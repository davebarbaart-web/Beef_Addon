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
  if COB.Sync and COB.Sync.OnLogin then
    COB.Sync:OnLogin()
  end
  if COB.Instance and COB.Instance.Init then
    COB.Instance:Init()
  end
end

function COB:OnLogout()
  if COB.DB and COB.DB.Save then
    COB.DB:Save()
  end
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
-- No subcommands in V1, debug included: arguments are ignored rather than parsed so
-- there is no verbose or force-send path shipping to a guild. In-game forging for
-- checklist box 9 goes through /run and the public Net:Send.
SlashCmdList["CHURCHOFBEEF"] = function()
  if COB.UI and COB.UI.Toggle then
    COB.UI:Toggle()
    return
  end
  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: UI not ready yet. (" .. COB.VERSION .. ")")
end
