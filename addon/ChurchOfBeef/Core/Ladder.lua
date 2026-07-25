ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Official ladder state: one record per member, plus the pending suggestion queue.
-- Records are only ever changed by an officer commit (local or replicated); standing
-- is advisory testimony that a member's own client accumulates.
local Ladder = {
  records = {},
  suggestions = {},
}
COB.Ladder = Ladder

local kindCache = {}

-- Rank ids come from canon rather than literals so a canon reorder cannot desync
-- the seat and uniqueness rules from the titles they police.
local function rankIdByKind(kind)
  if kindCache[kind] then return kindCache[kind] end
  local ranks = COB.Ranks
  if not ranks then return nil end
  for _, rank in ipairs(ranks.List) do
    if rank.kind == kind then
      kindCache[kind] = rank.id
      return rank.id
    end
  end
  return nil
end

local function normalizeName(name)
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" then return nil end
  return name
end

local function isValidRankId(rankId)
  local ranks = COB.Ranks
  return type(rankId) == "number" and ranks ~= nil and ranks.ById[rankId] ~= nil
end

local function isValidStanding(standing)
  return type(standing) == "number" and standing >= 0
end

local function resolveTime(now)
  if type(now) == "number" then return now end
  if type(time) == "function" then return time() end
  return 0
end

-- PLAYER_LOGOUT is a last flush, not the only one: a client crash between commits
-- would otherwise lose officer decisions the guild has already seen announced.
-- Commits are rare enough that flushing on each one costs nothing.
local function persist()
  if COB.DB and COB.DB.Save then COB.DB:Save() end
end

local function newRecord(name)
  return {
    name = name,
    rankId = 1,
    standing = 0,
    revision = 0,
    updatedAt = 0,
    updatedBy = "",
  }
end

local function copyRecord(record)
  return {
    name = record.name,
    rankId = record.rankId,
    standing = record.standing,
    revision = record.revision,
    updatedAt = record.updatedAt,
    updatedBy = record.updatedBy,
  }
end

local function copySuggestion(suggestion)
  return {
    name = suggestion.name,
    fromRankId = suggestion.fromRankId,
    toRankId = suggestion.toRankId,
    standing = suggestion.standing,
    threshold = suggestion.threshold,
    createdAt = suggestion.createdAt,
  }
end

function Ladder:_ensure(name)
  local record = self.records[name]
  if not record then
    record = newRecord(name)
    self.records[name] = record
  end
  return record
end

-- Returns an error string when the target rank is a limited seat that is already taken.
-- The holder themselves is excluded, so re-committing a sitting member (a standing
-- correction, say) never looks like a new claim on their own seat.
function Ladder:_seatError(name, rankId)
  local ranks = COB.Ranks
  local councilId = rankIdByKind("council")
  local prophetId = rankIdByKind("prophet")

  if rankId == councilId and type(ranks.CouncilSeats) == "number" then
    local taken = 0
    for holder, record in pairs(self.records) do
      if record.rankId == councilId and holder ~= name then taken = taken + 1 end
    end
    if taken >= ranks.CouncilSeats then
      return "the Beef Council is full (" .. ranks.CouncilSeats .. " seats)"
    end
  elseif rankId == prophetId and ranks.ProphetUnique then
    for holder, record in pairs(self.records) do
      if record.rankId == prophetId and holder ~= name then
        return "a Beef Prophet already lives: " .. holder
      end
    end
  end

  return nil
end

function Ladder:GetRecord(name)
  local key = normalizeName(name)
  if not key then return nil end
  local record = self.records[key]
  -- Unknown members read as Fresh Beef without being written into the ladder,
  -- so a UI lookup can never conjure an occupant.
  if not record then return newRecord(key) end
  return copyRecord(record)
end

-- True only for a name the ladder has actually written. GetRecord answers Fresh Beef
-- for strangers, so a caller deciding whether someone exists must ask here instead:
-- a typo in an officer's rite box must not conjure a ladder occupant.
function Ladder:HasOfficialRecord(name)
  local key = normalizeName(name)
  if not key then return false end
  return self.records[key] ~= nil
end

-- Local advisory standing. Deliberately does not bump the revision: points are
-- self-reported testimony, and only an officer commit creates official state.
function Ladder:SetStanding(name, standing)
  local key = normalizeName(name)
  if not key then return nil, "invalid name" end
  if type(standing) ~= "number" then return nil, "standing must be a number" end
  if standing < 0 then standing = 0 end

  local record = self:_ensure(key)
  record.standing = standing
  return copyRecord(record)
end

-- Returns suggestion, isNew. Only ever suggests the single next point-driven rank,
-- so Council and Prophet stay appointed/bestowed and cannot be reached by grinding.
function Ladder:MaybeSuggest(name)
  local key = normalizeName(name)
  if not key then return nil end
  local record = self.records[key]
  if not record then return nil end

  local ranks = COB.Ranks
  if ranks.IsPointDriven(record.rankId) ~= true then return nil end

  local nextId = record.rankId + 1
  if ranks.IsPointDriven(nextId) ~= true then return nil end

  local threshold = ranks.Threshold(nextId)
  if type(threshold) ~= "number" or record.standing < threshold then return nil end

  local pending = self.suggestions[key]
  if pending and pending.toRankId == nextId then
    -- Keep the queued suggestion showing what the member has actually earned so far
    -- rather than their standing at the moment they first crossed the line.
    pending.standing = record.standing
    return copySuggestion(pending), false
  end

  local suggestion = {
    name = key,
    fromRankId = record.rankId,
    toRankId = nextId,
    standing = record.standing,
    threshold = threshold,
    createdAt = resolveTime(nil),
  }
  self.suggestions[key] = suggestion
  return copySuggestion(suggestion), true
end

function Ladder:GetSuggestions()
  local out = {}
  for _, suggestion in pairs(self.suggestions) do
    out[#out + 1] = copySuggestion(suggestion)
  end
  table.sort(out, function(a, b) return a.name < b.name end)
  return out
end

function Ladder:RejectSuggestion(name)
  local key = normalizeName(name)
  if not key then return false end
  if not self.suggestions[key] then return false end
  -- Standing survives a rejection; officers correct points separately.
  self.suggestions[key] = nil
  persist()
  return true
end

-- The single write path for official state. Appointments and demotions route through
-- here so seat limits, validation and revision bumping cannot be bypassed.
-- A nil standing leaves the member's existing standing alone.
function Ladder:Commit(name, rankId, standing, officerName, now)
  local key = normalizeName(name)
  if not key then return nil, "invalid name" end
  if not isValidRankId(rankId) then return nil, "invalid rank id" end

  local officer = normalizeName(officerName)
  if not officer then return nil, "invalid officer name" end
  if standing ~= nil and not isValidStanding(standing) then
    return nil, "standing must be a non-negative number"
  end

  local seatError = self:_seatError(key, rankId)
  if seatError then return nil, seatError end

  local record = self:_ensure(key)
  record.rankId = rankId
  if standing ~= nil then record.standing = standing end
  record.revision = record.revision + 1
  record.updatedAt = resolveTime(now)
  record.updatedBy = officer
  self.suggestions[key] = nil

  -- Demote/AppointCouncil/BestowProphet route through here, so this is the one
  -- flush point for every local officer decision.
  persist()
  return copyRecord(record)
end

function Ladder:Demote(name, rankId, officerName, now)
  local key = normalizeName(name)
  if not key then return nil, "invalid name" end
  if not isValidRankId(rankId) then return nil, "invalid rank id" end

  local record = self.records[key]
  local currentRankId = record and record.rankId or 1
  if rankId >= currentRankId then
    return nil, "a demotion must target a lower rank"
  end

  return self:Commit(key, rankId, nil, officerName, now)
end

function Ladder:AppointCouncil(name, officerName, now)
  local councilId = rankIdByKind("council")
  if not councilId then return nil, "no council rank in canon" end
  return self:Commit(name, councilId, nil, officerName, now)
end

function Ladder:BestowProphet(name, officerName, now)
  local prophetId = rankIdByKind("prophet")
  if not prophetId then return nil, "no prophet rank in canon" end
  return self:Commit(name, prophetId, nil, officerName, now)
end

-- Higher revision wins; ties break on timestamp, then officer name, so every client
-- converges on the same record no matter what order commits arrive in.
local function beatsLocal(revision, updatedAt, updatedBy, localRecord)
  if revision ~= localRecord.revision then return revision > localRecord.revision end
  if updatedAt ~= localRecord.updatedAt then return updatedAt > localRecord.updatedAt end
  return updatedBy > (localRecord.updatedBy or "")
end

-- Seat and uniqueness limits are deliberately not re-checked here. A replicated commit
-- is already-decided history; rejecting it would leave clients permanently disagreeing.
function Ladder:ApplyRemoteCommit(record)
  if type(record) ~= "table" then return false end

  local key = normalizeName(record.name)
  if not key then return false end
  if not isValidRankId(record.rankId) then return false end
  if not isValidStanding(record.standing) then return false end
  if type(record.revision) ~= "number" or record.revision < 1 then return false end

  local updatedAt = type(record.updatedAt) == "number" and record.updatedAt or 0
  local updatedBy = normalizeName(record.updatedBy) or ""

  local localRecord = self.records[key]
  if localRecord and not beatsLocal(record.revision, updatedAt, updatedBy, localRecord) then
    return false
  end

  local target = self:_ensure(key)
  target.rankId = record.rankId
  target.standing = record.standing
  target.revision = record.revision
  target.updatedAt = updatedAt
  target.updatedBy = updatedBy
  self.suggestions[key] = nil

  persist()
  return true
end

function Ladder:GetLadderView()
  local out = {}
  for _, record in pairs(self.records) do
    out[#out + 1] = copyRecord(record)
  end
  table.sort(out, function(a, b)
    if a.rankId ~= b.rankId then return a.rankId > b.rankId end
    return a.name < b.name
  end)
  return out
end

-- Name-sorted so a SavedVariables write is stable between sessions.
function Ladder:ExportState()
  local out = {}
  for _, record in pairs(self.records) do
    out[#out + 1] = copyRecord(record)
  end
  table.sort(out, function(a, b) return a.name < b.name end)
  return out
end

-- Replaces the record store; malformed entries are dropped rather than poisoning
-- the ladder. Returns how many records were accepted. Suggestions are left alone:
-- restore those separately via ImportSuggestions from SavedVariables.
function Ladder:ImportState(records)
  -- A non-table argument is a caller bug, not an instruction to erase the ladder.
  if type(records) ~= "table" then return 0 end
  self.records = {}

  local accepted = 0
  for _, record in pairs(records) do
    if type(record) == "table" then
      local key = normalizeName(record.name)
      if key and isValidRankId(record.rankId) then
        local restored = newRecord(key)
        restored.rankId = record.rankId
        if isValidStanding(record.standing) then restored.standing = record.standing end
        if type(record.revision) == "number" and record.revision > 0 then
          restored.revision = record.revision
        end
        if type(record.updatedAt) == "number" then restored.updatedAt = record.updatedAt end
        restored.updatedBy = normalizeName(record.updatedBy) or ""
        self.records[key] = restored
        accepted = accepted + 1
      end
    end
  end

  return accepted
end

-- Pending suggestions are local testimony of crossed thresholds; persist them so a
-- /reload does not re-queue someone an officer already rejected (standing remains).
function Ladder:ImportSuggestions(suggestions)
  if type(suggestions) ~= "table" then return 0 end
  self.suggestions = {}

  local accepted = 0
  for _, suggestion in pairs(suggestions) do
    if type(suggestion) == "table" then
      local key = normalizeName(suggestion.name)
      if key and isValidRankId(suggestion.fromRankId) and isValidRankId(suggestion.toRankId) then
        self.suggestions[key] = {
          name = key,
          fromRankId = suggestion.fromRankId,
          toRankId = suggestion.toRankId,
          standing = isValidStanding(suggestion.standing) and suggestion.standing or 0,
          threshold = type(suggestion.threshold) == "number" and suggestion.threshold or 0,
          createdAt = type(suggestion.createdAt) == "number" and suggestion.createdAt or 0,
        }
        accepted = accepted + 1
      end
    end
  end

  return accepted
end

-- Test-only. Gated so a stray call in game cannot erase a guild's ladder.
function Ladder:ResetForTests()
  if not COB._IN_TEST then return false end
  self.records = {}
  self.suggestions = {}
  return true
end
