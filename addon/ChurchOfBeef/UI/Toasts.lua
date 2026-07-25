ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Private edge toast. Displays Core outcomes only — never grants standing,
-- never guild-chats. Silent (glossary 79). No custom Media.
local Toasts = {}
COB.Toasts = Toasts

local HOLD_SECONDS = 3.5
local FADE_IN = 0.15
local FADE_OUT = 0.22
local MAX_QUEUE = 5

local queue = {}

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

local function tryBackdrop(frame)
  if frame.SetBackdrop then
    frame:SetBackdrop({
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true,
      tileSize = 16,
      edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    if frame.SetBackdropColor then
      frame:SetBackdropColor(0, 0, 0, 0.85)
    end
    if frame.SetBackdropBorderColor then
      frame:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
    end
    return true
  end
  return false
end

function Toasts:Init()
  if self.frame then return self.frame end
  if type(CreateFrame) ~= "function" then return nil end

  -- Prefer BackdropTemplate when the client exposes it; fall back to plain Frame.
  local frame = CreateFrame("Frame", "ChurchOfBeefToast", UIParent, "BackdropTemplate")
  if not frame then
    frame = CreateFrame("Frame", "ChurchOfBeefToast", UIParent)
  end
  frame:SetWidth(360)
  frame:SetHeight(40)
  frame:SetPoint("TOP", UIParent, "TOP", 0, -160)
  frame:SetFrameStrata("HIGH")
  frame:Hide()
  if frame.SetAlpha then frame:SetAlpha(1) end

  if not tryBackdrop(frame) then
    -- Fail-soft: solid stock texture path only if Backdrop unavailable.
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(frame)
    bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    if bg.SetVertexColor then bg:SetVertexColor(0, 0, 0, 0.85) end
  end

  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  text:SetPoint("CENTER", frame, "CENTER", 0, 0)
  text:SetWidth(340)
  text:SetJustifyH("CENTER")
  frame.text = text

  self.frame = frame
  return frame
end

local function fadeOutThen(self, done)
  local frame = self.frame
  -- Desktop harness: skip multi-step alpha so one timer flush advances the queue.
  if COB._IN_TEST or not (frame and frame.SetAlpha) then
    if frame then frame:Hide() end
    done()
    return
  end
  local steps = 4
  local i = 0
  local function step()
    i = i + 1
    frame:SetAlpha(1 - (i / steps))
    if i < steps then
      after(FADE_OUT / steps, step)
    else
      frame:Hide()
      frame:SetAlpha(1)
      done()
    end
  end
  step()
end

local function fadeIn(self)
  local frame = self.frame
  if COB._IN_TEST or not (frame and frame.SetAlpha) then return end
  frame:SetAlpha(0)
  local steps = 3
  local i = 0
  local function step()
    i = i + 1
    frame:SetAlpha(i / steps)
    if i < steps then after(FADE_IN / steps, step) end
  end
  step()
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
  fadeIn(self)
  after(HOLD_SECONDS, function()
    fadeOutThen(self, function() pump(self) end)
  end)
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
  if self.frame then
    if self.frame.SetAlpha then self.frame:SetAlpha(1) end
    self.frame:Hide()
  end
end
