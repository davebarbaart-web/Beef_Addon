ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Pope-owned ceremony runtime (Bible §20.1–20.3). One writer: these verbs.
-- QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET.
-- awaitingPope is Event Mode degraded, not a sixth state. No holdSeconds.
-- No auto-advance, no narration, no SV persist, no frames, no Net.
local Runtime = {}
COB.Runtime = Runtime

local STATES = {
  QUIET = true,
  ASSEMBLY = true,
  RITE = true,
  CONSEQUENCE = true,
}

local RITE_TYPES = {
  Knighting = true,
  Gora = true,
  Confession = true,
  Proclamation = true,
}

local event = nil
local nextEventId = 1

local function isInt(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

local function isSeq(n)
  return type(n) == "number" and n == math.floor(n) and n >= 0
end

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function emptySubjects()
  return { candidate = nil, fighters = nil }
end

local function copyFighters(list)
  if list == nil then return nil end
  if type(list) ~= "table" then return nil, "fighters must be a list" end
  local n = 0
  for k, _ in pairs(list) do
    if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
      return nil, "invalid fighters"
    end
    n = n + 1
  end
  if n ~= #list then return nil, "invalid fighters" end
  local out = {}
  for i = 1, #list do
    if not isInt(list[i]) then return nil, "invalid fighters" end
    out[i] = list[i]
  end
  if #out == 0 then return nil end
  return out
end

local function parseSubjects(raw)
  if raw == nil then return emptySubjects() end
  if type(raw) ~= "table" then return nil, "invalid subjects" end
  local candidate = raw.candidate
  if candidate ~= nil and not isInt(candidate) then
    return nil, "invalid candidate"
  end
  local fighters, fightErr = copyFighters(raw.fighters)
  if fightErr then return nil, fightErr end
  return { candidate = candidate, fighters = fighters }
end

local function newEvent()
  return {
    eventId = nil,
    state = "QUIET",
    riteType = nil,
    subjects = emptySubjects(),
    sequence = 0,
  }
end

local function current()
  if not event then event = newEvent() end
  return event
end

local function copyEvent()
  return deepcopy(current())
end

local function succeed(fields)
  local ev = current()
  if fields.eventId ~= nil then ev.eventId = fields.eventId end
  if fields.state ~= nil then ev.state = fields.state end
  if fields.clearRite then
    ev.riteType = nil
  elseif fields.riteType ~= nil then
    ev.riteType = fields.riteType
  end
  if fields.subjects ~= nil then ev.subjects = fields.subjects end
  ev.sequence = ev.sequence + 1
  if ev.state == "QUIET" then
    ev.awaitingPope = nil
  end
  return copyEvent()
end

local function parseEvent(snap)
  if type(snap) ~= "table" then return nil, "snapshot must be a table" end
  local state = snap.state
  if type(state) ~= "string" or not STATES[state] then
    return nil, "invalid state"
  end

  local eventId = snap.eventId
  if eventId ~= nil and not isInt(eventId) then
    return nil, "invalid event id"
  end
  if state ~= "QUIET" and eventId == nil then
    return nil, "invalid event id"
  end

  if not isSeq(snap.sequence) then
    return nil, "invalid sequence"
  end

  local riteType = snap.riteType
  if riteType ~= nil then
    if type(riteType) ~= "string" or not RITE_TYPES[riteType] then
      return nil, "invalid rite type"
    end
  end
  if (state == "RITE" or state == "CONSEQUENCE") and riteType == nil then
    return nil, "rite type required"
  end
  if (state == "QUIET" or state == "ASSEMBLY") and riteType ~= nil then
    return nil, "invalid rite type"
  end

  local subjects, subErr = parseSubjects(snap.subjects)
  if not subjects then return nil, subErr end
  if state == "QUIET" then
    if subjects.candidate ~= nil or subjects.fighters ~= nil then
      return nil, "invalid subjects"
    end
  end

  local parsed = {
    eventId = eventId,
    state = state,
    riteType = riteType,
    subjects = subjects,
    sequence = snap.sequence,
  }
  if snap.awaitingPope == true and state ~= "QUIET" then
    parsed.awaitingPope = true
  end
  return parsed
end

local function clear()
  event = newEvent()
  nextEventId = 1
end

function Runtime:ResetForTests()
  if not COB._IN_TEST then return false end
  clear()
  return true
end

function Runtime:Snapshot()
  return copyEvent()
end

-- Latest-wins (Option C). Ceremony Bible fields apply when eventId differs
-- or sequence is greater. Same eventId + equal sequence is a no-op that
-- still returns ok so Net/bootstrap can overlay favor. Older sequence is
-- not-ok so favor is not overlaid. Favor is not a Runtime field.
function Runtime:Restore(snap)
  local parsed, err = parseEvent(snap)
  if not parsed then return nil, err end
  local ev = current()
  if parsed.eventId == ev.eventId then
    if parsed.sequence < ev.sequence then
      return nil, "stale sequence"
    end
    if parsed.sequence == ev.sequence then
      return true
    end
  end
  event = parsed
  nextEventId = (parsed.eventId or 0) + 1
  return true
end

-- Bible §13.4 / §20.3: stale protocol drops Event chrome to Quiet presentation.
-- Restore already accepts QUIET from any state. Do not call EndEvent (illegal from RITE).
-- Keep nextEventId so a later StartEvent on this client does not reuse 1.
function Runtime:DropToQuietForVersion()
  local keep = nextEventId
  local ok, err = self:Restore(newEvent())
  if ok then nextEventId = keep end
  return ok, err
end

function Runtime:StartEvent()
  local ev = current()
  if ev.state ~= "QUIET" then return nil, "start from quiet" end
  local id
  id, nextEventId = nextEventId, nextEventId + 1
  return succeed({
    eventId = id,
    state = "ASSEMBLY",
    clearRite = true,
    subjects = emptySubjects(),
  })
end

function Runtime:OpenRite(kind, subjects)
  local ev = current()
  if ev.state ~= "ASSEMBLY" then return nil, "rite opens from assembly" end
  if type(kind) ~= "string" or not RITE_TYPES[kind] then
    return nil, "unknown rite type"
  end
  local parsed, err = parseSubjects(subjects)
  if not parsed then return nil, err end
  return succeed({
    state = "RITE",
    riteType = kind,
    subjects = parsed,
  })
end

function Runtime:CloseRite()
  local ev = current()
  if ev.state ~= "RITE" then return nil, "no open rite" end
  return succeed({ state = "CONSEQUENCE" })
end

function Runtime:Continue()
  local ev = current()
  if ev.state ~= "CONSEQUENCE" then return nil, "continue is from consequence" end
  return succeed({
    state = "ASSEMBLY",
    clearRite = true,
    subjects = emptySubjects(),
  })
end

function Runtime:EndEvent()
  local ev = current()
  if ev.state ~= "ASSEMBLY" and ev.state ~= "CONSEQUENCE" then
    return nil, "event ends from assembly or consequence"
  end
  return succeed({
    state = "QUIET",
    clearRite = true,
    subjects = emptySubjects(),
  })
end

function Runtime:MarkPopeLost()
  local ev = current()
  if ev.state == "QUIET" then
    return nil, "awaiting pope from event"
  end
  ev.awaitingPope = true
  return copyEvent()
end

function Runtime:ClearPopeLost()
  local ev = current()
  ev.awaitingPope = nil
  return copyEvent()
end
