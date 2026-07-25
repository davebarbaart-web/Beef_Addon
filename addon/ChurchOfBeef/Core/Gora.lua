ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Thin Beef Gora ledger (spec §7.1). A challenge is a note that two members
-- agreed to fight; a recorded result is the testimony that pays them. Every
-- point leaves through Scoring:GrantGora, so the daily gora cap and the
-- "losses must pay" weighting stay in exactly one place.
local Gora = {
  pending = {},
}
COB.Gora = Gora

-- A challenge nobody ever records is social noise, not state. Expiring and
-- capping the table keeps a night of trash talk from growing without bound.
local CHALLENGE_TTL = 1800
local PENDING_MAX = 20

-- Outcome is stated from the winner's side, which is why the first name is the
-- winner: "loss" is deliberately not accepted, because silently swapping two
-- named parameters is how the wrong member ends up paid.
local OUTCOMES = {
  win = { winner = "win", loser = "loss" },
  draw = { winner = "draw", loser = "draw" },
}

local function normalizeName(name)
  if type(name) ~= "string" then return nil end
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" then return nil end
  return name
end

local function resolveTime(now)
  if type(now) == "number" then return now end
  if type(time) == "function" then return time() end
  return 0
end

local function localName()
  if type(UnitName) ~= "function" then return nil end
  local name = UnitName("player")
  if type(name) == "string" and name ~= "" then return name end
  return nil
end

-- One duel per pair regardless of who called it out, so recording the result
-- clears the challenge whichever combatant reports it.
local function pairKey(a, b)
  local x, y = a:lower(), b:lower()
  if x > y then x, y = y, x end
  return x .. "\0" .. y
end

local function copyChallenge(entry)
  return { challenger = entry.challenger, target = entry.target, at = entry.at }
end

function Gora:_Prune(at)
  local expired = nil
  for key, entry in pairs(self.pending) do
    if (at - entry.at) > CHALLENGE_TTL then
      expired = expired or {}
      expired[#expired + 1] = key
    end
  end
  if not expired then return 0 end
  for i = 1, #expired do self.pending[expired[i]] = nil end
  return #expired
end

local function countPending(pending)
  local n = 0
  for _ in pairs(pending) do n = n + 1 end
  return n
end

-- challenger defaults to the local player; it is a parameter so desktop tests
-- never need a UnitName stub.
function Gora:Challenge(target, challenger, now)
  local them = normalizeName(target)
  if not them then return nil, "name someone to challenge" end
  local me = normalizeName(challenger) or localName()
  if not me then return nil, "your character name is not known yet" end
  if me:lower() == them:lower() then return nil, "a Gora needs two different combatants" end

  local at = resolveTime(now)
  self:_Prune(at)

  local key = pairKey(me, them)
  if not self.pending[key] and countPending(self.pending) >= PENDING_MAX then
    return nil, "too many challenges are already open"
  end

  self.pending[key] = { challenger = me, target = them, at = at }
  return copyChallenge(self.pending[key])
end

function Gora:Cancel(target, challenger)
  local them = normalizeName(target)
  local me = normalizeName(challenger) or localName()
  if not them or not me then return false end
  local key = pairKey(me, them)
  if not self.pending[key] then return false end
  self.pending[key] = nil
  return true
end

function Gora:IsChallenged(a, b)
  local x, y = normalizeName(a), normalizeName(b)
  if not x or not y then return false end
  return self.pending[pairKey(x, y)] ~= nil
end

-- Copies, oldest first: the caller gets a list it can sort or mutate freely.
function Gora:GetPending(now)
  self:_Prune(resolveTime(now))
  local out = {}
  for _, entry in pairs(self.pending) do out[#out + 1] = copyChallenge(entry) end
  table.sort(out, function(a, b)
    if a.at ~= b.at then return a.at < b.at end
    if a.challenger ~= b.challenger then return a.challenger < b.challenger end
    return a.target < b.target
  end)
  return out
end

-- outcome is "win" (the default) or "draw". A prior Challenge is not required:
-- duels happen faster than anyone remembers to press a button, and refusing
-- unchallenged results would just teach members to stop recording them.
function Gora:RecordResult(winner, loser, outcome, now)
  local a = normalizeName(winner)
  if not a then return nil, "name the winner" end
  local b = normalizeName(loser)
  if not b then return nil, "name the loser" end
  if a:lower() == b:lower() then return nil, "a Gora needs two different combatants" end

  if outcome == nil then outcome = "win" end
  if type(outcome) ~= "string" then return nil, "outcome must be win or draw" end
  local grants = OUTCOMES[outcome:lower()]
  if not grants then
    return nil, "outcome must be win or draw; record a loss by naming the winner first"
  end

  local scoring = COB.Scoring
  if not (scoring and scoring.GrantGora) then return nil, "scoring unavailable" end

  -- Losses pay, and the loser's grant is independent of the winner's: a winner
  -- who has spent their daily gora cap must not silently cost the loser their
  -- participation points.
  local winnerPoints = scoring:GrantGora(a, grants.winner, now) or 0
  local loserPoints = scoring:GrantGora(b, grants.loser, now) or 0

  local at = resolveTime(now)
  local key = pairKey(a, b)
  local challenged = self.pending[key] ~= nil
  self.pending[key] = nil

  return {
    winner = a,
    loser = b,
    outcome = outcome:lower(),
    winnerPoints = winnerPoints,
    loserPoints = loserPoints,
    challenged = challenged,
    at = at,
  }
end

-- Test-only, matching the rest of Core: never clear live state in game.
function Gora:ResetForTests()
  if not COB._IN_TEST then return false end
  self.pending = {}
  return true
end
