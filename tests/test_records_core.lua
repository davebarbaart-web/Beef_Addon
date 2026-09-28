ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed, failed = 0, 0
if standalone then
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

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Records.lua")

local COB = ChurchOfBeef
local Store = COB.Store
local Records = COB.Records

local TITLES = {
  "Most Sanctioned Victories", "Longest Streak", "Most Successful Defenses",
  "The Iron Chin", "Greatest Rivalry", "Famous Upsets", "The Undefeated",
  "The Glorious Martyr", "Tournament Champions",
}

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store resets under _IN_TEST")
end

local function pageNamed(title)
  local pages = Records:Pages()
  for i = 1, #pages do
    if pages[i].title == title then return pages[i] end
  end
  return nil
end

local function bout(a, b, winner, now)
  Store:RecordGoraResult(a.id, { opponentId = b.id, ruling = "victor", won = (winner == a) }, now)
  Store:RecordGoraResult(b.id, { opponentId = a.id, ruling = "victor", won = (winner == b) }, now)
end

--------------------------------------------------------------------------------
-- Module contract
--------------------------------------------------------------------------------
assert_true(Records ~= nil, "COB.Records exists")
assert_eq(type(Records.Pages), "function", "Pages()")
assert_eq(type(Records.Summary), "function", "Summary(characterId)")
assert_eq(type(Records.HeldBy), "function", "HeldBy(characterId)")
assert_eq(type(Records.FighterStories), "function", "FighterStories()")
assert_eq(type(Records.VictoryFront), "function", "VictoryFront(limit)")
assert_eq(type(Records.ChroniclePreview), "function", "ChroniclePreview(limit)")
assert_eq(#Records.TITLES, 9, "nine canonical titles")
for i = 1, 9 do
  assert_eq(Records.TITLES[i], TITLES[i], "title " .. i .. " canonical order")
end
assert_eq(Records.Ladder, nil, "no ladder")
assert_eq(Records.Position, nil, "no position among members")
assert_eq(Records.Rank, nil, "no numeric rank")
assert_eq(Records.SortByWins, nil, "no sortable ladder")
assert_eq(Records.Rating, nil, "no rating")
assert_eq(Records.ComputeFamousUpsets, nil, "Famous Upsets are Pope-flagged, never computed")

local src = io.open("addon/ChurchOfBeef/Core/Records.lua", "r")
assert_true(src ~= nil, "Records.lua is readable")
local body = src:read("*a")
src:close()
assert_eq(body:find("CreateFrame", 1, true), nil, "Core never CreateFrame")
assert_eq(body:find("UnitName", 1, true), nil, "Core never reads WoW units")
assert_eq(body:find("SendAddonMessage", 1, true), nil, "Core never sends")
assert_eq(body:lower():find("standing", 1, true), nil, "no standing")
assert_eq(body:lower():find("leaderboard", 1, true), nil, "no leaderboard")

--------------------------------------------------------------------------------
-- Empty store: nine pages, every one empty; Summary refuses; HeldBy empty
--------------------------------------------------------------------------------
reset()
local pages = Records:Pages()
assert_eq(#pages, 9, "nine pages on an empty store")
for i = 1, 9 do
  assert_eq(pages[i].title, TITLES[i], "empty page " .. i .. " keeps its title")
  assert_eq(#pages[i].entries, 0, "empty page " .. i .. " has no entries")
end
local none, err = Records:Summary(1)
assert_eq(none, nil, "Summary of an unknown character is nil")
assert_eq(err, "unknown character", "Summary names the refusal")
local bad, badErr = Records:Summary("x")
assert_eq(bad, nil, "Summary of a non-id is nil")
assert_eq(badErr, "invalid character id", "Summary refuses non-ids")
assert_eq(#Records:HeldBy(1), 0, "HeldBy of an unknown character is empty")

--------------------------------------------------------------------------------
-- Two fighters, A beats B twice
--------------------------------------------------------------------------------
reset()
local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior" })
local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage" })
bout(a, b, a, 100)
bout(a, b, a, 200)

local victories = pageNamed("Most Sanctioned Victories")
assert_eq(#victories.entries, 1, "one victory holder")
assert_eq(victories.entries[1].characterId, a.id, "A holds Most Sanctioned Victories")
assert_eq(victories.entries[1].wins, 2, "with two wins")
assert_eq(pageNamed("Longest Streak").entries[1].streak, 2, "A holds Longest Streak at II")
assert_eq(#pageNamed("Most Successful Defenses").entries, 0, "no Lord, no defenses")
assert_eq(#pageNamed("The Iron Chin").entries, 2, "both fought twice — both hold The Iron Chin")
local rivalry = pageNamed("Greatest Rivalry").entries[1]
assert_eq(rivalry.fights, 2, "the pair fought twice")
assert_eq(rivalry.nameA, "Chuckroast", "rivalry names the lower id first")
assert_eq(rivalry.scoreA, 2, "A's side of the running score")
assert_eq(rivalry.scoreB, 0, "B's side of the running score")
assert_eq(#pageNamed("Famous Upsets").entries, 0, "no flagged upsets")
assert_eq(pageNamed("The Undefeated").entries[1].characterId, a.id, "A is undefeated")
assert_eq(pageNamed("The Glorious Martyr").entries[1].characterId, b.id, "B is the martyr")
assert_eq(#pageNamed("Tournament Champions").entries, 0, "no tournament engine")

local summary = Records:Summary(a.id)
assert_eq(summary.name, "Chuckroast", "Summary names the character")
assert_eq(summary.wins, 2, "Summary wins")
assert_eq(summary.losses, 0, "Summary losses")
assert_eq(summary.fought, 2, "Summary fought")
assert_eq(summary.longestStreak, 2, "Summary longest streak")
assert_eq(summary.defenses, 0, "Summary defenses without a Lord")
assert_eq(#summary.rivalries, 1, "one rival")
assert_eq(summary.rivalries[1].opponentId, b.id, "rival id")
assert_eq(summary.rivalries[1].opponentName, "Tendermage", "rival name")
assert_eq(summary.rivalries[1].wins, 2, "rival wins")
assert_eq(summary.rivalries[1].losses, 0, "rival losses")
assert_eq(summary.rivalries[1].fights, 2, "rival fights")

local heldA = Records:HeldBy(a.id)
assert_eq(table.concat(heldA, "|"),
  "Most Sanctioned Victories|Longest Streak|The Iron Chin|Greatest Rivalry|The Undefeated",
  "A's distinctions in canonical order")
local heldB = Records:HeldBy(b.id)
assert_eq(table.concat(heldB, "|"), "The Iron Chin|Greatest Rivalry|The Glorious Martyr",
  "B's distinctions in canonical order")

--------------------------------------------------------------------------------
-- Rivalries sort by fights desc then name; only the top matter to the card
--------------------------------------------------------------------------------
local c = Store:CreateCharacter({ name = "Brisketh", class = "Rogue" })
bout(a, c, c, 300)
local again = Records:Summary(a.id)
assert_eq(#again.rivalries, 2, "two rivals")
assert_eq(again.rivalries[1].opponentName, "Tendermage", "most-fought rival first")
assert_eq(again.rivalries[2].opponentName, "Brisketh", "then the newer rival")
assert_eq(again.losses, 1, "the loss counts")
assert_eq(again.longestStreak, 2, "longest streak survives the loss")

--------------------------------------------------------------------------------
-- Defenses: a sitting Lord's wins after elevation (OPEN_QUESTIONS #9)
--------------------------------------------------------------------------------
reset()
a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior" })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage" })
local human = Store:CreateHuman({ name = "Chuck" })
Store:LinkCharacter(a.id, human.id, 50)
Store:SetRank(human.id, 4, 100)
bout(a, b, a, 90)   -- before elevation: not a defense
bout(a, b, a, 150)  -- after: a defense
local lord = Records:Summary(a.id)
assert_eq(lord.defenses, 1, "one defense after elevation")
assert_eq(lord.humanId, human.id, "Summary carries the human id")
local defenses = pageNamed("Most Successful Defenses")
assert_eq(defenses.entries[1].characterId, a.id, "A holds Most Successful Defenses")
assert_eq(defenses.entries[1].defenses, 1, "with one defense")

--------------------------------------------------------------------------------
-- Getters return copies
--------------------------------------------------------------------------------
local copy = Records:Summary(a.id)
copy.wins = 99
copy.rivalries[1].wins = 99
assert_eq(Records:Summary(a.id).wins, 2, "mutating Summary does not change the record")
assert_eq(Records:Summary(a.id).rivalries[1].wins, 2, "mutating a rivalry copy does not leak")
local pagesCopy = Records:Pages()
pagesCopy[1].entries = {}
assert_eq(#Records:Pages()[1].entries, 1, "mutating Pages does not change the record")
local heldCopy = Records:HeldBy(a.id)
heldCopy[1] = "Fake"
assert_eq(Records:HeldBy(a.id)[1], "Most Sanctioned Victories", "mutating HeldBy does not leak")

--------------------------------------------------------------------------------
-- FighterStories / VictoryFront: wins, then win run, then recency, then name.
-- Not a rating and not a position among members.
--------------------------------------------------------------------------------
reset()
assert_eq(#Records:FighterStories(), 0, "empty store has no fighter stories")
assert_eq(#Records:VictoryFront(3), 0, "empty store has no victory front")
assert_eq(#Records:ChroniclePreview(2), 0, "empty store has no Chronicle preview")
local ghost = Store:CreateCharacter({ name = "WorldDuelist" })
assert_eq(#Records:FighterStories(), 0, "a character with no sanctioned result is absent")
Store:AppendCeremony("victor", { ghost.id }, 1)
assert_eq(#Records:FighterStories(), 0, "a ceremony line without RecordGoraResult is not a story")

a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior" })
b = Store:CreateCharacter({ name = "Tendermage", class = "Mage" })
bout(a, b, a, 100)
bout(a, b, a, 200)
Store:AppendCeremony("Knighting", { 1 }, 50)
Store:AppendCeremony("victor", { a.id, b.id }, 200)

local stories = Records:FighterStories()
assert_eq(#stories, 2, "both fighters who have a result appear")
assert_eq(stories[1].name, "Chuckroast", "more sanctioned victories read first")
assert_eq(stories[1].wins, 2, "A wins")
assert_eq(stories[1].losses, 0, "A losses")
assert_eq(stories[1].currentStreak, 2, "A current win run")
assert_eq(stories[1].last.opponentName, "Tendermage", "A last opponent")
assert_eq(stories[1].last.won, true, "A last result was a win")
assert_eq(stories[2].name, "Tendermage", "B is in the ledger")
assert_eq(stories[2].wins, 0, "B wins")
assert_eq(stories[2].losses, 2, "B losses")
assert_eq(stories[2].last.won, false, "B last result was a loss")

local later = Store:CreateCharacter({ name = "Brisketh", class = "Rogue" })
bout(a, later, later, 400)
stories = Records:FighterStories()
assert_eq(stories[1].name, "Chuckroast", "two victories still read before one")
assert_eq(stories[1].wins, 2, "A is 2-1 after the loss")
assert_eq(stories[2].name, "Brisketh", "one victory reads next")
assert_eq(stories[2].wins, 1, "Brisketh won the latest")
assert_eq(stories[3].name, "Tendermage", "zero victories read last")

local front = Records:VictoryFront(3)
assert_eq(#front, 3, "VictoryFront caps at three")
assert_eq(front[1].name, stories[1].name, "front 1 matches FighterStories")
assert_eq(front[2].name, stories[2].name, "front 2 matches FighterStories")
assert_eq(front[3].name, stories[3].name, "front 3 matches FighterStories")
assert_eq(#Records:VictoryFront(1), 1, "VictoryFront honors a smaller limit")
assert_eq(Records:VictoryFront(1)[1].name, "Chuckroast", "limit 1 is the first story")
assert_eq(#Records:VictoryFront(0), 3, "non-positive limit falls back to three")
assert_eq(#Records:VictoryFront("x"), 3, "non-numeric limit falls back to three")

local storiesCopy = Records:FighterStories()
storiesCopy[1].wins = 99
assert_eq(Records:FighterStories()[1].wins, 2, "mutating FighterStories does not leak")
local frontCopy = Records:VictoryFront(3)
frontCopy[1].wins = 99
assert_eq(Records:VictoryFront(3)[1].wins, 2, "mutating VictoryFront does not leak")

local preview = Records:ChroniclePreview(2)
assert_eq(#preview, 2, "preview caps at two")
assert_eq(preview[1].kind, "victor", "newest ceremony first")
assert_eq(preview[1].headline, "A VICTOR DECLARED", "clerical victor rubric")
assert_true(preview[1].body:find("declared victor over", 1, true) ~= nil, "factual victor line")
assert_eq(preview[2].kind, "Knighting", "older Knighting is second")
assert_eq(preview[2].headline, "A KNIGHTING", "clerical Knighting rubric")

local moment = Store:FlagMoment("Goldshire", 500)
Store:CanonizeMoment(moment.id, "The sitting is recorded.")
preview = Records:ChroniclePreview(1)
assert_eq(preview[1].kind, "canonized", "Pope scripture is preferred when newer")
assert_eq(preview[1].body, "The sitting is recorded.", "scripture is the Pope's words")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
