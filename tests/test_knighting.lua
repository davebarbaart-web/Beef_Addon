-- Knighting + Lord elevation + memory-only line (B5-A). Isolated: Common + Ranks + Store + Knighting.
-- Church record only. No TOC / bootstrap / run.lua / Store / Runtime / Gora / Officer / UI / Net.
-- No GuildPromote / SetGuildRank. No queue / AdvanceQueue, fairness, Prophet, demote, or Butcher/Council rite.
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
local savedRuntimeForIsolation = COB.Runtime
COB.Runtime = nil

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
  assert_eq(Knighting:ResetForTests(), true, "Knighting ResetForTests runs under _IN_TEST")
  promoteCalls = 0
  frameCalls = 0
  riteCalls = 0
end

local function seed(name)
  return Store:CreateHuman({ name = name or "Steve" }, 1000)
end

local function lineHas(humanId)
  local rows = Knighting:GetLine()
  for i = 1, #rows do
    if rows[i].humanId == humanId then return true end
  end
  return false
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
assert_eq(type(Knighting.Enqueue), "function", "Enqueue appends to the line")
assert_eq(type(Knighting.Insert), "function", "Insert is the latecomer append")
assert_eq(type(Knighting.Skip), "function", "Skip removes without knighting")
assert_eq(type(Knighting.GetLine), "function", "GetLine copies the line")
assert_eq(type(Knighting.ResetForTests), "function", "ResetForTests wipes the line")
assert_eq(Knighting.line, nil, "line is not a public field")
assert_eq(Knighting.GetQueue, nil, "no GetQueue — the getter is GetLine")

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
assert_eq(#Store:GetCeremonyLog(), 1, "successful KnightThisBeef appends one ceremony row")
assert_eq(Store:GetCeremonyLog()[1].type, "Knighting", "knighting log type is Knighting")
assert_eq(Store:GetCeremonyLog()[1].participantIds[1], steve.id, "knighting log names the human")
assert_eq(#Store:GetCeremonyLog()[1].participantIds, 1, "knighting log has one participant")
assert_eq(Store:GetCeremonyLog()[1].at, 2000, "knighting log uses the verb now")
assert_eq(Store:GetCeremonyLog()[1].text, nil, "knighting log has no text")
assert_eq(Store:GetCeremonyLog()[1].scripture, nil, "knighting log has no scripture")
assert_eq(Store:GetCeremonyLog()[1].narration, nil, "knighting log has no narration")
assert_eq(Store:GetCeremonyLog()[1].eventId, nil, "knighting without a live event stores no event id")
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
assert_eq(#Store:GetCeremonyLog(), 2, "re-knight appends again")
assert_eq(Store:GetCeremonyLog()[2].type, "Knighting", "re-knight type is still Knighting")
assert_eq(Store:GetCeremonyLog()[2].at, 2001, "re-knight uses the second now")
assert_eq(Store:GetCeremonyLog()[2].text, nil, "re-knight has no text")

again = Knighting:ElevateToLord(steve.id, 2002)
assert_eq(again.rankId, 4, "ElevateToLord still writes Beef Lord")
assert_eq(Store:GetHuman(steve.id).rankId, 4, "the Pope store holds Beef Lord after elevation")
assert_eq(Store:GetHuman(steve.id).elevationAt, 2002, "first elevationAt is the elevation verb")
assert_eq(#Store:GetCeremonyLog(), 3, "elevation appends after the two knightings")

knighted, knightErr = Knighting:KnightThisBeef(steve.id, 2003)
assert_eq(knighted, nil, "KnightThisBeef refuses a Lord")
assert_eq(knightErr, "already elevated", "Lord knighting names already elevated")
assert_eq(Store:GetHuman(steve.id).rankId, 4, "refused knighting does not demote a Lord")
assert_eq(Store:GetHuman(steve.id).elevationAt, 2002, "refused knighting does not change elevationAt")
assert_eq(#Store:GetCeremonyLog(), 3, "refused Lord knighting does not append")
assert_eq(#Knighting:GetLine(), 0, "refused Lord knighting does not dequeue")
assert_eq(promoteCalls, 0, "refused Lord knighting does not GuildPromote")

do
  local lined = Store:CreateHuman({ name = "Lined" }, 2004)
  Knighting:Enqueue(lined.id)
  Store:SetRank(lined.id, 4, 2005)
  assert_eq(#Knighting:GetLine(), 1, "a Store-written Lord can still sit on the line")
  assert_eq(lineHas(lined.id), true, "GetLine still lists that Store-written Lord")
  local row, err = Knighting:KnightThisBeef(lined.id, 2006)
  assert_eq(row, nil, "KnightThisBeef refuses a Lord still on the line")
  assert_eq(err, "already elevated", "on-line Lord knighting names already elevated")
  assert_eq(#Knighting:GetLine(), 1, "refused knighting leaves the line unchanged")
  assert_eq(lineHas(lined.id), true, "refused knighting does not dequeue a Lord")
  assert_eq(Store:GetHuman(lined.id).rankId, 4, "on-line refuse does not demote")
  assert_eq(Store:GetHuman(lined.id).elevationAt, 2005, "on-line refuse does not change elevationAt")
  assert_eq(#Store:GetCeremonyLog(), 3, "on-line refuse does not append")
  assert_eq(promoteCalls, 0, "on-line refuse does not GuildPromote")
end

--------------------------------------------------------------------------------
-- Refuse unknown humans and non-id keys. Names.Key is not a human.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local missing, missingErr = Knighting:KnightThisBeef(99, 2100)
assert_eq(missing, nil, "KnightThisBeef refuses an unknown human")
assert_true(type(missingErr) == "string", "unknown human returns an error string")
assert_eq(Store:GetHuman(99), nil, "refused knighting does not invent a human")
assert_eq(#Store:GetCeremonyLog(), 0, "unknown human leaves the ceremony log unchanged")

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
assert_eq(#Store:GetCeremonyLog(), 0, "refused knightings do not append")

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
assert_eq(#Store:GetCeremonyLog(), 1, "successful ElevateToLord appends one ceremony row")
assert_eq(Store:GetCeremonyLog()[1].type, "Elevation", "elevation log type is Elevation")
assert_eq(Store:GetCeremonyLog()[1].participantIds[1], steve.id, "elevation log names the human")
assert_eq(#Store:GetCeremonyLog()[1].participantIds, 1, "elevation log has one participant")
assert_eq(Store:GetCeremonyLog()[1].at, 2500, "elevation log uses the verb now")
assert_eq(Store:GetCeremonyLog()[1].text, nil, "elevation log has no text")
assert_eq(Store:GetCeremonyLog()[1].scripture, nil, "elevation log has no scripture")
assert_eq(Store:GetCeremonyLog()[1].narration, nil, "elevation log has no narration")
assert_eq(promoteCalls, 0, "ElevateToLord does not call GuildPromote or SetGuildRank")
assert_eq(frameCalls, 0, "ElevateToLord does not CreateFrame")

local stillLord = Knighting:ElevateToLord(steve.id, 2501)
assert_eq(stillLord.rankId, 4, "elevating a Lord stays Beef Lord")
assert_eq(stillLord.elevationAt, 2500, "a second Lord write does not overwrite elevationAt")
assert_eq(#Store:GetCeremonyLog(), 2, "re-elevate appends again")
assert_eq(Store:GetCeremonyLog()[2].type, "Elevation", "re-elevate type is still Elevation")
assert_eq(Store:GetCeremonyLog()[2].at, 2501, "re-elevate uses the second now")
assert_eq(Store:GetCeremonyLog()[2].text, nil, "re-elevate has no text")

local cookedLord = Store:CreateHuman({ name = "CookedLord" }, 2502)
Store:SetRank(cookedLord.id, 2, 2503)
local cookedElev = Knighting:ElevateToLord(cookedLord.id, 2504)
assert_eq(cookedElev.rankId, 4, "ElevateToLord still writes Lord from Cooked Beef")
assert_eq(Store:GetHuman(cookedLord.id).rankId, 4, "Cooked Beef elevation is Beef Lord")
assert_eq(Store:GetHuman(cookedLord.id).elevationAt, 2504, "Cooked elevationAt is the elevation verb")

--------------------------------------------------------------------------------
-- ElevateToLord refuses unknown humans. Does not compute fairness or pairing.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local missLord, missLordErr = Knighting:ElevateToLord(99, 2600)
assert_eq(missLord, nil, "ElevateToLord refuses an unknown human")
assert_true(type(missLordErr) == "string", "unknown human elevation returns an error string")
assert_eq(#Store:GetCeremonyLog(), 0, "unknown elevation leaves the ceremony log unchanged")

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

--------------------------------------------------------------------------------
-- Memory-only line. Isolated suite: Runtime missing → Enqueue still works.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local cooked = Store:CreateHuman({ name = "Cooked" }, 2900)
Store:SetRank(cooked.id, 2, 2901)
local fresh = Store:CreateHuman({ name = "Fresh" }, 2902)
Store:SetRank(fresh.id, 1, 2903)

assert_eq(COB.Runtime, nil, "line tests start with Runtime unloaded")
assert_eq(#Knighting:GetLine(), 0, "the line starts empty")

local enq, enqErr = Knighting:Enqueue(steve.id)
assert_true(enq ~= nil, "Enqueue without Runtime is accepted")
assert_eq(enqErr, nil, "successful Enqueue has no error")
assert_eq(enq.humanId, steve.id, "Enqueue row is that human")
assert_eq(enq.rankId, nil, "unenrolled Enqueue shows nil rank")
assert_eq(Store:GetHuman(steve.id).rankId, nil, "Enqueue does not knight")
assert_eq(riteCalls, 0, "Enqueue does not call Runtime verbs")

local cookedRow, cookedErr = Knighting:Enqueue(cooked.id)
assert_true(cookedRow ~= nil, "Cooked Beef may enter the line")
assert_eq(cookedErr, nil, "Cooked Enqueue has no error")
assert_eq(cookedRow.rankId, 2, "Cooked Enqueue shows rank 2")

local freshRow, freshErr = Knighting:Enqueue(fresh.id)
assert_true(freshRow ~= nil, "Fresh Beef may enter the line")
assert_eq(freshErr, nil, "Fresh Enqueue has no error")
assert_eq(freshRow.rankId, 1, "Fresh Enqueue shows rank 1")

local ordered = Knighting:GetLine()
assert_eq(#ordered, 3, "three Enqueues are three rows")
assert_eq(ordered[1].humanId, steve.id, "GetLine is oldest-first")
assert_eq(ordered[2].humanId, cooked.id, "second Enqueue stays second")
assert_eq(ordered[3].humanId, fresh.id, "third Enqueue is newest")

local copyLine = Knighting:GetLine()[1]
copyLine.humanId = 0
copyLine.rankId = 9
assert_eq(Knighting:GetLine()[1].humanId, steve.id, "mutating a GetLine copy does not rewrite the line")
assert_eq(Knighting:GetLine()[1].rankId, nil, "mutating a GetLine copy does not rewrite rank")

Store:SetRank(steve.id, 2, 2904)
assert_eq(Knighting:GetLine()[1].rankId, 2, "GetLine reads the current store rank")

local againEnq, againEnqErr = Knighting:Enqueue(steve.id)
assert_true(againEnq ~= nil, "Enqueue of someone already in line is a no-op success")
assert_eq(againEnqErr, nil, "already-in-line Enqueue has no error")
assert_eq(#Knighting:GetLine(), 3, "already-in-line Enqueue does not duplicate")
assert_eq(Knighting:GetLine()[1].humanId, steve.id, "already-in-line Enqueue does not reorder")

--------------------------------------------------------------------------------
-- Insert is a latecomer append. Already-in-line is a no-op success.
--------------------------------------------------------------------------------
local late = Store:CreateHuman({ name = "Latecomer" }, 2910)
local ins, insErr = Knighting:Insert(late.id)
assert_true(ins ~= nil, "Insert appends a latecomer")
assert_eq(insErr, nil, "successful Insert has no error")
assert_eq(ins.humanId, late.id, "Insert row is the latecomer")
assert_eq(#Knighting:GetLine(), 4, "Insert appends a fourth row")
assert_eq(Knighting:GetLine()[4].humanId, late.id, "Insert does not reorder earlier arrivals")
assert_eq(Knighting:GetLine()[1].humanId, steve.id, "Insert leaves the oldest first")

local insAgain, insAgainErr = Knighting:Insert(cooked.id)
assert_true(insAgain ~= nil, "Insert of someone already in line is a no-op success")
assert_eq(insAgainErr, nil, "already-in-line Insert has no error")
assert_eq(insAgain.humanId, cooked.id, "already-in-line Insert returns that human")
assert_eq(#Knighting:GetLine(), 4, "already-in-line Insert does not duplicate")
assert_eq(Knighting:GetLine()[2].humanId, cooked.id, "already-in-line Insert does not reorder")

--------------------------------------------------------------------------------
-- Skip removes without knighting. Unknown / non-human ids refuse.
--------------------------------------------------------------------------------
local skipped, skipErr = Knighting:Skip(cooked.id)
assert_true(skipped ~= nil, "Skip removes that human")
assert_eq(skipErr, nil, "successful Skip has no error")
assert_eq(skipped.humanId, cooked.id, "Skip returns the removed row")
assert_eq(Store:GetHuman(cooked.id).rankId, 2, "Skip does not knight")
assert_eq(#Knighting:GetLine(), 3, "Skip leaves the others")
assert_eq(Knighting:GetLine()[1].humanId, steve.id, "Skip does not reorder the remainder")
assert_eq(Knighting:GetLine()[2].humanId, fresh.id, "after Skip the next oldest moves up")
assert_eq(Knighting:GetLine()[3].humanId, late.id, "the latecomer stays last")

local skipGone, skipGoneErr = Knighting:Skip(cooked.id)
assert_eq(skipGone, nil, "Skip of someone not in line is refused")
assert_eq(skipGoneErr, "not in line", "absent Skip names not in line")

local missEnq, missEnqErr = Knighting:Enqueue(99)
assert_eq(missEnq, nil, "Enqueue refuses an unknown human")
assert_true(type(missEnqErr) == "string", "unknown Enqueue returns an error string")

local nameEnq, nameEnqErr = Knighting:Enqueue("Steve")
assert_eq(nameEnq, nil, "Enqueue refuses a name string")
assert_true(type(nameEnqErr) == "string", "name-string Enqueue returns an error string")

local keyEnq, keyEnqErr = Knighting:Enqueue(COB.Names.Key("Steve"))
assert_eq(keyEnq, nil, "Names.Key is not a human id for Enqueue")
assert_true(type(keyEnqErr) == "string", "Names.Key Enqueue returns an error string")

local zeroEnq, zeroEnqErr = Knighting:Enqueue(0)
assert_eq(zeroEnq, nil, "Enqueue refuses human id 0")
assert_true(type(zeroEnqErr) == "string", "human id 0 Enqueue returns an error string")

local noneEnq, noneEnqErr = Knighting:Enqueue(nil)
assert_eq(noneEnq, nil, "Enqueue refuses a missing human id")
assert_true(type(noneEnqErr) == "string", "missing human id Enqueue returns an error string")

local missIns, missInsErr = Knighting:Insert(99)
assert_eq(missIns, nil, "Insert refuses an unknown human")
assert_true(type(missInsErr) == "string", "unknown Insert returns an error string")

local missSkip, missSkipErr = Knighting:Skip(99)
assert_eq(missSkip, nil, "Skip refuses an unknown human")
assert_true(type(missSkipErr) == "string", "unknown Skip returns an error string")

local ch = Store:CreateCharacter({ name = "Chuckroast" }, 2920)
while Store:GetHuman(ch.id) do
  ch = Store:CreateCharacter({ name = "Alt-" .. tostring(ch.id) }, 2920)
end
local chEnq, chEnqErr = Knighting:Enqueue(ch.id)
assert_eq(chEnq, nil, "Enqueue refuses a character id that is not a human")
assert_true(type(chEnqErr) == "string", "non-human Enqueue returns an error string")
assert_eq(#Knighting:GetLine(), 3, "refused Enqueues do not grow the line")

--------------------------------------------------------------------------------
-- Rank 3+ refuses already knighted. Successful ElevateToLord removes that human.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local knightedHuman = Store:CreateHuman({ name = "AlreadyKnight" }, 3000)
Store:SetRank(knightedHuman.id, 3, 3001)
local lordHuman = Store:CreateHuman({ name = "AlreadyLord" }, 3002)
Store:SetRank(lordHuman.id, 4, 3003)
local butcherHuman = Store:CreateHuman({ name = "Butcher" }, 3004)
Store:SetRank(butcherHuman.id, 5, 3005)
local councilHuman = Store:CreateHuman({ name = "Council" }, 3006)
Store:SetRank(councilHuman.id, 6, 3007)

local knEnq, knEnqErr = Knighting:Enqueue(knightedHuman.id)
assert_eq(knEnq, nil, "Enqueue refuses a Beef Knight")
assert_eq(knEnqErr, "already knighted", "Knight Enqueue names already knighted")

local lordEnq, lordEnqErr = Knighting:Enqueue(lordHuman.id)
assert_eq(lordEnq, nil, "Enqueue refuses a Beef Lord")
assert_eq(lordEnqErr, "already knighted", "Lord Enqueue names already knighted")

local butEnq, butEnqErr = Knighting:Insert(butcherHuman.id)
assert_eq(butEnq, nil, "Insert refuses a Beef Butcher")
assert_eq(butEnqErr, "already knighted", "Butcher Insert names already knighted")

local coEnq, coEnqErr = Knighting:Enqueue(councilHuman.id)
assert_eq(coEnq, nil, "Enqueue refuses Beef Council")
assert_eq(coEnqErr, "already knighted", "Council Enqueue names already knighted")
assert_eq(#Knighting:GetLine(), 0, "rank 3+ refuses do not enter the line")

knighted, knightErr = Knighting:KnightThisBeef(butcherHuman.id, 3008)
assert_eq(knighted, nil, "KnightThisBeef refuses a Beef Butcher")
assert_eq(knightErr, "already elevated", "Butcher knighting names already elevated")
assert_eq(Store:GetHuman(butcherHuman.id).rankId, 5, "refused knighting does not demote a Butcher")
assert_eq(Store:GetHuman(butcherHuman.id).elevationAt, nil, "Butcher refuse does not write elevationAt")

knighted, knightErr = Knighting:KnightThisBeef(councilHuman.id, 3009)
assert_eq(knighted, nil, "KnightThisBeef refuses Beef Council")
assert_eq(knightErr, "already elevated", "Council knighting names already elevated")
assert_eq(Store:GetHuman(councilHuman.id).rankId, 6, "refused knighting does not demote Council")
assert_eq(Store:GetHuman(councilHuman.id).elevationAt, nil, "Council refuse does not write elevationAt")
assert_eq(#Store:GetCeremonyLog(), 0, "refused Butcher and Council knightings do not append")
assert_eq(#Knighting:GetLine(), 0, "refused elevated knightings do not change the line")
assert_eq(promoteCalls, 0, "refused elevated knightings do not GuildPromote")

local butcherElev, butcherElevErr = Knighting:ElevateToLord(butcherHuman.id, 3008)
assert_eq(butcherElev, nil, "ElevateToLord refuses a Beef Butcher")
assert_eq(butcherElevErr, "already elevated", "Butcher elevation names already elevated")
assert_eq(Store:GetHuman(butcherHuman.id).rankId, 5, "refused elevation does not demote a Butcher")
assert_eq(Store:GetHuman(butcherHuman.id).elevationAt, nil, "Butcher elevate refuse does not write elevationAt")

local councilElev, councilElevErr = Knighting:ElevateToLord(councilHuman.id, 3009)
assert_eq(councilElev, nil, "ElevateToLord refuses Beef Council")
assert_eq(councilElevErr, "already elevated", "Council elevation names already elevated")
assert_eq(Store:GetHuman(councilHuman.id).rankId, 6, "refused elevation does not demote Council")
assert_eq(Store:GetHuman(councilHuman.id).elevationAt, nil, "Council elevate refuse does not write elevationAt")
assert_eq(#Store:GetCeremonyLog(), 0, "refused Butcher and Council elevations do not append")
assert_eq(#Knighting:GetLine(), 0, "refused Butcher and Council elevations do not change the line")
assert_eq(promoteCalls, 0, "refused Butcher and Council elevations do not GuildPromote")

do
  local linedButcher = Store:CreateHuman({ name = "LinedButcher" }, 3010)
  Knighting:Enqueue(linedButcher.id)
  Store:SetRank(linedButcher.id, 5, 3011)
  assert_eq(#Knighting:GetLine(), 1, "a Store-written Butcher can still sit on the line")
  assert_eq(lineHas(linedButcher.id), true, "GetLine still lists that Store-written Butcher")
  local row, err = Knighting:ElevateToLord(linedButcher.id, 3012)
  assert_eq(row, nil, "ElevateToLord refuses a Butcher still on the line")
  assert_eq(err, "already elevated", "on-line Butcher elevation names already elevated")
  assert_eq(#Knighting:GetLine(), 1, "refused elevation leaves the line unchanged")
  assert_eq(lineHas(linedButcher.id), true, "refused elevation does not dequeue a Butcher")
  assert_eq(Store:GetHuman(linedButcher.id).rankId, 5, "on-line elevate refuse does not demote")
  assert_eq(Store:GetHuman(linedButcher.id).elevationAt, nil, "on-line elevate refuse does not change elevationAt")
  assert_eq(#Store:GetCeremonyLog(), 0, "on-line elevate refuse does not append")
  assert_eq(promoteCalls, 0, "on-line elevate refuse does not GuildPromote")
  Knighting:Skip(linedButcher.id)
  assert_eq(#Knighting:GetLine(), 0, "cleanup Skip empties the leftover Butcher row")
end

local waiting = Knighting:Enqueue(steve.id)
assert_true(waiting ~= nil, "an unenrolled human may still enter the line")
assert_eq(#Knighting:GetLine(), 1, "the line has the unenrolled human")

local elevated = Knighting:ElevateToLord(steve.id, 3010)
assert_eq(elevated.rankId, 4, "ElevateToLord still writes Lord")
assert_eq(#Knighting:GetLine(), 0, "successful ElevateToLord removes that human")
assert_eq(lineHas(steve.id), false, "GetLine does not contain the elevated id")

local elevEnq, elevEnqErr = Knighting:Enqueue(steve.id)
assert_eq(elevEnq, nil, "Enqueue after ElevateToLord refuses")
assert_eq(elevEnqErr, "already knighted", "elevated Enqueue names already knighted")
assert_eq(#Knighting:GetLine(), 0, "refused Enqueue after elevation does not re-enter")
assert_eq(lineHas(steve.id), false, "refused Enqueue after elevation does not restore the id")

--------------------------------------------------------------------------------
-- Successful KnightThisBeef removes that human. Others stay. Not AdvanceQueue.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local second = Store:CreateHuman({ name = "Second" }, 3100)
local third = Store:CreateHuman({ name = "Third" }, 3101)
Knighting:Enqueue(steve.id)
Knighting:Enqueue(second.id)
Knighting:Enqueue(third.id)
assert_eq(#Knighting:GetLine(), 3, "three candidates wait")

local knightedSteve = Knighting:KnightThisBeef(steve.id, 3110)
assert_eq(knightedSteve.rankId, 3, "KnightThisBeef still writes Beef Knight")
assert_eq(#Knighting:GetLine(), 2, "successful KnightThisBeef removes that human")
assert_eq(Knighting:GetLine()[1].humanId, second.id, "the next oldest remains first")
assert_eq(Knighting:GetLine()[2].humanId, third.id, "the newest remains last")
assert_eq(Store:GetHuman(second.id).rankId, nil, "KnightThisBeef does not knight the next human")
assert_eq(Knighting.AdvanceQueue, nil, "removal is not AdvanceQueue")
assert_eq(Knighting.NextCandidate, nil, "removal is not NextCandidate")
assert_eq(Knighting.queue, nil, "still no public queue field")
assert_eq(Knighting.next, nil, "still no next pointer")
assert_eq(riteCalls, 0, "KnightThisBeef still does not call Runtime verbs")

local againKnight = Knighting:KnightThisBeef(steve.id, 3111)
assert_eq(againKnight.rankId, 3, "a second knighting of the same human still succeeds")
assert_eq(#Knighting:GetLine(), 2, "knighting a human already off the line leaves the others")

local offLine = Store:CreateHuman({ name = "OffLine" }, 3112)
local offKnight = Knighting:KnightThisBeef(offLine.id, 3113)
assert_eq(offKnight.rankId, 3, "KnightThisBeef works for a human not on the line")
assert_eq(#Knighting:GetLine(), 2, "knighting an off-line human does not change the line")

--------------------------------------------------------------------------------
-- Successful ElevateToLord removes that human. Others stay. Not AdvanceQueue.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local peer = Store:CreateHuman({ name = "Peer" }, 3400)
local tail = Store:CreateHuman({ name = "Tail" }, 3401)
Knighting:Enqueue(steve.id)
Knighting:Enqueue(peer.id)
Knighting:Enqueue(tail.id)
assert_eq(#Knighting:GetLine(), 3, "three candidates wait before elevation")
assert_eq(lineHas(peer.id), true, "the middle human is on the line")

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

local missLordLine, missLordLineErr = Knighting:ElevateToLord(99, 3410)
assert_eq(missLordLine, nil, "unknown ElevateToLord still refuses")
assert_true(type(missLordLineErr) == "string", "unknown ElevateToLord returns an error string")
assert_eq(#Knighting:GetLine(), 3, "refused ElevateToLord does not dequeue")
assert_eq(lineHas(peer.id), true, "refused ElevateToLord leaves the waiting ids")

local elevatedPeer = Knighting:ElevateToLord(peer.id, 3411)
assert_eq(elevatedPeer.rankId, 4, "ElevateToLord still writes Beef Lord")
assert_eq(#Knighting:GetLine(), 2, "successful ElevateToLord removes that human")
assert_eq(lineHas(peer.id), false, "GetLine does not contain the elevated id")
assert_eq(Knighting:GetLine()[1].humanId, steve.id, "the oldest remains first")
assert_eq(Knighting:GetLine()[2].humanId, tail.id, "the newest remains last")
assert_eq(Store:GetHuman(steve.id).rankId, nil, "ElevateToLord does not knight the next human")
assert_eq(Store:GetHuman(tail.id).rankId, nil, "ElevateToLord does not knight the remainder")
assert_eq(Store:GetHuman(peer.id).rankId, 4, "only the clicked human is Lord")
assert_eq(Knighting.queue, nil, "elevation removal is not a public queue")
assert_eq(Knighting.next, nil, "elevation removal is not a next pointer")
assert_eq(Knighting.AdvanceQueue, nil, "elevation removal is not AdvanceQueue")
assert_eq(Knighting.NextCandidate, nil, "elevation removal is not NextCandidate")
assert_eq(riteCalls, 0, "ElevateToLord does not call Runtime verbs")
assert_eq(promoteCalls, 0, "ElevateToLord still does not GuildPromote")

local againLord = Knighting:ElevateToLord(peer.id, 3412)
assert_eq(againLord.rankId, 4, "a second elevation of the same human still succeeds")
assert_eq(#Knighting:GetLine(), 2, "elevating a human already off the line leaves the others")
assert_eq(lineHas(peer.id), false, "a second elevation does not restore the id")

local offLordHuman = Store:CreateHuman({ name = "OffLineLord" }, 3413)
local offLord = Knighting:ElevateToLord(offLordHuman.id, 3414)
assert_eq(offLord.rankId, 4, "ElevateToLord works for a human not on the line")
assert_eq(#Knighting:GetLine(), 2, "elevating an off-line human does not change the line")
assert_eq(lineHas(steve.id), true, "off-line elevation keeps the oldest")
assert_eq(lineHas(tail.id), true, "off-line elevation keeps the newest")
assert_eq(lineHas(offLordHuman.id), false, "an off-line elevation does not enqueue")

COB.Runtime = nil

--------------------------------------------------------------------------------
-- Event-scoped when Runtime.Snapshot is loaded. Inline stub. Never OpenRite.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
local snapHuman = Store:CreateHuman({ name = "Snap" }, 3200)
local savedRuntime = COB.Runtime
local opened = 0
local snap = { state = "QUIET", eventId = 1 }
COB.Runtime = {
  Snapshot = function()
    return snap
  end,
  OpenRite = function()
    opened = opened + 1
    riteCalls = riteCalls + 1
  end,
  EndEvent = function()
    riteCalls = riteCalls + 1
  end,
}

local quietEnq, quietEnqErr = Knighting:Enqueue(steve.id)
assert_eq(quietEnq, nil, "Enqueue from QUIET is refused")
assert_eq(quietEnqErr, "no event", "QUIET Enqueue names the missing event")
local quietIns, quietInsErr = Knighting:Insert(snapHuman.id)
assert_eq(quietIns, nil, "Insert from QUIET is refused")
assert_eq(quietInsErr, "no event", "QUIET Insert names the missing event")
assert_eq(#Knighting:GetLine(), 0, "QUIET GetLine is empty")
assert_eq(opened, 0, "QUIET Enqueue does not OpenRite")

snap.state = "ASSEMBLY"
local liveEnq, liveEnqErr = Knighting:Enqueue(steve.id)
assert_true(liveEnq ~= nil, "Enqueue during ASSEMBLY is accepted")
assert_eq(liveEnqErr, nil, "ASSEMBLY Enqueue has no error")
Knighting:Insert(snapHuman.id)
assert_eq(#Knighting:GetLine(), 2, "the live event holds two humans")
assert_eq(opened, 0, "Enqueue does not OpenRite")
assert_eq(riteCalls, 0, "line verbs do not call Runtime verbs")
assert_eq(Store:GetHuman(steve.id).rankId, nil, "event Enqueue does not knight")

snap.state = "RITE"
assert_eq(#Knighting:GetLine(), 2, "RITE keeps the current-event line")
snap.state = "CONSEQUENCE"
assert_eq(#Knighting:GetLine(), 2, "CONSEQUENCE keeps the current-event line")
snap.state = "ASSEMBLY"
assert_eq(#Knighting:GetLine(), 2, "return to ASSEMBLY keeps the current-event line")

snap.eventId = 2
assert_eq(#Knighting:GetLine(), 0, "a new eventId expires the prior line")
local newEnq = Knighting:Enqueue(steve.id)
assert_true(newEnq ~= nil, "a new event accepts a fresh Enqueue")
assert_eq(#Knighting:GetLine(), 1, "the new event has one human")

snap.state = "QUIET"
assert_eq(#Knighting:GetLine(), 0, "GetLine is empty after QUIET expire")
local postQuiet, postQuietErr = Knighting:Enqueue(steve.id)
assert_eq(postQuiet, nil, "Enqueue after QUIET expire is refused")
assert_eq(postQuietErr, "no event", "post-QUIET Enqueue names the missing event")

snap.state = "ASSEMBLY"
snap.eventId = 3
Knighting:Enqueue(steve.id)
assert_eq(#Knighting:GetLine(), 1, "a later event can fill the line again")
snap.eventId = nil
assert_eq(#Knighting:GetLine(), 0, "missing eventId wipes the line")
local missEv, missEvErr = Knighting:Insert(snapHuman.id)
assert_eq(missEv, nil, "Insert without eventId is refused")
assert_eq(missEvErr, "no event", "missing eventId Insert names the missing event")

snap.state = "ASSEMBLY"
snap.eventId = 4
Knighting:Enqueue(steve.id)
Knighting:Enqueue(snapHuman.id)
local knightDuring = Knighting:KnightThisBeef(steve.id, 3210)
assert_eq(knightDuring.rankId, 3, "KnightThisBeef during an event still writes Knight")
assert_eq(#Knighting:GetLine(), 1, "KnightThisBeef removes only that human")
assert_eq(Knighting:GetLine()[1].humanId, snapHuman.id, "the other human stays on the event line")
assert_eq(opened, 0, "KnightThisBeef does not OpenRite")
local duringLog = Store:GetCeremonyLog()
assert_eq(duringLog[#duringLog].eventId, 4, "KnightThisBeef stamps the live Gathering on the sitting")

COB.Runtime = savedRuntime
assert_eq(COB.Runtime, nil, "event stub is removed after expire tests")

--------------------------------------------------------------------------------
-- ResetForTests wipes the line. Inert outside the harness.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
Knighting:Enqueue(steve.id)
assert_eq(#Knighting:GetLine(), 1, "ResetForTests test has a waiting human")
ChurchOfBeef._IN_TEST = false
assert_eq(Knighting:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(#Knighting:GetLine(), 1, "out-of-harness reset does not wipe the line")
ChurchOfBeef._IN_TEST = true
assert_eq(Knighting:ResetForTests(), true, "ResetForTests wipes under _IN_TEST")
assert_eq(#Knighting:GetLine(), 0, "ResetForTests empties the line")

--------------------------------------------------------------------------------
-- Line verbs do not CreateFrame, promote, or persist. Source pins.
--------------------------------------------------------------------------------
reset()
steve = seed("Steve")
ChurchOfBeefDB = { sentinel = 1 }
Knighting:Enqueue(steve.id)
Knighting:Insert(Store:CreateHuman({ name = "Late" }, 3300).id)
Knighting:GetLine()
Knighting:Skip(steve.id)
assert_eq(promoteCalls, 0, "line verbs do not call GuildPromote or SetGuildRank")
assert_eq(frameCalls, 0, "line verbs do not CreateFrame")
assert_eq(ChurchOfBeefDB.sentinel, 1, "line verbs do not write ChurchOfBeefDB")
assert_eq(riteCalls, 0, "line verbs do not call Runtime verbs")

local srcFile = io.open("addon/ChurchOfBeef/Core/Knighting.lua", "r")
assert_true(srcFile ~= nil, "Knighting source is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("GuildPromote", 1, true), nil, "source does not GuildPromote")
assert_eq(src:find("SetGuildRank", 1, true), nil, "source does not SetGuildRank")
assert_eq(src:find("CreateFrame", 1, true), nil, "source does not CreateFrame")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("SendAddonMessage", 1, true), nil, "source does not send addon messages")
assert_eq(src:find("ChurchOfBeefDB", 1, true), nil, "source does not touch SavedVariables")
assert_eq(src:find("function Knighting:OpenRite", 1, true), nil, "source does not define OpenRite")
assert_eq(src:find("function Knighting:AdvanceQueue", 1, true), nil, "source does not define AdvanceQueue")
assert_eq(src:find("function Knighting:NextCandidate", 1, true), nil, "source does not define NextCandidate")
assert_true(src:find("already elevated", 1, true) ~= nil, "source names already elevated")

COB.Runtime = savedRuntimeForIsolation

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
