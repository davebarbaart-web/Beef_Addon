-- BeefNet v2 codecs (Phase 3 Lane B). Isolated: Common + Codec.
-- Encode/decode only. No SendAddonMessage. No BeefNet / Runtime / Store / UI.
-- Closed TYPEs: STATE, SNAPSHOT, INPUT. HELLO stays in BeefNet.
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
dofile("addon/ChurchOfBeef/Net/Codec.lua")

local COB = ChurchOfBeef
local Codec = COB.Codec

local sent = 0
SendAddonMessage = function()
  sent = sent + 1
end
C_ChatInfo = {
  SendAddonMessage = function()
    sent = sent + 1
  end,
}
CreateFrame = function()
  sent = sent + 1
end

local function refuse(producer, want, msg)
  local result, err = producer()
  assert_eq(result, nil, msg)
  assert_eq(err, want, (msg or "") .. " err")
end

--------------------------------------------------------------------------------
-- Isolated surface: codec only. Not transport, not Runtime, not a writer.
--------------------------------------------------------------------------------
assert_true(Codec ~= nil, "COB.Codec exists")
if standalone then
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
end
assert_true(COB.Names ~= nil, "Common name law is loaded")

assert_eq(type(Codec.Encode), "function", "Encode exists")
assert_eq(type(Codec.Decode), "function", "Decode exists")
assert_eq(type(Codec.EncodeState), "function", "EncodeState exists")
assert_eq(type(Codec.EncodeSnapshot), "function", "EncodeSnapshot exists")
assert_eq(type(Codec.EncodeInput), "function", "EncodeInput exists")
assert_eq(type(Codec.DecodeState), "function", "DecodeState exists")
assert_eq(type(Codec.DecodeSnapshot), "function", "DecodeSnapshot exists")
assert_eq(type(Codec.DecodeInput), "function", "DecodeInput exists")
assert_eq(type(Codec.IsCompatible), "function", "IsCompatible exists")
assert_eq(Codec.PROTOCOL, 1, "protocol major stays 1; v2 is the vocabulary")

assert_eq(Codec.Send, nil, "no Send")
assert_eq(Codec.SendAddonMessage, nil, "no SendAddonMessage")
assert_eq(Codec.Transmit, nil, "no Transmit")
assert_eq(Codec.SendHello, nil, "HELLO stays in BeefNet")
assert_eq(Codec.Whisper, nil, "no whisper routing")
assert_eq(Codec.SendWhisper, nil, "no whisper send")
assert_eq(Codec.Hold, nil, "no hold timer")
assert_eq(Codec.ReleaseHeld, nil, "no hold replay")
assert_eq(Codec.holdSeconds, nil, "no hold duration")
assert_eq(Codec.RegisterPope, nil, "no registered-Pope file")
assert_eq(Codec.IsPope, nil, "no Pope list")
assert_eq(Codec.Grant, nil, "no Grant")
assert_eq(Codec.GrantGora, nil, "no GrantGora")
assert_eq(Codec.SetStanding, nil, "no SetStanding")
assert_eq(Codec.AddPoints, nil, "no AddPoints")
assert_eq(Codec.CreateFrame, nil, "codec does not CreateFrame")
assert_eq(Codec.StartEvent, nil, "Runtime verbs are not this lane")
assert_eq(Codec.EncodeSuggestion, nil, "SUGGESTION is not restored")
assert_eq(Codec.EncodeSync, nil, "SYNC_* is not restored")
assert_eq(Codec.EncodeRankCommit, nil, "RANK_COMMIT is not restored")

assert_eq(Codec.TYPES.STATE, true, "STATE is a closed type")
assert_eq(Codec.TYPES.SNAPSHOT, true, "SNAPSHOT is a closed type")
assert_eq(Codec.TYPES.INPUT, true, "INPUT is a closed type")
assert_eq(Codec.TYPES.HELLO, nil, "HELLO is not this module")
assert_eq(Codec.TYPES.SUGGESTION, nil, "SUGGESTION is not a type")
assert_eq(Codec.TYPES.SYNC_STATE, nil, "SYNC_STATE is not a type")
assert_eq(Codec.TYPES.SYNC_REQUEST, nil, "SYNC_REQUEST is not a type")
assert_eq(Codec.TYPES.RANK_COMMIT, nil, "RANK_COMMIT is not a type")

local typeCount = 0
for _ in pairs(Codec.TYPES) do typeCount = typeCount + 1 end
assert_eq(typeCount, 3, "exactly three wire types")

assert_eq(Codec.STATES.QUIET, true, "QUIET is a named state")
assert_eq(Codec.STATES.ASSEMBLY, true, "ASSEMBLY is a named state")
assert_eq(Codec.STATES.RITE, true, "RITE is a named state")
assert_eq(Codec.STATES.CONSEQUENCE, true, "CONSEQUENCE is a named state")
assert_eq(Codec.STATES.AWAITING_POPE, nil, "awaiting the Pope is not a sixth state")

assert_eq(Codec.RITE_TYPES.Knighting, true, "Knighting is a closed rite")
assert_eq(Codec.RITE_TYPES.Gora, true, "Gora is a closed rite")
assert_eq(Codec.RITE_TYPES.Confession, true, "Confession is a closed rite")
assert_eq(Codec.RITE_TYPES.Proclamation, true, "Proclamation is a closed rite")
assert_eq(Codec.RITE_TYPES.birthday, nil, "free-text rite kinds are not types")

assert_eq(Codec.INPUT_KINDS.petition, true, "petition is a named input")
assert_eq(Codec.INPUT_KINDS.favor, true, "favor is a named input")
assert_eq(Codec.INPUT_KINDS.confession, true, "confession is a named input")
assert_eq(Codec.SNAPSHOT_ROLES.request, true, "snapshot role request")
assert_eq(Codec.SNAPSHOT_ROLES.response, true, "snapshot role response")

--------------------------------------------------------------------------------
-- STATE: Bible §20.2 fields only — event id, state, rite type, subjects, sequence
--------------------------------------------------------------------------------
local quiet = {
  eventId = 1,
  state = "QUIET",
  sequence = 0,
}
local quietWire, quietErr = Codec:EncodeState(quiet)
assert_true(quietWire ~= nil, "QUIET state encodes")
assert_eq(quietErr, nil, "QUIET encode has no error")
assert_eq(quiet.type, nil, "EncodeState does not stamp type onto the caller")
assert_eq(string.sub(quietWire, 1, 8), "1:STATE:", "STATE wire starts with version and type")

local quietMsg = Codec:Decode(quietWire)
assert_eq(quietMsg.type, "STATE", "QUIET decodes as STATE")
assert_eq(quietMsg.version, 1, "every message carries a protocol version")
assert_eq(quietMsg.eventId, 1, "event id round-trips")
assert_eq(quietMsg.state, "QUIET", "state round-trips")
assert_eq(quietMsg.riteType, nil, "QUIET has no rite type")
assert_eq(quietMsg.sequence, 0, "sequence 0 is valid")
assert_eq(type(quietMsg.subjects), "table", "subjects table is present")
assert_eq(quietMsg.subjects.candidate, nil, "no candidate in QUIET")
assert_eq(#quietMsg.subjects.fighters, 0, "no fighters in QUIET")
assert_eq(quietMsg.kind, nil, "STATE does not carry an input kind")
assert_eq(quietMsg.role, nil, "STATE does not carry a snapshot role")
assert_eq(quietMsg.text, nil, "STATE does not carry free text")
assert_eq(quietMsg.points, nil, "STATE does not carry points")
assert_eq(quietMsg.standing, nil, "STATE does not carry standing")
assert_eq(quietMsg.Grant, nil, "STATE does not carry Grant")

local sameQuiet = Codec:DecodeState(quietWire)
assert_eq(sameQuiet.state, "QUIET", "DecodeState accepts a STATE payload")

local assembly = Codec:Decode(Codec:EncodeState({
  eventId = 2,
  state = "ASSEMBLY",
  sequence = 1,
}))
assert_eq(assembly.state, "ASSEMBLY", "ASSEMBLY round-trips")
assert_eq(assembly.eventId, 2, "ASSEMBLY event id")
assert_eq(assembly.sequence, 1, "first transition is sequence 1")
assert_eq(assembly.riteType, nil, "ASSEMBLY has no rite type")

local rites = { "Knighting", "Gora", "Confession", "Proclamation" }
for i = 1, #rites do
  local name = rites[i]
  local msg = Codec:Decode(Codec:EncodeState({
    eventId = 10 + i,
    state = "RITE",
    riteType = name,
    sequence = 2,
    subjects = { candidate = 7 },
  }))
  assert_eq(msg.riteType, name, name .. " rite type round-trips")
  assert_eq(msg.state, "RITE", name .. " is a RITE")
  assert_eq(msg.subjects.candidate, 7, name .. " keeps the candidate")
end

local gora = Codec:Decode(Codec:EncodeState({
  eventId = 4,
  state = "RITE",
  riteType = "Gora",
  sequence = 3,
  subjects = { fighters = { 8, 9 } },
}))
assert_eq(gora.subjects.candidate, nil, "a Gora may have no candidate")
assert_eq(gora.subjects.fighters[1], 8, "first fighter")
assert_eq(gora.subjects.fighters[2], 9, "second fighter")
assert_eq(#gora.subjects.fighters, 2, "two fighters")

local knight = Codec:Decode(Codec:EncodeState({
  eventId = 5,
  state = "CONSEQUENCE",
  riteType = "Knighting",
  sequence = 4,
  subjects = { candidate = 11 },
}))
assert_eq(knight.state, "CONSEQUENCE", "CONSEQUENCE round-trips")
assert_eq(knight.riteType, "Knighting", "CONSEQUENCE may still name the rite")
assert_eq(knight.subjects.candidate, 11, "candidate survives CONSEQUENCE")

local both = Codec:Decode(Codec:EncodeState({
  eventId = 6,
  state = "RITE",
  riteType = "Gora",
  sequence = 5,
  subjects = { candidate = 1, fighters = { 2, 3 } },
}))
assert_eq(both.subjects.candidate, 1, "candidate and fighters may coexist")
assert_eq(both.subjects.fighters[2], 3, "fighters coexist with candidate")

local viaEncode = Codec:Encode({
  type = "STATE",
  eventId = 7,
  state = "QUIET",
  sequence = 0,
})
assert_eq(Codec:Decode(viaEncode).type, "STATE", "unified Encode accepts type STATE")

--------------------------------------------------------------------------------
-- SNAPSHOT: role request|response; response uses STATE fields only
--------------------------------------------------------------------------------
local reqWire = Codec:EncodeSnapshot({ role = "request" })
assert_true(reqWire ~= nil, "snapshot request encodes")
assert_eq(string.sub(reqWire, 1, 11), "1:SNAPSHOT:", "SNAPSHOT wire starts with version and type")

local req = Codec:Decode(reqWire)
assert_eq(req.type, "SNAPSHOT", "request decodes as SNAPSHOT")
assert_eq(req.version, 1, "request carries a protocol version")
assert_eq(req.role, "request", "request role")
assert_eq(req.eventId, nil, "request does not invent an event id")
assert_eq(req.state, nil, "request does not invent a state")
assert_eq(req.riteType, nil, "request does not invent a rite type")
assert_eq(req.subjects, nil, "request does not invent subjects")
assert_eq(req.sequence, nil, "request does not invent a sequence")
assert_eq(req.text, nil, "request carries no free text")

local resWire = Codec:EncodeSnapshot({
  role = "response",
  eventId = 4,
  state = "RITE",
  riteType = "Gora",
  sequence = 3,
  subjects = { fighters = { 8, 9 } },
})
local res = Codec:Decode(resWire)
assert_eq(res.type, "SNAPSHOT", "response decodes as SNAPSHOT")
assert_eq(res.role, "response", "response role")
assert_eq(res.eventId, 4, "response event id matches STATE")
assert_eq(res.state, "RITE", "response state matches STATE")
assert_eq(res.riteType, "Gora", "response rite type matches STATE")
assert_eq(res.sequence, 3, "response sequence matches STATE")
assert_eq(res.subjects.fighters[1], 8, "response fighters match STATE")
assert_eq(res.subjects.fighters[2], 9, "response second fighter")
assert_eq(res.schema, nil, "no extra snapshot schema field")
assert_eq(res.snapshot, nil, "no invented snapshot blob")

local resState = Codec:Decode(Codec:EncodeState({
  eventId = 4,
  state = "RITE",
  riteType = "Gora",
  sequence = 3,
  subjects = { fighters = { 8, 9 } },
}))
assert_eq(res.eventId, resState.eventId, "response event id equals STATE")
assert_eq(res.state, resState.state, "response state equals STATE")
assert_eq(res.riteType, resState.riteType, "response rite type equals STATE")
assert_eq(res.sequence, resState.sequence, "response sequence equals STATE")
assert_eq(res.subjects.fighters[1], resState.subjects.fighters[1], "response subjects equal STATE")

assert_eq(Codec:DecodeSnapshot(reqWire).role, "request", "DecodeSnapshot accepts a request")
assert_eq(Codec:DecodeSnapshot(resWire).role, "response", "DecodeSnapshot accepts a response")

--------------------------------------------------------------------------------
-- INPUT: petition | favor | confession. Character id. Confession may carry text.
-- Never theater.
--------------------------------------------------------------------------------
local petition = Codec:Decode(Codec:EncodeInput({ kind = "petition", characterId = 3 }))
assert_eq(petition.type, "INPUT", "petition is INPUT")
assert_eq(petition.version, 1, "petition carries a protocol version")
assert_eq(petition.kind, "petition", "petition kind")
assert_eq(petition.characterId, 3, "petition character id")
assert_eq(petition.text, nil, "petition carries no text")
assert_eq(petition.state, nil, "petition is not theater")
assert_eq(petition.riteType, nil, "petition has no rite type")
assert_eq(petition.eventId, nil, "petition has no event id")
assert_eq(petition.sequence, nil, "petition has no sequence")
assert_eq(petition.subjects, nil, "petition has no subjects")
assert_eq(petition.side, nil, "favor side is not invented on petition")

local favor = Codec:Decode(Codec:EncodeInput({ kind = "favor", characterId = 8 }))
assert_eq(favor.kind, "favor", "favor kind")
assert_eq(favor.characterId, 8, "favor character id")
assert_eq(favor.text, nil, "favor carries no text")
assert_eq(favor.state, nil, "favor is not theater")
assert_eq(favor.side, nil, "favor side is not a codec field")

local confession = Codec:Decode(Codec:EncodeInput({
  kind = "confession",
  characterId = 12,
  text = "I ate the last steak",
}))
assert_eq(confession.kind, "confession", "confession kind")
assert_eq(confession.characterId, 12, "confession character id")
assert_eq(confession.text, "I ate the last steak", "confession may carry text")
assert_eq(confession.state, nil, "confession text is not theater")

local colonText = Codec:Decode(Codec:EncodeInput({
  kind = "confession",
  characterId = 1,
  text = "forgive:me:twice",
}))
assert_eq(colonText.text, "forgive:me:twice", "confession text may contain colons")

local silent = Codec:Decode(Codec:EncodeInput({ kind = "confession", characterId = 1 }))
assert_eq(silent.text, nil, "confession text is optional")

assert_eq(Codec:DecodeInput(Codec:EncodeInput({ kind = "petition", characterId = 1 })).kind,
  "petition", "DecodeInput accepts INPUT")

--------------------------------------------------------------------------------
-- Copies: decode tables are fresh; encode does not mutate the caller
--------------------------------------------------------------------------------
local srcFighters = { 4, 5 }
local src = {
  eventId = 9,
  state = "RITE",
  riteType = "Gora",
  sequence = 6,
  subjects = { fighters = srcFighters },
}
local srcWire = Codec:EncodeState(src)
assert_eq(src.subjects.fighters[1], 4, "encode does not mutate fighters")
assert_eq(src.type, nil, "encode does not write type onto the caller")
srcFighters[1] = 99
local copyA = Codec:Decode(srcWire)
local copyB = Codec:Decode(srcWire)
copyA.subjects.fighters[1] = 77
copyA.eventId = 0
assert_eq(copyB.subjects.fighters[1], 4, "Decode returns a copy of fighters")
assert_eq(copyB.eventId, 9, "Decode returns a copy of the message")

--------------------------------------------------------------------------------
-- Fail closed: unknown TYPE, including HELLO and retired demo types
--------------------------------------------------------------------------------
local function badType(name)
  refuse(function() return Codec:Decode("1:" .. name .. ":x") end, "unknown message type", name .. " is unknown")
  refuse(function() return Codec:Encode({ type = name }) end, "unknown message type", "Encode " .. name)
end

badType("HELLO")
badType("SUGGESTION")
badType("SYNC_STATE")
badType("SYNC_REQUEST")
badType("RANK_COMMIT")
badType("SCORE_EVENT")
badType("THEATER")
badType("SUMMON")

refuse(function() return Codec:Decode("1::1:QUIET:::0") end, "no message type", "empty type")
refuse(function() return Codec:Encode({}) end, "unknown message type", "Encode without type")
refuse(function() return Codec:Encode("STATE") end, "invalid message", "Encode a string")
refuse(function() return Codec:Encode(nil) end, "invalid message", "Encode nil")

refuse(function() return Codec:DecodeState(reqWire) end, "unknown message type", "DecodeState rejects SNAPSHOT")
refuse(function() return Codec:DecodeSnapshot(quietWire) end, "unknown message type", "DecodeSnapshot rejects STATE")
refuse(function() return Codec:DecodeInput(quietWire) end, "unknown message type", "DecodeInput rejects STATE")

--------------------------------------------------------------------------------
-- Fail closed: missing protocol version
--------------------------------------------------------------------------------
refuse(function() return Codec:Decode("") end, "empty payload", "empty string")
refuse(function() return Codec:Decode(nil) end, "empty payload", "nil payload")
refuse(function() return Codec:Decode("STATE:1:QUIET:::0") end, "no protocol version", "version-less STATE")
refuse(function() return Codec:Decode("SNAPSHOT:request") end, "no protocol version", "version-less SNAPSHOT")
refuse(function() return Codec:Decode("INPUT:petition:1") end, "no protocol version", "version-less INPUT")
refuse(function() return Codec:Decode(":STATE:1:QUIET:::0") end, "no protocol version", "empty version field")
refuse(function() return Codec:Decode("nan:STATE:1:QUIET:::0") end, "no protocol version", "NaN version")

local foreign = Codec:Decode("2:STATE:1:QUIET::::0")
assert_true(foreign ~= nil, "a versioned foreign major still decodes")
assert_eq(foreign.version, 2, "foreign version is visible")
assert_eq(Codec:IsCompatible(foreign.version), false, "foreign major is not compatible")
assert_eq(Codec:IsCompatible(1), true, "this protocol is compatible")
assert_eq(Codec:IsCompatible(nil), false, "missing version is not compatible")

refuse(function() return Codec:EncodeState({
  version = 2,
  eventId = 1,
  state = "QUIET",
  sequence = 0,
}) end, "protocol mismatch", "Encode refuses a foreign major")

--------------------------------------------------------------------------------
-- Fail closed: bad role / kind
--------------------------------------------------------------------------------
refuse(function() return Codec:EncodeSnapshot({ role = "ask" }) end, "invalid role", "ask is not a role")
refuse(function() return Codec:EncodeSnapshot({ role = "REQUEST" }) end, "invalid role", "role is case-sensitive")
refuse(function() return Codec:EncodeSnapshot({ role = "reply" }) end, "invalid role", "reply is not a role")
refuse(function() return Codec:EncodeSnapshot({}) end, "invalid role", "snapshot without role")
refuse(function() return Codec:Decode("1:SNAPSHOT:ask") end, "invalid role", "wire ask")
refuse(function() return Codec:Decode("1:SNAPSHOT:REQUEST") end, "invalid role", "wire REQUEST")

refuse(function() return Codec:EncodeInput({ kind = "Petition", characterId = 1 }) end, "invalid kind", "Petition case")
refuse(function() return Codec:EncodeInput({ kind = "note", characterId = 1 }) end, "invalid kind", "note is not a kind")
refuse(function() return Codec:EncodeInput({ kind = "theater", characterId = 1 }) end, "invalid kind", "theater is not a kind")
refuse(function() return Codec:EncodeInput({ characterId = 1 }) end, "invalid kind", "INPUT without kind")
refuse(function() return Codec:Decode("1:INPUT:Petition:1") end, "invalid kind", "wire Petition")
refuse(function() return Codec:Decode("1:INPUT:theater:1") end, "invalid kind", "wire theater")

--------------------------------------------------------------------------------
-- Fail closed: Grant / standing / points keys
--------------------------------------------------------------------------------
local function banned(mutator, label)
  local fields = { eventId = 1, state = "QUIET", sequence = 0 }
  mutator(fields)
  refuse(function() return Codec:EncodeState(fields) end, "banned key", "STATE " .. label)
end

banned(function(f) f.points = 12 end, "points")
banned(function(f) f.standing = 4 end, "standing")
banned(function(f) f.Grant = true end, "Grant")
banned(function(f) f.GrantGora = 3 end, "GrantGora")
banned(function(f) f.granted = 1 end, "granted")
banned(function(f) f.subjects = { points = 1 } end, "nested points")
banned(function(f) f.subjects = { standing = 1 } end, "nested standing")
banned(function(f) f.subjects = { Grant = true } end, "nested Grant")

refuse(function() return Codec:EncodeSnapshot({ role = "request", points = 1 }) end, "banned key", "SNAPSHOT points")
refuse(function() return Codec:EncodeInput({ kind = "petition", characterId = 1, standing = 1 }) end,
  "banned key", "INPUT standing")
refuse(function() return Codec:Encode({ type = "INPUT", kind = "favor", characterId = 1, Grant = true }) end,
  "banned key", "unified Encode Grant")

--------------------------------------------------------------------------------
-- Fail closed: free-text rite kinds, bad states, bad ids
--------------------------------------------------------------------------------
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  riteType = "birthday",
  sequence = 1,
}) end, "invalid rite type", "birthday is free-text")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  riteType = "knighting",
  sequence = 1,
}) end, "invalid rite type", "rite type is case-sensitive")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "QUIET",
  riteType = "Custom",
  sequence = 0,
}) end, "invalid rite type", "free-text rite is refused even in QUIET")
refuse(function() return Codec:Decode("1:STATE:1:RITE:birthday:::1") end, "invalid rite type", "wire birthday")
refuse(function() return Codec:Decode("1:STATE:1:RITE:Knighting Extra:::1") end, "invalid rite type", "wire free-text rite")

refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  sequence = 1,
}) end, "rite type required", "RITE without a type")
refuse(function() return Codec:Decode("1:STATE:1:RITE::::1") end, "rite type required", "wire RITE without a type")

refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "quiet",
  sequence = 0,
}) end, "invalid state", "state is case-sensitive")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "AWAITING_POPE",
  sequence = 0,
}) end, "invalid state", "awaiting the Pope is not a state")
refuse(function() return Codec:EncodeState({ eventId = 1, sequence = 0 }) end, "invalid state", "STATE without state")
refuse(function() return Codec:Decode("1:STATE:1:LIVE::::0") end, "invalid state", "wire LIVE")

refuse(function() return Codec:EncodeState({ state = "QUIET", sequence = 0 }) end, "invalid event id", "missing event id")
refuse(function() return Codec:EncodeState({ eventId = 0, state = "QUIET", sequence = 0 }) end, "invalid event id", "event id 0")
refuse(function() return Codec:EncodeState({ eventId = 1.5, state = "QUIET", sequence = 0 }) end, "invalid event id", "fractional event id")
refuse(function() return Codec:EncodeState({ eventId = "evt-1", state = "QUIET", sequence = 0 }) end, "invalid event id", "string event id")
refuse(function() return Codec:EncodeState({ eventId = 1, state = "QUIET" }) end, "invalid sequence", "missing sequence")
refuse(function() return Codec:EncodeState({ eventId = 1, state = "QUIET", sequence = -1 }) end, "invalid sequence", "negative sequence")
refuse(function() return Codec:EncodeState({ eventId = 1, state = "QUIET", sequence = 1.2 }) end, "invalid sequence", "fractional sequence")

refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "QUIET",
  sequence = 0,
  subjects = { candidate = "Beefina" },
}) end, "invalid subjects", "name is not a character id")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "QUIET",
  sequence = 0,
  subjects = { candidate = 0 },
}) end, "invalid subjects", "candidate 0")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  riteType = "Gora",
  sequence = 1,
  subjects = { fighters = { "Steakina" } },
}) end, "invalid subjects", "fighter name")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "QUIET",
  sequence = 0,
  subjects = "7",
}) end, "invalid subjects", "subjects must be a table")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "QUIET",
  sequence = 0,
  subjects = { extra = 1 },
}) end, "invalid subjects", "unknown subjects key")
refuse(function() return Codec:Decode("1:STATE:1:QUIET::Beefina::0") end, "invalid subjects", "wire name candidate")
refuse(function() return Codec:Decode("1:STATE:1:RITE:Gora::4,x:1") end, "invalid subjects", "wire bad fighter")

refuse(function() return Codec:EncodeInput({ kind = "petition" }) end, "invalid character id", "INPUT without character id")
refuse(function() return Codec:EncodeInput({ kind = "petition", characterId = 0 }) end, "invalid character id", "character id 0")
refuse(function() return Codec:EncodeInput({ kind = "petition", characterId = "Beefina" }) end,
  "invalid character id", "name is not a character id")
refuse(function() return Codec:Decode("1:INPUT:petition:Beefina") end, "invalid character id", "wire name character")

--------------------------------------------------------------------------------
-- Fail closed: INPUT never encodes theater; petition/favor never carry text
--------------------------------------------------------------------------------
refuse(function() return Codec:EncodeInput({
  kind = "petition",
  characterId = 1,
  text = "please",
}) end, "text not allowed", "petition text")
refuse(function() return Codec:EncodeInput({
  kind = "favor",
  characterId = 1,
  text = "red",
}) end, "text not allowed", "favor text")
refuse(function() return Codec:Decode("1:INPUT:petition:1:please") end, "text not allowed", "wire petition text")
refuse(function() return Codec:Decode("1:INPUT:favor:1:red") end, "text not allowed", "wire favor text")

refuse(function() return Codec:EncodeInput({
  kind = "petition",
  characterId = 1,
  state = "RITE",
}) end, "unknown field", "INPUT state is theater")
refuse(function() return Codec:EncodeInput({
  kind = "favor",
  characterId = 1,
  riteType = "Gora",
}) end, "unknown field", "INPUT rite type is theater")
refuse(function() return Codec:EncodeInput({
  kind = "confession",
  characterId = 1,
  eventId = 4,
}) end, "unknown field", "INPUT event id is theater")
refuse(function() return Codec:EncodeInput({
  kind = "confession",
  characterId = 1,
  sequence = 1,
}) end, "unknown field", "INPUT sequence is theater")
refuse(function() return Codec:EncodeInput({
  kind = "confession",
  characterId = 1,
  subjects = { candidate = 1 },
}) end, "unknown field", "INPUT subjects are theater")
refuse(function() return Codec:EncodeInput({
  kind = "favor",
  characterId = 1,
  side = "left",
}) end, "unknown field", "favor side is not a named field")
refuse(function() return Codec:EncodeInput({
  kind = "confession",
  characterId = 1,
  narration = "the software speaks",
}) end, "unknown field", "narration is not a field")

refuse(function() return Codec:EncodeSnapshot({
  role = "request",
  eventId = 1,
  state = "ASSEMBLY",
  sequence = 1,
}) end, "unknown field", "request does not carry STATE fields")
refuse(function() return Codec:EncodeSnapshot({
  role = "response",
  eventId = 1,
  state = "ASSEMBLY",
  sequence = 1,
  schema = {},
}) end, "unknown field", "response has no extra snapshot schema")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "QUIET",
  sequence = 0,
  kind = "petition",
}) end, "unknown field", "STATE does not carry an input kind")
refuse(function() return Codec:EncodeState({
  eventId = 1,
  state = "QUIET",
  sequence = 0,
  text = "nope",
}) end, "unknown field", "STATE does not carry free text")

refuse(function() return Codec:EncodeSnapshot({ role = "response", state = "ASSEMBLY", sequence = 1 }) end,
  "invalid event id", "response missing event id")
refuse(function() return Codec:Decode("1:SNAPSHOT:response:1:ASSEMBLY::::0:extra") end,
  "unknown field", "response extra wire field")
refuse(function() return Codec:Decode("1:STATE:1:QUIET::::0:extra") end, "unknown field", "STATE extra wire field")
refuse(function() return Codec:Decode("1:SNAPSHOT:request:1") end, "unknown field", "request extra wire field")

--------------------------------------------------------------------------------
-- Codec never sends and never builds frames
--------------------------------------------------------------------------------
sent = 0
Codec:EncodeState({ eventId = 1, state = "QUIET", sequence = 0 })
Codec:EncodeSnapshot({ role = "request" })
Codec:EncodeInput({ kind = "petition", characterId = 1 })
Codec:Decode("1:STATE:1:QUIET::::0")
Codec:Decode("1:SNAPSHOT:request")
Codec:Decode("1:INPUT:confession:1:hello")
assert_eq(sent, 0, "encode/decode never SendAddonMessage or CreateFrame")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
