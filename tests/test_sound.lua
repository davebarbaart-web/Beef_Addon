-- Event Mode sound cues (Phase 5 Lane C). Isolated: Common + Runtime + Sound.
-- Quiet Mode is silent. MVP names only. No TOC / bootstrap / run.lua /
-- Runtime / Console / HUD / Gora / Knighting / Minimap / Toasts / MainFrame / Net.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed = 0
local failed = 0

if standalone then
  function assert_eq(a, b, msg)
    if a ~= b then
      failed = failed + 1
      print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
    else
      passed = passed + 1
    end
  end
  function assert_true(v, msg)
    assert_eq(not not v, true, msg)
  end
end

local played = {}
local filePlays = 0
local kitPlays = 0
local frames = 0
local chatSends = 0
local addonSends = 0

PlaySound = function(name)
  played[#played + 1] = name
end
PlaySoundFile = function()
  filePlays = filePlays + 1
end
PlaySoundKitID = function()
  kitPlays = kitPlays + 1
end
CreateFrame = function()
  frames = frames + 1
end
SendChatMessage = function()
  chatSends = chatSends + 1
end
SendAddonMessage = function()
  addonSends = addonSends + 1
end

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/UI/Sound.lua")

local COB = ChurchOfBeef
local Sound = COB.Sound
local Runtime = COB.Runtime

assert_eq(#played, 0, "file load plays nothing")
assert_eq(filePlays, 0, "file load does not call PlaySoundFile")
assert_eq(kitPlays, 0, "file load does not call PlaySoundKitID")
assert_eq(frames, 0, "Sound mints no frames on load")

local function reset()
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Sound:ResetForTests(), true, "Sound ResetForTests runs under _IN_TEST")
  played = {}
  filePlays = 0
  kitPlays = 0
  frames = 0
  chatSends = 0
  addonSends = 0
end

local function lastPlayed()
  return played[#played]
end

local ALLOWED = { "sanction", "verdict", "elevation", "knighting", "cowardice" }

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(Sound ~= nil, "COB.Sound exists")
assert_true(Runtime ~= nil, "isolated suite loads Runtime")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_eq(Sound.MODE, "Event", "Sound declares Event Mode")
assert_eq(type(Sound.Play), "function", "Play is the cue verb")
assert_eq(type(Sound.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(Sound.Init, nil, "Sound is a verb, not an Init loop")
assert_eq(Sound.Canonize, nil, "no Canonization cue this phase")
assert_eq(Sound.Canonization, nil, "no Canonization surface")
assert_eq(Sound.Grant, nil, "no Grant")
assert_eq(Sound.Standing, nil, "no standing")
assert_eq(Sound.Narrate, nil, "software does not narrate")
assert_eq(Sound.Announce, nil, "software does not announce")
assert_eq(Sound.Summon, nil, "no SUMMON chime")
assert_eq(Sound.Favor, nil, "no favor sting")
assert_eq(Sound.Ambient, nil, "no ambient loop")
assert_eq(Sound.Click, nil, "no UI click")
assert_eq(Sound.Login, nil, "no login jingle")

if standalone then
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.UI, nil, "isolated suite does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Snapshot, nil, "isolated suite does not load Snapshot")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Hud, nil, "isolated suite does not load the Fight HUD")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load the Records Book")
  assert_eq(COB.Decree, nil, "isolated suite does not load Decree")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
end

--------------------------------------------------------------------------------
-- Quiet Mode is silent. Default Runtime snapshot is QUIET.
--------------------------------------------------------------------------------
reset()
assert_eq(Runtime:Snapshot().state, "QUIET", "fresh runtime is QUIET")
for i = 1, #ALLOWED do
  local name = ALLOWED[i]
  local ok, err = Sound:Play(name)
  assert_eq(ok, nil, "QUIET plays no " .. name)
  assert_eq(type(err), "string", "QUIET " .. name .. " returns a reason")
end
assert_eq(#played, 0, "QUIET never calls PlaySound")
assert_eq(filePlays, 0, "QUIET never calls PlaySoundFile")

--------------------------------------------------------------------------------
-- Allow-list plays in ASSEMBLY. Unknown names play nothing.
--------------------------------------------------------------------------------
reset()
assert_true(Runtime:StartEvent() ~= nil, "StartEvent reaches ASSEMBLY")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY")

for i = 1, #ALLOWED do
  local name = ALLOWED[i]
  local ok, err = Sound:Play(name)
  assert_eq(ok, name, "ASSEMBLY records " .. name)
  assert_eq(err, nil, "ASSEMBLY " .. name .. " has no error")
  assert_eq(lastPlayed(), name, "PlaySound received " .. name)
end
assert_eq(#played, #ALLOWED, "each allow-list cue called PlaySound once")
assert_eq(filePlays, 0, "allow-list does not call PlaySoundFile")
assert_eq(kitPlays, 0, "allow-list does not call PlaySoundKitID")

local banned = {
  "canonization", "canonize", "seal", "Sanction", "SANCTION", "sanction ",
  "summon", "favor", "grant", "standing", "click", "login", "ambient",
  "whoosh", "pip", "toast", "8", "#8",
}
local before = #played
for i = 1, #banned do
  local ok, err = Sound:Play(banned[i])
  assert_eq(ok, nil, "banned cue " .. banned[i] .. " plays nothing")
  assert_eq(type(err), "string", "banned cue " .. banned[i] .. " returns a reason")
end
local okNil, errNil = Sound:Play(nil)
assert_eq(okNil, nil, "nil name plays nothing")
assert_eq(type(errNil), "string", "nil name returns a reason")
local okNum, errNum = Sound:Play(1)
assert_eq(okNum, nil, "numeric name plays nothing")
assert_eq(type(errNum), "string", "numeric name returns a reason")
assert_eq(#played, before, "unknown cues never call PlaySound")

--------------------------------------------------------------------------------
-- RITE and CONSEQUENCE may play. awaitingPope is not a sixth state.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
assert_true(Runtime:OpenRite("Gora", { fighters = { 1, 2 } }) ~= nil, "OpenRite reaches RITE")
assert_eq(Runtime:Snapshot().state, "RITE", "runtime is RITE")
assert_eq(Sound:Play("verdict"), "verdict", "RITE records verdict")
assert_eq(lastPlayed(), "verdict", "RITE called PlaySound")

assert_true(Runtime:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "runtime is CONSEQUENCE")
assert_eq(Sound:Play("cowardice"), "cowardice", "CONSEQUENCE records cowardice")
assert_eq(lastPlayed(), "cowardice", "CONSEQUENCE called PlaySound")

assert_true(Runtime:MarkPopeLost() ~= nil, "awaitingPope is Event Mode degraded")
assert_eq(Sound:Play("elevation"), "elevation", "awaitingPope still records elevation")
assert_eq(lastPlayed(), "elevation", "awaitingPope is not a mute state")
Runtime:ClearPopeLost()

assert_true(Runtime:Continue() ~= nil, "Continue returns to ASSEMBLY")
assert_eq(Sound:Play("knighting"), "knighting", "ASSEMBLY after Continue records knighting")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent returns to QUIET")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET")
local quietOk, quietErr = Sound:Play("sanction")
assert_eq(quietOk, nil, "QUIET after EndEvent plays nothing")
assert_eq(type(quietErr), "string", "QUIET after EndEvent returns a reason")
assert_eq(#played, 4, "EndEvent adds no cue")

--------------------------------------------------------------------------------
-- Missing Runtime is a no-op. Missing PlaySound still records the cue name.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local savedRuntime = COB.Runtime
COB.Runtime = nil
local missOk, missErr = Sound:Play("sanction")
assert_eq(missOk, nil, "missing Runtime plays nothing")
assert_eq(type(missErr), "string", "missing Runtime returns a reason")
assert_eq(#played, 0, "missing Runtime does not call PlaySound")

COB.Runtime = { Snapshot = nil }
local bareOk, bareErr = Sound:Play("sanction")
assert_eq(bareOk, nil, "Runtime without Snapshot plays nothing")
assert_eq(type(bareErr), "string", "Runtime without Snapshot returns a reason")
COB.Runtime = savedRuntime

local savedPlay = PlaySound
PlaySound = nil
assert_eq(Sound:Play("sanction"), "sanction", "missing PlaySound still records the cue")
assert_eq(#played, 0, "missing PlaySound calls nothing")
assert_eq(filePlays, 0, "missing PlaySound does not fall back to a file")

PlaySound = function()
  error("missing kit")
end
local rescued = Sound:Play("verdict")
assert_eq(rescued, "verdict", "a PlaySound error does not fail Play")
PlaySound = savedPlay

--------------------------------------------------------------------------------
-- Source contract: no addon media, no extra APIs, no sixth state, no callers.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/Sound.lua", "r")
assert_true(srcFile ~= nil, "Sound.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find(".ogg", 1, true), nil, "source ships no .ogg")
assert_eq(src:find(".mp3", 1, true), nil, "source ships no .mp3")
assert_eq(src:find("PlaySoundFile", 1, true), nil, "source does not call PlaySoundFile")
assert_eq(src:find("PlaySoundKitID", 1, true), nil, "source does not call PlaySoundKitID")
assert_eq(src:find("SOUNDKIT", 1, true), nil, "source does not invent SOUNDKIT ids")
assert_eq(src:find("RAID_WARNING", 1, true), nil, "source does not use RAID_WARNING")
assert_eq(src:find("READY_CHECK", 1, true), nil, "source does not use READY_CHECK")
assert_eq(src:find("CreateFrame", 1, true), nil, "source does not CreateFrame")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("SendAddonMessage", 1, true), nil, "source does not send addon messages")
assert_eq(src:find("canonization", 1, true), nil, "source does not name Canonization")
assert_eq(src:find("holdSeconds", 1, true), nil, "source does not invent a hold timer")
assert_eq(src:find("AWAITING", 1, true), nil, "source does not invent a sixth state")
assert_eq(src:find("COB.Console", 1, true), nil, "source does not wire Console")
assert_eq(src:find("COB.Gora", 1, true), nil, "source does not wire Gora")
assert_eq(src:find("COB.Knighting", 1, true), nil, "source does not wire Knighting")
assert_eq(src:find("COB.Hud", 1, true), nil, "source does not wire HUD")

assert_eq(frames, 0, "the suite minted no frames")
assert_eq(chatSends, 0, "the suite sent no chat")
assert_eq(addonSends, 0, "the suite sent no addon messages")
assert_eq(filePlays, 0, "the suite never called PlaySoundFile")
assert_eq(kitPlays, 0, "the suite never called PlaySoundKitID")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
assert_eq(Sound:Play("sanction"), "sanction", "a cue plays before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(Sound:ResetForTests(), false, "ResetForTests refuses to run outside tests")
ChurchOfBeef._IN_TEST = true

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
