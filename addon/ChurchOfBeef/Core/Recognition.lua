ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Rite of Recognition session (Bible §12.2). Pope or Council confirms with a
-- logged-in character id passed in — no UnitName widget, no self-service, no
-- silent same-account / BattleNet bind. Complete writes the Pope store (Law 5)
-- even when Council confirms. Duration is session metadata, not a UI timer.
local Recognition = {}
COB.Recognition = Recognition

local DEFAULT_DURATION = 30
local session = nil

local CONFIRMERS = {
  pope = true,
  council = true,
}

local function wall(now)
  if COB.Clock and COB.Clock.Wall then return COB.Clock.Wall(now) end
  if type(now) == "number" then return now end
  return 0
end

local function isId(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function roleOf(role)
  if type(role) ~= "string" then return nil end
  role = role:gsub("^%s+", ""):gsub("%s+$", ""):lower()
  if CONFIRMERS[role] then return role end
  return nil
end

local function durationOf(value)
  if value == nil then return DEFAULT_DURATION end
  if type(value) ~= "number" or value ~= value or value <= 0 then return nil end
  return value
end

local function readClock(now)
  local duration
  if type(now) == "table" then
    duration = now.duration
    now = now.now
  end
  return wall(now), durationOf(duration)
end

local function copySession()
  if not session then return nil end
  return deepcopy(session)
end

function Recognition:ResetForTests()
  if not COB._IN_TEST then return false end
  session = nil
  return true
end

function Recognition:GetSession()
  return copySession()
end

function Recognition:IsExpired(now)
  if not session then return false end
  return wall(now) >= session.startedAt + session.duration
end

function Recognition:Begin(humanId, characterId, confirmerRole, now)
  if session then return nil, "a rite is already open" end
  local role = roleOf(confirmerRole)
  if not role then return nil, "confirmer must be pope or council" end
  if characterId == nil then return nil, "logged-in character id required" end
  if not isId(characterId) then return nil, "invalid character id" end
  if not isId(humanId) then return nil, "invalid human id" end

  local Store = COB.Store
  if not Store then return nil, "store is not available" end
  local human, humanErr = Store:GetHuman(humanId)
  if not human then return nil, humanErr or "unknown human" end
  local ch, chErr = Store:GetCharacter(characterId)
  if not ch then return nil, chErr or "unknown character" end
  if ch.humanId ~= nil and ch.humanId ~= humanId then
    return nil, "character is already bound to a different human"
  end

  local at, duration = readClock(now)
  if not duration then return nil, "duration must be a positive number" end

  session = {
    humanId = humanId,
    characterId = characterId,
    confirmerRole = role,
    startedAt = at,
    duration = duration,
    relink = ch.humanId == humanId,
  }
  return copySession()
end

function Recognition:Complete(now)
  if not session then return nil, "no open rite" end
  local Store = COB.Store
  if not Store or not Store.LinkCharacter then return nil, "store is not available" end

  local humanId = session.humanId
  local characterId = session.characterId
  local linked, err = Store:LinkCharacter(characterId, humanId, now)
  if not linked then return nil, err end

  if Store.AppendCeremony then
    Store:AppendCeremony("Recognition", { characterId, humanId }, now)
  end
  session = nil
  return linked
end

function Recognition:Cancel()
  if not session then return nil, "no open rite" end
  session = nil
  return true
end
