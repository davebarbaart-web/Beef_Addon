ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- BeefNet v2 codecs (Bible §13.1, §13.4, §20.2–20.3). Encode/decode only.
-- Closed TYPEs: STATE, SNAPSHOT, INPUT, DECREE, NIGHTS, STUB, STUB_WITHDRAW.
-- No SendAddonMessage. No snapshot schema beyond STATE fields. No whisper,
-- registered-Pope file, or hold timer.
local Codec = {
  PROTOCOL = 2,
  TYPES = { STATE = true, SNAPSHOT = true, INPUT = true, DECREE = true, NIGHTS = true, STUB = true, STUB_WITHDRAW = true },
  STATES = { QUIET = true, ASSEMBLY = true, RITE = true, CONSEQUENCE = true },
  RITE_TYPES = { Knighting = true, Gora = true, Confession = true, Proclamation = true },
  INPUT_KINDS = { petition = true, favor = true, confession = true, going = true },
  SNAPSHOT_ROLES = { request = true, response = true },
}
COB.Codec = Codec

local PROTOCOL = Codec.PROTOCOL
local TYPES = Codec.TYPES
local STATES = Codec.STATES
local RITE_TYPES = Codec.RITE_TYPES
local INPUT_KINDS = Codec.INPUT_KINDS
local SNAPSHOT_ROLES = Codec.SNAPSHOT_ROLES

local FIELD = ":"

local STATE_KEYS = {
  type = true,
  version = true,
  eventId = true,
  state = true,
  riteType = true,
  subjects = true,
  sequence = true,
  favor = true,
  names = true,
}

local SNAPSHOT_REQ_KEYS = {
  type = true,
  version = true,
  role = true,
}

local SNAPSHOT_RES_KEYS = {
  type = true,
  version = true,
  role = true,
  eventId = true,
  state = true,
  riteType = true,
  subjects = true,
  sequence = true,
  favor = true,
  names = true,
}

local INPUT_KEYS = {
  type = true,
  version = true,
  kind = true,
  characterId = true,
  text = true,
  pick = true,
  opponent = true,
  occurrence = true,
}

local DECREE_KEYS = {
  type = true,
  version = true,
  line = true,
  flavor = true,
}

local NIGHTS_KEYS = {
  type = true,
  version = true,
  boardRevision = true,
  series = true,
  stubs = true,
  stubTombstones = true,
  goingCounts = true,
}

local STUB_KEYS = {
  type = true,
  version = true,
  id = true,
  kind = true,
  title = true,
  timeLine = true,
  place = true,
  date = true,
  createdBy = true,
  updatedAt = true,
  boardRevision = true,
}

local STUB_WITHDRAW_KEYS = {
  type = true,
  version = true,
  id = true,
  boardRevision = true,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function trim(text)
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function finite(value)
  local n = tonumber(value)
  if type(n) ~= "number" then return nil end
  if n ~= n then return nil end
  if n == math.huge or n == -math.huge then return nil end
  return n
end

local function isId(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1 and n == n and n ~= math.huge
end

local function isSeq(n)
  return type(n) == "number" and n == math.floor(n) and n >= 0 and n == n and n ~= math.huge
end

local function split(text, sep)
  local out, start = {}, 1
  while true do
    local from, to = text:find(sep, start, true)
    if not from then
      out[#out + 1] = text:sub(start)
      return out
    end
    out[#out + 1] = text:sub(start, from - 1)
    start = to + 1
  end
end

local function parseDigits(text, min)
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" or not text:match("^%d+$") then return nil end
  local n = tonumber(text)
  if type(n) ~= "number" or n ~= math.floor(n) or n < min or n ~= n then return nil end
  return n
end

local function parseId(text)
  return parseDigits(text, 1)
end

local function parseSeq(text)
  return parseDigits(text, 0)
end

local function fmtId(n)
  return string.format("%.0f", n)
end

local function isGrantShaped(key)
  if type(key) ~= "string" then return false end
  local lower = string.lower(key)
  if lower == "points" or lower == "standing" then return true end
  return string.sub(lower, 1, 5) == "grant"
end

local function hasBannedKey(value, seen)
  if type(value) ~= "table" then return false end
  seen = seen or {}
  if seen[value] then return false end
  seen[value] = true
  for k, v in pairs(value) do
    if isGrantShaped(k) then return true end
    if type(v) == "table" and hasBannedKey(v, seen) then return true end
  end
  return false
end

local function firstUnknown(msg, allowed)
  for k, _ in pairs(msg) do
    if not allowed[k] then return k end
  end
end

local function isIdArray(value)
  if type(value) ~= "table" then return false end
  local n = 0
  for k, v in pairs(value) do
    if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then return false end
    if not isId(v) then return false end
    n = n + 1
  end
  return n == #value
end

local function copyFighters(list)
  local out = {}
  if type(list) ~= "table" then return out end
  for i = 1, #list do out[i] = list[i] end
  return out
end

local function copyFavor(favor)
  if type(favor) ~= "table" then return nil end
  return { a = favor.a, b = favor.b }
end

local function copyNames(names)
  if type(names) ~= "table" then
    return { candidate = nil, fighterA = nil, fighterB = nil }
  end
  return {
    candidate = names.candidate,
    fighterA = names.fighterA,
    fighterB = names.fighterB,
  }
end

local function displayName(raw)
  if type(raw) ~= "string" then return nil end
  if COB.Names and COB.Names.Display then
    return COB.Names.Display(raw)
  end
  return trim(raw)
end

local function nameIllegal(text)
  if type(text) ~= "string" or text == "" then return false end
  return text:find(FIELD, 1, true) ~= nil or text:find("\n", 1, true) ~= nil
end

-- Subjects-mirror: candidateDisplay,fighterA,fighterB. Empty candidate is a
-- leading comma. Always emit the field (empty when no subjects) so 9 = names
-- and 10 = favor + names. Fail-closed on ":" or newline — do not escape.
local function encodeNames(names)
  if names == nil then return "" end
  local cand, a, b = "", "", ""
  if type(names) == "string" then
    if nameIllegal(names) then return nil, "invalid names" end
    local bits = split(names, ",")
    if #bits > 3 then return nil, "invalid names" end
    cand = displayName(bits[1]) or ""
    a = displayName(bits[2]) or ""
    b = displayName(bits[3]) or ""
  elseif type(names) == "table" then
    for k, _ in pairs(names) do
      if k ~= "candidate" and k ~= "fighterA" and k ~= "fighterB" then
        return nil, "invalid names"
      end
    end
    local function slot(value)
      if value == nil then return "", nil end
      if type(value) ~= "string" then return nil, "invalid names" end
      local shown = displayName(value)
      if not shown then return "", nil end
      return shown, nil
    end
    local e
    cand, e = slot(names.candidate)
    if e then return nil, e end
    a, e = slot(names.fighterA)
    if e then return nil, e end
    b, e = slot(names.fighterB)
    if e then return nil, e end
  else
    return nil, "invalid names"
  end
  if nameIllegal(cand) or nameIllegal(a) or nameIllegal(b) then
    return nil, "invalid names"
  end
  if cand == "" and a == "" and b == "" then return "" end
  return cand .. "," .. a .. "," .. b
end

local function parseNamesField(text)
  if type(text) ~= "string" then return nil, "invalid names" end
  if text:find("\n", 1, true) then return nil, "invalid names" end
  if text == "" then
    return { candidate = nil, fighterA = nil, fighterB = nil }
  end
  local bits = split(text, ",")
  if #bits > 3 then return nil, "invalid names" end
  local function slot(raw)
    local shown = displayName(raw)
    if not shown then return nil end
    if nameIllegal(shown) then return nil, "invalid names" end
    return shown
  end
  local cand, e = slot(bits[1])
  if e then return nil, e end
  local a
  a, e = slot(bits[2])
  if e then return nil, e end
  local b
  b, e = slot(bits[3])
  if e then return nil, e end
  return { candidate = cand, fighterA = a, fighterB = b }
end

local function fighterCount(subjects)
  if type(subjects) ~= "table" or type(subjects.fighters) ~= "table" then return 0 end
  return #subjects.fighters
end

local function validateFavor(favor, nFight)
  if type(favor) ~= "table" then return nil, "invalid favor" end
  for k, _ in pairs(favor) do
    if k ~= "a" and k ~= "b" then return nil, "invalid favor" end
  end
  if not isSeq(favor.a) or not isSeq(favor.b) then return nil, "invalid favor" end
  if nFight ~= 2 then return nil, "invalid favor" end
  return { a = favor.a, b = favor.b }
end

local function parseFavorField(text)
  if type(text) ~= "string" or not text:match("^%d+,%d+$") then
    return nil, "unknown field"
  end
  local aStr, bStr = text:match("^(%d+),(%d+)$")
  local a = parseSeq(aStr)
  local b = parseSeq(bStr)
  if a == nil or b == nil then return nil, "invalid favor" end
  return { a = a, b = b }
end

--------------------------------------------------------------------------------
-- STATE body (also SNAPSHOT response — same fields, no extra schema)
--------------------------------------------------------------------------------

local function encodeSubjects(subjects)
  if subjects == nil then return "", "" end
  if type(subjects) ~= "table" then return nil, "invalid subjects" end
  for k, _ in pairs(subjects) do
    if k ~= "candidate" and k ~= "fighters" then
      return nil, "invalid subjects"
    end
  end
  local cand = ""
  if subjects.candidate ~= nil then
    if not isId(subjects.candidate) then return nil, "invalid subjects" end
    cand = fmtId(subjects.candidate)
  end
  local fight = ""
  if subjects.fighters ~= nil then
    if not isIdArray(subjects.fighters) then return nil, "invalid subjects" end
    local parts = {}
    for i = 1, #subjects.fighters do
      parts[i] = fmtId(subjects.fighters[i])
    end
    fight = table.concat(parts, ",")
  end
  return cand, fight
end

local function parseSubjects(candField, fightField)
  local candidate = nil
  local cand = trim(candField)
  if cand then
    candidate = parseId(cand)
    if not candidate then return nil, "invalid subjects" end
  end
  local fighters = {}
  local fight = trim(fightField)
  if fight then
    local bits = split(fight, ",")
    for i = 1, #bits do
      local id = parseId(bits[i])
      if not id then return nil, "invalid subjects" end
      fighters[i] = id
    end
  end
  return { candidate = candidate, fighters = fighters }
end

local function validateStateFields(fields)
  if not isId(fields.eventId) then return nil, "invalid event id" end
  local state = trim(fields.state)
  if not state or not STATES[state] then return nil, "invalid state" end
  local riteType = nil
  if fields.riteType ~= nil then
    riteType = trim(fields.riteType)
    if type(fields.riteType) == "string" and fields.riteType:match("%S") and not riteType then
      return nil, "invalid rite type"
    end
    if fields.riteType ~= nil and type(fields.riteType) ~= "string" then
      return nil, "invalid rite type"
    end
    if riteType and not RITE_TYPES[riteType] then return nil, "invalid rite type" end
  end
  if state == "RITE" and not riteType then return nil, "rite type required" end
  if not isSeq(fields.sequence) then return nil, "invalid sequence" end
  local cand, fight = encodeSubjects(fields.subjects)
  if not cand then return nil, fight end
  local body = {
    eventId = fields.eventId,
    state = state,
    riteType = riteType,
    candidate = cand,
    fighters = fight,
    sequence = fields.sequence,
  }
  if fields.favor ~= nil then
    local fav, favErr = validateFavor(fields.favor, fighterCount(fields.subjects))
    if not fav then return nil, favErr end
    body.favor = fav
  end
  local packed, packErr = encodeNames(fields.names)
  if not packed then return nil, packErr end
  body.names = packed
  return body
end

local function encodeStateWire(msgType, role, body)
  local parts = { tostring(PROTOCOL), msgType }
  if role then parts[#parts + 1] = role end
  parts[#parts + 1] = fmtId(body.eventId)
  parts[#parts + 1] = body.state
  parts[#parts + 1] = body.riteType or ""
  parts[#parts + 1] = body.candidate
  parts[#parts + 1] = body.fighters
  parts[#parts + 1] = fmtId(body.sequence)
  if body.favor then
    parts[#parts + 1] = fmtId(body.favor.a) .. "," .. fmtId(body.favor.b)
  end
  parts[#parts + 1] = body.names or ""
  return table.concat(parts, FIELD)
end

local function decodeStateFields(parts, start)
  local expected = start + 5
  -- 8 = Bible fields (legacy Task 7). 9 = names, or legacy favor-only.
  -- 10 = favor + names. Anything past that is an unknown colon part.
  if #parts > expected + 2 then return nil, "unknown field" end
  local eventId = parseId(parts[start])
  if not eventId then return nil, "invalid event id" end
  local state = trim(parts[start + 1])
  if not state or not STATES[state] then return nil, "invalid state" end
  local riteType = trim(parts[start + 2])
  if riteType and not RITE_TYPES[riteType] then return nil, "invalid rite type" end
  if state == "RITE" and not riteType then return nil, "rite type required" end
  local subjects, err = parseSubjects(parts[start + 3], parts[start + 4])
  if not subjects then return nil, err end
  local sequence = parseSeq(parts[start + 5])
  if sequence == nil then return nil, "invalid sequence" end
  local favor = nil
  local names = { candidate = nil, fighterA = nil, fighterB = nil }
  if #parts == expected + 2 then
    local fav, favErr = parseFavorField(parts[expected + 1])
    if not fav then return nil, favErr end
    if fighterCount(subjects) ~= 2 then return nil, "invalid favor" end
    favor = fav
    local nm, nmErr = parseNamesField(parts[expected + 2])
    if not nm then return nil, nmErr end
    names = nm
  elseif #parts == expected + 1 then
    local extra = parts[expected + 1]
    if type(extra) == "string" and extra:match("^%d+,%d+$") then
      local fav, favErr = parseFavorField(extra)
      if not fav then return nil, favErr end
      if fighterCount(subjects) ~= 2 then return nil, "invalid favor" end
      favor = fav
    else
      local nm, nmErr = parseNamesField(extra)
      if not nm then return nil, nmErr end
      names = nm
    end
  end
  return {
    eventId = eventId,
    state = state,
    riteType = riteType,
    subjects = subjects,
    sequence = sequence,
    favor = favor,
    names = names,
  }
end

--------------------------------------------------------------------------------
-- Encode
--------------------------------------------------------------------------------

local function checkVersion(fields)
  if fields.version == nil then return true end
  if finite(fields.version) ~= PROTOCOL then return nil, "protocol mismatch" end
  return true
end

local function cleanCell(text, errName)
  text = trim(text)
  if not text then return nil end
  if text:find("\n", 1, true) or text:find("\t", 1, true) then
    return nil, "invalid " .. errName
  end
  return text
end

local function encodeNightsMessage(fields)
  local rev = fields.boardRevision
  if rev ~= nil and not isSeq(rev) then return nil, "invalid revision" end
  local lines = { tostring(rev or 0) }
  local list = fields.series
  if type(list) == "table" then
    for i = 1, #list do
      local row = list[i]
      if type(row) == "table" then
        local timeLine, timeErr = cleanCell(row.timeLine, "timeLine")
        if not timeLine then return nil, timeErr or "timeLine is required" end
        local place, placeErr = cleanCell(row.place, "place")
        if not place then return nil, placeErr or "place is required" end
        local flavor = ""
        if row.flavor ~= nil then
          local f, fErr = cleanCell(row.flavor, "flavor")
          if not f then return nil, fErr end
          flavor = f
        end
        local weekday = type(row.weekday) == "number" and tostring(row.weekday) or ""
        local oneshot = type(row.oneshotDate) == "string" and row.oneshotDate or ""
        lines[#lines + 1] = table.concat({
          "S",
          tostring(row.id or ""),
          tostring(row.kind or ""),
          weekday,
          timeLine,
          place,
          flavor,
          row.withdrawn and "1" or "",
          oneshot,
        }, "\t")
        if type(row.skip) == "table" then
          for date, flag in pairs(row.skip) do
            if flag == true and type(date) == "string" then
              if date:find("\n", 1, true) or date:find("\t", 1, true) then
                return nil, "invalid date"
              end
              lines[#lines + 1] = table.concat({ "K", tostring(row.id or ""), date }, "\t")
            end
          end
        end
        if type(row.move) == "table" then
          for date, moved in pairs(row.move) do
            if type(date) == "string" and type(moved) == "table" then
              if date:find("\n", 1, true) or date:find("\t", 1, true) then
                return nil, "invalid date"
              end
              local movedTime, movedTimeErr = cleanCell(moved.timeLine, "timeLine")
              local movedPlace, movedPlaceErr = cleanCell(moved.place, "place")
              if not movedTime then return nil, movedTimeErr or "timeLine is required" end
              if not movedPlace then return nil, movedPlaceErr or "place is required" end
              lines[#lines + 1] = table.concat({
                "M", tostring(row.id or ""), date, movedTime, movedPlace,
              }, "\t")
            end
          end
        end
      end
    end
  end
  list = fields.stubs
  if type(list) == "table" then
    for i = 1, #list do
      local row = list[i]
      if type(row) == "table" then
        local title, titleErr = cleanCell(row.title, "title")
        if not title then return nil, titleErr or "title is required" end
        local timeLine, timeErr = cleanCell(row.timeLine, "timeLine")
        if not timeLine then return nil, timeErr end
        local place, placeErr = cleanCell(row.place, "place")
        if not place then return nil, placeErr end
        local date, dateErr = cleanCell(row.date, "date")
        if not date then return nil, dateErr or "date is required" end
        lines[#lines + 1] = table.concat({
          "U",
          tostring(row.id or ""),
          tostring(row.kind or ""),
          title,
          timeLine,
          place,
          date,
          tostring(row.createdBy or ""),
          tostring(row.updatedAt or ""),
        }, "\t")
      end
    end
  end
  list = fields.stubTombstones
  if type(list) == "table" then
    for i = 1, #list do
      local id = trim(list[i])
      if id then
        if id:find("\n", 1, true) or id:find("\t", 1, true) then
          return nil, "invalid id"
        end
        lines[#lines + 1] = "T\t" .. id
      end
    end
  end
  local counts = fields.goingCounts
  if type(counts) == "table" then
    for key, n in pairs(counts) do
      if type(key) == "string" and type(n) == "number" then
        if key:find("\n", 1, true) or key:find("\t", 1, true) then
          return nil, "invalid occurrence"
        end
        lines[#lines + 1] = "G\t" .. key .. "\t" .. tostring(n)
      end
    end
  end
  return tostring(PROTOCOL) .. ":NIGHTS:\n" .. table.concat(lines, "\n")
end

local function encodeStubMessage(fields)
  local id, idErr = cleanCell(fields.id, "id")
  if not id then return nil, idErr or "id is required" end
  local title, titleErr = cleanCell(fields.title, "title")
  if not title then return nil, titleErr or "title is required" end
  local timeLine, timeErr = cleanCell(fields.timeLine, "timeLine")
  if not timeLine then return nil, timeErr or "timeLine is required" end
  local place, placeErr = cleanCell(fields.place, "place")
  if not place then return nil, placeErr or "place is required" end
  local date, dateErr = cleanCell(fields.date, "date")
  if not date then return nil, dateErr or "date is required" end
  local kind = trim(fields.kind)
  if kind ~= "raid" and kind ~= "pvp" then return nil, "unknown kind" end
  local createdBy = trim(fields.createdBy) or ""
  if createdBy:find("\t", 1, true) or createdBy:find("\n", 1, true) then
    return nil, "invalid createdBy"
  end
  local rev = fields.boardRevision
  if rev ~= nil and not isSeq(rev) then return nil, "invalid revision" end
  local body = table.concat({
    id, kind, title, timeLine, place, date, createdBy, tostring(fields.updatedAt or ""), tostring(rev or ""),
  }, "\t")
  return tostring(PROTOCOL) .. ":STUB:\n" .. body
end

local function encodeTyped(msgType, fields)
  if type(fields) ~= "table" then return nil, "invalid message" end
  if hasBannedKey(fields) then return nil, "banned key" end
  if fields.type ~= nil then
    if type(fields.type) ~= "string" or trim(fields.type) ~= msgType then
      return nil, "unknown message type"
    end
  end
  local ok, err = checkVersion(fields)
  if not ok then return nil, err end

  if msgType == "STATE" then
    if firstUnknown(fields, STATE_KEYS) then return nil, "unknown field" end
    local body, bodyErr = validateStateFields(fields)
    if not body then return nil, bodyErr end
    return encodeStateWire("STATE", nil, body)
  end

  if msgType == "SNAPSHOT" then
    local role = trim(fields.role)
    if not role or not SNAPSHOT_ROLES[role] then return nil, "invalid role" end
    local allowed = role == "request" and SNAPSHOT_REQ_KEYS or SNAPSHOT_RES_KEYS
    if firstUnknown(fields, allowed) then return nil, "unknown field" end
    if role == "request" then
      return table.concat({ tostring(PROTOCOL), "SNAPSHOT", "request" }, FIELD)
    end
    local body, bodyErr = validateStateFields(fields)
    if not body then return nil, bodyErr end
    return encodeStateWire("SNAPSHOT", "response", body)
  end

  if msgType == "INPUT" then
    if firstUnknown(fields, INPUT_KEYS) then return nil, "unknown field" end
    local kind = trim(fields.kind)
    if not kind or not INPUT_KINDS[kind] then return nil, "invalid kind" end
    if kind == "going" then
      local occurrence = trim(fields.occurrence)
      if not occurrence then return nil, "occurrence is required" end
      if occurrence:find(FIELD, 1, true) or occurrence:find("\n", 1, true) then
        return nil, "invalid occurrence"
      end
      if fields.characterId ~= nil then return nil, "character id not allowed" end
      if fields.text ~= nil then return nil, "text not allowed" end
      if fields.pick ~= nil then return nil, "pick not allowed" end
      if fields.opponent ~= nil then return nil, "opponent not allowed" end
      return table.concat({ tostring(PROTOCOL), "INPUT", "going", occurrence }, FIELD)
    end
    if not isId(fields.characterId) then return nil, "invalid character id" end
    if fields.text ~= nil then
      if kind ~= "confession" or type(fields.text) ~= "string" then
        return nil, "text not allowed"
      end
    end
    if kind ~= "favor" then
      if fields.pick ~= nil then return nil, "pick not allowed" end
    else
      if fields.pick == nil then return nil, "pick required" end
      if not isId(fields.pick) then return nil, "invalid pick" end
    end
    local opponent = nil
    if fields.opponent ~= nil then
      if kind ~= "petition" then return nil, "opponent not allowed" end
      if type(fields.opponent) ~= "string" then return nil, "invalid opponent" end
      if fields.opponent:find(FIELD, 1, true) or fields.opponent:find("\n", 1, true) then
        return nil, "invalid opponent"
      end
      opponent = trim(fields.opponent)
    end
    local parts = { tostring(PROTOCOL), "INPUT", kind, fmtId(fields.characterId) }
    if kind == "confession" and type(fields.text) == "string" and fields.text ~= "" then
      parts[#parts + 1] = fields.text
    elseif kind == "favor" then
      parts[#parts + 1] = fmtId(fields.pick)
    elseif kind == "petition" and opponent then
      parts[#parts + 1] = opponent
    end
    return table.concat(parts, FIELD)
  end

  if msgType == "DECREE" then
    if firstUnknown(fields, DECREE_KEYS) then return nil, "unknown field" end
    local line = trim(fields.line)
    if not line then return nil, "line is required" end
    if line:find("\n", 1, true) then return nil, "invalid line" end
    if fields.flavor ~= nil and type(fields.flavor) ~= "string" then
      return nil, "invalid flavor"
    end
    local flavor = trim(fields.flavor)
    if flavor and flavor:find("\n", 1, true) then return nil, "invalid flavor" end
    local wire = table.concat({ tostring(PROTOCOL), "DECREE", line }, FIELD)
    if flavor then
      wire = wire .. "\n" .. flavor
    end
    return wire
  end

  if msgType == "NIGHTS" then
    if firstUnknown(fields, NIGHTS_KEYS) then return nil, "unknown field" end
    return encodeNightsMessage(fields)
  end

  if msgType == "STUB" then
    if firstUnknown(fields, STUB_KEYS) then return nil, "unknown field" end
    return encodeStubMessage(fields)
  end

  if msgType == "STUB_WITHDRAW" then
    if firstUnknown(fields, STUB_WITHDRAW_KEYS) then return nil, "unknown field" end
    local id = trim(fields.id)
    if not id then return nil, "id is required" end
    if id:find("\n", 1, true) or id:find("\t", 1, true) then return nil, "invalid id" end
    local rev = fields.boardRevision
    if rev ~= nil and not isSeq(rev) then return nil, "invalid revision" end
    local wire = table.concat({ tostring(PROTOCOL), "STUB_WITHDRAW", id }, FIELD)
    if type(rev) == "number" then
      wire = wire .. "\n" .. tostring(rev)
    end
    return wire
  end

  return nil, "unknown message type"
end

function Codec:Encode(msg)
  if type(msg) ~= "table" then return nil, "invalid message" end
  local msgType = trim(msg.type)
  if not msgType or not TYPES[msgType] then return nil, "unknown message type" end
  return encodeTyped(msgType, msg)
end

function Codec:EncodeState(fields)
  return encodeTyped("STATE", fields)
end

function Codec:EncodeSnapshot(fields)
  return encodeTyped("SNAPSHOT", fields)
end

function Codec:EncodeInput(fields)
  return encodeTyped("INPUT", fields)
end

function Codec:EncodeDecree(fields)
  return encodeTyped("DECREE", fields)
end

function Codec:EncodeNights(fields)
  return encodeTyped("NIGHTS", fields)
end

function Codec:EncodeStub(fields)
  return encodeTyped("STUB", fields)
end

function Codec:EncodeStubWithdraw(fields)
  return encodeTyped("STUB_WITHDRAW", fields)
end

--------------------------------------------------------------------------------
-- Decode
--------------------------------------------------------------------------------

local function decodeStateMessage(version, parts)
  local body, err = decodeStateFields(parts, 3)
  if not body then return nil, err end
  return {
    type = "STATE",
    version = version,
    eventId = body.eventId,
    state = body.state,
    riteType = body.riteType,
    subjects = {
      candidate = body.subjects.candidate,
      fighters = copyFighters(body.subjects.fighters),
    },
    sequence = body.sequence,
    favor = copyFavor(body.favor),
    names = copyNames(body.names),
  }
end

local function decodeSnapshotMessage(version, parts)
  local role = trim(parts[3])
  if not role or not SNAPSHOT_ROLES[role] then return nil, "invalid role" end
  if role == "request" then
    if #parts > 3 then return nil, "unknown field" end
    return { type = "SNAPSHOT", version = version, role = "request" }
  end
  local body, err = decodeStateFields(parts, 4)
  if not body then return nil, err end
  return {
    type = "SNAPSHOT",
    version = version,
    role = "response",
    eventId = body.eventId,
    state = body.state,
    riteType = body.riteType,
    subjects = {
      candidate = body.subjects.candidate,
      fighters = copyFighters(body.subjects.fighters),
    },
    sequence = body.sequence,
    favor = copyFavor(body.favor),
    names = copyNames(body.names),
  }
end

local function decodeDecreeMessage(version, payload)
  local first = payload:find(FIELD, 1, true)
  if not first then return nil, "line is required" end
  local second = payload:find(FIELD, first + 1, true)
  local body = ""
  if second then
    body = payload:sub(second + 1)
  end
  local line, flavor
  local nl = body:find("\n", 1, true)
  if nl then
    line = body:sub(1, nl - 1)
    flavor = trim(body:sub(nl + 1))
  else
    line = body
  end
  line = trim(line)
  if not line then return nil, "line is required" end
  return {
    type = "DECREE",
    version = version,
    line = line,
    flavor = flavor,
  }
end

local function payloadBody(payload)
  local first = payload:find(FIELD, 1, true)
  if not first then return "" end
  local second = payload:find(FIELD, first + 1, true)
  if not second then return "" end
  local body = payload:sub(second + 1)
  if body:sub(1, 1) == "\n" then
    body = body:sub(2)
  end
  return body
end

local function decodeNightsMessage(version, payload)
  local body = payloadBody(payload)
  local lines = {}
  for line in string.gmatch(body .. "\n", "([^\n]*)\n") do
    lines[#lines + 1] = line
  end
  local rev = tonumber(lines[1])
  local series, stubs, tombs, counts = {}, {}, {}, {}
  for i = 2, #lines do
    local line = lines[i]
    if line ~= "" then
      local cols = split(line, "\t")
      local tag = cols[1]
      if tag == "S" then
        series[#series + 1] = {
          id = tonumber(cols[2]),
          kind = cols[3],
          weekday = tonumber(cols[4]),
          timeLine = cols[5],
          place = cols[6],
          flavor = cols[7] ~= "" and cols[7] or nil,
          withdrawn = cols[8] == "1",
          oneshotDate = cols[9] ~= "" and cols[9] or nil,
          skip = {},
          move = {},
        }
      elseif tag == "K" then
        local sid = tonumber(cols[2])
        local date = cols[3]
        if sid and date then
          for si = 1, #series do
            if series[si].id == sid then
              series[si].skip[date] = true
            end
          end
        end
      elseif tag == "M" then
        local sid = tonumber(cols[2])
        local date = cols[3]
        if sid and date then
          for si = 1, #series do
            if series[si].id == sid then
              series[si].move[date] = { timeLine = cols[4], place = cols[5] }
            end
          end
        end
      elseif tag == "U" then
        stubs[#stubs + 1] = {
          id = cols[2],
          kind = cols[3],
          title = cols[4],
          timeLine = cols[5],
          place = cols[6],
          date = cols[7],
          createdBy = cols[8] ~= "" and cols[8] or nil,
          updatedAt = tonumber(cols[9]),
        }
      elseif tag == "T" then
        tombs[#tombs + 1] = cols[2]
      elseif tag == "G" then
        counts[cols[2]] = tonumber(cols[3]) or 0
      end
    end
  end
  return {
    type = "NIGHTS",
    version = version,
    boardRevision = rev,
    series = series,
    stubs = stubs,
    stubTombstones = tombs,
    goingCounts = counts,
  }
end

local function decodeStubMessage(version, payload)
  local body = payloadBody(payload)
  local cols = split(body, "\t")
  if #cols < 6 then return nil, "stub is required" end
  return {
    type = "STUB",
    version = version,
    id = cols[1],
    kind = cols[2],
    title = cols[3],
    timeLine = cols[4],
    place = cols[5],
    date = cols[6],
    createdBy = cols[7] ~= "" and cols[7] or nil,
    updatedAt = tonumber(cols[8]),
    boardRevision = tonumber(cols[9]),
  }
end

local function decodeStubWithdrawMessage(version, payload)
  local first = payload:find(FIELD, 1, true)
  if not first then return nil, "id is required" end
  local second = payload:find(FIELD, first + 1, true)
  if not second then return nil, "id is required" end
  local rest = payload:sub(second + 1)
  local nl = rest:find("\n", 1, true)
  local id, rev
  if nl then
    id = trim(rest:sub(1, nl - 1))
    rev = tonumber(rest:sub(nl + 1))
  else
    id = trim(rest)
  end
  if not id then return nil, "id is required" end
  return {
    type = "STUB_WITHDRAW",
    version = version,
    id = id,
    boardRevision = rev,
  }
end

local function decodeInputMessage(version, parts)
  local kind = trim(parts[3])
  if not kind or not INPUT_KINDS[kind] then return nil, "invalid kind" end
  if kind == "going" then
    if #parts ~= 4 then return nil, "invalid going" end
    local occurrence = trim(parts[4])
    if not occurrence then return nil, "occurrence is required" end
    return {
      type = "INPUT",
      version = version,
      kind = "going",
      occurrence = occurrence,
    }
  end
  local characterId = parseId(parts[4])
  if not characterId then return nil, "invalid character id" end
  if kind == "favor" then
    if #parts < 5 then return nil, "pick required" end
    if #parts > 5 then return nil, "text not allowed" end
    local pick = parseId(parts[5])
    if not pick then return nil, "invalid pick" end
    return {
      type = "INPUT",
      version = version,
      kind = "favor",
      characterId = characterId,
      pick = pick,
    }
  end
  if kind == "petition" then
    if #parts > 5 then return nil, "text not allowed" end
    local opponent = nil
    if #parts == 5 then
      local raw = parts[5]
      if type(raw) == "string" and raw:find("\n", 1, true) then
        return nil, "invalid opponent"
      end
      opponent = trim(raw)
    end
    return {
      type = "INPUT",
      version = version,
      kind = "petition",
      characterId = characterId,
      opponent = opponent,
    }
  end
  if kind == "going" then
    if #parts ~= 4 then return nil, "invalid going" end
    local occurrence = trim(parts[4])
    if not occurrence then return nil, "occurrence is required" end
    return {
      type = "INPUT",
      version = version,
      kind = "going",
      occurrence = occurrence,
    }
  end
  if kind ~= "confession" then
    if #parts > 4 then return nil, "text not allowed" end
    return {
      type = "INPUT",
      version = version,
      kind = kind,
      characterId = characterId,
    }
  end
  local text = nil
  if #parts >= 5 then
    text = table.concat(parts, FIELD, 5)
    if text == "" then text = nil end
  end
  return {
    type = "INPUT",
    version = version,
    kind = "confession",
    characterId = characterId,
    text = text,
  }
end

function Codec:Decode(payload)
  if type(payload) ~= "string" or payload == "" then return nil, "empty payload" end
  local parts = split(payload, FIELD)
  local version = finite(parts[1])
  if not version then return nil, "no protocol version" end
  local msgType = trim(parts[2])
  if not msgType then return nil, "no message type" end
  if not TYPES[msgType] then return nil, "unknown message type" end

  if msgType == "STATE" then return decodeStateMessage(version, parts) end
  if msgType == "SNAPSHOT" then return decodeSnapshotMessage(version, parts) end
  if msgType == "INPUT" then return decodeInputMessage(version, parts) end
  if msgType == "DECREE" then return decodeDecreeMessage(version, payload) end
  if msgType == "NIGHTS" then return decodeNightsMessage(version, payload) end
  if msgType == "STUB" then return decodeStubMessage(version, payload) end
  if msgType == "STUB_WITHDRAW" then return decodeStubWithdrawMessage(version, payload) end
  return nil, "unknown message type"
end

function Codec:DecodeState(payload)
  local msg, err = self:Decode(payload)
  if not msg then return nil, err end
  if msg.type ~= "STATE" then return nil, "unknown message type" end
  return msg
end

function Codec:DecodeSnapshot(payload)
  local msg, err = self:Decode(payload)
  if not msg then return nil, err end
  if msg.type ~= "SNAPSHOT" then return nil, "unknown message type" end
  return msg
end

function Codec:DecodeInput(payload)
  local msg, err = self:Decode(payload)
  if not msg then return nil, err end
  if msg.type ~= "INPUT" then return nil, "unknown message type" end
  return msg
end

function Codec:IsCompatible(version)
  return finite(version) == self.PROTOCOL
end
