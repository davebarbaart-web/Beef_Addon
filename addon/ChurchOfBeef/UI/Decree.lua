ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Quiet Mode parchment banner (Bible §14.1 / Law 6 / Law 10). The one Quiet
-- feature beyond minimap presence. Header is UI copy, not a stored field.
-- Shown once per login; thereafter reachable from the minimap. No sound.
-- No scheduling suite, attendance reply, deputy, Console, HUD, or Records host.
local HEADER = "A GATHERING HAS BEEN DECREED"

local DecreeBanner = {
  MODE = "QUIET",
  HEADER = HEADER,
}
COB.DecreeBanner = DecreeBanner

local FRAME_NAME = "ChurchOfBeefDecree"
local TITLE_FONT = "Interface\\AddOns\\ChurchOfBeef\\Media\\DecreeTitle.ttf"
local SEAL_TEXTURE = "Interface\\AddOns\\ChurchOfBeef\\Media\\decree-seal"
local PARCHMENT_TEXTURE = "Interface\\AddOns\\ChurchOfBeef\\Media\\decree-parchment"
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

local function fill(tex, r, g, b, a)
  if not tex then return end
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, a)
  else
    tex:SetTexture("Interface\\Buttons\\WHITE8X8")
    if tex.SetVertexColor then tex:SetVertexColor(r, g, b, a) end
  end
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
  applyFont(fs, template or "GameFontNormal")
  if button.SetFontString then button:SetFontString(fs) end
  if fs.SetTextColor then fs:SetTextColor(0.45, 0.32, 0.12, 1) end
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

local function buildFrame()
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent)
  frame:SetFrameStrata("DIALOG")
  if frame.SetToplevel then frame:SetToplevel(true) end
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:SetWidth(520)
  frame:SetHeight(188)
  frame:Hide()

  local iron = frame:CreateTexture(nil, "BACKGROUND")
  iron:SetAllPoints(frame)
  fill(iron, 0.08, 0.07, 0.06, 0.96)
  frame.Iron = iron

  local gold = frame:CreateTexture(nil, "BORDER")
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
  fill(gold, 0.72, 0.62, 0.38, 1)
  frame.GoldEdge = gold

  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
  parchment:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
  if parchment.SetTexture then parchment:SetTexture(PARCHMENT_TEXTURE) end
  fill(parchment, 0.78, 0.70, 0.52, 0.94)
  frame.Parchment = parchment

  local seal = frame:CreateTexture(nil, "OVERLAY")
  seal:SetTexture(SEAL_TEXTURE)
  seal:SetWidth(28)
  seal:SetHeight(28)
  seal:SetPoint("BOTTOM", frame, "BOTTOM", 0, 16)
  frame.Seal = seal

  local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  header:SetPoint("TOP", frame, "TOP", 0, -28)
  applyFont(header, "GameFontNormalHuge", TITLE_FONT, 18)
  if header.SetTextColor then header:SetTextColor(0.45, 0.32, 0.12, 1) end
  if header.SetJustifyH then header:SetJustifyH("CENTER") end
  header:SetText(HEADER)
  frame.HeaderText = header

  local line = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  line:SetPoint("TOP", header, "BOTTOM", 0, -16)
  line:SetPoint("LEFT", frame, "LEFT", 36, 0)
  line:SetPoint("RIGHT", frame, "RIGHT", -36, 0)
  applyFont(line, "GameFontNormalLarge")
  if line.SetTextColor then line:SetTextColor(0.18, 0.12, 0.08, 1) end
  if line.SetJustifyH then line:SetJustifyH("CENTER") end
  line:SetText("")
  frame.LineText = line

  local flavor = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  flavor:SetPoint("TOP", line, "BOTTOM", 0, -12)
  flavor:SetPoint("LEFT", frame, "LEFT", 36, 0)
  flavor:SetPoint("RIGHT", frame, "RIGHT", -36, 0)
  applyFont(flavor, "GameFontNormal")
  if flavor.SetTextColor then flavor:SetTextColor(0.32, 0.24, 0.14, 1) end
  if flavor.SetJustifyH then flavor:SetJustifyH("CENTER") end
  flavor:SetText("")
  flavor:Hide()
  frame.FlavorText = flavor

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -4)
  titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -36, -4)
  titleBar:SetHeight(28)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)
  frame.TitleBar = titleBar

  local close = CreateFrame("Button", nil, frame)
  close:SetWidth(24)
  close:SetHeight(24)
  close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
  labelButton(close, "Close")
  close:SetScript("OnClick", function() DecreeBanner:Hide() end)
  frame.CloseButton = close

  restorePoint(frame)
  rememberSpecial(FRAME_NAME)
  return frame
end

local function ensureFrame()
  if DecreeBanner.frame then return DecreeBanner.frame end
  if type(CreateFrame) ~= "function" then return nil end
  DecreeBanner.frame = buildFrame()
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
    if self.frame then self.frame:Hide() end
    return false
  end
  local frame = ensureFrame()
  if not frame then return false end
  paint(frame, decree)
  frame:Show()
  return true
end

function DecreeBanner:Hide()
  if self.frame then self.frame:Hide() end
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
