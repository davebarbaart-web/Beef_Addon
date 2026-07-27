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
local PENDING_COLOR = "|cffe0b85a"

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

local function toastCredit(fields, fallbackText)
  if COB.Toasts and COB.Toasts.Celebrate then
    COB.Toasts:Celebrate("credit", fields)
  elseif COB.Toasts and COB.Toasts.Show then
    COB.Toasts:Show(fallbackText)
  end
end

-- Point-driven path for ranks 1–4; Butcher+ / appointed flip to scarcity copy.
-- Numbers always from COB.Ranks — never forked into this file.
local function nextThresholdCopy(rankId, standing)
  local ranks = COB.Ranks
  if not ranks then return "—" end

  if not ranks.IsPointDriven(rankId) then
    return "Council and Prophet come from your guild rank — standing still accrues."
  end

  local nextId = rankId + 1
  if not ranks.IsPointDriven(nextId) then
    -- Soft ceiling at Beef Butcher: standing still accrues; titles do not.
    return "Highest standing-earned title. Further guild ranks are officer decisions."
  end

  local need = ranks.Threshold(nextId)
  local title = ranks.Title(nextId)
  if type(need) ~= "number" then
    return "Council and Prophet come from your guild rank — standing still accrues."
  end
  local remain = need - (standing or 0)
  if remain < 0 then remain = 0 end
  if remain == 0 then
    return string.format("Eligible for %s — ask an officer to promote you in the guild roster.", title)
  end
  return string.format("%d to %s  ·  next at %d standing", remain, title, need)
end

local function localHasPendingSuggestion(name)
  if not (COB.Ladder and COB.Ladder.GetSuggestions) then return nil end
  local list = COB.Ladder:GetSuggestions()
  local key = type(name) == "string" and name:lower() or nil
  if not key then return nil end
  for i = 1, #list do
    local s = list[i]
    if type(s.name) == "string" and s.name:lower() == key then
      return s
    end
  end
  return nil
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

local function trimmedEdit(box)
  local text = box and box.GetText and box:GetText() or nil
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

local function opponentName(self)
  return trimmedEdit(self.opponent)
end

local function ceremonyLabelText(self)
  return trimmedEdit(self.ceremonyLabel) or "Ceremony"
end

local function honoreeName(self)
  return trimmedEdit(self.honoree)
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
    local line = string.format("Gora %s: +%d standing", verb, mine)
    toastCredit({
      detail = verb,
      standingDelta = mine,
      text = line,
      dedupeKey = "gora:" .. me,
    }, line)
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
      local status = string.format("Ceremony closed: %d attendee(s) credited, %d standing granted.",
        credited, result.total)
      if result.knighted and result.honoree then
        status = status .. string.format(" %s knighted.", result.honoree)
      end
      self:_Status(status)
      local line = string.format("Ceremony closed: %d attendee(s) credited", credited)
      toastCredit({ attendees = credited, text = line, dedupeKey = "ceremony-close" }, line)
    end
  else
    local started, err = ceremony:Start(ceremonyLabelText(self))
    if not started then
      self:_Status(err or "the ceremony would not start", true)
      self:_RefreshRites()
      return false
    end

    local honoree = honoreeName(self)
    if honoree and ceremony.SetHonoree then
      local set, setErr = ceremony:SetHonoree(honoree)
      if not set then
        self:_Status(setErr or "the honoree could not be set", true)
        self:_RefreshRites()
        refreshAll()
        return false
      end
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
  header:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 98)
  header:SetJustifyH("LEFT")
  header:SetText("Record testimony")

  local opponentLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  opponentLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 76)
  opponentLabel:SetJustifyH("LEFT")
  opponentLabel:SetText("Gora vs")

  local opponent = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  opponent:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 60, 72)
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
  outcome:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 190, 72)
  outcome:SetScript("OnClick", function() StandingTab:CycleOutcome() end)
  self.outcome = outcome

  local record = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  record:SetWidth(150)
  record:SetHeight(20)
  record:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 48)
  record:SetText("Record Gora Result")
  record:SetScript("OnClick", function() StandingTab:RecordGora() end)
  self.record = record

  -- Compact ceremony strip: label + optional honoree, then the officer toggle.
  local riteLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  riteLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 28)
  riteLabel:SetJustifyH("LEFT")
  riteLabel:SetText("Rite")

  local ceremonyLabel = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  ceremonyLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 36, 24)
  ceremonyLabel:SetWidth(88)
  ceremonyLabel:SetHeight(20)
  ceremonyLabel:SetAutoFocus(false)
  ceremonyLabel:SetMaxLetters(60)
  ceremonyLabel:SetText("Ceremony")
  ceremonyLabel:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
  self.ceremonyLabel = ceremonyLabel

  local honoreeHint = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  honoreeHint:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 132, 28)
  honoreeHint:SetJustifyH("LEFT")
  honoreeHint:SetText("Honoree")

  local honoree = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  honoree:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 186, 24)
  honoree:SetWidth(90)
  honoree:SetHeight(20)
  honoree:SetAutoFocus(false)
  honoree:SetMaxLetters(40)
  honoree:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
  self.honoree = honoree

  local ceremony = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  ceremony:SetWidth(140)
  ceremony:SetHeight(20)
  ceremony:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 156, 48)
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

  -- Classic hierarchy: title hero → standing → text threshold → status → history.
  -- No StatusBar / castbar chrome (glossary 76).
  local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  title:SetJustifyH("LEFT")
  self.title = title
  -- Legacy alias: harness and older call sites read .header for the title hero.
  self.header = title

  local nameLine = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  nameLine:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
  nameLine:SetJustifyH("LEFT")
  self.nameLine = nameLine

  local standing = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  standing:SetPoint("TOPLEFT", nameLine, "BOTTOMLEFT", 0, -10)
  standing:SetJustifyH("LEFT")
  self.standing = standing

  local nextLine = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  nextLine:SetPoint("TOPLEFT", standing, "BOTTOMLEFT", 0, -6)
  nextLine:SetPoint("RIGHT", panel, "RIGHT", -4, 0)
  nextLine:SetJustifyH("LEFT")
  self.nextLine = nextLine

  local petition = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  petition:SetPoint("TOPLEFT", nextLine, "BOTTOMLEFT", 0, -4)
  petition:SetJustifyH("LEFT")
  petition:SetText("")
  self.petition = petition

  local histLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisable")
  histLabel:SetPoint("TOPLEFT", petition, "BOTTOMLEFT", 0, -12)
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
  local officer = localIsOfficer()
  if officer then
    self.ceremony:Enable()
  else
    self.ceremony:Disable()
  end

  -- Label/honoree are start-time inputs; keep them editable only for officers
  -- when no ceremony is running (close does not re-read them).
  local editsLive = officer and not active
  if self.ceremonyLabel then
    if editsLive then self.ceremonyLabel:Enable() else self.ceremonyLabel:Disable() end
  end
  if self.honoree then
    if editsLive then self.honoree:Enable() else self.honoree:Disable() end
  end
end

function StandingTab:OnRefresh(panel)
  local name = playerName()
  local record = (COB.Ladder and COB.Ladder.GetRecord) and COB.Ladder:GetRecord(name) or nil
  local rankId = record and record.rankId or 1
  local standing = record and record.standing or 0
  local title = (COB.Ranks and COB.Ranks.Title) and COB.Ranks.Title(rankId) or "Fresh Beef"

  -- Title is the hero signal; name is secondary chrome.
  self.title:SetText(title)
  if self.nameLine then
    self.nameLine:SetText(name)
  end
  self.standing:SetText(string.format("Standing: %d", standing))
  self.nextLine:SetText(nextThresholdCopy(rankId, standing))

  if self.petition then
    local pending = localHasPendingSuggestion(name)
    if pending and COB.Ranks and COB.Ranks.Title then
      local toTitle = COB.Ranks.Title(pending.toRankId) or "next title"
      self.petition:SetText(PENDING_COLOR .. "Eligible — officers can promote you to " .. toTitle .. " in the guild roster." .. "|r")
    else
      self.petition:SetText("")
    end
  end

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
