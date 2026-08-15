ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- The frame's status chip. Guild membership and roster readiness only — not
-- standing, points, or grants. A version-mismatch word is the one soft flag
-- (Bible §13.4). Once the roster is in, the chip hides.
local Status = {
  state = "ready",
  softFlags = {},
}
COB.UI = COB.UI or {}
COB.UI.Status = Status

local CHIP = {
  unguilded = "Not in a guild",
  roster_wait = "Reading the guild roster…",
  ready = "",
}

local SOFT_CHIP = {
  version_warn = "BeefNet version mismatch",
}

local WARN_COLOR = "|cffffaa00"
local RESET = "|r"

local function inGuild()
  if type(IsInGuild) ~= "function" then return true end
  return IsInGuild() and true or false
end

local function rosterReady()
  if not (COB.Roster and COB.Roster.IsReady) then return true end
  return COB.Roster:IsReady() and true or false
end

local function softFlagsFromHost()
  local flags = {}
  if COB.Net and COB.Net.warnedVersion then
    flags.version_warn = true
  end
  return flags
end

function Status:ComputeRaw()
  local soft = softFlagsFromHost()
  if not inGuild() then return "unguilded", soft end
  if not rosterReady() then return "roster_wait", soft end
  return "ready", soft
end

function Status:Refresh()
  local raw, soft = self:ComputeRaw()
  self.state = raw
  self.softFlags = soft or {}
  self:Present()
  return self.state, self.softFlags
end

function Status:ChipText()
  local state = self.state or "ready"
  if state == "ready" then
    if self.softFlags and self.softFlags.version_warn then
      return SOFT_CHIP.version_warn
    end
    return ""
  end
  return CHIP[state] or ""
end

function Status:IsConnecting()
  return self.state == "roster_wait"
end

-- Dual-encode warnings with words plus amber; waiting states stay neutral.
function Status:FormattedChip()
  local text = self:ChipText()
  if text == "" then return "" end
  if self.state == "ready" and self.softFlags and self.softFlags.version_warn then
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

  if footer and footer.SetText then
    -- Quiet shell: no joke chrome (Law 10). Waiting copy lives on the chip.
    footer:SetText("")
  end
end

function Status:ResetForTests()
  if not COB._IN_TEST then return false end
  self.state = "ready"
  self.softFlags = {}
  return true
end
