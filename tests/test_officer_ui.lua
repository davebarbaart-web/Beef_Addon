-- Officer tab: promote prompts + dismiss + standing correction (roster-backed).
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
dofile("addon/ChurchOfBeef/Core/Roster.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")
dofile("addon/ChurchOfBeef/UI/MainFrame.lua")
dofile("addon/ChurchOfBeef/UI/Status.lua")
dofile("addon/ChurchOfBeef/UI/Announce.lua")
dofile("addon/ChurchOfBeef/UI/Toasts.lua")
dofile("addon/ChurchOfBeef/UI/LadderTab.lua")
dofile("addon/ChurchOfBeef/UI/StandingTab.lua")
dofile("addon/ChurchOfBeef/UI/OfficerTab.lua")

local COB = ChurchOfBeef
local Tab = COB.OfficerTab

ChurchOfBeefDB = nil
COB.DB:Init()

stub.playerName = "Popeina"
stub.guildRankIndex = 0
stub.guildRoster = {
  { name = "Popeina", rankIndex = 0 },
  { name = "Beefina", rankIndex = 6 },
  { name = "Steakina-Nightslayer", rankIndex = 6 },
}

local function refreshRoster()
  COB.Roster:Refresh()
end

local function crossThreshold(name)
  COB.Scoring:GrantGora(name, "win")
  COB.Scoring:GrantGora(name, "win")
end

local function refreshOfficer()
  COB.UI:MarkDirty("officer")
end

refreshRoster()
local frame = COB.UI:Init()
assert_true(frame ~= nil, "main frame built")
assert_true(Tab.dismiss ~= nil, "dismiss button built")
assert_true(Tab.announceCheck ~= nil, "announce checkbox widget retained (hidden)")
assert_eq(Tab.announceCheck:IsShown(), false, "announce checkbox hidden until roster-diff announcer")

--------------------------------------------------------------------------------
-- Non-officer cannot dismiss
--------------------------------------------------------------------------------
stub.guildRankIndex = nil
crossThreshold("Beefina")
assert_eq(#COB.Ladder:GetSuggestions(), 1, "crossing a threshold queues one petition")

assert_eq(Tab:Dismiss("Beefina"), false, "non-officer dismiss refused")
assert_eq(#COB.Ladder:GetSuggestions(), 1, "refused dismiss left the petition")
assert_eq(Tab.statusText, "you are not an officer of this guild", "refusal names the cause")

--------------------------------------------------------------------------------
-- Officer sees queue + promote-in-guild copy
--------------------------------------------------------------------------------
stub.guildRankIndex = 0
refreshRoster()
COB.UI:Show()
assert_eq(COB.UI:ShowTab("officer"), "officer", "officer tab activates")
refreshOfficer()

assert_eq(Tab.selected, "Beefina", "oldest petition auto-selected")
assert_true(Tab.rows[1].label:GetText():find("Beefina", 1, true) ~= nil, "queue row names the petitioner")
assert_true(Tab.rows[1].label:GetText():find("Cooked Beef", 1, true) ~= nil, "queue row names the target rank")
assert_eq(Tab.evName:GetText(), "Beefina", "evidence names the player")
assert_eq(Tab.evDelta:GetText(), "Fresh Beef → Cooked Beef", "evidence shows the rank delta")
assert_true(Tab.evPreview:GetText():find("guild roster", 1, true) ~= nil,
  "preview tells the officer to promote in the guild roster")
assert_eq(Tab.evStanding:GetText(), "Standing 50 / 50 (threshold)", "evidence shows standing vs threshold")
assert_eq(Tab.evRite:GetText(), "", "Cooked Beef has no rite checklist line")
assert_eq(Tab.evFooter:GetText(), "Beef Council seats are appointed by the Beef Prophet.",
  "soft Council policy footer is always shown")
assert_true(Tab.evBreakdown:GetText():find("gora", 1, true) ~= nil, "breakdown lists gora standing")

--------------------------------------------------------------------------------
-- Dismiss clears the prompt without changing mapped rank
--------------------------------------------------------------------------------
assert_true(stub.fire(Tab.dismiss, "OnClick"), "dismiss button wired")
assert_eq(#COB.Ladder:GetSuggestions(), 0, "dismiss clears the petition")
assert_eq(COB.Ladder:GetStanding("Beefina"), 50, "dismiss leaves standing")
assert_eq(COB.Roster:GetChurchRankId("Beefina"), 1, "dismiss does not change roster map")
assert_eq(Tab.overflow:GetText(), "No pending suggestions.", "empty copy after drain")
assert_eq(Tab.evFooter:GetText(), "Beef Council seats are appointed by the Beef Prophet.",
  "Council footer remains after queue drains")

--------------------------------------------------------------------------------
-- Standing correction adjusts points only
--------------------------------------------------------------------------------
assert_eq(Tab:CorrectStanding("Beefina", 25), true, "correction applies")
assert_eq(COB.Ladder:GetStanding("Beefina"), 75, "standing corrected")
assert_eq(COB.Roster:GetChurchRankId("Beefina"), 1, "correction does not invent a Church rank")

assert_eq(Tab:CorrectStanding("Ghostina", 10), false, "ghost correction refused")
assert_true(Tab.statusText:find("guild roster", 1, true) ~= nil, "refusal names the missing subject")

--------------------------------------------------------------------------------
-- Knight / Lord eligibility checklist (coach, not hard-block)
--------------------------------------------------------------------------------
-- CorrectStanding above may have re-queued Beefina; clear before rite cases.
COB.Ladder:RejectSuggestion("Beefina")

stub.guildRoster = {
  { name = "Popeina", rankIndex = 0 },
  { name = "Squire", rankIndex = 5 }, -- Cooked Beef → next is Knight
  { name = "Challenger", rankIndex = 4 }, -- Knight → next is Lord
}
refreshRoster()

COB.Ladder:SetStanding("Squire", 200)
COB.Ladder:MaybeSuggest("Squire")
COB.Scoring:GrantQuestBucket("Squire", 1000, true)
Tab.selected = "Squire"
if Tab.subject then Tab.subject:SetText("Squire") end
refreshOfficer()

assert_eq(Tab.evStanding:GetText(), "Standing 203 / 200 (threshold)", "Knight evidence keeps standing line")
assert_eq(Tab.evRite:GetText(), "Rite: Knighting — not yet", "Knight evidence shows unmet rite")
assert_true(Tab.rows[1].label:GetText():find("(!)", 1, true) ~= nil, "queue marks unmet rite")
assert_true(Tab.evBreakdown:GetText():find("quest", 1, true) ~= nil, "breakdown includes quest")

COB.Ladder:SetRiteFlag("Squire", "knighted", true)
refreshOfficer()
assert_eq(Tab.evRite:GetText(), "Rite: Knighting — met", "Knight evidence flips when knighted")
assert_eq(Tab.rows[1].label:GetText():find("(!)", 1, true), nil, "met rite drops queue warning")

COB.Ladder:RejectSuggestion("Squire")
COB.Ladder:SetStanding("Challenger", 500)
COB.Ladder:MaybeSuggest("Challenger")
Tab.selected = "Challenger"
if Tab.subject then Tab.subject:SetText("Challenger") end
refreshOfficer()
assert_eq(Tab.evRite:GetText(), "Rite: Gora win vs Lord — not yet", "Lord evidence shows Gora rite")

--------------------------------------------------------------------------------
-- Ladder view shows real roster bands (GM → Prophet)
--------------------------------------------------------------------------------
COB.UI:ShowTab("ladder")
local ladder = COB.LadderTab
assert_true(ladder.rows[1].title:GetText():find("Prophet", 1, true) ~= nil, "top band is Prophet")
assert_true(ladder.rows[1].occupants:GetText():find("Popeina", 1, true) ~= nil, "GM listed under Prophet")

restore()
