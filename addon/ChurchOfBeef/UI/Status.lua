ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Frame-level BeefNet / sync status (research 20 + 45). Maps Net/Sync signals to
-- UIStatus; never invents ranks or calls Commit. Chip lives on MainFrame.
local Status = {
  state = "ready",
  softFlags = {},
  SyncedHoldSeconds = 1.5,
  CachedHoldSeconds = 10,
}
COB.UI = COB.UI or {}
COB.UI.Status = Status

local CHIP = {
  settling = "Starting Church…",
  unguilded = "Not in a guild",
  roster_wait = "Waiting for guild roster…",
  syncing = "Checking for peers…",
  synced = "Synced",
  cached = "Using local standing",
  no_peers = "No addon peers",
  ready = "",
}

local SOFT_CHIP = {
  version_warn = "BeefNet version mismatch",
  no_officers = "No officers online",
}

local WARN_COLOR = "|cffffaa00"
local RESET = "|r"

local function after(seconds, fn)
  if type(C_Timer) == "table" and type(C_Timer.After) == "function" then
    C_Timer.After(seconds, fn)
    return true
  end
  return false
end

local function inGuild()
  if type(IsInGuild) ~= "function" then return true end
  return IsInGuild() and true or false
end

local function rosterReady()
  if not (COB.Net and COB.Net.RosterReady) then return true end
  return COB.Net:RosterReady() and true or false
end

local function cacheCount()
  if not (COB.Ladder and COB.Ladder.ExportState) then return 0 end
  local records = COB.Ladder:ExportState()
  return type(records) == "table" and #records or 0
end

-- Roster-backed ladder: live guild occupants mean titles are not peer-dependent.
local function rosterOccupantCount()
  if not (COB.Roster and COB.Roster.IsReady and COB.Roster:IsReady()) then return 0 end
  if not (COB.Roster.GetLadderView) then return 0 end
  local view = COB.Roster:GetLadderView()
  return type(view) == "table" and #view or 0
end

local function syncSignals()
  if COB.Sync and COB.Sync.GetStatus then
    return COB.Sync:GetStatus()
  end
  return {
    pendingRequest = COB.Sync and COB.Sync.pendingRequest or nil,
    requestSent = false,
    mergeCount = 0,
    consumeEnded = false,
  }
end

local function softFlagsFromHost()
  local flags = {}
  if COB.Net and COB.Net.warnedVersion then
    flags.version_warn = true
  end
  return flags
end

-- Derive the mesh state from wire signals. Sticky brief holds (synced/cached)
-- are applied in Refresh after this returns.
function Status:ComputeRaw()
  if not inGuild() then
    return "unguilded", softFlagsFromHost()
  end

  local sig = syncSignals()
  local soft = softFlagsFromHost()
  local cache = cacheCount()

  if sig.pendingRequest then
    if not rosterReady() then
      return "roster_wait", soft
    end
    if (sig.mergeCount or 0) > 0 then
      return "synced", soft
    end
    if not sig.requestSent then
      return "settling", soft
    end
    return "syncing", soft
  end

  if sig.consumeEnded then
    if (sig.mergeCount or 0) > 0 then
      return "synced", soft
    end
    -- Titles come from the live roster. Solo GM with a flock is ready even with
    -- zero addon peers — do not teach "empty ladder" learning copy.
    if rosterOccupantCount() > 0 then
      return "ready", soft
    end
    if cache > 0 then
      return "cached", soft
    end
    return "no_peers", soft
  end

  return "ready", soft
end

function Status:_CancelHold()
  self._holdToken = (self._holdToken or 0) + 1
end

function Status:_HoldThen(seconds, nextState)
  local token = (self._holdToken or 0) + 1
  self._holdToken = token
  if not after(seconds, function()
    if Status._holdToken ~= token then return end
    if Status.state == "synced" or Status.state == "cached" then
      Status.state = nextState
      Status:Present()
    end
  end) then
    -- No timer host (offline tests): advance immediately so Present is honest.
    self.state = nextState
  end
end

function Status:Refresh()
  local raw, soft = self:ComputeRaw()
  self.softFlags = soft or {}

  local prev = self.state

  -- Once we have shown synced this consume window, do not fall back to syncing
  -- for later chunks; brief success then ready.
  if raw == "synced" and prev ~= "synced" and prev ~= "ready" then
    self.state = "synced"
    self:_HoldThen(self.SyncedHoldSeconds, "ready")
  elseif raw == "cached" and prev ~= "cached" and prev ~= "ready" then
    self.state = "cached"
    self:_HoldThen(self.CachedHoldSeconds, "ready")
  elseif raw == "synced" and (prev == "synced" or prev == "ready") then
    -- stay; hold timer owns the exit
    if prev == "ready" and not self._holdToken then
      self.state = "ready"
    end
  elseif raw == "no_peers" then
    self.state = "no_peers"
    self:_CancelHold()
  elseif raw == "unguilded" or raw == "settling" or raw == "roster_wait" or raw == "syncing" then
    self.state = raw
    self:_CancelHold()
  elseif raw == "ready" then
    if prev == "synced" or prev == "cached" then
      -- wait for hold timers
    else
      self.state = "ready"
    end
  else
    self.state = raw
  end

  self:Present()
  return self.state, self.softFlags
end

function Status:ChipText()
  local state = self.state or "ready"
  if state == "ready" then
    if self.softFlags and self.softFlags.version_warn then
      return SOFT_CHIP.version_warn
    end
    if self.softFlags and self.softFlags.no_officers then
      return SOFT_CHIP.no_officers
    end
    return ""
  end
  return CHIP[state] or ""
end

function Status:IsConnecting()
  local s = self.state
  return s == "settling" or s == "roster_wait" or s == "syncing"
end

function Status:ShowsLearningBanner()
  -- Only when there is truly no flock to show (no roster occupants, no peer merge).
  return self.state == "no_peers" and rosterOccupantCount() == 0
end

function Status:ShowsHardGateBanner()
  return self.state == "unguilded"
end

-- Dual-encode stale/warn with words + optional amber; connecting stays neutral.
function Status:FormattedChip()
  local text = self:ChipText()
  if text == "" then return "" end
  local s = self.state
  if s == "cached" or s == "no_peers" or (s == "ready" and self.softFlags and self.softFlags.version_warn) then
    return WARN_COLOR .. text .. RESET
  end
  return text
end

function Status:Present()
  local ui = COB.UI
  if not ui then return end

  local chip = ui.statusChip
  local footer = ui.frame and ui.frame.FooterText
  local text = self:FormattedChip()

  if chip and chip.SetText then
    chip:SetText(text)
    if text ~= "" then
      if chip.Show then chip:Show() end
    else
      if chip.Hide then chip:Hide() end
    end
  end

  -- Scripture footer yields to the mesh chip; idle restores the lore line.
  if footer and footer.SetText then
    if text ~= "" then
      footer:SetText("")
    else
      footer:SetText("Eternal Grazing.")
    end
  end

  -- Ladder L1 banners react to hard gate / first-install empty.
  if self._presentedState ~= self.state then
    self._presentedState = self.state
    if ui.MarkDirty then
      ui:MarkDirty("ladder")
    end
  end
end

function Status:ResetForTests()
  if not COB._IN_TEST then return false end
  self:_CancelHold()
  self.state = "ready"
  self.softFlags = {}
  self._presentedState = nil
  return true
end
