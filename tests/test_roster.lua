-- Roster-backed ladder: guild rankIndex → Church title, ladder view from roster.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local stub = require("wow_ui_stub")
local restore = stub.install()

dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
dofile("addon/ChurchOfBeef/Core/Roster.lua")

local COB = ChurchOfBeef
local Ranks = COB.Ranks
local Roster = COB.Roster
local Ladder = COB.Ladder

assert_eq(Ranks.ChurchRankIdForGuildIndex(0), 7, "GM → Prophet")
assert_eq(Ranks.ChurchRankIdForGuildIndex(1), 6, "index 1 → Council")
assert_eq(Ranks.ChurchRankIdForGuildIndex(2), 5, "index 2 → Butcher")
assert_eq(Ranks.ChurchRankIdForGuildIndex(3), 4, "index 3 → Lord")
assert_eq(Ranks.ChurchRankIdForGuildIndex(4), 3, "index 4 → Knight")
assert_eq(Ranks.ChurchRankIdForGuildIndex(5), 2, "index 5 → Cooked")
assert_eq(Ranks.ChurchRankIdForGuildIndex(6), 1, "index 6 → Fresh")
assert_eq(Ranks.ChurchRankIdForGuildIndex(9), 1, "index 9 → Fresh")
assert_eq(Ranks.ChurchRankIdForGuildIndex(nil), nil, "nil index maps to nil")

Ladder:ResetForTests()
Roster:ResetForTests()

stub.guildRoster = {
  { name = "Popeina", rankIndex = 0 },
  { name = "Cardinal", rankIndex = 1 },
  { name = "Butcherina", rankIndex = 2 },
  { name = "Beefina", rankIndex = 6 },
  { name = "Steakina-Nightslayer", rankIndex = 6 },
}

assert_eq(Roster:IsReady(), false, "unread before Refresh")
assert_true(Roster:Refresh(), "Refresh reads stub roster")
assert_eq(Roster:IsReady(), true, "ready after Refresh")
assert_eq(Roster:GetChurchRankId("Popeina"), 7, "Popeina is Prophet")
assert_eq(Roster:GetChurchRankId("Cardinal"), 6, "Cardinal is Council")
assert_eq(Roster:GetChurchRankId("Butcherina"), 5, "Butcherina is Butcher")
assert_eq(Roster:GetChurchRankId("Beefina"), 1, "Beefina is Fresh Beef")
assert_eq(Roster:GetChurchRankId("Steakina"), 1, "realm suffix stripped for lookup")
assert_eq(Roster:HasMember("Steakina-Nightslayer"), true, "HasMember accepts realm form")

Ladder:SetStanding("Beefina", 12)
local view = Roster:GetLadderView()
assert_eq(#view, 5, "all five roster members appear")
local byName = {}
for i = 1, #view do byName[view[i].name] = view[i] end
assert_eq(byName.Popeina.rankId, 7, "view maps GM to Prophet")
assert_eq(byName.Beefina.standing, 12, "view merges Ladder standing")
assert_eq(byName.Steakina.rankId, 1, "display name drops realm")

-- Suggestion clears when roster rank already meets the target.
Ladder:SetStanding("Beefina", 50)
stub.guildRoster[4] = { name = "Beefina", rankIndex = 6 } -- still Fresh
Roster:Refresh()
local sug = Ladder:MaybeSuggest("Beefina")
assert_true(sug ~= nil, "Fresh Beef at 50 suggests Cooked")
assert_eq(sug.toRankId, 2, "target Cooked Beef")

stub.guildRoster[4] = { name = "Beefina", rankIndex = 5 } -- promoted in guild UI
Roster:Refresh()
assert_eq(Roster:GetChurchRankId("Beefina"), 2, "promoted to Cooked in roster")
assert_eq(#Ladder:GetSuggestions(), 0, "satisfied suggestion auto-cleared")

-- No suggest without a roster snapshot for the name.
Ladder:ResetForTests()
Roster:ResetForTests()
Ladder:SetStanding("Ghost", 999)
assert_eq(Ladder:MaybeSuggest("Ghost"), nil, "unknown to roster → no suggestion")

-- A failed/empty read must not wipe a good snapshot (Classic empty-update race).
stub.guildRoster = {
  { name = "Popeina", rankIndex = 0 },
  { name = "Beefina", rankIndex = 6 },
}
assert_true(Roster:Refresh(), "seed a good snapshot")
assert_eq(Roster:IsReady(), true, "ready after seed")
stub.guildRoster = {}
assert_eq(Roster:Refresh(), true, "empty update reports prior readiness")
assert_eq(Roster:IsReady(), true, "prior snapshot kept")
assert_eq(Roster:GetChurchRankId("Popeina"), 7, "GM still mapped after empty update")

-- String rank indices still map (some client stubs coerce oddly).
stub.guildRoster = { { name = "Stringina", rankIndex = "5" } }
assert_true(Roster:Refresh(), "string rankIndex accepted via tonumber")
assert_eq(Roster:GetChurchRankId("Stringina"), 2, "string 5 → Cooked Beef")

-- Local player seeds from GetGuildInfo when the roster walk is still empty.
Roster:ResetForTests()
stub.guildRoster = {}
stub.playerName = "Popeina"
stub.guildRankIndex = 0
stub.inGuild = true
assert_true(Roster:Refresh(), "GetGuildInfo seed makes a snapshot")
assert_eq(Roster:GetChurchRankId("Popeina"), 7, "seeded GM maps to Prophet")
assert_eq(#Roster:GetLadderView(), 1, "seeded ladder has the local player")

restore()
