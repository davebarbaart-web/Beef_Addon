ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Sacred Archive codec (Bible §13.5). Not a second writer (Law 5).
-- Export stamps a Store snapshot string. Import calls Store:Restore only after
-- integrity and schema checks pass. A missing or bad archive is not a wipe (Law 7).
local Archive = {}
COB.Archive = Archive

local MAGIC = "COBARCH1"

local SNAP_KEYS = {
  humans = true,
  characters = true,
  ceremonyLog = true,
  markedMoments = true,
  nextHumanId = true,
  nextCharacterId = true,
  nextCeremonyId = true,
  nextMomentId = true,
}

local function digest(text)
  local h = 5381
  for i = 1, #text do
    h = (h * 33 + text:byte(i)) % 2147483647
  end
  return string.format("%08x", h)
end

local function isArray(value)
  if type(value) ~= "table" then return false end
  local n = 0
  for k, _ in pairs(value) do
    if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then return false end
    n = n + 1
  end
  return n == #value
end

local function isNextId(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

local function isGrantShaped(key)
  if type(key) ~= "string" then return false end
  local lower = string.lower(key)
  if lower == "points" or lower == "standing" then return true end
  return string.sub(lower, 1, 5) == "grant"
end

local function encodeString(text)
  local parts = { '"' }
  for i = 1, #text do
    local c = text:sub(i, i)
    local b = text:byte(i)
    if c == "\\" then
      parts[#parts + 1] = "\\\\"
    elseif c == '"' then
      parts[#parts + 1] = "\\\""
    elseif c == "\n" then
      parts[#parts + 1] = "\\n"
    elseif c == "\r" then
      parts[#parts + 1] = "\\r"
    elseif c == "\t" then
      parts[#parts + 1] = "\\t"
    elseif b < 32 then
      parts[#parts + 1] = string.format("\\u%04x", b)
    else
      parts[#parts + 1] = c
    end
  end
  parts[#parts + 1] = '"'
  return table.concat(parts)
end

local function encode(value)
  local t = type(value)
  if t == "boolean" then
    if value then return "true" end
    return "false"
  end
  if t == "number" then
    if value ~= value or value == math.huge or value == -math.huge then
      return nil, "unsupported number"
    end
    if value == math.floor(value) then
      return string.format("%.0f", value)
    end
    return tostring(value)
  end
  if t == "string" then
    return encodeString(value)
  end
  if t ~= "table" then
    return nil, "unsupported type"
  end
  if isArray(value) then
    local parts = {}
    for i = 1, #value do
      local chunk, err = encode(value[i])
      if not chunk then return nil, err end
      parts[i] = chunk
    end
    return "[" .. table.concat(parts, ",") .. "]"
  end
  local keys = {}
  for k, _ in pairs(value) do
    keys[#keys + 1] = k
  end
  table.sort(keys, function(a, b)
    local ta, tb = type(a), type(b)
    if ta == "number" and tb == "number" then return a < b end
    if ta == "number" then return true end
    if tb == "number" then return false end
    return tostring(a) < tostring(b)
  end)
  local parts = {}
  for i = 1, #keys do
    local key = keys[i]
    local chunk, err = encode(value[key])
    if not chunk then return nil, err end
    parts[#parts + 1] = encodeString(tostring(key)) .. ":" .. chunk
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function decode(text)
  if type(text) ~= "string" then return nil, "truncated or tampered" end
  local pos = 1
  local len = #text

  local function skip()
    while pos <= len do
      local b = text:byte(pos)
      if b == 32 or b == 9 or b == 10 or b == 13 then
        pos = pos + 1
      else
        break
      end
    end
  end

  local function peek()
    return text:sub(pos, pos)
  end

  local parseValue

  local function parseString()
    if peek() ~= '"' then return nil, "truncated or tampered" end
    pos = pos + 1
    local parts = {}
    while pos <= len do
      local c = text:sub(pos, pos)
      if c == '"' then
        pos = pos + 1
        return table.concat(parts)
      end
      if c == "\\" then
        pos = pos + 1
        if pos > len then return nil, "truncated or tampered" end
        local e = text:sub(pos, pos)
        if e == '"' or e == "\\" or e == "/" then
          parts[#parts + 1] = e
        elseif e == "n" then
          parts[#parts + 1] = "\n"
        elseif e == "r" then
          parts[#parts + 1] = "\r"
        elseif e == "t" then
          parts[#parts + 1] = "\t"
        elseif e == "u" then
          local hex = text:sub(pos + 1, pos + 4)
          if not hex:match("^[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$") then
            return nil, "truncated or tampered"
          end
          local code = tonumber(hex, 16)
          if not code or code > 255 then return nil, "truncated or tampered" end
          parts[#parts + 1] = string.char(code)
          pos = pos + 4
        else
          return nil, "truncated or tampered"
        end
        pos = pos + 1
      else
        parts[#parts + 1] = c
        pos = pos + 1
      end
    end
    return nil, "truncated or tampered"
  end

  local function parseNumber()
    local start = pos
    if peek() == "-" then pos = pos + 1 end
    if pos > len or not text:sub(pos, pos):match("%d") then
      return nil, "truncated or tampered"
    end
    while pos <= len and text:sub(pos, pos):match("%d") do
      pos = pos + 1
    end
    if peek() == "." then
      pos = pos + 1
      if not text:sub(pos, pos):match("%d") then return nil, "truncated or tampered" end
      while pos <= len and text:sub(pos, pos):match("%d") do
        pos = pos + 1
      end
    end
    local n = tonumber(text:sub(start, pos - 1))
    if not n then return nil, "truncated or tampered" end
    return n
  end

  local function parseArray()
    pos = pos + 1
    skip()
    local list = {}
    if peek() == "]" then
      pos = pos + 1
      return list
    end
    while true do
      local value, err = parseValue()
      if err then return nil, err end
      list[#list + 1] = value
      skip()
      local c = peek()
      if c == "]" then
        pos = pos + 1
        return list
      end
      if c ~= "," then return nil, "truncated or tampered" end
      pos = pos + 1
      skip()
    end
  end

  local function parseObject()
    pos = pos + 1
    skip()
    local obj = {}
    if peek() == "}" then
      pos = pos + 1
      return obj
    end
    while true do
      skip()
      local key, err = parseString()
      if err then return nil, err end
      skip()
      if peek() ~= ":" then return nil, "truncated or tampered" end
      pos = pos + 1
      skip()
      local value, verr = parseValue()
      if verr then return nil, verr end
      obj[key] = value
      skip()
      local c = peek()
      if c == "}" then
        pos = pos + 1
        return obj
      end
      if c ~= "," then return nil, "truncated or tampered" end
      pos = pos + 1
    end
  end

  function parseValue()
    skip()
    if pos > len then return nil, "truncated or tampered" end
    local c = peek()
    if c == '"' then return parseString() end
    if c == "{" then return parseObject() end
    if c == "[" then return parseArray() end
    if c == "t" and text:sub(pos, pos + 3) == "true" then
      pos = pos + 4
      return true
    end
    if c == "f" and text:sub(pos, pos + 4) == "false" then
      pos = pos + 5
      return false
    end
    if c == "n" and text:sub(pos, pos + 3) == "null" then
      pos = pos + 4
      return nil
    end
    if c == "-" or c:match("%d") then return parseNumber() end
    return nil, "truncated or tampered"
  end

  local value, err = parseValue()
  if err then return nil, err end
  skip()
  if pos <= len then return nil, "truncated or tampered" end
  return value
end

local function walkBanned(value)
  if type(value) ~= "table" then return nil end
  for key, child in pairs(value) do
    if isGrantShaped(key) then
      return "points, standing, or Grant-shaped key"
    end
    if key == "narration" then
      return "narration"
    end
    local err = walkBanned(child)
    if err then return err end
  end
  return nil
end

local function knownRank(rankId)
  if rankId == nil then return true end
  if type(rankId) ~= "number" or rankId ~= math.floor(rankId) or rankId < 1 then
    return false
  end
  return COB.Ranks and COB.Ranks.ById and COB.Ranks.ById[rankId] ~= nil
end

local function validate(snap)
  if type(snap) ~= "table" then return nil, "empty snapshot" end
  local empty = true
  for _ in pairs(snap) do
    empty = false
    break
  end
  if empty then return nil, "empty snapshot" end

  for key, _ in pairs(snap) do
    if not SNAP_KEYS[key] then return nil, "foreign payload" end
  end

  if snap.humans == nil or snap.characters == nil then
    return nil, "empty snapshot"
  end
  if type(snap.humans) ~= "table" or not isArray(snap.humans) then
    return nil, "humans must be an array"
  end
  if type(snap.characters) ~= "table" or not isArray(snap.characters) then
    return nil, "characters must be an array"
  end
  if type(snap.ceremonyLog) ~= "table" or not isArray(snap.ceremonyLog) then
    return nil, "empty snapshot"
  end
  if type(snap.markedMoments) ~= "table" or not isArray(snap.markedMoments) then
    return nil, "empty snapshot"
  end
  if not isNextId(snap.nextHumanId) or not isNextId(snap.nextCharacterId)
      or not isNextId(snap.nextCeremonyId) or not isNextId(snap.nextMomentId) then
    return nil, "foreign payload"
  end

  local banned = walkBanned(snap)
  if banned then return nil, banned end

  for i = 1, #snap.humans do
    local row = snap.humans[i]
    if type(row) ~= "table" then return nil, "humans must be an array" end
    if not knownRank(row.rankId) then return nil, "unknown rank id" end
  end
  for i = 1, #snap.characters do
    if type(snap.characters[i]) ~= "table" then
      return nil, "characters must be an array"
    end
  end
  return true
end

local function stamp(body)
  return MAGIC .. "\n" .. digest(body) .. "\n" .. body
end

local function unstamp(blob)
  if blob == nil then return nil, "missing archive" end
  if type(blob) ~= "string" then return nil, "foreign payload" end
  if blob == "" or blob:match("^%s+$") then return nil, "empty archive" end

  if blob:sub(1, #MAGIC) ~= MAGIC then return nil, "foreign payload" end
  local rest = blob:sub(#MAGIC + 1)
  if rest:sub(1, 1) == "\r" then rest = rest:sub(2) end
  if rest:sub(1, 1) ~= "\n" then return nil, "foreign payload" end
  rest = rest:sub(2)

  local nl = rest:find("\n", 1, true)
  if not nl then return nil, "truncated or tampered" end
  local sum = rest:sub(1, nl - 1)
  if sum:sub(-1) == "\r" then sum = sum:sub(1, -2) end
  if not sum:match("^[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$") then
    return nil, "truncated or tampered"
  end
  local body = rest:sub(nl + 1)
  if digest(body) ~= string.lower(sum) then
    return nil, "truncated or tampered"
  end
  return body
end

local function open(blob)
  local body, err = unstamp(blob)
  if not body then return nil, err end
  if body == "" then return nil, "empty snapshot" end
  local snap, decErr = decode(body)
  if decErr then return nil, decErr end
  local ok, valErr = validate(snap)
  if not ok then return nil, valErr end
  return snap
end

function Archive:Export()
  if not COB.Store or type(COB.Store.Snapshot) ~= "function" then
    return nil, "store snapshot unavailable"
  end
  local snap = COB.Store:Snapshot()
  if type(snap) ~= "table" then return nil, "empty snapshot" end
  local body, err = encode(snap)
  if not body then return nil, err end
  return stamp(body)
end

function Archive:Check(blob)
  local snap, err = open(blob)
  if not snap then return nil, err end
  return true
end

function Archive:Import(blob)
  local snap, err = open(blob)
  if not snap then return nil, err end
  if not COB.Store or type(COB.Store.Restore) ~= "function" then
    return nil, "store restore unavailable"
  end
  return COB.Store:Restore(snap)
end
