-- Load ranks the same way the addon will: as a chunk setting COB.Ranks
ChurchOfBeef = ChurchOfBeef or {}
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
local R = ChurchOfBeef.Ranks

local TITLES = {
  "Fresh Beef",
  "Cooked Beef",
  "Beef Knight",
  "Beef Lord",
  "Beef Butcher",
  "Beef Council",
  "Beef Prophet",
}

assert_eq(#R.List, 7, "seven ranks")
for i, title in ipairs(TITLES) do
  assert_eq(R.List[i].title, title, "rank " .. i .. " title")
  assert_eq(R.List[i].id, i, "rank " .. i .. " id matches position")
  assert_eq(R.ById[i], R.List[i], "ById[" .. i .. "] matches List entry")
end

local THRESHOLDS = { 0, 50, 200, 500, 1000 }
for i, threshold in ipairs(THRESHOLDS) do
  assert_eq(R.List[i].threshold, threshold, "rank " .. i .. " threshold field")
  assert_eq(R.Threshold(i), threshold, "Threshold(" .. i .. ")")
end

-- Threshold(1) is 0, which is falsy in most languages but truthy in Lua;
-- assert explicitly so a `and/or` regression cannot slip through as nil.
assert_eq(R.Threshold(1), 0, "Threshold(1) is 0, not nil")
assert_eq(R.List[6].threshold, nil, "Council has no threshold")
assert_eq(R.List[7].threshold, nil, "Prophet has no threshold")
assert_eq(R.Threshold(6), nil, "Threshold(6) nil")
assert_eq(R.Threshold(7), nil, "Threshold(7) nil")

assert_eq(R.Title(2), "Cooked Beef", "Title(2)")
assert_eq(R.Title(99), "Unknown", "Title of unknown id")

assert_true(R.IsPointDriven(5), "Butcher point-driven")
assert_eq(R.IsPointDriven(6), false, "Council not point-driven")
assert_eq(R.IsPointDriven(7), false, "Prophet not point-driven")
assert_eq(R.CouncilSeats, 4, "default council seats")
assert_eq(R.ProphetUnique, true, "prophet unique")
assert_eq(R.OfficerRankIndexMax, 1, "GM + top officer")
assert_eq(R.ChurchRankIdForGuildIndex(0), 7, "guild 0 → Prophet")
assert_eq(R.ChurchRankIdForGuildIndex(6), 1, "guild 6 → Fresh Beef")

assert_eq(R.NeedsRite(2), nil, "Cooked has no rite checklist")
assert_eq(R.NeedsRite(3), "knighted", "Knight expects knighting rite")
assert_eq(R.NeedsRite(4), "goraLordWin", "Lord expects Gora win vs Lord")
assert_eq(R.NeedsRite(5), nil, "Butcher has no rite checklist")
