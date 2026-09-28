ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Nights board (Bible §14.1). Church series + Discord stubs + informational Going.
-- Core is a store: no frames, no Net, no SV writes. Authority is Console / Net.
-- Getters return copies. boardRevision bumps on night mutations only, not Going.
local Nights = {}
COB.Nights = Nights

local CHURCH = { gathering = true, knighting = true, gora = true }
local STUB = { raid = true, pvp = true }

local series = {}
local nextSeriesId = 1
local stubs = {}
local stubTombstones = {}
local stubSeq = {}
local goingNames = {}
local goingCounts = {}
local boardRevision = 0
local imported = false

local function trim(text)
  if COB.Names and COB.Names.Trim then
    return COB.Names.Trim(text)
  end
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function wall(now)
  if COB.Clock and COB.Clock.Wall then
    return COB.Clock.Wall(now)
  end
  if type(now) == "number" then return now end
  if type(time) == "function" then
    local t = time()
    if type(t) == "number" then return t end
  end
  return 0
end

local function copyTable(src)
  if type(src) ~= "table" then return nil end
  local out = {}
  for k, v in pairs(src) do
    if type(v) == "table" then
      out[k] = copyTable(v)
    else
      out[k] = v
    end
  end
  return out
end

local function bumpRevision()
  local known = boardRevision
  if type(known) ~= "number" then known = 0 end
  boardRevision = known + 1
  return boardRevision
end

local function mergeRevision(incoming)
  if type(incoming) ~= "number" then return boardRevision end
  if incoming > boardRevision then
    boardRevision = incoming
  end
  return boardRevision
end

local function validDate(text)
  text = trim(text)
  if not text then return nil end
  if not text:match("^%d%d%d%d%-%d%d%-%d%d$") then return nil end
  return text
end

local function dateParts(text)
  local y, m, d = text:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  if not y then return nil end
  return { year = tonumber(y), month = tonumber(m), day = tonumber(d) }
end

-- WoW exposes date() as a global and does not ship os.date / os.time.
-- The desktop harness has os; Anniversary has date() + time().
local function dateFn()
  if type(date) == "function" then return date end
  if type(os) == "table" and type(os.date) == "function" then return os.date end
  return nil
end

-- Howard Hinnant civil_from_days inverse. Days since 1970-01-01.
-- Used when os.time({year=,month=,day=}) is missing (the live client).
local function daysFromCivil(y, m, d)
  if type(y) ~= "number" or type(m) ~= "number" or type(d) ~= "number" then
    return nil
  end
  y = y - (m <= 2 and 1 or 0)
  local era = math.floor(y / 400)
  local yoe = y - era * 400
  local doy = math.floor((153 * (m + (m > 2 and -3 or 9)) + 2) / 5) + d - 1
  local doe = yoe * 365 + math.floor(yoe / 4) - math.floor(yoe / 100) + doy
  return era * 146097 + doe - 719468
end

local function ymdFromTs(ts)
  if type(ts) ~= "number" then return nil, nil end
  local fn = dateFn()
  if not fn then return nil, nil end
  local ok, t = pcall(fn, "*t", ts)
  if not ok or type(t) ~= "table" or type(t.year) ~= "number" then
    return nil, nil
  end
  return string.format("%04d-%02d-%02d", t.year, t.month, t.day), t.wday
end

local function tsFromYmd(ymd)
  local parts = dateParts(ymd)
  if not parts then return nil end
  if type(os) == "table" and type(os.time) == "function" then
    parts.hour = 12
    parts.min = 0
    parts.sec = 0
    local ts = os.time(parts)
    if type(ts) == "number" then return ts end
  end
  local days = daysFromCivil(parts.year, parts.month, parts.day)
  if type(days) ~= "number" then return nil end
  return days * 86400 + 12 * 3600
end

local function weekdayOf(date)
  local ts = tsFromYmd(date)
  if not ts then return nil end
  local _, wday = ymdFromTs(ts)
  return wday
end

local function addDays(date, days)
  local ts = tsFromYmd(date)
  if not ts then return nil end
  return ymdFromTs(ts + days * 86400)
end

local function dateInRange(date, startDate, endDate)
  if type(date) ~= "string" or type(startDate) ~= "string" or type(endDate) ~= "string" then
    return false
  end
  return date >= startDate and date <= endDate
end

local function occKey(seriesId, date)
  return tostring(seriesId) .. "/" .. date
end

local function copySeries(row)
  if not row then return nil end
  return {
    id = row.id,
    kind = row.kind,
    weekday = row.weekday,
    timeLine = row.timeLine,
    place = row.place,
    flavor = row.flavor,
    withdrawn = row.withdrawn and true or false,
    createdAt = row.createdAt,
    oneshotDate = row.oneshotDate,
    skip = copyTable(row.skip) or {},
    move = copyTable(row.move) or {},
  }
end

local function copyStub(row)
  if not row then return nil end
  return {
    id = row.id,
    kind = row.kind,
    title = row.title,
    timeLine = row.timeLine,
    place = row.place,
    date = row.date,
    createdBy = row.createdBy,
    updatedAt = row.updatedAt,
  }
end

local function findSeries(id)
  if type(id) ~= "number" then return nil end
  for i = 1, #series do
    if series[i].id == id then return series[i] end
  end
  return nil
end

local function parseChurch(fields)
  if type(fields) ~= "table" then return nil, "series must be a table" end
  local kind = fields.kind
  if not CHURCH[kind] then return nil, "unknown kind" end
  local timeLine = trim(fields.timeLine)
  local place = trim(fields.place)
  if not timeLine then return nil, "timeLine is required" end
  if not place then return nil, "place is required" end
  local oneshot = validDate(fields.oneshotDate)
  local weekday = fields.weekday
  if oneshot then
    weekday = nil
  else
    if type(weekday) ~= "number" or weekday < 1 or weekday > 7 or weekday ~= math.floor(weekday) then
      return nil, "weekday is required"
    end
  end
  return {
    kind = kind,
    weekday = weekday,
    timeLine = timeLine,
    place = place,
    flavor = trim(fields.flavor),
    oneshotDate = oneshot,
    skip = {},
    move = {},
    withdrawn = false,
  }
end

local function parseStub(fields)
  if type(fields) ~= "table" then return nil, "stub must be a table" end
  local kind = fields.kind
  if not STUB[kind] then return nil, "unknown kind" end
  local title = trim(fields.title)
  local timeLine = trim(fields.timeLine)
  local place = trim(fields.place)
  local date = validDate(fields.date)
  if not title then return nil, "title is required" end
  if not timeLine then return nil, "timeLine is required" end
  if not place then return nil, "place is required" end
  if not date then return nil, "date is required" end
  local createdBy = trim(fields.createdBy)
  if createdBy and COB.Names and COB.Names.Key then
    createdBy = COB.Names.Key(createdBy)
  end
  return {
    kind = kind,
    title = title,
    timeLine = timeLine,
    place = place,
    date = date,
    createdBy = createdBy,
  }
end

local function allocateStubId(createdBy)
  local key = createdBy or "unknown"
  local n = stubSeq[key] or 0
  n = n + 1
  stubSeq[key] = n
  return key .. ":" .. tostring(n)
end

local function rememberStubSeq(id)
  if type(id) ~= "string" then return end
  local key, n = id:match("^(.*):(%d+)$")
  n = tonumber(n)
  if not key or not n then return end
  if not stubSeq[key] or n > stubSeq[key] then
    stubSeq[key] = n
  end
end

local function setGoingCountFromNames(key)
  local names = goingNames[key]
  local n = 0
  if type(names) == "table" then
    for _ in pairs(names) do
      n = n + 1
    end
  end
  goingCounts[key] = n
end

function Nights:ResetForTests()
  if not COB._IN_TEST then return false end
  series = {}
  nextSeriesId = 1
  stubs = {}
  stubTombstones = {}
  stubSeq = {}
  goingNames = {}
  goingCounts = {}
  boardRevision = 0
  imported = false
  return true
end

function Nights:BoardRevision()
  return boardRevision
end

function Nights:SetSeries(fields, now)
  local parsed, err = parseChurch(fields)
  if not parsed then return nil, err end
  parsed.id = nextSeriesId
  nextSeriesId = nextSeriesId + 1
  parsed.createdAt = wall(now)
  series[#series + 1] = parsed
  bumpRevision()
  return copySeries(parsed)
end

function Nights:SkipWeek(seriesId, date)
  local row = findSeries(seriesId)
  if not row then return nil, "unknown series" end
  date = validDate(date)
  if not date then return nil, "date is required" end
  row.skip[date] = true
  row.move[date] = nil
  bumpRevision()
  return copySeries(row)
end

function Nights:MoveWeek(seriesId, date, fields)
  local row = findSeries(seriesId)
  if not row then return nil, "unknown series" end
  date = validDate(date)
  if not date then return nil, "date is required" end
  if type(fields) ~= "table" then return nil, "move must be a table" end
  local timeLine = trim(fields.timeLine) or row.timeLine
  local place = trim(fields.place) or row.place
  row.move[date] = { timeLine = timeLine, place = place }
  row.skip[date] = nil
  bumpRevision()
  return copySeries(row)
end

function Nights:WithdrawSeries(seriesId)
  local row = findSeries(seriesId)
  if not row then return nil, "unknown series" end
  row.withdrawn = true
  bumpRevision()
  return copySeries(row)
end

function Nights:SetStub(fields, now)
  local parsed, err = parseStub(fields)
  if not parsed then return nil, err end
  local id = trim(fields.id)
  if id and stubTombstones[id] then
    return nil, "stub withdrawn"
  end
  if not id then
    id = allocateStubId(parsed.createdBy)
  else
    rememberStubSeq(id)
  end
  parsed.id = id
  parsed.updatedAt = wall(now)
  stubs[id] = parsed
  bumpRevision()
  return copyStub(parsed)
end

function Nights:WithdrawStub(id)
  id = trim(id)
  if not id then return nil, "id is required" end
  stubTombstones[id] = true
  stubs[id] = nil
  bumpRevision()
  return true
end

function Nights:ApplyStub(fields, now)
  local parsed, err = parseStub(fields)
  if not parsed then return nil, err end
  local id = trim(fields.id)
  if not id then return nil, "id is required" end
  if stubTombstones[id] then
    return nil, "stub withdrawn"
  end
  rememberStubSeq(id)
  parsed.id = id
  parsed.updatedAt = wall(fields.updatedAt or now)
  local prior = stubs[id]
  if prior and type(prior.updatedAt) == "number" and type(parsed.updatedAt) == "number"
      and parsed.updatedAt < prior.updatedAt then
    mergeRevision(fields.boardRevision)
    return copyStub(prior)
  end
  stubs[id] = parsed
  mergeRevision(fields.boardRevision)
  if type(fields.boardRevision) ~= "number" then
    bumpRevision()
  end
  return copyStub(parsed)
end

function Nights:ApplyTombstone(id, incomingRevision)
  id = trim(id)
  if not id then return nil, "id is required" end
  stubTombstones[id] = true
  stubs[id] = nil
  mergeRevision(incomingRevision)
  if type(incomingRevision) ~= "number" then
    bumpRevision()
  end
  return true
end

function Nights:SetGoing(occurrenceKey, character, flag)
  occurrenceKey = trim(occurrenceKey)
  if not occurrenceKey then return nil, "occurrence is required" end
  if occurrenceKey:match("^stub/") then
    return nil, "going is church only"
  end
  local key
  if COB.Names and COB.Names.Key then
    key = COB.Names.Key(character)
  else
    key = trim(character)
  end
  if not key then return nil, "character is required" end
  if flag ~= true then
    if goingNames[occurrenceKey] then
      goingNames[occurrenceKey][key] = nil
    end
    setGoingCountFromNames(occurrenceKey)
    return true
  end
  if type(goingNames[occurrenceKey]) ~= "table" then
    goingNames[occurrenceKey] = {}
  end
  goingNames[occurrenceKey][key] = true
  setGoingCountFromNames(occurrenceKey)
  return true
end

function Nights:IsGoing(occurrenceKey, character)
  occurrenceKey = trim(occurrenceKey)
  if not occurrenceKey then return false end
  local key
  if COB.Names and COB.Names.Key then
    key = COB.Names.Key(character)
  else
    key = trim(character)
  end
  if not key then return false end
  local names = goingNames[occurrenceKey]
  return type(names) == "table" and names[key] == true
end

function Nights:ListSeries()
  local out = {}
  for i = 1, #series do
    out[i] = copySeries(series[i])
  end
  return out
end

function Nights:ListStubs()
  local out, i = {}, 1
  for _, row in pairs(stubs) do
    if not stubTombstones[row.id] then
      out[i] = copyStub(row)
      i = i + 1
    end
  end
  table.sort(out, function(a, b)
    return tostring(a.id) < tostring(b.id)
  end)
  return out
end

function Nights:CountGoing(occurrenceKey)
  occurrenceKey = trim(occurrenceKey)
  if not occurrenceKey then return 0 end
  local n = goingCounts[occurrenceKey]
  if type(n) == "number" then return n end
  local names = goingNames[occurrenceKey]
  if type(names) ~= "table" then return 0 end
  local count = 0
  for _ in pairs(names) do
    count = count + 1
  end
  return count
end

function Nights:ListGoing(occurrenceKey)
  occurrenceKey = trim(occurrenceKey)
  local names = occurrenceKey and goingNames[occurrenceKey]
  if type(names) ~= "table" then return {} end
  local out, i = {}, 1
  for key in pairs(names) do
    out[i] = key
    i = i + 1
  end
  table.sort(out)
  return out
end

function Nights:SetGoingCounts(counts)
  if type(counts) ~= "table" then return nil, "counts must be a table" end
  for key, n in pairs(counts) do
    if type(key) == "string" and type(n) == "number" then
      goingCounts[key] = n
    end
  end
  return true
end

local function emitSeriesRow(row, date)
  if row.withdrawn then return nil end
  if row.skip[date] then return nil end
  local timeLine, place, flavor = row.timeLine, row.place, row.flavor
  local moved = row.move[date]
  if moved then
    timeLine = moved.timeLine or timeLine
    place = moved.place or place
  end
  local key = occKey(row.id, date)
  return {
    key = key,
    source = "series",
    seriesId = row.id,
    kind = row.kind,
    date = date,
    timeLine = timeLine,
    place = place,
    flavor = flavor,
    goingCount = Nights:CountGoing(key),
  }
end

local function emitStubRow(row)
  if stubTombstones[row.id] then return nil end
  return {
    key = "stub/" .. row.id,
    source = "stub",
    stubId = row.id,
    kind = row.kind,
    title = row.title,
    date = row.date,
    timeLine = row.timeLine,
    place = row.place,
    cue = "Sign up on Discord",
    goingCount = 0,
  }
end

function Nights:Board(now, days)
  if type(days) ~= "number" or days < 1 then
    days = 7
  end
  local ts = wall(now)
  local startDate = ymdFromTs(ts)
  if not startDate then return {} end
  local endDate = addDays(startDate, days - 1)
  local rows = {}

  for i = 1, #series do
    local row = series[i]
    if row.oneshotDate then
      if dateInRange(row.oneshotDate, startDate, endDate) then
        local emitted = emitSeriesRow(row, row.oneshotDate)
        if emitted then rows[#rows + 1] = emitted end
      end
    elseif type(row.weekday) == "number" then
      for offset = 0, days - 1 do
        local date = addDays(startDate, offset)
        if date and weekdayOf(date) == row.weekday then
          local emitted = emitSeriesRow(row, date)
          if emitted then rows[#rows + 1] = emitted end
        end
      end
    end
  end

  for _, row in pairs(stubs) do
    if row.date and dateInRange(row.date, startDate, endDate) then
      local emitted = emitStubRow(row)
      if emitted then rows[#rows + 1] = emitted end
    end
  end

  table.sort(rows, function(a, b)
    if a.date ~= b.date then return a.date < b.date end
    if a.kind ~= b.kind then return a.kind < b.kind end
    local an = a.title or a.place or ""
    local bn = b.title or b.place or ""
    return an < bn
  end)
  return rows
end

function Nights:Week(now)
  return self:Board(now, 7)
end

function Nights:Month(now)
  return self:Board(now, 28)
end

function Nights:ImportDecree(line, flavor, now)
  line = trim(line)
  if not line then return nil, "line is required" end
  if imported then
    return nil, "already imported"
  end
  local ts = wall(now)
  local date = ymdFromTs(ts)
  local posted, err = self:SetSeries({
    kind = "gathering",
    timeLine = line,
    place = line,
    flavor = flavor,
    oneshotDate = date,
  }, now)
  if posted then
    imported = true
  end
  return posted, err
end

function Nights:Snapshot()
  local seriesOut = {}
  for i = 1, #series do
    seriesOut[i] = copySeries(series[i])
  end
  local stubOut = {}
  local i = 1
  for _, row in pairs(stubs) do
    stubOut[i] = copyStub(row)
    i = i + 1
  end
  table.sort(stubOut, function(a, b)
    return tostring(a.id) < tostring(b.id)
  end)
  local tombs = {}
  i = 1
  for id in pairs(stubTombstones) do
    tombs[i] = id
    i = i + 1
  end
  table.sort(tombs)
  local counts = {}
  for key, n in pairs(goingCounts) do
    counts[key] = n
  end
  local names = {}
  for key, set in pairs(goingNames) do
    names[key] = copyTable(set)
  end
  return {
    series = seriesOut,
    stubs = stubOut,
    stubTombstones = tombs,
    goingCounts = counts,
    goingNames = names,
    boardRevision = boardRevision,
    nextSeriesId = nextSeriesId,
    imported = imported or nil,
  }
end

local function replaceSeries(list)
  series = {}
  nextSeriesId = 1
  if type(list) ~= "table" then return end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and type(row.id) == "number" then
      local parsed = parseChurch(row)
      if parsed then
        parsed.id = row.id
        parsed.createdAt = row.createdAt
        parsed.withdrawn = row.withdrawn and true or false
        parsed.oneshotDate = validDate(row.oneshotDate)
        parsed.skip = copyTable(row.skip) or {}
        parsed.move = copyTable(row.move) or {}
        series[#series + 1] = parsed
        if row.id >= nextSeriesId then
          nextSeriesId = row.id + 1
        end
      end
    end
  end
end

function Nights:Restore(snap)
  if type(snap) ~= "table" then return nil, "snapshot must be a table" end
  if type(snap.series) ~= "table" and type(snap.stubs) ~= "table"
      and type(snap.boardRevision) ~= "number" then
    return nil, "nights snapshot required"
  end
  replaceSeries(snap.series)
  stubs = {}
  stubTombstones = {}
  stubSeq = {}
  if type(snap.stubTombstones) == "table" then
    for i = 1, #snap.stubTombstones do
      local id = trim(snap.stubTombstones[i])
      if id then stubTombstones[id] = true end
    end
  end
  if type(snap.stubs) == "table" then
    for i = 1, #snap.stubs do
      local row = snap.stubs[i]
      if type(row) == "table" and type(row.id) == "string" and not stubTombstones[row.id] then
        local parsed = parseStub(row)
        if parsed then
          parsed.id = row.id
          parsed.updatedAt = row.updatedAt
          parsed.createdBy = row.createdBy
          stubs[row.id] = parsed
          rememberStubSeq(row.id)
        end
      end
    end
  end
  goingNames = {}
  goingCounts = {}
  if type(snap.goingNames) == "table" then
    for key, set in pairs(snap.goingNames) do
      if type(key) == "string" and type(set) == "table" then
        goingNames[key] = copyTable(set)
        setGoingCountFromNames(key)
      end
    end
  end
  if type(snap.goingCounts) == "table" then
    for key, n in pairs(snap.goingCounts) do
      if type(key) == "string" and type(n) == "number" then
        goingCounts[key] = n
      end
    end
  end
  if type(snap.nextSeriesId) == "number" and snap.nextSeriesId > nextSeriesId then
    nextSeriesId = snap.nextSeriesId
  end
  imported = snap.imported == true
  boardRevision = 0
  mergeRevision(snap.boardRevision)
  return true
end

-- Pope NIGHTS apply: series + going are truth; stubs upsert; unknown local stubs stay;
-- tombstones win; revision max-merges and never lowers.
function Nights:ApplyBroadcast(snap)
  if type(snap) ~= "table" then return nil, "snapshot must be a table" end
  replaceSeries(snap.series)
  if type(snap.goingNames) == "table" then
    goingNames = {}
    for key, set in pairs(snap.goingNames) do
      if type(key) == "string" and type(set) == "table" then
        goingNames[key] = copyTable(set)
        setGoingCountFromNames(key)
      end
    end
  end
  if type(snap.goingCounts) == "table" then
    goingCounts = {}
    for key, n in pairs(snap.goingCounts) do
      if type(key) == "string" and type(n) == "number" then
        goingCounts[key] = n
      end
    end
  end
  if type(snap.stubTombstones) == "table" then
    for i = 1, #snap.stubTombstones do
      local id = trim(snap.stubTombstones[i])
      if id then
        stubTombstones[id] = true
        stubs[id] = nil
      end
    end
  end
  if type(snap.stubs) == "table" then
    for i = 1, #snap.stubs do
      local row = snap.stubs[i]
      if type(row) == "table" and type(row.id) == "string" and not stubTombstones[row.id] then
        local parsed = parseStub(row)
        if parsed then
          parsed.id = row.id
          parsed.updatedAt = row.updatedAt
          parsed.createdBy = row.createdBy
          stubs[row.id] = parsed
          rememberStubSeq(row.id)
        end
      end
    end
  end
  if type(snap.nextSeriesId) == "number" and snap.nextSeriesId > nextSeriesId then
    nextSeriesId = snap.nextSeriesId
  end
  mergeRevision(snap.boardRevision)
  return true
end

function Nights:BroadcastSnapshot()
  local snap = self:Snapshot()
  snap.goingNames = nil
  return snap
end

function Nights:HasBoard(now)
  local rows = self:Week(now)
  return type(rows) == "table" and #rows > 0
end
