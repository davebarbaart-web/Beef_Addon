ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Transient outcome banner. Toasts only display what Core already decided; they
-- never grant standing or announce to guild chat.
local Toasts = {}
COB.Toasts = Toasts

local DISPLAY_SECONDS = 4
local MAX_QUEUE = 5

local queue = {}

-- One-shot delay. C_Timer exists on TBC Anniversary; the OnUpdate fallback
-- unhooks itself so nothing polls while idle.
local function after(seconds, fn)
  if C_Timer and C_Timer.After then
    C_Timer.After(seconds, fn)
    return
  end
  local ticker = CreateFrame("Frame")
  local elapsed = 0
  ticker:SetScript("OnUpdate", function(self, delta)
    elapsed = elapsed + (delta or 0)
    if elapsed >= seconds then
      self:SetScript("OnUpdate", nil)
      fn()
    end
  end)
end

local function paint(texture, r, g, b, a)
  if texture.SetColorTexture then
    texture:SetColorTexture(r, g, b, a)
  else
    texture:SetTexture(r, g, b, a)
  end
end

function Toasts:Init()
  if self.frame then return self.frame end
  if type(CreateFrame) ~= "function" then return nil end

  local frame = CreateFrame("Frame", "ChurchOfBeefToast", UIParent)
  frame:SetWidth(360)
  frame:SetHeight(40)
  frame:SetPoint("TOP", UIParent, "TOP", 0, -160)
  frame:SetFrameStrata("HIGH")
  frame:Hide()

  local bg = frame:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(frame)
  paint(bg, 0.04, 0.03, 0.02, 0.85)

  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  text:SetPoint("CENTER", frame, "CENTER", 0, 0)
  text:SetWidth(340)
  text:SetJustifyH("CENTER")
  frame.text = text

  self.frame = frame
  return frame
end

local function pump(self)
  local nextText = table.remove(queue, 1)
  if not nextText then
    self.showing = false
    if self.frame then self.frame:Hide() end
    return
  end
  self.showing = true
  self.frame.text:SetText(nextText)
  self.frame:Show()
  after(DISPLAY_SECONDS, function() pump(self) end)
end

function Toasts:Show(text)
  if type(text) ~= "string" or text == "" then return false end
  if not self:Init() then return false end
  if #queue >= MAX_QUEUE then return false end

  queue[#queue + 1] = text
  if not self.showing then
    pump(self)
  end
  return true
end

function Toasts:HideAll()
  for i = #queue, 1, -1 do queue[i] = nil end
  self.showing = false
  if self.frame then self.frame:Hide() end
end
