-- Fight HUD (Wire W-F favor + Vestments V-D dress + B4-F name fields
-- + B8-D mute defense integer + B9-E persist through the verdict
-- + B10-B congregation pair from Runtime subjects.fighters
-- + B11-B leftover plate clicks never use lastPair
-- + B16-C congregation picks only while RITE and riteType Gora
-- + B17-D livePair runtime arm only while RITE and riteType Gora
-- + B19-C lastPair does not paint during a non-Gora RITE
-- + B21-B lastPair does not paint during a non-Gora CONSEQUENCE
-- + B32-A non-Gora refuse forgets lastPair
-- + B22-B fighter names use Theme:FontPath("display") at size ≥ 16
-- + B25-D Refresh/paintShown re-applies applyNameFont
-- + B34-A paintShown re-tints names after applyNameFont
-- + B35-A defenseA / defenseB SetWidth(28)
-- + B37-B Quiet forgetPersist also nils broadcastFavor). Isolated:
-- wow_ui_stub + Common + Theme + Ranks + Runtime + Store + Gora + Hud.
-- Event Mode only. No live health, favor economy, sound, or toasts.
-- Standalone wrap. Congregation never Sanctions; the star pair is
-- subjects.fighters. Congregation favor is broadcast-only. Pope stub
-- fills from Gora:GetFavorSplit; after the pair clears, the last split
-- is frozen. Plate picks: live GetSanctioned (isolated / Pope) or
-- Runtime fighters only while RITE and riteType Gora (B16-C). Display
-- livePair runtime arm is the same Gora-RITE gate (B17-D). lastPair
-- does not paint during a non-Gora RITE (B19-C) or a non-Gora
-- CONSEQUENCE (B21-B). A non-Gora refuse forgets lastPair so Knighting
-- Continue stays hidden (B32-A). paintShown restores class tint after
-- applyNameFont (B34-A). Defense labels are SetWidth(28) (B35-A). Quiet
-- forget also drops leftover congregation favor (B37-B). Never lastPair
-- clicks. Dress is Theme HUD-B — no faction crests, no hardcoded Media
-- or font paths. Thin frame_proclamation_center fields sit behind
-- name+format. Defense count is Store:CountDefenses as a mute integer;
-- zero or a missing method hides. Painted records are RomanPair.
-- Ranks is Data for Church titles. No TOC / bootstrap / run.lua edits.
package.path = package.path .. ";./tests/?.lua"

local stub = require("wow_ui_stub")
local restore = stub.install()

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
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")
dofile("addon/ChurchOfBeef/UI/Hud.lua")

local COB = ChurchOfBeef
local Hud = COB.Hud
local Gora = COB.Gora
local Store = COB.Store
local Runtime = COB.Runtime
local Ranks = COB.Ranks
local Theme = COB.Theme
local EN_DASH = "\226\128\147"
local FORMAT_DOT = " \194\183 "

local sounds = 0
PlaySound = function()
  sounds = sounds + 1
end
PlaySoundFile = function()
  sounds = sounds + 1
end

local healthReads = 0
UnitHealth = function()
  healthReads = healthReads + 1
  return 100
end
UnitHealthMax = function()
  healthReads = healthReads + 1
  return 100
end
CombatLogGetCurrentEventInfo = function()
  healthReads = healthReads + 1
end
C_NamePlate = {
  GetNamePlates = function()
    healthReads = healthReads + 1
    return {}
  end,
}

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Gora:ResetForTests(), true, "Gora ResetForTests runs under _IN_TEST")
  assert_eq(Hud:ResetForTests(), true, "Hud ResetForTests runs under _IN_TEST")
  sounds = 0
  healthReads = 0
end

local function twoChars(fieldsA, fieldsB)
  local a = Store:CreateCharacter(fieldsA or { name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter(fieldsB or { name = "Tendermage", class = "Mage", level = 68 })
  return a, b
end

local function sanctionPair()
  reset()
  Runtime:StartEvent()
  local a, b = twoChars()
  local pair = Gora:Sanction(a.id, b.id)
  return a, b, pair
end

local function findStatusBar(widget)
  if widget._type == "StatusBar" then return widget end
  for i = 1, #(widget._children or {}) do
    local hit = findStatusBar(widget._children[i])
    if hit then return hit end
  end
  return nil
end

local function countStatusBars(widget)
  local n = 0
  if widget._type == "StatusBar" then n = n + 1 end
  for i = 1, #(widget._children or {}) do
    n = n + countStatusBars(widget._children[i])
  end
  return n
end

local function sameRgb(color, sample)
  return color and sample
    and color.r == sample.r and color.g == sample.g and color.b == sample.b
end

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(Hud ~= nil, "Hud is loaded")
assert_true(Store ~= nil, "Store is loaded")
assert_true(Runtime ~= nil, "Runtime is loaded")
assert_true(Gora ~= nil, "Gora is loaded")
assert_true(Ranks ~= nil, "Ranks is loaded for Church titles")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_true(Theme ~= nil, "Theme is loaded for HUD-B dress")
assert_true(type(COB.Common.RomanPair) == "function", "RomanPair is available")

if standalone then
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.UI, nil, "isolated suite does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Snapshot, nil, "isolated suite does not load Snapshot")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
end

assert_eq(Hud.MODE, "Event", "HUD declares Event Mode")
assert_eq(type(Hud.Init), "function", "Init builds the surface")
assert_eq(type(Hud.Refresh), "function", "Refresh paints from Core")
assert_eq(type(Hud.IsShown), "function", "IsShown reads visibility")
assert_eq(type(Hud.GetView), "function", "GetView returns a copy")
assert_eq(type(Hud.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(type(Hud.SetBroadcastFavor), "function", "SetBroadcastFavor is the congregation fill")
assert_eq(type(Hud.SetFavorTarget), "function", "SetFavorTarget remembers the whisper dest")
assert_eq(type(Hud.SetLocalCharacterId), "function", "SetLocalCharacterId remembers the picker")
assert_eq(type(Hud.PickFavor), "function", "PickFavor is the congregation send")
assert_eq(Hud.Favor, nil, "no favor economy table")
assert_eq(Hud.SendFavor, nil, "no public SendFavor alias")
assert_eq(Hud.INPUT, nil, "no invented INPUT channel")
assert_eq(Hud.GetHealth, nil, "no health getter")
assert_eq(Hud.ScrapeHealth, nil, "no health scrape")
assert_eq(Hud.PlayCue, nil, "no sound this lane")
assert_eq(Hud.Toast, nil, "HUD is not a toast")
assert_eq(Hud.Announce, nil, "software does not announce")
assert_eq(Hud.Narrate, nil, "software does not narrate")
assert_eq(Hud.Sanction, nil, "HUD does not sanction")
assert_eq(Hud.DeclareVictor, nil, "HUD does not record outcomes")

--------------------------------------------------------------------------------
-- Source contract: no scrape, no sound, no toast engine. StatusBar is stock.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/Hud.lua", "r")
assert_true(srcFile ~= nil, "Hud.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("UnitHealth", 1, true), nil, "source does not read UnitHealth")
assert_eq(src:find("COMBAT_LOG", 1, true), nil, "source does not read the combat log")
assert_eq(src:find("NamePlate", 1, true), nil, "source does not scrape nameplates")
assert_eq(src:find("C_NamePlate", 1, true), nil, "source does not call C_NamePlate")
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_true(src:find("StatusBar", 1, true) ~= nil, "source mints a stock StatusBar")
assert_true(src:find('Theme:Texture("bar_stainedglass_fill")', 1, true) ~= nil,
  "mute rails resolve bar_stainedglass_fill through Theme")
assert_true(src:find('Theme:Texture("bar_favor_fill")', 1, true) ~= nil,
  "favor halves resolve bar_favor_fill through Theme")
assert_eq(src:find("UI-StatusBar", 1, true), nil, "source does not hardcode UI-StatusBar")
assert_eq(src:find(".tga", 1, true), nil, "source does not load custom tga")
assert_eq(src:find(".blp", 1, true), nil, "source does not load custom blp")
do
  -- B22-B: Theme display font on fighter names. No hardcoded font paths.
  -- B25-D: applyNameFont is called from paintShown, not only build().
  assert_true(src:find('Theme:FontPath("display")', 1, true) ~= nil,
    "names resolve through Theme display")
  assert_eq(src:find("Fonts\\\\MORPHEUS", 1, true), nil, "source does not hardcode Morpheus")
  assert_eq(src:find("MORPHEUS.TTF", 1, true), nil, "name path is not uppercase TTF")
  assert_eq(src:find("MORPHEUS_CYR", 1, true), nil, "source does not use GlueFonts MORPHEUS_CYR")
  assert_true(src:find("SetFontObject", 1, true) ~= nil, "applyNameFont still falls back to GameFont")
  assert_eq(src:find(".ttf", 1, true), nil, "source does not load custom fonts")
  local paintAt = src:find("function paintShown", 1, true)
  assert_true(paintAt ~= nil, "paintShown exists")
  local paintEnd = src:find("\nlocal function ", paintAt + 1, true)
  if not paintEnd then
    paintEnd = src:find("\nfunction ", paintAt + 1, true)
  end
  assert_true(paintEnd ~= nil, "paintShown body has a following function")
  local paintBody = src:sub(paintAt, paintEnd - 1)
  assert_true(paintBody:find("applyNameFont", 1, true) ~= nil,
    "paintShown re-applies name font on a shown pair")
  local buildAt = src:find("function build", 1, true)
  assert_true(buildAt ~= nil, "build exists")
  local buildEnd = src:find("\nfunction ", buildAt + 1, true)
  assert_true(buildEnd ~= nil, "build body has a following function")
  local buildBody = src:sub(buildAt, buildEnd - 1)
  assert_true(buildBody:find("applyNameFont", 1, true) ~= nil,
    "build still applies name font")
end
assert_eq(src:find("Media\\", 1, true), nil, "source does not require custom Media")
assert_eq(src:find("Toasts", 1, true), nil, "source does not drive Toasts")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("ShowUIPanel", 1, true), nil, "insecure Show/Hide only")
assert_eq(src:find("Interface\\PvPFrame\\", 1, true), nil, "source does not use PvPFrame crests")
assert_eq(src:find("PVP-Banner", 1, true), nil, "source does not use a PVP banner")
assert_eq(src:find("UI-PVP-Horde", 1, true), nil, "source does not use the Horde PVP icon")
assert_eq(src:find("UI-PVP-Alliance", 1, true), nil, "source does not use the Alliance PVP icon")
assert_eq(src:find("PlusManz-Horde", 1, true), nil, "source does not use PlusManz-Horde")
assert_eq(src:find("PlusManz-Alliance", 1, true), nil, "source does not use PlusManz-Alliance")
assert_eq(src:find("Beef Paladin", 1, true), nil, "source does not invent Beef Paladin")
assert_true(src:find('Theme:Texture("frame_proclamation_center")', 1, true) ~= nil,
  "parchment routes through Theme frame_proclamation_center")
assert_true(src:find('Theme:Texture("sigil_gora")', 1, true) ~= nil,
  "crest routes through Theme sigil_gora")
assert_true(src:find('Theme:Texture("sigil_favor")', 1, true) ~= nil,
  "FAVOR sigil routes through Theme sigil_favor")
assert_true(src:find("RomanPair", 1, true) ~= nil, "records use Common.RomanPair")
assert_true(src:find("nameFieldA", 1, true) ~= nil, "source names nameFieldA")
assert_true(src:find("nameFieldB", 1, true) ~= nil, "source names nameFieldB")
assert_true(src:find("CountDefenses", 1, true) ~= nil, "source reads Store:CountDefenses")
assert_true(src:find("subjects", 1, true) ~= nil, "source reads Runtime subjects")
assert_true(src:find("fighters", 1, true) ~= nil, "source reads subjects.fighters")
assert_true(src:find('riteType == "Gora"', 1, true) ~= nil,
  "congregation pick requires snap.riteType Gora")
do
  local goraRiteGates = 0
  for _ in src:gmatch('state == "RITE" and snap%.riteType == "Gora"') do
    goraRiteGates = goraRiteGates + 1
  end
  assert_true(goraRiteGates >= 2,
    "livePair and pickPair both gate runtimePair to Gora RITE")
end
assert_true(src:find('riteType ~= "Gora"', 1, true) ~= nil,
  "displayPair refuses lastPair during a non-Gora RITE or CONSEQUENCE")
assert_true(src:find('state == "RITE" or snap.state == "CONSEQUENCE"', 1, true) ~= nil,
  "displayPair lastPair refuse covers RITE and CONSEQUENCE")
do
  local displayAt = src:find("function displayPair", 1, true)
  assert_true(displayAt ~= nil, "displayPair exists")
  local displayEnd = src:find("\nlocal function ", displayAt + 1, true)
  if not displayEnd then
    displayEnd = src:find("\nfunction ", displayAt + 1, true)
  end
  assert_true(displayEnd ~= nil, "displayPair body has a following function")
  local displayBody = src:sub(displayAt, displayEnd - 1)
  assert_true(displayBody:find("forgetPersist", 1, true) ~= nil,
    "displayPair forgets lastPair when refusing a non-Gora leftover")
end
assert_eq(src:find("Gora:Sanction", 1, true), nil, "HUD does not call Gora:Sanction")
assert_true(src:find("defenseA", 1, true) ~= nil, "source names defenseA")
assert_true(src:find("defenseB", 1, true) ~= nil, "source names defenseB")
assert_eq(src:find("defenses of", 1, true), nil, "source does not invent defenses copy")
assert_eq(src:find("of the realm", 1, true), nil, "source does not invent realm copy")
assert_eq(src:find("UI-EmptySlot-White", 1, true), nil, "crest is not the EmptySlot ring")
assert_eq(src:find("MiniMap-TrackingBorder", 1, true), nil, "crest is not TrackingBorder")

--------------------------------------------------------------------------------
-- Init: hidden, top-center, movable, clamped. No per-frame script at rest.
--------------------------------------------------------------------------------
reset()
local frame = Hud:Init()
assert_true(frame ~= nil, "Init creates the HUD frame")
assert_eq(frame:GetName(), "ChurchOfBeefHud", "frame has a stable name")
assert_eq(frame:GetParent(), UIParent, "HUD is parented to UIParent")
assert_eq(Hud:Init(), frame, "Init is idempotent")
assert_eq(Hud:IsShown(), false, "HUD starts hidden in Quiet")
assert_eq(frame:IsShown(), false, "the widget starts hidden")
assert_eq(frame._movable, true, "HUD is movable")
assert_eq(frame._clamped, true, "HUD is clamped to screen")
assert_eq(frame:GetScript("OnUpdate"), nil, "a resting HUD runs nothing per frame")
assert_true(findStatusBar(frame) ~= nil, "Init mints a stock favor StatusBar")
assert_eq(countStatusBars(frame), 2, "only the two favor halves are StatusBars")
assert_eq(frame:GetWidth(), 420, "width stays a compact spectator card")
assert_eq(frame:GetHeight(), 100, "unknown UIParent height keeps the compact card")
assert_true(frame.parchment ~= nil, "iron/parchment dress has a parchment field")
assert_eq(frame.parchment._cobTexture, Theme:Texture("frame_proclamation_center"),
  "parchment is Theme frame_proclamation_center")
assert_true(frame.nameFieldA ~= nil, "name field A sits behind name+format")
assert_true(frame.nameFieldB ~= nil, "name field B sits behind name+format")
assert_eq(frame.nameFieldA._type, "Texture", "name field A is a texture, not a StatusBar")
assert_eq(frame.nameFieldB._type, "Texture", "name field B is a texture, not a StatusBar")
assert_eq(frame.nameFieldA._cobTexture, Theme:Texture("frame_proclamation_center"),
  "name field A is Theme frame_proclamation_center")
assert_eq(frame.nameFieldB._cobTexture, Theme:Texture("frame_proclamation_center"),
  "name field B is Theme frame_proclamation_center")
assert_true(
  frame.nameFieldA._layer == "BACKGROUND" or frame.nameFieldA._layer == "BORDER",
  "name field A draws behind name+format"
)
assert_true(
  frame.nameFieldB._layer == "BACKGROUND" or frame.nameFieldB._layer == "BORDER",
  "name field B draws behind name+format"
)
assert_true(frame.seal ~= nil, "center has a Gora-sigil crest slot")
assert_eq(frame.seal._cobTexture, Theme:Texture("sigil_gora"),
  "crest is Theme sigil_gora")
assert_eq(frame.railA._cobTexture, Theme:Texture("bar_stainedglass_fill"),
  "mute rail A is Theme bar_stainedglass_fill")
assert_eq(frame.railB._cobTexture, Theme:Texture("bar_stainedglass_fill"),
  "mute rail B is Theme bar_stainedglass_fill")
assert_eq(frame.barA._cobTexture, Theme:Texture("bar_favor_fill"),
  "favor bar A is Theme bar_favor_fill")
assert_eq(frame.barB._cobTexture, Theme:Texture("bar_favor_fill"),
  "favor bar B is Theme bar_favor_fill")
assert_eq(frame.nameA._cobFont, Theme:FontPath("display"),
  "name A font is Theme display")
assert_eq(frame.nameB._cobFont, Theme:FontPath("display"),
  "name B font is Theme display")
assert_true(type(frame.nameA._cobFontSize) == "number" and frame.nameA._cobFontSize >= 16,
  "name A size is ≥ 16")
assert_true(type(frame.nameB._cobFontSize) == "number" and frame.nameB._cobFontSize >= 16,
  "name B size is ≥ 16")
assert_true(frame.favorSigil ~= nil, "FAVOR has a sigil slot")
assert_eq(frame.favorSigil._cobTexture, Theme:Texture("sigil_favor"),
  "FAVOR sigil is Theme sigil_favor")
assert_eq(frame.favorSigil:IsShown(), false, "FAVOR sigil starts hidden")
assert_eq(frame.vs:GetText(), "VS", "center still reads VS")
assert_eq(frame.railA._type, "Texture", "mute rail A is a texture, not a health bar")
assert_eq(frame.railB._type, "Texture", "mute rail B is a texture, not a health bar")
assert_eq(frame.favorLabel:IsShown(), false, "FAVOR label starts hidden")
assert_eq(frame.barA:IsShown(), false, "favor bar A starts hidden")
assert_eq(frame.barB:IsShown(), false, "favor bar B starts hidden")
assert_true(frame.defenseA ~= nil, "defense A is a mute integer slot")
assert_true(frame.defenseB ~= nil, "defense B is a mute integer slot")
assert_eq(frame.defenseA:IsShown(), false, "defense A starts hidden")
assert_eq(frame.defenseB:IsShown(), false, "defense B starts hidden")
assert_eq(frame.defenseA._template, "GameFontNormal", "defense A is stock GameFont")
assert_eq(frame.defenseB._template, "GameFontNormal", "defense B is stock GameFont")
assert_eq(frame.nameA._template, "GameFontHighlight", "name A still uses GameFontHighlight")
assert_eq(frame.nameB._template, "GameFontHighlight", "name B still uses GameFontHighlight")
assert_eq(frame.titleA._template, "GameFontNormal", "title A stays GameFont")
assert_eq(frame.titleB._template, "GameFontNormal", "title B stays GameFont")
assert_eq(frame.recordA._template, "GameFontNormal", "record A stays GameFont")
assert_eq(frame.recordB._template, "GameFontNormal", "record B stays GameFont")
assert_eq(frame.vs._template, "GameFontNormal", "VS stays GameFont")
assert_eq(frame.favorLabel._template, "GameFontHighlightSmall", "FAVOR stays GameFont")

local point, relativeTo, relativePoint, x, y = frame:GetPoint(1)
assert_eq(point, "TOP", "default anchor is the top")
assert_eq(relativeTo, UIParent, "default relative is UIParent")
assert_eq(relativePoint, "TOP", "default relative point is the top")
assert_eq(x, 0, "default is horizontally centered")
assert_true(type(y) == "number" and y < 0, "default sits below the top edge")

local view0 = Hud:GetView()
assert_eq(view0.shown, false, "Quiet view is hidden")
assert_eq(view0.fighterA, nil, "Quiet view has no fighter A")
assert_eq(view0.fighterB, nil, "Quiet view has no fighter B")
assert_eq(view0.headToHead, nil, "Quiet view has no head-to-head")
assert_eq(view0.health, nil, "view never carries health")
assert_eq(view0.favor, nil, "Quiet view has no favor")

--------------------------------------------------------------------------------
-- Quiet and Event-without-a-pair stay hidden
--------------------------------------------------------------------------------
reset()
Hud:Refresh()
assert_eq(Hud:IsShown(), false, "QUIET with no pair hides the HUD")

Runtime:StartEvent()
Hud:Refresh()
assert_eq(Hud:IsShown(), false, "ASSEMBLY without a sanctioned pair stays hidden")
assert_eq(Gora:GetSanctioned(), nil, "no live pair yet")

twoChars()
Hud:Refresh()
assert_eq(Hud:IsShown(), false, "characters alone do not show the HUD")
assert_eq(Gora:GetSanctioned(), nil, "CreateCharacter is not a Sanction")

--------------------------------------------------------------------------------
-- Sanction in Event Mode shows the compact card
--------------------------------------------------------------------------------
local a, b, pair = sanctionPair()
assert_true(pair ~= nil, "Sanction returns a live pair")
local view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "Event Mode plus a live pair shows the HUD")
assert_eq(view.shown, true, "view agrees the HUD is shown")
assert_eq(view.mode, "Event", "painted view is Event Mode")
assert_eq(view.fighterA.name, "Chuckroast", "fighter A name comes from Store")
assert_eq(view.fighterB.name, "Tendermage", "fighter B name comes from Store")
assert_eq(view.fighterA.level, 70, "fighter A level comes from Store")
assert_eq(view.fighterB.level, 68, "fighter B level comes from Store")
assert_eq(view.fighterA.wins, 0, "fresh W/L starts at zero wins")
assert_eq(view.fighterA.losses, 0, "fresh W/L starts at zero losses")
assert_eq(view.fighterB.wins, 0, "other fresh W/L starts at zero wins")
assert_eq(view.fighterB.losses, 0, "other fresh W/L starts at zero losses")
assert_eq(view.fighterA.title, nil, "unlinked characters have no invented title")
assert_eq(view.fighterB.title, nil, "the other unlinked character has no invented title")
assert_eq(view.headToHead, nil, "no head-to-head line without Store history")
assert_eq(view.health, nil, "shown view still has no health")
assert_eq(view.favor, nil, "congregation with no broadcast hides favor")
assert_eq(view.defenses, nil, "pair view does not invent a defenses table")
assert_eq(view.fighterA.defenses, nil, "fresh fighter A hides defenses")
assert_eq(view.fighterB.defenses, nil, "fresh fighter B hides defenses")
assert_eq(frame.defenseA:IsShown(), false, "fresh pair hides defense A")
assert_eq(frame.defenseB:IsShown(), false, "fresh pair hides defense B")
assert_eq(view.odds, nil, "no odds copy")
assert_eq(frame.nameA:GetText(), "Chuckroast", "name A is painted")
assert_eq(frame.nameB:GetText(), "Tendermage", "name B is painted")
assert_eq(frame.levelA:GetText(), "70", "level A is painted")
assert_eq(frame.levelB:GetText(), "68", "level B is painted")
assert_eq(frame.titleA:GetText(),
  "Chuckroast" .. FORMAT_DOT .. "70" .. FORMAT_DOT .. "Warrior",
  "format A is Name · Level · Class")
assert_eq(frame.titleB:GetText(),
  "Tendermage" .. FORMAT_DOT .. "68" .. FORMAT_DOT .. "Mage",
  "format B is Name · Level · Class")
assert_eq(frame.recordA:GetText(), "N" .. EN_DASH .. "N", "record A is roman 0–0")
assert_eq(frame.recordB:GetText(), "N" .. EN_DASH .. "N", "record B is roman 0–0")
assert_eq(frame.headToHead:IsShown(), false, "head-to-head widget hides without history")
assert_eq(frame.favorLabel:IsShown(), false, "congregation without broadcast hides FAVOR")
assert_eq(frame.barA:IsShown(), false, "congregation without broadcast hides bar A")
assert_eq(frame.barB:IsShown(), false, "congregation without broadcast hides bar B")
assert_true(findStatusBar(frame) ~= nil, "shown HUD still has the stock favor bars")
assert_eq(sounds, 0, "showing the HUD plays no sound")
assert_eq(healthReads, 0, "showing the HUD does not read live health")
assert_eq(#stub.chat, 0, "HUD never SendChatMessage")
assert_eq(#stub.addonMessages, 0, "HUD never SendAddonMessage")

--------------------------------------------------------------------------------
-- Class color on the name only
--------------------------------------------------------------------------------
local warrior = RAID_CLASS_COLORS.WARRIOR
local mage = RAID_CLASS_COLORS.MAGE
assert_eq(view.fighterA.nameColor.r, warrior.r, "Warrior name uses class red")
assert_eq(view.fighterA.nameColor.g, warrior.g, "Warrior name uses class green")
assert_eq(view.fighterA.nameColor.b, warrior.b, "Warrior name uses class blue")
assert_eq(view.fighterB.nameColor.r, mage.r, "Mage name uses class red")
assert_eq(view.fighterB.nameColor.g, mage.g, "Mage name uses class green")
assert_eq(view.fighterB.nameColor.b, mage.b, "Mage name uses class blue")
assert_true(frame.nameA._cobColor ~= nil, "name A stores the applied tint")
assert_eq(frame.nameA._cobColor.r, warrior.r, "name A widget is class-tinted")
assert_eq(sameRgb(frame.levelA._cobColor, warrior), false, "level A is not class-colored")
assert_eq(sameRgb(frame.titleA._cobColor, warrior), false, "title A is not class-colored")
assert_eq(sameRgb(frame.recordA._cobColor, warrior), false, "record A is not class-colored")
assert_eq(sameRgb(frame.levelB._cobColor, mage), false, "level B is not class-colored")
assert_eq(sameRgb(frame.titleB._cobColor, mage), false, "title B is not class-colored")
assert_eq(sameRgb(frame.recordB._cobColor, mage), false, "record B is not class-colored")
assert_eq(sameRgb(frame.railA._cobColor, warrior), true, "mute rail A is fighter-tinted")
assert_eq(sameRgb(frame.railB._cobColor, mage), true, "mute rail B is fighter-tinted")
assert_eq(countStatusBars(frame), 2, "decorative rails did not add health StatusBars")

--------------------------------------------------------------------------------
-- Church title from the human rank. No Fresh Beef default on an unlinked row.
--------------------------------------------------------------------------------
local human = Store:CreateHuman({ name = "Chuck" })
Store:LinkCharacter(a.id, human.id)
Store:SetRank(human.id, 3)
view = Hud:Refresh()
assert_eq(view.fighterA.title, "Beef Knight", "linked Knight title comes from Ranks")
assert_eq(frame.titleA:GetText(),
  "Chuckroast" .. FORMAT_DOT .. "70" .. FORMAT_DOT .. "Beef Knight" .. FORMAT_DOT .. "Warrior",
  "format A is Name · Level · Title · Class")
assert_eq(string.find(frame.titleA:GetText() or "", "Paladin", 1, true), nil,
  "title is the Church title, not a class mash")
assert_eq(view.fighterB.title, nil, "unlinked opponent still has no title")
assert_eq(frame.titleB:GetText(),
  "Tendermage" .. FORMAT_DOT .. "68" .. FORMAT_DOT .. "Mage",
  "unlinked format omits a title, not Fresh Beef")

--------------------------------------------------------------------------------
-- Head-to-head appears only when Store already has history.
-- HUD persists through the verdict beat (Bible §10.7).
--------------------------------------------------------------------------------
Gora:DeclareVictor(a.id)
assert_eq(Gora:GetSanctioned(), nil, "a ruling clears the live pair")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "HUD stays shown after DeclareVictor while the event is live")
assert_eq(view.shown, true, "shown is true after the pair clears mid-event")
assert_eq(view.fighterA.name, "Chuckroast", "remembered pair still paints fighter A")
assert_eq(view.fighterB.name, "Tendermage", "remembered pair still paints fighter B")
assert_eq(view.health, nil, "persist still has no health")
assert_eq(view.favor, nil, "congregation persist still follows W-F (no broadcast)")
assert_eq(view.verdict, nil, "HUD does not invent a verdict qualifier")
assert_eq(Store:GetCharacter(a.id).gora.wins, 1, "Store recorded the win")
assert_eq(Store:GetCharacter(b.id).gora.losses, 1, "Store recorded the loss")

local rematch = Gora:Sanction(a.id, b.id)
assert_true(rematch ~= nil, "same pair may be sanctioned again")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "a rematch shows the HUD again")
assert_eq(view.fighterA.wins, 1, "W/L reflects Store after the first ruling")
assert_eq(view.fighterA.losses, 0, "winner has no loss")
assert_eq(view.fighterB.wins, 0, "loser has no win")
assert_eq(view.fighterB.losses, 1, "loser has one loss")
assert_eq(frame.recordA:GetText(), "I" .. EN_DASH .. "N", "painted record A follows Store in roman")
assert_eq(frame.recordB:GetText(), "N" .. EN_DASH .. "I", "painted record B follows Store in roman")
assert_true(view.headToHead ~= nil, "Store history produces a head-to-head line")
assert_eq(view.headToHead.wins, 1, "head-to-head wins are fighter A's")
assert_eq(view.headToHead.losses, 0, "head-to-head losses are fighter A's")
assert_eq(view.headToHead.fights, 1, "head-to-head fights come from Store")
assert_eq(view.headToHead.score, nil, "head-to-head has no pairing score")
assert_eq(frame.headToHead:IsShown(), true, "head-to-head widget shows when history exists")
assert_eq(frame.headToHead:GetText(), "I" .. EN_DASH .. "N", "head-to-head line is the roman Store record")
assert_eq(string.find(frame.headToHead:GetText() or "", "meeting", 1, true), nil,
  "head-to-head is a record, not narration")
assert_eq(string.find(frame.headToHead:GetText() or "", "odds", 1, true), nil,
  "head-to-head has no odds copy")

--------------------------------------------------------------------------------
-- RITE / CONSEQUENCE with a live pair still show. QUIET hides.
--------------------------------------------------------------------------------
assert_true(Runtime:OpenRite("Gora", { fighters = { a.id, b.id } }) ~= nil, "OpenRite is a Runtime verb")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "RITE with a live pair still shows")
assert_eq(Runtime:Snapshot().state, "RITE", "runtime is RITE")

assert_true(Runtime:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
view = Hud:Refresh()
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "runtime is CONSEQUENCE")
assert_eq(Hud:IsShown(), true, "CONSEQUENCE with a live pair still shows")

assert_true(Runtime:MarkPopeLost() ~= nil, "awaitingPope is Event Mode degraded")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "awaitingPope does not hide a live pair")
Runtime:ClearPopeLost()

assert_true(Runtime:Continue() ~= nil, "Continue returns to ASSEMBLY")
view = Hud:Refresh()
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY again")
assert_eq(Hud:IsShown(), true, "ASSEMBLY with a live pair still shows")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent returns to QUIET")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET")
assert_eq(Gora:GetSanctioned(), nil, "QUIET expires the live pair")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "Quiet Mode hides the HUD")
assert_eq(view.shown, false, "Quiet view is hidden")
assert_eq(sounds, 0, "hiding plays no sound")
assert_eq(healthReads, 0, "hiding does not scrape health")

--------------------------------------------------------------------------------
-- Knighting rite does not hide a sanctioned pair. HUD keys off pair + not QUIET.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
Runtime:OpenRite("Knighting", { candidate = a.id })
view = Hud:Refresh()
assert_eq(Runtime:Snapshot().riteType, "Knighting", "rite type is Knighting")
assert_eq(Hud:IsShown(), true, "a live pair still shows during another rite")

--------------------------------------------------------------------------------
-- Missing class colors and unknown class still paint names
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars({ name = "Mystery", class = "Banana", level = 10 }, { name = "Plain", level = 12 })
Gora:Sanction(a.id, b.id)
local savedColors = RAID_CLASS_COLORS
RAID_CLASS_COLORS = nil
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "missing RAID_CLASS_COLORS does not hide the HUD")
assert_eq(view.fighterA.name, "Mystery", "unknown class still shows the name")
assert_eq(view.fighterA.nameColor, nil, "unknown class has no invented tint")
assert_eq(view.fighterB.name, "Plain", "a class-less fighter still shows")
RAID_CLASS_COLORS = savedColors

view = Hud:Refresh()
assert_eq(view.fighterA.nameColor, nil, "Banana is not a class file")
assert_eq(frame.nameA:GetText(), "Mystery", "name survives a missing class tint")

--------------------------------------------------------------------------------
-- GetView returns a copy. HUD does not write Store or Gora.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
view = Hud:Refresh()
view.fighterA.name = "Mutated"
view.shown = false
if view.favor then view.favor.a = 99 end
local again = Hud:GetView()
assert_eq(again.fighterA.name, "Chuckroast", "mutating GetView does not change the live view")
assert_eq(again.shown, true, "mutating GetView does not hide the HUD")
assert_eq(again.favor, nil, "congregation GetView favor stays a copy (nil here)")
assert_eq(Store:GetCharacter(a.id).name, "Chuckroast", "HUD does not write the character")
assert_eq(Gora:GetSanctioned().fighterA, a.id, "HUD does not clear the live pair")

--------------------------------------------------------------------------------
-- Mute defense integer: stub or real CountDefenses. Zero / missing hides.
-- Favor STATE-off (no congregation broadcast) still omits the split paint.
--------------------------------------------------------------------------------
local savedCountDefenses = Store.CountDefenses
local aDef, bDef = sanctionPair()
Store.CountDefenses = nil
view = Hud:Refresh()
assert_eq(view.fighterA.defenses, nil, "missing CountDefenses hides fighter A")
assert_eq(view.fighterB.defenses, nil, "missing CountDefenses hides fighter B")
assert_eq(frame.defenseA:IsShown(), false, "missing method hides defense A widget")
assert_eq(frame.defenseB:IsShown(), false, "missing method hides defense B widget")
assert_eq(view.defenses, nil, "missing method does not invent a pair defenses table")
assert_eq(view.health, nil, "missing CountDefenses still has no health")
assert_eq(view.favor, nil, "missing CountDefenses does not invent congregation favor")
assert_eq(frame.favorLabel:IsShown(), false, "STATE-off still omits FAVOR")
assert_eq(frame.barA:IsShown(), false, "STATE-off still omits bar A")
assert_eq(frame.barB:IsShown(), false, "STATE-off still omits bar B")

Store.CountDefenses = function(_, id)
  if id == aDef.id then return 3 end
  if id == bDef.id then return 0 end
  return 0
end
view = Hud:Refresh()
assert_eq(view.fighterA.defenses, 3, "CountDefenses 3 is the mute integer")
assert_eq(view.fighterB.defenses, nil, "CountDefenses 0 hides fighter B")
assert_eq(frame.defenseA:IsShown(), true, "nonzero defense A is visible")
assert_eq(frame.defenseA:GetText(), "III", "defense A paints roman III")
assert_eq(frame.defenseB:IsShown(), false, "zero defense B hides")
assert_eq(frame.defenseB:GetText(), "", "hidden defense B has no zero glyph")
assert_eq(string.find(frame.defenseA:GetText() or "", "odds", 1, true), nil,
  "defense integer has no odds copy")
assert_eq(string.find(frame.defenseA:GetText() or "", "realm", 1, true), nil,
  "defense integer has no realm copy")
assert_eq(view.health, nil, "stub CountDefenses still has no health")
assert_eq(view.favor, nil, "stub CountDefenses does not paint STATE-off favor")
assert_eq(frame.favorLabel:IsShown(), false, "stub CountDefenses keeps FAVOR hidden")
assert_eq(sameRgb(frame.defenseA._cobColor, warrior), false, "defense A is not class-colored")
assert_eq(healthReads, 0, "CountDefenses paint does not read health")

Store.CountDefenses = function()
  return 0
end
view = Hud:Refresh()
assert_eq(view.fighterA.defenses, nil, "zero CountDefenses hides A")
assert_eq(view.fighterB.defenses, nil, "zero CountDefenses hides B")
assert_eq(frame.defenseA:IsShown(), false, "zero hides defense A widget")
assert_eq(frame.defenseB:IsShown(), false, "zero hides defense B widget")

Store.CountDefenses = function(_, id)
  if id == aDef.id then return 2 end
  return 0
end
view = Hud:Refresh()
view.fighterA.defenses = 99
assert_eq(Hud:GetView().fighterA.defenses, 2, "mutating GetView defenses does not change live view")
Store.CountDefenses = savedCountDefenses

--------------------------------------------------------------------------------
-- Drag persists when ChurchOfBeefDB.ui exists. Invalid saved point falls back.
--------------------------------------------------------------------------------
ChurchOfBeefDB = { ui = {} }
reset()
frame = Hud:Init()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
Hud:Refresh()
stub.fire(frame, "OnDragStart")
assert_eq(frame._moving, true, "drag starts a move")
frame:ClearAllPoints()
frame:SetPoint("TOP", UIParent, "TOP", 40, -80)
stub.fire(frame, "OnDragStop")
assert_eq(frame._moving, false, "drop stops the move")
assert_eq(frame:GetScript("OnUpdate"), nil, "drop leaves no animator")
local saved = ChurchOfBeefDB.ui.hud
assert_true(type(saved) == "table", "moved position is saved")
assert_eq(saved.point, "TOP", "saved anchor point")
assert_eq(saved.relativePoint, "TOP", "saved relative point")
assert_eq(saved.x, 40, "saved x")
assert_eq(saved.y, -80, "saved y")
assert_eq(saved.relativeTo, nil, "no frame reference lands in SavedVariables")

dofile("addon/ChurchOfBeef/UI/Hud.lua")
Hud = COB.Hud
local reloaded = Hud:Init()
local rp, rto, rrp, rx, ry = reloaded:GetPoint(1)
assert_eq(rp, "TOP", "saved top anchor restores")
assert_eq(rto, UIParent, "restore still parents to UIParent")
assert_eq(rrp, "TOP", "saved relative top restores")
assert_eq(rx, 40, "saved x restores")
assert_eq(ry, -80, "saved y restores")
frame = reloaded

ChurchOfBeefDB.ui.hud = { point = "MIDDLE-OF-NOWHERE", relativePoint = "CENTER", x = 1, y = 2 }
dofile("addon/ChurchOfBeef/UI/Hud.lua")
Hud = COB.Hud
local safe = Hud:Init()
assert_eq(select(1, safe:GetPoint(1)), "TOP", "invalid saved anchor falls back to top")
assert_eq(select(4, safe:GetPoint(1)), 0, "invalid saved x falls back to center")
frame = safe
ChurchOfBeefDB = nil

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
Hud:Refresh()
assert_eq(Hud:IsShown(), true, "HUD is showing before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(Hud:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Hud:IsShown(), true, "out-of-harness reset does not hide the HUD")
ChurchOfBeef._IN_TEST = true

--------------------------------------------------------------------------------
-- Pope stub: live split from Gora, including zeros. Bar shown. No Pope name.
--------------------------------------------------------------------------------
local function stubLocalPope(isPope)
  COB.Sender = {
    IsRegisteredPope = function()
      return isPope == true
    end,
  }
end

reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
stubLocalPope(true)
view = Hud:Refresh()
assert_true(view.favor ~= nil, "Pope sees a live split even at zero")
assert_eq(view.favor.a, 0, "Pope zero split a")
assert_eq(view.favor.b, 0, "Pope zero split b")
assert_eq(view.favor.pctA, 0, "zero total is 0 percent A")
assert_eq(view.favor.pctB, 0, "zero total is 0 percent B")
assert_eq(view.health, nil, "Pope view still has no health")
assert_eq(frame.favorLabel:IsShown(), true, "Pope FAVOR label shows on a live pair")
assert_eq(frame.favorSigil:IsShown(), true, "Pope FAVOR sigil shows with the label")
assert_eq(frame.favorLabel:GetText(), "FAVOR", "favor label is FAVOR")
assert_eq(frame.barA:IsShown(), true, "Pope bar A shows")
assert_eq(frame.barB:IsShown(), true, "Pope bar B shows")
assert_eq(frame.pctA:GetText(), "0%", "Pope zero paints 0% A")
assert_eq(frame.pctB:GetText(), "0%", "Pope zero paints 0% B")

local fan1 = Store:CreateCharacter({ name = "FanOne", class = "Priest", level = 70 })
local fan2 = Store:CreateCharacter({ name = "FanTwo", class = "Priest", level = 70 })
local fan3 = Store:CreateCharacter({ name = "FanThree", class = "Priest", level = 70 })
assert_true(Gora:RecordFavor(fan1.id, a.id) ~= nil, "first pick lands")
assert_true(Gora:RecordFavor(fan2.id, a.id) ~= nil, "second pick lands")
assert_true(Gora:RecordFavor(fan3.id, b.id) ~= nil, "third pick lands")
local split = Gora:GetFavorSplit()
assert_eq(split.a, 2, "Gora split a is 2")
assert_eq(split.b, 1, "Gora split b is 1")
view = Hud:Refresh()
assert_eq(view.favor.a, 2, "Pope view a matches Gora")
assert_eq(view.favor.b, 1, "Pope view b matches Gora")
assert_eq(view.favor.pctA, 66, "floor(100*2/3) is 66")
assert_eq(view.favor.pctB, 34, "remainder percent is 34")
assert_eq(frame.pctA:GetText(), "66%", "bar paints 66%")
assert_eq(frame.pctB:GetText(), "34%", "bar paints 34%")
assert_eq(sameRgb(frame.barA._cobColor, warrior), true, "bar A is fighter-tinted")
assert_eq(sameRgb(frame.barB._cobColor, mage), true, "bar B is fighter-tinted")
view.favor.a = 99
assert_eq(Hud:GetView().favor.a, 2, "mutating GetView favor does not change live favor")
assert_eq(Gora:GetFavorSplit().a, 2, "mutating GetView favor does not change Gora")

--------------------------------------------------------------------------------
-- Congregation: broadcast only. Gora picks do not fill. 2/1 → 66/34.
--------------------------------------------------------------------------------
COB.Sender = nil
Hud:SetBroadcastFavor(nil)
view = Hud:Refresh()
assert_eq(view.favor, nil, "congregation with nil broadcast hides favor")
assert_eq(Gora:GetFavorSplit().a, 2, "Gora still has picks")
assert_eq(frame.favorLabel:IsShown(), false, "toggle-off hides the FAVOR label")
assert_eq(frame.barA:IsShown(), false, "toggle-off hides bar A")
assert_eq(frame.barB:IsShown(), false, "toggle-off hides bar B")

Hud:SetBroadcastFavor({ a = 2, b = 1 })
view = Hud:Refresh()
assert_true(view.favor ~= nil, "broadcast table shows congregation favor")
assert_eq(view.favor.a, 2, "broadcast a")
assert_eq(view.favor.b, 1, "broadcast b")
assert_eq(view.favor.pctA, 66, "broadcast 2/1 is 66%")
assert_eq(view.favor.pctB, 34, "broadcast remainder is 34%")
assert_eq(frame.favorLabel:IsShown(), true, "broadcast shows FAVOR")
assert_eq(frame.pctA:GetText(), "66%", "broadcast paints 66%")
assert_eq(frame.pctB:GetText(), "34%", "broadcast paints 34%")

Hud:SetBroadcastFavor({ a = 0, b = 0 })
view = Hud:Refresh()
assert_eq(view.favor.a, 0, "broadcast zeros are a real split")
assert_eq(view.favor.pctA, 0, "broadcast zeros are 0%")
assert_eq(view.favor.pctB, 0, "broadcast zeros are 0% B")
assert_eq(frame.favorLabel:IsShown(), true, "broadcast zeros still show the bar")

--------------------------------------------------------------------------------
-- PickFavor stubs Net. Missing target / character. Plate click is gated.
--------------------------------------------------------------------------------
local sent = {}
COB.Net = {
  SendFavor = function(_, fields, target)
    sent[#sent + 1] = { fields = fields, target = target }
    return true
  end,
}

local picker = Store:CreateCharacter({ name = "Picker", class = "Priest", level = 70 })
local ok, err = Hud:PickFavor(a.id, "Host", picker.id)
assert_eq(ok, true, "PickFavor sends when target and character are present")
assert_eq(err, nil, "successful PickFavor has no error")
assert_eq(#sent, 1, "SendFavor is called once")
assert_eq(sent[1].target, "Host", "SendFavor uses the given target")
assert_eq(sent[1].fields.characterId, picker.id, "SendFavor carries characterId")
assert_eq(sent[1].fields.pick, a.id, "SendFavor carries pick")
assert_eq(sent[1].fields.pickId, nil, "fields use pick, not pickId")

ok, err = Hud:PickFavor(a.id, nil, picker.id)
assert_eq(ok, nil, "missing target is refused")
assert_eq(err, "no target", "missing target names the error")
ok, err = Hud:PickFavor(a.id, "", picker.id)
assert_eq(ok, nil, "empty target is refused")
assert_eq(err, "no target", "empty target is no target")
assert_eq(#sent, 1, "refused PickFavor does not send")

ok, err = Hud:PickFavor(a.id, "Host", nil)
assert_eq(ok, nil, "missing character is refused")
assert_eq(err, "no character", "missing character names the error")
assert_eq(#sent, 1, "missing character does not send")

sent = {}
Hud:SetFavorTarget(nil)
Hud:SetLocalCharacterId(nil)
assert_eq(stub.fire(frame.pickA, "OnClick"), true, "plate A has an OnClick")
assert_eq(#sent, 0, "plate click without target and id is a no-op")
assert_eq(#stub.chat, 0, "no-op click does not chat")

Hud:SetFavorTarget("Host")
assert_eq(stub.fire(frame.pickB, "OnClick"), true, "plate B click with only target")
assert_eq(#sent, 0, "plate click without local id is a no-op")

Hud:SetLocalCharacterId(picker.id)
assert_eq(stub.fire(frame.pickA, "OnClick"), true, "plate A click with both set")
assert_eq(#sent, 1, "plate click sends favor")
assert_eq(sent[1].target, "Host", "plate click uses SetFavorTarget")
assert_eq(sent[1].fields.characterId, picker.id, "plate click uses SetLocalCharacterId")
assert_eq(sent[1].fields.pick, a.id, "plate A picks fighter A")

sent = {}
assert_eq(stub.fire(frame.pickB, "OnClick"), true, "plate B click with both set")
assert_eq(#sent, 1, "plate B sends favor")
assert_eq(sent[1].fields.pick, b.id, "plate B picks fighter B")

assert_eq(Hud:ResetForTests(), true, "ResetForTests clears favor glue")
sent = {}
assert_eq(stub.fire(frame.pickA, "OnClick"), true, "plate still has OnClick after reset")
assert_eq(#sent, 0, "ResetForTests clears target so click is a no-op")
view = Hud:Refresh()
assert_eq(view.favor, nil, "ResetForTests clears broadcast favor")

COB.Net = nil
COB.Sender = nil

--------------------------------------------------------------------------------
-- Toast trap: Refresh must not call a toast engine if one is present
--------------------------------------------------------------------------------
local toastCalls = 0
local savedToasts = COB.Toasts
COB.Toasts = {
  Show = function() toastCalls = toastCalls + 1 end,
  Push = function() toastCalls = toastCalls + 1 end,
  Celebrate = function() toastCalls = toastCalls + 1 end,
}
Hud:Refresh()
assert_eq(toastCalls, 0, "HUD does not toast")
COB.Toasts = savedToasts

--------------------------------------------------------------------------------
-- Persist: last pair while not QUIET. Pope favor frozen. QUIET hides.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
stubLocalPope(true)
local persistFan1 = Store:CreateCharacter({ name = "PersistFanOne", class = "Priest", level = 70 })
local persistFan2 = Store:CreateCharacter({ name = "PersistFanTwo", class = "Priest", level = 70 })
local persistFan3 = Store:CreateCharacter({ name = "PersistFanThree", class = "Priest", level = 70 })
assert_true(Gora:RecordFavor(persistFan1.id, a.id) ~= nil, "persist first pick lands")
assert_true(Gora:RecordFavor(persistFan2.id, a.id) ~= nil, "persist second pick lands")
assert_true(Gora:RecordFavor(persistFan3.id, b.id) ~= nil, "persist third pick lands")
view = Hud:Refresh()
assert_eq(view.favor.a, 2, "Pope live split a before the ruling")
assert_eq(view.favor.b, 1, "Pope live split b before the ruling")
assert_eq(view.favor.pctA, 66, "Pope live 66 before the ruling")
assert_eq(view.favor.pctB, 34, "Pope live 34 before the ruling")
Gora:DeclareVictor(a.id)
assert_eq(Gora:GetSanctioned(), nil, "ruling cleared the live pair")
assert_eq(Gora:GetFavorSplit().a, 0, "Gora split is empty after the pair clears")
assert_eq(Gora:GetFavorSplit().b, 0, "Gora split b is empty after the pair clears")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "Pope HUD persists through the verdict")
assert_eq(view.shown, true, "Pope shown stays true after the ruling")
assert_eq(view.fighterA.name, "Chuckroast", "Pope persist still paints fighter A")
assert_eq(view.favor.a, 2, "Pope favor frozen on last split a")
assert_eq(view.favor.b, 1, "Pope favor frozen on last split b")
assert_eq(view.favor.pctA, 66, "Pope favor frozen at 66")
assert_eq(view.favor.pctB, 34, "Pope favor frozen at 34")
assert_eq(frame.pctA:GetText(), "66%", "frozen bar still paints 66%")
assert_eq(view.health, nil, "frozen persist has no health")
assert_eq(view.verdict, nil, "Pope persist does not invent a verdict qualifier")
assert_eq(sameRgb(frame.barA._cobColor, warrior), true, "frozen bar A stays fighter-tinted")

COB.Sender = nil
Hud:SetBroadcastFavor({ a = 2, b = 1 })
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "congregation HUD still persists after the ruling")
assert_eq(view.favor.a, 2, "congregation persist still follows W-F broadcast a")
assert_eq(view.favor.b, 1, "congregation persist still follows W-F broadcast b")
assert_eq(view.favor.pctA, 66, "congregation persist 66")
Hud:SetBroadcastFavor(nil)
view = Hud:Refresh()
assert_eq(view.favor, nil, "congregation persist hides favor without broadcast")
assert_eq(Hud:IsShown(), true, "clearing broadcast does not hide the persisted HUD")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent after persist")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET after persist")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "QUIET hides the persisted HUD")
assert_eq(view.shown, false, "Quiet view after persist is hidden")
assert_eq(view.favor, nil, "Quiet after persist has no favor")
assert_eq(view.fighterA, nil, "Quiet after persist has no fighter A")

Runtime:StartEvent()
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "ASSEMBLY after QUIET does not revive the last pair")
assert_eq(Gora:GetSanctioned(), nil, "no new Sanction yet")
COB.Sender = nil

assert_eq(sounds, 0, "the suite played no sound")
assert_eq(healthReads, 0, "the suite never scraped health")

--------------------------------------------------------------------------------
-- B10-B: congregation pair from Runtime subjects.fighters. No Gora sanction.
-- OpenRite names two ids → HUD shown. One id does not invent a pair.
-- Persist lastPair when both sources empty and the event is still live.
-- QUIET hides. Favor W-F intact. Existing DeclareVictor persist pins stay.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local congA, congB = twoChars()
assert_eq(Gora:GetSanctioned(), nil, "congregation never Sanctioned")
assert_true(Runtime:OpenRite("Gora", { fighters = { congA.id, congB.id } }) ~= nil,
  "OpenRite names the star pair")
assert_eq(Gora:GetSanctioned(), nil, "OpenRite is not a Sanction")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "Runtime fighters show the HUD with no Gora pair")
assert_eq(view.shown, true, "congregation subjects view is shown")
assert_eq(view.fighterA.id, congA.id, "fighter A id is the Runtime subject")
assert_eq(view.fighterB.id, congB.id, "fighter B id is the Runtime subject")
assert_eq(view.fighterA.name, "Chuckroast", "congregation fighter A name comes from Store")
assert_eq(view.fighterB.name, "Tendermage", "congregation fighter B name comes from Store")
assert_eq(view.health, nil, "congregation subjects view has no health")
assert_eq(view.favor, nil, "congregation without broadcast hides favor")
assert_eq(view.verdict, nil, "subjects paint does not invent a verdict")
assert_eq(Gora:GetSanctioned(), nil, "painting subjects does not invent a Gora pair")
assert_eq(healthReads, 0, "subjects paint does not read health")

Hud:SetBroadcastFavor({ a = 2, b = 1 })
view = Hud:Refresh()
assert_eq(view.favor.a, 2, "congregation subjects still follow W-F broadcast a")
assert_eq(view.favor.b, 1, "congregation subjects still follow W-F broadcast b")
assert_eq(view.favor.pctA, 66, "congregation subjects 2/1 is 66%")
assert_eq(frame.favorLabel:IsShown(), true, "broadcast still shows FAVOR on subjects")
Hud:SetBroadcastFavor(nil)
view = Hud:Refresh()
assert_eq(view.favor, nil, "clearing broadcast hides favor on the subjects pair")
assert_eq(Hud:IsShown(), true, "clearing broadcast does not hide the subjects HUD")

assert_true(Runtime:CloseRite() ~= nil, "CloseRite keeps the event live")
assert_true(Runtime:Continue() ~= nil, "Continue clears Runtime fighters")
assert_eq(Runtime:Snapshot().subjects.fighters, nil, "Runtime fighters are empty")
assert_eq(Gora:GetSanctioned(), nil, "Gora still has no pair after Continue")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "lastPair persists when both sources are empty")
assert_eq(view.fighterA.id, congA.id, "persisted congregation pair still paints A")
assert_eq(view.fighterB.id, congB.id, "persisted congregation pair still paints B")
assert_eq(view.health, nil, "persisted congregation view has no health")
assert_eq(view.favor, nil, "persisted congregation favor still follows W-F")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent after subjects persist")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET after subjects")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "QUIET hides the congregation HUD")
assert_eq(view.shown, false, "Quiet view after subjects persist is hidden")
assert_eq(view.fighterA, nil, "Quiet after subjects has no fighter A")
assert_eq(view.health, nil, "Quiet after subjects has no health")

reset()
Runtime:StartEvent()
local one, _ = twoChars()
assert_true(Runtime:OpenRite("Gora", { fighters = { one.id } }) ~= nil,
  "one fighter is valid Runtime")
assert_eq(Gora:GetSanctioned(), nil, "one fighter is not a Sanction")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "one fighter does not invent a pair")
assert_eq(view.shown, false, "one-fighter view stays hidden")
assert_eq(view.fighterA, nil, "one fighter does not mint fighter A")

reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
assert_true(Runtime:OpenRite("Gora", { fighters = { a.id, b.id } }) ~= nil,
  "Pope OpenRite names the same pair")
stubLocalPope(true)
local freezeFan1 = Store:CreateCharacter({ name = "FreezeFanOne", class = "Priest", level = 70 })
local freezeFan2 = Store:CreateCharacter({ name = "FreezeFanTwo", class = "Priest", level = 70 })
local freezeFan3 = Store:CreateCharacter({ name = "FreezeFanThree", class = "Priest", level = 70 })
assert_true(Gora:RecordFavor(freezeFan1.id, a.id) ~= nil, "freeze first pick lands")
assert_true(Gora:RecordFavor(freezeFan2.id, a.id) ~= nil, "freeze second pick lands")
assert_true(Gora:RecordFavor(freezeFan3.id, b.id) ~= nil, "freeze third pick lands")
view = Hud:Refresh()
assert_eq(view.favor.a, 2, "Pope live split a before ruling with subjects")
assert_eq(view.favor.b, 1, "Pope live split b before ruling with subjects")
Gora:DeclareVictor(a.id)
assert_eq(Gora:GetSanctioned(), nil, "ruling cleared the live Gora pair")
assert_true(type(Runtime:Snapshot().subjects.fighters) == "table",
  "Runtime still names fighters after the ruling")
assert_eq(Runtime:Snapshot().subjects.fighters[1], a.id, "Runtime fighter A remains")
assert_eq(Gora:GetFavorSplit().a, 0, "Gora split is empty after the pair clears")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "HUD persists with Runtime subjects after the ruling")
assert_eq(view.favor.a, 2, "Pope freeze survives Runtime subjects after the ruling")
assert_eq(view.favor.b, 1, "Pope freeze b survives Runtime subjects")
assert_eq(view.favor.pctA, 66, "Pope freeze stays 66 with leftover subjects")
assert_eq(view.health, nil, "subjects leftover persist has no health")
assert_eq(view.verdict, nil, "subjects leftover persist has no verdict qualifier")
COB.Sender = nil

assert_eq(sounds, 0, "subjects lane played no sound")
assert_eq(healthReads, 0, "subjects lane never scraped health")

--------------------------------------------------------------------------------
-- B11-B: leftover plate clicks. Display persist (lastPair) stays.
-- Pick never lastPair. Pope / live GetSanctioned only. Congregation
-- Runtime subjects.fighters only while RITE and riteType Gora (B16-C).
-- CONSEQUENCE / Continue persist / QUIET do not SendFavor. PickFavor
-- missing-target pins stay.
--------------------------------------------------------------------------------
local pickSent = {}
COB.Net = {
  SendFavor = function(_, fields, target)
    pickSent[#pickSent + 1] = { fields = fields, target = target }
    return true
  end,
}

reset()
Runtime:StartEvent()
local leftoverA, leftoverB = twoChars()
Gora:Sanction(leftoverA.id, leftoverB.id)
COB.Sender = nil
local pickFrame = Hud:Init()
Hud:SetFavorTarget("Host")
local leftoverPicker = Store:CreateCharacter({ name = "LeftoverFan", class = "Priest", level = 70 })
Hud:SetLocalCharacterId(leftoverPicker.id)
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "Sanctioned HUD is shown before the ruling")
assert_eq(view.health, nil, "pre-ruling leftover view has no health")
pickSent = {}
assert_eq(stub.fire(pickFrame.pickA, "OnClick"), true, "live Sanction plate still clicks")
assert_eq(#pickSent, 1, "live GetSanctioned still sends with Sender nil")
assert_eq(pickSent[1].fields.pick, leftoverA.id, "live plate A picks fighter A")

Gora:DeclareVictor(leftoverA.id)
assert_eq(Gora:GetSanctioned(), nil, "ruling cleared GetSanctioned")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "HUD still shown after DeclareVictor")
assert_eq(view.shown, true, "persist shown after DeclareVictor")
assert_eq(view.fighterA.id, leftoverA.id, "persist still paints fighter A")
assert_eq(view.fighterB.id, leftoverB.id, "persist still paints fighter B")
assert_eq(view.health, nil, "DeclareVictor persist has no health")
assert_eq(view.verdict, nil, "DeclareVictor persist has no verdict qualifier")
pickSent = {}
assert_eq(stub.fire(pickFrame.pickA, "OnClick"), true, "plate still has OnClick after ruling")
assert_eq(#pickSent, 0, "plate does not SendFavor after DeclareVictor")
assert_eq(stub.fire(pickFrame.pickB, "OnClick"), true, "plate B still has OnClick after ruling")
assert_eq(#pickSent, 0, "plate B does not SendFavor after DeclareVictor")

reset()
Runtime:StartEvent()
leftoverA, leftoverB = twoChars()
Gora:Sanction(leftoverA.id, leftoverB.id)
assert_true(Runtime:OpenRite("Gora", { fighters = { leftoverA.id, leftoverB.id } }) ~= nil,
  "OpenRite leftover subjects after a live pair")
stubLocalPope(true)
pickFrame = Hud:Init()
Hud:SetFavorTarget("Host")
leftoverPicker = Store:CreateCharacter({ name = "PopeLeftoverFan", class = "Priest", level = 70 })
Hud:SetLocalCharacterId(leftoverPicker.id)
Gora:DeclareVictor(leftoverA.id)
assert_eq(Gora:GetSanctioned(), nil, "Pope ruling cleared GetSanctioned")
assert_true(type(Runtime:Snapshot().subjects.fighters) == "table",
  "Runtime leftover subjects remain after the ruling")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "Pope HUD persists with leftover subjects")
assert_eq(view.health, nil, "Pope leftover persist has no health")
pickSent = {}
assert_eq(stub.fire(pickFrame.pickA, "OnClick"), true, "Pope leftover plate clicks")
assert_eq(#pickSent, 0, "Pope leftover Runtime subjects do not SendFavor")
assert_eq(stub.fire(pickFrame.pickB, "OnClick"), true, "Pope leftover plate B clicks")
assert_eq(#pickSent, 0, "Pope leftover plate B does not SendFavor")
COB.Sender = nil

reset()
Runtime:StartEvent()
local riteA, riteB = twoChars()
assert_eq(Gora:GetSanctioned(), nil, "congregation OpenRite has no Sanction")
assert_true(Runtime:OpenRite("Gora", { fighters = { riteA.id, riteB.id } }) ~= nil,
  "OpenRite names congregation fighters")
assert_eq(Gora:GetSanctioned(), nil, "OpenRite is still not a Sanction")
COB.Sender = nil
pickFrame = Hud:Init()
Hud:SetFavorTarget("Host")
local ritePicker = Store:CreateCharacter({ name = "RiteFan", class = "Priest", level = 70 })
Hud:SetLocalCharacterId(ritePicker.id)
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "RITE subjects show the HUD")
assert_eq(Runtime:Snapshot().state, "RITE", "runtime is RITE for congregation pick")
assert_eq(Runtime:Snapshot().riteType, "Gora", "congregation pick RITE is Gora")
assert_eq(view.fighterA.id, riteA.id, "RITE fighter A is the Runtime subject")
assert_eq(view.health, nil, "RITE subjects pick view has no health")
pickSent = {}
assert_eq(stub.fire(pickFrame.pickA, "OnClick"), true, "RITE plate A clicks")
assert_eq(#pickSent, 1, "congregation RITE plate sends")
assert_eq(pickSent[1].fields.pick, riteA.id, "RITE plate A picks Runtime fighter A")
assert_eq(pickSent[1].target, "Host", "RITE plate uses SetFavorTarget")
assert_eq(pickSent[1].fields.characterId, ritePicker.id, "RITE plate uses local character")
pickSent = {}
assert_eq(stub.fire(pickFrame.pickB, "OnClick"), true, "RITE plate B clicks")
assert_eq(#pickSent, 1, "congregation RITE plate B sends")
assert_eq(pickSent[1].fields.pick, riteB.id, "RITE plate B picks Runtime fighter B")

assert_true(Runtime:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "runtime is CONSEQUENCE")
assert_true(type(Runtime:Snapshot().subjects.fighters) == "table",
  "subjects may still be present after CloseRite")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "HUD may still show in CONSEQUENCE")
assert_eq(view.health, nil, "CONSEQUENCE leftover has no health")
pickSent = {}
assert_eq(stub.fire(pickFrame.pickA, "OnClick"), true, "CONSEQUENCE plate still clicks")
assert_eq(#pickSent, 0, "CONSEQUENCE plate does not SendFavor")
assert_eq(stub.fire(pickFrame.pickB, "OnClick"), true, "CONSEQUENCE plate B still clicks")
assert_eq(#pickSent, 0, "CONSEQUENCE plate B does not SendFavor")

assert_true(Runtime:Continue() ~= nil, "Continue returns to ASSEMBLY")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY after Continue")
assert_eq(Runtime:Snapshot().subjects.fighters, nil, "Runtime fighters are empty after Continue")
assert_eq(Gora:GetSanctioned(), nil, "Gora still has no pair after Continue")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "lastPair persist still shows after Continue")
assert_eq(view.fighterA.id, riteA.id, "lastPair persist still paints A")
assert_eq(view.fighterB.id, riteB.id, "lastPair persist still paints B")
assert_eq(view.health, nil, "Continue persist has no health")
pickSent = {}
assert_eq(stub.fire(pickFrame.pickA, "OnClick"), true, "persist plate still clicks")
assert_eq(#pickSent, 0, "lastPair persist plate does not SendFavor")
assert_eq(stub.fire(pickFrame.pickB, "OnClick"), true, "persist plate B still clicks")
assert_eq(#pickSent, 0, "lastPair persist plate B does not SendFavor")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent after leftover picks")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "QUIET hides the leftover HUD")
assert_eq(view.health, nil, "QUIET leftover view has no health")
pickSent = {}
assert_eq(stub.fire(pickFrame.pickA, "OnClick"), true, "QUIET plate still clicks")
assert_eq(#pickSent, 0, "QUIET plate does not SendFavor")

local pickOk, pickErr = Hud:PickFavor(riteA.id, nil, ritePicker.id)
assert_eq(pickOk, nil, "PickFavor missing-target pin stays")
assert_eq(pickErr, "no target", "PickFavor still names no target")
pickOk, pickErr = Hud:PickFavor(riteA.id, "Host", nil)
assert_eq(pickOk, nil, "PickFavor missing-character pin stays")
assert_eq(pickErr, "no character", "PickFavor still names no character")
assert_eq(#pickSent, 0, "PickFavor refusals still do not send")

COB.Net = nil
COB.Sender = nil

assert_eq(sounds, 0, "leftover pick lane played no sound")
assert_eq(healthReads, 0, "leftover pick lane never scraped health")

--------------------------------------------------------------------------------
-- B16-C: congregation pickPair requires RITE and riteType Gora.
-- Knighting RITE + two leftover Runtime fighters must not SendFavor.
-- Existing OpenRite("Gora") congregation pins stay. Pope still
-- GetSanctioned only. Isolation wrap stays. health nil.
--------------------------------------------------------------------------------
local knightSent = {}
COB.Net = {
  SendFavor = function(_, fields, target)
    knightSent[#knightSent + 1] = { fields = fields, target = target }
    return true
  end,
}

reset()
Runtime:StartEvent()
local knightA, knightB = twoChars()
assert_eq(Gora:GetSanctioned(), nil, "Knighting leftover has no Sanction")
assert_true(
  Runtime:OpenRite("Knighting", { candidate = knightA.id, fighters = { knightA.id, knightB.id } }) ~= nil,
  "Knighting RITE can carry leftover fighters"
)
assert_eq(Runtime:Snapshot().state, "RITE", "Knighting leftover is RITE")
assert_eq(Runtime:Snapshot().riteType, "Knighting", "rite type is Knighting")
assert_eq(Gora:GetSanctioned(), nil, "OpenRite Knighting is not a Sanction")
assert_true(type(Runtime:Snapshot().subjects.fighters) == "table",
  "Knighting leftover still names two fighters")
assert_eq(Runtime:Snapshot().subjects.fighters[1], knightA.id, "leftover fighter A remains")
assert_eq(Runtime:Snapshot().subjects.fighters[2], knightB.id, "leftover fighter B remains")
COB.Sender = nil
local knightFrame = Hud:Init()
Hud:SetFavorTarget("Host")
local knightPicker = Store:CreateCharacter({ name = "KnightFan", class = "Priest", level = 70 })
Hud:SetLocalCharacterId(knightPicker.id)
view = Hud:Refresh()
assert_eq(view.shown, false, "Knighting leftover pick view does not paint")
assert_eq(view.fighterA, nil, "Knighting leftover pick does not paint fighter A")
assert_eq(view.fighterB, nil, "Knighting leftover pick does not paint fighter B")
assert_eq(view.health, nil, "Knighting leftover pick view has no health")
assert_eq(view.verdict, nil, "Knighting leftover has no verdict qualifier")
knightSent = {}
assert_eq(stub.fire(knightFrame.pickA, "OnClick"), true, "Knighting leftover plate A clicks")
assert_eq(#knightSent, 0, "Knighting leftover plate does not SendFavor")
assert_eq(stub.fire(knightFrame.pickB, "OnClick"), true, "Knighting leftover plate B clicks")
assert_eq(#knightSent, 0, "Knighting leftover plate B does not SendFavor")

COB.Net = nil
COB.Sender = nil

assert_eq(sounds, 0, "Knighting leftover pick played no sound")
assert_eq(healthReads, 0, "Knighting leftover pick never scraped health")

--------------------------------------------------------------------------------
-- B17-D: livePair runtime arm requires RITE and riteType Gora.
-- After reset (lastPair empty), Knighting leftover fighters do not paint.
-- Sanctioned pair still shows during Knighting. lastPair persist after
-- Continue stays. B16-C send-0 stays. health nil.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
assert_eq(Gora:GetSanctioned(), nil, "B17-D leftover has no Sanction")
assert_true(
  Runtime:OpenRite("Knighting", { candidate = a.id, fighters = { a.id, b.id } }) ~= nil,
  "B17-D Knighting RITE can carry leftover fighters"
)
assert_eq(Runtime:Snapshot().state, "RITE", "B17-D leftover is RITE")
assert_eq(Runtime:Snapshot().riteType, "Knighting", "B17-D rite type is Knighting")
assert_eq(Gora:GetSanctioned(), nil, "B17-D OpenRite Knighting is not a Sanction")
assert_true(type(Runtime:Snapshot().subjects.fighters) == "table",
  "B17-D leftover still names two fighters")
assert_eq(Runtime:Snapshot().subjects.fighters[1], a.id, "B17-D leftover fighter A remains")
assert_eq(Runtime:Snapshot().subjects.fighters[2], b.id, "B17-D leftover fighter B remains")
frame = Hud:Init()
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "Knighting leftover fighters do not show the HUD")
assert_eq(view.shown, false, "Knighting leftover view is hidden")
assert_eq(view.fighterA, nil, "do not paint leftover fighter A")
assert_eq(view.fighterB, nil, "do not paint leftover fighter B")
assert_eq(view.health, nil, "Knighting leftover hide has no health")
assert_eq(view.favor, nil, "Knighting leftover hide has no favor")
assert_eq(frame.nameA:GetText(), "", "leftover fighter A name is not painted")
assert_eq(frame.nameB:GetText(), "", "leftover fighter B name is not painted")
assert_eq(sounds, 0, "B17-D hide played no sound")
assert_eq(healthReads, 0, "B17-D hide never scraped health")

--------------------------------------------------------------------------------
-- B19-C: lastPair does not paint through a later non-Gora RITE.
-- OpenRite Gora, Refresh (remember lastPair), CloseRite / Continue,
-- OpenRite Knighting with a candidate (no Sanction) → shown == false.
-- B21-B (nested): CloseRite → CONSEQUENCE / Knighting → shown == false.
-- B32-A (nested): Continue + Refresh → shown == false, names "".
-- B34-A (nested): wrap name SetFontObject wipe, live Gora Refresh
-- restores Warrior / Mage tint after applyNameFont.
-- B35-A (nested): defenseA / defenseB SetWidth(28); Init and
-- nonzero CountDefenses paint GetWidth() == 28.
-- B37-B (nested): SetBroadcastFavor a split, Quiet Refresh,
-- view.favor is nil; a later live pair without a new
-- SetBroadcastFavor still has no leftover favor.
-- Gora CONSEQUENCE and ASSEMBLY Continue persist stay. Existing
-- Sanction-during-Knighting pin stays shown. Isolation wrap stays.
-- health nil.
--------------------------------------------------------------------------------
local function runB19C()
  reset()
  Runtime:StartEvent()
  local goraA, goraB = twoChars()
  assert_eq(Gora:GetSanctioned(), nil, "B19-C Gora OpenRite has no Sanction")
  assert_true(
    Runtime:OpenRite("Gora", { fighters = { goraA.id, goraB.id } }) ~= nil,
    "OpenRite Gora names two fighters"
  )
  local hud = Hud:Init()
  local painted = Hud:Refresh()
  assert_eq(Hud:IsShown(), true, "Gora RITE Refresh remembers lastPair")
  assert_eq(painted.shown, true, "Gora RITE view is shown")
  assert_eq(painted.fighterA.name, "Chuckroast", "Gora RITE paints fighter A")
  assert_eq(painted.fighterB.name, "Tendermage", "Gora RITE paints fighter B")
  assert_eq(painted.health, nil, "Gora RITE remember has no health")
  assert_eq(Gora:GetSanctioned(), nil, "remembering lastPair is not a Sanction")

  assert_true(Runtime:CloseRite() ~= nil, "CloseRite reaches Gora CONSEQUENCE")
  assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "runtime is Gora CONSEQUENCE")
  painted = Hud:Refresh()
  assert_eq(Hud:IsShown(), true, "lastPair still paints during Gora CONSEQUENCE")
  assert_eq(painted.shown, true, "Gora CONSEQUENCE persist is shown")
  assert_eq(painted.fighterA.name, "Chuckroast", "Gora CONSEQUENCE still paints A")
  assert_eq(painted.fighterB.name, "Tendermage", "Gora CONSEQUENCE still paints B")
  assert_eq(painted.health, nil, "Gora CONSEQUENCE persist has no health")

  assert_true(Runtime:Continue() ~= nil, "Continue returns to ASSEMBLY")
  assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY after Gora")
  assert_eq(Runtime:Snapshot().riteType, nil, "Continue clears riteType")
  painted = Hud:Refresh()
  assert_eq(Hud:IsShown(), true, "lastPair still paints on ASSEMBLY after Continue")
  assert_eq(painted.fighterA.name, "Chuckroast", "Continue persist still paints A")
  assert_eq(painted.fighterB.name, "Tendermage", "Continue persist still paints B")
  assert_eq(painted.health, nil, "Continue persist has no health")

  assert_eq(Gora:GetSanctioned(), nil, "Knighting path still has no Sanction")
  assert_true(
    Runtime:OpenRite("Knighting", { candidate = goraA.id }) ~= nil,
    "OpenRite Knighting with a candidate"
  )
  assert_eq(Runtime:Snapshot().state, "RITE", "later rite is RITE")
  assert_eq(Runtime:Snapshot().riteType, "Knighting", "later riteType is Knighting")
  assert_eq(Gora:GetSanctioned(), nil, "OpenRite Knighting is not a Sanction")
  painted = Hud:Refresh()
  assert_eq(painted.shown, false, "lastPair does not paint through Knighting")
  assert_eq(Hud:IsShown(), false, "Knighting after Gora hides leftover lastPair")
  assert_eq(painted.fighterA, nil, "do not paint leftover Gora fighter A")
  assert_eq(painted.fighterB, nil, "do not paint leftover Gora fighter B")
  assert_eq(painted.health, nil, "Knighting leftover lastPair hide has no health")
  assert_eq(painted.favor, nil, "Knighting leftover lastPair hide has no favor")
  assert_eq(hud.nameA:GetText(), "", "leftover Gora name A is not painted")
  assert_eq(hud.nameB:GetText(), "", "leftover Gora name B is not painted")
  assert_eq(sounds, 0, "B19-C hide played no sound")
  assert_eq(healthReads, 0, "B19-C hide never scraped health")

  local function runB21B()
    assert_true(Runtime:CloseRite() ~= nil, "CloseRite reaches Knighting CONSEQUENCE")
    assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "runtime is Knighting CONSEQUENCE")
    assert_eq(Runtime:Snapshot().riteType, "Knighting", "CONSEQUENCE riteType is still Knighting")
    assert_eq(Gora:GetSanctioned(), nil, "Knighting CONSEQUENCE still has no Sanction")
    painted = Hud:Refresh()
    assert_eq(painted.shown, false, "lastPair does not paint through Knighting CONSEQUENCE")
    assert_eq(Hud:IsShown(), false, "Knighting CONSEQUENCE hides leftover lastPair")
    assert_eq(painted.fighterA, nil, "do not paint leftover Gora fighter A after CloseRite")
    assert_eq(painted.fighterB, nil, "do not paint leftover Gora fighter B after CloseRite")
    assert_eq(painted.health, nil, "Knighting CONSEQUENCE leftover hide has no health")
    assert_eq(painted.favor, nil, "Knighting CONSEQUENCE leftover hide has no favor")
    assert_eq(hud.nameA:GetText(), "", "leftover Gora name A stays unpainted")
    assert_eq(hud.nameB:GetText(), "", "leftover Gora name B stays unpainted")
    assert_eq(sounds, 0, "B21-B hide played no sound")
    assert_eq(healthReads, 0, "B21-B hide never scraped health")
  end
  runB21B()

  local function runB32A()
    assert_true(Runtime:Continue() ~= nil, "Continue after Knighting CONSEQUENCE")
    assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY after Knighting Continue")
    assert_eq(Runtime:Snapshot().riteType, nil, "Knighting Continue clears riteType")
    assert_eq(Gora:GetSanctioned(), nil, "Knighting Continue still has no Sanction")
    painted = Hud:Refresh()
    assert_eq(painted.shown, false, "forgotten lastPair does not return after Knighting Continue")
    assert_eq(Hud:IsShown(), false, "Knighting Continue stays hidden")
    assert_eq(painted.fighterA, nil, "do not paint leftover Gora fighter A after Knighting Continue")
    assert_eq(painted.fighterB, nil, "do not paint leftover Gora fighter B after Knighting Continue")
    assert_eq(painted.health, nil, "Knighting Continue leftover hide has no health")
    assert_eq(painted.favor, nil, "Knighting Continue leftover hide has no favor")
    assert_eq(hud.nameA:GetText(), "", "leftover Gora name A stays unpainted after Continue")
    assert_eq(hud.nameB:GetText(), "", "leftover Gora name B stays unpainted after Continue")
    assert_eq(sounds, 0, "B32-A hide played no sound")
    assert_eq(healthReads, 0, "B32-A hide never scraped health")
  end
  runB32A()

  local function runB34A()
    local paintAt = src:find("function paintShown", 1, true)
    assert_true(paintAt ~= nil, "B34-A paintShown exists")
    local paintEnd = src:find("\nlocal function ", paintAt + 1, true)
    if not paintEnd then
      paintEnd = src:find("\nfunction ", paintAt + 1, true)
    end
    assert_true(paintEnd ~= nil, "B34-A paintShown body has a following function")
    local paintBody = src:sub(paintAt, paintEnd - 1)
    local applyA = paintBody:find("applyNameFont(frame.nameA)", 1, true)
    local applyB = paintBody:find("applyNameFont(frame.nameB)", 1, true)
    assert_true(applyA ~= nil, "paintShown still applies name font on nameA")
    assert_true(applyB ~= nil, "paintShown still applies name font on nameB")
    local afterA = paintBody:sub(applyA)
    local afterB = paintBody:sub(applyB)
    assert_true(
      afterA:find("tint(frame.nameA", 1, true) ~= nil
        or afterA:find("nameA:SetTextColor", 1, true) ~= nil,
      "paintShown re-tints nameA after applyNameFont"
    )
    assert_true(
      afterB:find("tint(frame.nameB", 1, true) ~= nil
        or afterB:find("nameB:SetTextColor", 1, true) ~= nil,
      "paintShown re-tints nameB after applyNameFont"
    )

    local function wipeOnFont(fs)
      local priorObject = fs.SetFontObject
      local priorFont = fs.SetFont
      fs.SetFontObject = function(self, font)
        self._cobColor = nil
        if self.SetTextColor then self:SetTextColor(1, 1, 1) end
        if priorObject then return priorObject(self, font) end
      end
      fs.SetFont = function(self, path, size, flags)
        self._cobColor = nil
        if self.SetTextColor then self:SetTextColor(1, 1, 1) end
        if priorFont then return priorFont(self, path, size, flags) end
      end
    end
    wipeOnFont(hud.nameA)
    wipeOnFont(hud.nameB)

    assert_true(
      Runtime:OpenRite("Gora", { fighters = { goraA.id, goraB.id } }) ~= nil,
      "B34-A OpenRite Gora is a live pair"
    )
    painted = Hud:Refresh()
    assert_eq(painted.shown, true, "B34-A live Gora pair is shown")
    assert_eq(sameRgb(painted.fighterA.nameColor, warrior), true,
      "view nameColor A returns to Warrior")
    assert_eq(sameRgb(painted.fighterB.nameColor, mage), true,
      "view nameColor B returns to Mage")
    assert_true(hud.nameA._cobColor ~= nil, "name A tint returns after font apply")
    assert_eq(sameRgb(hud.nameA._cobColor, warrior), true,
      "name A widget returns to Warrior")
    assert_eq(sameRgb(hud.nameB._cobColor, mage), true,
      "name B widget returns to Mage")
    assert_eq(painted.health, nil, "B34-A live pair has no health")
    assert_eq(healthReads, 0, "B34-A never scraped health")
  end
  runB34A()

  local function runB35A()
    assert_true(src:find("defenseA:SetWidth(28)", 1, true) ~= nil,
      "defense A is capped at SetWidth(28)")
    assert_true(src:find("defenseB:SetWidth(28)", 1, true) ~= nil,
      "defense B is capped at SetWidth(28)")
    assert_eq(src:find("nameA:SetWidth", 1, true), nil, "name A is not SetWidth")
    assert_eq(src:find("nameB:SetWidth", 1, true), nil, "name B is not SetWidth")
    assert_eq(src:find("recordA:SetWidth", 1, true), nil, "record A is not SetWidth")
    assert_eq(src:find("recordB:SetWidth", 1, true), nil, "record B is not SetWidth")
    assert_eq(src:find("vs:SetWidth", 1, true), nil, "VS is not SetWidth")
    assert_eq(hud.defenseA:GetWidth(), 28, "Init mints defense A at 28")
    assert_eq(hud.defenseB:GetWidth(), 28, "Init mints defense B at 28")
    assert_eq(hud:GetWidth(), 420, "HUD width stays 420")
    assert_eq(hud.nameA:GetWidth(), nil, "name A width stays untouched")
    assert_eq(hud.recordA:GetWidth(), nil, "record A width stays untouched")
    assert_eq(hud.vs:GetWidth(), nil, "VS width stays untouched")
    local daPoint, daRel, daRelPoint = hud.defenseA:GetPoint(1)
    assert_eq(daPoint, "LEFT", "defense A stays LEFT of record A")
    assert_eq(daRel, hud.recordA, "defense A still anchors to record A")
    assert_eq(daRelPoint, "RIGHT", "defense A still uses record RIGHT")
    local dbPoint, dbRel, dbRelPoint = hud.defenseB:GetPoint(1)
    assert_eq(dbPoint, "RIGHT", "defense B stays RIGHT of record B")
    assert_eq(dbRel, hud.recordB, "defense B still anchors to record B")
    assert_eq(dbRelPoint, "LEFT", "defense B still uses record LEFT")

    local savedCount = Store.CountDefenses
    Store.CountDefenses = function(_, id)
      if id == goraA.id then return 3 end
      if id == goraB.id then return 12 end
      return 0
    end
    painted = Hud:Refresh()
    assert_eq(painted.fighterA.defenses, 3, "CountDefenses 3 is still the mute integer")
    assert_eq(painted.fighterB.defenses, 12, "two-digit CountDefenses stays arabic")
    assert_eq(hud.defenseA:GetText(), "III", "defense A still paints roman III")
    assert_eq(hud.defenseB:GetText(), "XII", "defense B paints roman XII")
    assert_eq(hud.defenseA:GetWidth(), 28, "nonzero paint keeps defense A at 28")
    assert_eq(hud.defenseB:GetWidth(), 28, "two-digit paint keeps defense B at 28")
    assert_eq(hud.defenseA:IsShown(), true, "nonzero defense A stays visible")
    assert_eq(hud.defenseB:IsShown(), true, "nonzero defense B stays visible")
    local silverR = select(1, Theme:Color("silver"))
    assert_eq(hud.defenseA._cobColor.r, silverR, "defense A stays Theme silver")
    assert_eq(hud.defenseB._cobColor.r, silverR, "defense B stays Theme silver")
    assert_eq(hud:GetWidth(), 420, "HUD width stays 420 after defense paint")
    assert_eq(hud.nameA:GetWidth(), nil, "name A width stays untouched after paint")
    assert_eq(hud.recordA:GetWidth(), nil, "record A width stays untouched after paint")
    assert_eq(hud.vs:GetWidth(), nil, "VS width stays untouched after paint")
    assert_eq(painted.health, nil, "B35-A paint has no health")
    assert_eq(healthReads, 0, "B35-A never scraped health")
    Store.CountDefenses = savedCount
  end
  runB35A()

  local function runB37B()
    local forgetAt = src:find("local function forgetPersist", 1, true)
    assert_true(forgetAt ~= nil, "B37-B forgetPersist exists")
    local forgetEnd = src:find("\nlocal function ", forgetAt + 1, true)
    if not forgetEnd then
      forgetEnd = src:find("\nfunction ", forgetAt + 1, true)
    end
    assert_true(forgetEnd ~= nil, "B37-B forgetPersist body has a following function")
    local forgetBody = src:sub(forgetAt, forgetEnd - 1)
    assert_true(forgetBody:find("lastPair = nil", 1, true) ~= nil,
      "forgetPersist still nils lastPair")
    assert_true(forgetBody:find("lastPopeFavor = nil", 1, true) ~= nil,
      "forgetPersist still nils lastPopeFavor")
    assert_true(forgetBody:find("broadcastFavor = nil", 1, true) ~= nil,
      "forgetPersist also nils leftover congregation favor")
    assert_eq(forgetBody:find("favorTarget", 1, true), nil,
      "forgetPersist does not nil dest persist")

    COB.Sender = nil
    Hud:SetFavorTarget("Host")
    Hud:SetBroadcastFavor({ a = 2, b = 1 })
    painted = Hud:Refresh()
    assert_eq(painted.shown, true, "B37-B live Gora pair still shows")
    assert_eq(painted.favor.a, 2, "broadcast split paints congregation favor a")
    assert_eq(painted.favor.b, 1, "broadcast split paints congregation favor b")
    assert_eq(painted.favor.pctA, 66, "broadcast 2/1 is still 66%")
    assert_eq(hud.favorLabel:IsShown(), true, "broadcast still shows FAVOR")

    assert_true(Runtime:CloseRite() ~= nil, "CloseRite reaches Gora CONSEQUENCE")
    assert_true(Runtime:EndEvent() ~= nil, "EndEvent from CONSEQUENCE is Quiet")
    assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET after EndEvent")
    painted = Hud:Refresh()
    assert_eq(painted.shown, false, "Quiet Refresh hides the HUD")
    assert_eq(painted.favor, nil, "Quiet Refresh drops leftover congregation favor")
    assert_eq(painted.fighterA, nil, "Quiet Refresh has no leftover fighter A")
    assert_eq(painted.fighterB, nil, "Quiet Refresh has no leftover fighter B")
    assert_eq(painted.health, nil, "Quiet Refresh has no health")
    assert_eq(hud.nameA:GetText(), "", "hidden paint stays empty on name A")
    assert_eq(hud.nameB:GetText(), "", "hidden paint stays empty on name B")
    assert_eq(hud.favorLabel:IsShown(), false, "hidden paint hides FAVOR")
    assert_eq(hud.barA:IsShown(), false, "hidden paint hides bar A")
    assert_eq(hud.barB:IsShown(), false, "hidden paint hides bar B")

    assert_true(Runtime:StartEvent() ~= nil, "StartEvent after Quiet forget")
    assert_true(
      Runtime:OpenRite("Gora", { fighters = { goraA.id, goraB.id } }) ~= nil,
      "later live pair without a new SetBroadcastFavor"
    )
    painted = Hud:Refresh()
    assert_eq(painted.shown, true, "later live pair is shown")
    assert_eq(painted.favor, nil, "later live pair has no leftover favor")
    assert_eq(hud.favorLabel:IsShown(), false, "STATE-off still omits FAVOR")
    assert_eq(hud.barA:IsShown(), false, "STATE-off still omits bar A")
    assert_eq(hud.barB:IsShown(), false, "STATE-off still omits bar B")
    assert_eq(sameRgb(painted.fighterA.nameColor, warrior), true,
      "later live pair still class-colors A Warrior")
    assert_eq(sameRgb(painted.fighterB.nameColor, mage), true,
      "later live pair still class-colors B Mage")
    assert_eq(painted.health, nil, "later live pair has no health")

    local destSent = {}
    COB.Net = {
      SendFavor = function(_, fields, target)
        destSent[#destSent + 1] = { fields = fields, target = target }
        return true
      end,
    }
    local destPicker = Store:CreateCharacter({ name = "DestFan", class = "Priest", level = 70 })
    Hud:SetLocalCharacterId(destPicker.id)
    assert_eq(stub.fire(hud.pickA, "OnClick"), true, "later live plate still clicks")
    assert_eq(#destSent, 1, "dest persist still sends after Quiet forget")
    assert_eq(destSent[1].target, "Host", "favorTarget survives forgetPersist")
    assert_eq(destSent[1].fields.pick, goraA.id, "later live plate still picks A")
    COB.Net = nil

    assert_eq(sounds, 0, "B37-B hide played no sound")
    assert_eq(healthReads, 0, "B37-B never scraped health")
  end
  runB37B()
end
runB19C()

--------------------------------------------------------------------------------
-- U-E HUD-B dress: Theme-sourced bar / crest / name font; roman record
-- XVIII–VI for a known Store record; favor percents stay Arabic (52%).
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local recA, recB = twoChars()
for _ = 1, 18 do
  Store:RecordGoraResult(recA.id, { ruling = "victor", opponentId = recB.id, won = true })
  Store:RecordGoraResult(recB.id, { ruling = "victor", opponentId = recA.id, won = false })
end
for _ = 1, 6 do
  Store:RecordGoraResult(recB.id, { ruling = "victor", opponentId = recA.id, won = true })
  Store:RecordGoraResult(recA.id, { ruling = "victor", opponentId = recB.id, won = false })
end
assert_true(Gora:Sanction(recA.id, recB.id) ~= nil, "known-record pair is sanctioned")
view = Hud:Refresh()
assert_eq(view.fighterA.wins, 18, "view wins stay an integer")
assert_eq(view.fighterA.losses, 6, "view losses stay an integer")
assert_eq(frame.recordA:GetText(), "XVIII" .. EN_DASH .. "VI",
  "known record paints XVIII–VI")
assert_eq(frame.recordA:GetText(), COB.Common.RomanPair(18, 6),
  "painted record matches Common.RomanPair")
assert_eq(frame.railA._cobTexture, Theme:Texture("bar_stainedglass_fill"),
  "shown rail still uses Theme stainedglass")
assert_eq(frame.seal._cobTexture, Theme:Texture("sigil_gora"),
  "shown crest still uses Theme sigil_gora")
assert_eq(frame.nameA._cobFont, Theme:FontPath("display"),
  "shown name still uses Theme display")

Hud:SetBroadcastFavor({ a = 13, b = 12 })
view = Hud:Refresh()
assert_eq(view.favor.pctA, 52, "13/25 is 52 percent")
assert_eq(view.favor.pctB, 48, "remainder is 48 percent")
assert_eq(frame.pctA:GetText(), "52%", "favor percent stays arabic 52%")
assert_eq(frame.pctB:GetText(), "48%", "favor remainder stays arabic")
assert_eq(string.find(frame.pctA:GetText() or "", "LII", 1, true), nil,
  "favor does not paint roman")
Hud:SetBroadcastFavor(nil)

--------------------------------------------------------------------------------
-- V-D height budget: ≤ 12% of UIParent when the parent height is known.
-- Unknown parent stays the compact card (pinned at Init). Do not grow into a toast.
--------------------------------------------------------------------------------
UIParent:SetHeight(768)
dofile("addon/ChurchOfBeef/UI/Hud.lua")
Hud = COB.Hud
reset()
local budgeted = Hud:Init()
local budget = math.floor(768 * 0.12 + 0.5)
assert_eq(budgeted:GetHeight(), budget, "known UIParent height caps the HUD at 12%")
assert_true(budgeted:GetHeight() <= budget, "height is ≤ 12% of UIParent")
assert_true(budgeted:GetHeight() <= 100, "the 12% cap does not grow the card into a toast")
assert_eq(budgeted:GetWidth(), 420, "rebuilt HUD keeps the compact width")
assert_true(budgeted.parchment ~= nil, "rebuilt HUD still has parchment")
assert_true(budgeted.nameFieldA ~= nil, "rebuilt HUD still has name field A")
assert_true(budgeted.nameFieldB ~= nil, "rebuilt HUD still has name field B")
assert_true(budgeted.defenseA ~= nil, "rebuilt HUD still has defense A")
assert_true(budgeted.defenseB ~= nil, "rebuilt HUD still has defense B")
assert_eq(budgeted.defenseA:IsShown(), false, "Quiet rebuild hides defense A")
assert_eq(budgeted.defenseB:IsShown(), false, "Quiet rebuild hides defense B")
assert_eq(countStatusBars(budgeted), 2, "rebuilt HUD still has only favor StatusBars")
assert_eq(Hud:IsShown(), false, "rebuild in Quiet still hides the HUD")
local copy = Hud:GetView()
copy.shown = true
copy.health = { a = 1 }
assert_eq(Hud:GetView().shown, false, "GetView is still a copy after a rebuild")
assert_eq(Hud:GetView().health, nil, "rebuilt view still has no health")

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
