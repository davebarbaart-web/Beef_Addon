ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Sole authority for Officer+ checks: guild roster rank index vs canon max.
-- Never gate on rank-name strings, invite rights, or opaque IsGuildOfficer helpers.
local Officer = {}
COB.Officer = Officer

function Officer:IsOfficerIndex(rankIndex)
  if type(rankIndex) ~= "number" then return false end
  local ranks = COB.Ranks
  if not ranks or type(ranks.OfficerRankIndexMax) ~= "number" then return false end
  return rankIndex <= ranks.OfficerRankIndexMax
end

-- Roster names and BeefNet sender names disagree about realm suffixes and case:
-- the roster may say "Beefina-Whitemane" where CHAT_MSG_ADDON says "Beefina".
-- One key shape for both sides is what stops that mismatch reading as "not an officer".
local function rosterKey(name)
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", ""):lower()
  if name == "" then return nil end
  return name:match("^([^%-]+)") or name
end

-- rosterLookup(name) -> rankIndex|nil is injected so desktop tests stay pure.
-- In game, wrap GetGuildRosterInfo after GuildRoster() / GUILD_ROSTER_UPDATE.
function Officer:IsOfficerName(name, rosterLookup)
  if type(name) ~= "string" or name == "" then return false end
  if type(rosterLookup) ~= "function" then return false end
  local rankIndex = rosterLookup(name)
  return self:IsOfficerIndex(rankIndex)
end

-- Roster membership, not authority: rites need to know the subject is a real person
-- before they write a ladder record. Fails closed while the roster is unread, so a
-- rite during a login race is refused rather than aimed at a name nobody answers to.
-- Roster entries may carry a realm suffix; match on the character part either way.
function Officer:IsGuildRosterName(name)
  if type(name) ~= "string" or name == "" then return false end
  if type(GetNumGuildMembers) ~= "function" or type(GetGuildRosterInfo) ~= "function" then
    return false
  end

  local wanted = name:lower()
  local count = GetNumGuildMembers()
  if type(count) ~= "number" then return false end

  for i = 1, count do
    local rosterName = GetGuildRosterInfo(i)
    if type(rosterName) == "string" and rosterName ~= "" then
      rosterName = rosterName:lower()
      if rosterName == wanted or (rosterName:match("^([^%-]+)") or rosterName) == wanted then
        return true
      end
    end
  end
  return false
end

-- Live local player check. Fail closed until GetGuildInfo returns a rank index
-- (login / PLAYER_GUILD_UPDATE races leave it nil).
function Officer:LocalIsOfficer()
  if type(GetGuildInfo) ~= "function" then return false end
  local _, _, rankIndex = GetGuildInfo("player")
  return self:IsOfficerIndex(rankIndex)
end

--------------------------------------------------------------------------------
-- Roster cache for BeefNet sender checks
--------------------------------------------------------------------------------

-- Snapshot the guild's rank indices once per GUILD_ROSTER_UPDATE. A commit burst
-- must not walk the whole guild per message, and the client ignores GuildRoster()
-- requests made less than ten seconds apart anyway.
--
-- An empty or unreadable roster clears the cache rather than caching "nobody is an
-- officer": a login race must leave callers unsure, not confidently wrong.
function Officer:RefreshRosterCache()
  self.rosterCache = nil
  if type(GetNumGuildMembers) ~= "function" or type(GetGuildRosterInfo) ~= "function" then
    return false
  end

  local count = GetNumGuildMembers()
  if type(count) ~= "number" or count < 1 then return false end

  local cache, seen = {}, 0
  for i = 1, count do
    local rosterName, _, rankIndex = GetGuildRosterInfo(i)
    local key = rosterKey(rosterName)
    if key and type(rankIndex) == "number" then
      cache[key] = rankIndex
      seen = seen + 1
    end
  end
  if seen == 0 then return false end

  self.rosterCache = cache
  return true
end

function Officer:HasRosterCache()
  return self.rosterCache ~= nil
end

-- Returns lookup(name) -> rankIndex|nil for IsOfficerName. While the roster is
-- unread every name answers nil, so BeefNet holds commits instead of trusting them.
function Officer:GetRosterLookup()
  if not self.rosterCache then self:RefreshRosterCache() end
  local cache = self.rosterCache
  return function(name)
    if not cache then return nil end
    local key = rosterKey(name)
    if not key then return nil end
    return cache[key]
  end
end

function Officer:ResetForTests()
  if not COB._IN_TEST then return false end
  self.rosterCache = nil
  return true
end
