ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Standing grants and their daily ceilings. Every point a member earns passes through
-- Grant, so the caps and the anti-AFK rule have exactly one place to be enforced.
-- Points here are advisory testimony only: they never promote anyone, they only feed
-- Ladder:MaybeSuggest so an officer has something to approve.
local Scoring = {
  Points = {
    InstanceBucket = 5,
    InstanceComplete = 20,
    Ceremony = 40,
    GoraWin = 25,
    GoraDraw = 10,
    GoraLoss = 8,
  },
  -- One cap per source, not per grant type: dungeon buckets and the completion bonus
  -- share the instance budget so finishing runs back-to-back cannot outrun the drip cap.
  DailyCaps = {
    instance = 60,
    ceremony = 80,
    gora = 100,
  },
  Sources = {
    Instance = "instance",
    Ceremony = "ceremony",
    Gora = "gora",
  },
  dayKey = "",
  granted = {},
  history = {},
}
COB.Scoring = Scoring

local HistoryMax = 20

local GORA_POINT_KEY = {
  win = "GoraWin",
  draw = "GoraDraw",
  loss = "GoraLoss",
}

local function normalizeName(name)
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" then return nil end
  return name
end

local function resolveTime(now)
  if type(now) == "number" then return now end
  if type(time) == "function" then return time() end
  return 0
end

-- Daily caps bound how often a paid grant can happen, so flushing standing and the
-- spent tally on each one keeps a crash from refunding cap or erasing an evening's
-- points. Refused grants (zero payout) never touch SavedVariables.
local function persist()
  if COB.DB and COB.DB.Save then COB.DB:Save() end
end

-- WoW exposes date() as a global; the desktop harness stubs it onto os.date.
local function dayString(at)
  if type(date) == "function" then return date("%Y-%m-%d", at) end
  if type(os) == "table" and type(os.date) == "function" then return os.date("%Y-%m-%d", at) end
  return "day"
end

function Scoring:GetDayKey(now)
  return dayString(resolveTime(now))
end

-- Only the current day's tallies are kept: yesterday's numbers can never restore a cap,
-- and the table cannot grow without bound across a long session.
--
-- Rollover is one-way. Day keys are "%Y-%m-%d", so a plain string compare is a date
-- compare, and only a *later* key clears the tallies. A backwards timestamp — a
-- system clock correction, a stale queued grant — is then charged against today's
-- cap instead of wiping it, which is the safe direction to be wrong in.
function Scoring:_rollover(dayKey)
  if self.dayKey ~= dayKey and dayKey > self.dayKey then
    self.dayKey = dayKey
    self.granted = {}
  end
end

function Scoring:_remember(name, source, amount, at)
  local log = self.history[name]
  if not log then
    log = {}
    self.history[name] = log
  end
  table.insert(log, 1, { source = source, amount = amount, at = at })
  -- Newest first, so trimming the tail drops the oldest entry.
  while #log > HistoryMax do table.remove(log) end
end

-- How much of a source's daily cap a member has already spent today. Reads never roll
-- the day over: a query about a different day must not be able to clear today's tally.
function Scoring:GetGranted(name, source, now)
  local key = normalizeName(name)
  if not key then return 0 end
  if self.dayKey ~= self:GetDayKey(now) then return 0 end
  local perName = self.granted[key]
  if not perName then return 0 end
  return perName[source] or 0
end

function Scoring:GetRemaining(name, source, now)
  local cap = self.DailyCaps[source]
  if not cap then return 0 end
  local remaining = cap - self:GetGranted(name, source, now)
  if remaining < 0 then return 0 end
  return remaining
end

-- The single point-granting path. Returns how much was actually paid after clamping to
-- the source's remaining daily cap, plus an error string when the request was malformed.
-- A grant of 0 because the cap is spent is a normal outcome, not an error.
function Scoring:Grant(name, source, amount, now)
  local key = normalizeName(name)
  if not key then return 0, "invalid name" end

  local cap = self.DailyCaps[source]
  if not cap then return 0, "unknown scoring source" end
  if type(amount) ~= "number" or amount <= 0 then
    return 0, "amount must be a positive number"
  end

  local ladder = COB.Ladder
  if not ladder then return 0, "ladder unavailable" end

  local at = resolveTime(now)
  self:_rollover(self:GetDayKey(at))

  local perName = self.granted[key]
  local used = perName and perName[source] or 0
  local remaining = cap - used
  if remaining <= 0 then return 0 end

  local payout = amount
  if payout > remaining then payout = remaining end

  if not perName then
    perName = {}
    self.granted[key] = perName
  end
  perName[source] = used + payout

  local record = ladder:GetRecord(key)
  local standing = record and record.standing or 0
  ladder:SetStanding(key, standing + payout)
  -- Suggest, never promote: crossing a threshold only queues officer work.
  local suggestion, isNew = ladder:MaybeSuggest(key)

  self:_remember(key, source, payout, at)
  persist()

  -- A petition nobody hears about is no petition at all: the officers who can act on
  -- it are usually on other clients. Net owns what that means on the wire and on
  -- screen, so Core neither sends nor draws. Fires once, on the crossing itself.
  if isNew and suggestion then
    local net = COB.Net
    if net and net.OnLocalSuggestion then net:OnLocalSuggestion(suggestion) end
  end

  return payout
end

-- Anti-AFK: a time bucket the player never fought in pays nothing and spends no cap,
-- so parking at a dungeon entrance next to a guildmate earns exactly zero.
function Scoring:GrantInstanceBucket(name, now, inCombat)
  if not inCombat then return 0 end
  return self:Grant(name, self.Sources.Instance, self.Points.InstanceBucket, now)
end

function Scoring:GrantInstanceComplete(name, now)
  return self:Grant(name, self.Sources.Instance, self.Points.InstanceComplete, now)
end

-- Losses pay: if showing up for a Gora and losing earned nothing, members would dodge
-- challenges and the competition would die.
function Scoring:GrantGora(name, outcome, now)
  if type(outcome) ~= "string" then return 0, "unknown gora outcome" end
  local pointKey = GORA_POINT_KEY[outcome:lower()]
  if not pointKey then return 0, "unknown gora outcome" end
  return self:Grant(name, self.Sources.Gora, self.Points[pointKey], now)
end

function Scoring:GrantCeremony(name, now)
  return self:Grant(name, self.Sources.Ceremony, self.Points.Ceremony, now)
end

-- Newest first, copies only. Feeds the My Standing tab's recent-events list.
function Scoring:GetHistory(name)
  local out = {}
  local key = normalizeName(name)
  if not key then return out end
  local log = self.history[key]
  if not log then return out end
  for i = 1, #log do
    out[i] = { source = log[i].source, amount = log[i].amount, at = log[i].at }
  end
  return out
end

-- Caps must survive a /reload, or logging out would hand back a spent daily budget.
-- Shape matches the ChurchOfBeefDB.scoring blob: granted[dayKey][name][source] = amount.
function Scoring:ExportState()
  local perDay = {}
  for name, sources in pairs(self.granted) do
    local copy = {}
    for source, amount in pairs(sources) do copy[source] = amount end
    perDay[name] = copy
  end
  return { dayKey = self.dayKey, granted = { [self.dayKey] = perDay } }
end

-- A snapshot from an earlier day is deliberately discarded rather than replayed:
-- the point of the cap is that a new day starts clean.
function Scoring:ImportState(state, now)
  -- A missing SavedVariables blob is a caller passing nil, not an instruction to
  -- refund everyone's daily cap, so validate before touching live tallies.
  if type(state) ~= "table" then return 0 end

  self.granted = {}
  self.dayKey = self:GetDayKey(now)
  if state.dayKey ~= self.dayKey then return 0 end
  if type(state.granted) ~= "table" then return 0 end

  local perDay = state.granted[self.dayKey]
  if type(perDay) ~= "table" then return 0 end

  local restored = 0
  for name, sources in pairs(perDay) do
    local key = normalizeName(name)
    if key and type(sources) == "table" then
      local copy = {}
      for source, amount in pairs(sources) do
        if self.DailyCaps[source] and type(amount) == "number" and amount > 0 then
          copy[source] = amount
        end
      end
      if next(copy) then
        self.granted[key] = copy
        restored = restored + 1
      end
    end
  end

  return restored
end

-- Test-only. Gated so a stray call in game cannot refund every member's daily cap.
function Scoring:ResetForTests()
  if not COB._IN_TEST then return false end
  self.dayKey = ""
  self.granted = {}
  self.history = {}
  return true
end
