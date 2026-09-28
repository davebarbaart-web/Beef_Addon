-- Guild roster sensing: names, guildRankIndex, completeness, local-player seed.
-- ChurchRankIdForGuildIndex is a nil stub (Bible §5). Members must still land
-- so the Quiet shell can leave "Reading the guild roster…".
-- Do not dofile Ladder or Scoring.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local stub = require("wow_ui_stub")
local restore = stub.install()

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Roster.lua")

local COB = ChurchOfBeef
local Ranks = COB.Ranks
local Roster = COB.Roster

assert_eq(Roster.GetLadderView, nil, "GetLadderView is deleted")
assert_eq(Roster.ClearSatisfiedSuggestions, nil, "ClearSatisfiedSuggestions is deleted")
assert_eq(Roster.SweepDeparted, nil, "no departed sweep")

assert_eq(Ranks.ChurchRankIdForGuildIndex(0), nil, "GM index is not a Church rank")
assert_eq(Ranks.ChurchRankIdForGuildIndex(6), nil, "no 0→7 map")

assert_eq(Roster.NameKey("Steakina-Nightslayer"), "steakina", "NameKey folds realm and case")
assert_eq(Roster.NameKey("Popeina"), "popeina", "NameKey is the spelling key")

Roster:ResetForTests()
assert_eq(Roster:IsReady(), false, "unread before Refresh")
assert_eq(Roster:IsComplete(), false, "unread is not complete")
assert_eq(Roster:GetOccupantCount(), 0, "no occupants before a snapshot")
assert_eq(Roster:GetGeneration(), 0, "generation starts at 0")
assert_eq(Roster:HasMember("Popeina"), false, "HasMember fails closed while unread")
assert_eq(Roster:GetGuildRankIndex("Popeina"), nil, "no display index while unread")
assert_eq(Roster:GetChurchRankId("Popeina"), nil, "no Church id while unread")

stub.inGuild = true
stub.guildRoster = {
  { name = "Popeina", rankIndex = 0, rankName = "Guild Master" },
  { name = "Beefina", rankIndex = 6, rankName = "Beef Knight" },
  { name = "Steakina-Nightslayer", rankIndex = 6 },
}

assert_true(Roster:Refresh(), "Refresh reads stub roster without a Church-rank map")
assert_eq(Roster:IsReady(), true, "ready after a guild walk even when every Church id is nil")
assert_eq(Roster:IsComplete(), true, "a full walk is complete")
assert_eq(Roster:GetOccupantCount(), 3, "all three names are kept")
assert_true(Roster:GetGeneration() > 0, "accepted snapshot bumps generation")
assert_eq(Roster:HasMember("Popeina"), true, "HasMember sees the GM")
assert_eq(Roster:HasMember("popeina"), true, "HasMember folds case")
assert_eq(Roster:HasMember("Steakina-Nightslayer"), true, "HasMember accepts realm form")
assert_eq(Roster:HasMember("Steakina"), true, "HasMember matches the character part")
assert_eq(Roster:HasMember("Nobody"), false, "unknown name is not a member")
assert_eq(Roster:GetGuildRankIndex("Popeina"), 0, "guild rankIndex is display only")
assert_eq(Roster:GetGuildRankIndex("Beefina"), 6, "display index 6 is kept")
assert_eq(Roster:GetGuildRankName("Popeina"), "Guild Master", "GM slot keeps its live name")
assert_eq(Roster:GetGuildRankName("Beefina"), "Beef Knight", "roster keeps a canon guild rank name")
assert_eq(Roster:GetGuildRankName("Steakina"), "Beefling", "unnamed entries keep the stub fallback")
assert_eq(Roster:GetChurchRankId("Popeina"), nil, "Church store is empty this phase")
assert_eq(Roster:GetChurchRankId("Beefina"), nil, "a matching title is not written as Church truth")
assert_eq(Roster:GetChurchRankId("Nobody"), nil, "unknown name has no Church id")
assert_eq(Roster:GetGuildRankName("Nobody"), nil, "unknown name has no guild rank name")

-- A failed/empty read must not wipe a good snapshot (Classic empty-update race).
stub.guildRoster = {}
assert_eq(Roster:Refresh(), true, "empty update reports prior readiness")
assert_eq(Roster:IsReady(), true, "prior snapshot kept")
assert_eq(Roster:IsComplete(), true, "prior complete walk is not forgotten")
assert_eq(Roster:HasMember("Popeina"), true, "names survive an empty update")
assert_eq(Roster:GetOccupantCount(), 3, "occupant count survives an empty update")

-- Leaving the guild clears the snapshot. History prune is not this module.
stub.inGuild = false
assert_eq(Roster:Refresh(), false, "unguilded Refresh reports empty")
assert_eq(Roster:IsReady(), false, "unguilded snapshot is cleared")
assert_eq(Roster:IsComplete(), false, "unguilded is not complete")
assert_eq(Roster:GetOccupantCount(), 0, "unguilded has no occupants")
assert_eq(Roster:HasMember("Popeina"), false, "guild names do not linger after leave")

-- Local player seeds from GetGuildInfo when the roster walk is still empty.
Roster:ResetForTests()
stub.inGuild = true
stub.guildRoster = {}
stub.playerName = "Popeina"
stub.guildRankIndex = 0
assert_true(Roster:Refresh(), "GetGuildInfo seed makes a snapshot without a Church id")
assert_eq(Roster:IsReady(), true, "seeded player is enough to leave roster_wait")
assert_eq(Roster:IsComplete(), false, "a seed is not a full guild walk")
assert_eq(Roster:GetOccupantCount(), 1, "seed is one occupant")
assert_eq(Roster:HasMember("Popeina"), true, "seeded local player is present")
assert_eq(Roster:GetChurchRankId("Popeina"), nil, "seed does not invent a Church rank")
assert_eq(Roster:GetGuildRankIndex("Popeina"), 0, "seed keeps display rankIndex")
assert_eq(Roster:GetGuildRankName("Popeina"), "Beefling", "seed keeps the GetGuildInfo rank name")

restore()
