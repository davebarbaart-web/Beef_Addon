-- Load canon, ladder and scoring the same way the addon will, as chunks setting COB fields.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
local S = ChurchOfBeef.Scoring
local L = ChurchOfBeef.Ladder
L:ResetForTests()
S:ResetForTests()

--------------------------------------------------------------------------------
-- The brief's block
--------------------------------------------------------------------------------
assert_eq(S:GrantInstanceBucket("A", 1000, false), 0, "AFK bucket pays 0")
assert_eq(S:GrantInstanceBucket("A", 1000, true), 5, "combat bucket pays")
assert_eq(L:GetRecord("A").standing, 5, "standing updated")

-- Cap: 60/day instance -> 12 buckets max
for i = 1, 20 do S:GrantInstanceBucket("A", 1000 + i, true) end
assert_true(L:GetRecord("A").standing <= 60, "instance daily cap")

L:ResetForTests(); S:ResetForTests()
S:GrantGora("B", "loss", 1)
assert_eq(L:GetRecord("B").standing, 8, "loss still pays")

--------------------------------------------------------------------------------
-- Constants are canon for scoring; call sites must not hardcode them
--------------------------------------------------------------------------------
assert_eq(S.Points.InstanceBucket, 5, "instance bucket is 5 points")
assert_eq(S.Points.InstanceComplete, 20, "instance completion is 20 points")
assert_eq(S.Points.Ceremony, 40, "ceremony is 40 points")
assert_eq(S.Points.GoraWin, 25, "gora win is 25 points")
assert_eq(S.Points.GoraDraw, 10, "gora draw is 10 points")
assert_eq(S.Points.GoraLoss, 8, "gora loss is 8 points")
assert_eq(S.DailyCaps.instance, 60, "instance daily cap is 60")
assert_eq(S.DailyCaps.ceremony, 80, "ceremony daily cap is 80")
assert_eq(S.DailyCaps.gora, 100, "gora daily cap is 100")

--------------------------------------------------------------------------------
-- Anti-AFK: a bucket with no combat pays nothing and spends no cap
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
for i = 1, 30 do S:GrantInstanceBucket("Idler", 1000 + i, false) end
assert_eq(L:GetRecord("Idler").standing, 0, "an AFK dungeon night earns nothing")
assert_eq(S:GetGranted("Idler", "instance", 1000), 0, "AFK buckets do not spend the daily cap")
assert_eq(S:GrantInstanceBucket("Idler", 2000, nil), 0, "a nil combat flag pays 0")
assert_eq(S:GrantInstanceBucket("Idler", 2000, true), 5, "the cap was still whole for a real bucket")

--------------------------------------------------------------------------------
-- The instance cap is exact, and clamps the final partial grant
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
for i = 1, 12 do
  assert_eq(S:GrantInstanceBucket("Grinder", 1000 + i, true), 5, "bucket " .. i .. " pays in full")
end
assert_eq(L:GetRecord("Grinder").standing, 60, "twelve buckets reach the cap exactly")
assert_eq(S:GrantInstanceBucket("Grinder", 1100, true), 0, "the thirteenth bucket pays nothing")
assert_eq(S:GrantInstanceComplete("Grinder", 1100), 0, "a capped source pays no completion bonus")
assert_eq(L:GetRecord("Grinder").standing, 60, "standing stops at the cap")

L:ResetForTests(); S:ResetForTests()
assert_eq(S:Grant("Partial", "instance", 58, 1000), 58, "a large grant under the cap pays in full")
assert_eq(S:GrantInstanceBucket("Partial", 1000, true), 2, "the last bucket is clamped to what is left")
assert_eq(L:GetRecord("Partial").standing, 60, "clamped grant lands exactly on the cap")

--------------------------------------------------------------------------------
-- Instance buckets and the completion bonus share one source cap
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
assert_eq(S:GrantInstanceComplete("Runner", 1000), 20, "completion bonus pays 20")
assert_eq(S:GetGranted("Runner", "instance", 1000), 20, "completion spends the instance cap")
assert_eq(S:GrantInstanceComplete("Runner", 1000), 20, "a second run still pays")
assert_eq(S:GrantInstanceComplete("Runner", 1000), 20, "a third run reaches the cap")
assert_eq(S:GrantInstanceComplete("Runner", 1000), 0, "a fourth run is capped out")
assert_eq(S:GrantInstanceBucket("Runner", 1000, true), 0, "buckets share the exhausted instance cap")

--------------------------------------------------------------------------------
-- Ceremony and Gora sources
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
assert_eq(S:GrantCeremony("Cleric", 1000), 40, "ceremony pays 40")
assert_eq(S:GrantCeremony("Cleric", 1000), 40, "a second ceremony pays")
assert_eq(S:GrantCeremony("Cleric", 1000), 0, "the ceremony cap is 80 a day")
assert_eq(L:GetRecord("Cleric").standing, 80, "ceremony standing stops at the cap")

L:ResetForTests(); S:ResetForTests()
assert_eq(S:GrantGora("Fighter", "win", 1000), 25, "a gora win pays 25")
assert_eq(S:GrantGora("Fighter", "draw", 1000), 10, "a gora draw pays 10")
assert_eq(S:GrantGora("Fighter", "loss", 1000), 8, "a gora loss pays 8")
assert_eq(S:GrantGora("Fighter", "WIN", 1000), 25, "outcomes are case-insensitive")
assert_eq(L:GetRecord("Fighter").standing, 68, "gora standing accumulates")
assert_eq(S:GrantGora("Fighter", "win", 1000), 25, "gora pays up to 100 a day")
assert_eq(S:GrantGora("Fighter", "win", 1000), 7, "the last gora is clamped to the cap")
assert_eq(S:GrantGora("Fighter", "win", 1000), 0, "the gora cap holds")
assert_eq(L:GetRecord("Fighter").standing, 100, "gora standing stops at the cap")

assert_eq(S:GrantGora("Fighter", "forfeit", 1000), 0, "an unknown outcome pays nothing")
assert_true(type(select(2, S:GrantGora("Fighter", "forfeit", 1000))) == "string", "unknown outcome explains itself")
assert_eq(S:GrantGora("Fighter", nil, 1000), 0, "a missing outcome pays nothing")

--------------------------------------------------------------------------------
-- Caps are per source, per member, per day
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
assert_eq(S:Grant("Split", "instance", 60, 1000), 60, "instance cap filled")
assert_eq(S:GrantCeremony("Split", 1000), 40, "an exhausted instance cap does not block ceremony")
assert_eq(S:GrantGora("Split", "win", 1000), 25, "an exhausted instance cap does not block gora")
assert_eq(S:GrantInstanceBucket("Other", 1000, true), 5, "one member's cap does not block another's")

-- Local noon on a summer day, so the next-day arithmetic is DST-proof in any timezone.
local noon = os.time({ year = 2026, month = 7, day = 25, hour = 12, min = 0, sec = 0 })
local nextNoon = noon + 86400

assert_eq(S:GetDayKey(noon), S:GetDayKey(noon + 3600), "an hour later is the same day")
assert_true(S:GetDayKey(noon) ~= S:GetDayKey(nextNoon), "a day later is a different day")
assert_true(type(S:GetDayKey(noon)) == "string", "the day key is a string")

L:ResetForTests(); S:ResetForTests()
assert_eq(S:Grant("Daily", "instance", 60, noon), 60, "day one fills the instance cap")
assert_eq(S:GrantInstanceBucket("Daily", noon, true), 0, "day one is spent")
assert_eq(S:GrantInstanceBucket("Daily", nextNoon, true), 5, "the cap resets the next day")
assert_eq(S:GetGranted("Daily", "instance", nextNoon), 5, "the new day starts a fresh tally")
assert_eq(L:GetRecord("Daily").standing, 65, "standing itself never resets")

-- Reading about another day must not roll today's tally over.
assert_eq(S:GetGranted("Daily", "instance", noon), 0, "yesterday reads as nothing spent")
assert_eq(S:GetGranted("Daily", "instance", nextNoon), 5, "the query did not clear today's tally")
assert_eq(S:GetRemaining("Daily", "instance", nextNoon), 55, "remaining cap accounts for what was spent")
assert_eq(S:GetRemaining("Daily", "chores", nextNoon), 0, "an unknown source has no budget")

--------------------------------------------------------------------------------
-- Grants feed the suggestion queue but never promote
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
S:GrantGora("Climber", "win", 1000)
assert_eq(#L:GetSuggestions(), 0, "25 points is short of Cooked Beef")
S:GrantGora("Climber", "win", 1000)
assert_eq(L:GetRecord("Climber").standing, 50, "two wins reach the first threshold")
assert_eq(#L:GetSuggestions(), 1, "crossing a threshold queues a suggestion")
assert_eq(L:GetSuggestions()[1].toRankId, 2, "the suggestion targets Cooked Beef")
assert_eq(L:GetRecord("Climber").rankId, 1, "scoring never promotes on its own")
assert_eq(L:GetRecord("Climber").revision, 0, "advisory standing does not bump the revision")

-- A member who cannot be suggested any higher still banks points safely.
L:ResetForTests(); S:ResetForTests()
L:BestowProphet("Anointed", "Pope", 10)
assert_eq(S:GrantCeremony("Anointed", 1000), 40, "an appointed rank still earns standing")
assert_eq(#L:GetSuggestions(), 0, "an appointed rank is never suggested")

--------------------------------------------------------------------------------
-- Bad input pays nothing and changes nothing
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
assert_eq(S:Grant(nil, "instance", 5, 1000), 0, "a nil name pays nothing")
assert_eq(S:Grant("", "instance", 5, 1000), 0, "an empty name pays nothing")
assert_eq(S:Grant("   ", "instance", 5, 1000), 0, "a whitespace name pays nothing")
assert_eq(S:Grant("Bad", "chores", 5, 1000), 0, "an unknown source pays nothing")
assert_eq(S:Grant("Bad", nil, 5, 1000), 0, "a nil source pays nothing")
assert_eq(S:Grant("Bad", "instance", -5, 1000), 0, "a negative grant pays nothing")
assert_eq(S:Grant("Bad", "instance", 0, 1000), 0, "a zero grant pays nothing")
assert_eq(S:Grant("Bad", "instance", "5", 1000), 0, "a string amount pays nothing")
assert_eq(S:Grant("Bad", "instance", nil, 1000), 0, "a nil amount pays nothing")
assert_true(type(select(2, S:Grant("Bad", "chores", 5, 1000))) == "string", "a rejected grant explains itself")
assert_eq(L:GetRecord("Bad").standing, 0, "no bad grant touched standing")
assert_eq(#L:GetLadderView(), 0, "no bad grant created a record")

-- A grant that is capped out is not an error, just a zero.
assert_eq(S:Grant("Full", "instance", 60, 1000), 60, "fill the cap")
assert_eq(select(2, S:Grant("Full", "instance", 5, 1000)), nil, "hitting the cap is not an error")

-- Names are trimmed the same way the ladder trims them.
L:ResetForTests(); S:ResetForTests()
assert_eq(S:Grant("  Spaced  ", "gora", 8, 1000), 8, "a padded name is accepted")
assert_eq(L:GetRecord("Spaced").standing, 8, "the grant landed on the trimmed name")
assert_eq(S:GetGranted("Spaced", "gora", 1000), 8, "the tally is keyed on the trimmed name")

--------------------------------------------------------------------------------
-- Grant history (feeds the My Standing tab)
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
assert_eq(#S:GetHistory("Nobody"), 0, "an unknown member has no history")
S:GrantInstanceBucket("Historian", 1000, true)
S:GrantGora("Historian", "loss", 1001)
S:GrantInstanceBucket("Historian", 1002, false)

local history = S:GetHistory("Historian")
assert_eq(#history, 2, "only paying grants are recorded")
assert_eq(history[1].source, "gora", "history is newest first")
assert_eq(history[1].amount, 8, "history records what was actually paid")
assert_eq(history[1].at, 1001, "history records when")
assert_eq(history[2].source, "instance", "the older grant follows")

history[1].amount = 999
assert_eq(S:GetHistory("Historian")[1].amount, 8, "GetHistory hands out copies")

-- One grant per day, so the daily cap never silences a grant and every one is logged.
for i = 1, 40 do S:Grant("Historian", "gora", 8, noon + i * 86400) end
assert_eq(#S:GetHistory("Historian"), 20, "history is capped at 20 entries")
assert_eq(S:GetHistory("Historian")[1].at, noon + 40 * 86400, "the newest grant survives the ring buffer")

--------------------------------------------------------------------------------
-- Export / import so a /reload cannot hand back a spent daily cap
--------------------------------------------------------------------------------
L:ResetForTests(); S:ResetForTests()
S:Grant("Saver", "instance", 55, noon)
S:GrantCeremony("Saver", noon)
local state = S:ExportState()
assert_eq(state.dayKey, S:GetDayKey(noon), "export carries the day key")

S:ResetForTests()
assert_eq(S:GetGranted("Saver", "instance", noon), 0, "reset cleared the tally")

S:ImportState(state, noon)
assert_eq(S:GetGranted("Saver", "instance", noon), 55, "import restores the instance tally")
assert_eq(S:GetGranted("Saver", "ceremony", noon), 40, "import restores the ceremony tally")
assert_eq(S:GrantInstanceBucket("Saver", noon, true), 5, "the restored cap still has room")
assert_eq(S:GrantInstanceBucket("Saver", noon, true), 0, "the restored cap then holds")

-- Yesterday's tally must not follow the player into today.
S:ResetForTests()
S:ImportState(state, nextNoon)
assert_eq(S:GetGranted("Saver", "instance", nextNoon), 0, "a stale day imports as a fresh day")
assert_eq(S:GrantInstanceBucket("Saver", nextNoon, true), 5, "the new day pays")

-- An unwritten SavedVariables key must not refund the day's spending.
S:ResetForTests()
S:ImportState(state, noon)
S:ImportState(nil, noon)
assert_eq(S:GetGranted("Saver", "instance", noon), 55, "a nil import leaves live tallies alone")
S:ImportState("scoring", noon)
assert_eq(S:GetGranted("Saver", "instance", noon), 55, "a non-table import leaves live tallies alone")

S:ResetForTests()
S:ImportState({ dayKey = S:GetDayKey(noon), granted = { [S:GetDayKey(noon)] = { Junk = "nope" } } }, noon)
assert_eq(S:GetGranted("Junk", "instance", noon), 0, "malformed tallies are dropped")

-- Exported state is a copy; mutating it cannot rewrite the live tally.
S:ResetForTests()
S:Grant("Copy", "gora", 25, noon)
local exported = S:ExportState()
exported.granted[exported.dayKey]["Copy"].gora = 0
assert_eq(S:GetGranted("Copy", "gora", noon), 25, "ExportState hands out a copy")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the test harness
--------------------------------------------------------------------------------
-- The flag flip lives inside pcall with a guaranteed restore, so a raise here
-- can never leave a later suite running with _IN_TEST = false.
L:ResetForTests(); S:ResetForTests()
S:Grant("Survivor", "instance", 20, 1000)

ChurchOfBeef._IN_TEST = false
local probeOk, probeErr = pcall(function()
  assert_eq(S:ResetForTests(), false, "ResetForTests refuses to run outside tests")
  assert_eq(S:GetGranted("Survivor", "instance", 1000), 20, "tallies survive a gated reset")
end)
ChurchOfBeef._IN_TEST = true
assert_true(probeOk, "_IN_TEST=false probe raised: " .. tostring(probeErr))

assert_eq(S:ResetForTests(), true, "ResetForTests runs under COB._IN_TEST")
assert_eq(S:GetGranted("Survivor", "instance", 1000), 0, "the ungated reset cleared the tally")
