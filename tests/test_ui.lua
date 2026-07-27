-- UI shell: frame creation, tab gating, saved position, minimap toggle, toasts.
-- Widget behaviour comes from tests/wow_ui_stub.lua; this is a construction and
-- wiring check, not a substitute for an in-game smoke test.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Ladder.lua")
dofile("addon/ChurchOfBeef/Core/Scoring.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
dofile("addon/ChurchOfBeef/Core/Roster.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local COB = ChurchOfBeef

-- TOC order: MainFrame owns COB.UI, tab files register into it on load.
local function loadUi()
  dofile("addon/ChurchOfBeef/UI/MainFrame.lua")
  dofile("addon/ChurchOfBeef/UI/Status.lua")
  dofile("addon/ChurchOfBeef/UI/Announce.lua")
  dofile("addon/ChurchOfBeef/UI/LadderTab.lua")
  dofile("addon/ChurchOfBeef/UI/StandingTab.lua")
  dofile("addon/ChurchOfBeef/UI/OfficerTab.lua")
  dofile("addon/ChurchOfBeef/UI/Minimap.lua")
  dofile("addon/ChurchOfBeef/UI/Toasts.lua")
end

COB.Ladder:ResetForTests()
COB.Scoring:ResetForTests()
ChurchOfBeefDB = nil
COB.DB:Init()

loadUi()

--------------------------------------------------------------------------------
-- Tabs register on load, in TOC order
--------------------------------------------------------------------------------
local names = COB.UI:GetTabNames()
assert_eq(#names, 3, "three tabs registered")
assert_eq(names[1], "ladder", "ladder registers first")
assert_eq(names[2], "standing", "standing registers second")
assert_eq(names[3], "officer", "officer registers third")

assert_eq(select(1, COB.UI:RegisterTab({ name = "ladder", label = "Dupe" })), nil, "duplicate tab refused")
assert_eq(select(1, COB.UI:RegisterTab({ label = "No name" })), nil, "unnamed tab refused")

--------------------------------------------------------------------------------
-- Init builds a hidden, movable, clamped frame
--------------------------------------------------------------------------------
stub.guildRankIndex = nil -- roster not answered yet: fail closed
local frame = COB.UI:Init()
assert_true(frame ~= nil, "Init creates the main frame")
assert_eq(frame:GetName(), "ChurchOfBeefFrame", "frame has a global name for UISpecialFrames")
assert_eq(frame._template, "BasicFrameTemplate", "shell inherits BasicFrameTemplate")
assert_true(frame.TitleText ~= nil, "BasicFrame TitleText present")
assert_eq(UISpecialFrames[1], "ChurchOfBeefFrame", "escape closes the frame")
assert_eq(COB.UI:IsShown(), false, "frame starts hidden")
assert_eq(COB.UI:Init(), frame, "Init is idempotent")
assert_eq(frame._movable, true, "frame is movable")
assert_eq(frame._clamped, true, "frame is clamped to screen")
assert_true(frame.FooterText ~= nil, "scripture footer placeholder exists")
assert_true(frame.StatusChip ~= nil, "L0 mesh status chip exists on main frame")
assert_true(COB.UI.Status ~= nil, "UI.Status presenter loaded")

local point, _, relativePoint, x, y = frame:GetPoint(1)
assert_eq(point, "CENTER", "unsaved position defaults to center")
assert_eq(relativePoint, "CENTER", "default relative anchor is center")
assert_eq(x, 0, "default x offset")
assert_eq(y, 0, "default y offset")

--------------------------------------------------------------------------------
-- Officer tab is hidden until the roster says Officer+
--------------------------------------------------------------------------------
local function buttonFor(label)
  return stub.findChild(frame, function(child)
    return child._type == "Button" and child:GetText() == label
  end)
end

assert_true(buttonFor("Ladder") ~= nil, "ladder tab button exists")
assert_eq(buttonFor("Ladder"):IsShown(), true, "ladder tab button visible")
assert_eq(buttonFor("My Standing"):IsShown(), true, "standing tab button visible")
assert_eq(buttonFor("Officer"):IsShown(), false, "non-officer does not see the Officer tab")
assert_eq(COB.UI.activeTab, "ladder", "first visible tab is active")
assert_eq(COB.UI:ShowTab("officer"), "ladder", "asking for a hidden tab falls back")

--------------------------------------------------------------------------------
-- Toggle shows/hides and records the state in SV
--------------------------------------------------------------------------------
COB.UI:Toggle()
assert_eq(COB.UI:IsShown(), true, "toggle opens the frame")
assert_eq(ChurchOfBeefDB.ui.shown, true, "open state persisted")

assert_eq(COB.UI:ShowTab("standing"), "standing", "standing tab activates")
assert_eq(buttonFor("My Standing")._highlighted, true, "active tab button is highlighted")
assert_eq(buttonFor("Ladder")._highlighted, false, "inactive tab button is not highlighted")

COB.UI:Toggle()
assert_eq(COB.UI:IsShown(), false, "toggle closes the frame")
assert_eq(ChurchOfBeefDB.ui.shown, false, "closed state persisted")

-- Escape via UISpecialFrames hides the frame without going through UI:Hide.
COB.UI:Show()
assert_eq(ChurchOfBeefDB.ui.shown, true, "Show persists the open state")
frame:Hide()
assert_eq(ChurchOfBeefDB.ui.shown, false, "an escape-key close still persists")

--------------------------------------------------------------------------------
-- Roster answering Officer+ reveals the tab without a reload
--------------------------------------------------------------------------------
stub.guildRankIndex = 0
assert_true(stub.fire(frame, "OnEvent", "GUILD_ROSTER_UPDATE"), "guild roster event handled")
assert_eq(buttonFor("Officer"):IsShown(), true, "officer sees the Officer tab")
assert_eq(COB.UI:ShowTab("officer"), "officer", "officer tab activates")

stub.guildRankIndex = 5
assert_true(stub.fire(frame, "OnEvent", "PLAYER_GUILD_UPDATE"), "guild update handled")
assert_eq(buttonFor("Officer"):IsShown(), false, "demoted player loses the Officer tab")
assert_eq(COB.UI.activeTab, "ladder", "hidden active tab falls back to ladder")

--------------------------------------------------------------------------------
-- Dragging the title bar saves the anchor into ChurchOfBeefDB.ui.point
--------------------------------------------------------------------------------
local titleBar = stub.findChild(frame, function(child)
  return child._scripts and child._scripts.OnDragStop ~= nil
end)
assert_true(titleBar ~= nil, "title bar is the drag handle")
assert_true(titleBar._scripts.OnDragStart ~= nil, "drag start wired")

stub.fire(titleBar, "OnDragStart")
assert_eq(frame._moving, true, "dragging the title bar moves the frame")

frame:ClearAllPoints()
frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 120, -80)
stub.fire(titleBar, "OnDragStop")
assert_eq(frame._moving, false, "drop stops the move")

local saved = ChurchOfBeefDB.ui.point
assert_true(type(saved) == "table", "position saved as a table")
assert_eq(saved.point, "TOPLEFT", "anchor point saved")
assert_eq(saved.relativePoint, "TOPLEFT", "relative anchor saved")
assert_eq(saved.x, 120, "x offset saved")
assert_eq(saved.y, -80, "y offset saved")
assert_eq(saved.relativeTo, nil, "no frame reference lands in SavedVariables")

--------------------------------------------------------------------------------
-- Reload restores position and open state
--------------------------------------------------------------------------------
ChurchOfBeefDB.ui.shown = true
loadUi() -- fresh COB.UI, as a /reload would produce
local reloaded = COB.UI:Init()
local rp, _, rrp, rx, ry = reloaded:GetPoint(1)
assert_eq(rp, "TOPLEFT", "saved anchor restored after reload")
assert_eq(rrp, "TOPLEFT", "saved relative anchor restored")
assert_eq(rx, 120, "saved x restored")
assert_eq(ry, -80, "saved y restored")
assert_eq(COB.UI:IsShown(), true, "frame reopens when it was open at logout")

-- A corrupt anchor must not brick /beef.
ChurchOfBeefDB.ui.point = { point = "MIDDLE-OF-NOWHERE", relativePoint = "CENTER", x = 1, y = 2 }
loadUi()
local safe = COB.UI:Init()
assert_eq(select(1, safe:GetPoint(1)), "CENTER", "invalid saved anchor falls back to center")
ChurchOfBeefDB.ui.point = saved

--------------------------------------------------------------------------------
-- Minimap button toggles the same frame
--------------------------------------------------------------------------------
local button = COB.Minimap.button
assert_true(button ~= nil, "minimap button created during UI Init")
assert_eq(button:GetName(), "ChurchOfBeefMinimapButton", "minimap button is named")
local wasShown = COB.UI:IsShown()
stub.fire(button, "OnClick")
assert_eq(COB.UI:IsShown(), not wasShown, "minimap click toggles the frame")
stub.fire(button, "OnClick")
assert_eq(COB.UI:IsShown(), wasShown, "minimap click toggles back")

COB.Minimap:SetShown(false)
assert_eq(button:IsShown(), false, "minimap button can be hidden")
assert_eq(ChurchOfBeefDB.ui.minimapHide, true, "hidden minimap preference persisted")
COB.Minimap:SetShown(true)
assert_eq(button:IsShown(), true, "minimap button can come back")

--------------------------------------------------------------------------------
-- Toasts queue and expire without a permanent OnUpdate
--------------------------------------------------------------------------------
assert_eq(COB.Toasts:Show(""), false, "empty toast refused")
assert_eq(COB.Toasts:Show(nil), false, "nil toast refused")
assert_eq(COB.Toasts:Show("Beefina is now Cooked Beef."), true, "toast accepted")
assert_eq(COB.Toasts.frame:IsShown(), true, "toast frame shown")
assert_eq(COB.Toasts.frame.text:GetText(), "Beefina is now Cooked Beef.", "toast text set")

assert_eq(COB.Toasts:Show("The Prophet has spoken."), true, "second toast queued")
assert_eq(COB.Toasts.frame.text:GetText(), "Beefina is now Cooked Beef.", "queued toast waits its turn")
stub.flushTimers()
assert_eq(COB.Toasts.frame.text:GetText(), "The Prophet has spoken.", "queue advances on expiry")
assert_eq(COB.Toasts.frame:IsShown(), true, "second toast visible")
stub.flushTimers()
assert_eq(COB.Toasts.frame:IsShown(), false, "toast hides when the queue drains")

--------------------------------------------------------------------------------
-- Toast priority / dedupe / Celebrate (V1 edge toast polish)
--------------------------------------------------------------------------------
COB.Toasts:ResetForTests()
assert_eq(COB.Toasts:Push({ kind = "credit", text = "Gora win: +8 standing" }), true, "credit accepted")
assert_eq(COB.Toasts:ShowingKind(), "credit", "showing credit")
assert_eq(COB.Toasts:Celebrate("promote", {
  name = "Beefina", title = "Cooked Beef", dedupeKey = "promote:Beefina:2",
}), true, "promote accepted")
assert_eq(COB.Toasts:ShowingKind(), "promote", "promote interrupts credit")
assert_eq(COB.Toasts.frame.text:GetText(), "Beefina is now Cooked Beef.", "promote copy")
local dupOk, dupReason = COB.Toasts:Celebrate("promote", {
  name = "Beefina", title = "Cooked Beef", dedupeKey = "promote:Beefina:2",
})
assert_eq(dupOk, false, "duplicate promote deduped")
assert_eq(dupReason, "deduped", "dedupe reason")
COB.Toasts:HideAll()
assert_eq(COB.Toasts:PendingCount(), 0, "HideAll clears pending")
assert_eq(COB.Toasts:ShowingKind(), nil, "HideAll clears showing")

-- Regression: wow_ui_stub __index-caches noops; cobFadeIn must not look Play()-able.
COB.Toasts:ResetForTests()
local wasTest = COB._IN_TEST
COB._IN_TEST = false
assert_eq(COB.Toasts:Push({ kind = "system", text = "motion fallback ok" }), true,
  "toast works when AnimationGroup is absent")
assert_eq(rawget(COB.Toasts.frame, "cobFadeIn"), nil, "cobFadeIn not stored as stub noop")
assert_eq(COB.Toasts.frame:IsShown(), true, "C_Timer fade path still shows toast")
stub.flushTimers()
COB._IN_TEST = wasTest
COB.Toasts:ResetForTests()

--------------------------------------------------------------------------------
-- Ladder / Standing tabs read roster + standing (text thresholds; no StatusBar)
--------------------------------------------------------------------------------
COB.Ladder:ResetForTests()
COB.Scoring:ResetForTests()
COB.Roster:ResetForTests()
stub.playerName = "Beefina"
stub.guildRoster = {
  { name = "Popeina", rankIndex = 0 },
  { name = "Beefina", rankIndex = 5 }, -- Cooked Beef via guild map
}
stub.guildRankIndex = 5
COB.Roster:Refresh()
COB.Ladder:SetStanding("Beefina", 75)

COB.UI:Show()
COB.UI:ShowTab("ladder")
COB.UI:MarkDirty("ladder")
assert_eq(COB.UI.activeTab, "ladder", "ladder tab active for refresh")
assert_true(COB.LadderTab.rows ~= nil and #COB.LadderTab.rows == 7, "seven ladder rows")
assert_eq(COB.LadderTab.rows[1].title:GetText(), "Beef Prophet", "top row is Prophet")
assert_eq(COB.LadderTab.rows[7].title:GetText(), "Fresh Beef", "bottom row is Fresh Beef")
-- Cooked Beef is rank 2 → display index 6 (7 - 2 + 1)
local cooked = COB.LadderTab.rows[6]
assert_eq(cooked.title:GetText():find("Cooked Beef", 1, true) ~= nil, true, "Cooked Beef title shown")
assert_eq(cooked.occupants:GetText():find("Beefina", 1, true) ~= nil, true, "occupant listed")
assert_eq(cooked.occupants:GetText():find("(You)", 1, true) ~= nil, true, "self dual-encoded as You")
assert_true(COB.LadderTab.rows[1].occupants:GetText():find("Popeina", 1, true) ~= nil,
  "GM listed under Prophet from roster")

COB.UI:ShowTab("standing")
COB.UI:MarkDirty("standing")
assert_eq(COB.StandingTab.header:GetText():find("Cooked Beef", 1, true) ~= nil, true, "standing shows title")
assert_eq(COB.StandingTab.standing:GetText(), "Standing: 75", "standing value from Core")
assert_eq(COB.StandingTab.nextLine:GetText():find("Beef Knight", 1, true) ~= nil, true, "text next threshold")
assert_eq(COB.StandingTab.nextLine:GetText():find("StatusBar", 1, true), nil, "no StatusBar copy")

-- No guild → empty flock copy
stub.inGuild = false
COB.UI:ShowTab("ladder")
COB.UI:MarkDirty("ladder")
assert_eq(COB.LadderTab.empty:IsShown(), true, "no-guild empty state shown")
assert_eq(COB.LadderTab.empty:GetText():find("outside the flock", 1, true) ~= nil, true, "COB_EMPTY_NO_GUILD copy")
stub.inGuild = true

--------------------------------------------------------------------------------
-- BeefNet / sync L0 status chip (research 20 + 45)
--------------------------------------------------------------------------------
dofile("addon/ChurchOfBeef/Net/BeefNet.lua")
dofile("addon/ChurchOfBeef/Net/Sync.lua")
local Status = COB.UI.Status
local Sync = COB.Sync
-- Prefer live UI.frame: loadUi()/Init reload replaces the first `frame` local.
local function chip()
  return COB.UI.statusChip or (COB.UI.frame and COB.UI.frame.StatusChip)
end

Status:ResetForTests()
Sync:ResetForTests()
COB.Ladder:ResetForTests()
stub.inGuild = true
COB.Net.rosterLookup = function()
  return function() return 0 end
end

Sync.pendingRequest = "r1"
Sync.requestSent = false
Sync.sessionMergeCount = 0
Sync.consumeEnded = false
COB.UI:OnSyncStatusChanged()
assert_eq(Status.state, "settling", "login settle is settling")
assert_true(Status:ChipText():find("Starting Church", 1, true) ~= nil, "settling chip copy")
assert_true(chip():GetText():find("Starting Church", 1, true) ~= nil, "settling text on chip")
assert_eq(chip():IsShown(), true, "chip visible while settling")

Sync.requestSent = true
COB.UI:OnSyncStatusChanged()
assert_eq(Status.state, "syncing", "sent request is syncing")
assert_eq(Status:ChipText(), "Checking for peers…", "syncing chip copy")

COB.Ladder:SetStanding("Beefina", 75)
Sync.sessionMergeCount = 2
COB.UI:OnSyncStatusChanged()
assert_eq(Status.state, "synced", "useful merge is synced")
assert_eq(Status:ChipText(), "Synced", "synced chip copy")
COB.UI:ShowTab("ladder")
COB.UI:MarkDirty("ladder")
assert_eq(COB.LadderTab.empty:IsShown(), false, "sync success never blanks ladder into empty")
assert_eq(COB.LadderTab.rows[6].occupants:GetText():find("Beefina", 1, true) ~= nil, true,
  "cached occupants stay visible during sync success")

stub.flushTimers()
assert_eq(Status.state, "ready", "synced auto-advances to ready")
assert_eq(Status:ChipText(), "", "ready hides the chip")

-- Solo GM with a live roster: consume-end with no peer merge is ready (not no_peers).
Status:ResetForTests()
Sync.pendingRequest = nil
Sync.requestSent = true
Sync.sessionMergeCount = 0
Sync.consumeEnded = true
assert_true(#COB.Roster:GetLadderView() > 0, "roster still has occupants")
COB.UI:OnSyncStatusChanged()
assert_eq(Status.state, "ready", "roster occupants → ready even with no addon peers")
assert_eq(Status:ChipText(), "", "ready hides the chip when roster fills the ladder")
COB.UI:ShowTab("ladder")
COB.UI:MarkDirty("ladder")
assert_eq(COB.LadderTab.banner:IsShown(), false, "roster-filled ladder hides learning banner")

-- Ready roster with zero occupants + local standing → soft "local standing" chip.
Status:ResetForTests()
COB.Roster:ResetForTests()
COB.Roster.ready = true
COB.Roster.members = {}
stub.guildRoster = {}
COB.Ladder:SetStanding("Beefina", 75)
Sync.pendingRequest = nil
Sync.requestSent = true
Sync.sessionMergeCount = 0
Sync.consumeEnded = true
assert_true(#COB.Ladder:ExportState() > 0, "standing cache present for cached chip")
COB.UI:OnSyncStatusChanged()
assert_eq(Status.state, "cached", "timeout with standing cache and empty roster is cached")
assert_true(Status:ChipText():find("local standing", 1, true) ~= nil, "cached chip copy")

Status:ResetForTests()
Sync:ResetForTests()
COB.Ladder:ResetForTests()
COB.Roster:ResetForTests()
COB.Roster.ready = true
COB.Roster.members = {}
stub.guildRoster = {}
Sync.consumeEnded = true
Sync.sessionMergeCount = 0
COB.UI:OnSyncStatusChanged()
assert_eq(Status.state, "no_peers", "timeout with empty cache and empty roster is no_peers")
assert_eq(Status:ChipText(), "No addon peers", "no_peers chip copy")
COB.UI:ShowTab("ladder")
COB.UI:MarkDirty("ladder")
assert_eq(COB.LadderTab.banner:IsShown(), true, "no_peers shows L1 learning banner")
assert_true(COB.LadderTab.banner:GetText():find("guild roster", 1, true) ~= nil,
  "roster-backed learning copy")
assert_eq(COB.LadderTab.rows[1].frame:IsShown(), true, "empty shelves stay visible for no_peers")

stub.inGuild = false
Status:ResetForTests()
COB.UI:OnSyncStatusChanged()
assert_eq(Status.state, "unguilded", "not in guild is unguilded")
assert_eq(Status:ChipText(), "Not in a guild", "unguilded chip copy")
COB.UI:ShowTab("ladder")
COB.UI:MarkDirty("ladder")
assert_eq(COB.LadderTab.empty:IsShown(), true, "unguilded L1 empty body")
assert_eq(COB.LadderTab.banner:IsShown(), false, "unguilded does not use no_peers banner")
stub.inGuild = true

local reqId = Sync:OnLogin()
local sig = Sync:GetStatus()
assert_eq(sig.pendingRequest, reqId, "GetStatus exposes pending request")
assert_eq(sig.requestSent, false, "settle window has not sent yet")
assert_eq(sig.mergeCount, 0, "merge count starts at zero")
assert_eq(sig.consumeEnded, false, "consume has not ended")
stub.flushTimers()
sig = Sync:GetStatus()
assert_eq(sig.requestSent, true, "after settle, requestSent is true")

restore()
