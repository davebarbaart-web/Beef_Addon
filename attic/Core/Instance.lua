ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Shared-instance co-play (spec §7.1). While the player is inside a dungeon, raid
-- or battleground with at least one guildmate in the group, every closed 60s bucket
-- the player actually fought in asks Scoring for one instance grant. This module
-- decides *when* a bucket closed; Scoring owns the payout, the anti-AFK refusal and
-- the daily cap, and only Ladder can turn standing into a suggestion.
--
-- Classic+ port notes: every client API read here is behind a type() guard and
-- listed below, so a host that renames one degrades to "never qualifies" instead of
-- erroring on a timer.
--   IsInInstance, GetInstanceInfo, UnitAffectingCombat, UnitName, UnitIsInMyGuild,
--   GetNumGroupMembers, IsInRaid, GetBattlefieldWinner, C_Timer
local Instance = {
  -- Bucket length in seconds. One grant per closed bucket, never per tick.
  BucketSeconds = 60,
  -- Dungeon, raid and battleground only. Arena is deliberately absent: it is a
  -- rated skirmish, not a co-play night, and Gora already covers small-scale PvP.
  QualifyingTypes = { party = true, raid = true, pvp = true },
  tracking = false,
  combatSeen = false,
  bucketStartedAt = nil,
  instanceId = nil,
  instanceType = nil,
  completed = false,
  buckets = 0,
}
COB.Instance = Instance

local UNKNOWN_TYPE = "none"

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
  local inInstance, instanceType = false, UNKNOWN_TYPE
  if type(IsInInstance) == "function" then
    local isIn, kind = IsInInstance()
    inInstance = isIn and true or false
    if type(kind) == "string" then instanceType = kind end
  end

  local inCombat = false
  if type(UnitAffectingCombat) == "function" then
    inCombat = UnitAffectingCombat("player") and true or false
  end

  -- Instance id tells one run from the next so a fresh dungeon starts a fresh
  -- bucket and can earn its own completion bonus. Unpacked positionally rather
  -- than with select() so a client returning fewer values cannot raise.
  local instanceId
  if type(GetInstanceInfo) == "function" then
    local _, _, _, _, _, _, _, id = GetInstanceInfo()
    if type(id) == "number" then instanceId = id end
  end

  return {
    inInstance = inInstance,
    instanceType = instanceType,
    guildmates = countGuildmates(),
    inCombat = inCombat,
    instanceId = instanceId,
  }
end

-- state may be nil (sample the live client), a function returning a table, or a
-- table. Tests inject; the client never does.
local function resolveState(state)
  if type(state) == "function" then state = state() end
  if state == nil then state = liveState() end
  if type(state) ~= "table" then
    return { inInstance = false, instanceType = UNKNOWN_TYPE, guildmates = 0, inCombat = false }
  end
  return {
    inInstance = state.inInstance and true or false,
    instanceType = type(state.instanceType) == "string" and state.instanceType or UNKNOWN_TYPE,
    guildmates = tonumber(state.guildmates) or 0,
    inCombat = state.inCombat and true or false,
    instanceId = state.instanceId,
  }
end

-- Cities, open world and solo runs earn nothing: co-play means a guildmate is
-- actually there. Guildmates need not run the addon.
function Instance:Qualifies(state)
  local snapshot = resolveState(state)
  if not snapshot.inInstance then return false end
  if not self.QualifyingTypes[snapshot.instanceType] then return false end
  if snapshot.guildmates < 1 then return false end
  return true
end

--------------------------------------------------------------------------------
-- Ticker. No OnUpdate anywhere: scoring on a per-frame handler is banned, and the
-- timer only exists while a qualifying instance is being tracked.
--------------------------------------------------------------------------------

function Instance:_StopTicker()
  local ticker = self.ticker
  self.ticker = nil
  -- Bump the generation first so any re-arming callback already in flight retires
  -- itself instead of scheduling another pass.
  self.tickerGeneration = (self.tickerGeneration or 0) + 1
  if type(ticker) == "table" and type(ticker.Cancel) == "function" then
    ticker:Cancel()
  end
end

-- Deliberately shorter than a bucket. A ticker whose period equals the bucket
-- length only has to fire a few milliseconds early — which frame-quantized timers
-- routinely do — for the elapsed check to miss, and then the next tick lands a full
-- period later: an hour of play pays for half an hour. Sampling twice per bucket
-- means a boundary is always noticed on the tick after it passes.
function Instance:TickPeriod()
  return self.BucketSeconds / 2
end

function Instance:_StartTicker()
  if self.ticker then return end
  if type(C_Timer) ~= "table" then return end

  local period = self:TickPeriod()
  if type(C_Timer.NewTicker) == "function" then
    self.ticker = C_Timer.NewTicker(period, function() Instance:Tick() end)
    return
  end

  -- Fallback for a host without NewTicker: a one-shot timer that re-arms itself
  -- only while this generation is still the live one.
  if type(C_Timer.After) ~= "function" then return end
  self.tickerGeneration = (self.tickerGeneration or 0) + 1
  local generation = self.tickerGeneration
  local function rearm()
    if not Instance.tracking or Instance.tickerGeneration ~= generation then return end
    Instance:Tick()
    if Instance.tracking and Instance.tickerGeneration == generation then
      C_Timer.After(period, rearm)
    end
  end
  self.ticker = { rearming = true }
  C_Timer.After(period, rearm)
end

--------------------------------------------------------------------------------
-- Tracking lifecycle
--------------------------------------------------------------------------------

function Instance:IsTracking()
  return self.tracking and true or false
end

function Instance:_Begin(snapshot, at)
  self.tracking = true
  self.combatSeen = snapshot.inCombat
  self.bucketStartedAt = at
  self.instanceId = snapshot.instanceId
  self.instanceType = snapshot.instanceType
  self.completed = false
  self:_StartTicker()
end

-- Leaving drops the open bucket. A partial window cannot be proven to hold a full
-- bucket's worth of fighting, so the conservative answer is to pay nothing.
function Instance:Stop()
  if not self.tracking then return false end
  self.tracking = false
  self.combatSeen = false
  self.bucketStartedAt = nil
  self.instanceId = nil
  self.instanceType = nil
  self.completed = false
  self:_StopTicker()
  return true
end

-- Reconcile tracking with the world. Driven by discrete events (zone change, group
-- change), so it is safe to call as often as the client fires them.
function Instance:Update(state, now)
  local snapshot = resolveState(state)
  local at = resolveTime(now)

  if not self:Qualifies(snapshot) then
    self:Stop()
    return false
  end

  if not self.tracking then
    self:_Begin(snapshot, at)
    return true
  end

  -- A different instance is a different run: fresh bucket, fresh completion bonus.
  if snapshot.instanceId ~= nil and self.instanceId ~= nil and snapshot.instanceId ~= self.instanceId then
    self.instanceId = snapshot.instanceId
    self.instanceType = snapshot.instanceType
    self.bucketStartedAt = at
    self.combatSeen = snapshot.inCombat
    self.completed = false
    return true
  end

  if snapshot.instanceId ~= nil then self.instanceId = snapshot.instanceId end
  self.instanceType = snapshot.instanceType
  if snapshot.inCombat then self.combatSeen = true end
  return true
end

-- PLAYER_REGEN_DISABLED is a discrete event, so the anti-AFK rule never depends on
-- a poll happening to land while the player is mid-fight.
function Instance:NoteCombat()
  if not self.tracking then return false end
  self.combatSeen = true
  return true
end

function Instance:_Grant(complete)
  local scoring = COB.Scoring
  if not scoring then return 0 end
  local name = playerName()
  if not name then return 0 end
  -- No timestamp: Scoring resolves the wall-clock day key itself, and the bucket
  -- clock above is monotonic seconds, which would be a nonsense day.
  -- instanceType selects raid vs dungeon/BG bucket weights; both spend the instance cap.
  if complete then
    if type(scoring.GrantBattlegroundEnd) ~= "function" then return 0 end
    return scoring:GrantBattlegroundEnd(name, nil) or 0
  end
  return scoring:GrantInstanceBucket(name, nil, true, self.instanceType) or 0
end

-- Closes at most one bucket per call. If the timer drifted and several bucket
-- lengths passed, the extra time is forfeited rather than paid out in a burst.
function Instance:Tick(now, state)
  if not self.tracking then return 0 end

  local snapshot = resolveState(state)
  if not self:Qualifies(snapshot) then
    self:Stop()
    return 0
  end
  if snapshot.inCombat then self.combatSeen = true end

  local at = resolveTime(now)
  local startedAt = self.bucketStartedAt or at
  if at - startedAt < self.BucketSeconds then return 0 end

  local paid = 0
  if self.combatSeen then paid = self:_Grant(false) end

  self.buckets = self.buckets + 1
  -- Carry the boundary forward rather than restarting from "now", so the few
  -- hundred milliseconds a tick lands late are not silently added to the next
  -- bucket over and over. If a whole bucket's worth of drift piled up (a long
  -- freeze, a suspended client), the backlog is still forfeited rather than paid.
  local nextStart = startedAt + self.BucketSeconds
  if at - nextStart >= self.BucketSeconds then nextStart = at end
  self.bucketStartedAt = nextStart
  -- Still fighting as the bucket closes? That combat belongs to the next bucket too.
  self.combatSeen = snapshot.inCombat
  return paid
end

--------------------------------------------------------------------------------
-- Finishing bonus — battlegrounds only, and the config says so
--------------------------------------------------------------------------------
--
-- There is exactly one run this client can prove finished: a battleground whose
-- scoreboard locked. TBC has no dependable dungeon or raid completion signal (no
-- LFG completion reward, and a final boss kill is not an end-of-run event), and
-- scoring must not register the combat log to invent one. So dungeons and raids
-- are paid entirely by their buckets, and Scoring.Points carries no raid-completion
-- number for a path that can never reach it.

-- Paid at most once per tracked instance, and only while the run still qualifies.
--
-- The battleground check is here rather than only in the caller because the grant it
-- makes is `BattlegroundEnd`. Left ungated, a raid reaching this method would be paid
-- a battleground's completion bonus and would burn its one completion slot doing it —
-- exactly the unpayable promise removing RaidComplete was meant to end.
function Instance:GrantCompletion(state)
  if not self.tracking or self.completed then return 0 end
  if self.instanceType ~= "pvp" then return 0 end
  if not self:Qualifies(state) then return 0 end
  self.completed = true
  return self:_Grant(true)
end

-- On TBC Anniversary a finished match is readable as GetBattlefieldWinner()
-- returning a faction index once the scoreboard locks, and UPDATE_BATTLEFIELD_STATUS
-- fires around it. Guarded, so a host that never reports a winner simply loses the
-- bonus and keeps its buckets.
function Instance:CheckBattlegroundEnd(state)
  if not self.tracking or self.completed then return 0 end
  if type(GetBattlefieldWinner) ~= "function" then return 0 end
  if GetBattlefieldWinner() == nil then return 0 end
  return self:GrantCompletion(state)
end

--------------------------------------------------------------------------------
-- Wiring
--------------------------------------------------------------------------------

-- Core owns no frames: the bootstrap registers the client events (see
-- ChurchOfBeef.lua, Events) and routes each one into the methods above. This is the
-- one entry point it needs — reconcile tracking with the world as it is right now.
function Instance:Init()
  self:Update()
  return true
end

-- The events the bootstrap must deliver, and which method each one feeds.
-- GROUP_ROSTER_UPDATE is the Anniversary-era name for a party/raid change.
Instance.Events = {
  PLAYER_ENTERING_WORLD = "Update",
  ZONE_CHANGED_NEW_AREA = "Update",
  GROUP_ROSTER_UPDATE = "Update",
  PLAYER_REGEN_DISABLED = "NoteCombat",
  UPDATE_BATTLEFIELD_STATUS = "CheckBattlegroundEnd",
}

-- Single dispatch point so the bootstrap frame stays a wire and nothing else.
-- An event this module does not claim is ignored rather than treated as a zone change.
function Instance:OnEvent(event)
  local method = self.Events[event]
  if not method then return false end
  self[method](self)
  return true
end

function Instance:ResetForTests()
  if not COB._IN_TEST then return false end
  self:_StopTicker()
  self.tracking = false
  self.combatSeen = false
  self.bucketStartedAt = nil
  self.instanceId = nil
  self.instanceType = nil
  self.completed = false
  self.buckets = 0
  return true
end
