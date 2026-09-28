-- Welcome parchment (Wave 2 Task 4 / Bible §19.5). Isolated: wow_ui_stub +
-- Common + Theme + Runtime + Welcome. Quiet, first-launch only. No TOC /
-- bootstrap / Store / DB / Net / Console / HUD / Toasts / Sound / PlayerCard.
-- Copy is Variant A. Close sets welcomeSeen; skip does not.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed, failed = 0, 0
if standalone then
  package.path = package.path .. ";./tests/?.lua"
  function assert_eq(a, b, msg)
    if a ~= b then
      failed = failed + 1
      print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
    else
      passed = passed + 1
    end
  end
  function assert_true(v, msg) assert_eq(not not v, true, msg) end
end

local stub = require("wow_ui_stub")
local restore = stub.install()

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/UI/Welcome.lua")

local COB = ChurchOfBeef
local Welcome = COB.Welcome
local Runtime = COB.Runtime

local sounds = 0
local savedPlaySound, savedPlaySoundFile, savedPlaySoundKitID = PlaySound, PlaySoundFile, PlaySoundKitID
PlaySound = function() sounds = sounds + 1 end
PlaySoundFile = function() sounds = sounds + 1 end
PlaySoundKitID = function() sounds = sounds + 1 end

local proclaims = 0
local savedToasts = COB.Toasts
COB.Toasts = {
  Proclaim = function()
    proclaims = proclaims + 1
  end,
}

local soundCues = 0
local savedSound = COB.Sound
COB.Sound = {
  Play = function() soundCues = soundCues + 1 end,
  PlayCue = function() soundCues = soundCues + 1 end,
}

local decreeShown = false
local savedBanner = COB.DecreeBanner
COB.DecreeBanner = {
  IsShown = function()
    return decreeShown == true
  end,
}

local function reset()
  assert_eq(Welcome:ResetForTests(), true, "Welcome ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  decreeShown = false
  ChurchOfBeefDB = { ui = { welcomeSeen = false } }
  sounds = 0
  proclaims = 0
  soundCues = 0
end

--------------------------------------------------------------------------------
-- Module contract
--------------------------------------------------------------------------------
assert_true(Welcome ~= nil, "COB.Welcome exists")
assert_eq(Welcome.MODE, "QUIET", "Welcome declares Quiet Mode")
assert_eq(type(Welcome.Init), "function", "Init exists")
assert_eq(type(Welcome.IsShown), "function", "IsShown exists")
assert_eq(type(Welcome.ResetForTests), "function", "ResetForTests exists")
assert_eq(Welcome.Grant, nil, "no Grant")
assert_eq(Welcome.Narrate, nil, "software does not narrate")
assert_eq(Welcome.PlayCue, nil, "no sound on the welcome")
assert_eq(Welcome.Toast, nil, "welcome is not a toast")

if standalone then
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "this file does not register a slash")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
  assert_eq(savedToasts, nil, "isolated suite does not load Toasts")
  assert_eq(savedSound, nil, "isolated suite does not load Sound")
  assert_eq(savedBanner, nil, "isolated suite does not load Decree UI")
end

--------------------------------------------------------------------------------
-- Copy: Variant A only. Ask and favor stay separate breaths.
--------------------------------------------------------------------------------
local COPY = Welcome.COPY
assert_true(type(COPY) == "table", "COPY table exists")
assert_eq(COPY.title, "Church of Beef", "title is Variant A in title case")
assert_eq(COPY.what, "Meetup nights and sanctioned duels.", "what is Variant A")
assert_eq(COPY.tuesday,
  "Most days: the bull on the minimap, and a notice if one is posted. That is Tuesday.",
  "tuesday is Variant A")
assert_eq(COPY.name, "Left-click the bull, or type /beef, to open your name.", "name is Variant A")
assert_eq(COPY.ask, "When the gathering starts, Ask to fight.", "ask is Variant A")
assert_eq(COPY.favor, "When two names appear on the fight bar, click a name to pick a side.",
  "favor is Variant A")
assert_eq(COPY.role, "You do not run the show.", "role is Variant A")
assert_eq(COPY.close, nil, "close is the shared window X, not copy")
assert_eq(COPY.ask:find("click a name", 1, true), nil, "ask does not contain click a name")
assert_true(COPY.ask ~= COPY.favor, "ask and favor are separate strings")
assert_eq(COPY.title:find("Director Console", 1, true), nil, "title has no Director Console")
assert_eq(COPY.what:find("Director Console", 1, true), nil, "what has no Director Console")
assert_eq(COPY.tuesday:find("Director Console", 1, true), nil, "tuesday has no Director Console")
assert_eq(COPY.name:find("Director Console", 1, true), nil, "name has no Director Console")
assert_eq(COPY.ask:find("Director Console", 1, true), nil, "ask has no Director Console")
assert_eq(COPY.favor:find("Director Console", 1, true), nil, "favor has no Director Console")
assert_eq(COPY.role:find("Director Console", 1, true), nil, "role has no Director Console")

local srcFile = io.open("addon/ChurchOfBeef/UI/Welcome.lua", "r")
assert_true(srcFile ~= nil, "UI/Welcome.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("Director Console", 1, true), nil, "source has no Director Console")
assert_eq(src:find("/beef console", 1, true), nil, "source does not advertise /beef console")
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find("PlaySoundFile", 1, true), nil, "source does not call PlaySoundFile")
assert_eq(src:find("Proclaim", 1, true), nil, "source does not Proclaim")
assert_eq(src:find("Toasts", 1, true), nil, "source does not call Toasts")
assert_eq(src:find("EnsureCharacterByName", 1, true), nil, "no congregation EnsureCharacterByName")
assert_eq(src:find("CreateHuman", 1, true), nil, "no congregation CreateHuman")
assert_eq(src:find("LinkCharacter", 1, true), nil, "no congregation LinkCharacter")
assert_eq(src:find("BackdropTemplate", 1, true), nil, "no BackdropTemplate")
assert_eq(src:find("SetColorTexture(0", 1, true), nil, "no color literals")
assert_eq(src:find("CreateFrame", 1, true) ~= nil, true, "Welcome is UI — CreateFrame is allowed")

--------------------------------------------------------------------------------
-- First Quiet launch with no Decree shows the sheet.
--------------------------------------------------------------------------------
reset()
assert_eq(Runtime:Snapshot().state, "QUIET", "fresh runtime is QUIET")
assert_eq(decreeShown, false, "no Decree is showing")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, false, "first launch has not closed")
local frame = Welcome:Init()
assert_true(frame ~= nil, "Init builds the parchment")
assert_eq(Welcome:IsShown(), true, "Init when unseen + QUIET + no Decree shows")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, false, "Init does not set welcomeSeen")
assert_eq(frame.AskText:GetText(), COPY.ask, "ask is its own FontString")
assert_eq(frame.FavorText:GetText(), COPY.favor, "favor is its own FontString")
assert_true(frame.AskText ~= frame.FavorText, "ask and favor are separate FontStrings")
assert_eq(frame.CloseButton._cobClose, true, "close is the shared window X")
assert_eq(frame.CloseButton:GetWidth(), COB.Theme.CloseSize, "close is stock width")
assert_eq(frame.CloseButton:GetNormalTexture(), COB.Theme:Texture("close_up"),
  "close uses the stock X")
assert_eq(sounds, 0, "showing welcome plays no PlaySound")
assert_eq(proclaims, 0, "showing welcome does not Proclaim")
assert_eq(soundCues, 0, "showing welcome does not call Sound")

--------------------------------------------------------------------------------
-- Close sets the flag and hides. Second Init stays silent.
--------------------------------------------------------------------------------
assert_true(stub.fire(frame.CloseButton, "OnClick"), "CLOSE is wired")
assert_eq(Welcome:IsShown(), false, "Close hides the sheet")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, true, "Close sets welcomeSeen")
assert_eq(sounds, 0, "Close plays no sound")
assert_eq(proclaims, 0, "Close does not Proclaim")

Welcome:Init()
assert_eq(Welcome:IsShown(), false, "second Init after Close is not shown")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, true, "second Init leaves welcomeSeen set")
assert_eq(sounds, 0, "second Init plays no sound")
assert_eq(proclaims, 0, "second Init does not Proclaim")

--------------------------------------------------------------------------------
-- Decree already showing: skip, do not stamp welcomeSeen.
--------------------------------------------------------------------------------
reset()
decreeShown = true
Welcome:Init()
assert_eq(Welcome:IsShown(), false, "Init skips when a Decree is showing")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, false, "skip-for-Decree does not set welcomeSeen")
assert_eq(sounds, 0, "Decree skip plays no sound")
assert_eq(proclaims, 0, "Decree skip does not Proclaim")

--------------------------------------------------------------------------------
-- Runtime ASSEMBLY: skip, do not stamp welcomeSeen.
--------------------------------------------------------------------------------
reset()
assert_true(Runtime:StartEvent() ~= nil, "StartEvent enters ASSEMBLY")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY")
Welcome:Init()
assert_eq(Welcome:IsShown(), false, "Init skips when Runtime is ASSEMBLY")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, false, "skip-for-ASSEMBLY does not set welcomeSeen")
assert_eq(sounds, 0, "ASSEMBLY skip plays no sound")
assert_eq(proclaims, 0, "ASSEMBLY skip does not Proclaim")

--------------------------------------------------------------------------------
-- ResetForTests hides/nils the frame and does not write SV.
--------------------------------------------------------------------------------
reset()
Welcome:Init()
assert_eq(Welcome:IsShown(), true, "sheet is showing before harness reset")
ChurchOfBeefDB.ui.welcomeSeen = false
assert_eq(Welcome:ResetForTests(), true, "ResetForTests returns under _IN_TEST")
assert_eq(Welcome:IsShown(), false, "harness reset hides the sheet")
assert_eq(Welcome.frame, nil, "harness reset nils the frame")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, false, "ResetForTests does not write welcomeSeen")

ChurchOfBeef._IN_TEST = false
ChurchOfBeefDB.ui.welcomeSeen = false
assert_eq(Welcome:ResetForTests(), false, "ResetForTests refuses outside tests")
ChurchOfBeef._IN_TEST = true

assert_eq(sounds, 0, "the suite played no sound")
assert_eq(proclaims, 0, "the suite never Proclaimed")
assert_eq(soundCues, 0, "the suite never called Sound")

COB.Toasts = savedToasts
COB.Sound = savedSound
COB.DecreeBanner = savedBanner
PlaySound, PlaySoundFile, PlaySoundKitID = savedPlaySound, savedPlaySoundFile, savedPlaySoundKitID
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
