ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Ladder view: seven titled bands from Data/Ranks.lua + occupants from Core.
-- UI never awards points or invents titles. Fixed Lua row pool (glossary 69).
-- No search / sort sprawl in V1 — institutional order 7→1 only.
local LadderTab = {}
COB.LadderTab = LadderTab

local RANK_COUNT = 7
local BAND_HEIGHT = 36
local OCCUPANT_MAX = 72
-- Dual-encode self: word "You" + gold tint (glossary 81 / color track 18).
local YOU_GOLD = "|cffffd100"
local YOU_RESET = "|r"

local function playerName()
  if type(UnitName) == "function" then
    local name = UnitName("player")
    if type(name) == "string" and name ~= "" then return name end
  end
  return nil
end

local function nameKey(name)
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", ""):lower()
  if name == "" then return nil end
  return name:match("^([^%-]+)") or name
end

-- Runtime class tint for names only (UI brief). Fail soft off-client / no roster.
local function classColorCode(name)
  if type(GetNumGuildMembers) ~= "function" or type(GetGuildRosterInfo) ~= "function" then
    return nil
  end
  local wanted = nameKey(name)
  if not wanted then return nil end
  local count = GetNumGuildMembers()
  if type(count) ~= "number" then return nil end

  for i = 1, count do
    local rosterName, _, _, _, _, _, _, _, _, _, classFile = GetGuildRosterInfo(i)
    if type(rosterName) == "string" and nameKey(rosterName) == wanted then
      local r, g, b
      if type(GetClassColor) == "function" and type(classFile) == "string" then
        r, g, b = GetClassColor(classFile)
      elseif type(RAID_CLASS_COLORS) == "table" and type(classFile) == "string" then
        local c = RAID_CLASS_COLORS[classFile]
        if c then r, g, b = c.r, c.g, c.b end
      end
      if type(r) == "number" and type(g) == "number" and type(b) == "number" then
        return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
      end
      return nil
    end
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

local function formatName(name, selfName)
  local isSelf = selfName and name == selfName
  local color = classColorCode(name)
  local body = name
  if isSelf then
    body = name .. " (You)"
    -- Self wins over class tint so the You marker stays stream-readable.
    return YOU_GOLD .. body .. YOU_RESET
  end
  if color then
    return color .. body .. "|r"
  end
  return body
end

local function formatOccupants(names, selfName)
  if #names == 0 then return "—", nil end
  local parts = {}
  for i = 1, #names do
    parts[#parts + 1] = formatName(names[i], selfName)
  end
  local full = table.concat(parts, ", ")
  if #full <= OCCUPANT_MAX then
    return full, nil
  end
  -- Truncate for scan; full list stays on tooltip (track 57 overflow).
  local short = full:sub(1, OCCUPANT_MAX - 1) .. "…"
  return short, full
end

local function seatCapacity(rank)
  local ranks = COB.Ranks
  if not ranks or not rank then return nil end
  if rank.kind == "council" and type(ranks.CouncilSeats) == "number" then
    return ranks.CouncilSeats
  end
  if rank.kind == "prophet" and ranks.ProphetUnique then
    return 1
  end
  return nil
end

local function vacancyCopy(taken, maxSeats)
  if type(maxSeats) ~= "number" then return nil end
  local open = maxSeats - (taken or 0)
  if open <= 0 then return nil end
  if maxSeats == 1 then
    return "— seat open —"
  end
  if open == 1 then
    return "— 1 seat open —"
  end
  return string.format("— %d seats open —", open)
end

local BANNER_HEIGHT = 34

local function layoutRows(self, panel, yOffset)
  for i = 1, RANK_COUNT do
    local row = self.rows[i]
    row.frame:ClearAllPoints()
    row.frame:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -(yOffset + (i - 1) * BAND_HEIGHT))
    row.frame:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -(yOffset + (i - 1) * BAND_HEIGHT))
  end
end

function LadderTab:OnCreate(panel)
  local empty = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  empty:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  empty:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, -4)
  empty:SetJustifyH("LEFT")
  empty:SetText("You are outside the flock. Join a guild to earn standing.")
  empty:Hide()
  self.empty = empty

  -- L1 learning banner for settled empty mesh (no_peers); never shown while syncing.
  local banner = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  banner:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -2)
  banner:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, -2)
  banner:SetJustifyH("LEFT")
  banner:SetText("")
  banner:Hide()
  self.banner = banner

  self.rows = {}
  for i = 1, RANK_COUNT do
    local row = CreateFrame("Frame", nil, panel)
    row:SetHeight(BAND_HEIGHT)
    row:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -((i - 1) * BAND_HEIGHT))
    row:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -((i - 1) * BAND_HEIGHT))

    -- Title hierarchy: large title left, seat fraction small right (council/prophet).
    local title = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", row, "TOPLEFT", 4, -2)
    title:SetJustifyH("LEFT")

    local seats = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    seats:SetPoint("TOPRIGHT", row, "TOPRIGHT", -4, -4)
    seats:SetJustifyH("RIGHT")
    seats:SetText("")

    local occupants = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    occupants:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 8, -1)
    occupants:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    occupants:SetJustifyH("LEFT")

    -- Hit target for truncated occupant tooltip (no search box).
    local tip = CreateFrame("Frame", nil, row)
    tip:SetPoint("TOPLEFT", occupants, "TOPLEFT", 0, 2)
    tip:SetPoint("BOTTOMRIGHT", occupants, "BOTTOMRIGHT", 0, -2)
    tip:EnableMouse(true)
    tip:SetScript("OnEnter", function(frame)
      if not frame.fullText then return end
      if type(GameTooltip) ~= "table" then return end
      GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
      GameTooltip:SetText(frame.fullText, nil, nil, nil, nil, true)
      GameTooltip:Show()
    end)
    tip:SetScript("OnLeave", function()
      if type(GameTooltip) == "table" and GameTooltip.Hide then GameTooltip:Hide() end
    end)

    self.rows[i] = {
      frame = row,
      title = title,
      seats = seats,
      occupants = occupants,
      tip = tip,
    }
  end

  local footer = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  footer:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 4, 2)
  footer:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -4, 2)
  footer:SetJustifyH("LEFT")
  footer:SetText("")
  self.footer = footer
end

function LadderTab:OnRefresh(panel)
  local status = COB.UI and COB.UI.Status
  local hardGate = status and status.ShowsHardGateBanner and status:ShowsHardGateBanner()
  local learning = status and status.ShowsLearningBanner and status:ShowsLearningBanner()

  local inGuild = true
  if type(IsInGuild) == "function" then
    inGuild = IsInGuild() and true or false
  end

  -- Hard gate B: unguilded. Status chip owns L0; this panel owns L1 copy.
  if hardGate or not inGuild then
    self.empty:Show()
    self.empty:SetText("You are outside the flock. Join a guild to earn standing.")
    if self.banner then self.banner:Hide() end
    for i = 1, RANK_COUNT do self.rows[i].frame:Hide() end
    if self.footer then self.footer:SetText("") end
    return
  end

  local rosterReady = COB.Roster and COB.Roster.IsReady and COB.Roster:IsReady()
  if not rosterReady then
    self.empty:Show()
    self.empty:SetText("Waiting for guild roster…")
    if self.banner then self.banner:Hide() end
    for i = 1, RANK_COUNT do self.rows[i].frame:Hide() end
    if self.footer then self.footer:SetText("") end
    return
  end

  self.empty:Hide()

  -- Keep cache shelves visible while connecting; L1 learning only after no_peers.
  local yOffset = 0
  if learning and self.banner then
    self.banner:Show()
    self.banner:SetText(
      "Ranks follow the guild roster. Earn standing with guildmates — officers promote in the guild UI.")
    yOffset = BANNER_HEIGHT
  elseif self.banner then
    self.banner:Hide()
  end
  layoutRows(self, panel, yOffset)

  local view = (COB.Ladder and COB.Ladder.GetLadderView) and COB.Ladder:GetLadderView() or {}
  local selfName = playerName()
  local list = COB.Ranks and COB.Ranks.List or {}
  local selfTitle

  -- Display high → low (Prophet at top). Fixed bands; never sort by standing.
  for i = 1, RANK_COUNT do
    local rank = list[RANK_COUNT - i + 1]
    local row = self.rows[i]
    if not rank then
      row.frame:Hide()
    else
      row.frame:Show()
      local names = occupantsForRank(view, rank.id)
      local line, full = formatOccupants(names, selfName)
      local hasSelf = false
      for n = 1, #names do
        if selfName and names[n] == selfName then
          hasSelf = true
          selfTitle = rank.title
          break
        end
      end

      -- Title stays institutional (no loot rainbow). Gold only marks your band.
      if hasSelf then
        row.title:SetText(YOU_GOLD .. rank.title .. YOU_RESET)
      else
        row.title:SetText(rank.title)
      end

      local maxSeats = seatCapacity(rank)
      if maxSeats then
        local taken = #names
        row.seats:SetText(string.format("%d/%d", taken, maxSeats))
        local vacancy = vacancyCopy(taken, maxSeats)
        if vacancy then
          if line == "—" then
            line = vacancy
          else
            line = line .. "  " .. vacancy
          end
          if full then
            full = full .. "  " .. vacancy
          end
        end
      else
        row.seats:SetText("")
      end

      row.occupants:SetText(line)
      row.tip.fullText = full
    end
  end

  -- Fresh Beef is endowed membership: if the player has no official record yet,
  -- they still sit conceptually at the entry title (GetRecord default).
  if not selfTitle and selfName and COB.Ranks and COB.Ranks.Title then
    local record = COB.Ladder and COB.Ladder.GetRecord and COB.Ladder:GetRecord(selfName)
    local rankId = record and record.rankId or 1
    selfTitle = COB.Ranks.Title(rankId)
  end

  if self.footer then
    if selfTitle then
      self.footer:SetText("Your title: " .. selfTitle)
    else
      self.footer:SetText("")
    end
  end
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({ name = "ladder", label = "Ladder", owner = LadderTab })
end
