-- Event congregation Ask to fight strip (Wave 2 Task 12; formerly Lane W /
-- B4-G, B5-E, B14-B, B15-A, B16-B, B17-C, B18-A, B21-D, B23-D, B33-A, B35-B,
-- B37-D, U-Q). Isolated: wow_ui_stub + Common + Runtime + Theme + Inputs. Stub
-- COB.Net.SendPetition + DefaultDest. Event Mode only. No Gora:Petition. No
-- Proclaim. No sound. No SendChatMessage. Isolation wrap. No TOC / bootstrap /
-- run.lua. Face is Ask to fight (header is not EVENT INPUT). Hidden on a
-- listed Pope (Sender:IsRegisteredPope). Dest line and send dest share
-- Net:DefaultDest() (last STATE sender else Popes.List[1]). Ask may name
-- UnitName("target") when it is not the effective dest and not the local
-- player (Names.Same). Both UnitName reads are pcalled. TitleBar drag persist
-- writes ChurchOfBeefDB.ui.inputs. Root has no RegisterForDrag. ResetForTests
-- does not wipe SV. U-Q: stock GameFontHighlight verb scan. Button Y stays 10
-- (B18-A). Zip-fresh empty store does not Ensure / CreateHuman.
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
dofile("addon/ChurchOfBeef/UI/Theme.lua")
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
local goraCalls = 0
local proclaimCalls = 0

local function stubDestName(target)
  if COB.Names and type(COB.Names.Trim) == "function" then
    return COB.Names.Trim(target)
  end
  if type(target) ~= "string" then return nil end
  target = target:gsub("^%s+", ""):gsub("%s+$", "")
  if target == "" then return nil end
  return target
end

local function stubNet()
  sentPetitions = {}
  COB.Net = {
    _lastStateSender = nil,
    DefaultDest = function(self)
      local last = stubDestName(self._lastStateSender)
      if last then return last end
      local popes = COB.Popes
      local list = type(popes) == "table" and popes.List or nil
      if type(list) ~= "table" then return nil end
      return stubDestName(list[1])
    end,
    SendPetition = function(_, fields, target)
      sentPetitions[#sentPetitions + 1] = { fields = fields, target = target }
      return true
    end,
  }
end

-- Already-asked is event-scoped (no TTL). Multi-send pins re-arm the strip
-- without ending the gathering.
local function rearmAsk()
  local view = Inputs:GetView()
  local target = view and view.target
  local id = view and view.characterId
  Inputs:ResetForTests()
  Inputs:Init()
  if target ~= nil then Inputs:SetInputTarget(target) end
  if id ~= nil then Inputs:SetLocalCharacterId(id) end
  if Runtime:Snapshot().state ~= "QUIET" then
    Inputs:Show()
  end
end

local function reset()
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Inputs:ResetForTests(), true, "Inputs ResetForTests runs under _IN_TEST")
  sounds = 0
  goraCalls = 0
  proclaimCalls = 0
  COB.Popes = nil
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
assert_eq(type(Inputs.Petition), "function", "Petition is the congregation send verb")
assert_eq(Inputs.Confess, nil, "Confess is gone")
assert_eq(Inputs.Catchup, nil, "Catchup is gone")
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
-- Source contract: Net only. No theater, no Pope lookup beyond COB.Popes.List,
-- no local Gora write. The box and the second/third verbs are gone.
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
assert_true(src:find("COB.Popes", 1, true) ~= nil, "recipient line reads COB.Popes.List")
assert_eq(src:find("LookupPope", 1, true), nil, "source has no Pope lookup")
assert_eq(src:find("FindPope", 1, true), nil, "source has no Pope finder")
assert_true(src:find("IsRegisteredPope", 1, true) ~= nil,
  "source hides the strip on Sender:IsRegisteredPope")
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
assert_true(src:find('"Ask to fight"', 1, true) ~= nil, "Ask to fight is the face")
assert_eq(src:find('"Petition"', 1, true), nil, "face is not Petition")
assert_eq(src:find("EVENT INPUT", 1, true), nil, "header is not EVENT INPUT")
assert_true(src:find("SendPetition", 1, true) ~= nil, "Ask sends through Net")
assert_true(src:find("DefaultDest", 1, true) ~= nil, "dest line shares Net DefaultDest")
assert_eq(src:find("EnsureCharacterByName", 1, true), nil, "source does not EnsureCharacterByName")
assert_eq(src:find("CreateHuman", 1, true), nil, "source does not CreateHuman")
assert_eq(src:find("CreateCharacter", 1, true), nil, "source does not CreateCharacter")
assert_eq(src:find("InputBoxTemplate", 1, true), nil, "the confession EditBox is gone")
assert_eq(src:find("confessBox", 1, true), nil, "no confessBox widget key anymore")
assert_eq(src:find("OnEscapePressed", 1, true), nil, "no box ESC handler anymore")
assert_eq(src:find("SetMultiLine", 1, true), nil, "no multiline box anymore")
assert_eq(src:find("Confess", 1, true), nil, "no Confess verb anymore")
assert_eq(src:find("Catchup", 1, true), nil, "no Catchup verb anymore")
assert_eq(src:find("Catch up", 1, true), nil, "no Catch up label anymore")
assert_eq(src:find("SendConfession", 1, true), nil, "source never sends confession text")
assert_eq(src:find("RequestSnapshot", 1, true), nil, "source never requests a snapshot")
assert_eq(src:find("UISpecialFrames", 1, true), nil, "source does not use UISpecialFrames")
assert_eq(src:find("SUMMON", 1, true), nil, "source has no SUMMON")
assert_true(src:find("GameFontHighlight", 1, true) ~= nil, "verb labels use GameFontHighlight")
assert_eq(src:find("TitleText", 1, true), nil, "source has no TitleText")
assert_true(src:find("CreateFontString", 1, true) ~= nil, "source creates functional labels")
assert_true(src:find('"Ask to fight"', 1, true) ~= nil, "source labels the surface Ask to fight")
assert_true(src:find('"No recipient"', 1, true) ~= nil, "source names the empty recipient")

--------------------------------------------------------------------------------
-- Init is hidden in Quiet. Stock Petition only. No EditBox.
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
assert_eq(frame._template, "BackdropTemplate", "functional panel uses stock tooltip backdrop support")
assert_eq(frame._cobBackdrop, "tooltip", "panel uses the shared tooltip backdrop")
assert_eq(frame:GetWidth(), 360, "WIDTH stays 360")
assert_eq(frame:GetHeight(), 64, "HEIGHT shrinks to the one-button strip")
assert_eq(frame.HeaderText and frame.HeaderText:GetText(), "Ask to fight", "panel identifies its purpose")
assert_eq(frame.TargetText and frame.TargetText:GetText(), "No recipient", "missing recipient is explicit")
assert_true(frame.ReasonText ~= nil, "strip paints fireable reasons")
assert_eq(frame.ReasonText and frame.ReasonText:GetText(), "", "Quiet Init has no reason")

local petitionBtn = buttonFor("Ask to fight")
assert_true(petitionBtn ~= nil, "Ask to fight button exists")
assert_eq(petitionBtn._template, "UIPanelButtonTemplate", "Ask to fight is a stock panel button")
assert_eq(buttonFor("Confess"), nil, "no Confess button anymore")
assert_eq(buttonFor("Catch up"), nil, "no Catch up button anymore")
assert_eq(buttonFor("Proclaim"), nil, "no Proclaim chrome")
assert_eq(buttonFor("SANCTION"), nil, "no SANCTION chrome")
assert_eq(editBox(), nil, "no confession EditBox anymore")
assert_eq(petitionBtn:IsEnabled(), false, "Quiet Petition is visibly unavailable")
assert_true(petitionBtn:GetScript("OnEnter") ~= nil, "Petition explains itself on hover")

local listed = false
for i = 1, #UISpecialFrames do
  if UISpecialFrames[i] == "ChurchOfBeefInputs" then listed = true end
end
assert_eq(listed, false, "Inputs is not registered on UISpecialFrames")

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
assert_eq(sounds, 0, "Quiet plays no sound")
assert_eq(#stub.chat, 0, "Quiet does not SendChatMessage")
assert_eq(#stub.addonMessages, 0, "Quiet does not SendAddonMessage")

--------------------------------------------------------------------------------
-- Event without target / listed Pope. Missing dest names the error.
-- Zip-fresh empty store: no character id still sends a placeholder.
--------------------------------------------------------------------------------
reset()
assert_true(Runtime:StartEvent() ~= nil, "StartEvent reaches ASSEMBLY")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY")
frame = Inputs:Init()
assert_eq(Inputs:Show(), true, "Event Show is true")
assert_eq(frame:IsShown(), true, "Event Show paints the widget")
assert_eq(Inputs:GetView().shown, true, "Event view is shown")

ok, err = Inputs:Petition()
assert_eq(ok, false, "Ask without target or listed Pope is refused")
assert_eq(err, "no target", "missing target and Pope names the error")
assert_eq(#sentPetitions, 0, "missing target and Pope does not send")

Inputs:SetInputTarget("")
ok, err = Inputs:Petition()
assert_eq(ok, false, "empty target without a listed Pope is refused")
assert_eq(err, "no target", "empty target is no target")

Inputs:SetInputTarget("Host")
ok, err = Inputs:Petition()
assert_eq(ok, true, "empty store still asks without a local character id")
assert_eq(err, nil, "placeholder ask has no error")
assert_eq(#sentPetitions, 1, "empty store sends once")
assert_eq(sentPetitions[1].fields.characterId, 1, "closed wire carries a placeholder id")
assert_eq(Inputs:GetView().characterId, nil, "empty store does not mint localCharacterId")

COB.Popes = { List = { "Popeonius" } }
Inputs:SetInputTarget(nil)
rearmAsk()
ok, err = Inputs:Petition()
assert_eq(ok, true, "a listed Pope without a character still sends")
assert_eq(sentPetitions[#sentPetitions].target, "Popeonius",
  "listed-Pope dest line and send dest match")
assert_eq(sentPetitions[#sentPetitions].fields.characterId, 1,
  "listed-Pope empty store still uses the placeholder")
COB.Popes = nil

--------------------------------------------------------------------------------
-- StartEvent + target + id → Petition spies Net. Button click is wired.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Inputs:Init()
Inputs:SetInputTarget("Host")
Inputs:SetLocalCharacterId(7)
assert_eq(Inputs:Show(), true, "armed Event Show is true")
assert_eq(Inputs.frame.TargetText:GetText(), "To: Host", "Event panel names the bound recipient")
assert_eq(buttonFor("Ask to fight"):IsEnabled(), true, "armed Petition is visibly available")

ok, err = Inputs:Petition()
assert_eq(ok, true, "Ask sends when target and id are present")
assert_eq(err, nil, "successful Ask has no error")
assert_eq(#sentPetitions, 1, "SendPetition is called once")
assert_eq(sentPetitions[1].target, "Host", "SendPetition uses SetInputTarget")
assert_eq(sentPetitions[1].fields.characterId, 7, "SendPetition carries characterId")
assert_eq(sentPetitions[1].fields.kind, nil, "Inputs does not invent a kind field")
assert_eq(sentPetitions[1].fields.opponent, nil, "unset stub target omits opponent")
assert_eq(Inputs.frame.ReasonText:GetText(), "Asked. Waiting.",
  "successful send paints asked / waiting")
assert_eq(buttonFor("Ask to fight"):IsEnabled(), false, "asked / waiting disables the verb")

rearmAsk()
petitionBtn = buttonFor("Ask to fight")
sentPetitions = {}
assert_eq(stub.fire(petitionBtn, "OnClick"), true, "Ask to fight button is wired")
assert_eq(#sentPetitions, 1, "Ask click spies Net")
assert_eq(sentPetitions[1].target, "Host", "Ask click uses the stored target")
assert_eq(sentPetitions[1].fields.characterId, 7, "Ask click uses the stored id")

assert_eq(sounds, 0, "sending plays no sound")
assert_eq(#stub.chat, 0, "sending does not SendChatMessage")
assert_eq(#stub.addonMessages, 0, "sending does not SendAddonMessage")

--------------------------------------------------------------------------------
-- Lane W: recipient display resolves bound target > listed Pope > none, and
-- Petition availability may rely on the Net default when a listed Pope exists.
--------------------------------------------------------------------------------
local function runRecipient()
  reset()
  assert_true(Runtime:StartEvent() ~= nil, "recipient StartEvent reaches ASSEMBLY")
  local frame = Inputs:Init()
  assert_eq(Inputs:Show(), true, "recipient Event Show is true")
  assert_eq(frame.TargetText:GetText(), "No recipient", "no target and no Pope is explicit")
  assert_eq(buttonFor("Ask to fight"):IsEnabled(), false, "no target and no Pope disables Petition")

  COB.Popes = { List = { "Popeonius" } }
  Inputs:Refresh()
  assert_eq(frame.TargetText:GetText(), "To: Popeonius", "listed Pope is the effective recipient")
  assert_eq(Inputs:GetView().target, nil, "the view still reports no bound target")

  Inputs:SetLocalCharacterId(7)
  assert_eq(buttonFor("Ask to fight"):IsEnabled(), true,
    "a listed Pope enables Petition without a bound target")
  local ok, err = Inputs:Petition()
  assert_eq(ok, true, "Ask sends with a listed Pope and no bound target")
  assert_eq(err, nil, "listed-Pope Ask has no error")
  assert_eq(#sentPetitions, 1, "listed-Pope Ask sends once")
  assert_eq(sentPetitions[1].target, "Popeonius", "send dest is DefaultDest List[1]")
  assert_eq(frame.TargetText:GetText(), "To: " .. sentPetitions[1].target,
    "dest line equals send dest")
  assert_eq(sentPetitions[1].fields.characterId, 7, "listed-Pope Ask carries characterId")

  Inputs:SetInputTarget("Host")
  rearmAsk()
  frame = Inputs.frame
  assert_eq(frame.TargetText:GetText(), "To: Host", "a bound target wins over the listed Pope")
  assert_eq(Inputs:GetView().target, "Host", "the view reports the bound target")
  sentPetitions = {}
  ok, err = Inputs:Petition()
  assert_eq(ok, true, "bound-target Ask still sends")
  assert_eq(sentPetitions[1].target, "Host", "the bound target wins on the wire")
  assert_eq(frame.TargetText:GetText(), "To: " .. sentPetitions[1].target,
    "bound dest line equals send dest")

  Inputs:SetInputTarget(nil)
  rearmAsk()
  frame = Inputs.frame
  assert_eq(frame.TargetText:GetText(), "To: Popeonius", "clearing the target falls back to the Pope")
  COB.Popes = nil
  Inputs:Refresh()
  assert_eq(frame.TargetText:GetText(), "No recipient", "no target and no Pope is explicit again")
  assert_eq(buttonFor("Ask to fight"):IsEnabled(), false, "Ask disables again without either")
  sentPetitions = {}
  ok, err = Inputs:Petition()
  assert_eq(ok, false, "Ask refuses again without target or Pope")
  assert_eq(err, "no target", "refused Petition names no target")
  assert_eq(#sentPetitions, 0, "refused Petition does not send")

  assert_eq(sounds, 0, "recipient lane plays no sound")
  assert_eq(goraCalls, 0, "recipient lane does not call Gora")
end
runRecipient()

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
COB.Runtime = savedRuntime
assert_eq(Inputs:Show(), true, "restored Runtime Show is true")

COB.Net = nil
ok, err = Inputs:Petition()
assert_eq(ok, false, "missing Net Petition is false")
assert_eq(err, "no net", "missing Net names the error")
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
assert_eq(Inputs:GetView().target, "Host", "dest stays after Hide")
view = Inputs:Refresh()
assert_eq(view.shown, true, "Refresh in Event shows again")
assert_eq(frame:IsShown(), true, "Refresh paints the widget")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent returns to QUIET")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET")
view = Inputs:Refresh()
assert_eq(view.shown, false, "Quiet Refresh hides the panel")
assert_eq(frame:IsShown(), false, "Quiet Refresh hides the widget")
assert_eq(Inputs:GetView().target, "Host", "dest stays after Quiet Hide")
assert_eq(Inputs:Show(), false, "Quiet Show is false after EndEvent")
assert_eq(Inputs:Petition(), false, "Quiet Petition is false after EndEvent")
assert_eq(#sentPetitions, 0, "Quiet after EndEvent does not send")

assert_true(Runtime:StartEvent() ~= nil, "a new event starts")
assert_eq(Inputs:Show(), true, "Show in the new event")
assert_eq(Inputs:GetView().target, "Host", "dest stays after a new Event Show")

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
-- pattern). Root has no OnDragStart. TitleBar exists, TOPLEFT/TOPRIGHT, title
-- and recipient labels. Invalid saved point falls back. Quiet Init with a
-- saved point still hides. ResetForTests must not wipe SV. Missing DB:
-- default restore; save no-ops. Nested so the main chunk stays under Lua
-- 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runPersist()
  ChurchOfBeefDB = { ui = {} }
  reset()
  local frame = Inputs:Init()
  assert_true(Runtime:StartEvent() ~= nil, "B15-A StartEvent reaches ASSEMBLY")
  assert_eq(Inputs:Show(), true, "Event Show is true before drag")
  assert_eq(frame:IsShown(), true, "Event Show paints the widget before drag")
  assert_eq(frame:GetWidth(), 360, "persist WIDTH stays 360")
  assert_eq(frame:GetHeight(), 64, "persist HEIGHT is the one-button strip")
  assert_eq(frame._movable, true, "root is SetMovable(true)")
  assert_eq(frame._clamped, true, "root stays SetClampedToScreen")
  assert_eq(frame:IsEventRegistered("DISPLAY_SIZE_CHANGED"), true,
    "inputs re-clamp when the display changes")
  assert_eq(frame:GetScript("OnDragStart"), nil, "root has no OnDragStart")
  assert_eq(frame:GetScript("OnDragStop"), nil, "drag stop is on TitleBar, not the root")
  local titleBar = rawget(frame, "TitleBar")
  assert_true(titleBar ~= nil, "TitleBar exists")
  if titleBar then
    assert_eq(titleBar:GetParent(), frame, "TitleBar is a child of the root")
    assert_eq(titleBar:GetHeight(), 22, "TitleBar height fits its functional labels")
    assert_eq(select(1, titleBar:GetPoint(1)), "TOPLEFT", "TitleBar TOPLEFT")
    assert_eq(select(2, titleBar:GetPoint(1)), frame, "TitleBar TOPLEFT relative is the root")
    assert_eq(select(1, titleBar:GetPoint(2)), "TOPRIGHT", "TitleBar TOPRIGHT")
    assert_eq(select(2, titleBar:GetPoint(2)), frame, "TitleBar TOPRIGHT relative is the root")
    assert_true(titleBar:GetScript("OnDragStart") ~= nil, "drag start is on TitleBar")
    assert_true(titleBar:GetScript("OnDragStop") ~= nil, "drag stop is on TitleBar")
    assert_eq(titleBar:GetNumRegions(), 2, "TitleBar has title and recipient labels")
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
  assert_true(persistSrc:find("CreateFontString", 1, true) ~= nil,
    "source keeps the functional labels")
  assert_eq(persistSrc:find("relativeTo", 1, true), nil, "source never stores relativeTo")
  assert_eq(persistSrc:find("UISpecialFrames", 1, true), nil, "persist source does not use UISpecialFrames")
  assert_eq(persistSrc:find("SUMMON", 1, true), nil, "persist source has no SUMMON")
  assert_eq(persistSrc:find("PlaySound", 1, true), nil, "persist source still has no PlaySound")
  assert_eq(persistSrc:find("OnUpdate", 1, true), nil, "persist source still has no OnUpdate")
  assert_eq(persistSrc:find("Media\\", 1, true), nil, "persist source still has no custom Media")
  assert_eq(persistSrc:find(".tga", 1, true), nil, "persist source still has no custom tga")
  assert_eq(persistSrc:find(".blp", 1, true), nil, "persist source still has no custom blp")
  assert_eq(persistSrc:find(".ttf", 1, true), nil, "persist source still has no custom fonts")
  assert_true(persistSrc:find("IsRegisteredPope", 1, true) ~= nil,
    "persist source still hides on IsRegisteredPope")

  if standalone then
    assert_eq(COB.Console, nil, "still no Console after persist")
    assert_eq(COB.Sender, nil, "still no Sender after persist")
    assert_eq(COB.Sound, nil, "still no Sound after persist")
    assert_eq(COB.Hud, nil, "still no Hud after persist")
    assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "persist still does not register a slash")
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
runPersist()

--------------------------------------------------------------------------------
-- B17-C / B18-A / B21-D / B23-D: Petition may name UnitName("target") when it
-- is not the bound dest and not the local player (Names.Same). Both reads are
-- pcalled; trim (^%s+ / %s+$) before Same; empty / erroring / missing reads
-- omit the opponent and still send. Nested so the main chunk stays under Lua
-- 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runOpponent()
  ChurchOfBeefDB = { ui = {} }
  reset()
  assert_true(Runtime:StartEvent() ~= nil, "opponent StartEvent reaches ASSEMBLY")
  local frame = Inputs:Init()
  assert_true(frame ~= nil, "opponent Init creates the frame")
  assert_eq(frame:IsShown(), true, "opponent Event Init shows the Inputs panel")
  assert_eq(frame:GetWidth(), 360, "opponent WIDTH stays 360")
  assert_eq(frame:GetHeight(), 64, "opponent HEIGHT is the one-button strip")
  assert_true(rawget(frame, "TitleBar") ~= nil, "opponent TitleBar stays")
  assert_eq(frame:GetScript("OnDragStart"), nil, "opponent root still has no OnDragStart")

  Inputs:SetInputTarget("Host")
  Inputs:SetLocalCharacterId(7)

  local function ask()
    rearmAsk()
    return Inputs:Petition()
  end

  local targetCalls = 0
  local savedTargetUnit = TargetUnit
  TargetUnit = function()
    targetCalls = targetCalls + 1
  end
  local savedUnitName = UnitName

  local ok, err = ask()
  assert_eq(ok, true, "unset target still sends")
  assert_eq(err, nil, "unset target has no error")
  assert_eq(#sentPetitions, 1, "unset target sends once")
  assert_eq(sentPetitions[1].target, "Host", "unset target whisper dest stays Host")
  assert_eq(sentPetitions[1].fields.characterId, 7, "unset target keeps characterId")
  assert_eq(sentPetitions[1].fields.opponent, nil, "unset stub target omits opponent")
  assert_eq(targetCalls, 0, "Petition does not TargetUnit")

  UnitName = function(unit)
    if unit == "target" then return "Chuckroast" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "named target sends")
  assert_eq(err, nil, "named target has no error")
  assert_eq(#sentPetitions, 1, "named target sends once")
  assert_eq(sentPetitions[1].target, "Host", "named target whisper dest stays Host")
  assert_eq(sentPetitions[1].fields.characterId, 7, "named target keeps characterId")
  assert_eq(sentPetitions[1].fields.opponent, "Chuckroast", "named target names Chuckroast")
  assert_eq(sentPetitions[1].fields.kind, nil, "named target does not invent a kind")
  assert_eq(targetCalls, 0, "named Petition does not TargetUnit")

  sentPetitions = {}
  rearmAsk()
  local petitionBtn = buttonFor("Ask to fight")
  assert_true(petitionBtn ~= nil, "Ask to fight button stays")
  assert_eq(stub.fire(petitionBtn, "OnClick"), true, "Ask click is wired")
  assert_eq(#sentPetitions, 1, "click sends once")
  assert_eq(sentPetitions[1].fields.opponent, "Chuckroast", "click names Chuckroast")
  assert_eq(sentPetitions[1].target, "Host", "click whisper dest stays Host")

  UnitName = function(unit)
    if unit == "target" then return "Host" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "names-same Host still sends")
  assert_eq(sentPetitions[1].fields.opponent, nil, "target names-same Host omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "names-same Host whisper dest stays")
  assert_eq(sentPetitions[1].fields.characterId, 7, "names-same Host keeps characterId")

  UnitName = function(unit)
    if unit == "target" then return "Host-Whitemane" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ask()
  assert_eq(sentPetitions[1].fields.opponent, nil, "target names-same Host realm omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "realm-fold Host whisper dest stays")

  UnitName = function(unit)
    if unit == "target" then return "Beefina" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "names-same player still sends")
  assert_eq(sentPetitions[1].fields.opponent, nil, "target names-same player omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "self-target whisper dest stays Host")
  assert_eq(sentPetitions[1].fields.characterId, 7, "self-target keeps characterId")

  UnitName = function(unit)
    if unit == "target" then return "Beefina-Whitemane" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ask()
  assert_eq(sentPetitions[1].fields.opponent, nil, "target names-same player realm omits opponent")

  UnitName = nil
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "missing UnitName still sends")
  assert_eq(err, nil, "missing UnitName has no error")
  assert_eq(sentPetitions[1].fields.opponent, nil, "missing UnitName omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "missing UnitName whisper dest stays")
  assert_eq(sentPetitions[1].fields.characterId, 7, "missing UnitName keeps characterId")

  UnitName = function()
    error("unitname failed")
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "UnitName error still sends")
  assert_eq(sentPetitions[1].fields.opponent, nil, "UnitName error omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "UnitName error whisper dest stays")

  UnitName = function(unit)
    if unit == "target" then return "" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ask()
  assert_eq(sentPetitions[1].fields.opponent, nil, "empty target name omits opponent")

  UnitName = function(unit)
    if unit == "target" then return "   " end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "whitespace-only target still sends")
  assert_eq(err, nil, "whitespace-only target has no error")
  assert_eq(sentPetitions[1].fields.opponent, nil, "whitespace-only target omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "whitespace-only whisper dest stays Host")

  UnitName = function(unit)
    if unit == "target" then return "  Chuckroast  " end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "padded Chuckroast still sends")
  assert_eq(err, nil, "padded Chuckroast has no error")
  assert_eq(sentPetitions[1].fields.opponent, "Chuckroast", "padded Chuckroast trims to Chuckroast")
  assert_eq(sentPetitions[1].target, "Host", "padded Chuckroast whisper dest stays Host")
  assert_eq(sentPetitions[1].fields.characterId, 7, "padded Chuckroast keeps characterId")

  UnitName = function(unit)
    if unit == "target" then return "  Host  " end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ask()
  assert_eq(sentPetitions[1].fields.opponent, nil, "padded Host after trim omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "padded Host whisper dest stays")

  UnitName = function(unit)
    if unit == "target" then return "  Beefina  " end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ask()
  assert_eq(sentPetitions[1].fields.opponent, nil, "padded player after trim omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "padded player whisper dest stays")

  UnitName = function(unit)
    if unit == "target" then return "Chuckroast" end
    if unit == "player" then error("unitname player failed") end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "player-throw still sends")
  assert_eq(err, nil, "player-throw has no error")
  assert_eq(sentPetitions[1].fields.opponent, nil, "player-throw omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "player-throw whisper dest stays Host")

  UnitName = function(unit)
    if unit == "target" then return "Chuckroast" end
    if unit == "player" then return nil end
    return nil
  end
  sentPetitions = {}
  ask()
  assert_eq(sentPetitions[1].fields.opponent, nil, "non-string player omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "non-string player whisper dest stays Host")

  UnitName = function(unit)
    if unit == "target" then return "Chuckroast" end
    if unit == "player" then return "" end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "empty player still sends")
  assert_eq(sentPetitions[1].fields.opponent, nil, "empty player omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "empty player whisper dest stays Host")

  UnitName = function(unit)
    if unit == "target" then return "Chuckroast" end
    if unit == "player" then return "   " end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "whitespace player still sends")
  assert_eq(sentPetitions[1].fields.opponent, nil, "whitespace player omits opponent")
  assert_eq(sentPetitions[1].target, "Host", "whitespace player whisper dest stays Host")

  -- Net-default dest: no bound target, listed Pope. The opponent check has no
  -- bound dest to compare against, so a named target still attaches.
  Inputs:SetInputTarget(nil)
  COB.Popes = { List = { "Popeonius" } }
  UnitName = function(unit)
    if unit == "target" then return "Chuckroast" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  ok, err = ask()
  assert_eq(ok, true, "Ask on the Net default still sends")
  assert_eq(err, nil, "Net-default Ask has no error")
  assert_eq(sentPetitions[1].target, "Popeonius", "Net-default Ask dest is DefaultDest")
  assert_eq(Inputs.frame.TargetText:GetText(), "To: " .. sentPetitions[1].target,
    "Net-default dest line equals send dest")
  assert_eq(sentPetitions[1].fields.opponent, "Chuckroast",
    "Net-default Ask still names the opponent")
  COB.Popes = nil
  Inputs:SetInputTarget("Host")

  UnitName = function(unit)
    if unit == "target" then return "Chuckroast" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  assert_true(Runtime:EndEvent() ~= nil, "opponent EndEvent returns QUIET")
  sentPetitions = {}
  ok = Inputs:Petition()
  assert_eq(ok, false, "Quiet Petition is false")
  assert_eq(#sentPetitions, 0, "Quiet does not send")

  assert_eq(targetCalls, 0, "the suite never TargetUnit")
  assert_eq(sounds, 0, "opponent lane plays no sound")
  assert_eq(goraCalls, 0, "opponent lane does not call Gora")

  local challengeSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
  assert_true(challengeSrcFile ~= nil, "Inputs.lua is readable after opponent pins")
  local challengeSrc = challengeSrcFile:read("*a")
  challengeSrcFile:close()
  assert_true(challengeSrc:find('pcall(UnitName, "target")', 1, true) ~= nil,
    "UnitName target read is pcalled")
  assert_true(challengeSrc:find('pcall(UnitName, "player")', 1, true) ~= nil,
    "UnitName player read is pcalled")
  assert_true(challengeSrc:find("Names.Same", 1, true) ~= nil, "source compares with Names.Same")
  assert_true(challengeSrc:find('playerName:gsub("^%s+", ""):gsub("%s+$", "")', 1, true) ~= nil,
    "player name is trimmed like the target")
  assert_true(challengeSrc:find('targetName:gsub("^%s+", ""):gsub("%s+$", "")', 1, true) ~= nil,
    "opponent target trim stays")
  assert_true(challengeSrc:find('if not pok or type(playerName) ~= "string"', 1, true) ~= nil,
    "failed player pcall or non-string playerName fail-closes")
  assert_eq(challengeSrc:find("TargetUnit", 1, true), nil, "source does not TargetUnit")
  assert_eq(challengeSrc:find("Gora:Petition", 1, true), nil, "source does not call Gora:Petition")
  assert_eq(challengeSrc:find("PlaySound", 1, true), nil, "source does not play sound")
  assert_true(challengeSrc:find("IsRegisteredPope", 1, true) ~= nil,
    "opponent source still hides on IsRegisteredPope")
  assert_eq(challengeSrc:find("UISpecialFrames", 1, true), nil, "source does not use UISpecialFrames")
  assert_eq(challengeSrc:find("SUMMON", 1, true), nil, "source has no SUMMON")
  assert_true(challengeSrc:find("TitleBar", 1, true) ~= nil, "source keeps TitleBar")
  assert_true(challengeSrc:find("db.inputs", 1, true) ~= nil, "source keeps ui.inputs persist")
  assert_true(challengeSrc:find("local WIDTH, HEIGHT = 360, 64", 1, true) ~= nil,
    "source HEIGHT is the one-button strip")

  if standalone then
    assert_eq(COB.Console, nil, "still no Console after opponent pins")
    assert_eq(COB.Sender, nil, "still no Sender after opponent pins")
    assert_eq(COB.Sound, nil, "still no Sound after opponent pins")
    assert_eq(COB.Hud, nil, "still no Hud after opponent pins")
    assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "opponent pins still do not register a slash")
  end

  UnitName = savedUnitName
  TargetUnit = savedTargetUnit
end
runOpponent()

--------------------------------------------------------------------------------
-- B33-A: SetInputTarget trims the whisper dest (Names.Trim, fallback
-- ^%s+ / %s+$). Empty after trim is no target; without a listed Pope,
-- Petition returns "no target" and does not send. Padded "  Host  " stores
-- "Host". Opponent / player trim pins stay. Isolation wrap stays.
--------------------------------------------------------------------------------
local function runDestTrim()
  ChurchOfBeefDB = { ui = {} }
  reset()
  assert_true(Runtime:StartEvent() ~= nil, "dest-trim StartEvent reaches ASSEMBLY")
  local frame = Inputs:Init()
  assert_true(frame ~= nil, "dest-trim Init creates the frame")
  assert_eq(frame:IsShown(), true, "dest-trim Event Init shows the Inputs panel")

  Inputs:SetLocalCharacterId(7)
  Inputs:SetInputTarget("  Host  ")
  assert_eq(Inputs:GetView().target, "Host", "padded Host stores Host")
  assert_eq(frame.TargetText:GetText(), "To: Host", "padded Host paints trimmed")

  local savedUnitName = UnitName
  UnitName = function(unit)
    if unit == "target" then return "Chuckroast" end
    if unit == "player" then return "Beefina" end
    return nil
  end
  sentPetitions = {}
  local ok, err = Inputs:Petition()
  assert_eq(ok, true, "padded dest still sends Petition")
  assert_eq(err, nil, "padded dest Petition has no error")
  assert_eq(#sentPetitions, 1, "padded dest sends Petition once")
  assert_eq(sentPetitions[1].target, "Host", "Petition whispers trimmed Host")
  assert_eq(sentPetitions[1].fields.characterId, 7, "padded dest keeps characterId")
  assert_eq(sentPetitions[1].fields.opponent, "Chuckroast",
    "unpadded Chuckroast still names opponent")
  assert_eq(sentPetitions[1].fields.kind, nil, "padded dest does not invent a kind")

  Inputs:SetInputTarget("   ")
  rearmAsk()
  frame = Inputs.frame
  assert_eq(Inputs:GetView().target, nil, "whitespace dest is no target")
  assert_eq(frame.TargetText:GetText(), "No recipient", "whitespace dest paints no recipient")
  sentPetitions = {}
  ok, err = Inputs:Petition()
  assert_eq(ok, false, "whitespace dest refuses Ask")
  assert_eq(err, "no target", "whitespace dest Ask is no target")
  assert_eq(#sentPetitions, 0, "whitespace dest does not send")

  Inputs:SetInputTarget(" ")
  assert_eq(Inputs:GetView().target, nil, "single-space dest is no target")
  sentPetitions = {}
  ok, err = Inputs:Petition()
  assert_eq(ok, false, "single-space dest refuses Petition")
  assert_eq(err, "no target", "single-space dest is no target")
  assert_eq(#sentPetitions, 0, "single-space dest does not send")

  Inputs:SetInputTarget("  Host  ")
  assert_eq(Inputs:GetView().target, "Host", "re-set padded Host still stores Host")

  assert_true(Runtime:EndEvent() ~= nil, "dest-trim EndEvent returns QUIET")
  sentPetitions = {}
  ok = Inputs:Petition()
  assert_eq(ok, false, "dest-trim Quiet Petition is false")
  assert_eq(#sentPetitions, 0, "dest-trim Quiet does not send")

  assert_eq(sounds, 0, "dest-trim plays no sound")
  assert_eq(goraCalls, 0, "dest-trim does not call Gora")

  local destSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
  assert_true(destSrcFile ~= nil, "Inputs.lua is readable after dest-trim pins")
  local destSrc = destSrcFile:read("*a")
  destSrcFile:close()
  local setAt = destSrc:find("function Inputs:SetInputTarget", 1, true)
  assert_true(setAt ~= nil, "SetInputTarget exists")
  local setEnd = destSrc:find("\nfunction Inputs:", setAt + 1, true)
  local setBody = destSrc:sub(setAt, setEnd or #destSrc)
  assert_true(setBody:find("Names.Trim", 1, true) ~= nil, "SetInputTarget uses Names.Trim")
  assert_true(setBody:find('gsub("^%s+", "")', 1, true) ~= nil,
    "SetInputTarget fallback trims leading whitespace")
  assert_true(setBody:find('gsub("%s+$", "")', 1, true) ~= nil,
    "SetInputTarget fallback trims trailing whitespace")
  assert_true(destSrc:find("petitionDest", 1, true) ~= nil,
    "readyToSend refuses empty dest via the shared dest helper")
  assert_true(destSrc:find('"no target"', 1, true) ~= nil,
    "empty dest without a listed Pope is still no target")
  assert_true(destSrc:find("IsRegisteredPope", 1, true) ~= nil,
    "dest-trim source still hides on IsRegisteredPope")
  assert_eq(destSrc:find("TargetUnit", 1, true), nil, "dest-trim source does not TargetUnit")
  assert_eq(destSrc:find("PlaySound", 1, true), nil, "dest-trim source does not play sound")
  assert_true(destSrc:find("TitleBar", 1, true) ~= nil, "dest-trim source keeps TitleBar")
  assert_true(destSrc:find("local WIDTH, HEIGHT = 360, 64", 1, true) ~= nil,
    "dest-trim source HEIGHT is the one-button strip")

  if standalone then
    assert_eq(COB.Console, nil, "still no Console after dest-trim")
    assert_eq(COB.Sender, nil, "still no Sender after dest-trim")
    assert_eq(COB.Sound, nil, "still no Sound after dest-trim")
    assert_eq(COB.Hud, nil, "still no Hud after dest-trim")
    assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "dest-trim still does not register a slash")
  end

  UnitName = savedUnitName
end
runDestTrim()

--------------------------------------------------------------------------------
-- U-Q: Event Inputs label scan. Stock GameFontHighlight on the verb.
-- Button Y stays 10 (B18-A). TitleBar has title and recipient labels.
-- Geometry pins, Quiet refuse, and isolation wrap stay.
--------------------------------------------------------------------------------
local function runUQ()
  ChurchOfBeefDB = { ui = {} }
  reset()
  assert_true(Runtime:StartEvent() ~= nil, "U-Q StartEvent reaches ASSEMBLY")
  local frame = Inputs:Init()
  assert_true(frame ~= nil, "U-Q Init creates the frame")
  assert_eq(frame:IsShown(), true, "U-Q Event Init shows the Inputs panel")
  assert_eq(frame:GetWidth(), 360, "U-Q WIDTH stays 360")
  assert_eq(frame:GetHeight(), 64, "U-Q HEIGHT is the one-button strip")
  assert_eq(frame._template, "BackdropTemplate", "U-Q panel uses stock tooltip backdrop support")
  assert_eq(frame._cobBackdrop, "tooltip", "U-Q panel uses the shared tooltip backdrop")

  local titleBar = rawget(frame, "TitleBar")
  assert_true(titleBar ~= nil, "U-Q TitleBar stays")
  if titleBar then
    assert_eq(titleBar:GetHeight(), 22, "U-Q TitleBar height stays 22")
    assert_eq(titleBar:GetNumRegions(), 2, "U-Q TitleBar keeps title and recipient labels")
  end

  local petitionBtn = buttonFor("Ask to fight")
  assert_true(petitionBtn ~= nil, "U-Q Petition button stays")
  assert_eq(petitionBtn._template, "UIPanelButtonTemplate", "U-Q Petition stays stock")

  local fs = petitionBtn.GetFontString and petitionBtn:GetFontString()
  assert_true(fs ~= nil, "U-Q Petition has a stock label FontString")
  if fs then
    assert_eq(fs:GetFontObject(), "GameFontHighlight",
      "U-Q Petition scans as GameFontHighlight")
  end
  assert_eq(select(1, petitionBtn:GetPoint(1)), "BOTTOMLEFT", "U-Q Petition stays BOTTOMLEFT")
  assert_eq(select(5, petitionBtn:GetPoint(1)), 10, "U-Q Petition Y stays BOTTOM + 10")

  assert_true(Runtime:EndEvent() ~= nil, "U-Q EndEvent returns QUIET")
  assert_eq(Inputs:Show(), false, "U-Q Quiet Show is false")
  assert_eq(frame:IsShown(), false, "U-Q Quiet stays hidden")
  assert_eq(Inputs:Petition(), false, "U-Q Quiet Petition is false")

  local uqSrcFile = io.open("addon/ChurchOfBeef/UI/Inputs.lua", "r")
  assert_true(uqSrcFile ~= nil, "Inputs.lua is readable after U-Q pins")
  local uqSrc = uqSrcFile:read("*a")
  uqSrcFile:close()
  assert_true(uqSrc:find("GameFontHighlight", 1, true) ~= nil, "U-Q source names GameFontHighlight")
  assert_true(uqSrc:find("local WIDTH, HEIGHT = 360, 64", 1, true) ~= nil,
    "U-Q source HEIGHT is the one-button strip")
  assert_true(uqSrc:find("SetHeight(22)", 1, true) ~= nil, "U-Q source TitleBar height 22")
  assert_eq(uqSrc:find("TitleText", 1, true), nil, "U-Q source has no TitleText")
  assert_true(uqSrc:find("CreateFontString", 1, true) ~= nil,
    "U-Q source keeps functional labels")
  assert_eq(uqSrc:find("Media\\", 1, true), nil, "U-Q source has no custom Media")
  assert_eq(uqSrc:find(".tga", 1, true), nil, "U-Q source has no custom tga")
  assert_eq(uqSrc:find(".blp", 1, true), nil, "U-Q source has no custom blp")
  assert_eq(uqSrc:find(".ttf", 1, true), nil, "U-Q source has no custom fonts")
  assert_true(uqSrc:find("IsRegisteredPope", 1, true) ~= nil,
    "U-Q source still hides on IsRegisteredPope")
  assert_eq(uqSrc:find("PlaySound", 1, true), nil, "U-Q source does not play sound")
  assert_eq(uqSrc:find("Proclaim", 1, true), nil, "U-Q source does not Proclaim")

  if standalone then
    assert_eq(COB.Console, nil, "still no Console after U-Q")
    assert_eq(COB.Sender, nil, "still no Sender after U-Q")
    assert_eq(COB.Sound, nil, "still no Sound after U-Q")
    assert_eq(COB.Hud, nil, "still no Hud after U-Q")
    assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "U-Q still does not register a slash")
  end
end
runUQ()

--------------------------------------------------------------------------------
-- Wave 2 Task 12: hide on listed Pope; dest line == send dest (last STATE
-- sender beats List[1]); fireable reasons; asked / waiting; empty store
-- does not Ensure. Nested for the 5.1 local cap.
--------------------------------------------------------------------------------
local function runTask12()
  ChurchOfBeefDB = { ui = {} }
  reset()
  assert_true(Runtime:StartEvent() ~= nil, "Task 12 StartEvent reaches ASSEMBLY")
  local frame = Inputs:Init()
  Inputs:SetInputTarget("Host")
  assert_eq(Inputs:Show(), true, "congregation Show is true before Pope hide")
  assert_eq(frame:IsShown(), true, "congregation strip is shown")

  COB.Sender = {
    IsRegisteredPope = function()
      return true
    end,
  }
  assert_eq(Inputs:Show(), false, "listed Pope Show is false")
  assert_eq(frame:IsShown(), false, "listed Pope hides the strip")
  assert_eq(Inputs:GetView().shown, false, "listed Pope view is hidden")
  sentPetitions = {}
  local ok, err = Inputs:Petition()
  assert_eq(ok, false, "listed Pope does not ask")
  assert_eq(#sentPetitions, 0, "listed Pope does not send")
  COB.Sender = nil
  assert_eq(Inputs:Show(), true, "clearing the Pope stub shows the strip again")

  reset()
  Runtime:StartEvent()
  frame = Inputs:Init()
  COB.Popes = { List = { "Popeonius" } }
  COB.Net._lastStateSender = "Steakina"
  Inputs:Refresh()
  assert_eq(frame.TargetText:GetText(), "To: Steakina",
    "dest line prefers the last STATE sender over List[1]")
  assert_eq(COB.Net:DefaultDest(), "Steakina", "DefaultDest is the last STATE sender")
  ok, err = Inputs:Petition()
  assert_eq(ok, true, "Ask sends to the last STATE sender")
  assert_eq(sentPetitions[1].target, "Steakina", "send dest is the last STATE sender")
  assert_eq(frame.TargetText:GetText(), "To: " .. sentPetitions[1].target,
    "dest line equals send dest when last STATE sender wins")
  assert_eq(sentPetitions[1].fields.characterId, 1,
    "no bound id still sends a placeholder")

  reset()
  Runtime:StartEvent()
  frame = Inputs:Init()
  Inputs:SetInputTarget("Host")
  local savedIsInGuild = IsInGuild
  IsInGuild = function()
    return false
  end
  Inputs:Refresh()
  assert_eq(frame.ReasonText:GetText(), "Not in a guild.", "face paints not in a guild")
  assert_eq(buttonFor("Ask to fight"):IsEnabled(), false, "not in a guild disables Ask")
  sentPetitions = {}
  ok, err = Inputs:Petition()
  assert_eq(ok, false, "not in a guild refuses Ask")
  assert_eq(err, "not in a guild", "not in a guild names the error")
  assert_eq(#sentPetitions, 0, "not in a guild does not send")
  IsInGuild = savedIsInGuild

  reset()
  Runtime:StartEvent()
  frame = Inputs:Init()
  Inputs:SetInputTarget("Host")
  COB.Net.SendPetition = function()
    return false, "boom"
  end
  ok, err = Inputs:Petition()
  assert_eq(ok, false, "send failed refuses Ask")
  assert_eq(err, "send failed", "send failed names the error")
  assert_eq(frame.ReasonText:GetText(), "Send failed.", "face paints send failed")
  stubNet()

  reset()
  Runtime:StartEvent()
  frame = Inputs:Init()
  Inputs:SetInputTarget("Host")
  ok, err = Inputs:Petition()
  assert_eq(ok, true, "first Ask sends")
  assert_eq(frame.ReasonText:GetText(), "Asked. Waiting.", "face paints asked / waiting")
  assert_eq(buttonFor("Ask to fight"):IsEnabled(), false, "asked / waiting disables Ask")
  sentPetitions = {}
  ok, err = Inputs:Petition()
  assert_eq(ok, false, "second Ask is already asked")
  assert_eq(err, "you already asked", "already asked names the error")
  assert_eq(frame.ReasonText:GetText(), "You already asked.", "face paints you already asked")
  assert_eq(#sentPetitions, 0, "already asked does not send again")

  reset()
  Runtime:StartEvent()
  assert_true(Runtime:OpenRite("Knighting") ~= nil, "Task 12 opens a Knighting")
  frame = Inputs:Init()
  Inputs:SetInputTarget("Host")
  assert_eq(Inputs:Show(), true, "Knighting still shows the strip so the reason can fire")
  assert_eq(frame.ReasonText:GetText(), "This is a Knighting, not a fight.",
    "face paints the Knighting reason")
  assert_eq(buttonFor("Ask to fight"):IsEnabled(), false, "Knighting disables Ask")
  sentPetitions = {}
  ok, err = Inputs:Petition()
  assert_eq(ok, false, "Knighting refuses Ask")
  assert_eq(err, "this is a Knighting, not a fight", "Knighting names the error")
  assert_eq(#sentPetitions, 0, "Knighting does not send")

  reset()
  Runtime:StartEvent()
  frame = Inputs:Init()
  Inputs:SetInputTarget("Host")
  local ensureCalls = 0
  COB.Store = {
    EnsureCharacterByName = function()
      ensureCalls = ensureCalls + 1
    end,
    CreateHuman = function()
      ensureCalls = ensureCalls + 1
    end,
    CreateCharacter = function()
      ensureCalls = ensureCalls + 1
    end,
    Snapshot = function()
      return { humans = {}, characters = {} }
    end,
  }
  assert_eq(Inputs:GetView().characterId, nil, "zip-fresh store has no localCharacterId")
  ok, err = Inputs:Petition()
  assert_eq(ok, true, "zip-fresh empty store still asks")
  assert_eq(ensureCalls, 0, "empty store does not Ensure / CreateHuman")
  assert_eq(sentPetitions[1].fields.characterId, 1, "empty store sends a placeholder id")
  assert_eq(Inputs:GetView().characterId, nil, "empty store does not invent an id")
  COB.Store = nil

  if standalone then
    assert_eq(COB.Sender, nil, "Task 12 restores Sender isolation")
    assert_eq(COB.Console, nil, "Task 12 does not load Console")
    assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "Task 12 does not register a slash")
  end
end
runTask12()

assert_eq(sounds, 0, "the suite played no sound")
assert_eq(#stub.chat, 0, "the suite never SendChatMessage")
assert_eq(#stub.addonMessages, 0, "the suite never SendAddonMessage")

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
