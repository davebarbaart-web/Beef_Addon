-- SavedVariables DB: defaults, migrate/merge, standing+scoring round-trip.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Roster.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local L = ChurchOfBeef.Ladder
local Roster = ChurchOfBeef.Roster
local S = ChurchOfBeef.Scoring
local DB = ChurchOfBeef.DB

local function mapFresh(name)
  Roster.ready = true
  Roster.members[name:lower()] = {
    name = name,
    guildRankIndex = 6,
    churchRankId = 1,
  }
end

L:ResetForTests()
S:ResetForTests()
Roster:ResetForTests()

--------------------------------------------------------------------------------
-- First run creates the schema stamp and nested defaults
--------------------------------------------------------------------------------
ChurchOfBeefDB = nil
local db = DB:Init()
assert_true(db ~= nil, "Init returns the SV table")
assert_eq(ChurchOfBeefDB.version, 3, "schema version is 3")
assert_eq(ChurchOfBeefDB.ui.announce, true, "announce defaults on")
assert_eq(ChurchOfBeefDB.ui.shown, false, "frame starts hidden")
assert_eq(ChurchOfBeefDB.ui.point, nil, "no saved point yet")
assert_true(type(ChurchOfBeefDB.ladder.records) == "table", "ladder.records table")
assert_true(type(ChurchOfBeefDB.ladder.suggestions) == "table", "ladder.suggestions table")
assert_true(type(ChurchOfBeefDB.scoring.granted) == "table", "scoring.granted table")

--------------------------------------------------------------------------------
-- Standing and pending suggestions survive Save → wipe modules → Init
--------------------------------------------------------------------------------
L:ResetForTests()
S:ResetForTests()
Roster:ResetForTests()
ChurchOfBeefDB = nil
DB:Init()
mapFresh("Beefina")
mapFresh("Other")

local noon = os.time({ year = 2026, month = 7, day = 25, hour = 12, min = 0, sec = 0 })
L:SetStanding("Beefina", 50)
local sug = L:MaybeSuggest("Beefina")
assert_true(sug ~= nil, "suggestion queued before save")
assert_eq(S:GrantInstanceBucket("Beefina", noon, true), 5, "scoring grant before save")
L:SetStanding("Other", 60)

assert_true(DB:Save(), "Save flushes Core into SV")
assert_eq(#ChurchOfBeefDB.ladder.records, 2, "two standing rows persisted")
assert_eq(#ChurchOfBeefDB.ladder.suggestions, 1, "pending suggestion persisted")
assert_eq(ChurchOfBeefDB.scoring.dayKey, S:GetDayKey(noon), "scoring dayKey persisted")

L:ResetForTests()
S:ResetForTests()
assert_eq(L:GetStanding("Beefina"), 0, "modules cleared before reload")
assert_eq(#L:GetSuggestions(), 0, "suggestions cleared before reload")

DB:Init(noon)
mapFresh("Beefina")
mapFresh("Other")
assert_eq(L:GetStanding("Beefina"), 55, "standing round-trips via SV")
assert_eq(L:GetRecord("Beefina").rankId, 1, "display rank comes from roster map")
assert_eq(L:GetStanding("Other"), 60, "second standing row round-trips")
assert_eq(#L:GetSuggestions(), 1, "suggestion round-trips")
assert_eq(L:GetSuggestions()[1].name, "Beefina", "suggestion name preserved")
assert_eq(S:GetGranted("Beefina", "instance", noon), 5, "daily cap tally round-trips")

--------------------------------------------------------------------------------
-- v1 → v3 migration strips legacy official rank fields (v2 standing + v3 rites stamp)
--------------------------------------------------------------------------------
ChurchOfBeefDB = {
  version = 1,
  ui = { announce = true, shown = false },
  ladder = {
    records = {
      { name = "Legacy", rankId = 5, standing = 80, revision = 3, updatedAt = 1, updatedBy = "Pope" },
    },
    suggestions = {},
  },
  scoring = { dayKey = "", granted = {} },
}
L:ResetForTests()
S:ResetForTests()
DB:Init(noon)
assert_eq(ChurchOfBeefDB.version, 3, "migrates to schema 3")
assert_eq(L:GetStanding("Legacy"), 80, "migration keeps standing")
assert_eq(ChurchOfBeefDB.ladder.records[1].revision, 0, "migration clears revision authority")

--------------------------------------------------------------------------------
-- Defaults merge never wipes unknown future keys
--------------------------------------------------------------------------------
ChurchOfBeefDB.futureRoot = "keep-me"
ChurchOfBeefDB.ui.streamerMode = true
ChurchOfBeefDB.ui.announce = nil

DB:Init(noon)
assert_eq(ChurchOfBeefDB.futureRoot, "keep-me", "unknown root key survives Init")
assert_eq(ChurchOfBeefDB.ui.streamerMode, true, "unknown ui key survives Init")
assert_eq(ChurchOfBeefDB.ui.announce, true, "missing announce is filled")
assert_eq(L:GetStanding("Legacy"), 80, "re-Init does not drop standing cache")
