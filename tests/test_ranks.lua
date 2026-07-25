-- Load ranks the same way the addon will: as a chunk setting COB.Ranks
ChurchOfBeef = ChurchOfBeef or {}
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
local R = ChurchOfBeef.Ranks

assert_eq(#R.List, 7, "seven ranks")
assert_eq(R.List[1].title, "Fresh Beef", "rank 1 title")
assert_eq(R.List[7].title, "Beef Prophet", "rank 7 title")
assert_eq(R.Threshold(2), 50, "Cooked Beef threshold")
assert_true(R.IsPointDriven(5), "Butcher point-driven")
assert_eq(R.IsPointDriven(6), false, "Council not point-driven")
assert_eq(R.IsPointDriven(7), false, "Prophet not point-driven")
assert_eq(R.CouncilSeats, 4, "default council seats")
assert_eq(R.ProphetUnique, true, "prophet unique")
assert_eq(R.OfficerRankIndexMax, 1, "GM + top officer")
