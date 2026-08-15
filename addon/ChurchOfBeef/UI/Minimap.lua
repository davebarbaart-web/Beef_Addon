ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Quiet Mode: minimap presence + Decree replay (Law 6 / Bible §14.1).
-- No grant pip, no petition cue, no standing glance. Left-click shows the
-- Decree banner when one is active; otherwise Toggle. Drag = move around
-- the ring. Event Mode is not this surface. No StatusBar on the map.
local MinimapButton = {}
COB.Minimap = MinimapButton

local BUTTON_NAME = "ChurchOfBeefMinimapButton"
local DEFAULT_ANGLE = 200
local RADIUS = 80

local HINT_R, HINT_G, HINT_B = 0.8, 0.8, 0.8

local function minimapDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

local function savedAngle()
  local db = minimapDb()
  local angle = db and db.minimapAngle
  if type(angle) ~= "number" then return DEFAULT_ANGLE end
  return angle
end

local function placeButton(button, angle)
  if type(angle) ~= "number" then angle = savedAngle() end
  local rad = math.rad(angle)
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", math.cos(rad) * RADIUS, math.sin(rad) * RADIUS)
end

-- Where the cursor currently sits on the ring, in degrees. GetCursorPosition
-- answers in raw screen units while GetCenter answers in the minimap's own
-- coordinate space, so the cursor has to come through the scale of that same
-- widget — not UIParent's — or a player who has scaled their minimap drags the
-- icon to the wrong spoke. Anything missing (an older client without the call, a
-- minimap the layout engine has not placed yet) returns nil rather than snapping
-- the icon to zero degrees.
local function cursorAngle()
  if type(GetCursorPosition) ~= "function" then return nil end
  if not (Minimap and Minimap.GetCenter) then return nil end

  local centerX, centerY = Minimap:GetCenter()
  if type(centerX) ~= "number" or type(centerY) ~= "number" then return nil end

  local scale = Minimap:GetEffectiveScale()
  if type(scale) ~= "number" or scale <= 0 then scale = 1 end

  local cursorX, cursorY = GetCursorPosition()
  if type(cursorX) ~= "number" or type(cursorY) ~= "number" then return nil end

  return math.deg(math.atan2(cursorY / scale - centerY, cursorX / scale - centerX)) % 360
end

-- Runs only while the button is held. The angle is written straight to the saved
-- variable as it moves so a /reload mid-drag keeps the icon where the player last
-- saw it; the same key is what placeButton reads on the next login.
local function followCursor(button)
  local angle = cursorAngle()
  if type(angle) ~= "number" then return end
  local db = minimapDb()
  if db then db.minimapAngle = angle end
  placeButton(button, angle)
end

local function activeDecree()
  if not (COB.Decree and COB.Decree.Get) then return nil end
  local row = COB.Decree:Get()
  if type(row) ~= "table" or type(row.line) ~= "string" or row.line == "" then
    return nil
  end
  return row
end

-- Presence label only. Not a standing glance, not a petition feed.
-- When a Decree is active the tooltip may name it (Bible §14.1).
local function fillTooltip(owner)
  if not GameTooltip or not GameTooltip.AddLine then return end
  GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine("Church of Beef")
  local decree = activeDecree()
  if decree then
    local header = "A GATHERING HAS BEEN DECREED"
    if COB.DecreeBanner and COB.DecreeBanner.HEADER then
      header = COB.DecreeBanner.HEADER
    end
    GameTooltip:AddLine(header, HINT_R, HINT_G, HINT_B)
    GameTooltip:AddLine(decree.line, HINT_R, HINT_G, HINT_B)
    GameTooltip:AddLine("Left-click: Decree", HINT_R, HINT_G, HINT_B)
  else
    GameTooltip:AddLine("Left-click: /beef", HINT_R, HINT_G, HINT_B)
  end
  GameTooltip:Show()
end

function MinimapButton:Init()
  if COB.DecreeBanner and COB.DecreeBanner.Init then
    COB.DecreeBanner:Init()
  end
  if self.button then return self.button end
  if type(CreateFrame) ~= "function" or not Minimap then return nil end

  local button = CreateFrame("Button", BUTTON_NAME, Minimap)
  button:SetWidth(31)
  button:SetHeight(31)
  button:SetFrameStrata("MEDIUM")
  button:SetFrameLevel(8)
  -- Left = Decree replay when active, else /beef toggle. No right-click menu.
  button:RegisterForClicks("LeftButtonUp")
  -- Drag is registered apart from clicks so the client can tell them apart: a
  -- press that never moves stays a click and still opens the window.
  button:RegisterForDrag("LeftButton")

  local icon = button:CreateTexture(nil, "BACKGROUND")
  icon:SetWidth(20)
  icon:SetHeight(20)
  icon:SetPoint("CENTER", button, "CENTER", 0, 1)
  -- A missing icon renders as the default question mark; it never errors.
  icon:SetTexture("Interface\\Icons\\INV_Misc_Food_15")
  icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
  button.icon = icon

  local border = button:CreateTexture(nil, "OVERLAY")
  border:SetWidth(53)
  border:SetHeight(53)
  border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  button.border = border

  button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  button:SetScript("OnClick", function(_, mouseButton)
    if mouseButton and mouseButton ~= "LeftButton" then return end
    local decree = activeDecree()
    local banner = COB.DecreeBanner
    if decree and banner and banner.Show then
      banner:Show()
      return
    end
    if COB.UI and COB.UI.Toggle then COB.UI:Toggle() end
  end)

  -- The follow script lives exactly as long as the drag does. An icon resting on
  -- the ring must not be running anything per frame, so mouse-up tears it down.
  button:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", followCursor)
  end)
  button:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
    followCursor(self)
  end)

  button:SetScript("OnEnter", function(self)
    fillTooltip(self)
  end)
  button:SetScript("OnLeave", function()
    if GameTooltip then GameTooltip:Hide() end
  end)

  placeButton(button)
  self.button = button

  local db = minimapDb()
  if db and db.minimapHide then
    button:Hide()
  end
  return button
end

-- Lets a player hide the icon without unloading the addon. /beef still opens the
-- window, and /beef minimap is the way back once the button itself is gone.
function MinimapButton:SetShown(show)
  local db = minimapDb()
  if db then db.minimapHide = not show end
  if not self.button then return end
  if show then self.button:Show() else self.button:Hide() end
end

-- The preference outlives the widget: the slash toggle has to answer correctly
-- before UI:Init has built anything, so the saved variable wins where it exists.
function MinimapButton:IsShown()
  local db = minimapDb()
  if db then return not db.minimapHide end
  if self.button then return self.button:IsShown() and true or false end
  return true
end

-- Presence only. Callers (shell refresh) may still invoke this; it never paints
-- a grant or petition cue.
function MinimapButton:Refresh()
  if not self.button then return end
  if GameTooltip and GameTooltip:IsOwned(self.button) then
    fillTooltip(self.button)
  end
end
