-- Quiet shell: frame creation, drag/resize/coalesce, saved position, minimap
-- toggle, system/debug toasts. Event Mode Proclaim (sanction / verdict /
-- cowardice / knighting / elevation). B12-D Proclaim ESC, B15-C Quiet-shell
-- UISpecialFrames, B18-C HideAll theaterGen, B19-B small-toast ESC,
-- B20-D small-toast OnHide pump, B21-C interrupt Hide idle,
-- B23-C Init early-return rememberSpecial,
-- B24-C Quiet-shell Init early-return rememberSpecial,
-- B26-B Init early-return restores a missing OnHide,
-- B27-C Quiet-shell Init restores a missing OnHide,
-- B29-D Proclaim re-applies applyHeadlineFont (Theme:FontPath display),
-- B31-C Quiet-shell Show remounts a missing OnHide,
-- B35-D Quiet-shell Hide remounts a missing OnHide,
-- B39-C HideAll remounts toast + proclaim ESC names,
-- B40-D already-hidden Hide still persists shown = false,
-- and B41-D existing-frame Init remounts ChurchOfBeefProclaim
-- live in runB12D() (Lua 5.1 200-local cap).
-- No tab registry. No Standing / Ladder / Officer IA. No promote / rite toast
-- kinds. Isolation stays under standalone.
local standalone = (type(assert_eq) ~= "function")
local passed = 0
local failed = 0

if standalone then
  package.path = package.path .. ";./tests/?.lua"
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

local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Core/Common.lua")
if not ChurchOfBeef.Theme then
  dofile("addon/ChurchOfBeef/UI/Theme.lua")
end
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
-- Isolated surface: this suite does not load Console / HUD / Records / Gora.
-- Runtime and Sound are dofiled later for the Quiet / cue pins.
--------------------------------------------------------------------------------
if standalone then
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load Records Book")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.Runtime, nil, "Runtime is dofiled later for the Quiet pin")
  assert_eq(COB.Sound, nil, "Sound is dofiled later for cue pins")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
end

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

--------------------------------------------------------------------------------
-- V-B + B3-A + B5-D + U-D: sanction / verdict / cowardice / knighting / elevation.
-- Push/Proclaim only. Runtime + Sound are loaded here (not wired
-- from Console / Gora / Knighting). Headlines resolve via Theme:FontPath.
--------------------------------------------------------------------------------
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/UI/Sound.lua")

local savedPlaySound = PlaySound
local savedPlaySoundFile = PlaySoundFile
local savedChatFrame = DEFAULT_CHAT_FRAME
local origSoundPlay = COB.Sound.Play

local played = {}
-- B3-A names the cue on Sound:Play. B3-C feeds PlaySound a kit id (or
-- nothing when SOUNDKIT is missing). Pin the name contract here.
COB.Sound.Play = function(self, name)
  played[#played + 1] = name
  return origSoundPlay(self, name)
end
PlaySound = function()
end
PlaySoundFile = function()
  error("PlaySoundFile is not a V-B cue path")
end

local chatLines = {}
DEFAULT_CHAT_FRAME = {
  AddMessage = function(_, message)
    chatLines[#chatLines + 1] = message
  end,
}

local function theaterReset()
  assert_eq(COB.Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(COB.Toasts:ResetForTests(), true, "Toasts ResetForTests runs under _IN_TEST")
  played = {}
  chatLines = {}
  stub.chat = {}
end

local function theaterCopy()
  local theater = COB.Toasts.theater
  if not theater then return nil end
  local head = theater.headline and theater.headline.GetText and theater.headline:GetText()
  local body = theater.copy and theater.copy.GetText and theater.copy:GetText()
  if type(head) ~= "string" then head = "" end
  if type(body) ~= "string" then body = "" end
  if head == "" and body == "" then return nil end
  if body == "" then return head end
  if head == "" then return body end
  return head .. "\n" .. body
end

local function findButton(widget)
  if not widget then return nil end
  if widget._type == "Button" then return widget end
  for i = 1, #(widget._children or {}) do
    local hit = findButton(widget._children[i])
    if hit then return hit end
  end
  return nil
end

assert_eq(type(COB.Toasts.Proclaim), "function", "Proclaim is the theatrical entry")

theaterReset()
assert_eq(COB.Runtime:Snapshot().state, "QUIET", "fresh runtime is QUIET")
local quietOk, quietReason = COB.Toasts:Proclaim("sanction", {
  fighterA = "Juicyj", fighterB = "Meat Is Murder",
})
assert_eq(quietOk, false, "Quiet Runtime refuses sanction")
assert_true(type(quietReason) == "string", "Quiet refuse returns a reason")
assert_true(
  COB.Toasts.theater == nil or COB.Toasts.theater.root:IsShown() == false,
  "Quiet does not show the theater frame"
)

local savedRuntime = COB.Runtime
COB.Runtime = nil
local missingOk = COB.Toasts:Proclaim("cowardice", { name = "Thickcut" })
assert_eq(missingOk, false, "missing Runtime refuses cowardice")
assert_true(
  COB.Toasts.theater == nil or COB.Toasts.theater.root:IsShown() == false,
  "missing Runtime does not show theater"
)
COB.Runtime = savedRuntime

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent reaches ASSEMBLY")
UIParent:SetWidth(1200)
UIParent:SetHeight(800)
assert_eq(COB.Toasts:Proclaim("sanction", {
  fighterA = "Juicyj",
  fighterB = "Meat Is Murder",
  stipulation = "Come as you are",
}), true, "Event Mode sanction is accepted")
assert_true(COB.Toasts.theater ~= nil, "sanction mints a theater overlay")
assert_eq(COB.Toasts.theater.root:IsShown(), true, "sanction shows the overlay")
local sanctionCopy = theaterCopy()
assert_true(type(sanctionCopy) == "string", "sanction paints clerical copy")
assert_true(sanctionCopy:find("A Beef Gora is Sanctioned", 1, true) ~= nil,
  "sanction headline is clerical")
assert_true(COB.Toasts.theater.headline ~= nil, "Proclaim has a headline FontString")
assert_eq(COB.Toasts.theater.headline._template, "GameFontNormalLarge",
  "headline fallback is the existing GameFontNormalLarge template")
assert_eq(COB.Toasts.theater.copy._template, "GameFontNormal",
  "body stays GameFont*")
assert_eq(COB.Toasts.theater.headline:GetText(), "A Beef Gora is Sanctioned",
  "sanction headline is the first clerical line")
assert_true(COB.Toasts.theater.copy:GetText():find("Juicyj", 1, true) ~= nil,
  "sanction body paints fighter A")
assert_eq(COB.Toasts.theater.headlineFontPath, COB.Theme:FontPath("display"),
  "headline font path is Theme display")
assert_eq(COB.Toasts.theater.bodyFontPath, COB.Theme:FontPath("body"),
  "body font path is Theme body")
local headFont = COB.Toasts.theater.headline.GetFont
  and select(1, COB.Toasts.theater.headline:GetFont())
if type(headFont) == "string" then
  assert_eq(headFont, COB.Theme:FontPath("display"),
    "SetFont reports the Theme display path when the stub records it")
end
local bodyFont = COB.Toasts.theater.copy.GetFont
  and select(1, COB.Toasts.theater.copy:GetFont())
if type(bodyFont) == "string" then
  assert_eq(bodyFont, COB.Theme:FontPath("body"),
    "body SetFont reports the Theme body path when the stub records it")
end
assert_eq(COB.Toasts.theater.sealName, "seal_papal", "sanction seal name is papal")
assert_eq(COB.Toasts.theater.sealPath, COB.Theme:Texture("seal_papal"),
  "sanction seal slot is the Theme path")
assert_eq(COB.Toasts.theater.seal._cobPath, COB.Theme:Texture("seal_papal"),
  "sanction seal texture slot stored the Theme path")
assert_eq(COB.Toasts.theater.rays:IsShown(), false, "sanction hides the sunburst")
assert_eq(COB.Toasts.theater.banner:IsShown(), false, "sanction hides the knighting banner")
assert_true(sanctionCopy:find("Juicyj", 1, true) ~= nil, "sanction paints fighter A")
assert_true(sanctionCopy:find("Meat Is Murder", 1, true) ~= nil, "sanction paints fighter B")
assert_true(sanctionCopy:find("Come as you are", 1, true) ~= nil,
  "sanction prints the Pope-authored stipulation as-is")
assert_eq(sanctionCopy:find("Their third meeting", 1, true), nil,
  "sanction does not generate head-to-head oratory")
assert_true(COB.Toasts.theater.dimAlpha ~= nil, "dim alpha is recorded")
assert_true(COB.Toasts.theater.dimAlpha <= 0.5, "background dim is ≤ 50%")
assert_true(COB.Toasts.theater.dimAlpha > 0, "background dim is present")
local panelW = COB.Toasts.theater.panel:GetWidth()
assert_true(type(panelW) == "number", "panel has a width")
assert_true(panelW <= 400, "panel occupies at most the center third")
assert_true(panelW < 1200, "panel is not full-screen")
local panelH = COB.Toasts.theater.panel:GetHeight()
assert_true(type(panelH) == "number" and panelH < 800, "panel is not full-screen tall")
assert_eq(findButton(COB.Toasts.theater.root), nil, "sanction has no close button")
assert_eq(COB.Toasts.theater.root:GetScript("OnUpdate"), nil, "theater has no permanent OnUpdate")
assert_eq(played[#played], "sanction", "sanction plays the sanction cue")
assert_eq(#stub.chat, 0, "Proclaim never SendChatMessage")
if #chatLines > 0 then
  assert_eq(chatLines[1], sanctionCopy, "optional chat repeats the same clerical line")
end

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for cowardice")
assert_eq(COB.Toasts:Proclaim("cowardice", { name = "Thickcut" }), true,
  "Event Mode cowardice is accepted")
assert_eq(theaterCopy(), "Cowardice recorded: Thickcut. So ruled by the Beef Pope.",
  "cowardice copy is the clerical sentence")
assert_eq(COB.Toasts.theater.headline:GetText(),
  "Cowardice recorded: Thickcut. So ruled by the Beef Pope.",
  "single-line cowardice sits on the headline")
assert_eq(COB.Toasts.theater.copy:GetText(), "",
  "single-line cowardice has no body")
assert_eq(chatLines[1], "Cowardice recorded: Thickcut. So ruled by the Beef Pope.",
  "cowardice chat echo stays the pinned clerical line")
assert_eq(COB.Toasts.theater.sealName, "seal_cowardice", "cowardice seal name")
assert_eq(COB.Toasts.theater.sealPath, COB.Theme:Texture("seal_cowardice"),
  "cowardice seal slot is the Theme path")
assert_eq(COB.Toasts.theater.accentRole, "oxblood", "cowardice accent is oxblood")
assert_eq(played[#played], "cowardice", "cowardice plays the cowardice cue")
assert_eq(findButton(COB.Toasts.theater.root), nil, "cowardice has no close button")
assert_eq(#stub.chat, 0, "cowardice never SendChatMessage")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for victor")
assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "victor", name = "Thickcut" }), true,
  "Event Mode victor is accepted")
assert_eq(COB.Toasts.theater.headline:GetText(), "VICTOR DECLARED",
  "victor panel headline is VICTOR DECLARED once")
assert_eq(COB.Toasts.theater.copy:GetText(), "Thickcut. So ruled by the Beef Pope.",
  "victor body says the name once, then the ruling")
assert_eq(theaterCopy(), "VICTOR DECLARED\nThickcut. So ruled by the Beef Pope.",
  "victor panel says it once each way")
assert_eq(chatLines[1], "Victor declared: Thickcut. So ruled by the Beef Pope.",
  "B9-D chat echo stays byte-identical")
assert_eq(COB.Toasts.theater.sealName, "seal_victor", "victor seal name")
assert_eq(COB.Toasts.theater.sealPath, COB.Theme:Texture("seal_victor"),
  "victor seal slot is the Theme path")
assert_eq(COB.Toasts.theater.accentRole, "gold", "victor accent is gold")
assert_eq(played[#played], "verdict", "victor plays the verdict cue")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for void")
assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
  "Event Mode void is accepted")
assert_eq(theaterCopy(), "Void.", "void copy is clerical")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for free text")
assert_eq(COB.Toasts:Proclaim("verdict", {
  ruling = "free", text = "The bout is set aside.",
}), true, "Event Mode free ruling with Pope text is accepted")
assert_eq(theaterCopy(), "The bout is set aside.", "free uses Pope text when provided")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for free default")
assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "free" }), true,
  "Event Mode free ruling without text is accepted")
assert_eq(theaterCopy(), "Free ruling.", "free falls back to the clerical default")

--------------------------------------------------------------------------------
-- B3-A: knighting / elevation. Fixed clerical headlines. Mute card.
--------------------------------------------------------------------------------
theaterReset()
assert_eq(COB.Runtime:Snapshot().state, "QUIET", "runtime reset is QUIET before knighting")
local kQuietOk, kQuietReason = COB.Toasts:Proclaim("knighting", { name = "Beefina" })
assert_eq(kQuietOk, false, "Quiet Runtime refuses knighting")
assert_true(type(kQuietReason) == "string", "Quiet knighting refuse returns a reason")
assert_true(
  COB.Toasts.theater == nil or COB.Toasts.theater.root:IsShown() == false,
  "Quiet does not show the knighting overlay"
)

local savedRuntimeK = COB.Runtime
COB.Runtime = nil
local kMissingOk = COB.Toasts:Proclaim("elevation", { name = "Juicyj" })
assert_eq(kMissingOk, false, "missing Runtime refuses elevation")
assert_true(
  COB.Toasts.theater == nil or COB.Toasts.theater.root:IsShown() == false,
  "missing Runtime does not show elevation"
)
COB.Runtime = savedRuntimeK

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for knighting")
UIParent:SetWidth(1200)
UIParent:SetHeight(800)
assert_eq(COB.Toasts:Proclaim("knighting", { name = "Beefina" }), true,
  "Event Mode knighting is accepted")
assert_true(COB.Toasts.theater ~= nil, "knighting mints a theater overlay")
assert_eq(COB.Toasts.theater.root:IsShown(), true, "knighting shows the overlay")
assert_eq(theaterCopy(), "RISE, BEEF KNIGHT\nBeefina",
  "knighting copy is the fixed headline plus name")
assert_eq(COB.Toasts.theater.headline:GetText(), "RISE, BEEF KNIGHT",
  "knighting headline is the fixed clerical line")
assert_eq(COB.Toasts.theater.copy:GetText(), "Beefina",
  "knighting body is the name")
assert_eq(COB.Toasts.theater.rays:IsShown(), true, "knighting shows the sunburst layer")
assert_eq(COB.Toasts.theater.raysPath, COB.Theme:Texture("rays_sunburst"),
  "knighting rays slot is the Theme path")
assert_eq(COB.Toasts.theater.rays._blend, "ADD", "knighting rays are additive")
assert_eq(COB.Toasts.theater.banner:IsShown(), true, "knighting shows the banner slot")
assert_eq(COB.Toasts.theater.bannerPath, COB.Theme:Texture("banner_knighting"),
  "knighting banner slot is the Theme path")
assert_eq(COB.Toasts.theater.sealName, "seal_papal", "knighting seal is papal")
assert_eq(theaterCopy():find("found worthy", 1, true), nil,
  "knighting does not generate oratory")
assert_true(COB.Toasts.theater.dimAlpha <= 0.5, "knighting dim is ≤ 50%")
assert_true(COB.Toasts.theater.dimAlpha > 0, "knighting dim is present")
local kPanelW = COB.Toasts.theater.panel:GetWidth()
assert_true(type(kPanelW) == "number", "knighting panel has a width")
assert_true(kPanelW <= 400, "knighting panel occupies at most the center third")
assert_eq(findButton(COB.Toasts.theater.root), nil, "knighting has no close button")
assert_eq(COB.Toasts.theater.root:GetScript("OnUpdate"), nil,
  "knighting theater has no permanent OnUpdate")
assert_eq(played[#played], "knighting", "knighting plays the knighting cue")
assert_eq(#stub.chat, 0, "knighting never SendChatMessage")
if #chatLines > 0 then
  assert_eq(chatLines[1], theaterCopy(), "optional chat repeats the knighting line")
end

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for elevation")
assert_eq(COB.Toasts:Proclaim("elevation", { name = "Juicyj" }), true,
  "Event Mode elevation is accepted")
assert_eq(theaterCopy(), "RISE, BEEF LORD\nJuicyj",
  "elevation copy is the fixed headline plus name")
assert_eq(COB.Toasts.theater.headline:GetText(), "RISE, BEEF LORD",
  "elevation headline is the fixed clerical line")
assert_eq(COB.Toasts.theater.copy:GetText(), "Juicyj",
  "elevation body is the name")
assert_eq(COB.Toasts.theater.rays:IsShown(), true, "elevation shows the sunburst layer")
assert_eq(COB.Toasts.theater.raysPath, COB.Theme:Texture("rays_sunburst"),
  "elevation rays slot is the Theme path")
assert_eq(COB.Toasts.theater.banner:IsShown(), true, "elevation shows the banner slot")
assert_eq(played[#played], "elevation", "elevation plays the elevation cue")
assert_eq(findButton(COB.Toasts.theater.root), nil, "elevation has no close button")
assert_eq(#stub.chat, 0, "elevation never SendChatMessage")
assert_true(COB.Toasts.theater.dimAlpha <= 0.5, "elevation dim is ≤ 50%")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for knighting without name")
local noNameOk, noNameReason = COB.Toasts:Proclaim("knighting", {})
assert_eq(noNameOk, false, "knighting without name is invalid")
assert_eq(noNameReason, "invalid", "knighting missing name reason")
assert_true(
  COB.Toasts.theater == nil or COB.Toasts.theater.root:IsShown() == false,
  "knighting without name does not show theater"
)

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for elevation without name")
local noElevOk, noElevReason = COB.Toasts:Proclaim("elevation", { name = "" })
assert_eq(noElevOk, false, "elevation with empty name is invalid")
assert_eq(noElevReason, "invalid", "elevation empty name reason")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for Celebrate knighting")
local celOk, celReason = COB.Toasts:Celebrate("knighting")
assert_eq(celOk, false, "Celebrate knighting without name mints no copy")
assert_eq(celReason, "invalid", "Celebrate knighting without name is invalid")
assert_eq(COB.Toasts:ShowingKind(), nil, "Celebrate knighting does not fall through to system")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for Celebrate knighting with name")
assert_eq(COB.Toasts:Celebrate("knighting", { name = "Beefina" }), true,
  "Celebrate routes knighting to Proclaim")
assert_eq(theaterCopy(), "RISE, BEEF KNIGHT\nBeefina",
  "Celebrate knighting paints the same clerical copy")
assert_eq(COB.Toasts.theater.headline:GetText(), "RISE, BEEF KNIGHT",
  "Celebrate knighting uses the same headline FontString")
assert_eq(played[#played], "knighting", "Celebrate knighting plays the knighting cue")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for unknown kind")
local unknownOk, unknownReason = COB.Toasts:Proclaim("sermon", { name = "Thickcut" })
assert_eq(unknownOk, false, "unknown kinds do not mint copy")
assert_eq(unknownReason, "invalid", "unknown kind is invalid")
assert_true(
  COB.Toasts.theater == nil or COB.Toasts.theater.root:IsShown() == false,
  "unknown kind does not show theater"
)

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for missing Sound")
local savedSound = COB.Sound
COB.Sound = nil
played = {}
assert_eq(COB.Toasts:Proclaim("sanction", {
  fighterA = "Juicyj", fighterB = "Meat Is Murder",
}), true, "theater still shows when Sound is absent")
assert_eq(COB.Toasts.theater.root:IsShown(), true, "missing Sound still shows the overlay")
assert_eq(#played, 0, "missing Sound does not invent a PlaySound")
COB.Sound = savedSound

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for timed hide")
assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true, "void beat is timed")
assert_eq(COB.Toasts.theater.root:IsShown(), true, "void is visible before the timer")
stub.flushTimers()
assert_eq(COB.Toasts.theater.root:IsShown(), false, "C_Timer.After hides the beat")

theaterReset()
assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for knighting timed hide")
assert_eq(COB.Toasts:Proclaim("knighting", { name = "Beefina" }), true, "knighting beat is timed")
assert_eq(COB.Toasts.theater.root:IsShown(), true, "knighting is visible before the timer")
stub.flushTimers()
assert_eq(COB.Toasts.theater.root:IsShown(), false, "C_Timer.After hides the knighting beat")

local toastSrcFile = io.open("addon/ChurchOfBeef/UI/Toasts.lua", "r")
assert_true(toastSrcFile ~= nil, "Toasts.lua is readable")
local toastSrc = toastSrcFile:read("*a")
toastSrcFile:close()
assert_eq(toastSrc:find("SendChatMessage(", 1, true), nil, "source never SendChatMessage")
assert_eq(toastSrc:find("COB.Console", 1, true), nil, "source does not wire Console")
assert_eq(toastSrc:find("COB.Gora", 1, true), nil, "source does not wire Gora")
assert_eq(toastSrc:find("COB.Knighting", 1, true), nil, "source does not wire Knighting")
assert_eq(toastSrc:find("Their third meeting", 1, true), nil, "source does not generate H2H oratory")
assert_eq(toastSrc:find("Let it be known", 1, true), nil, "source does not generate sermons")
assert_eq(toastSrc:find("found worthy", 1, true), nil, "source does not generate knighting oratory")
assert_eq(toastSrc:find("MORPHEUS", 1, true), nil,
  "headlines resolve via Theme, not a hardcoded Morpheus path")
assert_eq(toastSrc:find("HEADLINE_FONT", 1, true), nil, "HEADLINE_FONT local is gone")
assert_true(toastSrc:find('FontPath("display")', 1, true) ~= nil,
  "headlines request Theme display")
assert_eq(toastSrc:find(".ttf", 1, true), nil, "source does not load custom fonts")
assert_eq(toastSrc:find(".TTF", 1, true), nil, "source does not load custom TTF")
assert_eq(toastSrc:find("Media\\", 1, true), nil, "source does not require custom Media")
assert_eq(toastSrc:find("QuestBG", 1, true), nil, "source does not hardcode QuestBG")
assert_eq(toastSrc:find("WHITE8X8", 1, true), nil, "source does not hardcode WHITE8X8")
assert_eq(toastSrc:find("UI-EmptySlot", 1, true), nil, "source does not hardcode EmptySlot")
assert_eq(toastSrc:find("UI-Tooltip-Background", 1, true), nil,
  "source does not hardcode tooltip background")
assert_eq(toastSrc:find("local GOLD", 1, true), nil, "GOLD color local is gone")
assert_eq(toastSrc:find("local OXBLOOD", 1, true), nil, "OXBLOOD color local is gone")
assert_eq(toastSrc:find("local IRON", 1, true), nil, "IRON color local is gone")

-- Nested so the main chunk stays under Lua 5.1's 200-local cap.
local function runB12D()
  local srcFile = io.open("addon/ChurchOfBeef/UI/Toasts.lua", "r")
  assert_true(srcFile ~= nil, "B12-D Toasts.lua is readable")
  local src = srcFile:read("*a")
  srcFile:close()
  assert_true(src:find("UISpecialFrames", 1, true) ~= nil,
    "source contains UISpecialFrames")
  assert_true(src:find('rememberSpecial("ChurchOfBeefToast")', 1, true) ~= nil,
    "source rememberSpecial ChurchOfBeefToast")
  assert_eq(src:find('insert(UISpecialFrames, "ChurchOfBeefToast")', 1, true), nil,
    "source does not insert ChurchOfBeefToast")
  assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
    "source does not PlaySound IG_CHARACTER_INFO_*")
  assert_eq(src:find("SendChatMessage(", 1, true), nil,
    "B12-D source never SendChatMessage")
  assert_true(src:find('FontPath("display")', 1, true) ~= nil,
    "B12-D headlines resolve via Theme display")
  assert_eq(src:find("MORPHEUS", 1, true), nil,
    "B12-D no hardcoded Morpheus")

  local function countSpecial(name)
    local n = 0
    if type(UISpecialFrames) ~= "table" then return 0 end
    for i = 1, #UISpecialFrames do
      if UISpecialFrames[i] == name then n = n + 1 end
    end
    return n
  end

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for Proclaim ESC")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Event Mode void for ESC register")
  assert_true(COB.Toasts.theater ~= nil and COB.Toasts.theater.root ~= nil,
    "Proclaim mints the theatrical root")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "UISpecialFrames contains ChurchOfBeefProclaim once")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "ChurchOfBeefToast is on UISpecialFrames once")
  COB.Toasts:InitTheater()
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "InitTheater does not duplicate ChurchOfBeefProclaim")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "second Proclaim stays accepted")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "second Proclaim does not duplicate ChurchOfBeefProclaim")
  assert_true(COB.Toasts.theater.root:GetScript("OnHide") ~= nil,
    "theatrical root has OnHide teardown")

  local cues = #played
  COB.Toasts.theater.root:Hide()
  assert_eq(COB.Toasts.theater.root:IsShown(), false, "ESC Hide()s the proclaim root")
  assert_eq(#played, cues, "ESC Hide plays no sound")
  stub.flushTimers()
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Proclaim after ESC leftover Hide")
  assert_eq(COB.Toasts.theater.root:IsShown(), true,
    "next Proclaim is not stuck after ESC Hide")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "ESC Hide does not re-register ChurchOfBeefProclaim")
  assert_eq(findButton(COB.Toasts.theater.root), nil, "ESC path adds no close button")

  -- B18-C: HideAll tears theater down once. Nested here (200-local).
  local hideAllBody = src:match("function Toasts:HideAll%(%)%s*\n(.-)\nfunction Toasts:ResetForTests")
  assert_true(type(hideAllBody) == "string" and hideAllBody ~= "",
    "HideAll body is readable")
  local hideAllHasBump = hideAllBody:find("bumpGen", 1, true) ~= nil
  local hideAllHasTheater = hideAllBody:find("hideTheater", 1, true) ~= nil
  assert_true(not (hideAllHasBump and hideAllHasTheater),
    "HideAll body does not call both bumpGen and hideTheater")

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for HideAll gen")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Proclaim before HideAll")
  assert_true(COB.Toasts.theater ~= nil and COB.Toasts.theater.root ~= nil,
    "theater root exists before HideAll")
  assert_eq(COB.Toasts.theater.root:IsShown(), true, "theater shown before HideAll")
  local cuesHideAll = #played
  COB.Toasts:HideAll()
  assert_eq(COB.Toasts.theater.root:IsShown(), false, "HideAll hides the proclaim root")
  assert_eq(#played, cuesHideAll, "HideAll plays no sound")
  stub.flushTimers()
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Proclaim after HideAll is accepted")
  assert_eq(COB.Toasts.theater.root:IsShown(), true,
    "next Proclaim still shows after HideAll")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "HideAll keeps ChurchOfBeefProclaim on UISpecialFrames once")
  assert_eq(findButton(COB.Toasts.theater.root), nil, "HideAll path adds no close button")

  -- B39-C: HideAll remounts ChurchOfBeefToast and ChurchOfBeefProclaim
  -- after a wiped UISpecialFrames. B18-C still plays no sound and still
  -- tears theater once. Do not add a close button. Do not PlaySound.
  -- Isolation wrap stays. No new main-chunk locals.
  assert_true(hideAllBody:find('rememberSpecial("ChurchOfBeefToast")', 1, true) ~= nil,
    "HideAll remounts ChurchOfBeefToast")
  assert_true(
    hideAllBody:find("rememberSpecial(PROCLAIM_NAME)", 1, true) ~= nil
      or hideAllBody:find('rememberSpecial("ChurchOfBeefProclaim")', 1, true) ~= nil,
    "HideAll remounts ChurchOfBeefProclaim")
  assert_eq(hideAllBody:find("PlaySound", 1, true), nil,
    "HideAll remount does not PlaySound")
  assert_eq(hideAllBody:find("CreateFrame", 1, true), nil,
    "HideAll remount does not rebuild")
  local savedSpecialHideAll = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefToast"), 0,
    "wipe clears ChurchOfBeefToast before HideAll remount")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 0,
    "wipe clears ChurchOfBeefProclaim before HideAll remount")
  local cuesHideAllRemount = #played
  COB.Toasts:HideAll()
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "wiped UISpecialFrames + HideAll lists ChurchOfBeefToast once")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "wiped UISpecialFrames + HideAll lists ChurchOfBeefProclaim once")
  assert_eq(#played, cuesHideAllRemount, "HideAll remount plays no sound")
  assert_eq(COB.Toasts.theater.root:IsShown(), false,
    "HideAll remount still tears theater once")
  assert_eq(findButton(COB.Toasts.theater.root), nil,
    "HideAll remount adds no close button")
  COB.Toasts:HideAll()
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "second HideAll does not duplicate ChurchOfBeefToast")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "second HideAll does not duplicate ChurchOfBeefProclaim")
  assert_eq(#played, cuesHideAllRemount, "second HideAll plays no sound")
  UISpecialFrames = savedSpecialHideAll

  -- B41-D: existing-frame Init remounts ChurchOfBeefToast and
  -- ChurchOfBeefProclaim after a wiped UISpecialFrames. Keep
  -- wireSmallOnHide. Do not add a close button. Do not PlaySound.
  -- Do not tear theater. Isolation wrap stays. No new main-chunk locals.
  hideAllBody = src:match("function Toasts:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
  assert_true(type(hideAllBody) == "string" and hideAllBody ~= "",
    "Init early-return body is readable")
  assert_true(hideAllBody:find('rememberSpecial("ChurchOfBeefToast")', 1, true) ~= nil,
    "existing-frame Init remounts ChurchOfBeefToast")
  assert_true(
    hideAllBody:find("rememberSpecial(PROCLAIM_NAME)", 1, true) ~= nil
      or hideAllBody:find('rememberSpecial("ChurchOfBeefProclaim")', 1, true) ~= nil,
    "existing-frame Init remounts ChurchOfBeefProclaim")
  assert_true(hideAllBody:find("wireSmallOnHide", 1, true) ~= nil,
    "existing-frame Init keeps wireSmallOnHide")
  assert_eq(hideAllBody:find("PlaySound", 1, true), nil,
    "existing-frame Init does not PlaySound")
  assert_eq(hideAllBody:find("hideTheater", 1, true), nil,
    "existing-frame Init does not tear theater")
  assert_eq(hideAllBody:find("CreateFrame", 1, true), nil,
    "existing-frame Init does not rebuild")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Proclaim before Init remount")
  assert_eq(COB.Toasts.theater.root:IsShown(), true, "theater shown before Init remount")
  savedSpecialHideAll = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefToast"), 0,
    "wipe clears ChurchOfBeefToast before Init remount")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 0,
    "wipe clears ChurchOfBeefProclaim before Init remount")
  cuesHideAllRemount = #played
  assert_eq(COB.Toasts:Init(), COB.Toasts.frame,
    "Init remount returns the existing frame")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "wiped UISpecialFrames + Init lists ChurchOfBeefToast once")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "wiped UISpecialFrames + Init lists ChurchOfBeefProclaim once")
  assert_eq(#played, cuesHideAllRemount, "Init remount plays no sound")
  assert_eq(COB.Toasts.theater.root:IsShown(), true,
    "Init remount does not tear theater")
  assert_eq(findButton(COB.Toasts.theater.root), nil,
    "Init remount adds no close button")
  assert_eq(findButton(COB.Toasts.frame), nil,
    "Init remount adds no toast close button")
  COB.Toasts:Init()
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "second Init does not duplicate ChurchOfBeefToast")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "second Init does not duplicate ChurchOfBeefProclaim")
  assert_eq(#played, cuesHideAllRemount, "second Init plays no sound")
  assert_eq(COB.Toasts.theater.root:IsShown(), true,
    "second Init does not tear theater")
  UISpecialFrames = savedSpecialHideAll

  -- B15-C: Quiet shell UISpecialFrames rememberSpecial dedupe. Nested here
  -- so the main chunk stays under Lua 5.1's 200-local cap. No new main-chunk
  -- locals. Existing Init pin and B12-D Proclaim pins stay.
  local shellSrcFile = io.open("addon/ChurchOfBeef/UI/MainFrame.lua", "r")
  assert_true(shellSrcFile ~= nil, "B15-C MainFrame.lua is readable")
  local shellSrc = shellSrcFile:read("*a")
  shellSrcFile:close()
  assert_true(shellSrc:find("local function rememberSpecial", 1, true) ~= nil,
    "source has rememberSpecial")
  assert_true(shellSrc:find("UISpecialFrames[i] == name", 1, true) ~= nil,
    "source has a dedupe loop")
  assert_true(shellSrc:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "Init remembers the named Quiet shell")
  assert_eq(shellSrc:find("table.insert(UISpecialFrames", 1, true), nil,
    "source does not bare-insert UISpecialFrames")
  assert_eq(shellSrc:find("IG_CHARACTER_INFO", 1, true), nil,
    "source does not PlaySound IG_CHARACTER_INFO_*")
  assert_eq(shellSrc:find("PlaySound", 1, true), nil,
    "source does not PlaySound on ESC / show / hide")
  assert_true(shellSrc:find("BasicFrameTemplate", 1, true) ~= nil,
    "Quiet shell stays BasicFrameTemplate")
  assert_true(shellSrc:find("RecordsBook:Toggle", 1, true) ~= nil,
    "UI:Toggle still opens Records Book")
  assert_eq(shellSrc:find("PanelTabButtonTemplate", 1, true), nil,
    "no Ladder / Standing / Officer tabs")

  assert_eq(UISpecialFrames[1], "ChurchOfBeefFrame",
    "existing Init pin: escape still closes ChurchOfBeefFrame")
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "after UI:Init, ChurchOfBeefFrame is on UISpecialFrames once")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "B12-D Proclaim pin stays after shell count")

  -- Force a second build so rememberSpecial must dedupe (Init is otherwise
  -- idempotent; MainFrame has no ResetForTests).
  COB.UI.frame = nil
  local rebuilt = COB.UI:Init()
  assert_true(rebuilt ~= nil, "forced rebuild creates the Quiet shell")
  assert_eq(rebuilt:GetName(), "ChurchOfBeefFrame", "rebuilt frame keeps the special name")
  assert_eq(rebuilt._template, "BasicFrameTemplate", "rebuilt shell stays BasicFrameTemplate")
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "second build does not duplicate ChurchOfBeefFrame")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "second shell build does not touch ChurchOfBeefProclaim")
  assert_eq(UISpecialFrames[1], "ChurchOfBeefFrame",
    "forced rebuild keeps ChurchOfBeefFrame first")

  -- B19-B: small toast ESC via UISpecialFrames. Nested here (200-local).
  -- Proclaim special-frame pins stay. No PlaySound. No hideTheater from
  -- the small-toast OnHide. B26-B: handler lives in wireSmallOnHide;
  -- Init create + early-return both call it.
  local initBody = src:match("function Toasts:Init%(%)(.-)\nfunction Toasts:Push")
  assert_true(type(initBody) == "string" and initBody ~= "",
    "B19-B Init body is readable")
  assert_true(initBody:find('rememberSpecial("ChurchOfBeefToast")', 1, true) ~= nil,
    "Init rememberSpecial ChurchOfBeefToast")
  assert_true(initBody:find("wireSmallOnHide", 1, true) ~= nil,
    "Init calls wireSmallOnHide")
  assert_true(initBody:find("OnHide", 1, true) ~= nil,
    "Init wires OnHide on the small frame")
  assert_eq(initBody:find("hideTheater", 1, true), nil,
    "small-toast OnHide does not call hideTheater")
  assert_eq(initBody:find("PlaySound", 1, true), nil,
    "Init does not PlaySound")
  local wireBody = src:match("local function wireSmallOnHide%(self, frame%)(.-)\nfunction Toasts:Init")
  assert_true(type(wireBody) == "string" and wireBody ~= "",
    "wireSmallOnHide body is readable")
  wireBody = type(wireBody) == "string" and wireBody or ""
  assert_true(wireBody:find("bumpGen", 1, true) ~= nil,
    "small-toast OnHide bumpGen")
  assert_true(wireBody:find("pump(self)", 1, true) ~= nil,
    "small-toast OnHide pumps next")
  assert_true(wireBody:find("if not self.showing then return", 1, true) ~= nil,
    "OnHide idle-returns when showing is already nil")
  assert_eq(wireBody:find("#pending == 0", 1, true), nil,
    "OnHide idle guard does not require empty pending")
  assert_eq(wireBody:find("hideTheater", 1, true), nil,
    "wireSmallOnHide does not hideTheater")
  assert_eq(wireBody:find("PlaySound", 1, true), nil,
    "wireSmallOnHide does not PlaySound")
  assert_true(src:find("interrupt = false", 1, true) ~= nil,
    "default KINDS stay interrupt = false")

  local pumpBody = src:match("pump = function%(self%)(.-)local function interruptShowing")
  assert_true(type(pumpBody) == "string" and pumpBody ~= "",
    "B20-D pump body is readable")
  assert_true(pumpBody:find("not self.showing", 1, true) ~= nil,
    "empty pump returns when showing is already nil")
  assert_true(pumpBody:find("#pending == 0", 1, true) ~= nil,
    "empty pump returns when pending is empty")

  COB.Toasts:Init()
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "after Init, ChurchOfBeefToast is on UISpecialFrames once")
  COB.Toasts:Init()
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "second Init does not duplicate ChurchOfBeefToast")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "B12-D Proclaim pin stays after toast register")
  assert_true(COB.Toasts.frame ~= nil and COB.Toasts.frame:GetScript("OnHide") ~= nil,
    "small toast has OnHide sync")

  theaterReset()
  assert_eq(COB.Toasts:Push({ kind = "system", text = "esc dismiss" }), true,
    "Push before ESC Hide")
  assert_eq(COB.Toasts:ShowingKind(), "system", "showing before ESC Hide")
  assert_eq(COB.Toasts.frame:IsShown(), true, "small toast shown before ESC Hide")
  local cuesToast = #played
  COB.Toasts.frame:Hide()
  assert_eq(COB.Toasts.frame:IsShown(), false, "ESC Hide()s the small toast")
  assert_eq(COB.Toasts:ShowingKind(), nil, "ESC Hide clears ShowingKind")
  assert_eq(#played, cuesToast, "ESC Hide plays no sound")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "ESC Hide does not re-register ChurchOfBeefToast")
  assert_eq(COB.Toasts:Show("after esc"), true, "Show after ESC Hide still works")
  assert_eq(COB.Toasts:ShowingKind(), "system", "later Show shows a kind")
  assert_eq(COB.Toasts.frame:IsShown(), true, "later Show shows the small toast")
  assert_eq(COB.Toasts.frame.text:GetText(), "after esc", "later Show paints new copy")
  assert_eq(findButton(COB.Toasts.frame), nil, "ESC path adds no close button")

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for toast ESC vs theater")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Proclaim while testing small-toast OnHide")
  assert_eq(COB.Toasts.theater.root:IsShown(), true, "theater shown before small Hide")
  assert_eq(COB.Toasts:Push({ kind = "system", text = "beside theater" }), true,
    "small toast during theater")
  COB.Toasts.frame:Hide()
  assert_eq(COB.Toasts:ShowingKind(), nil, "small Hide clears ShowingKind beside theater")
  assert_eq(COB.Toasts.theater.root:IsShown(), true,
    "small-toast OnHide does not hide theater")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "small Hide keeps ChurchOfBeefProclaim once")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "small Hide keeps ChurchOfBeefToast once")

  -- B20-D: ESC Hide on the small toast bumpGen + pump. Advance one.
  -- Do not drain the rest of the queue. Hide-from-empty-pump must not loop.
  theaterReset()
  assert_eq(COB.Toasts:Show("pump one"), true, "first system toast shows")
  assert_eq(COB.Toasts:Show("pump two"), true, "second system toast queues")
  assert_eq(COB.Toasts:Show("pump three"), true, "third system toast queues")
  assert_eq(COB.Toasts.frame.text:GetText(), "pump one", "first envelope is showing")
  assert_eq(COB.Toasts:ShowingKind(), "system", "first showing kind is system")
  assert_eq(COB.Toasts:PendingCount(), 2, "two envelopes wait before ESC")
  local cuesPump = #played
  COB.Toasts.frame:Hide()
  assert_eq(COB.Toasts.frame:IsShown(), true, "ESC presents the queued toast")
  assert_eq(COB.Toasts.frame.text:GetText(), "pump two",
    "ShowingKind path: second envelope is now shown")
  assert_eq(COB.Toasts:ShowingKind(), "system", "ShowingKind is the second envelope")
  assert_eq(COB.Toasts:PendingCount(), 1, "ESC advances one; third stays queued")
  assert_eq(#played, cuesPump, "ESC pump plays no sound")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "ESC pump does not re-register ChurchOfBeefToast")
  assert_eq(findButton(COB.Toasts.frame), nil, "ESC pump adds no close button")

  COB.Toasts.frame:Hide()
  assert_eq(COB.Toasts.frame:IsShown(), true, "second ESC presents the third")
  assert_eq(COB.Toasts.frame.text:GetText(), "pump three",
    "third envelope is now shown")
  assert_eq(COB.Toasts:PendingCount(), 0, "queue is empty after two advances")

  COB.Toasts.frame:Hide()
  assert_eq(COB.Toasts.frame:IsShown(), false, "last ESC Hide()s the small toast")
  assert_eq(COB.Toasts:ShowingKind(), nil, "last ESC clears ShowingKind")
  assert_eq(COB.Toasts:PendingCount(), 0, "last ESC does not invent pending")
  assert_eq(#played, cuesPump, "empty-pump Hide plays no sound")

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for ESC pump vs theater")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Proclaim while testing ESC pump")
  assert_eq(COB.Toasts.theater.root:IsShown(), true, "theater shown before pump Hide")
  assert_eq(COB.Toasts:Show("theater pump one"), true, "first toast beside theater")
  assert_eq(COB.Toasts:Show("theater pump two"), true, "second toast queues beside theater")
  COB.Toasts.frame:Hide()
  assert_eq(COB.Toasts.frame:IsShown(), true, "ESC pump shows the second beside theater")
  assert_eq(COB.Toasts.frame.text:GetText(), "theater pump two",
    "ESC pump presents the second envelope beside theater")
  assert_eq(COB.Toasts:ShowingKind(), "system", "second envelope kind beside theater")
  assert_eq(COB.Toasts.theater.root:IsShown(), true,
    "small-toast OnHide pump does not hide theater")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "ESC pump keeps ChurchOfBeefProclaim once")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "ESC pump keeps ChurchOfBeefToast once")

  -- B21-C: interrupt Hide must not pump a queued row before Push
  -- inserts the interrupter. Default KINDS stay interrupt = false.
  -- Push may pass interrupt = true and a higher priority. Do not drain pending.
  theaterReset()
  assert_eq(COB.Toasts:Show("shown first"), true, "first system toast shows")
  assert_eq(COB.Toasts:Show("queued second"), true, "second system toast queues")
  assert_eq(COB.Toasts.frame.text:GetText(), "shown first", "first envelope is showing")
  assert_eq(COB.Toasts:ShowingKind(), "system", "first showing kind is system")
  assert_eq(COB.Toasts:PendingCount(), 1, "one envelope waits before interrupt")
  local cuesInterrupt = #played
  assert_eq(COB.Toasts:Push({
    kind = "system", text = "interrupt", interrupt = true, priority = 99,
  }), true, "interrupt Push accepted")
  assert_eq(COB.Toasts.frame.text:GetText(), "interrupt",
    "showing text is the interrupter")
  assert_eq(COB.Toasts:ShowingKind(), "system", "interrupter kind is system")
  assert_eq(COB.Toasts:PendingCount(), 1, "queued row stays pending")
  assert_eq(COB.Toasts.frame:IsShown(), true, "interrupter is shown")
  assert_eq(#played, cuesInterrupt, "interrupt Hide plays no sound")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "interrupt does not re-register ChurchOfBeefToast")
  assert_eq(findButton(COB.Toasts.frame), nil, "interrupt path adds no close button")

  -- B23-C: Init early-return re-registers ChurchOfBeefToast after a
  -- wiped UISpecialFrames. Do not replace an existing OnHide. First-create
  -- uniqueness pins stay. Isolation wrap stays. B26-B restores a missing
  -- script via wireSmallOnHide.
  local earlyInit = src:match("function Toasts:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
  assert_true(type(earlyInit) == "string" and earlyInit ~= "",
    "Init early-return body is readable")
  assert_true(earlyInit:find('rememberSpecial("ChurchOfBeefToast")', 1, true) ~= nil,
    "early-return rememberSpecial ChurchOfBeefToast")
  assert_true(earlyInit:find("wireSmallOnHide", 1, true) ~= nil,
    "early-return wireSmallOnHide")
  assert_eq(earlyInit:find("SetScript", 1, true), nil,
    "early-return does not SetScript inline")
  assert_eq(earlyInit:find("hideTheater", 1, true), nil,
    "early-return does not hideTheater")
  assert_eq(earlyInit:find("PlaySound", 1, true), nil,
    "early-return does not PlaySound")
  assert_true(src:find("interrupt = false", 1, true) ~= nil,
    "default KINDS stay interrupt = false")
  assert_true(src:find("if not self.showing then return", 1, true) ~= nil,
    "OnHide idle-return when showing is nil stays")

  COB.Toasts:Init()
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "first-create uniqueness: ChurchOfBeefToast once before wipe")
  local toastOnHide = COB.Toasts.frame:GetScript("OnHide")
  local savedSpecial = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefToast"), 0,
    "wipe clears ChurchOfBeefToast")
  local cuesWipe = #played
  assert_eq(COB.Toasts:Init(), COB.Toasts.frame,
    "second Init returns the existing frame")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "wiped UISpecialFrames + second Init lists ChurchOfBeefToast once")
  assert_eq(COB.Toasts.frame:GetScript("OnHide"), toastOnHide,
    "early-return does not re-wire OnHide")
  assert_eq(#played, cuesWipe, "second Init plays no sound")
  assert_eq(findButton(COB.Toasts.frame), nil, "wipe remount adds no close button")
  COB.Toasts:Init()
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "third Init after wipe does not duplicate ChurchOfBeefToast")
  UISpecialFrames = savedSpecial

  -- B26-B: nil the OnHide, second Init restores the idle-return handler.
  -- Third Init with the script already set keeps identity. Do not rebuild.
  -- Wipe uniqueness / B23-C pins stay. Isolation wrap stays.
  theaterReset()
  assert_true(COB.Toasts.frame ~= nil, "ResetForTests keeps the small toast frame")
  COB.Toasts.frame:SetScript("OnHide", nil)
  assert_eq(COB.Toasts.frame:GetScript("OnHide"), nil,
    "OnHide niled before second Init")
  local cuesRestore = #played
  local existingToast = COB.Toasts.frame
  assert_eq(COB.Toasts:Init(), existingToast,
    "niled OnHide Init returns the existing frame")
  local restoredOnHide = COB.Toasts.frame:GetScript("OnHide")
  assert_true(restoredOnHide ~= nil, "second Init restores missing OnHide")
  assert_eq(#played, cuesRestore, "restore Init plays no sound")
  assert_eq(countSpecial("ChurchOfBeefToast"), 1,
    "restore Init does not duplicate ChurchOfBeefToast")
  assert_eq(findButton(COB.Toasts.frame), nil, "restore remount adds no close button")
  COB.Toasts:Init()
  assert_eq(COB.Toasts.frame:GetScript("OnHide"), restoredOnHide,
    "third Init does not replace OnHide")
  assert_eq(COB.Toasts.frame, existingToast, "third Init does not rebuild")

  assert_eq(COB.Toasts:Show("restore one"), true, "first toast after restore")
  assert_eq(COB.Toasts:Show("restore two"), true, "second toast queues after restore")
  COB.Toasts.frame:Hide()
  assert_eq(COB.Toasts.frame.text:GetText(), "restore two",
    "restored OnHide still pumps")
  assert_eq(COB.Toasts:PendingCount(), 0, "restore pump advances one")
  COB.Toasts.frame:Hide()
  assert_eq(COB.Toasts:ShowingKind(), nil, "restored OnHide idle-returns after last")
  assert_eq(COB.Toasts.frame:IsShown(), false, "last restore Hide()s the small toast")

  -- B24-C / B27-C: UI:Init early-return re-registers ChurchOfBeefFrame
  -- after a wiped UISpecialFrames and may call wireShellOnHide when
  -- OnHide is missing. SetScript lives in the helper. Do not rebuild.
  -- Do not re-wire OnShow. First-create / rebuild uniqueness pins stay.
  -- Isolation wrap stays.
  local shellEarly = shellSrc:match("function UI:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
  assert_true(type(shellEarly) == "string" and shellEarly ~= "",
    "UI:Init early-return body is readable")
  assert_true(shellEarly:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "early-return rememberSpecial FRAME_NAME")
  assert_true(shellEarly:find("wireShellOnHide", 1, true) ~= nil,
    "early-return wireShellOnHide")
  assert_eq(shellEarly:find("SetScript", 1, true), nil,
    "early-return does not SetScript inline")
  assert_eq(shellEarly:find("OnShow", 1, true), nil,
    "early-return does not re-wire OnShow")
  assert_eq(shellEarly:find("buildFrame", 1, true), nil,
    "early-return does not rebuild")
  assert_eq(shellEarly:find("PlaySound", 1, true), nil,
    "early-return does not PlaySound")
  assert_eq(shellSrc:find("PlaySound", 1, true), nil,
    "Quiet shell still has no PlaySound")
  assert_true(shellSrc:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "B15-C uniqueness: Init still rememberSpecial FRAME_NAME")
  assert_true(shellSrc:find("local function wireShellOnHide", 1, true) ~= nil,
    "source has wireShellOnHide")
  local wireShell = shellSrc:match("local function wireShellOnHide%(frame%)(.-)\nfunction UI:Init")
  assert_true(type(wireShell) == "string" and wireShell ~= "",
    "wireShellOnHide body is readable")
  if type(wireShell) ~= "string" then wireShell = "" end
  assert_true(wireShell:find("SetScript", 1, true) ~= nil,
    "wireShellOnHide holds SetScript")
  assert_true(wireShell:find("_StopSizing", 1, true) ~= nil,
    "wireShellOnHide calls _StopSizing")
  assert_true(wireShell:find("shown = false", 1, true) ~= nil,
    "wireShellOnHide persists shown = false")
  assert_eq(wireShell:find("OnShow", 1, true), nil,
    "wireShellOnHide does not touch OnShow")
  assert_eq(wireShell:find("PlaySound", 1, true), nil,
    "wireShellOnHide does not PlaySound")
  assert_eq(wireShell:find("buildFrame", 1, true), nil,
    "wireShellOnHide does not rebuild")

  COB.UI:Init()
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "first-create uniqueness: ChurchOfBeefFrame once before wipe")
  local shellOnShow = COB.UI.frame:GetScript("OnShow")
  local shellOnHide = COB.UI.frame:GetScript("OnHide")
  local existingShell = COB.UI.frame
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefFrame"), 0,
    "wipe clears ChurchOfBeefFrame")
  local cuesShellWipe = #played
  assert_eq(COB.UI:Init(), existingShell,
    "second Init returns the existing frame")
  assert_eq(COB.UI.frame, existingShell,
    "early-return does not rebuild the Quiet shell")
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "wiped UISpecialFrames + second Init lists ChurchOfBeefFrame once")
  assert_eq(COB.UI.frame:GetScript("OnShow"), shellOnShow,
    "early-return does not re-wire OnShow")
  assert_eq(COB.UI.frame:GetScript("OnHide"), shellOnHide,
    "early-return does not re-wire OnHide")
  assert_eq(#played, cuesShellWipe, "second Init plays no sound")
  COB.UI:Init()
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "third Init after wipe does not duplicate ChurchOfBeefFrame")
  UISpecialFrames = savedSpecial

  -- B27-C: nil the shell OnHide, second Init restores. Third Init with
  -- the script already set keeps identity. Do not rebuild. Do not
  -- re-wire OnShow. Wipe uniqueness / B24-C rememberSpecial / B26-B
  -- toast pins stay. Isolation wrap stays.
  assert_true(COB.UI.frame ~= nil, "Quiet shell frame still exists")
  COB.UI.frame:SetScript("OnHide", nil)
  assert_eq(COB.UI.frame:GetScript("OnHide"), nil,
    "OnHide niled before second Init")
  local cuesShellRestore = #played
  assert_eq(COB.UI:Init(), existingShell,
    "niled OnHide Init returns the existing frame")
  local restoredShellOnHide = COB.UI.frame:GetScript("OnHide")
  assert_true(restoredShellOnHide ~= nil, "second Init restores missing OnHide")
  assert_eq(COB.UI.frame, existingShell, "restore Init does not rebuild")
  assert_eq(COB.UI.frame:GetScript("OnShow"), shellOnShow,
    "restore Init does not re-wire OnShow")
  assert_eq(#played, cuesShellRestore, "restore Init plays no sound")
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "restore Init does not duplicate ChurchOfBeefFrame")
  COB.UI:Init()
  assert_eq(COB.UI.frame:GetScript("OnHide"), restoredShellOnHide,
    "third Init does not replace OnHide")
  assert_eq(COB.UI.frame, existingShell, "third Init does not rebuild")

  ChurchOfBeefDB.ui.shown = true
  COB.UI._sizing = true
  COB.UI.frame:Show()
  COB.UI.frame:Hide()
  assert_eq(ChurchOfBeefDB.ui.shown, false,
    "restored OnHide persists shown = false")
  assert_eq(COB.UI._sizing, false, "restored OnHide calls _StopSizing")

  -- B29-D: applyHeadlineFont is called from Proclaim, not only InitTheater.
  -- Hidden / refused Proclaim does not need it. Display face is
  -- Theme:FontPath("display"). Fallback GameFontNormalLarge stays.
  -- No MORPHEUS_CYR. No new cue names. No PlaySound.
  assert_eq(src:find("HEADLINE_FONT", 1, true), nil,
    "HEADLINE_FONT local is gone — Theme:FontPath owns the display face")
  assert_true(src:find('FontPath("display")', 1, true) ~= nil,
    "display face is Theme:FontPath")
  assert_eq(src:find("MORPHEUS_CYR", 1, true), nil,
    "source does not use GlueFonts MORPHEUS_CYR")
  assert_true(src:find("GameFontNormalLarge", 1, true) ~= nil,
    "headline fallback stays GameFontNormalLarge")
  assert_eq(src:find("PlaySound(", 1, true), nil,
    "B29-D source does not PlaySound")
  local proclaimAt = src:find("function Toasts:Proclaim", 1, true)
  assert_true(proclaimAt ~= nil, "Proclaim exists")
  local proclaimEnd = src:find("\nlocal function wireSmallOnHide", proclaimAt + 1, true)
  assert_true(proclaimEnd ~= nil, "Proclaim body has a following function")
  local proclaimBody = src:sub(proclaimAt, proclaimEnd - 1)
  assert_true(proclaimBody:find("applyHeadlineFont", 1, true) ~= nil,
    "Proclaim re-applies headline font on a shown beat")
  local initTheaterAt = src:find("function Toasts:InitTheater", 1, true)
  assert_true(initTheaterAt ~= nil, "InitTheater exists")
  local initTheaterEnd = src:find("\nfunction Toasts:Proclaim", initTheaterAt + 1, true)
  assert_true(initTheaterEnd ~= nil, "InitTheater body has a following function")
  local initTheaterBody = src:sub(initTheaterAt, initTheaterEnd - 1)
  assert_true(initTheaterBody:find("applyHeadlineFont", 1, true) ~= nil,
    "InitTheater still applies headline font")

  -- B31-C: UI:Show remounts a missing OnHide when the frame exists.
  -- wireShellOnHide + rememberSpecial(FRAME_NAME) before Show. Do not
  -- replace an existing script. Do not rebuild. Init remount stays.
  -- FRAME_NAME is ChurchOfBeefFrame. No PlaySound / IG_CHARACTER_INFO_*.
  local showBody = shellSrc:match("function UI:Show%(%)(.-)\nfunction UI:Hide")
  assert_true(type(showBody) == "string" and showBody ~= "",
    "UI:Show body is readable")
  assert_true(showBody:find("wireShellOnHide", 1, true) ~= nil,
    "Show calls wireShellOnHide")
  assert_true(showBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "Show rememberSpecial FRAME_NAME")
  local showWireAt = showBody:find("wireShellOnHide", 1, true)
  local showRememberAt = showBody:find("rememberSpecial(FRAME_NAME)", 1, true)
  local showFrameAt = showBody:find("self.frame:Show()", 1, true)
  assert_true(showWireAt ~= nil and showFrameAt ~= nil and showWireAt < showFrameAt,
    "Show wires OnHide before frame:Show")
  assert_true(showRememberAt ~= nil and showFrameAt ~= nil and showRememberAt < showFrameAt,
    "Show rememberSpecial before frame:Show")
  assert_eq(showBody:find("SetScript", 1, true), nil,
    "Show does not SetScript inline")
  assert_eq(showBody:find("OnShow", 1, true), nil,
    "Show does not re-wire OnShow")
  assert_eq(showBody:find("buildFrame", 1, true), nil,
    "Show does not rebuild")
  assert_eq(showBody:find("PlaySound", 1, true), nil,
    "Show does not PlaySound")
  assert_true(shellSrc:find('FRAME_NAME = "ChurchOfBeefFrame"', 1, true) ~= nil,
    "FRAME_NAME stays ChurchOfBeefFrame")
  assert_eq(shellSrc:find("IG_CHARACTER_INFO", 1, true), nil,
    "Show remount still has no IG_CHARACTER_INFO")

  assert_true(COB.UI.frame ~= nil, "Quiet shell frame still exists for Show remount")
  local showOnShow = COB.UI.frame:GetScript("OnShow")
  local existingShowShell = COB.UI.frame
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefFrame"), 0,
    "wipe clears ChurchOfBeefFrame before Show remount")
  COB.UI.frame:SetScript("OnHide", nil)
  assert_eq(COB.UI.frame:GetScript("OnHide"), nil,
    "OnHide niled before Show")
  local cuesShowRestore = #played
  COB.UI:Show()
  local restoredShowOnHide = COB.UI.frame:GetScript("OnHide")
  assert_true(restoredShowOnHide ~= nil, "Show restores missing OnHide")
  assert_eq(COB.UI.frame, existingShowShell, "Show remount does not rebuild")
  assert_eq(COB.UI.frame:GetScript("OnShow"), showOnShow,
    "Show remount does not re-wire OnShow")
  assert_eq(#played, cuesShowRestore, "Show remount plays no sound")
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "Show remounts ChurchOfBeefFrame after wipe")
  COB.UI:Show()
  assert_eq(COB.UI.frame:GetScript("OnHide"), restoredShowOnHide,
    "third Show does not replace OnHide")
  assert_eq(COB.UI.frame, existingShowShell, "third Show does not rebuild")
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "third Show does not duplicate ChurchOfBeefFrame")
  UISpecialFrames = savedSpecial

  ChurchOfBeefDB.ui.shown = true
  COB.UI._sizing = true
  COB.UI.frame:Hide()
  assert_eq(ChurchOfBeefDB.ui.shown, false,
    "Show-restored OnHide persists shown = false")
  assert_eq(COB.UI._sizing, false, "Show-restored OnHide calls _StopSizing")

  -- B35-D: UI:Hide remounts a missing OnHide when the frame exists.
  -- wireShellOnHide + rememberSpecial(FRAME_NAME) before frame:Hide.
  -- Do not replace an existing script. Do not rebuild. No OnShow
  -- re-wire. FRAME_NAME is ChurchOfBeefFrame. Inputs stay off
  -- UISpecialFrames. No PlaySound / IG_CHARACTER_INFO_*.
  local hideBody = shellSrc:match("function UI:Hide%(%)(.-)\nfunction UI:IsShown")
  assert_true(type(hideBody) == "string" and hideBody ~= "",
    "UI:Hide body is readable")
  assert_true(hideBody:find("wireShellOnHide", 1, true) ~= nil,
    "Hide calls wireShellOnHide")
  assert_true(hideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "Hide rememberSpecial FRAME_NAME")
  local hideWireAt = hideBody:find("wireShellOnHide", 1, true)
  local hideRememberAt = hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
  local hideFrameAt = hideBody:find("self.frame:Hide()", 1, true)
  assert_true(hideWireAt ~= nil and hideFrameAt ~= nil and hideWireAt < hideFrameAt,
    "Hide wires OnHide before frame:Hide")
  assert_true(hideRememberAt ~= nil and hideFrameAt ~= nil and hideRememberAt < hideFrameAt,
    "Hide rememberSpecial before frame:Hide")
  assert_true(hideBody:find("_StopSizing", 1, true) ~= nil,
    "Hide still calls _StopSizing")
  assert_eq(hideBody:find("SetScript", 1, true), nil,
    "Hide does not SetScript inline")
  assert_eq(hideBody:find("OnShow", 1, true), nil,
    "Hide does not re-wire OnShow")
  assert_eq(hideBody:find("buildFrame", 1, true), nil,
    "Hide does not rebuild")
  assert_eq(hideBody:find("PlaySound", 1, true), nil,
    "Hide does not PlaySound")
  assert_true(shellSrc:find('FRAME_NAME = "ChurchOfBeefFrame"', 1, true) ~= nil,
    "FRAME_NAME stays ChurchOfBeefFrame")
  assert_eq(hideBody:find("IG_CHARACTER_INFO", 1, true), nil,
    "Hide remount has no IG_CHARACTER_INFO")

  assert_true(COB.UI.frame ~= nil, "Quiet shell frame still exists for Hide remount")
  COB.UI:Show()
  local hideOnShow = COB.UI.frame:GetScript("OnShow")
  local existingHideShell = COB.UI.frame
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefFrame"), 0,
    "wipe clears ChurchOfBeefFrame before Hide remount")
  COB.UI.frame:SetScript("OnHide", nil)
  assert_eq(COB.UI.frame:GetScript("OnHide"), nil,
    "OnHide niled before Hide")
  ChurchOfBeefDB.ui.shown = true
  local cuesHideRestore = #played
  COB.UI:Hide()
  local restoredHideOnHide = COB.UI.frame:GetScript("OnHide")
  assert_true(restoredHideOnHide ~= nil, "Hide restores missing OnHide")
  assert_eq(ChurchOfBeefDB.ui.shown, false,
    "Hide remount persists shown = false")
  assert_eq(COB.UI.frame, existingHideShell, "Hide remount does not rebuild")
  assert_eq(COB.UI.frame:GetScript("OnShow"), hideOnShow,
    "Hide remount does not re-wire OnShow")
  assert_eq(#played, cuesHideRestore, "Hide remount plays no sound")
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "Hide remounts ChurchOfBeefFrame after wipe")
  assert_eq(countSpecial("ChurchOfBeefInputs"), 0,
    "Hide remount leaves Inputs off UISpecialFrames")
  COB.UI:Hide()
  assert_eq(COB.UI.frame:GetScript("OnHide"), restoredHideOnHide,
    "third Hide does not replace OnHide")
  assert_eq(COB.UI.frame, existingHideShell, "third Hide does not rebuild")
  assert_eq(countSpecial("ChurchOfBeefFrame"), 1,
    "third Hide does not duplicate ChurchOfBeefFrame")
  UISpecialFrames = savedSpecial

  -- B40-D: already-hidden Hide still writes shown = false via uiDb
  -- (same slot as OnHide) even when OnHide does not fire again.
  -- Keep remount. Do not replace an existing OnHide. Do not rebuild.
  -- No OnShow re-wire. Inputs stay off UISpecialFrames.
  -- No PlaySound / IG_CHARACTER_INFO_*.
  assert_true(hideBody:find("uiDb()", 1, true) ~= nil,
    "Hide writes shown via uiDb")
  assert_true(hideBody:find("shown = false", 1, true) ~= nil,
    "Hide persists shown = false on the body")
  assert_true(hideWireAt ~= nil and hideBody:find("uiDb()", 1, true) ~= nil
      and hideBody:find("uiDb()", 1, true) > hideWireAt,
    "Hide writes shown after remount")
  assert_true(hideRememberAt ~= nil and hideBody:find("uiDb()", 1, true) ~= nil
      and hideBody:find("uiDb()", 1, true) > hideRememberAt,
    "Hide writes shown after rememberSpecial")
  assert_eq(hideBody:find("OnShow", 1, true), nil,
    "already-hidden persist does not re-wire OnShow")
  assert_eq(hideBody:find("SetScript", 1, true), nil,
    "already-hidden persist does not SetScript inline")
  assert_eq(hideBody:find("buildFrame", 1, true), nil,
    "already-hidden persist does not rebuild")
  assert_eq(hideBody:find("PlaySound", 1, true), nil,
    "already-hidden persist does not PlaySound")
  assert_eq(hideBody:find("IG_CHARACTER_INFO", 1, true), nil,
    "already-hidden persist has no IG_CHARACTER_INFO")

  assert_true(COB.UI.frame ~= nil, "Quiet shell still exists for already-hidden persist")
  assert_eq(COB.UI.frame:IsShown(), false, "shell is already hidden")
  hideOnShow = COB.UI.frame:GetScript("OnShow")
  existingHideShell = COB.UI.frame
  COB.UI.frame:SetScript("OnHide", nil)
  assert_eq(COB.UI.frame:GetScript("OnHide"), nil,
    "OnHide niled while already hidden")
  ChurchOfBeefDB.ui.shown = true
  cuesHideRestore = #played
  COB.UI:Hide()
  restoredHideOnHide = COB.UI.frame:GetScript("OnHide")
  assert_true(restoredHideOnHide ~= nil,
    "already-hidden Hide remounts missing OnHide")
  assert_eq(ChurchOfBeefDB.ui.shown, false,
    "already-hidden Hide persists shown = false")
  assert_eq(COB.UI.frame, existingHideShell, "already-hidden Hide does not rebuild")
  assert_eq(COB.UI.frame:GetScript("OnShow"), hideOnShow,
    "already-hidden Hide does not re-wire OnShow")
  assert_eq(#played, cuesHideRestore, "already-hidden Hide plays no sound")
  assert_eq(countSpecial("ChurchOfBeefInputs"), 0,
    "already-hidden Hide leaves Inputs off UISpecialFrames")
  COB.UI:Hide()
  assert_eq(COB.UI.frame:GetScript("OnHide"), restoredHideOnHide,
    "second already-hidden Hide does not replace OnHide")
  assert_eq(COB.UI.frame, existingHideShell,
    "second already-hidden Hide does not rebuild")
  assert_eq(ChurchOfBeefDB.ui.shown, false,
    "second already-hidden Hide keeps shown = false")

  -- U-D: Theme-sourced dress slots. Nested here (200-local). Engine pins above
  -- stay. Stub GetTexture/GetVertexColor are no-ops; slots record _cobPath
  -- / accent floats from Theme at apply time.
  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-D sanction dress")
  UIParent:SetWidth(1200)
  UIParent:SetHeight(800)
  assert_eq(COB.Toasts:Proclaim("sanction", {
    fighterA = "Juicyj", fighterB = "Meat Is Murder",
  }), true, "U-D sanction dress Proclaim")
  assert_eq(COB.Toasts.theater.seal._cobName, "seal_papal",
    "U-D sanction seal slot name")
  assert_eq(COB.Toasts.theater.seal._cobPath, COB.Theme:Texture("seal_papal"),
    "U-D sanction seal slot path")
  assert_eq(COB.Toasts.theater.center._cobPath, COB.Theme:Texture("frame_proclamation_center"),
    "U-D sanction parchment center is Theme frame_proclamation_center")
  assert_eq(COB.Toasts.theater.cornerTL._cobPath,
    COB.Theme:Texture("frame_proclamation_corner_tl"),
    "U-D sanction 9-slice corner is Theme-sourced")
  assert_eq(COB.Toasts.theater.headlineFontPath, COB.Theme:FontPath("display"),
    "U-D sanction headline is Theme display")
  assert_true(COB.Toasts.theater.dimAlpha <= 0.5, "U-D sanction dim is ≤ 0.5")
  assert_eq(findButton(COB.Toasts.theater.root), nil, "U-D sanction has no close button")
  assert_eq(COB.Toasts.theater.rays:IsShown(), false, "U-D sanction hides rays")

  local function expectAccent(role, label)
    local r, g, b = COB.Theme:Color(role)
    assert_eq(COB.Toasts.theater.accentRole, role, label .. " role")
    assert_eq(COB.Toasts.theater.accentR, r, label .. " r")
    assert_eq(COB.Toasts.theater.accentG, g, label .. " g")
    assert_eq(COB.Toasts.theater.accentB, b, label .. " b")
    assert_eq(COB.Toasts.theater.seal._cobR, r, label .. " seal r")
    assert_eq(COB.Toasts.theater.tint._cobR, r, label .. " tint r")
    assert_eq(COB.Toasts.theater.tint._cobG, g, label .. " tint g")
    assert_eq(COB.Toasts.theater.tint._cobB, b, label .. " tint b")
  end

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-D cowardice dress")
  assert_eq(COB.Toasts:Proclaim("cowardice", { name = "Thickcut" }), true,
    "U-D cowardice dress Proclaim")
  assert_eq(COB.Toasts.theater.seal._cobName, "seal_cowardice",
    "U-D cowardice seal slot name")
  assert_eq(COB.Toasts.theater.seal._cobPath, COB.Theme:Texture("seal_cowardice"),
    "U-D cowardice seal slot path")
  expectAccent("oxblood", "U-D cowardice")
  assert_eq(findButton(COB.Toasts.theater.root), nil, "U-D cowardice has no close button")

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-D victor dress")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "victor", name = "Thickcut" }), true,
    "U-D victor dress Proclaim")
  assert_eq(COB.Toasts.theater.seal._cobName, "seal_victor",
    "U-D victor seal slot name")
  assert_eq(COB.Toasts.theater.seal._cobPath, COB.Theme:Texture("seal_victor"),
    "U-D victor seal slot path")
  expectAccent("gold", "U-D victor")
  assert_eq(COB.Toasts.theater.headline:GetText(), "VICTOR DECLARED",
    "U-D victor headline stays VICTOR DECLARED")
  assert_eq(chatLines[1], "Victor declared: Thickcut. So ruled by the Beef Pope.",
    "U-D B9-D chat echo stays byte-identical")
  assert_eq(findButton(COB.Toasts.theater.root), nil, "U-D victor has no close button")
  assert_eq(COB.Toasts.theater.rays:IsShown(), false, "U-D victor hides rays")

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-D knighting dress")
  assert_eq(COB.Toasts:Proclaim("knighting", { name = "Beefina" }), true,
    "U-D knighting dress Proclaim")
  assert_eq(COB.Toasts.theater.rays:IsShown(), true, "U-D knighting shows rays")
  assert_eq(COB.Toasts.theater.rays._cobName, "rays_sunburst",
    "U-D knighting rays slot name")
  assert_eq(COB.Toasts.theater.rays._cobPath, COB.Theme:Texture("rays_sunburst"),
    "U-D knighting rays slot path")
  assert_eq(COB.Toasts.theater.rays._blend, "ADD", "U-D knighting rays stay ADD")
  assert_eq(COB.Toasts.theater.banner:IsShown(), true, "U-D knighting shows banner")
  assert_eq(COB.Toasts.theater.banner._cobPath, COB.Theme:Texture("banner_knighting"),
    "U-D knighting banner slot path")
  assert_eq(COB.Toasts.theater.headlineFontPath, COB.Theme:FontPath("display"),
    "U-D knighting headline is Theme display")
  expectAccent("gold", "U-D knighting")
  assert_true(COB.Toasts.theater.dimAlpha <= 0.5, "U-D knighting dim is ≤ 0.5")
  assert_eq(findButton(COB.Toasts.theater.root), nil, "U-D knighting has no close button")

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-D elevation dress")
  assert_eq(COB.Toasts:Proclaim("elevation", { name = "Juicyj" }), true,
    "U-D elevation dress Proclaim")
  assert_eq(COB.Toasts.theater.rays:IsShown(), true, "U-D elevation shows rays")
  assert_eq(COB.Toasts.theater.banner:IsShown(), true, "U-D elevation shows banner")
  assert_eq(COB.Toasts.theater.rays._cobPath, COB.Theme:Texture("rays_sunburst"),
    "U-D elevation rays slot path")
  expectAccent("gold", "U-D elevation")
  assert_eq(findButton(COB.Toasts.theater.root), nil, "U-D elevation has no close button")

  if standalone then
    assert_eq(COB.Console, nil, "isolation still does not load Console")
    assert_eq(COB.Hud, nil, "isolation still does not load Hud")
    assert_eq(COB.RecordsBook, nil, "isolation still does not load Records Book")
    assert_eq(COB.Gora, nil, "isolation still does not load Gora")
  end
end
runB12D()

theaterReset()
assert_eq(COB.Toasts:Push({ kind = "system", text = "system still lives" }), true,
  "system Push stays green after theater")
assert_eq(COB.Toasts:ShowingKind(), "system", "system kind still queues")
assert_eq(COB.Toasts.frame.text:GetText(), "system still lives", "system toast text is unchanged")
assert_eq(COB.Toasts.frame.text._template, "GameFontNormal",
  "system toast stays GameFont* — Morpheus is Proclaim headlines only")
COB.Toasts:ResetForTests()

COB.Sound.Play = origSoundPlay
PlaySound = savedPlaySound
PlaySoundFile = savedPlaySoundFile
DEFAULT_CHAT_FRAME = savedChatFrame

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
