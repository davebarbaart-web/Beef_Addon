ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode congregation input (Bible §13.1, §18.5, §19.1, §20.3).
-- Display terminals plus input devices. Inputs never trigger public theater.
-- Whisper destination is injected; this file does not look up a Pope name.
-- Catchup calls Net:RequestSnapshot on that target only.
-- Stock functional chrome. Quiet Mode: hidden, verbs return false.
-- Confess box type-guards SetMultiLine(true) and OnEscapePressed to ClearFocus;
-- the box does not Hide the panel. Missing SetScript / ClearFocus / SetMultiLine
-- no-op. Hide stays Runtime Quiet, not box ESC.
-- TitleBar drag persist writes ChurchOfBeefDB.ui.inputs as a flat point table.
-- Missing ChurchOfBeefDB restores the default; save no-ops. ResetForTests
-- does not wipe SavedVariables. Root stays SetMovable + SetClampedToScreen;
-- drag is on TitleBar, not the root.
-- Petition may pass opponent from the current target name when Names.Same
-- is false versus the whisper dest and the local player. Both unit-name
-- reads are pcalled. A missing unit-name API omits opponent. The target
-- name is trimmed (^%s+ / %s+$) before Same; empty after trim omits.
-- A failed player pcall or a non-string player name omits opponent
-- (fail-closed). The player name is trimmed (^%s+ / %s+$) like the
-- target; empty after trim omits. Dest-same and player-same still omit.
-- SetInputTarget trims the whisper dest (Names.Trim, fallback ^%s+ /
-- %s+$). Empty after trim is no target. readyToSend / Petition /
-- Catchup / Confess keep. No Pope-name lookup.
-- Confess trims optional text (Names.Trim, fallback ^%s+ / %s+$).
-- Empty after trim omits fields.text and still sends. Dest /
-- readyToSend stay. Opponent trim stays. No Pope-name lookup.
-- paintHidden blanks leftover confessBox text (SetText("") if present).
-- Dest / inputTarget persist. Width / ESC ClearFocus stay.
-- Confess box sits TOP / -14 so it stays fully below the 12px TitleBar.
local Inputs = {
  MODE = "Event",
}
COB.Inputs = Inputs

local FRAME_NAME = "ChurchOfBeefInputs"
local WIDTH, HEIGHT = 328, 72
local BTN_W, BTN_H = 96, 22
local DEFAULT_POINT = "BOTTOM"
local DEFAULT_X, DEFAULT_Y = 0, 80

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

local inputTarget = nil
local localCharacterId = nil
local lastView = nil

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function eventLive()
  local Runtime = COB.Runtime
  if not Runtime or type(Runtime.Snapshot) ~= "function" then return false end
  local snap = Runtime:Snapshot()
  return type(snap) == "table" and snap.state ~= nil and snap.state ~= "QUIET"
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
  if Inputs.frame then
    local box = Inputs.frame.confessBox
    if box and box.SetText then box:SetText("") end
    Inputs.frame:Hide()
  end
  lastView = hiddenView()
end

local function paintShown()
  if Inputs.frame then Inputs.frame:Show() end
  lastView = currentView(true)
end

local function stockButton(parent, label, onClick)
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btn:SetWidth(BTN_W)
  btn:SetHeight(BTN_H)
  btn:SetText(label)
  btn:SetScript("OnClick", onClick)
  return btn
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
  local widget = CreateFrame("Frame", FRAME_NAME, UIParent)
  widget:SetWidth(WIDTH)
  widget:SetHeight(HEIGHT)
  widget:SetClampedToScreen(true)
  widget:EnableMouse(true)
  widget:SetMovable(true)
  restorePoint(widget)

  local bg = widget:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(widget)
  if bg.SetTexture then
    bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
  end
  if bg.SetVertexColor and COB.Theme and COB.Theme.Color then
    local r, g, b = COB.Theme:Color("charcoal")
    if r then bg:SetVertexColor(r, g, b, 1) end
  end

  local titleBar = CreateFrame("Frame", nil, widget)
  titleBar:SetHeight(12)
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

  local box = CreateFrame("EditBox", nil, widget, "InputBoxTemplate")
  box:SetWidth(WIDTH - 24)
  box:SetHeight(22)
  box:SetPoint("TOP", widget, "TOP", 0, -14)
  box:SetAutoFocus(false)
  if type(box.SetMultiLine) == "function" then
    box:SetMultiLine(true)
  end
  if type(box.SetScript) == "function" then
    box:SetScript("OnEscapePressed", function(self)
      if type(self.ClearFocus) == "function" then
        self:ClearFocus()
      end
    end)
  end
  widget.confessBox = box

  local petition = stockButton(widget, "Petition", function()
    Inputs:Petition()
  end)
  petition:SetPoint("BOTTOMLEFT", widget, "BOTTOMLEFT", 12, 10)

  local catchup = stockButton(widget, "Catch up", function()
    Inputs:Catchup()
  end)
  catchup:SetPoint("BOTTOM", widget, "BOTTOM", 0, 10)

  local confess = stockButton(widget, "Confess", function()
    Inputs:Confess()
  end)
  confess:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -12, 10)

  widget:Hide()
  return widget
end

local function readyToSend()
  if not eventLive() then
    paintHidden()
    return false
  end
  if type(inputTarget) ~= "string" or inputTarget == "" then
    return false, "no target"
  end
  if type(localCharacterId) ~= "number" then
    return false, "no character"
  end
  return true
end

function Inputs:Init()
  if not self.frame then
    if type(CreateFrame) ~= "function" then return nil end
    self.frame = build()
  end
  if eventLive() then
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
  if COB.Names.Same(targetName, inputTarget) then return nil end
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
  local fields = { characterId = localCharacterId }
  local opponent = petitionOpponent()
  if opponent then
    fields.opponent = opponent
  end
  return COB.Net:SendPetition(fields, inputTarget)
end

function Inputs:Catchup()
  if not eventLive() then
    paintHidden()
    return false
  end
  if type(inputTarget) ~= "string" or inputTarget == "" then
    return false, "no target"
  end
  if not (COB.Net and COB.Net.RequestSnapshot) then
    return false, "no net"
  end
  return COB.Net:RequestSnapshot(inputTarget)
end

function Inputs:Confess(text)
  local ok, why = readyToSend()
  if not ok then return false, why end
  if type(text) ~= "string" then
    local box = self.frame and self.frame.confessBox
    if box and box.GetText then
      text = box:GetText()
    end
  end
  local trimmed
  if COB.Names and type(COB.Names.Trim) == "function" then
    trimmed = COB.Names.Trim(text)
  elseif type(text) == "string" then
    trimmed = text:gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed == "" then
      trimmed = nil
    end
  end
  if not (COB.Net and COB.Net.SendConfession) then
    return false, "no net"
  end
  local fields = { characterId = localCharacterId }
  if type(trimmed) == "string" then
    fields.text = trimmed
  end
  return COB.Net:SendConfession(fields, inputTarget)
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
  if eventLive() then
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
  if not eventLive() then
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
  lastView = hiddenView()
  if self.frame then
    local box = self.frame.confessBox
    if box and box.SetText then box:SetText("") end
    self.frame:Hide()
    self.frame = nil
  end
  return true
end
