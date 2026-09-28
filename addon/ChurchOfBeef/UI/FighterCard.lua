ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode mute fighter card (Bible §10.6, §10.7 persist). Tale of the
-- tape. The card shows; the Pope tells. Remember the last sanctioned pair
-- and stay painted after GetSanctioned() is nil while Runtime is not QUIET.
-- Congregation pair may arrive as Runtime subjects.fighters when Gora has
-- no live pair. The card is a sanction beat: the wire glue hides it when a
-- Gora verdict is recorded, on inbound CONSEQUENCE, on QUIET, and on
-- EndEvent. ESC Hide()s the named frame via UISpecialFrames (deduped).
-- Init remounts rememberSpecial.
-- Hide remounts rememberSpecial when the frame already exists, then
-- remounts a missing OnHide. Show / Refresh remount rememberSpecial
-- when the frame already exists and keep wireCardOnHide. OnHide
-- syncs lastView.shown without forgetting lastPair. Init / Show /
-- Refresh / Hide remount a missing OnHide; never replace an
-- existing script. lastPair remains until QUIET.
-- A new Sanction replaces the remembered pair.
-- Dress: stacked A-over-B tape (R3 is one fighter; both sit in one
-- left-third card). Dark name bands with class-tinted blackletter,
-- serif ledger in charcoal on parchment, papal seal, iron+parchment
-- frame — all via Theme. Arabic W/L on Record / Head-to-head;
-- Arabic on Defenses. No bag-slot chrome. No close furniture.
-- Honorifics are Pope text from Store human. Empty honorifics hide.
-- Long honorifics wrap inside the plate and stay above the footer.
-- Defenses are a mute CountDefenses integer. Zero or a missing
-- method hides the line. No live health. No sound. No generated flavor.
-- Type: Theme.FontSize (name ≥ 16, headline 22, label/body/caption 12).
-- Rhythm: Theme.Space — no leftover 6/10/14.
local FighterCard = {
  MODE = "Event",
}
COB.FighterCard = FighterCard

local FRAME_NAME = "ChurchOfBeefFighterCard"
local FALLBACK_W, FALLBACK_H = 420, 360
local TAPE_MIN_H = 280
-- U+2013 W–L join. Record sides are Arabic, including 0.
local EN_DASH = "\226\128\147"
local SURFACE_U0, SURFACE_U1 = 0.12, 0.88

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

local function themeFontSize(key, floor)
  local sizes = COB.Theme and COB.Theme.FontSize
  local n = type(sizes) == "table" and sizes[key] or nil
  if type(n) == "number" then
    if type(floor) == "number" and n < floor then return floor end
    return n
  end
  if type(floor) == "number" then return floor end
  return 12
end

local function space(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
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

local function isBagSlotPath(path)
  if type(path) ~= "string" then return false end
  if path:find("EmptySlot", 1, true) then return true end
  if path:find("Quickslot", 1, true) then return true end
  return false
end

local function applyThemeTexture(tex, name)
  local path = themeTexture(name)
  if not path or isBagSlotPath(path) then return false end
  return applyTexture(tex, path)
end

local function cropSurface(tex)
  if tex and tex.SetTexCoord then
    pcall(tex.SetTexCoord, tex, SURFACE_U0, SURFACE_U1, SURFACE_U0, SURFACE_U1)
  end
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
  if applyThemeTexture(tex, "frame_proclamation_center") then
    cropSurface(tex)
    return
  end
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

local function stashedName(id)
  local stash = COB._lastCastNames
  if type(stash) ~= "table" then return nil end
  if type(stash.byId) == "table" and type(stash.byId[id]) == "string" then
    return stash.byId[id]
  end
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  local subjects = type(snap) == "table" and snap.subjects or nil
  if type(subjects) ~= "table" then return nil end
  if subjects.candidate == id and type(stash.candidate) == "string" then
    return stash.candidate
  end
  if type(subjects.fighters) == "table" then
    if subjects.fighters[1] == id and type(stash.fighterA) == "string" then
      return stash.fighterA
    end
    if subjects.fighters[2] == id and type(stash.fighterB) == "string" then
      return stash.fighterB
    end
  end
  return nil
end

local function fighterFrom(id)
  local ch = COB.Store and COB.Store.GetCharacter and COB.Store:GetCharacter(id) or nil
  if type(ch) ~= "table" then
    return {
      id = id,
      name = stashedName(id) or "",
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

local function arabicCount(n)
  local whole = 0
  if type(n) == "number" then whole = math.floor(n) end
  if whole < 0 then whole = 0 end
  return tostring(whole)
end

local function recordText(fighter)
  return arabicCount(fighter.wins or 0) .. EN_DASH .. arabicCount(fighter.losses or 0)
end

local function defensesText(count)
  if type(count) ~= "number" or count < 1 then return nil end
  return arabicCount(count)
end

local function levelText(fighter)
  if type(fighter.level) ~= "number" then return "" end
  return tostring(fighter.level)
end

local function honorificWidth(plate)
  local sm = space("sm", 8)
  local w = plate and plate.GetWidth and plate:GetWidth()
  if type(w) == "number" and w > sm * 2 then
    return w - sm * 2
  end
  w = FALLBACK_W - sm * 4
  local band = space("band", 48)
  if w < band then w = band end
  return w
end

-- Honorifics wrap inside the plate. Plate A reserves the VS line;
-- plate B stays above the shared H2H footer.
local function layoutHonorific(plate, relative)
  if not plate or not plate.honorific then return end
  local fs = plate.honorific
  local sm = space("sm", 8)
  local gap = space("xs", 4)
  local reserve = plate._honorificReserve
  if type(reserve) ~= "number" then reserve = 0 end
  local anchor = relative or plate.record
  if fs.ClearAllPoints then fs:ClearAllPoints() end
  if anchor then
    fs:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gap)
  else
    fs:SetPoint("TOPLEFT", plate, "TOPLEFT", sm, -gap)
  end
  fs:SetPoint("RIGHT", plate, "RIGHT", -sm, 0)
  fs:SetPoint("BOTTOM", plate, "BOTTOM", 0, reserve)
  if fs.SetWidth then fs:SetWidth(honorificWidth(plate)) end
  if fs.SetJustifyV then fs:SetJustifyV("TOP") end
  if fs.SetWordWrap then fs:SetWordWrap(true) end
  if fs.SetMaxLines then fs:SetMaxLines(2) end
end

local function paintHonorific(fs, text)
  if type(text) == "string" and text ~= "" then
    fs:SetText(text)
    if fs.Show then fs:Show() end
  else
    fs:SetText("")
    if fs.Hide then fs:Hide() end
  end
  tintRole(fs, "charcoal")
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
  tintRole(plate.defenses, "charcoal")
  local relative = text and plate.defenses or plate.record
  layoutHonorific(plate, relative)
end

local function paintFighter(plate, fighter)
  plate.name:SetText(fighter.name or "")
  plate.level:SetText(levelText(fighter))
  plate.title:SetText(fighter.title or "")
  plate.record:SetText(recordText(fighter))
  paintDefenses(plate, fighter.defenses)
  paintHonorific(plate.honorific, fighter.honorific)
  tint(plate.name, fighter.nameColor or roleColor("parchment"))
  tintRole(plate.level, "charcoal")
  tintRole(plate.title, "charcoal")
  tintRole(plate.record, "charcoal")
  tintRole(plate.recordLabel, "charcoal")
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
  paintFighter(frame.plateA, fighterA)
  paintFighter(frame.plateB, fighterB)
  local h2hText = h2h and recordText(h2h) or nil
  paintLedgerPair(frame.headToHead, frame.headToHeadLabel, frame.headToHeadGlyph, h2hText)
  if h2hText then tintRole(frame.headToHead, "charcoal") end

  lastView = {
    shown = true,
    mode = "Event",
    fighterA = fighterA,
    fighterB = fighterB,
    headToHead = h2h,
    stipulation = nil,
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
    local budget = math.floor(h * 0.48 + 0.5)
    if budget < TAPE_MIN_H then return TAPE_MIN_H end
    if budget > FALLBACK_H then return FALLBACK_H end
    return budget
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
  local floor = 12
  if role == "display" then floor = 16 end
  local px = themeFontSize(sizeKey, floor)
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
  local g = space("glyph", 14)
  tex:SetSize(g, g)
  applyThemeTexture(tex, name)
  tintTexRole(tex, "gold")
  return tex
end

local function layoutHeader(plate)
  if not plate or not plate.header then return end
  if plate.header.ClearAllPoints then plate.header:ClearAllPoints() end
  plate.header:SetPoint("TOPLEFT", plate, "TOPLEFT", 0, 0)
  plate.header:SetPoint("TOPRIGHT", plate, "TOPRIGHT", 0, 0)
  if plate.header.SetHeight then plate.header:SetHeight(space("lg", 24) + space("sm", 8)) end
  fillRole(plate.header, "charcoal")
  if plate.headerEdge then
    if plate.headerEdge.ClearAllPoints then plate.headerEdge:ClearAllPoints() end
    plate.headerEdge:SetPoint("BOTTOMLEFT", plate.header, "BOTTOMLEFT", 0, 0)
    plate.headerEdge:SetPoint("BOTTOMRIGHT", plate.header, "BOTTOMRIGHT", 0, 0)
    if plate.headerEdge.SetHeight then plate.headerEdge:SetHeight(space("rule", 2)) end
    fillRole(plate.headerEdge, "gold")
  end
end

local function buildPlate(parent, justify)
  local plate = CreateFrame("Frame", nil, parent)
  plate._justify = justify
  plate.header = plate:CreateTexture(nil, "ARTWORK")
  plate.headerEdge = plate:CreateTexture(nil, "OVERLAY")
  fillRole(plate.header, "charcoal")
  fillRole(plate.headerEdge, "gold")
  plate.name = makeLabel(plate, "GameFontHighlight", justify)
  applyFont(plate.name, "display", "name")
  if plate.name.SetWordWrap then plate.name:SetWordWrap(false) end
  if plate.name.SetMaxLines then plate.name:SetMaxLines(1) end
  if plate.name.SetJustifyV then plate.name:SetJustifyV("MIDDLE") end
  plate.title = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.title, "label", "label")
  if plate.title.SetWordWrap then plate.title:SetWordWrap(false) end
  if plate.title.SetMaxLines then plate.title:SetMaxLines(1) end
  if plate.title.SetHeight then plate.title:SetHeight(themeFontSize("label")) end
  plate.level = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.level, "body", "caption")
  plate.recordGlyph = makeGlyph(plate, "glyph_record")
  plate.recordLabel = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.recordLabel, "label", "label")
  plate.recordLabel:SetText("Record")
  tintRole(plate.recordLabel, "charcoal")
  plate.record = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.record, "body", "body")
  plate.defensesGlyph = makeGlyph(plate, "glyph_defenses")
  plate.defensesLabel = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.defensesLabel, "label", "label")
  plate.defensesLabel:SetText("Defenses")
  tintRole(plate.defensesLabel, "charcoal")
  plate.defenses = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.defenses, "body", "body")
  setShown(plate.defenses, false)
  setShown(plate.defensesLabel, false)
  setShown(plate.defensesGlyph, false)
  plate.honorific = makeLabel(plate, "GameFontNormal", justify)
  applyFont(plate.honorific, "body", "body")
  if plate.honorific.SetJustifyV then plate.honorific:SetJustifyV("TOP") end
  if plate.honorific.SetWordWrap then plate.honorific:SetWordWrap(true) end
  if plate.honorific.SetMaxLines then plate.honorific:SetMaxLines(2) end
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
  local widget = CreateFrame("Frame", FRAME_NAME, parent)
  widget:SetSize(width, height)
  widget:SetClampedToScreen(true)
  if widget.EnableMouse then widget:EnableMouse(false) end
  if widget.SetFrameStrata then widget:SetFrameStrata("DIALOG") end
  widget:SetPoint("LEFT", parent, "LEFT", 0, 0)
  local sm = space("sm", 8)
  local md = space("md", 16)
  local xs = space("xs", 4)
  local rule = space("rule", 2)
  local sealPx = space("seal", 28)

  widget.iron = widget:CreateTexture(nil, "BACKGROUND")
  if widget.iron.SetAllPoints then widget.iron:SetAllPoints(widget) end
  if not applyThemeTexture(widget.iron, "frame_fightercard") then
    fillRole(widget.iron, "charcoal")
  else
    cropSurface(widget.iron)
    tintTexRole(widget.iron, "iron")
  end

  widget.parchment = widget:CreateTexture(nil, "BACKGROUND")
  if widget.parchment.ClearAllPoints then widget.parchment:ClearAllPoints() end
  widget.parchment:SetPoint("TOPLEFT", widget, "TOPLEFT", sm, -sm)
  widget.parchment:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -sm, sm)
  applyParchment(widget.parchment)

  widget.bullhorn = widget:CreateTexture(nil, "ARTWORK")
  widget.bullhorn:SetSize(space("xl", 32) * 3, space("lg", 24))
  widget.bullhorn:SetPoint("TOP", widget, "TOP", 0, -xs)
  if not applyThemeTexture(widget.bullhorn, "ornament_bullhorn") then
    fillRole(widget.bullhorn, "gold")
  else
    tintTexRole(widget.bullhorn, "gold")
  end

  widget.goldRule = widget:CreateTexture(nil, "ARTWORK")
  widget.goldRule:SetPoint("TOPLEFT", widget, "TOPLEFT", md, -(space("lg", 24) + sm))
  widget.goldRule:SetPoint("TOPRIGHT", widget, "TOPRIGHT", -md, -(space("lg", 24) + sm))
  if widget.goldRule.SetHeight then widget.goldRule:SetHeight(rule) end
  fillRole(widget.goldRule, "gold")

  widget.seal = widget:CreateTexture(nil, "ARTWORK")
  widget.seal:SetSize(sealPx, sealPx)
  widget.seal:SetPoint("BOTTOMRIGHT", widget.parchment, "BOTTOMRIGHT", -sm, sm)
  tintSeal(widget.seal)

  -- Stacked tale-of-the-tape (R3 is one fighter; both sit in one left-third
  -- ledger). Shared H2H sits in the footer above the seal.
  local plateMin = space("band", 48) + space("lg", 24)
  local plateH = math.floor((height - space("band", 48) - space("footer", 40) - sm) / 2)
  if plateH < plateMin then plateH = plateMin end
  local plateW = width - sm * 4
  widget.plateA = buildPlate(widget, "LEFT")
  widget.plateB = buildPlate(widget, "LEFT")
  widget.plateA:SetWidth(plateW)
  widget.plateB:SetWidth(plateW)
  widget.plateA:SetHeight(plateH)
  widget.plateB:SetHeight(plateH)
  widget.plateA:SetPoint("TOPLEFT", widget.parchment, "TOPLEFT", sm, -(space("lg", 24) + xs))
  widget.plateA:SetPoint("TOPRIGHT", widget.parchment, "TOPRIGHT", -sm, -(space("lg", 24) + xs))
  widget.plateB:SetPoint("TOPLEFT", widget.plateA, "BOTTOMLEFT", 0, -xs)
  widget.plateB:SetPoint("TOPRIGHT", widget.plateA, "BOTTOMRIGHT", 0, -xs)
  layoutHeader(widget.plateA)
  layoutHeader(widget.plateB)
  widget.plateA._honorificReserve = space("lg", 24)
  widget.plateB._honorificReserve = space("xs", 4)

  widget.plateA.name:SetPoint("TOPLEFT", widget.plateA.header, "TOPLEFT", sm, 0)
  widget.plateA.name:SetPoint("BOTTOMRIGHT", widget.plateA.header, "BOTTOMRIGHT", -sm, 0)
  widget.plateB.name:SetPoint("TOPLEFT", widget.plateB.header, "TOPLEFT", sm, 0)
  widget.plateB.name:SetPoint("BOTTOMRIGHT", widget.plateB.header, "BOTTOMRIGHT", -sm, 0)
  widget.plateA.title:SetPoint("TOPLEFT", widget.plateA.header, "BOTTOMLEFT", sm, -xs)
  widget.plateB.title:SetPoint("TOPLEFT", widget.plateB.header, "BOTTOMLEFT", sm, -xs)
  widget.plateA.level:SetPoint("LEFT", widget.plateA.title, "RIGHT", sm, 0)
  widget.plateB.level:SetPoint("LEFT", widget.plateB.title, "RIGHT", sm, 0)

  widget.plateA.recordGlyph:SetPoint("TOPLEFT", widget.plateA.title, "BOTTOMLEFT", 0, -sm)
  widget.plateA.recordLabel:SetPoint("LEFT", widget.plateA.recordGlyph, "RIGHT", xs, 0)
  widget.plateA.record:SetPoint("LEFT", widget.plateA.recordLabel, "RIGHT", sm, 0)
  widget.plateB.recordGlyph:SetPoint("TOPLEFT", widget.plateB.title, "BOTTOMLEFT", 0, -sm)
  widget.plateB.recordLabel:SetPoint("LEFT", widget.plateB.recordGlyph, "RIGHT", xs, 0)
  widget.plateB.record:SetPoint("LEFT", widget.plateB.recordLabel, "RIGHT", sm, 0)

  widget.plateA.defensesGlyph:SetPoint("TOPLEFT", widget.plateA.recordGlyph, "BOTTOMLEFT", 0, -xs)
  widget.plateA.defensesLabel:SetPoint("LEFT", widget.plateA.defensesGlyph, "RIGHT", xs, 0)
  widget.plateA.defenses:SetPoint("LEFT", widget.plateA.defensesLabel, "RIGHT", sm, 0)
  widget.plateB.defensesGlyph:SetPoint("TOPLEFT", widget.plateB.recordGlyph, "BOTTOMLEFT", 0, -xs)
  widget.plateB.defensesLabel:SetPoint("LEFT", widget.plateB.defensesGlyph, "RIGHT", xs, 0)
  widget.plateB.defenses:SetPoint("LEFT", widget.plateB.defensesLabel, "RIGHT", sm, 0)

  layoutHonorific(widget.plateA, widget.plateA.record)
  layoutHonorific(widget.plateB, widget.plateB.record)

  widget.vs = makeLabel(widget, "GameFontNormal", "CENTER")
  applyFont(widget.vs, "label", "label")
  widget.vs:SetPoint("BOTTOM", widget.plateA, "BOTTOM", 0, 0)
  widget.vs:SetText("VS")
  tintRole(widget.vs, "charcoal")

  widget.headToHeadGlyph = makeGlyph(widget, "glyph_headtohead")
  widget.headToHeadLabel = makeLabel(widget, "GameFontNormal", "LEFT")
  applyFont(widget.headToHeadLabel, "label", "label")
  widget.headToHeadLabel:SetText("Head-to-head")
  tintRole(widget.headToHeadLabel, "charcoal")
  widget.headToHead = makeLabel(widget, "GameFontNormal", "LEFT")
  applyFont(widget.headToHead, "body", "body")
  widget.headToHeadLabel:SetPoint(
    "BOTTOMLEFT",
    widget.parchment,
    "BOTTOMLEFT",
    sm + space("glyph", 14) + xs,
    space("footer", 40)
  )
  widget.headToHeadGlyph:SetPoint("RIGHT", widget.headToHeadLabel, "LEFT", -xs, 0)
  widget.headToHead:SetPoint("LEFT", widget.headToHeadLabel, "RIGHT", sm, 0)
  setShown(widget.headToHead, false)
  setShown(widget.headToHeadLabel, false)
  setShown(widget.headToHeadGlyph, false)

  widget:Hide()
  wireCardOnHide(widget)
  if type(widget.RegisterEvent) == "function" then
    widget:RegisterEvent("DISPLAY_SIZE_CHANGED")
    widget:RegisterEvent("UI_SCALE_CHANGED")
    if type(widget.SetScript) == "function" then
      widget:SetScript("OnEvent", function()
        widget:SetSize(cardWidth(), cardHeight())
      end)
    end
  end
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
