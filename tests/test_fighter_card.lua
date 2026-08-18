-- Mute fighter cards (Bible §10.6 + §10.7 persist through the verdict).
-- Isolated: wow_ui_stub + Common + Ranks + Store + Runtime + Gora +
-- FighterCard. Event Mode only. No live health, no sound, no generated
-- flavor. Standalone wrap. No TOC / bootstrap / run.lua.
-- B28-D Init remount of a missing OnHide lives in runB28D()
-- (Lua 5.1 200-local nest). B29-C Show / Refresh remount lives
-- in runB29C() nested after runB28D(). B30-B Hide remount lives
-- in runB30B() nested after runB29C(). B37-C Hide remounts
-- rememberSpecial lives in runB37C() nested after runB30B().
-- B39-B Show / Refresh remounts rememberSpecial lives in
-- runB39B() nested after runB37C().
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
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/UI/FighterCard.lua")

local EN_DASH = "\226\128\147"
local ROMAN_FRESH = "N" .. EN_DASH .. "N"
local ROMAN_WIN = "I" .. EN_DASH .. "N"
local ROMAN_LOSS = "N" .. EN_DASH .. "I"

local COB = ChurchOfBeef
local FighterCard = COB.FighterCard
local Gora = COB.Gora
local Store = COB.Store
local Runtime = COB.Runtime
local Ranks = COB.Ranks

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
  assert_eq(FighterCard:ResetForTests(), true, "FighterCard ResetForTests runs under _IN_TEST")
  sounds = 0
  healthReads = 0
end

local function twoChars(fieldsA, fieldsB)
  local a = Store:CreateCharacter(fieldsA or { name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter(fieldsB or { name = "Tendermage", class = "Mage", level = 68 })
  return a, b
end

local function rankBoth(charA, charB, rankA, rankB)
  local humanA = Store:CreateHuman({ name = "Chuck" })
  local humanB = Store:CreateHuman({ name = "Tender" })
  Store:LinkCharacter(charA.id, humanA.id)
  Store:LinkCharacter(charB.id, humanB.id)
  Store:SetRank(humanA.id, rankA or 3)
  Store:SetRank(humanB.id, rankB or 1)
  return humanA, humanB
end

local function sanctionPair(stipulation)
  reset()
  Runtime:StartEvent()
  local a, b = twoChars()
  rankBoth(a, b, 3, 1)
  local pair = Gora:Sanction(a.id, b.id, stipulation)
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

local function countType(widget, frameType)
  local n = 0
  if widget._type == frameType then n = n + 1 end
  for i = 1, #(widget._children or {}) do
    n = n + countType(widget._children[i], frameType)
  end
  return n
end

local function sameRgb(color, sample)
  return color and sample
    and color.r == sample.r and color.g == sample.g and color.b == sample.b
end

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(FighterCard ~= nil, "FighterCard is loaded")
assert_true(Store ~= nil, "Store is loaded")
assert_true(Runtime ~= nil, "Runtime is loaded")
assert_true(Gora ~= nil, "Gora is loaded")
assert_true(Ranks ~= nil, "Ranks is loaded for Church titles")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_true(COB.Theme ~= nil, "Theme is loaded for dress")
assert_true(COB.Common ~= nil, "Common is loaded for roman numerals")
assert_true(type(COB.Common.RomanPair) == "function", "RomanPair is available")
assert_true(type(COB.Common.RomanNumeral) == "function", "RomanNumeral is available")

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
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
  assert_eq(COB.Sound, nil, "isolated suite does not load Sound")
  assert_eq(COB.DecreeBanner, nil, "isolated suite does not load Decree")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load Records Book")
end

assert_eq(FighterCard.MODE, "Event", "card declares Event Mode")
assert_eq(type(FighterCard.Init), "function", "Init builds the surface")
assert_eq(type(FighterCard.Show), "function", "Show needs a sanctioned pair")
assert_eq(type(FighterCard.Hide), "function", "Hide dismisses the card")
assert_eq(type(FighterCard.Refresh), "function", "Refresh paints from Core")
assert_eq(type(FighterCard.GetView), "function", "GetView returns a copy")
assert_eq(type(FighterCard.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(FighterCard.GetHealth, nil, "no health getter")
assert_eq(FighterCard.ScrapeHealth, nil, "no health scrape")
assert_eq(FighterCard.PlayCue, nil, "no sound this lane")
assert_eq(FighterCard.Toast, nil, "card is not a toast")
assert_eq(FighterCard.Announce, nil, "software does not announce")
assert_eq(FighterCard.Narrate, nil, "software does not narrate")
assert_eq(FighterCard.Sanction, nil, "card does not sanction")
assert_eq(FighterCard.DeclareVictor, nil, "card does not record outcomes")
assert_eq(FighterCard.Favor, nil, "no favor economy table")
assert_eq(FighterCard.INPUT, nil, "no invented INPUT channel")

--------------------------------------------------------------------------------
-- Source contract: mute tape. No scrape, no sound, no flavor strings.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/FighterCard.lua", "r")
assert_true(srcFile ~= nil, "FighterCard.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("UnitHealth", 1, true), nil, "source does not read UnitHealth")
assert_eq(src:find("COMBAT_LOG", 1, true), nil, "source does not read the combat log")
assert_eq(src:find("NamePlate", 1, true), nil, "source does not scrape nameplates")
assert_eq(src:find("C_NamePlate", 1, true), nil, "source does not call C_NamePlate")
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find("StatusBar", 1, true), nil, "source does not mint a StatusBar")
assert_eq(src:find("rubber", 1, true), nil, "source has no rubber flavor")
assert_eq(src:find("ordained", 1, true), nil, "source has no ordained flavor")
assert_eq(src:find("one apiece", 1, true), nil, "source has no apiece flavor")
assert_eq(src:find(".tga", 1, true), nil, "source does not load custom tga")
assert_eq(src:find(".blp", 1, true), nil, "source does not load custom blp")
assert_eq(src:find("MORPHEUS", 1, true), nil, "names route through Theme, not a hardcoded Morpheus path")
assert_eq(src:find("Fonts\\", 1, true), nil, "source does not hardcode a Fonts path")
assert_eq(src:find("MORPHEUS_CYR", 1, true), nil, "source does not use GlueFonts MORPHEUS_CYR")
assert_true(src:find('FontPath("display")', 1, true) ~= nil
  or src:find("FontPath", 1, true) ~= nil, "names use Theme:FontPath")
assert_true(src:find('FontPath("label")', 1, true) ~= nil
  or src:find('"label"', 1, true) ~= nil, "ledger labels use Theme label role")
assert_true(src:find('FontPath("body")', 1, true) ~= nil
  or src:find('"body"', 1, true) ~= nil, "ledger values use Theme body role")
assert_true(src:find("SetFontObject", 1, true) ~= nil, "applyFont still falls back to GameFont")
assert_eq(src:find(".ttf", 1, true), nil, "source does not load custom fonts by path")
assert_eq(src:find("Media\\", 1, true), nil, "source does not require custom Media")
assert_eq(src:find("Toasts", 1, true), nil, "source does not drive Toasts")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("ShowUIPanel", 1, true), nil, "insecure Show/Hide only")
assert_eq(src:find("Interface\\PvPFrame\\", 1, true), nil, "source does not use PvPFrame crests")
assert_eq(src:find("UI-PVP-Horde", 1, true), nil, "source does not use the Horde PVP icon")
assert_eq(src:find("UI-PVP-Alliance", 1, true), nil, "source does not use the Alliance PVP icon")
assert_eq(src:find("Squire", 1, true), nil, "source does not invent Squire")
assert_eq(src:find("Paladin", 1, true), nil, "source does not invent Paladin-as-title")
assert_eq(src:find("Duke of", 1, true), nil, "source does not invent Duke of")
assert_eq(src:find("defenses of the realm", 1, true), nil, "source has no realm flavor")
assert_eq(src:find("QuestBG", 1, true), nil, "parchment goes through Theme, not a hardcoded QuestBG")
assert_eq(src:find("WHITE8X8", 1, true), nil, "iron fill does not hardcode WHITE8X8")
assert_true(src:find('Texture("ornament_bullhorn")', 1, true) ~= nil
  or src:find("ornament_bullhorn", 1, true) ~= nil, "bullhorn slot is Theme ornament_bullhorn")
assert_true(src:find('Texture("seal_papal")', 1, true) ~= nil
  or src:find("seal_papal", 1, true) ~= nil, "seal slot is Theme seal_papal")
assert_true(src:find("glyph_record", 1, true) ~= nil, "ledger uses Theme glyph_record")
assert_true(src:find("glyph_defenses", 1, true) ~= nil, "ledger uses Theme glyph_defenses")
assert_true(src:find("glyph_headtohead", 1, true) ~= nil, "ledger uses Theme glyph_headtohead")
assert_true(src:find("glyph_stipulation", 1, true) ~= nil, "ledger uses Theme glyph_stipulation")
assert_true(src:find("frame_fightercard", 1, true) ~= nil, "frame slot is Theme frame_fightercard")
assert_true(src:find("frame_proclamation_center", 1, true) ~= nil,
  "parchment reuses Theme frame_proclamation_center")
assert_true(src:find("RomanPair", 1, true) ~= nil, "records use Common.RomanPair")
assert_true(src:find("RomanNumeral", 1, true) ~= nil, "defenses use Common.RomanNumeral")
assert_true(src:find('"Record"', 1, true) ~= nil, "ledger chrome includes Record")
assert_true(src:find('"Defenses"', 1, true) ~= nil, "ledger chrome includes Defenses")
assert_true(src:find('"Head-to-head"', 1, true) ~= nil, "ledger chrome includes Head-to-head")
assert_true(src:find('"Stipulation"', 1, true) ~= nil, "ledger chrome includes Stipulation")
assert_eq(src:find("skull", 1, true), nil, "source has no skull imagery")
assert_true(src:find("UISpecialFrames", 1, true) ~= nil, "source registers UISpecialFrames")
assert_true(src:find("OnHide", 1, true) ~= nil, "source hooks OnHide")
assert_eq(src:find("✕", 1, true), nil, "source has no close mark")

--------------------------------------------------------------------------------
-- Init: hidden, left-third, two plates. No per-frame script at rest.
--------------------------------------------------------------------------------
reset()
local frame = FighterCard:Init()
assert_true(frame ~= nil, "Init creates the card frame")
assert_eq(frame:GetName(), "ChurchOfBeefFighterCard", "frame has a stable name")
assert_eq(frame:GetParent(), UIParent, "card is parented to UIParent")
assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1, "Init registers the card once")
assert_eq(FighterCard:Init(), frame, "Init is idempotent")
assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1, "second Init does not duplicate")
local savedSpecial = UISpecialFrames
UISpecialFrames = nil
assert_eq(FighterCard:Init(), frame, "Init survives a missing UISpecialFrames table")
UISpecialFrames = savedSpecial
assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1, "restored table still has one entry")
assert_eq(frame:IsShown(), false, "the widget starts hidden")
assert_eq(FighterCard:GetView().shown, false, "Quiet view is hidden")
assert_eq(frame:GetScript("OnUpdate"), nil, "a resting card runs nothing per frame")
assert_eq(findStatusBar(frame), nil, "Init mints no StatusBar")
assert_eq(countType(frame, "Button"), 0, "card has no close button")
assert_eq(frame:GetWidth(), 420, "unknown UIParent width keeps the compact third")
assert_eq(frame:GetHeight(), 220, "unknown UIParent height keeps the compact third")
assert_true(frame.parchment ~= nil, "iron/parchment dress has a parchment field")
assert_eq(frame.parchment._cobTexture, COB.Theme:Texture("frame_proclamation_center"),
  "parchment is Theme frame_proclamation_center")
assert_eq(frame.iron._cobTexture, COB.Theme:Texture("frame_fightercard"),
  "iron frame is Theme frame_fightercard")
assert_true(frame.bullhorn ~= nil, "bull-horn header slot exists")
assert_eq(frame.bullhorn._cobTexture, COB.Theme:Texture("ornament_bullhorn"),
  "bullhorn is Theme ornament_bullhorn")
assert_true(frame.seal ~= nil, "papal seal slot exists")
assert_eq(frame.seal._cobTexture, COB.Theme:Texture("seal_papal"),
  "seal is Theme seal_papal")
assert_true(frame.plateA ~= nil, "left facing plate exists")
assert_true(frame.plateB ~= nil, "right facing plate exists")
assert_eq(frame.plateA._type, "Frame", "plate A is a frame")
assert_eq(frame.plateB._type, "Frame", "plate B is a frame")

local point, relativeTo, relativePoint = frame:GetPoint(1)
assert_eq(point, "LEFT", "default anchor is LEFT")
assert_eq(relativeTo, UIParent, "default relative is UIParent")
assert_eq(relativePoint, "LEFT", "default relative point is LEFT")
assert_eq(frame._clamped, true, "card stays clamped to screen")
assert_eq(frame.plateA.name._template, "GameFontHighlight", "name fallback is GameFontHighlight")
assert_eq(frame.plateB.name._template, "GameFontHighlight", "name B fallback is GameFontHighlight")
assert_eq(frame.plateA.title._template, "GameFontNormal", "titles stay GameFont*")
assert_eq(frame.plateB.title._template, "GameFontNormal", "title B stays GameFont*")
assert_eq(frame.plateA.record._template, "GameFontNormal", "records stay GameFont*")
assert_eq(frame.plateB.record._template, "GameFontNormal", "record B stays GameFont*")
assert_true(frame.plateA.honorific ~= nil, "honorific line exists on plate A")
assert_true(frame.plateB.honorific ~= nil, "honorific line exists on plate B")
assert_eq(frame.plateA.honorific._template, "GameFontNormal", "honorifics stay GameFont*")
assert_eq(frame.plateB.honorific._template, "GameFontNormal", "honorific B stays GameFont*")
assert_eq(frame.plateA.honorific:IsShown(), false, "honorific starts hidden")
assert_eq(frame.plateB.honorific:IsShown(), false, "honorific B starts hidden")
assert_true(frame.plateA.defenses ~= nil, "defenses line exists on plate A")
assert_true(frame.plateB.defenses ~= nil, "defenses line exists on plate B")
assert_eq(frame.plateA.defenses._template, "GameFontNormal", "defenses stay GameFont*")
assert_eq(frame.plateB.defenses._template, "GameFontNormal", "defenses B stay GameFont*")
assert_eq(frame.plateA.defenses:IsShown(), false, "defenses start hidden")
assert_eq(frame.plateB.defenses:IsShown(), false, "defenses B start hidden")
assert_eq(frame.plateA.recordLabel:GetText(), "Record", "ledger label Record is on plate A")
assert_eq(frame.plateB.recordLabel:GetText(), "Record", "ledger label Record is on plate B")
assert_eq(frame.plateA.defensesLabel:GetText(), "Defenses", "ledger label Defenses is on plate A")
assert_eq(frame.plateB.defensesLabel:GetText(), "Defenses", "ledger label Defenses is on plate B")
assert_eq(frame.headToHeadLabel:GetText(), "Head-to-head", "ledger label Head-to-head exists")
assert_eq(frame.stipulationLabel:GetText(), "Stipulation", "ledger label Stipulation exists")
assert_eq(frame.headToHeadLabel:IsShown(), false, "Head-to-head label starts hidden")
assert_eq(frame.stipulationLabel:IsShown(), false, "Stipulation label starts hidden")
assert_eq(frame.plateA.recordGlyph._cobTexture, COB.Theme:Texture("glyph_record"),
  "record glyph is Theme glyph_record")
assert_eq(frame.plateB.recordGlyph._cobTexture, COB.Theme:Texture("glyph_record"),
  "record glyph B is Theme glyph_record")
assert_eq(frame.plateA.defensesGlyph._cobTexture, COB.Theme:Texture("glyph_defenses"),
  "defenses glyph is Theme glyph_defenses")
assert_eq(frame.headToHeadGlyph._cobTexture, COB.Theme:Texture("glyph_headtohead"),
  "head-to-head glyph is Theme glyph_headtohead")
assert_eq(frame.stipulationGlyph._cobTexture, COB.Theme:Texture("glyph_stipulation"),
  "stipulation glyph is Theme glyph_stipulation")
assert_eq(frame.plateA.name._cobFont, COB.Theme:FontPath("display"),
  "name A uses Theme display path")
assert_eq(frame.plateB.name._cobFont, COB.Theme:FontPath("display"),
  "name B uses Theme display path")
assert_true(frame.plateA.name._cobFontSize ~= nil
  and frame.plateA.name._cobFontSize >= 16, "name A is at least 16px")
assert_true(frame.plateB.name._cobFontSize ~= nil
  and frame.plateB.name._cobFontSize >= 16, "name B is at least 16px")
assert_eq(frame.plateA.recordLabel._cobFont, COB.Theme:FontPath("label"),
  "Record label uses Theme label path")
assert_eq(frame.plateA.record._cobFont, COB.Theme:FontPath("body"),
  "Record value uses Theme body path")
local nameFontA = frame.plateA.name.GetFont and select(1, frame.plateA.name:GetFont())
if type(nameFontA) == "string" then
  assert_eq(nameFontA, COB.Theme:FontPath("display"),
    "SetFont reports Theme display when the stub records it")
end
local nameFontB = frame.plateB.name.GetFont and select(1, frame.plateB.name:GetFont())
if type(nameFontB) == "string" then
  assert_eq(nameFontB, COB.Theme:FontPath("display"),
    "name B reports Theme display when the stub records it")
end

local view0 = FighterCard:GetView()
assert_eq(view0.shown, false, "Quiet view is hidden")
assert_eq(view0.mode, "Event", "hidden view still declares Event")
assert_eq(view0.fighterA, nil, "Quiet view has no fighter A")
assert_eq(view0.fighterB, nil, "Quiet view has no fighter B")
assert_eq(view0.headToHead, nil, "Quiet view has no head-to-head")
assert_eq(view0.stipulation, nil, "Quiet view has no stipulation")
assert_eq(view0.health, nil, "view never carries health")
assert_eq(view0.defenses, nil, "view does not invent defenses")
assert_eq(view0.favor, nil, "card is not a favor surface")

--------------------------------------------------------------------------------
-- Quiet Show is false. Event without a pair is false.
--------------------------------------------------------------------------------
reset()
assert_eq(FighterCard:Show(), false, "Quiet Show is false")
assert_eq(frame:IsShown(), false, "Quiet Show leaves the widget hidden")
assert_eq(FighterCard:GetView().shown, false, "Quiet Show view stays hidden")
assert_eq(Gora:GetSanctioned(), nil, "Quiet has no live pair")

Runtime:StartEvent()
assert_eq(FighterCard:Show(), false, "Event without a sanctioned pair is false")
assert_eq(frame:IsShown(), false, "ASSEMBLY without a pair stays hidden")
assert_eq(Gora:GetSanctioned(), nil, "no live pair yet")

twoChars()
assert_eq(FighterCard:Show(), false, "characters alone do not show the card")
assert_eq(Gora:GetSanctioned(), nil, "CreateCharacter is not a Sanction")

--------------------------------------------------------------------------------
-- Sanctioned pair: Show paints both names, titles, W-L.
--------------------------------------------------------------------------------
local a, b, pair = sanctionPair()
assert_true(pair ~= nil, "Sanction returns a live pair")
assert_eq(FighterCard:Show(), true, "sanctioned pair Show is true")
assert_eq(frame:IsShown(), true, "Show paints the widget")
local view = FighterCard:GetView()
assert_eq(view.shown, true, "view agrees the card is shown")
assert_eq(view.mode, "Event", "painted view is Event Mode")
assert_eq(view.fighterA.name, "Chuckroast", "fighter A name comes from Store")
assert_eq(view.fighterB.name, "Tendermage", "fighter B name comes from Store")
assert_eq(view.fighterA.level, 70, "fighter A level comes from Store")
assert_eq(view.fighterB.level, 68, "fighter B level comes from Store")
assert_eq(view.fighterA.wins, 0, "fresh W/L starts at zero wins")
assert_eq(view.fighterA.losses, 0, "fresh W/L starts at zero losses")
assert_eq(view.fighterB.wins, 0, "other fresh W/L starts at zero wins")
assert_eq(view.fighterB.losses, 0, "other fresh W/L starts at zero losses")
assert_eq(view.fighterA.title, "Beef Knight", "linked Knight title comes from Ranks")
assert_eq(view.fighterB.title, "Fresh Beef", "linked Fresh Beef title comes from Ranks")
assert_eq(view.headToHead, nil, "no head-to-head line without Store history")
assert_eq(view.stipulation, nil, "no stipulation when the Pope attached none")
assert_eq(view.health, nil, "shown view still has no health")
assert_eq(view.defenses, nil, "defense count is not invented")
assert_eq(view.fighterA.defenses, nil, "fighter A has no invented defenses")
assert_eq(view.fighterB.defenses, nil, "fighter B has no invented defenses")
assert_eq(view.fighterA.honorific, nil, "linked humans with no honorifics omit the line")
assert_eq(view.fighterB.honorific, nil, "the other human also omits the line")
assert_eq(view.odds, nil, "no odds copy")
assert_eq(frame.plateA.name:GetText(), "Chuckroast", "name A is painted")
assert_eq(frame.plateB.name:GetText(), "Tendermage", "name B is painted")
assert_eq(frame.plateA.level:GetText(), "70", "level A is painted")
assert_eq(frame.plateB.level:GetText(), "68", "level B is painted")
assert_eq(frame.plateA.title:GetText(), "Beef Knight", "title A is painted")
assert_eq(frame.plateB.title:GetText(), "Fresh Beef", "title B is painted")
assert_eq(frame.plateA.record:GetText(), ROMAN_FRESH, "record A is roman Store W/L")
assert_eq(frame.plateB.record:GetText(), ROMAN_FRESH, "record B is roman Store W/L")
assert_eq(frame.headToHead:IsShown(), false, "head-to-head widget hides without history")
assert_eq(frame.stipulation:IsShown(), false, "stipulation widget hides when none")
assert_eq(frame.plateA.honorific:IsShown(), false, "no honorifics → widget hidden")
assert_eq(frame.plateB.honorific:IsShown(), false, "other plate hides without honorifics")
assert_eq(frame.plateA.honorific:GetText(), "", "empty honorific paints empty")
assert_eq(frame.plateA.defenses:IsShown(), false, "zero defenses hide")
assert_eq(frame.plateB.defenses:IsShown(), false, "zero defenses hide on the other plate")
assert_eq(frame.plateA.defenses:GetText(), "", "zero defenses paint empty")
assert_eq(frame.plateA.recordLabel:IsShown(), true, "Record label stays on a shown card")
assert_eq(frame.plateA.defensesLabel:IsShown(), false, "Defenses label hides with a zero count")
assert_eq(frame.headToHeadLabel:IsShown(), false, "Head-to-head label hides without history")
assert_eq(frame.stipulationLabel:IsShown(), false, "Stipulation label hides when none")
assert_eq(findStatusBar(frame), nil, "shown card still has no StatusBar")
assert_eq(sounds, 0, "showing the card plays no sound")
assert_eq(healthReads, 0, "showing the card does not read live health")
assert_eq(#stub.chat, 0, "card never SendChatMessage")
assert_eq(#stub.addonMessages, 0, "card never SendAddonMessage")
assert_eq(string.find(frame.plateA.title:GetText() or "", "Paladin", 1, true), nil,
  "title is the Church title, not a class mash")
assert_eq(string.find(frame.plateA.title:GetText() or "", "Squire", 1, true), nil,
  "title is not Squire")

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
assert_true(frame.plateA.name._cobColor ~= nil, "name A stores the applied tint")
assert_eq(frame.plateA.name._cobColor.r, warrior.r, "name A widget is class-tinted")
assert_eq(sameRgb(frame.plateA.level._cobColor, warrior), false, "level A is not class-colored")
assert_eq(sameRgb(frame.plateA.title._cobColor, warrior), false, "title A is not class-colored")
assert_eq(sameRgb(frame.plateA.record._cobColor, warrior), false, "record A is not class-colored")
assert_eq(sameRgb(frame.plateA.honorific._cobColor, warrior), false, "honorific A is not class-colored")
assert_eq(sameRgb(frame.plateA.defenses._cobColor, warrior), false, "defenses A is not class-colored")
assert_eq(sameRgb(frame.plateB.level._cobColor, mage), false, "level B is not class-colored")
assert_eq(sameRgb(frame.plateB.title._cobColor, mage), false, "title B is not class-colored")
assert_eq(sameRgb(frame.plateB.record._cobColor, mage), false, "record B is not class-colored")

--------------------------------------------------------------------------------
-- Unlinked characters have no invented title. Pope stipulation paints as-is.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
pair = Gora:Sanction(a.id, b.id, "no potions")
assert_eq(FighterCard:Show(), true, "Show accepts a Pope stipulation")
view = FighterCard:GetView()
assert_eq(view.fighterA.title, nil, "unlinked characters have no invented title")
assert_eq(view.fighterB.title, nil, "the other unlinked character has no invented title")
assert_eq(frame.plateA.title:GetText(), "", "unlinked title paints empty, not Fresh Beef")
assert_eq(view.fighterA.honorific, nil, "unlinked characters have no invented honorific")
assert_eq(view.fighterB.honorific, nil, "the other unlinked character has no invented honorific")
assert_eq(frame.plateA.honorific:IsShown(), false, "unlinked honorific stays hidden")
assert_eq(frame.plateA.honorific:GetText(), "", "unlinked honorific paints empty")
assert_eq(view.stipulation, "no potions", "stipulation comes from GetSanctioned")
assert_eq(frame.stipulation:IsShown(), true, "stipulation widget shows when the Pope wrote one")
assert_eq(frame.stipulation:GetText(), "no potions", "stipulation is the Pope line")
assert_eq(frame.stipulationLabel:IsShown(), true, "Stipulation label shows with the Pope line")
assert_eq(frame.stipulationGlyph:IsShown(), true, "Stipulation glyph shows with the Pope line")
assert_eq(string.find(frame.stipulation:GetText() or "", "meeting", 1, true), nil,
  "stipulation is not narration")

--------------------------------------------------------------------------------
-- Head-to-head appears only when Store already has history. Numbers, not prose.
--------------------------------------------------------------------------------
Gora:DeclareVictor(a.id)
assert_eq(Gora:GetSanctioned(), nil, "a ruling clears the live pair")
view = FighterCard:Refresh()
assert_eq(view.shown, true, "card stays shown after DeclareVictor while the event is live")
assert_eq(frame:IsShown(), true, "widget stays painted after the pair clears mid-event")
assert_eq(view.fighterA.name, "Chuckroast", "remembered pair still paints fighter A")
assert_eq(view.fighterB.name, "Tendermage", "remembered pair still paints fighter B")
assert_eq(view.health, nil, "persist still has no health")
assert_eq(view.verdict, nil, "card does not invent a verdict qualifier")
assert_eq(Store:GetCharacter(a.id).gora.wins, 1, "Store recorded the win")
assert_eq(Store:GetCharacter(b.id).gora.losses, 1, "Store recorded the loss")
assert_eq(Store:GetCharacter(a.id).gora.defenses, nil, "Store still nils defenses")
assert_eq(frame.plateA.record:GetText(), ROMAN_WIN, "persist paint keeps roman I–N after the ruling")
assert_eq(frame.plateB.record:GetText(), ROMAN_LOSS, "persist paint keeps the loser roman N–I")
assert_eq(frame.headToHead:GetText(), ROMAN_WIN, "persist H2H is the Store roman I–N")
assert_eq(frame.headToHead:IsShown(), true, "persist H2H shows after the ruling")

local rematch = Gora:Sanction(a.id, b.id)
assert_true(rematch ~= nil, "same pair may be sanctioned again")
assert_eq(FighterCard:Show(), true, "a rematch Show is true")
view = FighterCard:GetView()
assert_eq(view.shown, true, "a rematch shows the card again")
assert_eq(view.fighterA.wins, 1, "W/L reflects Store after the first ruling")
assert_eq(view.fighterA.losses, 0, "winner has no loss")
assert_eq(view.fighterB.wins, 0, "loser has no win")
assert_eq(view.fighterB.losses, 1, "loser has one loss")
assert_eq(frame.plateA.record:GetText(), ROMAN_WIN, "painted record A follows Store in roman")
assert_eq(frame.plateB.record:GetText(), ROMAN_LOSS, "painted record B follows Store in roman")
assert_true(view.headToHead ~= nil, "Store history produces a head-to-head line")
assert_eq(view.headToHead.wins, 1, "head-to-head wins are fighter A's")
assert_eq(view.headToHead.losses, 0, "head-to-head losses are fighter A's")
assert_eq(view.headToHead.fights, 1, "head-to-head fights come from Store")
assert_eq(view.headToHead.score, nil, "head-to-head has no pairing score")
assert_eq(frame.headToHead:IsShown(), true, "head-to-head widget shows when history exists")
assert_eq(frame.headToHead:GetText(), ROMAN_WIN, "head-to-head line is the Store roman record")
assert_eq(frame.headToHeadLabel:IsShown(), true, "Head-to-head label shows with history")
assert_eq(frame.headToHeadGlyph:IsShown(), true, "Head-to-head glyph shows with history")
assert_eq(string.find(frame.headToHead:GetText() or "", "meeting", 1, true), nil,
  "head-to-head is a record, not narration")
assert_eq(string.find(frame.headToHead:GetText() or "", "odds", 1, true), nil,
  "head-to-head has no odds copy")

--------------------------------------------------------------------------------
-- Hide dismisses. Refresh with a live pair shows again. QUIET hides.
-- ASSEMBLY after QUIET does not revive the last pair.
--------------------------------------------------------------------------------
FighterCard:Hide()
assert_eq(frame:IsShown(), false, "Hide dismisses the widget")
assert_eq(FighterCard:GetView().shown, false, "Hide clears the view")
assert_true(Gora:GetSanctioned() ~= nil, "Hide does not clear the live pair")

view = FighterCard:Refresh()
assert_eq(view.shown, true, "Refresh with a live pair shows again")
assert_eq(frame:IsShown(), true, "Refresh paints the widget")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent returns to QUIET")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET")
assert_eq(Gora:GetSanctioned(), nil, "QUIET expires the live pair")
view = FighterCard:Refresh()
assert_eq(view.shown, false, "Quiet Mode hides the card")
assert_eq(frame:IsShown(), false, "Quiet Mode hides the widget")
assert_eq(FighterCard:Show(), false, "Quiet Show is false after EndEvent")
assert_eq(sounds, 0, "hiding plays no sound")
assert_eq(healthReads, 0, "hiding does not scrape health")

Runtime:StartEvent()
view = FighterCard:Refresh()
assert_eq(view.shown, false, "ASSEMBLY after QUIET does not revive the last pair")
assert_eq(frame:IsShown(), false, "ASSEMBLY after QUIET leaves the widget hidden")
assert_eq(Gora:GetSanctioned(), nil, "no new Sanction yet")
assert_eq(FighterCard:Show(), false, "ASSEMBLY without a pair stays hidden")

--------------------------------------------------------------------------------
-- ESC / widget Hide syncs lastView via OnHide. lastPair stays until QUIET.
-- paintHidden / Hide must not recurse forever.
--------------------------------------------------------------------------------
a, b, pair = sanctionPair()
assert_eq(FighterCard:Show(), true, "OnHide path needs a live card")
assert_eq(FighterCard:GetView().shown, true, "live card view is shown")
assert_true(frame:GetScript("OnHide") ~= nil, "card hooks OnHide")
assert_eq(stub.fire(frame, "OnHide"), true, "OnHide fires")
assert_eq(FighterCard:GetView().shown, false, "OnHide sets lastView.shown false")
assert_true(Gora:GetSanctioned() ~= nil, "OnHide does not clear the live pair")
view = FighterCard:Refresh()
assert_eq(view.shown, true, "Refresh after OnHide still paints the remembered pair")
assert_eq(view.fighterA.name, "Chuckroast", "OnHide did not forget lastPair")
assert_eq(view.fighterB.name, "Tendermage", "OnHide did not forget the other fighter")
assert_eq(frame:IsShown(), true, "Refresh after OnHide paints the widget")
assert_eq(view.health, nil, "OnHide persist still has no health")

assert_eq(FighterCard:Show(), true, "widget Hide path needs a live card")
frame:Hide()
assert_eq(frame:IsShown(), false, "widget Hide dismisses the card")
assert_eq(FighterCard:GetView().shown, false, "widget Hide syncs lastView.shown")
assert_true(Gora:GetSanctioned() ~= nil, "widget Hide does not clear the live pair")
view = FighterCard:Refresh()
assert_eq(view.shown, true, "Refresh after widget Hide still paints the remembered pair")
assert_eq(frame.plateA.name:GetText(), "Chuckroast", "remembered pair still paints A")
assert_eq(frame.plateB.name:GetText(), "Tendermage", "remembered pair still paints B")

FighterCard:Hide()
FighterCard:Hide()
assert_eq(FighterCard:GetView().shown, false, "second Hide stays hidden")
assert_eq(stub.fire(frame, "OnHide"), true, "OnHide while hidden still fires")
assert_eq(FighterCard:GetView().shown, false, "OnHide while hidden stays lastView hidden")
view = FighterCard:Refresh()
assert_eq(view.shown, true, "Refresh after guarded Hide still paints the remembered pair")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent after OnHide persist")
view = FighterCard:Refresh()
assert_eq(view.shown, false, "QUIET still forgets after OnHide")
assert_eq(frame:IsShown(), false, "QUIET hides the widget after OnHide")
Runtime:StartEvent()
view = FighterCard:Refresh()
assert_eq(view.shown, false, "ASSEMBLY after QUIET still does not revive last pair")
assert_eq(sounds, 0, "OnHide plays no sound")
assert_eq(healthReads, 0, "OnHide does not scrape health")

--------------------------------------------------------------------------------
-- Runtime subjects.fighters show the card when Gora has no live pair
-- (congregation). Persist last pair after subjects clear. QUIET hides.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local subA, subB = twoChars()
assert_eq(Gora:GetSanctioned(), nil, "congregation path has no live Gora pair")
assert_true(Runtime:OpenRite("Gora", { fighters = { subA.id, subB.id } }) ~= nil,
  "OpenRite names the congregation pair")
assert_eq(Gora:GetSanctioned(), nil, "OpenRite does not Sanction")
assert_eq(FighterCard:Show(), true, "Runtime subjects show the card")
assert_eq(frame:IsShown(), true, "subjects path paints the widget")
view = FighterCard:GetView()
assert_eq(view.shown, true, "subjects view is shown")
assert_eq(view.fighterA.name, "Chuckroast", "subjects pair paints fighter A")
assert_eq(view.fighterB.name, "Tendermage", "subjects pair paints fighter B")
assert_eq(view.fighterA.id, subA.id, "subjects fighter A id is the Runtime id")
assert_eq(view.fighterB.id, subB.id, "subjects fighter B id is the Runtime id")
assert_eq(view.health, nil, "subjects path has no health")
assert_eq(view.verdict, nil, "subjects path does not invent a verdict")
assert_eq(view.stipulation, nil, "subjects pair has no invented stipulation")
assert_eq(frame.plateA.name:GetText(), "Chuckroast", "subjects name A is painted")
assert_eq(frame.plateB.name:GetText(), "Tendermage", "subjects name B is painted")
assert_eq(frame.plateA.record:GetText(), ROMAN_FRESH, "fresh subjects W/L stays roman N–N")
assert_eq(healthReads, 0, "subjects path does not scrape health")

assert_true(Runtime:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
view = FighterCard:Refresh()
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "runtime is CONSEQUENCE")
assert_eq(view.shown, true, "CONSEQUENCE still paints the remembered subjects pair")
assert_eq(frame:IsShown(), true, "CONSEQUENCE keeps the widget painted")
assert_eq(Gora:GetSanctioned(), nil, "CONSEQUENCE still has no live Gora pair")

assert_true(Runtime:Continue() ~= nil, "Continue returns to ASSEMBLY")
assert_eq(Runtime:Snapshot().subjects.fighters, nil, "Continue clears fighters")
view = FighterCard:Refresh()
assert_eq(view.shown, true, "ASSEMBLY after subjects clear still persists last pair")
assert_eq(frame.plateA.name:GetText(), "Chuckroast", "persisted subjects still paint A")
assert_eq(frame.plateB.name:GetText(), "Tendermage", "persisted subjects still paint B")
assert_eq(view.health, nil, "persisted subjects still have no health")

FighterCard:Hide()
assert_eq(frame:IsShown(), false, "Hide dismisses the subjects card")
assert_eq(FighterCard:GetView().shown, false, "Hide clears the subjects view")
view = FighterCard:Refresh()
assert_eq(view.shown, true, "Refresh after Hide still paints the remembered subjects")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent after subjects persist")
view = FighterCard:Refresh()
assert_eq(view.shown, false, "QUIET hides the subjects card")
assert_eq(frame:IsShown(), false, "QUIET hides the subjects widget")
assert_eq(FighterCard:Show(), false, "Quiet Show is false after subjects EndEvent")

Runtime:StartEvent()
view = FighterCard:Refresh()
assert_eq(view.shown, false, "ASSEMBLY after subjects QUIET does not revive last pair")
assert_eq(Gora:GetSanctioned(), nil, "no Sanction after subjects QUIET")

--------------------------------------------------------------------------------
-- Honorifics: Pope text from Store human. Empty hides. Never invent Duke.
--------------------------------------------------------------------------------
local ha, hb = sanctionPair()
assert_eq(FighterCard:Show(), true, "honorific path still needs a sanctioned pair")
view = FighterCard:GetView()
assert_eq(view.fighterA.honorific, nil, "fresh linked humans omit the honorific")
assert_eq(view.fighterB.honorific, nil, "the other fresh human omits the honorific")
assert_eq(frame.plateA.honorific:IsShown(), false, "no honorifics → widget hidden")
assert_eq(frame.plateB.honorific:IsShown(), false, "other plate hides without honorifics")
assert_eq(frame.plateA.honorific:GetText(), "", "empty honorific paints empty")
assert_eq(frame.plateA.record:GetText(), ROMAN_FRESH, "honorific path keeps a fresh roman W/L")

local humanA = Store:GetHuman(Store:GetCharacter(ha.id).humanId)
assert_true(humanA ~= nil, "linked fighter has a Store human")
Store:AddHonorific(humanA.id, "Defender of the Faith")
view = FighterCard:Refresh()
assert_eq(view.fighterA.honorific, "Defender of the Faith", "honorific is Pope text from Store")
assert_eq(frame.plateA.honorific:IsShown(), true, "seeded honorific shows")
assert_eq(frame.plateA.honorific:GetText(), "Defender of the Faith", "paints exactly that string")
assert_eq(view.fighterB.honorific, nil, "unseeded human stays empty")
assert_eq(frame.plateB.honorific:IsShown(), false, "unseeded honorific stays hidden")
assert_eq(frame.plateB.honorific:GetText(), "", "unseeded honorific paints empty")
assert_eq(frame.plateA.record:GetText(), ROMAN_FRESH, "seeding an honorific does not change W/L")
assert_eq(string.find(frame.plateA.honorific:GetText() or "", "Duke of", 1, true), nil,
  "painted honorific is not an invented Duke")
assert_eq(sameRgb(frame.plateA.honorific._cobColor, RAID_CLASS_COLORS.WARRIOR), false,
  "honorific is not class-colored")

Gora:DeclareVictor(ha.id)
local rematchHonor = Gora:Sanction(ha.id, hb.id)
assert_true(rematchHonor ~= nil, "honorific rematch may be sanctioned")
assert_eq(FighterCard:Show(), true, "honorific rematch Show is true")
view = FighterCard:GetView()
assert_eq(frame.plateA.record:GetText(), ROMAN_WIN, "roman I–N pin stays with honorific")
assert_eq(frame.plateB.record:GetText(), ROMAN_LOSS, "loser record stays roman N–I with honorific")
assert_eq(frame.headToHead:GetText(), ROMAN_WIN, "H2H roman I–N pin stays with honorific")
assert_eq(frame.headToHead:IsShown(), true, "H2H still shows after honorific paint")
assert_eq(view.fighterA.honorific, "Defender of the Faith", "honorific survives rematch")
assert_eq(frame.plateA.honorific:GetText(), "Defender of the Faith", "rematch paints the same Pope text")
assert_eq(frame.plateA.honorific:IsShown(), true, "honorific still shown after rematch")
assert_eq(view.fighterB.honorific, nil, "unseeded rematch plate stays empty")
assert_eq(frame.plateB.honorific:IsShown(), false, "unseeded rematch honorific stays hidden")

--------------------------------------------------------------------------------
-- Defenses: mute integer from Store:CountDefenses. Zero / missing method hides.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
local lordChar, challenger = twoChars()
local humanLord = rankBoth(lordChar, challenger, 4, 1)
assert_true(Gora:Sanction(lordChar.id, challenger.id) ~= nil, "Lord pair can be sanctioned")
assert_true(Gora:DeclareVictor(lordChar.id) ~= nil, "post-elevation win is recorded")
local savedCountDefenses = Store.CountDefenses
if type(Store.CountDefenses) ~= "function" then
  Store.CountDefenses = function(_, id)
    if id == lordChar.id then return 1 end
    return 0
  end
else
  assert_eq(Store:CountDefenses(lordChar.id), 1, "sitting Lord post-elevation win is one defense")
  assert_eq(Store:CountDefenses(challenger.id), 0, "Fresh Beef has no defenses")
end
assert_eq(Store:GetCharacter(lordChar.id).gora.defenses, nil, "card does not write gora.defenses")
local lordRematch = Gora:Sanction(lordChar.id, challenger.id)
assert_true(lordRematch ~= nil, "Lord rematch may be sanctioned")
assert_eq(FighterCard:Show(), true, "Lord rematch Show is true")
view = FighterCard:GetView()
assert_eq(view.fighterA.title, "Beef Lord", "elevated fighter keeps the Lord title")
assert_eq(view.fighterA.defenses, 1, "plate view carries the CountDefenses integer")
assert_eq(view.fighterB.defenses, nil, "zero CountDefenses stays omitted")
assert_eq(view.defenses, nil, "view does not invent a top-level defenses field")
assert_eq(view.health, nil, "defenses paint does not invent health")
assert_eq(frame.plateA.defenses:IsShown(), true, "nonzero defenses show")
assert_eq(frame.plateA.defenses:GetText(), "I", "defenses is a mute roman numeral")
assert_eq(frame.plateA.defensesLabel:IsShown(), true, "Defenses label shows with a nonzero count")
assert_eq(frame.plateA.defensesGlyph:IsShown(), true, "Defenses glyph shows with a nonzero count")
assert_eq(frame.plateB.defenses:IsShown(), false, "zero defenses hide on the other plate")
assert_eq(frame.plateB.defenses:GetText(), "", "zero defenses paint empty")
assert_eq(frame.plateA.record:GetText(), ROMAN_WIN, "roman I–N pin stays with defenses")
assert_eq(frame.plateB.record:GetText(), ROMAN_LOSS, "loser record stays roman N–I with defenses")
assert_eq(frame.headToHead:GetText(), ROMAN_WIN, "H2H roman I–N pin stays with defenses")
assert_eq(frame.headToHead:IsShown(), true, "H2H still shows after defenses paint")
assert_eq(string.find(frame.plateA.defenses:GetText() or "", "realm", 1, true), nil,
  "defenses line is not realm flavor")
assert_eq(string.find(frame.plateA.defenses:GetText() or "", "defense", 1, true), nil,
  "defenses line has no copy")
assert_eq(sameRgb(frame.plateA.defenses._cobColor, RAID_CLASS_COLORS.WARRIOR), false,
  "defenses is not class-colored")

Store:AddHonorific(humanLord.id, "Defender of the Faith")
view = FighterCard:Refresh()
assert_eq(view.fighterA.honorific, "Defender of the Faith", "honorific stays with defenses")
assert_eq(frame.plateA.honorific:IsShown(), true, "honorific still shown with defenses")
assert_eq(frame.plateA.honorific:GetText(), "Defender of the Faith", "honorific text unchanged")
assert_eq(frame.plateA.defenses:GetText(), "I", "defenses stay roman while honorific paints")
assert_eq(frame.plateA.record:GetText(), ROMAN_WIN, "roman I–N stays with honorific and defenses")
assert_eq(frame.headToHead:GetText(), ROMAN_WIN, "H2H roman I–N stays with honorific and defenses")

Store.CountDefenses = function(_, id)
  if id == lordChar.id then return 2 end
  return 0
end
view = FighterCard:Refresh()
assert_eq(view.fighterA.defenses, 2, "card paints whatever CountDefenses returns")
assert_eq(frame.plateA.defenses:GetText(), "II", "stub integer paints as roman")
assert_eq(frame.plateA.honorific:IsShown(), true, "honorific stays when the integer changes")
assert_eq(frame.plateA.record:GetText(), ROMAN_WIN, "stubbing CountDefenses does not change W/L")
assert_eq(frame.headToHead:GetText(), ROMAN_WIN, "H2H roman I–N stays when CountDefenses is stubbed")

Store.CountDefenses = nil
view = FighterCard:Refresh()
assert_eq(view.fighterA.defenses, nil, "missing CountDefenses omits the field")
assert_eq(frame.plateA.defenses:IsShown(), false, "missing CountDefenses hides the line")
assert_eq(frame.plateA.defenses:GetText(), "", "missing CountDefenses paints empty")
assert_eq(frame.plateA.defensesLabel:IsShown(), false, "missing CountDefenses hides the label")
assert_eq(frame.plateA.defensesGlyph:IsShown(), false, "missing CountDefenses hides the glyph")
assert_eq(frame.plateA.honorific:IsShown(), true, "honorific stays when defenses hide")
assert_eq(frame.plateA.record:GetText(), ROMAN_WIN, "roman I–N stays when CountDefenses is missing")
assert_eq(frame.headToHead:GetText(), ROMAN_WIN, "H2H roman I–N stays when CountDefenses is missing")

Store.CountDefenses = savedCountDefenses

--------------------------------------------------------------------------------
-- Both-nonzero records paint through Common.RomanPair (no nulla side)
--------------------------------------------------------------------------------
do
  reset()
  Runtime:StartEvent()
  local vetA, vetB = twoChars()
  rankBoth(vetA, vetB, 3, 3)
  for i = 1, 3 do
    assert_true(Gora:Sanction(vetA.id, vetB.id) ~= nil, "vet sanction " .. i)
    assert_true(Gora:DeclareVictor(vetA.id) ~= nil, "vet ruling " .. i)
  end
  for i = 1, 2 do
    assert_true(Gora:Sanction(vetA.id, vetB.id) ~= nil, "vet answer sanction " .. i)
    assert_true(Gora:DeclareVictor(vetB.id) ~= nil, "vet answer ruling " .. i)
  end
  assert_true(Gora:Sanction(vetA.id, vetB.id) ~= nil, "vet rubber match sanctions")
  assert_eq(FighterCard:Show(), true, "both-nonzero card shows")
  local vetView = FighterCard:GetView()
  assert_eq(vetView.fighterA.wins, 3, "view keeps numeric wins under roman paint")
  assert_eq(vetView.fighterA.losses, 2, "view keeps numeric losses under roman paint")
  assert_eq(frame.plateA.record:GetText(), "III" .. EN_DASH .. "II",
    "both-nonzero record paints III–II via RomanPair")
  assert_eq(frame.plateB.record:GetText(), "II" .. EN_DASH .. "III",
    "loser side paints II–III via RomanPair")
  assert_eq(frame.headToHead:GetText(), "III" .. EN_DASH .. "II",
    "both-nonzero H2H paints III–II via RomanPair")
  assert_eq(frame.headToHead:IsShown(), true, "both-nonzero H2H shows")
end

--------------------------------------------------------------------------------
-- Missing class colors and unknown class still paint names. Level omitted if absent.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars({ name = "Mystery", class = "Banana" }, { name = "Plain", level = 12 })
Gora:Sanction(a.id, b.id)
local savedColors = RAID_CLASS_COLORS
RAID_CLASS_COLORS = nil
assert_eq(FighterCard:Show(), true, "missing RAID_CLASS_COLORS does not hide the card")
view = FighterCard:GetView()
assert_eq(view.fighterA.name, "Mystery", "unknown class still shows the name")
assert_eq(view.fighterA.nameColor, nil, "unknown class has no invented tint")
assert_eq(view.fighterA.level, nil, "missing level is omitted")
assert_eq(frame.plateA.level:GetText(), "", "missing level paints empty")
assert_eq(view.fighterB.name, "Plain", "a class-less fighter still shows")
assert_eq(view.fighterB.level, 12, "present level still paints")
RAID_CLASS_COLORS = savedColors

view = FighterCard:Refresh()
assert_eq(view.fighterA.nameColor, nil, "Banana is not a class file")
assert_eq(frame.plateA.name:GetText(), "Mystery", "name survives a missing class tint")

--------------------------------------------------------------------------------
-- GetView returns a copy. Card does not write Store or Gora.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
assert_eq(FighterCard:Show(), true, "Show for the copy pin")
view = FighterCard:GetView()
view.fighterA.name = "Mutated"
view.shown = false
view.stipulation = "invented"
view.fighterA.honorific = "Duke of the Fountain"
view.fighterA.defenses = 99
local again = FighterCard:GetView()
assert_eq(again.fighterA.name, "Chuckroast", "mutating GetView does not change the live view")
assert_eq(again.shown, true, "mutating GetView does not hide the card")
assert_eq(again.stipulation, nil, "mutating GetView does not invent a stipulation")
assert_eq(again.fighterA.honorific, nil, "mutating GetView does not invent an honorific")
assert_eq(again.fighterA.defenses, nil, "mutating GetView does not invent defenses")
assert_eq(Store:GetCharacter(a.id).name, "Chuckroast", "card does not write the character")
assert_eq(Gora:GetSanctioned().fighterA, a.id, "card does not clear the live pair")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
assert_eq(FighterCard:Show(), true, "card is showing before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(FighterCard:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(frame:IsShown(), true, "out-of-harness reset does not hide the card")
ChurchOfBeef._IN_TEST = true

--------------------------------------------------------------------------------
-- Toast trap: Show / Refresh must not call a toast engine if one is present
--------------------------------------------------------------------------------
local toastCalls = 0
local savedToasts = COB.Toasts
COB.Toasts = {
  Show = function() toastCalls = toastCalls + 1 end,
  Push = function() toastCalls = toastCalls + 1 end,
  Celebrate = function() toastCalls = toastCalls + 1 end,
}
FighterCard:Refresh()
assert_eq(toastCalls, 0, "card does not toast")
COB.Toasts = savedToasts

assert_eq(sounds, 0, "the suite played no sound")
assert_eq(healthReads, 0, "the suite never scraped health")

--------------------------------------------------------------------------------
-- Left-third when UIParent size is known. Not a full-screen toast.
--------------------------------------------------------------------------------
UIParent:SetWidth(1024)
UIParent:SetHeight(768)
dofile("addon/ChurchOfBeef/UI/FighterCard.lua")
FighterCard = COB.FighterCard
reset()
local budgeted = FighterCard:Init()
assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1, "rebuild Init still does not duplicate")
assert_eq(budgeted:GetWidth(), math.floor(1024 / 3), "known UIParent width is the left third")
assert_true(budgeted:GetWidth() < 1024, "width is not full-screen")
assert_true(budgeted:GetHeight() <= math.floor(768 / 3), "height stays inside the left third")
assert_true(budgeted:GetHeight() <= 220, "height does not grow into a toast")
local bp, brto, brp = budgeted:GetPoint(1)
assert_eq(bp, "LEFT", "rebuilt default anchor is LEFT")
assert_eq(brto, UIParent, "rebuilt relative is UIParent")
assert_eq(brp, "LEFT", "rebuilt relative point is LEFT")
assert_eq(budgeted._clamped, true, "rebuilt card stays clamped")
assert_eq(budgeted.plateA.name._template, "GameFontHighlight", "rebuilt name fallback is GameFontHighlight")
assert_true(budgeted.plateA ~= nil, "rebuilt card still has plate A")
assert_true(budgeted.plateB ~= nil, "rebuilt card still has plate B")
assert_true(budgeted.plateA.honorific ~= nil, "rebuilt card still has honorific A")
assert_true(budgeted.plateB.honorific ~= nil, "rebuilt card still has honorific B")
assert_eq(budgeted.plateA.honorific:IsShown(), false, "rebuilt Quiet hides honorific")
assert_true(budgeted.plateA.defenses ~= nil, "rebuilt card still has defenses A")
assert_true(budgeted.plateB.defenses ~= nil, "rebuilt card still has defenses B")
assert_eq(budgeted.plateA.defenses:IsShown(), false, "rebuilt Quiet hides defenses")
assert_true(budgeted.bullhorn ~= nil, "rebuilt card still has the bullhorn slot")
assert_eq(budgeted.bullhorn._cobTexture, COB.Theme:Texture("ornament_bullhorn"),
  "rebuilt bullhorn is still Theme ornament_bullhorn")
assert_eq(budgeted.seal._cobTexture, COB.Theme:Texture("seal_papal"),
  "rebuilt seal is still Theme seal_papal")
assert_eq(budgeted.plateA.name._cobFont, COB.Theme:FontPath("display"),
  "rebuilt name still uses Theme display")
assert_eq(budgeted.plateA.recordLabel:GetText(), "Record", "rebuilt ledger still has Record")
assert_eq(findStatusBar(budgeted), nil, "rebuilt card still has no StatusBar")
assert_eq(budgeted:IsShown(), false, "rebuild in Quiet still hides the card")
assert_true(budgeted:GetScript("OnHide") ~= nil, "rebuilt card still hooks OnHide")
local copy = FighterCard:GetView()
copy.shown = true
copy.health = { a = 1 }
assert_eq(FighterCard:GetView().shown, false, "GetView is still a copy after a rebuild")
assert_eq(FighterCard:GetView().health, nil, "rebuilt view still has no health")

--------------------------------------------------------------------------------
-- B28-D: Init restores a missing OnHide. Third Init keeps identity.
-- Nested to keep new locals off the main chunk. Isolation wrap stays.
--------------------------------------------------------------------------------
local function runB28D()
  assert_true(src:find("local function wireCardOnHide", 1, true) ~= nil,
    "source extracts wireCardOnHide")
  local initBody = src:match("function FighterCard:Init%(%)(.-)\nfunction FighterCard:GetView")
  assert_true(type(initBody) == "string" and initBody ~= "",
    "FighterCard:Init body is readable")
  if type(initBody) ~= "string" then initBody = "" end
  assert_true(initBody:find("wireCardOnHide", 1, true) ~= nil,
    "Init remounts OnHide via wireCardOnHide")
  assert_eq(initBody:find("SetScript", 1, true), nil,
    "Init does not SetScript inline")
  assert_true(initBody:find("rememberSpecial", 1, true) ~= nil,
    "Init still rememberSpecial")
  assert_eq(initBody:find("PlaySound", 1, true), nil,
    "Init does not PlaySound")
  local wireCard = src:match("local function wireCardOnHide%(widget%)(.-)\nlocal function build")
  assert_true(type(wireCard) == "string" and wireCard ~= "",
    "wireCardOnHide body is readable")
  if type(wireCard) ~= "string" then wireCard = "" end
  assert_true(wireCard:find("GetScript", 1, true) ~= nil,
    "wireCardOnHide checks GetScript")
  assert_true(wireCard:find("SetScript", 1, true) ~= nil,
    "wireCardOnHide holds SetScript")
  assert_true(wireCard:find("OnHide", 1, true) ~= nil,
    "wireCardOnHide wires OnHide")
  assert_true(wireCard:find("lastView", 1, true) ~= nil,
    "wireCardOnHide syncs lastView")
  assert_true(wireCard:find("paintHidden", 1, true) ~= nil,
    "wireCardOnHide calls paintHidden")
  assert_true(wireCard:find("hiding", 1, true) ~= nil,
    "wireCardOnHide guards hiding")
  assert_eq(wireCard:find("forgetPersist", 1, true), nil,
    "wireCardOnHide does not forget lastPair")
  assert_eq(wireCard:find("PlaySound", 1, true), nil,
    "wireCardOnHide does not PlaySound")
  assert_eq(wireCard:find("CreateFrame", 1, true), nil,
    "wireCardOnHide does not rebuild")
  local buildBody = src:match("local function build%(%)(.-)\nfunction FighterCard:Init")
  assert_true(type(buildBody) == "string" and buildBody ~= "",
    "build body is readable")
  if type(buildBody) ~= "string" then buildBody = "" end
  assert_true(buildBody:find("wireCardOnHide", 1, true) ~= nil,
    "create-path uses wireCardOnHide")
  assert_eq(buildBody:find('SetScript("OnHide"', 1, true), nil,
    "create-path does not SetScript OnHide inline")

  sanctionPair()
  assert_eq(FighterCard:Show(), true, "B28-D remount needs a live card")
  local widget = FighterCard:Init()
  assert_true(widget:GetScript("OnHide") ~= nil, "live card has OnHide")
  local savedCreate = CreateFrame
  local createCalls = 0
  CreateFrame = function(...)
    createCalls = createCalls + 1
    return savedCreate(...)
  end
  widget:SetScript("OnHide", nil)
  assert_eq(widget:GetScript("OnHide"), nil, "OnHide niled before second Init")
  assert_eq(FighterCard:Init(), widget, "niled OnHide Init returns the existing frame")
  local restored = widget:GetScript("OnHide")
  assert_true(restored ~= nil, "second Init restores missing OnHide")
  assert_eq(createCalls, 0, "second Init does not rebuild")
  assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
    "restore Init does not duplicate")
  assert_eq(FighterCard:Init(), widget, "third Init returns the existing frame")
  assert_eq(widget:GetScript("OnHide"), restored, "third Init does not replace OnHide")
  assert_eq(createCalls, 0, "third Init does not rebuild")
  CreateFrame = savedCreate

  assert_eq(stub.fire(widget, "OnHide"), true, "restored OnHide fires")
  assert_eq(FighterCard:GetView().shown, false,
    "restored OnHide sets lastView.shown false")
  assert_true(Gora:GetSanctioned() ~= nil,
    "restored OnHide does not clear the live pair")
  local persist = FighterCard:Refresh()
  assert_eq(persist.shown, true, "Refresh after restored OnHide still paints")
  assert_eq(persist.fighterA.name, "Chuckroast",
    "restored OnHide did not forget lastPair")
  assert_eq(persist.fighterB.name, "Tendermage",
    "restored OnHide did not forget the other fighter")
  assert_eq(persist.health, nil, "restored persist still has no health")
  assert_eq(sounds, 0, "restore Init plays no sound")
  assert_eq(healthReads, 0, "restore Init does not scrape health")

  -- B29-C: Show / Refresh restore a missing OnHide when the frame
  -- already exists. Do not replace an existing script. Do not rebuild.
  -- B28-D Init remount / lastPair / health-nil / Morpheus stay.
  local function runB29C()
    local showBody = src:match("function FighterCard:Show%(%)(.-)\nfunction FighterCard:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "FighterCard:Show body is readable")
    if type(showBody) ~= "string" then showBody = "" end
    local showExists = showBody:match("if not frame then.-end%s*(.+)")
    assert_true(type(showExists) == "string" and showExists ~= "",
      "Show exists-path is readable")
    if type(showExists) ~= "string" then showExists = "" end
    assert_true(showExists:find("wireCardOnHide", 1, true) ~= nil,
      "Show remounts OnHide via wireCardOnHide when the frame exists")
    assert_eq(showExists:find("SetScript", 1, true), nil,
      "Show does not SetScript inline")
    assert_eq(showExists:find("CreateFrame", 1, true), nil,
      "Show does not rebuild")
    assert_eq(showExists:find("PlaySound", 1, true), nil,
      "Show does not PlaySound")
    assert_eq(showExists:find("UnitHealth", 1, true), nil,
      "Show does not read UnitHealth")

    local refreshBody = src:match("function FighterCard:Refresh%(%)(.-)\nfunction FighterCard:Show")
    assert_true(type(refreshBody) == "string" and refreshBody ~= "",
      "FighterCard:Refresh body is readable")
    if type(refreshBody) ~= "string" then refreshBody = "" end
    local refreshExists = refreshBody:match("if not frame then.-end%s*(.+)")
    assert_true(type(refreshExists) == "string" and refreshExists ~= "",
      "Refresh exists-path is readable")
    if type(refreshExists) ~= "string" then refreshExists = "" end
    assert_true(refreshExists:find("wireCardOnHide", 1, true) ~= nil,
      "Refresh remounts OnHide via wireCardOnHide when the frame exists")
    assert_eq(refreshExists:find("SetScript", 1, true), nil,
      "Refresh does not SetScript inline")
    assert_eq(refreshExists:find("CreateFrame", 1, true), nil,
      "Refresh does not rebuild")
    assert_eq(refreshExists:find("PlaySound", 1, true), nil,
      "Refresh does not PlaySound")
    assert_eq(refreshExists:find("UnitHealth", 1, true), nil,
      "Refresh does not read UnitHealth")

    local initBody = src:match("function FighterCard:Init%(%)(.-)\nfunction FighterCard:GetView")
    assert_true(type(initBody) == "string" and initBody ~= "",
      "B28-D Init body stays readable")
    if type(initBody) ~= "string" then initBody = "" end
    assert_true(initBody:find("wireCardOnHide", 1, true) ~= nil,
      "B28-D Init remounts OnHide via wireCardOnHide")
    assert_true(src:find("FontPath", 1, true) ~= nil,
      "names still route through Theme:FontPath")
    assert_eq(src:find("Fonts\\", 1, true), nil,
      "source still does not hardcode a Fonts path")
    assert_eq(src:find("UnitHealth", 1, true), nil,
      "source still does not read UnitHealth")

    sanctionPair()
    assert_eq(FighterCard:Show(), true, "B29-C remount needs a live card")
    local widget = FighterCard:Init()
    assert_true(widget:GetScript("OnHide") ~= nil, "live card has OnHide")
    local savedCreate = CreateFrame
    local createCalls = 0
    CreateFrame = function(...)
      createCalls = createCalls + 1
      return savedCreate(...)
    end
    widget:SetScript("OnHide", nil)
    assert_eq(widget:GetScript("OnHide"), nil, "OnHide niled before Show")
    assert_eq(FighterCard:Show(), true, "niled OnHide Show still paints")
    local afterShow = widget:GetScript("OnHide")
    assert_true(afterShow ~= nil, "Show restores missing OnHide")
    assert_eq(createCalls, 0, "Show does not rebuild")

    widget:SetScript("OnHide", nil)
    assert_eq(widget:GetScript("OnHide"), nil, "OnHide niled before Refresh")
    local persist = FighterCard:Refresh()
    local afterRefresh = widget:GetScript("OnHide")
    assert_true(afterRefresh ~= nil, "Refresh restores missing OnHide")
    assert_eq(persist.shown, true, "Refresh after niled OnHide still paints")
    assert_eq(persist.fighterA.name, "Chuckroast",
      "Refresh remount did not forget lastPair")
    assert_eq(persist.fighterB.name, "Tendermage",
      "Refresh remount did not forget the other fighter")
    assert_eq(persist.health, nil, "Refresh remount still has no health")
    assert_eq(createCalls, 0, "Refresh does not rebuild")

    assert_eq(FighterCard:Show(), true, "third Show with OnHide already set")
    assert_eq(widget:GetScript("OnHide"), afterRefresh,
      "third Show does not replace OnHide")
    assert_eq(createCalls, 0, "third Show does not rebuild")
    CreateFrame = savedCreate

    assert_eq(stub.fire(widget, "OnHide"), true, "Show/Refresh restored OnHide fires")
    assert_eq(FighterCard:GetView().shown, false,
      "restored OnHide sets lastView.shown false")
    assert_true(Gora:GetSanctioned() ~= nil,
      "restored OnHide does not clear the live pair")
    persist = FighterCard:Refresh()
    assert_eq(persist.shown, true, "Refresh after restored OnHide still paints")
    assert_eq(persist.fighterA.name, "Chuckroast",
      "Show/Refresh remount did not forget lastPair")
    assert_eq(persist.health, nil, "Show/Refresh persist still has no health")
    assert_eq(sounds, 0, "Show/Refresh remount plays no sound")
    assert_eq(healthReads, 0, "Show/Refresh remount does not scrape health")
  end
  runB29C()

  -- B30-B: Hide restores a missing OnHide when the frame already
  -- exists. Do not replace an existing script. Do not rebuild.
  -- B28-D Init / B29-C Show/Refresh remount / lastPair / health-nil
  -- / Morpheus stay.
  local function runB30B()
    local hideBody = src:match("function FighterCard:Hide%(%)(.-)\nfunction FighterCard:ResetForTests")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "FighterCard:Hide body is readable")
    if type(hideBody) ~= "string" then hideBody = "" end
    assert_true(hideBody:find("wireCardOnHide", 1, true) ~= nil,
      "Hide remounts OnHide via wireCardOnHide when the frame exists")
    assert_true(hideBody:find("paintHidden", 1, true) ~= nil,
      "Hide still paintHidden")
    assert_eq(hideBody:find("SetScript", 1, true), nil,
      "Hide does not SetScript inline")
    assert_eq(hideBody:find("CreateFrame", 1, true), nil,
      "Hide does not rebuild")
    assert_eq(hideBody:find("PlaySound", 1, true), nil,
      "Hide does not PlaySound")
    assert_eq(hideBody:find("UnitHealth", 1, true), nil,
      "Hide does not read UnitHealth")

    local showBody = src:match("function FighterCard:Show%(%)(.-)\nfunction FighterCard:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "B29-C Show body stays readable")
    if type(showBody) ~= "string" then showBody = "" end
    local showExists = showBody:match("if not frame then.-end%s*(.+)")
    assert_true(type(showExists) == "string" and showExists ~= "",
      "B29-C Show exists-path stays readable")
    if type(showExists) ~= "string" then showExists = "" end
    assert_true(showExists:find("wireCardOnHide", 1, true) ~= nil,
      "B29-C Show remounts OnHide via wireCardOnHide when the frame exists")

    local refreshBody = src:match("function FighterCard:Refresh%(%)(.-)\nfunction FighterCard:Show")
    assert_true(type(refreshBody) == "string" and refreshBody ~= "",
      "B29-C Refresh body stays readable")
    if type(refreshBody) ~= "string" then refreshBody = "" end
    local refreshExists = refreshBody:match("if not frame then.-end%s*(.+)")
    assert_true(type(refreshExists) == "string" and refreshExists ~= "",
      "B29-C Refresh exists-path stays readable")
    if type(refreshExists) ~= "string" then refreshExists = "" end
    assert_true(refreshExists:find("wireCardOnHide", 1, true) ~= nil,
      "B29-C Refresh remounts OnHide via wireCardOnHide when the frame exists")

    local initBody = src:match("function FighterCard:Init%(%)(.-)\nfunction FighterCard:GetView")
    assert_true(type(initBody) == "string" and initBody ~= "",
      "B28-D Init body stays readable")
    if type(initBody) ~= "string" then initBody = "" end
    assert_true(initBody:find("wireCardOnHide", 1, true) ~= nil,
      "B28-D Init remounts OnHide via wireCardOnHide")
    assert_true(src:find("FontPath", 1, true) ~= nil,
      "names still route through Theme:FontPath")
    assert_eq(src:find("Fonts\\", 1, true), nil,
      "source still does not hardcode a Fonts path")
    assert_eq(src:find("UnitHealth", 1, true), nil,
      "source still does not read UnitHealth")

    sanctionPair()
    assert_eq(FighterCard:Show(), true, "B30-B remount needs a live card")
    local widget = FighterCard:Init()
    assert_true(widget:GetScript("OnHide") ~= nil, "live card has OnHide")
    local savedCreate = CreateFrame
    local createCalls = 0
    CreateFrame = function(...)
      createCalls = createCalls + 1
      return savedCreate(...)
    end
    widget:SetScript("OnHide", nil)
    assert_eq(widget:GetScript("OnHide"), nil, "OnHide niled before Hide")
    FighterCard:Hide()
    local afterHide = widget:GetScript("OnHide")
    assert_true(afterHide ~= nil, "Hide restores missing OnHide")
    assert_eq(FighterCard:GetView().shown, false, "Hide still paintHidden")
    assert_eq(createCalls, 0, "Hide does not rebuild")

    FighterCard:Hide()
    assert_eq(widget:GetScript("OnHide"), afterHide,
      "second Hide does not replace OnHide")
    FighterCard:Hide()
    assert_eq(widget:GetScript("OnHide"), afterHide,
      "third Hide does not replace OnHide")
    assert_eq(createCalls, 0, "third Hide does not rebuild")
    CreateFrame = savedCreate

    assert_eq(stub.fire(widget, "OnHide"), true, "Hide restored OnHide fires")
    assert_eq(FighterCard:GetView().shown, false,
      "restored OnHide sets lastView.shown false")
    assert_true(Gora:GetSanctioned() ~= nil,
      "restored OnHide does not clear the live pair")
    local persist = FighterCard:Refresh()
    assert_eq(persist.shown, true, "Refresh after Hide remount still paints")
    assert_eq(persist.fighterA.name, "Chuckroast",
      "Hide remount did not forget lastPair")
    assert_eq(persist.fighterB.name, "Tendermage",
      "Hide remount did not forget the other fighter")
    assert_eq(persist.health, nil, "Hide remount persist still has no health")
    assert_eq(sounds, 0, "Hide remount plays no sound")
    assert_eq(healthReads, 0, "Hide remount does not scrape health")
  end
  runB30B()

  -- B37-C: Hide remounts UISpecialFrames membership when the frame
  -- already exists. rememberSpecial(FRAME_NAME) before existing
  -- OnHide remount + paintHidden(). Do not replace an existing
  -- OnHide. No OnShow re-wire. No rebuild. Isolation wrap stays.
  local function runB37C()
    local hideBody = src:match("function FighterCard:Hide%(%)(.-)\nfunction FighterCard:ResetForTests")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B37-C Hide body is readable")
    if type(hideBody) ~= "string" then hideBody = "" end
    local remAt = hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
    local wireAt = hideBody:find("wireCardOnHide", 1, true)
    local paintAt = hideBody:find("paintHidden", 1, true)
    assert_true(remAt ~= nil, "Hide remounts rememberSpecial FRAME_NAME")
    assert_true(wireAt ~= nil, "Hide remounts via wireCardOnHide")
    assert_true(paintAt ~= nil, "Hide still paintHidden")
    assert_true(type(remAt) == "number" and type(paintAt) == "number" and remAt < paintAt,
      "Hide remounts rememberSpecial before paintHidden")
    assert_true(type(remAt) == "number" and type(wireAt) == "number" and remAt < wireAt,
      "Hide remounts rememberSpecial before OnHide remount")
    assert_true(type(wireAt) == "number" and type(paintAt) == "number" and wireAt < paintAt,
      "Hide remounts OnHide before paintHidden")
    assert_eq(hideBody:find("SetScript", 1, true), nil,
      "Hide does not SetScript inline")
    assert_eq(hideBody:find("OnShow", 1, true), nil,
      "Hide does not re-wire OnShow")
    assert_eq(hideBody:find("CreateFrame", 1, true), nil,
      "Hide does not rebuild")
    assert_eq(hideBody:find("PlaySound", 1, true), nil,
      "Hide does not PlaySound")
    assert_eq(hideBody:find("IG_CHARACTER_INFO", 1, true), nil,
      "Hide does not PlaySound IG_CHARACTER_INFO")
    assert_eq(hideBody:find("UnitHealth", 1, true), nil,
      "Hide does not read UnitHealth")
    assert_eq(hideBody:find("forgetPersist", 1, true), nil,
      "Hide does not forget lastPair")

    local initBody = src:match("function FighterCard:Init%(%)(.-)\nfunction FighterCard:GetView")
    assert_true(type(initBody) == "string" and initBody ~= "",
      "B28-D Init body stays readable")
    if type(initBody) ~= "string" then initBody = "" end
    assert_true(initBody:find("rememberSpecial", 1, true) ~= nil,
      "B28-D Init still rememberSpecial")
    assert_true(initBody:find("wireCardOnHide", 1, true) ~= nil,
      "B28-D Init remounts OnHide via wireCardOnHide")
    assert_true(src:find("FontPath", 1, true) ~= nil,
      "names still route through Theme:FontPath")
    assert_eq(src:find("Fonts\\", 1, true), nil,
      "source still does not hardcode a Fonts path")
    assert_eq(src:find("UnitHealth", 1, true), nil,
      "source still does not read UnitHealth")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")

    sanctionPair()
    assert_eq(FighterCard:Show(), true, "B37-C remount needs a live card")
    local widget = FighterCard:Init()
    assert_eq(widget:GetName(), "ChurchOfBeefFighterCard",
      "B37-C frame name stays ChurchOfBeefFighterCard")
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "live card is listed once before wipe")
    local existingOnHide = widget:GetScript("OnHide")
    assert_true(existingOnHide ~= nil, "OnHide is already wired before Hide special remount")
    local savedSpecial = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 0,
      "B37-C wipe clears ChurchOfBeefFighterCard")
    local cuesHide = sounds
    local savedCreate = CreateFrame
    local createCalls = 0
    CreateFrame = function(...)
      createCalls = createCalls + 1
      return savedCreate(...)
    end
    FighterCard:Hide()
    assert_eq(createCalls, 0, "Hide remount does not rebuild")
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "wiped UISpecialFrames + Hide lists ChurchOfBeefFighterCard once")
    assert_eq(widget:GetScript("OnHide"), existingOnHide,
      "Hide remount does not replace existing OnHide")
    assert_eq(widget:GetScript("OnShow"), nil,
      "Hide remount does not wire OnShow")
    assert_eq(FighterCard:GetView().shown, false, "Hide still paintHidden")
    assert_eq(sounds, cuesHide, "Hide remount plays no sound")
    FighterCard:Hide()
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "second Hide after wipe does not duplicate ChurchOfBeefFighterCard")
    FighterCard:Hide()
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "third Hide does not duplicate ChurchOfBeefFighterCard")
    assert_eq(widget:GetScript("OnHide"), existingOnHide,
      "third Hide keeps OnHide identity")
    assert_eq(createCalls, 0, "third Hide does not rebuild")
    CreateFrame = savedCreate
    UISpecialFrames = savedSpecial

    assert_true(Gora:GetSanctioned() ~= nil,
      "Hide special remount does not clear the live pair")
    local persist = FighterCard:Refresh()
    assert_eq(persist.shown, true, "Refresh after Hide special remount still paints")
    assert_eq(persist.fighterA.name, "Chuckroast",
      "Hide special remount did not forget lastPair")
    assert_eq(persist.fighterB.name, "Tendermage",
      "Hide special remount did not forget the other fighter")
    assert_eq(persist.health, nil, "Hide special remount persist still has no health")
    assert_eq(sounds, 0, "Hide special remount plays no sound")
    assert_eq(healthReads, 0, "Hide special remount does not scrape health")
  end
  runB37C()

  -- B39-B: Show / Refresh remount UISpecialFrames membership when
  -- the frame already exists. rememberSpecial(FRAME_NAME) and keep
  -- wireCardOnHide. Do not reset lastPair. No OnShow re-wire.
  -- No rebuild. Isolation wrap stays.
  local function runB39B()
    local showBody = src:match("function FighterCard:Show%(%)(.-)\nfunction FighterCard:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "B39-B Show body is readable")
    if type(showBody) ~= "string" then showBody = "" end
    local showExists = showBody:match("if not frame then.-end%s*(.+)")
    assert_true(type(showExists) == "string" and showExists ~= "",
      "B39-B Show exists-path is readable")
    if type(showExists) ~= "string" then showExists = "" end
    local remShow = showExists:find("rememberSpecial(FRAME_NAME)", 1, true)
    local wireShow = showExists:find("wireCardOnHide", 1, true)
    assert_true(remShow ~= nil, "Show remounts rememberSpecial FRAME_NAME")
    assert_true(wireShow ~= nil, "Show still remounts via wireCardOnHide")
    assert_true(type(remShow) == "number" and type(wireShow) == "number" and remShow < wireShow,
      "Show remounts rememberSpecial before OnHide remount")
    assert_eq(showExists:find("SetScript", 1, true), nil,
      "Show does not SetScript inline")
    assert_eq(showExists:find("OnShow", 1, true), nil,
      "Show does not re-wire OnShow")
    assert_eq(showExists:find("CreateFrame", 1, true), nil,
      "Show does not rebuild")
    assert_eq(showExists:find("PlaySound", 1, true), nil,
      "Show does not PlaySound")
    assert_eq(showExists:find("IG_CHARACTER_INFO", 1, true), nil,
      "Show does not PlaySound IG_CHARACTER_INFO")
    assert_eq(showExists:find("UnitHealth", 1, true), nil,
      "Show does not read UnitHealth")

    local refreshBody = src:match("function FighterCard:Refresh%(%)(.-)\nfunction FighterCard:Show")
    assert_true(type(refreshBody) == "string" and refreshBody ~= "",
      "B39-B Refresh body is readable")
    if type(refreshBody) ~= "string" then refreshBody = "" end
    local refreshExists = refreshBody:match("if not frame then.-end%s*(.+)")
    assert_true(type(refreshExists) == "string" and refreshExists ~= "",
      "B39-B Refresh exists-path is readable")
    if type(refreshExists) ~= "string" then refreshExists = "" end
    local remRefresh = refreshExists:find("rememberSpecial(FRAME_NAME)", 1, true)
    local wireRefresh = refreshExists:find("wireCardOnHide", 1, true)
    assert_true(remRefresh ~= nil, "Refresh remounts rememberSpecial FRAME_NAME")
    assert_true(wireRefresh ~= nil, "Refresh still remounts via wireCardOnHide")
    assert_true(type(remRefresh) == "number" and type(wireRefresh) == "number" and remRefresh < wireRefresh,
      "Refresh remounts rememberSpecial before OnHide remount")
    assert_eq(refreshExists:find("SetScript", 1, true), nil,
      "Refresh does not SetScript inline")
    assert_eq(refreshExists:find("OnShow", 1, true), nil,
      "Refresh does not re-wire OnShow")
    assert_eq(refreshExists:find("CreateFrame", 1, true), nil,
      "Refresh does not rebuild")
    assert_eq(refreshExists:find("PlaySound", 1, true), nil,
      "Refresh does not PlaySound")
    assert_eq(refreshExists:find("IG_CHARACTER_INFO", 1, true), nil,
      "Refresh does not PlaySound IG_CHARACTER_INFO")
    assert_eq(refreshExists:find("UnitHealth", 1, true), nil,
      "Refresh does not read UnitHealth")

    local hideBody = src:match("function FighterCard:Hide%(%)(.-)\nfunction FighterCard:ResetForTests")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B37-C Hide body stays readable")
    if type(hideBody) ~= "string" then hideBody = "" end
    assert_true(hideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B37-C Hide still remounts rememberSpecial FRAME_NAME")
    assert_true(hideBody:find("wireCardOnHide", 1, true) ~= nil,
      "B37-C Hide still remounts via wireCardOnHide")

    local initBody = src:match("function FighterCard:Init%(%)(.-)\nfunction FighterCard:GetView")
    assert_true(type(initBody) == "string" and initBody ~= "",
      "B28-D Init body stays readable")
    if type(initBody) ~= "string" then initBody = "" end
    assert_true(initBody:find("rememberSpecial", 1, true) ~= nil,
      "B28-D Init still rememberSpecial")
    assert_true(initBody:find("wireCardOnHide", 1, true) ~= nil,
      "B28-D Init remounts OnHide via wireCardOnHide")
    assert_true(src:find("FontPath", 1, true) ~= nil,
      "names still route through Theme:FontPath")
    assert_eq(src:find("Fonts\\", 1, true), nil,
      "source still does not hardcode a Fonts path")
    assert_eq(src:find("UnitHealth", 1, true), nil,
      "source still does not read UnitHealth")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")

    sanctionPair()
    assert_eq(FighterCard:Show(), true, "B39-B remount needs a live card")
    local widget = FighterCard:Init()
    assert_eq(widget:GetName(), "ChurchOfBeefFighterCard",
      "B39-B frame name stays ChurchOfBeefFighterCard")
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "live card is listed once before wipe")
    local existingOnHide = widget:GetScript("OnHide")
    assert_true(existingOnHide ~= nil, "OnHide is already wired before Show special remount")
    local savedSpecial = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 0,
      "B39-B wipe clears ChurchOfBeefFighterCard before Show")
    local cuesShow = sounds
    local savedCreate = CreateFrame
    local createCalls = 0
    CreateFrame = function(...)
      createCalls = createCalls + 1
      return savedCreate(...)
    end
    assert_eq(FighterCard:Show(), true, "wiped list Show still paints")
    assert_eq(createCalls, 0, "Show remount does not rebuild")
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "wiped UISpecialFrames + Show lists ChurchOfBeefFighterCard once")
    assert_eq(widget:GetScript("OnHide"), existingOnHide,
      "Show remount does not replace existing OnHide")
    assert_eq(widget:GetScript("OnShow"), nil,
      "Show remount does not wire OnShow")
    assert_eq(sounds, cuesShow, "Show remount plays no sound")

    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 0,
      "B39-B second wipe clears ChurchOfBeefFighterCard before Refresh")
    local persist = FighterCard:Refresh()
    assert_eq(createCalls, 0, "Refresh remount does not rebuild")
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "wiped UISpecialFrames + Refresh lists ChurchOfBeefFighterCard once")
    assert_eq(widget:GetScript("OnHide"), existingOnHide,
      "Refresh remount does not replace existing OnHide")
    assert_eq(widget:GetScript("OnShow"), nil,
      "Refresh remount does not wire OnShow")
    assert_eq(persist.shown, true, "Refresh after wipe still paints")
    assert_eq(persist.fighterA.name, "Chuckroast",
      "Show/Refresh special remount did not forget lastPair")
    assert_eq(persist.fighterB.name, "Tendermage",
      "Show/Refresh special remount did not forget the other fighter")
    assert_eq(persist.health, nil, "Show/Refresh special remount persist still has no health")

    assert_eq(FighterCard:Show(), true, "second Show after remount still paints")
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "second Show after wipe does not duplicate ChurchOfBeefFighterCard")
    persist = FighterCard:Refresh()
    assert_eq(countSpecial("ChurchOfBeefFighterCard"), 1,
      "third Refresh does not duplicate ChurchOfBeefFighterCard")
    assert_eq(widget:GetScript("OnHide"), existingOnHide,
      "third Refresh keeps OnHide identity")
    assert_eq(createCalls, 0, "third Refresh does not rebuild")
    CreateFrame = savedCreate
    UISpecialFrames = savedSpecial

    assert_true(Gora:GetSanctioned() ~= nil,
      "Show/Refresh special remount does not clear the live pair")
    persist = FighterCard:Refresh()
    assert_eq(persist.shown, true, "Refresh after Show/Refresh special remount still paints")
    assert_eq(persist.fighterA.name, "Chuckroast",
      "Show/Refresh special remount still remembers lastPair")
    assert_eq(persist.fighterB.name, "Tendermage",
      "Show/Refresh special remount still remembers the other fighter")
    assert_eq(persist.health, nil, "Show/Refresh special remount health stays nil")
    assert_eq(sounds, 0, "Show/Refresh special remount plays no sound")
    assert_eq(healthReads, 0, "Show/Refresh special remount does not scrape health")
    if standalone then
      assert_eq(COB.Hud, nil, "isolation still does not load Hud")
      assert_eq(COB.UI, nil, "isolation still does not load the Quiet shell")
      assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
    end
  end
  runB39B()
end
runB28D()

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
