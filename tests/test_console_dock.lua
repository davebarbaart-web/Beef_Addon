-- Event-only Director Console dock (Bible §18.1, §19.1). Isolated:
-- wow_ui_stub + Common + Runtime + Theme + ConsoleDock. Stub Sender.IsRegisteredPope
-- and Console.Sanction / Show. Quiet hides. StartEvent + Pope shows, title pin.
-- B22-D: ChurchOfBeefConsoleDock on UISpecialFrames (rememberSpecial).
-- B23-B: widget Hide / ESC stays dismissed until Show or QUIET.
-- B24-B: dismiss is keyed to Runtime eventId. EndEvent without Refresh
-- then StartEvent + Refresh shows (new eventId). Same-event Hide + Refresh
-- still hidden. B26-D: Init remounts rememberSpecial when the frame
-- already exists (wipe UISpecialFrames then second Init lists the name
-- once). B27-D: Refresh / Show remount rememberSpecial when the frame
-- already exists (wipe then Refresh-only or Show-only lists the name
-- once). B30-D: Hide remounts rememberSpecial when the frame
-- already exists (wipe then Hide lists the name once). B36-C:
-- Hide remounts a missing OnHide before rememberSpecial then
-- paint(false). Nested after runB30D() inside runB27D(); no new
-- main-chunk locals. B39-D: existing-frame Show remounts a missing
-- OnHide via wireDockOnHide then rememberSpecial. Nested after
-- runB36C() inside runB27D(); no new main-chunk locals. B40-C:
-- existing-frame Refresh remounts a missing OnHide via
-- wireDockOnHide then rememberSpecial. Nested after runB39D()
-- inside runB27D(); no new main-chunk locals. B41-C:
-- existing-frame Init remounts a missing OnHide via
-- wireDockOnHide then rememberSpecial then Refresh. Nested
-- after runB40C() inside runB27D(); no new main-chunk locals.
-- No TOC / bootstrap / run.lua / Console.lua / Hud / Toasts.
-- Isolation wrap.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed = 0
local failed = 0

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
  function assert_true(v, msg)
    assert_eq(not not v, true, msg)
  end
end

local stub = require("wow_ui_stub")
local restore = stub.install()

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/UI/ConsoleDock.lua")

local COB = ChurchOfBeef
local ConsoleDock = COB.ConsoleDock
local Runtime = COB.Runtime
local TITLE = "DIRECTOR CONSOLE"

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

local savedConsole = COB.Console
local savedSender = COB.Sender

local popeFlag = false
local popeNames = {}
local sanctionCalls = 0
local showCalls = 0
local toastCalls = 0

local function stubConsole()
  sanctionCalls = 0
  showCalls = 0
  COB.Console = {
    Sanction = function()
      sanctionCalls = sanctionCalls + 1
    end,
    Show = function()
      showCalls = showCalls + 1
    end,
  }
end

local function stubSender()
  popeNames = {}
  COB.Sender = {
    IsRegisteredPope = function(_, name)
      popeNames[#popeNames + 1] = name
      return popeFlag == true
    end,
  }
end

local function reset()
  popeFlag = false
  stubSender()
  stubConsole()
  sounds = 0
  toastCalls = 0
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(ConsoleDock:ResetForTests(), true, "ConsoleDock ResetForTests runs under _IN_TEST")
end

local function walk(widget, visit)
  visit(widget)
  for i = 1, #(widget._children or {}) do
    walk(widget._children[i], visit)
  end
  for i = 1, #(widget._regions or {}) do
    visit(widget._regions[i])
  end
end

local function findButton(root, label)
  local hit
  walk(root, function(child)
    if not hit and child._type == "Button" and child.GetText and child:GetText() == label then
      hit = child
    end
  end)
  return hit
end

local function findFont(root, text)
  local hit
  walk(root, function(child)
    if not hit and child._type == "FontString" and child.GetText and child:GetText() == text then
      hit = child
    end
  end)
  return hit
end

local function countType(root, frameType)
  local n = 0
  walk(root, function(child)
    if child._type == frameType then n = n + 1 end
  end)
  return n
end

local function labeledButtons(root)
  local labels = {}
  walk(root, function(child)
    if child._type == "Button" and child.GetText then
      local text = child:GetText()
      if type(text) == "string" and text ~= "" then
        labels[#labels + 1] = text
      end
    end
  end)
  return labels
end

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(ConsoleDock ~= nil, "COB.ConsoleDock exists")
assert_true(Runtime ~= nil, "isolated suite loads Runtime")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_eq(ConsoleDock.MODE, "Event", "dock declares Event Mode")
assert_eq(type(ConsoleDock.Init), "function", "Init builds the surface")
assert_eq(type(ConsoleDock.Refresh), "function", "Refresh applies the gate")
assert_eq(type(ConsoleDock.Show), "function", "Show is gated")
assert_eq(type(ConsoleDock.Hide), "function", "Hide dismisses the dock")
assert_eq(type(ConsoleDock.GetView), "function", "GetView returns a copy")
assert_eq(type(ConsoleDock.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(ConsoleDock.WhisperAll, nil, "no WHISPER ALL")
assert_eq(ConsoleDock.Sanction, nil, "dock does not reimplement Gora")
assert_eq(ConsoleDock.StartEvent, nil, "Runtime verbs are not this lane")
assert_eq(ConsoleDock.PlayCue, nil, "no sound this lane")
assert_eq(ConsoleDock.Toast, nil, "dock is not a toast")
assert_eq(ConsoleDock.Narrate, nil, "software does not narrate")
assert_eq(ConsoleDock.Announce, nil, "software does not announce")
assert_eq(ConsoleDock.Favor, nil, "no favor bar on the dock")
assert_eq(ConsoleDock.Grant, nil, "no Grant")
assert_eq(ConsoleDock.Standing, nil, "no Standing")
assert_eq(ConsoleDock.INPUT, nil, "no invented INPUT channel")
assert_eq(ConsoleDock.Toggle, nil, "dock is show/hide, not a /beef toggle")

if standalone then
  assert_eq(COB.UI, nil, "isolated suite does not load the Quiet shell")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Roster, nil, "isolated suite does not load Roster")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
  assert_eq(COB.Sound, nil, "isolated suite does not load Sound")
  assert_eq(COB.DecreeBanner, nil, "isolated suite does not load Decree")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load Records Book")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Snapshot, nil, "isolated suite does not load Snapshot")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.FighterCard, nil, "isolated suite does not load FighterCard")
  assert_eq(COB.Decree, nil, "isolated suite does not load Core Decree")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "this file does not register a slash")
end

--------------------------------------------------------------------------------
-- Source contract: stock dock. No whisper, sound, toast, favor, custom media.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/ConsoleDock.lua", "r")
assert_true(srcFile ~= nil, "ConsoleDock.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("WHISPER ALL", 1, true), nil, "source has no WHISPER ALL")
assert_eq(src:find("WhisperAll", 1, true), nil, "source has no WhisperAll")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
  "source has rememberSpecial")
assert_true(src:find("UISpecialFrames[i] == name", 1, true) ~= nil,
  "rememberSpecial scans UISpecialFrames")
assert_true(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "build remembers FRAME_NAME")
assert_eq(src:find("table.insert(UISpecialFrames", 1, true), nil,
  "source does not bare-insert UISpecialFrames")
assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
  "source does not play IG_CHARACTER_INFO on hide")
local hideAt = src:find("widget:Hide()", 1, true)
local onHideAt = src:find('SetScript("OnHide"', 1, true)
assert_true(hideAt ~= nil, "source has create-time Hide")
assert_true(onHideAt ~= nil, "source hooks OnHide")
hideAt = src:match("local function build%(%)(.-)\nfunction ConsoleDock:Init")
assert_true(type(hideAt) == "string" and hideAt ~= "",
  "build body is readable for OnHide order")
onHideAt = hideAt:find("wireDockOnHide", 1, true)
hideAt = hideAt:find("widget:Hide()", 1, true)
assert_true(type(hideAt) == "number" and type(onHideAt) == "number" and hideAt < onHideAt,
  "OnHide is after create-time Hide")
assert_true(src:find("dismissed", 1, true) ~= nil, "source remembers dismiss")
assert_true(src:find("eventId", 1, true) ~= nil, "source keys dismiss to eventId")
assert_eq(src:find("cooldown", 1, true), nil, "no dismiss-cooldown number")
assert_eq(src:find("Toasts", 1, true), nil, "source does not drive Toasts")
assert_eq(src:find("StatusBar", 1, true), nil, "source does not mint a StatusBar")
assert_eq(src:find("FAVOR", 1, true), nil, "source has no favor chrome")
assert_eq(src:find("Media\\", 1, true), nil, "source does not require custom Media")
assert_eq(src:find(".tga", 1, true), nil, "source does not load custom tga")
assert_eq(src:find(".blp", 1, true), nil, "source does not load custom blp")
assert_eq(src:find(".ttf", 1, true), nil, "source does not load custom fonts")
assert_eq(src:find("ShowUIPanel", 1, true), nil, "insecure Show/Hide only")
assert_eq(src:find("OnUpdate", 1, true), nil, "no permanent OnUpdate")
assert_eq(src:find("Gora:Sanction", 1, true), nil, "dock does not call Gora")
assert_eq(src:find("CreateFrame", 1, true) ~= nil, true, "dock builds a frame")

stubSender()
stubConsole()

--------------------------------------------------------------------------------
-- Quiet → hidden. Init is stock, titled DIRECTOR CONSOLE, SANCTION + Expand.
--------------------------------------------------------------------------------
reset()
local frame = ConsoleDock:Init()
assert_true(frame ~= nil, "Init creates the dock frame")
assert_eq(frame:GetName(), "ChurchOfBeefConsoleDock", "dock has its own global name")
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1, "Init registers the dock once")
assert_eq(frame._template, "BasicFrameTemplate", "stock BasicFrameTemplate")
assert_true(frame.TitleText ~= nil, "BasicFrame TitleText present")
assert_eq(frame.TitleText:GetText(), TITLE, "title is exactly DIRECTOR CONSOLE")
assert_eq(ConsoleDock:Init(), frame, "Init is idempotent")
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1, "second Init does not duplicate")
local savedSpecial = UISpecialFrames
UISpecialFrames = nil
assert_eq(ConsoleDock:Init(), frame, "Init survives a missing UISpecialFrames table")
UISpecialFrames = savedSpecial
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1, "restored table still has one entry")
assert_eq(frame._movable, true, "frame is movable")
assert_eq(frame._clamped, true, "frame is clamped to screen")
assert_eq(frame:GetParent(), UIParent, "insecure frame under UIParent")
local point, relativeTo = frame:GetPoint(1)
assert_eq(point, "BOTTOMLEFT", "dock sits BOTTOMLEFT so the ring stays visible")
assert_eq(relativeTo, UIParent, "dock anchors to UIParent")
assert_eq(frame:IsShown(), false, "Quiet Init stays hidden")
assert_eq(ConsoleDock:Show(), false, "Quiet Show is false")
assert_eq(frame:IsShown(), false, "Quiet Show does not paint")
local view = ConsoleDock:GetView()
assert_eq(view.shown, false, "Quiet GetView.shown is false")
assert_eq(view.title, TITLE, "Quiet view still names the dock")
assert_eq(view.mode, "Event", "view declares Event Mode")
assert_eq(view.state, "QUIET", "Quiet view reports QUIET")
assert_eq(view.pope, false, "Quiet view is not Pope-shown")
assert_eq(countType(frame, "StatusBar"), 0, "no favor bar on the dock")
assert_eq(countType(frame, "EditBox"), 0, "dock has no EditBox")

local labels = labeledButtons(frame)
assert_eq(#labels, 2, "exactly two labeled buttons")
assert_true(findButton(frame, "SANCTION") ~= nil, "SANCTION button exists")
assert_true(findButton(frame, "Expand") ~= nil, "Expand button exists")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL button")
assert_eq(findButton(frame, "SANCTION BEEF GORA"), nil, "dock label is SANCTION")
assert_eq(findFont(frame, "FAVOR"), nil, "no FAVOR label")
assert_eq(findButton(frame, "SANCTION")._template, "UIPanelButtonTemplate", "SANCTION is stock")
assert_eq(findButton(frame, "Expand")._template, "UIPanelButtonTemplate", "Expand is stock")
if frame.CloseButton then
  assert_eq(frame.CloseButton:IsShown(), false, "CloseButton is hidden — SANCTION + Expand only")
end
assert_eq(sounds, 0, "Quiet Init plays no sound")

--------------------------------------------------------------------------------
-- StartEvent + Pope true → shown, title pin. Pope false → hidden.
--------------------------------------------------------------------------------
reset()
frame = ConsoleDock:Init()
Runtime:StartEvent()
popeFlag = true
assert_eq(ConsoleDock:Show(), true, "StartEvent + Pope Show is true")
assert_eq(frame:IsShown(), true, "StartEvent + Pope shows the widget")
assert_eq(frame:GetName(), "ChurchOfBeefConsoleDock", "shown dock name stays ChurchOfBeefConsoleDock")
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
  "StartEvent + Pope lists ChurchOfBeefConsoleDock once")
assert_eq(ConsoleDock:Init(), frame, "second Init while shown returns the same widget")
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
  "second Init while shown does not duplicate")
view = ConsoleDock:GetView()
assert_eq(view.shown, true, "StartEvent + Pope GetView.shown is true")
assert_eq(view.title, TITLE, "shown title stays DIRECTOR CONSOLE")
assert_eq(view.state, "ASSEMBLY", "StartEvent view reports ASSEMBLY")
assert_eq(view.pope, true, "shown view records Pope")
assert_eq(frame.TitleText:GetText(), TITLE, "painted title is DIRECTOR CONSOLE")
assert_true(findButton(frame, "SANCTION") ~= nil, "shown SANCTION stays")
assert_true(findButton(frame, "Expand") ~= nil, "shown Expand stays")
if frame.CloseButton then
  assert_eq(frame.CloseButton:IsShown(), false, "shown CloseButton stays hidden")
end
assert_eq(popeNames[1], "Beefina", "Pope check uses UnitName player")
assert_eq(sounds, 0, "showing plays no sound")

ConsoleDock:Hide()
assert_eq(frame:IsShown(), false, "Hide still hides the widget")
assert_eq(ConsoleDock:GetView().shown, false, "Hide paints shown false")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Hide is not EndEvent")
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1, "Hide does not drop UISpecialFrames")
assert_eq(sounds, 0, "Hide plays no sound")
assert_eq(ConsoleDock:Show(), true, "Show after Hide still works while live")
assert_eq(frame:IsShown(), true, "Show after Hide paints again")

popeFlag = false
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "Pope false Refresh hides")
assert_eq(frame:IsShown(), false, "Pope false hides the widget")
assert_eq(ConsoleDock:Show(), false, "Pope false Show is false")

popeFlag = true
Runtime:ResetForTests()
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "Quiet Runtime hides even when Pope")
assert_eq(view.state, "QUIET", "Pope + Quiet is still QUIET")

--------------------------------------------------------------------------------
-- Live event states stay shown. EndEvent hides.
--------------------------------------------------------------------------------
reset()
frame = ConsoleDock:Init()
popeFlag = true
Runtime:StartEvent()
ConsoleDock:Refresh()
assert_eq(frame:IsShown(), true, "ASSEMBLY shows")
Runtime:OpenRite("Gora")
view = ConsoleDock:Refresh()
assert_eq(view.shown, true, "RITE still shows")
assert_eq(view.state, "RITE", "RITE view reports RITE")
Runtime:CloseRite()
view = ConsoleDock:Refresh()
assert_eq(view.shown, true, "CONSEQUENCE still shows")
assert_eq(view.state, "CONSEQUENCE", "CONSEQUENCE view reports CONSEQUENCE")
Runtime:EndEvent()
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "EndEvent hides the dock")
assert_eq(frame:IsShown(), false, "EndEvent hides the widget")
assert_eq(view.state, "QUIET", "ended view reports QUIET")

--------------------------------------------------------------------------------
-- B23-B: widget Hide (ESC) syncs lastView and stays hidden until Show or QUIET.
--------------------------------------------------------------------------------
reset()
frame = ConsoleDock:Init()
popeFlag = true
Runtime:StartEvent()
assert_eq(ConsoleDock:Show(), true, "StartEvent + Pope Show is true before widget Hide")
assert_eq(frame:IsShown(), true, "StartEvent + Pope shows before widget Hide")
assert_eq(ConsoleDock:GetView().shown, true, "StartEvent + Pope view is shown")
assert_eq(frame:GetScript("OnHide") ~= nil, true, "shown dock has OnHide")

frame:Hide()
assert_eq(frame:IsShown(), false, "widget Hide hides the dock")
assert_eq(ConsoleDock:GetView().shown, false, "widget Hide sets GetView().shown false")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "widget Hide is not EndEvent")
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1, "widget Hide keeps UISpecialFrames")
assert_eq(sounds, 0, "widget Hide plays no sound")

view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "Refresh after widget Hide stays hidden")
assert_eq(frame:IsShown(), false, "Refresh after widget Hide does not re-show")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Refresh after widget Hide is not EndEvent")
assert_eq(view.state, "ASSEMBLY", "dismissed Refresh still reports ASSEMBLY")

assert_eq(ConsoleDock:Show(), true, "Show after dismiss paints again")
assert_eq(frame:IsShown(), true, "Show after dismiss shows the widget")
assert_eq(ConsoleDock:GetView().shown, true, "Show after dismiss sets shown true")
assert_eq(sounds, 0, "Show after dismiss plays no sound")

frame:Hide()
assert_eq(ConsoleDock:GetView().shown, false, "second widget Hide sets shown false")
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "Refresh after second dismiss stays hidden")
assert_eq(frame:IsShown(), false, "Refresh after second dismiss does not re-show")

Runtime:EndEvent()
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "EndEvent Refresh hides")
assert_eq(frame:IsShown(), false, "EndEvent hides the widget")
assert_eq(view.state, "QUIET", "EndEvent view reports QUIET")

Runtime:StartEvent()
view = ConsoleDock:Refresh()
assert_eq(view.shown, true, "StartEvent + Refresh after EndEvent shows")
assert_eq(frame:IsShown(), true, "StartEvent + Refresh after EndEvent shows the widget")
assert_eq(view.state, "ASSEMBLY", "new event after EndEvent reports ASSEMBLY")
assert_eq(frame.TitleText:GetText(), TITLE, "re-shown title stays DIRECTOR CONSOLE")
if frame.CloseButton then
  assert_eq(frame.CloseButton:IsShown(), false, "re-shown CloseButton stays hidden")
end

frame:Hide()
assert_eq(ConsoleDock:GetView().shown, false, "widget Hide before Quiet Refresh sets shown false")
Runtime:ResetForTests()
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "Quiet Refresh hides")
assert_eq(frame:IsShown(), false, "Quiet Refresh hides the widget")
assert_eq(view.state, "QUIET", "Quiet Refresh reports QUIET")
assert_eq(Runtime:Snapshot().state, "QUIET", "Quiet Refresh is not a live event")

Runtime:StartEvent()
popeFlag = true
view = ConsoleDock:Refresh()
assert_eq(view.shown, true, "StartEvent + Refresh after Quiet Refresh shows")
assert_eq(frame:IsShown(), true, "StartEvent + Refresh after Quiet Refresh shows the widget")
assert_eq(view.state, "ASSEMBLY", "new event after Quiet Refresh reports ASSEMBLY")
assert_eq(sounds, 0, "dismiss path plays no sound")

--------------------------------------------------------------------------------
-- B24-B: dismiss is keyed to Runtime eventId. Hide then EndEvent
-- without Refresh; next StartEvent + Refresh shows (new eventId).
-- Same-event Hide + Refresh still hidden.
--------------------------------------------------------------------------------
reset()
frame = ConsoleDock:Init()
popeFlag = true
Runtime:StartEvent()
assert_eq(ConsoleDock:Show(), true, "B24-B StartEvent + Pope Show is true")
assert_eq(frame:IsShown(), true, "B24-B StartEvent + Pope shows the widget")
assert_eq(ConsoleDock:GetView().shown, true, "B24-B StartEvent + Pope view is shown")
local firstEventId = Runtime:Snapshot().eventId
assert_eq(type(firstEventId), "number", "B24-B StartEvent assigns a number eventId")

frame:Hide()
assert_eq(frame:IsShown(), false, "B24-B widget Hide hides the dock")
assert_eq(ConsoleDock:GetView().shown, false, "B24-B widget Hide sets shown false")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "B24-B widget Hide is not EndEvent")
assert_eq(Runtime:Snapshot().eventId, firstEventId, "B24-B widget Hide keeps eventId")
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1, "B24-B widget Hide keeps UISpecialFrames")
assert_eq(sounds, 0, "B24-B widget Hide plays no sound")

Runtime:EndEvent()
assert_eq(Runtime:Snapshot().state, "QUIET", "B24-B EndEvent without Refresh is QUIET")
assert_eq(ConsoleDock:GetView().shown, false, "B24-B EndEvent without Refresh leaves view hidden")
assert_eq(frame:IsShown(), false, "B24-B EndEvent without Refresh leaves widget hidden")

Runtime:StartEvent()
local secondEventId = Runtime:Snapshot().eventId
assert_eq(type(secondEventId), "number", "B24-B next StartEvent assigns a number eventId")
assert_true(secondEventId ~= firstEventId, "B24-B next StartEvent is a new eventId")
view = ConsoleDock:Refresh()
assert_eq(view.shown, true, "B24-B StartEvent + Refresh after EndEvent without Refresh shows")
assert_eq(frame:IsShown(), true, "B24-B new eventId shows the widget")
assert_eq(view.state, "ASSEMBLY", "B24-B new event reports ASSEMBLY")
assert_eq(view.title, TITLE, "B24-B new event title stays DIRECTOR CONSOLE")
assert_eq(frame.TitleText:GetText(), TITLE, "B24-B painted title stays DIRECTOR CONSOLE")
if frame.CloseButton then
  assert_eq(frame.CloseButton:IsShown(), false, "B24-B re-shown CloseButton stays hidden")
end
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1, "B24-B new event keeps UISpecialFrames")
assert_eq(sounds, 0, "B24-B new event Refresh plays no sound")

frame:Hide()
assert_eq(frame:IsShown(), false, "B24-B same-event Hide hides")
assert_eq(ConsoleDock:GetView().shown, false, "B24-B same-event Hide sets shown false")
assert_eq(Runtime:Snapshot().eventId, secondEventId, "B24-B same-event Hide keeps eventId")
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "B24-B same-event Hide + Refresh stays hidden")
assert_eq(frame:IsShown(), false, "B24-B same-event Hide + Refresh does not re-show")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "B24-B same-event Refresh is not EndEvent")
assert_eq(sounds, 0, "B24-B same-event Refresh plays no sound")

--------------------------------------------------------------------------------
-- B26-D: Init remounts rememberSpecial when the frame already exists.
-- Wipe UISpecialFrames to {}; second Init lists ChurchOfBeefConsoleDock
-- once. Same frame pointer. Do not rebuild. Per-event dismiss stays.
--------------------------------------------------------------------------------
local function runB26D()
  local remount = src:match("if not frame then return nil end(.-)return frame")
  assert_true(type(remount) == "string" and remount ~= "",
    "Init existing-frame remount body is readable")
  assert_true(remount:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "Init remount rememberSpecial FRAME_NAME")
  assert_true(remount:find("self:Refresh()", 1, true) ~= nil,
    "Init remount still Refresh")
  assert_eq(remount:find("build()", 1, true), nil,
    "Init remount does not rebuild")
  assert_eq(remount:find("CreateFrame", 1, true), nil,
    "Init remount does not CreateFrame")
  assert_eq(remount:find("PlaySound", 1, true), nil,
    "Init remount does not PlaySound")
  assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
    "rememberSpecial helper stays")
  assert_true(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "build still rememberSpecial FRAME_NAME")
  assert_true(src:find("eventId", 1, true) ~= nil,
    "per-event dismiss still keys eventId")
  assert_true(src:find("dismissed", 1, true) ~= nil,
    "per-event dismiss stays")
  assert_eq(src:find("PlaySound", 1, true), nil,
    "source still does not play sound")
  assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
    "source still has no IG_CHARACTER_INFO")
  assert_eq(src:find("cooldown", 1, true), nil,
    "source still has no dismiss-cooldown")
  assert_eq(src:find("parchment", 1, true), nil,
    "dock still has no parchment")

  reset()
  local existing = ConsoleDock:Init()
  assert_true(existing ~= nil, "B26-D Init creates the dock")
  assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
    "B26-D dock name stays ChurchOfBeefConsoleDock")
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "B26-D first Init lists ChurchOfBeefConsoleDock once")
  local savedList = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 0,
    "B26-D wipe clears ChurchOfBeefConsoleDock")
  local cuesWipe = sounds
  local createCalls = 0
  local savedCreateFrame = CreateFrame
  CreateFrame = function(...)
    createCalls = createCalls + 1
    return savedCreateFrame(...)
  end
  local same = ConsoleDock:Init()
  CreateFrame = savedCreateFrame
  assert_eq(same, existing, "B26-D second Init returns the same frame")
  assert_eq(same:GetName(), "ChurchOfBeefConsoleDock",
    "B26-D second Init keeps the named frame")
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "wiped UISpecialFrames + second Init lists ChurchOfBeefConsoleDock once")
  assert_eq(createCalls, 0, "B26-D second Init does not rebuild")
  assert_eq(sounds, cuesWipe, "B26-D second Init plays no sound")
  assert_eq(same:IsShown(), false, "B26-D remount Quiet Init stays hidden")
  ConsoleDock:Init()
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "B26-D third Init after wipe does not duplicate")
  assert_eq(ConsoleDock:Init(), existing, "B26-D third Init still same frame")

  popeFlag = true
  Runtime:StartEvent()
  assert_eq(ConsoleDock:Show(), true, "B26-D StartEvent + Pope Show is true")
  assert_eq(existing:IsShown(), true, "B26-D StartEvent + Pope shows")
  existing:Hide()
  local stay = ConsoleDock:Refresh()
  assert_eq(stay.shown, false, "B26-D same-event Hide + Refresh stays hidden")
  assert_eq(existing:IsShown(), false, "B26-D same-event Refresh does not re-show")
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "B26-D dismiss keeps UISpecialFrames")
  assert_eq(sounds, cuesWipe, "B26-D dismiss path plays no sound")

  UISpecialFrames = savedList

  if standalone then
    assert_eq(COB.Hud, nil, "isolation still does not load Hud")
    assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
    assert_eq(COB.DecreeBanner, nil, "isolation still does not load Decree")
    assert_eq(COB.RecordsBook, nil, "isolation still does not load Records Book")
    assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "isolation still does not register a slash")
  end
end
runB26D()

--------------------------------------------------------------------------------
-- B27-D: Refresh / Show remount rememberSpecial when the frame already
-- exists. Init, wipe UISpecialFrames to {}, Refresh-only: dock name
-- listed exactly once. Wipe again, Show-only: listed once. Same frame
-- pointer. Do not rebuild. B24-B same-event Hide+Refresh stays hidden.
-- B26-D Init remount pins stay.
--------------------------------------------------------------------------------
local function runB27D()
  local refreshBody = src:match("function ConsoleDock:Refresh%(%)(.-)\nfunction ConsoleDock:Show")
  assert_true(type(refreshBody) == "string" and refreshBody ~= "",
    "Refresh body is readable")
  local remountRefresh = refreshBody:match("return self:GetView%(%)%s+end%s+(.-)if not mayShow")
  assert_true(type(remountRefresh) == "string" and remountRefresh ~= "",
    "Refresh existing-frame remount body is readable")
  assert_true(remountRefresh:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "Refresh remount rememberSpecial FRAME_NAME")
  assert_eq(remountRefresh:find("build()", 1, true), nil,
    "Refresh remount does not rebuild")
  assert_eq(remountRefresh:find("CreateFrame", 1, true), nil,
    "Refresh remount does not CreateFrame")
  assert_eq(remountRefresh:find("PlaySound", 1, true), nil,
    "Refresh remount does not PlaySound")

  local showBody = src:match("function ConsoleDock:Show%(%)(.-)\nfunction ConsoleDock:Hide")
  assert_true(type(showBody) == "string" and showBody ~= "",
    "Show body is readable")
  local remountShow = showBody:match("return false%s+end%s+(.-)if not mayShow")
  assert_true(type(remountShow) == "string" and remountShow ~= "",
    "Show existing-frame remount body is readable")
  assert_true(remountShow:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "Show remount rememberSpecial FRAME_NAME")
  assert_eq(remountShow:find("build()", 1, true), nil,
    "Show remount does not rebuild")
  assert_eq(remountShow:find("CreateFrame", 1, true), nil,
    "Show remount does not CreateFrame")
  assert_eq(remountShow:find("Init()", 1, true), nil,
    "Show remount does not Init")
  assert_eq(remountShow:find("PlaySound", 1, true), nil,
    "Show remount does not PlaySound")

  local remountInit = src:match("if not frame then return nil end(.-)return frame")
  assert_true(type(remountInit) == "string" and remountInit ~= "",
    "B26-D Init remount body stays readable")
  assert_true(remountInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "B26-D Init remount rememberSpecial FRAME_NAME stays")
  assert_true(remountInit:find("self:Refresh()", 1, true) ~= nil,
    "B26-D Init remount still Refresh")
  assert_eq(remountInit:find("build()", 1, true), nil,
    "B26-D Init remount still does not rebuild")
  assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
    "rememberSpecial helper stays")
  assert_true(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "build still rememberSpecial FRAME_NAME")
  assert_true(src:find("eventId", 1, true) ~= nil,
    "per-event dismiss still keys eventId")
  assert_true(src:find("dismissed", 1, true) ~= nil,
    "per-event dismiss stays")
  assert_eq(src:find("PlaySound", 1, true), nil,
    "source still does not play sound")
  assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
    "source still has no IG_CHARACTER_INFO")
  assert_eq(src:find("cooldown", 1, true), nil,
    "source still has no dismiss-cooldown")
  assert_eq(src:find("parchment", 1, true), nil,
    "dock still has no parchment")

  reset()
  local existing = ConsoleDock:Init()
  assert_true(existing ~= nil, "B27-D Init creates the dock")
  assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
    "B27-D dock name stays ChurchOfBeefConsoleDock")
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "B27-D first Init lists ChurchOfBeefConsoleDock once")
  local savedList = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 0,
    "B27-D wipe clears ChurchOfBeefConsoleDock")
  local cuesWipe = sounds
  local createCalls = 0
  local savedCreateFrame = CreateFrame
  CreateFrame = function(...)
    createCalls = createCalls + 1
    return savedCreateFrame(...)
  end
  local refreshView = ConsoleDock:Refresh()
  CreateFrame = savedCreateFrame
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "wiped UISpecialFrames + Refresh-only lists ChurchOfBeefConsoleDock once")
  assert_eq(createCalls, 0, "B27-D Refresh-only does not rebuild")
  assert_eq(sounds, cuesWipe, "B27-D Refresh-only plays no sound")
  assert_eq(refreshView.shown, false, "B27-D Refresh-only Quiet stays hidden")
  assert_eq(existing:IsShown(), false, "B27-D Refresh-only Quiet widget stays hidden")
  assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
    "B27-D Refresh-only keeps the named frame")
  assert_eq(ConsoleDock:Init(), existing, "B27-D Refresh-only keeps the same frame")
  ConsoleDock:Refresh()
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "B27-D second Refresh after wipe does not duplicate")

  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 0,
    "B27-D second wipe clears ChurchOfBeefConsoleDock")
  createCalls = 0
  savedCreateFrame = CreateFrame
  CreateFrame = function(...)
    createCalls = createCalls + 1
    return savedCreateFrame(...)
  end
  local shown = ConsoleDock:Show()
  CreateFrame = savedCreateFrame
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "wiped UISpecialFrames + Show-only lists ChurchOfBeefConsoleDock once")
  assert_eq(shown, false, "B27-D Show-only Quiet is false")
  assert_eq(createCalls, 0, "B27-D Show-only does not rebuild")
  assert_eq(sounds, cuesWipe, "B27-D Show-only plays no sound")
  assert_eq(existing:IsShown(), false, "B27-D Show-only Quiet widget stays hidden")
  assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
    "B27-D Show-only keeps the named frame")
  assert_eq(ConsoleDock:Init(), existing, "B27-D Show-only keeps the same frame")
  ConsoleDock:Show()
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "B27-D second Show after wipe does not duplicate")

  UISpecialFrames = {}
  local remounted = ConsoleDock:Init()
  assert_eq(remounted, existing, "B26-D Init remount still same frame")
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "B26-D wiped UISpecialFrames + Init still lists ChurchOfBeefConsoleDock once")

  popeFlag = true
  Runtime:StartEvent()
  assert_eq(ConsoleDock:Show(), true, "B27-D StartEvent + Pope Show is true")
  assert_eq(existing:IsShown(), true, "B27-D StartEvent + Pope shows")
  existing:Hide()
  local stay = ConsoleDock:Refresh()
  assert_eq(stay.shown, false, "B24-B same-event Hide + Refresh stays hidden")
  assert_eq(existing:IsShown(), false, "B24-B same-event Refresh does not re-show")
  assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
    "B27-D dismiss keeps UISpecialFrames")
  assert_eq(sounds, cuesWipe, "B27-D dismiss path plays no sound")

  UISpecialFrames = savedList

  if standalone then
    assert_eq(COB.Hud, nil, "isolation still does not load Hud")
    assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
    assert_eq(COB.DecreeBanner, nil, "isolation still does not load Decree")
    assert_eq(COB.RecordsBook, nil, "isolation still does not load Records Book")
    assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "isolation still does not register a slash")
  end

  --------------------------------------------------------------------------------
  -- B30-D: Hide remounts rememberSpecial when the frame already exists.
  -- Init, wipe UISpecialFrames to {}, Hide: dock name listed exactly
  -- once. Same frame pointer. Do not rebuild. Do not Show.
  -- B27-D Show/Refresh remount and B26-D Init remount stay.
  -- B24-B same-event Hide+Refresh stays hidden.
  --------------------------------------------------------------------------------
  local function runB30D()
    local hideBody = src:match("function ConsoleDock:Hide%(%)(.-)\nfunction ConsoleDock:ResetForTests")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "Hide body is readable")
    assert_true(hideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "Hide remount rememberSpecial FRAME_NAME")
    assert_eq(hideBody:find("build()", 1, true), nil,
      "Hide remount does not rebuild")
    assert_eq(hideBody:find("CreateFrame", 1, true), nil,
      "Hide remount does not CreateFrame")
    assert_eq(hideBody:find("PlaySound", 1, true), nil,
      "Hide remount does not PlaySound")
    assert_eq(hideBody:find(":Show()", 1, true), nil,
      "Hide remount does not Show")
    assert_eq(hideBody:find("self:Show", 1, true), nil,
      "Hide remount does not call Show")
    assert_true(hideBody:find("paint(false)", 1, true) ~= nil,
      "Hide remount still paint(false)")

    local refreshBody = src:match("function ConsoleDock:Refresh%(%)(.-)\nfunction ConsoleDock:Show")
    assert_true(type(refreshBody) == "string" and refreshBody ~= "",
      "B27-D Refresh body stays readable")
    local remountRefresh = refreshBody:match("return self:GetView%(%)%s+end%s+(.-)if not mayShow")
    assert_true(type(remountRefresh) == "string" and remountRefresh ~= "",
      "B27-D Refresh remount body stays readable")
    assert_true(remountRefresh:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B27-D Refresh remount rememberSpecial FRAME_NAME stays")
    assert_eq(remountRefresh:find("build()", 1, true), nil,
      "B27-D Refresh remount still does not rebuild")

    local showBody = src:match("function ConsoleDock:Show%(%)(.-)\nfunction ConsoleDock:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "B27-D Show body stays readable")
    local remountShow = showBody:match("return false%s+end%s+(.-)if not mayShow")
    assert_true(type(remountShow) == "string" and remountShow ~= "",
      "B27-D Show remount body stays readable")
    assert_true(remountShow:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B27-D Show remount rememberSpecial FRAME_NAME stays")
    assert_eq(remountShow:find("build()", 1, true), nil,
      "B27-D Show remount still does not rebuild")

    local remountInit = src:match("if not frame then return nil end(.-)return frame")
    assert_true(type(remountInit) == "string" and remountInit ~= "",
      "B26-D Init remount body stays readable")
    assert_true(remountInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B26-D Init remount rememberSpecial FRAME_NAME stays")
    assert_true(remountInit:find("self:Refresh()", 1, true) ~= nil,
      "B26-D Init remount still Refresh")
    assert_eq(remountInit:find("build()", 1, true), nil,
      "B26-D Init remount still does not rebuild")
    assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
      "rememberSpecial helper stays")
    assert_true(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "build still rememberSpecial FRAME_NAME")
    assert_true(src:find("eventId", 1, true) ~= nil,
      "per-event dismiss still keys eventId")
    assert_true(src:find("dismissed", 1, true) ~= nil,
      "per-event dismiss stays")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")
    assert_eq(src:find("cooldown", 1, true), nil,
      "source still has no dismiss-cooldown")
    assert_eq(src:find("parchment", 1, true), nil,
      "dock still has no parchment")

    reset()
    local existing = ConsoleDock:Init()
    assert_true(existing ~= nil, "B30-D Init creates the dock")
    assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
      "B30-D dock name stays ChurchOfBeefConsoleDock")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B30-D first Init lists ChurchOfBeefConsoleDock once")
    local savedHideList = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 0,
      "B30-D wipe clears ChurchOfBeefConsoleDock")
    local cuesHide = sounds
    local hideCreates = 0
    local savedHideCreate = CreateFrame
    CreateFrame = function(...)
      hideCreates = hideCreates + 1
      return savedHideCreate(...)
    end
    ConsoleDock:Hide()
    CreateFrame = savedHideCreate
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "wiped UISpecialFrames + Hide lists ChurchOfBeefConsoleDock once")
    assert_eq(hideCreates, 0, "B30-D Hide does not rebuild")
    assert_eq(sounds, cuesHide, "B30-D Hide plays no sound")
    assert_eq(existing:IsShown(), false, "B30-D Hide Quiet widget stays hidden")
    assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
      "B30-D Hide keeps the named frame")
    assert_eq(ConsoleDock:Init(), existing, "B30-D Hide keeps the same frame")
    ConsoleDock:Hide()
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B30-D second Hide after wipe does not duplicate")
    assert_eq(ConsoleDock:Init(), existing, "B30-D Hide still same frame pointer")

    UISpecialFrames = {}
    local remountedInit = ConsoleDock:Init()
    assert_eq(remountedInit, existing, "B26-D Init remount still same frame after Hide")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B26-D wiped UISpecialFrames + Init still lists ChurchOfBeefConsoleDock once")

    UISpecialFrames = {}
    ConsoleDock:Refresh()
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B27-D Refresh remount still lists ChurchOfBeefConsoleDock once")
    assert_eq(ConsoleDock:Init(), existing, "B27-D Refresh remount still same frame")
    UISpecialFrames = {}
    ConsoleDock:Show()
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B27-D Show remount still lists ChurchOfBeefConsoleDock once")
    assert_eq(ConsoleDock:Init(), existing, "B27-D Show remount still same frame")

    popeFlag = true
    Runtime:StartEvent()
    assert_eq(ConsoleDock:Show(), true, "B30-D StartEvent + Pope Show is true")
    assert_eq(existing:IsShown(), true, "B30-D StartEvent + Pope shows")
    ConsoleDock:Hide()
    assert_eq(existing:IsShown(), false, "B30-D Hide hides the live dock")
    assert_eq(ConsoleDock:GetView().shown, false, "B30-D Hide paints shown false")
    local stay = ConsoleDock:Refresh()
    assert_eq(stay.shown, false, "B24-B same-event Hide + Refresh stays hidden")
    assert_eq(existing:IsShown(), false, "B24-B same-event Refresh does not re-show")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B30-D dismiss keeps UISpecialFrames")
    assert_eq(sounds, cuesHide, "B30-D dismiss path plays no sound")
    assert_eq(ConsoleDock:Init(), existing, "B30-D live Hide keeps the same frame")

    UISpecialFrames = savedHideList

    if standalone then
      assert_eq(COB.Hud, nil, "B30-D isolation still does not load Hud")
      assert_eq(COB.Toasts, nil, "B30-D isolation still does not load Toasts")
      assert_eq(COB.DecreeBanner, nil, "B30-D isolation still does not load Decree")
      assert_eq(COB.RecordsBook, nil, "B30-D isolation still does not load Records Book")
      assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B30-D isolation still does not register a slash")
    end
  end
  runB30D()

  --------------------------------------------------------------------------------
  -- B36-C: Hide remounts a missing OnHide when the frame already
  -- exists. Extract wireDockOnHide (never replace). Existing-frame
  -- Hide: remount OnHide, then rememberSpecial(FRAME_NAME), then
  -- paint(false). Wipe list, nil OnHide, Show a live dock, Hide:
  -- OnHide restored, shown false, live dismiss set, name listed
  -- once, no sound. Third Hide does not replace OnHide.
  -- No OnShow re-wire. No rebuild. Isolation wrap stays.
  --------------------------------------------------------------------------------
  local function runB36C()
    assert_true(src:find("local function wireDockOnHide", 1, true) ~= nil,
      "source extracts wireDockOnHide")
    local wireDock = src:match("local function wireDockOnHide%(widget%)(.-)\nlocal function build")
    assert_true(type(wireDock) == "string" and wireDock ~= "",
      "wireDockOnHide body is readable")
    assert_true(wireDock:find("GetScript", 1, true) ~= nil,
      "wireDockOnHide checks GetScript")
    assert_true(wireDock:find("SetScript", 1, true) ~= nil,
      "wireDockOnHide holds SetScript")
    assert_true(wireDock:find("OnHide", 1, true) ~= nil,
      "wireDockOnHide wires OnHide")
    assert_true(wireDock:find("if existing then return", 1, true) ~= nil,
      "wireDockOnHide does not replace an existing OnHide")
    assert_true(wireDock:find("lastView", 1, true) ~= nil,
      "wireDockOnHide syncs lastView")
    assert_true(wireDock:find("dismissedEventId", 1, true) ~= nil,
      "wireDockOnHide writes live dismissedEventId")
    assert_true(wireDock:find("eventId", 1, true) ~= nil,
      "wireDockOnHide keys dismiss to eventId")
    assert_eq(wireDock:find("OnShow", 1, true), nil,
      "wireDockOnHide does not wire OnShow")
    assert_eq(wireDock:find("PlaySound", 1, true), nil,
      "wireDockOnHide does not PlaySound")
    assert_eq(wireDock:find("IG_CHARACTER_INFO", 1, true), nil,
      "wireDockOnHide has no IG_CHARACTER_INFO")
    assert_eq(wireDock:find("CreateFrame", 1, true), nil,
      "wireDockOnHide does not rebuild")
    assert_eq(wireDock:find("build()", 1, true), nil,
      "wireDockOnHide does not call build")

    local hideBody = src:match("function ConsoleDock:Hide%(%)(.-)\nfunction ConsoleDock:ResetForTests")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B36-C Hide body is readable")
    local wireAt = hideBody:find("wireDockOnHide", 1, true)
    local rememberAt = hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
    local paintAt = hideBody:find("paint(false)", 1, true)
    assert_true(wireAt ~= nil, "Hide remounts OnHide via wireDockOnHide")
    assert_true(rememberAt ~= nil, "Hide remount still rememberSpecial FRAME_NAME")
    assert_true(paintAt ~= nil, "Hide remount still paint(false)")
    assert_true(type(wireAt) == "number" and type(paintAt) == "number" and wireAt < paintAt,
      "Hide remounts OnHide before paint(false)")
    assert_true(type(wireAt) == "number" and type(rememberAt) == "number" and wireAt < rememberAt,
      "Hide remounts OnHide before rememberSpecial")
    assert_true(type(rememberAt) == "number" and type(paintAt) == "number" and rememberAt < paintAt,
      "Hide remounts rememberSpecial before paint(false)")
    assert_eq(hideBody:find("SetScript", 1, true), nil,
      "Hide does not SetScript inline")
    assert_eq(hideBody:find("OnShow", 1, true), nil,
      "Hide does not re-wire OnShow")
    assert_eq(hideBody:find("build()", 1, true), nil,
      "Hide remount does not rebuild")
    assert_eq(hideBody:find("CreateFrame", 1, true), nil,
      "Hide remount does not CreateFrame")
    assert_eq(hideBody:find("PlaySound", 1, true), nil,
      "Hide remount does not PlaySound")
    assert_eq(hideBody:find("IG_CHARACTER_INFO", 1, true), nil,
      "Hide remount has no IG_CHARACTER_INFO")
    assert_eq(hideBody:find(":Show()", 1, true), nil,
      "Hide remount does not Show")
    assert_eq(hideBody:find("self:Show", 1, true), nil,
      "Hide remount does not call Show")

    local buildBody = src:match("local function build%(%)(.-)\nfunction ConsoleDock:Init")
    assert_true(type(buildBody) == "string" and buildBody ~= "",
      "build body is readable")
    local hideInBuild = buildBody:find("widget:Hide()", 1, true)
    local wireInBuild = buildBody:find("wireDockOnHide", 1, true)
    assert_true(hideInBuild ~= nil, "create-path still has create-time Hide")
    assert_true(wireInBuild ~= nil, "create-path uses wireDockOnHide")
    assert_true(type(hideInBuild) == "number" and type(wireInBuild) == "number"
        and hideInBuild < wireInBuild,
      "create-path wires OnHide after create-time Hide")
    assert_eq(buildBody:find('SetScript("OnHide"', 1, true), nil,
      "create-path does not SetScript OnHide inline")

    local showBody = src:match("function ConsoleDock:Show%(%)(.-)\nfunction ConsoleDock:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "B27-D Show body stays readable")
    assert_true(showBody:find("wireDockOnHide", 1, true) ~= nil,
      "Show remounts OnHide via wireDockOnHide")
    assert_eq(showBody:find("OnShow", 1, true), nil,
      "Show does not re-wire OnShow")
    local remountShow = showBody:match("return false%s+end%s+(.-)if not mayShow")
    assert_true(type(remountShow) == "string" and remountShow ~= "",
      "B27-D Show remount body stays readable")
    assert_true(remountShow:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B27-D Show remount rememberSpecial FRAME_NAME stays")

    local refreshBody = src:match("function ConsoleDock:Refresh%(%)(.-)\nfunction ConsoleDock:Show")
    assert_true(type(refreshBody) == "string" and refreshBody ~= "",
      "B27-D Refresh body stays readable")
    assert_true(refreshBody:find("wireDockOnHide", 1, true) ~= nil,
      "Refresh remounts OnHide via wireDockOnHide")
    local remountRefresh = refreshBody:match("return self:GetView%(%)%s+end%s+(.-)if not mayShow")
    assert_true(type(remountRefresh) == "string" and remountRefresh ~= "",
      "B27-D Refresh remount body stays readable")
    assert_true(remountRefresh:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B27-D Refresh remount rememberSpecial FRAME_NAME stays")

    local remountInit = src:match("if not frame then return nil end(.-)return frame")
    assert_true(type(remountInit) == "string" and remountInit ~= "",
      "B26-D Init remount body stays readable")
    assert_true(remountInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B26-D Init remount rememberSpecial FRAME_NAME stays")
    assert_true(remountInit:find("wireDockOnHide", 1, true) ~= nil,
      "Init remounts OnHide via wireDockOnHide")
    assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
      "rememberSpecial helper stays")
    assert_true(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "build still rememberSpecial FRAME_NAME")
    assert_true(src:find('FRAME_NAME = "ChurchOfBeefConsoleDock"', 1, true) ~= nil,
      "FRAME_NAME stays ChurchOfBeefConsoleDock")
    assert_true(src:find("eventId", 1, true) ~= nil,
      "per-event dismiss still keys eventId")
    assert_true(src:find("dismissed", 1, true) ~= nil,
      "per-event dismiss stays")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")
    assert_eq(src:find("cooldown", 1, true), nil,
      "source still has no dismiss-cooldown")
    assert_eq(src:find("parchment", 1, true), nil,
      "dock still has no parchment")

    reset()
    local existing = ConsoleDock:Init()
    assert_true(existing ~= nil, "B36-C Init creates the dock")
    assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
      "B36-C dock name stays ChurchOfBeefConsoleDock")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B36-C first Init lists ChurchOfBeefConsoleDock once")
    popeFlag = true
    Runtime:StartEvent()
    local savedOnHideList = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 0,
      "B36-C wipe clears ChurchOfBeefConsoleDock")
    existing:SetScript("OnHide", nil)
    assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before live Show")
    local cuesOnHide = sounds
    local hideCreates = 0
    local savedHideCreate = CreateFrame
    CreateFrame = function(...)
      hideCreates = hideCreates + 1
      return savedHideCreate(...)
    end
    assert_eq(ConsoleDock:Show(), true, "B36-C Show a live dock")
    assert_eq(existing:IsShown(), true, "B36-C live Show paints")
    assert_true(existing:GetScript("OnHide") ~= nil,
      "Show remounts missing OnHide")
    ConsoleDock:Hide()
    CreateFrame = savedHideCreate
    local restored = existing:GetScript("OnHide")
    assert_true(restored ~= nil, "Hide remounts missing OnHide")
    assert_eq(ConsoleDock:GetView().shown, false, "Hide paints shown false")
    assert_eq(existing:IsShown(), false, "Hide hides the live dock")
    assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Hide is not EndEvent")
    local stay = ConsoleDock:Refresh()
    assert_eq(stay.shown, false, "live dismiss set")
    assert_eq(existing:IsShown(), false, "Refresh after remount Hide stays hidden")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "ChurchOfBeefConsoleDock re-listed once")
    assert_eq(hideCreates, 0, "Hide remount does not rebuild")
    assert_eq(sounds, cuesOnHide, "Hide remount plays no sound")
    assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
      "Hide remount keeps FRAME_NAME ChurchOfBeefConsoleDock")
    assert_eq(ConsoleDock:Init(), existing, "Hide remount keeps the same frame")

    ConsoleDock:Hide()
    assert_eq(existing:GetScript("OnHide"), restored,
      "second Hide does not replace OnHide")
    ConsoleDock:Hide()
    assert_eq(existing:GetScript("OnHide"), restored,
      "third Hide does not replace OnHide")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "third Hide does not duplicate UISpecialFrames")
    assert_eq(sounds, cuesOnHide, "third Hide plays no sound")
    assert_eq(ConsoleDock:Init(), existing, "third Hide still same frame pointer")

    UISpecialFrames = savedOnHideList

    if standalone then
      assert_eq(COB.Hud, nil, "B36-C isolation still does not load Hud")
      assert_eq(COB.Toasts, nil, "B36-C isolation still does not load Toasts")
      assert_eq(COB.DecreeBanner, nil, "B36-C isolation still does not load Decree")
      assert_eq(COB.RecordsBook, nil, "B36-C isolation still does not load Records Book")
      assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B36-C isolation still does not register a slash")
    end
  end
  runB36C()

  --------------------------------------------------------------------------------
  -- B39-D: existing-frame Show remounts a missing OnHide.
  -- wireDockOnHide then rememberSpecial(FRAME_NAME). Never replace
  -- an existing script. Wipe list, nil OnHide, Show: OnHide
  -- restored, ChurchOfBeefConsoleDock re-listed once, no sound.
  -- Third Show does not replace OnHide. Do not reset drag persist.
  -- No OnShow re-wire. No rebuild. Isolation wrap stays.
  --------------------------------------------------------------------------------
  local function runB39D()
    local showBody = src:match("function ConsoleDock:Show%(%)(.-)\nfunction ConsoleDock:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "B39-D Show body is readable")
    local remountShow = showBody:match("return false%s+end%s+(.-)if not mayShow")
    assert_true(type(remountShow) == "string" and remountShow ~= "",
      "B39-D Show remount body is readable")
    local wireAt = remountShow:find("wireDockOnHide", 1, true)
    local rememberAt = remountShow:find("rememberSpecial(FRAME_NAME)", 1, true)
    assert_true(wireAt ~= nil, "Show remounts OnHide via wireDockOnHide")
    assert_true(rememberAt ~= nil, "Show remount still rememberSpecial FRAME_NAME")
    assert_true(type(wireAt) == "number" and type(rememberAt) == "number" and wireAt < rememberAt,
      "Show remounts OnHide before rememberSpecial")
    assert_eq(showBody:find("SetScript", 1, true), nil,
      "Show does not SetScript inline")
    assert_eq(showBody:find("OnShow", 1, true), nil,
      "Show does not re-wire OnShow")
    assert_eq(showBody:find("build()", 1, true), nil,
      "Show remount does not rebuild")
    assert_eq(showBody:find("CreateFrame", 1, true), nil,
      "Show remount does not CreateFrame")
    assert_eq(showBody:find("PlaySound", 1, true), nil,
      "Show remount does not PlaySound")
    assert_eq(showBody:find("IG_CHARACTER_INFO", 1, true), nil,
      "Show remount has no IG_CHARACTER_INFO")
    assert_eq(remountShow:find("restorePoint", 1, true), nil,
      "Show remount does not restorePoint")
    assert_eq(remountShow:find("savePoint", 1, true), nil,
      "Show remount does not savePoint")
    assert_eq(remountShow:find("consoleDock", 1, true), nil,
      "Show remount does not reset drag persist")
    assert_eq(remountShow:find("build()", 1, true), nil,
      "Show remount body does not rebuild")
    assert_eq(remountShow:find("Init()", 1, true), nil,
      "Show remount does not Init")

    local hideBody = src:match("function ConsoleDock:Hide%(%)(.-)\nfunction ConsoleDock:ResetForTests")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B36-C Hide body stays readable")
    assert_true(hideBody:find("wireDockOnHide", 1, true) ~= nil,
      "B36-C Hide remount still wireDockOnHide")
    assert_true(hideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B36-C Hide remount still rememberSpecial FRAME_NAME")

    local refreshBody = src:match("function ConsoleDock:Refresh%(%)(.-)\nfunction ConsoleDock:Show")
    assert_true(type(refreshBody) == "string" and refreshBody ~= "",
      "B27-D Refresh body stays readable")
    assert_true(refreshBody:find("wireDockOnHide", 1, true) ~= nil,
      "Refresh remounts OnHide via wireDockOnHide")
    local remountRefresh = refreshBody:match("return self:GetView%(%)%s+end%s+(.-)if not mayShow")
    assert_true(type(remountRefresh) == "string" and remountRefresh ~= "",
      "B27-D Refresh remount body stays readable")
    assert_true(remountRefresh:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B27-D Refresh remount rememberSpecial FRAME_NAME stays")

    local remountInit = src:match("if not frame then return nil end(.-)return frame")
    assert_true(type(remountInit) == "string" and remountInit ~= "",
      "B26-D Init remount body stays readable")
    assert_true(remountInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B26-D Init remount rememberSpecial FRAME_NAME stays")
    assert_true(remountInit:find("wireDockOnHide", 1, true) ~= nil,
      "Init remounts OnHide via wireDockOnHide")
    assert_true(src:find("local function wireDockOnHide", 1, true) ~= nil,
      "wireDockOnHide helper stays")
    assert_true(src:find("if existing then return", 1, true) ~= nil,
      "wireDockOnHide still does not replace an existing OnHide")
    assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
      "rememberSpecial helper stays")
    assert_true(src:find('FRAME_NAME = "ChurchOfBeefConsoleDock"', 1, true) ~= nil,
      "FRAME_NAME stays ChurchOfBeefConsoleDock")
    assert_true(src:find("eventId", 1, true) ~= nil,
      "per-event dismiss still keys eventId")
    assert_true(src:find("dismissed", 1, true) ~= nil,
      "per-event dismiss stays")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")
    assert_eq(src:find("cooldown", 1, true), nil,
      "source still has no dismiss-cooldown")
    assert_eq(src:find("parchment", 1, true), nil,
      "dock still has no parchment")

    reset()
    local existing = ConsoleDock:Init()
    assert_true(existing ~= nil, "B39-D Init creates the dock")
    assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
      "B39-D dock name stays ChurchOfBeefConsoleDock")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B39-D first Init lists ChurchOfBeefConsoleDock once")
    local persistPoint, persistRel, persistRelPoint, persistX, persistY = existing:GetPoint(1)
    popeFlag = true
    Runtime:StartEvent()
    local savedShowList = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 0,
      "B39-D wipe clears ChurchOfBeefConsoleDock")
    existing:SetScript("OnHide", nil)
    assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Show")
    local cuesShow = sounds
    local showCreates = 0
    local savedShowCreate = CreateFrame
    CreateFrame = function(...)
      showCreates = showCreates + 1
      return savedShowCreate(...)
    end
    assert_eq(ConsoleDock:Show(), true, "B39-D Show a live dock")
    CreateFrame = savedShowCreate
    local restored = existing:GetScript("OnHide")
    assert_true(restored ~= nil, "Show remounts missing OnHide")
    assert_eq(existing:IsShown(), true, "Show paints the live dock")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "ChurchOfBeefConsoleDock re-listed once")
    assert_eq(showCreates, 0, "Show remount does not rebuild")
    assert_eq(sounds, cuesShow, "Show remount plays no sound")
    assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
      "Show remount keeps FRAME_NAME ChurchOfBeefConsoleDock")
    assert_eq(ConsoleDock:Init(), existing, "Show remount keeps the same frame")
    assert_eq(select(1, existing:GetPoint(1)), persistPoint,
      "Show remount does not reset drag point")
    assert_eq(select(2, existing:GetPoint(1)), persistRel,
      "Show remount does not reset drag relative")
    assert_eq(select(3, existing:GetPoint(1)), persistRelPoint,
      "Show remount does not reset drag relativePoint")
    assert_eq(select(4, existing:GetPoint(1)), persistX,
      "Show remount does not reset drag x")
    assert_eq(select(5, existing:GetPoint(1)), persistY,
      "Show remount does not reset drag y")

    ConsoleDock:Show()
    assert_eq(existing:GetScript("OnHide"), restored,
      "second Show does not replace OnHide")
    ConsoleDock:Show()
    assert_eq(existing:GetScript("OnHide"), restored,
      "third Show does not replace OnHide")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "third Show does not duplicate UISpecialFrames")
    assert_eq(sounds, cuesShow, "third Show plays no sound")
    assert_eq(ConsoleDock:Init(), existing, "third Show still same frame pointer")
    assert_eq(existing:IsShown(), true, "third Show stays painted")

    UISpecialFrames = savedShowList

    if standalone then
      assert_eq(COB.Hud, nil, "B39-D isolation still does not load Hud")
      assert_eq(COB.Toasts, nil, "B39-D isolation still does not load Toasts")
      assert_eq(COB.DecreeBanner, nil, "B39-D isolation still does not load Decree")
      assert_eq(COB.RecordsBook, nil, "B39-D isolation still does not load Records Book")
      assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B39-D isolation still does not register a slash")
    end
  end
  runB39D()

  --------------------------------------------------------------------------------
  -- B40-C: existing-frame Refresh remounts a missing OnHide.
  -- wireDockOnHide then rememberSpecial(FRAME_NAME). Never replace
  -- an existing script. Wipe list, nil OnHide, Refresh: OnHide
  -- restored, ChurchOfBeefConsoleDock re-listed once, no sound.
  -- Third Refresh does not replace OnHide. Do not reset drag
  -- persist. Do not pop a dismissed dock. No OnShow re-wire.
  -- No rebuild. Isolation wrap stays.
  --------------------------------------------------------------------------------
  local function runB40C()
      local refreshBody = src:match("function ConsoleDock:Refresh%(%)(.-)\nfunction ConsoleDock:Show")
      assert_true(type(refreshBody) == "string" and refreshBody ~= "",
        "B40-C Refresh body is readable")
      local remountRefresh = refreshBody:match("return self:GetView%(%)%s+end%s+(.-)if not mayShow")
      assert_true(type(remountRefresh) == "string" and remountRefresh ~= "",
        "B40-C Refresh remount body is readable")
      local wireAt = remountRefresh:find("wireDockOnHide", 1, true)
      local rememberAt = remountRefresh:find("rememberSpecial(FRAME_NAME)", 1, true)
      assert_true(wireAt ~= nil, "Refresh remounts OnHide via wireDockOnHide")
      assert_true(rememberAt ~= nil, "Refresh remount still rememberSpecial FRAME_NAME")
      assert_true(type(wireAt) == "number" and type(rememberAt) == "number" and wireAt < rememberAt,
        "Refresh remounts OnHide before rememberSpecial")
      assert_eq(refreshBody:find("SetScript", 1, true), nil,
        "Refresh does not SetScript inline")
      assert_eq(refreshBody:find("OnShow", 1, true), nil,
        "Refresh does not re-wire OnShow")
      assert_eq(remountRefresh:find("build()", 1, true), nil,
        "Refresh remount does not rebuild")
      assert_eq(remountRefresh:find("CreateFrame", 1, true), nil,
        "Refresh remount does not CreateFrame")
      assert_eq(refreshBody:find("PlaySound", 1, true), nil,
        "Refresh remount does not PlaySound")
      assert_eq(refreshBody:find("IG_CHARACTER_INFO", 1, true), nil,
        "Refresh remount has no IG_CHARACTER_INFO")
      assert_eq(remountRefresh:find("restorePoint", 1, true), nil,
        "Refresh remount does not restorePoint")
      assert_eq(remountRefresh:find("savePoint", 1, true), nil,
        "Refresh remount does not savePoint")
      assert_eq(remountRefresh:find("consoleDock", 1, true), nil,
        "Refresh remount does not reset drag persist")
      assert_eq(remountRefresh:find("build()", 1, true), nil,
        "Refresh remount body does not rebuild")
      assert_eq(remountRefresh:find("Init()", 1, true), nil,
        "Refresh remount does not Init")
      assert_eq(remountRefresh:find("OnShow", 1, true), nil,
        "Refresh remount does not re-wire OnShow")

      local showBody = src:match("function ConsoleDock:Show%(%)(.-)\nfunction ConsoleDock:Hide")
      assert_true(type(showBody) == "string" and showBody ~= "",
        "B39-D Show body stays readable")
      assert_true(showBody:find("wireDockOnHide", 1, true) ~= nil,
        "B39-D Show remount still wireDockOnHide")
      assert_true(showBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
        "B39-D Show remount still rememberSpecial FRAME_NAME")

      local hideBody = src:match("function ConsoleDock:Hide%(%)(.-)\nfunction ConsoleDock:ResetForTests")
      assert_true(type(hideBody) == "string" and hideBody ~= "",
        "B36-C Hide body stays readable")
      assert_true(hideBody:find("wireDockOnHide", 1, true) ~= nil,
        "B36-C Hide remount still wireDockOnHide")
      assert_true(hideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
        "B36-C Hide remount still rememberSpecial FRAME_NAME")

      local remountInit = src:match("if not frame then return nil end(.-)return frame")
      assert_true(type(remountInit) == "string" and remountInit ~= "",
        "B26-D Init remount body stays readable")
      assert_true(remountInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
        "B26-D Init remount rememberSpecial FRAME_NAME stays")
      assert_true(remountInit:find("wireDockOnHide", 1, true) ~= nil,
        "Init remounts OnHide via wireDockOnHide")
      assert_true(src:find("local function wireDockOnHide", 1, true) ~= nil,
        "wireDockOnHide helper stays")
      assert_true(src:find("if existing then return", 1, true) ~= nil,
        "wireDockOnHide still does not replace an existing OnHide")
      assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
        "rememberSpecial helper stays")
      assert_true(src:find('FRAME_NAME = "ChurchOfBeefConsoleDock"', 1, true) ~= nil,
        "FRAME_NAME stays ChurchOfBeefConsoleDock")
      assert_true(src:find("eventId", 1, true) ~= nil,
        "per-event dismiss still keys eventId")
      assert_true(src:find("dismissed", 1, true) ~= nil,
        "per-event dismiss stays")
      assert_eq(src:find("PlaySound", 1, true), nil,
        "source still does not play sound")
      assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
        "source still has no IG_CHARACTER_INFO")
      assert_eq(src:find("cooldown", 1, true), nil,
        "source still has no dismiss-cooldown")
      assert_eq(src:find("parchment", 1, true), nil,
        "dock still has no parchment")

      reset()
      local existing = ConsoleDock:Init()
      assert_true(existing ~= nil, "B40-C Init creates the dock")
      assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
        "B40-C dock name stays ChurchOfBeefConsoleDock")
      assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
        "B40-C first Init lists ChurchOfBeefConsoleDock once")
      local persistPoint, persistRel, persistRelPoint, persistX, persistY = existing:GetPoint(1)
      popeFlag = true
      Runtime:StartEvent()
      assert_eq(ConsoleDock:Show(), true, "B40-C StartEvent + Pope Show is true")
      assert_eq(existing:IsShown(), true, "B40-C StartEvent + Pope shows")
      existing:Hide()
      assert_eq(existing:IsShown(), false, "B40-C widget Hide dismisses")
      assert_eq(ConsoleDock:GetView().shown, false, "B40-C widget Hide sets shown false")
      local savedRefreshList = UISpecialFrames
      UISpecialFrames = {}
      assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 0,
        "B40-C wipe clears ChurchOfBeefConsoleDock")
      existing:SetScript("OnHide", nil)
      assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Refresh")
      local cuesRefresh = sounds
      local refreshCreates = 0
      local savedRefreshCreate = CreateFrame
      CreateFrame = function(...)
        refreshCreates = refreshCreates + 1
        return savedRefreshCreate(...)
      end
      local stay = ConsoleDock:Refresh()
      CreateFrame = savedRefreshCreate
      local restored = existing:GetScript("OnHide")
      assert_true(restored ~= nil, "Refresh remounts missing OnHide")
      assert_eq(stay.shown, false, "Refresh does not pop a dismissed dock")
      assert_eq(existing:IsShown(), false, "Refresh after dismiss stays hidden")
      assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
        "ChurchOfBeefConsoleDock re-listed once")
      assert_eq(refreshCreates, 0, "Refresh remount does not rebuild")
      assert_eq(sounds, cuesRefresh, "Refresh remount plays no sound")
      assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
        "Refresh remount keeps FRAME_NAME ChurchOfBeefConsoleDock")
      assert_eq(ConsoleDock:Init(), existing, "Refresh remount keeps the same frame")
      assert_eq(select(1, existing:GetPoint(1)), persistPoint,
        "Refresh remount does not reset drag point")
      assert_eq(select(2, existing:GetPoint(1)), persistRel,
        "Refresh remount does not reset drag relative")
      assert_eq(select(3, existing:GetPoint(1)), persistRelPoint,
        "Refresh remount does not reset drag relativePoint")
      assert_eq(select(4, existing:GetPoint(1)), persistX,
        "Refresh remount does not reset drag x")
      assert_eq(select(5, existing:GetPoint(1)), persistY,
        "Refresh remount does not reset drag y")

      ConsoleDock:Refresh()
      assert_eq(existing:GetScript("OnHide"), restored,
        "second Refresh does not replace OnHide")
      assert_eq(existing:IsShown(), false, "second Refresh stays dismissed")
      ConsoleDock:Refresh()
      assert_eq(existing:GetScript("OnHide"), restored,
        "third Refresh does not replace OnHide")
      assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
        "third Refresh does not duplicate UISpecialFrames")
      assert_eq(sounds, cuesRefresh, "third Refresh plays no sound")
      assert_eq(ConsoleDock:Init(), existing, "third Refresh still same frame pointer")
      assert_eq(existing:IsShown(), false, "third Refresh stays dismissed")

      UISpecialFrames = savedRefreshList

      if standalone then
        assert_eq(COB.Hud, nil, "B40-C isolation still does not load Hud")
        assert_eq(COB.Toasts, nil, "B40-C isolation still does not load Toasts")
        assert_eq(COB.DecreeBanner, nil, "B40-C isolation still does not load Decree")
        assert_eq(COB.RecordsBook, nil, "B40-C isolation still does not load Records Book")
        assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B40-C isolation still does not register a slash")
      end
    end
  runB40C()

  --------------------------------------------------------------------------------
  -- B41-C: existing-frame Init remounts a missing OnHide.
  -- wireDockOnHide then rememberSpecial(FRAME_NAME) then Refresh.
  -- Never replace an existing script. Wipe list, nil OnHide, Init:
  -- OnHide restored, ChurchOfBeefConsoleDock re-listed once, no
  -- sound. Third Init does not replace OnHide. Do not reset drag
  -- persist. Do not pop a dismissed dock. No OnShow re-wire.
  -- No rebuild. Isolation wrap stays.
  --------------------------------------------------------------------------------
  local function runB41C()
    local remountInit = src:match("if not frame then return nil end(.-)return frame")
    assert_true(type(remountInit) == "string" and remountInit ~= "",
      "B41-C Init remount body is readable")
    local wireAt = remountInit:find("wireDockOnHide", 1, true)
    local rememberAt = remountInit:find("rememberSpecial(FRAME_NAME)", 1, true)
    local refreshAt = remountInit:find("self:Refresh()", 1, true)
    assert_true(wireAt ~= nil, "Init remounts OnHide via wireDockOnHide")
    assert_true(rememberAt ~= nil, "Init remount still rememberSpecial FRAME_NAME")
    assert_true(refreshAt ~= nil, "Init remount still Refresh")
    assert_true(type(wireAt) == "number" and type(rememberAt) == "number" and wireAt < rememberAt,
      "Init remounts OnHide before rememberSpecial")
    assert_true(type(rememberAt) == "number" and type(refreshAt) == "number" and rememberAt < refreshAt,
      "Init remounts rememberSpecial before Refresh")
    assert_eq(remountInit:find("SetScript", 1, true), nil,
      "Init remount does not SetScript inline")
    assert_eq(remountInit:find("OnShow", 1, true), nil,
      "Init remount does not re-wire OnShow")
    assert_eq(remountInit:find("build()", 1, true), nil,
      "Init remount does not rebuild")
    assert_eq(remountInit:find("CreateFrame", 1, true), nil,
      "Init remount does not CreateFrame")
    assert_eq(remountInit:find("PlaySound", 1, true), nil,
      "Init remount does not PlaySound")
    assert_eq(remountInit:find("IG_CHARACTER_INFO", 1, true), nil,
      "Init remount has no IG_CHARACTER_INFO")
    assert_eq(remountInit:find("restorePoint", 1, true), nil,
      "Init remount does not restorePoint")
    assert_eq(remountInit:find("savePoint", 1, true), nil,
      "Init remount does not savePoint")
    assert_eq(remountInit:find("consoleDock", 1, true), nil,
      "Init remount does not reset drag persist")

    local refreshBody = src:match("function ConsoleDock:Refresh%(%)(.-)\nfunction ConsoleDock:Show")
    assert_true(type(refreshBody) == "string" and refreshBody ~= "",
      "B40-C Refresh body stays readable")
    assert_true(refreshBody:find("wireDockOnHide", 1, true) ~= nil,
      "B40-C Refresh remount still wireDockOnHide")
    local remountRefresh = refreshBody:match("return self:GetView%(%)%s+end%s+(.-)if not mayShow")
    assert_true(type(remountRefresh) == "string" and remountRefresh ~= "",
      "B40-C Refresh remount body stays readable")
    local refreshWire = remountRefresh:find("wireDockOnHide", 1, true)
    local refreshRemember = remountRefresh:find("rememberSpecial(FRAME_NAME)", 1, true)
    assert_true(refreshWire ~= nil, "Refresh remount still wireDockOnHide")
    assert_true(refreshRemember ~= nil, "Refresh remount still rememberSpecial FRAME_NAME")
    assert_true(type(refreshWire) == "number" and type(refreshRemember) == "number"
        and refreshWire < refreshRemember,
      "Refresh remount still wires OnHide before rememberSpecial")

    local showBody = src:match("function ConsoleDock:Show%(%)(.-)\nfunction ConsoleDock:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "B39-D Show body stays readable")
    assert_true(showBody:find("wireDockOnHide", 1, true) ~= nil,
      "B39-D Show remount still wireDockOnHide")
    assert_true(showBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B39-D Show remount still rememberSpecial FRAME_NAME")

    local hideBody = src:match("function ConsoleDock:Hide%(%)(.-)\nfunction ConsoleDock:ResetForTests")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B36-C Hide body stays readable")
    assert_true(hideBody:find("wireDockOnHide", 1, true) ~= nil,
      "B36-C Hide remount still wireDockOnHide")
    assert_true(hideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B36-C Hide remount still rememberSpecial FRAME_NAME")

    assert_true(src:find("local function wireDockOnHide", 1, true) ~= nil,
      "wireDockOnHide helper stays")
    assert_true(src:find("if existing then return", 1, true) ~= nil,
      "wireDockOnHide still does not replace an existing OnHide")
    assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
      "rememberSpecial helper stays")
    assert_true(src:find('FRAME_NAME = "ChurchOfBeefConsoleDock"', 1, true) ~= nil,
      "FRAME_NAME stays ChurchOfBeefConsoleDock")
    assert_true(src:find("eventId", 1, true) ~= nil,
      "per-event dismiss still keys eventId")
    assert_true(src:find("dismissed", 1, true) ~= nil,
      "per-event dismiss stays")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")
    assert_eq(src:find("cooldown", 1, true), nil,
      "source still has no dismiss-cooldown")
    assert_eq(src:find("parchment", 1, true), nil,
      "dock still has no parchment")

    reset()
    local existing = ConsoleDock:Init()
    assert_true(existing ~= nil, "B41-C Init creates the dock")
    assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
      "B41-C dock name stays ChurchOfBeefConsoleDock")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "B41-C first Init lists ChurchOfBeefConsoleDock once")
    local persistPoint, persistRel, persistRelPoint, persistX, persistY = existing:GetPoint(1)
    popeFlag = true
    Runtime:StartEvent()
    assert_eq(ConsoleDock:Show(), true, "B41-C StartEvent + Pope Show is true")
    assert_eq(existing:IsShown(), true, "B41-C StartEvent + Pope shows")
    existing:Hide()
    assert_eq(existing:IsShown(), false, "B41-C widget Hide dismisses")
    assert_eq(ConsoleDock:GetView().shown, false, "B41-C widget Hide sets shown false")
    local savedInitList = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 0,
      "B41-C wipe clears ChurchOfBeefConsoleDock")
    existing:SetScript("OnHide", nil)
    assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Init")
    local cuesInit = sounds
    local initCreates = 0
    local savedInitCreate = CreateFrame
    CreateFrame = function(...)
      initCreates = initCreates + 1
      return savedInitCreate(...)
    end
    local remounted = ConsoleDock:Init()
    CreateFrame = savedInitCreate
    local restored = existing:GetScript("OnHide")
    assert_true(restored ~= nil, "Init remounts missing OnHide")
    assert_eq(remounted, existing, "Init remount keeps the same frame")
    assert_eq(ConsoleDock:GetView().shown, false, "Init does not pop a dismissed dock")
    assert_eq(existing:IsShown(), false, "Init after dismiss stays hidden")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "ChurchOfBeefConsoleDock re-listed once")
    assert_eq(initCreates, 0, "Init remount does not rebuild")
    assert_eq(sounds, cuesInit, "Init remount plays no sound")
    assert_eq(existing:GetName(), "ChurchOfBeefConsoleDock",
      "Init remount keeps FRAME_NAME ChurchOfBeefConsoleDock")
    assert_eq(select(1, existing:GetPoint(1)), persistPoint,
      "Init remount does not reset drag point")
    assert_eq(select(2, existing:GetPoint(1)), persistRel,
      "Init remount does not reset drag relative")
    assert_eq(select(3, existing:GetPoint(1)), persistRelPoint,
      "Init remount does not reset drag relativePoint")
    assert_eq(select(4, existing:GetPoint(1)), persistX,
      "Init remount does not reset drag x")
    assert_eq(select(5, existing:GetPoint(1)), persistY,
      "Init remount does not reset drag y")

    ConsoleDock:Init()
    assert_eq(existing:GetScript("OnHide"), restored,
      "second Init does not replace OnHide")
    assert_eq(existing:IsShown(), false, "second Init stays dismissed")
    ConsoleDock:Init()
    assert_eq(existing:GetScript("OnHide"), restored,
      "third Init does not replace OnHide")
    assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
      "third Init does not duplicate UISpecialFrames")
    assert_eq(sounds, cuesInit, "third Init plays no sound")
    assert_eq(ConsoleDock:Init(), existing, "third Init still same frame pointer")
    assert_eq(existing:IsShown(), false, "third Init stays dismissed")

    UISpecialFrames = savedInitList

    if standalone then
      assert_eq(COB.Hud, nil, "B41-C isolation still does not load Hud")
      assert_eq(COB.Toasts, nil, "B41-C isolation still does not load Toasts")
      assert_eq(COB.DecreeBanner, nil, "B41-C isolation still does not load Decree")
      assert_eq(COB.RecordsBook, nil, "B41-C isolation still does not load Records Book")
      assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "B41-C isolation still does not register a slash")
    end
  end
  runB41C()

  --------------------------------------------------------------------------------
  -- U-I: DIRECTOR CONSOLE gate, SANCTION plate, Expand stays stock.
  -- Nested inside runB27D — no new main-chunk locals.
  --------------------------------------------------------------------------------
  local function runUI()
    local Theme = COB.Theme
    assert_true(Theme ~= nil, "U-I Theme is loaded")
    local dockPlateUp = Theme:Texture("plate_verb")
    local dockPlateHover = Theme:Texture("plate_verb_hover")
    local dockPlateDown = Theme:Texture("plate_verb_pressed")
    assert_true(type(dockPlateUp) == "string" and dockPlateUp ~= "", "Theme resolves plate_verb")

    reset()
    local desk = ConsoleDock:Init()
    assert_eq(desk.TitleText:GetText(), TITLE, "U-I Quiet title is DIRECTOR CONSOLE")
    assert_eq(rawget(desk, "TitleSeal"), nil, "dock has no title-bar seal")
    assert_eq(ConsoleDock:GetView().shown, false, "U-I Quiet Init stays hidden")
    assert_eq(desk:IsShown(), false, "U-I Quiet widget stays hidden")

    popeFlag = true
    local view = ConsoleDock:Refresh()
    assert_eq(view.shown, false, "U-I Pope + Quiet stays hidden")
    assert_eq(view.title, TITLE, "U-I Quiet view title stays DIRECTOR CONSOLE")
    assert_eq(view.state, "QUIET", "U-I Quiet view reports QUIET")

    Runtime:StartEvent()
    popeFlag = false
    view = ConsoleDock:Refresh()
    assert_eq(view.shown, false, "U-I live event + non-Pope stays hidden")
    assert_eq(desk:IsShown(), false, "U-I non-Pope widget stays hidden")

    popeFlag = true
    view = ConsoleDock:Refresh()
    assert_eq(view.shown, true, "U-I live event + Pope shows")
    assert_eq(desk:IsShown(), true, "U-I live Pope widget shows")
    assert_eq(view.title, TITLE, "U-I shown title stays DIRECTOR CONSOLE")
    assert_eq(desk.TitleText:GetText(), TITLE, "U-I painted title is DIRECTOR CONSOLE")

    local dockSanction = findButton(desk, "SANCTION")
    local dockExpand = findButton(desk, "Expand")
    assert_true(dockSanction ~= nil, "U-I SANCTION stays")
    assert_true(dockExpand ~= nil, "U-I Expand stays")
    assert_eq(dockSanction._template, "UIPanelButtonTemplate", "U-I SANCTION stays a panel button")
    assert_eq(dockExpand._template, "UIPanelButtonTemplate", "U-I Expand stays stock")
    assert_eq(dockSanction._cobNormalTexture, dockPlateUp, "dock SANCTION normal is Theme plate_verb")
    assert_eq(dockSanction._cobHighlightTexture, dockPlateHover, "dock SANCTION highlight is Theme plate_verb_hover")
    assert_eq(dockSanction._cobPushedTexture, dockPlateDown, "dock SANCTION pushed is Theme plate_verb_pressed")
    assert_eq(dockExpand._cobNormalTexture, nil, "Expand is not a verb plate")
    assert_eq(dockExpand._cobHighlightTexture, nil, "Expand has no plate hover")
    assert_eq(dockExpand._cobPushedTexture, nil, "Expand has no plate press")

    local dockPlated = {}
    walk(desk, function(child)
      if child._type == "Button" and child._cobNormalTexture then
        dockPlated[#dockPlated + 1] = child:GetText()
      end
    end)
    assert_eq(#dockPlated, 1, "exactly one plated dock button")
    assert_eq(dockPlated[1], "SANCTION", "only SANCTION is plated")

    local sealHits = 0
    walk(desk, function(child)
      if child._type == "Texture" and child._cobTexture == Theme:Texture("seal_papal") then
        sealHits = sealHits + 1
      end
    end)
    assert_eq(sealHits, 0, "dock has no seal_papal texture")

    local srcFile = io.open("addon/ChurchOfBeef/UI/ConsoleDock.lua", "r")
    assert_true(srcFile ~= nil, "ConsoleDock.lua is readable for U-I pins")
    local src = srcFile:read("*a")
    srcFile:close()
    assert_eq(src:find("WHISPER ALL", 1, true), nil, "U-I source has no WHISPER ALL")
    assert_eq(src:find("SendChatMessage", 1, true), nil, "U-I source does not send chat")
    assert_eq(src:find("seal_papal", 1, true), nil, "dock source has no title-bar seal")
    assert_true(src:find('themeTexture("plate_verb")', 1, true) ~= nil,
      "dock SANCTION requests Theme plate_verb")
    assert_eq(src:find("Media\\", 1, true), nil, "U-I source still has no custom Media")
    assert_eq(src:find("parchment", 1, true), nil, "dock still has no parchment")
    assert_eq(src:find("oxblood", 1, true), nil, "dock has no red token")
    assert_eq(sounds, 0, "U-I path plays no sound")
  end
  runUI()
end
runB27D()

--------------------------------------------------------------------------------
-- SANCTION click spies Console:Sanction. Expand spies Console:Show.
--------------------------------------------------------------------------------
reset()
frame = ConsoleDock:Init()
popeFlag = true
Runtime:StartEvent()
ConsoleDock:Show()
local sanction = findButton(frame, "SANCTION")
local expand = findButton(frame, "Expand")
assert_eq(sanctionCalls, 0, "Show does not sanction")
assert_eq(showCalls, 0, "Show does not expand the desk")
stub.fire(sanction, "OnClick")
assert_eq(sanctionCalls, 1, "SANCTION click spies Console:Sanction")
assert_eq(showCalls, 0, "SANCTION does not call Console:Show")
stub.fire(expand, "OnClick")
assert_eq(showCalls, 1, "Expand click spies Console:Show")
assert_eq(sanctionCalls, 1, "Expand does not sanction")
assert_eq(sounds, 0, "clicks play no sound")

COB.Console = nil
stub.fire(sanction, "OnClick")
stub.fire(expand, "OnClick")
assert_eq(sanctionCalls, 1, "missing Console does not invent Sanction")
assert_eq(showCalls, 1, "missing Console does not invent Show")
stubConsole()

--------------------------------------------------------------------------------
-- Fail-closed: missing Sender, missing Runtime, non-true Pope, missing name.
--------------------------------------------------------------------------------
reset()
frame = ConsoleDock:Init()
popeFlag = true
Runtime:StartEvent()
COB.Sender = nil
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "missing Sender hides")
assert_eq(frame:IsShown(), false, "missing Sender hides the widget")
stubSender()

local savedRuntime = COB.Runtime
COB.Runtime = nil
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "missing Runtime hides")
COB.Runtime = savedRuntime
popeFlag = true
view = ConsoleDock:Refresh()
assert_eq(view.shown, true, "restored Runtime + Pope shows")

COB.Sender.IsRegisteredPope = function() return 1 end
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "non-true Pope is fail-closed")

stubSender()
popeFlag = true
local savedUnitName = UnitName
UnitName = function() return nil end
COB.Group = nil
COB.Net = nil
view = ConsoleDock:Refresh()
assert_eq(view.shown, false, "missing local player name is fail-closed")
UnitName = savedUnitName

--------------------------------------------------------------------------------
-- GetView returns a copy. Toast trap. ResetForTests is harness-gated.
--------------------------------------------------------------------------------
reset()
frame = ConsoleDock:Init()
popeFlag = true
Runtime:StartEvent()
ConsoleDock:Show()
view = ConsoleDock:GetView()
view.shown = false
view.title = "mutated"
view.state = "QUIET"
local again = ConsoleDock:GetView()
assert_eq(again.shown, true, "mutating GetView does not hide the dock")
assert_eq(again.title, TITLE, "mutating GetView does not rename the dock")
assert_eq(again.state, "ASSEMBLY", "mutating GetView does not change Runtime")

local savedToasts = COB.Toasts
COB.Toasts = {
  Show = function() toastCalls = toastCalls + 1 end,
  Push = function() toastCalls = toastCalls + 1 end,
  Celebrate = function() toastCalls = toastCalls + 1 end,
}
ConsoleDock:Refresh()
assert_eq(toastCalls, 0, "dock does not toast")
COB.Toasts = savedToasts

ChurchOfBeef._IN_TEST = false
assert_eq(ConsoleDock:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(frame:IsShown(), true, "out-of-harness reset does not hide the dock")
ChurchOfBeef._IN_TEST = true
assert_eq(ConsoleDock:ResetForTests(), true, "ResetForTests returns under _IN_TEST")
assert_eq(frame:IsShown(), false, "harness reset hides the dock")

--------------------------------------------------------------------------------
-- Missing CreateFrame must not fail load.
--------------------------------------------------------------------------------
reset()
local savedCreate = CreateFrame
CreateFrame = nil
assert_eq(ConsoleDock:Init(), nil, "Init without CreateFrame returns nil")
CreateFrame = savedCreate
frame = ConsoleDock:Init()
assert_true(frame ~= nil, "Init after CreateFrame rebuilds the frame")
assert_eq(frame:IsShown(), false, "rebuilt Init in Quiet stays hidden")

--------------------------------------------------------------------------------
-- Drag persists when ChurchOfBeefDB.ui exists. TitleBar OnDragStop, not root.
-- Invalid saved point falls back. Quiet Init with a saved point still hides.
-- ResetForTests must not wipe SavedVariables. Missing DB: default restore;
-- save no-ops.
--------------------------------------------------------------------------------
ChurchOfBeefDB = { ui = {} }
reset()
frame = ConsoleDock:Init()
Runtime:StartEvent()
popeFlag = true
assert_eq(ConsoleDock:Show(), true, "StartEvent + Pope Show is true before drag")
assert_eq(frame:GetScript("OnDragStop"), nil, "drag is on the title bar, not the root")
local titleBar = frame.TitleBar
assert_true(titleBar ~= nil, "title bar is the drag handle")
stub.fire(titleBar, "OnDragStart")
assert_eq(frame._moving, true, "dragging the title bar moves the dock")
frame:ClearAllPoints()
frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 24, 90)
stub.fire(titleBar, "OnDragStop")
assert_eq(frame._moving, false, "drop stops the move")
assert_eq(frame:GetScript("OnUpdate"), nil, "drop leaves no animator")
local saved = ChurchOfBeefDB.ui and ChurchOfBeefDB.ui.consoleDock
assert_true(type(saved) == "table", "moved position is saved")
assert_eq(saved and saved.point, "TOPLEFT", "saved anchor point")
assert_eq(saved and saved.relativePoint, "TOPLEFT", "saved relative point")
assert_eq(saved and saved.x, 24, "saved x")
assert_eq(saved and saved.y, 90, "saved y")
assert_eq(saved and saved.relativeTo, nil, "no frame reference lands in SavedVariables")

dofile("addon/ChurchOfBeef/UI/ConsoleDock.lua")
ConsoleDock = COB.ConsoleDock
local reloaded = ConsoleDock:Init()
local rp, rto, rrp, rx, ry = reloaded:GetPoint(1)
assert_eq(rp, "TOPLEFT", "saved top-left anchor restores")
assert_eq(rto, UIParent, "restore still parents to UIParent")
assert_eq(rrp, "TOPLEFT", "saved relative top-left restores")
assert_eq(rx, 24, "saved x restores")
assert_eq(ry, 90, "saved y restores")
frame = reloaded

ChurchOfBeefDB.ui.consoleDock = { point = "MIDDLE-OF-NOWHERE", relativePoint = "CENTER", x = 1, y = 2 }
dofile("addon/ChurchOfBeef/UI/ConsoleDock.lua")
ConsoleDock = COB.ConsoleDock
local safe = ConsoleDock:Init()
assert_eq(select(1, safe:GetPoint(1)), "BOTTOMLEFT", "invalid saved anchor falls back to BOTTOMLEFT")
assert_eq(select(2, safe:GetPoint(1)), UIParent, "invalid saved point still parents to UIParent")
assert_eq(select(4, safe:GetPoint(1)), 16, "invalid saved x falls back to 16")
assert_eq(select(5, safe:GetPoint(1)), 80, "invalid saved y falls back to 80")
frame = safe

ChurchOfBeefDB.ui.consoleDock = { point = "TOPLEFT", relativePoint = "TOPLEFT", x = 24, y = 90 }
reset()
assert_true(type(ChurchOfBeefDB.ui.consoleDock) == "table", "ResetForTests does not wipe SV")
assert_eq(ChurchOfBeefDB.ui.consoleDock.point, "TOPLEFT", "ResetForTests leaves the saved point")
frame = ConsoleDock:Init()
assert_eq(frame:IsShown(), false, "Quiet Init with a saved point still hides")
assert_eq(select(1, frame:GetPoint(1)), "TOPLEFT", "Quiet Init still restores the saved point")
assert_eq(select(2, frame:GetPoint(1)), UIParent, "Quiet restore still parents to UIParent")
assert_eq(select(4, frame:GetPoint(1)), 24, "Quiet Init restores saved x")
assert_eq(select(5, frame:GetPoint(1)), 90, "Quiet Init restores saved y")
assert_eq(frame.TitleText:GetText(), TITLE, "Quiet restored title stays DIRECTOR CONSOLE")
if frame.CloseButton then
  assert_eq(frame.CloseButton:IsShown(), false, "Quiet restored CloseButton stays hidden")
end
assert_true(findButton(frame, "SANCTION") ~= nil, "Quiet restored SANCTION stays")
assert_true(findButton(frame, "Expand") ~= nil, "Quiet restored Expand stays")
assert_eq(sounds, 0, "persist path plays no sound")

srcFile = io.open("addon/ChurchOfBeef/UI/ConsoleDock.lua", "r")
assert_true(srcFile ~= nil, "ConsoleDock.lua is readable after persist pins")
src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("consoleDock", 1, true) ~= nil, true, "source keys ChurchOfBeefDB.ui.consoleDock")
assert_eq(src:find("ANCHORS", 1, true) ~= nil, true, "source whitelists ANCHORS")
assert_eq(src:find("relativeTo", 1, true), nil, "source never stores relativeTo")
assert_eq(src:find("PlaySound", 1, true), nil, "persist source still has no PlaySound")
assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil, "persist source still has no IG_CHARACTER_INFO")
assert_eq(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil, true,
  "persist source still remembers FRAME_NAME")
assert_true(src:find('SetScript("OnHide"', 1, true) ~= nil,
  "persist source still hooks OnHide")
assert_true(src:find("dismissed", 1, true) ~= nil, "persist source still remembers dismiss")
assert_true(src:find("eventId", 1, true) ~= nil, "persist source still keys dismiss to eventId")
assert_eq(src:find("cooldown", 1, true), nil, "persist source still has no dismiss-cooldown")
assert_eq(src:find("OnUpdate", 1, true), nil, "persist source still has no OnUpdate")
assert_eq(src:find("Media\\", 1, true), nil, "persist source still has no custom Media")
assert_eq(src:find("BasicFrameTemplate", 1, true) ~= nil, true, "dock stays BasicFrameTemplate")
assert_eq(countSpecial("ChurchOfBeefConsoleDock"), 1,
  "persist remounts still list ChurchOfBeefConsoleDock once")

ChurchOfBeefDB = nil
dofile("addon/ChurchOfBeef/UI/ConsoleDock.lua")
ConsoleDock = COB.ConsoleDock
frame = ConsoleDock:Init()
assert_eq(select(1, frame:GetPoint(1)), "BOTTOMLEFT", "missing ChurchOfBeefDB restores BOTTOMLEFT")
assert_eq(select(2, frame:GetPoint(1)), UIParent, "missing ChurchOfBeefDB still parents to UIParent")
assert_eq(select(4, frame:GetPoint(1)), 16, "missing ChurchOfBeefDB restores x 16")
assert_eq(select(5, frame:GetPoint(1)), 80, "missing ChurchOfBeefDB restores y 80")
titleBar = frame.TitleBar
assert_true(titleBar ~= nil, "missing-DB title bar is still the drag handle")
stub.fire(titleBar, "OnDragStart")
frame:ClearAllPoints()
frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 99, 99)
stub.fire(titleBar, "OnDragStop")
assert_eq(ChurchOfBeefDB, nil, "save no-ops when ChurchOfBeefDB is missing")

assert_eq(sounds, 0, "the suite played no sound")

COB.Console = savedConsole
COB.Sender = savedSender
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
