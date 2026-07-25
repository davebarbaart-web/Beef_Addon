-- Officer tab rites and the guild-chat liturgy. Widget behaviour comes from
-- tests/wow_ui_stub.lua and SendChatMessage is recorded rather than sent, so this
-- proves wiring and refusals only — promotion-night spectacle still needs the client.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local COB = ChurchOfBeef

-- TOC order: MainFrame owns COB.UI, Announce loads before the tabs that use it.
dofile("addon/ChurchOfBeef/UI/MainFrame.lua")
dofile("addon/ChurchOfBeef/UI/Announce.lua")
dofile("addon/ChurchOfBeef/UI/LadderTab.lua")
dofile("addon/ChurchOfBeef/UI/StandingTab.lua")
dofile("addon/ChurchOfBeef/UI/OfficerTab.lua")
dofile("addon/ChurchOfBeef/UI/Minimap.lua")
dofile("addon/ChurchOfBeef/UI/Toasts.lua")

local Tab = COB.OfficerTab

COB.Ladder:ResetForTests()
COB.Scoring:ResetForTests()
COB.Announce:ResetForTests()
ChurchOfBeefDB = nil
COB.DB:Init()

-- The acting officer, not the subject of any rite below.
stub.playerName = "Popeina"

-- Rites refuse a name the guild has never heard of, so every intended subject has
-- to answer to a roster entry. Steakina carries a realm suffix on purpose.
stub.guildRoster = {
  "Popeina", "Beefina", "Steakina-Nightslayer", "Chuckina", "Fifthina",
  "Prophetina", "Falseina", "Brisketina", "Rumpina",
}

local function chatCount() return #stub.chat end
local function lastChat()
  local entry = stub.chat[#stub.chat]
  return entry and entry.text or nil
end

local function crossThreshold(name)
  -- Two Gora wins clear the Cooked Beef threshold and queue a petition.
  COB.Scoring:GrantGora(name, "win")
  COB.Scoring:GrantGora(name, "win")
end

local function refreshOfficer()
  COB.UI:MarkDirty("officer")
end

local function rankOf(name)
  return COB.Ladder:GetRecord(name).rankId
end

--------------------------------------------------------------------------------
-- Announce defaults ON before anyone touches the checkbox
--------------------------------------------------------------------------------
assert_eq(ChurchOfBeefDB.ui.announce, true, "announce defaults ON in SavedVariables")
assert_eq(COB.Announce:IsEnabled(), true, "announce reads enabled by default")
ChurchOfBeefDB.ui.announce = nil
assert_eq(COB.Announce:IsEnabled(), true, "an unset announce preference still announces")
ChurchOfBeefDB.ui.announce = true

stub.guildRankIndex = nil -- roster has not answered yet: fail closed
local frame = COB.UI:Init()
assert_true(frame ~= nil, "main frame built")
assert_true(Tab.approve ~= nil, "officer panel built even while the tab is hidden")
assert_true(Tab.announceCheck ~= nil, "announce checkbox lives on the Officer tab")
assert_eq(Tab.announceLabel:GetText(), "Announce promotions to guild chat",
  "COB_OPT_ANNOUNCE label is the locked procedural copy")

--------------------------------------------------------------------------------
-- A non-officer cannot commit, even by calling the tab directly
--------------------------------------------------------------------------------
crossThreshold("Beefina")
assert_eq(#COB.Ladder:GetSuggestions(), 1, "crossing a threshold queues one petition")

assert_eq(Tab:Approve("Beefina"), false, "non-officer approve refused")
assert_eq(rankOf("Beefina"), 1, "refused approve committed nothing")
assert_eq(chatCount(), 0, "refused approve said nothing in guild chat")
assert_eq(Tab.statusText, "you are not an officer of this guild", "refusal names the cause")

--------------------------------------------------------------------------------
-- Officer+ sees the queue and the evidence for the auto-selected petition
--------------------------------------------------------------------------------
stub.guildRankIndex = 0
COB.UI:Show()
assert_eq(COB.UI:ShowTab("officer"), "officer", "officer tab activates")
refreshOfficer()

assert_eq(Tab.selected, "Beefina", "oldest petition auto-selected")
assert_eq(Tab.subject:GetText(), "Beefina", "selection fills the rite subject")
assert_true(Tab.rows[1].label:GetText():find("Beefina", 1, true) ~= nil, "queue row names the petitioner")
assert_true(Tab.rows[1].label:GetText():find("Cooked Beef", 1, true) ~= nil, "queue row names the target rank")
assert_eq(Tab.rows[2].frame:IsShown(), false, "unused queue rows hide")

assert_eq(Tab.evName:GetText(), "Beefina", "evidence names the player")
assert_eq(Tab.evDelta:GetText(), "Fresh Beef → Cooked Beef", "evidence shows the rank delta")
assert_eq(Tab.evStanding:GetText(), "Standing 50 / 50 (threshold)", "evidence shows standing vs threshold")
assert_true(Tab.evBreakdown:GetText():find("gora 50", 1, true) ~= nil, "evidence breaks points down by source")
assert_true(Tab.evEvents[1]:GetText():find("+25 gora", 1, true) ~= nil, "evidence lists recent events")
assert_eq(Tab.approve:GetText(), "Approve: Cooked Beef", "approve names the destination rank")

--------------------------------------------------------------------------------
-- Approve: Commit → (Net) → Announce, no modal
--------------------------------------------------------------------------------
-- Replication is best effort; the commit is local truth. Approve must still work on
-- a client where BeefNet failed to load at all.
local realNet = COB.Net
COB.Net = nil
assert_eq(COB.Net, nil, "approve must tolerate a missing Net")
assert_true(stub.fire(Tab.approve, "OnClick"), "approve button wired")

assert_eq(rankOf("Beefina"), 2, "approve commits the suggested rank")
assert_eq(COB.Ladder:GetRecord("Beefina").revision, 1, "approve bumps the revision")
assert_eq(COB.Ladder:GetRecord("Beefina").standing, 50, "approve leaves earned standing alone")
assert_eq(#COB.Ladder:GetSuggestions(), 0, "approve clears the petition")
assert_eq(lastChat(), "The Church recognizes Beefina, elevated to Cooked Beef.",
  "COB_ANNOUNCE_PROMOTE liturgy sent to guild chat")
assert_eq(stub.chat[1].channel, "GUILD", "announce goes to GUILD")
assert_eq(COB.Toasts.frame.text:GetText(), "Elevated: Beefina → Cooked Beef", "outcome toasted privately")
assert_true(Tab.recentLines[1]:GetText():find("Elevated Beefina", 1, true) ~= nil, "recent actions logged")
assert_eq(Tab.overflow:GetText(), "No pending suggestions.", "COB_EMPTY_NO_SUGGESTIONS after the queue drains")
assert_eq(Tab.evName:GetText(), "No petition selected", "evidence clears with the queue")

--------------------------------------------------------------------------------
-- Approve replicates through Net once BeefNet exists (Task 12)
--------------------------------------------------------------------------------
local sent = {}
COB.Net = { SendRankCommit = function(_, record) sent[#sent + 1] = record end }

--------------------------------------------------------------------------------
-- Announce opt-out silences guild chat without touching the commit
--------------------------------------------------------------------------------
Tab.announceCheck:SetChecked(false) -- the client flips the box before OnClick
assert_true(stub.fire(Tab.announceCheck, "OnClick"), "announce checkbox wired")
assert_eq(ChurchOfBeefDB.ui.announce, false, "unchecking mirrors into SavedVariables")

crossThreshold("Steakina")
refreshOfficer()
assert_eq(Tab.selected, "Steakina", "next petition auto-selected")
local before = chatCount()
stub.fire(Tab.approve, "OnClick")
assert_eq(rankOf("Steakina"), 2, "opt-out still commits the rank")
assert_eq(chatCount(), before, "opt-out sends no guild line")
assert_eq(#sent, 1, "commit handed to Net for replication")
assert_eq(sent[1].name, "Steakina", "the replicated record is the committed one")

Tab.announceCheck:SetChecked(true)
stub.fire(Tab.announceCheck, "OnClick")
assert_eq(ChurchOfBeefDB.ui.announce, true, "re-checking restores the spectacle")

--------------------------------------------------------------------------------
-- Reject clears the petition, keeps the points, and stays out of guild chat
--------------------------------------------------------------------------------
crossThreshold("Chuckina")
refreshOfficer()
assert_eq(Tab.selected, "Chuckina", "rejectable petition selected")
before = chatCount()
assert_true(stub.fire(Tab.reject, "OnClick"), "reject button wired")
assert_eq(#COB.Ladder:GetSuggestions(), 0, "reject clears the petition")
assert_eq(rankOf("Chuckina"), 1, "reject commits no rank")
assert_eq(COB.Ladder:GetRecord("Chuckina").standing, 50, "reject leaves standing intact")
assert_eq(chatCount(), before, "rejection is officer process, not spectacle")
assert_true(Tab.statusText:find("keeps their standing", 1, true) ~= nil, "reject copy says points remain")

--------------------------------------------------------------------------------
-- Demote goes through the confirm frame and announces the fall
--------------------------------------------------------------------------------
Tab.subject:SetText("Beefina")
assert_eq(Tab.demoteRankId, 1, "demote stepper starts at the lowest point rank")
assert_true(stub.fire(Tab.excommunicate, "OnClick"), "excommunicate button wired")
assert_eq(Tab.confirm:IsShown(), true, "demote opens a confirm before committing")
assert_true(Tab.confirm.body:GetText():find("Beefina", 1, true) ~= nil, "confirm names the subject")
assert_true(Tab.confirm.body:GetText():find("Fresh Beef", 1, true) ~= nil, "confirm names the consequence")
assert_eq(rankOf("Beefina"), 2, "showing the confirm commits nothing")

stub.fire(Tab.confirm.cancel, "OnClick")
assert_eq(Tab.confirm:IsShown(), false, "cancel closes the confirm")
assert_eq(rankOf("Beefina"), 2, "cancel commits nothing")

stub.fire(Tab.excommunicate, "OnClick")
stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(rankOf("Beefina"), 1, "accepting the confirm demotes")
assert_eq(lastChat(), "The Church records the fall of Beefina, returned to Fresh Beef.",
  "COB_ANNOUNCE_DEMOTE liturgy sent")

--------------------------------------------------------------------------------
-- Council seats are limited; the fifth appointment fails visibly
--------------------------------------------------------------------------------
local seats = COB.Ranks.CouncilSeats
for i = 1, seats do
  assert_true(COB.Ladder:AppointCouncil("Councillor" .. i, "Popeina") ~= nil, "seat filled")
end

Tab.subject:SetText("Fifthina")
stub.fire(Tab.council, "OnClick")
assert_true(Tab.confirm.body:GetText():find("seats filled", 1, true) ~= nil, "confirm reports seat usage")
before = chatCount()
stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(rankOf("Fifthina"), 1, "the fifth councillor is not seated")
assert_true(Tab.statusText:find("full", 1, true) ~= nil, "seat refusal is visible on the tab")
assert_true(Tab.status:GetText():find("Refused", 1, true) ~= nil, "refusal is dual-encoded with a word")
assert_eq(chatCount(), before, "a refused rite announces nothing")

--------------------------------------------------------------------------------
-- The Prophet is unique; a second bestowal fails visibly
--------------------------------------------------------------------------------
Tab.subject:SetText("Prophetina")
stub.fire(Tab.prophet, "OnClick")
stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(rankOf("Prophetina"), 7, "the first Prophet is anointed")
assert_eq(lastChat(), "The Church anoints Prophetina as Beef Prophet.", "COB_ANNOUNCE_PROPHET liturgy sent")

Tab.subject:SetText("Falseina")
stub.fire(Tab.prophet, "OnClick")
before = chatCount()
stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(rankOf("Falseina"), 1, "a second Prophet is refused")
assert_true(Tab.statusText:find("already lives", 1, true) ~= nil, "prophet refusal is visible on the tab")
assert_eq(chatCount(), before, "a refused bestowal announces nothing")

--------------------------------------------------------------------------------
-- Seating a Councillor announces the office, not a point threshold
--------------------------------------------------------------------------------
COB.Ladder:Demote("Councillor1", 1, "Popeina")
Tab.subject:SetText("Councillor1")
stub.fire(Tab.council, "OnClick")
stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(lastChat(), "The Church seats Councillor1 upon the Beef Council.",
  "COB_ANNOUNCE_COUNCIL liturgy sent")

--------------------------------------------------------------------------------
-- Standing correction is committed, silent, and confirms only on a wipe
--------------------------------------------------------------------------------
Tab.subject:SetText("Chuckina")
Tab.standingDelta:SetText("25")
before = chatCount()
assert_true(stub.fire(Tab.applyStanding, "OnClick"), "correct button wired")
assert_eq(COB.Ladder:GetRecord("Chuckina").standing, 75, "a small correction applies directly")
assert_eq(Tab.confirm:IsShown(), false, "a small correction needs no confirm")
assert_eq(chatCount(), before, "standing corrections are not announced")

Tab.standingDelta:SetText("-500")
stub.fire(Tab.applyStanding, "OnClick")
assert_eq(Tab.confirm:IsShown(), true, "a wipe opens a confirm")
assert_eq(COB.Ladder:GetRecord("Chuckina").standing, 75, "the wipe has not landed yet")
stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(COB.Ladder:GetRecord("Chuckina").standing, 0, "the wipe clamps at zero")
assert_eq(rankOf("Chuckina"), 1, "a wipe does not change rank")

Tab.standingDelta:SetText("beef")
stub.fire(Tab.applyStanding, "OnClick")
assert_true(Tab.statusText:find("25 or -50", 1, true) ~= nil, "a bad correction explains the format")

--------------------------------------------------------------------------------
-- A rite cannot conjure a ghost: GetRecord's synthetic Fresh Beef is not evidence
--------------------------------------------------------------------------------
assert_eq(COB.Ladder:HasOfficialRecord("Ghostina"), false, "an unknown name has no official record")
assert_eq(COB.Ladder:GetRecord("Ghostina").rankId, 1, "but GetRecord still answers Fresh Beef")
assert_eq(COB.Officer:IsGuildRosterName("Ghostina"), false, "and the roster does not know them either")
assert_eq(COB.Officer:IsGuildRosterName("Steakina"), true, "a roster entry matches without its realm suffix")

assert_eq(Tab:AppointCouncil("Ghostina"), false, "a ghost cannot be seated on the Council")
assert_true(Tab.statusText:find("guild roster", 1, true) ~= nil, "the refusal names the missing subject")
assert_eq(COB.Ladder:HasOfficialRecord("Ghostina"), false, "the refused seating wrote no record")

assert_eq(Tab:BestowProphet("Ghostina"), false, "a ghost cannot be anointed")
assert_eq(Tab:CorrectStanding("Ghostina", 25), false, "a ghost cannot be given standing")
assert_eq(COB.Ladder:HasOfficialRecord("Ghostina"), false, "no refused rite left a ladder occupant")

before = chatCount()
Tab.subject:SetText("Ghostina")
stub.fire(Tab.excommunicate, "OnClick")
stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(COB.Ladder:HasOfficialRecord("Ghostina"), false, "excommunicating a ghost writes nothing")
assert_eq(chatCount(), before, "a refused rite announces nothing")

Tab.standingDelta:SetText("25")
stub.fire(Tab.applyStanding, "OnClick")
assert_eq(COB.Ladder:HasOfficialRecord("Ghostina"), false, "correcting a ghost writes nothing")

--------------------------------------------------------------------------------
-- Confirm frame: reason is kept, Escape backs out, a missing frame fails closed
--------------------------------------------------------------------------------
Tab.subject:SetText("Chuckina")
Tab.standingDelta:SetText("60")
stub.fire(Tab.applyStanding, "OnClick")
assert_eq(COB.Ladder:GetRecord("Chuckina").standing, 60, "Chuckina has standing to wipe again")

Tab.subject:SetText("Chuckina")
Tab.standingDelta:SetText("-100")
stub.fire(Tab.applyStanding, "OnClick")
assert_eq(Tab.confirm:IsShown(), true, "the wipe confirm is open")
assert_true(stub.fire(Tab.confirm, "OnKeyDown", "ESCAPE"), "the confirm listens for keys")
assert_eq(Tab.confirm:IsShown(), false, "escape closes the confirm")
-- rawget: the widget stub hands back a no-op for any unset field, so read past it.
assert_eq(rawget(Tab.confirm, "onAccept"), nil, "escape drops the pending rite")
assert_eq(COB.Ladder:GetRecord("Chuckina").standing, 60, "escape commits nothing")

stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(COB.Ladder:GetRecord("Chuckina").standing, 60, "a stale accept after escape does nothing")

Tab.subject:SetText("Chuckina")
stub.fire(Tab.applyStanding, "OnClick")
Tab.confirm.reason:SetText("  double-dipped the gora  ")
stub.fire(Tab.confirm.accept, "OnClick")
assert_eq(COB.Ladder:GetRecord("Chuckina").standing, 0, "the confirmed wipe lands")
assert_true(Tab.recentLines[1]:GetText():find("Corrected Chuckina", 1, true) ~= nil,
  "the wipe is logged in recent actions")
assert_true(Tab.recentLines[1]:GetText():find("double-dipped the gora", 1, true) ~= nil,
  "the typed reason rides along with the recent entry")

Tab.subject:SetText("Chuckina")
Tab.standingDelta:SetText("15")
stub.fire(Tab.applyStanding, "OnClick")
assert_eq(Tab.recentLines[1]:GetText():find("double-dipped", 1, true), nil,
  "the reason is consumed once and does not stick to the next rite")

local realConfirm = Tab.confirm
Tab.confirm = nil
Tab.subject:SetText("Chuckina")
stub.fire(Tab.excommunicate, "OnClick")
assert_true(Tab.statusText:find("confirmation window is missing", 1, true) ~= nil,
  "a missing confirm frame fails closed instead of committing")
assert_eq(rankOf("Chuckina"), 1, "the unconfirmable rite committed nothing")
Tab.confirm = realConfirm

--------------------------------------------------------------------------------
-- The officer queue never sits stale behind a refresh it should have seen
--------------------------------------------------------------------------------
assert_eq(COB.UI:ShowTab("officer"), "officer", "officer tab is up front")
Tab.overflow:SetText("STALE")
crossThreshold("Brisketina") -- Core only: scoring does not touch the UI
COB.UI:RefreshLadder()
assert_true(Tab.overflow:GetText() ~= "STALE", "RefreshLadder redraws the officer queue too")
assert_eq(Tab.selected, "Brisketina", "the new petition is selected and visible")

assert_eq(COB.UI:ShowTab("ladder"), "ladder", "switch away from the officer tab")
Tab.overflow:SetText("STALE")
crossThreshold("Rumpina")
assert_eq(Tab.overflow:GetText(), "STALE", "a hidden officer tab stays idle")
assert_eq(COB.UI:ShowTab("officer"), "officer", "and comes back to the front")
assert_true(Tab.overflow:GetText() ~= "STALE", "returning to a tab redraws it")
assert_eq(#COB.Ladder:GetSuggestions(), 2, "both petitions are queued")

--------------------------------------------------------------------------------
-- Announce refusals in their own right
--------------------------------------------------------------------------------
COB.Announce:ResetForTests()
assert_eq(select(1, COB.Announce:Promotion("Beefina", "Beef Knight")), true, "officer may announce")
assert_eq(select(1, COB.Announce:Promotion("Beefina", "Beef Knight")), false,
  "an identical line inside the throttle window is dropped")
stub.now = stub.now + 60
assert_eq(select(1, COB.Announce:Promotion("Beefina", "Beef Knight")), true,
  "the same line is allowed again once the window passes")

stub.guildRankIndex = 5
assert_eq(select(1, COB.Announce:Promotion("Lurkina", "Beef Knight")), false, "a member never announces")
stub.guildRankIndex = 0

stub.inGuild = false
assert_eq(select(1, COB.Announce:Promotion("Lurkina", "Beef Knight")), false, "no guild, no liturgy")
stub.inGuild = true

COB.Announce:SetEnabled(false)
assert_eq(select(1, COB.Announce:Promotion("Lurkina", "Beef Knight")), false, "opt-out silences the module")
COB.Announce:SetEnabled(true)

assert_eq(select(1, COB.Announce:Promotion("", "Beef Knight")), false, "an empty name never reaches chat")
assert_eq(select(1, COB.Announce:Promotion("Lurkina", nil)), false, "a missing title never reaches chat")

COB.Net = realNet
restore()
