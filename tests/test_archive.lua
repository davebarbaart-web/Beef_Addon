-- Sacred Archive codec (Phase 2 Lane B). Isolated: Common + Ranks + Store + Archive.
-- Codec only — not a second writer. No Discord, file-picker, reminder, or mirror.
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
dofile("addon/ChurchOfBeef/Core/Archive.lua")

local COB = ChurchOfBeef
local Store = COB.Store
local Archive = COB.Archive
local Ranks = COB.Ranks

local function reset()
  assert_eq(Store:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
end

local restoreCalls = 0
local realRestore = Store.Restore
function Store:Restore(...)
  restoreCalls = restoreCalls + 1
  return realRestore(self, ...)
end

local function craftedExport(mutator)
  local real = Store.Snapshot
  function Store:Snapshot()
    return mutator(real(self))
  end
  local blob, err = Archive:Export()
  Store.Snapshot = real
  return blob, err
end

--------------------------------------------------------------------------------
-- Surface: codec only. Not a writer, not a reminder, not a mirror.
--------------------------------------------------------------------------------
assert_true(Archive ~= nil, "COB.Archive exists")
assert_eq(type(Archive.Export), "function", "Export is the one-action string codec")
assert_eq(type(Archive.Import), "function", "Import restores through the store")
assert_eq(type(Archive.Check), "function", "Check is the integrity + schema gate")
assert_eq(Archive.Restore, nil, "Archive has no Restore of its own")
assert_eq(Archive.Snapshot, nil, "Archive does not fork Snapshot")
assert_eq(Archive.CreateHuman, nil, "Archive does not create humans")
assert_eq(Archive.CreateCharacter, nil, "Archive does not create characters")
assert_eq(Archive.SetRank, nil, "Archive does not set rank")
assert_eq(Archive.RecordGoraResult, nil, "Archive does not record Gora results")
assert_eq(Archive.LinkCharacter, nil, "Archive does not link characters")
assert_eq(Archive.Grant, nil, "no Grant")
assert_eq(Archive.GrantGora, nil, "no GrantGora")
assert_eq(Archive.SetStanding, nil, "no SetStanding")
assert_eq(Archive.AddPoints, nil, "no AddPoints")
assert_eq(Archive.Prophet, nil, "no Prophet")
assert_eq(Archive.Remind, nil, "no weekly reminder")
assert_eq(Archive.PostToDiscord, nil, "no Discord poster")
assert_eq(Archive.WriteFile, nil, "no file-picker writer")
assert_eq(Archive.Mirror, nil, "no cold-mirror writer")
assert_eq(Archive.BeginRecognition, nil, "Recognition is not this lane")
assert_eq(Archive.CreateFrame, nil, "Core codec does not CreateFrame")
assert_eq(Ranks.ById[7], nil, "Ranks.ById has no Prophet / 7")

--------------------------------------------------------------------------------
-- Export of a fresh store is a stamped string, not a wipe and not leftover demo
--------------------------------------------------------------------------------
reset()
restoreCalls = 0
local emptyBlob, emptyErr = Archive:Export()
assert_eq(type(emptyBlob), "string", "Export of an empty store returns a string")
assert_eq(emptyErr, nil, "Export of an empty store has no error")
assert_true(#emptyBlob > 0, "Export string is not empty")
assert_eq(emptyBlob:sub(1, 8), "COBARCH1", "integrity stamp starts with COBARCH1")
assert_eq(restoreCalls, 0, "Export does not call Restore")
assert_true(not emptyBlob:find("ladder", 1, true), "Export does not carry leftover ladder")
assert_true(not emptyBlob:find("scoring", 1, true), "Export does not carry leftover scoring")
assert_true(not emptyBlob:find('"ui"', 1, true), "Export does not carry ui")
assert_true(not emptyBlob:find("Grant", 1, true), "Export does not carry Grant")
assert_true(not emptyBlob:find("points", 1, true), "Export does not carry points")
assert_true(not emptyBlob:find("standing", 1, true), "Export does not carry standing")

restoreCalls = 0
assert_eq(Archive:Check(emptyBlob), true, "Check accepts a valid empty-store archive")
assert_eq(restoreCalls, 0, "Check does not call Restore")

restoreCalls = 0
assert_eq(Archive:Import(emptyBlob), true, "Import of a valid empty-store archive Restores")
assert_eq(restoreCalls, 1, "Import calls Restore once after checks pass")
assert_eq(Store:GetHuman(1), nil, "empty-store restore has no humans")
local again = Archive:Export()
assert_eq(again, emptyBlob, "Export is deterministic for the same snapshot")
assert_eq(Store:CreateHuman().id, 1, "ids after empty restore start at 1")

--------------------------------------------------------------------------------
-- Round-trip preserves Bible-named rows (Law 7)
--------------------------------------------------------------------------------
reset()
local human = Store:CreateHuman({ name = "Snap" }, 6000)
local alt = Store:CreateCharacter({
  name = "Snapalt",
  class = "Mage",
  level = 70,
  professions = { "Tailoring", "Enchanting" },
}, 6001)
local foe = Store:CreateCharacter({ name = "Foe", class = "Warrior", level = 70 }, 6001)
Store:LinkCharacter(alt.id, human.id, 6002)
Store:SetRank(human.id, 4, 6003)
Store:SetCouncil(human.id, true)
Store:AddHonorific(human.id, "Defender of the Faith")
Store:AddHonorific(human.id, "Iron Chin")
Store:RecordGoraResult(alt.id, {
  opponentId = foe.id,
  ruling = "victor",
  won = true,
  famousUpset = true,
  notable = true,
}, 6004)
Store:RecordGoraResult(alt.id, {
  opponentId = foe.id,
  ruling = "cowardice",
  won = false,
}, 6005)
Store:RecordGoraResult(alt.id, {
  opponentId = foe.id,
  ruling = "void",
}, 6006)
Store:TombstoneHuman(human.id, 6007)
Store:TombstoneCharacter(foe.id, 6008)
Store:AppendCeremony("Gora", { alt.id, foe.id }, 6009)
Store:FlagMoment("Shattrath", 6010)

local unlinked = Store:CreateCharacter({ name = "Wanderer" }, 6011)
assert_eq(Store:RankForCharacter(unlinked.id), nil, "unlinked character has no rank before export")

local knight = Store:CreateHuman({ name = "Knighted" }, 6012)
Store:SetRank(knight.id, 3, 6013)
local fresh = Store:CreateHuman({ name = "Recruit" }, 6014)
Store:SetRank(fresh.id, 1, 6015)
local cooked = Store:CreateHuman({ name = "Cooked" }, 6016)
Store:SetRank(cooked.id, 2, 6017)
local butcher = Store:CreateHuman({ name = "Butcher" }, 6018)
Store:SetRank(butcher.id, 5, 6019)
local councilH = Store:CreateHuman({ name = "Councillor" }, 6020)
Store:SetRank(councilH.id, 6, 6021)
local unranked = Store:CreateHuman({ name = "Unranked" }, 6022)

local beforeHuman = Store:GetHuman(human.id)
local beforeAlt = Store:GetCharacter(alt.id)
local beforeFoe = Store:GetCharacter(foe.id)
local beforeUnlinked = Store:GetCharacter(unlinked.id)
local beforeLog = Store:GetCeremonyLog()
local beforeMoments = Store:GetMarkedMoments()
local beforeKnight = Store:GetHuman(knight.id)
local beforeFresh = Store:GetHuman(fresh.id)
local beforeCooked = Store:GetHuman(cooked.id)
local beforeButcher = Store:GetHuman(butcher.id)
local beforeCouncil = Store:GetHuman(councilH.id)
local beforeUnranked = Store:GetHuman(unranked.id)
local beforeSnap = Store:Snapshot()

restoreCalls = 0
local blob = Archive:Export()
assert_eq(type(blob), "string", "Export of a filled store returns a string")
assert_eq(restoreCalls, 0, "filled Export does not Restore")
assert_eq(Archive:Check(blob), true, "Check accepts a filled archive")

reset()
assert_eq(Store:GetHuman(human.id), nil, "reset cleared the live human")
restoreCalls = 0
assert_eq(Archive:Import(blob), true, "Import Restores a filled archive")
assert_eq(restoreCalls, 1, "filled Import calls Restore once")

local afterHuman = Store:GetHuman(human.id)
assert_true(afterHuman ~= nil, "round-trip keeps the human")
assert_eq(afterHuman.id, beforeHuman.id, "human id is preserved")
assert_eq(afterHuman.name, "Snap", "human name is preserved")
assert_eq(afterHuman.rankId, 4, "Lord rank is preserved")
assert_eq(afterHuman.elevationAt, 6003, "elevationAt is preserved")
assert_eq(afterHuman.inactive, true, "human tombstone is preserved")
assert_eq(afterHuman.council, true, "Council flag is preserved")
assert_eq(afterHuman.honorifics[1], "Defender of the Faith", "first honorific is preserved")
assert_eq(afterHuman.honorifics[2], "Iron Chin", "second honorific is preserved")
assert_eq(#afterHuman.honorifics, 2, "honorific count is preserved")
assert_eq(afterHuman.characterIds[1], alt.id, "linked character id is preserved")
assert_eq(afterHuman.history[1].kind, "created", "created history is preserved")
assert_eq(afterHuman.history[2].kind, "linked", "linked history is preserved")
assert_eq(afterHuman.history[3].kind, "inactive", "tombstone history is preserved")
assert_eq(afterHuman.gora, nil, "human still does not own a Gora record")

local afterAlt = Store:GetCharacter(alt.id)
assert_eq(afterAlt.name, "Snapalt", "character name is preserved")
assert_eq(afterAlt.class, "Mage", "class is preserved")
assert_eq(afterAlt.level, 70, "level is preserved")
assert_eq(afterAlt.professions[1], "Tailoring", "profession is preserved")
assert_eq(afterAlt.professions[2], "Enchanting", "second profession is preserved")
assert_eq(afterAlt.humanId, human.id, "link is preserved")
assert_eq(afterAlt.inactive, false, "active character stays active")
assert_eq(afterAlt.rankId, nil, "character row has no rankId")
assert_eq(afterAlt.gora.wins, 1, "Gora wins are preserved")
assert_eq(afterAlt.gora.losses, 1, "Gora losses are preserved")
assert_eq(afterAlt.gora.streak, -1, "fight-record streak is preserved")
assert_eq(afterAlt.gora.defenses, nil, "defenses are not invented")
assert_eq(afterAlt.gora.defenseCount, nil, "defenseCount is not invented")
assert_eq(afterAlt.gora.results[1].famousUpset, true, "Famous Upset flag is preserved")
assert_eq(afterAlt.gora.results[1].ruling, "victor", "victor ruling is preserved")
assert_eq(afterAlt.gora.results[2].ruling, "cowardice", "cowardice ruling is preserved")
assert_eq(afterAlt.gora.results[2].won, false, "loss flag is preserved")
assert_eq(afterAlt.gora.results[3].ruling, "void", "void ruling is preserved")
assert_eq(afterAlt.gora.results[3].won, nil, "void has no won flag")
assert_eq(afterAlt.gora.notableVictims[1], foe.id, "notable victim is preserved")
assert_eq(afterAlt.gora.headToHeads[1].opponentId, foe.id, "head-to-head opponent is preserved")
assert_eq(afterAlt.gora.headToHeads[1].fights, 3, "head-to-head fight count is preserved")
assert_eq(afterAlt.gora.rulings[1].ruling, "victor", "rulings list is preserved")
assert_eq(Store:RankForCharacter(alt.id), 4, "linked character still reads human rank")

local afterFoe = Store:GetCharacter(foe.id)
assert_eq(afterFoe.inactive, true, "character tombstone is preserved")
assert_eq(afterFoe.gora.wins, 0, "opponent Gora is unchanged unless recorded")

assert_eq(Store:RankForCharacter(unlinked.id), nil, "unlinked character still has no rank")
assert_eq(Store:GetCharacter(unlinked.id).name, beforeUnlinked.name, "unlinked name is preserved")

assert_eq(Store:GetHuman(knight.id).rankId, 3, "Knight rank is preserved")
assert_eq(Store:GetHuman(fresh.id).rankId, 1, "Fresh Beef rank is preserved")
assert_eq(Store:GetHuman(cooked.id).rankId, 2, "Cooked Beef rank is preserved")
assert_eq(Store:GetHuman(butcher.id).rankId, 5, "Butcher rank is preserved")
assert_eq(Store:GetHuman(councilH.id).rankId, 6, "Council rank is preserved")
assert_eq(Store:GetHuman(unranked.id).rankId, nil, "nil rank is preserved")
assert_eq(Store:GetHuman(knight.id).elevationAt, nil, "Knight does not gain elevationAt")
assert_eq(beforeKnight.rankId, 3, "pre-export Knight fixture stayed Knight")
assert_eq(beforeFresh.rankId, 1, "pre-export Fresh fixture stayed Fresh")
assert_eq(beforeCooked.rankId, 2, "pre-export Cooked fixture stayed Cooked")
assert_eq(beforeButcher.rankId, 5, "pre-export Butcher fixture stayed Butcher")
assert_eq(beforeCouncil.rankId, 6, "pre-export Council fixture stayed Council")
assert_eq(beforeUnranked.rankId, nil, "pre-export unranked fixture stayed nil")

local afterLog = Store:GetCeremonyLog()
assert_eq(#afterLog, 1, "ceremony log length is preserved")
assert_eq(afterLog[1].type, "Gora", "ceremony type is preserved")
assert_eq(afterLog[1].at, 6009, "ceremony timestamp is preserved")
assert_eq(afterLog[1].participantIds[1], alt.id, "ceremony participant is preserved")
assert_eq(afterLog[1].participantIds[2], foe.id, "second participant is preserved")
assert_eq(afterLog[1].narration, nil, "round-trip does not invent narration")
assert_eq(beforeLog[1].type, "Gora", "pre-export ceremony type stayed Gora")

local afterMoments = Store:GetMarkedMoments()
assert_eq(#afterMoments, 1, "marked moments length is preserved")
assert_eq(afterMoments[1].location, "Shattrath", "marked moment location is preserved")
assert_eq(afterMoments[1].at, 6010, "marked moment timestamp is preserved")
assert_eq(beforeMoments[1].location, "Shattrath", "pre-export moment stayed Shattrath")

local afterCreate = Store:CreateHuman()
assert_true(afterCreate.id >= beforeSnap.nextHumanId, "ids after Import do not reuse snapshot ids")

--------------------------------------------------------------------------------
-- Fail closed: missing / bad archive is not a wipe (Law 7)
--------------------------------------------------------------------------------
reset()
local keep = Store:CreateHuman({ name = "Keep" }, 100)
Store:SetRank(keep.id, 3, 101)
local keepId = keep.id

local function liveUntouched(label)
  local row = Store:GetHuman(keepId)
  assert_true(row ~= nil, label .. ": live human remains")
  assert_eq(row.rankId, 3, label .. ": live rank unchanged")
  assert_eq(row.name, "Keep", label .. ": live name unchanged")
end

local function refuse(blob, why)
  restoreCalls = 0
  local ok, err = Archive:Import(blob)
  assert_eq(ok, nil, why .. ": Import refuses")
  assert_true(type(err) == "string", why .. ": Import error is a string")
  assert_eq(restoreCalls, 0, why .. ": Import does not call Restore")
  liveUntouched(why)
  restoreCalls = 0
  local cok, cerr = Archive:Check(blob)
  assert_eq(cok, nil, why .. ": Check refuses")
  assert_true(type(cerr) == "string", why .. ": Check error is a string")
  assert_eq(restoreCalls, 0, why .. ": Check does not call Restore")
end

local function refuseCrafted(mutator, why)
  local crafted, craftErr = craftedExport(mutator)
  assert_eq(type(crafted), "string", why .. ": crafted export is a string")
  assert_eq(craftErr, nil, why .. ": crafted export encodes")
  refuse(crafted, why)
end

refuse(nil, "missing archive (nil)")
refuse("", "empty archive string")
refuse("   ", "whitespace-only archive")
refuse("not an archive", "foreign plaintext")
refuse('{"humans":[],"characters":[]}', "foreign JSON without a stamp")
refuse("COBARCH2\nabcdef01\n{}", "foreign stamp version")
refuse("hello from Discord", "foreign Discord paste")

local good = Archive:Export()
refuse(good:sub(1, 8), "truncated to magic only")
refuse(good:sub(1, 18), "truncated header")
refuse(good:sub(1, #good - 12), "truncated body")

local flip = good:sub(-1)
if flip == "x" then flip = "y" else flip = "x" end
refuse(good:sub(1, #good - 1) .. flip, "tampered body")

local nl = good:find("\n", 1, true)
local nl2 = good:find("\n", nl + 1, true)
local badSum = good:sub(1, nl) .. "deadbeef" .. good:sub(nl2)
refuse(badSum, "tampered checksum")

refuseCrafted(function()
  return {}
end, "empty snapshot table")

refuseCrafted(function(snap)
  snap.humans = nil
  snap.characters = nil
  return snap
end, "snapshot missing humans and characters")

refuseCrafted(function(snap)
  local row = snap.humans[1]
  snap.humans = { [10] = row }
  return snap
end, "map-shaped humans")

refuseCrafted(function(snap)
  snap.characters = { [10] = snap.characters[1] or { id = 1, name = "X" } }
  return snap
end, "map-shaped characters")

refuseCrafted(function(snap)
  snap.humans = "nope"
  return snap
end, "humans not an array")

refuseCrafted(function(snap)
  snap.characters = "nope"
  return snap
end, "characters not an array")

refuseCrafted(function(snap)
  snap.humans[1].rankId = 7
  return snap
end, "Prophet / rankId 7")

refuseCrafted(function(snap)
  snap.humans[1].rankId = 99
  return snap
end, "unknown rank id 99")

refuseCrafted(function(snap)
  snap.humans[1].rankId = "Beef Lord"
  return snap
end, "rank title string")

refuseCrafted(function(snap)
  snap.humans[1].rankId = 0
  return snap
end, "rank id 0")

refuseCrafted(function(snap)
  snap.humans[1].points = 12
  return snap
end, "human points key")

refuseCrafted(function(snap)
  snap.humans[1].standing = 4
  return snap
end, "human standing key")

refuseCrafted(function(snap)
  snap.characters[1] = snap.characters[1] or { id = 1, name = "X", gora = {} }
  snap.characters[1].points = 1
  return snap
end, "character points key")

refuseCrafted(function(snap)
  snap.points = 99
  return snap
end, "top-level points key")

refuseCrafted(function(snap)
  snap.standing = 1
  return snap
end, "top-level standing key")

refuseCrafted(function(snap)
  snap.humans[1].Grant = true
  return snap
end, "Grant-shaped key")

refuseCrafted(function(snap)
  snap.humans[1].GrantGora = 3
  return snap
end, "GrantGora key")

refuseCrafted(function(snap)
  snap.humans[1].granted = { 1 }
  return snap
end, "granted key")

refuseCrafted(function(snap)
  if snap.characters[1] and snap.characters[1].gora then
    snap.characters[1].gora.points = 4
  else
    snap.humans[1].points = 4
  end
  return snap
end, "nested points key")

refuseCrafted(function(snap)
  snap.ladder = { records = {} }
  return snap
end, "leftover ladder key")

refuseCrafted(function(snap)
  snap.scoring = { granted = {} }
  return snap
end, "leftover scoring key")

refuseCrafted(function(snap)
  snap.ui = { minimap = true }
  return snap
end, "ui key")

refuseCrafted(function(snap)
  if snap.ceremonyLog[1] then
    snap.ceremonyLog[1].narration = "the software speaks"
  else
    snap.ceremonyLog[1] = { type = "Gora", at = 1, participantIds = {}, narration = "nope" }
  end
  return snap
end, "ceremony narration")

-- Live store still the original Keep after every refusal
liveUntouched("after all refusals")
assert_eq(Store:GetHuman(keepId).history[1].kind, "created", "refusals do not rewrite history")

--------------------------------------------------------------------------------
-- Valid Import over different live data is Restore, not a missing-archive wipe
--------------------------------------------------------------------------------
local filled = blob
restoreCalls = 0
assert_eq(Archive:Import(filled), true, "valid archive may Restore over live rows")
assert_eq(restoreCalls, 1, "valid overwrite calls Restore once")
assert_eq(Store:GetHuman(human.id).rankId, 4, "valid Import brought Lord back")
assert_eq(Store:GetHuman(keepId).name, "Snap", "valid Import replaced live Keep with the archive")

--------------------------------------------------------------------------------
-- Mutating an export string does not change the live store
--------------------------------------------------------------------------------
local liveRank = Store:GetHuman(human.id).rankId
local exported = Archive:Export()
exported = exported .. " "
assert_eq(Store:GetHuman(human.id).rankId, liveRank, "mutating the export string does not change rank")

Store.Restore = realRestore

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
