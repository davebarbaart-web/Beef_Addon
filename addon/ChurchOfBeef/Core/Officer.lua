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

-- rosterLookup(name) -> rankIndex|nil is injected so desktop tests stay pure.
-- In game, wrap GetGuildRosterInfo after GuildRoster() / GUILD_ROSTER_UPDATE.
function Officer:IsOfficerName(name, rosterLookup)
  if type(name) ~= "string" or name == "" then return false end
  if type(rosterLookup) ~= "function" then return false end
  local rankIndex = rosterLookup(name)
  return self:IsOfficerIndex(rankIndex)
end

-- Live local player check. Fail closed until GetGuildInfo returns a rank index
-- (login / PLAYER_GUILD_UPDATE races leave it nil).
function Officer:LocalIsOfficer()
  if type(GetGuildInfo) ~= "function" then return false end
  local _, _, rankIndex = GetGuildInfo("player")
  return self:IsOfficerIndex(rankIndex)
end
