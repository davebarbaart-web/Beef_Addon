ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- KNIGHT THIS BEEF and Lord elevation (Bible §8, §10.4). Church record only.
-- Memory-only knighting line: the Pope sees who is next; software never
-- auto-advances or auto-knights. Guild-rank promotion and theater are later Console.
-- Core never writes guild display rank.
local Knighting = {}
COB.Knighting = Knighting

local KNIGHT_ID = 3
local LORD_ID = 4

local line = {}
local nextSeq = 1

local function isId(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

local function store()
  local Store = COB.Store
  if not Store or not Store.SetRank or not Store.GetHuman then
    return nil, "store is not available"
  end
  return Store
end

local function knownHuman(Store, humanId)
  local human, err = Store:GetHuman(humanId)
  if not human then return nil, err or "unknown human" end
  return human
end

local function needsKnighting(rankId)
  return rankId == nil or rankId == 1 or rankId == 2
end

local function runtimeLoaded()
  return COB.Runtime ~= nil and type(COB.Runtime.Snapshot) == "function"
end

local function liveEventId()
  if not runtimeLoaded() then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" or snap.state == "QUIET" then return nil end
  if not isId(snap.eventId) then return nil end
  return snap.eventId
end

local function copyRow(entry)
  local rankId = entry.rankId
  if COB.Store and COB.Store.GetHuman then
    local human = COB.Store:GetHuman(entry.humanId)
    if human then rankId = human.rankId end
  end
  return { humanId = entry.humanId, rankId = rankId }
end

function Knighting:_Expire()
  if not runtimeLoaded() then return end
  local eventId = liveEventId()
  if not eventId then
    line = {}
    return
  end
  local drop = nil
  for id, entry in pairs(line) do
    if entry.eventId ~= eventId then
      drop = drop or {}
      drop[#drop + 1] = id
    end
  end
  if drop then
    for i = 1, #drop do line[drop[i]] = nil end
  end
end

local function addToLine(humanId)
  Knighting:_Expire()
  if runtimeLoaded() then
    local eventId = liveEventId()
    if not eventId then return nil, "no event" end
  end
  local Store, storeErr = store()
  if not Store then return nil, storeErr end
  local human, err = knownHuman(Store, humanId)
  if not human then return nil, err end
  if not needsKnighting(human.rankId) then
    return nil, "already knighted"
  end
  local existing = line[human.id]
  if existing then
    return copyRow(existing)
  end
  line[human.id] = {
    humanId = human.id,
    rankId = human.rankId,
    eventId = liveEventId(),
    seq = nextSeq,
  }
  nextSeq = nextSeq + 1
  return copyRow(line[human.id])
end

function Knighting:Enqueue(humanId)
  return addToLine(humanId)
end

function Knighting:Insert(humanId)
  return addToLine(humanId)
end

function Knighting:Skip(humanId)
  self:_Expire()
  local Store, storeErr = store()
  if not Store then return nil, storeErr end
  local human, err = knownHuman(Store, humanId)
  if not human then return nil, err end
  local entry = line[human.id]
  if not entry then return nil, "not in line" end
  local copy = copyRow(entry)
  line[human.id] = nil
  return copy
end

function Knighting:GetLine()
  self:_Expire()
  local rows = {}
  for _, entry in pairs(line) do
    rows[#rows + 1] = entry
  end
  table.sort(rows, function(a, b)
    if a.seq ~= b.seq then return a.seq < b.seq end
    return a.humanId < b.humanId
  end)
  local out = {}
  for i = 1, #rows do
    out[i] = copyRow(rows[i])
  end
  return out
end

function Knighting:ResetForTests()
  if not COB._IN_TEST then return false end
  line = {}
  nextSeq = 1
  return true
end

function Knighting:KnightThisBeef(humanId, now)
  local Store, storeErr = store()
  if not Store then return nil, storeErr end
  local human, err = knownHuman(Store, humanId)
  if not human then return nil, err end
  if type(human.rankId) == "number" and human.rankId >= LORD_ID then
    return nil, "already elevated"
  end
  local row, setErr = Store:SetRank(humanId, KNIGHT_ID, now)
  if not row then return nil, setErr end
  if Store.AppendCeremony then
    Store:AppendCeremony("Knighting", { humanId }, now)
  end
  self:_Expire()
  line[human.id] = nil
  return row
end

function Knighting:ElevateToLord(humanId, now)
  local Store, storeErr = store()
  if not Store then return nil, storeErr end
  local human, err = knownHuman(Store, humanId)
  if not human then return nil, err end
  if type(human.rankId) == "number" and human.rankId > LORD_ID then
    return nil, "already elevated"
  end
  local row, setErr = Store:SetRank(humanId, LORD_ID, now)
  if not row then return nil, setErr end
  if Store.AppendCeremony then
    Store:AppendCeremony("Elevation", { humanId }, now)
  end
  self:_Expire()
  line[human.id] = nil
  return row
end
