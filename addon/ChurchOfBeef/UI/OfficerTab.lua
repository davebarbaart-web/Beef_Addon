ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Officer+ rites, four zones (glossary 71):
--   A pending queue · B evidence for the selection · C rites, outside the queue
--   pool · D recent actions — plus the announce opt-out strip.
-- Approve and Reject commit straight from B with no modal (glossary 70); demote,
-- Council, Prophet and standing wipes route through the confirm child frame.
-- The tab button is hidden for non-officers; Core/Officer.lua stays the only real
-- gate, and every action re-checks it. This view reads and commits through Core:
-- it never awards standing and never spells a rank title itself.
local OfficerTab = {}
COB.OfficerTab = OfficerTab

local QUEUE_ROWS = 4
-- Zone D sits on the panel floor (~274 px of usable height): two rows and the
-- announce strip fit, three overflowed off the bottom edge.
local RECENT_ROWS = 2
local RECENT_MAX = 5
local EVIDENCE_EVENTS = 2

local COL_SPLIT = 168
local ANNOUNCE_COLUMN = 200
local ROW_HEIGHT = 16
local LINE = 13

local ERROR_COLOR = "|cffff5555"
local PENDING_COLOR = "|cffffd100"

--------------------------------------------------------------------------------
-- Core access helpers
--------------------------------------------------------------------------------

local function localIsOfficer()
  if not (COB.Officer and COB.Officer.LocalIsOfficer) then return false end
  return COB.Officer:LocalIsOfficer() and true or false
end

local function officerName()
  if type(UnitName) == "function" then
    local name = UnitName("player")
    if type(name) == "string" and name ~= "" then return name end
  end
  return nil
end

local function title(rankId)
  if COB.Ranks and COB.Ranks.Title then return COB.Ranks.Title(rankId) end
  return "Unknown"
end

-- Demote targets come from canon by kind, so adding a point rank does not need a
-- second list here and Council/Prophet can never appear as a demotion target.
local function demotableRankIds()
  local ids = {}
  local list = COB.Ranks and COB.Ranks.List or {}
  for i = 1, #list do
    if list[i].kind == "points" then ids[#ids + 1] = list[i].id end
  end
  return ids
end

local function rankIdByKind(kind)
  local list = COB.Ranks and COB.Ranks.List or {}
  for i = 1, #list do
    if list[i].kind == kind then return list[i].id end
  end
  return nil
end

local function titleForKind(kind)
  return title(rankIdByKind(kind))
end

local function suggestions()
  if not (COB.Ladder and COB.Ladder.GetSuggestions) then return {} end
  return COB.Ladder:GetSuggestions()
end

-- Oldest petition first: promotion night should drain in the order members earned
-- it, not alphabetically.
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

-- A rite must land on someone who exists. GetRecord answers Fresh Beef for any
-- string, so a mistyped subject would otherwise be seated on the Council as a
-- brand new ghost occupant. Accept an official ladder record, or a name the guild
-- roster answers to (a real member who simply has no record yet).
local function subjectExists(name)
  if COB.Ladder and COB.Ladder.HasOfficialRecord and COB.Ladder:HasOfficialRecord(name) then
    return true
  end
  if COB.Officer and COB.Officer.IsGuildRosterName then
    return COB.Officer:IsGuildRosterName(name)
  end
  return false
end

local function councilSeatsTaken()
  local ranks = COB.Ranks
  if not ranks then return 0, nil end
  local councilId = rankIdByKind("council")
  if not councilId then return 0, nil end

  local taken = 0
  local seats = ranks.CouncilSeats
  local view = (COB.Ladder and COB.Ladder.GetLadderView) and COB.Ladder:GetLadderView() or {}
  for i = 1, #view do
    if view[i].rankId == councilId then taken = taken + 1 end
  end
  return taken, seats
end

-- Hands Core's committed record to the wire. Best effort by design: a client with no
-- BeefNet (or no guild) still made a real local commit, and login sync will carry it
-- to the peers who missed the broadcast.
local function broadcast(committed)
  if COB.Net and COB.Net.SendRankCommit then COB.Net:SendRankCommit(committed) end
end

-- RefreshLadder already dirties the officer queue alongside ladder and standing;
-- MarkDirty is the fallback if only the narrower API is present.
local function refreshAll()
  if not COB.UI then return end
  if COB.UI.RefreshLadder then
    COB.UI:RefreshLadder()
  elseif COB.UI.MarkDirty then
    COB.UI:MarkDirty("officer")
  end
end

local function toast(text)
  if COB.Toasts and COB.Toasts.Show then COB.Toasts:Show(text) end
end

--------------------------------------------------------------------------------
-- Status line and recent actions (zone D)
--------------------------------------------------------------------------------

-- Dual-encoded: the verb carries the meaning, colour only reinforces it.
function OfficerTab:_Status(text, isError)
  self.statusText = text or ""
  if not self.status then return end
  if text and isError then
    self.status:SetText(ERROR_COLOR .. "Refused: " .. text .. "|r")
  else
    self.status:SetText(text or "")
  end
end

-- The confirm frame parks the officer's typed reason here for the length of one
-- rite, so every rite logs it without each call site having to thread it through.
-- Consumed once: a later unconfirmed rite must not inherit it.
function OfficerTab:_Remember(text)
  local why = self.pendingReason
  self.pendingReason = nil
  if type(why) == "string" and why ~= "" then
    text = string.format("%s \194\183 %s", text, why)
  end

  local log = self.recent
  table.insert(log, 1, text)
  while #log > RECENT_MAX do table.remove(log) end
end

--------------------------------------------------------------------------------
-- Rites (zone C) — every one of these ends in Ladder:Commit
--------------------------------------------------------------------------------

-- Shared tail for the three appointment-shaped rites: commit, replicate, announce,
-- log, refresh. Announce is a side effect of the commit, never a second
-- unsupervised SendChatMessage from a click handler.
function OfficerTab:_Rite(name, commitFn, verb, announceFn)
  if not localIsOfficer() then
    self:_Status("you are not an officer of this guild", true)
    return false
  end
  local officer = officerName()
  if not officer then
    self:_Status("your character name is not known yet", true)
    return false
  end
  if not subjectExists(name) then
    self:_Status(string.format("%s is on neither the ladder nor the guild roster", name), true)
    return false
  end

  local committed, err = commitFn(officer)
  if not committed then
    self:_Status(err or "the rite failed", true)
    toast(string.format("%s refused: %s", verb, err or "unknown"))
    return false
  end

  broadcast(committed)
  local rankTitle = title(committed.rankId)
  if announceFn then announceFn(committed.name, rankTitle) end

  self:_Status(string.format("%s: %s is %s.", verb, committed.name, rankTitle))
  self:_Remember(string.format("%s %s → %s", verb, committed.name, rankTitle))
  toast(string.format("%s: %s → %s", verb, committed.name, rankTitle))
  refreshAll()
  return true
end

function OfficerTab:Approve(name)
  local suggestion = findSuggestion(name)
  if not suggestion then
    self:_Status("that petition is no longer pending", true)
    return false
  end
  local toRankId = suggestion.toRankId
  return self:_Rite(name, function(officer)
    -- nil standing: approving a petition changes rank only, the member keeps
    -- every point they earned.
    return COB.Ladder:Commit(name, toRankId, nil, officer)
  end, "Elevated", function(who, rankTitle)
    if COB.Announce then COB.Announce:Promotion(who, rankTitle) end
  end)
end

-- Rejection is officer process, not flock spectacle: no guild line, and the
-- member's standing survives (spec §7.3).
function OfficerTab:Reject(name)
  if not localIsOfficer() then
    self:_Status("you are not an officer of this guild", true)
    return false
  end
  if not (COB.Ladder and COB.Ladder.RejectSuggestion and COB.Ladder:RejectSuggestion(name)) then
    self:_Status("that petition is no longer pending", true)
    return false
  end

  self:_Status(string.format("Dismissed: %s keeps their standing.", name))
  self:_Remember(string.format("Dismissed %s", name))
  toast(string.format("Petition dismissed: %s", name))
  refreshAll()
  return true
end

function OfficerTab:Demote(name, rankId)
  return self:_Rite(name, function(officer)
    return COB.Ladder:Demote(name, rankId, officer)
  end, "Cast down", function(who, rankTitle)
    if COB.Announce then COB.Announce:Demotion(who, rankTitle) end
  end)
end

function OfficerTab:AppointCouncil(name)
  return self:_Rite(name, function(officer)
    return COB.Ladder:AppointCouncil(name, officer)
  end, "Seated", function(who, rankTitle)
    if COB.Announce then COB.Announce:Council(who, rankTitle) end
  end)
end

function OfficerTab:BestowProphet(name)
  return self:_Rite(name, function(officer)
    return COB.Ladder:BestowProphet(name, officer)
  end, "Anointed", function(who, rankTitle)
    if COB.Announce then COB.Announce:Prophet(who, rankTitle) end
  end)
end

-- Officer correction of advisory points. Committed (not SetStanding) so the
-- change is official state that replicates, and never announced: standing is
-- bookkeeping, not a rite.
function OfficerTab:CorrectStanding(name, delta)
  if not localIsOfficer() then
    self:_Status("you are not an officer of this guild", true)
    return false
  end
  if type(delta) ~= "number" or delta == 0 then
    self:_Status("enter a standing change such as 25 or -50", true)
    return false
  end
  local officer = officerName()
  if not officer then
    self:_Status("your character name is not known yet", true)
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

  local committed, err = COB.Ladder:Commit(name, current.rankId, target, officer)
  if not committed then
    self:_Status(err or "the correction failed", true)
    return false
  end

  broadcast(committed)
  self:_Status(string.format("Corrected: %s now holds %d standing.", name, committed.standing))
  self:_Remember(string.format("Corrected %s %d → %d", name, current.standing, committed.standing))
  toast(string.format("%s: %d standing", name, committed.standing))
  refreshAll()
  return true
end

--------------------------------------------------------------------------------
-- Confirm child frame — nuclear rites only (glossary 70)
--------------------------------------------------------------------------------

-- Fails closed: with no confirm frame there is no way to ask, so a nuclear rite is
-- refused rather than performed unsupervised.
function OfficerTab:_Confirm(body, acceptLabel, onAccept)
  local confirm = self.confirm
  if not confirm then
    self:_Status("the confirmation window is missing; nothing was done", true)
    return false
  end
  confirm.body:SetText(body)
  confirm.accept:SetText(acceptLabel)
  confirm.reason:SetText("")
  confirm.onAccept = onAccept
  confirm:Show()
  return true
end

function OfficerTab:_CancelConfirm()
  local confirm = self.confirm
  if not confirm then return false end
  confirm.onAccept = nil
  confirm:Hide()
  return true
end

function OfficerTab:_BuildConfirm(panel)
  local confirm = CreateFrame("Frame", nil, panel, "BackdropTemplate")
  if not confirm then confirm = CreateFrame("Frame", nil, panel) end
  confirm:SetPoint("TOPLEFT", panel, "TOPLEFT", 20, -40)
  confirm:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -20, 60)
  confirm:SetFrameStrata("DIALOG")
  confirm:EnableMouse(true)
  confirm:Hide()

  -- Escape backs out of a nuclear rite. Keyboard input propagates by default so the
  -- reason box and the rest of the UI keep working; only Escape is swallowed.
  confirm:EnableKeyboard(true)
  confirm:SetScript("OnKeyDown", function(frame, key)
    local handled = key == "ESCAPE"
    if frame.SetPropagateKeyboardInput then
      frame:SetPropagateKeyboardInput(not handled)
    end
    if handled then OfficerTab:_CancelConfirm() end
  end)

  -- Whatever closes this frame, the pending rite dies with it.
  confirm:SetScript("OnHide", function(frame) frame.onAccept = nil end)

  if confirm.SetBackdrop then
    confirm:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true,
      tileSize = 32,
      edgeSize = 16,
      insets = { left = 5, right = 5, top = 5, bottom = 5 },
    })
  end

  local body = confirm:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  body:SetPoint("TOPLEFT", confirm, "TOPLEFT", 14, -14)
  body:SetPoint("TOPRIGHT", confirm, "TOPRIGHT", -14, -14)
  body:SetJustifyH("LEFT")
  confirm.body = body

  local reasonLabel = confirm:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  reasonLabel:SetPoint("TOPLEFT", confirm, "TOPLEFT", 14, -58)
  reasonLabel:SetText("Reason (optional, kept on this client)")

  local reason = CreateFrame("EditBox", nil, confirm, "InputBoxTemplate")
  reason:SetPoint("TOPLEFT", confirm, "TOPLEFT", 18, -72)
  reason:SetPoint("TOPRIGHT", confirm, "TOPRIGHT", -18, -72)
  reason:SetHeight(20)
  reason:SetAutoFocus(false)
  reason:SetMaxLetters(80)
  reason:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
  confirm.reason = reason

  local accept = CreateFrame("Button", nil, confirm, "UIPanelButtonTemplate")
  accept:SetWidth(110)
  accept:SetHeight(22)
  accept:SetPoint("BOTTOMRIGHT", confirm, "BOTTOM", -6, 14)
  accept:SetScript("OnClick", function()
    local fn = confirm.onAccept
    local why = confirm.reason:GetText()
    if type(why) == "string" then why = why:gsub("^%s+", ""):gsub("%s+$", "") else why = "" end
    confirm.onAccept = nil
    confirm:Hide()
    if not fn then return end
    -- Scoped to this one rite: _Remember consumes it, and a refused rite drops it.
    OfficerTab.pendingReason = why ~= "" and why or nil
    fn(why)
    OfficerTab.pendingReason = nil
  end)
  confirm.accept = accept

  local cancel = CreateFrame("Button", nil, confirm, "UIPanelButtonTemplate")
  cancel:SetWidth(110)
  cancel:SetHeight(22)
  cancel:SetPoint("BOTTOMLEFT", confirm, "BOTTOM", 6, 14)
  cancel:SetText("Cancel")
  cancel:SetScript("OnClick", function() OfficerTab:_CancelConfirm() end)
  confirm.cancel = cancel

  self.confirm = confirm
end

--------------------------------------------------------------------------------
-- Construction
--------------------------------------------------------------------------------

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
  header:SetText("Pending petitions")

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
  self.evStanding = line(3, "GameFontNormalSmall")
  self.evBreakdown = line(4, "GameFontNormalSmall")

  self.evEvents = {}
  for i = 1, EVIDENCE_EVENTS do
    self.evEvents[i] = line(4 + i, "GameFontDisableSmall")
  end

  local approve = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  approve:SetWidth(140)
  approve:SetHeight(22)
  approve:SetPoint("TOPLEFT", panel, "TOPLEFT", COL_SPLIT, -18 - ((5 + EVIDENCE_EVENTS) * LINE))
  approve:SetText("Approve")
  approve:SetScript("OnClick", function()
    if OfficerTab.selected then OfficerTab:Approve(OfficerTab.selected) end
  end)
  self.approve = approve

  local reject = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  reject:SetWidth(90)
  reject:SetHeight(22)
  reject:SetPoint("LEFT", approve, "RIGHT", 6, 0)
  reject:SetText("Reject")
  reject:SetScript("OnClick", function()
    if OfficerTab.selected then OfficerTab:Reject(OfficerTab.selected) end
  end)
  self.reject = reject
end

function OfficerTab:_BuildRites(panel)
  local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  header:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -126)
  header:SetText("Rites")

  local subjectLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  subjectLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -144)
  subjectLabel:SetText("Subject")

  local subject = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  subject:SetPoint("TOPLEFT", panel, "TOPLEFT", 60, -140)
  subject:SetWidth(120)
  subject:SetHeight(20)
  subject:SetAutoFocus(false)
  subject:SetMaxLetters(40)
  subject:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
  self.subject = subject

  local standingLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  standingLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 194, -144)
  standingLabel:SetText("Standing")

  local standing = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
  standing:SetPoint("TOPLEFT", panel, "TOPLEFT", 254, -140)
  standing:SetWidth(50)
  standing:SetHeight(20)
  standing:SetAutoFocus(false)
  standing:SetMaxLetters(6)
  standing:SetScript("OnEscapePressed", function(box) box:ClearFocus() end)
  self.standingDelta = standing

  local apply = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  apply:SetWidth(60)
  apply:SetHeight(20)
  apply:SetPoint("TOPLEFT", panel, "TOPLEFT", 310, -140)
  apply:SetText("Correct")
  apply:SetScript("OnClick", function() OfficerTab:_OnCorrect() end)
  self.applyStanding = apply

  -- Rank stepper instead of UIDropDownMenu: stock dropdowns are a taint hazard
  -- and five point ranks do not need a menu.
  local demoteLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  demoteLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -170)
  demoteLabel:SetText("Return to")

  local prev = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  prev:SetWidth(22)
  prev:SetHeight(20)
  prev:SetPoint("TOPLEFT", panel, "TOPLEFT", 60, -166)
  prev:SetText("<")
  prev:SetScript("OnClick", function() OfficerTab:_StepDemoteRank(-1) end)

  local rankText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  rankText:SetPoint("TOPLEFT", panel, "TOPLEFT", 86, -170)
  rankText:SetWidth(96)
  rankText:SetJustifyH("CENTER")
  self.demoteRankText = rankText

  local nextBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  nextBtn:SetWidth(22)
  nextBtn:SetHeight(20)
  nextBtn:SetPoint("TOPLEFT", panel, "TOPLEFT", 184, -166)
  nextBtn:SetText(">")
  nextBtn:SetScript("OnClick", function() OfficerTab:_StepDemoteRank(1) end)

  -- Nuclear rites are spaced away from Approve so a fat finger cannot excommunicate
  -- the member it meant to elevate (track 69 zone C grouping).
  local excommunicate = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  excommunicate:SetWidth(116)
  excommunicate:SetHeight(20)
  excommunicate:SetPoint("TOPLEFT", panel, "TOPLEFT", 212, -166)
  excommunicate:SetText("Excommunicate")
  excommunicate:SetScript("OnClick", function() OfficerTab:_OnDemote() end)
  self.excommunicate = excommunicate

  local council = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  council:SetWidth(100)
  council:SetHeight(20)
  council:SetPoint("TOPLEFT", panel, "TOPLEFT", 212, -190)
  council:SetText("Seat Council")
  council:SetScript("OnClick", function() OfficerTab:_OnCouncil() end)
  self.council = council

  local prophet = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  prophet:SetWidth(100)
  prophet:SetHeight(20)
  prophet:SetPoint("TOPLEFT", panel, "TOPLEFT", 318, -190)
  prophet:SetText("Anoint Prophet")
  prophet:SetScript("OnClick", function() OfficerTab:_OnProphet() end)
  self.prophet = prophet

  local seats = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  seats:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -194)
  seats:SetJustifyH("LEFT")
  self.seats = seats

  local status = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  status:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -212)
  status:SetPoint("RIGHT", panel, "RIGHT", -4, 0)
  status:SetJustifyH("LEFT")
  status:SetText("")
  self.status = status
end

function OfficerTab:_BuildRecent(panel)
  local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  header:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -226)
  header:SetText("Recent actions")

  self.recentLines = {}
  for i = 1, RECENT_ROWS do
    local fs = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    fs:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -240 - ((i - 1) * LINE))
    -- Stop short of the right column: the announce strip lives there.
    fs:SetPoint("RIGHT", panel, "RIGHT", -ANNOUNCE_COLUMN, 0)
    fs:SetJustifyH("LEFT")
    fs:SetText("")
    self.recentLines[i] = fs
  end
end

function OfficerTab:_BuildAnnounce(panel)
  -- Glossary 74: procedural label, mirrors ChurchOfBeefDB.ui.announce, default ON.
  local check = CreateFrame("CheckButton", "ChurchOfBeefAnnounceCheck", panel, "UICheckButtonTemplate")
  check:SetWidth(22)
  check:SetHeight(22)
  check:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, -240)
  check:SetScript("OnClick", function(button)
    local enabled = button:GetChecked() and true or false
    if COB.Announce and COB.Announce.SetEnabled then COB.Announce:SetEnabled(enabled) end
    OfficerTab:_Status(enabled
      and "Promotions will be announced to guild chat."
      or "Promotions will not be announced from this client.")
  end)
  self.announceCheck = check

  local label = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("RIGHT", check, "LEFT", -2, 0)
  label:SetJustifyH("RIGHT")
  label:SetText("Announce promotions to guild chat")
  self.announceLabel = label
end

function OfficerTab:OnCreate(panel)
  self.recent = self.recent or {}
  self.selected = nil
  self.pendingReason = nil
  self.demoteRankId = demotableRankIds()[1] or 1

  self:_BuildQueue(panel)
  self:_BuildEvidence(panel)
  self:_BuildRites(panel)
  self:_BuildRecent(panel)
  self:_BuildAnnounce(panel)
  self:_BuildConfirm(panel)
end

--------------------------------------------------------------------------------
-- Click handlers: read the widgets, then hand off to the rite functions
--------------------------------------------------------------------------------

function OfficerTab:_StepDemoteRank(step)
  local ids = demotableRankIds()
  if #ids == 0 then return end
  local index = 1
  for i = 1, #ids do
    if ids[i] == self.demoteRankId then index = i break end
  end
  index = index + step
  if index < 1 then index = 1 end
  if index > #ids then index = #ids end
  self.demoteRankId = ids[index]
  if self.demoteRankText then self.demoteRankText:SetText(title(self.demoteRankId)) end
end

function OfficerTab:_OnCorrect()
  local name = subjectName(self)
  if not name then
    self:_Status("name a subject for the rite", true)
    return
  end
  local raw = self.standingDelta and self.standingDelta:GetText() or nil
  local delta = tonumber(raw)
  if not delta then
    self:_Status("enter a standing change such as 25 or -50", true)
    return
  end

  local current = record(name)
  local before = current and current.standing or 0
  -- A wipe is nuclear (glossary 70); a routine correction is not.
  if delta < 0 and before > 0 and (before + delta) <= 0 then
    self:_Confirm(
      string.format("Wipe all %d standing from %s? Their rank is unchanged.", before, name),
      "Wipe",
      function() OfficerTab:CorrectStanding(name, delta) end)
    return
  end
  self:CorrectStanding(name, delta)
end

function OfficerTab:_OnDemote()
  local name = subjectName(self)
  if not name then
    self:_Status("name a subject for the rite", true)
    return
  end
  local current = record(name)
  local fromTitle = title(current and current.rankId or 1)
  local toTitle = title(self.demoteRankId)
  local rankId = self.demoteRankId
  self:_Confirm(
    string.format("Excommunicate %s from %s, returning them to %s? A guild-chat line is sent unless you opted out.",
      name, fromTitle, toTitle),
    "Excommunicate",
    function() OfficerTab:Demote(name, rankId) end)
end

function OfficerTab:_OnCouncil()
  local name = subjectName(self)
  if not name then
    self:_Status("name a subject for the rite", true)
    return
  end
  local taken, total = councilSeatsTaken()
  self:_Confirm(
    string.format("Seat %s upon the %s? (%d of %s seats filled)",
      name, titleForKind("council"), taken, tostring(total or "?")),
    "Seat",
    function() OfficerTab:AppointCouncil(name) end)
end

function OfficerTab:_OnProphet()
  local name = subjectName(self)
  if not name then
    self:_Status("name a subject for the rite", true)
    return
  end
  self:_Confirm(
    string.format("Anoint %s as %s? Only one Prophet may live.", name, titleForKind("prophet")),
    "Anoint",
    function() OfficerTab:BestowProphet(name) end)
end

--------------------------------------------------------------------------------
-- Refresh
--------------------------------------------------------------------------------

local function breakdownLine(name)
  if not (COB.Scoring and COB.Scoring.GetHistory) then return "Breakdown: none recorded" end
  local history = COB.Scoring:GetHistory(name)
  if #history == 0 then return "Breakdown: none recorded" end
  local totals, order = {}, {}
  for i = 1, #history do
    local source = history[i].source or "?"
    if not totals[source] then
      totals[source] = 0
      order[#order + 1] = source
    end
    totals[source] = totals[source] + (history[i].amount or 0)
  end
  local parts = {}
  for i = 1, #order do
    parts[#parts + 1] = string.format("%s %d", order[i], totals[order[i]])
  end
  return "Breakdown (recent): " .. table.concat(parts, " \194\183 ")
end

function OfficerTab:_RefreshQueue()
  local pending = sortByAge(suggestions())

  -- Auto-select the oldest petition so an officer opening the tab can act at once.
  if self.selected and not findSuggestion(self.selected) then self.selected = nil end
  if not self.selected and pending[1] then
    self.selected = pending[1].name
    if self.subject then self.subject:SetText(self.selected) end
  end

  for i = 1, QUEUE_ROWS do
    local row = self.rows[i]
    local suggestion = pending[i]
    if not suggestion then
      row.frame.subject = nil
      row.label:SetText("")
      row.frame:Hide()
    else
      row.frame:Show()
      row.frame.subject = suggestion.name
      local text = string.format("%s → %s", suggestion.name, title(suggestion.toRankId))
      if suggestion.name == self.selected then
        text = PENDING_COLOR .. "> " .. text .. "|r"
      else
        text = "  " .. text
      end
      row.label:SetText(text)
    end
  end

  if #pending > QUEUE_ROWS then
    self.overflow:SetText(string.format("+%d more awaiting rites", #pending - QUEUE_ROWS))
  elseif #pending == 0 then
    self.overflow:SetText("No pending suggestions.")
  else
    self.overflow:SetText("")
  end

  return pending
end

function OfficerTab:_RefreshEvidence()
  local name = self.selected
  local suggestion = name and findSuggestion(name) or nil

  if not suggestion then
    self.evName:SetText("No petition selected")
    self.evDelta:SetText("")
    self.evStanding:SetText("")
    self.evBreakdown:SetText("")
    for i = 1, EVIDENCE_EVENTS do self.evEvents[i]:SetText("") end
    self.approve:SetText("Approve")
    self.approve:Disable()
    self.reject:Disable()
    return
  end

  self.approve:Enable()
  self.reject:Enable()

  local toTitle = title(suggestion.toRankId)
  self.evName:SetText(suggestion.name)
  self.evDelta:SetText(string.format("%s → %s", title(suggestion.fromRankId), toTitle))
  self.evStanding:SetText(string.format("Standing %d / %d (threshold)",
    suggestion.standing or 0, suggestion.threshold or 0))
  self.evBreakdown:SetText(breakdownLine(suggestion.name))

  local history = (COB.Scoring and COB.Scoring.GetHistory)
    and COB.Scoring:GetHistory(suggestion.name) or {}
  for i = 1, EVIDENCE_EVENTS do
    local entry = history[i]
    if entry then
      self.evEvents[i]:SetText(string.format("· +%d %s", entry.amount or 0, entry.source or "?"))
    else
      self.evEvents[i]:SetText(i == 1 and "· no recorded events yet" or "")
    end
  end

  -- The button names the destination rank, which is what makes a modal unnecessary.
  self.approve:SetText("Approve: " .. toTitle)
end

function OfficerTab:_RefreshRites()
  if self.demoteRankText then self.demoteRankText:SetText(title(self.demoteRankId)) end

  local taken, total = councilSeatsTaken()
  if total then
    self.seats:SetText(string.format("Council %d / %d seats", taken, total))
  else
    self.seats:SetText("")
  end

  if self.announceCheck then
    local enabled = not COB.Announce or COB.Announce:IsEnabled()
    self.announceCheck:SetChecked(enabled and true or false)
  end
end

function OfficerTab:_RefreshRecent()
  for i = 1, RECENT_ROWS do
    local entry = self.recent[i]
    if entry then
      self.recentLines[i]:SetText(entry)
    else
      self.recentLines[i]:SetText(i == 1 and "No rites performed this session." or "")
    end
  end
end

function OfficerTab:OnRefresh(panel)
  self:_RefreshQueue()
  self:_RefreshEvidence()
  self:_RefreshRites()
  self:_RefreshRecent()
end

if COB.UI and COB.UI.RegisterTab then
  COB.UI:RegisterTab({ name = "officer", label = "Officer", officerOnly = true, owner = OfficerTab })
end
