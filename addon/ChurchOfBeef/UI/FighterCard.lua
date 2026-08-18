ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode mute fighter card (Bible §10.6, §10.7 persist). Tale of the
-- tape. The card shows; the Pope tells. Remember the last sanctioned pair
-- and stay painted after GetSanctioned() is nil while Runtime is not QUIET.
-- Congregation pair may arrive as Runtime subjects.fighters when Gora has
-- no live pair. Hide on QUIET / Hide() / EndEvent. ESC Hide()s the named
-- frame via UISpecialFrames (deduped). Init remounts rememberSpecial.
-- Hide remounts rememberSpecial when the frame already exists, then
-- remounts a missing OnHide. Show / Refresh remount rememberSpecial
-- when the frame already exists and keep wireCardOnHide. OnHide
-- syncs lastView.shown without forgetting lastPair. Init / Show /
-- Refresh / Hide remount a missing OnHide; never replace an
-- existing script. lastPair remains until QUIET.
-- A new Sanction replaces the remembered pair.
-- Dress (U-F): bull-horn header, blackletter names, serif ledger,
-- papal seal, iron+parchment frame — all via Theme. Roman numerals
-- on Record / Defenses / Head-to-head. No close furniture.
-- Honorifics are Pope text from Store human. Empty honorifics hide.
-- Defenses are a mute CountDefenses integer. Zero or a missing
-- method hides the line. No live health. No sound. No generated flavor.
local FighterCard = {
  MODE = "Event",
}
COB.FighterCard = FighterCard

local FRAME_NAME = "ChurchOfBeefFighterCard"
local FALLBACK_W, FALLBACK_H = 420, 220
-- U+2013; same join as Common.RomanPair. Common.RomanNumeral refuses 0,
-- so a fresh or one-sided record composes with theatrical nulla ("N").
local EN_DASH = "\226\128\147"
local ROMAN_ZERO = "N"

local frame = nil
local lastView = nil
local lastPair = nil
local hiding = false

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

local function hiddenView()
  return {
    shown = false,
    mode = "Event",
    fighterA = nil,
    fighterB = nil,
    headToHead = nil,
    stipulation = nil,
    health = nil,
  }
end

local function themeRGB(role)
  if not (COB.Theme and COB.Theme.Color) then return nil end
  local r, g, b = COB.Theme:Color(role)
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
    return nil
  end
  return r, g, b
end

local function roleColor(role)
  local r, g, b = themeRGB(role)
  if not r then return nil end
  return { r = r, g = g, b = b }
end

local function themeTexture(name)
  if not (COB.Theme and COB.Theme.Texture) then return nil end
  local path = COB.Theme:Texture(name)
  if type(path) ~= "string" or path == "" then return nil end
  return path
end

local function themeFont(role)
  if not (COB.Theme and COB.Theme.FontPath) then return nil end
  local path = COB.Theme:FontPath(role)
  if type(path) ~= "string" or path == "" then return nil end
  return path
end

local function themeFontSize(key, fallback)
  local sizes = COB.Theme and COB.Theme.FontSize
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
  return fallback
end

local function applyTexture(tex, path)
  if not tex or type(path) ~= "string" or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  if ok then
    tex._cobTexture = path
    return true
  end
  return false
end

local function applyThemeTexture(tex, name)
  local path = themeTexture(name)
  if not path then return false end
  return applyTexture(tex, path)
end

local function fill(tex, r, g, b, a)
  if not tex then return end
  a = a or 1
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, a)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, a)
  end
  tex._cobColor = { r = r, g = g, b = b, a = a }
end

local function fillRole(tex, role, a)
  local r, g, b = themeRGB(role)
  if not r then return end
  fill(tex, r, g, b, a or 1)
end

local function applyParchment(tex)
  if not tex then return end
  if applyThemeTexture(tex, "frame_proclamation_center") then return end
  fillRole(tex, "parchment")
end

local function tintTexRole(tex, role)
  if not tex then return end
  local r, g, b = themeRGB(role)
  if not r then return end
  if tex.SetVertexColor then tex:SetVertexColor(r, g, b, 1) end
  tex._cobColor = { r = r, g = g, b = b, a = 1 }
end

local function tintSeal(tex)
  if not tex then return end
  if not applyThemeTexture(tex, "seal_papal") then
    fillRole(tex, "gold")
    return
  end
  tintTexRole(tex, "gold")
end

local function tint(fs, color)
  if not fs or type(color) ~= "table" then return end
  local r, g, b = color.r, color.g, color.b
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then return end
  if fs.SetTextColor then fs:SetTextColor(r, g, b) end
  fs._cobColor = { r = r, g = g, b = b }
end

local function tintRole(fs, role)
  tint(fs, roleColor(role))
end

local function setShown(widget, shown)
  if not widget then return end
  if shown then
    if widget.Show then widget:Show() end
  else
    if widget.Hide then widget:Hide() end
  end
end

local function classFile(class)
  if type(class) ~= "string" then return nil end
  local file = class:gsub("%s+", ""):upper()
  if file == "" then return nil end
  return file
end

local function classColor(class)
  if not (COB.Theme and COB.Theme.ClassColor) then return nil end
  local file = classFile(class)
  if not file then return nil end
  local r, g, b = COB.Theme:ClassColor(file)
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
    return nil
  end
  return { r = r, g = g, b = b }
end

local function churchTitle(characterId)
  if not COB.Store or not COB.Store.RankForCharacter then return nil end
  local rankId = COB.Store:RankForCharacter(characterId)
  if rankId == nil then return nil end
  if not (COB.Ranks and COB.Ranks.Title) then return nil end
  local title = COB.Ranks.Title(rankId)
  if type(title) ~= "string" or title == "" or title == "Unknown" then return nil end
  return title
end

local function honorificFrom(ch)
  if type(ch) ~= "table" or ch.humanId == nil then return nil end
  if not (COB.Store and COB.Store.GetHuman) then return nil end
  local human = COB.Store:GetHuman(ch.humanId)
  if type(human) ~= "table" or type(human.honorifics) ~= "table" then return nil end
  local first = human.honorifics[1]
  if type(first) ~= "string" or first == "" then return nil end
  return first
end

local function defensesFrom(id)
  if not (COB.Store and type(COB.Store.CountDefenses) == "function") then
    return nil
  end
  local n = COB.Store:CountDefenses(id)
  if type(n) ~= "number" or n < 1 then return nil end
  return n
end

local function eventLive()
  if not COB.Runtime or not COB.Runtime.Snapshot then return false end
  local snap = COB.Runtime:Snapshot()
  return type(snap) == "table" and snap.state ~= "QUIET"
end

local function livePair()
  if not COB.Gora or not COB.Gora.GetSanctioned then return nil end
  local pair = COB.Gora:GetSanctioned()
  if type(pair) ~= "table" then return nil end
  if pair.fighterA == nil or pair.fighterB == nil then return nil end
  return pair
end

local function subjectsPair()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" or type(snap.subjects) ~= "table" then return nil end
  local fighters = snap.subjects.fighters
  if type(fighters) ~= "table" then return nil end
  if fighters[1] == nil or fighters[2] == nil then return nil end
  return { fighterA = fighters[1], fighterB = fighters[2] }
end

local function rememberPair(pair)
  lastPair = {
    fighterA = pair.fighterA,
    fighterB = pair.fighterB,
    stipulation = pair.stipulation,
  }
end

local function displayPair()
  local live = livePair()
  if live then
    rememberPair(live)
    return live
  end
  local subjects = subjectsPair()
  if subjects then
    rememberPair(subjects)
    return subjects
  end
  if lastPair then
    return lastPair
  end
  return nil
end

local function forgetPersist()
  lastPair = nil
end

local function headToHeadFor(character, opponentId)
  if type(character) ~= "table" or type(character.gora) ~= "table" then return nil end
  local list = character.gora.headToHeads
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and row.opponentId == opponentId then
      local fights = row.fights
      if type(fights) == "number" and fights > 0 then
        return {
          wins = row.wins or 0,
          losses = row.losses or 0,
          fights = fights,
        }
      end
    end
  end
  return nil
end

local function fighterFrom(id)
  local ch = COB.Store and COB.Store.GetCharacter and COB.Store:GetCharacter(id) or nil
  if type(ch) ~= "table" then
    return {
      id = id,
      name = "",
      level = nil,
      title = nil,
      honorific = nil,
      defenses = nil,
      wins = 0,
      losses = 0,
      nameColor = nil,
    }
  end
  local gora = type(ch.gora) == "table" and ch.gora or {}
  return {
    id = id,
    name = ch.name,
    class = ch.class,
    level = ch.level,
    title = churchTitle(id),
    honorific = honorificFrom(ch),
    defenses = defensesFrom(id),
    wins = gora.wins or 0,
    losses = gora.losses or 0,
    nameColor = classColor(ch.class),
  }
end

-- Theatrical zero: Common.RomanNumeral is 1–3999. Report the Common gap.
local function romanGlyph(n)
  if type(n) ~= "number" then return nil end
  n = math.floor(n)
  if n == 0 then return ROMAN_ZERO end
  if not (COB.Common and COB.Common.RomanNumeral) then return nil end
  local glyph = COB.Common.RomanNumeral(n)
  if type(glyph) == "string" then return glyph end
  return nil
end

local function recordText(fighter)
  local wins = fighter.wins or 0
  local losses = fighter.losses or 0
  if COB.Common and COB.Common.RomanPair then
    local pair = COB.Common.RomanPair(wins, losses)
    if type(pair) == "string" then return pair end
  end
  local left = romanGlyph(wins)
  local right = romanGlyph(losses)
  if not left or not right then return "" end
  return left .. EN_DASH .. right
end

local function defensesText(count)
  if type(count) ~= "number" or count < 1 then return nil end
  if COB.Common and COB.Common.RomanNumeral then
    local glyph = COB.Common.RomanNumeral(count)
    if type(glyph) == "string" then return glyph end
  end
  return nil
end

local function levelText(fighter)
  if type(fighter.level) ~= "number" then return "" end
  return tostring(fighter.level)
end

local function popeLine(pair)
  if type(pair) ~= "table" then return nil end
  local line = pair.stipulation
  if type(line) ~= "string" or line == "" then return nil end
  return line
end

local function paintHonorific(fs, text)
  if type(text) == "string" and text ~= "" then
    fs:SetText(text)
    if fs.Show then fs:Show() end
  else
    fs:SetText("")
    if fs.Hide then fs:Hide() end
  end
  tintRole(fs, "silver")
end

local function paintDefenses(plate, count)
  local text = defensesText(count)
  if text then
    plate.defenses:SetText(text)
    setShown(plate.defenses, true)
    setShown(plate.defensesLabel, true)
    setShown(plate.defensesGlyph, true)
  else
    plate.defenses:SetText("")
    setShown(plate.defenses, false)
    setShown(plate.defensesLabel, false)
    setShown(plate.defensesGlyph, false)
  end
  tintRole(plate.defenses, "parchment")
  local relative = text and plate.defenses or plate.record
  if plate.honorific and plate.honorific.ClearAllPoints then
    plate.honorific:ClearAllPoints()
  end
  if plate._justify == "RIGHT" then
    plate.honorific:SetPoint("TOPRIGHT", relative, "BOTTOMRIGHT", 0, -4)
  else
    plate.honorific:SetPoint("TOPLEFT", relative, "BOTTOMLEFT", 0, -4)
  end
end

local function paintFighter(plate, fighter)
  plate.name:SetText(fighter.name or "")
  plate.level:SetText(levelText(fighter))
  plate.title:SetText(fighter.title or "")
  plate.record:SetText(recordText(fighter))
  paintDefenses(plate, fighter.defenses)
  paintHonorific(plate.honorific, fighter.honorific)
  tint(plate.name, fighter.nameColor or roleColor("parchment"))
  tintRole(plate.level, "silver")
  tintRole(plate.title, "parchment")
  tintRole(plate.record, "parchment")
  tintRole(plate.recordLabel, "gold")
end

local function paintHidden()
  lastView = hiddenView()
  if not frame then return lastView end
  if hiding then return lastView end
  hiding = true
  frame.plateA.name:SetText("")
  frame.plateB.name:SetText("")
  frame.plateA.level:SetText("")
  frame.plateB.level:SetText("")
  frame.plateA.title:SetText("")
  frame.plateB.title:SetText("")
  frame.plateA.record:SetText("")
  frame.plateB.record:SetText("")
  frame.plateA.honorific:SetText("")
  frame.plateB.honorific:SetText("")
  setShown(frame.plateA.honorific, false)
  setShown(frame.plateB.honorific, false)
  frame.plateA.defenses:SetText("")
  frame.plateB.defenses:SetText("")
  setShown(frame.plateA.defenses, false)
  setShown(frame.plateB.defenses, false)
  setShown(frame.plateA.defensesLabel, false)
  setShown(frame.plateB.defensesLabel, false)
  setShown(frame.plateA.defensesGlyph, false)
  setShown(frame.plateB.defensesGlyph, false)
  frame.headToHead:SetText("")
  setShown(frame.headToHead, false)
  setShown(frame.headToHeadLabel, false)
  setShown(frame.headToHeadGlyph, false)
  frame.stipulation:SetText("")
  setShown(frame.stipulation, false)
  setShown(frame.stipulationLabel, false)
  setShown(frame.stipulationGlyph, false)
  frame:Hide()
  hiding = false
  return lastView
end

local function paintLedgerPair(value, label, glyph, text)
  if text then
    value:SetText(text)
    setShown(value, true)
    setShown(label, true)
    setShown(glyph, true)
  else
    value:SetText("")
    setShown(value, false)
    setShown(label, false)
    setShown(glyph, false)
  end
end

local function paintShown(pair)
  local fighterA = fighterFrom(pair.fighterA)
  local fighterB = fighterFrom(pair.fighterB)
  local h2h = nil
  if COB.Store and COB.Store.GetCharacter then
    local chA = COB.Store:GetCharacter(pair.fighterA)
    h2h = headToHeadFor(chA, pair.fighterB)
  end
  local stipulation = popeLine(pair)

  paintFighter(frame.plateA, fighterA)
  paintFighter(frame.plateB, fighterB)
  local h2hText = h2h and recordText(h2h) or nil
  paintLedgerPair(frame.headToHead, frame.headToHeadLabel, frame.headToHeadGlyph, h2hText)
  if h2hText then tintRole(frame.headToHead, "parchment") end
  paintLedgerPair(frame.stipulation, frame.stipulationLabel, frame.stipulationGlyph, stipulation)
  if stipulation then tintRole(frame.stipulation, "parchment") end

  lastView = {
    shown = true,
    mode = "Event",
    fighterA = fighterA,
    fighterB = fighterB,
    headToHead = h2h,
    stipulation = stipulation,
    health = nil,
  }
  frame:Show()
  return lastView
end

local function cardWidth()
  local parent = UIParent
  local w = parent and parent.GetWidth and parent:GetWidth()
  if type(w) == "number" and w > 0 then
    return math.floor(w / 3)
  end
  return FALLBACK_W
end

local function cardHeight()
  local parent = UIParent
  local h = parent and parent.GetHeight and parent:GetHeight()
  if type(h) == "number" and h > 0 then
    local third = math.floor(h / 3)
    if third < FALLBACK_H then return third end
    return FALLBACK_H
  end
  return FALLBACK_H
end

local function makeLabel(parent, template, justify)
  local fs = parent:CreateFontString(nil, "OVERLAY", template or "GameFontNormal")
  if fs.SetJustifyH and justify then fs:SetJustifyH(justify) end
  return fs
end

local function applyFont(fs, role, sizeKey)
  if not fs then return end
  local path = themeFont(role)
  local px = themeFontSize(sizeKey, 12)
  if role == "display" and px < 16 then px = 16 end
  local used = false
  if type(path) == "string" and fs.SetFont then
    local ok, applied = pcall(fs.SetFont, fs, path, px, "")
    used = ok and applied and true or false
    fs._cobFont = path
    fs._cobFontSize = px
    fs._cobFontRole = role
  end
  if not used and fs.SetFontObject then
    local font = (role == "display") and GameFontHighlight or GameFontNormal
    if type(font) == "string" then font = _G[font] end
    if font then pcall(fs.SetFontObject, fs, font) end
  end
end

local function makeGlyph(parent, name)
  local tex = parent:CreateTexture(nil, "ARTWORK")
  tex:SetSize(14, 14)
  applyThemeTexture(tex, name)
  tintTexRole(tex, "gold")
  return tex
end

local function buildPlate(parent, justify)
  local plate = CreateFrame("Frame", nil, parent)
  plate._justify = justify
  plate.name = makeLabel(plate, "GameFontHighlight", justify)
  applyFont(plate.name, "display", "name")
  plate.title = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.title, "label", "label")
  plate.level = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.level, "body", "caption")
  plate.recordGlyph = makeGlyph(plate, "glyph_record")
  plate.recordLabel = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.recordLabel, "label", "label")
  plate.recordLabel:SetText("Record")
  tintRole(plate.recordLabel, "gold")
  plate.record = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.record, "body", "body")
  plate.defensesGlyph = makeGlyph(plate, "glyph_defenses")
  plate.defensesLabel = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.defensesLabel, "label", "label")
  plate.defensesLabel:SetText("Defenses")
  tintRole(plate.defensesLabel, "gold")
  plate.defenses = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.defenses, "body", "body")
  setShown(plate.defenses, false)
  setShown(plate.defensesLabel, false)
  setShown(plate.defensesGlyph, false)
  plate.honorific = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.honorific, "body", "body")
  setShown(plate.honorific, false)
  return plate
end

-- ESC Hide via UISpecialFrames bypasses FighterCard:Hide. Restore a
-- missing OnHide; never replace an existing script. Sync lastView
-- without forgetting lastPair.
local function wireCardOnHide(widget)
  if not widget then return end
  if type(widget.SetScript) ~= "function" then return end
  local existing = type(widget.GetScript) == "function" and widget:GetScript("OnHide")
  if existing then return end
  widget:SetScript("OnHide", function()
    lastView = hiddenView()
    if hiding then return end
    paintHidden()
  end)
end

local function build()
  local parent = UIParent
  local width, height = cardWidth(), cardHeight()
  local widget = CreateFrame("Frame", FRAME_NAME, parent, "BackdropTemplate")
  widget:SetSize(width, height)
  widget:SetClampedToScreen(true)
  if widget.EnableMouse then widget:EnableMouse(false) end
  if widget.SetFrameStrata then widget:SetFrameStrata("DIALOG") end
  widget:SetPoint("LEFT", parent, "LEFT", 0, 0)
  local framePath = themeTexture("frame_fightercard")
  local edgePath = themeTexture("frame_proclamation_edge_top")
  if widget.SetBackdrop and framePath then
    widget:SetBackdrop({
      bgFile = framePath,
      edgeFile = edgePath,
      tile = true,
      tileSize = 8,
      edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    local cr, cg, cb = themeRGB("charcoal")
    if cr and widget.SetBackdropColor then
      widget:SetBackdropColor(cr, cg, cb, 1)
    end
    local gr, gg, gb = themeRGB("gold")
    if gr and widget.SetBackdropBorderColor then
      widget:SetBackdropBorderColor(gr, gg, gb, 1)
    end
  end

  widget.iron = widget:CreateTexture(nil, "BACKGROUND")
  if widget.iron.SetAllPoints then widget.iron:SetAllPoints(widget) end
  if not applyThemeTexture(widget.iron, "frame_fightercard") then
    fillRole(widget.iron, "charcoal")
  else
    tintTexRole(widget.iron, "iron")
  end

  widget.parchment = widget:CreateTexture(nil, "BACKGROUND")
  if widget.parchment.ClearAllPoints then widget.parchment:ClearAllPoints() end
  widget.parchment:SetPoint("TOPLEFT", widget, "TOPLEFT", 5, -5)
  widget.parchment:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -5, 5)
  applyParchment(widget.parchment)

  widget.bullhorn = widget:CreateTexture(nil, "ARTWORK")
  widget.bullhorn:SetSize(48, 24)
  widget.bullhorn:SetPoint("TOP", widget, "TOP", 0, -2)
  applyThemeTexture(widget.bullhorn, "ornament_bullhorn")
  tintTexRole(widget.bullhorn, "gold")

  widget.goldRule = widget:CreateTexture(nil, "ARTWORK")
  widget.goldRule:SetPoint("TOPLEFT", widget, "TOPLEFT", 8, -28)
  widget.goldRule:SetPoint("TOPRIGHT", widget, "TOPRIGHT", -8, -28)
  if widget.goldRule.SetHeight then widget.goldRule:SetHeight(1) end
  fillRole(widget.goldRule, "gold")

  widget.seal = widget:CreateTexture(nil, "ARTWORK")
  widget.seal:SetSize(28, 28)
  widget.seal:SetPoint("BOTTOM", widget, "BOTTOM", 0, 4)
  tintSeal(widget.seal)

  local plateW = math.floor((width - 56) / 2)
  local plateH = height - 88
  widget.plateA = buildPlate(widget, "LEFT")
  widget.plateB = buildPlate(widget, "RIGHT")
  widget.plateA:SetSize(plateW, plateH)
  widget.plateB:SetSize(plateW, plateH)
  widget.plateA:SetPoint("LEFT", widget, "LEFT", 12, 8)
  widget.plateB:SetPoint("RIGHT", widget, "RIGHT", -12, 8)

  widget.plateA.name:SetPoint("TOPLEFT", widget.plateA, "TOPLEFT", 8, -4)
  widget.plateB.name:SetPoint("TOPRIGHT", widget.plateB, "TOPRIGHT", -8, -4)
  widget.plateA.title:SetPoint("TOPLEFT", widget.plateA.name, "BOTTOMLEFT", 0, -2)
  widget.plateB.title:SetPoint("TOPRIGHT", widget.plateB.name, "BOTTOMRIGHT", 0, -2)
  widget.plateA.level:SetPoint("TOPLEFT", widget.plateA.title, "BOTTOMLEFT", 0, -2)
  widget.plateB.level:SetPoint("TOPRIGHT", widget.plateB.title, "BOTTOMRIGHT", 0, -2)

  widget.plateA.recordGlyph:SetPoint("TOPLEFT", widget.plateA.level, "BOTTOMLEFT", 0, -6)
  widget.plateA.recordLabel:SetPoint("LEFT", widget.plateA.recordGlyph, "RIGHT", 4, 0)
  widget.plateA.record:SetPoint("LEFT", widget.plateA.recordLabel, "RIGHT", 6, 0)
  widget.plateB.recordGlyph:SetPoint("TOPRIGHT", widget.plateB.level, "BOTTOMRIGHT", 0, -6)
  widget.plateB.recordLabel:SetPoint("RIGHT", widget.plateB.recordGlyph, "LEFT", -4, 0)
  widget.plateB.record:SetPoint("RIGHT", widget.plateB.recordLabel, "LEFT", -6, 0)

  widget.plateA.defensesGlyph:SetPoint("TOPLEFT", widget.plateA.record, "BOTTOMLEFT", 0, -4)
  widget.plateA.defensesLabel:SetPoint("LEFT", widget.plateA.defensesGlyph, "RIGHT", 4, 0)
  widget.plateA.defenses:SetPoint("LEFT", widget.plateA.defensesLabel, "RIGHT", 6, 0)
  widget.plateB.defensesGlyph:SetPoint("TOPRIGHT", widget.plateB.record, "BOTTOMRIGHT", 0, -4)
  widget.plateB.defensesLabel:SetPoint("RIGHT", widget.plateB.defensesGlyph, "LEFT", -4, 0)
  widget.plateB.defenses:SetPoint("RIGHT", widget.plateB.defensesLabel, "LEFT", -6, 0)

  widget.plateA.honorific:SetPoint("TOPLEFT", widget.plateA.record, "BOTTOMLEFT", 0, -4)
  widget.plateB.honorific:SetPoint("TOPRIGHT", widget.plateB.record, "BOTTOMRIGHT", 0, -4)

  widget.vs = makeLabel(widget, "GameFontNormal", "CENTER")
  applyFont(widget.vs, "label", "label")
  widget.vs:SetPoint("CENTER", widget, "CENTER", 0, 16)
  widget.vs:SetText("VS")
  tintRole(widget.vs, "silver")

  widget.headToHeadGlyph = makeGlyph(widget, "glyph_headtohead")
  widget.headToHeadLabel = makeLabel(widget, "GameFontNormal", "CENTER")
  applyFont(widget.headToHeadLabel, "label", "label")
  widget.headToHeadLabel:SetText("Head-to-head")
  tintRole(widget.headToHeadLabel, "gold")
  widget.headToHead = makeLabel(widget, "GameFontNormal", "CENTER")
  applyFont(widget.headToHead, "body", "body")
  widget.headToHeadLabel:SetPoint("BOTTOM", widget, "BOTTOM", 0, 56)
  widget.headToHeadGlyph:SetPoint("RIGHT", widget.headToHeadLabel, "LEFT", -4, 0)
  widget.headToHead:SetPoint("LEFT", widget.headToHeadLabel, "RIGHT", 6, 0)
  setShown(widget.headToHead, false)
  setShown(widget.headToHeadLabel, false)
  setShown(widget.headToHeadGlyph, false)

  widget.stipulationGlyph = makeGlyph(widget, "glyph_stipulation")
  widget.stipulationLabel = makeLabel(widget, "GameFontNormal", "CENTER")
  applyFont(widget.stipulationLabel, "label", "label")
  widget.stipulationLabel:SetText("Stipulation")
  tintRole(widget.stipulationLabel, "gold")
  widget.stipulation = makeLabel(widget, "GameFontNormal", "CENTER")
  applyFont(widget.stipulation, "body", "body")
  widget.stipulationLabel:SetPoint("BOTTOM", widget, "BOTTOM", 0, 36)
  widget.stipulationGlyph:SetPoint("RIGHT", widget.stipulationLabel, "LEFT", -4, 0)
  widget.stipulation:SetPoint("LEFT", widget.stipulationLabel, "RIGHT", 6, 0)
  setShown(widget.stipulation, false)
  setShown(widget.stipulationLabel, false)
  setShown(widget.stipulationGlyph, false)

  widget:Hide()
  wireCardOnHide(widget)
  return widget
end

function FighterCard:Init()
  if not frame then
    frame = build()
  end
  wireCardOnHide(frame)
  rememberSpecial(FRAME_NAME)
  self:Refresh()
  return frame
end

function FighterCard:GetView()
  if lastView == nil then lastView = hiddenView() end
  return deepcopy(lastView)
end

function FighterCard:Refresh()
  if not frame then
    self:Init()
    return self:GetView()
  end
  rememberSpecial(FRAME_NAME)
  wireCardOnHide(frame)
  if not eventLive() then
    forgetPersist()
    paintHidden()
    return self:GetView()
  end
  local pair = displayPair()
  if not pair then
    paintHidden()
    return self:GetView()
  end
  paintShown(pair)
  return self:GetView()
end

function FighterCard:Show()
  if not frame then
    self:Init()
  end
  rememberSpecial(FRAME_NAME)
  wireCardOnHide(frame)
  if not eventLive() then
    forgetPersist()
    paintHidden()
    return false
  end
  local pair = displayPair()
  if not pair then
    paintHidden()
    return false
  end
  paintShown(pair)
  return true
end

function FighterCard:Hide()
  if frame then
    rememberSpecial(FRAME_NAME)
    wireCardOnHide(frame)
  end
  paintHidden()
end

function FighterCard:ResetForTests()
  if not COB._IN_TEST then return false end
  forgetPersist()
  lastView = hiddenView()
  if frame then
    paintHidden()
  end
  return true
end
