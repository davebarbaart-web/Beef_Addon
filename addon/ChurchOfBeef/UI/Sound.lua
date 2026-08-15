ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode ceremonial cues (Bible §19.4). Verb only — no loop, no load play.
-- Quiet Mode is silent. No addon media. The later seal is out of scope.
local Sound = {
  MODE = "Event",
}
COB.Sound = Sound

local CUES = {
  sanction = true,
  verdict = true,
  elevation = true,
  knighting = true,
  cowardice = true,
}

function Sound:ResetForTests()
  if not COB._IN_TEST then return false end
  return true
end

function Sound:Play(name)
  if type(name) ~= "string" or not CUES[name] then
    return nil, "unknown cue"
  end

  local runtime = COB.Runtime
  if type(runtime) ~= "table" or type(runtime.Snapshot) ~= "function" then
    return nil, "runtime missing"
  end

  local snap = runtime:Snapshot()
  local state = type(snap) == "table" and snap.state or nil
  if state ~= "ASSEMBLY" and state ~= "RITE" and state ~= "CONSEQUENCE" then
    return nil, "quiet"
  end

  if type(PlaySound) == "function" then
    pcall(PlaySound, name)
  end
  return name
end
