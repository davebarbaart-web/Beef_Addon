-- Rite of Recognition (Phase 2 Lane C). Isolated: Common + Ranks + Store + Recognition.
-- No TOC / bootstrap / run.lua / Store edits. No UI, Net, UnitName widgets, or kneel slash.
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
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Recognition.lua")

local COB = ChurchOfBeef
local Store = COB.Store
local Recognition = COB.Recognition

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Recognition:ResetForTests(), true, "Recognition ResetForTests runs under _IN_TEST")
end

local function seed()
  local human = Store:CreateHuman({ name = "Steve" }, 1000)
  local alt = Store:CreateCharacter({ name = "Chuckroast" }, 1001)
  return human, alt
end

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
local hKeep, cKeep = seed()
local openKeep = Recognition:Begin(hKeep.id, cKeep.id, "pope", 1100)
assert_true(openKeep ~= nil, "a session exists before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(Recognition:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_true(Recognition:GetSession() ~= nil, "out-of-harness reset does not drop the session")
ChurchOfBeef._IN_TEST = true
reset()

--------------------------------------------------------------------------------
-- Begin: logged-in character id is passed in; confirmer is pope or council
--------------------------------------------------------------------------------
local steve, chuck = seed()
local session, beginErr = Recognition:Begin(steve.id, chuck.id, "pope", 2000)
assert_true(session ~= nil, "Begin opens a rite")
assert_eq(beginErr, nil, "successful Begin has no error")
assert_eq(session.humanId, steve.id, "session names the human")
assert_eq(session.characterId, chuck.id, "session names the logged-in character")
assert_eq(session.confirmerRole, "pope", "Pope may confirm")
assert_eq(session.startedAt, 2000, "Begin uses the injectable clock")
assert_eq(session.duration, 30, "Bible shape is a thirty-second rite")
assert_eq(session.relink, false, "a first bind is not a re-link")
assert_eq(Store:GetCharacter(chuck.id).humanId, nil, "Begin does not write the store")
assert_eq(#Store:GetCeremonyLog(), 0, "Begin does not append a ceremony")
assert_eq(Store:GetHuman(steve.id).history[1].kind, "created", "Begin does not add a linked history event")

local live = Recognition:GetSession()
assert_eq(live.characterId, chuck.id, "GetSession returns the open rite")
live.humanId = 99
live.duration = 1
live.relink = true
assert_eq(Recognition:GetSession().humanId, steve.id, "mutating a session copy does not retarget the human")
assert_eq(Recognition:GetSession().duration, 30, "mutating a session copy does not change duration")
assert_eq(Recognition:GetSession().relink, false, "mutating a session copy does not flip relink")

--------------------------------------------------------------------------------
-- Council may confirm; the write still goes through the Pope store
--------------------------------------------------------------------------------
reset()
steve, chuck = seed()
local councilSession = Recognition:Begin(steve.id, chuck.id, "council", 2100)
assert_eq(councilSession.confirmerRole, "council", "Council may confirm")
local titled = Recognition:Begin(steve.id, chuck.id, "Pope", 2101)
assert_eq(titled, nil, "a second Begin is refused while a rite is open")
assert_eq(Recognition:GetSession().confirmerRole, "council", "refused Begin leaves the open rite")

local councilLink = Recognition:Complete(2102)
assert_true(councilLink ~= nil, "Council Complete writes the Pope store")
assert_eq(councilLink.humanId, steve.id, "Council confirmation binds on the Pope store")
assert_eq(Store:GetCharacter(chuck.id).humanId, steve.id, "the character row is bound after Council Complete")
assert_eq(Store:GetHuman(steve.id).characterIds[1], chuck.id, "the human lists the character after Council Complete")
assert_eq(Recognition:GetSession(), nil, "Complete closes the session")

--------------------------------------------------------------------------------
-- Require a logged-in character id; do not invent UnitName widgets
--------------------------------------------------------------------------------
reset()
steve, chuck = seed()
local savedUnitName = UnitName
UnitName = function()
  return "Impostor"
end
local passedIn = Recognition:Begin(steve.id, chuck.id, "pope", 2200)
assert_true(passedIn ~= nil, "Begin uses the passed character id")
assert_eq(passedIn.characterId, chuck.id, "UnitName is not consulted")
Recognition:Cancel()

local noChar, noCharErr = Recognition:Begin(steve.id, nil, "pope", 2201)
assert_eq(noChar, nil, "Begin refuses a missing character id")
assert_true(type(noCharErr) == "string", "missing character id returns an error string")

local nameChar, nameCharErr = Recognition:Begin(steve.id, "Chuckroast", "pope", 2202)
assert_eq(nameChar, nil, "Begin refuses a name-string character id")
assert_true(type(nameCharErr) == "string", "name-string character id returns an error string")

local keyChar, keyCharErr = Recognition:Begin(steve.id, COB.Names.Key("Chuckroast"), "pope", 2203)
assert_eq(keyChar, nil, "Names.Key is not a logged-in character id")
assert_true(type(keyCharErr) == "string", "Names.Key character id returns an error string")

local unknownChar, unknownCharErr = Recognition:Begin(steve.id, 99, "pope", 2204)
assert_eq(unknownChar, nil, "Begin refuses an unknown character")
assert_true(type(unknownCharErr) == "string", "unknown character returns an error string")

local nameHuman, nameHumanErr = Recognition:Begin("Steve", chuck.id, "pope", 2205)
assert_eq(nameHuman, nil, "Begin refuses a name-string human id")
assert_true(type(nameHumanErr) == "string", "name-string human id returns an error string")

local unknownHuman, unknownHumanErr = Recognition:Begin(99, chuck.id, "pope", 2206)
assert_eq(unknownHuman, nil, "Begin refuses an unknown human")
assert_true(type(unknownHumanErr) == "string", "unknown human returns an error string")

assert_eq(Store:GetCharacter(chuck.id).humanId, nil, "refused Begins do not bind")
assert_eq(Recognition:GetSession(), nil, "refused Begins do not leave a session")
UnitName = savedUnitName

--------------------------------------------------------------------------------
-- No self-service: confirmer must be pope or council
--------------------------------------------------------------------------------
reset()
steve, chuck = seed()
local function refuseRole(role, label)
  local row, err = Recognition:Begin(steve.id, chuck.id, role, 2300)
  assert_eq(row, nil, label)
  assert_true(type(err) == "string", label .. " returns an error string")
  assert_eq(Recognition:GetSession(), nil, label .. " does not open a session")
  assert_eq(Store:GetCharacter(chuck.id).humanId, nil, label .. " does not bind")
end

refuseRole(nil, "missing confirmer is refused")
refuseRole("", "empty confirmer is refused")
refuseRole("self", "self confirmer is refused")
refuseRole("member", "member confirmer is refused")
refuseRole("officer", "officer confirmer is refused")
refuseRole("battlenet", "BattleNet confirmer is refused")

local folded = Recognition:Begin(steve.id, chuck.id, "Council", 2301)
assert_eq(folded.confirmerRole, "council", "Council is accepted case-insensitively")
Recognition:Cancel()

--------------------------------------------------------------------------------
-- Already bound to a different human: refuse; same-human re-link is confirmation
--------------------------------------------------------------------------------
reset()
steve, chuck = seed()
local dave = Store:CreateHuman({ name = "Dave" }, 2400)
Store:LinkCharacter(chuck.id, steve.id, 2401)

local stolen, stolenErr = Recognition:Begin(dave.id, chuck.id, "pope", 2402)
assert_eq(stolen, nil, "Begin refuses a character already bound to a different human")
assert_true(type(stolenErr) == "string", "cross-human Begin returns an error string")
assert_eq(Store:GetCharacter(chuck.id).humanId, steve.id, "refused Begin leaves the original human")
assert_eq(#Store:GetHuman(dave.id).characterIds, 0, "the other human does not gain the character")
assert_eq(Recognition:GetSession(), nil, "cross-human Begin does not open a session")

local confirm = Recognition:Begin(steve.id, chuck.id, "pope", 2403)
assert_true(confirm ~= nil, "same-human re-link opens as confirmation")
assert_eq(confirm.relink, true, "transfer/faction re-link is confirmation, not a new identity")
local confirmed = Recognition:Complete(2404)
assert_true(confirmed ~= nil, "same-human Complete confirms the existing bind")
assert_eq(confirmed.humanId, steve.id, "re-link keeps the same human")
assert_eq(#Store:GetHuman(steve.id).characterIds, 1, "re-link does not duplicate the character id")
assert_eq(Store:GetHuman(steve.id).characterIds[1], chuck.id, "re-link keeps the original character id")

--------------------------------------------------------------------------------
-- Complete: Store:LinkCharacter plus ceremony log; no scripture
--------------------------------------------------------------------------------
reset()
steve, chuck = seed()
Recognition:Begin(steve.id, chuck.id, "pope", 2500)
local linked, linkErr = Recognition:Complete(2501)
assert_true(linked ~= nil, "Complete binds through Store:LinkCharacter")
assert_eq(linkErr, nil, "successful Complete has no error")
assert_eq(linked.humanId, steve.id, "Complete returns the bound character")
assert_eq(Store:GetCharacter(chuck.id).humanId, steve.id, "the Pope store holds the bind")
assert_eq(Store:GetHuman(steve.id).characterIds[1], chuck.id, "the human lists the linked character")
assert_eq(Store:GetHuman(steve.id).history[2].kind, "linked", "Complete records a linked history event")
assert_eq(Store:GetHuman(steve.id).history[2].characterId, chuck.id, "linked history names the character")
assert_eq(Store:GetCharacter(chuck.id).rankId, nil, "linking does not invent a character rank")
assert_eq(Store:RankForCharacter(chuck.id), nil, "unranked human still has no Church rank")

local log = Store:GetCeremonyLog()
assert_eq(#log, 1, "Complete appends one ceremony entry")
assert_eq(log[1].type, "Recognition", "ceremony type is Recognition")
assert_eq(log[1].at, 2501, "ceremony uses the Complete clock")
assert_eq(log[1].participantIds[1], chuck.id, "ceremony names the logged-in character")
assert_eq(log[1].participantIds[2], steve.id, "ceremony names the human")
assert_eq(log[1].scripture, nil, "ceremony log has no scripture")
assert_eq(log[1].narration, nil, "ceremony log has no narration")
assert_eq(log[1].text, nil, "ceremony log has no generated text")
assert_eq(Recognition:GetSession(), nil, "Complete clears the session")

local noOpen, noOpenErr = Recognition:Complete(2502)
assert_eq(noOpen, nil, "Complete without a session is refused")
assert_true(type(noOpenErr) == "string", "Complete without a session returns an error string")
assert_eq(#Store:GetCeremonyLog(), 1, "a refused Complete does not append again")

--------------------------------------------------------------------------------
-- Cancel: no store write
--------------------------------------------------------------------------------
reset()
steve, chuck = seed()
Recognition:Begin(steve.id, chuck.id, "pope", 2600)
local cancelled, cancelErr = Recognition:Cancel()
assert_eq(cancelled, true, "Cancel closes an open rite")
assert_eq(cancelErr, nil, "successful Cancel has no error")
assert_eq(Recognition:GetSession(), nil, "Cancel clears the session")
assert_eq(Store:GetCharacter(chuck.id).humanId, nil, "Cancel does not bind")
assert_eq(#Store:GetCeremonyLog(), 0, "Cancel does not append a ceremony")
assert_eq(#Store:GetHuman(steve.id).history, 1, "Cancel does not add a linked history event")

local cancelledAgain, cancelAgainErr = Recognition:Cancel()
assert_eq(cancelledAgain, nil, "Cancel without a session is refused")
assert_true(type(cancelAgainErr) == "string", "Cancel without a session returns an error string")

local afterCancel = Recognition:Complete(2601)
assert_eq(afterCancel, nil, "Complete after Cancel does not bind")
assert_eq(Store:GetCharacter(chuck.id).humanId, nil, "cancelled rite stays unbound")

--------------------------------------------------------------------------------
-- Duration is metadata the harness can set — not a UI timer, not an auto-gate
--------------------------------------------------------------------------------
reset()
steve, chuck = seed()
local timed = Recognition:Begin(steve.id, chuck.id, "pope", { now = 2700, duration = 12 })
assert_eq(timed.duration, 12, "the harness may set session duration")
assert_eq(timed.startedAt, 2700, "opts.now is the start time")
assert_eq(Recognition:IsExpired(2711), false, "inside the duration is not expired")
assert_eq(Recognition:IsExpired(2712), true, "at startedAt + duration the session is expired")
assert_eq(Store:GetCharacter(chuck.id).humanId, nil, "expiry does not auto-bind")
assert_eq(#Store:GetCeremonyLog(), 0, "expiry does not auto-append")
local late = Recognition:Complete(2800)
assert_true(late ~= nil, "Complete still works after expiry — duration is not a timer gate")
assert_eq(late.humanId, steve.id, "late Complete still writes the Pope store")

reset()
steve, chuck = seed()
local defaulted = Recognition:Begin(steve.id, chuck.id, "pope", 2900)
assert_eq(defaulted.duration, 30, "omitted duration is thirty seconds")
assert_eq(Recognition:IsExpired(2929), false, "29 seconds is inside the Bible shape")
assert_eq(Recognition:IsExpired(2930), true, "30 seconds is the metadata horizon")
Recognition:Cancel()

local badDur, badDurErr = Recognition:Begin(steve.id, chuck.id, "pope", { now = 2901, duration = 0 })
assert_eq(badDur, nil, "non-positive duration is refused")
assert_true(type(badDurErr) == "string", "bad duration returns an error string")

assert_eq(Recognition:IsExpired(3000), false, "IsExpired is false when no session is open")

--------------------------------------------------------------------------------
-- Sneaked account / BattleNet fields do not bind and are not stored
--------------------------------------------------------------------------------
reset()
steve, chuck = seed()
local sneaky = Recognition:Begin(steve.id, chuck.id, "pope", {
  now = 3100,
  accountId = "shared-account",
  battlenetId = "Tag#1234",
})
assert_true(sneaky ~= nil, "extra opts do not invent an auto-link path")
assert_eq(sneaky.accountId, nil, "session does not store an account id")
assert_eq(sneaky.battlenetId, nil, "session does not store a BattleNet id")
assert_eq(Store:GetCharacter(chuck.id).humanId, nil, "sneaked account fields do not bind")
Recognition:Cancel()
assert_eq(Store:GetCharacter(chuck.id).humanId, nil, "cancel after sneaked opts still writes nothing")

--------------------------------------------------------------------------------
-- Banned product: no self-link, auto-link, BattleNet, unlink-as-delete, theater
--------------------------------------------------------------------------------
assert_eq(Recognition.LinkSelf, nil, "no self-service link")
assert_eq(Recognition.AutoLink, nil, "no silent same-account bind")
assert_eq(Recognition.BindAccount, nil, "no account auto-link")
assert_eq(Recognition.BindBattleNet, nil, "no BattleNet auto-link")
assert_eq(Recognition.Unlink, nil, "no unlink-as-delete")
assert_eq(Recognition.SweepDeparted, nil, "no departed sweep")
assert_eq(Recognition.SplitAccount, nil, "shared accounts have no machinery")
assert_eq(Recognition.Kneel, nil, "no kneel slash")
assert_eq(Recognition.CreateFrame, nil, "Core does not CreateFrame")
assert_eq(Recognition.OpenConsole, nil, "no Director Console")
assert_eq(type(Recognition.Begin), "function", "Begin is the rite start")
assert_eq(type(Recognition.Complete), "function", "Complete is the confirmer write")
assert_eq(type(Recognition.Cancel), "function", "Cancel is the abort")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
