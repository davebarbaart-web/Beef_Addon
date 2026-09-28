ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef
COB.VERSION = "0.1.0"
COB.ADDON_MSG_PREFIX = "COB"

function COB:OnLoad()
  if COB.DB and COB.DB.Init then
    COB.DB:Init()
  end
  COB.loaded = true
end

-- UI init lives on the bootstrap now that the Quiet shell is retired (Lane T).
-- Every module Init is pcall'd (Wave 2 Task 1). A Hud inherit abort must
-- still reach Net:Init. No shell frame, no UISpecialFrames listing for it,
-- no roster event registration on a shell, no ui.shown reopen-on-login
-- (the SV key stays in DB defaults harmlessly).
local function initChat(text)
  if type(DEFAULT_CHAT_FRAME) == "table" and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: " .. text)
  end
end

local function initModule(name, mod)
  if type(mod) ~= "table" or type(mod.Init) ~= "function" then
    return
  end
  local ok = pcall(mod.Init, mod)
  if not ok then
    initChat(name .. " failed to start.")
  end
end

local function initUi()
  initModule("Minimap", COB.Minimap)
  initModule("RecordsBook", COB.RecordsBook)
  initModule("PlayerCard", COB.PlayerCard)
  initModule("Hud", COB.Hud)
  initModule("Console", COB.Console)
  initModule("Toasts", COB.Toasts)
  initModule("DecreeBanner", COB.DecreeBanner)
  initModule("Welcome", COB.Welcome)
  initModule("Sound", COB.Sound)
  initModule("FighterCard", COB.FighterCard)
  initModule("Inputs", COB.Inputs)
  initModule("Markers", COB.Markers)
end

-- Forward: defined with the wire helpers. OnLogin runs after file load.
local sendState

local function isLocalPope()
  if not (COB.Sender and type(COB.Sender.IsRegisteredPope) == "function") then
    return false
  end
  if type(UnitName) ~= "function" then return false end
  return COB.Sender:IsRegisteredPope(UnitName("player")) == true
end

-- Pew leftover ChurchOfBeefDB.event is the Pope's ceremony, not this client's.
-- Nil-eventId Quiet (DropToQuietForVersion / newEvent shape). Do not EndEvent
-- from RITE, and do not Restore { state="QUIET", eventId=<same>, sequence=0 }.
local function dropCongregationEventIfNeeded()
  if isLocalPope() then return end
  local Runtime = COB.Runtime
  if type(Runtime) ~= "table" then return end
  if type(Runtime.DropToQuietForVersion) == "function" then
    pcall(Runtime.DropToQuietForVersion, Runtime)
    return
  end
  if type(Runtime.Restore) == "function" then
    pcall(Runtime.Restore, Runtime, {
      eventId = nil,
      state = "QUIET",
      riteType = nil,
      subjects = { candidate = nil, fighters = nil },
      sequence = 0,
    })
  end
end

-- Catch-up whisper only after accepted Pope HELLO or live STATE this session
-- (callers are those two paths). Local still QUIET, once per login. No dest
-- / Tuesday no-response is not a failure. Do not ask from OnLogin itself.
local function maybeRequestSnapshot()
  if COB._snapshotAsked then return end
  if isLocalPope() then return end
  local Runtime = COB.Runtime
  if not (type(Runtime) == "table" and type(Runtime.Snapshot) == "function") then
    return
  end
  local snap = Runtime:Snapshot()
  if type(snap) ~= "table" or snap.state ~= "QUIET" then return end
  local Net = COB.Net
  if not (type(Net) == "table" and type(Net.RequestSnapshot) == "function") then
    return
  end
  COB._snapshotAsked = true
  pcall(Net.RequestSnapshot, Net)
end

function COB:OnLogin()
  COB._snapshotAsked = nil
  -- Role split is here (PLAYER_LOGIN), not DB:Init (ADDON_LOADED).
  dropCongregationEventIfNeeded()
  initUi()
  if COB.Net and COB.Net.Init then
    COB.Net:Init()
  end
  self:InstallWire()
  -- #48: listed Pope rebroadcasts a restored live event once. Peer HELLO
  -- rebroadcast stays on _OnPeerHello.
  if COB.Net and COB.Net.RebroadcastStubs then
    pcall(COB.Net.RebroadcastStubs, COB.Net)
  end
  if isLocalPope() and type(sendState) == "function" then
    local Runtime = COB.Runtime
    if type(Runtime) == "table" and type(Runtime.Snapshot) == "function" then
      local snap = Runtime:Snapshot()
      if type(snap) == "table" and type(snap.state) == "string" and snap.state ~= "QUIET" then
        sendState()
      end
    end
  end
end

function COB:OnLogout()
  -- Save still runs for store / ui / decree. Ceremony blobs (event + gora)
  -- write only when DB:Save sees a registered Pope; pew leaves those keys.
  if COB.DB and COB.DB.Save then
    COB.DB:Save()
  end
end

--------------------------------------------------------------------------------
-- Wire glue. UI and Core stay Net-free. Wraps attach on login only so a
-- minimap dofile of this file does not broadcast. Fail-closed: missing Net
-- or an unlisted Pope already refuse. Do not throw.
--------------------------------------------------------------------------------

local function skipSend()
  return COB._inspecting == true
end

local function fighterCount(subjects)
  if type(subjects) ~= "table" or type(subjects.fighters) ~= "table" then
    return 0
  end
  return #subjects.fighters
end

local function holdPair(pair)
  return type(pair) == "table" and pair.fighterA and pair.fighterB
end

-- Runtime:Restore now accepts fighters in ASSEMBLY (B12-A). QUIET still
-- refuses them. Last pair stays off post-Continue ASSEMBLY so a finished
-- bout does not reopen picks. Knighting line-head candidate overlays
-- encode-only (B14-A SNAPSHOT / B14-INT STATE) when Runtime lacks one.
local function canCarryLive(state)
  return state == "ASSEMBLY" or state == "RITE" or state == "CONSEQUENCE"
end

local function canCarryLast(state, riteType)
  if riteType ~= "Gora" then return false end
  return state == "RITE" or state == "CONSEQUENCE"
end

local function canCarryCandidate(state, riteType)
  if state == "ASSEMBLY" then return true end
  return state == "RITE" and riteType == "Knighting"
end

local function overlayFighters(fields, pair)
  if fighterCount(fields.subjects) == 2 then return end
  local candidate = type(fields.subjects) == "table" and fields.subjects.candidate or nil
  fields.subjects = {
    candidate = candidate,
    fighters = { pair.fighterA, pair.fighterB },
  }
end

local function displayForId(id)
  if type(id) ~= "number" then return nil end
  local Store = COB.Store
  if not (Store and Store.GetCharacter) then return nil end
  local ch = Store:GetCharacter(id)
  if type(ch) ~= "table" or type(ch.name) ~= "string" then return nil end
  if COB.Names and COB.Names.Display then
    return COB.Names.Display(ch.name)
  end
  return ch.name
end

local function overlayNames(fields)
  local names = { candidate = nil, fighterA = nil, fighterB = nil }
  local subjects = fields.subjects
  if type(subjects) == "table" then
    names.candidate = displayForId(subjects.candidate)
    if type(subjects.fighters) == "table" then
      names.fighterA = displayForId(subjects.fighters[1])
      names.fighterB = displayForId(subjects.fighters[2])
    end
  end
  fields.names = names
end

local function overlayCandidate(fields)
  local subjects = fields.subjects
  if type(subjects) == "table" and type(subjects.candidate) == "number" then
    return
  end
  if not canCarryCandidate(fields.state, fields.riteType) then
    return
  end
  local Knighting = COB.Knighting
  if type(Knighting) ~= "table" or type(Knighting.GetLine) ~= "function" then
    return
  end
  local ok, line = pcall(Knighting.GetLine, Knighting)
  if not ok or type(line) ~= "table" then return end
  local head = line[1]
  if type(head) ~= "table" or type(head.humanId) ~= "number" then return end
  local fighters = type(subjects) == "table" and subjects.fighters or nil
  fields.subjects = {
    candidate = head.humanId,
    fighters = fighters,
  }
end

local function stateFields()
  local fields = {}
  if COB.Runtime and COB.Runtime.Snapshot then
    local snap = COB.Runtime:Snapshot()
    if type(snap) == "table" then
      fields.eventId = snap.eventId
      fields.state = snap.state
      fields.riteType = snap.riteType
      fields.subjects = snap.subjects
      fields.sequence = snap.sequence
    end
  end

  local visible = COB.Console
    and COB.Console.GetCongregationFavorVisible
    and COB.Console:GetCongregationFavorVisible() == true
  local live = COB.Gora and COB.Gora.GetSanctioned and COB.Gora:GetSanctioned()
  if not holdPair(live) then live = nil end
  local last = nil
  if not live and COB.Gora and type(COB.Gora.GetLastSanctioned) == "function" then
    last = COB.Gora:GetLastSanctioned()
    if not holdPair(last) then last = nil end
  end
  if live and canCarryLive(fields.state) then
    overlayFighters(fields, live)
  elseif last and canCarryLast(fields.state, fields.riteType) then
    overlayFighters(fields, last)
  end
  overlayCandidate(fields)
  if visible and fighterCount(fields.subjects) == 2 then
    if live and COB.Gora.GetFavorSplit then
      fields.favor = COB.Gora:GetFavorSplit()
    elseif last and COB.Gora.GetLastFavorSplit then
      fields.favor = COB.Gora:GetLastFavorSplit()
    end
  end
  overlayNames(fields)
  return fields
end

function sendState()
  if skipSend() then return end
  local Net = COB.Net
  if not (Net and Net.SendState) then return end
  pcall(Net.SendState, Net, stateFields())
end

local function sendDecree(fields)
  if skipSend() then return end
  local Net = COB.Net
  if not (Net and Net.SendDecree) then return end
  pcall(Net.SendDecree, Net, fields)
  if Net.SendNights then
    pcall(Net.SendNights, Net)
  end
end

local function bindLocalCharacter()
  if not (COB.Store and COB.Store.Snapshot) then return end
  if not (COB.Names and COB.Names.Key) then return end
  if type(UnitName) ~= "function" then return end
  local me = COB.Names.Key(UnitName("player"))
  if not me then return end
  local snap = COB.Store:Snapshot()
  local chars = snap and snap.characters
  if type(chars) ~= "table" then return end
  for i = 1, #chars do
    local row = chars[i]
    if type(row) == "table" and COB.Names.Key(row.name) == me then
      if COB.Hud and COB.Hud.SetLocalCharacterId then
        pcall(COB.Hud.SetLocalCharacterId, COB.Hud, row.id)
      end
      if not skipSend() and COB.Inputs and COB.Inputs.SetLocalCharacterId then
        pcall(COB.Inputs.SetLocalCharacterId, COB.Inputs, row.id)
      end
      return
    end
  end
end

local function hideInputs()
  if COB.Inputs and type(COB.Inputs.Hide) == "function" then
    pcall(COB.Inputs.Hide, COB.Inputs)
  end
end

local function refreshEventFurniture()
  if skipSend() then return end
  if COB.Inputs and type(COB.Inputs.Refresh) == "function" then
    pcall(COB.Inputs.Refresh, COB.Inputs)
  end
  -- Knighting OpenRite / Continue must forget leftover lastPair in place.
  if COB.Hud and type(COB.Hud.Refresh) == "function" then
    pcall(COB.Hud.Refresh, COB.Hud)
  end
end

local function afterRuntime()
  sendState()
  refreshEventFurniture()
end

local function hideFighterCard()
  if skipSend() then return end
  local Card = COB.FighterCard
  if type(Card) == "table" and type(Card.Hide) == "function" then
    pcall(Card.Hide, Card)
  end
end

-- The Pope's HUD refresh after a verdict is deterministic on his client — it
-- does not wait for the STATE echo. skipSend-guarded like its neighbors.
local function refreshHud()
  if skipSend() then return end
  local Hud = COB.Hud
  if type(Hud) == "table" and type(Hud.Refresh) == "function" then
    pcall(Hud.Refresh, Hud)
  end
end

local function refreshConsole()
  if skipSend() then return end
  local Desk = COB.Console
  if type(Desk) == "table" and type(Desk.Refresh) == "function" then
    pcall(Desk.Refresh, Desk)
  end
end

local function afterEndEvent()
  sendState()
  refreshEventFurniture()
  hideFighterCard()
  -- Desk-bypassing EndEvent (InspectProgress / Runtime:EndEvent) must
  -- drop a leftover Recommend line. Refresh is Pope-local and does not send.
  local Desk = COB.Console
  if type(Desk) == "table" and type(Desk.Refresh) == "function" then
    pcall(Desk.Refresh, Desk)
  end
  -- Leftover raid marks stay after End. Clear refuses Quiet; Forget sweeps.
  -- Inspect / skipSend must not touch the world.
  if skipSend() then return end
  local Marks = COB.Markers
  if type(Marks) == "table" and type(Marks.Forget) == "function" then
    pcall(Marks.Forget, Marks)
  end
end

local function paintInboundInputs(sender)
  if skipSend() then
    hideInputs()
    return
  end
  if COB.Inputs then
    if type(COB.Inputs.SetInputTarget) == "function" then
      pcall(COB.Inputs.SetInputTarget, COB.Inputs, sender)
    end
    if type(COB.Inputs.Refresh) == "function" then
      pcall(COB.Inputs.Refresh, COB.Inputs)
    end
  end
end

local function stashInboundCast(decoded)
  if type(decoded) ~= "table" then return end
  local names = decoded.names
  local stash = {
    candidate = nil,
    fighterA = nil,
    fighterB = nil,
    byId = {},
  }
  if type(names) == "table" then
    stash.candidate = names.candidate
    stash.fighterA = names.fighterA
    stash.fighterB = names.fighterB
  end
  local subjects = decoded.subjects
  if type(subjects) == "table" then
    if type(subjects.candidate) == "number" and type(stash.candidate) == "string" then
      stash.byId[subjects.candidate] = stash.candidate
    end
    if type(subjects.fighters) == "table" then
      if type(subjects.fighters[1]) == "number" and type(stash.fighterA) == "string" then
        stash.byId[subjects.fighters[1]] = stash.fighterA
      end
      if type(subjects.fighters[2]) == "number" and type(stash.fighterB) == "string" then
        stash.byId[subjects.fighters[2]] = stash.fighterB
      end
    end
  end
  COB._lastCastNames = stash
  COB._lastCast = {
    eventId = decoded.eventId,
    state = decoded.state,
    riteType = decoded.riteType,
    subjects = subjects,
    names = stash,
  }
end

local function paintInboundFavor(decoded, sender)
  local Hud = COB.Hud
  if type(Hud) ~= "table" then return end
  if Hud.SetFavorTarget then
    pcall(Hud.SetFavorTarget, Hud, sender)
  end
  if Hud.SetBroadcastFavor then
    local favor = decoded and decoded.favor or nil
    pcall(Hud.SetBroadcastFavor, Hud, favor)
  end
  if Hud.Refresh then
    pcall(Hud.Refresh, Hud)
  end
end

local function wrapAfter(module, name, afterFn)
  if type(module) ~= "table" then return end
  local orig = module[name]
  if type(orig) ~= "function" then return end
  module[name] = function(self, ...)
    local result, err = orig(self, ...)
    if result ~= nil then
      afterFn(self, result)
    end
    return result, err
  end
end

-- Pope desk persist after a successful write. wow_stub has no C_Timer:
-- Save runs on the write path. Client C_Timer.After coalesces. Logout
-- still flushes. Never wrap ResetForTests. Never Save from Gora:_Expire.
local function persistAfterWrite()
  local DB = COB.DB
  if not (type(DB) == "table" and type(DB.Save) == "function") then return end
  if C_Timer and type(C_Timer.After) == "function" then
    if COB._persistQueued then return end
    COB._persistQueued = true
    C_Timer.After(0, function()
      COB._persistQueued = nil
      pcall(DB.Save, DB)
    end)
    return
  end
  pcall(DB.Save, DB)
end

local function persistWrites(module, names)
  if type(module) ~= "table" or type(names) ~= "table" then return end
  for i = 1, #names do
    local name = names[i]
    if name ~= "ResetForTests" and name ~= "_Expire" then
      wrapAfter(module, name, persistAfterWrite)
    end
  end
end

-- Clear returns nil; wrapAfter would skip the banner wipe.
local function wrapAlways(module, name, afterFn)
  if type(module) ~= "table" then return end
  local orig = module[name]
  if type(orig) ~= "function" then return end
  module[name] = function(self, ...)
    local result, err = orig(self, ...)
    afterFn(self, result)
    return result, err
  end
end

local function characterName(id)
  local Store = COB.Store
  if not (Store and Store.GetCharacter) then return nil end
  local ok, row = pcall(Store.GetCharacter, Store, id)
  if not ok or type(row) ~= "table" then return nil end
  local name = row.name
  if type(name) == "string" and name ~= "" then return name end
  return nil
end

local function humanName(id)
  local Store = COB.Store
  if not (Store and Store.GetHuman) then return nil end
  local ok, row = pcall(Store.GetHuman, Store, id)
  if not ok or type(row) ~= "table" then return nil end
  local name = row.name
  if type(name) == "string" and name ~= "" then return name end
  return nil
end

local function proclaim(kind, fields)
  if skipSend() then return end
  local Toasts = COB.Toasts
  if not (Toasts and type(Toasts.Proclaim) == "function") then return end
  pcall(Toasts.Proclaim, Toasts, kind, fields)
end

local function showFighterCard()
  if skipSend() then return end
  local Card = COB.FighterCard
  if type(Card) ~= "table" then return end
  if type(Card.Show) == "function" then
    pcall(Card.Show, Card)
  end
  if type(Card.Refresh) == "function" then
    pcall(Card.Refresh, Card)
  end
end

local function markName(id)
  local name = humanName(id)
  if name then return name end
  return characterName(id)
end

local function markCandidate(name)
  if skipSend() then return end
  if type(name) ~= "string" or name == "" then return end
  local Markers = COB.Markers
  if type(Markers) ~= "table" then return end
  -- Do not TargetUnit here. Anniversary treats name-target as a Blizzard-only
  -- action (ADDON_ACTION_FORBIDDEN). MarkCandidate resolves a group unit.
  if type(Markers.MarkCandidate) == "function" then
    pcall(Markers.MarkCandidate, Markers, name)
  end
end

local function markFighters(nameA, nameB)
  if skipSend() then return end
  if type(nameA) ~= "string" or nameA == "" then return end
  if type(nameB) ~= "string" or nameB == "" then return end
  local Markers = COB.Markers
  if type(Markers) ~= "table" or type(Markers.MarkFighters) ~= "function" then
    return
  end
  pcall(Markers.MarkFighters, Markers, nameA, nameB)
end

function COB:InstallWire()
  if COB._wireInstalled then return true end
  COB._wireInstalled = true

  wrapAfter(COB.Runtime, "StartEvent", afterRuntime)
  wrapAfter(COB.Runtime, "OpenRite", afterRuntime)
  -- The fighter card is a sanction beat: it dies with the ruling beat, and
  -- CloseRite (CONSEQUENCE) sweeps it if no verdict landed first.
  wrapAfter(COB.Runtime, "CloseRite", function()
    sendState()
    hideFighterCard()
  end)
  wrapAfter(COB.Runtime, "Continue", afterRuntime)
  wrapAfter(COB.Runtime, "EndEvent", afterEndEvent)
  wrapAfter(COB.Gora, "RecordFavor", function()
    sendState()
    refreshHud()
    refreshConsole()
  end)
  wrapAfter(COB.Gora, "RecordFavorFromSender", function()
    sendState()
    refreshHud()
    refreshConsole()
  end)
  wrapAfter(COB.Gora, "Sanction", function(_, result)
    if type(result) ~= "table" then return end
    local fields = {}
    local a = characterName(result.fighterA)
    if a then fields.fighterA = a end
    local b = characterName(result.fighterB)
    if b then fields.fighterB = b end
    proclaim("sanction", fields)
    showFighterCard()
    markFighters(a, b)
    refreshHud()
    refreshConsole()
    sendState()
  end)
  wrapAfter(COB.Gora, "Propose", function()
    local Desk = COB.Console
    if type(Desk) == "table" and type(Desk.Show) == "function" then
      pcall(Desk.Show, Desk)
    end
    refreshConsole()
  end)
  wrapAfter(COB.Knighting, "Enqueue", sendState)
  wrapAfter(COB.Knighting, "Skip", sendState)
  wrapAfter(COB.Knighting, "Insert", sendState)
  wrapAfter(COB.Knighting, "KnightThisBeef", function(_, result)
    local fields = {}
    local name
    if type(result) == "table" then
      local human = humanName(result.id)
      if human then fields.name = human end
      name = markName(result.id)
    end
    proclaim("knighting", fields)
    markCandidate(name)
    sendState()
  end)
  wrapAfter(COB.Knighting, "ElevateToLord", function(_, result)
    local fields = {}
    if type(result) == "table" then
      local name = humanName(result.id)
      if name then fields.name = name end
    end
    proclaim("elevation", fields)
    sendState()
  end)
  wrapAfter(COB.Gora, "DeclareVictor", function(_, result)
    local fields = { ruling = "victor" }
    if type(result) == "table" then
      local name = characterName(result.winnerId)
      if name then fields.name = name end
    end
    proclaim("verdict", fields)
    hideFighterCard()
    refreshHud()
    sendState()
  end)
  wrapAfter(COB.Gora, "Void", function()
    proclaim("verdict", { ruling = "void" })
    hideFighterCard()
    refreshHud()
    sendState()
  end)
  wrapAfter(COB.Gora, "FreeRuling", function(_, result)
    local fields = { ruling = "free" }
    if type(result) == "table" and result.text ~= nil then
      fields.text = result.text
    end
    proclaim("verdict", fields)
    hideFighterCard()
    refreshHud()
    sendState()
  end)
  wrapAfter(COB.Gora, "CowardiceRecorded", function(_, result)
    local fields = {}
    if type(result) == "table" then
      local name = characterName(result.fleerId)
      if name then fields.name = name end
    end
    proclaim("cowardice", fields)
    hideFighterCard()
    refreshHud()
    sendState()
  end)
  wrapAfter(COB.Console, "SetCongregationFavorVisible", sendState)
  wrapAfter(COB.Console, "PostDecree", function(_, result)
    sendDecree({ line = result.line, flavor = result.flavor })
  end)
  wrapAfter(COB.Console, "PostStub", function(_, result)
    if skipSend() then return end
    local Net = COB.Net
    if Net and Net.SendStub and type(result) == "table" then
      pcall(Net.SendStub, Net, result)
    end
  end)
  wrapAfter(COB.Console, "PostSeries", function()
    if skipSend() then return end
    local Net = COB.Net
    if Net and Net.SendNights then
      pcall(Net.SendNights, Net)
    end
  end)
  wrapAfter(COB.Console, "SkipWeek", function()
    if skipSend() then return end
    local Net = COB.Net
    if Net and Net.SendNights then
      pcall(Net.SendNights, Net)
    end
  end)
  wrapAfter(COB.Console, "MoveWeek", function()
    if skipSend() then return end
    local Net = COB.Net
    if Net and Net.SendNights then
      pcall(Net.SendNights, Net)
    end
  end)
  wrapAfter(COB.Console, "WithdrawSeries", function()
    if skipSend() then return end
    local Net = COB.Net
    if Net and Net.SendNights then
      pcall(Net.SendNights, Net)
    end
  end)
  wrapAfter(COB.Console, "WithdrawStub", function(_, result)
    if skipSend() then return end
    if result == nil then return end
    local Net = COB.Net
    if Net and Net.SendStubWithdraw then
      pcall(Net.SendStubWithdraw, Net, { id = result })
    end
  end)
  wrapAlways(COB.Decree, "Clear", function()
    local Banner = COB.DecreeBanner
    if type(Banner) == "table" and type(Banner.Refresh) == "function" then
      pcall(Banner.Refresh, Banner)
    end
  end)
  wrapAfter(COB.Store, "Restore", bindLocalCharacter)

  persistWrites(COB.Runtime, {
    "StartEvent", "OpenRite", "CloseRite", "Continue", "EndEvent",
  })
  persistWrites(COB.Gora, {
    "Petition", "PetitionFromSender", "Dismiss", "Sanction", "Propose",
    "RecordFavor", "RecordFavorFromSender",
    "DeclareVictor", "Void", "FreeRuling", "CowardiceRecorded",
  })
  persistWrites(COB.Store, {
    "CreateHuman", "CreateCharacter", "LinkCharacter", "EnsureCharacterByName",
    "SetRank", "SetCouncil", "AddHonorific",
    "TombstoneHuman", "TombstoneCharacter",
    "AppendCeremony", "FlagMoment", "CanonizeMoment",
    "FlagFamousUpset", "RecordGoraResult",
  })
  persistWrites(COB.Nights, {
    "SetSeries", "SkipWeek", "MoveWeek", "WithdrawSeries",
    "SetStub", "WithdrawStub", "ApplyStub", "ApplyTombstone",
    "SetGoing", "SetGoingCounts", "ImportDecree", "Restore", "ApplyBroadcast",
  })

  local Net = COB.Net
  if type(Net) == "table" then
    local origState = Net._HandleState
    if type(origState) == "function" then
      Net._HandleState = function(self, decoded, channel, sender)
        local ok, err = origState(self, decoded, channel, sender)
        if ok then
          stashInboundCast(decoded)
          paintInboundFavor(decoded, sender)
          paintInboundInputs(sender)
          -- Live STATE this session is the other snapshot gate. After a
          -- Restore that left Event Mode the ask no-ops (local not QUIET).
          if type(decoded) == "table" and decoded.state ~= "QUIET" then
            maybeRequestSnapshot()
          end
          -- The card is a sanction beat. CONSEQUENCE hides it (ruling landed);
          -- QUIET hides it (event ended). ASSEMBLY + two fighters shows it.
          -- RITE + two fighters shows only if this event has not already
          -- hidden the card — post-verdict RITE + lastPair must not resurrect
          -- (#111). Self-echo still skips the card branch; favor/inputs paint.
          local selfEcho = type(self.IsSelf) == "function"
            and self:IsSelf(sender) == true
          if not selfEcho then
            if type(decoded) == "table" and decoded.state == "QUIET" then
              hideFighterCard()
              COB._fighterCardDismissed = false
            elseif type(decoded) == "table" and decoded.state == "CONSEQUENCE" then
              hideFighterCard()
              COB._fighterCardDismissed = true
            else
              local fighters = decoded and decoded.subjects and decoded.subjects.fighters
              if type(fighters) == "table" and fighters[1] and fighters[2] then
                if decoded.state == "ASSEMBLY" then
                  COB._fighterCardDismissed = false
                  showFighterCard()
                elseif decoded.state == "RITE" and COB._fighterCardDismissed ~= true then
                  showFighterCard()
                end
              end
            end
          end
        end
        return ok, err
      end
    end

    local origSnap = Net._HandleSnapshot
    if type(origSnap) == "function" then
      Net._HandleSnapshot = function(self, decoded, channel, sender, payload)
        local ok, err = origSnap(self, decoded, channel, sender, payload)
        if ok and decoded and decoded.role == "response" then
          local src = decoded
          if type(payload) == "string" and COB.Codec and COB.Codec.Decode then
            local again = COB.Codec:Decode(payload)
            if type(again) == "table" then
              src = again
            end
          end
          stashInboundCast(src)
          local favor = src and src.favor or decoded.favor
          paintInboundFavor({ favor = favor }, sender)
        end
        return ok, err
      end
    end

    local function refreshNightsSurfaces()
      if COB.Minimap and type(COB.Minimap.RefreshGlow) == "function" then
        pcall(COB.Minimap.RefreshGlow, COB.Minimap)
      end
      if COB.PlayerCard and type(COB.PlayerCard.IsShown) == "function"
          and COB.PlayerCard:IsShown() == true
          and type(COB.PlayerCard.Refresh) == "function" then
        pcall(COB.PlayerCard.Refresh, COB.PlayerCard)
      end
      if COB.DecreeBanner and type(COB.DecreeBanner.IsShown) == "function"
          and COB.DecreeBanner:IsShown() == true
          and type(COB.DecreeBanner.Refresh) == "function" then
        pcall(COB.DecreeBanner.Refresh, COB.DecreeBanner)
      end
    end
    local nightsHandlers = { "_HandleNights", "_HandleStub", "_HandleStubWithdraw", "_HandleGoing" }
    for i = 1, #nightsHandlers do
      local name = nightsHandlers[i]
      local orig = Net[name]
      if type(orig) == "function" then
        Net[name] = function(self, ...)
          local ok, err = orig(self, ...)
          if ok then refreshNightsSurfaces() end
          return ok, err
        end
      end
    end
  end

  bindLocalCharacter()

  -- A guildmate HELLO may be a late joiner: the Pope's client re-broadcasts
  -- live state over the same send-state path the other glue wrappers use.
  -- No-op on a congregation client or in QUIET. No UI refresh, toast, or
  -- sound. Net pcalls this; missing pieces return quietly.
  COB._OnPeerHello = function(sender)
    -- Congregation catch-up: accepted Pope HELLO + still QUIET → one ask.
    if COB.Sender and type(COB.Sender.IsRegisteredPope) == "function"
        and COB.Sender:IsRegisteredPope(sender) == true then
      maybeRequestSnapshot()
    end
    if not (COB.Runtime and COB.Runtime.Snapshot) then return end
    local snap = COB.Runtime:Snapshot()
    if type(snap) ~= "table" then return end
    if type(snap.state) ~= "string" or snap.state == "QUIET" then return end
    if not (COB.Sender and type(COB.Sender.IsRegisteredPope) == "function") then return end
    if type(UnitName) ~= "function" then return end
    if COB.Sender:IsRegisteredPope(UnitName("player")) ~= true then return end
    sendState()
  end
  return true
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")

frame:SetScript("OnEvent", function(_, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "ChurchOfBeef" then
    COB:OnLoad()
  elseif event == "PLAYER_LOGIN" then
    COB:OnLogin()
  elseif event == "PLAYER_LOGOUT" then
    COB:OnLogout()
  end
end)

SLASH_CHURCHOFBEEF1 = "/beef"
-- Subcommands: minimap, help, gora (the sanctioned-record ledger), console
-- (listed Pope only — do not advertise the desk to congregation). Bare
-- /beef toggles the player card. Unknown arguments print help; they do
-- not toggle the card (Wave 2 Task 3).
local function slashHelp()
  if not (DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage) then return end
  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: The bull or /beef opens your name. When the gathering starts, Ask to fight; when two names appear on the fight bar, pick a side.")
  local me = type(UnitName) == "function" and UnitName("player") or nil
  if COB.Sender and type(COB.Sender.CanWriteStub) == "function"
      and COB.Sender:CanWriteStub(me) == true then
    DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: The desk is /beef console. /beef start begins a gathering; /beef end stops it.")
  end
end

SlashCmdList["CHURCHOFBEEF"] = function(msg)
  local argument = type(msg) == "string" and string.lower((string.gsub(msg, "%s", ""))) or ""

  if argument == "minimap" then
    local minimap = COB.Minimap
    if not (minimap and minimap.SetShown) then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: minimap button not ready yet.")
      return
    end
    local show = not minimap:IsShown()
    minimap:SetShown(show)
    if show then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: minimap button shown.")
    else
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: minimap button hidden — /beef minimap brings it back.")
    end
    return
  end

  if argument == "help" then
    slashHelp()
    return
  end

  if argument == "gora" then
    local card = COB.PlayerCard
    if card and card.ShowGora then
      card:ShowGora()
      return
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: player card not ready yet. (" .. COB.VERSION .. ")")
    return
  end

  if argument == "console" then
    local console = COB.Console
    if not (console and console.Show) then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: desk not ready yet.")
      return
    end
    console:Show()
    return
  end

  local me = type(UnitName) == "function" and UnitName("player") or nil
  local isPope = COB.Sender and type(COB.Sender.IsRegisteredPope) == "function"
    and COB.Sender:IsRegisteredPope(me) == true

  if argument == "start" then
    if not isPope then
      slashHelp()
      return
    end
    local console = COB.Console
    if not (console and console.StartEvent) then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: desk not ready yet.")
      return
    end
    local ok, err = console:StartEvent()
    if ok == nil and type(err) == "string" then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: " .. err)
    elseif DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: Gathering started.")
    end
    if console.Show then console:Show() end
    return
  end

  if argument == "end" then
    if not isPope then
      slashHelp()
      return
    end
    local console = COB.Console
    if not (console and console.ForceEndGathering) then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: desk not ready yet.")
      return
    end
    local ok, err = console:ForceEndGathering()
    if ok == nil and type(err) == "string" then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: " .. err)
    elseif DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: Gathering ended.")
    end
    if console.Show then console:Show() end
    return
  end

  if argument ~= "" then
    slashHelp()
    return
  end

  -- Bare /beef toggles the player card (Bible §12.5, §14.2).
  local card = COB.PlayerCard
  if card and card.Toggle then
    card:Toggle()
    return
  end
  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: player card not ready yet. (" .. COB.VERSION .. ")")
end

-- Owner inspection only. Not a slash. Does not write Store Gora rows.
-- Sets a Decree (persists) and opens the built surfaces so they can be
-- seen. Runtime is returned to QUIET. Rituals stay fail-closed unless
-- the local character is listed (Data/Popes.lua or popeOverrides).
function COB:InspectProgress()
  COB._inspecting = true
  local ok, err = pcall(function()
    if COB.Decree and COB.Decree.Set then
      COB.Decree:Set({
        line = "Goldshire Inn — Sunday, 7:00 PM",
        flavor = "The Gathering.",
      })
    end
    if COB.DecreeBanner and COB.DecreeBanner.Show then
      COB.DecreeBanner:Show()
    end
    if COB.PlayerCard and COB.PlayerCard.Show then
      COB.PlayerCard:Show()
    end
    if COB.Console and COB.Console.Show then
      COB.Console:Show()
    end
    if COB.Runtime and COB.Runtime.StartEvent then
      COB.Runtime:StartEvent()
      if COB.Sound and COB.Sound.Play then
        COB.Sound:Play("sanction")
      end
      if COB.Runtime.EndEvent then
        COB.Runtime:EndEvent()
      end
    end
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
      local me = type(UnitName) == "function" and UnitName("player") or nil
      local listed = COB.Sender
        and type(COB.Sender.IsRegisteredPope) == "function"
        and COB.Sender:IsRegisteredPope(me) == true
      local note
      if listed then
        note = "Player card, Decree, and Director Console are open. Rituals are live on this character. Fight HUD needs a sanctioned pair."
      else
        note = "Player card, Decree, and Director Console are open. Rituals refuse on this character — listed Pope is Thedave. Fight HUD needs a sanctioned pair."
      end
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: " .. note)
    end
  end)
  COB._inspecting = false
  if not ok then error(err) end
end
