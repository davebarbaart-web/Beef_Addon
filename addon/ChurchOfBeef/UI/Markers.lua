ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode candidate / fighter raid marks (Bible §8).
-- Target + raid markers on the Pope's client. Fail-closed. No combat automation.
local Markers = {
  MODE = "Event",
}
COB.Markers = Markers

local last = { mode = "Event" }

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function parseName(name)
  if COB.Names and type(COB.Names.Trim) == "function" then
    return COB.Names.Trim(name)
  end
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" then return nil end
  return name
end

local function namesSame(a, b)
  if COB.Names and type(COB.Names.Same) == "function" then
    return COB.Names.Same(a, b)
  end
  return parseName(a) == parseName(b)
end

local function eventLive()
  local Runtime = COB.Runtime
  if not Runtime or type(Runtime.Snapshot) ~= "function" then return false end
  local snap = Runtime:Snapshot()
  return type(snap) == "table" and snap.state ~= nil and snap.state ~= "QUIET"
end

local function localSender()
  if COB.Group and type(COB.Group.PlayerName) == "function" then
    return COB.Group.PlayerName()
  end
  if type(UnitName) == "function" then
    local ok, name = pcall(UnitName, "player")
    if ok then return name end
  end
  return nil
end

local function isLocalPope()
  local Sender = COB.Sender
  if not Sender or type(Sender.IsRegisteredPope) ~= "function" then
    return false
  end
  return Sender:IsRegisteredPope(localSender()) == true
end

local function isGrouped()
  if type(IsInRaid) == "function" then
    local ok, inRaid = pcall(IsInRaid)
    if ok and inRaid then return true end
  end
  if type(IsInGroup) == "function" then
    local ok, inGroup = pcall(IsInGroup)
    if ok and inGroup then return true end
  end
  if type(GetNumGroupMembers) == "function" then
    local ok, n = pcall(GetNumGroupMembers)
    if ok and (tonumber(n) or 0) > 0 then return true end
  end
  return false
end

local function resolveUnit(name)
  if type(UnitName) ~= "function" then
    return nil
  end
  local pok, me = pcall(UnitName, "player")
  if pok and namesSame(me, name) then
    return "player"
  end
  if type(GetNumGroupMembers) ~= "function" then
    return nil
  end
  local ok, raw = pcall(GetNumGroupMembers)
  if not ok then return nil end
  local size = tonumber(raw) or 0
  if size <= 0 then return nil end
  local inRaid = false
  if type(IsInRaid) == "function" then
    local rok, raid = pcall(IsInRaid)
    inRaid = rok and raid and true or false
  end
  local prefix = inRaid and "raid" or "party"
  for i = 1, size do
    local unit = prefix .. i
    local uok, unitName = pcall(UnitName, unit)
    if uok and namesSame(unitName, name) then
      return unit
    end
  end
  return nil
end

local function applyMark(unit, index)
  if type(SetRaidTarget) ~= "function" then
    return false
  end
  local ok = pcall(SetRaidTarget, unit, index)
  if not ok then return false end
  if type(GetRaidTargetIndex) == "function" then
    pcall(GetRaidTargetIndex, unit)
  end
  return true
end

-- Index 0 on remembered last.unit / last.unitA / last.unitB that are not in
-- the new keep-set. Do not call Markers:Clear (it overwrites last first).
local function clearPrior(keepUnits)
  keepUnits = keepUnits or {}
  local seen = {}
  local function sweep(unit)
    if type(unit) ~= "string" or unit == "" then
      return
    end
    if keepUnits[unit] or seen[unit] then
      return
    end
    seen[unit] = true
    applyMark(unit, 0)
  end
  sweep(last.unit)
  sweep(last.unitA)
  sweep(last.unitB)
end

local function remember(fields)
  last = {
    mode = "Event",
    verb = fields.verb,
    ok = fields.ok == true,
    err = fields.err,
    name = fields.name,
    unit = fields.unit,
    index = fields.index,
    nameA = fields.nameA,
    nameB = fields.nameB,
    unitA = fields.unitA,
    unitB = fields.unitB,
    indexA = fields.indexA,
    indexB = fields.indexB,
  }
  if last.ok then
    return true
  end
  return false, last.err
end

local function keepLastUnits(fields)
  fields = fields or {}
  if fields.unit == nil then
    fields.unit = last.unit
  end
  if fields.index == nil then
    fields.index = last.index
  end
  if fields.unitA == nil then
    fields.unitA = last.unitA
  end
  if fields.unitB == nil then
    fields.unitB = last.unitB
  end
  if fields.indexA == nil then
    fields.indexA = last.indexA
  end
  if fields.indexB == nil then
    fields.indexB = last.indexB
  end
  if fields.nameA == nil then
    fields.nameA = last.nameA
  end
  if fields.nameB == nil then
    fields.nameB = last.nameB
  end
  return fields
end

local function refuse(verb, err, fields)
  fields = fields or {}
  fields.verb = verb
  fields.ok = false
  fields.err = err
  return remember(keepLastUnits(fields))
end

function Markers:Target(name)
  local trimmed = parseName(name)
  if not eventLive() then
    return refuse("Target", "quiet", { name = trimmed or name })
  end
  if not isLocalPope() then
    return refuse("Target", "not a registered pope", { name = trimmed or name })
  end
  if not trimmed then
    return refuse("Target", "invalid name")
  end
  if type(TargetUnit) ~= "function" then
    return refuse("Target", nil, { name = trimmed })
  end
  local ok = pcall(TargetUnit, trimmed, true)
  if not ok then
    return refuse("Target", nil, { name = trimmed })
  end
  return remember(keepLastUnits({ verb = "Target", ok = true, name = trimmed }))
end

function Markers:MarkCandidate(name)
  local trimmed = parseName(name)
  if not eventLive() then
    return refuse("MarkCandidate", "quiet", { name = trimmed or name })
  end
  if not isLocalPope() then
    return refuse("MarkCandidate", "not a registered pope", { name = trimmed or name })
  end
  if not trimmed then
    return refuse("MarkCandidate", "invalid name")
  end
  if not isGrouped() then
    return refuse("MarkCandidate", "not in a group", { name = trimmed })
  end
  local unit = resolveUnit(trimmed)
  if not unit then
    return refuse("MarkCandidate", "unit not found", { name = trimmed })
  end
  clearPrior({ [unit] = true })
  if not applyMark(unit, 1) then
    return refuse("MarkCandidate", nil, { name = trimmed, unit = unit, index = 1 })
  end
  return remember({
    verb = "MarkCandidate",
    ok = true,
    name = trimmed,
    unit = unit,
    index = 1,
  })
end

function Markers:MarkFighters(nameA, nameB)
  local a = parseName(nameA)
  local b = parseName(nameB)
  if not eventLive() then
    return refuse("MarkFighters", "quiet", { nameA = a or nameA, nameB = b or nameB })
  end
  if not isLocalPope() then
    return refuse("MarkFighters", "not a registered pope", { nameA = a or nameA, nameB = b or nameB })
  end
  if not a or not b then
    return refuse("MarkFighters", "invalid name", { nameA = a, nameB = b })
  end
  if not isGrouped() then
    return refuse("MarkFighters", "not in a group", { nameA = a, nameB = b })
  end
  local unitA = resolveUnit(a)
  local unitB = resolveUnit(b)
  if not unitA or not unitB then
    return refuse("MarkFighters", "unit not found", { nameA = a, nameB = b })
  end
  clearPrior({ [unitA] = true, [unitB] = true })
  if not applyMark(unitA, 2) or not applyMark(unitB, 3) then
    return refuse("MarkFighters", nil, {
      nameA = a,
      nameB = b,
      unitA = unitA,
      unitB = unitB,
      indexA = 2,
      indexB = 3,
    })
  end
  return remember({
    verb = "MarkFighters",
    ok = true,
    nameA = a,
    nameB = b,
    unitA = unitA,
    unitB = unitB,
    indexA = 2,
    indexB = 3,
  })
end

function Markers:Clear(name)
  local trimmed = parseName(name)
  if not eventLive() then
    return refuse("Clear", "quiet", { name = trimmed or name })
  end
  if not isLocalPope() then
    return refuse("Clear", "not a registered pope", { name = trimmed or name })
  end
  if not trimmed then
    return refuse("Clear", "invalid name")
  end
  if not isGrouped() then
    return refuse("Clear", "not in a group", { name = trimmed })
  end
  local unit = resolveUnit(trimmed)
  if not unit then
    return refuse("Clear", "unit not found", { name = trimmed })
  end
  if not applyMark(unit, 0) then
    return refuse("Clear", nil, { name = trimmed, unit = unit, index = 0 })
  end
  return remember({
    verb = "Clear",
    ok = true,
    name = trimmed,
    unit = unit,
    index = 0,
  })
end

function Markers:Forget()
  if not isLocalPope() then
    return refuse("Forget", "not a registered pope")
  end
  local seen = {}
  local leftover = false
  local applied = true
  local function sweep(unit)
    if type(unit) ~= "string" or unit == "" then
      return
    end
    leftover = true
    if seen[unit] then
      return
    end
    seen[unit] = true
    if not applyMark(unit, 0) then
      applied = false
    end
  end
  sweep(last.unit)
  sweep(last.unitA)
  sweep(last.unitB)
  if leftover and not applied then
    return refuse("Forget", nil)
  end
  return remember({
    verb = "Forget",
    ok = true,
  })
end

function Markers:GetView()
  return deepcopy(last)
end

function Markers:ResetForTests()
  if not COB._IN_TEST then return false end
  last = { mode = "Event" }
  return true
end
