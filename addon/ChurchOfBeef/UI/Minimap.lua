ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- One plain Minimap child button, no LibDBIcon: /beef stays the real entry point.
local MinimapButton = {}
COB.Minimap = MinimapButton

local BUTTON_NAME = "ChurchOfBeefMinimapButton"
local DEFAULT_ANGLE = 200
local RADIUS = 80

local function minimapDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

local function placeButton(button)
  local db = minimapDb()
  local angle = db and db.minimapAngle
  if type(angle) ~= "number" then angle = DEFAULT_ANGLE end
  local rad = math.rad(angle)
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", math.cos(rad) * RADIUS, math.sin(rad) * RADIUS)
end

function MinimapButton:Init()
  if self.button then return self.button end
  if type(CreateFrame) ~= "function" or not Minimap then return nil end

  local button = CreateFrame("Button", BUTTON_NAME, Minimap)
  button:SetWidth(31)
  button:SetHeight(31)
  button:SetFrameStrata("MEDIUM")
  button:SetFrameLevel(8)
  button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

  local icon = button:CreateTexture(nil, "BACKGROUND")
  icon:SetWidth(20)
  icon:SetHeight(20)
  icon:SetPoint("CENTER", button, "CENTER", 0, 1)
  -- A missing icon renders as the default question mark; it never errors.
  icon:SetTexture("Interface\\Icons\\INV_Misc_Food_15")
  icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

  local border = button:CreateTexture(nil, "OVERLAY")
  border:SetWidth(53)
  border:SetHeight(53)
  border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

  button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  button:SetScript("OnClick", function()
    if COB.UI and COB.UI.Toggle then COB.UI:Toggle() end
  end)

  button:SetScript("OnEnter", function(self)
    if not GameTooltip then return end
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Church of Beef")
    GameTooltip:AddLine("Click to open the ladder. /beef works too.", 1, 1, 1)
    GameTooltip:Show()
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

-- Lets a player hide the icon without unloading the addon.
function MinimapButton:SetShown(show)
  local db = minimapDb()
  if db then db.minimapHide = not show end
  if not self.button then return end
  if show then self.button:Show() else self.button:Hide() end
end
