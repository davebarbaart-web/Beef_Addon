-- Proclaim theater: Event Mode sanction / verdict / cowardice / knighting /
-- elevation beats (Lane T: the one toast engine). The small-toast engine
-- (Toasts:Show / Push / Celebrate, the queue, the ChurchOfBeefToast frame)
-- is retired — it had zero callers. Quiet-shell and Status-chip pins died
-- with their subjects (MainFrame.lua / Status.lua are deleted).
-- B12-D Proclaim ESC, B18-C HideAll theaterGen, B39-C HideAll remount,
-- B41-D existing-theater Init remount, B29-D Proclaim re-applies
-- applyHeadlineFont (Theme:FontPath display), and the U-Q proclamation
-- ink / wrap / ribbon / halo pins live in runB12D() (Lua 5.1 200-local cap).
-- Isolated: wow_ui_stub + Common + Theme + Toasts; Runtime and Sound are
-- dofiled later for the Quiet / cue pins. Standalone wrap.
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
dofile("addon/ChurchOfBeef/UI/Toasts.lua")

local COB = ChurchOfBeef

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

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
  assert_eq(COB.UI, nil, "the Quiet shell is retired — no COB.UI")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.FighterCard, nil, "isolated suite does not load FighterCard")
  assert_eq(COB.Inputs, nil, "isolated suite does not load Inputs")
  assert_eq(COB.Markers, nil, "isolated suite does not load Markers")
  assert_eq(COB.DecreeBanner, nil, "isolated suite does not load Decree UI")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Roster, nil, "isolated suite does not load Roster")
end

--------------------------------------------------------------------------------
-- One toast engine: the small-toast surface is gone, Proclaim theater stays
--------------------------------------------------------------------------------
assert_eq(type(COB.Toasts.Proclaim), "function", "Proclaim is the theatrical entry")
assert_eq(COB.Toasts.MODE, "Event", "Toasts declares Event Mode")
assert_eq(type(COB.Toasts.InitTheater), "function", "InitTheater builds the overlay")
assert_eq(type(COB.Toasts.HideAll), "function", "HideAll tears theater down")
assert_eq(type(COB.Toasts.Init), "function", "Init lives on the theater")
assert_eq(COB.Toasts.Show, nil, "small-toast Show is retired")
assert_eq(COB.Toasts.Push, nil, "small-toast Push is retired")
assert_eq(COB.Toasts.Celebrate, nil, "small-toast Celebrate is retired")
assert_eq(COB.Toasts.PendingCount, nil, "the small-toast queue is retired")
assert_eq(COB.Toasts.ShowingKind, nil, "the small-toast showing readout is retired")
assert_eq(COB.Toasts.frame, nil, "no small ChurchOfBeefToast frame exists")

assert_eq(countSpecial("ChurchOfBeefToast"), 0, "no small toast on UISpecialFrames")
local initFrame = COB.Toasts:Init()
assert_true(initFrame ~= nil, "Init builds the theater")
assert_eq(COB.Toasts:Init(), initFrame, "Init is idempotent")
assert_eq(COB.Toasts.frame, nil, "Init still mints no small toast frame")
assert_eq(countSpecial("ChurchOfBeefToast"), 0, "Init lists no small toast frame")
assert_eq(countSpecial("ChurchOfBeefProclaim"), 1, "Init lists the proclaim root once")
assert_true(COB.Toasts.theater ~= nil and COB.Toasts.theater.root ~= nil,
  "Init mints the theatrical root")
assert_true(
  COB.Toasts.theater ~= nil and COB.Toasts.theater.root ~= nil
    and COB.Toasts.theater.root:IsShown() == false,
  "theater starts hidden"
)

local toastSrcFile = io.open("addon/ChurchOfBeef/UI/Toasts.lua", "r")
assert_true(toastSrcFile ~= nil, "Toasts.lua is readable")
local toastSrc = toastSrcFile:read("*a")
toastSrcFile:close()
assert_eq(toastSrc:find("function Toasts:Show(", 1, true), nil, "source has no Toasts:Show")
assert_eq(toastSrc:find("function Toasts:Push(", 1, true), nil, "source has no Toasts:Push")
assert_eq(toastSrc:find("function Toasts:Celebrate(", 1, true), nil,
  "source has no Toasts:Celebrate")
assert_eq(toastSrc:find("ChurchOfBeefToast", 1, true), nil,
  "source never names the retired small toast frame")
assert_eq(toastSrc:find("wireSmallOnHide", 1, true), nil,
  "source has no small-toast OnHide wiring")
assert_eq(toastSrc:find("local KINDS", 1, true), nil, "small-toast KINDS table is gone")
assert_eq(toastSrc:find("local pending", 1, true), nil, "the small-toast queue is gone")
assert_eq(toastSrc:find("SendChatMessage(", 1, true), nil, "source never SendChatMessage")
assert_true(toastSrc:find('root:EnableMouse(true)', 1, true) ~= nil,
  "proclaim root EnableMouse true")
assert_eq(toastSrc:find("root:EnableMouse(false)", 1, true), nil,
  "proclaim root is not click-through")
assert_true(toastSrc:find('OnMouseUp', 1, true) ~= nil,
  "proclaim click dismisses")
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
assert_eq(toastSrc:find("The Pope ruled.", 1, true), nil,
  "source does not write The Pope ruled.")
assert_eq(toastSrc:find("_HandleState", 1, true), nil,
  "Toasts does not handle inbound STATE")
assert_eq(toastSrc:find("HandleState", 1, true), nil,
  "Toasts does not wire inbound STATE")
assert_eq(toastSrc:find("SendState", 1, true), nil,
  "Toasts does not send STATE")
assert_true(toastSrc:find("This fight does not count.", 1, true) ~= nil,
  "void gloss is This fight does not count.")
assert_true(toastSrc:find("fled", 1, true) ~= nil,
  "cowardice headline says fled")
assert_true(toastSrc:find("A sanctioned duel.", 1, true) ~= nil,
  "sanction adds a plain sanctioned duel line")
assert_true(toastSrc:find("Free ruling.", 1, true) ~= nil,
  "free ruling keeps the clerical default")

--------------------------------------------------------------------------------
-- V-B + B3-A + B5-D + U-D: sanction / verdict / cowardice / knighting / elevation.
-- Proclaim only. Runtime + Sound are loaded here (not wired from Console /
-- Gora / Knighting). Headlines resolve via Theme:FontPath.
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
assert_true(sanctionCopy:find("A sanctioned duel.", 1, true) ~= nil,
  "sanction body has one plain sanctioned duel line")
assert_true(COB.Toasts.theater.copy:GetText():find("A sanctioned duel.", 1, true) ~= nil,
  "sanctioned duel sits under the pomp headline")
assert_eq(sanctionCopy:find("Come as you are", 1, true), nil,
  "sanction does not print a stipulation")
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
assert_eq(theaterCopy(), "Cowardice recorded: Thickcut fled. So ruled by the Beef Pope.",
  "cowardice copy is the clerical sentence")
assert_eq(COB.Toasts.theater.headline:GetText(),
  "Cowardice recorded: Thickcut fled. So ruled by the Beef Pope.",
  "single-line cowardice sits on the headline")
assert_true((COB.Toasts.theater.headline:GetText() or ""):find("fled", 1, true) ~= nil,
  "cowardice headline says fled")
assert_eq(COB.Toasts.theater.copy:GetText(), "",
  "single-line cowardice has no body")
assert_eq(chatLines[1], "Cowardice recorded: Thickcut fled. So ruled by the Beef Pope.",
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
assert_eq(theaterCopy(), "This fight does not count.", "void copy is clerical")
assert_eq(COB.Toasts.theater.headline:GetText(), "This fight does not count.",
  "void headline is This fight does not count.")
assert_eq((theaterCopy() or ""):find("The Pope ruled.", 1, true), nil,
  "void does not write The Pope ruled.")

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
assert_eq((theaterCopy() or ""):find("The Pope ruled.", 1, true), nil,
  "free ruling does not write The Pope ruled.")

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
do
  local click = COB.Toasts.theater.root:GetScript("OnMouseUp")
  assert_true(type(click) == "function", "knighting click dismiss is wired")
  click(COB.Toasts.theater.root)
  assert_eq(COB.Toasts.theater.root:IsShown(), false, "knighting click hides the overlay")
end
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
do
  local click = COB.Toasts.theater.root:GetScript("OnMouseUp")
  assert_true(type(click) == "function", "elevation click dismiss is wired")
  click(COB.Toasts.theater.root)
  assert_eq(COB.Toasts.theater.root:IsShown(), false, "elevation click hides the overlay")
end
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

-- Nested so the main chunk stays under Lua 5.1's 200-local cap.
local function runB12D()
  local srcFile = io.open("addon/ChurchOfBeef/UI/Toasts.lua", "r")
  assert_true(srcFile ~= nil, "B12-D Toasts.lua is readable")
  local src = srcFile:read("*a")
  srcFile:close()
  assert_true(src:find("UISpecialFrames", 1, true) ~= nil,
    "source contains UISpecialFrames")
  assert_true(src:find("rememberSpecial(PROCLAIM_NAME)", 1, true) ~= nil,
    "source rememberSpecial PROCLAIM_NAME")
  assert_eq(src:find('insert(UISpecialFrames, "ChurchOfBeefProclaim")', 1, true), nil,
    "source does not insert ChurchOfBeefProclaim")
  assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
    "source does not PlaySound IG_CHARACTER_INFO_*")
  assert_eq(src:find("SendChatMessage(", 1, true), nil,
    "B12-D source never SendChatMessage")
  assert_true(src:find('FontPath("display")', 1, true) ~= nil,
    "B12-D headlines resolve via Theme display")
  assert_eq(src:find("MORPHEUS", 1, true), nil,
    "B12-D no hardcoded Morpheus")

  theaterReset()
  assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for Proclaim ESC")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Event Mode void for ESC register")
  assert_true(COB.Toasts.theater ~= nil and COB.Toasts.theater.root ~= nil,
    "Proclaim mints the theatrical root")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "UISpecialFrames contains ChurchOfBeefProclaim once")
  assert_eq(countSpecial("ChurchOfBeefToast"), 0,
    "the retired small toast never lists")
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
  assert_true(hideAllBody:find("hideTheater", 1, true) ~= nil,
    "HideAll calls hideTheater")

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

  -- B39-C: HideAll remounts ChurchOfBeefProclaim after a wiped
  -- UISpecialFrames. The retired small toast is never remounted.
  -- B18-C still plays no sound and still tears theater once.
  -- Do not add a close button. Do not PlaySound. No new main-chunk locals.
  assert_true(
    hideAllBody:find("rememberSpecial(PROCLAIM_NAME)", 1, true) ~= nil
      or hideAllBody:find('rememberSpecial("ChurchOfBeefProclaim")', 1, true) ~= nil,
    "HideAll remounts ChurchOfBeefProclaim")
  assert_eq(hideAllBody:find('rememberSpecial("ChurchOfBeefToast")', 1, true), nil,
    "HideAll does not remount the retired small toast")
  assert_eq(hideAllBody:find("PlaySound", 1, true), nil,
    "HideAll remount does not PlaySound")
  assert_eq(hideAllBody:find("CreateFrame", 1, true), nil,
    "HideAll remount does not rebuild")
  local savedSpecialHideAll = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 0,
    "wipe clears ChurchOfBeefProclaim before HideAll remount")
  local cuesHideAllRemount = #played
  COB.Toasts:HideAll()
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "wiped UISpecialFrames + HideAll lists ChurchOfBeefProclaim once")
  assert_eq(countSpecial("ChurchOfBeefToast"), 0,
    "HideAll never lists the retired small toast")
  assert_eq(#played, cuesHideAllRemount, "HideAll remount plays no sound")
  assert_eq(COB.Toasts.theater.root:IsShown(), false,
    "HideAll remount still tears theater once")
  assert_eq(findButton(COB.Toasts.theater.root), nil,
    "HideAll remount adds no close button")
  COB.Toasts:HideAll()
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "second HideAll does not duplicate ChurchOfBeefProclaim")
  assert_eq(#played, cuesHideAllRemount, "second HideAll plays no sound")
  UISpecialFrames = savedSpecialHideAll

  -- B41-D: existing-theater Init remounts ChurchOfBeefProclaim after a wiped
  -- UISpecialFrames. Init delegates to InitTheater; the early return keeps
  -- wireProclaimEsc. Do not add a close button. Do not PlaySound.
  -- Do not tear theater. Isolation wrap stays. No new main-chunk locals.
  local initTheaterBody = src:match(
    "function Toasts:InitTheater%(%)%s*\n%s*if self%.theater and self%.theater%.root then(.-)return self%.theater")
  assert_true(type(initTheaterBody) == "string" and initTheaterBody ~= "",
    "InitTheater early-return body is readable")
  assert_true(initTheaterBody:find("wireProclaimEsc", 1, true) ~= nil,
    "existing-theater InitTheater keeps wireProclaimEsc")
  assert_eq(initTheaterBody:find("PlaySound", 1, true), nil,
    "existing-theater InitTheater does not PlaySound")
  assert_eq(initTheaterBody:find("CreateFrame", 1, true), nil,
    "existing-theater InitTheater does not rebuild")
  local initBody = src:match("function Toasts:Init%(%)%s*\n(.-)\nend")
  assert_true(type(initBody) == "string" and initBody ~= "",
    "Init body is readable")
  assert_true(initBody:find("InitTheater", 1, true) ~= nil,
    "Init delegates to InitTheater")
  assert_eq(initBody:find('rememberSpecial("ChurchOfBeefToast")', 1, true), nil,
    "Init does not remount the retired small toast")
  assert_eq(initBody:find("PlaySound", 1, true), nil,
    "Init does not PlaySound")
  assert_eq(initBody:find("hideTheater", 1, true), nil,
    "Init does not tear theater")
  assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
    "Proclaim before Init remount")
  assert_eq(COB.Toasts.theater.root:IsShown(), true, "theater shown before Init remount")
  savedSpecialHideAll = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 0,
    "wipe clears ChurchOfBeefProclaim before Init remount")
  cuesHideAllRemount = #played
  assert_eq(COB.Toasts:Init(), COB.Toasts.theater,
    "Init remount returns the existing theater")
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "wiped UISpecialFrames + Init lists ChurchOfBeefProclaim once")
  assert_eq(#played, cuesHideAllRemount, "Init remount plays no sound")
  assert_eq(COB.Toasts.theater.root:IsShown(), true,
    "Init remount does not tear theater")
  assert_eq(findButton(COB.Toasts.theater.root), nil,
    "Init remount adds no close button")
  COB.Toasts:Init()
  assert_eq(countSpecial("ChurchOfBeefProclaim"), 1,
    "second Init does not duplicate ChurchOfBeefProclaim")
  assert_eq(#played, cuesHideAllRemount, "second Init plays no sound")
  assert_eq(COB.Toasts.theater.root:IsShown(), true,
    "second Init does not tear theater")
  UISpecialFrames = savedSpecialHideAll

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
  local proclaimEnd = src:find("\nfunction Toasts:HideAll", proclaimAt + 1, true)
  assert_true(proclaimEnd ~= nil, "Proclaim body has a following function")
  local proclaimBody = src:sub(proclaimAt, proclaimEnd - 1)
  assert_true(proclaimBody:find("applyHeadlineFont", 1, true) ~= nil,
    "Proclaim re-applies headline font on a shown beat")
  local initTheaterAt = src:find("function Toasts:InitTheater", 1, true)
  assert_true(initTheaterAt ~= nil, "InitTheater exists")
  local initTheaterEnd = src:find("\nfunction Toasts:Proclaim", initTheaterAt + 1, true)
  assert_true(initTheaterEnd ~= nil, "InitTheater body has a following function")
  local initTheaterFull = src:sub(initTheaterAt, initTheaterEnd - 1)
  assert_true(initTheaterFull:find("applyHeadlineFont", 1, true) ~= nil,
    "InitTheater still applies headline font")

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

  -- U-Q: charcoal ink, rule hairline, on-sheet seal, top ribbon,
  -- seal-halo rays, wrap-height for long blackletter, leftover 6/10/14.
  -- Nested (200-local). Engine / B9-D / Quiet-gate pins above stay.
  local function runUQ()
    assert_eq(src:find("px * 0.7", 1, true), nil,
      "U-Q wrap heuristic dropped the 0.7em char-split")
    assert_eq(src:find("10, -10", 1, true), nil,
      "U-Q leftover 10 toast pad is Theme.Space")
    assert_true(src:find("PROCLAIM_INSET = 12", 1, true) ~= nil,
      "U-Q 12px proclamation inset stays (art-cut)")
    assert_true(src:find('applyTextColor(theater.headline, "charcoal")', 1, true) ~= nil,
      "U-Q headline ink is charcoal")
    assert_true(src:find('applyTextColor(theater.copy, "charcoal")', 1, true) ~= nil,
      "U-Q body ink is charcoal")
    assert_eq(src:find('applyTextColor(theater.headline, "gold")', 1, true), nil,
      "U-Q never paints gold headline on parchment")
    assert_eq(src:find('applyTextColor(theater.copy, "gold")', 1, true), nil,
      "U-Q never paints gold body on parchment")
    assert_true(src:find('space("rule"', 1, true) ~= nil,
      "U-Q accent thickness is Theme.Space.rule")
    assert_true(src:find('space("seal"', 1, true) ~= nil,
      "U-Q seal size is Theme.Space.seal")
    assert_true(src:find('space("sm"', 1, true) ~= nil,
      "U-Q leftover 10 became Theme.Space.sm")

    local cr, cg, cb = COB.Theme:Color("charcoal")
    local gr, gg, gb = COB.Theme:Color("gold")
    local rule = COB.Theme.Space.rule
    local sealPx = COB.Theme.Space.seal
    local band = COB.Theme.Space.band
    local md = COB.Theme.Space.md

    theaterReset()
    assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-Q void floor")
    UIParent:SetWidth(1200)
    UIParent:SetHeight(800)
    assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "void" }), true,
      "U-Q void Proclaim")
    local voidH = COB.Toasts.theater.panel:GetHeight()
    assert_true(type(voidH) == "number" and voidH > 0, "U-Q void panel has height")
    assert_eq(COB.Toasts.theater.inkRole, "charcoal", "U-Q void ink role is charcoal")
    local hr, hg, hb = COB.Toasts.theater.headline:GetTextColor()
    assert_eq(hr, cr, "U-Q void headline r is charcoal")
    assert_eq(hg, cg, "U-Q void headline g is charcoal")
    assert_eq(hb, cb, "U-Q void headline b is charcoal")
    assert_true(hr ~= gr or hg ~= gg or hb ~= gb,
      "U-Q void headline is not gold on parchment")
    assert_eq(COB.Toasts.theater.tint:GetHeight(), rule,
      "U-Q accent is a Theme.Space.rule hairline")
    assert_eq(COB.Toasts.theater.seal:GetWidth(), sealPx,
      "U-Q seal width is Theme.Space.seal")
    assert_eq(COB.Toasts.theater.seal:GetHeight(), sealPx,
      "U-Q seal height is Theme.Space.seal")
    local _, sealRel = COB.Toasts.theater.seal:GetPoint(1)
    assert_eq(sealRel, COB.Toasts.theater.panel, "U-Q void seal sits on the sheet")
    local sealY
    _, _, _, _, sealY = COB.Toasts.theater.seal:GetPoint(1)
    assert_true(type(sealY) == "number" and sealY <= 0,
      "U-Q void seal does not hang above the sheet")

    theaterReset()
    assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-Q cowardice wrap")
    assert_eq(COB.Toasts:Proclaim("cowardice", { name = "Thickcut" }), true,
      "U-Q cowardice Proclaim")
    local cowH = COB.Toasts.theater.panel:GetHeight()
    assert_true(type(cowH) == "number" and cowH > voidH,
      "U-Q long blackletter cowardice grows the sheet past the floor")
    assert_eq(COB.Toasts.theater.headline._cobRole, "charcoal",
      "U-Q cowardice headline role is charcoal")
    hr, hg, hb = COB.Toasts.theater.headline:GetTextColor()
    assert_eq(hr, cr, "U-Q cowardice headline r is charcoal")
    assert_true(hr ~= gr or hg ~= gg or hb ~= gb,
      "U-Q cowardice headline is not gold on parchment")
    assert_eq(COB.Toasts.theater.accentRole, "oxblood",
      "U-Q cowardice accent stays oxblood")
    assert_eq(COB.Toasts.theater.tint:GetHeight(), rule,
      "U-Q cowardice accent is the rule hairline")
    assert_eq(COB.Toasts.theater.tint._cobRole, "oxblood",
      "U-Q cowardice hairline is oxblood, not gold text")
    local headH = COB.Toasts.theater.headline:GetHeight()
    assert_true(type(headH) == "number" and headH > COB.Theme.FontSize.headline,
      "U-Q cowardice headline height covers wrapped blackletter")
    assert_eq(COB.Toasts.theater.banner:IsShown(), false,
      "U-Q cowardice still hides the knighting ribbon")
    assert_eq(chatLines[1], "Cowardice recorded: Thickcut fled. So ruled by the Beef Pope.",
      "U-Q cowardice chat echo stays clerical")

    theaterReset()
    assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-Q free wrap")
    local freeText = "The Beef Pope sets this bout aside, for the circle was broken and the congregation will not count it among the records of the Church."
    assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "free", text = freeText }), true,
      "U-Q long free ruling Proclaim")
    local freeH = COB.Toasts.theater.panel:GetHeight()
    assert_true(type(freeH) == "number" and freeH > cowH,
      "U-Q long free ruling grows past the cowardice sheet")
    assert_eq(COB.Toasts.theater.headline:GetText(), freeText,
      "U-Q free ruling still paints Pope text on the headline")
    hr, hg, hb = COB.Toasts.theater.headline:GetTextColor()
    assert_eq(hr, cr, "U-Q free ruling headline r is charcoal")
    assert_eq(COB.Toasts.theater.tint:GetHeight(), rule,
      "U-Q free ruling accent is the rule hairline")

    theaterReset()
    assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-Q victor ink")
    assert_eq(COB.Toasts:Proclaim("verdict", { ruling = "victor", name = "Thickcut" }), true,
      "U-Q victor Proclaim")
    hr, hg, hb = COB.Toasts.theater.headline:GetTextColor()
    assert_eq(hr, cr, "U-Q victor headline r is charcoal")
    assert_true(hr ~= gr or hg ~= gg or hb ~= gb,
      "U-Q victor headline is not gold on parchment")
    local br, bg, bb = COB.Toasts.theater.copy:GetTextColor()
    assert_eq(br, cr, "U-Q victor body r is charcoal")
    assert_eq(COB.Toasts.theater.accentRole, "gold", "U-Q victor accent stays gold")
    assert_eq(COB.Toasts.theater.tint:GetHeight(), rule,
      "U-Q victor gold lives on the hairline, not the text")
    assert_eq(COB.Toasts.theater.tint._cobRole, "gold",
      "U-Q victor hairline role is gold")
    assert_eq(chatLines[1], "Victor declared: Thickcut. So ruled by the Beef Pope.",
      "U-Q B9-D chat echo stays byte-identical")
    assert_eq(COB.Toasts.theater.rays:IsShown(), false, "U-Q victor hides rays")
    assert_eq(COB.Toasts.theater.banner:IsShown(), false, "U-Q victor hides the ribbon")

    theaterReset()
    assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-Q knighting ribbon")
    assert_eq(COB.Toasts:Proclaim("knighting", { name = "Beefina" }), true,
      "U-Q knighting Proclaim")
    assert_eq(COB.Toasts.theater.banner:IsShown(), true, "U-Q knighting shows the ribbon")
    assert_eq(COB.Toasts.theater.banner:GetHeight(), band,
      "U-Q banner is a Theme.Space.band ribbon, not a second fill")
    local bp, brel, _, _, by = COB.Toasts.theater.banner:GetPoint(1)
    assert_eq(bp, "TOPLEFT", "U-Q banner anchors from the sheet top")
    assert_eq(brel, COB.Toasts.theater.panel, "U-Q banner is on the sheet")
    assert_true(type(by) == "number" and by <= 0, "U-Q banner does not hang above the sheet")
    assert_true(COB.Toasts.theater.banner:GetHeight() < COB.Toasts.theater.panel:GetHeight() / 2,
      "U-Q ribbon is not a second parchment fill")
    _, sealRel = COB.Toasts.theater.seal:GetPoint(1)
    assert_true(
      sealRel == COB.Toasts.theater.banner or sealRel == COB.Toasts.theater.panel,
      "U-Q knighting seal stays on-sheet"
    )
    assert_eq(COB.Toasts.theater.seal:GetWidth(), sealPx,
      "U-Q knighting seal is Theme.Space.seal")
    assert_eq(COB.Toasts.theater.rays:IsShown(), true, "U-Q knighting shows rays")
    assert_eq(COB.Toasts.theater.rays:GetParent(), COB.Toasts.theater.panel,
      "U-Q rays live on the sheet, not the root")
    local _, rayRel = COB.Toasts.theater.rays:GetPoint(1)
    assert_eq(rayRel, COB.Toasts.theater.seal, "U-Q rays are a seal halo")
    local rayW = COB.Toasts.theater.rays:GetWidth()
    local panelW = COB.Toasts.theater.panel:GetWidth()
    assert_true(type(rayW) == "number" and rayW < panelW,
      "U-Q rays are smaller than the panel")
    assert_true(rayW <= sealPx + md * 2,
      "U-Q ray box is seal plus Theme.Space.md halo")
    assert_eq(COB.Toasts.theater.rays._blend, "ADD", "U-Q knighting rays stay ADD")
    hr, hg, hb = COB.Toasts.theater.headline:GetTextColor()
    assert_eq(hr, cr, "U-Q knighting headline r is charcoal")
    assert_eq(COB.Toasts.theater.tint:GetHeight(), rule,
      "U-Q knighting accent is the rule hairline")
    assert_eq(findButton(COB.Toasts.theater.root), nil, "U-Q knighting has no close button")

    theaterReset()
    assert_true(COB.Runtime:StartEvent() ~= nil, "StartEvent for U-Q elevation halo")
    assert_eq(COB.Toasts:Proclaim("elevation", { name = "Juicyj" }), true,
      "U-Q elevation Proclaim")
    assert_eq(COB.Toasts.theater.banner:GetHeight(), band,
      "U-Q elevation banner is the same ribbon")
    assert_eq(COB.Toasts.theater.rays:GetParent(), COB.Toasts.theater.panel,
      "U-Q elevation rays stay on the sheet")
    _, rayRel = COB.Toasts.theater.rays:GetPoint(1)
    assert_eq(rayRel, COB.Toasts.theater.seal, "U-Q elevation rays are a seal halo")
    hr, hg, hb = COB.Toasts.theater.headline:GetTextColor()
    assert_eq(hr, cr, "U-Q elevation headline r is charcoal")
    assert_eq(played[#played], "elevation", "U-Q elevation still plays the elevation cue")
  end
  runUQ()

  if standalone then
    assert_eq(COB.Console, nil, "isolation still does not load Console")
    assert_eq(COB.Hud, nil, "isolation still does not load Hud")
    assert_eq(COB.RecordsBook, nil, "isolation still does not load Records Book")
    assert_eq(COB.Gora, nil, "isolation still does not load Gora")
  end
end
runB12D()

COB.Sound.Play = origSoundPlay
PlaySound = savedPlaySound
PlaySoundFile = savedPlaySoundFile
DEFAULT_CHAT_FRAME = savedChatFrame

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
