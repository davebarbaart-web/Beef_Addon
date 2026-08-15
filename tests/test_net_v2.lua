-- BeefNet v2 wire (Phase 4 Lane B). Isolated: Common + Runtime + Codec +
-- Snapshot + Sender + BeefNet. STATE on GUILD, SNAPSHOT on WHISPER.
-- HELLO stays the transport. Accept / IsRegisteredPope are false today.
-- No #8 Pope list. No INPUT channel. No holdSeconds. No peer SYNC.
-- Do not load TOC / bootstrap / run.lua / Store / UI / DB / Data/Popes.lua.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed = 0
local failed = 0

if standalone then
  function assert_eq(a, b, msg)
    if a ~= b then
      failed = failed + 1
      print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
    else
      passed = passed + 1
    end
  end
  function assert_true(v, msg)
    assert_eq(not not v, true, msg)
  end
end

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Net/Codec.lua")
dofile("addon/ChurchOfBeef/Net/Snapshot.lua")
dofile("addon/ChurchOfBeef/Core/Sender.lua")
dofile("addon/ChurchOfBeef/Net/BeefNet.lua")

local COB = ChurchOfBeef
local Runtime = COB.Runtime
local Codec = COB.Codec
local Snapshot = COB.Snapshot
local Sender = COB.Sender
local Net = COB.Net

local sent = 0
local framed = 0
local guildReads = 0
local chats = {}
local wire = {}

UnitName = function(unit)
  if unit == "player" then return "Beefina" end
  return nil
end
IsInGuild = function()
  return true
end
GetTime = function()
  return 0
end
C_Timer = {
  After = function() end,
}
SendAddonMessage = function()
  sent = sent + 1
end
C_ChatInfo = {
  SendAddonMessage = function()
    sent = sent + 1
  end,
  RegisterAddonMessagePrefix = function() end,
}
CreateFrame = function()
  framed = framed + 1
  return {
    RegisterEvent = function() end,
    SetScript = function() end,
  }
end
GetNumGuildMembers = function()
  guildReads = guildReads + 1
  return 3
end
GetGuildRosterInfo = function()
  guildReads = guildReads + 1
  return "Pope", "Guild Master", 0
end
GetGuildInfo = function()
  guildReads = guildReads + 1
  return "Church of Beef", "Guild Master", 0
end
UnitIsGuildLeader = function()
  guildReads = guildReads + 1
  return true
end
IsGuildLeader = function()
  guildReads = guildReads + 1
  return true
end
DEFAULT_CHAT_FRAME = {
  AddMessage = function(_, text)
    chats[#chats + 1] = text
  end,
}

local function reset()
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Net:ResetForTests(), true, "Net ResetForTests runs under _IN_TEST")
  sent = 0
  framed = 0
  guildReads = 0
  chats = {}
  wire = {}
  Net.transmit = function(payload, channel, target)
    sent = sent + 1
    wire[#wire + 1] = {
      payload = payload,
      channel = channel,
      target = target,
    }
  end
end

local function same_fighters(a, b)
  if a == nil and b == nil then return true end
  if type(a) ~= "table" or type(b) ~= "table" then return a == b end
  if #a ~= #b then return false end
  for i = 1, #a do
    if a[i] ~= b[i] then return false end
  end
  return true
end

local function assert_bible(a, b, msg)
  msg = msg or "bible"
  assert_eq(a.eventId, b.eventId, msg .. " event id")
  assert_eq(a.state, b.state, msg .. " state")
  assert_eq(a.riteType, b.riteType, msg .. " rite type")
  assert_eq(a.sequence, b.sequence, msg .. " sequence")
  assert_eq(a.subjects.candidate, b.subjects.candidate, msg .. " candidate")
  assert_true(same_fighters(a.subjects.fighters, b.subjects.fighters), msg .. " fighters")
end

local function assert_unchanged(before, after, msg)
  assert_bible(after, before, (msg or "state") .. " unchanged")
  assert_eq(after.awaitingPope, before.awaitingPope, (msg or "state") .. " awaitingPope unchanged")
end

local function guild(payload, sender)
  return Net:OnAddonMessage(Net.Prefix, payload, "GUILD", sender or "Steakina")
end

local function whisper(payload, sender)
  return Net:OnAddonMessage(Net.Prefix, payload, "WHISPER", sender or "Steakina")
end

local function state_wire(fields)
  return Codec:EncodeState(fields or {
    eventId = 1,
    state = "ASSEMBLY",
    sequence = 1,
  })
end

local function hello_payload(version)
  return Net:Encode("HELLO", version or "0.1.0")
end

--------------------------------------------------------------------------------
-- Isolated surface: transport + signed codecs. Not a Pope list.
--------------------------------------------------------------------------------
assert_true(Net ~= nil, "COB.Net exists")
assert_true(Runtime ~= nil, "Runtime is loaded")
assert_true(Codec ~= nil, "Codec is loaded")
assert_true(Snapshot ~= nil, "Snapshot is loaded")
assert_true(Sender ~= nil, "Sender is loaded")
assert_true(COB.Names ~= nil, "Common name law is loaded")

if standalone then
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Ranks, nil, "isolated suite does not load Ranks")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
end

assert_eq(Net.Prefix, "COB", "the prefix is COB")
assert_eq(Net.Channel, "GUILD", "HELLO and STATE travel on GUILD")
assert_eq(Net.PROTOCOL, 1, "protocol major stays 1")
assert_eq(type(Net.SendHello), "function", "SendHello stays")
assert_eq(type(Net._WarnVersion), "function", "_WarnVersion stays")
assert_eq(type(Net.SendState), "function", "SendState exists")
assert_eq(type(Net.SendSnapshot), "function", "SendSnapshot exists")
assert_eq(type(Net.OnAddonMessage), "function", "OnAddonMessage stays")

assert_eq(Net.SendSuggestion, nil, "SUGGESTION send is gone")
assert_eq(Net.HandleSuggestion, nil, "SUGGESTION is not handled")
assert_eq(Net.ReleaseHeld, nil, "petition hold/replay is gone")
assert_eq(Net.MaxHeld, nil, "no petition hold budget")
assert_eq(Net.holdSeconds, nil, "no holdSeconds")
assert_eq(Net.Hold, nil, "no hold timer")
assert_eq(Net.inbox, nil, "no INPUT inbox")
assert_eq(Net.Inbox, nil, "no Inbox")
assert_eq(Net.Toast, nil, "no toast")
assert_eq(Net.Notify, nil, "no Notify toast")
assert_eq(Net.RegisterPope, nil, "no RegisterPope")
assert_eq(Net.IsPope, nil, "no IsPope list")
assert_eq(Net.popes, nil, "no pope table")
assert_eq(Net.Grant, nil, "no Grant")
assert_eq(Net.ApplySync, nil, "no peer SYNC apply")
assert_eq(Net.SendSync, nil, "no SYNC send")
assert_eq(Net.Director, nil, "no Director Console")
assert_eq(Net.SendInput, nil, "no live INPUT send")
assert_eq(Net.HandleInput, nil, "no INPUT handler")
assert_eq(Net.LookupPope, nil, "no Pope-name lookup")
assert_eq(Net.FindPope, nil, "no FindPope")
assert_eq(COB.Popes, nil, "no COB.Popes (#8 is not coded)")

--------------------------------------------------------------------------------
-- HELLO unchanged: GUILD, prefix COB, presence, throttle, one version notice.
--------------------------------------------------------------------------------
reset()
assert_eq(hello_payload("0.1.0"), "1:HELLO:0.1.0", "HELLO framing is unchanged")
assert_eq(guild(hello_payload("0.1.0"), "Steakina"), true, "a peer HELLO on GUILD is accepted")
assert_eq(Net:PeerCount(), 1, "HELLO still seats presence")
assert_eq(Net.peers.steakina, "0.1.0", "presence is keyed by the shared name law")

assert_eq(guild(hello_payload("0.1.0"), "Beefina"), false, "our own HELLO echo is not a peer")
assert_eq(Net:PeerCount(), 1, "self never joins the peer table")

assert_eq(Net:OnAddonMessage("XYZ", hello_payload(), "GUILD", "Steakina"), false,
  "another addon's prefix is not our traffic")
assert_eq(Net:OnAddonMessage(Net.Prefix, hello_payload(), "RAID", "Steakina"), false,
  "HELLO is not accepted off the guild channel")
assert_eq(Net:OnAddonMessage(Net.Prefix, hello_payload(), "WHISPER", "Steakina"), false,
  "HELLO is not accepted on WHISPER")
assert_eq(Net:PeerCount(), 1, "wrong-channel HELLO is not a peer")

reset()
local _, helloWhy = guild("2:HELLO:9.9.9", "Steakina")
assert_eq(helloWhy, "protocol mismatch", "a mismatched HELLO is discarded")
assert_eq(Net.warnedVersion, true, "the first mismatch is the Quiet version notice")
assert_eq(#chats, 1, "incompatible HELLO chats once")
assert_eq(Net:_WarnVersion(2), false, "the version notice fires once")
assert_eq(#chats, 1, "a second _WarnVersion does not chat again")
assert_eq(Net:PeerCount(), 0, "a mismatched HELLO is not a peer")

reset()
assert_true(Net:SendHello(), "SendHello still goes out")
assert_eq(#wire, 1, "SendHello transmits once")
assert_eq(wire[1].channel, "GUILD", "SendHello stays on GUILD")
assert_true(wire[1].payload:find("HELLO", 1, true) ~= nil, "SendHello encodes HELLO")

reset()
local clock = 0
Net.clock = function() return clock end
for _ = 1, 12 do Net:Send(hello_payload(), clock) end
assert_eq(#wire, Net.OutboundBurst, "outbound burst of ten is unchanged")
assert_true(#Net.queue > 0, "overflow still waits in the queue")
clock = 1
assert_eq(Net:Pump(), 1, "one second still buys exactly one more")

reset()
local inClock = 0
Net.clock = function() return inClock end
local accepted = 0
for _ = 1, 12 do
  if guild(hello_payload(), "Steakina") then accepted = accepted + 1 end
end
assert_eq(accepted, Net.InboundBurst, "inbound burst budget is unchanged")
local _, tooFast = guild(hello_payload(), "Steakina")
assert_eq(tooFast, "sender is talking too fast", "inbound rate limit is unchanged")

--------------------------------------------------------------------------------
-- HELLO-green contract: malformed STATE / SNAPSHOT stay unknown.
--------------------------------------------------------------------------------
reset()
local _, why = guild(Net:Encode("SNAPSHOT", "x"), "Chuckina")
assert_eq(why, "unknown message type", "N:Encode SNAPSHOT x is unknown, not a v2 codec")
_, why = guild(Net:Encode("STATE", "QUIET"), "Porkina")
assert_eq(why, "unknown message type", "N:Encode STATE QUIET is unknown")
_, why = guild(Net:Encode("SNAPSHOT", "theater"), "Beefina")
assert_eq(why, "unknown message type", "N:Encode SNAPSHOT theater is unknown")
assert_eq(Runtime:Snapshot().state, "QUIET", "unknown STATE/SNAPSHOT do not Restore")

--------------------------------------------------------------------------------
-- Retired SUGGESTION / SYNC_* / RANK_COMMIT stay discarded unread.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeRetired = Runtime:Snapshot()
_, why = guild("1:RANK_COMMIT:Beefina:3:300:4:1700:Pope", "Pope")
assert_eq(why, "retired message type", "RANK_COMMIT is discarded by name")
_, why = guild("1:SYNC_REQUEST:req1", "Pope")
assert_eq(why, "retired message type", "SYNC_REQUEST is discarded by name")
_, why = guild("1:SYNC_STATE:req1:1:1:payload", "Pope")
assert_eq(why, "retired message type", "SYNC_STATE is discarded by name")
_, why = guild("1:SUGGESTION:Beefina:1:2:300:250", "Beefina")
assert_eq(why, "retired message type", "SUGGESTION is discarded by name")
_, why = whisper("1:SYNC_STATE:1:ASSEMBLY::::1", "Pope")
assert_eq(why, "retired message type", "SYNC_STATE on WHISPER is still retired")
assert_unchanged(beforeRetired, Runtime:Snapshot(), "retired types do not Restore")
assert_eq(Net:PeerCount(), 0, "retired types seat no peer")
assert_eq(#wire, 0, "retired types do not fan out")

--------------------------------------------------------------------------------
-- Inbound STATE on GUILD: Codec:Decode; Accept is false; discard; no Restore.
--------------------------------------------------------------------------------
reset()
local assemblyWire = state_wire({
  eventId = 4,
  state = "ASSEMBLY",
  sequence = 1,
})
assert_eq(Codec:Decode(assemblyWire).type, "STATE", "STATE wire decodes on Codec")
assert_eq(Sender:Accept("Steakina", "STATE"), false, "Accept STATE is false today")

local ok, stateWhy = guild(assemblyWire, "Steakina")
assert_eq(ok, false, "STATE on GUILD is discarded while Accept is false")
assert_eq(stateWhy, "not accepted", "discarded STATE names the Accept gate")
assert_eq(Runtime:Snapshot().state, "QUIET", "discarded STATE does not Restore")
assert_eq(Runtime:Snapshot().eventId, nil, "discarded STATE does not store an event")
assert_eq(Net.pendingState, nil, "discarded STATE is not stored for later paint")
assert_eq(Net.held, nil, "discarded STATE is not held")
assert_eq(Net.lastState, nil, "discarded STATE is not kept as lastState")
assert_eq(Net.discarded, nil, "rejected theater is not stored")
assert_eq(#wire, 0, "discarded STATE does not rebroadcast")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 3, 4 } })
local live = Runtime:Snapshot()
local foreignState = state_wire({
  eventId = 9,
  state = "RITE",
  riteType = "Knighting",
  subjects = { candidate = 7 },
  sequence = 2,
})
assert_eq(guild(foreignState, "Pope"), false, "STATE from a sender named Pope is still discarded")
assert_eq(Sender:IsRegisteredPope("Pope"), false, "the name Pope is not a registered Pope")
assert_unchanged(live, Runtime:Snapshot(), "discarded STATE does not overwrite a live rite")
assert_eq(Runtime:Snapshot().riteType, "Gora", "local rite is not replaced")

reset()
Runtime:StartEvent()
local localAssembly = Runtime:Snapshot()
assert_eq(guild(assemblyWire, "Beefina"), false, "our own STATE echo is discarded")
assert_unchanged(localAssembly, Runtime:Snapshot(), "self STATE does not Restore")

--------------------------------------------------------------------------------
-- Inbound STATE on WHISPER / RAID: not GUILD. Do not Restore.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeWrong = Runtime:Snapshot()
assert_eq(whisper(assemblyWire, "Steakina"), false, "STATE on WHISPER is discarded")
assert_eq(Net:OnAddonMessage(Net.Prefix, assemblyWire, "RAID", "Steakina"), false,
  "STATE on RAID is discarded")
assert_unchanged(beforeWrong, Runtime:Snapshot(), "wrong-channel STATE does not Restore")

--------------------------------------------------------------------------------
-- Inbound SNAPSHOT response on WHISPER: Accept then Apply only if Accept.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { candidate = 9, fighters = { 1, 2 } })
local popeLive = Runtime:Snapshot()
local responseWire = Snapshot:BuildResponse()
assert_true(responseWire ~= nil, "BuildResponse encodes a live event")
assert_eq(Codec:Decode(responseWire).role, "response", "response role is on the wire")

reset()
assert_eq(Runtime:Snapshot().state, "QUIET", "congregation starts QUIET")
assert_eq(Sender:Accept("Steakina", "SNAPSHOT"), false, "Accept SNAPSHOT is false today")
ok, stateWhy = whisper(responseWire, "Steakina")
assert_eq(ok, false, "SNAPSHOT response is discarded while Accept is false")
assert_eq(stateWhy, "not accepted", "discarded SNAPSHOT response names the Accept gate")
assert_eq(Runtime:Snapshot().state, "QUIET", "discarded response does not Apply")
assert_eq(Runtime:Snapshot().eventId, nil, "discarded response does not land an event")
assert_eq(Net.pendingSnapshot, nil, "discarded SNAPSHOT is not stored for later paint")
assert_eq(#wire, 0, "discarded response does not fan out")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting", { candidate = 2 })
local beforeSpoof = Runtime:Snapshot()
assert_eq(whisper(responseWire, "Spoof"), false, "SNAPSHOT response from a spoof is discarded")
assert_unchanged(beforeSpoof, Runtime:Snapshot(), "spoofed SNAPSHOT does not Apply")

--------------------------------------------------------------------------------
-- Inbound SNAPSHOT request on WHISPER: not the theater gate; no one else answers.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Confession", { candidate = 5 })
local beforeReq = Runtime:Snapshot()
local reqWire = Snapshot:Request()
assert_eq(reqWire, "1:SNAPSHOT:request", "Request wire is role only")
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "local player is not a registered Pope")
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "PlayerName is not a registered Pope")

sent = 0
wire = {}
ok, stateWhy = whisper(reqWire, "LateJoin")
assert_eq(ok, false, "SNAPSHOT request is not answered today")
assert_eq(stateWhy, "not a registered pope", "only a registered Pope answers a request")
assert_unchanged(beforeReq, Runtime:Snapshot(), "unanswered request does not change Runtime")
assert_eq(#wire, 0, "no one else answers — no whisper reply")
assert_eq(sent, 0, "request does not SendAddonMessage")
for i = 1, #wire do
  assert_eq(wire[i].channel ~= "GUILD", true, "request must not GUILD fan-out")
end

--------------------------------------------------------------------------------
-- Inbound SNAPSHOT on GUILD: not whisper. No fan-out. No Apply. No answer.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeGuildSnap = Runtime:Snapshot()
assert_eq(guild(responseWire, "Steakina"), false, "SNAPSHOT response on GUILD is discarded")
assert_eq(guild(reqWire, "LateJoin"), false, "SNAPSHOT request on GUILD is discarded")
assert_unchanged(beforeGuildSnap, Runtime:Snapshot(), "GUILD SNAPSHOT does not Apply")
assert_eq(#wire, 0, "GUILD SNAPSHOT does not fan out")
assert_eq(sent, 0, "GUILD SNAPSHOT does not send")

--------------------------------------------------------------------------------
-- INPUT is not a live channel. Do not Restore. Do not paint. No inbox.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeInput = Runtime:Snapshot()
local petition = Codec:EncodeInput({ kind = "petition", characterId = 12 })
local favor = Codec:EncodeInput({ kind = "favor", characterId = 2 })
local confession = Codec:EncodeInput({ kind = "confession", characterId = 3, text = "free text" })
assert_eq(Codec:Decode(petition).type, "INPUT", "petition still decodes on Codec")

_, why = guild(petition, "Petitioner")
assert_eq(why, "unknown message type", "INPUT on GUILD is not a live channel")
_, why = whisper(favor, "Petitioner")
assert_eq(why, "unknown message type", "INPUT on WHISPER is not a live channel")
_, why = guild(confession, "Petitioner")
assert_eq(why, "unknown message type", "confession INPUT is not a live channel")
assert_unchanged(beforeInput, Runtime:Snapshot(), "INPUT does not Restore Runtime")
assert_eq(Net.inbox, nil, "INPUT does not invent a console queue")
assert_eq(Net.pendingInput, nil, "INPUT is not stored")
assert_eq(#wire, 0, "INPUT does not paint or fan out")
assert_eq(Sender:Accept("Petitioner", "INPUT"), true, "Accept INPUT may be true — Net still does not wire it")

--------------------------------------------------------------------------------
-- Outbound SendState / SendSnapshot only if local IsRegisteredPope. No send today.
--------------------------------------------------------------------------------
reset()
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "local player is not a registered Pope")
local sendOk, sendWhy = Net:SendState({
  eventId = 1,
  state = "ASSEMBLY",
  sequence = 1,
})
assert_eq(sendOk, false, "SendState does not send today")
assert_eq(sendWhy, "not a registered pope", "SendState names the local Pope gate")
assert_eq(#wire, 0, "SendState does not transmit")
assert_eq(sent, 0, "SendState does not SendAddonMessage")
assert_eq(#Net.queue, 0, "SendState does not enqueue")

local snapOk, snapWhy = Net:SendSnapshot({
  role = "response",
  eventId = 1,
  state = "ASSEMBLY",
  sequence = 1,
}, "LateJoin")
assert_eq(snapOk, false, "SendSnapshot does not send today")
assert_eq(snapWhy, "not a registered pope", "SendSnapshot names the local Pope gate")
assert_eq(#wire, 0, "SendSnapshot does not whisper")
assert_eq(sent, 0, "SendSnapshot does not SendAddonMessage")

local reqOk, reqWhy = Net:SendSnapshot({ role = "request" }, "Pope")
assert_eq(reqOk, false, "a snapshot request send is still Pope-gated")
assert_eq(reqWhy, "not a registered pope", "no Pope-name lookup makes a request send")
assert_eq(#wire, 0, "request send does not look up a Pope and whisper")

assert_eq(Net:SendState(), false, "SendState with no fields still fails the Pope gate")
assert_eq(Net:SendSnapshot(), false, "SendSnapshot with no fields still fails the Pope gate")
assert_eq(Runtime:Snapshot().state, "QUIET", "outbound gates do not change Runtime")

--------------------------------------------------------------------------------
-- Incompatible version: _WarnVersion + discard. No second Quiet notice. No toast.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeSkew = Runtime:Snapshot()
assert_eq(Net.Toast, nil, "Net has no toast")
assert_eq(Runtime.Toast, nil, "Runtime has no toast")
assert_eq(Snapshot.Toast, nil, "Snapshot has no toast")

local foreignStateWire = "2:STATE:1:ASSEMBLY::::1"
assert_true(Codec:Decode(foreignStateWire) ~= nil, "foreign-major STATE still decodes")
assert_eq(Codec:IsCompatible(2), false, "protocol 2 is incompatible")
local skewOk, skewWhy = guild(foreignStateWire, "Steakina")
assert_eq(skewOk, false, "incompatible STATE is discarded")
assert_eq(skewWhy, "protocol mismatch", "incompatible STATE names the mismatch")
assert_eq(Net.warnedVersion, true, "incompatible STATE is the Quiet version notice")
assert_eq(#chats, 1, "incompatible STATE chats once")
assert_unchanged(beforeSkew, Runtime:Snapshot(), "incompatible STATE does not Restore")

local foreignSnap = "2:SNAPSHOT:response:1:ASSEMBLY::::1"
local snapSkewOk, snapSkewWhy = whisper(foreignSnap, "Steakina")
assert_eq(snapSkewOk, false, "incompatible SNAPSHOT is discarded")
assert_eq(snapSkewWhy, "protocol mismatch", "incompatible SNAPSHOT names the mismatch")
assert_eq(#chats, 1, "incompatible SNAPSHOT does not chat a second notice")
assert_eq(Net:_WarnVersion(2), false, "the version notice still fires once")
assert_eq(#chats, 1, "no second Quiet notice")
assert_unchanged(beforeSkew, Runtime:Snapshot(), "incompatible SNAPSHOT does not Apply")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "version skew does not drop the live event")

reset()
local zeroOk, zeroWhy = guild("0:STATE:1:RITE:Gora::3,4:2", "Steakina")
assert_eq(zeroOk, false, "protocol 0 STATE is discarded")
assert_eq(zeroWhy, "protocol mismatch", "protocol 0 is incompatible")
assert_eq(Net.warnedVersion, true, "protocol 0 is the same Quiet notice")
assert_eq(Runtime:Snapshot().state, "QUIET", "protocol 0 does not Restore")

--------------------------------------------------------------------------------
-- Floods of valid STATE / SNAPSHOT do not Restore and still spend inbound tokens.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeFlood = Runtime:Snapshot()
local floodClock = 0
Net.clock = function() return floodClock end
local heard = 0
for _ = 1, 12 do
  if guild(assemblyWire, "Flooder") == true then heard = heard + 1 end
end
assert_eq(heard, 0, "Accept-false STATE is never applied, even inside the burst")
local _, floodWhy = guild(assemblyWire, "Flooder")
assert_eq(floodWhy, "sender is talking too fast", "STATE floods still spend inbound tokens")
assert_unchanged(beforeFlood, Runtime:Snapshot(), "flooded STATE does not Restore")

--------------------------------------------------------------------------------
-- No CreateFrame, no guild-rank Pope, no SV write, no peer SYNC on v2 paths.
--------------------------------------------------------------------------------
reset()
ChurchOfBeefDB = { sentinel = 1 }
framed = 0
guildReads = 0
guild(assemblyWire, "Steakina")
whisper(responseWire, "Steakina")
whisper(reqWire, "LateJoin")
guild(petition, "Petitioner")
Net:SendState({ eventId = 1, state = "ASSEMBLY", sequence = 1 })
Net:SendSnapshot({ role = "request" }, "Pope")
guild("1:SUGGESTION:x", "Beefina")
guild("2:STATE:1:ASSEMBLY::::1", "Steakina")
assert_eq(framed, 0, "v2 handlers never CreateFrame")
assert_eq(guildReads, 0, "v2 handlers do not read guild rank")
assert_eq(ChurchOfBeefDB.sentinel, 1, "v2 handlers do not write ChurchOfBeefDB")
assert_eq(ChurchOfBeefDB.runtime, nil, "v2 handlers do not persist the event object")
assert_eq(Net.CreateFrame, nil, "Net does not grow a CreateFrame API")

--------------------------------------------------------------------------------
-- Closed sets stay on Codec. This lane does not add opcodes or a fourth TYPE.
--------------------------------------------------------------------------------
assert_eq(Codec.TYPES.STATE, true, "STATE stays a Codec type")
assert_eq(Codec.TYPES.SNAPSHOT, true, "SNAPSHOT stays a Codec type")
assert_eq(Codec.TYPES.INPUT, true, "INPUT stays a Codec type — not a live channel")
assert_eq(Codec.TYPES.HELLO, nil, "HELLO stays on the transport")
assert_eq(type(Net.Encode), "function", "transport Encode stays for HELLO")
assert_eq(Net:Encode("HELLO", "0.1.0"), "1:HELLO:0.1.0", "HELLO is still the transport type")

reset()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
