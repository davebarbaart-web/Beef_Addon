ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode congregation input (Bible §13.1, §18.5, §19.1, §20.3).
-- Display terminals plus input devices. Inputs never trigger public theater.
-- Face: Ask to fight. Hidden on a listed Pope (Sender:IsRegisteredPope).
-- The whisper destination is the bound target when one is set; otherwise
-- the same helper as Net defaultDest() — last accepted STATE sender, then
-- the first listed Pope. The recipient line uses that helper so it cannot
-- say List[1] while the whisper goes to _lastStateSender. This file never
-- looks up a Pope by guild roster and never reads SavedVariables for one.
-- Stock functional chrome. Quiet Mode: hidden. Ask returns false.
-- TitleBar drag persist writes ChurchOfBeefDB.ui.inputs as a flat point table.
-- Missing ChurchOfBeefDB restores the default; save no-ops. ResetForTests
-- does not wipe SavedVariables. Root stays SetMovable + SetClampedToScreen;
-- drag is on TitleBar, not the root.
-- Ask may pass opponent from the current target name when Names.Same
-- is false versus the effective dest and the local player. Both unit-name
-- reads are pcalled. A missing unit-name API omits opponent. The target
-- name is trimmed (^%s+ / %s+$) before Same; empty after trim omits.
-- A failed player pcall or a non-string player name omits opponent
-- (fail-closed). The player name is trimmed (^%s+ / %s+$) like the
-- target; empty after trim omits. Dest-same and player-same still omit.
-- SetInputTarget trims the whisper dest (Names.Trim, fallback ^%s+ /
-- %s+$). Empty after trim is no target.
-- Fireable face reasons (no toast): not in a guild; send failed; you
-- already asked (no TTL; event-scoped); this is a Knighting, not a fight.
-- After a successful send the strip says asked / waiting. Zip-fresh empty
-- store does not mint a character id; the closed wire may carry a
-- placeholder id that apply ignores. No Store mint.
local Inputs = {
  MODE = "Event",
}
COB.Inputs = Inputs

local FRAME_NAME = "ChurchOfBeefInputs"
local WIDTH, HEIGHT = 360, 64
local BTN_W, BTN_H = 96, 22
local DEFAULT_POINT = "BOTTOM"
local DEFAULT_X, DEFAULT_Y = 0, 80
-- Closed-wire INPUT still requires an id. Apply ignores it (Task 6).
local PLACEHOLDER_CHARACTER_ID = 1

local FACE = {
  ASK = "Ask to fight",
  NO_RECIPIENT = "No recipient",
  NOT_IN_GUILD = "Not in a guild.",
  SEND_FAILED = "Send failed.",
  ALREADY_ASKED = "You already asked.",
  KNIGHTING = "This is a Knighting, not a fight.",
  WAITING = "Asked. Waiting.",
}

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

local inputTarget = nil
local localCharacterId = nil
local askedWaiting = false
local lastView = nil
local eventLive

local function setButtonEnabled(button, enabled)
  if not button then return end
  if enabled then
    if button.Enable then button:Enable() end
  elseif button.Disable then
    button:Disable()
  end
end

local function setReason(text)
  local frame = Inputs.frame
  if frame and frame.ReasonText then
    frame.ReasonText:SetText(text or "")
  end
end

-- The first listed Pope when one is present (the registered-Pope list).
-- Fallback only when Net:DefaultDest is missing — never a roster or SV read.
local function listedPope()
  local popes = COB.Popes
  local list = type(popes) == "table" and popes.List or nil
  if type(list) ~= "table" then return nil end
  local first = list[1]
  if type(first) == "string" and first ~= "" then return first end
  return nil
end

-- Same dest SendPetition uses: bound target, else Net defaultDest().
local function petitionDest()
  if type(inputTarget) == "string" and inputTarget ~= "" then
    return inputTarget
  end
  if COB.Net and type(COB.Net.DefaultDest) == "function" then
    local dest = COB.Net:DefaultDest()
    if type(dest) == "string" and dest ~= "" then
      return dest
    end
  end
  return listedPope()
end

local function localPlayerName()
  if type(UnitName) ~= "function" then return nil end
  local ok, name = pcall(UnitName, "player")
  if not ok then return nil end
  if COB.Names and type(COB.Names.Trim) == "function" then
    return COB.Names.Trim(name)
  end
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" then return nil end
  return name
end

local function isLocalPope()
  local Sender = COB.Sender
  if not Sender or type(Sender.IsRegisteredPope) ~= "function" then
    return false
  end
  return Sender:IsRegisteredPope(localPlayerName()) == true
end

local function inGuild()
  if type(IsInGuild) ~= "function" then return false end
  local ok, result = pcall(IsInGuild)
  return ok and result and true or false
end

eventLive = function()
  local Runtime = COB.Runtime
  if not Runtime or type(Runtime.Snapshot) ~= "function" then return false end
  local snap = Runtime:Snapshot()
  return type(snap) == "table" and snap.state ~= nil and snap.state ~= "QUIET"
end

local function isKnighting()
  local Runtime = COB.Runtime
  if not Runtime or type(Runtime.Snapshot) ~= "function" then return false end
  local snap = Runtime:Snapshot()
  if type(snap) ~= "table" then return false end
  if snap.state ~= "RITE" and snap.state ~= "CONSEQUENCE" then return false end
  return snap.riteType == "Knighting"
end

local function shouldShow()
  return eventLive() and not isLocalPope()
end

local function paintAvailability()
  local frame = Inputs.frame
  if not frame then return end
  local dest = petitionDest()
  if frame.TargetText then
    frame.TargetText:SetText(dest and ("To: " .. dest) or FACE.NO_RECIPIENT)
  end
  local live = shouldShow()
  local reason = ""
  local enable = false
  if live then
    if isKnighting() then
      reason = FACE.KNIGHTING
    elseif askedWaiting then
      reason = FACE.WAITING
    elseif not inGuild() then
      reason = FACE.NOT_IN_GUILD
    elseif dest then
      enable = true
    end
  end
  setReason(reason)
  setButtonEnabled(frame.PetitionButton, enable)
end

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function currentView(shown)
  return {
    shown = shown and true or false,
    mode = "Event",
    target = inputTarget,
    characterId = localCharacterId,
  }
end

local function hiddenView()
  return currentView(false)
end

local function paintHidden()
  if not eventLive() then
    askedWaiting = false
  end
  if Inputs.frame then
    Inputs.frame:Hide()
  end
  paintAvailability()
  lastView = hiddenView()
end

local function paintShown()
  if Inputs.frame then Inputs.frame:Show() end
  paintAvailability()
  lastView = currentView(true)
end

local SCAN_FONT = "GameFontHighlight"

local function stockButton(parent, label, onClick)
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btn:SetWidth(BTN_W)
  btn:SetHeight(BTN_H)
  btn:SetText(label)
  if type(btn.SetNormalFontObject) == "function" then
    btn:SetNormalFontObject(SCAN_FONT)
  end
  if type(btn.SetHighlightFontObject) == "function" then
    btn:SetHighlightFontObject(SCAN_FONT)
  end
  local fs = type(btn.GetFontString) == "function" and btn:GetFontString()
  if fs and type(fs.SetFontObject) == "function" then
    fs:SetFontObject(SCAN_FONT)
  end
  btn:SetScript("OnClick", onClick)
  return btn
end

local function wireTooltip(button, title, detail)
  if not button or not button.SetScript then return end
  button:SetScript("OnEnter", function(self)
    if type(GameTooltip) ~= "table" then return end
    if GameTooltip.SetOwner then GameTooltip:SetOwner(self, "ANCHOR_TOP") end
    if GameTooltip.SetText then GameTooltip:SetText(title, 1, 0.82, 0) end
    if GameTooltip.AddLine then GameTooltip:AddLine(detail, 0.8, 0.8, 0.8, true) end
    if GameTooltip.Show then GameTooltip:Show() end
  end)
  button:SetScript("OnLeave", function()
    if type(GameTooltip) == "table" and GameTooltip.Hide then GameTooltip:Hide() end
  end)
end

local function uiDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

local function savePoint(widget)
  local db = uiDb()
  if not db then return end
  local point, _, relativePoint, x, y = widget:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  db.inputs = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(widget)
  local db = uiDb()
  local p = db and db.inputs
  widget:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    widget:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    widget:SetPoint(DEFAULT_POINT, UIParent, DEFAULT_POINT, DEFAULT_X, DEFAULT_Y)
  end
end

local function build()
  local widget = CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
  widget:SetWidth(WIDTH)
  widget:SetHeight(HEIGHT)
  widget:SetClampedToScreen(true)
  widget:EnableMouse(true)
  widget:SetMovable(true)
  restorePoint(widget)

  if not (COB.Theme and COB.Theme.ApplyBackdrop
      and COB.Theme:ApplyBackdrop(widget, "tooltip", "charcoal", "gold", 0.96)) then
    local bg = widget:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(widget)
    local path = COB.Theme and COB.Theme.Texture and COB.Theme:Texture("stock_tooltip_bg")
    if bg.SetTexture then bg:SetTexture(path or "Interface\\Tooltips\\UI-Tooltip-Background") end
    if bg.SetVertexColor then bg:SetVertexColor(0.06, 0.055, 0.05, 0.96) end
  end

  local titleBar = CreateFrame("Frame", nil, widget)
  titleBar:SetHeight(22)
  titleBar:SetPoint("TOPLEFT", widget, "TOPLEFT", 0, 0)
  titleBar:SetPoint("TOPRIGHT", widget, "TOPRIGHT", 0, 0)
  titleBar:EnableMouse(true)
  if titleBar.RegisterForDrag then
    titleBar:RegisterForDrag("LeftButton")
  end
  titleBar:SetScript("OnDragStart", function()
    if widget.StartMoving then widget:StartMoving() end
  end)
  titleBar:SetScript("OnDragStop", function()
    if widget.StopMovingOrSizing then widget:StopMovingOrSizing() end
    savePoint(widget)
  end)
  widget.TitleBar = titleBar

  local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  title:SetPoint("LEFT", titleBar, "LEFT", 12, 0)
  title:SetText(FACE.ASK)
  widget.HeaderText = title

  local targetText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  targetText:SetPoint("RIGHT", titleBar, "RIGHT", -12, 0)
  targetText:SetText(FACE.NO_RECIPIENT)
  widget.TargetText = targetText

  local petition = stockButton(widget, FACE.ASK, function()
    Inputs:Petition()
  end)
  petition:SetPoint("BOTTOMLEFT", widget, "BOTTOMLEFT", 12, 10)
  widget.PetitionButton = petition
  wireTooltip(petition, FACE.ASK,
    "Ask the Pope to consider you for tonight's sanctioned duel (a Beef Gora). Targeting another player names them when that name is already written; an unknown name does not refuse the ask.")

  local reason = widget:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  reason:SetPoint("LEFT", petition, "RIGHT", 8, 0)
  reason:SetPoint("RIGHT", widget, "RIGHT", -12, 10)
  if reason.SetJustifyH then reason:SetJustifyH("LEFT") end
  reason:SetText("")
  widget.ReasonText = reason

  if type(widget.RegisterEvent) == "function" then
    widget:RegisterEvent("DISPLAY_SIZE_CHANGED")
    widget:RegisterEvent("UI_SCALE_CHANGED")
    if type(widget.SetScript) == "function" then
      widget:SetScript("OnEvent", function()
        restorePoint(widget)
      end)
    end
  end

  widget:Hide()
  return widget
end

local function readyToSend()
  if isLocalPope() then
    paintHidden()
    return false
  end
  if not eventLive() then
    paintHidden()
    return false
  end
  if isKnighting() then
    paintAvailability()
    return false, "this is a Knighting, not a fight"
  end
  if askedWaiting then
    setReason(FACE.ALREADY_ASKED)
    setButtonEnabled(Inputs.frame and Inputs.frame.PetitionButton, false)
    return false, "you already asked"
  end
  if not inGuild() then
    paintAvailability()
    return false, "not in a guild"
  end
  if not petitionDest() then
    paintAvailability()
    return false, "no target"
  end
  return true
end

function Inputs:Init()
  if not self.frame then
    if type(CreateFrame) ~= "function" then return nil end
    self.frame = build()
  end
  if shouldShow() then
    paintShown()
  else
    paintHidden()
  end
  return self.frame
end

function Inputs:SetInputTarget(name)
  local trimmed
  if COB.Names and type(COB.Names.Trim) == "function" then
    trimmed = COB.Names.Trim(name)
  elseif type(name) == "string" then
    trimmed = name:gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed == "" then
      trimmed = nil
    end
  end
  if type(trimmed) == "string" then
    inputTarget = trimmed
  else
    inputTarget = nil
  end
  if lastView then
    lastView.target = inputTarget
  end
  paintAvailability()
end

function Inputs:SetLocalCharacterId(id)
  if type(id) == "number" then
    localCharacterId = id
  else
    localCharacterId = nil
  end
  if lastView then
    lastView.characterId = localCharacterId
  end
  paintAvailability()
end

local function petitionOpponent()
  if type(UnitName) ~= "function" then return nil end
  local tok, targetName = pcall(UnitName, "target")
  local pok, playerName = pcall(UnitName, "player")
  if not tok or type(targetName) ~= "string" then
    return nil
  end
  targetName = targetName:gsub("^%s+", ""):gsub("%s+$", "")
  if targetName == "" then
    return nil
  end
  if not (COB.Names and type(COB.Names.Same) == "function") then
    return nil
  end
  if COB.Names.Same(targetName, petitionDest()) then return nil end
  if not pok or type(playerName) ~= "string" then return nil end
  playerName = playerName:gsub("^%s+", ""):gsub("%s+$", "")
  if type(playerName) ~= "string" or playerName == "" then return nil end
  if COB.Names.Same(targetName, playerName) then return nil end
  return targetName
end

function Inputs:Petition()
  local ok, why = readyToSend()
  if not ok then return false, why end
  if not (COB.Net and COB.Net.SendPetition) then
    return false, "no net"
  end
  local dest = petitionDest()
  local characterId = localCharacterId
  if type(characterId) ~= "number" then
    characterId = PLACEHOLDER_CHARACTER_ID
  end
  local fields = { characterId = characterId }
  local opponent = petitionOpponent()
  if opponent then
    fields.opponent = opponent
  end
  local sent, sendWhy = COB.Net:SendPetition(fields, dest)
  if sent then
    askedWaiting = true
    setReason(FACE.WAITING)
    setButtonEnabled(self.frame and self.frame.PetitionButton, false)
    return true
  end
  setReason(FACE.SEND_FAILED)
  setButtonEnabled(self.frame and self.frame.PetitionButton, false)
  if sendWhy == "not in a guild" then
    setReason(FACE.NOT_IN_GUILD)
    return false, "not in a guild"
  end
  return false, "send failed"
end

function Inputs:GetView()
  if lastView == nil then lastView = hiddenView() end
  return deepcopy(lastView)
end

function Inputs:Refresh()
  if not self.frame then
    self:Init()
    return self:GetView()
  end
  if shouldShow() then
    paintShown()
  else
    paintHidden()
  end
  return self:GetView()
end

function Inputs:Show()
  if not self.frame then
    self:Init()
  end
  if not self.frame then return false end
  if not shouldShow() then
    paintHidden()
    return false
  end
  paintShown()
  return true
end

function Inputs:Hide()
  paintHidden()
  return true
end

function Inputs:ResetForTests()
  if not COB._IN_TEST then return false end
  inputTarget = nil
  localCharacterId = nil
  askedWaiting = false
  lastView = hiddenView()
  if self.frame then
    self.frame:Hide()
    self.frame = nil
  end
  return true
end
