-- Director Console target-driven Pope kit (Lane K UX rebuild). The console is
-- rebuilt around whoever the Pope is targeting, not around lists. Petitions
-- and the Knighting line stay as secondary strips. Cold tools (Archive,
-- Canonize, Recognition, Grant Honorific, Notebook, ceremony log, confession
-- inbox, Recommend, CallForward) leave the UI; their Core modules keep their
-- APIs. Rites surfaced in UI: Knighting and Gora only. Human copy replaces
-- engineer copy: no player-facing QUIET / ASSEMBLY / RITE / CONSEQUENCE names.
--
-- Isolated: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting
-- + Sender + Decree + Theme + Console. No Confession / Archive / Recognition /
-- Net / Hud / Toasts / Sound / DecreeBanner — the desk never calls theater
-- (glue owns that). The Pope predicate stays fail-closed unless a section
-- wraps Sender.IsRegisteredPope in-test (and restores it). No TOC / bootstrap /
-- MainFrame / slash. Lua 5.1: every section is function-wrapped (200-local cap).
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

local promoteCalls = 0
local savedPromote = GuildPromote
local savedSetGuildRank = SetGuildRank
local savedSlash = SLASH_CHURCHOFBEEF1
GuildPromote = function()
  promoteCalls = promoteCalls + 1
end
SetGuildRank = function()
  promoteCalls = promoteCalls + 1
end

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")
dofile("addon/ChurchOfBeef/Core/Knighting.lua")
dofile("addon/ChurchOfBeef/Core/Sender.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/UI/Console.lua")

local COB = ChurchOfBeef
local Console = COB.Console
local Runtime = COB.Runtime
local Store = COB.Store
local Gora = COB.Gora
local Knighting = COB.Knighting
local Sender = COB.Sender
local Decree = COB.Decree
local Theme = COB.Theme

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local savedPred
local popeDepth = 0

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Gora:ResetForTests(), true, "Gora ResetForTests runs under _IN_TEST")
  assert_eq(Decree:ResetForTests(), true, "Decree ResetForTests runs under _IN_TEST")
  if type(Knighting.ResetForTests) == "function" then
    assert_eq(Knighting:ResetForTests(), true, "Knighting ResetForTests runs under _IN_TEST")
  end
  if Console.ResetForTests then
    assert_eq(Console:ResetForTests(), true, "Console ResetForTests runs under _IN_TEST")
  end
  if COB.Nights and type(COB.Nights.ResetForTests) == "function" then
    assert_eq(COB.Nights:ResetForTests(), true, "Nights ResetForTests runs under _IN_TEST")
  end
  COB.Roster = nil
  stub.group.target = nil
  promoteCalls = 0
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

local function isVisible(widget)
  local w = widget
  while w do
    if w._shown == false then return false end
    w = w._parent
  end
  return true
end

local function buttonVisible(root, label)
  local btn = findButton(root, label)
  return btn ~= nil and isVisible(btn)
end

local function fontVisible(root, text)
  local fs = findFont(root, text)
  return fs ~= nil and isVisible(fs)
end

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

local function seedHuman(name, rankId)
  local human = Store:CreateHuman({ name = name }, 1000)
  if rankId ~= nil then
    Store:SetRank(human.id, rankId, 1000)
    human = Store:GetHuman(human.id)
  end
  return human
end

local function seedLinked(charName, humanName, rankId, fields)
  local human = seedHuman(humanName or charName, rankId)
  local ch = Store:CreateCharacter(fields or { name = charName, class = "Warrior", level = 70 })
  Store:LinkCharacter(ch.id, human.id, 1001)
  return human, ch
end

-- The wow_ui_stub UnitName answers M.group[unit].name for non-player units.
local function setTarget(name)
  if name == nil then
    stub.group.target = nil
  else
    stub.group.target = { name = name }
  end
end

local function fireTargetChanged()
  stub.fire(Console.frame, "OnEvent", "PLAYER_TARGET_CHANGED")
end

local function targetStranger(name)
  setTarget(name)
  fireTargetChanged()
end

local function popeOn()
  Sender = COB.Sender
  if popeDepth == 0 then
    savedPred = Sender.IsRegisteredPope
    Sender.IsRegisteredPope = function() return true end
  end
  popeDepth = popeDepth + 1
end
local function popeOff()
  assert_true(popeDepth > 0, "popeOff restores a saved predicate")
  popeDepth = popeDepth - 1
  if popeDepth == 0 then
    Sender = COB.Sender
    Sender.IsRegisteredPope = savedPred
    savedPred = nil
  end
end

local function readSource()
  local f = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
  assert_true(f ~= nil, "Console.lua is readable")
  local body = f:read("*a")
  f:close()
  return body
end

-- No player-facing runtime state names anywhere on the desk (human copy law).
local function assertNoStateNames(frame, phase)
  local banned = { "QUIET", "ASSEMBLY", "RITE", "CONSEQUENCE" }
  walk(frame, function(widget)
    if (widget._type == "FontString" or widget._type == "Button" or widget._type == "EditBox")
        and widget.GetText then
      local text = widget:GetText()
      if type(text) == "string" then
        for i = 1, #banned do
          assert_eq(text:find(banned[i], 1, true), nil,
            phase .. " copy never shows " .. banned[i] .. " (saw '" .. text .. "')")
        end
      end
    end
  end)
end

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(Console ~= nil, "COB.Console exists")
assert_true(Runtime ~= nil, "isolated suite loads Runtime")
assert_true(Store ~= nil, "isolated suite loads Store")
assert_true(Gora ~= nil, "isolated suite loads Gora")
assert_true(Knighting ~= nil, "isolated suite loads Knighting")
assert_true(Sender ~= nil, "isolated suite loads Sender")
assert_true(Decree ~= nil, "isolated suite loads Decree")
assert_true(Theme ~= nil, "isolated suite loads Theme")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_eq(Console.MODE, "Event", "Director Console declares Event Mode")

if standalone then
  assert_eq(COB.UI, nil, "isolated suite does not load the Quiet shell")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Roster, nil, "isolated suite does not load Roster")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Hud, nil, "isolated suite does not load the Fight HUD")
  assert_eq(COB.Sound, nil, "isolated suite does not load Sound")
  assert_eq(COB.DecreeBanner, nil, "isolated suite does not load Decree UI")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load the Records Book")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Snapshot, nil, "isolated suite does not load Snapshot")
  assert_eq(COB.Confession, nil, "isolated suite does not load Confession")
  assert_eq(COB.ConsoleDock, nil, "the console dock is retired")
end

--------------------------------------------------------------------------------
-- Public API: the exact kit surface, and the methods that left with the cold
-- tools.
--------------------------------------------------------------------------------
assert_eq(type(Console.Init), "function", "Init exists")
assert_eq(type(Console.Show), "function", "Show exists")
assert_eq(type(Console.Hide), "function", "Hide exists")
assert_eq(type(Console.Toggle), "function", "Toggle exists")
assert_eq(type(Console.IsShown), "function", "IsShown exists")
assert_eq(type(Console.Refresh), "function", "Refresh exists")
assert_eq(type(Console.ResetForTests), "function", "ResetForTests exists")

assert_eq(type(Console.GetPresence), "function", "GetPresence is a console readout")
assert_eq(type(Console.GetPresenceCensus), "function", "GetPresenceCensus is a console readout")
assert_eq(type(Console.GetKnightingLine), "function", "GetKnightingLine is a console readout")
assert_eq(type(Console.GetPetitions), "function", "GetPetitions is a console readout")
assert_eq(type(Console.GetWorkingSubject), "function", "GetWorkingSubject is a console readout")
assert_eq(type(Console.GetProposedBout), "function", "GetProposedBout is a console readout")
assert_eq(type(Console.GetFavorSplit), "function", "GetFavorSplit is a console readout")
assert_eq(type(Console.GetFavorCount), "function", "GetFavorCount is a console readout")
assert_eq(type(Console.GetCongregationFavorVisible), "function", "congregation favor toggle is readable")

assert_eq(type(Console.SelectHuman), "function", "SelectHuman sets the working subject")
assert_eq(type(Console.SelectCharacter), "function", "SelectCharacter sets the working subject")
assert_eq(type(Console.SetFighterA), "function", "SetFighterA assigns the pair slot")
assert_eq(type(Console.SetFighterB), "function", "SetFighterB assigns the pair slot")

assert_eq(type(Console.StartEvent), "function", "StartEvent is a console verb")
assert_eq(type(Console.OpenRite), "function", "OpenRite is a console verb")
assert_eq(type(Console.CloseRite), "function", "CloseRite is a console verb")
assert_eq(type(Console.Continue), "function", "Continue is a console verb")
assert_eq(type(Console.EndEvent), "function", "EndEvent is a console verb")
assert_eq(type(Console.KnightThisBeef), "function", "KNIGHT THIS BEEF is a console verb")
assert_eq(type(Console.ElevateToLord), "function", "ElevateToLord is a console verb")
assert_eq(type(Console.Sanction), "function", "SANCTION is a console verb")
assert_eq(type(Console.DeclareVictor), "function", "DECLARE VICTOR is a console verb")
assert_eq(type(Console.CowardiceRecorded), "function", "COWARDICE RECORDED is a console verb")
assert_eq(type(Console.Void), "function", "VOID is a console verb")
assert_eq(type(Console.FreeRuling), "function", "free ruling is a console verb")
assert_eq(type(Console.FlagMoment), "function", "Mark this moment is a console verb")
assert_eq(type(Console.PostDecree), "function", "Post the Decree is a console verb")
assert_eq(type(Console.Dismiss), "function", "Dismiss is a console verb")
assert_eq(type(Console.Enqueue), "function", "Enqueue is a console verb")
assert_eq(type(Console.Skip), "function", "Skip is a console verb")
assert_eq(type(Console.SetCongregationFavorVisible), "function", "congregation favor toggle is settable")

-- Removed with the cold tools / module dump.
assert_eq(Console.CallForward, nil, "CallForward leaves with the confession inbox")
assert_eq(Console.Recommend, nil, "Recommend leaves the kit")
assert_eq(Console.GetConfessions, nil, "no confession inbox on the kit")
assert_eq(Console.GetCeremonyLog, nil, "no ceremony log on the kit")
assert_eq(Console.GrantHonorific, nil, "Grant Honorific leaves with the cold tools")
assert_eq(Console.BeginRecognition, nil, "Recognition leaves with the cold tools")
assert_eq(Console.CompleteRecognition, nil, "CompleteRecognition leaves with the cold tools")
assert_eq(Console.CancelRecognition, nil, "CancelRecognition leaves with the cold tools")
assert_eq(Console.ExportArchive, nil, "Archive export leaves with the cold tools")
assert_eq(Console.ImportArchive, nil, "Archive import leaves with the cold tools")
assert_eq(Console.CanonizeMoment, nil, "Canonize leaves with the cold tools")
assert_eq(Console.FlagFamousUpset, nil, "FlagFamousUpset leaves with the cold tools")
assert_eq(Console.SelectFighters, nil, "SelectFighters is replaced by SetFighterA / SetFighterB")

-- Banned machinery stays banned.
assert_eq(Console.Grant, nil, "no Grant")
assert_eq(Console.Narrate, nil, "software does not narrate")
assert_eq(Console.Proclaim, nil, "no generated proclamation")
assert_eq(Console.Announce, nil, "console does not announce")
assert_eq(Console.AutoAdvance, nil, "no auto-advance")
assert_eq(Console.SaveNote, nil, "no Notebook persist")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.GuildPromote, nil, "no GuildPromote on the console")
assert_eq(Console.SetGuildRank, nil, "no SetGuildRank on the console")
assert_eq(Console.RegisterPope, nil, "no Pope list configuration")
assert_eq(Console.Queue, nil, "no Knighting queue store")
assert_eq(Console.AdvanceQueue, nil, "no queue auto-advance")
assert_eq(Console.NextCandidate, nil, "no next-candidate store")
assert_eq(Console.Target, nil, "targeting assist is not this lane")
assert_eq(Console.SetRaidMarker, nil, "raid markers are not this lane")
assert_eq(Console.Calendar, nil, "no calendar")
assert_eq(Console.RSVP, nil, "no RSVP")
assert_eq(Console.Deputy, nil, "no deputy")
assert_eq(Console.WinnerPicker, nil, "no winner picker")
assert_eq(Console.PickWinner, nil, "no winner picker")
assert_eq(SLASH_CHURCHOFBEEF1, savedSlash, "Console does not register a slash")
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "the registered-Pope predicate stays fail-closed")

do
  reset()
  local realPred = Sender.IsRegisteredPope
  Sender.IsRegisteredPope = function() return false end
  local before = Console.frame
  Console:Show()
  assert_eq(Console.frame, before, "non-Pope Show does not mint the desk")
  assert_eq(Console:IsShown(), false, "non-Pope Show stays hidden")
  Console:Toggle()
  assert_eq(Console.frame, before, "non-Pope Toggle does not mint the desk")
  Console:Init()
  assert_true(Console.frame ~= nil, "Init may build the desk in tests")
  Console:Show()
  assert_eq(Console:IsShown(), false, "non-Pope Show stays hidden after Init")
  Console:Toggle()
  assert_eq(Console:IsShown(), false, "non-Pope Toggle stays hidden after Init")
  Sender.IsRegisteredPope = realPred
end

--------------------------------------------------------------------------------
-- Lifecycle: hidden stock working frame, ESC, resize, persist.
--------------------------------------------------------------------------------
local function runLifecycle()
  reset()
  local frame = Console:Init()
  assert_true(frame ~= nil, "Init creates the console frame")
  assert_eq(frame:GetName(), "ChurchOfBeefConsoleFrame", "console has its own global name")
  assert_eq(frame._template, "BasicFrameTemplate", "stock BasicFrameTemplate")
  assert_true(frame.TitleText ~= nil, "BasicFrame TitleText present")
  assert_eq(frame.TitleText:GetText(), "Director Console", "title is the Bible desk name")
  assert_eq(Console:IsShown(), false, "frame starts hidden")
  assert_eq(Console:Init(), frame, "Init is idempotent")
  assert_eq(frame._movable, true, "frame is movable")
  assert_eq(frame._clamped, true, "frame is clamped to screen")
  assert_true(frame.SizeGrip ~= nil, "console has a size grip")
  assert_eq(frame:IsEventRegistered("DISPLAY_SIZE_CHANGED"), true,
    "console re-clamps when the display changes")
  assert_eq(frame:IsEventRegistered("UI_SCALE_CHANGED"), true,
    "console re-clamps when the ui scale changes")
  assert_eq(frame:IsEventRegistered("PLAYER_TARGET_CHANGED"), false,
    "target listening sleeps while the desk is hidden")
  assert_eq(frame:GetParent(), UIParent, "insecure frame under UIParent")
  assert_eq(frame:GetWidth(), 560, "default width is about 560")
  assert_eq(frame:GetHeight(), 600, "default height is about 600")
  assert_true(frame._minResize ~= nil, "2.5.x resize bounds are set")
  assert_eq(frame._minResize[1], 520, "width floor is 520")
  assert_eq(frame._minResize[2], 440, "height floor is 440")
  assert_true(frame.DeskScroll ~= nil, "desk body ScrollFrame exists")
  assert_eq(frame.DeskScroll._type, "ScrollFrame", "desk body is a ScrollFrame")
  assert_true(frame.DeskChild ~= nil, "desk child exists")
  assert_eq(frame:GetScript("OnUpdate"), nil, "no permanent OnUpdate")

  -- Toggle / Show / Hide only. Listed Pope required (login Init is not enough).
  popeOn()
  Console:Toggle()
  assert_eq(Console:IsShown(), true, "toggle opens the console")
  Console:Toggle()
  assert_eq(Console:IsShown(), false, "toggle closes the console")
  Console:Show()
  assert_eq(Console:IsShown(), true, "Show opens the console")
  assert_eq(frame:IsEventRegistered("PLAYER_TARGET_CHANGED"), true,
    "the kit listens for target changes while shown")
  Console:Hide()
  assert_eq(Console:IsShown(), false, "Hide closes the console")
  assert_eq(frame:IsEventRegistered("PLAYER_TARGET_CHANGED"), false,
    "Hide stops target listening")

  -- ESC: the named desk rides UISpecialFrames; a direct Hide (the ESC path)
  -- bypasses Console:Hide, so OnHide remounts the listing.
  assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
    "Init lists the console on UISpecialFrames once")
  Console:Init()
  assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1, "repeat Init does not duplicate")
  Console:Show()
  assert_eq(frame:IsEventRegistered("PLAYER_TARGET_CHANGED"), true,
    "a reopened desk listens for target changes again")
  frame:Hide()
  assert_eq(Console:IsShown(), false, "ESC hides the frame")
  assert_eq(frame:IsEventRegistered("PLAYER_TARGET_CHANGED"), false,
    "ESC dismissal stops target listening via OnHide")
  assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1, "ESC re-lists the frame via OnHide")

  local savedSpecial = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 0, "wipe clears the listing")
  Console:Show()
  assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1, "Show remounts the listing")
  UISpecialFrames = {}
  Console:Refresh()
  assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1, "Refresh remounts the listing")
  UISpecialFrames = {}
  Console:Hide()
  assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1, "Hide remounts the listing")
  UISpecialFrames = savedSpecial

  -- Grip resize clamps to the floor and persists ChurchOfBeefDB.ui.console.
  frame:SetWidth(900)
  frame:SetHeight(640)
  stub.fire(frame, "OnSizeChanged")
  assert_eq(frame:GetWidth(), 900, "console grows with the grip")
  assert_eq(frame:GetHeight(), 640, "console height follows a legal resize")
  ChurchOfBeefDB = { ui = {} }
  stub.fire(frame.SizeGrip, "OnMouseUp")
  assert_eq(ChurchOfBeefDB.ui.console.w, 900, "grip drop persists width")
  assert_eq(ChurchOfBeefDB.ui.console.h, 640, "grip drop persists height")
  frame:SetWidth(500)
  frame:SetHeight(400)
  stub.fire(frame, "OnSizeChanged")
  assert_eq(frame:GetWidth(), 520, "console width clamps to the floor")
  assert_eq(frame:GetHeight(), 440, "console height clamps to the floor")
  stub.fire(frame.SizeGrip, "OnMouseDown", "RightButton")
  assert_eq(frame:GetWidth(), 560, "right-click grip restores default width")
  assert_eq(frame:GetHeight(), 600, "right-click grip restores default height")
  ChurchOfBeefDB = nil

  -- Persisted size and point restore on a fresh build.
  ChurchOfBeefDB = { ui = { console = {
    w = 600, h = 500,
    point = "TOPLEFT", relativePoint = "TOPLEFT", x = 100, y = -100,
  } } }
  Console.frame = nil
  local rebuilt = Console:Init()
  assert_eq(rebuilt:GetWidth(), 600, "persisted width restores")
  assert_eq(rebuilt:GetHeight(), 500, "persisted height restores")
  local point, _, relativePoint, x, y = rebuilt:GetPoint(1)
  assert_eq(point, "TOPLEFT", "persisted point restores")
  assert_eq(relativePoint, "TOPLEFT", "persisted relative point restores")
  assert_eq(x, 100, "persisted x restores")
  assert_eq(y, -100, "persisted y restores")
  ChurchOfBeefDB = nil
  Console.frame = nil
  Console:Init()
  popeOff()
end
runLifecycle()

--------------------------------------------------------------------------------
-- Pope gate: every verb refuses with the exact string while the predicate is
-- fail-closed, and dead buttons write nothing.
--------------------------------------------------------------------------------
local function runPopeGate()
  reset()
  local frame = Console:Init()
  Console:Refresh()
  Console:Show()
  assert_eq(Console:IsShown(), false, "fail-closed Show does not open the desk")
  local steve = seedHuman("Steve", 2)
  local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })

  local starts = 0
  local realStart = Runtime.StartEvent
  Runtime.StartEvent = function(self, ...)
    starts = starts + 1
    return realStart(self, ...)
  end
  local flags = 0
  local realFlag = Store.FlagMoment
  Store.FlagMoment = function(self, ...)
    flags = flags + 1
    return realFlag(self, ...)
  end
  local knights = 0
  local realKnight = Knighting.KnightThisBeef
  Knighting.KnightThisBeef = function(self, ...)
    knights = knights + 1
    return realKnight(self, ...)
  end

  local ok, err = Console:StartEvent()
  assert_eq(ok, nil, "StartEvent refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "refuse reason is mechanical")
  assert_eq(starts, 0, "Runtime:StartEvent is not called")
  assert_eq(Runtime:Snapshot().state, "QUIET", "runtime stays QUIET")

  ok, err = Console:OpenRite("Knighting")
  assert_eq(ok, nil, "OpenRite refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "OpenRite refuse reason")
  ok, err = Console:CloseRite()
  assert_eq(ok, nil, "CloseRite refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "CloseRite refuse reason")
  ok, err = Console:Continue()
  assert_eq(ok, nil, "Continue refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "Continue refuse reason")
  ok, err = Console:EndEvent()
  assert_eq(ok, nil, "EndEvent refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "EndEvent refuse reason")

  ok, err = Console:KnightThisBeef(steve.id)
  assert_eq(ok, nil, "KNIGHT THIS BEEF refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "knight refuse reason")
  assert_eq(knights, 0, "Knighting:KnightThisBeef is not called")
  assert_eq(Store:GetHuman(steve.id).rankId, 2, "Church rank is unchanged")

  ok, err = Console:ElevateToLord(steve.id)
  assert_eq(ok, nil, "ElevateToLord refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "elevate refuse reason")
  assert_eq(Store:GetHuman(steve.id).rankId, 2, "elevation does not write")

  ok, err = Console:Sanction(a.id, b.id)
  assert_eq(ok, nil, "Sanction refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "sanction refuse reason")
  assert_eq(Gora:GetSanctioned(), nil, "no live pair")

  ok, err = Console:DeclareVictor(a.id)
  assert_eq(ok, nil, "DECLARE VICTOR refuses")
  assert_eq(err, "not a registered pope", "victor refuse reason")
  ok, err = Console:CowardiceRecorded(a.id)
  assert_eq(ok, nil, "COWARDICE RECORDED refuses")
  assert_eq(err, "not a registered pope", "cowardice refuse reason")
  ok, err = Console:Void()
  assert_eq(ok, nil, "VOID refuses")
  assert_eq(err, "not a registered pope", "void refuse reason")
  ok, err = Console:FreeRuling("the ring is closed")
  assert_eq(ok, nil, "FREE RULING refuses")
  assert_eq(err, "not a registered pope", "free ruling refuse reason")
  ok, err = Console:Dismiss(a.id)
  assert_eq(ok, nil, "Dismiss refuses")
  assert_eq(err, "not a registered pope", "dismiss refuse reason")
  ok, err = Console:Enqueue(steve.id)
  assert_eq(ok, nil, "Enqueue refuses")
  assert_eq(err, "not a registered pope", "enqueue refuse reason")
  ok, err = Console:Skip(steve.id)
  assert_eq(ok, nil, "Skip refuses")
  assert_eq(err, "not a registered pope", "skip refuse reason")

  ok, err = Console:FlagMoment()
  assert_eq(ok, nil, "Mark this moment refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "moment refuse reason")
  assert_eq(flags, 0, "Store:FlagMoment is not called")
  assert_eq(#Store:GetMarkedMoments(), 0, "no marked moment")

  ok, err = Console:PostDecree({ line = "Goldshire Inn — Sunday, 7:00 PM" })
  assert_eq(ok, nil, "PostDecree refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "PostDecree refuse reason")
  assert_eq(Decree:Get(), nil, "refused PostDecree does not Set")

  ok, err = Console:SetCongregationFavorVisible(false)
  assert_eq(ok, nil, "the congregation toggle refuses when not the registered Pope")
  assert_eq(err, "not a registered pope", "toggle refuse reason")
  assert_eq(Console:GetCongregationFavorVisible(), true, "refused toggle leaves the flag on")

  -- Dead buttons write nothing.
  stub.fire(findButton(frame, "Start the gathering"), "OnClick")
  stub.fire(findButton(frame, "Post the Decree"), "OnClick")
  assert_eq(starts, 0, "dead buttons do not StartEvent on a live client")
  assert_eq(Decree:Get(), nil, "dead Post the Decree does not Set")
  assert_eq(promoteCalls, 0, "refused verbs never GuildPromote")

  -- The gate disables the verb chrome.
  assert_eq(findButton(frame, "Start the gathering"):IsEnabled(), false,
    "applyGate disables Start the gathering")
  assert_eq(frame.PostDecree:IsEnabled(), false, "applyGate disables Post the Decree")
  assert_eq(frame.GateStatus:GetText(), "not a registered pope",
    "the desk says why the chrome is dead")

  Runtime.StartEvent = realStart
  Store.FlagMoment = realFlag
  Knighting.KnightThisBeef = realKnight
end
runPopeGate()

--------------------------------------------------------------------------------
-- Verbs reach signed Core with explicit ids (unchanged semantics), phases via
-- the console's own buttons.
--------------------------------------------------------------------------------
local function runVerbsReachCore()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()
  local steve = seedHuman("Steve", 2)
  local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })

  local started = Console:StartEvent()
  assert_true(started ~= nil, "StartEvent reaches Runtime when the predicate is true")
  assert_eq(started.state, "ASSEMBLY", "zero-config Tuesday start is StartEvent")
  assert_eq(started.riteType, nil, "StartEvent has no event-setup rite")
  assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "machine is live")

  local opened = Console:OpenRite("Gora")
  assert_true(opened ~= nil, "OpenRite reaches Runtime")
  assert_eq(opened.state, "RITE", "OpenRite opens a typed rite")
  assert_eq(opened.riteType, "Gora", "rite type is caller-supplied")
  assert_eq(Console:OpenRite("Tournament"), nil, "unknown rite types are refused")

  local closed = Console:CloseRite()
  assert_eq(closed.state, "CONSEQUENCE", "CloseRite is one click")
  local continued = Console:Continue()
  assert_eq(continued.state, "ASSEMBLY", "Continue returns to ASSEMBLY")
  assert_eq(continued.riteType, nil, "Continue clears the rite")

  Console:OpenRite("Knighting")
  Console:CloseRite()
  local ended = Console:EndEvent()
  assert_eq(ended.state, "QUIET", "EndEvent returns to QUIET")

  Console:StartEvent()
  local knighted = Console:KnightThisBeef(steve.id)
  assert_true(knighted ~= nil, "KNIGHT THIS BEEF reaches Knighting")
  assert_eq(knighted.rankId, 3, "Church record is Beef Knight")
  local elevated = Console:ElevateToLord(steve.id)
  assert_eq(elevated.rankId, 4, "ElevateToLord writes Beef Lord")

  Gora:Petition(a.id, b.id)
  Gora:Petition(b.id)
  COB.Roster = {
    ready = true,
    members = {
      chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
      tendermage = { name = "Tendermage", guildRankIndex = 5 },
    },
  }
  local petitions = Console:GetPetitions()
  assert_eq(#petitions, 2, "Gora desk shows present petitioners")
  assert_eq(petitions[1].characterId, a.id, "petition ids are store characters")

  local sanctioned = Console:Sanction(a.id, b.id)
  assert_true(sanctioned ~= nil, "SANCTION BEEF GORA reaches Gora")
  assert_eq(sanctioned.fighterA, a.id, "sanctioned pair is remembered")
  local voided = Console:Void()
  assert_eq(voided.ruling, "void", "VOID reaches Gora")
  assert_eq(Gora:GetSanctioned(), nil, "a ruling clears the live pair")

  Gora:Petition(a.id)
  Gora:Petition(b.id)
  Console:Sanction(a.id, b.id)
  local victor = Console:DeclareVictor(a.id)
  assert_eq(victor.ruling, "victor", "DECLARE VICTOR reaches Gora")

  Gora:Petition(a.id)
  Gora:Petition(b.id)
  Console:Sanction(a.id, b.id)
  local coward = Console:CowardiceRecorded(b.id)
  assert_eq(coward.ruling, "cowardice", "COWARDICE RECORDED reaches Gora")

  Gora:Petition(a.id)
  Gora:Petition(b.id)
  Console:Sanction(a.id, b.id)
  local free = Console:FreeRuling("the ring is closed")
  assert_eq(free.ruling, "free", "FREE RULING reaches Gora")
  assert_eq(free.text, "the ring is closed", "FREE RULING carries the text")

  Gora:Petition(a.id)
  assert_eq(Console:Dismiss(a.id), true, "Dismiss reaches Gora")
  local afterDismiss = Console:GetPetitions()
  local stillA = false
  for i = 1, #afterDismiss do
    if afterDismiss[i].characterId == a.id then stillA = true end
  end
  assert_eq(stillA, false, "dismissed petition is gone")

  local moment = Console:FlagMoment()
  assert_true(moment ~= nil, "Mark this moment reaches Store")
  assert_eq(#Store:GetMarkedMoments(), 1, "the moment is recorded")
  assert_eq(Store:GetMarkedMoments()[1].location, nil, "no location picker")

  local posted = Console:PostDecree({
    line = "Goldshire Inn — Sunday, 7:00 PM",
    flavor = "bring a fork",
  })
  assert_true(posted ~= nil, "PostDecree reaches Decree when the predicate is true")
  assert_eq(posted.line, "Goldshire Inn — Sunday, 7:00 PM", "PostDecree sets line")
  assert_eq(posted.flavor, "bring a fork", "PostDecree sets flavor")
  assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "Decree:Get is the posted line")
  assert_eq(posted.header, nil, "header is UI copy, not stored")

  frame.DecreeLine:SetText("Goldshire Inn — Tuesday")
  frame.DecreeFlavor:SetText("one optional line")
  stub.fire(findButton(frame, "Post the Decree"), "OnClick")
  assert_eq(Decree:Get().line, "Goldshire Inn — Tuesday", "the Post the Decree button reads the line box")
  assert_eq(Decree:Get().flavor, "one optional line", "the Post the Decree button reads the flavor box")

  -- The phase buttons drive the runtime.
  Console:EndEvent()
  stub.fire(findButton(frame, "Start the gathering"), "OnClick")
  assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Start the gathering starts the gathering")
  stub.fire(findButton(frame, "Open a Knighting rite"), "OnClick")
  assert_eq(Runtime:Snapshot().riteType, "Knighting", "Open a Knighting rite opens the rite")
  stub.fire(findButton(frame, "Back to Gathering"), "OnClick")
  assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "Back to Gathering closes the rite")
  stub.fire(findButton(frame, "Continue"), "OnClick")
  assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Continue returns to the gathering")
  stub.fire(findButton(frame, "End the gathering"), "OnClick")
  assert_eq(Runtime:Snapshot().state, "QUIET", "End the gathering ends the gathering")

  assert_eq(promoteCalls, 0, "console verbs never GuildPromote")
  assert_true(frame ~= nil, "frame fixture exists")
  popeOff()
  assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
    "wrapping the predicate in-test does not stub the list true")
  assert_eq(Console:StartEvent(), nil, "after restore, verbs refuse again")
  assert_eq(COB.Popes, nil, "still no Pope list")
end
runVerbsReachCore()

--------------------------------------------------------------------------------
-- Working subject: from the target, from row clicks, precedence, clearing.
--------------------------------------------------------------------------------
local function runWorkingSubject()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()
  assert_eq(Console:GetWorkingSubject(), nil, "no subject before any target or selection")
  assert_eq(frame.TargetLine:GetText(), "Target a guildmate, then select them.",
    "empty subject asks for a target")

  -- Target a known character: ids resolve through Names.Key (+ linked human).
  local human, ch = seedLinked("Chuckroast", "Chuck", 3)
  targetStranger("chuckroast-Whitemane")
  local subject = Console:GetWorkingSubject()
  assert_true(subject ~= nil, "targeting a named character sets the working subject")
  assert_eq(subject.name, "Chuckroast", "subject name is the store spelling")
  assert_eq(subject.characterId, ch.id, "subject carries the character id")
  assert_eq(subject.humanId, human.id, "subject carries the linked human id")
  assert_eq(subject.rankId, 3, "subject carries the human rank")
  assert_eq(subject.rankTitle, "Beef Knight", "subject carries the rank title")
  assert_eq(subject.needsKnighting, false, "a Knight does not need Knighting")
  assert_eq(subject.source, "target", "subject source is the target")
  assert_eq(frame.TargetLine:GetText(), "Current target: Chuckroast · Beef Knight",
    "the target line names the target and rank")

  -- The getter hands out a copy.
  subject.name = "mutated"
  assert_eq(Console:GetWorkingSubject().name, "Chuckroast", "GetWorkingSubject returns a copy")

  -- A Fresh Beef target needs Knighting.
  local freshHuman, freshChar = seedLinked("Beefina", "Beef", 1)
  targetStranger("Beefina")
  local fresh = Console:GetWorkingSubject()
  assert_eq(fresh.characterId, freshChar.id, "a new target replaces the subject")
  assert_eq(fresh.needsKnighting, true, "Fresh Beef needs Knighting")
  assert_eq(frame.TargetLine:GetText(), "Current target: Beefina · Fresh Beef  needs Knighting",
    "the target line flags needs Knighting")
  assert_true(freshHuman ~= nil and freshChar ~= nil, "fixtures exist")

  -- Clearing the target clears a target-sourced subject.
  setTarget(nil)
  fireTargetChanged()
  assert_eq(Console:GetWorkingSubject(), nil, "clearing the target clears a target subject")

  -- An unknown target is a name-only subject (recognition pending).
  targetStranger("Stranger")
  local stranger = Console:GetWorkingSubject()
  assert_true(stranger ~= nil, "targeting a stranger sets a name-only subject")
  assert_eq(stranger.name, "Stranger", "the stranger's name is kept")
  assert_eq(stranger.characterId, nil, "unknown target has no character id yet")
  assert_eq(stranger.humanId, nil, "unknown target has no human id yet")
  assert_eq(stranger.rankId, nil, "unknown target has no rank")
  assert_eq(stranger.rankTitle, nil, "unknown target has no rank title")
  assert_eq(stranger.needsKnighting, false, "unknown humans are not flagged")
  assert_eq(stranger.source, "target", "stranger source is the target")
  assert_eq(frame.TargetLine:GetText(), "Current target: Stranger",
    "a name-only target line carries no rank")

  -- A named target replaces a row selection.
  Console:SelectCharacter(ch.id)
  assert_eq(Console:GetWorkingSubject().source, "selection", "SelectCharacter sources the subject")
  targetStranger("Beefina")
  assert_eq(Console:GetWorkingSubject().name, "Beefina",
    "a named target replaces a row selection")
  assert_eq(Console:GetWorkingSubject().source, "target", "the replacement is target-sourced")

  -- Clearing the target keeps a row selection.
  Console:SelectCharacter(ch.id)
  setTarget(nil)
  fireTargetChanged()
  local kept = Console:GetWorkingSubject()
  assert_true(kept ~= nil, "clearing the target keeps a row selection")
  assert_eq(kept.characterId, ch.id, "the selection persists")
  assert_eq(kept.source, "selection", "the persisted subject stays selection-sourced")

  -- SelectHuman resolves the human and a linked character.
  Console:SelectHuman(human.id)
  local byHuman = Console:GetWorkingSubject()
  assert_eq(byHuman.humanId, human.id, "SelectHuman carries the human id")
  assert_eq(byHuman.characterId, ch.id, "SelectHuman resolves the linked character")
  assert_eq(byHuman.name, "Chuckroast", "SelectHuman prefers the character name")
  assert_eq(byHuman.rankId, 3, "SelectHuman carries the rank")

  -- Selection validation.
  assert_eq(Console:SelectHuman("steve"), nil, "SelectHuman refuses a name string")
  assert_eq(Console:SelectCharacter(1.5), nil, "SelectCharacter refuses a non-integer")
  Console:SelectCharacter(ch.id)
  assert_eq(Console:SelectCharacter(nil), true, "SelectCharacter(nil) clears")
  assert_eq(Console:GetWorkingSubject(), nil, "cleared selection is no subject")

  -- Rank changes re-resolve on Refresh (the knight → elevate beat).
  local rawHuman, rawChar = seedLinked("Rawbeef", "Raw", 2)
  Console:SelectCharacter(rawChar.id)
  assert_eq(Console:GetWorkingSubject().rankId, 2, "subject starts at Cooked Beef")
  Store:SetRank(rawHuman.id, 3, 2000)
  Console:Refresh()
  assert_eq(Console:GetWorkingSubject().rankId, 3, "Refresh re-resolves the subject rank")
  assert_eq(Console:GetWorkingSubject().rankTitle, "Beef Knight", "Refresh re-resolves the title")
  assert_true(rawChar ~= nil, "fixture exists")
  assert_true(frame ~= nil, "frame fixture exists")
  popeOff()
end
runWorkingSubject()

--------------------------------------------------------------------------------
-- Show pickup: a target picked before the desk opened still counts when you
-- open it, and a target-sourced subject re-resolves from the live target on
-- Show (the target listener sleeps while the desk is hidden).
--------------------------------------------------------------------------------
local function runShowPickup()
  reset()
  local frame = Console:Init()
  popeOn()
  local human, ch = seedLinked("Chuckroast", "Chuck", 3)

  -- The target was picked while the desk was closed; no event fired.
  setTarget("chuckroast-Whitemane")
  assert_eq(Console:GetWorkingSubject(), nil, "no subject while the desk stays closed")
  Console:Show()
  local picked = Console:GetWorkingSubject()
  assert_true(picked ~= nil, "Show picks up the pre-existing target")
  assert_eq(picked.characterId, ch.id, "the pre-existing target resolves its ids")
  assert_eq(picked.humanId, human.id, "the pre-existing target resolves the human")
  assert_eq(picked.source, "target", "the picked-up subject is target-sourced")
  assert_eq(frame.TargetLine:GetText(), "Current target: Chuckroast · Beef Knight",
    "the target line paints the picked-up target")

  -- The target moved while the desk was hidden: Show re-resolves.
  local freshHuman, freshChar = seedLinked("Beefina", "Beef", 1)
  Console:Hide()
  setTarget("Beefina")
  Console:Show()
  local moved = Console:GetWorkingSubject()
  assert_true(moved ~= nil, "Show re-resolves a target-sourced subject")
  assert_eq(moved.characterId, freshChar.id, "the re-resolved subject is the live target")
  assert_eq(moved.source, "target", "the re-resolved subject stays target-sourced")

  -- The target was cleared while the desk was hidden: Show clears the subject.
  Console:Hide()
  setTarget(nil)
  Console:Show()
  assert_eq(Console:GetWorkingSubject(), nil,
    "a target cleared while hidden clears the target subject on Show")

  -- A row selection is never re-resolved away by Show.
  Console:SelectCharacter(ch.id)
  Console:Hide()
  setTarget("Beefina")
  Console:Show()
  local kept = Console:GetWorkingSubject()
  assert_true(kept ~= nil, "a row selection survives Show with another target live")
  assert_eq(kept.characterId, ch.id, "the kept subject is the selection")
  assert_eq(kept.source, "selection", "the kept subject stays selection-sourced")
  setTarget(nil)
  assert_true(freshHuman ~= nil and frame ~= nil, "fixtures exist")
  popeOff()
end
runShowPickup()

--------------------------------------------------------------------------------
-- Lane T: Console:Show owns the roster kick the retired shell did on its
-- OnShow — attach + refresh the library, and kick a server query only while
-- the cache is cold. The Presence desk reads Roster; the book never needed it.
--------------------------------------------------------------------------------
local function runRosterKick()
  reset()
  Console:Init()
  popeOn()

  local savedRoster = COB.Roster
  local savedNet = COB.Net
  local attaches = 0
  local refreshes = 0
  local requests = 0
  COB.Roster = {
    ready = false,
    AttachLibrary = function() attaches = attaches + 1 end,
    Refresh = function() refreshes = refreshes + 1 return true end,
    IsReady = function() return false end,
  }
  COB.Net = {
    RequestRoster = function(_, now, force)
      requests = requests + 1
      assert_eq(now, nil, "RequestRoster is kicked with no clock")
      assert_eq(force, true, "RequestRoster is forced past the client throttle")
    end,
  }
  Console:Show()
  assert_eq(attaches, 1, "Show attaches the roster library")
  assert_eq(refreshes, 1, "Show refreshes the roster")
  assert_eq(requests, 1, "Show kicks a roster request while the cache is cold")
  Console:Hide()

  -- A ready roster is not re-requested.
  attaches = 0
  refreshes = 0
  requests = 0
  COB.Roster.IsReady = function() return true end
  Console:Show()
  assert_eq(attaches, 1, "Show still attaches a ready roster library")
  assert_eq(refreshes, 1, "Show still refreshes a ready roster")
  assert_eq(requests, 0, "a ready roster is not re-requested")
  Console:Hide()

  -- No roster at all: the kick is a no-op and the desk still opens.
  COB.Roster = nil
  COB.Net = nil
  Console:Show()
  assert_eq(Console:IsShown(), true, "Show works with no roster to kick")
  Console:Hide()

  reset()
  COB.Roster = savedRoster
  COB.Net = savedNet
  popeOff()
end
runRosterKick()

--------------------------------------------------------------------------------
-- NPC guard: when the client can tell the target is not a player, the desk
-- treats it as no target — an NPC never becomes a subject or a Church record.
-- The harness has no UnitIsPlayer and the guard falls open.
--------------------------------------------------------------------------------
local function runNpcTargetGuard()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  local human, ch = seedLinked("Chuckroast", "Chuck", 3)
  targetStranger("Chuckroast")
  assert_true(Console:GetWorkingSubject() ~= nil, "a player target sets the subject")

  -- UnitIsPlayer exists and says no: an NPC is treated as no target.
  local savedUnitIsPlayer = UnitIsPlayer
  UnitIsPlayer = function(unit)
    if unit == "target" then return false end
    return nil
  end
  targetStranger("Defias Pillager")
  assert_eq(Console:GetWorkingSubject(), nil,
    "an NPC target clears the target subject and never becomes one")
  assert_eq(frame.TargetLine:GetText(), "Target a guildmate, then select them.",
    "an NPC target leaves the desk asking for a guildmate")

  -- The ensure path cannot grow Church records from an NPC target.
  popeOn()
  local knighted, knightErr = Console:KnightThisBeef()
  assert_eq(knighted, nil, "no subject after targeting an NPC")
  assert_eq(knightErr, "Target the Beef you are knighting", "the refusal stays human")
  assert_eq(#Store:Snapshot().characters, 1, "an NPC target writes no store rows")
  assert_eq(#Store:Snapshot().humans, 1, "an NPC target writes no humans")
  popeOff()

  -- API absent (the harness default): the guard falls open.
  UnitIsPlayer = savedUnitIsPlayer
  targetStranger("Chuckroast")
  local reopened = Console:GetWorkingSubject()
  assert_true(reopened ~= nil, "without UnitIsPlayer the target path falls open")
  assert_eq(reopened.characterId, ch.id, "the fall-open subject resolves its ids")
  assert_true(human ~= nil and frame ~= nil, "fixtures exist")
  popeOff()
end
runNpcTargetGuard()

--------------------------------------------------------------------------------
-- Ensure-on-verb: a named-but-unknown target is recognised by the verb itself.
--------------------------------------------------------------------------------
local function runEnsureOnVerb()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  -- No subject: human refusals, no Core writes.
  local ok, err = Console:KnightThisBeef()
  assert_eq(ok, nil, "KnightThisBeef without a subject refuses")
  assert_eq(err, "Target the Beef you are knighting", "knight refusal is human")
  ok, err = Console:DeclareVictor()
  assert_eq(ok, nil, "DeclareVictor without a subject refuses")
  assert_eq(err, "Target the victor", "victor refusal is human")
  ok, err = Console:CowardiceRecorded()
  assert_eq(ok, nil, "CowardiceRecorded without a subject refuses")
  assert_eq(err, "Target the fleeing fighter", "cowardice refusal is human")
  ok, err = Console:Sanction()
  assert_eq(ok, nil, "Sanction without both fighters refuses")
  assert_eq(err, "Set Fighter A and Fighter B first", "sanction refusal is human")
  assert_eq(#Store:Snapshot().characters, 0, "refusals create no store rows")

  -- Knight a named-but-unknown target: the verb is the recognition.
  Console:StartEvent()
  targetStranger("Stranger")
  local knighted = Console:KnightThisBeef()
  assert_true(knighted ~= nil, "KnightThisBeef recognises the targeted stranger")
  assert_eq(knighted.rankId, 3, "the stranger is a Beef Knight")
  local snap = Store:Snapshot()
  assert_eq(#snap.characters, 1, "the verb created one character")
  assert_eq(#snap.humans, 1, "the verb created one human")
  assert_eq(snap.characters[1].name, "Stranger", "the created character keeps the name")
  assert_eq(snap.characters[1].humanId, snap.humans[1].id, "the created rows are linked")
  local subject = Console:GetWorkingSubject()
  assert_eq(subject.characterId, snap.characters[1].id, "the subject now carries the character id")
  assert_eq(subject.humanId, snap.humans[1].id, "the subject now carries the human id")
  assert_eq(subject.rankId, 3, "the subject now carries the Knight rank")

  -- A second verb on the same target reuses the rows.
  local before = Store:Snapshot()
  targetStranger("stranger")
  local enq, enqErr = Console:Enqueue()
  assert_eq(enq, nil, "a Beef Knight is never Enqueued")
  assert_eq(enqErr, "already knighted", "Core names the refusal")
  local after = Store:Snapshot()
  assert_eq(#after.characters, #before.characters, "a second verb creates no new character")
  assert_eq(#after.humans, #before.humans, "a second verb creates no new human")

  -- Target class / level pass through when the client offers them.
  local savedUnitClass = UnitClass
  local savedUnitLevel = UnitLevel
  UnitClass = function(unit)
    if unit == "target" then return "Mage", "MAGE" end
    return nil
  end
  UnitLevel = function(unit)
    if unit == "target" then return 68 end
    return 0
  end
  targetStranger("Tendermage")
  local knightedMage = Console:KnightThisBeef()
  assert_true(knightedMage ~= nil, "the mage stranger is knighted")
  local mageSnap = Store:Snapshot()
  local mageChar
  for i = 1, #mageSnap.characters do
    if mageSnap.characters[i].name == "Tendermage" then mageChar = mageSnap.characters[i] end
  end
  assert_true(mageChar ~= nil, "the mage character exists")
  assert_eq(mageChar.class, "Mage", "ensure passes the target's class")
  assert_eq(mageChar.level, 68, "ensure passes the target's level")
  UnitClass = savedUnitClass
  UnitLevel = savedUnitLevel

  -- Fighter slots ensure too: target two strangers, assign, sanction.
  -- (reset does not touch the Pope predicate; it stays stubbed.)
  reset()
  Console:Init()
  Console:Show()
  Console:StartEvent()
  targetStranger("Chuckroast")
  assert_eq(Console:SetFighterA(), true, "Fighter A assigns the targeted stranger")
  targetStranger("Tendermage")
  assert_eq(Console:SetFighterB(), true, "Fighter B assigns the second stranger")
  local bout = Console:GetProposedBout()
  assert_true(bout.fighterA ~= nil, "pair slot A is filled")
  assert_true(bout.fighterB ~= nil, "pair slot B is filled")
  assert_true(bout.fighterA ~= bout.fighterB, "the pair is two different combatants")
  local ensured = Store:Snapshot()
  assert_eq(#ensured.characters, 2, "both strangers were recognised")
  local sanctioned = Console:Sanction()
  assert_true(sanctioned ~= nil, "Sanction uses the ensured pair")
  assert_eq(sanctioned.fighterA, bout.fighterA, "sanctioned A is the ensured stranger")
  assert_eq(sanctioned.fighterB, bout.fighterB, "sanctioned B is the ensured stranger")

  -- DeclareVictor on a name-only subject ensures and rules.
  targetStranger("chuckroast")
  local declared = Console:DeclareVictor()
  assert_true(declared ~= nil, "DeclareVictor uses the targeted fighter")
  assert_eq(declared.winnerId, bout.fighterA, "the targeted fighter is the victor")
  local victorSubject = Console:GetWorkingSubject()
  assert_eq(victorSubject.characterId, bout.fighterA, "the victor becomes the working subject")
  assert_eq(Store:GetCharacter(bout.fighterA).gora.wins, 1, "the win is recorded")

  -- SetFighter with no subject refuses without creating rows.
  reset()
  Console:Init()
  local noFighter, noFighterErr = Console:SetFighterA()
  assert_eq(noFighter, nil, "SetFighterA without a subject refuses")
  assert_true(type(noFighterErr) == "string", "SetFighterA refusal is a string")
  assert_eq(#Store:Snapshot().characters, 0, "a refused Fighter A creates no rows")

  assert_true(frame ~= nil, "frame fixture exists")
  popeOff()
end
runEnsureOnVerb()

--------------------------------------------------------------------------------
-- Ensure gate: the ensure step is a Core write, so a name-only subject cannot
-- be recognised by an unlisted client through SetFighterA / SetFighterB.
-- Subjects that already have ids stay ungated selection.
--------------------------------------------------------------------------------
local function runEnsureGate()
  reset()
  local frame = Console:Init()
  Console:Refresh()
  Console:Show()
  assert_eq(Console:IsShown(), false, "unlisted Show does not open the desk")

  -- Unlisted client: a name-only subject refuses the ensure and writes nothing.
  targetStranger("Stranger")
  local subject = Console:GetWorkingSubject()
  assert_true(subject ~= nil, "a congregation client can still target a stranger")
  assert_eq(subject.characterId, nil, "the stranger is name-only")
  local refuseA, refuseAErr = Console:SetFighterA()
  assert_eq(refuseA, nil, "SetFighterA refuses the ensure for an unlisted client")
  assert_eq(refuseAErr, "not a registered pope", "the ensure gate names the refusal")
  assert_eq(Console:GetProposedBout().fighterA, nil, "the refused ensure sets no pair slot A")
  local refuseB, refuseBErr = Console:SetFighterB()
  assert_eq(refuseB, nil, "SetFighterB refuses the ensure for an unlisted client")
  assert_eq(refuseBErr, "not a registered pope", "the SetFighterB ensure gate names the refusal")
  assert_eq(Console:GetProposedBout().fighterB, nil, "the refused ensure sets no pair slot B")
  assert_eq(#Store:Snapshot().characters, 0, "a refused ensure writes no store rows")
  assert_eq(#Store:Snapshot().humans, 0, "a refused ensure writes no humans")

  -- A subject that already has ids stays ungated selection.
  local human, ch = seedLinked("Chuckroast", "Chuck", 3)
  Console:SelectCharacter(ch.id)
  assert_eq(Console:SetFighterA(), true, "a subject with ids assigns without the Pope gate")
  assert_eq(Console:GetProposedBout().fighterA, ch.id, "pair slot A carries the selected id")
  assert_eq(#Store:Snapshot().characters, 1, "selecting a known subject writes nothing new")

  -- The listed Pope's ensure still recognises the stranger.
  popeOn()
  targetStranger("Tendermage")
  assert_eq(Console:SetFighterB(), true, "the listed Pope's ensure recognises the stranger")
  assert_true(Console:GetProposedBout().fighterB ~= nil, "pair slot B is filled")
  assert_eq(#Store:Snapshot().characters, 2, "the Pope's ensure wrote the stranger")
  assert_eq(#Store:Snapshot().humans, 2, "the Pope's ensure wrote the stranger's human")
  popeOff()
  assert_true(human ~= nil and frame ~= nil, "fixtures exist")
end
runEnsureGate()

--------------------------------------------------------------------------------
-- Phase copy and verb visibility: exact human strings, one section per phase.
--------------------------------------------------------------------------------
local function runPhaseCopy()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  assert_eq(type(Console.GetDeskState), "function", "GetDeskState is the desk view-model")
  assert_eq(Console:GetDeskState().gathering, "inactive", "quiet desk is inactive")
  assert_eq(Console:GetDeskState().tab, "gathering", "the desk opens on Gathering")
  assert_eq(frame.PhaseHint:GetText(), "The Church is not currently gathered.",
    "inactive status is human copy")
  assert_true(buttonVisible(frame, "Start the gathering"), "inactive shows Start the gathering")
  assert_eq(buttonVisible(frame, "Open a Knighting rite"), false, "inactive hides Open a Knighting rite")
  assert_eq(buttonVisible(frame, "Open a Gora rite"), false, "inactive hides Open a Gora rite")
  assert_eq(buttonVisible(frame, "Back to Gathering"), false, "inactive hides Back to Gathering")
  assert_eq(buttonVisible(frame, "Continue"), false, "inactive hides Continue")
  assert_eq(buttonVisible(frame, "End the gathering"), false, "inactive hides End the gathering")
  assert_eq(buttonVisible(frame, "KNIGHT THIS BEEF"), false, "inactive hides KNIGHT THIS BEEF")
  assert_eq(buttonVisible(frame, "SANCTION BEEF GORA"), false, "inactive hides SANCTION")
  assert_eq(buttonVisible(frame, "DECLARE VICTOR"), false, "inactive hides DECLARE VICTOR")
  assert_true(buttonVisible(frame, "Mark this moment"), "Mark this moment stays on the shell")
  assert_eq(buttonVisible(frame, "Post the Decree"), false, "inactive Gathering hides the Decree compose")
  assert_eq(frame.DecreeLine:IsShown(), false, "inactive Gathering hides the Decree line box")
  assert_eq(isVisible(frame.CongregationFavor), false, "inactive hides the congregation toggle")
  assert_true(buttonVisible(frame, "Gathering"), "shell shows the Gathering tab")
  assert_true(buttonVisible(frame, "Nights"), "shell shows the Nights tab")
  assert_true(buttonVisible(frame, "Chronicle"), "shell shows the Chronicle tab")
  assert_true(buttonVisible(frame, "Church"), "shell shows the Church tab")
  assertNoStateNames(frame, "inactive")

  Console:SetTab("decrees")
  assert_true(buttonVisible(frame, "Post the Decree"), "Decrees tab shows Post the Decree")
  assert_true(frame.DecreeLine:IsShown(), "Nights tab shows the Place box")
  assert_true(frame.DecreeFlavor:IsShown(), "Nights tab shows the Note box")
  Console:SetTab("gathering")

  Console:StartEvent()
  assert_eq(Console:GetDeskState().gathering, "active", "StartEvent is an active gathering")
  assert_eq(frame.PhaseHint:GetText(), "Open a rite.",
    "active gathering asks which rite to open")
  assert_eq(buttonVisible(frame, "Start the gathering"), false, "active hides Start the gathering")
  assert_true(buttonVisible(frame, "Open a Knighting rite"), "active shows Open a Knighting rite")
  assert_true(buttonVisible(frame, "Open a Gora rite"), "active shows Open a Gora rite")
  assert_true(buttonVisible(frame, "End the gathering"), "active shows End the gathering")
  assert_eq(buttonVisible(frame, "Back to Gathering"), false, "active hides Back to Gathering")
  assert_eq(buttonVisible(frame, "Continue"), false, "active hides Continue")
  assert_eq(buttonVisible(frame, "KNIGHT THIS BEEF"), false, "active overview hides KNIGHT THIS BEEF")
  assert_eq(buttonVisible(frame, "Fighter A"), false, "active overview hides Fighter A")
  assert_eq(buttonVisible(frame, "SANCTION BEEF GORA"), false, "active overview hides SANCTION")
  assert_eq(buttonVisible(frame, "DECLARE VICTOR"), false, "active hides DECLARE VICTOR")
  assert_eq(buttonVisible(frame, "Post the Decree"), false, "active Gathering hides the Decree compose")
  assert_true(buttonVisible(frame, "Mark this moment"), "active shows Mark this moment")
  assert_eq(isVisible(frame.CongregationFavor), false, "active hides the congregation toggle")
  assertNoStateNames(frame, "active gathering")

  Console:OpenRite("Knighting")
  assert_eq(Console:GetDeskState().rite, "knighting", "OpenRite Knighting is a rite mode")
  assert_eq(frame.PhaseHint:GetText(), "Knighting rite is live.",
    "Knighting rite names the live mode")
  assert_true(buttonVisible(frame, "Back to Gathering"), "Knighting rite shows Back to Gathering")
  assert_eq(buttonVisible(frame, "Open a Knighting rite"), false, "Knighting rite hides Open")
  assert_true(buttonVisible(frame, "End the gathering"), "Knighting rite still shows End the gathering")
  assert_true(buttonVisible(frame, "KNIGHT THIS BEEF"), "Knighting rite shows KNIGHT THIS BEEF")
  assert_eq(buttonVisible(frame, "SANCTION BEEF GORA"), false, "Knighting rite hides SANCTION")
  assert_eq(buttonVisible(frame, "Fighter A"), false, "Knighting rite hides Fighter A")
  assert_eq(buttonVisible(frame, "DECLARE VICTOR"), false, "Knighting rite hides DECLARE VICTOR")
  assert_eq(buttonVisible(frame, "Post the Decree"), false, "Knighting rite hides the Decree compose")
  assert_true(buttonVisible(frame, "Mark this moment"), "Knighting rite shows Mark this moment")
  assertNoStateNames(frame, "Knighting rite")
  Console:CloseRite()
  Console:Continue()

  local humanA, charA = seedLinked("Chuckroast", "Chuck", 3)
  local humanB, charB = seedLinked("Tendermage", "Tender", 3)
  Console:SelectCharacter(charA.id)
  Console:SetFighterA()
  Console:SelectCharacter(charB.id)
  Console:SetFighterB()
  Console:OpenRite("Gora")
  assert_eq(Console:GetDeskState().goraPhase, "setup", "an unsanctioned Gora is setup")
  assert_eq(frame.PhaseHint:GetText(), "Prepare the combatants.",
    "Gora setup names the setup phase")
  assert_true(buttonVisible(frame, "Back to Gathering"), "Gora setup shows Back to Gathering")
  assert_true(buttonVisible(frame, "End the gathering"), "Gora setup still shows End the gathering")
  assert_eq(buttonVisible(frame, "KNIGHT THIS BEEF"), false, "Gora setup hides KNIGHT THIS BEEF")
  assert_true(buttonVisible(frame, "Fighter A") or buttonVisible(frame, "Change"),
    "Gora setup shows fighter controls")
  assert_true(buttonVisible(frame, "SANCTION BEEF GORA"), "Gora setup shows SANCTION")
  assert_eq(buttonVisible(frame, "DECLARE VICTOR"), false, "Gora setup hides DECLARE VICTOR")
  assert_eq(isVisible(frame.CongregationFavor), false, "Gora setup hides the congregation toggle")
  assertNoStateNames(frame, "Gora setup")

  Console:Sanction()
  assert_eq(Console:GetDeskState().goraPhase, "sanctioned", "Sanction enters the live Gora")
  assert_eq(frame.PhaseHint:GetText(), "The Gora is sanctioned.",
    "sanctioned Gora names the live phase")
  assert_true(buttonVisible(frame, "DECLARE VICTOR"), "sanctioned Gora shows DECLARE VICTOR")
  assert_true(buttonVisible(frame, "COWARDICE RECORDED"), "sanctioned Gora shows COWARDICE RECORDED")
  assert_true(buttonVisible(frame, "VOID"), "sanctioned Gora shows VOID")
  assert_true(buttonVisible(frame, "FREE RULING"), "sanctioned Gora shows FREE RULING")
  assert_true(frame.FreeRulingText:IsShown(), "sanctioned Gora shows the ruling box")
  assert_true(isVisible(frame.CongregationFavor), "sanctioned Gora shows the congregation toggle")
  assert_eq(buttonVisible(frame, "SANCTION BEEF GORA"), false, "sanctioned Gora hides SANCTION")
  assertNoStateNames(frame, "Gora sanctioned")

  Console:CloseRite()
  assert_true(buttonVisible(frame, "DECLARE VICTOR"), "an unresolved Gora still shows DECLARE VICTOR")
  assert_true(isVisible(frame.CongregationFavor), "an unresolved Gora still shows the toggle")
  assert_eq(buttonVisible(frame, "Post the Decree"), false, "Gora still hides the Decree compose")
  assertNoStateNames(frame, "unresolved Gora")
  Console:EndEvent()

  Console:StartEvent()
  Runtime:OpenRite("Confession")
  Console:Refresh()
  assert_eq(frame.PhaseHint:GetText(), "Leave this mode.",
    "other rites still name leave")
  assert_true(buttonVisible(frame, "Back to Gathering"), "other rites show Back to Gathering")
  assert_true(buttonVisible(frame, "End the gathering"), "other rites still show End the gathering")
  assert_eq(buttonVisible(frame, "KNIGHT THIS BEEF"), false, "other rites hide KNIGHT THIS BEEF")
  assert_eq(buttonVisible(frame, "SANCTION BEEF GORA"), false, "other rites hide SANCTION")
  assert_eq(buttonVisible(frame, "DECLARE VICTOR"), false, "other rites hide DECLARE VICTOR")
  assertNoStateNames(frame, "other rite")
  Runtime:CloseRite()
  Runtime:EndEvent()
  Console:Refresh()
  assert_eq(frame.PhaseHint:GetText(), "The Church is not currently gathered.",
    "the desk is quiet again")

  assert_true(humanA ~= nil and humanB ~= nil and charA ~= nil and charB ~= nil, "fixtures exist")
  popeOff()
end
runPhaseCopy()

--------------------------------------------------------------------------------
-- Subject verbs: KNIGHT / Elevate visibility, pair line, SANCTION enable,
-- verdict plates on the subject, clickable pair names, the elevation beat.
--------------------------------------------------------------------------------
local function runSubjectVerbs()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  -- Elevate to Lord is a Knighting-rite (or Gora-complete) action, never Quiet,
  -- and never for the wrong rank.
  assert_eq(buttonVisible(frame, "Elevate to Lord"), false, "no subject hides Elevate to Lord")
  local knightHuman, knightChar = seedLinked("Chuckroast", "Chuck", 3)
  Console:SelectCharacter(knightChar.id)
  Console:Refresh()
  assert_eq(buttonVisible(frame, "Elevate to Lord"), false,
    "QUIET hides Elevate to Lord even for a Beef Knight subject")
  Console:StartEvent()
  Console:Refresh()
  assert_eq(buttonVisible(frame, "Elevate to Lord"), false,
    "the gathering overview hides Elevate to Lord")
  Console:OpenRite("Knighting")
  Console:Refresh()
  assert_true(buttonVisible(frame, "Elevate to Lord"),
    "a Beef Knight candidate shows Elevate to Lord in the Knighting rite")
  local cookedHuman, cookedChar = seedLinked("Tendermage", "Tender", 2)
  Console:SelectCharacter(cookedChar.id)
  Console:Refresh()
  assert_eq(buttonVisible(frame, "Elevate to Lord"), false, "a Cooked Beef subject hides Elevate to Lord")
  assert_true(knightHuman ~= nil and cookedHuman ~= nil, "fixtures exist")
  Console:CloseRite()
  Console:Continue()

  -- The elevation beat: a victorious Knight becomes the subject; Elevate shows.
  Console:EndEvent()
  Console:SelectCharacter(knightChar.id)
  Console:Refresh()
  assert_eq(buttonVisible(frame, "Elevate to Lord"), false,
    "back in QUIET the Knight subject hides Elevate again")
  Console:StartEvent()
  Console:SelectCharacter(knightChar.id)
  Console:SetFighterA()
  Console:SelectCharacter(cookedChar.id)
  Console:SetFighterB()
  Console:OpenRite("Gora")
  Console:Sanction()
  local declared = Console:DeclareVictor(knightChar.id)
  assert_true(declared ~= nil, "DECLARE VICTOR rules")
  local subject = Console:GetWorkingSubject()
  assert_eq(subject.characterId, knightChar.id, "the victor becomes the working subject")
  assert_eq(subject.rankId, 3, "the victor is a Beef Knight")
  assert_true(buttonVisible(frame, "Elevate to Lord"), "the elevation beat shows Elevate to Lord")
  local elevated = Console:ElevateToLord()
  assert_true(elevated ~= nil, "Elevate to Lord uses the working subject")
  assert_eq(elevated.rankId, 4, "the victor is elevated to Beef Lord")
  assert_eq(Store:GetHuman(knightHuman.id).rankId, 4, "the store records the elevation")
  Console:Refresh()
  assert_eq(buttonVisible(frame, "Elevate to Lord"), false, "a Beef Lord subject hides Elevate")
  -- Core refuses Lord+ (rank 5 / 6) as already elevated.
  local councilHuman = seedHuman("Cardinal", 6)
  local refused, refusedErr = Console:ElevateToLord(councilHuman.id)
  assert_eq(refused, nil, "Core refuses to elevate Council")
  assert_eq(refusedErr, "already elevated", "Core names the refusal")
  Console:EndEvent()

  -- Pair line and SANCTION enable. (reset keeps the Pope stub.)
  reset()
  Console:Init()
  Console:Show()
  Console:StartEvent()
  assert_eq(frame.PairLine:GetText(), "A: —  vs  B: —", "empty pair line shows two empty slots")
  assert_eq(frame.Sanction:IsEnabled(), false, "SANCTION is disabled until both fighters are set")
  local hA, cA = seedLinked("Chuckroast", "Chuck", 3)
  local hB, cB = seedLinked("Tendermage", "Tender", 1)
  Console:SelectCharacter(cA.id)
  Console:SetFighterA()
  assert_eq(frame.PairLine:GetText(), "A: Chuckroast  vs  B: —", "one fighter fills one slot")
  assert_eq(frame.Sanction:IsEnabled(), false, "SANCTION stays disabled with one fighter")
  Console:SelectCharacter(cB.id)
  Console:SetFighterB()
  assert_eq(frame.PairLine:GetText(), "A: Chuckroast  vs  B: Tendermage",
    "the pair line names both fighters")
  assert_eq(frame.Sanction:IsEnabled(), true, "SANCTION enables when both fighters are set")
  assert_true(hA ~= nil and hB ~= nil, "fixtures exist")

  -- Sanction in ASSEMBLY still offers the verdict plates. HUD appears at
  -- sanction; Open Rite is not required to ratify.
  Console:SelectCharacter(nil)
  Console:Sanction()
  assert_true(buttonVisible(frame, "DECLARE VICTOR"),
    "ASSEMBLY after Sanction shows DECLARE VICTOR")
  assert_true(buttonVisible(frame, "COWARDICE RECORDED"),
    "ASSEMBLY after Sanction shows COWARDICE RECORDED")
  assert_true(isVisible(frame.PairVictorA), "ASSEMBLY after Sanction shows pair name A")
  assert_eq(frame.TargetLine:GetText(), "Select the victor, then RECORD VERDICT.",
    "empty subject after Sanction names the verdict click")
  assert_true(Gora:GetSanctioned() ~= nil, "ASSEMBLY Sanction leaves the live pair")

  -- Pair names select the subject. DECLARE VICTOR is the commit.
  Console:OpenRite("Gora")
  Console:Sanction()
  assert_true(frame.PairVictorA ~= nil, "pair victor slot A exists")
  assert_eq(frame.PairVictorA:GetText(), "Chuckroast", "pair victor A names fighter A")
  assert_eq(frame.PairVictorB:GetText(), "Tendermage", "pair victor B names fighter B")
  assert_true(isVisible(frame.PairVictorA), "Gora live shows the clickable fighter names")
  stub.fire(frame.PairVictorB, "OnClick")
  assert_eq(Store:GetCharacter(cB.id).gora.wins, 0,
    "clicking a fighter name does not declare them victor")
  assert_true(Gora:GetSanctioned() ~= nil, "a name click leaves the live pair")
  assert_eq(Console:GetWorkingSubject().characterId, cB.id,
    "pair name selects the subject")
  stub.fire(findButton(frame, "DECLARE VICTOR"), "OnClick")
  assert_eq(Store:GetCharacter(cB.id).gora.wins, 1, "DECLARE VICTOR is the commit")
  assert_eq(Gora:GetSanctioned(), nil, "the ruling clears the live pair")

  -- COWARDICE RECORDED and VOID ride the working subject / the live pair.
  Console:Continue()
  Console:SelectCharacter(cA.id)
  Console:SetFighterA()
  Console:SelectCharacter(cB.id)
  Console:SetFighterB()
  Console:OpenRite("Gora")
  Console:Sanction()
  Console:SelectCharacter(cB.id)
  local coward = Console:CowardiceRecorded()
  assert_true(coward ~= nil, "COWARDICE RECORDED uses the working subject")
  assert_eq(coward.fleerId, cB.id, "the subject is the fleer")
  assert_eq(Store:GetCharacter(cA.id).gora.wins, 1, "the standing fighter takes the cowardice win")

  Console:Continue()
  Console:SelectCharacter(cA.id)
  Console:SetFighterA()
  Console:SelectCharacter(cB.id)
  Console:SetFighterB()
  Console:OpenRite("Gora")
  Console:Sanction()
  frame.FreeRulingText:SetText("interference from the balcony")
  stub.fire(findButton(frame, "FREE RULING"), "OnClick")
  local lastRuling = Store:GetCharacter(cA.id).gora.rulings[#Store:GetCharacter(cA.id).gora.rulings]
  assert_eq(lastRuling.ruling, "free", "the FREE RULING button reads the ruling box")
  Console:EndEvent()
  popeOff()
end
runSubjectVerbs()

--------------------------------------------------------------------------------
-- Secondary strips: Waiting to be knighted, Asked to fight, Presence.
--------------------------------------------------------------------------------
local function runStrips()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  -- Empty lines.
  assert_true(fontVisible(frame, "No one is waiting."), "the knighting strip shows its empty line")
  assert_true(fontVisible(frame, "No petitions."), "the petition strip shows its empty line")
  assert_true(findFont(frame, "Waiting to be knighted") ~= nil, "knighting strip header")
  assert_true(findFont(frame, "Asked to fight") ~= nil, "petition strip header")
  Console:SetTab("church")
  assert_true(fontVisible(frame, "No one on the roster yet."), "the church census shows its empty line")
  assert_true(findFont(frame, "By rank") ~= nil, "church census strip header")
  Console:SetTab("gathering")

  -- Waiting to be knighted: rows, per-row Skip, row click selects.
  Console:StartEvent()
  local first = seedHuman("Sirloin", 1)
  local second = seedHuman("Chuck", 2)
  Knighting:Enqueue(first.id)
  Knighting:Enqueue(second.id)
  Console:Refresh()
  assert_eq(fontVisible(frame, "No one is waiting."), false, "lined rows hide the empty line")
  local rowBtn = findButton(frame, "Sirloin")
  assert_true(rowBtn ~= nil, "the knighting strip lists who is waiting")
  assert_true(findButton(frame, "Chuck") ~= nil, "the second lined human is listed")
  stub.fire(rowBtn, "OnClick")
  local subject = Console:GetWorkingSubject()
  assert_true(subject ~= nil, "clicking a line row sets the working subject")
  assert_eq(subject.humanId, first.id, "the line row selects the human")
  assert_eq(subject.source, "selection", "a row click is a selection")
  local skipBtn = findButton(frame, "Skip")
  assert_true(skipBtn ~= nil, "each line row carries Skip")
  stub.fire(skipBtn, "OnClick")
  assert_eq(#Console:GetKnightingLine(), 1, "Skip removes the row from the line")
  assert_eq(Console:GetKnightingLine()[1].humanId, second.id, "the other human stays lined")

  -- Asked to fight: present petitioners, mute H2H token, per-row Dismiss.
  local humanA, charA = seedLinked("Chuckroast", "Chuck", 3)
  local humanB, charB = seedLinked("Tendermage", "Tender", 3)
  Store:RecordGoraResult(charA.id, { opponentId = charB.id, ruling = "victor", won = true }, 3000)
  Store:RecordGoraResult(charB.id, { opponentId = charA.id, ruling = "victor", won = false }, 3000)
  COB.Roster = {
    ready = true,
    complete = true,
    members = {
      chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
      tendermage = { name = "Tendermage", guildRankIndex = 5 },
    },
  }
  Gora:Petition(charA.id, charB.id)
  Console:Refresh()
  assert_eq(fontVisible(frame, "No petitions."), false, "petition rows hide the empty line")
  local petitionBtn = findButton(frame, "Chuckroast  names  Tendermage  1-0")
  assert_true(petitionBtn ~= nil, "a named petition paints the mute H2H token")
  stub.fire(petitionBtn, "OnClick")
  assert_eq(Console:GetWorkingSubject().characterId, charA.id,
    "clicking a petition row selects the petitioner")
  assert_eq(Console:GetProposedBout().fighterA, charA.id,
    "a petition row fills the next empty Fighter A slot")
  assert_eq(Console:GetProposedBout().fighterB, nil,
    "one petition click fills only one slot")
  assert_eq(Gora:GetSanctioned(), nil, "a petition click does not Sanction")
  local dismissBtn = findButton(frame, "Dismiss")
  assert_true(dismissBtn ~= nil, "each petition row carries Dismiss")
  stub.fire(dismissBtn, "OnClick")
  assert_eq(#Console:GetPetitions(), 0, "Dismiss retires the petition")
  assert_true(fontVisible(frame, "No petitions."), "an empty petition strip returns")

  -- Presence: a rank census, not a name dump. Store-seeded names while the
  -- roster is incomplete still count. Add to the line is a subject verb.
  COB.Roster = {
    ready = true,
    complete = false,
    members = {
      chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
      beefina = { name = "Beefina", guildRankIndex = 6 },
    },
  }
  local freshHuman, freshChar = seedLinked("Beefina", "Beef", 1)
  local councilHuman = seedLinked("Sirloin", "Sir", 6)
  Console:SetTab("church")
  Console:Refresh()
  local councilBtn = findButton(frame, "Beef Council  1")
  local knightBtn = findButton(frame, "Beef Knight  2")
  local freshBtn = findButton(frame, "Fresh Beef  1")
  assert_true(councilBtn ~= nil, "census names Beef Council")
  assert_true(knightBtn ~= nil, "census rolls store-seeded Knights into the count")
  assert_true(freshBtn ~= nil, "census names Fresh Beef")
  local leftoverCensus = frame.PresenceStrip and frame.PresenceStrip.rows[3]
  assert_eq(findButton(frame, "Beefina  Fresh Beef  needs Knighting"), nil,
    "presence no longer dumps names")
  assert_eq(findButton(frame, "+line"), nil, "+line left the name dump")
  Console:SelectCharacter(freshChar.id)
  local before = Console:GetWorkingSubject()
  stub.fire(freshBtn, "OnClick")
  assert_eq(Console:GetWorkingSubject().characterId, before.characterId,
    "clicking a census row does not change the working subject")
  Console:SetTab("gathering")
  Console:Refresh()
  local addBtn = findButton(frame, "Add to the line")
  assert_true(addBtn ~= nil, "a Fresh Beef subject offers Add to the line")
  stub.fire(addBtn, "OnClick")
  local line = Console:GetKnightingLine()
  local lined = false
  for i = 1, #line do
    if line[i].humanId == freshHuman.id then lined = true end
  end
  assert_true(lined, "Add to the line enqueues the working subject")

  -- Leftover strip rows reset to full alpha when the census shrinks.
  COB.Roster = {
    ready = true,
    complete = true,
    members = {
      chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
      beefina = { name = "Beefina", guildRankIndex = 6 },
    },
  }
  Console:SetTab("church")
  Console:Refresh()
  assert_true(leftoverCensus ~= nil, "the incomplete census had a third row")
  assert_eq(leftoverCensus:IsShown(), false, "a shrunk census hides the leftover row")
  assert_eq(leftoverCensus:GetAlpha(), 1, "the leftover row resets to full alpha")
  assert_true(councilHuman ~= nil, "council fixture exists")

  assert_true(humanA ~= nil and humanB ~= nil and charA ~= nil and charB ~= nil, "fixtures exist")
  Console:EndEvent()
  popeOff()
end
runStrips()

--------------------------------------------------------------------------------
-- Presence / petitions / line readouts keep their semantics.
--------------------------------------------------------------------------------
local function runReadouts()
  reset()
  Console:Init()

  -- Presence is display from Roster + Store. No Roster → empty.
  local empty = Console:GetPresence()
  assert_eq(#empty, 0, "Presence is empty without a roster")
  empty[1] = { name = "injected" }
  assert_eq(#Console:GetPresence(), 0, "GetPresence returns a copy")

  local human, char = seedLinked("Beefina", "Steve", 1)
  local lord = seedLinked("Chuckroast", "Chuck", 3)
  COB.Roster = {
    ready = true,
    complete = true,
    members = {
      beefina = { name = "Beefina", guildRankIndex = 6 },
      chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
      stranger = { name = "Stranger", guildRankIndex = 8 },
    },
  }
  local rows = Console:GetPresence()
  assert_eq(#rows, 3, "Presence lists who is here")
  assert_eq(rows[1].name, "Beefina", "Presence is sorted by name")
  assert_eq(rows[1].here, true, "roster members are here")
  assert_eq(rows[1].humanId, human.id, "Presence carries the store human id")
  assert_eq(rows[1].characterId, char.id, "Presence carries the store character id")
  assert_eq(rows[1].rankId, 1, "Church rank comes from Store")
  assert_eq(rows[1].rankTitle, "Fresh Beef", "rank title is displayed")
  assert_eq(rows[1].needsKnighting, true, "Fresh Beef needs Knighting")
  assert_eq(rows[1].guildRankIndex, 6, "guild rankIndex is display only")
  assert_eq(rows[2].name, "Chuckroast", "second presence row")
  assert_eq(rows[2].rankId, 3, "Knight rank comes from Store")
  assert_eq(rows[2].needsKnighting, false, "a Knight does not need Knighting")
  assert_eq(rows[3].name, "Stranger", "unlinked roster name is still here")
  assert_eq(rows[3].humanId, nil, "unlinked presence has no human id")
  assert_eq(rows[3].needsKnighting, false, "unknown humans are not flagged")
  assert_eq(rows[3].rankTitle, nil, "no guild rank name is unrecorded")
  rows[1].name = "mutated"
  assert_eq(Console:GetPresence()[1].name, "Beefina", "Presence rows are copies")
  assert_true(lord ~= nil and char ~= nil, "fixtures exist")

  local census = Console:GetPresenceCensus()
  assert_eq(#census, 3, "census has one row per displayed title plus Unrecorded")
  assert_eq(census[1].rankTitle, "Beef Knight", "census sorts high rank first")
  assert_eq(census[1].count, 1, "one Knight")
  assert_eq(census[2].rankTitle, "Fresh Beef", "Fresh follows Knights")
  assert_eq(census[2].count, 1, "one Fresh")
  assert_eq(census[3].rankTitle, "Unrecorded", "unmatched names are Unrecorded")
  assert_eq(census[3].count, 1, "Stranger is unrecorded")
  census[1].count = 99
  assert_eq(Console:GetPresenceCensus()[1].count, 1, "census rows are copies")

  -- A live guild title that matches a canon rank is display only.
  COB.Roster.members.stranger.guildRankName = "Beef Knight"
  local titled = Console:GetPresence()
  local stranger
  for i = 1, #titled do
    if titled[i].name == "Stranger" then stranger = titled[i] end
  end
  assert_true(stranger ~= nil, "Stranger is still present")
  assert_eq(stranger.rankId, 3, "matching guild title supplies display rank")
  assert_eq(stranger.rankTitle, "Beef Knight", "matching guild title supplies display title")
  assert_eq(stranger.humanId, nil, "guild title does not invent a store human")
  assert_eq(stranger.needsKnighting, false, "display-only Knights are not lined")
  local titledCensus = Console:GetPresenceCensus()
  assert_eq(#titledCensus, 2, "Stranger joins the Knight count")
  assert_eq(titledCensus[1].rankTitle, "Beef Knight", "Knights stay first")
  assert_eq(titledCensus[1].count, 2, "store Knight plus guild-titled stranger")

  COB.Roster.members.stranger.guildRankName = "Guild Master"
  local named = Console:GetPresence()
  local namedStranger
  for i = 1, #named do
    if named[i].name == "Stranger" then namedStranger = named[i] end
  end
  assert_eq(namedStranger.rankId, nil, "a non-canon guild title is not a Church id")
  assert_eq(namedStranger.rankTitle, "Guild Master", "presence keeps the live guild rank name")
  local namedCensus = Console:GetPresenceCensus()
  assert_eq(#namedCensus, 3, "non-canon guild titles get their own census row")
  assert_eq(namedCensus[3].rankTitle, "Guild Master", "live guild title follows the canon counts")
  assert_eq(namedCensus[3].count, 1, "one member holds that guild title")
  COB.Roster.members.stranger.guildRankName = nil

  -- An incomplete roster fail-opens Store names (here = false).
  COB.Roster = {
    ready = true,
    complete = false,
    members = {
      beefina = { name = "Beefina", guildRankIndex = 6 },
    },
  }
  local seeded = Console:GetPresence()
  assert_eq(#seeded, 2, "incomplete roster seeds Store names")
  local seededLord
  for i = 1, #seeded do
    if seeded[i].name == "Chuckroast" then seededLord = seeded[i] end
  end
  assert_true(seededLord ~= nil, "the store-seeded row is present")
  assert_eq(seededLord.here, false, "store-seeded rows are not here")
  assert_eq(seededLord.rankId, 3, "store-seeded rows keep the Church rank")

  -- GetKnightingLine fills names from Store and returns copies.
  popeOn()
  Console:StartEvent()
  local linedHuman = seedHuman("Sirloin", 1)
  Knighting:Enqueue(linedHuman.id)
  local lineRows = Console:GetKnightingLine()
  assert_eq(#lineRows, 1, "the line lists the enqueued human")
  assert_eq(lineRows[1].name, "Sirloin", "the line fills the name from Store")
  lineRows[1].name = "mutated"
  assert_eq(Console:GetKnightingLine()[1].name, "Sirloin", "line rows are copies")
  Console:EndEvent()
  popeOff()

  -- Petitions stay present-and-alive only.
  popeOn()
  Console:StartEvent()
  local pA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local pB = Store:CreateCharacter({ name = "Ghosted", class = "Mage", level = 68 })
  Gora:Petition(pA.id)
  Gora:Petition(pB.id)
  COB.Roster = {
    ready = true,
    complete = true,
    members = {
      chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    },
  }
  local present = Console:GetPetitions()
  assert_eq(#present, 1, "petitions show only present-and-alive characters")
  assert_eq(present[1].characterId, pA.id, "the present petitioner shows")
  assert_true(pB ~= nil, "fixture exists")
  Console:EndEvent()
  popeOff()
end
runReadouts()

--------------------------------------------------------------------------------
-- Favor: readout and congregation toggle render only while a Gora lives.
--------------------------------------------------------------------------------
local function runFavor()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  assert_eq(Console:GetCongregationFavorVisible(), true, "congregation favor defaults on")
  local split = Console:GetFavorSplit()
  assert_eq(split.a, 0, "favor split starts 0")
  assert_eq(split.b, 0, "favor split starts 0 B")
  assert_eq(Console:GetFavorCount(), 0, "favor count starts at 0")

  local humanA, charA = seedLinked("Chuckroast", "Chuck", 3)
  local humanB, charB = seedLinked("Tendermage", "Tender", 3)
  local humanC, charC = seedLinked("Ribeye", "Rib", 1)
  Console:StartEvent()

  -- ASSEMBLY: no favor chrome.
  assert_eq(isVisible(frame.CongregationFavor), false, "ASSEMBLY hides the congregation toggle")
  assert_eq(isVisible(frame.FavorSplit), false, "ASSEMBLY hides the favor split")

  Console:SelectCharacter(charA.id)
  Console:SetFighterA()
  Console:SelectCharacter(charB.id)
  Console:SetFighterB()
  Console:OpenRite("Gora")
  Console:Sanction()
  Gora:RecordFavor(charA.id, charA.id)
  Gora:RecordFavor(charB.id, charB.id)
  Gora:RecordFavor(charC.id, charA.id)
  Console:Refresh()

  assert_true(isVisible(frame.FavorSplit), "a live Gora shows the favor split")
  assert_eq(frame.FavorSplit:GetText(), "2 / 1", "the split paints the standing picks")
  assert_eq(frame.FavorCount:GetText(), "3", "the count paints the standing picks")
  assert_true(isVisible(frame.CongregationFavor), "a live Gora shows the congregation toggle")
  assert_eq(frame.CongregationFavor:GetChecked(), true, "the toggle starts checked")

  -- The toggle is a per-event memory, Pope-gated.
  assert_eq(Console:SetCongregationFavorVisible(false), true, "the Pope hides congregation favor")
  assert_eq(Console:GetCongregationFavorVisible(), false, "the toggle stores false")
  assert_eq(frame.CongregationFavor:GetChecked(), false, "the checkbox follows the toggle")
  local badFlag, badErr = Console:SetCongregationFavorVisible("yes")
  assert_eq(badFlag, nil, "a non-boolean toggle refuses")
  assert_true(type(badErr) == "string", "toggle validation returns an error string")
  assert_eq(Console:GetCongregationFavorVisible(), false, "a refused toggle leaves the flag")

  -- The checkbox click drives the setter; a non-Pope click reverts.
  frame.CongregationFavor:SetChecked(true)
  stub.fire(frame.CongregationFavor, "OnClick")
  assert_eq(Console:GetCongregationFavorVisible(), true, "a Pope click shows favor again")
  popeOff()
  frame.CongregationFavor:SetChecked(false)
  stub.fire(frame.CongregationFavor, "OnClick")
  assert_eq(Console:GetCongregationFavorVisible(), true, "a non-Pope click does not hide favor")
  assert_eq(frame.CongregationFavor:GetChecked(), true, "the checkbox reverts for a non-Pope")
  popeOn()

  -- The toggle is a per-event memory: it resets when a NEW event id appears,
  -- not when the same event quiets (Runtime keeps the event id in QUIET).
  assert_eq(Console:SetCongregationFavorVisible(false), true, "the Pope hides favor for this event")
  Console:CloseRite()
  Console:EndEvent()
  assert_eq(Console:GetCongregationFavorVisible(), false,
    "the same event id keeps the toggle after EndEvent")
  Console:StartEvent()
  assert_eq(Console:GetCongregationFavorVisible(), true, "a new gathering resets the toggle")

  -- CONSEQUENCE of a Gora keeps the favor readout; a Knighting rite hides it.
  Console:SelectCharacter(charA.id)
  Console:SetFighterA()
  Console:SelectCharacter(charB.id)
  Console:SetFighterB()
  Console:OpenRite("Gora")
  Console:Sanction()
  Console:CloseRite()
  assert_true(isVisible(frame.FavorSplit), "Gora CONSEQUENCE keeps the favor readout")
  Console:Continue()
  Console:OpenRite("Knighting")
  assert_eq(isVisible(frame.FavorSplit), false, "a Knighting rite hides the favor readout")
  assert_eq(isVisible(frame.CongregationFavor), false, "a Knighting rite hides the toggle")
  Console:CloseRite()
  Console:EndEvent()

  assert_true(humanA ~= nil and humanB ~= nil and charA ~= nil and charB ~= nil, "fixtures exist")
  assert_true(humanC ~= nil and charC ~= nil, "third picker fixture exists")
  popeOff()
end
runFavor()

--------------------------------------------------------------------------------
-- GetProposedBout, OpenRite fallbacks, Dismiss semantics.
--------------------------------------------------------------------------------
local function runBoutAndFallbacks()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  -- GetProposedBout: pair slots only. No stipulation field.
  local empty = Console:GetProposedBout()
  assert_eq(empty.fighterA, nil, "empty bout has no fighterA")
  assert_eq(empty.fighterB, nil, "empty bout has no fighterB")
  assert_eq(empty.stipulation, nil, "the desk never carries a stipulation")
  local humanA, charA = seedLinked("Chuckroast", "Chuck", 3)
  local humanB, charB = seedLinked("Tendermage", "Tender", 3)
  Console:SelectCharacter(charA.id)
  Console:SetFighterA()
  Console:SelectCharacter(charB.id)
  Console:SetFighterB()
  local bout = Console:GetProposedBout()
  assert_eq(bout.fighterA, charA.id, "bout carries fighter A")
  assert_eq(bout.fighterB, charB.id, "bout carries fighter B")
  assert_eq(bout.stipulation, nil, "a proposed bout has no stipulation")
  assert_eq(rawget(frame, "Stipulation"), nil, "the desk has no stipulation box")
  assert_eq(findFont(frame, "Stipulation"), nil, "the desk has no Stipulation label")

  -- A successful StartEvent clears the pair but keeps the working subject.
  Console:StartEvent()
  assert_eq(Console:GetProposedBout().fighterA, nil, "StartEvent clears fighter A")
  assert_eq(Console:GetProposedBout().fighterB, nil, "StartEvent clears fighter B")
  assert_true(Console:GetWorkingSubject() ~= nil, "StartEvent keeps the working subject")

  -- OpenRite Knighting: no subject falls back to the line head.
  Console:SelectCharacter(nil)
  local lineHead = seedHuman("Sirloin", 1)
  Knighting:Enqueue(lineHead.id)
  local openedLine = Console:OpenRite("Knighting")
  assert_eq(openedLine.subjects.candidate, lineHead.id,
    "OpenRite Knighting falls back to the line head")
  Console:CloseRite()
  Console:Continue()
  Console:SelectHuman(humanA.id)
  local openedSubject = Console:OpenRite("Knighting")
  assert_eq(openedSubject.subjects.candidate, humanA.id,
    "the working subject wins over the line head")
  Console:CloseRite()
  Console:Continue()

  -- OpenRite Gora: the pair slots, then the live sanctioned pair — never the
  -- leftover last pair.
  Console:SelectCharacter(charA.id)
  Console:SetFighterA()
  Console:SelectCharacter(charB.id)
  Console:SetFighterB()
  local openedPair = Console:OpenRite("Gora")
  assert_true(openedPair.subjects.fighters ~= nil, "OpenRite Gora names the pair")
  assert_eq(openedPair.subjects.fighters[1], charA.id, "OpenRite Gora fighter A")
  assert_eq(openedPair.subjects.fighters[2], charB.id, "OpenRite Gora fighter B")
  Console:CloseRite()
  Console:Continue()

  -- No pair, no live sanction: no fighters on the rite.
  Console.selectedFighterA = nil
  Console.selectedFighterB = nil
  local openedEmpty = Console:OpenRite("Gora")
  assert_eq(openedEmpty.subjects.fighters, nil, "no pair and no sanction opens without fighters")
  Console:CloseRite()
  Console:Continue()

  -- Live-sanctioned fallback.
  Console:Sanction(charA.id, charB.id)
  local openedLive = Console:OpenRite("Gora")
  assert_true(openedLive.subjects.fighters ~= nil, "a live sanction fills the rite pair")
  assert_eq(openedLive.subjects.fighters[1], charA.id, "live fallback fighter A")
  Console:CloseRite()
  Console:Continue()

  -- A finished bout (last sanctioned) is not the next rite's fallback.
  Console:Sanction(charA.id, charB.id)
  Console:DeclareVictor(charA.id)
  assert_true(Gora:GetLastSanctioned() ~= nil, "the last pair is remembered by Core")
  Console:ReturnToGathering()
  local openedLast = Console:OpenRite("Gora")
  assert_eq(openedLast.subjects.fighters, nil, "OpenRite Gora does not fall back to the last pair")
  Console:CloseRite()
  Console:Continue()
  Console:EndEvent()

  -- A successful EndEvent clears the pair and the working subject...
  Console:StartEvent()
  Console:SelectCharacter(charA.id)
  Console:SetFighterA()
  Console:SelectCharacter(charB.id)
  Console:SetFighterB()
  local endedClean = Console:EndEvent()
  assert_true(endedClean ~= nil, "EndEvent runs from the assembly")
  assert_eq(Console:GetWorkingSubject(), nil, "EndEvent clears the working subject")
  assert_eq(Console:GetProposedBout().fighterA, nil, "EndEvent clears fighter A")
  assert_eq(Console:GetProposedBout().fighterB, nil, "EndEvent clears fighter B")

  -- ...and a still-selected live target reappears as the subject afterwards.
  Console:StartEvent()
  targetStranger("Chuckroast")
  assert_true(Console:GetWorkingSubject() ~= nil, "a mid-event target sets the subject")
  local endedTarget = Console:EndEvent()
  assert_true(endedTarget ~= nil, "EndEvent runs with a target live")
  local reSubject = Console:GetWorkingSubject()
  assert_true(reSubject ~= nil, "a still-selected target reappears after EndEvent")
  assert_eq(reSubject and reSubject.name, "Chuckroast", "the re-resolved subject is the live target")
  assert_eq(reSubject and reSubject.source, "target", "the re-resolved subject stays target-sourced")
  setTarget(nil)

  -- Dismiss: reaches Gora only, cleans the subject and the pair on success.
  -- (reset keeps the Pope stub.)
  reset()
  Console:Init()
  Console:Show()
  Console:StartEvent()
  COB.Roster = {
    ready = true,
    complete = true,
    members = {
      chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
      tendermage = { name = "Tendermage", guildRankIndex = 5 },
    },
  }
  local dA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local dB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
  Gora:Petition(dA.id)
  Gora:Petition(dB.id)

  -- No Confession module: Dismiss is Gora-only.
  assert_eq(COB.Confession, nil, "no confession inbox is loaded")
  local src = readSource()
  assert_eq(src:find("Confession", 1, true), nil, "the console never references Confession")

  -- Failed Dismiss keeps the subject and the pair.
  Console:SelectCharacter(dA.id)
  Console:SetFighterA()
  Console:SelectCharacter(dB.id)
  Console:SetFighterB()
  local stranger = Store:CreateCharacter({ name = "Stranger", class = "Priest", level = 60 })
  local dismissFail, dismissFailErr = Console:Dismiss(stranger.id)
  assert_eq(dismissFail, nil, "dismissing a non-petitioner refuses")
  assert_eq(dismissFailErr, "No petition from that fighter", "a refused Dismiss names the refusal")
  assert_true(Console:GetWorkingSubject() ~= nil, "a failed Dismiss keeps the subject")
  assert_eq(Console:GetProposedBout().fighterA, dA.id, "a failed Dismiss keeps fighter A")
  assert_eq(Console:GetProposedBout().fighterB, dB.id, "a failed Dismiss keeps fighter B")

  -- Successful Dismiss of the working subject clears the subject.
  Console:SelectCharacter(dA.id)
  assert_eq(Console:Dismiss(), true, "Dismiss uses the working subject")
  assert_eq(Console:GetWorkingSubject(), nil, "dismissing the subject clears the subject")
  assert_eq(Console:GetProposedBout().fighterA, nil, "dismissing fighter A clears the pair")
  assert_eq(Console:GetProposedBout().fighterB, nil, "the pair clears together")

  -- A failed Dismiss by explicit id leaves the current subject alone; a
  -- successful Dismiss of the selected character clears it.
  Console:SelectCharacter(dB.id)
  local dismissGone, dismissGoneErr = Console:Dismiss(dA.id)
  assert_eq(dismissGone, nil, "the dismissed petitioner is already gone")
  assert_eq(dismissGoneErr, "No petition from that fighter", "a refused Dismiss returns an error string")
  assert_true(Console:GetWorkingSubject() ~= nil, "a failed Dismiss keeps the current subject")
  assert_eq(Console:Dismiss(dB.id), true, "Dismiss by explicit id works")
  assert_eq(Console:GetWorkingSubject(), nil, "dismissing the selected character clears the subject")

  assert_true(humanA ~= nil and humanB ~= nil and charA ~= nil and charB ~= nil, "fixtures exist")
  assert_true(frame ~= nil, "frame fixture exists")
  Console:EndEvent()
  popeOff()
end
runBoutAndFallbacks()

--------------------------------------------------------------------------------
-- Chrome: stock templates, the two iron plates, the title seal, charcoal
-- ground, and the widgets that left with the cold tools.
--------------------------------------------------------------------------------
local function runChrome()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  -- Stock template census.
  assert_eq(countType(frame, "EditBox"), 4,
    "stock EditBoxes: Place, Note, Discord title, and free ruling")
  assert_eq(frame.DecreeLine._template, "InputBoxTemplate", "Decree line is InputBoxTemplate")
  assert_eq(frame.DecreeFlavor._template, "InputBoxTemplate", "Decree flavor is InputBoxTemplate")
  assert_eq(rawget(frame, "Stipulation"), nil, "the desk has no stipulation box")
  assert_eq(frame.FreeRulingText._template, "InputBoxTemplate", "ruling box is InputBoxTemplate")
  assert_eq(frame.DecreeLine._autoFocus, false, "Decree line does not steal focus")
  assert_eq(frame.CongregationFavor._type, "CheckButton", "congregation toggle is a CheckButton")
  assert_eq(frame.CongregationFavor._template, "UICheckButtonTemplate",
    "congregation toggle uses UICheckButtonTemplate")
  local startBtn = findButton(frame, "Start the gathering")
  assert_eq(startBtn._template, "UIPanelButtonTemplate", "Start the gathering is a stock button")
  assert_true(startBtn:GetHeight() >= 28, "phase verbs are large targets")
  assert_true(startBtn:GetWidth() >= 160, "phase verbs are wide enough")

  -- The only ornaments: the title-bar seal and the two iron plates.
  local sealPath = Theme:Texture("seal_papal")
  local plateUp = Theme:Texture("plate_verb")
  local plateHover = Theme:Texture("plate_verb_hover")
  local plateDown = Theme:Texture("plate_verb_pressed")
  assert_true(type(sealPath) == "string" and sealPath ~= "", "Theme resolves seal_papal")
  assert_true(frame.TitleSeal ~= nil, "title-bar seal slot exists")
  assert_eq(frame.TitleSeal._type, "Texture", "title-bar seal is a Texture")
  assert_eq(frame.TitleSeal._cobTexture, sealPath, "title-bar seal uses Theme:Texture seal_papal")
  assert_eq(frame.TitleSeal:GetWidth(), 20, "title-bar seal is about 20px wide")
  assert_eq(frame.TitleSeal:GetHeight(), 20, "title-bar seal is about 20px tall")

  local knightPlate = findButton(frame, "KNIGHT THIS BEEF")
  local sanctionPlate = findButton(frame, "SANCTION BEEF GORA")
  assert_eq(knightPlate._template, "UIPanelButtonTemplate", "KNIGHT stays a panel button")
  assert_eq(sanctionPlate._template, "UIPanelButtonTemplate", "SANCTION stays a panel button")
  assert_eq(knightPlate._cobNormalTexture, plateUp, "KNIGHT normal is Theme plate_verb")
  assert_eq(knightPlate._cobHighlightTexture, plateHover, "KNIGHT highlight is Theme plate_verb_hover")
  assert_eq(knightPlate._cobPushedTexture, plateDown, "KNIGHT pushed is Theme plate_verb_pressed")
  assert_eq(sanctionPlate._cobNormalTexture, plateUp, "SANCTION normal is Theme plate_verb")
  assert_eq(sanctionPlate._cobHighlightTexture, plateHover, "SANCTION highlight is Theme plate_verb_hover")
  assert_eq(sanctionPlate._cobPushedTexture, plateDown, "SANCTION pushed is Theme plate_verb_pressed")

  local plated = {}
  walk(frame, function(widget)
    if widget._type == "Button" and widget._cobNormalTexture then
      plated[#plated + 1] = widget:GetText()
    end
  end)
  table.sort(plated)
  assert_eq(#plated, 2, "exactly two iron plates on the desk")
  assert_eq(plated[1], "KNIGHT THIS BEEF", "plate one is KNIGHT THIS BEEF")
  assert_eq(plated[2], "SANCTION BEEF GORA", "plate two is SANCTION BEEF GORA")
  assert_eq(findButton(frame, "Elevate to Lord")._cobNormalTexture, nil,
    "Elevate to Lord stays unplated furniture")
  assert_eq(findButton(frame, "Fighter A")._cobNormalTexture, nil,
    "Fighter A stays unplated furniture")

  -- Charcoal desk ground via Theme.
  local charcoalR, charcoalG, charcoalB = Theme:Color("charcoal")
  assert_eq(type(charcoalR), "number", "Theme resolves charcoal")
  local charcoalHits = 0
  walk(frame, function(widget)
    if widget._type == "Texture" and widget._cobColor and widget._cobColor.role == "charcoal" then
      charcoalHits = charcoalHits + 1
      assert_eq(widget._cobColor.r, charcoalR, "desk ground r is Theme charcoal")
      assert_eq(widget._cobColor.g, charcoalG, "desk ground g is Theme charcoal")
      assert_eq(widget._cobColor.b, charcoalB, "desk ground b is Theme charcoal")
    end
  end)
  assert_true(charcoalHits >= 1, "the desk ground is Theme charcoal")

  -- The cold tools left no widgets behind.
  assert_eq(findButton(frame, "Open Confession"), nil, "Confession rite stays Core-only")
  assert_eq(findButton(frame, "Open Proclamation"), nil, "Proclamation rite stays Core-only")
  assert_eq(findButton(frame, "Records & archive"), nil, "no records fold")
  assert_eq(findButton(frame, "Hide records"), nil, "no records fold toggle")
  assert_eq(findButton(frame, "Recommend"), nil, "no Recommend furniture")
  assert_eq(findButton(frame, "Call Forward"), nil, "no Call Forward")
  assert_eq(findButton(frame, "GRANT HONORIFIC"), nil, "no Grant Honorific")
  assert_eq(findButton(frame, "EXPORT ARCHIVE"), nil, "no Export Archive")
  assert_eq(findButton(frame, "IMPORT ARCHIVE"), nil, "no Import Archive")
  assert_eq(findButton(frame, "CANONIZE"), nil, "no Canonize")
  assert_eq(findButton(frame, "FLAG UPSET"), nil, "no Flag Upset")
  assert_eq(findButton(frame, "Begin Recognition"), nil, "no Begin Recognition")
  assert_eq(findButton(frame, "Complete Recognition"), nil, "no Complete Recognition")
  assert_eq(findButton(frame, "Cancel Recognition"), nil, "no Cancel Recognition")
  assert_eq(findFont(frame, "Notebook"), nil, "no Notebook")
  assert_eq(findFont(frame, "Ceremony log"), nil, "no ceremony log desk")
  assert_eq(findFont(frame, "Confession"), nil, "no confession inbox")
  assert_eq(findFont(frame, "ARCHIVE"), nil, "no archive box")
  assert_eq(findFont(frame, "CANONIZE"), nil, "no canonize box")
  assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
  assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
  assert_eq(findButton(frame, "Calendar"), nil, "no calendar chrome")
  assert_eq(findFont(frame, "Eternal Grazing."), nil, "UI never tells jokes")

  -- Source-level pins: no theater, no wire, no guild-rank writes, no state
  -- names in user copy, stock-only construction.
  local src = readSource()
  assert_eq(src:find("SendChatMessage(", 1, true), nil, "no SendChatMessage call")
  assert_eq(src:find("SendAddonMessage(", 1, true), nil, "the desk never touches the wire")
  assert_eq(src:find("GuildPromote(", 1, true), nil, "no GuildPromote call")
  assert_eq(src:find("SetGuildRank(", 1, true), nil, "no SetGuildRank call")
  assert_eq(src:find("COB.Toasts", 1, true), nil, "the desk never calls Toasts")
  assert_eq(src:find("COB.Sound", 1, true), nil, "the desk never calls Sound")
  assert_eq(src:find("COB.FighterCard", 1, true), nil, "the desk never calls FighterCard")
  assert_eq(src:find("COB.Markers", 1, true), nil, "the desk never calls Markers")
  assert_eq(src:find("COB.Hud", 1, true), nil, "the desk never calls the Fight HUD")
  assert_eq(src:find("DecreeBanner", 1, true), nil, "the desk never calls the Decree banner")
  assert_eq(src:find("COB.Archive", 1, true), nil, "the desk never calls Archive")
  assert_eq(src:find("COB.Recognition", 1, true), nil, "the desk never calls Recognition")
  assert_eq(src:find("Stipulation", 1, true), nil, "the desk has no stipulation chrome")
  assert_eq(src:find("Parchment", 1, true), nil, "the desk stays stock, not parchment")
  assert_eq(src:find("PanelTabButtonTemplate", 1, true), nil, "the desk is not collapsed into tabs")
  assert_true(src:find('Theme:Color("charcoal")', 1, true) ~= nil
      or src:find('themeColor("charcoal")', 1, true) ~= nil,
    "the desk ground routes through Theme charcoal")
  assert_true(src:find('PLAYER_TARGET_CHANGED', 1, true) ~= nil,
    "the desk listens for target changes")
  assert_eq(src:find("UIDropDownMenu_", 1, true), nil, "Nights compose does not call dropdown menu APIs")
  assert_eq(src:find("EasyMenu", 1, true), nil, "Nights compose does not use EasyMenu")
  popeOff()
end
runChrome()

--------------------------------------------------------------------------------
-- Nights tab compose: stock pickers instead of typed kind / weekday / date.
--------------------------------------------------------------------------------
local function runNightsCompose()
  reset()
  local savedNights = rawget(COB, "Nights")
  if not COB.Nights then
    dofile("addon/ChurchOfBeef/Core/Nights.lua")
  end
  assert_eq(COB.Nights:ResetForTests(), true, "Nights ResetForTests for compose")
  local frame = Console:Init()
  popeOn()
  Console:Show()
  Console:SetTab("decrees")

  assert_true(frame.ChurchKindGathering:IsShown(), "Nights shows Gathering choice")
  assert_true(frame.ChurchKindKnighting:IsShown(), "Nights shows Knighting choice")
  assert_true(frame.ChurchKindGora:IsShown(), "Nights shows Gora choice")
  assert_true(frame.WeekdayPick:IsShown(), "Nights shows a weekday stepper")
  assert_true(frame.TimeHour:IsShown(), "Nights shows an hour stepper")
  assert_true(frame.DatePick:IsShown(), "Nights shows a date stepper")
  assert_true(frame.StubTitle:IsShown(), "Nights shows a Discord title box")
  assert_true(buttonVisible(frame, "Post weekly night"), "Nights shows Post weekly night")
  assert_true(buttonVisible(frame, "Post Discord notice"), "Nights shows Post Discord notice")
  assert_true(fontVisible(frame, "Church night"), "Nights names the Church compose")
  assert_true(fontVisible(frame, "Discord notice"), "Nights names the Discord compose")
  assert_true(fontVisible(frame, "Place"), "Nights labels Place")
  assert_true(fontVisible(frame, "Note"), "Nights labels Note")
  assert_true(fontVisible(frame, "Title"), "Nights labels Title")
  assert_eq(fontVisible(frame, "Weekday 1–7"), false, "typed weekday codes left the desk")
  assert_eq(fontVisible(frame, "Date YYYY-MM-DD"), false, "typed date codes left the desk")
  assert_eq(rawget(frame, "SeriesKind"), nil, "kind is no longer an EditBox")
  assert_eq(rawget(frame, "StubDate"), nil, "date is no longer an EditBox")

  local dayBefore = frame.WeekdayPick:GetText()
  stub.fire(frame.WeekdayNext, "OnClick")
  assert_true(frame.WeekdayPick:GetText() ~= dayBefore, "weekday stepper cycles the day name")

  stub.fire(frame.TimeHour, "OnClick")
  assert_eq(frame.TimeHour:GetText(), "8", "hour stepper advances 7 to 8")

  stub.fire(frame.TimeAmPm, "OnClick")
  assert_eq(frame.TimeAmPm:GetText(), "AM", "AM/PM toggles")

  local whenBefore = frame.DatePick:GetText()
  stub.fire(frame.DateNext, "OnClick")
  assert_true(frame.DatePick:GetText() ~= whenBefore, "date stepper advances a day")

  stub.fire(frame.ChurchKindKnighting, "OnClick")
  stub.fire(frame.StubKindPvp, "OnClick")
  frame.DecreeLine:SetText("Goldshire Inn")
  frame.DecreeFlavor:SetText("bring a fork")
  frame.StubTitle:SetText("Kara Thursday")

  local posted = Console:PostSeries()
  assert_true(posted ~= nil, "Post weekly night reads the pickers")
  assert_eq(posted.kind, "knighting", "kind choice posts Knighting")
  assert_eq(posted.place, "Goldshire Inn", "Place box is the series place")
  assert_eq(posted.flavor, "bring a fork", "Note box is the series flavor")
  assert_eq(posted.timeLine, "8:00 AM", "time steppers post a clock line")
  assert_true(type(posted.weekday) == "number" and posted.weekday >= 1 and posted.weekday <= 7,
    "weekday stepper posts 1–7")

  local notice = Console:PostStub()
  assert_true(notice ~= nil, "Post Discord notice reads the pickers")
  assert_eq(notice.kind, "pvp", "stub kind choice posts PvP")
  assert_eq(notice.title, "Kara Thursday", "Title box is the stub title")
  assert_eq(notice.place, "Goldshire Inn", "Place box is the stub place")
  assert_eq(notice.timeLine, "8:00 AM", "shared clock posts on the stub")
  assert_true(type(notice.date) == "string" and notice.date:match("^%d%d%d%d%-%d%d%-%d%d$") ~= nil,
    "date stepper posts YYYY-MM-DD")

  assert_eq(COB.Nights:ResetForTests(), true, "Nights compose clears the board")
  COB.Nights = savedNights
  popeOff()
end
runNightsCompose()

--------------------------------------------------------------------------------
-- Desk chrome pins kept from the old desk: ESC in a stock edit box only
-- clears focus (never hides the desk), the wheel scrolls 36px with a clamp,
-- and wireConsoleOnHide never replaces an existing OnHide.
--------------------------------------------------------------------------------
local function runDeskChrome()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  -- stockEdit OnEscapePressed: ClearFocus, never Hide the desk.
  assert_true(frame.DecreeLine:GetScript("OnEscapePressed") ~= nil,
    "DecreeLine wires OnEscapePressed")
  assert_true(frame.DecreeFlavor:GetScript("OnEscapePressed") ~= nil,
    "DecreeFlavor wires OnEscapePressed")
  assert_true(frame.FreeRulingText:GetScript("OnEscapePressed") ~= nil,
    "the ruling box wires OnEscapePressed")
  assert_true(frame.StubTitle:GetScript("OnEscapePressed") ~= nil,
    "the Discord title box wires OnEscapePressed")
  frame.DecreeLine:SetFocus()
  assert_eq(frame.DecreeLine:HasFocus(), true, "the Decree line can take focus")
  stub.fire(frame.DecreeLine, "OnEscapePressed")
  assert_eq(frame.DecreeLine:HasFocus(), false, "ESC in the box clears focus")
  assert_eq(Console:IsShown(), true, "ESC in the box does not hide the desk")

  -- DeskScroll OnMouseWheel: 36px step, clamped to the scroll range.
  assert_true(frame.DeskScroll:GetScript("OnMouseWheel") ~= nil, "DeskScroll wires OnMouseWheel")
  frame.DeskScroll.GetVerticalScrollRange = function() return 200 end
  frame.DeskScroll:SetVerticalScroll(100)
  stub.fire(frame.DeskScroll, "OnMouseWheel", 1)
  assert_eq(frame.DeskScroll:GetVerticalScroll(), 64, "wheel up scrolls a 36px step")
  stub.fire(frame.DeskScroll, "OnMouseWheel", -1)
  assert_eq(frame.DeskScroll:GetVerticalScroll(), 100, "wheel down scrolls a 36px step back")
  frame.DeskScroll:SetVerticalScroll(10)
  stub.fire(frame.DeskScroll, "OnMouseWheel", 1)
  assert_eq(frame.DeskScroll:GetVerticalScroll(), 0, "the wheel clamps at the top")
  frame.DeskScroll:SetVerticalScroll(190)
  stub.fire(frame.DeskScroll, "OnMouseWheel", -1)
  assert_eq(frame.DeskScroll:GetVerticalScroll(), 200, "the wheel clamps at the bottom")

  -- wireConsoleOnHide never replaces an existing OnHide; Hide remounts a
  -- missing one with the desk's own handler.
  local customOnHide = function() end
  frame:SetScript("OnHide", customOnHide)
  Console:Hide()
  assert_eq(frame:GetScript("OnHide"), customOnHide, "Hide never replaces an existing OnHide")
  Console:Show()
  Console:Refresh()
  assert_eq(frame:GetScript("OnHide"), customOnHide, "Refresh never replaces an existing OnHide")
  frame:SetScript("OnHide", nil)
  Console:Hide()
  local remounted = frame:GetScript("OnHide")
  assert_true(remounted ~= nil, "Hide remounts a missing OnHide")
  assert_true(remounted ~= customOnHide, "the remount is the desk's own OnHide")
  Console:Show()
  Console:Hide()
  assert_eq(frame:GetScript("OnHide"), remounted, "a present OnHide is never replaced")
  assert_eq(Console:IsShown(), false, "the desk ends hidden")
  popeOff()
end
runDeskChrome()

--------------------------------------------------------------------------------
-- Task 6: unsigned petition paint. Verbs still refuse a non-Pope.
--------------------------------------------------------------------------------
local function runUnsignedPetitionPaint()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()
  Console:StartEvent()
  local humans0 = #Store:Snapshot().humans
  local chars0 = #Store:Snapshot().characters
  assert_true(Gora:PetitionFromSender("Zipfresh") ~= nil, "unsigned Zipfresh petitions")
  Console:Refresh()
  assert_eq(fontVisible(frame, "No petitions."), false, "unsigned petition hides the empty line")
  assert_true(findButton(frame, "Zipfresh") ~= nil, "the petition strip paints the unsigned name")
  local rows = Console:GetPetitions()
  assert_eq(#rows, 1, "GetPetitions includes the unsigned row")
  assert_eq(rows[1].name, "Zipfresh", "unsigned desk row carries the display name")
  assert_eq(rows[1].senderKey, "zipfresh", "unsigned desk row carries the name-key")
  assert_eq(#Store:Snapshot().humans, humans0, "unsigned paint does not mint a human")
  assert_eq(#Store:Snapshot().characters, chars0, "unsigned paint does not mint a character")
  local zipBtn = findButton(frame, "Zipfresh")
  stub.fire(zipBtn, "OnClick")
  assert_eq(#Store:Snapshot().humans, humans0, "unsigned click does not mint a human")
  assert_eq(#Store:Snapshot().characters, chars0, "unsigned click does not mint a character")
  assert_eq(Console:GetProposedBout().fighterA, nil,
    "unsigned click does not fill Fighter A")
  assert_eq(Console:GetProposedBout().fighterB, nil,
    "unsigned click does not fill Fighter B")
  assert_eq(Gora:GetSanctioned(), nil, "unsigned click does not Sanction")
  assert_eq(Console:GetWorkingSubject() and Console:GetWorkingSubject().name, "Zipfresh",
    "unsigned click selects the painted name")
  local dismissBtn = findButton(frame, "Dismiss")
  assert_true(dismissBtn ~= nil, "unsigned row carries Dismiss")
  stub.fire(dismissBtn, "OnClick")
  assert_eq(#Console:GetPetitions(), 0, "Dismiss by unsigned name-key retires the row")
  assert_eq(#Store:Snapshot().humans, humans0, "unsigned Dismiss does not mint a human")
  assert_eq(#Store:Snapshot().characters, chars0, "unsigned Dismiss does not mint a character")
  Console:EndEvent()
  popeOff()
  Sender.IsRegisteredPope = function() return false end
  local refused, refuseWhy = Console:Dismiss()
  assert_eq(refused, nil, "Dismiss still refuses when not a registered pope")
  assert_eq(refuseWhy, "not a registered pope", "unsigned paint does not undo pope verb refuses")
  dofile("addon/ChurchOfBeef/Core/Sender.lua")
  Sender = COB.Sender
end
if type(Gora.PetitionFromSender) == "function" then
  runUnsignedPetitionPaint()
end

--------------------------------------------------------------------------------
-- Task 14: next-verb refuse paint, petition fill A then B, no toast.
--------------------------------------------------------------------------------
local function runTask14Desk()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()
  Console:StartEvent()
  Console:OpenRite("Gora")
  assert_eq(Runtime:Snapshot().state, "RITE", "End-during-RITE starts in RITE")
  local ended, endWhy = Console:EndEvent()
  assert_eq(ended, nil, "EndEvent refuses during RITE")
  assert_eq(endWhy, "event ends from assembly or consequence",
    "End-during-RITE names the Core refuse")
  assert_eq(frame.GateStatus:GetText(), "event ends from assembly or consequence",
    "after() paints End-during-RITE on GateStatus")
  assert_eq(Runtime:Snapshot().state, "RITE", "a painted refuse does not end the event")
  local closed = Console:CloseRite()
  assert_true(closed ~= nil, "Close this rite still succeeds")
  assert_eq(frame.GateStatus:GetText(), "", "success Refresh clears the refuse")
  Console:EndEvent()

  Console:StartEvent()
  local _, first = seedLinked("Ribeye", "Rib", 2)
  local _, second = seedLinked("Flatiron", "Flat", 2)
  COB.Roster = {
    ready = true,
    complete = true,
    members = {
      ribeye = { name = "Ribeye", guildRankIndex = 4 },
      flatiron = { name = "Flatiron", guildRankIndex = 5 },
    },
  }
  Gora:Petition(first.id)
  Gora:Petition(second.id)
  Console:Refresh()
  local firstBtn = findButton(frame, "Ribeye")
  local secondBtn = findButton(frame, "Flatiron")
  assert_true(firstBtn ~= nil, "first petitioner paints")
  assert_true(secondBtn ~= nil, "second petitioner paints")
  stub.fire(firstBtn, "OnClick")
  assert_eq(Console:GetProposedBout().fighterA, first.id, "first petition fills Fighter A")
  assert_eq(Console:GetProposedBout().fighterB, nil, "Fighter B stays empty")
  assert_eq(Gora:GetSanctioned(), nil, "first petition click does not Sanction")
  stub.fire(secondBtn, "OnClick")
  assert_eq(Console:GetProposedBout().fighterA, first.id, "Fighter A stays the first petitioner")
  assert_eq(Console:GetProposedBout().fighterB, second.id, "second petition fills Fighter B")
  assert_eq(Gora:GetSanctioned(), nil, "second petition click does not Sanction")
  Console:Refresh()
  assert_true(findButton(frame, "Ribeye  use this petitioner") ~= nil,
    "a full pair labels the row use this petitioner")
  Console:EndEvent()
  popeOff()

  local src = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
  assert_true(src ~= nil, "Console.lua is readable")
  local body = src:read("*a")
  src:close()
  assert_eq(body:find("Toasts", 1, true), nil, "the desk does not toast refuses")
  assert_eq(body:find("Proclaim", 1, true), nil, "the desk does not Proclaim refuses")
end
runTask14Desk()

--------------------------------------------------------------------------------
-- Pope's Desk rework: tabs, candidate lock, fighter uniqueness, verdict once.
--------------------------------------------------------------------------------
local function runDeskRework()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()

  assert_eq(Console:GetTab(), "gathering", "default tab is Gathering")
  assert_eq(Console:SetTab("church"), true, "SetTab church")
  assert_eq(Console:GetTab(), "church", "Church tab is selected")
  assert_eq(isVisible(frame.PresenceStrip.head), true, "Church tab shows the census")
  assert_eq(Console:SetTab("bogus"), nil, "unknown tabs refuse")
  Console:SetTab("gathering")

  Console:StartEvent()
  local hA, cA = seedLinked("Chuckroast", "Chuck", 2)
  local hB, cB = seedLinked("Tendermage", "Tender", 3)
  targetStranger("Chuckroast")
  Console:OpenRite("Knighting")
  local locked = Console:GetWorkingSubject()
  assert_eq(locked.characterId, cA.id, "opening Knighting locks the targeted candidate")
  targetStranger("Tendermage")
  assert_eq(Console:GetWorkingSubject().characterId, cA.id,
    "a target change does not replace the locked candidate")
  assert_eq(Console:GetDeskState().rite, "knighting", "Knighting is a desk rite mode")
  Console:CloseRite()
  Console:Continue()

  Console:SelectCharacter(cA.id)
  Console:SetFighterA()
  Console:SelectCharacter(cA.id)
  local same, sameErr = Console:SetFighterB()
  assert_eq(same, nil, "the same fighter cannot fill both slots")
  assert_eq(sameErr, "a Gora needs two different combatants", "same-fighter refusal is human")
  Console:SelectCharacter(cB.id)
  assert_eq(Console:SetFighterB(), true, "a second fighter fills slot B")
  Console:OpenRite("Gora")
  Console:Sanction()
  assert_eq(Console:GetDeskState().goraPhase, "sanctioned", "Sanction locks the Gora into live")
  local relock, relockErr = Console:SetFighterA()
  assert_eq(relock, nil, "sanctioned fighters cannot change")
  assert_eq(relockErr, "fighters are locked", "lock refusal is human")
  local first = Console:DeclareVictor(cB.id)
  assert_true(first ~= nil, "first verdict writes")
  local dup, dupErr = Console:DeclareVictor(cA.id)
  assert_eq(dup, nil, "a second verdict is refused")
  assert_eq(dupErr, "verdict already recorded", "duplicate verdict names the refuse")
  assert_eq(Console:GetDeskState().goraPhase, "complete", "a recorded verdict is a completion state")
  assert_true(hA ~= nil and hB ~= nil, "fixtures exist")
  Console:ReturnToGathering()
  Console:OpenRite("Gora")
  Console:SelectCharacter(cA.id)
  Console:SetFighterA()
  Console:SelectCharacter(cB.id)
  Console:SetFighterB()
  Console:Sanction()
  assert_eq(Console:ForceEndGathering() ~= nil, true, "ForceEndGathering ends a live Gora")
  assert_eq(Runtime:Snapshot().state, "QUIET", "ForceEndGathering returns to quiet")
  Console:EndEvent()

  -- Button hierarchy: gold primary, oxblood destructive, silver secondary.
  Console:Show()
  assert_eq(frame.StartGathering._cobStyle, "gold", "Begin Gathering is the gold primary")
  assert_eq(frame.MarkMoment._cobStyle, "silver", "Mark this moment is a silver secondary")
  Console:StartEvent()
  assert_eq(frame.EndGathering._cobStyle, "oxblood", "End Gathering is oxblood destructive")
  assert_eq(frame.OpenKnighting._cobStyle, "silver", "rite launchers stay secondary")
  Console:EndEvent()
  popeOff()
end
runDeskRework()

--------------------------------------------------------------------------------
-- /reload keeps rite locks and a recorded verdict (Core + ui.console).
--------------------------------------------------------------------------------
local function runDeskReload()
  reset()
  ChurchOfBeefDB = { ui = {} }
  local frame = Console:Init()
  popeOn()
  Console:Show()
  Console:StartEvent()
  local _, cA = seedLinked("Chuckroast", "Chuck", 2)
  local _, cB = seedLinked("Tendermage", "Tender", 3)
  targetStranger("Chuckroast")
  Console:OpenRite("Knighting")
  Console:SimulateReloadForTests()
  assert_eq(Console:GetWorkingSubject().characterId, cA.id,
    "reload keeps the locked Knighting candidate")
  targetStranger("Tendermage")
  Console:Refresh()
  assert_eq(Console:GetWorkingSubject().characterId, cA.id,
    "reload keeps candidate lock against a new target")
  Console:CloseRite()
  Console:Continue()

  Console:SelectCharacter(cA.id)
  Console:SetFighterA()
  Console:SelectCharacter(cB.id)
  Console:SetFighterB()
  Console:OpenRite("Gora")
  Console:Sanction()
  Console:SimulateReloadForTests()
  assert_eq(Console:GetDeskState().goraPhase, "sanctioned", "reload keeps a sanctioned Gora")
  local relock, relockErr = Console:SetFighterA()
  assert_eq(relock, nil, "reload keeps fighters locked")
  assert_eq(relockErr, "fighters are locked", "reload lock refusal is human")
  assert_eq(Console:DeclareVictor(cB.id) ~= nil, true, "reload still records a first verdict")
  Console:SimulateReloadForTests()
  assert_eq(Console:GetDeskState().goraPhase, "complete", "reload keeps the recorded verdict")
  local dup, dupErr = Console:DeclareVictor(cA.id)
  assert_eq(dup, nil, "reload does not allow a second verdict")
  assert_eq(dupErr, "verdict already recorded", "reload duplicate names the refuse")
  assert_true(frame ~= nil, "frame exists")
  Console:ReturnToGathering()
  Console:EndEvent()
  popeOff()
  ChurchOfBeefDB = nil
end
runDeskReload()

--------------------------------------------------------------------------------
-- Raid-health draft arms DECLARE VICTOR without a new target.
--------------------------------------------------------------------------------
local function runRaidHealthPropose()
  reset()
  local frame = Console:Init()
  popeOn()
  Console:Show()
  Console:StartEvent()
  local _, sideA = seedLinked("Chuckroast", "Chuck", 3)
  local _, sideB = seedLinked("Tendermage", "Tender", 1)
  Console:SelectCharacter(sideA.id)
  Console:SetFighterA()
  Console:SelectCharacter(sideB.id)
  Console:SetFighterB()
  Console:Sanction()
  Console:SelectCharacter(nil)
  Console:Refresh()
  assert_eq(frame.TargetLine:GetText(), "Select the victor, then RECORD VERDICT.",
    "without a draft the empty subject still names the verdict click")
  assert_eq(frame.DeclareVictor._highlighted == true, false,
    "without a draft DECLARE VICTOR is not locked")
  local refused, refuseErr = Console:DeclareVictor()
  assert_eq(refused, nil, "DeclareVictor without a draft or target still refuses")
  assert_eq(refuseErr, "Target the victor", "victor refusal is human")

  Console:SetTab("decrees")
  Gora:Propose({
    ruling = "victor",
    winnerId = sideB.id,
    loserId = sideA.id,
    source = "raid-health",
  })
  Console:Refresh()
  assert_eq(Console:GetTab(), "gathering", "a draft returns the desk to Gathering")
  assert_eq(frame.TargetLine:GetText(),
    "Proposed victor: Tendermage. DECLARE VICTOR to ratify.",
    "raid-health draft names the proposed victor")
  assert_eq(frame.DeclareVictor._highlighted, true,
    "a draft locks the DECLARE VICTOR highlight")
  assert_eq(frame.DeclareVictor._cobArmed, true, "DECLARE VICTOR is marked armed")
  assert_eq(frame.OutcomeLabel:GetText(), "Proposed victor — tap DECLARE VICTOR",
    "the verdict label names the waiting tap")
  assert_eq(frame.DeclareVictor:GetText(), "DECLARE VICTOR",
    "the verb name stays DECLARE VICTOR")
  local recorded, recErr = Console:DeclareVictor()
  assert_true(recorded ~= nil, "DECLARE VICTOR with a draft and no target records")
  assert_eq(recErr, nil, "drafted DeclareVictor has no error")
  assert_eq(recorded.winnerId, sideB.id, "the draft winner is the recorded winner")
  assert_eq(Store:GetCharacter(sideB.id).gora.wins, 1, "the draft winner gets the win")
  Console:Refresh()
  assert_eq(frame.DeclareVictor._cobArmed, nil, "a recorded verdict clears the armed mark")
  assert_eq(frame.DeclareVictor._highlighted, false, "a recorded verdict unlocks the highlight")
  popeOff()
end
runRaidHealthPropose()

--------------------------------------------------------------------------------
-- No queue store, no auto-advance, no guild write, no theater in this file.
--------------------------------------------------------------------------------
reset()
Console:Init()
assert_eq(Console.frame:GetScript("OnUpdate"), nil, "no permanent OnUpdate")
assert_eq(promoteCalls, 0, "suite never called GuildPromote")

GuildPromote = savedPromote
SetGuildRank = savedSetGuildRank
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
