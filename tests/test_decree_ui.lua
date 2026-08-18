-- Decree parchment banner + minimap replay (Phase 5 Lane B / U-G dress).
-- Isolated: wow_ui_stub + Common + Theme + Decree + Decree UI + Minimap.
-- Quiet Mode theatrical parchment (Bible §14.1). Header is UI copy.
-- No TOC / bootstrap / run.lua / MainFrame / Console / HUD / Records / Status /
-- Toasts / Store / Runtime / Net / Core/DB.lua. No slash.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

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

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/UI/Decree.lua")
dofile("addon/ChurchOfBeef/UI/Minimap.lua")

local COB = ChurchOfBeef
local Decree = COB.Decree
local Banner = COB.DecreeBanner
local Theme = COB.Theme
local HEADER = "A GATHERING HAS BEEN DECREED"

-- Stub SetTexture / SetFont / SetTextColor do not remember arguments.
-- Dress pins need the Theme path and token each region actually received.
local savedCreateFrame = CreateFrame
CreateFrame = function(frameType, name, parent, template)
  local widget = savedCreateFrame(frameType, name, parent, template)
  local function dressRegion(region)
    region.SetTexture = function(self, path) self._texture = path end
    region.GetTexture = function(self) return self._texture end
    region.SetColorTexture = function(self, r, g, b, a)
      self._fill = { r, g, b, a }
    end
    region.SetVertexColor = function(self, r, g, b, a)
      self._vertex = { r, g, b, a }
    end
    region.GetVertexColor = function(self)
      local v = self._vertex
      if not v then return nil end
      return v[1], v[2], v[3], v[4]
    end
    region.SetFont = function(self, path, size, flags)
      self._fontPath = path
      self._fontSize = size
      self._fontFlags = flags
    end
    region.GetFont = function(self)
      return self._fontPath, self._fontSize, self._fontFlags
    end
    region.SetTextColor = function(self, r, g, b, a)
      self._textColor = { r, g, b, a }
    end
    region.GetTextColor = function(self)
      local c = self._textColor
      if not c then return nil end
      return c[1], c[2], c[3], c[4]
    end
  end
  local savedCreateTexture = widget.CreateTexture
  widget.CreateTexture = function(self, texName, layer)
    local tex = savedCreateTexture(self, texName, layer)
    dressRegion(tex)
    return tex
  end
  local savedCreateFontString = widget.CreateFontString
  widget.CreateFontString = function(self, fsName, layer, fsTemplate)
    local fs = savedCreateFontString(self, fsName, layer, fsTemplate)
    dressRegion(fs)
    return fs
  end
  return widget
end

local function expectTextColor(fs, role, msg)
  local er, eg, eb = Theme:Color(role)
  local r, g, b = fs:GetTextColor()
  assert_eq(r, er, (msg or role) .. " text r")
  assert_eq(g, eg, (msg or role) .. " text g")
  assert_eq(b, eb, (msg or role) .. " text b")
end

local function expectFill(tex, role, msg)
  local er, eg, eb = Theme:Color(role)
  local fill = tex and tex._fill
  assert_true(type(fill) == "table", (msg or role) .. " has a Theme fill")
  if type(fill) == "table" then
    assert_eq(fill[1], er, (msg or role) .. " fill r")
    assert_eq(fill[2], eg, (msg or role) .. " fill g")
    assert_eq(fill[3], eb, (msg or role) .. " fill b")
  end
end

local sounds = 0
PlaySound = function()
  sounds = sounds + 1
end
PlaySoundFile = function()
  sounds = sounds + 1
end
PlaySoundKitID = function()
  sounds = sounds + 1
end

local tipLines = {}
GameTooltip.AddLine = function(_, text)
  tipLines[#tipLines + 1] = text
end
GameTooltip.ClearLines = function()
  tipLines = {}
end
GameTooltip.SetOwner = function(self, owner)
  self._owner = owner
end
GameTooltip.IsOwned = function(self, owner)
  return self._owner == owner
end

local savedUi = COB.UI
local toggles = 0
COB.UI = {
  Toggle = function()
    toggles = toggles + 1
  end,
}

local function reset()
  assert_eq(Decree:ResetForTests(), true, "Decree ResetForTests runs under _IN_TEST")
  assert_eq(Banner:ResetForTests(), true, "DecreeBanner ResetForTests runs under _IN_TEST")
  sounds = 0
  toggles = 0
  tipLines = {}
end

local function buttonFor(label)
  local frame = Banner.frame
  if not frame then return nil end
  return stub.findChild(frame, function(child)
    return child._type == "Button" and child:GetText() == label
  end)
end

local function tipHas(text)
  for i = 1, #tipLines do
    if tipLines[i] == text then return true end
  end
  return false
end

local function pointRelativeTo(region, other)
  if not region or type(region._points) ~= "table" then return false end
  for i = 1, #region._points do
    if region._points[i].relativeTo == other then return true end
  end
  return false
end

local function isSmallClerical(template)
  return template == "GameFontHighlightSmall"
      or template == "GameFontNormalSmall"
      or template == "GameFontDisableSmall"
end

--------------------------------------------------------------------------------
-- Isolated surface: stub + Common + Theme + Decree + Decree UI + Minimap.
--------------------------------------------------------------------------------
assert_true(Decree ~= nil, "Core Decree is loaded")
assert_true(Banner ~= nil, "COB.DecreeBanner exists")
assert_true(Theme ~= nil, "isolated suite loads Theme")
assert_true(COB.Minimap ~= nil, "isolated suite loads Minimap")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_true(Banner ~= Decree, "the banner is not the Core Decree table")
assert_eq(type(Decree.Get), "function", "UI/Decree.lua does not clobber Core Decree")
assert_eq(Banner.MODE, "QUIET", "Decree banner declares Quiet Mode")
assert_eq(Banner.HEADER, HEADER, "header is the Bible UI copy")
assert_eq(type(Banner.Init), "function", "Init builds the surface")
assert_eq(type(Banner.Show), "function", "Show paints an active Decree")
assert_eq(type(Banner.Hide), "function", "Hide dismisses the banner")
assert_eq(type(Banner.IsShown), "function", "IsShown reads visibility")
assert_eq(type(Banner.GetView), "function", "GetView returns a copy")
assert_eq(type(Banner.Refresh), "function", "Refresh syncs leftover paint")
assert_eq(type(Banner.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(Banner.Grant, nil, "no Grant")
assert_eq(Banner.Standing, nil, "no Standing")
assert_eq(Banner.Calendar, nil, "no calendar")
assert_eq(Banner.RSVP, nil, "no RSVP")
assert_eq(Banner.Summon, nil, "no SUMMON")
assert_eq(Banner.Deputy, nil, "no deputy picker")
assert_eq(Banner.ClearDecree, nil, "no Clear Decree verb")
assert_eq(Banner.Post, nil, "no Console Post")
assert_eq(Banner.Narrate, nil, "software does not narrate")
assert_eq(Banner.PlayCue, nil, "no sound this lane")
assert_eq(Banner.Toast, nil, "banner is not a toast")
assert_eq(Banner.Toggle, nil, "banner is show/hide, not a /beef toggle")

if standalone then
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "this file does not register a slash")
  assert_eq(type(SLASH_DECREE1), "nil", "no Decree slash")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load Records Book")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Sound, nil, "isolated suite does not load Sound")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(type(COB.UI.Init), "nil", "isolated suite does not load MainFrame")
end

--------------------------------------------------------------------------------
-- Source contract: silent parchment. No calendar / RSVP / sound / Event host.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/Decree.lua", "r")
assert_true(srcFile ~= nil, "UI/Decree.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find("PlaySoundFile", 1, true), nil, "source does not call PlaySoundFile")
assert_eq(src:find("ShowUIPanel", 1, true), nil, "insecure Show/Hide only")
assert_eq(src:find("StatusBar", 1, true), nil, "source does not mint a StatusBar")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("SendAddonMessage", 1, true), nil, "source does not send addon messages")
assert_eq(src:find("Calendar", 1, true), nil, "source has no calendar")
assert_eq(src:find("RSVP", 1, true), nil, "source has no RSVP")
assert_eq(src:find("SecureActionButton", 1, true), nil, "no secure template")
assert_eq(src:find("COB.Console", 1, true), nil, "banner does not host Console")
assert_eq(src:find("COB.Hud", 1, true), nil, "banner does not host HUD")
assert_eq(src:find("COB.RecordsBook", 1, true), nil, "banner does not host Records Book")
assert_eq(src:find("COB.Toasts", 1, true), nil, "banner does not drive Toasts")
assert_eq(src:find("alreadySeen", 1, true), nil, "source does not persist already-seen")
assert_eq(src:find("decreeSeen", 1, true), nil, "source does not persist decreeSeen")
assert_eq(src:find("SLASH_", 1, true), nil, "source does not register a slash")
assert_eq(src:find("✠", 1, true), nil, "source has no cross glyphs")
assert_eq(src:find("DecreeTitle.ttf", 1, true), nil, "no missing DecreeTitle.ttf path")
assert_eq(src:find("decree-seal", 1, true), nil, "no missing Media\\decree-seal path")
assert_eq(src:find("decree-parchment", 1, true), nil, "no missing Media\\decree-parchment path")
assert_eq(src:find("Media\\\\", 1, true), nil, "no Media\\ paths required to load")
assert_eq(src:find("Interface\\\\", 1, true), nil, "no hardcoded Interface texture paths")
assert_eq(src:find("UI-PVP", 1, true), nil, "seal is not a PVP crest")
assert_eq(src:find("PVP-Banner", 1, true), nil, "seal is not a PVP banner")
assert_eq(src:find("Horde", 1, true), nil, "seal is not a Horde crest")
assert_eq(src:find("Alliance", 1, true), nil, "seal is not an Alliance crest")
assert_true(src:find('themeTexture("parchment_decree")', 1, true) ~= nil,
  "parchment slot is Theme parchment_decree")
assert_true(src:find('themeTexture("seal_papal")', 1, true) ~= nil,
  "seal slot is Theme seal_papal")
assert_true(src:find('themeTexture("ornament_nail")', 1, true) ~= nil,
  "nail slots are Theme ornament_nail")
assert_true(src:find('themeFont("display")', 1, true) ~= nil,
  "decree line uses Theme display (blackletter)")
assert_true(src:find('themeFont("label")', 1, true) ~= nil,
  "church name / header use Theme label")
assert_true(src:find('themeFont("body")', 1, true) ~= nil,
  "flavor uses Theme body")
assert_true(src:find('themeSize("headline")', 1, true) ~= nil,
  "decree line uses Theme headline size")
assert_true(src:find("Theme:Color", 1, true) ~= nil, "fills and ink go through Theme:Color")
assert_true(src:find("Theme:FontPath", 1, true) ~= nil, "fonts resolve through Theme:FontPath")
assert_true(src:find("Theme:Texture", 1, true) ~= nil, "textures resolve through Theme:Texture")
assert_eq(src:find("QuestBG", 1, true), nil, "parchment path is not hardcoded")
assert_eq(src:find("0.62, 0.52, 0.34", 1, true), nil, "parchment fill literal dies")
assert_eq(src:find("0.78, 0.70, 0.52", 1, true), nil, "bright parchment fill is dropped")
assert_eq(src:find("0.45, 0.32, 0.12", 1, true), nil, "brown ink literals die")
assert_eq(src:find("0.08, 0.07, 0.06", 1, true), nil, "iron fill literals die")
assert_eq(src:find("0.72, 0.62, 0.38", 1, true), nil, "gold fill literals die")
assert_eq(src:find("0.18, 0.12, 0.08", 1, true), nil, "line ink literals die")
assert_eq(src:find("0.32, 0.24, 0.14", 1, true), nil, "flavor ink literals die")
assert_eq(src:find("0.85, 0.72, 0.28", 1, true), nil, "seal tint literals die")
assert_eq(src:find("Fonts\\\\MORPHEUS", 1, true), nil, "no hardcoded Morpheus path")
assert_eq(src:find("MORPHEUS.TTF", 1, true), nil, "line path is not uppercase TTF")
assert_eq(src:find("MORPHEUS_CYR", 1, true), nil, "source does not use GlueFonts MORPHEUS_CYR")
assert_eq(src:find("FRIZQT", 1, true), nil, "FRIZQT path is Theme-sourced")
assert_eq(src:find("LINE_FONT", 1, true), nil, "LINE_FONT local dies")
assert_eq(src:find("BODY_FONT", 1, true), nil, "BODY_FONT local dies")
assert_eq(src:find("PARCHMENT_TEXTURE", 1, true), nil, "PARCHMENT_TEXTURE local dies")
assert_eq(src:find("SEAL_TEXTURE", 1, true), nil, "SEAL_TEXTURE local dies")
assert_true(src:find("SetFontObject", 1, true) ~= nil, "applyFont still falls back to GameFont")
local earlyEnsure = src:match("local function ensureFrame%(%)%s*\n%s*if DecreeBanner%.frame then(.-)return DecreeBanner%.frame")
assert_true(type(earlyEnsure) == "string" and earlyEnsure ~= "",
  "ensureFrame early-return body is readable")
assert_true(earlyEnsure:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
  "early-return rememberSpecial FRAME_NAME")
assert_eq(earlyEnsure:find("buildFrame", 1, true), nil,
  "early-return does not rebuild")
assert_eq(earlyEnsure:find("PlaySound", 1, true), nil,
  "early-return does not PlaySound")
assert_eq(earlyEnsure:find("CreateFrame", 1, true), nil,
  "early-return does not CreateFrame")
assert_true(src:find('themeFont("display")', 1, true) ~= nil,
  "line stays Theme display after ensureFrame pin")
local emptyShow = src:match("function DecreeBanner:Show%(%)%s*\n%s*local decree = getDecree%(%)%s*\n%s*if not decree then(.-)return false")
assert_true(type(emptyShow) == "string" and emptyShow ~= "",
  "Show empty-Get body is readable")
assert_true(emptyShow:find("ensureFrame()", 1, true) ~= nil,
  "empty Show still calls ensureFrame")
assert_true(emptyShow:find(":Hide()", 1, true) ~= nil,
  "empty Show Hides")
assert_true(
  emptyShow:find("wipePaint(frame)", 1, true) ~= nil
    or emptyShow:find('LineText:SetText("")', 1, true) ~= nil,
  "empty Show blanks leftover LineText")
assert_true(src:find('frame.LineText:SetText("")', 1, true) ~= nil,
  "LineText SetText empty")
assert_true(src:find('frame.FlavorText:SetText("")', 1, true) ~= nil,
  "FlavorText SetText empty")
assert_eq(emptyShow:find("paint(frame", 1, true), nil,
  "empty Show does not paint")
assert_eq(emptyShow:find("frame:Show()", 1, true), nil,
  "empty Show does not Show the banner")
assert_eq(emptyShow:find("PlaySound", 1, true), nil,
  "empty Show does not PlaySound")
local hideBody = src:match("function DecreeBanner:Hide%(%)%s*\n(.-)function DecreeBanner:GetView")
assert_true(type(hideBody) == "string" and hideBody ~= "",
  "Hide body is readable")
assert_true(hideBody:find("getDecree()", 1, true) ~= nil,
  "Hide checks getDecree before wiping")
assert_true(
  hideBody:find("wipePaint(self.frame)", 1, true) ~= nil
    or hideBody:find("wipePaint(frame)", 1, true) ~= nil
    or hideBody:find('LineText:SetText("")', 1, true) ~= nil,
  "Hide blanks leftover LineText when Get is nil")
assert_true(hideBody:find(":Hide()", 1, true) ~= nil,
  "Hide hides the frame")
assert_eq(hideBody:find("paint(", 1, true), nil,
  "Hide does not paint")
assert_eq(hideBody:find(":Show()", 1, true), nil,
  "Hide does not Show")
assert_eq(hideBody:find("PlaySound", 1, true), nil,
  "Hide does not PlaySound")
assert_eq(hideBody:find("Goldshire", 1, true), nil,
  "Hide does not invent a line")
local refreshBody = src:match("function DecreeBanner:Refresh%(%)%s*\n(.+)$")
assert_true(type(refreshBody) == "string" and refreshBody ~= "",
  "Refresh body is readable")
assert_true(refreshBody:find("ensureFrame()", 1, true) ~= nil,
  "Refresh calls ensureFrame")
assert_true(refreshBody:find("getDecree()", 1, true) ~= nil,
  "Refresh checks getDecree")
assert_true(
  refreshBody:find("wipePaint(frame)", 1, true) ~= nil
    or refreshBody:find("wipePaint(self.frame)", 1, true) ~= nil
    or refreshBody:find('LineText:SetText("")', 1, true) ~= nil,
  "Refresh blanks leftover LineText when Get is nil")
assert_true(refreshBody:find(":Hide()", 1, true) ~= nil,
  "Refresh Hides when Get is nil")
assert_true(refreshBody:find("paint(frame", 1, true) ~= nil
    or refreshBody:find("paint(", 1, true) ~= nil,
  "Refresh paints when a Decree is shown")
assert_true(refreshBody:find("IsShown", 1, true) ~= nil,
  "Refresh checks shown before paint")
assert_eq(refreshBody:find(":Show()", 1, true), nil,
  "Refresh does not Show a hidden banner")
assert_eq(refreshBody:find("PlaySound", 1, true), nil,
  "Refresh does not PlaySound")
assert_eq(refreshBody:find("Goldshire", 1, true), nil,
  "Refresh does not invent a line")
assert_eq(refreshBody:find("Clear Decree", 1, true), nil,
  "Refresh has no Clear Decree chrome")
assert_eq(src:find("Clear Decree", 1, true), nil,
  "source has no Clear Decree chrome")
assert_true(src:find('themeFont("display")', 1, true) ~= nil,
  "line stays Theme display after Refresh")

local miniFile = io.open("addon/ChurchOfBeef/UI/Minimap.lua", "r")
assert_true(miniFile ~= nil, "UI/Minimap.lua is readable")
local miniSrc = miniFile:read("*a")
miniFile:close()
assert_eq(miniSrc:find("RSVP", 1, true), nil, "minimap has no RSVP")
assert_eq(miniSrc:find("Calendar", 1, true), nil, "minimap has no calendar")
assert_eq(miniSrc:find("petitionPip", 1, true), nil, "minimap has no petition pip")
assert_eq(miniSrc:find("RightButton", 1, true), nil, "minimap has no right-click menu")
assert_eq(miniSrc:find("PlaySound", 1, true), nil, "minimap plays no sound")

--------------------------------------------------------------------------------
-- Init with no Decree: silent. Hidden frame is not an empty parchment.
--------------------------------------------------------------------------------
reset()
assert_eq(Decree:Get(), nil, "no Decree is set")
assert_eq(Banner:IsShown(), false, "the banner is closed before Init")
local frame = Banner:Init()
assert_true(frame ~= nil, "Init creates the frame")
assert_eq(frame:GetName(), "ChurchOfBeefDecree", "frame has a stable name")
assert_eq(frame:GetParent(), UIParent, "banner is parented to UIParent")
assert_eq(Banner:Init(), frame, "Init is idempotent")
assert_eq(Banner:IsShown(), false, "Init stays silent when Get is nil")
assert_eq(frame:IsShown(), false, "the widget stays hidden")
assert_eq(frame._template, nil, "theatrical banner is not BasicFrameTemplate")
assert_eq(frame._movable, true, "the banner is movable")
assert_eq(frame._clamped, true, "the banner is clamped to screen")
assert_eq(frame:GetScript("OnUpdate"), nil, "no permanent OnUpdate")
assert_eq(sounds, 0, "Init plays no sound")
assert_true(frame.Iron ~= nil, "dark-iron field exists")
assert_true(frame.Parchment ~= nil, "parchment leaf exists")
assert_true(frame.GoldEdge ~= nil, "muted-gold edge exists")
assert_true(frame.HeaderText ~= nil, "header FontString exists")
assert_true(frame.LineText ~= nil, "line FontString exists")
assert_true(frame.FlavorText ~= nil, "flavor FontString exists")
assert_true(frame.HeaderText._template ~= nil, "header uses a GameFont* fallback template")
assert_true(frame:GetWidth() >= 300 and frame:GetWidth() <= 340, "banner is quest-tracker wide")
assert_true(frame:GetHeight() >= 130 and frame:GetHeight() <= 160, "banner is quest-tracker tall")
assert_eq(frame.LineText._template, "GameFontNormalHuge", "line is the visual headline")
assert_true(frame.HeaderText._template ~= "GameFontNormalHuge", "header is not the largest line")
assert_true(isSmallClerical(frame.HeaderText._template), "header stays small clerical")
local churchName = rawget(frame, "ChurchName")
assert_true(churchName ~= nil, "church name sits on the parchment")
if churchName then
  assert_eq(churchName:GetText(), "Church of Beef", "church name is the institution, not a Pope")
  assert_eq(churchName._template, "GameFontHighlightSmall", "church name is small by the seal")
  assert_true(
    pointRelativeTo(churchName, frame.Seal) or pointRelativeTo(frame.Seal, churchName),
    "church name is anchored next to the seal"
  )
end
assert_true(frame.Seal ~= nil, "seal exists")
assert_true(rawget(frame, "GoldRule") ~= nil, "a gold rule dresses the parchment")
assert_true(frame.NailTL ~= nil, "iron nail at top-left")
assert_true(frame.NailTR ~= nil, "iron nail at top-right")
assert_true(frame.NailBL ~= nil, "iron nail at bottom-left")
assert_true(frame.NailBR ~= nil, "iron nail at bottom-right")
assert_eq(frame.LineText._fontPath, Theme:FontPath("display"),
  "line font path is Theme display")
assert_eq(frame.LineText._fontSize, Theme.FontSize.headline,
  "line size is Theme headline")
assert_eq(frame.HeaderText._fontPath, Theme:FontPath("label"),
  "header font path is Theme label")
if churchName then
  assert_eq(churchName._fontPath, Theme:FontPath("label"),
    "church name font path is Theme label")
end
assert_eq(frame.FlavorText._fontPath, Theme:FontPath("body"),
  "flavor font path is Theme body")
assert_eq(frame.Parchment:GetTexture(), Theme:Texture("parchment_decree"),
  "parchment texture is Theme parchment_decree")
assert_eq(frame.Seal:GetTexture(), Theme:Texture("seal_papal"),
  "seal texture is Theme seal_papal")
assert_eq(frame.NailTL:GetTexture(), Theme:Texture("ornament_nail"),
  "nail texture is Theme ornament_nail")
assert_eq(frame.NailTR:GetTexture(), Theme:Texture("ornament_nail"),
  "top-right nail is Theme ornament_nail")
assert_eq(frame.NailBL:GetTexture(), Theme:Texture("ornament_nail"),
  "bottom-left nail is Theme ornament_nail")
assert_eq(frame.NailBR:GetTexture(), Theme:Texture("ornament_nail"),
  "bottom-right nail is Theme ornament_nail")
expectFill(frame.Iron, "charcoal", "iron field")
expectFill(frame.GoldEdge, "gold", "gold edge")
expectFill(frame.GoldRule, "gold", "gold rule")
expectTextColor(frame.HeaderText, "gold", "header")
expectTextColor(frame.LineText, "charcoal", "line")
expectTextColor(frame.FlavorText, "iron", "flavor")
expectTextColor(churchName, "gold", "church name")
local sr, sg, sb = frame.Seal:GetVertexColor()
local gr, gg, gb = Theme:Color("gold")
assert_eq(sr, gr, "seal vertex r is gold")
assert_eq(sg, gg, "seal vertex g is gold")
assert_eq(sb, gb, "seal vertex b is gold")
assert_eq(buttonFor("RSVP"), nil, "no RSVP chrome")
assert_eq(buttonFor("Attend"), nil, "no attendance chrome")
assert_eq(buttonFor("Calendar"), nil, "no calendar chrome")
assert_eq(buttonFor("Deputy"), nil, "no deputy picker")
assert_eq(buttonFor("Clear Decree"), nil, "no Clear Decree chrome")
assert_eq(buttonFor("Grant"), nil, "no Grant chrome")
assert_eq(buttonFor("I will attend"), nil, "no RSVP verb")
assert_true(UISpecialFrames[1] == "ChurchOfBeefDecree" or (function()
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == "ChurchOfBeefDecree" then return true end
  end
  return false
end)(), "Escape can dismiss the banner")

-- B24-D: ensureFrame early-return re-registers ChurchOfBeefDecree after a
-- wiped UISpecialFrames. Do not rebuild. Quiet silent. Isolation wrap stays.
local function runB24D()
  local function countSpecial(name)
    local n = 0
    if type(UISpecialFrames) ~= "table" then return 0 end
    for i = 1, #UISpecialFrames do
      if UISpecialFrames[i] == name then n = n + 1 end
    end
    return n
  end
  assert_true(Banner.frame ~= nil, "Init so the frame exists")
  assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
    "first-create uniqueness: ChurchOfBeefDecree once before wipe")
  local savedSpecial = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefDecree"), 0,
    "wipe clears ChurchOfBeefDecree")
  local cuesWipe = sounds
  local same = Banner:Init()
  assert_eq(same, Banner.frame, "second Init returns the existing frame")
  assert_eq(same, frame, "ensureFrame does not rebuild")
  assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
    "wiped UISpecialFrames + second Init lists ChurchOfBeefDecree once")
  assert_eq(sounds, cuesWipe, "second Init plays no sound")
  Banner:Init()
  assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
    "third Init after wipe does not duplicate ChurchOfBeefDecree")
  UISpecialFrames = {}
  assert_eq(Banner:Show(), false, "Show without a Decree stays silent")
  assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
    "wiped UISpecialFrames + Show without Decree lists ChurchOfBeefDecree once")
  assert_eq(Banner:Init(), frame, "Show miss still leaves ensureFrame on Init")
  assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
    "wiped UISpecialFrames + Init after Show lists ChurchOfBeefDecree once")
  assert_eq(Banner.frame, frame, "ensureFrame after Show does not rebuild")
  assert_eq(sounds, cuesWipe, "ensureFrame after Show plays no sound")
  UISpecialFrames = savedSpecial
end
runB24D()

-- B25-B: empty Show still ensureFrame (re-register ESC) then Hide. Do not
-- paint. Do not Show the banner. Quiet silent. Isolation wrap stays.
local function runB25B()
  local function countSpecial(name)
    local n = 0
    if type(UISpecialFrames) ~= "table" then return 0 end
    for i = 1, #UISpecialFrames do
      if UISpecialFrames[i] == name then n = n + 1 end
    end
    return n
  end
  assert_true(Banner.frame ~= nil, "Init so the frame exists")
  assert_eq(Decree:Get(), nil, "B25-B Show path has no active Decree")
  local savedSpecial = UISpecialFrames
  UISpecialFrames = {}
  local cuesWipe = sounds
  assert_eq(Banner:Show(), false, "Show without a Decree stays silent")
  assert_eq(Banner:IsShown(), false, "empty Show does not paint the banner")
  assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
    "wiped UISpecialFrames + Show-only lists ChurchOfBeefDecree once")
  assert_eq(sounds, cuesWipe, "empty Show plays no sound")
  Banner:Show()
  assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
    "second empty Show does not duplicate ChurchOfBeefDecree")
  assert_eq(Banner:IsShown(), false, "second empty Show stays hidden")
  UISpecialFrames = savedSpecial

  -- B26-C: leftover Goldshire line/flavor must blank on empty Show.
  -- B25-B wipe + Show-only uniqueness stays. Isolation wrap stays.
  local function runB26C()
    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "B26-C Show paints Goldshire")
    assert_eq(Banner:IsShown(), true, "B26-C Show opens the banner")
    assert_eq(Banner.frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
      "B26-C leftover starts as Goldshire")
    assert_eq(Banner.frame.FlavorText:GetText(), "Bring a friend.",
      "B26-C leftover flavor starts set")
    Decree:Clear()
    assert_eq(Decree:Get(), nil, "B26-C Clear removes the Decree")
    local cuesClear = sounds
    local savedAfter = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(Banner:Show(), false, "empty Show after Clear refuses parchment")
    assert_eq(Banner:IsShown(), false, "empty Show after Clear stays hidden")
    assert_eq(Banner.frame.LineText:GetText(), "",
      "empty Show blanks leftover LineText")
    assert_eq(Banner.frame.FlavorText:GetText(), "",
      "empty Show blanks leftover FlavorText")
    assert_eq(Banner.frame.FlavorText:IsShown(), false,
      "empty Show hides leftover flavor")
    assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
      "B26-C empty Show still remounts ChurchOfBeefDecree once")
    assert_eq(sounds, cuesClear, "empty Show after Clear plays no sound")
    Banner:Show()
    assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
      "second empty Show after Clear still once")
    assert_eq(Banner:IsShown(), false, "second empty Show after Clear stays hidden")
    assert_eq(Banner.frame.LineText:GetText(), "",
      "second empty Show keeps LineText blank")
    assert_eq(Banner.frame.FlavorText:GetText(), "",
      "second empty Show keeps FlavorText blank")
    UISpecialFrames = savedAfter
  end
  runB26C()

  -- B27-B: leftover Goldshire must blank on Hide after Clear (not Show).
  -- Hide while a Decree is still set just Hides; next Show paints.
  -- B26-C empty-Show wipe stays. Isolation wrap stays.
  local function runB27B()
    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "B27-B Show paints Goldshire")
    assert_eq(Banner:IsShown(), true, "B27-B Show opens the banner")
    assert_eq(Banner.frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
      "B27-B leftover starts as Goldshire")
    assert_eq(Banner.frame.FlavorText:GetText(), "Bring a friend.",
      "B27-B leftover flavor starts set")
    Decree:Clear()
    assert_eq(Decree:Get(), nil, "B27-B Clear removes the Decree")
    local cuesHide = sounds
    assert_eq(Banner:Hide(), true, "Hide after Clear succeeds")
    assert_eq(Banner:IsShown(), false, "Hide after Clear stays hidden")
    assert_eq(Banner.frame.LineText:GetText(), "",
      "Hide after Clear blanks leftover LineText")
    assert_eq(Banner.frame.FlavorText:GetText(), "",
      "Hide after Clear blanks leftover FlavorText")
    assert_eq(Banner.frame.FlavorText:IsShown(), false,
      "Hide after Clear hides leftover flavor")
    assert_eq(sounds, cuesHide, "Hide after Clear plays no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "Show with live Decree paints")
    local cuesLive = sounds
    assert_eq(Banner:Hide(), true, "Hide while Decree is set succeeds")
    assert_eq(Banner:IsShown(), false, "Hide while Decree is set hides")
    assert_eq(sounds, cuesLive, "Hide while Decree is set plays no sound")
    assert_eq(Banner:Show(), true, "Show after Hide-with-Decree still paints")
    assert_eq(Banner.frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
      "Show after Hide-with-Decree paints Goldshire")
    assert_eq(Banner.frame.FlavorText:GetText(), "Bring a friend.",
      "Show after Hide-with-Decree paints flavor")
    Decree:Clear()
    Banner:Hide()
  end
  runB27B()

  -- B28-B: leftover Goldshire must blank on Refresh after Clear (not Hide/Show).
  -- Hidden + Set + Refresh does not Show. Shown + live Decree Refresh paints.
  -- B27-B Hide wipe / B26-C empty Show stay. Isolation wrap stays.
  local function runB28B()
    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "B28-B Show paints Goldshire")
    assert_eq(Banner:IsShown(), true, "B28-B Show opens the banner")
    assert_eq(Banner.frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
      "B28-B leftover starts as Goldshire")
    assert_eq(Banner.frame.FlavorText:GetText(), "Bring a friend.",
      "B28-B leftover flavor starts set")
    Decree:Clear()
    assert_eq(Decree:Get(), nil, "B28-B Clear removes the Decree")
    local cuesRefresh = sounds
    local savedRefresh = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(Banner:Refresh(), false, "Refresh after Clear hides leftover")
    assert_eq(Banner:IsShown(), false, "Refresh after Clear is hidden")
    assert_eq(Banner.frame.LineText:GetText(), "",
      "Refresh after Clear blanks leftover LineText")
    assert_eq(Banner.frame.FlavorText:GetText(), "",
      "Refresh after Clear blanks leftover FlavorText")
    assert_eq(Banner.frame.FlavorText:IsShown(), false,
      "Refresh after Clear hides leftover flavor")
    assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
      "Refresh remounts ChurchOfBeefDecree once")
    assert_eq(sounds, cuesRefresh, "Refresh after Clear plays no sound")
    UISpecialFrames = savedRefresh

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:IsShown(), false, "Set after Refresh stays hidden")
    local cuesHidden = sounds
    assert_eq(Banner:Refresh(), false, "Hidden + Set + Refresh does not Show")
    assert_eq(Banner:IsShown(), false, "Hidden + Set + Refresh stays hidden")
    assert_eq(Banner.frame.LineText:GetText(), "",
      "Hidden + Set + Refresh does not paint")
    assert_eq(Banner.frame.FlavorText:GetText(), "",
      "Hidden + Set + Refresh does not paint flavor")
    assert_eq(sounds, cuesHidden, "Hidden + Set + Refresh plays no sound")

    assert_eq(Banner:Show(), true, "Show after hidden Refresh paints")
    assert_eq(Banner.frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
      "Show after hidden Refresh paints Goldshire")
    Decree:Set({
      line = "Shattrath — Friday, 8:00 PM",
      flavor = "The Gathering.",
    })
    local cuesLive = sounds
    assert_eq(Banner:Refresh(), true, "Refresh while shown paints")
    assert_eq(Banner:IsShown(), true, "Refresh while shown stays shown")
    assert_eq(Banner.frame.LineText:GetText(), "Shattrath — Friday, 8:00 PM",
      "Refresh while shown paints the new line")
    assert_eq(Banner.frame.FlavorText:GetText(), "The Gathering.",
      "Refresh while shown paints the new flavor")
    assert_eq(sounds, cuesLive, "Refresh while shown plays no sound")
    Decree:Clear()
    Banner:Hide()
  end
  runB28B()

  -- B29-B: leftover Goldshire must blank on widget frame:Hide after Clear
  -- (ESC via UISpecialFrames), not DecreeBanner:Hide / Refresh.
  -- Refresh / Hide wipe / empty Show stay. Isolation wrap stays.
  local function runB29B()
    assert_true(src:find("local function wireDecreeOnHide", 1, true) ~= nil,
      "source extracts wireDecreeOnHide")
    local wireDecree = src:match("local function wireDecreeOnHide%(frame%)(.-)\nlocal function buildFrame")
    assert_true(type(wireDecree) == "string" and wireDecree ~= "",
      "wireDecreeOnHide body is readable")
    if type(wireDecree) ~= "string" then wireDecree = "" end
    assert_true(wireDecree:find("GetScript", 1, true) ~= nil,
      "wireDecreeOnHide checks GetScript")
    assert_true(wireDecree:find("SetScript", 1, true) ~= nil,
      "wireDecreeOnHide holds SetScript")
    assert_true(wireDecree:find("OnHide", 1, true) ~= nil,
      "wireDecreeOnHide wires OnHide")
    assert_true(wireDecree:find("if existing then return", 1, true) ~= nil,
      "wireDecreeOnHide does not replace an existing OnHide")
    assert_true(wireDecree:find("getDecree()", 1, true) ~= nil,
      "wireDecreeOnHide checks getDecree")
    assert_true(
      wireDecree:find("wipePaint(frame)", 1, true) ~= nil
        or wireDecree:find('LineText:SetText("")', 1, true) ~= nil,
      "wireDecreeOnHide wipePaints when Get is nil")
    assert_eq(wireDecree:find(":Show()", 1, true), nil,
      "OnHide does not Show")
    assert_eq(wireDecree:find("PlaySound", 1, true), nil,
      "wireDecreeOnHide does not PlaySound")
    assert_eq(wireDecree:find("CreateFrame", 1, true), nil,
      "wireDecreeOnHide does not rebuild")
    assert_eq(wireDecree:find("Clear Decree", 1, true), nil,
      "wireDecreeOnHide has no Clear Decree chrome")
    local buildBody = src:match("local function buildFrame%(%)(.-)\nlocal function ensureFrame")
    assert_true(type(buildBody) == "string" and buildBody ~= "",
      "buildFrame body is readable")
    if type(buildBody) ~= "string" then buildBody = "" end
    assert_true(buildBody:find("wireDecreeOnHide", 1, true) ~= nil,
      "buildFrame calls wireDecreeOnHide")
    assert_eq(buildBody:find('SetScript("OnHide"', 1, true), nil,
      "buildFrame does not SetScript OnHide inline")
    local createEnsure = src:match(
      'if type%(CreateFrame%) ~= "function" then return nil end%s*\n(.-)return DecreeBanner%.frame'
    )
    assert_true(type(createEnsure) == "string" and createEnsure ~= "",
      "ensureFrame create body is readable")
    if type(createEnsure) ~= "string" then createEnsure = "" end
    assert_true(createEnsure:find("buildFrame()", 1, true) ~= nil,
      "ensureFrame create still builds")
    assert_true(createEnsure:find("wireDecreeOnHide", 1, true) ~= nil,
      "ensureFrame create calls wireDecreeOnHide")
    assert_eq(createEnsure:find('SetScript("OnHide"', 1, true), nil,
      "ensureFrame create does not SetScript OnHide inline")
    assert_eq(hideBody:find("SetScript", 1, true), nil,
      "Hide does not SetScript")
    assert_eq(refreshBody:find("SetScript", 1, true), nil,
      "Refresh does not SetScript")
    assert_eq(refreshBody:find("wireDecreeOnHide", 1, true), nil,
      "Refresh does not call wireDecreeOnHide")
    assert_true(src:find('themeFont("display")', 1, true) ~= nil,
      "line stays Theme display after OnHide")
    assert_eq(src:find("Clear Decree", 1, true), nil,
      "source still has no Clear Decree chrome")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "B29-B Show paints Goldshire")
    assert_eq(Banner:IsShown(), true, "B29-B Show opens the banner")
    assert_eq(Banner.frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
      "B29-B leftover starts as Goldshire")
    assert_eq(Banner.frame.FlavorText:GetText(), "Bring a friend.",
      "B29-B leftover flavor starts set")
    local onHide = Banner.frame:GetScript("OnHide")
    assert_true(onHide ~= nil, "create-path wires OnHide")
    assert_eq(Banner:Init(), Banner.frame, "Init returns the existing frame")
    assert_eq(Banner.frame:GetScript("OnHide"), onHide,
      "Init does not replace OnHide")
    Decree:Clear()
    assert_eq(Decree:Get(), nil, "B29-B Clear removes the Decree")
    local cuesHide = sounds
    local widget = Banner.frame
    widget:Hide()
    assert_eq(Banner:IsShown(), false, "widget Hide after Clear is hidden")
    assert_eq(widget:IsShown(), false, "widget Hide hides the frame")
    assert_eq(widget.LineText:GetText(), "",
      "widget Hide after Clear blanks leftover LineText")
    assert_eq(widget.FlavorText:GetText(), "",
      "widget Hide after Clear blanks leftover FlavorText")
    assert_eq(widget.FlavorText:IsShown(), false,
      "widget Hide after Clear hides leftover flavor")
    assert_eq(sounds, cuesHide, "widget Hide after Clear plays no sound")
    assert_eq(Banner.frame:GetScript("OnHide"), onHide,
      "widget Hide does not replace OnHide")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "Hide wipe stay Show paints")
    Decree:Clear()
    local cuesBannerHide = sounds
    assert_eq(Banner:Hide(), true, "Hide wipe still blanks after OnHide")
    assert_eq(Banner:IsShown(), false, "Hide wipe stay is hidden")
    assert_eq(Banner.frame.LineText:GetText(), "",
      "Hide wipe stay blanks leftover LineText")
    assert_eq(Banner.frame.FlavorText:GetText(), "",
      "Hide wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesBannerHide, "Hide wipe stay plays no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "Refresh wipe stay Show paints")
    Decree:Clear()
    local cuesRefresh = sounds
    assert_eq(Banner:Refresh(), false, "Refresh wipe still blanks after OnHide")
    assert_eq(Banner:IsShown(), false, "Refresh wipe stay is hidden")
    assert_eq(Banner.frame.LineText:GetText(), "",
      "Refresh wipe stay blanks leftover LineText")
    assert_eq(Banner.frame.FlavorText:GetText(), "",
      "Refresh wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesRefresh, "Refresh wipe stay plays no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "empty Show wipe stay paints")
    Decree:Clear()
    local cuesEmpty = sounds
    assert_eq(Banner:Show(), false, "empty Show wipe still blanks after OnHide")
    assert_eq(Banner:IsShown(), false, "empty Show wipe stay is hidden")
    assert_eq(Banner.frame.LineText:GetText(), "",
      "empty Show wipe stay blanks leftover LineText")
    assert_eq(Banner.frame.FlavorText:GetText(), "",
      "empty Show wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesEmpty, "empty Show wipe stay plays no sound")
    Decree:Clear()
    Banner:Hide()
  end
  runB29B()

  -- B30-A: ensureFrame remounts a missing OnHide when the frame already
  -- exists. Early-return rememberSpecial then wireDecreeOnHide. Do not
  -- replace an existing script. Create-path / Hide / Refresh / empty Show
  -- stay. Isolation wrap stays.
  local function runB30A()
    assert_true(type(earlyEnsure) == "string" and earlyEnsure ~= "",
      "B30-A early-return body is readable")
    local remAt = earlyEnsure:find("rememberSpecial(FRAME_NAME)", 1, true)
    local wireAt = earlyEnsure:find("wireDecreeOnHide", 1, true)
    assert_true(remAt ~= nil, "early-return still rememberSpecials")
    assert_true(wireAt ~= nil, "early-return remounts via wireDecreeOnHide")
    assert_true(type(remAt) == "number" and type(wireAt) == "number" and remAt < wireAt,
      "early-return wires OnHide after rememberSpecial")
    assert_eq(earlyEnsure:find('SetScript("OnHide"', 1, true), nil,
      "early-return does not SetScript OnHide inline")
    assert_eq(earlyEnsure:find("buildFrame", 1, true), nil,
      "early-return does not rebuild")
    assert_eq(earlyEnsure:find("CreateFrame", 1, true), nil,
      "early-return does not CreateFrame")
    assert_eq(earlyEnsure:find("PlaySound", 1, true), nil,
      "early-return does not PlaySound")
    assert_eq(earlyEnsure:find(":Show()", 1, true), nil,
      "early-return does not Show")
    assert_eq(earlyEnsure:find("Clear Decree", 1, true), nil,
      "early-return has no Clear Decree chrome")
    local buildBody = src:match("local function buildFrame%(%)(.-)\nlocal function ensureFrame")
    assert_true(type(buildBody) == "string" and buildBody ~= "",
      "B30-A buildFrame body is readable")
    if type(buildBody) ~= "string" then buildBody = "" end
    assert_true(buildBody:find("wireDecreeOnHide", 1, true) ~= nil,
      "create-path buildFrame still calls wireDecreeOnHide")
    assert_eq(buildBody:find('SetScript("OnHide"', 1, true), nil,
      "buildFrame still does not SetScript OnHide inline")
    local createEnsure = src:match(
      'if type%(CreateFrame%) ~= "function" then return nil end%s*\n(.-)return DecreeBanner%.frame'
    )
    assert_true(type(createEnsure) == "string" and createEnsure ~= "",
      "B30-A ensureFrame create body is readable")
    if type(createEnsure) ~= "string" then createEnsure = "" end
    assert_true(createEnsure:find("buildFrame()", 1, true) ~= nil,
      "ensureFrame create still builds")
    assert_true(createEnsure:find("wireDecreeOnHide", 1, true) ~= nil,
      "ensureFrame create still calls wireDecreeOnHide")
    assert_eq(refreshBody:find("wireDecreeOnHide", 1, true), nil,
      "Refresh still does not call wireDecreeOnHide")
    assert_true(src:find('themeFont("display")', 1, true) ~= nil,
      "line stays Theme display after remount")
    assert_eq(src:find("Clear Decree", 1, true), nil,
      "source still has no Clear Decree chrome")

    assert_true(Banner.frame ~= nil, "frame already exists before remount")
    local same = Banner.frame
    local cuesRemount = sounds
    same:SetScript("OnHide", nil)
    assert_eq(same:GetScript("OnHide"), nil, "OnHide dropped before Show remount")
    assert_eq(Banner:Show(), false, "Show remount with empty Get stays silent")
    assert_eq(Banner.frame, same, "Show remount does not rebuild")
    local afterShow = same:GetScript("OnHide")
    assert_true(afterShow ~= nil, "Show remounts a missing OnHide")
    assert_eq(sounds, cuesRemount, "Show remount plays no sound")

    same:SetScript("OnHide", nil)
    assert_eq(same:GetScript("OnHide"), nil, "OnHide dropped before Refresh remount")
    assert_eq(Banner:Refresh(), false, "Refresh remount with empty Get stays silent")
    assert_eq(Banner.frame, same, "Refresh remount does not rebuild")
    local afterRefresh = same:GetScript("OnHide")
    assert_true(afterRefresh ~= nil, "Refresh remounts a missing OnHide")
    assert_eq(sounds, cuesRemount, "Refresh remount plays no sound")

    same:SetScript("OnHide", nil)
    assert_eq(same:GetScript("OnHide"), nil, "OnHide dropped before Init remount")
    assert_eq(Banner:Init(), same, "Init remount returns the existing frame")
    local afterInit = same:GetScript("OnHide")
    assert_true(afterInit ~= nil, "Init remounts a missing OnHide")
    assert_eq(Banner:Init(), same, "third Init still returns the existing frame")
    assert_eq(same:GetScript("OnHide"), afterInit,
      "third call with the script already set keeps identity")
    assert_eq(Banner:Show(), false, "Show with script set does not rebuild")
    assert_eq(same:GetScript("OnHide"), afterInit,
      "Show with the script already set keeps identity")
    assert_eq(Banner:Refresh(), false, "Refresh with script set does not rebuild")
    assert_eq(same:GetScript("OnHide"), afterInit,
      "Refresh with the script already set keeps identity")
    assert_eq(sounds, cuesRemount, "identity-stay remounts play no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "widget-Hide stay Show paints")
    assert_eq(same:GetScript("OnHide"), afterInit,
      "live Show does not replace remounted OnHide")
    Decree:Clear()
    local cuesHide = sounds
    same:Hide()
    assert_eq(Banner:IsShown(), false, "widget Hide after Clear is hidden")
    assert_eq(same.LineText:GetText(), "",
      "widget Hide after remount blanks leftover LineText")
    assert_eq(same.FlavorText:GetText(), "",
      "widget Hide after remount blanks leftover FlavorText")
    assert_eq(same.FlavorText:IsShown(), false,
      "widget Hide after remount hides leftover flavor")
    assert_eq(sounds, cuesHide, "widget Hide after remount plays no sound")
    assert_eq(same:GetScript("OnHide"), afterInit,
      "widget Hide does not replace remounted OnHide")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "Hide wipe stay Show paints")
    Decree:Clear()
    local cuesBannerHide = sounds
    assert_eq(Banner:Hide(), true, "Hide wipe still blanks after remount")
    assert_eq(Banner:IsShown(), false, "Hide wipe stay is hidden")
    assert_eq(same.LineText:GetText(), "",
      "Hide wipe stay blanks leftover LineText")
    assert_eq(same.FlavorText:GetText(), "",
      "Hide wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesBannerHide, "Hide wipe stay plays no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "Refresh wipe stay Show paints")
    Decree:Clear()
    local cuesRefresh = sounds
    assert_eq(Banner:Refresh(), false, "Refresh wipe still blanks after remount")
    assert_eq(Banner:IsShown(), false, "Refresh wipe stay is hidden")
    assert_eq(same.LineText:GetText(), "",
      "Refresh wipe stay blanks leftover LineText")
    assert_eq(same.FlavorText:GetText(), "",
      "Refresh wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesRefresh, "Refresh wipe stay plays no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "empty Show wipe stay paints")
    Decree:Clear()
    local cuesEmpty = sounds
    assert_eq(Banner:Show(), false, "empty Show wipe still blanks after remount")
    assert_eq(Banner:IsShown(), false, "empty Show wipe stay is hidden")
    assert_eq(same.LineText:GetText(), "",
      "empty Show wipe stay blanks leftover LineText")
    assert_eq(same.FlavorText:GetText(), "",
      "empty Show wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesEmpty, "empty Show wipe stay plays no sound")
    Decree:Clear()
    Banner:Hide()
  end
  runB30A()

  -- B31-B: Hide remounts a missing OnHide when the frame already
  -- exists. When the frame exists, Hide calls wireDecreeOnHide
  -- before wipe/Hide. Do not replace an existing script.
  -- ensureFrame remount stays. Isolation wrap stays.
  local function runB31B()
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B31-B Hide body is readable")
    local wireAt = hideBody:find("wireDecreeOnHide", 1, true)
    local wipeAt = hideBody:find("wipePaint", 1, true)
    local frameHideAt = hideBody:find(":Hide()", 1, true)
    assert_true(wireAt ~= nil, "Hide remounts via wireDecreeOnHide")
    assert_true(wipeAt ~= nil, "Hide still wipePaints when Get is nil")
    assert_true(frameHideAt ~= nil, "Hide still hides the frame")
    assert_true(type(wireAt) == "number" and type(wipeAt) == "number" and wireAt < wipeAt,
      "Hide wires OnHide before wipe")
    assert_true(type(wireAt) == "number" and type(frameHideAt) == "number" and wireAt < frameHideAt,
      "Hide wires OnHide before Hide")
    assert_eq(hideBody:find('SetScript("OnHide"', 1, true), nil,
      "Hide does not SetScript OnHide inline")
    assert_eq(hideBody:find("buildFrame", 1, true), nil,
      "Hide does not rebuild")
    assert_eq(hideBody:find("CreateFrame", 1, true), nil,
      "Hide does not CreateFrame")
    assert_eq(hideBody:find("PlaySound", 1, true), nil,
      "Hide does not PlaySound")
    assert_eq(hideBody:find(":Show()", 1, true), nil,
      "Hide does not Show")
    assert_eq(hideBody:find("ensureFrame", 1, true), nil,
      "Hide does not call ensureFrame")
    assert_eq(hideBody:find("Clear Decree", 1, true), nil,
      "Hide has no Clear Decree chrome")
    assert_true(type(earlyEnsure) == "string" and earlyEnsure ~= "",
      "B31-B early-return body is readable")
    assert_true(earlyEnsure:find("wireDecreeOnHide", 1, true) ~= nil,
      "ensureFrame remount stays")
    assert_eq(earlyEnsure:find('SetScript("OnHide"', 1, true), nil,
      "ensureFrame remount still does not SetScript OnHide inline")
    assert_eq(refreshBody:find("wireDecreeOnHide", 1, true), nil,
      "Refresh still does not call wireDecreeOnHide")
    assert_true(src:find('themeFont("display")', 1, true) ~= nil,
      "line stays Theme display after Hide remount")
    assert_eq(src:find("Clear Decree", 1, true), nil,
      "source still has no Clear Decree chrome")

    assert_true(Banner.frame ~= nil, "frame already exists before Hide remount")
    local same = Banner.frame
    local cuesRemount = sounds
    same:SetScript("OnHide", nil)
    assert_eq(same:GetScript("OnHide"), nil, "OnHide dropped before Hide remount")
    assert_eq(Banner:Hide(), true, "Hide remount succeeds")
    assert_eq(Banner.frame, same, "Hide remount does not rebuild")
    local afterHide = same:GetScript("OnHide")
    assert_true(afterHide ~= nil, "Hide remounts a missing OnHide")
    assert_eq(sounds, cuesRemount, "Hide remount plays no sound")

    assert_eq(Banner:Hide(), true, "second Hide with script set succeeds")
    assert_eq(same:GetScript("OnHide"), afterHide,
      "second Hide with the script already set keeps identity")
    assert_eq(Banner:Hide(), true, "third Hide with script set succeeds")
    assert_eq(same:GetScript("OnHide"), afterHide,
      "third Hide with the script already set keeps identity")
    assert_eq(Banner.frame, same, "third Hide does not rebuild")
    assert_eq(sounds, cuesRemount, "identity-stay Hides play no sound")

    same:SetScript("OnHide", nil)
    assert_eq(same:GetScript("OnHide"), nil, "OnHide dropped before Show remount stay")
    assert_eq(Banner:Show(), false, "Show remount stay with empty Get stays silent")
    assert_eq(Banner.frame, same, "Show remount stay does not rebuild")
    local afterShow = same:GetScript("OnHide")
    assert_true(afterShow ~= nil, "ensureFrame Show remount stays")
    assert_eq(sounds, cuesRemount, "Show remount stay plays no sound")

    same:SetScript("OnHide", nil)
    assert_eq(same:GetScript("OnHide"), nil, "OnHide dropped before Refresh remount stay")
    assert_eq(Banner:Refresh(), false, "Refresh remount stay with empty Get stays silent")
    assert_eq(Banner.frame, same, "Refresh remount stay does not rebuild")
    local afterRefresh = same:GetScript("OnHide")
    assert_true(afterRefresh ~= nil, "ensureFrame Refresh remount stays")
    assert_eq(sounds, cuesRemount, "Refresh remount stay plays no sound")

    same:SetScript("OnHide", nil)
    assert_eq(same:GetScript("OnHide"), nil, "OnHide dropped before Init remount stay")
    assert_eq(Banner:Init(), same, "Init remount stay returns the existing frame")
    local afterInit = same:GetScript("OnHide")
    assert_true(afterInit ~= nil, "ensureFrame Init remount stays")
    assert_eq(Banner:Init(), same, "third Init stay still returns the existing frame")
    assert_eq(same:GetScript("OnHide"), afterInit,
      "third Init with the script already set keeps identity")
    assert_eq(sounds, cuesRemount, "Init remount stay plays no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "widget-Hide stay Show paints")
    assert_eq(same:GetScript("OnHide"), afterInit,
      "live Show does not replace remounted OnHide")
    Decree:Clear()
    local cuesHide = sounds
    same:Hide()
    assert_eq(Banner:IsShown(), false, "widget Hide after Clear is hidden")
    assert_eq(same.LineText:GetText(), "",
      "widget Hide after remount blanks leftover LineText")
    assert_eq(same.FlavorText:GetText(), "",
      "widget Hide after remount blanks leftover FlavorText")
    assert_eq(same.FlavorText:IsShown(), false,
      "widget Hide after remount hides leftover flavor")
    assert_eq(sounds, cuesHide, "widget Hide after remount plays no sound")
    assert_eq(same:GetScript("OnHide"), afterInit,
      "widget Hide does not replace remounted OnHide")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "Hide wipe stay Show paints")
    Decree:Clear()
    local cuesBannerHide = sounds
    assert_eq(Banner:Hide(), true, "Hide wipe still blanks after Hide remount")
    assert_eq(Banner:IsShown(), false, "Hide wipe stay is hidden")
    assert_eq(same.LineText:GetText(), "",
      "Hide wipe stay blanks leftover LineText")
    assert_eq(same.FlavorText:GetText(), "",
      "Hide wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesBannerHide, "Hide wipe stay plays no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "Refresh wipe stay Show paints")
    Decree:Clear()
    local cuesRefresh = sounds
    assert_eq(Banner:Refresh(), false, "Refresh wipe still blanks after Hide remount")
    assert_eq(Banner:IsShown(), false, "Refresh wipe stay is hidden")
    assert_eq(same.LineText:GetText(), "",
      "Refresh wipe stay blanks leftover LineText")
    assert_eq(same.FlavorText:GetText(), "",
      "Refresh wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesRefresh, "Refresh wipe stay plays no sound")

    Decree:Set({
      line = "Goldshire Inn — Sunday, 7:00 PM",
      flavor = "Bring a friend.",
    })
    assert_eq(Banner:Show(), true, "empty Show wipe stay paints")
    Decree:Clear()
    local cuesEmpty = sounds
    assert_eq(Banner:Show(), false, "empty Show wipe still blanks after Hide remount")
    assert_eq(Banner:IsShown(), false, "empty Show wipe stay is hidden")
    assert_eq(same.LineText:GetText(), "",
      "empty Show wipe stay blanks leftover LineText")
    assert_eq(same.FlavorText:GetText(), "",
      "empty Show wipe stay blanks leftover FlavorText")
    assert_eq(sounds, cuesEmpty, "empty Show wipe stay plays no sound")
    Decree:Clear()
    Banner:Hide()
  end
  runB31B()

  -- B36-D: Hide remounts UISpecialFrames membership when the frame
  -- already exists. rememberSpecial(FRAME_NAME) before existing
  -- OnHide remount + wipe-if-empty + frame:Hide(). Do not replace
  -- an existing OnHide. No OnShow re-wire. No rebuild. Isolation wrap stays.
  local function runB36D()
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B36-D Hide body is readable")
    local remAt = hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
    local wireAt = hideBody:find("wireDecreeOnHide", 1, true)
    local wipeAt = hideBody:find("wipePaint", 1, true)
    local frameHideAt = hideBody:find(":Hide()", 1, true)
    assert_true(remAt ~= nil, "Hide remounts rememberSpecial FRAME_NAME")
    assert_true(wireAt ~= nil, "Hide remounts via wireDecreeOnHide")
    assert_true(wipeAt ~= nil, "Hide still wipePaints when Get is nil")
    assert_true(frameHideAt ~= nil, "Hide still hides the frame")
    assert_true(type(remAt) == "number" and type(wireAt) == "number" and remAt < wireAt,
      "Hide rememberSpecials before OnHide remount")
    assert_true(type(remAt) == "number" and type(wipeAt) == "number" and remAt < wipeAt,
      "Hide rememberSpecials before wipe")
    assert_true(type(remAt) == "number" and type(frameHideAt) == "number" and remAt < frameHideAt,
      "Hide remounts rememberSpecial FRAME_NAME before Hide")
    assert_true(type(wireAt) == "number" and type(wipeAt) == "number" and wireAt < wipeAt,
      "Hide wires OnHide before wipe")
    assert_true(type(wireAt) == "number" and type(frameHideAt) == "number" and wireAt < frameHideAt,
      "Hide wires OnHide before Hide")
    assert_eq(hideBody:find('SetScript("OnHide"', 1, true), nil,
      "Hide does not SetScript OnHide inline")
    assert_eq(hideBody:find("OnShow", 1, true), nil,
      "Hide does not re-wire OnShow")
    assert_eq(hideBody:find("buildFrame", 1, true), nil,
      "Hide does not rebuild")
    assert_eq(hideBody:find("CreateFrame", 1, true), nil,
      "Hide does not CreateFrame")
    assert_eq(hideBody:find("PlaySound", 1, true), nil,
      "Hide does not PlaySound")
    assert_eq(hideBody:find("IG_CHARACTER_INFO", 1, true), nil,
      "Hide does not PlaySound IG_CHARACTER_INFO")
    assert_eq(hideBody:find(":Show()", 1, true), nil,
      "Hide does not Show")
    assert_eq(hideBody:find("ensureFrame", 1, true), nil,
      "Hide does not call ensureFrame")
    assert_eq(hideBody:find("Clear Decree", 1, true), nil,
      "Hide has no Clear Decree chrome")
    assert_true(type(earlyEnsure) == "string" and earlyEnsure ~= "",
      "B36-D early-return body is readable")
    assert_true(earlyEnsure:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "ensureFrame remount rememberSpecial stays")
    assert_true(earlyEnsure:find("wireDecreeOnHide", 1, true) ~= nil,
      "ensureFrame remount stays")
    assert_eq(refreshBody:find("wireDecreeOnHide", 1, true), nil,
      "Refresh still does not call wireDecreeOnHide")
    assert_true(src:find('themeFont("display")', 1, true) ~= nil,
      "line stays Theme display after Hide special remount")
    assert_eq(src:find("Clear Decree", 1, true), nil,
      "source still has no Clear Decree chrome")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")

    assert_true(Banner.frame ~= nil, "frame already exists before Hide special remount")
    local same = Banner.frame
    assert_eq(same:GetName(), "ChurchOfBeefDecree",
      "B36-D frame name stays ChurchOfBeefDecree")
    local existingOnHide = same:GetScript("OnHide")
    assert_true(existingOnHide ~= nil, "OnHide is already wired before Hide special remount")
    local savedSpecial = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefDecree"), 0,
      "B36-D wipe clears ChurchOfBeefDecree")
    local cuesHide = sounds
    assert_eq(Banner:Hide(), true, "Hide remounts special")
    assert_eq(Banner.frame, same, "Hide remount does not rebuild")
    assert_eq(same:GetName(), "ChurchOfBeefDecree",
      "Hide remount keeps the named frame")
    assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
      "wiped UISpecialFrames + Hide lists ChurchOfBeefDecree once")
    assert_eq(same:GetScript("OnHide"), existingOnHide,
      "Hide remount does not replace existing OnHide")
    assert_eq(same:GetScript("OnShow"), nil,
      "Hide remount does not wire OnShow")
    assert_eq(sounds, cuesHide, "Hide remount plays no sound")
    Banner:Hide()
    assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
      "second Hide after wipe does not duplicate ChurchOfBeefDecree")
    assert_eq(same:GetScript("OnHide"), existingOnHide,
      "second Hide keeps OnHide identity")
    Banner:Hide()
    assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
      "third Hide does not duplicate ChurchOfBeefDecree")
    assert_eq(Banner.frame, same, "third Hide does not rebuild")
    assert_eq(same:GetScript("OnHide"), existingOnHide,
      "third Hide keeps OnHide identity")
    assert_eq(sounds, cuesHide, "third Hide plays no sound")

    same:SetScript("OnHide", nil)
    assert_eq(same:GetScript("OnHide"), nil, "OnHide dropped before Hide remount stay")
    assert_eq(Banner:Hide(), true, "Hide remount stay succeeds")
    assert_eq(Banner.frame, same, "Hide remount stay does not rebuild")
    local afterHide = same:GetScript("OnHide")
    assert_true(afterHide ~= nil, "Hide remounts a missing OnHide")
    assert_eq(countSpecial("ChurchOfBeefDecree"), 1,
      "Hide remount stay still lists ChurchOfBeefDecree once")
    assert_eq(sounds, cuesHide, "Hide remount stay plays no sound")
    Decree:Clear()
    Banner:Hide()
    UISpecialFrames = savedSpecial
  end
  runB36D()
end
runB25B()

local view0 = Banner:GetView()
assert_eq(view0.shown, false, "silent view is hidden")
assert_eq(view0.header, HEADER, "view still names the fixed header")
assert_eq(view0.line, nil, "silent view has no line")
assert_eq(view0.flavor, nil, "silent view has no flavor")
assert_eq(view0.title, nil, "view does not invent a title field")

--------------------------------------------------------------------------------
-- Show with no Decree refuses an empty parchment.
--------------------------------------------------------------------------------
assert_eq(Banner:Show(), false, "Show without a Decree fails")
assert_eq(Banner:IsShown(), false, "Show without a Decree does not paint empty parchment")
assert_eq(sounds, 0, "refused Show plays no sound")

--------------------------------------------------------------------------------
-- Init with an active Decree shows the banner once this session.
--------------------------------------------------------------------------------
reset()
local posted = Decree:Set({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "Bring a friend.",
})
assert_true(posted ~= nil, "Core Set posts a Decree")
frame = Banner:Init()
assert_eq(Banner:IsShown(), true, "Init shows the banner when Get is non-nil")
assert_eq(frame:IsShown(), true, "the widget is shown")
assert_eq(frame.HeaderText:GetText(), HEADER, "header is the fixed UI copy")
assert_eq(frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "line is Get().line")
assert_eq(frame.FlavorText:GetText(), "Bring a friend.", "flavor is Get().flavor")
assert_eq(frame.FlavorText:IsShown(), true, "flavor line is visible when set")
assert_eq(sounds, 0, "auto-show plays no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "shown banner has no OnUpdate")

local view = Banner:GetView()
assert_eq(view.shown, true, "view agrees the banner is shown")
assert_eq(view.header, HEADER, "view header is UI copy")
assert_eq(view.line, "Goldshire Inn — Sunday, 7:00 PM", "view line comes from Core")
assert_eq(view.flavor, "Bring a friend.", "view flavor comes from Core")
assert_eq(view.title, nil, "view does not invent a title")
assert_eq(view.deputy, nil, "view does not invent a deputy")
assert_eq(view.postedAt, nil, "view does not invent postedAt")

Banner:Init()
assert_eq(Banner:IsShown(), true, "second Init does not hide a shown banner")
assert_eq(Banner:Init(), frame, "second Init returns the same frame")

--------------------------------------------------------------------------------
-- Close dismisses. Same-session Init does not auto-show again. Show replays.
--------------------------------------------------------------------------------
local close = frame.CloseButton
assert_true(close ~= nil, "a close control exists")
assert_true(stub.fire(close, "OnClick"), "close is wired")
assert_eq(Banner:IsShown(), false, "close hides the banner")
assert_eq(sounds, 0, "close plays no addon sound")

Banner:Init()
assert_eq(Banner:IsShown(), false, "same-session Init does not auto-show again")

assert_eq(Banner:Show(), true, "Show replays an active Decree")
assert_eq(Banner:IsShown(), true, "minimap-style Show opens the banner again")
assert_eq(frame.HeaderText:GetText(), HEADER, "replay still paints the header")
assert_eq(frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "replay still paints the line")
assert_eq(sounds, 0, "replay plays no sound")

assert_eq(Banner:Hide(), true, "Hide succeeds")
assert_eq(Banner:IsShown(), false, "Hide dismisses the banner")
assert_eq(Banner:Hide(), true, "Hide on a closed banner is still success")

--------------------------------------------------------------------------------
-- Optional flavor. Extra stored fields are not a title line.
--------------------------------------------------------------------------------
reset()
Decree:Set({ line = "Shattrath — Friday, 8:00 PM" })
frame = Banner:Init()
assert_eq(Banner:IsShown(), true, "a line-only Decree still shows")
assert_eq(frame.HeaderText:GetText(), HEADER, "header stays the fixed copy")
assert_eq(frame.LineText:GetText(), "Shattrath — Friday, 8:00 PM", "line-only paints the line")
assert_eq(frame.FlavorText:GetText(), "", "omitted flavor paints empty")
assert_eq(frame.FlavorText:IsShown(), false, "omitted flavor hides the flavor line")
assert_eq(Banner:GetView().flavor, nil, "view flavor is nil when omitted")

Decree:Set({
  line = "Orgrimmar — Saturday",
  flavor = "The Gathering.",
  title = "A GATHERING HAS BEEN DECREED",
  deputy = "Steve",
})
assert_eq(Banner:Show(), true, "Show repaints after Set")
assert_eq(frame.LineText:GetText(), "Orgrimmar — Saturday", "repaint uses the new line")
assert_eq(frame.FlavorText:GetText(), "The Gathering.", "repaint uses the new flavor")
assert_eq(frame.FlavorText:IsShown(), true, "flavor line returns when set")
assert_eq(frame.HeaderText:GetText(), HEADER, "header is never taken from a stored title")
assert_eq(Banner:GetView().title, nil, "stored title is not a view field")
assert_eq(Banner:GetView().deputy, nil, "stored deputy is not a view field")

--------------------------------------------------------------------------------
-- GetView is a copy. Banner does not write Core.
--------------------------------------------------------------------------------
view = Banner:GetView()
view.line = "mutated"
view.header = "hacked"
view.shown = false
local again = Banner:GetView()
assert_eq(again.line, "Orgrimmar — Saturday", "mutating GetView does not change the live view")
assert_eq(again.header, HEADER, "mutating GetView does not change the header")
assert_eq(again.shown, true, "mutating GetView does not hide the banner")
assert_eq(Decree:Get().line, "Orgrimmar — Saturday", "banner does not write Core line")
assert_eq(Decree:Get().flavor, "The Gathering.", "banner does not write Core flavor")

--------------------------------------------------------------------------------
-- Clear: no empty parchment. Session flag is not SavedVariables.
--------------------------------------------------------------------------------
Decree:Clear()
assert_eq(Decree:Get(), nil, "Core Clear removes the Decree")
assert_eq(Banner:Show(), false, "Show after Clear refuses empty parchment")
assert_eq(Banner:IsShown(), false, "Clear + Show hides rather than painting blanks")
assert_eq(frame.LineText:GetText(), "", "Clear + empty Show blanks leftover line")
assert_eq(frame.FlavorText:GetText(), "", "Clear + empty Show blanks leftover flavor")
assert_eq(frame.FlavorText:IsShown(), false, "Clear + empty Show hides flavor")

ChurchOfBeefDB = { ui = {} }
reset()
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
Banner:Init()
assert_eq(Banner:IsShown(), true, "Init shows with a live Decree")
Banner:Hide()
assert_eq(ChurchOfBeefDB.ui.decreeSeen, nil, "already-seen is not saved as decreeSeen")
assert_eq(ChurchOfBeefDB.ui.alreadySeen, nil, "already-seen is not saved as alreadySeen")
assert_eq(ChurchOfBeefDB.ui.shownThisSession, nil, "session flag is not a ui key")
assert_eq(ChurchOfBeefDB.decreeSeen, nil, "already-seen is not a root SV key")
assert_eq(ChurchOfBeefDB.ui.decree, nil, "Init without a drag writes no decree slot")
ChurchOfBeefDB = nil

--------------------------------------------------------------------------------
-- /reload (fresh module locals) may show again. Same-session Init does not.
--------------------------------------------------------------------------------
reset()
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "Bring a friend." })
Banner:Init()
assert_eq(Banner:IsShown(), true, "first login shows the banner")
Banner:Hide()
Banner:Init()
assert_eq(Banner:IsShown(), false, "same session does not auto-show twice")

dofile("addon/ChurchOfBeef/UI/Decree.lua")
Banner = COB.DecreeBanner
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "Core Decree survives the UI reload")
frame = Banner:Init()
assert_eq(Banner:IsShown(), true, "/reload may show the banner again")
assert_eq(frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "reloaded banner paints the live line")
assert_eq(frame.FlavorText:GetText(), "Bring a friend.", "reloaded banner paints the live flavor")

--------------------------------------------------------------------------------
-- Minimap:Init reaches the banner. Left-click replays or Toggles.
--------------------------------------------------------------------------------
reset()
local button = COB.Minimap:Init()
assert_true(button ~= nil, "Minimap:Init creates the button")
assert_eq(button.petitionPip, nil, "Quiet presence has no petition pip")
assert_eq(Banner:IsShown(), false, "Minimap:Init stays silent when Get is nil")
assert_eq(button:GetScript("OnUpdate"), nil, "a resting button runs nothing per frame")
frame = Banner.frame

stub.fire(button, "OnClick")
assert_eq(toggles, 1, "a plain click still opens the window when no Decree is set")
assert_eq(Banner:IsShown(), false, "a plain click does not invent a parchment")

Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
toggles = 0
stub.fire(button, "OnClick")
frame = Banner.frame
assert_eq(Banner:IsShown(), true, "left-click shows the banner when a Decree is active")
assert_eq(toggles, 0, "left-click does not Toggle while a Decree is active")
assert_eq(frame.HeaderText:GetText(), HEADER, "click replay paints the header")
assert_eq(frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "click replay paints the line")
assert_eq(sounds, 0, "click replay plays no sound")

Banner:Hide()
stub.fire(button, "OnClick")
assert_eq(Banner:IsShown(), true, "left-click shows the banner again after dismiss")
assert_eq(toggles, 0, "replay still does not Toggle")

Decree:Clear()
toggles = 0
Banner:Hide()
stub.fire(button, "OnClick")
assert_eq(toggles, 1, "after Clear, left-click opens the window again")
assert_eq(Banner:IsShown(), false, "after Clear, click does not show empty parchment")

--------------------------------------------------------------------------------
-- Tooltip may name the Decree when one is active. Presence only.
--------------------------------------------------------------------------------
reset()
button = COB.Minimap:Init()
tipLines = {}
stub.fire(button, "OnEnter")
assert_true(tipHas("Church of Beef"), "tooltip names the addon")
assert_true(tipHas("Left-click: /beef"), "empty Decree tooltip keeps the /beef hint")
assert_eq(tipHas(HEADER), false, "empty Decree tooltip does not name a gathering")
assert_eq(tipHas("RSVP"), false, "tooltip has no RSVP")

Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
COB.Minimap:Refresh()
tipLines = {}
stub.fire(button, "OnEnter")
assert_true(tipHas("Church of Beef"), "active tooltip still names the addon")
assert_true(tipHas(HEADER), "active tooltip names the Decree header")
assert_true(tipHas("Goldshire Inn — Sunday, 7:00 PM"), "active tooltip names the Decree line")
assert_eq(tipHas("Left-click: /beef"), false, "active tooltip does not claim /beef on left-click")
assert_eq(tipHas("RSVP"), false, "active tooltip has no RSVP")
assert_eq(tipHas("3 days"), false, "tooltip has no countdown")

--------------------------------------------------------------------------------
-- Missing CreateFrame / missing custom media must not fail load.
--------------------------------------------------------------------------------
reset()
local savedCreate = CreateFrame
CreateFrame = nil
assert_eq(Banner:Init(), nil, "Init without CreateFrame returns nil")
assert_eq(Banner:IsShown(), false, "Init without CreateFrame stays hidden")
CreateFrame = savedCreate
frame = Banner:Init()
assert_true(frame ~= nil, "Init after CreateFrame returns builds the frame")
assert_eq(Banner:IsShown(), false, "rebuilt Init with no Decree stays silent")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness.
--------------------------------------------------------------------------------
reset()
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
Banner:Init()
assert_eq(Banner:IsShown(), true, "banner is showing before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(Banner:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Banner:IsShown(), true, "out-of-harness reset does not hide the banner")
ChurchOfBeef._IN_TEST = true
assert_eq(Banner:ResetForTests(), true, "ResetForTests returns under _IN_TEST")
assert_eq(Banner:IsShown(), false, "harness reset hides the banner")

assert_eq(sounds, 0, "the suite played no sound")

COB.UI = savedUi
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
