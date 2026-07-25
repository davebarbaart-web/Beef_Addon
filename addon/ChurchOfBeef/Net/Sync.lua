ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Login reconciliation (spec §8.3). Live fanout only reaches players who were online
-- with the addon running; anyone offline during a promotion holds a stale ladder until
-- someone tells them. On login this client asks once, and peers answer once.
--
-- The whole design is about not shouting: one request after the login settles, a
-- jittered reply so peers do not answer in the same frame, and suppression so the
-- second peer through the gate stays quiet. Officers roll a shorter jitter because
-- their copy is the freshest in practice — they are the only source of commits.
local Sync = {
  -- Login is already the busiest moment on a client; ask after it has settled.
  RequestDelay = 6,
  -- Officers answer first, members only if no officer did.
  OfficerReplyDelay = { 1, 3 },
  MemberReplyDelay = { 4, 8 },
  -- Guard against a huge guild filling the outbound queue with sync chunks.
  MaxChunks = 12,
  answered = {},
  replying = {},
}
COB.Sync = Sync

local RECORD_SEP = ";"
local VALUE_SEP = ","
-- Body budget per SYNC_STATE, leaving room for the "1:SYNC_STATE:id:i:n:" header.
local CHUNK_BUDGET = 180

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function trim(text)
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function split(text, sep)
  local out, start = {}, 1
  while true do
    local from, to = text:find(sep, start, true)
    if not from then
      out[#out + 1] = text:sub(start)
      return out
    end
    out[#out + 1] = text:sub(start, from - 1)
    start = to + 1
  end
end

local function after(seconds, fn)
  if type(C_Timer) == "table" and type(C_Timer.After) == "function" then
    C_Timer.After(seconds, fn)
    return true
  end
  -- No timer host: answer immediately rather than never. Suppression still applies,
  -- so the worst case is a duplicate reply, not silence.
  fn()
  return false
end

-- Injectable so the reply race is deterministic in tests.
local function roll(self, low, high)
  local fn = type(self.rand) == "function" and self.rand or math.random
  local value = fn(low * 100, high * 100)
  if type(value) ~= "number" then return low end
  return value / 100
end

local function localIsOfficer()
  if not (COB.Officer and COB.Officer.LocalIsOfficer) then return false end
  return COB.Officer:LocalIsOfficer() and true or false
end

local function refreshUI()
  if COB.UI and COB.UI.RefreshLadder then COB.UI:RefreshLadder() end
end

--------------------------------------------------------------------------------
-- Wire format: name,rankId,standing,revision,updatedAt,updatedBy — records by ";"
--------------------------------------------------------------------------------

-- A name or officer name carrying a delimiter would corrupt every record after it,
-- so such a record is dropped rather than shipped. Character names cannot contain
-- these; a corrupted SavedVariables entry could.
local function encodeRecord(record)
  local fields = {
    record.name, record.rankId, record.standing, record.revision,
    record.updatedAt or 0, record.updatedBy or "",
  }
  local parts = {}
  for i = 1, 6 do
    local value = tostring(fields[i] == nil and "" or fields[i])
    if value:find("[,;:]") then return nil end
    parts[i] = value
  end
  return table.concat(parts, VALUE_SEP)
end

function Sync:DecodeRecords(body)
  local out = {}
  if type(body) ~= "string" or body == "" then return out end
  local net = COB.Net
  if not net then return out end

  local encoded = split(body, RECORD_SEP)
  for i = 1, #encoded do
    if encoded[i] ~= "" then
      -- Same shape gate as an inbound commit: a sync answer is not more trusted
      -- for arriving in bulk.
      local record = net:ParseRecord(split(encoded[i], VALUE_SEP))
      if record then out[#out + 1] = record end
    end
  end
  return out
end

function Sync:Chunks(records)
  local chunks, current, size = {}, {}, 0
  for i = 1, #records do
    local encoded = encodeRecord(records[i])
    if encoded then
      local cost = #encoded + (size > 0 and 1 or 0)
      if size > 0 and (size + cost) > CHUNK_BUDGET then
        chunks[#chunks + 1] = table.concat(current, RECORD_SEP)
        if #chunks >= self.MaxChunks then return chunks end
        current, size, cost = {}, 0, #encoded
      end
      current[#current + 1] = encoded
      size = size + cost
    end
  end
  if size > 0 then chunks[#chunks + 1] = table.concat(current, RECORD_SEP) end
  return chunks
end

--------------------------------------------------------------------------------
-- Requesting
--------------------------------------------------------------------------------

function Sync:NewRequestId()
  local name = COB.Net and COB.Net:PlayerName() or "?"
  local salt = math.floor(roll(self, 1000, 9999))
  -- Keeps the id free of the field delimiter no matter what the name looks like.
  return string.format("%s%d", tostring(salt), #tostring(name))
end

function Sync:OnLogin()
  if not COB.Net then return nil end

  local reqId = self:NewRequestId()
  self.pendingRequest = reqId
  self.answered = {}
  self.replying = {}

  after(self.RequestDelay, function()
    -- A /reload during the settle window supersedes this request.
    if Sync.pendingRequest ~= reqId then return end
    COB.Net:SendSyncRequest(reqId)
  end)
  return reqId
end

--------------------------------------------------------------------------------
-- Answering
--------------------------------------------------------------------------------

function Sync:OnSyncRequest(reqId, sender)
  reqId = trim(reqId)
  if not reqId then return false end
  if COB.Net and COB.Net:IsSelf(sender) then return false end
  if self.answered[reqId] or self.replying[reqId] then return false end

  -- An empty ladder has nothing to teach anyone; staying silent leaves the floor to
  -- a peer who does.
  local records = (COB.Ladder and COB.Ladder.ExportState) and COB.Ladder:ExportState() or {}
  if #records == 0 then return false end

  self.replying[reqId] = true
  local window = localIsOfficer() and self.OfficerReplyDelay or self.MemberReplyDelay
  after(roll(self, window[1], window[2]), function() Sync:Reply(reqId) end)
  return true
end

function Sync:Reply(reqId)
  reqId = trim(reqId)
  if not reqId then return false end
  self.replying[reqId] = nil
  -- Suppression: somebody answered while our jitter ran, so the requester is served.
  if self.answered[reqId] then return false end
  if not COB.Net then return false end

  local records = (COB.Ladder and COB.Ladder.ExportState) and COB.Ladder:ExportState() or {}
  local chunks = self:Chunks(records)
  if #chunks == 0 then return false end

  self.answered[reqId] = true
  for i = 1, #chunks do
    COB.Net:SendSyncState(reqId, i, #chunks, chunks[i])
  end
  return true
end

--------------------------------------------------------------------------------
-- Merging
--------------------------------------------------------------------------------

-- One BeginBatch/EndBatch around the whole arrival: a guild-sized answer would
-- otherwise export and rewrite the entire ladder once per record.
function Sync:MergeState(body)
  local ladder = COB.Ladder
  if not ladder then return 0 end

  local records = self:DecodeRecords(body)
  if #records == 0 then return 0 end

  if ladder.BeginBatch then ladder:BeginBatch() end
  local merged = 0
  for i = 1, #records do
    -- ApplyRemoteCommit owns the merge: higher revision wins, ties break on time
    -- then officer name. Sync does not get its own opinion about who is newer.
    if ladder:ApplyRemoteCommit(records[i]) then merged = merged + 1 end
  end
  if ladder.EndBatch then ladder:EndBatch() end

  if merged > 0 then refreshUI() end
  return merged
end

function Sync:OnSyncState(reqId, body, _sender)
  reqId = trim(reqId)
  if not reqId then return 0 end

  -- Suppression is global, not just for our own request: once a request has been
  -- answered in guild chat, nobody else needs to answer it.
  self.answered[reqId] = true
  self.replying[reqId] = nil

  if reqId ~= self.pendingRequest then return 0 end
  return self:MergeState(body)
end

function Sync:ResetForTests()
  if not COB._IN_TEST then return false end
  self.answered = {}
  self.replying = {}
  self.pendingRequest = nil
  self.rand = nil
  return true
end
