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

-- Display match is by live guild rank title, never by slot number.
assert_eq(type(R.IdForTitle), "function", "IdForTitle exists")
for i, title in ipairs(TITLES) do
  assert_eq(R.IdForTitle(title), i, "IdForTitle(" .. title .. ")")
  assert_eq(R.IdForTitle(string.lower(title)), i, "IdForTitle folds case for " .. title)
end
assert_eq(R.IdForTitle("  Beef Knight  "), 3, "IdForTitle trims")
assert_eq(R.IdForTitle("Guild Master"), nil, "Guild Master is not a Church rank")
assert_eq(R.IdForTitle("Beef Pope"), nil, "the Pope is not a rank")
assert_eq(R.IdForTitle("Beef Prophet"), nil, "the retired seventh rung is not a rank")
assert_eq(R.IdForTitle("Officer"), nil, "Officer is not a Church rank")
assert_eq(R.IdForTitle("Beef  Knight"), nil, "internal spacing does not match")
assert_eq(R.IdForTitle(""), nil, "empty title is not a rank")
assert_eq(R.IdForTitle(nil), nil, "nil title is not a rank")
assert_eq(R.IdForTitle(3), nil, "numeric title is not a rank")

-- Bible §5: each rank is a kind of relationship with the Church, not a rung.
-- The player card paints this line under the rank; it never invents rank copy.
local RELATIONSHIPS = {
  "Recruitment",
  "Engagement",
  "Belonging",
  "Proven prestige",
  "The Raiding Team",
  "Trusted leadership",
}

assert_eq(type(R.Relationship), "function", "Relationship(id) exists")
for i, line in ipairs(RELATIONSHIPS) do
  assert_eq(R.List[i].relationship, line, "rank " .. i .. " relationship (Bible §5)")
  assert_eq(R.Relationship(i), line, "Relationship(" .. i .. ")")
end
assert_eq(R.Relationship(7), nil, "Relationship of a non-rank is nil")
assert_eq(R.Relationship(nil), nil, "Relationship(nil) is nil")
assert_eq(R.NextRank, nil, "no next-rank helper — ranks are not a ladder")
assert_eq(R.Progress, nil, "no progress helper")
