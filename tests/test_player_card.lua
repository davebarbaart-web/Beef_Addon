-- Player card — `/beef`. Isolated: wow_ui_stub + Common + Theme + Ranks +
-- Store + Records + Decree + PlayerCard. Quiet, player-opened identity
-- (Bible §12.5, §14.2). Never a position among members (§10.9).
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed, failed = 0, 0
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
  function assert_true(v, msg) assert_eq(not not v, true, msg) end
end

local stub = require("wow_ui_stub")
local restore = stub.install()

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/UI/NightRows.lua")
dofile("addon/ChurchOfBeef/Core/Nights.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Records.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/UI/PlayerCard.lua")

local COB = ChurchOfBeef
local Store, Decree, Card = COB.Store, COB.Decree, COB.PlayerCard
local EN_DASH = "\226\128\147"

-- The 2.5.x stub does not model these; the card must guard them.
local savedUnitClass, savedUnitLevel = UnitClass, UnitLevel
UnitClass = function() return "Warrior", "WARRIOR" end
UnitLevel = function() return 70 end

local sounds = 0
local savedPlaySound, savedPlaySoundFile = PlaySound, PlaySoundFile
PlaySound = function() sounds = sounds + 1 end
PlaySoundFile = function() sounds = sounds + 1 end

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store resets")
  assert_eq(Decree:ResetForTests(), true, "Decree resets")
  assert_eq(Card:ResetForTests(), true, "PlayerCard resets")
  if type(COB.Nights) == "table" and type(COB.Nights.ResetForTests) == "function" then
    assert_eq(COB.Nights:ResetForTests(), true, "Nights resets")
  end
  if type(COB.Runtime) == "table" and type(COB.Runtime.ResetForTests) == "function" then
    assert_eq(COB.Runtime:ResetForTests(), true, "Runtime resets")
  end
  stub.playerName = "Beefina"
  stub.guildRankIndex = nil
  stub.guildRankName = "Beefling"
  ChurchOfBeefDB = { ui = {} }
  sounds = 0
end

local function bout(a, b, winner, now)
  Store:RecordGoraResult(a.id, { opponentId = b.id, ruling = "victor", won = (winner == a) }, now)
  Store:RecordGoraResult(b.id, { opponentId = a.id, ruling = "victor", won = (winner == b) }, now)
end

-- Chuckroast: Beef Knight, knighted at 1700000000, 2–0 vs Tendermage,
-- one honorific, a posted Decree, guild rank shown.
local function seedKnight()
  local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
  local human = Store:CreateHuman({ name = "Chuck" })
  Store:LinkCharacter(a.id, human.id, 1699990000)
  Store:SetRank(human.id, 3, 1700000000)
  Store:AppendCeremony("Knighting", { human.id }, 1700000000)
  bout(a, b, a, 1700000100)
  bout(a, b, a, 1700000200)
  Store:AddHonorific(human.id, "Duke of the Fountain")
  Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
  stub.playerName = "Chuckroast"
  stub.guildRankIndex = 6
  return a, b, human
end

local function countSpecial(name)
  local n = 0
  if type(UISpecialFrames) ~= "table" then return 0 end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then n = n + 1 end
  end
  return n
end

local function collectText(widget, out, seen)
  if type(widget) ~= "table" or seen[widget] then return end
  seen[widget] = true
  if type(widget.IsShown) == "function" and widget:IsShown() ~= true then return end
  if type(widget._text) == "string" then out[#out + 1] = widget._text end
  for _, kid in ipairs(widget._children or {}) do collectText(kid, out, seen) end
  for _, region in ipairs(widget._regions or {}) do collectText(region, out, seen) end
end

local function pointRelatives(widget)
  local out = {}
  if not (widget and widget.GetNumPoints) then return out end
  for i = 1, widget:GetNumPoints() do
    local _, rel = widget:GetPoint(i)
    out[#out + 1] = rel
  end
  return out
end

local function among(list, target)
  for i = 1, #list do
    if list[i] == target then return true end
  end
  return false
end

local function bottomRelative(fs)
  if not (fs and fs.GetNumPoints) then return nil end
  for i = 1, fs:GetNumPoints() do
    local point, rel = fs:GetPoint(i)
    if point == "BOTTOM" then return rel end
  end
  return nil
end

local function topRelative(widget)
  if not (widget and widget.GetNumPoints) then return nil end
  for i = 1, widget:GetNumPoints() do
    local point, rel = widget:GetPoint(i)
    if point == "TOPLEFT" or point == "TOP" then return rel end
  end
  return nil
end

-- The stub does not resolve stretch-from-points. Inherit width from the
-- LEFT/RIGHT (or TOPLEFT/TOPRIGHT) relative when both sides pin to one widget.
local function inheritedWidth(widget, seen)
  if not widget then return nil end
  seen = seen or {}
  if seen[widget] then return nil end
  seen[widget] = true
  if type(widget.GetWidth) == "function" then
    local w = widget:GetWidth()
    if type(w) == "number" then return w end
  end
  local leftRel, rightRel
  if widget.GetNumPoints then
    for i = 1, widget:GetNumPoints() do
      local point, rel = widget:GetPoint(i)
      if point == "LEFT" or point == "TOPLEFT" or point == "BOTTOMLEFT" then
        leftRel = rel
      elseif point == "RIGHT" or point == "TOPRIGHT" or point == "BOTTOMRIGHT" then
        rightRel = rel
      end
    end
  end
  if leftRel and leftRel == rightRel then return inheritedWidth(leftRel, seen) end
  return nil
end

local function allText()
  local out = {}
  if Card.frame then collectText(Card.frame, out, {}) end
  return table.concat(out, "\n")
end

--------------------------------------------------------------------------------
-- Module contract
--------------------------------------------------------------------------------
assert_true(Card ~= nil, "COB.PlayerCard exists")
assert_eq(Card.MODE, "QUIET", "the card is player-opened Quiet identity")
for _, name in ipairs({ "Init", "Show", "Hide", "Toggle", "IsShown", "Refresh", "GetModel", "OpenRecords", "OpenDesk", "OpenDecree", "ShowHome", "ShowGora", "ResetForTests" }) do
  assert_eq(type(Card[name]), "function", name .. " exists")
end
assert_eq(Card.Position, nil, "no position among members")
assert_eq(Card.Ladder, nil, "no ladder")
assert_eq(Card.Rank, nil, "no numeric rank")
assert_eq(Card.NextRank, nil, "no next-rank hint")
assert_eq(type(SLASH_PLAYERCARD1), "nil", "the card registers no slash")

local f = io.open("addon/ChurchOfBeef/UI/PlayerCard.lua", "r")
assert_true(f ~= nil, "PlayerCard.lua is readable")
local src = f:read("*a")
f:close()
assert_eq(src:find("Interface\\\\", 1, true), nil, "no hardcoded media paths")
assert_eq(src:find("Fonts\\\\", 1, true), nil, "no hardcoded font paths")
assert_eq(src:find("SendChatMessage", 1, true), nil, "the card never talks in chat")
assert_eq(src:find("PlaySound", 1, true), nil, "the card never plays sound (Quiet)")
assert_eq(src:find("SetResizable(true)", 1, true), nil, "fixed size — no resize grip")
assert_true(src:find("ApplyBackdrop", 1, true) ~= nil,
  "section cards use the stock tooltip backdrop")
assert_true(src:find("BackdropTemplate", 1, true) ~= nil,
  "section cards inherit BackdropTemplate")
assert_true(src:find("PanelButton", 1, true) ~= nil,
  "card verbs use Theme:PanelButton")
assert_eq(src:find('applyFont(frame.DecreeText, "GameFontNormal", "display"', 1, true), nil,
  "paintHome never promotes leftover Decree to blackletter")
assert_eq(src:lower():find("standing", 1, true), nil, "no standing")
assert_eq(src:lower():find("leaderboard", 1, true), nil, "no leaderboard")
assert_eq(src:find("#1", 1, true), nil, "no #1")
assert_eq(src:find("Grant", 1, true), nil, "no Grant")
assert_eq(src:lower():find("prophet", 1, true), nil, "the card never names the retired seventh rung")
assert_eq(src:find("BEEF POPE", 1, true), nil, "the plate does not invent a Church title")
assert_eq(src:find("SetColorTexture(0", 1, true), nil, "no color literals")
assert_eq(Card.COPY.gathering, "GATHERING", "Assembly ribbon")
assert_eq(Card.COPY.decree, "DECREE", "Quiet decree ribbon")
assert_eq(Card.COPY.knighting, "KNIGHTING", "Knighting ribbon")
assert_eq(Card.COPY.gora, "GORA", "Gora ribbon")
assert_eq(Card.COPY.confession, "CONFESSION", "Confession ribbon")
assert_eq(Card.COPY.proclamation, "PROCLAMATION", "Proclamation ribbon")
assert_eq(Card.COPY.gatheringStarted, nil, "live Gathering no longer replaces the Decree line")
assert_eq(Card.COPY.goraLabel, "BEEF GORA", "Gora ledger rubric")
assert_eq(Card.COPY.weekLabel, "THIS WEEK", "week rubric")
assert_eq(Card.COPY.victoriesLabel, "MOST SANCTIONED VICTORIES", "victory holders rubric")
assert_eq(Card.COPY.chronicleLabel, "FROM THE CHRONICLE", "Chronicle rubric")
assert_eq(Card.COPY.noDecree, "No nights posted this week.", "empty Gathering copy")
assert_eq(Card.COPY.noGora, "No sanctioned Goras are on the record.", "empty Gora copy")
assert_eq(Card.COPY.yourRecord, "Your record ", "personal line when not in the front three")
assert_eq(Card.COPY.unrecorded, nil, "no UNRECORDED fake rank word")
assert_eq(Card.COPY.unrecordedLine, "The Pope has not written you yet. That is normal.",
  "newness is the relationship line")
assert_eq(Card.COPY.guildRankLine, nil, "guild-rank plate reuses the newness line")
assert_eq(Card.COPY.records, "RECORDS", "records nav label")
assert_eq(Card.COPY.navChurch, "CHURCH", "church nav label")
assert_eq(Card.COPY.navGora, "GORA", "gora nav label")
assert_eq(Card.COPY.desk, "THE DESK", "listed-Pope desk door label")
assert_eq(Card.COPY.unranked, "UNRANKED", "entered-but-unranked plate stays")
assert_eq(Card.COPY.unrankedLine, "Recorded, no rank yet.", "entered-but-unranked line stays")
assert_eq(src:find("UNRECORDED", 1, true), nil, "source never paints UNRECORDED")
assert_eq(src:find('unrecorded = "NEW"', 1, true), nil, "do not paint NEW as a rank")
assert_eq(src:find("Guild rank.", 1, true), nil, "source never labels a guild rank as Guild rank.")
assert_eq(src:find("Welcome", 1, true), nil, "the card never reopens welcome")
assert_eq(src:find("COB.Toast", 1, true), nil, "the card never toasts")
assert_eq(src:find("EnsureCharacterByName", 1, true), nil, "the card never Ensures")
assert_eq(src:find("Proclaim", 1, true), nil, "the card never Proclaims")
assert_eq(Card.COPY.noBouts, nil, "empty Gora copy is gone")
assert_eq(Card.COPY.noRivalries, nil, "empty Rivals copy is gone")
assert_eq(Card.COPY.noDistinctions, nil, "empty Legacy copy is gone")
assert_eq(src:find("SANCTIONED GORA", 1, true), nil, "old Gora rubric is gone from source")
assert_eq(src:find("No sanctioned bouts.", 1, true), nil, "empty-bout copy is gone from source")
assert_eq(src:find("No rivalries yet.", 1, true), nil, "empty-rivalry copy is gone from source")
assert_eq(src:find("None yet.", 1, true), nil, "empty-legacy copy is gone from source")

--------------------------------------------------------------------------------
-- Empty store: honest, not a prototype
--------------------------------------------------------------------------------
reset()
local model = Card:GetModel()
assert_eq(model.name, "Beefina", "model names the local character")
assert_eq(model.class, "Warrior", "class from UnitClass")
assert_eq(model.classFile, "WARRIOR", "classFile from UnitClass")
assert_eq(model.level, 70, "level from UnitLevel")
assert_eq(model.entered, false, "not in the Church's record")
assert_eq(model.rankTitle, nil, "no rank")
assert_eq(model.relationship, nil, "no relationship line")
assert_eq(model.record, nil, "no record")
assert_eq(#model.rivalries, 0, "no rivalries")
assert_eq(#model.distinctions, 0, "no distinctions")
assert_eq(model.decree, nil, "no decree")
assert_eq(model.guildName, nil, "unguilded shows no guild")

assert_eq(Card:Show(), true, "empty card shows")
assert_eq(ChurchOfBeefDB.ui.playerCard.layoutVersion, 3, "shown card stamps the home layout")
local frame = Card.frame
assert_true(frame ~= nil, "frame exists")
assert_eq(rawget(frame, "Portrait") ~= nil, true, "portrait slot exists")
assert_eq(rawget(frame, "PortraitWell") ~= nil, true, "portrait sits in a charcoal well")
assert_eq(frame.PortraitWell._cobColorRole, "charcoal", "the well is not a gold fill")
assert_eq(rawget(frame, "PortraitSeal") ~= nil, true, "papal seal sits under the unit face")
assert_eq(frame.PortraitSeal._cobTextureName, "seal_papal_small", "underlay is the papal seal")
assert_eq(rawget(frame, "PortraitRimT") ~= nil, true, "gold portrait rim is slivers, not a fill")
assert_eq(frame.PortraitRimT._cobColorRole, "gold", "rim stays gold")
assert_eq(frame.Portrait._cobPortrait, "seal", "no unit portrait API uses the papal seal")
assert_eq(frame.Portrait._cobTextureName, "seal_papal_small", "seal path through Theme")
assert_eq(frame.GoraGlyph:IsShown(), false, "14px record glyph does not read as a missing mark")
assert_eq(frame:GetWidth(), 600, "card is 600 wide")
assert_eq(frame:GetHeight(), 444, "empty home card shrinks")
local gathering = rawget(frame, "GatheringPlate")
local gatheringLabel = rawget(frame, "GatheringLabel")
assert_true(gathering ~= nil, "Gathering plate exists")
assert_eq(gathering and gathering._cobColorRole, "parchment", "empty week plate stays parchment")
assert_eq(rawget(frame, "DecreeRibbon") and frame.DecreeRibbon._cobTextureName, "ribbon_bookmark",
  "category sits on the bookmark ribbon")
assert_eq(frame.DecreeText:GetText(), "No nights posted this week.", "empty Gathering copy")
assert_eq(frame.DecreeText._cobColorRole, "iron", "empty Gathering ink is iron")
assert_eq(rawget(frame, "FlavorText") ~= nil, true, "flavor line exists")
assert_eq(rawget(frame, "FlavorText") and frame.FlavorText:IsShown(), false, "empty flavor is hidden")
assert_eq(frame.GoraLabel:IsShown(), true, "Gora rubric stays as structure")
assert_eq(frame.GoraEmptyText:GetText(), "No sanctioned Goras are on the record.", "compact Gora empty")
assert_eq(frame.WeekPlate:GetHeight(), 88, "empty week plate is quiet")
assert_eq(frame.WeekPlate._cobBackdrop, "tooltip", "THIS WEEK is a stock tooltip container")
assert_eq(frame.WeekPlate._template, "BackdropTemplate", "THIS WEEK inherits BackdropTemplate")
assert_eq(rawget(frame.WeekPlate, "Edge"), nil, "THIS WEEK has no homemade gold rim")
assert_eq(frame.GoraPlate._cobBackdrop, "tooltip", "BEEF GORA is a stock tooltip container")
assert_eq(frame.GoraPlate._template, "BackdropTemplate", "Gora inherits BackdropTemplate")
assert_eq(rawget(frame.GoraPlate, "Edge"), nil, "Gora has no homemade gold rim")
assert_eq(frame.ChroniclePlate._cobBackdrop, "tooltip", "Chronicle is a stock tooltip container")
assert_eq(frame.ChroniclePlate._template, "BackdropTemplate", "Chronicle inherits BackdropTemplate")
assert_eq(rawget(frame.ChroniclePlate, "Edge"), nil, "Chronicle has no homemade gold rim")
assert_eq(frame.GoraPlate:GetHeight(), 88, "empty Gora plate is quiet")
assert_true(frame.WeekPlate:GetWidth() > frame.GoraPlate:GetWidth(),
  "THIS WEEK is wider than BEEF GORA")
assert_true(frame.WeekPlate:GetWidth() >= frame.GoraPlate:GetWidth() * 1.5,
  "THIS WEEK is the primary column (at least half-again Gora)")
assert_true(frame.WeekPlate:GetWidth() >= 360,
  "THIS WEEK is wide enough for two-line night rows")
assert_eq(Card:ShowGora(), true, "empty THE RECORD still opens")
assert_eq(frame:GetHeight(), 444, "empty ledger stays compact")
assert_eq(Card:ShowHome(), true, "empty CHURCH returns home")
assert_eq(frame:GetHeight(), 444, "empty home shrinks again")
assert_eq(rawget(frame, "NailTL") ~= nil, true, "board has a top-left nail")
assert_eq(rawget(frame, "NailBR") ~= nil, true, "board has a bottom-right nail")
assert_eq(frame.ChronicleEmptyText:IsShown(), true, "compact Chronicle empty is shown")
assert_eq(frame.FooterBand:GetHeight(), 36, "nav sits on the charcoal footer")
assert_eq(frame.FooterBand._cobColorRole, "charcoal", "close band is charcoal")
assert_eq(among(pointRelatives(frame.DecreeText), frame.FooterBand), false, "Decree left the close band")
assert_eq(rawget(frame, "SizeGrip"), nil, "card is fixed-size: no resize grip")
assert_eq(frame.RankText:GetText(), "", "unwritten gold plate is empty")
assert_eq(frame.RelationshipText:GetText(), "The Pope has not written you yet. That is normal.",
  "newness is the relationship line")
assert_eq(frame.FormatLine:GetText(), "Level 70 \194\183 Warrior", "format line")
assert_eq(frame.KnightedText:GetText(), "", "no knighting date")
assert_eq(frame.GuildText:GetText(), "", "no guild line when unguilded")
assert_eq(frame.NavChurch:GetText(), "CHURCH", "church nav")
assert_eq(frame.NavChurch._cobStockTemplate, "UIPanelButtonTemplate",
  "church nav is a stock panel button")
assert_eq(frame.NavGora:GetText(), "GORA", "gora nav")
assert_eq(frame.RecordsButton:GetText(), "RECORDS", "records nav")
local text = allText()
for _, banned in ipairs({
  "Roster", "Ceremonies", "Marked", "Gathering live",
  "QUIET", "ASSEMBLY", "RITE", "CONSEQUENCE", "#1",
  "SANCTIONED GORA", "No sanctioned bouts.", "No rivalries yet.", "None yet.",
  "RIVALRIES", "BEEF RIVALS", "BEEF LEGACY",
  "UNRECORDED", "Not yet in the Church's record.", "Guild rank.",
}) do
  assert_eq(text:find(banned, 1, true), nil, "card never paints '" .. banned .. "'")
end
assert_eq(sounds, 0, "Quiet: no sound on show")

--------------------------------------------------------------------------------
-- A Beef Knight with a record
--------------------------------------------------------------------------------
reset()
local a, b, human = seedKnight()
model = Card:GetModel()
assert_eq(model.entered, true, "entered")
assert_eq(model.rankId, 3, "rank id")
assert_eq(model.rankTitle, "Beef Knight", "rank title from Ranks")
assert_eq(model.relationship, "Belonging", "relationship from Ranks (Bible §5)")
assert_eq(model.knightedAt, 1700000000, "knighted at the Knighting ceremony's time")
assert_eq(model.guildName, "Church of Beef", "guild name")
assert_eq(model.guildRank, "Beefling", "Blizzard guild rank (display)")
assert_eq(model.record.wins, 2, "wins")
assert_eq(model.record.losses, 0, "losses")
assert_eq(model.record.fought, 2, "fought")
assert_eq(model.record.longestStreak, 2, "longest streak")
assert_eq(model.record.defenses, 0, "no defenses for a Knight")
assert_eq(#model.rivalries, 1, "one rivalry")
assert_eq(model.rivalries[1].name, "Tendermage", "rival name")
assert_eq(model.rivalries[1].wins, 2, "rival wins")
assert_eq(model.rivalries[1].losses, 0, "rival losses")
assert_eq(table.concat(model.distinctions, "|"),
  "Most Sanctioned Victories|Longest Streak|The Iron Chin|Greatest Rivalry|The Undefeated|Duke of the Fountain",
  "distinctions: held superlatives then honorifics")
assert_eq(model.decree.line, "Goldshire Inn — Sunday, 7:00 PM", "decree line")

assert_eq(Card:Show(), true, "knight card shows")
frame = Card.frame
assert_eq(frame:GetHeight(), 536, "home card stays compact with a story")
assert_eq(frame.GoraLabel:GetText(), "BEEF GORA", "Gora rubric")
assert_eq(frame.GoraLabel:IsShown(), true, "Gora rubric shown")
assert_eq(frame.NameText:GetText(), "Chuckroast", "name")
local cr, cg, cb = COB.Theme:ClassColor("WARRIOR")
local nr, ng, nb = frame.NameText:GetTextColor()
assert_eq(nr, cr, "name is class-colored (r)")
assert_eq(ng, cg, "name is class-colored (g)")
assert_eq(nb, cb, "name is class-colored (b)")
assert_eq(frame.RankText:GetText(), "Beef Knight", "rank plate is title case, not all caps")
assert_eq(frame.ChurchLabel:GetText(), "Church of Beef", "church title is title case on blackletter")
assert_eq(frame.HonorificText:GetText(), "\"Duke of the Fountain\"", "honorific stays under the rank")
assert_eq(frame.RelationshipText:GetText(), "Belonging", "relationship under the rank")
assert_true(frame.KnightedText:GetText():find("Knighted ", 1, true) == 1, "knighted date line")
assert_eq(frame.GuildText:GetText(), "Church of Beef \194\183 Beefling", "guild · Blizzard rank")
assert_eq(frame.RecordText:GetText(), "Gora 2" .. EN_DASH .. "0", "arabic record 2–0")
assert_eq(frame.VictoryLines[1]:GetText(), "Chuckroast", "front-three name")
assert_eq(frame.VictoryRecords[1]:GetText(), "2" .. EN_DASH .. "0", "front-three record")
assert_eq(frame.YourRecordText:IsShown(), false, "holder in the front three has no personal line")
assert_eq(frame.WeekPlate:GetHeight(), 180, "posted Decree keeps the week plate loud")
assert_eq(frame.GoraPlate:GetHeight(), 180, "held victories keep the Gora plate loud")
assert_eq(frame.GatheringLabel:GetText(), "DECREE", "Quiet posted ribbon is DECREE")
assert_eq(frame.DecreeText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "Gathering title is the Decree line")
assert_eq(frame.FlavorText:GetText(), "The Gathering.", "flavor sits under the line")
assert_eq(frame.FlavorText:IsShown(), true, "posted flavor is shown")
assert_eq(frame.FlavorText._maxLines, 1, "posted flavor stays one line above READ DECREE")
assert_eq(frame.ReadDecreeButton:IsShown(), true, "posted Decree grows a read door")
assert_eq(frame.ReadDecreeButton._cobStockTemplate, "UIPanelButtonTemplate",
  "OPEN NIGHTS is a stock panel button")
text = allText()
assert_true(text:find("BEEF GORA", 1, true) ~= nil, "shown Gora rubric is painted")
assert_true(text:find("THIS WEEK", 1, true) ~= nil, "week rubric is painted")
assert_true(text:find("FROM THE CHRONICLE", 1, true) ~= nil, "Chronicle rubric is painted")
assert_true(text:find("The Gathering.", 1, true) ~= nil, "Decree flavor is on the card")
assert_eq(text:find("SANCTIONED GORA", 1, true), nil, "old Gora rubric is not painted")
assert_eq(text:find("RIVALRIES", 1, true), nil, "old Rivals rubric is not painted")
assert_true(text:find("2" .. EN_DASH .. "0", 1, true) ~= nil, "identity record is arabic 2–0")
assert_eq(text:find("of 2", 1, true), nil, "no position copy")

assert_eq(frame.RankText._cobColorRole, "gold", "rank is gold on the charcoal plate")
assert_eq(frame.DecreeText._cobColorRole, "parchment", "live Gathering ink is parchment on charcoal")
assert_eq(rawget(frame, "GatheringLabel") and rawget(frame, "GatheringLabel")._cobColorRole, "parchment", "leftover ribbon ink is parchment")
assert_eq(rawget(frame, "DecreeRibbon") and frame.DecreeRibbon._cobColorRole, "gathering",
  "Quiet DECREE cloth is gathering umber")
assert_eq(rawget(frame, "GatheringPlate") and rawget(frame, "GatheringPlate")._cobColorRole, "charcoal", "Gathering plate is charcoal")
assert_eq(frame.ChurchLabel._cobColorRole, "gold", "church label is gold on the title band")
assert_eq(frame.ChurchLabel._cobFontRole, "display", "church title uses the display face")
assert_eq(frame.ChurchLabel._cobFontPath, COB.Theme:FontPath("display"),
  "church title path is Theme display")
assert_eq(frame.RankPlate._cobColorRole, "charcoal", "rank plate is charcoal")
assert_eq(frame.IdentityPlate._cobColorRole, "charcoal", "identity plate is charcoal")
assert_eq(frame.IdentityPlate:GetParent() ~= frame, true, "identity charcoal is not under the parchment")
assert_eq(frame.Parchment:GetParent() == frame, true, "parchment stays on the root")
assert_eq(frame.NameText:GetParent() == frame.IdentityBox, true, "name sits on the identity box")
assert_eq(frame.RankText:GetParent() == frame.IdentityBox, true, "rank sits on the identity box")
assert_eq(frame.Parchment._cobTextureName, "parchment_decree", "parchment art through Theme")
assert_eq(frame.Seal._cobTextureName, "seal_papal_small", "papal seal through Theme")
assert_eq(frame.DecreeSigil._cobTextureName, "sigil_gora_small", "gora sigil through Theme")
assert_eq(frame.RankText._cobFontRole, "display", "rank uses the display face")
assert_eq(frame.RankText._cobFontPath, COB.Theme:FontPath("display"),
  "Church rank path is Theme display")
assert_eq(frame.NameText._cobFontRole, "display", "name uses the display face")
assert_eq(frame.NameText._cobFontPath, COB.Theme:FontPath("display"),
  "name path is Theme display")
assert_eq(frame.RecordText._cobFontRole, "label", "identity record uses the label face")
assert_eq(frame.RecordText._cobFontPath, nil, "identity record is stock GameFont")
assert_eq(frame.RelationshipText._cobFontRole, "body", "relationship uses the body face")
assert_eq(frame.RelationshipText._cobFontPath, nil, "relationship is stock GameFont")
assert_eq(frame.DecreeText._cobFontRole, "body", "Decree leftover is not blackletter")
assert_eq(frame.DecreeText._cobFontPath, nil, "Decree leftover is stock GameFont")
assert_eq(frame.WeekLabel._cobFontPath, nil, "THIS WEEK is stock GameFont")
assert_eq(frame.GoraLabel._cobFontPath, nil, "BEEF GORA is stock GameFont")
assert_eq(frame.ChronicleLabel._cobFontPath, nil, "Chronicle rubric is stock GameFont")
assert_eq(frame.GoraLabel._cobColorRole, "oxblood", "Gora rubric is oxblood on parchment")

assert_eq(Card:ShowGora(), true, "THE RECORD opens the Gora ledger")
assert_eq(Card.view, "gora", "view is the Gora ledger")
assert_eq(frame.HomePane:IsShown(), false, "home pane hides on the ledger")
assert_eq(frame.GoraLedger:IsShown(), true, "ledger is shown")
assert_eq(frame.LedgerRows[1].Name:GetText(), "Chuckroast", "ledger names the fighter")
assert_eq(frame.LedgerRows[1].Record:GetText(), "2" .. EN_DASH .. "0", "ledger paints the arabic record")
local _, _, _, nameX = frame.LedgerRows[1].Name:GetPoint(1)
local _, _, _, recX = frame.LedgerRows[1].Record:GetPoint(1)
assert_eq(nameX, 0, "fighter cell shares the Fighter header origin")
assert_eq(recX, 188, "record cell stays on the Record column")
assert_eq(Card:ShowHome(), true, "CHURCH returns home")
assert_eq(Card.view, "home", "view is home")
assert_eq(frame.HomePane:IsShown(), true, "home pane returns")

--------------------------------------------------------------------------------
-- One and two sanctioned fighters; a long name stays one line
--------------------------------------------------------------------------------
reset()
local onlyA = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
local onlyB = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
Store:RecordGoraResult(onlyA.id, { opponentId = onlyB.id, ruling = "victor", won = true }, 100)
stub.playerName = "Chuckroast"
Card:Show()
frame = Card.frame
assert_eq(frame.VictoryLines[1]:GetText(), "Chuckroast", "one-fighter home names the recorded fighter")
assert_eq(frame.VictoryLines[2]:IsShown(), false, "one-fighter home has no second row")
assert_eq(frame.VictoryLines[3]:IsShown(), false, "one-fighter home has no third row")
assert_eq(frame.GoraPlate:GetHeight(), 180, "one fighter still uses the loud Gora column")
Store:RecordGoraResult(onlyB.id, { opponentId = onlyA.id, ruling = "victor", won = false }, 100)
Card:Refresh()
assert_eq(frame.VictoryLines[1]:GetText(), "Chuckroast", "two-fighter home keeps the victor first")
assert_eq(frame.VictoryLines[2]:GetText(), "Tendermage", "two-fighter home names the other")
assert_eq(frame.VictoryLines[3]:IsShown(), false, "two-fighter home has no third row")

reset()
stub.playerName = "Supercalifragilisticexpialidocious"
Card:Show()
frame = Card.frame
assert_eq(frame.NameText:GetText(), "Supercalifragilisticexpialidocious", "long name is painted")
assert_eq(frame.NameText._maxLines, 1, "long name stays one line")

--------------------------------------------------------------------------------
-- Victory front: three names from Core order; outsider gets a personal line
--------------------------------------------------------------------------------
local function seedFront()
  local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
  local c = Store:CreateCharacter({ name = "Brisketh", class = "Rogue", level = 69 })
  local d = Store:CreateCharacter({ name = "Sirloin", class = "Paladin", level = 70 })
  bout(a, b, a, 100)
  bout(a, c, a, 200)
  bout(a, d, a, 300)
  bout(c, b, c, 400)
  bout(c, d, c, 500)
  bout(b, d, b, 600)
  return a, b, c, d
end

reset()
seedFront()
stub.playerName = "Chuckroast"
Card:Show()
frame = Card.frame
assert_eq(frame.VictoryLines[1]:GetText(), "Chuckroast", "front 1 by victories")
assert_eq(frame.VictoryRecords[1]:GetText(), "3" .. EN_DASH .. "0", "front 1 is 3-0")
assert_eq(frame.VictoryLines[2]:GetText(), "Brisketh", "front 2 by victories")
assert_eq(frame.VictoryRecords[2]:GetText(), "2" .. EN_DASH .. "1", "front 2 is 2-1")
assert_eq(frame.VictoryLines[3]:GetText(), "Tendermage", "front 3 by victories")
assert_eq(frame.VictoryRecords[3]:GetText(), "1" .. EN_DASH .. "2", "front 3 is 1-2")
assert_eq(frame.YourRecordText:IsShown(), false, "a front-three fighter has no personal line")
assert_eq(frame.VictoryLines[1]._cobColorRole, "oxblood", "local fighter in the front is oxblood")
text = allText()
assert_eq(text:find("Your record", 1, true), nil, "front-three home does not paint a personal line")
assert_eq(text:find("#", 1, true), nil, "front never paints a position mark")

assert_eq(Card:ShowGora(), true, "expanded ledger opens from the front")
assert_eq(frame:GetHeight(), 444, "four-row ledger stays compact")
assert_eq(frame.LedgerScroll ~= nil, true, "ledger owns a FauxScrollFrame")
assert_eq(frame.LedgerScroll.ScrollBar:IsShown(), false, "four rows hide the thumb")
assert_eq(frame.LedgerRows[1].Name:GetText(), "Chuckroast", "ledger 1 matches VictoryFront")
assert_eq(frame.LedgerRows[2].Name:GetText(), "Brisketh", "ledger 2 matches VictoryFront")
assert_eq(frame.LedgerRows[3].Name:GetText(), "Tendermage", "ledger 3 matches VictoryFront")
assert_eq(frame.LedgerRows[4].Name:GetText(), "Sirloin", "ledger keeps the rest of FighterStories")
assert_eq(frame.LedgerRows[4].Record:GetText(), "0" .. EN_DASH .. "3", "fourth row is 0-3")

reset()
seedFront()
stub.playerName = "Sirloin"
Card:Show()
frame = Card.frame
assert_eq(frame.VictoryLines[1]:GetText(), "Chuckroast", "outsider home still names the front")
assert_eq(frame.VictoryLines[3]:GetText(), "Tendermage", "outsider home keeps three names")
assert_eq(frame.YourRecordText:IsShown(), true, "outsider paints a personal line")
assert_eq(frame.YourRecordText:GetText(), "Your record 0" .. EN_DASH .. "3", "personal line is arabic W-L")
assert_eq(frame.WeekPlate:GetHeight(), 180, "outsider week column matches the loud row")
assert_eq(frame.WeekPlate._cobColorRole, "parchment", "outsider empty week stays parchment")
assert_eq(frame.GoraPlate:GetHeight(), 180, "outsider Gora plate stays loud")
text = allText()
assert_true(text:find("Your record", 1, true) ~= nil, "outsider home paints the personal line")
assert_eq(text:find("#", 1, true), nil, "personal line never paints a position")
assert_eq(text:find("standing", 1, true), nil, "personal line never says standing")

reset()
local champ = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
for i = 1, 10 do
  bout(champ, Store:CreateCharacter({ name = string.format("Beef%02d", i) }), champ, i * 100)
end
stub.playerName = "Chuckroast"
Card:ShowGora()
frame = Card.frame
assert_eq(#Card:GetModel().stories, 11, "all sanctioned fighters stay on the model")
assert_eq(frame.LedgerRows[1].Name:GetText(), "Chuckroast", "scroll window starts at the front")
assert_eq(frame.LedgerRows[8].Name:GetText(), "Beef04", "eighth visible row is story 8")
assert_eq(frame.LedgerScroll.ScrollBar:IsShown(), true, "ten-plus fighters show the thumb")
FauxScrollFrame_SetOffset(frame.LedgerScroll, 3)
Card:Refresh()
assert_eq(frame.LedgerRows[1].Name:GetText(), "Beef08", "offset 3 starts at story 4")
assert_eq(frame.LedgerRows[8].Name:GetText(), "Beef01", "offset 3 ends at story 11")
assert_eq(Card.view, "gora", "scroll refresh stays on the ledger")

reset()
Card.frame = nil
local savedCreate = CreateFrame
CreateFrame = function(kind, name, parent, template)
  if template == "FauxScrollFrameTemplate" then
    error("missing FauxScrollFrameTemplate")
  end
  return savedCreate(kind, name, parent, template)
end
assert_eq(Card:Show(), true, "card builds when FauxScrollFrameTemplate is missing")
assert_eq(Card.frame.LedgerScroll ~= nil, true, "ledger scroll falls back")
CreateFrame = savedCreate

reset()
Decree:Set({ line = "TODAY IS THE DAY FOR BEEF", flavor = "TESTING BEEF FLAVOR HERE" })
stub.playerName = "Thedave"
Card:Show()
frame = Card.frame
assert_eq(frame.DecreeText:GetText(), "TODAY IS THE DAY FOR BEEF", "live Decree title paints")
assert_eq(frame.FlavorText:GetText(), "TESTING BEEF FLAVOR HERE", "live Decree flavor paints")
assert_eq(frame.ReadDecreeButton:IsShown(), true, "live Decree still offers READ DECREE")
assert_eq(frame.FlavorText._maxLines, 1, "live flavor does not stack onto the verb")

reset()
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
stub.playerName = "Beefina"
Card:Show()
frame = Card.frame
assert_eq(frame.WeekPlate:GetHeight(), 180, "posted Decree with no Goras still uses the loud row")
assert_eq(frame.GoraPlate:GetHeight(), 180, "empty Gora column matches the loud week")
assert_eq(frame.WeekPlate._cobColorRole, "charcoal", "posted week stays charcoal")
assert_eq(frame.GoraEmptyText:IsShown(), true, "empty Gora copy stays on the aligned plate")
assert_eq(frame:GetHeight(), 536, "one loud column keeps the full card")

--------------------------------------------------------------------------------
-- Refresh follows the store; a Lord shows defenses
--------------------------------------------------------------------------------
reset()
a, b, human = seedKnight()
Card:Show()
bout(a, b, b, 1700000300)
assert_eq(Card:Refresh(), true, "Refresh repaints")
assert_eq(frame.RecordText:GetText(), "Gora 2" .. EN_DASH .. "1", "record follows the store")
Store:SetRank(human.id, 4, 1700000400)
bout(a, b, a, 1700000500)
Card:Refresh()
assert_eq(frame.RankText:GetText(), "Beef Lord", "rank follows the store")
assert_eq(frame.RelationshipText:GetText(), "Proven prestige", "Lord relationship line")
assert_eq(Card:GetModel().record.defenses, 1, "a Lord's defense is still on the model")

--------------------------------------------------------------------------------
-- Entered but unranked human (Store paths other than Knighting)
--------------------------------------------------------------------------------
reset()
local c = Store:CreateCharacter({ name = "Beefina", class = "Priest" })
local h2 = Store:CreateHuman({ name = "Bee" })
Store:LinkCharacter(c.id, h2.id)
Card:Show()
frame = Card.frame
assert_eq(frame.RankText:GetText(), "UNRANKED", "entered without a rank")
assert_eq(frame.RelationshipText:GetText(), "Recorded, no rank yet.", "honest unranked line")

--------------------------------------------------------------------------------
-- Live guild rank titles that match a canon Church title show on the plate.
-- That is display, not a store write. The store still wins when it has a row.
--------------------------------------------------------------------------------
reset()
stub.guildRankIndex = 0
stub.guildRankName = "Beef Knight"
model = Card:GetModel()
assert_eq(model.entered, false, "a guild title does not enter the Church store")
assert_eq(model.rankId, 3, "matching guild title supplies the display id")
assert_eq(model.rankTitle, "Beef Knight", "matching guild title supplies the display title")
assert_eq(model.relationship, "Belonging", "matching guild title supplies the relationship")
assert_eq(model.knightedAt, nil, "guild title invents no Knighting date")
assert_eq(Card:Show(), true, "guild-title card shows")
frame = Card.frame
assert_eq(frame.RankText:GetText(), "Beef Knight", "gold plate shows the matching guild title")
assert_eq(frame.RelationshipText:GetText(), "Belonging", "relationship from the matched title")
assert_eq(frame.KnightedText:GetText(), "", "no fake Knighting date")
assert_eq(frame.GoraEmptyText:IsShown(), true, "no record until the store has one — Gora stays compact")
assert_eq(frame.RecordText:GetText(), "", "identity record stays empty without a store row")
assert_eq(frame.GuildText:GetText(), "Church of Beef \194\183 Beef Knight", "small line still shows the Blizzard name")

reset()
stub.guildRankIndex = 0
stub.guildRankName = "Guild Master"
model = Card:GetModel()
assert_eq(model.rankTitle, nil, "a non-canon guild title is not a Church rank")
Card:Show()
assert_eq(Card.frame.RankText:GetText(), "Guild Master", "the plate shows the live guild rank")
assert_eq(Card.frame.RankText._cobFontRole, "label", "a non-canon guild title is not the display face")
assert_eq(Card.frame.RelationshipText:GetText(), "The Pope has not written you yet. That is normal.",
  "guild-rank plate uses the newness line")
assert_eq(Card.frame.GuildText:GetText(), "Church of Beef \194\183 Guild Master", "small line keeps the Blizzard name")

reset()
stub.playerName = "Thedave"
stub.guildRankIndex = 0
stub.guildRankName = "Beef Prophet"
local savedPopes = COB.Popes
COB.Popes = { IsListed = function(n) return n == "Thedave" end }
Card:Show()
assert_eq(Card.frame.RankText:GetText(), "Beef Prophet", "the plate shows the live guild title")
assert_eq(Card.frame.RankText._cobFontRole, "label", "Beef Prophet as a guild title is not a Church rank face")
assert_eq(Card.frame.RelationshipText:GetText(), "The Pope has not written you yet. That is normal.",
  "a listed Pope is not a Church rank on the plate")
assert_eq(Card.frame.GuildText:GetText(), "Church of Beef \194\183 Beef Prophet", "small line keeps the Blizzard name")
COB.Popes = savedPopes

reset()
stub.guildRankIndex = nil
local savedRoster = COB.Roster
local rosterReads = 0
COB.Roster = {
  GetGuildRankName = function(_, who)
    rosterReads = rosterReads + 1
    if who == "Beefina" then return "Beef Knight" end
    return nil
  end,
}
model = Card:GetModel()
assert_eq(model.guildRank, "Beef Knight", "GetGuildInfo miss falls back to the roster name")
assert_eq(model.rankTitle, "Beef Knight", "roster fallback still matches a canon title")
assert_true(rosterReads >= 1, "the card asked the roster for the rank name")
COB.Roster = savedRoster

reset()
local kicks = 0
savedRoster = COB.Roster
COB.Roster = {
  Refresh = function() kicks = kicks + 1; return true end,
  AttachLibrary = function() end,
  IsReady = function() return true end,
}
assert_eq(Card:Show(), true, "card shows while kicking the roster")
assert_true(kicks >= 1, "Show refreshes the guild roster")
assert_eq(Card.frame:IsEventRegistered("GUILD_ROSTER_UPDATE"), true, "shown card listens for roster updates")
assert_eq(Card.frame:IsEventRegistered("PLAYER_GUILD_UPDATE"), true, "shown card listens for guild updates")
assert_eq(Card.frame:IsEventRegistered("UNIT_PORTRAIT_UPDATE"), true, "shown card listens for the unit portrait")
COB.Roster = savedRoster

reset()
Card.frame = nil
do
  local calls = 0
  local savedPortrait = SetPortraitTexture
  SetPortraitTexture = function(tex, unit)
    calls = calls + 1
    if tex then tex._portraitUnit = unit end
  end
  Card:Show()
  assert_true(calls >= 1, "unit portrait paints after the card is shown")
  assert_eq(Card.frame.Portrait._cobPortrait, "player", "shown card keeps the unit portrait")
  assert_eq(Card.frame.Portrait._portraitUnit, "player", "portrait reads the local unit")
  SetPortraitTexture = savedPortrait
end

reset()
do
  local hidden = 0
  local savedWelcome = COB.Welcome
  COB.Welcome = {
    IsShown = function() return true end,
    frame = { Hide = function() hidden = hidden + 1 end },
  }
  Card:Show()
  assert_eq(hidden, 1, "card yields a first-launch sheet without stamping it")
  assert_eq(ChurchOfBeefDB.ui.welcomeSeen, nil, "yielding the first-launch sheet does not stamp seen")
  COB.Welcome = savedWelcome
end

reset()
savedRoster = COB.Roster
Card:Show()
COB.Roster = {
  Refresh = function() return true end,
  GetGuildRankName = function() return "Beef Lord" end,
}
stub.fire(Card.frame, "OnEvent", "GUILD_ROSTER_UPDATE")
assert_eq(Card.frame.RankText:GetText(), "Beef Lord", "a late roster update repaints the plate")
COB.Roster = savedRoster

reset()
stub.guildRankIndex = 0
stub.guildRankName = "Fresh Beef"
local enteredChar = Store:CreateCharacter({ name = "Beefina", class = "Priest" })
local enteredHuman = Store:CreateHuman({ name = "Bee" })
Store:LinkCharacter(enteredChar.id, enteredHuman.id)
Card:Show()
assert_eq(Card.frame.RankText:GetText(), "UNRANKED", "an entered store row beats a matching guild title")
assert_eq(Card.frame.RelationshipText:GetText(), "Recorded, no rank yet.", "store-unranked copy stays")

--------------------------------------------------------------------------------
-- Goldshire Pope client (2026-09-14 SV): entered-unranked Thedave, 2–1
-- vs Regularbeef, posted Decree, live Gora rite. Guild title Beef Prophet
-- must not replace the store plate.
--------------------------------------------------------------------------------
reset()
Card.frame = nil
do
  local dave = Store:CreateCharacter({ name = "Thedave", class = "Warrior", level = 70 })
  local beef = Store:CreateCharacter({ name = "Regularbeef", class = "Hunter", level = 36 })
  local hDave = Store:CreateHuman({ name = "Thedave" })
  local hBeef = Store:CreateHuman({ name = "Regularbeef" })
  Store:LinkCharacter(dave.id, hDave.id)
  Store:LinkCharacter(beef.id, hBeef.id)
  Store:SetRank(hBeef.id, 3)
  Store:AppendCeremony("Knighting", { hBeef.id }, 1789444424)
  bout(beef, dave, beef, 1789444319)
  bout(dave, beef, dave, 1789444341)
  bout(dave, beef, dave, 1789444670)
  Store:AppendCeremony("victor", { dave.id, beef.id }, 1789444670)
  Decree:Set({ line = "TODAY IS THE DAY FOR BEEF", flavor = "TESTING BEEF FLAVOR HERE" })
  stub.playerName = "Thedave"
  stub.guildRankIndex = 0
  stub.guildRankName = "Beef Prophet"
  local savedRuntime = COB.Runtime
  COB.Runtime = { Snapshot = function() return { state = "RITE", riteType = "Gora" } end }
  Card:Show()
  frame = Card.frame
assert_eq(frame.RankText:GetText(), "UNRANKED", "Goldshire plate is the store row")
assert_eq(frame.RankText._cobFontRole, "label", "UNRANKED is not the Church-rank display face")
assert_eq(frame.RankText._cobFontPath, nil, "UNRANKED is stock GameFont")
assert_eq(frame.RankText._cobFontSize, 14, "UNRANKED stays smaller than a canon title")
assert_eq(frame.RelationshipText:GetText(), "Recorded, no rank yet.", "Goldshire newness is unranked")
  assert_eq(frame.RecordText:GetText(), "Gora 2" .. EN_DASH .. "1", "Goldshire personal record")
  assert_eq(frame.VictoryLines[1]:GetText(), "Thedave", "Goldshire front names Thedave")
  assert_eq(frame.VictoryRecords[1]:GetText(), "2" .. EN_DASH .. "1", "Goldshire front record")
  assert_eq(frame.VictoryLines[2]:GetText(), "Regularbeef", "Goldshire second name")
  assert_eq(frame.VictoryRecords[2]:GetText(), "1" .. EN_DASH .. "2", "Goldshire second record")
  assert_eq(frame.VictoryLines[3]:IsShown(), false, "two fighters do not invent a third")
  assert_eq(frame.YourRecordText:IsShown(), false, "Thedave is in the front three")
  assert_eq(frame.GatheringLabel:GetText(), "GORA", "live Gora rite names the ribbon")
  assert_eq(frame.GatheringLabel._cobColorRole, "parchment", "live Gora ribbon ink is parchment")
  assert_eq(frame.DecreeRibbon._cobColorRole, "gora", "live Gora cloth is steel")
  assert_eq(frame.DecreeText:GetText(), "TODAY IS THE DAY FOR BEEF", "posted Decree stays the week title")
  assert_eq(frame.FlavorText:GetText(), "TESTING BEEF FLAVOR HERE", "posted flavor stays")
  assert_eq(frame.ChronicleHeadlines[1]:GetText(), "A VICTOR DECLARED", "latest ceremony is first")
  assert_eq(frame.ChronicleBodies[1]:GetText(), "Thedave declared victor over Regularbeef.",
    "victor line is clerical")
  assert_eq(frame.ChronicleHeadlines[2]:GetText(), "A KNIGHTING", "prior ceremony is second")
  local painted = allText()
  assert_eq(painted:find("BEEF PROPHET", 1, true), nil, "guild title does not replace the store plate")
  assert_eq(painted:find("#1", 1, true), nil, "Goldshire front has no position")
  assert_eq(Card:ShowGora(), true, "Goldshire THE RECORD opens")
  assert_eq(frame.LedgerRows[1].Name:GetText(), "Thedave", "ledger keeps VictoryFront order")
  assert_eq(frame.LedgerRows[2].Name:GetText(), "Regularbeef", "ledger second row")
  assert_eq(frame.LedgerRows[3]:IsShown(), false, "ledger does not invent a third fighter")
  COB.Runtime = savedRuntime
end

--------------------------------------------------------------------------------
-- Live Goldshire after Tonyswife: UTF-8 Regularbéef 3–3 (last victor),
-- Thedave 3–2, Tonyswife 0–1. Posted Decree, no live rite. No position column.
--------------------------------------------------------------------------------
reset()
Card.frame = nil
do
  local REGULARBEEF = "Regularb\195\169ef"
  local dave = Store:CreateCharacter({ name = "Thedave", class = "Warrior", level = 70 })
  local beef = Store:CreateCharacter({ name = REGULARBEEF, class = "Hunter", level = 36 })
  local tony = Store:CreateCharacter({ name = "Tonyswife", class = "Mage", level = 16 })
  local hDave = Store:CreateHuman({ name = "Thedave" })
  local hBeef = Store:CreateHuman({ name = REGULARBEEF })
  local hTony = Store:CreateHuman({ name = "Tonyswife" })
  Store:LinkCharacter(dave.id, hDave.id)
  Store:LinkCharacter(beef.id, hBeef.id)
  Store:LinkCharacter(tony.id, hTony.id)
  Store:SetRank(hBeef.id, 4)
  Store:AppendCeremony("Elevation", { hBeef.id }, 1789447164)
  bout(beef, dave, beef, 1)
  bout(dave, beef, dave, 2)
  bout(dave, beef, dave, 3)
  bout(beef, dave, beef, 4)
  bout(dave, beef, dave, 5)
  Store:AppendCeremony("victor", { dave.id, beef.id }, 1789447382)
  bout(beef, tony, beef, 6)
  Store:AppendCeremony("victor", { beef.id, tony.id }, 1789448676)
  Decree:Set({ line = "Big raid today", flavor = "Nov 4th" })
  stub.playerName = "Thedave"
  stub.guildRankIndex = 0
  stub.guildRankName = "Beef Prophet"
  Card:Show()
  frame = Card.frame
  assert_eq(frame.RankText:GetText(), "UNRANKED", "quiet-night plate stays the store row")
  assert_eq(frame.RankText._cobFontRole, "label", "UNRANKED is not the Church-rank display face")
  assert_eq(frame.GatheringLabel:GetText(), "DECREE", "quiet night names the ribbon DECREE")
  assert_eq(frame.VictoryLines[1]:GetText(), REGULARBEEF, "tied 3-win recency leads the front")
  assert_eq(frame.VictoryRecords[1]:GetText(), "3" .. EN_DASH .. "3", "front 1 is 3-3")
  assert_eq(frame.VictoryLines[2]:GetText(), "Thedave", "Thedave is second on the same win count")
  assert_eq(frame.VictoryRecords[2]:GetText(), "3" .. EN_DASH .. "2", "front 2 is 3-2")
  assert_eq(frame.VictoryLines[3]:GetText(), "Tonyswife", "third sanctioned fighter is on the home front")
  assert_eq(frame.VictoryRecords[3]:GetText(), "0" .. EN_DASH .. "1", "front 3 is 0-1")
  assert_eq(frame.GoraGlyph:IsShown(), false, "quiet-night home hides the 14px glyph")
  assert_eq(frame.PortraitWell._cobColorRole, "charcoal", "quiet-night well stays charcoal")
  assert_eq(frame.ChronicleHeadlines[1]:GetText(), "A VICTOR DECLARED", "latest ceremony is first")
  assert_eq(frame.ChronicleBodies[1]:GetText(), REGULARBEEF .. " declared victor over Tonyswife.",
    "latest bout is clerical")
  assert_eq(frame.ChronicleHeadlines[2]:GetText(), "A VICTOR DECLARED", "prior bout is second")
  Card:ShowGora()
  assert_eq(frame.LedgerRows[1].Name:GetText(), REGULARBEEF, "3-3 recency is first")
  assert_eq(frame.LedgerRows[1].Record:GetText(), "3" .. EN_DASH .. "3", "Regularbéef 3-3")
  assert_eq(frame.LedgerRows[1].Streak:GetText(), "Streak 1", "Regularbéef's last result is a win")
  assert_eq(frame.LedgerRows[1].Last:GetText(), "victor over Tonyswife", "Regularbéef's last Gora")
  assert_eq(frame.LedgerRows[2].Name:GetText(), "Thedave", "Thedave is second")
  assert_eq(frame.LedgerRows[2].Record:GetText(), "3" .. EN_DASH .. "2", "Thedave 3-2")
  assert_eq(frame.LedgerRows[2].Streak:GetText(), "Streak 1", "Thedave's last result vs Regularbéef is a win")
  assert_eq(frame.LedgerRows[2].Last:GetText(), "victor over " .. REGULARBEEF, "Thedave's last Gora")
  assert_eq(frame.LedgerRows[3].Name:GetText(), "Tonyswife", "third fighter is on the ledger")
  assert_eq(frame.LedgerRows[3].Record:GetText(), "0" .. EN_DASH .. "1", "Tonyswife 0-1")
  assert_eq(frame.LedgerRows[3].Last:GetText(), "fell to " .. REGULARBEEF, "Tonyswife's last Gora")
  assert_eq(frame.LedgerRows[1].Last._maxLines, 1, "Last Gora clips to one line")
  assert_eq(frame.LedgerRows[4]:IsShown(), false, "three-row ledger invents no fourth")
  local ledgerText = allText()
  assert_eq(ledgerText:find("#", 1, true), nil, "ledger never paints a position")
  assert_eq(ledgerText:find("standing", 1, true), nil, "ledger never says standing")
end

reset()
seedKnight()
stub.guildRankName = "Fresh Beef"
Card:Show()
assert_eq(Card.frame.RankText:GetText(), "Beef Knight", "store rank beats a conflicting guild title")
assert_eq(Card.frame.RelationshipText:GetText(), "Belonging", "store relationship stays")

--------------------------------------------------------------------------------
-- Runtime ≠ QUIET: ribbon names the event; the Decree line stays the title.
--------------------------------------------------------------------------------
do
  reset()
  local savedRuntime = COB.Runtime
  local savedWelcome = COB.Welcome
  local savedToasts = COB.Toasts
  local welcomeShows, toastCalls = 0, 0
  COB.Welcome = { Show = function() welcomeShows = welcomeShows + 1; return true end }
  COB.Toasts = { Proclaim = function() toastCalls = toastCalls + 1; return true end }
  COB.Runtime = { Snapshot = function() return { state = "ASSEMBLY" } end }
  Card:Show()
  assert_eq(Card.frame.GatheringLabel:GetText(), "GATHERING", "Assembly ribbon is GATHERING")
  assert_eq(Card.frame.DecreeText:GetText(), "No nights posted this week.",
    "live Runtime still shows the empty Decree line")
  assert_eq(welcomeShows, 0, "live Gathering never reopens welcome")
  assert_eq(toastCalls, 0, "live Gathering never toasts")

  Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "Bring a stool." })
  Card:Refresh()
  assert_eq(Card.frame.GatheringLabel:GetText(), "GATHERING", "Assembly ribbon stays GATHERING")
  assert_eq(Card.frame.DecreeText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
    "live Runtime title is the posted Decree line")
  assert_eq(Card.frame.FlavorText:GetText(), "Bring a stool.", "live Runtime keeps flavor")
  assert_eq(Card.frame.FlavorText:IsShown(), true, "live flavor is shown")
  assert_eq(Card.frame.DecreeText._cobColorRole, "parchment", "posted line ink is parchment")

  COB.Runtime = { Snapshot = function() return { state = "RITE", riteType = "Knighting" } end }
  Card:Refresh()
  assert_eq(Card.frame.GatheringLabel:GetText(), "KNIGHTING", "Knighting ribbon")
  assert_eq(Card.frame.DecreeText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
    "RITE keeps the Decree line")

  COB.Runtime = { Snapshot = function() return { state = "RITE", riteType = "Gora" } end }
  Card:Refresh()
  assert_eq(Card.frame.GatheringLabel:GetText(), "GORA", "Gora ribbon")

  COB.Runtime = { Snapshot = function() return { state = "CONSEQUENCE", riteType = "Gora" } end }
  Card:Refresh()
  assert_eq(Card.frame.GatheringLabel:GetText(), "GORA", "Consequence keeps the rite ribbon")

  COB.Runtime = { Snapshot = function() return { state = "QUIET" } end }
  Card:Refresh()
  assert_eq(Card.frame.GatheringLabel:GetText(), "DECREE", "Quiet ribbon is DECREE")
  assert_eq(Card.frame.DecreeText:GetText(), "Goldshire Inn — Sunday, 7:00 PM",
    "Quiet Runtime keeps the posted Decree line")

  Decree:Clear()
  Card:Refresh()
  assert_eq(Card.frame.DecreeText:GetText(), "No nights posted this week.",
    "Quiet Runtime empty Gathering copy")
  assert_eq(Card.frame.DecreeText._cobColorRole, "iron", "empty Gathering ink is iron")
  assert_eq(Card.frame.FlavorText:IsShown(), false, "cleared flavor is hidden")

  COB.Runtime = nil
  Card:Refresh()
  assert_eq(Card.frame.DecreeText:GetText(), "No nights posted this week.",
    "missing Runtime is Quiet Gathering")
  assert_eq(Card.frame.GatheringLabel:GetText(), "DECREE", "missing Runtime ribbon is DECREE")
  assert_eq(welcomeShows, 0, "missing Runtime never reopens welcome")
  assert_eq(toastCalls, 0, "missing Runtime never toasts")
  local liveText = ""
  if Card.frame.GatheringLabel then liveText = Card.frame.GatheringLabel:GetText() or "" end
  for _, banned in ipairs({ "QUIET", "ASSEMBLY", "RITE", "CONSEQUENCE" }) do
    assert_eq(liveText:find(banned, 1, true), nil, "ribbon never paints '" .. banned .. "'")
  end
  COB.Runtime = savedRuntime
  COB.Welcome = savedWelcome
  COB.Toasts = savedToasts
end

--------------------------------------------------------------------------------
-- Lifecycle: toggle, ESC, persist, the one path out
--------------------------------------------------------------------------------
reset()
assert_eq(Card:Init(), Card:Init(), "Init is idempotent")
assert_eq(Card:IsShown(), false, "hidden after Init")
assert_eq(Card:Toggle(), true, "Toggle shows")
assert_eq(Card:IsShown(), true, "shown")
assert_eq(Card:Toggle(), true, "Toggle hides")
assert_eq(Card:IsShown(), false, "hidden")
assert_eq(countSpecial("ChurchOfBeefPlayerCard"), 1, "ESC-listed once")
Card:Show()
Card.frame:Hide()
assert_eq(countSpecial("ChurchOfBeefPlayerCard"), 1, "widget Hide re-lists without duplicating")
assert_eq(Card:IsShown(), false, "widget Hide is seen by IsShown")

Card:Show()
frame = Card.frame
assert_true(stub.fire(frame.CloseButton, "OnClick"), "close is wired")
assert_eq(Card:IsShown(), false, "close hides the card")
assert_eq(frame.CloseButton._cobClose, true, "close is the shared window X")
assert_eq(frame.CloseButton:GetWidth(), COB.Theme.CloseSize, "close is stock width")
assert_eq(frame.CloseButton:GetNormalTexture(), COB.Theme:Texture("close_up"),
  "close uses the stock X")

Card:Show()
assert_true(stub.fire(frame.TitleBar, "OnDragStart"), "title bar drags")
assert_true(stub.fire(frame.TitleBar, "OnDragStop"), "drag stop saves")
local slot = ChurchOfBeefDB.ui.playerCard
assert_true(type(slot) == "table" and type(slot.point) == "table", "position persists to ui.playerCard")
assert_eq(slot.point.point, "CENTER", "default anchor persisted")
assert_eq(ChurchOfBeefDB.ui.playerCard.w, nil, "no size persisted — the card is fixed")

local shows = 0
local savedBook = COB.RecordsBook
COB.RecordsBook = { Show = function() shows = shows + 1; return true end }
assert_eq(frame.RecordsButton:GetText(), "RECORDS", "the records path out")
assert_true(stub.fire(frame.RecordsButton, "OnClick"), "records button wired")
assert_eq(shows, 1, "records button opens the Records Book")
assert_eq(Card:IsShown(), false, "the card steps aside for the book")
COB.RecordsBook = nil
Card:Show()
assert_eq(Card:OpenRecords(), false, "no book → guarded false")
assert_eq(Card:IsShown(), true, "without a book the card stays")
COB.RecordsBook = savedBook

local fromCardOpens, dismisses = 0, 0
local bookShown = false
COB.RecordsBook = {
  IsShown = function() return bookShown end,
  Show = function() shows = shows + 1; bookShown = true; return true end,
  ShowFromCard = function() fromCardOpens = fromCardOpens + 1; bookShown = true; return true end,
  Hide = function() bookShown = false; return true end,
  Dismiss = function() dismisses = dismisses + 1; bookShown = false; return true end,
}
Card:Show()
assert_eq(Card:OpenRecords(), true, "records opens on the return path")
assert_eq(fromCardOpens, 1, "OpenRecords prefers ShowFromCard")
assert_eq(Card:IsShown(), false, "the card still steps aside")
assert_eq(bookShown, true, "the book is shown")
assert_eq(Card:Show(), true, "Show returns to the dashboard")
assert_eq(dismisses, 1, "returning to the card dismisses the book")
assert_eq(Card:IsShown(), true, "the card is the /beef dashboard again")
assert_eq(bookShown, false, "the book and card do not stack")
COB.RecordsBook = savedBook

--------------------------------------------------------------------------------
-- Task 14: listed-Pope desk door. Congregation card must not grow one.
--------------------------------------------------------------------------------
reset()
local deskShows = 0
local savedConsole, savedSender = COB.Console, COB.Sender
COB.Console = {
  Show = function()
    deskShows = deskShows + 1
  end,
  Toggle = function()
    deskShows = deskShows + 1
  end,
}
COB.Sender = {
  IsRegisteredPope = function() return false end,
}
assert_eq(Card:Show(), true, "congregation card still shows")
frame = Card.frame
assert_true(frame.DeskButton == nil or frame.DeskButton:IsShown() ~= true,
  "congregation card has no desk door")
assert_eq(allText():find("THE DESK", 1, true), nil,
  "congregation card does not paint THE DESK")
assert_eq(Card:OpenDesk(), false, "congregation OpenDesk refuses")
assert_eq(deskShows, 0, "congregation door never Shows the console")
assert_eq(Card:IsShown(), true, "congregation /beef stays the card")

COB.Sender = {
  IsRegisteredPope = function() return true end,
}
assert_eq(Card:Show(), true, "listed-Pope card shows")
frame = Card.frame
assert_true(frame.DeskButton ~= nil, "listed-Pope card grows a desk door")
assert_eq(frame.DeskButton:IsShown(), true, "listed-Pope desk door is shown")
assert_eq(frame.DeskButton:GetText(), "THE DESK", "desk door label")
assert_true(stub.fire(frame.DeskButton, "OnClick"), "desk door wired")
assert_eq(deskShows, 1, "listed-Pope desk door Shows the console")
assert_eq(Card:OpenDesk(), true, "listed-Pope OpenDesk reaches Console:Show")
assert_eq(deskShows, 2, "OpenDesk Shows the console")
COB.Console = {
  Show = function()
    deskShows = deskShows + 1
    error("congregation must not reach Show")
  end,
}
COB.Sender = {
  IsRegisteredPope = function() return false end,
}
Card:Refresh()
assert_true(frame.DeskButton == nil or frame.DeskButton:IsShown() ~= true,
  "a later congregation paint hides the desk door")
assert_eq(Card:OpenDesk(), false, "congregation OpenDesk stays refused")
assert_eq(deskShows, 2, "congregation Refresh does not Show the desk")
COB.Console, COB.Sender = savedConsole, savedSender

--------------------------------------------------------------------------------
-- Missing optional modules never fail load or paint
--------------------------------------------------------------------------------
reset()
local savedRecords, savedRanks, savedDecree = COB.Records, COB.Ranks, COB.Decree
COB.Records, COB.Ranks, COB.Decree = nil, nil, nil
seedKnight()
assert_eq(Card:Show(), true, "card shows without Records/Ranks/Decree")
assert_eq(Card.frame.GoraEmptyText:IsShown(), true, "no Records keeper → Gora stays compact")
assert_eq(Card.frame.DecreeText:GetText(), "No nights posted this week.", "no Decree keeper → honest Gathering")
COB.Records, COB.Ranks, COB.Decree = savedRecords, savedRanks, savedDecree

reset()
savedDecree = COB.Decree
COB.Decree = nil
assert_eq(Card:Show(), true, "card shows without Decree")
assert_eq(Card.frame.DecreeText:GetText(), "No nights posted this week.", "missing Decree still paints empty Gathering")
assert_eq(Card.frame.GoraEmptyText:IsShown(), true, "missing Decree still keeps Gora compact")
assert_eq(Card.frame:GetHeight(), 444, "missing Decree empty card shrinks")
COB.Decree = savedDecree

--------------------------------------------------------------------------------
-- Posted nights are one row each, never a concatenated blob
--------------------------------------------------------------------------------
reset()
assert_eq(Card:Show(), true, "empty card shows")
COB.Nights:SetSeries({
  kind = "gathering",
  weekday = 5,
  timeLine = "7:00 PM",
  place = "Goldshire Inn",
})
local week = COB.Nights:Week()
assert_true(#week >= 1, "series lands on this week")
COB.Nights:SetStub({
  kind = "raid",
  title = "Kara Thursday",
  timeLine = "8:00 PM",
  place = "Karazhan",
  date = week[1].date,
})
assert_eq(Card:Show(), true, "card shows a posted week")
assert_eq(Card.frame.DecreeText:IsShown(), false, "week list hides the leftover blob")
local weekHost = COB.NightRows:Host(Card.frame.NightList)
assert_true(weekHost ~= nil, "week strip owns a NightRows host")
assert_eq(Card.frame.NightList:IsShown(), true, "week list is shown")
assert_eq(weekHost.rows[1]:IsShown(), true, "first night is its own row")
assert_eq(weekHost.rows[2]:IsShown(), true, "second night is its own row")
assert_eq(weekHost.rows[1].Kind:GetText() == weekHost.rows[2].Kind:GetText(), false,
  "two week nights are not one concatenated line")
assert_eq(weekHost.rows[1].KindRibbon._cobTextureName, "ribbon_bookmark",
  "week kind sits on a bookmark ribbon")
assert_eq(weekHost.metrics.twoLine, true, "week strip uses two-line rows")
assert_eq(Card.frame.GatheringLabel:IsShown(), false,
  "posted nights do not keep the leftover DECREE headline ribbon")
assert_eq(weekHost.rows[1].Going:IsShown() or weekHost.rows[2].Going:IsShown(), true,
  "Going sits on the Church row")
assert_eq(weekHost.rows[1].Date._cobFontPath, nil, "card night date is stock GameFont")
assert_eq(weekHost.rows[1].Kind._cobFontPath, nil, "card night kind is stock GameFont")
assert_eq(weekHost.rows[1].Where._cobFontPath, nil, "card night where is stock GameFont")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
Card:Show()
ChurchOfBeef._IN_TEST = false
assert_eq(Card:ResetForTests(), false, "ResetForTests refuses outside tests")
assert_eq(Card:IsShown(), true, "refused reset leaves the card")
ChurchOfBeef._IN_TEST = true
assert_eq(Card:ResetForTests(), true, "ResetForTests runs under _IN_TEST")
assert_eq(Card:IsShown(), false, "reset hides the card")

UnitClass, UnitLevel = savedUnitClass, savedUnitLevel
PlaySound, PlaySoundFile = savedPlaySound, savedPlaySoundFile
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
