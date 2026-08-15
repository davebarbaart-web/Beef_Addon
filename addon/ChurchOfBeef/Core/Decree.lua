ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Single active Decree (Bible §14.1). Stored fields: line + optional flavor.
-- Header "A GATHERING HAS BEEN DECREED" is UI copy, not stored.
-- No calendar, RSVP, deputy, expiry, wire, or Pope-list gate.
local Decree = {}
COB.Decree = Decree

local active = nil

local function trim(text)
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function copyOf(row)
  if not row then return nil end
  return { line = row.line, flavor = row.flavor }
end

local function parse(fields)
  if type(fields) ~= "table" then return nil, "decree must be a table" end
  local line = trim(fields.line)
  if not line then return nil, "line is required" end
  return { line = line, flavor = trim(fields.flavor) }
end

function Decree:ResetForTests()
  if not COB._IN_TEST then return false end
  active = nil
  return true
end

function Decree:Set(fields)
  local parsed, err = parse(fields)
  if not parsed then return nil, err end
  active = parsed
  return copyOf(active)
end

function Decree:Get()
  return copyOf(active)
end

function Decree:Clear()
  active = nil
end

function Decree:Snapshot()
  if not active then return {} end
  return copyOf(active)
end

function Decree:Restore(snap)
  if type(snap) ~= "table" then return nil, "snapshot must be a table" end
  if type(snap.line) ~= "string" then return nil, "line is required" end
  local parsed, err = parse(snap)
  if not parsed then return nil, err end
  active = parsed
  return true
end
