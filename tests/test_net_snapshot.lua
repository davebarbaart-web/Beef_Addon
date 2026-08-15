-- Snapshot request / response apply (Phase 3 Lane C).
-- Isolated: Common + Runtime + Codec + Snapshot.
-- No SendAddonMessage. No whisper routing. No #8 Pope list. No peer SYNC.
-- Do not load BeefNet / Store / UI / TOC / bootstrap / run.lua.
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

local COB = ChurchOfBeef
local Runtime = COB.Runtime
local Codec = COB.Codec
local Snapshot = COB.Snapshot

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

local SNAP_KEYS = {
  eventId = true,
  state = true,
  riteType = true,
  subjects = true,
  sequence = true,
}

local SUBJECT_KEYS = {
  candidate = true,
  fighters = true,
}

local function reset()
  assert_eq(Runtime:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
end

local function assert_snap_shape(snap, msg)
  assert_eq(type(snap), "table", (msg or "snapshot") .. " is a table")
  for k, _ in pairs(snap) do
    assert_true(SNAP_KEYS[k], (msg or "snapshot") .. " field " .. tostring(k) .. " is Bible-named")
  end
  assert_eq(type(snap.subjects), "table", (msg or "snapshot") .. " has subjects")
  for k, _ in pairs(snap.subjects) do
    assert_true(SUBJECT_KEYS[k], (msg or "snapshot") .. " subject " .. tostring(k) .. " is Bible-named")
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
end

local function encode_expected(snap)
  return Codec:EncodeSnapshot({
    role = "response",
    eventId = snap.eventId,
    state = snap.state,
    riteType = snap.riteType,
    subjects = snap.subjects,
    sequence = snap.sequence,
  })
end

--------------------------------------------------------------------------------
-- Isolated surface: apply/build only. Not transport, not a second schema.
--------------------------------------------------------------------------------
assert_true(Snapshot ~= nil, "COB.Snapshot exists")
if standalone then
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
end
assert_true(Runtime ~= nil, "Runtime is loaded")
assert_true(Codec ~= nil, "Codec is loaded")
assert_true(COB.Names ~= nil, "Common name law is loaded")

assert_eq(type(Snapshot.Request), "function", "Request exists")
assert_eq(type(Snapshot.BuildResponse), "function", "BuildResponse exists")
assert_eq(type(Snapshot.ApplyResponse), "function", "ApplyResponse exists")

assert_eq(Snapshot.Send, nil, "no Send")
assert_eq(Snapshot.SendAddonMessage, nil, "no SendAddonMessage")
assert_eq(Snapshot.Transmit, nil, "no Transmit")
assert_eq(Snapshot.Whisper, nil, "no whisper routing")
assert_eq(Snapshot.SendWhisper, nil, "no whisper send")
assert_eq(Snapshot.Route, nil, "no routing table")
assert_eq(Snapshot.Hold, nil, "no hold timer")
assert_eq(Snapshot.ReleaseHeld, nil, "no hold replay")
assert_eq(Snapshot.holdSeconds, nil, "no hold duration")
assert_eq(Snapshot.RegisterPope, nil, "no registered-Pope file")
assert_eq(Snapshot.IsPope, nil, "no Pope list")
assert_eq(Snapshot.IsRegisteredPope, nil, "no #8 predicate")
assert_eq(Snapshot.Grant, nil, "no Grant")
assert_eq(Snapshot.GrantGora, nil, "no GrantGora")
assert_eq(Snapshot.SetStanding, nil, "no SetStanding")
assert_eq(Snapshot.AddPoints, nil, "no AddPoints")
assert_eq(Snapshot.CreateFrame, nil, "Snapshot does not CreateFrame")
assert_eq(Snapshot.StartEvent, nil, "Runtime verbs are not this lane")
assert_eq(Snapshot.OpenRite, nil, "OpenRite is not this lane")
assert_eq(Snapshot.EncodeSuggestion, nil, "SUGGESTION is not restored")
assert_eq(Snapshot.EncodeSync, nil, "SYNC_* is not restored")
assert_eq(Snapshot.ApplySync, nil, "no peer SYNC apply")
assert_eq(Snapshot.EncodeRankCommit, nil, "RANK_COMMIT is not restored")
assert_eq(Snapshot.SCHEMA, nil, "no extra snapshot schema")
assert_eq(Snapshot.schema, nil, "no schema table")

--------------------------------------------------------------------------------
-- Request(): EncodeSnapshot({ role = "request" }). Does not change Runtime.
--------------------------------------------------------------------------------
reset()
local cold = Runtime:Snapshot()
assert_eq(cold.state, "QUIET", "cold start is QUIET")
assert_eq(cold.eventId, nil, "cold start has no event")

sent = 0
local req, reqErr = Snapshot:Request()
assert_true(req ~= nil, "Request encodes")
assert_eq(reqErr, nil, "Request has no error")
assert_eq(req, "1:SNAPSHOT:request", "Request wire is role only")
assert_eq(req, Codec:EncodeSnapshot({ role = "request" }), "Request is Codec EncodeSnapshot request")
assert_unchanged(cold, Runtime:Snapshot(), "Request from QUIET")
assert_eq(sent, 0, "Request does not SendAddonMessage")

local decodedReq = Codec:DecodeSnapshot(req)
assert_eq(decodedReq.type, "SNAPSHOT", "Request decodes as SNAPSHOT")
assert_eq(decodedReq.role, "request", "Request role is request")
assert_eq(decodedReq.eventId, nil, "Request does not invent an event id")
assert_eq(decodedReq.state, nil, "Request does not invent a state")
assert_eq(decodedReq.riteType, nil, "Request does not invent a rite type")
assert_eq(decodedReq.subjects, nil, "Request does not invent subjects")
assert_eq(decodedReq.sequence, nil, "Request does not invent a sequence")
assert_eq(decodedReq.schema, nil, "Request has no extra schema")

Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 3, 4 } })
local midRite = Runtime:Snapshot()
local reqMid = Snapshot:Request()
assert_eq(reqMid, "1:SNAPSHOT:request", "Request mid-rite is still role only")
assert_unchanged(midRite, Runtime:Snapshot(), "Request does not change a live event")

local reqExtra = Snapshot:Request({ pope = true }, "whisper")
assert_eq(reqExtra, "1:SNAPSHOT:request", "Request ignores leftover args")
assert_unchanged(midRite, Runtime:Snapshot(), "Request leftover args do not change Runtime")

--------------------------------------------------------------------------------
-- BuildResponse(): QUIET (no event) fails. Nothing to catch up to.
--------------------------------------------------------------------------------
reset()
local quietBefore = Runtime:Snapshot()
local quietBlob, quietErr = Snapshot:BuildResponse()
assert_eq(quietBlob, nil, "BuildResponse from cold QUIET returns nil")
assert_eq(quietErr, "no event", "BuildResponse from cold QUIET: no event")
assert_unchanged(quietBefore, Runtime:Snapshot(), "failed BuildResponse from cold QUIET")

Runtime:StartEvent()
local ended = Runtime:EndEvent()
assert_eq(ended.state, "QUIET", "EndEvent returns to QUIET")
assert_true(ended.eventId ~= nil, "ended QUIET still remembers the event id")
local afterEnd = Runtime:Snapshot()
local endedBlob, endedErr = Snapshot:BuildResponse()
assert_eq(endedBlob, nil, "BuildResponse after EndEvent returns nil")
assert_eq(endedErr, "no event", "ended QUIET is not catch-up")
assert_unchanged(afterEnd, Runtime:Snapshot(), "failed BuildResponse after EndEvent")

--------------------------------------------------------------------------------
-- BuildResponse(): live event encodes STATE fields + role response.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local assembly = Runtime:Snapshot()
assert_eq(assembly.state, "ASSEMBLY", "StartEvent is ASSEMBLY")
local assemblyWire, assemblyErr = Snapshot:BuildResponse()
assert_true(assemblyWire ~= nil, "BuildResponse from ASSEMBLY encodes")
assert_eq(assemblyErr, nil, "successful BuildResponse has no error")
assert_eq(assemblyWire, encode_expected(assembly), "ASSEMBLY response is Codec STATE fields plus role")
assert_unchanged(assembly, Runtime:Snapshot(), "BuildResponse does not change ASSEMBLY")
assert_eq(Runtime:Snapshot().sequence, assembly.sequence, "BuildResponse does not increment sequence")

local assemblyMsg = Codec:DecodeSnapshot(assemblyWire)
assert_eq(assemblyMsg.type, "SNAPSHOT", "ASSEMBLY response is SNAPSHOT")
assert_eq(assemblyMsg.role, "response", "ASSEMBLY response role")
assert_eq(assemblyMsg.version, 1, "ASSEMBLY response carries protocol 1")
assert_eq(assemblyMsg.eventId, assembly.eventId, "ASSEMBLY response event id")
assert_eq(assemblyMsg.state, "ASSEMBLY", "ASSEMBLY response state")
assert_eq(assemblyMsg.riteType, nil, "ASSEMBLY response has no rite type")
assert_eq(assemblyMsg.sequence, assembly.sequence, "ASSEMBLY response sequence")
assert_eq(assemblyMsg.schema, nil, "no extra snapshot schema on the wire")
assert_eq(assemblyMsg.holdSeconds, nil, "response does not invent holdSeconds")
assert_eq(assemblyMsg.awaitingPope, nil, "response does not invent awaitingPope")
assert_eq(assemblyMsg.kind, nil, "response is not an INPUT")

Runtime:OpenRite("Knighting", { candidate = 7 })
local knighting = Runtime:Snapshot()
local knightWire = Snapshot:BuildResponse()
assert_eq(knightWire, encode_expected(knighting), "Knighting response matches Codec")
local knightMsg = Codec:DecodeSnapshot(knightWire)
assert_eq(knightMsg.state, "RITE", "Knighting response is RITE")
assert_eq(knightMsg.riteType, "Knighting", "Knighting response keeps the rite type")
assert_eq(knightMsg.subjects.candidate, 7, "Knighting response keeps the candidate")
assert_unchanged(knighting, Runtime:Snapshot(), "BuildResponse does not change RITE")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 8, 9 } })
local gora = Runtime:Snapshot()
local goraWire = Snapshot:BuildResponse()
assert_eq(goraWire, encode_expected(gora), "Gora response matches Codec")
local goraMsg = Codec:DecodeSnapshot(goraWire)
assert_eq(goraMsg.riteType, "Gora", "Gora response rite type")
assert_eq(goraMsg.subjects.fighters[1], 8, "Gora response first fighter")
assert_eq(goraMsg.subjects.fighters[2], 9, "Gora response second fighter")
assert_eq(goraMsg.subjects.candidate, nil, "Gora without a candidate leaves candidate empty")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Confession")
Runtime:CloseRite()
local consequence = Runtime:Snapshot()
assert_eq(consequence.state, "CONSEQUENCE", "CloseRite is CONSEQUENCE")
local consWire = Snapshot:BuildResponse()
assert_eq(consWire, encode_expected(consequence), "CONSEQUENCE response matches Codec")
local consMsg = Codec:DecodeSnapshot(consWire)
assert_eq(consMsg.state, "CONSEQUENCE", "CONSEQUENCE response state")
assert_eq(consMsg.riteType, "Confession", "CONSEQUENCE keeps the rite type")
assert_unchanged(consequence, Runtime:Snapshot(), "BuildResponse does not change CONSEQUENCE")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Proclamation", { candidate = 11 })
Runtime:CloseRite()
Runtime:Continue()
local continued = Runtime:Snapshot()
assert_eq(continued.state, "ASSEMBLY", "Continue returns to ASSEMBLY")
assert_eq(continued.riteType, nil, "Continue clears the rite type")
local contWire = Snapshot:BuildResponse()
assert_eq(contWire, encode_expected(continued), "post-Continue ASSEMBLY response matches Codec")
assert_eq(Codec:DecodeSnapshot(contWire).riteType, nil, "post-Continue response has no rite type")

local extraBuild = Snapshot:BuildResponse({ schema = true }, "guild")
assert_eq(extraBuild, encode_expected(continued), "BuildResponse ignores leftover args")
assert_unchanged(continued, Runtime:Snapshot(), "BuildResponse leftover args do not change Runtime")

--------------------------------------------------------------------------------
-- ApplyResponse(blob): Restore Bible fields only. Congregation lands mid-rite.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { candidate = 9, fighters = { 1, 2 } })
local pope = Runtime:Snapshot()
local catchup = Snapshot:BuildResponse()
assert_true(catchup ~= nil, "Pope BuildResponse for catch-up")

reset()
local congregation = Runtime:Snapshot()
assert_eq(congregation.state, "QUIET", "congregation starts QUIET")
sent = 0
local applied, applyErr = Snapshot:ApplyResponse(catchup)
assert_eq(applied, true, "ApplyResponse restores a response")
assert_eq(applyErr, nil, "successful ApplyResponse has no error")
assert_eq(sent, 0, "ApplyResponse does not SendAddonMessage")
local landed = Runtime:Snapshot()
assert_snap_shape(landed, "landed snapshot")
assert_bible(landed, pope, "congregation lands on the Pope event")
assert_eq(landed.state, "RITE", "late join lands in RITE")
assert_eq(landed.riteType, "Gora", "late join keeps the rite type")
assert_eq(landed.subjects.candidate, 9, "late join keeps the candidate")
assert_eq(landed.subjects.fighters[1], 1, "late join keeps fighter 1")
assert_eq(landed.subjects.fighters[2], 2, "late join keeps fighter 2")
assert_eq(landed.type, nil, "Restore does not keep wire type")
assert_eq(landed.role, nil, "Restore does not keep snapshot role")
assert_eq(landed.version, nil, "Restore does not keep protocol version")
assert_eq(landed.schema, nil, "Restore does not keep an extra schema")

-- Sequence is resumed, not incremented (Restore, not a Pope verb).
assert_eq(landed.sequence, pope.sequence, "ApplyResponse does not increment sequence")

local afterLand = Runtime:CloseRite()
assert_eq(afterLand.state, "CONSEQUENCE", "verbs resume from the restored rite")
assert_eq(afterLand.sequence, pope.sequence + 1, "sequence increments from the restored value")

--------------------------------------------------------------------------------
-- ApplyResponse of ASSEMBLY / CONSEQUENCE / each closed rite type
--------------------------------------------------------------------------------
local rites = { "Knighting", "Gora", "Confession", "Proclamation" }
for i = 1, #rites do
  reset()
  Runtime:StartEvent()
  Runtime:OpenRite(rites[i], { candidate = 20 + i })
  local src = Runtime:Snapshot()
  local blob = Snapshot:BuildResponse()
  reset()
  assert_eq(Snapshot:ApplyResponse(blob), true, "ApplyResponse " .. rites[i])
  assert_bible(Runtime:Snapshot(), src, "round-trip " .. rites[i])
end

reset()
Runtime:StartEvent()
local srcAssembly = Runtime:Snapshot()
local assemblyCatch = Snapshot:BuildResponse()
reset()
assert_eq(Snapshot:ApplyResponse(assemblyCatch), true, "ApplyResponse ASSEMBLY")
assert_bible(Runtime:Snapshot(), srcAssembly, "round-trip ASSEMBLY")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting", { candidate = 15 })
Runtime:CloseRite()
local srcCons = Runtime:Snapshot()
local consCatch = Snapshot:BuildResponse()
reset()
assert_eq(Snapshot:ApplyResponse(consCatch), true, "ApplyResponse CONSEQUENCE")
assert_bible(Runtime:Snapshot(), srcCons, "round-trip CONSEQUENCE")

--------------------------------------------------------------------------------
-- ApplyResponse fail closed: request role. Do not apply a request.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local live = Runtime:Snapshot()
local fromRequest, fromRequestErr = Snapshot:ApplyResponse(Snapshot:Request())
assert_eq(fromRequest, nil, "ApplyResponse refuses a Request blob")
assert_eq(fromRequestErr, "invalid role", "request role is not response")
assert_unchanged(live, Runtime:Snapshot(), "refused request leaves Runtime")

reset()
local coldAgain = Runtime:Snapshot()
local fromWireReq, fromWireReqErr = Snapshot:ApplyResponse("1:SNAPSHOT:request")
assert_eq(fromWireReq, nil, "ApplyResponse refuses a request wire")
assert_eq(fromWireReqErr, "invalid role", "request wire is not response")
assert_unchanged(coldAgain, Runtime:Snapshot(), "refused request wire leaves QUIET")

--------------------------------------------------------------------------------
-- ApplyResponse fail closed: incompatible version. Do not Restore theater.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeForeign = Runtime:Snapshot()
local foreign = "2:SNAPSHOT:response:1:ASSEMBLY::::1"
local foreignMsg, foreignDecErr = Codec:DecodeSnapshot(foreign)
assert_true(foreignMsg ~= nil, "foreign major still decodes")
assert_eq(foreignDecErr, nil, "foreign major is versioned, not garbage")
assert_eq(Codec:IsCompatible(foreignMsg.version), false, "protocol 2 is incompatible")
local foreignApply, foreignErr = Snapshot:ApplyResponse(foreign)
assert_eq(foreignApply, nil, "ApplyResponse refuses an incompatible version")
assert_eq(foreignErr, "protocol mismatch", "incompatible version fails closed")
assert_unchanged(beforeForeign, Runtime:Snapshot(), "incompatible version does not Restore")

reset()
local beforeZero = Runtime:Snapshot()
local zeroApply, zeroErr = Snapshot:ApplyResponse("0:SNAPSHOT:response:1:RITE:Gora::3,4:2")
assert_eq(zeroApply, nil, "ApplyResponse refuses protocol 0")
assert_eq(zeroErr, "protocol mismatch", "protocol 0 is incompatible")
assert_unchanged(beforeZero, Runtime:Snapshot(), "protocol 0 does not Restore")

--------------------------------------------------------------------------------
-- ApplyResponse fail closed: bad decode, SUGGESTION / SYNC_* / other TYPEs.
--------------------------------------------------------------------------------
local function refuse_apply(blob, want, msg)
  local before = Runtime:Snapshot()
  local result, err = Snapshot:ApplyResponse(blob)
  assert_eq(result, nil, msg)
  assert_eq(err, want, (msg or "") .. " err")
  assert_unchanged(before, Runtime:Snapshot(), msg)
end

reset()
Runtime:StartEvent()
Runtime:OpenRite("Confession")

refuse_apply(nil, "empty payload", "nil blob")
refuse_apply("", "empty payload", "empty blob")
refuse_apply("not-a-snapshot", "no protocol version", "garbage blob")
refuse_apply("SNAPSHOT:response:1:ASSEMBLY::::1", "no protocol version", "version-less SNAPSHOT")
refuse_apply("1:SNAPSHOT:ask", "invalid role", "ask is not a role")
refuse_apply("1:SNAPSHOT:REQUEST", "invalid role", "REQUEST is not a role")
refuse_apply("1:SNAPSHOT:reply", "invalid role", "reply is not a role")
refuse_apply("1:SNAPSHOT:response", "invalid event id", "response missing STATE fields")
refuse_apply("1:SNAPSHOT:request:1", "unknown field", "request extra wire field")

refuse_apply("1:SUGGESTION:foo", "unknown message type", "SUGGESTION is not applied")
refuse_apply("1:SYNC_STATE:1:ASSEMBLY::::1", "unknown message type", "SYNC_STATE is not applied")
refuse_apply("1:SYNC_REQUEST", "unknown message type", "SYNC_REQUEST is not applied")
refuse_apply("1:RANK_COMMIT:1:2", "unknown message type", "RANK_COMMIT is not applied")
refuse_apply("1:HELLO", "unknown message type", "HELLO is not applied")
refuse_apply("1:INPUT:petition:3", "unknown message type", "INPUT is not a snapshot")
refuse_apply(Codec:EncodeState({
  eventId = 1,
  state = "ASSEMBLY",
  sequence = 1,
}), "unknown message type", "STATE is not a snapshot response")

--------------------------------------------------------------------------------
-- ApplyResponse fail closed: Codec-valid body that Runtime Restore refuses.
-- Do not invent a third schema; Restore is the Bible-field gate.
--------------------------------------------------------------------------------
refuse_apply("1:SNAPSHOT:response:1:CONSEQUENCE::::1", "rite type required",
  "CONSEQUENCE without a rite type is not restored")
refuse_apply("1:SNAPSHOT:response:1:ASSEMBLY:Gora:::1", "invalid rite type",
  "ASSEMBLY with a rite type is not restored")
refuse_apply("1:SNAPSHOT:response:1:QUIET::5::0", "invalid subjects",
  "QUIET with a candidate is not restored")
refuse_apply("1:SNAPSHOT:response:1:RITE:Builder:::1", "invalid rite type",
  "free-text rite type is not restored")
refuse_apply("1:SNAPSHOT:response:1:AWAITING_POPE::::1", "invalid state",
  "sixth state is not restored")

--------------------------------------------------------------------------------
-- ApplyResponse leftover args are ignored. Failed apply stays inert.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Proclamation")
local srcProc = Runtime:Snapshot()
local procWire = Snapshot:BuildResponse()
reset()
local appliedExtra = Snapshot:ApplyResponse(procWire, { whisper = true }, "GUILD")
assert_eq(appliedExtra, true, "ApplyResponse ignores leftover args")
assert_bible(Runtime:Snapshot(), srcProc, "leftover args still Restore Bible fields")

--------------------------------------------------------------------------------
-- No SendAddonMessage, no frames, no SV write, no peer SYNC on any path.
--------------------------------------------------------------------------------
reset()
ChurchOfBeefDB = { sentinel = 1 }
sent = 0
Snapshot:Request()
assert_eq(Snapshot:BuildResponse(), nil, "cold BuildResponse still fails")
Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 21, 22 } })
local cycle = Snapshot:BuildResponse()
Snapshot:Request()
reset()
Snapshot:ApplyResponse(cycle)
Snapshot:ApplyResponse("1:SNAPSHOT:request")
Snapshot:ApplyResponse("1:SYNC_STATE:1:RITE:Gora::21,22:2")
Snapshot:ApplyResponse("1:SUGGESTION:x")
assert_eq(sent, 0, "Request / BuildResponse / ApplyResponse never send or CreateFrame")
assert_eq(ChurchOfBeefDB.sentinel, 1, "Snapshot does not write ChurchOfBeefDB")
assert_eq(ChurchOfBeefDB.runtime, nil, "Snapshot does not persist the event object")
assert_eq(ChurchOfBeefDB.snapshot, nil, "Snapshot does not invent an SV snapshot key")

--------------------------------------------------------------------------------
-- Closed sets stay on Codec / Runtime. This lane does not add opcodes.
--------------------------------------------------------------------------------
assert_eq(Codec.TYPES.SNAPSHOT, true, "SNAPSHOT stays a Codec type")
assert_eq(Codec.SNAPSHOT_ROLES.request, true, "request stays a Codec role")
assert_eq(Codec.SNAPSHOT_ROLES.response, true, "response stays a Codec role")
assert_eq(Snapshot.TYPES, nil, "Snapshot does not fork TYPES")
assert_eq(Snapshot.SNAPSHOT_ROLES, nil, "Snapshot does not fork roles")
assert_eq(Snapshot.PROTOCOL, nil, "protocol major stays on Codec")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
