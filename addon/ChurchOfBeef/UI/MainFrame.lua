ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Product window: fully insecure CreateFrame under UIParent so /beef still opens
-- in combat. Tabs are views over Core -- nothing in UI grants points or writes
-- official ranks. Loads before the tab files so they can register on load.
local UI = {}
COB.UI = UI

local FRAME_NAME = "ChurchOfBeefFrame"
local FRAME_WIDTH, FRAME_HEIGHT = 460, 340
local TITLE_HEIGHT = 26
local TAB_HEIGHT, TAB_WIDTH, TAB_GAP = 22, 104, 4

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

--------------------------------------------------------------------------------
-- Chrome built from plain textures: no backdrop template, no custom media, so a
-- missing art file can never stop /beef from opening.
--------------------------------------------------------------------------------

local function paint(texture, r, g, b, a)
  if texture.SetColorTexture then
    texture:SetColorTexture(r, g, b, a)
  else
    texture:SetTexture(r, g, b, a)
  end
end

local function addBorder(frame, r, g, b, a)
  local function edge(p1, p2, w, h)
    local tex = frame:CreateTexture(nil, "BORDER")
    paint(tex, r, g, b, a)
    tex:SetPoint(p1)
    tex:SetPoint(p2)
    if w then tex:SetWidth(w) end
    if h then tex:SetHeight(h) end
  end
  edge("TOPLEFT", "TOPRIGHT", nil, 1)
  edge("BOTTOMLEFT", "BOTTOMRIGHT", nil, 1)
  edge("TOPLEFT", "BOTTOMLEFT", 1, nil)
  edge("TOPRIGHT", "BOTTOMRIGHT", 1, nil)
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

  -- Registered after Init (hot reload of a tab file): build it immediately.
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
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent)
  frame:SetWidth(FRAME_WIDTH)
  frame:SetHeight(FRAME_HEIGHT)
  frame:SetFrameStrata("MEDIUM")
  frame:SetToplevel(true)
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:Hide()

  local bg = frame:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(frame)
  paint(bg, 0.04, 0.03, 0.02, 0.92)
  addBorder(frame, 0.45, 0.32, 0.10, 1)

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetHeight(TITLE_HEIGHT)
  titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
  titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)

  local titleBg = titleBar:CreateTexture(nil, "ARTWORK")
  titleBg:SetAllPoints(titleBar)
  paint(titleBg, 0.30, 0.16, 0.04, 0.95)

  local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("LEFT", titleBar, "LEFT", 8, 0)
  title:SetText("|cffffaa00Church of Beef|r")

  -- Hook rather than replace: the template's own handler keeps the click sound.
  local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
  close:HookScript("OnClick", function() UI:Hide() end)

  local content = CreateFrame("Frame", nil, frame)
  content:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -(TITLE_HEIGHT + TAB_HEIGHT + 10))
  content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)

  restorePoint(frame)
  return frame, content
end

--------------------------------------------------------------------------------
-- Lifecycle
--------------------------------------------------------------------------------

function UI:Init()
  if self.frame then return self.frame end
  if type(CreateFrame) ~= "function" then return nil end

  -- Read the persisted open state before the OnHide hook below can rewrite it.
  local db = uiDb()
  local wasShown = db and db.shown

  local frame, content = buildFrame()
  self.frame = frame
  self.content = content

  for i = 1, #tabs do
    self:_BuildTab(tabs[i])
  end

  -- Officer+ is unknown during the login roster race; the gate fails closed and
  -- these events re-check once the roster answers.
  frame:RegisterEvent("PLAYER_GUILD_UPDATE")
  frame:RegisterEvent("GUILD_ROSTER_UPDATE")
  frame:SetScript("OnEvent", function() UI:UpdateOfficerVisibility() end)

  -- Escape (UISpecialFrames) and the close button bypass UI:Hide, so persist the
  -- open state from the frame's own show/hide instead.
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
  local x = 8
  for i = 1, #tabs do
    local tab = tabs[i]
    if tab.button then
      if tabIsVisible(tab) then
        tab.button:ClearAllPoints()
        tab.button:SetPoint("TOPLEFT", frame, "TOPLEFT", x, -(TITLE_HEIGHT + 5))
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

-- Called after a local or replicated commit changes official state.
function UI:RefreshLadder()
  self:MarkDirty("ladder")
end
