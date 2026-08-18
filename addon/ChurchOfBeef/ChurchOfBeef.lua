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

function COB:OnLogin()
  if COB.UI and COB.UI.Init then
    COB.UI:Init()
  end
  if COB.Net and COB.Net.Init then
    COB.Net:Init()
  end
  self:InstallWire()
end

function COB:OnLogout()
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
  return fields
end

local function sendState()
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

local function hideInputsAndDock()
  if COB.Inputs and type(COB.Inputs.Hide) == "function" then
    pcall(COB.Inputs.Hide, COB.Inputs)
  end
  if COB.ConsoleDock and type(COB.ConsoleDock.Hide) == "function" then
    pcall(COB.ConsoleDock.Hide, COB.ConsoleDock)
  end
end

local function refreshEventFurniture()
  if skipSend() then return end
  if COB.Inputs and type(COB.Inputs.Refresh) == "function" then
    pcall(COB.Inputs.Refresh, COB.Inputs)
  end
  if COB.ConsoleDock and type(COB.ConsoleDock.Refresh) == "function" then
    pcall(COB.ConsoleDock.Refresh, COB.ConsoleDock)
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
    hideInputsAndDock()
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
  if COB.ConsoleDock and type(COB.ConsoleDock.Refresh) == "function" then
    pcall(COB.ConsoleDock.Refresh, COB.ConsoleDock)
  end
end

local function bindSlashInputTarget()
  local Inputs = COB.Inputs
  if not (Inputs and Inputs.SetInputTarget) then return end
  if type(UnitName) ~= "function" then return end
  local target = UnitName("target")
  if type(target) == "string" and target ~= "" then
    pcall(Inputs.SetInputTarget, Inputs, target)
  end
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
  if type(Markers.Target) == "function" then
    pcall(Markers.Target, Markers, name)
  end
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
  wrapAfter(COB.Runtime, "CloseRite", sendState)
  wrapAfter(COB.Runtime, "Continue", afterRuntime)
  wrapAfter(COB.Runtime, "EndEvent", afterEndEvent)
  wrapAfter(COB.Gora, "RecordFavor", sendState)
  wrapAfter(COB.Gora, "Sanction", function(_, result)
    if type(result) ~= "table" then return end
    local fields = {}
    local a = characterName(result.fighterA)
    if a then fields.fighterA = a end
    local b = characterName(result.fighterB)
    if b then fields.fighterB = b end
    if result.stipulation ~= nil then
      fields.stipulation = result.stipulation
    end
    proclaim("sanction", fields)
    showFighterCard()
    markFighters(a, b)
    sendState()
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
    sendState()
  end)
  wrapAfter(COB.Gora, "Void", function()
    proclaim("verdict", { ruling = "void" })
    sendState()
  end)
  wrapAfter(COB.Gora, "FreeRuling", function(_, result)
    local fields = { ruling = "free" }
    if type(result) == "table" and result.text ~= nil then
      fields.text = result.text
    end
    proclaim("verdict", fields)
    sendState()
  end)
  wrapAfter(COB.Gora, "CowardiceRecorded", function(_, result)
    local fields = {}
    if type(result) == "table" then
      local name = characterName(result.fleerId)
      if name then fields.name = name end
    end
    proclaim("cowardice", fields)
    sendState()
  end)
  wrapAfter(COB.Console, "SetCongregationFavorVisible", sendState)
  wrapAfter(COB.Console, "PostDecree", function(_, result)
    sendDecree({ line = result.line, flavor = result.flavor })
  end)
  wrapAlways(COB.Decree, "Clear", function()
    local Banner = COB.DecreeBanner
    if type(Banner) == "table" and type(Banner.Refresh) == "function" then
      pcall(Banner.Refresh, Banner)
    end
  end)
  wrapAfter(COB.Store, "Restore", bindLocalCharacter)

  local Net = COB.Net
  if type(Net) == "table" then
    local origState = Net._HandleState
    if type(origState) == "function" then
      Net._HandleState = function(self, decoded, channel, sender)
        local ok, err = origState(self, decoded, channel, sender)
        if ok then
          paintInboundFavor(decoded, sender)
          paintInboundInputs(sender)
          if type(decoded) == "table" and decoded.state == "QUIET" then
            hideFighterCard()
          else
            local fighters = decoded and decoded.subjects and decoded.subjects.fighters
            if type(fighters) == "table" and fighters[1] and fighters[2] then
              showFighterCard()
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
          local favor = decoded.favor
          if favor == nil and type(payload) == "string" and COB.Codec and COB.Codec.Decode then
            local again = COB.Codec:Decode(payload)
            if type(again) == "table" then
              favor = again.favor
            end
          end
          paintInboundFavor({ favor = favor }, sender)
        end
        return ok, err
      end
    end
  end

  bindLocalCharacter()
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
-- Subcommands: minimap (restore the hideable button), console (player-opened
-- Director Console — Bible §18 names the tool, not the slash; OPEN_QUESTIONS #11),
-- petition / confess / catchup (Event congregation inputs; whisper target is
-- UnitName("target") — no Pope-name lookup).
-- Unrecognised arguments open the Records Book. No verbose/debug guild noise.
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

  if argument == "console" then
    local console = COB.Console
    if not (console and console.Show) then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: Director Console not ready yet.")
      return
    end
    console:Show()
    return
  end

  if argument == "petition" then
    local inputs = COB.Inputs
    if not (inputs and inputs.Petition) then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: inputs not ready yet.")
      return
    end
    bindSlashInputTarget()
    pcall(inputs.Petition, inputs)
    return
  end

  if argument == "confess" then
    local inputs = COB.Inputs
    if not (inputs and inputs.Show) then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: inputs not ready yet.")
      return
    end
    bindSlashInputTarget()
    pcall(inputs.Show, inputs)
    return
  end

  if argument == "catchup" then
    local inputs = COB.Inputs
    if not (inputs and inputs.Catchup) then
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: inputs not ready yet.")
      return
    end
    bindSlashInputTarget()
    pcall(inputs.Catchup, inputs)
    return
  end

  if COB.UI and COB.UI.Toggle then
    COB.UI:Toggle()
    return
  end
  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: UI not ready yet. (" .. COB.VERSION .. ")")
end

-- Owner inspection only. Not a slash. Not #8. Does not write Store Gora
-- rows. Sets a Decree (persists) and opens the built surfaces so they can
-- be seen. Runtime is returned to QUIET. Rituals stay fail-closed.
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
    if COB.RecordsBook and COB.RecordsBook.Show then
      COB.RecordsBook:Show()
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
      DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: Records Book, Decree, and Director Console are open. Buttons still refuse — no registered Pope. Fight HUD needs a sanctioned pair.")
    end
  end)
  COB._inspecting = false
  if not ok then error(err) end
end
