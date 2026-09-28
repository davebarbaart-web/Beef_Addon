ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Registered-Pope sender predicate (Bible §13.4, Law 5).
-- Workspace list: Data/Popes.lua (COB.Popes.List). Local override:
-- ChurchOfBeefDB.ui.popeOverrides via /run — no settings panel.
-- Data never reads SV. Sender reads the override.
-- When COB.Popes is not loaded, the workspace list is empty; only the
-- override can return true. Council stub senders: Data/Council.lua plus
-- ChurchOfBeefDB.ui.councilOverrides. Do not read guild rank, GM, Officer,
-- or a sender named "Pope". No Register / Set / Load / config UX.
local Sender = {}
COB.Sender = Sender

local function senderKey(sender)
  if type(sender) ~= "string" then
    return nil
  end
  if not (COB.Names and COB.Names.Key) then
    return nil
  end
  return COB.Names.Key(sender)
end

local function overrideHas(key)
  if not key then
    return false
  end
  if type(ChurchOfBeefDB) ~= "table" then
    return false
  end
  local ui = ChurchOfBeefDB.ui
  if type(ui) ~= "table" then
    return false
  end
  local overrides = ui.popeOverrides
  if type(overrides) ~= "table" then
    return false
  end
  if not (COB.Names and COB.Names.Key) then
    return false
  end
  for i = 1, #overrides do
    if COB.Names.Key(overrides[i]) == key then
      return true
    end
  end
  return false
end

function Sender:IsRegisteredPope(sender)
  local key = senderKey(sender)
  if not key then
    return false
  end
  if COB.Popes and type(COB.Popes.IsListed) == "function" and COB.Popes.IsListed(sender) then
    return true
  end
  return overrideHas(key)
end

local function councilOverrideHas(key)
  if not key then
    return false
  end
  if type(ChurchOfBeefDB) ~= "table" then
    return false
  end
  local ui = ChurchOfBeefDB.ui
  if type(ui) ~= "table" then
    return false
  end
  local overrides = ui.councilOverrides
  if type(overrides) ~= "table" then
    return false
  end
  if not (COB.Names and COB.Names.Key) then
    return false
  end
  for i = 1, #overrides do
    if COB.Names.Key(overrides[i]) == key then
      return true
    end
  end
  return false
end

function Sender:IsListedCouncil(sender)
  local key = senderKey(sender)
  if not key then
    return false
  end
  if COB.Council and type(COB.Council.IsListed) == "function" and COB.Council.IsListed(sender) then
    return true
  end
  return councilOverrideHas(key)
end

function Sender:CanWriteStub(sender)
  return self:IsRegisteredPope(sender) or self:IsListedCouncil(sender)
end

local function senderPresent(sender)
  if COB.Names and COB.Names.Trim then
    return COB.Names.Trim(sender) ~= nil
  end
  return type(sender) == "string" and sender ~= ""
end

function Sender:Accept(sender, kind)
  if kind == "INPUT" then
    return senderPresent(sender)
  end
  if kind == "STATE" or kind == "SNAPSHOT" or kind == "NIGHTS" or kind == "DECREE" then
    return self:IsRegisteredPope(sender)
  end
  if kind == "STUB" or kind == "STUB_WITHDRAW" then
    return self:CanWriteStub(sender)
  end
  return false
end
