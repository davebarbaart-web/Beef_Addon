-- Shared night-row language. Isolated: Common + Nights + Theme + NightRows.
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

local COB = ChurchOfBeef
local Rows = COB.NightRows

assert_true(Rows ~= nil, "COB.NightRows exists")
assert_eq(Rows.MODE, "QUIET", "NightRows declares Quiet Mode")

local church = {
  source = "series",
  kind = "gathering",
  key = "1/2026-09-15",
  date = "2026-09-15",
  place = "Goldshire Inn",
  timeLine = "7:00 PM",
  goingCount = 1,
}
local stubRow = {
  source = "stub",
  kind = "raid",
  title = "Kara Thursday",
  date = "2026-09-20",
  place = "Karazhan",
  timeLine = "8:00 PM",
}

local view = Rows.Present(church)
assert_eq(view.date, "Sep 15", "church date is short")
assert_eq(view.kind, "Gathering", "church kind")
assert_eq(Rows.KindLabel({ kind = "knighting" }), "Knighting", "knighting ribbon is short")
assert_eq(Rows.KindLabel({ kind = "gora" }), "Gora", "gora ribbon is short")
assert_eq(Rows.KindRole(church), "gathering", "church gathering is umber")
assert_eq(Rows.KindRole({ kind = "knighting" }), "knighting", "knighting is bronze")
assert_eq(Rows.KindRole({ kind = "gora" }), "gora", "gora is steel")
assert_eq(Rows.KindRole(stubRow), "notice", "stub is pewter")
assert_eq(view.where, "Goldshire Inn · 7:00 PM", "church where")
assert_eq(view.church, true, "church is Going-eligible")
assert_eq(view.going, 1, "church going count")
assert_eq(view.cue, nil, "church has no Discord cue")

local stubView = Rows.Present(stubRow)
assert_eq(stubView.kind, "Kara Thursday", "stub title is the kind line")
assert_eq(stubView.church, false, "stub is not Going")
assert_eq(stubView.cue, "Sign up on Discord", "stub cue")
assert_eq(stubView.where, "Karazhan · 8:00 PM", "stub where")

local compact = Rows.Metrics(260, 160, "card")
assert_eq(compact.compact, true, "narrow card is compact")
assert_eq(compact.twoLine, false, "compact is one line")
assert_true(compact.visible >= 3, "compact still shows at least three rows")
assert_eq(compact.font, 12, "compact never drops below 12px")

local cardRoom = Rows.Metrics(350, 100, "card")
assert_eq(cardRoom.compact, false, "card compact is width-only")
assert_eq(cardRoom.twoLine, true, "card week list stays two-line in a short host")
assert_eq(cardRoom.actionW, 64, "Going stays a compact chip")

local roomy = Rows.Metrics(440, 260, "parchment")
assert_eq(roomy.compact, false, "parchment width is comfortable")
assert_eq(roomy.twoLine, true, "comfortable rows are two-line")
assert_true(roomy.visible >= 5, "parchment shows several rows")

local parent = CreateFrame("Frame")
parent:SetWidth(400)
parent:SetHeight(200)
local host = Rows:Attach(parent, { variant = "parchment", pool = 6 })
assert_true(host ~= nil, "Attach builds a host")
assert_eq(Rows:Paint(host, { church, stubRow }), true, "Paint two rows")
assert_eq(host.rows[1]:IsShown(), true, "first row shown")
assert_eq(host.rows[2]:IsShown(), true, "second row shown")
assert_eq(host.rows[1].Kind:GetText(), "Gathering", "first row kind")
assert_eq(host.rows[1].Date._cobFontPath, COB.Theme:FontPath("label"),
  "parchment date uses Theme label")
assert_eq(host.rows[1].Kind._cobFontPath, COB.Theme:FontPath("label"),
  "parchment kind uses Theme label")
assert_eq(host.rows[1].Where._cobFontPath, COB.Theme:FontPath("body"),
  "parchment where uses Theme body")
assert_eq(host.rows[1].Kind._cobColorRole, "parchment", "kind ink is parchment on the cloth")
assert_eq(host.rows[1].KindRibbon._cobColorRole, "gathering", "Gathering cloth is umber")
assert_eq(host.rows[1].KindRibbon._cobTextureName, "ribbon_bookmark",
  "kind sits on the bookmark ribbon")
assert_eq(host.rows[1].KindRibbon:IsShown(), true, "kind ribbon is shown")
assert_eq(host.rows[1].KindRibbon:GetHeight(), 20, "kind ribbon is 20px")
assert_true(host.rows[1].KindRibbon:GetWidth() >= 80, "kind ribbon is at least 80px")
assert_true(host.rows[1].KindRibbon:GetWidth() <= 180, "parchment ribbon stays within 180")
assert_eq(host.rows[2].KindRibbon._cobColorRole, "notice", "stub cloth is pewter")
assert_eq(host.rows[2].Kind._cobColorRole, "parchment", "stub kind ink is parchment")
assert_true(host.rows[2].KindRibbon:GetWidth() >= host.rows[1].KindRibbon:GetWidth(),
  "stub title gets a wider chip than Gathering")
assert_eq(host.rows[1].Where:GetText(), "Goldshire Inn · 7:00 PM", "first row where")
assert_eq(host.rows[1].Going:IsShown(), true, "church Going is on its row")
assert_eq(host.rows[1].Going._cobStockTemplate, "UIPanelButtonTemplate",
  "Going is a stock panel button")
assert_eq(host.rows[1].Going:GetWidth(), 64, "Going does not steal the title")
assert_eq(host.rows[1].Going.Label:GetText(), "Going 1", "Going names the count")
assert_eq(host.rows[2].Cue:GetText(), "Sign up on Discord", "stub cue is on its row")
assert_eq(host.rows[2].Going:IsShown(), false, "stub has no Going")
assert_eq(host.empty:IsShown(), false, "empty copy hides when rows exist")

local knight = {
  source = "series",
  kind = "knighting",
  key = "2/2026-09-16",
  date = "2026-09-16",
  place = "Goldshire Inn",
  timeLine = "8:00 PM",
}
local goraNight = {
  source = "series",
  kind = "gora",
  key = "3/2026-09-17",
  date = "2026-09-17",
  place = "Goldshire Inn",
  timeLine = "9:00 PM",
}
assert_eq(Rows:Paint(host, { knight, goraNight }), true, "Paint rite nights")
assert_eq(host.rows[1].KindRibbon._cobColorRole, "knighting", "Knighting cloth is bronze")
assert_eq(host.rows[1].Kind._cobColorRole, "parchment", "Knighting ink is parchment")
assert_eq(host.rows[2].KindRibbon._cobColorRole, "gora", "Gora cloth is steel")

assert_eq(Rows:Paint(host, {}), true, "Paint empty")
assert_eq(host.empty:GetText(), "No nights posted this week.", "empty copy")
assert_eq(host.rows[1]:IsShown(), false, "rows hide when empty")
assert_eq(host.rows[1].KindRibbon:IsShown(), false, "empty hides the kind ribbon")

local compactParent = CreateFrame("Frame")
compactParent:SetWidth(260)
compactParent:SetHeight(160)
local compactHost = Rows:Attach(compactParent, { variant = "card", pool = 4 })
assert_eq(Rows:Paint(compactHost, { church }), true, "Paint compact card")
assert_eq(compactHost.metrics.twoLine, false, "narrow card stays one line")
assert_eq(compactHost.rows[1].Kind:GetText(), "Gathering", "compact ribbon is kind only")
assert_eq(compactHost.rows[1].Where:GetText(), "Goldshire Inn · 7:00 PM",
  "compact keeps where beside the ribbon")
assert_eq(compactHost.rows[1].Kind:GetText():find("Goldshire", 1, true), nil,
  "compact does not pour where into the kind ribbon")
assert_eq(compactHost.rows[1].Date._cobFontPath, nil, "card date is stock GameFont")
assert_eq(compactHost.rows[1].Kind._cobFontPath, nil, "card kind is stock GameFont")
assert_eq(compactHost.rows[1].Where._cobFontPath, nil, "card where is stock GameFont")
assert_eq(compactHost.rows[1].KindRibbon._cobColorRole, "gathering", "card Gathering cloth is umber")
assert_true(compactHost.rows[1].KindRibbon:GetWidth() <= 140, "card ribbon max is 140")

local f = io.open("addon/ChurchOfBeef/UI/NightRows.lua", "r")
assert_true(f ~= nil, "NightRows.lua is readable")
local src = f:read("*a")
f:close()
assert_eq(src:find('kindRibbon._cobColorRole = "oxblood"', 1, true), nil,
  "rows are not locked to oxblood")
assert_eq(src:find('colorText(kindFs, "gold")', 1, true), nil,
  "kind ink is not gold")

if restore then restore() end

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
