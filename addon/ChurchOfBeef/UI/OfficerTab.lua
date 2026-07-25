ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Stub panel: Task 9 adds approve / reject / demote / appoint controls. The tab
-- button is hidden for non-officers; Core/Officer.lua stays the only real gate.
local OfficerTab = {}
COB.OfficerTab = OfficerTab

function OfficerTab:OnCreate(panel)
  local text = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  text:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  text:SetJustifyH("LEFT")
  text:SetText("No judgements are available yet.")
  self.text = text
end

function OfficerTab:OnRefresh(panel)
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({ name = "officer", label = "Officer", officerOnly = true, owner = OfficerTab })
end
