ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Product window: insecure BasicFrameTemplate under UIParent so /beef opens in
-- combat. Template-native chrome only (glossary 78/81) — no custom Media, no
-- brand hex paint, no uiScale writes. Tabs are views over Core.
local UI = {}
COB.UI = UI

local FRAME_NAME = "ChurchOfBeefFrame"
local FRAME_WIDTH, FRAME_HEIGHT = 480, 360
local TAB_HEIGHT, TAB_WIDTH, TAB_GAP = 22, 110, 4
local TAB_TOP_INSET = 28
local CONTENT_TOP = TAB_TOP_INSET + TAB_HEIGHT + 8

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

-- Registration order from the TOC decides tab order.
local tabs = {}
local tabsByName = {}

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

local function localIsOfficer()
  if not (COB.Officer and COB.Officer.LocalIsOfficer) then return false end
  return COB.Officer:LocalIsOfficer() and true or false
end

--------------------------------------------------------------------------------
-- Tab registry
--------------------------------------------------------------------------------

-- def = { name, label, officerOnly, owner }
-- owner:OnCreate(panel) builds the view; owner:OnRefresh(panel) redraws it.
function UI:RegisterTab(def)
  if type(def) ~= "table" then return nil, "tab definition must be a table" end
  if type(def.name) ~= "string" or def.name == "" then return nil, "tab needs a name" end
  if type(def.label) ~= "string" or def.label == "" then return nil, "tab needs a label" end
  if tabsByName[def.name] then return nil, "tab already registered" end

  local tab = {
    name = def.name,
    label = def.label,
    officerOnly = def.officerOnly and true or false,
    owner = def.owner,
    dirty = true,
  }
  tabs[#tabs + 1] = tab
  tabsByName[def.name] = tab

  if self.frame then
    self:_BuildTab(tab)
    self:UpdateOfficerVisibility()
  end
  return tab
end

function UI:GetTabNames()
  local names = {}
  for i = 1, #tabs do names[i] = tabs[i].name end
  return names
end

--------------------------------------------------------------------------------
-- Frame construction
--------------------------------------------------------------------------------

function UI:_BuildTab(tab)
  local frame = self.frame
  if not frame or tab.panel then return end

  local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  button:SetHeight(TAB_HEIGHT)
  button:SetWidth(TAB_WIDTH)
  button:SetText(tab.label)
  button:SetScript("OnClick", function() UI:ShowTab(tab.name) end)
  tab.button = button

  local panel = CreateFrame("Frame", nil, self.content)
  panel:SetAllPoints(self.content)
  panel:Hide()
  tab.panel = panel

  if tab.owner and tab.owner.OnCreate then
    tab.owner:OnCreate(panel)
  end
end

local function buildFrame()
  -- Build-prep: BasicFrameTemplate — title/close from FrameXML; no custom TGA.
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent, "BasicFrameTemplate")
  frame:SetWidth(FRAME_WIDTH)
  frame:SetHeight(FRAME_HEIGHT)
  frame:SetFrameStrata("MEDIUM")
  frame:SetToplevel(true)
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:Hide()

  if frame.TitleText and frame.TitleText.SetText then
    frame.TitleText:SetText("Church of Beef")
  end

  -- Invisible drag strip under the template title (tests + Classic drag UX).
  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetHeight(24)
  titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -2)
  titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -28, -2)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)

  -- Hook rather than replace: keep template click sound if present.
  if frame.CloseButton and frame.CloseButton.HookScript then
    frame.CloseButton:HookScript("OnClick", function() UI:Hide() end)
  else
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    close:HookScript("OnClick", function() UI:Hide() end)
  end

  local content = CreateFrame("Frame", nil, frame)
  content:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -CONTENT_TOP)
  content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -12, 28)

  -- One-line scripture/footer placeholder (spec §10); GameFontDisable only.
  local footer = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  footer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 14, 10)
  footer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 10)
  footer:SetJustifyH("CENTER")
  footer:SetText("Eternal Grazing.")
  frame.FooterText = footer

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

  for i = 1, #tabs do
    self:_BuildTab(tabs[i])
  end

  frame:RegisterEvent("PLAYER_GUILD_UPDATE")
  frame:RegisterEvent("GUILD_ROSTER_UPDATE")
  frame:SetScript("OnEvent", function() UI:UpdateOfficerVisibility() end)

  frame:SetScript("OnShow", function()
    local ui = uiDb()
    if ui then ui.shown = true end
  end)
  frame:SetScript("OnHide", function()
    local ui = uiDb()
    if ui then ui.shown = false end
  end)

  if type(UISpecialFrames) == "table" then
    table.insert(UISpecialFrames, FRAME_NAME)
  end

  self:UpdateOfficerVisibility()
  self:ShowTab(self.activeTab)

  if COB.Minimap and COB.Minimap.Init then
    COB.Minimap:Init()
  end

  if wasShown then
    self:Show()
  end
  return frame
end

function UI:Show()
  if not self.frame then self:Init() end
  if not self.frame then return end
  self:UpdateOfficerVisibility()
  self.frame:Show()
  self:_RefreshActive()
end

function UI:Hide()
  if not self.frame then return end
  self.frame:Hide()
end

function UI:IsShown()
  return self.frame and self.frame:IsShown() and true or false
end

function UI:Toggle()
  if not self.frame then self:Init() end
  if not self.frame then
    if DEFAULT_CHAT_FRAME then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: UI could not be created.")
    end
    return
  end
  if self.frame:IsShown() then self:Hide() else self:Show() end
end

--------------------------------------------------------------------------------
-- Tab switching and refresh
--------------------------------------------------------------------------------

local function tabIsVisible(tab)
  if not tab.officerOnly then return true end
  return localIsOfficer()
end

local function layoutTabButtons(self)
  local frame = self.frame
  if not frame then return end
  local x = 12
  for i = 1, #tabs do
    local tab = tabs[i]
    if tab.button then
      if tabIsVisible(tab) then
        tab.button:ClearAllPoints()
        tab.button:SetPoint("TOPLEFT", frame, "TOPLEFT", x, -TAB_TOP_INSET)
        tab.button:Show()
        x = x + TAB_WIDTH + TAB_GAP
      else
        tab.button:Hide()
      end
    end
  end
end

function UI:UpdateOfficerVisibility()
  if not self.frame then return end
  local isOfficer = localIsOfficer()
  if self._officerKnown == isOfficer and self._laidOut then return end
  self._officerKnown = isOfficer
  self._laidOut = true
  layoutTabButtons(self)

  local active = tabsByName[self.activeTab]
  if active and not tabIsVisible(active) then
    self:ShowTab(nil)
  end
end

function UI:ShowTab(name)
  local tab = name and tabsByName[name] or nil
  if tab and not tabIsVisible(tab) then tab = nil end
  if not tab then
    for i = 1, #tabs do
      if tabIsVisible(tabs[i]) then tab = tabs[i] break end
    end
  end
  if not tab then return nil end

  self.activeTab = tab.name
  if not self.frame then return tab.name end

  for i = 1, #tabs do
    local other = tabs[i]
    if other.panel then
      if other == tab then other.panel:Show() else other.panel:Hide() end
    end
    if other.button then
      if other == tab then other.button:LockHighlight() else other.button:UnlockHighlight() end
    end
  end

  -- A tab returning to the front always redraws. Core can move on while a tab is
  -- hidden, and one extra layout pass per click is cheaper than an officer acting
  -- on a queue that emptied behind their back.
  tab.dirty = true
  self:_RefreshActive()
  return tab.name
end

-- Redraw only when the window is open: closed UI stays event-idle.
function UI:_RefreshActive()
  if not self:IsShown() then return end
  local tab = tabsByName[self.activeTab]
  if not tab or not tab.dirty then return end
  tab.dirty = false
  if tab.owner and tab.owner.OnRefresh then
    tab.owner:OnRefresh(tab.panel)
  end
end

function UI:MarkDirty(name)
  if name then
    local tab = tabsByName[name]
    if tab then tab.dirty = true end
  else
    for i = 1, #tabs do tabs[i].dirty = true end
  end
  self:_RefreshActive()
end

function UI:Refresh()
  self:MarkDirty()
end

-- Officer rides along: standing earned anywhere can queue a petition, so the
-- pending queue and its evidence go stale on exactly the same events.
function UI:RefreshLadder()
  self:MarkDirty("ladder")
  self:MarkDirty("standing")
  self:MarkDirty("officer")
end
