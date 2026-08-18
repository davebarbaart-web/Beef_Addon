ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Quiet Mode parchment banner (Bible §14.1 / Law 6 / Law 10). The one Quiet
-- feature beyond minimap presence. Header is UI copy, not a stored field.
-- The decree line is the visual headline (blackletter via Theme display);
-- church name is small by the seal (Theme label). Shown once per login;
-- thereafter reachable from the minimap. No sound.
-- Colors, fonts, and textures resolve through COB.Theme. No scheduling
-- suite, attendance reply, deputy, Console, HUD, or Records host.
local HEADER = "A GATHERING HAS BEEN DECREED"
local CHURCH_NAME = "Church of Beef"

local DecreeBanner = {
  MODE = "QUIET",
  HEADER = HEADER,
}
COB.DecreeBanner = DecreeBanner

local FRAME_NAME = "ChurchOfBeefDecree"
local TOP_INSET = -72

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

local loginRevealDone = false

local function getDecree()
  if not (COB.Decree and COB.Decree.Get) then return nil end
  local row = COB.Decree:Get()
  if type(row) ~= "table" or type(row.line) ~= "string" or row.line == "" then
    return nil
  end
  return row
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

local function labelButton(button, text, template)
  if not button then return end
  local fs = button:CreateFontString(nil, "OVERLAY", template or "GameFontNormal")
  applyFont(fs, template or "GameFontNormal", themeFont("label"), themeSize("caption"))
  if button.SetFontString then button:SetFontString(fs) end
  colorText(fs, "iron")
  button:SetText(text)
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

local function paint(frame, decree)
  if frame.HeaderText and frame.HeaderText.SetText then
    frame.HeaderText:SetText(HEADER)
  end
  if frame.LineText and frame.LineText.SetText then
    frame.LineText:SetText(decree.line)
  end
  local flavor = decree.flavor
  if type(flavor) ~= "string" then flavor = "" end
  if frame.FlavorText then
    if frame.FlavorText.SetText then frame.FlavorText:SetText(flavor) end
    if flavor ~= "" then
      frame.FlavorText:Show()
    else
      frame.FlavorText:Hide()
    end
  end
end

local function wipePaint(frame)
  if not frame then return end
  if frame.LineText and frame.LineText.SetText then
    frame.LineText:SetText("")
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
    if not getDecree() then
      wipePaint(frame)
    end
  end)
end

local function placeNail(frame, key, point, x, y)
  local nail = frame:CreateTexture(nil, "OVERLAY")
  nail:SetWidth(10)
  nail:SetHeight(10)
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
  frame:SetWidth(320)
  frame:SetHeight(148)
  frame:Hide()

  local iron = frame:CreateTexture(nil, "BACKGROUND")
  iron:SetAllPoints(frame)
  fillRole(iron, "charcoal", 0.96)
  frame.Iron = iron

  local gold = frame:CreateTexture(nil, "BORDER")
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
  fillRole(gold, "gold")
  frame.GoldEdge = gold

  -- parchment_decree is the nailed/curled body (curl lives in the texture).
  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
  parchment:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
  if not applyTexture(parchment, themeTexture("parchment_decree")) then
    fillRole(parchment, "parchmentMid", 0.94)
  end
  frame.Parchment = parchment

  local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  header:SetPoint("TOP", frame, "TOP", 0, -10)
  header:SetPoint("LEFT", frame, "LEFT", 16, 0)
  header:SetPoint("RIGHT", frame, "RIGHT", -32, 0)
  applyFont(header, "GameFontNormalSmall", themeFont("label"), themeSize("caption"))
  colorText(header, "gold")
  if header.SetJustifyH then header:SetJustifyH("CENTER") end
  header:SetText(HEADER)
  frame.HeaderText = header

  local line = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  line:SetPoint("TOP", header, "BOTTOM", 0, -4)
  line:SetPoint("LEFT", frame, "LEFT", 16, 0)
  line:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
  applyFont(line, "GameFontNormalHuge", themeFont("display"), themeSize("headline"))
  colorText(line, "charcoal")
  if line.SetJustifyH then line:SetJustifyH("CENTER") end
  line:SetText("")
  frame.LineText = line

  local rule = frame:CreateTexture(nil, "OVERLAY")
  rule:SetHeight(1)
  rule:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 12, -5)
  rule:SetPoint("TOPRIGHT", line, "BOTTOMRIGHT", -12, -5)
  fillRole(rule, "gold", 0.9)
  frame.GoldRule = rule

  local flavor = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  flavor:SetPoint("TOP", rule, "BOTTOM", 0, -6)
  flavor:SetPoint("LEFT", frame, "LEFT", 16, 0)
  flavor:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
  applyFont(flavor, "GameFontNormal", themeFont("body"), themeSize("body"))
  colorText(flavor, "iron")
  if flavor.SetJustifyH then flavor:SetJustifyH("CENTER") end
  flavor:SetText("")
  flavor:Hide()
  frame.FlavorText = flavor

  local seal = frame:CreateTexture(nil, "OVERLAY")
  seal:SetWidth(22)
  seal:SetHeight(22)
  seal:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 12, 10)
  if not applyTexture(seal, themeTexture("seal_papal")) then
    fillRole(seal, "gold")
  end
  tintRole(seal, "gold")
  frame.Seal = seal

  local church = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  church:SetPoint("LEFT", seal, "RIGHT", 4, 0)
  applyFont(church, "GameFontHighlightSmall", themeFont("label"), themeSize("caption"))
  colorText(church, "gold")
  if church.SetJustifyH then church:SetJustifyH("LEFT") end
  church:SetText(CHURCH_NAME)
  frame.ChurchName = church

  -- Iron nail studs: nailed-to-the-board corners. TOPRIGHT sits clear of Close.
  placeNail(frame, "NailTL", "TOPLEFT", 6, -6)
  placeNail(frame, "NailTR", "TOPRIGHT", -28, -6)
  placeNail(frame, "NailBL", "BOTTOMLEFT", 6, 6)
  placeNail(frame, "NailBR", "BOTTOMRIGHT", -6, 6)

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -4)
  titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -28, -4)
  titleBar:SetHeight(22)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)
  frame.TitleBar = titleBar

  local close = CreateFrame("Button", nil, frame)
  close:SetWidth(20)
  close:SetHeight(20)
  close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
  labelButton(close, "Close")
  close:SetScript("OnClick", function() DecreeBanner:Hide() end)
  frame.CloseButton = close

  restorePoint(frame)
  rememberSpecial(FRAME_NAME)
  wireDecreeOnHide(frame)
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
  local frame = ensureFrame()
  if not loginRevealDone then
    loginRevealDone = true
    if getDecree() then
      self:Show()
    end
  end
  return frame
end

function DecreeBanner:IsShown()
  return self.frame and self.frame:IsShown() and true or false
end

function DecreeBanner:Show()
  local decree = getDecree()
  if not decree then
    local frame = ensureFrame()
    if frame then
      wipePaint(frame)
      frame:Hide()
    end
    return false
  end
  local frame = ensureFrame()
  if not frame then return false end
  paint(frame, decree)
  frame:Show()
  return true
end

function DecreeBanner:Hide()
  if self.frame then
    rememberSpecial(FRAME_NAME)
    wireDecreeOnHide(self.frame)
    if not getDecree() then
      wipePaint(self.frame)
    end
    self.frame:Hide()
  end
  return true
end

function DecreeBanner:GetView()
  local decree = getDecree()
  return {
    shown = self:IsShown(),
    header = HEADER,
    line = decree and decree.line or nil,
    flavor = decree and decree.flavor or nil,
  }
end

function DecreeBanner:Refresh()
  local frame = ensureFrame()
  if not frame then return false end
  local decree = getDecree()
  if not decree then
    wipePaint(frame)
    frame:Hide()
    return false
  end
  if self:IsShown() then
    paint(frame, decree)
    return true
  end
  return false
end
