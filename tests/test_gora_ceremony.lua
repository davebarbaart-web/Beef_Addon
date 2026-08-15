-- Pair-key challenge notes only. Points, Grant, Ladder rite flags, and the
-- ceremony attendance-credit ledger are excised (Audit V4 / V5).
ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true
dofile("addon/ChurchOfBeef/Core/Gora.lua")

local Gora = ChurchOfBeef.Gora

local function reset()
  Gora:ResetForTests()
end

reset()

--------------------------------------------------------------------------------
-- Pair key: one challenge per pair, direction does not matter
--------------------------------------------------------------------------------
local challenge = Gora:Challenge("Steakina", "Beefina", 100)
assert_true(challenge ~= nil, "a challenge is opened")
assert_eq(challenge.challenger, "Beefina", "the challenger is recorded")
assert_eq(challenge.target, "Steakina", "the target is recorded")
assert_eq(Gora:IsChallenged("Beefina", "Steakina"), true, "the pair is challenged")
assert_eq(Gora:IsChallenged("Steakina", "Beefina"), true, "direction does not matter")
assert_eq(#Gora:GetPending(100), 1, "one challenge is pending")

assert_eq(select(1, Gora:Challenge("Beefina", "Beefina")), nil, "nobody challenges themselves")
assert_eq(select(1, Gora:Challenge("", "Beefina")), nil, "an empty target is refused")

Gora:Cancel("Steakina", "Beefina")
assert_eq(Gora:IsChallenged("Beefina", "Steakina"), false, "cancel clears the pair")

Gora:Challenge("Steakina", "Beefina", 200)
assert_eq(Gora:Cancel("Steakina", "Beefina"), true, "a challenge can be withdrawn")
assert_eq(Gora:Cancel("Steakina", "Beefina"), false, "withdrawing twice is a no-op")

--------------------------------------------------------------------------------
-- Pair key: case and realm fold to the same pair
--------------------------------------------------------------------------------
reset()
assert_true(Gora:Challenge("Steakina-Whitemane", "Beefina", 100) ~= nil,
  "a realm-suffixed target still opens")
assert_eq(Gora:IsChallenged("beefina", "steakina"), true, "pair key ignores case and realm")
assert_eq(Gora:IsChallenged("STEAKINA", "Beefina-Whitemane"), true,
  "the reverse spelling is the same pair")
assert_eq(#Gora:GetPending(100), 1, "folded spellings do not open a second note")

--------------------------------------------------------------------------------
-- Pair key: stale notes expire
--------------------------------------------------------------------------------
reset()
Gora:Challenge("Steakina", "Beefina", 300)
assert_eq(#Gora:GetPending(300), 1, "the challenge is live inside its window")
assert_eq(#Gora:GetPending(300 + 3600), 0, "a stale challenge expires")
