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
--   GetNumGroupMembers, IsInRaid, GetBattlefieldWinner, C_Timer, CreateFrame
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
  completed = false,
  buckets = 0,
}
COB.Instance = Instance

local UNKNOWN_TYPE = "none"

-- Bucket length is measured on the monotonic clock (GetTime), never the wall clock:
-- a system-time change must not be able to close or stretch a bucket. Scoring keeps
-- its own wall-clock day key, so grants below deliberately pass no timestamp.
local function resolveTime(now)
  if type(now) == "number" then return now end
  if type(GetTime) == "function" then
    local t = GetTime()
    if type(t) == "number" then return t end
  end
  return 0
end

local function playerName()
  if type(UnitName) ~= "function" then return nil end
  local name = UnitName("player")
  if type(name) ~= "string" or name == "" then return nil end
  return name
end

-- Guildmates other than the player. Raid unit ids include the player and party ids
-- do not, so the name compare is what keeps the player out of their own count.
local function countGuildmates()
  if type(GetNumGroupMembers) ~= "function" or type(UnitName) ~= "function" then return 0 end
  local size = tonumber(GetNumGroupMembers()) or 0
  if size <= 0 then return 0 end

  local inRaid = type(IsInRaid) == "function" and IsInRaid() and true or false
  local prefix = inRaid and "raid" or "party"
  local me = playerName()
  local count, seen = 0, {}
  for i = 1, size do
    local unit = prefix .. i
    local name = UnitName(unit)
    if type(name) == "string" and name ~= "" and name ~= me and not seen[name] then
      seen[name] = true
      local inGuild = true
      if type(UnitIsInMyGuild) == "function" then
        inGuild = UnitIsInMyGuild(unit) and true or false
      end
      if inGuild then count = count + 1 end
    end
  end
  return count
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

function Instance:_StartTicker()
  if self.ticker then return end
  if type(C_Timer) ~= "table" then return end

  local period = self.BucketSeconds
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
    self.bucketStartedAt = at
    self.combatSeen = snapshot.inCombat
    self.completed = false
    return true
  end

  if snapshot.instanceId ~= nil then self.instanceId = snapshot.instanceId end
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
  if complete then
    return scoring:GrantInstanceComplete(name) or 0
  end
  return scoring:GrantInstanceBucket(name, nil, true) or 0
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
  self.bucketStartedAt = at
  -- Still fighting as the bucket closes? That combat belongs to the next bucket too.
  self.combatSeen = snapshot.inCombat
  return paid
end

--------------------------------------------------------------------------------
-- Completion bonus (best-effort, spec open question #4)
--------------------------------------------------------------------------------

-- Paid at most once per tracked instance, and only while the run still qualifies.
function Instance:GrantCompletion(state)
  if not self.tracking or self.completed then return 0 end
  if not self:Qualifies(state) then return 0 end
  self.completed = true
  return self:_Grant(true)
end

-- Battlegrounds: on TBC Anniversary a finished match is readable as
-- GetBattlefieldWinner() returning a faction index once the scoreboard locks, and
-- UPDATE_BATTLEFIELD_STATUS fires around it. Guarded, so a host that never reports
-- a winner simply loses the bonus and keeps its buckets.
--
-- Dungeons are deliberately skipped: TBC has no dependable "dungeon complete"
-- signal (no LFG completion reward, and a final boss kill is not an end-of-run
-- event), and scoring must not register CLEU to invent one. Buckets carry the run.
function Instance:CheckBattlegroundEnd(state)
  if not self.tracking or self.completed then return 0 end
  if type(GetBattlefieldWinner) ~= "function" then return 0 end
  if GetBattlefieldWinner() == nil then return 0 end
  return self:GrantCompletion(state)
end

--------------------------------------------------------------------------------
-- Wiring
--------------------------------------------------------------------------------

function Instance:Init()
  if self.frame then
    self:Update()
    return self.frame
  end
  if type(CreateFrame) ~= "function" then return nil end

  local frame = CreateFrame("Frame")
  self.frame = frame

  -- GROUP_ROSTER_UPDATE is the Anniversary-era name for a party/raid change.
  -- RegisterEvent raises on an event a host does not know, so each registration is
  -- pcall'd: losing one costs responsiveness (the 60s tick re-checks qualification
  -- anyway), never the whole tracker.
  local events = {
    "PLAYER_ENTERING_WORLD",
    "ZONE_CHANGED_NEW_AREA",
    "GROUP_ROSTER_UPDATE",
    "PLAYER_REGEN_DISABLED",
    "UPDATE_BATTLEFIELD_STATUS",
  }
  for i = 1, #events do
    pcall(function() frame:RegisterEvent(events[i]) end)
  end

  frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
      Instance:NoteCombat()
      return
    end
    if event == "UPDATE_BATTLEFIELD_STATUS" then
      Instance:CheckBattlegroundEnd()
      return
    end
    Instance:Update()
  end)

  self:Update()
  return frame
end

function Instance:ResetForTests()
  if not COB._IN_TEST then return false end
  self:_StopTicker()
  self.tracking = false
  self.combatSeen = false
  self.bucketStartedAt = nil
  self.instanceId = nil
  self.completed = false
  self.buckets = 0
  return true
end
