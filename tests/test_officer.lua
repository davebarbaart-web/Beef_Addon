-- Officer authority is a Phase 1 fail-closed stub. Phase 4 owns registered-Pope / Council.
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/Core/Officer.lua")
local O = ChurchOfBeef.Officer

--------------------------------------------------------------------------------
-- Authority APIs always refuse
--------------------------------------------------------------------------------
assert_eq(O:IsOfficerIndex(0), false, "GM index is not authority")
assert_eq(O:IsOfficerIndex(1), false, "officer index is not authority")
assert_eq(O:IsOfficerIndex(2), false, "member index is not authority")
assert_eq(O:IsOfficerIndex(nil), false, "nil index is not authority")
assert_eq(O:IsOfficerIndex("0"), false, "string index is not authority")
assert_eq(O:IsOfficerIndex(true), false, "bool index is not authority")

local function roster(name)
  if name == "Pope" then return 0 end
  if name == "Cardinal" then return 1 end
  if name == "Pleb" then return 4 end
  return nil
end
assert_eq(O:IsOfficerName("Pope", roster), false, "pope name is not authority")
assert_eq(O:IsOfficerName("Cardinal", roster), false, "cardinal name is not authority")
assert_eq(O:IsOfficerName("Pleb", roster), false, "pleb name is not authority")
assert_eq(O:IsOfficerName("Ghost", roster), false, "missing name is not authority")
assert_eq(O:IsOfficerName(nil, roster), false, "nil name is not authority")
assert_eq(O:IsOfficerName("", roster), false, "empty name is not authority")
assert_eq(O:IsOfficerName("Pope", nil), false, "nil lookup is not authority")
assert_eq(O:IsOfficerName("Pope", "not a function"), false, "bad lookup is not authority")

assert_eq(O.OfficerRankIndexMax, nil, "stub has no OfficerRankIndexMax")
assert_eq(O.IsProphet, nil, "stub has no Prophet gate")

--------------------------------------------------------------------------------
-- LocalIsOfficer always false, even when GetGuildInfo would have said GM
--------------------------------------------------------------------------------
local savedGetGuildInfo = GetGuildInfo

GetGuildInfo = nil
assert_eq(O:LocalIsOfficer(), false, "no GetGuildInfo is not authority")

GetGuildInfo = function() return "Church", "Member", 4 end
assert_eq(O:LocalIsOfficer(), false, "member local rank is not authority")

GetGuildInfo = function() return "Church", "Officer", 1 end
assert_eq(O:LocalIsOfficer(), false, "officer local rank is not authority")

GetGuildInfo = function() return "Church", "GM", 0 end
assert_eq(O:LocalIsOfficer(), false, "GM local rank is not authority")

GetGuildInfo = savedGetGuildInfo

--------------------------------------------------------------------------------
-- Roster cache may still answer display rank; that is not authority
--------------------------------------------------------------------------------
O:ResetForTests()
O.rosterCache = { pope = 0, pleb = 5 }
local lookup = O:GetRosterLookup()
assert_eq(lookup("Pope"), 0, "cache still answers a display rank index")
assert_eq(O:IsOfficerName("Pope", lookup), false, "cached GM is still not authority")

O.rosterCache = { pope = 5, pleb = 5 }
assert_eq(lookup("Pope"), 5, "a refreshed cache is what the same lookup reads")
assert_eq(O:IsOfficerName("Pope", lookup), false, "a demoted index is still not authority")

O.rosterCache = nil
assert_eq(lookup("Pope"), nil, "a cleared roster answers nothing rather than stale")
O:ResetForTests()

--------------------------------------------------------------------------------
-- IsGuildRosterName is membership sensing, not authority
--------------------------------------------------------------------------------
assert_eq(O:IsGuildRosterName(nil), false, "nil is not a roster member")
assert_eq(O:IsGuildRosterName(""), false, "empty is not a roster member")
