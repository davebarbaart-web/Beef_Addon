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

--------------------------------------------------------------------------------
-- B11-A: overlay live / last pair onto the encoded SNAPSHOT only.
-- Stubs stay in-file. Do not dofile Gora.lua / Store / UI.
--------------------------------------------------------------------------------

local function clearPairStubs()
  COB.Gora = nil
  COB.Console = nil
  COB.Knighting = nil
end

local function encode_overlay(snap, fighters, favor)
  local fields = {
    role = "response",
    eventId = snap.eventId,
    state = snap.state,
    riteType = snap.riteType,
    subjects = {
      candidate = snap.subjects and snap.subjects.candidate or nil,
      fighters = fighters,
    },
    sequence = snap.sequence,
  }
  if favor ~= nil then
    fields.favor = favor
  end
  return Codec:EncodeSnapshot(fields)
end

local function encode_candidate(snap, candidate, fighters)
  return Codec:EncodeSnapshot({
    role = "response",
    eventId = snap.eventId,
    state = snap.state,
    riteType = snap.riteType,
    subjects = {
      candidate = candidate,
      fighters = fighters,
    },
    sequence = snap.sequence,
  })
end

local function stubLineHead(humanId)
  COB.Knighting = {
    GetLine = function()
      return { { humanId = humanId } }
    end,
  }
end

-- 1. No Gora / missing methods → today's encode_expected path.
clearPairStubs()
reset()
Runtime:StartEvent()
local noGora = Runtime:Snapshot()
assert_eq(Snapshot:BuildResponse(), encode_expected(noGora), "no Gora matches encode_expected")
assert_unchanged(noGora, Runtime:Snapshot(), "no Gora does not change Runtime")

COB.Gora = {}
assert_eq(Snapshot:BuildResponse(), encode_expected(Runtime:Snapshot()), "Gora without methods matches encode_expected")
assert_unchanged(noGora, Runtime:Snapshot(), "Gora without methods does not change Runtime")

COB.Console = {}
assert_eq(Snapshot:BuildResponse(), encode_expected(Runtime:Snapshot()), "Console without methods matches encode_expected")
clearPairStubs()

reset()
local quietStub = Runtime:Snapshot()
COB.Gora = {
  GetSanctioned = function()
    return { fighterA = 1, fighterB = 2 }
  end,
  GetLastSanctioned = function()
    return { fighterA = 3, fighterB = 4 }
  end,
}
assert_eq(Snapshot:BuildResponse(), nil, "QUIET BuildResponse stays nil with Gora stubs")
assert_eq(select(2, Snapshot:BuildResponse()), "no event", "QUIET with Gora stubs: no event")
assert_unchanged(quietStub, Runtime:Snapshot(), "QUIET with Gora stubs does not change Runtime")
clearPairStubs()

-- 2. Live GetSanctioned + ASSEMBLY + empty Runtime fighters.
reset()
Runtime:StartEvent()
local assemblyEmpty = Runtime:Snapshot()
assert_eq(assemblyEmpty.state, "ASSEMBLY", "StartEvent is ASSEMBLY for live overlay")
assert_eq(assemblyEmpty.subjects.fighters, nil, "ASSEMBLY start has no fighters")
COB.Gora = {
  GetSanctioned = function()
    return { fighterA = 31, fighterB = 32 }
  end,
}
local liveWire = Snapshot:BuildResponse()
assert_eq(liveWire, encode_overlay(assemblyEmpty, { 31, 32 }), "live overlay encodes the sanctioned pair")
assert_unchanged(assemblyEmpty, Runtime:Snapshot(), "live overlay does not change Runtime")
local liveMsg = Codec:DecodeSnapshot(liveWire)
assert_eq(liveMsg.subjects.fighters[1], 31, "live overlay fighter A")
assert_eq(liveMsg.subjects.fighters[2], 32, "live overlay fighter B")
assert_eq(liveMsg.state, "ASSEMBLY", "live overlay keeps ASSEMBLY")
assert_eq(liveMsg.favor, nil, "live overlay omits favor without Console")
assert_true(liveWire ~= encode_expected(assemblyEmpty), "live overlay is not Runtime-only encode")

COB.Console = {
  GetCongregationFavorVisible = function()
    return true
  end,
}
COB.Gora.GetFavorSplit = function()
  return { a = 2, b = 5 }
end
local liveFavWire = Snapshot:BuildResponse()
assert_eq(liveFavWire, encode_overlay(assemblyEmpty, { 31, 32 }, { a = 2, b = 5 }), "live overlay favor when toggle true")
assert_unchanged(assemblyEmpty, Runtime:Snapshot(), "live favor overlay does not change Runtime")
local liveFavMsg = Codec:DecodeSnapshot(liveFavWire)
assert_true(liveFavMsg.favor ~= nil, "live overlay carries favor")
assert_eq(liveFavMsg.favor and liveFavMsg.favor.a, 2, "live favor a")
assert_eq(liveFavMsg.favor and liveFavMsg.favor.b, 5, "live favor b")

COB.Console.GetCongregationFavorVisible = function()
  return false
end
assert_eq(Snapshot:BuildResponse(), encode_overlay(assemblyEmpty, { 31, 32 }), "live overlay toggle false omits favor")
assert_unchanged(assemblyEmpty, Runtime:Snapshot(), "BuildResponse live overlay leaves Runtime empty")
clearPairStubs()

-- B13-A: ApplyResponse of that liveWire Restores fighters and keeps ASSEMBLY.
-- Favor stays off Restore even when the overlay wire carried it.
reset()
assert_eq(Snapshot:ApplyResponse(liveWire), true, "ApplyResponse live ASSEMBLY overlay")
local landedLive = Runtime:Snapshot()
assert_snap_shape(landedLive, "live ASSEMBLY land")
assert_eq(landedLive.state, "ASSEMBLY", "Restore live overlay keeps ASSEMBLY")
assert_eq(landedLive.riteType, nil, "Restore live ASSEMBLY has no rite type")
assert_eq(landedLive.subjects.fighters[1], 31, "Restore live ASSEMBLY fighter A")
assert_eq(landedLive.subjects.fighters[2], 32, "Restore live ASSEMBLY fighter B")
assert_eq(landedLive.subjects.candidate, nil, "Restore live ASSEMBLY has no candidate")
assert_eq(landedLive.eventId, assemblyEmpty.eventId, "Restore live ASSEMBLY event id")
assert_eq(landedLive.sequence, assemblyEmpty.sequence, "Restore live ASSEMBLY sequence")
assert_eq(landedLive.favor, nil, "Restore does not keep favor")
assert_eq(landedLive.role, nil, "Restore does not keep snapshot role")

reset()
assert_eq(Snapshot:ApplyResponse(liveFavWire), true, "ApplyResponse live ASSEMBLY overlay with favor on the wire")
local landedLiveFav = Runtime:Snapshot()
assert_eq(landedLiveFav.state, "ASSEMBLY", "favor-carrying live overlay still lands ASSEMBLY")
assert_eq(landedLiveFav.subjects.fighters[1], 31, "favor-carrying Restore fighter A")
assert_eq(landedLiveFav.subjects.fighters[2], 32, "favor-carrying Restore fighter B")
assert_eq(landedLiveFav.favor, nil, "Restore does not keep favor from live overlay wire")

-- 3. Last pair + CONSEQUENCE + empty Runtime fighters. Favor follows the toggle.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora")
Runtime:CloseRite()
local consEmpty = Runtime:Snapshot()
assert_eq(consEmpty.state, "CONSEQUENCE", "CloseRite without fighters is CONSEQUENCE")
assert_eq(consEmpty.subjects.fighters, nil, "CONSEQUENCE without OpenRite fighters")
COB.Gora = {
  GetSanctioned = function()
    return nil
  end,
  GetLastSanctioned = function()
    return { fighterA = 41, fighterB = 42 }
  end,
  GetLastFavorSplit = function()
    return { a = 3, b = 1 }
  end,
}
COB.Console = {
  GetCongregationFavorVisible = function()
    return true
  end,
}
local lastFavWire = Snapshot:BuildResponse()
assert_eq(lastFavWire, encode_overlay(consEmpty, { 41, 42 }, { a = 3, b = 1 }), "last overlay encodes pair and last favor")
assert_unchanged(consEmpty, Runtime:Snapshot(), "last overlay does not change Runtime")
local lastFavMsg = Codec:DecodeSnapshot(lastFavWire)
assert_eq(lastFavMsg.subjects.fighters[1], 41, "last overlay fighter A")
assert_eq(lastFavMsg.subjects.fighters[2], 42, "last overlay fighter B")
assert_true(lastFavMsg.favor ~= nil, "last overlay carries favor")
assert_eq(lastFavMsg.favor and lastFavMsg.favor.a, 3, "last favor a")
assert_eq(lastFavMsg.favor and lastFavMsg.favor.b, 1, "last favor b")

COB.Console.GetCongregationFavorVisible = function()
  return false
end
local lastOffWire = Snapshot:BuildResponse()
assert_eq(lastOffWire, encode_overlay(consEmpty, { 41, 42 }), "last overlay toggle false omits favor")
assert_eq(Codec:DecodeSnapshot(lastOffWire).favor, nil, "toggle false decoded favor is nil")
assert_eq(Codec:DecodeSnapshot(lastOffWire).subjects.fighters[1], 41, "toggle false still overlays last pair")

COB.Console = nil
assert_eq(Snapshot:BuildResponse(), encode_overlay(consEmpty, { 41, 42 }), "missing Console omits favor")

COB.Console = {
  GetCongregationFavorVisible = function()
    return true
  end,
}
COB.Gora.GetLastFavorSplit = nil
assert_eq(Snapshot:BuildResponse(), encode_overlay(consEmpty, { 41, 42 }), "missing GetLastFavorSplit omits favor")
clearPairStubs()

-- Live pair wins over last pair in CONSEQUENCE when Runtime fighters are missing.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora")
Runtime:CloseRite()
local consLiveWins = Runtime:Snapshot()
COB.Gora = {
  GetSanctioned = function()
    return { fighterA = 61, fighterB = 62 }
  end,
  GetLastSanctioned = function()
    return { fighterA = 41, fighterB = 42 }
  end,
}
assert_eq(Snapshot:BuildResponse(), encode_overlay(consLiveWins, { 61, 62 }), "live pair wins over last pair")
assert_unchanged(consLiveWins, Runtime:Snapshot(), "live-over-last does not change Runtime")
clearPairStubs()

-- 4. Last pair + ASSEMBLY (post-Continue) → no last-pair overlay.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora")
Runtime:CloseRite()
Runtime:Continue()
local postCont = Runtime:Snapshot()
assert_eq(postCont.state, "ASSEMBLY", "Continue returns to ASSEMBLY")
assert_eq(postCont.subjects.fighters, nil, "post-Continue has no fighters")
COB.Gora = {
  GetSanctioned = function()
    return nil
  end,
  GetLastSanctioned = function()
    return { fighterA = 51, fighterB = 52 }
  end,
  GetLastFavorSplit = function()
    return { a = 9, b = 1 }
  end,
}
COB.Console = {
  GetCongregationFavorVisible = function()
    return true
  end,
}
assert_eq(Snapshot:BuildResponse(), encode_expected(postCont), "post-Continue does not overlay last pair")
assert_unchanged(postCont, Runtime:Snapshot(), "post-Continue last pair does not change Runtime")
local postMsg = Codec:DecodeSnapshot(Snapshot:BuildResponse())
assert_eq(#postMsg.subjects.fighters, 0, "post-Continue wire has no fighters")
assert_eq(postMsg.favor, nil, "post-Continue does not invent last favor")
clearPairStubs()

-- 5. Runtime already has two fighters → do not replace them.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 8, 9 } })
local keptRite = Runtime:Snapshot()
COB.Gora = {
  GetSanctioned = function()
    return { fighterA = 71, fighterB = 72 }
  end,
  GetLastSanctioned = function()
    return { fighterA = 81, fighterB = 82 }
  end,
}
assert_eq(Snapshot:BuildResponse(), encode_expected(keptRite), "live pair does not replace Runtime fighters")
assert_unchanged(keptRite, Runtime:Snapshot(), "kept Runtime fighters stay on Runtime")
local keptRiteMsg = Codec:DecodeSnapshot(Snapshot:BuildResponse())
assert_eq(keptRiteMsg.subjects.fighters[1], 8, "kept Runtime fighter A")
assert_eq(keptRiteMsg.subjects.fighters[2], 9, "kept Runtime fighter B")

Runtime:CloseRite()
local keptCons = Runtime:Snapshot()
assert_eq(keptCons.state, "CONSEQUENCE", "CloseRite keeps the rite fighters")
COB.Gora.GetSanctioned = function()
  return nil
end
assert_eq(Snapshot:BuildResponse(), encode_expected(keptCons), "last pair does not replace Runtime fighters")
assert_unchanged(keptCons, Runtime:Snapshot(), "kept CONSEQUENCE fighters stay on Runtime")
local keptConsMsg = Codec:DecodeSnapshot(Snapshot:BuildResponse())
assert_eq(keptConsMsg.subjects.fighters[1], 8, "CONSEQUENCE kept fighter A")
assert_eq(keptConsMsg.subjects.fighters[2], 9, "CONSEQUENCE kept fighter B")
clearPairStubs()

-- 6. ApplyResponse of an overlay wire Restores those fighters. Favor stays off Restore.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora")
Runtime:CloseRite()
COB.Gora = {
  GetSanctioned = function()
    return nil
  end,
  GetLastSanctioned = function()
    return { fighterA = 41, fighterB = 42 }
  end,
  GetLastFavorSplit = function()
    return { a = 3, b = 1 }
  end,
}
COB.Console = {
  GetCongregationFavorVisible = function()
    return true
  end,
}
local overlayWire = Snapshot:BuildResponse()
assert_true(Codec:DecodeSnapshot(overlayWire).favor ~= nil, "overlay wire may carry favor")
clearPairStubs()
reset()
assert_eq(Snapshot:ApplyResponse(overlayWire), true, "ApplyResponse overlay wire")
local landedOverlay = Runtime:Snapshot()
assert_snap_shape(landedOverlay, "overlay land")
assert_eq(landedOverlay.subjects.fighters[1], 41, "Restore overlay fighter A")
assert_eq(landedOverlay.subjects.fighters[2], 42, "Restore overlay fighter B")
assert_eq(landedOverlay.state, "CONSEQUENCE", "Restore overlay keeps CONSEQUENCE")
assert_eq(landedOverlay.favor, nil, "Restore does not keep favor")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora")
COB.Gora = {
  GetSanctioned = function()
    return { fighterA = 31, fighterB = 32 }
  end,
}
local riteOverlay = Snapshot:BuildResponse()
clearPairStubs()
reset()
assert_eq(Snapshot:ApplyResponse(riteOverlay), true, "ApplyResponse live RITE overlay")
assert_eq(Runtime:Snapshot().subjects.fighters[1], 31, "Restore live overlay fighter A")
assert_eq(Runtime:Snapshot().subjects.fighters[2], 32, "Restore live overlay fighter B")
assert_eq(Runtime:Snapshot().state, "RITE", "Restore live overlay keeps RITE")

--------------------------------------------------------------------------------
-- B14-A: overlay Knighting line-head candidate onto the encoded SNAPSHOT only.
-- Stubs stay in-file. Do not dofile Knighting.lua / Gora.lua / Store / UI.
--------------------------------------------------------------------------------

-- 1. No Knighting → existing encode_expected pins still pass.
clearPairStubs()
reset()
Runtime:StartEvent()
local noKnight = Runtime:Snapshot()
assert_eq(Snapshot:BuildResponse(), encode_expected(noKnight), "no Knighting matches encode_expected")
assert_unchanged(noKnight, Runtime:Snapshot(), "no Knighting does not change Runtime")

COB.Knighting = {}
assert_eq(Snapshot:BuildResponse(), encode_expected(Runtime:Snapshot()), "Knighting without GetLine matches encode_expected")
assert_unchanged(noKnight, Runtime:Snapshot(), "Knighting without GetLine does not change Runtime")
clearPairStubs()

reset()
local quietKnight = Runtime:Snapshot()
stubLineHead(77)
assert_eq(Snapshot:BuildResponse(), nil, "QUIET BuildResponse stays nil with Knighting stub")
assert_eq(select(2, Snapshot:BuildResponse()), "no event", "QUIET with Knighting stub: no event")
assert_unchanged(quietKnight, Runtime:Snapshot(), "QUIET with Knighting stub does not change Runtime")
clearPairStubs()

-- 2. ASSEMBLY + empty Runtime candidate + GetLine()[1].humanId == 77.
reset()
Runtime:StartEvent()
local assemblyCand = Runtime:Snapshot()
assert_eq(assemblyCand.state, "ASSEMBLY", "StartEvent is ASSEMBLY for candidate overlay")
assert_eq(assemblyCand.subjects.candidate, nil, "ASSEMBLY start has no candidate")
stubLineHead(77)
local candWire = Snapshot:BuildResponse()
assert_eq(candWire, encode_candidate(assemblyCand, 77), "ASSEMBLY line-head overlay encodes candidate 77")
assert_unchanged(assemblyCand, Runtime:Snapshot(), "ASSEMBLY candidate overlay does not change Runtime")
local candMsg = Codec:DecodeSnapshot(candWire)
assert_eq(candMsg.subjects.candidate, 77, "ASSEMBLY overlay candidate")
assert_eq(candMsg.state, "ASSEMBLY", "ASSEMBLY overlay keeps ASSEMBLY")
assert_eq(candMsg.favor, nil, "ASSEMBLY candidate overlay omits favor")
assert_true(candWire ~= encode_expected(assemblyCand), "ASSEMBLY candidate overlay is not Runtime-only encode")
clearPairStubs()

-- 3. RITE Knighting + empty Runtime candidate + line head → overlay.
reset()
assert_eq(Runtime:Restore({
  eventId = 1,
  state = "RITE",
  riteType = "Knighting",
  subjects = {},
  sequence = 1,
}), true, "empty-candidate RITE Knighting Restore is legal")
local riteKnightEmpty = Runtime:Snapshot()
assert_eq(riteKnightEmpty.state, "RITE", "Restored empty Knighting is RITE")
assert_eq(riteKnightEmpty.riteType, "Knighting", "Restored empty Knighting keeps rite type")
assert_eq(riteKnightEmpty.subjects.candidate, nil, "Restored Knighting candidate is nil")
stubLineHead(77)
local riteCandWire = Snapshot:BuildResponse()
assert_eq(riteCandWire, encode_candidate(riteKnightEmpty, 77), "RITE Knighting line-head overlay encodes candidate 77")
assert_unchanged(riteKnightEmpty, Runtime:Snapshot(), "RITE Knighting candidate overlay does not change Runtime")
assert_eq(Codec:DecodeSnapshot(riteCandWire).subjects.candidate, 77, "RITE Knighting overlay candidate")
assert_eq(Codec:DecodeSnapshot(riteCandWire).riteType, "Knighting", "RITE Knighting overlay keeps rite type")
clearPairStubs()

-- 4. RITE Gora + empty Runtime candidate + line head → no candidate overlay.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora")
local riteGoraEmpty = Runtime:Snapshot()
assert_eq(riteGoraEmpty.state, "RITE", "OpenRite Gora is RITE")
assert_eq(riteGoraEmpty.riteType, "Gora", "OpenRite Gora rite type")
assert_eq(riteGoraEmpty.subjects.candidate, nil, "Gora RITE has no candidate")
stubLineHead(77)
assert_eq(Snapshot:BuildResponse(), encode_expected(riteGoraEmpty), "RITE Gora does not overlay candidate")
assert_unchanged(riteGoraEmpty, Runtime:Snapshot(), "RITE Gora line head does not change Runtime")
assert_eq(Codec:DecodeSnapshot(Snapshot:BuildResponse()).subjects.candidate, nil, "RITE Gora wire has no candidate")
clearPairStubs()

reset()
Runtime:StartEvent()
Runtime:OpenRite("Proclamation")
local riteProcEmpty = Runtime:Snapshot()
stubLineHead(77)
assert_eq(Snapshot:BuildResponse(), encode_expected(riteProcEmpty), "RITE Proclamation does not overlay candidate")
assert_unchanged(riteProcEmpty, Runtime:Snapshot(), "RITE Proclamation line head does not change Runtime")
clearPairStubs()

-- 5. CONSEQUENCE + line head → no candidate overlay.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting")
Runtime:CloseRite()
local consKnight = Runtime:Snapshot()
assert_eq(consKnight.state, "CONSEQUENCE", "CloseRite Knighting is CONSEQUENCE")
assert_eq(consKnight.subjects.candidate, nil, "CONSEQUENCE Knighting has no candidate")
stubLineHead(77)
assert_eq(Snapshot:BuildResponse(), encode_expected(consKnight), "CONSEQUENCE does not overlay candidate")
assert_unchanged(consKnight, Runtime:Snapshot(), "CONSEQUENCE line head does not change Runtime")
assert_eq(Codec:DecodeSnapshot(Snapshot:BuildResponse()).subjects.candidate, nil, "CONSEQUENCE wire has no candidate")
clearPairStubs()

-- 6. Runtime already has candidate 7 + different line head → keep 7.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting", { candidate = 7 })
local keptCand = Runtime:Snapshot()
assert_eq(keptCand.subjects.candidate, 7, "OpenRite Knighting candidate is 7")
stubLineHead(77)
assert_eq(Snapshot:BuildResponse(), encode_expected(keptCand), "line head does not replace Runtime candidate")
assert_unchanged(keptCand, Runtime:Snapshot(), "kept Runtime candidate stays on Runtime")
assert_eq(Codec:DecodeSnapshot(Snapshot:BuildResponse()).subjects.candidate, 7, "kept Runtime candidate on the wire")
clearPairStubs()

-- 7. Live fighter overlay + line head on ASSEMBLY → fighters {31,32} and candidate 77.
reset()
Runtime:StartEvent()
local assemblyBoth = Runtime:Snapshot()
assert_eq(assemblyBoth.subjects.candidate, nil, "ASSEMBLY both-overlay has no candidate")
assert_eq(assemblyBoth.subjects.fighters, nil, "ASSEMBLY both-overlay has no fighters")
COB.Gora = {
  GetSanctioned = function()
    return { fighterA = 31, fighterB = 32 }
  end,
}
stubLineHead(77)
local bothWire = Snapshot:BuildResponse()
assert_eq(bothWire, encode_candidate(assemblyBoth, 77, { 31, 32 }), "ASSEMBLY wire has live fighters and line-head candidate")
assert_unchanged(assemblyBoth, Runtime:Snapshot(), "combined overlay does not change Runtime")
local bothMsg = Codec:DecodeSnapshot(bothWire)
assert_eq(bothMsg.subjects.candidate, 77, "combined overlay candidate")
assert_eq(bothMsg.subjects.fighters[1], 31, "combined overlay fighter A")
assert_eq(bothMsg.subjects.fighters[2], 32, "combined overlay fighter B")
assert_eq(bothMsg.state, "ASSEMBLY", "combined overlay keeps ASSEMBLY")
assert_eq(bothMsg.favor, nil, "combined overlay omits favor without Console")
clearPairStubs()

-- 8. ApplyResponse of a candidate overlay Restores 77, stays ASSEMBLY. Favor nil.
reset()
assert_eq(Snapshot:ApplyResponse(candWire), true, "ApplyResponse ASSEMBLY candidate overlay")
local landedCand = Runtime:Snapshot()
assert_snap_shape(landedCand, "ASSEMBLY candidate land")
assert_eq(landedCand.state, "ASSEMBLY", "Restore candidate overlay keeps ASSEMBLY")
assert_eq(landedCand.riteType, nil, "Restore candidate ASSEMBLY has no rite type")
assert_eq(landedCand.subjects.candidate, 77, "Restore candidate overlay candidate")
assert_eq(landedCand.subjects.fighters, nil, "Restore candidate-only overlay has no fighters")
assert_eq(landedCand.eventId, assemblyCand.eventId, "Restore candidate ASSEMBLY event id")
assert_eq(landedCand.sequence, assemblyCand.sequence, "Restore candidate ASSEMBLY sequence")
assert_eq(landedCand.favor, nil, "Restore does not keep favor")
assert_eq(landedCand.role, nil, "Restore does not keep snapshot role")

reset()
assert_eq(Snapshot:ApplyResponse(bothWire), true, "ApplyResponse combined fighter and candidate overlay")
local landedBoth = Runtime:Snapshot()
assert_eq(landedBoth.state, "ASSEMBLY", "combined Restore keeps ASSEMBLY")
assert_eq(landedBoth.subjects.candidate, 77, "combined Restore candidate")
assert_eq(landedBoth.subjects.fighters[1], 31, "combined Restore fighter A")
assert_eq(landedBoth.subjects.fighters[2], 32, "combined Restore fighter B")
assert_eq(landedBoth.favor, nil, "combined Restore does not keep favor")

if standalone then
  assert_eq(COB.Net, nil, "candidate Apply isolation: no BeefNet")
  assert_eq(COB.Store, nil, "candidate Apply isolation: no Store")
  assert_eq(COB.UI, nil, "candidate Apply isolation: no UI")
end

-- 9. Empty line / missing humanId / GetLine throwing → no overlay, no throw.
reset()
Runtime:StartEvent()
local missLine = Runtime:Snapshot()
COB.Knighting = {
  GetLine = function()
    return {}
  end,
}
assert_eq(Snapshot:BuildResponse(), encode_expected(missLine), "empty line does not overlay candidate")
assert_unchanged(missLine, Runtime:Snapshot(), "empty line does not change Runtime")

COB.Knighting = {
  GetLine = function()
    return { { seq = 1 } }
  end,
}
assert_eq(Snapshot:BuildResponse(), encode_expected(missLine), "missing humanId does not overlay candidate")
assert_unchanged(missLine, Runtime:Snapshot(), "missing humanId does not change Runtime")

COB.Knighting = {
  GetLine = function()
    error("GetLine failed")
  end,
}
local throwOk, throwWire, throwErr = pcall(function()
  return Snapshot:BuildResponse()
end)
assert_eq(throwOk, true, "GetLine throw does not throw from BuildResponse")
assert_eq(throwErr, nil, "GetLine throw BuildResponse has no error")
assert_eq(throwWire, encode_expected(missLine), "GetLine throw does not overlay candidate")
assert_unchanged(missLine, Runtime:Snapshot(), "GetLine throw does not change Runtime")
clearPairStubs()

--------------------------------------------------------------------------------
-- B38-B: last-pair overlay is Gora CONSEQUENCE only. Live GetSanctioned stays.
-- Candidate overlay stays B14-A. Existing Gora CONSEQUENCE last pins stay.
--------------------------------------------------------------------------------

-- Existing Gora empty CONSEQUENCE + GetLastSanctioned still overlays.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora")
Runtime:CloseRite()
local goraLastStay = Runtime:Snapshot()
assert_eq(goraLastStay.state, "CONSEQUENCE", "Gora CloseRite is CONSEQUENCE")
assert_eq(goraLastStay.riteType, "Gora", "Gora CONSEQUENCE rite type")
assert_eq(goraLastStay.subjects.fighters, nil, "Gora CONSEQUENCE without OpenRite fighters")
COB.Gora = {
  GetSanctioned = function()
    return nil
  end,
  GetLastSanctioned = function()
    return { fighterA = 41, fighterB = 42 }
  end,
}
assert_eq(Snapshot:BuildResponse(), encode_overlay(goraLastStay, { 41, 42 }), "Gora CONSEQUENCE still overlays last pair")
assert_unchanged(goraLastStay, Runtime:Snapshot(), "Gora last overlay does not change Runtime")
local goraLastStayMsg = Codec:DecodeSnapshot(Snapshot:BuildResponse())
assert_eq(goraLastStayMsg.subjects.fighters[1], 41, "Gora last overlay fighter A")
assert_eq(goraLastStayMsg.subjects.fighters[2], 42, "Gora last overlay fighter B")
clearPairStubs()

-- Knighting CONSEQUENCE + last pair stub does not overlay leftover fighters.
reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting")
Runtime:CloseRite()
local knightLastRefuse = Runtime:Snapshot()
assert_eq(knightLastRefuse.state, "CONSEQUENCE", "Knighting CloseRite is CONSEQUENCE")
assert_eq(knightLastRefuse.riteType, "Knighting", "Knighting CONSEQUENCE rite type")
assert_eq(knightLastRefuse.subjects.fighters, nil, "Knighting CONSEQUENCE has no fighters")
COB.Gora = {
  GetSanctioned = function()
    return nil
  end,
  GetLastSanctioned = function()
    return { fighterA = 41, fighterB = 42 }
  end,
  GetLastFavorSplit = function()
    return { a = 3, b = 1 }
  end,
}
COB.Console = {
  GetCongregationFavorVisible = function()
    return true
  end,
}
assert_eq(Snapshot:BuildResponse(), encode_expected(knightLastRefuse), "Knighting CONSEQUENCE does not overlay last pair")
assert_unchanged(knightLastRefuse, Runtime:Snapshot(), "Knighting last pair stub does not change Runtime")
local knightLastMsg = Codec:DecodeSnapshot(Snapshot:BuildResponse())
assert_eq(#knightLastMsg.subjects.fighters, 0, "Knighting CONSEQUENCE wire has no leftover fighters")
assert_eq(knightLastMsg.favor, nil, "Knighting CONSEQUENCE does not invent last favor")
clearPairStubs()

clearPairStubs()
if standalone then
  assert_eq(COB.Net, nil, "isolation wrap stays: no BeefNet")
  assert_eq(COB.Store, nil, "isolation wrap stays: no Store")
  assert_eq(COB.UI, nil, "isolation wrap stays: no UI")
  assert_eq(COB.DB, nil, "isolation wrap stays: no DB")
  assert_eq(COB.Gora, nil, "isolation wrap stays: Gora stub cleared")
  assert_eq(COB.Console, nil, "isolation wrap stays: Console stub cleared")
  assert_eq(COB.Knighting, nil, "isolation wrap stays: Knighting stub cleared")
end

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
