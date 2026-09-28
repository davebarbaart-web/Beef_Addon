ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Quiet Mode presence (Law 6 / Bible §14.1, §19.1). At most this button
-- and the active Decree. No grant pip, no petition cue, no standing glance,
-- no toast, no sound. Left-click always opens the player card; when a
-- Decree exists, right-click explicitly replays it. Neither path opens the
-- Director Console; OPEN_QUESTIONS #11). Drag = move around the ring.
-- Event Mode is not this surface. No StatusBar on the map.
--
-- Roundel, highlight, and pushed resolve through Theme:Texture. Custom
-- Media/ art (when the manifest names it) is shown full-bleed so the
-- gold ring is not cropped. Stock UI-Minimap-Background keeps the 0.07
-- inset so the disc sits inside MiniMap-TrackingBorder. Missing Theme
-- or a failed SetTexture never errors — load continues.
local MinimapButton = {
  MODE = "QUIET",
}
COB.Minimap = MinimapButton

local BUTTON_NAME = "ChurchOfBeefMinimapButton"
-- Ring geometry. Tests pin these; they are not Theme.Space.
local DEFAULT_ANGLE = 200
local RADIUS = 80
-- Stock MiniMap-TrackingBorder geometry. The inner disc is cut for 20
-- and the overlay for 53. Not Theme.Space (4/8/16/24…).
local ICON_SIZE = 20
local BORDER_SIZE = 53
local STOCK_INSET = 0.07
local MEDIA_MARK = "Interface\\AddOns\\ChurchOfBeef\\Media\\"
local MEDIA_MARK_ALT = "Interface/AddOns/ChurchOfBeef/Media/"

local function themeTexture(name)
  local theme = COB.Theme
  if not theme or type(theme.Texture) ~= "function" then return nil end
  local path = theme:Texture(name)
  if type(path) ~= "string" or path == "" then return nil end
  return path
end

local function themeColor(role)
  local theme = COB.Theme
  if not theme or type(theme.Color) ~= "function" then return nil end
  local r, g, b = theme:Color(role)
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
    return nil
  end
  return r, g, b
end

local function space(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
  return fallback
end

local function applyTexture(tex, path)
  if not tex or type(path) ~= "string" or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  return ok and true or false
end

local function applyButtonTexture(button, setter, path)
  if not button or type(setter) ~= "function" or type(path) ~= "string" then
    return false
  end
  local ok = pcall(setter, button, path)
  return ok and true or false
end

local function isAddonMedia(path)
  if type(path) ~= "string" then return false end
  return path:find(MEDIA_MARK, 1, true) ~= nil
    or path:find(MEDIA_MARK_ALT, 1, true) ~= nil
end

-- Custom roundel is a compact bull medallion: show the whole face. Stock
-- fallback is a full-bleed disc that squares under the tracking border
-- unless cropped.
local function applyRoundel(icon)
  if not icon then return end
  local path = themeTexture("roundel_minimap")
  if applyTexture(icon, path) then
    if icon.SetTexCoord then
      if isAddonMedia(path) then
        icon:SetTexCoord(0, 1, 0, 1)
      else
        icon:SetTexCoord(STOCK_INSET, 0.93, STOCK_INSET, 0.93)
      end
    end
    return
  end
  local r, g, b = themeColor("charcoal")
  if r and icon.SetColorTexture then
    pcall(icon.SetColorTexture, icon, r, g, b, 1)
  end
end

local function addTipLine(text, role)
  if role then
    local r, g, b = themeColor(role)
    if r then
      GameTooltip:AddLine(text, r, g, b)
      return
    end
  end
  GameTooltip:AddLine(text)
end

local function minimapDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

local function finiteNumber(n)
  return type(n) == "number" and n == n and n + 1 ~= n
end

local function savedAngle()
  local db = minimapDb()
  local angle = db and db.minimapAngle
  if not finiteNumber(angle) then return DEFAULT_ANGLE end
  return angle % 360
end

local function placeButton(button, angle)
  if not finiteNumber(angle) then angle = savedAngle() end
  local rad = math.rad(angle)
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", math.cos(rad) * RADIUS, math.sin(rad) * RADIUS)
end

local waitingForMinimap = false
local watchedMinimap = false

local function watchForMinimap()
  if waitingForMinimap or watchedMinimap or MinimapButton.button then return end
  waitingForMinimap = true
  watchedMinimap = true
  local function retry()
    waitingForMinimap = false
    if MinimapButton.button then return end
    MinimapButton:Init()
  end
  if type(C_Timer) == "table" and type(C_Timer.After) == "function" then
    C_Timer.After(0, retry)
  end
  if type(CreateFrame) ~= "function" then return end
  local watcher = CreateFrame("Frame")
  if type(watcher) ~= "table" or type(watcher.RegisterEvent) ~= "function" then
    return
  end
  watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
  watcher:SetScript("OnEvent", function(self)
    if self.UnregisterAllEvents then pcall(self.UnregisterAllEvents, self) end
    if self.SetScript then self:SetScript("OnEvent", nil) end
    retry()
  end)
end

-- Where the cursor currently sits on the ring, in degrees. GetCursorPosition
-- answers in raw screen units while GetCenter answers in the minimap's own
-- coordinate space, so the cursor has to come through the scale of that same
-- widget — not UIParent's — or a player who has scaled their minimap drags the
-- icon to the wrong spoke. Anything missing (an older client without the call, a
-- minimap the layout engine has not placed yet) returns nil rather than snapping
-- the icon to zero degrees.
local function cursorAngle()
  if type(GetCursorPosition) ~= "function" then return nil end
  if not (Minimap and Minimap.GetCenter) then return nil end

  local centerX, centerY = Minimap:GetCenter()
  if type(centerX) ~= "number" or type(centerY) ~= "number" then return nil end

  local scale = Minimap:GetEffectiveScale()
  if type(scale) ~= "number" or scale <= 0 then scale = 1 end

  local cursorX, cursorY = GetCursorPosition()
  if type(cursorX) ~= "number" or type(cursorY) ~= "number" then return nil end

  return math.deg(math.atan2(cursorY / scale - centerY, cursorX / scale - centerX)) % 360
end

-- Runs only while the button is held. The angle is written straight to the saved
-- variable as it moves so a /reload mid-drag keeps the icon where the player last
-- saw it; the same key is what placeButton reads on the next login.
local function followCursor(button)
  local angle = cursorAngle()
  if type(angle) ~= "number" then return end
  local db = minimapDb()
  if db then db.minimapAngle = angle end
  placeButton(button, angle)
end

local function activeDecree()
  if COB.Nights and type(COB.Nights.HasBoard) == "function" then
    local ok, has = pcall(COB.Nights.HasBoard, COB.Nights)
    if ok and has == true and type(COB.Nights.Week) == "function" then
      local weekOk, week = pcall(COB.Nights.Week, COB.Nights)
      local row = weekOk and type(week) == "table" and week[1] or nil
      if type(row) == "table" then
        return { line = row.title or row.place or "", flavor = row.timeLine }
      end
    end
  end
  if not (COB.Decree and COB.Decree.Get) then return nil end
  local row = COB.Decree:Get()
  if type(row) ~= "table" or type(row.line) ~= "string" or row.line == "" then
    return nil
  end
  return row
end

local function shouldGlow()
  if not (COB.Nights and type(COB.Nights.BoardRevision) == "function") then
    return false
  end
  local ok, rev = pcall(COB.Nights.BoardRevision, COB.Nights)
  if not ok or type(rev) ~= "number" or rev <= 0 then return false end
  local seen = 0
  if type(ChurchOfBeefDB) == "table" and type(ChurchOfBeefDB.ui) == "table"
      and type(ChurchOfBeefDB.ui.nightsSeenRevision) == "number" then
    seen = ChurchOfBeefDB.ui.nightsSeenRevision
  end
  return rev > seen
end

local GATHERING_STARTED = "The gathering has started."

local function runtimeIsLive()
  local Runtime = COB.Runtime
  if type(Runtime) ~= "table" or type(Runtime.Snapshot) ~= "function" then
    return false
  end
  local ok, snap = pcall(Runtime.Snapshot, Runtime)
  if not ok or type(snap) ~= "table" then return false end
  return type(snap.state) == "string" and snap.state ~= "QUIET"
end

-- Presence label only. Not a standing glance, not a petition feed.
-- When a Decree is posted the tooltip may name it (Bible §14.1).
-- When Runtime is not QUIET the tooltip names that the gathering has
-- started. Stock GameTooltip is dark; gold title + silver lines stay
-- on that ground so the ink stays readable (gold/silver never sit on
-- parchment). Hidden button: do not fill.
local function fillTooltip(owner)
  if not GameTooltip or not GameTooltip.AddLine then return end
  if owner and type(owner.IsShown) == "function" and owner:IsShown() ~= true then
    return
  end
  GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
  GameTooltip:ClearLines()
  addTipLine("Church of Beef", "gold")
  local decree = activeDecree()
  local live = runtimeIsLive()
  if live then
    addTipLine(GATHERING_STARTED, "silver")
  end
  if decree then
    addTipLine("GUILD GATHERING", "silver")
    addTipLine(decree.line, "silver")
    addTipLine("Left-click: your card", "silver")
    addTipLine("Right-click: View gathering notice", "silver")
  else
    addTipLine("Left-click: your card", "silver")
  end
  GameTooltip:Show()
end

function MinimapButton:Init()
  -- Pre-build the Nights parchment, but never let it take the button down.
  if COB.DecreeBanner and type(COB.DecreeBanner.Init) == "function" then
    pcall(COB.DecreeBanner.Init, COB.DecreeBanner)
  end
  if self.button then return self.button end
  if type(CreateFrame) ~= "function" or not Minimap then
    watchForMinimap()
    return nil
  end

  local ok, button = pcall(CreateFrame, "Button", BUTTON_NAME, Minimap)
  if not ok or type(button) ~= "table" then
    watchForMinimap()
    return nil
  end
  -- Keep the widget even if chrome or glow throws — Quiet presence first.
  self.button = button
  pcall(function()
    local size = space("xl", 32)
    button:SetWidth(size)
    button:SetHeight(size)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    if button.EnableMouse then button:EnableMouse(true) end
    -- Left is stable navigation; right is the explicit Decree replay affordance.
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    -- Drag is registered apart from clicks so the client can tell them apart: a
    -- press that never moves stays a click and still opens the window.
    button:RegisterForDrag("LeftButton")

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetWidth(ICON_SIZE)
    icon:SetHeight(ICON_SIZE)
    -- 1px down seats the disc in MiniMap-TrackingBorder. Not Theme.Space.
    icon:SetPoint("CENTER", button, "CENTER", 0, 1)
    applyRoundel(icon)
    button.icon = icon

    -- Tracking border stays hardcoded MiniMap-TrackingBorder: it is stock
    -- minimap chrome, not a church crest. Theme has no slot for it.
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetWidth(BORDER_SIZE)
    border:SetHeight(BORDER_SIZE)
    border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
    applyTexture(border, "Interface\\Minimap\\MiniMap-TrackingBorder")
    button.border = border

    applyButtonTexture(button, button.SetHighlightTexture, themeTexture("roundel_minimap_highlight"))
    applyButtonTexture(button, button.SetPushedTexture, themeTexture("roundel_minimap_pushed"))

    button:SetScript("OnClick", function(_, mouseButton)
      if mouseButton == "RightButton" then
        local banner = COB.DecreeBanner
        if banner and banner.Show then banner:Show() end
        return
      end
      if mouseButton and mouseButton ~= "LeftButton" then return end
      -- Left is stable navigation: the player card (Bible §14.2 identity).
      local card = COB.PlayerCard
      if card and type(card.Toggle) == "function" then
        card:Toggle()
      end
    end)

    -- The follow script lives exactly as long as the drag does. An icon resting on
    -- the ring must not be running anything per frame, so mouse-up tears it down.
    button:SetScript("OnDragStart", function(self)
      self:SetScript("OnUpdate", followCursor)
    end)
    button:SetScript("OnDragStop", function(self)
      self:SetScript("OnUpdate", nil)
      followCursor(self)
      MinimapButton:RefreshGlow()
    end)

    button:SetScript("OnEnter", function(self)
      fillTooltip(self)
    end)
    button:SetScript("OnLeave", function()
      if GameTooltip then GameTooltip:Hide() end
    end)

    placeButton(button)
  end)
  pcall(self.RefreshGlow, self)

  local db = minimapDb()
  if db and db.minimapHide and button.Hide then
    pcall(button.Hide, button)
  end
  return button
end

function MinimapButton:RefreshGlow()
  local button = self.button
  if not button then return false end
  if shouldGlow() then
    local pulse = 0
    button:SetScript("OnUpdate", function(self, elapsed)
      if not shouldGlow() then
        self:SetScript("OnUpdate", nil)
        if self.icon and self.icon.SetAlpha then self.icon:SetAlpha(1) end
        return
      end
      pulse = pulse + (elapsed or 0)
      local a = 0.55 + 0.45 * math.abs(math.sin(pulse * 3))
      if self.icon and self.icon.SetAlpha then self.icon:SetAlpha(a) end
    end)
    return true
  end
  if button.SetScript then button:SetScript("OnUpdate", nil) end
  if button.icon and button.icon.SetAlpha then button.icon:SetAlpha(1) end
  return false
end

-- Lets a player hide the icon without unloading the addon. /beef still opens the
-- window, and /beef minimap is the way back once the button itself is gone.
function MinimapButton:SetShown(show)
  local db = minimapDb()
  if db then db.minimapHide = not show end
  if not self.button then return end
  if show then self.button:Show() else self.button:Hide() end
end

-- The preference outlives the widget: /beef minimap asks IsShown/SetShown
-- before Init has built the button, so the saved variable wins where it exists.
function MinimapButton:IsShown()
  local db = minimapDb()
  if db then return not db.minimapHide end
  if self.button then return self.button:IsShown() and true or false end
  return true
end
