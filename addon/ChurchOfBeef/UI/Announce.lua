ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Guild-chat liturgy: the one place the addon speaks in public. Plain text, so a
-- member without the addon still reads the rite, and only from the client whose
-- officer made the commit — every other client watching the same RANK_COMMIT
-- stays silent (spec §10). Displays outcomes only: never grants standing, never
-- writes ladder state, never invents a title.
local Announce = {}
COB.Announce = Announce

local CHANNEL = "GUILD"
-- SendChatMessage refuses longer lines; canon titles keep us far under it, but a
-- pathological name must fail loudly here rather than in the client.
local MAX_CHARS = 255
-- "One throttled line" (spec §10): a double-click, or a commit replayed through
-- the officer's own UI, must not shout the same sentence twice.
local REPEAT_WINDOW = 10
local REPEAT_MEMORY = 32

-- Copy IDs COB_ANNOUNCE_PROMOTE / _DEMOTE / _COUNCIL / _PROPHET. Both substitutions
-- are caller-supplied: the title always comes from COB.Ranks.Title, so a canon
-- rename lands in guild chat without editing liturgy.
local LINES = {
  promotion = "The Church recognizes %s, elevated to %s.",
  demotion = "The Church records the fall of %s, returned to %s.",
  council = "The Church seats %s upon the %s.",
  prophet = "The Church anoints %s as %s.",
}

local sentAt = {}
local sentCount = 0

local function nowSeconds()
  if type(GetTime) == "function" then return GetTime() end
  if type(time) == "function" then return time() end
  return 0
end

local function announceDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

-- Default ON (glossary 74): an unset preference is consent, not silence.
function Announce:IsEnabled()
  local db = announceDb()
  if not db then return true end
  return db.announce ~= false
end

function Announce:SetEnabled(enabled)
  local db = announceDb()
  if not db then return nil, "saved variables not ready" end
  db.announce = enabled and true or false
  return db.announce
end

local function throttled(text)
  local at = nowSeconds()
  local last = sentAt[text]
  if last and (at - last) < REPEAT_WINDOW then return true end
  -- Bounded memory: the window only has to cover accidental repeats, so dropping
  -- the whole table beats tracking eviction order for a handful of strings.
  if sentCount >= REPEAT_MEMORY then
    sentAt = {}
    sentCount = 0
  end
  sentAt[text] = at
  sentCount = sentCount + 1
  return false
end

-- Returns sent, text|reason.
local function speak(self, template, name, title)
  if type(name) ~= "string" or name == "" then return false, "invalid name" end
  if type(title) ~= "string" or title == "" then return false, "invalid title" end
  if not self:IsEnabled() then return false, "announce opt-out" end
  -- The commit's author announces it. Peers applying the replicated commit must
  -- not each add a line, or one promotion becomes a guild-chat stampede.
  if not (COB.Officer and COB.Officer:LocalIsOfficer()) then return false, "not an officer" end
  if type(IsInGuild) == "function" and not IsInGuild() then return false, "not in a guild" end
  if type(SendChatMessage) ~= "function" then return false, "no chat api" end

  local text = string.format(template, name, title)
  if #text > MAX_CHARS then return false, "line too long" end
  if throttled(text) then return false, "throttled" end

  SendChatMessage(text, CHANNEL)
  return true, text
end

function Announce:Promotion(name, title)
  return speak(self, LINES.promotion, name, title)
end

function Announce:Demotion(name, title)
  return speak(self, LINES.demotion, name, title)
end

function Announce:Council(name, title)
  return speak(self, LINES.council, name, title)
end

function Announce:Prophet(name, title)
  return speak(self, LINES.prophet, name, title)
end

-- Test-only. Gated so a stray call in game cannot unlock duplicate spam.
function Announce:ResetForTests()
  if not COB._IN_TEST then return false end
  sentAt = {}
  sentCount = 0
  return true
end
