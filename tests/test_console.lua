-- Director Console stock desks (Phase 4 Lane E + Phase 6 Lane I). Isolated:
-- wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender +
-- Decree + Console. Toggle / Show / Hide only. Ritual verbs call signed Core
-- only when Sender:IsRegisteredPope(local) is true — always false today; this
-- suite does not stub a Pope list. Sound / Hud / Decree UI are stubs when
-- needed. No TOC / bootstrap / run.lua / MainFrame / slash.
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
dofile("addon/ChurchOfBeef/UI/Console.lua")

local COB = ChurchOfBeef
local Console = COB.Console
local Runtime = COB.Runtime
local Store = COB.Store
local Gora = COB.Gora
local Knighting = COB.Knighting
local Sender = COB.Sender
local Decree = COB.Decree

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Gora:ResetForTests(), true, "Gora ResetForTests runs under _IN_TEST")
  assert_eq(Decree:ResetForTests(), true, "Decree ResetForTests runs under _IN_TEST")
  if Console.ResetForTests then
    assert_eq(Console:ResetForTests(), true, "Console ResetForTests runs under _IN_TEST")
  end
  COB.Roster = nil
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
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_eq(Console.MODE, "event", "Director Console declares Event Mode")

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
end

assert_eq(type(Console.Init), "function", "Init exists")
assert_eq(type(Console.Show), "function", "Show exists")
assert_eq(type(Console.Hide), "function", "Hide exists")
assert_eq(type(Console.Toggle), "function", "Toggle exists")
assert_eq(type(Console.IsShown), "function", "IsShown exists")
assert_eq(type(Console.Refresh), "function", "Refresh exists")
assert_eq(type(Console.GetPresence), "function", "GetPresence is display")
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
assert_eq(type(Console.FlagMoment), "function", "MARK THIS MOMENT is a console verb")
assert_eq(type(Console.PostDecree), "function", "Post Decree is a console verb")

assert_eq(Console.Grant, nil, "no Grant")
assert_eq(Console.Narrate, nil, "software does not narrate")
assert_eq(Console.Proclaim, nil, "no generated proclamation")
assert_eq(Console.Announce, nil, "console does not announce")
assert_eq(Console.AutoAdvance, nil, "no auto-advance")
assert_eq(Console.SaveNote, nil, "no Notebook persist")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.GuildPromote, nil, "no GuildPromote on the console")
assert_eq(Console.SetGuildRank, nil, "no SetGuildRank on the console")
assert_eq(Console.RegisterPope, nil, "no #8 Pope list")
assert_eq(Console.OpenHud, nil, "Fight HUD is not this file")
assert_eq(Console.OpenRecords, nil, "Records Book is not this file")
assert_eq(Console.ShowDecree, nil, "Decree parchment is not this file")
assert_eq(Console.Calendar, nil, "no calendar")
assert_eq(Console.RSVP, nil, "no RSVP")
assert_eq(Console.Deputy, nil, "no deputy")
assert_eq(Console.Favor, nil, "favor is not this file")
assert_eq(Console.INPUT, nil, "INPUT channel is not this file")
assert_eq(SLASH_CHURCHOFBEEF1, savedSlash, "Console does not register a slash")
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "the registered-Pope predicate stays fail-closed")

--------------------------------------------------------------------------------
-- Init: hidden stock working frame. Not the Quiet /beef shell.
--------------------------------------------------------------------------------
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
assert_eq(frame:GetParent(), UIParent, "insecure frame under UIParent")
assert_eq(countType(frame, "EditBox"), 2, "Decree line and flavor only")
assert_true(frame.DecreeLine ~= nil, "Decree line is a stock EditBox")
assert_eq(frame.DecreeLine._type, "EditBox", "line box is an EditBox")
assert_eq(frame.DecreeLine._template, "InputBoxTemplate", "line box is InputBoxTemplate")
assert_eq(frame.DecreeLine._autoFocus, false, "line box does not steal focus")
assert_true(frame.DecreeFlavor ~= nil, "Decree flavor is a stock EditBox")
assert_eq(frame.DecreeFlavor._template, "InputBoxTemplate", "flavor box is InputBoxTemplate")
assert_eq(frame.DecreeFlavor._autoFocus, false, "flavor box does not steal focus")

assert_true(findFont(frame, "Presence") ~= nil, "Presence desk header")
assert_true(findFont(frame, "Knighting") ~= nil, "Knighting desk header")
assert_true(findFont(frame, "Gora") ~= nil, "Gora desk header")
assert_true(findButton(frame, "Start Event") ~= nil, "Start Event is one click")
assert_true(findButton(frame, "Open Knighting") ~= nil, "Open Knighting is one click")
assert_true(findButton(frame, "Open Gora") ~= nil, "Open Gora is one click")
assert_true(findButton(frame, "Open Confession") ~= nil, "Open Confession is one click")
assert_true(findButton(frame, "Open Proclamation") ~= nil, "Open Proclamation is one click")
assert_true(findButton(frame, "Close Rite") ~= nil, "Close Rite is one click")
assert_true(findButton(frame, "Continue") ~= nil, "Continue is one click")
assert_true(findButton(frame, "End Event") ~= nil, "End Event is one click")
assert_true(findButton(frame, "KNIGHT THIS BEEF") ~= nil, "KNIGHT THIS BEEF button")
assert_true(findButton(frame, "ELEVATE TO LORD") ~= nil, "ELEVATE TO LORD button")
assert_true(findButton(frame, "SANCTION BEEF GORA") ~= nil, "SANCTION BEEF GORA button")
assert_true(findButton(frame, "Dismiss") ~= nil, "Dismiss petition button")
assert_true(findButton(frame, "DECLARE VICTOR") ~= nil, "DECLARE VICTOR button")
assert_true(findButton(frame, "COWARDICE RECORDED") ~= nil, "COWARDICE RECORDED button")
assert_true(findButton(frame, "VOID") ~= nil, "VOID button")
assert_true(findButton(frame, "FREE RULING") ~= nil, "FREE RULING button")
assert_true(findButton(frame, "MARK THIS MOMENT") ~= nil, "MARK THIS MOMENT button")
assert_true(findFont(frame, "Notebook") ~= nil, "Notebook is a disabled label")
assert_true(findFont(frame, "A GATHERING HAS BEEN DECREED") ~= nil, "Decree header is UI copy")
assert_true(findButton(frame, "Post Decree") ~= nil, "Post Decree is one click")
assert_eq(findButton(frame, "Favor"), nil, "no favor chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_eq(findButton(frame, "Calendar"), nil, "no calendar chrome")
assert_eq(findFont(frame, "Eternal Grazing."), nil, "UI never tells jokes")

--------------------------------------------------------------------------------
-- Toggle / Show / Hide only
--------------------------------------------------------------------------------
Console:Toggle()
assert_eq(Console:IsShown(), true, "toggle opens the console")
Console:Toggle()
assert_eq(Console:IsShown(), false, "toggle closes the console")
Console:Show()
assert_eq(Console:IsShown(), true, "Show opens the console")
Console:Hide()
assert_eq(Console:IsShown(), false, "Hide closes the console")

--------------------------------------------------------------------------------
-- Presence is display from Roster + Store. No Roster → empty.
--------------------------------------------------------------------------------
reset()
Console:Init()
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
rows[1].name = "mutated"
assert_eq(Console:GetPresence()[1].name, "Beefina", "Presence rows are copies")
assert_eq(lord.id ~= nil, true, "lord fixture exists")

Console:Refresh()
assert_true(frame.PresenceList ~= nil, "Presence list is a stock FontString")
local presenceText = frame.PresenceList:GetText() or ""
assert_true(presenceText:find("Beefina", 1, true) ~= nil, "Presence paints who is here")
assert_true(presenceText:find("needs Knighting", 1, true) ~= nil, "Presence paints the Knighting flag")
assert_true(presenceText:find("Fresh Beef", 1, true) ~= nil, "Presence paints the Church rank")

--------------------------------------------------------------------------------
-- Ritual verbs refuse while the registered-Pope list is fail-closed
--------------------------------------------------------------------------------
reset()
Console:Init()
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
assert_eq(err, "not the registered pope", "refuse reason is mechanical")
assert_eq(starts, 0, "Runtime:StartEvent is not called")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime stays QUIET")

ok, err = Console:OpenRite("Knighting")
assert_eq(ok, nil, "OpenRite refuses when not the registered Pope")
assert_eq(err, "not the registered pope", "OpenRite refuse reason")
assert_eq(Console:CloseRite(), nil, "CloseRite refuses when not the registered Pope")
assert_eq(Console:Continue(), nil, "Continue refuses when not the registered Pope")
assert_eq(Console:EndEvent(), nil, "EndEvent refuses when not the registered Pope")

ok, err = Console:KnightThisBeef(steve.id)
assert_eq(ok, nil, "KNIGHT THIS BEEF refuses when not the registered Pope")
assert_eq(err, "not the registered pope", "knight refuse reason")
assert_eq(knights, 0, "Knighting:KnightThisBeef is not called")
assert_eq(Store:GetHuman(steve.id).rankId, 2, "Church rank is unchanged")

ok, err = Console:ElevateToLord(steve.id)
assert_eq(ok, nil, "ElevateToLord refuses when not the registered Pope")
assert_eq(Store:GetHuman(steve.id).rankId, 2, "elevation does not write")

ok, err = Console:Sanction(a.id, b.id)
assert_eq(ok, nil, "Sanction refuses when not the registered Pope")
assert_eq(err, "not the registered pope", "sanction refuse reason")
assert_eq(Gora:GetSanctioned(), nil, "no live pair")

assert_eq(Console:DeclareVictor(a.id), nil, "DECLARE VICTOR refuses")
assert_eq(Console:CowardiceRecorded(a.id), nil, "COWARDICE RECORDED refuses")
assert_eq(Console:Void(), nil, "VOID refuses")
assert_eq(Console:FreeRuling(), nil, "FREE RULING refuses")
assert_eq(Console:Dismiss(a.id), nil, "Dismiss refuses")

ok, err = Console:FlagMoment()
assert_eq(ok, nil, "MARK THIS MOMENT refuses when not the registered Pope")
assert_eq(err, "not the registered pope", "moment refuse reason")
assert_eq(flags, 0, "Store:FlagMoment is not called")
assert_eq(#Store:GetMarkedMoments(), 0, "no marked moment")

ok, err = Console:PostDecree({ line = "Goldshire Inn — Sunday, 7:00 PM" })
assert_eq(ok, nil, "PostDecree refuses when not the registered Pope")
assert_eq(err, "not the registered pope", "PostDecree refuse reason")
assert_eq(Decree:Get(), nil, "refused PostDecree does not Set")

stub.fire(findButton(frame, "Start Event"), "OnClick")
stub.fire(findButton(frame, "KNIGHT THIS BEEF"), "OnClick")
stub.fire(findButton(frame, "SANCTION BEEF GORA"), "OnClick")
stub.fire(findButton(frame, "MARK THIS MOMENT"), "OnClick")
stub.fire(findButton(frame, "Post Decree"), "OnClick")
assert_eq(starts, 0, "dead buttons do not StartEvent on a live client")
assert_eq(knights, 0, "dead buttons do not knight on a live client")
assert_eq(flags, 0, "dead buttons do not flag a moment on a live client")
assert_eq(Decree:Get(), nil, "dead Post Decree does not Set")
assert_eq(promoteCalls, 0, "refused verbs never GuildPromote")

Runtime.StartEvent = realStart
Store.FlagMoment = realFlag
Knighting.KnightThisBeef = realKnight

--------------------------------------------------------------------------------
-- Temporary predicate wrap (not a Pope list): verbs call signed Core
--------------------------------------------------------------------------------
reset()
Console:Init()
steve = seedHuman("Steve", 2)
a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

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
local free = Console:FreeRuling()
assert_eq(free.ruling, "free", "FREE RULING reaches Gora")

Gora:Petition(a.id)
assert_eq(Console:Dismiss(a.id), true, "Dismiss reaches Gora")
local afterDismiss = Console:GetPetitions()
local stillA = false
for i = 1, #afterDismiss do
  if afterDismiss[i].characterId == a.id then stillA = true end
end
assert_eq(stillA, false, "dismissed petition is gone")

local moment = Console:FlagMoment()
assert_true(moment ~= nil, "MARK THIS MOMENT reaches Store")
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
assert_eq(Decree:Get().flavor, "bring a fork", "Decree:Get is the posted flavor")
assert_eq(posted.header, nil, "header is UI copy, not stored")

frame.DecreeLine:SetText("Goldshire Inn — Tuesday")
frame.DecreeFlavor:SetText("one optional line")
stub.fire(findButton(frame, "Post Decree"), "OnClick")
assert_eq(Decree:Get().line, "Goldshire Inn — Tuesday", "the Post Decree button reads the line box")
assert_eq(Decree:Get().flavor, "one optional line", "the Post Decree button reads the flavor box")

Console:SelectHuman(steve.id)
stub.fire(findButton(frame, "KNIGHT THIS BEEF"), "OnClick")
assert_eq(Store:GetHuman(steve.id).rankId, 3, "the Knighting button uses the caller-supplied human")

Console:SelectFighters(a.id, b.id)
Gora:Petition(a.id)
Gora:Petition(b.id)
stub.fire(findButton(frame, "SANCTION BEEF GORA"), "OnClick")
assert_true(Gora:GetSanctioned() ~= nil, "the Sanction button uses caller-supplied fighters")

stub.fire(findButton(frame, "MARK THIS MOMENT"), "OnClick")
assert_eq(#Store:GetMarkedMoments(), 2, "the moment button flags once")

assert_eq(promoteCalls, 0, "console verbs never GuildPromote")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "wrapping the predicate in-test does not stub the list true")
assert_eq(Console:StartEvent(), nil, "after restore, verbs refuse again")
assert_eq(COB.Popes, nil, "still no Pope list")

--------------------------------------------------------------------------------
-- Sound callers (Event Mode only) and Hud:Refresh after Gora verbs
--------------------------------------------------------------------------------
reset()
Console:Init()
steve = seedHuman("Steve", 2)
a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

local savedSound = COB.Sound
local savedHud = COB.Hud
local savedBanner = COB.DecreeBanner
local soundCalls = {}
local hudRefreshes = 0
local bannerShows = 0
COB.Sound = {
  Play = function(_, name)
    soundCalls[#soundCalls + 1] = name
    return name
  end,
}
COB.Hud = {
  Refresh = function()
    hudRefreshes = hudRefreshes + 1
  end,
}
COB.DecreeBanner = {
  Show = function()
    bannerShows = bannerShows + 1
  end,
}

local function lastSound()
  return soundCalls[#soundCalls]
end

local startedQuiet = Console:StartEvent()
assert_true(startedQuiet ~= nil, "StartEvent succeeds with Sound stubbed")
assert_eq(#soundCalls, 0, "StartEvent does not play Sound")
assert_eq(hudRefreshes, 0, "StartEvent does not Refresh Hud")

local knightedCue = Console:KnightThisBeef(steve.id)
assert_true(knightedCue ~= nil, "KNIGHT THIS BEEF succeeds with Sound stubbed")
assert_eq(lastSound(), "knighting", "KNIGHT THIS BEEF plays knighting")

local elevatedCue = Console:ElevateToLord(steve.id)
assert_true(elevatedCue ~= nil, "ElevateToLord succeeds with Sound stubbed")
assert_eq(lastSound(), "elevation", "ElevateToLord plays elevation")
assert_eq(#soundCalls, 2, "runtime verbs have not added cues")

Gora:Petition(a.id, b.id)
Gora:Petition(b.id)
local hBefore = hudRefreshes
local sanctionedCue = Console:Sanction(a.id, b.id)
assert_true(sanctionedCue ~= nil, "Sanction succeeds with Sound stubbed")
assert_eq(lastSound(), "sanction", "Sanction plays sanction")
assert_eq(hudRefreshes, hBefore + 1, "Sanction calls Hud:Refresh")

local voidedCue = Console:Void()
assert_true(voidedCue ~= nil, "VOID succeeds with Sound stubbed")
assert_eq(lastSound(), "verdict", "VOID plays verdict")
assert_eq(hudRefreshes, hBefore + 2, "VOID calls Hud:Refresh")

Gora:Petition(a.id)
Gora:Petition(b.id)
Console:Sanction(a.id, b.id)
local victorCue = Console:DeclareVictor(a.id)
assert_true(victorCue ~= nil, "DECLARE VICTOR succeeds with Sound stubbed")
assert_eq(lastSound(), "verdict", "DECLARE VICTOR plays verdict")

Gora:Petition(a.id)
Gora:Petition(b.id)
Console:Sanction(a.id, b.id)
local cowardCue = Console:CowardiceRecorded(b.id)
assert_true(cowardCue ~= nil, "COWARDICE RECORDED succeeds with Sound stubbed")
assert_eq(lastSound(), "cowardice", "COWARDICE RECORDED plays cowardice")

Gora:Petition(a.id)
Gora:Petition(b.id)
Console:Sanction(a.id, b.id)
local freeCue = Console:FreeRuling()
assert_true(freeCue ~= nil, "FREE RULING succeeds with Sound stubbed")
assert_eq(lastSound(), "verdict", "FREE RULING plays verdict")

local nSound = #soundCalls
Gora:Petition(a.id)
assert_eq(Console:Dismiss(a.id), true, "Dismiss succeeds with Sound stubbed")
assert_eq(#soundCalls, nSound, "Dismiss does not play Sound")
assert_true(Console:FlagMoment() ~= nil, "FlagMoment succeeds with Sound stubbed")
assert_eq(#soundCalls, nSound, "FlagMoment does not play Sound")

local postedCue = Console:PostDecree({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "bring a fork",
})
assert_true(postedCue ~= nil, "PostDecree succeeds with Sound stubbed")
assert_eq(postedCue.line, "Goldshire Inn — Sunday, 7:00 PM", "stubbed PostDecree sets line")
assert_eq(postedCue.flavor, "bring a fork", "stubbed PostDecree sets flavor")
assert_eq(#soundCalls, nSound, "PostDecree does not play Sound")
assert_eq(bannerShows, 1, "PostDecree shows the parchment when the banner exists")

nSound = #soundCalls
hBefore = hudRefreshes
local endedCue = Console:EndEvent()
assert_true(endedCue ~= nil, "EndEvent succeeds with stubs")
assert_eq(#soundCalls, nSound, "EndEvent does not play Sound")
assert_eq(hudRefreshes, hBefore + 1, "EndEvent calls Hud:Refresh")

Console:StartEvent()
nSound = #soundCalls
hBefore = hudRefreshes
assert_true(Console:OpenRite("Gora") ~= nil, "OpenRite succeeds with Sound stubbed")
assert_true(Console:CloseRite() ~= nil, "CloseRite succeeds with Sound stubbed")
assert_true(Console:Continue() ~= nil, "Continue succeeds with Sound stubbed")
assert_eq(#soundCalls, nSound, "OpenRite / CloseRite / Continue do not play Sound")
assert_eq(hudRefreshes, hBefore, "runtime transitions do not Refresh Hud")

COB.Sound = nil
Gora:Petition(a.id)
Gora:Petition(b.id)
assert_true(Console:Sanction(a.id, b.id) ~= nil, "Sanction succeeds when Sound is missing")

COB.Sound = {
  Play = function()
    error("sound exploded")
  end,
}
assert_true(Console:Void() ~= nil, "VOID succeeds when Sound.Play errors")

COB.Sound = savedSound
COB.Hud = savedHud
COB.DecreeBanner = savedBanner
Sender.IsRegisteredPope = savedPred

--------------------------------------------------------------------------------
-- No queue store, no auto-advance, no guild write, no theater in this file
--------------------------------------------------------------------------------
reset()
Console:Init()
assert_eq(Console.Queue, nil, "no Knighting queue store")
assert_eq(Console.AdvanceQueue, nil, "no queue auto-advance")
assert_eq(Console.NextCandidate, nil, "no next-candidate store")
assert_eq(Console.Target, nil, "targeting assist is not this lane")
assert_eq(Console.SetRaidMarker, nil, "raid markers are not this lane")
assert_eq(frame:GetScript("OnUpdate"), nil, "no permanent OnUpdate")
assert_eq(promoteCalls, 0, "suite never called GuildPromote")

GuildPromote = savedPromote
SetGuildRank = savedSetGuildRank
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
