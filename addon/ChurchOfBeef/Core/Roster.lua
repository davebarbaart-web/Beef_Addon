ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Live guild roster snapshot. Guild rankIndex and guildRankName are public
-- display only (Bible §5). ChurchRankIdForGuildIndex is a nil stub — members
-- are still kept so Presence can leave roster_wait. Church rank is not
-- invented here. A matching rank name is display in UI via Ranks.IdForTitle.
--
-- Prefers LibGuildRoster-1.0 when present (common with FastGuildInvite /
-- GuildRoster installs), otherwise walks GetGuildRosterInfo directly. Always
-- seeds the local player from GetGuildInfo so /beef is not empty while the
-- full roster is still streaming in.
local Roster = {
  ready = false,
  -- ready means "we have something to show" (the local player alone counts).
  -- complete means "a full guild walk answered", which is the only state where
  -- "this name is not in the guild" is a safe conclusion.
  complete = false,
  members = {}, -- key → { name, guildRankIndex, guildRankName, churchRankId, classFile? }
  generation = 0,
  _libWired = false,
  _onChanged = nil,
}
COB.Roster = Roster

local function rosterKey(name)
  return COB.Names and COB.Names.Key(name) or nil
end

-- Pure static (dot-call): the shared identity law, re-exported here because UI and
-- Net were written against Roster.NameKey.
function Roster.NameKey(name)
  return rosterKey(name)
end

local function displayName(rosterName)
  return COB.Names and COB.Names.Display(rosterName) or nil
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
  self.complete = false
  self.members = {}
  self.generation = (self.generation or 0) + 1
  clearOfficerCache()
end

local function applySnapshot(self, members, officerCache, seen, complete)
  if seen == 0 then return false end
  self.members = members
  self.ready = true
  self.complete = complete and true or false
  self.generation = (self.generation or 0) + 1
  if COB.Officer then COB.Officer.rosterCache = officerCache end
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

  local guildName, rankName, rankIndex = GetGuildInfo("player")
  rankIndex = tonumber(rankIndex)
  if type(guildName) ~= "string" or guildName == "" or not rankIndex then return seen end
  if type(rankName) ~= "string" or rankName == "" then rankName = nil end

  local ranks = COB.Ranks
  local churchRankId = ranks and ranks.ChurchRankIdForGuildIndex and ranks.ChurchRankIdForGuildIndex(rankIndex) or nil

  members[key] = {
    name = shown,
    guildRankIndex = rankIndex,
    guildRankName = rankName,
    churchRankId = churchRankId,
  }
  officerCache[key] = rankIndex
  return seen + 1
end

local function buildFromLib(lib)
  if not (lib and lib.IsReady and lib:IsReady()) then return nil, nil, 0 end
  if not (lib.GetAllMembers and lib.GetMember) then return nil, nil, 0 end

  local ranks = COB.Ranks
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
        local churchRankId = ranks and ranks.ChurchRankIdForGuildIndex and ranks.ChurchRankIdForGuildIndex(rankIndex) or nil
        local classFile = member.classFile or member.class
        if type(classFile) ~= "string" then classFile = nil end
        local rankName = member.rankName or member.rank
        if type(rankName) ~= "string" or rankName == "" then rankName = nil end
        members[key] = {
          name = shown,
          guildRankIndex = rankIndex,
          guildRankName = rankName,
          churchRankId = churchRankId,
          classFile = classFile,
        }
        officerCache[key] = rankIndex
        seen = seen + 1
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
  local members, officerCache, seen = {}, {}, 0
  for i = 1, count do
    local rosterName, rankName, rankIndex, _, _, _, _, _, _, _, classFile = GetGuildRosterInfo(i)
    rankIndex = tonumber(rankIndex)
    local key = rosterKey(rosterName)
    local shown = displayName(rosterName)
    if key and shown and rankIndex then
      local churchRankId = ranks and ranks.ChurchRankIdForGuildIndex and ranks.ChurchRankIdForGuildIndex(rankIndex) or nil
      if type(classFile) ~= "string" then classFile = nil end
      if type(rankName) ~= "string" or rankName == "" then rankName = nil end
      members[key] = {
        name = shown,
        guildRankIndex = rankIndex,
        guildRankName = rankName,
        churchRankId = churchRankId,
        classFile = classFile,
      }
      officerCache[key] = rankIndex
      seen = seen + 1
    end
  end
  return members, officerCache, seen
end

function Roster:IsReady()
  return self.ready == true
end

-- True only when a full guild walk answered. Callers that turn "not in members"
-- into a refusal (petition imports, membership checks) must ask this instead of
-- IsReady, or they spend the login window rejecting real guildmates because the
-- only name we had was the player's own seed.
function Roster:IsComplete()
  return self.ready == true and self.complete == true
end

function Roster:GetGeneration()
  return self.generation or 0
end

-- How many names the current snapshot holds. Derived, not a running total:
-- `members` is replaced wholesale by each snapshot, so a stored count would
-- be one missed update away from lying. A counting walk allocates nothing.
function Roster:GetOccupantCount()
  if not self.ready then return 0 end
  local count = 0
  for _ in pairs(self.members) do count = count + 1 end
  return count
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

function Roster:GetGuildRankName(name)
  local key = rosterKey(name)
  if not key or not self.ready then return nil end
  local entry = self.members[key]
  return entry and entry.guildRankName or nil
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

  -- Counted before the seed: one member who happens to be you is not a guild walk.
  local walked = seen > 0
  seen = seedLocalPlayer(members, officerCache, seen)

  if applySnapshot(self, members, officerCache, seen, walked) then
    return true
  end

  return self.ready
end

function Roster:ResetForTests()
  if not COB._IN_TEST then return false end
  self.ready = false
  self.complete = false
  self.members = {}
  self.generation = 0
  self._libWired = false
  self._onChanged = nil
  return true
end
