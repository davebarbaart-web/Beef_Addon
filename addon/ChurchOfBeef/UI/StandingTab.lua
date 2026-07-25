ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- My Standing: text thresholds only (glossary 76 / spec §10). No StatusBar hero,
-- no meter-dashboard chrome. Reads Core; never awards points.
local StandingTab = {}
COB.StandingTab = StandingTab

local HISTORY_LINES = 10

local function playerName()
  if type(UnitName) == "function" then
    local name = UnitName("player")
    if type(name) == "string" and name ~= "" then return name end
  end
  return "Player"
end

local function nextThresholdCopy(rankId, standing)
  local ranks = COB.Ranks
  if not ranks then return "—" end

  if not ranks.IsPointDriven(rankId) then
    return "Appointed ranks only"
  end

  local nextId = rankId + 1
  if not ranks.IsPointDriven(nextId) then
    return "Appointed ranks only"
  end

  local need = ranks.Threshold(nextId)
  local title = ranks.Title(nextId)
  if type(need) ~= "number" then
    return "Appointed ranks only"
  end
  local remain = need - (standing or 0)
  if remain < 0 then remain = 0 end
  return string.format("Next: %s at %d standing (%d to go)", title, need, remain)
end

function StandingTab:OnCreate(panel)
  local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  header:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  header:SetJustifyH("LEFT")
  self.header = header

  local standing = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  standing:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
  standing:SetJustifyH("LEFT")
  self.standing = standing

  local nextLine = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  nextLine:SetPoint("TOPLEFT", standing, "BOTTOMLEFT", 0, -6)
  nextLine:SetJustifyH("LEFT")
  self.nextLine = nextLine

  local histLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  histLabel:SetPoint("TOPLEFT", nextLine, "BOTTOMLEFT", 0, -14)
  histLabel:SetText("Recent testimony")
  self.histLabel = histLabel

  self.history = {}
  for i = 1, HISTORY_LINES do
    local line = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    line:SetPoint("TOPLEFT", histLabel, "BOTTOMLEFT", 0, -4 - ((i - 1) * 14))
    line:SetJustifyH("LEFT")
    line:SetText("")
    self.history[i] = line
  end
end

function StandingTab:OnRefresh(panel)
  local name = playerName()
  local record = (COB.Ladder and COB.Ladder.GetRecord) and COB.Ladder:GetRecord(name) or nil
  local rankId = record and record.rankId or 1
  local standing = record and record.standing or 0
  local title = (COB.Ranks and COB.Ranks.Title) and COB.Ranks.Title(rankId) or "Fresh Beef"

  self.header:SetText(string.format("%s — %s", name, title))
  self.standing:SetText(string.format("Standing: %d", standing))
  self.nextLine:SetText(nextThresholdCopy(rankId, standing))

  local hist = (COB.Scoring and COB.Scoring.GetHistory) and COB.Scoring:GetHistory(name) or {}
  for i = 1, HISTORY_LINES do
    local entry = hist[i]
    if entry then
      self.history[i]:SetText(string.format("+%d %s", entry.amount or 0, entry.source or "?"))
    else
      self.history[i]:SetText(i == 1 and "(none yet)" or "")
    end
  end
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({ name = "standing", label = "My Standing", owner = StandingTab })
end
