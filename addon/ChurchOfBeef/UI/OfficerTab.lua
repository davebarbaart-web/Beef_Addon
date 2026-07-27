ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Officer+ promote prompts: queue of members who crossed a standing threshold.
-- Ranks are changed in the Blizzard guild UI — this tab only Dismisses prompts
-- and corrects advisory standing. Core/Officer.lua stays the only authority gate.
local OfficerTab = {}
COB.OfficerTab = OfficerTab

local QUEUE_ROWS = 6
local RECENT_ROWS = 2
local RECENT_MAX = 5
local EVIDENCE_EVENTS = 2

local COL_SPLIT = 168
local ROW_HEIGHT = 16
local LINE = 13

local ERROR_COLOR = "|cffff5555"
local REJECT_COLOR = "|cffc08080"
local SUCCESS_COLOR = "|cff3cb371"

local function localIsOfficer()
  if not (COB.Officer and COB.Officer.LocalIsOfficer) then return false end
  return COB.Officer:LocalIsOfficer() and true or false
end

local function title(rankId)
  if COB.Ranks and COB.Ranks.Title then return COB.Ranks.Title(rankId) end
  return "Unknown"
end

local function suggestions()
  if not (COB.Ladder and COB.Ladder.GetSuggestions) then return {} end
  return COB.Ladder:GetSuggestions()
end

local function sortByAge(list)
  table.sort(list, function(a, b)
    if (a.createdAt or 0) ~= (b.createdAt or 0) then
      return (a.createdAt or 0) < (b.createdAt or 0)
    end
    return a.name < b.name
  end)
  return list
end

local function findSuggestion(name)
  local list = suggestions()
  for i = 1, #list do
    if list[i].name == name then return list[i] end
  end
  return nil
end

local function record(name)
  if not (COB.Ladder and COB.Ladder.GetRecord) then return nil end
  return COB.Ladder:GetRecord(name)
end

local function subjectExists(name)
  if COB.Roster and COB.Roster.HasMember and COB.Roster:HasMember(name) then
    return true
  end
  if COB.Officer and COB.Officer.IsGuildRosterName then
    return COB.Officer:IsGuildRosterName(name)
  end
  if COB.Ladder and COB.Ladder.HasOfficialRecord and COB.Ladder:HasOfficialRecord(name) then
    return true
  end
  return false
end

local function refreshAll()
  if not COB.UI then return end
  if COB.UI.RefreshLadder then
    COB.UI:RefreshLadder()
  elseif COB.UI.MarkDirty then
    COB.UI:MarkDirty("officer")
  end
end

local function toast(text, kind, dedupeKey)
  if not COB.Toasts then return end
  kind = kind or "system"
  if COB.Toasts.Push then
    COB.Toasts:Push({ kind = kind, text = text, dedupeKey = dedupeKey })
  elseif COB.Toasts.Show then
    COB.Toasts:Show(text)
  end
end

function OfficerTab:_Status(text, tone)
  self.statusText = text or ""
  if not self.status then return end
  if not text then
    self.status:SetText("")
    return
  end
  if tone == true or tone == "error" then
    self.status:SetText(ERROR_COLOR .. "Refused: " .. text .. "|r")
  elseif tone == "reject" then
    self.status:SetText(REJECT_COLOR .. text .. "|r")
  elseif tone == "success" then
    self.status:SetText(SUCCESS_COLOR .. text .. "|r")
  else
    self.status:SetText(text)
  end
end

function OfficerTab:_Remember(text)
  local log = self.recent
  if not log then
    self.recent = {}
    log = self.recent
  end
  table.insert(log, 1, text)
  while #log > RECENT_MAX do table.remove(log) end
end

-- Dismiss a promote prompt. Does not change guild rank or standing.
function OfficerTab:Dismiss(name)
  if not localIsOfficer() then
    self:_Status("you are not an officer of this guild", true)
    return false
  end
  if not (COB.Ladder and COB.Ladder.RejectSuggestion and COB.Ladder:RejectSuggestion(name)) then
    self:_Status("Petition no longer pending.", true)
    return false
  end

  self:_Status(string.format("Dismissed: %s keeps their standing.", name), "reject")
  self:_Remember(string.format("Dismissed %s", name))
  toast(string.format("Dismissed: %s", name), "system", "dismiss:" .. name)
  refreshAll()
  return true
end

-- Back-compat alias used by older call sites / muscle memory.
OfficerTab.Reject = OfficerTab.Dismiss

function OfficerTab:CorrectStanding(name, delta)
  if not localIsOfficer() then
    self:_Status("you are not an officer of this guild", true)
    return false
  end
  if type(delta) ~= "number" or delta == 0 then
    self:_Status("enter a standing change such as 25 or -50", true)
    return false
  end
  if not subjectExists(name) then
    self:_Status(string.format("%s is on neither the ladder nor the guild roster", name), true)
    return false
  end

  local current = record(name)
  if not current then
    self:_Status("that member is not on the ladder", true)
    return false
  end

  local target = current.standing + delta
  if target < 0 then target = 0 end

  local updated, err = COB.Ladder:CorrectStanding(name, target)
  if not updated then
    self:_Status(err or "the correction failed", true)
    return false
  end

  self:_Status(string.format("Corrected: %s now holds %d standing.", name, updated.standing))
  self:_Remember(string.format("Corrected %s %d → %d", name, current.standing, updated.standing))
  toast(string.format("%s: %d standing", name, updated.standing), "rite",
    "rite-standing:" .. name .. ":" .. tostring(updated.standing))
  refreshAll()
  return true
end

local function subjectName(self)
  local text = self.subject and self.subject:GetText() or nil
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

function OfficerTab:_BuildQueue(panel)
  local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  header:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -2)
  header:SetText("Promote prompts")

  self.rows = {}
  for i = 1, QUEUE_ROWS do
    local row = CreateFrame("Button", nil, panel)
    row:SetHeight(ROW_HEIGHT)
    row:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -18 - ((i - 1) * ROW_HEIGHT))
    row:SetWidth(COL_SPLIT - 12)
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

    local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("LEFT", row, "LEFT", 2, 0)
    label:SetPoint("RIGHT", row, "RIGHT", -2, 0)
    label:SetJustifyH("LEFT")

    row:SetScript("OnClick", function()
      if row.subject then
        OfficerTab.selected = row.subject
        if OfficerTab.subject then OfficerTab.subject:SetText(row.subject) end
        refreshAll()
      end
    end)

    self.rows[i] = { frame = row, label = label }
  end

  local overflow = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  overflow:SetPoint("TOPLEFT", panel, "TOPLEFT", 6, -20 - (QUEUE_ROWS * ROW_HEIGHT))
  overflow:SetJustifyH("LEFT")
  overflow:SetText("")
  self.overflow = overflow
end

function OfficerTab:_BuildEvidence(panel)
  local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  header:SetPoint("TOPLEFT", panel, "TOPLEFT", COL_SPLIT, -2)
  header:SetText("Evidence")

  local function line(index, template)
    local fs = panel:CreateFontString(nil, "OVERLAY", template)
    fs:SetPoint("TOPLEFT", panel, "TOPLEFT", COL_SPLIT, -18 - ((index - 1) * LINE))
    fs:SetPoint("RIGHT", panel, "RIGHT", -4, 0)
    fs:SetJustifyH("LEFT")
    return fs
  end

  self.evName = line(1, "GameFontHighlight")
  self.evDelta = line(2, "GameFontNormalSmall")
  self.evPreview = line(3, "GameFontNormalSmall")
  self.evStanding = line(4, "GameFontNormalSmall")
  self.evRite = line(5, "GameFontNormalSmall")
  self.evBreakdown = line(6, "GameFontDisableSmall")

  self.evEvents = {}
  for i = 1, EVIDENCE_EVENTS do
    self.evEvents[i] = line(6 + i, "GameFontDisableSmall")
  end

  local buttonRow = 7 + EVIDENCE_EVENTS
  local dismiss = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  dismiss:SetWidth(140)
  dismiss:SetHeight(22)
  dismiss:SetPoint("TOPLEFT", panel, "TOPLEFT", COL_SPLIT, -18 - (buttonRow * LINE))
  dismiss:SetText("Dismiss")
  dismiss:SetScript("OnClick", function()
    if OfficerTab.selected then OfficerTab:Dismiss(OfficerTab.selected) end
  end)
  self.dismiss = dismiss
  -- Alias so older tests looking for reject still find a button.
  self.reject = dismiss
  self.approve = nil

  -- Soft Council policy (Approach 1): Prophet appoints — not a points ladder seat.
  self.evFooter = line(buttonRow + 2, "GameFontDisableSmall")
  self.evFooter:SetText("Beef Council seats are appointed by the Beef Prophet.")
end

function OfficerTab:_BuildStanding(panel)
  local y = -18 - ((9 + EVIDENCE_EVENTS) * LINE) - 28

  local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  header:SetPoint("TOPLEFT", panel, "TOPLEFT", COL_SPLIT, y)
  header:SetText("Standing correction")

  local subject = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  subject:SetPoint("TOPLEFT", panel, "TOPLEFT", COL_SPLIT + 4, y - 18)
  subject:SetWidth(120)
  subject:SetHeight(20)
  subject:SetAutoFocus(false)
  subject:SetMaxLetters(40)
  subject:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
  self.subject = subject

  local delta = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  delta:SetPoint("LEFT", subject, "RIGHT", 8, 0)
  delta:SetWidth(50)
  delta:SetHeight(20)
  delta:SetAutoFocus(false)
  delta:SetMaxLetters(6)
  delta:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
  self.standingDelta = delta

  local apply = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  apply:SetWidth(60)
  apply:SetHeight(22)
  apply:SetPoint("LEFT", delta, "RIGHT", 6, 0)
  apply:SetText("Apply")
  apply:SetScript("OnClick", function()
    local name = subjectName(OfficerTab)
    local text = OfficerTab.standingDelta and OfficerTab.standingDelta:GetText() or ""
    local amount = tonumber(text)
    if name and amount then OfficerTab:CorrectStanding(name, amount) end
  end)
  self.standingApply = apply
end

function OfficerTab:_BuildRecent(panel)
  self.recent = {}
  self.recentLines = {}
  for i = 1, RECENT_ROWS do
    local fs = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    fs:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 4, 18 + ((RECENT_ROWS - i) * LINE))
    fs:SetPoint("RIGHT", panel, "RIGHT", -4, 0)
    fs:SetJustifyH("LEFT")
    self.recentLines[i] = fs
  end

  local status = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  status:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 4, 2)
  status:SetPoint("RIGHT", panel, "RIGHT", -4, 0)
  status:SetJustifyH("LEFT")
  self.status = status

  -- Announce checkbox retained but hidden until a future roster-diff announcer.
  local check = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  check:Hide()
  self.announceCheck = check
  local label = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:Hide()
  self.announceLabel = label
end

function OfficerTab:_RefreshQueue()
  local list = sortByAge(suggestions())
  if not self.selected and list[1] then
    self.selected = list[1].name
    if self.subject then self.subject:SetText(list[1].name) end
  end
  if self.selected and not findSuggestion(self.selected) then
    self.selected = list[1] and list[1].name or nil
    if self.subject then self.subject:SetText(self.selected or "") end
  end

  for i = 1, QUEUE_ROWS do
    local row = self.rows[i]
    local suggestion = list[i]
    if not suggestion then
      row.frame:Hide()
      row.subject = nil
    else
      row.frame:Show()
      row.subject = suggestion.name
      local toTitle = title(suggestion.toRankId)
      local label = string.format("Promote %s → %s", suggestion.name, toTitle)
      if suggestion.riteKind and not suggestion.riteMet then
        label = label .. " (!)"
      end
      row.label:SetText(label)
    end
  end

  if self.overflow then
    if #list == 0 then
      self.overflow:SetText("No pending suggestions.")
    elseif #list > QUEUE_ROWS then
      self.overflow:SetText(string.format("+%d more", #list - QUEUE_ROWS))
    else
      self.overflow:SetText("")
    end
  end
end

local function riteLine(suggestion)
  local kind = suggestion and suggestion.riteKind
  if not kind then return "" end
  local label
  if kind == "knighted" then
    label = "Knighting"
  elseif kind == "goraLordWin" then
    label = "Gora win vs Lord"
  else
    label = kind
  end
  if suggestion.riteMet then
    return string.format("Rite: %s — met", label)
  end
  return string.format("Rite: %s — not yet", label)
end

function OfficerTab:_RefreshEvidence()
  if self.evFooter then
    self.evFooter:SetText("Beef Council seats are appointed by the Beef Prophet.")
  end

  local suggestion = self.selected and findSuggestion(self.selected) or nil
  if not suggestion then
    if self.evName then self.evName:SetText("No petition selected") end
    if self.evDelta then self.evDelta:SetText("") end
    if self.evPreview then self.evPreview:SetText("") end
    if self.evStanding then self.evStanding:SetText("") end
    if self.evRite then self.evRite:SetText("") end
    if self.evBreakdown then self.evBreakdown:SetText("") end
    for i = 1, EVIDENCE_EVENTS do
      if self.evEvents[i] then self.evEvents[i]:SetText("") end
    end
    if self.dismiss then self.dismiss:Disable() end
    return
  end

  local fromTitle = title(suggestion.fromRankId)
  local toTitle = title(suggestion.toRankId)
  if self.evName then self.evName:SetText(suggestion.name) end
  if self.evDelta then self.evDelta:SetText(string.format("%s → %s", fromTitle, toTitle)) end
  if self.evPreview then
    self.evPreview:SetText(string.format("Promote %s to %s in the guild roster.", suggestion.name, toTitle))
  end
  if self.evStanding then
    self.evStanding:SetText(string.format("Standing %d / %d (threshold)",
      suggestion.standing or 0, suggestion.threshold or 0))
  end
  if self.evRite then self.evRite:SetText(riteLine(suggestion)) end

  local breakdown = ""
  if COB.Scoring and COB.Scoring.GetGranted then
    local parts = {}
    for _, source in ipairs({ "instance", "ceremony", "gora", "quest" }) do
      local amount = COB.Scoring:GetGranted(suggestion.name, source)
      if type(amount) == "number" and amount > 0 then
        parts[#parts + 1] = string.format("%s %d", source, amount)
      end
    end
    breakdown = table.concat(parts, " · ")
  end
  if self.evBreakdown then self.evBreakdown:SetText(breakdown) end

  local history = (COB.Scoring and COB.Scoring.GetHistory) and COB.Scoring:GetHistory(suggestion.name) or {}
  for i = 1, EVIDENCE_EVENTS do
    local event = history[i]
    if self.evEvents[i] then
      if event then
        self.evEvents[i]:SetText(string.format("+%d %s", event.amount, event.source))
      else
        self.evEvents[i]:SetText("")
      end
    end
  end

  if self.dismiss then self.dismiss:Enable() end
end

function OfficerTab:_RefreshRecent()
  local log = self.recent or {}
  for i = 1, RECENT_ROWS do
    if self.recentLines[i] then
      self.recentLines[i]:SetText(log[i] or "")
    end
  end
end

function OfficerTab:OnCreate(panel)
  self.panel = panel
  self.selected = nil
  self.recent = {}
  self:_BuildQueue(panel)
  self:_BuildEvidence(panel)
  self:_BuildStanding(panel)
  self:_BuildRecent(panel)
end

function OfficerTab:OnRefresh(_panel)
  if not localIsOfficer() then return end
  if COB.Roster and COB.Roster.ClearSatisfiedSuggestions then
    COB.Roster:ClearSatisfiedSuggestions()
  end
  self:_RefreshQueue()
  self:_RefreshEvidence()
  self:_RefreshRecent()
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({
    name = "officer",
    label = "Officer",
    officerOnly = true,
    owner = OfficerTab,
  })
end
