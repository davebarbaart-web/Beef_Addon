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

-- Net reports outcomes to the private toast and asks the open window to redraw; it
-- never builds a frame or writes a widget itself.
local function refreshUI()
  if not COB.UI then return end
  if COB.UI.RefreshLadder then COB.UI:RefreshLadder() end
end

-- Prefer Celebrate/Push so kind priority + dedupe apply; fall back to Show for
-- harness mocks that only stub Show.
local function toastCelebrate(kind, fields, fallbackText)
  if COB.Toasts and COB.Toasts.Celebrate then
    return COB.Toasts:Celebrate(kind, fields)
  end
  if COB.Toasts and COB.Toasts.Show and fallbackText then
    return COB.Toasts:Show(fallbackText)
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
-- An absent standing is encoded as an empty field, which every receiver reads as
-- "rank only, keep your own standing".
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

  -- Empty standing field: a rank-only rite. Nil travels through to Core, which
  -- then leaves the member's advisory standing alone. A present-but-nonsense
  -- standing is still a refusal — silence and garbage are different claims.
  local standing = nil
  if trim(tostring(fields[3] == nil and "" or fields[3])) ~= nil then
    standing = finite(fields[3])
    if not standing or standing < 0 then return nil, "invalid standing" end
  end

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
  -- Prefer the roster-backed snapshot; Officer cache is kept in sync by Roster:Refresh.
  if COB.Roster and COB.Roster.IsReady and COB.Roster:IsReady() then return true end
  if not (COB.Officer and COB.Officer.HasRosterCache) then return false end
  return COB.Officer:HasRosterCache() and true or false
end

-- force=true bypasses our client throttle. Blizzard still ignores calls <10s apart;
-- we must not block login retries ourselves (that was stranding the ladder empty).
function Net:RequestRoster(nowSeconds, force)
  local t = now(self, nowSeconds)
  if not force and self.rosterRequestedAt and (t - self.rosterRequestedAt) < ROSTER_REQUEST_INTERVAL then
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
--
-- includeStanding must be asked for. Elevations, demotions and appointments are
-- rank-only rites, and shipping the officer's copy of an advisory point total with
-- them would overwrite the standing the member actually earned. Only a deliberate
-- standing correction sets the flag.
function Net:SendRankCommit(record, includeStanding)
  if type(record) ~= "table" then return false, "no record" end
  local standing = includeStanding and record.standing or nil
  local parsed = self:ParseRecord({ record.name, record.rankId, standing,
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

-- The local client just crossed a threshold. One place decides what that means on
-- the wire and on screen, so Core only has to say "this happened" and stays free of
-- both SendAddonMessage and the UI.
function Net:OnLocalSuggestion(suggestion)
  if type(suggestion) ~= "table" then return false, "no suggestion" end

  local title = COB.Ranks and COB.Ranks.Title(suggestion.toRankId) or nil
  if title then
    -- COB_TOAST_SUGGEST: eligible for guild-UI promote — not a promotion itself.
    local name = suggestion.name or ""
    local rankId = suggestion.toRankId or 0
    toastCelebrate("suggest", {
      title = title,
      dedupeKey = "suggest-self:" .. name .. ":" .. tostring(rankId),
    }, string.format("Eligible for %s \226\128\148 officers can promote you in the guild roster.", title))
  end

  -- Best effort: a guildless or Net-less client still queued the petition locally,
  -- and the officer will see it at the next login sync or the next grant.
  local sent = self:SendSuggestion(suggestion) and true or false
  return sent
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

function Net:_WarnVersion(version)
  if self.warnedVersion then return false end
  self.warnedVersion = true
  chat(string.format(
    "a guildmate is running BeefNet v%s; this client speaks v%d. Update for matching addon messages.",
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

function Net:HandleRankCommit(_message, _sender)
  -- Roster-backed ladder amendment: Church titles come from the live guild roster.
  -- Legacy RANK_COMMIT payloads are soft-ignored so mixed-version guilds do not fork.
  return false, "rank commits ignored (roster-backed ladder)"
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

-- A member's petition. Never a promotion and never an official record: it lands in
-- the local pending queue so the officer tab has something to approve, and Core
-- re-derives the target rank from our own ladder rather than trusting the wire.
--
-- Members drop these on the floor: only the client that can act on a petition has
-- any reason to keep one.
function Net:HandleSuggestion(message, sender)
  if not self:IsCompatible(message.version) then return false, "protocol mismatch" end
  local name = trim(message.fields[1])
  local toRankId = finite(message.fields[3])
  if not name or not toRankId then return false, "malformed suggestion" end
  if not (COB.Officer and COB.Officer:LocalIsOfficer()) then return false, "not an officer" end
  if not (COB.Ladder and COB.Ladder.ImportSuggestion) then return false, "ladder unavailable" end

  local suggestion, err = COB.Ladder:ImportSuggestion({
    name = name,
    toRankId = toRankId,
    standing = finite(message.fields[4]),
  })
  if not suggestion then return false, err end

  local title = COB.Ranks and COB.Ranks.Title(suggestion.toRankId) or "?"
  toastCelebrate("suggest", {
    name = suggestion.name,
    title = title,
    dedupeKey = "suggest:" .. suggestion.name .. ":" .. tostring(suggestion.toRankId),
  }, string.format("Promote %s to %s in the guild roster.", suggestion.name, title))
  refreshUI()
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
  local ready = false
  if COB.Roster and COB.Roster.Refresh then
    ready = COB.Roster:Refresh() and true or false
  elseif COB.Officer and COB.Officer.RefreshRosterCache then
    ready = COB.Officer:RefreshRosterCache() and true or false
  end
  -- Empty login race: ask again (force). Blizzard may ignore within 10s; later
  -- events / scheduled retries pick it up — same pattern as LibGuildRoster.
  if not ready then
    self:RequestRoster(nil, true)
  end
  -- Legacy held RANK_COMMITs are drained as no-ops (HandleRankCommit ignores them).
  local applied = self:ReleaseHeld()
  if COB.Sync and COB.Sync.ReleaseHeldStates then COB.Sync:ReleaseHeldStates() end
  refreshUI()
  return applied
end

-- Classic often answers the first GuildRoster() with an empty snapshot. Blizzard
-- also ignores requests <10s apart, so we retry past that window until ready.
function Net:_ScheduleRosterRetries()
  if type(C_Timer) ~= "table" or type(C_Timer.After) ~= "function" then return end
  local delays = { 0.5, 2, 5, 10.5, 21 }
  for i = 1, #delays do
    local delay = delays[i]
    C_Timer.After(delay, function()
      if COB.Roster and COB.Roster.IsReady and COB.Roster:IsReady() then return end
      if COB.Roster and COB.Roster.Refresh then COB.Roster:Refresh() end
      if COB.Roster and COB.Roster.IsReady and COB.Roster:IsReady() then
        refreshUI()
        return
      end
      Net:RequestRoster(nil, true)
    end)
  end
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

  -- Prefer any already-cached roster before kicking a server query.
  if COB.Roster then
    if COB.Roster.AttachLibrary then COB.Roster:AttachLibrary() end
    if COB.Roster.SetOnChanged then
      COB.Roster:SetOnChanged(function() refreshUI() end)
    end
    if COB.Roster.Refresh then COB.Roster:Refresh() end
  end
  self:RequestRoster(nil, true)
  self:_ScheduleRosterRetries()
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
