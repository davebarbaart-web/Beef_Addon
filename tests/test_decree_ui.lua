-- Nights parchment + minimap (Quiet). Isolated: stub + Common + Nights + Theme + UI.
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
dofile("addon/ChurchOfBeef/Core/Nights.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/UI/NightRows.lua")
dofile("addon/ChurchOfBeef/UI/Decree.lua")
dofile("addon/ChurchOfBeef/UI/Minimap.lua")

local COB = ChurchOfBeef
local Nights = COB.Nights
local Banner = COB.DecreeBanner
local Mini = COB.Minimap

assert_true(Banner ~= nil, "DecreeBanner exists")
assert_eq(Banner.MODE, "QUIET", "Nights parchment is Quiet")
assert_eq(type(Banner.Init), "function", "Init")
assert_eq(type(Banner.Show), "function", "Show")

Nights:ResetForTests()
Banner:ResetForTests()
local frame = Banner:Init()
assert_true(frame ~= nil, "Init builds the frame")
assert_eq(Banner:IsShown(), false, "Init does not auto-show")

assert_eq(Banner:Show(), true, "Show opens the empty board")
assert_eq(Banner:IsShown(), true, "empty board is shown")
assert_eq(frame.LineText:GetText(), "No nights posted this week.", "empty copy")
assert_eq(frame.HeaderText:GetText(), "Nights", "header")

local THU = 1767290400
Nights:SetSeries({
  kind = "gathering",
  weekday = 5,
  timeLine = "7:00 PM",
  place = "Goldshire Inn",
}, THU)
Banner:Show()
assert_eq(frame.LineText:IsShown(), false, "posted board hides the empty blob")
local host = COB.NightRows:Host(frame.NightList)
assert_true(host ~= nil, "parchment owns a NightRows host")
assert_eq(host.rows[1]:IsShown(), true, "first night is its own row")
assert_eq(host.rows[1].Kind:GetText(), "Gathering", "row names the kind")
assert_eq(host.rows[1].KindRibbon._cobTextureName, "ribbon_bookmark",
  "parchment kind sits on a bookmark ribbon")
assert_true(host.rows[1].Where:GetText():find("Goldshire", 1, true) ~= nil,
  "row names the place")
assert_eq(host.rows[1].Going:IsShown(), true, "Going sits on that row")

local live = Nights:Week()
assert_true(#live >= 1, "posted series is on this week")
Nights:SetStub({
  kind = "raid",
  title = "Kara Thursday",
  timeLine = "8:00 PM",
  place = "Karazhan",
  date = live[1].date,
})
Banner:Show()
assert_eq(host.rows[2]:IsShown(), true, "second night is a second row")
assert_eq(host.rows[2].Kind:GetText(), "Kara Thursday", "stub title is its own row")
assert_eq(host.rows[2].Cue:GetText(), "Sign up on Discord", "stub cue stays on its row")
assert_eq(host.rows[1].Kind:GetText() == host.rows[2].Kind:GetText(), false,
  "two nights are not one concatenated line")

Banner:Hide()
assert_eq(Banner:IsShown(), false, "Hide")

local button = Mini:Init()
assert_true(button ~= nil, "minimap button")
stub.fire(button, "OnClick", "RightButton")
assert_eq(Banner:IsShown(), true, "right-click opens the parchment")

ChurchOfBeefDB = { ui = { nightsSeenRevision = 0 } }
assert_eq(Nights:BoardRevision() > 0, true, "posted series bumps revision")
assert_eq(Mini:RefreshGlow(), true, "unseen revision glows")
Banner:Show()
assert_eq(ChurchOfBeefDB.ui.nightsSeenRevision, Nights:BoardRevision(),
  "opening the parchment sets seen")
assert_eq(Mini:RefreshGlow(), false, "seen revision does not glow")

if restore then restore() end

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
