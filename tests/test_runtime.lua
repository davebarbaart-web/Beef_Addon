-- Ceremony runtime (Phase 3 Lanes A + E). Isolated: Common + Runtime.
-- No TOC / bootstrap / run.lua / Store / Archive / Recognition / BeefNet / UI.
-- Pope verbs only. No auto-advance, narration, SV persist, frames, or Net.
-- Lane E: awaitingPope degrade flag. Not a sixth state. No holdSeconds / toast.
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

local COB = ChurchOfBeef
local Runtime = COB.Runtime

local SNAP_KEYS = {
  eventId = true,
  state = true,
  riteType = true,
  subjects = true,
  sequence = true,
  awaitingPope = true,
}

local SUBJECT_KEYS = {
  candidate = true,
  fighters = true,
}

local unpack = unpack or table.unpack
local RITE_TYPES = { "Knighting", "Gora", "Confession", "Proclamation" }

local function reset()
  assert_eq(Runtime:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
end

local function isInt(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
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

local function assert_unchanged(before, after, msg)
  assert_eq(after.state, before.state, (msg or "state") .. " is unchanged")
  assert_eq(after.eventId, before.eventId, (msg or "event id") .. " is unchanged")
  assert_eq(after.riteType, before.riteType, (msg or "rite type") .. " is unchanged")
  assert_eq(after.sequence, before.sequence, (msg or "sequence") .. " is unchanged")
  assert_eq(after.subjects.candidate, before.subjects.candidate, (msg or "candidate") .. " is unchanged")
  assert_eq(after.awaitingPope, before.awaitingPope, (msg or "awaitingPope") .. " is unchanged")
  local bf, af = before.subjects.fighters, after.subjects.fighters
  if bf == nil then
    assert_eq(af, nil, (msg or "fighters") .. " stay nil")
  else
    assert_eq(type(af), "table", (msg or "fighters") .. " stay a list")
    assert_eq(#af, #bf, (msg or "fighters") .. " length is unchanged")
    for i = 1, #bf do
      assert_eq(af[i], bf[i], (msg or "fighters") .. " id " .. i .. " is unchanged")
    end
  end
end

local function refuse(method, args, why)
  local before = Runtime:Snapshot()
  local ok, err = Runtime[method](Runtime, unpack(args or {}))
  local after = Runtime:Snapshot()
  assert_eq(ok, nil, why .. " returns nil")
  assert_eq(type(err), "string", why .. " returns an error string")
  assert_unchanged(before, after, why)
end

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
local started = Runtime:StartEvent()
assert_true(started ~= nil, "an event exists before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(Runtime:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "out-of-harness reset does not drop the event")
ChurchOfBeef._IN_TEST = true
reset()

--------------------------------------------------------------------------------
-- Cold start: QUIET, no event, no rite, no subjects, sequence 0
--------------------------------------------------------------------------------
local cold = Runtime:Snapshot()
assert_snap_shape(cold, "cold snapshot")
assert_eq(cold.state, "QUIET", "cold state is QUIET")
assert_eq(cold.eventId, nil, "cold event id is nil")
assert_eq(cold.riteType, nil, "cold rite type is nil")
assert_eq(cold.subjects.candidate, nil, "cold candidate is nil")
assert_eq(cold.subjects.fighters, nil, "cold fighters are nil")
assert_eq(cold.sequence, 0, "cold sequence is 0")

--------------------------------------------------------------------------------
-- StartEvent: QUIET → ASSEMBLY. Zero configuration. One action.
--------------------------------------------------------------------------------
local ev, startErr = Runtime:StartEvent()
assert_true(ev ~= nil, "StartEvent opens an event")
assert_eq(startErr, nil, "successful StartEvent has no error")
assert_snap_shape(ev, "StartEvent result")
assert_eq(ev.state, "ASSEMBLY", "StartEvent enters ASSEMBLY")
assert_true(isInt(ev.eventId), "StartEvent assigns a positive event id")
assert_eq(ev.eventId, 1, "first event id is 1")
assert_eq(ev.riteType, nil, "StartEvent does not open a rite")
assert_eq(ev.subjects.candidate, nil, "StartEvent names no candidate")
assert_eq(ev.subjects.fighters, nil, "StartEvent names no fighters")
assert_eq(ev.sequence, 1, "StartEvent increments sequence")

local live = Runtime:Snapshot()
assert_eq(live.state, "ASSEMBLY", "Snapshot matches StartEvent")
assert_eq(live.eventId, ev.eventId, "Snapshot keeps the event id")
assert_eq(live.sequence, 1, "Snapshot keeps the sequence")

-- Extra args are not event configuration; Tuesday start stays one action.
reset()
local plain = Runtime:StartEvent({ name = "Tuesday", setup = true }, "config")
assert_true(plain ~= nil, "StartEvent ignores leftover args")
assert_eq(plain.state, "ASSEMBLY", "StartEvent with leftover args still enters ASSEMBLY")
assert_eq(plain.riteType, nil, "StartEvent does not take a rite from leftover args")

--------------------------------------------------------------------------------
-- Illegal StartEvent leaves state unchanged
--------------------------------------------------------------------------------
refuse("StartEvent", {}, "StartEvent from ASSEMBLY")
Runtime:OpenRite("Knighting")
refuse("StartEvent", {}, "StartEvent from RITE")
Runtime:CloseRite()
refuse("StartEvent", {}, "StartEvent from CONSEQUENCE")

--------------------------------------------------------------------------------
-- OpenRite: ASSEMBLY → RITE. Closed types only.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
for i, kind in ipairs(RITE_TYPES) do
  if i > 1 then
    Runtime:CloseRite()
    Runtime:Continue()
  end
  local rite, riteErr = Runtime:OpenRite(kind)
  assert_true(rite ~= nil, "OpenRite accepts " .. kind)
  assert_eq(riteErr, nil, "OpenRite " .. kind .. " has no error")
  assert_eq(rite.state, "RITE", "OpenRite " .. kind .. " enters RITE")
  assert_eq(rite.riteType, kind, "OpenRite records " .. kind)
  assert_eq(Runtime:Snapshot().riteType, kind, "Snapshot keeps " .. kind)
end

reset()
Runtime:StartEvent()
refuse("OpenRite", {}, "OpenRite without a type")
refuse("OpenRite", { "knighting" }, "OpenRite rejects folded knighting")
refuse("OpenRite", { "KNIGHTING" }, "OpenRite rejects shouted KNIGHTING")
refuse("OpenRite", { "Builder" }, "OpenRite rejects a generic builder")
refuse("OpenRite", { "Recognition" }, "OpenRite rejects Recognition as a rite type")
refuse("OpenRite", { "Custom" }, "OpenRite rejects free-text kind")
refuse("OpenRite", { "" }, "OpenRite rejects empty kind")
refuse("OpenRite", { 1 }, "OpenRite rejects a numeric kind")

reset()
refuse("OpenRite", { "Knighting" }, "OpenRite from QUIET")
Runtime:StartEvent()
Runtime:OpenRite("Gora")
refuse("OpenRite", { "Knighting" }, "OpenRite from RITE")
Runtime:CloseRite()
refuse("OpenRite", { "Confession" }, "OpenRite from CONSEQUENCE")

--------------------------------------------------------------------------------
-- Subjects: candidate / fighters ids or nil. No Store lookup.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local knighted = Runtime:OpenRite("Knighting", { candidate = 7 })
assert_eq(knighted.subjects.candidate, 7, "OpenRite may name a candidate id")
assert_eq(knighted.subjects.fighters, nil, "Knighting without fighters leaves fighters nil")
assert_eq(knighted.riteType, "Knighting", "candidate does not change the rite type")

reset()
Runtime:StartEvent()
local gora = Runtime:OpenRite("Gora", { fighters = { 3, 4 } })
assert_eq(gora.subjects.candidate, nil, "Gora without a candidate leaves candidate nil")
assert_eq(type(gora.subjects.fighters), "table", "OpenRite may name fighters")
assert_eq(#gora.subjects.fighters, 2, "two fighters are recorded")
assert_eq(gora.subjects.fighters[1], 3, "first fighter id is kept")
assert_eq(gora.subjects.fighters[2], 4, "second fighter id is kept")

reset()
Runtime:StartEvent()
local both = Runtime:OpenRite("Gora", { candidate = 9, fighters = { 1, 2 } })
assert_eq(both.subjects.candidate, 9, "subjects may carry both Bible names")
assert_eq(both.subjects.fighters[1], 1, "fighters survive alongside a candidate")

reset()
Runtime:StartEvent()
refuse("OpenRite", { "Knighting", { candidate = "Beefina" } }, "candidate must be an id")
refuse("OpenRite", { "Gora", { fighters = 1 } }, "fighters must be a list")
refuse("OpenRite", { "Gora", { fighters = { "A", "B" } } }, "fighter entries must be ids")
refuse("OpenRite", { "Knighting", "Beefina" }, "subjects must be a table")
refuse("OpenRite", { "Knighting", { candidate = 0 } }, "candidate id must be positive")
refuse("OpenRite", { "Gora", { fighters = { 1.5, 2 } } }, "fighter ids must be integers")

--------------------------------------------------------------------------------
-- CloseRite: RITE → CONSEQUENCE. Keeps rite type and subjects.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Proclamation", { candidate = 11 })
local closed, closeErr = Runtime:CloseRite()
assert_true(closed ~= nil, "CloseRite closes the rite")
assert_eq(closeErr, nil, "successful CloseRite has no error")
assert_eq(closed.state, "CONSEQUENCE", "CloseRite enters CONSEQUENCE")
assert_eq(closed.riteType, "Proclamation", "CONSEQUENCE keeps the rite type")
assert_eq(closed.subjects.candidate, 11, "CONSEQUENCE keeps the candidate")
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "Snapshot stays on CONSEQUENCE")

reset()
refuse("CloseRite", {}, "CloseRite from QUIET")
Runtime:StartEvent()
refuse("CloseRite", {}, "CloseRite from ASSEMBLY")
Runtime:OpenRite("Confession")
Runtime:CloseRite()
refuse("CloseRite", {}, "CloseRite from CONSEQUENCE")

--------------------------------------------------------------------------------
-- Continue: CONSEQUENCE → ASSEMBLY. Clears rite type and subjects.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting", { candidate = 5, fighters = { 8, 9 } })
Runtime:CloseRite()
local cont, contErr = Runtime:Continue()
assert_true(cont ~= nil, "Continue returns to ASSEMBLY")
assert_eq(contErr, nil, "successful Continue has no error")
assert_eq(cont.state, "ASSEMBLY", "Continue enters ASSEMBLY")
assert_eq(cont.riteType, nil, "Continue clears the rite type")
assert_eq(cont.subjects.candidate, nil, "Continue clears the candidate")
assert_eq(cont.subjects.fighters, nil, "Continue clears fighters")
assert_eq(cont.eventId, 1, "Continue keeps the same event")

reset()
refuse("Continue", {}, "Continue from QUIET")
Runtime:StartEvent()
refuse("Continue", {}, "Continue from ASSEMBLY")
Runtime:OpenRite("Gora")
refuse("Continue", {}, "Continue from RITE")

--------------------------------------------------------------------------------
-- EndEvent: ASSEMBLY or CONSEQUENCE → QUIET. Not from RITE.
--------------------------------------------------------------------------------
reset()
local first = Runtime:StartEvent()
local ended, endErr = Runtime:EndEvent()
assert_true(ended ~= nil, "EndEvent from ASSEMBLY ends the event")
assert_eq(endErr, nil, "successful EndEvent has no error")
assert_eq(ended.state, "QUIET", "EndEvent enters QUIET")
assert_eq(ended.eventId, first.eventId, "QUIET keeps the ended event id")
assert_eq(ended.riteType, nil, "EndEvent clears the rite type")
assert_eq(ended.subjects.candidate, nil, "EndEvent clears the candidate")
assert_eq(ended.subjects.fighters, nil, "EndEvent clears fighters")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Confession")
local midRite = Runtime:Snapshot()
refuse("EndEvent", {}, "EndEvent from RITE")
assert_eq(Runtime:Snapshot().state, "RITE", "illegal EndEvent leaves the rite open")
assert_eq(Runtime:Snapshot().riteType, midRite.riteType, "illegal EndEvent keeps the rite type")

Runtime:CloseRite()
local fromCons = Runtime:EndEvent()
assert_eq(fromCons.state, "QUIET", "EndEvent from CONSEQUENCE enters QUIET")
assert_eq(fromCons.riteType, nil, "EndEvent from CONSEQUENCE clears the rite type")

reset()
refuse("EndEvent", {}, "EndEvent from QUIET")

--------------------------------------------------------------------------------
-- Sequence increments only on success. New event gets a new id.
--------------------------------------------------------------------------------
reset()
local s1 = Runtime:StartEvent()
local s2 = Runtime:OpenRite("Knighting")
local s3 = Runtime:CloseRite()
local s4 = Runtime:Continue()
local s5 = Runtime:OpenRite("Gora")
local s6 = Runtime:CloseRite()
local s7 = Runtime:EndEvent()
assert_eq(s1.sequence, 1, "first success is sequence 1")
assert_eq(s2.sequence, 2, "OpenRite increments sequence")
assert_eq(s3.sequence, 3, "CloseRite increments sequence")
assert_eq(s4.sequence, 4, "Continue increments sequence")
assert_eq(s5.sequence, 5, "second OpenRite increments sequence")
assert_eq(s6.sequence, 6, "second CloseRite increments sequence")
assert_eq(s7.sequence, 7, "EndEvent increments sequence")

local beforeFail = Runtime:Snapshot()
local bad, _ = Runtime:OpenRite("Knighting")
assert_eq(bad, nil, "illegal OpenRite after EndEvent fails")
assert_eq(Runtime:Snapshot().sequence, beforeFail.sequence, "failed transition does not increment sequence")

local s8 = Runtime:StartEvent()
assert_eq(s8.eventId, 2, "next StartEvent assigns a new event id")
assert_eq(s8.sequence, 8, "new event keeps incrementing sequence")
assert_eq(s8.state, "ASSEMBLY", "new event starts in ASSEMBLY")

--------------------------------------------------------------------------------
-- No auto-advance: each verb stops where the Pope left it
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "StartEvent does not auto-open a rite")
Runtime:OpenRite("Knighting")
assert_eq(Runtime:Snapshot().state, "RITE", "OpenRite does not auto-close")
Runtime:CloseRite()
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "CloseRite does not auto-continue or end")
Runtime:Continue()
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Continue does not auto-open the next rite")

--------------------------------------------------------------------------------
-- Snapshot is a copy. Restore resumes the event object. Failed Restore is inert.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora", { fighters = { 21, 22 } })
local snap = Runtime:Snapshot()
assert_snap_shape(snap, "live snapshot")
snap.state = "QUIET"
snap.riteType = "Builder"
snap.sequence = 99
snap.eventId = 50
snap.subjects.candidate = 1
snap.subjects.fighters[1] = 99
assert_eq(Runtime:Snapshot().state, "RITE", "mutating a Snapshot does not change live state")
assert_eq(Runtime:Snapshot().riteType, "Gora", "mutating a Snapshot does not change rite type")
assert_eq(Runtime:Snapshot().sequence, 2, "mutating a Snapshot does not change sequence")
assert_eq(Runtime:Snapshot().eventId, 1, "mutating a Snapshot does not change event id")
assert_eq(Runtime:Snapshot().subjects.candidate, nil, "mutating a Snapshot does not add a candidate")
assert_eq(Runtime:Snapshot().subjects.fighters[1], 21, "mutating a Snapshot does not retarget fighters")

local resume = {
  eventId = 4,
  state = "RITE",
  riteType = "Confession",
  subjects = { candidate = 15, fighters = nil },
  sequence = 12,
}
local restored, restoreErr = Runtime:Restore(resume)
assert_eq(restored, true, "Restore accepts a Bible-shaped event object")
assert_eq(restoreErr, nil, "successful Restore has no error")
local mid = Runtime:Snapshot()
assert_eq(mid.eventId, 4, "Restore resumes the event id")
assert_eq(mid.state, "RITE", "Restore resumes the state")
assert_eq(mid.riteType, "Confession", "Restore resumes the rite type")
assert_eq(mid.subjects.candidate, 15, "Restore resumes the candidate")
assert_eq(mid.subjects.fighters, nil, "Restore resumes nil fighters")
assert_eq(mid.sequence, 12, "Restore resumes the sequence")

local afterClose = Runtime:CloseRite()
assert_eq(afterClose.state, "CONSEQUENCE", "verbs resume from the restored state")
assert_eq(afterClose.sequence, 13, "sequence increments from the restored value")

local quietSnap = {
  eventId = 4,
  state = "QUIET",
  riteType = nil,
  subjects = { candidate = nil, fighters = nil },
  sequence = 13,
}
assert_eq(Runtime:Restore(quietSnap), true, "Restore accepts a QUIET event object")
local nextEv = Runtime:StartEvent()
assert_eq(nextEv.eventId, 5, "StartEvent after Restore does not reuse the restored event id")

local beforeBad = Runtime:Snapshot()
local noTable, noTableErr = Runtime:Restore("nope")
assert_eq(noTable, nil, "Restore refuses a non-table")
assert_eq(type(noTableErr), "string", "bad Restore returns an error string")
assert_unchanged(beforeBad, Runtime:Snapshot(), "non-table Restore")

refuse("Restore", { { eventId = 1, state = "AWAITING_POPE", riteType = nil, subjects = {}, sequence = 1 } }, "Restore rejects a sixth state")
refuse("Restore", { { eventId = 1, state = "RITE", riteType = "Builder", subjects = {}, sequence = 1 } }, "Restore rejects a free-text rite type")
refuse("Restore", { { eventId = 1, state = "RITE", riteType = nil, subjects = {}, sequence = 1 } }, "Restore rejects RITE without a rite type")
refuse("Restore", { { eventId = 1, state = "CONSEQUENCE", riteType = nil, subjects = {}, sequence = 1 } }, "Restore rejects CONSEQUENCE without a rite type")
refuse("Restore", { { eventId = 1, state = "ASSEMBLY", riteType = "Gora", subjects = {}, sequence = 1 } }, "Restore rejects ASSEMBLY with a rite type")
refuse("Restore", { { eventId = 1, state = "QUIET", riteType = "Knighting", subjects = {}, sequence = 1 } }, "Restore rejects QUIET with a rite type")
refuse("Restore", { { eventId = 0, state = "ASSEMBLY", riteType = nil, subjects = {}, sequence = 1 } }, "Restore rejects a non-positive event id")
refuse("Restore", { { eventId = 1, state = "ASSEMBLY", riteType = nil, subjects = {}, sequence = -1 } }, "Restore rejects a negative sequence")
refuse("Restore", { { eventId = 1, state = "ASSEMBLY", riteType = nil, subjects = "x", sequence = 1 } }, "Restore rejects non-table subjects")
refuse("Restore", { { eventId = 1, state = "RITE", riteType = "Gora", subjects = { fighters = { "A" } }, sequence = 1 } }, "Restore rejects named fighters")

-- Extra product fields are not kept. awaitingPope is a Lane E flag, tested below.
reset()
Runtime:StartEvent()
local extras = Runtime:Snapshot()
extras.holdTimeout = 30
extras.holdSeconds = 5
extras.narration = "Behold the Beef"
extras.attendance = { 1, 2 }
assert_eq(Runtime:Restore(extras), true, "Restore ignores extra fields")
local cleaned = Runtime:Snapshot()
assert_eq(cleaned.holdTimeout, nil, "Restore does not keep holdTimeout")
assert_eq(cleaned.holdSeconds, nil, "Restore does not keep holdSeconds")
assert_eq(cleaned.awaitingPope, nil, "Restore does not invent awaitingPope")
assert_eq(cleaned.narration, nil, "Restore does not keep narration")
assert_eq(cleaned.attendance, nil, "Restore does not keep attendance")
assert_snap_shape(cleaned, "cleaned snapshot")

--------------------------------------------------------------------------------
-- Pope-disconnect degrade: awaitingPope flag. Not a sixth state. No holdSeconds.
--------------------------------------------------------------------------------
reset()
refuse("MarkPopeLost", {}, "MarkPopeLost from QUIET")
assert_eq(Runtime:Snapshot().awaitingPope, nil, "QUIET does not set awaitingPope")
assert_eq(Runtime:Snapshot().state, "QUIET", "MarkPopeLost from QUIET stays QUIET")

reset()
local assembled = Runtime:StartEvent()
local lostAsm, lostAsmErr = Runtime:MarkPopeLost()
assert_true(lostAsm ~= nil, "MarkPopeLost from ASSEMBLY sets the flag")
assert_eq(lostAsmErr, nil, "successful MarkPopeLost has no error")
assert_eq(lostAsm.awaitingPope, true, "MarkPopeLost sets awaitingPope")
assert_eq(lostAsm.state, "ASSEMBLY", "MarkPopeLost is not a sixth state")
assert_eq(lostAsm.eventId, assembled.eventId, "MarkPopeLost keeps the event id")
assert_eq(lostAsm.riteType, nil, "MarkPopeLost keeps a nil rite type")
assert_eq(lostAsm.sequence, assembled.sequence, "MarkPopeLost does not increment sequence")
assert_eq(lostAsm.subjects.candidate, nil, "MarkPopeLost keeps subjects")
assert_eq(lostAsm.holdSeconds, nil, "MarkPopeLost does not invent holdSeconds")
assert_eq(lostAsm.holdTimeout, nil, "MarkPopeLost does not invent holdTimeout")
assert_snap_shape(lostAsm, "degraded ASSEMBLY")
local liveLost = Runtime:Snapshot()
assert_eq(liveLost.awaitingPope, true, "Snapshot shows awaitingPope")
assert_eq(liveLost.state, "ASSEMBLY", "Snapshot state stays ASSEMBLY")
assert_eq(liveLost.sequence, assembled.sequence, "Snapshot sequence is unchanged")

local lostAgain = Runtime:MarkPopeLost()
assert_eq(lostAgain.awaitingPope, true, "second MarkPopeLost stays awaiting")
assert_eq(lostAgain.sequence, assembled.sequence, "second MarkPopeLost does not increment sequence")
assert_eq(lostAgain.state, "ASSEMBLY", "second MarkPopeLost is not a transition")

local cleared, clearErr = Runtime:ClearPopeLost()
assert_true(cleared ~= nil, "ClearPopeLost clears the flag")
assert_eq(clearErr, nil, "successful ClearPopeLost has no error")
assert_eq(cleared.awaitingPope, nil, "ClearPopeLost unsets awaitingPope")
assert_eq(cleared.state, "ASSEMBLY", "ClearPopeLost does not change state")
assert_eq(cleared.sequence, assembled.sequence, "ClearPopeLost does not increment sequence")
assert_eq(Runtime:Snapshot().awaitingPope, nil, "Snapshot after ClearPopeLost has no flag")

local clearedAgain = Runtime:ClearPopeLost()
assert_eq(clearedAgain.awaitingPope, nil, "ClearPopeLost when unset stays unset")
assert_eq(clearedAgain.sequence, assembled.sequence, "inert ClearPopeLost does not increment sequence")

reset()
Runtime:StartEvent()
Runtime:MarkPopeLost()
reset()
assert_eq(Runtime:Snapshot().awaitingPope, nil, "ResetForTests clears awaitingPope")
assert_eq(Runtime:Snapshot().state, "QUIET", "ResetForTests returns to QUIET")

reset()
Runtime:StartEvent()
local rite = Runtime:OpenRite("Gora", { fighters = { 3, 4 } })
local lostRite = Runtime:MarkPopeLost()
assert_eq(lostRite.awaitingPope, true, "MarkPopeLost from RITE sets awaitingPope")
assert_eq(lostRite.state, "RITE", "RITE degrade is not a sixth state")
assert_eq(lostRite.riteType, "Gora", "RITE degrade keeps the rite type")
assert_eq(lostRite.sequence, rite.sequence, "RITE degrade does not increment sequence")
assert_eq(lostRite.subjects.fighters[1], 3, "RITE degrade keeps fighters")
assert_eq(lostRite.subjects.fighters[2], 4, "RITE degrade keeps the second fighter")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Knighting", { candidate = 7 })
local cons = Runtime:CloseRite()
local lostCons = Runtime:MarkPopeLost()
assert_eq(lostCons.awaitingPope, true, "MarkPopeLost from CONSEQUENCE sets awaitingPope")
assert_eq(lostCons.state, "CONSEQUENCE", "CONSEQUENCE degrade is not a sixth state")
assert_eq(lostCons.riteType, "Knighting", "CONSEQUENCE degrade keeps the rite type")
assert_eq(lostCons.subjects.candidate, 7, "CONSEQUENCE degrade keeps the candidate")
assert_eq(lostCons.sequence, cons.sequence, "CONSEQUENCE degrade does not increment sequence")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Confession", { candidate = 15 })
Runtime:MarkPopeLost()
local degSnap = Runtime:Snapshot()
assert_eq(degSnap.awaitingPope, true, "degraded Snapshot carries awaitingPope")
assert_snap_shape(degSnap, "degraded snapshot")
degSnap.awaitingPope = false
degSnap.state = "QUIET"
assert_eq(Runtime:Snapshot().awaitingPope, true, "mutating a Snapshot does not clear awaitingPope")
assert_eq(Runtime:Snapshot().state, "RITE", "mutating a Snapshot does not leave degrade")

local resumeLost = {
  eventId = 6,
  state = "ASSEMBLY",
  riteType = nil,
  subjects = { candidate = nil, fighters = nil },
  sequence = 20,
  awaitingPope = true,
}
assert_eq(Runtime:Restore(resumeLost), true, "Restore accepts awaitingPope when set")
local resumedLost = Runtime:Snapshot()
assert_eq(resumedLost.awaitingPope, true, "Restore round-trips awaitingPope")
assert_eq(resumedLost.state, "ASSEMBLY", "Restore with awaitingPope keeps ASSEMBLY")
assert_eq(resumedLost.eventId, 6, "Restore with awaitingPope keeps the event id")
assert_eq(resumedLost.sequence, 20, "Restore with awaitingPope keeps the sequence")

local resumeRiteLost = {
  eventId = 6,
  state = "RITE",
  riteType = "Gora",
  subjects = { candidate = nil, fighters = { 1, 2 } },
  sequence = 21,
  awaitingPope = true,
}
assert_eq(Runtime:Restore(resumeRiteLost), true, "Restore round-trips awaitingPope on RITE")
assert_eq(Runtime:Snapshot().awaitingPope, true, "RITE Restore keeps awaitingPope")
assert_eq(Runtime:Snapshot().state, "RITE", "RITE Restore keeps RITE")
assert_eq(Runtime:Snapshot().riteType, "Gora", "RITE Restore keeps the rite type")

local quietLost = {
  eventId = 6,
  state = "QUIET",
  riteType = nil,
  subjects = { candidate = nil, fighters = nil },
  sequence = 21,
  awaitingPope = true,
}
assert_eq(Runtime:Restore(quietLost), true, "Restore accepts QUIET even if awaitingPope is present")
assert_eq(Runtime:Snapshot().state, "QUIET", "QUIET Restore stays QUIET")
assert_eq(Runtime:Snapshot().awaitingPope, nil, "QUIET Restore does not keep awaitingPope")

reset()
Runtime:StartEvent()
Runtime:MarkPopeLost()
local noFlag = {
  eventId = 1,
  state = "ASSEMBLY",
  riteType = nil,
  subjects = { candidate = nil, fighters = nil },
  sequence = 1,
}
assert_eq(Runtime:Restore(noFlag), true, "Restore without awaitingPope succeeds")
assert_eq(Runtime:Snapshot().awaitingPope, nil, "Restore without awaitingPope clears the flag")

local junkFlag = {
  eventId = 1,
  state = "ASSEMBLY",
  riteType = nil,
  subjects = { candidate = nil, fighters = nil },
  sequence = 1,
  awaitingPope = "yes",
}
assert_eq(Runtime:Restore(junkFlag), true, "Restore ignores a non-boolean awaitingPope")
assert_eq(Runtime:Snapshot().awaitingPope, nil, "non-true awaitingPope is not set")

reset()
Runtime:StartEvent()
Runtime:MarkPopeLost()
local opened = Runtime:OpenRite("Proclamation")
assert_eq(opened.state, "RITE", "OpenRite still runs while awaitingPope")
assert_eq(opened.awaitingPope, true, "OpenRite does not clear awaitingPope")
local closed = Runtime:CloseRite()
assert_eq(closed.state, "CONSEQUENCE", "CloseRite still runs while awaitingPope")
assert_eq(closed.awaitingPope, true, "CloseRite does not clear awaitingPope")
local continued = Runtime:Continue()
assert_eq(continued.state, "ASSEMBLY", "Continue still runs while awaitingPope")
assert_eq(continued.awaitingPope, true, "Continue does not clear awaitingPope")
local ended = Runtime:EndEvent()
assert_eq(ended.state, "QUIET", "EndEvent still runs while awaitingPope")
assert_eq(ended.awaitingPope, nil, "EndEvent to QUIET clears awaitingPope")
assert_eq(Runtime:Snapshot().awaitingPope, nil, "QUIET after EndEvent is not degraded")

reset()
Runtime:StartEvent()
Runtime:OpenRite("Gora")
Runtime:MarkPopeLost()
assert_eq(Runtime:Snapshot().state, "RITE", "MarkPopeLost does not EndEvent")
assert_eq(Runtime:Snapshot().riteType, "Gora", "MarkPopeLost does not close the rite")

assert_eq(Runtime.Toast, nil, "no toast")
assert_eq(Runtime.WarnVersion, nil, "no second Quiet notice")
assert_eq(Runtime.Notify, nil, "no notify")
assert_eq(Runtime.Promote, nil, "no Promote")
assert_eq(Runtime.PromoteSelf, nil, "no PromoteSelf")
assert_eq(Runtime.TakeOver, nil, "no TakeOver")
assert_eq(Runtime.AutoEndEvent, nil, "no AutoEndEvent")
assert_eq(Runtime.HoldSeconds, nil, "no HoldSeconds")
assert_eq(type(Runtime.MarkPopeLost), "function", "MarkPopeLost is the degrade verb")
assert_eq(type(Runtime.ClearPopeLost), "function", "ClearPopeLost clears degrade")

--------------------------------------------------------------------------------
-- No SV persist, no frames, no Net, no banned product verbs
--------------------------------------------------------------------------------
reset()
ChurchOfBeefDB = { sentinel = 1 }
local framed = 0
CreateFrame = function()
  framed = framed + 1
end
local netCalls = 0
COB.Net = {
  Send = function()
    netCalls = netCalls + 1
  end,
  Broadcast = function()
    netCalls = netCalls + 1
  end,
}
Runtime:StartEvent()
Runtime:MarkPopeLost()
Runtime:OpenRite("Knighting", { candidate = 2 })
Runtime:CloseRite()
Runtime:ClearPopeLost()
Runtime:Continue()
Runtime:OpenRite("Proclamation")
Runtime:CloseRite()
local parked = Runtime:Snapshot()
Runtime:Restore(parked)
Runtime:EndEvent()
assert_eq(ChurchOfBeefDB.sentinel, 1, "Runtime does not write ChurchOfBeefDB")
assert_eq(ChurchOfBeefDB.runtime, nil, "Runtime does not persist the event object into SV")
assert_eq(framed, 0, "Runtime does not CreateFrame")
assert_eq(netCalls, 0, "Runtime does not call Net")

assert_eq(Runtime.Grant, nil, "no Grant")
assert_eq(Runtime.GrantCeremony, nil, "no GrantCeremony")
assert_eq(Runtime.AutoAdvance, nil, "no AutoAdvance")
assert_eq(Runtime.Narrate, nil, "no Narrate")
assert_eq(Runtime.Announce, nil, "no Announce")
assert_eq(type(Runtime.StartEvent), "function", "StartEvent is a Pope verb")
assert_eq(type(Runtime.OpenRite), "function", "OpenRite is a Pope verb")
assert_eq(type(Runtime.CloseRite), "function", "CloseRite is a Pope verb")
assert_eq(type(Runtime.Continue), "function", "Continue is a Pope verb")
assert_eq(type(Runtime.EndEvent), "function", "EndEvent is a Pope verb")
assert_eq(type(Runtime.MarkPopeLost), "function", "MarkPopeLost is a degrade verb")
assert_eq(type(Runtime.ClearPopeLost), "function", "ClearPopeLost is a degrade verb")
assert_eq(type(Runtime.Snapshot), "function", "Snapshot is the event object")
assert_eq(type(Runtime.Restore), "function", "Restore is the event object")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
