ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Snapshot request / response apply (Bible §20.3, §13.1). Catch-up is not
-- peer SYNC: congregation Request(); only a Pope client BuildResponse().
-- This file encodes and Restores. It does not send, whisper, or route.
-- BuildResponse may overlay Gora live / last pair (and toggle-gated favor)
-- and a Knighting line-head candidate onto the encoded SNAPSHOT only.
-- Runtime is not mutated. ApplyResponse Restores Bible fields only
-- (same latest-wins rule as Runtime:Restore); favor stays off Restore.
local Snapshot = {}
COB.Snapshot = Snapshot

local BIBLE = { "eventId", "state", "riteType", "subjects", "sequence" }

local function bibleFields(src)
  local out = {}
  for i = 1, #BIBLE do
    local key = BIBLE[i]
    out[key] = src[key]
  end
  return out
end

local function fighterCount(subjects)
  if type(subjects) ~= "table" or type(subjects.fighters) ~= "table" then
    return 0
  end
  return #subjects.fighters
end

local function pairIds(pair)
  if type(pair) ~= "table" then return nil end
  local a, b = pair.fighterA, pair.fighterB
  if type(a) ~= "number" or type(b) ~= "number" then return nil end
  return a, b
end

local function callPair(mod, method)
  if type(mod) ~= "table" or type(mod[method]) ~= "function" then
    return nil
  end
  return pairIds(mod[method](mod))
end

local function overlaySubjects(subjects, fighterA, fighterB)
  local candidate = type(subjects) == "table" and subjects.candidate or nil
  return {
    candidate = candidate,
    fighters = { fighterA, fighterB },
  }
end

local function overlayCandidate(subjects, candidate)
  local fighters = type(subjects) == "table" and subjects.fighters or nil
  return { candidate = candidate, fighters = fighters }
end

local function displayForId(id)
  if type(id) ~= "number" then return nil end
  local Store = COB.Store
  if not (Store and Store.GetCharacter) then return nil end
  local ch = Store:GetCharacter(id)
  if type(ch) ~= "table" or type(ch.name) ~= "string" then return nil end
  if COB.Names and COB.Names.Display then
    return COB.Names.Display(ch.name)
  end
  return ch.name
end

local function overlayNames(fields)
  local names = { candidate = nil, fighterA = nil, fighterB = nil }
  local subjects = fields.subjects
  if type(subjects) == "table" then
    names.candidate = displayForId(subjects.candidate)
    if type(subjects.fighters) == "table" then
      names.fighterA = displayForId(subjects.fighters[1])
      names.fighterB = displayForId(subjects.fighters[2])
    end
  end
  fields.names = names
end

local function lineHeadHumanId()
  local knighting = COB.Knighting
  if type(knighting) ~= "table" or type(knighting.GetLine) ~= "function" then
    return nil
  end
  local ok, line = pcall(knighting.GetLine, knighting)
  if not ok or type(line) ~= "table" then
    return nil
  end
  local head = line[1]
  if type(head) ~= "table" then
    return nil
  end
  local humanId = head.humanId
  if type(humanId) ~= "number" then
    return nil
  end
  return humanId
end

function Snapshot:Request()
  return COB.Codec:EncodeSnapshot({ role = "request" })
end

function Snapshot:BuildResponse()
  local snap = COB.Runtime:Snapshot()
  if snap.state == "QUIET" then
    return nil, "no event"
  end
  local fields = bibleFields(snap)
  local usedLive = false
  local usedLast = false
  local gora = COB.Gora
  local liveA, liveB = callPair(gora, "GetSanctioned")
  if fighterCount(fields.subjects) ~= 2 then
    if liveA and liveB then
      fields.subjects = overlaySubjects(fields.subjects, liveA, liveB)
      usedLive = true
    elseif snap.state == "CONSEQUENCE" and snap.riteType == "Gora" then
      local lastA, lastB = callPair(gora, "GetLastSanctioned")
      if lastA and lastB then
        fields.subjects = overlaySubjects(fields.subjects, lastA, lastB)
        usedLast = true
      end
    end
  elseif liveA and liveB then
    usedLive = true
  end

  local cand = type(fields.subjects) == "table" and fields.subjects.candidate or nil
  if type(cand) ~= "number" then
    local allow = fields.state == "ASSEMBLY"
      or (fields.state == "RITE" and fields.riteType == "Knighting")
    if allow then
      local head = lineHeadHumanId()
      if type(head) == "number" then
        fields.subjects = overlayCandidate(fields.subjects, head)
      end
    end
  end

  local console = COB.Console
  local visible = type(console) == "table"
    and type(console.GetCongregationFavorVisible) == "function"
    and console:GetCongregationFavorVisible() == true
  if visible and fighterCount(fields.subjects) == 2 then
    if usedLive and type(gora) == "table" and type(gora.GetFavorSplit) == "function" then
      fields.favor = gora:GetFavorSplit()
    elseif usedLast and type(gora) == "table" and type(gora.GetLastFavorSplit) == "function" then
      fields.favor = gora:GetLastFavorSplit()
    end
  end
  overlayNames(fields)
  fields.role = "response"
  return COB.Codec:EncodeSnapshot(fields)
end

function Snapshot:ApplyResponse(blob)
  local msg, err = COB.Codec:DecodeSnapshot(blob)
  if not msg then return nil, err end
  if not COB.Codec:IsCompatible(msg.version) then
    COB.Runtime:DropToQuietForVersion()
    return nil, "protocol mismatch"
  end
  if msg.role ~= "response" then
    return nil, "invalid role"
  end
  return COB.Runtime:Restore(bibleFields(msg))
end
