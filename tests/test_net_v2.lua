-- BeefNet v2 wire (Phase 4 Lane B / W-D / B4-A). Isolated: Common + Runtime +
-- Codec + Snapshot + Sender + BeefNet. STATE on GUILD, SNAPSHOT on WHISPER.
-- DECREE on GUILD from a registered-Pope sender. INPUT is live for favor,
-- petition, and confession on whisper-to-Pope. GUILD INPUT stays unknown.
-- HELLO stays the transport. Accept / IsRegisteredPope are false today unless
-- this suite stubs the predicate. No #8 Pope list. No holdSeconds. No peer SYNC.
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
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Decree, nil, "isolated suite does not load Decree")
  assert_eq(COB.Confession, nil, "isolated suite does not load Confession")
end

assert_eq(Net.Prefix, "COB", "the prefix is COB")
assert_eq(Net.Channel, "GUILD", "HELLO and STATE travel on GUILD")
assert_eq(Net.PROTOCOL, 2, "protocol major is 2")
do
  local fh = io.open("addon/ChurchOfBeef/Net/BeefNet.lua", "r")
  assert_true(fh ~= nil, "BeefNet.lua is readable")
  local src = fh:read("*a")
  fh:close()
  assert_eq(src:find("EnsureCharacterByName", 1, true), nil,
    "INPUT apply does not call EnsureCharacterByName")
  assert_eq(src:find("CreateHuman", 1, true), nil, "INPUT apply does not CreateHuman")
  assert_eq(src:find("LinkCharacter", 1, true), nil, "INPUT apply does not LinkCharacter")
end
assert_eq(type(Net.SendHello), "function", "SendHello stays")
assert_eq(type(Net._WarnVersion), "function", "_WarnVersion stays")
assert_eq(type(Net.SendState), "function", "SendState exists")
assert_eq(type(Net.SendSnapshot), "function", "SendSnapshot exists")
assert_eq(type(Net.SendDecree), "function", "SendDecree exists")
assert_eq(type(Net.SendFavor), "function", "SendFavor exists")
assert_eq(type(Net.SendPetition), "function", "SendPetition exists")
assert_eq(type(Net.SendConfession), "function", "SendConfession exists")
assert_eq(type(Net.RequestSnapshot), "function", "RequestSnapshot exists")
assert_eq(type(Net.DefaultDest), "function", "DefaultDest is the shared whisper dest helper")
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
assert_eq(hello_payload("0.1.0"), "2:HELLO:0.1.0", "HELLO framing is unchanged")
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
local _, helloWhy = guild("1:HELLO:9.9.9", "Steakina")
assert_eq(helloWhy, "protocol mismatch", "a mismatched HELLO is discarded")
assert_eq(Net.warnedVersion, true, "the first mismatch is the Quiet version notice")
assert_eq(#chats, 1, "incompatible HELLO chats once")
assert_true(chats[1]:find("the Church's software has advanced", 1, true) ~= nil,
  "incompatible HELLO names the Church's software has advanced")
assert_true(chats[1]:find("update the addon", 1, true) ~= nil,
  "incompatible HELLO tells the player to update the addon")
assert_eq(Net:_WarnVersion(1), false, "the version notice fires once")
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
assert_eq(reqWire, "2:SNAPSHOT:request", "Request wire is role only")
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
-- INPUT: favor / petition / confession live on WHISPER only. GUILD INPUT stays
-- unknown. Non-Pope whisper refuses. Do not Restore. Do not paint. No inbox.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeInput = Runtime:Snapshot()
local petition = Codec:EncodeInput({ kind = "petition", characterId = 12 })
local favor = Codec:EncodeInput({ kind = "favor", characterId = 2, pick = 1 })
local confession = Codec:EncodeInput({ kind = "confession", characterId = 3, text = "free text" })
assert_eq(Codec:Decode(petition).type, "INPUT", "petition still decodes on Codec")
assert_eq(Codec:Decode(favor).pick, 1, "favor INPUT carries pick")

_, why = guild(petition, "Petitioner")
assert_eq(why, "unknown message type", "petition INPUT on GUILD is not a live channel")
_, why = whisper(petition, "Petitioner")
assert_eq(why, "not a registered pope", "petition INPUT on WHISPER to a non-Pope is discarded")
_, why = guild(confession, "Confessor")
assert_eq(why, "unknown message type", "confession INPUT on GUILD is not a live channel")
_, why = whisper(confession, "Confessor")
assert_eq(why, "not a registered pope", "confession INPUT on WHISPER to a non-Pope is discarded")
_, why = guild(favor, "Favorer")
assert_eq(why, "unknown message type", "favor INPUT on GUILD is discarded")
_, why = whisper(favor, "Favorer")
assert_eq(why, "not a registered pope", "favor INPUT on WHISPER to a non-Pope is discarded")
assert_unchanged(beforeInput, Runtime:Snapshot(), "INPUT does not Restore Runtime")
assert_eq(Net.inbox, nil, "INPUT does not invent a console queue")
assert_eq(Net.pendingInput, nil, "INPUT is not stored")
assert_eq(#wire, 0, "INPUT does not paint or fan out")
assert_eq(Sender:Accept("Petitioner", "INPUT"), true,
  "Accept INPUT may be true — favor still requires a local Pope")

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

local decOk, decWhy = Net:SendDecree({ line = "Gather at the Pit" })
assert_eq(decOk, false, "SendDecree does not send today")
assert_eq(decWhy, "not a registered pope", "SendDecree names the local Pope gate")
assert_eq(#wire, 0, "SendDecree does not transmit")
assert_eq(sent, 0, "SendDecree does not SendAddonMessage")
assert_eq(#Net.queue, 0, "SendDecree does not enqueue")

local favorSendOk, favorSendWhy = Net:SendFavor({
  kind = "favor",
  characterId = 2,
  pick = 1,
}, "Pope")
assert_eq(favorSendOk, true, "SendFavor is not Pope-gated")
assert_eq(favorSendWhy, nil, "SendFavor does not name the Pope gate")
assert_eq(#wire, 1, "SendFavor whispers once")
assert_eq(wire[1].channel, "WHISPER", "SendFavor is whisper")
assert_eq(wire[1].target, "Pope", "SendFavor uses the given target")
assert_eq(wire[1].payload, "2:INPUT:favor:2:1", "SendFavor encodes favor+pick")

local noTgt, noTgtWhy = Net:SendFavor({ kind = "favor", characterId = 2, pick = 1 })
assert_eq(noTgt, false, "SendFavor requires a whisper target")
assert_eq(noTgtWhy, "no target", "SendFavor names the missing target")

assert_eq(Runtime:Snapshot().state, "QUIET", "outbound gates do not change Runtime")

--------------------------------------------------------------------------------
-- Outbound SendPetition / SendConfession: congregation whisper. Not Pope-gated.
--------------------------------------------------------------------------------
reset()
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "local player is not a registered Pope")
assert_eq(COB.Popes, nil, "empty Popes list — SendPetition does not invent one")

local noPet, noPetWhy = Net:SendPetition({ characterId = 12 })
assert_eq(noPet, false, "SendPetition without target fails")
assert_eq(noPetWhy, "no target", "SendPetition names the missing target")
assert_eq(#wire, 0, "SendPetition without target does not whisper")
assert_eq(sent, 0, "SendPetition without target does not SendAddonMessage")
assert_eq(#Net.queue, 0, "SendPetition without target does not enqueue")

noPet, noPetWhy = Net:SendPetition({ characterId = 12 }, "")
assert_eq(noPet, false, "SendPetition empty target fails")
assert_eq(noPetWhy, "no target", "SendPetition empty target is missing")

local petSendOk, petSendWhy = Net:SendPetition({
  kind = "petition",
  characterId = 12,
  namedOpponentId = 99,
}, "Pope")
assert_eq(petSendOk, true, "SendPetition is not Pope-gated")
assert_eq(petSendWhy, nil, "SendPetition does not name the Pope gate")
assert_eq(#wire, 1, "SendPetition whispers once")
assert_eq(wire[1].channel, "WHISPER", "SendPetition is whisper")
assert_eq(wire[1].target, "Pope", "SendPetition uses the given target")
assert_eq(wire[1].payload, "2:INPUT:petition:12", "SendPetition encodes petition+id only")
assert_eq(sent, 1, "SendPetition SendAddonMessage once")
assert_eq(#Net.queue, 0, "SendPetition does not enqueue on GUILD")

local noConf, noConfWhy = Net:SendConfession({ characterId = 3, text = "free text" })
assert_eq(noConf, false, "SendConfession without target fails")
assert_eq(noConfWhy, "no target", "SendConfession names the missing target")

noConf, noConfWhy = Net:SendConfession({ characterId = 3, text = "free text" }, "")
assert_eq(noConf, false, "SendConfession empty target fails")
assert_eq(noConfWhy, "no target", "SendConfession empty target is missing")

local confSendOk, confSendWhy = Net:SendConfession({
  kind = "confession",
  characterId = 3,
  text = "free text",
}, "Pope")
assert_eq(confSendOk, true, "SendConfession is not Pope-gated")
assert_eq(confSendWhy, nil, "SendConfession does not name the Pope gate")
assert_eq(#wire, 2, "SendConfession whispers once")
assert_eq(wire[2].channel, "WHISPER", "SendConfession is whisper")
assert_eq(wire[2].target, "Pope", "SendConfession uses the given target")
assert_eq(wire[2].payload, "2:INPUT:confession:3:free text", "SendConfession encodes confession+text")

local nlOk, nlWhy = Net:SendConfession({ characterId = 3, text = "a\nb" }, "Pope")
assert_eq(nlOk, false, "SendConfession refuses a newline in the text")
assert_eq(nlWhy, "invalid text", "SendConfession names the newline refusal")
assert_eq(#wire, 2, "newline confession does not whisper")

local silentOk = Net:SendConfession({ characterId = 3 }, "Pope")
assert_eq(silentOk, true, "SendConfession text is optional")
assert_eq(wire[3].payload, "2:INPUT:confession:3", "SendConfession encodes id without text")

local stillPetBlocked, stillPetWhy = Net:SendState({
  eventId = 1,
  state = "ASSEMBLY",
  sequence = 1,
})
assert_eq(stillPetBlocked, false, "empty Popes list still blocks SendState")
assert_eq(stillPetWhy, "not a registered pope", "SendState stays Pope-gated after SendPetition")
assert_eq(#Net.queue, 0, "SendState still does not enqueue")
assert_eq(Net.LookupPope, nil, "SendPetition does not grow a Pope-name lookup")
assert_eq(Runtime:Snapshot().state, "QUIET", "SendPetition does not change Runtime")

--------------------------------------------------------------------------------
-- Outbound RequestSnapshot: congregation whisper. Not Pope-gated.
--------------------------------------------------------------------------------
reset()
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "local player is not a registered Pope")
assert_eq(COB.Popes, nil, "empty Popes list — RequestSnapshot does not invent one")

local snapAskOk, snapAskWhy = Net:RequestSnapshot()
assert_eq(snapAskOk, false, "RequestSnapshot without target fails")
assert_eq(snapAskWhy, "no target", "RequestSnapshot names the missing target")
assert_eq(#wire, 0, "RequestSnapshot without target does not whisper")
assert_eq(sent, 0, "RequestSnapshot without target does not SendAddonMessage")
assert_eq(#Net.queue, 0, "RequestSnapshot without target does not enqueue")

snapAskOk, snapAskWhy = Net:RequestSnapshot("")
assert_eq(snapAskOk, false, "RequestSnapshot empty target fails")
assert_eq(snapAskWhy, "no target", "RequestSnapshot empty target is missing")

snapAskOk, snapAskWhy = Net:RequestSnapshot("Steakina")
assert_eq(snapAskOk, true, "RequestSnapshot with a target whispers")
assert_eq(snapAskWhy, nil, "RequestSnapshot is not Pope-gated")
assert_eq(#wire, 1, "RequestSnapshot whispers once")
assert_eq(wire[1].channel, "WHISPER", "RequestSnapshot is whisper")
assert_eq(wire[1].target, "Steakina", "RequestSnapshot uses the given target")
assert_eq(wire[1].payload, Snapshot:Request(), "RequestSnapshot body is Snapshot:Request")
assert_eq(wire[1].payload, "2:SNAPSHOT:request", "RequestSnapshot encodes request role only")
assert_eq(sent, 1, "RequestSnapshot SendAddonMessage once")
assert_eq(#Net.queue, 0, "RequestSnapshot does not enqueue on GUILD")

local stillBlocked, stillWhy = Net:SendState({
  eventId = 1,
  state = "ASSEMBLY",
  sequence = 1,
})
assert_eq(stillBlocked, false, "empty Popes list still blocks SendState")
assert_eq(stillWhy, "not a registered pope", "SendState stays Pope-gated after RequestSnapshot")
assert_eq(#Net.queue, 0, "SendState still does not enqueue")

local stillDec, stillDecWhy = Net:SendDecree({ line = "Gather at the Pit" })
assert_eq(stillDec, false, "SendDecree stays Pope-gated")
assert_eq(stillDecWhy, "not a registered pope", "SendDecree names the local Pope gate")

local stillSnap, stillSnapWhy = Net:SendSnapshot({ role = "request" }, "Steakina")
assert_eq(stillSnap, false, "SendSnapshot request stays Pope-gated")
assert_eq(stillSnapWhy, "not a registered pope", "SendSnapshot is not RequestSnapshot")

assert_eq(Runtime:Snapshot().state, "QUIET", "RequestSnapshot does not change Runtime")
assert_eq(Net.LookupPope, nil, "RequestSnapshot does not grow a Pope-name lookup")

--------------------------------------------------------------------------------
-- B33-D: whitespace dest is no target. Trim before whisper. No dest on INPUT.
--------------------------------------------------------------------------------
do
  reset()
  assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "dest pins do not invent a Pope")
  assert_eq(Net.LookupPope, nil, "dest pins do not grow a Pope-name lookup")
  assert_eq(Net.FindPope, nil, "dest pins do not grow FindPope")

  local space = "   "
  local hostPad = "  Host  "
  local ok, why

  ok, why = Net:SendPetition({ characterId = 12 }, space)
  assert_eq(ok, false, "SendPetition whitespace dest fails")
  assert_eq(why, "no target", "SendPetition whitespace dest is no target")
  assert_eq(#wire, 0, "SendPetition whitespace dest does not whisper")
  assert_eq(sent, 0, "SendPetition whitespace dest does not SendAddonMessage")

  ok, why = Net:SendConfession({ characterId = 3, text = "free text" }, space)
  assert_eq(ok, false, "SendConfession whitespace dest fails")
  assert_eq(why, "no target", "SendConfession whitespace dest is no target")
  assert_eq(#wire, 0, "SendConfession whitespace dest does not whisper")
  assert_eq(sent, 0, "SendConfession whitespace dest does not SendAddonMessage")

  ok, why = Net:RequestSnapshot(space)
  assert_eq(ok, false, "RequestSnapshot whitespace dest fails")
  assert_eq(why, "no target", "RequestSnapshot whitespace dest is no target")
  assert_eq(#wire, 0, "RequestSnapshot whitespace dest does not whisper")
  assert_eq(sent, 0, "RequestSnapshot whitespace dest does not SendAddonMessage")

  ok, why = Net:_TransmitWhisper("2:SNAPSHOT:request", space)
  assert_eq(ok, false, "_TransmitWhisper whitespace dest fails")
  assert_eq(why, "no target", "_TransmitWhisper whitespace dest is no target")
  assert_eq(#wire, 0, "_TransmitWhisper whitespace dest does not whisper")
  assert_eq(sent, 0, "_TransmitWhisper whitespace dest does not SendAddonMessage")

  ok, why = Net:SendFavor({ kind = "favor", characterId = 2, pick = 1 }, space)
  assert_eq(ok, false, "SendFavor whitespace dest fails")
  assert_eq(why, "no target", "SendFavor whitespace dest is no target")
  assert_eq(#wire, 0, "SendFavor whitespace dest does not whisper")
  assert_eq(sent, 0, "SendFavor whitespace dest does not SendAddonMessage")

  ok, why = Net:SendPetition({ characterId = 12 }, " ")
  assert_eq(ok, false, "SendPetition single-space dest fails")
  assert_eq(why, "no target", "SendPetition single-space dest is no target")
  assert_eq(#wire, 0, "SendPetition single-space dest does not whisper")

  ok, why = Net:SendPetition({ characterId = 12 }, "")
  assert_eq(ok, false, "SendPetition empty dest still fails")
  assert_eq(why, "no target", "SendPetition empty dest stays no target")
  ok, why = Net:SendPetition({ characterId = 12 })
  assert_eq(ok, false, "SendPetition nil dest still fails")
  assert_eq(why, "no target", "SendPetition nil dest stays no target")
  ok, why = Net:_TransmitWhisper("2:SNAPSHOT:request", "")
  assert_eq(ok, false, "_TransmitWhisper empty dest still fails")
  assert_eq(why, "no target", "_TransmitWhisper empty dest stays no target")
  ok, why = Net:_TransmitWhisper("2:SNAPSHOT:request")
  assert_eq(ok, false, "_TransmitWhisper nil dest still fails")
  assert_eq(why, "no target", "_TransmitWhisper nil dest stays no target")
  ok, why = Net:SendFavor({ kind = "favor", characterId = 2, pick = 1 }, "")
  assert_eq(ok, false, "SendFavor empty dest still fails")
  assert_eq(why, "no target", "SendFavor empty dest stays no target")
  ok, why = Net:SendConfession({ characterId = 3 }, "")
  assert_eq(ok, false, "SendConfession empty dest still fails")
  assert_eq(why, "no target", "SendConfession empty dest stays no target")
  ok, why = Net:RequestSnapshot("")
  assert_eq(ok, false, "RequestSnapshot empty dest still fails")
  assert_eq(why, "no target", "RequestSnapshot empty dest stays no target")
  assert_eq(#wire, 0, "empty dest pins still do not whisper")
  assert_eq(sent, 0, "empty dest pins still do not SendAddonMessage")

  reset()
  ok, why = Net:SendPetition({ characterId = 12 }, hostPad)
  assert_eq(ok, true, "SendPetition padded dest sends")
  assert_eq(why, nil, "SendPetition padded dest has no refusal")
  assert_eq(#wire, 1, "SendPetition padded dest whispers once")
  assert_eq(wire[1].channel, "WHISPER", "SendPetition padded dest stays whisper")
  assert_eq(wire[1].target, "Host", "SendPetition trims dest before transmit")
  assert_eq(wire[1].payload, "2:INPUT:petition:12", "SendPetition padded dest has no dest on INPUT")

  ok, why = Net:SendConfession({ characterId = 3, text = "free text" }, hostPad)
  assert_eq(ok, true, "SendConfession padded dest sends")
  assert_eq(why, nil, "SendConfession padded dest has no refusal")
  assert_eq(wire[2].target, "Host", "SendConfession trims dest before transmit")
  assert_eq(wire[2].payload, "2:INPUT:confession:3:free text",
    "SendConfession padded dest has no dest on INPUT")

  ok, why = Net:RequestSnapshot(hostPad)
  assert_eq(ok, true, "RequestSnapshot padded dest sends")
  assert_eq(why, nil, "RequestSnapshot padded dest is not Pope-gated")
  assert_eq(wire[3].target, "Host", "RequestSnapshot trims dest before transmit")
  assert_eq(wire[3].payload, "2:SNAPSHOT:request", "RequestSnapshot padded dest body is unchanged")

  ok, why = Net:SendFavor({ kind = "favor", characterId = 2, pick = 1 }, hostPad)
  assert_eq(ok, true, "SendFavor padded dest sends")
  assert_eq(why, nil, "SendFavor padded dest has no refusal")
  assert_eq(wire[4].target, "Host", "SendFavor trims dest before transmit")
  assert_eq(wire[4].payload, "2:INPUT:favor:2:1", "SendFavor padded dest has no dest on INPUT")

  ok, why = Net:_TransmitWhisper("2:SNAPSHOT:request", hostPad)
  assert_eq(ok, true, "_TransmitWhisper padded dest sends")
  assert_eq(why, nil, "_TransmitWhisper padded dest has no refusal")
  assert_eq(wire[5].target, "Host", "_TransmitWhisper trims dest before transmit")
  assert_eq(wire[5].payload, "2:SNAPSHOT:request", "_TransmitWhisper padded dest body is unchanged")
  assert_eq(#wire, 5, "padded dest pins whisper five times")

  assert_eq(Codec.TYPES.INPUT, true, "INPUT stays a Codec type")
  assert_eq(Codec.TYPES.SNAPSHOT, true, "SNAPSHOT stays a Codec type")
  assert_eq(Codec:Decode("2:INPUT:petition:12").kind, "petition", "petition kind is unchanged")
  assert_eq(Codec:Decode("2:INPUT:favor:2:1").kind, "favor", "favor kind is unchanged")
  assert_eq(Codec:Decode("2:INPUT:confession:3:free text").kind, "confession",
    "confession kind is unchanged")
  assert_eq(Runtime:Snapshot().state, "QUIET", "dest pins do not change Runtime")
  assert_eq(Net.LookupPope, nil, "dest trim does not grow a Pope-name lookup")

  if standalone then
    assert_eq(COB.Store, nil, "dest pins do not load Store")
    assert_eq(COB.UI, nil, "dest pins do not load UI")
    assert_eq(COB.Popes, nil, "dest pins do not load a Pope list")
    assert_eq(COB.Gora, nil, "dest pins do not leave a Gora stub")
    assert_eq(COB.Confession, nil, "dest pins do not leave a Confession stub")
  end
end

--------------------------------------------------------------------------------
-- B34-D: SendSnapshot destName before encode. Pope gate stays first.
--------------------------------------------------------------------------------
do
  reset()
  assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "snapshot dest pins do not invent a Pope")
  assert_eq(Net.LookupPope, nil, "snapshot dest pins do not grow a Pope-name lookup")
  assert_eq(Net.FindPope, nil, "snapshot dest pins do not grow FindPope")

  local encodeCalls = 0
  local savedEncode = Codec.EncodeSnapshot
  Codec.EncodeSnapshot = function(self, fields)
    encodeCalls = encodeCalls + 1
    return savedEncode(self, fields)
  end

  local space = "   "
  local hostPad = "  Host  "
  local ok, why

  ok, why = Net:SendSnapshot({ role = "request" }, space)
  assert_eq(ok, false, "non-pope SendSnapshot whitespace dest fails")
  assert_eq(why, "not a registered pope", "non-pope SendSnapshot whitespace dest stays Pope-gated")
  ok, why = Net:SendSnapshot({ role = "request" }, "")
  assert_eq(ok, false, "non-pope SendSnapshot empty dest fails")
  assert_eq(why, "not a registered pope", "non-pope SendSnapshot empty dest stays Pope-gated")
  ok, why = Net:SendSnapshot({ role = "request" })
  assert_eq(ok, false, "non-pope SendSnapshot nil dest fails")
  assert_eq(why, "not a registered pope", "non-pope SendSnapshot nil dest stays Pope-gated")
  ok, why = Net:SendSnapshot({ role = "request" }, hostPad)
  assert_eq(ok, false, "non-pope SendSnapshot padded dest fails")
  assert_eq(why, "not a registered pope", "non-pope SendSnapshot padded dest stays Pope-gated")
  assert_eq(encodeCalls, 0, "non-pope SendSnapshot does not EncodeSnapshot")
  assert_eq(#wire, 0, "non-pope SendSnapshot dest pins do not whisper")
  assert_eq(sent, 0, "non-pope SendSnapshot dest pins do not SendAddonMessage")

  local savedPred = Sender.IsRegisteredPope
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "beefina"
  end
  assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), true, "stub lists the local player")
  assert_eq(Sender:IsRegisteredPope("Steakina"), false, "stub does not list a congregation name")

  reset()
  encodeCalls = 0

  ok, why = Net:SendSnapshot({ role = "request" }, space)
  assert_eq(ok, false, "SendSnapshot whitespace dest fails")
  assert_eq(why, "no target", "SendSnapshot whitespace dest is no target")
  ok, why = Net:SendSnapshot({ role = "request" }, " ")
  assert_eq(ok, false, "SendSnapshot single-space dest fails")
  assert_eq(why, "no target", "SendSnapshot single-space dest is no target")
  ok, why = Net:SendSnapshot({ role = "request" }, "")
  assert_eq(ok, false, "SendSnapshot empty dest fails")
  assert_eq(why, "no target", "SendSnapshot empty dest is no target")
  ok, why = Net:SendSnapshot({ role = "request" })
  assert_eq(ok, false, "SendSnapshot nil dest fails")
  assert_eq(why, "no target", "SendSnapshot nil dest is no target")
  assert_eq(encodeCalls, 0, "empty dest does not EncodeSnapshot")
  assert_eq(#wire, 0, "empty dest does not whisper")
  assert_eq(sent, 0, "empty dest does not SendAddonMessage")

  reset()
  encodeCalls = 0
  ok, why = Net:SendSnapshot({ role = "request" }, hostPad)
  assert_eq(ok, true, "SendSnapshot padded dest sends")
  assert_eq(why, nil, "SendSnapshot padded dest has no refusal")
  assert_eq(encodeCalls, 1, "padded dest EncodeSnapshot once")
  assert_eq(#wire, 1, "SendSnapshot padded dest whispers once")
  assert_eq(wire[1].channel, "WHISPER", "SendSnapshot padded dest stays whisper")
  assert_eq(wire[1].target, "Host", "SendSnapshot trims dest before transmit")
  assert_eq(wire[1].payload, "2:SNAPSHOT:request", "SendSnapshot has no dest on SNAPSHOT")
  assert_eq(Codec:Decode(wire[1].payload).role, "request", "padded dest SNAPSHOT role is unchanged")
  assert_eq(Codec:Decode(wire[1].payload).dest, nil, "padded dest SNAPSHOT body has no dest")

  Codec.EncodeSnapshot = savedEncode
  Sender.IsRegisteredPope = savedPred
  assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false,
    "snapshot dest stub does not leave the Pope list true")
  assert_eq(Net.LookupPope, nil, "SendSnapshot dest trim does not grow a Pope-name lookup")
  assert_eq(Runtime:Snapshot().state, "QUIET", "SendSnapshot dest pins do not change Runtime")

  if standalone then
    assert_eq(COB.Store, nil, "snapshot dest pins do not load Store")
    assert_eq(COB.UI, nil, "snapshot dest pins do not load UI")
    assert_eq(COB.Popes, nil, "snapshot dest pins do not load a Pope list")
    assert_eq(COB.Gora, nil, "snapshot dest pins do not leave a Gora stub")
    assert_eq(COB.Confession, nil, "snapshot dest pins do not leave a Confession stub")
  end
end

--------------------------------------------------------------------------------
-- B36-A: SendConfession trims optional text. Empty after trim omits.
--------------------------------------------------------------------------------
do
  reset()
  assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "confess trim pins do not invent a Pope")
  assert_eq(Net.LookupPope, nil, "confess trim pins do not grow a Pope-name lookup")
  assert_eq(Net.FindPope, nil, "confess trim pins do not grow FindPope")

  local ok, why
  ok, why = Net:SendConfession({ characterId = 3, text = "  forgive me  " }, "Pope")
  assert_eq(ok, true, "SendConfession padded text sends")
  assert_eq(why, nil, "SendConfession padded text has no refusal")
  assert_eq(#wire, 1, "SendConfession padded text whispers once")
  assert_eq(wire[1].channel, "WHISPER", "SendConfession padded text stays whisper")
  assert_eq(wire[1].target, "Pope", "SendConfession padded text dest is unchanged")
  assert_eq(wire[1].payload, "2:INPUT:confession:3:forgive me",
    "SendConfession encodes trimmed text")
  assert_eq(Codec:Decode(wire[1].payload).text, "forgive me",
    "padded confession text decodes trimmed")
  assert_eq(Codec:Decode(wire[1].payload).dest, nil, "padded confession has no dest on INPUT")
  assert_eq(Codec:Decode(wire[1].payload).kind, "confession",
    "padded confession kind is unchanged")

  ok, why = Net:SendConfession({ characterId = 3, text = "   " }, "Pope")
  assert_eq(ok, true, "SendConfession whitespace text still sends")
  assert_eq(why, nil, "SendConfession whitespace text is not a refusal")
  assert_eq(wire[2].payload, "2:INPUT:confession:3",
    "SendConfession whitespace text omits text")
  assert_eq(Codec:Decode(wire[2].payload).text, nil, "whitespace confession has no text")

  ok, why = Net:SendConfession({ characterId = 3, text = "" }, "Pope")
  assert_eq(ok, true, "SendConfession empty text still sends")
  assert_eq(why, nil, "SendConfession empty text is not a refusal")
  assert_eq(wire[3].payload, "2:INPUT:confession:3",
    "SendConfession empty text omits text")
  assert_eq(wire[3].payload, wire[2].payload, "empty text matches whitespace omit")

  ok, why = Net:SendConfession({ characterId = 3, text = "a\nb" }, "Pope")
  assert_eq(ok, false, "SendConfession newline refuse stays")
  assert_eq(why, "invalid text", "SendConfession newline stay is invalid text")
  assert_eq(#wire, 3, "newline confession still does not whisper")

  ok, why = Net:SendConfession({ characterId = 3 }, "Pope")
  assert_eq(ok, true, "SendConfession optional text stays")
  assert_eq(wire[4].payload, "2:INPUT:confession:3", "SendConfession no-text payload stays")
  assert_eq(wire[4].payload, wire[2].payload, "whitespace omit matches no-text")

  ok, why = Net:SendConfession({ characterId = 3, text = "free text" }, "   ")
  assert_eq(ok, false, "SendConfession whitespace dest still fails")
  assert_eq(why, "no target", "SendConfession whitespace dest stays no target")
  assert_eq(#wire, 4, "whitespace dest still does not whisper")

  reset()
  ok, why = Net:SendConfession({ characterId = 3, text = "free text" }, "  Host  ")
  assert_eq(ok, true, "SendConfession padded dest still sends")
  assert_eq(why, nil, "SendConfession padded dest still has no refusal")
  assert_eq(wire[1].target, "Host", "SendConfession dest trim stays")
  assert_eq(wire[1].payload, "2:INPUT:confession:3:free text",
    "SendConfession padded dest still has no dest on INPUT")
  assert_eq(Codec:Decode(wire[1].payload).dest, nil,
    "padded dest confession body has no dest")

  assert_eq(Runtime:Snapshot().state, "QUIET", "confess trim pins do not change Runtime")
  assert_eq(Net.LookupPope, nil, "confess trim does not grow a Pope-name lookup")

  if standalone then
    assert_eq(COB.Store, nil, "confess trim pins do not load Store")
    assert_eq(COB.UI, nil, "confess trim pins do not load UI")
    assert_eq(COB.Popes, nil, "confess trim pins do not load a Pope list")
    assert_eq(COB.Gora, nil, "confess trim pins do not leave a Gora stub")
    assert_eq(COB.Confession, nil, "confess trim pins do not leave a Confession stub")
  end
end

--------------------------------------------------------------------------------
-- Unstubbed inbound DECREE: IsRegisteredPope is false. Do not Set. Do not Restore.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeDecree = Runtime:Snapshot()
local decreeWire = Codec:EncodeDecree({
  line = "Gather at the Pit",
  flavor = "bring a fork",
})
assert_eq(Codec:Decode(decreeWire).type, "DECREE", "DECREE wire decodes on Codec")
assert_eq(Sender:Accept("Beefina", "DECREE"), false, "Accept DECREE is false — Net uses IsRegisteredPope")
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "Beefina is not a registered Pope today")

local decreeSets = 0
COB.Decree = {
  Set = function()
    decreeSets = decreeSets + 1
    return { line = "should not land" }
  end,
}
ok, stateWhy = guild(decreeWire, "Beefina")
assert_eq(ok, false, "unstubbed inbound DECREE is discarded")
assert_eq(stateWhy, "not accepted", "unstubbed DECREE names the Pope sender gate")
assert_eq(decreeSets, 0, "unstubbed DECREE does not Set")
assert_eq(whisper(decreeWire, "Beefina"), false, "DECREE on WHISPER is discarded")
assert_eq(decreeSets, 0, "wrong-channel DECREE does not Set")
assert_unchanged(beforeDecree, Runtime:Snapshot(), "unstubbed DECREE does not Restore")
COB.Decree = nil

--------------------------------------------------------------------------------
-- Stubbed registered Pope: SendDecree; inbound DECREE Set; favor / petition /
-- confession INPUT on WHISPER.
--------------------------------------------------------------------------------
reset()
local savedPred = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function(_, sender)
  return COB.Names.Key(sender) == "beefina"
end
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), true, "stub lists the local player")
assert_eq(Sender:IsRegisteredPope("Steakina"), false, "stub does not list a congregation name")

local sendDecOk, sendDecWhy = Net:SendDecree({
  line = "Gather at the Pit",
  flavor = "bring a fork",
})
assert_eq(sendDecOk, true, "SendDecree sends when the local player is a registered Pope")
assert_eq(sendDecWhy, nil, "SendDecree has no refusal when gated open")
assert_eq(#wire, 1, "SendDecree transmits once")
assert_eq(wire[1].channel, "GUILD", "SendDecree stays on GUILD")
assert_eq(wire[1].payload, decreeWire, "SendDecree encodes line and flavor")

local sendStateOk = Net:SendState({
  eventId = 1,
  state = "ASSEMBLY",
  sequence = 1,
})
assert_eq(sendStateOk, true, "SendState sends when the local player is a registered Pope")

local badLine, badLineWhy = Net:SendDecree({ line = "a\nb" })
assert_eq(badLine, false, "SendDecree refuses a newline in the line")
assert_eq(badLineWhy, "invalid line", "SendDecree names the codec refusal")

reset()
Sender.IsRegisteredPope = function(_, sender)
  return COB.Names.Key(sender) == "beefina"
end
Runtime:StartEvent()
local liveDecree = Runtime:Snapshot()
decreeSets = {}
COB.Decree = {
  Set = function(_, fields)
    decreeSets[#decreeSets + 1] = { line = fields.line, flavor = fields.flavor }
    return { line = fields.line, flavor = fields.flavor }
  end,
}
ok, stateWhy = guild(decreeWire, "Beefina")
assert_eq(ok, true, "inbound DECREE from the stubbed Pope is accepted")
assert_eq(#decreeSets, 1, "inbound DECREE from the stubbed Pope calls Decree:Set")
assert_eq(decreeSets[1].line, "Gather at the Pit", "Decree:Set receives the line")
assert_eq(decreeSets[1].flavor, "bring a fork", "Decree:Set receives the flavor")
assert_unchanged(liveDecree, Runtime:Snapshot(), "accepted DECREE does not Restore Runtime")

ok, stateWhy = guild(decreeWire, "Steakina")
assert_eq(ok, false, "inbound DECREE from a congregation name is discarded")
assert_eq(stateWhy, "not accepted", "congregation DECREE names the Pope sender gate")
assert_eq(#decreeSets, 1, "congregation DECREE does not Set")

assert_eq(whisper(decreeWire, "Beefina"), false, "DECREE on WHISPER is still discarded")
assert_eq(#decreeSets, 1, "whisper DECREE does not Set")
assert_eq(#wire, 0, "inbound DECREE does not fan out")
COB.Decree = nil

reset()
Sender.IsRegisteredPope = function(_, sender)
  return COB.Names.Key(sender) == "beefina"
end
Runtime:StartEvent()
local liveFavor = Runtime:Snapshot()
local favorCalls = {}
COB.Gora = {
  RecordFavorFromSender = function(_, sender, pick)
    favorCalls[#favorCalls + 1] = { sender = sender, pick = pick }
    return true
  end,
}
ok, stateWhy = whisper(favor, "Petitioner")
assert_eq(ok, true, "favor INPUT on WHISPER to a Pope client is accepted")
assert_eq(#favorCalls, 1, "Pope-side favor calls RecordFavorFromSender")
assert_eq(favorCalls[1].sender, "Petitioner", "RecordFavorFromSender receives the server sender")
assert_eq(COB.Names.Key(favorCalls[1].sender), "petitioner", "favor apply keys by Names.Key(sender)")
assert_eq(favorCalls[1].pick, 1, "RecordFavorFromSender receives pick")
assert_unchanged(liveFavor, Runtime:Snapshot(), "favor INPUT does not Restore Runtime")
assert_eq(Net.inbox, nil, "favor INPUT does not invent a console queue")
assert_eq(#wire, 0, "favor INPUT does not fan out")

ok, stateWhy = guild(favor, "Petitioner")
assert_eq(ok, false, "favor INPUT on GUILD is still discarded on a Pope client")
assert_eq(stateWhy, "unknown message type", "favor on GUILD stays unknown")
assert_eq(#favorCalls, 1, "favor on GUILD does not RecordFavorFromSender")

COB.Gora.RecordFavorFromSender = function()
  return nil, "no sanctioned gora"
end
ok, stateWhy = whisper(favor, "Petitioner")
assert_eq(ok, false, "RecordFavor error does not invent a queue")
assert_eq(stateWhy, "no sanctioned gora", "RecordFavor error is returned")
assert_eq(Net.inbox, nil, "RecordFavor error does not invent an inbox")
assert_eq(Net.pendingInput, nil, "RecordFavor error is not stored")
assert_eq(#wire, 0, "RecordFavor error does not fan out")
assert_unchanged(liveFavor, Runtime:Snapshot(), "RecordFavor error does not Restore")

COB.Gora = nil

reset()
Sender.IsRegisteredPope = function(_, sender)
  return COB.Names.Key(sender) == "beefina"
end
Runtime:StartEvent()
local livePetition = Runtime:Snapshot()
local petitionCalls = {}
COB.Gora = {
  PetitionFromSender = function(_, sender, namedOpponentId)
    petitionCalls[#petitionCalls + 1] = {
      sender = sender,
      namedOpponentId = namedOpponentId,
    }
    return true
  end,
}
local confessionCalls = {}
COB.Confession = {
  ReceiveFromSender = function(_, sender, text)
    confessionCalls[#confessionCalls + 1] = { sender = sender, text = text }
    return true
  end,
}
ok, stateWhy = whisper(petition, "Petitioner")
assert_eq(ok, true, "petition INPUT on WHISPER to a Pope client is accepted")
assert_eq(#petitionCalls, 1, "Pope-side petition calls Gora:PetitionFromSender")
assert_eq(petitionCalls[1].sender, "Petitioner", "PetitionFromSender receives the server sender")
assert_eq(COB.Names.Key(petitionCalls[1].sender), "petitioner",
  "petition apply keys by Names.Key(sender)")
assert_eq(petitionCalls[1].namedOpponentId, nil, "Petition does not pass a named opponent")
assert_unchanged(livePetition, Runtime:Snapshot(), "petition INPUT does not Restore Runtime")
assert_eq(Net.inbox, nil, "petition INPUT does not invent a console queue")
assert_eq(#wire, 0, "petition INPUT does not fan out")

ok, stateWhy = whisper(confession, "Petitioner")
assert_eq(ok, true, "confession INPUT on WHISPER to a Pope client is accepted")
assert_eq(#confessionCalls, 1, "Pope-side confession calls Confession:ReceiveFromSender")
assert_eq(confessionCalls[1].sender, "Petitioner", "ReceiveFromSender receives the server sender")
assert_eq(COB.Names.Key(confessionCalls[1].sender), "petitioner",
  "confession apply keys by Names.Key(sender)")
assert_eq(confessionCalls[1].text, "free text", "ReceiveFromSender receives text")
assert_unchanged(livePetition, Runtime:Snapshot(), "confession INPUT does not Restore Runtime")
assert_eq(Net.inbox, nil, "confession INPUT does not invent a console queue")
assert_eq(#wire, 0, "confession INPUT does not fan out")

ok, stateWhy = guild(petition, "Petitioner")
assert_eq(ok, false, "petition INPUT on GUILD is still discarded on a Pope client")
assert_eq(stateWhy, "unknown message type", "petition on GUILD stays unknown")
assert_eq(#petitionCalls, 1, "petition on GUILD does not Petition")

ok, stateWhy = guild(confession, "Petitioner")
assert_eq(ok, false, "confession INPUT on GUILD is still discarded on a Pope client")
assert_eq(stateWhy, "unknown message type", "confession on GUILD stays unknown")
assert_eq(#confessionCalls, 1, "confession on GUILD does not Receive")

COB.Gora = nil
COB.Confession = nil

reset()
Sender.IsRegisteredPope = function(_, sender)
  return COB.Names.Key(sender) == "beefina"
end
Runtime:StartEvent()
local liveInputErr = Runtime:Snapshot()
COB.Gora = {
  PetitionFromSender = function()
    return nil, "no event"
  end,
}
ok, stateWhy = whisper(confession, "Petitioner")
assert_eq(ok, false, "missing Confession module fail-closes")
assert_eq(stateWhy, nil, "missing Confession does not invent a queue")
assert_eq(Net.inbox, nil, "missing Confession does not invent an inbox")

ok, stateWhy = whisper(petition, "Petitioner")
assert_eq(ok, false, "Petition error does not invent a queue")
assert_eq(stateWhy, "no event", "Petition error is returned")
assert_eq(Net.inbox, nil, "Petition error does not invent an inbox")
assert_eq(Net.pendingInput, nil, "Petition error is not stored")
assert_eq(#wire, 0, "Petition error does not fan out")
assert_unchanged(liveInputErr, Runtime:Snapshot(), "Petition error does not Restore")

COB.Gora = nil
COB.Confession = nil
Sender.IsRegisteredPope = savedPred
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false,
  "wrapping the predicate in-test does not stub the list true")
assert_eq(COB.Popes, nil, "still no Pope list")

--------------------------------------------------------------------------------
-- B17-B: petition may name an opponent. Isolate: stub Store.Snapshot, never dofile Store.
--------------------------------------------------------------------------------
do
  local savedPope = Sender.IsRegisteredPope
  reset()
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "beefina"
  end

  local namedOk, namedWhy = Net:SendPetition({
    characterId = 12,
    opponent = "Chuckroast",
  }, "Host")
  assert_eq(namedOk, true, "SendPetition with opponent is not Pope-gated")
  assert_eq(namedWhy, nil, "SendPetition with opponent does not name the Pope gate")
  assert_eq(#wire, 1, "SendPetition with opponent whispers once")
  local namedFrame = wire[1] or {}
  assert_eq(namedFrame.channel, "WHISPER", "SendPetition with opponent is whisper")
  assert_eq(namedFrame.target, "Host", "SendPetition with opponent uses the given target")
  assert_eq(namedFrame.payload, "2:INPUT:petition:12:Chuckroast",
    "SendPetition encodes petition+id+opponent name")

  reset()
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "beefina"
  end
  local idLeakOk = Net:SendPetition({
    characterId = 12,
    opponent = "Chuckroast",
    namedOpponentId = 99,
  }, "Host")
  assert_eq(idLeakOk, true, "SendPetition still sends when namedOpponentId is also set")
  local leakFrame = wire[1] or {}
  assert_eq(leakFrame.payload, "2:INPUT:petition:12:Chuckroast",
    "SendPetition does not copy namedOpponentId onto the wire")

  local namedCalls = {}
  COB.Gora = {
    PetitionFromSender = function(_, sender, namedOpponentId)
      namedCalls[#namedCalls + 1] = {
        sender = sender,
        namedOpponentId = namedOpponentId,
      }
      return true
    end,
  }
  COB.Store = {
    Snapshot = function()
      return { characters = { { id = 7, name = "Chuckroast" } } }
    end,
  }
  local namedWire = "2:INPUT:petition:12:Chuckroast"
  local hitOk, hitWhy = whisper(namedWire, "Petitioner")
  assert_eq(hitOk, true, "named-opponent petition on WHISPER to a Pope client is accepted")
  assert_eq(hitWhy, nil, "resolved opponent has no refusal")
  assert_eq(hitWhy ~= "unknown opponent", true, "known opponent is not an unknown-opponent refuse")
  assert_eq(#namedCalls, 1, "resolved opponent calls Gora:PetitionFromSender")
  local hit = namedCalls[1] or {}
  assert_eq(hit.sender, "Petitioner", "resolved PetitionFromSender receives the server sender")
  assert_eq(COB.Names.Key(hit.sender), "petitioner", "resolved apply ignores payload characterId")
  assert_eq(hit.namedOpponentId, 7, "resolved PetitionFromSender receives namedOpponentId")

  local beforeNil = #namedCalls
  COB.Store = nil
  local nilOk, nilWhy = whisper(namedWire, "Petitioner")
  assert_eq(nilOk, true, "named-opponent petition without Store still records the ask")
  assert_eq(nilWhy, nil, "missing Store does not return unknown opponent")
  assert_eq(#namedCalls, beforeNil + 1, "missing Store still calls PetitionFromSender")
  assert_eq(namedCalls[#namedCalls].namedOpponentId, nil, "missing Store ignores the opponent")
  assert_eq(namedCalls[#namedCalls].sender, "Petitioner", "missing Store still keys by sender")

  COB.Store = {
    Snapshot = function()
      return { characters = {} }
    end,
  }
  local beforeEmpty = #namedCalls
  local emptyOk, emptyWhy = whisper(namedWire, "Petitioner")
  assert_eq(emptyOk, true, "named-opponent petition with empty characters still records the ask")
  assert_eq(emptyWhy, nil, "empty characters does not return unknown opponent")
  assert_eq(#namedCalls, beforeEmpty + 1, "empty characters still calls PetitionFromSender")
  assert_eq(namedCalls[#namedCalls].namedOpponentId, nil, "empty characters ignores the opponent")

  local beforeGuild = #namedCalls
  local guildOk, guildWhy = guild(namedWire, "Petitioner")
  assert_eq(guildOk, false, "named-opponent petition on GUILD is still discarded")
  assert_eq(guildWhy, "unknown message type", "named-opponent petition on GUILD stays unknown")
  assert_eq(#namedCalls, beforeGuild, "GUILD named-opponent petition does not Petition")

  COB.Gora = nil
  COB.Store = nil
  Sender.IsRegisteredPope = savedPope
  if standalone then
    assert_eq(COB.Store, nil, "opponent pins do not load Store")
    assert_eq(COB.Gora, nil, "opponent pins do not leave a Gora stub")
  end
end

--------------------------------------------------------------------------------
-- Incompatible version: _WarnVersion + discard + Quiet drop. No second notice. No toast.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeSkew = Runtime:Snapshot()
assert_eq(beforeSkew.state, "ASSEMBLY", "skew starts from a live event")
assert_eq(Net.Toast, nil, "Net has no toast")
assert_eq(Runtime.Toast, nil, "Runtime has no toast")
assert_eq(Snapshot.Toast, nil, "Snapshot has no toast")

local foreignStateWire = "1:STATE:1:ASSEMBLY::::1"
assert_true(Codec:Decode(foreignStateWire) ~= nil, "foreign-major STATE still decodes")
assert_eq(Codec:IsCompatible(1), false, "protocol 1 is incompatible")
local skewOk, skewWhy = guild(foreignStateWire, "Steakina")
assert_eq(skewOk, false, "incompatible STATE is discarded")
assert_eq(skewWhy, "protocol mismatch", "incompatible STATE names the mismatch")
assert_eq(Net.warnedVersion, true, "incompatible STATE is the Quiet version notice")
assert_eq(#chats, 1, "incompatible STATE chats once")
assert_true(chats[1]:find("the Church's software has advanced", 1, true) ~= nil,
  "incompatible STATE names the Church's software has advanced")
assert_true(chats[1]:find("update the addon", 1, true) ~= nil,
  "incompatible STATE tells the player to update the addon")
local afterStateSkew = Runtime:Snapshot()
assert_eq(afterStateSkew.state, "QUIET", "version skew drops the live event")
assert_eq(afterStateSkew.eventId, nil, "incompatible STATE does not Restore the foreign event")
assert_eq(afterStateSkew.riteType, nil, "incompatible STATE drops rite chrome")
assert_eq(afterStateSkew.sequence, 0, "incompatible STATE Restores clean QUIET")

local foreignSnap = "1:SNAPSHOT:response:1:ASSEMBLY::::1"
local snapSkewOk, snapSkewWhy = whisper(foreignSnap, "Steakina")
assert_eq(snapSkewOk, false, "incompatible SNAPSHOT is discarded")
assert_eq(snapSkewWhy, "protocol mismatch", "incompatible SNAPSHOT names the mismatch")
assert_eq(#chats, 1, "incompatible SNAPSHOT does not chat a second notice")
assert_eq(Net:_WarnVersion(1), false, "the version notice still fires once")
assert_eq(#chats, 1, "no second Quiet notice")
local afterSnapSkew = Runtime:Snapshot()
assert_eq(afterSnapSkew.state, "QUIET", "incompatible SNAPSHOT stays Quiet")
assert_eq(afterSnapSkew.eventId, nil, "incompatible SNAPSHOT does not Apply")

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
guild("1:STATE:1:ASSEMBLY::::1", "Steakina")
assert_eq(framed, 0, "v2 handlers never CreateFrame")
assert_eq(guildReads, 0, "v2 handlers do not read guild rank")
assert_eq(ChurchOfBeefDB.sentinel, 1, "v2 handlers do not write ChurchOfBeefDB")
assert_eq(ChurchOfBeefDB.runtime, nil, "v2 handlers do not persist the event object")
assert_eq(Net.CreateFrame, nil, "Net does not grow a CreateFrame API")

--------------------------------------------------------------------------------
-- Closed sets stay on Codec. This lane does not add HELLO types or a fifth TYPE.
--------------------------------------------------------------------------------
assert_eq(Codec.TYPES.STATE, true, "STATE stays a Codec type")
assert_eq(Codec.TYPES.SNAPSHOT, true, "SNAPSHOT stays a Codec type")
assert_eq(Codec.TYPES.INPUT, true, "INPUT stays a Codec type")
assert_eq(Codec.TYPES.DECREE, true, "DECREE is a Codec type")
assert_eq(Codec.TYPES.HELLO, nil, "HELLO stays on the transport")
assert_eq(type(Net.Encode), "function", "transport Encode stays for HELLO")
assert_eq(Net:Encode("HELLO", "0.1.0"), "2:HELLO:0.1.0", "HELLO is still the transport type")

--------------------------------------------------------------------------------
-- Lane W: default whisper destination. Explicit target wins; else the last
-- accepted STATE sender; else the first listed Pope; else refuse. The destName
-- trim applies to whichever source wins. A self dest is legal and not skipped.
--------------------------------------------------------------------------------
do
  reset()
  assert_eq(Net._lastStateSender, nil, "no STATE sender is remembered yet")
  assert_eq(COB.Popes, nil, "no Pope list is loaded in this suite")

  local ok, why

  ok, why = Net:SendPetition({ characterId = 12 })
  assert_eq(ok, false, "SendPetition with no default anywhere still refuses")
  assert_eq(why, "no target", "SendPetition with no default anywhere names no target")
  assert_eq(#wire, 0, "no default anywhere does not whisper")
  assert_eq(sent, 0, "no default anywhere does not SendAddonMessage")

  COB.Popes = { List = { "Popeonius" } }
  assert_eq(Net:DefaultDest(), "Popeonius", "DefaultDest falls back to the listed Pope")
  ok, why = Net:SendPetition({ characterId = 12 })
  assert_eq(ok, true, "SendPetition falls back to the listed Pope")
  assert_eq(why, nil, "listed-Pope Petition has no refusal")
  assert_eq(#wire, 1, "listed-Pope Petition whispers once")
  assert_eq(wire[1].channel, "WHISPER", "listed-Pope Petition stays whisper")
  assert_eq(wire[1].target, "Popeonius", "listed-Pope Petition dest is the list head")
  assert_eq(wire[1].payload, "2:INPUT:petition:12", "listed-Pope Petition body is unchanged")

  ok, why = Net:SendFavor({ characterId = 2, pick = 1 })
  assert_eq(ok, true, "SendFavor falls back to the listed Pope")
  assert_eq(why, nil, "listed-Pope SendFavor has no refusal")
  assert_eq(wire[2].target, "Popeonius", "listed-Pope SendFavor dest is the list head")
  assert_eq(wire[2].payload, "2:INPUT:favor:2:1", "listed-Pope SendFavor body is unchanged")

  ok, why = Net:SendConfession({ characterId = 3, text = "free text" })
  assert_eq(ok, true, "SendConfession falls back to the listed Pope")
  assert_eq(wire[3].target, "Popeonius", "listed-Pope SendConfession dest is the list head")
  assert_eq(wire[3].payload, "2:INPUT:confession:3:free text",
    "listed-Pope SendConfession body is unchanged")

  ok, why = Net:RequestSnapshot()
  assert_eq(ok, true, "RequestSnapshot falls back to the listed Pope")
  assert_eq(why, nil, "listed-Pope RequestSnapshot has no refusal")
  assert_eq(wire[4].target, "Popeonius", "listed-Pope RequestSnapshot dest is the list head")
  assert_eq(wire[4].payload, "2:SNAPSHOT:request", "listed-Pope RequestSnapshot body is unchanged")

  Net._lastStateSender = "Steakina"
  assert_eq(Net:DefaultDest(), "Steakina",
    "DefaultDest prefers the remembered STATE sender over List[1]")
  ok, why = Net:SendPetition({ characterId = 12 })
  assert_eq(ok, true, "SendPetition prefers the remembered STATE sender")
  assert_eq(wire[5].target, "Steakina", "remembered STATE sender beats the listed Pope")
  assert_eq(wire[5].target, Net:DefaultDest(),
    "SendPetition dest matches DefaultDest when no explicit target")
  ok, why = Net:RequestSnapshot()
  assert_eq(ok, true, "RequestSnapshot prefers the remembered STATE sender")
  assert_eq(wire[6].target, "Steakina", "remembered STATE sender beats the list for snapshots")

  ok, why = Net:SendPetition({ characterId = 12 }, "Host")
  assert_eq(ok, true, "an explicit target always wins")
  assert_eq(wire[7].target, "Host", "explicit target beats sender and list")
  ok, why = Net:SendFavor({ characterId = 2, pick = 1 }, "  Host  ")
  assert_eq(ok, true, "a padded explicit target always wins")
  assert_eq(wire[8].target, "Host", "explicit target trim stays")

  Net._lastStateSender = "  Steakina  "
  ok, why = Net:SendPetition({ characterId = 12 })
  assert_eq(ok, true, "a padded remembered sender still resolves")
  assert_eq(wire[9].target, "Steakina", "the remembered sender is destName-trimmed")

  COB.Popes = { List = { "  Popeonius  " } }
  Net._lastStateSender = nil
  ok, why = Net:SendPetition({ characterId = 12 })
  assert_eq(ok, true, "a padded listed Pope still resolves")
  assert_eq(wire[10].target, "Popeonius", "the listed Pope is destName-trimmed")

  Net._lastStateSender = "Beefina"
  ok, why = Net:SendPetition({ characterId = 12 })
  assert_eq(ok, true, "a self dest is legal and not skipped")
  assert_eq(wire[11].target, "Beefina", "self-whisper resolves like any other dest")

  Net._lastStateSender = nil
  COB.Popes = { List = {} }
  ok, why = Net:SendPetition({ characterId = 12 })
  assert_eq(ok, false, "an empty Pope list refuses")
  assert_eq(why, "no target", "an empty Pope list names no target")

  COB.Popes = { List = { "" } }
  ok, why = Net:SendFavor({ characterId = 2, pick = 1 })
  assert_eq(ok, false, "an empty-string Pope refuses")
  assert_eq(why, "no target", "an empty-string Pope names no target")

  COB.Popes = { List = { "   " } }
  ok, why = Net:RequestSnapshot()
  assert_eq(ok, false, "a whitespace Pope refuses")
  assert_eq(why, "no target", "a whitespace Pope names no target")

  COB.Popes = {}
  ok, why = Net:SendConfession({ characterId = 3 })
  assert_eq(ok, false, "a Pope table without a List refuses")
  assert_eq(why, "no target", "a Pope table without a List names no target")

  COB.Popes = nil
  assert_eq(#wire, 11, "refused defaults do not whisper")
  assert_eq(Runtime:Snapshot().state, "QUIET", "default-dest pins do not change Runtime")
  assert_eq(Net.LookupPope, nil, "default dest does not grow a Pope-name lookup")
  assert_eq(Net.FindPope, nil, "default dest does not grow FindPope")
end

--------------------------------------------------------------------------------
-- Lane W: _lastStateSender is set only when an inbound STATE passes sender
-- auth. Rejected senders and accepted SNAPSHOT / DECREE / INPUT never set it.
--------------------------------------------------------------------------------
do
  reset()
  local savedAccept = Sender.Accept
  local savedPred = Sender.IsRegisteredPope

  assert_eq(Sender:Accept("Steakina", "STATE"), false, "unstubbed Accept STATE stays false")
  local _, rejectedWhy = guild(state_wire({
    eventId = 4,
    state = "ASSEMBLY",
    sequence = 1,
  }), "Steakina")
  assert_eq(rejectedWhy, "not accepted", "rejected STATE still names the Accept gate")
  assert_eq(Net._lastStateSender, nil, "rejected STATE does not remember the sender")

  Sender.Accept = function() return true end
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "beefina"
  end

  Runtime:StartEvent()
  local snapWire = Snapshot:BuildResponse()
  assert_true(snapWire ~= nil, "a live event builds a SNAPSHOT response")
  assert_eq(whisper(snapWire, "Steakina"), true, "accepted SNAPSHOT response applies")
  assert_eq(Net._lastStateSender, nil, "accepted SNAPSHOT does not remember the sender")

  local decreeSets = 0
  COB.Decree = {
    Set = function()
      decreeSets = decreeSets + 1
      return { line = "x" }
    end,
  }
  assert_eq(guild(Codec:EncodeDecree({ line = "Gather at the Pit" }), "Beefina"), true,
    "accepted DECREE sets")
  assert_eq(decreeSets, 1, "accepted DECREE reached Decree:Set")
  assert_eq(Net._lastStateSender, nil, "accepted DECREE does not remember the sender")

  COB.Gora = {
    RecordFavorFromSender = function() return true end,
  }
  assert_eq(whisper(Codec:EncodeInput({ kind = "favor", characterId = 2, pick = 1 }), "Petitioner"), true,
    "accepted favor INPUT lands")
  assert_eq(Net._lastStateSender, nil, "accepted INPUT does not remember the sender")

  assert_eq(guild(state_wire({
    eventId = 5,
    state = "ASSEMBLY",
    sequence = 2,
  }), "Steakina"), true, "accepted STATE restores")
  assert_eq(Net._lastStateSender, "Steakina", "accepted STATE remembers the raw sender")

  assert_eq(guild(state_wire({
    eventId = 5,
    state = "ASSEMBLY",
    sequence = 3,
  }), "Porkina"), true, "a second accepted STATE restores")
  assert_eq(Net._lastStateSender, "Porkina", "the newest accepted STATE sender wins")

  assert_eq(whisper(snapWire, "Steakina"), true, "another accepted SNAPSHOT applies")
  assert_eq(Net._lastStateSender, "Porkina", "SNAPSHOT does not overwrite the sender")
  assert_eq(guild(Codec:EncodeDecree({ line = "Gather at the Pit" }), "Beefina"), true,
    "another accepted DECREE sets")
  assert_eq(Net._lastStateSender, "Porkina", "DECREE does not overwrite the sender")
  assert_eq(whisper(Codec:EncodeInput({ kind = "favor", characterId = 2, pick = 1 }), "Petitioner"), true,
    "another accepted INPUT lands")
  assert_eq(Net._lastStateSender, "Porkina", "INPUT does not overwrite the sender")

  Net._lastStateSender = "Steakina"
  reset()
  assert_eq(Net._lastStateSender, nil, "ResetForTests forgets the remembered STATE sender")

  COB.Decree = nil
  COB.Gora = nil
  Sender.Accept = savedAccept
  Sender.IsRegisteredPope = savedPred
  assert_eq(Sender:Accept("Steakina", "STATE"), false, "Accept stub is restored")
  assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "Pope stub is restored")
end

--------------------------------------------------------------------------------
-- Lane W: COB._OnPeerHello fires (pcall'd) only on a compatible, non-self
-- HELLO. Absent function, self-HELLO, and version-mismatch paths never fire
-- and never error.
--------------------------------------------------------------------------------
do
  reset()
  assert_eq(COB._OnPeerHello, nil, "no peer-HELLO callback outside the bootstrap")

  local helloCalls = {}
  COB._OnPeerHello = function(sender)
    helloCalls[#helloCalls + 1] = sender
  end

  assert_eq(guild(hello_payload("0.1.0"), "Steakina"), true, "compatible HELLO is still accepted")
  assert_eq(#helloCalls, 1, "compatible non-self HELLO fires the callback")
  assert_eq(helloCalls[1], "Steakina", "the callback receives the raw sender")
  assert_eq(Net:PeerCount(), 1, "the peer record still seats")

  assert_eq(guild(hello_payload("0.1.0"), "Beefina"), false, "self HELLO is still not a peer")
  assert_eq(#helloCalls, 1, "self HELLO does not fire the callback")

  local _, mismatchWhy = guild("1:HELLO:9.9.9", "Porkina")
  assert_eq(mismatchWhy, "protocol mismatch", "mismatched HELLO is still discarded")
  assert_eq(#helloCalls, 1, "mismatched HELLO does not fire the callback")

  COB._OnPeerHello = function()
    error("boom")
  end
  assert_eq(guild(hello_payload("0.1.0"), "Chuckina"), true, "a throwing callback is swallowed")
  assert_eq(Net.peers.chuckina, "0.1.0", "a throwing callback still seats the peer")

  COB._OnPeerHello = nil
  assert_eq(guild(hello_payload("0.1.0"), "Ribeye"), true, "a missing callback is a no-op")
  assert_eq(Net.peers.ribeye, "0.1.0", "a missing callback still seats the peer")

  COB._OnPeerHello = nil
end

--------------------------------------------------------------------------------
-- Latest-wins favor overlay (Option C). Accept stub + favor spy on the
-- existing if-ok glue: equal sequence still paints; older does not overlay.
--------------------------------------------------------------------------------
do
  reset()
  local savedAccept = Sender.Accept
  Sender.Accept = function() return true end

  local favorSpy = {}
  local origHandle = Net._HandleState
  Net._HandleState = function(self, decoded, channel, sender)
    local ok, err = origHandle(self, decoded, channel, sender)
    if ok then
      favorSpy[#favorSpy + 1] = decoded and decoded.favor or nil
    end
    return ok, err
  end

  local greaterWire, greaterErr = Codec:EncodeState({
    eventId = 1,
    state = "RITE",
    riteType = "Gora",
    subjects = { fighters = { 8, 9 } },
    sequence = 2,
    favor = { a = 1, b = 0 },
  })
  assert_true(greaterWire ~= nil, "greater STATE with favor encodes")
  assert_eq(greaterErr, nil, "greater STATE encode has no error")
  assert_eq(guild(greaterWire, "Steakina"), true, "greater sequence applies ceremony")
  assert_eq(Runtime:Snapshot().state, "RITE", "greater sequence lands RITE")
  assert_eq(Runtime:Snapshot().sequence, 2, "greater sequence lands sequence")
  assert_eq(Runtime:Snapshot().subjects.fighters[1], 8, "greater sequence lands fighter A")
  assert_eq(Runtime:Snapshot().favor, nil, "Restore does not keep favor")
  assert_eq(#favorSpy, 1, "greater sequence overlays favor")
  assert_eq(favorSpy[1] and favorSpy[1].a, 1, "greater sequence favor a")
  assert_eq(favorSpy[1] and favorSpy[1].b, 0, "greater sequence favor b")

  favorSpy = {}
  local equalWire, equalErr = Codec:EncodeState({
    eventId = 1,
    state = "RITE",
    riteType = "Gora",
    subjects = { fighters = { 1, 2 } },
    sequence = 2,
    favor = { a = 4, b = 3 },
  })
  assert_true(equalWire ~= nil, "equal STATE with favor encodes")
  assert_eq(equalErr, nil, "equal STATE encode has no error")
  assert_eq(guild(equalWire, "Steakina"), true, "equal sequence still accepts")
  assert_eq(Runtime:Snapshot().subjects.fighters[1], 8, "equal sequence does not replace fighters")
  assert_eq(Runtime:Snapshot().subjects.fighters[2], 9, "equal sequence keeps later fighters")
  assert_eq(Runtime:Snapshot().sequence, 2, "equal sequence does not move ceremony")
  assert_eq(#favorSpy, 1, "equal sequence still paints favor")
  assert_eq(favorSpy[1] and favorSpy[1].a, 4, "equal sequence overlays later favor")
  assert_eq(favorSpy[1] and favorSpy[1].b, 3, "equal sequence overlays later favor b")

  favorSpy = {}
  local olderWire, olderEncErr = Codec:EncodeState({
    eventId = 1,
    state = "ASSEMBLY",
    subjects = { fighters = { 8, 9 } },
    sequence = 1,
    favor = { a = 9, b = 9 },
  })
  assert_true(olderWire ~= nil, "older STATE with favor encodes")
  assert_eq(olderEncErr, nil, "older STATE encode has no error")
  local olderOk, olderWhy = guild(olderWire, "Steakina")
  assert_eq(olderOk, nil, "older sequence does not apply")
  assert_eq(olderWhy, "stale sequence", "older sequence is not-ok")
  assert_eq(Runtime:Snapshot().state, "RITE", "older sequence leaves later ceremony")
  assert_eq(Runtime:Snapshot().sequence, 2, "older sequence does not rewind")
  assert_eq(#favorSpy, 0, "older sequence does not overlay favor")

  favorSpy = {}
  local otherWire, otherErr = Codec:EncodeState({
    eventId = 2,
    state = "ASSEMBLY",
    subjects = { fighters = { 3, 4 } },
    sequence = 1,
    favor = { a = 2, b = 2 },
  })
  assert_true(otherWire ~= nil, "different-event STATE encodes")
  assert_eq(otherErr, nil, "different-event STATE encode has no error")
  assert_eq(guild(otherWire, "Steakina"), true, "different eventId applies")
  assert_eq(Runtime:Snapshot().eventId, 2, "different eventId lands")
  assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "different eventId applies ceremony")
  assert_eq(Runtime:Snapshot().sequence, 1, "new event keeps its own sequence")
  assert_eq(#favorSpy, 1, "different eventId overlays favor")
  assert_eq(favorSpy[1] and favorSpy[1].a, 2, "different eventId favor a")

  Net._HandleState = origHandle
  Sender.Accept = savedAccept
end

reset()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
