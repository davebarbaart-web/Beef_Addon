ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Standing + promote-suggestion store. Church titles come from Core/Roster
-- (live guild rankIndex map). This module never invents official ranks.
local Ladder = {
  records = {}, -- name → { name, standing }
  suggestions = {},
}
COB.Ladder = Ladder

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

local batchDepth = 0
local batchDirty = false

local function save()
  if COB.DB and COB.DB.Save then COB.DB:Save() end
end

local function persist()
  if batchDepth > 0 then
    batchDirty = true
    return
  end
  save()
end

function Ladder:BeginBatch()
  batchDepth = batchDepth + 1
  return batchDepth
end

function Ladder:EndBatch()
  if batchDepth == 0 then return false end
  batchDepth = batchDepth - 1
  if batchDepth > 0 then return false end
  if not batchDirty then return false end
  batchDirty = false
  save()
  return true
end

local function mappedRankId(name)
  local roster = COB.Roster
  if roster and roster.IsReady and roster:IsReady() and roster.GetChurchRankId then
    return roster:GetChurchRankId(name)
  end
  return nil
end

local RITE_FLAGS = { knighted = true, goraLordWin = true }

local function newStanding(name)
  return { name = name, standing = 0, knighted = false, goraLordWin = false }
end

local function recordHasRite(record, flag)
  if not record or not RITE_FLAGS[flag] then return false end
  return record[flag] and true or false
end

local function enrichSuggestion(suggestion, record)
  local copy = {
    name = suggestion.name,
    fromRankId = suggestion.fromRankId,
    toRankId = suggestion.toRankId,
    standing = suggestion.standing,
    threshold = suggestion.threshold,
    createdAt = suggestion.createdAt,
    standingMet = true,
  }
  local ranks = COB.Ranks
  local riteKind = ranks and ranks.NeedsRite and ranks.NeedsRite(suggestion.toRankId) or nil
  copy.riteKind = riteKind
  if riteKind then
    copy.riteMet = recordHasRite(record, riteKind)
  else
    copy.riteMet = nil
  end
  return copy
end

local function copySuggestion(suggestion)
  local record = suggestion and suggestion.name and Ladder.records[suggestion.name] or nil
  return enrichSuggestion(suggestion, record)
end

-- Public shape kept for Standing/Officer tabs: rankId is roster-mapped when known,
-- else Fresh Beef for display only (does not write a ladder occupant).
function Ladder:GetRecord(name)
  local key = normalizeName(name)
  if not key then return nil end
  local record = self.records[key]
  local standing = record and record.standing or 0
  local rankId = mappedRankId(key) or 1
  return {
    name = key,
    rankId = rankId,
    standing = standing,
    knighted = recordHasRite(record, "knighted"),
    goraLordWin = recordHasRite(record, "goraLordWin"),
    revision = 0,
    updatedAt = 0,
    updatedBy = "",
  }
end

function Ladder:GetStanding(name)
  local key = normalizeName(name)
  if not key then return 0 end
  local record = self.records[key]
  return record and record.standing or 0
end

-- True when standing has been written for this name (ceremony, grant, correction).
function Ladder:HasOfficialRecord(name)
  local key = normalizeName(name)
  if not key then return false end
  return self.records[key] ~= nil
end

function Ladder:_ensure(name)
  local record = self.records[name]
  if not record then
    record = newStanding(name)
    self.records[name] = record
  end
  return record
end

function Ladder:SetStanding(name, standing)
  local key = normalizeName(name)
  if not key then return nil, "invalid name" end
  if type(standing) ~= "number" then return nil, "standing must be a number" end
  if standing < 0 then standing = 0 end

  local record = self:_ensure(key)
  record.standing = standing
  persist()
  return self:GetRecord(key)
end

-- Advisory rite flags for Officer eligibility checklists (never write Church titles).
function Ladder:HasRiteFlag(name, flag)
  local key = normalizeName(name)
  if not key or not RITE_FLAGS[flag] then return false end
  return recordHasRite(self.records[key], flag)
end

function Ladder:SetRiteFlag(name, flag, value)
  local key = normalizeName(name)
  if not key then return nil, "invalid name" end
  if not RITE_FLAGS[flag] then return nil, "unknown rite flag" end

  local record = self:_ensure(key)
  record[flag] = value and true or false

  local pending = self.suggestions[key]
  if pending then
    -- Refresh checklist fields on any open petition for this member.
    pending.standing = record.standing
  end
  persist()
  return self:GetRecord(key)
end

-- Suggest the next point-driven Church title above the member's *mapped* guild rank.
-- Does not enqueue until the roster knows the member (spec §9).
function Ladder:MaybeSuggest(name)
  local key = normalizeName(name)
  if not key then return nil end

  local fromRankId = mappedRankId(key)
  if not fromRankId then return nil end

  local ranks = COB.Ranks
  if not ranks then return nil end
  if ranks.IsPointDriven(fromRankId) ~= true then return nil end

  local nextId = fromRankId + 1
  if ranks.IsPointDriven(nextId) ~= true then return nil end

  local record = self.records[key]
  if not record then return nil end

  local threshold = ranks.Threshold(nextId)
  if type(threshold) ~= "number" or record.standing < threshold then return nil end

  local pending = self.suggestions[key]
  if pending and pending.toRankId == nextId then
    pending.standing = record.standing
    pending.fromRankId = fromRankId
    return copySuggestion(pending), false
  end

  local suggestion = {
    name = key,
    fromRankId = fromRankId,
    toRankId = nextId,
    standing = record.standing,
    threshold = threshold,
    createdAt = resolveTime(nil),
  }
  self.suggestions[key] = suggestion
  persist()
  return enrichSuggestion(suggestion, record), true
end

function Ladder:ImportSuggestion(suggestion)
  if type(suggestion) ~= "table" then return nil, "no suggestion" end
  local key = normalizeName(suggestion.name)
  if not key then return nil, "invalid name" end

  local ranks = COB.Ranks
  if not ranks then return nil, "no rank canon" end

  local fromRankId = mappedRankId(key)
  if not fromRankId then return nil, "roster does not know this member" end
  if ranks.IsPointDriven(fromRankId) ~= true then return nil, "rank is not point-driven" end

  local toRankId = fromRankId + 1
  if ranks.IsPointDriven(toRankId) ~= true then return nil, "next rank is not point-driven" end
  if suggestion.toRankId ~= nil and suggestion.toRankId ~= toRankId then
    return nil, "petition does not match the local record"
  end

  local threshold = ranks.Threshold(toRankId)
  local claimed = isValidStanding(suggestion.standing) and suggestion.standing or 0

  local pending = self.suggestions[key]
  if pending and pending.toRankId == toRankId then
    if claimed > (pending.standing or 0) then pending.standing = claimed end
    pending.fromRankId = fromRankId
    return copySuggestion(pending), false
  end

  self.suggestions[key] = {
    name = key,
    fromRankId = fromRankId,
    toRankId = toRankId,
    standing = claimed,
    threshold = type(threshold) == "number" and threshold or 0,
    createdAt = resolveTime(nil),
  }
  persist()
  return enrichSuggestion(self.suggestions[key], self.records[key]), true
end

function Ladder:GetSuggestions()
  local out = {}
  for _, suggestion in pairs(self.suggestions) do
    out[#out + 1] = copySuggestion(suggestion)
  end
  table.sort(out, function(a, b) return a.name < b.name end)
  return out
end

-- Dismiss a promote prompt. Alias kept as RejectSuggestion for existing call sites.
function Ladder:RejectSuggestion(name)
  local key = normalizeName(name)
  if not key then return false end
  if not self.suggestions[key] then return false end
  self.suggestions[key] = nil
  persist()
  return true
end

Ladder.DismissSuggestion = Ladder.RejectSuggestion

-- Standing correction path used by the Officer tab. Does not change Church title.
-- Crossing a threshold still only queues a promote suggestion (same boundary as Scoring).
function Ladder:CorrectStanding(name, standing, _officerName, _now)
  local record, err = self:SetStanding(name, standing)
  if not record then return nil, err end

  local suggestion, isNew = self:MaybeSuggest(name)
  if isNew and suggestion then
    local net = COB.Net
    if net and net.OnLocalSuggestion then net:OnLocalSuggestion(suggestion) end
  end

  return record
end

-- Retired product paths (roster-backed amendment). Kept as explicit refusals so
-- stale UI/tests fail closed instead of writing fake ranks into SV.
function Ladder:Commit(_name, _rankId, standing, _officerName, _now)
  if standing ~= nil then
    return nil, "use CorrectStanding for points; ranks come from the guild roster"
  end
  return nil, "ranks come from the guild roster — promote in the guild UI"
end

function Ladder:Demote()
  return nil, "ranks come from the guild roster — demote in the guild UI"
end

function Ladder:AppointCouncil()
  return nil, "ranks come from the guild roster — change guild ranks in the guild UI"
end

function Ladder:BestowProphet()
  return nil, "ranks come from the guild roster — change guild ranks in the guild UI"
end

-- Legacy BeefNet: ignored. Roster is the only rank authority.
function Ladder:ApplyRemoteCommit(_record)
  return false
end

function Ladder:GetLadderView()
  if COB.Roster and COB.Roster.GetLadderView then
    return COB.Roster:GetLadderView()
  end
  return {}
end

-- Persist standing only. Legacy rankId/revision fields are dropped on save.
function Ladder:ExportState()
  local out = {}
  for _, record in pairs(self.records) do
    out[#out + 1] = {
      name = record.name,
      standing = record.standing or 0,
      knighted = record.knighted and true or false,
      goraLordWin = record.goraLordWin and true or false,
      rankId = 1,
      revision = 0,
      updatedAt = 0,
      updatedBy = "",
    }
  end
  table.sort(out, function(a, b) return a.name < b.name end)
  return out
end

function Ladder:ImportState(records)
  if type(records) ~= "table" then return 0 end
  self.records = {}

  local accepted = 0
  for _, record in pairs(records) do
    if type(record) == "table" then
      local key = normalizeName(record.name)
      if key and isValidStanding(record.standing) then
        self.records[key] = {
          name = key,
          standing = record.standing,
          knighted = record.knighted and true or false,
          goraLordWin = record.goraLordWin and true or false,
        }
        accepted = accepted + 1
      elseif key and record.standing == nil then
        -- Legacy row with rank but no standing: keep a zero standing marker only if
        -- revision proves it was an official seat — still standing-only store.
        if type(record.revision) == "number" and record.revision > 0 then
          self.records[key] = newStanding(key)
          accepted = accepted + 1
        end
      end
    end
  end
  return accepted
end

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

function Ladder:ResetForTests()
  if not COB._IN_TEST then return false end
  self.records = {}
  self.suggestions = {}
  batchDepth = 0
  batchDirty = false
  return true
end
