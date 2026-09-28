-- Gora Core: sanction + verdict (Phase 4 Lane C). Isolated: Common + Ranks + Store + Runtime + Gora.
-- Petition / Sanction / Propose / Pope rulings. No duel, OpenRite, Grant, ELO, or auto-elevate.
-- Leftover Challenge pair-key notes stay working. No TOC / bootstrap / run.lua / Store / Runtime edits.
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
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")

local COB = ChurchOfBeef
local Gora = COB.Gora
local Store = COB.Store
local Runtime = COB.Runtime
local Ranks = COB.Ranks

local chats = 0
local addons = 0
SendChatMessage = function()
  chats = chats + 1
end
SendAddonMessage = function()
  addons = addons + 1
end

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Gora:ResetForTests(), true, "Gora ResetForTests runs under _IN_TEST")
  chats = 0
  addons = 0
end

local function present(...)
  local set = {}
  local n = select("#", ...)
  for i = 1, n do
    set[select(i, ...)] = true
  end
  return set
end

local function twoChars(fieldsA, fieldsB)
  local a = Store:CreateCharacter(fieldsA or { name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter(fieldsB or { name = "Tendermage", class = "Mage", level = 68 })
  return a, b
end

local function livePair()
  reset()
  Runtime:StartEvent()
  local a, b = twoChars()
  return a, b
end

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(Gora ~= nil, "Gora is loaded")
assert_true(Store ~= nil, "Store is loaded")
assert_true(Runtime ~= nil, "Runtime is loaded")
assert_true(Ranks ~= nil, "Ranks is loaded")
assert_true(COB.Names ~= nil, "Common name law is loaded")

if standalone then
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Snapshot, nil, "isolated suite does not load Snapshot")
end

assert_eq(type(Gora.Petition), "function", "Petition is a verb")
assert_eq(type(Gora.Dismiss), "function", "Dismiss is a verb")
assert_eq(type(Gora.GetPetitions), "function", "GetPetitions reads the pool")
assert_eq(type(Gora.Sanction), "function", "Sanction is one verb")
assert_eq(type(Gora.GetSanctioned), "function", "GetSanctioned reads the live pair")
assert_eq(type(Gora.Propose), "function", "Propose is caller-supplied")
assert_eq(type(Gora.GetProposal), "function", "GetProposal reads the proposal")
assert_eq(type(Gora.GuessKnockout), "function", "GuessKnockout is a pure helper")
assert_eq(type(Gora.ConsiderRaidHealth), "function", "ConsiderRaidHealth is a verb")
assert_eq(type(Gora.DeclareVictor), "function", "DECLARE VICTOR is a verb")
assert_eq(type(Gora.CowardiceRecorded), "function", "COWARDICE RECORDED is a verb")
assert_eq(type(Gora.Void), "function", "VOID is a verb")
assert_eq(type(Gora.FreeRuling), "function", "free ruling is a verb")
assert_eq(type(Gora.RecordFavor), "function", "RecordFavor is a verb")
assert_eq(type(Gora.PetitionFromSender), "function", "PetitionFromSender is the unsigned INPUT verb")
assert_eq(type(Gora.RecordFavorFromSender), "function", "RecordFavorFromSender is the unsigned favor verb")
assert_eq(type(Gora.GetFavor), "function", "GetFavor reads standing picks")
assert_eq(type(Gora.GetFavorSplit), "function", "GetFavorSplit reads the live split")
assert_eq(type(Gora.GetLastSanctioned), "function", "GetLastSanctioned reads the last cleared pair")
assert_eq(type(Gora.GetLastFavorSplit), "function", "GetLastFavorSplit reads the last cleared split")
assert_eq(type(Gora.Recommend), "function", "Recommend is optional context")
assert_eq(type(Gora.Snapshot), "function", "Snapshot copies the live desk")
assert_eq(type(Gora.Restore), "function", "Restore loads a desk snapshot")
assert_eq(type(Gora.Challenge), "function", "leftover Challenge remains")
assert_eq(type(Gora.GetPending), "function", "leftover GetPending remains")

assert_eq(Gora.Grant, nil, "no Grant")
assert_eq(Gora.GrantGora, nil, "no GrantGora")
assert_eq(Gora.RecordResult, nil, "no typed RecordResult")
assert_eq(Gora.OpenRite, nil, "OpenRite is not a Gora verb")
assert_eq(Gora.StartDuel, nil, "no StartDuel")
assert_eq(Gora.AcceptDuel, nil, "no AcceptDuel")
assert_eq(Gora.Announce, nil, "software does not announce")
assert_eq(Gora.Notify, nil, "software does not notify a callout")
assert_eq(Gora.Callout, nil, "software does not officialize a callout")
assert_eq(Gora.Narrate, nil, "no Narrate")
assert_eq(Gora.AutoDeclare, nil, "no AutoDeclare")
assert_eq(Gora.AutoElevate, nil, "no AutoElevate")
assert_eq(Gora.Elevate, nil, "elevation is not this lane")
assert_eq(Gora.SetRank, nil, "Gora does not SetRank")
assert_eq(Gora.ParseDuel, nil, "no duel-chat parser")
assert_eq(Gora.ParseChat, nil, "no chat parser")
assert_eq(Gora.PairingScore, nil, "no pairing score")
assert_eq(Gora.ELO, nil, "no ELO")
assert_eq(Gora.MMR, nil, "no MMR")
assert_eq(Gora.holdSeconds, nil, "no holdSeconds")
assert_eq(Gora.PETITION_TTL, nil, "no petition TTL number")
assert_eq(Gora.DISMISS_COOLDOWN, nil, "no dismiss cooldown number")
assert_eq(Gora.REPETITION_COOLDOWN, nil, "no re-petition cooldown number")
assert_eq(Gora.FamousUpsets, nil, "Famous Upsets are not computed")
assert_eq(Gora.FavorHistory, nil, "no favor history")
assert_eq(Gora.Accuracy, nil, "no favor accuracy")
assert_eq(Gora.HUD, nil, "Fight HUD is not this lane")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local keepA, keepB = twoChars()
Gora:Petition(keepA.id)
Gora:Sanction(keepA.id, keepB.id)
Gora:RecordFavor(keepA.id, keepA.id)
ChurchOfBeef._IN_TEST = false
assert_eq(Gora:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(#Gora:GetPetitions(present(keepA.id)), 1, "out-of-harness reset does not wipe petitions")
assert_eq(Gora:GetFavor()[keepA.id], keepA.id, "out-of-harness reset does not wipe favor")
ChurchOfBeef._IN_TEST = true
reset()

--------------------------------------------------------------------------------
-- Petition / Dismiss. Pool is character ids. Named opponent is stored, not announced.
--------------------------------------------------------------------------------
reset()
local quietPet, quietErr = Gora:Petition(1)
assert_eq(quietPet, nil, "Petition from QUIET is refused")
assert_true(type(quietErr) == "string", "QUIET Petition returns an error string")

Runtime:StartEvent()
local chuck, tender = twoChars()
local pet, petErr = Gora:Petition(chuck.id)
assert_true(pet ~= nil, "Petition during an event is accepted")
assert_eq(petErr, nil, "successful Petition has no error")
assert_eq(pet.characterId, chuck.id, "pool entry is a character id")
assert_eq(pet.namedOpponentId, nil, "a petition may omit a named opponent")
assert_eq(pet.name, nil, "the pool is not keyed by a name string")
assert_eq(#Gora:GetPetitions(), 0, "the pool hides petitioners the caller does not flag present-and-alive")
assert_eq(#Gora:GetPetitions(present(chuck.id)), 1, "a present-and-alive flag shows the petitioner")
assert_eq(Gora:GetPetitions(present(chuck.id))[1].characterId, chuck.id, "shown entry is the character id")

local named, namedErr = Gora:Petition(tender.id, chuck.id)
assert_true(named ~= nil, "a petition may name a desired opponent")
assert_eq(namedErr, nil, "named Petition has no error")
assert_eq(named.namedOpponentId, chuck.id, "the named opponent is stored")
assert_eq(chats, 0, "storing a named opponent does not announce")
assert_eq(addons, 0, "storing a named opponent does not SendAddonMessage")

local shown = Gora:GetPetitions(present(chuck.id, tender.id))
assert_eq(#shown, 2, "two present petitioners are in the pool")
assert_eq(shown[1].characterId < shown[2].characterId, true, "the pool is ordered by character id")

assert_eq(#Gora:GetPetitions(present(tender.id)), 1, "absent petitioners are hidden, not deleted")
assert_eq(Gora:GetPetitions(present(tender.id))[1].characterId, tender.id, "only the flagged petitioner is shown")
assert_eq(#Gora:GetPetitions(present(chuck.id, tender.id)), 2, "returning present-and-alive shows the hidden petition again")

local again = Gora:Petition(chuck.id, tender.id)
assert_eq(again.namedOpponentId, tender.id, "re-petition updates the named opponent")
assert_eq(#Gora:GetPetitions(present(chuck.id, tender.id)), 2, "re-petition deduplicates by character id")

assert_eq(Gora:Dismiss(chuck.id), true, "Dismiss is consequence-free")
assert_eq(#Gora:GetPetitions(present(chuck.id, tender.id)), 1, "Dismiss removes that character")
assert_eq(Gora:Dismiss(chuck.id), false, "Dismiss of an absent petition is a no-op")
local back, backErr = Gora:Petition(chuck.id)
assert_true(back ~= nil, "Dismiss has no re-petition cooldown number")
assert_eq(backErr, nil, "immediate re-petition is accepted")
assert_eq(#Gora:GetPetitions(present(chuck.id, tender.id)), 2, "re-petition after Dismiss returns to the pool")

local namePet, namePetErr = Gora:Petition("Chuckroast")
assert_eq(namePet, nil, "Petition refuses a name string")
assert_true(type(namePetErr) == "string", "name-string Petition returns an error string")

local selfPet, selfPetErr = Gora:Petition(chuck.id, chuck.id)
assert_eq(selfPet, nil, "a petitioner cannot name themselves")
assert_true(type(selfPetErr) == "string", "self-named opponent returns an error string")

local foePet, foePetErr = Gora:Petition(chuck.id, "Tendermage")
assert_eq(foePet, nil, "named opponent must be a character id")
assert_true(type(foePetErr) == "string", "name-string opponent returns an error string")

local stray = Store:CreateHuman()
while Store:GetCharacter(stray.id) do
  stray = Store:CreateHuman()
end
local humanPet, humanPetErr = Gora:Petition(stray.id)
assert_eq(humanPet, nil, "Petition refuses an id that is not a character")
assert_true(type(humanPetErr) == "string", "non-character Petition returns an error string")

local copyPet = Gora:GetPetitions(present(chuck.id))[1]
copyPet.namedOpponentId = 99
copyPet.characterId = 0
assert_eq(Gora:GetPetitions(present(chuck.id))[1].characterId, chuck.id, "mutating a petition copy does not change the pool")
assert_eq(Gora:GetPetitions(present(chuck.id))[1].namedOpponentId, nil, "mutating a petition copy does not rewrite the callout")

--------------------------------------------------------------------------------
-- Petitions expire when Runtime is QUIET / EndEvent. Same event survives Continue.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local p1, p2 = twoChars()
Gora:Petition(p1.id)
Gora:Petition(p2.id, p1.id)
assert_eq(#Gora:GetPetitions(present(p1.id, p2.id)), 2, "petitions live for the current event")

Runtime:OpenRite("Gora", { fighters = { p1.id, p2.id } })
assert_eq(#Gora:GetPetitions(present(p1.id, p2.id)), 2, "OpenRite does not expire petitions")
Runtime:CloseRite()
assert_eq(#Gora:GetPetitions(present(p1.id, p2.id)), 2, "CONSEQUENCE keeps the current-event pool")
Runtime:Continue()
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "Continue stays in the same event")
assert_eq(#Gora:GetPetitions(present(p1.id, p2.id)), 2, "Continue does not expire petitions")

Runtime:EndEvent()
assert_eq(Runtime:Snapshot().state, "QUIET", "EndEvent returns to QUIET")
assert_eq(#Gora:GetPetitions(present(p1.id, p2.id)), 0, "EndEvent expires the petition pool")
assert_eq(Gora:Dismiss(p1.id), false, "expired petitions are gone")

Runtime:StartEvent()
assert_eq(#Gora:GetPetitions(present(p1.id, p2.id)), 0, "a new event starts with an empty pool")
assert_true(Gora:Petition(p1.id) ~= nil, "a new event accepts a fresh petition")
assert_eq(#Gora:GetPetitions(present(p1.id)), 1, "the new petition is the current event")

--------------------------------------------------------------------------------
-- Sender-keyed unsigned petitions / favor. Petition(id) still refuses names.
--------------------------------------------------------------------------------
local function runUnsignedDesk()
  reset()
  local humans0 = #Store:Snapshot().humans
  local chars0 = #Store:Snapshot().characters
  assert_eq(humans0, 0, "empty store starts with zero humans")
  assert_eq(chars0, 0, "empty store starts with zero characters")
  Runtime:StartEvent()
  local zip, zipErr = Gora:PetitionFromSender("Zipfresh")
  assert_true(zip ~= nil, "unknown sender is accepted as an unsigned petition")
  assert_eq(zipErr, nil, "unsigned petition has no error")
  assert_eq(zip.senderKey, "zipfresh", "unsigned petition keys by Names.Key")
  assert_eq(zip.name, "Zipfresh", "unsigned petition keeps the display name")
  assert_eq(zip.characterId, nil, "unsigned petition has no store character id")
  assert_eq(zip.namedOpponentId, nil, "unsigned petition may omit an opponent")
  assert_eq(#Store:Snapshot().humans, 0, "unsigned petition creates no human")
  assert_eq(#Store:Snapshot().characters, 0, "unsigned petition creates no character")
  local unsignedShown = Gora:GetPetitions()
  assert_eq(#unsignedShown, 1, "unsigned name-key shows without a present-id flag")
  assert_eq(unsignedShown[1].senderKey, "zipfresh", "GetPetitions includes the name-key")
  assert_eq(unsignedShown[1].name, "Zipfresh", "GetPetitions paints the display name")

  local realmZip = Gora:PetitionFromSender("Zipfresh-Whitemane", 99)
  assert_true(realmZip ~= nil, "unknown named opponent does not refuse the ask")
  assert_eq(realmZip.senderKey, "zipfresh", "re-petition deduplicates by sender key")
  assert_eq(realmZip.namedOpponentId, nil, "unknown opponent id is ignored")
  assert_eq(#Gora:GetPetitions(), 1, "unknown opponent still records one unsigned row")
  assert_eq(#Store:Snapshot().humans, 0, "ignored opponent creates no human")
  assert_eq(#Store:Snapshot().characters, 0, "ignored opponent creates no character")

  local nameStill, nameStillErr = Gora:Petition("Zipfresh")
  assert_eq(nameStill, nil, "Petition still refuses a name string")
  assert_true(type(nameStillErr) == "string", "name-string Petition still returns an error")

  local knownA, knownB = twoChars()
  local knownRow = Gora:PetitionFromSender("Chuckroast", knownB.id)
  assert_eq(knownRow.characterId, knownA.id, "known sender resolves to the store id")
  assert_eq(knownRow.namedOpponentId, knownB.id, "known opponent is stored on a known sender")
  assert_eq(knownRow.name, nil, "known-id pool rows stay id-keyed")
  local missedOpp = Gora:PetitionFromSender("Tendermage", 9999)
  assert_true(missedOpp ~= nil, "known sender with unknown opponent is still recorded")
  assert_eq(missedOpp.characterId, knownB.id, "known sender still resolves")
  assert_eq(missedOpp.namedOpponentId, nil, "unknown opponent is dropped, not refused")

  Gora:Sanction(knownA.id, knownB.id)
  local humansBeforeFavor = #Store:Snapshot().humans
  local charsBeforeFavor = #Store:Snapshot().characters
  local fav, favErr = Gora:RecordFavorFromSender("Zipfresh", knownA.id)
  assert_true(fav ~= nil, "unsigned favor from an unknown sender is accepted")
  assert_eq(favErr, nil, "unsigned favor has no error")
  local picks = Gora:GetFavor()
  assert_eq(picks.zipfresh, knownA.id, "favor keys by sender name-key")
  assert_eq(picks[99], nil, "spoofed numeric id is not a favor key")
  assert_eq(picks[knownA.id], nil, "unsigned favor does not write the fighter id as the picker")
  assert_eq(#Store:Snapshot().humans, humansBeforeFavor, "unsigned favor creates no human")
  assert_eq(#Store:Snapshot().characters, charsBeforeFavor, "unsigned favor creates no character")
end
runUnsignedDesk()

--------------------------------------------------------------------------------
-- Recommend: Store context only. No odds, rating, or auto-sanction.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local r1, r2 = twoChars({ name = "Chuckroast", level = 70 }, { name = "Tendermage", level = 68 })
Gora:Petition(r1.id, r2.id)
local rec, recErr = Gora:Recommend(r1.id, r2.id)
assert_true(rec ~= nil, "Recommend returns context")
assert_eq(recErr, nil, "successful Recommend has no error")
assert_eq(rec.levelA, 70, "Recommend shows level context")
assert_eq(rec.levelB, 68, "Recommend shows the other level")
assert_eq(rec.namedOpponent, true, "Recommend surfaces a named-challenge request")
assert_eq(rec.score, nil, "Recommend has no pairing score")
assert_eq(rec.odds, nil, "Recommend has no odds copy")
assert_eq(rec.rating, nil, "Recommend has no rating")
assert_eq(rec.elo, nil, "Recommend has no ELO")
assert_eq(rec.mmr, nil, "Recommend has no MMR")
assert_eq(Gora:GetSanctioned(), nil, "Recommend does not auto-sanction")

Store:RecordGoraResult(r1.id, { opponentId = r2.id, ruling = "victor", won = true }, 500)
local rec2 = Gora:Recommend(r1.id, r2.id)
assert_true(rec2.headToHead ~= nil, "Recommend may show head-to-head from Store")
assert_eq(rec2.headToHead.opponentId, r2.id, "head-to-head is the other character")
assert_eq(rec2.headToHead.fights, 1, "head-to-head fights come from Store")
assert_eq(rec2.headToHead.score, nil, "head-to-head has no pairing score")

local recSelf, recSelfErr = Gora:Recommend(r1.id, r1.id)
assert_eq(recSelf, nil, "Recommend needs two different combatants")
assert_true(type(recSelfErr) == "string", "self Recommend returns an error string")

--------------------------------------------------------------------------------
-- Sanction: one verb. Optional one-line stipulation. No duel. No OpenRite.
--------------------------------------------------------------------------------
local a, b = livePair()
local beforeSanction = Runtime:Snapshot()
local pair, pairErr = Gora:Sanction(a.id, b.id)
assert_true(pair ~= nil, "Sanction sets the live pair")
assert_eq(pairErr, nil, "successful Sanction has no error")
assert_eq(pair.fighterA, a.id, "Sanction records fighter A")
assert_eq(pair.fighterB, b.id, "Sanction records fighter B")
assert_eq(pair.stipulation, nil, "stipulation may be omitted")
assert_eq(Gora:GetSanctioned().fighterA, a.id, "GetSanctioned returns the live pair")
assert_eq(Runtime:Snapshot().state, beforeSanction.state, "Sanction does not OpenRite")
assert_eq(Runtime:Snapshot().sequence, beforeSanction.sequence, "Sanction does not transition Runtime")
assert_eq(Runtime:Snapshot().riteType, nil, "Sanction does not invent a rite type")
assert_eq(chats, 0, "Sanction does not announce")
assert_eq(addons, 0, "Sanction does not SendAddonMessage")

local liveCopy = Gora:GetSanctioned()
liveCopy.fighterA = 0
liveCopy.stipulation = "hacked"
assert_eq(Gora:GetSanctioned().fighterA, a.id, "mutating a sanctioned copy does not change the pair")
assert_eq(Gora:GetSanctioned().stipulation, nil, "mutating a sanctioned copy does not attach a stipulation")

local sameStip = Gora:Sanction(a.id, b.id, "no potions; combatants shall be nude")
assert_eq(sameStip.stipulation, "no potions; combatants shall be nude", "one-line stipulation is remembered")
assert_eq(Gora:GetSanctioned().stipulation, "no potions; combatants shall be nude", "GetSanctioned keeps the decree")

local c = Store:CreateCharacter({ name = "Brisket" })
local third, thirdErr = Gora:Sanction(a.id, c.id)
assert_eq(third, nil, "a second live pair is refused")
assert_true(type(thirdErr) == "string", "busy Sanction returns an error string")
assert_eq(Gora:GetSanctioned().fighterB, b.id, "refused Sanction leaves the live pair")

local selfS, selfSErr = Gora:Sanction(a.id, a.id)
assert_eq(selfS, nil, "Sanction needs two different combatants")
assert_true(type(selfSErr) == "string", "self Sanction returns an error string")

reset()
Runtime:StartEvent()
local qA, qB = twoChars()
local quietBefore = Runtime:EndEvent()
assert_eq(quietBefore.state, "QUIET", "event ended")
local quietS, quietSErr = Gora:Sanction(qA.id, qB.id)
assert_eq(quietS, nil, "Sanction from QUIET is refused")
assert_true(type(quietSErr) == "string", "QUIET Sanction returns an error string")

--------------------------------------------------------------------------------
-- Propose is caller-supplied. It does not write Store and does not declare.
--------------------------------------------------------------------------------
a, b = livePair()
Gora:Sanction(a.id, b.id)
local proposed, propErr = Gora:Propose({ ruling = "victor", winnerId = a.id })
assert_true(proposed ~= nil, "Propose stores caller-supplied context")
assert_eq(propErr, nil, "successful Propose has no error")
assert_eq(Gora:GetProposal().ruling, "victor", "GetProposal returns the caller table")
assert_eq(Gora:GetProposal().winnerId, a.id, "Propose does not rewrite the winner")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "Propose does not write a Store result")
assert_eq(Store:GetCharacter(b.id).gora.losses, 0, "Propose does not record a loss")

local propCopy = Gora:GetProposal()
propCopy.winnerId = b.id
assert_eq(Gora:GetProposal().winnerId, a.id, "mutating a proposal copy does not change the stored proposal")

local raw, rawErr = Gora:Propose("caller text")
assert_eq(raw, "caller text", "Propose may store a caller string")
assert_eq(rawErr, nil, "string Propose has no error")
assert_eq(Gora:GetProposal(), "caller text", "GetProposal returns the caller string")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "a string proposal still does not write Store")

local noProp, noPropErr = Gora:Propose()
assert_eq(noProp, nil, "Propose without a caller value is refused")
assert_true(type(noPropErr) == "string", "empty Propose returns an error string")

--------------------------------------------------------------------------------
-- Raid-health draft: 1 HP loser, living partner. Does not write Store.
--------------------------------------------------------------------------------
assert_eq(Gora.GuessKnockout(1, 40), "B", "1 HP on A and living B proposes B")
assert_eq(Gora.GuessKnockout(40, 1), "A", "1 HP on B and living A proposes A")
assert_eq(Gora.GuessKnockout(0, 40), nil, "dead A is not a duel knockout")
assert_eq(Gora.GuessKnockout(1, 1), nil, "both at the floor is ambiguous")
assert_eq(Gora.GuessKnockout(20, 40), nil, "neither at the floor is not a knockout")
assert_eq(Gora.GuessKnockout(1, 0), nil, "dead partner is not a knockout")
assert_eq(Gora.GuessKnockout(nil, 40), nil, "missing reading A is not a knockout")
assert_eq(Gora.GuessKnockout(1.0, 40), "B", "integer 1.0 still counts as the floor")

local ka, kb = livePair()
assert_true(Gora:Sanction(ka.id, kb.id) ~= nil, "knockout pair is sanctioned")
local first, firstErr = Gora:ConsiderRaidHealth(1, 80)
assert_true(first ~= nil, "ConsiderRaidHealth proposes on a clean 1 HP")
assert_eq(firstErr, nil, "clean knockout has no error")
assert_eq(first.ruling, "victor", "raid-health proposal is a victor draft")
assert_eq(first.winnerId, kb.id, "the living fighter is the proposed winner")
assert_eq(first.loserId, ka.id, "the 1 HP fighter is the proposed loser")
assert_eq(first.source, "raid-health", "source is raid-health")
assert_eq(Store:GetCharacter(ka.id).gora.wins, 0, "ConsiderRaidHealth does not write wins")
assert_eq(Store:GetCharacter(ka.id).gora.losses, 0, "ConsiderRaidHealth does not write losses")
assert_eq(Gora:GetProposal().winnerId, kb.id, "GetProposal holds the draft")

local again, againErr = Gora:ConsiderRaidHealth(1, 80)
assert_eq(again, nil, "duplicate knockout does not re-Propose")
assert_eq(againErr, "already proposed", "duplicate knockout is already proposed")
assert_eq(Gora:GetProposal().winnerId, kb.id, "duplicate leaves the same draft")

local flip = Gora:ConsiderRaidHealth(80, 1)
assert_eq(flip.winnerId, ka.id, "a later opposite floor replaces the draft")
assert_eq(Gora:GetProposal().winnerId, ka.id, "GetProposal follows the later floor")

Gora:ResetForTests()
assert_eq(Gora:ConsiderRaidHealth(1, 80), nil, "no sanctioned pair refuses")

--------------------------------------------------------------------------------
-- DeclareVictor writes Store for both characters. No auto-elevate. Pair clears.
--------------------------------------------------------------------------------
a, b = livePair()
local human = Store:CreateHuman({ name = "Steve" })
Store:LinkCharacter(a.id, human.id)
Store:SetRank(human.id, 3, 2000)
Gora:Sanction(a.id, b.id, "come as you are")
Gora:Propose({ ruling = "victor", winnerId = b.id })

COB.Clock.Wall = function(now)
  if type(now) == "number" then return now end
  return 2100
end
local verdict, verdictErr = Gora:DeclareVictor(a.id)
COB.Clock.Wall = function(now)
  if type(now) == "number" then return now end
  return 0
end
assert_true(verdict ~= nil, "DeclareVictor records the Pope's ruling")
assert_eq(verdictErr, nil, "successful DeclareVictor has no error")
assert_eq(verdict.ruling, "victor", "the ruling is victor")
assert_eq(Store:GetCharacter(a.id).gora.wins, 1, "the named winner gets a win")
assert_eq(Store:GetCharacter(a.id).gora.losses, 0, "the named winner does not get a loss")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling, "victor", "winner result stores victor")
assert_eq(Store:GetCharacter(a.id).gora.results[1].won, true, "winner result is a win")
assert_eq(Store:GetCharacter(a.id).gora.results[1].opponentId, b.id, "winner result names the opponent")
assert_eq(Store:GetCharacter(a.id).gora.results[1].at, 2100, "result uses the clock")
assert_eq(Store:GetCharacter(b.id).gora.wins, 0, "the other fighter does not get a win")
assert_eq(Store:GetCharacter(b.id).gora.losses, 1, "the other fighter gets a loss")
assert_eq(Store:GetCharacter(b.id).gora.results[1].ruling, "victor", "loser result stores the same Pope ruling")
assert_eq(Store:GetCharacter(b.id).gora.results[1].won, false, "loser result is a loss")
assert_eq(Store:GetCharacter(b.id).gora.results[1].opponentId, a.id, "loser result names the winner")
assert_eq(Store:GetHuman(human.id).rankId, 3, "a Gora win does not auto-elevate")
assert_eq(Store:GetHuman(human.id).elevationAt, nil, "a Gora win does not write elevationAt")
assert_eq(Ranks.ById[3].title, "Beef Knight", "the fighter remains a Beef Knight")
assert_eq(Gora:GetSanctioned(), nil, "the live pair clears after the ruling")
assert_eq(Gora:GetProposal(), nil, "the proposal clears after the Pope rules")
assert_eq(Gora:GetLastSanctioned().fighterA, a.id, "GetLastSanctioned names fighter A after DeclareVictor")
assert_eq(Gora:GetLastSanctioned().fighterB, b.id, "GetLastSanctioned names fighter B after DeclareVictor")
assert_eq(Gora:GetLastFavorSplit().a, 0, "DeclareVictor with no picks snapshots an empty last split")
assert_eq(Gora:GetLastFavorSplit().b, 0, "DeclareVictor with no picks snapshots empty last split b")
assert_eq(Store:GetCharacter(a.id).gora.results[1].famousUpset, false, "Famous Upsets are not computed")
assert_eq(#Store:GetCeremonyLog(), 1, "DeclareVictor appends one ceremony row")
assert_eq(Store:GetCeremonyLog()[1].type, "victor", "DeclareVictor appends a victor ceremony row")
assert_eq(Store:GetCeremonyLog()[1].participantIds[1], a.id, "victor ceremony log names the winner")
assert_eq(Store:GetCeremonyLog()[1].participantIds[2], b.id, "victor ceremony log names the loser")
assert_eq(Store:GetCeremonyLog()[1].text, nil, "victor ceremony row has no text")
assert_eq(Store:GetCeremonyLog()[1].scripture, nil, "victor ceremony row has no scripture")

local twice, twiceErr = Gora:DeclareVictor(a.id)
assert_eq(twice, nil, "DeclareVictor without a live pair is refused")
assert_true(type(twiceErr) == "string", "double DeclareVictor returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.wins, 1, "a refused second ruling does not write again")
assert_eq(#Store:GetCeremonyLog(), 1, "a refused second ruling does not append again")

a, b = livePair()
Gora:Sanction(a.id, b.id)
local outsider = Store:CreateCharacter({ name = "Witness" })
local notFighter, notFighterErr = Gora:DeclareVictor(outsider.id)
assert_eq(notFighter, nil, "DeclareVictor refuses a winner who is not in the pair")
assert_true(type(notFighterErr) == "string", "outsider winner returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "refused DeclareVictor does not write Store")
assert_eq(Gora:GetSanctioned().fighterA, a.id, "refused DeclareVictor leaves the live pair")
assert_eq(#Store:GetCeremonyLog(), 0, "refused DeclareVictor does not append ceremony")

a, b = livePair()
Gora:Sanction(a.id, b.id)
local keepAppend = Store.AppendCeremony
Store.AppendCeremony = nil
local missingLog, missingLogErr = Gora:DeclareVictor(a.id)
Store.AppendCeremony = keepAppend
assert_true(missingLog ~= nil, "DeclareVictor still records when AppendCeremony is missing")
assert_eq(missingLogErr, nil, "missing AppendCeremony is not an error")
assert_eq(Store:GetCharacter(a.id).gora.wins, 1, "missing AppendCeremony still writes the bout")
assert_eq(#Store:GetCeremonyLog(), 0, "missing AppendCeremony leaves the log empty")
assert_eq(Gora:GetSanctioned(), nil, "missing AppendCeremony still clears the pair")
assert_eq(Store:GetCharacter(a.id).gora.results[1].famousUpset, false, "missing AppendCeremony does not compute Famous Upsets")

--------------------------------------------------------------------------------
-- CowardiceRecorded writes Store for both. Fleer lost. Ruling is cowardice.
--------------------------------------------------------------------------------
a, b = livePair()
Gora:Sanction(a.id, b.id)
local coward, cowardErr = Gora:CowardiceRecorded(b.id)
assert_true(coward ~= nil, "CowardiceRecorded records the Pope's ruling")
assert_eq(cowardErr, nil, "successful CowardiceRecorded has no error")
assert_eq(coward.ruling, "cowardice", "the ruling is cowardice")
assert_eq(Store:GetCharacter(b.id).gora.losses, 1, "the fleer takes a loss")
assert_eq(Store:GetCharacter(b.id).gora.results[1].ruling, "cowardice", "fleer result is cowardice")
assert_eq(Store:GetCharacter(b.id).gora.results[1].won, false, "fleer result is not a win")
assert_eq(Store:GetCharacter(a.id).gora.wins, 1, "the standing fighter takes a win")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling, "cowardice", "standing result stores the same ruling")
assert_eq(Store:GetCharacter(a.id).gora.results[1].won, true, "standing result is a win")
assert_eq(Gora:GetSanctioned(), nil, "CowardiceRecorded clears the live pair")
assert_eq(#Store:GetCeremonyLog(), 1, "CowardiceRecorded appends one ceremony row")
assert_eq(Store:GetCeremonyLog()[1].type, "cowardice", "CowardiceRecorded appends a cowardice ceremony row")
assert_eq(Store:GetCeremonyLog()[1].participantIds[1], b.id, "cowardice ceremony log names the fleer")
assert_eq(Store:GetCeremonyLog()[1].participantIds[2], a.id, "cowardice ceremony log names the other fighter")
assert_eq(Store:GetCeremonyLog()[1].text, nil, "cowardice ceremony row has no text")
assert_eq(Store:GetCeremonyLog()[1].scripture, nil, "cowardice ceremony row has no scripture")

a, b = livePair()
Gora:Sanction(a.id, b.id)
local badFlee, badFleeErr = Gora:CowardiceRecorded(Store:CreateCharacter({ name = "Crowd" }).id)
assert_eq(badFlee, nil, "CowardiceRecorded refuses a fleer who is not in the pair")
assert_true(type(badFleeErr) == "string", "outsider fleer returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.losses, 0, "refused CowardiceRecorded does not write")
assert_eq(#Store:GetCeremonyLog(), 0, "refused CowardiceRecorded does not append ceremony")

--------------------------------------------------------------------------------
-- Void writes Store for both. No win, no loss, no shame increment.
--------------------------------------------------------------------------------
a, b = livePair()
Gora:Sanction(a.id, b.id)
local voided, voidErr = Gora:Void()
assert_true(voided ~= nil, "Void records the Pope's ruling")
assert_eq(voidErr, nil, "successful Void has no error")
assert_eq(voided.ruling, "void", "the ruling is void")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "Void does not increment wins")
assert_eq(Store:GetCharacter(a.id).gora.losses, 0, "Void does not increment losses")
assert_eq(Store:GetCharacter(b.id).gora.wins, 0, "Void does not increment the other wins")
assert_eq(Store:GetCharacter(b.id).gora.losses, 0, "Void does not increment the other losses")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling, "void", "Void is stored on fighter A")
assert_eq(Store:GetCharacter(b.id).gora.results[1].ruling, "void", "Void is stored on fighter B")
assert_eq(Store:GetCharacter(a.id).gora.results[1].won, nil, "Void has no won flag")
assert_eq(Store:GetCharacter(a.id).gora.headToHeads[1].fights, 1, "Void still happened as a sanctioned fight")
assert_eq(Gora:GetSanctioned(), nil, "Void clears the live pair")
assert_eq(#Store:GetCeremonyLog(), 1, "Void appends one ceremony row")
assert_eq(Store:GetCeremonyLog()[1].type, "void", "Void appends a void ceremony row")
assert_eq(Store:GetCeremonyLog()[1].participantIds[1], a.id, "void ceremony log names fighter A")
assert_eq(Store:GetCeremonyLog()[1].participantIds[2], b.id, "void ceremony log names fighter B")
assert_eq(Store:GetCeremonyLog()[1].text, nil, "void ceremony row has no text")
assert_eq(Store:GetCeremonyLog()[1].scripture, nil, "void ceremony row has no scripture")

--------------------------------------------------------------------------------
-- FreeRuling writes Store for both. No win/loss. Text is free text, not a new enum.
--------------------------------------------------------------------------------
a, b = livePair()
Gora:Sanction(a.id, b.id)
local free, freeErr = Gora:FreeRuling("rematch at the Pope's pleasure")
assert_true(free ~= nil, "FreeRuling records the Pope's judgment")
assert_eq(freeErr, nil, "successful FreeRuling has no error")
assert_eq(free.ruling, "free", "free ruling uses the Store enum")
assert_eq(free.text, "rematch at the Pope's pleasure", "free text is remembered")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "FreeRuling does not increment wins")
assert_eq(Store:GetCharacter(a.id).gora.losses, 0, "FreeRuling does not increment losses")
assert_eq(Store:GetCharacter(b.id).gora.wins, 0, "FreeRuling does not increment the other wins")
assert_eq(Store:GetCharacter(b.id).gora.losses, 0, "FreeRuling does not increment the other losses")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling, "free", "Store stores free, not the text")
assert_eq(Store:GetCharacter(b.id).gora.results[1].ruling, "free", "both characters receive free")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling ~= "rematch at the Pope's pleasure", true,
  "the text is not a new outcome enum")
assert_eq(Store:GetCharacter(a.id).gora.results[1].won, nil, "a free ruling writes no won flag")
assert_eq(Store:GetCharacter(b.id).gora.results[1].won, nil, "the other fighter also has no won flag")
assert_eq(Store:GetCharacter(a.id).gora.results[1].text, "rematch at the Pope's pleasure",
  "the result stores the Pope's line")
assert_eq(Store:GetCharacter(b.id).gora.results[1].text, "rematch at the Pope's pleasure",
  "both sides store the Pope's line")
assert_eq(Store:GetCeremonyLog()[1].type, "free", "FreeRuling appends a free ceremony row")
assert_eq(Store:GetCeremonyLog()[1].participantIds[1], a.id, "ceremony log names fighter A")
assert_eq(Store:GetCeremonyLog()[1].participantIds[2], b.id, "ceremony log names fighter B")
assert_eq(Store:GetCeremonyLog()[1].text, "rematch at the Pope's pleasure",
  "ceremony log stores the Pope's line")
assert_eq(Gora:GetSanctioned(), nil, "FreeRuling clears the live pair")

a, b = livePair()
Gora:Sanction(a.id, b.id)
local quietFree = Gora:FreeRuling()
assert_true(quietFree ~= nil, "FreeRuling may omit text")
assert_eq(quietFree.text, nil, "omitted text is not invented")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling, "free", "omitted text still writes free")
assert_eq(Store:GetCharacter(a.id).gora.results[1].won, nil, "omitted text still writes no won flag")
assert_eq(Store:GetCharacter(a.id).gora.results[1].text, nil, "omitted text is nil on the result")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "omitted-text FreeRuling does not increment wins")
assert_eq(Store:GetCharacter(a.id).gora.losses, 0, "omitted-text FreeRuling does not increment losses")
assert_eq(Store:GetCeremonyLog()[1].text, nil, "omitted text is not stored on the ceremony row")

a, b = livePair()
Gora:Sanction(a.id, b.id)
local blankFree, blankFreeErr = Gora:FreeRuling("   ")
assert_true(blankFree ~= nil, "whitespace-only FreeRuling is accepted")
assert_eq(blankFreeErr, nil, "whitespace-only FreeRuling has no error")
assert_eq(blankFree.text, nil, "whitespace-only text is omitted")

a, b = livePair()
Gora:Sanction(a.id, b.id)
local badText, badTextErr = Gora:FreeRuling(12)
assert_eq(badText, nil, "non-string ruling text is refused")
assert_true(type(badTextErr) == "string", "non-string FreeRuling returns an error string")
assert_eq(Gora:GetSanctioned().fighterA, a.id, "refused FreeRuling leaves the live pair")
assert_eq(#Store:GetCharacter(a.id).gora.results, 0, "refused FreeRuling does not write Store")

a, b = livePair()
local noPair, noPairErr = Gora:Void()
assert_eq(noPair, nil, "Void without a sanctioned pair is refused")
assert_true(type(noPairErr) == "string", "unsanctioned Void returns an error string")
assert_eq(#Store:GetCeremonyLog(), 0, "unsanctioned Void does not append ceremony")

--------------------------------------------------------------------------------
-- Favor tally: one standing pick per member. Memory only. Cleared on Sanction / expire.
--------------------------------------------------------------------------------
a, b = livePair()
local noPick, noPickErr = Gora:RecordFavor(a.id, a.id)
assert_eq(noPick, nil, "RecordFavor without a sanctioned pair is refused")
assert_true(type(noPickErr) == "string", "unsanctioned RecordFavor returns an error string")
assert_eq(Gora:GetFavor()[a.id], nil, "a refused pick is not stored")
assert_eq(Gora:GetFavorSplit().a, 0, "split is zero with no sanctioned pair")
assert_eq(Gora:GetFavorSplit().b, 0, "split b is zero with no sanctioned pair")

Gora:Sanction(a.id, b.id)
assert_eq(Gora:GetFavorSplit().a, 0, "a new bout starts with an empty split")
assert_eq(Gora:GetFavorSplit().b, 0, "a new bout starts with an empty split b")

local fan1 = Store:CreateCharacter({ name = "FanOne" })
local fan2 = Store:CreateCharacter({ name = "FanTwo" })
local fan3 = Store:CreateCharacter({ name = "FanThree" })
local pick, pickErr = Gora:RecordFavor(fan1.id, a.id)
assert_true(pick ~= nil, "RecordFavor records a standing pick")
assert_eq(pickErr, nil, "successful RecordFavor has no error")
assert_eq(Gora:GetFavor()[fan1.id], a.id, "GetFavor maps the member to the fighter")

Gora:RecordFavor(fan1.id, b.id)
assert_eq(Gora:GetFavor()[fan1.id], b.id, "a later pick replaces the earlier pick")
assert_eq(Gora:GetFavorSplit().a, 0, "replaced pick is not counted twice")
assert_eq(Gora:GetFavorSplit().b, 1, "the replacement pick is the standing count")

Gora:RecordFavor(fan1.id, a.id)
Gora:RecordFavor(fan2.id, a.id)
Gora:RecordFavor(fan3.id, b.id)
local split = Gora:GetFavorSplit()
assert_eq(split.a, 2, "two members pick fighter A")
assert_eq(split.b, 1, "one member picks fighter B")
assert_eq(Gora:GetFavor()[fan1.id], a.id, "member one stands with A")
assert_eq(Gora:GetFavor()[fan2.id], a.id, "member two stands with A")
assert_eq(Gora:GetFavor()[fan3.id], b.id, "member three stands with B")

local favCopy = Gora:GetFavor()
favCopy[fan1.id] = 0
favCopy[999] = b.id
assert_eq(Gora:GetFavor()[fan1.id], a.id, "mutating a favor copy does not change live picks")
assert_eq(Gora:GetFavor()[999], nil, "mutating a favor copy does not add a pick")

local splitCopy = Gora:GetFavorSplit()
splitCopy.a = 99
splitCopy.b = 99
assert_eq(Gora:GetFavorSplit().a, 2, "mutating a split copy does not change the tally")
assert_eq(Gora:GetFavorSplit().b, 1, "mutating a split copy does not change the other half")

local crowd = Store:CreateCharacter({ name = "Crowd" })
local outsiderPick, outsiderPickErr = Gora:RecordFavor(fan1.id, crowd.id)
assert_eq(outsiderPick, nil, "RecordFavor refuses a pick who is not in the pair")
assert_true(type(outsiderPickErr) == "string", "outsider pick returns an error string")
assert_eq(Gora:GetFavor()[fan1.id], a.id, "a refused outsider pick does not replace the standing pick")
assert_eq(Gora:GetFavorSplit().a, 2, "a refused outsider pick does not change the split")

local badMember, badMemberErr = Gora:RecordFavor(0, a.id)
assert_eq(badMember, nil, "RecordFavor refuses a non-store member id")
assert_true(type(badMemberErr) == "string", "invalid member id returns an error string")

local badPick, badPickErr = Gora:RecordFavor(fan1.id, 0)
assert_eq(badPick, nil, "RecordFavor refuses a non-store pick id")
assert_true(type(badPickErr) == "string", "invalid pick id returns an error string")

local namePick, namePickErr = Gora:RecordFavor("FanOne", a.id)
assert_eq(namePick, nil, "RecordFavor refuses a name string")
assert_true(type(namePickErr) == "string", "name-string RecordFavor returns an error string")

local extra = Store:CreateCharacter({ name = "Brisket" })
local busyS, busySErr = Gora:Sanction(a.id, extra.id)
assert_eq(busyS, nil, "a second live pair is refused")
assert_true(type(busySErr) == "string", "busy Sanction returns an error string")
assert_eq(Gora:GetFavor()[fan1.id], a.id, "failed Sanction does not clear picks")
assert_eq(Gora:GetFavorSplit().a, 2, "failed Sanction leaves the split")

local samePair = Gora:Sanction(a.id, b.id)
assert_true(samePair ~= nil, "the same pair may be sanctioned again")
assert_eq(Gora:GetFavor()[fan1.id], nil, "successful Sanction clears prior picks")
assert_eq(Gora:GetFavor()[fan2.id], nil, "successful Sanction clears every standing pick")
assert_eq(Gora:GetFavorSplit().a, 0, "a newly sanctioned bout starts empty")
assert_eq(Gora:GetFavorSplit().b, 0, "a newly sanctioned bout starts empty on b")

Gora:RecordFavor(fan1.id, b.id)
local voidedFavor = Gora:Void()
assert_true(voidedFavor ~= nil, "Void after a pick still records")
assert_eq(Gora:GetFavor()[fan1.id], b.id, "Void leaves the favor tally")
assert_eq(Gora:GetFavorSplit().a, 0, "split is zero once the live pair is gone")
assert_eq(Gora:GetFavorSplit().b, 0, "split b is zero once the live pair is gone")

Gora:Sanction(a.id, b.id)
assert_eq(Gora:GetFavor()[fan1.id], nil, "the next Sanction clears leftover picks")

Gora:RecordFavor(fan2.id, a.id)
Gora:ResetForTests()
assert_eq(Gora:GetFavor()[fan2.id], nil, "ResetForTests clears picks")
assert_eq(Gora:GetFavorSplit().a, 0, "ResetForTests leaves an empty split")

a, b = livePair()
Gora:Sanction(a.id, b.id)
Gora:RecordFavor(a.id, a.id)
Runtime:EndEvent()
assert_eq(Gora:GetSanctioned(), nil, "EndEvent expires the live pair")
assert_eq(Gora:GetFavor()[a.id], nil, "EndEvent clears the favor tally")
assert_eq(Gora:GetFavorSplit().a, 0, "expired split is zero")

-- Production leak: verdict → EndEvent → StartEvent with no Gora call in QUIET.
-- First GetFavor of the new event must be empty. Same-event Void still leaves the pick.
a, b = livePair()
Gora:Sanction(a.id, b.id)
local nextEventFan = Store:CreateCharacter({ name = "NextEventFan" })
Gora:RecordFavor(nextEventFan.id, a.id)
local leftoverVoid = Gora:Void()
assert_true(leftoverVoid ~= nil, "Void after a pick still records across the event boundary")
assert_eq(Gora:GetFavor()[nextEventFan.id], a.id, "same-event Void still leaves the pick")
Runtime:EndEvent()
Runtime:StartEvent()
assert_eq(Gora:GetFavor()[nextEventFan.id], nil, "first GetFavor after StartEvent does not inherit last event's picks")
assert_eq(next(Gora:GetFavor()), nil, "a new event starts with an empty favor map")

--------------------------------------------------------------------------------
-- EndEvent expires an unrulied pair. No auto-void. No auto-declare.
--------------------------------------------------------------------------------
a, b = livePair()
Gora:Sanction(a.id, b.id)
Runtime:EndEvent()
assert_eq(Gora:GetSanctioned(), nil, "EndEvent expires the live pair")
assert_eq(Gora:GetLastSanctioned(), nil, "EndEvent without a ruling does not invent a last pair")
local late, lateErr = Gora:DeclareVictor(a.id)
assert_eq(late, nil, "a ruling after EndEvent is refused")
assert_true(type(lateErr) == "string", "late DeclareVictor returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "EndEvent does not auto-declare")
assert_eq(#Store:GetCharacter(a.id).gora.results, 0, "EndEvent does not auto-void")

--------------------------------------------------------------------------------
-- Last pair / last favor: snapshot on clearLive; nil on new Sanction / QUIET.
--------------------------------------------------------------------------------
local function runLastPair()
  local fa, fb = livePair()
  assert_eq(Gora:GetLastSanctioned(), nil, "missing last pair is nil")
  assert_eq(Gora:GetLastFavorSplit().a, 0, "missing last split is zero")
  assert_eq(Gora:GetLastFavorSplit().b, 0, "missing last split b is zero")
  assert_eq(Gora:GetFavorSplit().a, 0, "GetFavorSplit stays 0 without a live pair")
  assert_eq(Gora:GetFavorSplit().b, 0, "GetFavorSplit stays 0/0 without a live pair")

  Gora:Sanction(fa.id, fb.id, "come as you are")
  assert_eq(Gora:GetLastSanctioned(), nil, "a live pair is not the last pair")
  assert_eq(Gora:GetSanctioned().fighterA, fa.id, "GetSanctioned still reads the live pair")
  Gora:RecordFavor(fa.id, fa.id)
  Gora:RecordFavor(fb.id, fa.id)
  local preSplit = Gora:GetFavorSplit()
  assert_eq(preSplit.a, 2, "pre-ruling split a is two")
  assert_eq(preSplit.b, 0, "pre-ruling split b is zero")

  local lastVerdict = Gora:DeclareVictor(fa.id)
  assert_true(lastVerdict ~= nil, "DeclareVictor still records for the last-pair snapshot")
  assert_eq(Gora:GetSanctioned(), nil, "GetSanctioned stays nil after the ruling")
  assert_eq(Gora:GetLastSanctioned().fighterA, fa.id, "GetLastSanctioned names fighter A")
  assert_eq(Gora:GetLastSanctioned().fighterB, fb.id, "GetLastSanctioned names fighter B")
  assert_eq(Gora:GetLastSanctioned().stipulation, nil, "last pair is ids only")
  assert_eq(Gora:GetLastFavorSplit().a, preSplit.a, "GetLastFavorSplit equals the pre-ruling split")
  assert_eq(Gora:GetLastFavorSplit().b, preSplit.b, "GetLastFavorSplit b equals the pre-ruling split")
  assert_eq(Gora:GetFavorSplit().a, 0, "GetFavorSplit stays 0/0 after the ruling")
  assert_eq(Gora:GetFavorSplit().b, 0, "GetFavorSplit b stays 0 after the ruling")
  assert_eq(Store:GetCharacter(fa.id).gora.results[1].famousUpset, false,
    "Famous Upsets are not computed on the last-pair path")

  local lastCopy = Gora:GetLastSanctioned()
  lastCopy.fighterA = 0
  lastCopy.fighterB = 0
  assert_eq(Gora:GetLastSanctioned().fighterA, fa.id, "mutating a last-pair copy does not change the snapshot")
  local lastSplitCopy = Gora:GetLastFavorSplit()
  lastSplitCopy.a = 99
  lastSplitCopy.b = 99
  assert_eq(Gora:GetLastFavorSplit().a, 2, "mutating a last-split copy does not change the snapshot")
  assert_eq(Gora:GetLastFavorSplit().b, 0, "mutating a last-split copy does not change the other half")

  local nextPair = Gora:Sanction(fa.id, fb.id)
  assert_true(nextPair ~= nil, "a new Sanction is accepted after the ruling")
  assert_eq(Gora:GetLastSanctioned(), nil, "new Sanction nils the last pair")
  assert_eq(Gora:GetLastFavorSplit().a, 0, "new Sanction nils the last split")
  assert_eq(Gora:GetLastFavorSplit().b, 0, "new Sanction nils the last split b")
  assert_eq(Gora:GetSanctioned().fighterA, fa.id, "the new live pair is GetSanctioned")

  Gora:RecordFavor(fa.id, fb.id)
  Gora:CowardiceRecorded(fa.id)
  assert_eq(Gora:GetSanctioned(), nil, "CowardiceRecorded clears the live pair")
  assert_eq(Gora:GetLastSanctioned().fighterA, fa.id, "CowardiceRecorded snapshots fighter A")
  assert_eq(Gora:GetLastSanctioned().fighterB, fb.id, "CowardiceRecorded snapshots fighter B")
  assert_eq(Gora:GetLastFavorSplit().a, 0, "CowardiceRecorded snapshots the then-current split a")
  assert_eq(Gora:GetLastFavorSplit().b, 1, "CowardiceRecorded snapshots the then-current split")

  Gora:Sanction(fa.id, fb.id)
  assert_eq(Gora:GetLastSanctioned(), nil, "Sanction after cowardice nils last")
  Gora:Void()
  assert_eq(Gora:GetLastSanctioned().fighterA, fa.id, "Void snapshots the pair")
  assert_eq(Gora:GetLastFavorSplit().a, 0, "Void with no picks snapshots 0/0")
  assert_eq(Gora:GetLastFavorSplit().b, 0, "Void with no picks snapshots empty last split b")

  Gora:Sanction(fa.id, fb.id)
  Gora:RecordFavor(fb.id, fa.id)
  Gora:FreeRuling("rematch")
  assert_eq(Gora:GetLastSanctioned().fighterB, fb.id, "FreeRuling snapshots the pair")
  assert_eq(Gora:GetLastFavorSplit().a, 1, "FreeRuling snapshots the then-current split")
  assert_eq(Gora:GetLastFavorSplit().b, 0, "FreeRuling snapshots empty last split b")

  Runtime:EndEvent()
  assert_eq(Gora:GetLastSanctioned(), nil, "EndEvent / QUIET expire nils last")
  assert_eq(Gora:GetLastFavorSplit().a, 0, "EndEvent / QUIET expire nils last split")
  assert_eq(Gora:GetLastFavorSplit().b, 0, "EndEvent / QUIET expire nils last split b")

  fa, fb = livePair()
  Gora:Sanction(fa.id, fb.id)
  Gora:RecordFavor(fa.id, fa.id)
  Gora:DeclareVictor(fb.id)
  assert_eq(Gora:GetLastSanctioned().fighterA, fa.id, "last pair keeps sanctioned A/B order")
  assert_eq(Gora:GetLastSanctioned().fighterB, fb.id, "last pair keeps sanctioned B when B wins")
  assert_eq(Gora:GetLastFavorSplit().a, 1, "last split survives until ResetForTests")
  Gora:ResetForTests()
  assert_eq(Gora:GetLastSanctioned(), nil, "ResetForTests wipes last pair")
  assert_eq(Gora:GetLastFavorSplit().a, 0, "ResetForTests wipes last split")
  assert_eq(Gora:GetLastFavorSplit().b, 0, "ResetForTests wipes last split b")

  -- Production leak: ruling → EndEvent → StartEvent with no GetLast in QUIET.
  -- First GetLast of the new event must be empty. Same-event last still holds.
  fa, fb = livePair()
  Gora:Sanction(fa.id, fb.id)
  Gora:RecordFavor(fa.id, fa.id)
  Gora:DeclareVictor(fa.id)
  assert_eq(Gora:GetSanctioned(), nil, "GetSanctioned stays nil after the ruling")
  assert_eq(Gora:GetLastSanctioned().fighterA, fa.id, "same-event last pair still holds")
  assert_eq(Gora:GetLastFavorSplit().a, 1, "same-event last split still holds")
  assert_eq(Store:GetCharacter(fa.id).gora.results[1].famousUpset, false,
    "Famous Upsets are not computed across the event boundary")
  Runtime:EndEvent()
  Runtime:StartEvent()
  assert_eq(Gora:GetLastSanctioned(), nil, "first GetLast after StartEvent does not inherit last event's pair")
  assert_eq(Gora:GetLastFavorSplit().a, 0, "first GetLastFavorSplit after StartEvent is empty")
  assert_eq(Gora:GetLastFavorSplit().b, 0, "first GetLastFavorSplit after StartEvent is empty on b")
  assert_eq(Gora:GetFavorSplit().a, 0, "GetFavorSplit stays 0/0 without a live pair on the new event")
  assert_eq(Gora:GetFavorSplit().b, 0, "GetFavorSplit b stays 0 without a live pair on the new event")
end
runLastPair()

--------------------------------------------------------------------------------
-- Leftover Challenge pair-key notes still work and stay off the product loop.
--------------------------------------------------------------------------------
reset()
local challenge = Gora:Challenge("Steakina", "Beefina", 100)
assert_true(challenge ~= nil, "leftover Challenge still opens")
assert_eq(challenge.challenger, "Beefina", "leftover challenger is recorded")
assert_eq(challenge.target, "Steakina", "leftover target is recorded")
assert_eq(Gora:IsChallenged("Beefina", "Steakina"), true, "leftover pair is challenged")
assert_eq(Gora:IsChallenged("Steakina", "Beefina"), true, "leftover direction does not matter")
assert_eq(#Gora:GetPending(100), 1, "leftover GetPending still lists the note")
assert_eq(#Gora:GetPetitions(present(1)), 0, "Challenge does not enter the petition pool")
assert_eq(Gora:GetSanctioned(), nil, "Challenge is not a Sanction")
assert_eq(Gora:Cancel("Steakina", "Beefina"), true, "leftover Cancel still clears the pair")
assert_eq(Gora:IsChallenged("Beefina", "Steakina"), false, "leftover cancel worked")

Gora:Challenge("Steakina", "Beefina", 300)
assert_eq(#Gora:GetPending(300), 1, "leftover challenge is live inside its window")
assert_eq(#Gora:GetPending(300 + 3600), 0, "leftover stale challenge still expires")

--------------------------------------------------------------------------------
-- Snapshot / Restore. Empty {} is not a snapshot. Restore after event.
--------------------------------------------------------------------------------
local function petitionBySender(rows, key)
  if type(rows) ~= "table" then return nil end
  if type(rows[key]) == "table" then return rows[key] end
  for _, row in pairs(rows) do
    if type(row) == "table" and row.senderKey == key then return row end
  end
  return nil
end

reset()
assert_eq(Gora:Snapshot().eventId, nil, "empty desk Snapshot has no eventId")
assert_eq(Gora:Restore({}), nil, "empty {} is not a snapshot")
assert_eq(Gora:Restore(nil), nil, "missing Restore is not a snapshot")

local snapA, snapB = livePair()
Gora:PetitionFromSender("Zipfresh")
Gora:Sanction(snapA.id, snapB.id, "come as you are")
Gora:RecordFavor(snapA.id, snapA.id)
Gora:RecordFavorFromSender("Zipfresh", snapB.id)
assert_true(Gora:ConsiderRaidHealth(1, 80) ~= nil, "snapshot fixture has a raid-health draft")
local liveEvent = Runtime:Snapshot()
local desk = Gora:Snapshot()
assert_eq(desk.proposal.winnerId, snapB.id, "Snapshot copies the proposed winner")
assert_eq(desk.proposal.source, "raid-health", "Snapshot copies the proposal source")
local liveCopy = Gora:GetProposal()
liveCopy.winnerId = 999
assert_eq(Gora:GetProposal().winnerId, snapB.id, "mutating a proposal copy does not change live")
assert_eq(desk.proposal.winnerId, snapB.id, "the snapshot proposal stays the live winner")
assert_eq(desk.eventId, liveEvent.eventId, "Snapshot carries the live eventId")
assert_eq(desk.sanctioned.fighterA, snapA.id, "Snapshot keeps fighter A")
assert_eq(desk.sanctioned.fighterB, snapB.id, "Snapshot keeps fighter B")
assert_eq(desk.sanctioned.stipulation, "come as you are", "Snapshot keeps the stipulation")
assert_eq(desk.sanctioned.eventId, liveEvent.eventId, "Snapshot tags the pair to the event")
local unsigned = petitionBySender(desk.petitions, "zipfresh")
assert_true(unsigned ~= nil, "Snapshot keeps the unsigned name-key petition")
assert_eq(unsigned.senderKey, "zipfresh", "unsigned petition key survives Snapshot")
assert_eq(unsigned.name, "Zipfresh", "unsigned display name survives Snapshot")
assert_eq(unsigned.characterId, nil, "unsigned Snapshot row has no store id")
assert_eq(desk.favorPicks[snapA.id], snapA.id, "Snapshot keeps standing favor")
assert_eq(desk.favorPicks.zipfresh, snapB.id, "Snapshot keeps sender-key favor")
assert_eq(desk.lastSanctioned, nil, "live pair Snapshot has no last pair")

local livePairSnap = Gora:GetSanctioned()
assert_eq(Gora:Restore({}), nil, "empty {} does not replace live memory")
assert_eq(Gora:GetSanctioned().fighterA, livePairSnap.fighterA, "empty Restore keeps fighter A")
assert_eq(Gora:GetSanctioned().fighterB, livePairSnap.fighterB, "empty Restore keeps fighter B")
assert_eq(Gora:Restore({ petitions = {}, favorPicks = {} }), nil, "eventId-less table is not a snapshot")
assert_eq(Gora:GetSanctioned().fighterA, snapA.id, "stateless Restore keeps the live pair")

Gora:ResetForTests()
Runtime:ResetForTests()
assert_eq(Gora:GetSanctioned(), nil, "reset cleared the live pair")
assert_eq(Gora:Restore(desk), true, "gora before event still Restores into memory")
assert_eq(Gora:GetSanctioned(), nil, "Restore-before-event expires on the next read")
assert_eq(Runtime:Restore(liveEvent), true, "event Restore lands first")
assert_eq(Gora:Restore(desk), true, "gora Restore after event succeeds")
local resumedPair = Gora:GetSanctioned()
assert_eq(resumedPair.fighterA, snapA.id, "Restore after event keeps fighter A")
assert_eq(resumedPair.fighterB, snapB.id, "Restore after event keeps fighter B")
assert_eq(resumedPair.stipulation, "come as you are", "Restore after event keeps the stipulation")
local resumedUnsigned = Gora:GetPetitions()
local foundUnsigned = false
for i = 1, #resumedUnsigned do
  if resumedUnsigned[i].senderKey == "zipfresh" then foundUnsigned = true end
end
assert_eq(foundUnsigned, true, "Restore keeps the unsigned name-key petition")
assert_eq(Gora:GetFavor()[snapA.id], snapA.id, "Restore keeps standing favor")
assert_eq(Gora:GetFavor().zipfresh, snapB.id, "Restore keeps sender-key favor")
assert_eq(Gora:GetProposal().winnerId, snapB.id, "Reload keeps the proposed winner")
assert_eq(Gora:GetProposal().source, "raid-health", "Reload keeps raid-health source")
local stripped = Gora:Snapshot()
stripped.proposal = nil
assert_eq(Gora:Restore(stripped), true, "Restore without a proposal key succeeds")
assert_eq(Gora:GetProposal(), nil, "Restore without a proposal key leaves none")
assert_eq(Gora:Restore(desk), true, "re-Restore brings the draft back")
assert_eq(Gora:GetProposal().winnerId, snapB.id, "re-Restore keeps the proposed winner")
local ruled, ruledErr = Gora:DeclareVictor(snapA.id)
assert_true(ruled ~= nil, "DeclareVictor after Restore does not refuse no sanctioned gora")
assert_eq(ruledErr, nil, "DeclareVictor after Restore has no error")
assert_eq(ruled.ruling, "victor", "DeclareVictor after Restore records the ruling")
assert_eq(Gora:GetSanctioned(), nil, "DeclareVictor after Restore clears the live pair")
assert_eq(Gora:GetLastSanctioned().fighterA, snapA.id, "ruling after Restore leaves last pair")

local afterRuling = Gora:Snapshot()
assert_eq(afterRuling.eventId, liveEvent.eventId, "post-ruling Snapshot still has eventId")
assert_eq(afterRuling.sanctioned, nil, "post-ruling Snapshot has no live pair")
assert_eq(afterRuling.lastSanctioned.fighterA, snapA.id, "post-ruling Snapshot keeps last pair")
assert_eq(afterRuling.lastSanctioned.fighterB, snapB.id, "post-ruling Snapshot keeps last pair B")

--------------------------------------------------------------------------------
-- ResetForTests must not call DB:Save.
--------------------------------------------------------------------------------
reset()
local saveCalls = 0
local savedDB = COB.DB
COB.DB = {
  Save = function()
    saveCalls = saveCalls + 1
    return true
  end,
}
assert_eq(Gora:ResetForTests(), true, "ResetForTests still clears under _IN_TEST")
assert_eq(saveCalls, 0, "ResetForTests does not call DB:Save")
assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests still clears")
assert_eq(saveCalls, 0, "Runtime ResetForTests does not call DB:Save")
assert_eq(Store:ResetForTests(), true, "Store ResetForTests still clears")
assert_eq(saveCalls, 0, "Store ResetForTests does not call DB:Save")
COB.DB = savedDB

--------------------------------------------------------------------------------
-- Getters / verbs do not CreateFrame or write ChurchOfBeefDB.
--------------------------------------------------------------------------------
reset()
ChurchOfBeefDB = { sentinel = 1 }
local framed = 0
CreateFrame = function()
  framed = framed + 1
end
Runtime:StartEvent()
local f1, f2 = twoChars()
Gora:Petition(f1.id, f2.id)
Gora:Recommend(f1.id, f2.id)
Gora:Sanction(f1.id, f2.id, "come as you are")
Gora:RecordFavor(f1.id, f1.id)
Gora:GetFavor()
Gora:GetFavorSplit()
Gora:GetLastSanctioned()
Gora:GetLastFavorSplit()
Gora:Propose({ ruling = "void" })
Gora:Void()
Gora:GetLastSanctioned()
Gora:GetLastFavorSplit()
assert_eq(framed, 0, "Gora verbs never CreateFrame")
assert_eq(ChurchOfBeefDB.sentinel, 1, "Gora verbs do not write ChurchOfBeefDB")
assert_eq(chats, 0, "Gora verbs never SendChatMessage")
assert_eq(addons, 0, "Gora verbs never SendAddonMessage")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
