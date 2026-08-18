-- Event congregation Petition / Confess / Catchup (B4-G, B5-E, B14-B, B15-A,
-- B16-B, B17-C, B18-A, B21-D, B23-D, B33-A, B35-B, B37-D). Isolated: wow_ui_stub + Common + Runtime + Inputs. Stub
-- COB.Net.SendPetition / SendConfession / RequestSnapshot. Event Mode only.
-- No Pope-name lookup. No Gora:Petition. No Proclaim. No sound. No
-- SendChatMessage. Isolation wrap. No TOC / bootstrap / run.lua. Confess
-- box: OnEscapePressed ClearFocus only; type-guarded SetMultiLine(true).
-- Not on UISpecialFrames. TitleBar drag persist writes ChurchOfBeefDB.ui.inputs.
-- Root has no RegisterForDrag. ResetForTests does not wipe SV.
-- Petition may name UnitName("target") when it is not the whisper dest and
-- not the local player (Names.Same). Both UnitName reads are pcalled.
-- Confess box sits TOP / -14 below the 12px TitleBar. HEIGHT 72 stays.
-- Opponent name is trimmed (^%s+ / %s+$) before Names.Same; empty omits.
-- A failed player pcall or a non-string player name omits opponent
-- (fail-closed). Player name is trimmed the same way; empty after trim omits.
-- Dest-same and player-same still omit. SetInputTarget trims the whisper
-- dest (Names.Trim, fallback ^%s+ / %s+$); empty after trim is no target.
-- Confess trims optional text (Names.Trim, fallback ^%s+ / %s+$);
-- empty after trim omits fields.text and still sends.
-- Quiet Hide blanks leftover confess text; dest / inputTarget persist.
package.path = package.path .. ";./tests/?.lua"

local stub = require("wow_ui_stub")
local restore = stub.install()

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

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/UI/Inputs.lua")

local COB = ChurchOfBeef
local Inputs = COB.Inputs
local Runtime = COB.Runtime

local sounds = 0
PlaySound = function()
  sounds = sounds + 1
end
PlaySoundFile = function()
  sounds = sounds + 1
end
PlaySoundKitID = function()
  sounds = sounds + 1
end

local sentPetitions = {}
local sentConfessions = {}
local sentSnapshots = {}
local goraCalls = 0
local proclaimCalls = 0

local function stubNet()
  sentPetitions = {}
  sentConfessions = {}
  sentSnapshots = {}
  COB.Net = {
    SendPetition = function(_, fields, target)
      sentPetitions[#sentPetitions + 1] = { fields = fields, target = target }
      return true
    end,
    SendConfession = function(_, fields, target)
      sentConfessions[#sentConfessions + 1] = { fields = fields, target = target }
      return true
    end,
    RequestSnapshot = function(_, target)
      sentSnapshots[#sentSnapshots + 1] = { target = target }
      return true
    end,
  }
end

local function reset()
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Inputs:ResetForTests(), true, "Inputs ResetForTests runs under _IN_TEST")
  sounds = 0
  goraCalls = 0
  proclaimCalls = 0
  stubNet()
end

local function buttonFor(label)
  local frame = Inputs.frame
  if not frame then return nil end
  return stub.findChild(frame, function(child)
    return child._type == "Button" and child:GetText() == label
  end)
end

local function editBox()
  local frame = Inputs.frame
  if not frame then return nil end
  if frame.confessBox then return frame.confessBox end
  return stub.findChild(frame, function(child)
    return child._type == "EditBox"
  end)
end

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(Inputs ~= nil, "COB.Inputs is loaded")
assert_true(Runtime ~= nil, "isolated suite loads Runtime")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_eq(Inputs.MODE, "Event", "Inputs declares Event Mode")
assert_eq(type(Inputs.Init), "function", "Init builds the surface")
assert_eq(type(Inputs.SetInputTarget), "function", "SetInputTarget stores the whisper destination")
assert_eq(type(Inputs.SetLocalCharacterId), "function", "SetLocalCharacterId stores the local id")
assert_eq(type(Inputs.Petition), "function", "Petition is the congregation verb")
assert_eq(type(Inputs.Confess), "function", "Confess is the congregation verb")
assert_eq(type(Inputs.Catchup), "function", "Catchup is the congregation snapshot verb")
assert_eq(type(Inputs.Show), "function", "Show needs Event Mode")
assert_eq(type(Inputs.Hide), "function", "Hide dismisses the surface")
assert_eq(type(Inputs.Refresh), "function", "Refresh paints from Runtime")
assert_eq(type(Inputs.GetView), "function", "GetView returns a copy")
assert_eq(type(Inputs.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(Inputs.Proclaim, nil, "no Proclaim")
assert_eq(Inputs.PlayCue, nil, "no sound this lane")
assert_eq(Inputs.Toast, nil, "surface is not a toast")
assert_eq(Inputs.Narrate, nil, "software does not narrate")
assert_eq(Inputs.Announce, nil, "software does not announce")
assert_eq(Inputs.LookupPope, nil, "no Pope lookup")
assert_eq(Inputs.FindPope, nil, "no Pope finder")
assert_eq(Inputs.Sanction, nil, "congregation does not sanction")

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
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load Records Book")
  assert_eq(COB.Decree, nil, "isolated suite does not load Decree")
  assert_eq(COB.DecreeBanner, nil, "isolated suite does not load Decree banner")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Sound, nil, "isolated suite does not load Sound")
  assert_eq(COB.FighterCard, nil, "isolated suite does not load FighterCard")
  assert_eq(COB.Confession, nil, "isolated suite does not load Confession")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "this file does not register a slash")
end

--------------------------------------------------------------------------------
-- Source contract: Net only. No theater, no Pope lookup, no local Gora write.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(srcFile ~= nil, "UI/Inputs.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find("PlaySoundFile", 1, true), nil, "source does not call PlaySoundFile")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("SendAddonMessage", 1, true), nil, "source does not send addon messages")
assert_eq(src:find("Proclaim", 1, true), nil, "source does not Proclaim")
assert_eq(src:find("Gora:Petition", 1, true), nil, "source does not call Gora:Petition")
assert_eq(src:find("Gora.Petition", 1, true), nil, "source does not call Gora.Petition")
assert_eq(src:find("Popes.lua", 1, true), nil, "source does not load Popes.lua")
assert_eq(src:find("Data/Popes", 1, true), nil, "source does not read Data/Popes")
assert_eq(src:find("COB.Popes", 1, true), nil, "source does not read COB.Popes")
assert_eq(src:find("LookupPope", 1, true), nil, "source has no Pope lookup")
assert_eq(src:find("FindPope", 1, true), nil, "source has no Pope finder")
assert_eq(src:find("ShowUIPanel", 1, true), nil, "insecure Show/Hide only")
assert_eq(src:find("SecureActionButton", 1, true), nil, "no secure template")
assert_eq(src:find("SLASH_", 1, true), nil, "source does not register a slash")
assert_eq(src:find("Media\\", 1, true), nil, "source does not require custom Media")
assert_eq(src:find(".tga", 1, true), nil, "source does not load custom tga")
assert_eq(src:find(".blp", 1, true), nil, "source does not load custom blp")
assert_eq(src:find(".ttf", 1, true), nil, "source does not load custom fonts")
assert_eq(src:find("rubber", 1, true), nil, "source has no rubber flavor")
assert_eq(src:find("ordained", 1, true), nil, "source has no ordained flavor")
assert_eq(src:find("Speak your truth", 1, true), nil, "source has no joke copy")
assert_true(src:find("UIPanelButtonTemplate", 1, true) ~= nil, "buttons use UIPanelButtonTemplate")
assert_true(src:find("InputBoxTemplate", 1, true) ~= nil, "confession box uses InputBoxTemplate")
assert_true(src:find('"Petition"', 1, true) ~= nil, "Petition label is stock")
assert_true(src:find('"Confess"', 1, true) ~= nil, "Confess label is stock")
assert_true(src:find('"Catch up"', 1, true) ~= nil, "Catch up label is stock")
assert_true(src:find("RequestSnapshot", 1, true) ~= nil, "Catchup calls RequestSnapshot")
assert_true(src:find("OnEscapePressed", 1, true) ~= nil, "source contains OnEscapePressed")
assert_true(src:find("ClearFocus", 1, true) ~= nil, "source contains ClearFocus")
assert_true(src:find("SetMultiLine", 1, true) ~= nil, "source contains SetMultiLine")
assert_eq(src:find("UISpecialFrames", 1, true), nil, "source does not use UISpecialFrames")
assert_eq(src:find("SUMMON", 1, true), nil, "source has no SUMMON")
assert_eq(src:find("Popes", 1, true), nil, "source has no Popes lookup")
assert_eq(src:find("IsRegisteredPope", 1, true), nil, "source has no IsRegisteredPope")

--------------------------------------------------------------------------------
-- Init is hidden in Quiet. Stock Petition / Confess / Catch up. Optional EditBox.
--------------------------------------------------------------------------------
reset()
assert_eq(Runtime:Snapshot().state, "QUIET", "fresh runtime is QUIET")
local frame = Inputs:Init()
assert_true(frame ~= nil, "Init creates the frame")
assert_eq(frame:GetName(), "ChurchOfBeefInputs", "frame has a stable name")
assert_eq(frame:GetParent(), UIParent, "panel is parented to UIParent")
assert_eq(Inputs:Init(), frame, "Init is idempotent")
assert_eq(frame:IsShown(), false, "Quiet Init stays hidden")
assert_eq(Inputs:GetView().shown, false, "Quiet view is hidden")
assert_eq(Inputs:GetView().mode, "Event", "hidden view still declares Event")
assert_eq(frame:GetScript("OnUpdate"), nil, "a resting panel runs nothing per frame")
assert_eq(frame._template, nil, "functional panel is not a BasicFrameTemplate")

local petitionBtn = buttonFor("Petition")
local confessBtn = buttonFor("Confess")
local catchupBtn = buttonFor("Catch up")
assert_true(petitionBtn ~= nil, "Petition button exists")
assert_true(confessBtn ~= nil, "Confess button exists")
assert_true(catchupBtn ~= nil, "Catch up button exists")
assert_eq(petitionBtn._template, "UIPanelButtonTemplate", "Petition is a stock panel button")
assert_eq(confessBtn._template, "UIPanelButtonTemplate", "Confess is a stock panel button")
assert_eq(catchupBtn._template, "UIPanelButtonTemplate", "Catch up is a stock panel button")
assert_eq(buttonFor("Proclaim"), nil, "no Proclaim chrome")
assert_eq(buttonFor("SANCTION"), nil, "no SANCTION chrome")
local box = editBox()
assert_true(box ~= nil, "optional confession EditBox exists")
assert_eq(box._template, "InputBoxTemplate", "confession box is stock InputBoxTemplate")

--------------------------------------------------------------------------------
-- Quiet refuse. No Quiet chrome. No Net.
--------------------------------------------------------------------------------
assert_eq(Inputs:Show(), false, "Quiet Show is false")
assert_eq(frame:IsShown(), false, "Quiet Show leaves the widget hidden")
Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(1)
local ok, err = Inputs:Petition()
assert_eq(ok, false, "Quiet Petition is false")
assert_eq(#sentPetitions, 0, "Quiet Petition does not send")
ok, err = Inputs:Confess("forgive me")
assert_eq(ok, false, "Quiet Confess is false")
assert_eq(#sentConfessions, 0, "Quiet Confess does not send")
ok, err = Inputs:Catchup()
assert_eq(ok, false, "Quiet Catchup is false")
assert_eq(#sentSnapshots, 0, "Quiet Catchup does not send")
assert_eq(sounds, 0, "Quiet plays no sound")
assert_eq(#stub.chat, 0, "Quiet does not SendChatMessage")
assert_eq(#stub.addonMessages, 0, "Quiet does not SendAddonMessage")

--------------------------------------------------------------------------------
-- Event without target / id. Missing target names the error.
--------------------------------------------------------------------------------
reset()
assert_true(Runtime:StartEvent() ~= nil, "StartEvent reaches ASSEMBLY")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY")
frame = Inputs:Init()
assert_eq(Inputs:Show(), true, "Event Show is true")
assert_eq(frame:IsShown(), true, "Event Show paints the widget")
assert_eq(Inputs:GetView().shown, true, "Event view is shown")

ok, err = Inputs:Petition()
assert_eq(ok, false, "Petition without target is refused")
assert_eq(err, "no target", "missing target names the error")
assert_eq(#sentPetitions, 0, "missing target does not send")
ok, err = Inputs:Catchup()
assert_eq(ok, false, "Catchup without target is refused")
assert_eq(err, "no target", "Catchup missing target names the error")
assert_eq(#sentSnapshots, 0, "Catchup missing target does not send")

Inputs:SetInputTarget("")
ok, err = Inputs:Petition()
assert_eq(ok, false, "empty target is refused")
assert_eq(err, "no target", "empty target is no target")
ok, err = Inputs:Catchup()
assert_eq(ok, false, "Catchup empty target is refused")
assert_eq(err, "no target", "Catchup empty target is no target")

Inputs:SetInputTarget("Host")
ok, err = Inputs:Petition()
assert_eq(ok, false, "Petition without character is refused")
assert_eq(err, "no character", "missing character names the error")
assert_eq(#sentPetitions, 0, "missing character does not send")
ok, err = Inputs:Catchup()
assert_eq(ok, true, "Catchup does not require a character id")
assert_eq(err, nil, "successful Catchup has no error")
assert_eq(#sentSnapshots, 1, "Catchup without character still requests")
assert_eq(sentSnapshots[1].target, "Host", "Catchup without character uses the target")

Inputs:SetLocalCharacterId(nil)
ok, err = Inputs:Confess("forgive me")
assert_eq(ok, false, "Confess without character is refused")
assert_eq(err, "no character", "Confess missing character names the error")
assert_eq(#sentConfessions, 0, "missing character does not confess")

Inputs:SetInputTarget(nil)
Inputs:SetLocalCharacterId(1)
ok, err = Inputs:Confess("forgive me")
assert_eq(ok, false, "Confess without target is refused")
assert_eq(err, "no target", "Confess missing target names the error")
assert_eq(#sentConfessions, 0, "missing target does not confess")

--------------------------------------------------------------------------------
-- StartEvent + target + id → Petition spies Net. Confess spies text.
-- Catchup spies the injected target.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Inputs:Init()
Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)
assert_eq(Inputs:Show(), true, "armed Event Show is true")

ok, err = Inputs:Petition()
assert_eq(ok, true, "Petition sends when target and id are present")
assert_eq(err, nil, "successful Petition has no error")
assert_eq(#sentPetitions, 1, "SendPetition is called once")
assert_eq(sentPetitions[1].target, "Host", "SendPetition uses SetInputTarget")
assert_eq(sentPetitions[1].fields.characterId, 7, "SendPetition carries characterId")
assert_eq(sentPetitions[1].fields.kind, nil, "Inputs does not invent a kind field")
assert_eq(sentPetitions[1].fields.opponent, nil, "unset stub target omits opponent")

ok, err = Inputs:Catchup()
assert_eq(ok, true, "Catchup sends when target is present")
assert_eq(err, nil, "successful Catchup has no error")
assert_eq(#sentSnapshots, 1, "RequestSnapshot is called once")
assert_eq(sentSnapshots[1].target, "Host", "RequestSnapshot uses SetInputTarget")

ok, err = Inputs:Confess("forgive me")
assert_eq(ok, true, "Confess sends when target, id, and text are present")
assert_eq(err, nil, "successful Confess has no error")
assert_eq(#sentConfessions, 1, "SendConfession is called once")
assert_eq(sentConfessions[1].target, "Host", "SendConfession uses SetInputTarget")
assert_eq(sentConfessions[1].fields.characterId, 7, "SendConfession carries characterId")
assert_eq(sentConfessions[1].fields.text, "forgive me", "SendConfession spies the text")

box = editBox()
box:SetText("typed in the box")
ok, err = Inputs:Confess()
assert_eq(ok, true, "Confess without an arg reads the EditBox")
assert_eq(#sentConfessions, 2, "EditBox Confess sends once more")
assert_eq(sentConfessions[2].fields.text, "typed in the box", "EditBox text reaches Net")

ok, err = Inputs:Confess("explicit wins")
assert_eq(sentConfessions[3].fields.text, "explicit wins", "explicit Confess text wins over the box")

petitionBtn = buttonFor("Petition")
confessBtn = buttonFor("Confess")
catchupBtn = buttonFor("Catch up")
sentPetitions = {}
sentConfessions = {}
sentSnapshots = {}
assert_eq(stub.fire(petitionBtn, "OnClick"), true, "Petition button is wired")
assert_eq(#sentPetitions, 1, "Petition click spies Net")
assert_eq(sentPetitions[1].target, "Host", "Petition click uses the stored target")
assert_eq(sentPetitions[1].fields.characterId, 7, "Petition click uses the stored id")
box:SetText("from the button")
assert_eq(stub.fire(confessBtn, "OnClick"), true, "Confess button is wired")
assert_eq(#sentConfessions, 1, "Confess click spies Net")
assert_eq(sentConfessions[1].fields.text, "from the button", "Confess click reads the box")
assert_eq(stub.fire(catchupBtn, "OnClick"), true, "Catch up button is wired")
assert_eq(#sentSnapshots, 1, "Catch up click spies Net")
assert_eq(sentSnapshots[1].target, "Host", "Catch up click uses the stored target")

assert_eq(sounds, 0, "sending plays no sound")
assert_eq(#stub.chat, 0, "sending does not SendChatMessage")
assert_eq(#stub.addonMessages, 0, "sending does not SendAddonMessage")

--------------------------------------------------------------------------------
-- Missing Runtime is Quiet. Missing Net is fail-closed. No local Gora write.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)
local savedRuntime = COB.Runtime
COB.Runtime = nil
assert_eq(Inputs:Show(), false, "missing Runtime Show is false")
ok, err = Inputs:Petition()
assert_eq(ok, false, "missing Runtime Petition is false")
assert_eq(#sentPetitions, 0, "missing Runtime does not send")
ok, err = Inputs:Confess("x")
assert_eq(ok, false, "missing Runtime Confess is false")
ok, err = Inputs:Catchup()
assert_eq(ok, false, "missing Runtime Catchup is false")
assert_eq(#sentSnapshots, 0, "missing Runtime does not request a snapshot")
COB.Runtime = savedRuntime
assert_eq(Inputs:Show(), true, "restored Runtime Show is true")

COB.Net = nil
ok, err = Inputs:Petition()
assert_eq(ok, false, "missing Net Petition is false")
assert_eq(err, "no net", "missing Net names the error")
ok, err = Inputs:Confess("x")
assert_eq(ok, false, "missing Net Confess is false")
assert_eq(err, "no net", "missing Net Confess names the error")
ok, err = Inputs:Catchup()
assert_eq(ok, false, "missing Net Catchup is false")
assert_eq(err, "no net", "missing Net Catchup names the error")
stubNet()

COB.Gora = {
  Petition = function()
    goraCalls = goraCalls + 1
  end,
}
COB.Toasts = {
  Proclaim = function()
    proclaimCalls = proclaimCalls + 1
  end,
}
assert_eq(Inputs:Petition(), true, "Petition still sends with a Gora spy present")
assert_eq(goraCalls, 0, "Petition does not call Gora:Petition locally")
assert_eq(proclaimCalls, 0, "Petition does not Proclaim")
assert_eq(Inputs:Confess("still private"), true, "Confess still sends with a toast spy present")
assert_eq(proclaimCalls, 0, "Confess does not Proclaim")
assert_eq(Inputs:Catchup(), true, "Catchup still sends with a Gora spy present")
assert_eq(goraCalls, 0, "Catchup does not call Gora locally")
assert_eq(proclaimCalls, 0, "Catchup does not Proclaim")
COB.Gora = nil
COB.Toasts = nil

--------------------------------------------------------------------------------
-- GetView is a copy. Hide / EndEvent hide. Refresh follows Runtime.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
frame = Inputs:Init()
Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)
assert_eq(Inputs:Show(), true, "Show for the copy pin")
local view = Inputs:GetView()
assert_eq(view.shown, true, "view agrees the panel is shown")
assert_eq(view.mode, "Event", "view declares Event")
assert_eq(view.target, "Host", "view reports the stored target")
assert_eq(view.characterId, 7, "view reports the stored id")
view.shown = false
view.target = "hacked"
view.characterId = 99
view.mode = "Quiet"
local again = Inputs:GetView()
assert_eq(again.shown, true, "mutating GetView does not hide the panel")
assert_eq(again.target, "Host", "mutating GetView does not change the target")
assert_eq(again.characterId, 7, "mutating GetView does not change the id")
assert_eq(again.mode, "Event", "mutating GetView does not change the mode")

Inputs:Hide()
assert_eq(frame:IsShown(), false, "Hide dismisses the widget")
assert_eq(Inputs:GetView().shown, false, "Hide clears the view")
view = Inputs:Refresh()
assert_eq(view.shown, true, "Refresh in Event shows again")
assert_eq(frame:IsShown(), true, "Refresh paints the widget")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent returns to QUIET")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET")
view = Inputs:Refresh()
assert_eq(view.shown, false, "Quiet Refresh hides the panel")
assert_eq(frame:IsShown(), false, "Quiet Refresh hides the widget")
assert_eq(Inputs:Show(), false, "Quiet Show is false after EndEvent")
assert_eq(Inputs:Petition(), false, "Quiet Petition is false after EndEvent")
assert_eq(#sentPetitions, 0, "Quiet after EndEvent does not send")
assert_eq(Inputs:Catchup(), false, "Quiet Catchup is false after EndEvent")
assert_eq(#sentSnapshots, 0, "Quiet after EndEvent does not request a snapshot")

--------------------------------------------------------------------------------
-- B14-B: confess box OnEscapePressed ClearFocus. Box does not Hide the panel.
-- Nested so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB14B()
reset()
assert_true(Runtime:StartEvent() ~= nil, "B14-B StartEvent reaches ASSEMBLY")
local frame = Inputs:Init()
assert_true(frame ~= nil, "B14-B Init creates the frame")
assert_eq(frame:IsShown(), true, "Event Init shows the Inputs panel")
assert_eq(Inputs:GetView().shown, true, "Event view is shown before ESC")
assert_eq(frame:GetWidth(), 328, "WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "HEIGHT stays 72")

local box = editBox()
assert_true(box ~= nil, "B14-B editBox exists")
assert_eq(box:GetHeight(), 22, "box height stays 22")
assert_eq(box._autoFocus, false, "SetAutoFocus(false) stays")
assert_eq(type(box.GetScript), "function", "editBox GetScript exists")
assert_true(box:GetScript("OnEscapePressed") ~= nil, "editBox has OnEscapePressed")

box:SetFocus()
assert_eq(box:HasFocus(), true, "editBox can take focus")
local fired, fireErr = pcall(function()
  stub.fire(box, "OnEscapePressed")
end)
assert_eq(fired, true, "OnEscapePressed fire does not error")
assert_eq(fireErr, nil, "OnEscapePressed fire has no error text")
assert_eq(box:HasFocus(), false, "OnEscapePressed ClearFocuses")
assert_eq(frame:IsShown(), true, "frame stays shown after OnEscapePressed")
assert_eq(Inputs:GetView().shown, true, "GetView().shown stays true")

local listed = false
for i = 1, #UISpecialFrames do
  if UISpecialFrames[i] == "ChurchOfBeefInputs" then listed = true end
end
assert_eq(listed, false, "Inputs is not registered on UISpecialFrames")

Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)
box:SetText("after esc")
local ok, err = Inputs:Confess()
assert_eq(ok, true, "Confess GetText still works after ESC")
assert_eq(err, nil, "Confess after ESC has no error")
assert_eq(#sentConfessions, 1, "Confess after ESC sends")
assert_eq(sentConfessions[1].fields.text, "after esc", "Confess GetText pin still holds")

assert_true(src:find("OnEscapePressed", 1, true) ~= nil, "source contains OnEscapePressed")
assert_true(src:find("ClearFocus", 1, true) ~= nil, "source contains ClearFocus")
assert_true(src:find("SetMultiLine", 1, true) ~= nil, "source contains SetMultiLine")
assert_true(src:find('type(box.SetMultiLine) == "function"', 1, true) ~= nil,
  "SetMultiLine is type-guarded")
assert_true(src:find("SetMultiLine(true)", 1, true) ~= nil, "source calls SetMultiLine(true)")
assert_true(src:find('SetScript("OnEscapePressed"', 1, true) ~= nil,
  "source wires OnEscapePressed")
assert_true(src:find('type(box.SetScript) == "function"', 1, true) ~= nil,
  "SetScript is type-guarded")
assert_true(src:find('type(self.ClearFocus) == "function"', 1, true) ~= nil,
  "ClearFocus is type-guarded")
assert_eq(src:find("UISpecialFrames", 1, true), nil, "source does not use UISpecialFrames")
assert_eq(src:find("SUMMON", 1, true), nil, "source has no SUMMON")
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find(".tga", 1, true), nil, "source does not load custom tga")
assert_eq(src:find(".blp", 1, true), nil, "source does not load custom blp")
assert_eq(src:find(".ttf", 1, true), nil, "source does not load custom fonts")
assert_eq(src:find("Popes", 1, true), nil, "source has no Popes lookup")
assert_eq(src:find("IsRegisteredPope", 1, true), nil, "source has no IsRegisteredPope")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B14-B")
  assert_eq(COB.Popes, nil, "still no Pope list after B14-B")
  assert_eq(COB.Sender, nil, "still no Sender after B14-B")
  assert_eq(COB.Sound, nil, "still no Sound after B14-B")
  assert_eq(COB.Hud, nil, "still no Hud after B14-B")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B14-B still does not register a slash")
end
end
runB14B()

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
frame = Inputs:Init()
Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)
assert_eq(Inputs:Show(), true, "panel is showing before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(Inputs:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(frame:IsShown(), true, "out-of-harness reset does not hide the panel")
ChurchOfBeef._IN_TEST = true
assert_eq(Inputs:ResetForTests(), true, "ResetForTests returns under _IN_TEST")
assert_eq(frame:IsShown(), false, "harness reset hides the panel")
assert_eq(Inputs:GetView().target, nil, "harness reset clears the target")
assert_eq(Inputs:GetView().characterId, nil, "harness reset clears the id")

--------------------------------------------------------------------------------
-- Missing CreateFrame must not fail load.
--------------------------------------------------------------------------------
reset()
local savedCreate = CreateFrame
CreateFrame = nil
assert_eq(Inputs:Init(), nil, "Init without CreateFrame returns nil")
assert_eq(Inputs:Show(), false, "Show without CreateFrame is false")
CreateFrame = savedCreate
frame = Inputs:Init()
assert_true(frame ~= nil, "Init after CreateFrame returns builds the frame")
assert_eq(frame:IsShown(), false, "rebuilt Init in Quiet stays hidden")

--------------------------------------------------------------------------------
-- B15-A + B16-B: TitleBar OnDragStop persists ChurchOfBeefDB.ui.inputs (dock
-- pattern). Root has no OnDragStart. TitleBar exists, height 12–14,
-- TOPLEFT/TOPRIGHT, no title string. Invalid saved point falls back. Quiet
-- Init with a saved point still hides. ResetForTests must not wipe SV.
-- Missing DB: default restore; save no-ops. Nested so the main chunk stays
-- under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB15A()
ChurchOfBeefDB = { ui = {} }
reset()
local frame = Inputs:Init()
assert_true(Runtime:StartEvent() ~= nil, "B15-A StartEvent reaches ASSEMBLY")
assert_eq(Inputs:Show(), true, "Event Show is true before drag")
assert_eq(frame:IsShown(), true, "Event Show paints the widget before drag")
assert_eq(frame:GetWidth(), 328, "persist WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "persist HEIGHT stays 72")
assert_eq(frame._movable, true, "root is SetMovable(true)")
assert_eq(frame._clamped, true, "root stays SetClampedToScreen")
assert_eq(frame:GetScript("OnDragStart"), nil, "root has no OnDragStart")
assert_eq(frame:GetScript("OnDragStop"), nil, "drag stop is on TitleBar, not the root")
local titleBar = rawget(frame, "TitleBar")
assert_true(titleBar ~= nil, "TitleBar exists")
if titleBar then
  assert_eq(titleBar:GetParent(), frame, "TitleBar is a child of the root")
  local th = titleBar:GetHeight()
  assert_true(th ~= nil and th >= 12 and th <= 14, "TitleBar height is 12–14")
  assert_eq(select(1, titleBar:GetPoint(1)), "TOPLEFT", "TitleBar TOPLEFT")
  assert_eq(select(2, titleBar:GetPoint(1)), frame, "TitleBar TOPLEFT relative is the root")
  assert_eq(select(1, titleBar:GetPoint(2)), "TOPRIGHT", "TitleBar TOPRIGHT")
  assert_eq(select(2, titleBar:GetPoint(2)), frame, "TitleBar TOPRIGHT relative is the root")
  assert_true(titleBar:GetScript("OnDragStart") ~= nil, "drag start is on TitleBar")
  assert_true(titleBar:GetScript("OnDragStop") ~= nil, "drag stop is on TitleBar")
  assert_eq(titleBar:GetNumRegions(), 0, "TitleBar has no title FontString")
  stub.fire(titleBar, "OnDragStart")
  assert_eq(frame._moving, true, "TitleBar drag starts a move on the root")
  frame:ClearAllPoints()
  frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, 90)
  stub.fire(titleBar, "OnDragStop")
  assert_eq(frame._moving, false, "drop stops the move")
else
  assert_true(false, "TitleBar drag persist cannot fire")
end
assert_eq(frame:GetScript("OnUpdate"), nil, "drop leaves no animator")
local saved = ChurchOfBeefDB.ui and ChurchOfBeefDB.ui.inputs
assert_true(type(saved) == "table", "moved position is saved")
assert_eq(saved and saved.point, "TOPLEFT", "saved anchor point")
assert_eq(saved and saved.relativePoint, "TOPLEFT", "saved relative point")
assert_eq(saved and saved.x, 24, "saved x")
assert_eq(saved and saved.y, 90, "saved y")
assert_eq(saved and saved.relativeTo, nil, "no frame reference lands in SavedVariables")

dofile("addon/ChurchOfBeef/UI/Inputs.lua")
Inputs = COB.Inputs
local reloaded = Inputs:Init()
local rp, rto, rrp, rx, ry = reloaded:GetPoint(1)
assert_eq(rp, "TOPLEFT", "saved top-left anchor restores")
assert_eq(rto, UIParent, "restore still parents to UIParent")
assert_eq(rrp, "TOPLEFT", "saved relative top-left restores")
assert_eq(rx, 24, "saved x restores")
assert_eq(ry, 90, "saved y restores")
assert_eq(reloaded:GetParent(), UIParent, "dofile Init restores parented UIParent")
assert_true(rawget(reloaded, "TitleBar") ~= nil, "TitleBar survives dofile Init")
assert_eq(reloaded:GetScript("OnDragStart"), nil, "reloaded root has no OnDragStart")
frame = reloaded

ChurchOfBeefDB.ui.inputs = { point = "MIDDLE-OF-NOWHERE", relativePoint = "CENTER", x = 1, y = 2 }
dofile("addon/ChurchOfBeef/UI/Inputs.lua")
Inputs = COB.Inputs
local safe = Inputs:Init()
assert_eq(select(1, safe:GetPoint(1)), "BOTTOM", "invalid saved anchor falls back to BOTTOM")
assert_eq(select(2, safe:GetPoint(1)), UIParent, "invalid saved point still parents to UIParent")
assert_eq(select(3, safe:GetPoint(1)), "BOTTOM", "invalid saved relative falls back to BOTTOM")
assert_eq(select(4, safe:GetPoint(1)), 0, "invalid saved x falls back to 0")
assert_eq(select(5, safe:GetPoint(1)), 80, "invalid saved y falls back to 80")
frame = safe

ChurchOfBeefDB.ui.inputs = { point = "TOPLEFT", relativePoint = "TOPLEFT", x = 24, y = 90 }
reset()
assert_true(type(ChurchOfBeefDB.ui.inputs) == "table", "ResetForTests does not wipe SV")
assert_eq(ChurchOfBeefDB.ui.inputs.point, "TOPLEFT", "ResetForTests leaves the saved point")
assert_eq(ChurchOfBeefDB.ui.inputs.x, 24, "ResetForTests leaves saved x")
assert_eq(ChurchOfBeefDB.ui.inputs.y, 90, "ResetForTests leaves saved y")
frame = Inputs:Init()
assert_eq(frame:IsShown(), false, "Quiet Init with a saved point still hides")
assert_eq(Inputs:GetView().shown, false, "Quiet view stays hidden with a saved point")
assert_eq(select(1, frame:GetPoint(1)), "TOPLEFT", "Quiet Init still restores the saved point")
assert_eq(select(2, frame:GetPoint(1)), UIParent, "Quiet restore still parents to UIParent")
assert_eq(select(4, frame:GetPoint(1)), 24, "Quiet Init restores saved x")
assert_eq(select(5, frame:GetPoint(1)), 90, "Quiet Init restores saved y")
assert_true(rawget(frame, "TitleBar") ~= nil, "Quiet Init still has TitleBar")
assert_eq(frame:GetScript("OnDragStart"), nil, "Quiet restored root has no OnDragStart")

assert_true(Runtime:StartEvent() ~= nil, "B15-A Event after Quiet persist")
assert_eq(Inputs:Show(), true, "Event Show after persist restore")
assert_eq(frame:IsShown(), true, "Event paints after persist restore")
local box = editBox()
assert_true(box ~= nil, "confess box still exists after persist")
assert_true(box:GetScript("OnEscapePressed") ~= nil, "OnEscapePressed stays after persist")
box:SetFocus()
assert_eq(box:HasFocus(), true, "editBox can take focus after persist")
local fired, fireErr = pcall(function()
  stub.fire(box, "OnEscapePressed")
end)
assert_eq(fired, true, "OnEscapePressed fire does not error after persist")
assert_eq(fireErr, nil, "OnEscapePressed fire has no error text after persist")
assert_eq(box:HasFocus(), false, "ESC ClearFocus still does not Hide")
assert_eq(frame:IsShown(), true, "frame stays shown after ESC ClearFocus")
assert_eq(Inputs:GetView().shown, true, "GetView().shown stays true after ESC")

local listed = false
for i = 1, #UISpecialFrames do
  if UISpecialFrames[i] == "ChurchOfBeefInputs" then listed = true end
end
assert_eq(listed, false, "Inputs is still not registered on UISpecialFrames")

Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)
box:SetText("after persist")
local ok, err = Inputs:Confess()
assert_eq(ok, true, "Confess GetText still works after persist")
assert_eq(err, nil, "Confess after persist has no error")
assert_eq(#sentConfessions, 1, "Confess after persist sends")
assert_eq(sentConfessions[1].fields.text, "after persist", "existing Confess pin still holds")

local persistSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(persistSrcFile ~= nil, "Inputs.lua is readable after persist pins")
local persistSrc = persistSrcFile:read("*a")
persistSrcFile:close()
assert_true(persistSrc:find("ANCHORS", 1, true) ~= nil, "source whitelists ANCHORS")
assert_true(persistSrc:find("savePoint", 1, true) ~= nil, "source has savePoint")
assert_true(persistSrc:find("restorePoint", 1, true) ~= nil, "source has restorePoint")
assert_true(persistSrc:find("db.inputs", 1, true) ~= nil, "source keys ChurchOfBeefDB.ui.inputs")
assert_true(persistSrc:find("SetMovable(true)", 1, true) ~= nil, "source SetMovable(true)")
assert_true(persistSrc:find("SetClampedToScreen(true)", 1, true) ~= nil, "source SetClampedToScreen(true)")
assert_true(persistSrc:find('RegisterForDrag("LeftButton")', 1, true) ~= nil,
  "source RegisterForDrag LeftButton")
assert_true(persistSrc:find("TitleBar", 1, true) ~= nil, "source names TitleBar")
assert_true(persistSrc:find("titleBar:EnableMouse(true)", 1, true) ~= nil,
  "TitleBar EnableMouse")
assert_true(persistSrc:find('titleBar:RegisterForDrag("LeftButton")', 1, true) ~= nil,
  "TitleBar RegisterForDrag LeftButton")
assert_eq(persistSrc:find("widget:RegisterForDrag", 1, true), nil, "root RegisterForDrag is gone")
assert_eq(persistSrc:find('widget:SetScript("OnDragStart"', 1, true), nil,
  "root OnDragStart is gone")
assert_eq(persistSrc:find('widget:SetScript("OnDragStop"', 1, true), nil,
  "root OnDragStop is gone")
assert_eq(persistSrc:find("titleBar:SetText", 1, true), nil, "TitleBar has no SetText")
assert_eq(persistSrc:find("TitleText", 1, true), nil, "source has no TitleText")
assert_eq(persistSrc:find("CreateFontString", 1, true), nil, "source has no title FontString")
assert_eq(persistSrc:find("relativeTo", 1, true), nil, "source never stores relativeTo")
assert_eq(persistSrc:find("UISpecialFrames", 1, true), nil, "persist source does not use UISpecialFrames")
assert_true(persistSrc:find("OnEscapePressed", 1, true) ~= nil, "persist source keeps OnEscapePressed")
assert_true(persistSrc:find("ClearFocus", 1, true) ~= nil, "persist source keeps ClearFocus")
assert_true(persistSrc:find("SetMultiLine(true)", 1, true) ~= nil, "persist source keeps SetMultiLine(true)")
assert_eq(persistSrc:find("SUMMON", 1, true), nil, "persist source has no SUMMON")
assert_eq(persistSrc:find("PlaySound", 1, true), nil, "persist source still has no PlaySound")
assert_eq(persistSrc:find("OnUpdate", 1, true), nil, "persist source still has no OnUpdate")
assert_eq(persistSrc:find("Media\\", 1, true), nil, "persist source still has no custom Media")
assert_eq(persistSrc:find(".tga", 1, true), nil, "persist source still has no custom tga")
assert_eq(persistSrc:find(".blp", 1, true), nil, "persist source still has no custom blp")
assert_eq(persistSrc:find(".ttf", 1, true), nil, "persist source still has no custom fonts")
assert_eq(persistSrc:find("Popes", 1, true), nil, "persist source has no Popes lookup")
assert_eq(persistSrc:find("IsRegisteredPope", 1, true), nil, "persist source has no IsRegisteredPope")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B15-A")
  assert_eq(COB.Popes, nil, "still no Pope list after B15-A")
  assert_eq(COB.Sender, nil, "still no Sender after B15-A")
  assert_eq(COB.Sound, nil, "still no Sound after B15-A")
  assert_eq(COB.Hud, nil, "still no Hud after B15-A")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B15-A still does not register a slash")
  assert_eq(COB.Console, nil, "still no Console after B16-B")
  assert_eq(COB.Popes, nil, "still no Pope list after B16-B")
  assert_eq(COB.Sender, nil, "still no Sender after B16-B")
  assert_eq(COB.Sound, nil, "still no Sound after B16-B")
  assert_eq(COB.Hud, nil, "still no Hud after B16-B")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B16-B still does not register a slash")
end

ChurchOfBeefDB = nil
dofile("addon/ChurchOfBeef/UI/Inputs.lua")
Inputs = COB.Inputs
frame = Inputs:Init()
assert_eq(select(1, frame:GetPoint(1)), "BOTTOM", "missing ChurchOfBeefDB restores BOTTOM")
assert_eq(select(2, frame:GetPoint(1)), UIParent, "missing ChurchOfBeefDB still parents to UIParent")
assert_eq(select(4, frame:GetPoint(1)), 0, "missing ChurchOfBeefDB restores x 0")
assert_eq(select(5, frame:GetPoint(1)), 80, "missing ChurchOfBeefDB restores y 80")
assert_eq(frame:GetScript("OnDragStart"), nil, "missing-DB root has no OnDragStart")
assert_eq(frame:GetScript("OnDragStop"), nil, "missing-DB root has no OnDragStop")
titleBar = rawget(frame, "TitleBar")
assert_true(titleBar ~= nil, "missing-DB TitleBar is still the drag handle")
if titleBar then
  stub.fire(titleBar, "OnDragStart")
  frame:ClearAllPoints()
  frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 99, 99)
  stub.fire(titleBar, "OnDragStop")
end
assert_eq(ChurchOfBeefDB, nil, "save no-ops when ChurchOfBeefDB is missing")
assert_eq(sounds, 0, "persist path plays no sound")
end
runB15A()

--------------------------------------------------------------------------------
-- B17-C: Petition may name UnitName("target") when it is not the whisper dest
-- and not the local player (Names.Same). Existing spies stay opponent-less
-- when stub target is nil. Nested so the main chunk stays under Lua 5.1's
-- 200-local cap.
--------------------------------------------------------------------------------
local function runB17C()
ChurchOfBeefDB = { ui = {} }
reset()
assert_true(Runtime:StartEvent() ~= nil, "B17-C StartEvent reaches ASSEMBLY")
local frame = Inputs:Init()
assert_true(frame ~= nil, "B17-C Init creates the frame")
assert_eq(frame:IsShown(), true, "B17-C Event Init shows the Inputs panel")
assert_eq(frame:GetWidth(), 328, "B17-C WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "B17-C HEIGHT stays 72")
assert_true(rawget(frame, "TitleBar") ~= nil, "B17-C TitleBar stays")
assert_eq(frame:GetScript("OnDragStart"), nil, "B17-C root still has no OnDragStart")

local box = editBox()
assert_true(box ~= nil, "B17-C confess box stays")
assert_true(box:GetScript("OnEscapePressed") ~= nil, "B17-C OnEscapePressed stays")
box:SetFocus()
assert_eq(box:HasFocus(), true, "B17-C editBox can take focus")
local fired, fireErr = pcall(function()
  stub.fire(box, "OnEscapePressed")
end)
assert_eq(fired, true, "B17-C OnEscapePressed fire does not error")
assert_eq(fireErr, nil, "B17-C OnEscapePressed fire has no error text")
assert_eq(box:HasFocus(), false, "B17-C ESC ClearFocus")
assert_eq(frame:IsShown(), true, "B17-C ESC does not Hide")
assert_eq(Inputs:GetView().shown, true, "B17-C GetView().shown stays true after ESC")

local listed = false
for i = 1, #UISpecialFrames do
  if UISpecialFrames[i] == "ChurchOfBeefInputs" then listed = true end
end
assert_eq(listed, false, "B17-C still not on UISpecialFrames")

Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)

local targetCalls = 0
local savedTargetUnit = TargetUnit
TargetUnit = function()
  targetCalls = targetCalls + 1
end

local ok, err = Inputs:Petition()
assert_eq(ok, true, "B17-C unset target still sends")
assert_eq(err, nil, "B17-C unset target has no error")
assert_eq(#sentPetitions, 1, "B17-C unset target sends once")
assert_eq(sentPetitions[1].target, "Host", "B17-C unset target whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B17-C unset target keeps characterId")
assert_eq(sentPetitions[1].fields.opponent, nil, "B17-C unset stub target omits opponent")
assert_eq(targetCalls, 0, "B17-C Petition does not TargetUnit")

local savedUnitName = UnitName
UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B17-C named target sends")
assert_eq(err, nil, "B17-C named target has no error")
assert_eq(#sentPetitions, 1, "B17-C named target sends once")
assert_eq(sentPetitions[1].target, "Host", "B17-C whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B17-C named target keeps characterId")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast", "B17-C names Chuckroast")
assert_eq(sentPetitions[1].fields.kind, nil, "B17-C does not invent a kind")
assert_eq(targetCalls, 0, "B17-C named Petition does not TargetUnit")

sentPetitions = {}
local petitionBtn = buttonFor("Petition")
assert_true(petitionBtn ~= nil, "B17-C Petition button stays")
assert_eq(stub.fire(petitionBtn, "OnClick"), true, "B17-C Petition click is wired")
assert_eq(#sentPetitions, 1, "B17-C click sends once")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast", "B17-C click names Chuckroast")
assert_eq(sentPetitions[1].target, "Host", "B17-C click whisper dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Host" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B17-C names-same Host still sends")
assert_eq(sentPetitions[1].fields.opponent, nil, "B17-C target names-same Host omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B17-C names-same Host whisper dest stays")
assert_eq(sentPetitions[1].fields.characterId, 7, "B17-C names-same Host keeps characterId")

UnitName = function(unit)
  if unit == "target" then return "Host-Whitemane" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B17-C target names-same Host realm omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B17-C realm-fold Host whisper dest stays")

UnitName = function(unit)
  if unit == "target" then return "Beefina" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B17-C names-same player still sends")
assert_eq(sentPetitions[1].fields.opponent, nil, "B17-C target names-same player omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B17-C self-target whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B17-C self-target keeps characterId")

UnitName = function(unit)
  if unit == "target" then return "Beefina-Whitemane" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B17-C target names-same player realm omits opponent")

UnitName = nil
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B17-C missing UnitName still sends")
assert_eq(err, nil, "B17-C missing UnitName has no error")
assert_eq(sentPetitions[1].fields.opponent, nil, "B17-C missing UnitName omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B17-C missing UnitName whisper dest stays")
assert_eq(sentPetitions[1].fields.characterId, 7, "B17-C missing UnitName keeps characterId")

UnitName = function()
  error("unitname failed")
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B17-C UnitName error still sends")
assert_eq(sentPetitions[1].fields.opponent, nil, "B17-C UnitName error omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B17-C UnitName error whisper dest stays")

UnitName = function(unit)
  if unit == "target" then return "" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B17-C empty target name omits opponent")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "Beefina" end
  return nil
end
assert_true(Runtime:EndEvent() ~= nil, "B17-C EndEvent returns QUIET")
sentPetitions = {}
ok = Inputs:Petition()
assert_eq(ok, false, "B17-C Quiet Petition is false")
assert_eq(#sentPetitions, 0, "B17-C Quiet does not send")

assert_eq(targetCalls, 0, "B17-C never TargetUnit")
assert_eq(sounds, 0, "B17-C plays no sound")
assert_eq(goraCalls, 0, "B17-C does not call Gora")

local challengeSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(challengeSrcFile ~= nil, "Inputs.lua is readable after B17-C pins")
local challengeSrc = challengeSrcFile:read("*a")
challengeSrcFile:close()
assert_true(challengeSrc:find('pcall(UnitName, "target")', 1, true) ~= nil,
  "UnitName target read is pcalled")
assert_true(challengeSrc:find('pcall(UnitName, "player")', 1, true) ~= nil,
  "UnitName player read is pcalled")
assert_true(challengeSrc:find("Names.Same", 1, true) ~= nil, "source compares with Names.Same")
assert_eq(challengeSrc:find("TargetUnit", 1, true), nil, "source does not TargetUnit")
assert_eq(challengeSrc:find("Gora:Petition", 1, true), nil, "source does not call Gora:Petition")
assert_eq(challengeSrc:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(challengeSrc:find("Popes", 1, true), nil, "source has no Popes lookup")
assert_eq(challengeSrc:find("IsRegisteredPope", 1, true), nil, "source has no IsRegisteredPope")
assert_eq(challengeSrc:find("UISpecialFrames", 1, true), nil, "source does not use UISpecialFrames")
assert_eq(challengeSrc:find("SUMMON", 1, true), nil, "source has no SUMMON")
assert_true(challengeSrc:find("OnEscapePressed", 1, true) ~= nil, "B17-C source keeps OnEscapePressed")
assert_true(challengeSrc:find("ClearFocus", 1, true) ~= nil, "B17-C source keeps ClearFocus")
assert_true(challengeSrc:find("SetMultiLine(true)", 1, true) ~= nil, "B17-C source keeps SetMultiLine(true)")
assert_true(challengeSrc:find("TitleBar", 1, true) ~= nil, "B17-C source keeps TitleBar")
assert_true(challengeSrc:find("db.inputs", 1, true) ~= nil, "B17-C source keeps ui.inputs persist")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B17-C")
  assert_eq(COB.Popes, nil, "still no Pope list after B17-C")
  assert_eq(COB.Sender, nil, "still no Sender after B17-C")
  assert_eq(COB.Sound, nil, "still no Sound after B17-C")
  assert_eq(COB.Hud, nil, "still no Hud after B17-C")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B17-C still does not register a slash")
end

UnitName = savedUnitName
TargetUnit = savedTargetUnit
end
runB17C()

--------------------------------------------------------------------------------
-- B18-A: confess box TOP / -14 (below 12px TitleBar). HEIGHT 72 stays.
-- Trim opponent: whitespace-only omits; padded "  Chuckroast  " sends
-- "Chuckroast". B17-C challenge law, TitleBar persist, ESC ClearFocus,
-- not UISpecialFrames stay. Nested so the main chunk stays under Lua 5.1's
-- 200-local cap. B21-D / B23-D / B33-A / B35-B / B37-D nest inside runB18A() (no new main-chunk locals).
--------------------------------------------------------------------------------
local function runB18A()
ChurchOfBeefDB = { ui = {} }
reset()
assert_true(Runtime:StartEvent() ~= nil, "B18-A StartEvent reaches ASSEMBLY")
local frame = Inputs:Init()
assert_true(frame ~= nil, "B18-A Init creates the frame")
assert_eq(frame:IsShown(), true, "B18-A Event Init shows the Inputs panel")
assert_eq(frame:GetWidth(), 328, "B18-A WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "B18-A HEIGHT stays 72")

local titleBar = rawget(frame, "TitleBar")
assert_true(titleBar ~= nil, "B18-A TitleBar stays")
if titleBar then
  assert_eq(titleBar:GetHeight(), 12, "B18-A TitleBar height stays 12")
end
assert_eq(frame:GetScript("OnDragStart"), nil, "B18-A root still has no OnDragStart")

local box = editBox()
assert_true(box ~= nil, "B18-A confess box stays")
assert_eq(box:GetHeight(), 22, "B18-A box height stays 22")
local bp, brto, brp, bx, by = box:GetPoint(1)
assert_eq(bp, "TOP", "B18-A confess box TOP")
assert_eq(brto, frame, "B18-A confess box relative is the root")
assert_eq(brp, "TOP", "B18-A confess box relativePoint TOP")
assert_eq(bx, 0, "B18-A confess box x stays 0")
assert_eq(by, -14, "B18-A confess box TOP offset is -14")
assert_true(by ~= nil and by <= -12, "B18-A confess box is fully below the 12px TitleBar")

local petitionBtn = buttonFor("Petition")
local catchupBtn = buttonFor("Catch up")
local confessBtn = buttonFor("Confess")
assert_true(petitionBtn ~= nil, "B18-A Petition button stays")
assert_true(catchupBtn ~= nil, "B18-A Catch up button stays")
assert_true(confessBtn ~= nil, "B18-A Confess button stays")
assert_eq(select(5, petitionBtn:GetPoint(1)), 10, "B18-A Petition stays BOTTOM + 10")
assert_eq(select(5, catchupBtn:GetPoint(1)), 10, "B18-A Catch up stays BOTTOM + 10")
assert_eq(select(5, confessBtn:GetPoint(1)), 10, "B18-A Confess stays BOTTOM + 10")

assert_true(box:GetScript("OnEscapePressed") ~= nil, "B18-A OnEscapePressed stays")
box:SetFocus()
assert_eq(box:HasFocus(), true, "B18-A editBox can take focus")
local fired, fireErr = pcall(function()
  stub.fire(box, "OnEscapePressed")
end)
assert_eq(fired, true, "B18-A OnEscapePressed fire does not error")
assert_eq(fireErr, nil, "B18-A OnEscapePressed fire has no error text")
assert_eq(box:HasFocus(), false, "B18-A ESC ClearFocus")
assert_eq(frame:IsShown(), true, "B18-A ESC does not Hide")
assert_eq(Inputs:GetView().shown, true, "B18-A GetView().shown stays true after ESC")

local listed = false
for i = 1, #UISpecialFrames do
  if UISpecialFrames[i] == "ChurchOfBeefInputs" then listed = true end
end
assert_eq(listed, false, "B18-A still not on UISpecialFrames")

Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)

local targetCalls = 0
local savedTargetUnit = TargetUnit
TargetUnit = function()
  targetCalls = targetCalls + 1
end
local savedUnitName = UnitName

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "Beefina" end
  return nil
end
local ok, err = Inputs:Petition()
assert_eq(ok, true, "B18-A named target still sends")
assert_eq(err, nil, "B18-A named target has no error")
assert_eq(#sentPetitions, 1, "B18-A named target sends once")
assert_eq(sentPetitions[1].target, "Host", "B18-A whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B18-A named target keeps characterId")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast", "B18-A existing Chuckroast pin stays")
assert_eq(targetCalls, 0, "B18-A Petition does not TargetUnit")

UnitName = function(unit)
  if unit == "target" then return "   " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B18-A whitespace-only target still sends")
assert_eq(err, nil, "B18-A whitespace-only target has no error")
assert_eq(#sentPetitions, 1, "B18-A whitespace-only target sends once")
assert_eq(sentPetitions[1].fields.opponent, nil, "B18-A whitespace-only target omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B18-A whitespace-only whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B18-A whitespace-only keeps characterId")

UnitName = function(unit)
  if unit == "target" then return "  Chuckroast  " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B18-A padded Chuckroast still sends")
assert_eq(err, nil, "B18-A padded Chuckroast has no error")
assert_eq(#sentPetitions, 1, "B18-A padded Chuckroast sends once")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast", "B18-A padded Chuckroast trims to Chuckroast")
assert_eq(sentPetitions[1].target, "Host", "B18-A padded Chuckroast whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B18-A padded Chuckroast keeps characterId")
assert_eq(sentPetitions[1].fields.kind, nil, "B18-A does not invent a kind")
assert_eq(targetCalls, 0, "B18-A padded Petition does not TargetUnit")

sentPetitions = {}
assert_eq(stub.fire(petitionBtn, "OnClick"), true, "B18-A Petition click is wired")
assert_eq(#sentPetitions, 1, "B18-A click sends once")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast", "B18-A click trims padded Chuckroast")
assert_eq(sentPetitions[1].target, "Host", "B18-A click whisper dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "  Host  " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B18-A padded Host after trim omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B18-A padded Host whisper dest stays")

UnitName = function(unit)
  if unit == "target" then return "  Beefina  " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B18-A padded player after trim omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B18-A padded player whisper dest stays")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "Beefina" end
  return nil
end
assert_true(Runtime:EndEvent() ~= nil, "B18-A EndEvent returns QUIET")
sentPetitions = {}
ok = Inputs:Petition()
assert_eq(ok, false, "B18-A Quiet Petition is false")
assert_eq(#sentPetitions, 0, "B18-A Quiet does not send")

assert_eq(targetCalls, 0, "B18-A never TargetUnit")
assert_eq(sounds, 0, "B18-A plays no sound")
assert_eq(goraCalls, 0, "B18-A does not call Gora")

local gapSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(gapSrcFile ~= nil, "Inputs.lua is readable after B18-A pins")
local gapSrc = gapSrcFile:read("*a")
gapSrcFile:close()
assert_true(gapSrc:find('SetPoint("TOP", widget, "TOP", 0, -14)', 1, true) ~= nil,
  "confess box SetPoint TOP -14")
assert_true(gapSrc:find('gsub("^%s+", "")', 1, true) ~= nil, "source trims leading whitespace")
assert_true(gapSrc:find('gsub("%s+$", "")', 1, true) ~= nil, "source trims trailing whitespace")
assert_true(gapSrc:find('pcall(UnitName, "target")', 1, true) ~= nil,
  "B18-A UnitName target read is pcalled")
assert_true(gapSrc:find('pcall(UnitName, "player")', 1, true) ~= nil,
  "B18-A UnitName player read is pcalled")
assert_true(gapSrc:find("Names.Same", 1, true) ~= nil, "B18-A source compares with Names.Same")
assert_eq(gapSrc:find("TargetUnit", 1, true), nil, "B18-A source does not TargetUnit")
assert_eq(gapSrc:find("Gora:Petition", 1, true), nil, "B18-A source does not call Gora:Petition")
assert_eq(gapSrc:find("PlaySound", 1, true), nil, "B18-A source does not play sound")
assert_eq(gapSrc:find("Popes", 1, true), nil, "B18-A source has no Popes lookup")
assert_eq(gapSrc:find("IsRegisteredPope", 1, true), nil, "B18-A source has no IsRegisteredPope")
assert_eq(gapSrc:find("UISpecialFrames", 1, true), nil, "B18-A source does not use UISpecialFrames")
assert_eq(gapSrc:find("SUMMON", 1, true), nil, "B18-A source has no SUMMON")
assert_true(gapSrc:find("OnEscapePressed", 1, true) ~= nil, "B18-A source keeps OnEscapePressed")
assert_true(gapSrc:find("ClearFocus", 1, true) ~= nil, "B18-A source keeps ClearFocus")
assert_true(gapSrc:find("SetMultiLine(true)", 1, true) ~= nil, "B18-A source keeps SetMultiLine(true)")
assert_true(gapSrc:find("TitleBar", 1, true) ~= nil, "B18-A source keeps TitleBar")
assert_true(gapSrc:find("db.inputs", 1, true) ~= nil, "B18-A source keeps ui.inputs persist")
assert_true(gapSrc:find("SetHeight(12)", 1, true) ~= nil, "B18-A source TitleBar height 12")
assert_true(gapSrc:find("local WIDTH, HEIGHT = 328, 72", 1, true) ~= nil,
  "B18-A source HEIGHT stays 72")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B18-A")
  assert_eq(COB.Popes, nil, "still no Pope list after B18-A")
  assert_eq(COB.Sender, nil, "still no Sender after B18-A")
  assert_eq(COB.Sound, nil, "still no Sound after B18-A")
  assert_eq(COB.Hud, nil, "still no Hud after B18-A")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B18-A still does not register a slash")
end

--------------------------------------------------------------------------------
-- B21-D: player pcall fail or non-string playerName omits opponent
-- (fail-closed). Unpadded Chuckroast + successful player still names
-- opponent. Quiet / ESC / TitleBar / isolation wrap stay. Nested in
-- runB18A() so the main chunk stays under Lua 5.1's 200-local cap.
-- B23-D / B33-A / B35-B / B37-D nest inside runB21D().
--------------------------------------------------------------------------------
local function runB21D()
ChurchOfBeefDB = { ui = {} }
reset()
assert_true(Runtime:StartEvent() ~= nil, "B21-D StartEvent reaches ASSEMBLY")
local frame = Inputs:Init()
assert_true(frame ~= nil, "B21-D Init creates the frame")
assert_eq(frame:IsShown(), true, "B21-D Event Init shows the Inputs panel")
assert_eq(frame:GetWidth(), 328, "B21-D WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "B21-D HEIGHT stays 72")

local titleBar = rawget(frame, "TitleBar")
assert_true(titleBar ~= nil, "B21-D TitleBar stays")
if titleBar then
  assert_eq(titleBar:GetHeight(), 12, "B21-D TitleBar height stays 12")
end
assert_eq(frame:GetScript("OnDragStart"), nil, "B21-D root still has no OnDragStart")

local box = editBox()
assert_true(box ~= nil, "B21-D confess box stays")
assert_true(box:GetScript("OnEscapePressed") ~= nil, "B21-D OnEscapePressed stays")
box:SetFocus()
assert_eq(box:HasFocus(), true, "B21-D editBox can take focus")
local fired, fireErr = pcall(function()
  stub.fire(box, "OnEscapePressed")
end)
assert_eq(fired, true, "B21-D OnEscapePressed fire does not error")
assert_eq(fireErr, nil, "B21-D OnEscapePressed fire has no error text")
assert_eq(box:HasFocus(), false, "B21-D ESC ClearFocus")
assert_eq(frame:IsShown(), true, "B21-D ESC does not Hide")
assert_eq(Inputs:GetView().shown, true, "B21-D GetView().shown stays true after ESC")

local listed = false
for i = 1, #UISpecialFrames do
  if UISpecialFrames[i] == "ChurchOfBeefInputs" then listed = true end
end
assert_eq(listed, false, "B21-D still not on UISpecialFrames")

Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then error("unitname player failed") end
  return nil
end
sentPetitions = {}
local ok, err = Inputs:Petition()
assert_eq(ok, true, "B21-D player-throw still sends")
assert_eq(err, nil, "B21-D player-throw has no error")
assert_eq(#sentPetitions, 1, "B21-D player-throw sends once")
assert_eq(sentPetitions[1].target, "Host", "B21-D player-throw whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B21-D player-throw keeps characterId")
assert_eq(sentPetitions[1].fields.opponent, nil, "B21-D player-throw omits opponent")
assert_eq(sentPetitions[1].fields.kind, nil, "B21-D does not invent a kind")
assert_eq(targetCalls, 0, "B21-D player-throw does not TargetUnit")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B21-D successful player still sends")
assert_eq(err, nil, "B21-D successful player has no error")
assert_eq(#sentPetitions, 1, "B21-D successful player sends once")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast",
  "B21-D unpadded Chuckroast + successful player still names opponent")
assert_eq(sentPetitions[1].target, "Host", "B21-D successful player whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B21-D successful player keeps characterId")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return nil end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B21-D non-string player omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B21-D non-string player whisper dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Host" end
  if unit == "player" then error("unitname player failed") end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B21-D dest-same still omits")
assert_eq(sentPetitions[1].target, "Host", "B21-D dest-same whisper dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Beefina" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B21-D player-same still omits")
assert_eq(sentPetitions[1].target, "Host", "B21-D player-same whisper dest stays Host")

UnitName = nil
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B21-D missing UnitName still sends")
assert_eq(err, nil, "B21-D missing UnitName has no error")
assert_eq(sentPetitions[1].fields.opponent, nil, "B21-D missing UnitName omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B21-D missing UnitName whisper dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then error("unitname player failed") end
  return nil
end
assert_true(Runtime:EndEvent() ~= nil, "B21-D EndEvent returns QUIET")
sentPetitions = {}
ok = Inputs:Petition()
assert_eq(ok, false, "B21-D Quiet Petition is false")
assert_eq(#sentPetitions, 0, "B21-D Quiet does not send")

assert_eq(targetCalls, 0, "B21-D never TargetUnit")
assert_eq(sounds, 0, "B21-D plays no sound")
assert_eq(goraCalls, 0, "B21-D does not call Gora")

local playerSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(playerSrcFile ~= nil, "Inputs.lua is readable after B21-D pins")
local playerSrc = playerSrcFile:read("*a")
playerSrcFile:close()
assert_true(playerSrc:find('if not pok or type(playerName) ~= "string"', 1, true) ~= nil,
  "B21-D failed player pcall or non-string playerName fail-closes")
assert_true(playerSrc:find('gsub("^%s+", "")', 1, true) ~= nil, "B21-D source still trims leading whitespace")
assert_true(playerSrc:find('gsub("%s+$", "")', 1, true) ~= nil, "B21-D source still trims trailing whitespace")
assert_true(playerSrc:find('pcall(UnitName, "target")', 1, true) ~= nil,
  "B21-D UnitName target read is pcalled")
assert_true(playerSrc:find('pcall(UnitName, "player")', 1, true) ~= nil,
  "B21-D UnitName player read is pcalled")
assert_true(playerSrc:find("Names.Same", 1, true) ~= nil, "B21-D source compares with Names.Same")
assert_eq(playerSrc:find("TargetUnit", 1, true), nil, "B21-D source does not TargetUnit")
assert_eq(playerSrc:find("Gora:Petition", 1, true), nil, "B21-D source does not call Gora:Petition")
assert_eq(playerSrc:find("PlaySound", 1, true), nil, "B21-D source does not play sound")
assert_eq(playerSrc:find("Popes", 1, true), nil, "B21-D source has no Popes lookup")
assert_eq(playerSrc:find("IsRegisteredPope", 1, true), nil, "B21-D source has no IsRegisteredPope")
assert_eq(playerSrc:find("UISpecialFrames", 1, true), nil, "B21-D source does not use UISpecialFrames")
assert_eq(playerSrc:find("SUMMON", 1, true), nil, "B21-D source has no SUMMON")
assert_true(playerSrc:find("OnEscapePressed", 1, true) ~= nil, "B21-D source keeps OnEscapePressed")
assert_true(playerSrc:find("ClearFocus", 1, true) ~= nil, "B21-D source keeps ClearFocus")
assert_true(playerSrc:find("SetMultiLine(true)", 1, true) ~= nil, "B21-D source keeps SetMultiLine(true)")
assert_true(playerSrc:find("TitleBar", 1, true) ~= nil, "B21-D source keeps TitleBar")
assert_true(playerSrc:find("db.inputs", 1, true) ~= nil, "B21-D source keeps ui.inputs persist")
assert_true(playerSrc:find("SetHeight(12)", 1, true) ~= nil, "B21-D source TitleBar height 12")
assert_true(playerSrc:find("local WIDTH, HEIGHT = 328, 72", 1, true) ~= nil,
  "B21-D source HEIGHT stays 72")
assert_true(playerSrc:find('SetPoint("TOP", widget, "TOP", 0, -14)', 1, true) ~= nil,
  "B21-D confess box SetPoint TOP -14 stays")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B21-D")
  assert_eq(COB.Popes, nil, "still no Pope list after B21-D")
  assert_eq(COB.Sender, nil, "still no Sender after B21-D")
  assert_eq(COB.Sound, nil, "still no Sound after B21-D")
  assert_eq(COB.Hud, nil, "still no Hud after B21-D")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B21-D still does not register a slash")
end

--------------------------------------------------------------------------------
-- B23-D: empty / whitespace UnitName("player") omits opponent after trim
-- (^%s+ / %s+$), like the target. Unpadded Chuckroast + successful
-- Beefina still names opponent. pcall fail / dest-same / missing
-- UnitName still omit. Quiet / ESC / TitleBar / isolation wrap stay.
-- Nested in runB21D() / runB18A() so the main chunk stays under
-- Lua 5.1's 200-local cap. B33-A / B35-B follow runB23D().
--------------------------------------------------------------------------------
local function runB23D()
ChurchOfBeefDB = { ui = {} }
reset()
assert_true(Runtime:StartEvent() ~= nil, "B23-D StartEvent reaches ASSEMBLY")
local frame = Inputs:Init()
assert_true(frame ~= nil, "B23-D Init creates the frame")
assert_eq(frame:IsShown(), true, "B23-D Event Init shows the Inputs panel")
assert_eq(frame:GetWidth(), 328, "B23-D WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "B23-D HEIGHT stays 72")

local titleBar = rawget(frame, "TitleBar")
assert_true(titleBar ~= nil, "B23-D TitleBar stays")
if titleBar then
  assert_eq(titleBar:GetHeight(), 12, "B23-D TitleBar height stays 12")
end
assert_eq(frame:GetScript("OnDragStart"), nil, "B23-D root still has no OnDragStart")

local box = editBox()
assert_true(box ~= nil, "B23-D confess box stays")
assert_true(box:GetScript("OnEscapePressed") ~= nil, "B23-D OnEscapePressed stays")
box:SetFocus()
assert_eq(box:HasFocus(), true, "B23-D editBox can take focus")
local fired, fireErr = pcall(function()
  stub.fire(box, "OnEscapePressed")
end)
assert_eq(fired, true, "B23-D OnEscapePressed fire does not error")
assert_eq(fireErr, nil, "B23-D OnEscapePressed fire has no error text")
assert_eq(box:HasFocus(), false, "B23-D ESC ClearFocus")
assert_eq(frame:IsShown(), true, "B23-D ESC does not Hide")
assert_eq(Inputs:GetView().shown, true, "B23-D GetView().shown stays true after ESC")

local listed = false
for i = 1, #UISpecialFrames do
  if UISpecialFrames[i] == "ChurchOfBeefInputs" then listed = true end
end
assert_eq(listed, false, "B23-D still not on UISpecialFrames")

Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "" end
  return nil
end
sentPetitions = {}
local ok, err = Inputs:Petition()
assert_eq(ok, true, "B23-D empty player still sends")
assert_eq(err, nil, "B23-D empty player has no error")
assert_eq(#sentPetitions, 1, "B23-D empty player sends once")
assert_eq(sentPetitions[1].target, "Host", "B23-D empty player whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B23-D empty player keeps characterId")
assert_eq(sentPetitions[1].fields.opponent, nil, "B23-D empty player omits opponent")
assert_eq(sentPetitions[1].fields.kind, nil, "B23-D does not invent a kind")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "   " end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B23-D whitespace player still sends")
assert_eq(err, nil, "B23-D whitespace player has no error")
assert_eq(#sentPetitions, 1, "B23-D whitespace player sends once")
assert_eq(sentPetitions[1].target, "Host", "B23-D whitespace player whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B23-D whitespace player keeps characterId")
assert_eq(sentPetitions[1].fields.opponent, nil, "B23-D whitespace player omits opponent")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B23-D successful player still sends")
assert_eq(err, nil, "B23-D successful player has no error")
assert_eq(#sentPetitions, 1, "B23-D successful player sends once")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast",
  "B23-D unpadded Chuckroast + successful player still names opponent")
assert_eq(sentPetitions[1].target, "Host", "B23-D successful player whisper dest stays Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B23-D successful player keeps characterId")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then error("unitname player failed") end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B23-D player pcall fail still omits")
assert_eq(sentPetitions[1].target, "Host", "B23-D player pcall fail whisper dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Host" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B23-D dest-same still omits")
assert_eq(sentPetitions[1].target, "Host", "B23-D dest-same whisper dest stays Host")

UnitName = nil
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B23-D missing UnitName still sends")
assert_eq(err, nil, "B23-D missing UnitName has no error")
assert_eq(sentPetitions[1].fields.opponent, nil, "B23-D missing UnitName omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B23-D missing UnitName whisper dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "" end
  return nil
end
assert_true(Runtime:EndEvent() ~= nil, "B23-D EndEvent returns QUIET")
sentPetitions = {}
ok = Inputs:Petition()
assert_eq(ok, false, "B23-D Quiet Petition is false")
assert_eq(#sentPetitions, 0, "B23-D Quiet does not send")

assert_eq(sounds, 0, "B23-D plays no sound")
assert_eq(goraCalls, 0, "B23-D does not call Gora")

local emptySrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(emptySrcFile ~= nil, "Inputs.lua is readable after B23-D pins")
local emptySrc = emptySrcFile:read("*a")
emptySrcFile:close()
assert_true(emptySrc:find('playerName:gsub("^%s+", ""):gsub("%s+$", "")', 1, true) ~= nil,
  "B23-D player name is trimmed like the target")
assert_true(emptySrc:find('if not pok or type(playerName) ~= "string"', 1, true) ~= nil,
  "B23-D failed player pcall or non-string playerName fail-closes")
assert_true(emptySrc:find('gsub("^%s+", "")', 1, true) ~= nil, "B23-D source still trims leading whitespace")
assert_true(emptySrc:find('gsub("%s+$", "")', 1, true) ~= nil, "B23-D source still trims trailing whitespace")
assert_true(emptySrc:find('pcall(UnitName, "target")', 1, true) ~= nil,
  "B23-D UnitName target read is pcalled")
assert_true(emptySrc:find('pcall(UnitName, "player")', 1, true) ~= nil,
  "B23-D UnitName player read is pcalled")
assert_true(emptySrc:find("Names.Same", 1, true) ~= nil, "B23-D source compares with Names.Same")
assert_eq(emptySrc:find("TargetUnit", 1, true), nil, "B23-D source does not TargetUnit")
assert_eq(emptySrc:find("Gora:Petition", 1, true), nil, "B23-D source does not call Gora:Petition")
assert_eq(emptySrc:find("PlaySound", 1, true), nil, "B23-D source does not play sound")
assert_eq(emptySrc:find("Popes", 1, true), nil, "B23-D source has no Popes lookup")
assert_eq(emptySrc:find("IsRegisteredPope", 1, true), nil, "B23-D source has no IsRegisteredPope")
assert_eq(emptySrc:find("UISpecialFrames", 1, true), nil, "B23-D source does not use UISpecialFrames")
assert_eq(emptySrc:find("SUMMON", 1, true), nil, "B23-D source has no SUMMON")
assert_true(emptySrc:find("OnEscapePressed", 1, true) ~= nil, "B23-D source keeps OnEscapePressed")
assert_true(emptySrc:find("ClearFocus", 1, true) ~= nil, "B23-D source keeps ClearFocus")
assert_true(emptySrc:find("SetMultiLine(true)", 1, true) ~= nil, "B23-D source keeps SetMultiLine(true)")
assert_true(emptySrc:find("TitleBar", 1, true) ~= nil, "B23-D source keeps TitleBar")
assert_true(emptySrc:find("db.inputs", 1, true) ~= nil, "B23-D source keeps ui.inputs persist")
assert_true(emptySrc:find("SetHeight(12)", 1, true) ~= nil, "B23-D source TitleBar height 12")
assert_true(emptySrc:find("local WIDTH, HEIGHT = 328, 72", 1, true) ~= nil,
  "B23-D source HEIGHT stays 72")
assert_true(emptySrc:find('SetPoint("TOP", widget, "TOP", 0, -14)', 1, true) ~= nil,
  "B23-D confess box SetPoint TOP -14 stays")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B23-D")
  assert_eq(COB.Popes, nil, "still no Pope list after B23-D")
  assert_eq(COB.Sender, nil, "still no Sender after B23-D")
  assert_eq(COB.Sound, nil, "still no Sound after B23-D")
  assert_eq(COB.Hud, nil, "still no Hud after B23-D")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B23-D still does not register a slash")
end
end
runB23D()

--------------------------------------------------------------------------------
-- B33-A: SetInputTarget trims the whisper dest (Names.Trim, fallback
-- ^%s+ / %s+$). Empty after trim is no target. Petition / Catchup /
-- Confess return "no target" and do not send. Padded "  Host  " stores
-- "Host". Opponent / player trim pins stay. Isolation wrap stays.
-- Nested after runB23D() so the main chunk stays under Lua 5.1's
-- 200-local cap. B35-B follows runB33A().
--------------------------------------------------------------------------------
local function runB33A()
ChurchOfBeefDB = { ui = {} }
reset()
assert_true(Runtime:StartEvent() ~= nil, "B33-A StartEvent reaches ASSEMBLY")
local frame = Inputs:Init()
assert_true(frame ~= nil, "B33-A Init creates the frame")
assert_eq(frame:IsShown(), true, "B33-A Event Init shows the Inputs panel")
assert_eq(frame:GetWidth(), 328, "B33-A WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "B33-A HEIGHT stays 72")

local titleBar = rawget(frame, "TitleBar")
assert_true(titleBar ~= nil, "B33-A TitleBar stays")
if titleBar then
  assert_eq(titleBar:GetHeight(), 12, "B33-A TitleBar height stays 12")
end
assert_eq(frame:GetScript("OnDragStart"), nil, "B33-A root still has no OnDragStart")

local box = editBox()
assert_true(box ~= nil, "B33-A confess box stays")
assert_true(box:GetScript("OnEscapePressed") ~= nil, "B33-A OnEscapePressed stays")

Inputs:SetLocalCharacterId(7)
Inputs:SetInputTarget("  Host  ")
assert_eq(Inputs:GetView().target, "Host", "B33-A padded Host stores Host")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
sentSnapshots = {}
sentConfessions = {}
local ok, err = Inputs:Petition()
assert_eq(ok, true, "B33-A padded dest still sends Petition")
assert_eq(err, nil, "B33-A padded dest Petition has no error")
assert_eq(#sentPetitions, 1, "B33-A padded dest sends Petition once")
assert_eq(sentPetitions[1].target, "Host", "B33-A Petition whispers trimmed Host")
assert_eq(sentPetitions[1].fields.characterId, 7, "B33-A padded dest keeps characterId")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast",
  "B33-A unpadded Chuckroast still names opponent")
assert_eq(sentPetitions[1].fields.kind, nil, "B33-A does not invent a kind")

ok, err = Inputs:Catchup()
assert_eq(ok, true, "B33-A padded dest still sends Catchup")
assert_eq(err, nil, "B33-A padded dest Catchup has no error")
assert_eq(#sentSnapshots, 1, "B33-A padded dest sends Catchup once")
assert_eq(sentSnapshots[1].target, "Host", "B33-A Catchup whispers trimmed Host")

ok, err = Inputs:Confess("forgive me")
assert_eq(ok, true, "B33-A padded dest still sends Confess")
assert_eq(err, nil, "B33-A padded dest Confess has no error")
assert_eq(#sentConfessions, 1, "B33-A padded dest sends Confess once")
assert_eq(sentConfessions[1].target, "Host", "B33-A Confess whispers trimmed Host")
assert_eq(sentConfessions[1].fields.text, "forgive me", "B33-A Confess text stays")

Inputs:SetInputTarget("   ")
assert_eq(Inputs:GetView().target, nil, "B33-A whitespace dest is no target")
sentPetitions = {}
sentSnapshots = {}
sentConfessions = {}
ok, err = Inputs:Petition()
assert_eq(ok, false, "B33-A whitespace dest refuses Petition")
assert_eq(err, "no target", "B33-A whitespace dest Petition is no target")
assert_eq(#sentPetitions, 0, "B33-A whitespace dest does not send Petition")
ok, err = Inputs:Catchup()
assert_eq(ok, false, "B33-A whitespace dest refuses Catchup")
assert_eq(err, "no target", "B33-A whitespace dest Catchup is no target")
assert_eq(#sentSnapshots, 0, "B33-A whitespace dest does not send Catchup")
ok, err = Inputs:Confess("forgive me")
assert_eq(ok, false, "B33-A whitespace dest refuses Confess")
assert_eq(err, "no target", "B33-A whitespace dest Confess is no target")
assert_eq(#sentConfessions, 0, "B33-A whitespace dest does not send Confess")

Inputs:SetInputTarget(" ")
assert_eq(Inputs:GetView().target, nil, "B33-A single-space dest is no target")
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, false, "B33-A single-space dest refuses Petition")
assert_eq(err, "no target", "B33-A single-space dest is no target")
assert_eq(#sentPetitions, 0, "B33-A single-space dest does not send")

Inputs:SetInputTarget("  Host  ")
assert_eq(Inputs:GetView().target, "Host", "B33-A re-set padded Host still stores Host")

UnitName = function(unit)
  if unit == "target" then return "   " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B33-A whitespace-only opponent still sends")
assert_eq(err, nil, "B33-A whitespace-only opponent has no error")
assert_eq(#sentPetitions, 1, "B33-A whitespace-only opponent sends once")
assert_eq(sentPetitions[1].fields.opponent, nil, "B33-A whitespace-only opponent omits")
assert_eq(sentPetitions[1].target, "Host", "B33-A whitespace-only opponent dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "  Chuckroast  " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B33-A padded Chuckroast still sends")
assert_eq(err, nil, "B33-A padded Chuckroast has no error")
assert_eq(#sentPetitions, 1, "B33-A padded Chuckroast sends once")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast",
  "B33-A padded Chuckroast trims to Chuckroast")
assert_eq(sentPetitions[1].target, "Host", "B33-A padded Chuckroast dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "  Host  " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B33-A padded Host after trim omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B33-A padded Host dest-same whisper dest stays")

UnitName = function(unit)
  if unit == "target" then return "  Beefina  " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B33-A padded player after trim omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B33-A padded player dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B33-A empty player still sends")
assert_eq(err, nil, "B33-A empty player has no error")
assert_eq(sentPetitions[1].fields.opponent, nil, "B33-A empty player omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B33-A empty player dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "   " end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B33-A whitespace player still sends")
assert_eq(err, nil, "B33-A whitespace player has no error")
assert_eq(sentPetitions[1].fields.opponent, nil, "B33-A whitespace player omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B33-A whitespace player dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "Beefina" end
  return nil
end
assert_true(Runtime:EndEvent() ~= nil, "B33-A EndEvent returns QUIET")
sentPetitions = {}
ok = Inputs:Petition()
assert_eq(ok, false, "B33-A Quiet Petition is false")
assert_eq(#sentPetitions, 0, "B33-A Quiet does not send")

assert_eq(sounds, 0, "B33-A plays no sound")
assert_eq(goraCalls, 0, "B33-A does not call Gora")

local destSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(destSrcFile ~= nil, "Inputs.lua is readable after B33-A pins")
local destSrc = destSrcFile:read("*a")
destSrcFile:close()
local setAt = destSrc:find("function Inputs:SetInputTarget", 1, true)
assert_true(setAt ~= nil, "B33-A SetInputTarget exists")
local setEnd = destSrc:find("\nfunction Inputs:", setAt + 1, true)
local setBody = destSrc:sub(setAt, setEnd or #destSrc)
assert_true(setBody:find("Names.Trim", 1, true) ~= nil, "B33-A SetInputTarget uses Names.Trim")
assert_true(setBody:find('gsub("^%s+", "")', 1, true) ~= nil,
  "B33-A SetInputTarget fallback trims leading whitespace")
assert_true(setBody:find('gsub("%s+$", "")', 1, true) ~= nil,
  "B33-A SetInputTarget fallback trims trailing whitespace")
assert_true(destSrc:find('playerName:gsub("^%s+", ""):gsub("%s+$", "")', 1, true) ~= nil,
  "B33-A player name trim stays")
assert_true(destSrc:find('targetName:gsub("^%s+", ""):gsub("%s+$", "")', 1, true) ~= nil,
  "B33-A opponent target trim stays")
assert_true(destSrc:find('if type(inputTarget) ~= "string" or inputTarget == ""', 1, true) ~= nil,
  "B33-A readyToSend / Catchup still refuse empty dest")
assert_eq(destSrc:find("Popes", 1, true), nil, "B33-A source has no Popes lookup")
assert_eq(destSrc:find("IsRegisteredPope", 1, true), nil, "B33-A source has no IsRegisteredPope")
assert_eq(destSrc:find("TargetUnit", 1, true), nil, "B33-A source does not TargetUnit")
assert_eq(destSrc:find("PlaySound", 1, true), nil, "B33-A source does not play sound")
assert_true(destSrc:find("OnEscapePressed", 1, true) ~= nil, "B33-A source keeps OnEscapePressed")
assert_true(destSrc:find("TitleBar", 1, true) ~= nil, "B33-A source keeps TitleBar")
assert_true(destSrc:find("local WIDTH, HEIGHT = 328, 72", 1, true) ~= nil,
  "B33-A source HEIGHT stays 72")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B33-A")
  assert_eq(COB.Popes, nil, "still no Pope list after B33-A")
  assert_eq(COB.Sender, nil, "still no Sender after B33-A")
  assert_eq(COB.Sound, nil, "still no Sound after B33-A")
  assert_eq(COB.Hud, nil, "still no Hud after B33-A")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B33-A still does not register a slash")
end
end
runB33A()

--------------------------------------------------------------------------------
-- B35-B: Confess trims optional text (Names.Trim, fallback ^%s+ /
-- %s+$). Empty after trim omits fields.text and still sends. Dest /
-- readyToSend stay. Opponent trim stays. Isolation wrap stays.
-- Nested after runB33A() inside runB21D() so the main chunk stays
-- under Lua 5.1's 200-local cap. B37-D follows runB35B().
--------------------------------------------------------------------------------
local function runB35B()
ChurchOfBeefDB = { ui = {} }
reset()
assert_true(Runtime:StartEvent() ~= nil, "B35-B StartEvent reaches ASSEMBLY")
local frame = Inputs:Init()
assert_true(frame ~= nil, "B35-B Init creates the frame")
assert_eq(frame:IsShown(), true, "B35-B Event Init shows the Inputs panel")
assert_eq(frame:GetWidth(), 328, "B35-B WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "B35-B HEIGHT stays 72")

local titleBar = rawget(frame, "TitleBar")
assert_true(titleBar ~= nil, "B35-B TitleBar stays")
if titleBar then
  assert_eq(titleBar:GetHeight(), 12, "B35-B TitleBar height stays 12")
end
assert_eq(frame:GetScript("OnDragStart"), nil, "B35-B root still has no OnDragStart")

local box = editBox()
assert_true(box ~= nil, "B35-B confess box stays")
assert_true(box:GetScript("OnEscapePressed") ~= nil, "B35-B OnEscapePressed stays")

Inputs:SetLocalCharacterId(7)
Inputs:SetInputTarget("  Host  ")
assert_eq(Inputs:GetView().target, "Host", "B35-B padded dest still stores Host")

sentConfessions = {}
local ok, err = Inputs:Confess("  forgive me  ")
assert_eq(ok, true, "B35-B padded text still sends")
assert_eq(err, nil, "B35-B padded text has no error")
assert_eq(#sentConfessions, 1, "B35-B padded text sends once")
assert_eq(sentConfessions[1].target, "Host", "B35-B padded text whispers trimmed Host")
assert_eq(sentConfessions[1].fields.characterId, 7, "B35-B padded text keeps characterId")
assert_eq(sentConfessions[1].fields.text, "forgive me", "B35-B padded text trims to forgive me")

sentConfessions = {}
ok, err = Inputs:Confess("   ")
assert_eq(ok, true, "B35-B whitespace text still sends")
assert_eq(err, nil, "B35-B whitespace text has no error")
assert_eq(#sentConfessions, 1, "B35-B whitespace text sends once")
assert_eq(sentConfessions[1].target, "Host", "B35-B whitespace text whispers Host")
assert_eq(sentConfessions[1].fields.characterId, 7, "B35-B whitespace text keeps characterId")
assert_eq(sentConfessions[1].fields.text, nil, "B35-B whitespace text omits fields.text")

box:SetText("   ")
sentConfessions = {}
ok, err = Inputs:Confess()
assert_eq(ok, true, "B35-B box-only whitespace still sends")
assert_eq(err, nil, "B35-B box-only whitespace has no error")
assert_eq(#sentConfessions, 1, "B35-B box-only whitespace sends once")
assert_eq(sentConfessions[1].target, "Host", "B35-B box-only whitespace whispers Host")
assert_eq(sentConfessions[1].fields.characterId, 7, "B35-B box-only whitespace keeps characterId")
assert_eq(sentConfessions[1].fields.text, nil, "B35-B box-only whitespace omits fields.text")

box:SetText("  typed in the box  ")
sentConfessions = {}
ok, err = Inputs:Confess()
assert_eq(ok, true, "B35-B padded box text still sends")
assert_eq(err, nil, "B35-B padded box text has no error")
assert_eq(#sentConfessions, 1, "B35-B padded box text sends once")
assert_eq(sentConfessions[1].fields.text, "typed in the box",
  "B35-B padded box text trims")
assert_eq(sentConfessions[1].target, "Host", "B35-B padded box dest stays Host")

sentConfessions = {}
ok, err = Inputs:Confess("forgive me")
assert_eq(ok, true, "B35-B unpadded text still sends")
assert_eq(err, nil, "B35-B unpadded text has no error")
assert_eq(sentConfessions[1].fields.text, "forgive me", "B35-B unpadded text stays")
assert_eq(sentConfessions[1].target, "Host", "B35-B unpadded text dest stays Host")

Inputs:SetInputTarget("   ")
assert_eq(Inputs:GetView().target, nil, "B35-B whitespace dest is still no target")
sentConfessions = {}
ok, err = Inputs:Confess("forgive me")
assert_eq(ok, false, "B35-B whitespace dest still refuses Confess")
assert_eq(err, "no target", "B35-B whitespace dest Confess is still no target")
assert_eq(#sentConfessions, 0, "B35-B whitespace dest does not send Confess")

Inputs:SetInputTarget("  Host  ")
assert_eq(Inputs:GetView().target, "Host", "B35-B re-set padded dest still stores Host")

UnitName = function(unit)
  if unit == "target" then return "   " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B35-B whitespace-only opponent still sends")
assert_eq(err, nil, "B35-B whitespace-only opponent has no error")
assert_eq(#sentPetitions, 1, "B35-B whitespace-only opponent sends once")
assert_eq(sentPetitions[1].fields.opponent, nil, "B35-B whitespace-only opponent omits")
assert_eq(sentPetitions[1].target, "Host", "B35-B whitespace-only opponent dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "  Chuckroast  " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B35-B padded Chuckroast still sends")
assert_eq(err, nil, "B35-B padded Chuckroast has no error")
assert_eq(#sentPetitions, 1, "B35-B padded Chuckroast sends once")
assert_eq(sentPetitions[1].fields.opponent, "Chuckroast",
  "B35-B padded Chuckroast trims to Chuckroast")
assert_eq(sentPetitions[1].target, "Host", "B35-B padded Chuckroast dest stays Host")

UnitName = function(unit)
  if unit == "target" then return "  Host  " end
  if unit == "player" then return "Beefina" end
  return nil
end
sentPetitions = {}
Inputs:Petition()
assert_eq(sentPetitions[1].fields.opponent, nil, "B35-B padded Host after trim omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B35-B padded Host dest-same whisper dest stays")

UnitName = function(unit)
  if unit == "target" then return "Chuckroast" end
  if unit == "player" then return "   " end
  return nil
end
sentPetitions = {}
ok, err = Inputs:Petition()
assert_eq(ok, true, "B35-B whitespace player still sends")
assert_eq(err, nil, "B35-B whitespace player has no error")
assert_eq(sentPetitions[1].fields.opponent, nil, "B35-B whitespace player omits opponent")
assert_eq(sentPetitions[1].target, "Host", "B35-B whitespace player dest stays Host")

assert_true(Runtime:EndEvent() ~= nil, "B35-B EndEvent returns QUIET")
sentConfessions = {}
ok = Inputs:Confess("forgive me")
assert_eq(ok, false, "B35-B Quiet Confess is false")
assert_eq(#sentConfessions, 0, "B35-B Quiet does not send")

assert_eq(sounds, 0, "B35-B plays no sound")
assert_eq(goraCalls, 0, "B35-B does not call Gora")

local confessSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(confessSrcFile ~= nil, "Inputs.lua is readable after B35-B pins")
local confessSrc = confessSrcFile:read("*a")
confessSrcFile:close()
local confessAt = confessSrc:find("function Inputs:Confess", 1, true)
assert_true(confessAt ~= nil, "B35-B Confess exists")
local confessEnd = confessSrc:find("\nfunction Inputs:", confessAt + 1, true)
local confessBody = confessSrc:sub(confessAt, confessEnd or #confessSrc)
assert_true(confessBody:find("Names.Trim", 1, true) ~= nil, "B35-B Confess uses Names.Trim")
assert_true(confessBody:find('gsub("^%s+", "")', 1, true) ~= nil,
  "B35-B Confess fallback trims leading whitespace")
assert_true(confessBody:find('gsub("%s+$", "")', 1, true) ~= nil,
  "B35-B Confess fallback trims trailing whitespace")
local setAt = confessSrc:find("function Inputs:SetInputTarget", 1, true)
assert_true(setAt ~= nil, "B35-B SetInputTarget exists")
local setEnd = confessSrc:find("\nfunction Inputs:", setAt + 1, true)
local setBody = confessSrc:sub(setAt, setEnd or #confessSrc)
assert_true(setBody:find("Names.Trim", 1, true) ~= nil, "B35-B SetInputTarget still uses Names.Trim")
assert_true(confessSrc:find('playerName:gsub("^%s+", ""):gsub("%s+$", "")', 1, true) ~= nil,
  "B35-B player name trim stays")
assert_true(confessSrc:find('targetName:gsub("^%s+", ""):gsub("%s+$", "")', 1, true) ~= nil,
  "B35-B opponent target trim stays")
assert_true(confessSrc:find('if type(inputTarget) ~= "string" or inputTarget == ""', 1, true) ~= nil,
  "B35-B readyToSend / Catchup still refuse empty dest")
assert_eq(confessSrc:find("Popes", 1, true), nil, "B35-B source has no Popes lookup")
assert_eq(confessSrc:find("IsRegisteredPope", 1, true), nil, "B35-B source has no IsRegisteredPope")
assert_eq(confessSrc:find("TargetUnit", 1, true), nil, "B35-B source does not TargetUnit")
assert_eq(confessSrc:find("PlaySound", 1, true), nil, "B35-B source does not play sound")
assert_true(confessSrc:find("OnEscapePressed", 1, true) ~= nil, "B35-B source keeps OnEscapePressed")
assert_true(confessSrc:find("TitleBar", 1, true) ~= nil, "B35-B source keeps TitleBar")
assert_true(confessSrc:find("local WIDTH, HEIGHT = 328, 72", 1, true) ~= nil,
  "B35-B source HEIGHT stays 72")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B35-B")
  assert_eq(COB.Popes, nil, "still no Pope list after B35-B")
  assert_eq(COB.Sender, nil, "still no Sender after B35-B")
  assert_eq(COB.Sound, nil, "still no Sound after B35-B")
  assert_eq(COB.Hud, nil, "still no Hud after B35-B")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B35-B still does not register a slash")
end
end
runB35B()

--------------------------------------------------------------------------------
-- B37-D: Quiet Hide blanks leftover confess text. paintHidden
-- SetText("") if confessBox is present. Dest / inputTarget persist.
-- Width / ESC ClearFocus stay. New Event Show + Confess() without
-- a new arg does not send leftover text. Isolation wrap stays.
-- Nested after runB35B() inside runB21D() so the main chunk stays
-- under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB37D()
ChurchOfBeefDB = { ui = {} }
reset()
assert_true(Runtime:StartEvent() ~= nil, "B37-D StartEvent reaches ASSEMBLY")
local frame = Inputs:Init()
assert_true(frame ~= nil, "B37-D Init creates the frame")
assert_eq(frame:IsShown(), true, "B37-D Event Init shows the Inputs panel")
assert_eq(frame:GetWidth(), 328, "B37-D WIDTH stays 328")
assert_eq(frame:GetHeight(), 72, "B37-D HEIGHT stays 72")

local titleBar = rawget(frame, "TitleBar")
assert_true(titleBar ~= nil, "B37-D TitleBar stays")
if titleBar then
  assert_eq(titleBar:GetHeight(), 12, "B37-D TitleBar height stays 12")
end
assert_eq(frame:GetScript("OnDragStart"), nil, "B37-D root still has no OnDragStart")

local box = editBox()
assert_true(box ~= nil, "B37-D confess box stays")
assert_true(box:GetScript("OnEscapePressed") ~= nil, "B37-D OnEscapePressed stays")
box:SetFocus()
assert_eq(box:HasFocus(), true, "B37-D editBox can take focus")
local fired, fireErr = pcall(function()
  stub.fire(box, "OnEscapePressed")
end)
assert_eq(fired, true, "B37-D OnEscapePressed fire does not error")
assert_eq(fireErr, nil, "B37-D OnEscapePressed fire has no error text")
assert_eq(box:HasFocus(), false, "B37-D ESC ClearFocus")
assert_eq(frame:IsShown(), true, "B37-D ESC does not Hide")

Inputs:SetLocalCharacterId(7)
Inputs:SetInputTarget("Host")
assert_eq(Inputs:GetView().target, "Host", "B37-D dest stores Host")

box:SetText("leftover line")
assert_eq(box:GetText(), "leftover line", "B37-D box holds leftover text")

assert_true(Runtime:EndEvent() ~= nil, "B37-D EndEvent returns QUIET")
assert_eq(Inputs:Hide(), true, "B37-D Quiet Hide returns true")
assert_eq(frame:IsShown(), false, "B37-D Quiet Hide dismisses the widget")
assert_eq(box:GetText(), "", "B37-D Quiet Hide blanks leftover confess text")
assert_eq(Inputs:GetView().target, "Host", "B37-D dest stays after Quiet Hide")
assert_eq(Inputs:GetView().shown, false, "B37-D view is hidden after Quiet Hide")

assert_true(Runtime:StartEvent() ~= nil, "B37-D new Event reaches ASSEMBLY")
assert_eq(Inputs:Show(), true, "B37-D new Event Show")
assert_eq(frame:IsShown(), true, "B37-D new Event Show paints the widget")
assert_eq(box:GetText(), "", "B37-D box stays blank after new Event Show")
assert_eq(Inputs:GetView().target, "Host", "B37-D dest stays after new Event Show")

sentConfessions = {}
local ok, err = Inputs:Confess()
assert_eq(ok, true, "B37-D Confess without arg still sends")
assert_eq(err, nil, "B37-D Confess without arg has no error")
assert_eq(#sentConfessions, 1, "B37-D Confess without arg sends once")
assert_eq(sentConfessions[1].target, "Host", "B37-D Confess without arg dest stays Host")
assert_eq(sentConfessions[1].fields.characterId, 7, "B37-D Confess without arg keeps characterId")
local sentText = sentConfessions[1].fields.text
assert_true(sentText == nil or sentText == "",
  "B37-D Confess without arg does not send leftover text")
assert_eq(sentText ~= "leftover line", true, "B37-D leftover line is not sent")

assert_eq(sounds, 0, "B37-D plays no sound")
assert_eq(goraCalls, 0, "B37-D does not call Gora")

local wipeSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
assert_true(wipeSrcFile ~= nil, "Inputs.lua is readable after B37-D pins")
local wipeSrc = wipeSrcFile:read("*a")
wipeSrcFile:close()
local paintAt = wipeSrc:find("local function paintHidden", 1, true)
assert_true(paintAt ~= nil, "B37-D paintHidden exists")
local paintEnd = wipeSrc:find("\nlocal function paintShown", paintAt + 1, true)
local paintBody = wipeSrc:sub(paintAt, paintEnd or #wipeSrc)
assert_true(paintBody:find('SetText("")', 1, true) ~= nil,
  "B37-D paintHidden blanks confessBox with SetText")
assert_eq(paintBody:find("inputTarget", 1, true), nil,
  "B37-D paintHidden does not clear dest")
assert_true(wipeSrc:find("function Inputs:Hide", 1, true) ~= nil, "B37-D Hide stays")
local hideAt = wipeSrc:find("function Inputs:Hide", 1, true)
local hideEnd = wipeSrc:find("\nfunction Inputs:", hideAt + 1, true)
local hideBody = wipeSrc:sub(hideAt, hideEnd or #wipeSrc)
assert_true(hideBody:find("paintHidden()", 1, true) ~= nil, "B37-D Hide still calls paintHidden")
assert_true(wipeSrc:find("OnEscapePressed", 1, true) ~= nil, "B37-D source keeps OnEscapePressed")
assert_true(wipeSrc:find("ClearFocus", 1, true) ~= nil, "B37-D source keeps ClearFocus")
assert_true(wipeSrc:find("local WIDTH, HEIGHT = 328, 72", 1, true) ~= nil,
  "B37-D source HEIGHT stays 72")
assert_eq(wipeSrc:find("Popes", 1, true), nil, "B37-D source has no Popes lookup")
assert_eq(wipeSrc:find("IsRegisteredPope", 1, true), nil, "B37-D source has no IsRegisteredPope")
assert_eq(wipeSrc:find("TargetUnit", 1, true), nil, "B37-D source does not TargetUnit")
assert_eq(wipeSrc:find("PlaySound", 1, true), nil, "B37-D source does not play sound")

if standalone then
  assert_eq(COB.Console, nil, "still no Console after B37-D")
  assert_eq(COB.Popes, nil, "still no Pope list after B37-D")
  assert_eq(COB.Sender, nil, "still no Sender after B37-D")
  assert_eq(COB.Sound, nil, "still no Sound after B37-D")
  assert_eq(COB.Hud, nil, "still no Hud after B37-D")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B37-D still does not register a slash")
end
end
runB37D()
end
runB21D()

UnitName = savedUnitName
TargetUnit = savedTargetUnit
end
runB18A()

assert_eq(sounds, 0, "the suite played no sound")
assert_eq(#stub.chat, 0, "the suite never SendChatMessage")
assert_eq(#stub.addonMessages, 0, "the suite never SendAddonMessage")

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
