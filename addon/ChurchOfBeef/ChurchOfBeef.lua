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
-- Subcommands: minimap (restore the hideable button) and console (player-opened
-- Director Console — Bible §18 names the tool, not the slash; OPEN_QUESTIONS #11).
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
end
