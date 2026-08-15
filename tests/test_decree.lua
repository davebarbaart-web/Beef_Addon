-- The Decree (Phase 5 Lane A). Isolated: Common + Decree only.
-- Single active proclamation. Header is UI copy, not stored.
-- No TOC / bootstrap / run.lua / DB / Store / Runtime / UI / Net.
-- No deputy, calendar, RSVP, wire kind, #8, or Data/Popes.lua.
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
dofile("addon/ChurchOfBeef/Core/Decree.lua")

local COB = ChurchOfBeef
local Decree = COB.Decree

local function reset()
  assert_eq(Decree:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
end

local function snapKeys(row)
  local keys = {}
  if type(row) ~= "table" then return "" end
  for key in pairs(row) do
    keys[#keys + 1] = key
  end
  table.sort(keys)
  return table.concat(keys, ",")
end

--------------------------------------------------------------------------------
-- Isolated surface: Common + Decree. Other modules stay nil only standalone.
--------------------------------------------------------------------------------
assert_true(Decree ~= nil, "COB.Decree exists")
assert_true(COB.Names ~= nil, "Common name law is loaded")
if standalone then
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Roster, nil, "isolated suite does not load Roster")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
end

assert_eq(type(Decree.Set), "function", "Set replaces the single active Decree")
assert_eq(type(Decree.Get), "function", "Get returns a copy")
assert_eq(type(Decree.Clear), "function", "Clear removes the active Decree")
assert_eq(type(Decree.Snapshot), "function", "Snapshot is the persist shape")
assert_eq(type(Decree.Restore), "function", "Restore is the persist shape")
assert_eq(type(Decree.ResetForTests), "function", "ResetForTests is the harness reset")
assert_eq(Decree.IsRegisteredPope, nil, "Core does not check IsRegisteredPope")
assert_eq(Decree.Grant, nil, "no Grant")
assert_eq(Decree.Post, nil, "no Console Post")
assert_eq(Decree.Calendar, nil, "no calendar")
assert_eq(Decree.RSVP, nil, "no RSVP")
assert_eq(Decree.Summon, nil, "no SUMMON")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
local seeded, seedErr = Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
assert_true(seeded ~= nil, "a Decree exists before the out-of-harness reset")
assert_eq(seedErr, nil, "successful Set has no error")
ChurchOfBeef._IN_TEST = false
assert_eq(Decree:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "out-of-harness reset does not drop the Decree")
ChurchOfBeef._IN_TEST = true
reset()
assert_eq(Decree:Get(), nil, "ResetForTests clears the active Decree")

--------------------------------------------------------------------------------
-- Empty: Get is nil; Snapshot is {}
--------------------------------------------------------------------------------
assert_eq(Decree:Get(), nil, "Get is nil when no Decree is set")
local emptySnap = Decree:Snapshot()
assert_eq(type(emptySnap), "table", "empty Snapshot is a table")
assert_eq(snapKeys(emptySnap), "", "empty Snapshot is {}")
emptySnap.line = "injected"
assert_eq(snapKeys(Decree:Snapshot()), "", "mutating an empty Snapshot does not invent a live Decree")

--------------------------------------------------------------------------------
-- Set: line required; flavor omitted or "" is nil
--------------------------------------------------------------------------------
local missing, missingErr = Decree:Set()
assert_eq(missing, nil, "Set without a table fails")
assert_true(type(missingErr) == "string" and missingErr ~= "", "Set without a table returns a reason")
assert_eq(Decree:Get(), nil, "failed Set does not invent a Decree")

local noLine, noLineErr = Decree:Set({})
assert_eq(noLine, nil, "Set without line fails")
assert_true(type(noLineErr) == "string" and noLineErr ~= "", "Set without line returns a reason")

local blank, blankErr = Decree:Set({ line = "" })
assert_eq(blank, nil, "Set with empty line fails")
assert_true(type(blankErr) == "string" and blankErr ~= "", "Set with empty line returns a reason")

local spaces, spacesErr = Decree:Set({ line = "   " })
assert_eq(spaces, nil, "Set with whitespace line fails")
assert_true(type(spacesErr) == "string" and spacesErr ~= "", "Set with whitespace line returns a reason")

local numbered, numberedErr = Decree:Set({ line = 1 })
assert_eq(numbered, nil, "Set with a non-string line fails")
assert_true(type(numberedErr) == "string" and numberedErr ~= "", "Set with a non-string line returns a reason")

local posted, postedErr = Decree:Set({
  line = "Goldshire Inn — Sunday, 7:00 PM",
})
assert_true(posted ~= nil, "Set with a line succeeds")
assert_eq(postedErr, nil, "successful Set has no error")
assert_eq(posted.line, "Goldshire Inn — Sunday, 7:00 PM", "Set returns the place-and-when line")
assert_eq(posted.flavor, nil, "omitted flavor is nil")
assert_eq(posted.title, nil, "Set does not invent a title")
assert_eq(posted.header, nil, "Set does not store the banner header")
assert_eq(posted.author, nil, "Set does not invent an author")
assert_eq(posted.deputy, nil, "Set does not invent a deputy")
assert_eq(posted.postedAt, nil, "Set does not invent postedAt")
assert_eq(posted.expiry, nil, "Set does not invent expiry")

local got = Decree:Get()
assert_eq(got.line, "Goldshire Inn — Sunday, 7:00 PM", "Get returns the line")
assert_eq(got.flavor, nil, "Get flavor is nil when omitted")
got.line = "mutated"
got.flavor = "injected"
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "mutating a Get copy does not change the live line")
assert_eq(Decree:Get().flavor, nil, "mutating a Get copy does not invent live flavor")

local withEmptyFlavor = Decree:Set({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "",
})
assert_eq(withEmptyFlavor.flavor, nil, "empty flavor is nil")
assert_eq(Decree:Get().flavor, nil, "Get flavor is nil when Set flavor is empty")

local withSpacesFlavor = Decree:Set({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "   ",
})
assert_eq(withSpacesFlavor.flavor, nil, "whitespace flavor is nil")

local withFlavor = Decree:Set({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "Bring a friend.",
})
assert_eq(withFlavor.line, "Goldshire Inn — Sunday, 7:00 PM", "Set keeps the line when flavor is present")
assert_eq(withFlavor.flavor, "Bring a friend.", "Set stores optional flavor")
assert_eq(Decree:Get().flavor, "Bring a friend.", "Get returns the flavor")

--------------------------------------------------------------------------------
-- Single active Decree. Extra fields and the banner header are not stored.
--------------------------------------------------------------------------------
local replaced = Decree:Set({
  line = "Shattrath — Friday, 8:00 PM",
  flavor = "The Gathering.",
  title = "A GATHERING HAS BEEN DECREED",
  header = "A GATHERING HAS BEEN DECREED",
  author = "The Pope",
  deputy = "Steve",
  postedAt = 1,
  expiry = 2,
  place = "Shattrath",
  when = "Friday",
})
assert_eq(replaced.line, "Shattrath — Friday, 8:00 PM", "Set replaces the single active line")
assert_eq(replaced.flavor, "The Gathering.", "Set replaces the single active flavor")
assert_eq(replaced.title, nil, "title is not a stored field")
assert_eq(replaced.header, nil, "header is UI copy, not stored")
local live = Decree:Get()
assert_eq(live.line, "Shattrath — Friday, 8:00 PM", "Get sees the replacement")
assert_eq(live.flavor, "The Gathering.", "Get sees the replacement flavor")
assert_eq(live.title, nil, "Get does not return a title")
assert_eq(live.header, nil, "Get does not return the banner header")
assert_eq(live.author, nil, "Get does not return an author")
assert_eq(live.deputy, nil, "Get does not return a deputy")
assert_eq(live.postedAt, nil, "Get does not return postedAt")
assert_eq(live.expiry, nil, "Get does not return expiry")
assert_eq(live.place, nil, "place is not split out of line")
assert_eq(live.when, nil, "when is not split out of line")
assert_eq(snapKeys(live), "flavor,line", "Get copy is { line, flavor }")

--------------------------------------------------------------------------------
-- Snapshot is a copy. Empty Snapshot is {}.
--------------------------------------------------------------------------------
local snap = Decree:Snapshot()
assert_eq(snap.line, "Shattrath — Friday, 8:00 PM", "Snapshot has the line")
assert_eq(snap.flavor, "The Gathering.", "Snapshot has the flavor")
assert_eq(snapKeys(snap), "flavor,line", "Snapshot is { line, flavor } when set")
assert_eq(snap.title, nil, "Snapshot does not store a title")
assert_eq(snap.header, nil, "Snapshot does not store the banner header")
snap.line = "mutated"
snap.flavor = "mutated"
assert_eq(Decree:Get().line, "Shattrath — Friday, 8:00 PM", "mutating a Snapshot does not change the live line")
assert_eq(Decree:Get().flavor, "The Gathering.", "mutating a Snapshot does not change the live flavor")

--------------------------------------------------------------------------------
-- Clear removes the active Decree
--------------------------------------------------------------------------------
Decree:Clear()
assert_eq(Decree:Get(), nil, "Clear removes the active Decree")
assert_eq(snapKeys(Decree:Snapshot()), "", "Clear makes Snapshot {}")

--------------------------------------------------------------------------------
-- Restore only when line is a non-empty string. Empty {} does not wipe live.
--------------------------------------------------------------------------------
local kept = Decree:Set({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "Bring a friend.",
})
assert_true(kept ~= nil, "a live Decree exists before Restore refusals")

local badTable, badTableErr = Decree:Restore()
assert_eq(badTable, nil, "Restore without a table fails")
assert_true(type(badTableErr) == "string" and badTableErr ~= "", "Restore without a table returns a reason")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "non-table Restore does not wipe live")

local emptyRestore, emptyRestoreErr = Decree:Restore({})
assert_eq(emptyRestore, nil, "Restore of {} fails")
assert_true(type(emptyRestoreErr) == "string" and emptyRestoreErr ~= "", "Restore of {} returns a reason")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "empty {} does not wipe a live Decree")
assert_eq(Decree:Get().flavor, "Bring a friend.", "empty {} does not drop live flavor")

local missingLine, missingLineErr = Decree:Restore({ flavor = "nope" })
assert_eq(missingLine, nil, "Restore without line fails")
assert_true(type(missingLineErr) == "string" and missingLineErr ~= "", "Restore without line returns a reason")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "missing line does not wipe live")

local emptyLine, emptyLineErr = Decree:Restore({ line = "" })
assert_eq(emptyLine, nil, "Restore of empty line fails")
assert_true(type(emptyLineErr) == "string" and emptyLineErr ~= "", "Restore of empty line returns a reason")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "empty line does not wipe live")

local spaceLine, spaceLineErr = Decree:Restore({ line = "   " })
assert_eq(spaceLine, nil, "Restore of whitespace line fails")
assert_true(type(spaceLineErr) == "string" and spaceLineErr ~= "", "Restore of whitespace line returns a reason")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "whitespace line does not wipe live")

local typedLine, typedLineErr = Decree:Restore({ line = 1 })
assert_eq(typedLine, nil, "Restore of non-string line fails")
assert_true(type(typedLineErr) == "string" and typedLineErr ~= "", "Restore of non-string line returns a reason")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "non-string line does not wipe live")

local restored = Decree:Restore({
  line = "Shattrath — Friday, 8:00 PM",
  flavor = "The Gathering.",
  title = "A GATHERING HAS BEEN DECREED",
  deputy = "Steve",
})
assert_eq(restored, true, "Restore of a non-empty line succeeds")
assert_eq(Decree:Get().line, "Shattrath — Friday, 8:00 PM", "Restore replaces the live line")
assert_eq(Decree:Get().flavor, "The Gathering.", "Restore keeps flavor")
assert_eq(Decree:Get().title, nil, "Restore does not import a title")
assert_eq(Decree:Get().deputy, nil, "Restore does not import a deputy")

local restoredNilFlavor = Decree:Restore({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "",
})
assert_eq(restoredNilFlavor, true, "Restore with empty flavor succeeds")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "Restore with empty flavor keeps the line")
assert_eq(Decree:Get().flavor, nil, "Restore empty flavor is nil")

local restoredOmit = Decree:Restore({ line = "Orgrimmar — Saturday" })
assert_eq(restoredOmit, true, "Restore with omitted flavor succeeds")
assert_eq(Decree:Get().flavor, nil, "Restore omitted flavor is nil")
assert_eq(snapKeys(Decree:Get()), "line", "Get with nil flavor has no flavor key")

--------------------------------------------------------------------------------
-- Core does not write SV, frames, or Net. No Pope-list stub.
--------------------------------------------------------------------------------
ChurchOfBeefDB = { sentinel = 1 }
local framed = 0
local netCalls = 0
CreateFrame = function()
  framed = framed + 1
end
if not COB.Net then
  COB.Net = {
    Send = function()
      netCalls = netCalls + 1
    end,
  }
end
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
Decree:Get()
Decree:Snapshot()
Decree:Restore({ line = "Shattrath — Friday, 8:00 PM" })
Decree:Clear()
assert_eq(ChurchOfBeefDB.sentinel, 1, "Decree does not write ChurchOfBeefDB")
assert_eq(ChurchOfBeefDB.decree, nil, "Decree does not persist itself into SV")
assert_eq(framed, 0, "Decree does not CreateFrame")
assert_eq(netCalls, 0, "Decree does not call Net")
if standalone then
  COB.Net = nil
end

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
