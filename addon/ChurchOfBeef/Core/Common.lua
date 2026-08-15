ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Shared Core primitives. Loads first so every module speaks one identity law and
-- one clock story instead of keeping private copies that drift apart.

--------------------------------------------------------------------------------
-- Names: one identity law for the whole addon
--------------------------------------------------------------------------------

-- Character names reach us from four sources that disagree about case and realm:
-- the guild roster ("Beefina-Whitemane"), CHAT_MSG_ADDON senders ("Beefina"),
-- UnitName ("Beefina"), and an officer typing into an edit box ("beefina").
-- Key answers "is this the same person"; Display is what a human should read.
-- Anything that keys a table by a member must key it by Key, or one member's
-- standing quietly becomes three records.
local Names = {}
COB.Names = Names

local function trim(text)
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

Names.Trim = trim

-- Realm suffix stripped, case preserved. Each guild is its own ladder, so the
-- realm half carries no information we need.
function Names.Display(name)
  local trimmed = trim(name)
  if not trimmed then return nil end
  return trim(trimmed:match("^([^%-]+)") or trimmed)
end

function Names.Key(name)
  local shown = Names.Display(name)
  if not shown then return nil end
  return shown:lower()
end

function Names.Same(a, b)
  local left = Names.Key(a)
  if not left then return false end
  return left == Names.Key(b)
end

--------------------------------------------------------------------------------
-- Clock: two clocks, told apart on purpose
--------------------------------------------------------------------------------

local Clock = {}
COB.Clock = Clock

-- Wall clock. Day keys, "created at" stamps — anything a human reads or that has
-- to survive a session.
function Clock.Wall(now)
  if type(now) == "number" then return now end
  if type(time) == "function" then
    local t = time()
    if type(t) == "number" then return t end
  end
  return 0
end

-- Monotonic client clock. Elapsed-time measurement only: a system-time correction
-- must never be able to close or stretch a co-play bucket.
function Clock.Mono(now)
  if type(now) == "number" then return now end
  if type(GetTime) == "function" then
    local t = GetTime()
    if type(t) == "number" then return t end
  end
  return 0
end

--------------------------------------------------------------------------------
-- Group: live party/raid reads shared by the co-play trackers
--------------------------------------------------------------------------------

local Group = {}
COB.Group = Group

function Group.PlayerName()
  if type(UnitName) ~= "function" then return nil end
  local name = UnitName("player")
  if type(name) ~= "string" or name == "" then return nil end
  return name
end

-- Guildmates other than the player. Raid unit ids include the player and party
-- ids do not, so the name compare is what keeps the player out of their own count.
-- Guildmates need not run the addon for co-play to count.
function Group.CountGuildmates()
  if type(GetNumGroupMembers) ~= "function" or type(UnitName) ~= "function" then return 0 end
  local size = tonumber(GetNumGroupMembers()) or 0
  if size <= 0 then return 0 end

  local inRaid = type(IsInRaid) == "function" and IsInRaid() and true or false
  local prefix = inRaid and "raid" or "party"
  local me = Names.Key(Group.PlayerName())
  local count, seen = 0, {}
  for i = 1, size do
    local unit = prefix .. i
    local key = Names.Key(UnitName(unit))
    if key and key ~= me and not seen[key] then
      seen[key] = true
      local inGuild = true
      if type(UnitIsInMyGuild) == "function" then
        inGuild = UnitIsInMyGuild(unit) and true or false
      end
      if inGuild then count = count + 1 end
    end
  end
  return count
end
