-- Director Console stock desks (Phase 4 Lane E + Phase 6 Lane I + Wire W-E +
-- Vestments B3-D proposed bout / stipulation + B4-D petition H2H / confession
-- inbox / stock Dismiss + B5-C line / Recommend / CallForward / zone mark +
-- B6-A GRANT HONORIFIC / Recognition Begin-Complete-Cancel + B7-B Archive
-- export/import / CanonizeMoment / FlagFamousUpset + B8-E multiline
-- ArchiveBox / stock ARCHIVE and CANONIZE labels + B9-C stock
-- CeremonyLog desk + B10-D stock desk-body ScrollFrame, outer height 780
-- + B11-C desk mouse wheel and Open Gora subject fallback + B12-B Open
-- Knighting line-head subject fallback + B13-D stockEdit OnEscapePressed
-- ClearFocus + B14-D UISpecialFrames rememberSpecial dedupe + B18-B named
-- petition paints "  names  " and click SelectFighters + B19-A
-- presentCharacterIds fail-opens until Roster is complete + B20-A
-- Confession rows click-select and mute called token + B21-A
-- GetPresence fail-opens Store names until Roster is complete + B22-A
-- Recommendation paints named-opponent "  names  " + B23-A
-- playCue no-ops when Toasts.Proclaim exists + B24-A
-- lastRecommendation clears on successful StartEvent / EndEvent + B25-A
-- selected pair does not inherit the Recommend names token + B26-A
-- selected pair dies with successful StartEvent / EndEvent + B27-A
-- Init early-return remounts UISpecialFrames rememberSpecial + B28-A
-- Show / Refresh remount UISpecialFrames rememberSpecial + B29-A
-- Hide remounts UISpecialFrames rememberSpecial + B31-A
-- Refresh in QUIET nils lastRecommendation + B32-B
-- Console:Dismiss also reaches Confession:Dismiss + B33-B
-- Presence here == false stock SetAlpha + B34-B leftover
-- Presence hide SetAlpha(1) + B36-B
-- successful EndEvent nils selectedHumanId / selectedCharacterId + B37-A
-- successful Dismiss nils selectedCharacterId + B38-A
-- successful Dismiss of a pair member nils the pair and lastRecommendation
-- + B39-A OpenRite Gora does not fall back to GetLastSanctioned
-- + B40-A Hide remounts missing OnHide
-- + B41-A Refresh remounts missing OnHide
-- + U-I title-bar seal_papal, SANCTION/KNIGHT plates, charcoal ground).
-- Isolated: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting
-- + Sender + Decree + Theme + Console. Confession is stubbed when painted; this file
-- does not load Confession.lua. Knighting GetLine/Enqueue/Skip are stubbed
-- when the real module has not landed them; otherwise the suite pins the real
-- API with Store+Runtime. Toggle / Show / Hide only. Ritual verbs call signed
-- Core only when Sender:IsRegisteredPope(local) is true — always false today;
-- this suite does not stub a Pope list. Favor pane and congregation toggle are
-- Pope-desk chrome (memory only). Post Decree is Decree:Set; this file does
-- not call Net. Sound / Hud / Decree UI are stubs when needed. No TOC /
-- bootstrap / run.lua / MainFrame / slash.
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

-- B5-A may land in the same harness. Pin the real line API when it exists;
-- otherwise stub GetLine / Enqueue / Skip to the brief shape.
local knightLineRows = {}
local stubbedKnightingLine = false
if type(Knighting.GetLine) ~= "function"
    or type(Knighting.Enqueue) ~= "function"
    or type(Knighting.Skip) ~= "function" then
  stubbedKnightingLine = true
  local function liveEvent()
    if not Runtime or type(Runtime.Snapshot) ~= "function" then return true end
    local snap = Runtime:Snapshot()
    return type(snap) == "table" and snap.eventId ~= nil and snap.state ~= "QUIET"
  end
  Knighting.GetLine = function()
    if not liveEvent() then return {} end
    local out = {}
    for i = 1, #knightLineRows do
      out[i] = { humanId = knightLineRows[i].humanId, rankId = knightLineRows[i].rankId }
    end
    return out
  end
  Knighting.Enqueue = function(_, humanId)
    if not liveEvent() then return nil, "no event" end
    if type(humanId) ~= "number" or humanId ~= math.floor(humanId) or humanId < 1 then
      return nil, "invalid human id"
    end
    local human = Store:GetHuman(humanId)
    if not human then return nil, "unknown human" end
    local rankId = human.rankId
    if rankId ~= nil and rankId ~= 1 and rankId ~= 2 then
      return nil, "already knighted"
    end
    for i = 1, #knightLineRows do
      if knightLineRows[i].humanId == humanId then
        return { humanId = humanId, rankId = rankId }
      end
    end
    knightLineRows[#knightLineRows + 1] = { humanId = humanId, rankId = rankId }
    return { humanId = humanId, rankId = rankId }
  end
  Knighting.Skip = function(_, humanId)
    for i = 1, #knightLineRows do
      if knightLineRows[i].humanId == humanId then
        table.remove(knightLineRows, i)
        return true
      end
    end
    return nil, "not in line"
  end
end

local function wipeKnightLine()
  for i = #knightLineRows, 1, -1 do
    knightLineRows[i] = nil
  end
end

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Gora:ResetForTests(), true, "Gora ResetForTests runs under _IN_TEST")
  assert_eq(Decree:ResetForTests(), true, "Decree ResetForTests runs under _IN_TEST")
  if type(Knighting.ResetForTests) == "function" then
    assert_eq(Knighting:ResetForTests(), true, "Knighting ResetForTests runs under _IN_TEST")
  end
  wipeKnightLine()
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
assert_true(COB.Theme ~= nil, "isolated suite loads Theme")
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
  assert_eq(COB.Confession, nil, "isolated suite does not load Confession")
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
assert_eq(type(Console.GetFavorSplit), "function", "GetFavorSplit is a console readout")
assert_eq(type(Console.GetFavorCount), "function", "GetFavorCount is a standing-pick count")
assert_eq(type(Console.GetCongregationFavorVisible), "function", "congregation favor toggle is readable")
assert_eq(type(Console.SetCongregationFavorVisible), "function", "congregation favor toggle is settable")
assert_eq(type(Console.GetProposedBout), "function", "GetProposedBout is a console readout")
assert_eq(type(Console.GetConfessions), "function", "GetConfessions is a console readout")
assert_eq(#Console:GetConfessions(), 0, "GetConfessions is empty without a Confession module")
assert_eq(type(Console.GetKnightingLine), "function", "GetKnightingLine is a console readout")
assert_eq(type(Console.Enqueue), "function", "Enqueue is a console verb")
assert_eq(type(Console.Skip), "function", "Skip is a console verb")
assert_eq(type(Console.Recommend), "function", "Recommend is a console verb")
assert_eq(type(Console.CallForward), "function", "CallForward is a console verb")
assert_eq(type(Console.GrantHonorific), "function", "GRANT HONORIFIC is a console verb")
assert_eq(type(Console.BeginRecognition), "function", "BeginRecognition is a console verb")
assert_eq(type(Console.CompleteRecognition), "function", "CompleteRecognition is a console verb")
assert_eq(type(Console.CancelRecognition), "function", "CancelRecognition is a console verb")
assert_eq(type(Console.ExportArchive), "function", "ExportArchive is a console verb")
assert_eq(type(Console.ImportArchive), "function", "ImportArchive is a console verb")
assert_eq(type(Console.CanonizeMoment), "function", "CanonizeMoment is a console verb")
assert_eq(type(Console.FlagFamousUpset), "function", "FlagFamousUpset is a console verb")
assert_eq(type(Console.GetCeremonyLog), "function", "GetCeremonyLog is a console readout")
assert_eq(#Console:GetCeremonyLog(), 0, "GetCeremonyLog is empty before anyone is logged")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(#Console:GetKnightingLine(), 0, "GetKnightingLine is empty before anyone is lined")
assert_eq(Console.WinnerPicker, nil, "no winner picker")
assert_eq(Console.PickWinner, nil, "no winner picker")

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
assert_eq(countType(frame, "EditBox"), 7, "Decree line, flavor, FREE RULING, STIPULATION, honorific, archive, canonize")
assert_true(frame.DecreeLine ~= nil, "Decree line is a stock EditBox")
assert_eq(frame.DecreeLine._type, "EditBox", "line box is an EditBox")
assert_eq(frame.DecreeLine._template, "InputBoxTemplate", "line box is InputBoxTemplate")
assert_eq(frame.DecreeLine._autoFocus, false, "line box does not steal focus")
assert_true(frame.DecreeFlavor ~= nil, "Decree flavor is a stock EditBox")
assert_eq(frame.DecreeFlavor._template, "InputBoxTemplate", "flavor box is InputBoxTemplate")
assert_eq(frame.DecreeFlavor._autoFocus, false, "flavor box does not steal focus")
assert_true(frame.FreeRulingText ~= nil, "FREE RULING text is a stock EditBox")
assert_eq(frame.FreeRulingText._type, "EditBox", "FREE RULING box is an EditBox")
assert_eq(frame.FreeRulingText._template, "InputBoxTemplate", "FREE RULING box is InputBoxTemplate")
assert_eq(frame.FreeRulingText._autoFocus, false, "FREE RULING box does not steal focus")
assert_true(frame.ProposedBout ~= nil, "proposed bout slot exists")
assert_eq(frame.ProposedBout._type, "FontString", "proposed bout is a FontString")
assert_eq(frame.ProposedBout:GetText(), "", "proposed bout starts empty")
assert_true(frame.Stipulation ~= nil, "STIPULATION is a stock EditBox")
assert_eq(frame.Stipulation._type, "EditBox", "STIPULATION box is an EditBox")
assert_eq(frame.Stipulation._template, "InputBoxTemplate", "STIPULATION box is InputBoxTemplate")
assert_eq(frame.Stipulation._autoFocus, false, "STIPULATION box does not steal focus")
assert_true(frame.CongregationFavor ~= nil, "congregation favor is a stock CheckButton")
assert_eq(frame.CongregationFavor._type, "CheckButton", "congregation toggle is a CheckButton")
assert_eq(frame.CongregationFavor._template, "UICheckButtonTemplate", "congregation toggle uses UICheckButtonTemplate")
assert_eq(frame.CongregationFavor:GetChecked(), true, "congregation toggle starts checked")

assert_true(findFont(frame, "Presence") ~= nil, "Presence desk header")
assert_true(findFont(frame, "Knighting") ~= nil, "Knighting desk header")
assert_true(findFont(frame, "Gora") ~= nil, "Gora desk header")
assert_true(findFont(frame, "FAVOR") ~= nil, "FAVOR pane is clerical")
assert_true(findFont(frame, "PROPOSED BOUT") ~= nil, "proposed bout header")
assert_true(findFont(frame, "STIPULATION") ~= nil, "STIPULATION header")
assert_true(findFont(frame, "Congregation sees favor") ~= nil, "congregation toggle label")
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
assert_true(frame:GetWidth() >= 740, "console is a two-column desk")
assert_eq(frame:GetHeight(), 780, "outer frame height is 780")
assert_true(frame.DeskScroll ~= nil, "desk body ScrollFrame exists")
assert_eq(frame.DeskScroll._type, "ScrollFrame", "desk body is a ScrollFrame")
local startBtn = findButton(frame, "Start Event")
assert_true(startBtn:GetHeight() >= 28, "sacred verbs are large targets")
assert_true(startBtn:GetWidth() >= 160, "sacred verbs are wide enough")
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

local beefinaBtn
walk(frame, function(child)
  if not beefinaBtn and child._type == "Button" and child.GetText then
    local text = child:GetText() or ""
    if text:find("Beefina", 1, true) then beefinaBtn = child end
  end
end)
assert_true(beefinaBtn ~= nil, "Presence rows are clickable")
stub.fire(beefinaBtn, "OnClick")
assert_eq(Console.selectedHumanId, human.id, "clicking Presence selects the human")
assert_eq(Console.selectedCharacterId, char.id, "clicking Presence selects the character")
assert_true((frame.SelectionStatus:GetText() or ""):find("Beefina", 1, true) ~= nil,
  "selection is glanceable")

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

do
  assert_eq(Store:GetHuman(steve.id).rankId, 4, "steve is already a Lord before the button click")
  local rawBeef = seedHuman("RawBeef", 2)
  Console:SelectHuman(rawBeef.id)
  stub.fire(findButton(frame, "KNIGHT THIS BEEF"), "OnClick")
  assert_eq(Store:GetHuman(rawBeef.id).rankId, 3, "the Knighting button uses the caller-supplied human")
  assert_eq(Store:GetHuman(steve.id).rankId, 4, "KNIGHT THIS BEEF does not demote a Lord")
end

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

do
local savedSound = COB.Sound
local savedHud = COB.Hud
local savedBanner = COB.DecreeBanner
local savedToastsCue = COB.Toasts
local soundCalls = {}
local hudRefreshes = 0
local bannerShows = 0
-- Full harness may have loaded Toasts already; this block pins isolated Sound:Play.
COB.Toasts = nil
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
COB.Toasts = savedToastsCue
end
Sender.IsRegisteredPope = savedPred

--------------------------------------------------------------------------------
-- W-E: favor pane, congregation toggle, Post Decree stays Core, FREE RULING text
--------------------------------------------------------------------------------
reset()
Console:Init()
assert_eq(Console:GetCongregationFavorVisible(), true, "congregation favor defaults on")
assert_eq(Console:GetFavorSplit().a, 0, "favor split a is zero with no pair")
assert_eq(Console:GetFavorSplit().b, 0, "favor split b is zero with no pair")
assert_eq(Console:GetFavorCount(), 0, "favor count is zero with no picks")

local zeroCopy = Console:GetFavorSplit()
zeroCopy.a = 9
assert_eq(Console:GetFavorSplit().a, 0, "mutating a zero split does not invent a tally")

assert_eq(Console:SetCongregationFavorVisible(false), true, "setter accepts false")
assert_eq(Console:GetCongregationFavorVisible(), false, "setter stores false")
assert_eq(Console:SetCongregationFavorVisible(true), true, "setter accepts true")
assert_eq(Console:GetCongregationFavorVisible(), true, "setter stores true")
local badFlag, badFlagErr = Console:SetCongregationFavorVisible("yes")
assert_eq(badFlag, nil, "non-boolean toggle is refused")
assert_true(type(badFlagErr) == "string", "non-boolean toggle returns an error string")
assert_eq(Console:GetCongregationFavorVisible(), true, "refused toggle leaves the flag")
Console:SetCongregationFavorVisible(false)
badFlag, badFlagErr = Console:SetCongregationFavorVisible(1)
assert_eq(badFlag, nil, "numeric toggle is refused")
assert_eq(Console:GetCongregationFavorVisible(), false, "refused numeric toggle leaves false")
assert_eq(Console:ResetForTests(), true, "ResetForTests still returns true")
assert_eq(Console:GetCongregationFavorVisible(), true, "ResetForTests returns congregation favor to on")

reset()
Console:Init()
a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
local fan = Store:CreateCharacter({ name = "Fanone", class = "Priest", level = 70 })
assert_true(Runtime:StartEvent() ~= nil, "favor pane needs a live event")
Gora:Petition(a.id)
Gora:Petition(b.id)
assert_true(Gora:Sanction(a.id, b.id) ~= nil, "favor pane needs a sanctioned pair")
Gora:RecordFavor(fan.id, a.id)
Gora:RecordFavor(a.id, a.id)
Gora:RecordFavor(b.id, b.id)
local goraSplit = Gora:GetFavorSplit()
local deskSplit = Console:GetFavorSplit()
assert_eq(deskSplit.a, goraSplit.a, "GetFavorSplit a matches Gora")
assert_eq(deskSplit.b, goraSplit.b, "GetFavorSplit b matches Gora")
assert_eq(deskSplit.a, 2, "two standing picks on a")
assert_eq(deskSplit.b, 1, "one standing pick on b")
assert_eq(Console:GetFavorCount(), 3, "GetFavorCount is the standing map size")
deskSplit.a = 99
assert_eq(Gora:GetFavorSplit().a, 2, "mutating the Console split does not change Gora")
assert_eq(Console:GetFavorSplit().a, 2, "GetFavorSplit returns a fresh copy")
Console:Refresh()
assert_true(frame.FavorSplit ~= nil, "Refresh paints a favor split readout")
assert_eq(frame.FavorSplit:GetText(), "2 / 1", "Refresh paints the split counts")
assert_true(frame.FavorCount ~= nil, "Refresh paints a standing-pick count")
assert_eq(frame.FavorCount:GetText(), "3", "Refresh paints the pick count")

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
assert_true(Console:StartEvent() ~= nil, "StartEvent opens the first gathering")
Console:SetCongregationFavorVisible(false)
assert_eq(Console:GetCongregationFavorVisible(), false, "Pope hid congregation favor")
assert_true(Console:EndEvent() ~= nil, "EndEvent returns to QUIET")
Console:Refresh()
assert_eq(Console:GetCongregationFavorVisible(), false,
  "same event id after EndEvent does not restore the toggle")
assert_true(Console:StartEvent() ~= nil, "StartEvent opens the next gathering")
Console:Refresh()
assert_eq(Console:GetCongregationFavorVisible(), true,
  "a new event restores congregation favor to on")

local savedNet = COB.Net
local sendDecree = 0
local sendState = 0
COB.Net = {
  SendDecree = function()
    sendDecree = sendDecree + 1
  end,
  SendState = function()
    sendState = sendState + 1
  end,
}
local postedCore = Console:PostDecree({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "bring a fork",
})
assert_true(postedCore ~= nil, "PostDecree still Sets Core")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "PostDecree wrote Decree")
assert_eq(sendDecree, 0, "PostDecree does not call Net:SendDecree")
assert_eq(sendState, 0, "PostDecree does not call Net:SendState")
COB.Net = savedNet

reset()
Console:Init()
a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
assert_true(Console:StartEvent() ~= nil, "FREE RULING needs a live event")
Gora:Petition(a.id)
Gora:Petition(b.id)
assert_true(Console:Sanction(a.id, b.id) ~= nil, "FREE RULING needs a sanctioned pair")
frame.FreeRulingText:SetText("so ruled")
local boxed = Console:FreeRuling()
assert_true(boxed ~= nil, "FREE RULING with box text reaches Gora")
assert_eq(boxed.ruling, "free", "box FREE RULING is free")
assert_eq(boxed.won, nil, "box FREE RULING has no winner")
assert_eq(boxed.text, "so ruled", "box text is forwarded")
assert_eq(Store:GetCharacter(a.id).gora.results[1].text, "so ruled",
  "Store row keeps the box text")
assert_eq(Store:GetCharacter(a.id).gora.results[1].won, nil,
  "Store row has no won flag")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "box FREE RULING writes no win")
assert_eq(Store:GetCharacter(a.id).gora.losses, 0, "box FREE RULING writes no loss")

Gora:Petition(a.id)
Gora:Petition(b.id)
Console:Sanction(a.id, b.id)
frame.FreeRulingText:SetText("box leftover")
local explicit = Console:FreeRuling("so ruled")
assert_eq(explicit.text, "so ruled", "an explicit FreeRuling argument wins over the box")

Gora:Petition(a.id)
Gora:Petition(b.id)
Console:Sanction(a.id, b.id)
frame.FreeRulingText:SetText("")
local emptyBox = Console:FreeRuling()
assert_true(emptyBox ~= nil, "empty-box FREE RULING still reaches Gora")
assert_eq(emptyBox.ruling, "free", "empty-box FREE RULING is free")
assert_eq(emptyBox.won, nil, "empty-box FREE RULING has no winner")
assert_eq(emptyBox.text, nil, "empty-box FREE RULING stores no text")
assert_eq(Store:GetCharacter(a.id).gora.results[3].won, nil,
  "empty-box Store row has no won flag")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "empty-box FREE RULING writes no win")

Console:Refresh()
frame.CongregationFavor:Disable()
Sender.IsRegisteredPope = function() return false end
Console:Refresh()
assert_eq(frame.CongregationFavor:IsEnabled(), false, "applyGate disables the toggle")
Console:SetCongregationFavorVisible(true)
frame.CongregationFavor:SetChecked(false)
stub.fire(frame.CongregationFavor, "OnClick")
assert_eq(Console:GetCongregationFavorVisible(), true, "non-Pope click does not hide favor")

Sender.IsRegisteredPope = savedPred
assert_eq(COB.Popes, nil, "still no Pope list after the favor desk")

--------------------------------------------------------------------------------
-- B3-D: proposed bout slot + one-line STIPULATION. No winner picker. No Net.
--------------------------------------------------------------------------------
reset()
Console:Init()
a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })

local emptyBout = Console:GetProposedBout()
assert_eq(emptyBout.fighterA, nil, "empty proposed bout has no fighter A")
assert_eq(emptyBout.fighterB, nil, "empty proposed bout has no fighter B")
assert_eq(emptyBout.label, "", "empty proposed bout has an empty label")
emptyBout.label = "mutated"
emptyBout.fighterA = 99
assert_eq(Console:GetProposedBout().label, "", "mutating an empty bout copy does not stick")
assert_eq(Console:GetProposedBout().fighterA, nil, "mutating an empty bout copy does not invent A")

Console:SelectFighters(a.id, nil)
local oneBout = Console:GetProposedBout()
assert_eq(oneBout.fighterA, a.id, "one selected fighter is reported")
assert_eq(oneBout.fighterB, nil, "missing second fighter stays empty")
assert_eq(oneBout.label, "", "label stays empty until both ids are selected")

Console:SelectFighters(a.id, b.id)
local pairBout = Console:GetProposedBout()
assert_eq(pairBout.fighterA, a.id, "proposed bout has fighter A")
assert_eq(pairBout.fighterB, b.id, "proposed bout has fighter B")
assert_eq(pairBout.label, "Chuckroast vs Tendermage", "label is Store names vs")
pairBout.fighterA = 0
pairBout.label = "hacked"
assert_eq(Console:GetProposedBout().fighterA, a.id, "mutating a bout copy does not change A")
assert_eq(Console:GetProposedBout().label, "Chuckroast vs Tendermage",
  "mutating a bout copy does not change the label")

Console:Refresh()
assert_eq(frame.ProposedBout:GetText(), "Chuckroast vs Tendermage",
  "Refresh paints the proposed bout")

Console:SelectFighters(nil, nil)
Console:Refresh()
assert_eq(frame.ProposedBout:GetText(), "", "Refresh clears the proposed bout")

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

local sendDecreeBout = 0
local sendStateBout = 0
local savedNetBout = COB.Net
COB.Net = {
  SendDecree = function()
    sendDecreeBout = sendDecreeBout + 1
  end,
  SendState = function()
    sendStateBout = sendStateBout + 1
  end,
}

assert_true(Console:StartEvent() ~= nil, "stipulation Sanction needs a live event")
Gora:Petition(a.id)
Gora:Petition(b.id)
Console:SelectFighters(a.id, b.id)
frame.Stipulation:SetText("  no potions  ")
local withStip = Console:Sanction()
assert_true(withStip ~= nil, "Sanction with box text reaches Gora")
assert_eq(withStip.fighterA, a.id, "box Sanction uses the proposed pair")
assert_eq(withStip.stipulation, "no potions", "box stipulation is trimmed")
assert_eq(Gora:GetSanctioned().stipulation, "no potions", "Gora remembers the trimmed line")
assert_eq(sendDecreeBout, 0, "Sanction does not call Net:SendDecree")
assert_eq(sendStateBout, 0, "Sanction does not call Net:SendState")

frame.Stipulation:SetText("")
local emptyStip = Console:Sanction(a.id, b.id)
assert_true(emptyStip ~= nil, "empty-box Sanction still reaches Gora")
assert_eq(emptyStip.stipulation, nil, "empty box omits stipulation")
assert_eq(Gora:GetSanctioned().stipulation, nil, "empty box leaves Gora stipulation nil")

frame.Stipulation:SetText("   ")
local wsStip = Console:Sanction(a.id, b.id)
assert_eq(wsStip.stipulation, nil, "whitespace box omits stipulation")

frame.Stipulation:SetText("box leftover")
local explicitStip = Console:Sanction(a.id, b.id, "combatants shall be nude")
assert_eq(explicitStip.stipulation, "combatants shall be nude",
  "an explicit Sanction argument wins over the box")

frame.Stipulation:SetText("box leftover")
local blankArg = Console:Sanction(a.id, b.id, "")
assert_eq(blankArg.stipulation, nil, "explicit empty string omits stipulation")

COB.Net = savedNetBout
Sender.IsRegisteredPope = savedPred
assert_eq(COB.Popes, nil, "still no Pope list after the proposed bout")

--------------------------------------------------------------------------------
-- B4-D: mute petition H2H, confession inbox, stock Dismiss. No WHISPER ALL.
--------------------------------------------------------------------------------
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")

local srcFile = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcFile ~= nil, "Console.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("WHISPER ALL", 1, true), nil, "source must not contain WHISPER ALL")

local dismissBtn = findButton(frame, "Dismiss")
assert_true(dismissBtn ~= nil, "Dismiss button still exists")
assert_eq(dismissBtn._template, "UIPanelButtonTemplate", "Dismiss uses UIPanelButtonTemplate")
local dismissIsRitual = false
for i = 1, #(frame.RitualButtons or {}) do
  if frame.RitualButtons[i] == dismissBtn then dismissIsRitual = true end
end
assert_eq(dismissIsRitual, false, "Dismiss is furniture, not a ritual plate")
Console:Refresh()
assert_eq(dismissBtn:IsEnabled(), true, "Dismiss stays enabled when not the registered Pope")

assert_true(findFont(frame, "Confession") ~= nil, "Confession inbox header")
assert_true(frame.ConfessionList ~= nil, "confession inbox is a stock FontString")
assert_eq(frame.ConfessionList._type, "FontString", "confession inbox is a FontString")
assert_true(findButton(frame, "SANCTION BEEF GORA") ~= nil, "SANCTION stays")
assert_true(findButton(frame, "Post Decree") ~= nil, "Post Decree stays")
assert_true(findButton(frame, "FREE RULING") ~= nil, "FREE RULING stays")
assert_true(findButton(frame, "MARK THIS MOMENT") ~= nil, "MARK THIS MOMENT stays")
assert_true(frame.ProposedBout ~= nil, "proposed bout stays")
assert_true(frame.FavorSplit ~= nil, "favor pane stays")

local noModule = Console:GetConfessions()
assert_eq(#noModule, 0, "GetConfessions is empty without a Confession module")
noModule[1] = { text = "injected" }
assert_eq(#Console:GetConfessions(), 0, "GetConfessions returns a copy when empty")
COB.Confession = {}
assert_eq(#Console:GetConfessions(), 0, "GetConfessions is empty when GetQueue is missing")
COB.Confession = nil
Console:Refresh()
assert_true((frame.ConfessionList:GetText() or ""):find("No confessions", 1, true) ~= nil,
  "empty inbox paints a stock empty line")

a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
local unnamed = Store:CreateCharacter({ name = "Brisket", class = "Rogue", level = 69 })
Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "victor",
  won = true,
}, 2100)
assert_eq(Store:GetCharacter(a.id).gora.headToHeads[1].wins, 1, "Store has petitioner H2H")
assert_true(Runtime:StartEvent() ~= nil, "petition H2H needs a live event")
Gora:Petition(a.id, b.id)
Gora:Petition(unnamed.id)
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
    brisket = { name = "Brisket", guildRankIndex = 6 },
  },
}
local namedPets = Console:GetPetitions()
assert_eq(#namedPets, 2, "named and unnamed petitions are present")
Console:Refresh()

local namedLine
local unnamedLine
walk(frame, function(child)
  if child._type == "Button" and child.GetText then
    local text = child:GetText() or ""
    if text:find("Chuckroast", 1, true) and text:find("names", 1, true) then
      namedLine = text
    end
    if text:find("Brisket", 1, true) and not text:find("names", 1, true) then
      unnamedLine = text
    end
  end
end)
assert_true(namedLine ~= nil, "named petition paints a row")
assert_true(namedLine:find("Chuckroast", 1, true) ~= nil, "named petition keeps the petitioner name")
assert_true(namedLine:find("Tendermage", 1, true) ~= nil, "named petition keeps the opponent name")
assert_true(namedLine:find("1-0", 1, true) ~= nil, "named petition appends mute numeric H2H")
assert_eq(namedLine:find("meeting", 1, true), nil, "H2H line has no meeting prose")
assert_eq(namedLine:find("demanded", 1, true), nil, "H2H line has no demanded prose")
assert_eq(namedLine:find("odds", 1, true), nil, "H2H line has no odds prose")
assert_true(unnamedLine ~= nil, "unnamed petition paints a row")
assert_eq(unnamedLine:find("1-0", 1, true), nil, "unnamed petition is name only")

Gora:Dismiss(a.id)
Gora:Petition(unnamed.id, a.id)
Console:Refresh()
local noHistLine
walk(frame, function(child)
  if child._type == "Button" and child.GetText then
    local text = child:GetText() or ""
    if text:find("Brisket", 1, true) and text:find("names", 1, true) then
      noHistLine = text
    end
  end
end)
assert_true(noHistLine ~= nil, "named petition without history still paints")
assert_eq(noHistLine:find("1-0", 1, true), nil, "no H2H row means names only")

local confessor = Store:CreateCharacter({ name = "Beefina", class = "Priest", level = 70 })
local liveQueue = {
  { characterId = confessor.id, text = "I ate the sacred brisket" },
}
COB.Confession = {
  GetQueue = function()
    return liveQueue
  end,
}
local queued = Console:GetConfessions()
assert_eq(#queued, 1, "GetConfessions returns the stubbed queue")
assert_eq(queued[1].characterId, confessor.id, "confession copy keeps the character id")
assert_eq(queued[1].text, "I ate the sacred brisket", "confession copy keeps the text")
queued[1].text = "mutated"
assert_eq(Console:GetConfessions()[1].text, "I ate the sacred brisket",
  "mutating a confession copy does not rewrite the queue")
assert_eq(liveQueue[1].text, "I ate the sacred brisket",
  "mutating a confession copy does not rewrite the stub")

local toastCalls = 0
local hudCalls = 0
local netCalls = 0
local savedToasts = COB.Toasts
local savedHudConf = COB.Hud
local savedNetConf = COB.Net
COB.Toasts = {
  Show = function()
    toastCalls = toastCalls + 1
  end,
}
COB.Hud = {
  Refresh = function()
    hudCalls = hudCalls + 1
  end,
}
COB.Net = {
  SendState = function()
    netCalls = netCalls + 1
  end,
  SendDecree = function()
    netCalls = netCalls + 1
  end,
}
local decreeBefore = Decree:Get()
Console:Refresh()
local inboxText = frame.ConfessionList:GetText() or ""
assert_true(inboxText:find("Beefina", 1, true) ~= nil, "inbox paints the confessor name")
assert_true(inboxText:find("I ate the sacred brisket", 1, true) ~= nil,
  "inbox paints the confession text")
assert_eq(toastCalls, 0, "Refresh does not send confession text to Toasts")
assert_eq(hudCalls, 0, "Refresh does not send confession text to Hud")
assert_eq(netCalls, 0, "Refresh does not send confession text to Net")
assert_eq(Decree:Get(), decreeBefore, "Refresh does not write confession text to Decree")
assert_eq((frame.DecreeLine:GetText() or ""):find("sacred brisket", 1, true), nil,
  "confession text does not leak into the Decree line")

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end
Gora:Petition(a.id)
Console:SelectCharacter(a.id)
assert_eq(Console:Dismiss(), true, "Dismiss still reaches Gora")
Gora:Petition(a.id)
Console:SelectCharacter(a.id)
stub.fire(findButton(frame, "Dismiss"), "OnClick")
local afterBtn = Console:GetPetitions()
local stillPetitioner = false
for i = 1, #afterBtn do
  if afterBtn[i].characterId == a.id then stillPetitioner = true end
end
assert_eq(stillPetitioner, false, "the Dismiss button still reaches Gora")
Sender.IsRegisteredPope = savedPred

COB.Toasts = savedToasts
COB.Hud = savedHudConf
COB.Net = savedNetConf
COB.Confession = nil
assert_eq(COB.Popes, nil, "still no Pope list after the inbox")

--------------------------------------------------------------------------------
-- B5-C: knighting line, Recommend, CallForward, zone FlagMoment. Stock only.
--------------------------------------------------------------------------------
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_true(findButton(frame, "KNIGHT THIS BEEF") ~= nil, "KNIGHT THIS BEEF stays a ritual plate")
assert_true(findButton(frame, "ELEVATE TO LORD") ~= nil, "ELEVATE TO LORD stays a ritual plate")
local enqueueBtn = findButton(frame, "Enqueue")
assert_true(enqueueBtn ~= nil, "Enqueue is a stock line button")
assert_eq(enqueueBtn._template, "UIPanelButtonTemplate", "Enqueue uses UIPanelButtonTemplate")
local skipBtn = findButton(frame, "Skip")
assert_true(skipBtn ~= nil, "Skip is a stock line button")
assert_eq(skipBtn._template, "UIPanelButtonTemplate", "Skip uses UIPanelButtonTemplate")
local recommendBtn = findButton(frame, "Recommend")
assert_true(recommendBtn ~= nil, "Recommend is a stock Gora button")
assert_eq(recommendBtn._template, "UIPanelButtonTemplate", "Recommend uses UIPanelButtonTemplate")
local callBtn = findButton(frame, "Call Forward")
assert_true(callBtn ~= nil, "Call Forward is a stock confession button")
assert_eq(callBtn._template, "UIPanelButtonTemplate", "Call Forward uses UIPanelButtonTemplate")

local function isRitual(btn)
  for i = 1, #(frame.RitualButtons or {}) do
    if frame.RitualButtons[i] == btn then return true end
  end
  return false
end
assert_eq(isRitual(enqueueBtn), false, "Enqueue is furniture, not a ritual plate")
assert_eq(isRitual(skipBtn), false, "Skip is furniture, not a ritual plate")
assert_eq(isRitual(recommendBtn), false, "Recommend is furniture, not a ritual plate")
assert_eq(isRitual(callBtn), false, "Call Forward is furniture, not a ritual plate")
assert_eq(isRitual(findButton(frame, "KNIGHT THIS BEEF")), true, "KNIGHT THIS BEEF stays ritual")
assert_eq(isRitual(findButton(frame, "ELEVATE TO LORD")), true, "ELEVATE TO LORD stays ritual")
assert_eq(isRitual(findButton(frame, "SANCTION BEEF GORA")), true, "SANCTION stays ritual")

Console:Refresh()
assert_eq(enqueueBtn:IsEnabled(), true, "Enqueue stays enabled when not the registered Pope")
assert_eq(skipBtn:IsEnabled(), true, "Skip stays enabled when not the registered Pope")
assert_eq(recommendBtn:IsEnabled(), true, "Recommend stays enabled when not the registered Pope")
assert_eq(callBtn:IsEnabled(), true, "Call Forward stays enabled when not the registered Pope")
assert_eq(findButton(frame, "KNIGHT THIS BEEF"):IsEnabled(), false, "ritual plates stay gated")

assert_true(frame.KnightingList ~= nil, "knighting line is a stock FontString")
assert_eq(frame.KnightingList._type, "FontString", "knighting line is a FontString")
assert_true(frame.Recommendation ~= nil, "recommendation line exists")
assert_eq(frame.Recommendation._type, "FontString", "recommendation is a FontString")
assert_eq(frame.Recommendation:GetText(), "", "recommendation starts empty")

local savedGetLine = Knighting.GetLine
Knighting.GetLine = nil
assert_eq(#Console:GetKnightingLine(), 0, "GetKnightingLine is empty without GetLine")
Knighting.GetLine = savedGetLine

local emptyLine = Console:GetKnightingLine()
emptyLine[1] = { humanId = 99 }
assert_eq(#Console:GetKnightingLine(), 0, "GetKnightingLine returns a copy when empty")

local okLine, errLine = Console:Enqueue()
assert_eq(okLine, nil, "Enqueue refuses when not the registered Pope")
assert_eq(errLine, "not the registered pope", "Enqueue refuse reason")
okLine, errLine = Console:Skip()
assert_eq(okLine, nil, "Skip refuses when not the registered Pope")
assert_eq(errLine, "not the registered pope", "Skip refuse reason")
okLine, errLine = Console:Recommend()
assert_eq(okLine, nil, "Recommend refuses when not the registered Pope")
assert_eq(errLine, "not the registered pope", "Recommend refuse reason")
okLine, errLine = Console:CallForward(1)
assert_eq(okLine, nil, "CallForward refuses when not the registered Pope")
assert_eq(errLine, "not the registered pope", "CallForward refuse reason")

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

local lineHuman = seedHuman("Steve", 2)
local alreadyKnight = seedHuman("Chuck", 3)
assert_true(Console:StartEvent() ~= nil, "line Enqueue needs a live event")
Console:SelectHuman(lineHuman.id)
local enqueued = Console:Enqueue()
assert_true(enqueued ~= nil, "Enqueue reaches Knighting")
local lined = Console:GetKnightingLine()
assert_eq(#lined, 1, "GetKnightingLine has the enqueued human")
assert_eq(lined[1].humanId, lineHuman.id, "line row keeps the human id")
assert_eq(lined[1].name, "Steve", "GetKnightingLine paints the Store name")
lined[1].name = "mutated"
assert_eq(Console:GetKnightingLine()[1].name, "Steve", "mutating a line copy does not rewrite Knighting")
Console:Refresh()
local lineText = frame.KnightingList:GetText() or ""
assert_true(lineText:find("Steve", 1, true) ~= nil, "Refresh paints the line name from Store")
assert_eq(lineText:find("demanded", 1, true), nil, "line paint has no demanded prose")

local skippedKnight, skipKnightErr = Console:Enqueue(alreadyKnight.id)
assert_eq(skippedKnight, nil, "Enqueue of a Knight is refused by Knighting")
assert_true(type(skipKnightErr) == "string", "already-knighted Enqueue returns an error string")
assert_eq(#Console:GetKnightingLine(), 1, "a Knight is not appended")

Console:SelectHuman(lineHuman.id)
stub.fire(findButton(frame, "Skip"), "OnClick")
assert_eq(#Console:GetKnightingLine(), 0, "the Skip button reaches Knighting")

Console:SelectHuman(lineHuman.id)
stub.fire(findButton(frame, "Enqueue"), "OnClick")
assert_eq(#Console:GetKnightingLine(), 1, "the Enqueue button reaches Knighting")
assert_true(Console:Skip() ~= nil, "Skip reaches Knighting")
assert_eq(#Console:GetKnightingLine(), 0, "Skip removes the human")

a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
local unnamedRec = Store:CreateCharacter({ name = "Brisket", class = "Rogue", level = 69 })
Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "victor",
  won = true,
}, 3100)
assert_eq(Store:GetCharacter(a.id).gora.headToHeads[1].wins, 1, "Store has recommend H2H")

local sanctionCalls = 0
local realSanction = Gora.Sanction
Gora.Sanction = function(self, ...)
  sanctionCalls = sanctionCalls + 1
  return realSanction(self, ...)
end

Console:SelectFighters(a.id, b.id)
local recSel = Console:Recommend()
assert_true(recSel ~= nil, "Recommend reaches Gora for the selected pair")
assert_eq(sanctionCalls, 0, "Recommend does not call Sanction")
assert_eq(Gora:GetSanctioned(), nil, "Recommend never sanctions")
assert_eq(Console.selectedFighterA, a.id, "Recommend keeps selected fighter A")
assert_eq(Console.selectedFighterB, b.id, "Recommend keeps selected fighter B")
assert_eq(Console:GetProposedBout().label, "Chuckroast vs Tendermage",
  "Recommend updates Proposed Bout")
Console:Refresh()
local recText = frame.Recommendation:GetText() or ""
assert_true(recText:find("Chuckroast", 1, true) ~= nil, "suggestion paints name A")
assert_true(recText:find("Tendermage", 1, true) ~= nil, "suggestion paints name B")
assert_true(recText:find("vs", 1, true) ~= nil, "suggestion is nameA vs nameB")
assert_true(recText:find("1-0", 1, true) ~= nil, "suggestion appends mute numeric H2H")
assert_eq(recText:find("demanded", 1, true), nil, "suggestion has no demanded prose")
assert_eq(recText:find("odds", 1, true), nil, "suggestion has no odds prose")
assert_eq(recText:find("meeting", 1, true), nil, "suggestion has no meeting prose")

Gora:Petition(unnamedRec.id)
Gora:Petition(a.id)
Gora:Petition(b.id)
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
    brisket = { name = "Brisket", guildRankIndex = 6 },
  },
}
Console:SelectFighters(nil, nil)
Gora:Dismiss(a.id)
Gora:Dismiss(b.id)
Gora:Dismiss(unnamedRec.id)
Gora:Petition(a.id)
Gora:Petition(b.id)
local recPets = Console:Recommend()
assert_true(recPets ~= nil, "Recommend uses the first two petitions")
assert_eq(sanctionCalls, 0, "petition Recommend does not call Sanction")
assert_eq(Gora:GetSanctioned(), nil, "petition Recommend never sanctions")
assert_eq(Console.selectedFighterA, a.id, "first petition becomes fighter A")
assert_eq(Console.selectedFighterB, b.id, "second petition becomes fighter B")

Gora:Dismiss(a.id)
Gora:Dismiss(b.id)
Console:SelectFighters(nil, nil)
Gora:Petition(b.id, a.id)
local recNamed = Console:Recommend()
assert_true(recNamed ~= nil, "Recommend uses a named opponent")
assert_eq(Console.selectedFighterA, b.id, "named petitioner is fighter A")
assert_eq(Console.selectedFighterB, a.id, "named opponent is fighter B")
assert_eq(Gora:GetSanctioned(), nil, "named Recommend never sanctions")

Console:SelectFighters(a.id, b.id)
local recKeep = Console:Recommend()
assert_true(recKeep ~= nil, "selected fighters win over petitions")
assert_eq(Console.selectedFighterA, a.id, "selected pair is not replaced by a named petition")
assert_eq(Console.selectedFighterB, b.id, "selected pair B stays")
stub.fire(findButton(frame, "Recommend"), "OnClick")
assert_eq(sanctionCalls, 0, "the Recommend button does not call Sanction")
assert_eq(Gora:GetSanctioned(), nil, "the Recommend button never sanctions")
Gora.Sanction = realSanction

local callId = nil
local callCount = 0
local savedConfession = COB.Confession
COB.Confession = {
  CallForward = function(_, characterId)
    callCount = callCount + 1
    callId = characterId
    return true
  end,
  GetQueue = function()
    return {}
  end,
}
local nSoundRec = 0
local soundRec = {}
local savedSoundRec = COB.Sound
local savedToastsRec = COB.Toasts
local savedChatRec = SendChatMessage
COB.Sound = {
  Play = function(_, name)
    soundRec[#soundRec + 1] = name
    return name
  end,
}
COB.Toasts = {
  Show = function()
    nSoundRec = nSoundRec + 1
  end,
}
local chats = 0
SendChatMessage = function()
  chats = chats + 1
end
local called = Console:CallForward(a.id)
assert_eq(called, true, "CallForward reaches Confession")
assert_eq(callCount, 1, "CallForward is one mark")
assert_eq(callId, a.id, "CallForward forwards the character id")
assert_eq(#soundRec, 0, "CallForward does not play Sound")
assert_eq(nSoundRec, 0, "CallForward does not toast")
assert_eq(chats, 0, "CallForward does not SendChatMessage")
Console:SelectCharacter(b.id)
stub.fire(findButton(frame, "Call Forward"), "OnClick")
assert_eq(callId, b.id, "the Call Forward button uses the selected character")
assert_eq(#soundRec, 0, "the Call Forward button does not play Sound")
assert_eq(chats, 0, "the Call Forward button does not SendChatMessage")

nSoundRec = #soundRec
assert_true(Console:Enqueue(lineHuman.id) ~= nil, "Enqueue succeeds with Sound stubbed")
assert_eq(#soundRec, nSoundRec, "Enqueue does not play Sound")
assert_true(Console:Skip(lineHuman.id) ~= nil, "Skip succeeds with Sound stubbed")
assert_eq(#soundRec, nSoundRec, "Skip does not play Sound")
assert_true(Console:Recommend(a.id, b.id) ~= nil, "Recommend succeeds with Sound stubbed")
assert_eq(#soundRec, nSoundRec, "Recommend does not play Sound")

local savedZone = GetSubZoneText
GetSubZoneText = function()
  return "  Goldshire Inn  "
end
local zoned = Console:FlagMoment()
assert_true(zoned ~= nil, "FlagMoment with GetSubZoneText reaches Store")
assert_eq(zoned.location, "Goldshire Inn", "FlagMoment trims GetSubZoneText")
assert_eq(Store:GetMarkedMoments()[#Store:GetMarkedMoments()].location, "Goldshire Inn",
  "Store keeps the trimmed zone")

GetSubZoneText = function()
  return "   "
end
local blankZone = Console:FlagMoment()
assert_true(blankZone ~= nil, "empty GetSubZoneText still flags")
assert_eq(blankZone.location, nil, "empty GetSubZoneText becomes nil")

GetSubZoneText = function()
  return "Elwynn Forest"
end
local explicitZone = Console:FlagMoment("  Lions Pride  ")
assert_eq(explicitZone.location, "Lions Pride", "an explicit location wins over GetSubZoneText")

GetSubZoneText = savedZone
COB.Sound = savedSoundRec
COB.Toasts = savedToastsRec
SendChatMessage = savedChatRec
COB.Confession = savedConfession
Sender.IsRegisteredPope = savedPred
assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B5-C")
assert_eq(COB.Popes, nil, "still no Pope list after B5-C")
assert_eq(stubbedKnightingLine or type(Knighting.GetLine) == "function", true,
  "line API is stubbed or real")

--------------------------------------------------------------------------------
-- B6-A: GRANT HONORIFIC + Recognition Begin/Complete/Cancel. Pope only.
--------------------------------------------------------------------------------
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.LinkSelf, nil, "no self-service link")
assert_eq(Console.LinkCharacter, nil, "LinkCharacter is not a console verb")
assert_eq(Console.ConfirmCouncil, nil, "no Council confirmer verb")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "Council"), nil, "no Council button")
assert_eq(findButton(frame, "Council Confirm"), nil, "no Council Confirm button")
assert_eq(findButton(frame, "Confirm as Council"), nil, "no Council confirmer button")

local honorBtn = findButton(frame, "GRANT HONORIFIC")
assert_true(honorBtn ~= nil, "GRANT HONORIFIC is one click")
assert_eq(honorBtn._template, "UIPanelButtonTemplate", "GRANT HONORIFIC uses UIPanelButtonTemplate")
local beginBtn = findButton(frame, "Begin Recognition")
assert_true(beginBtn ~= nil, "Begin Recognition is one click")
assert_eq(beginBtn._template, "UIPanelButtonTemplate", "Begin Recognition uses UIPanelButtonTemplate")
local completeBtn = findButton(frame, "Complete Recognition")
assert_true(completeBtn ~= nil, "Complete Recognition is one click")
assert_eq(completeBtn._template, "UIPanelButtonTemplate", "Complete Recognition uses UIPanelButtonTemplate")
local cancelBtn = findButton(frame, "Cancel Recognition")
assert_true(cancelBtn ~= nil, "Cancel Recognition is one click")
assert_eq(cancelBtn._template, "UIPanelButtonTemplate", "Cancel Recognition uses UIPanelButtonTemplate")

assert_true(frame.HonorificText ~= nil, "honorific is a stock EditBox")
assert_eq(frame.HonorificText._type, "EditBox", "honorific box is an EditBox")
assert_eq(frame.HonorificText._template, "InputBoxTemplate", "honorific box is InputBoxTemplate")
assert_eq(frame.HonorificText._autoFocus, false, "honorific box does not steal focus")
assert_eq(countType(frame, "EditBox"), 7, "archive and canonize are the sixth and seventh stock EditBoxes")

local function isRitualB6(btn)
  for i = 1, #(frame.RitualButtons or {}) do
    if frame.RitualButtons[i] == btn then return true end
  end
  return false
end
assert_eq(isRitualB6(honorBtn), true, "GRANT HONORIFIC is a ritual plate")
assert_eq(isRitualB6(beginBtn), true, "Begin Recognition is a ritual plate")
assert_eq(isRitualB6(completeBtn), true, "Complete Recognition is a ritual plate")
assert_eq(isRitualB6(cancelBtn), true, "Cancel Recognition is a ritual plate")
assert_eq(isRitualB6(findButton(frame, "KNIGHT THIS BEEF")), true, "KNIGHT THIS BEEF stays ritual")
assert_eq(isRitualB6(findButton(frame, "Recommend")), false, "Recommend stays furniture")

Console:Refresh()
assert_eq(honorBtn:IsEnabled(), false, "GRANT HONORIFIC stays gated")
assert_eq(beginBtn:IsEnabled(), false, "Begin Recognition stays gated")
assert_eq(findButton(frame, "KNIGHT THIS BEEF"):IsEnabled(), false, "existing ritual plates stay gated")
assert_eq(findButton(frame, "Recommend"):IsEnabled(), true, "Recommend stays furniture")

local honorHuman = seedHuman("Steve", 2)
local honorChar = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
Store:LinkCharacter(honorChar.id, honorHuman.id, 4100)

local addCalls = 0
local realAddHonor = Store.AddHonorific
Store.AddHonorific = function(self, ...)
  addCalls = addCalls + 1
  return realAddHonor(self, ...)
end

local okHonor, errHonor = Console:GrantHonorific(honorHuman.id, "Duke of the Fountain")
assert_eq(okHonor, nil, "GrantHonorific refuses when not the registered Pope")
assert_eq(errHonor, "not the registered pope", "GrantHonorific refuse reason")
assert_eq(addCalls, 0, "Store:AddHonorific is not called when refused")
assert_eq(#Store:GetHuman(honorHuman.id).honorifics, 0, "refused grant does not write")

okHonor, errHonor = Console:BeginRecognition(honorHuman.id, honorChar.id)
assert_eq(okHonor, nil, "BeginRecognition refuses when not the registered Pope")
assert_eq(errHonor, "not the registered pope", "BeginRecognition refuse reason")
okHonor, errHonor = Console:CompleteRecognition()
assert_eq(okHonor, nil, "CompleteRecognition refuses when not the registered Pope")
assert_eq(errHonor, "not the registered pope", "CompleteRecognition refuse reason")
okHonor, errHonor = Console:CancelRecognition()
assert_eq(okHonor, nil, "CancelRecognition refuses when not the registered Pope")
assert_eq(errHonor, "not the registered pope", "CancelRecognition refuse reason")

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

local priorRecognition = COB.Recognition
COB.Recognition = nil

okHonor, errHonor = Console:BeginRecognition(honorHuman.id, honorChar.id)
assert_eq(okHonor, nil, "BeginRecognition refuses when Recognition is missing")
assert_true(type(errHonor) == "string", "missing Recognition returns a refuse string")
okHonor, errHonor = Console:CompleteRecognition()
assert_eq(okHonor, nil, "CompleteRecognition refuses when Recognition is missing")
assert_true(type(errHonor) == "string", "missing Complete Recognition returns a refuse string")
okHonor, errHonor = Console:CancelRecognition()
assert_eq(okHonor, nil, "CancelRecognition refuses when Recognition is missing")
assert_true(type(errHonor) == "string", "missing Cancel Recognition returns a refuse string")

local granted = Console:GrantHonorific(honorHuman.id, "Duke of the Fountain")
assert_true(granted ~= nil, "GrantHonorific writes Store when Pope")
assert_eq(addCalls, 1, "GrantHonorific calls Store:AddHonorific once")
assert_eq(#Store:GetHuman(honorHuman.id).honorifics, 1, "honorific is appended")
assert_eq(Store:GetHuman(honorHuman.id).honorifics[1], "Duke of the Fountain",
  "honorific text is stored as given")
assert_eq(granted.honorifics[1], "Duke of the Fountain", "GrantHonorific returns the Store human")

frame.HonorificText:SetText("  Defender of the Faith  ")
Console:SelectHuman(honorHuman.id)
local boxedHonor = Console:GrantHonorific()
assert_true(boxedHonor ~= nil, "GrantHonorific reads the box when text is omitted")
assert_eq(Store:GetHuman(honorHuman.id).honorifics[2], "Defender of the Faith",
  "box text is trimmed")
assert_eq(addCalls, 2, "box grant calls Store:AddHonorific")

frame.HonorificText:SetText("box leftover")
local explicitHonor = Console:GrantHonorific(honorHuman.id, "Martyr of Goldshire")
assert_eq(explicitHonor.honorifics[3], "Martyr of Goldshire",
  "an explicit GrantHonorific argument wins over the box")

local beforeEmpty = #Store:GetHuman(honorHuman.id).honorifics
okHonor, errHonor = Console:GrantHonorific(honorHuman.id, "")
assert_eq(okHonor, nil, "empty honorific is refused")
assert_true(type(errHonor) == "string", "empty honorific returns an error string")
assert_eq(addCalls, 3, "empty honorific does not call Store")
assert_eq(#Store:GetHuman(honorHuman.id).honorifics, beforeEmpty, "empty honorific is not appended")

okHonor, errHonor = Console:GrantHonorific(honorHuman.id, "   ")
assert_eq(okHonor, nil, "whitespace honorific is refused")
assert_eq(addCalls, 3, "whitespace honorific does not call Store")

okHonor, errHonor = Console:GrantHonorific(honorHuman.id, "Duke\nof the Fountain")
assert_eq(okHonor, nil, "embedded newline honorific is refused")
assert_true(type(errHonor) == "string", "newline honorific returns an error string")
assert_eq(addCalls, 3, "newline honorific does not call Store")
assert_eq(#Store:GetHuman(honorHuman.id).honorifics, beforeEmpty, "newline honorific is not appended")

frame.HonorificText:SetText("")
okHonor, errHonor = Console:GrantHonorific(honorHuman.id)
assert_eq(okHonor, nil, "empty box honorific is refused")
assert_eq(addCalls, 3, "empty box does not call Store")

frame.HonorificText:SetText("Iron Chin")
Console:SelectHuman(honorHuman.id)
stub.fire(findButton(frame, "GRANT HONORIFIC"), "OnClick")
assert_eq(Store:GetHuman(honorHuman.id).honorifics[4], "Iron Chin",
  "the GRANT HONORIFIC button reads the box")
Store.AddHonorific = realAddHonor

local beginArgs = {}
local completeCalls = 0
local cancelCalls = 0
local savedUnitName = UnitName
COB.Recognition = {
  Begin = function(_, humanId, characterId, role, now)
    beginArgs = { humanId = humanId, characterId = characterId, role = role, now = now }
    return {
      humanId = humanId,
      characterId = characterId,
      confirmerRole = role,
    }
  end,
  Complete = function()
    completeCalls = completeCalls + 1
    return true
  end,
  Cancel = function()
    cancelCalls = cancelCalls + 1
    return true
  end,
}
UnitName = function()
  return "Impostor"
end

Console:SelectHuman(honorHuman.id)
Console:SelectCharacter(honorChar.id)
local begun = Console:BeginRecognition()
assert_true(begun ~= nil, "BeginRecognition reaches Recognition")
assert_eq(beginArgs.humanId, honorHuman.id, "BeginRecognition uses the selected human")
assert_eq(beginArgs.characterId, honorChar.id, "BeginRecognition uses the selected character")
assert_eq(beginArgs.role, "pope", "BeginRecognition spies role pope")
assert_eq(beginArgs.role == "pope", true, "BeginRecognition never passes another confirmer")
assert_eq(begun.confirmerRole, "pope", "returned session confirmer is pope")

local otherHuman = seedHuman("Dave", 1)
local otherChar = Store:CreateCharacter({ name = "Brisket", class = "Rogue", level = 69 })
local begunExplicit = Console:BeginRecognition(otherHuman.id, otherChar.id)
assert_eq(beginArgs.humanId, otherHuman.id, "explicit human wins over selection")
assert_eq(beginArgs.characterId, otherChar.id, "explicit character wins over selection")
assert_eq(beginArgs.role, "pope", "explicit BeginRecognition still passes pope")
assert_eq(begunExplicit.characterId, otherChar.id, "UnitName is not consulted")

local soundId = {}
local savedSoundHonor = COB.Sound
COB.Sound = {
  Play = function(_, name)
    soundId[#soundId + 1] = name
    return name
  end,
}
local nSoundHonor = #soundId
assert_true(Console:CompleteRecognition() ~= nil, "CompleteRecognition reaches Recognition")
assert_eq(completeCalls, 1, "CompleteRecognition is one call")
assert_eq(#soundId, nSoundHonor, "CompleteRecognition does not play Sound")
assert_true(Console:CancelRecognition() ~= nil, "CancelRecognition reaches Recognition")
assert_eq(cancelCalls, 1, "CancelRecognition is one call")
assert_eq(#soundId, nSoundHonor, "CancelRecognition does not play Sound")
assert_true(Console:GrantHonorific(honorHuman.id, "Quiet Knight") ~= nil,
  "GrantHonorific succeeds with Sound stubbed")
assert_eq(#soundId, nSoundHonor, "GrantHonorific does not play Sound")
assert_true(Console:BeginRecognition(honorHuman.id, honorChar.id) ~= nil,
  "BeginRecognition succeeds with Sound stubbed")
assert_eq(#soundId, nSoundHonor, "BeginRecognition does not play Sound")

stub.fire(findButton(frame, "Begin Recognition"), "OnClick")
assert_eq(beginArgs.role, "pope", "the Begin Recognition button passes pope")
assert_eq(#soundId, nSoundHonor, "the Begin Recognition button does not play Sound")
stub.fire(findButton(frame, "Complete Recognition"), "OnClick")
assert_eq(completeCalls, 2, "the Complete Recognition button reaches Recognition")
assert_eq(#soundId, nSoundHonor, "the Complete Recognition button does not play Sound")
stub.fire(findButton(frame, "Cancel Recognition"), "OnClick")
assert_eq(cancelCalls, 2, "the Cancel Recognition button reaches Recognition")
assert_eq(#soundId, nSoundHonor, "the Cancel Recognition button does not play Sound")

assert_eq(frame:GetScript("OnUpdate"), nil, "no duration timer OnUpdate")
local srcHonor = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcHonor ~= nil, "Console.lua is readable for B6-A")
local srcHonorBody = srcHonor:read("*a")
srcHonor:close()
assert_eq(srcHonorBody:find("C_Timer", 1, true), nil, "no C_Timer auto-Complete")
assert_eq(srcHonorBody:find("WHISPER ALL", 1, true), nil, "source must not contain WHISPER ALL")
assert_eq(srcHonorBody:find('"council"', 1, true), nil, "source must not pass a council confirmer")

UnitName = savedUnitName
COB.Sound = savedSoundHonor
COB.Recognition = priorRecognition
Sender.IsRegisteredPope = savedPred
Store.AddHonorific = realAddHonor
assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B6-A")
if standalone then
  assert_eq(COB.Recognition, nil, "isolation still does not load Recognition")
end
assert_eq(COB.Popes, nil, "still no Pope list after B6-A")

--------------------------------------------------------------------------------
-- B7-B: Archive export/import, CanonizeMoment, FlagFamousUpset. Stock only.
-- Nested function keeps this block under Lua 5.1's 200-local main-chunk cap.
--------------------------------------------------------------------------------
local function runB7B()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")

local exportBtn = findButton(frame, "EXPORT ARCHIVE")
assert_true(exportBtn ~= nil, "EXPORT ARCHIVE is one click")
assert_eq(exportBtn._template, "UIPanelButtonTemplate", "EXPORT ARCHIVE uses UIPanelButtonTemplate")
local importBtn = findButton(frame, "IMPORT ARCHIVE")
assert_true(importBtn ~= nil, "IMPORT ARCHIVE is one click")
assert_eq(importBtn._template, "UIPanelButtonTemplate", "IMPORT ARCHIVE uses UIPanelButtonTemplate")
local canonBtn = findButton(frame, "CANONIZE")
assert_true(canonBtn ~= nil, "CANONIZE is one click")
assert_eq(canonBtn._template, "UIPanelButtonTemplate", "CANONIZE uses UIPanelButtonTemplate")
local upsetBtn = findButton(frame, "FLAG UPSET")
assert_true(upsetBtn ~= nil, "FLAG UPSET is one click")
assert_eq(upsetBtn._template, "UIPanelButtonTemplate", "FLAG UPSET uses UIPanelButtonTemplate")

assert_true(frame.ArchiveBox ~= nil, "ArchiveBox is a stock EditBox")
assert_eq(frame.ArchiveBox._type, "EditBox", "ArchiveBox is an EditBox")
assert_eq(frame.ArchiveBox._template, "InputBoxTemplate", "ArchiveBox is InputBoxTemplate")
assert_eq(frame.ArchiveBox._autoFocus, false, "ArchiveBox does not steal focus")
assert_true(frame.CanonizeText ~= nil, "canonize is a stock EditBox")
assert_eq(frame.CanonizeText._type, "EditBox", "canonize box is an EditBox")
assert_eq(frame.CanonizeText._template, "InputBoxTemplate", "canonize box is InputBoxTemplate")
assert_eq(frame.CanonizeText._autoFocus, false, "canonize box does not steal focus")
assert_eq(countType(frame, "EditBox"), 7, "ArchiveBox and CanonizeText are stock EditBoxes")

local function isRitualB7(btn)
  for i = 1, #(frame.RitualButtons or {}) do
    if frame.RitualButtons[i] == btn then return true end
  end
  return false
end
assert_eq(isRitualB7(exportBtn), true, "EXPORT ARCHIVE is a ritual plate")
assert_eq(isRitualB7(importBtn), true, "IMPORT ARCHIVE is a ritual plate")
assert_eq(isRitualB7(canonBtn), true, "CANONIZE is a ritual plate")
assert_eq(isRitualB7(upsetBtn), true, "FLAG UPSET is a ritual plate")
assert_eq(isRitualB7(findButton(frame, "KNIGHT THIS BEEF")), true, "KNIGHT THIS BEEF stays ritual")
assert_eq(isRitualB7(findButton(frame, "Recommend")), false, "Recommend stays furniture")

Console:Refresh()
assert_eq(exportBtn:IsEnabled(), false, "EXPORT ARCHIVE stays gated")
assert_eq(importBtn:IsEnabled(), false, "IMPORT ARCHIVE stays gated")
assert_eq(canonBtn:IsEnabled(), false, "CANONIZE stays gated")
assert_eq(upsetBtn:IsEnabled(), false, "FLAG UPSET stays gated")
assert_eq(findButton(frame, "Recommend"):IsEnabled(), true, "Recommend stays furniture")

local srcArchive = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcArchive ~= nil, "Console.lua is readable for B7-B")
local srcArchiveBody = srcArchive:read("*a")
srcArchive:close()
assert_eq(srcArchiveBody:find("WHISPER ALL", 1, true), nil, "source must not contain WHISPER ALL")
assert_eq(srcArchiveBody:find("SUMMON THE FAITHFUL", 1, true), nil, "source must not contain SUMMON")
assert_eq(srcArchiveBody:find("Knighted:", 1, true), nil, "source must not contain a ceremony summary")
assert_eq(srcArchiveBody:find("CopyCeremonySummary", 1, true), nil, "source must not copy a ceremony summary")

local exportCalls = 0
local importCalls = 0
local checkCalls = 0
local lastCheckBlob
local lastImportBlob
local lastExportBlob = "COBARCHIVE:test-blob"
local archiveCheckOk = true
local archiveCheckErr = "bad archive"

local priorArchive = COB.Archive
COB.Archive = nil

local okArch, errArch = Console:ExportArchive()
assert_eq(okArch, nil, "ExportArchive refuses when not the registered Pope")
assert_eq(errArch, "not the registered pope", "ExportArchive refuse reason")
okArch, errArch = Console:ImportArchive("x")
assert_eq(okArch, nil, "ImportArchive refuses when not the registered Pope")
assert_eq(errArch, "not the registered pope", "ImportArchive refuse reason")
okArch, errArch = Console:CanonizeMoment(1, "so sealed")
assert_eq(okArch, nil, "CanonizeMoment refuses when not the registered Pope")
assert_eq(errArch, "not the registered pope", "CanonizeMoment refuse reason")
okArch, errArch = Console:FlagFamousUpset(1, 2)
assert_eq(okArch, nil, "FlagFamousUpset refuses when not the registered Pope")
assert_eq(errArch, "not the registered pope", "FlagFamousUpset refuse reason")

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

okArch, errArch = Console:ExportArchive()
assert_eq(okArch, nil, "ExportArchive refuses when Archive is missing")
assert_true(type(errArch) == "string", "missing Archive export returns a refuse string")
okArch, errArch = Console:ImportArchive("x")
assert_eq(okArch, nil, "ImportArchive refuses when Archive is missing")
assert_true(type(errArch) == "string", "missing Archive import returns a refuse string")

frame.ArchiveBox:SetText("keep-me")
okArch, errArch = Console:ExportArchive()
assert_eq(okArch, nil, "missing Archive export still refuses")
assert_eq(frame.ArchiveBox:GetText(), "keep-me", "missing Archive does not wipe the box")

local lastCanonize
local canonizeCalls = 0
local savedCanonize = Store.CanonizeMoment
Store.CanonizeMoment = function(self, momentId, text)
  canonizeCalls = canonizeCalls + 1
  lastCanonize = { momentId = momentId, text = text }
  if type(savedCanonize) == "function" then
    return savedCanonize(self, momentId, text)
  end
  return { id = momentId, scripture = text }
end

local lastUpset
local upsetCalls = 0
local savedUpset = Store.FlagFamousUpset
Store.FlagFamousUpset = function(self, characterId, opponentId)
  upsetCalls = upsetCalls + 1
  lastUpset = { characterId = characterId, opponentId = opponentId }
  if type(savedUpset) == "function" then
    return savedUpset(self, characterId, opponentId)
  end
  return { characterId = characterId, opponentId = opponentId, famousUpset = true }
end

local reachMoment = Store:FlagMoment("Shattrath")
okArch, errArch = Console:CanonizeMoment(reachMoment.id, "so sealed")
assert_true(okArch ~= nil, "CanonizeMoment reaches Store when Pope")
assert_eq(canonizeCalls, 1, "CanonizeMoment calls Store:CanonizeMoment")
assert_eq(lastCanonize.momentId, reachMoment.id, "CanonizeMoment forwards the moment id")
assert_eq(lastCanonize.text, "so sealed", "CanonizeMoment forwards the text")

a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "victor",
  won = true,
}, 5100)
okArch, errArch = Console:FlagFamousUpset(a.id, b.id)
assert_true(okArch ~= nil, "FlagFamousUpset reaches Store when Pope")
assert_eq(upsetCalls, 1, "FlagFamousUpset calls Store:FlagFamousUpset")
assert_eq(lastUpset.characterId, a.id, "FlagFamousUpset forwards the victor")
assert_eq(lastUpset.opponentId, b.id, "FlagFamousUpset forwards the opponent")

COB.Archive = {
  Export = function()
    exportCalls = exportCalls + 1
    return lastExportBlob
  end,
  Check = function(_, blob)
    checkCalls = checkCalls + 1
    lastCheckBlob = blob
    if archiveCheckOk then return true end
    return nil, archiveCheckErr
  end,
  Import = function(_, blob)
    importCalls = importCalls + 1
    lastImportBlob = blob
    return { ok = true }
  end,
}

local clip = {}
local savedClip = CopyToClipboard
CopyToClipboard = function(text)
  clip[#clip + 1] = text
  return #tostring(text)
end

frame.ArchiveBox:SetText("")
local exported = Console:ExportArchive()
assert_eq(exported, lastExportBlob, "ExportArchive returns the Archive blob")
assert_eq(exportCalls, 1, "ExportArchive calls Archive:Export")
assert_eq(frame.ArchiveBox:GetText(), lastExportBlob, "ExportArchive fills ArchiveBox")
assert_eq(#clip, 1, "ExportArchive copies the blob when CopyToClipboard exists")
assert_eq(clip[1], lastExportBlob, "CopyToClipboard receives the blob only")

CopyToClipboard = nil
lastExportBlob = "COBARCHIVE:no-clip"
local exportedNoClip = Console:ExportArchive()
assert_eq(exportedNoClip, "COBARCHIVE:no-clip", "ExportArchive still returns the blob")
assert_eq(frame.ArchiveBox:GetText(), "COBARCHIVE:no-clip", "missing CopyToClipboard still fills the box")
assert_eq(#clip, 1, "missing CopyToClipboard does not invent a copy")

CopyToClipboard = function()
  error("clipboard exploded")
end
lastExportBlob = "COBARCHIVE:pcall"
local exportedPcall = Console:ExportArchive()
assert_eq(exportedPcall, "COBARCHIVE:pcall", "CopyToClipboard errors do not fail export")
assert_eq(frame.ArchiveBox:GetText(), "COBARCHIVE:pcall", "pcall failure still fills the box")

CopyToClipboard = function(text)
  clip[#clip + 1] = text
  return #tostring(text)
end

frame.ArchiveBox:SetText("box-blob")
local imported = Console:ImportArchive()
assert_true(imported ~= nil, "ImportArchive reaches Archive")
assert_eq(checkCalls, 1, "ImportArchive calls Check first")
assert_eq(importCalls, 1, "ImportArchive calls Import after Check")
assert_eq(lastCheckBlob, "box-blob", "ImportArchive Check reads the box")
assert_eq(lastImportBlob, "box-blob", "ImportArchive Import reads the box")

local importedArg = Console:ImportArchive("arg-blob")
assert_true(importedArg ~= nil, "ImportArchive accepts an explicit blob")
assert_eq(lastCheckBlob, "arg-blob", "explicit blob wins over the box for Check")
assert_eq(lastImportBlob, "arg-blob", "explicit blob wins over the box for Import")
assert_eq(checkCalls, 2, "explicit ImportArchive still Checks")
assert_eq(importCalls, 2, "explicit ImportArchive still Imports")

archiveCheckOk = false
frame.ArchiveBox:SetText("bad-blob")
local beforeHumans = #Store:Snapshot().humans
local badImport, badImportErr = Console:ImportArchive()
assert_eq(badImport, nil, "bad blob ImportArchive is refused")
assert_true(type(badImportErr) == "string", "bad blob returns an error string")
assert_eq(checkCalls, 3, "bad blob still Calls Check")
assert_eq(importCalls, 2, "bad blob does not call Import")
assert_eq(frame.ArchiveBox:GetText(), "bad-blob", "bad blob does not wipe the box")
assert_eq(#Store:Snapshot().humans, beforeHumans, "bad blob does not wipe the store")
archiveCheckOk = true

local firstMoment = Store:FlagMoment("Goldshire Inn")
local secondMoment = Store:FlagMoment("Lions Pride")
assert_true(firstMoment ~= nil, "two marked moments for latest-id pin")
assert_true(secondMoment ~= nil, "second marked moment exists")
frame.CanonizeText:SetText("  so sealed from the box  ")
local boxedCanon = Console:CanonizeMoment()
assert_true(boxedCanon ~= nil, "CanonizeMoment uses the latest moment and the box")
assert_eq(lastCanonize.momentId, secondMoment.id, "omitted momentId is the latest marked moment")
assert_eq(lastCanonize.text, "  so sealed from the box  ", "omitted text is the box text")

frame.CanonizeText:SetText("box leftover")
local explicitCanon = Console:CanonizeMoment(firstMoment.id, "explicit scripture")
assert_eq(lastCanonize.momentId, firstMoment.id, "explicit momentId wins over latest")
assert_eq(lastCanonize.text, "explicit scripture", "explicit text wins over the box")

Console:SelectFighters(a.id, b.id)
Console:SelectCharacter(nil)
local upsetDefault = Console:FlagFamousUpset()
assert_true(upsetDefault ~= nil, "FlagFamousUpset defaults to the proposed bout")
assert_eq(lastUpset.characterId, a.id, "unset selected character uses fighterA as victor")
assert_eq(lastUpset.opponentId, b.id, "unset selected character uses fighterB as opponent")

Console:SelectFighters(a.id, b.id)
Console:SelectCharacter(b.id)
local upsetSel = Console:FlagFamousUpset()
assert_eq(lastUpset.characterId, b.id, "selected character is the victor")
assert_eq(lastUpset.opponentId, a.id, "the other proposed fighter is the opponent")

Console:SelectFighters(b.id, a.id)
Console:SelectCharacter(a.id)
local upsetSelA = Console:FlagFamousUpset()
assert_eq(lastUpset.characterId, a.id, "selected character still wins when it is fighterB")
assert_eq(lastUpset.opponentId, b.id, "opponent is the other selected fighter")

Console:SelectFighters(a.id, b.id)
Console:SelectCharacter(b.id)
local upsetExplicit = Console:FlagFamousUpset(a.id, b.id)
assert_eq(lastUpset.characterId, a.id, "explicit FlagFamousUpset character wins over selection")
assert_eq(lastUpset.opponentId, b.id, "explicit FlagFamousUpset opponent wins over selection")

local savedSoundArch = COB.Sound
local savedToastsArch = COB.Toasts
local savedChatArch = SendChatMessage
local soundArch = {}
local toastArch = 0
local chatsArch = 0
local clipBefore = #clip
COB.Sound = {
  Play = function(_, name)
    soundArch[#soundArch + 1] = name
    return name
  end,
}
COB.Toasts = {
  Show = function()
    toastArch = toastArch + 1
  end,
}
SendChatMessage = function()
  chatsArch = chatsArch + 1
end

lastExportBlob = "COBARCHIVE:quiet"
assert_true(Console:ExportArchive() ~= nil, "ExportArchive succeeds with Sound stubbed")
assert_eq(#soundArch, 0, "ExportArchive does not play Sound")
assert_eq(toastArch, 0, "ExportArchive does not toast")
assert_eq(chatsArch, 0, "ExportArchive does not SendChatMessage")
assert_eq(#clip, clipBefore + 1, "quiet ExportArchive still copies the archive blob only")
assert_eq(clip[#clip], "COBARCHIVE:quiet", "quiet copy is the archive blob")

assert_true(Console:ImportArchive("quiet-blob") ~= nil, "ImportArchive succeeds with Sound stubbed")
assert_eq(#soundArch, 0, "ImportArchive does not play Sound")
assert_eq(toastArch, 0, "ImportArchive does not toast")
assert_eq(chatsArch, 0, "ImportArchive does not SendChatMessage")
assert_eq(#clip, clipBefore + 1, "ImportArchive does not CopyToClipboard")

assert_true(Console:CanonizeMoment(secondMoment.id, "quiet scripture") ~= nil,
  "CanonizeMoment succeeds with Sound stubbed")
assert_eq(#soundArch, 0, "CanonizeMoment does not play Sound")
assert_eq(toastArch, 0, "CanonizeMoment does not toast")
assert_eq(chatsArch, 0, "CanonizeMoment does not SendChatMessage")

assert_true(Console:FlagFamousUpset(a.id, b.id) ~= nil, "FlagFamousUpset succeeds with Sound stubbed")
assert_eq(#soundArch, 0, "FlagFamousUpset does not play Sound")
assert_eq(toastArch, 0, "FlagFamousUpset does not toast")
assert_eq(chatsArch, 0, "FlagFamousUpset does not SendChatMessage")

stub.fire(findButton(frame, "EXPORT ARCHIVE"), "OnClick")
assert_eq(#soundArch, 0, "the EXPORT ARCHIVE button does not play Sound")
stub.fire(findButton(frame, "CANONIZE"), "OnClick")
assert_eq(#soundArch, 0, "the CANONIZE button does not play Sound")
stub.fire(findButton(frame, "FLAG UPSET"), "OnClick")
assert_eq(#soundArch, 0, "the FLAG UPSET button does not play Sound")
stub.fire(findButton(frame, "IMPORT ARCHIVE"), "OnClick")
assert_eq(#soundArch, 0, "the IMPORT ARCHIVE button does not play Sound")
assert_eq(chatsArch, 0, "B7-B buttons do not SendChatMessage")

CopyToClipboard = savedClip
COB.Sound = savedSoundArch
COB.Toasts = savedToastsArch
SendChatMessage = savedChatArch
Store.CanonizeMoment = savedCanonize
Store.FlagFamousUpset = savedUpset
COB.Archive = priorArchive
Sender.IsRegisteredPope = savedPred
assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B7-B")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
end
assert_eq(COB.Popes, nil, "still no Pope list after B7-B")
end
runB7B()

--------------------------------------------------------------------------------
-- B8-E: ArchiveBox multiline + stock ARCHIVE / CANONIZE labels.
-- Nested function keeps this block under Lua 5.1's 200-local main-chunk cap.
--------------------------------------------------------------------------------
local function runB8E()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")

assert_true(frame.ArchiveBox ~= nil, "ArchiveBox still exists")
assert_eq(frame.ArchiveBox._type, "EditBox", "ArchiveBox stays an EditBox")
assert_eq(frame.ArchiveBox._template, "InputBoxTemplate", "ArchiveBox stays InputBoxTemplate")
assert_eq(frame.ArchiveBox._autoFocus, false, "ArchiveBox does not steal focus")
assert_eq(frame.ArchiveBox._multiline, true, "ArchiveBox is multiline")
assert_true(frame.ArchiveBox:GetHeight() > 22, "ArchiveBox is taller than one line")
assert_eq(frame.CanonizeText._multiline, nil, "CanonizeText stays one line")
assert_eq(frame.DecreeLine._multiline, nil, "DecreeLine stays one line")
assert_true((frame.DecreeLine:GetHeight() or 22) <= 22, "other boxes stay one line")
assert_eq(countType(frame, "EditBox"), 7, "B8-E adds no extra EditBox")

local archiveLabel = findFont(frame, "ARCHIVE")
assert_true(archiveLabel ~= nil, "ARCHIVE label exists")
assert_eq(archiveLabel._type, "FontString", "ARCHIVE is a FontString")
assert_eq(archiveLabel._template, "GameFontNormal", "ARCHIVE is GameFontNormal")
assert_eq(archiveLabel:GetText(), "ARCHIVE", "ARCHIVE wording is exact")
assert_eq(frame.ArchiveLabel, archiveLabel, "ArchiveLabel is the ARCHIVE FontString")

local canonLabel = findFont(frame, "CANONIZE")
assert_true(canonLabel ~= nil, "CANONIZE label exists")
assert_eq(canonLabel._type, "FontString", "CANONIZE is a FontString")
assert_eq(canonLabel._template, "GameFontNormal", "CANONIZE is GameFontNormal")
assert_eq(canonLabel:GetText(), "CANONIZE", "CANONIZE wording is exact")
assert_eq(frame.CanonizeLabel, canonLabel, "CanonizeLabel is the CANONIZE FontString")

assert_true(findButton(frame, "EXPORT ARCHIVE") ~= nil, "EXPORT ARCHIVE stays")
assert_true(findButton(frame, "IMPORT ARCHIVE") ~= nil, "IMPORT ARCHIVE stays")
assert_true(findButton(frame, "CANONIZE") ~= nil, "CANONIZE verb stays")
assert_true(findButton(frame, "FLAG UPSET") ~= nil, "FLAG UPSET stays")

local srcBox = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcBox ~= nil, "Console.lua is readable for B8-E")
local srcBoxBody = srcBox:read("*a")
srcBox:close()
assert_true(srcBoxBody:find('type(frame.ArchiveBox.SetMultiLine) == "function"', 1, true) ~= nil,
  "SetMultiLine is type-guarded")
assert_true(srcBoxBody:find("SetMultiLine(true)", 1, true) ~= nil, "source calls SetMultiLine(true)")
assert_eq(srcBoxBody:find("SetMaxLetters", 1, true), nil, "do not lower SetMaxLetters")
assert_eq(srcBoxBody:find("SUMMON THE FAITHFUL", 1, true), nil, "source must not contain SUMMON")
assert_eq(srcBoxBody:find("CopyCeremonySummary", 1, true), nil, "source must not copy a ceremony summary")
assert_eq(srcBoxBody:find("function Console:SaveNote", 1, true), nil, "source must not define SaveNote")
assert_eq(srcBoxBody:find("WHISPER ALL", 1, true), nil, "source must not contain WHISPER ALL")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B8-E")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
end
assert_eq(COB.Popes, nil, "still no Pope list after B8-E")

--------------------------------------------------------------------------------
-- B9-C: stock CeremonyLog desk. Type + names + optional Pope text.
-- Newest first. SaveNote nil. No SUMMON. No post-show summary.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
reset()
Console:Init()
assert_eq(type(Console.GetCeremonyLog), "function", "GetCeremonyLog is a console readout")
assert_eq(#Console:GetCeremonyLog(), 0, "empty Store log is an empty list")
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(Console.Proclaim, nil, "CeremonyLog does not Proclaim")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")

assert_true(findButton(frame, "KNIGHT THIS BEEF") ~= nil, "KNIGHT THIS BEEF stays")
assert_true(findButton(frame, "ELEVATE TO LORD") ~= nil, "ELEVATE TO LORD stays")
assert_true(findButton(frame, "SANCTION BEEF GORA") ~= nil, "SANCTION stays")
assert_true(findButton(frame, "DECLARE VICTOR") ~= nil, "DECLARE VICTOR stays")
assert_true(findButton(frame, "COWARDICE RECORDED") ~= nil, "COWARDICE RECORDED stays")
assert_true(findButton(frame, "VOID") ~= nil, "VOID stays")
assert_true(findButton(frame, "FREE RULING") ~= nil, "FREE RULING stays")
assert_true(findButton(frame, "Post Decree") ~= nil, "Post Decree stays")
assert_true(findButton(frame, "MARK THIS MOMENT") ~= nil, "MARK THIS MOMENT stays")
assert_eq(countType(frame, "EditBox"), 7, "B9-C adds no extra EditBox")

local logLabel = findFont(frame, "CeremonyLog")
assert_true(logLabel ~= nil, "CeremonyLog header exists")
assert_eq(logLabel._type, "FontString", "CeremonyLog header is a FontString")
assert_eq(logLabel._template, "GameFontNormal", "CeremonyLog header is GameFontNormal")
assert_eq(logLabel:GetText(), "CeremonyLog", "CeremonyLog wording is exact")

assert_true(frame.CeremonyLog ~= nil, "CeremonyLog list exists")
assert_eq(frame.CeremonyLog._type, "FontString", "CeremonyLog list is a FontString")
assert_eq(frame.CeremonyLog._template, "GameFontHighlightSmall", "CeremonyLog list is GameFontHighlightSmall")

Console:Refresh()
assert_true((frame.CeremonyLog:GetText() or ""):find("No ceremony yet", 1, true) ~= nil,
  "empty log paints a stock empty line")
assert_eq((frame.CeremonyLog:GetText() or ""):find("ordained", 1, true), nil,
  "empty log does not paint ordained")

local savedLog = Store.GetCeremonyLog
Store.GetCeremonyLog = nil
assert_eq(#Console:GetCeremonyLog(), 0, "missing Store log is an empty list")
Store.GetCeremonyLog = savedLog

local savedStore = COB.Store
COB.Store = nil
assert_eq(#Console:GetCeremonyLog(), 0, "missing Store is an empty list")
COB.Store = savedStore

local human, char = seedLinked("Beefina")
local h2, c2 = seedLinked("Chuckroast")
Store:AppendCeremony("Knighting", { human.id }, 3000)
Store:AppendCeremony("victor", { char.id, c2.id }, 3001)
Store:AppendCeremony("free", { char.id, c2.id }, 3002, "rematch at the Pope's pleasure")

local log = Console:GetCeremonyLog()
assert_eq(#log, 3, "GetCeremonyLog returns seeded rows")
assert_eq(log[1].type, "free", "GetCeremonyLog is newest first")
assert_eq(log[2].type, "victor", "middle row is the prior append")
assert_eq(log[3].type, "Knighting", "oldest row is last")
assert_eq(log[1].text, "rematch at the Pope's pleasure", "Pope text stays on the free row")
assert_eq(log[2].text, nil, "type-only rows have no text")
assert_eq(log[3].text, nil, "Knighting row has no generated text")
assert_eq(log[1].participantIds[1], char.id, "free row keeps fighter A")
assert_eq(log[1].participantIds[2], c2.id, "free row keeps fighter B")
assert_eq(h2.id, c2.id, "linked fixture keeps matching store ids")
log[1].type = "mutated"
assert_eq(Console:GetCeremonyLog()[1].type, "free", "GetCeremonyLog returns a copy")
assert_eq(Store:GetCeremonyLog()[1].type, "Knighting", "Store log stays oldest first")

local soundCalls = 0
local savedSound = COB.Sound
COB.Sound = {
  Play = function()
    soundCalls = soundCalls + 1
  end,
}
Console:Refresh()
assert_eq(soundCalls, 0, "painting CeremonyLog does not Play Sound")
COB.Sound = savedSound

local body = frame.CeremonyLog:GetText() or ""
assert_true(body:find("free", 1, true) ~= nil, "list shows the free type token")
assert_true(body:find("victor", 1, true) ~= nil, "list shows the victor type token")
assert_true(body:find("Knighting", 1, true) ~= nil, "list shows the Knighting type token")
assert_true(body:find("Beefina", 1, true) ~= nil, "list shows the human/character name")
assert_true(body:find("Chuckroast", 1, true) ~= nil, "list shows the second name")
assert_true(body:find("rematch at the Pope's pleasure", 1, true) ~= nil,
  "list shows Pope-authored free-ruling text")
assert_eq(body:find("ordained", 1, true), nil, "list does not invent ordained")
assert_eq(body:find("The Pope knighted", 1, true), nil, "list does not invent knighting prose")
local freePos = body:find("free", 1, true)
local knightPos = body:find("Knighting", 1, true)
assert_true(freePos ~= nil and knightPos ~= nil and freePos < knightPos,
  "painted list is newest first")

reset()
Console:Init()
local collideHuman, collideChar = seedLinked("Beefina", "Steve")
assert_eq(collideHuman.name, "Steve", "collision fixture: human name is Steve")
assert_eq(collideChar.name, "Beefina", "collision fixture: character name is Beefina")
assert_eq(collideHuman.id, collideChar.id, "human and character ids can collide at 1")
Store:AppendCeremony("victor", { collideChar.id }, 4000)
Console:Refresh()
local collideBody = frame.CeremonyLog:GetText() or ""
assert_true(collideBody:find("Beefina", 1, true) ~= nil,
  "victor row paints the character name")
assert_eq(collideBody:find("Steve", 1, true), nil,
  "victor row does not paint the colliding human name")

local srcLog = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcLog ~= nil, "Console.lua is readable for B9-C")
local srcLogBody = srcLog:read("*a")
srcLog:close()
assert_eq(srcLogBody:find("ordained", 1, true), nil, "source must not contain ordained")
assert_eq(srcLogBody:find("The Pope knighted", 1, true), nil, "source must not invent knighting prose")
assert_eq(srcLogBody:find("SUMMON THE FAITHFUL", 1, true), nil, "source must not contain SUMMON")
assert_eq(srcLogBody:find("CopyCeremonySummary", 1, true), nil, "source must not copy a ceremony summary")
assert_eq(srcLogBody:find("function Console:SaveNote", 1, true), nil, "source must not define SaveNote")
assert_eq(srcLogBody:find("WHISPER ALL", 1, true), nil, "source must not contain WHISPER ALL")
assert_eq(srcLogBody:find("Console:Proclaim", 1, true), nil, "source must not Proclaim")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B9-C")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
end
assert_eq(COB.Popes, nil, "still no Pope list after B9-C")

--------------------------------------------------------------------------------
-- B10-D: stock ScrollFrame around the desk. Outer height 780. Child stays
-- tall. CeremonyLog / Archive / Canonize / SaveNote pins stay. No SUMMON.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
reset()
Console:Init()
assert_eq(frame:GetHeight(), 780, "B10-D outer frame height is 780")
assert_true(frame.DeskScroll ~= nil, "B10-D desk body ScrollFrame exists")
assert_eq(frame.DeskScroll._type, "ScrollFrame", "B10-D desk body is a ScrollFrame")
assert_eq(frame.DeskScroll._template, "UIPanelScrollFrameTemplate",
  "desk ScrollFrame is stock")
assert_eq(frame.DeskScroll:GetName(), "ChurchOfBeefConsoleFrameDeskScroll",
  "desk ScrollFrame has a stable name")
assert_eq(countType(frame, "ScrollFrame"), 6, "desk body is a sixth stock ScrollFrame")
assert_true(frame.DeskChild ~= nil, "desk scroll child exists")
assert_eq(frame.DeskChild:GetParent(), frame.DeskScroll, "content is the scroll child")
assert_eq(frame.Content, frame.DeskChild, "Content stays the desk child")
assert_true((frame.DeskChild:GetHeight() or 0) > frame:GetHeight(),
  "desk child can stay tall")
assert_eq(frame.DeskChild:GetHeight(), 1050, "desk child keeps the tall desk height")
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_true(findFont(frame, "Presence") ~= nil, "Presence desk stays")
assert_true(findFont(frame, "Knighting") ~= nil, "Knighting desk stays")
assert_true(findFont(frame, "Gora") ~= nil, "Gora desk stays")
assert_true(findFont(frame, "Confession") ~= nil, "Confession desk stays")
assert_true(findFont(frame, "CeremonyLog") ~= nil, "CeremonyLog header stays")
assert_true(findFont(frame, "ARCHIVE") ~= nil, "ARCHIVE label stays")
assert_true(findFont(frame, "CANONIZE") ~= nil, "CANONIZE label stays")
assert_true(findFont(frame, "Notebook") ~= nil, "Notebook label stays")
assert_true(frame.CeremonyLog ~= nil, "CeremonyLog list stays")
assert_true(frame.ArchiveBox ~= nil, "ArchiveBox stays")
assert_true(frame.CanonizeText ~= nil, "CanonizeText stays")
assert_eq(frame.ArchiveBox._multiline, true, "ArchiveBox stays multiline")
assert_eq(countType(frame, "EditBox"), 7, "B10-D adds no extra EditBox")
assert_true(findButton(frame, "KNIGHT THIS BEEF") ~= nil, "KNIGHT THIS BEEF stays")
assert_true(findButton(frame, "SANCTION BEEF GORA") ~= nil, "SANCTION stays")
assert_true(findButton(frame, "EXPORT ARCHIVE") ~= nil, "EXPORT ARCHIVE stays")
assert_true(findButton(frame, "CANONIZE") ~= nil, "CANONIZE verb stays")
assert_true(findButton(frame, "Post Decree") ~= nil, "Post Decree stays")

local srcDesk = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcDesk ~= nil, "Console.lua is readable for B10-D")
local srcDeskBody = srcDesk:read("*a")
srcDesk:close()
assert_true(srcDeskBody:find('CreateFrame("ScrollFrame", FRAME_NAME .. "DeskScroll"', 1, true) ~= nil,
  "desk uses CreateFrame ScrollFrame")
assert_true(srcDeskBody:find('type(deskScroll.SetScrollChild) == "function"', 1, true) ~= nil,
  "SetScrollChild is type-guarded")
assert_true(srcDeskBody:find('type(deskScroll.SetVerticalScroll) == "function"', 1, true) ~= nil,
  "SetVerticalScroll is type-guarded")
assert_eq(srcDeskBody:find("SUMMON THE FAITHFUL", 1, true), nil, "source must not contain SUMMON")
assert_eq(srcDeskBody:find("CopyCeremonySummary", 1, true), nil, "source must not copy a ceremony summary")
assert_eq(srcDeskBody:find("function Console:SaveNote", 1, true), nil, "source must not define SaveNote")
assert_eq(srcDeskBody:find("WHISPER ALL", 1, true), nil, "source must not contain WHISPER ALL")
assert_eq(srcDeskBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcDeskBody:find("PanelTabButtonTemplate", 1, true), nil, "desks are not collapsed into tabs")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B10-D")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
end
assert_eq(COB.Popes, nil, "still no Pope list after B10-D")

--------------------------------------------------------------------------------
-- B11-C: DeskScroll mouse wheel + Open Gora subjects.
-- Nested further so runB8E stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB11C()
reset()
Console:Init()
assert_true(frame.DeskScroll ~= nil, "B11-C desk ScrollFrame exists")
assert_eq(type(frame.DeskScroll.GetScript), "function", "DeskScroll GetScript exists")
assert_true(frame.DeskScroll:GetScript("OnMouseWheel") ~= nil, "DeskScroll has OnMouseWheel")
assert_eq(frame.DeskScroll:GetScript("OnUpdate"), nil, "DeskScroll has no permanent OnUpdate")
assert_eq(frame:GetScript("OnUpdate"), nil, "console frame has no permanent OnUpdate")
local fired, fireErr = pcall(function()
  stub.fire(frame.DeskScroll, "OnMouseWheel", -1)
end)
assert_eq(fired, true, "OnMouseWheel fire does not error")
assert_eq(fireErr, nil, "OnMouseWheel fire has no error text")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local srcWheel = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcWheel ~= nil, "Console.lua is readable for B11-C")
local srcWheelBody = srcWheel:read("*a")
srcWheel:close()
assert_true(srcWheelBody:find("EnableMouseWheel", 1, true) ~= nil,
  "source contains EnableMouseWheel")
assert_true(srcWheelBody:find('type(deskScroll.EnableMouseWheel) == "function"', 1, true) ~= nil,
  "EnableMouseWheel is type-guarded")
assert_true(srcWheelBody:find('SetScript("OnMouseWheel"', 1, true) ~= nil,
  "source wires OnMouseWheel")
assert_true(srcWheelBody:find("GetVerticalScroll", 1, true) ~= nil,
  "source type-guards GetVerticalScroll")
assert_true(srcWheelBody:find("GetVerticalScrollRange", 1, true) ~= nil,
  "source type-guards GetVerticalScrollRange")
assert_true(srcWheelBody:find("36", 1, true) ~= nil, "wheel steps by 36px")
assert_eq(srcWheelBody:find('deskScroll:SetScript("OnUpdate"', 1, true), nil,
  "source must not add a DeskScroll OnUpdate")
assert_eq(srcWheelBody:find("SUMMON THE FAITHFUL", 1, true), nil, "source must not contain SUMMON")
assert_eq(srcWheelBody:find("CopyCeremonySummary", 1, true), nil, "source must not copy a ceremony summary")
assert_eq(srcWheelBody:find("function Console:SaveNote", 1, true), nil, "source must not define SaveNote")
assert_eq(srcWheelBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcWheelBody:find("PanelTabButtonTemplate", 1, true), nil, "desks are not collapsed into tabs")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local liveA = Store:CreateCharacter({ name = "WheelA", class = "Warrior", level = 70 })
local liveB = Store:CreateCharacter({ name = "WheelB", class = "Mage", level = 68 })
assert_eq(Console.selectedFighterA, nil, "no selected fighter A")
assert_eq(Console.selectedFighterB, nil, "no selected fighter B")
assert_true(Console:StartEvent() ~= nil, "StartEvent reaches Runtime")
assert_true(Console:Sanction(liveA.id, liveB.id) ~= nil, "Sanction reaches Gora")
assert_eq(Gora:GetSanctioned().fighterA, liveA.id, "live pair is A")
assert_eq(Gora:GetSanctioned().fighterB, liveB.id, "live pair is B")
local openedLive = Console:OpenRite("Gora")
assert_true(openedLive ~= nil, "OpenRite Gora reaches Runtime from the live pair")
assert_eq(openedLive.state, "RITE", "OpenRite opens a typed rite")
assert_eq(openedLive.riteType, "Gora", "rite type is Gora")
assert_true(openedLive.subjects ~= nil, "Runtime subjects exist")
local liveFighters = openedLive.subjects and openedLive.subjects.fighters
assert_true(liveFighters ~= nil, "Runtime subjects have fighters")
assert_eq(liveFighters and liveFighters[1], liveA.id, "Runtime subject A is the live pair")
assert_eq(liveFighters and liveFighters[2], liveB.id, "Runtime subject B is the live pair")
assert_eq(liveFighters and #liveFighters, 2, "Runtime subjects are the two live ids")

reset()
Console:Init()
local lastA = Store:CreateCharacter({ name = "LastA", class = "Warrior", level = 70 })
local lastB = Store:CreateCharacter({ name = "LastB", class = "Mage", level = 68 })
local selA = Store:CreateCharacter({ name = "SelA", class = "Rogue", level = 70 })
local selB = Store:CreateCharacter({ name = "SelB", class = "Priest", level = 69 })
assert_true(Console:StartEvent() ~= nil, "StartEvent for selected-wins")
assert_true(Console:Sanction(lastA.id, lastB.id) ~= nil, "Sanction last pair")
assert_true(Console:Void() ~= nil, "VOID clears the live pair")
assert_eq(Gora:GetSanctioned(), nil, "live pair is gone after VOID")
assert_eq(Gora:GetLastSanctioned().fighterA, lastA.id, "last pair is A")
assert_eq(Gora:GetLastSanctioned().fighterB, lastB.id, "last pair is B")
Console:SelectFighters(selA.id, selB.id)
assert_eq(Console.selectedFighterA, selA.id, "selected A is set")
assert_eq(Console.selectedFighterB, selB.id, "selected B is set")
local openedSel = Console:OpenRite("Gora")
assert_true(openedSel ~= nil, "OpenRite Gora reaches Runtime from the selected pair")
local selFighters = openedSel and openedSel.subjects and openedSel.subjects.fighters
assert_eq(selFighters and selFighters[1], selA.id, "selected pair wins over GetLastSanctioned")
assert_eq(selFighters and selFighters[2], selB.id, "selected pair B wins over GetLastSanctioned")
assert_eq(selFighters and selFighters[1] == lastA.id, false, "last pair A does not win")
assert_eq(selFighters and selFighters[2] == lastB.id, false, "last pair B does not win")

reset()
Console:Init()
local lastOnlyA = Store:CreateCharacter({ name = "OnlyA", class = "Warrior", level = 70 })
local lastOnlyB = Store:CreateCharacter({ name = "OnlyB", class = "Mage", level = 68 })
assert_eq(Console.selectedFighterA, nil, "last-only has no selected A")
assert_eq(Console.selectedFighterB, nil, "last-only has no selected B")
assert_true(Console:StartEvent() ~= nil, "StartEvent for last-pair fallback")
assert_true(Console:Sanction(lastOnlyA.id, lastOnlyB.id) ~= nil, "Sanction last-only pair")
assert_true(Console:Void() ~= nil, "VOID leaves last pair only")
assert_eq(Gora:GetSanctioned(), nil, "no live pair after VOID")
assert_eq(Gora:GetLastSanctioned().fighterA, lastOnlyA.id, "last pair leftover is A")
assert_eq(Gora:GetLastSanctioned().fighterB, lastOnlyB.id, "last pair leftover is B")
local openedLast = Console:OpenRite("Gora")
assert_true(openedLast ~= nil, "OpenRite Gora still opens without a desk pair")
local lastFighters = openedLast and openedLast.subjects and openedLast.subjects.fighters
assert_eq(lastFighters, nil, "OpenRite Gora does not attach leftover last fighters")
assert_eq((lastFighters and lastFighters[1]) == lastOnlyA.id, false,
  "last pair A is not a Runtime subject")
assert_eq((lastFighters and lastFighters[2]) == lastOnlyB.id, false,
  "last pair B is not a Runtime subject")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B11-C wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B11-C")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
end
assert_eq(COB.Popes, nil, "still no Pope list after B11-C")
end
runB11C()

--------------------------------------------------------------------------------
-- B12-B: Open Knighting falls back to Knighting:GetLine() head.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB12B()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local srcOpen = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcOpen ~= nil, "Console.lua is readable for B12-B")
local srcOpenBody = srcOpen:read("*a")
srcOpen:close()
assert_eq(srcOpenBody:find("SUMMON THE FAITHFUL", 1, true), nil, "source must not contain SUMMON")
assert_eq(srcOpenBody:find("CopyCeremonySummary", 1, true), nil, "source must not copy a ceremony summary")
assert_eq(srcOpenBody:find("function Console:SaveNote", 1, true), nil, "source must not define SaveNote")
assert_eq(srcOpenBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcOpenBody:find("PanelTabButtonTemplate", 1, true), nil, "desks are not collapsed into tabs")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local lineHead = seedHuman("LineHead", 1)
assert_eq(Console.selectedHumanId, nil, "no selected human")
assert_true(Console:StartEvent() ~= nil, "StartEvent for line-head fallback")
assert_true(Console:Enqueue(lineHead.id) ~= nil, "Enqueue reaches Knighting")
assert_eq(Console.selectedHumanId, nil, "Enqueue does not SelectHuman")
assert_eq(Knighting:GetLine()[1].humanId, lineHead.id, "line head is the enqueued human")
local openedLine = Console:OpenRite("Knighting")
assert_true(openedLine ~= nil, "OpenRite Knighting reaches Runtime from the line head")
assert_eq(openedLine.state, "RITE", "OpenRite opens a typed rite")
assert_eq(openedLine.riteType, "Knighting", "rite type is Knighting")
assert_true(openedLine.subjects ~= nil, "Runtime subjects exist")
assert_eq(openedLine.subjects.candidate, lineHead.id,
  "Runtime candidate is the line head when nothing is selected")
assert_eq(Runtime:Snapshot().subjects.candidate, lineHead.id,
  "Snapshot candidate is the line head")

reset()
Console:Init()
local headHuman = seedHuman("HeadBeef", 1)
local pickHuman = seedHuman("PickBeef", 1)
assert_true(Console:StartEvent() ~= nil, "StartEvent for selected-wins")
assert_true(Console:Enqueue(headHuman.id) ~= nil, "Enqueue the line head")
assert_eq(Knighting:GetLine()[1].humanId, headHuman.id, "line head stays HeadBeef")
assert_eq(Console.selectedHumanId, nil, "selected-wins starts with no selection")
Console:SelectHuman(pickHuman.id)
assert_eq(Console.selectedHumanId, pickHuman.id, "selected human is PickBeef")
local openedSel = Console:OpenRite("Knighting")
assert_true(openedSel ~= nil, "OpenRite Knighting reaches Runtime from the selected human")
assert_eq(openedSel.subjects and openedSel.subjects.candidate, pickHuman.id,
  "selected human wins over a different line head")
assert_eq(openedSel.subjects and openedSel.subjects.candidate == headHuman.id, false,
  "line head does not win when a human is selected")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B12-B wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B12-B")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
end
assert_eq(COB.Popes, nil, "still no Pope list after B12-B")
end
runB12B()

--------------------------------------------------------------------------------
-- B13-D: stockEdit OnEscapePressed ClearFocus. Box does not Hide the desk.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB13D()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_eq(countType(frame, "EditBox"), 7, "B13-D adds no extra EditBox")

assert_true(frame.ArchiveBox ~= nil, "ArchiveBox exists")
assert_true(frame.DecreeLine ~= nil, "DecreeLine exists")
assert_eq(type(frame.ArchiveBox.GetScript), "function", "ArchiveBox GetScript exists")
assert_eq(type(frame.DecreeLine.GetScript), "function", "DecreeLine GetScript exists")
assert_true(frame.ArchiveBox:GetScript("OnEscapePressed") ~= nil, "ArchiveBox has OnEscapePressed")
assert_true(frame.DecreeLine:GetScript("OnEscapePressed") ~= nil, "DecreeLine has OnEscapePressed")
assert_true(frame.Stipulation:GetScript("OnEscapePressed") ~= nil, "Stipulation inherits OnEscapePressed")
assert_true(frame.FreeRulingText:GetScript("OnEscapePressed") ~= nil, "FreeRuling inherits OnEscapePressed")
assert_true(frame.DecreeFlavor:GetScript("OnEscapePressed") ~= nil, "DecreeFlavor inherits OnEscapePressed")
assert_true(frame.HonorificText:GetScript("OnEscapePressed") ~= nil, "Honorific inherits OnEscapePressed")
assert_true(frame.CanonizeText:GetScript("OnEscapePressed") ~= nil, "Canonize inherits OnEscapePressed")

Console:Show()
assert_eq(Console:IsShown(), true, "console is shown before ESC")
frame.ArchiveBox:SetFocus()
assert_eq(frame.ArchiveBox:HasFocus(), true, "ArchiveBox can take focus")
local fired, fireErr = pcall(function()
  stub.fire(frame.ArchiveBox, "OnEscapePressed")
end)
assert_eq(fired, true, "OnEscapePressed fire does not error")
assert_eq(fireErr, nil, "OnEscapePressed fire has no error text")
assert_eq(frame.ArchiveBox:HasFocus(), false, "OnEscapePressed ClearFocuses ArchiveBox")
assert_eq(Console:IsShown(), true, "ESC on the box does not Hide the console")

frame.DecreeLine:SetFocus()
assert_eq(frame.DecreeLine:HasFocus(), true, "DecreeLine can take focus")
local firedDecree, fireDecreeErr = pcall(function()
  stub.fire(frame.DecreeLine, "OnEscapePressed")
end)
assert_eq(firedDecree, true, "DecreeLine OnEscapePressed fire does not error")
assert_eq(fireDecreeErr, nil, "DecreeLine OnEscapePressed fire has no error text")
assert_eq(frame.DecreeLine:HasFocus(), false, "OnEscapePressed ClearFocuses DecreeLine")
assert_eq(Console:IsShown(), true, "DecreeLine ESC does not Hide the console")

local srcEsc = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcEsc ~= nil, "Console.lua is readable for B13-D")
local srcEscBody = srcEsc:read("*a")
srcEsc:close()
assert_true(srcEscBody:find("OnEscapePressed", 1, true) ~= nil, "source contains OnEscapePressed")
assert_true(srcEscBody:find("ClearFocus", 1, true) ~= nil, "source contains ClearFocus")
assert_true(srcEscBody:find('SetScript("OnEscapePressed"', 1, true) ~= nil,
  "source wires OnEscapePressed")
assert_true(srcEscBody:find('type(box.SetScript) == "function"', 1, true) ~= nil,
  "SetScript is type-guarded")
assert_true(srcEscBody:find("local function stockEdit", 1, true) ~= nil, "stockEdit still exists")
assert_eq(srcEscBody:find("PlaySound", 1, true), nil, "source must not PlaySound")
assert_eq(srcEscBody:find("SUMMON THE FAITHFUL", 1, true), nil, "source must not contain SUMMON")
assert_eq(srcEscBody:find("CopyCeremonySummary", 1, true), nil, "source must not copy a ceremony summary")
assert_eq(srcEscBody:find("function Console:SaveNote", 1, true), nil, "source must not define SaveNote")
assert_eq(srcEscBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcEscBody:find("PanelTabButtonTemplate", 1, true), nil, "desks are not collapsed into tabs")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B13-D")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
end
assert_eq(COB.Popes, nil, "still no Pope list after B13-D")
end
runB13D()

--------------------------------------------------------------------------------
-- B14-D: UISpecialFrames rememberSpecial dedupe. Named desk once.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB14D()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "after Init, ChurchOfBeefConsoleFrame is on UISpecialFrames once")

reset()
Console:Init()
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "ResetForTests + Init still registers ChurchOfBeefConsoleFrame once")

-- Force a second build so rememberSpecial must dedupe (Init is otherwise
-- idempotent; ResetForTests does not nil the widget).
Console.frame = nil
Console:Init()
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "second build does not duplicate ChurchOfBeefConsoleFrame")

-- Optional: name already present before Init does not add a second.
Console.frame = nil
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "name already present before Init")
Console:Init()
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "Init does not add a second when the name is already present")

frame = Console.frame
assert_true(frame ~= nil, "live console frame is restored after rebuild")
assert_true(frame.ArchiveBox ~= nil, "B13-D ArchiveBox still exists")
assert_true(frame.ArchiveBox:GetScript("OnEscapePressed") ~= nil,
  "B13-D OnEscapePressed ClearFocus still wired")

local srcSpecial = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcSpecial ~= nil, "Console.lua is readable for B14-D")
local srcSpecialBody = srcSpecial:read("*a")
srcSpecial:close()
assert_true(srcSpecialBody:find("ChurchOfBeefConsoleFrame", 1, true) ~= nil,
  "source names ChurchOfBeefConsoleFrame")
assert_true(srcSpecialBody:find("local function rememberSpecial", 1, true) ~= nil,
  "source has rememberSpecial")
assert_true(srcSpecialBody:find("UISpecialFrames[i] == name", 1, true) ~= nil,
  "source has a dedupe loop")
assert_true(srcSpecialBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "build remembers the named desk")
assert_eq(srcSpecialBody:find("table.insert(UISpecialFrames", 1, true), nil,
  "source does not bare-insert UISpecialFrames")
assert_eq(srcSpecialBody:find("rememberSpecial(FRAME_NAME ..", 1, true), nil,
  "source does not register scroll child names")
assert_eq(srcSpecialBody:find("IG_CHARACTER_INFO", 1, true), nil,
  "source does not PlaySound IG_CHARACTER_INFO_*")
assert_eq(srcSpecialBody:find("PlaySound", 1, true), nil, "source must not PlaySound")
assert_eq(srcSpecialBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcSpecialBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcSpecialBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcSpecialBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B14-D")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
end
assert_eq(COB.Popes, nil, "still no Pope list after B14-D")
end
runB14D()

--------------------------------------------------------------------------------
-- B18-B: named-opponent petition paints "  names  "; click SelectFighters
-- both ids. petitionLine copy stays. SaveNote nil. No DEMANDED.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB18B()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local nameA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local nameB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
assert_eq(Console.selectedFighterA, nil, "no selected fighter A before the named petition")
assert_eq(Console.selectedFighterB, nil, "no selected fighter B before the named petition")
assert_true(Console:StartEvent() ~= nil, "StartEvent for named petition")
assert_true(Gora:Petition(nameA.id, nameB.id) ~= nil, "named petition lands")
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
  },
}
local namedPets = Console:GetPetitions()
assert_eq(#namedPets, 1, "GetPetitions has the named petition")
assert_eq(namedPets[1].characterId, nameA.id, "GetPetitions keeps the petitioner id")
assert_eq(namedPets[1].namedOpponentId, nameB.id, "GetPetitions keeps the named opponent id")
Console:Refresh()
local listText = frame.PetitionsList:GetText() or ""
assert_true(listText:find("  names  ", 1, true) ~= nil,
  "PetitionsList FontString paints the names token")
assert_true(listText:find("Chuckroast", 1, true) ~= nil,
  "PetitionsList keeps the petitioner name")
assert_true(listText:find("Tendermage", 1, true) ~= nil,
  "PetitionsList keeps the opponent name")
assert_eq(listText:find("DEMANDED", 1, true), nil, "painted line has no DEMANDED")
assert_eq(listText:find("demanded", 1, true), nil, "painted line has no demanded prose")
assert_eq(listText:find("odds", 1, true), nil, "painted line has no odds prose")
assert_eq(listText:find("meeting", 1, true), nil, "painted line has no meeting prose")

local rowBtn = frame.PetitionRows and frame.PetitionRows[1]
assert_true(rowBtn ~= nil, "named petition paints a row button")
assert_true((rowBtn:GetText() or ""):find("  names  ", 1, true) ~= nil,
  "row button paints the names token")
assert_true((rowBtn:GetText() or ""):find("Chuckroast", 1, true) ~= nil,
  "row button keeps the petitioner name")
assert_true((rowBtn:GetText() or ""):find("Tendermage", 1, true) ~= nil,
  "row button keeps the opponent name")
stub.fire(rowBtn, "OnClick")
assert_eq(Console.selectedFighterA, nameA.id, "click SelectFighters the petitioner")
assert_eq(Console.selectedFighterB, nameB.id, "click SelectFighters the named opponent")

local srcNames = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcNames ~= nil, "Console.lua is readable for B18-B")
local srcNamesBody = srcNames:read("*a")
srcNames:close()
assert_true(srcNamesBody:find('left .. "  names  " .. right', 1, true) ~= nil,
  "petitionLine copy stays")
assert_true(srcNamesBody:find("Console:SelectFighters(row.characterId, row.namedOpponentId)", 1, true) ~= nil,
  "click SelectFighters both ids")
assert_eq(srcNamesBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcNamesBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcNamesBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcNamesBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcNamesBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B18-B wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B18-B")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
end
assert_eq(COB.Popes, nil, "still no Pope list after B18-B")
end
runB18B()

--------------------------------------------------------------------------------
-- B19-A: presentCharacterIds fail-opens Store ids while Roster is ready
-- but not complete. Complete keeps the member-name filter. Not-ready
-- stays {}. SaveNote nil. No UnitIsDead. No new empty copy.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB19A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local localChar = Store:CreateCharacter({ name = "Beefina", class = "Warrior", level = 70 })
local otherChar = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
assert_true(Runtime:StartEvent() ~= nil, "B19-A needs a live event")
assert_true(Gora:Petition(localChar.id) ~= nil, "local character petitioned")
assert_true(Gora:Petition(otherChar.id) ~= nil, "second Store character petitioned")

COB.Roster = nil
assert_eq(#Console:GetPetitions(), 0, "missing Roster keeps empty present set")

COB.Roster = {
  ready = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
assert_eq(#Console:GetPetitions(), 0, "not-ready Roster keeps empty present set")

COB.Roster = { ready = true, members = "nope" }
assert_eq(#Console:GetPetitions(), 0, "non-table members keep empty present set")

COB.Roster = {
  ready = true,
  complete = true,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local completePets = Console:GetPetitions()
assert_eq(#completePets, 1, "complete roster filters to members")
assert_eq(completePets[1].characterId, localChar.id, "complete keeps the member petition")
local presenceComplete = Console:GetPresence()
assert_eq(#presenceComplete, 1, "GetPresence still lists roster members")
assert_eq(presenceComplete[1].name, "Beefina", "GetPresence is not fail-open")

COB.Roster = {
  ready = true,
  complete = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
  IsComplete = function() return true end,
}
local methodPets = Console:GetPetitions()
assert_eq(#methodPets, 1, "IsComplete true filters to members")
assert_eq(methodPets[1].characterId, localChar.id, "IsComplete true keeps the member petition")

COB.Roster = {
  ready = true,
  complete = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local openPets = Console:GetPetitions()
assert_eq(#openPets, 2, "incomplete roster fail-opens Store petitioners")
assert_eq(openPets[1] and openPets[1].characterId, localChar.id, "fail-open keeps the local petition")
assert_eq(openPets[2] and openPets[2].characterId, otherChar.id, "second Store character petition still appears")
local presenceOpen = Console:GetPresence()
assert_eq(#presenceOpen, 2, "GetPresence fail-opens when Roster is incomplete")
assert_eq(presenceOpen[1] and presenceOpen[1].name, "Beefina", "seed member stays on Presence")
assert_eq(presenceOpen[1] and presenceOpen[1].here, true, "seed member is here")
assert_eq(presenceOpen[2] and presenceOpen[2].name, "Chuckroast", "Store-only character is listed")
assert_eq(presenceOpen[2] and presenceOpen[2].here, false, "Store-only is not invented as here")
assert_eq(presenceOpen[2] and presenceOpen[2].characterId, otherChar.id, "Chuckroast carries characterId")

COB.Roster = {
  ready = true,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local seedPets = Console:GetPetitions()
assert_eq(#seedPets, 2, "ready without complete fail-opens")
assert_eq(seedPets[2] and seedPets[2].characterId, otherChar.id, "seed snapshot still shows the second petitioner")

local srcComplete = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcComplete ~= nil, "Console.lua is readable for B19-A")
local srcCompleteBody = srcComplete:read("*a")
srcComplete:close()
assert_true(srcCompleteBody:find('type(Roster.IsComplete) == "function"', 1, true) ~= nil,
  "complete detection prefers IsComplete")
assert_true(srcCompleteBody:find("Roster:IsComplete() == true", 1, true) ~= nil,
  "IsComplete true is the complete gate")
assert_true(srcCompleteBody:find("Roster.complete == true", 1, true) ~= nil,
  "harness stubs can set complete without the method")
assert_true(srcCompleteBody:find('body = "No one on the roster yet."', 1, true) ~= nil,
  "empty Presence copy stays")
assert_true(srcCompleteBody:find('body = "No petitions."', 1, true) ~= nil,
  "empty petition copy stays")
assert_eq(srcCompleteBody:find("UnitIsDead", 1, true), nil, "source must not scrape UnitIsDead")
assert_eq(srcCompleteBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcCompleteBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcCompleteBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcCompleteBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcCompleteBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B19-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
end
assert_eq(COB.Popes, nil, "still no Pope list after B19-A")
end
runB19A()

--------------------------------------------------------------------------------
-- B20-A: Confession inbox click-select + mute "  called" token.
-- paintRowButtons on ConfessionChild. No new Dismiss. No fan-out.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB20A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
local builtRows = rawget(frame, "ConfessionRows")
assert_true(builtRows ~= nil, "ConfessionRows exists on build")
assert_eq(type(builtRows), "table", "ConfessionRows is a table on build")

Console:Refresh()
assert_true((frame.ConfessionList:GetText() or ""):find("No confessions", 1, true) ~= nil,
  "empty inbox stays No confessions.")
assert_eq(frame.ConfessionList:IsShown(), true, "empty inbox shows the FontString")

local dismissCount = 0
walk(frame, function(child)
  if child._type == "Button" and child.GetText and child:GetText() == "Dismiss" then
    dismissCount = dismissCount + 1
  end
end)
assert_eq(dismissCount, 1, "no second Dismiss plate")
assert_true(findButton(frame, "Dismiss") ~= nil, "Gora Dismiss stays")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local confessor = Store:CreateCharacter({ name = "Beefina", class = "Priest", level = 70 })
assert_eq(Console.selectedCharacterId, nil, "no selected character before the confession click")
local liveQueue = {
  { characterId = confessor.id, text = "I ate the sacred brisket", called = false },
}
local callCount = 0
local callId
COB.Confession = {
  GetQueue = function()
    return liveQueue
  end,
  CallForward = function(_, characterId)
    callCount = callCount + 1
    callId = characterId
    for i = 1, #liveQueue do
      if liveQueue[i].characterId == characterId then
        liveQueue[i].called = true
      end
    end
    return true
  end,
}
local queued = Console:GetConfessions()
assert_eq(#queued, 1, "GetConfessions returns the stubbed queue")
assert_eq(queued[1].characterId, confessor.id, "confession copy keeps the character id")
assert_eq(queued[1].called, false, "confession copy keeps called")

Console:Refresh()
assert_eq(frame.ConfessionList:IsShown(), false, "inbox FontString hides when rows exist")
assert_true((frame.ConfessionList:GetText() or ""):find("Beefina", 1, true) ~= nil,
  "ConfessionList still SetTexts the confessor name")
assert_true((frame.ConfessionList:GetText() or ""):find("I ate the sacred brisket", 1, true) ~= nil,
  "ConfessionList still SetTexts the confession text")
assert_eq((frame.ConfessionList:GetText() or ""):find("  called", 1, true), nil,
  "uncalled FontString has no called token")

local rowBtn = rawget(frame, "ConfessionRows") and rawget(frame, "ConfessionRows")[1]
assert_true(rowBtn ~= nil, "a Confession row button exists")
local rowText = (rowBtn and rowBtn.GetText and rowBtn:GetText()) or ""
assert_eq(rowBtn and rowBtn._type, "Button", "confession row is a Button")
assert_true(rowText:find("Beefina", 1, true) ~= nil,
  "row button paints the confessor name")
assert_true(rowText:find("I ate the sacred brisket", 1, true) ~= nil,
  "row button paints the confession text")
assert_eq(rowText:find("  called", 1, true), nil,
  "uncalled row has no called token")
assert_eq(rowText:find("CALLED FORWARD", 1, true), nil,
  "row has no CALLED FORWARD oratory")
assert_eq(rowText:find("DEMANDED", 1, true), nil,
  "row has no DEMANDED oratory")

local soundRec = {}
local toastCalls = 0
local chats = 0
local savedSound = COB.Sound
local savedToasts = COB.Toasts
local savedChat = SendChatMessage
COB.Sound = {
  Play = function(_, name)
    soundRec[#soundRec + 1] = name
    return name
  end,
}
COB.Toasts = {
  Show = function()
    toastCalls = toastCalls + 1
  end,
}
SendChatMessage = function()
  chats = chats + 1
end

if rowBtn then
  stub.fire(rowBtn, "OnClick")
end
assert_eq(Console.selectedCharacterId, confessor.id, "click SelectCharacter the confessor")
assert_eq(#soundRec, 0, "confession click does not play Sound")
assert_eq(toastCalls, 0, "confession click does not toast")
assert_eq(chats, 0, "confession click does not SendChatMessage")

local calledOk = Console:CallForward()
assert_eq(calledOk, true, "CallForward reaches Confession")
assert_eq(callCount, 1, "CallForward is one mark")
assert_eq(callId, confessor.id, "CallForward uses the selected character")
assert_eq(#soundRec, 0, "CallForward does not play Sound")
assert_eq(toastCalls, 0, "CallForward does not toast")
assert_eq(chats, 0, "CallForward does not SendChatMessage")
assert_eq(liveQueue[1].called, true, "CallForward marks called on the stub")

local paintedRows = rawget(frame, "ConfessionRows")
local painted = (paintedRows and paintedRows[1] and paintedRows[1].GetText and paintedRows[1]:GetText()) or ""
assert_true(painted:find("  called", 1, true) ~= nil,
  "after CallForward the painted line contains the called token")
assert_true(painted:find("Beefina", 1, true) ~= nil, "called line keeps the confessor name")
assert_true((frame.ConfessionList:GetText() or ""):find("  called", 1, true) ~= nil,
  "ConfessionList SetText also has the called token")
assert_eq(painted:find("CALLED FORWARD", 1, true), nil, "painted line has no CALLED FORWARD")
assert_eq(painted:find("DEMANDED", 1, true), nil, "painted line has no DEMANDED")

local srcConfess = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcConfess ~= nil, "Console.lua is readable for B20-A")
local srcConfessBody = srcConfess:read("*a")
srcConfess:close()
assert_true(srcConfessBody:find("frame.ConfessionRows = {}", 1, true) ~= nil,
  "build seeds ConfessionRows")
assert_true(srcConfessBody:find("local function onConfessionClick", 1, true) ~= nil,
  "source has onConfessionClick")
assert_true(srcConfessBody:find("Console:SelectCharacter(row.characterId)", 1, true) ~= nil,
  "click SelectCharacter the row character")
assert_true(srcConfessBody:find("row.called == true", 1, true) ~= nil,
  "called token gates on called == true")
assert_true(srcConfessBody:find('line = line .. "  called"', 1, true) ~= nil,
  "mute called token matches needs Knighting")
assert_eq(srcConfessBody:find("CALLED FORWARD", 1, true), nil,
  "source must not invent CALLED FORWARD")
assert_eq(srcConfessBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcConfessBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcConfessBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcConfessBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcConfessBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

COB.Sound = savedSound
COB.Toasts = savedToasts
SendChatMessage = savedChat
COB.Confession = nil
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B20-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B20-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B20-A")
end
runB20A()

--------------------------------------------------------------------------------
-- B21-A: GetPresence fail-opens Store snapshot characters while Roster is
-- ready but not complete. Appended Store-only rows use here = false.
-- Complete keeps the member walk. Missing / not-ready stays {}.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB21A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local dismissCount = 0
walk(frame, function(child)
  if child._type == "Button" and child.GetText and child:GetText() == "Dismiss" then
    dismissCount = dismissCount + 1
  end
end)
assert_eq(dismissCount, 1, "no second Dismiss plate")
assert_true(findButton(frame, "Dismiss") ~= nil, "Gora Dismiss stays")

local human, localChar = seedLinked("Beefina", "Steve", 1)
local otherHuman, otherChar = seedLinked("Chuckroast", "Chuck", 3)
assert_eq(human.id ~= nil, true, "local human fixture exists")
assert_eq(otherHuman.id ~= nil, true, "Store human fixture exists")

COB.Roster = nil
assert_eq(#Console:GetPresence(), 0, "missing Roster keeps empty Presence")

COB.Roster = {
  ready = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
assert_eq(#Console:GetPresence(), 0, "not-ready Roster keeps empty Presence")

COB.Roster = { ready = true, members = "nope" }
assert_eq(#Console:GetPresence(), 0, "non-table members keep empty Presence")

COB.Roster = {
  ready = true,
  complete = true,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local presenceComplete = Console:GetPresence()
assert_eq(#presenceComplete, 1, "complete roster still lists members only")
assert_eq(presenceComplete[1].name, "Beefina", "complete Presence stays the seed member")
assert_eq(presenceComplete[1].here, true, "complete member is here")
assert_eq(presenceComplete[1].characterId, localChar.id, "complete member keeps characterId")

COB.Roster = {
  ready = true,
  complete = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
  IsComplete = function() return true end,
}
local presenceMethod = Console:GetPresence()
assert_eq(#presenceMethod, 1, "IsComplete true keeps the member walk")
assert_eq(presenceMethod[1].name, "Beefina", "IsComplete true does not append Store-only")

COB.Roster = {
  ready = true,
  complete = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local presenceOpen = Console:GetPresence()
assert_eq(#presenceOpen, 2, "incomplete seed lists member and Store-only")
assert_eq(presenceOpen[1] and presenceOpen[1].name, "Beefina", "seed member stays first after sort")
assert_eq(presenceOpen[1] and presenceOpen[1].here, true, "seed member is here")
assert_eq(presenceOpen[1] and presenceOpen[1].characterId, localChar.id, "seed member keeps characterId")
assert_eq(presenceOpen[1] and presenceOpen[1].rankId, 1, "seed member copies Store human rank")
assert_eq(presenceOpen[2] and presenceOpen[2].name, "Chuckroast", "Store-only character is appended")
assert_eq(presenceOpen[2] and presenceOpen[2].here, false, "Store-only is not invented as here")
assert_eq(presenceOpen[2] and presenceOpen[2].characterId, otherChar.id, "Chuckroast carries characterId")
assert_eq(presenceOpen[2] and presenceOpen[2].humanId, otherHuman.id, "Store-only copies Store human id")
assert_eq(presenceOpen[2] and presenceOpen[2].rankId, 3, "Store-only copies Store human rank")
assert_eq(presenceOpen[2] and presenceOpen[2].rankTitle, "Beef Knight", "Store-only copies Store rank title")
assert_eq(presenceOpen[2] and presenceOpen[2].needsKnighting, false, "a Knight does not need Knighting")
assert_eq(presenceOpen[2] and presenceOpen[2].guildRankIndex, nil, "Store-only has no invented guild rank")

COB.Roster = {
  ready = true,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local presenceSeed = Console:GetPresence()
assert_eq(#presenceSeed, 2, "ready without complete fail-opens Presence")
assert_eq(presenceSeed[2] and presenceSeed[2].name, "Chuckroast", "seed snapshot still lists the Store-only name")
assert_eq(presenceSeed[2] and presenceSeed[2].here, false, "seed Store-only stays not here")
assert_eq(presenceSeed[2] and presenceSeed[2].characterId, otherChar.id, "seed Store-only keeps characterId")

assert_eq(Console.selectedCharacterId, nil, "no selected character before the Presence click")
Console:Refresh()
local storeBtn
local painted = rawget(frame, "PresenceRows")
if type(painted) == "table" then
  for i = 1, #painted do
    local btn = painted[i]
    local row = btn and btn._row
    if row and row.characterId == otherChar.id then
      storeBtn = btn
      break
    end
  end
end
assert_true(storeBtn ~= nil, "fail-open Store row is clickable")
stub.fire(storeBtn, "OnClick")
assert_eq(Console.selectedCharacterId, otherChar.id, "clicking a fail-open Store row selects that characterId")
assert_eq(Console.selectedHumanId, otherHuman.id, "clicking a fail-open Store row selects the Store human")

local srcPresence = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcPresence ~= nil, "Console.lua is readable for B21-A")
local srcPresenceBody = srcPresence:read("*a")
srcPresence:close()
assert_true(srcPresenceBody:find("here = false", 1, true) ~= nil,
  "Store-only rows set here false")
assert_true(srcPresenceBody:find('type(Roster.IsComplete) == "function"', 1, true) ~= nil,
  "complete detection prefers IsComplete")
assert_true(srcPresenceBody:find("Roster:IsComplete() == true", 1, true) ~= nil,
  "IsComplete true is the complete gate")
assert_true(srcPresenceBody:find("Roster.complete == true", 1, true) ~= nil,
  "harness stubs can set complete without the method")
assert_true(srcPresenceBody:find('body = "No one on the roster yet."', 1, true) ~= nil,
  "empty Presence copy stays")
assert_true(srcPresenceBody:find('left .. "  names  " .. right', 1, true) ~= nil,
  "petition names token stays")
assert_eq(srcPresenceBody:find("UnitIsDead", 1, true), nil, "source must not scrape UnitIsDead")
assert_eq(srcPresenceBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcPresenceBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcPresenceBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcPresenceBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcPresenceBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B21-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B21-A")
end
runB21A()

--------------------------------------------------------------------------------
-- B22-A: Recommendation paints mute "  names  " when Gora:Recommend
-- returns namedOpponent. nameA vs nameB + mute H2H stay. petitionLine
-- copy stays. SaveNote nil. No DEMANDED.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB22A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_true(frame.Recommendation ~= nil, "recommendation line exists")
assert_eq(frame.Recommendation._type, "FontString", "recommendation is a FontString")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local nameA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local nameB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
assert_eq(Console.selectedFighterA, nil, "no selected fighter A before named Recommend")
assert_eq(Console.selectedFighterB, nil, "no selected fighter B before named Recommend")
assert_true(Console:StartEvent() ~= nil, "StartEvent for named Recommend")
assert_true(Gora:Petition(nameB.id, nameA.id) ~= nil, "named petition lands")
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
  },
}
local recNamed = Console:Recommend()
assert_true(recNamed ~= nil, "Recommend uses a named opponent")
assert_eq(recNamed.namedOpponent, true, "Gora:Recommend flags the named pair")
local namedText = frame.Recommendation:GetText() or ""
assert_true(namedText:find("  names  ", 1, true) ~= nil,
  "named Recommend paints the names token")
assert_true(namedText:find("Chuckroast", 1, true) ~= nil,
  "named Recommend keeps name A")
assert_true(namedText:find("Tendermage", 1, true) ~= nil,
  "named Recommend keeps name B")
assert_true(namedText:find("vs", 1, true) ~= nil, "named Recommend stays nameA vs nameB")
assert_eq(namedText:find("DEMANDED", 1, true), nil, "named Recommend has no DEMANDED")
assert_eq(namedText:find("demanded", 1, true), nil, "named Recommend has no demanded prose")
assert_eq(namedText:find("odds", 1, true), nil, "named Recommend has no odds prose")

Gora:Dismiss(nameB.id)
Console:SelectFighters(nil, nil)
assert_true(Gora:Petition(nameA.id) ~= nil, "unnamed petition A lands")
assert_true(Gora:Petition(nameB.id) ~= nil, "unnamed petition B lands")
local recUnnamed = Console:Recommend()
assert_true(recUnnamed ~= nil, "Recommend uses the unnamed pair")
assert_eq(recUnnamed.namedOpponent, false, "unnamed pair is not flagged")
local unnamedText = frame.Recommendation:GetText() or ""
assert_true(unnamedText:find("Chuckroast", 1, true) ~= nil,
  "unnamed Recommend keeps name A")
assert_true(unnamedText:find("Tendermage", 1, true) ~= nil,
  "unnamed Recommend keeps name B")
assert_true(unnamedText:find("vs", 1, true) ~= nil, "unnamed Recommend stays nameA vs nameB")
assert_eq(unnamedText:find("  names  ", 1, true), nil,
  "unnamed pair Recommend has no names token")
assert_eq(unnamedText:find("DEMANDED", 1, true), nil, "unnamed Recommend has no DEMANDED")

local srcRec = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcRec ~= nil, "Console.lua is readable for B22-A")
local srcRecBody = srcRec:read("*a")
srcRec:close()
assert_true(srcRecBody:find('left .. "  names  " .. right', 1, true) ~= nil,
  "petitionLine copy stays")
assert_true(srcRecBody:find("result.namedOpponent == true", 1, true) ~= nil,
  "Recommend stores the namedOpponent flag")
assert_true(srcRecBody:find('label = label .. "  names  "', 1, true) ~= nil,
  "recommendation line appends the names token")
assert_eq(srcRecBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcRecBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcRecBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcRecBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcRecBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B22-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B22-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B22-A")
end
runB22A()

--------------------------------------------------------------------------------
-- B23-A: playCue no-ops when Toasts.Proclaim exists. Isolated Sound
-- pins stay (suite does not load Toasts). Sanction + one other cued
-- verb do not append to the Sound spy. SaveNote nil. No Proclaim call.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB23A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local steve = seedHuman("Steve", 2)
local fighterA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local fighterB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })

local savedSound = COB.Sound
local savedToasts = COB.Toasts
local soundCalls = {}
local proclaimCalls = 0
COB.Sound = {
  Play = function(_, name)
    soundCalls[#soundCalls + 1] = name
    return name
  end,
}
COB.Toasts = {
  Proclaim = function()
    proclaimCalls = proclaimCalls + 1
  end,
}

assert_true(Console:StartEvent() ~= nil, "StartEvent for theater-owned cues")
assert_eq(#soundCalls, 0, "StartEvent does not play Sound")
assert_eq(proclaimCalls, 0, "StartEvent does not call Toasts:Proclaim")

local knightedCue = Console:KnightThisBeef(steve.id)
assert_true(knightedCue ~= nil, "KNIGHT THIS BEEF succeeds when Proclaim exists")
assert_eq(#soundCalls, 0, "KNIGHT THIS BEEF does not append to the Sound spy when Proclaim exists")
assert_eq(proclaimCalls, 0, "Console does not call Toasts:Proclaim")

Gora:Petition(fighterA.id, fighterB.id)
Gora:Petition(fighterB.id)
local sanctionedCue = Console:Sanction(fighterA.id, fighterB.id)
assert_true(sanctionedCue ~= nil, "Sanction succeeds when Proclaim exists")
assert_eq(#soundCalls, 0, "Sanction does not append to the Sound spy when Proclaim exists")
assert_eq(proclaimCalls, 0, "Sanction does not call Toasts:Proclaim")

local srcCue = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcCue ~= nil, "Console.lua is readable for B23-A")
local srcCueBody = srcCue:read("*a")
srcCue:close()
assert_true(srcCueBody:find('type(Toasts.Proclaim) == "function"', 1, true) ~= nil,
  "playCue guards on Toasts.Proclaim")
assert_true(srcCueBody:find('return after(self, result, err, "sanction", true)', 1, true) ~= nil,
  "Sanction cue argument stays")
assert_true(srcCueBody:find('return after(self, result, err, "knighting")', 1, true) ~= nil,
  "KnightThisBeef cue argument stays")
assert_true(srcCueBody:find('return after(self, result, err, "elevation")', 1, true) ~= nil,
  "ElevateToLord cue argument stays")
assert_true(srcCueBody:find("pcall(Sound.Play, Sound, name)", 1, true) ~= nil,
  "isolated Sound:Play path stays")
assert_eq(srcCueBody:find("Toasts:Proclaim", 1, true), nil, "source must not call Toasts:Proclaim")
assert_eq(srcCueBody:find("Toasts.Proclaim(", 1, true), nil, "source must not call Toasts.Proclaim")
assert_eq(srcCueBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcCueBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcCueBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcCueBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

COB.Sound = savedSound
COB.Toasts = savedToasts
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B23-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B23-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B23-A")
end
runB23A()

--------------------------------------------------------------------------------
-- B24-A: lastRecommendation clears on successful StartEvent / EndEvent
-- before after() so Refresh paints empty. Failed Start (already live)
-- / failed End keep the table. Continue does not clear. Recommend still
-- stores namedOpponent. SaveNote nil. No DEMANDED.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB24A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_true(frame.Recommendation ~= nil, "recommendation line exists")
assert_eq(frame.Recommendation._type, "FontString", "recommendation is a FontString")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local nameA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local nameB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
assert_true(Console:StartEvent() ~= nil, "StartEvent for named Recommend")
assert_true(Gora:Petition(nameB.id, nameA.id) ~= nil, "named petition lands")
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
  },
}
local recNamed = Console:Recommend()
assert_true(recNamed ~= nil, "Recommend uses a named opponent")
assert_eq(recNamed.namedOpponent, true, "Gora:Recommend flags the named pair")
local namedText = frame.Recommendation:GetText() or ""
assert_true(namedText:find("  names  ", 1, true) ~= nil,
  "named Recommend paints the names token")
assert_true(namedText:find("Chuckroast", 1, true) ~= nil,
  "named Recommend keeps name A")
assert_true(namedText:find("Tendermage", 1, true) ~= nil,
  "named Recommend keeps name B")
assert_eq(namedText:find("DEMANDED", 1, true), nil, "named Recommend has no DEMANDED")

local failStart = Console:StartEvent()
assert_eq(failStart, nil, "StartEvent refuses when already live")
Console:Refresh()
assert_eq(frame.Recommendation:GetText() or "", namedText,
  "failed StartEvent while live does not clear Recommendation")

assert_true(Console:OpenRite("Gora") ~= nil, "OpenRite for Continue pin")
assert_true(Console:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
assert_true(Console:Continue() ~= nil, "Continue returns to ASSEMBLY")
Console:Refresh()
assert_eq(frame.Recommendation:GetText() or "", namedText,
  "Continue does not clear Recommendation")

assert_true(Console:OpenRite("Gora") ~= nil, "OpenRite for failed End pin")
local failEnd = Console:EndEvent()
assert_eq(failEnd, nil, "EndEvent refuses from RITE")
Console:Refresh()
assert_eq(frame.Recommendation:GetText() or "", namedText,
  "failed EndEvent does not clear Recommendation")
assert_true(Console:CloseRite() ~= nil, "CloseRite after failed End")

local ended = Console:EndEvent()
assert_true(ended ~= nil, "EndEvent returns to QUIET")
Console:Refresh()
assert_eq(frame.Recommendation:GetText() or "", "",
  "EndEvent then Refresh paints empty Recommendation")
assert_eq((frame.Recommendation:GetText() or ""):find("  names  ", 1, true), nil,
  "EndEvent Recommendation has no names token")

local started = Console:StartEvent()
assert_true(started ~= nil, "later StartEvent opens a new gathering")
assert_eq(frame.Recommendation:GetText() or "", "",
  "later StartEvent still paints empty Recommendation")

Console:SelectFighters(nil, nil)
assert_eq(Console.selectedFighterA, nil, "later StartEvent has no leftover selected A")
assert_eq(Console.selectedFighterB, nil, "later StartEvent has no leftover selected B")
assert_true(Gora:Petition(nameB.id, nameA.id) ~= nil, "named petition lands on the next event")
local recAgain = Console:Recommend()
assert_true(recAgain ~= nil, "new Recommend reaches Gora")
assert_eq(recAgain.namedOpponent, true, "new Recommend still stores namedOpponent")
local againText = frame.Recommendation:GetText() or ""
assert_true(againText:find("  names  ", 1, true) ~= nil,
  "new Recommend paints the names token again")
assert_true(againText:find("Chuckroast", 1, true) ~= nil,
  "new Recommend keeps name A")
assert_true(againText:find("Tendermage", 1, true) ~= nil,
  "new Recommend keeps name B")

assert_true(Runtime:EndEvent() ~= nil, "Runtime EndEvent bypasses the desk")
Console:Refresh()
assert_eq(frame.Recommendation:GetText() or "", "",
  "Runtime EndEvent then Refresh paints empty Recommendation")
assert_true(Console:StartEvent() ~= nil, "StartEvent after a leftover recommendation")
assert_eq(frame.Recommendation:GetText() or "", "",
  "successful StartEvent clears leftover Recommendation")

local srcLife = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcLife ~= nil, "Console.lua is readable for B24-A")
local srcLifeBody = srcLife:read("*a")
srcLife:close()
assert_true(srcLifeBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "successful StartEvent clears lastRecommendation before after")
assert_true(srcLifeBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "successful EndEvent clears lastRecommendation before after")
assert_true(srcLifeBody:find("local result, err = COB.Runtime:Continue()\n  return after(self, result, err)", 1, true) ~= nil,
  "Continue does not clear lastRecommendation")
assert_true(srcLifeBody:find("result.namedOpponent == true", 1, true) ~= nil,
  "Recommend still stores the namedOpponent flag")
assert_true(srcLifeBody:find('label = label .. "  names  "', 1, true) ~= nil,
  "recommendation line still appends the names token")
assert_eq(srcLifeBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcLifeBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcLifeBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcLifeBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcLifeBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B24-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B24-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B24-A")
end
runB24A()

--------------------------------------------------------------------------------
-- B25-A: lastRecommendation.namedOpponent is false when the Pope already
-- selected two different fighters. Petition-path Recommend (no selected
-- pair) still stores Core namedOpponent and paints "  names  ".
-- SaveNote nil. No DEMANDED. Petition line "  names  " stays.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB25A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_true(frame.Recommendation ~= nil, "recommendation line exists")
assert_eq(frame.Recommendation._type, "FontString", "recommendation is a FontString")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local nameA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local nameB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
assert_true(Console:StartEvent() ~= nil, "StartEvent for selected-pair Recommend")
Console:SelectFighters(nameA.id, nameB.id)
assert_eq(Console.selectedFighterA, nameA.id, "selected fighter A is set")
assert_eq(Console.selectedFighterB, nameB.id, "selected fighter B is set")
assert_true(Gora:Petition(nameB.id, nameA.id) ~= nil, "named petition lands on the selected pair")
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
  },
}
local recSelected = Console:Recommend()
assert_true(recSelected ~= nil, "Recommend still reaches Gora")
assert_eq(recSelected.namedOpponent, true, "Gora:Recommend still flags the named pair")
local selectedText = frame.Recommendation:GetText() or ""
assert_true(selectedText:find("Chuckroast", 1, true) ~= nil,
  "selected-pair Recommend keeps name A")
assert_true(selectedText:find("Tendermage", 1, true) ~= nil,
  "selected-pair Recommend keeps name B")
assert_true(selectedText:find("vs", 1, true) ~= nil,
  "selected-pair Recommend stays nameA vs nameB")
assert_eq(selectedText:find("  names  ", 1, true), nil,
  "already-selected pair does not paint the names token")
assert_eq(selectedText:find("DEMANDED", 1, true), nil,
  "selected-pair Recommend has no DEMANDED")
local petText = frame.PetitionsList:GetText() or ""
assert_true(petText:find("  names  ", 1, true) ~= nil,
  "petition line still paints the names token")

reset()
Console:Init()
local petitionA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local petitionB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
assert_eq(Console.selectedFighterA, nil, "no selected fighter A before petition-path Recommend")
assert_eq(Console.selectedFighterB, nil, "no selected fighter B before petition-path Recommend")
assert_true(Console:StartEvent() ~= nil, "StartEvent for petition-path Recommend")
assert_true(Gora:Petition(petitionB.id, petitionA.id) ~= nil, "named petition lands without a selected pair")
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
  },
}
local recPetition = Console:Recommend()
assert_true(recPetition ~= nil, "petition-path Recommend uses a named opponent")
assert_eq(recPetition.namedOpponent, true, "Gora:Recommend flags the named pair")
local petitionText = frame.Recommendation:GetText() or ""
assert_true(petitionText:find("  names  ", 1, true) ~= nil,
  "petition-path Recommend paints the names token")
assert_true(petitionText:find("Chuckroast", 1, true) ~= nil,
  "petition-path Recommend keeps name A")
assert_true(petitionText:find("Tendermage", 1, true) ~= nil,
  "petition-path Recommend keeps name B")
assert_eq(petitionText:find("DEMANDED", 1, true), nil,
  "petition-path Recommend has no DEMANDED")

local srcSel = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcSel ~= nil, "Console.lua is readable for B25-A")
local srcSelBody = srcSel:read("*a")
srcSel:close()
local recAt = srcSelBody:find("function Console:Recommend", 1, true)
assert_true(recAt ~= nil, "Recommend is in source")
local hadAt = srcSelBody:find("local hadSelected = isId(self.selectedFighterA)", recAt, true)
local pairAt = srcSelBody:find("a, b = recommendPair(self)", recAt, true)
local pickAt = srcSelBody:find("self:SelectFighters(a, b)", recAt, true)
assert_true(hadAt ~= nil, "hadSelected is computed from the already-selected pair")
assert_true(pairAt ~= nil, "Recommend still resolves recommendPair")
assert_true(pickAt ~= nil, "Recommend still SelectFighters the pair")
assert_true(hadAt ~= nil and pairAt ~= nil and hadAt < pairAt,
  "hadSelected is computed before recommendPair")
assert_true(hadAt ~= nil and pickAt ~= nil and hadAt < pickAt,
  "hadSelected is computed before SelectFighters")
assert_true(srcSelBody:find("namedOpponent = (not hadSelected) and result.namedOpponent == true", 1, true) ~= nil,
  "namedOpponent store is gated by hadSelected")
assert_true(srcSelBody:find("result.namedOpponent == true", 1, true) ~= nil,
  "Recommend still reads the Core namedOpponent flag")
assert_true(srcSelBody:find('label = label .. "  names  "', 1, true) ~= nil,
  "recommendation line still appends the names token")
assert_true(srcSelBody:find('left .. "  names  " .. right', 1, true) ~= nil,
  "petitionLine copy stays")
assert_eq(srcSelBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcSelBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcSelBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcSelBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcSelBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B25-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B25-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B25-A")
end
runB25A()

--------------------------------------------------------------------------------
-- B26-A: successful StartEvent / EndEvent nil selectedFighterA / B
-- before after(). Failed Start / failed End / Continue keep the pair.
-- lastRecommendation clear stays. B25-A hadSelected gate stays.
-- SaveNote nil. No DEMANDED.
-- Nested inside runB8E so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
local function runB26A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_true(frame.Recommendation ~= nil, "recommendation line exists")
assert_eq(frame.Recommendation._type, "FontString", "recommendation is a FontString")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local nameA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local nameB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
assert_true(Console:StartEvent() ~= nil, "StartEvent for selected-pair Recommend")
Console:SelectFighters(nameA.id, nameB.id)
assert_eq(Console.selectedFighterA, nameA.id, "selected fighter A is set")
assert_eq(Console.selectedFighterB, nameB.id, "selected fighter B is set")
assert_true(Gora:Petition(nameB.id, nameA.id) ~= nil, "named petition lands on the selected pair")
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
  },
}
local recSelected = Console:Recommend()
assert_true(recSelected ~= nil, "Recommend still reaches Gora")
assert_eq(recSelected.namedOpponent, true, "Gora:Recommend still flags the named pair")
local selectedText = frame.Recommendation:GetText() or ""
assert_true(selectedText:find("Chuckroast", 1, true) ~= nil,
  "selected-pair Recommend keeps name A")
assert_true(selectedText:find("Tendermage", 1, true) ~= nil,
  "selected-pair Recommend keeps name B")
assert_eq(selectedText:find("  names  ", 1, true), nil,
  "already-selected pair does not paint the names token")
assert_eq(selectedText:find("DEMANDED", 1, true), nil,
  "selected-pair Recommend has no DEMANDED")

local failStart = Console:StartEvent()
assert_eq(failStart, nil, "StartEvent refuses when already live")
assert_eq(Console.selectedFighterA, nameA.id, "failed StartEvent keeps selected A")
assert_eq(Console.selectedFighterB, nameB.id, "failed StartEvent keeps selected B")
local recAfterFail = Console:Recommend()
assert_true(recAfterFail ~= nil, "Recommend after failed Start still reaches Gora")
local failStartText = frame.Recommendation:GetText() or ""
assert_eq(failStartText:find("  names  ", 1, true), nil,
  "failed Start still has hadSelected and no names token")
assert_eq(Console.selectedFighterA, nameA.id, "Recommend after failed Start keeps selected A")
assert_eq(Console.selectedFighterB, nameB.id, "Recommend after failed Start keeps selected B")

assert_true(Console:OpenRite("Gora") ~= nil, "OpenRite for failed End pin")
local failEnd = Console:EndEvent()
assert_eq(failEnd, nil, "EndEvent refuses from RITE")
assert_eq(Console.selectedFighterA, nameA.id, "failed EndEvent keeps selected A")
assert_eq(Console.selectedFighterB, nameB.id, "failed EndEvent keeps selected B")
assert_true(Console:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
assert_true(Console:Continue() ~= nil, "Continue returns to ASSEMBLY")
assert_eq(Console.selectedFighterA, nameA.id, "Continue keeps selected A")
assert_eq(Console.selectedFighterB, nameB.id, "Continue keeps selected B")
local recAfterContinue = Console:Recommend()
assert_true(recAfterContinue ~= nil, "Recommend after Continue still reaches Gora")
local continueText = frame.Recommendation:GetText() or ""
assert_eq(continueText:find("  names  ", 1, true), nil,
  "Continue still has hadSelected and no names token")

local ended = Console:EndEvent()
assert_true(ended ~= nil, "EndEvent returns to QUIET")
assert_eq(Console.selectedFighterA, nil, "successful EndEvent nils selected A")
assert_eq(Console.selectedFighterB, nil, "successful EndEvent nils selected B")

local started = Console:StartEvent()
assert_true(started ~= nil, "later StartEvent opens a new gathering")
assert_eq(Console.selectedFighterA, nil, "successful StartEvent leaves selected A nil")
assert_eq(Console.selectedFighterB, nil, "successful StartEvent leaves selected B nil")
assert_true(Gora:Petition(nameB.id, nameA.id) ~= nil, "named petition lands without SelectFighters")
local recNext = Console:Recommend()
assert_true(recNext ~= nil, "petition-path Recommend after End then Start")
assert_eq(recNext.namedOpponent, true, "petition-path Recommend still stores namedOpponent")
local nextText = frame.Recommendation:GetText() or ""
assert_true(nextText:find("  names  ", 1, true) ~= nil,
  "End then Start then named Recommend paints the names token")
assert_true(nextText:find("Chuckroast", 1, true) ~= nil,
  "next Recommend keeps name A")
assert_true(nextText:find("Tendermage", 1, true) ~= nil,
  "next Recommend keeps name B")
assert_eq(nextText:find("DEMANDED", 1, true), nil,
  "next Recommend has no DEMANDED")

local srcLife = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcLife ~= nil, "Console.lua is readable for B26-A")
local srcLifeBody = srcLife:read("*a")
srcLife:close()
assert_true(srcLifeBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "successful StartEvent nils lastRecommendation and the selected pair before after")
assert_true(srcLifeBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "successful EndEvent nils lastRecommendation and the selected pair before after")
assert_true(srcLifeBody:find("local result, err = COB.Runtime:Continue()\n  return after(self, result, err)", 1, true) ~= nil,
  "Continue does not clear the selected pair")
assert_true(srcLifeBody:find("local hadSelected = isId(self.selectedFighterA)", 1, true) ~= nil,
  "hadSelected gate stays")
assert_true(srcLifeBody:find("namedOpponent = (not hadSelected) and result.namedOpponent == true", 1, true) ~= nil,
  "namedOpponent store is still gated by hadSelected")
assert_true(srcLifeBody:find('label = label .. "  names  "', 1, true) ~= nil,
  "recommendation line still appends the names token")
assert_eq(srcLifeBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcLifeBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcLifeBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcLifeBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcLifeBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B26-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B26-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B26-A")
end
runB26A()

--------------------------------------------------------------------------------
-- B27-A: Init early-return remounts ChurchOfBeefConsoleFrame after a
-- wiped UISpecialFrames. Do not rebuild. B14-D uniqueness / B26-A pins
-- stay. SaveNote nil. Isolation wrap stays.
--------------------------------------------------------------------------------
local function runB27A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "B14-D uniqueness: ChurchOfBeefConsoleFrame once before wipe")

local srcEsc = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcEsc ~= nil, "Console.lua is readable for B27-A")
local srcEscBody = srcEsc:read("*a")
srcEsc:close()
local earlyInit = srcEscBody:match("function Console:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
assert_true(type(earlyInit) == "string" and earlyInit ~= "",
  "Init early-return body is readable")
assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "early-return rememberSpecial FRAME_NAME")
assert_eq(earlyInit:find("buildFrame", 1, true), nil,
  "early-return does not rebuild")
assert_eq(earlyInit:find("PlaySound", 1, true), nil,
  "early-return does not PlaySound")
assert_eq(earlyInit:find("CreateFrame", 1, true), nil,
  "early-return does not CreateFrame")
assert_true(srcEscBody:find("local function rememberSpecial", 1, true) ~= nil,
  "rememberSpecial helper stays")
assert_true(srcEscBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "buildFrame still rememberSpecial FRAME_NAME")
assert_true(srcEscBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "B26-A successful StartEvent still nils the selected pair")
assert_true(srcEscBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "B26-A successful EndEvent still nils the selected pair")
assert_eq(srcEscBody:find("IG_CHARACTER_INFO", 1, true), nil,
  "source does not PlaySound IG_CHARACTER_INFO_*")
assert_eq(srcEscBody:find("PlaySound", 1, true), nil, "source must not PlaySound")
assert_eq(srcEscBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcEscBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcEscBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcEscBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local existing = Console.frame
assert_true(existing ~= nil, "B27-A Init creates the desk")
assert_eq(existing:GetName(), "ChurchOfBeefConsoleFrame",
  "B27-A desk name stays ChurchOfBeefConsoleFrame")
local savedSpecial = UISpecialFrames
UISpecialFrames = {}
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 0,
  "wipe clears ChurchOfBeefConsoleFrame")
local createCalls = 0
local savedCreateFrame = CreateFrame
CreateFrame = function(...)
  createCalls = createCalls + 1
  return savedCreateFrame(...)
end
local same = Console:Init()
CreateFrame = savedCreateFrame
assert_eq(same, existing, "second Init returns the existing frame")
assert_eq(Console.frame, existing, "early-return does not rebuild")
assert_eq(same:GetName(), "ChurchOfBeefConsoleFrame",
  "second Init keeps the named frame")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "wiped UISpecialFrames + second Init lists ChurchOfBeefConsoleFrame once")
assert_eq(createCalls, 0, "second Init does not CreateFrame")
Console:Init()
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "third Init after wipe does not duplicate ChurchOfBeefConsoleFrame")
assert_eq(Console.frame, existing, "third Init still does not rebuild")
assert_eq(Console:Init(), existing, "third Init still same frame")
UISpecialFrames = savedSpecial

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B27-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B27-A")
end
runB27A()

--------------------------------------------------------------------------------
-- B28-A: Show / Refresh remount ChurchOfBeefConsoleFrame after a
-- wiped UISpecialFrames. Do not rebuild. B27-A Init remount /
-- B14-D uniqueness / B26-A pins stay. SaveNote nil. Isolation wrap stays.
--------------------------------------------------------------------------------
local function runB28A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "B14-D uniqueness: ChurchOfBeefConsoleFrame once before wipe")

local srcEsc = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcEsc ~= nil, "Console.lua is readable for B28-A")
local srcEscBody = srcEsc:read("*a")
srcEsc:close()
local earlyInit = srcEscBody:match("function Console:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
assert_true(type(earlyInit) == "string" and earlyInit ~= "",
  "Init early-return body is readable")
assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "B27-A early-return rememberSpecial FRAME_NAME stays")
assert_eq(earlyInit:find("buildFrame", 1, true), nil,
  "B27-A early-return does not rebuild")
local refreshFn = srcEscBody:match("function Console:Refresh%(%)(.-)\nfunction Console:Show")
assert_true(type(refreshFn) == "string" and refreshFn ~= "",
  "Refresh body is readable")
assert_true(refreshFn:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "Refresh rememberSpecial FRAME_NAME")
assert_eq(refreshFn:find("buildFrame", 1, true), nil,
  "Refresh does not rebuild")
assert_eq(refreshFn:find("PlaySound", 1, true), nil,
  "Refresh does not PlaySound")
assert_eq(refreshFn:find("CreateFrame", 1, true), nil,
  "Refresh does not CreateFrame")
local showFn = srcEscBody:match("function Console:Show%(%)(.-)\nfunction Console:Hide")
assert_true(type(showFn) == "string" and showFn ~= "",
  "Show body is readable")
assert_true(showFn:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "Show rememberSpecial FRAME_NAME")
assert_eq(showFn:find("buildFrame", 1, true), nil,
  "Show does not rebuild")
assert_eq(showFn:find("PlaySound", 1, true), nil,
  "Show does not PlaySound")
assert_eq(showFn:find("CreateFrame", 1, true), nil,
  "Show does not CreateFrame")
assert_true(srcEscBody:find("local function rememberSpecial", 1, true) ~= nil,
  "rememberSpecial helper stays")
assert_true(srcEscBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "buildFrame still rememberSpecial FRAME_NAME")
assert_true(srcEscBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "B26-A successful StartEvent still nils the selected pair")
assert_true(srcEscBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "B26-A successful EndEvent still nils the selected pair")
assert_eq(srcEscBody:find("IG_CHARACTER_INFO", 1, true), nil,
  "source does not PlaySound IG_CHARACTER_INFO_*")
assert_eq(srcEscBody:find("PlaySound", 1, true), nil, "source must not PlaySound")
assert_eq(srcEscBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcEscBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcEscBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcEscBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local existing = Console.frame
assert_true(existing ~= nil, "B28-A Init creates the desk")
assert_eq(existing:GetName(), "ChurchOfBeefConsoleFrame",
  "B28-A desk name stays ChurchOfBeefConsoleFrame")
local savedSpecial = UISpecialFrames
UISpecialFrames = {}
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 0,
  "wipe clears ChurchOfBeefConsoleFrame before Show")
local createCalls = 0
local savedCreateFrame = CreateFrame
CreateFrame = function(...)
  createCalls = createCalls + 1
  return savedCreateFrame(...)
end
Console:Show()
CreateFrame = savedCreateFrame
assert_eq(Console.frame, existing, "Show-only does not rebuild")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "wiped UISpecialFrames + Show-only lists ChurchOfBeefConsoleFrame once")
assert_eq(createCalls, 0, "Show-only does not CreateFrame")

UISpecialFrames = {}
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 0,
  "second wipe clears ChurchOfBeefConsoleFrame before Refresh")
createCalls = 0
savedCreateFrame = CreateFrame
CreateFrame = function(...)
  createCalls = createCalls + 1
  return savedCreateFrame(...)
end
Console:Refresh()
CreateFrame = savedCreateFrame
assert_eq(Console.frame, existing, "Refresh-only does not rebuild")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "wiped UISpecialFrames + Refresh-only lists ChurchOfBeefConsoleFrame once")
assert_eq(createCalls, 0, "Refresh-only does not CreateFrame")
assert_eq(Console.frame, existing, "Show and Refresh keep the same frame pointer")
UISpecialFrames = savedSpecial

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B28-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B28-A")
end
runB28A()

--------------------------------------------------------------------------------
-- B29-A: Hide remounts ChurchOfBeefConsoleFrame after a wiped
-- UISpecialFrames. Toggle-hide remounts via Hide. Do not rebuild.
-- B28-A Show/Refresh / B27-A Init remount / B14-D uniqueness /
-- B26-A pins stay. SaveNote nil. Isolation wrap stays.
--------------------------------------------------------------------------------
local function runB29A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "B14-D uniqueness: ChurchOfBeefConsoleFrame once before wipe")

local srcEsc = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcEsc ~= nil, "Console.lua is readable for B29-A")
local srcEscBody = srcEsc:read("*a")
srcEsc:close()
local earlyInit = srcEscBody:match("function Console:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
assert_true(type(earlyInit) == "string" and earlyInit ~= "",
  "Init early-return body is readable")
assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "B27-A early-return rememberSpecial FRAME_NAME stays")
assert_eq(earlyInit:find("buildFrame", 1, true), nil,
  "B27-A early-return does not rebuild")
local refreshFn = srcEscBody:match("function Console:Refresh%(%)(.-)\nfunction Console:Show")
assert_true(type(refreshFn) == "string" and refreshFn ~= "",
  "Refresh body is readable")
assert_true(refreshFn:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "B28-A Refresh rememberSpecial FRAME_NAME stays")
assert_eq(refreshFn:find("buildFrame", 1, true), nil,
  "B28-A Refresh does not rebuild")
local showFn = srcEscBody:match("function Console:Show%(%)(.-)\nfunction Console:Hide")
assert_true(type(showFn) == "string" and showFn ~= "",
  "Show body is readable")
assert_true(showFn:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "B28-A Show rememberSpecial FRAME_NAME stays")
assert_eq(showFn:find("buildFrame", 1, true), nil,
  "B28-A Show does not rebuild")
local hideFn = srcEscBody:match("function Console:Hide%(%)(.-)\nfunction Console:IsShown")
assert_true(type(hideFn) == "string" and hideFn ~= "",
  "Hide body is readable")
assert_true(hideFn:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "Hide rememberSpecial FRAME_NAME")
assert_eq(hideFn:find("buildFrame", 1, true), nil,
  "Hide does not rebuild")
assert_eq(hideFn:find("PlaySound", 1, true), nil,
  "Hide does not PlaySound")
assert_eq(hideFn:find("CreateFrame", 1, true), nil,
  "Hide does not CreateFrame")
assert_true(srcEscBody:find("local function rememberSpecial", 1, true) ~= nil,
  "rememberSpecial helper stays")
assert_true(srcEscBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "buildFrame still rememberSpecial FRAME_NAME")
assert_true(srcEscBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "B26-A successful StartEvent still nils the selected pair")
assert_true(srcEscBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "B26-A successful EndEvent still nils the selected pair")
assert_eq(srcEscBody:find("IG_CHARACTER_INFO", 1, true), nil,
  "source does not PlaySound IG_CHARACTER_INFO_*")
assert_eq(srcEscBody:find("PlaySound", 1, true), nil, "source must not PlaySound")
assert_eq(srcEscBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcEscBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcEscBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcEscBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local existing = Console.frame
assert_true(existing ~= nil, "B29-A Init creates the desk")
assert_eq(existing:GetName(), "ChurchOfBeefConsoleFrame",
  "B29-A desk name stays ChurchOfBeefConsoleFrame")
local savedSpecial = UISpecialFrames
UISpecialFrames = {}
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 0,
  "wipe clears ChurchOfBeefConsoleFrame before Hide")
local createCalls = 0
local savedCreateFrame = CreateFrame
CreateFrame = function(...)
  createCalls = createCalls + 1
  return savedCreateFrame(...)
end
Console:Hide()
CreateFrame = savedCreateFrame
assert_eq(Console.frame, existing, "Hide-only does not rebuild")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "wiped UISpecialFrames + Hide-only lists ChurchOfBeefConsoleFrame once")
assert_eq(createCalls, 0, "Hide-only does not CreateFrame")

existing:Show()
assert_eq(Console:IsShown(), true, "desk is shown before Toggle-hide")
UISpecialFrames = {}
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 0,
  "second wipe clears ChurchOfBeefConsoleFrame before Toggle-hide")
createCalls = 0
savedCreateFrame = CreateFrame
CreateFrame = function(...)
  createCalls = createCalls + 1
  return savedCreateFrame(...)
end
Console:Toggle()
CreateFrame = savedCreateFrame
assert_eq(Console:IsShown(), false, "Toggle while shown hides the desk")
assert_eq(Console.frame, existing, "Toggle-hide does not rebuild")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "wiped UISpecialFrames + Toggle-hide lists ChurchOfBeefConsoleFrame once")
assert_eq(createCalls, 0, "Toggle-hide does not CreateFrame")
assert_eq(Console.frame, existing, "Hide and Toggle keep the same frame pointer")
UISpecialFrames = savedSpecial

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B29-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B29-A")
end
runB29A()

--------------------------------------------------------------------------------
-- B31-A: Refresh in QUIET (or nil Runtime state) nils lastRecommendation
-- before paintRecommendation. Runtime:EndEvent leftover is empty.
-- Recommend during a live event still paints. Selected pair stays.
-- StartEvent / EndEvent pair-clear stay. Continue does not clear.
-- SaveNote nil. No SUMMON. Nested inside runB8E after runB29A().
--------------------------------------------------------------------------------
local function runB31A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_true(frame.Recommendation ~= nil, "recommendation line exists")
assert_eq(frame.Recommendation._type, "FontString", "recommendation is a FontString")

local srcQuiet = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcQuiet ~= nil, "Console.lua is readable for B31-A")
local srcQuietBody = srcQuiet:read("*a")
srcQuiet:close()
local refreshFn = srcQuietBody:match("function Console:Refresh%(%)(.-)\nfunction Console:Show")
assert_true(type(refreshFn) == "string" and refreshFn ~= "",
  "Refresh body is readable")
assert_true(refreshFn:find('state == nil or state == "QUIET"', 1, true) ~= nil,
  "Refresh treats nil or QUIET Runtime state as a leftover drop")
assert_true(refreshFn:find("lastRecommendation = nil", 1, true) ~= nil,
  "Refresh nils lastRecommendation when state is QUIET")
local dropAt = refreshFn:find("lastRecommendation = nil", 1, true)
local paintAt = refreshFn:find("paintRecommendation(self.frame)", 1, true)
assert_true(type(dropAt) == "number" and type(paintAt) == "number" and dropAt < paintAt,
  "Refresh nils lastRecommendation before paintRecommendation")
assert_eq(refreshFn:find("selectedFighterA", 1, true), nil,
  "Refresh does not nil selectedFighterA")
assert_eq(refreshFn:find("selectedFighterB", 1, true), nil,
  "Refresh does not nil selectedFighterB")
assert_true(srcQuietBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "B26-A successful StartEvent still nils the selected pair")
assert_true(srcQuietBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "B26-A successful EndEvent still nils the selected pair")
assert_true(srcQuietBody:find("local result, err = COB.Runtime:Continue()\n  return after(self, result, err)", 1, true) ~= nil,
  "Continue does not clear lastRecommendation")
assert_true(srcQuietBody:find('label = label .. "  names  "', 1, true) ~= nil,
  "recommendation line still appends the names token")
assert_eq(srcQuietBody:find("DEMANDED", 1, true), nil, "source must not invent DEMANDED")
assert_eq(srcQuietBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcQuietBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcQuietBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcQuietBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local nameA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local nameB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
Console:SelectFighters(nameA.id, nameB.id)
assert_eq(Console.selectedFighterA, nameA.id, "QUIET pick seats fighter A")
assert_eq(Console.selectedFighterB, nameB.id, "QUIET pick seats fighter B")
Console:Refresh()
assert_eq(Console.selectedFighterA, nameA.id, "QUIET Refresh keeps selected fighter A")
assert_eq(Console.selectedFighterB, nameB.id, "QUIET Refresh keeps selected fighter B")

assert_true(Console:StartEvent() ~= nil, "StartEvent for live Recommend")
assert_true(Gora:Petition(nameB.id, nameA.id) ~= nil, "named petition lands")
COB.Roster = {
  ready = true,
  members = {
    chuckroast = { name = "Chuckroast", guildRankIndex = 4 },
    tendermage = { name = "Tendermage", guildRankIndex = 5 },
  },
}
local recLive = Console:Recommend()
assert_true(recLive ~= nil, "Recommend during a live event reaches Gora")
local liveText = frame.Recommendation:GetText() or ""
assert_true(liveText ~= "", "live Recommend paints a pair")
assert_true(liveText:find("  names  ", 1, true) ~= nil,
  "live Recommend paints the names token")
assert_true(liveText:find("Chuckroast", 1, true) ~= nil,
  "live Recommend keeps name A")
assert_true(liveText:find("Tendermage", 1, true) ~= nil,
  "live Recommend keeps name B")
Console:Refresh()
assert_eq(frame.Recommendation:GetText() or "", liveText,
  "Recommend during a live event still paints")

assert_true(Runtime:EndEvent() ~= nil, "Runtime EndEvent bypasses the desk")
Console:Refresh()
assert_eq(frame.Recommendation:GetText() or "", "",
  "Runtime EndEvent then Refresh paints empty Recommendation")
assert_eq((frame.Recommendation:GetText() or ""):find("  names  ", 1, true), nil,
  "Runtime EndEvent Recommendation has no names token")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B31-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B31-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B31-A")
end
runB31A()

--------------------------------------------------------------------------------
-- B32-B: Console:Dismiss also reaches Confession:Dismiss when present.
-- Same id. Gora path and "gora is not available" stay. Missing Confession
-- stays Gora-only. One stock Dismiss. No second button. No theater.
-- CallForward pins stay. SaveNote nil. No SUMMON.
-- Nested inside runB8E after runB31A().
--------------------------------------------------------------------------------
local function runB32B()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_eq(type(Console.Dismiss), "function", "Dismiss stays a console verb")
assert_eq(type(Console.CallForward), "function", "CallForward pins stay")
local dismissCount = 0
walk(frame, function(child)
  if child._type == "Button" and child.GetText and child:GetText() == "Dismiss" then
    dismissCount = dismissCount + 1
  end
end)
assert_eq(dismissCount, 1, "no second Dismiss plate")
assert_true(findButton(frame, "Dismiss") ~= nil, "Gora Dismiss stays")
assert_eq(findButton(frame, "Dismiss")._template, "UIPanelButtonTemplate",
  "Dismiss stays UIPanelButtonTemplate")

local srcDismiss = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcDismiss ~= nil, "Console.lua is readable for B32-B")
local srcDismissBody = srcDismiss:read("*a")
srcDismiss:close()
local dismissFn = srcDismissBody:match("function Console:Dismiss%(characterId%)(.-)\nfunction Console:DeclareVictor")
assert_true(type(dismissFn) == "string" and dismissFn ~= "",
  "Dismiss body is readable")
assert_true(dismissFn:find('return nil, "gora is not available"', 1, true) ~= nil,
  "Dismiss keeps the gora is not available refuse")
assert_true(dismissFn:find("if not COB.Gora or not COB.Gora.Dismiss then", 1, true) ~= nil,
  "Dismiss still requires Gora.Dismiss")
assert_true(dismissFn:find("local id = characterId or self.selectedCharacterId", 1, true) ~= nil,
  "Dismiss resolves one id for Gora and Confession")
assert_true(dismissFn:find("COB.Gora:Dismiss(id)", 1, true) ~= nil,
  "Dismiss still reaches Gora with that id")
assert_true(dismissFn:find('type(COB.Confession.Dismiss) == "function"', 1, true) ~= nil,
  "Dismiss type-guards Confession.Dismiss")
assert_true(dismissFn:find("COB.Confession:Dismiss(id)", 1, true) ~= nil,
  "Dismiss reaches Confession with the same id")
assert_true(dismissFn:find("if ok then\n    self.selectedCharacterId = nil\n    if isId(id) and (id == self.selectedFighterA or id == self.selectedFighterB) then\n      lastRecommendation = nil\n      self.selectedFighterA = nil\n      self.selectedFighterB = nil\n    end\n    self:Refresh()\n  end", 1, true) ~= nil,
  "Dismiss Refreshs when either succeeded, after nilling the character pick and a matching pair")
assert_eq(dismissFn:find("after(", 1, true), nil, "Dismiss does not fan-out through after()")
assert_eq(dismissFn:find("PlaySound", 1, true), nil, "Dismiss does not PlaySound")
assert_eq(dismissFn:find("playCue", 1, true), nil, "Dismiss does not playCue")
assert_true(srcDismissBody:find("function Console:CallForward(characterId)", 1, true) ~= nil,
  "CallForward source pin stays")
assert_true(srcDismissBody:find("Confession:CallForward", 1, true) ~= nil,
  "CallForward still reaches Confession")
assert_true(srcDismissBody:find('stockButton(right, "Dismiss", function() Console:Dismiss() end)', 1, true) ~= nil,
  "one stock Dismiss button stays")
assert_eq(srcDismissBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcDismissBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcDismissBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcDismissBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
assert_true(Console:StartEvent() ~= nil, "StartEvent for a live petition")
local petitioner = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local confessionId
local confessionCalls = 0
local goraIds = {}
local realGoraDismiss = Gora.Dismiss
Gora.Dismiss = function(self, id)
  goraIds[#goraIds + 1] = id
  return realGoraDismiss(self, id)
end
COB.Confession = {
  GetQueue = function()
    return {}
  end,
  Dismiss = function(_, characterId)
    confessionCalls = confessionCalls + 1
    confessionId = characterId
    return true
  end,
}
local soundRec = {}
local toastCalls = 0
local chats = 0
local savedSound = COB.Sound
local savedToasts = COB.Toasts
local savedChat = SendChatMessage
COB.Sound = {
  Play = function(_, name)
    soundRec[#soundRec + 1] = name
    return name
  end,
}
COB.Toasts = {
  Show = function()
    toastCalls = toastCalls + 1
  end,
}
SendChatMessage = function()
  chats = chats + 1
end

Gora:Petition(petitioner.id)
assert_eq(Console:Dismiss(petitioner.id), true, "Dismiss reaches Gora and Confession")
assert_eq(confessionCalls, 1, "Dismiss reaches Confession:Dismiss")
assert_eq(confessionId, petitioner.id, "Confession:Dismiss receives the same id")
assert_eq(#goraIds, 1, "Dismiss still reaches Gora")
assert_eq(goraIds[1], petitioner.id, "Gora:Dismiss receives the same id")
assert_eq(#soundRec, 0, "Dismiss does not play Sound")
assert_eq(toastCalls, 0, "Dismiss does not toast")
assert_eq(chats, 0, "Dismiss does not SendChatMessage")

assert_eq(Console:Dismiss(petitioner.id), true, "Confession success still returns true")
assert_eq(confessionCalls, 2, "Confession:Dismiss runs when Gora has no petition")
assert_eq(confessionId, petitioner.id, "either-succeeded still uses the same id")
assert_eq(#goraIds, 2, "Gora:Dismiss still runs when the petition is gone")
assert_eq(#soundRec, 0, "either-succeeded Dismiss does not play Sound")
assert_eq(toastCalls, 0, "either-succeeded Dismiss does not toast")
assert_eq(chats, 0, "either-succeeded Dismiss does not SendChatMessage")

COB.Confession = {
  GetQueue = function()
    return {}
  end,
}
Gora:Petition(petitioner.id)
assert_eq(Console:Dismiss(petitioner.id), true, "Confession without Dismiss still reaches Gora")
assert_eq(confessionCalls, 2, "missing Confession.Dismiss does not call the prior stub")

COB.Confession = nil
Gora:Petition(petitioner.id)
assert_eq(Console:Dismiss(petitioner.id), true, "missing Confession: Gora Dismiss still true")
assert_eq(#soundRec, 0, "Gora-only Dismiss does not play Sound")
assert_eq(toastCalls, 0, "Gora-only Dismiss does not toast")
assert_eq(chats, 0, "Gora-only Dismiss does not SendChatMessage")

Gora.Dismiss = nil
local missingOk, missingErr = Console:Dismiss(petitioner.id)
assert_eq(missingOk, nil, "missing Gora.Dismiss refuses")
assert_eq(missingErr, "gora is not available", "gora is not available refuse stays")
Gora.Dismiss = realGoraDismiss

COB.Sound = savedSound
COB.Toasts = savedToasts
SendChatMessage = savedChat
COB.Confession = nil
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B32-B wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B32-B")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B32-B")
end
runB32B()

--------------------------------------------------------------------------------
-- B33-B: Presence here == false stock SetAlpha(0.45) after paintRowButtons.
-- Roster here == true stays 1. Petition rows are not dimmed. No mute
-- suffix / offline / away. Fail-open membership stays. SaveNote nil.
-- No SUMMON. No UnitIsDead. Nested inside runB8E after runB32B().
--------------------------------------------------------------------------------
local function runB33B()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local srcHere = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcHere ~= nil, "Console.lua is readable for B33-B")
local srcHereBody = srcHere:read("*a")
srcHere:close()
local paintPresenceFn = srcHereBody:match(
  "local function paintPresence%(frame, rows%)(.-)\nlocal function paintPetitions")
assert_true(type(paintPresenceFn) == "string" and paintPresenceFn ~= "",
  "paintPresence body is readable")
assert_true(paintPresenceFn:find("paintRowButtons", 1, true) ~= nil,
  "paintPresence still uses paintRowButtons")
assert_true(paintPresenceFn:find("here == false", 1, true) ~= nil,
  "paintPresence honors here == false after paint")
assert_true(paintPresenceFn:find("SetAlpha(0.45)", 1, true) ~= nil,
  "paintPresence SetAlpha(0.45) when here == false")
assert_true(paintPresenceFn:find("SetAlpha(1)", 1, true) ~= nil,
  "paintPresence SetAlpha(1) when here is not false")
assert_eq(paintPresenceFn:find("offline", 1, true), nil,
  "paintPresence does not add an offline suffix")
assert_eq(paintPresenceFn:find("away", 1, true), nil,
  "paintPresence does not add an away suffix")
assert_eq(paintPresenceFn:find("UnitIsDead", 1, true), nil,
  "paintPresence does not scrape UnitIsDead")
local paintRowButtonsFn = srcHereBody:match(
  "local function paintRowButtons%(pool, parent, rows, lineOf, selectedOf, onClick%)(.-)\nlocal function placeRow")
assert_true(type(paintRowButtonsFn) == "string" and paintRowButtonsFn ~= "",
  "paintRowButtons body is readable")
assert_eq(paintRowButtonsFn:find("SetAlpha", 1, true), nil,
  "paintRowButtons itself does not SetAlpha")
local paintPetitionsFn = srcHereBody:match(
  "local function paintPetitions%(frame, petitions%)(.-)\nlocal function paintRuntime")
assert_true(type(paintPetitionsFn) == "string" and paintPetitionsFn ~= "",
  "paintPetitions body is readable")
assert_eq(paintPetitionsFn:find("SetAlpha", 1, true), nil,
  "paintPetitions does not dim petition rows")
local paintConfessionsFn = srcHereBody:match(
  "local function paintConfessions%(frame, rows%)(.-)\nlocal function paintKnightingLine")
assert_true(type(paintConfessionsFn) == "string" and paintConfessionsFn ~= "",
  "paintConfessions body is readable")
assert_eq(paintConfessionsFn:find("SetAlpha", 1, true), nil,
  "paintConfessions does not dim confession rows")
local paintKnightingFn = srcHereBody:match(
  "local function paintKnightingLine%(frame, rows%)(.-)\nlocal function paintRecommendation")
assert_true(type(paintKnightingFn) == "string" and paintKnightingFn ~= "",
  "paintKnightingLine body is readable")
assert_eq(paintKnightingFn:find("SetAlpha", 1, true), nil,
  "paintKnightingLine does not dim knighting rows")
local presenceLineFn = srcHereBody:match(
  "local function presenceLine%(row%)(.-)\nlocal function h2hScore")
assert_true(type(presenceLineFn) == "string" and presenceLineFn ~= "",
  "presenceLine body is readable")
assert_eq(presenceLineFn:find("offline", 1, true), nil,
  "presenceLine does not add offline")
assert_eq(presenceLineFn:find("away", 1, true), nil,
  "presenceLine does not add away")
assert_eq(presenceLineFn:find("here", 1, true), nil,
  "presenceLine still ignores the here flag for copy")
assert_true(srcHereBody:find("here = true", 1, true) ~= nil,
  "GetPresence roster rows stay here true")
assert_true(srcHereBody:find("here = false", 1, true) ~= nil,
  "GetPresence Store-only rows stay here false")
assert_eq(srcHereBody:find("UnitIsDead", 1, true), nil, "source must not scrape UnitIsDead")
assert_eq(srcHereBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcHereBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcHereBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcHereBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local function pinAlpha(btn)
  if type(btn) ~= "table" then return end
  btn._alpha = 1
  btn.SetAlpha = function(self, a)
    self._alpha = a
  end
  btn.GetAlpha = function(self)
    return self._alpha
  end
end
local function pinPool(pool)
  if type(pool) ~= "table" then return end
  for i = 1, #pool do
    pinAlpha(pool[i])
  end
end
pinPool(frame.PresenceRows)
pinPool(frame.PetitionRows)
pinPool(frame.ConfessionRows)
pinPool(frame.KnightingRows)
local savedCreate = CreateFrame
CreateFrame = function(frameType, name, parent, template)
  local w = savedCreate(frameType, name, parent, template)
  if frameType == "Button" then
    pinAlpha(w)
  end
  return w
end
local function stubAlpha(btn)
  if type(btn) ~= "table" then return nil end
  if type(btn.GetAlpha) == "function" then
    local a = btn:GetAlpha()
    if a ~= nil then return a end
  end
  return btn._alpha
end
local function almost(a, want, msg)
  assert_true(type(a) == "number" and math.abs(a - want) < 0.001, msg)
end

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local human, localChar = seedLinked("Beefina", "Steve", 1)
local otherHuman, otherChar = seedLinked("Chuckroast", "Chuck", 3)
assert_eq(human.id ~= nil, true, "local human fixture exists")
assert_eq(otherHuman.id ~= nil, true, "Store human fixture exists")
assert_true(Console:StartEvent() ~= nil, "StartEvent for a live petition")
assert_true(Gora:Petition(localChar.id) ~= nil, "roster member petition lands")
COB.Roster = {
  ready = true,
  complete = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local presenceOpen = Console:GetPresence()
assert_eq(#presenceOpen, 2, "fail-open membership still lists member and Store-only")
assert_eq(presenceOpen[1] and presenceOpen[1].name, "Beefina", "seed member stays first")
assert_eq(presenceOpen[1] and presenceOpen[1].here, true, "roster member stays here")
assert_eq(presenceOpen[1] and presenceOpen[1].characterId, localChar.id, "seed member keeps characterId")
assert_eq(presenceOpen[2] and presenceOpen[2].name, "Chuckroast", "Store-only character is still listed")
assert_eq(presenceOpen[2] and presenceOpen[2].here, false, "Store-only stays not here")
assert_eq(presenceOpen[2] and presenceOpen[2].characterId, otherChar.id, "Chuckroast keeps characterId")
Console:Refresh()

local hereBtn
local storeBtn
local painted = rawget(frame, "PresenceRows")
assert_true(type(painted) == "table", "Presence rows painted")
for i = 1, #painted do
  local btn = painted[i]
  local row = btn and btn._row
  if row and row.characterId == localChar.id then
    hereBtn = btn
  elseif row and row.characterId == otherChar.id then
    storeBtn = btn
  end
end
assert_true(hereBtn ~= nil, "roster here == true row is painted")
assert_true(storeBtn ~= nil, "fail-open Store row is painted")
almost(stubAlpha(hereBtn), 1, "roster here == true stays alpha 1")
almost(stubAlpha(storeBtn), 0.45, "fail-open here == false SetAlpha ~0.45")
local storeLabel = storeBtn:GetText() or ""
assert_true(storeLabel:find("Chuckroast", 1, true) ~= nil, "Store-only label keeps the name")
assert_eq(storeLabel:find("offline", 1, true), nil, "Store-only label has no offline suffix")
assert_eq(storeLabel:find("away", 1, true), nil, "Store-only label has no away suffix")
assert_eq(storeLabel:find("not here", 1, true), nil, "Store-only label has no not-here suffix")

local petBtn = frame.PetitionRows and frame.PetitionRows[1]
assert_true(petBtn ~= nil, "petition row is painted")
almost(stubAlpha(petBtn), 1, "petition rows are not dimmed")

CreateFrame = savedCreate
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B33-B wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B33-B")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B33-B")
end
runB33B()

--------------------------------------------------------------------------------
-- B34-B: leftover Presence Hide resets SetAlpha(1). Visible here == false
-- stays 0.45 after paintPresence. Visible here ~= false stays 1.
-- Petitions stay undimmed. No offline / away. Fail-open membership stays.
-- SaveNote nil. No SUMMON. No UnitIsDead. Nested inside runB8E after
-- runB33B().
--------------------------------------------------------------------------------
local function runB34B()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local srcAlpha = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcAlpha ~= nil, "Console.lua is readable for B34-B")
local srcAlphaBody = srcAlpha:read("*a")
srcAlpha:close()
local acquireRowsFn = srcAlphaBody:match(
  "local function acquireRows%(pool, parent, count, width%)(.-)\nlocal function paintRowButtons")
assert_true(type(acquireRowsFn) == "string" and acquireRowsFn ~= "",
  "acquireRows body is readable")
assert_true(acquireRowsFn:find("count + 1", 1, true) ~= nil,
  "acquireRows still hides the leftover tail")
assert_true(acquireRowsFn:find(":Hide()", 1, true) ~= nil,
  "acquireRows leftover tail still Hide")
assert_true(acquireRowsFn:find("SetAlpha(1)", 1, true) ~= nil,
  "acquireRows leftover hide SetAlpha(1)")
assert_true(acquireRowsFn:find("SetAlpha", 1, true) ~= nil,
  "acquireRows leftover reset is type-guarded SetAlpha")
local paintPresenceFn = srcAlphaBody:match(
  "local function paintPresence%(frame, rows%)(.-)\nlocal function paintPetitions")
assert_true(type(paintPresenceFn) == "string" and paintPresenceFn ~= "",
  "paintPresence body is readable")
assert_true(paintPresenceFn:find("paintRowButtons", 1, true) ~= nil,
  "paintPresence still uses paintRowButtons")
assert_true(paintPresenceFn:find("here == false", 1, true) ~= nil,
  "paintPresence still honors here == false after paint")
assert_true(paintPresenceFn:find("SetAlpha(0.45)", 1, true) ~= nil,
  "paintPresence still SetAlpha(0.45) when here == false")
assert_true(paintPresenceFn:find("SetAlpha(1)", 1, true) ~= nil,
  "paintPresence still SetAlpha(1) when here is not false")
assert_eq(paintPresenceFn:find("offline", 1, true), nil,
  "paintPresence does not add an offline suffix")
assert_eq(paintPresenceFn:find("away", 1, true), nil,
  "paintPresence does not add an away suffix")
assert_eq(paintPresenceFn:find("UnitIsDead", 1, true), nil,
  "paintPresence does not scrape UnitIsDead")
local paintRowButtonsFn = srcAlphaBody:match(
  "local function paintRowButtons%(pool, parent, rows, lineOf, selectedOf, onClick%)(.-)\nlocal function placeRow")
assert_true(type(paintRowButtonsFn) == "string" and paintRowButtonsFn ~= "",
  "paintRowButtons body is readable")
assert_eq(paintRowButtonsFn:find("SetAlpha", 1, true), nil,
  "paintRowButtons itself does not SetAlpha")
local paintPetitionsFn = srcAlphaBody:match(
  "local function paintPetitions%(frame, petitions%)(.-)\nlocal function paintRuntime")
assert_true(type(paintPetitionsFn) == "string" and paintPetitionsFn ~= "",
  "paintPetitions body is readable")
assert_eq(paintPetitionsFn:find("SetAlpha", 1, true), nil,
  "paintPetitions does not dim petition rows")
local paintConfessionsFn = srcAlphaBody:match(
  "local function paintConfessions%(frame, rows%)(.-)\nlocal function paintKnightingLine")
assert_true(type(paintConfessionsFn) == "string" and paintConfessionsFn ~= "",
  "paintConfessions body is readable")
assert_eq(paintConfessionsFn:find("SetAlpha", 1, true), nil,
  "paintConfessions does not dim confession rows")
local paintKnightingFn = srcAlphaBody:match(
  "local function paintKnightingLine%(frame, rows%)(.-)\nlocal function paintRecommendation")
assert_true(type(paintKnightingFn) == "string" and paintKnightingFn ~= "",
  "paintKnightingLine body is readable")
assert_eq(paintKnightingFn:find("SetAlpha", 1, true), nil,
  "paintKnightingLine does not dim knighting rows")
local presenceLineFn = srcAlphaBody:match(
  "local function presenceLine%(row%)(.-)\nlocal function h2hScore")
assert_true(type(presenceLineFn) == "string" and presenceLineFn ~= "",
  "presenceLine body is readable")
assert_eq(presenceLineFn:find("offline", 1, true), nil,
  "presenceLine does not add offline")
assert_eq(presenceLineFn:find("away", 1, true), nil,
  "presenceLine does not add away")
assert_eq(presenceLineFn:find("here", 1, true), nil,
  "presenceLine still ignores the here flag for copy")
assert_true(srcAlphaBody:find("here = true", 1, true) ~= nil,
  "GetPresence roster rows stay here true")
assert_true(srcAlphaBody:find("here = false", 1, true) ~= nil,
  "GetPresence Store-only rows stay here false")
assert_eq(srcAlphaBody:find("UnitIsDead", 1, true), nil, "source must not scrape UnitIsDead")
assert_eq(srcAlphaBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcAlphaBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcAlphaBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcAlphaBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local function pinAlpha(btn)
  if type(btn) ~= "table" then return end
  btn._alpha = 1
  btn.SetAlpha = function(self, a)
    self._alpha = a
  end
  btn.GetAlpha = function(self)
    return self._alpha
  end
end
local function pinPool(pool)
  if type(pool) ~= "table" then return end
  for i = 1, #pool do
    pinAlpha(pool[i])
  end
end
pinPool(frame.PresenceRows)
pinPool(frame.PetitionRows)
pinPool(frame.ConfessionRows)
pinPool(frame.KnightingRows)
local savedCreate = CreateFrame
CreateFrame = function(frameType, name, parent, template)
  local w = savedCreate(frameType, name, parent, template)
  if frameType == "Button" then
    pinAlpha(w)
  end
  return w
end
local function stubAlpha(btn)
  if type(btn) ~= "table" then return nil end
  if type(btn.GetAlpha) == "function" then
    local a = btn:GetAlpha()
    if a ~= nil then return a end
  end
  return btn._alpha
end
local function almost(a, want, msg)
  assert_true(type(a) == "number" and math.abs(a - want) < 0.001, msg)
end

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local human, localChar = seedLinked("Beefina", "Steve", 1)
local otherHuman, otherChar = seedLinked("Chuckroast", "Chuck", 3)
assert_eq(human.id ~= nil, true, "local human fixture exists")
assert_eq(otherHuman.id ~= nil, true, "Store human fixture exists")
assert_true(Console:StartEvent() ~= nil, "StartEvent for a live petition")
assert_true(Gora:Petition(localChar.id) ~= nil, "roster member petition lands")
COB.Roster = {
  ready = true,
  complete = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local presenceOpen = Console:GetPresence()
assert_eq(#presenceOpen, 2, "fail-open membership still lists member and Store-only")
assert_eq(presenceOpen[1] and presenceOpen[1].name, "Beefina", "seed member stays first")
assert_eq(presenceOpen[1] and presenceOpen[1].here, true, "roster member stays here")
assert_eq(presenceOpen[1] and presenceOpen[1].characterId, localChar.id, "seed member keeps characterId")
assert_eq(presenceOpen[2] and presenceOpen[2].name, "Chuckroast", "Store-only character is still listed")
assert_eq(presenceOpen[2] and presenceOpen[2].here, false, "Store-only stays not here")
assert_eq(presenceOpen[2] and presenceOpen[2].characterId, otherChar.id, "Chuckroast keeps characterId")
Console:Refresh()

local hereBtn
local storeBtn
local painted = rawget(frame, "PresenceRows")
assert_true(type(painted) == "table", "Presence rows painted")
for i = 1, #painted do
  local btn = painted[i]
  local row = btn and btn._row
  if row and row.characterId == localChar.id then
    hereBtn = btn
  elseif row and row.characterId == otherChar.id then
    storeBtn = btn
  end
end
assert_true(hereBtn ~= nil, "roster here == true row is painted")
assert_true(storeBtn ~= nil, "fail-open Store row is painted")
almost(stubAlpha(hereBtn), 1, "roster here == true stays alpha 1")
almost(stubAlpha(storeBtn), 0.45, "fail-open here == false SetAlpha ~0.45")
local storeLabel = storeBtn:GetText() or ""
assert_true(storeLabel:find("Chuckroast", 1, true) ~= nil, "Store-only label keeps the name")
assert_eq(storeLabel:find("offline", 1, true), nil, "Store-only label has no offline suffix")
assert_eq(storeLabel:find("away", 1, true), nil, "Store-only label has no away suffix")
assert_eq(storeLabel:find("not here", 1, true), nil, "Store-only label has no not-here suffix")

local petBtn = frame.PetitionRows and frame.PetitionRows[1]
assert_true(petBtn ~= nil, "petition row is painted")
almost(stubAlpha(petBtn), 1, "petition rows are not dimmed")

COB.Roster = nil
assert_eq(#Console:GetPresence(), 0, "missing Roster keeps empty Presence")
Console:Refresh()
assert_eq(hereBtn:IsShown(), false, "here leftover Presence button is hidden")
assert_eq(storeBtn:IsShown(), false, "Store leftover Presence button is hidden")
almost(stubAlpha(hereBtn), 1, "hidden here leftover resets alpha to 1")
almost(stubAlpha(storeBtn), 1, "hidden dim leftover resets alpha to 1")
local leftover = rawget(frame, "PresenceRows")
assert_true(type(leftover) == "table" and #leftover >= 2, "empty Presence keeps leftover buttons")
for i = 1, #leftover do
  local btn = leftover[i]
  assert_eq(btn:IsShown(), false, "leftover Presence button is hidden")
  almost(stubAlpha(btn), 1, "leftover hidden Presence button GetAlpha == 1")
end

COB.Roster = {
  ready = true,
  complete = false,
  members = {
    beefina = { name = "Beefina", guildRankIndex = 6 },
  },
}
local presenceAgain = Console:GetPresence()
assert_eq(#presenceAgain, 2, "re-paint fail-open still lists member and Store-only")
assert_eq(presenceAgain[1] and presenceAgain[1].here, true, "re-paint roster member stays here")
assert_eq(presenceAgain[2] and presenceAgain[2].here, false, "re-paint Store-only stays not here")
Console:Refresh()
assert_eq(hereBtn:IsShown(), true, "re-paint here row is visible")
assert_eq(storeBtn:IsShown(), true, "re-paint Store row is visible")
almost(stubAlpha(hereBtn), 1, "re-paint visible here stays 1")
almost(stubAlpha(storeBtn), 0.45, "re-paint visible Store stays ~0.45")
local petAgain = frame.PetitionRows and frame.PetitionRows[1]
assert_true(petAgain ~= nil, "petition row is painted after re-paint")
almost(stubAlpha(petAgain), 1, "petition rows stay undimmed after re-paint")

CreateFrame = savedCreate
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B34-B wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B34-B")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B34-B")
end
runB34B()

--------------------------------------------------------------------------------
-- B36-B: successful EndEvent nils selectedHumanId / selectedCharacterId
-- before after(). Fighter-pair clear stays. Successful StartEvent after
-- a Quiet pick keeps human / character. Refresh does not nil selection.
-- Failed End / Continue keep. Leftover CallForward / Dismiss /
-- KnightThisBeef without an explicit id refuse or no-op.
-- SaveNote nil. No SUMMON. Nested inside runB8E after runB34B().
--------------------------------------------------------------------------------
local function runB36B()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local srcEnd = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcEnd ~= nil, "Console.lua is readable for B36-B")
local srcEndBody = srcEnd:read("*a")
srcEnd:close()
local startFn = srcEndBody:match("function Console:StartEvent%(%)(.-)\nfunction Console:OpenRite")
assert_true(type(startFn) == "string" and startFn ~= "",
  "StartEvent body is readable")
assert_eq(startFn:find("selectedHumanId", 1, true), nil,
  "StartEvent does not nil selectedHumanId")
assert_eq(startFn:find("selectedCharacterId", 1, true), nil,
  "StartEvent does not nil selectedCharacterId")
assert_true(startFn:find("self.selectedFighterA = nil", 1, true) ~= nil,
  "StartEvent still nils selected fighter A")
assert_true(startFn:find("self.selectedFighterB = nil", 1, true) ~= nil,
  "StartEvent still nils selected fighter B")
local endFn = srcEndBody:match("function Console:EndEvent%(%)(.-)\nfunction Console:KnightThisBeef")
assert_true(type(endFn) == "string" and endFn ~= "",
  "EndEvent body is readable")
assert_true(endFn:find("self.selectedHumanId = nil", 1, true) ~= nil,
  "EndEvent nils selectedHumanId")
assert_true(endFn:find("self.selectedCharacterId = nil", 1, true) ~= nil,
  "EndEvent nils selectedCharacterId")
assert_true(endFn:find("self.selectedFighterA = nil", 1, true) ~= nil,
  "EndEvent still nils selected fighter A")
assert_true(endFn:find("self.selectedFighterB = nil", 1, true) ~= nil,
  "EndEvent still nils selected fighter B")
assert_true(srcEndBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "successful EndEvent nils lastRecommendation, the selected pair, and human / character before after")
assert_true(srcEndBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "successful StartEvent still nils only lastRecommendation and the selected pair")
assert_true(srcEndBody:find("local result, err = COB.Runtime:Continue()\n  return after(self, result, err)", 1, true) ~= nil,
  "Continue does not clear selection")
local refreshFn = srcEndBody:match("function Console:Refresh%(%)(.-)\nfunction Console:Show")
assert_true(type(refreshFn) == "string" and refreshFn ~= "",
  "Refresh body is readable")
assert_eq(refreshFn:find("selectedHumanId", 1, true), nil,
  "Refresh does not nil selectedHumanId")
assert_eq(refreshFn:find("selectedCharacterId", 1, true), nil,
  "Refresh does not nil selectedCharacterId")
assert_eq(refreshFn:find("selectedFighterA", 1, true), nil,
  "Refresh still does not nil selectedFighterA")
assert_eq(refreshFn:find("selectedFighterB", 1, true), nil,
  "Refresh still does not nil selectedFighterB")
assert_eq(srcEndBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcEndBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcEndBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcEndBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local human, ch = seedLinked("Beefina", "Steve", 1)
local otherHuman, otherChar = seedLinked("Chuckroast", "Chuck", 3)
assert_eq(human.id ~= nil, true, "Quiet-pick human fixture exists")
assert_eq(ch.id ~= nil, true, "Quiet-pick character fixture exists")
assert_eq(otherHuman.id ~= nil, true, "second human fixture exists")
assert_eq(otherChar.id ~= nil, true, "second character fixture exists")
assert_eq(Console:SelectHuman(human.id), true, "Quiet pick selects the human")
assert_eq(Console:SelectCharacter(ch.id), true, "Quiet pick selects the character")
assert_eq(Console.selectedHumanId, human.id, "Quiet pick stores selectedHumanId")
assert_eq(Console.selectedCharacterId, ch.id, "Quiet pick stores selectedCharacterId")
Console:Refresh()
assert_eq(Console.selectedHumanId, human.id, "Refresh does not nil selectedHumanId")
assert_eq(Console.selectedCharacterId, ch.id, "Refresh does not nil selectedCharacterId")

local started = Console:StartEvent()
assert_true(started ~= nil, "StartEvent after a Quiet pick")
assert_eq(Console.selectedHumanId, human.id, "StartEvent after Quiet pick keeps human")
assert_eq(Console.selectedCharacterId, ch.id, "StartEvent after Quiet pick keeps character")
assert_true(Console:OpenRite("Knighting") ~= nil, "OpenRite Knighting still uses the Quiet pick")
local failEnd = Console:EndEvent()
assert_eq(failEnd, nil, "EndEvent refuses from RITE")
assert_eq(Console.selectedHumanId, human.id, "failed EndEvent keeps selectedHumanId")
assert_eq(Console.selectedCharacterId, ch.id, "failed EndEvent keeps selectedCharacterId")
assert_true(Console:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
assert_true(Console:Continue() ~= nil, "Continue returns to ASSEMBLY")
assert_eq(Console.selectedHumanId, human.id, "Continue keeps selectedHumanId")
assert_eq(Console.selectedCharacterId, ch.id, "Continue keeps selectedCharacterId")
assert_eq(Console:SelectFighters(ch.id, otherChar.id), true, "selected pair is set before End")
assert_eq(Console.selectedFighterA, ch.id, "selected fighter A is set")
assert_eq(Console.selectedFighterB, otherChar.id, "selected fighter B is set")
assert_true(Gora:Petition(ch.id) ~= nil, "petition lands on the leftover character")

local ended = Console:EndEvent()
assert_true(ended ~= nil, "EndEvent returns to QUIET")
assert_eq(Console.selectedHumanId, nil, "successful EndEvent nils selectedHumanId")
assert_eq(Console.selectedCharacterId, nil, "successful EndEvent nils selectedCharacterId")
assert_eq(Console.selectedFighterA, nil, "successful EndEvent still nils selected A")
assert_eq(Console.selectedFighterB, nil, "successful EndEvent still nils selected B")

assert_eq(COB.Confession, nil, "isolation Confession is nil after End")
local called, callErr = Console:CallForward()
assert_eq(called, nil, "CallForward without id refuses when Confession is nil")
assert_eq(callErr, "confession is not available", "CallForward refuse is not a leftover fire")

local callCount = 0
local callId
COB.Confession = {
  CallForward = function(_, characterId)
    callCount = callCount + 1
    callId = characterId
    if type(characterId) ~= "number" then return false end
    return true
  end,
}
local stubCalled = Console:CallForward()
assert_eq(stubCalled, false, "CallForward without id no-ops after End")
assert_eq(callCount, 1, "CallForward still reaches Confession with the resolved id")
assert_eq(callId, nil, "CallForward is not called with leftover character")
COB.Confession = nil

local dismissId
local realDismiss = Gora.Dismiss
Gora.Dismiss = function(self, id)
  dismissId = id
  return realDismiss(self, id)
end
local dismissed = Console:Dismiss()
Gora.Dismiss = realDismiss
assert_eq(dismissed, false, "Dismiss without id no-ops after End")
assert_eq(dismissId, nil, "Dismiss is not called with leftover character")

local before = Store:GetHuman(human.id)
assert_eq(before.rankId, 1, "leftover human is still Fresh Beef")
local knightId
local realKnight = Knighting.KnightThisBeef
Knighting.KnightThisBeef = function(self, hid, now)
  knightId = hid
  return realKnight(self, hid, now)
end
local knighted = Console:KnightThisBeef()
Knighting.KnightThisBeef = realKnight
assert_eq(knighted, nil, "KnightThisBeef without id refuses after End")
assert_eq(knightId, nil, "KnightThisBeef is not called with leftover human")
local afterHuman = Store:GetHuman(human.id)
assert_eq(afterHuman.rankId, 1, "leftover KnightThisBeef does not knight")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B36-B wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B36-B")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B36-B")
end
runB36B()

--------------------------------------------------------------------------------
-- B37-A: successful Dismiss nils selectedCharacterId before Refresh.
-- Confession-only success also nils. Failed Dismiss keeps. Does not
-- nil selectedHumanId. End / Start / Refresh keeps stay. Leftover
-- CallForward / DeclareVictor without an explicit id do not fire on
-- the leftover. SaveNote nil. No SUMMON. Nested inside runB8E after
-- runB36B().
--------------------------------------------------------------------------------
local function runB37A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_eq(type(Console.Dismiss), "function", "Dismiss stays a console verb")
assert_eq(type(Console.CallForward), "function", "CallForward pins stay")
assert_eq(type(Console.DeclareVictor), "function", "DeclareVictor pins stay")

local srcPick = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcPick ~= nil, "Console.lua is readable for B37-A")
local srcPickBody = srcPick:read("*a")
srcPick:close()
local dismissFn = srcPickBody:match("function Console:Dismiss%(characterId%)(.-)\nfunction Console:DeclareVictor")
assert_true(type(dismissFn) == "string" and dismissFn ~= "",
  "Dismiss body is readable")
assert_true(dismissFn:find("local id = characterId or self.selectedCharacterId", 1, true) ~= nil,
  "Dismiss still resolves one id from the pick")
assert_true(dismissFn:find("if ok then\n    self.selectedCharacterId = nil\n    if isId(id) and (id == self.selectedFighterA or id == self.selectedFighterB) then\n      lastRecommendation = nil\n      self.selectedFighterA = nil\n      self.selectedFighterB = nil\n    end\n    self:Refresh()\n  end", 1, true) ~= nil,
  "successful Dismiss nils selectedCharacterId before Refresh")
assert_eq(dismissFn:find("selectedHumanId = nil", 1, true), nil,
  "Dismiss does not nil selectedHumanId")
assert_eq(dismissFn:find("after(", 1, true), nil, "Dismiss does not fan-out through after()")
local startFn = srcPickBody:match("function Console:StartEvent%(%)(.-)\nfunction Console:OpenRite")
assert_true(type(startFn) == "string" and startFn ~= "",
  "StartEvent body is readable")
assert_eq(startFn:find("selectedCharacterId", 1, true), nil,
  "StartEvent keep stays — does not nil selectedCharacterId")
assert_eq(startFn:find("selectedHumanId", 1, true), nil,
  "StartEvent keep stays — does not nil selectedHumanId")
local endFn = srcPickBody:match("function Console:EndEvent%(%)(.-)\nfunction Console:KnightThisBeef")
assert_true(type(endFn) == "string" and endFn ~= "",
  "EndEvent body is readable")
assert_true(endFn:find("self.selectedCharacterId = nil", 1, true) ~= nil,
  "EndEvent keep stays — still nils selectedCharacterId")
assert_true(endFn:find("self.selectedHumanId = nil", 1, true) ~= nil,
  "EndEvent keep stays — still nils selectedHumanId")
assert_true(srcPickBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "EndEvent keep stays — success still nils the pick before after")
assert_true(srcPickBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "StartEvent keep stays — still nils only lastRecommendation and the pair")
local refreshFn = srcPickBody:match("function Console:Refresh%(%)(.-)\nfunction Console:Show")
assert_true(type(refreshFn) == "string" and refreshFn ~= "",
  "Refresh body is readable")
assert_eq(refreshFn:find("selectedCharacterId", 1, true), nil,
  "Refresh keep stays — does not nil selectedCharacterId")
assert_eq(refreshFn:find("selectedHumanId", 1, true), nil,
  "Refresh keep stays — does not nil selectedHumanId")
assert_eq(srcPickBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcPickBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcPickBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcPickBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local human, ch = seedLinked("Beefina", "Steve", 1)
assert_eq(human.id ~= nil, true, "pick human fixture exists")
assert_eq(ch.id ~= nil, true, "pick character fixture exists")
assert_eq(Console:SelectHuman(human.id), true, "selects the human")
assert_eq(Console:SelectCharacter(ch.id), true, "selects the character")
assert_eq(Console.selectedHumanId, human.id, "stores selectedHumanId")
assert_eq(Console.selectedCharacterId, ch.id, "stores selectedCharacterId")
Console:Refresh()
assert_eq(Console.selectedHumanId, human.id, "Refresh keep stays — human")
assert_eq(Console.selectedCharacterId, ch.id, "Refresh keep stays — character")

local started = Console:StartEvent()
assert_true(started ~= nil, "StartEvent after a pick")
assert_eq(Console.selectedHumanId, human.id, "StartEvent keep stays — human")
assert_eq(Console.selectedCharacterId, ch.id, "StartEvent keep stays — character")

local failDismiss = Console:Dismiss()
assert_eq(failDismiss, false, "Dismiss without a petition fails")
assert_eq(Console.selectedCharacterId, ch.id, "failed Dismiss keeps selectedCharacterId")
assert_eq(Console.selectedHumanId, human.id, "failed Dismiss keeps selectedHumanId")

assert_true(Gora:Petition(ch.id) ~= nil, "petition lands on the selected character")
local dismissed = Console:Dismiss()
assert_eq(dismissed, true, "successful Dismiss returns true")
assert_eq(Console.selectedCharacterId, nil, "successful Dismiss nils selectedCharacterId")
assert_eq(Console.selectedHumanId, human.id, "successful Dismiss does not nil selectedHumanId")

assert_eq(COB.Confession, nil, "isolation Confession is nil after Dismiss")
local called, callErr = Console:CallForward()
assert_eq(called, nil, "CallForward without id refuses when Confession is nil")
assert_eq(callErr, "confession is not available", "CallForward refuse is not a leftover fire")

local callCount = 0
local callId
COB.Confession = {
  CallForward = function(_, characterId)
    callCount = callCount + 1
    callId = characterId
    if type(characterId) ~= "number" then return false end
    return true
  end,
}
local stubCalled = Console:CallForward()
assert_eq(stubCalled, false, "CallForward without id no-ops after Dismiss")
assert_eq(callCount, 1, "CallForward still reaches Confession with the resolved id")
assert_eq(callId, nil, "CallForward is not called with leftover character")
COB.Confession = nil

local victorId
local realVictor = Gora.DeclareVictor
Gora.DeclareVictor = function(self, id)
  victorId = id
  return realVictor(self, id)
end
local declared = Console:DeclareVictor()
Gora.DeclareVictor = realVictor
assert_eq(declared, nil, "DeclareVictor without id refuses after Dismiss")
assert_eq(victorId, nil, "DeclareVictor is not called with leftover character")

assert_eq(Console:SelectCharacter(ch.id), true, "re-selects the character for Confession-only")
assert_eq(Console.selectedCharacterId, ch.id, "re-select stores selectedCharacterId")
assert_eq(Console.selectedHumanId, human.id, "re-select keeps selectedHumanId")
COB.Confession = {
  Dismiss = function(_, characterId)
    return type(characterId) == "number"
  end,
}
local confessionOnly = Console:Dismiss()
assert_eq(confessionOnly, true, "Confession-only Dismiss succeeds")
assert_eq(Console.selectedCharacterId, nil, "Confession-only success nils selectedCharacterId")
assert_eq(Console.selectedHumanId, human.id, "Confession-only success does not nil selectedHumanId")
COB.Confession = nil

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B37-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B37-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B37-A")
end
runB37A()

--------------------------------------------------------------------------------
-- B38-A: successful Dismiss of a pair member nils the pair and
-- lastRecommendation before Refresh. Dismiss of a third id keeps
-- the pair. Failed Dismiss keeps. B37-A selectedCharacterId nil
-- stays. Does not nil selectedHumanId. Leftover FlagFamousUpset /
-- Sanction without explicit ids do not fire on leftover A.
-- SaveNote nil. No SUMMON. Nested inside runB8E after runB37A().
--------------------------------------------------------------------------------
local function runB38A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_eq(type(Console.Dismiss), "function", "Dismiss stays a console verb")
assert_eq(type(Console.FlagFamousUpset), "function", "FlagFamousUpset pins stay")
assert_eq(type(Console.Sanction), "function", "Sanction pins stay")
assert_eq(type(Console.Recommend), "function", "Recommend pins stay")

local srcPair = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcPair ~= nil, "Console.lua is readable for B38-A")
local srcPairBody = srcPair:read("*a")
srcPair:close()
local dismissFn = srcPairBody:match("function Console:Dismiss%(characterId%)(.-)\nfunction Console:DeclareVictor")
assert_true(type(dismissFn) == "string" and dismissFn ~= "",
  "Dismiss body is readable")
assert_true(dismissFn:find("local id = characterId or self.selectedCharacterId", 1, true) ~= nil,
  "Dismiss still resolves one id from the pick")
assert_true(dismissFn:find("if ok then\n    self.selectedCharacterId = nil\n    if isId(id) and (id == self.selectedFighterA or id == self.selectedFighterB) then\n      lastRecommendation = nil\n      self.selectedFighterA = nil\n      self.selectedFighterB = nil\n    end\n    self:Refresh()\n  end", 1, true) ~= nil,
  "successful Dismiss nils selectedCharacterId, and the pair when the dismissed id is in it, before Refresh")
assert_eq(dismissFn:find("selectedHumanId = nil", 1, true), nil,
  "Dismiss does not nil selectedHumanId")
assert_eq(dismissFn:find("after(", 1, true), nil, "Dismiss does not fan-out through after()")
local startFn = srcPairBody:match("function Console:StartEvent%(%)(.-)\nfunction Console:OpenRite")
assert_true(type(startFn) == "string" and startFn ~= "",
  "StartEvent body is readable")
assert_eq(startFn:find("selectedCharacterId", 1, true), nil,
  "StartEvent keep stays — does not nil selectedCharacterId")
assert_eq(startFn:find("selectedHumanId", 1, true), nil,
  "StartEvent keep stays — does not nil selectedHumanId")
local endFn = srcPairBody:match("function Console:EndEvent%(%)(.-)\nfunction Console:KnightThisBeef")
assert_true(type(endFn) == "string" and endFn ~= "",
  "EndEvent body is readable")
assert_true(endFn:find("self.selectedCharacterId = nil", 1, true) ~= nil,
  "EndEvent keep stays — still nils selectedCharacterId")
assert_true(endFn:find("self.selectedHumanId = nil", 1, true) ~= nil,
  "EndEvent keep stays — still nils selectedHumanId")
assert_true(srcPairBody:find("local result, err = COB.Runtime:EndEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n    self.selectedHumanId = nil\n    self.selectedCharacterId = nil\n  end\n  return after(self, result, err, nil, true)", 1, true) ~= nil,
  "EndEvent keep stays — success still nils the pick before after")
assert_true(srcPairBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "StartEvent keep stays — still nils only lastRecommendation and the pair")
local refreshFn = srcPairBody:match("function Console:Refresh%(%)(.-)\nfunction Console:Show")
assert_true(type(refreshFn) == "string" and refreshFn ~= "",
  "Refresh body is readable")
assert_eq(refreshFn:find("selectedCharacterId", 1, true), nil,
  "Refresh keep stays — does not nil selectedCharacterId")
assert_eq(refreshFn:find("selectedHumanId", 1, true), nil,
  "Refresh keep stays — does not nil selectedHumanId")
assert_eq(refreshFn:find("selectedFighterA", 1, true), nil,
  "Refresh keep stays — does not nil selectedFighterA")
assert_eq(srcPairBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcPairBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcPairBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcPairBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local human, chA = seedLinked("Chuckroast", "Steve", 1)
local chB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
local chC = Store:CreateCharacter({ name = "Brisket", class = "Rogue", level = 70 })
local chD = Store:CreateCharacter({ name = "Shortloin", class = "Priest", level = 69 })
assert_eq(human.id ~= nil, true, "pair human fixture exists")
assert_eq(chA.id ~= nil, true, "pair fighter A exists")
assert_eq(chB.id ~= nil, true, "pair fighter B exists")
assert_eq(chC.id ~= nil, true, "third id exists")
assert_true(Console:StartEvent() ~= nil, "StartEvent for a live petition pool")
assert_true(Gora:Petition(chA.id) ~= nil, "petition A lands")
assert_true(Gora:Petition(chB.id) ~= nil, "petition B lands")
assert_true(Gora:Petition(chC.id) ~= nil, "petition C lands")
assert_eq(Console:SelectHuman(human.id), true, "selects the human")
assert_eq(Console:SelectCharacter(chA.id), true, "selects fighter A as the character pick")
assert_eq(Console:SelectFighters(chA.id, chB.id), true, "selects pair A/B")
assert_eq(Console.selectedHumanId, human.id, "stores selectedHumanId")
assert_eq(Console.selectedCharacterId, chA.id, "stores selectedCharacterId")
assert_eq(Console.selectedFighterA, chA.id, "stores selectedFighterA")
assert_eq(Console.selectedFighterB, chB.id, "stores selectedFighterB")
local recPair = Console:Recommend()
assert_true(recPair ~= nil, "Recommend stores the selected pair")
local recText = frame.Recommendation:GetText() or ""
assert_true(recText:find("Chuckroast", 1, true) ~= nil, "Recommend paints fighter A")
assert_true(recText:find("Tendermage", 1, true) ~= nil, "Recommend paints fighter B")

local failDismiss = Console:Dismiss(chD.id)
assert_eq(failDismiss, false, "Dismiss of an unpetitioned id fails")
assert_eq(Console.selectedFighterA, chA.id, "failed Dismiss keeps selected A")
assert_eq(Console.selectedFighterB, chB.id, "failed Dismiss keeps selected B")
assert_eq(Console.selectedCharacterId, chA.id, "failed Dismiss keeps selectedCharacterId")
assert_eq(Console.selectedHumanId, human.id, "failed Dismiss keeps selectedHumanId")
assert_eq(frame.Recommendation:GetText() or "", recText,
  "failed Dismiss keeps Recommendation")

local thirdOk = Console:Dismiss(chC.id)
assert_eq(thirdOk, true, "Dismiss of a third id succeeds")
assert_eq(Console.selectedFighterA, chA.id, "third-id Dismiss keeps selected A")
assert_eq(Console.selectedFighterB, chB.id, "third-id Dismiss keeps selected B")
assert_eq(Console.selectedCharacterId, nil, "B37-A stays — successful Dismiss nils selectedCharacterId")
assert_eq(Console.selectedHumanId, human.id, "third-id Dismiss does not nil selectedHumanId")
assert_eq(frame.Recommendation:GetText() or "", recText,
  "third-id Dismiss keeps Recommendation")

assert_eq(Console:SelectCharacter(chA.id), true, "re-selects fighter A before Dismiss A")
assert_eq(Console.selectedCharacterId, chA.id, "re-select stores selectedCharacterId")
local dismissedA = Console:Dismiss(chA.id)
assert_eq(dismissedA, true, "Dismiss A succeeds")
assert_eq(Console.selectedFighterA, nil, "Dismiss A nils selected A")
assert_eq(Console.selectedFighterB, nil, "Dismiss A nils selected B")
assert_eq(Console.selectedCharacterId, nil, "B37-A stays — Dismiss A nils selectedCharacterId")
assert_eq(Console.selectedHumanId, human.id, "Dismiss A does not nil selectedHumanId")
assert_eq(frame.Recommendation:GetText() or "", "",
  "Dismiss A nils Recommendation")
local bout = Console:GetProposedBout()
assert_eq(bout.fighterA, nil, "Dismiss A clears proposed A")
assert_eq(bout.fighterB, nil, "Dismiss A clears proposed B")

local upsetId
local upsetOpp
local savedUpset = Store.FlagFamousUpset
Store.FlagFamousUpset = function(self, characterId, opponentId)
  upsetId = characterId
  upsetOpp = opponentId
  return savedUpset(self, characterId, opponentId)
end
local upsetOk, upsetErr = Console:FlagFamousUpset()
Store.FlagFamousUpset = savedUpset
assert_eq(upsetOk, nil, "FlagFamousUpset without ids refuses after Dismiss A")
assert_eq(upsetId, nil, "FlagFamousUpset is not called with leftover A")
assert_eq(upsetOpp, nil, "FlagFamousUpset is not called with leftover B")
assert_true(upsetErr == "invalid character id" or upsetId ~= chA.id,
  "FlagFamousUpset leftover refuse is not a leftover fire")

local sanctionA
local sanctionB
local realSanction = Gora.Sanction
Gora.Sanction = function(self, fighterA, fighterB, stipulation)
  sanctionA = fighterA
  sanctionB = fighterB
  return realSanction(self, fighterA, fighterB, stipulation)
end
local sanctioned, sanctionErr = Console:Sanction()
Gora.Sanction = realSanction
assert_eq(sanctioned, nil, "Sanction without ids refuses after Dismiss A")
assert_eq(sanctionA, nil, "Sanction is not called with leftover A")
assert_eq(sanctionB, nil, "Sanction is not called with leftover B")
assert_eq(sanctionErr, "a Gora needs two different combatants",
  "Sanction leftover refuse is not a leftover fire")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B38-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B38-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B38-A")
end
runB38A()

--------------------------------------------------------------------------------
-- B39-A: OpenRite Gora does not fall back to GetLastSanctioned.
-- Live GetSanctioned fallback stays. Selected pair still wins.
-- Sanction A/B, rule, Continue; OpenRite without a desk pair does
-- not put leftover last fighters on Runtime subjects.
-- Knighting OpenRite unchanged. End / Start / Dismiss keeps stay.
-- SaveNote nil. No SUMMON. Nested inside runB8E after runB38A().
--------------------------------------------------------------------------------
local function runB39A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")
assert_eq(type(Console.OpenRite), "function", "OpenRite stays a console verb")
assert_eq(type(Console.Continue), "function", "Continue stays a console verb")
assert_eq(type(Console.Dismiss), "function", "Dismiss keep stays")

local srcOpen = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcOpen ~= nil, "Console.lua is readable for B39-A")
local srcOpenBody = srcOpen:read("*a")
srcOpen:close()
local openFn = srcOpenBody:match("function Console:OpenRite%(kind%)(.-)\nfunction Console:CloseRite")
assert_true(type(openFn) == "string" and openFn ~= "",
  "OpenRite body is readable")
assert_true(openFn:find("selectedFighterA", 1, true) ~= nil,
  "selected fighter A still wins")
assert_true(openFn:find("selectedFighterB", 1, true) ~= nil,
  "selected fighter B still wins")
assert_true(openFn:find("GetSanctioned", 1, true) ~= nil,
  "live GetSanctioned fallback stays")
assert_eq(openFn:find("GetLastSanctioned", 1, true), nil,
  "OpenRite Gora does not fall back to GetLastSanctioned")
assert_true(openFn:find('kind == "Knighting"', 1, true) ~= nil,
  "Knighting OpenRite stays")
assert_true(openFn:find("GetLine", 1, true) ~= nil,
  "Knighting OpenRite still falls back to GetLine")
assert_true(openFn:find("selectedHumanId", 1, true) ~= nil,
  "Knighting OpenRite still prefers selectedHumanId")
assert_eq(srcOpenBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcOpenBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcOpenBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcOpenBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")
local startFn = srcOpenBody:match("function Console:StartEvent%(%)(.-)\nfunction Console:OpenRite")
assert_true(type(startFn) == "string" and startFn ~= "",
  "StartEvent body is readable")
assert_eq(startFn:find("selectedCharacterId", 1, true), nil,
  "StartEvent keep stays — does not nil selectedCharacterId")
assert_eq(startFn:find("selectedHumanId", 1, true), nil,
  "StartEvent keep stays — does not nil selectedHumanId")
assert_true(srcOpenBody:find("local result, err = COB.Runtime:StartEvent()\n  if result ~= nil then\n    lastRecommendation = nil\n    self.selectedFighterA = nil\n    self.selectedFighterB = nil\n  end\n  return after(self, result, err)", 1, true) ~= nil,
  "StartEvent keep stays — still nils only lastRecommendation and the pair")
local endFn = srcOpenBody:match("function Console:EndEvent%(%)(.-)\nfunction Console:KnightThisBeef")
assert_true(type(endFn) == "string" and endFn ~= "",
  "EndEvent body is readable")
assert_true(endFn:find("self.selectedCharacterId = nil", 1, true) ~= nil,
  "EndEvent keep stays — still nils selectedCharacterId")
assert_true(endFn:find("self.selectedHumanId = nil", 1, true) ~= nil,
  "EndEvent keep stays — still nils selectedHumanId")
local dismissFn = srcOpenBody:match("function Console:Dismiss%(characterId%)(.-)\nfunction Console:DeclareVictor")
assert_true(type(dismissFn) == "string" and dismissFn ~= "",
  "Dismiss body is readable")
assert_true(dismissFn:find("if ok then\n    self.selectedCharacterId = nil\n    if isId(id) and (id == self.selectedFighterA or id == self.selectedFighterB) then\n      lastRecommendation = nil\n      self.selectedFighterA = nil\n      self.selectedFighterB = nil\n    end\n    self:Refresh()\n  end", 1, true) ~= nil,
  "Dismiss keep stays — successful Dismiss still nils the pair when the id is in it")
assert_eq(dismissFn:find("selectedHumanId = nil", 1, true), nil,
  "Dismiss keep stays — does not nil selectedHumanId")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end

reset()
Console:Init()
local liveA = Store:CreateCharacter({ name = "LiveA", class = "Warrior", level = 70 })
local liveB = Store:CreateCharacter({ name = "LiveB", class = "Mage", level = 68 })
assert_eq(Console.selectedFighterA, nil, "live fallback has no selected A")
assert_eq(Console.selectedFighterB, nil, "live fallback has no selected B")
assert_true(Console:StartEvent() ~= nil, "StartEvent for live sanctioned fallback")
assert_true(Console:Sanction(liveA.id, liveB.id) ~= nil, "Sanction live pair")
assert_eq(Gora:GetSanctioned().fighterA, liveA.id, "live pair is A")
assert_eq(Gora:GetSanctioned().fighterB, liveB.id, "live pair is B")
local openedLive = Console:OpenRite("Gora")
assert_true(openedLive ~= nil, "OpenRite Gora reaches Runtime from the live pair")
assert_eq(openedLive.state, "RITE", "OpenRite opens a typed rite")
assert_eq(openedLive.riteType, "Gora", "rite type is Gora")
local liveFighters = openedLive.subjects and openedLive.subjects.fighters
assert_eq(liveFighters and liveFighters[1], liveA.id, "Runtime subject A is the live pair")
assert_eq(liveFighters and liveFighters[2], liveB.id, "Runtime subject B is the live pair")

reset()
Console:Init()
local lastA = Store:CreateCharacter({ name = "LastA", class = "Warrior", level = 70 })
local lastB = Store:CreateCharacter({ name = "LastB", class = "Mage", level = 68 })
local selA = Store:CreateCharacter({ name = "SelA", class = "Rogue", level = 70 })
local selB = Store:CreateCharacter({ name = "SelB", class = "Priest", level = 69 })
assert_true(Console:StartEvent() ~= nil, "StartEvent for selected-wins")
assert_true(Console:Sanction(lastA.id, lastB.id) ~= nil, "Sanction last pair")
assert_true(Console:Void() ~= nil, "VOID clears the live pair")
assert_eq(Gora:GetSanctioned(), nil, "live pair is gone after VOID")
assert_eq(Gora:GetLastSanctioned().fighterA, lastA.id, "last pair is A")
assert_eq(Gora:GetLastSanctioned().fighterB, lastB.id, "last pair is B")
Console:SelectFighters(selA.id, selB.id)
assert_eq(Console.selectedFighterA, selA.id, "selected A is set")
assert_eq(Console.selectedFighterB, selB.id, "selected B is set")
local openedSel = Console:OpenRite("Gora")
assert_true(openedSel ~= nil, "OpenRite Gora reaches Runtime from the selected pair")
local selFighters = openedSel and openedSel.subjects and openedSel.subjects.fighters
assert_eq(selFighters and selFighters[1], selA.id, "selected pair still wins")
assert_eq(selFighters and selFighters[2], selB.id, "selected pair B still wins")
assert_eq(selFighters and selFighters[1] == lastA.id, false, "last pair A does not win")
assert_eq(selFighters and selFighters[2] == lastB.id, false, "last pair B does not win")

reset()
Console:Init()
local boutA = Store:CreateCharacter({ name = "BoutA", class = "Warrior", level = 70 })
local boutB = Store:CreateCharacter({ name = "BoutB", class = "Mage", level = 68 })
assert_eq(Console.selectedFighterA, nil, "leftover sequence has no selected A")
assert_eq(Console.selectedFighterB, nil, "leftover sequence has no selected B")
assert_true(Console:StartEvent() ~= nil, "StartEvent for leftover last pair")
assert_true(Console:Sanction(boutA.id, boutB.id) ~= nil, "Sanction leftover pair")
assert_true(Console:OpenRite("Gora") ~= nil, "OpenRite Gora from the live pair")
assert_true(Console:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
assert_true(Console:Void() ~= nil, "rule clears the live pair")
assert_true(Console:Continue() ~= nil, "Continue returns to ASSEMBLY")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "machine is ASSEMBLY after Continue")
assert_eq(Gora:GetSanctioned(), nil, "no live pair after the ruling")
assert_eq(Gora:GetLastSanctioned().fighterA, boutA.id, "last pair leftover is A")
assert_eq(Gora:GetLastSanctioned().fighterB, boutB.id, "last pair leftover is B")
assert_eq(Console.selectedFighterA, nil, "desk pair stays empty after Continue")
assert_eq(Console.selectedFighterB, nil, "desk pair B stays empty after Continue")
local leftoverA
local leftoverB
local leftoverKind
local realOpen = Runtime.OpenRite
Runtime.OpenRite = function(self, kind, subjects)
  leftoverKind = kind
  leftoverA = subjects and subjects.fighters and subjects.fighters[1]
  leftoverB = subjects and subjects.fighters and subjects.fighters[2]
  return realOpen(self, kind, subjects)
end
local openedAgain = Console:OpenRite("Gora")
Runtime.OpenRite = realOpen
assert_true(openedAgain ~= nil, "OpenRite Gora still opens after Continue")
assert_eq(leftoverKind, "Gora", "second OpenRite is Gora")
assert_eq(leftoverA, nil, "OpenRite does not pass leftover last A")
assert_eq(leftoverB, nil, "OpenRite does not pass leftover last B")
local againFighters = openedAgain and openedAgain.subjects and openedAgain.subjects.fighters
assert_eq(againFighters, nil, "Runtime subjects have no leftover last fighters")
assert_eq((againFighters and againFighters[1]) == boutA.id, false,
  "leftover last A is not a Runtime subject")
assert_eq((againFighters and againFighters[2]) == boutB.id, false,
  "leftover last B is not a Runtime subject")

reset()
Console:Init()
local lineHead = seedHuman("LineHead39", 1)
assert_eq(Console.selectedHumanId, nil, "no selected human")
assert_true(Console:StartEvent() ~= nil, "StartEvent for Knighting keep")
assert_true(Console:Enqueue(lineHead.id) ~= nil, "Enqueue reaches Knighting")
local openedLine = Console:OpenRite("Knighting")
assert_true(openedLine ~= nil, "OpenRite Knighting still reaches Runtime from the line head")
assert_eq(openedLine.subjects and openedLine.subjects.candidate, lineHead.id,
  "Knighting OpenRite still uses the line head")

Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B39-A wrapping the predicate does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B39-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B39-A")
end
runB39A()

--------------------------------------------------------------------------------
-- B40-A: Hide remounts a missing OnHide when the frame already
-- exists. Extract wireConsoleOnHide (never replace). Existing-frame
-- Hide: remount OnHide, then rememberSpecial(FRAME_NAME), then
-- frame:Hide(). OnHide remounts rememberSpecial so ESC still
-- re-lists. Wipe list, nil OnHide, Show, Hide: OnHide restored,
-- ChurchOfBeefConsoleFrame re-listed once, no sound. Third Hide
-- does not replace OnHide. Do not reset selection / pair /
-- Recommend. Do not refuse empty OpenRite Gora. No OnShow re-wire.
-- No rebuild. SaveNote nil. No SUMMON. Nested inside runB8E after
-- runB39A().
--------------------------------------------------------------------------------
local function runB40A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

local srcOnHide = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcOnHide ~= nil, "Console.lua is readable for B40-A")
local srcOnHideBody = srcOnHide:read("*a")
srcOnHide:close()
assert_true(srcOnHideBody:find("local function wireConsoleOnHide", 1, true) ~= nil,
  "source extracts wireConsoleOnHide")
local wireConsole = srcOnHideBody:match("local function wireConsoleOnHide%(widget%)(.-)\nlocal function buildFrame")
assert_true(type(wireConsole) == "string" and wireConsole ~= "",
  "wireConsoleOnHide body is readable")
assert_true(wireConsole:find("GetScript", 1, true) ~= nil,
  "wireConsoleOnHide checks GetScript")
assert_true(wireConsole:find("SetScript", 1, true) ~= nil,
  "wireConsoleOnHide holds SetScript")
assert_true(wireConsole:find("OnHide", 1, true) ~= nil,
  "wireConsoleOnHide wires OnHide")
assert_true(wireConsole:find("if existing then return", 1, true) ~= nil,
  "wireConsoleOnHide does not replace an existing OnHide")
assert_true(wireConsole:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "OnHide remounts rememberSpecial FRAME_NAME")
assert_eq(wireConsole:find("selectedFighterA", 1, true), nil,
  "wireConsoleOnHide does not reset selectedFighterA")
assert_eq(wireConsole:find("selectedFighterB", 1, true), nil,
  "wireConsoleOnHide does not reset selectedFighterB")
assert_eq(wireConsole:find("selectedHumanId", 1, true), nil,
  "wireConsoleOnHide does not reset selectedHumanId")
assert_eq(wireConsole:find("lastRecommendation", 1, true), nil,
  "wireConsoleOnHide does not reset Recommend")
assert_eq(wireConsole:find("OnShow", 1, true), nil,
  "wireConsoleOnHide does not wire OnShow")
assert_eq(wireConsole:find("PlaySound", 1, true), nil,
  "wireConsoleOnHide does not PlaySound")
assert_eq(wireConsole:find("IG_CHARACTER_INFO", 1, true), nil,
  "wireConsoleOnHide has no IG_CHARACTER_INFO")
assert_eq(wireConsole:find("CreateFrame", 1, true), nil,
  "wireConsoleOnHide does not rebuild")
assert_eq(wireConsole:find("buildFrame", 1, true), nil,
  "wireConsoleOnHide does not call buildFrame")

local hideFn = srcOnHideBody:match("function Console:Hide%(%)(.-)\nfunction Console:IsShown")
assert_true(type(hideFn) == "string" and hideFn ~= "",
  "Hide body is readable")
local wireAt = hideFn:find("wireConsoleOnHide", 1, true)
local remountAt = hideFn:find("rememberSpecial(FRAME_NAME)", 1, true)
local hideAt = hideFn:find("self.frame:Hide()", 1, true)
assert_true(wireAt ~= nil, "Hide remounts OnHide via wireConsoleOnHide")
assert_true(remountAt ~= nil, "Hide remount still rememberSpecial FRAME_NAME")
assert_true(hideAt ~= nil, "Hide still calls self.frame:Hide()")
assert_true(type(wireAt) == "number" and type(hideAt) == "number" and wireAt < hideAt,
  "Hide remounts OnHide before frame:Hide()")
assert_true(type(wireAt) == "number" and type(remountAt) == "number" and wireAt < remountAt,
  "Hide remounts OnHide before rememberSpecial")
assert_true(type(remountAt) == "number" and type(hideAt) == "number" and remountAt < hideAt,
  "Hide remounts rememberSpecial before frame:Hide()")
assert_eq(hideFn:find("SetScript", 1, true), nil,
  "Hide does not SetScript inline")
assert_eq(hideFn:find("OnShow", 1, true), nil,
  "Hide does not re-wire OnShow")
assert_eq(hideFn:find("selectedFighterA", 1, true), nil,
  "Hide does not reset selectedFighterA")
assert_eq(hideFn:find("selectedFighterB", 1, true), nil,
  "Hide does not reset selectedFighterB")
assert_eq(hideFn:find("selectedHumanId", 1, true), nil,
  "Hide does not reset selectedHumanId")
assert_eq(hideFn:find("lastRecommendation", 1, true), nil,
  "Hide does not reset Recommend")
assert_eq(hideFn:find("buildFrame", 1, true), nil,
  "Hide remount does not rebuild")
assert_eq(hideFn:find("CreateFrame", 1, true), nil,
  "Hide remount does not CreateFrame")
assert_eq(hideFn:find("PlaySound", 1, true), nil,
  "Hide remount does not PlaySound")
assert_eq(hideFn:find("IG_CHARACTER_INFO", 1, true), nil,
  "Hide remount has no IG_CHARACTER_INFO")
assert_eq(hideFn:find(":Show()", 1, true), nil,
  "Hide remount does not Show")
assert_eq(hideFn:find("self:Show", 1, true), nil,
  "Hide remount does not call Show")

local buildBody = srcOnHideBody:match("local function buildFrame%(%)(.-)\nlocal function onPresenceClick")
assert_true(type(buildBody) == "string" and buildBody ~= "",
  "buildFrame body is readable")
local hideInBuild = buildBody:find("frame:Hide()", 1, true)
local wireInBuild = buildBody:find("wireConsoleOnHide", 1, true)
assert_true(hideInBuild ~= nil, "create-path still has create-time Hide")
assert_true(wireInBuild ~= nil, "create-path uses wireConsoleOnHide")
assert_true(type(hideInBuild) == "number" and type(wireInBuild) == "number"
    and hideInBuild < wireInBuild,
  "create-path wires OnHide after create-time Hide")
assert_eq(buildBody:find('SetScript("OnHide"', 1, true), nil,
  "create-path does not SetScript OnHide inline")

local showFn = srcOnHideBody:match("function Console:Show%(%)(.-)\nfunction Console:Hide")
assert_true(type(showFn) == "string" and showFn ~= "",
  "Show body stays readable")
assert_eq(showFn:find("wireConsoleOnHide", 1, true), nil,
  "Show has no direct wireConsoleOnHide")
assert_eq(showFn:find("OnShow", 1, true), nil,
  "Show does not re-wire OnShow")
assert_true(showFn:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "B28-A Show rememberSpecial FRAME_NAME stays")

local refreshFn = srcOnHideBody:match("function Console:Refresh%(%)(.-)\nfunction Console:Show")
assert_true(type(refreshFn) == "string" and refreshFn ~= "",
  "Refresh body stays readable")
local refreshWireAt = refreshFn:find("wireConsoleOnHide", 1, true)
local refreshRemountAt = refreshFn:find("rememberSpecial(FRAME_NAME)", 1, true)
assert_true(refreshWireAt ~= nil, "Refresh remounts OnHide via wireConsoleOnHide")
assert_true(refreshRemountAt ~= nil, "B28-A Refresh rememberSpecial FRAME_NAME stays")
assert_true(type(refreshWireAt) == "number" and type(refreshRemountAt) == "number"
    and refreshWireAt < refreshRemountAt,
  "Refresh remounts OnHide before rememberSpecial")

local earlyInit = srcOnHideBody:match("function Console:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
assert_true(type(earlyInit) == "string" and earlyInit ~= "",
  "Init early-return body stays readable")
assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "B27-A early-return rememberSpecial FRAME_NAME stays")
assert_eq(earlyInit:find("wireConsoleOnHide", 1, true), nil,
  "Init remount does not remount OnHide")
assert_eq(earlyInit:find("buildFrame", 1, true), nil,
  "B27-A early-return still does not rebuild")

local openFn = srcOnHideBody:match("function Console:OpenRite%(kind%)(.-)\nfunction Console:CloseRite")
assert_true(type(openFn) == "string" and openFn ~= "",
  "OpenRite body stays readable")
assert_true(openFn:find("GetSanctioned", 1, true) ~= nil,
  "B39-A live GetSanctioned fallback stays")
assert_eq(openFn:find("GetLastSanctioned", 1, true), nil,
  "B39-A OpenRite Gora still does not fall back to GetLastSanctioned")
assert_eq(openFn:find("return nil, \"a Gora needs", 1, true), nil,
  "OpenRite Gora does not refuse an empty pair")

assert_true(srcOnHideBody:find('FRAME_NAME = "ChurchOfBeefConsoleFrame"', 1, true) ~= nil,
  "FRAME_NAME stays ChurchOfBeefConsoleFrame")
assert_true(srcOnHideBody:find("local function rememberSpecial", 1, true) ~= nil,
  "rememberSpecial helper stays")
assert_true(srcOnHideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "buildFrame still rememberSpecial FRAME_NAME")
assert_eq(srcOnHideBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcOnHideBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcOnHideBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcOnHideBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")
assert_eq(srcOnHideBody:find("PlaySound", 1, true), nil, "source must not PlaySound")
assert_eq(srcOnHideBody:find("IG_CHARACTER_INFO", 1, true), nil,
  "source does not PlaySound IG_CHARACTER_INFO_*")

local existing = Console.frame
assert_true(existing ~= nil, "B40-A Init creates the desk")
assert_eq(existing:GetName(), "ChurchOfBeefConsoleFrame",
  "B40-A desk name stays ChurchOfBeefConsoleFrame")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end
local keepA = Store:CreateCharacter({ name = "KeepA", class = "Warrior", level = 70 })
local keepB = Store:CreateCharacter({ name = "KeepB", class = "Mage", level = 68 })
local keepHuman = seedHuman("KeepHuman40", 1)
assert_true(Console:StartEvent() ~= nil, "StartEvent for Hide keep")
assert_true(Gora:Petition(keepB.id, keepA.id) ~= nil, "named petition lands")
COB.Roster = {
  ready = true,
  members = {
    keepa = { name = "KeepA", guildRankIndex = 4 },
    keepb = { name = "KeepB", guildRankIndex = 5 },
  },
}
Console:SelectFighters(keepA.id, keepB.id)
Console:SelectHuman(keepHuman.id)
local recKeep = Console:Recommend()
assert_true(recKeep ~= nil, "Recommend before remount Hide")
local keepText = frame.Recommendation:GetText() or ""
assert_true(keepText ~= "", "Recommend paints before remount Hide")
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B40-A wrapping the predicate does not stub the list true")

local savedOnHideList = UISpecialFrames
UISpecialFrames = {}
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 0,
  "B40-A wipe clears ChurchOfBeefConsoleFrame")
existing:SetScript("OnHide", nil)
assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Show")
local soundCalls = 0
local savedPlaySound = PlaySound
local savedPlaySoundFile = PlaySoundFile
local savedPlaySoundKitID = PlaySoundKitID
PlaySound = function()
  soundCalls = soundCalls + 1
end
PlaySoundFile = function()
  soundCalls = soundCalls + 1
end
PlaySoundKitID = function()
  soundCalls = soundCalls + 1
end
local hideCreates = 0
local savedHideCreate = CreateFrame
CreateFrame = function(...)
  hideCreates = hideCreates + 1
  return savedHideCreate(...)
end
Console:Show()
assert_eq(existing:IsShown(), true, "B40-A Show opens the desk")
assert_true(existing:GetScript("OnHide") ~= nil,
  "Show remounts missing OnHide via Refresh")
existing:SetScript("OnHide", nil)
assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Hide remount")
assert_eq(Console.selectedFighterA, keepA.id, "Show does not reset selected A")
assert_eq(Console.selectedFighterB, keepB.id, "Show does not reset selected B")
assert_eq(Console.selectedHumanId, keepHuman.id, "Show does not reset selected human")
Console:Hide()
CreateFrame = savedHideCreate
local restored = existing:GetScript("OnHide")
assert_true(restored ~= nil, "Hide remounts missing OnHide")
assert_eq(Console:IsShown(), false, "Hide closes the desk")
assert_eq(existing:IsShown(), false, "Hide hides the widget")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "ChurchOfBeefConsoleFrame re-listed once")
assert_eq(hideCreates, 0, "Hide remount does not rebuild")
assert_eq(soundCalls, 0, "Hide remount plays no sound")
assert_eq(existing:GetName(), "ChurchOfBeefConsoleFrame",
  "Hide remount keeps FRAME_NAME ChurchOfBeefConsoleFrame")
assert_eq(Console.frame, existing, "Hide remount keeps the same frame")
assert_eq(Console.selectedFighterA, keepA.id, "Hide does not reset selected A")
assert_eq(Console.selectedFighterB, keepB.id, "Hide does not reset selected B")
assert_eq(Console.selectedHumanId, keepHuman.id, "Hide does not reset selected human")
Console:Show()
assert_eq((existing.Recommendation and existing.Recommendation:GetText()) or "", keepText,
  "Hide does not reset Recommend")
Console:Hide()
assert_eq(existing:GetScript("OnHide"), restored,
  "second Hide does not replace OnHide")
Console:Hide()
assert_eq(existing:GetScript("OnHide"), restored,
  "third Hide does not replace OnHide")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "third Hide does not duplicate UISpecialFrames")
assert_eq(soundCalls, 0, "third Hide plays no sound")
PlaySound = savedPlaySound
PlaySoundFile = savedPlaySoundFile
PlaySoundKitID = savedPlaySoundKitID
assert_eq(Console.frame, existing, "third Hide still same frame pointer")
assert_eq(Console.selectedFighterA, keepA.id, "third Hide still keeps selected A")
assert_eq(Console.selectedFighterB, keepB.id, "third Hide still keeps selected B")
assert_eq(Console.selectedHumanId, keepHuman.id, "third Hide still keeps selected human")

UISpecialFrames = savedOnHideList

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end
reset()
Console:Init()
assert_eq(Console.selectedFighterA, nil, "empty OpenRite has no selected A")
assert_eq(Console.selectedFighterB, nil, "empty OpenRite has no selected B")
assert_true(Console:StartEvent() ~= nil, "StartEvent for empty OpenRite keep")
local emptyOpened = Console:OpenRite("Gora")
assert_true(emptyOpened ~= nil, "OpenRite Gora still opens with an empty pair")
assert_eq(emptyOpened.state, "RITE", "empty OpenRite Gora is not a refuse")
assert_eq(emptyOpened.riteType, "Gora", "empty OpenRite kind stays Gora")
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B40-A empty-OpenRite wrap does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B40-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B40-A")
end
runB40A()

--------------------------------------------------------------------------------
-- B41-A: Existing-frame Refresh remounts missing OnHide via
-- wireConsoleOnHide, then rememberSpecial(FRAME_NAME). Never
-- replace. Wipe list, nil OnHide, Refresh: OnHide restored,
-- ChurchOfBeefConsoleFrame re-listed once, no sound. Third
-- Refresh does not replace OnHide. QUIET Refresh still nils
-- Recommend (B31-A keep). Do not reset selection / pair.
-- Do not refuse empty OpenRite Gora. Show may stay without
-- a direct wireConsoleOnHide call (Show already Refreshs).
-- SaveNote nil. No SUMMON. Nested inside runB8E after runB40A().
--------------------------------------------------------------------------------
local function runB41A()
reset()
Console:Init()
assert_eq(Console.SaveNote, nil, "SaveNote stays nil")
assert_eq(Console.GetNotes, nil, "no notes table")
assert_eq(Console.CopyCeremonySummary, nil, "no post-show ceremony summary")
assert_eq(Console.CeremonySummary, nil, "no ceremony summary")
assert_eq(findButton(frame, "SUMMON THE FAITHFUL"), nil, "no SUMMON chrome")
assert_eq(findButton(frame, "COPY SUMMARY"), nil, "no ceremony-summary chrome")
assert_eq(findButton(frame, "WHISPER ALL"), nil, "no WHISPER ALL chrome")
assert_eq(findButton(frame, "RSVP"), nil, "no RSVP chrome")

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

local srcRefresh = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
assert_true(srcRefresh ~= nil, "Console.lua is readable for B41-A")
local srcRefreshBody = srcRefresh:read("*a")
srcRefresh:close()
assert_true(srcRefreshBody:find("local function wireConsoleOnHide", 1, true) ~= nil,
  "source extracts wireConsoleOnHide")
local wireConsole = srcRefreshBody:match("local function wireConsoleOnHide%(widget%)(.-)\nlocal function buildFrame")
assert_true(type(wireConsole) == "string" and wireConsole ~= "",
  "wireConsoleOnHide body is readable")
assert_true(wireConsole:find("if existing then return", 1, true) ~= nil,
  "wireConsoleOnHide does not replace an existing OnHide")
assert_true(wireConsole:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "OnHide remounts rememberSpecial FRAME_NAME")
assert_eq(wireConsole:find("selectedFighterA", 1, true), nil,
  "wireConsoleOnHide does not reset selectedFighterA")
assert_eq(wireConsole:find("selectedFighterB", 1, true), nil,
  "wireConsoleOnHide does not reset selectedFighterB")
assert_eq(wireConsole:find("lastRecommendation", 1, true), nil,
  "wireConsoleOnHide does not reset Recommend")
assert_eq(wireConsole:find("OnShow", 1, true), nil,
  "wireConsoleOnHide does not wire OnShow")
assert_eq(wireConsole:find("PlaySound", 1, true), nil,
  "wireConsoleOnHide does not PlaySound")
assert_eq(wireConsole:find("IG_CHARACTER_INFO", 1, true), nil,
  "wireConsoleOnHide has no IG_CHARACTER_INFO")
assert_eq(wireConsole:find("buildFrame", 1, true), nil,
  "wireConsoleOnHide does not call buildFrame")

local refreshFn = srcRefreshBody:match("function Console:Refresh%(%)(.-)\nfunction Console:Show")
assert_true(type(refreshFn) == "string" and refreshFn ~= "",
  "Refresh body is readable")
local wireAt = refreshFn:find("wireConsoleOnHide", 1, true)
local remountAt = refreshFn:find("rememberSpecial(FRAME_NAME)", 1, true)
assert_true(wireAt ~= nil, "Refresh remounts OnHide via wireConsoleOnHide")
assert_true(remountAt ~= nil, "Refresh remount still rememberSpecial FRAME_NAME")
assert_true(type(wireAt) == "number" and type(remountAt) == "number" and wireAt < remountAt,
  "Refresh remounts OnHide before rememberSpecial")
assert_eq(refreshFn:find("SetScript", 1, true), nil,
  "Refresh does not SetScript inline")
assert_eq(refreshFn:find("OnShow", 1, true), nil,
  "Refresh does not re-wire OnShow")
assert_eq(refreshFn:find("selectedFighterA", 1, true), nil,
  "Refresh does not reset selectedFighterA")
assert_eq(refreshFn:find("selectedFighterB", 1, true), nil,
  "Refresh does not reset selectedFighterB")
assert_eq(refreshFn:find("selectedHumanId", 1, true), nil,
  "Refresh does not reset selectedHumanId")
assert_true(refreshFn:find('state == nil or state == "QUIET"', 1, true) ~= nil,
  "B31-A Refresh treats nil or QUIET Runtime state as a leftover drop")
assert_true(refreshFn:find("lastRecommendation = nil", 1, true) ~= nil,
  "B31-A QUIET Refresh still nils lastRecommendation")
local dropAt = refreshFn:find("lastRecommendation = nil", 1, true)
local paintAt = refreshFn:find("paintRecommendation(self.frame)", 1, true)
assert_true(type(dropAt) == "number" and type(paintAt) == "number" and dropAt < paintAt,
  "B31-A Refresh nils lastRecommendation before paintRecommendation")
assert_eq(refreshFn:find("buildFrame", 1, true), nil,
  "Refresh remount does not rebuild")
assert_eq(refreshFn:find("CreateFrame", 1, true), nil,
  "Refresh remount does not CreateFrame")
assert_eq(refreshFn:find("PlaySound", 1, true), nil,
  "Refresh remount does not PlaySound")
assert_eq(refreshFn:find("IG_CHARACTER_INFO", 1, true), nil,
  "Refresh remount has no IG_CHARACTER_INFO")

local showFn = srcRefreshBody:match("function Console:Show%(%)(.-)\nfunction Console:Hide")
assert_true(type(showFn) == "string" and showFn ~= "",
  "Show body stays readable")
assert_eq(showFn:find("wireConsoleOnHide", 1, true), nil,
  "Show has no direct wireConsoleOnHide")
assert_true(showFn:find("self:Refresh()", 1, true) ~= nil,
  "Show already Refreshs")
assert_true(showFn:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "B28-A Show rememberSpecial FRAME_NAME stays")

local hideFn = srcRefreshBody:match("function Console:Hide%(%)(.-)\nfunction Console:IsShown")
assert_true(type(hideFn) == "string" and hideFn ~= "",
  "Hide body stays readable")
assert_true(hideFn:find("wireConsoleOnHide", 1, true) ~= nil,
  "B40-A Hide remount via wireConsoleOnHide stays")

local earlyInit = srcRefreshBody:match("function Console:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
assert_true(type(earlyInit) == "string" and earlyInit ~= "",
  "Init early-return body stays readable")
assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "B27-A early-return rememberSpecial FRAME_NAME stays")
assert_eq(earlyInit:find("wireConsoleOnHide", 1, true), nil,
  "Init remount does not remount OnHide")

local openFn = srcRefreshBody:match("function Console:OpenRite%(kind%)(.-)\nfunction Console:CloseRite")
assert_true(type(openFn) == "string" and openFn ~= "",
  "OpenRite body stays readable")
assert_true(openFn:find("GetSanctioned", 1, true) ~= nil,
  "B39-A live GetSanctioned fallback stays")
assert_eq(openFn:find("GetLastSanctioned", 1, true), nil,
  "B39-A OpenRite Gora still does not fall back to GetLastSanctioned")
assert_eq(openFn:find("return nil, \"a Gora needs", 1, true), nil,
  "OpenRite Gora does not refuse an empty pair")

assert_true(srcRefreshBody:find('FRAME_NAME = "ChurchOfBeefConsoleFrame"', 1, true) ~= nil,
  "FRAME_NAME stays ChurchOfBeefConsoleFrame")
assert_true(srcRefreshBody:find("local function rememberSpecial", 1, true) ~= nil,
  "rememberSpecial helper stays")
assert_eq(srcRefreshBody:find("function Console:SaveNote", 1, true), nil,
  "source must not define SaveNote")
assert_eq(srcRefreshBody:find("SUMMON THE FAITHFUL", 1, true), nil,
  "source must not contain SUMMON")
assert_eq(srcRefreshBody:find("Parchment", 1, true), nil, "console stays stock, not parchment")
assert_eq(srcRefreshBody:find("PanelTabButtonTemplate", 1, true), nil,
  "desks are not collapsed into tabs")
assert_eq(srcRefreshBody:find("PlaySound", 1, true), nil, "source must not PlaySound")
assert_eq(srcRefreshBody:find("IG_CHARACTER_INFO", 1, true), nil,
  "source does not PlaySound IG_CHARACTER_INFO_*")

local existing = Console.frame
assert_true(existing ~= nil, "B41-A Init creates the desk")
assert_eq(existing:GetName(), "ChurchOfBeefConsoleFrame",
  "B41-A desk name stays ChurchOfBeefConsoleFrame")

local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end
local keepA = Store:CreateCharacter({ name = "KeepA41", class = "Warrior", level = 70 })
local keepB = Store:CreateCharacter({ name = "KeepB41", class = "Mage", level = 68 })
local keepHuman = seedHuman("KeepHuman41", 1)
assert_true(Console:StartEvent() ~= nil, "StartEvent for Refresh keep")
assert_true(Gora:Petition(keepB.id, keepA.id) ~= nil, "named petition lands")
COB.Roster = {
  ready = true,
  members = {
    keepa41 = { name = "KeepA41", guildRankIndex = 4 },
    keepb41 = { name = "KeepB41", guildRankIndex = 5 },
  },
}
Console:SelectFighters(keepA.id, keepB.id)
Console:SelectHuman(keepHuman.id)
local recKeep = Console:Recommend()
assert_true(recKeep ~= nil, "Recommend before remount Refresh")
local keepText = (existing.Recommendation and existing.Recommendation:GetText()) or ""
assert_true(keepText ~= "", "Recommend paints before remount Refresh")
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B41-A wrapping the predicate does not stub the list true")

local savedOnHideList = UISpecialFrames
UISpecialFrames = {}
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 0,
  "B41-A wipe clears ChurchOfBeefConsoleFrame")
existing:SetScript("OnHide", nil)
assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Refresh")
local soundCalls = 0
local savedPlaySound = PlaySound
local savedPlaySoundFile = PlaySoundFile
local savedPlaySoundKitID = PlaySoundKitID
PlaySound = function()
  soundCalls = soundCalls + 1
end
PlaySoundFile = function()
  soundCalls = soundCalls + 1
end
PlaySoundKitID = function()
  soundCalls = soundCalls + 1
end
local refreshCreates = 0
local savedRefreshCreate = CreateFrame
CreateFrame = function(...)
  refreshCreates = refreshCreates + 1
  return savedRefreshCreate(...)
end
Console:Refresh()
CreateFrame = savedRefreshCreate
local restored = existing:GetScript("OnHide")
assert_true(restored ~= nil, "Refresh remounts missing OnHide")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "ChurchOfBeefConsoleFrame re-listed once")
assert_eq(refreshCreates, 0, "Refresh remount does not rebuild")
assert_eq(soundCalls, 0, "Refresh remount plays no sound")
assert_eq(existing:GetName(), "ChurchOfBeefConsoleFrame",
  "Refresh remount keeps FRAME_NAME ChurchOfBeefConsoleFrame")
assert_eq(Console.frame, existing, "Refresh remount keeps the same frame")
assert_eq(Console.selectedFighterA, keepA.id, "Refresh does not reset selected A")
assert_eq(Console.selectedFighterB, keepB.id, "Refresh does not reset selected B")
assert_eq(Console.selectedHumanId, keepHuman.id, "Refresh does not reset selected human")
assert_eq((existing.Recommendation and existing.Recommendation:GetText()) or "", keepText,
  "live Refresh does not reset Recommend")
Console:Refresh()
assert_eq(existing:GetScript("OnHide"), restored,
  "second Refresh does not replace OnHide")
Console:Refresh()
assert_eq(existing:GetScript("OnHide"), restored,
  "third Refresh does not replace OnHide")
assert_eq(countSpecial("ChurchOfBeefConsoleFrame"), 1,
  "third Refresh does not duplicate UISpecialFrames")
assert_eq(soundCalls, 0, "third Refresh plays no sound")
PlaySound = savedPlaySound
PlaySoundFile = savedPlaySoundFile
PlaySoundKitID = savedPlaySoundKitID
assert_eq(Console.frame, existing, "third Refresh still same frame pointer")
assert_eq(Console.selectedFighterA, keepA.id, "third Refresh still keeps selected A")
assert_eq(Console.selectedFighterB, keepB.id, "third Refresh still keeps selected B")
assert_eq(Console.selectedHumanId, keepHuman.id, "third Refresh still keeps selected human")

assert_true(Runtime:EndEvent() ~= nil, "Runtime EndEvent bypasses the desk")
Console:Refresh()
assert_eq((existing.Recommendation and existing.Recommendation:GetText()) or "", "",
  "QUIET Refresh still nils Recommend")
assert_eq(Console.selectedFighterA, keepA.id, "QUIET Refresh keeps selected A")
assert_eq(Console.selectedFighterB, keepB.id, "QUIET Refresh keeps selected B")

UISpecialFrames = savedOnHideList

savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return true end
reset()
Console:Init()
assert_eq(Console.selectedFighterA, nil, "empty OpenRite has no selected A")
assert_eq(Console.selectedFighterB, nil, "empty OpenRite has no selected B")
assert_true(Console:StartEvent() ~= nil, "StartEvent for empty OpenRite keep")
local emptyOpened = Console:OpenRite("Gora")
assert_true(emptyOpened ~= nil, "OpenRite Gora still opens with an empty pair")
assert_eq(emptyOpened.state, "RITE", "empty OpenRite Gora is not a refuse")
assert_eq(emptyOpened.riteType, "Gora", "empty OpenRite kind stays Gora")
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(COB.Group.PlayerName()), false,
  "B41-A empty-OpenRite wrap does not stub the list true")

assert_eq(Console.SaveNote, nil, "SaveNote stays nil after B41-A")
if standalone then
  assert_eq(COB.Archive, nil, "isolation still does not load Archive")
  assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
  assert_eq(COB.Confession, nil, "isolation still does not load Confession")
end
assert_eq(COB.Popes, nil, "still no Pope list after B41-A")
end
runB41A()

  --------------------------------------------------------------------------------
  -- U-I: title-bar seal, sacred-verb plates, charcoal ground, quiet Skip.
  -- Nested inside runB8E — no new main-chunk locals.
  --------------------------------------------------------------------------------
  local function runUI()
    reset()
    local desk = Console:Init()
    local Theme = COB.Theme
    assert_true(Theme ~= nil, "U-I Theme is loaded")
    local sealPath = Theme:Texture("seal_papal")
    local plateUp = Theme:Texture("plate_verb")
    local plateHover = Theme:Texture("plate_verb_hover")
    local plateDown = Theme:Texture("plate_verb_pressed")
    local charcoalR, charcoalG, charcoalB = Theme:Color("charcoal")
    assert_true(type(sealPath) == "string" and sealPath ~= "", "Theme resolves seal_papal")
    assert_true(type(plateUp) == "string" and plateUp ~= "", "Theme resolves plate_verb")
    assert_true(type(plateHover) == "string" and plateHover ~= "", "Theme resolves plate_verb_hover")
    assert_true(type(plateDown) == "string" and plateDown ~= "", "Theme resolves plate_verb_pressed")
    assert_eq(type(charcoalR), "number", "Theme resolves charcoal r")

    assert_true(desk.TitleSeal ~= nil, "title-bar seal slot exists")
    assert_eq(desk.TitleSeal._type, "Texture", "title-bar seal is a Texture")
    assert_eq(desk.TitleSeal._cobTexture, sealPath, "title-bar seal uses Theme:Texture seal_papal")
    assert_eq(desk.TitleSeal:GetWidth(), 20, "title-bar seal is 20px wide")
    assert_eq(desk.TitleSeal:GetHeight(), 20, "title-bar seal is 20px tall")
    assert_eq(desk.TitleSeal:GetParent(), desk.TitleBar, "seal sits on the title bar")

    local knightPlate = findButton(desk, "KNIGHT THIS BEEF")
    local sanctionPlate = findButton(desk, "SANCTION BEEF GORA")
    assert_true(knightPlate ~= nil, "KNIGHT THIS BEEF stays")
    assert_true(sanctionPlate ~= nil, "SANCTION BEEF GORA stays")
    assert_eq(knightPlate._template, "UIPanelButtonTemplate", "KNIGHT stays a panel button")
    assert_eq(sanctionPlate._template, "UIPanelButtonTemplate", "SANCTION stays a panel button")
    assert_eq(knightPlate._cobNormalTexture, plateUp, "KNIGHT normal is Theme plate_verb")
    assert_eq(knightPlate._cobHighlightTexture, plateHover, "KNIGHT highlight is Theme plate_verb_hover")
    assert_eq(knightPlate._cobPushedTexture, plateDown, "KNIGHT pushed is Theme plate_verb_pressed")
    assert_eq(sanctionPlate._cobNormalTexture, plateUp, "SANCTION normal is Theme plate_verb")
    assert_eq(sanctionPlate._cobHighlightTexture, plateHover, "SANCTION highlight is Theme plate_verb_hover")
    assert_eq(sanctionPlate._cobPushedTexture, plateDown, "SANCTION pushed is Theme plate_verb_pressed")

    local platedLabels = {}
    walk(desk, function(child)
      if child._type == "Button" and child._cobNormalTexture then
        platedLabels[#platedLabels + 1] = child:GetText()
      end
    end)
    table.sort(platedLabels)
    assert_eq(#platedLabels, 2, "exactly two plated buttons")
    assert_eq(platedLabels[1], "KNIGHT THIS BEEF", "KNIGHT is plated")
    assert_eq(platedLabels[2], "SANCTION BEEF GORA", "SANCTION is plated")

    local furniture = {
      "Skip", "Enqueue", "Dismiss", "Recommend", "Call Forward",
      "ELEVATE TO LORD", "DECLARE VICTOR", "COWARDICE RECORDED", "VOID",
      "FREE RULING", "Post Decree", "Start Event", "End Event",
    }
    for i = 1, #furniture do
      local btn = findButton(desk, furniture[i])
      assert_true(btn ~= nil, furniture[i] .. " stays")
      assert_eq(btn._cobNormalTexture, nil, furniture[i] .. " is not a verb plate")
      assert_eq(btn._cobHighlightTexture, nil, furniture[i] .. " has no plate hover")
      assert_eq(btn._cobPushedTexture, nil, furniture[i] .. " has no plate press")
    end

    local skipBtnUI = findButton(desk, "Skip")
    assert_eq(skipBtnUI._template, "UIPanelButtonTemplate", "Skip stays stock gray chrome")
    assert_eq(skipBtnUI._cobColor, nil, "Skip has no tint table")
    local skipTinted = 0
    walk(skipBtnUI, function(child)
      if child._cobColor then skipTinted = skipTinted + 1 end
    end)
    assert_eq(skipTinted, 0, "Skip regions have no red or other tint")

    local charcoalSeen = {}
    local charcoalHits = 0
    walk(desk, function(child)
      if child._type == "Texture" and child._cobColor and child._cobColor.role == "charcoal"
          and not charcoalSeen[child] then
        charcoalSeen[child] = true
        charcoalHits = charcoalHits + 1
        assert_eq(child._cobColor.r, charcoalR, "desk ground r is Theme charcoal")
        assert_eq(child._cobColor.g, charcoalG, "desk ground g is Theme charcoal")
        assert_eq(child._cobColor.b, charcoalB, "desk ground b is Theme charcoal")
      end
    end)
    assert_eq(charcoalHits, 2, "both desk panels use Theme charcoal")

    assert_eq(findButton(desk, "WHISPER ALL"), nil, "U-I still has no WHISPER ALL")
    assert_eq(Console.Announce, nil, "U-I still has no Announce")
    assert_eq(Console.WhisperAll, nil, "U-I still has no WhisperAll")

    local srcUI = io.open("addon/ChurchOfBeef/UI/Console.lua", "r")
    assert_true(srcUI ~= nil, "Console.lua is readable for U-I pins")
    local srcUIBody = srcUI:read("*a")
    srcUI:close()
    assert_eq(srcUIBody:find("0.08, 0.08, 0.08", 1, true), nil, "bg literal is gone")
    assert_true(srcUIBody:find('Theme:Color("charcoal")', 1, true) ~= nil,
      "desk ground routes through Theme charcoal")
    assert_true(srcUIBody:find('Theme:Texture("seal_papal")', 1, true) ~= nil,
      "seal slot requests Theme seal_papal")
    assert_true(srcUIBody:find('themeTexture("plate_verb")', 1, true) ~= nil,
      "plates request Theme plate_verb")
    assert_eq(srcUIBody:find("SendChatMessage(", 1, true), nil, "no SendChatMessage call")
    assert_eq(srcUIBody:find("WHISPER ALL", 1, true), nil, "source still has no WHISPER ALL")
    assert_eq(srcUIBody:find("oxblood", 1, true), nil, "red token is unused on this desk")
    assert_eq(srcUIBody:find("RomanNumeral", 1, true), nil, "arabic numerals stay")
    assert_eq(srcUIBody:find("RomanPair", 1, true), nil, "console does not romanize")
    assert_eq(srcUIBody:find("Media\\", 1, true), nil, "no hardcoded Media path")

    local h2hA = Store:CreateCharacter({ name = "ChuckroastUI", class = "Warrior", level = 70 })
    local h2hB = Store:CreateCharacter({ name = "TendermageUI", class = "Mage", level = 68 })
    Store:RecordGoraResult(h2hA.id, {
      opponentId = h2hB.id,
      ruling = "victor",
      won = true,
    }, 3100)
    assert_true(Runtime:StartEvent() ~= nil, "U-I H2H needs a live event")
    Gora:Petition(h2hA.id, h2hB.id)
    COB.Roster = {
      ready = true,
      members = {
        chuckroastui = { name = "ChuckroastUI", guildRankIndex = 4 },
        tendermageui = { name = "TendermageUI", guildRankIndex = 5 },
      },
    }
    Console:Refresh()
    local h2hLine
    walk(desk, function(child)
      if child._type == "Button" and child.GetText then
        local text = child:GetText() or ""
        if text:find("ChuckroastUI", 1, true) and text:find("names", 1, true) then
          h2hLine = text
        end
      end
    end)
    assert_true(h2hLine ~= nil, "named petitioner card still paints")
    assert_true(h2hLine:find("1-0", 1, true) ~= nil, "petitioner card keeps mute arabic H2H")
    assert_eq(h2hLine:find("I-0", 1, true), nil, "H2H is not romanized")
    assert_eq(h2hLine:find("I–0", 1, true), nil, "H2H is not an en-dash roman pair")
  end
  runUI()
end
runB8E()

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
