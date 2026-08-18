ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Registered Pope characters (Bible §13.1, §13.4, Law 5).
-- Add Names.Key spellings of registered Pope characters.
-- Local override is ChurchOfBeefDB.ui.popeOverrides (array of name strings)
-- via /run — no settings panel. This file never reads SavedVariables.
-- The Pope is not a rank. Do not invent a character name here.
local LIST = { "Thedave" }

local function isListed(name)
  if not (COB.Names and COB.Names.Key) then
    return false
  end
  local key = COB.Names.Key(name)
  if not key then
    return false
  end
  for i = 1, #LIST do
    if COB.Names.Key(LIST[i]) == key then
      return true
    end
  end
  return false
end

COB.Popes = {
  List = LIST,
  IsListed = isListed,
}
