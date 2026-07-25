ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- My Standing: text thresholds only (glossary 76 / spec §10). No StatusBar hero,
-- no meter-dashboard chrome. Reads Core; never awards points.
--
-- The strip along the bottom is the thin Gora / ceremony surface from spec §10.
-- It collects a name and an outcome and hands them to Core/Gora and
-- Core/Ceremony: no grant, cap, or officer rule is decided here.
local StandingTab = {}
COB.StandingTab = StandingTab

local HISTORY_LINES = 6

local ERROR_COLOR = "|cffff5555"

-- Stated from the local player's side, because that is who is pressing it.
local OUTCOMES = {
  { key = "won", label = "I won" },
  { key = "lost", label = "I lost" },
  { key = "draw", label = "Draw" },
}

local function playerName()
  if type(UnitName) == "function" then
    local name = UnitName("player")
    if type(name) == "string" and name ~= "" then return name end
  end
  return "Player"
end

local function localIsOfficer()
  if not (COB.Officer and COB.Officer.LocalIsOfficer) then return false end
  return COB.Officer:LocalIsOfficer() and true or false
end

local function toast(text)
  if COB.Toasts and COB.Toasts.Show then COB.Toasts:Show(text) end
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

--------------------------------------------------------------------------------
-- Status line (shared by both stubs)
--------------------------------------------------------------------------------

-- Dual-encoded: the word "Refused" carries the meaning, colour only reinforces it.
function StandingTab:_Status(text, isError)
  self.statusText = text or ""
  self.statusIsError = isError and true or false
  self:_RefreshStatus()
end

function StandingTab:_RefreshStatus()
  if not self.status then return end
  if self.statusText ~= "" and self.statusIsError then
    self.status:SetText(ERROR_COLOR .. "Refused: " .. self.statusText .. "|r")
  else
    self.status:SetText(self.statusText or "")
  end
end

local function opponentName(self)
  local text = self.opponent and self.opponent:GetText() or nil
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function refreshAll()
  if COB.UI and COB.UI.RefreshLadder then COB.UI:RefreshLadder() end
end

--------------------------------------------------------------------------------
-- Thin stubs: collect input, call Core, report what Core decided
--------------------------------------------------------------------------------

function StandingTab:OutcomeKey()
  return OUTCOMES[self.outcomeIndex or 1].key
end

function StandingTab:CycleOutcome()
  local index = (self.outcomeIndex or 1) + 1
  if index > #OUTCOMES then index = 1 end
  self.outcomeIndex = index
  if self.outcome then self.outcome:SetText(OUTCOMES[index].label) end
  return OUTCOMES[index].key
end

function StandingTab:RecordGora()
  if not (COB.Gora and COB.Gora.RecordResult) then
    self:_Status("the Gora ledger is not loaded", true)
    return false
  end

  local me = playerName()
  local other = opponentName(self)
  if not other then
    self:_Status("name the member you fought", true)
    return false
  end

  -- The button says what happened to me; Core wants the winner first.
  local key = self:OutcomeKey()
  local winner, loser, outcome = me, other, "win"
  if key == "lost" then
    winner, loser = other, me
  elseif key == "draw" then
    outcome = "draw"
  end

  local result, err = COB.Gora:RecordResult(winner, loser, outcome)
  if not result then
    self:_Status(err or "the Gora was not recorded", true)
    return false
  end

  local mine = (result.winner == me) and result.winnerPoints or result.loserPoints
  local verb = (key == "draw" and "draw") or (key == "lost" and "loss") or "win"
  if mine > 0 then
    self:_Status(string.format("Gora recorded against %s: +%d standing (%s).", other, mine, verb))
    toast(string.format("Gora %s: +%d standing", verb, mine))
  else
    -- A zero payout is the daily cap doing its job, not a failure.
    self:_Status(string.format("Gora recorded against %s: your daily Gora standing is spent.", other))
  end

  refreshAll()
  return true
end

function StandingTab:ToggleCeremony()
  local ceremony = COB.Ceremony
  if not (ceremony and ceremony.Start) then
    self:_Status("the ceremony ledger is not loaded", true)
    return false
  end

  if ceremony:IsActive() then
    local result, err = ceremony:Close()
    if not result then
      self:_Status(err or "the ceremony would not close", true)
      self:_RefreshRites()
      return false
    end

    local credited = #result.attendees
    if credited == 0 then
      self:_Status("Ceremony closed: nobody present had attended it.")
    else
      self:_Status(string.format("Ceremony closed: %d attendee(s) credited, %d standing granted.",
        credited, result.total))
      toast(string.format("Ceremony closed: %d attendee(s) credited", credited))
    end
  else
    local started, err = ceremony:Start()
    if not started then
      self:_Status(err or "the ceremony would not start", true)
      self:_RefreshRites()
      return false
    end
    self:_Status(string.format("Ceremony under way: %d present. Close it to grant credit.",
      #started.tracked))
  end

  self:_RefreshRites()
  refreshAll()
  return true
end

--------------------------------------------------------------------------------
-- Construction
--------------------------------------------------------------------------------

function StandingTab:_BuildRites(panel)
  local header = panel:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  header:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 74)
  header:SetJustifyH("LEFT")
  header:SetText("Record testimony")

  local opponentLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  opponentLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 52)
  opponentLabel:SetJustifyH("LEFT")
  opponentLabel:SetText("Gora vs")

  local opponent = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  opponent:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 60, 48)
  opponent:SetWidth(120)
  opponent:SetHeight(20)
  opponent:SetAutoFocus(false)
  opponent:SetMaxLetters(40)
  opponent:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
  self.opponent = opponent

  -- Stepper rather than a stock dropdown: UIDropDownMenu is a taint hazard and
  -- three outcomes do not need a menu.
  local outcome = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  outcome:SetWidth(70)
  outcome:SetHeight(20)
  outcome:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 190, 48)
  outcome:SetScript("OnClick", function() StandingTab:CycleOutcome() end)
  self.outcome = outcome

  local record = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  record:SetWidth(150)
  record:SetHeight(20)
  record:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 24)
  record:SetText("Record Gora Result")
  record:SetScript("OnClick", function() StandingTab:RecordGora() end)
  self.record = record

  local ceremony = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  ceremony:SetWidth(140)
  ceremony:SetHeight(20)
  ceremony:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 156, 24)
  ceremony:SetScript("OnClick", function() StandingTab:ToggleCeremony() end)
  self.ceremony = ceremony

  local status = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  status:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 6)
  status:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 6)
  status:SetJustifyH("LEFT")
  status:SetText("")
  self.status = status
end

function StandingTab:OnCreate(panel)
  self.outcomeIndex = 1
  self.statusText = ""
  self.statusIsError = false

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

  self:_BuildRites(panel)
  self:_RefreshRites()
end

--------------------------------------------------------------------------------
-- Refresh
--------------------------------------------------------------------------------

function StandingTab:_RefreshRites()
  if self.outcome then
    self.outcome:SetText(OUTCOMES[self.outcomeIndex or 1].label)
  end

  if not self.ceremony then return end
  local ceremony = COB.Ceremony
  local active = ceremony and ceremony.IsActive and ceremony:IsActive()
  self.ceremony:SetText(active and "Close Ceremony" or "Start Ceremony")

  -- Spec §7.1: officers run ceremonies. Core refuses either way; disabling the
  -- button is so a member is not invited to press something that cannot work.
  if localIsOfficer() then
    self.ceremony:Enable()
  else
    self.ceremony:Disable()
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

  self:_RefreshRites()
  self:_RefreshStatus()
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({ name = "standing", label = "My Standing", owner = StandingTab })
end
