-- Pope store schema (Phase 2 Lane A). Isolated: Common + Ranks + Store.
-- No Scoring/Ladder/DB/UI/Net. No Grant, standing, points, or Prophet rank.
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

local COB = ChurchOfBeef
local Store = COB.Store
local Ranks = COB.Ranks

local function reset()
  assert_eq(Store:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
end

local function isInt(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

--------------------------------------------------------------------------------
-- Isolated surface: Common + Ranks + Store. Not Gora, UI, Net, Archive.
--------------------------------------------------------------------------------
assert_true(Store ~= nil, "isolated suite loads Store")
assert_true(Ranks ~= nil, "isolated suite loads Ranks")
assert_true(COB.Names ~= nil, "Common name law is loaded")
if standalone then
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.UI, nil, "isolated suite does not load UI")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load Records Book")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Popes, nil, "isolated suite does not load a Pope list")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
end

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
ChurchOfBeef._IN_TEST = false
local hKeep = Store:CreateHuman()
assert_true(hKeep ~= nil, "a human exists before the out-of-harness reset")
assert_eq(Store:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_true(Store:GetHuman(hKeep.id) ~= nil, "out-of-harness reset does not wipe the store")
ChurchOfBeef._IN_TEST = true
reset()

--------------------------------------------------------------------------------
-- Create/get human: store-local monotonic integer ids, never Names.Key
--------------------------------------------------------------------------------
local steve = Store:CreateHuman({ name = "Steve" }, 1000)
assert_true(steve ~= nil, "CreateHuman returns a row")
assert_true(isInt(steve.id), "human id is a positive integer")
assert_eq(steve.id, 1, "first human id is 1")
assert_eq(steve.name, "Steve", "optional human label is stored")
assert_eq(steve.rankId, nil, "new human has no rank until the Pope sets one")
assert_eq(steve.council, false, "new human is not Council")
assert_eq(type(steve.honorifics), "table", "honorifics list exists")
assert_eq(#steve.honorifics, 0, "honorifics start empty")
assert_eq(steve.inactive, false, "new human is active")
assert_eq(steve.elevationAt, nil, "new human has no elevation timestamp")
assert_eq(type(steve.characterIds), "table", "linked character id list exists")
assert_eq(#steve.characterIds, 0, "new human has no linked characters")
assert_eq(type(steve.history), "table", "membership history exists")
assert_eq(#steve.history, 1, "create writes one membership event")
assert_eq(steve.history[1].kind, "created", "first history kind is created")
assert_eq(steve.history[1].at, 1000, "create uses the injectable clock")
assert_eq(steve.gora, nil, "human row does not own a Gora record")

local dave = Store:CreateHuman(nil, 1001)
assert_eq(dave.id, 2, "human ids are monotonic")
assert_true(dave.id ~= steve.id, "each human gets its own id")
assert_eq(Store:GetHuman(COB.Names.Key("Steve")), nil, "Names.Key is not a human id")
assert_eq(Store:GetHuman("Steve"), nil, "a name string is not a human id")
assert_eq(Store:GetHuman("steve"), nil, "a lowercased name is not a human id")

local gotSteve = Store:GetHuman(steve.id)
assert_eq(gotSteve.id, steve.id, "GetHuman finds the row by integer id")
assert_eq(gotSteve.name, "Steve", "GetHuman returns the label")

--------------------------------------------------------------------------------
-- Create/get character: separate id sequence; name is a field, not the key
--------------------------------------------------------------------------------
local chuck = Store:CreateCharacter({
  name = "Chuckroast-Whitemane",
  class = "Warrior",
  level = 70,
  professions = { "Blacksmithing" },
}, 1100)
assert_true(chuck ~= nil, "CreateCharacter returns a row")
assert_true(isInt(chuck.id), "character id is a positive integer")
assert_eq(chuck.id, 1, "first character id is 1 (separate sequence)")
assert_eq(chuck.name, "Chuckroast", "stored name is the display spelling, not a key")
assert_eq(chuck.class, "Warrior", "class is stored on the character")
assert_eq(chuck.level, 70, "level is stored on the character")
assert_eq(#chuck.professions, 1, "professions may be supplied")
assert_eq(chuck.professions[1], "Blacksmithing", "profession text is stored")
assert_eq(chuck.humanId, nil, "new character is unlinked")
assert_eq(chuck.inactive, false, "new character is active")
assert_eq(chuck.rankId, nil, "character row has no Church rank field")
assert_eq(type(chuck.gora), "table", "character owns a Gora record")
assert_eq(chuck.gora.wins, 0, "Gora wins start at 0")
assert_eq(chuck.gora.losses, 0, "Gora losses start at 0")
assert_eq(chuck.gora.streak, 0, "fight-record streak starts at 0")
assert_eq(type(chuck.gora.headToHeads), "table", "head-to-heads list exists")
assert_eq(#chuck.gora.headToHeads, 0, "head-to-heads start empty")
assert_eq(type(chuck.gora.notableVictims), "table", "notable victims list exists")
assert_eq(#chuck.gora.notableVictims, 0, "notable victims start empty")
assert_eq(type(chuck.gora.rulings), "table", "rulings-received list exists")
assert_eq(#chuck.gora.rulings, 0, "rulings start empty")
assert_eq(type(chuck.gora.results), "table", "sanctioned result log exists")
assert_eq(#chuck.gora.results, 0, "result log starts empty")
assert_eq(chuck.gora.defenses, nil, "defenses are not a stored counter")
assert_eq(chuck.gora.defenseCount, nil, "no defenseCount field")

local tender = Store:CreateCharacter({ name = "Tendermage" }, 1101)
assert_eq(tender.id, 2, "character ids are monotonic")
assert_eq(type(tender.professions), "table", "professions default to a table")
assert_eq(#tender.professions, 0, "professions may be empty")
assert_eq(tender.class, nil, "class may be empty")
assert_eq(tender.level, nil, "level may be empty")

local chuck2 = Store:CreateCharacter({ name = "Chuckroast" }, 1102)
assert_true(chuck2.id ~= chuck.id, "name reuse gets a new character id")
assert_eq(chuck2.name, "Chuckroast", "reused spelling is still just a field")
assert_eq(Store:GetCharacter(COB.Names.Key("Chuckroast")), nil, "Names.Key is not a character id")
assert_eq(Store:GetCharacter("Chuckroast"), nil, "a name string is not a character id")
assert_eq(Store:GetCharacter("chuckroast"), nil, "a lowercased name is not a character id")
assert_eq(Store:GetCharacter(chuck.id).id, chuck.id, "GetCharacter finds the row by integer id")

local noName, noNameErr = Store:CreateCharacter({ name = "" })
assert_eq(noName, nil, "empty character name is refused")
assert_true(type(noNameErr) == "string", "empty name returns an error string")

local noFields, noFieldsErr = Store:CreateCharacter()
assert_eq(noFields, nil, "CreateCharacter without fields is refused")
assert_true(type(noFieldsErr) == "string", "missing fields returns an error string")

--------------------------------------------------------------------------------
-- Getters hand out copies
--------------------------------------------------------------------------------
local liveHuman = Store:GetHuman(steve.id)
liveHuman.rankId = 4
liveHuman.honorifics[1] = "hacked"
liveHuman.history[1].kind = "wiped"
liveHuman.characterIds[1] = 99
assert_eq(Store:GetHuman(steve.id).rankId, nil, "mutating a human copy does not set rank")
assert_eq(#Store:GetHuman(steve.id).honorifics, 0, "mutating a human copy does not add honorifics")
assert_eq(Store:GetHuman(steve.id).history[1].kind, "created", "mutating a human copy does not rewrite history")
assert_eq(#Store:GetHuman(steve.id).characterIds, 0, "mutating a human copy does not link characters")

local liveChar = Store:GetCharacter(chuck.id)
liveChar.rankId = 1
liveChar.gora.wins = 99
liveChar.gora.defenses = 7
liveChar.gora.results[1] = { ruling = "fake" }
liveChar.humanId = steve.id
assert_eq(Store:GetCharacter(chuck.id).rankId, nil, "mutating a character copy does not invent rank")
assert_eq(Store:GetCharacter(chuck.id).gora.wins, 0, "mutating a character copy does not change wins")
assert_eq(Store:GetCharacter(chuck.id).gora.defenses, nil, "mutating a character copy does not add defenses")
assert_eq(#Store:GetCharacter(chuck.id).gora.results, 0, "mutating a character copy does not append results")
assert_eq(Store:GetCharacter(chuck.id).humanId, nil, "mutating a character copy does not link")

--------------------------------------------------------------------------------
-- Unlinked characters have no Church rank; rank lives on the human
--------------------------------------------------------------------------------
assert_eq(Store:RankForCharacter(chuck.id), nil, "unlinked character has no Church rank")
assert_eq(Store:RankForCharacter(tender.id), nil, "second unlinked character has no rank")
assert_eq(Store:GetCharacter(chuck.id).rankId, nil, "unlinked alt is not defaulted to Fresh Beef")

local linked, linkErr = Store:LinkCharacter(chuck.id, steve.id, 1200)
assert_true(linked ~= nil, "LinkCharacter binds a character to a human")
assert_eq(linkErr, nil, "successful link has no error")
assert_eq(linked.humanId, steve.id, "character stores the human id")
assert_eq(Store:GetHuman(steve.id).characterIds[1], chuck.id, "human lists the linked character id")
assert_eq(Store:GetCharacter(chuck.id).rankId, nil, "linked character row still has no rank field")
assert_eq(Store:RankForCharacter(chuck.id), nil, "linked character with unset human rank has no rank")

local relink = Store:LinkCharacter(chuck.id, steve.id, 1201)
assert_true(relink ~= nil, "re-link to the same human is confirmation, not a new identity")
assert_eq(#Store:GetHuman(steve.id).characterIds, 1, "same-human re-link does not duplicate the character id")

local otherBind, otherErr = Store:LinkCharacter(chuck.id, dave.id, 1202)
assert_eq(otherBind, nil, "already-bound character cannot move to a different human")
assert_true(type(otherErr) == "string", "cross-human rebind returns an error string")
assert_eq(Store:GetCharacter(chuck.id).humanId, steve.id, "refused rebind leaves the original human")

local nameLink, nameLinkErr = Store:LinkCharacter("chuckroast", steve.id)
assert_eq(nameLink, nil, "LinkCharacter refuses a name-string character id")
assert_true(type(nameLinkErr) == "string", "name-string link returns an error string")

--------------------------------------------------------------------------------
-- SetRank: Ranks.ById only; refuse Prophet / unknown; elevation on Lord
--------------------------------------------------------------------------------
local ranked = Store:SetRank(steve.id, 1, 1300)
assert_eq(ranked.rankId, 1, "Fresh Beef (id 1) is accepted")
assert_eq(Store:RankForCharacter(chuck.id), 1, "character rank is the linked human's rank")
assert_eq(Store:GetCharacter(chuck.id).rankId, nil, "SetRank does not write rank onto the character")
assert_eq(ranked.elevationAt, nil, "Fresh Beef does not record an elevation timestamp")

assert_eq(Store:SetRank(steve.id, 2, 1301).rankId, 2, "Cooked Beef is accepted")
assert_eq(Store:SetRank(steve.id, 3, 1302).rankId, 3, "Beef Knight is accepted")
assert_eq(Store:GetHuman(steve.id).elevationAt, nil, "Knight does not record elevation")

local lord = Store:SetRank(steve.id, 4, 1400)
assert_eq(lord.rankId, 4, "Beef Lord (id 4) is accepted")
assert_eq(lord.elevationAt, 1400, "becoming Lord records an elevation timestamp")
assert_eq(Ranks.ById[4].title, "Beef Lord", "id 4 is Beef Lord in Ranks")

local stillLord = Store:SetRank(steve.id, 4, 1401)
assert_eq(stillLord.elevationAt, 1400, "a second Lord write does not overwrite elevationAt")

Store:SetRank(steve.id, 3, 1402)
assert_eq(Store:GetHuman(steve.id).rankId, 3, "rank may be set away from Lord")
assert_eq(Store:GetHuman(steve.id).elevationAt, 1400, "leaving Lord does not delete the elevation timestamp")
Store:SetRank(steve.id, 4, 1403)
assert_eq(Store:GetHuman(steve.id).elevationAt, 1400, "returning to Lord keeps the first elevation timestamp")

assert_eq(Store:SetRank(steve.id, 5, 1404).rankId, 5, "Beef Butcher is a valid rank id")
assert_eq(Store:SetRank(steve.id, 6, 1405).rankId, 6, "Beef Council is a valid rank id")
assert_eq(Store:GetHuman(steve.id).elevationAt, 1400, "non-Lord ranks do not clear elevationAt")

local cleared = Store:SetRank(steve.id, nil, 1406)
assert_eq(cleared.rankId, nil, "rank may be cleared to nil")
assert_eq(cleared.elevationAt, 1400, "clearing rank does not delete elevationAt")

local prophet, prophetErr = Store:SetRank(steve.id, 7, 1407)
assert_eq(prophet, nil, "id 7 / Prophet is refused")
assert_true(type(prophetErr) == "string", "Prophet refusal returns an error string")
assert_eq(Store:GetHuman(steve.id).rankId, nil, "refused Prophet write leaves rank unchanged")

local unknown, unknownErr = Store:SetRank(steve.id, 99)
assert_eq(unknown, nil, "unknown rank id is refused")
assert_true(type(unknownErr) == "string", "unknown rank returns an error string")

local titled, titledErr = Store:SetRank(steve.id, "Beef Lord")
assert_eq(titled, nil, "rank title strings are refused; ids only")
assert_true(type(titledErr) == "string", "title-string rank returns an error string")

local zero, zeroErr = Store:SetRank(steve.id, 0)
assert_eq(zero, nil, "rank id 0 is refused")
assert_true(type(zeroErr) == "string", "rank id 0 returns an error string")

local missingHuman, missingHumanErr = Store:SetRank(99, 1)
assert_eq(missingHuman, nil, "SetRank on an unknown human is refused")
assert_true(type(missingHumanErr) == "string", "unknown human rank write returns an error string")

--------------------------------------------------------------------------------
-- Elevation timestamp uses COB.Clock when now is omitted
--------------------------------------------------------------------------------
reset()
local clocked = Store:CreateHuman()
local savedWall = COB.Clock.Wall
COB.Clock.Wall = function(now)
  if type(now) == "number" then return now end
  return 55555
end
Store:SetRank(clocked.id, 4)
assert_eq(Store:GetHuman(clocked.id).elevationAt, 55555, "SetRank to Lord uses COB.Clock.Wall")
COB.Clock.Wall = savedWall

--------------------------------------------------------------------------------
-- Council flag and honorifics live on the human
--------------------------------------------------------------------------------
reset()
local officer = Store:CreateHuman({ name = "Cardinal" })
assert_eq(Store:SetCouncil(officer.id, true).council, true, "Council flag can be set")
assert_eq(Store:GetHuman(officer.id).rankId, nil, "Council flag does not invent a rank")
assert_eq(Store:SetCouncil(officer.id, false).council, false, "Council flag can be cleared")

local badFlag, badFlagErr = Store:SetCouncil(officer.id, "yes")
assert_eq(badFlag, nil, "non-boolean Council flag is refused")
assert_true(type(badFlagErr) == "string", "bad Council flag returns an error string")

local withHonor = Store:AddHonorific(officer.id, "Duke of the Fountain")
assert_eq(#withHonor.honorifics, 1, "honorific is appended")
assert_eq(withHonor.honorifics[1], "Duke of the Fountain", "honorific text is stored as given")
Store:AddHonorific(officer.id, "Martyr of Goldshire")
assert_eq(#Store:GetHuman(officer.id).honorifics, 2, "honorifics are a list")
assert_eq(Store:GetHuman(officer.id).honorifics[2], "Martyr of Goldshire", "second honorific is stored")

local emptyHonor, emptyHonorErr = Store:AddHonorific(officer.id, "")
assert_eq(emptyHonor, nil, "empty honorific is refused")
assert_true(type(emptyHonorErr) == "string", "empty honorific returns an error string")
assert_eq(#Store:GetHuman(officer.id).honorifics, 2, "refused honorific is not appended")

--------------------------------------------------------------------------------
-- Record a sanctioned Gora result onto a character, never a human
--------------------------------------------------------------------------------
reset()
local human = Store:CreateHuman()
local a = Store:CreateCharacter({ name = "Chuckroast" })
local b = Store:CreateCharacter({ name = "Tendermage" })
Store:LinkCharacter(a.id, human.id)
Store:SetRank(human.id, 3, 2000)

local win = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "victor",
  won = true,
  famousUpset = true,
  notable = true,
}, 2100)
assert_true(win ~= nil, "RecordGoraResult writes onto a character")
assert_eq(win.gora.wins, 1, "a victory increments wins")
assert_eq(win.gora.losses, 0, "a victory does not increment losses")
assert_eq(win.gora.streak, 1, "a victory starts a win streak")
assert_eq(win.gora.defenses, nil, "a victory does not store a defense counter")
assert_eq(#win.gora.results, 1, "the sanctioned result is appended")
assert_eq(win.gora.results[1].at, 2100, "the result carries a timestamp")
assert_eq(win.gora.results[1].opponentId, b.id, "the result names the opponent by id")
assert_eq(win.gora.results[1].ruling, "victor", "the result stores the Pope's ruling")
assert_eq(win.gora.results[1].won, true, "the result stores whether this character won")
assert_eq(win.gora.results[1].famousUpset, true, "Famous Upset is a flag on the result")
assert_eq(win.gora.notableVictims[1], b.id, "notable victim is the opponent id")
assert_eq(win.gora.rulings[1].ruling, "victor", "ruling received is recorded")
assert_eq(win.gora.headToHeads[1].opponentId, b.id, "head-to-head is keyed by opponent id")
assert_eq(win.gora.headToHeads[1].wins, 1, "head-to-head wins increment")
assert_eq(win.gora.headToHeads[1].losses, 0, "head-to-head losses stay 0")
assert_eq(win.gora.headToHeads[1].fights, 1, "head-to-head fights increment")

assert_eq(Store:GetHuman(human.id).gora, nil, "Gora result is not recorded on the human")
assert_eq(Store:GetHuman(human.id).rankId, 3, "a Gora win does not auto-elevate")
assert_eq(Store:GetHuman(human.id).elevationAt, nil, "a Gora win does not write elevationAt")

local loss = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "victor",
  won = false,
}, 2101)
assert_eq(loss.gora.wins, 1, "a loss leaves prior wins")
assert_eq(loss.gora.losses, 1, "a loss increments losses")
assert_eq(loss.gora.streak, -1, "a loss starts a loss streak")
assert_eq(loss.gora.headToHeads[1].losses, 1, "head-to-head losses increment")
assert_eq(loss.gora.headToHeads[1].fights, 2, "a rematch increments fights")
assert_eq(#loss.gora.notableVictims, 1, "a loss does not add a notable victim")

local coward = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "cowardice",
  won = false,
}, 2102)
assert_eq(coward.gora.losses, 2, "Cowardice Recorded against this character is a loss")
assert_eq(coward.gora.rulings[3].ruling, "cowardice", "Cowardice is a ruling received")
assert_eq(coward.gora.results[3].ruling, "cowardice", "Cowardice is stored on the result")
assert_eq(coward.gora.defenses, nil, "Cowardice does not invent a defense counter")

local voided = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "void",
}, 2103)
assert_eq(voided.gora.wins, 1, "Void does not increment wins")
assert_eq(voided.gora.losses, 2, "Void does not increment losses")
assert_eq(voided.gora.streak, -2, "Void does not change the fight-record streak")
assert_eq(voided.gora.headToHeads[1].fights, 4, "Void still happened as a sanctioned fight")
assert_eq(voided.gora.results[4].ruling, "void", "Void is stored as the Pope's ruling")
assert_eq(voided.gora.defenses, nil, "Void does not store a defense")

local beforeFreeWins = Store:GetCharacter(a.id).gora.wins
local beforeFreeLosses = Store:GetCharacter(a.id).gora.losses
local beforeFreeStreak = Store:GetCharacter(a.id).gora.streak
local beforeFreeResults = #Store:GetCharacter(a.id).gora.results
local beforeFreeFights = Store:GetCharacter(a.id).gora.headToHeads[1].fights
local beforeFreeH2hWins = Store:GetCharacter(a.id).gora.headToHeads[1].wins
local beforeFreeH2hLosses = Store:GetCharacter(a.id).gora.headToHeads[1].losses

local freeWin, freeWinErr = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "free",
  won = true,
}, 2104)
assert_eq(freeWin, nil, "free + won = true is refused")
assert_true(type(freeWinErr) == "string", "free + won = true returns an error string")
assert_eq(Store:GetCharacter(a.id).gora.wins, beforeFreeWins, "refused free+won does not increment wins")
assert_eq(Store:GetCharacter(a.id).gora.losses, beforeFreeLosses, "refused free+won does not increment losses")
assert_eq(Store:GetCharacter(a.id).gora.streak, beforeFreeStreak, "refused free+won does not change the streak")
assert_eq(#Store:GetCharacter(a.id).gora.results, beforeFreeResults, "refused free+won does not append a result")

local freeLoss, freeLossErr = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "free",
  won = false,
}, 2105)
assert_eq(freeLoss, nil, "free + won = false is refused")
assert_true(type(freeLossErr) == "string", "free + won = false returns an error string")
assert_eq(#Store:GetCharacter(a.id).gora.results, beforeFreeResults, "refused free+won=false leaves the store unchanged")
assert_eq(Store:GetCharacter(a.id).gora.wins, beforeFreeWins, "refused free+won=false does not increment wins")
assert_eq(Store:GetCharacter(a.id).gora.losses, beforeFreeLosses, "refused free+won=false does not increment losses")

local free = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "free",
  text = "  rematch at the Pope's pleasure  ",
}, 2106)
assert_true(free ~= nil, "free without won writes the bout")
assert_eq(free.gora.wins, beforeFreeWins, "free ruling does not increment wins")
assert_eq(free.gora.losses, beforeFreeLosses, "free ruling does not increment losses")
assert_eq(free.gora.streak, beforeFreeStreak, "free ruling does not change the fight-record streak")
assert_eq(free.gora.headToHeads[1].wins, beforeFreeH2hWins, "free ruling does not increment h2h wins")
assert_eq(free.gora.headToHeads[1].losses, beforeFreeH2hLosses, "free ruling does not increment h2h losses")
assert_eq(free.gora.headToHeads[1].fights, beforeFreeFights + 1, "free ruling increments h2h fights")
assert_eq(#free.gora.results, beforeFreeResults + 1, "free ruling appends a result")
assert_eq(free.gora.results[#free.gora.results].ruling, "free", "free ruling is stored")
assert_eq(free.gora.results[#free.gora.results].won, nil, "free ruling has no won flag")
assert_eq(free.gora.results[#free.gora.results].text, "rematch at the Pope's pleasure", "free ruling stores trimmed Pope text")
assert_eq(free.gora.results[#free.gora.results].famousUpset, false, "free ruling famousUpset defaults false")
assert_eq(free.gora.rulings[#free.gora.rulings].ruling, "free", "free ruling is appended to rulings")

local quietFree = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "free",
}, 2107)
assert_true(quietFree ~= nil, "free may omit text")
assert_eq(quietFree.gora.results[#quietFree.gora.results].text, nil, "omitted free text is nil")
assert_eq(quietFree.gora.results[#quietFree.gora.results].won, nil, "omitted-text free still has no won flag")

local blankFree = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "free",
  text = "   ",
}, 2108)
assert_true(blankFree ~= nil, "empty free text is accepted as omitted")
assert_eq(blankFree.gora.results[#blankFree.gora.results].text, nil, "empty free text is stored as nil")

local nilWonFree = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "free",
  won = nil,
}, 2109)
assert_true(nilWonFree ~= nil, "free with explicit won = nil is accepted")
assert_eq(nilWonFree.gora.results[#nilWonFree.gora.results].won, nil, "explicit nil won stays nil")

local badFreeText, badFreeTextErr = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "free",
  text = 42,
}, 2110)
assert_eq(badFreeText, nil, "non-string free text is refused")
assert_true(type(badFreeTextErr) == "string", "non-string free text returns an error string")
assert_eq(#Store:GetCharacter(a.id).gora.results, #nilWonFree.gora.results, "refused non-string text does not append")

-- Human and character sequences both start at 1, so human.id may equal a
-- character id. Create extra humans until the id is not a character row.
local strayHuman = Store:CreateHuman()
while Store:GetCharacter(strayHuman.id) do
  strayHuman = Store:CreateHuman()
end
local missingChar, missingCharErr = Store:RecordGoraResult(strayHuman.id, {
  opponentId = b.id,
  ruling = "victor",
  won = true,
})
assert_eq(missingChar, nil, "RecordGoraResult refuses an id that is not a character")
assert_true(type(missingCharErr) == "string", "non-character Gora write returns an error string")
assert_eq(Store:GetHuman(strayHuman.id).gora, nil, "a refused write does not attach Gora to the human")

local nameOpp, nameOppErr = Store:RecordGoraResult(a.id, {
  opponentId = "tendermage",
  ruling = "victor",
  won = true,
})
assert_eq(nameOpp, nil, "opponent must be a character id, not a name")
assert_true(type(nameOppErr) == "string", "name-string opponent returns an error string")

local badRuling, badRulingErr = Store:RecordGoraResult(a.id, {
  opponentId = b.id,
  ruling = "draw",
  won = true,
})
assert_eq(badRuling, nil, "invented outcome strings are refused")
assert_true(type(badRulingErr) == "string", "bad ruling returns an error string")

--------------------------------------------------------------------------------
-- Never-delete: tombstone / inactive only; row remains
--------------------------------------------------------------------------------
reset()
local stay = Store:CreateHuman({ name = "Stay" }, 3000)
local alt = Store:CreateCharacter({ name = "Stayalt" }, 3001)
Store:LinkCharacter(alt.id, stay.id, 3002)
Store:SetRank(stay.id, 2, 3003)
Store:AddHonorific(stay.id, "Defender of the Faith")

local deadHuman = Store:TombstoneHuman(stay.id, 3100)
assert_eq(deadHuman.inactive, true, "TombstoneHuman sets inactive")
assert_eq(deadHuman.id, stay.id, "tombstoned human keeps its id")
assert_eq(deadHuman.rankId, 2, "tombstone does not wipe rank")
assert_eq(deadHuman.honorifics[1], "Defender of the Faith", "tombstone does not wipe honorifics")
assert_eq(Store:GetHuman(stay.id).inactive, true, "GetHuman still returns a tombstoned human")
assert_eq(Store:GetHuman(stay.id).history[#Store:GetHuman(stay.id).history].kind, "inactive",
  "tombstone appends an inactive membership event")
assert_eq(Store.SweepDeparted, nil, "no SweepDeparted")
assert_eq(Store.Prune, nil, "no Prune")
assert_eq(Store.DeleteHuman, nil, "no DeleteHuman")
assert_eq(Store.DeleteCharacter, nil, "no DeleteCharacter")

local deadChar = Store:TombstoneCharacter(alt.id, 3101)
assert_eq(deadChar.inactive, true, "TombstoneCharacter sets inactive")
assert_eq(Store:GetCharacter(alt.id).id, alt.id, "GetCharacter still returns a tombstoned character")
assert_eq(Store:GetCharacter(alt.id).gora.wins, 0, "tombstone does not wipe the Gora record")
assert_eq(Store:GetHuman(stay.id).characterIds[1], alt.id, "tombstone does not unlink")

--------------------------------------------------------------------------------
-- Ceremony log: type + timestamp + participant ids; no narration
--------------------------------------------------------------------------------
reset()
local p1 = Store:CreateHuman()
local c1 = Store:CreateCharacter({ name = "Knighted" })
Store:LinkCharacter(c1.id, p1.id)
local rite = Store:AppendCeremony("Knighting", { c1.id, p1.id }, 4000)
assert_true(rite ~= nil, "AppendCeremony returns the entry")
assert_true(isInt(rite.id), "ceremony entry has a store-local id")
assert_eq(rite.type, "Knighting", "ceremony type is stored")
assert_eq(rite.at, 4000, "ceremony timestamp is stored")
assert_eq(rite.participantIds[1], c1.id, "participant ids are stored")
assert_eq(rite.participantIds[2], p1.id, "human id may be a participant")
assert_eq(rite.scripture, nil, "ceremony log has no scripture")
assert_eq(rite.narration, nil, "ceremony log has no narration")
assert_eq(rite.text, nil, "ceremony log has no generated text")
assert_eq(rite.flavor, nil, "ceremony log has no flavor text")

local log = Store:GetCeremonyLog()
assert_eq(#log, 1, "ceremony log is append-only and readable")
log[1].type = "hacked"
log[1].participantIds[1] = 0
assert_eq(Store:GetCeremonyLog()[1].type, "Knighting", "mutating a log copy does not rewrite history")
assert_eq(Store:GetCeremonyLog()[1].participantIds[1], c1.id, "mutating participant ids does not rewrite history")

local nameParts, namePartsErr = Store:AppendCeremony("Knighting", { "knighted" }, 4001)
assert_eq(nameParts, nil, "ceremony participants must be integer ids")
assert_true(type(namePartsErr) == "string", "name-string participants return an error string")
assert_eq(#Store:GetCeremonyLog(), 1, "refused ceremony append is not stored")

local noType, noTypeErr = Store:AppendCeremony("", { c1.id }, 4002)
assert_eq(noType, nil, "empty ceremony type is refused")
assert_true(type(noTypeErr) == "string", "empty ceremony type returns an error string")

local withLine = Store:AppendCeremony("free", { c1.id }, 4003, "  rematch at the Pope's pleasure  ")
assert_true(withLine ~= nil, "AppendCeremony accepts optional text")
assert_eq(withLine.type, "free", "4-arg ceremony type is stored")
assert_eq(withLine.text, "rematch at the Pope's pleasure", "4-arg stores trimmed Pope-authored text")
assert_eq(withLine.narration, nil, "4-arg ceremony has no narration")
assert_eq(withLine.scripture, nil, "4-arg ceremony has no scripture")

local emptyLine = Store:AppendCeremony("free", { c1.id }, 4004, "   ")
assert_true(emptyLine ~= nil, "empty ceremony text is accepted as omitted")
assert_eq(emptyLine.text, nil, "empty ceremony text is omitted")

local threeArg = Store:AppendCeremony("Recognition", { c1.id, p1.id }, 4005)
assert_true(threeArg ~= nil, "3-arg AppendCeremony still works")
assert_eq(threeArg.text, nil, "3-arg ceremony has no text field")

local badLine, badLineErr = Store:AppendCeremony("free", { c1.id }, 4006, 99)
assert_eq(badLine, nil, "non-string ceremony text is refused")
assert_true(type(badLineErr) == "string", "non-string ceremony text returns an error string")
assert_eq(#Store:GetCeremonyLog(), 4, "refused 4-arg text is not stored")

--------------------------------------------------------------------------------
-- Marked moments: flag-hot only — timestamp, optional location; no canon text
--------------------------------------------------------------------------------
reset()
local marked = Store:FlagMoment("Goldshire", 5000)
assert_true(marked ~= nil, "FlagMoment returns the row")
assert_true(isInt(marked.id), "marked moment has a store-local id")
assert_eq(marked.at, 5000, "marked moment has a timestamp")
assert_eq(marked.location, "Goldshire", "optional location is stored")
assert_eq(marked.scripture, nil, "marked moment has no scripture")
assert_eq(marked.canon, nil, "marked moment is not a canonization")
assert_eq(marked.text, nil, "marked moment has no flavor text")

local quietMark = Store:FlagMoment(nil, 5001)
assert_eq(quietMark.location, nil, "location may be omitted")
assert_eq(quietMark.at, 5001, "timestamp is still recorded")

local moments = Store:GetMarkedMoments()
assert_eq(#moments, 2, "marked moments are append-only")
moments[1].text = "auto scripture"
assert_eq(Store:GetMarkedMoments()[1].text, nil, "mutating a moment copy does not invent scripture")
assert_eq(type(Store.CanonizeMoment), "function", "CANONIZE is Store:CanonizeMoment")
assert_eq(type(Store.FlagFamousUpset), "function", "Famous Upset is a Pope flag, not a computation")

--------------------------------------------------------------------------------
-- CanonizeMoment: cold Pope-authored scripture on a marked moment
--------------------------------------------------------------------------------
reset()
local goldshire = Store:FlagMoment("Goldshire", 5100)
local painted, paintErr = Store:CanonizeMoment(goldshire.id, "  The fountain held.  ")
assert_true(painted ~= nil, "CanonizeMoment returns the row")
assert_eq(paintErr, nil, "successful canonize has no error")
assert_eq(painted.id, goldshire.id, "canonize writes the same marked-moment id")
assert_eq(painted.at, 5100, "canonize does not rewrite the flag timestamp")
assert_eq(painted.location, "Goldshire", "canonize does not invent or rewrite location")
assert_eq(painted.scripture, "The fountain held.", "CanonizeMoment stores trimmed Pope text as scripture")
assert_eq(painted.narration, nil, "canonize does not invent narration")
assert_eq(painted.canon, nil, "canonize does not invent a canon generator field")
assert_eq(Store:GetMarkedMoments()[1].scripture, "The fountain held.", "GetMarkedMoments copies scripture")
assert_eq(#Store:GetMarkedMoments(), 1, "canonize does not delete or duplicate the moment")

local liveMoment = Store:GetMarkedMoments()[1]
liveMoment.scripture = "hacked"
assert_eq(Store:GetMarkedMoments()[1].scripture, "The fountain held.", "mutating a canonized copy does not rewrite scripture")

local quietCanon = Store:FlagMoment(nil, 5101)
local quietPainted = Store:CanonizeMoment(quietCanon.id, "A quiet mark.")
assert_eq(quietPainted.location, nil, "canonize does not invent a location")
assert_eq(quietPainted.scripture, "A quiet mark.", "a location-less moment may still carry scripture")

local unknownMoment, unknownMomentErr = Store:CanonizeMoment(99, "Lost words.")
assert_eq(unknownMoment, nil, "unknown moment id is refused")
assert_true(type(unknownMomentErr) == "string", "unknown moment returns an error string")
assert_eq(#Store:GetMarkedMoments(), 2, "refused unknown id does not append a moment")

local emptyScript, emptyScriptErr = Store:CanonizeMoment(goldshire.id, "")
assert_eq(emptyScript, nil, "empty scripture is refused")
assert_true(type(emptyScriptErr) == "string", "empty scripture returns an error string")
assert_eq(Store:GetMarkedMoments()[1].scripture, "The fountain held.", "refused empty does not wipe scripture")

local blankScript, blankScriptErr = Store:CanonizeMoment(goldshire.id, "   ")
assert_eq(blankScript, nil, "whitespace-only scripture is refused")
assert_true(type(blankScriptErr) == "string", "whitespace-only scripture returns an error string")

local newlineScript, newlineScriptErr = Store:CanonizeMoment(goldshire.id, "The fountain held.\nSo ruled.")
assert_eq(newlineScript, nil, "scripture with a newline is refused")
assert_true(type(newlineScriptErr) == "string", "newline scripture returns an error string")
assert_eq(Store:GetMarkedMoments()[1].scripture, "The fountain held.", "refused newline does not rewrite scripture")

local missingText, missingTextErr = Store:CanonizeMoment(goldshire.id)
assert_eq(missingText, nil, "missing scripture is refused")
assert_true(type(missingTextErr) == "string", "missing scripture returns an error string")

local badText, badTextErr = Store:CanonizeMoment(goldshire.id, 42)
assert_eq(badText, nil, "non-string scripture is refused")
assert_true(type(badTextErr) == "string", "non-string scripture returns an error string")

local badMomentId, badMomentIdErr = Store:CanonizeMoment("goldshire", "The fountain held.")
assert_eq(badMomentId, nil, "a name string is not a moment id")
assert_true(type(badMomentIdErr) == "string", "name-string moment id returns an error string")

--------------------------------------------------------------------------------
-- FlagFamousUpset: Pope flag on the latest matching victory; never computed
--------------------------------------------------------------------------------
reset()
local champ = Store:CreateCharacter({ name = "Chuckroast", level = 60 })
local foe = Store:CreateCharacter({ name = "Tendermage", level = 70 })
local other = Store:CreateCharacter({ name = "Brisket" })

local firstWin = Store:RecordGoraResult(champ.id, {
  opponentId = foe.id,
  ruling = "victor",
  won = true,
}, 5200)
assert_eq(firstWin.gora.results[1].famousUpset, false, "a victory is not an Upset until the Pope flags it")
assert_eq(#firstWin.gora.notableVictims, 0, "a victory does not invent notable")

local flagged, flagErr = Store:FlagFamousUpset(champ.id, foe.id)
assert_true(flagged ~= nil, "FlagFamousUpset after a victor writes the flag")
assert_eq(flagErr, nil, "successful flag has no error")
assert_eq(flagged.gora.results[1].famousUpset, true, "the matching victory is flagged")
assert_eq(flagged.gora.results[1].won, true, "flag does not rewrite won")
assert_eq(#flagged.gora.notableVictims, 0, "FlagFamousUpset does not set notable")
assert_eq(flagged.level, 60, "flag does not read levels to compute an upset")

local rematchA = Store:CreateCharacter({ name = "Rematcha" })
local rematchB = Store:CreateCharacter({ name = "Rematchb" })
Store:RecordGoraResult(rematchA.id, {
  opponentId = rematchB.id,
  ruling = "victor",
  won = true,
}, 5201)
Store:RecordGoraResult(rematchA.id, {
  opponentId = rematchB.id,
  ruling = "victor",
  won = true,
}, 5202)
local latestFlag = Store:FlagFamousUpset(rematchA.id, rematchB.id)
assert_eq(latestFlag.gora.results[1].famousUpset, false, "the earlier of two wins is not the flagged row")
assert_eq(latestFlag.gora.results[2].famousUpset, true, "the latest of two wins is the row that is flagged")

Store:RecordGoraResult(champ.id, {
  opponentId = other.id,
  ruling = "victor",
  won = true,
}, 5203)
Store:FlagFamousUpset(champ.id, other.id)
assert_eq(Store:GetCharacter(champ.id).gora.results[1].famousUpset, true, "flagging another opponent does not clear the prior flag")
assert_eq(Store:GetCharacter(champ.id).gora.results[2].famousUpset, true, "a later opponent win is flagged on its own row")

local lossOnly = Store:CreateCharacter({ name = "Lossalt" })
Store:RecordGoraResult(lossOnly.id, {
  opponentId = foe.id,
  ruling = "victor",
  won = false,
}, 5203)
local lossFlag, lossFlagErr = Store:FlagFamousUpset(lossOnly.id, foe.id)
assert_eq(lossFlag, nil, "a loss is not a Famous Upset")
assert_true(type(lossFlagErr) == "string", "loss flag returns an error string")
assert_eq(Store:GetCharacter(lossOnly.id).gora.results[1].famousUpset, false, "refused loss does not set the flag")
assert_eq(#Store:GetCharacter(lossOnly.id).gora.notableVictims, 0, "refused loss does not set notable")

local voidOnly = Store:CreateCharacter({ name = "Voidalt" })
Store:RecordGoraResult(voidOnly.id, {
  opponentId = foe.id,
  ruling = "void",
}, 5204)
local voidFlag, voidFlagErr = Store:FlagFamousUpset(voidOnly.id, foe.id)
assert_eq(voidFlag, nil, "a void is not a Famous Upset")
assert_true(type(voidFlagErr) == "string", "void flag returns an error string")
assert_eq(Store:GetCharacter(voidOnly.id).gora.results[1].famousUpset, false, "refused void does not set the flag")

local winThenLoss = Store:CreateCharacter({ name = "Winloss" })
Store:RecordGoraResult(winThenLoss.id, {
  opponentId = foe.id,
  ruling = "victor",
  won = true,
}, 5205)
Store:RecordGoraResult(winThenLoss.id, {
  opponentId = foe.id,
  ruling = "victor",
  won = false,
}, 5206)
local afterLoss = Store:FlagFamousUpset(winThenLoss.id, foe.id)
assert_eq(afterLoss.gora.results[1].famousUpset, true, "the latest matching win is flagged even if a later bout is a loss")
assert_eq(afterLoss.gora.results[2].famousUpset, false, "a later loss is not flagged")

local noMatch, noMatchErr = Store:FlagFamousUpset(champ.id, 99)
assert_eq(noMatch, nil, "no matching victory is refused")
assert_true(type(noMatchErr) == "string", "no-match flag returns an error string")

local missingChamp, missingChampErr = Store:FlagFamousUpset(99, foe.id)
assert_eq(missingChamp, nil, "unknown character is refused")
assert_true(type(missingChampErr) == "string", "unknown character flag returns an error string")

local nameChamp, nameChampErr = Store:FlagFamousUpset("chuckroast", foe.id)
assert_eq(nameChamp, nil, "a name string is not a character id")
assert_true(type(nameChampErr) == "string", "name-string character id returns an error string")

local nameFoe, nameFoeErr = Store:FlagFamousUpset(champ.id, "tendermage")
assert_eq(nameFoe, nil, "opponent must be a character id, not a name")
assert_true(type(nameFoeErr) == "string", "name-string opponent returns an error string")

--------------------------------------------------------------------------------
-- Snapshot / Restore keep FlagFamousUpset on the latest win
--------------------------------------------------------------------------------
reset()
local flagA = Store:CreateCharacter({ name = "Flaga" })
local flagB = Store:CreateCharacter({ name = "Flagb" })
Store:RecordGoraResult(flagA.id, {
  opponentId = flagB.id,
  ruling = "victor",
  won = true,
}, 5300)
Store:RecordGoraResult(flagA.id, {
  opponentId = flagB.id,
  ruling = "victor",
  won = true,
}, 5301)
Store:FlagFamousUpset(flagA.id, flagB.id)
local flagSnap = Store:Snapshot()
assert_eq(flagSnap.characters[1].gora.results[1].famousUpset, false, "Snapshot keeps the earlier win unflagged")
assert_eq(flagSnap.characters[1].gora.results[2].famousUpset, true, "Snapshot keeps the flagged latest win")
reset()
assert_eq(Store:Restore(flagSnap), true, "Restore accepts a flagged-upset snapshot")
assert_eq(Store:GetCharacter(flagA.id).gora.results[1].famousUpset, false, "Restore keeps the earlier win unflagged")
assert_eq(Store:GetCharacter(flagA.id).gora.results[2].famousUpset, true, "Restore brings back the flagged result")

--------------------------------------------------------------------------------
-- Snapshot / Restore lock the in-memory shape for Archive (Lane B)
--------------------------------------------------------------------------------
reset()
local snapH = Store:CreateHuman({ name = "Snap" }, 6000)
local snapC = Store:CreateCharacter({ name = "Snapalt", class = "Mage" }, 6001)
Store:LinkCharacter(snapC.id, snapH.id, 6002)
Store:SetRank(snapH.id, 4, 6003)
Store:SetCouncil(snapH.id, true)
Store:AddHonorific(snapH.id, "Defender of the Faith")
Store:RecordGoraResult(snapC.id, {
  opponentId = Store:CreateCharacter({ name = "Foe" }).id,
  ruling = "victor",
  won = true,
  famousUpset = true,
}, 6004)
Store:TombstoneHuman(snapH.id, 6005)
Store:AppendCeremony("Gora", { snapC.id }, 6006)
local snapMoment = Store:FlagMoment("Shattrath", 6007)
Store:CanonizeMoment(snapMoment.id, "The fountain held.")

local snap = Store:Snapshot()
assert_eq(type(snap), "table", "Snapshot returns a table")
assert_eq(type(snap.humans), "table", "Snapshot has humans")
assert_eq(type(snap.characters), "table", "Snapshot has characters")
assert_eq(type(snap.ceremonyLog), "table", "Snapshot has ceremonyLog")
assert_eq(type(snap.markedMoments), "table", "Snapshot has markedMoments")
assert_eq(#snap.humans, 1, "Snapshot lists the human")
assert_eq(snap.humans[1].id, snapH.id, "Snapshot human keeps integer id")
assert_eq(snap.humans[1].rankId, 4, "Snapshot keeps rank")
assert_eq(snap.humans[1].elevationAt, 6003, "Snapshot keeps elevationAt")
assert_eq(snap.humans[1].inactive, true, "Snapshot keeps tombstone")
assert_eq(snap.humans[1].council, true, "Snapshot keeps Council flag")
assert_eq(snap.humans[1].honorifics[1], "Defender of the Faith", "Snapshot keeps honorifics")
assert_eq(snap.characters[1].gora.results[1].famousUpset, true, "Snapshot keeps Famous Upset flags")
assert_eq(snap.characters[1].gora.defenses, nil, "Snapshot does not invent defenses")
assert_eq(snap.ceremonyLog[1].type, "Gora", "Snapshot keeps the ceremony log")
assert_eq(snap.markedMoments[1].location, "Shattrath", "Snapshot keeps marked moments")
assert_eq(snap.markedMoments[1].scripture, "The fountain held.", "Snapshot keeps Pope-authored scripture")
assert_true(isInt(snap.nextHumanId), "Snapshot carries nextHumanId")
assert_true(isInt(snap.nextCharacterId), "Snapshot carries nextCharacterId")

local tamper = Store:Snapshot()
tamper.humans[1].rankId = 1
assert_eq(Store:GetHuman(snapH.id).rankId, 4, "mutating a Snapshot does not change live rank")
assert_eq(snap.humans[1].rankId, 4, "a second Snapshot is its own copy")

reset()
assert_eq(Store:GetHuman(snapH.id), nil, "reset clears live humans")
assert_eq(Store:Restore(snap), true, "Restore accepts a Snapshot")
assert_eq(Store:GetHuman(snapH.id).rankId, 4, "Restore brings back rank")
assert_eq(Store:GetHuman(snapH.id).elevationAt, 6003, "Restore brings back elevationAt")
assert_eq(Store:GetHuman(snapH.id).inactive, true, "Restore brings back tombstone")
assert_eq(Store:GetCharacter(snapC.id).gora.wins, 1, "Restore brings back Gora wins")
assert_eq(Store:GetCeremonyLog()[1].type, "Gora", "Restore brings back the ceremony log")
assert_eq(Store:GetMarkedMoments()[1].location, "Shattrath", "Restore brings back marked moments")
assert_eq(Store:GetMarkedMoments()[1].scripture, "The fountain held.", "Restore brings back scripture")

local after = Store:CreateHuman()
assert_true(after.id >= snap.nextHumanId, "ids after Restore do not reuse snapshot ids")

local badRestore, badRestoreErr = Store:Restore("nope")
assert_eq(badRestore, nil, "Restore refuses a non-table")
assert_true(type(badRestoreErr) == "string", "bad Restore returns an error string")

--------------------------------------------------------------------------------
-- Restore keeps free rulings with won == nil and optional text
--------------------------------------------------------------------------------
reset()
local restA = Store:CreateCharacter({ name = "Resta" })
local restB = Store:CreateCharacter({ name = "Restb" })
Store:RecordGoraResult(restA.id, {
  opponentId = restB.id,
  ruling = "free",
  text = "the fountain stays",
}, 7000)
local freeSnap = Store:Snapshot()
freeSnap.characters[1].gora.results[1].leftoverNote = "keep"
freeSnap.characters[1].customMark = "keep"
reset()
assert_eq(Store:Restore(freeSnap), true, "Restore accepts a free-ruling snapshot")
local restored = Store:GetCharacter(restA.id)
assert_eq(restored.gora.results[1].ruling, "free", "Restore keeps free ruling")
assert_eq(restored.gora.results[1].won, nil, "Restore does not invent won = false on free")
assert_eq(restored.gora.results[1].text, "the fountain stays", "Restore keeps free ruling text")
assert_eq(restored.gora.wins, 0, "restored free ruling has no wins")
assert_eq(restored.gora.losses, 0, "restored free ruling has no losses")
assert_eq(restored.gora.results[1].leftoverNote, "keep", "Restore does not wipe leftover result keys")
assert_eq(restored.customMark, "keep", "Restore does not wipe leftover character keys")

--------------------------------------------------------------------------------
-- CountDefenses: derived from elevationAt + won == true; never a stored field
--------------------------------------------------------------------------------
local function runCountDefenses()
  assert_eq(type(Store.CountDefenses), "function", "CountDefenses is a Store read")
  reset()
  local lordH = Store:CreateHuman({ name = "Lord" })
  local lordC = Store:CreateCharacter({ name = "Lordalt" })
  local foe = Store:CreateCharacter({ name = "Foealt" })
  local unlinked = Store:CreateCharacter({ name = "Strayalt" })
  Store:LinkCharacter(lordC.id, lordH.id)
  Store:SetRank(lordH.id, 3, 8000)

  Store:RecordGoraResult(lordC.id, {
    opponentId = foe.id,
    ruling = "victor",
    won = true,
    famousUpset = true,
    notable = true,
  }, 8010)
  assert_eq(Store:CountDefenses(lordC.id), 0, "a Knight win before elevation is not a defense")
  assert_eq(Store:GetHuman(lordH.id).elevationAt, nil, "Knight still has no elevationAt")
  assert_eq(Store:GetCharacter(lordC.id).gora.defenses, nil, "pre-elevation win does not write defenses")

  Store:SetRank(lordH.id, 4, 8100)
  assert_eq(Store:GetHuman(lordH.id).elevationAt, 8100, "first Lord write stamps elevationAt")
  assert_eq(Store:CountDefenses(lordC.id), 0, "the pre-elevation win is still not counted")

  Store:RecordGoraResult(lordC.id, {
    opponentId = foe.id,
    ruling = "victor",
    won = true,
  }, 8200)
  Store:RecordGoraResult(lordC.id, {
    opponentId = foe.id,
    ruling = "victor",
    won = true,
    famousUpset = true,
    notable = true,
  }, 8210)
  assert_eq(Store:CountDefenses(lordC.id), 2, "Lord + two post-elevation wins is 2")
  assert_eq(Store:GetCharacter(lordC.id).gora.defenses, nil, "two post-elevation wins do not store defenses")
  assert_eq(Store:GetCharacter(lordC.id).gora.defenseCount, nil, "two post-elevation wins do not store defenseCount")
  assert_eq(Store:GetCharacter(lordC.id).gora.results[2].famousUpset, false, "CountDefenses does not invent famousUpset")
  assert_eq(Store:GetCharacter(lordC.id).gora.results[3].famousUpset, true, "a Pope-flagged win is still one defense")

  Store:RecordGoraResult(lordC.id, {
    opponentId = foe.id,
    ruling = "void",
  }, 8300)
  Store:RecordGoraResult(lordC.id, {
    opponentId = foe.id,
    ruling = "free",
    text = "rematch at the Pope's pleasure",
  }, 8310)
  assert_eq(Store:CountDefenses(lordC.id), 2, "void and free after elevation are not defenses")
  assert_eq(Store:GetCharacter(lordC.id).gora.results[4].won, nil, "void has no won flag")
  assert_eq(Store:GetCharacter(lordC.id).gora.results[5].won, nil, "free has no won flag")

  Store:RecordGoraResult(lordC.id, {
    opponentId = foe.id,
    ruling = "victor",
    won = false,
  }, 8320)
  assert_eq(Store:CountDefenses(lordC.id), 2, "a post-elevation loss is not a defense")

  Store:RecordGoraResult(lordC.id, {
    opponentId = foe.id,
    ruling = "cowardice",
    won = true,
  }, 8400)
  assert_eq(Store:CountDefenses(lordC.id), 3, "Cowardice on the Lord with won == true is a defense")
  assert_eq(Store:GetCharacter(lordC.id).gora.results[7].ruling, "cowardice", "the counted cowardice row keeps its ruling")
  assert_eq(Store:GetCharacter(lordC.id).gora.results[7].won, true, "the counted cowardice row keeps won == true")
  assert_eq(Store:GetCharacter(lordC.id).gora.defenses, nil, "cowardice defense does not write gora.defenses")

  Store:SetRank(lordH.id, 3, 8500)
  assert_eq(Store:GetHuman(lordH.id).rankId, 3, "rank may leave Lord")
  assert_eq(Store:GetHuman(lordH.id).elevationAt, 8100, "leaving Lord keeps elevationAt")
  assert_eq(Store:CountDefenses(lordC.id), 3, "leaving Lord does not erase derived defenses")

  assert_eq(Store:CountDefenses(unlinked.id), 0, "unlinked character is 0")
  assert_eq(Store:CountDefenses(99), 0, "unknown character id is 0")
  assert_eq(Store:CountDefenses("lordalt"), 0, "a name string is 0")
  assert_eq(Store:CountDefenses(nil), 0, "nil id is 0")
  assert_eq(Store:CountDefenses(0), 0, "id 0 is 0")

  local snap = Store:Snapshot()
  assert_eq(snap.characters[1].gora.defenses, nil, "Snapshot still strips defenses")
  assert_eq(snap.humans[1].elevationAt, 8100, "Snapshot still keeps elevationAt")
  reset()
  assert_eq(Store:Restore(snap), true, "Restore accepts the CountDefenses snapshot")
  assert_eq(Store:CountDefenses(lordC.id), 3, "Restore still derives defenses from results + elevationAt")
  assert_eq(Store:GetCharacter(lordC.id).gora.defenses, nil, "Restore still strips gora.defenses")
end
runCountDefenses()

--------------------------------------------------------------------------------
-- Banned product: no Grant, standing, points, Prophet, Director, Archive codec
--------------------------------------------------------------------------------
assert_eq(Store.Grant, nil, "no Grant")
assert_eq(Store.GrantGora, nil, "no GrantGora")
assert_eq(Store.SetStanding, nil, "no SetStanding")
assert_eq(Store.GetStanding, nil, "no GetStanding")
assert_eq(Store.AddPoints, nil, "no AddPoints")
assert_eq(Store.Prophet, nil, "no Prophet")
assert_eq(Store.Export, nil, "Archive codec is not this lane")
assert_eq(Store.Import, nil, "Archive import is not this lane")
assert_eq(Store.BeginRecognition, nil, "Rite of Recognition is not this lane")
assert_eq(type(Store.Snapshot), "function", "Snapshot is the in-memory shape for Lane B")
assert_eq(type(Store.Restore), "function", "Restore is the in-memory shape for Lane B")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
