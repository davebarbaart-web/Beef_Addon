ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Thin ceremony ledger (spec §7.1): an officer starts a ceremony, attendees are
-- credited when it closes cleanly. Nothing here draws, chats, or promotes — the
-- flat grant leaves through Scoring:GrantCeremony so the daily ceremony cap
-- keeps applying.
--
-- The active ceremony is deliberately session-only. Spec §11 says a disconnect
-- mid-ceremony earns no credit until an officer closes cleanly, so losing the
-- ceremony to a /reload is the specified behaviour, not a gap.
local Ceremony = {
  active = nil,
}
COB.Ceremony = Ceremony

local DEFAULT_LABEL = "Ceremony"
local LABEL_MAX = 60

local function normalizeName(name)
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" then return nil end
  return name
end

local function normalizeLabel(label)
  local text = normalizeName(label)
  if not text then return DEFAULT_LABEL end
  if #text > LABEL_MAX then text = text:sub(1, LABEL_MAX) end
  return text
end

local function resolveTime(now)
  if type(now) == "number" then return now end
  if type(time) == "function" then return time() end
  return 0
end

-- Core/Officer.lua stays the only officer gate; this is a call into it, not a
-- second implementation of the rank-index rule.
local function localIsOfficer()
  local officer = COB.Officer
  if not (officer and officer.LocalIsOfficer) then return false end
  return officer:LocalIsOfficer() and true or false
end

local function unitEntry(unit)
  if type(UnitName) ~= "function" then return nil end
  local name = UnitName(unit)
  if type(name) ~= "string" or name == "" then return nil end

  local inGuild = true
  if type(UnitIsInMyGuild) == "function" then
    inGuild = UnitIsInMyGuild(unit) and true or false
  end
  local afk = false
  if type(UnitIsAFK) == "function" then
    afk = UnitIsAFK(unit) and true or false
  end
  return { name = name, inGuild = inGuild, afk = afk }
end

-- Party or raid plus the officiant. Raid unit ids include the player, so the
-- caller-side dedupe is what stops the officiant being sampled twice.
local function liveRoster()
  local out, seen = {}, {}
  local function add(unit)
    local entry = unitEntry(unit)
    if entry and not seen[entry.name] then
      seen[entry.name] = true
      out[#out + 1] = entry
    end
  end

  add("player")

  local size = 0
  if type(GetNumGroupMembers) == "function" then
    size = tonumber(GetNumGroupMembers()) or 0
  end
  local inRaid = type(IsInRaid) == "function" and IsInRaid() and true or false
  local prefix = inRaid and "raid" or "party"
  for i = 1, size do add(prefix .. i) end

  return out
end

-- roster may be nil (sample the live group), a function returning a list, or a
-- list of names / { name, inGuild, afk } tables. Tests inject; the client does not.
local function sampleRoster(roster)
  if type(roster) == "function" then roster = roster() end
  if roster == nil then roster = liveRoster() end
  if type(roster) ~= "table" then return {} end

  local out, seen = {}, {}
  for i = 1, #roster do
    local entry = roster[i]
    if type(entry) == "string" then entry = { name = entry } end
    if type(entry) == "table" then
      local name = normalizeName(entry.name)
      -- Non-guildmates never earn church standing, and an AFK flag at the
      -- moment of sampling is the ceremony's answer to standing in the back.
      if name and entry.inGuild ~= false and not entry.afk and not seen[name] then
        seen[name] = true
        out[#out + 1] = name
      end
    end
  end
  return out
end

function Ceremony:IsActive()
  return self.active ~= nil
end

-- Copy: the live attendance set never leaves this module.
function Ceremony:GetActive()
  local active = self.active
  if not active then return nil end
  local tracked = {}
  for name in pairs(active.seen) do tracked[#tracked + 1] = name end
  table.sort(tracked)
  return { label = active.label, startedAt = active.startedAt, tracked = tracked }
end

function Ceremony:Start(label, roster, now)
  if self.active then return nil, "a ceremony is already under way" end
  if not localIsOfficer() then return nil, "only an officer may start a ceremony" end

  local at = resolveTime(now)
  local present = sampleRoster(roster)
  local seen = {}
  for i = 1, #present do seen[present[i]] = at end

  self.active = { label = normalizeLabel(label), startedAt = at, seen = seen }
  return self:GetActive()
end

-- Fold another sample into the tracked set. Not wired to a roster event yet:
-- Task 11 owns group-event plumbing and can verify the Anniversary event name
-- before anything registers it.
function Ceremony:Mark(roster, now)
  local active = self.active
  if not active then return 0 end
  local at = resolveTime(now)
  local present = sampleRoster(roster)
  local added = 0
  for i = 1, #present do
    local name = present[i]
    if not active.seen[name] then added = added + 1 end
    active.seen[name] = at
  end
  return added
end

-- Credit needs both halves: tracked since Start *and* still present at close.
-- Someone who logged out mid-rite is not present; someone who wandered in for
-- the closing second was never tracked. Neither is paid.
function Ceremony:Close(roster, now)
  local active = self.active
  if not active then return nil, "no ceremony is under way" end
  if not localIsOfficer() then return nil, "only an officer may close a ceremony" end

  local at = resolveTime(now)
  local present = sampleRoster(roster)
  local scoring = COB.Scoring

  local attendees, latecomers, total = {}, 0, 0
  for i = 1, #present do
    local name = present[i]
    if active.seen[name] then
      local paid = 0
      if scoring and scoring.GrantCeremony then
        paid = scoring:GrantCeremony(name, now) or 0
      end
      total = total + paid
      attendees[#attendees + 1] = { name = name, points = paid }
    else
      latecomers = latecomers + 1
    end
  end

  self.active = nil
  return {
    label = active.label,
    startedAt = active.startedAt,
    closedAt = at,
    attendees = attendees,
    latecomers = latecomers,
    total = total,
  }
end

-- Ungated on purpose: abandoning a ceremony pays nobody, and an officer who
-- lost their rank mid-rite must still be able to clear the stuck state.
function Ceremony:Cancel()
  if not self.active then return false end
  self.active = nil
  return true
end

function Ceremony:ResetForTests()
  if not COB._IN_TEST then return false end
  self.active = nil
  return true
end
