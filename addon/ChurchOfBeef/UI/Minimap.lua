ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- One plain Minimap child button, no LibDBIcon: /beef stays the real entry point.
-- Hover = standing glance (title · standing · next/appointed · petition); left-click = Toggle.
-- No StatusBar on the map (glossary 76 / research 47).
local MinimapButton = {}
COB.Minimap = MinimapButton

local BUTTON_NAME = "ChurchOfBeefMinimapButton"
local DEFAULT_ANGLE = 200
local RADIUS = 80

local HINT_R, HINT_G, HINT_B = 0.8, 0.8, 0.8
local PETITION_R, PETITION_G, PETITION_B = 1.0, 0.82, 0.0

local function minimapDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

local function playerName()
  if type(UnitName) == "function" then
    local name = UnitName("player")
    if type(name) == "string" and name ~= "" then return name end
  end
  return nil
end

local function inGuild()
  if type(IsInGuild) == "function" then
    return IsInGuild() and true or false
  end
  return true
end

local function localPendingSuggestion(name)
  if type(name) ~= "string" or name == "" then return nil end
  if not (COB.Ladder and COB.Ladder.GetSuggestions) then return nil end
  local list = COB.Ladder:GetSuggestions()
  if type(list) ~= "table" then return nil end
  local key = string.lower(name)
  for i = 1, #list do
    local s = list[i]
    if type(s) == "table" and type(s.name) == "string" and string.lower(s.name) == key then
      return s
    end
  end
  return nil
end

-- Short next-line for the glance tip. Same math as StandingTab (point-driven
-- remaining / appointed-only); denser copy for ≤5 tip lines.
local function nextGlanceCopy(rankId, standing)
  local ranks = COB.Ranks
  if not ranks then return nil end

  if not ranks.IsPointDriven(rankId) then
    return "Appointed ranks only"
  end

  local nextId = rankId + 1
  if not ranks.IsPointDriven(nextId) then
    return "Appointed ranks only"
  end

  local need = ranks.Threshold(nextId)
  local title = ranks.Title(nextId)
  if type(need) ~= "number" or type(title) ~= "string" then
    return "Appointed ranks only"
  end
  local remain = need - (standing or 0)
  if remain < 0 then remain = 0 end
  return string.format("%d to %s", remain, title)
end

-- Shared glance payload for minimap (and any later LDB OnTooltipShow).
-- Returns { lines = { { text, r, g, b }, ... }, petitionPending = bool }.
function MinimapButton.StandingGlanceLines()
  local lines = {}
  local petitionPending = false

  lines[#lines + 1] = { text = "Church of Beef" }

  if not inGuild() then
    lines[#lines + 1] = { text = "Not in a guild", r = 1, g = 1, b = 1 }
    lines[#lines + 1] = {
      text = "Left-click: open ladder  ·  /beef",
      r = HINT_R, g = HINT_G, b = HINT_B,
    }
    return { lines = lines, petitionPending = false }
  end

  local name = playerName()
  local record = (name and COB.Ladder and COB.Ladder.GetRecord)
    and COB.Ladder:GetRecord(name) or nil
  local rankId = (record and record.rankId) or 1
  local standing = (record and record.standing) or 0
  if type(standing) ~= "number" then standing = 0 end

  local title = (COB.Ranks and COB.Ranks.Title) and COB.Ranks.Title(rankId) or "Fresh Beef"
  lines[#lines + 1] = {
    text = string.format("%s · %d standing", title, standing),
    r = 1, g = 1, b = 1,
  }

  local nextLine = nextGlanceCopy(rankId, standing)
  if nextLine then
    lines[#lines + 1] = { text = nextLine, r = 1, g = 1, b = 1 }
  end

  if name and localPendingSuggestion(name) then
    petitionPending = true
    lines[#lines + 1] = {
      text = "Petition pending officers",
      r = PETITION_R, g = PETITION_G, b = PETITION_B,
    }
  end

  lines[#lines + 1] = {
    text = "Left-click: open ladder  ·  /beef",
    r = HINT_R, g = HINT_G, b = HINT_B,
  }

  return { lines = lines, petitionPending = petitionPending }
end

-- Prefer COB.UI.StandingGlanceLines when MainFrame already owns COB.UI.
if COB.UI then
  COB.UI.StandingGlanceLines = MinimapButton.StandingGlanceLines
end

local function placeButton(button)
  local db = minimapDb()
  local angle = db and db.minimapAngle
  if type(angle) ~= "number" then angle = DEFAULT_ANGLE end
  local rad = math.rad(angle)
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", math.cos(rad) * RADIUS, math.sin(rad) * RADIUS)
end

local function paintPetitionCue(button, pending)
  if not button or not button.petitionPip then return end
  if pending then
    button.petitionPip:Show()
    if button.border then
      button.border:SetVertexColor(1.0, 0.82, 0.0)
    end
  else
    button.petitionPip:Hide()
    if button.border then
      button.border:SetVertexColor(1, 1, 1)
    end
  end
end

local function fillTooltip(owner)
  if not GameTooltip or not GameTooltip.AddLine then return end
  GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
  GameTooltip:ClearLines()

  local glance = MinimapButton.StandingGlanceLines()
  local rows = glance and glance.lines or {}
  for i = 1, #rows do
    local row = rows[i]
    if row and type(row.text) == "string" then
      if row.r then
        GameTooltip:AddLine(row.text, row.r, row.g, row.b)
      else
        GameTooltip:AddLine(row.text)
      end
    end
  end
  GameTooltip:Show()
  paintPetitionCue(owner, glance and glance.petitionPending)
end

function MinimapButton:Init()
  if self.button then return self.button end
  if type(CreateFrame) ~= "function" or not Minimap then return nil end

  local button = CreateFrame("Button", BUTTON_NAME, Minimap)
  button:SetWidth(31)
  button:SetHeight(31)
  button:SetFrameStrata("MEDIUM")
  button:SetFrameLevel(8)
  -- V1: left = /beef toggle only. No right-click menu (research 47).
  button:RegisterForClicks("LeftButtonUp")

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

  -- Quiet dual-encoded petition cue: corner pip + gold border tint (not hue-only).
  local pip = button:CreateTexture(nil, "OVERLAY")
  pip:SetWidth(6)
  pip:SetHeight(6)
  pip:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2)
  pip:SetTexture("Interface\\Buttons\\WHITE8X8")
  pip:SetVertexColor(PETITION_R, PETITION_G, PETITION_B)
  pip:Hide()
  button.petitionPip = pip

  button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  button:SetScript("OnClick", function(_, mouseButton)
    if mouseButton and mouseButton ~= "LeftButton" then return end
    if COB.UI and COB.UI.Toggle then COB.UI:Toggle() end
  end)

  button:SetScript("OnEnter", function(self)
    fillTooltip(self)
  end)
  button:SetScript("OnLeave", function(self)
    if GameTooltip then GameTooltip:Hide() end
    -- Keep petition cue after leave; refresh from Core on next enter / paint.
    local glance = MinimapButton.StandingGlanceLines()
    paintPetitionCue(self, glance and glance.petitionPending)
  end)

  placeButton(button)
  self.button = button

  local glance = MinimapButton.StandingGlanceLines()
  paintPetitionCue(button, glance and glance.petitionPending)

  local db = minimapDb()
  if db and db.minimapHide then
    button:Hide()
  end
  return button
end

-- Lets a player hide the icon without unloading the addon. /beef always works.
function MinimapButton:SetShown(show)
  local db = minimapDb()
  if db then db.minimapHide = not show end
  if not self.button then return end
  if show then self.button:Show() else self.button:Hide() end
end

function MinimapButton:Refresh()
  if not self.button then return end
  local glance = MinimapButton.StandingGlanceLines()
  paintPetitionCue(self.button, glance and glance.petitionPending)
  if GameTooltip and GameTooltip:IsOwned(self.button) then
    fillTooltip(self.button)
  end
end
