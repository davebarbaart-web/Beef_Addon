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
}

assert_eq(#R.List, 6, "six ranks")
assert_eq(R.List[7], nil, "no seventh rank")
assert_eq(R.ById[7], nil, "ById has no id 7")

for i, title in ipairs(TITLES) do
  assert_eq(R.List[i].title, title, "rank " .. i .. " title")
  assert_eq(R.List[i].id, i, "rank " .. i .. " id matches position")
  assert_eq(R.ById[i], R.List[i], "ById[" .. i .. "] matches List entry")
  assert_eq(R.List[i].threshold, nil, "rank " .. i .. " has no threshold")
  assert_eq(R.List[i].kind, nil, "rank " .. i .. " has no kind")
end

assert_eq(R.Title(1), "Fresh Beef", "Title(1)")
assert_eq(R.Title(2), "Cooked Beef", "Title(2)")
assert_eq(R.Title(5), "Beef Butcher", "Title(5)")
assert_eq(R.Title(6), "Beef Council", "Title(6)")
assert_eq(R.Title(7), "Unknown", "Title(7) is not a rank")
assert_eq(R.Title(99), "Unknown", "Title of unknown id")

assert_eq(R.Threshold, nil, "no Threshold")
assert_eq(R.IsPointDriven, nil, "no IsPointDriven")
assert_eq(R.NeedsRite, nil, "no NeedsRite")
assert_eq(R.ProphetUnique, nil, "no ProphetUnique")
assert_eq(R.OfficerRankIndexMax, nil, "no OfficerRankIndexMax")
assert_eq(R.CouncilSeats, nil, "no CouncilSeats")

assert_eq(R.ChurchRankIdForGuildIndex(0), nil, "guild 0 is not a Church rank")
assert_eq(R.ChurchRankIdForGuildIndex(1), nil, "guild 1 is not a Church rank")
assert_eq(R.ChurchRankIdForGuildIndex(6), nil, "guild 6 is not a Church rank")
assert_eq(R.ChurchRankIdForGuildIndex(nil), nil, "nil index maps to nil")
