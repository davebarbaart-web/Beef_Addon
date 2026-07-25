ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Per-character SavedVariables cache. Not a server: officer commits + BeefNet
-- revisions are authoritative; this file only survives /reload and logout.
-- Nest ui separately from ladder/scoring so future cosmetic profiles never own
-- church data (research track 21).
local DB = {}
COB.DB = DB

local SCHEMA_VERSION = 1

local function defaultUi()
  return { point = nil, shown = false, announce = true }
end

local function defaultLadder()
  return { records = {}, suggestions = {} }
end

local function defaultScoring()
  return { dayKey = "", granted = {} }
end

local function defaultDb()
  return {
    version = SCHEMA_VERSION,
    ui = defaultUi(),
    ladder = defaultLadder(),
    scoring = defaultScoring(),
  }
end

local function ensureTable(parent, key, factory)
  if type(parent[key]) ~= "table" then
    parent[key] = factory()
  end
  return parent[key]
end

-- Fill missing known keys only. Never delete unknown future fields.
local function applyDefaults(db)
  local version = db.version
  if type(version) ~= "number" then version = 0 end

  -- Ordered migrations land here: if version < 2 then …; version = 2; end
  if version < SCHEMA_VERSION then
    db.version = SCHEMA_VERSION
  end
  -- Downgrade (db.version > SCHEMA_VERSION): keep the higher stamp and unknown keys.

  local ui = ensureTable(db, "ui", defaultUi)
  if ui.shown == nil then ui.shown = false end
  if ui.announce == nil then ui.announce = true end
  -- ui.point may be nil (unset position).

  local ladder = ensureTable(db, "ladder", defaultLadder)
  if type(ladder.records) ~= "table" then ladder.records = {} end
  if type(ladder.suggestions) ~= "table" then ladder.suggestions = {} end

  local scoring = ensureTable(db, "scoring", defaultScoring)
  if type(scoring.dayKey) ~= "string" then scoring.dayKey = "" end
  if type(scoring.granted) ~= "table" then scoring.granted = {} end
end

local function loadIntoModules(db, now)
  if COB.Ladder then
    COB.Ladder:ImportState(db.ladder.records)
    COB.Ladder:ImportSuggestions(db.ladder.suggestions)
  end
  if COB.Scoring and COB.Scoring.ImportState then
    -- Optional now keeps desktop tests off the harness epoch-0 clock.
    COB.Scoring:ImportState(db.scoring, now)
  end
end

-- Call only from ADDON_LOADED for ChurchOfBeef — SV is not ready at file load.
-- Optional now is forwarded to Scoring:ImportState (injectable clock for tests).
function DB:Init(now)
  if type(ChurchOfBeefDB) ~= "table" then
    ChurchOfBeefDB = defaultDb()
  else
    applyDefaults(ChurchOfBeefDB)
  end
  loadIntoModules(ChurchOfBeefDB, now)
  return ChurchOfBeefDB
end

-- Flush live Core state into the SV table. UI writes ChurchOfBeefDB.ui in place;
-- this only refreshes ladder + scoring caches. Client persists on logout.
function DB:Save()
  local db = ChurchOfBeefDB
  if type(db) ~= "table" then return false end
  applyDefaults(db)

  if COB.Ladder then
    db.ladder.records = COB.Ladder:ExportState()
    db.ladder.suggestions = COB.Ladder:GetSuggestions()
  end
  if COB.Scoring and COB.Scoring.ExportState then
    db.scoring = COB.Scoring:ExportState()
  end
  return true
end
