ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

local LIST = {
  { id = 1, title = "Fresh Beef",   threshold = 0,    kind = "points" },
  { id = 2, title = "Cooked Beef",  threshold = 50,   kind = "points" },
  { id = 3, title = "Beef Knight",  threshold = 200,  kind = "points" },
  { id = 4, title = "Beef Lord",    threshold = 500,  kind = "points" },
  { id = 5, title = "Beef Butcher", threshold = 1000, kind = "points" },
  { id = 6, title = "Beef Council", threshold = nil,  kind = "council" },
  { id = 7, title = "Beef Prophet", threshold = nil,  kind = "prophet" },
}

local BY_ID = {}
for _, r in ipairs(LIST) do BY_ID[r.id] = r end

-- Fixed experiment map (roster-backed ladder amendment): WoW guild rankIndex →
-- Church rank id. Index 0 = Guild Master = Beef Prophet; 6+ collapse to Fresh Beef.
local function churchRankIdForGuildIndex(rankIndex)
  if type(rankIndex) ~= "number" then return nil end
  if rankIndex <= 0 then return 7 end
  if rankIndex == 1 then return 6 end
  if rankIndex == 2 then return 5 end
  if rankIndex == 3 then return 4 end
  if rankIndex == 4 then return 3 end
  if rankIndex == 5 then return 2 end
  return 1
end

-- Expected rite flag for a *target* point-driven rank (eligibility checklist).
-- Missing rite does not block suggestions — officers are coached only.
local function needsRite(toRankId)
  if toRankId == 3 then return "knighted" end
  if toRankId == 4 then return "goraLordWin" end
  return nil
end

COB.Ranks = {
  List = LIST,
  ById = BY_ID,
  CouncilSeats = 4,
  ProphetUnique = true,
  -- Guild rank index 0 = GM, 1 = first officer tier; approve if index <= this.
  OfficerRankIndexMax = 1,
  Threshold = function(id)
    local r = BY_ID[id]
    return r and r.threshold
  end,
  IsPointDriven = function(id)
    local r = BY_ID[id]
    return r and r.kind == "points"
  end,
  Title = function(id)
    local r = BY_ID[id]
    return r and r.title or "Unknown"
  end,
  NeedsRite = needsRite,
  ChurchRankIdForGuildIndex = churchRankIdForGuildIndex,
}
