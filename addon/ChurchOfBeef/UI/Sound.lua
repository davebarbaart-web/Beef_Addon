ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode ceremonial cues (Bible §19.4). Verb only — no loop, no load play.
-- Quiet Mode is silent. No addon media. The later seal is out of scope.
-- Cue names map to FrameXML SOUNDKIT keys; PlaySound wants a kit id on 20506.
local Sound = {
  MODE = "Event",
}
COB.Sound = Sound

-- classic_anniversary FrameXML keys (search_source SOUNDKIT., flavor classic_anniversary).
local CUES = {
  sanction = "IG_QUEST_LOG_OPEN",
  verdict = "IG_QUEST_LIST_COMPLETE",
  elevation = "TALENT_SCREEN_OPEN",
  knighting = "IG_SPELLBOOK_OPEN",
  cowardice = "IG_QUEST_LOG_ABANDON_QUEST",
}

local function resolveKit(name)
  local key = CUES[name]
  if type(key) ~= "string" then
    return nil
  end
  local kits = _G.SOUNDKIT
  if type(kits) ~= "table" then
    return nil
  end
  local kit = kits[key]
  if type(kit) ~= "number" then
    return nil
  end
  return kit
end

local function fireKit(kit)
  if type(kit) ~= "number" then
    return
  end
  if type(PlaySound) == "function" then
    pcall(PlaySound, kit)
  end
  -- Anniversary aliases PlaySound = C_Sound.PlaySound; do not fire twice.
  local csound = C_Sound
  if type(csound) == "table" and type(csound.PlaySound) == "function" and csound.PlaySound ~= PlaySound then
    pcall(csound.PlaySound, kit)
  end
end

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

  fireKit(resolveKit(name))
  return name
end
