ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Memory-only private confession inbox (Bible §9, §13.4).
-- Event-scoped like Gora petitions: wipe when Runtime is QUIET or has no live
-- event id; survive OpenRite / CONSEQUENCE / Continue. Latest line replaces.
-- Software organizes the queue. It does not write the Pope's response.
local Confession = {}
COB.Confession = Confession

local inbox = {}
local nextSeq = 1

local function isId(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

local function liveEventId()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" or snap.state == "QUIET" then return nil end
  if not isId(snap.eventId) then return nil end
  return snap.eventId
end

local function knownCharacter(id)
  if not isId(id) then return false end
  if COB.Store and COB.Store.GetCharacter then
    return COB.Store:GetCharacter(id) ~= nil
  end
  return true
end

local function parseText(text)
  if text == nil then return nil end
  if type(text) ~= "string" then return nil, "invalid text" end
  if text:find("\n", 1, true) then return nil, "invalid text" end
  if COB.Names and COB.Names.Trim then return COB.Names.Trim(text) end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function copyRow(entry)
  return {
    characterId = entry.characterId,
    text = entry.text,
    called = entry.called == true,
  }
end

function Confession:_Expire()
  local eventId = liveEventId()
  if not eventId then
    inbox = {}
    return
  end
  local drop = nil
  for id, entry in pairs(inbox) do
    if entry.eventId ~= eventId then
      drop = drop or {}
      drop[#drop + 1] = id
    end
  end
  if drop then
    for i = 1, #drop do inbox[drop[i]] = nil end
  end
end

function Confession:Receive(characterId, text)
  self:_Expire()
  local eventId = liveEventId()
  if not eventId then return nil, "no event" end
  if not isId(characterId) then return nil, "invalid character id" end
  if not knownCharacter(characterId) then return nil, "unknown character" end
  local line, textErr = parseText(text)
  if textErr then return nil, textErr end

  local existing = inbox[characterId]
  if existing then
    existing.text = line
    existing.eventId = eventId
    existing.called = false
    return copyRow(existing)
  end

  local entry = {
    characterId = characterId,
    eventId = eventId,
    seq = nextSeq,
    text = line,
    called = false,
  }
  nextSeq = nextSeq + 1
  inbox[characterId] = entry
  return copyRow(entry)
end

function Confession:GetQueue()
  self:_Expire()
  local rows = {}
  for _, entry in pairs(inbox) do
    rows[#rows + 1] = entry
  end
  table.sort(rows, function(a, b)
    if a.seq ~= b.seq then return a.seq < b.seq end
    return a.characterId < b.characterId
  end)
  local out = {}
  for i = 1, #rows do
    out[i] = copyRow(rows[i])
  end
  return out
end

function Confession:CallForward(characterId)
  self:_Expire()
  if not isId(characterId) then return false end
  local entry = inbox[characterId]
  if not entry then return false end
  entry.called = true
  return true
end

function Confession:Dismiss(characterId)
  self:_Expire()
  if not isId(characterId) or not inbox[characterId] then return false end
  inbox[characterId] = nil
  return true
end

function Confession:ResetForTests()
  if not COB._IN_TEST then return false end
  inbox = {}
  nextSeq = 1
  return true
end
