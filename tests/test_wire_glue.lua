-- Bootstrap wire glue (W-INT / B3-INT / B4-INT / B5-INT / B10-INT / B11-INT /
-- B14-INT / B38-INT / B39-INT). Isolated: Common +
-- Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Codec +
-- Snapshot + BeefNet + Console + Hud + ChurchOfBeef.lua. FighterCard /
-- Inputs / Markers are spies, not the UI modules. InstallWire
-- only — no Data/Popes.lua. Pope predicate is stubbed in-test and restored.
-- Standalone wrap.
package.path = package.path .. ";./tests/?.lua"

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

local stub = require("wow_ui_stub")
local restoreUi = stub.install()

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

SlashCmdList = SlashCmdList or {}
DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or { AddMessage = function() end }

UnitName = function(unit)
  if unit == "player" then return "Beefina" end
  return nil
end

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")
dofile("addon/ChurchOfBeef/Core/Knighting.lua")
dofile("addon/ChurchOfBeef/Core/Sender.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/Net/Codec.lua")
dofile("addon/ChurchOfBeef/Net/Snapshot.lua")
dofile("addon/ChurchOfBeef/Net/BeefNet.lua")
dofile("addon/ChurchOfBeef/UI/Console.lua")
dofile("addon/ChurchOfBeef/UI/Hud.lua")

local origStart = ChurchOfBeef.Runtime.StartEvent
local origOpen = ChurchOfBeef.Runtime.OpenRite
local origClose = ChurchOfBeef.Runtime.CloseRite
local origContinue = ChurchOfBeef.Runtime.Continue
local origEnd = ChurchOfBeef.Runtime.EndEvent
local origFavor = ChurchOfBeef.Gora.RecordFavor
local origFavorFrom = ChurchOfBeef.Gora.RecordFavorFromSender
local origSanction = ChurchOfBeef.Gora.Sanction
local origVictor = ChurchOfBeef.Gora.DeclareVictor
local origVoid = ChurchOfBeef.Gora.Void
local origFree = ChurchOfBeef.Gora.FreeRuling
local origCoward = ChurchOfBeef.Gora.CowardiceRecorded
local origKnight = ChurchOfBeef.Knighting.KnightThisBeef
local origElevate = ChurchOfBeef.Knighting.ElevateToLord
local origCard = ChurchOfBeef.FighterCard
local origInputs = ChurchOfBeef.Inputs
local origMarkers = ChurchOfBeef.Markers
local origToggle = ChurchOfBeef.Console.SetCongregationFavorVisible
local origPost = ChurchOfBeef.Console.PostDecree
local origClear = ChurchOfBeef.Decree.Clear
local origDecreeSet = ChurchOfBeef.Decree.Set
local origBanner = ChurchOfBeef.DecreeBanner
local origHandleState = ChurchOfBeef.Net._HandleState
local origHandleSnap = ChurchOfBeef.Net._HandleSnapshot
local origStoreRestore = ChurchOfBeef.Store.Restore
local origPope = ChurchOfBeef.Sender.IsRegisteredPope
local origProclaim = ChurchOfBeef.Toasts and ChurchOfBeef.Toasts.Proclaim

dofile("addon/ChurchOfBeef/ChurchOfBeef.lua")

local COB = ChurchOfBeef
local Runtime = COB.Runtime
local Store = COB.Store
local Gora = COB.Gora
local Knighting = COB.Knighting
local Sender = COB.Sender
local Decree = COB.Decree
local Codec = COB.Codec
local Net = COB.Net
local Console = COB.Console
local Hud = COB.Hud

local wire = {}
local favorSpy = {}
local targetSpy = {}
local localIdSpy = {}
local proclaimSpy = {}
local cardShowSpy = {}
local cardRefreshSpy = {}
local cardHideSpy = {}
local hudRefreshSpy = {}
local inputRefreshSpy = {}
local inputHideSpy = {}
local inputTargetBindSpy = {}
local inputLocalSpy = {}
local inputPetitionSpy = {}
local inputShowSpy = {}
local inputCatchupSpy = {}
local markerTargetSpy = {}
local markerCandidateSpy = {}
local markerFightersSpy = {}
local origSetFavor = Hud.SetBroadcastFavor
local origSetTarget = Hud.SetFavorTarget
local origSetLocal = Hud.SetLocalCharacterId
local origHudRefresh = Hud.Refresh

local function hookHud()
  favorSpy = {}
  targetSpy = {}
  localIdSpy = {}
  hudRefreshSpy = {}
  Hud.SetBroadcastFavor = function(self, favor)
    favorSpy[#favorSpy + 1] = favor
    return origSetFavor(self, favor)
  end
  Hud.SetFavorTarget = function(self, target)
    targetSpy[#targetSpy + 1] = target
    return origSetTarget(self, target)
  end
  Hud.SetLocalCharacterId = function(self, characterId)
    localIdSpy[#localIdSpy + 1] = characterId
    return origSetLocal(self, characterId)
  end
  Hud.Refresh = function(self, ...)
    hudRefreshSpy[#hudRefreshSpy + 1] = true
    return origHudRefresh(self, ...)
  end
end

local function hookProclaim()
  proclaimSpy = {}
  COB.Toasts = COB.Toasts or {}
  COB.Toasts.Proclaim = function(_, kind, fields)
    proclaimSpy[#proclaimSpy + 1] = { kind = kind, fields = fields }
    return true
  end
end

local function hookCard()
  cardShowSpy = {}
  cardRefreshSpy = {}
  cardHideSpy = {}
  COB.FighterCard = {
    Show = function()
      cardShowSpy[#cardShowSpy + 1] = true
      return true
    end,
    Refresh = function()
      cardRefreshSpy[#cardRefreshSpy + 1] = true
      return {}
    end,
    Hide = function()
      cardHideSpy[#cardHideSpy + 1] = true
      return true
    end,
  }
end

local function hookFurniture()
  inputRefreshSpy = {}
  inputHideSpy = {}
  inputTargetBindSpy = {}
  inputLocalSpy = {}
  inputPetitionSpy = {}
  inputShowSpy = {}
  inputCatchupSpy = {}
  COB.Inputs = {
    SetInputTarget = function(_, name)
      inputTargetBindSpy[#inputTargetBindSpy + 1] = name
    end,
    SetLocalCharacterId = function(_, characterId)
      inputLocalSpy[#inputLocalSpy + 1] = characterId
    end,
    Refresh = function()
      inputRefreshSpy[#inputRefreshSpy + 1] = true
      return {}
    end,
    Hide = function()
      inputHideSpy[#inputHideSpy + 1] = true
      return true
    end,
    Petition = function()
      inputPetitionSpy[#inputPetitionSpy + 1] = true
      return true
    end,
    Show = function()
      inputShowSpy[#inputShowSpy + 1] = true
      return true
    end,
    Catchup = function()
      inputCatchupSpy[#inputCatchupSpy + 1] = true
      return true
    end,
  }
end

local function hookMarkers()
  markerTargetSpy = {}
  markerCandidateSpy = {}
  markerFightersSpy = {}
  COB.Markers = {
    Target = function(_, name)
      markerTargetSpy[#markerTargetSpy + 1] = name
      return true
    end,
    MarkCandidate = function(_, name)
      markerCandidateSpy[#markerCandidateSpy + 1] = name
      return true
    end,
    MarkFighters = function(_, nameA, nameB)
      markerFightersSpy[#markerFightersSpy + 1] = { nameA, nameB }
      return true
    end,
  }
end

local function armTransmit()
  wire = {}
  Net.transmit = function(payload, channel, target)
    wire[#wire + 1] = {
      payload = payload,
      channel = channel,
      target = target,
    }
  end
end

local function reset()
  assert_eq(Store:ResetForTests(), true, "Store ResetForTests runs under _IN_TEST")
  assert_eq(Runtime:ResetForTests(), true, "Runtime ResetForTests runs under _IN_TEST")
  assert_eq(Gora:ResetForTests(), true, "Gora ResetForTests runs under _IN_TEST")
  assert_eq(Decree:ResetForTests(), true, "Decree ResetForTests runs under _IN_TEST")
  assert_eq(Net:ResetForTests(), true, "Net ResetForTests runs under _IN_TEST")
  if Console.ResetForTests then
    assert_eq(Console:ResetForTests(), true, "Console ResetForTests runs under _IN_TEST")
  end
  if Hud.ResetForTests then
    assert_eq(Hud:ResetForTests(), true, "Hud ResetForTests runs under _IN_TEST")
  end
  COB._inspecting = nil
  COB._lastCastNames = nil
  COB._lastCast = nil
  COB._fighterCardDismissed = false
  COB._snapshotAsked = nil
  armTransmit()
  hookHud()
  hookProclaim()
  hookCard()
  hookFurniture()
  hookMarkers()
end

local function decodeLast()
  local last = wire[#wire]
  if not last then return nil end
  return Codec:Decode(last.payload)
end

local function lastOfType(msgType)
  for i = #wire, 1, -1 do
    local msg = Codec:Decode(wire[i].payload)
    if msg and msg.type == msgType then return msg, wire[i] end
  end
  return nil
end

local function countType(msgType)
  local n = 0
  for i = 1, #wire do
    local msg = Codec:Decode(wire[i].payload)
    if msg and msg.type == msgType then n = n + 1 end
  end
  return n
end

local function twoChars()
  local a = Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local b = Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
  return a, b
end

local function stubPope()
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "beefina"
  end
end

--------------------------------------------------------------------------------
-- Isolated surface. Pope list stays unloaded. Glue is not installed at load.
--------------------------------------------------------------------------------
assert_true(COB.InstallWire ~= nil, "InstallWire exists")
assert_eq(type(COB.InstallWire), "function", "InstallWire is a function")
assert_eq(COB._wireInstalled, nil, "dofile does not install wraps")
assert_eq(COB._OnPeerHello, nil, "dofile does not install the peer-HELLO callback")
assert_eq(Runtime.StartEvent, origStart, "StartEvent is unwrapped at load")
assert_eq(COB.Popes, nil, "no COB.Popes (#8 is not coded)")
assert_true(Knighting ~= nil, "isolated suite loads Knighting")
assert_true(COB.Ranks ~= nil, "isolated suite loads Ranks for Knighting")
assert_eq(type(Knighting.KnightThisBeef), "function", "KnightThisBeef exists")
assert_eq(type(Knighting.ElevateToLord), "function", "ElevateToLord exists")

if standalone then
  assert_eq(COB.Scoring, nil, "isolated suite does not load Scoring")
  assert_eq(COB.Ladder, nil, "isolated suite does not load Ladder")
  assert_eq(COB.Officer, nil, "isolated suite does not load Officer")
  assert_eq(COB.DB, nil, "isolated suite does not load DB")
  assert_eq(COB.Archive, nil, "isolated suite does not load Archive")
  assert_eq(COB.Recognition, nil, "isolated suite does not load Recognition")
  assert_eq(COB.Popes, nil, "isolated suite does not load Data/Popes.lua")
  assert_eq(origCard, nil, "isolated suite does not load FighterCard")
end

assert_eq(UnitName("player"), "Beefina", "UnitName is stubbed to Beefina")
assert_eq(Sender:IsRegisteredPope("Beefina"), false, "unstubbed Beefina is not a Pope")

--------------------------------------------------------------------------------
-- Lane T fix wave: bootstrap initUi coverage. OnLogin Inits the UI
-- modules in the contract order (Welcome after DecreeBanner), a throwing
-- Console.Init does not prevent later modules (pcall shape), and
-- InstallWire still runs. Every stubbed key is saved and restored.
--------------------------------------------------------------------------------
do
  local order = {}
  local function initSpy(name)
    return function()
      order[#order + 1] = name
      return true
    end
  end
  local savedMinimap = COB.Minimap
  local savedRecordsBook = COB.RecordsBook
  local savedPlayerCard = COB.PlayerCard
  local savedHud = COB.Hud
  local savedConsole = COB.Console
  local savedToasts = COB.Toasts
  local savedDecreeBanner = COB.DecreeBanner
  local savedWelcome = COB.Welcome
  local savedSound = COB.Sound
  local savedFighterCard = COB.FighterCard
  local savedInputs = COB.Inputs
  local savedMarkers = COB.Markers
  local savedNetInit = COB.Net.Init
  local savedInstallWire = COB.InstallWire

  COB.Minimap = { Init = initSpy("Minimap") }
  COB.RecordsBook = { Init = initSpy("RecordsBook") }
  COB.PlayerCard = { Init = initSpy("PlayerCard") }
  COB.Hud = { Init = initSpy("Hud") }
  COB.Console = { Init = initSpy("Console") }
  COB.Toasts = { Init = initSpy("Toasts") }
  COB.DecreeBanner = { Init = initSpy("DecreeBanner") }
  COB.Welcome = { Init = initSpy("Welcome") }
  COB.Sound = { Init = initSpy("Sound") }
  COB.FighterCard = { Init = initSpy("FighterCard") }
  COB.Inputs = { Init = initSpy("Inputs") }
  COB.Markers = { Init = initSpy("Markers") }
  local netInits = 0
  COB.Net.Init = function()
    netInits = netInits + 1
    return true
  end
  local wireCalls = 0
  COB.InstallWire = function()
    wireCalls = wireCalls + 1
    return true
  end

  local contractOrder = "Minimap,RecordsBook,PlayerCard,Hud,Console,Toasts,DecreeBanner,Welcome,Sound,FighterCard,Inputs,Markers"
  COB:OnLogin()
  assert_eq(table.concat(order, ","), contractOrder,
    "OnLogin Inits the eleven UI modules in the contract order")
  assert_eq(netInits, 1, "OnLogin Inits Net once")
  assert_eq(wireCalls, 1, "OnLogin still runs InstallWire")

  order = {}
  COB.Console.Init = function()
    order[#order + 1] = "Console"
    error("console boom")
  end
  COB:OnLogin()
  assert_eq(table.concat(order, ","), contractOrder,
    "a throwing Console.Init does not prevent later module Inits")
  assert_eq(netInits, 2, "Net Init runs again on the second OnLogin")
  assert_eq(wireCalls, 2, "InstallWire still runs after a throwing Console.Init")

  order = {}
  local chats = {}
  local savedAdd = DEFAULT_CHAT_FRAME.AddMessage
  DEFAULT_CHAT_FRAME.AddMessage = function(_, m)
    chats[#chats + 1] = m
  end
  COB.Hud.Init = function()
    order[#order + 1] = "Hud"
    error("hud boom")
  end
  COB:OnLogin()
  DEFAULT_CHAT_FRAME.AddMessage = savedAdd
  assert_eq(table.concat(order, ","), contractOrder,
    "a throwing Hud.Init does not prevent later module Inits")
  assert_eq(netInits, 3, "Net Init still runs after a throwing Hud.Init")
  assert_eq(wireCalls, 3, "InstallWire still runs after a throwing Hud.Init")
  local sawHudFail = false
  for i = 1, #chats do
    local m = chats[i]
    if type(m) == "string" and m:find("Hud failed to start.", 1, true) then
      sawHudFail = true
    end
  end
  assert_eq(sawHudFail, true, "Hud Init failure prints Church of Beef: Hud failed to start.")

  COB.Minimap = savedMinimap
  COB.RecordsBook = savedRecordsBook
  COB.PlayerCard = savedPlayerCard
  COB.Hud = savedHud
  COB.Console = savedConsole
  COB.Toasts = savedToasts
  COB.DecreeBanner = savedDecreeBanner
  COB.Welcome = savedWelcome
  COB.Sound = savedSound
  COB.FighterCard = savedFighterCard
  COB.Inputs = savedInputs
  COB.Markers = savedMarkers
  COB.Net.Init = savedNetInit
  COB.InstallWire = savedInstallWire
end

COB:InstallWire()
assert_eq(COB._wireInstalled, true, "InstallWire marks itself installed")
assert_eq(type(COB._OnPeerHello), "function", "InstallWire installs the peer-HELLO callback")
COB:InstallWire()
assert_eq(COB._wireInstalled, true, "InstallWire is idempotent")

--------------------------------------------------------------------------------
-- Lane W: guildmate HELLO re-broadcast. _OnPeerHello sends STATE only when an
-- event is live and the local player is a registered Pope. QUIET no-ops.
-- A congregation client no-ops. Missing Runtime / Net are swallowed.
--------------------------------------------------------------------------------
do
  reset()
  stubPope()
  assert_eq(Runtime:Snapshot().state, "QUIET", "fresh runtime is QUIET")
  COB._OnPeerHello("Steakina")
  assert_eq(countType("STATE"), 0, "QUIET peer HELLO does not send STATE")

  assert_true(Runtime:StartEvent() ~= nil, "StartEvent for the HELLO re-broadcast")
  local beforeHello = countType("STATE")
  local inputRefreshes = #inputRefreshSpy
  COB._OnPeerHello("Steakina")
  assert_eq(countType("STATE"), beforeHello + 1,
    "live event + registered Pope re-broadcasts STATE on a peer HELLO")
  local helloState, helloFrame = lastOfType("STATE")
  assert_true(helloState ~= nil, "the re-broadcast decodes")
  assert_eq(helloState.state, "ASSEMBLY", "the re-broadcast carries the live state")
  assert_eq(helloFrame.channel, "GUILD", "the re-broadcast stays on GUILD")
  assert_eq(#inputRefreshSpy, inputRefreshes, "the re-broadcast does not refresh Inputs")
  assert_eq(#proclaimSpy, 0, "the re-broadcast does not Proclaim")

  local beforeWire = countType("STATE")
  Net:HandleHello({ version = 2, fields = { "0.1.0" } }, "Steakina")
  assert_eq(countType("STATE"), beforeWire + 1,
    "an inbound HELLO off the wire fires the same re-broadcast")

  assert_true(Runtime:EndEvent() ~= nil, "EndEvent back to QUIET")
  local beforeQuiet = countType("STATE")
  COB._OnPeerHello("Steakina")
  assert_eq(countType("STATE"), beforeQuiet, "back in QUIET the callback no-ops")
  Sender.IsRegisteredPope = origPope
end

do
  reset()
  assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false,
    "local player is not a registered Pope")
  assert_true(Runtime:StartEvent() ~= nil, "congregation StartEvent for the no-op pin")
  local beforeCong = countType("STATE")
  COB._OnPeerHello("Steakina")
  assert_eq(countType("STATE"), beforeCong, "a congregation client never re-broadcasts")
end

do
  reset()
  stubPope()
  local savedRuntime = COB.Runtime
  COB.Runtime = nil
  COB._OnPeerHello("Steakina")
  assert_eq(countType("STATE"), 0, "missing Runtime is swallowed")
  COB.Runtime = savedRuntime

  assert_true(Runtime:StartEvent() ~= nil, "StartEvent before the missing-Net pin")
  local savedNet = COB.Net
  COB.Net = nil
  COB._OnPeerHello("Steakina")
  COB.Net = savedNet
  assert_eq(countType("STATE"), 1, "missing Net is swallowed without a send")
  Sender.IsRegisteredPope = origPope
end

--------------------------------------------------------------------------------
-- Task 10: login restore + Pope rebroadcast + gated RequestSnapshot.
-- Nested `do` — no new main-chunk local. Init order stays Welcome after
-- DecreeBanner; pew Quiet drop is before the first UI Init spy.
--------------------------------------------------------------------------------
do
  local function spyRequestSnapshot()
    local asks = { n = 0 }
    local orig = Net.RequestSnapshot
    Net.RequestSnapshot = function(self, ...)
      asks.n = asks.n + 1
      return orig(self, ...)
    end
    asks.restore = function()
      Net.RequestSnapshot = orig
    end
    return asks
  end

  local function stubNetAndWire()
    local savedNetInit = COB.Net.Init
    local savedInstall = COB.InstallWire
    COB.Net.Init = function() return true end
    COB.InstallWire = function() return true end
    return function()
      COB.Net.Init = savedNetInit
      COB.InstallWire = savedInstall
    end
  end

  -- Congregation OnLogin after a restored live event → QUIET before UI Init.
  reset()
  assert_eq(Sender:IsRegisteredPope(UnitName("player")), false,
    "OnLogin pew pin starts unlisted")
  assert_true(Runtime:StartEvent() ~= nil, "pew StartEvent before OnLogin")
  assert_true(Runtime:OpenRite("Gora") ~= nil, "pew OpenRite before OnLogin")
  local pewLive = Runtime:Snapshot()
  assert_eq(pewLive.state, "RITE", "pew runtime is RITE before OnLogin")
  assert_true(type(pewLive.eventId) == "number", "pew live event has an id")

  local pewOrder = {}
  local pewStates = {}
  local function pewInitSpy(name)
    return function()
      pewOrder[#pewOrder + 1] = name
      local snap = Runtime:Snapshot()
      pewStates[#pewStates + 1] = snap and snap.state or nil
      return true
    end
  end
  local savedMinimap = COB.Minimap
  local savedRecordsBook = COB.RecordsBook
  local savedPlayerCard = COB.PlayerCard
  local savedHud = COB.Hud
  local savedConsole = COB.Console
  local savedToasts = COB.Toasts
  local savedDecreeBanner = COB.DecreeBanner
  local savedWelcome = COB.Welcome
  local savedSound = COB.Sound
  local savedFighterCard = COB.FighterCard
  local savedInputs = COB.Inputs
  local savedMarkers = COB.Markers
  COB.Minimap = { Init = pewInitSpy("Minimap") }
  COB.RecordsBook = { Init = pewInitSpy("RecordsBook") }
  COB.PlayerCard = { Init = pewInitSpy("PlayerCard") }
  COB.Hud = { Init = pewInitSpy("Hud") }
  COB.Console = { Init = pewInitSpy("Console") }
  COB.Toasts = { Init = pewInitSpy("Toasts") }
  COB.DecreeBanner = { Init = pewInitSpy("DecreeBanner") }
  COB.Welcome = { Init = pewInitSpy("Welcome") }
  COB.Sound = { Init = pewInitSpy("Sound") }
  COB.FighterCard = { Init = pewInitSpy("FighterCard") }
  COB.Inputs = { Init = pewInitSpy("Inputs") }
  COB.Markers = { Init = pewInitSpy("Markers") }
  local restorePewLogin = stubNetAndWire()
  local pewAsks = spyRequestSnapshot()
  local savedPewPopes = COB.Popes
  COB.Popes = { List = { "Thedave" } }
  COB:OnLogin()
  assert_eq(table.concat(pewOrder, ","),
    "Minimap,RecordsBook,PlayerCard,Hud,Console,Toasts,DecreeBanner,Welcome,Sound,FighterCard,Inputs,Markers",
    "congregation OnLogin keeps Welcome after DecreeBanner")
  assert_eq(pewStates[1], "QUIET",
    "congregation OnLogin is QUIET before the first UI Init")
  assert_eq(pewStates[7], "QUIET", "DecreeBanner Init is still QUIET")
  assert_eq(pewStates[8], "QUIET", "Welcome Init is still QUIET")
  local pewAfter = Runtime:Snapshot()
  assert_eq(pewAfter.state, "QUIET", "congregation OnLogin Restores Quiet")
  assert_eq(pewAfter.eventId, nil, "pew Quiet drop is a nil-eventId Quiet object")
  assert_eq(pewAfter.sequence, 0, "pew Quiet drop uses newEvent sequence 0")
  assert_eq(pewAsks.n, 0, "cold Tuesday OnLogin does not RequestSnapshot")
  pewAsks.restore()
  COB.Popes = savedPewPopes
  restorePewLogin()
  COB.Minimap = savedMinimap
  COB.RecordsBook = savedRecordsBook
  COB.PlayerCard = savedPlayerCard
  COB.Hud = savedHud
  COB.Console = savedConsole
  COB.Toasts = savedToasts
  COB.DecreeBanner = savedDecreeBanner
  COB.Welcome = savedWelcome
  COB.Sound = savedSound
  COB.FighterCard = savedFighterCard
  COB.Inputs = savedInputs
  COB.Markers = savedMarkers

  -- Listed Pope OnLogin keeps the restored event and sendState once.
  reset()
  stubPope()
  assert_true(Runtime:StartEvent() ~= nil, "Pope StartEvent before OnLogin")
  assert_true(Runtime:OpenRite("Gora") ~= nil, "Pope OpenRite before OnLogin")
  local popeLive = Runtime:Snapshot()
  assert_eq(popeLive.state, "RITE", "Pope runtime is RITE before OnLogin")
  local popeOrder = {}
  local popeStates = {}
  local function popeInitSpy(name)
    return function()
      popeOrder[#popeOrder + 1] = name
      local snap = Runtime:Snapshot()
      popeStates[#popeStates + 1] = snap and snap.state or nil
      return true
    end
  end
  savedMinimap = COB.Minimap
  savedRecordsBook = COB.RecordsBook
  savedPlayerCard = COB.PlayerCard
  savedHud = COB.Hud
  savedConsole = COB.Console
  savedToasts = COB.Toasts
  savedDecreeBanner = COB.DecreeBanner
  savedWelcome = COB.Welcome
  savedSound = COB.Sound
  savedFighterCard = COB.FighterCard
  savedInputs = COB.Inputs
  savedMarkers = COB.Markers
  COB.Minimap = { Init = popeInitSpy("Minimap") }
  COB.RecordsBook = { Init = popeInitSpy("RecordsBook") }
  COB.PlayerCard = { Init = popeInitSpy("PlayerCard") }
  COB.Hud = { Init = popeInitSpy("Hud") }
  COB.Console = { Init = popeInitSpy("Console") }
  COB.Toasts = { Init = popeInitSpy("Toasts") }
  COB.DecreeBanner = { Init = popeInitSpy("DecreeBanner") }
  COB.Welcome = { Init = popeInitSpy("Welcome") }
  COB.Sound = { Init = popeInitSpy("Sound") }
  COB.FighterCard = { Init = popeInitSpy("FighterCard") }
  COB.Inputs = { Init = popeInitSpy("Inputs") }
  COB.Markers = { Init = popeInitSpy("Markers") }
  local restorePopeLogin = stubNetAndWire()
  armTransmit()
  COB:OnLogin()
  assert_eq(popeStates[1], "RITE", "listed Pope OnLogin keeps RITE before UI Init")
  assert_eq(Runtime:Snapshot().state, "RITE", "listed Pope OnLogin keeps the restored event")
  assert_eq(Runtime:Snapshot().eventId, popeLive.eventId, "Pope OnLogin keeps the event id")
  assert_eq(countType("STATE"), 1, "listed Pope OnLogin sendState once when not QUIET")
  local loginState = lastOfType("STATE")
  assert_true(loginState ~= nil, "Pope login rebroadcast decodes")
  assert_eq(loginState.state, "RITE", "Pope login rebroadcast carries the restored state")
  restorePopeLogin()
  COB.Minimap = savedMinimap
  COB.RecordsBook = savedRecordsBook
  COB.PlayerCard = savedPlayerCard
  COB.Hud = savedHud
  COB.Console = savedConsole
  COB.Toasts = savedToasts
  COB.DecreeBanner = savedDecreeBanner
  COB.Welcome = savedWelcome
  COB.Sound = savedSound
  COB.FighterCard = savedFighterCard
  COB.Inputs = savedInputs
  COB.Markers = savedMarkers
  Sender.IsRegisteredPope = origPope

  -- QUIET Pope OnLogin does not self-send.
  reset()
  stubPope()
  local restoreQuietPope = stubNetAndWire()
  armTransmit()
  COB:OnLogin()
  assert_eq(countType("STATE"), 0, "QUIET Pope OnLogin does not sendState")
  restoreQuietPope()
  Sender.IsRegisteredPope = origPope

  -- RequestSnapshot: Pope HELLO while local QUIET, once. Not on pew HELLO.
  reset()
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "steakina"
  end
  local helloAsks = spyRequestSnapshot()
  assert_eq(Runtime:Snapshot().state, "QUIET", "snapshot HELLO pin starts QUIET")
  COB._OnPeerHello("Chuckroast")
  assert_eq(helloAsks.n, 0, "a pew HELLO does not RequestSnapshot")
  COB._OnPeerHello("Steakina")
  assert_eq(helloAsks.n, 1, "accepted Pope HELLO while QUIET RequestSnapshots once")
  COB._OnPeerHello("Steakina")
  assert_eq(helloAsks.n, 1, "a second Pope HELLO does not RequestSnapshot again")
  Net:HandleHello({ version = 2, fields = { "0.1.0" } }, "Steakina")
  assert_eq(helloAsks.n, 1, "inbound Pope HELLO after the ask does not fire twice")
  helloAsks.restore()
  Sender.IsRegisteredPope = origPope

  -- Live STATE that Restores Event Mode does not also ask (local no longer QUIET).
  reset()
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "steakina"
  end
  local savedAccept = Sender.Accept
  Sender.Accept = function() return true end
  local stateAsks = spyRequestSnapshot()
  local liveInbound, liveErr = Codec:EncodeState({
    eventId = 1,
    state = "RITE",
    riteType = "Gora",
    sequence = 1,
  })
  assert_true(liveInbound ~= nil, "live STATE for the snapshot pin encodes")
  assert_eq(liveErr, nil, "live STATE encode has no error")
  local liveDecoded = Codec:DecodeState(liveInbound)
  assert_true(Net:_HandleState(liveDecoded, "GUILD", "Steakina"),
    "accepted live STATE Restores")
  assert_eq(Runtime:Snapshot().state, "RITE", "live STATE left Quiet")
  assert_eq(stateAsks.n, 0, "live STATE that Restores Event Mode does not RequestSnapshot")
  stateAsks.restore()
  Sender.Accept = savedAccept
  Sender.IsRegisteredPope = origPope

  -- Live STATE that leaves local QUIET (Restore no-op / already Quiet object)
  -- is still a session gate: ask once.
  reset()
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "steakina"
  end
  savedAccept = Sender.Accept
  Sender.Accept = function() return true end
  local savedRestore = Runtime.Restore
  Runtime.Restore = function()
    return true
  end
  local quietLiveAsks = spyRequestSnapshot()
  assert_eq(Runtime:Snapshot().state, "QUIET", "Restore-stub pin starts QUIET")
  local keptInbound = Codec:EncodeState({
    eventId = 1,
    state = "ASSEMBLY",
    sequence = 1,
  })
  local keptDecoded = Codec:DecodeState(keptInbound)
  assert_true(Net:_HandleState(keptDecoded, "GUILD", "Steakina"),
    "accepted live STATE with a Restore no-op is ok")
  assert_eq(Runtime:Snapshot().state, "QUIET", "Restore stub left local QUIET")
  assert_eq(quietLiveAsks.n, 1, "accepted live STATE while still QUIET RequestSnapshots once")
  local keptDecoded2 = Codec:DecodeState(keptInbound)
  assert_true(Net:_HandleState(keptDecoded2, "GUILD", "Steakina"),
    "second accepted live STATE while QUIET is ok")
  assert_eq(quietLiveAsks.n, 1, "live STATE snapshot ask is once per login")
  quietLiveAsks.restore()
  Runtime.Restore = savedRestore
  Sender.Accept = savedAccept
  Sender.IsRegisteredPope = origPope

  -- Event Mode + Pope HELLO does not ask.
  reset()
  Sender.IsRegisteredPope = function(_, sender)
    return COB.Names.Key(sender) == "steakina"
  end
  assert_true(Runtime:StartEvent() ~= nil, "StartEvent so local is not QUIET")
  local liveHelloAsks = spyRequestSnapshot()
  COB._OnPeerHello("Steakina")
  assert_eq(liveHelloAsks.n, 0, "Pope HELLO while not QUIET does not RequestSnapshot")
  liveHelloAsks.restore()
  Sender.IsRegisteredPope = origPope
end

--------------------------------------------------------------------------------
-- Unstubbed Pope: StartEvent does not send.
--------------------------------------------------------------------------------
reset()
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "local player is not a registered Pope")
local started, startErr = Runtime:StartEvent()
assert_true(started ~= nil, "StartEvent still succeeds in Core")
assert_eq(startErr, nil, "StartEvent has no Core error")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "StartEvent entered ASSEMBLY")
assert_eq(#wire, 0, "unstubbed StartEvent does not send")
assert_eq(countType("STATE"), 0, "unstubbed StartEvent does not enqueue STATE")

--------------------------------------------------------------------------------
-- Stubbed Pope: StartEvent / EndEvent send STATE. Second InstallWire does not
-- double-wrap.
--------------------------------------------------------------------------------
reset()
stubPope()
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), true, "stub lists Beefina")
COB:InstallWire()
started = Runtime:StartEvent()
assert_true(started ~= nil, "stubbed StartEvent succeeds")
assert_eq(#wire, 1, "stubbed StartEvent sends once")
local stateMsg = decodeLast()
assert_true(stateMsg ~= nil, "StartEvent payload decodes")
assert_eq(stateMsg.type, "STATE", "StartEvent sends STATE")
assert_eq(stateMsg.state, "ASSEMBLY", "StartEvent STATE is ASSEMBLY")
assert_eq(stateMsg.eventId, started.eventId, "StartEvent STATE carries event id")
assert_eq(stateMsg.sequence, started.sequence, "StartEvent STATE carries sequence")
assert_eq(stateMsg.favor, nil, "StartEvent STATE omits favor without a pair")
assert_eq(wire[1].channel, "GUILD", "STATE travels on GUILD")
assert_eq(#inputRefreshSpy, 1, "StartEvent refreshes Inputs")
assert_eq(#cardHideSpy, 0, "StartEvent does not Hide the fighter card")

local ended = Runtime:EndEvent()
assert_true(ended ~= nil, "EndEvent succeeds from ASSEMBLY")
assert_eq(#wire, 2, "EndEvent sends a second STATE")
stateMsg = decodeLast()
assert_eq(stateMsg.type, "STATE", "EndEvent sends STATE")
assert_eq(stateMsg.state, "QUIET", "EndEvent STATE is QUIET")
assert_eq(#inputRefreshSpy, 2, "EndEvent refreshes Inputs")
assert_eq(#cardHideSpy, 1, "EndEvent Hides the fighter card")

--------------------------------------------------------------------------------
-- PostDecree sends DECREE. InspectProgress does not. Lane T: the Decree:Set
-- wrap shows the banner on a real post (wrapAfter fires on the non-nil copy).
--------------------------------------------------------------------------------
reset()
stubPope()
local bannerShows = 0
COB.DecreeBanner = {
  Show = function()
    bannerShows = bannerShows + 1
    return true
  end,
}
local posted = Console:PostDecree({
  line = "Goldshire Inn — Sunday, 7:00 PM",
  flavor = "The Gathering.",
})
assert_true(posted ~= nil, "PostDecree Sets Core")
assert_eq(posted.line, "Goldshire Inn — Sunday, 7:00 PM", "PostDecree returns line")
assert_eq(countType("DECREE"), 1, "PostDecree sends DECREE")
local decreeMsg = lastOfType("DECREE")
assert_true(decreeMsg ~= nil, "DECREE decodes")
assert_eq(decreeMsg.line, "Goldshire Inn — Sunday, 7:00 PM", "DECREE carries line")
assert_eq(decreeMsg.flavor, "The Gathering.", "DECREE carries flavor")
assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "PostDecree wrote Core")
assert_eq(bannerShows, 0, "PostDecree does not auto-show a login parchment")

--------------------------------------------------------------------------------
-- Lane T: inbound DECREE (Pope sender) lands in Decree:Set, so the banner
-- shows too. Login restore goes through Decree:Restore — never Set — so a
-- stored Decree does not re-show the banner outside the once-per-login reveal.
--------------------------------------------------------------------------------
do
  reset()
  stubPope()
  local inboundShows = 0
  COB.DecreeBanner = {
    Show = function()
      inboundShows = inboundShows + 1
      return true
    end,
  }
  local accepted, acceptErr = Net:_HandleDecree(
    { line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." },
    "GUILD",
    "Beefina"
  )
  assert_true(accepted, "inbound DECREE from the registered Pope is accepted")
  assert_eq(acceptErr, nil, "inbound DECREE has no error")
  assert_eq(Decree:Get().line, "Goldshire Inn — Sunday, 7:00 PM", "inbound DECREE wrote Core")
  assert_eq(inboundShows, 0, "inbound DECREE does not auto-show a login parchment")

  assert_true(Decree:Restore({ line = "Goldshire Inn — Sunday, 7:00 PM" }) ~= nil,
    "Decree Restore succeeds")
  assert_eq(inboundShows, 0, "login restore does not show the banner")
  Sender.IsRegisteredPope = origPope
end

--------------------------------------------------------------------------------
-- B28-INT: Decree:Clear always Refreshs the banner. Clear returns nil, so
-- wrapAfter would skip. Does not send DECREE.
--------------------------------------------------------------------------------
do
  reset()
  stubPope()
  assert_true(Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM" }) ~= nil,
    "Set a Decree so Clear has something to wipe")
  local bannerRefresh = 0
  COB.DecreeBanner = {
    Refresh = function()
      bannerRefresh = bannerRefresh + 1
      return false
    end,
  }
  Decree:Clear()
  assert_eq(Decree:Get(), nil, "Clear empties Core")
  assert_eq(bannerRefresh, 1, "Clear Refreshs the banner")
  assert_eq(countType("DECREE"), 0, "Clear does not send DECREE")
  assert_eq(countType("STATE"), 0, "Clear does not send STATE")
end

--------------------------------------------------------------------------------
-- B31-INT: Runtime:EndEvent Refreshs the desk so a leftover Recommend line
-- dies in QUIET. StartEvent / Continue glue still skip Console:Refresh.
--------------------------------------------------------------------------------
do
  reset()
  stubPope()
  local hits = 0
  local origRefresh = Console.Refresh
  Console.Refresh = function(self, ...)
    hits = hits + 1
    return origRefresh(self, ...)
  end
  Runtime:StartEvent()
  local afterStart = hits
  Runtime:EndEvent()
  local afterEnd = hits
  Console.Refresh = origRefresh
  assert_eq(afterStart, 0, "StartEvent glue does not Refresh Console")
  assert_true(afterEnd >= 1, "EndEvent glue Refreshs Console")
end

--------------------------------------------------------------------------------
-- B32-INT: runtime wraps Refresh Hud so Knighting hide forgets lastPair.
-- Inspect / skipSend still skip Hud.
--------------------------------------------------------------------------------
do
  reset()
  stubPope()
  local hits = 0
  local origHudRefresh = Hud.Refresh
  Hud.Refresh = function(self, ...)
    hits = hits + 1
    return origHudRefresh(self, ...)
  end
  Runtime:StartEvent()
  local afterStart = hits
  local a, b = twoChars()
  Runtime:OpenRite("Gora", { fighters = { a.id, b.id } })
  local afterOpen = hits
  hits = 0
  COB._inspecting = true
  Runtime:EndEvent()
  local afterInspect = hits
  COB._inspecting = false
  Hud.Refresh = origHudRefresh
  assert_true(afterStart >= 1, "StartEvent glue Refreshs Hud")
  assert_true(afterOpen > afterStart, "OpenRite glue Refreshs Hud")
  assert_eq(afterInspect, 0, "inspecting EndEvent skips Hud Refresh")
end

--------------------------------------------------------------------------------
-- B38-INT: Runtime:EndEvent Forgets leftover raid marks. Clear refuses
-- Quiet; Forget is the Quiet leftover sweep. Inspect / skipSend skip.
-- StartEvent / OpenRite do not Forget. Missing Forget is a no-op.
-- Nested `do` — no new main-chunk local.
--------------------------------------------------------------------------------
do
  reset()
  stubPope()
  local hits = 0
  COB.Markers.Forget = function()
    hits = hits + 1
    return true
  end
  Runtime:StartEvent()
  local afterStart = hits
  local a, b = twoChars()
  Runtime:OpenRite("Gora", { fighters = { a.id, b.id } })
  local afterOpen = hits
  Runtime:CloseRite()
  local afterClose = hits
  Runtime:EndEvent()
  local afterEnd = hits
  hits = 0
  Runtime:StartEvent()
  local afterRestart = hits
  COB._inspecting = true
  Runtime:EndEvent()
  local afterInspect = hits
  COB._inspecting = false
  assert_eq(afterStart, 0, "StartEvent glue does not Forget marks")
  assert_eq(afterOpen, 0, "OpenRite glue does not Forget marks")
  assert_eq(afterClose, 0, "CloseRite glue does not Forget marks")
  assert_true(afterEnd >= 1, "EndEvent glue Forgets leftover marks")
  assert_eq(afterRestart, 0, "second StartEvent does not Forget")
  assert_eq(afterInspect, 0, "inspecting EndEvent skips Markers Forget")

  reset()
  stubPope()
  COB.Markers.Forget = nil
  Runtime:StartEvent()
  local muteOk, muteErr = Runtime:EndEvent()
  assert_true(muteOk ~= nil, "missing Forget does not break EndEvent")
  assert_eq(muteErr, nil, "missing Forget is a no-op")

  reset()
  stubPope()
  COB.Markers = nil
  Runtime:StartEvent()
  local unmarkedOk, unmarkedErr = Runtime:EndEvent()
  assert_true(unmarkedOk ~= nil, "missing Markers does not break EndEvent")
  assert_eq(unmarkedErr, nil, "missing Markers Forget is a no-op")
end

--------------------------------------------------------------------------------
-- B39-INT: live STATE last-pair overlay is Gora-only (matches B38-B
-- SNAPSHOT). Knighting RITE / CONSEQUENCE after a finished Gora does
-- not overlay leftover last fighters. Nested `do` — no new main-chunk local.
--------------------------------------------------------------------------------
do
  reset()
  stubPope()
  Runtime:StartEvent()
  local lastA, lastB = twoChars()
  assert_true(Gora:Sanction(lastA.id, lastB.id) ~= nil, "B39-INT Sanction last pair")
  assert_true(Runtime:OpenRite("Gora", { fighters = { lastA.id, lastB.id } }) ~= nil,
    "B39-INT OpenRite Gora")
  assert_true(Gora:DeclareVictor(lastA.id) ~= nil, "B39-INT DeclareVictor")
  assert_true(Runtime:CloseRite() ~= nil, "B39-INT CloseRite Gora")
  local goraClose = lastOfType("STATE")
  assert_eq(goraClose.state, "CONSEQUENCE", "Gora CloseRite is CONSEQUENCE")
  assert_eq(goraClose.riteType, "Gora", "Gora CloseRite rite type")
  assert_eq(goraClose.subjects.fighters[1], lastA.id, "Gora CONSEQUENCE still names last A")
  assert_eq(goraClose.subjects.fighters[2], lastB.id, "Gora CONSEQUENCE still names last B")
  assert_true(Runtime:Continue() ~= nil, "B39-INT Continue")
  local afterContinue = lastOfType("STATE")
  assert_eq(#afterContinue.subjects.fighters, 0, "post-Continue ASSEMBLY still no last pair")
  local knightHuman = Store:CreateHuman({ name = "Sirloin" })
  assert_true(Runtime:OpenRite("Knighting", { candidate = knightHuman.id }) ~= nil,
    "B39-INT OpenRite Knighting")
  local knightRite = lastOfType("STATE")
  assert_eq(knightRite.riteType, "Knighting", "Knighting STATE rite type")
  assert_eq(#(knightRite.subjects.fighters or {}), 0,
    "Knighting RITE does not overlay last Gora pair")
  assert_true(Runtime:CloseRite() ~= nil, "B39-INT CloseRite Knighting")
  local knightClose = lastOfType("STATE")
  assert_eq(knightClose.state, "CONSEQUENCE", "Knighting CloseRite is CONSEQUENCE")
  assert_eq(knightClose.riteType, "Knighting", "Knighting CloseRite rite type")
  assert_eq(#(knightClose.subjects.fighters or {}), 0,
    "Knighting CONSEQUENCE STATE does not overlay last Gora pair")
  assert_eq(knightClose.favor, nil, "Knighting CONSEQUENCE does not invent last favor")
end

reset()
stubPope()
COB:InspectProgress()
assert_eq(countType("DECREE"), 0, "InspectProgress does not send DECREE")
assert_eq(countType("STATE"), 0, "InspectProgress does not send STATE")
assert_eq(#inputRefreshSpy, 0, "InspectProgress does not Refresh Inputs")
assert_eq(#cardHideSpy, 0, "InspectProgress does not Hide the fighter card")
assert_eq(COB._inspecting, false, "InspectProgress clears the inspect flag")

--------------------------------------------------------------------------------
-- RecordFavor: toggle on + sanctioned pair includes favor; toggle off omits it.
--------------------------------------------------------------------------------
reset()
stubPope()
Runtime:StartEvent()
local fighterA, fighterB = twoChars()
assert_true(Runtime:OpenRite("Gora", { fighters = { fighterA.id, fighterB.id } }) ~= nil,
  "OpenRite names the pair so STATE can carry fighters")
local pair = Gora:Sanction(fighterA.id, fighterB.id)
assert_true(pair ~= nil, "Sanction sets a live pair")
assert_eq(Console:GetCongregationFavorVisible(), true, "congregation favor defaults on")
assert_eq(Gora:RecordFavor(fighterA.id, fighterA.id), true, "RecordFavor stands a pick")
stateMsg = lastOfType("STATE")
assert_true(stateMsg ~= nil, "RecordFavor sends STATE")
assert_true(stateMsg.favor ~= nil, "toggle-on STATE includes favor")
assert_eq(stateMsg.favor.a, 1, "favor counts A")
assert_eq(stateMsg.favor.b, 0, "favor counts B")

assert_eq(Console:SetCongregationFavorVisible(false), true, "toggle accepts false")
stateMsg = lastOfType("STATE")
assert_true(stateMsg ~= nil, "toggle-off sends STATE")
assert_eq(stateMsg.favor, nil, "toggle-off STATE omits favor")

assert_eq(Gora:RecordFavor(fighterB.id, fighterB.id), true, "second pick stands")
stateMsg = lastOfType("STATE")
assert_eq(stateMsg.favor, nil, "RecordFavor with toggle off omits favor")

assert_eq(Console:SetCongregationFavorVisible(true), true, "toggle accepts true")
local hudBeforeFavor = #hudRefreshSpy
assert_eq(Gora:RecordFavorFromSender("Zipfresh", fighterA.id), true,
  "RecordFavorFromSender stands a pick")
stateMsg = lastOfType("STATE")
assert_true(stateMsg ~= nil, "RecordFavorFromSender sends STATE")
assert_true(stateMsg.favor ~= nil, "inbound-style favor is on STATE")
assert_true(#hudRefreshSpy > hudBeforeFavor, "RecordFavorFromSender refreshes the HUD")

--------------------------------------------------------------------------------
-- Inbound STATE with favor (stub Accept) paints the HUD broadcast.
--------------------------------------------------------------------------------
reset()
local savedAccept = Sender.Accept
Sender.Accept = function() return true end
local inbound, inboundErr = Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  riteType = "Gora",
  subjects = { fighters = { 1, 2 } },
  sequence = 1,
  favor = { a = 3, b = 1 },
})
assert_true(inbound ~= nil, "inbound STATE encodes")
assert_eq(inboundErr, nil, "inbound STATE encode has no error")
local decoded = Codec:DecodeState(inbound)
local ok = Net:_HandleState(decoded, "GUILD", "Steakina")
assert_true(ok, "accepted STATE Restores")
assert_eq(#favorSpy, 1, "accepted STATE calls SetBroadcastFavor once")
assert_eq(favorSpy[1].a, 3, "broadcast favor a")
assert_eq(favorSpy[1].b, 1, "broadcast favor b")
assert_eq(targetSpy[1], "Steakina", "accepted STATE sets favor target")
assert_eq(inputTargetBindSpy[1], "Steakina", "accepted STATE sets Inputs whisper target")
assert_eq(#inputRefreshSpy, 1, "accepted STATE refreshes Inputs")
assert_eq(#cardShowSpy, 1, "accepted STATE with fighters Shows the fighter card")
assert_eq(#cardRefreshSpy, 1, "accepted STATE with fighters Refreshes the fighter card")
Sender.Accept = savedAccept

--------------------------------------------------------------------------------
-- Inbound STATE while inspecting hides Inputs and skips Refresh.
--------------------------------------------------------------------------------
reset()
savedAccept = Sender.Accept
Sender.Accept = function() return true end
inbound, inboundErr = Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  riteType = "Gora",
  subjects = { fighters = { 1, 2 } },
  sequence = 1,
  favor = { a = 1, b = 0 },
})
assert_true(inbound ~= nil, "inspect inbound STATE encodes")
assert_eq(inboundErr, nil, "inspect inbound STATE encode has no error")
decoded = Codec:DecodeState(inbound)
COB._inspecting = true
ok = Net:_HandleState(decoded, "GUILD", "Steakina")
assert_true(ok, "inspecting accepted STATE still Restores")
assert_eq(#inputTargetBindSpy, 0, "inspecting STATE does not bind Inputs target")
assert_eq(#inputRefreshSpy, 0, "inspecting STATE does not Refresh Inputs")
assert_eq(#inputHideSpy, 1, "inspecting STATE Hides Inputs")
assert_eq(#cardShowSpy, 0, "inspecting STATE does not Show the fighter card")
COB._inspecting = false
Sender.Accept = savedAccept

--------------------------------------------------------------------------------
-- Lane T congregation side: inbound STATE CONSEQUENCE hides the sanction-beat
-- card (the ruling landed); QUIET still hides it. RITE with fighters shows.
--------------------------------------------------------------------------------
reset()
savedAccept = Sender.Accept
Sender.Accept = function() return true end
local riteInbound, riteInboundErr = Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  riteType = "Gora",
  subjects = { fighters = { 1, 2 } },
  sequence = 1,
})
assert_true(riteInbound ~= nil, "RITE STATE encodes")
assert_eq(riteInboundErr, nil, "RITE STATE encode has no error")
local riteDecoded = Codec:DecodeState(riteInbound)
assert_true(Net:_HandleState(riteDecoded, "GUILD", "Steakina"), "RITE STATE Restores")
assert_eq(#cardShowSpy, 1, "RITE with fighters Shows the fighter card")
assert_eq(#cardHideSpy, 0, "RITE with fighters does not Hide the fighter card")

local consequenceInbound, consequenceInboundErr = Codec:EncodeState({
  eventId = 1,
  state = "CONSEQUENCE",
  riteType = "Gora",
  subjects = { fighters = { 1, 2 } },
  sequence = 2,
})
assert_true(consequenceInbound ~= nil, "CONSEQUENCE STATE encodes")
assert_eq(consequenceInboundErr, nil, "CONSEQUENCE STATE encode has no error")
local consequenceDecoded = Codec:DecodeState(consequenceInbound)
assert_true(Net:_HandleState(consequenceDecoded, "GUILD", "Steakina"),
  "CONSEQUENCE STATE Restores")
assert_eq(#cardHideSpy, 1, "CONSEQUENCE STATE Hides the fighter card")
assert_eq(#cardShowSpy, 1, "CONSEQUENCE STATE does not re-Show the fighter card")

local leftoverInbound, leftoverErr = Codec:EncodeState({
  eventId = 1,
  state = "RITE",
  riteType = "Gora",
  subjects = { fighters = { 1, 2 } },
  sequence = 3,
})
assert_true(leftoverInbound ~= nil, "post-verdict RITE STATE encodes")
assert_eq(leftoverErr, nil, "post-verdict RITE encode has no error")
local leftoverDecoded = Codec:DecodeState(leftoverInbound)
assert_true(Net:_HandleState(leftoverDecoded, "GUILD", "Steakina"),
  "post-verdict RITE + lastPair Restores")
assert_eq(#cardShowSpy, 1, "post-verdict RITE + lastPair does not re-Show the fighter card")
assert_eq(#cardHideSpy, 1, "post-verdict RITE + lastPair does not Hide again")

local quietInbound, quietInboundErr = Codec:EncodeState({
  eventId = 1,
  state = "QUIET",
  sequence = 4,
})
assert_true(quietInbound ~= nil, "QUIET STATE encodes")
assert_eq(quietInboundErr, nil, "QUIET STATE encode has no error")
local quietDecoded = Codec:DecodeState(quietInbound)
assert_true(Net:_HandleState(quietDecoded, "GUILD", "Steakina"), "QUIET STATE Restores")
assert_eq(#cardHideSpy, 2, "QUIET STATE still Hides the fighter card")
assert_eq(#cardShowSpy, 1, "QUIET STATE does not re-Show the fighter card")
Sender.Accept = savedAccept

--------------------------------------------------------------------------------
-- Inbound stash: names stay off Runtime. No Store upsert.
--------------------------------------------------------------------------------
reset()
savedAccept = Sender.Accept
Sender.Accept = function() return true end
local beforeHumans = #(Store:Snapshot().humans or {})
local beforeChars = #(Store:Snapshot().characters or {})
local stashInbound, stashErr = Codec:EncodeState({
  eventId = 1,
  state = "ASSEMBLY",
  subjects = { fighters = { 8, 9 } },
  sequence = 1,
  names = { fighterA = "Chuckroast", fighterB = "Beefina" },
})
assert_true(stashInbound ~= nil, "named ASSEMBLY STATE encodes")
assert_eq(stashErr, nil, "named ASSEMBLY encode has no error")
local stashDecoded = Codec:DecodeState(stashInbound)
assert_true(Net:_HandleState(stashDecoded, "GUILD", "Steakina"), "named ASSEMBLY Restores")
assert_eq(COB._lastCastNames.fighterA, "Chuckroast", "bootstrap stashes fighter A")
assert_eq(COB._lastCastNames.fighterB, "Beefina", "bootstrap stashes fighter B")
assert_eq(COB._lastCastNames.byId[8], "Chuckroast", "stash maps fighter A id")
assert_eq(COB._lastCastNames.byId[9], "Beefina", "stash maps fighter B id")
assert_eq(Runtime:Snapshot().names, nil, "Runtime:Restore stays Bible fields only")
assert_eq(Runtime:Snapshot().subjects.fighters[1], 8, "Restore still has fighter A id")
assert_eq(#(Store:Snapshot().humans or {}), beforeHumans, "inbound names do not CreateHuman")
assert_eq(#(Store:Snapshot().characters or {}), beforeChars, "inbound names do not upsert Store")
Sender.Accept = savedAccept

--------------------------------------------------------------------------------
-- Lane T fix wave (adjudicated defect): the Pope's own GUILD STATE echoes
-- back to his client, and the verdict STATE is RITE carrying the lastPair
-- overlay — the echo re-Showed the card one beat after the verdict wrap hid
-- it. The card branch of the _HandleState glue now skips self-echoes (the
-- Pope's one show source is the Sanction wrap); favor/inputs keep their
-- self-echo paint. A different registered Pope's identical STATE still shows.
--------------------------------------------------------------------------------
do
  reset()
  Sender.IsRegisteredPope = function(_, sender)
    local key = COB.Names.Key(sender)
    return key == "beefina" or key == "steakina"
  end
  local echoInbound, echoErr = Codec:EncodeState({
    eventId = 1,
    state = "RITE",
    riteType = "Gora",
    subjects = { fighters = { 1, 2 } },
    sequence = 1,
    favor = { a = 2, b = 1 },
  })
  assert_true(echoInbound ~= nil, "self-echo RITE STATE encodes")
  assert_eq(echoErr, nil, "self-echo RITE STATE encode has no error")
  local echoDecoded = Codec:DecodeState(echoInbound)
  assert_true(Net:_HandleState(echoDecoded, "GUILD", "Beefina"),
    "the Pope's own echoed STATE is accepted and Restores")
  assert_eq(#cardShowSpy, 0, "self-echo RITE with fighters does not Show the fighter card")
  assert_eq(#cardHideSpy, 0, "self-echo RITE with fighters does not Hide the fighter card")
  assert_eq(#favorSpy, 1, "self-echo STATE still paints inbound favor")
  assert_eq(targetSpy[1], "Beefina", "self-echo STATE still sets the favor target")
  assert_eq(#inputTargetBindSpy, 1, "self-echo STATE still binds the Inputs target")
  assert_eq(#inputRefreshSpy, 1, "self-echo STATE still refreshes Inputs")

  local otherDecoded = Codec:DecodeState(echoInbound)
  assert_true(Net:_HandleState(otherDecoded, "GUILD", "Steakina"),
    "the same STATE from another registered Pope Restores")
  assert_eq(#cardShowSpy, 1, "another registered Pope's RITE with fighters still Shows the card")
  assert_eq(#cardHideSpy, 0, "another registered Pope's RITE with fighters does not Hide the card")
  Sender.IsRegisteredPope = origPope
end

--------------------------------------------------------------------------------
-- Petition INPUT: GUILD stays unknown. WHISPER is live and Pope-gated.
--------------------------------------------------------------------------------
reset()
Sender.IsRegisteredPope = origPope
local petition = Codec:EncodeInput({ kind = "petition", characterId = 1 })
assert_true(petition ~= nil, "petition still encodes")
assert_eq(Sender:IsRegisteredPope(Net:PlayerName()), false, "local player is not a Pope for the petition pin")
local petOk, petErr = Net:OnAddonMessage(Net.Prefix, petition, "GUILD", "Steakina")
assert_eq(petOk, false, "petition INPUT is not accepted on GUILD")
assert_eq(petErr, "unknown message type", "GUILD petition stays unknown")
petOk, petErr = Net:OnAddonMessage(Net.Prefix, petition, "WHISPER", "Steakina")
assert_eq(petOk, false, "whispered petition is not accepted without a Pope")
assert_eq(petErr, "not a registered pope", "whispered petition names the Pope gate")

--------------------------------------------------------------------------------
-- Local picker id from Store after Restore. Matching UnitName via Names.Key.
--------------------------------------------------------------------------------
reset()
local me = Store:CreateCharacter({ name = "Beefina", class = "Paladin", level = 70 })
assert_true(me ~= nil, "local character is created")
local restored = Store:Restore(Store:Snapshot())
assert_true(restored, "Store Restore succeeds")
assert_true(#localIdSpy >= 1, "Restore sets local character id")
assert_eq(localIdSpy[#localIdSpy], me.id, "local id matches the Beefina row")
assert_true(#inputLocalSpy >= 1, "Restore sets Inputs local character id")
assert_eq(inputLocalSpy[#inputLocalSpy], me.id, "Inputs local id matches the Beefina row")

--------------------------------------------------------------------------------
-- Proclaim glue: successful Gora verbs. Names from Store. Inspect is silent.
-- Lane T: every verdict wrap also Hides the sanction-beat fighter card and
-- Refreshs the Pope's HUD (deterministic on the Pope client, not the echo).
--------------------------------------------------------------------------------
local cardHidesAt = 0
local hudRefreshesAt = 0
reset()
stubPope()
Runtime:StartEvent()
local proclaimA, proclaimB = twoChars()
local sanctioned = Gora:Sanction(proclaimA.id, proclaimB.id, "Come as you are")
assert_true(sanctioned ~= nil, "Sanction succeeds for Proclaim")
assert_eq(#proclaimSpy, 1, "Sanction Proclaims once")
assert_eq(proclaimSpy[1].kind, "sanction", "Sanction kind is sanction")
assert_eq(proclaimSpy[1].fields.fighterA, "Chuckroast", "Sanction names fighter A from Store")
assert_eq(proclaimSpy[1].fields.fighterB, "Tendermage", "Sanction names fighter B from Store")
assert_eq(proclaimSpy[1].fields.stipulation, nil, "Sanction does not proclaim a stipulation")
assert_eq(#cardShowSpy, 1, "Sanction Shows the fighter card once")
assert_eq(#cardRefreshSpy, 1, "Sanction Refreshes the fighter card once")
assert_eq(#markerFightersSpy, 1, "Sanction marks fighters once")
assert_eq(markerFightersSpy[1][1], "Chuckroast", "Sanction MarkFighters names A from Store")
assert_eq(markerFightersSpy[1][2], "Tendermage", "Sanction MarkFighters names B from Store")

cardHidesAt = #cardHideSpy
hudRefreshesAt = #hudRefreshSpy
local coward = Gora:CowardiceRecorded(proclaimA.id)
assert_true(coward ~= nil, "CowardiceRecorded succeeds")
assert_eq(#proclaimSpy, 2, "Cowardice Proclaims after Sanction")
assert_eq(proclaimSpy[2].kind, "cowardice", "Cowardice kind is clerical cowardice")
assert_eq(proclaimSpy[2].fields.name, "Chuckroast", "Cowardice names the fleer from Store")
assert_eq(#cardHideSpy, cardHidesAt + 1, "CowardiceRecorded Hides the fighter card")
assert_eq(#hudRefreshSpy, hudRefreshesAt + 1, "CowardiceRecorded Refreshs the Pope HUD")

reset()
stubPope()
Runtime:StartEvent()
local victorA, victorB = twoChars()
assert_true(Gora:Sanction(victorA.id, victorB.id) ~= nil, "victor pair is sanctioned")
proclaimSpy = {}
local stateBefore = #wire
local refreshAt = 0
local origConRefresh = Console.Refresh
Console.Refresh = function(self, ...)
  refreshAt = refreshAt + 1
  return origConRefresh(self, ...)
end
Gora:Propose({
  ruling = "victor",
  winnerId = victorB.id,
  loserId = victorA.id,
  source = "raid-health",
})
assert_eq(#proclaimSpy, 0, "Propose does not Proclaim")
assert_eq(#wire, stateBefore, "Propose does not send STATE")
assert_eq(Gora:GetProposal().winnerId, victorB.id, "wire leaves the draft in Gora")
assert_true(refreshAt > 0, "Propose refreshes the console")
assert_eq(Console:IsShown(), true, "Propose opens the Pope desk")
Console.Refresh = origConRefresh
cardHidesAt = #cardHideSpy
hudRefreshesAt = #hudRefreshSpy
local declared = Gora:DeclareVictor(victorA.id)
assert_true(declared ~= nil, "DeclareVictor succeeds")
assert_eq(#proclaimSpy, 1, "DeclareVictor Proclaims once")
assert_eq(proclaimSpy[1].kind, "verdict", "DeclareVictor kind is verdict")
assert_eq(proclaimSpy[1].fields.ruling, "victor", "DeclareVictor ruling is victor")
assert_eq(proclaimSpy[1].fields.name, "Chuckroast", "DeclareVictor names the winner from Store")
assert_eq(#cardHideSpy, cardHidesAt + 1, "DeclareVictor Hides the fighter card")
assert_eq(#hudRefreshSpy, hudRefreshesAt + 1, "DeclareVictor Refreshs the Pope HUD")

reset()
stubPope()
Runtime:StartEvent()
local voidA, voidB = twoChars()
assert_true(Gora:Sanction(voidA.id, voidB.id) ~= nil, "void pair is sanctioned")
proclaimSpy = {}
cardHidesAt = #cardHideSpy
hudRefreshesAt = #hudRefreshSpy
assert_true(Gora:Void() ~= nil, "Void succeeds")
assert_eq(#proclaimSpy, 1, "Void Proclaims once")
assert_eq(proclaimSpy[1].kind, "verdict", "Void kind is verdict")
assert_eq(proclaimSpy[1].fields.ruling, "void", "Void ruling is void")
assert_eq(#cardHideSpy, cardHidesAt + 1, "Void Hides the fighter card")
assert_eq(#hudRefreshSpy, hudRefreshesAt + 1, "Void Refreshs the Pope HUD")

reset()
stubPope()
Runtime:StartEvent()
local freeA, freeB = twoChars()
assert_true(Gora:Sanction(freeA.id, freeB.id) ~= nil, "free pair is sanctioned")
proclaimSpy = {}
cardHidesAt = #cardHideSpy
hudRefreshesAt = #hudRefreshSpy
local freed = Gora:FreeRuling("The ring is closed.")
assert_true(freed ~= nil, "FreeRuling succeeds")
assert_eq(#proclaimSpy, 1, "FreeRuling Proclaims once")
assert_eq(proclaimSpy[1].kind, "verdict", "FreeRuling kind is verdict")
assert_eq(proclaimSpy[1].fields.ruling, "free", "FreeRuling ruling is free")
assert_eq(proclaimSpy[1].fields.text, "The ring is closed.", "FreeRuling carries the result text")
assert_eq(#cardHideSpy, cardHidesAt + 1, "FreeRuling Hides the fighter card")
assert_eq(#hudRefreshSpy, hudRefreshesAt + 1, "FreeRuling Refreshs the Pope HUD")

--------------------------------------------------------------------------------
-- Lane T: the card is a sanction beat — CloseRite hides it too (EndEvent
-- already did). Inspecting stays silent for both.
--------------------------------------------------------------------------------
reset()
stubPope()
Runtime:StartEvent()
local closeA, closeB = twoChars()
assert_true(Gora:Sanction(closeA.id, closeB.id) ~= nil, "CloseRite pair is sanctioned")
assert_true(Runtime:OpenRite("Gora", { fighters = { closeA.id, closeB.id } }) ~= nil,
  "OpenRite for the CloseRite hide pin")
cardHidesAt = #cardHideSpy
assert_true(Runtime:CloseRite() ~= nil, "CloseRite succeeds")
assert_eq(#cardHideSpy, cardHidesAt + 1, "CloseRite Hides the fighter card")
cardHidesAt = #cardHideSpy
assert_true(Runtime:EndEvent() ~= nil, "EndEvent after CloseRite")
assert_eq(#cardHideSpy, cardHidesAt + 1, "EndEvent still Hides the fighter card")

reset()
stubPope()
Runtime:StartEvent()
local inspectCloseA, inspectCloseB = twoChars()
assert_true(Gora:Sanction(inspectCloseA.id, inspectCloseB.id) ~= nil,
  "inspecting Sanction still writes")
assert_true(Runtime:OpenRite("Gora", { fighters = { inspectCloseA.id, inspectCloseB.id } }) ~= nil,
  "inspecting OpenRite succeeds")
COB._inspecting = true
cardHidesAt = #cardHideSpy
assert_true(Runtime:CloseRite() ~= nil, "inspecting CloseRite succeeds")
assert_eq(#cardHideSpy, cardHidesAt, "inspecting CloseRite does not Hide the fighter card")
COB._inspecting = false

reset()
stubPope()
COB:InspectProgress()
assert_eq(#proclaimSpy, 0, "InspectProgress does not Proclaim")
assert_eq(COB._inspecting, false, "InspectProgress still clears the inspect flag")

reset()
stubPope()
Runtime:StartEvent()
local inspectA, inspectB = twoChars()
COB._inspecting = true
assert_true(Gora:Sanction(inspectA.id, inspectB.id) ~= nil, "Sanction still writes while inspecting")
assert_eq(#proclaimSpy, 0, "inspecting Sanction does not Proclaim")
assert_eq(#cardShowSpy, 0, "inspecting Sanction does not Show the fighter card")
assert_eq(#cardRefreshSpy, 0, "inspecting Sanction does not Refresh the fighter card")
assert_eq(#markerFightersSpy, 0, "inspecting Sanction does not MarkFighters")
COB._inspecting = false

reset()
stubPope()
assert_eq(Gora:Sanction(1, 2), nil, "Sanction without an event refuses")
assert_eq(#proclaimSpy, 0, "refused Sanction does not Proclaim")
assert_eq(#cardShowSpy, 0, "refused Sanction does not Show the fighter card")
assert_eq(#markerFightersSpy, 0, "refused Sanction does not MarkFighters")

reset()
stubPope()
COB.Toasts = nil
Runtime:StartEvent()
local quietA, quietB = twoChars()
local stillOk, stillErr = Gora:Sanction(quietA.id, quietB.id)
assert_true(stillOk ~= nil, "missing Toasts does not break Sanction")
assert_eq(stillErr, nil, "missing Toasts is a no-op")
assert_eq(#cardShowSpy, 1, "missing Toasts still Shows the fighter card")
assert_eq(#markerFightersSpy, 1, "missing Toasts still MarkFighters")

reset()
stubPope()
COB.FighterCard = nil
Runtime:StartEvent()
local muteA, muteB = twoChars()
local muteOk, muteErr = Gora:Sanction(muteA.id, muteB.id)
assert_true(muteOk ~= nil, "missing FighterCard does not break Sanction")
assert_eq(muteErr, nil, "missing FighterCard is a no-op")
assert_eq(#proclaimSpy, 1, "missing FighterCard still Proclaims sanction")
assert_eq(#markerFightersSpy, 1, "missing FighterCard still MarkFighters")

reset()
stubPope()
COB.Markers = nil
Runtime:StartEvent()
local unmarkedA, unmarkedB = twoChars()
local unmarkedOk, unmarkedErr = Gora:Sanction(unmarkedA.id, unmarkedB.id)
assert_true(unmarkedOk ~= nil, "missing Markers does not break Sanction")
assert_eq(unmarkedErr, nil, "missing Markers is a no-op")
assert_eq(#proclaimSpy, 1, "missing Markers still Proclaims sanction")

--------------------------------------------------------------------------------
-- Knighting / elevation Proclaim. Human name from Store:GetHuman. Inspect silent.
--------------------------------------------------------------------------------
reset()
stubPope()
local knightHuman = Store:CreateHuman({ name = "Sirloin" })
assert_true(knightHuman ~= nil, "knight human is created")
local knighted = Knighting:KnightThisBeef(knightHuman.id)
assert_true(knighted ~= nil, "KnightThisBeef succeeds")
assert_eq(#proclaimSpy, 1, "KnightThisBeef Proclaims once")
assert_eq(proclaimSpy[1].kind, "knighting", "KnightThisBeef kind is knighting")
assert_eq(proclaimSpy[1].fields.name, "Sirloin", "KnightThisBeef names the human from Store:GetHuman")
assert_eq(Store:GetHuman(knightHuman.id).name, "Sirloin", "GetHuman still returns Sirloin")
assert_eq(#markerTargetSpy, 0, "KnightThisBeef does not TargetUnit")
assert_eq(#markerCandidateSpy, 1, "KnightThisBeef marks the candidate once")
assert_eq(markerCandidateSpy[1], "Sirloin", "MarkCandidate uses Store human name")

reset()
stubPope()
local lordHuman = Store:CreateHuman({ name = "Sirloin" })
local elevated = Knighting:ElevateToLord(lordHuman.id)
assert_true(elevated ~= nil, "ElevateToLord succeeds")
assert_eq(#proclaimSpy, 1, "ElevateToLord Proclaims once")
assert_eq(proclaimSpy[1].kind, "elevation", "ElevateToLord kind is elevation")
assert_eq(proclaimSpy[1].fields.name, "Sirloin", "ElevateToLord names the human from Store:GetHuman")
assert_eq(#markerTargetSpy, 0, "ElevateToLord does not Target")
assert_eq(#markerCandidateSpy, 0, "ElevateToLord does not MarkCandidate")

reset()
stubPope()
COB._inspecting = true
local inspectHuman = Store:CreateHuman({ name = "Sirloin" })
assert_true(Knighting:KnightThisBeef(inspectHuman.id) ~= nil, "KnightThisBeef still writes while inspecting")
assert_eq(#proclaimSpy, 0, "inspecting KnightThisBeef does not Proclaim")
assert_eq(#markerTargetSpy, 0, "inspecting KnightThisBeef does not Target")
assert_eq(#markerCandidateSpy, 0, "inspecting KnightThisBeef does not MarkCandidate")
assert_true(Knighting:ElevateToLord(inspectHuman.id) ~= nil, "ElevateToLord still writes while inspecting")
assert_eq(#proclaimSpy, 0, "inspecting ElevateToLord does not Proclaim")
COB._inspecting = false

reset()
stubPope()
assert_eq(Knighting:KnightThisBeef(999), nil, "KnightThisBeef without a human refuses")
assert_eq(#proclaimSpy, 0, "refused KnightThisBeef does not Proclaim")
assert_eq(#markerTargetSpy, 0, "refused KnightThisBeef does not Target")
assert_eq(#markerCandidateSpy, 0, "refused KnightThisBeef does not MarkCandidate")
assert_eq(Knighting:ElevateToLord(999), nil, "ElevateToLord without a human refuses")
assert_eq(#proclaimSpy, 0, "refused ElevateToLord does not Proclaim")

reset()
stubPope()
local nameless = Store:CreateHuman({})
assert_true(nameless ~= nil, "nameless human is created")
local namelessOk = Knighting:KnightThisBeef(nameless.id)
assert_true(namelessOk ~= nil, "KnightThisBeef without a Store name still writes")
assert_eq(#proclaimSpy, 1, "nameless KnightThisBeef still Proclaims")
assert_eq(proclaimSpy[1].fields.name, nil, "nameless KnightThisBeef omits Proclaim name")
assert_eq(#markerTargetSpy, 0, "missing Store name skips Target")
assert_eq(#markerCandidateSpy, 0, "missing Store name skips MarkCandidate")

reset()
stubPope()
COB.Toasts = nil
local quietHuman = Store:CreateHuman({ name = "Sirloin" })
local stillKnight, stillKnightErr = Knighting:KnightThisBeef(quietHuman.id)
assert_true(stillKnight ~= nil, "missing Toasts does not break KnightThisBeef")
assert_eq(stillKnightErr, nil, "missing Toasts is a knighting no-op")
assert_eq(#markerTargetSpy, 0, "missing Toasts still does not TargetUnit")
assert_eq(#markerCandidateSpy, 1, "missing Toasts still MarkCandidate")

reset()
stubPope()
COB.Markers = nil
local muteKnight = Store:CreateHuman({ name = "Sirloin" })
local muteKnightOk, muteKnightErr = Knighting:KnightThisBeef(muteKnight.id)
assert_true(muteKnightOk ~= nil, "missing Markers does not break KnightThisBeef")
assert_eq(muteKnightErr, nil, "missing Markers is a knighting no-op")
assert_eq(#proclaimSpy, 1, "missing Markers still Proclaims knighting")

--------------------------------------------------------------------------------
-- OpenRite / Continue refresh furniture. Lane W: /beef petition / confess /
-- catchup are gone — they fall through to the player card like any
-- unrecognised argument, and never touch Inputs.
--------------------------------------------------------------------------------
reset()
stubPope()
assert_true(Runtime:StartEvent() ~= nil, "StartEvent for OpenRite furniture")
inputRefreshSpy = {}
assert_true(Runtime:OpenRite("Gora") ~= nil, "OpenRite succeeds")
assert_eq(#inputRefreshSpy, 1, "OpenRite refreshes Inputs")
assert_true(Runtime:CloseRite() ~= nil, "CloseRite succeeds")
inputRefreshSpy = {}
assert_true(Runtime:Continue() ~= nil, "Continue succeeds")
assert_eq(#inputRefreshSpy, 1, "Continue refreshes Inputs")

reset()
local cardToggles = 0
local savedCard = COB.PlayerCard
COB.PlayerCard = { Toggle = function() cardToggles = cardToggles + 1; return true end }
SlashCmdList["CHURCHOFBEEF"]("")
assert_eq(cardToggles, 1, "/beef toggles the player card")
local goraShows = 0
COB.PlayerCard.ShowGora = function() goraShows = goraShows + 1; return true end
SlashCmdList["CHURCHOFBEEF"]("gora")
assert_eq(goraShows, 1, "/beef gora opens the sanctioned record")
assert_eq(cardToggles, 1, "/beef gora does not toggle the home card")
local helpNotes = {}
local savedHelpChat = DEFAULT_CHAT_FRAME
DEFAULT_CHAT_FRAME = {
  AddMessage = function(_, message) helpNotes[#helpNotes + 1] = message end,
}
SlashCmdList["CHURCHOFBEEF"]("anything")
assert_eq(cardToggles, 1, "unrecognised arguments do not toggle the player card")
assert_true(#helpNotes >= 1, "unrecognised arguments print help")
assert_true(helpNotes[1]:find("Ask to fight", 1, true) ~= nil,
  "help names Ask to fight")
assert_eq(helpNotes[1]:find("Director Console", 1, true), nil,
  "congregation help does not advertise the Director Console")
local savedHelpPope = Sender.IsRegisteredPope
Sender.IsRegisteredPope = function() return false end
helpNotes = {}
SlashCmdList["CHURCHOFBEEF"]("help")
assert_eq(#helpNotes, 1, "congregation help is one line")
assert_true(helpNotes[1]:find("/beef", 1, true) ~= nil, "help names /beef")
Sender.IsRegisteredPope = function() return true end
helpNotes = {}
SlashCmdList["CHURCHOFBEEF"]("help")
assert_eq(#helpNotes, 2, "listed Pope help is two lines")
assert_true(helpNotes[2]:find("/beef console", 1, true) ~= nil,
  "Pope help names the desk slash")
Sender.IsRegisteredPope = savedHelpPope
helpNotes = {}
SlashCmdList["CHURCHOFBEEF"]("petition")
assert_eq(cardToggles, 1, "retired subcommands print help, not the card")
DEFAULT_CHAT_FRAME = savedHelpChat
COB.PlayerCard = savedCard
assert_eq(#inputTargetBindSpy, 0, "no slash binds an input target anymore")
assert_eq(#inputPetitionSpy, 0, "no slash calls Inputs:Petition anymore")
assert_eq(#inputShowSpy, 0, "no slash Shows Inputs anymore")
assert_eq(#inputCatchupSpy, 0, "no slash calls Inputs:Catchup anymore")

do
  local savedDeskPope = Sender.IsRegisteredPope
  Sender.IsRegisteredPope = function() return false end
  if COB.Console and COB.Console.Init then
    COB.Console:Init()
  end
  SlashCmdList["CHURCHOFBEEF"]("console")
  assert_eq(COB.Console:IsShown(), false,
    "congregation /beef console does not open the desk after Init")
  Sender.IsRegisteredPope = savedDeskPope
end

-- The retired shell owned the "UI not ready" fallback; it now names the card.
COB.PlayerCard = nil
local chatNotes = {}
local savedChat = DEFAULT_CHAT_FRAME
DEFAULT_CHAT_FRAME = {
  AddMessage = function(_, message) chatNotes[#chatNotes + 1] = message end,
}
SlashCmdList["CHURCHOFBEEF"]("")
assert_eq(cardToggles, 1, "a missing player card does not toggle")
assert_eq(#chatNotes, 1, "a missing player card prints the not-ready fallback")
assert_true(chatNotes[1]:find("player card", 1, true) ~= nil,
  "the not-ready fallback names the player card")
DEFAULT_CHAT_FRAME = savedChat
COB.PlayerCard = savedCard

--------------------------------------------------------------------------------
-- B10 / B11 / B12: live pair may ride ASSEMBLY STATE (Restore-safe after
-- B12-A). Last pair still stays off post-Continue ASSEMBLY.
--------------------------------------------------------------------------------
local function runB10()
reset()
stubPope()
Runtime:StartEvent()
local lastA, lastB = twoChars()
assert_true(Gora:Sanction(lastA.id, lastB.id) ~= nil, "last-pair Sanction succeeds")
local afterSanction = lastOfType("STATE")
assert_true(afterSanction ~= nil, "Sanction sends STATE")
assert_eq(afterSanction.state, "ASSEMBLY", "Sanction without OpenRite stays ASSEMBLY")
assert_eq(afterSanction.subjects.fighters[1], lastA.id, "ASSEMBLY live overlay names fighter A")
assert_eq(afterSanction.subjects.fighters[2], lastB.id, "ASSEMBLY live overlay names fighter B")
assert_true(afterSanction.favor ~= nil, "toggle-on ASSEMBLY live overlay may carry favor")
assert_eq(afterSanction.favor.a, 0, "Sanction before a pick is favor 0")
assert_eq(afterSanction.favor.b, 0, "Sanction before a pick is favor 0 B")

local savedAccept = Sender.Accept
Sender.Accept = function() return true end
local inboundAsm = Codec:EncodeState({
  eventId = afterSanction.eventId,
  state = "ASSEMBLY",
  subjects = { fighters = { lastA.id, lastB.id } },
  sequence = afterSanction.sequence,
})
assert_true(inboundAsm ~= nil, "ASSEMBLY live STATE encodes")
local decodedAsm = Codec:DecodeState(inboundAsm)
assert_eq(Net:_HandleState(decodedAsm, "GUILD", "Steakina"), true,
  "congregation Restore accepts ASSEMBLY fighters")
Sender.Accept = savedAccept

assert_true(Runtime:OpenRite("Gora", { fighters = { lastA.id, lastB.id } }) ~= nil,
  "OpenRite moves the pair onto Restore-safe subjects")
assert_eq(Gora:RecordFavor(lastA.id, lastA.id), true, "last-pair favor stands")
local declared = Gora:DeclareVictor(lastA.id)
assert_true(declared ~= nil, "last-pair DeclareVictor succeeds")
assert_eq(Gora:GetSanctioned(), nil, "ruling still clears the live pair")
local lastPair = Gora:GetLastSanctioned()
assert_true(lastPair ~= nil, "last pair is remembered")
assert_eq(lastPair.fighterA, lastA.id, "last pair keeps A")
assert_eq(lastPair.fighterB, lastB.id, "last pair keeps B")
local afterVerdict = lastOfType("STATE")
assert_true(afterVerdict ~= nil, "DeclareVictor sends STATE")
assert_eq(afterVerdict.state, "RITE", "verdict STATE stays in the open rite")
assert_eq(afterVerdict.subjects.fighters[1], lastA.id, "verdict STATE keeps fighter A")
assert_eq(afterVerdict.subjects.fighters[2], lastB.id, "verdict STATE keeps fighter B")
assert_true(afterVerdict.favor ~= nil, "verdict STATE keeps the frozen favor")
assert_eq(afterVerdict.favor.a, 1, "frozen favor a")
assert_eq(afterVerdict.favor.b, 0, "frozen favor b")

assert_eq(Console:SetCongregationFavorVisible(false), true, "toggle off after verdict")
local toggled = lastOfType("STATE")
assert_eq(toggled.favor, nil, "toggle-off still omits favor after the ruling")
assert_eq(toggled.subjects.fighters[1], lastA.id, "toggle-off still names fighter A")
assert_eq(toggled.subjects.fighters[2], lastB.id, "toggle-off still names fighter B")

assert_true(Runtime:CloseRite() ~= nil, "CloseRite is CONSEQUENCE")
local afterClose = lastOfType("STATE")
assert_eq(afterClose.state, "CONSEQUENCE", "CloseRite STATE is CONSEQUENCE")
assert_eq(afterClose.subjects.fighters[1], lastA.id, "CONSEQUENCE still names fighter A")
assert_eq(afterClose.subjects.fighters[2], lastB.id, "CONSEQUENCE still names fighter B")

assert_true(Runtime:Continue() ~= nil, "Continue returns to ASSEMBLY")
local afterContinue = lastOfType("STATE")
assert_eq(afterContinue.state, "ASSEMBLY", "Continue STATE is ASSEMBLY")
assert_eq(#afterContinue.subjects.fighters, 0, "post-Continue ASSEMBLY does not overlay last pair")
assert_eq(afterContinue.favor, nil, "post-Continue ASSEMBLY omits favor")

Runtime:EndEvent()
local quietMsg = lastOfType("STATE")
assert_eq(quietMsg.state, "QUIET", "EndEvent STATE is QUIET")
assert_eq(quietMsg.favor, nil, "QUIET STATE omits favor")
end
runB10()

--------------------------------------------------------------------------------
-- B14-INT: Knighting line-head candidate overlays STATE when Runtime lacks
-- one (ASSEMBLY, or RITE Knighting). Encode-only. No Enqueue sendState.
-- Nested `do` so the main chunk stays under Lua 5.1's 200-local cap.
--------------------------------------------------------------------------------
do
reset()
stubPope()
if Knighting.ResetForTests then
  assert_eq(Knighting:ResetForTests(), true, "Knighting ResetForTests runs under _IN_TEST")
end
Runtime:StartEvent()
local lineHuman = Store:CreateHuman({ name = "Sirloin" })
assert_true(Knighting:Enqueue(lineHuman.id) ~= nil, "Enqueue line head")
assert_eq(Runtime:Snapshot().subjects.candidate, nil,
  "Runtime candidate stays empty after Enqueue")
assert_eq(Knighting:GetLine()[1].humanId, lineHuman.id, "line head is the enqueued human")
assert_eq(Console:SetCongregationFavorVisible(true), true, "toggle forces SendState")
local afterToggle = lastOfType("STATE")
assert_true(afterToggle ~= nil, "toggle sends STATE")
assert_eq(afterToggle.state, "ASSEMBLY", "toggle STATE stays ASSEMBLY")
assert_eq(afterToggle.subjects.candidate, lineHuman.id,
  "ASSEMBLY STATE overlays line-head candidate")
assert_eq(Runtime:Snapshot().subjects.candidate, nil,
  "overlay does not write Runtime candidate")

local goraA, goraB = twoChars()
assert_true(Runtime:OpenRite("Gora", { fighters = { goraA.id, goraB.id } }) ~= nil,
  "OpenRite Gora from ASSEMBLY")
local goraState = lastOfType("STATE")
assert_eq(goraState.state, "RITE", "OpenRite Gora STATE is RITE")
assert_eq(goraState.riteType, "Gora", "rite type is Gora")
assert_eq(goraState.subjects.candidate, nil,
  "Gora RITE does not overlay knighting candidate")
assert_eq(goraState.subjects.fighters[1], goraA.id, "Gora RITE keeps fighter A")
assert_eq(goraState.subjects.fighters[2], goraB.id, "Gora RITE keeps fighter B")

reset()
stubPope()
if Knighting.ResetForTests then
  Knighting:ResetForTests()
end
Runtime:StartEvent()
local knightHuman = Store:CreateHuman({ name = "Sirloin" })
assert_true(Runtime:OpenRite("Knighting", { candidate = knightHuman.id }) ~= nil,
  "OpenRite Knighting with Runtime candidate")
local knightState = lastOfType("STATE")
assert_eq(knightState.state, "RITE", "Knighting STATE is RITE")
assert_eq(knightState.riteType, "Knighting", "rite type is Knighting")
assert_eq(knightState.subjects.candidate, knightHuman.id,
  "Knighting STATE keeps Runtime candidate")
end

--------------------------------------------------------------------------------
-- B15-INT: successful Enqueue / Skip / Insert / KnightThisBeef / ElevateToLord
-- send STATE. Failed Enqueue does not. Nested `do` — no new main-chunk local.
--------------------------------------------------------------------------------
do
reset()
stubPope()
if Knighting.ResetForTests then
  assert_eq(Knighting:ResetForTests(), true, "Knighting ResetForTests for B15-INT")
end
Runtime:StartEvent()
local head = Store:CreateHuman({ name = "Sirloin" })
local tail = Store:CreateHuman({ name = "Chuck" })
assert_true(Knighting:Enqueue(head.id) ~= nil, "Enqueue head")
local afterEnq = lastOfType("STATE")
assert_true(afterEnq ~= nil, "Enqueue sends STATE")
assert_eq(afterEnq.state, "ASSEMBLY", "Enqueue STATE stays ASSEMBLY")
assert_eq(afterEnq.subjects.candidate, head.id, "Enqueue STATE overlays the line head")
assert_eq(Runtime:Snapshot().subjects.candidate, nil,
  "Enqueue overlay does not write Runtime candidate")

assert_true(Knighting:Insert(tail.id) ~= nil, "Insert tail")
local afterIns = lastOfType("STATE")
assert_eq(afterIns.subjects.candidate, head.id, "Insert keeps the existing head")

assert_true(Knighting:Skip(head.id) ~= nil, "Skip the head")
local afterSkip = lastOfType("STATE")
assert_eq(afterSkip.subjects.candidate, tail.id, "Skip STATE overlays the remaining head")
assert_eq(Runtime:Snapshot().subjects.candidate, nil,
  "Skip overlay does not write Runtime candidate")

local lord = Store:CreateHuman({ name = "Baron" })
assert_true(Knighting:ElevateToLord(lord.id) ~= nil, "ElevateToLord writes Lord")
local afterElev = lastOfType("STATE")
assert_true(afterElev ~= nil, "ElevateToLord sends STATE")
local beforeFail = countType("STATE")
local failed, failErr = Knighting:Enqueue(lord.id)
assert_eq(failed, nil, "Enqueue refuses a Lord")
assert_eq(failErr, "already knighted", "Lord Enqueue names already knighted")
assert_eq(countType("STATE"), beforeFail, "failed Enqueue does not send STATE")

reset()
stubPope()
if Knighting.ResetForTests then
  Knighting:ResetForTests()
end
Runtime:StartEvent()
local first = Store:CreateHuman({ name = "Sirloin" })
local second = Store:CreateHuman({ name = "Chuck" })
assert_true(Knighting:Enqueue(first.id) ~= nil, "Enqueue first for knighting STATE")
assert_true(Knighting:Enqueue(second.id) ~= nil, "Enqueue second for knighting STATE")
assert_true(Knighting:KnightThisBeef(first.id) ~= nil, "KnightThisBeef the head")
local afterKnight = lastOfType("STATE")
assert_eq(afterKnight.subjects.candidate, second.id,
  "KnightThisBeef STATE overlays the remaining head")
  assert_eq(Runtime:Snapshot().subjects.candidate, nil,
  "KnightThisBeef overlay does not write Runtime candidate")
end

--------------------------------------------------------------------------------
-- Task 6: empty-store INPUT apply. No pew Ensure. Sender-keyed unsigned desk.
--------------------------------------------------------------------------------
do
  reset()
  stubPope()
  Runtime:StartEvent()
  local humans0 = #Store:Snapshot().humans
  local chars0 = #Store:Snapshot().characters
  assert_eq(humans0, 0, "login bind starts from an empty store")
  assert_eq(chars0, 0, "login bind starts with zero characters")
  local petition = Codec:EncodeInput({
    kind = "petition",
    characterId = 99,
    opponent = "Nobody",
  })
  assert_true(petition ~= nil, "spoofed-id petition still encodes")
  local petOk, petWhy = Net:OnAddonMessage(Net.Prefix, petition, "WHISPER", "Zipfresh")
  assert_eq(petOk, true, "empty-store petition from Zipfresh is accepted")
  assert_eq(petWhy, nil, "unknown opponent does not refuse the ask")
  assert_eq(petWhy ~= "unknown opponent", true, "apply does not return unknown opponent")
  local desk = Gora:GetPetitions()
  assert_eq(#desk, 1, "unsigned Zipfresh lands on the desk")
  assert_eq(desk[1].senderKey, "zipfresh", "desk row keys by Names.Key(sender)")
  assert_eq(desk[1].name, "Zipfresh", "desk row paints the unsigned name")
  assert_eq(desk[1].characterId, nil, "unsigned desk row has no store id")
  assert_eq(desk[1].namedOpponentId, nil, "unknown opponent is ignored")
  assert_eq(#Store:Snapshot().humans, 0, "INPUT apply creates no human")
  assert_eq(#Store:Snapshot().characters, 0, "INPUT apply creates no character")

  local fighterA, fighterB = twoChars()
  assert_true(Gora:Sanction(fighterA.id, fighterB.id) ~= nil, "sanction the bout for favor")
  local humans1 = #Store:Snapshot().humans
  local chars1 = #Store:Snapshot().characters
  local favor = Codec:EncodeInput({
    kind = "favor",
    characterId = 99,
    pick = fighterA.id,
  })
  local favOk, favWhy = Net:OnAddonMessage(Net.Prefix, favor, "WHISPER", "Zipfresh")
  assert_eq(favOk, true, "spoofed-id favor from Zipfresh is accepted")
  assert_eq(favWhy, nil, "spoofed favor has no apply error")
  local picks = Gora:GetFavor()
  assert_eq(picks[99], nil, "RecordFavor does not write favorPicks[spoofedId]")
  assert_eq(picks.zipfresh, fighterA.id, "favor keys by sender name-key")
  assert_eq(#Store:Snapshot().humans, humans1, "favor apply creates no human")
  assert_eq(#Store:Snapshot().characters, chars1, "favor apply creates no character")
end

--------------------------------------------------------------------------------
-- Restore Pope stub and unwrap so a later harness suite is not polluted.
--------------------------------------------------------------------------------
Sender.IsRegisteredPope = origPope
Hud.SetBroadcastFavor = origSetFavor
Hud.SetFavorTarget = origSetTarget
Hud.SetLocalCharacterId = origSetLocal
Runtime.StartEvent = origStart
Runtime.OpenRite = origOpen
Runtime.CloseRite = origClose
Runtime.Continue = origContinue
Runtime.EndEvent = origEnd
Gora.RecordFavor = origFavor
Gora.RecordFavorFromSender = origFavorFrom
Gora.Sanction = origSanction
Gora.DeclareVictor = origVictor
Gora.Void = origVoid
Gora.FreeRuling = origFree
Gora.CowardiceRecorded = origCoward
Knighting.KnightThisBeef = origKnight
Knighting.ElevateToLord = origElevate
COB.FighterCard = origCard
COB.Inputs = origInputs
COB.Markers = origMarkers
Console.SetCongregationFavorVisible = origToggle
Console.PostDecree = origPost
Decree.Clear = origClear
Decree.Set = origDecreeSet
COB.DecreeBanner = origBanner
Net._HandleState = origHandleState
Net._HandleSnapshot = origHandleSnap
Store.Restore = origStoreRestore
Hud.Refresh = origHudRefresh
if COB.Toasts then
  COB.Toasts.Proclaim = origProclaim
end
COB._wireInstalled = nil
COB._OnPeerHello = nil
COB._inspecting = nil
COB._snapshotAsked = nil

assert_eq(Sender:IsRegisteredPope("Beefina"), false, "Pope stub is restored")
assert_eq(Runtime.StartEvent, origStart, "StartEvent wrap is restored")
assert_eq(Knighting.KnightThisBeef, origKnight, "KnightThisBeef wrap is restored")
assert_eq(Knighting.ElevateToLord, origElevate, "ElevateToLord wrap is restored")
assert_eq(COB.FighterCard, origCard, "FighterCard spy is restored")
assert_eq(COB.Inputs, origInputs, "Inputs spy is restored")
assert_eq(COB.Markers, origMarkers, "Markers spy is restored")

if restoreUi then restoreUi() end

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
