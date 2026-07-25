ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Stub panel: Task 8 shows standing, next threshold, and recent grants here.
local StandingTab = {}
COB.StandingTab = StandingTab

function StandingTab:OnCreate(panel)
  local text = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  text:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  text:SetJustifyH("LEFT")
  text:SetText("Your testimony has not been written down yet.")
  self.text = text
end

function StandingTab:OnRefresh(panel)
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({ name = "standing", label = "My Standing", owner = StandingTab })
end
