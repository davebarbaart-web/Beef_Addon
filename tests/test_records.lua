-- Records Book superlatives (Phase 4 Lane G). Isolated: wow_ui_stub + Common + Theme + Ranks + Store + RecordsBook.
-- Player-opened Quiet identity/history. Theatrical parchment, not a sortable ladder.
-- B25-C Init early-return rememberSpecial lives in runB25C() (Lua 5.1 200-local cap).
-- B28-C Hide remount rememberSpecial lives in runB28C() nested in runB25C().
-- B30-C paint() re-applies Theme label font on PageTitle lives in runB30C() nested in runB25C().
-- B31-D paint() re-applies Theme label font on TitleText lives in runB31D() nested in runB25C().
-- B38-D Hide remounts missing OnHide lives in runB38D() nested in runB25C().
-- B40-B Show remounts missing OnHide lives in runB40B() nested in runB25C().
-- B41-B Init remounts missing OnHide lives in runB41B() nested in runB25C().
-- U-H tome dress (Theme fonts/textures/colors, Common roman wrapper, medallion slots) lives in runUH().
-- No TOC / bootstrap / run.lua / MainFrame / Console / Hud / Store / Net edits. No slash.
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
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/UI/RecordsBook.lua")

local COB = ChurchOfBeef
local Store = COB.Store
local Book = COB.RecordsBook

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

local BIBLE_TITLES = {
  "Most Sanctioned Victories",
  "Longest Streak",
  "Most Successful Defenses",
  "The Iron Chin",
  "Greatest Rivalry",
  "Famous Upsets",
  "The Undefeated",
  "The Glorious Martyr",
  "Tournament Champions",
}

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  if Book.ResetForTests then
    assert_eq(Book:ResetForTests(), true, "RecordsBook ResetForTests runs under _IN_TEST")
  end
  sounds = 0
end

local function char(name, class)
  return Store:CreateCharacter({ name = name, class = class })
end

-- Both combatants receive the Pope's ruling. Store writes are per-character.
local function bout(a, b, winner, now, fields)
  fields = fields or {}
  local ruling = fields.ruling or "victor"
  local flag = fields.famousUpset == true
  if ruling == "void" then
    Store:RecordGoraResult(a.id, { opponentId = b.id, ruling = "void", famousUpset = flag }, now)
    Store:RecordGoraResult(b.id, { opponentId = a.id, ruling = "void", famousUpset = flag }, now)
    return
  end
  Store:RecordGoraResult(a.id, {
    opponentId = b.id,
    ruling = ruling,
    won = (winner == a),
    famousUpset = flag and winner == a,
  }, now)
  Store:RecordGoraResult(b.id, {
    opponentId = a.id,
    ruling = ruling,
    won = (winner == b),
    famousUpset = flag and winner == b,
  }, now)
end

local function pageNamed(title)
  local pages = Book:GetPages()
  for i = 1, #pages do
    if pages[i].title == title then return pages[i], i end
  end
  return nil
end

local function namesOn(title)
  local page = pageNamed(title)
  local names = {}
  if not page then return names end
  for i = 1, #page.entries do
    local e = page.entries[i]
    names[#names + 1] = e.name or e.nameA
  end
  return names
end

local function hasName(title, name)
  local names = namesOn(title)
  for i = 1, #names do
    if names[i] == name then return true end
  end
  return false
end

local function buttonFor(label)
  local frame = Book.frame
  if not frame then return nil end
  return stub.findChild(frame, function(child)
    return child._type == "Button" and child:GetText() == label
  end)
end

--------------------------------------------------------------------------------
-- Isolated surface: stub + Common + Ranks + Store + RecordsBook.
--------------------------------------------------------------------------------
assert_true(Book ~= nil, "COB.RecordsBook exists")
assert_true(Store ~= nil, "isolated suite loads Store")
assert_true(COB.Ranks ~= nil, "isolated suite loads Ranks")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_true(COB.Theme ~= nil, "Theme is loaded for tome dress")
assert_true(COB.Common ~= nil and type(COB.Common.RomanNumeral) == "function",
  "Common.RomanNumeral is loaded")
assert_eq(Book.MODE, "QUIET", "Records Book declares Quiet Mode (player-opened identity/history)")
assert_eq(Book.Grant, nil, "no Grant")
assert_eq(Book.Standing, nil, "no Standing")
assert_eq(Book.ComputeFamousUpsets, nil, "Famous Upsets are never computed")
assert_eq(Book.RecordDefense, nil, "no defense increment")
assert_eq(Book.AddTournamentChampion, nil, "no tournament engine")
assert_eq(Book.SortPages, nil, "pages are not a sortable ladder")
assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "this file does not register a slash")
assert_eq(type(SLASH_RECORDSBOOK1), "nil", "no Records Book slash")

if standalone then
  assert_true(COB.Theme ~= nil, "isolated suite loads Theme")
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.UI, nil, "isolated suite does not load MainFrame")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
end

--------------------------------------------------------------------------------
-- Source contract: Theme dress only. No Media/font/texture paths. No generated prose.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/RecordsBook.lua", "r")
assert_true(srcFile ~= nil, "UI/RecordsBook.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("Media\\", 1, true), nil, "no required Media path")
assert_eq(src:find("Interface\\", 1, true), nil, "no hardcoded Interface texture path")
assert_eq(src:find("Fonts\\", 1, true), nil, "no hardcoded font path")
assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil, "PAGE_TITLE_FONT local is gone")
assert_eq(src:find("FALLBACK_TITLE_FONT", 1, true), nil, "FALLBACK_TITLE_FONT local is gone")
assert_eq(src:find("ROMAN_MAP", 1, true), nil, "local ROMAN_MAP is gone")
assert_eq(src:find("PARCHMENT_TEXTURE", 1, true), nil, "PARCHMENT_TEXTURE local is gone")
assert_eq(src:find("SEAL_TEXTURE", 1, true), nil, "SEAL_TEXTURE local is gone")
assert_eq(src:find("ordained", 1, true), nil, "source does not generate 'ordained' prose")
assert_eq(src:find("folk hero", 1, true), nil, "source does not generate 'folk hero' prose")
assert_eq(src:find("This is not hatred", 1, true), nil, "source does not generate that sermon")
assert_eq(src:find("on this day", 1, true), nil, "source does not narrate marked moments")
assert_eq(src:find("unrecognized", 1, true), nil, "source does not invent a missing-bind label")
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find("SLASH_", 1, true), nil, "source does not register a slash")
assert_eq(src:find("AddHonorific", 1, true), nil, "the book does not grant honorifics")
assert_eq(src:find("FlagMoment", 1, true), nil, "the book does not mark moments")
assert_eq(src:find("CanonizeMoment", 1, true), nil, "the book does not canonize")
assert_true(src:find("scripture", 1, true) ~= nil, "right leaf reads moment.scripture")
assert_true(src:find("CountDefenses", 1, true) ~= nil, "page prefers Store:CountDefenses")
assert_true(src:find('Theme:FontPath', 1, true) ~= nil, "fonts resolve through Theme:FontPath")
assert_true(src:find('Theme:Color', 1, true) ~= nil, "colors resolve through Theme:Color")
assert_true(src:find('Theme:Texture', 1, true) ~= nil, "textures resolve through Theme:Texture")
assert_true(src:find('"tome_records"', 1, true) ~= nil, "parchment uses Theme tome_records")
assert_true(src:find('"ribbon_bookmark"', 1, true) ~= nil, "ribbons use Theme ribbon_bookmark")
assert_true(src:find('"seal_papal"', 1, true) ~= nil, "medallions use Theme seal_papal")
assert_true(src:find("RomanNumeral", 1, true) ~= nil, "toRoman adopts Common.RomanNumeral")
assert_eq(src:find("MORPHEUS", 1, true), nil, "source does not hardcode MORPHEUS")
assert_eq(src:find("FRIZQT", 1, true), nil, "source does not hardcode FRIZQT")
assert_eq(src:find("MORPHEUS_CYR", 1, true), nil, "source does not use GlueFonts MORPHEUS_CYR")
assert_eq(src:find("QuestBG", 1, true), nil, "parchment is not a hardcoded QuestBG path")
assert_true(src:find("SetFontObject", 1, true) ~= nil, "applyFont still falls back to GameFont")
assert_true(src:find("EnableMouseWheel", 1, true) ~= nil, "source contains EnableMouseWheel")
assert_true(src:find('type(frame.EnableMouseWheel) == "function"', 1, true) ~= nil,
  "EnableMouseWheel is type-guarded")
assert_true(src:find('SetScript("OnMouseWheel"', 1, true) ~= nil,
  "source wires OnMouseWheel")
assert_eq(src:find("0.42, 0.12, 0.10", 1, true), nil, "page title oxblood is not a color literal")
assert_eq(src:find("0.45, 0.32, 0.12", 1, true), nil, "title brown is not a color literal")
assert_eq(src:find("0.18, 0.12, 0.08", 1, true), nil, "body ink is not a color literal")
assert_eq(src:find("0.72, 0.62, 0.38", 1, true), nil, "gold rule is not a color literal")
assert_eq(src:find("0.08, 0.07, 0.06", 1, true), nil, "iron field is not a color literal")

--------------------------------------------------------------------------------
-- Init: hidden parchment tome. No auto-open. No sound. No OnUpdate.
--------------------------------------------------------------------------------
reset()
assert_eq(Book:IsShown(), false, "the book is closed before Init")
local frame = Book:Init()
assert_true(frame ~= nil, "Init creates the frame")
assert_eq(frame:GetName(), "ChurchOfBeefRecordsBook", "frame has a global name for UISpecialFrames")
assert_eq(Book:Init(), frame, "Init is idempotent")
assert_eq(Book:IsShown(), false, "Init does not open the book")
assert_eq(frame:IsShown(), false, "the widget starts hidden")
assert_eq(frame._template, nil, "theatrical tome is not BasicFrameTemplate")
assert_eq(frame._movable, true, "the book is movable")
assert_eq(frame._clamped, true, "the book is clamped to screen")
assert_eq(frame:GetScript("OnUpdate"), nil, "no permanent OnUpdate")
assert_eq(sounds, 0, "Init plays no sound")
assert_true(frame.Iron ~= nil, "dark-iron field exists")
assert_true(frame.Parchment ~= nil, "parchment leaf exists")
assert_true(frame.RightLeaf ~= nil, "right leaf exists")
assert_true(frame.Honorifics ~= nil, "right-leaf honorifics FontString exists")
assert_true(frame.Moments ~= nil, "right-leaf moments FontString exists")
assert_true(frame.GoldEdge ~= nil, "muted-gold edge exists")
assert_true(frame.TitleText ~= nil, "title FontString exists")
assert_eq(frame.TitleText:GetText(), "The Records Book", "chrome title is the Bible name")
assert_true(frame.PageTitle ~= nil, "page title FontString exists")
assert_true(frame.Body ~= nil, "body FontString exists")
assert_true(frame.TitleText._template ~= nil, "title uses a GameFont* fallback template")
assert_true(frame.Medallion ~= nil, "medallion slot exists")
assert_true(type(frame.Medallions) == "table", "medallion pool is a table")
assert_eq(#frame.Medallions, 8, "medallion pool is a fixed slot count")
assert_eq(frame.Medallion, frame.Medallions[1], "Medallion aliases the first pool slot")
assert_eq(frame.Medallion:IsShown(), false, "medallion slots start hidden")
assert_eq(frame.Medallion._cobTextureName, "seal_papal", "medallion slot is Theme seal_papal")
assert_eq(frame.Medallion._cobTexture, COB.Theme:Texture("seal_papal"), "medallion path is Theme seal_papal")
assert_eq(frame.Parchment._cobTextureName, "tome_records", "left leaf is Theme tome_records")
assert_eq(frame.RightLeaf._cobTextureName, "tome_records", "right leaf is Theme tome_records")
assert_eq(frame.Parchment._cobTexture, COB.Theme:Texture("tome_records"), "left leaf path is Theme tome_records")
assert_eq(frame.Seal._cobTextureName, "seal_papal", "book seal is Theme seal_papal")
assert_eq(frame.Iron._cobColorRole, "iron", "iron field uses Theme iron")
assert_eq(frame.GoldEdge._cobColorRole, "gold", "gold edge uses Theme gold")
assert_eq(frame.Gutter._cobColorRole, "gold", "gutter uses Theme gold")
assert_eq(frame.TitleRule._cobColorRole, "gold", "title rule uses Theme gold")
assert_eq(frame.Iron._cobColor.r, select(1, COB.Theme:Color("iron")), "iron r is Theme iron")
assert_eq(frame.GoldEdge._cobColor.r, select(1, COB.Theme:Color("gold")), "gold edge r is Theme gold")
assert_eq(frame.TitleText._cobFontRole, "label", "chrome title uses Theme label role")
assert_eq(frame.PageTitle._cobFontRole, "label", "page title uses Theme label role")
assert_eq(frame.PageTitle._cobColorRole, "oxblood", "page title uses Theme oxblood")
assert_eq(frame.PageTitle._cobColor.r, select(1, COB.Theme:Color("oxblood")), "page title r is Theme oxblood")
assert_eq(frame.Body._cobFontRole, "body", "body uses Theme body role")
assert_eq(frame.Body._cobColorRole, "charcoal", "body ink uses Theme charcoal")
assert_eq(frame.Body._cobColor.r, select(1, COB.Theme:Color("charcoal")), "body r is Theme charcoal")
assert_eq(frame.Honorifics._cobFontRole, "label", "honorifics use Theme label role")
assert_eq(frame.Moments._cobFontRole, "body", "moments use Theme body role")
assert_eq(frame.TitleText._cobFontPath, COB.Theme:FontPath("label"), "chrome title path is Theme label")
assert_eq(frame.Body._cobFontPath, COB.Theme:FontPath("body"), "body path is Theme body")
assert_eq(frame.VictoriesRibbon._cobTextureName, "ribbon_bookmark", "Victories ribbon is Theme ribbon_bookmark")
assert_eq(frame.RivalriesRibbon._cobTextureName, "ribbon_bookmark", "Rivalries ribbon is Theme ribbon_bookmark")
assert_eq(frame.MartyrsRibbon._cobTextureName, "ribbon_bookmark", "Martyrs ribbon is Theme ribbon_bookmark")
assert_eq(frame.VictoriesRibbon._cobTexture, COB.Theme:Texture("ribbon_bookmark"),
  "Victories ribbon path is Theme ribbon_bookmark")
assert_eq(frame:GetHeight(), 480, "unknown UIParent height caps the tome near 480")
assert_eq(buttonFor("Search"), nil, "no search box chrome")
assert_eq(stub.findChild(frame, function(child)
  return child._type == "EditBox"
end), nil, "no search EditBox")
assert_true(UISpecialFrames[1] == "ChurchOfBeefRecordsBook" or (function()
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == "ChurchOfBeefRecordsBook" then return true end
  end
  return false
end)(), "Escape can close the book")

-- B25-C: Init early-return re-registers ChurchOfBeefRecordsBook after a
-- wiped UISpecialFrames. Do not rebuild. Wheel / roman / PAGE_TITLES==9 /
-- Morpheus stay. First-create uniqueness pin stays. Isolation wrap stays.
local function runB25C()
  local function countSpecial(name)
    local n = 0
    if type(UISpecialFrames) ~= "table" then return 0 end
    for i = 1, #UISpecialFrames do
      if UISpecialFrames[i] == name then n = n + 1 end
    end
    return n
  end

  local earlyInit = src:match("function RecordsBook:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
  assert_true(type(earlyInit) == "string" and earlyInit ~= "",
    "Init early-return body is readable")
  assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "early-return rememberSpecial FRAME_NAME")
  assert_eq(earlyInit:find("buildFrame", 1, true), nil,
    "early-return does not rebuild")
  assert_eq(earlyInit:find("PlaySound", 1, true), nil,
    "early-return does not PlaySound")
  assert_eq(src:find("PlaySound", 1, true), nil,
    "source still does not play sound")
  assert_true(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "buildFrame still rememberSpecial FRAME_NAME")
  assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil,
    "PAGE_TITLE_FONT local stays gone")
  assert_true(src:find('applyFont(pageTitle, "GameFontNormalLarge", "label", 18)', 1, true) ~= nil,
    "page titles stay Theme label role")
  assert_eq(src:find("MORPHEUS", 1, true), nil,
    "page titles still do not hardcode MORPHEUS")
  assert_true(src:find("EnableMouseWheel", 1, true) ~= nil,
    "wheel EnableMouseWheel stays")
  assert_eq(type(Book.toRoman), "function", "toRoman stays a public helper")
  if type(Book.toRoman) == "function" then
    assert_eq(Book.toRoman(14), "XIV", "roman tallies stay XIV")
  end
  assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
  assert_eq(#Book:GetPages(), 9, "PAGE_TITLES stay 9")

  Book:Init()
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "first-create uniqueness: ChurchOfBeefRecordsBook once before wipe")
  local existing = Book.frame
  local savedSpecial = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 0,
    "wipe clears ChurchOfBeefRecordsBook")
  local cuesWipe = sounds
  local same = Book:Init()
  assert_eq(same, existing, "second Init returns the existing frame")
  assert_eq(Book.frame, existing, "early-return does not rebuild")
  assert_eq(same:GetName(), "ChurchOfBeefRecordsBook",
    "second Init keeps the named frame")
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "wiped UISpecialFrames + second Init lists ChurchOfBeefRecordsBook once")
  assert_eq(sounds, cuesWipe, "second Init plays no sound")
  Book:Init()
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "third Init after wipe does not duplicate ChurchOfBeefRecordsBook")
  assert_eq(Book.frame, existing, "third Init still does not rebuild")
  assert_eq(#Book:GetPages(), 9, "wipe remount is not a tenth page")
  UISpecialFrames = savedSpecial

  -- B28-C: Hide remounts ChurchOfBeefRecordsBook after a wiped
  -- UISpecialFrames. Do not rebuild. Toggle-while-shown is Hide.
  -- PAGE_TITLES==9 / Morpheus / B25-C Init remount stay.
  local function runB28C()
    local hideBody = src:match("function RecordsBook:Hide%(%)(.-)function RecordsBook:Toggle")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "Hide body is readable")
    local remountAt = hideBody and hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
    local hideAt = hideBody and hideBody:find("self.frame:Hide()", 1, true)
    assert_true(remountAt ~= nil and hideAt ~= nil and remountAt < hideAt,
      "Hide remounts rememberSpecial FRAME_NAME before Hide")
    assert_eq(hideBody:find("buildFrame", 1, true), nil,
      "Hide does not rebuild")
    assert_eq(hideBody:find("CreateFrame", 1, true), nil,
      "Hide does not CreateFrame")
    assert_eq(hideBody:find("PlaySound", 1, true), nil,
      "Hide does not PlaySound")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")

    local earlyInit = src:match("function RecordsBook:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
    assert_true(type(earlyInit) == "string" and earlyInit ~= "",
      "B25-C Init early-return body stays readable")
    assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B25-C early-return rememberSpecial FRAME_NAME stays")
    assert_eq(earlyInit:find("buildFrame", 1, true), nil,
      "B25-C early-return still does not rebuild")

    assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil,
      "PAGE_TITLE_FONT local stays gone")
    assert_true(src:find('applyFont(pageTitle, "GameFontNormalLarge", "label", 18)', 1, true) ~= nil,
      "page titles stay Theme label role")
    assert_eq(src:find("MORPHEUS", 1, true), nil,
      "page titles still do not hardcode MORPHEUS")
    assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
    assert_eq(#Book:GetPages(), 9, "PAGE_TITLES stay 9")

    Book:Init()
    local existingHide = Book.frame
    assert_true(existingHide ~= nil, "B28-C Init so the frame exists")
    assert_eq(existingHide:GetName(), "ChurchOfBeefRecordsBook",
      "B28-C frame name stays ChurchOfBeefRecordsBook")
    local savedHide = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 0,
      "B28-C wipe clears ChurchOfBeefRecordsBook")
    local cuesHide = sounds
    assert_eq(Book:Hide(), true, "B28-C Hide succeeds")
    assert_eq(Book.frame, existingHide, "B28-C Hide does not rebuild")
    assert_eq(existingHide:GetName(), "ChurchOfBeefRecordsBook",
      "B28-C Hide keeps the named frame")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "wiped UISpecialFrames + Hide lists ChurchOfBeefRecordsBook once")
    assert_eq(sounds, cuesHide, "B28-C Hide plays no sound")
    Book:Hide()
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "second Hide after wipe does not duplicate ChurchOfBeefRecordsBook")
    assert_eq(Book.frame, existingHide, "second Hide still does not rebuild")
    assert_eq(#Book:GetPages(), 9, "Hide remount is not a tenth page")

    Book:Show()
    assert_eq(Book:IsShown(), true, "B28-C Show opens for Toggle")
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 0,
      "B28-C Toggle wipe clears ChurchOfBeefRecordsBook")
    assert_eq(Book:Toggle(), true, "B28-C Toggle-while-shown succeeds")
    assert_eq(Book:IsShown(), false, "B28-C Toggle-while-shown hides")
    assert_eq(Book.frame, existingHide, "B28-C Toggle-while-shown does not rebuild")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "wiped UISpecialFrames + Toggle-while-shown lists ChurchOfBeefRecordsBook once")
    assert_eq(sounds, cuesHide, "B28-C Toggle-while-shown plays no sound")

    UISpecialFrames = {}
    local remounted = Book:Init()
    assert_eq(remounted, existingHide, "B25-C Init remount still same frame")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "B25-C wiped UISpecialFrames + Init still lists ChurchOfBeefRecordsBook once")
    UISpecialFrames = savedHide
  end
  runB28C()

  -- B30-C: paint() re-applies PAGE_TITLE_FONT on PageTitle when the
  -- leaf turns. TitleText paint is B31-D. PAGE_TITLES==9 /
  -- Hide remount / wheel / Morpheus create-path stay.
  local function runB30C()
    local paintAt = src:find("local function paint()", 1, true)
    assert_true(paintAt ~= nil, "paint exists")
    local paintEnd = src:find("\nlocal function turn(", paintAt + 1, true)
    assert_true(paintEnd ~= nil, "paint body has a following turn")
    local paintBody = src:sub(paintAt, paintEnd - 1)
    local applyAt = paintBody:find(
      'applyFont(frame.PageTitle, "GameFontNormalLarge", "label", 18)',
      1, true)
    local setAt = paintBody:find("frame.PageTitle:SetText", 1, true)
    assert_true(applyAt ~= nil and setAt ~= nil and applyAt < setAt,
      "paint re-applies PAGE_TITLE_FONT on PageTitle before SetText")
    assert_eq(paintBody:find("PlaySound", 1, true), nil,
      "paint does not PlaySound")

    assert_true(src:find(
      'applyFont(pageTitle, "GameFontNormalLarge", "label", 18)',
      1, true) ~= nil,
      "buildFrame still applies PAGE_TITLE_FONT on create")
    assert_true(src:find(
      'applyFont(title, "GameFontNormalHuge", "label", 20)',
      1, true) ~= nil,
      "TitleText stays create-only Morpheus")
    assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil,
      "PAGE_TITLE_FONT local stays gone")
    assert_true(src:find('applyFont(pageTitle, "GameFontNormalLarge", "label", 18)', 1, true) ~= nil,
      "page titles stay Theme label role")
    assert_eq(src:find("MORPHEUS", 1, true), nil,
      "page titles still do not hardcode MORPHEUS")
    assert_eq(src:find("MORPHEUS_CYR", 1, true), nil,
      "source does not use GlueFonts MORPHEUS_CYR")
    assert_eq(src:find("FRIZQT", 1, true), nil,
      "applyFont does not hardcode FRIZQT")
    assert_true(src:find("SetFontObject", 1, true) ~= nil,
      "applyFont still falls back to GameFont")
    assert_true(src:find("EnableMouseWheel", 1, true) ~= nil,
      "wheel EnableMouseWheel stays")
    assert_true(src:find('SetScript("OnMouseWheel"', 1, true) ~= nil,
      "wheel OnMouseWheel stays")

    local hideBody = src:match("function RecordsBook:Hide%(%)(.-)function RecordsBook:Toggle")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B28-C Hide body stays readable")
    local remountAt = hideBody and hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
    local hideAt = hideBody and hideBody:find("self.frame:Hide()", 1, true)
    assert_true(remountAt ~= nil and hideAt ~= nil and remountAt < hideAt,
      "B28-C Hide remount rememberSpecial FRAME_NAME stays")

    assert_eq(type(Book.toRoman), "function", "toRoman stays a public helper")
    if type(Book.toRoman) == "function" then
      assert_eq(Book.toRoman(14), "XIV", "roman tallies stay XIV")
    end
    assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
    assert_eq(#Book:GetPages(), 9, "PAGE_TITLES stay 9")
    Book:Show()
    assert_eq(Book.frame.PageTitle:GetText(), "Most Sanctioned Victories",
      "first leaf title is unchanged")
    assert_eq(Book.frame.TitleText:GetText(), "The Records Book",
      "chrome title stays The Records Book")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
  end
  runB30C()

  -- B31-D: paint() re-applies PAGE_TITLE_FONT on TitleText when
  -- paint runs. PageTitle apply stays. Chrome title copy stays
  -- "The Records Book". PAGE_TITLES==9 / Hide remount / wheel stay.
  local function runB31D()
    local paintAt = src:find("local function paint()", 1, true)
    assert_true(paintAt ~= nil, "paint exists")
    local paintEnd = src:find("\nlocal function turn(", paintAt + 1, true)
    assert_true(paintEnd ~= nil, "paint body has a following turn")
    local paintBody = src:sub(paintAt, paintEnd - 1)
    local titleApplyAt = paintBody:find(
      'applyFont(frame.TitleText, "GameFontNormalHuge", "label", 20)',
      1, true)
    assert_true(titleApplyAt ~= nil,
      "paint re-applies PAGE_TITLE_FONT on TitleText")
    local pageApplyAt = paintBody:find(
      'applyFont(frame.PageTitle, "GameFontNormalLarge", "label", 18)',
      1, true)
    local setAt = paintBody:find("frame.PageTitle:SetText", 1, true)
    assert_true(pageApplyAt ~= nil and setAt ~= nil and pageApplyAt < setAt,
      "paint still re-applies PAGE_TITLE_FONT on PageTitle before SetText")
    assert_eq(paintBody:find("frame.TitleText:SetText", 1, true), nil,
      "paint does not rewrite the chrome title string")
    assert_eq(paintBody:find("PlaySound", 1, true), nil,
      "paint does not PlaySound")

    assert_true(src:find('title:SetText("The Records Book")', 1, true) ~= nil,
      "chrome title string stays The Records Book")
    assert_true(src:find(
      'applyFont(title, "GameFontNormalHuge", "label", 20)',
      1, true) ~= nil,
      "buildFrame still applies TitleText Morpheus")
    assert_true(src:find(
      'applyFont(pageTitle, "GameFontNormalLarge", "label", 18)',
      1, true) ~= nil,
      "buildFrame still applies PAGE_TITLE_FONT on create")
    assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil,
      "PAGE_TITLE_FONT local stays gone")
    assert_true(src:find('applyFont(pageTitle, "GameFontNormalLarge", "label", 18)', 1, true) ~= nil,
      "page titles stay Theme label role")
    assert_eq(src:find("MORPHEUS", 1, true), nil,
      "page titles still do not hardcode MORPHEUS")
    assert_eq(src:find("MORPHEUS_CYR", 1, true), nil,
      "source does not use GlueFonts MORPHEUS_CYR")
    assert_eq(src:find("FRIZQT", 1, true), nil,
      "applyFont does not hardcode FRIZQT")
    assert_true(src:find("SetFontObject", 1, true) ~= nil,
      "applyFont still falls back to GameFont")
    assert_true(src:find("EnableMouseWheel", 1, true) ~= nil,
      "wheel EnableMouseWheel stays")
    assert_true(src:find('SetScript("OnMouseWheel"', 1, true) ~= nil,
      "wheel OnMouseWheel stays")

    local hideBody = src:match("function RecordsBook:Hide%(%)(.-)function RecordsBook:Toggle")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B28-C Hide body stays readable")
    local remountAt = hideBody and hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
    local hideAt = hideBody and hideBody:find("self.frame:Hide()", 1, true)
    assert_true(remountAt ~= nil and hideAt ~= nil and remountAt < hideAt,
      "B28-C Hide remount rememberSpecial FRAME_NAME stays")

    assert_eq(type(Book.toRoman), "function", "toRoman stays a public helper")
    if type(Book.toRoman) == "function" then
      assert_eq(Book.toRoman(14), "XIV", "roman tallies stay XIV")
    end
    assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
    assert_eq(#Book:GetPages(), 9, "PAGE_TITLES stay 9")
    Book:Show()
    assert_eq(Book.frame.PageTitle:GetText(), "Most Sanctioned Victories",
      "first leaf title is unchanged")
    assert_eq(Book.frame.TitleText:GetText(), "The Records Book",
      "chrome title stays The Records Book")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
  end
  runB31D()

  -- B38-D: Hide remounts a missing OnHide when the frame already
  -- exists. Extract wireBookOnHide (never replace). Existing-frame
  -- Hide: remount OnHide, then rememberSpecial(FRAME_NAME), then
  -- frame:Hide(). OnHide remounts rememberSpecial so ESC still
  -- re-lists. Wipe list, nil OnHide, Show, Hide: OnHide restored,
  -- ChurchOfBeefRecordsBook re-listed once, pageIndex unchanged,
  -- no sound. Third Hide does not replace OnHide.
  -- No OnShow re-wire. No rebuild. Isolation wrap stays.
  local function runB38D()
    assert_true(src:find("local function wireBookOnHide", 1, true) ~= nil,
      "source extracts wireBookOnHide")
    local wireBook = src:match("local function wireBookOnHide%(widget%)(.-)\nlocal function uiSlot")
    assert_true(type(wireBook) == "string" and wireBook ~= "",
      "wireBookOnHide body is readable")
    assert_true(wireBook:find("GetScript", 1, true) ~= nil,
      "wireBookOnHide checks GetScript")
    assert_true(wireBook:find("SetScript", 1, true) ~= nil,
      "wireBookOnHide holds SetScript")
    assert_true(wireBook:find("OnHide", 1, true) ~= nil,
      "wireBookOnHide wires OnHide")
    assert_true(wireBook:find("if existing then return", 1, true) ~= nil,
      "wireBookOnHide does not replace an existing OnHide")
    assert_true(wireBook:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "OnHide remounts rememberSpecial FRAME_NAME")
    assert_eq(wireBook:find("pageIndex", 1, true), nil,
      "wireBookOnHide does not reset pageIndex")
    assert_eq(wireBook:find("OnShow", 1, true), nil,
      "wireBookOnHide does not wire OnShow")
    assert_eq(wireBook:find("PlaySound", 1, true), nil,
      "wireBookOnHide does not PlaySound")
    assert_eq(wireBook:find("IG_CHARACTER_INFO", 1, true), nil,
      "wireBookOnHide has no IG_CHARACTER_INFO")
    assert_eq(wireBook:find("CreateFrame", 1, true), nil,
      "wireBookOnHide does not rebuild")
    assert_eq(wireBook:find("buildFrame", 1, true), nil,
      "wireBookOnHide does not call buildFrame")

    local hideBody = src:match("function RecordsBook:Hide%(%)(.-)function RecordsBook:Toggle")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B38-D Hide body is readable")
    local wireAt = hideBody:find("wireBookOnHide", 1, true)
    local remountAt = hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
    local hideAt = hideBody:find("self.frame:Hide()", 1, true)
    assert_true(wireAt ~= nil, "Hide remounts OnHide via wireBookOnHide")
    assert_true(remountAt ~= nil, "Hide remount still rememberSpecial FRAME_NAME")
    assert_true(hideAt ~= nil, "Hide still calls self.frame:Hide()")
    assert_true(type(wireAt) == "number" and type(hideAt) == "number" and wireAt < hideAt,
      "Hide remounts OnHide before frame:Hide()")
    assert_true(type(wireAt) == "number" and type(remountAt) == "number" and wireAt < remountAt,
      "Hide remounts OnHide before rememberSpecial")
    assert_true(type(remountAt) == "number" and type(hideAt) == "number" and remountAt < hideAt,
      "Hide remounts rememberSpecial before frame:Hide()")
    assert_eq(hideBody:find("SetScript", 1, true), nil,
      "Hide does not SetScript inline")
    assert_eq(hideBody:find("OnShow", 1, true), nil,
      "Hide does not re-wire OnShow")
    assert_eq(hideBody:find("pageIndex", 1, true), nil,
      "Hide does not reset pageIndex")
    assert_eq(hideBody:find("buildFrame", 1, true), nil,
      "Hide remount does not rebuild")
    assert_eq(hideBody:find("CreateFrame", 1, true), nil,
      "Hide remount does not CreateFrame")
    assert_eq(hideBody:find("PlaySound", 1, true), nil,
      "Hide remount does not PlaySound")
    assert_eq(hideBody:find("IG_CHARACTER_INFO", 1, true), nil,
      "Hide remount has no IG_CHARACTER_INFO")
    assert_eq(hideBody:find(":Show()", 1, true), nil,
      "Hide remount does not Show")
    assert_eq(hideBody:find("self:Show", 1, true), nil,
      "Hide remount does not call Show")

    local buildBody = src:match("local function buildFrame%(%)(.-)\nfunction RecordsBook:ResetForTests")
    assert_true(type(buildBody) == "string" and buildBody ~= "",
      "buildFrame body is readable")
    local hideInBuild = buildBody:find("frame:Hide()", 1, true)
    local wireInBuild = buildBody:find("wireBookOnHide", 1, true)
    assert_true(hideInBuild ~= nil, "create-path still has create-time Hide")
    assert_true(wireInBuild ~= nil, "create-path uses wireBookOnHide")
    assert_true(type(hideInBuild) == "number" and type(wireInBuild) == "number"
        and hideInBuild < wireInBuild,
      "create-path wires OnHide after create-time Hide")
    assert_eq(buildBody:find('SetScript("OnHide"', 1, true), nil,
      "create-path does not SetScript OnHide inline")

    local showBody = src:match("function RecordsBook:Show%(%)(.-)function RecordsBook:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "Show body stays readable")
    assert_true(showBody:find("wireBookOnHide", 1, true) ~= nil,
      "Show remounts OnHide via wireBookOnHide")
    assert_eq(showBody:find("OnShow", 1, true), nil,
      "Show does not re-wire OnShow")

    local earlyInit = src:match("function RecordsBook:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
    assert_true(type(earlyInit) == "string" and earlyInit ~= "",
      "B25-C Init early-return body stays readable")
    assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B25-C early-return rememberSpecial FRAME_NAME stays")
    assert_true(earlyInit:find("wireBookOnHide", 1, true) ~= nil,
      "Init remounts OnHide via wireBookOnHide")
    assert_eq(earlyInit:find("buildFrame", 1, true), nil,
      "B25-C early-return still does not rebuild")

    assert_true(src:find('FRAME_NAME = "ChurchOfBeefRecordsBook"', 1, true) ~= nil,
      "FRAME_NAME stays ChurchOfBeefRecordsBook")
    assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
      "rememberSpecial helper stays")
    assert_true(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "buildFrame still rememberSpecial FRAME_NAME")
    assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil,
      "PAGE_TITLE_FONT local stays gone")
    assert_true(src:find('applyFont(pageTitle, "GameFontNormalLarge", "label", 18)', 1, true) ~= nil,
      "page titles stay Theme label role")
    assert_eq(src:find("MORPHEUS", 1, true), nil,
      "page titles still do not hardcode MORPHEUS")
    assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
    assert_eq(#Book:GetPages(), 9, "PAGE_TITLES stay 9")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")

    Book:Show()
    local existing = Book.frame
    assert_true(existing ~= nil, "B38-D Show so the frame exists")
    assert_eq(existing:GetName(), "ChurchOfBeefRecordsBook",
      "B38-D frame name stays ChurchOfBeefRecordsBook")
    local nextBtn = existing.NextButton
    assert_true(nextBtn ~= nil, "Next leaf control exists")
    stub.fire(nextBtn, "OnClick")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "turned to second leaf before remount")
    local savedOnHideList = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 0,
      "B38-D wipe clears ChurchOfBeefRecordsBook")
    existing:SetScript("OnHide", nil)
    assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Show")
    local cuesOnHide = sounds
    local hideCreates = 0
    local savedHideCreate = CreateFrame
    CreateFrame = function(...)
      hideCreates = hideCreates + 1
      return savedHideCreate(...)
    end
    assert_eq(Book:Show(), true, "B38-D Show after wipe")
    assert_eq(existing:IsShown(), true, "B38-D Show opens the book")
    assert_true(existing:GetScript("OnHide") ~= nil,
      "Show remounts missing OnHide")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "Show does not reset pageIndex")
    assert_eq(Book:Hide(), true, "B38-D Hide succeeds")
    CreateFrame = savedHideCreate
    local restored = existing:GetScript("OnHide")
    assert_true(restored ~= nil, "Hide remounts missing OnHide")
    assert_eq(Book:IsShown(), false, "Hide closes the book")
    assert_eq(existing:IsShown(), false, "Hide hides the widget")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "ChurchOfBeefRecordsBook re-listed once")
    assert_eq(hideCreates, 0, "Hide remount does not rebuild")
    assert_eq(sounds, cuesOnHide, "Hide remount plays no sound")
    assert_eq(existing:GetName(), "ChurchOfBeefRecordsBook",
      "Hide remount keeps FRAME_NAME ChurchOfBeefRecordsBook")
    assert_eq(Book.frame, existing, "Hide remount keeps the same frame")
    assert_eq(Book:Show(), true, "Show after remount Hide succeeds")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "pageIndex unchanged after Hide")
    Book:Hide()
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "second Hide still does not reset pageIndex")
    assert_eq(existing:GetScript("OnHide"), restored,
      "second Hide does not replace OnHide")
    Book:Hide()
    assert_eq(existing:GetScript("OnHide"), restored,
      "third Hide does not replace OnHide")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "third Hide does not duplicate UISpecialFrames")
    assert_eq(sounds, cuesOnHide, "third Hide plays no sound")
    assert_eq(Book.frame, existing, "third Hide still same frame pointer")
    assert_eq(#Book:GetPages(), 9, "OnHide remount is not a tenth page")

    UISpecialFrames = savedOnHideList

    if standalone then
      assert_eq(COB.Runtime, nil, "B38-D isolation still does not load Runtime")
      assert_eq(COB.UI, nil, "B38-D isolation still does not load MainFrame")
      assert_eq(COB.Toasts, nil, "B38-D isolation still does not load Toasts")
      assert_eq(COB.Console, nil, "B38-D isolation still does not load Console")
      assert_eq(COB.Hud, nil, "B38-D isolation still does not load Hud")
    end
  end
  runB38D()

  -- B40-B: existing-frame Show remounts a missing OnHide.
  -- wireBookOnHide then paint / frame:Show(). Never replace
  -- an existing script. Wipe list, nil OnHide, Show: OnHide
  -- restored, ChurchOfBeefRecordsBook re-listed once,
  -- pageIndex unchanged, no sound. Third Show does not
  -- replace OnHide. No OnShow re-wire. No rebuild.
  -- Isolation wrap stays.
  local function runB40B()
    local showBody = src:match("function RecordsBook:Show%(%)(.-)function RecordsBook:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "B40-B Show body is readable")
    local wireAt = showBody:find("wireBookOnHide", 1, true)
    local paintAt = showBody:find("paint()", 1, true)
    local showAt = showBody:find("frame:Show()", 1, true)
    assert_true(wireAt ~= nil, "Show remounts OnHide via wireBookOnHide")
    assert_true(paintAt ~= nil, "Show still paints")
    assert_true(showAt ~= nil, "Show still calls frame:Show()")
    assert_true(type(wireAt) == "number" and type(paintAt) == "number" and wireAt < paintAt,
      "Show remounts OnHide before paint")
    assert_true(type(paintAt) == "number" and type(showAt) == "number" and paintAt < showAt,
      "Show paints before frame:Show()")
    assert_eq(showBody:find("SetScript", 1, true), nil,
      "Show does not SetScript inline")
    assert_eq(showBody:find("OnShow", 1, true), nil,
      "Show does not re-wire OnShow")
    assert_eq(showBody:find("pageIndex", 1, true), nil,
      "Show does not reset pageIndex")
    assert_eq(showBody:find("buildFrame", 1, true), nil,
      "Show remount does not rebuild")
    assert_eq(showBody:find("CreateFrame", 1, true), nil,
      "Show remount does not CreateFrame")
    assert_eq(showBody:find("PlaySound", 1, true), nil,
      "Show remount does not PlaySound")
    assert_eq(showBody:find("IG_CHARACTER_INFO", 1, true), nil,
      "Show remount has no IG_CHARACTER_INFO")

    local hideBody = src:match("function RecordsBook:Hide%(%)(.-)function RecordsBook:Toggle")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B38-D Hide body stays readable")
    assert_true(hideBody:find("wireBookOnHide", 1, true) ~= nil,
      "B38-D Hide remount still wireBookOnHide")
    assert_true(hideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B38-D Hide remount still rememberSpecial FRAME_NAME")

    local earlyInit = src:match("function RecordsBook:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
    assert_true(type(earlyInit) == "string" and earlyInit ~= "",
      "B25-C Init early-return body stays readable")
    assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B25-C early-return rememberSpecial FRAME_NAME stays")
    assert_true(earlyInit:find("wireBookOnHide", 1, true) ~= nil,
      "Init remounts OnHide via wireBookOnHide")
    assert_eq(earlyInit:find("buildFrame", 1, true), nil,
      "B25-C early-return still does not rebuild")

    assert_true(src:find("local function wireBookOnHide", 1, true) ~= nil,
      "wireBookOnHide helper stays")
    assert_true(src:find("if existing then return", 1, true) ~= nil,
      "wireBookOnHide still does not replace an existing OnHide")
    assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
      "rememberSpecial helper stays")
    assert_true(src:find('FRAME_NAME = "ChurchOfBeefRecordsBook"', 1, true) ~= nil,
      "FRAME_NAME stays ChurchOfBeefRecordsBook")
    assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil,
      "PAGE_TITLE_FONT local stays gone")
    assert_true(src:find('applyFont(pageTitle, "GameFontNormalLarge", "label", 18)', 1, true) ~= nil,
      "page titles stay Theme label role")
    assert_eq(src:find("MORPHEUS", 1, true), nil,
      "page titles still do not hardcode MORPHEUS")
    assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
    assert_eq(#Book:GetPages(), 9, "PAGE_TITLES stay 9")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")

    reset()
    Book:Show()
    local existing = Book.frame
    assert_true(existing ~= nil, "B40-B Show so the frame exists")
    assert_eq(existing:GetName(), "ChurchOfBeefRecordsBook",
      "B40-B frame name stays ChurchOfBeefRecordsBook")
    local nextBtn = existing.NextButton
    assert_true(nextBtn ~= nil, "Next leaf control exists")
    stub.fire(nextBtn, "OnClick")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "turned to second leaf before remount")
    local savedShowList = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 0,
      "B40-B wipe clears ChurchOfBeefRecordsBook")
    existing:SetScript("OnHide", nil)
    assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Show")
    local cuesShow = sounds
    local showCreates = 0
    local savedShowCreate = CreateFrame
    CreateFrame = function(...)
      showCreates = showCreates + 1
      return savedShowCreate(...)
    end
    assert_eq(Book:Show(), true, "B40-B Show after wipe")
    CreateFrame = savedShowCreate
    local restored = existing:GetScript("OnHide")
    assert_true(restored ~= nil, "Show remounts missing OnHide")
    assert_eq(existing:IsShown(), true, "Show opens the book")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "ChurchOfBeefRecordsBook re-listed once")
    assert_eq(showCreates, 0, "Show remount does not rebuild")
    assert_eq(sounds, cuesShow, "Show remount plays no sound")
    assert_eq(existing:GetName(), "ChurchOfBeefRecordsBook",
      "Show remount keeps FRAME_NAME ChurchOfBeefRecordsBook")
    assert_eq(Book.frame, existing, "Show remount keeps the same frame")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "Show does not reset pageIndex")

    Book:Show()
    assert_eq(existing:GetScript("OnHide"), restored,
      "second Show does not replace OnHide")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "second Show still does not reset pageIndex")
    Book:Show()
    assert_eq(existing:GetScript("OnHide"), restored,
      "third Show does not replace OnHide")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "third Show does not duplicate UISpecialFrames")
    assert_eq(sounds, cuesShow, "third Show plays no sound")
    assert_eq(Book.frame, existing, "third Show still same frame pointer")
    assert_eq(existing:IsShown(), true, "third Show stays open")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "third Show still does not reset pageIndex")
    assert_eq(#Book:GetPages(), 9, "OnHide remount is not a tenth page")

    UISpecialFrames = savedShowList

    if standalone then
      assert_eq(COB.Runtime, nil, "B40-B isolation still does not load Runtime")
      assert_eq(COB.UI, nil, "B40-B isolation still does not load MainFrame")
      assert_eq(COB.Toasts, nil, "B40-B isolation still does not load Toasts")
      assert_eq(COB.Console, nil, "B40-B isolation still does not load Console")
      assert_eq(COB.Hud, nil, "B40-B isolation still does not load Hud")
    end
  end
  runB40B()

  -- B41-B: existing-frame Init remounts a missing OnHide.
  -- wireBookOnHide then rememberSpecial(FRAME_NAME). Never replace
  -- an existing script. Wipe list, nil OnHide, Init: OnHide
  -- restored, ChurchOfBeefRecordsBook re-listed once,
  -- pageIndex unchanged, no sound. Third Init does not
  -- replace OnHide. No OnShow re-wire. No rebuild.
  -- Isolation wrap stays.
  local function runB41B()
    local earlyInit = src:match("function RecordsBook:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
    assert_true(type(earlyInit) == "string" and earlyInit ~= "",
      "B41-B Init early-return body is readable")
    local wireAt = earlyInit:find("wireBookOnHide", 1, true)
    local remountAt = earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true)
    assert_true(wireAt ~= nil, "Init remounts OnHide via wireBookOnHide")
    assert_true(remountAt ~= nil, "Init remount still rememberSpecial FRAME_NAME")
    assert_true(type(wireAt) == "number" and type(remountAt) == "number" and wireAt < remountAt,
      "Init remounts OnHide before rememberSpecial")
    assert_eq(earlyInit:find("SetScript", 1, true), nil,
      "Init does not SetScript inline")
    assert_eq(earlyInit:find("OnShow", 1, true), nil,
      "Init does not re-wire OnShow")
    assert_eq(earlyInit:find("pageIndex", 1, true), nil,
      "Init does not reset pageIndex")
    assert_eq(earlyInit:find("buildFrame", 1, true), nil,
      "Init remount does not rebuild")
    assert_eq(earlyInit:find("CreateFrame", 1, true), nil,
      "Init remount does not CreateFrame")
    assert_eq(earlyInit:find("PlaySound", 1, true), nil,
      "Init remount does not PlaySound")
    assert_eq(earlyInit:find("IG_CHARACTER_INFO", 1, true), nil,
      "Init remount has no IG_CHARACTER_INFO")
    assert_eq(earlyInit:find("paint()", 1, true), nil,
      "Init remount does not paint")
    assert_eq(earlyInit:find(":Show()", 1, true), nil,
      "Init remount does not Show")
    assert_eq(earlyInit:find(":Hide()", 1, true), nil,
      "Init remount does not Hide")

    local showBody = src:match("function RecordsBook:Show%(%)(.-)function RecordsBook:Hide")
    assert_true(type(showBody) == "string" and showBody ~= "",
      "B40-B Show body stays readable")
    assert_true(showBody:find("wireBookOnHide", 1, true) ~= nil,
      "B40-B Show remount still wireBookOnHide")

    local hideBody = src:match("function RecordsBook:Hide%(%)(.-)function RecordsBook:Toggle")
    assert_true(type(hideBody) == "string" and hideBody ~= "",
      "B38-D Hide body stays readable")
    assert_true(hideBody:find("wireBookOnHide", 1, true) ~= nil,
      "B38-D Hide remount still wireBookOnHide")
    assert_true(hideBody:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
      "B38-D Hide remount still rememberSpecial FRAME_NAME")

    assert_true(src:find("local function wireBookOnHide", 1, true) ~= nil,
      "wireBookOnHide helper stays")
    assert_true(src:find("if existing then return", 1, true) ~= nil,
      "wireBookOnHide still does not replace an existing OnHide")
    assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
      "rememberSpecial helper stays")
    assert_true(src:find('FRAME_NAME = "ChurchOfBeefRecordsBook"', 1, true) ~= nil,
      "FRAME_NAME stays ChurchOfBeefRecordsBook")
    assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil,
      "PAGE_TITLE_FONT local stays gone")
    assert_true(src:find('applyFont(pageTitle, "GameFontNormalLarge", "label", 18)', 1, true) ~= nil,
      "page titles stay Theme label role")
    assert_eq(src:find("MORPHEUS", 1, true), nil,
      "page titles still do not hardcode MORPHEUS")
    assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
    assert_eq(#Book:GetPages(), 9, "PAGE_TITLES stay 9")
    assert_eq(src:find("PlaySound", 1, true), nil,
      "source still does not play sound")
    assert_eq(src:find("IG_CHARACTER_INFO", 1, true), nil,
      "source still has no IG_CHARACTER_INFO")

    reset()
    Book:Show()
    local existing = Book.frame
    assert_true(existing ~= nil, "B41-B Show so the frame exists")
    assert_eq(existing:GetName(), "ChurchOfBeefRecordsBook",
      "B41-B frame name stays ChurchOfBeefRecordsBook")
    local nextBtn = existing.NextButton
    assert_true(nextBtn ~= nil, "Next leaf control exists")
    stub.fire(nextBtn, "OnClick")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "turned to second leaf before remount")
    local savedInitList = UISpecialFrames
    UISpecialFrames = {}
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 0,
      "B41-B wipe clears ChurchOfBeefRecordsBook")
    existing:SetScript("OnHide", nil)
    assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Init")
    local cuesInit = sounds
    local initCreates = 0
    local savedInitCreate = CreateFrame
    CreateFrame = function(...)
      initCreates = initCreates + 1
      return savedInitCreate(...)
    end
    local remounted = Book:Init()
    CreateFrame = savedInitCreate
    assert_eq(remounted, existing, "Init remount returns the existing frame")
    local restored = existing:GetScript("OnHide")
    assert_true(restored ~= nil, "Init remounts missing OnHide")
    assert_eq(existing:IsShown(), true, "Init remount does not close the book")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "ChurchOfBeefRecordsBook re-listed once")
    assert_eq(initCreates, 0, "Init remount does not rebuild")
    assert_eq(sounds, cuesInit, "Init remount plays no sound")
    assert_eq(existing:GetName(), "ChurchOfBeefRecordsBook",
      "Init remount keeps FRAME_NAME ChurchOfBeefRecordsBook")
    assert_eq(Book.frame, existing, "Init remount keeps the same frame")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "Init does not reset pageIndex")
    assert_eq(existing:GetScript("OnShow"), nil,
      "Init remount does not wire OnShow")

    Book:Init()
    assert_eq(existing:GetScript("OnHide"), restored,
      "second Init does not replace OnHide")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "second Init still does not reset pageIndex")
    Book:Init()
    assert_eq(existing:GetScript("OnHide"), restored,
      "third Init does not replace OnHide")
    assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
      "third Init does not duplicate UISpecialFrames")
    assert_eq(sounds, cuesInit, "third Init plays no sound")
    assert_eq(Book.frame, existing, "third Init still same frame pointer")
    assert_eq(existing:IsShown(), true, "third Init stays open")
    assert_eq(existing.PageTitle:GetText(), "Longest Streak",
      "third Init still does not reset pageIndex")
    assert_eq(#Book:GetPages(), 9, "OnHide remount is not a tenth page")

    UISpecialFrames = savedInitList

    if standalone then
      assert_eq(COB.Runtime, nil, "B41-B isolation still does not load Runtime")
      assert_eq(COB.UI, nil, "B41-B isolation still does not load MainFrame")
      assert_eq(COB.Toasts, nil, "B41-B isolation still does not load Toasts")
      assert_eq(COB.Console, nil, "B41-B isolation still does not load Console")
      assert_eq(COB.Hud, nil, "B41-B isolation still does not load Hud")
    end
  end
  runB41B()

  -- U-H: Theme dress, Common roman wrapper, fixed medallion pool.
  -- Nested here so the Lua 5.1 200-local cap stays quiet.
  local function runUH()
    assert_true(COB.Theme ~= nil, "U-H Theme is loaded")
    assert_true(type(COB.Common.RomanNumeral) == "function", "U-H Common.RomanNumeral exists")
    assert_eq(Book.toRoman(14), "XIV", "U-H toRoman(14) is XIV")
    assert_eq(Book.toRoman(14), COB.Common.RomanNumeral(14), "U-H toRoman wraps Common")
    assert_eq(Book.toRoman(0), "", "U-H toRoman empty on 0")
    assert_eq(Book.toRoman(nil), "", "U-H toRoman empty on nil")

    local paintAt = src:find("local function paint()", 1, true)
    local paintEnd = src:find("\nlocal function turn(", paintAt + 1, true)
    local paintBody = src:sub(paintAt, paintEnd - 1)
    assert_eq(paintBody:find("CreateFrame", 1, true), nil,
      "paint does not CreateFrame medallion rows")
    assert_eq(paintBody:find("CreateTexture", 1, true), nil,
      "paint does not CreateTexture medallion rows")
    assert_true(paintBody:find("dressMedallion", 1, true) ~= nil,
      "paint dresses existing medallion slots")
    assert_true(src:find("local MEDALLION_POOL = 8", 1, true) ~= nil,
      "medallion pool size is a create-time constant")
    assert_true(src:find("frame.Medallion = frame.Medallions[1]", 1, true) ~= nil,
      "Medallion aliases the first pool slot")
    assert_true(src:find('Theme:FontPath', 1, true) ~= nil, "U-H fonts go through Theme")
    assert_true(src:find('Theme:Color', 1, true) ~= nil, "U-H colors go through Theme")
    assert_true(src:find('Theme:Texture', 1, true) ~= nil, "U-H textures go through Theme")
    assert_eq(src:find("PAGE_TITLE_FONT", 1, true), nil, "U-H PAGE_TITLE_FONT stays gone")
    assert_eq(src:find("ROMAN_MAP", 1, true), nil, "U-H ROMAN_MAP stays gone")
    assert_eq(#Book:GetPages(), 9, "U-H dress is not a tenth page")

    if standalone then
      assert_eq(COB.Runtime, nil, "U-H isolation still does not load Runtime")
      assert_eq(COB.UI, nil, "U-H isolation still does not load MainFrame")
      assert_eq(COB.Toasts, nil, "U-H isolation still does not load Toasts")
      assert_eq(COB.Console, nil, "U-H isolation still does not load Console")
      assert_eq(COB.Hud, nil, "U-H isolation still does not load Hud")
    end
  end
  runUH()

  if standalone then
    assert_eq(COB.Runtime, nil, "isolation still does not load Runtime")
    assert_eq(COB.UI, nil, "isolation still does not load MainFrame")
    assert_eq(COB.Toasts, nil, "isolation still does not load Toasts")
    assert_eq(COB.Console, nil, "isolation still does not load Console")
    assert_eq(COB.Hud, nil, "isolation still does not load Hud")
  end
end
runB25C()

assert_eq(buttonFor("Ladder"), nil, "no Ladder chrome")
assert_eq(buttonFor("My Standing"), nil, "no Standing chrome")
assert_eq(buttonFor("Sort"), nil, "no Sort control")
assert_eq(buttonFor("#1"), nil, "no #1 rating control")
assert_eq(buttonFor("Grant"), nil, "no Grant control")

--------------------------------------------------------------------------------
-- Toggle / Show / Hide only. No feed. No auto-open. No sound.
--------------------------------------------------------------------------------
assert_eq(Book:Show(), true, "Show succeeds")
assert_eq(Book:IsShown(), true, "Show opens the book")
assert_eq(Book:Show(), true, "Show on an open book is still success")
assert_eq(Book:IsShown(), true, "Show does not toggle closed")
assert_eq(Book:Hide(), true, "Hide succeeds")
assert_eq(Book:IsShown(), false, "Hide closes the book")
assert_eq(Book:Hide(), true, "Hide on a closed book is still success")
assert_eq(Book:Toggle(), true, "Toggle opens a closed book")
assert_eq(Book:IsShown(), true, "Toggle opened")
assert_eq(Book:Toggle(), true, "Toggle closes an open book")
assert_eq(Book:IsShown(), false, "Toggle closed")
assert_eq(sounds, 0, "Show / Hide / Toggle play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "open book still has no OnUpdate")

local close = frame.CloseButton
assert_true(close ~= nil, "a close control exists")
Book:Show()
assert_true(stub.fire(close, "OnClick"), "close is wired")
assert_eq(Book:IsShown(), false, "close hides the book")
assert_eq(sounds, 0, "close plays no addon sound")

--------------------------------------------------------------------------------
-- Bible pages from an empty store. Defenses and Tournament Champions stay empty.
--------------------------------------------------------------------------------
reset()
local pages = Book:GetPages()
assert_eq(#pages, #BIBLE_TITLES, "exactly the Bible MVP pages")
for i = 1, #BIBLE_TITLES do
  assert_eq(pages[i].title, BIBLE_TITLES[i], "page " .. i .. " is " .. BIBLE_TITLES[i])
  assert_eq(type(pages[i].entries), "table", BIBLE_TITLES[i] .. " has an entries list")
  assert_eq(pages[i].rank, nil, BIBLE_TITLES[i] .. " is not a ranked row")
  assert_eq(pages[i].rating, nil, BIBLE_TITLES[i] .. " has no rating")
  assert_eq(pages[i].place, nil, BIBLE_TITLES[i] .. " has no place")
end
assert_eq(#pageNamed("Most Successful Defenses").entries, 0, "empty store has no defenses")
assert_eq(#pageNamed("Tournament Champions").entries, 0, "Tournament Champions is empty")
assert_eq(#pageNamed("Famous Upsets").entries, 0, "unflagged empty store has no Famous Upsets")
assert_eq(#pageNamed("Most Sanctioned Victories").entries, 0, "no victories yet")
assert_eq(#pageNamed("The Undefeated").entries, 0, "no unbeaten records yet")

Book:Show()
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "first leaf is Most Sanctioned Victories")
assert_eq(frame.Body:GetText(), "", "empty leaf has no invented copy")
assert_eq(frame.Honorifics:GetText(), "", "empty store paints no honorifics")
assert_eq(frame.Moments:GetText(), "", "empty store paints no moments")
assert_eq(frame.Medallion:IsShown(), false, "empty leaf hides the medallion slot")
assert_eq(sounds, 0, "painting an empty book is silent")

--------------------------------------------------------------------------------
-- Most Sanctioned Victories: the holder(s), not a ladder of everyone.
--------------------------------------------------------------------------------
reset()
local chuck = char("Chuckroast", "Warrior")
local tender = char("Tendermage", "Mage")
local rib = char("Ribeye")
bout(chuck, tender, chuck, 1000)
bout(chuck, tender, chuck, 1001)
bout(chuck, rib, chuck, 1002)
bout(tender, rib, tender, 1003)

local victories = pageNamed("Most Sanctioned Victories")
assert_eq(#victories.entries, 1, "only the superlative holder is listed")
assert_eq(victories.entries[1].name, "Chuckroast", "most sanctioned victories is Chuckroast")
assert_eq(victories.entries[1].wins, 3, "the measure is sanctioned wins")
assert_eq(victories.entries[1].characterId, chuck.id, "holder is the character id")
assert_eq(victories.entries[1].place, nil, "no place number")
assert_eq(victories.entries[1].rating, nil, "no rating")
assert_eq(hasName("Most Sanctioned Victories", "Tendermage"), false, "a lesser win count is not a runner-up row")
assert_eq(hasName("Most Sanctioned Victories", "Ribeye"), false, "a zero-win record is not listed")

bout(tender, rib, tender, 1004)
bout(tender, chuck, tender, 1005)
local tied = pageNamed("Most Sanctioned Victories")
assert_eq(#tied.entries, 2, "a shared record lists both holders")
assert_eq(tied.entries[1].wins, 3, "shared measure is 3")
assert_eq(tied.entries[2].wins, 3, "both holders show the same measure")
assert_true(hasName("Most Sanctioned Victories", "Chuckroast"), "Chuckroast still holds")
assert_true(hasName("Most Sanctioned Victories", "Tendermage"), "Tendermage shares the hold")
assert_eq(tied.entries[1].characterId < tied.entries[2].characterId, true, "tied holders are id-ordered, not ranked")

--------------------------------------------------------------------------------
-- Longest Streak: sanctioned-Gora W/L only. Peak from the result log. Void ignored.
--------------------------------------------------------------------------------
reset()
local a = char("Streaker")
local b = char("Foil")
local c = char("Shorter")
bout(a, b, a, 2000)
bout(a, b, a, 2001)
bout(a, b, a, 2002)
bout(a, b, a, 2003)
bout(a, b, a, 2004)
bout(a, b, b, 2005)
bout(c, b, c, 2006)
bout(c, b, c, 2007)
bout(c, b, c, 2008)
local streak = pageNamed("Longest Streak")
assert_eq(#streak.entries, 1, "Longest Streak is a superlative")
assert_eq(streak.entries[1].name, "Streaker", "the broken five-win peak still holds Longest Streak")
assert_eq(streak.entries[1].streak, 5, "the measure is the longest sanctioned win run")
assert_eq(hasName("Longest Streak", "Shorter"), false, "a live three-win streak is not listed when 5 exists")
assert_eq(Store:GetCharacter(a.id).gora.streak, -1, "Store current streak is a loss; the page still uses the peak")

reset()
local v1 = char("Voided")
local v2 = char("Other")
bout(v1, v2, v1, 2100)
bout(v1, v2, nil, 2101, { ruling = "void" })
bout(v1, v2, v1, 2102)
local voidStreak = pageNamed("Longest Streak")
assert_eq(voidStreak.entries[1].name, "Voided", "Void does not break the fight-record streak")
assert_eq(voidStreak.entries[1].streak, 2, "Void is skipped; two victories remain a streak of 2")

--------------------------------------------------------------------------------
-- Most Successful Defenses: derived post-elevation Lord victories. Not a field.
--------------------------------------------------------------------------------
reset()
assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
local lordH = Store:CreateHuman({ name = "Lordly" }, 3000)
local lordC = char("Lordalt")
local challenger = char("Challenger")
Store:LinkCharacter(lordC.id, lordH.id, 3001)
Store:SetRank(lordH.id, 4, 3002)
assert_eq(Store:GetHuman(lordH.id).rankId, 4, "human is a Beef Lord")
assert_true(Store:GetHuman(lordH.id).elevationAt ~= nil, "Store stamped elevationAt")
bout(lordC, challenger, lordC, 3100)
bout(lordC, challenger, lordC, 3101)

local earlyH = Store:CreateHuman({ name = "Early" }, 3200)
local earlyC = char("Earlyalt")
local foil = char("Foil")
Store:LinkCharacter(earlyC.id, earlyH.id, 3201)
bout(earlyC, foil, earlyC, 3202)
bout(earlyC, foil, earlyC, 3203)
Store:SetRank(earlyH.id, 4, 3300)

local defenses = pageNamed("Most Successful Defenses")
assert_eq(#defenses.entries, 1, "only the top derived defense count is listed")
assert_eq(defenses.entries[1].name, "Lordalt", "Lord + two post-elevation wins is listed")
assert_eq(defenses.entries[1].defenses, 2, "the measure is two post-elevation victories")
assert_eq(defenses.entries[1].characterId, lordC.id, "holder is the character id")
assert_eq(defenses.entries[1].place, nil, "no place number")
assert_eq(hasName("Most Successful Defenses", "Earlyalt"), false,
  "pre-elevation-only wins stay off the page")
assert_eq(Store:GetCharacter(lordC.id).gora.defenses, nil, "Store still has no defenses field")
assert_eq(Store:GetCharacter(earlyC.id).gora.defenses, nil, "derive does not write a defense field")
assert_eq(#Book:GetPages(), 9, "defenses fill is not a tenth page")

Book:Show()
local hopsDef = 0
while frame.PageTitle:GetText() ~= "Most Successful Defenses" and hopsDef < 12 do
  local nextDef = buttonFor("Next")
  assert_true(nextDef ~= nil, "parchment has a Next leaf control")
  stub.fire(nextDef, "OnClick")
  hopsDef = hopsDef + 1
end
assert_eq(frame.PageTitle:GetText(), "Most Successful Defenses", "the defenses leaf can be opened")
local defBody = frame.Body:GetText() or ""
assert_true(defBody:find("Lordalt", 1, true) ~= nil, "the defenses leaf names the holder")
assert_true(defBody:find("II", 1, true) ~= nil, "painted defenses use roman II")
assert_eq(defBody:find("2", 1, true), nil, "painted defenses do not print raw 2")
assert_eq(defBody:find("of the realm", 1, true), nil, "no invented defenses copy")

--------------------------------------------------------------------------------
-- The Iron Chin: most Goras fought. Voids count as fought.
--------------------------------------------------------------------------------
reset()
local chin = char("Ironjaw")
local soft = char("Softer")
local extra = char("Extra")
bout(chin, soft, chin, 4000)
bout(chin, soft, soft, 4001)
bout(chin, extra, nil, 4002, { ruling = "void" })
local iron = pageNamed("The Iron Chin")
assert_eq(#iron.entries, 1, "Iron Chin lists the most-fought holder")
assert_eq(iron.entries[1].name, "Ironjaw", "three sanctioned Goras is the chin")
assert_eq(iron.entries[1].fought, 3, "voids count as Goras fought")
assert_eq(hasName("The Iron Chin", "Softer"), false, "two fights is not the chin")

--------------------------------------------------------------------------------
-- Greatest Rivalry: most-fought pairing + running score. Not every pairing.
--------------------------------------------------------------------------------
reset()
local r1 = char("Riva")
local r2 = char("Rival")
local r3 = char("Once")
bout(r1, r2, r1, 5000)
bout(r1, r2, r2, 5001)
bout(r1, r2, r1, 5002)
bout(r1, r3, r1, 5003)
local rivalry = pageNamed("Greatest Rivalry")
assert_eq(#rivalry.entries, 1, "only the most-fought pairing is listed")
assert_eq(rivalry.entries[1].fights, 3, "the pairing fought three times")
assert_true(
  (rivalry.entries[1].nameA == "Riva" and rivalry.entries[1].nameB == "Rival")
    or (rivalry.entries[1].nameA == "Rival" and rivalry.entries[1].nameB == "Riva"),
  "Greatest Rivalry names both combatants")
local scoreSum = rivalry.entries[1].scoreA + rivalry.entries[1].scoreB
assert_eq(scoreSum, 3, "running score accounts for the three decisive bouts")
assert_true(rivalry.entries[1].scoreA == 2 or rivalry.entries[1].scoreB == 2, "Riva leads 2–1")
assert_true(rivalry.entries[1].scoreA == 1 or rivalry.entries[1].scoreB == 1, "Rival has 1")
assert_eq(hasName("Greatest Rivalry", "Once"), false, "a one-bout pairing is not the rivalry")
assert_eq(rivalry.entries[1].place, nil, "rivalry is not a ranked row")

--------------------------------------------------------------------------------
-- Famous Upsets: Pope-flagged only. Never computed from rank or level.
--------------------------------------------------------------------------------
reset()
local freshH = Store:CreateHuman({ name = "Fresh" }, 6000)
local lordH2 = Store:CreateHuman({ name = "SittingLord" }, 6001)
local freshC = Store:CreateCharacter({ name = "Underdog", class = "Priest", level = 60 })
local lordC2 = Store:CreateCharacter({ name = "Champ", class = "Warrior", level = 70 })
Store:LinkCharacter(freshC.id, freshH.id, 6002)
Store:LinkCharacter(lordC2.id, lordH2.id, 6003)
Store:SetRank(freshH.id, 1, 6004)
Store:SetRank(lordH2.id, 4, 6005)
bout(freshC, lordC2, freshC, 6100)
assert_eq(#pageNamed("Famous Upsets").entries, 0,
  "a Fresh Beef beating a Lord is not an upset unless the Pope flags it")

bout(freshC, lordC2, freshC, 6101, { famousUpset = true })
local upsets = pageNamed("Famous Upsets")
assert_eq(#upsets.entries, 1, "the flagged result is the only Famous Upset")
assert_eq(upsets.entries[1].name, "Underdog", "the flagged winner is named")
assert_eq(upsets.entries[1].opponentName, "Champ", "the flagged opponent is named")
assert_eq(upsets.entries[1].at, 6101, "the flagged result keeps its timestamp")
assert_eq(upsets.entries[1].computed, nil, "no computed-upset mark")

local unflagged = Store:GetCharacter(freshC.id).gora.results[1]
assert_eq(unflagged.famousUpset, false, "the first bout stayed unflagged")
assert_eq(Store:GetCharacter(freshC.id).gora.results[2].famousUpset, true, "the second bout carries the Pope flag")

--------------------------------------------------------------------------------
-- The Undefeated: active unbeaten records. A set, not a ranking.
--------------------------------------------------------------------------------
reset()
local u1 = char("Clean")
local u2 = char("AlsoClean")
local u3 = char("Fallen")
local fodder = char("Fodder")
bout(u1, fodder, u1, 7000)
bout(u2, fodder, u2, 7001)
bout(u2, fodder, u2, 7002)
bout(u3, fodder, u3, 7003)
bout(u3, fodder, fodder, 7004)
local undefeated = pageNamed("The Undefeated")
assert_eq(#undefeated.entries, 2, "both unbeaten records are listed")
assert_true(hasName("The Undefeated", "Clean"), "1–0 is unbeaten")
assert_true(hasName("The Undefeated", "AlsoClean"), "2–0 is unbeaten")
assert_eq(hasName("The Undefeated", "Fallen"), false, "a loss leaves the unbeaten set")
assert_eq(hasName("The Undefeated", "Fodder"), false, "an 0–n record is not unbeaten")
assert_eq(undefeated.entries[1].place, nil, "undefeated entries have no place")
assert_eq(undefeated.entries[1].characterId < undefeated.entries[2].characterId, true,
  "the unbeaten set is id-ordered, not sorted by wins")

--------------------------------------------------------------------------------
-- The Glorious Martyr: most losses. Title is the frame; no generated poetry.
--------------------------------------------------------------------------------
reset()
local martyr = char("Martyralt")
local winner = char("Winner")
local lesser = char("LesserLoss")
bout(martyr, winner, winner, 8000)
bout(martyr, winner, winner, 8001)
bout(martyr, winner, winner, 8002)
bout(lesser, winner, winner, 8003)
local fallen = pageNamed("The Glorious Martyr")
assert_eq(#fallen.entries, 1, "Martyr is a superlative")
assert_eq(fallen.entries[1].name, "Martyralt", "most losses holds the page")
assert_eq(fallen.entries[1].losses, 3, "the measure is losses")
assert_eq(hasName("The Glorious Martyr", "LesserLoss"), false, "fewer losses are not listed")
Book:Show()
-- Flip to the martyr leaf by walking titles, not by inventing a jump API.
local hops = 0
while frame.PageTitle:GetText() ~= "The Glorious Martyr" and hops < 12 do
  local nextBtn = buttonFor("Next")
  assert_true(nextBtn ~= nil, "parchment has a Next leaf control")
  stub.fire(nextBtn, "OnClick")
  hops = hops + 1
end
assert_eq(frame.PageTitle:GetText(), "The Glorious Martyr", "the martyr leaf can be opened")
local body = frame.Body:GetText() or ""
assert_true(body:find("Martyralt", 1, true) ~= nil, "the martyr leaf names the holder")
assert_eq(body:find("fallen", 1, true), nil, "no generated 'fallen' poetry")
assert_eq(body:find("risen", 1, true), nil, "no generated 'risen' poetry")
assert_eq(body:find("Goldshire", 1, true), nil, "no invented location flavor")
assert_eq(body:find("lol", 1, true), nil, "the UI does not tell jokes")

--------------------------------------------------------------------------------
-- Tournament Champions stays empty. No invented engine.
--------------------------------------------------------------------------------
reset()
char("Champish")
assert_eq(#pageNamed("Tournament Champions").entries, 0, "a character does not mint a tournament")
assert_eq(Book.AddTournamentChampion, nil, "still no tournament writer")

--------------------------------------------------------------------------------
-- GetPages returns copies. Show / Hide do not write the Store.
--------------------------------------------------------------------------------
reset()
local p = char("Copy")
local q = char("Mut")
bout(p, q, p, 9000)
local snapBefore = Store:Snapshot()
local leaf = Book:GetPages()
leaf[1].title = "hacked"
leaf[1].entries[1] = { name = "forged", wins = 99, place = 1 }
assert_eq(pageNamed("Most Sanctioned Victories").title, "Most Sanctioned Victories",
  "mutating a GetPages copy does not rewrite the book")
assert_eq(pageNamed("Most Sanctioned Victories").entries[1].name, "Copy",
  "mutating an entry copy does not rewrite the holder")
Book:Show()
Book:Hide()
Book:Toggle()
Book:Toggle()
local snapAfter = Store:Snapshot()
assert_eq(snapAfter.characters[1].gora.wins, snapBefore.characters[1].gora.wins,
  "opening the book does not write Gora wins")
assert_eq(#snapAfter.characters[1].gora.results, #snapBefore.characters[1].gora.results,
  "opening the book does not append results")
assert_eq(snapAfter.nextCharacterId, snapBefore.nextCharacterId, "opening the book does not mint ids")
assert_eq(sounds, 0, "copy / paint path stays silent")

--------------------------------------------------------------------------------
-- History is never deleted: a tombstoned character still holds a record.
--------------------------------------------------------------------------------
reset()
local stay = char("Stayalt")
local foe = char("Foe")
bout(stay, foe, stay, 9100)
Store:TombstoneCharacter(stay.id, 9101)
assert_eq(Store:GetCharacter(stay.id).inactive, true, "character is inactive")
assert_eq(pageNamed("Most Sanctioned Victories").entries[1].name, "Stayalt",
  "a tombstone does not drop the record")

--------------------------------------------------------------------------------
-- Painted chrome stays ecclesiastical and silent. Prev/Next turn leaves, not ranks.
--------------------------------------------------------------------------------
reset()
local leafA = char("LeafA")
local leafB = char("LeafB")
bout(leafA, leafB, leafA, 9200)
Book:Show()
assert_eq(frame.TitleText:GetText(), "The Records Book", "title stays the book name while open")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "open book starts on the first leaf")
local bodyOpen = frame.Body:GetText() or ""
assert_true(bodyOpen:find("LeafA", 1, true) ~= nil, "the open leaf names the holder")
assert_eq(bodyOpen:find("#1", 1, true), nil, "painted copy has no #1 rating")
assert_eq(bodyOpen:find("standing", 1, true), nil, "painted copy has no standing")
assert_eq(bodyOpen:find("Grant", 1, true), nil, "painted copy has no Grant")
assert_eq(bodyOpen:find("points", 1, true), nil, "painted copy has no points")
local prevBtn = buttonFor("Previous")
local nextBtn = buttonFor("Next")
assert_true(prevBtn ~= nil, "Previous leaf control exists")
assert_true(nextBtn ~= nil, "Next leaf control exists")
stub.fire(nextBtn, "OnClick")
assert_eq(frame.PageTitle:GetText(), "Longest Streak", "Next turns the leaf")
stub.fire(prevBtn, "OnClick")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "Previous turns the leaf back")
assert_eq(sounds, 0, "leaf turns play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "leaf turns install no OnUpdate")

--------------------------------------------------------------------------------
-- Mouse wheel turns leaves the same way Prev/Next do. Silent. No OnUpdate.
--------------------------------------------------------------------------------
reset()
assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
Book:Show()
assert_true(frame:GetScript("OnMouseWheel") ~= nil, "frame has OnMouseWheel")
assert_eq(frame:GetScript("OnUpdate"), nil, "wheel install has no OnUpdate")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "open book starts on the first leaf")
assert_eq(frame.Body:GetText(), "", "empty leaf has no invented copy")
assert_true(stub.fire(frame, "OnMouseWheel", -1), "wheel down is wired")
assert_eq(frame.PageTitle:GetText(), "Longest Streak", "wheel down turns the leaf the same way Next does")
assert_eq(frame.Body:GetText(), "", "empty leaf body stays empty after a turn")
assert_true(stub.fire(frame, "OnMouseWheel", 1), "wheel up is wired")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "wheel up turns the leaf the same way Previous does")
assert_eq(frame.Body:GetText(), "", "empty leaf body stays empty after Previous")
assert_eq(sounds, 0, "wheel turns play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "wheel turns install no OnUpdate")
assert_eq(#Book:GetPages(), 9, "wheel is not a tenth page")

--------------------------------------------------------------------------------
-- Chrome on top of the tome also turns leaves. Same handler as the outer frame.
--------------------------------------------------------------------------------
reset()
assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
Book:Show()
assert_true(frame:GetScript("OnMouseWheel") ~= nil, "outer frame still has OnMouseWheel")
assert_true(frame.TitleBar ~= nil, "TitleBar exists")
assert_true(frame.TitleBar:GetScript("OnMouseWheel") ~= nil, "TitleBar has OnMouseWheel")
assert_true(frame.CloseButton ~= nil, "CloseButton exists")
assert_true(frame.CloseButton:GetScript("OnMouseWheel") ~= nil, "CloseButton has OnMouseWheel")
assert_true(frame.VictoriesRibbon ~= nil, "VictoriesRibbon exists")
assert_true(frame.VictoriesRibbon:GetScript("OnMouseWheel") ~= nil, "VictoriesRibbon has OnMouseWheel")
assert_true(frame.RivalriesRibbon ~= nil, "RivalriesRibbon exists")
assert_true(frame.RivalriesRibbon:GetScript("OnMouseWheel") ~= nil, "RivalriesRibbon has OnMouseWheel")
assert_true(frame.MartyrsRibbon ~= nil, "MartyrsRibbon exists")
assert_true(frame.MartyrsRibbon:GetScript("OnMouseWheel") ~= nil, "MartyrsRibbon has OnMouseWheel")
assert_true(frame.PrevButton ~= nil, "PrevButton exists")
assert_true(frame.PrevButton:GetScript("OnMouseWheel") ~= nil, "PrevButton has OnMouseWheel")
assert_true(frame.NextButton ~= nil, "NextButton exists")
assert_true(frame.NextButton:GetScript("OnMouseWheel") ~= nil, "NextButton has OnMouseWheel")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "open book starts on the first leaf")
assert_eq(frame.Body:GetText(), "", "empty leaf has no invented copy")
assert_true(stub.fire(frame.TitleBar, "OnMouseWheel", -1), "TitleBar wheel down is wired")
assert_eq(frame.PageTitle:GetText(), "Longest Streak", "TitleBar wheel down turns Next")
assert_eq(frame.Body:GetText(), "", "empty leaf body stays empty after TitleBar Next")
assert_true(stub.fire(frame.PrevButton, "OnMouseWheel", 1), "PrevButton wheel up is wired")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "PrevButton wheel up turns Previous")
assert_eq(frame.Body:GetText(), "", "empty leaf body stays empty after PrevButton Previous")
assert_eq(sounds, 0, "chrome wheel turns play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "chrome wheel installs no OnUpdate")
assert_eq(#Book:GetPages(), 9, "chrome wheel is not a tenth page")

--------------------------------------------------------------------------------
-- Painted counts are roman. GetPages measures stay arabic.
--------------------------------------------------------------------------------
assert_eq(type(Book.toRoman), "function", "toRoman is a public helper")
if type(Book.toRoman) == "function" then
  assert_eq(Book.toRoman(14), "XIV", "14 paints as XIV")
  assert_eq(Book.toRoman(4), "IV", "4 paints as IV")
  assert_eq(Book.toRoman(9), "IX", "9 paints as IX")
  assert_eq(Book.toRoman(14), COB.Common.RomanNumeral(14), "toRoman(14) matches Common.RomanNumeral")
  assert_eq(Book.toRoman(0), "", "toRoman alias returns empty for 0")
  assert_eq(Book.toRoman(-1), "", "toRoman alias returns empty for negative")
  assert_eq(Book.toRoman(4000), "", "toRoman alias returns empty over 3999")
  assert_eq(Book.toRoman("14"), "", "toRoman alias returns empty for a string")
  assert_eq(Book.toRoman(nil), "", "toRoman alias returns empty for nil")
  assert_eq(Book.toRoman(14.9), "XIV", "toRoman alias floors then asks Common")
end

reset()
local high = char("Highbeef")
local foil14 = char("Foil")
for i = 1, 14 do
  bout(high, foil14, high, 9300 + i)
end
local fourteen = pageNamed("Most Sanctioned Victories")
assert_eq(fourteen.entries[1].wins, 14, "GetPages keeps the arabic measure")
assert_eq(fourteen.entries[1].name, "Highbeef", "the holder is Highbeef")
Book:Show()
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "open book starts on victories")
local romanBody = frame.Body:GetText() or ""
assert_true(romanBody:find("Highbeef", 1, true) ~= nil, "painted victories name the holder")
assert_true(romanBody:find("XIV", 1, true) ~= nil, "painted victories use roman XIV")
assert_eq(romanBody:find("XIV", 1, true) ~= nil and COB.Common.RomanNumeral(14) == "XIV", true,
  "14-win leaf renders Common roman XIV")
assert_eq(romanBody:find("14", 1, true), nil, "painted victories do not print raw 14")
assert_eq(romanBody:find("ordained", 1, true), nil, "painted body does not invent ordained prose")
assert_eq(frame.Medallion:IsShown(), true, "a holder shows the medallion slot")
assert_eq(frame.Medallion._cobTextureName, "seal_papal", "shown medallion stays seal_papal")
assert_eq(frame.Medallions[2]:IsShown(), false, "unused medallion slots stay hidden")

--------------------------------------------------------------------------------
-- Ribbon bookmarks jump only among existing Bible pages. Prev/next stay.
--------------------------------------------------------------------------------
reset()
local markA = char("MarkA")
local markB = char("MarkB")
bout(markA, markB, markA, 9400)
bout(markA, markB, markB, 9401)
bout(markA, markB, markA, 9402)
Book:Show()
local victoriesRibbon = buttonFor("Victories")
local rivalriesRibbon = buttonFor("Rivalries")
local martyrsRibbon = buttonFor("Martyrs")
assert_true(victoriesRibbon ~= nil, "Victories ribbon exists")
assert_true(rivalriesRibbon ~= nil, "Rivalries ribbon exists")
assert_true(martyrsRibbon ~= nil, "Martyrs ribbon exists")
assert_eq(buttonFor("Cowardice"), nil, "no invented Cowardice superlative ribbon")
if rivalriesRibbon then stub.fire(rivalriesRibbon, "OnClick") end
assert_eq(frame.PageTitle:GetText(), "Greatest Rivalry", "Rivalries lands on Greatest Rivalry")
local rivalryBody = frame.Body:GetText() or ""
assert_true(rivalryBody:find("II", 1, true) ~= nil, "rivalry score paints roman")
assert_eq(rivalryBody:find("2", 1, true), nil, "rivalry score does not print raw 2")
if martyrsRibbon then stub.fire(martyrsRibbon, "OnClick") end
assert_eq(frame.PageTitle:GetText(), "The Glorious Martyr", "Martyrs lands on The Glorious Martyr")
local prevFromMartyr = buttonFor("Previous")
assert_true(prevFromMartyr ~= nil, "Previous still exists beside ribbons")
if prevFromMartyr then stub.fire(prevFromMartyr, "OnClick") end
assert_eq(frame.PageTitle:GetText(), "The Undefeated", "Previous still turns a leaf")
if victoriesRibbon then stub.fire(victoriesRibbon, "OnClick") end
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "Victories lands on Most Sanctioned Victories")
assert_eq(sounds, 0, "ribbons play no sound")

--------------------------------------------------------------------------------
-- Right leaf: local-player honorifics + marked moment locations. Not a tenth page.
--------------------------------------------------------------------------------
reset()
assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
for i = 1, #BIBLE_TITLES do
  assert_eq(Book:GetPages()[i].title, BIBLE_TITLES[i], "identity paint does not rename page " .. i)
end
assert_eq(UnitName("player"), "Beefina", "stub local player is Beefina")
Store:FlagMoment("Shattrath", 10000)
Book:Show()
assert_true(frame.RightLeaf ~= nil, "right leaf still exists after paint")
assert_eq(frame.Honorifics:GetText(), "", "missing bind leaves honorifics blank")
assert_true((frame.Moments:GetText() or ""):find("Shattrath", 1, true) ~= nil,
  "unbound local player still paints marked-moment locations")
assert_eq((frame.Body:GetText() or ""):find("Shattrath", 1, true), nil,
  "moment locations are not painted on the superlative leaf")
assert_eq(#Book:GetPages(), 9, "FlagMoment does not add a tenth page")

reset()
local localHuman = Store:CreateHuman({ name = "Local" }, 11000)
local localChar = Store:CreateCharacter({ name = "Beefina" })
Store:LinkCharacter(localChar.id, localHuman.id, 11001)
Store:AddHonorific(localHuman.id, "Duke of the Fountain")
Store:AddHonorific(localHuman.id, "Defender of the Faith")
Store:FlagMoment("Goldshire Inn", 11002)
Book:Show()
assert_eq(#Book:GetPages(), 9, "seeded identity is not a tenth PAGE_TITLE")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "left leaf stays on superlatives")
local honors = frame.Honorifics:GetText() or ""
local marked = frame.Moments:GetText() or ""
local identity = honors .. "\n" .. marked
assert_true(honors:find("Duke of the Fountain", 1, true) ~= nil, "right leaf paints the granted honorific")
assert_true(honors:find("Defender of the Faith", 1, true) ~= nil, "right leaf lists honorifics as given")
assert_true(marked:find("Goldshire Inn", 1, true) ~= nil, "right leaf paints the marked location")
assert_eq(identity:find("ordained", 1, true), nil, "identity paint does not invent ordained prose")
assert_eq(identity:find("folk hero", 1, true), nil, "identity paint does not invent folk hero prose")
assert_eq(honors:find("II", 1, true), nil, "honorific text is titles, not a roman count")
assert_eq((frame.Body:GetText() or ""):find("Duke of the Fountain", 1, true), nil,
  "honorifics stay off the superlative leaf")
assert_eq((frame.Body:GetText() or ""):find("Goldshire Inn", 1, true), nil,
  "moment locations stay off the superlative leaf")

reset()
local unbound = Store:CreateCharacter({ name = "Beefina" })
local otherH = Store:CreateHuman({ name = "Other" }, 12000)
Store:AddHonorific(otherH.id, "Martyr of Goldshire")
assert_eq(unbound.humanId, nil, "local character is unbound")
Book:Show()
assert_eq(frame.Honorifics:GetText(), "", "unlinked local character paints no honorifics")
assert_eq((frame.Honorifics:GetText() or ""):find("Martyr of Goldshire", 1, true), nil,
  "another human's honorific is not borrowed")

--------------------------------------------------------------------------------
-- Right leaf: FlagMoment + scripture after location. PAGE_TITLES stay 9.
--------------------------------------------------------------------------------
-- Seed the scripture field. Use CanonizeMoment when Store already has it
-- (B7-A); otherwise Restore the field onto the marked-moment row.
local function seedScripture(momentId, text)
  if type(Store.CanonizeMoment) == "function" then
    return Store:CanonizeMoment(momentId, text)
  end
  local snap = Store:Snapshot()
  local list = snap and snap.markedMoments
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    if list[i] and list[i].id == momentId then
      list[i].scripture = text
      break
    end
  end
  return Store:Restore(snap)
end

reset()
assert_eq(#Book:GetPages(), #BIBLE_TITLES, "PAGE_TITLES stay the nine Bible titles")
for i = 1, #BIBLE_TITLES do
  assert_eq(Book:GetPages()[i].title, BIBLE_TITLES[i], "scripture paint does not rename page " .. i)
end
local canonLoc = Store:FlagMoment("Goldshire Inn", 13000)
assert_true(canonLoc ~= nil, "FlagMoment returns a marked row")
assert_true(seedScripture(canonLoc.id, "The fountain ran red") ~= nil, "scripture field is seeded")
Book:Show()
assert_eq(#Book:GetPages(), 9, "scripture is not a tenth PAGE_TITLE")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "left leaf stays on superlatives")
local canonPaint = frame.Moments:GetText() or ""
local locAt = canonPaint:find("Goldshire Inn", 1, true)
local scriptureAt = canonPaint:find("The fountain ran red", 1, true)
assert_true(locAt ~= nil, "right leaf still paints the marked location")
assert_true(scriptureAt ~= nil, "right leaf paints Pope scripture")
assert_true(locAt < scriptureAt, "scripture paints after the location")
assert_eq(canonPaint:find("ordained", 1, true), nil, "scripture paint does not invent ordained")
assert_eq(canonPaint:find("on this day", 1, true), nil, "scripture paint does not invent on-this-day copy")
assert_eq((frame.Body:GetText() or ""):find("The fountain ran red", 1, true), nil,
  "scripture stays off the superlative leaf")
assert_eq((frame.Honorifics:GetText() or ""):find("The fountain ran red", 1, true), nil,
  "scripture is not painted as an honorific")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness.
--------------------------------------------------------------------------------
reset()
Book:Show()
ChurchOfBeef._IN_TEST = false
assert_eq(Book:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Book:IsShown(), true, "out-of-harness reset does not hide the book")
ChurchOfBeef._IN_TEST = true
assert_eq(Book:ResetForTests(), true, "ResetForTests returns under _IN_TEST")
assert_eq(Book:IsShown(), false, "harness reset closes the book")

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
