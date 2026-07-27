ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Live guild roster snapshot → Church ladder view. Ranks are never written to
-- SavedVariables; standing still lives on Ladder. UI reads GetLadderView here.
--
-- Prefers LibGuildRoster-1.0 when present (common with FastGuildInvite /
-- GuildRoster installs), otherwise walks GetGuildRosterInfo directly. Always
-- seeds the local player from GetGuildInfo so /beef is not empty while the
-- full roster is still streaming in.
local Roster = {
  ready = false,
  members = {}, -- key → { name, guildRankIndex, churchRankId }
  _libWired = false,
  _onChanged = nil,
}
COB.Roster = Roster

local function rosterKey(name)
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", ""):lower()
  if name == "" then return nil end
  return name:match("^([^%-]+)") or name
end

local function displayName(rosterName)
  if type(rosterName) ~= "string" then return nil end
  local trimmed = rosterName:gsub("^%s+", ""):gsub("%s+$", "")
  if trimmed == "" then return nil end
  return trimmed:match("^([^%-]+)") or trimmed
end

local function inGuild()
  if type(IsInGuild) == "function" then
    return IsInGuild() and true or false
  end
  return true
end

local function guildLib()
  if type(LibStub) ~= "function" then return nil end
  local lib = LibStub("LibGuildRoster-1.0", true)
  if type(lib) == "table" then return lib end
  return nil
end

local function clearOfficerCache()
  if COB.Officer then COB.Officer.rosterCache = nil end
end

local function clearSnapshot(self)
  self.ready = false
  self.members = {}
  clearOfficerCache()
end

local function applySnapshot(self, members, officerCache, seen)
  if seen == 0 then return false end
  self.members = members
  self.ready = true
  if COB.Officer then COB.Officer.rosterCache = officerCache end
  self:ClearSatisfiedSuggestions()
  return true
end

-- Local player from GetGuildInfo — available earlier than the full roster walk.
local function seedLocalPlayer(members, officerCache, seen)
  if type(UnitName) ~= "function" or type(GetGuildInfo) ~= "function" then
    return seen
  end
  local name = UnitName("player")
  local shown = displayName(name)
  local key = rosterKey(name)
  if not key or not shown then return seen end
  if members[key] then return seen end

  local guildName, _, rankIndex = GetGuildInfo("player")
  rankIndex = tonumber(rankIndex)
  if type(guildName) ~= "string" or guildName == "" or not rankIndex then return seen end

  local ranks = COB.Ranks
  if not (ranks and ranks.ChurchRankIdForGuildIndex) then return seen end
  local churchRankId = ranks.ChurchRankIdForGuildIndex(rankIndex)
  if not churchRankId then return seen end

  members[key] = {
    name = shown,
    guildRankIndex = rankIndex,
    churchRankId = churchRankId,
  }
  officerCache[key] = rankIndex
  return seen + 1
end

local function buildFromLib(lib)
  if not (lib and lib.IsReady and lib:IsReady()) then return nil, nil, 0 end
  if not (lib.GetAllMembers and lib.GetMember) then return nil, nil, 0 end

  local ranks = COB.Ranks
  if not (ranks and ranks.ChurchRankIdForGuildIndex) then return nil, nil, 0 end

  local names = lib:GetAllMembers()
  if type(names) ~= "table" then return nil, nil, 0 end

  local members, officerCache, seen = {}, {}, 0
  for i = 1, #names do
    local member = lib:GetMember(names[i])
    if type(member) == "table" then
      local rankIndex = tonumber(member.rankIndex)
      local shown = displayName(member.name or names[i])
      local key = rosterKey(shown)
      if key and shown and rankIndex then
        local churchRankId = ranks.ChurchRankIdForGuildIndex(rankIndex)
        if churchRankId then
          members[key] = {
            name = shown,
            guildRankIndex = rankIndex,
            churchRankId = churchRankId,
          }
          officerCache[key] = rankIndex
          seen = seen + 1
        end
      end
    end
  end
  return members, officerCache, seen
end

local function buildFromApi()
  if type(GetNumGuildMembers) ~= "function" or type(GetGuildRosterInfo) ~= "function" then
    return nil, nil, 0
  end

  local count = GetNumGuildMembers()
  if type(count) ~= "number" or count < 1 then return nil, nil, 0 end

  local ranks = COB.Ranks
  if not (ranks and ranks.ChurchRankIdForGuildIndex) then return nil, nil, 0 end

  local members, officerCache, seen = {}, {}, 0
  for i = 1, count do
    local rosterName, _, rankIndex = GetGuildRosterInfo(i)
    rankIndex = tonumber(rankIndex)
    local key = rosterKey(rosterName)
    local shown = displayName(rosterName)
    if key and shown and rankIndex then
      local churchRankId = ranks.ChurchRankIdForGuildIndex(rankIndex)
      if churchRankId then
        members[key] = {
          name = shown,
          guildRankIndex = rankIndex,
          churchRankId = churchRankId,
        }
        officerCache[key] = rankIndex
        seen = seen + 1
      end
    end
  end
  return members, officerCache, seen
end

function Roster:IsReady()
  return self.ready == true
end

function Roster:GetChurchRankId(name)
  local key = rosterKey(name)
  if not key or not self.ready then return nil end
  local entry = self.members[key]
  return entry and entry.churchRankId or nil
end

function Roster:GetGuildRankIndex(name)
  local key = rosterKey(name)
  if not key or not self.ready then return nil end
  local entry = self.members[key]
  return entry and entry.guildRankIndex or nil
end

function Roster:HasMember(name)
  local key = rosterKey(name)
  if not key or not self.ready then return false end
  return self.members[key] ~= nil
end

-- Optional notify when the snapshot changes (wired by Net/UI — Core does not CreateFrame).
function Roster:SetOnChanged(fn)
  self._onChanged = type(fn) == "function" and fn or nil
end

function Roster:_NotifyChanged()
  local fn = self._onChanged
  if fn then fn() end
end

-- Soft-wire LibGuildRoster callbacks when the library is loaded.
function Roster:AttachLibrary()
  if self._libWired then return true end
  local lib = guildLib()
  if not lib or type(lib.RegisterCallback) ~= "function" then return false end

  lib.RegisterCallback(self, "OnRosterReady", "OnLibraryRosterEvent")
  lib.RegisterCallback(self, "OnRosterUpdated", "OnLibraryRosterEvent")
  self._libWired = true
  return true
end

function Roster:OnLibraryRosterEvent()
  if self:Refresh() then self:_NotifyChanged() end
end

-- Rebuild from LibGuildRoster, else GetGuildRosterInfo, else local GetGuildInfo seed.
-- A failed/empty full walk does NOT wipe a good prior snapshot while still guilded.
function Roster:Refresh()
  if not inGuild() then
    clearSnapshot(self)
    return false
  end

  local members, officerCache, seen = buildFromLib(guildLib())
  if not members then
    members, officerCache, seen = buildFromApi()
  end
  if not members then
    members, officerCache, seen = {}, {}, 0
  end

  seen = seedLocalPlayer(members, officerCache, seen)

  if applySnapshot(self, members, officerCache, seen) then
    return true
  end

  return self.ready
end

function Roster:ClearSatisfiedSuggestions()
  local ladder = COB.Ladder
  if not (ladder and ladder.GetSuggestions and ladder.RejectSuggestion) then return 0 end
  if not self.ready then return 0 end

  local cleared = 0
  local list = ladder:GetSuggestions()
  for i = 1, #list do
    local suggestion = list[i]
    local churchRankId = self:GetChurchRankId(suggestion.name)
    if churchRankId and churchRankId >= (suggestion.toRankId or 0) then
      if ladder:RejectSuggestion(suggestion.name) then cleared = cleared + 1 end
    end
  end
  return cleared
end

function Roster:GetLadderView()
  local out = {}
  if not self.ready then return out end

  local ladder = COB.Ladder
  for _, entry in pairs(self.members) do
    local standing = 0
    if ladder and ladder.GetStanding then
      standing = ladder:GetStanding(entry.name) or 0
    elseif ladder and ladder.GetRecord then
      local rec = ladder:GetRecord(entry.name)
      standing = rec and rec.standing or 0
    end
    out[#out + 1] = {
      name = entry.name,
      rankId = entry.churchRankId,
      standing = standing,
      revision = 0,
      updatedAt = 0,
      updatedBy = "",
    }
  end

  table.sort(out, function(a, b)
    if a.rankId ~= b.rankId then return a.rankId > b.rankId end
    return a.name < b.name
  end)
  return out
end

function Roster:ResetForTests()
  if not COB._IN_TEST then return false end
  self.ready = false
  self.members = {}
  self._libWired = false
  self._onChanged = nil
  return true
end
