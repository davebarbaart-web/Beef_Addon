-- Load ranks and ladder the same way the addon will, as chunks setting COB fields.
ChurchOfBeef = ChurchOfBeef or {}
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
local L = ChurchOfBeef.Ladder
L:ResetForTests()

L:SetStanding("Beefina", 50)
local sug = L:MaybeSuggest("Beefina")
assert_true(sug ~= nil, "suggestion at threshold")
assert_eq(sug.toRankId, 2, "suggest Cooked Beef")

local rec, err = L:Commit("Beefina", 2, 50, "Pope", 1000)
assert_true(rec ~= nil, "commit ok: " .. tostring(err))
assert_eq(rec.revision, 1, "revision starts at 1")
assert_eq(rec.rankId, 2, "committed rank")

-- Older revision must not overwrite
local applied = L:ApplyRemoteCommit({
  name = "Beefina", rankId = 1, standing = 0, revision = 1,
  updatedAt = 999, updatedBy = "Other",
})
assert_eq(applied, false, "same revision rejected")

applied = L:ApplyRemoteCommit({
  name = "Beefina", rankId = 3, standing = 200, revision = 2,
  updatedAt = 2000, updatedBy = "Pope",
})
assert_eq(applied, true, "higher revision applied")
assert_eq(L:GetRecord("Beefina").rankId, 3, "remote promote")

-- Council seat limit
L:ResetForTests()
for i = 1, 4 do
  local r, e = L:AppointCouncil("C"..i, "Pope", i)
  assert_true(r ~= nil, "appoint " .. i .. " " .. tostring(e))
end
local r, e = L:AppointCouncil("C5", "Pope", 5)
assert_true(r == nil, "fifth council blocked")
assert_true(type(e) == "string", "error string")

-- Prophet unique
L:ResetForTests()
assert_true(L:BestowProphet("A", "Pope", 1) ~= nil, "first prophet")
assert_true(select(1, L:BestowProphet("B", "Pope", 2)) == nil, "second prophet blocked")

--------------------------------------------------------------------------------
-- Unknown members read as Fresh Beef without being written into the ladder
--------------------------------------------------------------------------------
L:ResetForTests()
local unknown = L:GetRecord("Nobody")
assert_eq(unknown.rankId, 1, "unknown member reads as Fresh Beef")
assert_eq(unknown.standing, 0, "unknown member has no standing")
assert_eq(unknown.revision, 0, "unknown member has no revision")
assert_eq(#L:GetLadderView(), 0, "reading an unknown name does not create a record")

--------------------------------------------------------------------------------
-- Suggestion thresholds and de-duplication
--------------------------------------------------------------------------------
L:SetStanding("Edge", 49)
assert_eq(L:MaybeSuggest("Edge"), nil, "one point short of the threshold, no suggestion")

L:SetStanding("Edge", 50)
local first, firstIsNew = L:MaybeSuggest("Edge")
assert_true(first ~= nil, "threshold reached, suggestion created")
assert_eq(firstIsNew, true, "first suggestion reports as new")
assert_eq(first.fromRankId, 1, "suggestion carries the current rank")
assert_eq(first.toRankId, 2, "suggestion targets the next rank")

local again, againIsNew = L:MaybeSuggest("Edge")
assert_true(again ~= nil, "repeat call still returns the pending suggestion")
assert_eq(againIsNew, false, "repeat call does not report a new suggestion")
assert_eq(#L:GetSuggestions(), 1, "no duplicate suggestion queued")

-- A pending suggestion tracks standing earned after it was raised.
L:SetStanding("Edge", 90)
assert_eq(L:MaybeSuggest("Edge").standing, 90, "pending suggestion shows current standing")
assert_eq(L:GetSuggestions()[1].standing, 90, "queued suggestion shows current standing")

L:RejectSuggestion("Edge")
assert_eq(#L:GetSuggestions(), 0, "reject clears the suggestion")
assert_eq(L:GetRecord("Edge").standing, 90, "reject leaves standing untouched")

-- Standing far past several thresholds still only advances one rank at a time.
L:ResetForTests()
L:SetStanding("Rocket", 999999)
assert_eq(L:MaybeSuggest("Rocket").toRankId, 2, "suggestions advance one rank at a time")

--------------------------------------------------------------------------------
-- Appointed ranks are never auto-suggested
--------------------------------------------------------------------------------
L:ResetForTests()
L:Commit("Butcher", 5, 1000, "Pope", 10)
L:SetStanding("Butcher", 999999)
assert_eq(L:MaybeSuggest("Butcher"), nil, "Butcher is never auto-suggested into Council")

L:ResetForTests()
L:AppointCouncil("Seated", "Pope", 10)
L:SetStanding("Seated", 999999)
assert_eq(L:MaybeSuggest("Seated"), nil, "a Council member is never auto-suggested")

L:ResetForTests()
L:BestowProphet("Anointed", "Pope", 10)
L:SetStanding("Anointed", 999999)
assert_eq(L:MaybeSuggest("Anointed"), nil, "the Prophet is never auto-suggested")

--------------------------------------------------------------------------------
-- Commit bookkeeping
--------------------------------------------------------------------------------
L:ResetForTests()
L:SetStanding("Climb", 50)
L:MaybeSuggest("Climb")
assert_eq(#L:GetSuggestions(), 1, "suggestion pending before approval")

local c1 = L:Commit("Climb", 2, 50, "Pope", 100)
assert_eq(#L:GetSuggestions(), 0, "commit clears the pending suggestion")
assert_eq(c1.revision, 1, "first commit is revision 1")
assert_eq(c1.updatedBy, "Pope", "commit records the approving officer")
assert_eq(c1.updatedAt, 100, "commit records the time")

local c2 = L:Commit("Climb", 3, 200, "Pope", 200)
assert_eq(c2.revision, 2, "second commit bumps the revision")

--------------------------------------------------------------------------------
-- Commit validation (bad input must not touch state)
--------------------------------------------------------------------------------
local bad, badErr = L:Commit("Climb", 8, 0, "Pope", 300)
assert_eq(bad, nil, "rank id above the ladder rejected")
assert_true(type(badErr) == "string", "rejected commit returns an error string")
assert_eq(select(1, L:Commit("Climb", 0, 0, "Pope", 300)), nil, "rank id 0 rejected")
assert_eq(select(1, L:Commit("Climb", 2.5, 0, "Pope", 300)), nil, "fractional rank id rejected")
assert_eq(select(1, L:Commit("Climb", "2", 0, "Pope", 300)), nil, "string rank id rejected")
assert_eq(select(1, L:Commit("Climb", 2, -5, "Pope", 300)), nil, "negative standing rejected")
assert_eq(select(1, L:Commit("Climb", 2, "50", "Pope", 300)), nil, "string standing rejected")
assert_eq(select(1, L:Commit("", 2, 0, "Pope", 300)), nil, "empty name rejected")
assert_eq(select(1, L:Commit("Climb", 2, 0, "", 300)), nil, "empty officer name rejected")
assert_eq(select(1, L:Commit("Climb", 2, 0, nil, 300)), nil, "missing officer name rejected")
assert_eq(L:GetRecord("Climb").revision, 2, "rejected commits do not bump the revision")
assert_eq(L:GetRecord("Climb").rankId, 3, "rejected commits do not change the rank")

--------------------------------------------------------------------------------
-- Demotion
--------------------------------------------------------------------------------
local d1 = L:Demote("Climb", 1, "Pope", 400)
assert_true(d1 ~= nil, "demotion to a lower rank succeeds")
assert_eq(d1.rankId, 1, "demoted to the target rank")
assert_eq(d1.revision, 3, "demotion bumps the revision")
assert_eq(d1.standing, 200, "demotion leaves standing alone")
assert_eq(select(1, L:Demote("Climb", 1, "Pope", 500)), nil, "demotion to the same rank rejected")
assert_eq(select(1, L:Demote("Climb", 3, "Pope", 500)), nil, "demotion upward rejected")

--------------------------------------------------------------------------------
-- Remote commit ordering: revision, then timestamp, then officer name
--------------------------------------------------------------------------------
L:ResetForTests()
assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 4, standing = 500, revision = 7, updatedAt = 10, updatedBy = "Pope",
}), true, "an unknown member accepts a remote commit")
assert_eq(L:GetRecord("Away").revision, 7, "remote revision stored verbatim")

assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 5, standing = 1000, revision = 7, updatedAt = 11, updatedBy = "Aaa",
}), true, "equal revision, later timestamp wins")
assert_eq(L:GetRecord("Away").rankId, 5, "later timestamp applied")

assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 3, standing = 200, revision = 7, updatedAt = 11, updatedBy = "Aab",
}), true, "equal revision and timestamp, higher officer name wins")
assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 1, standing = 0, revision = 7, updatedAt = 11, updatedBy = "Aaa",
}), false, "equal revision and timestamp, lower officer name loses")
assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 1, standing = 0, revision = 6, updatedAt = 99999, updatedBy = "Zzz",
}), false, "a stale revision never overwrites, however new its timestamp")
assert_eq(L:GetRecord("Away").rankId, 3, "ladder holds the winning record after the tiebreaks")

--------------------------------------------------------------------------------
-- Remote commit validation
--------------------------------------------------------------------------------
assert_eq(L:ApplyRemoteCommit(nil), false, "nil remote commit rejected")
assert_eq(L:ApplyRemoteCommit("RANK_COMMIT"), false, "non-table remote commit rejected")
assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 9, standing = 0, revision = 99, updatedAt = 99, updatedBy = "Pope",
}), false, "out-of-range rank id rejected")
assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 2, standing = -1, revision = 99, updatedAt = 99, updatedBy = "Pope",
}), false, "negative standing rejected")
assert_eq(L:ApplyRemoteCommit({
  name = "Away", rankId = 2, standing = 0, revision = 0, updatedAt = 99, updatedBy = "Pope",
}), false, "revision 0 rejected: commits always start at 1")
assert_eq(L:ApplyRemoteCommit({
  rankId = 2, standing = 0, revision = 99, updatedAt = 99, updatedBy = "Pope",
}), false, "nameless remote commit rejected")
assert_eq(L:GetRecord("Away").rankId, 3, "malformed remote commits changed nothing")

-- A commit that lands while a local suggestion is pending clears the stale suggestion.
L:ResetForTests()
L:SetStanding("Absent", 50)
L:MaybeSuggest("Absent")
assert_eq(L:ApplyRemoteCommit({
  name = "Absent", rankId = 2, standing = 50, revision = 1, updatedAt = 5, updatedBy = "Pope",
}), true, "remote commit for a suggested member applies")
assert_eq(#L:GetSuggestions(), 0, "remote commit clears the now-stale suggestion")

--------------------------------------------------------------------------------
-- Council seats: occupancy, re-appointment, freeing a seat, direct-commit backdoor
--------------------------------------------------------------------------------
L:ResetForTests()
for i = 1, 4 do L:AppointCouncil("C"..i, "Pope", i) end
assert_true(L:AppointCouncil("C1", "Pope", 9) ~= nil, "re-appointing a sitting member takes no extra seat")
assert_eq(select(1, L:AppointCouncil("C5", "Pope", 9)), nil, "council still full after re-appointment")
assert_true(L:Demote("C4", 5, "Pope", 10) ~= nil, "a council member can be demoted")
assert_true(L:AppointCouncil("C5", "Pope", 11) ~= nil, "the vacated seat can be filled")
assert_eq(select(1, L:Commit("C6", 6, 0, "Pope", 12)), nil, "a direct commit cannot exceed the seat limit")

--------------------------------------------------------------------------------
-- Prophet: unique, re-bestowable, successable
--------------------------------------------------------------------------------
L:ResetForTests()
assert_true(L:BestowProphet("First", "Pope", 1) ~= nil, "the first prophet is anointed")
assert_true(L:BestowProphet("First", "Pope", 2) ~= nil, "re-bestowing on the sitting prophet is allowed")
assert_eq(select(1, L:Commit("Second", 7, 0, "Pope", 3)), nil, "a direct commit cannot create a second prophet")
assert_true(L:Demote("First", 5, "Pope", 4) ~= nil, "the prophet can be demoted")
assert_true(L:BestowProphet("Second", "Pope", 5) ~= nil, "succession is possible once the seat is empty")

--------------------------------------------------------------------------------
-- Ladder view ordering: rank descending, then name ascending
--------------------------------------------------------------------------------
L:ResetForTests()
L:Commit("bella", 2, 50, "Pope", 1)
L:Commit("Alpha", 2, 50, "Pope", 1)
L:Commit("Zed", 5, 1000, "Pope", 1)
L:SetStanding("Newbie", 0)

local view = L:GetLadderView()
assert_eq(#view, 4, "every member with a record appears in the view")
assert_eq(view[1].name, "Zed", "highest rank sorts first")
assert_eq(view[2].name, "Alpha", "equal ranks sort by name")
assert_eq(view[3].name, "bella", "equal ranks sort by name, second entry")
assert_eq(view[4].name, "Newbie", "uncommitted members sit at the bottom")

--------------------------------------------------------------------------------
-- Export / import round trip
--------------------------------------------------------------------------------
local exported = L:ExportState()
assert_eq(#exported, 4, "export covers every record")

L:ResetForTests()
assert_eq(#L:GetLadderView(), 0, "reset empties the ladder")

assert_eq(L:ImportState(exported), 4, "import reports how many records it took")
local restored = L:GetRecord("Zed")
assert_eq(restored.rankId, 5, "import restores rank")
assert_eq(restored.standing, 1000, "import restores standing")
assert_eq(restored.revision, 1, "import restores revision")
assert_eq(restored.updatedBy, "Pope", "import restores the committing officer")
assert_eq(#L:GetLadderView(), 4, "import restores every record")

assert_eq(L:ImportState({
  { name = "Solo", rankId = 3, standing = 200, revision = 2, updatedAt = 1, updatedBy = "Pope" },
}), 1, "import replaces rather than merges")
assert_eq(#L:GetLadderView(), 1, "previous records are gone after a replacing import")
assert_eq(L:ImportState({
  {},
  { name = "Ok", rankId = 2, standing = 0, revision = 1, updatedAt = 1, updatedBy = "Pope" },
}), 1, "malformed records are skipped on import")
assert_eq(L:ImportState(nil), 0, "a nil import is safe")
assert_eq(#L:GetLadderView(), 1, "a nil import does not erase the ladder")

-- Records handed out are copies; callers cannot corrupt official state by accident.
L:ResetForTests()
L:Commit("Copy", 2, 50, "Pope", 1)
local handed = L:GetRecord("Copy")
handed.rankId = 99
assert_eq(L:GetRecord("Copy").rankId, 2, "GetRecord hands out a copy, not live state")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the test harness
--------------------------------------------------------------------------------
ChurchOfBeef._IN_TEST = false
L:SetStanding("Survivor", 10)
assert_eq(L:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(L:GetRecord("Survivor").standing, 10, "records survive a gated reset")

ChurchOfBeef._IN_TEST = true
assert_eq(L:ResetForTests(), true, "ResetForTests runs under COB._IN_TEST")
assert_eq(#L:GetLadderView(), 0, "the ungated reset cleared the ladder")
