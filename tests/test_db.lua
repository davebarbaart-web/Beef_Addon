-- SavedVariables DB: defaults, migrate/merge, ladder+scoring round-trip.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local L = ChurchOfBeef.Ladder
local S = ChurchOfBeef.Scoring
local DB = ChurchOfBeef.DB

L:ResetForTests()
S:ResetForTests()

--------------------------------------------------------------------------------
-- First run creates the schema stamp and nested defaults
--------------------------------------------------------------------------------
ChurchOfBeefDB = nil
local db = DB:Init()
assert_true(db ~= nil, "Init returns the SV table")
assert_eq(ChurchOfBeefDB.version, 1, "schema version is 1")
assert_eq(ChurchOfBeefDB.ui.announce, true, "announce defaults on")
assert_eq(ChurchOfBeefDB.ui.shown, false, "frame starts hidden")
assert_eq(ChurchOfBeefDB.ui.point, nil, "no saved point yet")
assert_true(type(ChurchOfBeefDB.ladder.records) == "table", "ladder.records table")
assert_true(type(ChurchOfBeefDB.ladder.suggestions) == "table", "ladder.suggestions table")
assert_true(type(ChurchOfBeefDB.scoring.granted) == "table", "scoring.granted table")

--------------------------------------------------------------------------------
-- Records and pending suggestions survive Save → wipe modules → Init
--------------------------------------------------------------------------------
L:ResetForTests()
S:ResetForTests()
ChurchOfBeefDB = nil
DB:Init()

local noon = os.time({ year = 2026, month = 7, day = 25, hour = 12, min = 0, sec = 0 })
L:SetStanding("Beefina", 50)
local sug = L:MaybeSuggest("Beefina")
assert_true(sug ~= nil, "suggestion queued before save")
assert_eq(S:GrantInstanceBucket("Beefina", noon, true), 5, "scoring grant before save")
L:Commit("Other", 2, 60, "Pope", noon)

assert_true(DB:Save(), "Save flushes Core into SV")
assert_eq(#ChurchOfBeefDB.ladder.records, 2, "two records persisted")
assert_eq(#ChurchOfBeefDB.ladder.suggestions, 1, "pending suggestion persisted")
assert_eq(ChurchOfBeefDB.scoring.dayKey, S:GetDayKey(noon), "scoring dayKey persisted")

L:ResetForTests()
S:ResetForTests()
assert_eq(L:GetRecord("Beefina").standing, 0, "modules cleared before reload")
assert_eq(#L:GetSuggestions(), 0, "suggestions cleared before reload")

-- Pass noon so Scoring day-key import matches the grant (harness time() is epoch 0).
DB:Init(noon)
assert_eq(L:GetRecord("Beefina").standing, 55, "standing round-trips via SV")
assert_eq(L:GetRecord("Beefina").rankId, 1, "uncommitted rank stays Fresh")
assert_eq(L:GetRecord("Other").rankId, 2, "committed rank round-trips")
assert_eq(L:GetRecord("Other").revision, 1, "revision round-trips")
assert_eq(#L:GetSuggestions(), 1, "suggestion round-trips")
assert_eq(L:GetSuggestions()[1].name, "Beefina", "suggestion name preserved")
assert_eq(S:GetGranted("Beefina", "instance", noon), 5, "daily cap tally round-trips")

--------------------------------------------------------------------------------
-- Defaults merge never wipes unknown future keys (forward-compatible SV)
--------------------------------------------------------------------------------
ChurchOfBeefDB.futureRoot = "keep-me"
ChurchOfBeefDB.ui.streamerMode = true
ChurchOfBeefDB.version = 1
-- Simulate a partial upgrade missing a nested key
ChurchOfBeefDB.ui.announce = nil

DB:Init(noon)
assert_eq(ChurchOfBeefDB.futureRoot, "keep-me", "unknown root key survives Init")
assert_eq(ChurchOfBeefDB.ui.streamerMode, true, "unknown ui key survives Init")
assert_eq(ChurchOfBeefDB.ui.announce, true, "missing announce is filled")
assert_eq(L:GetRecord("Beefina").standing, 55, "re-Init does not drop ladder cache")

--------------------------------------------------------------------------------
-- A higher future schema stamp is not down-migrated
--------------------------------------------------------------------------------
ChurchOfBeefDB.version = 99
DB:Init(noon)
assert_eq(ChurchOfBeefDB.version, 99, "future schema stamp is left alone")

--------------------------------------------------------------------------------
-- Rejected suggestion stays gone across Save/Init (not recomputed from standing)
--------------------------------------------------------------------------------
L:ResetForTests()
S:ResetForTests()
ChurchOfBeefDB = nil
DB:Init(noon)
L:SetStanding("Rejected", 50)
L:MaybeSuggest("Rejected")
assert_true(L:RejectSuggestion("Rejected"), "officer rejects")
DB:Save()
L:ResetForTests()
DB:Init(noon)
assert_eq(#L:GetSuggestions(), 0, "rejected suggestion does not reappear after reload")
assert_eq(L:GetRecord("Rejected").standing, 50, "standing still present after reject+reload")

--------------------------------------------------------------------------------
-- State-changing paths flush to SV as they happen, not only at PLAYER_LOGOUT
--------------------------------------------------------------------------------
local realDb = ChurchOfBeef.DB
local saves = 0
ChurchOfBeef.DB = { Save = function() saves = saves + 1 return true end }

L:ResetForTests()
S:ResetForTests()

assert_true(L:Commit("Flushed", 2, 50, "Pope", noon) ~= nil, "commit succeeds")
assert_eq(saves, 1, "a commit flushes the DB")

assert_eq(select(1, L:Commit("Flushed", 99, 0, "Pope", noon)), nil, "invalid commit rejected")
assert_eq(saves, 1, "a rejected commit does not flush")

assert_true(L:Demote("Flushed", 1, "Pope", noon) ~= nil, "demotion succeeds")
assert_eq(saves, 2, "a demotion flushes once through Commit, not twice")

assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 3, standing = 10, revision = 2, updatedAt = 5, updatedBy = "Pope",
}), true, "remote commit applies")
assert_eq(saves, 3, "an applied remote commit flushes the DB")

assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 1, standing = 0, revision = 1, updatedAt = 4, updatedBy = "Pope",
}), false, "stale remote commit ignored")
assert_eq(saves, 3, "an ignored remote commit does not flush")

assert_eq(S:GrantInstanceBucket("Flushed", noon, true), 5, "grant pays out")
assert_eq(saves, 4, "a paid grant flushes the DB")

assert_eq(S:GrantInstanceBucket("Flushed", noon, false), 0, "an AFK bucket pays nothing")
assert_eq(saves, 4, "a zero grant does not flush")

L:SetStanding("RejectSpy", 50)
L:MaybeSuggest("RejectSpy")
assert_true(L:RejectSuggestion("RejectSpy"), "reject succeeds")
assert_eq(saves, 5, "a suggestion reject flushes the DB")
assert_eq(L:RejectSuggestion("RejectSpy"), false, "rejecting again is a no-op")
assert_eq(saves, 5, "a no-op reject does not flush")

ChurchOfBeef.DB = realDb
