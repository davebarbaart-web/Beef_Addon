ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Designated Council characters for Discord-stub senders only
-- (Bible §14.1 / nights-board spec). Add Names.Key spellings.
-- Local override is ChurchOfBeefDB.ui.councilOverrides (array of name strings)
-- via /run — no settings panel. This file never reads SavedVariables.
-- Empty list: only a registered Pope may post stubs until names are added.
-- Not ritual authority. Not a settings panel. Rest of OQ #8 stays open.
local LIST = {}

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

COB.Council = {
  List = LIST,
  IsListed = isListed,
}
