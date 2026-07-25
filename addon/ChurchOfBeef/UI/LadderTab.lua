ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Stub panel: Task 8 renders the seven ranks and their occupants here. The view
-- only reads Core -- it never writes standing or rank.
local LadderTab = {}
COB.LadderTab = LadderTab

function LadderTab:OnCreate(panel)
  local text = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  text:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  text:SetJustifyH("LEFT")
  text:SetText("The ladder has not been carved yet.")
  self.text = text
end

function LadderTab:OnRefresh(panel)
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({ name = "ladder", label = "Ladder", owner = LadderTab })
end
