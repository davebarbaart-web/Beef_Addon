ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Quiet Mode Nights parchment (Bible §14.1 / Law 6 / Law 10). Player-opened
-- 28-day board. No login reveal. No sound. Empty copy is clerical.
-- Colors, fonts, and textures resolve through COB.Theme. No scheduling
-- suite, attendance reply, deputy, Console, or HUD.
local HEADER = "Nights"
local DESCRIPTION = "Posted Church nights and Discord notices for the next four weeks."
local EMPTY = "No nights posted this week."
local CHURCH_NAME = "Church of Beef"

local DecreeBanner = {
  MODE = "QUIET",
  HEADER = HEADER,
  DESCRIPTION = DESCRIPTION,
}
COB.DecreeBanner = DecreeBanner

-- Full-surface art keeps a 12% transparent master margin for clean imports;
-- reclaim it when the parchment is stretched into its live banner slot.
local SURFACE_U0, SURFACE_U1 = 0.12, 0.88

local FRAME_NAME = "ChurchOfBeefDecree"
local TOP_INSET = -72

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

local loginRevealDone = false

local function boardRows()
  if not (COB.Nights and COB.Nights.Month) then return {} end
  local rows = COB.Nights:Month()
  if type(rows) ~= "table" then return {} end
  return rows
end

local function markSeen()
  if type(ChurchOfBeefDB) ~= "table" then return end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  local rev = 0
  if COB.Nights and COB.Nights.BoardRevision then
    rev = COB.Nights:BoardRevision()
  end
  ChurchOfBeefDB.ui.nightsSeenRevision = rev
  if COB.Minimap and type(COB.Minimap.RefreshGlow) == "function" then
    pcall(COB.Minimap.RefreshGlow, COB.Minimap)
  end
end

local function boardExtent()
  local w, h = 440, 468
  local parent = UIParent
  local pw = parent and parent.GetWidth and parent:GetWidth()
  local ph = parent and parent.GetHeight and parent:GetHeight()
  if type(pw) == "number" and pw > 0 and pw < 900 then
    w, h = 380, 400
  elseif type(pw) == "number" and pw >= 1200 then
    w, h = 480, 520
  end
  if type(ph) == "number" and ph > 0 and ph < 700 then
    h = math.min(h, 380)
  end
  return w, h
end

local function themeColor(role, a)
  if not (COB.Theme and COB.Theme.Color) then return nil end
  local r, g, b = COB.Theme:Color(role)
  if type(r) ~= "number" then return nil end
  return r, g, b, a or 1
end

local function themeFont(role)
  if COB.Theme and COB.Theme.FontPath then
    return COB.Theme:FontPath(role)
  end
end

local function themeSize(key)
  local sizes = COB.Theme and COB.Theme.FontSize
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
end

local function themeTexture(name)
  if COB.Theme and COB.Theme.Texture then
    return COB.Theme:Texture(name)
  end
end

local function space(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
  return fallback
end

local function fill(tex, r, g, b, a)
  if not tex then return end
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, a)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, a)
  end
end

local function fillRole(tex, role, a)
  local r, g, b, alpha = themeColor(role, a)
  if not r then return end
  fill(tex, r, g, b, alpha)
end

local function colorText(fs, role, a)
  if not fs or not fs.SetTextColor then return end
  local r, g, b, alpha = themeColor(role, a)
  if r then fs:SetTextColor(r, g, b, alpha) end
end

local function tintRole(tex, role, a)
  if not tex or not tex.SetVertexColor then return end
  local r, g, b, alpha = themeColor(role, a)
  if r then pcall(tex.SetVertexColor, tex, r, g, b, alpha) end
end

local function applyTexture(tex, path)
  if not tex or not path or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  return ok and true or false
end

local function applyFont(fs, template, path, size)
  if not fs then return end
  local used = false
  if path and fs.SetFont then
    local ok, applied = pcall(fs.SetFont, fs, path, size or 16, "")
    used = ok and applied and true or false
  end
  if not used and fs.SetFontObject then
    local font = template
    if type(template) == "string" then font = _G[template] end
    if font then pcall(fs.SetFontObject, fs, font) end
  end
end

local function labelButton(button, text, template, ink, size)
  if not button then return end
  local fs = button:CreateFontString(nil, "OVERLAY", template or "GameFontNormal")
  applyFont(fs, template or "GameFontNormal", themeFont("label"), size or 14)
  if button.SetFontString then button:SetFontString(fs) end
  colorText(fs, ink or "charcoal")
  if fs.SetAllPoints then fs:SetAllPoints(button) end
  if fs.SetText then fs:SetText(text) end
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

local function uiSlot()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui.decree) ~= "table" then
    ChurchOfBeefDB.ui.decree = {}
  end
  return ChurchOfBeefDB.ui.decree
end

local function savePoint(frame)
  local slot = uiSlot()
  if not slot then return end
  local point, _, relativePoint, x, y = frame:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  slot.point = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(frame)
  local slot = nil
  if type(ChurchOfBeefDB) == "table" and type(ChurchOfBeefDB.ui) == "table"
      and type(ChurchOfBeefDB.ui.decree) == "table" then
    slot = ChurchOfBeefDB.ui.decree
  end
  local p = slot and slot.point
  frame:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    frame:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    frame:SetPoint("TOP", UIParent, "TOP", 0, TOP_INSET)
  end
end

local function attachList(frame)
  if not (COB.NightRows and COB.NightRows.Attach) then return nil end
  if not frame.NightList then return nil end
  return COB.NightRows:Attach(frame.NightList, {
    variant = "parchment",
    pool = 8,
    onGoing = function(key)
      local card = COB.PlayerCard
      if card and type(card.TapGoing) == "function" then
        card:TapGoing(key)
      end
      DecreeBanner:Refresh()
    end,
  })
end

local function paint(frame, rows)
  local bw, bh = boardExtent()
  if frame.SetWidth then frame:SetWidth(bw) end
  if frame.SetHeight then frame:SetHeight(bh) end
  if frame.HeaderText and frame.HeaderText.SetText then
    frame.HeaderText:SetText(HEADER)
  end
  if frame.DescriptionText and frame.DescriptionText.SetText then
    frame.DescriptionText:SetText(DESCRIPTION)
  end
  local n = type(rows) == "table" and #rows or 0
  if frame.LineText and frame.LineText.SetText then
    frame.LineText:SetText(n == 0 and EMPTY or "")
  end
  if frame.LineText then
    if n == 0 then frame.LineText:Show() else frame.LineText:Hide() end
  end
  if frame.FlavorText then
    if frame.FlavorText.SetText then frame.FlavorText:SetText("") end
    frame.FlavorText:Hide()
  end
  if frame.GoldRule and frame.GoldRule.Hide then
    frame.GoldRule:Hide()
  end
  local host = attachList(frame)
  if host and COB.NightRows and COB.NightRows.Paint then
    COB.NightRows:Paint(host, rows)
    if frame.NightList then
      if n == 0 then frame.NightList:Hide() else frame.NightList:Show() end
    end
    local first
    if host.rows then
      for i = 1, #host.rows do
        local going = host.rows[i] and host.rows[i].Going
        if going and going.IsShown and going:IsShown() then
          first = going
          break
        end
      end
    end
    frame.GoingButtons = host.rows and { host.rows[1] and host.rows[1].Going } or {}
    frame.GoingButton = first
  elseif n == 0 and frame.NightList then
    frame.NightList:Hide()
  end
end

local function wipePaint(frame)
  if not frame then return end
  if frame.LineText and frame.LineText.SetText then
    frame.LineText:SetText("")
  end
  if frame.NightList and COB.NightRows and COB.NightRows.Host then
    local host = COB.NightRows:Host(frame.NightList)
    if host and COB.NightRows.Paint then
      COB.NightRows:Paint(host, {})
    end
  end
  if frame.FlavorText then
    if frame.FlavorText.SetText then frame.FlavorText:SetText("") end
    frame.FlavorText:Hide()
  end
end

-- ESC Hide via UISpecialFrames bypasses DecreeBanner:Hide. Wire OnHide
-- once; never replace an existing script. Wipe leftover paint when
-- getDecree is nil. Do not Show.
local function wireDecreeOnHide(frame)
  if not frame then return end
  if type(frame.SetScript) ~= "function" then return end
  local existing = type(frame.GetScript) == "function" and frame:GetScript("OnHide")
  if existing then return end
  frame:SetScript("OnHide", function()
    if #boardRows() == 0 then
      wipePaint(frame)
    end
  end)
end

local function placeNail(frame, key, point, x, y)
  local nail = frame:CreateTexture(nil, "OVERLAY")
  local n = space("nail", 8)
  nail:SetWidth(n)
  nail:SetHeight(n)
  nail:SetPoint(point, frame, point, x, y)
  if not applyTexture(nail, themeTexture("ornament_nail")) then
    fillRole(nail, "iron")
  end
  tintRole(nail, "iron")
  frame[key] = nail
  return nail
end

local function buildFrame()
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent)
  frame:SetFrameStrata("DIALOG")
  if frame.SetToplevel then frame:SetToplevel(true) end
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  local sm = space("sm", 8)
  local md = space("md", 16)
  local xs = space("xs", 4)
  local lg = space("lg", 24)
  local sealPx = 40
  local footerH = 48
  local ruleH = space("rule", 2)
  local titleH = 52
  local bw, bh = boardExtent()
  frame:SetWidth(bw)
  frame:SetHeight(bh)
  frame:Hide()

  local iron = frame:CreateTexture(nil, "BACKGROUND")
  iron:SetAllPoints(frame)
  fillRole(iron, "charcoal", 0.96)
  frame.Iron = iron

  -- Hairline gold around the sheet; iron rim is the board the nails bite.
  local gold = frame:CreateTexture(nil, "BORDER")
  local goldInset = sm - ruleH
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", goldInset, -goldInset)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -goldInset, goldInset)
  fillRole(gold, "gold")
  frame.GoldEdge = gold

  local titleBand = frame:CreateTexture(nil, "ARTWORK")
  titleBand:SetPoint("TOPLEFT", frame, "TOPLEFT", sm, -sm)
  titleBand:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -sm, -sm)
  titleBand:SetHeight(titleH)
  fillRole(titleBand, "charcoal", 1)
  frame.TitleBand = titleBand

  local footerBand = frame:CreateTexture(nil, "ARTWORK")
  footerBand:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", sm, sm)
  footerBand:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -sm, sm)
  footerBand:SetHeight(footerH)
  fillRole(footerBand, "charcoal", 1)
  frame.FooterBand = footerBand

  -- Sheet on the iron board, held between the title and action bands.
  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", titleBand, "BOTTOMLEFT", 0, 0)
  parchment:SetPoint("BOTTOMRIGHT", footerBand, "TOPRIGHT", 0, 0)
  if not applyTexture(parchment, themeTexture("parchment_decree")) then
    fillRole(parchment, "parchmentMid", 0.94)
  elseif parchment.SetTexCoord then
    pcall(parchment.SetTexCoord, parchment, SURFACE_U0, SURFACE_U1, SURFACE_U0, SURFACE_U1)
  end
  frame.Parchment = parchment

  local seal = frame:CreateTexture(nil, "OVERLAY")
  seal:SetWidth(sealPx)
  seal:SetHeight(sealPx)
  seal:SetPoint("LEFT", titleBand, "LEFT", sm, 0)
  if not applyTexture(seal, themeTexture("seal_papal")) then
    fillRole(seal, "gold")
  end
  frame.Seal = seal

  local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  header:SetPoint("LEFT", seal, "RIGHT", sm, 0)
  applyFont(header, "GameFontNormalHuge", themeFont("display"), 18)
  colorText(header, "gold")
  if header.SetJustifyH then header:SetJustifyH("LEFT") end
  if header.SetWordWrap then header:SetWordWrap(false) end
  header:SetText(HEADER)
  frame.HeaderText = header

  local description = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  description:SetPoint("TOP", parchment, "TOP", 0, -md)
  description:SetPoint("LEFT", parchment, "LEFT", lg, 0)
  description:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  applyFont(description, "GameFontNormal", themeFont("label"), 14)
  colorText(description, "oxblood")
  if description.SetJustifyH then description:SetJustifyH("CENTER") end
  if description.SetWordWrap then description:SetWordWrap(true) end
  if description.SetMaxLines then description:SetMaxLines(2) end
  description:SetText(DESCRIPTION)
  frame.DescriptionText = description

  local list = CreateFrame("Frame", nil, frame)
  list:SetPoint("TOP", description, "BOTTOM", 0, -sm)
  list:SetPoint("LEFT", parchment, "LEFT", lg, 0)
  list:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  list:SetPoint("BOTTOM", parchment, "BOTTOM", 0, sm)
  frame.NightList = list

  local line = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  line:SetPoint("TOPLEFT", list, "TOPLEFT", 0, 0)
  line:SetPoint("BOTTOMRIGHT", list, "BOTTOMRIGHT", 0, 0)
  applyFont(line, "GameFontNormal", themeFont("body"), 12)
  colorText(line, "iron")
  if line.SetJustifyH then line:SetJustifyH("CENTER") end
  if line.SetJustifyV then line:SetJustifyV("MIDDLE") end
  if line.SetWordWrap then line:SetWordWrap(true) end
  if line.SetMaxLines then line:SetMaxLines(3) end
  line:SetText(EMPTY)
  frame.LineText = line

  frame.GoingButtons = {}

  local rule = frame:CreateTexture(nil, "OVERLAY")
  rule:SetHeight(ruleH)
  rule:SetPoint("BOTTOMLEFT", list, "TOPLEFT", md, xs)
  rule:SetPoint("BOTTOMRIGHT", list, "TOPRIGHT", -md, xs)
  fillRole(rule, "gold", 0.9)
  rule:Hide()
  frame.GoldRule = rule

  local flavor = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  flavor:SetPoint("TOP", rule, "BOTTOM", 0, -sm)
  flavor:SetPoint("LEFT", parchment, "LEFT", lg, 0)
  flavor:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  flavor:SetPoint("BOTTOM", parchment, "BOTTOM", 0, sm)
  applyFont(flavor, "GameFontNormal", themeFont("body"), 15)
  colorText(flavor, "iron")
  if flavor.SetJustifyH then flavor:SetJustifyH("CENTER") end
  if flavor.SetJustifyV then flavor:SetJustifyV("TOP") end
  if flavor.SetMaxLines then flavor:SetMaxLines(2) end
  flavor:SetText("")
  flavor:Hide()
  frame.FlavorText = flavor

  local church = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  church:SetPoint("LEFT", footerBand, "LEFT", md, 0)
  applyFont(church, "GameFontHighlight", themeFont("label"), 14)
  colorText(church, "silver")
  if church.SetJustifyH then church:SetJustifyH("LEFT") end
  if church.SetWordWrap then church:SetWordWrap(false) end
  church:SetText(CHURCH_NAME)
  frame.ChurchName = church

  local book
  if COB.Theme and type(COB.Theme.PanelButton) == "function" then
    book = COB.Theme:PanelButton(frame, "YOUR CARD")
  end
  if not book then
    book = CreateFrame("Button", nil, frame)
    labelButton(book, "YOUR CARD", "GameFontNormal", "gold", 14)
  end
  book:SetWidth(152)
  book:SetHeight(32)
  book:SetPoint("RIGHT", footerBand, "RIGHT", -sm, 0)
  book:SetScript("OnClick", function()
    DecreeBanner:Hide()
    local card = COB.PlayerCard
    if card and type(card.Show) == "function" then
      card:Show()
    end
  end)
  frame.BookButton = book

  -- Four corner pins. Close sits inside the title band.
  placeNail(frame, "NailTL", "TOPLEFT", sm, -sm)
  placeNail(frame, "NailTR", "TOPRIGHT", -sm, -sm)
  placeNail(frame, "NailBL", "BOTTOMLEFT", sm, sm)
  placeNail(frame, "NailBR", "BOTTOMRIGHT", -sm, sm)

  local close = COB.Theme:CloseButton(frame, function() DecreeBanner:Hide() end)
  close:SetPoint("RIGHT", titleBand, "RIGHT", -xs, 0)
  frame.CloseButton = close
  header:SetPoint("RIGHT", close, "LEFT", -xs, 0)

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetPoint("TOPLEFT", titleBand, "TOPLEFT", md, 0)
  titleBar:SetPoint("RIGHT", close, "LEFT", -xs, 0)
  titleBar:SetHeight(titleH)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)
  frame.TitleBar = titleBar

  restorePoint(frame)
  rememberSpecial(FRAME_NAME)
  wireDecreeOnHide(frame)
  if type(frame.RegisterEvent) == "function" then
    frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
    frame:RegisterEvent("UI_SCALE_CHANGED")
    if type(frame.SetScript) == "function" then
      frame:SetScript("OnEvent", function()
        restorePoint(frame)
        paint(frame, boardRows())
      end)
    end
  end
  return frame
end

local function ensureFrame()
  if DecreeBanner.frame then
    rememberSpecial(FRAME_NAME)
    wireDecreeOnHide(DecreeBanner.frame)
    return DecreeBanner.frame
  end
  if type(CreateFrame) ~= "function" then return nil end
  DecreeBanner.frame = buildFrame()
  wireDecreeOnHide(DecreeBanner.frame)
  return DecreeBanner.frame
end

function DecreeBanner:ResetForTests()
  if not COB._IN_TEST then return false end
  loginRevealDone = false
  if self.frame then self.frame:Hide() end
  self.frame = nil
  return true
end

function DecreeBanner:Init()
  return ensureFrame()
end

function DecreeBanner:IsShown()
  return self.frame and self.frame:IsShown() and true or false
end

function DecreeBanner:Show()
  local frame = ensureFrame()
  if not frame then return false end
  local rows = boardRows()
  paint(frame, rows)
  markSeen()
  frame:Show()
  return true
end

function DecreeBanner:Hide()
  if self.frame then
    rememberSpecial(FRAME_NAME)
    wireDecreeOnHide(self.frame)
    if #boardRows() == 0 then
      wipePaint(self.frame)
    end
    self.frame:Hide()
  end
  return true
end

function DecreeBanner:GetView()
  local rows = boardRows()
  return {
    shown = self:IsShown(),
    header = HEADER,
    description = DESCRIPTION,
    count = #rows,
  }
end

function DecreeBanner:Refresh()
  local frame = ensureFrame()
  if not frame then return false end
  if not self:IsShown() then return false end
  paint(frame, boardRows())
  return true
end
