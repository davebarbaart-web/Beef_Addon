-- Fight HUD (Phase 4 Lane F). Isolated: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Hud.
-- Event Mode only. No live health, favor INPUT, sound, or toasts. Standalone wrap.
-- Ranks is Data for Church titles (Store rank ids). No TOC / bootstrap / run.lua edits.
package.path = package.path .. ";./tests/?.lua"

local stub = require("wow_ui_stub")
local restore = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local standalone = (type(assert_eq) ~= "function")
local passed = 0
local failed = 0

if standalone then
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

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")
dofile("addon/ChurchOfBeef/UI/Hud.lua")

local COB = ChurchOfBeef
local Hud = COB.Hud
local Gora = COB.Gora
local Store = COB.Store
local Runtime = COB.Runtime
local Ranks = COB.Ranks

local sounds = 0
PlaySound = function()
  sounds = sounds + 1
end
PlaySoundFile = function()
  sounds = sounds + 1
end

local healthReads = 0
UnitHealth = function()
  healthReads = healthReads + 1
  return 100
end
UnitHealthMax = function()
  healthReads = healthReads + 1
  return 100
end
CombatLogGetCurrentEventInfo = function()
  healthReads = healthReads + 1
end
C_NamePlate = {
  GetNamePlates = function()
    healthReads = healthReads + 1
    return {}
  end,
}

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Gora:ResetForTests(), true, "Gora ResetForTests runs under _IN_TEST")
  assert_eq(Hud:ResetForTests(), true, "Hud ResetForTests runs under _IN_TEST")
  sounds = 0
  healthReads = 0
end

local function twoChars(fieldsA, fieldsB)
  local a = Store:CreateCharacter(fieldsA or { name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter(fieldsB or { name = "Tendermage", class = "Mage", level = 68 })
  return a, b
end

local function sanctionPair()
  reset()
  Runtime:StartEvent()
  local a, b = twoChars()
  local pair = Gora:Sanction(a.id, b.id)
  return a, b, pair
end

local function findStatusBar(widget)
  if widget._type == "StatusBar" then return widget end
  for i = 1, #(widget._children or {}) do
    local hit = findStatusBar(widget._children[i])
    if hit then return hit end
  end
  return nil
end

local function sameRgb(color, sample)
  return color and sample
    and color.r == sample.r and color.g == sample.g and color.b == sample.b
end

--------------------------------------------------------------------------------
-- Isolated surface. Other modules stay nil only when this file is the process.
--------------------------------------------------------------------------------
assert_true(Hud ~= nil, "Hud is loaded")
assert_true(Store ~= nil, "Store is loaded")
assert_true(Runtime ~= nil, "Runtime is loaded")
assert_true(Gora ~= nil, "Gora is loaded")
assert_true(Ranks ~= nil, "Ranks is loaded for Church titles")
assert_true(COB.Names ~= nil, "Common name law is loaded")

if standalone then
  assert_eq(COB.Net, nil, "isolated suite does not load BeefNet")
  assert_eq(COB.UI, nil, "isolated suite does not load the Quiet shell")
  assert_eq(COB.Toasts, nil, "isolated suite does not load Toasts")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Sender, nil, "isolated suite does not load Sender")
  assert_eq(COB.Codec, nil, "isolated suite does not load Codec")
  assert_eq(COB.Snapshot, nil, "isolated suite does not load Snapshot")
  assert_eq(COB.Knighting, nil, "isolated suite does not load Knighting")
  assert_eq(COB.Minimap, nil, "isolated suite does not load Minimap")
  assert_eq(COB.Console, nil, "isolated suite does not load Console")
end

assert_eq(Hud.MODE, "Event", "HUD declares Event Mode")
assert_eq(type(Hud.Init), "function", "Init builds the surface")
assert_eq(type(Hud.Refresh), "function", "Refresh paints from Core")
assert_eq(type(Hud.IsShown), "function", "IsShown reads visibility")
assert_eq(type(Hud.GetView), "function", "GetView returns a copy")
assert_eq(type(Hud.ResetForTests), "function", "ResetForTests is a harness hatch")
assert_eq(Hud.Favor, nil, "no favor INPUT")
assert_eq(Hud.SendFavor, nil, "no favor send")
assert_eq(Hud.INPUT, nil, "no invented INPUT channel")
assert_eq(Hud.GetHealth, nil, "no health getter")
assert_eq(Hud.ScrapeHealth, nil, "no health scrape")
assert_eq(Hud.PlayCue, nil, "no sound this lane")
assert_eq(Hud.Toast, nil, "HUD is not a toast")
assert_eq(Hud.Announce, nil, "software does not announce")
assert_eq(Hud.Narrate, nil, "software does not narrate")
assert_eq(Hud.Sanction, nil, "HUD does not sanction")
assert_eq(Hud.DeclareVictor, nil, "HUD does not record outcomes")

--------------------------------------------------------------------------------
-- Source contract: no scrape, no StatusBar, no sound, no toast engine
--------------------------------------------------------------------------------
local srcFile = io.open("addon/ChurchOfBeef/UI/Hud.lua", "r")
assert_true(srcFile ~= nil, "Hud.lua is readable")
local src = srcFile:read("*a")
srcFile:close()
assert_eq(src:find("UnitHealth", 1, true), nil, "source does not read UnitHealth")
assert_eq(src:find("COMBAT_LOG", 1, true), nil, "source does not read the combat log")
assert_eq(src:find("NamePlate", 1, true), nil, "source does not scrape nameplates")
assert_eq(src:find("C_NamePlate", 1, true), nil, "source does not call C_NamePlate")
assert_eq(src:find("PlaySound", 1, true), nil, "source does not play sound")
assert_eq(src:find("StatusBar", 1, true), nil, "source does not mint a StatusBar")
assert_eq(src:find("Toasts", 1, true), nil, "source does not drive Toasts")
assert_eq(src:find("SendChatMessage", 1, true), nil, "source does not send chat")
assert_eq(src:find("ShowUIPanel", 1, true), nil, "insecure Show/Hide only")

--------------------------------------------------------------------------------
-- Init: hidden, top-center, movable, clamped. No per-frame script at rest.
--------------------------------------------------------------------------------
reset()
local frame = Hud:Init()
assert_true(frame ~= nil, "Init creates the HUD frame")
assert_eq(frame:GetName(), "ChurchOfBeefHud", "frame has a stable name")
assert_eq(frame:GetParent(), UIParent, "HUD is parented to UIParent")
assert_eq(Hud:Init(), frame, "Init is idempotent")
assert_eq(Hud:IsShown(), false, "HUD starts hidden in Quiet")
assert_eq(frame:IsShown(), false, "the widget starts hidden")
assert_eq(frame._movable, true, "HUD is movable")
assert_eq(frame._clamped, true, "HUD is clamped to screen")
assert_eq(frame:GetScript("OnUpdate"), nil, "a resting HUD runs nothing per frame")
assert_eq(findStatusBar(frame), nil, "Init mints no StatusBar")

local point, relativeTo, relativePoint, x, y = frame:GetPoint(1)
assert_eq(point, "TOP", "default anchor is the top")
assert_eq(relativeTo, UIParent, "default relative is UIParent")
assert_eq(relativePoint, "TOP", "default relative point is the top")
assert_eq(x, 0, "default is horizontally centered")
assert_true(type(y) == "number" and y < 0, "default sits below the top edge")

local view0 = Hud:GetView()
assert_eq(view0.shown, false, "Quiet view is hidden")
assert_eq(view0.fighterA, nil, "Quiet view has no fighter A")
assert_eq(view0.fighterB, nil, "Quiet view has no fighter B")
assert_eq(view0.headToHead, nil, "Quiet view has no head-to-head")
assert_eq(view0.health, nil, "view never carries health")
assert_eq(view0.favor, nil, "view never carries favor")

--------------------------------------------------------------------------------
-- Quiet and Event-without-a-pair stay hidden
--------------------------------------------------------------------------------
reset()
Hud:Refresh()
assert_eq(Hud:IsShown(), false, "QUIET with no pair hides the HUD")

Runtime:StartEvent()
Hud:Refresh()
assert_eq(Hud:IsShown(), false, "ASSEMBLY without a sanctioned pair stays hidden")
assert_eq(Gora:GetSanctioned(), nil, "no live pair yet")

twoChars()
Hud:Refresh()
assert_eq(Hud:IsShown(), false, "characters alone do not show the HUD")
assert_eq(Gora:GetSanctioned(), nil, "CreateCharacter is not a Sanction")

--------------------------------------------------------------------------------
-- Sanction in Event Mode shows the compact card
--------------------------------------------------------------------------------
local a, b, pair = sanctionPair()
assert_true(pair ~= nil, "Sanction returns a live pair")
local view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "Event Mode plus a live pair shows the HUD")
assert_eq(view.shown, true, "view agrees the HUD is shown")
assert_eq(view.mode, "Event", "painted view is Event Mode")
assert_eq(view.fighterA.name, "Chuckroast", "fighter A name comes from Store")
assert_eq(view.fighterB.name, "Tendermage", "fighter B name comes from Store")
assert_eq(view.fighterA.level, 70, "fighter A level comes from Store")
assert_eq(view.fighterB.level, 68, "fighter B level comes from Store")
assert_eq(view.fighterA.wins, 0, "fresh W/L starts at zero wins")
assert_eq(view.fighterA.losses, 0, "fresh W/L starts at zero losses")
assert_eq(view.fighterB.wins, 0, "other fresh W/L starts at zero wins")
assert_eq(view.fighterB.losses, 0, "other fresh W/L starts at zero losses")
assert_eq(view.fighterA.title, nil, "unlinked characters have no invented title")
assert_eq(view.fighterB.title, nil, "the other unlinked character has no invented title")
assert_eq(view.headToHead, nil, "no head-to-head line without Store history")
assert_eq(view.health, nil, "shown view still has no health")
assert_eq(view.favor, nil, "shown view still has no favor")
assert_eq(view.defenses, nil, "defense count is not invented")
assert_eq(view.odds, nil, "no odds copy")
assert_eq(frame.nameA:GetText(), "Chuckroast", "name A is painted")
assert_eq(frame.nameB:GetText(), "Tendermage", "name B is painted")
assert_eq(frame.levelA:GetText(), "70", "level A is painted")
assert_eq(frame.levelB:GetText(), "68", "level B is painted")
assert_eq(frame.recordA:GetText(), "0-0", "record A is Store W/L")
assert_eq(frame.recordB:GetText(), "0-0", "record B is Store W/L")
assert_eq(frame.headToHead:IsShown(), false, "head-to-head widget hides without history")
assert_eq(findStatusBar(frame), nil, "shown HUD still has no StatusBar")
assert_eq(sounds, 0, "showing the HUD plays no sound")
assert_eq(healthReads, 0, "showing the HUD does not read live health")
assert_eq(#stub.chat, 0, "HUD never SendChatMessage")
assert_eq(#stub.addonMessages, 0, "HUD never SendAddonMessage")

--------------------------------------------------------------------------------
-- Class color on the name only
--------------------------------------------------------------------------------
local warrior = RAID_CLASS_COLORS.WARRIOR
local mage = RAID_CLASS_COLORS.MAGE
assert_eq(view.fighterA.nameColor.r, warrior.r, "Warrior name uses class red")
assert_eq(view.fighterA.nameColor.g, warrior.g, "Warrior name uses class green")
assert_eq(view.fighterA.nameColor.b, warrior.b, "Warrior name uses class blue")
assert_eq(view.fighterB.nameColor.r, mage.r, "Mage name uses class red")
assert_eq(view.fighterB.nameColor.g, mage.g, "Mage name uses class green")
assert_eq(view.fighterB.nameColor.b, mage.b, "Mage name uses class blue")
assert_true(frame.nameA._cobColor ~= nil, "name A stores the applied tint")
assert_eq(frame.nameA._cobColor.r, warrior.r, "name A widget is class-tinted")
assert_eq(sameRgb(frame.levelA._cobColor, warrior), false, "level A is not class-colored")
assert_eq(sameRgb(frame.titleA._cobColor, warrior), false, "title A is not class-colored")
assert_eq(sameRgb(frame.recordA._cobColor, warrior), false, "record A is not class-colored")
assert_eq(sameRgb(frame.levelB._cobColor, mage), false, "level B is not class-colored")
assert_eq(sameRgb(frame.titleB._cobColor, mage), false, "title B is not class-colored")
assert_eq(sameRgb(frame.recordB._cobColor, mage), false, "record B is not class-colored")

--------------------------------------------------------------------------------
-- Church title from the human rank. No Fresh Beef default on an unlinked row.
--------------------------------------------------------------------------------
local human = Store:CreateHuman({ name = "Chuck" })
Store:LinkCharacter(a.id, human.id)
Store:SetRank(human.id, 3)
view = Hud:Refresh()
assert_eq(view.fighterA.title, "Beef Knight", "linked Knight title comes from Ranks")
assert_eq(frame.titleA:GetText(), "Beef Knight", "Knight title is painted")
assert_eq(view.fighterB.title, nil, "unlinked opponent still has no title")
assert_eq(frame.titleB:GetText(), "", "unlinked title paints empty, not Fresh Beef")

--------------------------------------------------------------------------------
-- Head-to-head appears only when Store already has history
--------------------------------------------------------------------------------
Gora:DeclareVictor(a.id)
assert_eq(Gora:GetSanctioned(), nil, "a ruling clears the live pair")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "HUD hides when the pair clears, even mid-event")
assert_eq(Store:GetCharacter(a.id).gora.wins, 1, "Store recorded the win")
assert_eq(Store:GetCharacter(b.id).gora.losses, 1, "Store recorded the loss")

local rematch = Gora:Sanction(a.id, b.id)
assert_true(rematch ~= nil, "same pair may be sanctioned again")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "a rematch shows the HUD again")
assert_eq(view.fighterA.wins, 1, "W/L reflects Store after the first ruling")
assert_eq(view.fighterA.losses, 0, "winner has no loss")
assert_eq(view.fighterB.wins, 0, "loser has no win")
assert_eq(view.fighterB.losses, 1, "loser has one loss")
assert_eq(frame.recordA:GetText(), "1-0", "painted record A follows Store")
assert_eq(frame.recordB:GetText(), "0-1", "painted record B follows Store")
assert_true(view.headToHead ~= nil, "Store history produces a head-to-head line")
assert_eq(view.headToHead.wins, 1, "head-to-head wins are fighter A's")
assert_eq(view.headToHead.losses, 0, "head-to-head losses are fighter A's")
assert_eq(view.headToHead.fights, 1, "head-to-head fights come from Store")
assert_eq(view.headToHead.score, nil, "head-to-head has no pairing score")
assert_eq(frame.headToHead:IsShown(), true, "head-to-head widget shows when history exists")
assert_eq(frame.headToHead:GetText(), "1-0", "head-to-head line is the Store record")
assert_eq(string.find(frame.headToHead:GetText() or "", "meeting", 1, true), nil,
  "head-to-head is a record, not narration")
assert_eq(string.find(frame.headToHead:GetText() or "", "odds", 1, true), nil,
  "head-to-head has no odds copy")

--------------------------------------------------------------------------------
-- RITE / CONSEQUENCE with a live pair still show. QUIET hides.
--------------------------------------------------------------------------------
assert_true(Runtime:OpenRite("Gora", { fighters = { a.id, b.id } }) ~= nil, "OpenRite is a Runtime verb")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "RITE with a live pair still shows")
assert_eq(Runtime:Snapshot().state, "RITE", "runtime is RITE")

assert_true(Runtime:CloseRite() ~= nil, "CloseRite reaches CONSEQUENCE")
view = Hud:Refresh()
assert_eq(Runtime:Snapshot().state, "CONSEQUENCE", "runtime is CONSEQUENCE")
assert_eq(Hud:IsShown(), true, "CONSEQUENCE with a live pair still shows")

assert_true(Runtime:MarkPopeLost() ~= nil, "awaitingPope is Event Mode degraded")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "awaitingPope does not hide a live pair")
Runtime:ClearPopeLost()

assert_true(Runtime:Continue() ~= nil, "Continue returns to ASSEMBLY")
view = Hud:Refresh()
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "runtime is ASSEMBLY again")
assert_eq(Hud:IsShown(), true, "ASSEMBLY with a live pair still shows")

assert_true(Runtime:EndEvent() ~= nil, "EndEvent returns to QUIET")
assert_eq(Runtime:Snapshot().state, "QUIET", "runtime is QUIET")
assert_eq(Gora:GetSanctioned(), nil, "QUIET expires the live pair")
view = Hud:Refresh()
assert_eq(Hud:IsShown(), false, "Quiet Mode hides the HUD")
assert_eq(view.shown, false, "Quiet view is hidden")
assert_eq(sounds, 0, "hiding plays no sound")
assert_eq(healthReads, 0, "hiding does not scrape health")

--------------------------------------------------------------------------------
-- Knighting rite does not hide a sanctioned pair. HUD keys off pair + not QUIET.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
Runtime:OpenRite("Knighting", { candidate = a.id })
view = Hud:Refresh()
assert_eq(Runtime:Snapshot().riteType, "Knighting", "rite type is Knighting")
assert_eq(Hud:IsShown(), true, "a live pair still shows during another rite")

--------------------------------------------------------------------------------
-- Missing class colors and unknown class still paint names
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars({ name = "Mystery", class = "Banana", level = 10 }, { name = "Plain", level = 12 })
Gora:Sanction(a.id, b.id)
local savedColors = RAID_CLASS_COLORS
RAID_CLASS_COLORS = nil
view = Hud:Refresh()
assert_eq(Hud:IsShown(), true, "missing RAID_CLASS_COLORS does not hide the HUD")
assert_eq(view.fighterA.name, "Mystery", "unknown class still shows the name")
assert_eq(view.fighterA.nameColor, nil, "unknown class has no invented tint")
assert_eq(view.fighterB.name, "Plain", "a class-less fighter still shows")
RAID_CLASS_COLORS = savedColors

view = Hud:Refresh()
assert_eq(view.fighterA.nameColor, nil, "Banana is not a class file")
assert_eq(frame.nameA:GetText(), "Mystery", "name survives a missing class tint")

--------------------------------------------------------------------------------
-- GetView returns a copy. HUD does not write Store or Gora.
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
view = Hud:Refresh()
view.fighterA.name = "Mutated"
view.shown = false
local again = Hud:GetView()
assert_eq(again.fighterA.name, "Chuckroast", "mutating GetView does not change the live view")
assert_eq(again.shown, true, "mutating GetView does not hide the HUD")
assert_eq(Store:GetCharacter(a.id).name, "Chuckroast", "HUD does not write the character")
assert_eq(Gora:GetSanctioned().fighterA, a.id, "HUD does not clear the live pair")

--------------------------------------------------------------------------------
-- Drag persists when ChurchOfBeefDB.ui exists. Invalid saved point falls back.
--------------------------------------------------------------------------------
ChurchOfBeefDB = { ui = {} }
reset()
frame = Hud:Init()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
Hud:Refresh()
stub.fire(frame, "OnDragStart")
assert_eq(frame._moving, true, "drag starts a move")
frame:ClearAllPoints()
frame:SetPoint("TOP", UIParent, "TOP", 40, -80)
stub.fire(frame, "OnDragStop")
assert_eq(frame._moving, false, "drop stops the move")
assert_eq(frame:GetScript("OnUpdate"), nil, "drop leaves no animator")
local saved = ChurchOfBeefDB.ui.hud
assert_true(type(saved) == "table", "moved position is saved")
assert_eq(saved.point, "TOP", "saved anchor point")
assert_eq(saved.relativePoint, "TOP", "saved relative point")
assert_eq(saved.x, 40, "saved x")
assert_eq(saved.y, -80, "saved y")
assert_eq(saved.relativeTo, nil, "no frame reference lands in SavedVariables")

dofile("addon/ChurchOfBeef/UI/Hud.lua")
Hud = COB.Hud
local reloaded = Hud:Init()
local rp, rto, rrp, rx, ry = reloaded:GetPoint(1)
assert_eq(rp, "TOP", "saved top anchor restores")
assert_eq(rto, UIParent, "restore still parents to UIParent")
assert_eq(rrp, "TOP", "saved relative top restores")
assert_eq(rx, 40, "saved x restores")
assert_eq(ry, -80, "saved y restores")
frame = reloaded

ChurchOfBeefDB.ui.hud = { point = "MIDDLE-OF-NOWHERE", relativePoint = "CENTER", x = 1, y = 2 }
dofile("addon/ChurchOfBeef/UI/Hud.lua")
Hud = COB.Hud
local safe = Hud:Init()
assert_eq(select(1, safe:GetPoint(1)), "TOP", "invalid saved anchor falls back to top")
assert_eq(select(4, safe:GetPoint(1)), 0, "invalid saved x falls back to center")
frame = safe
ChurchOfBeefDB = nil

--------------------------------------------------------------------------------
-- ResetForTests is inert outside the harness
--------------------------------------------------------------------------------
reset()
Runtime:StartEvent()
a, b = twoChars()
Gora:Sanction(a.id, b.id)
Hud:Refresh()
assert_eq(Hud:IsShown(), true, "HUD is showing before the out-of-harness reset")
ChurchOfBeef._IN_TEST = false
assert_eq(Hud:ResetForTests(), false, "ResetForTests refuses to run outside tests")
assert_eq(Hud:IsShown(), true, "out-of-harness reset does not hide the HUD")
ChurchOfBeef._IN_TEST = true

--------------------------------------------------------------------------------
-- Toast trap: Refresh must not call a toast engine if one is present
--------------------------------------------------------------------------------
local toastCalls = 0
local savedToasts = COB.Toasts
COB.Toasts = {
  Show = function() toastCalls = toastCalls + 1 end,
  Push = function() toastCalls = toastCalls + 1 end,
  Celebrate = function() toastCalls = toastCalls + 1 end,
}
Hud:Refresh()
assert_eq(toastCalls, 0, "HUD does not toast")
COB.Toasts = savedToasts

assert_eq(sounds, 0, "the suite played no sound")
assert_eq(healthReads, 0, "the suite never scraped health")

restore()

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
