ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Quiet first-launch parchment (Bible §19.5). One sheet, then silence.
-- MODE QUIET: no sound, no inbound theater. Close stamps ui.welcomeSeen.
-- Skip (do not stamp) when a Decree is already showing or Runtime ≠ QUIET.
-- Copy is Variant A. Ask and favor stay separate breaths.
local Welcome = { MODE = "QUIET" }
COB.Welcome = Welcome

local FRAME_NAME = "ChurchOfBeefWelcome"
local SHEET_W, SHEET_H = 440, 400
local SURFACE_U0, SURFACE_U1 = 0.12, 0.88

local COPY = {
  title = "Church of Beef",
  what = "Meetup nights and sanctioned duels.",
  tuesday = "Most days: the bull on the minimap, and a notice if one is posted. That is Tuesday.",
  name = "Left-click the bull, or type /beef, to open your name.",
  ask = "When the gathering starts, Ask to fight.",
  favor = "When two names appear on the fight bar, click a name to pick a side.",
  role = "You do not run the show.",
}
Welcome.COPY = COPY

local function themeColor(role)
  local Theme = COB.Theme
  if not (Theme and type(Theme.Color) == "function") then return nil end
  return Theme:Color(role)
end

local function themeFont(role)
  local Theme = COB.Theme
  if not (Theme and type(Theme.FontPath) == "function") then return nil end
  return Theme:FontPath(role)
end

local function themeTexture(name)
  local Theme = COB.Theme
  if not (Theme and type(Theme.Texture) == "function") then return nil end
  return Theme:Texture(name)
end

local function space(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
  if type(sizes) == "table" and type(sizes[key]) == "number" then return sizes[key] end
  return fallback
end

local function fontSize(key, fallback)
  local sizes = COB.Theme and COB.Theme.FontSize
  if type(sizes) == "table" and type(sizes[key]) == "number" then return sizes[key] end
  return fallback
end

local function fillRole(tex, role, alpha)
  if not tex then return end
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, alpha or 1)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, alpha or 1)
  end
end

local function applyInk(fs, role)
  if not fs then return end
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  if fs.SetTextColor then fs:SetTextColor(r, g, b, 1) end
end

local function applyTexture(tex, name)
  if not tex then return false end
  local path = themeTexture(name)
  if type(path) ~= "string" or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  return ok and true or false
end

local function applyFont(fs, template, role, size)
  if not fs then return end
  local path = role and themeFont(role) or nil
  local used = false
  if path and fs.SetFont then
    local ok, applied = pcall(fs.SetFont, fs, path, size or fontSize("body", 12), "")
    used = ok and applied and true or false
  end
  if not used and fs.SetFontObject then
    local font = type(template) == "string" and _G[template] or template
    if font then pcall(fs.SetFontObject, fs, font) end
  end
end

local function plate(frame, layer, role, alpha)
  local tex = frame:CreateTexture(nil, layer or "ARTWORK")
  fillRole(tex, role, alpha or 1)
  return tex
end

local function bodyLine(frame, template, role, size, ink)
  local fs = frame:CreateFontString(nil, "OVERLAY", template)
  applyFont(fs, template, role, size)
  applyInk(fs, ink)
  if fs.SetJustifyH then fs:SetJustifyH("LEFT") end
  if fs.SetJustifyV then fs:SetJustifyV("TOP") end
  if fs.SetWordWrap then fs:SetWordWrap(true) end
  fs:SetText("")
  return fs
end

local function plateButton(parent, text, w, h)
  local btn = CreateFrame("Button", nil, parent)
  btn:SetWidth(w)
  btn:SetHeight(h)
  local bg = btn:CreateTexture(nil, "ARTWORK")
  if bg.SetAllPoints then bg:SetAllPoints(btn) end
  fillRole(bg, "iron", 1)
  btn._cobPlate = bg
  local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  applyFont(fs, "GameFontNormal", "label", 12)
  applyInk(fs, "gold")
  if fs.SetAllPoints then fs:SetAllPoints(btn) end
  if fs.SetJustifyH then fs:SetJustifyH("CENTER") end
  fs:SetText(text)
  if btn.SetFontString then btn:SetFontString(fs) end
  btn:SetText(text)
  return btn
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

local function placeNail(frame, key, point, x, y)
  local nail = frame:CreateTexture(nil, "OVERLAY")
  local n = space("nail", 8)
  nail:SetWidth(n)
  nail:SetHeight(n)
  nail:SetPoint(point, frame, point, x, y)
  if not applyTexture(nail, "ornament_nail") then
    fillRole(nail, "iron")
  else
    local r, g, b = themeColor("iron")
    if type(r) == "number" and nail.SetVertexColor then
      pcall(nail.SetVertexColor, nail, r, g, b, 1)
    end
  end
  frame[key] = nail
  return nail
end

local function hasSeen()
  local db = ChurchOfBeefDB
  if type(db) ~= "table" or type(db.ui) ~= "table" then return false end
  return db.ui.welcomeSeen == true
end

local function markSeen()
  if type(ChurchOfBeefDB) ~= "table" then return end
  if type(ChurchOfBeefDB.ui) ~= "table" then
    ChurchOfBeefDB.ui = {}
  end
  ChurchOfBeefDB.ui.welcomeSeen = true
end

local function decreeIsShowing()
  local banner = COB.DecreeBanner
  if type(banner) ~= "table" or type(banner.IsShown) ~= "function" then
    return false
  end
  local ok, shown = pcall(banner.IsShown, banner)
  return ok and shown == true
end

local function runtimeState()
  local runtime = COB.Runtime
  if type(runtime) ~= "table" or type(runtime.Snapshot) ~= "function" then
    return "QUIET"
  end
  local ok, snap = pcall(runtime.Snapshot, runtime)
  if not ok or type(snap) ~= "table" or type(snap.state) ~= "string" then
    return "QUIET"
  end
  return snap.state
end

local function shouldShow()
  if hasSeen() then return false end
  if decreeIsShowing() then return false end
  if runtimeState() ~= "QUIET" then return false end
  return true
end

local function paint(frame)
  if frame.TitleText then frame.TitleText:SetText(COPY.title) end
  if frame.WhatText then frame.WhatText:SetText(COPY.what) end
  if frame.TuesdayText then frame.TuesdayText:SetText(COPY.tuesday) end
  if frame.NameText then frame.NameText:SetText(COPY.name) end
  if frame.AskText then frame.AskText:SetText(COPY.ask) end
  if frame.FavorText then frame.FavorText:SetText(COPY.favor) end
  if frame.RoleText then frame.RoleText:SetText(COPY.role) end
end

function Welcome:Close()
  markSeen()
  if self.frame then self.frame:Hide() end
  return true
end

local function buildFrame()
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent)
  frame:SetFrameStrata("DIALOG")
  if frame.SetToplevel then frame:SetToplevel(true) end
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:SetWidth(SHEET_W)
  frame:SetHeight(SHEET_H)
  frame:Hide()

  local xs, sm, md = space("xs", 4), space("sm", 8), space("md", 16)
  local lg = space("lg", 24)
  local ruleH = space("rule", 2)
  local bandH = space("band", 48)
  local footerH = space("footer", 40)
  local sealPx = space("seal", 28)

  local iron = plate(frame, "BACKGROUND", "charcoal", 0.96)
  iron:SetAllPoints(frame)
  frame.Iron = iron

  local gold = plate(frame, "BORDER", "gold", 1)
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", ruleH, -ruleH)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -ruleH, ruleH)
  frame.GoldEdge = gold

  local titleBand = plate(frame, "ARTWORK", "charcoal", 1)
  titleBand:SetPoint("TOPLEFT", frame, "TOPLEFT", xs, -xs)
  titleBand:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -xs, -xs)
  titleBand:SetHeight(bandH)
  frame.TitleBand = titleBand

  local footerBand = plate(frame, "ARTWORK", "charcoal", 1)
  footerBand:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", xs, xs)
  footerBand:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -xs, xs)
  footerBand:SetHeight(footerH)
  frame.FooterBand = footerBand

  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", titleBand, "BOTTOMLEFT", 0, 0)
  parchment:SetPoint("BOTTOMRIGHT", footerBand, "TOPRIGHT", 0, 0)
  if applyTexture(parchment, "parchment_decree") then
    if parchment.SetTexCoord then
      pcall(parchment.SetTexCoord, parchment, SURFACE_U0, SURFACE_U1, SURFACE_U0, SURFACE_U1)
    end
  else
    fillRole(parchment, "parchment", 0.94)
  end
  frame.Parchment = parchment

  local seal = frame:CreateTexture(nil, "OVERLAY")
  seal:SetWidth(sealPx)
  seal:SetHeight(sealPx)
  seal:SetPoint("LEFT", titleBand, "LEFT", md, 0)
  applyTexture(seal, "seal_papal_small")
  frame.Seal = seal

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  applyFont(title, "GameFontNormalHuge", "display", 18)
  applyInk(title, "gold")
  if title.SetJustifyH then title:SetJustifyH("LEFT") end
  if title.SetWordWrap then title:SetWordWrap(false) end
  title:SetText(COPY.title)
  title:SetPoint("LEFT", seal, "RIGHT", sm, 0)
  frame.TitleText = title

  local close = COB.Theme:CloseButton(frame, function() Welcome:Close() end)
  close:SetPoint("RIGHT", titleBand, "RIGHT", -sm, 0)
  frame.CloseButton = close
  title:SetPoint("RIGHT", close, "LEFT", -sm, 0)

  local what = bodyLine(frame, "GameFontNormal", "body", fontSize("body", 12), "charcoal")
  what:SetPoint("TOPLEFT", parchment, "TOPLEFT", lg, -md)
  what:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  frame.WhatText = what

  local tuesday = bodyLine(frame, "GameFontNormal", "body", fontSize("body", 12), "charcoal")
  tuesday:SetPoint("TOPLEFT", what, "BOTTOMLEFT", 0, -sm)
  tuesday:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  frame.TuesdayText = tuesday

  local name = bodyLine(frame, "GameFontNormal", "body", fontSize("body", 12), "charcoal")
  name:SetPoint("TOPLEFT", tuesday, "BOTTOMLEFT", 0, -sm)
  name:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  frame.NameText = name

  local ask = bodyLine(frame, "GameFontNormal", "body", fontSize("body", 12), "charcoal")
  ask:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -md)
  ask:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  frame.AskText = ask

  local favor = bodyLine(frame, "GameFontNormal", "body", fontSize("body", 12), "charcoal")
  favor:SetPoint("TOPLEFT", ask, "BOTTOMLEFT", 0, -md)
  favor:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  frame.FavorText = favor

  local role = bodyLine(frame, "GameFontNormal", "body", fontSize("body", 12), "iron")
  role:SetPoint("TOPLEFT", favor, "BOTTOMLEFT", 0, -md)
  role:SetPoint("RIGHT", parchment, "RIGHT", -lg, 0)
  frame.RoleText = role

  placeNail(frame, "NailTL", "TOPLEFT", sm, -sm)
  placeNail(frame, "NailTR", "TOPRIGHT", -sm, -sm)
  placeNail(frame, "NailBL", "BOTTOMLEFT", sm, sm)
  placeNail(frame, "NailBR", "BOTTOMRIGHT", -sm, sm)

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetPoint("TOPLEFT", titleBand, "TOPLEFT", 0, 0)
  titleBar:SetPoint("BOTTOMRIGHT", titleBand, "BOTTOMRIGHT", -(56 + md), 0)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
  frame.TitleBar = titleBar

  frame:ClearAllPoints()
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  rememberSpecial(FRAME_NAME)
  paint(frame)
  return frame
end

local function ensureFrame()
  if Welcome.frame then
    rememberSpecial(FRAME_NAME)
    return Welcome.frame
  end
  if type(CreateFrame) ~= "function" then return nil end
  Welcome.frame = buildFrame()
  return Welcome.frame
end

function Welcome:Init()
  if not shouldShow() then
    if self.frame then self.frame:Hide() end
    return self.frame
  end
  local frame = ensureFrame()
  if not frame then return nil end
  paint(frame)
  frame:Show()
  return frame
end

function Welcome:IsShown()
  return self.frame ~= nil and self.frame:IsShown() == true
end

function Welcome:ResetForTests()
  if not COB._IN_TEST then return false end
  if self.frame then self.frame:Hide() end
  self.frame = nil
  return true
end
