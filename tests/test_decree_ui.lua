-- Decree parchment banner + minimap replay (Phase 5 Lane B).
-- Isolated: wow_ui_stub + Common + Decree + Decree UI + Minimap.
-- Quiet Mode theatrical parchment (Bible §14.1). Header is UI copy.
-- No TOC / bootstrap / run.lua / MainFrame / Console / HUD / Records / Status /
-- Toasts / Store / Runtime / Net / Core/Decree.lua / Core/DB.lua. No slash.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

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

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/UI/Decree.lua")
dofile("addon/ChurchOfBeef/UI/Minimap.lua")

local COB = ChurchOfBeef
local Decree = COB.Decree
local Banner = COB.DecreeBanner
local HEADER = "A GATHERING HAS BEEN DECREED"

local sounds = 0
PlaySound = function()
  sounds = sounds + 1
end
PlaySoundFile = function()
  sounds = sounds + 1
end
PlaySoundKitID = function()
  sounds = sounds + 1
end

local tipLines = {}
GameTooltip.AddLine = function(_, text)
  tipLines[#tipLines + 1] = text
end
GameTooltip.ClearLines = function()
  tipLines = {}
end
GameTooltip.SetOwner = function(self, owner)
  self._owner = owner
end
GameTooltip.IsOwned = function(self, owner)
  return self._owner == owner
end

local savedUi = COB.UI
local toggles = 0
COB.UI = {
  Toggle = function()
    toggles = toggles + 1
  end,
}

local function reset()
  assert_eq(Decree:ResetForTests(), true, "Decree ResetForTests runs under _IN_TEST")
  assert_eq(Banner:ResetForTests(), true, "DecreeBanner ResetForTests runs under _IN_TEST")
  sounds = 0
  toggles = 0
  tipLines = {}
end

local function buttonFor(label)
  local frame = Banner.frame
  if not frame then return nil end
  return stub.findChild(frame, function(child)
    return child._type == "Button" and child:GetText() == label
  end)
end

local function tipHas(text)
  for i = 1, #tipLines do
    if tipLines[i] == text then return true end
  end
  return false
end

--------------------------------------------------------------------------------
-- Isolated surface: stub + Common + Decree + Decree UI + Minimap.
--------------------------------------------------------------------------------
assert_true(Decree ~= nil, "Core Decree is loaded")
assert_true(Banner ~= nil, "COB.DecreeBanner exists")
assert_true(COB.Minimap ~= nil, "isolated suite loads Minimap")
assert_true(COB.Names ~= nil, "Common name law is loaded")
assert_true(Banner ~= Decree, "the banner is not the Core Decree table")
assert_eq(type(Decree.Get), "function", "UI/Decree.lua does not clobber Core Decree")
assert_eq(Banner.MODE, "QUIET", "Decree banner declares Quiet Mode")
assert_eq(Banner.HEADER, HEADER, "header is the Bible UI copy")
assert_eq(type(Banner.Init), "function", "Init builds the surface")
assert_eq(type(Banner.Show), "function", "Show paints an active Decree")
assert_eq(type(Banner.Hide), "function", "Hide dismisses the banner")
assert_eq(type(Banner.IsShown), "function", "IsShown reads visibility")
assert_eq(type(Banner.GetView), "function", "GetView returns a copy")
assert_eq(type(Banner.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(Banner.Grant, nil, "no Grant")
assert_eq(Banner.Standing, nil, "no Standing")
assert_eq(Banner.Calendar, nil, "no calendar")
assert_eq(Banner.RSVP, nil, "no RSVP")
assert_eq(Banner.Summon, nil, "no SUMMON")
assert_eq(Banner.Deputy, nil, "no deputy picker")
assert_eq(Banner.Post, nil, "no Console Post")
assert_eq(Banner.Narrate, nil, "software does not narrate")
assert_eq(Banner.PlayCue, nil, "no sound this lane")
assert_eq(Banner.Toast, nil, "banner is not a toast")
assert_eq(Banner.Toggle, nil, "banner is show/hide, not a /beef toggle")

if standalone then
  assert_eq(type(SLASH_CHURCHOFBEEF1), "nil", "this file does not register a slash")
  assert_eq(type(SLASH_DECREE1), "nil", "no Decree slash")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Store, nil, "isolated suite does not load Store")
  assert_eq(COB.Runtime, nil, "isolated suite does not load Runtime")
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
  assert_eq(COB.Hud, nil, "isolated suite does not load Hud")
  assert_eq(COB.RecordsBook, nil, "isolated suite does not load Records Book")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Sound, nil, "isolated suite does not load Sound")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Gora, nil, "isolated suite does not load Gora")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(type(COB.UI.Init), "nil", "isolated suite does not load MainFrame")
end

--------------------------------------------------------------------------------
-- Source contract: silent parchment. No calendar / RSVP / sound / Event host.
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/Decree.lua", "r")
assert_true(srcFile ~= nil, "UI/Decree.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find("PlaySoundFile", 1, true), nil, "source does not call PlaySoundFile")
assert_eq(src:find("ShowUIPanel", 1, true), nil, "insecure Show/Hide only")
assert_eq(src:find("StatusBar", 1, true), nil, "source does not mint a StatusBar")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("SendAddonMessage", 1, true), nil, "source does not send addon messages")
assert_eq(src:find("Calendar", 1, true), nil, "source has no calendar")
assert_eq(src:find("RSVP", 1, true), nil, "source has no RSVP")
assert_eq(src:find("SecureActionButton", 1, true), nil, "no secure template")
assert_eq(src:find("COB.Console", 1, true), nil, "banner does not host Console")
assert_eq(src:find("COB.Hud", 1, true), nil, "banner does not host HUD")
assert_eq(src:find("COB.RecordsBook", 1, true), nil, "banner does not host Records Book")
assert_eq(src:find("COB.Toasts", 1, true), nil, "banner does not drive Toasts")
assert_eq(src:find("alreadySeen", 1, true), nil, "source does not persist already-seen")
assert_eq(src:find("decreeSeen", 1, true), nil, "source does not persist decreeSeen")
assert_eq(src:find("SLASH_", 1, true), nil, "source does not register a slash")

local miniFile = io.open("addon/ChurchOfBeef/UI/Minimap.lua", "r")
assert_true(miniFile ~= nil, "UI/Minimap.lua is readable")
local miniSrc = miniFile:read("*a")
miniFile:close()
assert_eq(miniSrc:find("RSVP", 1, true), nil, "minimap has no RSVP")
assert_eq(miniSrc:find("Calendar", 1, true), nil, "minimap has no calendar")
assert_eq(miniSrc:find("petitionPip", 1, true), nil, "minimap has no petition pip")
assert_eq(miniSrc:find("RightButton", 1, true), nil, "minimap has no right-click menu")
assert_eq(miniSrc:find("PlaySound", 1, true), nil, "minimap plays no sound")

--------------------------------------------------------------------------------
-- Init with no Decree: silent. Hidden frame is not an empty parchment.
--------------------------------------------------------------------------------
reset()
assert_eq(Decree:Get(), nil, "no Decree is set")
assert_eq(Banner:IsShown(), false, "the banner is closed before Init")
local frame = Banner:Init()
assert_true(frame ~= nil, "Init creates the frame")
assert_eq(frame:GetName(), "ChurchOfBeefDecree", "frame has a stable name")
assert_eq(frame:GetParent(), UIParent, "banner is parented to UIParent")
assert_eq(Banner:Init(), frame, "Init is idempotent")
assert_eq(Banner:IsShown(), false, "Init stays silent when Get is nil")
assert_eq(frame:IsShown(), false, "the widget stays hidden")
assert_eq(frame._template, nil, "theatrical banner is not BasicFrameTemplate")
assert_eq(frame._movable, true, "the banner is movable")
assert_eq(frame._clamped, true, "the banner is clamped to screen")
assert_eq(frame:GetScript("OnUpdate"), nil, "no permanent OnUpdate")
assert_eq(sounds, 0, "Init plays no sound")
assert_true(frame.Iron ~= nil, "dark-iron field exists")
assert_true(frame.Parchment ~= nil, "parchment leaf exists")
assert_true(frame.GoldEdge ~= nil, "muted-gold edge exists")
assert_true(frame.HeaderText ~= nil, "header FontString exists")
assert_true(frame.LineText ~= nil, "line FontString exists")
assert_true(frame.FlavorText ~= nil, "flavor FontString exists")
assert_true(frame.HeaderText._template ~= nil, "header uses a GameFont* fallback template")
assert_eq(buttonFor("RSVP"), nil, "no RSVP chrome")
assert_eq(buttonFor("Attend"), nil, "no attendance chrome")
assert_eq(buttonFor("Calendar"), nil, "no calendar chrome")
assert_eq(buttonFor("Deputy"), nil, "no deputy picker")
assert_eq(buttonFor("Grant"), nil, "no Grant chrome")
assert_eq(buttonFor("I will attend"), nil, "no RSVP verb")
assert_true(UISpecialFrames[1] == "ChurchOfBeefDecree" or (function()
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == "ChurchOfBeefDecree" then return true end
  end
  return false
end)(), "Escape can dismiss the banner")

local view0 = Banner:GetView()
assert_eq(view0.shown, false, "silent view is hidden")
assert_eq(view0.header, HEADER, "view still names the fixed header")
assert_eq(view0.line, nil, "silent view has no line")
assert_eq(view0.flavor, nil, "silent view has no flavor")
assert_eq(view0.title, nil, "view does not invent a title field")

--------------------------------------------------------------------------------
-- Show with no Decree refuses an empty parchment.
--------------------------------------------------------------------------------
assert_eq(Banner:Show(), false, "Show without a Decree fails")
assert_eq(Banner:IsShown(), false, "Show without a Decree does not paint empty parchment")
assert_eq(sounds, 0, "refused Show plays no sound")

--------------------------------------------------------------------------------
-- Init with an active Decree shows the banner once this session.
--------------------------------------------------------------------------------
reset()
local posted = Decree:Set({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "Bring a friend.",
})
assert_true(posted ~= nil, "Core Set posts a Decree")
frame = Banner:Init()
assert_eq(Banner:IsShown(), true, "Init shows the banner when Get is non-nil")
assert_eq(frame:IsShown(), true, "the widget is shown")
assert_eq(frame.HeaderText:GetText(), HEADER, "header is the fixed UI copy")
assert_eq(frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "line is Get().line")
assert_eq(frame.FlavorText:GetText(), "Bring a friend.", "flavor is Get().flavor")
assert_eq(frame.FlavorText:IsShown(), true, "flavor line is visible when set")
assert_eq(sounds, 0, "auto-show plays no sound")
assert_eq(frame:GetScript("OnUpdate"), nil, "shown banner has no OnUpdate")

local view = Banner:GetView()
assert_eq(view.shown, true, "view agrees the banner is shown")
assert_eq(view.header, HEADER, "view header is UI copy")
assert_eq(view.line, "Goldshire Inn — Sunday, 7:00 PM", "view line comes from Core")
assert_eq(view.flavor, "Bring a friend.", "view flavor comes from Core")
assert_eq(view.title, nil, "view does not invent a title")
assert_eq(view.deputy, nil, "view does not invent a deputy")
assert_eq(view.postedAt, nil, "view does not invent postedAt")

Banner:Init()
assert_eq(Banner:IsShown(), true, "second Init does not hide a shown banner")
assert_eq(Banner:Init(), frame, "second Init returns the same frame")

--------------------------------------------------------------------------------
-- Close dismisses. Same-session Init does not auto-show again. Show replays.
--------------------------------------------------------------------------------
local close = frame.CloseButton
assert_true(close ~= nil, "a close control exists")
assert_true(stub.fire(close, "OnClick"), "close is wired")
assert_eq(Banner:IsShown(), false, "close hides the banner")
assert_eq(sounds, 0, "close plays no addon sound")

Banner:Init()
assert_eq(Banner:IsShown(), false, "same-session Init does not auto-show again")

assert_eq(Banner:Show(), true, "Show replays an active Decree")
assert_eq(Banner:IsShown(), true, "minimap-style Show opens the banner again")
assert_eq(frame.HeaderText:GetText(), HEADER, "replay still paints the header")
assert_eq(frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "replay still paints the line")
assert_eq(sounds, 0, "replay plays no sound")

assert_eq(Banner:Hide(), true, "Hide succeeds")
assert_eq(Banner:IsShown(), false, "Hide dismisses the banner")
assert_eq(Banner:Hide(), true, "Hide on a closed banner is still success")

--------------------------------------------------------------------------------
-- Optional flavor. Extra stored fields are not a title line.
--------------------------------------------------------------------------------
reset()
Decree:Set({ line = "Shattrath — Friday, 8:00 PM" })
frame = Banner:Init()
assert_eq(Banner:IsShown(), true, "a line-only Decree still shows")
assert_eq(frame.HeaderText:GetText(), HEADER, "header stays the fixed copy")
assert_eq(frame.LineText:GetText(), "Shattrath — Friday, 8:00 PM", "line-only paints the line")
assert_eq(frame.FlavorText:GetText(), "", "omitted flavor paints empty")
assert_eq(frame.FlavorText:IsShown(), false, "omitted flavor hides the flavor line")
assert_eq(Banner:GetView().flavor, nil, "view flavor is nil when omitted")

Decree:Set({
  line = "Orgrimmar — Saturday",
  flavor = "The Gathering.",
  title = "A GATHERING HAS BEEN DECREED",
  deputy = "Steve",
})
assert_eq(Banner:Show(), true, "Show repaints after Set")
assert_eq(frame.LineText:GetText(), "Orgrimmar — Saturday", "repaint uses the new line")
assert_eq(frame.FlavorText:GetText(), "The Gathering.", "repaint uses the new flavor")
assert_eq(frame.FlavorText:IsShown(), true, "flavor line returns when set")
assert_eq(frame.HeaderText:GetText(), HEADER, "header is never taken from a stored title")
assert_eq(Banner:GetView().title, nil, "stored title is not a view field")
assert_eq(Banner:GetView().deputy, nil, "stored deputy is not a view field")

--------------------------------------------------------------------------------
-- GetView is a copy. Banner does not write Core.
--------------------------------------------------------------------------------
view = Banner:GetView()
view.line = "mutated"
view.header = "hacked"
view.shown = false
local again = Banner:GetView()
assert_eq(again.line, "Orgrimmar — Saturday", "mutating GetView does not change the live view")
assert_eq(again.header, HEADER, "mutating GetView does not change the header")
assert_eq(again.shown, true, "mutating GetView does not hide the banner")
assert_eq(Decree:Get().line, "Orgrimmar — Saturday", "banner does not write Core line")
assert_eq(Decree:Get().flavor, "The Gathering.", "banner does not write Core flavor")

--------------------------------------------------------------------------------
-- Clear: no empty parchment. Session flag is not SavedVariables.
--------------------------------------------------------------------------------
Decree:Clear()
assert_eq(Decree:Get(), nil, "Core Clear removes the Decree")
assert_eq(Banner:Show(), false, "Show after Clear refuses empty parchment")
assert_eq(Banner:IsShown(), false, "Clear + Show hides rather than painting blanks")

ChurchOfBeefDB = { ui = {} }
reset()
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
Banner:Init()
assert_eq(Banner:IsShown(), true, "Init shows with a live Decree")
Banner:Hide()
assert_eq(ChurchOfBeefDB.ui.decreeSeen, nil, "already-seen is not saved as decreeSeen")
assert_eq(ChurchOfBeefDB.ui.alreadySeen, nil, "already-seen is not saved as alreadySeen")
assert_eq(ChurchOfBeefDB.ui.shownThisSession, nil, "session flag is not a ui key")
assert_eq(ChurchOfBeefDB.decreeSeen, nil, "already-seen is not a root SV key")
assert_eq(ChurchOfBeefDB.ui.decree, nil, "Init without a drag writes no decree slot")
ChurchOfBeefDB = nil

--------------------------------------------------------------------------------
-- /reload (fresh module locals) may show again. Same-session Init does not.
--------------------------------------------------------------------------------
reset()
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "Bring a friend." })
Banner:Init()
assert_eq(Banner:IsShown(), true, "first login shows the banner")
Banner:Hide()
Banner:Init()
assert_eq(Banner:IsShown(), false, "same session does not auto-show twice")

dofile("addon/ChurchOfBeef/UI/Decree.lua")
Banner = COB.DecreeBanner
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "Core Decree survives the UI reload")
frame = Banner:Init()
assert_eq(Banner:IsShown(), true, "/reload may show the banner again")
assert_eq(frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "reloaded banner paints the live line")
assert_eq(frame.FlavorText:GetText(), "Bring a friend.", "reloaded banner paints the live flavor")

--------------------------------------------------------------------------------
-- Minimap:Init reaches the banner. Left-click replays or Toggles.
--------------------------------------------------------------------------------
reset()
local button = COB.Minimap:Init()
assert_true(button ~= nil, "Minimap:Init creates the button")
assert_eq(button.petitionPip, nil, "Quiet presence has no petition pip")
assert_eq(Banner:IsShown(), false, "Minimap:Init stays silent when Get is nil")
assert_eq(button:GetScript("OnUpdate"), nil, "a resting button runs nothing per frame")
frame = Banner.frame

stub.fire(button, "OnClick")
assert_eq(toggles, 1, "a plain click still opens the window when no Decree is set")
assert_eq(Banner:IsShown(), false, "a plain click does not invent a parchment")

Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
toggles = 0
stub.fire(button, "OnClick")
frame = Banner.frame
assert_eq(Banner:IsShown(), true, "left-click shows the banner when a Decree is active")
assert_eq(toggles, 0, "left-click does not Toggle while a Decree is active")
assert_eq(frame.HeaderText:GetText(), HEADER, "click replay paints the header")
assert_eq(frame.LineText:GetText(), "Goldshire Inn — Sunday, 7:00 PM", "click replay paints the line")
assert_eq(sounds, 0, "click replay plays no sound")

Banner:Hide()
stub.fire(button, "OnClick")
assert_eq(Banner:IsShown(), true, "left-click shows the banner again after dismiss")
assert_eq(toggles, 0, "replay still does not Toggle")

Decree:Clear()
toggles = 0
Banner:Hide()
stub.fire(button, "OnClick")
assert_eq(toggles, 1, "after Clear, left-click opens the window again")
assert_eq(Banner:IsShown(), false, "after Clear, click does not show empty parchment")

--------------------------------------------------------------------------------
-- Tooltip may name the Decree when one is active. Presence only.
--------------------------------------------------------------------------------
reset()
button = COB.Minimap:Init()
tipLines = {}
stub.fire(button, "OnEnter")
assert_true(tipHas("Church of Beef"), "tooltip names the addon")
assert_true(tipHas("Left-click: /beef"), "empty Decree tooltip keeps the /beef hint")
assert_eq(tipHas(HEADER), false, "empty Decree tooltip does not name a gathering")
assert_eq(tipHas("RSVP"), false, "tooltip has no RSVP")

Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
COB.Minimap:Refresh()
tipLines = {}
stub.fire(button, "OnEnter")
assert_true(tipHas("Church of Beef"), "active tooltip still names the addon")
assert_true(tipHas(HEADER), "active tooltip names the Decree header")
assert_true(tipHas("Goldshire Inn — Sunday, 7:00 PM"), "active tooltip names the Decree line")
assert_eq(tipHas("Left-click: /beef"), false, "active tooltip does not claim /beef on left-click")
assert_eq(tipHas("RSVP"), false, "active tooltip has no RSVP")
assert_eq(tipHas("3 days"), false, "tooltip has no countdown")

--------------------------------------------------------------------------------
-- Missing CreateFrame / missing custom media must not fail load.
--------------------------------------------------------------------------------
reset()
local savedCreate = CreateFrame
CreateFrame = nil
assert_eq(Banner:Init(), nil, "Init without CreateFrame returns nil")
assert_eq(Banner:IsShown(), false, "Init without CreateFrame stays hidden")
CreateFrame = savedCreate
frame = Banner:Init()
assert_true(frame ~= nil, "Init after CreateFrame returns builds the frame")
assert_eq(Banner:IsShown(), false, "rebuilt Init with no Decree stays silent")

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness.
--------------------------------------------------------------------------------
reset()
Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" })
Banner:Init()
assert_eq(Banner:IsShown(), true, "banner is showing before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(Banner:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Banner:IsShown(), true, "out-of-harness reset does not hide the banner")
ChurchOfBeef._IN_TEST = true
assert_eq(Banner:ResetForTests(), true, "ResetForTests returns under _IN_TEST")
assert_eq(Banner:IsShown(), false, "harness reset hides the banner")

assert_eq(sounds, 0, "the suite played no sound")

COB.UI = savedUi
restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
