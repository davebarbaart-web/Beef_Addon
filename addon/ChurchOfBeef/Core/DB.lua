ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- SavedVariables cache. Schema 8 is { version, ui, store, event, gora, decree, nights }.
-- Store persist: Save writes Store:Snapshot() (a table, not an Archive stamp).
-- Init Restores store only when it looks like a Snapshot (humans + characters).
-- Event persist: Save writes Runtime:Snapshot() when Runtime exists and the
-- local writer is a registered Pope. Init Restores event only when state is
-- a string. Empty {} / missing does not Restore. Gora persist: Save writes
-- Gora:Snapshot() when Gora exists and the local writer is a registered Pope.
-- Init Restores gora only when eventId is a number. Empty {} / missing does
-- not Restore. Restore order is store → event → gora → decree (gora after
-- event so _Expire does not see QUIET and wipe the pair).
-- Decree persist: leftover decree.line is imported into Nights once (Law 7).
-- Nights persist: Save writes Nights:Snapshot() when Nights exists.
-- Init Restores nights when series or stubs or boardRevision is present.
-- Init does not look up the local character. ADDON_LOADED is too early
-- for a role split — pew Quiet drop is PLAYER_LOGIN on the bootstrap.
-- Ceremony Save (event + gora) is Pope-only.
local DB = {}
COB.DB = DB

local SCHEMA_VERSION = 8

local function defaultUi()
  return { point = nil, shown = false, announce = true, welcomeSeen = false }
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

local function defaultNights()
  return {}
end

local function defaultGora()
  return {}
end

local function defaultDb()
  return {
    version = SCHEMA_VERSION,
    ui = defaultUi(),
    store = defaultStore(),
    event = defaultEvent(),
    gora = defaultGora(),
    decree = defaultDecree(),
    nights = defaultNights(),
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
  if ui.welcomeSeen == nil then ui.welcomeSeen = false end
  -- ui.point may be nil (unset position).

  ensureTable(db, "store", defaultStore)
  ensureTable(db, "event", defaultEvent)
  ensureTable(db, "gora", defaultGora)
  ensureTable(db, "decree", defaultDecree)
  ensureTable(db, "nights", defaultNights)
end

-- Ceremony persist (event + gora) is Pope-only. Isolated Core tests with
-- no Sender are not Pope — leave a present blob untouched. Missing name
-- is not Pope (Group.PlayerName is the login name; Init never calls this).
local function localWriterIsPope()
  local sender = COB.Sender
  if type(sender) ~= "table" or type(sender.IsRegisteredPope) ~= "function" then
    return false
  end
  local name
  if COB.Group and type(COB.Group.PlayerName) == "function" then
    name = COB.Group.PlayerName()
  end
  return sender:IsRegisteredPope(name) == true
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
-- This Init does not look up the local character. ADDON_LOADED is too early
-- for a role split — the pew Quiet drop is PLAYER_LOGIN on the bootstrap.
local function restoreEventFromSv(db)
  local runtime = runtimeModule()
  if not runtime or type(runtime.Restore) ~= "function" then return end
  if not isEventSnapshot(db.event) then return end
  runtime:Restore(db.event)
end

-- Persist the in-memory event object. Never copy leftover root keys into event.
-- Caller must be the Pope writer; congregation leaves db.event untouched.
local function snapshotEventToSv(db)
  local runtime = runtimeModule()
  if not runtime or type(runtime.Snapshot) ~= "function" then return end
  db.event = runtime:Snapshot()
end

-- Gora snapshot gate: eventId is a number. {} / missing is not a snapshot.
local function isGoraSnapshot(gora)
  return type(gora) == "table" and type(gora.eventId) == "number"
end

local function goraModule()
  local gora = COB.Gora
  if type(gora) ~= "table" then return nil end
  return gora
end

-- Restore only a Gora snapshot. Empty {} / missing must not replace live.
-- Init does not look up the local character. Call after event Restore.
local function restoreGoraFromSv(db)
  local gora = goraModule()
  if not gora or type(gora.Restore) ~= "function" then return end
  if not isGoraSnapshot(db.gora) then return end
  gora:Restore(db.gora)
end

-- Persist the in-memory Gora desk. Never copy leftover root keys into gora.
-- Caller must be the Pope writer; congregation leaves db.gora untouched.
local function snapshotGoraToSv(db)
  local gora = goraModule()
  if not gora or type(gora.Snapshot) ~= "function" then return end
  db.gora = gora:Snapshot()
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

local function isNightsSnapshot(nights)
  return type(nights) == "table"
    and (type(nights.series) == "table"
      or type(nights.stubs) == "table"
      or type(nights.boardRevision) == "number")
end

local function nightsModule()
  local nights = COB.Nights
  if type(nights) ~= "table" then return nil end
  return nights
end

local function restoreNightsFromSv(db)
  local nights = nightsModule()
  if not nights then return end
  if type(nights.Restore) == "function" and isNightsSnapshot(db.nights) then
    nights:Restore(db.nights)
  end
  if type(nights.ImportDecree) == "function" and isDecreeSnapshot(db.decree) then
    nights:ImportDecree(db.decree.line, db.decree.flavor)
  end
end

local function snapshotNightsToSv(db)
  local nights = nightsModule()
  if not nights or type(nights.Snapshot) ~= "function" then return end
  db.nights = nights:Snapshot()
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
  restoreGoraFromSv(ChurchOfBeefDB)
  restoreDecreeFromSv(ChurchOfBeefDB)
  restoreNightsFromSv(ChurchOfBeefDB)
  return ChurchOfBeefDB
end

-- UI writes ChurchOfBeefDB.ui in place. No leftover-key import into store/event/gora/decree.
-- Ceremony blobs (event + gora) write only when localWriterIsPope(). Pew
-- OnLogout / Save may still persist store / ui / decree; a present event or
-- gora snapshot is left untouched. Tests that stub Sender as Pope write both.
function DB:Save()
  local db = ChurchOfBeefDB
  if type(db) ~= "table" then return false end
  applyDefaults(db)
  snapshotToSv(db)
  if localWriterIsPope() then
    snapshotEventToSv(db)
    snapshotGoraToSv(db)
  end
  snapshotDecreeToSv(db)
  snapshotNightsToSv(db)
  return true
end
