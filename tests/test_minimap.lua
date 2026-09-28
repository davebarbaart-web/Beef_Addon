-- Minimap button: ring placement, drag-to-reposition, and the /beef minimap
-- escape hatch. Quiet Mode presence + Decree replay — no grant/petition pip.
-- Widget behaviour comes from tests/wow_ui_stub.lua; this proves the wiring
-- and the maths, not that the icon looks right on a real minimap.
local standalone = (type(assert_eq) ~= "function")
local passed = 0
local failed = 0

if standalone then
  package.path = package.path .. ";./tests/?.lua"
  function assert_eq(a, b, msg)
    if a ~= b then
      failed = failed + 1
      print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
    else
      passed = passed + 1
    end
  end
  function assert_true(v, msg)
    assert_eq(not not v, true, msg)
  end
end

local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/DB.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/UI/NightRows.lua")
dofile("addon/ChurchOfBeef/Core/Nights.lua")
dofile("addon/ChurchOfBeef/UI/Decree.lua")

local COB = ChurchOfBeef

local RADIUS = 80
local DEFAULT_ANGLE = 200

--------------------------------------------------------------------------------
-- Fixtures
--------------------------------------------------------------------------------
-- The stub leaves GetCursorPosition absent (the addon has to survive that), the
-- minimap unplaced, and every scale nil. A drag needs all three, so they are
-- installed here and taken away again at the end rather than baked into the
-- shared stub. A non-1 scale is deliberate: cursor and centre are reported in
-- different units, and a missing division would still pass at scale 1. UIParent
-- is given a different scale again, so reading the wrong widget's scale skews the
-- angle instead of quietly agreeing.
local CENTER_X, CENTER_Y = 400, 300
local SCALE = 2

-- The widget stub allows SetTexture / SetHighlightTexture / SetPushedTexture
-- but does not remember the path. Dress pins need the path Set* received.
local savedCreateFrame = CreateFrame
CreateFrame = function(frameType, name, parent, template)
  local widget = savedCreateFrame(frameType, name, parent, template)
  widget.SetHighlightTexture = function(self, path) self._highlightPath = path end
  widget.GetHighlightTexture = function(self) return self._highlightPath end
  widget.SetPushedTexture = function(self, path) self._pushedPath = path end
  widget.GetPushedTexture = function(self) return self._pushedPath end
  local savedCreateTexture = widget.CreateTexture
  widget.CreateTexture = function(self, texName, layer)
    local tex = savedCreateTexture(self, texName, layer)
    tex.SetTexture = function(self, path) self._texture = path end
    tex.GetTexture = function(self) return self._texture end
    tex.SetTexCoord = function(self, ...) self._texCoord = { ... } end
    tex.GetTexCoord = function(self)
      local c = self._texCoord
      if not c then return nil end
      return c[1], c[2], c[3], c[4]
    end
    return tex
  end
  return widget
end

local savedCursorApi = GetCursorPosition
local savedChatFrame = DEFAULT_CHAT_FRAME
local savedCard = COB.PlayerCard
local savedConsole = COB.Console
local savedManifest = ChurchOfBeefMediaManifest

local cursorScreenX, cursorScreenY = 0, 0
GetCursorPosition = function() return cursorScreenX, cursorScreenY end
Minimap.GetCenter = function() return CENTER_X, CENTER_Y end
Minimap.GetEffectiveScale = function() return SCALE end
UIParent.GetEffectiveScale = function() return SCALE * 3 end

local function cursorAtAngle(degrees, distance)
  local rad = math.rad(degrees)
  cursorScreenX = (CENTER_X + math.cos(rad) * (distance or 90)) * SCALE
  cursorScreenY = (CENTER_Y + math.sin(rad) * (distance or 90)) * SCALE
end

local chatLines = {}
DEFAULT_CHAT_FRAME = {
  AddMessage = function(_, message) chatLines[#chatLines + 1] = message end,
}

-- A stand-in for the player card: this suite is about the button, and the
-- whole card would only add ways for an unrelated change to redden it.
-- /beef is the player card; click must never open Console.
local toggles = 0
local consoleCalls = 0
COB.PlayerCard = { Toggle = function() toggles = toggles + 1 end }
COB.Console = {
  Show = function() consoleCalls = consoleCalls + 1 end,
  Toggle = function() consoleCalls = consoleCalls + 1 end,
}

local tipLines = {}
GameTooltip.AddLine = function(_, text, r, g, b)
  tipLines[#tipLines + 1] = { text = text, r = r, g = g, b = b }
end
GameTooltip.ClearLines = function()
  tipLines = {}
end

local function assert_tip_line(i, text, role, msg)
  local row = tipLines[i]
  assert_true(row ~= nil, msg .. " exists")
  if not row then return end
  assert_eq(row.text, text, msg)
  local er, eg, eb = COB.Theme:Color(role)
  assert_eq(row.r, er, msg .. " r is Theme " .. role)
  assert_eq(row.g, eg, msg .. " g is Theme " .. role)
  assert_eq(row.b, eb, msg .. " b is Theme " .. role)
end

local function tipNamesConsole()
  for i = 1, #tipLines do
    local text = tipLines[i] and tipLines[i].text
    if type(text) == "string" and text:lower():find("console", 1, true) then
      return true
    end
  end
  return false
end

local function assert_near(actual, expected, msg)
  assert_true(type(actual) == "number" and math.abs(actual - expected) < 0.0001, msg)
end

local function assert_at_angle(button, degrees, msg)
  local point, relativeTo, relativePoint, x, y = button:GetPoint(1)
  assert_eq(point, "CENTER", msg .. " (anchored by its centre)")
  assert_eq(relativeTo, Minimap, msg .. " (anchored to the minimap)")
  assert_eq(relativePoint, "CENTER", msg .. " (relative to the minimap centre)")
  assert_near(x, math.cos(math.rad(degrees)) * RADIUS, msg .. " (x on the ring)")
  assert_near(y, math.sin(math.rad(degrees)) * RADIUS, msg .. " (y on the ring)")
end

if type(COB.Nights) == "table" and type(COB.Nights.ResetForTests) == "function" then
  COB.Nights:ResetForTests()
end

ChurchOfBeefDB = nil
COB.DB:Init()

dofile("addon/ChurchOfBeef/UI/Minimap.lua")
SlashCmdList = SlashCmdList or {}
dofile("addon/ChurchOfBeef/ChurchOfBeef.lua")

local slash = SlashCmdList["CHURCHOFBEEF"]

if type(COB.Runtime) == "table" and type(COB.Runtime.ResetForTests) == "function" then
  COB.Runtime:ResetForTests()
end

--------------------------------------------------------------------------------
-- A button with no saved angle lands on the default spoke
--------------------------------------------------------------------------------
local button = COB.Minimap:Init()
assert_true(button ~= nil, "Init creates the minimap button")
assert_eq(COB.Minimap.MODE, "QUIET", "minimap declares Quiet Mode")
assert_eq(button.petitionPip, nil, "Quiet presence has no petition pip")
assert_eq(COB.Minimap.StandingGlanceLines, nil, "the standing glance is gone")
assert_eq(COB.Minimap.Refresh, nil, "Minimap:Refresh is retired with the shell")
assert_eq(ChurchOfBeefDB.ui.minimapAngle, nil, "a fresh install saves no angle")
assert_at_angle(button, DEFAULT_ANGLE, "an unplaced button sits on the default spoke")
assert_eq(button:GetScript("OnUpdate"), nil, "a resting button runs nothing per frame")
assert_eq(button:GetWidth(), COB.Theme.Space.xl, "button width is Theme.Space.xl")
assert_eq(button:GetHeight(), COB.Theme.Space.xl, "button height is Theme.Space.xl")
assert_eq(button.icon:GetWidth(), 20, "icon stays the stock MiniMap disc (not Theme.Space)")
assert_eq(button.border:GetWidth(), 53, "tracking border stays the stock 53px chrome")

stub.fire(button, "OnEnter")
assert_eq(#tipLines, 2, "empty tooltip is title plus the /beef hint")
assert_tip_line(1, "Church of Beef", "gold", "empty tooltip title")
assert_tip_line(2, "Left-click: your card", "silver", "empty tooltip click hint")
assert_eq(tipNamesConsole(), false, "empty tooltip never names the console")

assert_true(COB.Theme ~= nil, "Theme is loaded for the roundel slot")
assert_eq(button.icon:GetTexture(), COB.Theme:Texture("roundel_minimap"),
  "icon is the Theme-resolved minimap roundel")
assert_eq(button:GetHighlightTexture(), COB.Theme:Texture("roundel_minimap_highlight"),
  "highlight is the Theme-resolved minimap roundel highlight")
assert_eq(button:GetPushedTexture(), COB.Theme:Texture("roundel_minimap_pushed"),
  "pushed is the Theme-resolved minimap roundel press")
local u0, u1, v0, v1 = button.icon:GetTexCoord()
assert_eq(u0, 0.07, "roundel keeps the stock-disc inset (u0)")
assert_eq(u1, 0.93, "roundel keeps the stock-disc inset (u1)")
assert_eq(v0, 0.07, "roundel keeps the stock-disc inset (v0)")
assert_eq(v1, 0.93, "roundel keeps the stock-disc inset (v1)")
assert_eq(button.border:GetTexture(), "Interface\\Minimap\\MiniMap-TrackingBorder",
  "tracking border stays stock MiniMap-TrackingBorder chrome")
assert_eq(button.icon:GetTexture() == "Interface\\Icons\\INV_Misc_Food_15", false,
  "the steak placeholder is gone")

--------------------------------------------------------------------------------
-- Dragging walks the button around the ring and persists where it stopped
--------------------------------------------------------------------------------
stub.fire(button, "OnDragStart")
assert_true(button:GetScript("OnUpdate") ~= nil, "picking the button up starts following the cursor")

cursorAtAngle(90)
stub.fire(button, "OnUpdate", 0.016)
assert_near(ChurchOfBeefDB.ui.minimapAngle, 90, "dragging writes the cursor angle to the saved variable")
assert_at_angle(button, 90, "the button follows the cursor while held")

cursorAtAngle(315)
stub.fire(button, "OnUpdate", 0.016)
assert_near(ChurchOfBeefDB.ui.minimapAngle, 315, "the angle keeps up with the cursor")
assert_at_angle(button, 315, "the button keeps up with the cursor")

stub.fire(button, "OnDragStop")
assert_eq(button:GetScript("OnUpdate"), nil, "letting go leaves no animator behind")
assert_near(ChurchOfBeefDB.ui.minimapAngle, 315, "the released angle is the one that persists")
assert_at_angle(button, 315, "the button rests where it was released")

-- Distance from the centre is the cursor's business, not the button's: the icon
-- stays on the ring however far out the player drags.
stub.fire(button, "OnDragStart")
cursorAtAngle(45, 400)
stub.fire(button, "OnUpdate", 0.016)
stub.fire(button, "OnDragStop")
assert_near(ChurchOfBeefDB.ui.minimapAngle, 45, "only the direction of the cursor matters")
assert_at_angle(button, 45, "a far-flung cursor still parks the button on the ring")

-- Clicking without moving must still open the player card rather than count
-- as a drag.
stub.fire(button, "OnClick")
assert_eq(toggles, 1, "a plain click drives PlayerCard:Toggle")
assert_eq(consoleCalls, 0, "a plain click never opens the Director Console")
assert_eq(button:GetScript("OnUpdate"), nil, "a click installs no follow script")

--------------------------------------------------------------------------------
-- A client that cannot report the cursor loses the drag, not the button
--------------------------------------------------------------------------------
GetCursorPosition = nil
stub.fire(button, "OnDragStart")
stub.fire(button, "OnUpdate", 0.016)
stub.fire(button, "OnDragStop")
assert_near(ChurchOfBeefDB.ui.minimapAngle, 45, "a missing cursor API never rewrites the angle")
assert_at_angle(button, 45, "a missing cursor API never moves the button")
assert_eq(button:GetScript("OnUpdate"), nil, "a failed drag still tears its script down")
GetCursorPosition = function() return cursorScreenX, cursorScreenY end

--------------------------------------------------------------------------------
-- The angle survives a save/load round trip
--------------------------------------------------------------------------------
assert_eq(COB.DB:Save(), true, "saved variables flush")
local persisted = ChurchOfBeefDB
assert_near(persisted.ui.minimapAngle, 45, "the angle is not scrubbed by the defaults pass")

-- A /reload: fresh module tables over the saved variable table the client kept.
-- A sentinel manifest proves the icon is Theme-resolved, not a hardcoded stock path.
ChurchOfBeefMediaManifest = {
  roundel_minimap = "Interface\\AddOns\\ChurchOfBeef\\Media\\Roundel\\test-roundel.tga",
  roundel_minimap_highlight = "Interface\\AddOns\\ChurchOfBeef\\Media\\Roundel\\test-highlight.tga",
  roundel_minimap_pushed = "Interface\\AddOns\\ChurchOfBeef\\Media\\Roundel\\test-pushed.tga",
}
dofile("addon/ChurchOfBeef/UI/Minimap.lua")
ChurchOfBeefDB = persisted
COB.DB:Init()
local reloaded = COB.Minimap:Init()
assert_true(reloaded ~= button, "the reload builds a new button")
assert_eq(COB.Minimap.MODE, "QUIET", "reload still declares Quiet Mode")
assert_eq(reloaded:GetWidth(), COB.Theme.Space.xl, "reload button size still Theme.Space.xl")
assert_at_angle(reloaded, 45, "the dragged angle is honoured on the next login")
assert_eq(reloaded.icon:GetTexture(), COB.Theme:Texture("roundel_minimap"),
  "reload icon still follows Theme (manifest wins)")
assert_eq(reloaded:GetHighlightTexture(), COB.Theme:Texture("roundel_minimap_highlight"),
  "reload highlight still follows Theme (manifest wins)")
assert_eq(reloaded:GetPushedTexture(), COB.Theme:Texture("roundel_minimap_pushed"),
  "reload pushed still follows Theme (manifest wins)")
assert_eq(reloaded.icon:GetTexture(),
  "Interface\\AddOns\\ChurchOfBeef\\Media\\Roundel\\test-roundel.tga",
  "reload icon is the manifest path, not a hardcoded stock disc")
button = reloaded
ChurchOfBeefMediaManifest = nil

--------------------------------------------------------------------------------
-- /beef minimap is the way back from a hidden button
--------------------------------------------------------------------------------
assert_true(type(slash) == "function", "/beef is registered")
assert_eq(COB.Minimap:IsShown(), true, "the button starts visible")

slash("minimap")
assert_eq(button:IsShown(), false, "/beef minimap hides a shown button")
assert_eq(ChurchOfBeefDB.ui.minimapHide, true, "hiding through the slash persists")
assert_eq(#chatLines, 1, "the toggle confirms itself once")
assert_true(chatLines[1]:find("Church of Beef", 1, true) ~= nil, "the confirmation is branded")
assert_true(chatLines[1]:find("hidden", 1, true) ~= nil, "the confirmation says the button went away")
assert_true(chatLines[1]:find("/beef minimap", 1, true) ~= nil, "the confirmation names the way back")

slash("minimap")
assert_eq(button:IsShown(), true, "/beef minimap shows a hidden button")
assert_eq(ChurchOfBeefDB.ui.minimapHide, false, "showing through the slash persists")
assert_eq(#chatLines, 2, "the second toggle confirms itself too")
assert_true(chatLines[2]:find("shown", 1, true) ~= nil, "the confirmation says the button came back")

slash("  MiniMap ")
assert_eq(button:IsShown(), false, "the subcommand tolerates padding and case")
slash("minimap")
assert_eq(button:IsShown(), true, "and toggles back")

--------------------------------------------------------------------------------
-- Everything else is still just the player card
--------------------------------------------------------------------------------
local chatBefore = #chatLines
toggles = 0

slash("")
assert_eq(toggles, 1, "bare /beef toggles the player card")
slash(nil)
assert_eq(toggles, 2, "a nil argument toggles the player card")
slash("verbose")
assert_eq(toggles, 2, "an unrecognised subcommand does not toggle the player card")
slash("minimapp")
assert_eq(toggles, 2, "a near miss is not the minimap toggle and does not toggle the card")

assert_eq(button:IsShown(), true, "help never touches the button")
assert_eq(ChurchOfBeefDB.ui.minimapHide, false, "help never touches the preference")
assert_true(#chatLines > chatBefore, "unrecognised arguments print help")

--------------------------------------------------------------------------------
-- Stable navigation: left opens the card; right explicitly replays a Decree.
--------------------------------------------------------------------------------
local Banner = COB.DecreeBanner
local Decree = COB.Decree
assert_true(Banner ~= nil, "Decree banner is loaded")
assert_true(Decree ~= nil, "Core Decree is loaded")
assert_eq(Decree:ResetForTests(), true, "Decree ResetForTests runs under _IN_TEST")
assert_eq(Banner:ResetForTests(), true, "DecreeBanner ResetForTests runs under _IN_TEST")
assert_eq(Decree:Get(), nil, "no Decree is set for the Toggle path")

toggles = 0
consoleCalls = 0
stub.fire(button, "OnClick")
assert_eq(toggles, 1, "a plain click drives PlayerCard:Toggle")
assert_eq(consoleCalls, 0, "a plain click does not open the Director Console")
assert_eq(Banner:IsShown(), false, "a plain click does not invent a parchment")

Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
toggles = 0
consoleCalls = 0
stub.fire(button, "OnClick")
assert_eq(Banner:IsShown(), false, "left-click does not surprise-open the Decree")
assert_eq(toggles, 1, "left-click always opens the player card")
stub.fire(button, "OnClick", "RightButton")
assert_eq(Banner:IsShown(), true, "right-click explicitly shows the posted Decree")
assert_eq(consoleCalls, 0, "Decree replay does not open the Director Console")
assert_eq(Banner.frame.HeaderText:GetText(), "Nights", "replay paints the header")
assert_eq(Banner.frame.LineText:GetText(), "No nights posted this week.",
  "replay with no Nights board keeps empty copy")
assert_eq(ChurchOfBeefDB.ui.decreeSeen, nil, "already-seen is not persisted")
assert_eq(ChurchOfBeefDB.decreeSeen, nil, "already-seen is not a root SV key")

stub.fire(button, "OnEnter")
assert_eq(#tipLines, 5, "posted tooltip explains overview and Decree actions")
assert_tip_line(1, "Church of Beef", "gold", "posted tooltip title")
assert_tip_line(2, "GUILD GATHERING", "silver", "posted tooltip plain-language header")
assert_tip_line(3, "Goldshire Inn — Sunday, 7:00 PM", "silver", "posted tooltip names the Decree")
assert_tip_line(4, "Left-click: your card", "silver", "posted tooltip stable navigation hint")
assert_tip_line(5, "Right-click: View gathering notice", "silver",
  "posted tooltip explicit gathering hint")
assert_eq(tipNamesConsole(), false, "posted tooltip never names the console")

Decree:Clear()
Banner:Hide()
toggles = 0
consoleCalls = 0
stub.fire(button, "OnClick")
assert_eq(toggles, 1, "after Clear, a plain click still drives PlayerCard:Toggle")
assert_eq(consoleCalls, 0, "after Clear, click still does not open the Director Console")
assert_eq(Banner:IsShown(), false, "after Clear, click does not show empty parchment")

stub.fire(button, "OnEnter")
assert_eq(#tipLines, 2, "cleared tooltip returns to title plus /beef")
assert_tip_line(1, "Church of Beef", "gold", "cleared tooltip title")
assert_tip_line(2, "Left-click: your card", "silver", "cleared tooltip click hint")
assert_eq(tipNamesConsole(), false, "cleared tooltip never names the console")

slash("minimap")
assert_eq(button:IsShown(), false, "/beef minimap still hides after Decree replay")
slash("minimap")
assert_eq(button:IsShown(), true, "/beef minimap still shows after Decree replay")

local srcFile = io.open("addon/ChurchOfBeef/UI/Minimap.lua", "r")
assert_true(srcFile ~= nil, "Minimap.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("COB.Console", 1, true), nil, "minimap source does not host Console")
assert_eq(src:find("PlaySound", 1, true), nil, "Quiet presence plays no sound")
assert_eq(src:find("COB.Toast", 1, true), nil, "Quiet presence has no toast")
assert_eq(src:find("Welcome", 1, true), nil, "minimap never reopens welcome")
assert_eq(src:find("Proclaim", 1, true), nil, "minimap never Proclaims")
assert_eq(consoleCalls, 0, "the suite never opened the Director Console")

--------------------------------------------------------------------------------
-- Runtime ≠ QUIET: tooltip names that the gathering has started. No toast.
--------------------------------------------------------------------------------
do
  local savedRuntime = COB.Runtime
  local savedWelcome = COB.Welcome
  local savedToasts = COB.Toasts
  local welcomeShows, toastCalls = 0, 0
  COB.Welcome = { Show = function() welcomeShows = welcomeShows + 1 end }
  COB.Toasts = { Proclaim = function() toastCalls = toastCalls + 1 end }

  Decree:Clear()
  Banner:Hide()
  COB.Runtime = { Snapshot = function() return { state = "ASSEMBLY" } end }
  stub.fire(button, "OnEnter")
  assert_eq(#tipLines, 3, "live empty tooltip adds the started line")
  assert_tip_line(1, "Church of Beef", "gold", "live empty tooltip title")
  assert_tip_line(2, "The gathering has started.", "silver", "live empty tooltip Gathering line")
  assert_tip_line(3, "Left-click: your card", "silver", "live empty tooltip click hint")
  assert_eq(tipNamesConsole(), false, "live tooltip never names the console")
  assert_eq(welcomeShows, 0, "live tooltip never reopens welcome")
  assert_eq(toastCalls, 0, "live tooltip never toasts")

  Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
  stub.fire(button, "OnEnter")
  assert_eq(#tipLines, 6, "live posted tooltip adds the started line")
  assert_tip_line(1, "Church of Beef", "gold", "live posted tooltip title")
  assert_tip_line(2, "The gathering has started.", "silver", "live posted tooltip Gathering line")
  assert_tip_line(3, "GUILD GATHERING", "silver", "live posted tooltip header")
  assert_tip_line(4, "Goldshire Inn — Sunday, 7:00 PM", "silver",
    "live posted tooltip keeps the Decree line")
  assert_tip_line(5, "Left-click: your card", "silver", "live posted tooltip click hint")
  assert_tip_line(6, "Right-click: View gathering notice", "silver",
    "live posted tooltip still offers replay")

  COB.Runtime = { Snapshot = function() return { state = "QUIET" } end }
  stub.fire(button, "OnEnter")
  assert_eq(#tipLines, 5, "Quiet posted tooltip is unchanged")
  assert_tip_line(3, "Goldshire Inn — Sunday, 7:00 PM", "silver",
    "Quiet posted tooltip keeps the Decree line")

  Decree:Clear()
  COB.Runtime = { Snapshot = function() return { state = "RITE" } end }
  slash("minimap")
  assert_eq(button:IsShown(), false, "hidden button for the live-tooltip guard")
  tipLines = {}
  stub.fire(button, "OnEnter")
  assert_eq(#tipLines, 0, "hidden button does not fill a live Gathering tooltip")
  slash("minimap")
  assert_eq(button:IsShown(), true, "button shown again after the guard")

  COB.Runtime = nil
  stub.fire(button, "OnEnter")
  assert_eq(#tipLines, 2, "missing Runtime is Quiet tooltip")
  assert_tip_line(2, "Left-click: your card", "silver", "missing Runtime click hint")

  COB.Runtime = savedRuntime
  COB.Welcome = savedWelcome
  COB.Toasts = savedToasts
end

--------------------------------------------------------------------------------
-- A throwing Nights parchment must not take the button down
--------------------------------------------------------------------------------
do
  local savedInit = Banner.Init
  Banner.Init = function() error("parchment boom") end
  COB.Minimap.button = nil
  local recovered = COB.Minimap:Init()
  assert_true(recovered ~= nil, "banner Init throw still creates the button")
  assert_eq(COB.Minimap.button, recovered, "recovery keeps the button on the module")
  Banner.Init = savedInit
  button = recovered
end

--------------------------------------------------------------------------------
-- Missing Minimap at login: Init returns nil and retries once the frame exists
--------------------------------------------------------------------------------
do
  local savedMap = Minimap
  COB.Minimap.button = nil
  Minimap = nil
  local missing = COB.Minimap:Init()
  assert_eq(missing, nil, "Init without Minimap returns nil (no throw)")
  Minimap = savedMap
  local retried = COB.Minimap:Init()
  assert_true(retried ~= nil, "Init after Minimap appears creates the button")
  button = retried
end

--------------------------------------------------------------------------------
-- A poisoned saved angle must not throw SetPoint
--------------------------------------------------------------------------------
do
  ChurchOfBeefDB.ui.minimapAngle = 0 / 0
  COB.Minimap.button = nil
  local sanitized = COB.Minimap:Init()
  assert_true(sanitized ~= nil, "NaN angle still creates the button")
  assert_at_angle(sanitized, DEFAULT_ANGLE, "NaN angle falls back to the default spoke")
  button = sanitized
end

GetCursorPosition = savedCursorApi
DEFAULT_CHAT_FRAME = savedChatFrame
COB.PlayerCard = savedCard
COB.Console = savedConsole
ChurchOfBeefMediaManifest = savedManifest
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
