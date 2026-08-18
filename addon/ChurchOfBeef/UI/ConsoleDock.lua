ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event-only Pope dock (Bible §18.1 collapsible, §19.1). Titled
-- DIRECTOR CONSOLE. Shown only while Runtime is not QUIET and the
-- local player is the registered Pope. Stock SANCTION calls
-- Console:Sanction when present. Expand calls Console:Show.
-- ESC Hide()s ChurchOfBeefConsoleDock via UISpecialFrames (deduped).
-- Init remounts a missing OnHide before rememberSpecial then
-- Refresh when the frame already exists. Refresh, Show, and Hide
-- remount rememberSpecial when the frame already exists. Hide
-- remounts a missing OnHide before rememberSpecial then
-- paint(false). Show remounts a missing OnHide before
-- rememberSpecial. Refresh remounts a missing OnHide before
-- rememberSpecial. OnHide (after create-time
-- Hide) remembers Runtime eventId while the event is live and
-- sets lastView.shown false. Refresh stays hidden while mayShow
-- and that eventId is still current. A new eventId or QUIET / nil
-- clears dismiss. Show() clears dismiss.
-- Hide is not EndEvent. No Quiet chrome. No whisper fan-out. No cue.
-- No congregation bar. SANCTION wears Theme:Texture plate_verb /
-- hover / pressed as SetNormalTexture / SetHighlightTexture /
-- SetPushedTexture. Expand stays stock. No title-bar seal here.
local ConsoleDock = {
  MODE = "Event",
}
COB.ConsoleDock = ConsoleDock

local FRAME_NAME = "ChurchOfBeefConsoleDock"
local TITLE = "DIRECTOR CONSOLE"
local WIDTH, HEIGHT = 260, 72
local SANCTION_W, EXPAND_W, BTN_H = 140, 80, 28
local DEFAULT_POINT = "BOTTOMLEFT"
local DEFAULT_X, DEFAULT_Y = 16, 80

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

local frame = nil
local lastView = nil
local dismissedEventId = nil

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function runtimeSnapshot()
  if not COB.Runtime or type(COB.Runtime.Snapshot) ~= "function" then
    return nil
  end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then
    return nil
  end
  return snap
end

local function runtimeState()
  local snap = runtimeSnapshot()
  if not snap or type(snap.state) ~= "string" then
    return "QUIET"
  end
  return snap.state
end

local function currentEventId()
  local snap = runtimeSnapshot()
  if not snap then return nil end
  local eventId = snap.eventId
  if type(eventId) ~= "number" then return nil end
  return eventId
end

local function localSender()
  if COB.Group and type(COB.Group.PlayerName) == "function" then
    return COB.Group.PlayerName()
  end
  if COB.Net and type(COB.Net.PlayerName) == "function" then
    return COB.Net:PlayerName()
  end
  if type(UnitName) == "function" then
    return UnitName("player")
  end
  return nil
end

local function isLocalPope()
  local Sender = COB.Sender
  if not Sender or type(Sender.IsRegisteredPope) ~= "function" then
    return false
  end
  local name = localSender()
  if type(name) ~= "string" or name == "" then
    return false
  end
  return Sender:IsRegisteredPope(name) == true
end

local function eventLive()
  return runtimeState() ~= "QUIET"
end

local function mayShow()
  return eventLive() and isLocalPope()
end

local function stayDismissed()
  if not mayShow() then return false end
  local eventId = currentEventId()
  if type(eventId) ~= "number" then return false end
  return dismissedEventId ~= nil and dismissedEventId == eventId
end

local function hiddenView()
  return {
    shown = false,
    title = TITLE,
    mode = "Event",
    state = runtimeState(),
    pope = isLocalPope(),
  }
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
  db.consoleDock = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(widget)
  local db = uiDb()
  local p = db and db.consoleDock
  widget:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    widget:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    widget:SetPoint(DEFAULT_POINT, UIParent, DEFAULT_POINT, DEFAULT_X, DEFAULT_Y)
  end
end

local function paint(shown)
  local visible = shown and true or false
  lastView = {
    shown = visible,
    title = TITLE,
    mode = "Event",
    state = runtimeState(),
    pope = isLocalPope(),
  }
  if not frame then return end
  if visible then
    frame:Show()
  else
    frame:Hide()
  end
end

local function callConsole(method)
  local Console = COB.Console
  if not Console or type(Console[method]) ~= "function" then
    return
  end
  Console[method](Console)
end

local function stockButton(parent, label, width, onClick)
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btn:SetWidth(width)
  btn:SetHeight(BTN_H)
  btn:SetText(label)
  btn:SetScript("OnClick", onClick)
  return btn
end

local function themeTexture(name)
  local Theme = COB.Theme
  if type(Theme) ~= "table" or type(Theme.Texture) ~= "function" then
    return nil
  end
  return Theme:Texture(name)
end

-- Iron plate on SANCTION only. Paths come from Theme:Texture.
-- Missing Theme leaves stock UIPanelButtonTemplate chrome.
local function plateVerb(btn)
  if not btn then return btn end
  local normal = themeTexture("plate_verb")
  local hover = themeTexture("plate_verb_hover")
  local pressed = themeTexture("plate_verb_pressed")
  if type(normal) == "string" and type(btn.SetNormalTexture) == "function" then
    pcall(btn.SetNormalTexture, btn, normal)
    btn._cobNormalTexture = normal
  end
  if type(hover) == "string" and type(btn.SetHighlightTexture) == "function" then
    pcall(btn.SetHighlightTexture, btn, hover)
    btn._cobHighlightTexture = hover
  end
  if type(pressed) == "string" and type(btn.SetPushedTexture) == "function" then
    pcall(btn.SetPushedTexture, btn, pressed)
    btn._cobPushedTexture = pressed
  end
  return btn
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

-- ESC Hide via UISpecialFrames bypasses ConsoleDock:Hide. Restore a
-- missing OnHide; never replace an existing script. Sync lastView
-- shown false and live dismissedEventId. Do not wire OnShow.
local function wireDockOnHide(widget)
  if not widget then return end
  if type(widget.SetScript) ~= "function" then return end
  local existing = type(widget.GetScript) == "function" and widget:GetScript("OnHide")
  if existing then return end
  widget:SetScript("OnHide", function()
    if lastView == nil then lastView = hiddenView() end
    lastView.shown = false
    if eventLive() then
      local eventId = currentEventId()
      if type(eventId) == "number" then
        dismissedEventId = eventId
      end
    end
  end)
end

local function build()
  if type(CreateFrame) ~= "function" then return nil end
  local widget = CreateFrame("Frame", FRAME_NAME, UIParent, "BasicFrameTemplate")
  widget:SetFrameStrata("MEDIUM")
  widget:SetToplevel(true)
  widget:EnableMouse(true)
  widget:SetMovable(true)
  widget:SetClampedToScreen(true)
  widget:SetWidth(WIDTH)
  widget:SetHeight(HEIGHT)
  restorePoint(widget)
  widget:Hide()

  -- After the initial Hide so create does not fire OnHide teardown.
  wireDockOnHide(widget)

  if widget.TitleText and widget.TitleText.SetText then
    widget.TitleText:SetText(TITLE)
  end
  if widget.CloseButton and widget.CloseButton.Hide then
    widget.CloseButton:Hide()
  end

  local titleBar = CreateFrame("Frame", nil, widget)
  titleBar:SetHeight(22)
  titleBar:SetPoint("TOPLEFT", widget, "TOPLEFT", 8, -2)
  titleBar:SetPoint("TOPRIGHT", widget, "TOPRIGHT", -8, -2)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() widget:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    widget:StopMovingOrSizing()
    savePoint(widget)
  end)
  widget.TitleBar = titleBar

  local sanction = stockButton(widget, "SANCTION", SANCTION_W, function()
    callConsole("Sanction")
  end)
  plateVerb(sanction)
  sanction:SetPoint("BOTTOMLEFT", widget, "BOTTOMLEFT", 12, 10)
  widget.Sanction = sanction

  local expand = stockButton(widget, "Expand", EXPAND_W, function()
    callConsole("Show")
  end)
  expand:SetPoint("LEFT", sanction, "RIGHT", 8, 0)
  widget.Expand = expand

  rememberSpecial(FRAME_NAME)
  return widget
end

function ConsoleDock:Init()
  if not frame then
    frame = build()
  end
  if not frame then return nil end
  wireDockOnHide(frame)
  rememberSpecial(FRAME_NAME)
  self:Refresh()
  return frame
end

function ConsoleDock:GetView()
  if lastView == nil then lastView = hiddenView() end
  return deepcopy(lastView)
end

function ConsoleDock:Refresh()
  if not frame then
    if type(CreateFrame) == "function" then
      frame = build()
    end
  end
  if not frame then
    lastView = hiddenView()
    lastView.shown = false
    lastView.pope = isLocalPope()
    if not stayDismissed() then
      dismissedEventId = nil
    end
    return self:GetView()
  end
  wireDockOnHide(frame)
  rememberSpecial(FRAME_NAME)
  if not mayShow() then
    dismissedEventId = nil
    paint(false)
    dismissedEventId = nil
    return self:GetView()
  end
  if stayDismissed() then
    paint(false)
    return self:GetView()
  end
  dismissedEventId = nil
  paint(true)
  return self:GetView()
end

function ConsoleDock:Show()
  dismissedEventId = nil
  if not frame then
    self:Init()
  end
  if not frame then
    lastView = hiddenView()
    return false
  end
  wireDockOnHide(frame)
  rememberSpecial(FRAME_NAME)
  if not mayShow() then
    paint(false)
    return false
  end
  paint(true)
  return true
end

function ConsoleDock:Hide()
  if frame then
    wireDockOnHide(frame)
    rememberSpecial(FRAME_NAME)
  end
  paint(false)
end

function ConsoleDock:ResetForTests()
  if not COB._IN_TEST then return false end
  dismissedEventId = nil
  lastView = hiddenView()
  lastView.shown = false
  if frame then
    frame:Hide()
    frame = nil
  end
  dismissedEventId = nil
  return true
end
