-- Officer gate: pure rank-index threshold + injected roster lookup.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
local O = ChurchOfBeef.Officer
local R = ChurchOfBeef.Ranks

--------------------------------------------------------------------------------
-- Plan brief
--------------------------------------------------------------------------------
assert_eq(O:IsOfficerIndex(0), true, "GM")
assert_eq(O:IsOfficerIndex(1), true, "officer")
assert_eq(O:IsOfficerIndex(2), false, "member")

local function roster(name)
  if name == "Pope" then return 0 end
  if name == "Cardinal" then return 1 end
  if name == "Pleb" then return 4 end
  return nil
end
assert_eq(O:IsOfficerName("Pope", roster), true, "pope")
assert_eq(O:IsOfficerName("Pleb", roster), false, "pleb")
assert_eq(O:IsOfficerName("Ghost", roster), false, "missing")
assert_eq(O:IsOfficerName("Cardinal", roster), true, "cardinal")

--------------------------------------------------------------------------------
-- Fail closed: nil / bad index, missing roster, bad lookup
--------------------------------------------------------------------------------
assert_eq(O:IsOfficerIndex(nil), false, "nil rank fails closed")
assert_eq(O:IsOfficerIndex("0"), false, "string rank fails closed")
assert_eq(O:IsOfficerIndex(true), false, "bool rank fails closed")
assert_eq(O:IsOfficerName(nil, roster), false, "nil name fails closed")
assert_eq(O:IsOfficerName("", roster), false, "empty name fails closed")
assert_eq(O:IsOfficerName("Pope", nil), false, "nil rosterLookup fails closed")
assert_eq(O:IsOfficerName("Pope", "not a function"), false, "bad rosterLookup fails closed")

assert_eq(R.OfficerRankIndexMax, 1, "canon default OfficerRankIndexMax is 1")
assert_eq(O:IsOfficerIndex(R.OfficerRankIndexMax), true, "max index is officer")
assert_eq(O:IsOfficerIndex(R.OfficerRankIndexMax + 1), false, "past max is not officer")

--------------------------------------------------------------------------------
-- LocalIsOfficer: fail closed until GetGuildInfo yields a ready rank index
--------------------------------------------------------------------------------
local savedGetGuildInfo = GetGuildInfo

GetGuildInfo = nil
assert_eq(O:LocalIsOfficer(), false, "no GetGuildInfo fails closed")

GetGuildInfo = function() return nil end
assert_eq(O:LocalIsOfficer(), false, "nil guild info fails closed")

GetGuildInfo = function() return "Church", "Member", nil end
assert_eq(O:LocalIsOfficer(), false, "nil local rankIndex fails closed")

GetGuildInfo = function() return "Church", "Member", 4 end
assert_eq(O:LocalIsOfficer(), false, "member local rank is not officer")

GetGuildInfo = function() return "Church", "Officer", 1 end
assert_eq(O:LocalIsOfficer(), true, "officer local rank passes")

GetGuildInfo = function() return "Church", "GM", 0 end
assert_eq(O:LocalIsOfficer(), true, "GM local rank passes")

GetGuildInfo = savedGetGuildInfo
