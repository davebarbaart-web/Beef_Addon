-- Shared-instance co-play tracker. The rules are exercised on injected state
-- tables (where am I, who is with me, was I fighting) so the bucket logic is proven
-- offline; the live sampler and the event frame are checked against the widget stub.
-- Whether a real TBC dungeon fires these events still needs the client.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
dofile("addon/ChurchOfBeef/Core/Instance.lua")
-- The bootstrap is where the tracker's client events are registered now.
dofile("addon/ChurchOfBeef/ChurchOfBeef.lua")

local COB = ChurchOfBeef
local I = COB.Instance
local Points = COB.Scoring.Points

local function reset()
  COB.Ladder:ResetForTests()
  COB.Scoring:ResetForTests()
  I:ResetForTests()
  stub.tickers = {}
end

local function standingOf(name)
  return COB.Ladder:GetRecord(name).standing
end

-- A dungeon with one guildmate, out of combat, unless the caller says otherwise.
local function inDungeon(overrides)
  local state = {
    inInstance = true,
    instanceType = "party",
    guildmates = 1,
    inCombat = false,
    instanceId = 100,
  }
  for key, value in pairs(overrides or {}) do state[key] = value end
  return state
end

stub.playerName = "Beefina"
reset()

--------------------------------------------------------------------------------
-- What counts as co-play
--------------------------------------------------------------------------------
assert_eq(I:Qualifies(inDungeon()), true, "a dungeon with a guildmate qualifies")
assert_eq(I:Qualifies(inDungeon({ instanceType = "raid" })), true, "a raid qualifies")
assert_eq(I:Qualifies(inDungeon({ instanceType = "pvp" })), true, "a battleground qualifies")

assert_eq(I:Qualifies(inDungeon({ guildmates = 0 })), false, "soloing a dungeon earns nothing")
assert_eq(I:Qualifies(inDungeon({ inInstance = false, instanceType = "none" })), false,
  "the open world never qualifies")
assert_eq(I:Qualifies(inDungeon({ inInstance = false })), false, "a city never qualifies")
assert_eq(I:Qualifies(inDungeon({ instanceType = "arena" })), false, "arena is not a co-play night")
assert_eq(I:Qualifies(inDungeon({ instanceType = "scenario" })), false, "an unknown instance type is refused")
assert_eq(I:Qualifies("dungeon"), false, "a malformed state qualifies for nothing")
assert_eq(I:Qualifies(function() return inDungeon() end), true, "state may be sampled through a function")

--------------------------------------------------------------------------------
-- Buckets: one grant per closed 60s window the player fought in
--------------------------------------------------------------------------------
reset()
assert_eq(I:IsTracking(), false, "the tracker starts idle")
assert_eq(I:Tick(60), 0, "an idle tracker pays nothing")
assert_eq(I:NoteCombat(), false, "combat outside a tracked instance is not recorded")

assert_eq(I:Update(inDungeon(), 0), true, "entering a dungeon with a guildmate starts tracking")
assert_eq(I:IsTracking(), true, "the tracker is running")
assert_eq(#stub.tickers, 1, "tracking arms exactly one ticker")
assert_eq(stub.tickers[1].seconds, I.BucketSeconds, "the ticker runs at the bucket length")

assert_eq(I:Tick(30, inDungeon({ inCombat = true })), 0, "an unfinished bucket pays nothing")
assert_eq(I:Tick(60, inDungeon()), Points.InstanceBucket, "a bucket the player fought in pays")
assert_eq(standingOf("Beefina"), Points.InstanceBucket, "the bucket landed on the player's standing")

-- The fight was in the previous bucket; this one was quiet.
assert_eq(I:Tick(120, inDungeon()), 0, "a quiet bucket pays nothing")
assert_eq(standingOf("Beefina"), Points.InstanceBucket, "standing did not move for a quiet bucket")

-- PLAYER_REGEN_DISABLED is the real combat signal; a poll never has to catch it.
assert_eq(I:NoteCombat(), true, "entering combat is recorded while tracking")
assert_eq(I:Tick(180, inDungeon()), Points.InstanceBucket, "combat noted mid-bucket pays at the close")

-- Still swinging as the bucket closes: that combat belongs to the next bucket too.
assert_eq(I:Tick(240, inDungeon({ inCombat = true })), Points.InstanceBucket, "a fighting bucket pays")
assert_eq(I:Tick(300, inDungeon()), Points.InstanceBucket, "combat spanning the boundary counts twice")

--------------------------------------------------------------------------------
-- Anti-AFK: a night parked at the entrance earns exactly nothing
--------------------------------------------------------------------------------
reset()
I:Update(inDungeon(), 0)
for i = 1, 30 do I:Tick(i * 60, inDungeon()) end
assert_eq(standingOf("Beefina"), 0, "an AFK dungeon night earns nothing")
assert_eq(COB.Scoring:GetGranted("Beefina", "instance"), 0, "AFK buckets spend no daily cap")

--------------------------------------------------------------------------------
-- A drifting timer pays one bucket, not a burst
--------------------------------------------------------------------------------
reset()
I:Update(inDungeon({ inCombat = true }), 0)
assert_eq(I:Tick(600, inDungeon()), Points.InstanceBucket, "ten minutes of drift still closes one bucket")
assert_eq(standingOf("Beefina"), Points.InstanceBucket, "drift cannot be cashed in as a burst")

--------------------------------------------------------------------------------
-- Leaving: the open bucket is dropped and the ticker is cancelled
--------------------------------------------------------------------------------
reset()
I:Update(inDungeon(), 0)
I:NoteCombat()
assert_eq(I:Update(inDungeon({ inInstance = false, instanceType = "none" }), 30), false,
  "stepping outside stops tracking")
assert_eq(I:IsTracking(), false, "the tracker went idle")
assert_eq(stub.tickers[1].cancelled, true, "an idle tracker leaves no timer running")
assert_eq(I:Tick(60, inDungeon()), 0, "the dropped partial bucket cannot be cashed later")
assert_eq(standingOf("Beefina"), 0, "leaving mid-bucket pays nothing")

-- The last guildmate leaving ends co-play just as surely as zoning out.
reset()
I:Update(inDungeon(), 0)
I:NoteCombat()
assert_eq(I:Update(inDungeon({ guildmates = 0 }), 30), false, "the last guildmate leaving stops tracking")
assert_eq(standingOf("Beefina"), 0, "a solo run pays nothing")

-- A tick that discovers the world changed stops tracking instead of paying.
reset()
I:Update(inDungeon({ inCombat = true }), 0)
assert_eq(I:Tick(60, inDungeon({ guildmates = 0 })), 0, "a tick without a guildmate pays nothing")
assert_eq(I:IsTracking(), false, "the tick stopped tracking")

--------------------------------------------------------------------------------
-- A second dungeon is a second run: fresh bucket, fresh completion bonus
--------------------------------------------------------------------------------
reset()
I:Update(inDungeon(), 0)
I:NoteCombat()
I:Update(inDungeon({ instanceId = 200 }), 45)
assert_eq(I:Tick(60, inDungeon({ instanceId = 200 })), 0, "the new run's bucket started fresh")
assert_eq(I:Tick(105, inDungeon({ instanceId = 200 })), 0, "the previous run's combat did not carry over")
assert_eq(standingOf("Beefina"), 0, "zoning between dungeons pays nothing on its own")

--------------------------------------------------------------------------------
-- Completion bonus: best effort, once per run
--------------------------------------------------------------------------------
reset()
assert_eq(I:GrantCompletion(inDungeon()), 0, "no completion bonus outside a tracked run")

I:Update(inDungeon({ instanceType = "pvp" }), 0)
local bg = inDungeon({ instanceType = "pvp" })
assert_eq(I:GrantCompletion(bg), Points.InstanceComplete, "finishing a match pays the completion bonus")
assert_eq(I:GrantCompletion(bg), 0, "the bonus is paid at most once per run")
assert_eq(standingOf("Beefina"), Points.InstanceComplete, "the bonus landed on standing")

reset()
I:Update(bg, 0)
stub.battlefieldWinner = nil
assert_eq(I:CheckBattlegroundEnd(bg), 0, "a battleground still in progress pays nothing")
stub.battlefieldWinner = 0
assert_eq(I:CheckBattlegroundEnd(bg), Points.InstanceComplete, "a locked scoreboard pays the bonus")
assert_eq(I:CheckBattlegroundEnd(bg), 0, "the scoreboard cannot be read twice for credit")
stub.battlefieldWinner = nil

--------------------------------------------------------------------------------
-- The live sampler: what actually runs in game
--------------------------------------------------------------------------------
reset()
stub.inInstance = true
stub.instanceType = "party"
stub.instanceId = 33
stub.groupSize = 3
stub.group = {
  party1 = { name = "Steakina" },
  party2 = { name = "Pugina", inGuild = false },
}

assert_eq(I:Qualifies(), true, "the live sampler sees the guildmate in the party")

stub.group.party1 = { name = "Rando", inGuild = false }
assert_eq(I:Qualifies(), false, "a party of pugs is not co-play")
stub.group.party1 = { name = "Steakina" }

stub.inInstance = false
stub.instanceType = "none"
assert_eq(I:Qualifies(), false, "the live sampler refuses the open world")
stub.inInstance = true
stub.instanceType = "party"

-- Raid unit ids include the player, who must never count as their own guildmate.
stub.inRaid = true
stub.instanceType = "raid"
stub.groupSize = 1
stub.group = { raid1 = { name = "Beefina" } }
assert_eq(I:Qualifies(), false, "the player alone in a raid is not co-play")
stub.groupSize = 2
stub.group.raid2 = { name = "Steakina" }
assert_eq(I:Qualifies(), true, "a guildmate in the raid is co-play")
stub.inRaid = false
stub.instanceType = "party"
stub.groupSize = 3
stub.group = { party1 = { name = "Steakina" } }

--------------------------------------------------------------------------------
-- Init: discrete events only, and combat sampled from the client
--------------------------------------------------------------------------------
reset()
stub.playerInCombat = false
-- Core owns no frames (addon-module-layers): the bootstrap registers the events and
-- routes them into the tracker, so that is what has to be exercised here.
local frame = COB:WireInstanceEvents()
assert_true(frame ~= nil, "the bootstrap owns the tracker's event frame")
assert_eq(I.frame, nil, "and Core/Instance.lua holds no frame of its own")
assert_eq(frame._events["PLAYER_ENTERING_WORLD"], true, "zone-in is watched")
assert_eq(frame._events["ZONE_CHANGED_NEW_AREA"], true, "zone changes are watched")
assert_eq(frame._events["GROUP_ROSTER_UPDATE"], true, "group changes are watched")
assert_eq(frame._events["PLAYER_REGEN_DISABLED"], true, "entering combat is watched")
assert_eq(frame._events["UPDATE_BATTLEFIELD_STATUS"], true, "battleground status is watched")
assert_eq(frame._events["COMBAT_LOG_EVENT_UNFILTERED"], nil, "scoring never registers the combat log")
assert_eq(frame._scripts.OnUpdate, nil, "no per-frame handler drives scoring")

assert_eq(stub.fire(frame, "OnEvent", "PLAYER_ENTERING_WORLD"), true, "the event frame is wired")
assert_eq(I:IsTracking(), true, "zoning into the dungeon started tracking from live state")

stub.fire(frame, "OnEvent", "PLAYER_REGEN_DISABLED")
local ticker = stub.tickers[#stub.tickers]
stub.playerInCombat = false
COB.Ladder:ResetForTests()
I.bucketStartedAt = -I.BucketSeconds -- the ticker's own clock is GetTime; force a closed bucket
ticker.fn()
assert_eq(standingOf("Beefina"), Points.InstanceBucket, "the ticker closes buckets through Scoring")

stub.inInstance = false
stub.instanceType = "none"
stub.fire(frame, "OnEvent", "PLAYER_ENTERING_WORLD")
assert_eq(I:IsTracking(), false, "leaving the instance idles the tracker")
assert_eq(ticker.cancelled, true, "the ticker is cancelled on the way out")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
I:Update(inDungeon(), 0)
ChurchOfBeef._IN_TEST = false
local probeOk, probeErr = pcall(function()
  assert_eq(I:ResetForTests(), false, "ResetForTests refuses to run outside tests")
  assert_eq(I:IsTracking(), true, "a gated reset leaves tracking alone")
end)
ChurchOfBeef._IN_TEST = true
assert_true(probeOk, "_IN_TEST=false probe raised: " .. tostring(probeErr))
assert_eq(I:ResetForTests(), true, "ResetForTests runs under COB._IN_TEST")

stub.groupSize = 0
stub.group = {}
stub.inInstance = false
restore()
