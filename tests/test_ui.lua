-- Quiet shell: frame creation, drag/resize/coalesce, saved position, minimap
-- toggle, system/debug toasts. No tab registry. No Standing / Ladder / Officer
-- IA. No promote / rite toast kinds.
local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
dofile("addon/ChurchOfBeef/Core/Roster.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")

local COB = ChurchOfBeef

local function loadUi()
  dofile("addon/ChurchOfBeef/UI/MainFrame.lua")
  dofile("addon/ChurchOfBeef/UI/Status.lua")
  dofile("addon/ChurchOfBeef/UI/Minimap.lua")
  dofile("addon/ChurchOfBeef/UI/Toasts.lua")
end

ChurchOfBeefDB = nil
COB.DB:Init()
if COB.Roster and COB.Roster.ResetForTests then COB.Roster:ResetForTests() end

loadUi()

--------------------------------------------------------------------------------
-- Tab registry and ClassColorCode are gone
--------------------------------------------------------------------------------
assert_eq(COB.UI.RegisterTab, nil, "RegisterTab is gone")
assert_eq(COB.UI.ShowTab, nil, "ShowTab is gone")
assert_eq(COB.UI.GetTabNames, nil, "GetTabNames is gone")
assert_eq(COB.UI.UpdateOfficerVisibility, nil, "officer-only tab chrome is gone")
assert_eq(COB.UI.ClassColorCode, nil, "ClassColorCode is gone")
assert_eq(COB.UI.MarkDirty, nil, "tab dirty-flag is gone")

--------------------------------------------------------------------------------
-- Init builds a hidden, movable, clamped, resizable frame
--------------------------------------------------------------------------------
stub.guildRankIndex = nil
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
assert_true(frame.FooterText ~= nil, "footer placeholder exists")
assert_eq(frame.FooterText:GetText(), "", "footer is empty — no Eternal Grazing joke")
assert_true(frame.StatusChip ~= nil, "status chip exists on main frame")
assert_true(COB.UI.Status ~= nil, "UI.Status presenter loaded")
assert_eq(frame:GetWidth(), COB.UI.DEFAULT_WIDTH, "default width")
assert_eq(frame:GetHeight(), COB.UI.DEFAULT_HEIGHT, "default height")
assert_true(frame.SizeGrip ~= nil, "size grip exists")
assert_true(frame._minResize ~= nil, "Classic SetMinResize applied")
assert_eq(frame._minResize[1], COB.UI.MIN_WIDTH, "min width bound")
assert_eq(frame._minResize[2], COB.UI.MIN_HEIGHT, "min height bound")
assert_true(COB.UI.content ~= nil, "empty content host exists")

local point, _, relativePoint, x, y = frame:GetPoint(1)
assert_eq(point, "CENTER", "unsaved position defaults to center")
assert_eq(relativePoint, "CENTER", "default relative anchor is center")
assert_eq(x, 0, "default x offset")
assert_eq(y, 0, "default y offset")

local function buttonFor(label)
  return stub.findChild(frame, function(child)
    return child._type == "Button" and child:GetText() == label
  end)
end

assert_eq(buttonFor("Ladder"), nil, "no Ladder tab button")
assert_eq(buttonFor("My Standing"), nil, "no Standing tab button")
assert_eq(buttonFor("Officer"), nil, "no Officer tab button")
assert_eq(buttonFor("Probe"), nil, "no plumbing-tab probe button")

--------------------------------------------------------------------------------
-- Toggle shows/hides and records the state in SV
--------------------------------------------------------------------------------
COB.UI:Toggle()
assert_eq(COB.UI:IsShown(), true, "toggle opens the frame")
assert_eq(ChurchOfBeefDB.ui.shown, true, "open state persisted")

COB.UI:Toggle()
assert_eq(COB.UI:IsShown(), false, "toggle closes the frame")
assert_eq(ChurchOfBeefDB.ui.shown, false, "closed state persisted")

COB.UI:Show()
assert_eq(ChurchOfBeefDB.ui.shown, true, "Show persists the open state")
frame:Hide()
assert_eq(ChurchOfBeefDB.ui.shown, false, "an escape-key close still persists")

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
-- Resize: clamp, persist, restore default
--------------------------------------------------------------------------------
frame:SetWidth(100)
frame:SetHeight(50)
stub.fire(frame, "OnSizeChanged")
assert_eq(frame:GetWidth(), COB.UI.MIN_WIDTH, "undersize width clamps to min")
assert_eq(frame:GetHeight(), COB.UI.MIN_HEIGHT, "undersize height clamps to min")

frame:SetWidth(2000)
frame:SetHeight(2000)
stub.fire(frame, "OnSizeChanged")
assert_eq(frame:GetWidth(), COB.UI.MAX_WIDTH, "oversize width clamps to max")
assert_eq(frame:GetHeight(), COB.UI.MAX_HEIGHT, "oversize height clamps to max")

assert_eq(COB.UI:ResetSize(), true, "ResetSize succeeds")
assert_eq(frame:GetWidth(), COB.UI.DEFAULT_WIDTH, "ResetSize restores default width")
assert_eq(frame:GetHeight(), COB.UI.DEFAULT_HEIGHT, "ResetSize restores default height")
assert_eq(ChurchOfBeefDB.ui.size.w, COB.UI.DEFAULT_WIDTH, "default size persisted")
assert_eq(ChurchOfBeefDB.ui.size.h, COB.UI.DEFAULT_HEIGHT, "default height persisted")

local cw, ch = COB.UI:GetContentSize()
assert_true(type(cw) == "number" and cw > 0, "GetContentSize width")
assert_true(type(ch) == "number" and ch > 0, "GetContentSize height")

assert_true(stub.fire(frame.SizeGrip, "OnMouseDown", "RightButton"), "grip right-click wired")
assert_eq(frame:GetWidth(), COB.UI.DEFAULT_WIDTH, "grip right-click restores default width")

--------------------------------------------------------------------------------
-- Reload restores position and open state
--------------------------------------------------------------------------------
ChurchOfBeefDB.ui.shown = true
loadUi()
local reloaded = COB.UI:Init()
local rp, _, rrp, rx, ry = reloaded:GetPoint(1)
assert_eq(rp, "TOPLEFT", "saved anchor restored after reload")
assert_eq(rrp, "TOPLEFT", "saved relative anchor restored")
assert_eq(rx, 120, "saved x restored")
assert_eq(ry, -80, "saved y restored")
assert_eq(COB.UI:IsShown(), true, "frame reopens when it was open at logout")
assert_eq(COB.UI.RegisterTab, nil, "reload still has no tab registry")
assert_eq(COB.UI.ClassColorCode, nil, "reload still has no ClassColorCode")
assert_eq(reloaded.FooterText:GetText(), "", "reload footer stays empty")

ChurchOfBeefDB.ui.point = { point = "MIDDLE-OF-NOWHERE", relativePoint = "CENTER", x = 1, y = 2 }
loadUi()
local safe = COB.UI:Init()
assert_eq(select(1, safe:GetPoint(1)), "CENTER", "invalid saved anchor falls back to center")
ChurchOfBeefDB.ui.point = saved
frame = safe

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
-- System / debug toasts queue and expire without a permanent OnUpdate
--------------------------------------------------------------------------------
assert_eq(COB.Toasts:Show(""), false, "empty toast refused")
assert_eq(COB.Toasts:Show(nil), false, "nil toast refused")
assert_eq(COB.Toasts:Show("system one"), true, "toast accepted")
assert_eq(COB.Toasts.frame:IsShown(), true, "toast frame shown")
assert_eq(COB.Toasts.frame.text:GetText(), "system one", "toast text set")

assert_eq(COB.Toasts:Show("system two"), true, "second toast queued")
assert_eq(COB.Toasts.frame.text:GetText(), "system one", "queued toast waits its turn")
stub.flushTimers()
assert_eq(COB.Toasts.frame.text:GetText(), "system two", "queue advances on expiry")
assert_eq(COB.Toasts.frame:IsShown(), true, "second toast visible")
stub.flushTimers()
assert_eq(COB.Toasts.frame:IsShown(), false, "toast hides when the queue drains")

COB.Toasts:ResetForTests()
assert_eq(COB.Toasts:Push({ kind = "system", text = "dedupe me", dedupeKey = "sys:1" }), true,
  "system push accepted")
local dupOk, dupReason = COB.Toasts:Push({ kind = "system", text = "dedupe me", dedupeKey = "sys:1" })
assert_eq(dupOk, false, "duplicate system toast deduped")
assert_eq(dupReason, "deduped", "dedupe reason")
COB.Toasts:HideAll()
assert_eq(COB.Toasts:PendingCount(), 0, "HideAll clears pending")
assert_eq(COB.Toasts:ShowingKind(), nil, "HideAll clears showing")

COB.Toasts:ResetForTests()
assert_eq(COB.Toasts:Celebrate("debug", { detail = "probe" }), true, "debug Celebrate accepted")
assert_eq(COB.Toasts:ShowingKind(), "debug", "debug kind still exists")
assert_eq(COB.Toasts.frame.text:GetText(), "probe", "debug uses detail copy")
COB.Toasts:ResetForTests()

local promoteOk, promoteReason = COB.Toasts:Celebrate("promote", {
  name = "Beefina", title = "Beef Knight",
})
assert_eq(promoteOk, false, "promote Celebrate mints no copy")
assert_eq(promoteReason, "invalid", "promote builder is gone")
assert_eq(COB.Toasts:ShowingKind(), nil, "promote does not show")

local riteOk, riteReason = COB.Toasts:Celebrate("rite", {
  verb = "Set", name = "Beefina", title = "Cooked Beef",
})
assert_eq(riteOk, false, "rite Celebrate mints no copy")
assert_eq(riteReason, "invalid", "rite builder is gone")

assert_eq(COB.Toasts:Push({ kind = "promote", text = "leftover promote" }), true,
  "unknown kind with explicit text still queues")
assert_eq(COB.Toasts:ShowingKind(), "system", "excised promote kind falls through to system")
COB.Toasts:ResetForTests()

local wasTest = COB._IN_TEST
COB._IN_TEST = false

assert_eq(COB.Toasts:Push({ kind = "system", text = "motion on" }), true,
  "toast accepted on a client with animation groups")
local fadeIn = rawget(COB.Toasts.frame, "cobFadeIn")
assert_eq(type(fadeIn), "table", "a real AnimationGroup is built and kept")
assert_eq(fadeIn:IsPlaying(), true, "and it is the thing that plays the toast in")
assert_eq(COB.Toasts.frame:IsShown(), true, "the toast is on screen")
COB.Toasts:HideAll()
COB.Toasts:ResetForTests()

local toastFrame = COB.Toasts.frame
local realCreate = rawget(toastFrame, "CreateAnimationGroup")
rawset(toastFrame, "CreateAnimationGroup", false)
rawset(toastFrame, "_cobMotionReady", nil)
rawset(toastFrame, "cobFadeIn", nil)

assert_eq(COB.Toasts:Push({ kind = "system", text = "motion fallback ok" }), true,
  "toast works when AnimationGroup is absent")
assert_eq(rawget(toastFrame, "cobFadeIn"), nil, "no group is invented on a client without them")
assert_eq(toastFrame:IsShown(), true, "C_Timer fade path still shows toast")

rawset(toastFrame, "CreateAnimationGroup", realCreate or nil)
rawset(toastFrame, "_cobMotionReady", nil)
stub.flushTimers()
COB._IN_TEST = wasTest
COB.Toasts:ResetForTests()

--------------------------------------------------------------------------------
-- Status chip: guild / roster / version only — no standing or grant copy
--------------------------------------------------------------------------------
local Status = COB.UI.Status
local function chip()
  return COB.UI.statusChip or (COB.UI.frame and COB.UI.frame.StatusChip)
end

assert_eq(Status.ShowsLearningBanner, nil, "no ladder learning banner predicate")
assert_eq(Status.ShowsHardGateBanner, nil, "no ladder hard-gate banner predicate")

Status:ResetForTests()
if COB.Roster and COB.Roster.ResetForTests then COB.Roster:ResetForTests() end
stub.inGuild = true
COB.Roster.ready = false
COB.UI:OnStatusChanged()
assert_eq(Status.state, "roster_wait", "an unread roster is the one waiting state")
assert_eq(Status:ChipText(), "Reading the guild roster…", "roster_wait chip copy")
assert_eq(chip():GetText(), "Reading the guild roster…", "and it reaches the chip widget")
assert_eq(chip():IsShown(), true, "chip visible while waiting")
assert_eq(Status:IsConnecting(), true, "roster_wait is the connecting state")

Status:ResetForTests()
if COB.Roster and COB.Roster.ResetForTests then COB.Roster:ResetForTests() end
stub.guildRoster = { { name = "Beefina", rankIndex = 6 } }
assert_true(COB.Roster:Refresh(), "Refresh succeeds when Church ids are nil")
COB.UI:OnStatusChanged()
assert_eq(Status.state, "ready", "a sensed roster leaves roster_wait")
assert_eq(Status:ChipText(), "", "ready hides the chip")
assert_eq(chip():IsShown(), false, "the widget hides after a real Refresh")
assert_eq(COB.UI.frame.FooterText:GetText(), "", "ready footer stays empty")

Status:ResetForTests()
if COB.Roster and COB.Roster.ResetForTests then COB.Roster:ResetForTests() end
COB.Roster.ready = true
COB.Roster.complete = true
COB.UI:OnStatusChanged()
assert_eq(Status.state, "ready", "a read roster is ready")
assert_eq(Status:ChipText(), "", "ready hides the chip")
assert_eq(chip():IsShown(), false, "the widget hides too")
assert_eq(Status:IsConnecting(), false, "ready is not connecting")

COB.Net = COB.Net or {}
COB.Net.warnedVersion = true
Status:ResetForTests()
COB.UI:OnStatusChanged()
assert_eq(Status.state, "ready", "a version mismatch does not block the shell")
assert_eq(Status:ChipText(), "BeefNet version mismatch", "but it is said out loud")
assert_true(Status:FormattedChip():find("|cffffaa00", 1, true) ~= nil,
  "warnings are dual-encoded: words plus amber")
COB.Net.warnedVersion = nil

stub.inGuild = false
Status:ResetForTests()
COB.UI:OnStatusChanged()
assert_eq(Status.state, "unguilded", "not in a guild is unguilded")
assert_eq(Status:ChipText(), "Not in a guild", "unguilded chip copy")
stub.inGuild = true

--------------------------------------------------------------------------------
-- Roster events coalesce; RefreshLadder is a safe no-tab fan-out
--------------------------------------------------------------------------------
COB.UI:Show()
assert_true(stub.fire(COB.UI.frame, "OnEvent", "GUILD_ROSTER_UPDATE"), "guild roster event handled")
stub.flushTimers()
COB.UI:RefreshLadder()
assert_eq(COB.UI:IsShown(), true, "RefreshLadder does not close the shell")
assert_eq(COB.UI.frame.FooterText:GetText(), "", "coalesced paint never restores Eternal Grazing")

restore()
