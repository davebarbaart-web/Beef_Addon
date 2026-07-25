-- Minimal stubs so Core modules can load under desktop Lua.
CreateFrame = CreateFrame or function()
  return {
    RegisterEvent = function() end,
    SetScript = function() end,
    Hide = function() end,
    Show = function() end,
  }
end
DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or { AddMessage = function(_, m) print(m) end }
SlashCmdList = SlashCmdList or {}
time = time or function() return 0 end
