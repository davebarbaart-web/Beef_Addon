-- Quest fellowship co-play tracker. Rules are exercised on injected state tables
-- (guildmate present, not in instance, not resting, combat or turn-in) so the
-- bucket logic is proven offline; the live sampler and the event frame are
-- checked against the widget stub.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
dofile("addon/ChurchOfBeef/Core/Quest.lua")
-- The bootstrap is where the tracker's client events are registered now.
dofile("addon/ChurchOfBeef/ChurchOfBeef.lua")

local COB = ChurchOfBeef
local Q = COB.Quest
local Points = COB.Scoring.Points

local function reset()
  COB.Ladder:ResetForTests()
  COB.Scoring:ResetForTests()
  Q:ResetForTests()
  stub.tickers = {}
end

local function standingOf(name)
  return COB.Ladder:GetRecord(name).standing
end

-- Open-world party with one guildmate, out of combat / not resting, unless overridden.
local function inQuestParty(overrides)
  local state = {
    inInstance = false,
    guildmates = 1,
    resting = false,
    inCombat = false,
  }
  for key, value in pairs(overrides or {}) do state[key] = value end
  return state
end

stub.playerName = "Beefina"
reset()

--------------------------------------------------------------------------------
-- What counts as quest fellowship
--------------------------------------------------------------------------------
assert_eq(Q:Qualifies(inQuestParty()), true, "a party with a guildmate in the open world qualifies")
assert_eq(Q:Qualifies(inQuestParty({ guildmates = 0 })), false, "no guildmate earns nothing")
assert_eq(Q:Qualifies(inQuestParty({ inInstance = true })), false, "an instance never qualifies for quest fellowship")
assert_eq(Q:Qualifies(inQuestParty({ resting = true })), false, "resting in a city/inn refuses")
assert_eq(Q:Qualifies("party"), false, "a malformed state qualifies for nothing")
assert_eq(Q:Qualifies(function() return inQuestParty() end), true, "state may be sampled through a function")

--------------------------------------------------------------------------------
-- No pay without a guildmate; no pay inside an instance
--------------------------------------------------------------------------------
reset()
assert_eq(Q:Update(inQuestParty({ guildmates = 0 }), 0), false, "solo open world does not start tracking")
assert_eq(Q:Tick(60, inQuestParty({ guildmates = 0 })), 0, "solo never pays")
assert_eq(standingOf("Beefina"), 0, "solo standing untouched")

reset()
assert_eq(Q:Update(inQuestParty({ inInstance = true }), 0), false, "an instance does not start quest tracking")
Q:Update(inQuestParty(), 0)
Q:NoteCombat()
assert_eq(Q:Tick(60, inQuestParty({ inInstance = true })), 0, "zoning into an instance mid-bucket pays nothing")
assert_eq(Q:IsTracking(), false, "entering an instance stops quest tracking")
assert_eq(standingOf("Beefina"), 0, "instance path leaves quest standing alone")

--------------------------------------------------------------------------------
-- Resting refuses
--------------------------------------------------------------------------------
reset()
assert_eq(Q:Update(inQuestParty({ resting = true }), 0), false, "resting never starts tracking")
assert_eq(Q:Qualifies(inQuestParty({ resting = true })), false, "Qualifies refuses resting")

reset()
Q:Update(inQuestParty(), 0)
Q:NoteCombat()
assert_eq(Q:Update(inQuestParty({ resting = true }), 30), false, "becoming rested stops tracking")
assert_eq(Q:IsTracking(), false, "resting idles the tracker")
assert_eq(standingOf("Beefina"), 0, "resting drops the open bucket unpaid")

--------------------------------------------------------------------------------
-- Combat-gated bucket pays via GrantQuestBucket
--------------------------------------------------------------------------------
reset()
assert_eq(Q:IsTracking(), false, "the tracker starts idle")
assert_eq(Q:Tick(60), 0, "an idle tracker pays nothing")
assert_eq(Q:NoteCombat(), false, "combat outside tracking is not recorded")

assert_eq(Q:Update(inQuestParty(), 0), true, "a guildmate party starts tracking")
assert_eq(Q:IsTracking(), true, "the tracker is running")
assert_eq(#stub.tickers, 1, "tracking arms exactly one ticker")
assert_eq(stub.tickers[1].seconds, Q.BucketSeconds, "the ticker runs at the bucket length")

assert_eq(Q:Tick(30, inQuestParty({ inCombat = true })), 0, "an unfinished bucket pays nothing")
assert_eq(Q:Tick(60, inQuestParty()), Points.QuestBucket, "a bucket the player fought in pays")
assert_eq(standingOf("Beefina"), Points.QuestBucket, "the bucket landed on the player's standing")
assert_eq(COB.Scoring:GetGranted("Beefina", "quest"), Points.QuestBucket, "quest daily cap spent")

-- Quiet bucket after the fight: no pay, no extra cap spend.
assert_eq(Q:Tick(120, inQuestParty()), 0, "a quiet bucket pays nothing")
assert_eq(standingOf("Beefina"), Points.QuestBucket, "standing did not move for a quiet bucket")

-- Discrete combat note mid-bucket.
assert_eq(Q:NoteCombat(), true, "entering combat is recorded while tracking")
assert_eq(Q:Tick(180, inQuestParty()), Points.QuestBucket, "combat noted mid-bucket pays at the close")

--------------------------------------------------------------------------------
-- Quest turn-in also gates a bucket
--------------------------------------------------------------------------------
reset()
Q:Update(inQuestParty(), 0)
assert_eq(Q:NoteQuestTurnIn(), true, "a turn-in is recorded while tracking")
assert_eq(Q:Tick(60, inQuestParty()), Points.QuestBucket, "a turn-in bucket pays via GrantQuestBucket")
assert_eq(standingOf("Beefina"), Points.QuestBucket, "turn-in credit landed on standing")

--------------------------------------------------------------------------------
-- Leaving / AFK
--------------------------------------------------------------------------------
reset()
Q:Update(inQuestParty(), 0)
for i = 1, 30 do Q:Tick(i * 60, inQuestParty()) end
assert_eq(standingOf("Beefina"), 0, "an AFK quest night earns nothing")
assert_eq(COB.Scoring:GetGranted("Beefina", "quest"), 0, "AFK buckets spend no quest cap")

reset()
Q:Update(inQuestParty(), 0)
Q:NoteCombat()
assert_eq(Q:Update(inQuestParty({ guildmates = 0 }), 30), false, "last guildmate leaving stops tracking")
assert_eq(stub.tickers[1].cancelled, true, "an idle tracker leaves no timer running")
assert_eq(standingOf("Beefina"), 0, "leaving mid-bucket pays nothing")

--------------------------------------------------------------------------------
-- Bootstrap wiring: discrete events only
--------------------------------------------------------------------------------
reset()
stub.inInstance = false
stub.playerResting = false
stub.playerInCombat = false
stub.groupSize = 2
stub.group = { party1 = { name = "Steakina" } }

local frame = COB:WireQuestEvents()
assert_true(frame ~= nil, "the bootstrap owns the quest event frame")
assert_eq(Q.frame, nil, "and Core/Quest.lua holds no frame of its own")
assert_eq(frame._events["PLAYER_ENTERING_WORLD"], true, "zone-in is watched")
assert_eq(frame._events["ZONE_CHANGED_NEW_AREA"], true, "zone changes are watched")
assert_eq(frame._events["GROUP_ROSTER_UPDATE"], true, "group changes are watched")
assert_eq(frame._events["PLAYER_REGEN_DISABLED"], true, "entering combat is watched")
assert_eq(frame._events["QUEST_TURNED_IN"], true, "quest turn-in is watched")
assert_eq(frame._events["COMBAT_LOG_EVENT_UNFILTERED"], nil, "scoring never registers the combat log")
assert_eq(frame._scripts.OnUpdate, nil, "no per-frame handler drives scoring")

assert_eq(stub.fire(frame, "OnEvent", "PLAYER_ENTERING_WORLD"), true, "the event frame is wired")
assert_eq(Q:IsTracking(), true, "zoning with a guildmate started tracking from live state")

stub.fire(frame, "OnEvent", "PLAYER_REGEN_DISABLED")
local ticker = stub.tickers[#stub.tickers]
stub.playerInCombat = false
COB.Ladder:ResetForTests()
COB.Scoring:ResetForTests()
Q.bucketStartedAt = -Q.BucketSeconds
ticker.fn()
assert_eq(standingOf("Beefina"), Points.QuestBucket, "the ticker closes buckets through Scoring")

stub.fire(frame, "OnEvent", "QUEST_TURNED_IN")
assert_eq(Q.questTurnInSeen, true, "QUEST_TURNED_IN notes a turn-in while tracking")

stub.playerResting = true
stub.fire(frame, "OnEvent", "ZONE_CHANGED_NEW_AREA")
assert_eq(Q:IsTracking(), false, "resting idles the tracker from live state")
assert_eq(ticker.cancelled, true, "the ticker is cancelled on the way out")

--------------------------------------------------------------------------------
-- Live sampler: IsResting and instance refuse
--------------------------------------------------------------------------------
reset()
stub.inInstance = false
stub.playerResting = false
stub.groupSize = 2
stub.group = { party1 = { name = "Steakina" } }
assert_eq(Q:Qualifies(), true, "the live sampler sees the guildmate in the party")

stub.playerResting = true
assert_eq(Q:Qualifies(), false, "the live sampler refuses resting")
stub.playerResting = false

stub.inInstance = true
assert_eq(Q:Qualifies(), false, "the live sampler refuses instances")
stub.inInstance = false

stub.group.party1 = { name = "Rando", inGuild = false }
assert_eq(Q:Qualifies(), false, "a party of pugs is not quest fellowship")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
Q:Update(inQuestParty(), 0)
ChurchOfBeef._IN_TEST = false
local probeOk, probeErr = pcall(function()
  assert_eq(Q:ResetForTests(), false, "ResetForTests refuses to run outside tests")
  assert_eq(Q:IsTracking(), true, "a gated reset leaves tracking alone")
end)
ChurchOfBeef._IN_TEST = true
assert_true(probeOk, "_IN_TEST=false probe raised: " .. tostring(probeErr))
assert_eq(Q:ResetForTests(), true, "ResetForTests runs under COB._IN_TEST")

stub.groupSize = 0
stub.group = {}
stub.inInstance = false
stub.playerResting = false
restore()
