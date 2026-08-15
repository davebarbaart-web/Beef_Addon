ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode Fight HUD (Bible §10.7, §19.2). Compact spectator card.
-- Show only when Runtime is not QUIET and Gora:GetSanctioned() is a live pair.
-- Defined fallback: everything except live health. No split bar this lane
-- (INPUT channel unspecified). No sound. No toasts. Cards stay mute.
local Hud = {
  MODE = "Event",
}
COB.Hud = Hud

local FRAME_NAME = "ChurchOfBeefHud"
local WIDTH, HEIGHT = 420, 80
local TOP_INSET = -24

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

-- Theatrical ink. Class tint is applied to names only (Law 10).
local INK = { r = 0.95, g = 0.88, b = 0.70 }
local MUTED = { r = 0.55, g = 0.50, b = 0.42 }

local frame = nil
local lastView = nil

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function hiddenView()
  return {
    shown = false,
    mode = "Event",
    fighterA = nil,
    fighterB = nil,
    headToHead = nil,
    health = nil,
    favor = nil,
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
  db.hud = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(widget)
  local db = uiDb()
  local p = db and db.hud
  widget:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    widget:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    widget:SetPoint("TOP", UIParent, "TOP", 0, TOP_INSET)
  end
end

local function tint(fs, color)
  if not fs or type(color) ~= "table" then return end
  local r, g, b = color.r, color.g, color.b
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then return end
  if fs.SetTextColor then fs:SetTextColor(r, g, b) end
  fs._cobColor = { r = r, g = g, b = b }
end

local function classFile(class)
  if type(class) ~= "string" then return nil end
  local file = class:gsub("%s+", ""):upper()
  if file == "" then return nil end
  return file
end

local function classColor(class)
  if type(RAID_CLASS_COLORS) ~= "table" then return nil end
  local file = classFile(class)
  local c = file and RAID_CLASS_COLORS[file]
  if type(c) ~= "table" or type(c.r) ~= "number" then return nil end
  return { r = c.r, g = c.g, b = c.b }
end

local function churchTitle(characterId)
  if not COB.Store or not COB.Store.RankForCharacter then return nil end
  local rankId = COB.Store:RankForCharacter(characterId)
  if rankId == nil then return nil end
  if not (COB.Ranks and COB.Ranks.Title) then return nil end
  local title = COB.Ranks.Title(rankId)
  if type(title) ~= "string" or title == "" or title == "Unknown" then return nil end
  return title
end

local function eventLive()
  if not COB.Runtime or not COB.Runtime.Snapshot then return false end
  local snap = COB.Runtime:Snapshot()
  return type(snap) == "table" and snap.state ~= "QUIET"
end

local function livePair()
  if not COB.Gora or not COB.Gora.GetSanctioned then return nil end
  local pair = COB.Gora:GetSanctioned()
  if type(pair) ~= "table" then return nil end
  if pair.fighterA == nil or pair.fighterB == nil then return nil end
  return pair
end

local function headToHeadFor(character, opponentId)
  if type(character) ~= "table" or type(character.gora) ~= "table" then return nil end
  local list = character.gora.headToHeads
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and row.opponentId == opponentId then
      local fights = row.fights
      if type(fights) == "number" and fights > 0 then
        return {
          wins = row.wins or 0,
          losses = row.losses or 0,
          fights = fights,
        }
      end
    end
  end
  return nil
end

local function fighterFrom(id)
  local ch = COB.Store and COB.Store.GetCharacter and COB.Store:GetCharacter(id) or nil
  if type(ch) ~= "table" then
    return {
      id = id,
      name = "",
      level = nil,
      title = nil,
      wins = 0,
      losses = 0,
      nameColor = nil,
    }
  end
  local gora = type(ch.gora) == "table" and ch.gora or {}
  return {
    id = id,
    name = ch.name,
    class = ch.class,
    level = ch.level,
    title = churchTitle(id),
    wins = gora.wins or 0,
    losses = gora.losses or 0,
    nameColor = classColor(ch.class),
  }
end

local function recordText(fighter)
  return tostring(fighter.wins or 0) .. "-" .. tostring(fighter.losses or 0)
end

local function levelText(fighter)
  if type(fighter.level) ~= "number" then return "" end
  return tostring(fighter.level)
end

local function paintFighter(side, fighter)
  local nameFS = frame["name" .. side]
  local levelFS = frame["level" .. side]
  local titleFS = frame["title" .. side]
  local recordFS = frame["record" .. side]
  nameFS:SetText(fighter.name or "")
  levelFS:SetText(levelText(fighter))
  titleFS:SetText(fighter.title or "")
  recordFS:SetText(recordText(fighter))
  tint(nameFS, fighter.nameColor or INK)
  tint(levelFS, MUTED)
  tint(titleFS, INK)
  tint(recordFS, MUTED)
end

local function paintHidden()
  lastView = hiddenView()
  if not frame then return lastView end
  frame.nameA:SetText("")
  frame.nameB:SetText("")
  frame.levelA:SetText("")
  frame.levelB:SetText("")
  frame.titleA:SetText("")
  frame.titleB:SetText("")
  frame.recordA:SetText("")
  frame.recordB:SetText("")
  if frame.headToHead.Hide then frame.headToHead:Hide() end
  frame:Hide()
  return lastView
end

local function paintShown(pair)
  local fighterA = fighterFrom(pair.fighterA)
  local fighterB = fighterFrom(pair.fighterB)
  local h2h = nil
  if COB.Store and COB.Store.GetCharacter then
    local chA = COB.Store:GetCharacter(pair.fighterA)
    h2h = headToHeadFor(chA, pair.fighterB)
  end

  paintFighter("A", fighterA)
  paintFighter("B", fighterB)
  if h2h then
    frame.headToHead:SetText(recordText(h2h))
    if frame.headToHead.Show then frame.headToHead:Show() end
  else
    frame.headToHead:SetText("")
    if frame.headToHead.Hide then frame.headToHead:Hide() end
  end

  lastView = {
    shown = true,
    mode = "Event",
    fighterA = fighterA,
    fighterB = fighterB,
    headToHead = h2h,
    health = nil,
    favor = nil,
  }
  frame:Show()
  return lastView
end

local function makeLabel(parent, name, template, justify)
  local fs = parent:CreateFontString(name, "OVERLAY", template or "GameFontNormal")
  if fs.SetJustifyH and justify then fs:SetJustifyH(justify) end
  return fs
end

local function build()
  local parent = UIParent
  local widget = CreateFrame("Frame", FRAME_NAME, parent, "BackdropTemplate")
  widget:SetSize(WIDTH, HEIGHT)
  widget:SetMovable(true)
  widget:SetClampedToScreen(true)
  if widget.EnableMouse then widget:EnableMouse(true) end
  if widget.RegisterForDrag then widget:RegisterForDrag("LeftButton") end
  if widget.SetFrameStrata then widget:SetFrameStrata("HIGH") end
  if widget.SetBackdrop then
    widget:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8X8",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true,
      tileSize = 8,
      edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    if widget.SetBackdropColor then
      widget:SetBackdropColor(0.06, 0.05, 0.04, 0.92)
    end
    if widget.SetBackdropBorderColor then
      widget:SetBackdropBorderColor(0.65, 0.55, 0.35, 1)
    end
  end

  widget.nameA = makeLabel(widget, nil, "GameFontHighlight", "LEFT")
  widget.nameB = makeLabel(widget, nil, "GameFontHighlight", "RIGHT")
  widget.titleA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.titleB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.levelA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.levelB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.recordA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.recordB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.vs = makeLabel(widget, nil, "GameFontNormal", "CENTER")
  widget.headToHead = makeLabel(widget, nil, "GameFontNormal", "CENTER")

  widget.nameA:SetPoint("TOPLEFT", widget, "TOPLEFT", 12, -8)
  widget.nameB:SetPoint("TOPRIGHT", widget, "TOPRIGHT", -12, -8)
  widget.vs:SetPoint("TOP", widget, "TOP", 0, -8)
  widget.vs:SetText("VS")
  tint(widget.vs, MUTED)

  widget.titleA:SetPoint("TOPLEFT", widget.nameA, "BOTTOMLEFT", 0, -4)
  widget.titleB:SetPoint("TOPRIGHT", widget.nameB, "BOTTOMRIGHT", 0, -4)
  widget.levelA:SetPoint("TOPLEFT", widget.titleA, "BOTTOMLEFT", 0, -2)
  widget.levelB:SetPoint("TOPRIGHT", widget.titleB, "BOTTOMRIGHT", 0, -2)
  widget.recordA:SetPoint("LEFT", widget.levelA, "RIGHT", 8, 0)
  widget.recordB:SetPoint("RIGHT", widget.levelB, "LEFT", -8, 0)
  widget.headToHead:SetPoint("BOTTOM", widget, "BOTTOM", 0, 8)
  widget.headToHead:Hide()

  widget:SetScript("OnDragStart", function(self)
    if self.StartMoving then self:StartMoving() end
  end)
  widget:SetScript("OnDragStop", function(self)
    if self.StopMovingOrSizing then self:StopMovingOrSizing() end
    savePoint(self)
  end)
  widget:Hide()
  return widget
end

function Hud:Init()
  if not frame then
    frame = build()
    restorePoint(frame)
  end
  self:Refresh()
  return frame
end

function Hud:IsShown()
  return frame ~= nil and frame:IsShown() == true
end

function Hud:GetView()
  if lastView == nil then lastView = hiddenView() end
  return deepcopy(lastView)
end

function Hud:Refresh()
  if not frame then
    self:Init()
    return self:GetView()
  end
  local pair = eventLive() and livePair() or nil
  if not pair then
    paintHidden()
    return self:GetView()
  end
  paintShown(pair)
  return self:GetView()
end

function Hud:ResetForTests()
  if not COB._IN_TEST then return false end
  lastView = hiddenView()
  if frame then
    paintHidden()
  end
  return true
end
