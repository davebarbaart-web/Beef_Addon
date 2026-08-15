ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Phase 1 fail-closed authority stub. Phase 4 owns registered-Pope / Council.
-- OPEN_QUESTIONS #8 is direction only — do not invent that module or a config UX.
local Officer = {}
COB.Officer = Officer

function Officer:IsOfficerIndex(_rankIndex)
  return false
end

function Officer:IsOfficerName(_name, _rosterLookup)
  return false
end

function Officer:LocalIsOfficer()
  return false
end

-- Roster names and BeefNet sender names disagree about realm suffixes and case:
-- the roster may say "Beefina-Whitemane" where CHAT_MSG_ADDON says "Beefina".
local function rosterKey(name)
  return COB.Names and COB.Names.Key(name) or nil
end

-- Roster membership, not authority. Fails closed while the roster is unread.
-- Roster entries may carry a realm suffix; match on the character part either way.
function Officer:IsGuildRosterName(name)
  if COB.Roster and COB.Roster.IsReady and COB.Roster:IsReady() and COB.Roster.HasMember then
    return COB.Roster:HasMember(name)
  end
  if type(name) ~= "string" or name == "" then return false end
  if type(GetNumGuildMembers) ~= "function" or type(GetGuildRosterInfo) ~= "function" then
    return false
  end

  local wanted = rosterKey(name)
  if not wanted then return false end
  local count = GetNumGuildMembers()
  if type(count) ~= "number" then return false end

  for i = 1, count do
    local rosterName = GetGuildRosterInfo(i)
    if rosterKey(rosterName) == wanted then return true end
  end
  return false
end

--------------------------------------------------------------------------------
-- Roster cache for BeefNet sender checks (membership / display-rank sensing)
--------------------------------------------------------------------------------

-- Snapshot the guild's rank indices once per GUILD_ROSTER_UPDATE. BeefNet still
-- asks. A burst must not walk the whole guild per message, and the client ignores
-- GuildRoster() requests made less than ten seconds apart anyway.
--
-- An empty or unreadable roster clears the cache rather than caching an empty
-- guild: a login race must leave callers unsure, not confidently wrong.
-- Prefer Core/Roster as the single guild walk; fall back to a local cache if
-- Roster is not loaded yet (TOC order / desktop suites that only dofile Officer).
function Officer:RefreshRosterCache()
  if COB.Roster and COB.Roster.Refresh then
    return COB.Roster:Refresh()
  end

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

-- Returns lookup(name) -> rankIndex|nil. Membership / display-rank sensing for
-- BeefNet roster readiness. Not an authority gate.
-- Reads self.rosterCache at call time, not at closure time: Roster:Refresh replaces
-- that table wholesale, and a lookup captured before a refresh would keep answering
-- from the old snapshot.
function Officer:GetRosterLookup()
  if not self.rosterCache then self:RefreshRosterCache() end
  local officer = self
  return function(name)
    local cache = officer.rosterCache
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
