ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- BeefNet: the wire, and nothing more.
--
-- The transport vocabulary is HELLO: version/presence discovery (Bible §21.3 /
-- §13.4 version-skew). STATE (GUILD) and SNAPSHOT (WHISPER) are Codec types
-- routed when COB.Codec is loaded. They are not added to the HELLO TYPES set:
-- a body Codec will not decode stays unknown, so HELLO-only suites stay green.
-- Older builds may still broadcast SUGGESTION, RANK_COMMIT, SYNC_REQUEST, or
-- SYNC_STATE; those are named so they die quietly and are never acted on.
-- INPUT (favor, petition, confession) is live on whisper-to-Pope. A petition
-- may carry an opponent name. GUILD INPUT stays unknown. Outbound STATE /
-- SNAPSHOT / DECREE send only if the local player is a registered Pope
-- (gated on the listed Pope: Data/Popes.lua + ChurchOfBeefDB.ui.popeOverrides).
-- SendFavor, SendPetition, SendConfession, and RequestSnapshot are congregation
-- whisper and are not Pope-gated. A missing or blank whisper target resolves a
-- default destination before refusing: the last sender whose STATE passed
-- sender auth this session (Net._lastStateSender), then the first listed Pope
-- (COB.Popes.List, guarded). No roster lookup, no SavedVariables; a self dest
-- is legal and is not skipped.
--
-- Classic+ port notes: the client APIs read here are behind type() guards and listed
-- below, so a host that renames one degrades to "cannot send" instead of erroring on
-- an incoming message.
--   C_ChatInfo, SendAddonMessage, RegisterAddonMessagePrefix, C_GuildInfo, GuildRoster,
--   IsInGuild, UnitName, C_Timer, GetTime, CreateFrame
local Net = {
  -- Major protocol number. A mismatch is a once-per-session Quiet notice
  -- plus a drop to Quiet presentation: an older client's field order is
  -- not something we can guess our way through.
  PROTOCOL = 2,
  Prefix = "COB",
  -- GUILD always. The client default is PARTY, and custom CHANNEL addon chat is
  -- forbidden on Classic, so this is passed explicitly on every send.
  Channel = "GUILD",
  -- ChatThrottleLib-class pacing without the library, and shaped like the thing it
  -- is protecting: the client's addon-message allowance is a bucket of about ten
  -- that refills at one per second, so that is what we model. A login HELLO goes
  -- out at once; a client that keeps talking settles to one per second instead of
  -- the old fixed half-second gap, which sustained twice the refill rate and
  -- eventually got messages dropped by the server with no way for us to know.
  OutboundBurst = 10,
  OutboundPerSecond = 1,
  MaxQueued = 60,
  -- Inbound pacing, per sender. A peer may burst a few messages (a login HELLO
  -- plus a couple of retries) and then sustains one every five seconds. Everything
  -- past that is dropped unread: one client with a stuck loop, or a hostile one
  -- with /run, must not be able to spend every peer's decode budget.
  InboundBurst = 5,
  InboundPerSecond = 0.2,
  MaxInboundSenders = 200,
  queue = {},
  inbound = {},
  sentCount = 0,
}
COB.Net = Net

local FIELD = ":"
-- SendAddonMessage bodies cap at 255; leave room for the prefix framing.
local MAX_BODY = 240
-- The client ignores a GuildRoster() request made less than ten seconds after the last.
local ROSTER_REQUEST_INTERVAL = 10
local STUB_REBROADCAST_INTERVAL = 30

local TYPES = {
  HELLO = true,
}

-- Types an older build may still be broadcasting. Recognized so they are discarded
-- quietly instead of counted as garbage, and never acted on.
local RETIRED_TYPES = {
  RANK_COMMIT = true,
  SYNC_REQUEST = true,
  SYNC_STATE = true,
  SUGGESTION = true,
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

-- Whisper dest only. Names.Trim when Common is loaded; else the local trim.
-- Empty after trim is no target. Do not look up a Pope name.
local function destName(target)
  if COB.Names and type(COB.Names.Trim) == "function" then
    return COB.Names.Trim(target)
  end
  return trim(target)
end

-- Default whisper destination when the caller supplies none: the last sender
-- whose STATE passed sender auth this session, else the first listed Pope
-- (COB.Popes.List, guarded for absence). No guild-roster lookup, no
-- SavedVariables. A self dest is legal. destName trims whichever source wins.
local function defaultDest()
  local last = destName(Net._lastStateSender)
  if last then return last end
  local popes = COB.Popes
  local list = type(popes) == "table" and popes.List or nil
  if type(list) == "table" then
    return destName(list[1])
  end
  return nil
end

-- An explicit caller target always wins over the default.
local function resolveDest(target)
  return destName(target) or defaultDest()
end

-- Same helper SendPetition / RequestSnapshot use when the caller supplies
-- no dest. Inputs paints the recipient line from this so the face cannot
-- say List[1] while the whisper goes to _lastStateSender.
function Net:DefaultDest()
  return defaultDest()
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
-- Identity and roster
--------------------------------------------------------------------------------

local function nameKey(name)
  return COB.Names and COB.Names.Key(name) or nil
end

function Net:PlayerName()
  if type(UnitName) ~= "function" then return nil end
  local name = UnitName("player")
  return trim(name)
end

-- Our own guild-channel traffic comes back to us. Counting a self-HELLO as a peer
-- would make a lone user look like they had company.
function Net:IsSelf(sender)
  local me = nameKey(self:PlayerName())
  if not me then return false end
  return nameKey(sender) == me
end

-- force=true bypasses our client throttle. Blizzard still ignores calls <10s apart;
-- we must not block login retries ourselves (that was stranding the roster unread).
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

-- Whisper only. Target is the destination given to us (request sender, or an
-- explicit SendSnapshot target). Do not look up a Pope name.
function Net:_TransmitWhisper(payload, target)
  if type(payload) ~= "string" or payload == "" then return false, "empty payload" end
  if #payload > MAX_BODY then return false, "payload too large" end
  target = destName(target)
  if not target then return false, "no target" end

  self.sentCount = self.sentCount + 1
  self.lastSent = payload

  if type(self.transmit) == "function" then
    self.transmit(payload, "WHISPER", target)
    return true
  end
  if type(C_ChatInfo) == "table" and type(C_ChatInfo.SendAddonMessage) == "function" then
    C_ChatInfo.SendAddonMessage(self.Prefix, payload, "WHISPER", target)
    return true
  end
  if type(SendAddonMessage) == "function" then
    SendAddonMessage(self.Prefix, payload, "WHISPER", target)
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

-- Outbound allowance, refilled by the clock. Separate from Pump so a test (and a
-- future /beef debug line) can read the budget without spending it.
function Net:_Refill(t)
  local tokens = self.tokens
  if type(tokens) ~= "number" then tokens = self.OutboundBurst end
  local at = self.tokensAt or t
  local elapsed = t - at
  if elapsed > 0 then
    tokens = tokens + elapsed * self.OutboundPerSecond
    if tokens > self.OutboundBurst then tokens = self.OutboundBurst end
  end
  self.tokens = tokens
  self.tokensAt = t
  return tokens
end

-- Spends whatever allowance is available on the head of the queue, then arms a
-- timer for the next token. Returns how many went out, so pacing is countable
-- without a client.
function Net:Pump(nowSeconds)
  if #self.queue == 0 then return 0 end
  local t = now(self, nowSeconds)
  local tokens = self:_Refill(t)

  local sent = 0
  while #self.queue > 0 and tokens >= 1 do
    local payload = table.remove(self.queue, 1)
    tokens = tokens - 1
    self.tokens = tokens
    self.lastSentAt = t
    self:_Transmit(payload)
    sent = sent + 1
  end

  if #self.queue > 0 then
    self:_Arm((1 - tokens) / self.OutboundPerSecond)
  end
  return sent
end

function Net:Send(payload, nowSeconds)
  if type(payload) ~= "string" or payload == "" then return false, "empty payload" end
  if #payload > MAX_BODY then return false, "payload too large" end
  if not self:CanSend() then return false, "not in a guild" end
  -- Dropping the newest keeps the oldest HELLO in a stuck queue. A queue this
  -- deep already means something is wrong upstream.
  if #self.queue >= self.MaxQueued then return false, "outbound queue full" end

  self.queue[#self.queue + 1] = payload
  self:Pump(nowSeconds)
  return true
end

function Net:SendHello()
  return self:Send(self:Encode("HELLO", COB.VERSION or "?"))
end

-- Fail-closed until the registered-Pope list exists. Do not invent that list.
function Net:_LocalPope()
  if not (COB.Sender and COB.Sender.IsRegisteredPope) then
    return false
  end
  return COB.Sender:IsRegisteredPope(self:PlayerName()) and true or false
end

function Net:SendState(fields, nowSeconds)
  if not self:_LocalPope() then
    return false, "not a registered pope"
  end
  if not (COB.Codec and COB.Codec.EncodeState) then
    return false, "no codec"
  end
  local payload, err = COB.Codec:EncodeState(fields)
  if not payload then
    return false, err
  end
  return self:Send(payload, nowSeconds)
end

-- Pope-gated. destName before encode. Empty dest is no target and does
-- not EncodeSnapshot. Caller supplies the whisper dest. Do not look up
-- a Pope name.
function Net:SendSnapshot(fields, target)
  if not self:_LocalPope() then
    return false, "not a registered pope"
  end
  target = destName(target)
  if not target then
    return false, "no target"
  end
  if not (COB.Codec and COB.Codec.EncodeSnapshot) then
    return false, "no codec"
  end
  local payload, err = COB.Codec:EncodeSnapshot(fields)
  if not payload then
    return false, err
  end
  return self:_TransmitWhisper(payload, target)
end

function Net:SendDecree(fields, nowSeconds)
  if not self:_LocalPope() then
    return false, "not a registered pope"
  end
  if not (COB.Codec and COB.Codec.EncodeDecree) then
    return false, "no codec"
  end
  local payload, err = COB.Codec:EncodeDecree(fields)
  if not payload then
    return false, err
  end
  return self:Send(payload, nowSeconds)
end

function Net:SendNights(nowSeconds)
  if not self:_LocalPope() then
    return false, "not a registered pope"
  end
  if not (COB.Nights and COB.Nights.BroadcastSnapshot) then
    return false, "nights is not available"
  end
  if not (COB.Codec and COB.Codec.EncodeNights) then
    return false, "no codec"
  end
  local payload, err = COB.Codec:EncodeNights(COB.Nights:BroadcastSnapshot())
  if not payload then
    return false, err
  end
  return self:Send(payload, nowSeconds)
end

function Net:SendStub(fields, nowSeconds)
  local name
  if COB.Group and COB.Group.PlayerName then
    name = COB.Group.PlayerName()
  end
  if not (COB.Sender and COB.Sender.CanWriteStub and COB.Sender:CanWriteStub(name)) then
    return false, "not accepted"
  end
  if not (COB.Codec and COB.Codec.EncodeStub) then
    return false, "no codec"
  end
  local payload, err = COB.Codec:EncodeStub(fields)
  if not payload then
    return false, err
  end
  return self:Send(payload, nowSeconds)
end

function Net:SendStubWithdraw(fields, nowSeconds)
  local name
  if COB.Group and COB.Group.PlayerName then
    name = COB.Group.PlayerName()
  end
  if not (COB.Sender and COB.Sender.CanWriteStub and COB.Sender:CanWriteStub(name)) then
    return false, "not accepted"
  end
  if not (COB.Codec and COB.Codec.EncodeStubWithdraw) then
    return false, "no codec"
  end
  local payload, err = COB.Codec:EncodeStubWithdraw(fields)
  if not payload then
    return false, err
  end
  return self:Send(payload, nowSeconds)
end

function Net:SendGoing(fields, target, nowSeconds)
  target = resolveDest(target)
  if not target then
    return false, "no target"
  end
  if not (COB.Codec and COB.Codec.EncodeInput) then
    return false, "no codec"
  end
  local body = type(fields) == "table" and {
    kind = "going",
    occurrence = fields.occurrence,
  } or { kind = "going" }
  local payload, err = COB.Codec:EncodeInput(body)
  if not payload then
    return false, err
  end
  return self:_TransmitWhisper(payload, target)
end

function Net:RebroadcastStubs(nowSeconds)
  local t = now(self, nowSeconds)
  if type(self.stubsRebroadcastAt) == "number"
      and (t - self.stubsRebroadcastAt) < STUB_REBROADCAST_INTERVAL then
    return false, "throttled"
  end
  local name
  if COB.Group and COB.Group.PlayerName then
    name = COB.Group.PlayerName()
  end
  local canStub = COB.Sender and COB.Sender.CanWriteStub and COB.Sender:CanWriteStub(name)
  local isPope = self:_LocalPope()
  if not canStub and not isPope then
    return false, "not accepted"
  end
  if not (COB.Nights and COB.Nights.Snapshot) then
    return false, "nights is not available"
  end
  local snap = COB.Nights:Snapshot()
  if type(snap) ~= "table" or type(snap.stubs) ~= "table" then
    return true
  end
  self.stubsRebroadcastAt = t
  for i = 1, #snap.stubs do
    local row = snap.stubs[i]
    if type(row) == "table" then
      row.boardRevision = snap.boardRevision
      self:SendStub(row, nowSeconds)
    end
  end
  return true
end

-- Congregation → Pope. Not Pope-gated. Favor+pick only. Explicit dest wins;
-- blank falls back to the default destination (resolveDest).
function Net:SendFavor(fields, target, nowSeconds)
  target = resolveDest(target)
  if not target then
    return false, "no target"
  end
  if not (COB.Codec and COB.Codec.EncodeInput) then
    return false, "no codec"
  end
  local body = type(fields) == "table" and {
    kind = "favor",
    characterId = fields.characterId,
    pick = fields.pick,
  } or { kind = "favor" }
  local payload, err = COB.Codec:EncodeInput(body)
  if not payload then
    return false, err
  end
  return self:_TransmitWhisper(payload, target)
end

-- Congregation → Pope. Not Pope-gated. Petition id, optional opponent name.
-- Do not copy namedOpponentId onto the wire. Explicit dest wins; blank falls
-- back to the default destination (resolveDest).
function Net:SendPetition(fields, target, nowSeconds)
  target = resolveDest(target)
  if not target then
    return false, "no target"
  end
  if not (COB.Codec and COB.Codec.EncodeInput) then
    return false, "no codec"
  end
  local body = type(fields) == "table" and {
    kind = "petition",
    characterId = fields.characterId,
  } or { kind = "petition" }
  if type(fields) == "table" and type(fields.opponent) == "string"
      and fields.opponent ~= "" then
    body.opponent = fields.opponent
  end
  local payload, err = COB.Codec:EncodeInput(body)
  if not payload then
    return false, err
  end
  return self:_TransmitWhisper(payload, target)
end

-- Congregation → Pope. Not Pope-gated. Confession text is optional.
-- Trim text (Names.Trim or local trim). Empty after trim omits
-- body.text and still sends. Explicit dest wins; blank falls back to
-- the default destination (resolveDest).
function Net:SendConfession(fields, target, nowSeconds)
  target = resolveDest(target)
  if not target then
    return false, "no target"
  end
  if not (COB.Codec and COB.Codec.EncodeInput) then
    return false, "no codec"
  end
  if type(fields) == "table" and type(fields.text) == "string"
      and fields.text:find("\n", 1, true) then
    return false, "invalid text"
  end
  local text
  if type(fields) == "table" then
    if COB.Names and type(COB.Names.Trim) == "function" then
      text = COB.Names.Trim(fields.text)
    else
      text = trim(fields.text)
    end
  end
  local body = type(fields) == "table" and {
    kind = "confession",
    characterId = fields.characterId,
  } or { kind = "confession" }
  if type(text) == "string" then
    body.text = text
  end
  local payload, err = COB.Codec:EncodeInput(body)
  if not payload then
    return false, err
  end
  return self:_TransmitWhisper(payload, target)
end

-- Congregation → Pope. Not Pope-gated. Explicit dest wins; blank falls back
-- to the default destination (resolveDest).
function Net:RequestSnapshot(target, nowSeconds)
  target = resolveDest(target)
  if not target then
    return false, "no target"
  end
  local payload, err
  if COB.Snapshot and COB.Snapshot.Request then
    payload, err = COB.Snapshot:Request()
  elseif COB.Codec and COB.Codec.EncodeSnapshot then
    payload, err = COB.Codec:EncodeSnapshot({ role = "request" })
  else
    return false, "no codec"
  end
  if not payload then
    return false, err
  end
  return self:_TransmitWhisper(payload, target)
end

--------------------------------------------------------------------------------
-- Inbound
--------------------------------------------------------------------------------

function Net:_WarnVersion(version)
  if self.warnedVersion then return false end
  self.warnedVersion = true
  chat("the Church's software has advanced; update the addon.")
  return true
end

local function dropToQuietForVersion()
  local runtime = COB.Runtime
  if type(runtime) == "table" and type(runtime.DropToQuietForVersion) == "function" then
    runtime:DropToQuietForVersion()
  end
end

--------------------------------------------------------------------------------
-- Inbound pacing
--------------------------------------------------------------------------------

-- One token bucket per sender. Answers "may this client speak right now", which is
-- a different question from "is this message well formed": a peer that floods is
-- silenced without any of its payloads being parsed, so the cost of abuse stays flat.
function Net:_AllowInbound(sender, nowSeconds)
  local key = nameKey(sender)
  if not key then return false end

  local t = now(self, nowSeconds)
  local bucket = self.inbound[key]
  if not bucket then
    -- Bounded: a guild-sized burst of first-time senders must not grow this table
    -- without limit. Everyone starts full again, which is the harmless direction.
    local count = 0
    for _ in pairs(self.inbound) do count = count + 1 end
    if count >= self.MaxInboundSenders then self.inbound = {} end
    bucket = { tokens = self.InboundBurst, at = t }
    self.inbound[key] = bucket
  else
    local elapsed = t - bucket.at
    if elapsed > 0 then
      bucket.tokens = bucket.tokens + elapsed * self.InboundPerSecond
      if bucket.tokens > self.InboundBurst then bucket.tokens = self.InboundBurst end
      bucket.at = t
    end
  end

  if bucket.tokens < 1 then return false end
  bucket.tokens = bucket.tokens - 1
  return true
end

function Net:HandleHello(message, sender)
  if not self:IsCompatible(message.version) then
    self:_WarnVersion(message.version)
    dropToQuietForVersion()
    return false
  end
  -- Our own HELLO comes back to us off the guild channel. Counting it would make a
  -- lone user look like they had company.
  if self:IsSelf(sender) then return false end

  self.peers = self.peers or {}
  local key = nameKey(sender)
  if key then self.peers[key] = message.fields[1] or "?" end
  -- A guildmate's HELLO may be a late joiner: the bootstrap installs
  -- COB._OnPeerHello so the Pope's client re-broadcasts live state. Errors
  -- are swallowed; a missing callback is a no-op.
  if type(COB._OnPeerHello) == "function" then
    pcall(COB._OnPeerHello, sender)
  end
  return true
end

-- Guildmates we have heard a HELLO from this session. Informational only:
-- version/presence discovery, not authority.
function Net:PeerCount()
  local count = 0
  for _ in pairs(self.peers or {}) do count = count + 1 end
  return count
end

function Net:OnAddonMessage(prefix, payload, channel, sender, nowSeconds)
  if prefix ~= self.Prefix then return false end
  -- HELLO, STATE, and DECREE travel on GUILD. SNAPSHOT catch-up and INPUT
  -- (favor, petition, confession) are whisper only.
  if channel ~= self.Channel and channel ~= "WHISPER" then return false end

  -- Our own guild-channel traffic comes straight back to us and is not somebody
  -- else's budget to spend. Whisper senders share the same inbound budget.
  if not self:IsSelf(sender) and not self:_AllowInbound(sender, nowSeconds) then
    return false, "sender is talking too fast"
  end

  local message = self:Decode(payload)
  if not message then return false, "undecodable payload" end
  if RETIRED_TYPES[message.type] then return false, "retired message type" end

  if TYPES[message.type] then
    if channel ~= self.Channel then return false end
    if not self:IsCompatible(message.version) then
      self:_WarnVersion(message.version)
      dropToQuietForVersion()
      return false, "protocol mismatch"
    end
    if message.type == "HELLO" then
      return self:HandleHello(message, sender)
    end
    return false
  end

  return self:_HandleV2(payload, channel, sender)
end

function Net:_HandleV2(payload, channel, sender)
  if not (COB.Codec and COB.Codec.Decode) then
    return false, "unknown message type"
  end
  local decoded = COB.Codec:Decode(payload)
  if not decoded then
    return false, "unknown message type"
  end
  local msgType = decoded.type
  if msgType ~= "STATE" and msgType ~= "SNAPSHOT"
      and msgType ~= "DECREE" and msgType ~= "INPUT"
      and msgType ~= "NIGHTS" and msgType ~= "STUB" and msgType ~= "STUB_WITHDRAW" then
    return false, "unknown message type"
  end
  -- GUILD INPUT stays unknown — not a live channel.
  if msgType == "INPUT" and channel ~= "WHISPER" then
    return false, "unknown message type"
  end
  if not COB.Codec:IsCompatible(decoded.version) then
    self:_WarnVersion(decoded.version)
    dropToQuietForVersion()
    return false, "protocol mismatch"
  end
  if msgType == "STATE" then
    -- The last sender whose STATE passed sender auth is the default whisper
    -- destination for congregation inputs. Store the raw sender string.
    if COB.Sender and COB.Sender.Accept and COB.Sender:Accept(sender, "STATE") then
      self._lastStateSender = sender
    end
    return self:_HandleState(decoded, channel, sender)
  end
  if msgType == "SNAPSHOT" then
    return self:_HandleSnapshot(decoded, channel, sender, payload)
  end
  if msgType == "DECREE" then
    return self:_HandleDecree(decoded, channel, sender)
  end
  if msgType == "NIGHTS" then
    return self:_HandleNights(decoded, channel, sender)
  end
  if msgType == "STUB" then
    return self:_HandleStub(decoded, channel, sender)
  end
  if msgType == "STUB_WITHDRAW" then
    return self:_HandleStubWithdraw(decoded, channel, sender)
  end
  if decoded.kind == "favor" then
    return self:_HandleFavor(decoded, channel, sender)
  end
  if decoded.kind == "petition" then
    return self:_HandlePetition(decoded, channel, sender)
  end
  if decoded.kind == "confession" then
    return self:_HandleConfession(decoded, channel, sender)
  end
  if decoded.kind == "going" then
    return self:_HandleGoing(decoded, channel, sender)
  end
  return false, "unknown message type"
end

function Net:_HandleState(decoded, channel, sender)
  if channel ~= self.Channel then
    return false
  end
  if not (COB.Sender and COB.Sender.Accept) then
    return false
  end
  if not COB.Sender:Accept(sender, "STATE") then
    return false, "not accepted"
  end
  if not (COB.Runtime and COB.Runtime.Restore) then
    return false
  end
  -- Bible fields only. Do not encode or Restore awaitingPope.
  -- Restore's return is the favor-overlay gate: ok on equal sequence
  -- (glue still paints), not-ok on an older sequence (no rewind).
  return COB.Runtime:Restore({
    eventId = decoded.eventId,
    state = decoded.state,
    riteType = decoded.riteType,
    subjects = decoded.subjects,
    sequence = decoded.sequence,
  })
end

function Net:_HandleSnapshot(decoded, channel, sender, payload)
  if channel ~= "WHISPER" then
    return false
  end
  if decoded.role == "response" then
    if not (COB.Sender and COB.Sender.Accept) then
      return false
    end
    if not COB.Sender:Accept(sender, "SNAPSHOT") then
      return false, "not accepted"
    end
    if not (COB.Snapshot and COB.Snapshot.ApplyResponse) then
      return false
    end
    return COB.Snapshot:ApplyResponse(payload)
  end
  if decoded.role == "request" then
    -- Congregation → Pope. Not the theater Accept gate. No one else answers.
    if not self:_LocalPope() then
      return false, "not a registered pope"
    end
    if not (COB.Snapshot and COB.Snapshot.BuildResponse) then
      return false
    end
    local blob = COB.Snapshot:BuildResponse()
    if not blob then
      return false
    end
    local ok = self:_TransmitWhisper(blob, sender)
    if ok and self.SendNights then
      pcall(self.SendNights, self)
    end
    return ok
  end
  return false
end

function Net:_HandleDecree(decoded, channel, sender)
  if channel ~= self.Channel then
    return false
  end
  -- Accept(sender, "DECREE") is false today. Call the registered-Pope predicate.
  if not (COB.Sender and COB.Sender.IsRegisteredPope) then
    return false
  end
  if not COB.Sender:IsRegisteredPope(sender) then
    return false, "not accepted"
  end
  if COB.Decree and COB.Decree.Set then
    local saved, err = COB.Decree:Set({
      line = decoded.line,
      flavor = decoded.flavor,
    })
    if not saved then
      return false, err
    end
  end
  if COB.Nights and COB.Nights.ImportDecree then
    COB.Nights:ImportDecree(decoded.line, decoded.flavor)
  end
  return true
end

function Net:_HandleNights(decoded, channel, sender)
  if channel ~= self.Channel then
    return false
  end
  if not (COB.Sender and COB.Sender.Accept and COB.Sender:Accept(sender, "NIGHTS")) then
    return false, "not accepted"
  end
  if not (COB.Nights and COB.Nights.ApplyBroadcast) then
    return false
  end
  return COB.Nights:ApplyBroadcast({
    series = decoded.series,
    stubs = decoded.stubs,
    stubTombstones = decoded.stubTombstones,
    goingCounts = decoded.goingCounts,
    boardRevision = decoded.boardRevision,
  })
end

function Net:_HandleStub(decoded, channel, sender)
  if channel ~= self.Channel then
    return false
  end
  if not (COB.Sender and COB.Sender.Accept and COB.Sender:Accept(sender, "STUB")) then
    return false, "not accepted"
  end
  if not (COB.Nights and COB.Nights.ApplyStub) then
    return false
  end
  return COB.Nights:ApplyStub({
    id = decoded.id,
    kind = decoded.kind,
    title = decoded.title,
    timeLine = decoded.timeLine,
    place = decoded.place,
    date = decoded.date,
    createdBy = decoded.createdBy or sender,
    updatedAt = decoded.updatedAt,
    boardRevision = decoded.boardRevision,
  })
end

function Net:_HandleStubWithdraw(decoded, channel, sender)
  if channel ~= self.Channel then
    return false
  end
  if not (COB.Sender and COB.Sender.Accept and COB.Sender:Accept(sender, "STUB_WITHDRAW")) then
    return false, "not accepted"
  end
  if not (COB.Nights and COB.Nights.ApplyTombstone) then
    return false
  end
  return COB.Nights:ApplyTombstone(decoded.id, decoded.boardRevision)
end

function Net:_HandleGoing(decoded, channel, sender)
  if channel ~= "WHISPER" or decoded.kind ~= "going" then
    return false, "unknown message type"
  end
  if not self:_LocalPope() then
    return false, "not a registered pope"
  end
  if not (COB.Nights and COB.Nights.SetGoing) then
    return false
  end
  local already = COB.Nights.IsGoing and COB.Nights:IsGoing(decoded.occurrence, sender)
  local ok, err = COB.Nights:SetGoing(decoded.occurrence, sender, already ~= true)
  if not ok then
    return false, err
  end
  if self.SendNights then
    pcall(self.SendNights, self)
  end
  return true
end

function Net:_HandleFavor(decoded, channel, sender)
  if channel ~= "WHISPER" or decoded.kind ~= "favor" then
    return false, "unknown message type"
  end
  if not self:_LocalPope() then
    return false, "not a registered pope"
  end
  local pick = decoded.pick
  if pick == nil then
    return false
  end
  if not (COB.Gora and COB.Gora.RecordFavorFromSender) then
    return false
  end
  -- Ignore payload characterId. Key by the server-provided sender.
  local ok, err = COB.Gora:RecordFavorFromSender(sender, pick)
  if not ok then
    return false, err
  end
  return true
end

-- Name → store id. First match on Snapshot().characters via Names.Key / Same.
-- Missing Store, missing list, or no match → nil (caller ignores the opponent).
local function resolveOpponentId(opponentName)
  if not (COB.Store and type(COB.Store.Snapshot) == "function") then
    return nil
  end
  if not (COB.Names and COB.Names.Key and COB.Names.Same) then
    return nil
  end
  local snap = COB.Store:Snapshot()
  local chars = type(snap) == "table" and snap.characters or nil
  if type(chars) ~= "table" then
    return nil
  end
  for i = 1, #chars do
    local row = chars[i]
    if type(row) == "table" and COB.Names.Same(row.name, opponentName) then
      return row.id
    end
  end
  return nil
end

function Net:_HandlePetition(decoded, channel, sender)
  if channel ~= "WHISPER" or decoded.kind ~= "petition" then
    return false, "unknown message type"
  end
  if not self:_LocalPope() then
    return false, "not a registered pope"
  end
  if not (COB.Gora and COB.Gora.PetitionFromSender) then
    return false
  end
  local opponent = type(decoded.opponent) == "string" and trim(decoded.opponent) or nil
  local namedOpponentId
  if opponent then
    namedOpponentId = resolveOpponentId(opponent)
  end
  -- Ignore payload characterId. Unknown opponent is dropped, not refused.
  local ok, err = COB.Gora:PetitionFromSender(sender, namedOpponentId)
  if not ok then
    return false, err
  end
  return true
end

function Net:_HandleConfession(decoded, channel, sender)
  if channel ~= "WHISPER" or decoded.kind ~= "confession" then
    return false, "unknown message type"
  end
  if not self:_LocalPope() then
    return false, "not a registered pope"
  end
  if not (COB.Confession and COB.Confession.ReceiveFromSender) then
    return false
  end
  -- Ignore payload characterId. Key by the server-provided sender.
  local ok, err = COB.Confession:ReceiveFromSender(sender, decoded.text)
  if not ok then
    return false, err
  end
  return true
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
  return ready
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
  self.inbound = {}
  self.peers = nil
  self.lastSentAt = nil
  self.lastSent = nil
  self.tokens = nil
  self.tokensAt = nil
  self.sentCount = 0
  self.armed = nil
  self.warnedVersion = nil
  self.rosterRequestedAt = nil
  self.stubsRebroadcastAt = nil
  self._lastStateSender = nil
  self.clock = nil
  self.transmit = nil
  self.initialized = nil
  return true
end
