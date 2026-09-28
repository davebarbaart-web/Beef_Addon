-- SavedVariables DB: { version, ui, store, event, gora, decree, nights }. Schema 8.
-- No-Decree path: decree stays {}. With Decree: Save writes Snapshot;
-- Init Restores only when decree.line is a string. Gora: Init Restores
-- after event when eventId is a number. Ceremony Save (event + gora) is
-- Pope-only. Leftover demo keys survive (Law 7) and are not imported
-- into store, event, gora, or decree.
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

-- Isolated no-Store / no-Runtime / no-Decree path must stay green even if
-- those modules were already loaded (full harness).
ChurchOfBeef.Store = nil
ChurchOfBeef.Runtime = nil
ChurchOfBeef.Decree = nil
dofile("addon/ChurchOfBeef/Core/DB.lua")

local DB = ChurchOfBeef.DB

local function rootKeys(db)
  local keys = {}
  for key in pairs(db) do
    keys[#keys + 1] = key
  end
  table.sort(keys)
  return table.concat(keys, ",")
end

local function storeKeys(store)
  local keys = {}
  for key in pairs(store) do
    keys[#keys + 1] = key
  end
  table.sort(keys)
  return table.concat(keys, ",")
end

local function eventKeys(event)
  local keys = {}
  if type(event) ~= "table" then return "" end
  for key in pairs(event) do
    keys[#keys + 1] = key
  end
  table.sort(keys)
  return table.concat(keys, ",")
end

-- Safe field read so a missing event hook fails asserts instead of erroring.
local function eventField(event, key)
  if type(event) ~= "table" then return nil end
  return event[key]
end

local function decreeKeys(decree)
  local keys = {}
  if type(decree) ~= "table" then return "" end
  for key in pairs(decree) do
    keys[#keys + 1] = key
  end
  table.sort(keys)
  return table.concat(keys, ",")
end

local function decreeField(decree, key)
  if type(decree) ~= "table" then return nil end
  return decree[key]
end

local function goraKeys(gora)
  local keys = {}
  if type(gora) ~= "table" then return "" end
  for key in pairs(gora) do
    keys[#keys + 1] = key
  end
  table.sort(keys)
  return table.concat(keys, ",")
end

local function goraField(gora, key)
  if type(gora) ~= "table" then return nil end
  return gora[key]
end

local function stubWriterPope(isPope)
  ChurchOfBeef.Sender = {
    IsRegisteredPope = function()
      return isPope == true
    end,
  }
end

local function eventSubjects(event)
  local subjects = eventField(event, "subjects")
  if type(subjects) ~= "table" then return {} end
  return subjects
end

local function initOk(label)
  local ok, err = pcall(function()
    return DB:Init()
  end)
  assert_true(ok, label .. " Init does not error")
  if not ok then
    assert_eq(tostring(err), "", label .. " Init error")
  end
  return ok
end

local function saveOk(label)
  local ok, result = pcall(function()
    return DB:Save()
  end)
  assert_true(ok, label .. " Save does not error")
  if ok then
    assert_true(result, label .. " Save returns true")
  end
  return ok
end

--------------------------------------------------------------------------------
-- First run creates the schema stamp, ui defaults, empty store + event + gora + decree
--------------------------------------------------------------------------------
ChurchOfBeefDB = nil
local db = DB:Init()
assert_true(db ~= nil, "Init returns the SV table")
assert_true(db == ChurchOfBeefDB, "Init returns the global SV")
assert_eq(ChurchOfBeefDB.version, 8, "schema version is 8")
assert_eq(type(ChurchOfBeefDB.ui), "table", "ui table exists")
assert_eq(ChurchOfBeefDB.ui.announce, true, "announce defaults on")
assert_eq(ChurchOfBeefDB.ui.shown, false, "frame starts hidden")
assert_eq(ChurchOfBeefDB.ui.point, nil, "no saved point yet")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, false, "welcomeSeen defaults false")
assert_eq(type(ChurchOfBeefDB.store), "table", "store table exists")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "fresh store is empty")
assert_eq(type(ChurchOfBeefDB.event), "table", "event hook exists")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "fresh event is empty")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), nil, "Init does not invent a Runtime snapshot")
assert_eq(type(ChurchOfBeefDB.gora), "table", "gora hook exists")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "fresh gora is empty")
assert_eq(goraField(ChurchOfBeefDB.gora, "eventId"), nil, "Init does not invent a Gora snapshot")
assert_eq(type(ChurchOfBeefDB.decree), "table", "decree hook exists")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "fresh decree is empty")
assert_eq(decreeField(ChurchOfBeefDB.decree, "line"), nil, "Init does not invent a Decree snapshot")
assert_eq(type(ChurchOfBeefDB.nights), "table", "nights hook exists")
assert_eq(rootKeys(ChurchOfBeefDB), "decree,event,gora,nights,store,ui,version", "fresh SV is { version, ui, store, event, gora, decree }")
assert_eq(ChurchOfBeefDB.ladder, nil, "Init does not invent standing schema")
assert_eq(ChurchOfBeefDB.scoring, nil, "Init does not invent scoring schema")
assert_eq(ChurchOfBeefDB.suggestions, nil, "Init does not invent suggestions")
assert_eq(ChurchOfBeefDB.runtime, nil, "Init does not invent a runtime key")
assert_eq(ChurchOfBeefDB.ceremony, nil, "Init does not invent a ceremony key")
assert_eq(ChurchOfBeefDB.holdSeconds, nil, "Init does not invent holdSeconds")
assert_eq(ChurchOfBeefDB.store.humans, nil, "store hook is not a human schema")
assert_eq(ChurchOfBeefDB.store.characters, nil, "store hook is not a character schema")
assert_eq(ChurchOfBeefDB.store.gora, nil, "store hook is not a Gora schema")
assert_eq(decreeField(ChurchOfBeefDB.decree, "title"), nil, "decree hook is not a title schema")
assert_eq(decreeField(ChurchOfBeefDB.decree, "header"), nil, "decree hook does not store the banner header")
assert_eq(decreeField(ChurchOfBeefDB.decree, "deputy"), nil, "decree hook does not invent a deputy")

--------------------------------------------------------------------------------
-- No humans / characters / Gora APIs on DB (Lane A owns Store)
--------------------------------------------------------------------------------
assert_eq(DB.GetHuman, nil, "DB has no GetHuman")
assert_eq(DB.CreateHuman, nil, "DB has no CreateHuman")
assert_eq(DB.GetCharacter, nil, "DB has no GetCharacter")
assert_eq(DB.CreateCharacter, nil, "DB has no CreateCharacter")
assert_eq(DB.RecordGora, nil, "DB has no RecordGora")
assert_eq(DB.SetRank, nil, "DB has no SetRank")

--------------------------------------------------------------------------------
-- Save applies defaults; UI writes persist across Save and re-Init
--------------------------------------------------------------------------------
assert_true(DB:Save(), "Save succeeds with an SV table")
ChurchOfBeefDB.ui.shown = true
ChurchOfBeefDB.ui.point = "CENTER"
ChurchOfBeefDB.ui.announce = false
assert_true(DB:Save(), "Save keeps UI-written ui fields")
assert_eq(ChurchOfBeefDB.ui.shown, true, "Save keeps shown")
assert_eq(ChurchOfBeefDB.ui.point, "CENTER", "Save keeps point")
assert_eq(ChurchOfBeefDB.ui.announce, false, "Save keeps announce")
assert_eq(type(ChurchOfBeefDB.store), "table", "Save keeps the store hook")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "Save does not invent store rows")
assert_eq(type(ChurchOfBeefDB.event), "table", "Save keeps the event hook")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Save without Runtime does not invent an event snapshot")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), nil, "Save without Runtime does not invent state")
assert_eq(type(ChurchOfBeefDB.gora), "table", "Save keeps the gora hook")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "Save without Gora does not invent a gora snapshot")
assert_eq(goraField(ChurchOfBeefDB.gora, "eventId"), nil, "Save without Gora does not invent eventId")
assert_eq(type(ChurchOfBeefDB.decree), "table", "Save keeps the decree hook")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Save without Decree does not invent a decree snapshot")
assert_eq(decreeField(ChurchOfBeefDB.decree, "line"), nil, "Save without Decree does not invent line")

DB:Init()
assert_eq(ChurchOfBeefDB.ui.shown, true, "re-Init keeps shown")
assert_eq(ChurchOfBeefDB.ui.point, "CENTER", "re-Init keeps point")
assert_eq(ChurchOfBeefDB.ui.announce, false, "re-Init keeps announce")
assert_eq(type(ChurchOfBeefDB.store), "table", "re-Init keeps the store hook")
assert_eq(type(ChurchOfBeefDB.event), "table", "re-Init keeps the event hook")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "re-Init without Runtime leaves event empty")
assert_eq(type(ChurchOfBeefDB.gora), "table", "re-Init keeps the gora hook")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "re-Init without Gora leaves gora empty")
assert_eq(type(ChurchOfBeefDB.decree), "table", "re-Init keeps the decree hook")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "re-Init without Decree leaves decree empty")
assert_eq(ChurchOfBeefDB.ladder, nil, "re-Init still does not invent standing")
assert_eq(ChurchOfBeefDB.scoring, nil, "re-Init still does not invent scoring")

ChurchOfBeefDB = { version = 6, ui = {} }
assert_true(DB:Save(), "Save fills a sparse ui table")
assert_eq(ChurchOfBeefDB.ui.announce, true, "Save fills missing announce")
assert_eq(ChurchOfBeefDB.ui.shown, false, "Save fills missing shown")
assert_eq(type(ChurchOfBeefDB.store), "table", "Save fills missing store")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "Save store hook is empty")
assert_eq(type(ChurchOfBeefDB.event), "table", "Save fills missing event")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Save event hook is empty")
assert_eq(type(ChurchOfBeefDB.gora), "table", "Save fills missing gora")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "Save gora hook is empty")
assert_eq(type(ChurchOfBeefDB.decree), "table", "Save fills missing decree")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Save decree hook is empty")
assert_eq(ChurchOfBeefDB.version, 8, "Save stamps schema 8 on a schema-6 table")

ChurchOfBeefDB = nil
assert_eq(DB:Save(), false, "Save without an SV table returns false")

--------------------------------------------------------------------------------
-- store / event / gora / decree = {} if missing; existing contents are not wiped
--------------------------------------------------------------------------------
ChurchOfBeefDB = { version = 6, ui = { announce = true, shown = false }, store = {}, event = {} }
DB:Init()
assert_eq(ChurchOfBeefDB.version, 8, "stamps schema 8 when adding the decree hook")
assert_eq(type(ChurchOfBeefDB.store), "table", "missing store becomes a table")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "missing store becomes {}")
assert_eq(type(ChurchOfBeefDB.event), "table", "missing event becomes a table")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "missing event becomes {}")
assert_eq(type(ChurchOfBeefDB.gora), "table", "missing gora becomes a table")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "missing gora becomes {}")
assert_eq(type(ChurchOfBeefDB.decree), "table", "missing decree becomes a table")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "missing decree becomes {}")

ChurchOfBeefDB = { version = 6, ui = { shown = true }, store = { future = true }, event = { future = true }, gora = { future = true }, decree = { future = true } }
DB:Init()
assert_eq(ChurchOfBeefDB.store.future, true, "unknown store key survives Init")
assert_eq(eventField(ChurchOfBeefDB.event, "future"), true, "unknown event key survives Init")
assert_eq(goraField(ChurchOfBeefDB.gora, "future"), true, "unknown gora key survives Init")
assert_eq(decreeField(ChurchOfBeefDB.decree, "future"), true, "unknown decree key survives Init")
assert_true(DB:Save(), "Save keeps unknown store keys")
assert_eq(ChurchOfBeefDB.store.future, true, "unknown store key survives Save")
assert_eq(eventField(ChurchOfBeefDB.event, "future"), true, "unknown event key survives Save without Runtime")
assert_eq(goraField(ChurchOfBeefDB.gora, "future"), true, "unknown gora key survives Save without Gora")
assert_eq(decreeField(ChurchOfBeefDB.decree, "future"), true, "unknown decree key survives Save without Decree")

ChurchOfBeefDB = { version = 6, ui = {}, store = "not-a-table", event = "not-a-table", gora = "not-a-table", decree = "not-a-table" }
DB:Init()
assert_eq(type(ChurchOfBeefDB.store), "table", "non-table store is replaced")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "replaced store is {}")
assert_eq(type(ChurchOfBeefDB.event), "table", "non-table event is replaced")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "replaced event is {}")
assert_eq(type(ChurchOfBeefDB.gora), "table", "non-table gora is replaced")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "replaced gora is {}")
assert_eq(type(ChurchOfBeefDB.decree), "table", "non-table decree is replaced")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "replaced decree is {}")

--------------------------------------------------------------------------------
-- Leftover demo keys survive (Law 7). They are not product and not imported.
--------------------------------------------------------------------------------
ChurchOfBeefDB = {
  version = 1,
  ui = { announce = true, shown = false },
  ladder = { records = { "Alice" }, suggestions = { "Bob" } },
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
DB:Init()
assert_eq(ChurchOfBeefDB.version, 8, "stamps schema 8 on an old table")
assert_eq(type(ChurchOfBeefDB.ladder), "table", "leftover ladder key is not wiped")
assert_eq(type(ChurchOfBeefDB.scoring), "table", "leftover scoring key is not wiped")
assert_eq(type(ChurchOfBeefDB.suggestions), "table", "leftover suggestions key is not wiped")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "leftover ladder payload is not wiped")
assert_eq(ChurchOfBeefDB.ladder.suggestions[1], "Bob", "leftover nested suggestions are not wiped")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "leftover scoring payload is not wiped")
assert_eq(type(ChurchOfBeefDB.store), "table", "old table gets a store hook")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "leftovers are not migrated into store")
assert_eq(ChurchOfBeefDB.store.ladder, nil, "ladder is not copied into store")
assert_eq(ChurchOfBeefDB.store.scoring, nil, "scoring is not copied into store")
assert_eq(ChurchOfBeefDB.store.suggestions, nil, "suggestions are not copied into store")
assert_eq(ChurchOfBeefDB.store.records, nil, "ladder records are not copied into store")
assert_eq(type(ChurchOfBeefDB.event), "table", "old table gets an event hook")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "leftovers are not migrated into event")
assert_eq(eventField(ChurchOfBeefDB.event, "ladder"), nil, "ladder is not copied into event")
assert_eq(eventField(ChurchOfBeefDB.event, "scoring"), nil, "scoring is not copied into event")
assert_eq(eventField(ChurchOfBeefDB.event, "suggestions"), nil, "suggestions are not copied into event")
assert_eq(eventField(ChurchOfBeefDB.event, "records"), nil, "ladder records are not copied into event")
assert_eq(type(ChurchOfBeefDB.decree), "table", "old table gets a decree hook")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "leftovers are not migrated into decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "ladder"), nil, "ladder is not copied into decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "scoring"), nil, "scoring is not copied into decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "suggestions"), nil, "suggestions are not copied into decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "records"), nil, "ladder records are not copied into decree")

assert_true(DB:Save(), "Save keeps leftover demo keys")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "Save does not wipe leftover ladder payload")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "Save does not wipe leftover scoring payload")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "Save still does not import leftovers")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Save still does not import leftovers into event")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Save still does not import leftovers into decree")

ChurchOfBeefDB = { version = 1, ui = { announce = true, shown = false } }
DB:Init()
assert_eq(ChurchOfBeefDB.version, 8, "v1 without leftovers stamps schema 8")
assert_eq(ChurchOfBeefDB.ladder, nil, "missing leftover keys are not created")
assert_eq(ChurchOfBeefDB.scoring, nil, "missing scoring is not created")
assert_eq(ChurchOfBeefDB.suggestions, nil, "missing suggestions are not created")
assert_eq(type(ChurchOfBeefDB.store), "table", "v1 without leftovers still gets store")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "v1 store hook is empty")
assert_eq(type(ChurchOfBeefDB.event), "table", "v1 without leftovers still gets event")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "v1 event hook is empty")
assert_eq(type(ChurchOfBeefDB.decree), "table", "v1 without leftovers still gets decree")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "v1 decree hook is empty")

--------------------------------------------------------------------------------
-- Dirty demo / per-character SV: Init and Save must not error
--------------------------------------------------------------------------------
ChurchOfBeefDB = {}
initOk("empty table")
saveOk("empty table")
assert_eq(ChurchOfBeefDB.version, 8, "empty table gets schema 8")
assert_eq(type(ChurchOfBeefDB.ui), "table", "empty table gets ui")
assert_eq(type(ChurchOfBeefDB.store), "table", "empty table gets store")
assert_eq(type(ChurchOfBeefDB.event), "table", "empty table gets event")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "empty table event hook is empty")
assert_eq(type(ChurchOfBeefDB.decree), "table", "empty table gets decree")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "empty table decree hook is empty")

ChurchOfBeefDB = { version = "3", ui = "broken", ladder = true, scoring = 1 }
initOk("typed-wrong leftovers")
saveOk("typed-wrong leftovers")
assert_eq(ChurchOfBeefDB.version, 8, "string version is stamped to 7")
assert_eq(type(ChurchOfBeefDB.ui), "table", "non-table ui is replaced")
assert_eq(ChurchOfBeefDB.ladder, true, "non-table leftover ladder is not wiped")
assert_eq(ChurchOfBeefDB.scoring, 1, "non-table leftover scoring is not wiped")
assert_eq(type(ChurchOfBeefDB.store), "table", "typed-wrong leftovers still get store")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "typed-wrong leftovers are not imported")
assert_eq(type(ChurchOfBeefDB.event), "table", "typed-wrong leftovers still get event")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "typed-wrong leftovers are not imported into event")
assert_eq(type(ChurchOfBeefDB.decree), "table", "typed-wrong leftovers still get decree")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "typed-wrong leftovers are not imported into decree")

ChurchOfBeefDB = { version = 2 }
initOk("missing ui")
saveOk("missing ui")
assert_eq(type(ChurchOfBeefDB.ui), "table", "missing ui is filled")
assert_eq(type(ChurchOfBeefDB.store), "table", "missing-ui table gets store")
assert_eq(type(ChurchOfBeefDB.event), "table", "missing-ui table gets event")
assert_eq(type(ChurchOfBeefDB.decree), "table", "missing-ui table gets decree")

ChurchOfBeefDB = {
  version = 3,
  ui = { announce = false, shown = true, point = "TOPLEFT" },
  ladder = { records = {}, suggestions = { pending = 1 } },
  scoring = { granted = {} },
}
initOk("classic demo leftovers")
saveOk("classic demo leftovers")
assert_eq(ChurchOfBeefDB.ui.announce, false, "dirty demo keeps announce")
assert_eq(ChurchOfBeefDB.ui.shown, true, "dirty demo keeps shown")
assert_eq(ChurchOfBeefDB.ui.point, "TOPLEFT", "dirty demo keeps point")
assert_eq(ChurchOfBeefDB.ladder.suggestions.pending, 1, "classic demo leftover payload stays")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "classic demo leftovers are not imported")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "classic demo leftovers are not imported into event")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "classic demo leftovers are not imported into decree")

--------------------------------------------------------------------------------
-- Defaults merge never wipes unknown future keys
--------------------------------------------------------------------------------
ChurchOfBeefDB.futureRoot = "keep-me"
ChurchOfBeefDB.ui.streamerMode = true
ChurchOfBeefDB.ui.announce = nil

DB:Init()
assert_eq(ChurchOfBeefDB.futureRoot, "keep-me", "unknown root key survives Init")
assert_eq(ChurchOfBeefDB.ui.streamerMode, true, "unknown ui key survives Init")
assert_eq(ChurchOfBeefDB.ui.announce, true, "missing announce is filled")
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, false, "missing welcomeSeen fills false")
assert_eq(ChurchOfBeefDB.version, 8, "welcomeSeen fill stays schema 8")
ChurchOfBeefDB.ui.welcomeSeen = true
DB:Init()
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, true, "existing welcomeSeen is kept")
assert_eq(ChurchOfBeefDB.ui.streamerMode, true, "streamerMode pin stays after welcomeSeen keep")
assert_eq(ChurchOfBeefDB.version, 8, "keeping welcomeSeen stays schema 8")
assert_eq(type(ChurchOfBeefDB.store), "table", "unknown-key merge keeps store")
assert_eq(type(ChurchOfBeefDB.event), "table", "unknown-key merge keeps event")
assert_eq(type(ChurchOfBeefDB.decree), "table", "unknown-key merge keeps decree")

ChurchOfBeefDB = { version = 99, ui = { shown = true, announce = false } }
DB:Init()
assert_eq(ChurchOfBeefDB.version, 99, "downgrade keeps the higher stamp")
assert_eq(ChurchOfBeefDB.ui.shown, true, "existing shown is kept")
assert_eq(ChurchOfBeefDB.ui.announce, false, "existing announce is kept")
assert_eq(type(ChurchOfBeefDB.store), "table", "downgrade still gets a store hook")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "downgrade store hook is empty")
assert_eq(type(ChurchOfBeefDB.event), "table", "downgrade still gets an event hook")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "downgrade event hook is empty")
assert_eq(type(ChurchOfBeefDB.decree), "table", "downgrade still gets a decree hook")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "downgrade decree hook is empty")
assert_eq(ChurchOfBeef.Store, nil, "no-Store section never loads Store")
assert_eq(ChurchOfBeef.Runtime, nil, "no-Runtime section never loads Runtime")
assert_eq(ChurchOfBeef.Decree, nil, "no-Decree section never loads Decree")

--------------------------------------------------------------------------------
-- Persist: Common + Ranks + Store + DB. Snapshot table, not Archive string.
--------------------------------------------------------------------------------
dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local Store = ChurchOfBeef.Store
assert_eq(type(Store), "table", "persist section has Store")
assert_eq(type(Store.Snapshot), "function", "Store.Snapshot exists")
assert_eq(type(Store.Restore), "function", "Store.Restore exists")
assert_eq(ChurchOfBeefDB.version, 99, "loading Store does not bump schema")
assert_eq(ChurchOfBeef.Runtime, nil, "Store persist section does not load Runtime")

local function resetStore()
  assert_eq(Store:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
end

local restoreCalls = 0
local realRestore = Store.Restore
function Store:Restore(...)
  restoreCalls = restoreCalls + 1
  return realRestore(self, ...)
end

local function leftovers()
  return {
    records = { "Alice" },
    suggestions = { "Bob" },
  }
end

--------------------------------------------------------------------------------
-- Init with Store still leaves the empty hook. Save writes a Snapshot table.
--------------------------------------------------------------------------------
resetStore()
restoreCalls = 0
ChurchOfBeefDB = nil
DB:Init()
assert_eq(restoreCalls, 0, "fresh Init does not Restore the empty hook")
assert_eq(ChurchOfBeefDB.version, 8, "schema version stays 7")
assert_eq(type(ChurchOfBeefDB.store), "table", "fresh Init with Store still has store")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "Init does not Snapshot")
assert_eq(ChurchOfBeefDB.store.humans, nil, "Init does not invent humans")
assert_eq(ChurchOfBeefDB.store.characters, nil, "Init does not invent characters")
assert_eq(type(ChurchOfBeefDB.store), "table", "fresh store is a table, not an Archive string")
assert_eq(type(ChurchOfBeefDB.event), "table", "fresh Init with Store still has event")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Init without Runtime does not invent an event snapshot")
assert_eq(type(ChurchOfBeefDB.decree), "table", "fresh Init with Store still has decree")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Init without Decree does not invent a decree snapshot")

assert_true(DB:Save(), "Save with Store succeeds")
assert_eq(type(ChurchOfBeefDB.store), "table", "Save writes a table, not an Archive string")
assert_eq(type(ChurchOfBeefDB.store.humans), "table", "Save Snapshot has humans")
assert_eq(type(ChurchOfBeefDB.store.characters), "table", "Save Snapshot has characters")
assert_eq(type(ChurchOfBeefDB.store.ceremonyLog), "table", "Save Snapshot has ceremonyLog")
assert_eq(type(ChurchOfBeefDB.store.markedMoments), "table", "Save Snapshot has markedMoments")
assert_eq(#ChurchOfBeefDB.store.humans, 0, "empty Store Snapshots empty humans")
assert_eq(#ChurchOfBeefDB.store.characters, 0, "empty Store Snapshots empty characters")
assert_eq(ChurchOfBeefDB.store.ladder, nil, "Save does not import leftover ladder")
assert_eq(ChurchOfBeefDB.store.scoring, nil, "Save does not import leftover scoring")
assert_eq(ChurchOfBeefDB.store.suggestions, nil, "Save does not import leftover suggestions")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Save without Runtime does not invent an event snapshot")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Save without Decree does not invent a decree snapshot")
assert_eq(ChurchOfBeefDB.Grant, nil, "Save does not invent Grant")
assert_eq(ChurchOfBeefDB.standing, nil, "Save does not invent standing")

--------------------------------------------------------------------------------
-- Empty {} must not Restore (would replace live memory with nobody)
--------------------------------------------------------------------------------
resetStore()
local keep = Store:CreateHuman({ name = "Keep" }, 100)
restoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = {} }
DB:Init()
assert_eq(restoreCalls, 0, "empty store hook does not call Restore")
assert_eq(Store:GetHuman(keep.id).name, "Keep", "empty hook does not wipe live humans")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "empty hook stays {}")

resetStore()
keep = Store:CreateHuman({ name = "StillHere" }, 101)
restoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {} }
DB:Init()
assert_eq(restoreCalls, 0, "missing store (filled to {}) does not Restore")
assert_eq(Store:GetHuman(keep.id).name, "StillHere", "missing store does not wipe live humans")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "missing store becomes {}")

resetStore()
keep = Store:CreateHuman({ name = "Partial" }, 102)
restoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = { humans = {} } }
DB:Init()
assert_eq(restoreCalls, 0, "humans without characters is not a Snapshot")
assert_eq(Store:GetHuman(keep.id).name, "Partial", "partial store does not wipe live humans")

resetStore()
keep = Store:CreateHuman({ name = "CharsOnly" }, 103)
restoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = { characters = {} } }
DB:Init()
assert_eq(restoreCalls, 0, "characters without humans is not a Snapshot")
assert_eq(Store:GetHuman(keep.id).name, "CharsOnly", "characters-only store does not wipe live humans")

resetStore()
keep = Store:CreateHuman({ name = "TypedWrong" }, 104)
restoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = { humans = "nope", characters = {} } }
DB:Init()
assert_eq(restoreCalls, 0, "non-table humans is not a Snapshot")
assert_eq(Store:GetHuman(keep.id).name, "TypedWrong", "typed-wrong Snapshot fields do not wipe live humans")

--------------------------------------------------------------------------------
-- Snapshot-shaped store Restores. Round-trip survives Reset.
--------------------------------------------------------------------------------
resetStore()
local human = Store:CreateHuman({ name = "Persisted" }, 2000)
local char = Store:CreateCharacter({ name = "PersistedAlt", class = "Mage", level = 70 }, 2001)
Store:LinkCharacter(char.id, human.id, 2002)
Store:SetRank(human.id, 4, 2003)
Store:SetCouncil(human.id, true)
Store:AddHonorific(human.id, "Defender of the Faith")
local foe = Store:CreateCharacter({ name = "Foe" }, 2004)
Store:RecordGoraResult(char.id, {
  opponentId = foe.id,
  ruling = "victor",
  won = true,
  famousUpset = true,
}, 2005)
Store:TombstoneHuman(human.id, 2006)
Store:AppendCeremony("Gora", { char.id }, 2007)
Store:FlagMoment("Shattrath", 2008)

ChurchOfBeefDB = {
  version = 6,
  ui = { shown = true, announce = false },
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
assert_true(DB:Save(), "Save persists a filled Store")
assert_eq(type(ChurchOfBeefDB.store), "table", "filled Save is a table")
assert_eq(#ChurchOfBeefDB.store.humans, 1, "filled Save Snapshots the human")
assert_eq(ChurchOfBeefDB.store.humans[1].name, "Persisted", "filled Save keeps human name")
assert_eq(ChurchOfBeefDB.store.humans[1].rankId, 4, "filled Save keeps rank")
assert_eq(ChurchOfBeefDB.store.humans[1].elevationAt, 2003, "filled Save keeps elevationAt")
assert_eq(ChurchOfBeefDB.store.humans[1].inactive, true, "filled Save keeps tombstone")
assert_eq(ChurchOfBeefDB.store.humans[1].honorifics[1], "Defender of the Faith", "filled Save keeps honorifics")
assert_eq(#ChurchOfBeefDB.store.characters, 2, "filled Save Snapshots both characters")
assert_eq(ChurchOfBeefDB.store.characters[1].gora.results[1].famousUpset, true, "filled Save keeps Famous Upset")
assert_eq(ChurchOfBeefDB.store.ceremonyLog[1].type, "Gora", "filled Save keeps ceremony log")
assert_eq(ChurchOfBeefDB.store.markedMoments[1].location, "Shattrath", "filled Save keeps marked moments")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "Save does not wipe leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "Save does not wipe leftover scoring")
assert_eq(ChurchOfBeefDB.suggestions.leftover, true, "Save does not wipe leftover suggestions")
assert_eq(ChurchOfBeefDB.store.ladder, nil, "filled Save does not copy ladder into store")
assert_eq(ChurchOfBeefDB.store.scoring, nil, "filled Save does not copy scoring into store")
assert_eq(ChurchOfBeefDB.store.suggestions, nil, "filled Save does not copy suggestions into store")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "filled Store Save does not invent an event snapshot")
assert_eq(eventField(ChurchOfBeefDB.event, "ladder"), nil, "filled Save does not copy ladder into event")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "filled Store Save does not invent a decree snapshot")
assert_eq(decreeField(ChurchOfBeefDB.decree, "ladder"), nil, "filled Save does not copy ladder into decree")
assert_eq(ChurchOfBeefDB.ui.shown, true, "Save still keeps ui")
assert_eq(ChurchOfBeefDB.version, 8, "filled Save stamps schema 8")

local saved = ChurchOfBeefDB.store
resetStore()
assert_eq(Store:GetHuman(human.id), nil, "reset cleared live humans before Restore")
restoreCalls = 0
ChurchOfBeefDB = {
  version = 6,
  ui = { shown = true, announce = false },
  store = saved,
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
DB:Init()
assert_eq(restoreCalls, 1, "Snapshot-shaped store Restores once")
assert_eq(Store:GetHuman(human.id).name, "Persisted", "Init Restores the human")
assert_eq(Store:GetHuman(human.id).rankId, 4, "Init Restores rank")
assert_eq(Store:GetHuman(human.id).elevationAt, 2003, "Init Restores elevationAt")
assert_eq(Store:GetHuman(human.id).inactive, true, "Init Restores tombstone")
assert_eq(Store:GetCharacter(char.id).gora.wins, 1, "Init Restores Gora wins")
assert_eq(Store:GetCeremonyLog()[1].type, "Gora", "Init Restores ceremony log")
assert_eq(Store:GetMarkedMoments()[1].location, "Shattrath", "Init Restores marked moments")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "Init does not wipe leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "Init does not wipe leftover scoring")
assert_eq(ChurchOfBeefDB.suggestions.leftover, true, "Init does not wipe leftover suggestions")
assert_eq(ChurchOfBeefDB.store.ladder, nil, "Init does not copy leftovers into store")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Init without Runtime leaves event empty")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Init without Decree leaves decree empty")
assert_eq(ChurchOfBeefDB.version, 8, "Init after Snapshot stamps schema 8")

--------------------------------------------------------------------------------
-- Leftovers + empty hook: still no Restore, still no import
--------------------------------------------------------------------------------
resetStore()
keep = Store:CreateHuman({ name = "LiveLeftover" }, 300)
restoreCalls = 0
ChurchOfBeefDB = {
  version = 1,
  ui = { announce = true, shown = false },
  store = {},
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
DB:Init()
assert_eq(restoreCalls, 0, "leftovers plus empty hook do not Restore")
assert_eq(Store:GetHuman(keep.id).name, "LiveLeftover", "leftover Init does not wipe live humans")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "leftover ladder survives persist Init")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "leftovers are not imported on persist Init")
assert_eq(ChurchOfBeefDB.store.ladder, nil, "ladder stays at the SV root")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "leftovers are not imported into event on persist Init")
assert_eq(eventField(ChurchOfBeefDB.event, "ladder"), nil, "ladder stays at the SV root, not in event")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "leftovers are not imported into decree on persist Init")
assert_eq(decreeField(ChurchOfBeefDB.decree, "ladder"), nil, "ladder stays at the SV root, not in decree")
assert_eq(ChurchOfBeefDB.version, 8, "old leftover table stamps schema 8")

assert_true(DB:Save(), "Save with leftovers and Store succeeds")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "Save with Store keeps leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "Save with Store keeps leftover scoring")
assert_eq(ChurchOfBeefDB.store.ladder, nil, "Save with Store does not copy leftovers into Snapshot")
assert_eq(type(ChurchOfBeefDB.store.humans), "table", "Save with leftovers still writes Snapshot humans")
assert_eq(#ChurchOfBeefDB.store.humans, 1, "Save with leftovers Snapshots the live human")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Save with Store still does not invent an event snapshot")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Save with Store still does not invent a decree snapshot")

--------------------------------------------------------------------------------
-- Save without an SV table still fails. No Grant / standing / Archive APIs on DB.
--------------------------------------------------------------------------------
ChurchOfBeefDB = nil
assert_eq(DB:Save(), false, "Save without an SV table still returns false")
assert_eq(DB.Grant, nil, "DB has no Grant")
assert_eq(DB.SetStanding, nil, "DB has no SetStanding")
assert_eq(DB.Export, nil, "DB is not the Archive codec")
assert_eq(DB.Import, nil, "DB has no Archive Import")
assert_eq(DB.StartEvent, nil, "DB has no StartEvent")
assert_eq(DB.OpenRite, nil, "DB has no OpenRite")

--------------------------------------------------------------------------------
-- Persist event: Common + Runtime + DB. Snapshot is the event object.
--------------------------------------------------------------------------------
dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local Runtime = ChurchOfBeef.Runtime
assert_eq(type(Runtime), "table", "event persist section has Runtime")
assert_eq(type(Runtime.Snapshot), "function", "Runtime.Snapshot exists")
assert_eq(type(Runtime.Restore), "function", "Runtime.Restore exists")
assert_eq(type(Store), "table", "event persist keeps Store loaded")
-- Ceremony Save is Pope-only. Isolated tests with no Sender leave blobs.
-- Stub Pope so existing event Save pins still write.
stubWriterPope(true)

local function resetRuntime()
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
end

local eventRestoreCalls = 0
local realEventRestore = Runtime.Restore
function Runtime:Restore(...)
  eventRestoreCalls = eventRestoreCalls + 1
  return realEventRestore(self, ...)
end

--------------------------------------------------------------------------------
-- Init with Runtime still leaves the empty hook. Save writes a Snapshot.
--------------------------------------------------------------------------------
resetRuntime()
eventRestoreCalls = 0
ChurchOfBeefDB = nil
DB:Init()
assert_eq(eventRestoreCalls, 0, "fresh Init does not Restore the empty event hook")
assert_eq(ChurchOfBeefDB.version, 8, "fresh Init with Runtime stays schema 8")
assert_eq(type(ChurchOfBeefDB.event), "table", "fresh Init with Runtime still has event")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Init does not Snapshot the event")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), nil, "Init does not invent event state")
assert_eq(type(ChurchOfBeefDB.decree), "table", "fresh Init with Runtime still has decree")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Init without Decree does not invent a decree snapshot")
assert_eq(rootKeys(ChurchOfBeefDB), "decree,event,gora,nights,store,ui,version", "Runtime Init root is { version, ui, store, event, gora, decree }")

assert_true(DB:Save(), "Save with Runtime succeeds")
assert_eq(type(ChurchOfBeefDB.event), "table", "Save writes an event table")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), "QUIET", "Save Snapshots cold QUIET")
assert_eq(eventField(ChurchOfBeefDB.event, "sequence"), 0, "cold Snapshot sequence is 0")
assert_eq(type(eventField(ChurchOfBeefDB.event, "subjects")), "table", "Save Snapshot has subjects")
assert_eq(eventField(ChurchOfBeefDB.event, "holdSeconds"), nil, "Save does not invent holdSeconds")
assert_eq(eventField(ChurchOfBeefDB.event, "holdTimeout"), nil, "Save does not invent holdTimeout")
assert_eq(eventField(ChurchOfBeefDB.event, "awaitingPope"), nil, "cold Save does not invent awaitingPope")
assert_eq(ChurchOfBeefDB.runtime, nil, "Save does not invent a runtime key")
assert_eq(ChurchOfBeefDB.ceremony, nil, "Save does not invent a ceremony key")

--------------------------------------------------------------------------------
-- Empty {} / missing / non-string state must not Restore (live event stays)
--------------------------------------------------------------------------------
resetRuntime()
local started = Runtime:StartEvent()
assert_eq(started.state, "ASSEMBLY", "StartEvent enters ASSEMBLY")
eventRestoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = {}, event = {} }
DB:Init()
assert_eq(eventRestoreCalls, 0, "empty event hook does not call Restore")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "empty hook does not wipe live event")
assert_eq(Runtime:Snapshot().eventId, started.eventId, "empty hook keeps the live event id")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "empty event hook stays {}")

resetRuntime()
started = Runtime:StartEvent()
eventRestoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = {} }
DB:Init()
assert_eq(eventRestoreCalls, 0, "missing event (filled to {}) does not Restore")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "missing event does not wipe live event")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "missing event becomes {}")

resetRuntime()
started = Runtime:StartEvent()
eventRestoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = {}, event = { future = true } }
DB:Init()
assert_eq(eventRestoreCalls, 0, "event without state is not a Runtime snapshot")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "stateless event does not wipe live event")
assert_eq(eventField(ChurchOfBeefDB.event, "future"), true, "unknown event key survives Init")

resetRuntime()
started = Runtime:StartEvent()
eventRestoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = {}, event = { state = 1 } }
DB:Init()
assert_eq(eventRestoreCalls, 0, "non-string state is not a Runtime snapshot")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "typed-wrong state does not wipe live event")

resetRuntime()
started = Runtime:StartEvent()
eventRestoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = {}, event = { state = true } }
DB:Init()
assert_eq(eventRestoreCalls, 0, "boolean state is not a Runtime snapshot")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "boolean state does not wipe live event")

--------------------------------------------------------------------------------
-- Snapshot-shaped event Restores. Round-trip survives Reset.
--------------------------------------------------------------------------------
resetRuntime()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 21, 22 } })
ChurchOfBeefDB = {
  version = 6,
  ui = { shown = true, announce = false },
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
assert_true(DB:Save(), "Save persists a live Runtime event")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), "RITE", "filled Save Snapshots RITE")
assert_eq(eventField(ChurchOfBeefDB.event, "riteType"), "Gora", "filled Save keeps rite type")
assert_eq(eventField(ChurchOfBeefDB.event, "eventId"), 1, "filled Save keeps event id")
assert_eq(eventField(ChurchOfBeefDB.event, "sequence"), 2, "filled Save keeps sequence")
assert_eq((eventSubjects(ChurchOfBeefDB.event).fighters or {})[1], 21, "filled Save keeps fighters")
assert_eq(eventSubjects(ChurchOfBeefDB.event).candidate, nil, "filled Save keeps nil candidate")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "event Save does not wipe leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "event Save does not wipe leftover scoring")
assert_eq(ChurchOfBeefDB.suggestions.leftover, true, "event Save does not wipe leftover suggestions")
assert_eq(eventField(ChurchOfBeefDB.event, "ladder"), nil, "filled Save does not copy ladder into event")
assert_eq(eventField(ChurchOfBeefDB.event, "scoring"), nil, "filled Save does not copy scoring into event")
assert_eq(eventField(ChurchOfBeefDB.event, "suggestions"), nil, "filled Save does not copy suggestions into event")
assert_eq(ChurchOfBeefDB.store.ladder, nil, "event Save does not copy leftovers into store")
assert_eq(eventField(ChurchOfBeefDB.event, "holdSeconds"), nil, "filled Save does not invent holdSeconds")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "filled event Save does not invent a decree snapshot")
assert_eq(ChurchOfBeefDB.version, 8, "filled event Save stamps schema 8")

local savedEvent = ChurchOfBeefDB.event
resetRuntime()
assert_eq(Runtime:Snapshot().state, "QUIET", "reset cleared live event before Restore")
eventRestoreCalls = 0
ChurchOfBeefDB = {
  version = 6,
  ui = { shown = true, announce = false },
  event = savedEvent,
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
DB:Init()
assert_eq(eventRestoreCalls, 1, "Snapshot-shaped event Restores once")
local resumed = Runtime:Snapshot()
assert_eq(resumed.state, "RITE", "Init Restores the state")
assert_eq(resumed.riteType, "Gora", "Init Restores the rite type")
assert_eq(resumed.eventId, 1, "Init Restores the event id")
assert_eq(resumed.sequence, 2, "Init Restores the sequence")
assert_eq(((resumed.subjects or {}).fighters or {})[1], 21, "Init Restores fighters")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "event Init does not wipe leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "event Init does not wipe leftover scoring")
assert_eq(ChurchOfBeefDB.suggestions.leftover, true, "event Init does not wipe leftover suggestions")
assert_eq(eventField(ChurchOfBeefDB.event, "ladder"), nil, "event Init does not copy leftovers into event")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "event Init without Decree leaves decree empty")
assert_eq(ChurchOfBeefDB.version, 8, "Init after event Snapshot stamps schema 8")

local afterClose = Runtime:CloseRite() or {}
assert_eq(afterClose.state, "CONSEQUENCE", "verbs resume from the restored event")
assert_eq(afterClose.sequence, 3, "sequence increments from the restored value")

--------------------------------------------------------------------------------
-- Task 10: DB:Init still Restores a saved RITE with no local-character gate.
-- The pew Quiet drop is PLAYER_LOGIN, not ADDON_LOADED.
--------------------------------------------------------------------------------
do
  local srcFile = io.open("addon/ChurchOfBeef/Core/DB.lua", "r")
  assert_true(srcFile ~= nil, "DB.lua is readable for the Task 10 source pin")
  local src = srcFile:read("*a")
  srcFile:close()
  assert_eq(src:find("UnitName", 1, true), nil, "DB.lua does not mention UnitName")
  local initStart = src:find("function DB:Init", 1, true)
  local saveStart = src:find("function DB:Save", 1, true)
  assert_true(initStart ~= nil, "DB:Init is present")
  assert_true(saveStart ~= nil, "DB:Save is present")
  local initChunk = src:sub(initStart, saveStart - 1)
  assert_eq(initChunk:find("IsRegisteredPope", 1, true), nil, "DB:Init does not mention IsRegisteredPope")
  assert_eq(initChunk:find("UnitName", 1, true), nil, "DB:Init does not mention UnitName")
  assert_true(src:find("localWriterIsPope", 1, true) ~= nil, "Save documents the Pope writer predicate")

  resetRuntime()
  Runtime:StartEvent()
  Runtime:OpenRite("Gora", { fighters = { 21, 22 } })
  local live = Runtime:Snapshot()
  ChurchOfBeefDB = { version = 7, ui = {}, event = live }
  resetRuntime()
  assert_eq(Runtime:Snapshot().state, "QUIET", "reset before the Task 10 Init pin")
  local savedUnit = UnitName
  local savedSender = ChurchOfBeef.Sender
  UnitName = function(unit)
    if unit == "player" then return "Pewalt" end
    return nil
  end
  ChurchOfBeef.Sender = {
    IsRegisteredPope = function() return false end,
  }
  eventRestoreCalls = 0
  DB:Init()
  assert_eq(eventRestoreCalls, 1, "Init Restores with a local name present")
  assert_eq(Runtime:Snapshot().state, "RITE", "Init Restores RITE with no Pope predicate")
  assert_eq(Runtime:Snapshot().eventId, live.eventId, "Init keeps the saved event id")
  assert_eq(ChurchOfBeefDB.version, 8, "Task 10 Init pin stays schema 8")
  UnitName = savedUnit
  ChurchOfBeef.Sender = savedSender
  stubWriterPope(true)
end

--------------------------------------------------------------------------------
-- QUIET Restore is a Restore. awaitingPope is Runtime's flag, not a sixth state.
--------------------------------------------------------------------------------
resetRuntime()
Runtime:StartEvent()
Runtime:MarkPopeLost()
ChurchOfBeefDB = { version = 6, ui = {}, store = {} }
assert_true(DB:Save(), "Save persists awaitingPope on the event object")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), "ASSEMBLY", "awaitingPope Save is not a sixth state")
assert_eq(eventField(ChurchOfBeefDB.event, "awaitingPope"), true, "Save keeps awaitingPope")
assert_eq(eventField(ChurchOfBeefDB.event, "holdSeconds"), nil, "awaitingPope Save does not invent holdSeconds")

local lostEvent = ChurchOfBeefDB.event
resetRuntime()
eventRestoreCalls = 0
ChurchOfBeefDB = { version = 6, ui = {}, store = {}, event = lostEvent }
DB:Init()
assert_eq(eventRestoreCalls, 1, "awaitingPope Snapshot Restores once")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Init Restores ASSEMBLY, not a sixth state")
assert_eq(Runtime:Snapshot().awaitingPope, true, "Init Restores awaitingPope")

resetRuntime()
eventRestoreCalls = 0
ChurchOfBeefDB = {
  version = 6,
  ui = {},
  store = {},
  event = {
    state = "QUIET",
    sequence = 4,
    subjects = { candidate = nil, fighters = nil },
    awaitingPope = true,
  },
}
DB:Init()
assert_eq(eventRestoreCalls, 1, "QUIET event with string state Restores")
assert_eq(Runtime:Snapshot().state, "QUIET", "QUIET Restore lands in QUIET")
assert_eq(Runtime:Snapshot().awaitingPope, nil, "QUIET Restore drops awaitingPope")

--------------------------------------------------------------------------------
-- Leftovers + empty event hook: still no Restore, still no import
--------------------------------------------------------------------------------
resetRuntime()
Runtime:StartEvent()
eventRestoreCalls = 0
ChurchOfBeefDB = {
  version = 1,
  ui = { announce = true, shown = false },
  event = {},
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
DB:Init()
assert_eq(eventRestoreCalls, 0, "leftovers plus empty event hook do not Restore")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "leftover event Init does not wipe live event")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "leftover ladder survives event Init")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "leftovers are not imported on event Init")
assert_eq(eventField(ChurchOfBeefDB.event, "ladder"), nil, "ladder stays at the SV root during event Init")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "leftovers are not imported into decree on event Init")
assert_eq(ChurchOfBeefDB.version, 8, "old leftover table with event hook stamps schema 8")

assert_true(DB:Save(), "Save with leftovers and Runtime succeeds")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "Save with Runtime keeps leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "Save with Runtime keeps leftover scoring")
assert_eq(eventField(ChurchOfBeefDB.event, "ladder"), nil, "Save with Runtime does not copy leftovers into event")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), "ASSEMBLY", "Save with leftovers still writes the live event")
assert_eq(ChurchOfBeefDB.store.ladder, nil, "Save with Runtime does not copy leftovers into store")

--------------------------------------------------------------------------------
-- Runtime without Store: event persists; store hook stays empty.
--------------------------------------------------------------------------------
local savedStoreMod = ChurchOfBeef.Store
ChurchOfBeef.Store = nil
resetRuntime()
Runtime:StartEvent()
Runtime:OpenRite("Knighting", { candidate = 9 })
ChurchOfBeefDB = { version = 6, ui = {}, store = {}, event = {} }
assert_true(DB:Save(), "Save with Runtime and no Store succeeds")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), "RITE", "no-Store Save still Snapshots the event")
assert_eq(eventField(ChurchOfBeefDB.event, "riteType"), "Knighting", "no-Store Save keeps rite type")
assert_eq(eventSubjects(ChurchOfBeefDB.event).candidate, 9, "no-Store Save keeps candidate")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "no-Store Save does not invent store rows")
assert_eq(eventField(ChurchOfBeefDB.event, "holdSeconds"), nil, "no-Store Save does not invent holdSeconds")
ChurchOfBeef.Store = savedStoreMod

--------------------------------------------------------------------------------
-- Sixth-state name is still a string, so Restore is called; Runtime refuses.
--------------------------------------------------------------------------------
resetRuntime()
Runtime:StartEvent()
eventRestoreCalls = 0
ChurchOfBeefDB = {
  version = 6,
  ui = {},
  store = {},
  event = { eventId = 1, state = "AWAITING_POPE", sequence = 1 },
}
DB:Init()
assert_eq(eventRestoreCalls, 1, "string state still calls Restore")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "failed sixth-state Restore leaves live event")

--------------------------------------------------------------------------------
-- No Grant / Director / hold APIs on DB after Runtime persist.
--------------------------------------------------------------------------------
assert_eq(DB.Grant, nil, "DB still has no Grant")
assert_eq(DB.StartEvent, nil, "DB still has no StartEvent")
assert_eq(DB.MarkPopeLost, nil, "DB has no MarkPopeLost")
assert_eq(DB.holdSeconds, nil, "DB has no holdSeconds")

Store.Restore = realRestore
Runtime.Restore = realEventRestore

--------------------------------------------------------------------------------
-- Persist gora: Common + Store + Runtime + Gora + DB. Schema stays 7.
-- Restore after event. Ceremony Save is Pope-only.
--------------------------------------------------------------------------------
dofile("addon/ChurchOfBeef/Core/Gora.lua")
local Gora = ChurchOfBeef.Gora
assert_eq(type(Gora), "table", "gora persist section has Gora")
assert_eq(type(Gora.Snapshot), "function", "Gora.Snapshot exists")
assert_eq(type(Gora.Restore), "function", "Gora.Restore exists")
assert_eq(ChurchOfBeef.DB.SCHEMA_VERSION, nil, "SCHEMA_VERSION is not a public DB field")

local function resetGoraDesk()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Gora:ResetForTests(), true, "Gora ResetForTests runs under _IN_TEST")
end

local function twoPersistChars()
  local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
  return a, b
end

local function goraHasSender(petitions, key)
  if type(petitions) ~= "table" then return false end
  if type(petitions[key]) == "table" then return true end
  for _, row in pairs(petitions) do
    if type(row) == "table" and row.senderKey == key then return true end
  end
  return false
end

local goraRestoreCalls = 0
local eventOrder = {}
local realGoraRestore = Gora.Restore
local realEventRestoreForOrder = Runtime.Restore
function Runtime:Restore(...)
  eventOrder[#eventOrder + 1] = "event"
  return realEventRestoreForOrder(self, ...)
end
function Gora:Restore(...)
  eventOrder[#eventOrder + 1] = "gora"
  goraRestoreCalls = goraRestoreCalls + 1
  return realGoraRestore(self, ...)
end

--------------------------------------------------------------------------------
-- Fresh Init with Gora still leaves the empty hook. Pope Save writes a Snapshot.
--------------------------------------------------------------------------------
resetGoraDesk()
goraRestoreCalls = 0
ChurchOfBeefDB = nil
stubWriterPope(true)
DB:Init()
assert_eq(goraRestoreCalls, 0, "fresh Init does not Restore the empty gora hook")
assert_eq(ChurchOfBeefDB.version, 8, "fresh Init with Gora stays schema 8")
assert_eq(type(ChurchOfBeefDB.gora), "table", "fresh Init with Gora still has gora")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "Init does not Snapshot the gora desk")
assert_eq(goraField(ChurchOfBeefDB.gora, "eventId"), nil, "Init does not invent gora eventId")
assert_eq(rootKeys(ChurchOfBeefDB), "decree,event,gora,nights,store,ui,version", "Gora Init root includes gora")

assert_true(DB:Save(), "Pope Save with Gora succeeds")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "Pope Save of an empty desk is {}")
assert_eq(goraField(ChurchOfBeefDB.gora, "eventId"), nil, "empty desk Save is not a snapshot")

--------------------------------------------------------------------------------
-- Empty {} / missing / non-number eventId must not Restore (live desk stays)
--------------------------------------------------------------------------------
resetGoraDesk()
Runtime:StartEvent()
local keepA, keepB = twoPersistChars()
Gora:Sanction(keepA.id, keepB.id)
goraRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, gora = {} }
DB:Init()
assert_eq(goraRestoreCalls, 0, "empty gora hook does not call Restore")
assert_eq(Gora:GetSanctioned().fighterA, keepA.id, "empty gora hook does not wipe the live pair")
assert_eq(goraKeys(ChurchOfBeefDB.gora), "", "empty gora hook stays {}")

resetGoraDesk()
Runtime:StartEvent()
keepA, keepB = twoPersistChars()
Gora:Sanction(keepA.id, keepB.id)
goraRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {} }
DB:Init()
assert_eq(goraRestoreCalls, 0, "missing gora (filled to {}) does not Restore")
assert_eq(Gora:GetSanctioned().fighterA, keepA.id, "missing gora does not wipe the live pair")

resetGoraDesk()
Runtime:StartEvent()
keepA, keepB = twoPersistChars()
Gora:Sanction(keepA.id, keepB.id)
goraRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, gora = { future = true } }
DB:Init()
assert_eq(goraRestoreCalls, 0, "gora without eventId is not a snapshot")
assert_eq(Gora:GetSanctioned().fighterA, keepA.id, "stateless gora does not wipe the live pair")
assert_eq(goraField(ChurchOfBeefDB.gora, "future"), true, "unknown gora key survives Init")

--------------------------------------------------------------------------------
-- Pope Save writes gora. Restore order is event then gora. DeclareVictor works.
--------------------------------------------------------------------------------
resetGoraDesk()
stubWriterPope(true)
Runtime:StartEvent()
local fightA, fightB = twoPersistChars()
Gora:PetitionFromSender("Zipfresh")
Gora:Sanction(fightA.id, fightB.id, "come as you are")
Gora:RecordFavor(fightA.id, fightA.id)
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, gora = {} }
assert_true(DB:Save(), "Pope Save persists a live Gora desk")
assert_eq(goraField(ChurchOfBeefDB.gora, "eventId"), 1, "Pope Save writes gora eventId")
assert_eq((ChurchOfBeefDB.gora.sanctioned or {}).fighterA, fightA.id, "Pope Save writes fighter A")
assert_eq((ChurchOfBeefDB.gora.sanctioned or {}).fighterB, fightB.id, "Pope Save writes fighter B")
assert_eq((ChurchOfBeefDB.gora.favorPicks or {})[fightA.id], fightA.id, "Pope Save writes favorPicks")
assert_eq(goraHasSender(ChurchOfBeefDB.gora.petitions, "zipfresh"), true, "Pope Save writes the unsigned petition")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), "ASSEMBLY", "Pope Save still writes event")
assert_eq(ChurchOfBeefDB.version, 8, "Pope Gora Save stays schema 8")

local savedEvent = ChurchOfBeefDB.event
local savedGora = ChurchOfBeefDB.gora
local savedStore = ChurchOfBeefDB.store
resetGoraDesk()
assert_eq(Gora:GetSanctioned(), nil, "reset cleared the live pair before Restore")
eventOrder = {}
goraRestoreCalls = 0
ChurchOfBeefDB = {
  version = 7,
  ui = {},
  store = savedStore,
  event = savedEvent,
  gora = savedGora,
}
DB:Init()
assert_eq(goraRestoreCalls, 1, "Snapshot-shaped gora Restores once")
assert_eq(eventOrder[1], "event", "event Restores before gora")
assert_eq(eventOrder[2], "gora", "gora Restores after event")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Init Restores the event first")
assert_eq(Gora:GetSanctioned().fighterA, fightA.id, "Init Restores fighter A")
assert_eq(Gora:GetSanctioned().fighterB, fightB.id, "Init Restores fighter B")
local victor, victorErr = Gora:DeclareVictor(fightA.id)
assert_true(victor ~= nil, "DeclareVictor after Pope reload does not refuse no sanctioned gora")
assert_eq(victorErr, nil, "DeclareVictor after Pope reload has no error")
assert_eq(victor.ruling, "victor", "DeclareVictor after Pope reload records the ruling")

--------------------------------------------------------------------------------
-- Pew Save / no-Sender Save leave present event + gora blobs.
--------------------------------------------------------------------------------
resetGoraDesk()
stubWriterPope(true)
Runtime:StartEvent()
local pewA, pewB = twoPersistChars()
Gora:Sanction(pewA.id, pewB.id)
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, gora = {} }
assert_true(DB:Save(), "Pope Save seeds the shared blobs")
local popeEvent = ChurchOfBeefDB.event
local popeGora = ChurchOfBeefDB.gora
assert_eq(eventField(popeEvent, "state"), "ASSEMBLY", "seeded event is ASSEMBLY")
assert_eq(goraField(popeGora, "eventId"), 1, "seeded gora has eventId")

resetGoraDesk()
ChurchOfBeefDB = {
  version = 7,
  ui = {},
  store = ChurchOfBeefDB.store,
  event = popeEvent,
  gora = popeGora,
}
eventOrder = {}
DB:Init()
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "pew Init still Restores leftover event")
assert_eq(Gora:GetSanctioned().fighterA, pewA.id, "pew Init still Restores leftover gora")
assert_eq(Runtime:DropToQuietForVersion(), true, "pew Quiet drop lands")
assert_eq(Runtime:Snapshot().state, "QUIET", "pew login is QUIET")
assert_eq(Gora:GetSanctioned(), nil, "Quiet drop expires the restored desk")
local eventRef = ChurchOfBeefDB.event
local goraRef = ChurchOfBeefDB.gora
stubWriterPope(false)
assert_true(DB:Save(), "pew Save still returns true")
assert_true(ChurchOfBeefDB.event == eventRef, "pew Save does not replace db.event")
assert_true(ChurchOfBeefDB.gora == goraRef, "pew Save does not assign empty gora")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), "ASSEMBLY", "pew Save does not snapshot Quiet over event")
assert_eq(goraField(ChurchOfBeefDB.gora, "eventId"), 1, "pew Save leaves the Pope gora blob")
assert_eq((ChurchOfBeefDB.gora.sanctioned or {}).fighterA, pewA.id, "pew Save leaves the sanctioned pair")

local pewStore = ChurchOfBeefDB.store
ChurchOfBeef.Sender = nil
resetGoraDesk()
ChurchOfBeefDB = {
  version = 7,
  ui = { shown = true },
  store = pewStore,
  event = popeEvent,
  gora = popeGora,
}
assert_true(DB:Save(), "isolated Save with no Sender still returns true")
assert_eq(eventField(ChurchOfBeefDB.event, "state"), "ASSEMBLY", "no-Sender Save does not wipe event")
assert_eq(goraField(ChurchOfBeefDB.gora, "eventId"), 1, "no-Sender Save does not wipe gora")
assert_eq(ChurchOfBeefDB.ui.shown, true, "no-Sender Save still persists ui")

resetGoraDesk()
ChurchOfBeefDB = {
  version = 7,
  ui = {},
  store = pewStore,
  event = popeEvent,
  gora = popeGora,
}
stubWriterPope(true)
DB:Init()
assert_eq(Gora:GetSanctioned().fighterA, pewA.id, "Pope reload after pew Save still has the pair")
assert_eq(Gora:DeclareVictor(pewA.id).ruling, "victor", "Pope reload after pew Save can still rule")

Gora.Restore = realGoraRestore
Runtime.Restore = realEventRestoreForOrder
stubWriterPope(true)

do
  local srcFile = io.open("addon/ChurchOfBeef/ChurchOfBeef.lua", "r")
  assert_true(srcFile ~= nil, "ChurchOfBeef.lua is readable for the persist wrap pin")
  local src = srcFile:read("*a")
  srcFile:close()
  assert_eq(src:find('persistWrites(COB.Gora', 1, true) ~= nil, true, "InstallWire persist-wraps Gora writes")
  assert_eq(src:find('ResetForTests', src:find('persistWrites(COB.Gora', 1, true) or 1, true), nil,
    "persistWrites lists do not include ResetForTests")
  assert_eq(src:find('wrapAfter(COB.Gora, "ResetForTests"', 1, true), nil, "ResetForTests is not wrapAfter'd")
  assert_eq(src:find('wrapAfter(COB.Gora, "_Expire"', 1, true), nil, "_Expire is not wrapAfter'd")
end

--------------------------------------------------------------------------------
-- Persist decree: Common + Decree + DB. Snapshot is { line, flavor } or {}.
--------------------------------------------------------------------------------
local savedStoreForDecree = ChurchOfBeef.Store
local savedRuntimeForDecree = ChurchOfBeef.Runtime
ChurchOfBeef.Store = nil
ChurchOfBeef.Runtime = nil
dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local Decree = ChurchOfBeef.Decree
assert_eq(type(Decree), "table", "decree persist section has Decree")
assert_eq(type(Decree.Snapshot), "function", "Decree.Snapshot exists")
assert_eq(type(Decree.Restore), "function", "Decree.Restore exists")
assert_eq(ChurchOfBeef.Store, nil, "decree persist section does not keep Store")
assert_eq(ChurchOfBeef.Runtime, nil, "decree persist section does not keep Runtime")

local function resetDecree()
  assert_eq(Decree:ResetForTests(), true, "Decree ResetForTests runs under _IN_TEST")
end

local decreeRestoreCalls = 0
local realDecreeRestore = Decree.Restore
function Decree:Restore(...)
  decreeRestoreCalls = decreeRestoreCalls + 1
  return realDecreeRestore(self, ...)
end

--------------------------------------------------------------------------------
-- Init with Decree still leaves the empty hook. Save writes a Snapshot.
--------------------------------------------------------------------------------
resetDecree()
decreeRestoreCalls = 0
ChurchOfBeefDB = nil
DB:Init()
assert_eq(decreeRestoreCalls, 0, "fresh Init does not Restore the empty decree hook")
assert_eq(ChurchOfBeefDB.version, 8, "fresh Init with Decree stays schema 8")
assert_eq(type(ChurchOfBeefDB.decree), "table", "fresh Init with Decree still has decree")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Init does not Snapshot the decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "line"), nil, "Init does not invent decree line")
assert_eq(decreeField(ChurchOfBeefDB.decree, "header"), nil, "Init does not invent the banner header")
assert_eq(rootKeys(ChurchOfBeefDB), "decree,event,gora,nights,store,ui,version", "Decree Init root is { version, ui, store, event, gora, decree }")

assert_true(DB:Save(), "Save with Decree succeeds")
assert_eq(type(ChurchOfBeefDB.decree), "table", "Save writes a decree table")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "Save of an unset Decree is {}")
assert_eq(decreeField(ChurchOfBeefDB.decree, "line"), nil, "unset Save does not invent line")
assert_eq(decreeField(ChurchOfBeefDB.decree, "title"), nil, "Save does not invent a title")
assert_eq(decreeField(ChurchOfBeefDB.decree, "deputy"), nil, "Save does not invent a deputy")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "Decree Save without Store does not invent store rows")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Decree Save without Runtime does not invent an event snapshot")

--------------------------------------------------------------------------------
-- Empty {} / missing / non-string line must not Restore (live Decree stays)
--------------------------------------------------------------------------------
resetDecree()
local posted = Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "Bring a friend." })
assert_eq(posted.line, "Goldshire Inn — Sunday, 7:00 PM", "Set posts the live Decree")
decreeRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, decree = {} }
DB:Init()
assert_eq(decreeRestoreCalls, 0, "empty decree hook does not call Restore")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "empty hook does not wipe live Decree")
assert_eq(Decree:Get().flavor, "Bring a friend.", "empty hook keeps live flavor")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "empty decree hook stays {}")

resetDecree()
posted = Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
decreeRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {} }
DB:Init()
assert_eq(decreeRestoreCalls, 0, "missing decree (filled to {}) does not Restore")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "missing decree does not wipe live")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "missing decree becomes {}")

resetDecree()
posted = Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
decreeRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, decree = { future = true } }
DB:Init()
assert_eq(decreeRestoreCalls, 0, "decree without line is not a Decree snapshot")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "stateless decree does not wipe live")
assert_eq(decreeField(ChurchOfBeefDB.decree, "future"), true, "unknown decree key survives Init")

resetDecree()
posted = Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
decreeRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, decree = { line = 1 } }
DB:Init()
assert_eq(decreeRestoreCalls, 0, "non-string line is not a Decree snapshot")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "typed-wrong line does not wipe live")

resetDecree()
posted = Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
decreeRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, decree = { line = true } }
DB:Init()
assert_eq(decreeRestoreCalls, 0, "boolean line is not a Decree snapshot")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "boolean line does not wipe live")

resetDecree()
posted = Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
decreeRestoreCalls = 0
ChurchOfBeefDB = { version = 7, ui = {}, store = {}, event = {}, decree = { line = "" } }
DB:Init()
assert_eq(decreeRestoreCalls, 1, "empty-string line still calls Restore")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "empty-string Restore does not wipe live")

--------------------------------------------------------------------------------
-- Snapshot-shaped decree Restores. Round-trip survives Reset.
--------------------------------------------------------------------------------
resetDecree()
Decree:Set({
  line = "Shattrath — Friday, 8:00 PM",
  flavor = "The Gathering.",
  title = "A GATHERING HAS BEEN DECREED",
  deputy = "Steve",
})
ChurchOfBeefDB = {
  version = 7,
  ui = { shown = true, announce = false },
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
assert_true(DB:Save(), "Save persists a live Decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "line"), "Shattrath — Friday, 8:00 PM", "filled Save Snapshots the line")
assert_eq(decreeField(ChurchOfBeefDB.decree, "flavor"), "The Gathering.", "filled Save keeps flavor")
assert_eq(decreeField(ChurchOfBeefDB.decree, "title"), nil, "filled Save does not store a title")
assert_eq(decreeField(ChurchOfBeefDB.decree, "header"), nil, "filled Save does not store the banner header")
assert_eq(decreeField(ChurchOfBeefDB.decree, "deputy"), nil, "filled Save does not store a deputy")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "decree Save does not wipe leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "decree Save does not wipe leftover scoring")
assert_eq(ChurchOfBeefDB.suggestions.leftover, true, "decree Save does not wipe leftover suggestions")
assert_eq(decreeField(ChurchOfBeefDB.decree, "ladder"), nil, "filled Save does not copy ladder into decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "scoring"), nil, "filled Save does not copy scoring into decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "suggestions"), nil, "filled Save does not copy suggestions into decree")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "decree Save does not invent store rows")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "decree Save does not invent an event snapshot")
assert_eq(ChurchOfBeefDB.ui.shown, true, "decree Save still keeps ui")
assert_eq(ChurchOfBeefDB.version, 8, "filled decree Save stays schema 8")

local savedDecree = ChurchOfBeefDB.decree
resetDecree()
assert_eq(Decree:Get(), nil, "reset cleared live Decree before Restore")
decreeRestoreCalls = 0
ChurchOfBeefDB = {
  version = 7,
  ui = { shown = true, announce = false },
  decree = savedDecree,
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
DB:Init()
assert_eq(decreeRestoreCalls, 1, "Snapshot-shaped decree Restores once")
local resumed = Decree:Get()
assert_eq(resumed.line, "Shattrath — Friday, 8:00 PM", "Init Restores the line")
assert_eq(resumed.flavor, "The Gathering.", "Init Restores the flavor")
assert_eq(resumed.title, nil, "Init does not Restore a title")
assert_eq(resumed.deputy, nil, "Init does not Restore a deputy")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "decree Init does not wipe leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "decree Init does not wipe leftover scoring")
assert_eq(ChurchOfBeefDB.suggestions.leftover, true, "decree Init does not wipe leftover suggestions")
assert_eq(decreeField(ChurchOfBeefDB.decree, "ladder"), nil, "decree Init does not copy leftovers into decree")
assert_eq(ChurchOfBeefDB.version, 8, "Init after decree Snapshot stays schema 8")

--------------------------------------------------------------------------------
-- Leftovers + empty decree hook: still no Restore, still no import
--------------------------------------------------------------------------------
resetDecree()
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
decreeRestoreCalls = 0
ChurchOfBeefDB = {
  version = 1,
  ui = { announce = true, shown = false },
  decree = {},
  ladder = leftovers(),
  scoring = { granted = { dayKey = "2026-01-01" } },
  suggestions = { leftover = true },
}
DB:Init()
assert_eq(decreeRestoreCalls, 0, "leftovers plus empty decree hook do not Restore")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "leftover decree Init does not wipe live")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "leftover ladder survives decree Init")
assert_eq(decreeKeys(ChurchOfBeefDB.decree), "", "leftovers are not imported on decree Init")
assert_eq(decreeField(ChurchOfBeefDB.decree, "ladder"), nil, "ladder stays at the SV root during decree Init")
assert_eq(ChurchOfBeefDB.version, 8, "old leftover table with decree hook stamps schema 8")

assert_true(DB:Save(), "Save with leftovers and Decree succeeds")
assert_eq(ChurchOfBeefDB.ladder.records[1], "Alice", "Save with Decree keeps leftover ladder")
assert_eq(ChurchOfBeefDB.scoring.granted.dayKey, "2026-01-01", "Save with Decree keeps leftover scoring")
assert_eq(decreeField(ChurchOfBeefDB.decree, "ladder"), nil, "Save with Decree does not copy leftovers into decree")
assert_eq(decreeField(ChurchOfBeefDB.decree, "line"), "Goldshire Inn — Sunday, 7:00 PM", "Save with leftovers still writes the live Decree")
assert_eq(storeKeys(ChurchOfBeefDB.store), "", "Save with Decree does not invent store rows")
assert_eq(eventKeys(ChurchOfBeefDB.event), "", "Save with Decree does not invent an event snapshot")

--------------------------------------------------------------------------------
-- No Grant / calendar / deputy / Pope-list APIs on DB after Decree persist.
--------------------------------------------------------------------------------
assert_eq(DB.Grant, nil, "DB still has no Grant")
assert_eq(DB.SetDecree, nil, "DB has no SetDecree")
assert_eq(DB.Post, nil, "DB has no Post")
assert_eq(DB.IsRegisteredPope, nil, "DB does not check IsRegisteredPope")
assert_eq(DB.Calendar, nil, "DB has no calendar")
assert_eq(DB.RSVP, nil, "DB has no RSVP")

Decree.Restore = realDecreeRestore
ChurchOfBeef.Store = savedStoreForDecree
ChurchOfBeef.Runtime = savedRuntimeForDecree
if type(ChurchOfBeef.Runtime) == "table" and type(ChurchOfBeef.Runtime.ResetForTests) == "function" then
  ChurchOfBeef.Runtime:ResetForTests()
end
ChurchOfBeefDB = { version = 7, ui = { streamerMode = true } }
DB:Init()
assert_eq(ChurchOfBeefDB.ui.welcomeSeen, false, "missing welcomeSeen fills false after event persist")
assert_eq(ChurchOfBeefDB.ui.streamerMode, true, "streamerMode pin stays after event persist")
assert_eq(ChurchOfBeefDB.version, 8, "welcomeSeen fill after event persist stays schema 8")
-- Do not leave Runtime on the global: Knighting:_Expire wipes the line when
-- Runtime is loaded and QUIET (test_knighting is isolated from Runtime).
ChurchOfBeef.Runtime = nil

--------------------------------------------------------------------------------
-- Leftover decree.line is not wiped on Init (Law 7). Nights import is
-- isolated in test_nights so this suite does not leak a board into later UI.
--------------------------------------------------------------------------------
local savedNights = ChurchOfBeef.Nights
ChurchOfBeef.Nights = nil
ChurchOfBeefDB = {
  version = 7,
  ui = {},
  store = {},
  event = {},
  decree = { line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "Bring a friend." },
  nights = {},
}
DB:Init()
assert_eq(ChurchOfBeefDB.decree.line, "Goldshire Inn — Sunday, 7:00 PM",
  "leftover decree line survives schema 8 Init")
assert_eq(ChurchOfBeefDB.decree.flavor, "Bring a friend.",
  "leftover decree flavor survives schema 8 Init")
ChurchOfBeef.Nights = savedNights
if type(savedNights) == "table" and type(savedNights.ResetForTests) == "function" then
  savedNights:ResetForTests()
end

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
