-- Ladder standing + promote suggestions under the roster-backed model.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Roster.lua")

local L = ChurchOfBeef.Ladder
local Roster = ChurchOfBeef.Roster

local function setMapped(name, churchRankId)
  Roster.ready = true
  local key = name:lower()
  Roster.members[key] = {
    name = name,
    guildRankIndex = 0,
    churchRankId = churchRankId,
  }
end

L:ResetForTests()
Roster:ResetForTests()

--------------------------------------------------------------------------------
-- Unknown members read as Fresh Beef without writing a standing row
--------------------------------------------------------------------------------
local unknown = L:GetRecord("Nobody")
assert_eq(unknown.rankId, 1, "unknown member reads as Fresh Beef")
assert_eq(unknown.standing, 0, "unknown member has no standing")
assert_eq(L:HasOfficialRecord("Nobody"), false, "read does not create a standing row")
assert_eq(#L:GetLadderView(), 0, "empty roster → empty ladder view")

--------------------------------------------------------------------------------
-- Suggestions require a roster mapping
--------------------------------------------------------------------------------
L:SetStanding("Edge", 50)
assert_eq(L:MaybeSuggest("Edge"), nil, "no roster mapping → no suggestion")

setMapped("Edge", 1)
local first, firstIsNew = L:MaybeSuggest("Edge")
assert_true(first ~= nil, "threshold reached, suggestion created")
assert_eq(firstIsNew, true, "first suggestion reports as new")
assert_eq(first.fromRankId, 1, "suggestion carries the mapped rank")
assert_eq(first.toRankId, 2, "suggestion targets the next rank")

local again, againIsNew = L:MaybeSuggest("Edge")
assert_true(again ~= nil, "repeat call still returns the pending suggestion")
assert_eq(againIsNew, false, "repeat call does not report a new suggestion")
assert_eq(#L:GetSuggestions(), 1, "no duplicate suggestion queued")

L:SetStanding("Edge", 90)
assert_eq(L:MaybeSuggest("Edge").standing, 90, "pending suggestion shows current standing")

L:RejectSuggestion("Edge")
assert_eq(#L:GetSuggestions(), 0, "dismiss clears the suggestion")
assert_eq(L:GetStanding("Edge"), 90, "dismiss leaves standing untouched")

--------------------------------------------------------------------------------
-- One rank at a time; appointed bands never suggested from points
--------------------------------------------------------------------------------
L:ResetForTests()
Roster:ResetForTests()
setMapped("Rocket", 1)
L:SetStanding("Rocket", 999999)
assert_eq(L:MaybeSuggest("Rocket").toRankId, 2, "suggestions advance one rank at a time")

L:ResetForTests()
Roster:ResetForTests()
setMapped("Butcher", 5)
L:SetStanding("Butcher", 999999)
assert_eq(L:MaybeSuggest("Butcher"), nil, "Butcher is never auto-suggested into Council")

setMapped("Seated", 6)
L:SetStanding("Seated", 999999)
assert_eq(L:MaybeSuggest("Seated"), nil, "Council is never auto-suggested")

--------------------------------------------------------------------------------
-- Rank write paths refuse; remote commits are ignored
--------------------------------------------------------------------------------
local rec, err = L:Commit("Edge", 2, nil, "Pope", 1000)
assert_eq(rec, nil, "Commit refused")
assert_true(type(err) == "string" and err:find("guild", 1, true) ~= nil, "Commit names guild UI")

assert_eq(L:Demote("Edge", 1, "Pope"), nil, "Demote refused")
assert_eq(L:AppointCouncil("Edge", "Pope"), nil, "AppointCouncil refused")
assert_eq(L:BestowProphet("Edge", "Pope"), nil, "BestowProphet refused")
assert_eq(L:ApplyRemoteCommit({
  name = "Edge", rankId = 3, standing = 200, revision = 2,
  updatedAt = 2000, updatedBy = "Pope",
}), false, "remote rank commit ignored")

--------------------------------------------------------------------------------
-- Standing correction + export/import keep points only
--------------------------------------------------------------------------------
L:ResetForTests()
Roster:ResetForTests()
setMapped("Beefina", 1)
local corrected = L:CorrectStanding("Beefina", 40)
assert_eq(corrected.standing, 40, "CorrectStanding sets points")
assert_eq(L:GetRecord("Beefina").rankId, 1, "GetRecord rank comes from roster map")
assert_eq(#L:GetSuggestions(), 0, "below threshold → no suggestion from correction")

-- Solo smoke path (amendment §10): officer correction can enqueue a promote prompt.
local heard = 0
ChurchOfBeef.Net = {
  OnLocalSuggestion = function(_, suggestion)
    heard = heard + 1
    assert_eq(suggestion.toRankId, 2, "correction fanout targets Cooked Beef")
  end,
}
local atThreshold = L:CorrectStanding("Beefina", 50)
assert_eq(atThreshold.standing, 50, "CorrectStanding can set threshold standing")
assert_eq(#L:GetSuggestions(), 1, "correction crossing threshold enqueues suggestion")
assert_eq(heard, 1, "new suggestion notifies Net once")
heard = 0
L:CorrectStanding("Beefina", 60)
assert_eq(heard, 0, "repeat correction does not re-fanout the same petition")
ChurchOfBeef.Net = nil

local exported = L:ExportState()
assert_eq(#exported, 1, "one standing row exported")
assert_eq(exported[1].standing, 60, "standing exported")
assert_eq(exported[1].rankId, 1, "export stamps Fresh placeholder rankId")

L:ResetForTests()
assert_eq(L:ImportState(exported), 1, "import accepts standing row")
assert_eq(L:GetStanding("Beefina"), 60, "standing restored")
assert_eq(L:HasOfficialRecord("Beefina"), true, "import writes a standing row")

--------------------------------------------------------------------------------
-- Eligibility tags: rite flags coach Knight/Lord suggestions, never hard-block
--------------------------------------------------------------------------------
L:ResetForTests()
Roster:ResetForTests()
setMapped("Squire", 2) -- Cooked Beef → next is Knight
L:SetStanding("Squire", 200)
local knightSug, knightNew = L:MaybeSuggest("Squire")
assert_eq(knightNew, true, "Knight suggestion enqueues at threshold without rite")
assert_eq(knightSug.riteKind, "knighted", "Knight suggestion names rite")
assert_eq(knightSug.riteMet, false, "rite unmet still allows suggestion")
assert_eq(knightSug.standingMet, true, "standingMet true at enqueue")

L:SetRiteFlag("Squire", "knighted", true)
assert_eq(L:HasRiteFlag("Squire", "knighted"), true, "knighted flag set")
assert_eq(L:MaybeSuggest("Squire").riteMet, true, "checklist flips when knighted")

L:ResetForTests()
Roster:ResetForTests()
setMapped("Challenger", 3) -- Knight → next is Lord
L:SetStanding("Challenger", 500)
local lordSug = L:MaybeSuggest("Challenger")
assert_eq(lordSug.riteKind, "goraLordWin", "Lord suggestion names Gora rite")
assert_eq(lordSug.riteMet, false, "Lord suggestion without Gora win")
L:SetRiteFlag("Challenger", "goraLordWin", true)
assert_eq(L:MaybeSuggest("Challenger").riteMet, true, "Lord rite met after flag")

local ritesExported = L:ExportState()
L:ResetForTests()
L:ImportState(ritesExported)
assert_eq(L:HasRiteFlag("Challenger", "goraLordWin"), true, "rite flags survive export/import")
