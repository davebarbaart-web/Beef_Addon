ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode Fight HUD (Bible §10.7, §19.2 / §19.3). Compact spectator card.
-- Appears at sanction. Congregation pair arrives as Runtime subjects.fighters
-- (STATE); they never Sanction locally. livePair is GetSanctioned(), else
-- subjects.fighters with two ids only while RITE and riteType Gora
-- (B17-D). Remember it as lastPair. Persist lastPair
-- when both Gora and Runtime fighters are empty and the event is still live
-- (B9-E), except lastPair does not paint during a non-Gora RITE (B19-C)
-- or a non-Gora CONSEQUENCE (B21-B); a refuse forgets lastPair so
-- Knighting Continue stays hidden (B32-A).
-- Hide on QUIET / EndEvent / no last pair. A new live pair replaces
-- the remembered pair. clickPlate pick pair never uses lastPair (B11-B):
-- Pope (IsRegisteredPope local) → GetSanctioned() only; congregation →
-- Runtime subjects.fighters only while RITE and riteType Gora (B16-C).
-- Isolated suite with a live GetSanctioned still sends even if Sender
-- is nil. No verdict qualifier. Names use Theme:FontPath("display") at
-- Theme.FontSize.name (≥ 16). Refresh re-applies on a shown pair (B25-D)
-- and restores class tint after SetFontObject (B34-A). Format line,
-- records, defenses, vs, and favor use Theme label/body.
-- Defined fallback: everything except live health. Favor split is
-- Pope-local from Gora (gora pair only, so a Runtime leftover after a
-- ruling does not thaw the freeze), or congregation broadcast only.
-- Quiet forgetPersist also nils broadcastFavor (License 2 / §10.6
-- per-event); it does not nil favorTarget (dest persist, B37-B).
-- Dress is Theme HUD-B: iron/charcoal chrome, parchment name fields via
-- Theme:Texture("frame_proclamation_center") (stock QuestBG until custom
-- art), mute class-tinted rails via Theme:Texture("bar_stainedglass_fill"),
-- favor fills via Theme:Texture("bar_favor_fill"), crest via
-- Theme:Texture("sigil_gora") — never a faction crest. Small
-- Theme:Texture("sigil_favor") sits on the FAVOR label. Mute rails are
-- decorative, not live HP. Defense count is Store:CountDefenses as a
-- mute integer per fighter; hide when 0 or the method is missing.
-- Painted defenses are Common.RomanNumeral; W/L and head-to-head are
-- Common.RomanPair (0 paints N — Common.RomanNumeral is 1–3999).
-- Favor percentages stay Arabic. Defense labels are SetWidth(28) so
-- two-digit W/L plus a count cannot grow into VS / seal (B35-A).
-- No sound. No toasts. Cards stay mute.
local Hud = {
  MODE = "Event",
}
COB.Hud = Hud

local FRAME_NAME = "ChurchOfBeefHud"
local WIDTH, HEIGHT = 420, 100
local TOP_INSET = -24
local EN_DASH = "\226\128\147"
local FORMAT_DOT = " \194\183 "

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

local frame = nil
local lastView = nil
local lastPair = nil
local lastPopeFavor = nil
local broadcastFavor = nil
local favorTarget = nil
local localCharacterId = nil

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function hiddenView()
  return {
    shown = false,
    mode = "Event",
    fighterA = nil,
    fighterB = nil,
    headToHead = nil,
    health = nil,
    favor = nil,
  }
end

local function uiDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

local function savePoint(widget)
  local db = uiDb()
  if not db then return end
  local point, _, relativePoint, x, y = widget:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  db.hud = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(widget)
  local db = uiDb()
  local p = db and db.hud
  widget:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    widget:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    widget:SetPoint("TOP", UIParent, "TOP", 0, TOP_INSET)
  end
end

local function hudHeight()
  local parent = UIParent
  local h = parent and parent.GetHeight and parent:GetHeight()
  if type(h) == "number" and h > 0 then
    local budget = math.floor(h * 0.12 + 0.5)
    if budget < HEIGHT then return budget end
    return HEIGHT
  end
  return HEIGHT
end

local function themeColor(role)
  if not (COB.Theme and COB.Theme.Color) then return nil end
  local r, g, b = COB.Theme:Color(role)
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
    return nil
  end
  return r, g, b
end

local function themeColorTable(role)
  local r, g, b = themeColor(role)
  if r == nil then return nil end
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

local function applyTexture(tex, path)
  if not tex or type(path) ~= "string" or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  if ok then
    tex._cobTexture = path
    return true
  end
  return false
end

local function fill(tex, r, g, b, a)
  if not tex then return end
  a = a or 1
  if tex.SetColorTexture then
    pcall(tex.SetColorTexture, tex, r, g, b, a)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, a)
  end
  tex._cobColor = { r = r, g = g, b = b, a = a }
end

local function applyParchment(tex)
  if not tex then return end
  -- Theme:Texture("frame_proclamation_center") — parchment fill; stock QuestBG.
  if applyTexture(tex, themeTexture("frame_proclamation_center")) then return end
  local r, g, b = themeColor("parchmentMid")
  if r then fill(tex, r, g, b, 0.94) end
end

local function tintSeal(tex)
  if not tex then return end
  local gold = themeColorTable("gold")
  if not applyTexture(tex, themeTexture("sigil_gora")) then
    if gold then fill(tex, gold.r, gold.g, gold.b, 1) end
    return
  end
  if gold and tex.SetVertexColor then
    tex:SetVertexColor(gold.r, gold.g, gold.b, 1)
    tex._cobColor = { r = gold.r, g = gold.g, b = gold.b, a = 1 }
  end
end

local function tintRail(rail, color)
  if not rail then return end
  local ink = themeColorTable("silver")
  if type(color) == "table"
      and type(color.r) == "number"
      and type(color.g) == "number"
      and type(color.b) == "number" then
    ink = color
  end
  applyTexture(rail, themeTexture("bar_stainedglass_fill"))
  if not ink then return end
  if rail.SetVertexColor then
    rail:SetVertexColor(ink.r, ink.g, ink.b, 0.85)
  end
  rail._cobColor = { r = ink.r, g = ink.g, b = ink.b, a = 0.85 }
end

local function tint(fs, color)
  if not fs or type(color) ~= "table" then return end
  local r, g, b = color.r, color.g, color.b
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then return end
  if fs.SetTextColor then fs:SetTextColor(r, g, b) end
  fs._cobColor = { r = r, g = g, b = b }
end

local function classFile(class)
  if type(class) ~= "string" then return nil end
  local file = class:gsub("%s+", ""):upper()
  if file == "" then return nil end
  return file
end

local function classColor(class)
  local file = classFile(class)
  if not file or not (COB.Theme and COB.Theme.ClassColor) then return nil end
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

local function eventLive()
  if not COB.Runtime or not COB.Runtime.Snapshot then return false end
  local snap = COB.Runtime:Snapshot()
  return type(snap) == "table" and snap.state ~= "QUIET"
end

local function goraPair()
  if not COB.Gora or not COB.Gora.GetSanctioned then return nil end
  local pair = COB.Gora:GetSanctioned()
  if type(pair) ~= "table" then return nil end
  if pair.fighterA == nil or pair.fighterB == nil then return nil end
  return pair
end

local function runtimePair()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then return nil end
  local subjects = snap.subjects
  if type(subjects) ~= "table" then return nil end
  local fighters = subjects.fighters
  if type(fighters) ~= "table" then return nil end
  local a, b = fighters[1], fighters[2]
  if type(a) ~= "number" or type(b) ~= "number" then return nil end
  return { fighterA = a, fighterB = b }
end

local function livePair()
  local gora = goraPair()
  if gora then return gora end
  do
    if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
    local snap = COB.Runtime:Snapshot()
    if type(snap) == "table" then
      if snap.state == "RITE" and snap.riteType == "Gora" then
        return runtimePair()
      end
    end
  end
  return nil
end

local function localSender()
  if COB.Group and COB.Group.PlayerName then
    return COB.Group.PlayerName()
  end
  if type(UnitName) == "function" then
    return UnitName("player")
  end
  return nil
end

local function isLocalPope()
  local Sender = COB.Sender
  if not Sender or type(Sender.IsRegisteredPope) ~= "function" then
    return false
  end
  return Sender:IsRegisteredPope(localSender()) == true
end

local function favorPercents(a, b)
  if a + b == 0 then
    return 0, 0
  end
  local pctA = math.floor(100 * a / (a + b))
  return pctA, 100 - pctA
end

local function favorView(split)
  if type(split) ~= "table" then return nil end
  local a, b = split.a, split.b
  if type(a) ~= "number" or type(b) ~= "number" then return nil end
  local pctA, pctB = favorPercents(a, b)
  return { a = a, b = b, pctA = pctA, pctB = pctB }
end

local function resolveFavor()
  if isLocalPope() then
    if goraPair() then
      if not (COB.Gora and COB.Gora.GetFavorSplit) then
        lastPopeFavor = nil
        return nil
      end
      lastPopeFavor = favorView(COB.Gora:GetFavorSplit())
      return lastPopeFavor
    end
    return lastPopeFavor
  end
  return favorView(broadcastFavor)
end

local function rememberPair(pair)
  lastPair = { fighterA = pair.fighterA, fighterB = pair.fighterB }
end

local function forgetPersist()
  lastPair = nil
  lastPopeFavor = nil
  broadcastFavor = nil
end

local function displayPair()
  local live = livePair()
  if live then
    rememberPair(live)
    return live
  end
  if lastPair then
    if COB.Runtime and COB.Runtime.Snapshot then
      local snap = COB.Runtime:Snapshot()
      if type(snap) == "table"
          and (snap.state == "RITE" or snap.state == "CONSEQUENCE")
          and snap.riteType ~= "Gora" then
        forgetPersist()
        return nil
      end
    end
    return lastPair
  end
  return nil
end

local function tintBar(bar, color)
  if not bar then return end
  local ink = themeColorTable("silver")
  if type(color) == "table"
      and type(color.r) == "number"
      and type(color.g) == "number"
      and type(color.b) == "number" then
    ink = color
  end
  if not ink then return end
  if bar.SetStatusBarColor then
    bar:SetStatusBarColor(ink.r, ink.g, ink.b)
  end
  bar._cobColor = { r = ink.r, g = ink.g, b = ink.b }
end

local function hideFavorWidgets()
  if not frame then return end
  if frame.favorLabel and frame.favorLabel.Hide then frame.favorLabel:Hide() end
  if frame.favorSigil and frame.favorSigil.Hide then frame.favorSigil:Hide() end
  if frame.barA and frame.barA.Hide then frame.barA:Hide() end
  if frame.barB and frame.barB.Hide then frame.barB:Hide() end
  if frame.pctA then
    frame.pctA:SetText("")
    if frame.pctA.Hide then frame.pctA:Hide() end
  end
  if frame.pctB then
    frame.pctB:SetText("")
    if frame.pctB.Hide then frame.pctB:Hide() end
  end
end

local function paintFavor(favor, fighterA, fighterB)
  if not frame then return end
  if not favor then
    hideFavorWidgets()
    return
  end
  frame.favorLabel:SetText("FAVOR")
  if frame.favorLabel.Show then frame.favorLabel:Show() end
  if frame.favorSigil and frame.favorSigil.Show then frame.favorSigil:Show() end
  frame.pctA:SetText(tostring(favor.pctA) .. "%")
  frame.pctB:SetText(tostring(favor.pctB) .. "%")
  if frame.pctA.Show then frame.pctA:Show() end
  if frame.pctB.Show then frame.pctB:Show() end
  if frame.barA.SetMinMaxValues then frame.barA:SetMinMaxValues(0, 100) end
  if frame.barB.SetMinMaxValues then frame.barB:SetMinMaxValues(0, 100) end
  if frame.barA.SetValue then frame.barA:SetValue(favor.pctA) end
  if frame.barB.SetValue then frame.barB:SetValue(favor.pctB) end
  tintBar(frame.barA, fighterA and fighterA.nameColor)
  tintBar(frame.barB, fighterB and fighterB.nameColor)
  if frame.barA.Show then frame.barA:Show() end
  if frame.barB.Show then frame.barB:Show() end
end

-- Display persist may use lastPair. Favor picks close when the live
-- pair is gone. Isolated suite: a live GetSanctioned still sends
-- even if Sender is nil (existing Sanctioned plate-click pins).
-- Congregation leftovers send only during a Gora RITE (B16-C).
local function pickPair()
  local gora = goraPair()
  if gora then return gora end
  if isLocalPope() then return nil end
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then return nil end
  if snap.state == "RITE" and snap.riteType == "Gora" then
    return runtimePair()
  end
  return nil
end

local function clickPlate(side)
  if type(favorTarget) ~= "string" or favorTarget == "" then return end
  if type(localCharacterId) ~= "number" then return end
  local pair = pickPair()
  if not pair then return end
  local pickId = (side == "A") and pair.fighterA or pair.fighterB
  Hud:PickFavor(pickId, favorTarget, localCharacterId)
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

local function defenseCount(characterId)
  if not (COB.Store and type(COB.Store.CountDefenses) == "function") then
    return nil
  end
  local n = COB.Store:CountDefenses(characterId)
  if type(n) ~= "number" then return nil end
  local whole = math.floor(n)
  if whole <= 0 then return nil end
  return whole
end

local function fighterFrom(id)
  local ch = COB.Store and COB.Store.GetCharacter and COB.Store:GetCharacter(id) or nil
  if type(ch) ~= "table" then
    return {
      id = id,
      name = "",
      level = nil,
      title = nil,
      wins = 0,
      losses = 0,
      nameColor = nil,
      defenses = defenseCount(id),
    }
  end
  local gora = type(ch.gora) == "table" and ch.gora or {}
  return {
    id = id,
    name = ch.name,
    class = ch.class,
    level = ch.level,
    title = churchTitle(id),
    wins = gora.wins or 0,
    losses = gora.losses or 0,
    nameColor = classColor(ch.class),
    defenses = defenseCount(id),
  }
end

local function romanGlyph(n)
  local whole = 0
  if type(n) == "number" then whole = math.floor(n) end
  if whole >= 1 and COB.Common and COB.Common.RomanNumeral then
    local s = COB.Common.RomanNumeral(whole)
    if type(s) == "string" then return s end
  end
  if whole == 0 then return "N" end
  return nil
end

local function romanPairText(a, b)
  if COB.Common and COB.Common.RomanPair then
    local s = COB.Common.RomanPair(a, b)
    if type(s) == "string" then return s end
  end
  local left = romanGlyph(a)
  local right = romanGlyph(b)
  if type(left) ~= "string" or type(right) ~= "string" then return "" end
  return left .. EN_DASH .. right
end

local function recordText(fighter)
  return romanPairText(fighter.wins or 0, fighter.losses or 0)
end

local function formatLine(fighter)
  local parts = {}
  if type(fighter.name) == "string" and fighter.name ~= "" then
    parts[#parts + 1] = fighter.name
  end
  if type(fighter.level) == "number" then
    parts[#parts + 1] = tostring(fighter.level)
  end
  if type(fighter.title) == "string" and fighter.title ~= "" then
    parts[#parts + 1] = fighter.title
  end
  if type(fighter.class) == "string" and fighter.class ~= "" then
    parts[#parts + 1] = fighter.class
  end
  if #parts == 0 then return "" end
  return table.concat(parts, FORMAT_DOT)
end

local function levelText(fighter)
  if type(fighter.level) ~= "number" then return "" end
  return tostring(fighter.level)
end

local function defenseText(n)
  if type(n) ~= "number" or n <= 0 then return "" end
  local whole = math.floor(n)
  if COB.Common and COB.Common.RomanNumeral then
    local s = COB.Common.RomanNumeral(whole)
    if type(s) == "string" then return s end
  end
  return tostring(whole)
end

local function paintDefense(side, n)
  local fs = frame["defense" .. side]
  if not fs then return end
  fs:SetWidth(28)
  tint(fs, themeColorTable("silver"))
  if type(n) == "number" and n > 0 then
    fs:SetText(defenseText(n))
    if fs.Show then fs:Show() end
  else
    fs:SetText("")
    if fs.Hide then fs:Hide() end
  end
end

local function paintFighter(side, fighter)
  local nameFS = frame["name" .. side]
  local levelFS = frame["level" .. side]
  local titleFS = frame["title" .. side]
  local recordFS = frame["record" .. side]
  nameFS:SetText(fighter.name or "")
  levelFS:SetText(levelText(fighter))
  titleFS:SetText(formatLine(fighter))
  recordFS:SetText(recordText(fighter))
  tint(nameFS, fighter.nameColor or themeColorTable("parchment"))
  tint(levelFS, themeColorTable("silver"))
  tint(titleFS, themeColorTable("parchment"))
  tint(recordFS, themeColorTable("silver"))
  paintDefense(side, fighter.defenses)
  tintRail(frame["rail" .. side], fighter.nameColor)
end

local function paintHidden()
  lastView = hiddenView()
  if not frame then return lastView end
  frame.nameA:SetText("")
  frame.nameB:SetText("")
  frame.levelA:SetText("")
  frame.levelB:SetText("")
  frame.titleA:SetText("")
  frame.titleB:SetText("")
  frame.recordA:SetText("")
  frame.recordB:SetText("")
  paintDefense("A", nil)
  paintDefense("B", nil)
  if frame.headToHead.Hide then frame.headToHead:Hide() end
  hideFavorWidgets()
  frame:Hide()
  return lastView
end

local function applyFont(fs, role, sizeKey, minSize)
  if not fs then return end
  local path = themeFont(role)
  local size = themeFontSize(sizeKey, minSize)
  local used = false
  if type(path) == "string" and fs.SetFont then
    local ok = pcall(fs.SetFont, fs, path, size)
    used = ok and true or false
    if used then
      fs._cobFont = path
      fs._cobFontSize = size
    end
  end
  if not used and fs.SetFontObject then
    local font = GameFontHighlight
    if type(font) == "string" then font = _G[font] end
    if font then pcall(fs.SetFontObject, fs, font) end
  end
end

local function applyNameFont(fs)
  applyFont(fs, "display", "name", 16)
end

local function applyLabelFont(fs, sizeKey)
  applyFont(fs, "label", sizeKey or "label")
end

local function paintShown(pair)
  local fighterA = fighterFrom(pair.fighterA)
  local fighterB = fighterFrom(pair.fighterB)
  local h2h = nil
  if COB.Store and COB.Store.GetCharacter then
    local chA = COB.Store:GetCharacter(pair.fighterA)
    h2h = headToHeadFor(chA, pair.fighterB)
  end

  paintFighter("A", fighterA)
  paintFighter("B", fighterB)
  if h2h then
    frame.headToHead:SetText(recordText(h2h))
    if frame.headToHead.Show then frame.headToHead:Show() end
  else
    frame.headToHead:SetText("")
    if frame.headToHead.Hide then frame.headToHead:Hide() end
  end

  local favor = resolveFavor()
  paintFavor(favor, fighterA, fighterB)

  lastView = {
    shown = true,
    mode = "Event",
    fighterA = fighterA,
    fighterB = fighterB,
    headToHead = h2h,
    health = nil,
    favor = favor,
  }
  applyNameFont(frame.nameA)
  applyNameFont(frame.nameB)
  tint(frame.nameA, fighterA.nameColor or themeColorTable("parchment"))
  tint(frame.nameB, fighterB.nameColor or themeColorTable("parchment"))
  frame:Show()
  return lastView
end

local function makeLabel(parent, name, template, justify)
  local fs = parent:CreateFontString(name, "OVERLAY", template or "GameFontNormal")
  if fs.SetJustifyH and justify then fs:SetJustifyH(justify) end
  return fs
end

local function applyBarFill(bar, semantic)
  local path = themeTexture(semantic)
  if not bar or type(path) ~= "string" then return end
  if bar.SetStatusBarTexture then
    pcall(bar.SetStatusBarTexture, bar, path)
  end
  bar._cobTexture = path
end

local function build()
  local parent = UIParent
  local widget = CreateFrame("Frame", FRAME_NAME, parent, "BackdropTemplate")
  widget:SetSize(WIDTH, hudHeight())
  widget:SetMovable(true)
  widget:SetClampedToScreen(true)
  if widget.EnableMouse then widget:EnableMouse(true) end
  if widget.RegisterForDrag then widget:RegisterForDrag("LeftButton") end
  if widget.SetFrameStrata then widget:SetFrameStrata("HIGH") end
  if widget.SetBackdrop then
    widget:SetBackdrop({
      bgFile = themeTexture("frame_proclamation"),
      edgeFile = themeTexture("frame_proclamation_edge_top"),
      tile = true,
      tileSize = 8,
      edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    local cr, cg, cb = themeColor("charcoal")
    if cr and widget.SetBackdropColor then
      widget:SetBackdropColor(cr, cg, cb, 0.92)
    end
    local gr, gg, gb = themeColor("gold")
    if gr and widget.SetBackdropBorderColor then
      widget:SetBackdropBorderColor(gr, gg, gb, 1)
    end
  end

  widget.iron = widget:CreateTexture(nil, "BACKGROUND")
  if widget.iron.SetAllPoints then widget.iron:SetAllPoints(widget) end
  do
    local r, g, b = themeColor("iron")
    if r then fill(widget.iron, r, g, b, 0.94) end
  end

  widget.parchment = widget:CreateTexture(nil, "BACKGROUND")
  if widget.parchment.ClearAllPoints then widget.parchment:ClearAllPoints() end
  widget.parchment:SetPoint("TOPLEFT", widget, "TOPLEFT", 5, -5)
  widget.parchment:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -5, 5)
  applyParchment(widget.parchment)

  widget.goldRule = widget:CreateTexture(nil, "ARTWORK")
  widget.goldRule:SetPoint("TOPLEFT", widget, "TOPLEFT", 8, -3)
  widget.goldRule:SetPoint("TOPRIGHT", widget, "TOPRIGHT", -8, -3)
  if widget.goldRule.SetHeight then widget.goldRule:SetHeight(1) end
  do
    local r, g, b = themeColor("gold")
    if r then fill(widget.goldRule, r, g, b, 0.90) end
  end

  widget.seal = widget:CreateTexture(nil, "ARTWORK")
  widget.seal:SetSize(28, 28)
  widget.seal:SetPoint("TOP", widget, "TOP", 0, -2)
  tintSeal(widget.seal)

  widget.nameA = makeLabel(widget, nil, "GameFontHighlight", "LEFT")
  widget.nameB = makeLabel(widget, nil, "GameFontHighlight", "RIGHT")
  applyNameFont(widget.nameA)
  applyNameFont(widget.nameB)
  widget.titleA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.titleB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.levelA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.levelB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.recordA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.recordB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.defenseA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.defenseB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.vs = makeLabel(widget, nil, "GameFontNormal", "CENTER")
  widget.headToHead = makeLabel(widget, nil, "GameFontNormal", "CENTER")
  widget.favorLabel = makeLabel(widget, nil, "GameFontHighlightSmall", "CENTER")
  widget.pctA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.pctB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  applyLabelFont(widget.titleA, "label")
  applyLabelFont(widget.titleB, "label")
  applyLabelFont(widget.levelA, "caption")
  applyLabelFont(widget.levelB, "caption")
  applyLabelFont(widget.recordA, "label")
  applyLabelFont(widget.recordB, "label")
  applyLabelFont(widget.defenseA, "caption")
  applyLabelFont(widget.defenseB, "caption")
  applyLabelFont(widget.vs, "label")
  applyLabelFont(widget.headToHead, "caption")
  applyLabelFont(widget.favorLabel, "label")
  applyLabelFont(widget.pctA, "label")
  applyLabelFont(widget.pctB, "label")

  widget.barA = CreateFrame("StatusBar", nil, widget)
  widget.barB = CreateFrame("StatusBar", nil, widget)
  applyBarFill(widget.barA, "bar_favor_fill")
  applyBarFill(widget.barB, "bar_favor_fill")
  if widget.barA.SetMinMaxValues then widget.barA:SetMinMaxValues(0, 100) end
  if widget.barB.SetMinMaxValues then widget.barB:SetMinMaxValues(0, 100) end
  widget.barA:SetSize(110, 8)
  widget.barB:SetSize(110, 8)

  widget.favorSigil = widget:CreateTexture(nil, "ARTWORK")
  widget.favorSigil:SetSize(10, 10)
  applyTexture(widget.favorSigil, themeTexture("sigil_favor"))
  do
    local gold = themeColorTable("gold")
    if gold and widget.favorSigil.SetVertexColor then
      widget.favorSigil:SetVertexColor(gold.r, gold.g, gold.b, 1)
      widget.favorSigil._cobColor = { r = gold.r, g = gold.g, b = gold.b, a = 1 }
    end
  end

  widget.pickA = CreateFrame("Button", nil, widget)
  widget.pickB = CreateFrame("Button", nil, widget)
  widget.pickA:SetSize(190, 36)
  widget.pickB:SetSize(190, 36)
  if widget.pickA.EnableMouse then widget.pickA:EnableMouse(true) end
  if widget.pickB.EnableMouse then widget.pickB:EnableMouse(true) end

  widget.nameA:SetPoint("TOPLEFT", widget, "TOPLEFT", 12, -8)
  widget.nameB:SetPoint("TOPRIGHT", widget, "TOPRIGHT", -12, -8)
  widget.vs:SetPoint("TOP", widget, "TOP", 0, -8)
  widget.vs:SetText("VS")
  tint(widget.vs, themeColorTable("silver"))

  widget.railA = widget:CreateTexture(nil, "ARTWORK")
  widget.railB = widget:CreateTexture(nil, "ARTWORK")
  widget.railA:SetSize(120, 8)
  widget.railB:SetSize(120, 8)
  widget.railA:SetPoint("TOPLEFT", widget.nameA, "BOTTOMLEFT", 0, -1)
  widget.railB:SetPoint("TOPRIGHT", widget.nameB, "BOTTOMRIGHT", 0, -1)
  tintRail(widget.railA, nil)
  tintRail(widget.railB, nil)

  widget.titleA:SetPoint("TOPLEFT", widget.nameA, "BOTTOMLEFT", 0, -10)
  widget.titleB:SetPoint("TOPRIGHT", widget.nameB, "BOTTOMRIGHT", 0, -10)

  -- Thin parchment behind name + HUD-B format line. Theme proclamation center.
  widget.nameFieldA = widget:CreateTexture(nil, "BORDER")
  widget.nameFieldB = widget:CreateTexture(nil, "BORDER")
  applyParchment(widget.nameFieldA)
  applyParchment(widget.nameFieldB)
  widget.nameFieldA:SetPoint("TOPLEFT", widget.nameA, "TOPLEFT", -4, 3)
  widget.nameFieldA:SetPoint("BOTTOMLEFT", widget.titleA, "BOTTOMLEFT", -4, -3)
  widget.nameFieldA:SetPoint("RIGHT", widget.railA, "RIGHT", 4, 0)
  widget.nameFieldB:SetPoint("TOPRIGHT", widget.nameB, "TOPRIGHT", 4, 3)
  widget.nameFieldB:SetPoint("BOTTOMRIGHT", widget.titleB, "BOTTOMRIGHT", 4, -3)
  widget.nameFieldB:SetPoint("LEFT", widget.railB, "LEFT", -4, 0)

  widget.levelA:SetPoint("TOPLEFT", widget.titleA, "BOTTOMLEFT", 0, -2)
  widget.levelB:SetPoint("TOPRIGHT", widget.titleB, "BOTTOMRIGHT", 0, -2)
  widget.levelA:Hide()
  widget.levelB:Hide()
  widget.recordA:SetPoint("TOPLEFT", widget.titleA, "BOTTOMLEFT", 0, -2)
  widget.recordB:SetPoint("TOPRIGHT", widget.titleB, "BOTTOMRIGHT", 0, -2)
  widget.defenseA:SetPoint("LEFT", widget.recordA, "RIGHT", 8, 0)
  widget.defenseB:SetPoint("RIGHT", widget.recordB, "LEFT", -8, 0)
  widget.defenseA:SetWidth(28)
  widget.defenseB:SetWidth(28)
  widget.defenseA:Hide()
  widget.defenseB:Hide()
  widget.headToHead:SetPoint("BOTTOM", widget, "BOTTOM", 0, 22)
  widget.headToHead:Hide()

  widget.favorLabel:SetPoint("BOTTOM", widget, "BOTTOM", 0, 8)
  widget.favorLabel:SetText("FAVOR")
  widget.favorSigil:SetPoint("RIGHT", widget.favorLabel, "LEFT", -2, 0)
  widget.pctA:SetPoint("BOTTOMLEFT", widget, "BOTTOMLEFT", 12, 8)
  widget.pctB:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -12, 8)
  widget.barA:SetPoint("LEFT", widget.pctA, "RIGHT", 6, 0)
  widget.barB:SetPoint("RIGHT", widget.pctB, "LEFT", -6, 0)
  widget.favorLabel:Hide()
  widget.favorSigil:Hide()
  widget.pctA:Hide()
  widget.pctB:Hide()
  widget.barA:Hide()
  widget.barB:Hide()

  widget.pickA:SetPoint("TOPLEFT", widget, "TOPLEFT", 8, -6)
  widget.pickB:SetPoint("TOPRIGHT", widget, "TOPRIGHT", -8, -6)
  widget.pickA:SetScript("OnClick", function()
    clickPlate("A")
  end)
  widget.pickB:SetScript("OnClick", function()
    clickPlate("B")
  end)

  widget:SetScript("OnDragStart", function(self)
    if self.StartMoving then self:StartMoving() end
  end)
  widget:SetScript("OnDragStop", function(self)
    if self.StopMovingOrSizing then self:StopMovingOrSizing() end
    savePoint(self)
  end)
  widget:Hide()
  return widget
end

function Hud:Init()
  if not frame then
    frame = build()
    restorePoint(frame)
  end
  self:Refresh()
  return frame
end

function Hud:IsShown()
  return frame ~= nil and frame:IsShown() == true
end

function Hud:GetView()
  if lastView == nil then lastView = hiddenView() end
  return deepcopy(lastView)
end

function Hud:Refresh()
  if not frame then
    self:Init()
    return self:GetView()
  end
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

function Hud:SetBroadcastFavor(favor)
  if type(favor) ~= "table" then
    broadcastFavor = nil
    return
  end
  local a, b = favor.a, favor.b
  if type(a) ~= "number" or type(b) ~= "number" then
    broadcastFavor = nil
    return
  end
  broadcastFavor = { a = a, b = b }
end

function Hud:SetFavorTarget(target)
  if type(target) == "string" and target ~= "" then
    favorTarget = target
  else
    favorTarget = nil
  end
end

function Hud:SetLocalCharacterId(characterId)
  if type(characterId) == "number" then
    localCharacterId = characterId
  else
    localCharacterId = nil
  end
end

function Hud:PickFavor(pickId, target, characterId)
  if type(target) ~= "string" or target == "" then
    return nil, "no target"
  end
  if type(characterId) ~= "number" then
    return nil, "no character"
  end
  if not (COB.Net and COB.Net.SendFavor) then
    return nil, "no net"
  end
  return COB.Net:SendFavor({ characterId = characterId, pick = pickId }, target)
end

function Hud:ResetForTests()
  if not COB._IN_TEST then return false end
  broadcastFavor = nil
  favorTarget = nil
  localCharacterId = nil
  forgetPersist()
  lastView = hiddenView()
  if frame then
    paintHidden()
  end
  return true
end
