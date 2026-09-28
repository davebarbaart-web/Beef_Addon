ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Pope-authoritative in-memory store (Bible §13.1). One writer: these APIs.
-- Humans own rank / Council / honorifics / membership history (§12.1).
-- Characters own the Gora record. Ids are store-local integers, never Names.Key.
-- Defenses are not stored (Design Lead §4). Archive / Recognition / SV are other lanes.
local Store = {}
COB.Store = Store

local LORD_ID = 4

local humans = {}
local characters = {}
local ceremonyLog = {}
local markedMoments = {}
local nextHumanId = 1
local nextCharacterId = 1
local nextCeremonyId = 1
local nextMomentId = 1

local RULINGS = {
  victor = true,
  cowardice = true,
  void = true,
  free = true,
}

local function wall(now)
  if COB.Clock and COB.Clock.Wall then return COB.Clock.Wall(now) end
  if type(now) == "number" then return now end
  return 0
end

local function trim(text)
  if COB.Names and COB.Names.Trim then return COB.Names.Trim(text) end
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function displayName(name)
  if COB.Names and COB.Names.Display then return COB.Names.Display(name) end
  return trim(name)
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

local function hasId(list, id)
  for i = 1, #list do
    if list[i] == id then return true end
  end
  return false
end

local function emptyGora()
  return {
    wins = 0,
    losses = 0,
    streak = 0,
    headToHeads = {},
    notableVictims = {},
    rulings = {},
    results = {},
  }
end

local function takeId(current)
  local id = current
  return id, id + 1
end

local function clear()
  humans = {}
  characters = {}
  ceremonyLog = {}
  markedMoments = {}
  nextHumanId = 1
  nextCharacterId = 1
  nextCeremonyId = 1
  nextMomentId = 1
end

local function knownRank(rankId)
  if rankId == nil then return true end
  if not isId(rankId) then return false end
  return COB.Ranks and COB.Ranks.ById and COB.Ranks.ById[rankId] ~= nil
end

local function h2hFor(gora, opponentId)
  local list = gora.headToHeads
  for i = 1, #list do
    if list[i].opponentId == opponentId then return list[i] end
  end
  local row = { opponentId = opponentId, wins = 0, losses = 0, fights = 0 }
  list[#list + 1] = row
  return row
end

local function sortById(list)
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  return list
end

local function listCopy(map)
  local list = {}
  for _, row in pairs(map) do
    list[#list + 1] = deepcopy(row)
  end
  return sortById(list)
end

local function bumpNext(nextId, map)
  local n = nextId
  if type(n) ~= "number" or n ~= math.floor(n) or n < 1 then n = 1 end
  for id, _ in pairs(map) do
    if type(id) == "number" and id >= n then n = id + 1 end
  end
  return n
end

local function bumpNextList(nextId, list)
  local n = nextId
  if type(n) ~= "number" or n ~= math.floor(n) or n < 1 then n = 1 end
  for i = 1, #list do
    local id = list[i] and list[i].id
    if type(id) == "number" and id >= n then n = id + 1 end
  end
  return n
end

local function loadRows(list, ensure)
  local map = {}
  if type(list) ~= "table" then return map end
  for i = 1, #list do
    local row = deepcopy(list[i])
    if type(row) == "table" and isId(row.id) then
      map[row.id] = ensure(row)
    end
  end
  return map
end

local function ensureHuman(row)
  if type(row.honorifics) ~= "table" then row.honorifics = {} end
  if type(row.history) ~= "table" then row.history = {} end
  if type(row.characterIds) ~= "table" then row.characterIds = {} end
  if row.council ~= true then row.council = false end
  if row.inactive ~= true then row.inactive = false end
  row.gora = nil
  return row
end

local function ensureCharacter(row)
  if type(row.professions) ~= "table" then row.professions = {} end
  if row.inactive ~= true then row.inactive = false end
  row.rankId = nil
  if type(row.gora) ~= "table" then row.gora = emptyGora() end
  if type(row.gora.headToHeads) ~= "table" then row.gora.headToHeads = {} end
  if type(row.gora.notableVictims) ~= "table" then row.gora.notableVictims = {} end
  if type(row.gora.rulings) ~= "table" then row.gora.rulings = {} end
  if type(row.gora.results) ~= "table" then row.gora.results = {} end
  if type(row.gora.wins) ~= "number" then row.gora.wins = 0 end
  if type(row.gora.losses) ~= "number" then row.gora.losses = 0 end
  if type(row.gora.streak) ~= "number" then row.gora.streak = 0 end
  row.gora.defenses = nil
  row.gora.defenseCount = nil
  return row
end

function Store:ResetForTests()
  if not COB._IN_TEST then return false end
  clear()
  return true
end

function Store:CreateHuman(fields, now)
  if type(fields) ~= "table" then fields = nil end
  local at = wall(now)
  local id
  id, nextHumanId = takeId(nextHumanId)
  local name = fields and trim(fields.name) or nil
  local row = {
    id = id,
    name = name,
    rankId = nil,
    council = false,
    honorifics = {},
    history = { { kind = "created", at = at } },
    inactive = false,
    elevationAt = nil,
    characterIds = {},
  }
  humans[id] = row
  return deepcopy(row)
end

function Store:GetHuman(id)
  if not isId(id) then return nil, "invalid human id" end
  local row = humans[id]
  if not row then return nil, "unknown human" end
  return deepcopy(row)
end

function Store:CreateCharacter(fields, now)
  if type(fields) ~= "table" then return nil, "character fields required" end
  local name = displayName(fields.name)
  if not name then return nil, "character name required" end
  if fields.class ~= nil and type(fields.class) ~= "string" then
    return nil, "class must be text"
  end
  if fields.level ~= nil and type(fields.level) ~= "number" then
    return nil, "level must be a number"
  end
  local professions = {}
  if fields.professions ~= nil then
    if type(fields.professions) ~= "table" then return nil, "professions must be a list" end
    for i = 1, #fields.professions do
      local p = fields.professions[i]
      if type(p) ~= "string" then return nil, "profession must be text" end
      professions[#professions + 1] = p
    end
  end
  local id
  id, nextCharacterId = takeId(nextCharacterId)
  local class = fields.class
  if type(class) == "string" then class = trim(class) end
  local row = {
    id = id,
    name = name,
    class = class,
    level = fields.level,
    professions = professions,
    humanId = nil,
    inactive = false,
    gora = emptyGora(),
  }
  characters[id] = row
  return deepcopy(row)
end

function Store:GetCharacter(id)
  if not isId(id) then return nil, "invalid character id" end
  local row = characters[id]
  if not row then return nil, "unknown character" end
  return deepcopy(row)
end

function Store:LinkCharacter(characterId, humanId, now)
  if not isId(characterId) then return nil, "invalid character id" end
  if not isId(humanId) then return nil, "invalid human id" end
  local ch = characters[characterId]
  if not ch then return nil, "unknown character" end
  local human = humans[humanId]
  if not human then return nil, "unknown human" end
  if ch.humanId ~= nil and ch.humanId ~= humanId then
    return nil, "character is already bound to a different human"
  end
  local at = wall(now)
  ch.humanId = humanId
  if not hasId(human.characterIds, characterId) then
    human.characterIds[#human.characterIds + 1] = characterId
  end
  human.history[#human.history + 1] = { kind = "linked", at = at, characterId = characterId }
  return deepcopy(ch)
end

function Store:RankForCharacter(characterId)
  if not isId(characterId) then return nil end
  local ch = characters[characterId]
  if not ch or not isId(ch.humanId) then return nil end
  local human = humans[ch.humanId]
  if not human then return nil end
  return human.rankId
end

-- The Pope Knighting or Sanctioning a targeted stranger IS the recognition
-- (Bible §4.4, §12.2: one action, Pope present, character logged in). Lookup is
-- over characters by Names.Key (realm-stripped, case-insensitive). A found +
-- linked row returns created=false. A found but unlinked row gets a fresh
-- human linked. An unknown name gets a fresh human + character + link. Never
-- merges into an existing human by name similarity: a new character always
-- gets a fresh human. No alt guessing. Character is created before the human
-- so a refused character leaves no orphan human row.
function Store:EnsureCharacterByName(fields, now)
  local rawName = fields
  local class, level
  if type(fields) == "table" then
    rawName = fields.name
    class = fields.class
    level = fields.level
  end
  local name = displayName(rawName)
  if not name then return nil, "invalid name" end

  local key = COB.Names and COB.Names.Key(name) or nil
  if key then
    local found
    for id, ch in pairs(characters) do
      if COB.Names.Key(ch.name) == key then
        if not found or id < found.id then
          found = ch
        end
      end
    end
    if found then
      if isId(found.humanId) and humans[found.humanId] then
        return found.id, found.humanId, false
      end
      local human = self:CreateHuman({ name = found.name }, now)
      local linked, linkErr = self:LinkCharacter(found.id, human.id, now)
      if not linked then return nil, linkErr end
      return found.id, human.id, true
    end
  end

  local ch, charErr = self:CreateCharacter({
    name = name,
    class = class,
    level = level,
  }, now)
  if not ch then return nil, charErr end
  local human = self:CreateHuman({ name = ch.name }, now)
  local linked, linkErr = self:LinkCharacter(ch.id, human.id, now)
  if not linked then return nil, linkErr end
  return ch.id, human.id, true
end

function Store:SetRank(humanId, rankId, now)
  if not isId(humanId) then return nil, "invalid human id" end
  local human = humans[humanId]
  if not human then return nil, "unknown human" end
  if not knownRank(rankId) then return nil, "unknown rank id" end
  human.rankId = rankId
  if rankId == LORD_ID and human.elevationAt == nil then
    human.elevationAt = wall(now)
  end
  return deepcopy(human)
end

function Store:SetCouncil(humanId, flag)
  if not isId(humanId) then return nil, "invalid human id" end
  local human = humans[humanId]
  if not human then return nil, "unknown human" end
  if type(flag) ~= "boolean" then return nil, "council flag must be boolean" end
  human.council = flag
  return deepcopy(human)
end

function Store:AddHonorific(humanId, text)
  if not isId(humanId) then return nil, "invalid human id" end
  local human = humans[humanId]
  if not human then return nil, "unknown human" end
  local title = trim(text)
  if not title then return nil, "honorific text required" end
  human.honorifics[#human.honorifics + 1] = title
  return deepcopy(human)
end

function Store:TombstoneHuman(humanId, now)
  if not isId(humanId) then return nil, "invalid human id" end
  local human = humans[humanId]
  if not human then return nil, "unknown human" end
  local at = wall(now)
  human.inactive = true
  human.history[#human.history + 1] = { kind = "inactive", at = at }
  return deepcopy(human)
end

function Store:TombstoneCharacter(characterId, now)
  if not isId(characterId) then return nil, "invalid character id" end
  local ch = characters[characterId]
  if not ch then return nil, "unknown character" end
  ch.inactive = true
  return deepcopy(ch)
end

function Store:AppendCeremony(entryType, participantIds, now, text, eventId)
  local kind = trim(entryType)
  if not kind then return nil, "ceremony type required" end
  local ids = {}
  if participantIds ~= nil then
    if type(participantIds) ~= "table" then return nil, "participant ids must be a list" end
    for i = 1, #participantIds do
      local id = participantIds[i]
      if not isId(id) then return nil, "participant ids must be store integers" end
      ids[#ids + 1] = id
    end
  end
  if text ~= nil then
    if type(text) ~= "string" then return nil, "text must be text" end
    text = trim(text)
  end
  if eventId ~= nil and not isId(eventId) then
    return nil, "invalid event id"
  end
  local id
  id, nextCeremonyId = takeId(nextCeremonyId)
  local entry = {
    id = id,
    type = kind,
    at = wall(now),
    participantIds = ids,
  }
  if text ~= nil then
    entry.text = text
  end
  if eventId ~= nil then
    entry.eventId = eventId
  end
  ceremonyLog[#ceremonyLog + 1] = entry
  return deepcopy(entry)
end

function Store:GetCeremonyLog()
  return deepcopy(ceremonyLog)
end

function Store:FlagMoment(location, now)
  if location ~= nil then
    if type(location) ~= "string" then return nil, "location must be text" end
    location = trim(location)
  end
  local id
  id, nextMomentId = takeId(nextMomentId)
  local row = {
    id = id,
    at = wall(now),
    location = location,
  }
  markedMoments[#markedMoments + 1] = row
  return deepcopy(row)
end

function Store:GetMarkedMoments()
  return deepcopy(markedMoments)
end

function Store:CanonizeMoment(momentId, text)
  if not isId(momentId) then return nil, "invalid moment id" end
  local row
  for i = 1, #markedMoments do
    if markedMoments[i].id == momentId then
      row = markedMoments[i]
      break
    end
  end
  if not row then return nil, "unknown moment" end
  if type(text) ~= "string" then return nil, "scripture text required" end
  if text:find("\n", 1, true) then return nil, "invalid text" end
  local scripture = trim(text)
  if not scripture then return nil, "scripture text required" end
  row.scripture = scripture
  return deepcopy(row)
end

function Store:FlagFamousUpset(characterId, opponentId)
  if not isId(characterId) then return nil, "invalid character id" end
  if not isId(opponentId) then return nil, "opponent must be a character id" end
  local ch = characters[characterId]
  if not ch then return nil, "unknown character" end
  local results = ch.gora and ch.gora.results
  if type(results) ~= "table" then return nil, "no matching victory" end
  for i = #results, 1, -1 do
    local result = results[i]
    if result and result.opponentId == opponentId and result.won == true then
      result.famousUpset = true
      return deepcopy(ch)
    end
  end
  return nil, "no matching victory"
end

function Store:RecordGoraResult(characterId, fields, now)
  if not isId(characterId) then return nil, "invalid character id" end
  local ch = characters[characterId]
  if not ch then return nil, "unknown character" end
  if type(fields) ~= "table" then return nil, "result fields required" end
  local ruling = fields.ruling
  if type(ruling) ~= "string" or not RULINGS[ruling] then
    return nil, "unknown ruling"
  end
  if not isId(fields.opponentId) then return nil, "opponent must be a character id" end
  if fields.opponentId == characterId then return nil, "a Gora needs two different combatants" end
  if not characters[fields.opponentId] then return nil, "unknown opponent" end
  local won = fields.won
  if ruling == "void" then
    won = nil
  elseif ruling == "free" then
    if won == true or won == false then
      return nil, "free ruling has no won flag"
    end
    won = nil
  else
    if won ~= true and won ~= false then return nil, "ruling needs a won flag" end
  end

  local text
  if ruling == "free" and fields.text ~= nil then
    if type(fields.text) ~= "string" then return nil, "text must be text" end
    text = trim(fields.text)
  end

  local at = wall(now)
  local gora = ch.gora
  local famousUpset = fields.famousUpset == true
  local notable = fields.notable == true

  if won == true then
    gora.wins = gora.wins + 1
    if gora.streak < 0 then gora.streak = 1 else gora.streak = gora.streak + 1 end
  elseif won == false then
    gora.losses = gora.losses + 1
    if gora.streak > 0 then gora.streak = -1 else gora.streak = gora.streak - 1 end
  end

  local h2h = h2hFor(gora, fields.opponentId)
  h2h.fights = h2h.fights + 1
  if won == true then
    h2h.wins = h2h.wins + 1
  elseif won == false then
    h2h.losses = h2h.losses + 1
  end

  if notable and won == true and not hasId(gora.notableVictims, fields.opponentId) then
    gora.notableVictims[#gora.notableVictims + 1] = fields.opponentId
  end

  gora.rulings[#gora.rulings + 1] = {
    ruling = ruling,
    at = at,
    opponentId = fields.opponentId,
  }
  local result = {
    at = at,
    opponentId = fields.opponentId,
    ruling = ruling,
    won = won,
    famousUpset = famousUpset,
  }
  if ruling == "free" then
    result.text = text
  end
  gora.results[#gora.results + 1] = result
  gora.defenses = nil
  gora.defenseCount = nil
  return deepcopy(ch)
end

-- Derived story field (OPEN_QUESTIONS #9). Never writes gora.defenses.
function Store:CountDefenses(characterId)
  if not isId(characterId) then return 0 end
  local ch = characters[characterId]
  if not ch then return 0 end
  if not isId(ch.humanId) then return 0 end
  local human = humans[ch.humanId]
  if not human then return 0 end
  local elevationAt = human.elevationAt
  if type(elevationAt) ~= "number" then return 0 end
  local results = ch.gora and ch.gora.results
  if type(results) ~= "table" then return 0 end
  local n = 0
  for i = 1, #results do
    local result = results[i]
    if result
      and result.won == true
      and result.ruling ~= "void"
      and result.ruling ~= "free"
      and type(result.at) == "number"
      and result.at >= elevationAt
    then
      n = n + 1
    end
  end
  return n
end

function Store:Snapshot()
  return {
    humans = listCopy(humans),
    characters = listCopy(characters),
    ceremonyLog = deepcopy(ceremonyLog),
    markedMoments = deepcopy(markedMoments),
    nextHumanId = nextHumanId,
    nextCharacterId = nextCharacterId,
    nextCeremonyId = nextCeremonyId,
    nextMomentId = nextMomentId,
  }
end

function Store:Restore(snap)
  if type(snap) ~= "table" then return nil, "snapshot must be a table" end
  if snap.humans ~= nil and type(snap.humans) ~= "table" then
    return nil, "humans must be a table"
  end
  if snap.characters ~= nil and type(snap.characters) ~= "table" then
    return nil, "characters must be a table"
  end
  if snap.ceremonyLog ~= nil and type(snap.ceremonyLog) ~= "table" then
    return nil, "ceremonyLog must be a table"
  end
  if snap.markedMoments ~= nil and type(snap.markedMoments) ~= "table" then
    return nil, "markedMoments must be a table"
  end

  humans = loadRows(snap.humans, ensureHuman)
  characters = loadRows(snap.characters, ensureCharacter)
  ceremonyLog = deepcopy(snap.ceremonyLog or {})
  markedMoments = deepcopy(snap.markedMoments or {})
  nextHumanId = bumpNext(snap.nextHumanId, humans)
  nextCharacterId = bumpNext(snap.nextCharacterId, characters)
  nextCeremonyId = bumpNextList(snap.nextCeremonyId, ceremonyLog)
  nextMomentId = bumpNextList(snap.nextMomentId, markedMoments)
  return true
end
