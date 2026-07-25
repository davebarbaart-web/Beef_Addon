ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Ladder view: seven rank bands from Data/Ranks.lua + occupants from Core.
-- UI never awards points or invents titles. Fixed Lua row pool (glossary 69).
local LadderTab = {}
COB.LadderTab = LadderTab

local ROW_HEIGHT = 28
local RANK_COUNT = 7

local function playerName()
  if type(UnitName) == "function" then
    local name = UnitName("player")
    if type(name) == "string" and name ~= "" then return name end
  end
  return nil
end

local function occupantsForRank(view, rankId)
  local names = {}
  for i = 1, #view do
    local rec = view[i]
    if rec.rankId == rankId then
      names[#names + 1] = rec.name
    end
  end
  table.sort(names)
  return names
end

local function formatOccupants(names, selfName)
  if #names == 0 then return "—" end
  local parts = {}
  for i = 1, #names do
    local n = names[i]
    if selfName and n == selfName then
      parts[#parts + 1] = n .. " (You)"
    else
      parts[#parts + 1] = n
    end
  end
  return table.concat(parts, ", ")
end

function LadderTab:OnCreate(panel)
  local empty = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  empty:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  empty:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, -4)
  empty:SetJustifyH("LEFT")
  empty:SetText("You are outside the flock. Join a guild to earn standing.")
  empty:Hide()
  self.empty = empty

  self.rows = {}
  for i = 1, RANK_COUNT do
    local row = CreateFrame("Frame", nil, panel)
    row:SetHeight(ROW_HEIGHT)
    row:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -((i - 1) * ROW_HEIGHT))
    row:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -((i - 1) * ROW_HEIGHT))

    local title = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", row, "TOPLEFT", 4, -2)
    title:SetJustifyH("LEFT")

    local occupants = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    occupants:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -1)
    occupants:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    occupants:SetJustifyH("LEFT")

    self.rows[i] = { frame = row, title = title, occupants = occupants }
  end
end

function LadderTab:OnRefresh(panel)
  local inGuild = true
  if type(IsInGuild) == "function" then
    inGuild = IsInGuild() and true or false
  end

  if not inGuild then
    self.empty:Show()
    self.empty:SetText("You are outside the flock. Join a guild to earn standing.")
    for i = 1, RANK_COUNT do self.rows[i].frame:Hide() end
    return
  end

  self.empty:Hide()

  local view = (COB.Ladder and COB.Ladder.GetLadderView) and COB.Ladder:GetLadderView() or {}
  local selfName = playerName()
  local list = COB.Ranks and COB.Ranks.List or {}

  -- Display high → low (Prophet at top).
  for i = 1, RANK_COUNT do
    local rank = list[RANK_COUNT - i + 1]
    local row = self.rows[i]
    if not rank then
      row.frame:Hide()
    else
      row.frame:Show()
      local names = occupantsForRank(view, rank.id)
      local line = formatOccupants(names, selfName)
      -- Dual-encode self: "(You)" in occupants + gold title text only
      -- (class/gold on names — not chrome paint; glossary 81).
      if selfName and line:find("(You)", 1, true) then
        row.title:SetText("|cffffd100" .. rank.title .. "|r")
      else
        row.title:SetText(rank.title)
      end
      row.occupants:SetText(line)
    end
  end
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({ name = "ladder", label = "Ladder", owner = LadderTab })
end
