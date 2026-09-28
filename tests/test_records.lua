-- Records Book — Lane C: chronicle-first records behind the player card.
-- Isolated: wow_ui_stub + Common + Theme + Ranks + Store + RecordsBook.
-- Player-opened Quiet identity/history. Theatrical parchment, not a sortable
-- ladder. The Home spread is retired — /beef is the player card; the book
-- opens on the Chronicle (dated ledger); superlatives exist only when
-- held. ESC/OnHide remount, wheel-on-chrome, resize persist, Theme dress,
-- leaf-caption roman, arabic superlative counts, and ink-discipline pins
-- are retained from the Lane G suite.
-- No TOC / bootstrap / run.lua / MainFrame / Console / Hud / Store / Net edits.
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
dofile("addon/ChurchOfBeef/Core/Records.lua")
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

-- Canonical §10.9 order. Superlative pages render only when held; the
-- Chronicle is always the first records page.
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

local function pageTitles()
  local pages = Book:GetPages()
  local titles = {}
  for i = 1, #pages do
    titles[i] = pages[i].title
  end
  return titles
end

local function chronicleLines()
  local page = pageNamed("Chronicle")
  if not page then return {} end
  return page.entries
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

local function fireButton(label)
  local btn = buttonFor(label)
  if not btn then return false end
  return stub.fire(btn, "OnClick")
end

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

-- Every painted string in the book, so removed surfaces can be proven absent.
local function collectText(widget, out, seen)
  if type(widget) ~= "table" or seen[widget] then return end
  seen[widget] = true
  if type(widget._text) == "string" then out[#out + 1] = widget._text end
  local kids = widget._children or {}
  for i = 1, #kids do collectText(kids[i], out, seen) end
  local regions = widget._regions or {}
  for i = 1, #regions do collectText(regions[i], out, seen) end
end

local function allText()
  local out = {}
  if Book.frame then collectText(Book.frame, out, {}) end
  return table.concat(out, "\n")
end

-- Visible Chronicle entry slots in paint order. The ledger paints one
-- FontString per entry on a fixed two-line stride; the body well carries
-- only the honest empty line. rawget: the strict stub hard-errors on
-- capitalized reads of absent fields, and a broken build may lack the pool.
local function paintedChronicle()
  local out = {}
  local book = Book.frame
  local slots = book and rawget(book, "ChronicleEntries")
  if type(slots) ~= "table" then return out end
  for i = 1, #slots do
    local slot = slots[i]
    if slot and slot.IsShown and slot:IsShown() then
      out[#out + 1] = slot:GetText() or ""
    end
  end
  return out
end

local function stamp(at)
  return os.date("%b %d", at)
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
assert_eq(type(Book.GetPages), "function", "records pages are inspectable without reading widgets")
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
-- Source contract: Theme dress only. No Media/font/texture paths. No generated
-- prose. No counters, no runtime state word, no marked-moment display.
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
assert_eq(src:find("local function maxHolders", 1, true), nil, "the book holds no superlative math")
assert_eq(src:find("local function longestWinStreak", 1, true), nil, "streak math lives in Core/Records")
assert_true(src:find("COB.Records", 1, true) ~= nil, "the book reads Core/Records")
assert_eq(src:find("scripture", 1, true), nil, "marked moments leave the book entirely")
assert_eq(src:find("GetMarkedMoments", 1, true), nil, "the book no longer reads marked moments")
assert_eq(src:find("momentLines", 1, true), nil, "the marked-moment line builder is gone")
assert_eq(src:find("COB.Runtime", 1, true), nil, "the card carries no runtime state word")
assert_eq(src:find("COB.Roster", 1, true), nil, "the card never reads the roster")
assert_eq(src:find("GetOccupantCount", 1, true), nil, "the card carries no roster count")
assert_eq(src:find("VictoriesRibbon", 1, true), nil, "fixed Victories shortcut tab is gone")
assert_eq(src:find("RivalriesRibbon", 1, true), nil, "fixed Rivalries shortcut tab is gone")
assert_eq(src:find("MartyrsRibbon", 1, true), nil, "fixed Martyrs shortcut tab is gone")
assert_eq(src:find('"CURRENT CHURCH STATE"', 1, true), nil, "state label copy is gone")
assert_eq(src:find('"LATEST CHRONICLE"', 1, true), nil, "latest-chronicle label copy is gone")
assert_eq(src:find('"THE CHRONICLE"', 1, true), nil, "archive metric-head copy is gone")
assert_eq(src:find('"GORAS"', 1, true), nil, "goras metric label is gone")
assert_eq(src:find('"MOMENTS"', 1, true), nil, "moments metric label is gone")
assert_eq(src:find('"ROSTER"', 1, true), nil, "roster metric label is gone")
assert_eq(src:find('"CEREMONIES"', 1, true), nil, "ceremonies metric label is gone")
assert_eq(src:find("leaderboard", 1, true), nil, "the book is not a leaderboard")
assert_eq(src:find("Grant", 1, true), nil, "the book does not Grant")
assert_true(src:find("GetCeremonyLog", 1, true) ~= nil, "the Chronicle reads Store:GetCeremonyLog")
assert_true(src:find('"Chronicle"', 1, true) ~= nil, "the Chronicle leaf exists")
assert_true(src:find('"Nothing has been written yet."', 1, true) ~= nil,
  "the empty Chronicle line is honest")
assert_true(src:find('Theme:FontPath', 1, true) ~= nil, "fonts resolve through Theme:FontPath")
assert_true(src:find('Theme:Color', 1, true) ~= nil, "colors resolve through Theme:Color")
assert_true(src:find('Theme:Texture', 1, true) ~= nil, "textures resolve through Theme:Texture")
assert_true(src:find('Theme.FontSize', 1, true) ~= nil, "sizes resolve through Theme.FontSize")
assert_true(src:find("local function themeFontSize", 1, true) ~= nil,
  "font sizes go through themeFontSize")
assert_true(src:find('applyFont(body, "GameFontNormal", "body", 14)', 1, true) ~= nil,
  "archive body uses the 14px legibility floor")
assert_true(src:find('applyFont(title, "GameFontNormalHuge", "display", 26)', 1, true) ~= nil,
  "chrome title uses the 26px ecclesiastical display face")
assert_true(src:find('applyFont(pageTitle, "GameFontNormalLarge", "label", 20)', 1, true) ~= nil,
  "page titles use the 20px label face")
assert_true(src:find('applyFont(fs, template or "GameFontNormal", "label", 14)', 1, true) ~= nil,
  "chrome labels use the 14px legibility floor")
assert_eq(src:find(', "body", 12)', 1, true), nil, "body no longer hardcodes applyFont 12")
assert_eq(src:find(', "label", 12)', 1, true), nil, "labels no longer hardcode applyFont 12")
assert_true(src:find("LeftLeafFill", 1, true) ~= nil, "left leaf has an opaque parchment underlay")
assert_true(src:find("RightLeafFill", 1, true) ~= nil, "right leaf has an opaque parchment underlay")
assert_true(src:find("frame.LeftLeafFill = leftFill", 1, true) ~= nil, "LeftLeafFill stays")
assert_true(src:find("frame.RightLeafFill = rightFill", 1, true) ~= nil, "RightLeafFill stays")
assert_true(src:find('fillRole(leftFill, "parchment", 1)', 1, true) ~= nil,
  "left fill stays opaque parchment")
assert_true(src:find('fillRole(rightFill, "parchment", 1)', 1, true) ~= nil,
  "right fill stays opaque parchment")
assert_true(src:find('"tome_records"', 1, true) ~= nil, "parchment uses Theme tome_records")
assert_eq(src:find("dressRibbon", 1, true), nil, "footer tabs are retired — no ribbon dress remains")
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
-- U-Q retained: no leftover one-off offsets; surfaces read Theme.Space.
assert_eq(src:find(", 6)", 1, true), nil, "no leftover 6px offset literal")
assert_eq(src:find(", 6,", 1, true), nil, "no leftover 6px inset literal")
assert_eq(src:find(", 10)", 1, true), nil, "no leftover 10px offset literal")
assert_eq(src:find(", 10,", 1, true), nil, "no leftover 10px inset literal")
assert_true(src:find("local CHRONICLE_STRIDE = CHRONICLE_LINE_PX * 2", 1, true) ~= nil,
  "the chronicle per-entry stride is defined as the two-line value, not a bare number")

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
-- rawget: the strict stub hard-errors on capitalized reads of absent fields,
-- and these pins must observe absence, not trip the policer.
assert_eq(rawget(frame, "Moments"), nil, "marked-moments text leaves the book")
assert_eq(rawget(frame, "MomentsHeading"), nil, "marked-moments heading leaves the book")
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
-- Chronicle ledger slots: a fixed pool created once, one FontString per entry
-- on a fixed two-line stride. Guarded so a missing pool fails here without
-- aborting the rest of the suite.
local chronicleSlots = rawget(frame, "ChronicleEntries")
assert_true(type(chronicleSlots) == "table", "the Chronicle leaf has a fixed entry slot pool")
if type(chronicleSlots) == "table" then
  assert_eq(#chronicleSlots, 14, "the pool holds the two-line entries that fit both leaves")
  for i = 1, #chronicleSlots do
    local slot = chronicleSlots[i]
    assert_eq(slot:IsShown(), false, "chronicle entry slot " .. i .. " starts hidden")
    assert_eq(slot._maxLines, 2, "chronicle entry slot " .. i .. " wraps at most once inside its stride")
    assert_eq(slot._wordWrap, true, "chronicle entry slot " .. i .. " word-wraps inside the column")
    assert_eq(slot._cobFontRole, "body", "chronicle entry slot " .. i .. " uses the Theme body role")
    assert_eq(slot._cobFontSize, 14, "chronicle entry slot " .. i .. " keeps the 14px legibility floor")
    assert_eq(slot._cobColorRole, "charcoal", "chronicle entry slot " .. i .. " is charcoal ink on parchment")
    local point, relTo, relPoint, x, y = slot:GetPoint(1)
    assert_eq(point, "TOPLEFT", "chronicle entry slot " .. i .. " hangs from its leaf column top")
    if i <= 7 then
      assert_eq(relTo, frame.Body, "chronicle entry slot " .. i .. " anchors to the body column")
      assert_eq(x, 0, "chronicle entry slot " .. i .. " keeps the body column inset")
      assert_eq(y, -(i - 1) * 44,
        "chronicle entry slot " .. i .. " sits on the fixed two-line stride (2 × 22px at the 14px face)")
    else
      assert_eq(relTo, frame.RightLeaf, "chronicle entry slot " .. i .. " anchors to the right leaf")
    end
  end
end
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
assert_true(frame.TitleBand ~= nil, "chrome title sits on a dark band")
assert_eq(frame.TitleBand._cobColorRole, "charcoal", "title band is Theme charcoal")
assert_eq(frame.FooterBand._cobColorRole, "charcoal", "footer band is Theme charcoal")
assert_eq(frame.TitleText._cobFontRole, "display", "chrome title uses the ecclesiastical display role")
assert_eq(frame.PageTitle._cobFontRole, "label", "page title uses Theme label role")
assert_eq(frame.PageTitle._cobColorRole, "oxblood", "page title uses Theme oxblood")
assert_eq(frame.PageTitle._cobColor.r, select(1, COB.Theme:Color("oxblood")), "page title r is Theme oxblood")
assert_eq(frame.Body._cobFontRole, "body", "body uses Theme body role")
assert_eq(frame.Body._cobColorRole, "charcoal", "body ink uses Theme charcoal")
assert_eq(frame.Body._cobColor.r, select(1, COB.Theme:Color("charcoal")), "body r is Theme charcoal")
assert_eq(frame.TitleText._cobColorRole, "gold", "chrome title is gold on the charcoal band")
assert_eq(frame.Body._cobFontSize, 14, "body meets the in-client 14px legibility floor")
assert_eq(frame.TitleText._cobFontSize, 26, "chrome title is a readable 26px display face")
assert_eq(frame.PageTitle._cobFontSize, 20, "page title is a readable 20px serif")
assert_true(frame.LeftLeafFill ~= nil, "left leaf fill exists")
assert_true(frame.RightLeafFill ~= nil, "right leaf fill exists")
assert_eq(frame.LeftLeafFill._cobColorRole, "parchment", "left leaf fill is Theme parchment")
assert_eq(frame.RightLeafFill._cobColorRole, "parchment", "right leaf fill is Theme parchment")
assert_eq(frame.LeftLeafFill._cobColor.a, 1, "left leaf fill is opaque")
assert_eq(frame.RightLeafFill._cobColor.a, 1, "right leaf fill is opaque")
assert_eq(frame.TitleText._cobFontPath, COB.Theme:FontPath("display"), "chrome title path is Theme display")
assert_eq(frame.Body._cobFontPath, COB.Theme:FontPath("body"), "body path is Theme body")
assert_eq(rawget(frame, "VictoriesRibbon"), nil, "no fixed Victories shortcut ribbon")
assert_eq(rawget(frame, "RivalriesRibbon"), nil, "no fixed Rivalries shortcut ribbon")
assert_eq(rawget(frame, "MartyrsRibbon"), nil, "no fixed Martyrs shortcut ribbon")
assert_eq(frame.PrevButton._cobPlateRole, "charcoal", "Previous sits on a dark plate")
assert_eq(frame.PrevButton._cobStockTemplate, "UIPanelButtonTemplate",
  "Previous is a stock panel button")
assert_eq(frame.NextButton._cobPlateRole, "charcoal", "Next sits on a dark plate")
assert_eq(frame.NextButton._cobStockTemplate, "UIPanelButtonTemplate",
  "Next is a stock panel button")
assert_eq(frame.CloseButton._cobClose, true, "Close is the shared window X")
assert_eq(frame.CloseButton:GetWidth(), COB.Theme.CloseSize, "Close is stock width")
assert_eq(frame.CloseButton:GetHeight(), COB.Theme.CloseSize, "Close is stock height")
assert_eq(frame.CloseButton:GetNormalTexture(), COB.Theme:Texture("close_up"),
  "Close uses the stock X")
assert_eq(frame:GetWidth(), 680, "unknown UIParent width uses the focused dashboard width")
assert_eq(frame:GetHeight(), 520, "unknown UIParent height uses the focused dashboard height")
assert_eq(buttonFor("Search"), nil, "no search box chrome")
assert_eq(stub.findChild(frame, function(child)
  return child._type == "EditBox"
end), nil, "no search EditBox")
assert_eq(buttonFor("Ladder"), nil, "no Ladder chrome")
assert_eq(buttonFor("My Standing"), nil, "no Standing chrome")
assert_eq(buttonFor("Sort"), nil, "no Sort control")
assert_eq(buttonFor("#1"), nil, "no #1 rating control")
assert_eq(buttonFor("Grant"), nil, "no Grant control")
assert_eq(buttonFor("RECORDS"), nil, "no fixed Victories shortcut tab")
assert_eq(buttonFor("RIVALRIES"), nil, "no fixed Rivalries shortcut tab")
assert_eq(buttonFor("MARTYRS"), nil, "no fixed Martyrs shortcut tab")
assert_true(frame.PrevButton ~= nil, "footer has a Previous control")
assert_true(frame.NextButton ~= nil, "footer has a Next control")
assert_true(UISpecialFrames[1] == "ChurchOfBeefRecordsBook" or (function()
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == "ChurchOfBeefRecordsBook" then return true end
  end
  return false
end)(), "Escape can close the book")

--------------------------------------------------------------------------------
-- The Home spread is retired: /beef is the player card. The book is records
-- only — it opens on the Chronicle and carries no identity or Decree leaf.
--------------------------------------------------------------------------------
assert_eq(Book.ShowHome, nil, "the book has no Home spread — /beef is the player card")
assert_eq(Book.ToggleHome, nil, "no ToggleHome")
assert_eq(Book.GetOverview, nil, "no overview model — identity lives on the player card")
assert_eq(type(Book.ShowFromCard), "function", "the card opens the book on a return path")
assert_eq(type(Book.Dismiss), "function", "the card can dismiss the book without bouncing")
assert_eq(type(Book.ReturnToCard), "function", "Back returns to the player card")
Book:Show()
assert_eq(Book.frame.PageTitle:GetText(), "Chronicle", "Show opens on the Chronicle")
assert_eq(rawget(Book.frame, "OverviewWidgets"), nil, "no overview widgets")
assert_eq(rawget(Book.frame, "IdentityTitle"), nil, "no identity leaf — the card owns identity")
assert_eq(rawget(Book.frame, "Honorifics"), nil, "no honorifics leaf")
assert_eq(allText():find("Your Record", 1, true), nil, "the book never says Your Record")
assert_eq(allText():find("THE DECREE", 1, true), nil, "the book never paints the Decree block")

--------------------------------------------------------------------------------
-- Init/Hide/Show remount a missing OnHide and re-list UISpecialFrames without
-- rebuilding, resetting pageIndex, or playing sound. (B25-C / B28-C / B38-D /
-- B40-B / B41-B retained.)
--------------------------------------------------------------------------------
local function runRemountSourcePins()
  local earlyInit = src:match("function RecordsBook:Init%(%)%s*\n%s*if self%.frame then(.-)return self%.frame")
  assert_true(type(earlyInit) == "string" and earlyInit ~= "",
    "Init early-return body is readable")
  assert_true(earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "early-return rememberSpecial FRAME_NAME")
  assert_true(earlyInit:find("wireBookOnHide", 1, true) ~= nil,
    "Init remounts OnHide via wireBookOnHide")
  local wireAt = earlyInit:find("wireBookOnHide", 1, true)
  local remountAt = earlyInit:find("rememberSpecial(FRAME_NAME)", 1, true)
  assert_true(type(wireAt) == "number" and type(remountAt) == "number" and wireAt < remountAt,
    "Init remounts OnHide before rememberSpecial")
  assert_eq(earlyInit:find("buildFrame", 1, true), nil, "early-return does not rebuild")
  assert_eq(earlyInit:find("CreateFrame", 1, true), nil, "Init does not CreateFrame")
  assert_eq(earlyInit:find("PlaySound", 1, true), nil, "early-return does not PlaySound")
  assert_eq(earlyInit:find("SetScript", 1, true), nil, "Init does not SetScript inline")
  assert_eq(earlyInit:find("OnShow", 1, true), nil, "Init does not re-wire OnShow")
  assert_eq(earlyInit:find("pageIndex", 1, true), nil, "Init does not reset pageIndex")
  assert_eq(earlyInit:find("paint()", 1, true), nil, "Init remount does not paint")
  assert_eq(earlyInit:find(":Show()", 1, true), nil, "Init remount does not Show")
  assert_eq(earlyInit:find(":Hide()", 1, true), nil, "Init remount does not Hide")

  local hideBody = src:match("function RecordsBook:Hide%(%)(.-)function RecordsBook:Toggle")
  assert_true(type(hideBody) == "string" and hideBody ~= "", "Hide body is readable")
  local hideWireAt = hideBody:find("wireBookOnHide", 1, true)
  local hideRemountAt = hideBody:find("rememberSpecial(FRAME_NAME)", 1, true)
  local hideAt = hideBody:find("self.frame:Hide()", 1, true)
  assert_true(hideWireAt ~= nil, "Hide remounts OnHide via wireBookOnHide")
  assert_true(hideRemountAt ~= nil, "Hide remount rememberSpecial FRAME_NAME")
  assert_true(hideAt ~= nil, "Hide still calls self.frame:Hide()")
  assert_true(hideWireAt < hideRemountAt, "Hide remounts OnHide before rememberSpecial")
  assert_true(hideRemountAt < hideAt, "Hide remounts rememberSpecial before frame:Hide()")
  assert_eq(hideBody:find("buildFrame", 1, true), nil, "Hide does not rebuild")
  assert_eq(hideBody:find("CreateFrame", 1, true), nil, "Hide does not CreateFrame")
  assert_eq(hideBody:find("PlaySound", 1, true), nil, "Hide does not PlaySound")
  assert_eq(hideBody:find("SetScript", 1, true), nil, "Hide does not SetScript inline")
  assert_eq(hideBody:find("OnShow", 1, true), nil, "Hide does not re-wire OnShow")
  assert_eq(hideBody:find("pageIndex", 1, true), nil, "Hide does not reset pageIndex")
  assert_eq(hideBody:find(":Show()", 1, true), nil, "Hide remount does not Show")

  local showBody = src:match("function RecordsBook:Show%(%)(.-)function RecordsBook:Hide")
  assert_true(type(showBody) == "string" and showBody ~= "", "Show body is readable")
  local showWireAt = showBody:find("wireBookOnHide", 1, true)
  local paintAt = showBody:find("paint()", 1, true)
  local showAt = showBody:find("frame:Show()", 1, true)
  assert_true(showWireAt ~= nil, "Show remounts OnHide via wireBookOnHide")
  assert_true(paintAt ~= nil, "Show still paints")
  assert_true(showAt ~= nil, "Show still calls frame:Show()")
  assert_true(showWireAt < paintAt, "Show remounts OnHide before paint")
  assert_true(paintAt < showAt, "Show paints before frame:Show()")
  assert_eq(showBody:find("SetScript", 1, true), nil, "Show does not SetScript inline")
  assert_eq(showBody:find("OnShow", 1, true), nil, "Show does not re-wire OnShow")
  -- Show's only pageIndex touch is the stale-index clamp onto the first leaf
  -- (`if pageIndex < 1 then pageIndex = 1 end` — two mentions). Anything more
  -- is a reset.
  local _, showPageIndexMentions = showBody:gsub("pageIndex", "")
  assert_eq(showPageIndexMentions, 2, "Show does not reset pageIndex")
  assert_eq(showBody:find("buildFrame", 1, true), nil, "Show remount does not rebuild")
  assert_eq(showBody:find("PlaySound", 1, true), nil, "Show remount does not PlaySound")

  assert_true(src:find("local function wireBookOnHide", 1, true) ~= nil,
    "source extracts wireBookOnHide")
  local wireBook = src:match("local function wireBookOnHide%(widget%)(.-)\nlocal function uiSlot")
  assert_true(type(wireBook) == "string" and wireBook ~= "", "wireBookOnHide body is readable")
  assert_true(wireBook:find("GetScript", 1, true) ~= nil, "wireBookOnHide checks GetScript")
  assert_true(wireBook:find("SetScript", 1, true) ~= nil, "wireBookOnHide holds SetScript")
  assert_true(wireBook:find("OnHide", 1, true) ~= nil, "wireBookOnHide wires OnHide")
  assert_true(wireBook:find("if existing then return", 1, true) ~= nil,
    "wireBookOnHide does not replace an existing OnHide")
  assert_true(wireBook:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "OnHide remounts rememberSpecial FRAME_NAME")
  assert_eq(wireBook:find("pageIndex", 1, true), nil, "wireBookOnHide does not reset pageIndex")
  assert_eq(wireBook:find("OnShow", 1, true), nil, "wireBookOnHide does not wire OnShow")
  assert_eq(wireBook:find("CreateFrame", 1, true), nil, "wireBookOnHide does not rebuild")
  assert_eq(wireBook:find("buildFrame", 1, true), nil, "wireBookOnHide does not call buildFrame")

  local buildBody = src:match("local function buildFrame%(%)(.-)\nfunction RecordsBook:ResetForTests")
  assert_true(type(buildBody) == "string" and buildBody ~= "", "buildFrame body is readable")
  local hideInBuild = buildBody:find("frame:Hide()", 1, true)
  local wireInBuild = buildBody:find("wireBookOnHide", 1, true)
  assert_true(hideInBuild ~= nil, "create-path still has create-time Hide")
  assert_true(wireInBuild ~= nil, "create-path uses wireBookOnHide")
  assert_true(type(hideInBuild) == "number" and type(wireInBuild) == "number"
      and hideInBuild < wireInBuild,
    "create-path wires OnHide after create-time Hide")
  assert_eq(buildBody:find('SetScript("OnHide"', 1, true), nil,
    "create-path does not SetScript OnHide inline")

  assert_true(src:find("local function rememberSpecial", 1, true) ~= nil,
    "rememberSpecial helper stays")
  assert_true(src:find('FRAME_NAME = "ChurchOfBeefRecordsBook"', 1, true) ~= nil,
    "FRAME_NAME stays ChurchOfBeefRecordsBook")
  assert_true(src:find("rememberSpecial(FRAME_NAME)", 1, true) ~= nil,
    "buildFrame still rememberSpecial FRAME_NAME")
end
runRemountSourcePins()

local function runRemountBehavior()
  reset()
  local a = char("RemountA")
  local b = char("RemountB")
  bout(a, b, a, 1500)
  Book:Init()
  local existing = Book.frame
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "first-create uniqueness: ChurchOfBeefRecordsBook once before wipe")

  -- Init early-return re-lists after a wiped UISpecialFrames.
  local savedSpecial = UISpecialFrames
  UISpecialFrames = {}
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 0, "wipe clears ChurchOfBeefRecordsBook")
  local cuesWipe = sounds
  local same = Book:Init()
  assert_eq(same, existing, "second Init returns the existing frame")
  assert_eq(Book.frame, existing, "early-return does not rebuild")
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "wiped UISpecialFrames + second Init lists ChurchOfBeefRecordsBook once")
  assert_eq(sounds, cuesWipe, "second Init plays no sound")
  Book:Init()
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "third Init after wipe does not duplicate ChurchOfBeefRecordsBook")
  UISpecialFrames = savedSpecial

  -- Hide remounts after a wipe; Toggle-while-shown is Hide.
  assert_eq(Book:Show(), true, "Show opens for the remount walk")
  local nextBtn = existing.NextButton
  assert_true(nextBtn ~= nil, "Next leaf control exists")
  stub.fire(nextBtn, "OnClick")
  assert_eq(existing.PageTitle:GetText(), "Most Sanctioned Victories",
    "turned to the first held leaf before remount")
  UISpecialFrames = {}
  local cuesHide = sounds
  assert_eq(Book:Hide(), true, "Hide succeeds")
  assert_eq(Book.frame, existing, "Hide does not rebuild")
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "wiped UISpecialFrames + Hide lists ChurchOfBeefRecordsBook once")
  assert_eq(sounds, cuesHide, "Hide plays no sound")
  Book:Hide()
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "second Hide after wipe does not duplicate ChurchOfBeefRecordsBook")

  Book:Show()
  assert_eq(Book:IsShown(), true, "Show opens for Toggle")
  UISpecialFrames = {}
  assert_eq(Book:Toggle(), true, "Toggle-while-shown succeeds")
  assert_eq(Book:IsShown(), false, "Toggle-while-shown hides")
  assert_eq(Book.frame, existing, "Toggle-while-shown does not rebuild")
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "wiped UISpecialFrames + Toggle-while-shown lists ChurchOfBeefRecordsBook once")
  assert_eq(sounds, cuesHide, "Toggle-while-shown plays no sound")

  -- Existing-frame Show / Hide remount a missing OnHide; never replace it.
  UISpecialFrames = {}
  existing:SetScript("OnHide", nil)
  assert_eq(existing:GetScript("OnHide"), nil, "OnHide niled before Show")
  local remountCreates = 0
  local savedCreate = CreateFrame
  CreateFrame = function(...)
    remountCreates = remountCreates + 1
    return savedCreate(...)
  end
  assert_eq(Book:Show(), true, "Show after wipe")
  CreateFrame = savedCreate
  local restored = existing:GetScript("OnHide")
  assert_true(restored ~= nil, "Show remounts missing OnHide")
  assert_eq(existing:IsShown(), true, "Show opens the book")
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1, "ChurchOfBeefRecordsBook re-listed once")
  assert_eq(remountCreates, 0, "Show remount does not rebuild")
  assert_eq(existing.PageTitle:GetText(), "Most Sanctioned Victories",
    "Show does not reset pageIndex")
  Book:Show()
  assert_eq(existing:GetScript("OnHide"), restored, "second Show does not replace OnHide")
  assert_eq(existing.PageTitle:GetText(), "Most Sanctioned Victories",
    "second Show still does not reset pageIndex")

  assert_eq(Book:Hide(), true, "Hide succeeds")
  assert_eq(existing:GetScript("OnHide"), restored, "Hide does not replace OnHide")
  assert_eq(Book:IsShown(), false, "Hide closes the book")
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1, "Hide does not duplicate the listing")
  Book:Hide()
  assert_eq(existing:GetScript("OnHide"), restored, "third Hide does not replace OnHide")

  -- Existing-frame Init remounts a missing OnHide.
  Book:Show()
  UISpecialFrames = {}
  existing:SetScript("OnHide", nil)
  local remounted = Book:Init()
  assert_eq(remounted, existing, "Init remount returns the existing frame")
  assert_true(existing:GetScript("OnHide") ~= nil, "Init remounts missing OnHide")
  assert_eq(existing:IsShown(), true, "Init remount does not close the book")
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1, "Init re-listed once")
  assert_eq(existing:GetScript("OnShow"), nil, "Init remount does not wire OnShow")
  Book:Init()
  assert_eq(existing:GetScript("OnHide") ~= nil, true, "third Init keeps the remount")
  assert_eq(countSpecial("ChurchOfBeefRecordsBook"), 1,
    "third Init does not duplicate UISpecialFrames")
  assert_eq(Book:GetPages()[1].title, "Chronicle", "remounts do not move the Chronicle")
  UISpecialFrames = savedSpecial
end
runRemountBehavior()

--------------------------------------------------------------------------------
-- paint() re-applies the page-turn faces on PageTitle / TitleText (B30-C /
-- B31-D retained), and keeps the Records Book masthead on every leaf.
--------------------------------------------------------------------------------
local function runPaintReapply()
  local paintAt = src:find("local function paint(", 1, true)
  assert_true(paintAt ~= nil, "paint exists")
  local paintEnd = src:find("\nlocal function turn(", paintAt + 1, true)
  assert_true(paintEnd ~= nil, "paint body has a following turn")
  local paintBody = src:sub(paintAt, paintEnd - 1)
  local applyAt = paintBody:find(
    'applyFont(frame.PageTitle, "GameFontNormalLarge", "label", 20)',
    1, true)
  local setAt = paintBody:find("frame.PageTitle:SetText", 1, true)
  assert_true(applyAt ~= nil and setAt ~= nil and applyAt < setAt,
    "paint re-applies the page-title face on PageTitle before SetText")
  local titleApplyAt = paintBody:find(
    'applyFont(frame.TitleText, "GameFontNormalHuge", "display", 26)',
    1, true)
  assert_true(titleApplyAt ~= nil, "paint re-applies the display face on TitleText")
  assert_true(paintBody:find('frame.TitleText:SetText("The Records Book")', 1, true) ~= nil,
    "archive paint restores the Records Book title after the card masthead")
  assert_true(paintBody:find('applyInk(frame.PageTitle, "oxblood")', 1, true) ~= nil,
    "paint keeps page titles oxblood")
  assert_true(paintBody:find('applyInk(frame.TitleText, "gold")', 1, true) ~= nil,
    "paint keeps the chrome title gold")
  assert_true(paintBody:find('applyInk(frame.Body, "charcoal")', 1, true) ~= nil,
    "paint keeps the body charcoal")
  assert_eq(paintBody:find('("display", 20)', 1, true), nil,
    "paint never puts the 20px display face on a page title")
  assert_eq(paintBody:find("PlaySound", 1, true), nil, "paint does not PlaySound")
  assert_eq(paintBody:find("CreateFrame", 1, true), nil, "paint does not CreateFrame medallion rows")
  assert_eq(paintBody:find("CreateTexture", 1, true), nil, "paint does not CreateTexture medallion rows")
  assert_true(paintBody:find("dressMedallion", 1, true) ~= nil, "paint dresses existing medallion slots")

  reset()
  Book:Show()
  assert_eq(frame.PageTitle:GetText(), "Chronicle", "the book opens on the Chronicle leaf")
  assert_eq(frame.TitleText:GetText(), "The Records Book", "records leaves keep the book masthead")
  assert_eq(src:find("PlaySound", 1, true), nil, "source still does not play sound")
end
runPaintReapply()

--------------------------------------------------------------------------------
-- U-H / U-Q / U-R retained: Theme dress, Common roman wrapper, fixed medallion
-- pool, leaf geometry, grip resize + clamps.
--------------------------------------------------------------------------------
local function runDress()
  assert_true(COB.Theme ~= nil, "Theme is loaded")
  assert_true(type(COB.Common.RomanNumeral) == "function", "Common.RomanNumeral exists")
  assert_eq(Book.toRoman(14), "XIV", "toRoman(14) is XIV")
  assert_eq(Book.toRoman(14), COB.Common.RomanNumeral(14), "toRoman wraps Common")
  assert_eq(Book.toRoman(0), "", "toRoman empty on 0")
  assert_eq(Book.toRoman(nil), "", "toRoman empty on nil")
  assert_eq(Book.toRoman(14.9), "XIV", "toRoman floors then asks Common")
  assert_true(src:find("local MEDALLION_POOL = 8", 1, true) ~= nil,
    "medallion pool size is a create-time constant")
  assert_true(src:find("frame.Medallion = frame.Medallions[1]", 1, true) ~= nil,
    "Medallion aliases the first pool slot")

  -- U-Q retained: create-time page-title ink is oxblood, never charcoal.
  local buildBody = src:match("local function buildFrame%(%)(.-)\nfunction RecordsBook:ResetForTests")
  assert_true(type(buildBody) == "string" and buildBody ~= "", "buildFrame body is readable")
  assert_true(buildBody:find('applyInk(pageTitle, "oxblood")', 1, true) ~= nil,
    "create-time page title ink is oxblood")
  assert_eq(buildBody:find('applyInk(frame.PageTitle, "charcoal")', 1, true), nil,
    "create-time page title is never charcoal")

  local function gutterX(tex, pointName)
    if not tex or type(tex.GetNumPoints) ~= "function" then return nil end
    for i = 1, tex:GetNumPoints() do
      local p, _, relP, x = tex:GetPoint(i)
      if p == pointName and relP == "CENTER" then return x end
    end
    return nil
  end

  Book:Init()
  local tome = Book.frame
  assert_true(tome ~= nil, "Init so the frame exists")
  assert_eq(gutterX(tome.LeftLeafFill, "RIGHT"), -1, "left fill meets center at -1")
  assert_eq(gutterX(tome.Parchment, "RIGHT"), -1, "left leaf meets center at -1")
  assert_eq(gutterX(tome.RightLeafFill, "LEFT"), 1, "right fill meets center at +1")
  assert_eq(gutterX(tome.RightLeaf, "LEFT"), 1, "right leaf meets center at +1")
  assert_eq(tome.GoldEdge._cobColorRole, "gold", "GoldEdge stays gold")
  assert_eq(tome.TitleBand._cobColorRole, "charcoal", "title board stays")
  assert_eq(tome.FooterBand._cobColorRole, "charcoal", "footer board stays")
  assert_eq(tome.PageTitle._cobColorRole, "oxblood", "page title stays oxblood")
  assert_eq(tome.Body._cobColorRole, "charcoal", "body stays charcoal")
  assert_eq(tome.TitleText._cobColorRole, "gold", "chrome title stays gold")
  assert_eq(Book:GetPages()[1].title, "Chronicle", "dress is not a new page")
end
runDress()

local function runResize()
  Book:Init()
  local tome = Book.frame
  assert_true(tome ~= nil, "Init so the frame exists")
  assert_eq(tome:GetWidth(), 680, "unknown UIParent keeps the focused tome width")
  assert_eq(tome:GetHeight(), 520, "unknown UIParent keeps the focused tome height")
  assert_true(tome.SizeGrip ~= nil, "Records Book has a size grip")
  assert_eq(tome:IsEventRegistered("DISPLAY_SIZE_CHANGED"), true,
    "Records Book re-clamps on display size")
  assert_eq(tome:IsEventRegistered("UI_SCALE_CHANGED"), true,
    "Records Book re-clamps on uiScale")
  tome:SetWidth(800)
  tome:SetHeight(510)
  stub.fire(tome, "OnSizeChanged")
  assert_eq(tome:GetWidth(), 800, "tome grows with the grip")
  assert_eq(tome:GetHeight(), 510, "tome height follows a legal resize")
  tome:SetWidth(200)
  tome:SetHeight(100)
  stub.fire(tome, "OnSizeChanged")
  assert_eq(tome:GetWidth(), 620, "tome width clamps to the readable floor")
  assert_eq(tome:GetHeight(), 500, "tome height clamps to the readable floor")
  stub.fire(tome.SizeGrip, "OnMouseDown", "RightButton")
  assert_eq(tome:GetWidth(), 680, "right-click grip restores default width")
  assert_eq(tome:GetHeight(), 520, "right-click grip restores default height")
end
runResize()

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
-- Empty store: the Chronicle is the only records page. One honest line.
--------------------------------------------------------------------------------
reset()
local emptyTitles = pageTitles()
assert_eq(#emptyTitles, 1, "an empty archive has only the Chronicle leaf")
assert_eq(emptyTitles[1], "Chronicle", "the Chronicle is always the first records page")
assert_eq(#chronicleLines(), 0, "an empty archive has no chronicle lines")
assert_eq(pageNamed("Tournament Champions"), nil, "Tournament Champions does not exist without data")
assert_eq(pageNamed("Most Sanctioned Victories"), nil, "unheld superlatives do not exist")
assert_eq(pageNamed("Famous Upsets"), nil, "unflagged empty store has no Famous Upsets page")
assert_eq(pageNamed("The Undefeated"), nil, "no unbeaten page without records")
assert_eq(pageNamed("Most Successful Defenses"), nil, "empty store has no defenses page")

Book:Show()
assert_eq(frame.PageTitle:GetText(), "Chronicle", "the book opens on the Chronicle")
assert_eq(frame.Body:GetText(), "Nothing has been written yet.", "empty Chronicle state is honest")
assert_eq(frame.Medallion:IsShown(), false, "empty leaf hides the medallion slot")
assert_eq(frame.PrevButton:IsShown(), false, "Previous hides when the Chronicle stands alone")
assert_eq(frame.NextButton:IsShown(), false, "Next hides when the Chronicle stands alone")
assert_eq(sounds, 0, "painting an empty book is silent")

--------------------------------------------------------------------------------
-- Chronicle lines: type-routed record lines, newest first, dated when the
-- wall stamp is a number. Never narration (Law 4).
--------------------------------------------------------------------------------
local function runChronicleFormats()
  reset()
  local human = Store:CreateHuman({ name = "Chuck" }, 100)
  local knight = char("Chuckroast", "Warrior")
  local mage = char("Tendermage", "Mage")
  Store:LinkCharacter(knight.id, human.id, 101)

  Store:AppendCeremony("Knighting", { human.id }, 1700000000)
  Store:AppendCeremony("Elevation", { human.id }, 1700000100)
  Store:AppendCeremony("victor", { knight.id, mage.id }, 1700000200)
  Store:AppendCeremony("victor", { knight.id, 9999 }, 1700000300)
  Store:AppendCeremony("cowardice", { mage.id, knight.id }, 1700000400)
  Store:AppendCeremony("cowardice", { 9999, knight.id }, 1700000500)
  Store:AppendCeremony("void", { knight.id, mage.id }, 1700000600)
  Store:AppendCeremony("void", { 9998, 9999 }, 1700000700)
  Store:AppendCeremony("free", { knight.id, mage.id }, 1700000800, "The ring was fouled.")
  Store:AppendCeremony("free", { knight.id, mage.id }, 1700000900)
  Store:AppendCeremony("Recognition", { knight.id, human.id }, 1700001000)
  Store:AppendCeremony("Canonization", { human.id }, 1700001100)
  Store:AppendCeremony("Canonization", {}, 1700001200)

  local lines = chronicleLines()
  assert_eq(#lines, 13, "every log row renders one dated line")
  assert_eq(lines[13], stamp(1700000000) .. " — Chuck was Knighted.",
    "Knighting names the human, oldest last")
  assert_eq(lines[12], stamp(1700000100) .. " — Chuck rose to Beef Lord.",
    "Elevation names the human")
  assert_eq(lines[11], stamp(1700000200) .. " — Chuckroast declared victor over Tendermage.",
    "victor names winner over loser")
  assert_eq(lines[10], stamp(1700000300) .. " — Chuckroast declared victor.",
    "victor degrades when the second fighter is missing")
  assert_eq(lines[9], stamp(1700000400) .. " — Cowardice recorded: Tendermage.",
    "cowardice names the fleeing fighter")
  assert_eq(lines[8], stamp(1700000500) .. " — Cowardice recorded.",
    "cowardice degrades without a name")
  assert_eq(lines[7], stamp(1700000600) .. " — A bout was voided: Chuckroast, Tendermage.",
    "void names the fighters when they resolve")
  assert_eq(lines[6], stamp(1700000700) .. " — A bout was voided.",
    "void stands alone when no fighter resolves")
  assert_eq(lines[5], stamp(1700000800) .. " — Free ruling: The ring was fouled.",
    "free ruling carries the Pope's text")
  assert_eq(lines[4], stamp(1700000900) .. " — Free ruling.",
    "free ruling without text is the bare record")
  assert_eq(lines[3], stamp(1700001000) .. " — Recognition: Chuckroast, Chuck.",
    "Recognition resolves character-then-human")
  assert_eq(lines[2], stamp(1700001100) .. " — Canonization.",
    "an id resolving as both character and human names no one (type token alone)")
  assert_eq(lines[1], stamp(1700001200) .. " — Canonization.",
    "unknown type with no names is the bare type token, newest first")

  Book:Show()
  assert_eq(frame.PageTitle:GetText(), "Chronicle", "the Chronicle is the first leaf")
  -- The ledger paints one FontString per entry on a fixed two-line stride;
  -- thirteen seeded rows fit the fourteen-slot two-leaf pool, so every row
  -- paints. The body well carries nothing while entries show.
  local painted = paintedChronicle()
  assert_eq(#painted, 13, "the ledger paints every seeded row across both leaves")
  assert_eq(painted[1], lines[1], "the newest line paints first")
  assert_eq(painted[13], lines[13], "the oldest seeded row paints last")
  local well = table.concat(painted, "\n")
  assert_true(well:find("Recognition: Chuckroast, Chuck.", 1, true) ~= nil,
    "the Chronicle paints the Recognition")
  assert_true(well:find("Chuck was Knighted.", 1, true) ~= nil,
    "the fourteen-slot pool holds the whole seeded ledger")
  assert_eq(well:find("ordained", 1, true), nil, "the Chronicle does not invent ordained prose")
  assert_eq(well:find("folk hero", 1, true), nil, "the Chronicle does not invent folk hero prose")
  assert_eq(frame.Body:GetText(), "", "a written ledger leaves the body well to the entry slots")
  for i = 1, #frame.Medallions do
    assert_eq(frame.Medallions[i]:IsShown(), false,
      "the ledger leaf shows no medallion (slot " .. i .. ")")
  end
  assert_eq(sounds, 0, "painting the Chronicle is silent")
end
runChronicleFormats()

--------------------------------------------------------------------------------
-- Knighting sittings: one Chronicle line per tranche, not per promotion.
--------------------------------------------------------------------------------
local function runKnightingTranches()
  reset()
  local alice = Store:CreateHuman({ name = "Alice" }, 100)
  local bob = Store:CreateHuman({ name = "Bob" }, 101)
  local carol = Store:CreateHuman({ name = "Carol" }, 102)
  local dave = Store:CreateHuman({ name = "Dave" }, 103)

  Store:AppendCeremony("Knighting", { alice.id }, 1700000000)
  Store:AppendCeremony("Knighting", { bob.id }, 1700000100)
  Store:AppendCeremony("Knighting", { carol.id }, 1700000200)
  local lines = chronicleLines()
  assert_eq(#lines, 1, "three same-day Knightings are one sitting")
  assert_eq(lines[1], stamp(1700000200) .. " — Alice, Bob, and Carol were Knighted.",
    "a small sitting names the humans in sitting order")

  Store:AppendCeremony("victor", { 1, 2 }, 1700000300)
  Store:AppendCeremony("Knighting", { dave.id }, 1700000400)
  lines = chronicleLines()
  assert_eq(#lines, 3, "a ruling between Knightings starts a new sitting")
  assert_eq(lines[1], stamp(1700000400) .. " — Dave was Knighted.",
    "the later sitting is its own line")
  assert_eq(lines[3], stamp(1700000200) .. " — Alice, Bob, and Carol were Knighted.",
    "the earlier sitting stays collapsed")

  reset()
  local names = { "Ann", "Bea", "Cyd", "Dee" }
  for i = 1, #names do
    local human = Store:CreateHuman({ name = names[i] }, 200 + i)
    Store:AppendCeremony("Knighting", { human.id }, 1700000000 + i)
  end
  lines = chronicleLines()
  assert_eq(#lines, 1, "four same-day Knightings are still one sitting")
  assert_eq(lines[1], stamp(1700000004) .. " — 4 were Knighted.",
    "a large sitting is a count, not each name")

  reset()
  local one = Store:CreateHuman({ name = "One" }, 300)
  local two = Store:CreateHuman({ name = "Two" }, 301)
  Store:AppendCeremony("Knighting", { one.id }, 1700000000, nil, 1)
  Store:AppendCeremony("Knighting", { two.id }, 1700000100, nil, 2)
  lines = chronicleLines()
  assert_eq(#lines, 2, "two Gatherings on the same day do not merge")
  assert_eq(lines[1], stamp(1700000100) .. " — Two was Knighted.",
    "the later Gathering is its own sitting")
  assert_eq(lines[2], stamp(1700000000) .. " — One was Knighted.",
    "the earlier Gathering is its own sitting")

  reset()
  local early = Store:CreateHuman({ name = "Early" }, 400)
  local late = Store:CreateHuman({ name = "Late" }, 401)
  Store:AppendCeremony("Knighting", { early.id }, 1700000000, nil, 7)
  Store:AppendCeremony("victor", { 9, 10 }, 1700000100)
  Store:AppendCeremony("Knighting", { late.id }, 1700000200, nil, 7)
  lines = chronicleLines()
  assert_eq(#lines, 3, "a latecomer sitting after a ruling stays a second tranche")
  assert_eq(lines[1], stamp(1700000200) .. " — Late was Knighted.",
    "latecomer Knighting is its own line")
  assert_eq(lines[3], stamp(1700000000) .. " — Early was Knighted.",
    "the first sitting stays its own line")
end
runKnightingTranches()

local function runChronicleDateGuard()
  reset()
  local ok = Store:Restore({
    humans = { { id = 1, name = "Chuck", rankId = 3 } },
    ceremonyLog = {
      { id = 1, type = "Knighting", at = "soon", participantIds = { 1 } },
      { id = 2, type = "Knighting", participantIds = { 1 } },
      { id = 3, type = "Knighting", at = 1700000000, participantIds = { 1 } },
    },
  })
  assert_true(ok == true, "Restore seeds a hand-written log")
  local lines = chronicleLines()
  assert_eq(#lines, 3, "every restored row still renders")
  assert_eq(lines[1], stamp(1700000000) .. " — Chuck was Knighted.",
    "a numeric wall stamp paints the date prefix")
  assert_eq(lines[2], "Chuck was Knighted.", "a missing stamp renders without a prefix, not an error")
  assert_eq(lines[3], "Chuck was Knighted.", "a non-numeric stamp renders without a prefix, not an error")
end
runChronicleDateGuard()

--------------------------------------------------------------------------------
-- Degraded rulings never misattribute: victor/Knighting/Elevation rows whose
-- expected participants do not resolve render a bare non-attributing line —
-- never the generic token path naming whoever did resolve.
--------------------------------------------------------------------------------
local function runCeremonyDegradation()
  reset()
  local human = Store:CreateHuman({ name = "Chuck" }, 100)
  local knight = char("Chuckroast", "Warrior")
  local mage = char("Tendermage", "Mage")
  Store:LinkCharacter(knight.id, human.id, 101)

  Store:AppendCeremony("victor", { 9999, mage.id }, 1700000000)
  Store:AppendCeremony("victor", { 9998, 9999 }, 1700000100)
  Store:AppendCeremony("victor", { knight.id, 9999 }, 1700000200)
  Store:AppendCeremony("Knighting", { 9999 }, 1700000300)
  Store:AppendCeremony("Knighting", { mage.id }, 1700000300 + 86400)
  Store:AppendCeremony("Elevation", { 9999 }, 1700000300 + 86400 + 100)

  local lines = chronicleLines()
  assert_eq(#lines, 6, "every degraded row still renders one dated line")
  assert_eq(lines[6], stamp(1700000000) .. " — A victor was declared.",
    "an unresolvable winner never names the loser on a victor line")
  assert_eq(lines[5], stamp(1700000100) .. " — A victor was declared.",
    "both ids missing is a bare declared line, never a 'victor.' token")
  assert_eq(lines[4], stamp(1700000200) .. " — Chuckroast declared victor.",
    "a resolvable winner with a missing loser keeps the brief degrade")
  assert_eq(lines[3], stamp(1700000300) .. " — A Knighting was held.",
    "Knighting without a resolvable human is a bare held line")
  assert_eq(lines[2], stamp(1700000300 + 86400) .. " — A Knighting was held.",
    "a Knighting id that resolves only as a character names no one")
  assert_eq(lines[1], stamp(1700000300 + 86400 + 100) .. " — An elevation was held.",
    "Elevation without a resolvable human is a bare held line")
  assert_eq(lines[6]:find("Tendermage", 1, true), nil,
    "the loser is never named when the winner does not resolve")
  for i = 1, #lines do
    assert_true(lines[i] ~= "victor.", "no bare lowercase victor token")
    assert_eq(lines[i]:find("victor:", 1, true), nil, "no victor-token attribution")
  end
end
runCeremonyDegradation()

--------------------------------------------------------------------------------
-- Unknown future ceremony types (adjudicated): name a participant only when
-- exactly one of character/human resolution succeeds for that id; when both
-- or neither resolve, the id contributes no name. No names at all renders
-- the type token alone.
--------------------------------------------------------------------------------
local function runUnknownTypeAttribution()
  reset()
  -- Character and human id sequences both start at 1: id 1 resolves as both.
  Store:CreateHuman({ name = "Dualname" }, 100)
  char("Dualalt")
  local charOnly = char("Onlycharacter")
  Store:AppendCeremony("Canonization", { 1 }, 1700000000)
  Store:AppendCeremony("Canonization", { charOnly.id }, 1700000100)
  Store:AppendCeremony("Canonization", { 9999 }, 1700000200)
  Store:AppendCeremony("Canonization", { charOnly.id, 1 }, 1700000300)

  local lines = chronicleLines()
  assert_eq(#lines, 4, "every unknown-type row renders one dated line")
  assert_eq(lines[4], stamp(1700000000) .. " — Canonization.",
    "both character and human resolving names no one")
  assert_eq(lines[3], stamp(1700000100) .. " — Canonization: Onlycharacter.",
    "exactly one resolution (character) names the participant")
  assert_eq(lines[2], stamp(1700000200) .. " — Canonization.",
    "neither resolving renders the type token alone")
  assert_eq(lines[1], stamp(1700000300) .. " — Canonization: Onlycharacter.",
    "an ambiguous id contributes nothing beside a resolvable one")

  reset()
  -- Humans ahead of characters: id 2 resolves as a human only.
  Store:CreateHuman({ name = "Dual" }, 200)
  local humanOnly = Store:CreateHuman({ name = "Onlyhuman" }, 201)
  char("Dualalt")
  Store:AppendCeremony("Canonization", { humanOnly.id }, 1700000400)
  local humanLines = chronicleLines()
  assert_eq(#humanLines, 1, "the human-only row renders")
  assert_eq(humanLines[1], stamp(1700000400) .. " — Canonization: Onlyhuman.",
    "exactly one resolution (human) names the participant")
end
runUnknownTypeAttribution()

--------------------------------------------------------------------------------
-- Chronicle geometry: fixed two-line stride, no medallions on the ledger
-- leaf, rows past the pool simply not painted (newest-first preserved).
--------------------------------------------------------------------------------
local function runChronicleGeometry()
  reset()
  for i = 1, 15 do
    Store:AppendCeremony("free", nil, 1700000000 + i * 100, "Ruling " .. i)
  end
  Book:Show()
  assert_eq(frame.PageTitle:GetText(), "Chronicle", "the book opens on the Chronicle")
  local painted = paintedChronicle()
  assert_eq(#painted, 14, "rows past the two-leaf pool are simply not painted")
  assert_eq(painted[1], stamp(1700001500) .. " — Free ruling: Ruling 15",
    "the newest row paints first")
  assert_eq(painted[14], stamp(1700000200) .. " — Free ruling: Ruling 2",
    "the fourteenth-newest row paints last")
  assert_eq(frame.Body:GetText(), "", "a written ledger leaves the body well empty")
  for i = 1, #frame.Medallions do
    assert_eq(frame.Medallions[i]:IsShown(), false,
      "a full ledger still shows no medallion (slot " .. i .. ")")
  end
  assert_eq(sounds, 0, "painting the ledger pool is silent")
end
runChronicleGeometry()

--------------------------------------------------------------------------------
-- Navigation: a leaf caption names where the reader stands, Previous/Next
-- hide at the edges, and the Chronicle spans both leaves.
--------------------------------------------------------------------------------
local function runNavigation()
  reset()
  local a, b = char("Chuckroast", "Warrior"), char("Tendermage", "Mage")
  -- 10 free rulings so the Chronicle overflows the left leaf onto the right.
  -- Knightings collapse into one sitting and cannot fill the spread.
  for i = 1, 10 do
    Store:AppendCeremony("free", nil, 1700000000 + i * 100, "Ruling " .. i)
  end
  bout(a, b, a, 1700001000)
  Book:Show()
  local frame = Book.frame
  assert_eq(rawget(frame, "HomeRibbon"), nil, "no Home tab")
  assert_eq(rawget(frame, "ChronicleRibbon"), nil, "no Chronicle tab — the Chronicle is leaf I")
  assert_eq(type(frame.LeafCaption), "table", "footer carries a leaf caption")
  local n = #Book:GetPages()
  assert_true(n >= 2, "a held superlative makes a second leaf")
  assert_eq(frame.LeafCaption:GetText(), "Leaf I of " .. Book.toRoman(n) .. " \194\183 Chronicle", "caption names the leaf and page")
  assert_eq(frame.LeafCaption._cobColorRole, "gold", "caption is gold on the charcoal footer")
  assert_eq(frame.PrevButton:IsShown(), false, "no Previous on the first leaf")
  assert_eq(frame.NextButton:IsShown(), true, "Next on the first leaf")
  assert_eq(frame.PrevButton:GetText(), "\226\128\185 PREVIOUS", "previous label")
  assert_eq(frame.NextButton:GetText(), "NEXT \226\128\186", "next label")
  -- Chronicle spans both leaves: 14 slots, 8..14 on the right leaf.
  assert_eq(#frame.ChronicleEntries, 14, "fourteen chronicle slots")
  local _, rel8 = frame.ChronicleEntries[8]:GetPoint(1)
  assert_eq(rel8, frame.RightLeaf, "slot 8 hangs on the right leaf")
  local _, rel1 = frame.ChronicleEntries[1]:GetPoint(1)
  assert_true(rel1 ~= frame.RightLeaf, "slot 1 stays on the left leaf")
  local painted = paintedChronicle()
  assert_eq(#painted, 10, "ten ledger rows paint across both leaves")
  assert_eq(frame.RightSeal:IsShown(), false, "no watermark on the Chronicle")
  -- Turn to the last leaf.
  for _ = 1, n do stub.fire(frame.NextButton, "OnClick") end
  assert_eq(frame.NextButton:IsShown(), false, "no Next on the last leaf")
  assert_eq(frame.PrevButton:IsShown(), true, "Previous on the last leaf")
  assert_eq(frame.RightSeal:IsShown(), true, "superlative leaves carry the seal watermark")
  assert_eq(frame.RightSeal._cobTextureName, "seal_papal", "watermark is the papal seal through Theme")
  assert_true(frame.LeafCaption:GetText():find("^Leaf " .. Book.toRoman(n) .. " of ") == 1, "caption follows the turn")
  -- Wheel still turns; the footer chrome still forwards the wheel.
  stub.fire(frame.FooterBar, "OnMouseWheel", 1)
  assert_true(frame.LeafCaption:GetText():find("^Leaf " .. Book.toRoman(n - 1) .. " of ") == 1, "wheel up turns back")
end
runNavigation()

--------------------------------------------------------------------------------
-- Held-only walk: a mid-order category with no holder is skipped by Next
-- while its canonical neighbors are held.
--------------------------------------------------------------------------------
local function runUnheldMidOrderSkip()
  reset()
  local a = char("Skipalt")
  local b = char("Skipfoil")
  bout(a, b, a, 4100)
  bout(a, b, a, 4101)
  bout(a, b, b, 4102)

  assert_eq(pageNamed("Most Successful Defenses"), nil,
    "no elevations: the mid-order defenses page is unheld")
  assert_true(pageNamed("Longest Streak") ~= nil, "the canonical neighbor before is held")
  assert_true(pageNamed("The Iron Chin") ~= nil, "the canonical neighbor after is held")

  Book:Show()
  local seen = {}
  local hops = 0
  while hops < 10 do
    seen[frame.PageTitle:GetText()] = true
    stub.fire(frame.NextButton, "OnClick")
    hops = hops + 1
  end
  assert_eq(seen["Most Successful Defenses"], nil, "Next never lands on the unheld mid-order page")
  assert_eq(seen["Longest Streak"], true, "the walk reaches the held neighbor before the gap")
  assert_eq(seen["The Iron Chin"], true, "the walk reaches the held neighbor after the gap")

  while frame.PageTitle:GetText() ~= "Longest Streak" and hops < 24 do
    stub.fire(frame.PrevButton, "OnClick")
    hops = hops + 1
  end
  assert_eq(frame.PageTitle:GetText(), "Longest Streak", "parked on the held neighbor before the gap")
  stub.fire(frame.NextButton, "OnClick")
  assert_eq(frame.PageTitle:GetText(), "The Iron Chin", "one Next hop skips the unheld mid-order page")
  assert_eq(sounds, 0, "the skipping walk is silent")
end
runUnheldMidOrderSkip()

--------------------------------------------------------------------------------
-- Superlatives exist only when held. Canonical §10.9 order after the
-- Chronicle. Unheld pages are absent from GetPages() and unreachable.
--------------------------------------------------------------------------------
local function runHeldOnlyAndOrder()
  reset()
  local lordH = Store:CreateHuman({ name = "Lordly" }, 3000)
  local lord = char("Lordalt", "Warrior")
  local chal = char("Challenger", "Mage")
  Store:LinkCharacter(lord.id, lordH.id, 3001)
  Store:SetRank(lordH.id, 4, 3002)
  bout(lord, chal, lord, 3100)
  bout(lord, chal, lord, 3101)
  bout(lord, chal, chal, 3102)
  local upH = Store:CreateHuman({ name = "Up" }, 3200)
  local dog = char("Underdog", "Priest")
  Store:LinkCharacter(dog.id, upH.id, 3201)
  bout(dog, lord, dog, 3202, { famousUpset = true })

  local titles = pageTitles()
  assert_eq(#titles, 9, "Chronicle plus eight held superlatives")
  assert_eq(titles[1], "Chronicle", "Chronicle first")
  assert_eq(titles[2], "Most Sanctioned Victories", "canonical order: victories")
  assert_eq(titles[3], "Longest Streak", "canonical order: streak")
  assert_eq(titles[4], "Most Successful Defenses", "canonical order: defenses")
  assert_eq(titles[5], "The Iron Chin", "canonical order: iron chin")
  assert_eq(titles[6], "Greatest Rivalry", "canonical order: rivalry")
  assert_eq(titles[7], "Famous Upsets", "canonical order: upsets")
  assert_eq(titles[8], "The Undefeated", "canonical order: undefeated")
  assert_eq(titles[9], "The Glorious Martyr", "canonical order: martyr")
  assert_eq(pageNamed("Tournament Champions"), nil,
    "Tournament Champions will simply not exist until data does")

  -- Unheld pages are unreachable: walk Next past the end and never land on one.
  Book:Show()
  local seen = {}
  for i = 1, 14 do
    seen[frame.PageTitle:GetText()] = true
    stub.fire(frame.NextButton, "OnClick")
  end
  assert_eq(frame.PageTitle:GetText(), "The Glorious Martyr", "Next clamps at the last held leaf")
  assert_eq(seen["Tournament Champions"], nil, "Next never reaches Tournament Champions")
  assert_eq(seen["Most Successful Defenses"] , true, "Next reaches the held defenses leaf")
  assert_eq(seen["Chronicle"], true, "the walk began on the Chronicle")
  for i = 1, 14 do
    stub.fire(frame.PrevButton, "OnClick")
  end
  assert_eq(frame.PageTitle:GetText(), "Chronicle",
    "Previous past the first leaf clamps on the Chronicle")
  assert_eq(sounds, 0, "leaf walks are silent")
end
runHeldOnlyAndOrder()

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

Book:Show()
local hopsDef = 0
while frame.PageTitle:GetText() ~= "Most Successful Defenses" and hopsDef < 12 do
  local nextDef = frame.NextButton
  assert_true(nextDef ~= nil, "parchment has a Next leaf control")
  stub.fire(nextDef, "OnClick")
  hopsDef = hopsDef + 1
end
assert_eq(frame.PageTitle:GetText(), "Most Successful Defenses", "the defenses leaf can be opened")
local defBody = frame.Body:GetText() or ""
assert_true(defBody:find("Lordalt", 1, true) ~= nil, "the defenses leaf names the holder")
assert_true(defBody:find("2", 1, true) ~= nil, "painted defenses use arabic 2")
assert_eq(defBody:find("II", 1, true), nil, "painted defenses do not print roman II")
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

Book:Show()
local hopsRiv = 0
while frame.PageTitle:GetText() ~= "Greatest Rivalry" and hopsRiv < 12 do
  local nextRiv = frame.NextButton
  assert_true(nextRiv ~= nil, "parchment has a Next leaf control")
  stub.fire(nextRiv, "OnClick")
  hopsRiv = hopsRiv + 1
end
assert_eq(frame.PageTitle:GetText(), "Greatest Rivalry", "the rivalry leaf can be opened")
local rivBody = frame.Body:GetText() or ""
assert_true(rivBody:find("2", 1, true) ~= nil, "painted rivalry score uses arabic 2")
assert_eq(rivBody:find("II", 1, true), nil, "painted rivalry score does not print roman II")

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
assert_eq(pageNamed("Famous Upsets"), nil,
  "a Fresh Beef beating a Lord is not an upset page unless the Pope flags it")

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
  local nextBtn = frame.NextButton
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
-- Tournament Champions never exists without a tournament engine.
--------------------------------------------------------------------------------
reset()
char("Champish")
assert_eq(pageNamed("Tournament Champions"), nil, "a character does not mint a tournament page")
assert_eq(Book.AddTournamentChampion, nil, "still no tournament writer")

--------------------------------------------------------------------------------
-- GetPages returns copies. Show / Hide do not write the Store.
--------------------------------------------------------------------------------
reset()
local p = char("Copy")
local q = char("Mut")
bout(p, q, p, 9000)
Store:AppendCeremony("victor", { p.id, q.id }, 9001)
local snapBefore = Store:Snapshot()
local leaf = Book:GetPages()
leaf[1].title = "hacked"
leaf[1].entries[1] = "forged"
local chronCopy = pageNamed("Chronicle")
assert_eq(chronCopy and chronCopy.title, "Chronicle",
  "mutating a GetPages copy does not rewrite the book")
assert_true(chronCopy and chronCopy.entries[1] ~= "forged",
  "mutating a chronicle copy does not rewrite the ledger")
local sup = pageNamed("Most Sanctioned Victories")
sup.entries[1] = { name = "forged", wins = 99, place = 1 }
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
assert_eq(#snapAfter.ceremonyLog, #snapBefore.ceremonyLog,
  "opening the book does not append ceremony rows")
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
-- Painted chrome stays ecclesiastical and silent. Prev/Next turn leaves.
--------------------------------------------------------------------------------
reset()
local leafA = char("LeafA")
local leafB = char("LeafB")
bout(leafA, leafB, leafA, 9200)
Book:Show()
assert_eq(frame.TitleText:GetText(), "The Records Book", "title stays the book name while open")
assert_eq(frame.PageTitle:GetText(), "Chronicle", "open book starts on the Chronicle")
stub.fire(frame.NextButton, "OnClick")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "Next turns to the first held leaf")
local bodyOpen = frame.Body:GetText() or ""
assert_true(bodyOpen:find("LeafA", 1, true) ~= nil, "the open leaf names the holder")
assert_eq(bodyOpen:find("#1", 1, true), nil, "painted copy has no #1 rating")
assert_eq(bodyOpen:find("standing", 1, true), nil, "painted copy has no standing")
assert_eq(bodyOpen:find("Grant", 1, true), nil, "painted copy has no Grant")
assert_eq(bodyOpen:find("points", 1, true), nil, "painted copy has no points")
local prevBtn = frame.PrevButton
local nextBtn = frame.NextButton
assert_true(prevBtn ~= nil, "Previous leaf control exists")
assert_true(nextBtn ~= nil, "Next leaf control exists")
stub.fire(prevBtn, "OnClick")
assert_eq(frame.PageTitle:GetText(), "Chronicle", "Previous turns the leaf back")
assert_eq(sounds, 0, "leaf turns play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "leaf turns install no OnUpdate")

--------------------------------------------------------------------------------
-- Mouse wheel turns leaves the same way Prev/Next do. Silent. No OnUpdate.
--------------------------------------------------------------------------------
reset()
local wheelA = char("WheelA")
local wheelB = char("WheelB")
bout(wheelA, wheelB, wheelA, 9250)
Book:Show()
assert_true(frame:GetScript("OnMouseWheel") ~= nil, "frame has OnMouseWheel")
assert_eq(frame:GetScript("OnUpdate"), nil, "wheel install has no OnUpdate")
assert_eq(frame.PageTitle:GetText(), "Chronicle", "open book starts on the Chronicle")
assert_true(stub.fire(frame, "OnMouseWheel", -1), "wheel down is wired")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories",
  "wheel down turns the leaf the same way Next does")
assert_true(stub.fire(frame, "OnMouseWheel", 1), "wheel up is wired")
assert_eq(frame.PageTitle:GetText(), "Chronicle",
  "wheel up turns the leaf the same way Previous does")
assert_true(stub.fire(frame, "OnMouseWheel", 1), "wheel up again is wired")
assert_eq(frame.PageTitle:GetText(), "Chronicle", "wheel up past the first leaf clamps on the Chronicle")
assert_eq(sounds, 0, "wheel turns play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "wheel turns install no OnUpdate")

reset()
Book:Show()
assert_eq(frame.PageTitle:GetText(), "Chronicle", "empty book opens on the Chronicle")
assert_eq(frame.Body:GetText(), "Nothing has been written yet.", "empty Chronicle state is explicit")
assert_true(stub.fire(frame, "OnMouseWheel", -1), "wheel down is wired on an empty book")
assert_eq(frame.PageTitle:GetText(), "Chronicle", "wheel down clamps when the Chronicle stands alone")
assert_eq(frame.Body:GetText(), "Nothing has been written yet.", "empty state survives the clamp")

--------------------------------------------------------------------------------
-- Chrome on top of the tome also turns leaves. Same handler as the outer frame.
--------------------------------------------------------------------------------
reset()
local chromeA = char("ChromeA")
local chromeB = char("ChromeB")
bout(chromeA, chromeB, chromeA, 9275)
Book:Show()
assert_true(frame:GetScript("OnMouseWheel") ~= nil, "outer frame still has OnMouseWheel")
assert_true(frame.TitleBar ~= nil, "TitleBar exists")
assert_true(frame.TitleBar:GetScript("OnMouseWheel") ~= nil, "TitleBar has OnMouseWheel")
assert_true(frame.CloseButton ~= nil, "CloseButton exists")
assert_true(frame.CloseButton:GetScript("OnMouseWheel") ~= nil, "CloseButton has OnMouseWheel")
assert_true(frame.ChurchButton ~= nil, "ChurchButton exists")
assert_eq(frame.ChurchButton:GetText(), "Back", "return is labeled Back")
assert_true(frame.ChurchButton:GetScript("OnMouseWheel") ~= nil, "ChurchButton has OnMouseWheel")
assert_true(frame.PrevButton ~= nil, "PrevButton exists")
assert_true(frame.PrevButton:GetScript("OnMouseWheel") ~= nil, "PrevButton has OnMouseWheel")
assert_true(frame.NextButton ~= nil, "NextButton exists")
assert_true(frame.NextButton:GetScript("OnMouseWheel") ~= nil, "NextButton has OnMouseWheel")
assert_eq(frame.PageTitle:GetText(), "Chronicle", "open book starts on the Chronicle")
assert_true(stub.fire(frame.TitleBar, "OnMouseWheel", -1), "TitleBar wheel down is wired")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "TitleBar wheel down turns Next")
assert_true(stub.fire(frame.PrevButton, "OnMouseWheel", 1), "PrevButton wheel up is wired")
assert_eq(frame.PageTitle:GetText(), "Chronicle", "PrevButton wheel up turns Previous")
assert_eq(sounds, 0, "chrome wheel turns play no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "chrome wheel installs no OnUpdate")

--------------------------------------------------------------------------------
-- Painted counts are arabic. GetPages measures stay arabic. toRoman stays
-- the leaf-caption helper.
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
assert_eq(frame.PageTitle:GetText(), "Chronicle", "open book starts on the Chronicle")
stub.fire(frame.NextButton, "OnClick")
assert_eq(frame.PageTitle:GetText(), "Most Sanctioned Victories", "Next turns to victories")
local countBody = frame.Body:GetText() or ""
assert_true(countBody:find("Highbeef", 1, true) ~= nil, "painted victories name the holder")
assert_true(countBody:find("14", 1, true) ~= nil, "painted victories use arabic 14")
assert_eq(countBody:find("XIV", 1, true), nil, "painted victories do not print roman XIV")
assert_eq(countBody:find("ordained", 1, true), nil, "painted body does not invent ordained prose")
assert_eq(frame.Medallion:IsShown(), true, "a holder shows the medallion slot")
assert_eq(frame.Medallion._cobTextureName, "seal_papal", "shown medallion stays seal_papal")
assert_eq(frame.Medallions[2]:IsShown(), false, "unused medallion slots stay hidden")

--------------------------------------------------------------------------------
-- Marked moments are gone from the book even when the Store holds them, and
-- honorifics never paint in the book (they live on the player card).
--------------------------------------------------------------------------------
reset()
assert_eq(UnitName("player"), "Beefina", "stub local player is Beefina")
Store:FlagMoment("Shattrath", 10000)
Book:Show()
assert_true(frame.RightLeaf ~= nil, "right leaf still exists after paint")
assert_eq(allText():find("Shattrath", 1, true), nil,
  "a stored marked moment never renders anywhere in the book")
assert_eq((frame.Body:GetText() or ""):find("Shattrath", 1, true), nil,
  "moment locations are not painted on the records leaf")

reset()
local localHuman = Store:CreateHuman({ name = "Local" }, 11000)
local localChar = Store:CreateCharacter({ name = "Beefina" })
Store:LinkCharacter(localChar.id, localHuman.id, 11001)
Store:AddHonorific(localHuman.id, "Duke of the Fountain")
Store:AddHonorific(localHuman.id, "Defender of the Faith")
Store:FlagMoment("Goldshire Inn", 11002)
Book:Show()
assert_eq(frame.PageTitle:GetText(), "Chronicle", "left leaf opens on the Chronicle")
assert_eq((frame.Body:GetText() or ""):find("Duke of the Fountain", 1, true), nil,
  "honorifics stay off the records leaf")
assert_eq(allText():find("Duke of the Fountain", 1, true), nil,
  "granted honorifics never paint in the book")
assert_eq(allText():find("Goldshire Inn", 1, true), nil,
  "marked-moment locations stay out of the book entirely")

reset()
local unbound = Store:CreateCharacter({ name = "Beefina" })
local otherH = Store:CreateHuman({ name = "Other" }, 12000)
Store:AddHonorific(otherH.id, "Martyr of Goldshire")
assert_eq(unbound.humanId, nil, "local character is unbound")
Book:Show()
assert_eq(allText():find("Martyr of Goldshire", 1, true), nil,
  "another human's honorific never paints in the book")

--------------------------------------------------------------------------------
-- Show paint is at most two Store:Snapshot calls — one for the pages walk,
-- one for the chronicle log read. Spy on Snapshot to prove it.
--------------------------------------------------------------------------------
local function runHomePaintPerf()
  reset()
  local a = char("Perfalt")
  local b = char("Perfoil")
  bout(a, b, a, 9600)
  Store:AppendCeremony("victor", { a.id, b.id }, 9601)

  local realSnapshot = Store.Snapshot
  local snaps = 0
  Store.Snapshot = function(self, ...)
    snaps = snaps + 1
    return realSnapshot(self, ...)
  end
  assert_eq(Book:Show(), true, "Show opens on the Chronicle")
  Store.Snapshot = realSnapshot
  assert_true(snaps <= 2, "painting the Chronicle takes at most two Store:Snapshot calls")
end
runHomePaintPerf()

--------------------------------------------------------------------------------
-- Return to the player card. Close / ESC restore only after ShowFromCard.
-- Back always returns. Bare Show + Close must not invent a card.
--------------------------------------------------------------------------------
reset()
do
  local cardShows = 0
  local savedCard = COB.PlayerCard
  COB.PlayerCard = {
    Show = function()
      cardShows = cardShows + 1
      return true
    end,
  }
  Book:ShowFromCard()
  assert_eq(Book:IsShown(), true, "ShowFromCard opens the book")
  assert_true(stub.fire(Book.frame.CloseButton, "OnClick"), "Close is wired")
  assert_eq(Book:IsShown(), false, "Close hides the book")
  assert_eq(cardShows, 1, "Close from the card returns to the player card")

  Book:ShowFromCard()
  Book.frame:Hide()
  assert_eq(Book:IsShown(), false, "widget Hide closes the book")
  assert_eq(cardShows, 2, "ESC Hide from the card returns to the player card")

  Book:ShowFromCard()
  assert_true(stub.fire(Book.frame.ChurchButton, "OnClick"), "Back is wired")
  assert_eq(Book:IsShown(), false, "Back hides the book")
  assert_eq(cardShows, 3, "Back returns to the player card")

  Book:Show()
  stub.fire(Book.frame.CloseButton, "OnClick")
  assert_eq(cardShows, 3, "Close after a bare Show does not invent a card return")
  assert_eq(Book:ReturnToCard(), true, "ReturnToCard still opens the card")
  assert_eq(cardShows, 4, "Back / ReturnToCard works from a bare Show")
  assert_eq(Book:IsShown(), false, "ReturnToCard leaves the book closed")

  Book:ShowFromCard()
  assert_eq(Book:Dismiss(), true, "Dismiss succeeds")
  assert_eq(Book:IsShown(), false, "Dismiss hides the book")
  assert_eq(cardShows, 4, "Dismiss does not bounce back to the card")
  COB.PlayerCard = savedCard
end

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
