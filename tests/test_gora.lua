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
assert_eq(type(Gora.DeclareVictor), "function", "DECLARE VICTOR is a verb")
assert_eq(type(Gora.CowardiceRecorded), "function", "COWARDICE RECORDED is a verb")
assert_eq(type(Gora.Void), "function", "VOID is a verb")
assert_eq(type(Gora.FreeRuling), "function", "free ruling is a verb")
assert_eq(type(Gora.Recommend), "function", "Recommend is optional context")
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
assert_eq(Gora.Favor, nil, "favor is not this lane")
assert_eq(Gora.HUD, nil, "Fight HUD is not this lane")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local keepA, keepB = twoChars()
Gora:Petition(keepA.id)
ChurchOfBeef._IN_TEST = false
assert_eq(Gora:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(#Gora:GetPetitions(present(keepA.id)), 1, "out-of-harness reset does not wipe petitions")
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
assert_eq(Store:GetCharacter(a.id).gora.results[1].famousUpset, false, "Famous Upsets are not computed")

local twice, twiceErr = Gora:DeclareVictor(a.id)
assert_eq(twice, nil, "DeclareVictor without a live pair is refused")
assert_true(type(twiceErr) == "string", "double DeclareVictor returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.wins, 1, "a refused second ruling does not write again")

a, b = livePair()
Gora:Sanction(a.id, b.id)
local outsider = Store:CreateCharacter({ name = "Witness" })
local notFighter, notFighterErr = Gora:DeclareVictor(outsider.id)
assert_eq(notFighter, nil, "DeclareVictor refuses a winner who is not in the pair")
assert_true(type(notFighterErr) == "string", "outsider winner returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "refused DeclareVictor does not write Store")
assert_eq(Gora:GetSanctioned().fighterA, a.id, "refused DeclareVictor leaves the live pair")

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

a, b = livePair()
Gora:Sanction(a.id, b.id)
local badFlee, badFleeErr = Gora:CowardiceRecorded(Store:CreateCharacter({ name = "Crowd" }).id)
assert_eq(badFlee, nil, "CowardiceRecorded refuses a fleer who is not in the pair")
assert_true(type(badFleeErr) == "string", "outsider fleer returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.losses, 0, "refused CowardiceRecorded does not write")

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

--------------------------------------------------------------------------------
-- FreeRuling writes Store for both. Text is free text, not a new outcome enum.
--------------------------------------------------------------------------------
a, b = livePair()
Gora:Sanction(a.id, b.id)
local free, freeErr = Gora:FreeRuling("rematch at the Pope's pleasure")
assert_true(free ~= nil, "FreeRuling records the Pope's judgment")
assert_eq(freeErr, nil, "successful FreeRuling has no error")
assert_eq(free.ruling, "free", "free ruling uses the Store enum")
assert_eq(free.text, "rematch at the Pope's pleasure", "free text is remembered")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling, "free", "Store stores free, not the text")
assert_eq(Store:GetCharacter(b.id).gora.results[1].ruling, "free", "both characters receive free")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling ~= "rematch at the Pope's pleasure", true,
  "the text is not a new outcome enum")
assert_eq(Store:GetCharacter(a.id).gora.results[1].won, false, "a free ruling without a named victor is not a win")
assert_eq(Store:GetCharacter(b.id).gora.results[1].won, false, "the other fighter is also not declared victor")
assert_eq(Gora:GetSanctioned(), nil, "FreeRuling clears the live pair")

a, b = livePair()
Gora:Sanction(a.id, b.id)
local quietFree = Gora:FreeRuling()
assert_true(quietFree ~= nil, "FreeRuling may omit text")
assert_eq(quietFree.text, nil, "omitted text is not invented")
assert_eq(Store:GetCharacter(a.id).gora.results[1].ruling, "free", "omitted text still writes free")

a, b = livePair()
local noPair, noPairErr = Gora:Void()
assert_eq(noPair, nil, "Void without a sanctioned pair is refused")
assert_true(type(noPairErr) == "string", "unsanctioned Void returns an error string")

--------------------------------------------------------------------------------
-- EndEvent expires an unrulied pair. No auto-void. No auto-declare.
--------------------------------------------------------------------------------
a, b = livePair()
Gora:Sanction(a.id, b.id)
Runtime:EndEvent()
assert_eq(Gora:GetSanctioned(), nil, "EndEvent expires the live pair")
local late, lateErr = Gora:DeclareVictor(a.id)
assert_eq(late, nil, "a ruling after EndEvent is refused")
assert_true(type(lateErr) == "string", "late DeclareVictor returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.wins, 0, "EndEvent does not auto-declare")
assert_eq(#Store:GetCharacter(a.id).gora.results, 0, "EndEvent does not auto-void")

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
Gora:Propose({ ruling = "void" })
Gora:Void()
assert_eq(framed, 0, "Gora verbs never CreateFrame")
assert_eq(ChurchOfBeefDB.sentinel, 1, "Gora verbs do not write ChurchOfBeefDB")
assert_eq(chats, 0, "Gora verbs never SendChatMessage")
assert_eq(addons, 0, "Gora verbs never SendAddonMessage")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
