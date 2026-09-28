-- Nights board. Isolated: Common + Nights.
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
dofile("addon/ChurchOfBeef/Core/Nights.lua")

local COB = ChurchOfBeef
local Nights = COB.Nights

local function reset()
  assert_eq(Nights:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
end

-- 1 Jan 2026 was a Thursday. os.date wday: Sunday=1 ... Thursday=5.
local THU = 1767290400
local function day(offset)
  return THU + offset * 86400
end

reset()
assert_true(Nights ~= nil, "COB.Nights exists")
assert_eq(Nights:BoardRevision(), 0, "fresh revision is 0")
assert_eq(#Nights:Week(THU), 0, "empty week")

local bad, badErr = Nights:SetSeries({})
assert_eq(bad, nil, "empty series refuses")
assert_true(type(badErr) == "string", "empty series names a reason")

local series, seriesErr = Nights:SetSeries({
  kind = "gathering",
  weekday = 5,
  timeLine = "7:00 PM",
  place = "Goldshire Inn",
  flavor = "Bring a friend.",
}, THU)
assert_true(series ~= nil, "SetSeries succeeds")
assert_eq(seriesErr, nil, "SetSeries has no error")
assert_eq(series.id, 1, "first series id is 1")
assert_eq(Nights:BoardRevision(), 1, "SetSeries bumps revision")

local week = Nights:Week(THU)
assert_eq(#week, 1, "Thursday gathering appears this week")
assert_eq(week[1].kind, "gathering", "kind is gathering")
assert_eq(week[1].date, "2026-01-01", "first Thursday is 2026-01-01")
assert_eq(week[1].place, "Goldshire Inn", "place")
assert_eq(week[1].timeLine, "7:00 PM", "time")
assert_eq(week[1].flavor, "Bring a friend.", "flavor")
assert_eq(week[1].goingCount, 0, "no going yet")

week[1].place = "mutated"
assert_eq(Nights:Week(THU)[1].place, "Goldshire Inn", "Board returns copies")

local skipped = Nights:SkipWeek(1, "2026-01-01")
assert_true(skipped ~= nil, "SkipWeek succeeds")
assert_eq(#Nights:Week(THU), 0, "skipped week is empty")
assert_eq(Nights:BoardRevision(), 2, "SkipWeek bumps revision")

assert_eq(#Nights:Week(day(7)), 1, "next Thursday still generates")

Nights:ResetForTests()
Nights:SetSeries({
  kind = "gora",
  weekday = 5,
  timeLine = "8:00 PM",
  place = "The Pit",
}, THU)
Nights:MoveWeek(1, "2026-01-01", { timeLine = "9:00 PM", place = "Orgrimmar" })
local moved = Nights:Week(THU)[1]
assert_eq(moved.timeLine, "9:00 PM", "move replaces time")
assert_eq(moved.place, "Orgrimmar", "move replaces place")
local nextWeek = Nights:Week(day(7))[1]
assert_eq(nextWeek.place, "The Pit", "next week keeps the series place")

Nights:WithdrawSeries(1)
assert_eq(#Nights:Week(THU), 0, "withdrawn series emits nothing")
assert_eq(#Nights:Week(day(7)), 0, "withdrawn series has no future")

Nights:ResetForTests()
local stub, stubErr = Nights:SetStub({
  kind = "raid",
  title = "Kara Thursday",
  timeLine = "8:00 PM",
  place = "Karazhan",
  date = "2026-01-01",
  createdBy = "Beefina",
}, THU)
assert_true(stub ~= nil, "SetStub succeeds")
assert_eq(stubErr, nil, "SetStub has no error")
assert_eq(stub.id, "beefina:1", "stub id is sender:seq")
assert_eq(stub.kind, "raid", "raid stub")
local stubWeek = Nights:Week(THU)
assert_eq(#stubWeek, 1, "stub appears this week")
assert_eq(stubWeek[1].title, "Kara Thursday", "stub title")
assert_eq(stubWeek[1].cue, "Sign up on Discord", "fixed Discord cue")
assert_eq(stubWeek[1].goingCount, 0, "stubs have no going")

local goingStub, goingStubErr = Nights:SetGoing(stubWeek[1].key, "thickcut", true)
assert_eq(goingStub, nil, "Going on a stub refuses")
assert_eq(goingStubErr, "going is church only", "Going names the refusal")

Nights:WithdrawStub(stub.id)
assert_eq(#Nights:Week(THU), 0, "withdrawn stub is gone")
local again, againErr = Nights:ApplyStub({
  id = stub.id,
  kind = "raid",
  title = "Kara Thursday",
  timeLine = "8:00 PM",
  place = "Karazhan",
  date = "2026-01-01",
  createdBy = "Beefina",
}, THU)
assert_eq(again, nil, "tombstone wins over ApplyStub")
assert_eq(againErr, "stub withdrawn", "tombstone reason")

Nights:ResetForTests()
Nights:SetSeries({
  kind = "knighting",
  weekday = 5,
  timeLine = "7:00 PM",
  place = "Goldshire Inn",
}, THU)
local key = Nights:Week(THU)[1].key
local revBeforeGoing = Nights:BoardRevision()
assert_eq(Nights:SetGoing(key, "Thickcut", true), true, "Going sets")
assert_eq(Nights:CountGoing(key), 1, "count is 1")
assert_eq(Nights:ListGoing(key)[1], "thickcut", "names are keyed")
assert_eq(Nights:BoardRevision(), revBeforeGoing, "Going does not bump revision")
Nights:SetGoing(key, "Steakina", true)
assert_eq(Nights:CountGoing(key), 2, "second Going")
Nights:SetGoing(key, "Thickcut", false)
assert_eq(Nights:CountGoing(key), 1, "clear Going")

-- Broadcast merge: Pope snapshot does not wipe unknown local stubs.
Nights:ResetForTests()
Nights:SetStub({
  kind = "pvp",
  title = "AV Sunday",
  timeLine = "3:00 PM",
  place = "Alterac",
  date = "2026-01-04",
  createdBy = "Councilor",
  id = "councilor:1",
}, THU)
local localRev = Nights:BoardRevision()
Nights:ApplyBroadcast({
  series = {},
  stubs = {},
  stubTombstones = {},
  goingCounts = {},
  boardRevision = 1,
})
local still = Nights:Board(day(3), 7)
assert_eq(#still, 1, "unknown local stub survives Pope snapshot")
assert_eq(still[1].title, "AV Sunday", "local stub title remains")
assert_true(Nights:BoardRevision() >= localRev, "revision never lowers")

Nights:ApplyBroadcast({
  series = {},
  stubs = {},
  stubTombstones = { "councilor:1" },
  boardRevision = 9,
})
assert_eq(#Nights:Board(day(3), 7), 0, "broadcast tombstone removes local stub")
assert_eq(Nights:BoardRevision(), 9, "revision max-merges")

Nights:ResetForTests()
local imported = Nights:ImportDecree("Goldshire Inn — Sunday, 7:00 PM", "Bring a friend.", THU)
assert_true(imported ~= nil, "ImportDecree succeeds")
assert_eq(imported.oneshotDate, "2026-01-01", "import is a one-shot on the import date")
assert_eq(#Nights:Week(THU), 1, "imported decree appears that day")
assert_eq(Nights:Week(THU)[1].kind, "gathering", "import is a Gathering")
assert_eq(#Nights:Week(day(7)), 0, "one-shot does not recur")
local second, secondErr = Nights:ImportDecree("Shattrath", nil, THU)
assert_eq(second, nil, "second import refuses")
assert_eq(secondErr, "already imported", "import once")

local snap = Nights:Snapshot()
assert_eq(type(snap.series), "table", "Snapshot has series")
snap.series[1].place = "mutated"
assert_eq(Nights:Week(THU)[1].place, "Goldshire Inn — Sunday, 7:00 PM",
  "mutating Snapshot does not change live")

Nights:ResetForTests()
assert_eq(Nights:Restore(snap), true, "Restore succeeds")
assert_eq(#Nights:Week(THU), 1, "Restore rebuilds the one-shot")

Nights:ResetForTests()
local listed = Nights:SetSeries({
  kind = "gora",
  weekday = 5,
  timeLine = "9:00 PM",
  place = "Goldshire",
}, THU)
assert_eq(#Nights:ListSeries(), 1, "ListSeries returns the live series")
assert_eq(Nights:ListSeries()[1].id, listed.id, "ListSeries id")
Nights:SetGoing(Nights:Week(THU)[1].key, "Beefina", true)
assert_eq(Nights:IsGoing(Nights:Week(THU)[1].key, "Beefina"), true, "IsGoing is true after SetGoing")
assert_eq(Nights:CountGoing(Nights:Week(THU)[1].key), 1, "CountGoing follows SetGoing")
Nights:SetGoing(Nights:Week(THU)[1].key, "Beefina", false)
assert_eq(Nights:IsGoing(Nights:Week(THU)[1].key, "Beefina"), false, "IsGoing clears")
assert_eq(Nights:BoardRevision(), 1, "Going does not bump revision")

if ChurchOfBeef.DB and ChurchOfBeef.DB.Init then
  Nights:ResetForTests()
  ChurchOfBeefDB = {
    version = 7,
    ui = {},
    store = {},
    event = {},
    decree = { line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "Bring a friend." },
    nights = {},
  }
  ChurchOfBeef.DB:Init()
  assert_eq(ChurchOfBeefDB.decree.line, "Goldshire Inn — Sunday, 7:00 PM",
    "DB Init keeps leftover decree.line")
  assert_eq(#Nights:Week(), 1, "DB Init imports leftover decree into nights")
  Nights:ResetForTests()
end

-- Anniversary has date() / time() and no os. The board must still generate.
do
  local savedOs = os
  local savedDate = date
  os = nil
  date = function(fmt, ts)
    return savedOs.date(fmt, ts)
  end
  reset()
  local wowSeries = Nights:SetSeries({
    kind = "gathering",
    weekday = 5,
    timeLine = "7:00 PM",
    place = "Goldshire Inn",
  }, THU)
  assert_true(wowSeries ~= nil, "SetSeries without os succeeds")
  local wowWeek = Nights:Week(THU)
  assert_eq(#wowWeek, 1, "Week without os still generates Thursday")
  assert_eq(wowWeek[1].date, "2026-01-01", "WoW date() path keeps the civil day")
  assert_eq(Nights:HasBoard(THU), true, "HasBoard without os is true")
  os = savedOs
  date = savedDate
  reset()
end

ChurchOfBeef._IN_TEST = false
assert_eq(Nights:ResetForTests(), false, "ResetForTests refuses outside tests")
ChurchOfBeef._IN_TEST = true
Nights:ResetForTests()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
