-- Widget stubs for desktop UI tests.
--
-- This stub is deliberately *strict*. An earlier version answered any method name
-- at all with a silent no-op, which meant the suite happily proved that code using
-- Retail-only APIs worked — the one class of bug an offline harness exists to catch
-- for an addon that ships against TBC Classic 2.5.x. Now every widget class carries
-- the method list that client actually has:
--
--   * a method the client has        → modelled behaviour, or an accepted no-op
--   * a method a *later* client has  → nil, exactly as the real 2.5.x client leaves
--                                      it, so `if frame.SetResizeBounds then` picks
--                                      the branch that will really run in game
--   * anything else                  → a hard error naming the widget type
--
-- Only capitalised keys are policed. Widget methods are all UpperCamelCase, so
-- lowercase and underscore-prefixed reads stay ordinary nil lookups and the addon's
-- own bookkeeping fields keep working.
local M = {}

--------------------------------------------------------------------------------
-- What a 2.5.x widget can do
--------------------------------------------------------------------------------

local function set(list, ...)
  local out = {}
  for _, source in ipairs({ list, ... }) do
    for i = 1, #source do out[source[i]] = true end
  end
  return out
end

local REGION = {
  "GetName", "GetObjectType", "IsObjectType", "GetParent", "SetParent",
  "Show", "Hide", "IsShown", "IsVisible", "SetShown",
  "SetAlpha", "GetAlpha", "SetIgnoreParentAlpha",
  "SetPoint", "SetAllPoints", "ClearAllPoints", "GetPoint", "GetNumPoints",
  "SetWidth", "SetHeight", "SetSize", "GetWidth", "GetHeight", "GetSize",
  "GetLeft", "GetRight", "GetTop", "GetBottom", "GetCenter", "GetRect",
  "SetScale", "GetScale", "GetEffectiveScale",
}

local LAYERED = { "SetDrawLayer", "GetDrawLayer", "SetVertexColor", "GetVertexColor" }

local FONTSTRING = {
  "SetText", "GetText", "SetFormattedText", "SetTextColor", "GetTextColor",
  "SetFont", "GetFont", "SetFontObject", "GetFontObject",
  "SetJustifyH", "GetJustifyH", "SetJustifyV", "GetJustifyV",
  "SetWordWrap", "SetNonSpaceWrap", "SetMaxLines", "GetNumLines",
  "GetStringWidth", "GetStringHeight", "SetSpacing", "GetSpacing",
  "SetShadowColor", "SetShadowOffset", "SetTextHeight",
}

local TEXTURE = {
  "SetTexture", "GetTexture", "SetTexCoord", "GetTexCoord", "SetBlendMode",
  "SetColorTexture", "SetDesaturated", "SetGradient", "SetGradientAlpha",
  "SetRotation", "SetAtlas", "GetAtlas", "SetHorizTile", "SetVertTile",
}

local FRAME = {
  "CreateTexture", "CreateFontString", "CreateAnimationGroup",
  "GetChildren", "GetNumChildren", "GetRegions", "GetNumRegions",
  "RegisterEvent", "UnregisterEvent", "UnregisterAllEvents", "IsEventRegistered",
  "RegisterUnitEvent", "RegisterAllEvents",
  "SetScript", "GetScript", "HookScript", "HasScript",
  "EnableMouse", "IsMouseEnabled", "EnableMouseWheel", "EnableKeyboard",
  "SetPropagateKeyboardInput",
  "SetFrameStrata", "GetFrameStrata", "SetFrameLevel", "GetFrameLevel",
  "SetToplevel", "IsToplevel", "Raise", "Lower",
  "SetMovable", "IsMovable", "SetResizable", "IsResizable",
  "SetClampedToScreen", "SetClampRectInsets", "SetHitRectInsets",
  "RegisterForDrag", "StartMoving", "StartSizing", "StopMovingOrSizing",
  -- The 2.5.x resize-bounds pair. Their Retail replacement is listed as absent
  -- below, so MainFrame's feature detection lands here in tests as in game.
  "SetMinResize", "SetMaxResize", "GetMinResize", "GetMaxResize",
  "SetUserPlaced", "IsUserPlaced", "SetClipsChildren", "SetDontSavePosition",
  "SetID", "GetID", "SetAttribute", "GetAttribute",
}

local BUTTON = {
  "SetText", "GetText", "GetFontString", "SetFontString",
  "SetNormalTexture", "GetNormalTexture", "SetPushedTexture", "GetPushedTexture",
  "SetHighlightTexture", "GetHighlightTexture", "SetDisabledTexture",
  "SetNormalFontObject", "SetHighlightFontObject", "SetDisabledFontObject",
  "SetTextFontObject", "RegisterForClicks", "Click",
  "Enable", "Disable", "IsEnabled", "LockHighlight", "UnlockHighlight",
  "SetButtonState", "GetButtonState", "SetMotionScriptsWhileDisabled",
  "GetTextWidth", "GetTextHeight",
}

local CHECKBUTTON = { "SetChecked", "GetChecked", "SetCheckedTexture", "GetCheckedTexture" }

local EDITBOX = {
  "SetText", "GetText", "SetAutoFocus", "ClearFocus", "SetFocus", "HasFocus",
  "SetMaxLetters", "GetMaxLetters", "SetNumeric", "IsNumeric",
  "SetMultiLine", "IsMultiLine", "Insert", "HighlightText",
  "SetCursorPosition", "GetCursorPosition", "GetNumLetters",
  "SetTextInsets", "GetTextInsets", "SetFontObject", "SetFont",
  "SetJustifyH", "SetJustifyV", "SetTextColor",
  "Enable", "Disable", "IsEnabled", "SetAltArrowKeyMode",
}

local SLIDER = {
  "SetMinMaxValues", "GetMinMaxValues", "SetValue", "GetValue",
  "SetValueStep", "GetValueStep", "SetOrientation", "GetOrientation",
  "SetThumbTexture", "GetThumbTexture", "SetObeyStepOnDrag", "SetStepsPerPage",
  "Enable", "Disable", "IsEnabled",
}

local SCROLLFRAME = {
  "SetScrollChild", "GetScrollChild",
  "SetVerticalScroll", "GetVerticalScroll", "GetVerticalScrollRange",
  "SetHorizontalScroll", "GetHorizontalScroll", "GetHorizontalScrollRange",
  "UpdateScrollChildRect",
}

local STATUSBAR = {
  "SetMinMaxValues", "GetMinMaxValues", "SetValue", "GetValue",
  "SetStatusBarTexture", "GetStatusBarTexture", "SetStatusBarColor",
  "SetOrientation", "SetRotatesTexture", "SetFillStyle",
}

local TOOLTIP = {
  "SetOwner", "GetOwner", "IsOwned", "AddLine", "AddDoubleLine", "ClearLines",
  "SetText", "NumLines", "SetMinimumWidth", "ClearAllPoints",
}

local ANIM_GROUP = {
  "CreateAnimation", "Play", "Stop", "Pause", "Finish", "Restart",
  "IsPlaying", "IsPaused", "IsDone", "SetLooping", "GetLooping",
  "SetScript", "GetScript", "HookScript", "HasScript",
  "GetProgress", "GetDuration", "GetAnimations", "RemoveAnimations",
  "SetToFinalAlpha", "GetParent",
}

local ANIMATION = {
  "SetDuration", "GetDuration", "SetOrder", "GetOrder",
  "SetStartDelay", "GetStartDelay", "SetEndDelay", "GetEndDelay",
  "SetSmoothing", "GetSmoothing", "SetParent", "GetParent",
  "Play", "Stop", "Pause", "IsPlaying", "IsDone", "GetProgress",
  "SetScript", "GetScript", "HookScript",
  "SetChildKey", "SetTarget", "SetTargetKey",
  -- Alpha / Translation / Scale / Rotation setters. One flat list: the client
  -- would refuse the wrong one at runtime, but the suite has no interest in
  -- proving Blizzard validates its own animation types.
  "SetFromAlpha", "GetFromAlpha", "SetToAlpha", "GetToAlpha",
  "SetOffset", "GetOffset", "SetFromScale", "SetToScale", "SetOrigin",
  "SetDegrees", "SetRadians",
}

local ALLOWED = {
  Frame = set(REGION, FRAME),
  Button = set(REGION, FRAME, BUTTON),
  CheckButton = set(REGION, FRAME, BUTTON, CHECKBUTTON),
  EditBox = set(REGION, FRAME, EDITBOX),
  Slider = set(REGION, FRAME, SLIDER),
  ScrollFrame = set(REGION, FRAME, SCROLLFRAME),
  StatusBar = set(REGION, FRAME, STATUSBAR),
  GameTooltip = set(REGION, FRAME, TOOLTIP),
  Texture = set(REGION, LAYERED, TEXTURE),
  FontString = set(REGION, LAYERED, FONTSTRING),
  AnimationGroup = set(ANIM_GROUP),
  Animation = set(ANIMATION),
}

-- Methods this addon is known to reach for that 2.5.x does not have. They are
-- listed rather than merely omitted so the failure message can say *why* the name
-- is missing instead of accusing the caller of a typo, and so a future client bump
-- has one obvious place to move a name from.
local LATER_CLIENT_ONLY = {
  SetResizeBounds = "10.0 — 2.5.x uses SetMinResize / SetMaxResize",
  GetResizeBounds = "10.0 — 2.5.x uses GetMinResize / GetMaxResize",
  SetChange = "removed in 7.0 — Alpha animations use SetFromAlpha / SetToAlpha",
  SetPassThroughButtons = "10.0",
  SetEnabled = "not on 2.5.x widgets — use Enable() / Disable()",
}

local widgetMethods = {}

local function allowedFor(widget, key)
  local allowed = ALLOWED[widget._type]
  -- An unmodelled frame type is a gap in this stub, not a bug in the addon; let it
  -- behave like the permissive base rather than failing every call.
  if not allowed then return true end
  return allowed[key] == true
end

local widgetMeta = {
  __index = function(widget, key)
    if type(key) ~= "string" or not key:match("^%u") then return nil end

    if LATER_CLIENT_ONLY[key] then return nil end

    if not allowedFor(widget, key) then
      error(("%s:%s() does not exist on a TBC Classic 2.5.x %s")
        :format(widget._name or widget._type, key, widget._type), 2)
    end

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
function widgetMethods:IsVisible() return self._shown end
function widgetMethods:SetShown(shown) self._shown = shown and true or false end
function widgetMethods:GetName() return self._name end
function widgetMethods:GetObjectType() return self._type end
function widgetMethods:IsObjectType(t) return self._type == t end
function widgetMethods:GetParent() return self._parent end

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

function widgetMethods:GetNumPoints() return #self._points end

function widgetMethods:SetScript(name, fn) self._scripts[name] = fn end
function widgetMethods:GetScript(name) return self._scripts[name] end
function widgetMethods:HookScript(name, fn) self._scripts[name] = fn end
function widgetMethods:HasScript(name) return self._scripts[name] ~= nil end

function widgetMethods:RegisterEvent(event) self._events[event] = true end
function widgetMethods:UnregisterEvent(event) self._events[event] = nil end
function widgetMethods:IsEventRegistered(event) return self._events[event] == true end

function widgetMethods:SetText(text) self._text = text end
function widgetMethods:GetText() return self._text end
function widgetMethods:GetStringWidth()
  local t = self._text
  if type(t) ~= "string" or t == "" then return 0 end
  return #t * 7
end
function widgetMethods:SetFormattedText(fmt, ...) self._text = fmt:format(...) end

function widgetMethods:SetWidth(w) self._width = w end
function widgetMethods:SetHeight(h) self._height = h end
function widgetMethods:GetWidth() return self._width end
function widgetMethods:GetHeight() return self._height end
function widgetMethods:SetSize(w, h) self._width, self._height = w, h end
function widgetMethods:GetSize() return self._width, self._height end

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

function widgetMethods:GetRegions() return unpack(self._regions) end
function widgetMethods:GetNumRegions() return #self._regions end
function widgetMethods:GetChildren() return unpack(self._children) end
function widgetMethods:GetNumChildren() return #self._children end

function widgetMethods:SetMovable(movable) self._movable = movable and true or false end
function widgetMethods:SetClampedToScreen(clamped) self._clamped = clamped and true or false end
function widgetMethods:StartMoving() self._moving = true end
function widgetMethods:StopMovingOrSizing() self._moving = false end

function widgetMethods:SetMinResize(w, h) self._minResize = { w, h } end
function widgetMethods:SetMaxResize(w, h) self._maxResize = { w, h } end

function widgetMethods:LockHighlight() self._highlighted = true end
function widgetMethods:UnlockHighlight() self._highlighted = false end

function widgetMethods:GetFontString() return self._fontString end
function widgetMethods:SetFontString(fs) self._fontString = fs end

-- Preview dump recording -------------------------------------------------------
-- Record-only. Setters keep the same return value they had as silent no-ops
-- (nil). Getters return a recorded value only after a setter ran; an unset
-- field still answers nil, which is what the previous no-op did. Do not make
-- SetFont return true — several dress helpers treat a truthy second pcall
-- result as "the client accepted the path" and skip the GameFont fallback.

function widgetMethods:SetAlpha(a) self._alpha = a end
function widgetMethods:GetAlpha() return self._alpha end
function widgetMethods:SetIgnoreParentAlpha(flag)
  self._ignoreParentAlpha = flag and true or false
end

function widgetMethods:SetDrawLayer(layer, sub)
  self._layer = layer
  self._subLayer = sub
end
function widgetMethods:GetDrawLayer() return self._layer, self._subLayer end

function widgetMethods:SetVertexColor(r, g, b, a)
  self._vertexColor = { r = r, g = g, b = b, a = a }
end
function widgetMethods:GetVertexColor()
  local c = self._vertexColor
  if not c then return nil end
  return c.r, c.g, c.b, c.a
end

function widgetMethods:SetTexture(path)
  self._texture = path
  self._colorTexture = nil
end
function widgetMethods:GetTexture() return self._texture end

function widgetMethods:SetColorTexture(r, g, b, a)
  self._colorTexture = { r = r, g = g, b = b, a = a }
  self._texture = nil
end

function widgetMethods:SetTexCoord(...)
  self._texCoord = { ... }
end
function widgetMethods:GetTexCoord()
  local c = self._texCoord
  if not c then return nil end
  return unpack(c)
end

function widgetMethods:SetBlendMode(mode) self._blendMode = mode end

function widgetMethods:SetHorizTile(flag) self._horizTile = flag and true or false end
function widgetMethods:SetVertTile(flag) self._vertTile = flag and true or false end

function widgetMethods:SetGradient(orientation, r1, g1, b1, r2, g2, b2)
  self._gradient = { orientation = orientation, r1 = r1, g1 = g1, b1 = b1, r2 = r2, g2 = g2, b2 = b2 }
end
function widgetMethods:SetGradientAlpha(orientation, r1, g1, b1, a1, r2, g2, b2, a2)
  self._gradient = {
    orientation = orientation,
    r1 = r1, g1 = g1, b1 = b1, a1 = a1,
    r2 = r2, g2 = g2, b2 = b2, a2 = a2,
  }
end

function widgetMethods:SetFont(path, size, flags)
  self._fontPath = path
  self._fontSize = size
  self._fontFlags = flags
end
function widgetMethods:GetFont()
  if self._fontPath == nil and self._fontSize == nil then return nil end
  return self._fontPath, self._fontSize, self._fontFlags
end

function widgetMethods:SetFontObject(font) self._fontObject = font end
function widgetMethods:GetFontObject() return self._fontObject end

function widgetMethods:SetTextColor(r, g, b, a)
  self._textColor = { r = r, g = g, b = b, a = a }
end
function widgetMethods:GetTextColor()
  local c = self._textColor
  if not c then return nil end
  return c.r, c.g, c.b, c.a
end

function widgetMethods:SetJustifyH(h) self._justifyH = h end
function widgetMethods:GetJustifyH() return self._justifyH end
function widgetMethods:SetJustifyV(v) self._justifyV = v end
function widgetMethods:GetJustifyV() return self._justifyV end
function widgetMethods:SetWordWrap(flag) self._wordWrap = flag and true or false end
function widgetMethods:SetNonSpaceWrap(flag) self._nonSpaceWrap = flag and true or false end
function widgetMethods:SetMaxLines(n) self._maxLines = n end

function widgetMethods:SetShadowColor(r, g, b, a)
  self._shadowColor = { r = r, g = g, b = b, a = a }
end
function widgetMethods:SetShadowOffset(x, y) self._shadowOffset = { x = x, y = y } end

function widgetMethods:SetFrameStrata(strata) self._strata = strata end
function widgetMethods:GetFrameStrata() return self._strata end
function widgetMethods:SetFrameLevel(level) self._frameLevel = level end
function widgetMethods:GetFrameLevel() return self._frameLevel end

function widgetMethods:SetStatusBarTexture(path)
  self._statusBarTexture = path
end
function widgetMethods:GetStatusBarTexture() return self._statusBarTexture end
function widgetMethods:SetStatusBarColor(r, g, b, a)
  self._statusBarColor = { r = r, g = g, b = b, a = a }
end
function widgetMethods:SetOrientation(o) self._orientation = o end
function widgetMethods:GetOrientation() return self._orientation end

function widgetMethods:SetNormalTexture(path) self._normalTexture = path end
function widgetMethods:GetNormalTexture() return self._normalTexture end
function widgetMethods:SetPushedTexture(path) self._pushedTexture = path end
function widgetMethods:GetPushedTexture() return self._pushedTexture end
function widgetMethods:SetHighlightTexture(path) self._highlightTexture = path end
function widgetMethods:GetHighlightTexture() return self._highlightTexture end
function widgetMethods:SetDisabledTexture(path) self._disabledTexture = path end
function widgetMethods:SetCheckedTexture(path) self._checkedTexture = path end
function widgetMethods:GetCheckedTexture() return self._checkedTexture end
function widgetMethods:SetThumbTexture(path) self._thumbTexture = path end
function widgetMethods:GetThumbTexture() return self._thumbTexture end

function widgetMethods:SetScrollChild(child) self._scrollChild = child end
function widgetMethods:GetScrollChild() return self._scrollChild end
function widgetMethods:SetVerticalScroll(offset) self._verticalScroll = offset end
function widgetMethods:GetVerticalScroll() return self._verticalScroll end
function widgetMethods:SetHorizontalScroll(offset) self._horizontalScroll = offset end
function widgetMethods:GetHorizontalScroll() return self._horizontalScroll end

function widgetMethods:SetClipsChildren(flag) self._clipsChildren = flag and true or false end

-- CheckButton state. The client flips this before OnClick runs, so tests that
-- drive a checkbox should SetChecked first and then fire the script.
function widgetMethods:SetChecked(checked) self._checked = checked and true or false end
function widgetMethods:GetChecked() return self._checked and true or false end

function widgetMethods:Enable() self._enabled = true end
function widgetMethods:Disable() self._enabled = false end
function widgetMethods:IsEnabled() return self._enabled ~= false end

function widgetMethods:SetAutoFocus(auto) self._autoFocus = auto and true or false end
function widgetMethods:SetFocus() self._focused = true end
function widgetMethods:ClearFocus() self._focused = false end
function widgetMethods:HasFocus() return self._focused and true or false end

function widgetMethods:SetValue(value) self._value = value end
function widgetMethods:GetValue() return self._value end
function widgetMethods:SetMinMaxValues(min, max) self._min, self._max = min, max end
function widgetMethods:GetMinMaxValues() return self._min, self._max end

function widgetMethods:CreateAnimationGroup(name)
  local group = newWidget("AnimationGroup", name, nil)
  group._animations = {}
  self._animGroups = self._animGroups or {}
  self._animGroups[#self._animGroups + 1] = group
  return group
end

function widgetMethods:CreateAnimation(animType, name)
  local anim = newWidget("Animation", name, nil)
  anim._animType = animType
  self._animations = self._animations or {}
  self._animations[#self._animations + 1] = anim
  return anim
end

function widgetMethods:Play() self._playing = true end
function widgetMethods:Stop() self._playing = false end
function widgetMethods:IsPlaying() return self._playing and true or false end

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

-- Timers -----------------------------------------------------------------------
--
-- C_Timer.After delays used to be discarded, so every throttle, coalesce and
-- retry in the addon was untestable: flushTimers() ran callbacks that the client
-- would not have fired for another ten seconds. Timers now carry a due time on the
-- same clock GetTime() reports, and M.advance(seconds) moves that clock forward and
-- fires only what has actually come due, in order.

local function dueOrder(a, b)
  if a.due ~= b.due then return a.due < b.due end
  return a.seq < b.seq
end

-- Runs everything scheduled, regardless of when it was due. Kept for suites that
-- only care that a deferred callback eventually runs; prefer advance() when the
-- delay itself is the thing under test.
function M.flushTimers()
  local pending = M.timers
  M.timers = {}
  table.sort(pending, dueOrder)
  for i = 1, #pending do pending[i].fn() end
  return #pending
end

-- Moves the clock forward and fires the timers that came due, honouring callbacks
-- that schedule further work inside the same window.
function M.advance(seconds)
  local target = M.now + (seconds or 0)
  local fired = 0

  while true do
    local next_, index = nil, nil
    for i = 1, #M.timers do
      local timer = M.timers[i]
      if timer.due <= target and (not next_ or dueOrder(timer, next_)) then
        next_, index = timer, i
      end
    end
    if not next_ then break end

    table.remove(M.timers, index)
    M.now = next_.due
    next_.fn()
    fired = fired + 1
  end

  M.now = target
  return fired
end

function M.pendingTimers()
  return #M.timers
end

local GLOBALS = {
  "CreateFrame", "UIParent", "Minimap", "UISpecialFrames",
  "GameTooltip", "C_Timer", "GetGuildInfo", "UnitName", "IsInGuild",
  "GetNumGuildMembers", "GetGuildRosterInfo", "RAID_CLASS_COLORS",
  "SendChatMessage", "GetTime",
  "C_ChatInfo", "SendAddonMessage", "RegisterAddonMessagePrefix",
  "C_GuildInfo", "GuildRoster",
  "UnitIsInMyGuild", "UnitIsAFK", "GetNumGroupMembers", "IsInRaid",
  "IsInInstance", "IsResting", "GetInstanceInfo", "UnitAffectingCombat", "GetBattlefieldWinner",
  "FauxScrollFrame_Update", "FauxScrollFrame_SetOffset", "FauxScrollFrame_GetOffset",
  "FauxScrollFrame_OnVerticalScroll",
  "PanelTemplates_SelectTab", "PanelTemplates_DeselectTab", "PanelTemplates_TabResize",
}

-- Names of scroll bars this stub minted for FauxScrollFrameTemplate frames, so the
-- install teardown can put the global namespace back exactly as it found it.
local mintedGlobals = {}

function M.install()
  local saved = {}
  for i = 1, #GLOBALS do saved[GLOBALS[i]] = _G[GLOBALS[i]] end

  for i = 1, #mintedGlobals do _G[mintedGlobals[i]] = nil end
  mintedGlobals = {}

  M.timers = {}
  M.timerSeq = 0
  M.guildRankIndex = nil
  M.guildRankName = "Beefling"
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

  -- Classic exposes class tints through this table; GetClassColor stays absent
  -- so the Ladder exercises its TBC-safe fallback branch.
  RAID_CLASS_COLORS = {
    MAGE = { r = 0.41, g = 0.80, b = 0.94 },
    WARRIOR = { r = 0.78, g = 0.61, b = 0.43 },
    PRIEST = { r = 1.0, g = 1.0, b = 1.0 },
  }

  UIParent = newWidget("Frame", "UIParent", nil)
  Minimap = newWidget("Frame", "Minimap", nil)
  UISpecialFrames = {}
  GameTooltip = newWidget("GameTooltip", "GameTooltip", nil)

  CreateFrame = function(frameType, name, parent, template)
    local widget = newWidget(frameType, name, parent)
    widget._template = template
    if type(template) == "string" then
      -- BasicFrameTemplate surface used by MainFrame (TitleText / CloseButton).
      if template:find("BasicFrame", 1, true) then
        widget.TitleText = widget:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        widget.CloseButton = newWidget("Button", (name or "") .. "CloseButton", widget)
      end
      -- Backdrops moved onto a template in the 9.x UI 2.5.x is built from, so the
      -- methods exist only where the template was asked for.
      if template:find("Backdrop", 1, true) then
        -- GetBackdrop stays nil: suites and the client-template pin treat
        -- the stub as having the methods without a live backdrop table.
        widget.SetBackdrop = function(self, info) self._backdrop = info end
        widget.SetBackdropColor = function(self, r, g, b, a)
          self._backdropColor = { r = r, g = g, b = b, a = a }
        end
        widget.SetBackdropBorderColor = function(self, r, g, b, a)
          self._backdropBorderColor = { r = r, g = g, b = b, a = a }
        end
        widget.GetBackdrop = function() return nil end
      end
      -- UIPanelButtonTemplate and PanelTabButtonTemplate ship a label, which is
      -- what GetFontString returns.
      if template:find("UIPanelButton", 1, true) or template:find("PanelTabButton", 1, true) then
        widget._fontString = widget:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      end
      -- FauxScrollFrameTemplate mints a named scroll bar as a global. The tabs read
      -- it back with rawget(_G, name .. "ScrollBar"), and without this the thumb
      -- sync in every scroller was dead code the suite never entered.
      if template:find("FauxScrollFrame", 1, true) and name then
        local barName = name .. "ScrollBar"
        local bar = newWidget("Slider", barName, widget)
        _G[barName] = bar
        mintedGlobals[#mintedGlobals + 1] = barName
        widget.ScrollBar = bar
      end
    end
    return widget
  end

  -- FauxScrollFrame is FrameXML, not a widget method: model the three calls the
  -- tabs make so their scroll maths is exercised rather than skipped.
  FauxScrollFrame_SetOffset = function(frame, offset) frame._fauxOffset = offset or 0 end
  FauxScrollFrame_GetOffset = function(frame) return frame._fauxOffset or 0 end
  FauxScrollFrame_Update = function(frame, itemCount, shownCount, itemHeight)
    frame._fauxRange = math.max(0, (itemCount - shownCount)) * itemHeight
    local needed = itemCount > shownCount
    frame._fauxShown = needed
    local bar = frame.ScrollBar
    if bar then
      bar:SetMinMaxValues(0, frame._fauxRange)
      if needed then bar:Show() else bar:Hide() end
    end
    return needed
  end
  FauxScrollFrame_OnVerticalScroll = function(frame, offsetPx, itemHeight, updateFn)
    frame._fauxOffset = math.floor((offsetPx or 0) / (itemHeight or 1) + 0.5)
    if updateFn then updateFn() end
  end

  C_Timer = {
    After = function(seconds, fn)
      M.timerSeq = M.timerSeq + 1
      M.timers[#M.timers + 1] = {
        due = M.now + (tonumber(seconds) or 0),
        seq = M.timerSeq,
        fn = fn,
      }
    end,
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
    return "Church of Beef", M.guildRankName or "Beefling", M.guildRankIndex
  end

  GetNumGuildMembers = function() return #M.guildRoster end

  -- Entries may be a plain name string, or { name = "...", rankIndex = N,
  -- rankName = "...", classFile = "MAGE" }. Rank name is public display;
  -- rankIndex never maps to a Church id.
  GetGuildRosterInfo = function(index)
    local entry = M.guildRoster[index]
    if not entry then return nil end
    local fallbackName = M.guildRankName or "Beefling"
    if type(entry) == "table" then
      local name = entry.name or entry[1]
      local rankIndex = tonumber(entry.rankIndex or entry[2])
      if not rankIndex then rankIndex = M.guildRankIndex or 6 end
      local rankName = entry.rankName or entry.rank
      if type(rankName) ~= "string" then rankName = fallbackName end
      return name, rankName, rankIndex, 70, "Mage", "Zone", "", "",
        true, 0, entry.classFile
    end
    return entry, fallbackName, M.guildRankIndex or 6, 70, "Mage", "Zone", "", "",
      true, 0, nil
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
  M.oversizeMessages = {}
  -- Guild addon messages come back to the sender in game. Suites that want to
  -- prove IsSelf really drops our own traffic set this and route the echo.
  M.loopbackAddonMessages = false
  M.onAddonMessageEcho = nil

  -- The client refuses an addon message whose prefix + payload will not fit the
  -- 255-byte chat envelope. Modelling the refusal is the only way an offline test
  -- can catch a message format that grows past the wire budget.
  local ADDON_MESSAGE_LIMIT = 255

  local function sendAddonMessage(prefix, payload, channel, target)
    prefix = tostring(prefix or "")
    payload = tostring(payload or "")
    -- prefix + tab separator + payload is what actually travels.
    local size = #prefix + 1 + #payload
    if size > ADDON_MESSAGE_LIMIT then
      M.oversizeMessages[#M.oversizeMessages + 1] =
        { prefix = prefix, payload = payload, size = size }
      return false
    end

    M.addonMessages[#M.addonMessages + 1] =
      { prefix = prefix, payload = payload, channel = channel, target = target }

    if M.loopbackAddonMessages and channel == "GUILD" and M.onAddonMessageEcho then
      M.onAddonMessageEcho(prefix, payload, channel, M.playerName)
    end
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

  -- FrameXML panel-tab helpers. The client swaps the tab's active/idle texture
  -- set and resizes to the label; the stub records the selected state and a
  -- plausible width so suites can assert which tab the shell considers active.
  PanelTemplates_SelectTab = function(tab) tab._panelTabSelected = true end
  PanelTemplates_DeselectTab = function(tab) tab._panelTabSelected = false end
  PanelTemplates_TabResize = function(tab, padding)
    local text = type(tab.GetText) == "function" and tab:GetText() or ""
    tab:SetWidth(#tostring(text) * 7 + (padding or 0) * 2)
  end

  return function()
    for i = 1, #GLOBALS do _G[GLOBALS[i]] = saved[GLOBALS[i]] end
    for i = 1, #mintedGlobals do _G[mintedGlobals[i]] = nil end
    mintedGlobals = {}
  end
end

return M
