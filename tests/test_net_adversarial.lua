-- BeefNet under a hostile guild channel.
--
-- test_net_validate proves the protocol behaves for a peer that is trying to be
-- understood. This suite assumes the opposite: a member with /run, a buggy build in
-- a send loop, and the ordinary accidents of a shared channel. Everything here goes
-- in through OnAddonMessage — the same door the client uses — so nothing is proven
-- against an internal function a real attacker could not reach.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Net/Codec.lua")
dofile("addon/ChurchOfBeef/Net/BeefNet.lua")

local COB = ChurchOfBeef
local N = COB.Net

stub.playerName = "Pope"
COB.VERSION = COB.VERSION or "0.1.0"

local function reset()
  N:ResetForTests()
  stub.timers = {}
  stub.addonMessages = {}
  stub.oversizeMessages = {}
  stub.now = 0
end

local function hello(version)
  return N:Encode("HELLO", version or "0.1.0")
end

local function deliver(payload, sender)
  return N:OnAddonMessage(N.Prefix, payload, N.Channel, sender)
end

reset()

--------------------------------------------------------------------------------
-- Retired and unknown types are discarded, never acted on
--------------------------------------------------------------------------------
local ok, why = deliver("1:SUGGESTION:Steakina:1:2:99999:50", "Beefina")
assert_eq(ok, false, "a standing petition is refused")
assert_eq(why, "retired message type", "and the refusal names retirement, not a queue")
assert_eq(N:PeerCount(), 0, "SUGGESTION never becomes presence")

ok, why = deliver("1:RANK_COMMIT:Beefina:3:300:4:1700:Pope", "Beefina")
assert_eq(ok, false, "a rank commit is refused")
assert_eq(why, "retired message type", "by the same retired door")

ok, why = deliver(N:Encode("SNAPSHOT", "theater"), "Beefina")
assert_eq(ok, false, "an invented snapshot is refused")
assert_eq(why, "unknown message type", "as unknown, not as a v2 codec")

--------------------------------------------------------------------------------
-- Sender spelling is identity for HELLO, not a petition binding
--------------------------------------------------------------------------------
-- Stripping "-Realm" is what makes one member one row. The price is that two
-- characters with the same name on different realms collapse into one identity.
-- TBC Anniversary guilds are single-realm, so this cannot happen inside a guild —
-- but the behaviour should be asserted rather than discovered later.
reset()
assert_eq(COB.Names.Same("Beefina-Whitemane", "Beefina-Doomhowl"), true,
  "same name on two realms reads as one member — single-realm guilds make this safe")
assert_eq(deliver(hello(), "Beefina-Whitemane"), true, "a realm-suffixed HELLO is accepted")
assert_eq(deliver(hello("0.2.0"), "Beefina-Doomhowl"), true,
  "so the same spelling across suffixes is one peer")
assert_eq(N:PeerCount(), 1, "not two identities")

--------------------------------------------------------------------------------
-- Flood: one loud client cannot spend every peer's decode budget
--------------------------------------------------------------------------------
reset()

local accepted = 0
for _ = 1, 50 do
  if deliver(hello(), "Beefina") then accepted = accepted + 1 end
end
assert_eq(accepted, N.InboundBurst, "a burst is cut off at the sender's allowance")
assert_eq(N:PeerCount(), 1, "and presence holds one peer, not fifty")

assert_eq(deliver(hello(), "Steakina"), true,
  "a different member is unaffected by the flooder")
assert_eq(N:PeerCount(), 2, "the quiet sender is still heard")

stub.now = 100
assert_eq(deliver(hello(), "Beefina"), true, "the flooder is heard again once time passes")

-- Nothing the flood did was parsed: a refusal happens before Decode, which is what
-- keeps the cost of abuse flat.
reset()
for _ = 1, 20 do deliver("garbage that would not decode", "Beefina") end
local blocked, reason = deliver(hello(), "Beefina")
assert_eq(blocked, false, "malformed traffic still spends the sender's allowance")
assert_eq(reason, "sender is talking too fast", "and the sender is silenced on volume alone")

--------------------------------------------------------------------------------
-- Our own guild traffic comes back to us
--------------------------------------------------------------------------------
reset()
stub.loopbackAddonMessages = true
stub.onAddonMessageEcho = function(prefix, payload, channel, sender)
  N:OnAddonMessage(prefix, payload, channel, sender)
end

N:SendHello()
assert_eq(#stub.addonMessages, 1, "the HELLO went out")
assert_eq(N:PeerCount(), 0, "and hearing it back does not make us our own peer")

for _ = 1, 30 do N:Send(hello(), stub.now) end
assert_eq(N:PeerCount(), 0, "no amount of our own echo counts as peers")
assert_eq(deliver(hello(), "Beefina"), true,
  "and the echo never spent another member's allowance")

stub.loopbackAddonMessages = false
stub.onAddonMessageEcho = nil

--------------------------------------------------------------------------------
-- The 255-byte envelope
--------------------------------------------------------------------------------
reset()

local huge = string.rep("B", 400)
local refused, envelopeWhy = N:Send(N:Encode("HELLO", huge))
assert_eq(refused, false, "an oversized payload is refused before the wire")
assert_eq(envelopeWhy, "payload too large", "with a reason that names the envelope")
assert_eq(#stub.oversizeMessages, 0, "so the client never had to drop it")
assert_eq(#stub.addonMessages, 0, "and nothing went out")

local longest = N:Encode("HELLO", "0.1.0")
assert_true(#longest + #N.Prefix + 1 <= 255, "a HELLO still fits the envelope")
assert_eq(N:Send(longest), true, "and the client accepts it")
assert_eq(#stub.oversizeMessages, 0, "no oversize message reached the client")

--------------------------------------------------------------------------------
-- Outbound pacing survives a local send loop
--------------------------------------------------------------------------------
reset()

local queuedOk = 0
for _ = 1, 200 do
  if N:Send(hello(), 0) then queuedOk = queuedOk + 1 end
end
assert_eq(#stub.addonMessages, N.OutboundBurst, "only the burst allowance actually went out")
assert_eq(queuedOk, N.OutboundBurst + N.MaxQueued, "the rest filled a bounded queue and then stopped")
assert_true(#N.queue <= N.MaxQueued, "the queue never grows past its cap")

assert_eq(stub.pendingTimers() > 0, true, "a retry is armed for the next token")
stub.advance(1)
assert_eq(#stub.addonMessages, N.OutboundBurst + 1, "one second buys exactly one more message")
stub.advance(5)
assert_eq(#stub.addonMessages, N.OutboundBurst + 6, "and the rate holds at one per second")

--------------------------------------------------------------------------------
-- A-05: worst-case 12-letter names + favor through Send / _TransmitWhisper.
-- Codec round-trip alone is not enough. Do not raise MAX_BODY.
--------------------------------------------------------------------------------
reset()
local fat = COB.Codec:EncodeState({
  eventId = 123456,
  state = "CONSEQUENCE",
  riteType = "Proclamation",
  subjects = { candidate = 123456, fighters = { 234567, 345678 } },
  sequence = 1234,
  favor = { a = 999, b = 999 },
  names = {
    candidate = "CCCCCCCCCCCC",
    fighterA = "AAAAAAAAAAAA",
    fighterB = "BBBBBBBBBBBB",
  },
})
assert_true(fat ~= nil, "fat STATE encodes")
assert_true(#fat <= 240, "fat STATE #payload is under MAX_BODY")
local sentOk, sentWhy = N:Send(fat)
assert_eq(sentOk, true, "fat STATE goes through Net:Send")
assert_eq(sentWhy, nil, "fat STATE Send has no refusal")
assert_true(#fat <= 240, "Send accepted a body at or under 240")
assert_true(#stub.addonMessages >= 1, "fat STATE reached the guild transmit")

local whisperOk, whisperWhy = N:_TransmitWhisper(fat, "Steakina")
assert_eq(whisperOk, true, "fat STATE goes through _TransmitWhisper")
assert_eq(whisperWhy, nil, "fat whisper has no refusal")
assert_eq(N.lastSent, fat, "whisper lastSent is the encoded fat body")
assert_true(#N.lastSent <= 240, "whisper #payload is under MAX_BODY")

local firstNight = COB.Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  riteType = "Gora",
  sequence = 3,
  subjects = { fighters = { 8, 9 } },
  favor = { a = 2, b = 1 },
  names = { fighterA = "AAAAAAAAAAAA", fighterB = "BBBBBBBBBBBB" },
})
assert_eq(#firstNight, 57, "first-night Gora stays 57 bytes through the live encoder")
assert_eq(N:Send(firstNight), true, "first-night Gora goes through Net:Send")
assert_eq(N:_TransmitWhisper(firstNight, "Steakina"), true,
  "first-night Gora goes through _TransmitWhisper")

reset()
restore()
