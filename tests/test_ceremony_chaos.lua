-- Ceremony chaos (Phase 3 Lane F). Isolated: Common + Runtime + Codec + Snapshot + Sender.
-- Compose signed APIs only. No new verbs, TYPEs, snapshot fields, holdSeconds, or Pope list.
-- §20.4 quality bar: five / thirty is not a timer. No SendAddonMessage. No BeefNet.
-- Do not load TOC / bootstrap / run.lua / Store / UI / Data/Popes.lua.
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

local COB = ChurchOfBeef
local Runtime = COB.Runtime
local Codec = COB.Codec
local Snapshot = COB.Snapshot
local Sender = COB.Sender

local sent = 0
local framed = 0
local guildReads = 0

SendAddonMessage = function()
  sent = sent + 1
end
C_ChatInfo = {
  SendAddonMessage = function()
    sent = sent + 1
  end,
}
CreateFrame = function()
  framed = framed + 1
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

local THEATER_KINDS = {
  "STATE",
  "SNAPSHOT",
  "THEATER",
  "PROCLAMATION",
  "Proclamation",
  "SANCTION",
  "VERDICT",
  "KNIGHTING",
  "Knighting",
  "HUD",
  "RITE",
  "CONSEQUENCE",
  "ASSEMBLY",
  "HELLO",
  "SUGGESTION",
  "SYNC_STATE",
  "SYNC_REQUEST",
  "RANK_COMMIT",
}

local function reset()
  assert_eq(Runtime:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
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

--------------------------------------------------------------------------------
-- Isolated surface: compose signed APIs. Not transport, not a Pope list.
--------------------------------------------------------------------------------
assert_true(Runtime ~= nil, "Runtime is loaded")
assert_true(Codec ~= nil, "Codec is loaded")
assert_true(Snapshot ~= nil, "Snapshot is loaded")
assert_true(Sender ~= nil, "Sender is loaded")
assert_true(COB.Names ~= nil, "Common name law is loaded")

if standalone then
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Ranks, nil, "isolated suite does not load Ranks")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
end

assert_eq(Runtime.holdSeconds, nil, "Runtime does not invent holdSeconds")
assert_eq(Snapshot.holdSeconds, nil, "Snapshot does not invent holdSeconds")
assert_eq(Sender.holdSeconds, nil, "Sender does not invent holdSeconds")
assert_eq(Codec.holdSeconds, nil, "Codec does not invent holdSeconds")
assert_eq(Runtime.Hold, nil, "no hold timer")
assert_eq(Snapshot.Whisper, nil, "no whisper routing")
assert_eq(Sender.Whisper, nil, "no whisper send")
assert_eq(Runtime.Promote, nil, "no Promote")
assert_eq(Runtime.TakeOver, nil, "no TakeOver")
assert_eq(Runtime.Grant, nil, "no Grant")
assert_eq(Runtime.Narrate, nil, "no Narrate")
assert_eq(Runtime.AutoAdvance, nil, "no AutoAdvance")
assert_eq(Runtime.Declare, nil, "no Declare")
assert_eq(Sender.RegisterPope, nil, "no RegisterPope")
assert_eq(Sender.IsPope, nil, "no IsPope list")
assert_eq(Snapshot.RegisterPope, nil, "Snapshot has no Pope list")

--------------------------------------------------------------------------------
-- Late arrival: Event Mode on Runtime; Request() does not change it;
-- BuildResponse(); ResetForTests; ApplyResponse lands Bible fields.
-- QUIET BuildResponse is nil, err.
--------------------------------------------------------------------------------
reset()
local quietCold = Runtime:Snapshot()
assert_eq(quietCold.state, "QUIET", "late arrival starts from Quiet Mode")
local quietBlob, quietErr = Snapshot:BuildResponse()
assert_eq(quietBlob, nil, "QUIET BuildResponse is nil")
assert_eq(quietErr, "no event", "QUIET BuildResponse err")
assert_unchanged(quietCold, Runtime:Snapshot(), "QUIET BuildResponse")

Runtime:StartEvent()
Runtime:OpenRite("Gora", { candidate = 9, fighters = { 3, 4 } })
local popeLive = Runtime:Snapshot()
assert_eq(popeLive.state, "RITE", "late arrival Pope is Event Mode")
assert_eq(popeLive.riteType, "Gora", "late arrival Pope is mid-rite")

sent = 0
local req, reqErr = Snapshot:Request()
assert_true(req ~= nil, "Request encodes")
assert_eq(reqErr, nil, "Request has no error")
assert_eq(req, "2:SNAPSHOT:request", "Request wire is role only")
assert_unchanged(popeLive, Runtime:Snapshot(), "Request does not change Event Mode")
assert_eq(sent, 0, "Request does not SendAddonMessage")

local catchup, catchErr = Snapshot:BuildResponse()
assert_true(catchup ~= nil, "BuildResponse from Event Mode encodes")
assert_eq(catchErr, nil, "successful BuildResponse has no error")
assert_unchanged(popeLive, Runtime:Snapshot(), "BuildResponse does not change Event Mode")

reset()
local coldClient = Runtime:Snapshot()
assert_eq(coldClient.state, "QUIET", "ResetForTests is a cold client")
local landed, landErr = Snapshot:ApplyResponse(catchup)
assert_eq(landed, true, "ApplyResponse lands the late arrival")
assert_eq(landErr, nil, "successful ApplyResponse has no error")
assert_bible(Runtime:Snapshot(), popeLive, "late arrival lands Bible fields")
assert_eq(Runtime:Snapshot().state, "RITE", "late arrival lands mid-rite")
assert_eq(Runtime:Snapshot().riteType, "Gora", "late arrival keeps the rite type")
assert_eq(Runtime:Snapshot().subjects.candidate, 9, "late arrival keeps the candidate")
assert_eq(Runtime:Snapshot().subjects.fighters[1], 3, "late arrival keeps fighter 1")
assert_eq(Runtime:Snapshot().subjects.fighters[2], 4, "late arrival keeps fighter 2")
assert_eq(Runtime:Snapshot().sequence, popeLive.sequence, "late arrival resumes sequence")

reset()
Runtime:StartEvent()
local ended = Runtime:EndEvent()
assert_eq(ended.state, "QUIET", "EndEvent returns to QUIET")
local endedBlob, endedErr = Snapshot:BuildResponse()
assert_eq(endedBlob, nil, "ended QUIET BuildResponse is nil")
assert_eq(endedErr, "no event", "ended QUIET has nothing to catch up to")

--------------------------------------------------------------------------------
-- Reload / mid-rite reload: same event id / state / rite / subjects / sequence
-- after ApplyResponse. awaitingPope round-trips on Runtime Restore when set;
-- BuildResponse / ApplyResponse must not put awaitingPope on the wire.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting", { candidate = 7 })
local midRite = Runtime:Snapshot()
assert_eq(midRite.state, "RITE", "mid-rite reload source is RITE")
local reloadWire = Snapshot:BuildResponse()
reset()
assert_eq(Snapshot:ApplyResponse(reloadWire), true, "mid-rite ApplyResponse")
assert_bible(Runtime:Snapshot(), midRite, "mid-rite reload resumes Bible fields")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Confession")
Runtime:CloseRite()
local consSnap = Runtime:Snapshot()
assert_eq(consSnap.state, "CONSEQUENCE", "reload from CONSEQUENCE")
local consWire = Snapshot:BuildResponse()
reset()
assert_eq(Snapshot:ApplyResponse(consWire), true, "CONSEQUENCE ApplyResponse")
assert_bible(Runtime:Snapshot(), consSnap, "CONSEQUENCE reload resumes Bible fields")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Proclamation", { candidate = 11 })
local parked = Runtime:Snapshot()
reset()
assert_eq(Runtime:Restore(parked), true, "Runtime Restore mid-rite")
assert_bible(Runtime:Snapshot(), parked, "Runtime Restore resumes Bible fields")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 1, 2 } })
Runtime:MarkPopeLost()
local degraded = Runtime:Snapshot()
assert_eq(degraded.awaitingPope, true, "degraded Snapshot carries awaitingPope")
assert_eq(degraded.state, "RITE", "degraded mid-rite is still RITE")

local degradedWire = Snapshot:BuildResponse()
local degradedMsg = Codec:DecodeSnapshot(degradedWire)
assert_eq(degradedMsg.awaitingPope, nil, "BuildResponse does not put awaitingPope on the wire")
assert_eq(degradedMsg.eventId, degraded.eventId, "wire keeps event id")
assert_eq(degradedMsg.state, "RITE", "wire keeps RITE")
assert_eq(degradedMsg.riteType, "Gora", "wire keeps the rite type")
assert_eq(degradedMsg.sequence, degraded.sequence, "wire keeps sequence")

reset()
assert_eq(Snapshot:ApplyResponse(degradedWire), true, "ApplyResponse of a degraded rite")
local fromWire = Runtime:Snapshot()
assert_bible(fromWire, degraded, "ApplyResponse resumes Bible fields")
assert_eq(fromWire.awaitingPope, nil, "ApplyResponse does not Restore awaitingPope from the wire")

reset()
assert_eq(Runtime:Restore(degraded), true, "Runtime Restore keeps awaitingPope when set")
local fromRestore = Runtime:Snapshot()
assert_bible(fromRestore, degraded, "Runtime Restore resumes Bible fields")
assert_eq(fromRestore.awaitingPope, true, "awaitingPope round-trips on Runtime Restore")

--------------------------------------------------------------------------------
-- Pope disconnect: MarkPopeLost holds last state; not AWAITING_POPE;
-- no Promote / TakeOver; ClearPopeLost is not a transition;
-- EndEvent is not automatic.
--------------------------------------------------------------------------------
reset()
assert_eq(Runtime.Promote, nil, "no Promote on disconnect")
assert_eq(Runtime.PromoteSelf, nil, "no PromoteSelf")
assert_eq(Runtime.TakeOver, nil, "no TakeOver")
assert_eq(Runtime.AssumePope, nil, "no AssumePope")
assert_eq(Runtime.AutoEndEvent, nil, "no AutoEndEvent")
assert_eq(Sender.Promote, nil, "Sender has no Promote")
assert_eq(Snapshot.TakeOver, nil, "Snapshot has no TakeOver")

local lostQuiet, lostQuietErr = Runtime:MarkPopeLost()
assert_eq(lostQuiet, nil, "MarkPopeLost from QUIET refuses")
assert_eq(type(lostQuietErr), "string", "MarkPopeLost from QUIET returns err")
assert_eq(Runtime:Snapshot().state, "QUIET", "QUIET MarkPopeLost is not a sixth state")

Runtime:StartEvent()
Runtime:OpenRite("Confession", { candidate = 5 })
local beforeLost = Runtime:Snapshot()
local lost, lostErr = Runtime:MarkPopeLost()
assert_true(lost ~= nil, "MarkPopeLost from RITE holds")
assert_eq(lostErr, nil, "successful MarkPopeLost has no error")
assert_eq(lost.state, "RITE", "MarkPopeLost holds last state")
assert_eq(lost.state, beforeLost.state, "MarkPopeLost is not AWAITING_POPE")
assert_eq(lost.riteType, "Confession", "MarkPopeLost keeps the rite type")
assert_eq(lost.eventId, beforeLost.eventId, "MarkPopeLost keeps the event id")
assert_eq(lost.sequence, beforeLost.sequence, "MarkPopeLost is not a transition")
assert_eq(lost.subjects.candidate, 5, "MarkPopeLost keeps subjects")
assert_eq(lost.awaitingPope, true, "MarkPopeLost sets awaitingPope")
assert_eq(Runtime:Snapshot().state, "RITE", "EndEvent is not automatic after MarkPopeLost")
assert_eq(Runtime:Snapshot().riteType, "Confession", "MarkPopeLost does not close the rite")

local stillRite, endFromRiteErr = Runtime:EndEvent()
assert_eq(stillRite, nil, "EndEvent from RITE stays explicit and illegal")
assert_eq(type(endFromRiteErr), "string", "EndEvent from RITE returns err")
assert_eq(Runtime:Snapshot().state, "RITE", "failed EndEvent leaves the rite")

local cleared, clearErr = Runtime:ClearPopeLost()
assert_true(cleared ~= nil, "ClearPopeLost runs")
assert_eq(clearErr, nil, "successful ClearPopeLost has no error")
assert_eq(cleared.state, "RITE", "ClearPopeLost is not a transition")
assert_eq(cleared.sequence, beforeLost.sequence, "ClearPopeLost does not increment sequence")
assert_eq(cleared.awaitingPope, nil, "ClearPopeLost clears the flag")
assert_eq(cleared.riteType, "Confession", "ClearPopeLost keeps the rite")

reset()
Runtime:StartEvent()
local assembly = Runtime:Snapshot()
Runtime:MarkPopeLost()
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "MarkPopeLost from ASSEMBLY holds ASSEMBLY")
assert_eq(Runtime:Snapshot().sequence, assembly.sequence, "ASSEMBLY MarkPopeLost is not a transition")
assert_eq(Runtime:Snapshot().state ~= "QUIET", true, "EndEvent is not automatic from ASSEMBLY")
local endedByPope = Runtime:EndEvent()
assert_eq(endedByPope.state, "QUIET", "EndEvent remains a Pope verb")

--------------------------------------------------------------------------------
-- No-show petitioner: Accept(sender, "INPUT") may be true;
-- Runtime does not auto-advance, auto-open, or auto-end.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local waiting = Runtime:Snapshot()
assert_eq(waiting.state, "ASSEMBLY", "no-show waits in ASSEMBLY")
assert_eq(Sender:Accept("NoShow", "INPUT"), true, "Accept INPUT from a no-show may be true")
assert_eq(Sender:IsRegisteredPope("NoShow"), false, "an INPUT sender is not a registered Pope")
assert_unchanged(waiting, Runtime:Snapshot(), "Accept INPUT does not change Runtime")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "no-show does not auto-open a rite")
assert_eq(Runtime:Snapshot().riteType, nil, "no-show does not invent a rite type")

local inputWire, inputErr = Codec:EncodeInput({ kind = "petition", characterId = 12 })
assert_true(inputWire ~= nil, "a no-show petition still encodes as INPUT")
assert_eq(inputErr, nil, "petition encode has no error")
assert_eq(Codec:DecodeInput(inputWire).type, "INPUT", "petition is INPUT, not theater")
assert_unchanged(waiting, Runtime:Snapshot(), "EncodeInput does not change Runtime")

local appliedInput, appliedInputErr = Snapshot:ApplyResponse(inputWire)
assert_eq(appliedInput, nil, "INPUT does not Apply as a snapshot")
assert_eq(type(appliedInputErr), "string", "INPUT Apply returns err")
assert_unchanged(waiting, Runtime:Snapshot(), "refused INPUT Apply leaves ASSEMBLY")

--------------------------------------------------------------------------------
-- Disputed outcome: no Grant / Narrate / AutoAdvance / Declare;
-- CloseRite / Continue / EndEvent stay explicit.
--------------------------------------------------------------------------------
reset()
assert_eq(Runtime.Grant, nil, "no Grant")
assert_eq(Runtime.GrantGora, nil, "no GrantGora")
assert_eq(Runtime.Narrate, nil, "no Narrate")
assert_eq(Runtime.AutoAdvance, nil, "no AutoAdvance")
assert_eq(Runtime.Declare, nil, "no Declare")
assert_eq(Runtime.DeclareVictor, nil, "no DeclareVictor")
assert_eq(Snapshot.Grant, nil, "Snapshot has no Grant")
assert_eq(Sender.Narrate, nil, "Sender has no Narrate")
assert_eq(Codec.AutoAdvance, nil, "Codec has no AutoAdvance")
assert_eq(type(Runtime.CloseRite), "function", "CloseRite stays explicit")
assert_eq(type(Runtime.Continue), "function", "Continue stays explicit")
assert_eq(type(Runtime.EndEvent), "function", "EndEvent stays explicit")

Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 5, 6 } })
local disputed = Runtime:Snapshot()
assert_eq(disputed.state, "RITE", "disputed fight is still RITE")
assert_eq(Runtime:Snapshot().state, "RITE", "nothing auto-declares a Gora")
assert_eq(Runtime:CloseRite().state, "CONSEQUENCE", "CloseRite is the explicit close")
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "CONSEQUENCE does not auto-Continue")
assert_eq(Runtime:Snapshot().riteType, "Gora", "disputed CONSEQUENCE keeps the rite")
assert_eq(Runtime:Continue().state, "ASSEMBLY", "Continue is the explicit next assembly")
assert_eq(Runtime:Snapshot().riteType, nil, "Continue clears the rite")
assert_eq(Runtime:EndEvent().state, "QUIET", "EndEvent is the explicit end")

--------------------------------------------------------------------------------
-- Spoofed senders: IsRegisteredPope always false;
-- Accept false for STATE / SNAPSHOT / theater.
--------------------------------------------------------------------------------
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "a named sender is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("Pope"), false, "the name Pope is not a registered Pope")
assert_eq(Sender:IsRegisteredPope("GM"), false, "GM is not a registered Pope")
assert_eq(Sender:IsRegisteredPope(nil), false, "missing sender is not a registered Pope")
assert_eq(COB.Popes, nil, "no COB.Popes (#8 is not coded)")
assert_eq(Sender.popes, nil, "no pope table")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting", { candidate = 2 })
local beforeSpoof = Runtime:Snapshot()
local popeBlob = Snapshot:BuildResponse()

for i = 1, #THEATER_KINDS do
  local kind = THEATER_KINDS[i]
  assert_eq(Sender:Accept("Spoof", kind), false, kind .. " from a spoofed sender is discarded")
  assert_eq(Sender:IsRegisteredPope("Spoof"), false, "IsRegisteredPope stays false after " .. kind)
end
assert_eq(Sender:Accept("Spoof", "STATE"), false, "STATE from a spoof is discarded")
assert_eq(Sender:Accept("Spoof", "SNAPSHOT"), false, "SNAPSHOT from a spoof is discarded")
assert_unchanged(beforeSpoof, Runtime:Snapshot(), "spoofed Accept does not change Runtime")
assert_eq(Sender.discarded, nil, "rejected theater is not stored for later paint")

-- Leftover: ApplyResponse has no sender argument. Accept is the gate; Apply is ungated.
assert_eq(Sender:Accept("Spoof", "SNAPSHOT"), false, "Net must refuse this sender")
reset()
assert_eq(Snapshot:ApplyResponse(popeBlob), true, "ApplyResponse is ungated if called without Accept")
assert_eq(Runtime:Snapshot().state, "RITE", "ungated Apply still Restores Bible fields")

--------------------------------------------------------------------------------
-- Version skew: ApplyResponse of a foreign-major SNAPSHOT fails closed;
-- Event chrome drops to Quiet presentation. Do not add a Quiet toast.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Proclamation")
local beforeSkew = Runtime:Snapshot()
assert_eq(beforeSkew.state, "RITE", "skew starts from a live rite")
assert_eq(Runtime.Toast, nil, "Runtime has no toast")
assert_eq(Runtime.WarnVersion, nil, "Runtime has no WarnVersion")
assert_eq(Runtime._WarnVersion, nil, "Runtime has no _WarnVersion")
assert_eq(Snapshot.Toast, nil, "Snapshot has no toast")
assert_eq(Sender.Notify, nil, "Sender has no Notify")
assert_eq(Codec.Toast, nil, "Codec has no toast")

local foreign = "1:SNAPSHOT:response:1:ASSEMBLY::::1"
local foreignMsg, foreignDecErr = Codec:DecodeSnapshot(foreign)
assert_true(foreignMsg ~= nil, "foreign major still decodes")
assert_eq(foreignDecErr, nil, "foreign major is versioned, not garbage")
assert_eq(Codec:IsCompatible(foreignMsg.version), false, "protocol 1 is incompatible")
local foreignApply, foreignErr = Snapshot:ApplyResponse(foreign)
assert_eq(foreignApply, nil, "ApplyResponse refuses an incompatible version")
assert_eq(foreignErr, "protocol mismatch", "incompatible version fails closed")
local afterSkew = Runtime:Snapshot()
assert_eq(afterSkew.state, "QUIET", "version skew drops the live rite")
assert_eq(afterSkew.state == "QUIET", true, "this lane does drop to Quiet presentation")
assert_eq(afterSkew.eventId, nil, "foreign-major SNAPSHOT does not Restore")
assert_eq(afterSkew.riteType, nil, "foreign-major SNAPSHOT does not keep the rite")
assert_eq(afterSkew.sequence, 0, "foreign-major SNAPSHOT Restores clean QUIET")

local zeroApply, zeroErr = Snapshot:ApplyResponse("0:SNAPSHOT:response:1:RITE:Gora::3,4:2")
assert_eq(zeroApply, nil, "ApplyResponse refuses protocol 0")
assert_eq(zeroErr, "protocol mismatch", "protocol 0 is incompatible")
assert_eq(Runtime:Snapshot().state, "QUIET", "protocol 0 stays Quiet")
assert_eq(Runtime:Snapshot().riteType, nil, "protocol 0 does not Restore")

--------------------------------------------------------------------------------
-- Floods: many INPUT Accepts do not change Runtime and do not encode theater.
-- SUGGESTION / SYNC_* / HELLO do not Apply.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local beforeFlood = Runtime:Snapshot()
for i = 1, 40 do
  assert_eq(Sender:Accept("Petitioner" .. i, "INPUT"), true, "flood INPUT " .. i .. " may Accept")
end
assert_unchanged(beforeFlood, Runtime:Snapshot(), "flooded INPUT Accepts do not change Runtime")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "floods do not auto-open a rite")

local petition = Codec:EncodeInput({ kind = "petition", characterId = 1 })
local favor = Codec:EncodeInput({ kind = "favor", characterId = 2, pick = 1 })
local confession = Codec:EncodeInput({ kind = "confession", characterId = 3, text = "free text" })
assert_eq(Codec:Decode(petition).type, "INPUT", "flood petition is INPUT")
assert_eq(Codec:Decode(favor).type, "INPUT", "flood favor is INPUT")
assert_eq(Codec:Decode(confession).type, "INPUT", "flood confession is INPUT")
assert_eq(Codec:Decode(petition).state, nil, "INPUT does not encode theater state")
assert_eq(type(Codec.EncodeState), "function", "EncodeState stays a Codec verb")
assert_eq(type(Codec.EncodeInput), "function", "EncodeInput stays a Codec verb")
assert_unchanged(beforeFlood, Runtime:Snapshot(), "EncodeInput floods do not change Runtime")

local function refuse_apply(blob, want, msg)
  local before = Runtime:Snapshot()
  local result, err = Snapshot:ApplyResponse(blob)
  assert_eq(result, nil, msg)
  assert_eq(err, want, (msg or "") .. " err")
  assert_unchanged(before, Runtime:Snapshot(), msg)
end

refuse_apply(petition, "unknown message type", "INPUT petition does not Apply")
refuse_apply(favor, "unknown message type", "INPUT favor does not Apply")
refuse_apply("1:SUGGESTION:foo", "unknown message type", "SUGGESTION does not Apply")
refuse_apply("1:SYNC_STATE:1:ASSEMBLY::::1", "unknown message type", "SYNC_STATE does not Apply")
refuse_apply("1:SYNC_REQUEST", "unknown message type", "SYNC_REQUEST does not Apply")
refuse_apply("2:HELLO", "unknown message type", "HELLO does not Apply")
refuse_apply("1:RANK_COMMIT:1:2", "unknown message type", "RANK_COMMIT does not Apply")
assert_unchanged(beforeFlood, Runtime:Snapshot(), "retired TYPEs do not Apply")

--------------------------------------------------------------------------------
-- Latest-wins: ceremony applies only if sequence is greater (same eventId).
-- Older Apply/Restore do not rewind. Equal sequence does not apply ceremony.
-- Different eventId still applies. Equal sequence must not fire theater.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local earlySnap = Runtime:Snapshot()
local earlyWire = Snapshot:BuildResponse()
assert_eq(earlySnap.sequence, 1, "early ASSEMBLY sequence is 1")
Runtime:OpenRite("Gora", { fighters = { 8, 9 } })
Runtime:CloseRite()
local laterSnap = Runtime:Snapshot()
assert_eq(laterSnap.sequence, 3, "later CONSEQUENCE sequence is 3")
assert_eq(laterSnap.state, "CONSEQUENCE", "later state is CONSEQUENCE")
assert_eq(laterSnap.riteType, "Gora", "later rite is Gora")

local proclaims = 0
local sounds = 0
COB.Toasts = {
  Proclaim = function()
    proclaims = proclaims + 1
  end,
}
COB.Sound = {
  Play = function()
    sounds = sounds + 1
  end,
}

local replayed, replayErr = Snapshot:ApplyResponse(earlyWire)
assert_eq(replayed, nil, "older Apply does not rewind")
assert_eq(type(replayErr), "string", "older Apply is not-ok")
local afterOlder = Runtime:Snapshot()
assert_eq(afterOlder.sequence, 3, "older Apply leaves later sequence")
assert_eq(afterOlder.state, "CONSEQUENCE", "older Apply leaves later state")
assert_eq(afterOlder.riteType, "Gora", "older Apply leaves the later rite")
assert_bible(afterOlder, laterSnap, "ceremony requires a greater sequence")

assert_eq(Runtime:Restore(laterSnap), true, "Restore of the later object succeeds")
assert_eq(Runtime:Snapshot().sequence, 3, "later Restore returns to sequence 3")
local olderRestore, olderRestoreErr = Runtime:Restore(earlySnap)
assert_eq(olderRestore, nil, "older Restore does not rewind")
assert_eq(type(olderRestoreErr), "string", "older Restore is not-ok")
assert_eq(Runtime:Snapshot().sequence, 3, "older Restore leaves later sequence")
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "older Restore leaves later state")
assert_eq(Runtime:Snapshot().riteType, "Gora", "older Restore leaves the later rite")

local hijack = {
  eventId = laterSnap.eventId,
  state = laterSnap.state,
  riteType = laterSnap.riteType,
  subjects = { candidate = laterSnap.subjects.candidate, fighters = { 1, 2 } },
  sequence = laterSnap.sequence,
}
assert_eq(Runtime:Restore(hijack), true, "equal-sequence Restore returns ok")
assert_eq(Runtime:Snapshot().subjects.fighters[1], 8, "equal sequence does not replace fighters")
assert_eq(Runtime:Snapshot().subjects.fighters[2], 9, "equal sequence keeps later fighters")
assert_bible(Runtime:Snapshot(), laterSnap, "equal sequence does not apply ceremony")

local sameWire = Snapshot:BuildResponse()
assert_eq(Snapshot:ApplyResponse(sameWire), true, "equal-sequence Apply returns ok")
assert_bible(Runtime:Snapshot(), laterSnap, "equal-sequence Apply does not move ceremony")
assert_eq(proclaims, 0, "equal sequence does not Proclaim")
assert_eq(sounds, 0, "equal sequence does not Sound")

local otherEvent = {
  eventId = (laterSnap.eventId or 1) + 1,
  state = "ASSEMBLY",
  riteType = nil,
  subjects = { candidate = nil, fighters = nil },
  sequence = 1,
}
assert_eq(Runtime:Restore(otherEvent), true, "different eventId still applies")
assert_eq(Runtime:Snapshot().eventId, otherEvent.eventId, "different eventId lands")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "different eventId applies ceremony")
assert_eq(Runtime:Snapshot().sequence, 1, "new event keeps its own sequence")

COB.Toasts = nil
COB.Sound = nil

--------------------------------------------------------------------------------
-- No SendAddonMessage, no frames, no guild-rank Pope, no SV write.
--------------------------------------------------------------------------------
reset()
ChurchOfBeefDB = { sentinel = 1 }
sent = 0
framed = 0
guildReads = 0
Snapshot:Request()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 21, 22 } })
Runtime:MarkPopeLost()
local cycle = Snapshot:BuildResponse()
Sender:Accept("Flood", "INPUT")
Sender:Accept("Spoof", "STATE")
Sender:IsRegisteredPope("Pope")
reset()
Snapshot:ApplyResponse(cycle)
Snapshot:ApplyResponse("1:SNAPSHOT:response:1:ASSEMBLY::::1")
Snapshot:ApplyResponse("2:HELLO")
assert_eq(sent, 0, "chaos paths never SendAddonMessage")
assert_eq(framed, 0, "chaos paths never CreateFrame")
assert_eq(guildReads, 0, "Sender does not read guild rank")
assert_eq(ChurchOfBeefDB.sentinel, 1, "chaos paths do not write ChurchOfBeefDB")
assert_eq(ChurchOfBeefDB.runtime, nil, "Runtime does not persist the event object")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
