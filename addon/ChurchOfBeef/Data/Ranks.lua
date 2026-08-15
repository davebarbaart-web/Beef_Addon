ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Bible §5 / Law 9. Six ranks, ids 1–6. No thresholds. No Beef Prophet.
-- The Pope is not a rank. Ranks are relationships, not a linear ladder.
local LIST = {
  { id = 1, title = "Fresh Beef" },
  { id = 2, title = "Cooked Beef" },
  { id = 3, title = "Beef Knight" },
  { id = 4, title = "Beef Lord" },
  -- Raid-team role designation; display-only this phase (Bible §5).
  { id = 5, title = "Beef Butcher" },
  { id = 6, title = "Beef Council" },
}

local BY_ID = {}
for _, r in ipairs(LIST) do BY_ID[r.id] = r end

-- Guild rank index is public display only. Church store is truth (Bible §5).
-- No roster-index → Church-rank map. Do not treat GM as a Church rank.
local function churchRankIdForGuildIndex(_rankIndex)
  return nil
end

COB.Ranks = {
  List = LIST,
  ById = BY_ID,
  Title = function(id)
    local r = BY_ID[id]
    return r and r.title or "Unknown"
  end,
  ChurchRankIdForGuildIndex = churchRankIdForGuildIndex,
}
