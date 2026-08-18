-- Candidate / fighter raid marks (B5-B). Isolated: wow_ui_stub + Common +
-- Runtime + Markers. Stub SetRaidTarget / TargetUnit / Sender / UnitName.
-- Quiet refuse. StartEvent + Pope + grouped → MarkCandidate spies
-- SetRaidTarget(unit, 1). Missing API fail-closed. Isolation wrap.
-- No TOC / bootstrap / run.lua / Knighting / Gora / Console.
package.path = package.path .. ";./tests/?.lua"

local stub = require("wow_ui_stub")
local restore = stub.install()

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
dofile("addon/ChurchOfBeef/UI/Markers.lua")

local COB = ChurchOfBeef
local Markers = COB.Markers
local Runtime = COB.Runtime

local sounds = 0
PlaySound = function()
  sounds = sounds + 1
end
PlaySoundFile = function()
  sounds = sounds + 1
end
PlaySoundKitID = function()
  sounds = sounds + 1
end

local popeFlag = false
local popeNames = {}
local raidTargets = {}
local targetCalls = {}
local raidIndexReads = {}
local combatCalls = 0

local function stubSender()
  popeNames = {}
  COB.Sender = {
    IsRegisteredPope = function(_, name)
      popeNames[#popeNames + 1] = name
      return popeFlag == true
    end,
  }
end

local function stubMarkApis()
  raidTargets = {}
  targetCalls = {}
  raidIndexReads = {}
  combatCalls = 0
  SetRaidTarget = function(unit, index)
    raidTargets[#raidTargets + 1] = { unit = unit, index = index }
  end
  TargetUnit = function(name, exact)
    targetCalls[#targetCalls + 1] = { name = name, exact = exact }
  end
  GetRaidTargetIndex = function(unit)
    raidIndexReads[#raidIndexReads + 1] = unit
    for i = #raidTargets, 1, -1 do
      if raidTargets[i].unit == unit then
        return raidTargets[i].index
      end
    end
    return nil
  end
  StartAttack = function()
    combatCalls = combatCalls + 1
  end
  AttackTarget = function()
    combatCalls = combatCalls + 1
  end
  AssistUnit = function()
    combatCalls = combatCalls + 1
  end
end

local function resetGroup()
  stub.playerName = "Beefina"
  stub.group = {}
  stub.groupSize = 0
  stub.inRaid = false
  stub.playerInCombat = false
end

local function armRaid(candidateName, extra)
  stub.playerName = "Beefina"
  stub.inRaid = true
  stub.groupSize = extra and 3 or 2
  stub.group = {
    raid1 = { name = "Beefina" },
    raid2 = { name = candidateName or "Chuckroast" },
  }
  if extra then
    stub.group.raid3 = { name = extra }
  end
end

local function reset()
  popeFlag = false
  stubSender()
  stubMarkApis()
  resetGroup()
  sounds = 0
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Markers:ResetForTests(), true, "Markers ResetForTests runs under _IN_TEST")
end

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(Markers ~= nil, "COB.Markers is loaded")
assert_true(Runtime ~= nil, "isolated suite loads Runtime")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_true(COB.Group ~= nil, "Common Group is loaded")
assert_eq(Markers.MODE, "Event", "Markers declares Event Mode")
assert_eq(type(Markers.Target), "function", "Target is the desk-assist verb")
assert_eq(type(Markers.MarkCandidate), "function", "MarkCandidate places star")
assert_eq(type(Markers.MarkFighters), "function", "MarkFighters places 2 and 3")
assert_eq(type(Markers.Clear), "function", "Clear removes a mark")
assert_eq(type(Markers.Forget), "function", "Forget sweeps leftover marks")
assert_eq(type(Markers.GetView), "function", "GetView returns a copy")
assert_eq(type(Markers.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(Markers.Init, nil, "no frame surface this lane")
assert_eq(Markers.Show, nil, "no Show chrome")
assert_eq(Markers.PlayCue, nil, "no sound this lane")
assert_eq(Markers.Toast, nil, "Markers is not a toast")
assert_eq(Markers.Narrate, nil, "software does not narrate")
assert_eq(Markers.Announce, nil, "software does not announce")
assert_eq(Markers.Sanction, nil, "Markers does not sanction")
assert_eq(Markers.Knight, nil, "Markers does not knight")
assert_eq(Markers.Promote, nil, "no GuildPromote verb")
assert_eq(Markers.StartAttack, nil, "no combat verb")
assert_eq(Markers.INPUT, nil, "no invented INPUT channel")

if standalone then
  assert_eq(COB.UI, nil, "isolated suite does not load the Quiet shell")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Roster, nil, "isolated suite does not load Roster")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
  assert_eq(COB.Sound, nil, "isolated suite does not load Sound")
  assert_eq(COB.DecreeBanner, nil, "isolated suite does not load Decree")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load Records Book")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Snapshot, nil, "isolated suite does not load Snapshot")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.FighterCard, nil, "isolated suite does not load FighterCard")
  assert_eq(COB.Confession, nil, "isolated suite does not load Confession")
  assert_eq(COB.Inputs, nil, "isolated suite does not load Inputs")
  assert_eq(COB.ConsoleDock, nil, "isolated suite does not load ConsoleDock")
  assert_eq(COB.Decree, nil, "isolated suite does not load Core Decree")
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "this file does not register a slash")
end

--------------------------------------------------------------------------------
-- Source contract: guarded APIs, no theater, no combat automation.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/Markers.lua", "r")
assert_true(srcFile ~= nil, "UI/Markers.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_true(src:find('type(TargetUnit)', 1, true) ~= nil, "TargetUnit is type-guarded")
assert_true(src:find('type(SetRaidTarget)', 1, true) ~= nil, "SetRaidTarget is type-guarded")
assert_true(src:find('type(GetRaidTargetIndex)', 1, true) ~= nil, "GetRaidTargetIndex is type-guarded")
assert_true(src:find('type(GetNumGroupMembers)', 1, true) ~= nil, "GetNumGroupMembers is type-guarded")
assert_true(src:find('type(IsInRaid)', 1, true) ~= nil, "IsInRaid is type-guarded")
assert_true(src:find("pcall(TargetUnit", 1, true) ~= nil, "TargetUnit is pcalled")
assert_true(src:find('"not in a group"', 1, true) ~= nil, "ungrouped error is named")
assert_true(src:find('"not a registered pope"', 1, true) ~= nil, "unlisted Pope error is named")
assert_true(src:find('return "player"', 1, true) ~= nil, "resolveUnit returns the player token")
assert_true(src:find("namesSame(me, name)", 1, true) ~= nil, "player resolve uses namesSame")
assert_true(src:find('pcall(UnitName, "player")', 1, true) ~= nil, "UnitName player read is pcalled")
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find("PlaySoundFile", 1, true), nil, "source does not call PlaySoundFile")
assert_eq(src:find("Toasts", 1, true), nil, "source does not drive Toasts")
assert_eq(src:find("COB.Net", 1, true), nil, "source does not call Net")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("SendAddonMessage", 1, true), nil, "source does not send addon messages")
assert_eq(src:find("GuildPromote", 1, true), nil, "source does not GuildPromote")
assert_eq(src:find("SetGuildMemberRank", 1, true), nil, "source does not set guild rank")
assert_eq(src:find("StartAttack", 1, true), nil, "source does not StartAttack")
assert_eq(src:find("AttackTarget", 1, true), nil, "source does not AttackTarget")
assert_eq(src:find("AssistUnit", 1, true), nil, "source does not AssistUnit")
assert_eq(src:find("CastSpell", 1, true), nil, "source does not CastSpell")
assert_eq(src:find("UseAction", 1, true), nil, "source does not UseAction")
assert_eq(src:find("SecureActionButton", 1, true), nil, "no secure template")
assert_eq(src:find("UnitIsDead", 1, true), nil, "source does not UnitIsDead")
assert_true(src:find("local function clearPrior", 1, true) ~= nil, "clearPrior helper exists")
assert_true(src:find("function Markers:Forget", 1, true) ~= nil, "Forget verb exists")
assert_eq(src:find("CreateFrame", 1, true), nil, "no frame this lane")
assert_eq(src:find("ShowUIPanel", 1, true), nil, "insecure only")
assert_eq(src:find("SLASH_", 1, true), nil, "source does not register a slash")
assert_eq(src:find("Media\\", 1, true), nil, "source does not require custom Media")
assert_eq(src:find(".tga", 1, true), nil, "source does not load custom tga")
assert_eq(src:find(".blp", 1, true), nil, "source does not load custom blp")
assert_eq(src:find("rubber", 1, true), nil, "source has no rubber flavor")
assert_eq(src:find("ordained", 1, true), nil, "source has no ordained flavor")
assert_eq(src:find("Proclaim", 1, true), nil, "source does not Proclaim")

--------------------------------------------------------------------------------
-- Quiet refuse. All verbs. No TargetUnit / SetRaidTarget.
--------------------------------------------------------------------------------
reset()
assert_eq(Runtime:Snapshot().state, "QUIET", "fresh runtime is QUIET")
local ok, err = Markers:Target("Chuckroast")
assert_eq(ok, false, "Quiet Target is false")
assert_eq(err, "quiet", "Quiet Target names quiet")
assert_eq(#targetCalls, 0, "Quiet Target does not TargetUnit")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, false, "Quiet MarkCandidate is false")
assert_eq(err, "quiet", "Quiet MarkCandidate names quiet")
assert_eq(#raidTargets, 0, "Quiet MarkCandidate does not SetRaidTarget")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, false, "Quiet MarkFighters is false")
assert_eq(err, "quiet", "Quiet MarkFighters names quiet")
ok, err = Markers:Clear("Chuckroast")
assert_eq(ok, false, "Quiet Clear is false")
assert_eq(err, "quiet", "Quiet Clear names quiet")
assert_eq(#raidTargets, 0, "Quiet Clear does not SetRaidTarget")
assert_eq(Markers:GetView().ok, false, "Quiet view records the refuse")
assert_eq(Markers:GetView().mode, "Event", "refused view still declares Event")
assert_eq(Markers:GetView().unit, nil, "first Quiet refuse has no unit")
assert_eq(Markers:GetView().unitA, nil, "first Quiet refuse has no unitA")
assert_eq(Markers:GetView().unitB, nil, "first Quiet refuse has no unitB")
assert_eq(sounds, 0, "Quiet plays no sound")
assert_eq(#stub.chat, 0, "Quiet does not SendChatMessage")
assert_eq(#stub.addonMessages, 0, "Quiet does not SendAddonMessage")
assert_eq(combatCalls, 0, "Quiet does not start combat")

--------------------------------------------------------------------------------
-- Event without Pope. Unlisted → not a registered pope.
--------------------------------------------------------------------------------
reset()
assert_true(Runtime:StartEvent() ~= nil, "StartEvent reaches ASSEMBLY")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY")
popeFlag = false
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, false, "unlisted Pope MarkCandidate is false")
assert_eq(err, "not a registered pope", "unlisted Pope names the error")
assert_eq(#raidTargets, 0, "unlisted Pope does not SetRaidTarget")
ok, err = Markers:Target("Chuckroast")
assert_eq(ok, false, "unlisted Pope Target is false")
assert_eq(err, "not a registered pope", "unlisted Pope Target names the error")
assert_eq(#targetCalls, 0, "unlisted Pope does not TargetUnit")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, false, "unlisted Pope MarkFighters is false")
assert_eq(err, "not a registered pope", "unlisted Pope MarkFighters names the error")
ok, err = Markers:Clear("Chuckroast")
assert_eq(ok, false, "unlisted Pope Clear is false")
assert_eq(err, "not a registered pope", "unlisted Pope Clear names the error")

local savedSender = COB.Sender
COB.Sender = nil
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, false, "missing Sender is false")
assert_eq(err, "not a registered pope", "missing Sender is not a registered pope")
COB.Sender = {
  IsRegisteredPope = function()
    return 1
  end,
}
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, false, "non-true Pope return is false")
assert_eq(err, "not a registered pope", "non-true Pope return is unlisted")
COB.Sender = savedSender

--------------------------------------------------------------------------------
-- Event + Pope + not grouped → not in a group.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, false, "ungrouped MarkCandidate is false")
assert_eq(err, "not in a group", "ungrouped MarkCandidate names the error")
assert_eq(#raidTargets, 0, "ungrouped MarkCandidate does not mark")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, false, "ungrouped MarkFighters is false")
assert_eq(err, "not in a group", "ungrouped MarkFighters names the error")
ok, err = Markers:Clear("Chuckroast")
assert_eq(ok, false, "ungrouped Clear is false")
assert_eq(err, "not in a group", "ungrouped Clear names the error")
assert_eq(#raidTargets, 0, "ungrouped Clear does not SetRaidTarget")

--------------------------------------------------------------------------------
-- Event + Pope + grouped: Target and MarkCandidate spies.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:Target("Chuckroast")
assert_eq(ok, true, "Event Pope Target is true")
assert_eq(err, nil, "successful Target has no error")
assert_eq(#targetCalls, 1, "Target spies TargetUnit once")
assert_eq(targetCalls[1].name, "Chuckroast", "TargetUnit receives the name")
assert_eq(targetCalls[1].exact, true, "TargetUnit uses exactMatch true")
assert_eq(#raidTargets, 0, "Target does not SetRaidTarget")

ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "Event Pope grouped MarkCandidate is true")
assert_eq(err, nil, "successful MarkCandidate has no error")
assert_eq(#raidTargets, 1, "MarkCandidate spies SetRaidTarget once")
assert_eq(raidTargets[1].unit, "raid2", "MarkCandidate uses a scanned raid token")
assert_eq(raidTargets[1].index, 1, "MarkCandidate places star index 1")
assert_eq(raidTargets[1].unit ~= "Chuckroast", true, "MarkCandidate does not invent a name token")
assert_eq(#raidIndexReads >= 1, true, "GetRaidTargetIndex is read after mark")
local view = Markers:GetView()
assert_eq(view.ok, true, "view records success")
assert_eq(view.verb, "MarkCandidate", "view records the verb")
assert_eq(view.name, "Chuckroast", "view records the name")
assert_eq(view.unit, "raid2", "view records the unit token")
assert_eq(view.index, 1, "view records star index 1")
assert_eq(view.mode, "Event", "success view declares Event")
assert_eq(popeNames[#popeNames], "Beefina", "Pope gate reads the local player")

ok, err = Markers:MarkCandidate("chuckroast")
assert_eq(ok, true, "Names.Same matches case")
assert_eq(raidTargets[#raidTargets].unit, "raid2", "case fold still uses raid2")

stub.group.raid2 = { name = "Chuckroast-Whitemane" }
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "Names.Same matches a realm suffix")
assert_eq(raidTargets[#raidTargets].unit, "raid2", "realm suffix still uses raid2")

ok, err = Markers:MarkCandidate("Ghost")
assert_eq(ok, false, "unknown grouped name is false")
assert_eq(err, "unit not found", "unknown name names the error")

ok, err = Markers:MarkCandidate(nil)
assert_eq(ok, false, "nil name is false")
assert_eq(err, "invalid name", "nil name is invalid")
ok, err = Markers:MarkCandidate("")
assert_eq(ok, false, "empty name is false")
assert_eq(err, "invalid name", "empty name is invalid")
ok, err = Markers:MarkCandidate(1)
assert_eq(ok, false, "numeric name is false")
assert_eq(err, "invalid name", "numeric name is invalid")

ok, err = Markers:Target("  Chuckroast  ")
assert_eq(ok, true, "padded Target trims")
assert_eq(targetCalls[#targetCalls].name, "Chuckroast", "TargetUnit receives the trimmed name")
assert_eq(targetCalls[#targetCalls].exact, true, "padded Target still exact-matches")

--------------------------------------------------------------------------------
-- MarkFighters indices 2 and 3. Clear index 0. Atomic miss.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, true, "MarkFighters is true when both resolve")
assert_eq(err, nil, "successful MarkFighters has no error")
assert_eq(#raidTargets, 2, "MarkFighters spies two SetRaidTarget calls")
assert_eq(raidTargets[1].unit, "raid2", "fighter A is raid2")
assert_eq(raidTargets[1].index, 2, "fighter A is index 2")
assert_eq(raidTargets[2].unit, "raid3", "fighter B is raid3")
assert_eq(raidTargets[2].index, 3, "fighter B is index 3")
view = Markers:GetView()
assert_eq(view.verb, "MarkFighters", "view records MarkFighters")
assert_eq(view.unitA, "raid2", "view records fighter A unit")
assert_eq(view.unitB, "raid3", "view records fighter B unit")
assert_eq(view.indexA, 2, "view records fighter A index")
assert_eq(view.indexB, 3, "view records fighter B index")
assert_eq(view.nameA, "Chuckroast", "view records fighter A name")
assert_eq(view.nameB, "Tendermage", "view records fighter B name")

for i = #raidTargets, 1, -1 do raidTargets[i] = nil end
ok, err = Markers:MarkFighters("Chuckroast", "Ghost")
assert_eq(ok, false, "MarkFighters refuses a missing fighter")
assert_eq(err, "unit not found", "missing fighter names the error")
assert_eq(#raidTargets, 0, "partial MarkFighters does not mark")

ok, err = Markers:Clear("Chuckroast")
assert_eq(ok, true, "Clear is true when the unit resolves")
assert_eq(raidTargets[#raidTargets].unit, "raid2", "Clear uses the scanned token")
assert_eq(raidTargets[#raidTargets].index, 0, "Clear sets index 0")
assert_eq(Markers:GetView().index, 0, "Clear view records index 0")

--------------------------------------------------------------------------------
-- Party prefix. Target still works ungrouped.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
stub.inRaid = false
stub.groupSize = 2
stub.group = {
  party1 = { name = "Chuckroast" },
  party2 = { name = "Tendermage" },
}
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "party MarkCandidate is true")
assert_eq(raidTargets[1].unit, "party1", "party scan uses party1")
assert_eq(raidTargets[1].index, 1, "party candidate is still star")

reset()
Runtime:StartEvent()
popeFlag = true
ok, err = Markers:Target("Chuckroast")
assert_eq(ok, true, "ungrouped Event Pope Target still runs")
assert_eq(#targetCalls, 1, "ungrouped Target still spies TargetUnit")
assert_eq(#raidTargets, 0, "ungrouped Target does not mark")

--------------------------------------------------------------------------------
-- B16-D: grouped + Pope + Event, local stub player Beefina → "player".
-- Party scan pins stay. Quiet / ungrouped / unlisted Pope still refuse.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Beefina")
assert_eq(ok, true, "Event Pope grouped MarkCandidate on player is true")
assert_eq(err, nil, "successful player MarkCandidate has no error")
assert_eq(#raidTargets, 1, "player MarkCandidate spies SetRaidTarget once")
assert_eq(raidTargets[1].unit, "player", "MarkCandidate uses the player UnitToken")
assert_eq(raidTargets[1].index, 1, "player MarkCandidate still places star index 1")
assert_eq(raidTargets[1].unit ~= "raid1", true, "player mark does not use the raid1 pin")
view = Markers:GetView()
assert_eq(view.ok, true, "player MarkCandidate view records success")
assert_eq(view.verb, "MarkCandidate", "player MarkCandidate view records the verb")
assert_eq(view.name, "Beefina", "player MarkCandidate view records the local name")
assert_eq(view.unit, "player", "player MarkCandidate view records the player token")
assert_eq(view.index, 1, "player MarkCandidate view records star index 1")

ok, err = Markers:MarkCandidate("beefina")
assert_eq(ok, true, "Names.Same matches player case")
assert_eq(raidTargets[#raidTargets].unit, "player", "player case fold still uses player")

stub.playerName = "Beefina-Whitemane"
ok, err = Markers:MarkCandidate("Beefina")
assert_eq(ok, true, "Names.Same matches a player realm suffix")
assert_eq(raidTargets[#raidTargets].unit, "player", "player realm suffix still uses player")
stub.playerName = "Beefina"

for i = #raidTargets, 1, -1 do raidTargets[i] = nil end
ok, err = Markers:MarkFighters("Beefina", "Chuckroast")
assert_eq(ok, true, "MarkFighters is true when A is the player")
assert_eq(err, nil, "successful player MarkFighters has no error")
assert_eq(#raidTargets, 2, "player MarkFighters spies two SetRaidTarget calls")
assert_eq(raidTargets[1].unit, "player", "fighter A is the player UnitToken")
assert_eq(raidTargets[1].index, 2, "fighter A is still index 2")
assert_eq(raidTargets[2].unit, "raid2", "fighter B stays the scanned raid token")
assert_eq(raidTargets[2].index, 3, "fighter B is still index 3")
view = Markers:GetView()
assert_eq(view.unitA, "player", "view records fighter A as player")
assert_eq(view.unitB, "raid2", "view records fighter B as raid2")
assert_eq(view.indexA, 2, "view records fighter A index")
assert_eq(view.indexB, 3, "view records fighter B index")

for i = #raidTargets, 1, -1 do raidTargets[i] = nil end
ok, err = Markers:MarkFighters("Chuckroast", "Beefina")
assert_eq(ok, true, "MarkFighters is true when B is the player")
assert_eq(raidTargets[1].unit, "raid2", "fighter A stays the scanned raid token")
assert_eq(raidTargets[1].index, 2, "fighter A is still index 2")
assert_eq(raidTargets[2].unit, "player", "fighter B is the player UnitToken")
assert_eq(raidTargets[2].index, 3, "fighter B is still index 3")

reset()
Runtime:StartEvent()
popeFlag = true
stub.inRaid = false
stub.groupSize = 2
stub.group = {
  party1 = { name = "Chuckroast" },
  party2 = { name = "Tendermage" },
}
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "party scan pin stays after player resolve")
assert_eq(raidTargets[1].unit, "party1", "party scan still uses party1")
assert_eq(raidTargets[1].index, 1, "party candidate is still star")
ok, err = Markers:MarkCandidate("Beefina")
assert_eq(ok, true, "party MarkCandidate on player is true")
assert_eq(raidTargets[#raidTargets].unit, "player", "party player mark uses player not partyN")
assert_eq(raidTargets[#raidTargets].index, 1, "party player mark is still star")
ok, err = Markers:MarkFighters("Beefina", "Chuckroast")
assert_eq(ok, true, "party MarkFighters is true when A is the player")
assert_eq((raidTargets[#raidTargets - 1] or {}).unit, "player", "party fighter A is the player token")
assert_eq((raidTargets[#raidTargets] or {}).unit, "party1", "party fighter B stays party1")

reset()
Runtime:StartEvent()
popeFlag = true
ok, err = Markers:MarkCandidate("Beefina")
assert_eq(ok, false, "ungrouped player MarkCandidate is false")
assert_eq(err, "not in a group", "ungrouped player Mark still refuses")
assert_eq(#raidTargets, 0, "ungrouped player Mark does not SetRaidTarget")
ok, err = Markers:MarkFighters("Beefina", "Chuckroast")
assert_eq(ok, false, "ungrouped player MarkFighters is false")
assert_eq(err, "not in a group", "ungrouped player MarkFighters still refuses")

reset()
ok, err = Markers:MarkCandidate("Beefina")
assert_eq(ok, false, "Quiet player MarkCandidate is false")
assert_eq(err, "quiet", "Quiet player Mark names quiet")
assert_eq(#raidTargets, 0, "Quiet player Mark does not SetRaidTarget")
ok, err = Markers:MarkFighters("Beefina", "Chuckroast")
assert_eq(ok, false, "Quiet player MarkFighters is false")
assert_eq(err, "quiet", "Quiet player MarkFighters names quiet")

reset()
Runtime:StartEvent()
popeFlag = false
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Beefina")
assert_eq(ok, false, "unlisted Pope player MarkCandidate is false")
assert_eq(err, "not a registered pope", "unlisted Pope player Mark names the error")
assert_eq(#raidTargets, 0, "unlisted Pope player Mark does not SetRaidTarget")
ok, err = Markers:MarkFighters("Beefina", "Chuckroast")
assert_eq(ok, false, "unlisted Pope player MarkFighters is false")
assert_eq(err, "not a registered pope", "unlisted Pope player MarkFighters names the error")

--------------------------------------------------------------------------------
-- B18-D: grouped + Pope + Event Clear("Beefina") spies "player", 0.
-- Quiet / ungrouped Clear still refuse. B16-D Mark player pins stay.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:Clear("Beefina")
assert_eq(ok, true, "Event Pope grouped Clear on player is true")
assert_eq(err, nil, "successful player Clear has no error")
assert_eq(#raidTargets, 1, "player Clear spies SetRaidTarget once")
assert_eq(raidTargets[1].unit, "player", "Clear uses the player UnitToken")
assert_eq(raidTargets[1].index, 0, "Clear sets index 0")
assert_eq(raidTargets[1].unit ~= "raid1", true, "player Clear does not use the raid1 pin")
view = Markers:GetView()
assert_eq(view.ok, true, "player Clear view records success")
assert_eq(view.verb, "Clear", "player Clear view records the verb")
assert_eq(view.name, "Beefina", "player Clear view records the local name")
assert_eq(view.unit, "player", "player Clear view records the player token")
assert_eq(view.index, 0, "player Clear view records index 0")

reset()
Runtime:StartEvent()
popeFlag = true
ok, err = Markers:Clear("Beefina")
assert_eq(ok, false, "ungrouped player Clear is false")
assert_eq(err, "not in a group", "ungrouped player Clear still refuses")
assert_eq(#raidTargets, 0, "ungrouped player Clear does not SetRaidTarget")

reset()
ok, err = Markers:Clear("Beefina")
assert_eq(ok, false, "Quiet player Clear is false")
assert_eq(err, "quiet", "Quiet player Clear names quiet")
assert_eq(#raidTargets, 0, "Quiet player Clear does not SetRaidTarget")

--------------------------------------------------------------------------------
-- B22-C: grouped (IsInRaid) + Pope + Event, GetNumGroupMembers nil:
-- MarkCandidate("Beefina") spies SetRaidTarget("player", …).
-- Existing missing-group-APIs pin (both nil) stays fail-closed below.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
do
  local savedCount = GetNumGroupMembers
  GetNumGroupMembers = nil
  ok, err = Markers:MarkCandidate("Beefina")
  assert_eq(ok, true, "grouped player MarkCandidate without GetNumGroupMembers is true")
  assert_eq(err, nil, "successful player Mark without count API has no error")
  assert_eq(#raidTargets, 1, "player Mark without count API spies SetRaidTarget once")
  assert_eq((raidTargets[1] or {}).unit, "player", "player Mark without count API uses the player token")
  assert_eq((raidTargets[1] or {}).index, 1, "player Mark without count API still places star")
  GetNumGroupMembers = savedCount
end

--------------------------------------------------------------------------------
-- B32-D: new Mark* applyMark index 0 on remembered last.unit / last.unitA /
-- last.unitB that are not in the new keep-set. Do not call Markers:Clear.
-- Same-unit remake does not clear-then-mark. First mark still one spy.
-- Fail-closed gates do not clear. Quiet / ungrouped / player-token pins stay.
--------------------------------------------------------------------------------
do
  local markStart = src:find("function Markers:MarkCandidate", 1, true)
  local fightStart = src:find("function Markers:MarkFighters", 1, true)
  local clearStart = src:find("function Markers:Clear", 1, true)
  assert_true(markStart ~= nil and fightStart ~= nil and clearStart ~= nil, "Mark* and Clear are findable")
  local markBody = src:sub(markStart, fightStart - 1)
  local fightBody = src:sub(fightStart, clearStart - 1)
  assert_eq(markBody:find(":Clear(", 1, true), nil, "MarkCandidate does not call Clear")
  assert_eq(fightBody:find(":Clear(", 1, true), nil, "MarkFighters does not call Clear")
  assert_true(markBody:find("clearPrior", 1, true) ~= nil, "MarkCandidate calls clearPrior")
  assert_true(fightBody:find("clearPrior", 1, true) ~= nil, "MarkFighters calls clearPrior")
end

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B32-D first MarkCandidate is true")
assert_eq(err, nil, "B32-D first MarkCandidate has no error")
assert_eq(#raidTargets, 1, "first MarkCandidate still one SetRaidTarget spy")
assert_eq((raidTargets[1] or {}).unit, "raid2", "first MarkCandidate marks A")
assert_eq((raidTargets[1] or {}).index, 1, "first MarkCandidate is star 1")

ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "same-name remake is true")
assert_eq(#raidTargets, 2, "same-name remake does not add a clear spy")
assert_eq((raidTargets[2] or {}).unit, "raid2", "same-name remake marks the same unit")
assert_eq((raidTargets[2] or {}).index, 1, "same-name remake is still star 1")
assert_eq((raidTargets[2] or {}).index ~= 0, true, "same-name remake has no extra 0 on that unit")

ok, err = Markers:MarkCandidate("Ghost")
assert_eq(ok, false, "unknown remake still refuses")
assert_eq(err, "unit not found", "unknown remake names the error")
assert_eq(#raidTargets, 2, "unit-not-found remake does not clear prior")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "A then B starts with A")
assert_eq(#raidTargets, 1, "A then B first mark is one spy")
ok, err = Markers:MarkCandidate("Tendermage")
assert_eq(ok, true, "MarkCandidate B after A is true")
assert_eq(#raidTargets, 3, "A then B spies A, clear A, then B")
assert_eq((raidTargets[2] or {}).unit, "raid2", "A then B clears A")
assert_eq((raidTargets[2] or {}).index, 0, "A then B clears A at index 0")
assert_eq((raidTargets[3] or {}).unit, "raid3", "A then B marks B")
assert_eq((raidTargets[3] or {}).index, 1, "A then B marks B at star 1")

reset()
Runtime:StartEvent()
popeFlag = true
stub.playerName = "Beefina"
stub.inRaid = true
stub.groupSize = 4
stub.group = {
  raid1 = { name = "Beefina" },
  raid2 = { name = "Chuckroast" },
  raid3 = { name = "Tendermage" },
  raid4 = { name = "Brisket" },
}
ok, err = Markers:MarkCandidate("Brisket")
assert_eq(ok, true, "candidate not in later pair marks")
assert_eq(#raidTargets, 1, "first candidate still one spy")
assert_eq((raidTargets[1] or {}).unit, "raid4", "candidate not in pair is raid4")
assert_eq((raidTargets[1] or {}).index, 1, "candidate not in pair is star 1")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, true, "MarkFighters after outsider candidate is true")
assert_eq(#raidTargets, 4, "MarkFighters after outsider clears the candidate then marks the pair")
assert_eq((raidTargets[2] or {}).unit, "raid4", "MarkFighters clears the outsider candidate")
assert_eq((raidTargets[2] or {}).index, 0, "outsider candidate clear is index 0")
assert_eq((raidTargets[3] or {}).unit, "raid2", "fighter A is raid2")
assert_eq((raidTargets[3] or {}).index, 2, "fighter A is index 2")
assert_eq((raidTargets[4] or {}).unit, "raid3", "fighter B is raid3")
assert_eq((raidTargets[4] or {}).index, 3, "fighter B is index 3")

for i = #raidTargets, 1, -1 do raidTargets[i] = nil end
ok, err = Markers:MarkCandidate("Brisket")
assert_eq(ok, true, "MarkCandidate after MarkFighters is true")
assert_eq(#raidTargets, 3, "MarkCandidate after fighters clears both then marks")
assert_eq((raidTargets[1] or {}).unit, "raid2", "prior fighter A is cleared")
assert_eq((raidTargets[1] or {}).index, 0, "prior fighter A clear is index 0")
assert_eq((raidTargets[2] or {}).unit, "raid3", "prior fighter B is cleared")
assert_eq((raidTargets[2] or {}).index, 0, "prior fighter B clear is index 0")
assert_eq((raidTargets[3] or {}).unit, "raid4", "new candidate is raid4")
assert_eq((raidTargets[3] or {}).index, 1, "new candidate is star 1")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "keep-set candidate marks")
for i = #raidTargets, 1, -1 do raidTargets[i] = nil end
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, true, "MarkFighters after in-pair candidate is true")
assert_eq(#raidTargets, 2, "in-pair candidate is kept; no extra 0")
assert_eq((raidTargets[1] or {}).unit, "raid2", "kept candidate is remade as fighter A")
assert_eq((raidTargets[1] or {}).index, 2, "kept candidate is index 2 not 0")
assert_eq((raidTargets[2] or {}).unit, "raid3", "fighter B is raid3")
assert_eq((raidTargets[2] or {}).index, 3, "fighter B is index 3")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Beefina")
assert_eq(ok, true, "player first mark is true")
assert_eq(#raidTargets, 1, "player first mark still one spy")
assert_eq((raidTargets[1] or {}).unit, "player", "player first mark uses player token")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "MarkCandidate after player prior is true")
assert_eq(#raidTargets, 3, "player prior is cleared then raid2 is marked")
assert_eq((raidTargets[2] or {}).unit, "player", "player prior is cleared")
assert_eq((raidTargets[2] or {}).index, 0, "player prior clear is index 0")
assert_eq((raidTargets[3] or {}).unit, "raid2", "new mark is raid2")
assert_eq((raidTargets[3] or {}).index, 1, "new mark is star 1")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "pre-Quiet mark is true")
assert_eq(#raidTargets, 1, "pre-Quiet mark is one spy")
assert_true(Runtime:EndEvent() ~= nil, "EndEvent returns to QUIET for refuse pin")
ok, err = Markers:MarkCandidate("Tendermage")
assert_eq(ok, false, "Quiet after a live mark still refuses")
assert_eq(err, "quiet", "Quiet after a live mark names quiet")
assert_eq(#raidTargets, 1, "Quiet refuse does not clear prior")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "pre-ungrouped mark is true")
assert_eq(#raidTargets, 1, "pre-ungrouped mark is one spy")
resetGroup()
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, false, "ungrouped after a live mark still refuses")
assert_eq(err, "not in a group", "ungrouped after a live mark names the error")
assert_eq(#raidTargets, 1, "ungrouped refuse does not clear prior")

--------------------------------------------------------------------------------
-- B33-C: refuse copies last.unit / last.unitA / last.unitB (and indices)
-- when the caller omitted them. Ghost miss after A keeps A's token so
-- MarkCandidate B can still clearPrior. Successful Mark* still replace
-- last. Successful Clear still records Clear. First Quiet refuse stays
-- empty units (pinned above). Do not call Markers:Clear. clearPrior stays.
--------------------------------------------------------------------------------
do
  local keepStart = src:find("local function keepLastUnits", 1, true)
  local refuseStart = src:find("local function refuse", 1, true)
  local targetStart = src:find("function Markers:Target", 1, true)
  assert_true(refuseStart ~= nil and targetStart ~= nil, "refuse and Target are findable")
  local refuseBody = src:sub(keepStart or refuseStart, targetStart - 1)
  assert_true(refuseBody:find("fields.unit = last.unit", 1, true) ~= nil, "refuse copies last.unit")
  assert_true(refuseBody:find("fields.unitA = last.unitA", 1, true) ~= nil, "refuse copies last.unitA")
  assert_true(refuseBody:find("fields.unitB = last.unitB", 1, true) ~= nil, "refuse copies last.unitB")
  assert_true(refuseBody:find("fields.index = last.index", 1, true) ~= nil, "refuse copies last.index")
  assert_true(refuseBody:find("fields.indexA = last.indexA", 1, true) ~= nil, "refuse copies last.indexA")
  assert_true(refuseBody:find("fields.indexB = last.indexB", 1, true) ~= nil, "refuse copies last.indexB")
  assert_eq(refuseBody:find(":Clear(", 1, true), nil, "refuse does not call Clear")
end

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B33-C MarkCandidate A is true")
assert_eq(err, nil, "B33-C MarkCandidate A has no error")
assert_eq(#raidTargets, 1, "B33-C first A is one spy")
assert_eq((raidTargets[1] or {}).unit, "raid2", "B33-C A marks raid2")
assert_eq(Markers:GetView().unit, "raid2", "B33-C A view is raid2")

ok, err = Markers:MarkCandidate("Ghost")
assert_eq(ok, false, "Ghost miss after A refuses")
assert_eq(err, "unit not found", "Ghost miss after A names the error")
assert_eq(#raidTargets, 1, "Ghost miss after A does not SetRaidTarget")
view = Markers:GetView()
assert_eq(view.ok, false, "Ghost miss view records refuse")
assert_eq(view.verb, "MarkCandidate", "Ghost miss view records the verb")
assert_eq(view.name, "Ghost", "Ghost miss view records Ghost")
assert_eq(view.unit, "raid2", "Ghost miss keeps A's unit")
assert_eq(view.index, 1, "Ghost miss keeps A's index")

ok, err = Markers:MarkCandidate("Tendermage")
assert_eq(ok, true, "MarkCandidate B after Ghost miss is true")
assert_eq(#raidTargets, 3, "B after Ghost spies A, clear A, then B")
assert_eq((raidTargets[2] or {}).unit, "raid2", "B after Ghost clears A")
assert_eq((raidTargets[2] or {}).index, 0, "B after Ghost clears A at 0")
assert_eq((raidTargets[3] or {}).unit, "raid3", "B after Ghost marks B")
assert_eq((raidTargets[3] or {}).index, 1, "B after Ghost marks B at 1")
assert_eq(Markers:GetView().ok, true, "successful B replaces last ok")
assert_eq(Markers:GetView().verb, "MarkCandidate", "successful B replaces last verb")
assert_eq(Markers:GetView().unit, "raid3", "successful B replaces last.unit")
assert_eq(Markers:GetView().index, 1, "successful B replaces last.index")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, true, "B33-C MarkFighters pair is true")
ok, err = Markers:MarkCandidate("Ghost")
assert_eq(ok, false, "Ghost miss after fighters refuses")
assert_eq(err, "unit not found", "Ghost miss after fighters names the error")
view = Markers:GetView()
assert_eq(view.unitA, "raid2", "Ghost miss keeps last.unitA")
assert_eq(view.unitB, "raid3", "Ghost miss keeps last.unitB")
assert_eq(view.indexA, 2, "Ghost miss keeps last.indexA")
assert_eq(view.indexB, 3, "Ghost miss keeps last.indexB")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B33-C pre-Clear A is true")
ok, err = Markers:Clear("Chuckroast")
assert_eq(ok, true, "successful Clear after A is true")
view = Markers:GetView()
assert_eq(view.verb, "Clear", "successful Clear still records Clear")
assert_eq(view.ok, true, "successful Clear still records ok")
assert_eq(view.unit, "raid2", "successful Clear still records the unit")
assert_eq(view.index, 0, "successful Clear still records index 0")

--------------------------------------------------------------------------------
-- B34-C: successful Target keeps last.unit / last.unitA / last.unitB
-- (and indices) when omitted, same == nil copy as refuse. After
-- MarkCandidate A → Target B → MarkCandidate C, clearPrior can still
-- clear A. MarkFighters pair + Target keeps unitA / unitB. Failed
-- Target still keeps (refuse). Do not call Markers:Clear from Target.
--------------------------------------------------------------------------------
do
  local targetStart = src:find("function Markers:Target", 1, true)
  local markStart = src:find("function Markers:MarkCandidate", 1, true)
  assert_true(targetStart ~= nil and markStart ~= nil, "Target and MarkCandidate are findable")
  local targetBody = src:sub(targetStart, markStart - 1)
  assert_true(targetBody:find("keepLastUnits", 1, true) ~= nil, "Target success path copies last units when omitted")
  assert_true(targetBody:find("remember(keepLastUnits", 1, true) ~= nil, "Target success remembers kept units")
  assert_eq(targetBody:find(":Clear(", 1, true), nil, "Target does not call Clear")
  assert_eq(targetBody:find("clearPrior", 1, true), nil, "Target does not call clearPrior")
end

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B34-C MarkCandidate A is true")
assert_eq(err, nil, "B34-C MarkCandidate A has no error")
assert_eq(#raidTargets, 1, "B34-C first A is one spy")
assert_eq((raidTargets[1] or {}).unit, "raid2", "B34-C A marks raid2")
assert_eq(Markers:GetView().unit, "raid2", "B34-C A view is raid2")
assert_eq(Markers:GetView().index, 1, "B34-C A view index is 1")

ok, err = Markers:Target("Tendermage")
assert_eq(ok, true, "successful Target of another name is true")
assert_eq(err, nil, "successful Target has no error")
assert_eq(#targetCalls, 1, "Target spies TargetUnit once")
assert_eq(targetCalls[1].name, "Tendermage", "TargetUnit receives the other name")
assert_eq(#raidTargets, 1, "successful Target does not SetRaidTarget")
view = Markers:GetView()
assert_eq(view.ok, true, "successful Target view records ok")
assert_eq(view.verb, "Target", "successful Target view records the verb")
assert_eq(view.name, "Tendermage", "successful Target view records the name")
assert_eq(view.unit, "raid2", "successful Target keeps A's unit")
assert_eq(view.index, 1, "successful Target keeps A's index")

ok, err = Markers:MarkCandidate("Tendermage")
assert_eq(ok, true, "MarkCandidate B after Target is true")
assert_eq(#raidTargets, 3, "B after Target spies A, clear A, then B")
assert_eq((raidTargets[2] or {}).unit, "raid2", "B after Target clears A")
assert_eq((raidTargets[2] or {}).index, 0, "B after Target clears A at 0")
assert_eq((raidTargets[3] or {}).unit, "raid3", "B after Target marks B")
assert_eq((raidTargets[3] or {}).index, 1, "B after Target marks B at 1")
assert_eq(Markers:GetView().ok, true, "successful B after Target replaces last ok")
assert_eq(Markers:GetView().verb, "MarkCandidate", "successful B after Target replaces last verb")
assert_eq(Markers:GetView().unit, "raid3", "successful B after Target replaces last.unit")
assert_eq(Markers:GetView().index, 1, "successful B after Target replaces last.index")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, true, "B34-C MarkFighters pair is true")
ok, err = Markers:Target("Beefina")
assert_eq(ok, true, "Target after fighters is true")
view = Markers:GetView()
assert_eq(view.verb, "Target", "Target after fighters records Target")
assert_eq(view.ok, true, "Target after fighters records ok")
assert_eq(view.unitA, "raid2", "Target after fighters keeps last.unitA")
assert_eq(view.unitB, "raid3", "Target after fighters keeps last.unitB")
assert_eq(view.indexA, 2, "Target after fighters keeps last.indexA")
assert_eq(view.indexB, 3, "Target after fighters keeps last.indexB")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B34-C pre-fail Target A is true")
do
  TargetUnit = function()
    error("protected")
  end
  local threw, callOk = pcall(function()
    return Markers:Target("Tendermage")
  end)
  assert_eq(threw, true, "failed Target is pcalled")
  assert_eq(callOk, false, "failed Target is false")
  view = Markers:GetView()
  assert_eq(view.ok, false, "failed Target view records refuse")
  assert_eq(view.verb, "Target", "failed Target view records the verb")
  assert_eq(view.unit, "raid2", "failed Target keeps A's unit")
  assert_eq(view.index, 1, "failed Target keeps A's index")
  stubMarkApis()
end

--------------------------------------------------------------------------------
-- B35-C: keepLastUnits also copies last.nameA / last.nameB when omitted
-- (== nil). Target success still sets name = trimmed (who was targeted).
-- Do not merge name vs unit. Mark* / Clear success still replace.
-- First Quiet refuse stays empty names. Do not call Markers:Clear from Target.
--------------------------------------------------------------------------------
do
  local keepStart = src:find("local function keepLastUnits", 1, true)
  local refuseStart = src:find("local function refuse", 1, true)
  assert_true(keepStart ~= nil and refuseStart ~= nil, "keepLastUnits and refuse are findable")
  local keepBody = src:sub(keepStart, refuseStart - 1)
  assert_true(keepBody:find("fields.nameA = last.nameA", 1, true) ~= nil, "keepLastUnits copies last.nameA when omitted")
  assert_true(keepBody:find("fields.nameB = last.nameB", 1, true) ~= nil, "keepLastUnits copies last.nameB when omitted")
end

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, true, "B35-C MarkFighters pair is true")
ok, err = Markers:Target("Beefina")
assert_eq(ok, true, "B35-C Target after fighters is true")
view = Markers:GetView()
assert_eq(view.verb, "Target", "B35-C Target after fighters records Target")
assert_eq(view.ok, true, "B35-C Target after fighters records ok")
assert_eq(view.name, "Beefina", "B35-C Target after fighters name is the targeted name")
assert_eq(view.nameA, "Chuckroast", "B35-C Target after fighters keeps nameA")
assert_eq(view.nameB, "Tendermage", "B35-C Target after fighters keeps nameB")
assert_eq(view.unitA, "raid2", "B35-C Target after fighters keeps unitA")
assert_eq(view.unitB, "raid3", "B35-C Target after fighters keeps unitB")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B35-C MarkCandidate A is true")
ok, err = Markers:Target("Tendermage")
assert_eq(ok, true, "B35-C Target after A is true")
view = Markers:GetView()
assert_eq(view.name, "Tendermage", "B35-C Target after A name is the Target")
assert_eq(view.unit, "raid2", "B35-C Target after A keeps prior unit")

--------------------------------------------------------------------------------
-- B38-C: Markers:Forget() works in Quiet. Pope-gated. applyMark(unit, 0)
-- on leftover last.unit / unitA / unitB, then remember empty
-- (verb = "Forget", no units). Do not call Markers:Clear. Clear Quiet
-- refuse stays. Missing SetRaidTarget fail-closed. Isolation wrap stays.
--------------------------------------------------------------------------------
do
  local forgetStart = src:find("function Markers:Forget", 1, true)
  local viewStart = src:find("function Markers:GetView", 1, true)
  assert_true(forgetStart ~= nil and viewStart ~= nil, "Forget and GetView are findable")
  if forgetStart and viewStart then
    local forgetBody = src:sub(forgetStart, viewStart - 1)
    assert_eq(forgetBody:find(":Clear(", 1, true), nil, "Forget does not call Clear")
    assert_true(forgetBody:find("applyMark", 1, true) ~= nil, "Forget applyMarks leftover units")
  end
end

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B38-C MarkCandidate A is true")
assert_eq(err, nil, "B38-C MarkCandidate A has no error")
assert_eq(#raidTargets, 1, "B38-C first A is one spy")
assert_eq((raidTargets[1] or {}).unit, "raid2", "B38-C A marks raid2")
assert_eq(Markers:GetView().unit, "raid2", "B38-C A view is raid2")
assert_true(Runtime:EndEvent() ~= nil, "B38-C EndEvent returns to QUIET")
assert_eq(Runtime:Snapshot().state, "QUIET", "B38-C after EndEvent is QUIET")
for i = #raidTargets, 1, -1 do raidTargets[i] = nil end
ok, err = Markers:Forget()
assert_eq(ok, true, "Quiet Forget after leftover A is true")
assert_eq(err, nil, "Quiet Forget after leftover A has no error")
assert_eq(#raidTargets, 1, "Forget after A spies one SetRaidTarget")
assert_eq((raidTargets[1] or {}).unit, "raid2", "Forget after A clears leftover A")
assert_eq((raidTargets[1] or {}).index, 0, "Forget after A clears leftover A at 0")
view = Markers:GetView()
assert_eq(view.ok, true, "Forget after A view records ok")
assert_eq(view.verb, "Forget", "Forget after A view records the verb")
assert_eq(view.unit, nil, "Forget after A view unit is nil")
assert_eq(view.unitA, nil, "Forget after A view unitA is nil")
assert_eq(view.unitB, nil, "Forget after A view unitB is nil")
ok, err = Markers:Clear("Chuckroast")
assert_eq(ok, false, "Quiet Clear still refuses after Forget")
assert_eq(err, "quiet", "Quiet Clear after Forget still names quiet")
assert_eq(#raidTargets, 1, "Quiet Clear after Forget does not SetRaidTarget")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast", "Tendermage")
ok, err = Markers:MarkFighters("Chuckroast", "Tendermage")
assert_eq(ok, true, "B38-C MarkFighters pair is true")
for i = #raidTargets, 1, -1 do raidTargets[i] = nil end
ok, err = Markers:Forget()
assert_eq(ok, true, "Forget after fighters is true")
assert_eq(err, nil, "Forget after fighters has no error")
assert_eq(#raidTargets, 2, "Forget after fighters spies two SetRaidTarget clears")
assert_eq((raidTargets[1] or {}).unit, "raid2", "Forget after fighters clears A")
assert_eq((raidTargets[1] or {}).index, 0, "Forget after fighters clears A at 0")
assert_eq((raidTargets[2] or {}).unit, "raid3", "Forget after fighters clears B")
assert_eq((raidTargets[2] or {}).index, 0, "Forget after fighters clears B at 0")
view = Markers:GetView()
assert_eq(view.verb, "Forget", "Forget after fighters records Forget")
assert_eq(view.ok, true, "Forget after fighters records ok")
assert_eq(view.unit, nil, "Forget after fighters view unit is nil")
assert_eq(view.unitA, nil, "Forget after fighters view unitA is nil")
assert_eq(view.unitB, nil, "Forget after fighters view unitB is nil")

reset()
popeFlag = true
ok, err = Markers:Forget()
assert_eq(ok, true, "Quiet Forget without prior last is true")
assert_eq(err, nil, "Quiet Forget without prior last has no error")
assert_eq(#raidTargets, 0, "Quiet Forget without prior last does not SetRaidTarget")
view = Markers:GetView()
assert_eq(view.ok, true, "empty Quiet Forget view records ok")
assert_eq(view.verb, "Forget", "empty Quiet Forget view records the verb")
assert_eq(view.unit, nil, "empty Quiet Forget view unit is nil")
assert_eq(view.unitA, nil, "empty Quiet Forget view unitA is nil")
assert_eq(view.unitB, nil, "empty Quiet Forget view unitB is nil")

reset()
popeFlag = false
ok, err = Markers:Forget()
assert_eq(ok, false, "unlisted Pope Forget is false")
assert_eq(err, "not a registered pope", "unlisted Pope Forget names the error")
assert_eq(#raidTargets, 0, "unlisted Pope Forget does not SetRaidTarget")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B38-C leftover before unlisted Forget is true")
popeFlag = false
for i = #raidTargets, 1, -1 do raidTargets[i] = nil end
ok, err = Markers:Forget()
assert_eq(ok, false, "unlisted Pope Forget after leftover is false")
assert_eq(err, "not a registered pope", "unlisted Pope Forget after leftover names the error")
assert_eq(#raidTargets, 0, "unlisted Pope Forget after leftover does not SetRaidTarget")
assert_eq(Markers:GetView().unit, "raid2", "unlisted Pope Forget keeps leftover unit")

reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "B38-C leftover before missing SetRaidTarget is true")
assert_true(Runtime:EndEvent() ~= nil, "B38-C EndEvent before missing SetRaidTarget")
do
  local saved = SetRaidTarget
  SetRaidTarget = nil
  local threw, callOk = pcall(function()
    return Markers:Forget()
  end)
  assert_eq(threw, true, "missing SetRaidTarget Forget does not throw")
  assert_eq(callOk, false, "missing SetRaidTarget Forget is false")
  SetRaidTarget = saved
end
assert_eq(Markers:GetView().unit, "raid2", "missing SetRaidTarget Forget keeps leftover unit")

--------------------------------------------------------------------------------
-- Missing API fail-closed. No throw.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")

local savedSet = SetRaidTarget
SetRaidTarget = nil
local threw, callOk, callErr = pcall(function()
  return Markers:MarkCandidate("Chuckroast")
end)
assert_eq(threw, true, "missing SetRaidTarget does not throw")
assert_eq(callOk, false, "missing SetRaidTarget is false")
SetRaidTarget = savedSet

local savedTarget = TargetUnit
TargetUnit = nil
threw, callOk = pcall(function()
  return Markers:Target("Chuckroast")
end)
assert_eq(threw, true, "missing TargetUnit does not throw")
assert_eq(callOk, false, "missing TargetUnit is false")
TargetUnit = savedTarget

local savedGet = GetRaidTargetIndex
GetRaidTargetIndex = nil
raidTargets = {}
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "missing GetRaidTargetIndex still marks")
assert_eq(#raidTargets, 1, "missing GetRaidTargetIndex still spies SetRaidTarget")
GetRaidTargetIndex = savedGet

local savedNum = GetNumGroupMembers
local savedRaid = IsInRaid
GetNumGroupMembers = nil
IsInRaid = nil
threw, callOk, callErr = pcall(function()
  return Markers:MarkCandidate("Chuckroast")
end)
assert_eq(threw, true, "missing group APIs do not throw")
assert_eq(callOk, false, "missing group APIs are fail-closed")
assert_eq(callErr, "not in a group", "missing group APIs are not grouped")
GetNumGroupMembers = savedNum
IsInRaid = savedRaid

TargetUnit = function()
  error("protected")
end
threw, callOk = pcall(function()
  return Markers:Target("Chuckroast")
end)
assert_eq(threw, true, "TargetUnit error is pcalled")
assert_eq(callOk, false, "TargetUnit error is false")
stubMarkApis()

SetRaidTarget = function()
  error("no assist")
end
threw, callOk = pcall(function()
  return Markers:MarkCandidate("Chuckroast")
end)
assert_eq(threw, true, "SetRaidTarget error is pcalled")
assert_eq(callOk, false, "SetRaidTarget error is false")
stubMarkApis()

--------------------------------------------------------------------------------
-- Missing Runtime is Quiet. EndEvent refuses again. RITE still Event.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
local savedRuntime = COB.Runtime
COB.Runtime = nil
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, false, "missing Runtime MarkCandidate is false")
assert_eq(err, "quiet", "missing Runtime is Quiet")
ok, err = Markers:Target("Chuckroast")
assert_eq(ok, false, "missing Runtime Target is false")
assert_eq(#targetCalls, 0, "missing Runtime does not TargetUnit")
COB.Runtime = savedRuntime

assert_eq(Markers:MarkCandidate("Chuckroast"), true, "restored Runtime marks")
assert_true(Runtime:OpenRite("Knighting", { candidate = 1 }) ~= nil, "OpenRite reaches RITE")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, true, "RITE MarkCandidate is true")
Runtime:CloseRite()
assert_eq(Markers:MarkCandidate("Chuckroast"), true, "CONSEQUENCE MarkCandidate is true")
Runtime:Continue()
assert_eq(Markers:Target("Chuckroast"), true, "ASSEMBLY after Continue still Targets")
assert_true(Runtime:EndEvent() ~= nil, "EndEvent returns to QUIET")
ok, err = Markers:MarkCandidate("Chuckroast")
assert_eq(ok, false, "Quiet after EndEvent is false")
assert_eq(err, "quiet", "EndEvent refuse names quiet")

--------------------------------------------------------------------------------
-- GetView is a copy. Combat flag does not automate. ResetForTests hatch.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
popeFlag = true
armRaid("Chuckroast")
stub.playerInCombat = true
assert_eq(Markers:MarkCandidate("Chuckroast"), true, "combat still marks")
assert_eq(combatCalls, 0, "marking does not StartAttack")
view = Markers:GetView()
view.ok = false
view.unit = "hacked"
view.index = 99
view.mode = "Quiet"
local again = Markers:GetView()
assert_eq(again.ok, true, "mutating GetView does not change ok")
assert_eq(again.unit, "raid2", "mutating GetView does not change the unit")
assert_eq(again.index, 1, "mutating GetView does not change the index")
assert_eq(again.mode, "Event", "mutating GetView does not change the mode")

assert_eq(Markers:Target("Chuckroast"), true, "combat still Targets")
assert_eq(combatCalls, 0, "Target does not AttackTarget")
assert_eq(#stub.chat, 0, "verbs do not SendChatMessage")
assert_eq(#stub.addonMessages, 0, "verbs do not SendAddonMessage")
assert_eq(sounds, 0, "verbs play no sound")

ChurchOfBeef._IN_TEST = false
assert_eq(Markers:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Markers:GetView().ok, true, "out-of-harness reset leaves the last attempt")
ChurchOfBeef._IN_TEST = true
assert_eq(Markers:ResetForTests(), true, "ResetForTests returns under _IN_TEST")
assert_eq(Markers:GetView().ok, nil, "harness reset clears the last attempt")
assert_eq(Markers:GetView().mode, "Event", "harness reset still declares Event")
assert_eq(Markers:GetView().unit, nil, "harness reset clears the unit")

assert_eq(sounds, 0, "the suite played no sound")
assert_eq(combatCalls, 0, "the suite never started combat")
assert_eq(#stub.chat, 0, "the suite never SendChatMessage")
assert_eq(#stub.addonMessages, 0, "the suite never SendAddonMessage")

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
