-- BeefNet: the wire decides before anyone else is asked. Payload shape, HELLO
-- presence, the retired-message discard, inbound pacing per sender, and the
-- burst-then-one-per-second outbound throttle.
-- Whether a real TBC client actually delivers CHAT_MSG_ADDON still needs the game.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Net/BeefNet.lua")

local COB = ChurchOfBeef
local N = COB.Net

stub.playerName = "Beefina"
COB.VERSION = COB.VERSION or "0.1.0"

local function reset()
  N:ResetForTests()
  stub.timers = {}
  stub.addonMessages = {}
  stub.oversizeMessages = {}
end

local function helloPayload(version)
  return N:Encode("HELLO", version or "0.1.0")
end

local function deliver(payload, sender)
  return N:OnAddonMessage(N.Prefix, payload, N.Channel, sender or "Steakina")
end

reset()

--------------------------------------------------------------------------------
-- Wire format: VERSION:TYPE:fields...
--------------------------------------------------------------------------------
assert_eq(N.Prefix, "COB", "the prefix is COB")
assert_eq(N.Channel, "GUILD", "addon messages travel on GUILD, never PARTY")
assert_eq(N.PROTOCOL, 2, "this cut speaks protocol 2")

local encoded = helloPayload("0.1.0")
assert_eq(encoded, "2:HELLO:0.1.0", "payload is version, type, then fields")
assert_true(#encoded < 240, "a HELLO fits well inside the 255-byte body limit")

local message = N:Decode(encoded)
assert_eq(message.version, 2, "the version is read back")
assert_eq(message.type, "HELLO", "the type is read back")
assert_eq(message.fields[1], "0.1.0", "the first field is the addon version")

assert_eq(N:Decode(""), nil, "an empty payload decodes to nothing")
assert_eq(N:Decode(nil), nil, "a nil payload decodes to nothing")
assert_eq(N:Decode("HELLO:0.1.0"), nil, "a payload with no version is refused")

--------------------------------------------------------------------------------
-- The live vocabulary is HELLO. Retired types die by name and are never acted on.
--------------------------------------------------------------------------------
reset()
assert_eq(N.SendSuggestion, nil, "SUGGESTION send is gone")
assert_eq(N.OnLocalSuggestion, nil, "local suggestion fanout is gone")
assert_eq(N.HandleSuggestion, nil, "SUGGESTION is not handled")
assert_eq(N.ReleaseHeld, nil, "petition hold/replay is gone")
assert_eq(N.MaxHeld, nil, "no petition hold budget")

local _, why = deliver("1:RANK_COMMIT:Beefina:3:300:4:1700:Pope", "Pope")
assert_eq(why, "retired message type", "an old build's rank commit is discarded by name")
assert_eq(N:PeerCount(), 0, "and seats no peer")

_, why = deliver("1:SYNC_REQUEST:req1", "Pope")
assert_eq(why, "retired message type", "so is a state-sync request")
_, why = deliver("1:SYNC_STATE:req1:1:1:payload", "Pope")
assert_eq(why, "retired message type", "and a state-sync answer")
_, why = deliver("1:SUGGESTION:Beefina:1:2:300:250", "Beefina")
assert_eq(why, "retired message type", "and a standing petition")

_, why = deliver(N:Encode("SCORE_EVENT", "Beefina", 5), "Cardinal")
assert_eq(why, "unknown message type", "a type this protocol never had is just unknown")
_, why = deliver(N:Encode("SNAPSHOT", "x"), "Chuckina")
assert_eq(why, "unknown message type", "a v2 snapshot codec is not invented here")
_, why = deliver(N:Encode("STATE", "QUIET"), "Porkina")
assert_eq(why, "unknown message type", "nor a Pope state broadcast")

--------------------------------------------------------------------------------
-- Envelope: wrong prefix, wrong channel, wrong protocol major
--------------------------------------------------------------------------------
reset()
assert_eq(N:OnAddonMessage("XYZ", helloPayload(), "GUILD", "Steakina"), false,
  "another addon's prefix is not our traffic")
assert_eq(N:OnAddonMessage(N.Prefix, helloPayload(), "RAID", "Steakina"), false,
  "HELLO is not accepted off the guild channel")
assert_eq(N:PeerCount(), 0, "none of those counted as peers")

_, why = deliver("1:HELLO:9.9.9", "Steakina")
assert_eq(why, "protocol mismatch", "another protocol major is discarded, not guessed at")
assert_eq(N.warnedVersion, true, "the first mismatch is the Quiet version notice")
assert_eq(N:PeerCount(), 0, "and a mismatched HELLO is not a peer")

local warnedAgain = N:_WarnVersion(1)
assert_eq(warnedAgain, false, "the version notice fires once")

--------------------------------------------------------------------------------
-- HELLO: version/presence, never authority
--------------------------------------------------------------------------------
reset()
assert_eq(deliver(helloPayload("0.1.0"), "Steakina"), true, "a peer HELLO is accepted")
assert_eq(N:PeerCount(), 1, "and that sender is one peer")
assert_eq(N.peers.steakina, "0.1.0", "keyed by the shared name law, carrying their version")

assert_eq(deliver(helloPayload("0.1.1"), "STEAKINA-Whitemane"), true,
  "casing and a realm suffix still read as the same member")
assert_eq(N:PeerCount(), 1, "so a re-spelled HELLO does not invent a second peer")
assert_eq(N.peers.steakina, "0.1.1", "the later version overwrites the presence note")

assert_eq(deliver(helloPayload("0.1.0"), "Beefina"), false,
  "our own echo is not a peer")
assert_eq(N:PeerCount(), 1, "self never joins the peer table")

assert_eq(deliver(helloPayload("0.2.0"), "Cardinal"), true, "a second guildmate is a second peer")
assert_eq(N:PeerCount(), 2, "presence is a count of distinct senders")

--------------------------------------------------------------------------------
-- Inbound pacing: one loud guildmate cannot spend the whole guild's attention
--------------------------------------------------------------------------------
reset()
local inClock = 0
N.clock = function() return inClock end

local accepted = 0
for _ = 1, 12 do
  local ok = N:OnAddonMessage(N.Prefix, helloPayload(), N.Channel, "Steakina")
  if ok then accepted = accepted + 1 end
end
assert_eq(accepted, N.InboundBurst, "a burst is heard exactly as far as the burst budget")

local _, tooFast = N:OnAddonMessage(N.Prefix, helloPayload(), N.Channel, "Steakina")
assert_eq(tooFast, "sender is talking too fast", "and the rest are dropped unread")

assert_eq(N:OnAddonMessage(N.Prefix, helloPayload(), N.Channel, "Cardinal"), true,
  "a different sender still gets through")

inClock = 5
assert_eq(N:OnAddonMessage(N.Prefix, helloPayload(), N.Channel, "Steakina"), true,
  "one token regenerates after five quiet seconds")

-- Our own guild-channel traffic echoes back to us and is not somebody else's budget.
inClock = 5
for _ = 1, 20 do
  N:OnAddonMessage(N.Prefix, helloPayload(), N.Channel, "Beefina")
end
local _, selfWhy = N:OnAddonMessage(N.Prefix, helloPayload(), N.Channel, "Beefina")
assert_eq(selfWhy, nil, "the echo of our own messages is never throttled")

reset()
N.clock = function() return 0 end
N.MaxInboundSenders = 4
for i = 1, 12 do
  N:OnAddonMessage(N.Prefix, helloPayload(), N.Channel, "Beefling" .. i)
end
local tracked = 0
for _ in pairs(N.inbound) do tracked = tracked + 1 end
assert_true(tracked <= 4, "the per-sender table stays inside its cap")
N.MaxInboundSenders = 200

--------------------------------------------------------------------------------
-- Outbound pacing: burst of ten, refilling one per second
--------------------------------------------------------------------------------
reset()
local clock = 0
N.clock = function() return clock end
local wire = {}
N.transmit = function(payload) wire[#wire + 1] = payload end

for i = 1, 5 do N:Send(N:Encode("HELLO", "0.1." .. i)) end
assert_eq(#wire, 5, "a login-sized burst goes out at once")
assert_eq(#N.queue, 0, "with nothing left waiting")

for i = 1, 8 do N:Send(N:Encode("HELLO", "0.2." .. i)) end
assert_eq(#wire, 10, "the burst allowance stops at ten")
assert_eq(#N.queue, 3, "and the overflow waits in the queue")

assert_eq(N:Pump(), 0, "pumping an empty bucket sends nothing")
assert_eq(#wire, 10, "still ten on the wire")

clock = 1
assert_eq(N:Pump(), 1, "a second buys exactly one more")
assert_eq(#wire, 11, "eleven on the wire")

clock = 3
assert_eq(N:Pump(), 2, "two quiet seconds buy two")
assert_eq(#wire, 13, "the queue drains at the refill rate")
assert_eq(#N.queue, 0, "and empties")
assert_eq(N:Pump(), 0, "an empty queue sends nothing")

clock = 600
N:_Refill(clock)
assert_eq(N.tokens, N.OutboundBurst, "a long silence refills to the burst cap, no further")

--------------------------------------------------------------------------------
-- Outbound shapes: HELLO goes out; a guildless client sends nothing
--------------------------------------------------------------------------------
reset()
N.transmit = function() end
assert_true(N:SendHello(), "a well-formed HELLO goes out")
assert_true(N.lastSent ~= nil and N.lastSent:find("HELLO", 1, true) ~= nil,
  "SendHello encodes HELLO")

stub.inGuild = false
assert_eq(N:Send(helloPayload()), false, "a guildless client sends nothing")
stub.inGuild = true

--------------------------------------------------------------------------------
-- Init: register the prefix, and only once
--------------------------------------------------------------------------------
reset()
assert_true(N:Init(), "Init wires the listener")
assert_true(stub.registeredPrefixes["COB"], "the COB prefix is registered")
assert_true(N.frame._events["CHAT_MSG_ADDON"], "and CHAT_MSG_ADDON is listened for")
assert_true(N.frame._events["GUILD_ROSTER_UPDATE"], "along with roster updates")
assert_eq(N:Init(), false, "a second Init is a no-op")

stub.fire(N.frame, "OnEvent", "CHAT_MSG_ADDON", N.Prefix,
  "1:RANK_COMMIT:Beefina:5:1200:3:1700:Pope", N.Channel, "Pope")
assert_eq(N:PeerCount(), 0, "an old build's commit off the wire seats nobody")

stub.fire(N.frame, "OnEvent", "CHAT_MSG_ADDON", N.Prefix,
  helloPayload("0.1.0"), N.Channel, "Steakina")
assert_eq(N:PeerCount(), 1, "a HELLO off the listener still counts as presence")

reset()
restore()
