ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- SavedVariables cache. Schema 7 is { version, ui, store, event, decree }.
-- Store persist: Save writes Store:Snapshot() (a table, not an Archive stamp).
-- Init Restores store only when it looks like a Snapshot (humans + characters).
-- Event persist: Save writes Runtime:Snapshot() when Runtime exists. Init
-- Restores event only when state is a string. Empty {} / missing does not
-- Restore. Decree persist: Save writes Decree:Snapshot() when Decree exists.
-- Init Restores decree only when line is a string. Empty {} / missing does
-- not Restore. Leftover demo keys stay at the SV root (Law 7).
local DB = {}
COB.DB = DB

local SCHEMA_VERSION = 7

local function defaultUi()
  return { point = nil, shown = false, announce = true }
end

local function defaultStore()
  return {}
end

local function defaultEvent()
  return {}
end

local function defaultDecree()
  return {}
end

local function defaultDb()
  return {
    version = SCHEMA_VERSION,
    ui = defaultUi(),
    store = defaultStore(),
    event = defaultEvent(),
    decree = defaultDecree(),
  }
end

local function ensureTable(parent, key, factory)
  if type(parent[key]) ~= "table" then
    parent[key] = factory()
  end
  return parent[key]
end

-- Fill missing known keys only. Never delete unknown future fields, and never
-- require or import leftover ladder / scoring / suggestions.
local function applyDefaults(db)
  local version = db.version
  if type(version) ~= "number" then version = 0 end
  if version < SCHEMA_VERSION then
    version = SCHEMA_VERSION
  end
  db.version = version
  -- Downgrade (db.version > SCHEMA_VERSION): keep the higher stamp and unknown keys.

  local ui = ensureTable(db, "ui", defaultUi)
  if ui.shown == nil then ui.shown = false end
  if ui.announce == nil then ui.announce = true end
  -- ui.point may be nil (unset position).

  ensureTable(db, "store", defaultStore)
  ensureTable(db, "event", defaultEvent)
  ensureTable(db, "decree", defaultDecree)
end

-- Snapshot shape is Store's table (humans + characters). {} is the Lane D hook.
local function isSnapshot(store)
  return type(store) == "table"
    and type(store.humans) == "table"
    and type(store.characters) == "table"
end

local function storeModule()
  local store = COB.Store
  if type(store) ~= "table" then return nil end
  return store
end

-- Runtime snapshot gate: state is a string. {} / missing is not a snapshot.
local function isEventSnapshot(event)
  return type(event) == "table" and type(event.state) == "string"
end

local function runtimeModule()
  local runtime = COB.Runtime
  if type(runtime) ~= "table" then return nil end
  return runtime
end

-- Restore only a Snapshot-shaped table. Empty {} must not replace live memory.
local function restoreFromSv(db)
  local store = storeModule()
  if not store or type(store.Restore) ~= "function" then return end
  if not isSnapshot(db.store) then return end
  store:Restore(db.store)
end

-- Persist the in-memory Pope store. Never copy leftover root keys into store.
local function snapshotToSv(db)
  local store = storeModule()
  if not store or type(store.Snapshot) ~= "function" then return end
  db.store = store:Snapshot()
end

-- Restore only a Runtime snapshot. Empty {} / missing must not replace live event.
local function restoreEventFromSv(db)
  local runtime = runtimeModule()
  if not runtime or type(runtime.Restore) ~= "function" then return end
  if not isEventSnapshot(db.event) then return end
  runtime:Restore(db.event)
end

-- Persist the in-memory event object. Never copy leftover root keys into event.
local function snapshotEventToSv(db)
  local runtime = runtimeModule()
  if not runtime or type(runtime.Snapshot) ~= "function" then return end
  db.event = runtime:Snapshot()
end

-- Decree snapshot gate: line is a string. {} / missing is not a snapshot.
local function isDecreeSnapshot(decree)
  return type(decree) == "table" and type(decree.line) == "string"
end

local function decreeModule()
  local decree = COB.Decree
  if type(decree) ~= "table" then return nil end
  return decree
end

-- Restore only a Decree snapshot. Empty {} / missing must not replace live.
local function restoreDecreeFromSv(db)
  local decree = decreeModule()
  if not decree or type(decree.Restore) ~= "function" then return end
  if not isDecreeSnapshot(db.decree) then return end
  decree:Restore(db.decree)
end

-- Persist the in-memory Decree. Never copy leftover root keys into decree.
local function snapshotDecreeToSv(db)
  local decree = decreeModule()
  if not decree or type(decree.Snapshot) ~= "function" then return end
  db.decree = decree:Snapshot()
end

-- Call only from ADDON_LOADED for ChurchOfBeef — SV is not ready at file load.
function DB:Init(_now)
  if type(ChurchOfBeefDB) ~= "table" then
    ChurchOfBeefDB = defaultDb()
  else
    applyDefaults(ChurchOfBeefDB)
  end
  restoreFromSv(ChurchOfBeefDB)
  restoreEventFromSv(ChurchOfBeefDB)
  restoreDecreeFromSv(ChurchOfBeefDB)
  return ChurchOfBeefDB
end

-- UI writes ChurchOfBeefDB.ui in place. No leftover-key import into store/event/decree.
function DB:Save()
  local db = ChurchOfBeefDB
  if type(db) ~= "table" then return false end
  applyDefaults(db)
  snapshotToSv(db)
  snapshotEventToSv(db)
  snapshotDecreeToSv(db)
  return true
end
