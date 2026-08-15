ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Quest fellowship co-play (eligibility amendment §4). While the player is in an
-- open-world party with at least one guildmate — not inside an instance, and not
-- resting in a city/inn — every closed 60s bucket that saw combat or a quest
-- turn-in asks Scoring for one quest grant. This module decides *when* a bucket
-- closed; Scoring owns the payout and the strict daily quest cap.
--
-- Classic+ port notes: every client API read here is behind a type() guard and
-- listed below, so a host that renames one degrades to "never qualifies" instead of
-- erroring on a timer.
--   IsInInstance, IsResting, UnitAffectingCombat, UnitName, UnitIsInMyGuild,
--   GetNumGroupMembers, IsInRaid, C_Timer
-- QUEST_TURNED_IN is registered best-effort (bootstrap pcall); if the host never
-- fires it, combat alone still gates the bucket.
local Quest = {
  -- Bucket length in seconds. One grant per closed bucket, never per tick.
  BucketSeconds = 60,
  -- How long a run of fellowship survives walking into an inn or a city.
  --
  -- The rest-zone rule exists so standing around in Shattrath does not pay. Applied
  -- the instant IsResting() flips, it also deleted the thing this source was built
  -- to reward: an evening of questing together ends at a quest giver, in a town, and
  -- QUEST_TURNED_IN then arrives after tracking has already stopped. So resting ends
  -- a session on a delay — long enough to walk in and hand in a chain, far too short
  -- to be an afternoon at the auction house.
  RestGraceSeconds = 180,
  tracking = false,
  combatSeen = false,
  questTurnInSeen = false,
  bucketStartedAt = nil,
  restingSince = nil,
  buckets = 0,
}
COB.Quest = Quest

-- Bucket length is measured on the monotonic clock (GetTime), never the wall clock:
-- a system-time change must not be able to close or stretch a bucket. Scoring keeps
-- its own wall-clock day key, so grants below deliberately pass no timestamp.
local function resolveTime(now)
  return COB.Clock and COB.Clock.Mono(now) or (type(now) == "number" and now or 0)
end

local function playerName()
  return COB.Group and COB.Group.PlayerName() or nil
end

local function countGuildmates()
  return COB.Group and COB.Group.CountGuildmates() or 0
end

-- The single place live client state is read. Everything else in this file works on
-- the plain table this returns, which is what makes the rules testable offline.
local function liveState()
  local inInstance = false
  if type(IsInInstance) == "function" then
    local isIn = IsInInstance()
    inInstance = isIn and true or false
  end

  local resting = false
  if type(IsResting) == "function" then
    resting = IsResting() and true or false
  end

  local inCombat = false
  if type(UnitAffectingCombat) == "function" then
    inCombat = UnitAffectingCombat("player") and true or false
  end

  return {
    inInstance = inInstance,
    guildmates = countGuildmates(),
    resting = resting,
    inCombat = inCombat,
  }
end

-- state may be nil (sample the live client), a function returning a table, or a
-- table. Tests inject; the client never does.
local function resolveState(state)
  if type(state) == "function" then state = state() end
  if state == nil then state = liveState() end
  if type(state) ~= "table" then
    return { inInstance = false, guildmates = 0, resting = false, inCombat = false }
  end
  return {
    inInstance = state.inInstance and true or false,
    guildmates = tonumber(state.guildmates) or 0,
    resting = state.resting and true or false,
    inCombat = state.inCombat and true or false,
  }
end

-- Open-world fellowship only: an instance is Instance.lua's job, a resting city/inn
-- pays nothing, and co-play still means a guildmate is actually there.
--
-- This is the rule for *starting*, and it is what the daily cap is sized against.
-- Continuing has one extra allowance; see _Continues.
function Quest:Qualifies(state)
  local snapshot = resolveState(state)
  if snapshot.inInstance then return false end
  if snapshot.guildmates < 1 then return false end
  if snapshot.resting then return false end
  return true
end

-- Whether an already-running session survives this snapshot. Resting is the only
-- disqualification that gets a grace period, and only while the rest of the shape
-- still holds: leaving the group or zoning into an instance ends it immediately,
-- because neither of those is "we are wrapping up the evening".
function Quest:_Continues(snapshot, at)
  if self:Qualifies(snapshot) then
    self.restingSince = nil
    return true
  end
  if not self.tracking then return false end
  if not snapshot.resting then return false end
  if snapshot.inInstance or snapshot.guildmates < 1 then return false end

  self.restingSince = self.restingSince or at
  return (at - self.restingSince) <= self.RestGraceSeconds
end

--------------------------------------------------------------------------------
-- Ticker. No OnUpdate anywhere: scoring on a per-frame handler is banned, and the
-- timer only exists while a qualifying quest party is being tracked.
--------------------------------------------------------------------------------

function Quest:_StopTicker()
  local ticker = self.ticker
  self.ticker = nil
  -- Bump the generation first so any re-arming callback already in flight retires
  -- itself instead of scheduling another pass.
  self.tickerGeneration = (self.tickerGeneration or 0) + 1
  if type(ticker) == "table" and type(ticker.Cancel) == "function" then
    ticker:Cancel()
  end
end

-- Half a bucket, for the reason spelled out in Core/Instance.lua: a ticker period
-- equal to the bucket length loses every boundary it arrives a hair early for.
function Quest:TickPeriod()
  return self.BucketSeconds / 2
end

function Quest:_StartTicker()
  if self.ticker then return end
  if type(C_Timer) ~= "table" then return end

  local period = self:TickPeriod()
  if type(C_Timer.NewTicker) == "function" then
    self.ticker = C_Timer.NewTicker(period, function() Quest:Tick() end)
    return
  end

  -- Fallback for a host without NewTicker: a one-shot timer that re-arms itself
  -- only while this generation is still the live one.
  if type(C_Timer.After) ~= "function" then return end
  self.tickerGeneration = (self.tickerGeneration or 0) + 1
  local generation = self.tickerGeneration
  local function rearm()
    if not Quest.tracking or Quest.tickerGeneration ~= generation then return end
    Quest:Tick()
    if Quest.tracking and Quest.tickerGeneration == generation then
      C_Timer.After(period, rearm)
    end
  end
  self.ticker = { rearming = true }
  C_Timer.After(period, rearm)
end

--------------------------------------------------------------------------------
-- Tracking lifecycle
--------------------------------------------------------------------------------

function Quest:IsTracking()
  return self.tracking and true or false
end

function Quest:_Begin(snapshot, at)
  self.tracking = true
  self.combatSeen = snapshot.inCombat
  self.questTurnInSeen = false
  self.bucketStartedAt = at
  self.restingSince = nil
  self:_StartTicker()
end

-- Leaving drops the open bucket. A partial window cannot be proven to hold a full
-- bucket's worth of activity, so the conservative answer is to pay nothing.
function Quest:Stop()
  if not self.tracking then return false end
  self.tracking = false
  self.combatSeen = false
  self.questTurnInSeen = false
  self.bucketStartedAt = nil
  self.restingSince = nil
  self:_StopTicker()
  return true
end

-- Reconcile tracking with the world. Driven by discrete events (zone change, group
-- change), so it is safe to call as often as the client fires them.
function Quest:Update(state, now)
  local snapshot = resolveState(state)
  local at = resolveTime(now)

  if not self:_Continues(snapshot, at) then
    self:Stop()
    return false
  end

  -- Only a fully qualifying snapshot may open a session; grace can extend one but
  -- never start one, so logging in inside an inn earns nothing.
  if not self.tracking then
    if not self:Qualifies(snapshot) then return false end
    self:_Begin(snapshot, at)
    return true
  end

  if snapshot.inCombat then self.combatSeen = true end
  return true
end

-- PLAYER_REGEN_DISABLED is a discrete event, so the anti-AFK rule never depends on
-- a poll happening to land while the player is mid-fight.
function Quest:NoteCombat()
  if not self.tracking then return false end
  self.combatSeen = true
  return true
end

-- QUEST_TURNED_IN is the other activity signal: turning in a quest mid-bucket counts
-- even if the player never swung. Absent on a host that never fires the event.
function Quest:NoteQuestTurnIn()
  if not self.tracking then return false end
  self.questTurnInSeen = true
  return true
end

function Quest:_Grant()
  local scoring = COB.Scoring
  if not scoring then return 0 end
  local name = playerName()
  if not name then return 0 end
  -- No timestamp: Scoring resolves the wall-clock day key itself, and the bucket
  -- clock above is monotonic seconds, which would be a nonsense day.
  if type(scoring.GrantQuestBucket) ~= "function" then return 0 end
  return scoring:GrantQuestBucket(name, nil, true) or 0
end

-- Closes at most one bucket per call. If the timer drifted and several bucket
-- lengths passed, the extra time is forfeited rather than paid out in a burst.
function Quest:Tick(now, state)
  if not self.tracking then return 0 end

  local snapshot = resolveState(state)
  local at = resolveTime(now)
  if not self:_Continues(snapshot, at) then
    self:Stop()
    return 0
  end
  if snapshot.inCombat then self.combatSeen = true end

  local startedAt = self.bucketStartedAt or at
  if at - startedAt < self.BucketSeconds then return 0 end

  local paid = 0
  if self.combatSeen or self.questTurnInSeen then paid = self:_Grant() end

  self.buckets = self.buckets + 1
  -- Carry the boundary forward instead of restarting from "now" (see Instance:Tick).
  local nextStart = startedAt + self.BucketSeconds
  if at - nextStart >= self.BucketSeconds then nextStart = at end
  self.bucketStartedAt = nextStart
  -- Still fighting as the bucket closes? That combat belongs to the next bucket too.
  -- A turn-in is discrete and does not span the boundary on its own.
  self.combatSeen = snapshot.inCombat
  self.questTurnInSeen = false
  return paid
end

--------------------------------------------------------------------------------
-- Wiring
--------------------------------------------------------------------------------

-- Core owns no frames: the bootstrap registers the client events (see
-- ChurchOfBeef.lua, Events) and routes each one into the methods above. This is the
-- one entry point it needs — reconcile tracking with the world as it is right now.
function Quest:Init()
  self:Update()
  return true
end

-- The events the bootstrap must deliver, and which method each one feeds.
-- GROUP_ROSTER_UPDATE is the Anniversary-era name for a party/raid change.
-- QUEST_TURNED_IN is best-effort: RegisterEvent is pcall'd in the bootstrap.
Quest.Events = {
  PLAYER_ENTERING_WORLD = "Update",
  ZONE_CHANGED_NEW_AREA = "Update",
  GROUP_ROSTER_UPDATE = "Update",
  PLAYER_REGEN_DISABLED = "NoteCombat",
  QUEST_TURNED_IN = "NoteQuestTurnIn",
}

-- Single dispatch point so the bootstrap frame stays a wire and nothing else.
-- An event this module does not claim is ignored rather than treated as a zone change.
-- QUEST_TURNED_IN is type-guarded: if the event name somehow arrives without a
-- matching method table entry, still note the turn-in when tracking.
function Quest:OnEvent(event)
  if event == "QUEST_TURNED_IN" then
    return self:NoteQuestTurnIn()
  end
  local method = self.Events[event]
  if not method then return false end
  self[method](self)
  return true
end

function Quest:ResetForTests()
  if not COB._IN_TEST then return false end
  self:_StopTicker()
  self.tracking = false
  self.combatSeen = false
  self.questTurnInSeen = false
  self.bucketStartedAt = nil
  self.restingSince = nil
  self.buckets = 0
  return true
end
