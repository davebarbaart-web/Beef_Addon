ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- KNIGHT THIS BEEF and Lord elevation (Bible §8, §10.4). Church record only.
-- Guild-rank promotion, queue, targeting, and theater are later Console.
-- Core never calls GuildPromote / SetGuildRank.
local Knighting = {}
COB.Knighting = Knighting

local KNIGHT_ID = 3
local LORD_ID = 4

local function store()
  local Store = COB.Store
  if not Store or not Store.SetRank or not Store.GetHuman then
    return nil, "store is not available"
  end
  return Store
end

local function knownHuman(Store, humanId)
  local human, err = Store:GetHuman(humanId)
  if not human then return nil, err or "unknown human" end
  return human
end

function Knighting:KnightThisBeef(humanId, now)
  local Store, storeErr = store()
  if not Store then return nil, storeErr end
  local human, err = knownHuman(Store, humanId)
  if not human then return nil, err end
  return Store:SetRank(humanId, KNIGHT_ID, now)
end

function Knighting:ElevateToLord(humanId, now)
  local Store, storeErr = store()
  if not Store then return nil, storeErr end
  local human, err = knownHuman(Store, humanId)
  if not human then return nil, err end
  return Store:SetRank(humanId, LORD_ID, now)
end
