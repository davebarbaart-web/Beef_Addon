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
  "GetNumGuildMembers", "GetGuildRosterInfo",
  "SendChatMessage", "GetTime",
  "C_ChatInfo", "SendAddonMessage", "RegisterAddonMessagePrefix",
  "C_GuildInfo", "GuildRoster",
  "UnitIsInMyGuild", "UnitIsAFK", "GetNumGroupMembers", "IsInRaid",
  "IsInInstance", "IsResting", "GetInstanceInfo", "UnitAffectingCombat", "GetBattlefieldWinner",
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

  -- Guild roster the officer rites check names against. Plain strings; entries may
  -- carry a "-Realm" suffix the way the real roster does.
  M.guildRoster = {}

  -- Group model for the ceremony sampler: M.group is keyed by unit id
  -- (M.group.party1 = { name = "Steakina", inGuild = true, afk = false }) and
  -- M.groupSize is what GetNumGroupMembers reports.
  M.group = {}
  M.groupSize = 0
  M.inRaid = false
  M.playerInGuild = true
  M.playerAfk = false

  -- Instance / quest-fellowship model for the co-play trackers: where the player
  -- is, whether they are resting or fighting, and whether a battleground has
  -- locked in a winner.
  M.inInstance = false
  M.instanceType = "none"
  M.instanceId = nil
  M.playerResting = false
  M.playerInCombat = false
  M.battlefieldWinner = nil
  M.tickers = {}

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
    -- Tickers are recorded rather than run: suites drive ticker.fn() themselves and
    -- assert that an idle tracker cancelled its timer.
    NewTicker = function(seconds, fn)
      local ticker = { seconds = seconds, fn = fn, cancelled = false }
      ticker.Cancel = function(self) self.cancelled = true end
      M.tickers[#M.tickers + 1] = ticker
      return ticker
    end,
  }

  GetGuildInfo = function(_unit)
    if M.guildRankIndex == nil then return nil end
    return "Church of Beef", "Beefling", M.guildRankIndex
  end

  GetNumGuildMembers = function() return #M.guildRoster end

  -- Entries may be a plain name string, or { name = "...", rankIndex = N }.
  -- Per-member rankIndex drives the roster-backed Church title map.
  GetGuildRosterInfo = function(index)
    local entry = M.guildRoster[index]
    if not entry then return nil end
    if type(entry) == "table" then
      local name = entry.name or entry[1]
      local rankIndex = tonumber(entry.rankIndex or entry[2])
      if not rankIndex then rankIndex = M.guildRankIndex or 6 end
      return name, "Beefling", rankIndex
    end
    return entry, "Beefling", M.guildRankIndex or 6
  end

  UnitName = function(unit)
    if unit == "player" then return M.playerName end
    local member = M.group[unit]
    return member and member.name or nil
  end

  UnitIsInMyGuild = function(unit)
    if unit == "player" then return M.playerInGuild and true or false end
    local member = M.group[unit]
    return (member and member.inGuild ~= false) and true or false
  end

  UnitIsAFK = function(unit)
    if unit == "player" then return M.playerAfk and true or false end
    local member = M.group[unit]
    return (member and member.afk) and true or false
  end

  UnitAffectingCombat = function(unit)
    if unit == "player" then return M.playerInCombat and true or false end
    local member = M.group[unit]
    return (member and member.inCombat) and true or false
  end

  IsInInstance = function() return M.inInstance and true or false, M.instanceType end

  IsResting = function() return M.playerResting and true or false end

  -- Only the 8th return (instanceID) is read by the tracker; the rest matches the
  -- shape of the real call so a positional unpack behaves the same.
  GetInstanceInfo = function()
    return "Test Instance", M.instanceType, 0, "", 0, 0, false, M.instanceId
  end

  GetBattlefieldWinner = function() return M.battlefieldWinner end

  GetNumGroupMembers = function() return M.groupSize end

  IsInRaid = function() return M.inRaid and true or false end

  IsInGuild = function()
    return M.inGuild and true or false
  end

  -- Guild chat recorder: the announce suite asserts on exact liturgy, so nothing
  -- here reformats or trims the line the addon produced.
  SendChatMessage = function(text, channel)
    M.chat[#M.chat + 1] = { text = text, channel = channel }
  end

  -- BeefNet recorder. Sends land here so the throttle suite can count them, and
  -- prefix registration is remembered because forgetting it in game means silence.
  M.addonMessages = {}
  M.registeredPrefixes = {}
  M.rosterRequests = 0

  local function sendAddonMessage(prefix, payload, channel, target)
    M.addonMessages[#M.addonMessages + 1] =
      { prefix = prefix, payload = payload, channel = channel, target = target }
    return true
  end

  SendAddonMessage = sendAddonMessage
  RegisterAddonMessagePrefix = function(prefix)
    M.registeredPrefixes[prefix] = true
    return true
  end

  C_ChatInfo = {
    SendAddonMessage = sendAddonMessage,
    RegisterAddonMessagePrefix = RegisterAddonMessagePrefix,
  }

  C_GuildInfo = { GuildRoster = function() M.rosterRequests = M.rosterRequests + 1 end }
  GuildRoster = C_GuildInfo.GuildRoster

  GetTime = function() return M.now end

  return function()
    for i = 1, #GLOBALS do _G[GLOBALS[i]] = saved[GLOBALS[i]] end
  end
end

return M
