-- Records Book superlatives (Phase 4 Lane G). Isolated: wow_ui_stub + Common + Ranks + Store + RecordsBook.
-- Player-opened Quiet identity/history. Theatrical parchment, not a sortable ladder.
-- No TOC / bootstrap / run.lua / MainFrame / Console / Hud / Store / Net edits. No slash.
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
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/UI/RecordsBook.lua")

local COB = ChurchOfBeef
local Store = COB.Store
local Book = COB.RecordsBook

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

local BIBLE_TITLES = {
  "Most Sanctioned Victories",
  "Longest Streak",
  "Most Successful Defenses",
  "The Iron Chin",
  "Greatest Rivalry",
  "Famous Upsets",
  "The Undefeated",
  "The Glorious Martyr",
  "Tournament Champions",
}

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  if Book.ResetForTests then
    assert_eq(Book:ResetForTests(), true, "RecordsBook ResetForTests runs under _IN_TEST")
  end
  sounds = 0
end

local function char(name, class)
  return Store:CreateCharacter({ name = name, class = class })
end

-- Both combatants receive the Pope's ruling. Store writes are per-character.
local function bout(a, b, winner, now, fields)
  fields = fields or {}
  local ruling = fields.ruling or "victor"
  local flag = fields.famousUpset == true
  if ruling == "void" then
    Store:RecordGoraResult(a.id, { opponentId = b.id, ruling = "void", famousUpset = flag }, now)
    Store:RecordGoraResult(b.id, { opponentId = a.id, ruling = "void", famousUpset = flag }, now)
    return
  end
  Store:RecordGoraResult(a.id, {
    opponentId = b.id,
    ruling = ruling,
    won = (winner == a),
    famousUpset = flag and winner == a,
  }, now)
  Store:RecordGoraResult(b.id, {
    opponentId = a.id,
    ruling = ruling,
    won = (winner == b),
    famousUpset = flag and winner == b,
  }, now)
end

local function pageNamed(title)
  local pages = Book:GetPages()
  for i = 1, #pages do
    if pages[i].title == title then return pages[i], i end
  end
  return nil
end

local function namesOn(title)
  local page = pageNamed(title)
  local names = {}
  if not page then return names end
  for i = 1, #page.entries do
    local e = page.entries[i]
    names[#names + 1] = e.name or e.nameA
  end
  return names
end

local function hasName(title, name)
  local names = namesOn(title)
  for i = 1, #names do
    if names[i] == name then return true end
  end
  return false
end

local function buttonFor(label)
  local frame = Book.frame
  if not frame then return nil end
  return stub.findChild(frame, function(child)
    return child._type == "Button" and child:GetText() == label
  end)
end

--------------------------------------------------------------------------------
-- Isolated surface: stub + Common + Ranks + Store + RecordsBook.
--------------------------------------------------------------------------------
assert_true(Book ~= nil, "COB.RecordsBook exists")
assert_true(Store ~= nil, "isolated suite loads Store")
assert_true(COB.Ranks ~= nil, "isolated suite loads Ranks")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_eq(Book.MODE, "QUIET", "Records Book declares Quiet Mode (player-opened identity/history)")
assert_eq(Book.Grant, nil, "no Grant")
assert_eq(Book.Standing, nil, "no Standing")
assert_eq(Book.ComputeFamousUpsets, nil, "Famous Upsets are never computed")
assert_eq(Book.RecordDefense, nil, "no defense increment")
assert_eq(Book.AddTournamentChampion, nil, "no tournament engine")
assert_eq(Book.SortPages, nil, "pages are not a sortable ladder")
assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "this file does not register a slash")
assert_eq(type(SLASH_RECORDSBOOK1), "nil", "no Records Book slash")

if standalone then
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.UI, nil, "isolated suite does not load MainFrame")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
end

--------------------------------------------------------------------------------
-- Init: hidden parchment tome. No auto-open. No sound. No OnUpdate.
--------------------------------------------------------------------------------
reset()
assert_eq(Book:IsShown(), false, "the book is closed before Init")
local frame = Book:Init()
assert_true(frame ~= nil, "Init creates the frame")
assert_eq(frame:GetName(), "ChurchOfBeefRecordsBook", "frame has a global name for UISpecialFrames")
assert_eq(Book:Init(), frame, "Init is idempotent")
assert_eq(Book:IsShown(), false, "Init does not open the book")
assert_eq(frame:IsShown(), false, "the widget starts hidden")
assert_eq(frame._template, nil, "theatrical tome is not BasicFrameTemplate")
assert_eq(frame._movable, true, "the book is movable")
assert_eq(frame._clamped, true, "the book is clamped to screen")
assert_eq(frame:GetScript("OnUpdate"), nil, "no permanent OnUpdate")
assert_eq(sounds, 0, "Init plays no sound")
assert_true(frame.Iron ~= nil, "dark-iron field exists")
assert_true(frame.Parchment ~= nil, "parchment leaf exists")
assert_true(frame.GoldEdge ~= nil, "muted-gold edge exists")
assert_true(frame.TitleText ~= nil, "title FontString exists")
assert_eq(frame.TitleText:GetText(), "The Records Book", "chrome title is the Bible name")
assert_true(frame.PageTitle ~= nil, "page title FontString exists")
assert_true(frame.Body ~= nil, "body FontString exists")
assert_true(frame.TitleText._template ~= nil, "title uses a GameFont* fallback template")
assert_true(UISpecialFrames[1] == "ChurchOfBeefRecordsBook" or (function()
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == "ChurchOfBeefRecordsBook" then return true end
  end
  return false
end)(), "Escape can close the book")

assert_eq(buttonFor("Ladder"), nil, "no Ladder chrome")
assert_eq(buttonFor("My Standing"), nil, "no Standing chrome")
assert_eq(buttonFor("Sort"), nil, "no Sort control")
assert_eq(buttonFor("#1"), nil, "no #1 rating control")
assert_eq(buttonFor("Grant"), nil, "no Grant control")

--------------------------------------------------------------------------------
-- Toggle / Show / Hide only. No feed. No auto-open. No sound.
--------------------------------------------------------------------------------
assert_eq(Book:Show(), true, "Show succeeds")
assert_eq(Book:IsShown(), true, "Show opens the book")
assert_eq(Book:Show(), true, "Show on an open book is still success")
assert_eq(Book:IsShown(), true, "Show does not toggle closed")
assert_eq(Book:Hide(), true, "Hide succeeds")
assert_eq(Book:IsShown(), false, "Hide closes the book")
assert_eq(Book:Hide(), true, "Hide on a closed book is still success")
assert_eq(Book:Toggle(), true, "Toggle opens a closed book")
assert_eq(Book:IsShown(), true, "Toggle opened")
assert_eq(Book:Toggle(), true, "Toggle closes an open book")
assert_eq(Book:IsShown(), false, "Toggle closed")
assert_eq(sounds, 0, "Show / Hide / Toggle play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "open book still has no OnUpdate")

local close = frame.CloseButton
assert_true(close ~= nil, "a close control exists")
Book:Show()
assert_true(stub.fire(close, "OnClick"), "close is wired")
assert_eq(Book:IsShown(), false, "close hides the book")
assert_eq(sounds, 0, "close plays no addon sound")

--------------------------------------------------------------------------------
-- Bible pages from an empty store. Defenses and Tournament Champions stay empty.
--------------------------------------------------------------------------------
reset()
local pages = Book:GetPages()
assert_eq(#pages, #BIBLE_TITLES, "exactly the Bible MVP pages")
for i = 1, #BIBLE_TITLES do
  assert_eq(pages[i].title, BIBLE_TITLES[i], "page " .. i .. " is " .. BIBLE_TITLES[i])
  assert_eq(type(pages[i].entries), "table", BIBLE_TITLES[i] .. " has an entries list")
  assert_eq(pages[i].rank, nil, BIBLE_TITLES[i] .. " is not a ranked row")
  assert_eq(pages[i].rating, nil, BIBLE_TITLES[i] .. " has no rating")
  assert_eq(pages[i].place, nil, BIBLE_TITLES[i] .. " has no place")
end
assert_eq(#pageNamed("Most Successful Defenses").entries, 0, "Defenses is empty (OPEN_QUESTIONS #9)")
assert_eq(#pageNamed("Tournament Champions").entries, 0, "Tournament Champions is empty")
assert_eq(#pageNamed("Famous Upsets").entries, 0, "unflagged empty store has no Famous Upsets")
assert_eq(#pageNamed("Most Sanctioned Victories").entries, 0, "no victories yet")
assert_eq(#pageNamed("The Undefeated").entries, 0, "no unbeaten records yet")

Book:Show()
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "first leaf is Most Sanctioned Victories")
assert_eq(frame.Body:GetText(), "", "empty leaf has no invented copy")
assert_eq(sounds, 0, "painting an empty book is silent")

--------------------------------------------------------------------------------
-- Most Sanctioned Victories: the holder(s), not a ladder of everyone.
--------------------------------------------------------------------------------
reset()
local chuck = char("Chuckroast", "Warrior")
local tender = char("Tendermage", "Mage")
local rib = char("Ribeye")
bout(chuck, tender, chuck, 1000)
bout(chuck, tender, chuck, 1001)
bout(chuck, rib, chuck, 1002)
bout(tender, rib, tender, 1003)

local victories = pageNamed("Most Sanctioned Victories")
assert_eq(#victories.entries, 1, "only the superlative holder is listed")
assert_eq(victories.entries[1].name, "Chuckroast", "most sanctioned victories is Chuckroast")
assert_eq(victories.entries[1].wins, 3, "the measure is sanctioned wins")
assert_eq(victories.entries[1].characterId, chuck.id, "holder is the character id")
assert_eq(victories.entries[1].place, nil, "no place number")
assert_eq(victories.entries[1].rating, nil, "no rating")
assert_eq(hasName("Most Sanctioned Victories", "Tendermage"), false, "a lesser win count is not a runner-up row")
assert_eq(hasName("Most Sanctioned Victories", "Ribeye"), false, "a zero-win record is not listed")

bout(tender, rib, tender, 1004)
bout(tender, chuck, tender, 1005)
local tied = pageNamed("Most Sanctioned Victories")
assert_eq(#tied.entries, 2, "a shared record lists both holders")
assert_eq(tied.entries[1].wins, 3, "shared measure is 3")
assert_eq(tied.entries[2].wins, 3, "both holders show the same measure")
assert_true(hasName("Most Sanctioned Victories", "Chuckroast"), "Chuckroast still holds")
assert_true(hasName("Most Sanctioned Victories", "Tendermage"), "Tendermage shares the hold")
assert_eq(tied.entries[1].characterId < tied.entries[2].characterId, true, "tied holders are id-ordered, not ranked")

--------------------------------------------------------------------------------
-- Longest Streak: sanctioned-Gora W/L only. Peak from the result log. Void ignored.
--------------------------------------------------------------------------------
reset()
local a = char("Streaker")
local b = char("Foil")
local c = char("Shorter")
bout(a, b, a, 2000)
bout(a, b, a, 2001)
bout(a, b, a, 2002)
bout(a, b, a, 2003)
bout(a, b, a, 2004)
bout(a, b, b, 2005)
bout(c, b, c, 2006)
bout(c, b, c, 2007)
bout(c, b, c, 2008)
local streak = pageNamed("Longest Streak")
assert_eq(#streak.entries, 1, "Longest Streak is a superlative")
assert_eq(streak.entries[1].name, "Streaker", "the broken five-win peak still holds Longest Streak")
assert_eq(streak.entries[1].streak, 5, "the measure is the longest sanctioned win run")
assert_eq(hasName("Longest Streak", "Shorter"), false, "a live three-win streak is not listed when 5 exists")
assert_eq(Store:GetCharacter(a.id).gora.streak, -1, "Store current streak is a loss; the page still uses the peak")

reset()
local v1 = char("Voided")
local v2 = char("Other")
bout(v1, v2, v1, 2100)
bout(v1, v2, nil, 2101, { ruling = "void" })
bout(v1, v2, v1, 2102)
local voidStreak = pageNamed("Longest Streak")
assert_eq(voidStreak.entries[1].name, "Voided", "Void does not break the fight-record streak")
assert_eq(voidStreak.entries[1].streak, 2, "Void is skipped; two victories remain a streak of 2")

--------------------------------------------------------------------------------
-- Most Successful Defenses: omit-or-empty. Do not derive from elevationAt.
--------------------------------------------------------------------------------
reset()
local lordH = Store:CreateHuman({ name = "Lordly" }, 3000)
local lordC = char("Lordalt")
local challenger = char("Challenger")
Store:LinkCharacter(lordC.id, lordH.id, 3001)
Store:SetRank(lordH.id, 4, 3002)
assert_eq(Store:GetHuman(lordH.id).rankId, 4, "human is a Beef Lord")
assert_true(Store:GetHuman(lordH.id).elevationAt ~= nil, "Store stamped elevationAt")
bout(lordC, challenger, lordC, 3100)
bout(lordC, challenger, lordC, 3101)
assert_eq(#pageNamed("Most Successful Defenses").entries, 0,
  "Lord victories after elevation do not invent a defense increment")
assert_eq(Store:GetCharacter(lordC.id).gora.defenses, nil, "Store still has no defenses field")

--------------------------------------------------------------------------------
-- The Iron Chin: most Goras fought. Voids count as fought.
--------------------------------------------------------------------------------
reset()
local chin = char("Ironjaw")
local soft = char("Softer")
local extra = char("Extra")
bout(chin, soft, chin, 4000)
bout(chin, soft, soft, 4001)
bout(chin, extra, nil, 4002, { ruling = "void" })
local iron = pageNamed("The Iron Chin")
assert_eq(#iron.entries, 1, "Iron Chin lists the most-fought holder")
assert_eq(iron.entries[1].name, "Ironjaw", "three sanctioned Goras is the chin")
assert_eq(iron.entries[1].fought, 3, "voids count as Goras fought")
assert_eq(hasName("The Iron Chin", "Softer"), false, "two fights is not the chin")

--------------------------------------------------------------------------------
-- Greatest Rivalry: most-fought pairing + running score. Not every pairing.
--------------------------------------------------------------------------------
reset()
local r1 = char("Riva")
local r2 = char("Rival")
local r3 = char("Once")
bout(r1, r2, r1, 5000)
bout(r1, r2, r2, 5001)
bout(r1, r2, r1, 5002)
bout(r1, r3, r1, 5003)
local rivalry = pageNamed("Greatest Rivalry")
assert_eq(#rivalry.entries, 1, "only the most-fought pairing is listed")
assert_eq(rivalry.entries[1].fights, 3, "the pairing fought three times")
assert_true(
  (rivalry.entries[1].nameA == "Riva" and rivalry.entries[1].nameB == "Rival")
    or (rivalry.entries[1].nameA == "Rival" and rivalry.entries[1].nameB == "Riva"),
  "Greatest Rivalry names both combatants")
local scoreSum = rivalry.entries[1].scoreA + rivalry.entries[1].scoreB
assert_eq(scoreSum, 3, "running score accounts for the three decisive bouts")
assert_true(rivalry.entries[1].scoreA == 2 or rivalry.entries[1].scoreB == 2, "Riva leads 2–1")
assert_true(rivalry.entries[1].scoreA == 1 or rivalry.entries[1].scoreB == 1, "Rival has 1")
assert_eq(hasName("Greatest Rivalry", "Once"), false, "a one-bout pairing is not the rivalry")
assert_eq(rivalry.entries[1].place, nil, "rivalry is not a ranked row")

--------------------------------------------------------------------------------
-- Famous Upsets: Pope-flagged only. Never computed from rank or level.
--------------------------------------------------------------------------------
reset()
local freshH = Store:CreateHuman({ name = "Fresh" }, 6000)
local lordH2 = Store:CreateHuman({ name = "SittingLord" }, 6001)
local freshC = Store:CreateCharacter({ name = "Underdog", class = "Priest", level = 60 })
local lordC2 = Store:CreateCharacter({ name = "Champ", class = "Warrior", level = 70 })
Store:LinkCharacter(freshC.id, freshH.id, 6002)
Store:LinkCharacter(lordC2.id, lordH2.id, 6003)
Store:SetRank(freshH.id, 1, 6004)
Store:SetRank(lordH2.id, 4, 6005)
bout(freshC, lordC2, freshC, 6100)
assert_eq(#pageNamed("Famous Upsets").entries, 0,
  "a Fresh Beef beating a Lord is not an upset unless the Pope flags it")

bout(freshC, lordC2, freshC, 6101, { famousUpset = true })
local upsets = pageNamed("Famous Upsets")
assert_eq(#upsets.entries, 1, "the flagged result is the only Famous Upset")
assert_eq(upsets.entries[1].name, "Underdog", "the flagged winner is named")
assert_eq(upsets.entries[1].opponentName, "Champ", "the flagged opponent is named")
assert_eq(upsets.entries[1].at, 6101, "the flagged result keeps its timestamp")
assert_eq(upsets.entries[1].computed, nil, "no computed-upset mark")

local unflagged = Store:GetCharacter(freshC.id).gora.results[1]
assert_eq(unflagged.famousUpset, false, "the first bout stayed unflagged")
assert_eq(Store:GetCharacter(freshC.id).gora.results[2].famousUpset, true, "the second bout carries the Pope flag")

--------------------------------------------------------------------------------
-- The Undefeated: active unbeaten records. A set, not a ranking.
--------------------------------------------------------------------------------
reset()
local u1 = char("Clean")
local u2 = char("AlsoClean")
local u3 = char("Fallen")
local fodder = char("Fodder")
bout(u1, fodder, u1, 7000)
bout(u2, fodder, u2, 7001)
bout(u2, fodder, u2, 7002)
bout(u3, fodder, u3, 7003)
bout(u3, fodder, fodder, 7004)
local undefeated = pageNamed("The Undefeated")
assert_eq(#undefeated.entries, 2, "both unbeaten records are listed")
assert_true(hasName("The Undefeated", "Clean"), "1–0 is unbeaten")
assert_true(hasName("The Undefeated", "AlsoClean"), "2–0 is unbeaten")
assert_eq(hasName("The Undefeated", "Fallen"), false, "a loss leaves the unbeaten set")
assert_eq(hasName("The Undefeated", "Fodder"), false, "an 0–n record is not unbeaten")
assert_eq(undefeated.entries[1].place, nil, "undefeated entries have no place")
assert_eq(undefeated.entries[1].characterId < undefeated.entries[2].characterId, true,
  "the unbeaten set is id-ordered, not sorted by wins")

--------------------------------------------------------------------------------
-- The Glorious Martyr: most losses. Title is the frame; no generated poetry.
--------------------------------------------------------------------------------
reset()
local martyr = char("Martyralt")
local winner = char("Winner")
local lesser = char("LesserLoss")
bout(martyr, winner, winner, 8000)
bout(martyr, winner, winner, 8001)
bout(martyr, winner, winner, 8002)
bout(lesser, winner, winner, 8003)
local fallen = pageNamed("The Glorious Martyr")
assert_eq(#fallen.entries, 1, "Martyr is a superlative")
assert_eq(fallen.entries[1].name, "Martyralt", "most losses holds the page")
assert_eq(fallen.entries[1].losses, 3, "the measure is losses")
assert_eq(hasName("The Glorious Martyr", "LesserLoss"), false, "fewer losses are not listed")
Book:Show()
-- Flip to the martyr leaf by walking titles, not by inventing a jump API.
local hops = 0
while frame.PageTitle:GetText() ~= "The Glorious Martyr" and hops < 12 do
  local nextBtn = buttonFor("Next")
  assert_true(nextBtn ~= nil, "parchment has a Next leaf control")
  stub.fire(nextBtn, "OnClick")
  hops = hops + 1
end
assert_eq(frame.PageTitle:GetText(), "The Glorious Martyr", "the martyr leaf can be opened")
local body = frame.Body:GetText() or ""
assert_true(body:find("Martyralt", 1, true) ~= nil, "the martyr leaf names the holder")
assert_eq(body:find("fallen", 1, true), nil, "no generated 'fallen' poetry")
assert_eq(body:find("risen", 1, true), nil, "no generated 'risen' poetry")
assert_eq(body:find("Goldshire", 1, true), nil, "no invented location flavor")
assert_eq(body:find("lol", 1, true), nil, "the UI does not tell jokes")

--------------------------------------------------------------------------------
-- Tournament Champions stays empty. No invented engine.
--------------------------------------------------------------------------------
reset()
char("Champish")
assert_eq(#pageNamed("Tournament Champions").entries, 0, "a character does not mint a tournament")
assert_eq(Book.AddTournamentChampion, nil, "still no tournament writer")

--------------------------------------------------------------------------------
-- GetPages returns copies. Show / Hide do not write the Store.
--------------------------------------------------------------------------------
reset()
local p = char("Copy")
local q = char("Mut")
bout(p, q, p, 9000)
local snapBefore = Store:Snapshot()
local leaf = Book:GetPages()
leaf[1].title = "hacked"
leaf[1].entries[1] = { name = "forged", wins = 99, place = 1 }
assert_eq(pageNamed("Most Sanctioned Victories").title, "Most Sanctioned Victories",
  "mutating a GetPages copy does not rewrite the book")
assert_eq(pageNamed("Most Sanctioned Victories").entries[1].name, "Copy",
  "mutating an entry copy does not rewrite the holder")
Book:Show()
Book:Hide()
Book:Toggle()
Book:Toggle()
local snapAfter = Store:Snapshot()
assert_eq(snapAfter.characters[1].gora.wins, snapBefore.characters[1].gora.wins,
  "opening the book does not write Gora wins")
assert_eq(#snapAfter.characters[1].gora.results, #snapBefore.characters[1].gora.results,
  "opening the book does not append results")
assert_eq(snapAfter.nextCharacterId, snapBefore.nextCharacterId, "opening the book does not mint ids")
assert_eq(sounds, 0, "copy / paint path stays silent")

--------------------------------------------------------------------------------
-- History is never deleted: a tombstoned character still holds a record.
--------------------------------------------------------------------------------
reset()
local stay = char("Stayalt")
local foe = char("Foe")
bout(stay, foe, stay, 9100)
Store:TombstoneCharacter(stay.id, 9101)
assert_eq(Store:GetCharacter(stay.id).inactive, true, "character is inactive")
assert_eq(pageNamed("Most Sanctioned Victories").entries[1].name, "Stayalt",
  "a tombstone does not drop the record")

--------------------------------------------------------------------------------
-- Painted chrome stays ecclesiastical and silent. Prev/Next turn leaves, not ranks.
--------------------------------------------------------------------------------
reset()
local leafA = char("LeafA")
local leafB = char("LeafB")
bout(leafA, leafB, leafA, 9200)
Book:Show()
assert_eq(frame.TitleText:GetText(), "The Records Book", "title stays the book name while open")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "open book starts on the first leaf")
local bodyOpen = frame.Body:GetText() or ""
assert_true(bodyOpen:find("LeafA", 1, true) ~= nil, "the open leaf names the holder")
assert_eq(bodyOpen:find("#1", 1, true), nil, "painted copy has no #1 rating")
assert_eq(bodyOpen:find("standing", 1, true), nil, "painted copy has no standing")
assert_eq(bodyOpen:find("Grant", 1, true), nil, "painted copy has no Grant")
assert_eq(bodyOpen:find("points", 1, true), nil, "painted copy has no points")
local prevBtn = buttonFor("Previous")
local nextBtn = buttonFor("Next")
assert_true(prevBtn ~= nil, "Previous leaf control exists")
assert_true(nextBtn ~= nil, "Next leaf control exists")
stub.fire(nextBtn, "OnClick")
assert_eq(frame.PageTitle:GetText(), "Longest Streak", "Next turns the leaf")
stub.fire(prevBtn, "OnClick")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "Previous turns the leaf back")
assert_eq(sounds, 0, "leaf turns play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "leaf turns install no OnUpdate")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness.
--------------------------------------------------------------------------------
reset()
Book:Show()
ChurchOfBeef._IN_TEST = false
assert_eq(Book:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Book:IsShown(), true, "out-of-harness reset does not hide the book")
ChurchOfBeef._IN_TEST = true
assert_eq(Book:ResetForTests(), true, "ResetForTests returns under _IN_TEST")
assert_eq(Book:IsShown(), false, "harness reset closes the book")

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
