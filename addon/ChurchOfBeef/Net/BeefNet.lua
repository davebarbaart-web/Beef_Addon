ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- BeefNet: the wire, and nothing more. It parses a payload, proves the sender is an
-- Officer+ against the guild roster, and then hands the record to Core. It never
-- decides a rank itself: every accepted commit goes through Ladder:ApplyRemoteCommit,
-- which owns the revision merge.
--
-- Classic+ port notes: the client APIs read here are behind type() guards and listed
-- below, so a host that renames one degrades to "cannot send" instead of erroring on
-- an incoming message.
--   C_ChatInfo, SendAddonMessage, RegisterAddonMessagePrefix, C_GuildInfo, GuildRoster,
--   IsInGuild, UnitName, C_Timer, GetTime, CreateFrame
local Net = {
  -- Major protocol number. A mismatch is a soft warning plus a discard: an older
  -- client's field order is not something we can guess our way through.
  PROTOCOL = 1,
  Prefix = "COB",
  -- GUILD always. The client default is PARTY, and custom CHANNEL addon chat is
  -- forbidden on Classic, so this is passed explicitly on every send.
  Channel = "GUILD",
  -- ChatThrottleLib-class pacing without the library: the client drops a prefix at
  -- roughly ten messages regenerating one per second, and a login sync is the one
  -- moment we would otherwise blow straight through that.
  SendInterval = 0.5,
  MaxQueued = 60,
  -- Commits that arrived before the roster did. Bounded: a flood while the roster
  -- is unread must not grow without limit.
  MaxHeld = 24,
  queue = {},
  held = {},
  sentCount = 0,
}
COB.Net = Net

local FIELD = ":"
-- SendAddonMessage bodies cap at 255; leave room for the prefix framing.
local MAX_BODY = 240
-- The client ignores a GuildRoster() request made less than ten seconds after the last.
local ROSTER_REQUEST_INTERVAL = 10

local TYPES = {
  HELLO = true,
  SUGGESTION = true,
  RANK_COMMIT = true,
  SYNC_REQUEST = true,
  SYNC_STATE = true,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function trim(text)
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

-- Rejects NaN and infinity as well as non-numbers: tonumber("nan") succeeds on some
-- hosts, and a NaN revision would compare false against everything forever.
local function finite(value)
  local n = tonumber(value)
  if type(n) ~= "number" then return nil end
  if n ~= n then return nil end
  if n == math.huge or n == -math.huge then return nil end
  return n
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

local function chat(text)
  if type(DEFAULT_CHAT_FRAME) == "table" and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: " .. text)
  end
end

-- Injectable clock so the outbound throttle is provable offline. GetTime is the
-- monotonic client clock; a system-time change must not open the throttle gate.
local function now(self, given)
  if type(given) == "number" then return given end
  if type(self.clock) == "function" then
    local t = self.clock()
    if type(t) == "number" then return t end
  end
  if type(GetTime) == "function" then
    local t = GetTime()
    if type(t) == "number" then return t end
  end
  return 0
end

--------------------------------------------------------------------------------
-- Serialization: VERSION:TYPE:fields...
--------------------------------------------------------------------------------

function Net:Encode(msgType, ...)
  local parts = { tostring(self.PROTOCOL), msgType }
  for i = 1, select("#", ...) do
    local value = select(i, ...)
    parts[#parts + 1] = value == nil and "" or tostring(value)
  end
  return table.concat(parts, FIELD)
end

function Net:Decode(payload)
  if type(payload) ~= "string" or payload == "" then return nil, "empty payload" end
  local parts = split(payload, FIELD)
  local version = finite(parts[1])
  if not version then return nil, "no protocol version" end
  local msgType = trim(parts[2])
  if not msgType then return nil, "no message type" end

  local fields = {}
  for i = 3, #parts do fields[i - 2] = parts[i] end
  return { version = version, type = msgType, fields = fields }
end

function Net:IsCompatible(version)
  return finite(version) == self.PROTOCOL
end

--------------------------------------------------------------------------------
-- Record shape (shared with Sync)
--------------------------------------------------------------------------------

-- Order is load-bearing: name, rankId, standing, revision, updatedAt, updatedBy.
function Net:EncodeRecordFields(record)
  return record.name, record.rankId, record.standing, record.revision,
    record.updatedAt or 0, record.updatedBy or ""
end

-- Shape validation only — authority is the caller's job. Rank ids come from canon,
-- so a canon reorder cannot leave a stale 1-7 literal here.
function Net:ParseRecord(fields)
  if type(fields) ~= "table" then return nil, "no record fields" end

  local name = trim(fields[1])
  if not name then return nil, "missing name" end

  local rankId = finite(fields[2])
  local ranks = COB.Ranks
  if not rankId or not ranks or not ranks.ById[rankId] then return nil, "invalid rank id" end

  local standing = finite(fields[3])
  if not standing or standing < 0 then return nil, "invalid standing" end

  local revision = finite(fields[4])
  if not revision or revision < 1 then return nil, "invalid revision" end

  return {
    name = name,
    rankId = rankId,
    standing = standing,
    revision = revision,
    updatedAt = finite(fields[5]) or 0,
    updatedBy = trim(fields[6]) or "",
  }
end

--------------------------------------------------------------------------------
-- Identity and roster
--------------------------------------------------------------------------------

local function nameKey(name)
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", ""):lower()
  if name == "" then return nil end
  return name:match("^([^%-]+)") or name
end

function Net:PlayerName()
  if type(UnitName) ~= "function" then return nil end
  local name = UnitName("player")
  return trim(name)
end

-- Our own guild-channel traffic comes back to us. Commits from self are harmless
-- (equal revision loses the merge) but a sync request answered by its own sender
-- would be pure noise.
function Net:IsSelf(sender)
  local me = nameKey(self:PlayerName())
  if not me then return false end
  return nameKey(sender) == me
end

function Net:RosterLookup()
  if type(self.rosterLookup) == "function" then return self.rosterLookup end
  if COB.Officer and COB.Officer.GetRosterLookup then return COB.Officer:GetRosterLookup() end
  return nil
end

-- An injected lookup (tests, and any future non-guild source) is always considered
-- ready; the live path is only ready once a roster snapshot exists.
function Net:RosterReady()
  if type(self.rosterLookup) == "function" then return true end
  if not (COB.Officer and COB.Officer.HasRosterCache) then return false end
  return COB.Officer:HasRosterCache() and true or false
end

function Net:RequestRoster(nowSeconds)
  local t = now(self, nowSeconds)
  if self.rosterRequestedAt and (t - self.rosterRequestedAt) < ROSTER_REQUEST_INTERVAL then
    return false
  end
  self.rosterRequestedAt = t

  if type(C_GuildInfo) == "table" and type(C_GuildInfo.GuildRoster) == "function" then
    C_GuildInfo.GuildRoster()
    return true
  end
  if type(GuildRoster) == "function" then
    GuildRoster()
    return true
  end
  return false
end

--------------------------------------------------------------------------------
-- Outbound: one message per SendInterval
--------------------------------------------------------------------------------

function Net:CanSend()
  if type(IsInGuild) ~= "function" then return false end
  return IsInGuild() and true or false
end

function Net:_Transmit(payload)
  self.sentCount = self.sentCount + 1
  self.lastSent = payload

  if type(self.transmit) == "function" then
    self.transmit(payload, self.Channel)
    return true
  end
  if type(C_ChatInfo) == "table" and type(C_ChatInfo.SendAddonMessage) == "function" then
    C_ChatInfo.SendAddonMessage(self.Prefix, payload, self.Channel)
    return true
  end
  if type(SendAddonMessage) == "function" then
    SendAddonMessage(self.Prefix, payload, self.Channel)
    return true
  end
  return false
end

function Net:_Arm(delay)
  if self.armed then return false end
  if type(C_Timer) ~= "table" or type(C_Timer.After) ~= "function" then return false end
  self.armed = true
  C_Timer.After(delay, function()
    Net.armed = false
    Net:Pump()
  end)
  return true
end

-- Sends at most one queued message, then arms a timer for whatever is left.
-- Returns how many went out, so the throttle can be counted without a client.
function Net:Pump(nowSeconds)
  if #self.queue == 0 then return 0 end
  local t = now(self, nowSeconds)

  if self.lastSentAt then
    local waited = t - self.lastSentAt
    if waited < self.SendInterval then
      self:_Arm(self.SendInterval - waited)
      return 0
    end
  end

  local payload = table.remove(self.queue, 1)
  self.lastSentAt = t
  self:_Transmit(payload)
  if #self.queue > 0 then self:_Arm(self.SendInterval) end
  return 1
end

function Net:Send(payload, nowSeconds)
  if type(payload) ~= "string" or payload == "" then return false, "empty payload" end
  if #payload > MAX_BODY then return false, "payload too large" end
  if not self:CanSend() then return false, "not in a guild" end
  -- Dropping the newest is right for a queue this size: the tail is sync chunks,
  -- and an unanswered sync retries on the next login rather than lying.
  if #self.queue >= self.MaxQueued then return false, "outbound queue full" end

  self.queue[#self.queue + 1] = payload
  self:Pump(nowSeconds)
  return true
end

function Net:SendHello()
  return self:Send(self:Encode("HELLO", COB.VERSION or "?"))
end

-- Called by the Officer tab after Ladder:Commit has already written official state.
-- The UI never forges a record here: it forwards what Core returned.
function Net:SendRankCommit(record)
  if type(record) ~= "table" then return false, "no record" end
  local parsed = self:ParseRecord({ record.name, record.rankId, record.standing,
    record.revision, record.updatedAt, record.updatedBy })
  if not parsed then return false, "record is not committable" end
  return self:Send(self:Encode("RANK_COMMIT", self:EncodeRecordFields(parsed)))
end

-- V1 keeps no shared suggestion store (spec §16 track 67): this is live fanout so a
-- watching officer hears about a petition, not a second queue to reconcile.
function Net:SendSuggestion(suggestion)
  if type(suggestion) ~= "table" then return false, "no suggestion" end
  local name = trim(suggestion.name)
  local toRankId = finite(suggestion.toRankId)
  if not name or not toRankId then return false, "suggestion is not sendable" end
  return self:Send(self:Encode("SUGGESTION", name, suggestion.fromRankId or 0, toRankId,
    suggestion.standing or 0, suggestion.threshold or 0))
end

function Net:SendSyncRequest(reqId)
  if not trim(reqId) then return false, "no request id" end
  return self:Send(self:Encode("SYNC_REQUEST", reqId))
end

function Net:SendSyncState(reqId, index, total, body)
  if not trim(reqId) then return false, "no request id" end
  return self:Send(self:Encode("SYNC_STATE", reqId, index, total, body))
end

--------------------------------------------------------------------------------
-- Inbound
--------------------------------------------------------------------------------

local function refreshUI()
  if not COB.UI then return end
  if COB.UI.RefreshLadder then COB.UI:RefreshLadder() end
end

local function toast(text)
  if COB.Toasts and COB.Toasts.Show then COB.Toasts:Show(text) end
end

function Net:_WarnVersion(version)
  if self.warnedVersion then return false end
  self.warnedVersion = true
  chat(string.format(
    "a guildmate is running BeefNet v%s; this client speaks v%d. Update to share ranks.",
    tostring(version), self.PROTOCOL))
  return true
end

-- Returns record, nil when the commit should be applied; nil, reason otherwise.
-- Pure: no state changes here, so every refusal is provable offline.
function Net:ValidateRankCommit(message, sender, rosterLookup)
  if type(message) ~= "table" then return nil, "no message" end
  if not self:IsCompatible(message.version) then return nil, "protocol mismatch" end
  if message.type ~= "RANK_COMMIT" then return nil, "not a rank commit" end
  if not trim(sender) then return nil, "no sender" end

  local record, err = self:ParseRecord(message.fields)
  if not record then return nil, err end

  -- The one authority check on the wire. A member's client claiming officer rights
  -- in its own UI means nothing here: the guild roster answers, or we refuse.
  if not (COB.Officer and COB.Officer:IsOfficerName(sender, rosterLookup)) then
    return nil, "sender is not an officer"
  end
  return record
end

function Net:_Hold(message, sender)
  if #self.held >= self.MaxHeld then return false end
  self.held[#self.held + 1] = { message = message, sender = sender }
  self:RequestRoster()
  return true
end

-- Applies the commits that arrived before the roster did. One batch, one Save.
function Net:ReleaseHeld()
  local held = self.held
  if #held == 0 then return 0 end
  if not self:RosterReady() then return 0 end

  self.held = {}
  local ladder = COB.Ladder
  if ladder and ladder.BeginBatch then ladder:BeginBatch() end

  local applied = 0
  for i = 1, #held do
    if self:HandleRankCommit(held[i].message, held[i].sender) then applied = applied + 1 end
  end

  if ladder and ladder.EndBatch then ladder:EndBatch() end
  return applied
end

function Net:HandleRankCommit(message, sender)
  -- Never apply unverified. An unread roster means hold and retry, not trust.
  if not self:RosterReady() then
    self:_Hold(message, sender)
    return false, "roster not loaded"
  end

  local record, err = self:ValidateRankCommit(message, sender, self:RosterLookup())
  if not record then return false, err end

  if not (COB.Ladder and COB.Ladder:ApplyRemoteCommit(record)) then
    -- A replay or an older revision. Silent: this is the normal cost of fanout.
    return false, "record did not beat the local copy"
  end

  local title = COB.Ranks and COB.Ranks.Title(record.rankId) or nil
  if title then toast(string.format("%s is now %s.", record.name, title)) end
  refreshUI()
  return true
end

function Net:HandleHello(message, sender)
  if not self:IsCompatible(message.version) then
    self:_WarnVersion(message.version)
    return false
  end
  self.peers = self.peers or {}
  local key = nameKey(sender)
  if key then self.peers[key] = message.fields[1] or "?" end
  return true
end

function Net:HandleSuggestion(message, sender)
  if not self:IsCompatible(message.version) then return false, "protocol mismatch" end
  local name = trim(message.fields[1])
  local toRankId = finite(message.fields[3])
  if not name or not toRankId then return false, "malformed suggestion" end
  -- Never a promotion, never a ladder write: officers still approve locally, and a
  -- non-officer hearing this has nothing to do with it.
  if not (COB.Officer and COB.Officer:LocalIsOfficer()) then return false, "not an officer" end

  local title = COB.Ranks and COB.Ranks.Title(toRankId) or "?"
  toast(string.format("%s petitions for %s.", name, title))
  return true
end

function Net:OnAddonMessage(prefix, payload, channel, sender)
  if prefix ~= self.Prefix then return false end
  -- Ladder state travels on GUILD only; anything else is not our protocol.
  if channel ~= self.Channel then return false end

  local message = self:Decode(payload)
  if not message then return false, "undecodable payload" end
  if not TYPES[message.type] then return false, "unknown message type" end
  if not self:IsCompatible(message.version) then
    self:_WarnVersion(message.version)
    return false, "protocol mismatch"
  end

  if message.type == "RANK_COMMIT" then
    return self:HandleRankCommit(message, sender)
  elseif message.type == "HELLO" then
    return self:HandleHello(message, sender)
  elseif message.type == "SUGGESTION" then
    return self:HandleSuggestion(message, sender)
  elseif message.type == "SYNC_REQUEST" then
    if not (COB.Sync and COB.Sync.OnSyncRequest) then return false end
    return COB.Sync:OnSyncRequest(message.fields[1], sender)
  elseif message.type == "SYNC_STATE" then
    if not (COB.Sync and COB.Sync.OnSyncState) then return false end
    return COB.Sync:OnSyncState(message.fields[1], message.fields[4], sender)
  end
  return false
end

function Net:OnRosterUpdate()
  if COB.Officer and COB.Officer.RefreshRosterCache then COB.Officer:RefreshRosterCache() end
  return self:ReleaseHeld()
end

--------------------------------------------------------------------------------
-- Lifecycle
--------------------------------------------------------------------------------

function Net:Init()
  if self.initialized then return false end
  self.initialized = true

  if type(C_ChatInfo) == "table" and type(C_ChatInfo.RegisterAddonMessagePrefix) == "function" then
    C_ChatInfo.RegisterAddonMessagePrefix(self.Prefix)
  elseif type(RegisterAddonMessagePrefix) == "function" then
    RegisterAddonMessagePrefix(self.Prefix)
  end

  if type(CreateFrame) == "function" then
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("CHAT_MSG_ADDON")
    frame:RegisterEvent("GUILD_ROSTER_UPDATE")
    frame:RegisterEvent("PLAYER_GUILD_UPDATE")
    frame:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
      if event == "CHAT_MSG_ADDON" then
        Net:OnAddonMessage(a1, a2, a3, a4)
      else
        Net:OnRosterUpdate()
      end
    end)
    self.frame = frame
  end

  self:RequestRoster()
  self:SendHello()
  return true
end

function Net:ResetForTests()
  if not COB._IN_TEST then return false end
  self.queue = {}
  self.held = {}
  self.peers = nil
  self.lastSentAt = nil
  self.lastSent = nil
  self.sentCount = 0
  self.armed = nil
  self.warnedVersion = nil
  self.rosterRequestedAt = nil
  self.rosterLookup = nil
  self.clock = nil
  self.transmit = nil
  self.initialized = nil
  return true
end
