ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Quiet shell: insecure BasicFrameTemplate under UIParent so /beef opens in
-- combat. Template-native chrome only — no custom Media, no brand hex paint,
-- no uiScale writes. Drag, resize, and paint coalesce stay. Standing / Ladder /
-- Officer tab IA does not. The tab registry and ClassColorCode (GetLadderView
-- walk) are gone. /beef opens this frame; it is not a Director Console, Decree,
-- or Event theater.
--
-- Resizable shell: bottom-right grip, bounds 420×320–900×760 (further clamped
-- to UIParent), default 480×420. Content starts under the title rule. Empty
-- content host — no registered surfaces.
local UI = {}
COB.UI = UI

local FRAME_NAME = "ChurchOfBeefFrame"

-- Amendment §6.1 — opening size, floor, and ceiling.
local DEFAULT_WIDTH, DEFAULT_HEIGHT = 480, 420
local MIN_WIDTH, MIN_HEIGHT = 420, 320
local MAX_WIDTH, MAX_HEIGHT = 900, 760

local SIDE_INSET = 12
local TITLE_BAR_HEIGHT = 22
-- Content begins just under the title rule (amendment CONTENT_TOP).
local CONTENT_TOP = TITLE_BAR_HEIGHT + 8 -- 30
-- Footer/status strip reserved at the bottom of the frame, below the content host.
local FOOTER_HEIGHT = 28
-- Grip hit target; stock ChatIM grabber textures scale to this.
local GRIP_SIZE = 18
-- Footer/chip right edge must clear the grip + a few px of breathing room.
local FOOTER_GRIP_CLEAR = GRIP_SIZE + 14
local FOOTER_SIDE = SIDE_INSET + 2
local FOOTER_BOTTOM = 11
-- Live drag and GUILD_ROSTER_UPDATE storms: coalesce dirty paints ≤10 Hz.
local PAINT_COALESCE = 0.1

-- One palette for Beef surfaces (class color on names only when a later
-- theatrical surface needs it; no brand hex paint on chrome). MainFrame loads
-- first (TOC order). Toasts read COB.UI.Palette.HeavyEdge.
UI.Palette = {
  Gold       = { 1.0, 0.82, 0.0 },
  IdleTab    = { 0.55, 0.48, 0.32 },
  Rule       = { 0.45, 0.36, 0.18, 0.75 },
  TitleStone = { 0.95, 0.88, 0.70 },
  Seat       = { 0.72, 0.66, 0.52 },
  SeatWarn   = { 1.0, 0.55, 0.32 },
  Hint       = { 0.85, 0.55, 0.35 },
  Muted      = { 0.55, 0.50, 0.42 },
  Divider    = { 0.55, 0.45, 0.28 },
  HeavyBG    = { 0.06, 0.05, 0.04, 0.92 },
  HeavyEdge  = { 0.65, 0.55, 0.35, 1 },
}

local RULE_COLOR = UI.Palette.Rule

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

-- Exported so the harness can assert against the same budget.
UI.MIN_WIDTH, UI.MIN_HEIGHT = MIN_WIDTH, MIN_HEIGHT
UI.MAX_WIDTH, UI.MAX_HEIGHT = MAX_WIDTH, MAX_HEIGHT
UI.DEFAULT_WIDTH, UI.DEFAULT_HEIGHT = DEFAULT_WIDTH, DEFAULT_HEIGHT
UI.CONTENT_TOP = CONTENT_TOP
UI.FOOTER_HEIGHT = FOOTER_HEIGHT
UI.SIDE_INSET = SIDE_INSET

--------------------------------------------------------------------------------
-- SavedVariables helpers (DB.lua owns the shape; UI edits ui.* in place)
--------------------------------------------------------------------------------

local function uiDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

-- Store the anchor as plain fields: never park a frame reference in SV.
local function savePoint(frame)
  local db = uiDb()
  if not db then return end
  local point, _, relativePoint, x, y = frame:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  db.point = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(frame)
  local db = uiDb()
  local p = db and db.point
  frame:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    frame:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
end

-- Ceiling follows the player's screen so a window saved on a big monitor (or at a
-- different uiScale) still opens reachable. We read UIParent — never write it.
-- When the screen cannot be read, the static ceiling stands unmodified.
local SCREEN_MARGIN = 40

local function maxSize()
  local maxW, maxH = MAX_WIDTH, MAX_HEIGHT
  if type(UIParent) == "table" and type(UIParent.GetWidth) == "function" then
    local w, h = UIParent:GetWidth(), UIParent:GetHeight()
    if type(w) == "number" and w > 0 then
      maxW = math.min(maxW, math.max(MIN_WIDTH, w - SCREEN_MARGIN))
    end
    if type(h) == "number" and h > 0 then
      maxH = math.min(maxH, math.max(MIN_HEIGHT, h - SCREEN_MARGIN))
    end
  end
  return maxW, maxH
end

local function clampSize(width, height)
  local maxW, maxH = maxSize()
  if type(width) ~= "number" or width ~= width then width = DEFAULT_WIDTH end
  if type(height) ~= "number" or height ~= height then height = DEFAULT_HEIGHT end
  if width < MIN_WIDTH then width = MIN_WIDTH end
  if height < MIN_HEIGHT then height = MIN_HEIGHT end
  if width > maxW then width = maxW end
  if height > maxH then height = maxH end
  return math.floor(width + 0.5), math.floor(height + 0.5)
end

-- Amendment §6.1: persist { w, h }. Read-migrate legacy { width, height }.
local function saveSize(frame)
  local db = uiDb()
  if not db then return end
  local w, h = frame:GetWidth(), frame:GetHeight()
  if type(w) ~= "number" or type(h) ~= "number" then return end
  w, h = clampSize(w, h)
  db.size = { w = w, h = h }
end

local function restoreSize(frame)
  local db = uiDb()
  local s = db and db.size
  local w, h = DEFAULT_WIDTH, DEFAULT_HEIGHT
  if type(s) == "table" then
    if type(s.w) == "number" then
      w = s.w
    elseif type(s.width) == "number" then
      w = s.width
    end
    if type(s.h) == "number" then
      h = s.h
    elseif type(s.height) == "number" then
      h = s.height
    end
  end
  w, h = clampSize(w, h)
  frame:SetWidth(w)
  frame:SetHeight(h)
  return w, h
end

--------------------------------------------------------------------------------
-- Layout (empty content host; size from frame geometry)
--------------------------------------------------------------------------------

function UI:_FrameSize()
  local frame = self.frame
  local w = frame and frame:GetWidth() or nil
  local h = frame and frame:GetHeight() or nil
  if type(w) ~= "number" or w <= 0 then w = DEFAULT_WIDTH end
  if type(h) ~= "number" or h <= 0 then h = DEFAULT_HEIGHT end
  return w, h
end

function UI:_ContentTop()
  return CONTENT_TOP
end

-- Usable content budget. Anchored frames only report a real size once the
-- client has resolved layout, so fall back to arithmetic. Sane defaults
-- before Init (amendment §7.5).
function UI:GetContentSize()
  local frameW, frameH = self:_FrameSize()
  local fallbackW = frameW - SIDE_INSET * 2
  local fallbackH = frameH - CONTENT_TOP - FOOTER_HEIGHT
  if fallbackW < 0 then fallbackW = 0 end
  if fallbackH < 0 then fallbackH = 0 end

  local content = self.content
  if not content then return fallbackW, fallbackH end

  local w = content:GetWidth()
  local h = content:GetHeight()
  if type(w) ~= "number" or w <= 0 then w = fallbackW end
  if type(h) ~= "number" or h <= 0 then h = fallbackH end
  if w < 0 then w = 0 end
  if h < 0 then h = 0 end
  return w, h
end

local function layoutContent(self)
  local frame, content = self.frame, self.content
  if not frame or not content then return end
  if self._contentTop == CONTENT_TOP then return end
  self._contentTop = CONTENT_TOP
  content:ClearAllPoints()
  content:SetPoint("TOPLEFT", frame, "TOPLEFT", SIDE_INSET, -CONTENT_TOP)
  content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -SIDE_INSET, FOOTER_HEIGHT)
end

-- Pure geometry: safe to run every OnSizeChanged frame.
function UI:_ApplyLayout()
  if not self.frame then return end
  layoutContent(self)
end

-- Coalesce sink. Empty host: no tab owners to reflow.
function UI:_NotifyResize()
  self._resizeToken = (self._resizeToken or 0) + 1
end

function UI:_ScheduleResizeNotify()
  local token = (self._resizeToken or 0) + 1
  self._resizeToken = token
  if type(C_Timer) == "table" and type(C_Timer.After) == "function" then
    C_Timer.After(PAINT_COALESCE, function()
      if UI._resizeToken ~= token then return end
      UI:_NotifyResize()
    end)
  else
    self:_NotifyResize()
  end
end

-- Belt-and-braces clamp (§6.2): always enforce bounds in OnSizeChanged, even
-- when SetResizeBounds / SetMinResize were unavailable.
function UI:_OnResize()
  local frame = self.frame
  if not frame or self._clamping then return end

  local w, h = frame:GetWidth(), frame:GetHeight()
  local cw, ch = clampSize(w, h)
  if cw ~= w or ch ~= h then
    self._clamping = true
    frame:SetWidth(cw)
    frame:SetHeight(ch)
    self._clamping = false
  end

  self:_ApplyLayout()
  self:_ScheduleResizeNotify()
end

-- Grip released (or a stray mouse-up while sizing): commit the geometry. Sizing
-- from a corner rewrites the frame's anchor, so the point is re-saved too.
function UI:_StopSizing()
  local frame = self.frame
  if not frame or not self._sizing then return false end
  self._sizing = false
  frame:StopMovingOrSizing()
  savePoint(frame)
  saveSize(frame)
  self:_ApplyLayout()
  self:_NotifyResize()
  return true
end

function UI:ResetSize()
  local frame = self.frame
  if not frame then return false end
  local w, h = clampSize(DEFAULT_WIDTH, DEFAULT_HEIGHT)
  frame:SetWidth(w)
  frame:SetHeight(h)
  saveSize(frame)
  self:_ApplyLayout()
  self:_NotifyResize()
  return true
end

--------------------------------------------------------------------------------
-- Roster-update coalesce (≤10 Hz under GUILD_ROSTER_UPDATE storms)
--------------------------------------------------------------------------------

function UI:_ScheduleRosterUpdate()
  local token = (self._rosterToken or 0) + 1
  self._rosterToken = token
  if type(C_Timer) == "table" and type(C_Timer.After) == "function" then
    C_Timer.After(PAINT_COALESCE, function()
      if UI._rosterToken ~= token then return end
      if COB.Roster and COB.Roster.Refresh then COB.Roster:Refresh() end
      UI:OnStatusChanged()
      UI:RefreshLadder()
    end)
  else
    if COB.Roster and COB.Roster.Refresh then COB.Roster:Refresh() end
    UI:OnStatusChanged()
    UI:RefreshLadder()
  end
end

--------------------------------------------------------------------------------
-- Frame construction
--------------------------------------------------------------------------------

local function applyResizeBounds(frame)
  local maxW, maxH = maxSize()
  -- SetResizeBounds is the current call; Classic builds that predate it still
  -- carry the SetMinResize / SetMaxResize pair (§6.2 feature-detect).
  if type(frame.SetResizeBounds) == "function" then
    frame:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT, maxW, maxH)
  else
    if type(frame.SetMinResize) == "function" then frame:SetMinResize(MIN_WIDTH, MIN_HEIGHT) end
    if type(frame.SetMaxResize) == "function" then frame:SetMaxResize(maxW, maxH) end
  end
end

-- Thin Classic-looking hairline (stock 8x8; missing texture must not fail load).
local function addHairline(parent, name, topOffset)
  local rule = parent:CreateTexture(name, "ARTWORK")
  rule:SetHeight(1)
  rule:SetPoint("TOPLEFT", parent, "TOPLEFT", SIDE_INSET, -topOffset)
  rule:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -SIDE_INSET, -topOffset)
  rule:SetTexture("Interface\\Buttons\\WHITE8X8")
  if rule.SetVertexColor then
    rule:SetVertexColor(RULE_COLOR[1], RULE_COLOR[2], RULE_COLOR[3], RULE_COLOR[4])
  end
  return rule
end

local function buildFrame()
  -- Build-prep: BasicFrameTemplate — title/close from FrameXML; no custom TGA.
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent, "BasicFrameTemplate")
  frame:SetFrameStrata("MEDIUM")
  frame:SetToplevel(true)
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetResizable(true)
  frame:SetClampedToScreen(true)
  frame:Hide()

  restoreSize(frame)
  applyResizeBounds(frame)

  local baseLevel = frame:GetFrameLevel() or 0

  -- Title: highlight font + centered brand; drag strip clears the close hit rect.
  if frame.TitleText then
    if frame.TitleText.SetFontObject and GameFontHighlight then
      frame.TitleText:SetFontObject(GameFontHighlight)
    end
    if frame.TitleText.SetText then
      frame.TitleText:SetText("Church of Beef")
    end
    if frame.TitleText.SetJustifyH then
      frame.TitleText:SetJustifyH("CENTER")
    end
  end

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetHeight(TITLE_BAR_HEIGHT)
  titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -2)
  titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -2)
  titleBar:SetFrameLevel(baseLevel + 2)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)
  frame.TitleBar = titleBar

  -- Hairline under the title strip.
  frame.TitleRule = addHairline(frame, nil, TITLE_BAR_HEIGHT + 2)

  -- Close: Classic corner inset, above the drag strip; hook keeps template sound.
  local close = frame.CloseButton
  if not close then
    close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.CloseButton = close
  end
  if close.ClearAllPoints then close:ClearAllPoints() end
  close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)
  if close.SetFrameLevel then close:SetFrameLevel(baseLevel + 6) end
  if close.HookScript then
    close:HookScript("OnClick", function() UI:Hide() end)
  else
    close:SetScript("OnClick", function() UI:Hide() end)
  end

  -- Content host: SIDE_INSET matches the Find strip's optical edge.
  local content = CreateFrame("Frame", nil, frame)
  content:SetPoint("TOPLEFT", frame, "TOPLEFT", SIDE_INSET, -CONTENT_TOP)
  content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -SIDE_INSET, FOOTER_HEIGHT)
  content:SetFrameLevel(baseLevel + 1)

  -- Bottom-right size grip: stock Classic chat-pane grabber, no custom Media.
  -- Left drag resizes; right click restores the default size.
  local grip = CreateFrame("Button", nil, frame)
  grip:SetWidth(GRIP_SIZE)
  grip:SetHeight(GRIP_SIZE)
  grip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
  grip:SetFrameLevel(baseLevel + 8)
  grip:EnableMouse(true)
  grip:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
  grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  grip:SetScript("OnEnter", function(self)
    if type(GameTooltip) ~= "table" then return end
    if GameTooltip.SetOwner then GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT") end
    if GameTooltip.SetText then
      GameTooltip:SetText("Drag to resize", 1, 0.82, 0)
    end
    if GameTooltip.AddLine then
      GameTooltip:AddLine("Right-click restores default size", 0.75, 0.75, 0.75, true)
    end
    if GameTooltip.Show then GameTooltip:Show() end
  end)
  grip:SetScript("OnLeave", function()
    if type(GameTooltip) == "table" and GameTooltip.Hide then GameTooltip:Hide() end
  end)
  grip:SetScript("OnMouseDown", function(_, button)
    if button == "RightButton" then
      UI:ResetSize()
      return
    end
    UI._sizing = true
    frame:StartSizing("BOTTOMRIGHT")
  end)
  grip:SetScript("OnMouseUp", function() UI:_StopSizing() end)
  grip:SetScript("OnHide", function() UI:_StopSizing() end)
  frame.SizeGrip = grip

  -- Hook, never replace: the template may already own these on some builds.
  -- Releasing outside the grip must not leave the frame stuck in sizing.
  frame:HookScript("OnMouseUp", function() UI:_StopSizing() end)
  frame:HookScript("OnSizeChanged", function() UI:_OnResize() end)

  -- Status chip occupies the footer strip; right edge clears grip.
  -- Quiet shell: no joke chrome (Law 10). Footer text stays empty.
  local footerRight = -FOOTER_GRIP_CLEAR
  local footer = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  footer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", FOOTER_SIDE, FOOTER_BOTTOM)
  footer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", footerRight, FOOTER_BOTTOM)
  footer:SetJustifyH("LEFT")
  footer:SetJustifyV("MIDDLE")
  footer:SetText("")
  frame.FooterText = footer

  -- L0 mesh status chip (research 20/45). Yields the scripture line while active.
  local statusChip = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  statusChip:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", FOOTER_SIDE, FOOTER_BOTTOM)
  statusChip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", footerRight, FOOTER_BOTTOM)
  statusChip:SetJustifyH("LEFT")
  statusChip:SetJustifyV("MIDDLE")
  statusChip:SetText("")
  statusChip:Hide()
  frame.StatusChip = statusChip

  restorePoint(frame)
  return frame, content
end

--------------------------------------------------------------------------------
-- Lifecycle
--------------------------------------------------------------------------------

function UI:Init()
  if self.frame then return self.frame end
  if type(CreateFrame) ~= "function" then return nil end

  local db = uiDb()
  local wasShown = db and db.shown

  local frame, content = buildFrame()
  self.frame = frame
  self.content = content
  self.statusChip = frame.StatusChip

  frame:RegisterEvent("PLAYER_GUILD_UPDATE")
  frame:RegisterEvent("GUILD_ROSTER_UPDATE")
  frame:SetScript("OnEvent", function()
    UI:_ScheduleRosterUpdate()
  end)

  frame:SetScript("OnShow", function()
    local ui = uiDb()
    if ui then ui.shown = true end
    -- Opening /beef should not sit on "Waiting for guild roster…" if a query
    -- can be kicked (or a client cache already has names).
    if COB.Roster then
      if COB.Roster.AttachLibrary then COB.Roster:AttachLibrary() end
      if COB.Roster.Refresh then COB.Roster:Refresh() end
    end
    if COB.Roster and not COB.Roster:IsReady() and COB.Net and COB.Net.RequestRoster then
      COB.Net:RequestRoster(nil, true)
    end
    UI:OnStatusChanged()
    UI:RefreshLadder()
  end)
  frame:SetScript("OnHide", function()
    -- Escape via UISpecialFrames bypasses UI:Hide — never stay stuck sizing.
    UI:_StopSizing()
    local ui = uiDb()
    if ui then ui.shown = false end
  end)

  if type(UISpecialFrames) == "table" then
    table.insert(UISpecialFrames, FRAME_NAME)
  end

  self:OnStatusChanged()

  if COB.Minimap and COB.Minimap.Init then
    COB.Minimap:Init()
  end

  if COB.RecordsBook and COB.RecordsBook.Init then
    COB.RecordsBook:Init()
  end
  if COB.Hud and COB.Hud.Init then
    COB.Hud:Init()
  end

  if wasShown then
    if COB.RecordsBook and COB.RecordsBook.Show then
      COB.RecordsBook:Show()
    else
      self:Show()
    end
  end
  return frame
end

-- Guild / roster state → the status chip. Presentation only; never invents ranks.
function UI:OnStatusChanged()
  if self.Status and self.Status.Refresh then
    self.Status:Refresh()
  end
end

function UI:Show()
  if not self.frame then self:Init() end
  if not self.frame then return end
  self.frame:Show()
  self:OnStatusChanged()
end

function UI:Hide()
  if not self.frame then return end
  self:_StopSizing()
  self.frame:Hide()
end

function UI:IsShown()
  return self.frame and self.frame:IsShown() and true or false
end

function UI:Toggle()
  -- Player-opened Quiet is the Records Book (§14.2). The empty shell stays
  -- for suites that have not loaded that module.
  if COB.RecordsBook and COB.RecordsBook.Toggle then
    return COB.RecordsBook:Toggle()
  end
  if not self.frame then self:Init() end
  if not self.frame then
    if DEFAULT_CHAT_FRAME then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: UI could not be created.")
    end
    return
  end
  if self.frame:IsShown() then self:Hide() else self:Show() end
end

-- Name kept: BeefNet still invokes RefreshLadder. Empty shell: minimap only.
function UI:RefreshLadder()
  if COB.Minimap and COB.Minimap.Refresh then COB.Minimap:Refresh() end
end
