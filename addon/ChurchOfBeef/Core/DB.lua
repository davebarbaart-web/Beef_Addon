ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Per-character SavedVariables cache. Standing + suggestions are local testimony;
-- Church titles come from the live guild roster (Core/Roster), not this file.
-- Nest ui separately from ladder/scoring so future cosmetic profiles never own
-- church data (research track 21).
local DB = {}
COB.DB = DB

-- v2: roster-backed ranks — ladder.records keep standing only.
-- v3: advisory rite flags (knighted / goraLordWin) on standing rows.
local SCHEMA_VERSION = 3

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

  -- Ordered migrations: strip legacy official rank fields from standing rows.
  if version < 2 then
    local ladder = db.ladder
    if type(ladder) == "table" and type(ladder.records) == "table" then
      local cleaned = {}
      for _, record in pairs(ladder.records) do
        if type(record) == "table" and type(record.name) == "string" then
          local standing = record.standing
          if type(standing) ~= "number" or standing < 0 then standing = 0 end
          cleaned[#cleaned + 1] = {
            name = record.name,
            standing = standing,
            rankId = 1,
            revision = 0,
            updatedAt = 0,
            updatedBy = "",
          }
        end
      end
      ladder.records = cleaned
    end
    version = 2
  end
  -- v3: rite flags are additive on standing rows; ImportState reads them when present.
  if version < 3 then
    version = 3
  end
  if version < SCHEMA_VERSION then
    version = SCHEMA_VERSION
  end
  db.version = version
  -- Downgrade (db.version > SCHEMA_VERSION): keep the higher stamp and unknown keys.

  local ui = ensureTable(db, "ui", defaultUi)
  if ui.shown == nil then ui.shown = false end
  if ui.announce == nil then ui.announce = true end
  -- ui.point may be nil (unset position). Announce checkbox is retained in SV for a
  -- future roster-diff announcer; Officer UI hides it until then.

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
