-- Common is loaded by the harness (and by the U-A standalone runner) before this
-- file is require()'d. Do not dofile it here.
local Common = ChurchOfBeef.Common

assert_true(Common ~= nil, "COB.Common exists")
assert_true(type(Common.RomanNumeral) == "function", "RomanNumeral is a function")
assert_true(type(Common.RomanPair) == "function", "RomanPair is a function")
assert_true(ChurchOfBeef.Names ~= nil, "Names primitive remains attached")
assert_true(ChurchOfBeef.Clock ~= nil, "Clock primitive remains attached")
assert_true(ChurchOfBeef.Group ~= nil, "Group primitive remains attached")

local cases = {
  { 1, "I" },
  { 4, "IV" },
  { 5, "V" },
  { 9, "IX" },
  { 14, "XIV" },
  { 40, "XL" },
  { 90, "XC" },
  { 400, "CD" },
  { 900, "CM" },
  { 1999, "MCMXCIX" },
  { 3999, "MMMCMXCIX" },
}

for i = 1, #cases do
  local n, want = cases[i][1], cases[i][2]
  assert_eq(Common.RomanNumeral(n), want, "RomanNumeral(" .. n .. ")")
end

local function assert_oor(n, label)
  local val, err = Common.RomanNumeral(n)
  assert_eq(val, nil, label .. " is nil")
  assert_eq(err, "out of range", label .. " err")
end

assert_oor(0, "0")
assert_oor(4000, "4000")
assert_oor(-3, "-3")
assert_oor(2.5, "2.5")
assert_oor("XII", '"XII"')
assert_oor(nil, "nil")

local EN_DASH = "\226\128\147"
assert_eq(Common.RomanPair(18, 6), "XVIII" .. EN_DASH .. "VI", "RomanPair(18,6)")
assert_eq(Common.RomanPair(1, 1), "I" .. EN_DASH .. "I", "RomanPair(1,1)")

local pair = Common.RomanPair(18, 6)
assert_eq(pair:byte(6), 226, "en dash byte 1")
assert_eq(pair:byte(7), 128, "en dash byte 2")
assert_eq(pair:byte(8), 147, "en dash byte 3")

local function assert_pair_oor(a, b, label)
  local val, err = Common.RomanPair(a, b)
  assert_eq(val, nil, label .. " is nil")
  assert_eq(err, "out of range", label .. " err")
end

assert_pair_oor(0, 6, "RomanPair left invalid")
assert_pair_oor(18, 4000, "RomanPair right invalid")
assert_pair_oor(2.5, 1, "RomanPair fractional left")
