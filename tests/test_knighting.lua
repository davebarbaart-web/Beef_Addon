-- Knighting + Lord elevation (Phase 4 Lane D). Isolated: Common + Ranks + Store + Knighting.
-- Church record only. No TOC / bootstrap / run.lua / Store / Runtime / Gora / Officer / UI / Net.
-- No GuildPromote / SetGuildRank. No queue, fairness, Prophet, demote, or Butcher/Council rite.
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
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Knighting.lua")

local COB = ChurchOfBeef
local Store = COB.Store
local Ranks = COB.Ranks
local Knighting = COB.Knighting

local promoteCalls = 0
local frameCalls = 0
local riteCalls = 0

GuildPromote = function()
  promoteCalls = promoteCalls + 1
end
SetGuildRank = function()
  promoteCalls = promoteCalls + 1
end
GuildSetLeader = function()
  promoteCalls = promoteCalls + 1
end
CreateFrame = function()
  frameCalls = frameCalls + 1
end

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  promoteCalls = 0
  frameCalls = 0
  riteCalls = 0
end

local function seed(name)
  return Store:CreateHuman({ name = name or "Steve" }, 1000)
end

--------------------------------------------------------------------------------
-- Isolated surface: Common + Ranks + Store + Knighting. Not Runtime, not UI.
--------------------------------------------------------------------------------
assert_true(Knighting ~= nil, "COB.Knighting exists")
assert_true(Store ~= nil, "isolated suite loads Store")
assert_true(Ranks ~= nil, "isolated suite loads Ranks")
assert_true(COB.Names ~= nil, "Common name law is loaded")
if standalone then
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Roster, nil, "isolated suite does not load Roster")
end

assert_eq(type(Knighting.KnightThisBeef), "function", "KnightThisBeef is the knighting verb")
assert_eq(type(Knighting.ElevateToLord), "function", "ElevateToLord is the Lord verb")

assert_eq(Ranks.ById[3].title, "Beef Knight", "id 3 is Beef Knight")
assert_eq(Ranks.ById[4].title, "Beef Lord", "id 4 is Beef Lord")
assert_eq(Ranks.ById[5].title, "Beef Butcher", "id 5 is Beef Butcher")
assert_eq(Ranks.ById[6].title, "Beef Council", "id 6 is Beef Council")
assert_eq(Ranks.ById[7], nil, "no Prophet rank id")

--------------------------------------------------------------------------------
-- KnightThisBeef writes Church rank 3. Guild promote is later UI.
--------------------------------------------------------------------------------
reset()
local steve = seed("Steve")
assert_eq(steve.rankId, nil, "new human has no rank until the Pope knights")

local knighted, knightErr = Knighting:KnightThisBeef(steve.id, 2000)
assert_true(knighted ~= nil, "KnightThisBeef returns the human row")
assert_eq(knightErr, nil, "successful knighting has no error")
assert_eq(knighted.rankId, 3, "KnightThisBeef writes rank id 3")
assert_eq(Ranks.Title(knighted.rankId), "Beef Knight", "the Church record is Beef Knight")
assert_eq(Store:GetHuman(steve.id).rankId, 3, "the Pope store holds Beef Knight")
assert_eq(Store:GetHuman(steve.id).elevationAt, nil, "knighting does not write elevationAt")
assert_eq(#Store:GetCeremonyLog(), 0, "KnightThisBeef does not append ceremony narration")
assert_eq(#Store:GetHuman(steve.id).honorifics, 0, "knighting does not invent an honorific")
assert_eq(Store:GetHuman(steve.id).council, false, "knighting does not set Council")
assert_eq(promoteCalls, 0, "KnightThisBeef does not call GuildPromote or SetGuildRank")
assert_eq(frameCalls, 0, "KnightThisBeef does not CreateFrame")

local live = Store:GetHuman(steve.id)
live.rankId = 4
assert_eq(Store:GetHuman(steve.id).rankId, 3, "mutating a store copy does not change the knighting")
knighted.rankId = 1
assert_eq(Store:GetHuman(steve.id).rankId, 3, "mutating the verb copy does not change the store")

local again = Knighting:KnightThisBeef(steve.id, 2001)
assert_eq(again.rankId, 3, "knighting a Knight stays Beef Knight")
assert_eq(again.elevationAt, nil, "a second knighting still does not elevate")

--------------------------------------------------------------------------------
-- Refuse unknown humans and non-id keys. Names.Key is not a human.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local missing, missingErr = Knighting:KnightThisBeef(99, 2100)
assert_eq(missing, nil, "KnightThisBeef refuses an unknown human")
assert_true(type(missingErr) == "string", "unknown human returns an error string")
assert_eq(Store:GetHuman(99), nil, "refused knighting does not invent a human")

local named, namedErr = Knighting:KnightThisBeef("Steve", 2101)
assert_eq(named, nil, "KnightThisBeef refuses a name string")
assert_true(type(namedErr) == "string", "name-string knighting returns an error string")

local keyed, keyedErr = Knighting:KnightThisBeef(COB.Names.Key("Steve"), 2102)
assert_eq(keyed, nil, "Names.Key is not a human id")
assert_true(type(keyedErr) == "string", "Names.Key knighting returns an error string")

local zero, zeroErr = Knighting:KnightThisBeef(0, 2103)
assert_eq(zero, nil, "KnightThisBeef refuses human id 0")
assert_true(type(zeroErr) == "string", "human id 0 returns an error string")

local none, noneErr = Knighting:KnightThisBeef(nil, 2104)
assert_eq(none, nil, "KnightThisBeef refuses a missing human id")
assert_true(type(noneErr) == "string", "missing human id returns an error string")

assert_eq(Store:GetHuman(steve.id).rankId, nil, "refused knightings leave the known human unchanged")

--------------------------------------------------------------------------------
-- Do not knight to Lord. Do not auto-advance a queue. Do not OpenRite / EndEvent.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local cooked = Store:CreateHuman({ name = "Cooked" }, 2200)
Store:SetRank(cooked.id, 2, 2201)

COB.Runtime = {
  OpenRite = function()
    riteCalls = riteCalls + 1
  end,
  EndEvent = function()
    riteCalls = riteCalls + 1
  end,
  CloseRite = function()
    riteCalls = riteCalls + 1
  end,
  Continue = function()
    riteCalls = riteCalls + 1
  end,
}

local first = Knighting:KnightThisBeef(steve.id, 2300)
local second = Knighting:KnightThisBeef(cooked.id, 2301)
assert_eq(first.rankId, 3, "first knighting is Beef Knight")
assert_eq(second.rankId, 3, "second knighting is Beef Knight")
assert_eq(first.rankId ~= 4, true, "KnightThisBeef does not write Lord")
assert_eq(Store:GetHuman(steve.id).rankId, 3, "first candidate is not elevated to Lord")
assert_eq(Store:GetHuman(cooked.id).rankId, 3, "Cooked Beef is knighted, not made Lord")
assert_eq(riteCalls, 0, "KnightThisBeef does not call Runtime verbs")
assert_eq(Knighting.queue, nil, "no knighting queue")
assert_eq(Knighting.next, nil, "no next-candidate pointer")
assert_eq(Knighting.AdvanceQueue, nil, "no queue auto-advance")
assert_eq(Knighting.NextCandidate, nil, "no NextCandidate")
assert_eq(Knighting.OpenRite, nil, "no OpenRite on Knighting")
assert_eq(Knighting.EndEvent, nil, "no EndEvent on Knighting")
assert_eq(Knighting.CloseRite, nil, "no CloseRite on Knighting")
COB.Runtime = nil

--------------------------------------------------------------------------------
-- ElevateToLord writes rank 4. Fairness is the Pope's; this lane does not compute it.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
Store:SetRank(steve.id, 3, 2400)
local lord, lordErr = Knighting:ElevateToLord(steve.id, 2500)
assert_true(lord ~= nil, "ElevateToLord returns the human row")
assert_eq(lordErr, nil, "successful elevation has no error")
assert_eq(lord.rankId, 4, "ElevateToLord writes rank id 4")
assert_eq(Ranks.Title(lord.rankId), "Beef Lord", "the Church record is Beef Lord")
assert_eq(Store:GetHuman(steve.id).rankId, 4, "the Pope store holds Beef Lord")
assert_eq(lord.elevationAt, 2500, "first Lord elevationAt comes from Store")
assert_eq(Store:GetHuman(steve.id).elevationAt, 2500, "Store keeps the first elevationAt")
assert_eq(#Store:GetCeremonyLog(), 0, "ElevateToLord does not append ceremony narration")
assert_eq(promoteCalls, 0, "ElevateToLord does not call GuildPromote or SetGuildRank")
assert_eq(frameCalls, 0, "ElevateToLord does not CreateFrame")

local stillLord = Knighting:ElevateToLord(steve.id, 2501)
assert_eq(stillLord.rankId, 4, "elevating a Lord stays Beef Lord")
assert_eq(stillLord.elevationAt, 2500, "a second Lord write does not overwrite elevationAt")

--------------------------------------------------------------------------------
-- ElevateToLord refuses unknown humans. Does not compute fairness or pairing.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local missLord, missLordErr = Knighting:ElevateToLord(99, 2600)
assert_eq(missLord, nil, "ElevateToLord refuses an unknown human")
assert_true(type(missLordErr) == "string", "unknown human elevation returns an error string")

local nameLord, nameLordErr = Knighting:ElevateToLord("Steve", 2601)
assert_eq(nameLord, nil, "ElevateToLord refuses a name string")
assert_true(type(nameLordErr) == "string", "name-string elevation returns an error string")

local freshLord = Knighting:ElevateToLord(steve.id, 2602)
assert_eq(freshLord.rankId, 4, "the Pope may elevate without a fairness score")
assert_eq(Store:GetHuman(steve.id).elevationAt, 2602, "first elevationAt is still from Store")
assert_eq(Knighting.IsFair, nil, "no fairness predicate")
assert_eq(Knighting.JudgeFair, nil, "no fairness judge")
assert_eq(Knighting.ComputeFairness, nil, "no fairness computation")
assert_eq(Knighting.Pair, nil, "no pairing")
assert_eq(Knighting.Match, nil, "no matchmaking")
assert_eq(Knighting.CountDefense, nil, "no defense counter")
assert_eq(Knighting.RecordDefense, nil, "no defense write")

--------------------------------------------------------------------------------
-- Elevation is not automatic after a Gora win. KnightThisBeef is not elevation.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local chuck = Store:CreateCharacter({ name = "Chuckroast" }, 2700)
local tender = Store:CreateCharacter({ name = "Tendermage" }, 2701)
Store:LinkCharacter(chuck.id, steve.id, 2702)
Knighting:KnightThisBeef(steve.id, 2703)
assert_eq(Store:GetHuman(steve.id).rankId, 3, "the fighter is a Beef Knight")

local win = Store:RecordGoraResult(chuck.id, {
  opponentId = tender.id,
  ruling = "victor",
  won = true,
}, 2704)
assert_true(win ~= nil, "a sanctioned Gora result can be recorded")
assert_eq(Store:GetHuman(steve.id).rankId, 3, "a Gora win does not auto-elevate")
assert_eq(Store:GetHuman(steve.id).elevationAt, nil, "a Gora win does not write elevationAt")

local stillKnight = Knighting:KnightThisBeef(steve.id, 2705)
assert_eq(stillKnight.rankId, 3, "KnightThisBeef after a win is still Beef Knight")
assert_eq(stillKnight.rankId ~= 4, true, "do not knight to Lord")
assert_eq(Store:GetHuman(steve.id).elevationAt, nil, "knighting after a win is not elevation")

local elevated = Knighting:ElevateToLord(steve.id, 2706)
assert_eq(elevated.rankId, 4, "elevation is its own Pope verb")
assert_eq(elevated.elevationAt, 2706, "first Lord timestamp is the elevation verb, not the win")

--------------------------------------------------------------------------------
-- elevationAt uses COB.Clock when now is omitted
--------------------------------------------------------------------------------
reset()
local clocked = seed("Clocked")
Store:SetRank(clocked.id, 3)
local savedWall = COB.Clock.Wall
COB.Clock.Wall = function(now)
  if type(now) == "number" then return now end
  return 55555
end
Knighting:ElevateToLord(clocked.id)
assert_eq(Store:GetHuman(clocked.id).elevationAt, 55555, "ElevateToLord uses Store's clock for first Lord")
COB.Clock.Wall = savedWall

--------------------------------------------------------------------------------
-- Do not invent Prophet. Do not demote. Butcher / Council are not this rite.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
assert_eq(Knighting.Demote, nil, "no Demote")
assert_eq(Knighting.DemoteHuman, nil, "no DemoteHuman")
assert_eq(Knighting.SetRank, nil, "Knighting is not a generic SetRank")
assert_eq(Knighting.Prophet, nil, "no Prophet")
assert_eq(Knighting.ElevateToProphet, nil, "no ElevateToProphet")
assert_eq(Knighting.ElevateToButcher, nil, "Butcher is not this rite")
assert_eq(Knighting.SetButcher, nil, "no SetButcher")
assert_eq(Knighting.ElevateToCouncil, nil, "Council is not this rite")
assert_eq(Knighting.SetCouncil, nil, "no SetCouncil on Knighting")
assert_eq(Knighting.Grant, nil, "no Grant")
assert_eq(Knighting.AddPoints, nil, "no points")
assert_eq(Knighting.OpenConsole, nil, "no Director Console")
assert_eq(Knighting.Proclaim, nil, "no proclamation text")
assert_eq(Knighting.Narrate, nil, "no narration")
assert_eq(Knighting.RegisterPope, nil, "no #8 Pope list")
assert_eq(Knighting.GuildRankFor, nil, "no guild-index map")
assert_eq(Knighting.ChurchRankIdForGuildIndex, nil, "no guild-index map on Knighting")
assert_eq(Knighting.CreateFrame, nil, "Core does not CreateFrame")

local knightRow = Knighting:KnightThisBeef(steve.id, 2800)
assert_eq(knightRow.rankId, 3, "the knighting rite writes Knight, not Butcher or Council")
assert_eq(knightRow.rankId ~= 5, true, "KnightThisBeef does not write Butcher")
assert_eq(knightRow.rankId ~= 6, true, "KnightThisBeef does not write Council")
assert_eq(knightRow.rankId ~= 7, true, "KnightThisBeef does not invent Prophet")

local lordRow = Knighting:ElevateToLord(steve.id, 2801)
assert_eq(lordRow.rankId, 4, "the elevation rite writes Lord, not Butcher or Council")
assert_eq(lordRow.rankId ~= 5, true, "ElevateToLord does not write Butcher")
assert_eq(lordRow.rankId ~= 6, true, "ElevateToLord does not write Council")
assert_eq(lordRow.rankId ~= 3, true, "ElevateToLord is not a knighting")
assert_eq(promoteCalls, 0, "neither verb performs a protected guild-rank write")
assert_eq(frameCalls, 0, "neither verb creates a frame")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
