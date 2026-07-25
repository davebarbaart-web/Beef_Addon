-- Widget stubs for desktop UI tests. Models only the behaviour the suite asserts
-- on (shown state, anchors, scripts, children); every other widget method is an
-- accepted no-op, the same way the real client ignores what we never call.
local M = {}

local widgetMethods = {}

local widgetMeta = {
  __index = function(widget, key)
    local method = widgetMethods[key]
    if method then return method end
    local noop = function() end
    rawset(widget, key, noop)
    return noop
  end,
}

local function newWidget(frameType, name, parent)
  local widget = {
    _type = frameType,
    _name = name,
    _parent = parent,
    _shown = true,
    _points = {},
    _scripts = {},
    _children = {},
    _events = {},
    _regions = {},
  }
  setmetatable(widget, widgetMeta)
  if parent and parent._children then
    parent._children[#parent._children + 1] = widget
  end
  return widget
end

-- The client only fires OnShow/OnHide on a real transition; mirror that so the
-- addon's persistence hooks are exercised the same way.
function widgetMethods:Show()
  if self._shown then return end
  self._shown = true
  local fn = self._scripts.OnShow
  if fn then fn(self) end
end

function widgetMethods:Hide()
  if not self._shown then return end
  self._shown = false
  local fn = self._scripts.OnHide
  if fn then fn(self) end
end
function widgetMethods:IsShown() return self._shown end
function widgetMethods:SetShown(shown) self._shown = shown and true or false end
function widgetMethods:GetName() return self._name end

function widgetMethods:SetPoint(point, a2, a3, a4, a5)
  local entry = { point = point }
  if type(a2) == "table" then
    entry.relativeTo = a2
    entry.relativePoint = a3 or point
    entry.x = a4 or 0
    entry.y = a5 or 0
  elseif type(a2) == "number" then
    entry.relativePoint = point
    entry.x = a2
    entry.y = a3 or 0
  else
    entry.relativePoint = a2 or point
    entry.x = a3 or 0
    entry.y = a4 or 0
  end
  self._points[#self._points + 1] = entry
end

function widgetMethods:ClearAllPoints()
  for i = #self._points, 1, -1 do self._points[i] = nil end
end

function widgetMethods:SetAllPoints(other)
  self._points[#self._points + 1] = { point = "ALL", relativeTo = other }
end

function widgetMethods:GetPoint(index)
  local entry = self._points[index or 1]
  if not entry then return nil end
  return entry.point, entry.relativeTo, entry.relativePoint, entry.x, entry.y
end

function widgetMethods:SetScript(name, fn) self._scripts[name] = fn end
function widgetMethods:GetScript(name) return self._scripts[name] end
function widgetMethods:HookScript(name, fn) self._scripts[name] = fn end

function widgetMethods:RegisterEvent(event) self._events[event] = true end
function widgetMethods:UnregisterEvent(event) self._events[event] = nil end

function widgetMethods:SetText(text) self._text = text end
function widgetMethods:GetText() return self._text end

function widgetMethods:SetWidth(w) self._width = w end
function widgetMethods:SetHeight(h) self._height = h end
function widgetMethods:GetWidth() return self._width end
function widgetMethods:GetHeight() return self._height end
function widgetMethods:SetSize(w, h) self._width, self._height = w, h end

function widgetMethods:CreateTexture(name, layer)
  local tex = newWidget("Texture", name, self)
  self._regions[#self._regions + 1] = tex
  tex._layer = layer
  return tex
end

function widgetMethods:CreateFontString(name, layer, template)
  local fs = newWidget("FontString", name, self)
  self._regions[#self._regions + 1] = fs
  fs._layer = layer
  fs._template = template
  return fs
end

function widgetMethods:SetMovable(movable) self._movable = movable and true or false end
function widgetMethods:SetClampedToScreen(clamped) self._clamped = clamped and true or false end
function widgetMethods:StartMoving() self._moving = true end
function widgetMethods:StopMovingOrSizing() self._moving = false end

function widgetMethods:LockHighlight() self._highlighted = true end
function widgetMethods:UnlockHighlight() self._highlighted = false end

-- CheckButton state. The client flips this before OnClick runs, so tests that
-- drive a checkbox should SetChecked first and then fire the script.
function widgetMethods:SetChecked(checked) self._checked = checked and true or false end
function widgetMethods:GetChecked() return self._checked and true or false end

function widgetMethods:Enable() self._enabled = true end
function widgetMethods:Disable() self._enabled = false end
function widgetMethods:IsEnabled() return self._enabled ~= false end

-- Test helpers -----------------------------------------------------------------

function M.fire(widget, script, ...)
  local fn = widget._scripts[script]
  if not fn then return false end
  fn(widget, ...)
  return true
end

function M.findChild(widget, predicate)
  for i = 1, #widget._children do
    local child = widget._children[i]
    if predicate(child) then return child end
  end
  return nil
end

function M.flushTimers()
  local pending = M.timers
  M.timers = {}
  for i = 1, #pending do pending[i]() end
  return #pending
end

local GLOBALS = {
  "CreateFrame", "UIParent", "Minimap", "UISpecialFrames",
  "GameTooltip", "C_Timer", "GetGuildInfo", "UnitName", "IsInGuild",
  "SendChatMessage", "GetTime",
}

function M.install()
  local saved = {}
  for i = 1, #GLOBALS do saved[GLOBALS[i]] = _G[GLOBALS[i]] end

  M.timers = {}
  M.guildRankIndex = nil
  M.playerName = "Beefina"
  M.inGuild = true
  M.chat = {}
  M.now = 0

  UIParent = newWidget("Frame", "UIParent", nil)
  Minimap = newWidget("Frame", "Minimap", nil)
  UISpecialFrames = {}
  GameTooltip = newWidget("Frame", "GameTooltip", nil)

  CreateFrame = function(frameType, name, parent, template)
    local widget = newWidget(frameType, name, parent)
    widget._template = template
    -- BasicFrameTemplate surface used by MainFrame (TitleText / CloseButton).
    if type(template) == "string" and template:find("BasicFrame", 1, true) then
      widget.TitleText = widget:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      widget.CloseButton = newWidget("Button", (name or "") .. "CloseButton", widget)
      widget.CloseButton.HookScript = widgetMethods.HookScript
    end
    if type(template) == "string" and template:find("Backdrop", 1, true) then
      widget.SetBackdrop = function() end
      widget.SetBackdropColor = function() end
      widget.SetBackdropBorderColor = function() end
    end
    return widget
  end

  C_Timer = {
    After = function(_seconds, fn) M.timers[#M.timers + 1] = fn end,
  }

  GetGuildInfo = function(_unit)
    if M.guildRankIndex == nil then return nil end
    return "Church of Beef", "Beefling", M.guildRankIndex
  end

  UnitName = function(unit)
    if unit == "player" then return M.playerName end
    return nil
  end

  IsInGuild = function()
    return M.inGuild and true or false
  end

  -- Guild chat recorder: the announce suite asserts on exact liturgy, so nothing
  -- here reformats or trims the line the addon produced.
  SendChatMessage = function(text, channel)
    M.chat[#M.chat + 1] = { text = text, channel = channel }
  end

  GetTime = function() return M.now end

  return function()
    for i = 1, #GLOBALS do _G[GLOBALS[i]] = saved[GLOBALS[i]] end
  end
end

return M
