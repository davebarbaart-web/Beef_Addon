ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Director Console / Pope's Desk (Bible §18.1–18.3, §20.2). Event Mode Pope
-- working tool, player-opened (/beef console); not Quiet congregation chrome.
--
-- A Gathering is a state. A Knighting is a state. A Gora is a state. The desk
-- paints a view-model from Runtime + Gora + Knighting + local selection; frame
-- visibility is never the source of truth. Tabs (stock buttons, not a tab
-- template) separate live direction (Gathering) from administration (Nights,
-- Chronicle, Church). Census leaves the live rite. Nights compose lives on
-- the Nights tab: stock choice/cycle pickers, not typed codes. Mark this
-- moment is a shell utility.
--
-- The current WoW target is not the selected Church member. A target change
-- updates the preview; it does not silently replace a locked candidate or a
-- sanctioned pair. Verbs with no explicit id use the locked candidate, then
-- the working subject. A named stranger is recognised on the verb through
-- Store:EnsureCharacterByName (Bible §4.4, §12.2). Human refusals replace
-- engineer copy. No player-facing QUIET / ASSEMBLY / RITE / CONSEQUENCE names.
--
-- Law 10 functional: stock Blizzard templates, GameFont*, charcoal desk
-- ground via themeColor("charcoal"). The only ornaments are the title-bar
-- seal_papal (~20px) and the iron plate_verb / _hover / _pressed textures on
-- KNIGHT THIS BEEF and SANCTION BEEF GORA. Every other button stays stock.
-- Gold labels / oxblood destructive copy communicate hierarchy; red is not
-- used for every click.
--
-- Every verb is Pope-gated. Law 4: the desk never calls theater or the wire.
-- Cold tools left the UI; their Core modules keep their APIs. Rites surfaced
-- here: Knighting and Gora only. No GuildPromote. No Notebook persist.
--
-- ESC hides via UISpecialFrames + the OnHide remount pattern. Grip resize
-- clamps 520×440 and persists ChurchOfBeefDB.ui.console (point / size /
-- gatheringStartedAt / lastVerdict / knightingComplete).
-- No permanent OnUpdate.
local Console = {
  MODE = "Event",
}
COB.Console = Console

local FRAME_NAME = "ChurchOfBeefConsoleFrame"
local REFUSE = "not a registered pope"
local DEFAULT_WIDTH, DEFAULT_HEIGHT = 560, 600
local MIN_WIDTH, MIN_HEIGHT = 520, 440
local SCREEN_MARGIN = 40
local BTN_W, BTN_H, BTN_GAP = 172, 28, 8
local ROW_H = 20
local MUTE_EMPTY = 0.45
local congregationFavorVisible = true
local lastSeenEventId
local lastRefuse
local paintDesk
local themeSpace
local gatheringStartedAt
local candidateLocked = false
local fightersLocked = false
local selectedWinnerId
local selectedOutcome = "victor"
local lastVerdict
local knightingComplete
local pendingConfirm
local deskTab = "gathering"
local decreeBusy = false
local targetPreview
-- Nights tab compose. Stock cycle/choice buttons (no shared dropdown menu
-- templates — those taint). Typed fields stay Place / Note / Title only.
local nightsDesk = {
  churchKind = "gathering",
  weekday = nil,
  hour = 7,
  minute = 0,
  pm = true,
  stubKind = "raid",
  dateOffset = 0,
  WEEKDAYS = {
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday",
  },
  MINUTES = { 0, 15, 30, 45 },
  KIND_LABEL = {
    gathering = "Gathering",
    knighting = "Knighting",
    gora = "Gora",
  },
}

-- Human status copy. Never the Runtime names QUIET / ASSEMBLY / RITE / CONSEQUENCE.
local PHASE_HINT = {
  inactive = "The Church is not currently gathered.",
  active = "Open a rite.",
  knighting = "Knighting rite is live.",
  knightingDone = "The elevation is recorded.",
  goraSetup = "Prepare the combatants.",
  goraLive = "The Gora is sanctioned.",
  goraDone = "The Gora is decided.",
  other = "Leave this mode.",
  consequence = "Return to the gathering.",
}
local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

local function isId(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

local function localSender()
  if COB.Group and COB.Group.PlayerName then
    return COB.Group.PlayerName()
  end
  if type(UnitName) == "function" then
    return UnitName("player")
  end
  return nil
end

local function isRegisteredPope()
  local Sender = COB.Sender
  if not Sender or type(Sender.IsRegisteredPope) ~= "function" then
    return false
  end
  return Sender:IsRegisteredPope(localSender()) == true
end

local function canWriteStub()
  local Sender = COB.Sender
  if not Sender or type(Sender.CanWriteStub) ~= "function" then
    return false
  end
  return Sender:CanWriteStub(localSender()) == true
end

local function canOpenDesk()
  return isRegisteredPope() or canWriteStub()
end

local function nameKey(name)
  return COB.Names and COB.Names.Key(name) or nil
end

local function namesSame(a, b)
  return COB.Names and COB.Names.Same(a, b) or false
end

local function rankTitle(rankId)
  if rankId == nil then return nil end
  if COB.Ranks and COB.Ranks.Title then
    return COB.Ranks.Title(rankId)
  end
  return nil
end

local function titleId(name)
  if not (COB.Ranks and type(COB.Ranks.IdForTitle) == "function") then
    return nil
  end
  return COB.Ranks.IdForTitle(name)
end

local function rosterGuildRankName(name)
  local Roster = COB.Roster
  if type(Roster) ~= "table" then return nil end
  if type(Roster.GetGuildRankName) == "function" then
    local ok, value = pcall(Roster.GetGuildRankName, Roster, name)
    if ok and type(value) == "string" and value ~= "" then return value end
  end
  if Roster.ready == true and type(Roster.members) == "table" then
    local key = nameKey(name)
    local entry = key and Roster.members[key]
    if type(entry) == "table" and type(entry.guildRankName) == "string" and entry.guildRankName ~= "" then
      return entry.guildRankName
    end
  end
  return nil
end

-- Store human rank wins, including an entered-but-unranked row. A matching
-- live guild title is display only when there is no store human.
local function displayedRank(human, guildRankName)
  if type(human) == "table" then
    local rankId = human.rankId
    local needs = rankId == nil or rankId == 1 or rankId == 2
    return rankId, rankTitle(rankId), needs
  end
  local rankId = titleId(guildRankName)
  if type(rankId) == "number" then
    return rankId, rankTitle(rankId), false
  end
  if type(guildRankName) == "string" and guildRankName ~= "" then
    return nil, guildRankName, false
  end
  return nil, nil, false
end

local function applyGuildDisplay(subject)
  if type(subject) ~= "table" then return subject end
  if subject.humanId ~= nil or subject.rankId ~= nil then return subject end
  if type(subject.name) ~= "string" then return subject end
  local rankId, title = displayedRank(nil, rosterGuildRankName(subject.name))
  if type(rankId) == "number" then
    subject.rankId = rankId
  end
  if type(title) == "string" then
    subject.rankTitle = title
  end
  return subject
end

local function trimText(text)
  if COB.Names and COB.Names.Trim then
    return COB.Names.Trim(text)
  end
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
end

function nightsDesk.reset()
  nightsDesk.churchKind = "gathering"
  nightsDesk.weekday = nil
  nightsDesk.hour = 7
  nightsDesk.minute = 0
  nightsDesk.pm = true
  nightsDesk.stubKind = "raid"
  nightsDesk.dateOffset = 0
end

function nightsDesk.dateFn()
  if type(date) == "function" then return date end
  if type(os) == "table" and type(os.date) == "function" then return os.date end
  return nil
end

function nightsDesk.nowParts()
  local fn = nightsDesk.dateFn()
  if fn then
    local ok, t = pcall(fn, "*t")
    if ok and type(t) == "table" and type(t.year) == "number" then
      return t
    end
  end
  return { year = 2026, month = 1, day = 1, wday = 5, hour = 19, min = 0 }
end

function nightsDesk.cycle(n, lo, hi, delta)
  local span = hi - lo + 1
  local i = ((n - lo) + delta) % span
  if i < 0 then i = i + span end
  return i + lo
end

function nightsDesk.weekdayNow()
  local w = nightsDesk.weekday
  if type(w) == "number" and w >= 1 and w <= 7 then
    return w
  end
  return nightsDesk.nowParts().wday or 5
end

function nightsDesk.clock()
  return string.format("%d:%02d %s", nightsDesk.hour, nightsDesk.minute,
    nightsDesk.pm and "PM" or "AM")
end

function nightsDesk.daysFromCivil(y, m, d)
  y = y - (m <= 2 and 1 or 0)
  local era = math.floor(y / 400)
  local yoe = y - era * 400
  local doy = math.floor((153 * (m + (m > 2 and -3 or 9)) + 2) / 5) + d - 1
  local doe = yoe * 365 + math.floor(yoe / 4) - math.floor(yoe / 100) + doy
  return era * 146097 + doe - 719468
end

function nightsDesk.tsFromParts(parts)
  if type(os) == "table" and type(os.time) == "function" then
    local ts = os.time({
      year = parts.year, month = parts.month, day = parts.day,
      hour = 12, min = 0, sec = 0,
    })
    if type(ts) == "number" then return ts end
  end
  local days = nightsDesk.daysFromCivil(parts.year, parts.month, parts.day)
  if type(days) ~= "number" then return nil end
  return days * 86400 + 12 * 3600
end

function nightsDesk.offsetParts(offset)
  if type(offset) ~= "number" then offset = 0 end
  local parts = nightsDesk.nowParts()
  local ts = nightsDesk.tsFromParts(parts)
  if type(ts) ~= "number" then return parts end
  local fn = nightsDesk.dateFn()
  if not fn then return parts end
  local ok, t = pcall(fn, "*t", ts + offset * 86400)
  if ok and type(t) == "table" and type(t.year) == "number" then
    return t
  end
  return parts
end

function nightsDesk.dateYmd(offset)
  if offset == nil then offset = nightsDesk.dateOffset end
  local t = nightsDesk.offsetParts(offset)
  return string.format("%04d-%02d-%02d", t.year, t.month, t.day)
end

function nightsDesk.dateLabel(offset)
  if offset == nil then offset = nightsDesk.dateOffset end
  local t = nightsDesk.offsetParts(offset)
  local fn = nightsDesk.dateFn()
  local ts = nightsDesk.tsFromParts(t)
  if fn and type(ts) == "number" then
    local ok, label = pcall(fn, "%a %d %b", ts)
    if ok and type(label) == "string" and label ~= "" then
      return label
    end
  end
  local name = nightsDesk.WEEKDAYS[t.wday] or ""
  return name:sub(1, 3) .. " " .. tostring(t.day)
end

function nightsDesk.weekdayLabel()
  return nightsDesk.WEEKDAYS[nightsDesk.weekdayNow()] or "Thursday"
end

function nightsDesk.bumpWeekday(delta)
  nightsDesk.weekday = nightsDesk.cycle(nightsDesk.weekdayNow(), 1, 7, delta)
end

function nightsDesk.bumpDate(delta)
  nightsDesk.dateOffset = nightsDesk.cycle(nightsDesk.dateOffset, 0, 27, delta)
end

function nightsDesk.bumpHour()
  nightsDesk.hour = nightsDesk.cycle(nightsDesk.hour, 1, 12, 1)
end

function nightsDesk.bumpMinute()
  local idx = 1
  local mins = nightsDesk.MINUTES
  for i = 1, #mins do
    if mins[i] == nightsDesk.minute then
      idx = i
      break
    end
  end
  nightsDesk.minute = mins[nightsDesk.cycle(idx, 1, #mins, 1)]
end

function nightsDesk.toggleAmPm()
  nightsDesk.pm = not nightsDesk.pm
end

function nightsDesk.refresh()
  Console:Refresh()
end

local function storeSnap()
  if not COB.Store or not COB.Store.Snapshot then return nil end
  return COB.Store:Snapshot()
end

local function presentCharacterIds()
  local set = {}
  local Roster = COB.Roster
  if not Roster or Roster.ready ~= true or type(Roster.members) ~= "table" then
    return set
  end
  local snap = storeSnap()
  local chars = snap and snap.characters or {}
  local complete = false
  if type(Roster.IsComplete) == "function" then
    complete = Roster:IsComplete() == true
  else
    complete = Roster.complete == true
  end
  if complete ~= true then
    for i = 1, #chars do
      local id = chars[i].id
      if id then set[id] = true end
    end
    return set
  end
  local byKey = {}
  for i = 1, #chars do
    local key = nameKey(chars[i].name)
    if key then byKey[key] = chars[i].id end
  end
  for key, _ in pairs(Roster.members) do
    local id = byKey[key]
    if id then set[id] = true end
  end
  return set
end

--------------------------------------------------------------------------------
-- Working subject
--------------------------------------------------------------------------------

local function rankFieldsFor(human)
  local rankId = human and human.rankId or nil
  local needs = false
  if human then
    needs = rankId == nil or rankId == 1 or rankId == 2
  end
  return rankId, rankTitle(rankId), needs
end

local function subjectFromRows(ch, human, source)
  local subject = { source = source, needsKnighting = false }
  if ch then
    subject.name = ch.name
    subject.characterId = ch.id
  end
  if human then
    subject.humanId = human.id
    if subject.name == nil and type(human.name) == "string" and human.name ~= "" then
      subject.name = human.name
    end
  end
  local rankId, title, needs = rankFieldsFor(human)
  subject.rankId = rankId
  subject.rankTitle = title
  subject.needsKnighting = needs
  return applyGuildDisplay(subject)
end

local function snapshotMaps()
  local snap = storeSnap()
  local chars = snap and snap.characters or {}
  local humans = snap and snap.humans or {}
  local humanById = {}
  for i = 1, #humans do
    humanById[humans[i].id] = humans[i]
  end
  return chars, humanById
end

-- Ids resolve through Names.Key against the store's characters (+ the linked
-- human), exactly like GetPresence. Name reuse picks the first-created row.
local function findCharacterByKey(chars, key)
  local found
  for i = 1, #chars do
    local row = chars[i]
    if type(row) == "table" and nameKey(row.name) == key then
      if not found or (isId(row.id) and row.id < found.id) then
        found = row
      end
    end
  end
  return found
end

local function subjectForCharacterId(characterId, source)
  local chars, humanById = snapshotMaps()
  for i = 1, #chars do
    if chars[i].id == characterId then
      local ch = chars[i]
      local human = isId(ch.humanId) and humanById[ch.humanId] or nil
      return subjectFromRows(ch, human, source)
    end
  end
  return { characterId = characterId, source = source, needsKnighting = false }
end

local function subjectForHumanId(humanId, source)
  local chars, humanById = snapshotMaps()
  local human = humanById[humanId]
  if not human then
    return { humanId = humanId, source = source, needsKnighting = false }
  end
  local ch
  local ids = human.characterIds
  if type(ids) == "table" and isId(ids[1]) then
    for i = 1, #chars do
      if chars[i].id == ids[1] then
        ch = chars[i]
        break
      end
    end
  end
  return subjectFromRows(ch, human, source)
end

local function subjectForTargetName(name, source)
  local key = nameKey(name)
  if not key then return nil end
  local chars, humanById = snapshotMaps()
  local ch = findCharacterByKey(chars, key)
  if ch then
    local human = isId(ch.humanId) and humanById[ch.humanId] or nil
    return subjectFromRows(ch, human, source)
  end
  local display = COB.Names and COB.Names.Display(name) or trimText(name)
  return applyGuildDisplay({ name = display, source = source, needsKnighting = false })
end

local function targetName()
  if type(UnitName) ~= "function" then return nil end
  local ok, name = pcall(UnitName, "target")
  if not ok or type(name) ~= "string" or name == "" then return nil end
  return name
end

-- NPCs are not congregation: when the client can say the target is not a
-- player, the desk treats it as no target (an NPC must never become a Church
-- record through ensure-on-verb). The harness has no UnitIsPlayer and the
-- guard falls open.
local function targetIsPlayer()
  if type(UnitIsPlayer) ~= "function" then return true end
  local ok, isPlayer = pcall(UnitIsPlayer, "target")
  if not ok then return true end
  return isPlayer ~= false
end

local function readTargetPreview()
  local name = targetName()
  if name and not targetIsPlayer() then
    name = nil
  end
  if not name then
    return nil
  end
  return subjectForTargetName(name, "target")
end

local function refreshTargetSubject(self)
  local preview = readTargetPreview()
  targetPreview = preview
  -- A locked candidate or sanctioned pair is ceremony selection, not the
  -- live WoW target. Target changes update the preview only.
  if candidateLocked == true then
    return
  end
  if preview then
    self.subject = preview
  elseif type(self.subject) == "table" and self.subject.source == "target" then
    self.subject = nil
  end
end

-- Class / level ride along only for a target-sourced subject, and only when
-- the client offers the reads. The harness has neither; that is fine.
local function targetClassLevel(subject)
  if type(subject) ~= "table" or subject.source ~= "target" then
    return nil, nil
  end
  local class, level
  if type(UnitClass) == "function" then
    local ok, c = pcall(UnitClass, "target")
    if ok and type(c) == "string" and c ~= "" then
      class = c
    end
  end
  if type(UnitLevel) == "function" then
    local ok, l = pcall(UnitLevel, "target")
    if ok and type(l) == "number" and l >= 1 then
      level = l
    end
  end
  return class, level
end

-- A verb that needs a store id from the working subject. A named stranger is
-- recognised on the spot: the store grows a fresh human + character, and the
-- subject is re-resolved so the next verb sees the rank. The ensure is a Core
-- write, so it is Pope-gated here as well as at the verbs — SetFighterA /
-- SetFighterB are selection-family and otherwise ungated. Selecting a subject
-- that already has ids never writes and stays ungated.
local function ensureSubjectId(self, kind)
  local subject = self.subject
  if type(subject) ~= "table" then return nil end
  if kind == "human" and isId(subject.humanId) then return subject.humanId end
  if kind == "character" and isId(subject.characterId) then return subject.characterId end
  if type(subject.name) ~= "string" or subject.name == "" then return nil end
  if not isRegisteredPope() then return nil, REFUSE end
  local Store = COB.Store
  if not Store or type(Store.EnsureCharacterByName) ~= "function" then return nil end
  local class, level = targetClassLevel(subject)
  local characterId, humanId = Store:EnsureCharacterByName({
    name = subject.name,
    class = class,
    level = level,
  })
  if not isId(characterId) then return nil end
  self.subject = subjectForCharacterId(characterId, subject.source)
  if kind == "human" then return self.subject.humanId end
  return self.subject.characterId
end

-- Rank fields go stale after a verb writes the store; re-resolve the subject
-- from its ids without touching source or a name-only pending stranger.
local function refreshSubjectRanks(self)
  local subject = self.subject
  if type(subject) ~= "table" then return end
  local refreshed
  if isId(subject.characterId) then
    refreshed = subjectForCharacterId(subject.characterId, subject.source)
  elseif isId(subject.humanId) then
    refreshed = subjectForHumanId(subject.humanId, subject.source)
  end
  if refreshed then
    if refreshed.name == nil then
      refreshed.name = subject.name
    end
    self.subject = refreshed
  end
end

--------------------------------------------------------------------------------
-- Frame plumbing: persist, clamp, ESC
--------------------------------------------------------------------------------

local function uiDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

local function parentWH()
  local parent = UIParent
  local w = parent and parent.GetWidth and parent:GetWidth()
  local h = parent and parent.GetHeight and parent:GetHeight()
  if type(w) ~= "number" or w <= 0 then w = nil end
  if type(h) ~= "number" or h <= 0 then h = nil end
  return w, h
end

local function clampFrameSize(w, h)
  if type(w) ~= "number" or w ~= w then w = DEFAULT_WIDTH end
  if type(h) ~= "number" or h ~= h then h = DEFAULT_HEIGHT end
  if w < MIN_WIDTH then w = MIN_WIDTH end
  if h < MIN_HEIGHT then h = MIN_HEIGHT end
  local pw, ph = parentWH()
  if pw then w = math.min(w, math.max(MIN_WIDTH, pw - SCREEN_MARGIN)) end
  if ph then h = math.min(h, math.max(MIN_HEIGHT, ph - SCREEN_MARGIN)) end
  return math.floor(w + 0.5), math.floor(h + 0.5)
end

local function savePoint(widget)
  local db = uiDb()
  if not db then return end
  local point, _, relativePoint, x, y = widget:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  local slot = db.console
  if type(slot) ~= "table" then slot = {} end
  slot.point = point
  slot.relativePoint = relativePoint or point
  slot.x = x
  slot.y = y
  db.console = slot
end

local function saveSize(widget)
  local db = uiDb()
  if not db or not widget then return end
  local slot = db.console
  if type(slot) ~= "table" then
    slot = {}
    db.console = slot
  end
  local w, h = widget:GetWidth(), widget:GetHeight()
  if type(w) ~= "number" or type(h) ~= "number" then return end
  w, h = clampFrameSize(w, h)
  slot.w = w
  slot.h = h
end

local function restoreSize(widget)
  if not widget then return end
  local db = uiDb()
  local slot = db and db.console
  local w, h = DEFAULT_WIDTH, DEFAULT_HEIGHT
  if type(slot) == "table" then
    if type(slot.w) == "number" then w = slot.w end
    if type(slot.h) == "number" then h = slot.h end
  end
  w, h = clampFrameSize(w, h)
  widget:SetWidth(w)
  widget:SetHeight(h)
end

local function applyConsoleBounds(widget)
  if not widget then return end
  local pw, ph = parentWH()
  local maxW = pw and math.max(MIN_WIDTH, pw - SCREEN_MARGIN) or 1200
  local maxH = ph and math.max(MIN_HEIGHT, ph - SCREEN_MARGIN) or 1200
  if type(widget.SetResizeBounds) == "function" then
    widget:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT, maxW, maxH)
  else
    if type(widget.SetMinResize) == "function" then
      widget:SetMinResize(MIN_WIDTH, MIN_HEIGHT)
    end
    if type(widget.SetMaxResize) == "function" then
      widget:SetMaxResize(maxW, maxH)
    end
  end
end

local function restorePoint(widget)
  local db = uiDb()
  local p = db and db.console
  widget:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    widget:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    widget:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

-- ESC Hide via UISpecialFrames bypasses Console:Hide. Restore a missing
-- OnHide; never replace an existing script. The handler puts the target
-- listener to sleep (PLAYER_TARGET_CHANGED is shown-only) and remounts
-- rememberSpecial so ESC still re-lists. Do not reset the subject or the
-- pair. Do not wire OnShow.
local function wireConsoleOnHide(widget)
  if not widget then return end
  if type(widget.SetScript) ~= "function" then return end
  local existing = type(widget.GetScript) == "function" and widget:GetScript("OnHide")
  if existing then return end
  widget:SetScript("OnHide", function()
    if type(widget.UnregisterEvent) == "function" then
      widget:UnregisterEvent("PLAYER_TARGET_CHANGED")
    end
    rememberSpecial(FRAME_NAME)
  end)
end

--------------------------------------------------------------------------------
-- Stock widget factories
--------------------------------------------------------------------------------

local function header(parent, text, template)
  local fs = parent:CreateFontString(nil, "OVERLAY", template or "GameFontNormal")
  fs:SetText(text)
  fs:SetJustifyH("LEFT")
  return fs
end

themeSpace = function(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
  return fallback
end

local function muteEmpty(fs, isEmpty)
  if not fs or type(fs.SetAlpha) ~= "function" then return end
  if isEmpty then
    fs:SetAlpha(MUTE_EMPTY)
  else
    fs:SetAlpha(1)
  end
end

local function stockButton(parent, label, onClick)
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btn:SetWidth(BTN_W)
  btn:SetHeight(BTN_H)
  btn:SetText(label)
  btn:SetScript("OnClick", onClick)
  return btn
end

local function themeColor(role)
  local Theme = COB.Theme
  if type(Theme) ~= "table" or type(Theme.Color) ~= "function" then
    return nil
  end
  return Theme:Color(role)
end

local function colorize(fs, role)
  -- FontStrings only. Button:SetTextColor is not a Classic panel API and
  -- the harness stub treats it as a hard error on Buttons.
  if not fs or fs._type == "Button" then return end
  if type(fs.SetTextColor) ~= "function" then return end
  local r, g, b = themeColor(role)
  if type(r) == "number" then
    fs:SetTextColor(r, g, b)
  end
end

-- Gold primary / silver secondary / oxblood destructive. The FontString
-- lives on the stock panel button (GetFontString); never colorize the Button.
local function styleVerb(btn, role)
  if not btn then return end
  local fs
  if type(btn.GetFontString) == "function" then
    fs = btn:GetFontString()
  end
  colorize(fs, role)
  btn._cobStyle = role
end

local function applyButtonHierarchy(frame, view)
  if not frame then return end
  local tab = view and view.tab
  styleVerb(frame.TabGathering, tab == "gathering" and "gold" or "silver")
  styleVerb(frame.TabDecrees, tab == "decrees" and "gold" or "silver")
  styleVerb(frame.TabChronicle, tab == "chronicle" and "gold" or "silver")
  styleVerb(frame.TabChurch, tab == "church" and "gold" or "silver")

  styleVerb(frame.StartGathering, "gold")
  styleVerb(frame.KnightThisBeef, "gold")
  styleVerb(frame.ElevateToLord, "gold")
  styleVerb(frame.Sanction, "gold")
  styleVerb(frame.RecordVerdict, "gold")
  styleVerb(frame.PostDecree, "silver")
  if frame.PostStub then styleVerb(frame.PostStub, "gold") end
  if frame.PostSeries then styleVerb(frame.PostSeries, "gold") end
  if frame.SkipWeek then styleVerb(frame.SkipWeek, "silver") end
  if frame.MoveWeek then styleVerb(frame.MoveWeek, "silver") end
  if frame.WithdrawSeries then styleVerb(frame.WithdrawSeries, "oxblood") end
  if frame.WithdrawStub then styleVerb(frame.WithdrawStub, "oxblood") end
  if frame.ChurchKindGathering then
    styleVerb(frame.ChurchKindGathering, nightsDesk.churchKind == "gathering" and "gold" or "silver")
  end
  if frame.ChurchKindKnighting then
    styleVerb(frame.ChurchKindKnighting, nightsDesk.churchKind == "knighting" and "gold" or "silver")
  end
  if frame.ChurchKindGora then
    styleVerb(frame.ChurchKindGora, nightsDesk.churchKind == "gora" and "gold" or "silver")
  end
  if frame.StubKindRaid then
    styleVerb(frame.StubKindRaid, nightsDesk.stubKind == "raid" and "gold" or "silver")
  end
  if frame.StubKindPvp then
    styleVerb(frame.StubKindPvp, nightsDesk.stubKind == "pvp" and "gold" or "silver")
  end
  styleVerb(frame.ConfirmOk, "gold")
  styleVerb(frame.DeclareVictor, "gold")

  styleVerb(frame.OpenKnighting, "silver")
  styleVerb(frame.OpenGora, "silver")
  styleVerb(frame.SelectCandidate, "silver")
  styleVerb(frame.AddToLine, "silver")
  styleVerb(frame.FighterA, "silver")
  styleVerb(frame.FighterB, "silver")
  styleVerb(frame.FreeRuling, "silver")
  styleVerb(frame.ContinueBtn, "silver")
  styleVerb(frame.ReturnGathering, "silver")
  styleVerb(frame.ConfirmCancel, "silver")
  styleVerb(frame.MarkMoment, "silver")

  styleVerb(frame.EndGathering, "oxblood")
  styleVerb(frame.CloseRite, "oxblood")
  styleVerb(frame.VoidRuling, "oxblood")
  styleVerb(frame.WithdrawDecree, "oxblood")
  styleVerb(frame.CowardiceRecorded, "oxblood")

  if frame.PairVictorA then
    local id = frame.PairVictorA._cobVictorId
    local on = isId(selectedWinnerId) and selectedWinnerId == id
    styleVerb(frame.PairVictorA, on and "gold" or "silver")
  end
  if frame.PairVictorB then
    local id = frame.PairVictorB._cobVictorId
    local on = isId(selectedWinnerId) and selectedWinnerId == id
    styleVerb(frame.PairVictorB, on and "gold" or "silver")
  end

  colorize(frame.CongregationFavorLabel, "silver")
  if frame.KnightingStrip then colorize(frame.KnightingStrip.head, "gold") end
  if frame.PetitionStrip then colorize(frame.PetitionStrip.head, "gold") end
  if frame.PresenceStrip then colorize(frame.PresenceStrip.head, "gold") end
  if frame.ChronicleStrip then colorize(frame.ChronicleStrip.head, "gold") end
end

local function themeTexture(name)
  local Theme = COB.Theme
  if type(Theme) ~= "table" or type(Theme.Texture) ~= "function" then
    return nil
  end
  return Theme:Texture(name)
end

local function applyThemeTexture(tex, name)
  local path = themeTexture(name)
  if not tex or type(path) ~= "string" then return false end
  if type(tex.SetTexture) == "function" then
    pcall(tex.SetTexture, tex, path)
  end
  tex._cobTexture = path
  return true
end

-- Iron plates: Theme plate paths as button textures. KNIGHT THIS BEEF and
-- SANCTION BEEF GORA only. Missing Theme leaves stock chrome.
local function plateVerb(btn)
  if not btn then return btn end
  local normal = themeTexture("plate_verb")
  local hover = themeTexture("plate_verb_hover")
  local pressed = themeTexture("plate_verb_pressed")
  if type(normal) == "string" and type(btn.SetNormalTexture) == "function" then
    pcall(btn.SetNormalTexture, btn, normal)
    btn._cobNormalTexture = normal
  end
  if type(hover) == "string" and type(btn.SetHighlightTexture) == "function" then
    pcall(btn.SetHighlightTexture, btn, hover)
    btn._cobHighlightTexture = hover
  end
  if type(pressed) == "string" and type(btn.SetPushedTexture) == "function" then
    pcall(btn.SetPushedTexture, btn, pressed)
    btn._cobPushedTexture = pressed
  end
  return btn
end

local function stockEdit(parent, width)
  local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
  box:SetWidth(width or 200)
  box:SetHeight(22)
  box:SetAutoFocus(false)
  if type(box.SetScript) == "function" then
    box:SetScript("OnEscapePressed", function(self)
      if type(self.ClearFocus) == "function" then
        self:ClearFocus()
      end
    end)
  end
  return box
end

local function stockCheck(parent, label)
  local btn
  local ok, created = pcall(CreateFrame, "CheckButton", nil, parent, "UICheckButtonTemplate")
  if ok and created then
    btn = created
  else
    btn = CreateFrame("CheckButton", nil, parent)
  end
  btn:SetWidth(26)
  btn:SetHeight(26)
  btn:SetChecked(true)
  btn:SetScript("OnClick", function(self)
    if not isRegisteredPope() then
      self:SetChecked(congregationFavorVisible)
      return
    end
    Console:SetCongregationFavorVisible(self:GetChecked() == true)
  end)
  local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  fs:SetText(label)
  fs:SetJustifyH("LEFT")
  return btn, fs
end

--------------------------------------------------------------------------------
-- Strips: compact stock lists with a per-row action
--------------------------------------------------------------------------------

local function buildStrip(parent, headerText, emptyText)
  local strip = {}
  strip.head = header(parent, headerText)
  strip.body = CreateFrame("Frame", nil, parent)
  strip.empty = strip.body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  strip.empty:SetPoint("TOPLEFT", strip.body, "TOPLEFT", 4, -2)
  strip.empty:SetJustifyH("LEFT")
  strip.empty:SetText(emptyText)
  strip.emptyText = emptyText
  strip.rows = {}
  return strip
end

local function acquireStripRow(frame, strip, i)
  local btn = strip.rows[i]
  if btn then return btn end
  btn = CreateFrame("Button", nil, strip.body)
  btn:SetHeight(ROW_H)
  local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  fs:SetPoint("LEFT", btn, "LEFT", 4, 0)
  fs:SetJustifyH("LEFT")
  btn:SetFontString(fs)
  btn.Label = fs
  local action = CreateFrame("Button", nil, btn, "UIPanelButtonTemplate")
  action:SetWidth(64)
  action:SetHeight(18)
  action:SetPoint("RIGHT", btn, "RIGHT", -2, 0)
  action._cobVerb = true
  frame.GatedButtons[#frame.GatedButtons + 1] = action
  btn.Action = action
  strip.rows[i] = btn
  return btn
end

-- config: lineOf(row), onRow(row), actionLabel(row) or nil, onAction(row),
-- dimOf(row) or nil. Row clicks set the working subject; the action button
-- carries the row's verb (Skip / Dismiss / +line).
local function paintStrip(frame, strip, rows, config)
  local body = strip.body
  local width = (body.GetWidth and body:GetWidth()) or 300
  if #rows == 0 then
    for i = 1, #strip.rows do
      local leftover = strip.rows[i]
      leftover:Hide()
      if leftover.SetAlpha then leftover:SetAlpha(1) end
    end
    strip.empty:SetText(strip.emptyText)
    muteEmpty(strip.empty, true)
    strip.empty:Show()
    body:SetHeight(ROW_H + 4)
    return
  end
  strip.empty:Hide()
  for i = 1, #rows do
    local row = rows[i]
    local btn = acquireStripRow(frame, strip, i)
    btn:SetWidth(width)
    btn:ClearAllPoints()
    btn:SetPoint("TOPLEFT", body, "TOPLEFT", 0, -((i - 1) * ROW_H))
    local label = config.lineOf(row)
    btn:SetText(label)
    if btn.Label then btn.Label:SetText(label) end
    btn._row = row
    btn:SetScript("OnClick", function(b)
      config.onRow(b._row)
    end)
    local actionLabel = config.actionLabel and config.actionLabel(row) or nil
    if actionLabel then
      btn.Action:SetText(actionLabel)
      btn.Action._row = row
      btn.Action:SetScript("OnClick", function(b)
        config.onAction(b._row)
      end)
      btn.Action:Show()
      if btn.Label then btn.Label:SetWidth(math.max(32, width - 76)) end
    else
      btn.Action:Hide()
      if btn.Label then btn.Label:SetWidth(math.max(32, width - 8)) end
    end
    if btn.SetAlpha then
      if config.dimOf and config.dimOf(row) then
        btn:SetAlpha(0.45)
      else
        btn:SetAlpha(1)
      end
    end
    btn:Show()
  end
  for i = #rows + 1, #strip.rows do
    local leftover = strip.rows[i]
    leftover:Hide()
    if leftover.SetAlpha then leftover:SetAlpha(1) end
  end
  body:SetHeight(math.max(ROW_H, #rows * ROW_H))
end

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

local function layoutDesk(widget)
  if not widget or not widget.DeskChild then return end
  local gutter = themeSpace("md", 16)
  local inner = widget:GetWidth()
  if type(inner) == "number" and inner > gutter * 2 then
    widget.DeskChild:SetWidth(inner - gutter * 2)
  end
end

local function onConsoleSizeChanged(widget)
  if not widget or widget._cobClamping then return end
  local w, h = widget:GetWidth(), widget:GetHeight()
  local cw, ch = clampFrameSize(w, h)
  if cw ~= w or ch ~= h then
    widget._cobClamping = true
    widget:SetWidth(cw)
    widget:SetHeight(ch)
    widget._cobClamping = false
  end
  layoutDesk(widget)
  paintDesk(widget)
end

local function placeAt(widget, parent, x, y)
  if not widget then return end
  if widget.ClearAllPoints then widget:ClearAllPoints() end
  widget:SetPoint("TOPLEFT", parent, "TOPLEFT", x, -y)
end

local function placeRightAt(widget, parent, y)
  if not widget then return end
  if widget.ClearAllPoints then widget:ClearAllPoints() end
  widget:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -y)
end

local function placeRowAt(parent, y, buttons)
  for i = 1, #buttons do
    placeAt(buttons[i], parent, (i - 1) * (BTN_W + BTN_GAP), y)
    buttons[i]:Show()
  end
  return y + BTN_H + BTN_GAP
end

local function setShown(widget, shown)
  if not widget then return end
  if shown then
    if widget.Show then widget:Show() end
  else
    if widget.Hide then widget:Hide() end
  end
end

local function currentSnap()
  if not COB.Runtime or type(COB.Runtime.Snapshot) ~= "function" then
    return nil
  end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then return nil end
  return snap
end

local function currentState(snap)
  if type(snap) == "table" and type(snap.state) == "string" and snap.state ~= "" then
    return snap.state
  end
  return "QUIET"
end

local function currentEventId()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then return nil end
  return snap.eventId
end

local function goraRecordLine(characterId)
  if not isId(characterId) or not COB.Store or type(COB.Store.GetCharacter) ~= "function" then
    return nil
  end
  local ch = COB.Store:GetCharacter(characterId)
  if type(ch) ~= "table" or type(ch.gora) ~= "table" then
    return "0-0"
  end
  local wins, losses = ch.gora.wins, ch.gora.losses
  if type(wins) ~= "number" then wins = 0 end
  if type(losses) ~= "number" then losses = 0 end
  return tostring(wins) .. "-" .. tostring(losses)
end

local function promotionFor(rankId)
  if rankId == nil or rankId == 1 or rankId == 2 then
    return {
      kind = "knight",
      label = "KNIGHT THIS BEEF",
      fromTitle = rankTitle(rankId) or "Unrecorded",
      toTitle = rankTitle(3) or "Beef Knight",
    }
  end
  if rankId == 3 then
    return {
      kind = "elevate",
      label = "Elevate to Lord",
      fromTitle = rankTitle(3) or "Beef Knight",
      toTitle = rankTitle(4) or "Beef Lord",
    }
  end
  return nil
end

local function wallNow()
  if COB.Clock and type(COB.Clock.Wall) == "function" then
    return COB.Clock.Wall()
  end
  if type(time) == "function" then
    return time()
  end
  return 0
end

local function formatElapsed(started)
  if type(started) ~= "number" then return "00:00:00" end
  local sec = math.floor(wallNow() - started)
  if sec < 0 then sec = 0 end
  local h = math.floor(sec / 3600)
  local m = math.floor((sec % 3600) / 60)
  local s = sec % 60
  return string.format("%02d:%02d:%02d", h, m, s)
end

local function persistSession()
  local db = uiDb()
  if not db then return end
  local slot = db.console
  if type(slot) ~= "table" then
    slot = {}
    db.console = slot
  end
  slot.gatheringStartedAt = gatheringStartedAt
  if type(lastVerdict) == "table" then
    slot.lastVerdict = {
      ruling = lastVerdict.ruling,
      winnerId = lastVerdict.winnerId,
      fleerId = lastVerdict.fleerId,
      text = lastVerdict.text,
    }
  else
    slot.lastVerdict = nil
  end
  if type(knightingComplete) == "table" then
    slot.knightingComplete = {
      name = knightingComplete.name,
      toTitle = knightingComplete.toTitle,
      humanId = knightingComplete.humanId,
    }
  else
    slot.knightingComplete = nil
  end
end

local function persistStartedAt(at)
  gatheringStartedAt = at
  persistSession()
end

local function restoreStartedAt()
  local db = uiDb()
  local slot = db and db.console
  if type(slot) == "table" and type(slot.gatheringStartedAt) == "number" then
    return slot.gatheringStartedAt
  end
  return nil
end

local function restoreSession()
  local db = uiDb()
  local slot = db and db.console
  if type(slot) ~= "table" then return end
  if gatheringStartedAt == nil and type(slot.gatheringStartedAt) == "number" then
    gatheringStartedAt = slot.gatheringStartedAt
  end
  if lastVerdict == nil and type(slot.lastVerdict) == "table" then
    lastVerdict = slot.lastVerdict
  end
  if knightingComplete == nil and type(slot.knightingComplete) == "table" then
    knightingComplete = slot.knightingComplete
  end
end

-- After /reload the locals are gone. Core + ui.console still know the gathering.
local function rehydrateDesk(self)
  restoreSession()
  local pair
  if COB.Gora and type(COB.Gora.GetSanctioned) == "function" then
    pair = COB.Gora:GetSanctioned()
  end
  if type(pair) == "table" and isId(pair.fighterA) and isId(pair.fighterB) then
    fightersLocked = true
    if not isId(self.selectedFighterA) then self.selectedFighterA = pair.fighterA end
    if not isId(self.selectedFighterB) then self.selectedFighterB = pair.fighterB end
  end
  local snap = currentSnap()
  if type(snap) == "table" and snap.riteType == "Knighting" then
    candidateLocked = true
    local cand = type(snap.subjects) == "table" and snap.subjects.candidate or nil
    if isId(cand) and type(self.subject) ~= "table" then
      self.subject = subjectForHumanId(cand, "selection")
    end
  end
end

local TABS = { gathering = true, decrees = true, chronicle = true, church = true }

local function syncCongregationToggle()
  local eventId = currentEventId()
  if eventId ~= lastSeenEventId then
    lastSeenEventId = eventId
    congregationFavorVisible = true
  end
end

local function characterName(id)
  if not isId(id) then return nil end
  local snap = storeSnap()
  local chars = snap and snap.characters or {}
  for i = 1, #chars do
    if chars[i].id == id then return chars[i].name end
  end
  return tostring(id)
end

local function raidHealthProposal()
  if not (COB.Gora and type(COB.Gora.GetProposal) == "function") then
    return nil
  end
  local proposal = COB.Gora:GetProposal()
  if type(proposal) ~= "table" then return nil end
  if proposal.ruling ~= "victor" or not isId(proposal.winnerId) then return nil end
  return proposal
end

local function armProposedWinner()
  local proposal = raidHealthProposal()
  if not proposal then return end
  if selectedWinnerId == nil then
    selectedWinnerId = proposal.winnerId
  end
  if deskTab ~= "gathering" then
    deskTab = "gathering"
  end
end

-- Stock highlight lock + label: the gold plate is waiting for a tap.
-- No pulse, no sound, no auto-declare.
local function paintArmedDeclare(frame)
  local btn = frame.DeclareVictor
  if not btn then return end
  local proposal = raidHealthProposal()
  local shown = btn.IsShown and btn:IsShown()
  if proposal and shown then
    if btn.LockHighlight then btn:LockHighlight() end
    btn._cobArmed = true
    if frame.OutcomeLabel and frame.OutcomeLabel.IsShown and frame.OutcomeLabel:IsShown() then
      frame.OutcomeLabel:SetText("Proposed victor — tap DECLARE VICTOR")
    end
    return
  end
  if btn.UnlockHighlight then btn:UnlockHighlight() end
  btn._cobArmed = nil
end

local function censusLine(row)
  local title = row.rankTitle or "Unrecorded"
  local count = row.count
  if type(count) ~= "number" then count = 0 end
  return title .. "  " .. tostring(count)
end

local function h2hScore(characterId, opponentId)
  if not isId(characterId) or not isId(opponentId) then return nil end
  if not COB.Store or type(COB.Store.GetCharacter) ~= "function" then return nil end
  local ch = COB.Store:GetCharacter(characterId)
  if type(ch) ~= "table" or type(ch.gora) ~= "table" then return nil end
  local list = ch.gora.headToHeads
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and row.opponentId == opponentId then
      local wins = row.wins
      local losses = row.losses
      if type(wins) ~= "number" then wins = 0 end
      if type(losses) ~= "number" then losses = 0 end
      return tostring(wins) .. "-" .. tostring(losses)
    end
  end
  return nil
end

local function petitionLine(row)
  local left
  if type(row.name) == "string" and row.name ~= "" then
    left = row.name
  else
    left = characterName(row.characterId) or row.senderKey or tostring(row.characterId)
  end
  if row.namedOpponentId ~= nil then
    local right = characterName(row.namedOpponentId) or tostring(row.namedOpponentId)
    local line = left .. "  names  " .. right
    local score = h2hScore(row.characterId, row.namedOpponentId)
    if score then
      line = line .. "  " .. score
    end
    if isId(Console.selectedFighterA) and isId(Console.selectedFighterB) then
      line = line .. "  use this petitioner"
    end
    return line
  end
  if isId(Console.selectedFighterA) and isId(Console.selectedFighterB) then
    return left .. "  use this petitioner"
  end
  return left
end

local function knightingLine(row)
  if type(row.name) == "string" and row.name ~= "" then
    return row.name
  end
  if row.humanId ~= nil then
    return tostring(row.humanId)
  end
  return ""
end

--------------------------------------------------------------------------------
-- Paint
--------------------------------------------------------------------------------

local function liveSanctionedPair()
  local Gora = COB.Gora
  if not (Gora and type(Gora.GetSanctioned) == "function") then return nil end
  local pair = Gora:GetSanctioned()
  if type(pair) ~= "table" then return nil end
  if not isId(pair.fighterA) or not isId(pair.fighterB) then return nil end
  return pair
end

-- Canonical desk view. Derived from Core + session locks, never from widgets.
local function deskView()
  local snap = currentSnap()
  local state = currentState(snap)
  local riteType = type(snap) == "table" and snap.riteType or nil
  local pair = liveSanctionedPair()
  local gathering = (state ~= "QUIET") and "active" or "inactive"
  local rite = nil
  local goraPhase = nil
  local knightingPhase = nil
  if state == "RITE" or state == "CONSEQUENCE" then
    if riteType == "Knighting" then
      rite = "knighting"
      knightingPhase = knightingComplete and "complete" or "live"
    elseif riteType == "Gora" then
      rite = "gora"
      if lastVerdict then
        goraPhase = "complete"
      elseif pair then
        goraPhase = "sanctioned"
      else
        goraPhase = "setup"
      end
    elseif type(riteType) == "string" then
      rite = "other"
    end
  elseif pair and gathering == "active" then
    rite = "gora"
    goraPhase = lastVerdict and "complete" or "sanctioned"
  end
  if gathering == "inactive" then
    rite = nil
    goraPhase = nil
    knightingPhase = nil
  end
  local tab = deskTab
  if not TABS[tab] then tab = "gathering" end
  return {
    tab = tab,
    gathering = gathering,
    rite = rite,
    goraPhase = goraPhase,
    knightingPhase = knightingPhase,
    runtimeState = state,
    riteType = riteType,
    sanctioned = pair,
  }
end

local function subjectLine(subject, empty)
  if type(subject) ~= "table" or type(subject.name) ~= "string" or subject.name == "" then
    return empty
  end
  local line = subject.name
  if type(subject.rankTitle) == "string" and subject.rankTitle ~= "" then
    line = line .. " · " .. subject.rankTitle
  end
  return line
end

local function paintTargetLine(frame, subject, view)
  if not frame.TargetLine then return end
  local preview = targetPreview
  if candidateLocked == true then
    local selected = subjectLine(subject, nil)
    local live = subjectLine(preview, nil)
    if selected and live and live ~= selected then
      frame.TargetLine:SetText("Selected: " .. selected .. "   Current target: " .. live)
    elseif selected then
      frame.TargetLine:SetText("Selected: " .. selected)
    else
      frame.TargetLine:SetText("Current target: " .. (live or "none"))
    end
    return
  end
  local proposal = raidHealthProposal()
  if proposal then
    local name = characterName(proposal.winnerId) or "?"
    frame.TargetLine:SetText("Proposed victor: " .. name .. ". DECLARE VICTOR to ratify.")
    return
  end
  if type(subject) ~= "table" or type(subject.name) ~= "string" or subject.name == "" then
    if view and view.goraPhase == "sanctioned" then
      frame.TargetLine:SetText("Select the victor, then RECORD VERDICT.")
    else
      frame.TargetLine:SetText("Target a guildmate, then select them.")
    end
    return
  end
  local line = "Current target: " .. subject.name
  if type(subject.rankTitle) == "string" and subject.rankTitle ~= "" then
    line = line .. " · " .. subject.rankTitle
  end
  if subject.needsKnighting == true then
    line = line .. "  needs Knighting"
  end
  frame.TargetLine:SetText(line)
end

-- The pair line and its clickable names (select only) show the slots as they stand
-- (one slot may still be empty); with both slots empty and a Gora live they
-- fall back to the live sanctioned pair (a reload forgets the slots). The
-- leftover last pair is persist, not the next rite — never a paint source.
local function pairForDisplay()
  local a = isId(Console.selectedFighterA) and Console.selectedFighterA or nil
  local b = isId(Console.selectedFighterB) and Console.selectedFighterB or nil
  if a or b then
    return a, b
  end
  local Gora = COB.Gora
  if Gora and type(Gora.GetSanctioned) == "function" then
    local pair = Gora:GetSanctioned()
    if type(pair) == "table" then
      return pair.fighterA, pair.fighterB
    end
  end
  return nil, nil
end

local function paintPairLine(frame, a, b)
  if not frame.PairLine then return end
  local nameA = isId(a) and characterName(a) or "—"
  local nameB = isId(b) and characterName(b) or "—"
  frame.PairLine:SetText("A: " .. nameA .. "  vs  B: " .. nameB)
end

local function paintFavor(frame)
  if not frame then return end
  local split = Console:GetFavorSplit()
  local pairA, pairB = pairForDisplay()
  local nameA = isId(pairA) and characterName(pairA) or "Fighter A"
  local nameB = isId(pairB) and characterName(pairB) or "Fighter B"
  if frame.FavorSplit then
    frame.FavorSplit:SetText(tostring(split.a) .. " / " .. tostring(split.b))
  end
  if frame.FavorCount then
    frame.FavorCount:SetText(tostring(Console:GetFavorCount()))
  end
  if frame.FavorNameA then
    frame.FavorNameA:SetText(nameA .. "  " .. tostring(split.a))
  end
  if frame.FavorNameB then
    frame.FavorNameB:SetText(nameB .. "  " .. tostring(split.b))
  end
  if frame.FavorBar then
    local total = (split.a or 0) + (split.b or 0)
    local filled = 0
    if total > 0 then
      filled = math.floor((split.a / total) * 16 + 0.5)
    else
      filled = 8
    end
    if filled < 0 then filled = 0 end
    if filled > 16 then filled = 16 end
    frame.FavorBar:SetText(string.rep("|", filled) .. string.rep(".", 16 - filled))
  end
  if frame.CongregationFavor then
    frame.CongregationFavor:SetChecked(congregationFavorVisible)
  end
end

local function paintOneStrip(frame, content, y, stripW, entry)
  local strip = entry.strip
  if not strip then return y end
  placeAt(strip.head, content, 0, y)
  y = y + 18
  placeAt(strip.body, content, 0, y)
  strip.body:SetWidth(stripW)
  paintStrip(frame, strip, entry.rows, entry)
  setShown(strip.head, true)
  setShown(strip.body, true)
  return y + (strip.body:GetHeight() or ROW_H) + themeSpace("sm", 8)
end

local function hideStrip(strip)
  if not strip then return end
  setShown(strip.head, false)
  setShown(strip.body, false)
end

local function waitingNeedsKnighting()
  local people = Console:GetPresence()
  local out = {}
  for i = 1, #people do
    local row = people[i]
    if row.needsKnighting == true and row.here == true then
      out[#out + 1] = row
    end
  end
  return out
end

local function congregationHere()
  local people = Console:GetPresence()
  local n = 0
  for i = 1, #people do
    if people[i].here == true then n = n + 1 end
  end
  return n
end

local function chronicleRows()
  local rows = {}
  if COB.Records and type(COB.Records.ChroniclePreview) == "function" then
    local preview = COB.Records:ChroniclePreview(20)
    if type(preview) == "table" then
      for i = 1, #preview do
        rows[#rows + 1] = preview[i]
      end
    end
    return rows
  end
  if COB.Store and type(COB.Store.GetCeremonyLog) == "function" then
    local log = COB.Store:GetCeremonyLog()
    if type(log) == "table" then
      for i = #log, 1, -1 do
        local entry = log[i]
        if type(entry) == "table" then
          rows[#rows + 1] = {
            headline = entry.type or "Entry",
            body = entry.text,
            at = entry.at,
          }
        end
        if #rows >= 20 then break end
      end
    end
  end
  if COB.Store and type(COB.Store.GetMarkedMoments) == "function" then
    local marks = COB.Store:GetMarkedMoments()
    if type(marks) == "table" then
      for i = #marks, 1, -1 do
        local mark = marks[i]
        if type(mark) == "table" then
          rows[#rows + 1] = {
            headline = "Marked moment",
            body = mark.location,
            at = mark.at,
          }
        end
        if #rows >= 24 then break end
      end
    end
  end
  return rows
end

local function paintChronicleStrip(frame, rows)
  local strip = frame.ChronicleStrip
  if not strip then return end
  paintStrip(frame, strip, rows, {
    lineOf = function(row)
      local head = row.headline or row.type or "Entry"
      if type(row.body) == "string" and row.body ~= "" then
        return head .. " — " .. row.body
      end
      return head
    end,
    actionLabel = function() return nil end,
    onAction = function() end,
    onRow = function() end,
  })
end

local function hintFor(view)
  if view.tab ~= "gathering" then
    if view.tab == "decrees" then return "Post a Church night or a Discord notice." end
    if view.tab == "chronicle" then return "Church history." end
    return "Church census."
  end
  if view.gathering == "inactive" then return PHASE_HINT.inactive end
  if view.rite == "knighting" then
    return view.knightingPhase == "complete" and PHASE_HINT.knightingDone or PHASE_HINT.knighting
  end
  if view.rite == "gora" then
    if view.goraPhase == "complete" then return PHASE_HINT.goraDone end
    if view.goraPhase == "sanctioned" then return PHASE_HINT.goraLive end
    return PHASE_HINT.goraSetup
  end
  if view.rite == "other" then return PHASE_HINT.other end
  if view.runtimeState == "CONSEQUENCE" then return PHASE_HINT.consequence end
  return PHASE_HINT.active
end

local function paintSessionChrome(frame, view)
  local bar = frame.SessionBar
  if not bar then return end
  setShown(bar, true)
  if view.gathering == "inactive" then
    setShown(frame.StartGathering, true)
    setShown(frame.EndGathering, false)
    if frame.ChromeStatus then
      frame.ChromeStatus:SetText("Not gathered")
      colorize(frame.ChromeStatus, "silver")
      setShown(frame.ChromeStatus, true)
    end
    if frame.StartGathering.ClearAllPoints then frame.StartGathering:ClearAllPoints() end
    frame.StartGathering:SetPoint("RIGHT", bar, "RIGHT", 0, 0)
    return
  end
  setShown(frame.StartGathering, false)
  setShown(frame.EndGathering, true)
  local elapsed = formatElapsed(gatheringStartedAt or restoreStartedAt())
  local status = "ACTIVE  ·  " .. elapsed
  if view.rite == "gora" then
    status = "ACTIVE  ·  Gora  ·  " .. elapsed
  elseif view.rite == "knighting" then
    status = "ACTIVE  ·  Knighting  ·  " .. elapsed
  end
  if frame.ChromeStatus then
    frame.ChromeStatus:SetText(status)
    colorize(frame.ChromeStatus, "gold")
    setShown(frame.ChromeStatus, true)
  end
  if frame.EndGathering.ClearAllPoints then frame.EndGathering:ClearAllPoints() end
  frame.EndGathering:SetPoint("RIGHT", bar, "RIGHT", 0, 0)
end

local function paintTabs(frame, view)
  local pope = isRegisteredPope()
  local councilOnly = canWriteStub() and not pope
  local tabs = {
    { btn = frame.TabGathering, id = "gathering", pope = true },
    { btn = frame.TabDecrees, id = "decrees" },
    { btn = frame.TabChronicle, id = "chronicle", pope = true },
    { btn = frame.TabChurch, id = "church", pope = true },
  }
  for i = 1, #tabs do
    local tab = tabs[i]
    if tab.btn then
      local show = not councilOnly or tab.pope ~= true
      setShown(tab.btn, show)
      if tab.id == view.tab then
        if tab.btn.LockHighlight then tab.btn:LockHighlight() end
      else
        if tab.btn.UnlockHighlight then tab.btn:UnlockHighlight() end
      end
    end
  end
end

local function hideWorkflow(frame)
  local hide = {
    frame.StartGathering, frame.OpenKnighting, frame.OpenGora,
    frame.EndGathering, frame.CloseRite, frame.ContinueBtn,
    frame.KnightThisBeef, frame.AddToLine, frame.ElevateToLord,
    frame.SelectCandidate, frame.FighterA, frame.FighterB,
    frame.PairVictorA, frame.PairVictorB,
    frame.Sanction,
    frame.DeclareVictor, frame.CowardiceRecorded, frame.VoidRuling,
    frame.FreeRuling, frame.FreeRulingText, frame.RecordVerdict,
    frame.FavorLabel, frame.FavorSplit, frame.FavorCount,
    frame.FavorNameA, frame.FavorNameB, frame.FavorBar,
    frame.CongregationFavor, frame.CongregationFavorLabel,
    frame.DecreeHeader, frame.DecreeLineLabel, frame.DecreeLine,
    frame.DecreeFlavorLabel, frame.DecreeFlavor, frame.PostDecree, frame.PostStub,
    frame.DecreeCurrent, frame.WithdrawDecree,
    frame.PostSeries, frame.SkipWeek, frame.MoveWeek, frame.WithdrawSeries,
    frame.GoingNames, frame.WithdrawStub, frame.StubTitleLabel, frame.StubTitle,
    frame.RiteHead, frame.CandidateCard, frame.PromotionLine,
    frame.FighterAName, frame.FighterAMeta, frame.FighterBName, frame.FighterBMeta,
    frame.CompleteTitle, frame.CompleteBody, frame.ReturnGathering,
    frame.SessionLine, frame.CongregationLine, frame.HelperText,
    frame.OutcomeLabel, frame.ConfirmTitle, frame.ConfirmBody,
    frame.ConfirmCancel, frame.ConfirmOk, frame.ChurchHead,
    frame.ChronicleHead,
  }
  for i = 1, #hide do
    setShown(hide[i], false)
  end
  local nightsHide = frame._nightsHide
  if type(nightsHide) == "table" then
    for i = 1, #nightsHide do
      setShown(nightsHide[i], false)
    end
  end
  hideStrip(frame.KnightingStrip)
  hideStrip(frame.PetitionStrip)
  hideStrip(frame.PresenceStrip)
  hideStrip(frame.ChronicleStrip)
  setShown(frame.PairLine, false)
end

local function paintConfirm(frame, content, y)
  if type(pendingConfirm) ~= "table" then return y end
  setShown(frame.ConfirmTitle, true)
  setShown(frame.ConfirmBody, true)
  setShown(frame.ConfirmCancel, true)
  setShown(frame.ConfirmOk, true)
  frame.ConfirmTitle:SetText(pendingConfirm.title or "Confirm")
  frame.ConfirmBody:SetText(pendingConfirm.body or "")
  frame.ConfirmCancel:SetText(pendingConfirm.cancelLabel or "Cancel")
  frame.ConfirmOk:SetText(pendingConfirm.okLabel or "Confirm")
  colorize(frame.ConfirmTitle, "gold")
  placeAt(frame.ConfirmTitle, content, 0, y)
  y = y + 20
  placeAt(frame.ConfirmBody, content, 0, y)
  y = y + 36
  y = placeRowAt(content, y, { frame.ConfirmCancel, frame.ConfirmOk })
  return y
end

paintDesk = function(frame)
  if not frame then return end
  layoutDesk(frame)
  local content = frame.DeskChild or frame.Content
  if not content then return end
  local view = deskView()
  local subject = Console.subject
  local stripW = (content.GetWidth and content:GetWidth()) or 300

  hideWorkflow(frame)
  if frame.Sanction then
    local two = isId(Console.selectedFighterA) and isId(Console.selectedFighterB)
      and Console.selectedFighterA ~= Console.selectedFighterB
    if two and fightersLocked ~= true then
      frame.Sanction._cobOff = nil
    else
      frame.Sanction._cobOff = true
    end
  end
  paintTabs(frame, view)
  paintSessionChrome(frame, view)
  setShown(frame.MarkMoment, true)
  setShown(frame.PhaseHint, true)
  setShown(frame.TargetLine, view.tab == "gathering")
  colorize(frame.PhaseHint, "gold")

  if frame.PhaseHint then
    frame.PhaseHint:SetText(hintFor(view))
  end
  paintTargetLine(frame, subject, view)

  local pairA, pairB = pairForDisplay()
  paintPairLine(frame, pairA, pairB)

  local y = 0
  placeAt(frame.PhaseHint, content, 0, y)
  y = y + 18
  if view.tab == "gathering" then
    placeAt(frame.TargetLine, content, 0, y)
    y = y + 18
  end

  if pendingConfirm then
    y = paintConfirm(frame, content, y)
  elseif view.tab == "decrees" then
    y = Console._paintDecrees and Console._paintDecrees(frame, content, y) or y
  elseif view.tab == "chronicle" then
    y = Console._paintChronicle and Console._paintChronicle(frame, content, y, stripW) or y
  elseif view.tab == "church" then
    y = Console._paintChurch and Console._paintChurch(frame, content, y, stripW) or y
  else
    y = Console._paintGathering and Console._paintGathering(frame, content, y, view, stripW) or y
  end

  placeAt(frame.MarkMoment, content, 0, y)
  y = y + BTN_H + BTN_GAP
  if frame.GateStatus then
    placeAt(frame.GateStatus, content, 0, y)
    y = y + 16
  end

  applyButtonHierarchy(frame, view)
  paintArmedDeclare(frame)

  if content.SetHeight then
    content:SetHeight(math.max(80, y + themeSpace("sm", 8)))
  end
end

local function knightingQueueAction()
  return function(row)
    Console:SelectHuman(row.humanId)
    candidateLocked = true
    if deskView().gathering == "active" and deskView().rite == nil then
      Console:OpenRite("Knighting")
    else
      Console:Refresh()
    end
  end
end

function Console._paintGathering(frame, content, y, view, stripW)
  local subject = Console.subject
  local pairA, pairB = pairForDisplay()
  local sameFighters = isId(Console.selectedFighterA) and Console.selectedFighterA == Console.selectedFighterB
  local twoFighters = isId(Console.selectedFighterA) and isId(Console.selectedFighterB) and not sameFighters

  local function knightStrip()
    return {
      strip = frame.KnightingStrip,
      rows = (view.gathering == "inactive") and waitingNeedsKnighting() or Console:GetKnightingLine(),
      lineOf = knightingLine,
      actionLabel = function()
        return (view.gathering == "inactive") and "Review" or "Skip"
      end,
      onAction = function(row)
        if view.gathering == "inactive" then
          Console:SelectHuman(row.humanId)
          Console:Refresh()
        else
          Console:Skip(row.humanId)
        end
      end,
      onRow = function(row)
        Console:SelectHuman(row.humanId)
        if view.rite == "knighting" then
          candidateLocked = true
        end
        Console:Refresh()
      end,
    }
  end

  local function petitionStrip()
    return {
      strip = frame.PetitionStrip,
      rows = Console:GetPetitions(),
      lineOf = petitionLine,
      actionLabel = function()
        return (view.gathering == "inactive") and "Review" or "Dismiss"
      end,
      onAction = function(row)
        if view.gathering == "inactive" then
          Console:UsePetitioner(row)
        else
          Console:Dismiss(row.characterId or row.senderKey)
        end
      end,
      onRow = function(row)
        Console:UsePetitioner(row)
      end,
    }
  end

  if view.gathering == "inactive" then
    y = paintOneStrip(frame, content, y, stripW, knightStrip("Review"))
    y = paintOneStrip(frame, content, y, stripW, petitionStrip("Review"))
    return y
  end

  if view.rite == "knighting" and view.knightingPhase == "complete" then
    setShown(frame.CompleteTitle, true)
    setShown(frame.CompleteBody, true)
    setShown(frame.ReturnGathering, true)
    frame.CompleteTitle:SetText("THE CANDIDATE IS ELEVATED")
    colorize(frame.CompleteTitle, "gold")
    local done = knightingComplete
    local body = ""
    if type(done) == "table" then
      body = (done.name or "This Beef") .. "  →  " .. (done.toTitle or "")
    end
    frame.CompleteBody:SetText(body)
    placeAt(frame.CompleteTitle, content, 0, y)
    y = y + 20
    placeAt(frame.CompleteBody, content, 0, y)
    y = y + 22
    y = placeRowAt(content, y, { frame.ReturnGathering })
    return y
  end

  if view.rite == "knighting" then
    setShown(frame.RiteHead, true)
    frame.RiteHead:SetText("Gathering  ›  KNIGHTING  ·  LIVE")
    colorize(frame.RiteHead, "gold")
    placeAt(frame.RiteHead, content, 0, y)
    y = y + 20
    y = placeRowAt(content, y, { frame.CloseRite })
    setShown(frame.CandidateCard, true)
    local cand = subjectLine(subject, "No candidate selected")
    frame.CandidateCard:SetText("The candidate  " .. cand)
    placeAt(frame.CandidateCard, content, 0, y)
    y = y + 20
    local promo = promotionFor(subject and subject.rankId)
    if promo then
      setShown(frame.PromotionLine, true)
      frame.PromotionLine:SetText(promo.fromTitle .. "  →  " .. promo.toTitle)
      placeAt(frame.PromotionLine, content, 0, y)
      y = y + 18
    end
    setShown(frame.SelectCandidate, true)
    placeAt(frame.SelectCandidate, content, 0, y)
    y = y + BTN_H + BTN_GAP
    if promo and promo.kind == "knight" then
      y = placeRowAt(content, y, { frame.KnightThisBeef, frame.AddToLine })
      setShown(frame.AddToLine, type(subject) == "table" and subject.needsKnighting == true)
    elseif promo and promo.kind == "elevate" then
      y = placeRowAt(content, y, { frame.ElevateToLord })
    end
    y = paintOneStrip(frame, content, y, stripW, knightStrip("Choose"))
    return y
  end

  if view.rite == "gora" and view.goraPhase == "complete" then
    setShown(frame.CompleteTitle, true)
    setShown(frame.CompleteBody, true)
    setShown(frame.ReturnGathering, true)
    frame.CompleteTitle:SetText("THE GORA IS DECIDED")
    colorize(frame.CompleteTitle, "gold")
    local body = ""
    if type(lastVerdict) == "table" then
      if lastVerdict.ruling == "victor" then
        body = (characterName(lastVerdict.winnerId) or "A fighter") .. "  ·  Standard Victory"
      elseif lastVerdict.ruling == "cowardice" then
        body = (characterName(lastVerdict.fleerId) or "A fighter") .. "  ·  Cowardice"
      elseif lastVerdict.ruling == "void" then
        body = "Void"
      else
        body = "Free ruling"
        if type(lastVerdict.text) == "string" and lastVerdict.text ~= "" then
          body = body .. "  ·  " .. lastVerdict.text
        end
      end
      if isId(lastVerdict.winnerId) then
        local rec = goraRecordLine(lastVerdict.winnerId)
        if rec then body = body .. "  ·  Record now " .. rec end
      end
    end
    frame.CompleteBody:SetText(body)
    placeAt(frame.CompleteTitle, content, 0, y)
    y = y + 20
    placeAt(frame.CompleteBody, content, 0, y)
    y = y + 22
    local elevateVisible = type(subject) == "table" and subject.rankId == 3
    if elevateVisible then
      y = placeRowAt(content, y, { frame.ElevateToLord, frame.ReturnGathering })
    else
      y = placeRowAt(content, y, { frame.ReturnGathering })
    end
    return y
  end

  if view.rite == "gora" and view.goraPhase == "sanctioned" then
    setShown(frame.RiteHead, true)
    frame.RiteHead:SetText("Gathering  ›  BEEF GORA  ·  SANCTIONED")
    colorize(frame.RiteHead, "gold")
    placeAt(frame.RiteHead, content, 0, y)
    y = y + 20
    y = placeRowAt(content, y, { frame.CloseRite })
    if isId(pairA) then
      setShown(frame.FighterAName, true)
      frame.FighterAName:SetText(characterName(pairA) or "Fighter A")
      setShown(frame.FighterAMeta, true)
      frame.FighterAMeta:SetText(goraRecordLine(pairA) or "")
      placeAt(frame.FighterAName, content, 0, y)
      placeAt(frame.FighterAMeta, content, 180, y)
    end
    if isId(pairB) then
      setShown(frame.FighterBName, true)
      frame.FighterBName:SetText(characterName(pairB) or "Fighter B")
      setShown(frame.FighterBMeta, true)
      frame.FighterBMeta:SetText(goraRecordLine(pairB) or "")
      placeAt(frame.FighterBName, content, 260, y)
      placeAt(frame.FighterBMeta, content, 420, y)
    end
    y = y + 20
    setShown(frame.FavorLabel, true)
    frame.FavorLabel:SetText("Favor of the Church")
    colorize(frame.FavorLabel, "gold")
    setShown(frame.FavorNameA, true)
    setShown(frame.FavorNameB, true)
    setShown(frame.FavorBar, true)
    setShown(frame.FavorSplit, true)
    setShown(frame.FavorCount, true)
    setShown(frame.CongregationFavor, true)
    setShown(frame.CongregationFavorLabel, true)
    paintFavor(frame)
    placeAt(frame.FavorLabel, content, 0, y)
    y = y + 16
    placeAt(frame.FavorNameA, content, 0, y)
    placeAt(frame.FavorBar, content, 160, y)
    placeAt(frame.FavorNameB, content, 300, y)
    y = y + 16
    placeAt(frame.FavorSplit, content, 0, y)
    placeAt(frame.FavorCount, content, 48, y)
    placeAt(frame.CongregationFavor, content, 80, y - 6)
    placeAt(frame.CongregationFavorLabel, content, 110, y)
    y = y + 26
    setShown(frame.OutcomeLabel, true)
    frame.OutcomeLabel:SetText("Record verdict")
    colorize(frame.OutcomeLabel, "gold")
    placeAt(frame.OutcomeLabel, content, 0, y)
    y = y + 16
    if isId(pairA) then
      frame.PairVictorA:SetText(characterName(pairA))
      frame.PairVictorA._cobVictorId = pairA
      setShown(frame.PairVictorA, true)
    end
    if isId(pairB) then
      frame.PairVictorB:SetText(characterName(pairB))
      frame.PairVictorB._cobVictorId = pairB
      setShown(frame.PairVictorB, true)
    end
    if isId(pairA) or isId(pairB) then
      local vx = 0
      if isId(pairA) then
        placeAt(frame.PairVictorA, content, vx, y)
        vx = vx + 140 + BTN_GAP
      end
      if isId(pairB) then
        placeAt(frame.PairVictorB, content, vx, y)
      end
      y = y + 22 + BTN_GAP
    end
    y = placeRowAt(content, y, { frame.DeclareVictor, frame.CowardiceRecorded })
    y = placeRowAt(content, y, { frame.VoidRuling, frame.FreeRuling })
    setShown(frame.FreeRulingText, true)
    placeAt(frame.FreeRulingText, content, 0, y)
    y = y + 24 + BTN_GAP
    if frame.RecordVerdict then
      if lastVerdict then
        frame.RecordVerdict._cobOff = true
      else
        frame.RecordVerdict._cobOff = nil
      end
      y = placeRowAt(content, y, { frame.RecordVerdict })
    end
    return y
  end

  if view.rite == "gora" then
    setShown(frame.RiteHead, true)
    frame.RiteHead:SetText("Gathering  ›  BEEF GORA  ·  SETUP")
    colorize(frame.RiteHead, "gold")
    placeAt(frame.RiteHead, content, 0, y)
    y = y + 20
    y = placeRowAt(content, y, { frame.CloseRite })
    setShown(frame.FighterAName, true)
    setShown(frame.FighterBName, true)
    setShown(frame.FighterAMeta, true)
    setShown(frame.FighterBMeta, true)
    if isId(Console.selectedFighterA) then
      frame.FighterAName:SetText(characterName(Console.selectedFighterA) or "Fighter A")
      frame.FighterAMeta:SetText(goraRecordLine(Console.selectedFighterA) or "")
      frame.FighterA:SetText("Change")
    else
      frame.FighterAName:SetText("Fighter A")
      frame.FighterAMeta:SetText(subjectLine(targetPreview or subject, "Select a fighter"))
      frame.FighterA:SetText("Fighter A")
    end
    if isId(Console.selectedFighterB) then
      frame.FighterBName:SetText(characterName(Console.selectedFighterB) or "Fighter B")
      frame.FighterBMeta:SetText(goraRecordLine(Console.selectedFighterB) or "")
      frame.FighterB:SetText("Change")
    else
      frame.FighterBName:SetText("Fighter B")
      frame.FighterBMeta:SetText("Select a fighter")
      frame.FighterB:SetText("Fighter B")
    end
    placeAt(frame.FighterAName, content, 0, y)
    placeAt(frame.FighterBName, content, 260, y)
    y = y + 16
    placeAt(frame.FighterAMeta, content, 0, y)
    placeAt(frame.FighterBMeta, content, 260, y)
    y = y + 18
    y = placeRowAt(content, y, { frame.FighterA, frame.FighterB })
    if frame.Sanction then
      if twoFighters then
        frame.Sanction._cobOff = nil
      else
        frame.Sanction._cobOff = true
      end
    end
    y = placeRowAt(content, y, { frame.Sanction })
    setShown(frame.HelperText, true)
    if sameFighters then
      frame.HelperText:SetText("A Gora needs two different combatants.")
    elseif not twoFighters then
      frame.HelperText:SetText("Select two different fighters first.")
    else
      frame.HelperText:SetText("")
    end
    placeAt(frame.HelperText, content, 0, y)
    y = y + 16
    y = paintOneStrip(frame, content, y, stripW, petitionStrip("Select"))
    return y
  end

  if view.rite == "other" then
    y = placeRowAt(content, y, { frame.CloseRite })
    return y
  end

  -- Active gathering: rite launchers and queues. Start/End live on the chrome.
  local here = congregationHere()
  setShown(frame.CongregationLine, true)
  frame.CongregationLine:SetText("Congregation  " .. tostring(here))
  placeAt(frame.CongregationLine, content, 0, y)
  y = y + 18
  if view.runtimeState == "CONSEQUENCE" then
    y = placeRowAt(content, y, { frame.ContinueBtn })
  else
    local waiting = #Console:GetKnightingLine()
    local petitions = #Console:GetPetitions()
    if frame.OpenKnighting then
      frame.OpenKnighting:SetText("Open a Knighting rite")
    end
    if frame.OpenGora then
      frame.OpenGora:SetText("Open a Gora rite")
    end
    setShown(frame.HelperText, true)
    frame.HelperText:SetText(tostring(waiting) .. " waiting    " .. tostring(petitions) .. " petitions")
    placeAt(frame.HelperText, content, 0, y)
    y = y + 16
    y = placeRowAt(content, y, { frame.OpenKnighting, frame.OpenGora })
  end
  y = paintOneStrip(frame, content, y, stripW, knightStrip("Select"))
  y = paintOneStrip(frame, content, y, stripW, petitionStrip("Select"))
  local addVisible = type(subject) == "table" and subject.needsKnighting == true and isId(subject.humanId)
  setShown(frame.AddToLine, addVisible)
  if addVisible then
    placeAt(frame.AddToLine, content, 0, y)
    y = y + BTN_H + BTN_GAP
  end
  return y
end

function Console._paintDecrees(frame, content, y)
  local pope = isRegisteredPope()
  local stubber = canWriteStub()
  local function placeLabeled(label, widgets, x0)
    if label then
      setShown(label, true)
      placeAt(label, content, 0, y + 3)
    end
    local x = x0 or 52
    for i = 1, #widgets do
      local w = widgets[i]
      setShown(w, true)
      placeAt(w, content, x, y)
      x = x + (w.GetWidth and w:GetWidth() or 80) + 6
    end
    y = y + 26
  end
  local function placeTime()
    if frame.TimeHour then
      frame.TimeHour:SetText(tostring(nightsDesk.hour))
      frame.TimeMinute:SetText(string.format("%02d", nightsDesk.minute))
      frame.TimeAmPm:SetText(nightsDesk.pm and "PM" or "AM")
      placeLabeled(frame.TimeLabel, { frame.TimeHour, frame.TimeMinute, frame.TimeAmPm })
    end
  end
  local function placePlace()
    setShown(frame.DecreeLineLabel, true)
    setShown(frame.DecreeLine, true)
    frame.DecreeLineLabel:SetText("Place")
    placeAt(frame.DecreeLineLabel, content, 0, y + 3)
    placeAt(frame.DecreeLine, content, 52, y)
    y = y + 24
  end

  setShown(frame.DecreeHeader, true)
  frame.DecreeHeader:SetText("Nights")
  colorize(frame.DecreeHeader, "gold")
  placeAt(frame.DecreeHeader, content, 0, y)
  y = y + 20

  local summary = "No nights posted this week."
  local live
  if COB.Nights and COB.Nights.ListSeries then
    local list = COB.Nights:ListSeries()
    for i = 1, #list do
      if list[i].withdrawn ~= true then
        live = list[i]
        break
      end
    end
  end
  if live then
    local parts = {}
    if live.oneshotDate then
      parts[#parts + 1] = live.oneshotDate
    elseif type(live.weekday) == "number" then
      parts[#parts + 1] = nightsDesk.WEEKDAYS[live.weekday]
    end
    parts[#parts + 1] = nightsDesk.KIND_LABEL[live.kind] or live.kind
    if type(live.place) == "string" and live.place ~= "" then
      parts[#parts + 1] = live.place
    end
    if type(live.timeLine) == "string" and live.timeLine ~= "" then
      parts[#parts + 1] = live.timeLine
    end
    summary = table.concat(parts, "  ·  ")
  elseif COB.Decree and type(COB.Decree.Get) == "function" then
    local current = COB.Decree:Get()
    if type(current) == "table" and type(current.line) == "string" then
      summary = current.line
      if type(current.flavor) == "string" and current.flavor ~= "" then
        summary = summary .. "  ·  " .. current.flavor
      end
    end
  end
  setShown(frame.DecreeCurrent, true)
  frame.DecreeCurrent:SetText(summary)
  placeAt(frame.DecreeCurrent, content, 0, y)
  y = y + 18

  if pope and frame.GoingNames then
    local names = ""
    if COB.Nights and COB.Nights.Week and COB.Nights.ListGoing then
      local week = COB.Nights:Week()
      for i = 1, #week do
        if week[i].source ~= "stub" then
          local listed = COB.Nights:ListGoing(week[i].key)
          names = table.concat(listed, ", ")
          break
        end
      end
    end
    setShown(frame.GoingNames, true)
    frame.GoingNames:SetText(names ~= "" and ("Going  " .. names) or "Going  —")
    placeAt(frame.GoingNames, content, 0, y)
    y = y + 18
  end

  local leftover = COB.Decree and COB.Decree.Get and COB.Decree:Get() ~= nil
  if pope and leftover and live == nil then
    setShown(frame.WithdrawDecree, true)
    placeAt(frame.WithdrawDecree, content, 0, y)
    y = y + BTN_H + BTN_GAP
  end

  if pope then
    if frame.NightsChurchHead then
      setShown(frame.NightsChurchHead, true)
      colorize(frame.NightsChurchHead, "gold")
      placeAt(frame.NightsChurchHead, content, 0, y)
      y = y + 18
    end
    if frame.ChurchKindGathering then
      placeLabeled(nil, {
        frame.ChurchKindGathering, frame.ChurchKindKnighting, frame.ChurchKindGora,
      }, 0)
    end
    if frame.WeekdayPick then
      frame.WeekdayPick:SetText(nightsDesk.weekdayLabel())
      placeLabeled(frame.WeekdayLabel, {
        frame.WeekdayPrev, frame.WeekdayPick, frame.WeekdayNext,
      })
    end
    placeTime()
    placePlace()
    setShown(frame.DecreeFlavorLabel, true)
    setShown(frame.DecreeFlavor, true)
    frame.DecreeFlavorLabel:SetText("Note")
    placeAt(frame.DecreeFlavorLabel, content, 0, y + 3)
    placeAt(frame.DecreeFlavor, content, 52, y)
    y = y + 24
    if frame.PostSeries then
      y = placeRowAt(content, y, { frame.PostSeries, frame.PostDecree })
    else
      setShown(frame.PostDecree, true)
      placeAt(frame.PostDecree, content, 0, y)
      y = y + BTN_H + BTN_GAP
    end
    if frame.SkipWeek then
      y = placeRowAt(content, y, { frame.SkipWeek, frame.MoveWeek, frame.WithdrawSeries })
    end
  end

  if stubber then
    if frame.NightsStubHead then
      setShown(frame.NightsStubHead, true)
      colorize(frame.NightsStubHead, "gold")
      placeAt(frame.NightsStubHead, content, 0, y)
      y = y + 18
    end
    if frame.StubKindRaid then
      placeLabeled(nil, { frame.StubKindRaid, frame.StubKindPvp }, 0)
    end
    if frame.DatePick then
      frame.DatePick:SetText(nightsDesk.dateLabel())
      placeLabeled(frame.DateLabel, { frame.DatePrev, frame.DatePick, frame.DateNext })
    end
    if not pope then
      placeTime()
      placePlace()
    end
    if frame.StubTitle then
      setShown(frame.StubTitleLabel, true)
      setShown(frame.StubTitle, true)
      placeAt(frame.StubTitleLabel, content, 0, y + 3)
      placeAt(frame.StubTitle, content, 52, y)
      y = y + 24
    end
    if frame.PostStub then
      y = placeRowAt(content, y, { frame.PostStub, frame.WithdrawStub })
    end
  end
  return y
end

function Console._paintChronicle(frame, content, y, stripW)
  setShown(frame.ChronicleHead, true)
  frame.ChronicleHead:SetText("Chronicle")
  colorize(frame.ChronicleHead, "gold")
  placeAt(frame.ChronicleHead, content, 0, y)
  y = y + 20
  local rows = chronicleRows()
  if frame.ChronicleStrip then
    placeAt(frame.ChronicleStrip.head, content, 0, y)
    y = y + 18
    placeAt(frame.ChronicleStrip.body, content, 0, y)
    frame.ChronicleStrip.body:SetWidth(stripW)
    setShown(frame.ChronicleStrip.head, true)
    setShown(frame.ChronicleStrip.body, true)
    paintChronicleStrip(frame, rows)
    y = y + (frame.ChronicleStrip.body:GetHeight() or ROW_H) + themeSpace("sm", 8)
  end
  return y
end

function Console._paintChurch(frame, content, y, stripW)
  setShown(frame.ChurchHead, true)
  frame.ChurchHead:SetText("Church census")
  colorize(frame.ChurchHead, "gold")
  placeAt(frame.ChurchHead, content, 0, y)
  y = y + 20
  y = paintOneStrip(frame, content, y, stripW, {
    strip = frame.PresenceStrip,
    rows = Console:GetPresenceCensus(),
    lineOf = censusLine,
    actionLabel = function() return nil end,
    onAction = function() end,
    onRow = function() end,
  })
  return y
end

local function applyGate(frame)
  local pope = isRegisteredPope()
  local stubber = canWriteStub()
  if frame.GateStatus then
    if not pope and not stubber then
      frame.GateStatus:SetText(REFUSE)
    elseif type(lastRefuse) == "string" and lastRefuse ~= "" then
      frame.GateStatus:SetText(lastRefuse)
    else
      frame.GateStatus:SetText("")
    end
  end
  local buttons = frame.GatedButtons or {}
  for i = 1, #buttons do
    local btn = buttons[i]
    if pope and btn._cobOff ~= true then
      btn:Enable()
    elseif stubber and btn._cobStub == true and btn._cobOff ~= true then
      btn:Enable()
    else
      btn:Disable()
    end
  end
end

--------------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------------

local function buildFrame()
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent, "BasicFrameTemplate")
  frame:SetFrameStrata("MEDIUM")
  frame:SetToplevel(true)
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetResizable(true)
  frame:SetClampedToScreen(true)
  frame:SetWidth(DEFAULT_WIDTH)
  frame:SetHeight(DEFAULT_HEIGHT)
  restoreSize(frame)
  applyConsoleBounds(frame)
  restorePoint(frame)
  frame:Hide()

  -- After the initial Hide so create does not fire OnHide remount.
  wireConsoleOnHide(frame)

  frame.GatedButtons = {}

  if frame.TitleText and frame.TitleText.SetText then
    frame.TitleText:SetText("Director Console")
  end

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetHeight(22)
  titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -2)
  titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -2)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
    saveSize(frame)
  end)
  frame.TitleBar = titleBar

  -- One decorative texture this desk may wear besides the verb plates.
  local titleSeal = titleBar:CreateTexture(nil, "OVERLAY")
  titleSeal:SetWidth(20)
  titleSeal:SetHeight(20)
  titleSeal:SetPoint("LEFT", titleBar, "LEFT", 2, 0)
  applyThemeTexture(titleSeal, "seal_papal")
  frame.TitleSeal = titleSeal

  local close = frame.CloseButton
  if close then
    if close.HookScript then
      close:HookScript("OnClick", function() Console:Hide() end)
    else
      close:SetScript("OnClick", function() Console:Hide() end)
    end
  end

  local gutter = themeSpace("md", 16)
  local tabBar = CreateFrame("Frame", nil, frame)
  tabBar:SetHeight(24)
  tabBar:SetPoint("TOPLEFT", frame, "TOPLEFT", gutter, -28)
  tabBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -gutter, -28)
  frame.TabBar = tabBar
  local function tabButton(label, id, x)
    local btn = CreateFrame("Button", nil, tabBar, "UIPanelButtonTemplate")
    btn:SetWidth(96)
    btn:SetHeight(22)
    btn:SetPoint("LEFT", tabBar, "LEFT", x, 0)
    btn:SetText(label)
    btn:SetScript("OnClick", function()
      Console:SetTab(id)
    end)
    return btn
  end
  frame.TabGathering = tabButton("Gathering", "gathering", 0)
  frame.TabDecrees = tabButton("Nights", "decrees", 100)
  frame.TabChronicle = tabButton("Chronicle", "chronicle", 200)
  frame.TabChurch = tabButton("Church", "church", 300)

  local sessionBar = CreateFrame("Frame", nil, frame)
  sessionBar:SetHeight(32)
  sessionBar:SetPoint("TOPLEFT", frame, "TOPLEFT", gutter, -54)
  sessionBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -gutter, -54)
  frame.SessionBar = sessionBar
  local chromeStatus = sessionBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  chromeStatus:SetPoint("LEFT", sessionBar, "LEFT", 0, 0)
  chromeStatus:SetJustifyH("LEFT")
  frame.ChromeStatus = chromeStatus

  local deskScroll = CreateFrame("ScrollFrame", FRAME_NAME .. "DeskScroll", frame, "UIPanelScrollFrameTemplate")
  deskScroll:SetPoint("TOPLEFT", frame, "TOPLEFT", gutter, -88)
  deskScroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -gutter, 12)
  local content = CreateFrame("Frame", nil, deskScroll)
  content:SetWidth(DEFAULT_WIDTH - gutter * 2)
  content:SetHeight(400)
  if type(deskScroll.SetScrollChild) == "function" then
    deskScroll:SetScrollChild(content)
  end
  if type(deskScroll.SetVerticalScroll) == "function" then
    deskScroll:SetVerticalScroll(0)
  end
  if type(deskScroll.EnableMouseWheel) == "function" then
    deskScroll:EnableMouseWheel(true)
  end
  if type(deskScroll.SetScript) == "function" then
    deskScroll:SetScript("OnMouseWheel", function(self, delta)
      if type(self.GetVerticalScroll) ~= "function"
          or type(self.SetVerticalScroll) ~= "function"
          or type(self.GetVerticalScrollRange) ~= "function" then
        return
      end
      local current = self:GetVerticalScroll()
      local range = self:GetVerticalScrollRange()
      if type(current) ~= "number" or type(range) ~= "number" then
        return
      end
      if type(delta) ~= "number" then return end
      local nextScroll = current - (delta * 36)
      if nextScroll < 0 then nextScroll = 0 end
      if nextScroll > range then nextScroll = range end
      self:SetVerticalScroll(nextScroll)
    end)
  end
  frame.DeskScroll = deskScroll
  frame.DeskChild = content
  frame.Content = content

  -- Charcoal desk ground (deeper ground, not iron chrome).
  local deskBg = content:CreateTexture(nil, "BACKGROUND")
  deskBg:SetAllPoints(content)
  deskBg:SetTexture(themeTexture("stock_tooltip_bg")
    or "Interface\\Tooltips\\UI-Tooltip-Background")
  local r, g, b = themeColor("charcoal")
  if deskBg.SetVertexColor and type(r) == "number" then
    deskBg:SetVertexColor(r, g, b, 1)
    deskBg._cobColor = { r = r, g = g, b = b, a = 1, role = "charcoal" }
  end
  frame.DeskBg = deskBg

  local grip = CreateFrame("Button", nil, frame)
  grip:SetWidth(18)
  grip:SetHeight(18)
  grip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
  grip:EnableMouse(true)
  grip:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  local grabUp = themeTexture("stock_grabber_up")
    or "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up"
  local grabDown = themeTexture("stock_grabber_down")
    or "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down"
  local grabHi = themeTexture("stock_grabber_highlight")
    or "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight"
  grip:SetNormalTexture(grabUp)
  grip:SetPushedTexture(grabDown)
  grip:SetHighlightTexture(grabHi)
  grip:SetScript("OnMouseDown", function(_, button)
    if button == "RightButton" then
      frame:SetWidth(DEFAULT_WIDTH)
      frame:SetHeight(DEFAULT_HEIGHT)
      saveSize(frame)
      layoutDesk(frame)
      paintDesk(frame)
      return
    end
    if type(frame.StartSizing) == "function" then
      frame:StartSizing("BOTTOMRIGHT")
    end
  end)
  grip:SetScript("OnMouseUp", function()
    if type(frame.StopMovingOrSizing) == "function" then
      frame:StopMovingOrSizing()
    end
    savePoint(frame)
    saveSize(frame)
    layoutDesk(frame)
    paintDesk(frame)
  end)
  frame.SizeGrip = grip
  if type(frame.HookScript) == "function" then
    frame:HookScript("OnSizeChanged", function() onConsoleSizeChanged(frame) end)
  elseif type(frame.SetScript) == "function" then
    frame:SetScript("OnSizeChanged", function() onConsoleSizeChanged(frame) end)
  end
  if type(frame.RegisterEvent) == "function" then
    frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
    frame:RegisterEvent("UI_SCALE_CHANGED")
    -- PLAYER_TARGET_CHANGED is registered by Show and unregistered by the
    -- OnHide handler: the desk only re-resolves targets while it is shown.
    frame:SetScript("OnEvent", function(_, event)
      if event == "PLAYER_TARGET_CHANGED" then
        refreshTargetSubject(Console)
        if frame:IsShown() then
          Console:Refresh()
        end
      else
        applyConsoleBounds(frame)
        onConsoleSizeChanged(frame)
      end
    end)
  end

  local function verb(label, onClick, width)
    local btn = stockButton(content, label, onClick)
    if type(width) == "number" then
      btn:SetWidth(width)
    end
    btn._cobVerb = true
    frame.GatedButtons[#frame.GatedButtons + 1] = btn
    return btn
  end

  -- Phase hint + gate line.
  frame.PhaseHint = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.PhaseHint:SetJustifyH("LEFT")
  frame.PhaseHint:SetText(PHASE_HINT.inactive)

  frame.GateStatus = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.GateStatus:SetPoint("LEFT", frame.PhaseHint, "RIGHT", 12, 0)
  frame.GateStatus:SetJustifyH("LEFT")
  frame.GateStatus:SetText("")

  -- Phase verbs.
  frame.StartGathering = verb("Start the gathering", function() Console:StartEvent() end)
  frame.OpenKnighting = verb("Open a Knighting rite", function() Console:OpenRite("Knighting") end)
  frame.OpenGora = verb("Open a Gora rite", function() Console:OpenRite("Gora") end)
  frame.EndGathering = verb("End the gathering", function() Console:RequestEndGathering() end)
  frame.CloseRite = verb("Back to Gathering", function() Console:RequestCloseRite() end)
  if sessionBar then
    if frame.StartGathering.SetParent then frame.StartGathering:SetParent(sessionBar) end
    if frame.EndGathering.SetParent then frame.EndGathering:SetParent(sessionBar) end
  end
  frame.ContinueBtn = verb("Continue", function() Console:Continue() end)
  frame.ReturnGathering = verb("Return to Gathering", function() Console:ReturnToGathering() end)
  frame.SelectCandidate = verb("Select as candidate", function() Console:SelectCandidateFromTarget() end)
  frame.RecordVerdict = verb("RECORD VERDICT", function() Console:RecordVerdict() end)
  frame.WithdrawDecree = verb("Withdraw", function() Console:WithdrawDecree() end)
  frame.ConfirmCancel = verb("Cancel", function() Console:CancelConfirm() end, 100)
  frame.ConfirmOk = verb("Confirm", function() Console:AcceptConfirm() end, 120)

  -- Target line.
  frame.TargetLine = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.TargetLine:SetJustifyH("LEFT")
  frame.TargetLine:SetText("Target a guildmate to act on them.")

  -- Subject verbs.
  frame.KnightThisBeef = plateVerb(verb("KNIGHT THIS BEEF", function() Console:KnightThisBeef() end))
  frame.AddToLine = verb("Add to the line", function() Console:Enqueue() end)
  frame.ElevateToLord = verb("Elevate to Lord", function() Console:ElevateToLord() end)

  -- Pair section.
  frame.FighterA = verb("Fighter A", function() Console:SetFighterA() end, 84)
  frame.FighterB = verb("Fighter B", function() Console:SetFighterB() end, 84)
  frame.PairLine = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.PairLine:SetJustifyH("LEFT")
  frame.PairLine:SetText("A: —  vs  B: —")
  frame.PairVictorA = verb("", function(self)
    if isId(self._cobVictorId) then
      selectedWinnerId = self._cobVictorId
      selectedOutcome = "victor"
      Console:SelectCharacter(self._cobVictorId)
      Console:Refresh()
    end
  end, 140)
  frame.PairVictorA:SetHeight(22)
  frame.PairVictorB = verb("", function(self)
    if isId(self._cobVictorId) then
      selectedWinnerId = self._cobVictorId
      selectedOutcome = "victor"
      Console:SelectCharacter(self._cobVictorId)
      Console:Refresh()
    end
  end, 140)
  frame.PairVictorB:SetHeight(22)
  frame.Sanction = plateVerb(verb("SANCTION BEEF GORA", function() Console:Sanction() end))

  -- Verdict plates (stock chrome; only the two sacred verbs wear iron).
  frame.DeclareVictor = verb("DECLARE VICTOR", function() Console:DeclareVictor() end)
  frame.CowardiceRecorded = verb("COWARDICE RECORDED", function() Console:CowardiceRecorded() end)
  frame.VoidRuling = verb("VOID", function() Console:Void() end)
  frame.FreeRuling = verb("FREE RULING", function() Console:FreeRuling() end)
  frame.FreeRulingText = stockEdit(content, 200)

  -- Favor readout (Pope-desk only) + per-event congregation toggle.
  frame.FavorLabel = header(content, "Favor", "GameFontNormalSmall")
  frame.FavorSplit = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.FavorSplit:SetJustifyH("LEFT")
  frame.FavorSplit:SetText("0 / 0")
  frame.FavorCount = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.FavorCount:SetJustifyH("LEFT")
  frame.FavorCount:SetText("0")
  local congBtn, congLabel = stockCheck(content, "Show favor to the congregation")
  congBtn._cobVerb = true
  frame.GatedButtons[#frame.GatedButtons + 1] = congBtn
  frame.CongregationFavor = congBtn
  frame.CongregationFavorLabel = congLabel

  -- Event-wide moment flag.
  frame.MarkMoment = verb("Mark this moment", function() Console:FlagMoment() end)

  -- Nights compose. Typed fields: Place, Note, Title. Kind / day / time /
  -- date are stock cycle and choice buttons.
  local nightsHide = {}
  frame._nightsHide = nightsHide
  local function trackNights(widget)
    nightsHide[#nightsHide + 1] = widget
    return widget
  end
  local function picker(label, onClick, width, stub)
    local btn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    btn:SetWidth(width or 88)
    btn:SetHeight(22)
    btn:SetText(label)
    btn:SetScript("OnClick", onClick)
    btn._cobVerb = true
    if stub then btn._cobStub = true end
    frame.GatedButtons[#frame.GatedButtons + 1] = btn
    return trackNights(btn)
  end

  frame.DecreeHeader = header(content, "Nights")
  frame.DecreeLineLabel = header(content, "Place", "GameFontNormalSmall")
  frame.DecreeLine = stockEdit(content, 220)
  frame.DecreeFlavorLabel = header(content, "Note", "GameFontNormalSmall")
  frame.DecreeFlavor = stockEdit(content, 220)
  frame.PostDecree = verb("Post the Decree", function() Console:PostDecree() end)
  frame.PostStub = verb("Post Discord notice", function() Console:PostStub() end)
  frame.PostStub._cobStub = true
  frame.NightsChurchHead = trackNights(header(content, "Church night"))
  frame.ChurchKindGathering = picker("Gathering", function()
    nightsDesk.churchKind = "gathering"
    nightsDesk.refresh()
  end, 100)
  frame.ChurchKindKnighting = picker("Knighting", function()
    nightsDesk.churchKind = "knighting"
    nightsDesk.refresh()
  end, 100)
  frame.ChurchKindGora = picker("Gora", function()
    nightsDesk.churchKind = "gora"
    nightsDesk.refresh()
  end, 80)
  frame.WeekdayLabel = trackNights(header(content, "Day", "GameFontNormalSmall"))
  frame.WeekdayPrev = picker("<", function()
    nightsDesk.bumpWeekday(-1)
    nightsDesk.refresh()
  end, 28)
  frame.WeekdayPick = picker("Thursday", function()
    nightsDesk.bumpWeekday(1)
    nightsDesk.refresh()
  end, 110)
  frame.WeekdayNext = picker(">", function()
    nightsDesk.bumpWeekday(1)
    nightsDesk.refresh()
  end, 28)
  frame.TimeLabel = trackNights(header(content, "Time", "GameFontNormalSmall"))
  frame.TimeHour = picker("7", function()
    nightsDesk.bumpHour()
    nightsDesk.refresh()
  end, 36, true)
  frame.TimeMinute = picker("00", function()
    nightsDesk.bumpMinute()
    nightsDesk.refresh()
  end, 40, true)
  frame.TimeAmPm = picker("PM", function()
    nightsDesk.toggleAmPm()
    nightsDesk.refresh()
  end, 40, true)
  frame.PostSeries = verb("Post weekly night", function() Console:PostSeries() end)
  frame.SkipWeek = verb("Skip this week", function() Console:SkipWeek() end, 120)
  frame.MoveWeek = verb("Move this week", function() Console:MoveWeek() end, 120)
  frame.WithdrawSeries = verb("Withdraw series", function() Console:WithdrawSeries() end, 140)
  frame.GoingNames = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.GoingNames:SetJustifyH("LEFT")
  frame.NightsStubHead = trackNights(header(content, "Discord notice"))
  frame.StubKindRaid = picker("Raid", function()
    nightsDesk.stubKind = "raid"
    nightsDesk.refresh()
  end, 80, true)
  frame.StubKindPvp = picker("PvP", function()
    nightsDesk.stubKind = "pvp"
    nightsDesk.refresh()
  end, 80, true)
  frame.DateLabel = trackNights(header(content, "When", "GameFontNormalSmall"))
  frame.DatePrev = picker("<", function()
    nightsDesk.bumpDate(-1)
    nightsDesk.refresh()
  end, 28, true)
  frame.DatePick = picker("Today", function()
    nightsDesk.bumpDate(1)
    nightsDesk.refresh()
  end, 130, true)
  frame.DateNext = picker(">", function()
    nightsDesk.bumpDate(1)
    nightsDesk.refresh()
  end, 28, true)
  frame.StubTitleLabel = header(content, "Title", "GameFontNormalSmall")
  frame.StubTitle = stockEdit(content, 220)
  frame.WithdrawStub = verb("Withdraw notice", function() Console:WithdrawStub() end)
  frame.WithdrawStub._cobStub = true
  frame.DecreeCurrent = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.DecreeCurrent:SetJustifyH("LEFT")

  frame.RiteHead = header(content, "")
  frame.SessionLine = header(content, "")
  frame.CongregationLine = header(content, "", "GameFontHighlightSmall")
  frame.CandidateCard = header(content, "")
  frame.PromotionLine = header(content, "", "GameFontHighlightSmall")
  frame.FighterAName = header(content, "Fighter A")
  frame.FighterAMeta = header(content, "", "GameFontHighlightSmall")
  frame.FighterBName = header(content, "Fighter B")
  frame.FighterBMeta = header(content, "", "GameFontHighlightSmall")
  frame.CompleteTitle = header(content, "")
  frame.CompleteBody = header(content, "", "GameFontHighlightSmall")
  frame.HelperText = header(content, "", "GameFontHighlightSmall")
  frame.OutcomeLabel = header(content, "Record verdict", "GameFontNormalSmall")
  frame.FavorNameA = header(content, "", "GameFontHighlightSmall")
  frame.FavorNameB = header(content, "", "GameFontHighlightSmall")
  frame.FavorBar = header(content, "", "GameFontHighlightSmall")
  frame.ConfirmTitle = header(content, "")
  frame.ConfirmBody = header(content, "", "GameFontHighlightSmall")
  frame.ChurchHead = header(content, "Church census")
  frame.ChronicleHead = header(content, "Chronicle")

  -- Secondary strips.
  frame.KnightingStrip = buildStrip(content, "Waiting to be knighted", "No one is waiting.")
  frame.PetitionStrip = buildStrip(content, "Asked to fight", "No petitions.")
  frame.PresenceStrip = buildStrip(content, "By rank", "No one on the roster yet.")
  frame.ChronicleStrip = buildStrip(content, "Recent history", "No chronicle entries yet.")

  rememberSpecial(FRAME_NAME)
  paintDesk(frame)

  return frame
end

--------------------------------------------------------------------------------
-- Lifecycle
--------------------------------------------------------------------------------

function Console:Init()
  if self.frame then
    rememberSpecial(FRAME_NAME)
    return self.frame
  end
  if type(CreateFrame) ~= "function" then return nil end
  self.frame = buildFrame()
  return self.frame
end

function Console:Refresh()
  if not self.frame then return end
  wireConsoleOnHide(self.frame)
  rememberSpecial(FRAME_NAME)
  syncCongregationToggle()
  armProposedWinner()
  refreshSubjectRanks(self)
  paintDesk(self.frame)
  applyGate(self.frame)
end

function Console:Show()
  -- Congregation must not open the desk. Listed Council may open the Nights tab.
  if not canOpenDesk() then return end
  if not isRegisteredPope() then
    deskTab = "decrees"
  end
  if not self.frame then self:Init() end
  if not self.frame then return end
  rememberSpecial(FRAME_NAME)
  -- The roster kick the retired Quiet shell owned on its OnShow: the Presence
  -- desk reads Roster, so opening the desk attaches and re-reads the cache,
  -- and kicks a forced server query while the cache is still cold. The
  -- Records Book does not need this kick.
  local Roster = COB.Roster
  if type(Roster) == "table" then
    if type(Roster.AttachLibrary) == "function" then
      pcall(Roster.AttachLibrary, Roster)
    end
    if type(Roster.Refresh) == "function" then
      pcall(Roster.Refresh, Roster)
    end
    if type(Roster.IsReady) == "function" and not Roster:IsReady()
        and type(COB.Net) == "table" and type(COB.Net.RequestRoster) == "function" then
      pcall(COB.Net.RequestRoster, COB.Net, nil, true)
    end
  end
  -- A target picked before the desk opened still counts, and a target-sourced
  -- subject re-resolves from the live target: the listener slept while the
  -- desk was hidden, so a move or clear in between is only visible now.
  -- Rehydrate first so a locked candidate survives /reload.
  rehydrateDesk(self)
  if self.subject == nil
      or (type(self.subject) == "table" and self.subject.source == "target") then
    refreshTargetSubject(self)
  else
    targetPreview = readTargetPreview()
  end
  if gatheringStartedAt == nil and currentState(currentSnap()) ~= "QUIET" then
    gatheringStartedAt = restoreStartedAt() or wallNow()
    persistSession()
  end
  if type(self.frame.RegisterEvent) == "function" then
    self.frame:RegisterEvent("PLAYER_TARGET_CHANGED")
  end
  self.frame:Show()
  self:Refresh()
end

function Console:Hide()
  if not self.frame then return end
  wireConsoleOnHide(self.frame)
  rememberSpecial(FRAME_NAME)
  self.frame:Hide()
end

function Console:IsShown()
  return self.frame and self.frame:IsShown() and true or false
end

function Console:Toggle()
  if not canOpenDesk() then return end
  if not self.frame then self:Init() end
  if not self.frame then return end
  if self.frame:IsShown() then self:Hide() else self:Show() end
end

function Console:ResetForTests()
  if not COB._IN_TEST then return false end
  self.subject = nil
  self.selectedFighterA = nil
  self.selectedFighterB = nil
  lastRefuse = nil
  congregationFavorVisible = true
  lastSeenEventId = currentEventId()
  gatheringStartedAt = nil
  candidateLocked = false
  fightersLocked = false
  selectedWinnerId = nil
  selectedOutcome = "victor"
  lastVerdict = nil
  knightingComplete = nil
  pendingConfirm = nil
  deskTab = "gathering"
  decreeBusy = false
  targetPreview = nil
  nightsDesk.reset()
  persistStartedAt(nil)
  persistSession()
  if self.frame then
    if self.frame.CongregationFavor then
      self.frame.CongregationFavor:SetChecked(true)
    end
    if self.frame.FighterA then self.frame.FighterA:SetText("Fighter A") end
    if self.frame.FighterB then self.frame.FighterB:SetText("Fighter B") end
    paintDesk(self.frame)
    self:Hide()
  end
  return true
end

-- Drop in-memory session only. Core + ChurchOfBeefDB.ui.console stay.
-- Models /reload of the desk module.
function Console:SimulateReloadForTests()
  if not COB._IN_TEST then return false end
  gatheringStartedAt = nil
  candidateLocked = false
  fightersLocked = false
  selectedWinnerId = nil
  selectedOutcome = "victor"
  lastVerdict = nil
  knightingComplete = nil
  pendingConfirm = nil
  self.subject = nil
  self.selectedFighterA = nil
  self.selectedFighterB = nil
  rehydrateDesk(self)
  if self.frame then
    paintDesk(self.frame)
    applyGate(self.frame)
  end
  return true
end

--------------------------------------------------------------------------------
-- Readouts (copies; the desk never hands out live tables)
--------------------------------------------------------------------------------

function Console:GetPresence()
  local rows = {}
  local Roster = COB.Roster
  if not Roster or Roster.ready ~= true or type(Roster.members) ~= "table" then
    return rows
  end

  local snap = storeSnap()
  local humans = snap and snap.humans or {}
  local chars = snap and snap.characters or {}
  local charByKey = {}
  for i = 1, #chars do
    local key = nameKey(chars[i].name)
    if key then charByKey[key] = chars[i] end
  end
  local humanById = {}
  for i = 1, #humans do
    humanById[humans[i].id] = humans[i]
  end

  for key, member in pairs(Roster.members) do
    if type(member) == "table" then
      local ch = charByKey[key]
      local human = ch and isId(ch.humanId) and humanById[ch.humanId] or nil
      if not human then
        for i = 1, #humans do
          if namesSame(humans[i].name, member.name) then
            human = humans[i]
            break
          end
        end
      end
      local rankId, title, needs = displayedRank(human, member.guildRankName)
      rows[#rows + 1] = {
        name = member.name,
        here = true,
        guildRankIndex = member.guildRankIndex,
        guildRankName = member.guildRankName,
        rankId = rankId,
        rankTitle = title,
        needsKnighting = needs,
        humanId = human and human.id or nil,
        characterId = ch and ch.id or nil,
      }
    end
  end

  local complete = false
  if type(Roster.IsComplete) == "function" then
    complete = Roster:IsComplete() == true
  else
    complete = Roster.complete == true
  end
  if complete ~= true then
    local seen = {}
    for i = 1, #rows do
      local key = nameKey(rows[i].name)
      if key then seen[key] = true end
    end
    for i = 1, #chars do
      local ch = chars[i]
      local key = type(ch) == "table" and nameKey(ch.name) or nil
      if key and not seen[key] then
        local human = isId(ch.humanId) and humanById[ch.humanId] or nil
        if not human then
          for j = 1, #humans do
            if namesSame(humans[j].name, ch.name) then
              human = humans[j]
              break
            end
          end
        end
        local rankId, title, needs = displayedRank(human, nil)
        rows[#rows + 1] = {
          name = ch.name,
          here = false,
          guildRankIndex = nil,
          guildRankName = nil,
          rankId = rankId,
          rankTitle = title,
          needsKnighting = needs,
          humanId = human and human.id or nil,
          characterId = ch.id,
        }
        seen[key] = true
      end
    end
  end

  table.sort(rows, function(a, b)
    local an, bn = a.name or "", b.name or ""
    return an < bn
  end)
  return rows
end

function Console:GetPresenceCensus()
  local people = self:GetPresence()
  local byId = {}
  local byName = {}
  local unrecorded = 0
  for i = 1, #people do
    local rankId = people[i].rankId
    local title = people[i].rankTitle
    if type(rankId) == "number" then
      byId[rankId] = (byId[rankId] or 0) + 1
    elseif type(title) == "string" and title ~= "" then
      local key = string.lower(title)
      local row = byName[key]
      if not row then
        row = { rankTitle = title, count = 0 }
        byName[key] = row
      end
      row.count = row.count + 1
    else
      unrecorded = unrecorded + 1
    end
  end
  local rows = {}
  for id = 6, 1, -1 do
    local count = byId[id]
    if type(count) == "number" and count > 0 then
      rows[#rows + 1] = {
        rankId = id,
        rankTitle = rankTitle(id),
        count = count,
      }
    end
  end
  local extras = {}
  for _, row in pairs(byName) do
    extras[#extras + 1] = row
  end
  table.sort(extras, function(a, b)
    return (a.rankTitle or "") < (b.rankTitle or "")
  end)
  for i = 1, #extras do
    rows[#rows + 1] = {
      rankId = nil,
      rankTitle = extras[i].rankTitle,
      count = extras[i].count,
    }
  end
  if unrecorded > 0 then
    rows[#rows + 1] = {
      rankId = nil,
      rankTitle = "Unrecorded",
      count = unrecorded,
    }
  end
  return rows
end

function Console:GetPetitions()
  if not COB.Gora or not COB.Gora.GetPetitions then return {} end
  return COB.Gora:GetPetitions(presentCharacterIds())
end

function Console:GetKnightingLine()
  local Knighting = COB.Knighting
  if type(Knighting) ~= "table" or type(Knighting.GetLine) ~= "function" then
    return {}
  end
  local line = Knighting:GetLine()
  if type(line) ~= "table" then return {} end
  local out = {}
  for i = 1, #line do
    local row = line[i]
    if type(row) == "table" then
      local copy = {}
      for k, v in pairs(row) do
        copy[k] = v
      end
      if copy.name == nil and isId(copy.humanId) and COB.Store and type(COB.Store.GetHuman) == "function" then
        local human = COB.Store:GetHuman(copy.humanId)
        if type(human) == "table" and type(human.name) == "string" then
          copy.name = human.name
        end
      end
      out[#out + 1] = copy
    end
  end
  return out
end

function Console:GetWorkingSubject()
  local subject = self.subject
  if type(subject) ~= "table" then return nil end
  local copy = {}
  for k, v in pairs(subject) do
    copy[k] = v
  end
  return copy
end

function Console:GetProposedBout()
  local out = {}
  if isId(self.selectedFighterA) then out.fighterA = self.selectedFighterA end
  if isId(self.selectedFighterB) then out.fighterB = self.selectedFighterB end
  return out
end

function Console:GetFavorSplit()
  local split
  if COB.Gora and type(COB.Gora.GetFavorSplit) == "function" then
    split = COB.Gora:GetFavorSplit()
  end
  if type(split) ~= "table" then
    return { a = 0, b = 0 }
  end
  local a, b = split.a, split.b
  if type(a) ~= "number" then a = 0 end
  if type(b) ~= "number" then b = 0 end
  return { a = a, b = b }
end

function Console:GetFavorCount()
  if not COB.Gora or type(COB.Gora.GetFavor) ~= "function" then
    return 0
  end
  local map = COB.Gora:GetFavor()
  if type(map) ~= "table" then return 0 end
  local n = 0
  for _ in pairs(map) do
    n = n + 1
  end
  return n
end

function Console:GetCongregationFavorVisible()
  return congregationFavorVisible == true
end

function Console:GetDeskState()
  local view = deskView()
  local copy = {}
  for k, v in pairs(view) do
    if k ~= "sanctioned" then
      copy[k] = v
    end
  end
  if view.sanctioned then
    copy.hasSanctioned = true
  end
  return copy
end

function Console:SetTab(id)
  if not TABS[id] then
    return nil, "unknown tab"
  end
  deskTab = id
  if self.frame then
    paintDesk(self.frame)
    applyGate(self.frame)
  end
  return true
end

function Console:GetTab()
  return deskTab
end

--------------------------------------------------------------------------------
-- Selection
--------------------------------------------------------------------------------

function Console:SelectHuman(humanId)
  if humanId ~= nil and not isId(humanId) then return nil, "invalid human id" end
  if humanId == nil then
    self.subject = nil
    if self.frame then self:Refresh() end
    return true
  end
  self.subject = subjectForHumanId(humanId, "selection")
  if self.frame then self:Refresh() end
  return true
end

function Console:SelectCharacter(characterId)
  if characterId ~= nil and not isId(characterId) then return nil, "invalid character id" end
  if characterId == nil then
    self.subject = nil
    if self.frame then self:Refresh() end
    return true
  end
  self.subject = subjectForCharacterId(characterId, "selection")
  if self.frame then self:Refresh() end
  return true
end

function Console:SetFighterA()
  if fightersLocked == true then
    lastRefuse = "fighters are locked"
    self:Refresh()
    return nil, lastRefuse
  end
  local id, ensureErr = ensureSubjectId(self, "character")
  if id == nil then return nil, ensureErr or "Target a fighter first" end
  if isId(self.selectedFighterB) and self.selectedFighterB == id then
    lastRefuse = "a Gora needs two different combatants"
    self:Refresh()
    return nil, lastRefuse
  end
  self.selectedFighterA = id
  self:Refresh()
  return true
end

function Console:SetFighterB()
  if fightersLocked == true then
    lastRefuse = "fighters are locked"
    self:Refresh()
    return nil, lastRefuse
  end
  local id, ensureErr = ensureSubjectId(self, "character")
  if id == nil then return nil, ensureErr or "Target a fighter first" end
  if isId(self.selectedFighterA) and self.selectedFighterA == id then
    lastRefuse = "a Gora needs two different combatants"
    self:Refresh()
    return nil, lastRefuse
  end
  self.selectedFighterB = id
  self:Refresh()
  return true
end

-- Petition row: fill the next empty Fighter A/B when a store id exists.
-- Unsigned name-key rows select/paint only — never Ensure, never Sanction.
function Console:UsePetitioner(row)
  if type(row) ~= "table" then
    return nil
  end
  if isId(row.characterId) then
    self:SelectCharacter(row.characterId)
    if not isId(self.selectedFighterA) then
      self.selectedFighterA = row.characterId
    elseif not isId(self.selectedFighterB) then
      self.selectedFighterB = row.characterId
    end
    self:Refresh()
    return true
  end
  local name = row.name
  if type(name) ~= "string" or name == "" then
    name = row.senderKey
  end
  if type(name) == "string" and name ~= "" then
    self.subject = applyGuildDisplay({
      name = name,
      source = "selection",
      needsKnighting = false,
    })
  end
  self:Refresh()
  return true
end

--------------------------------------------------------------------------------
-- Verbs — fail closed unless the local sender is a registered Pope. The desk
-- writes signed Core only; bootstrap glue owns the wire and the theater.
--------------------------------------------------------------------------------

function Console._closeRiteAfterVerdict()
  local snap = currentSnap()
  if currentState(snap) == "RITE" and COB.Runtime and type(COB.Runtime.CloseRite) == "function" then
    COB.Runtime:CloseRite()
  end
end

local function after(self, result, err)
  if result ~= nil then
    lastRefuse = nil
    persistSession()
    self:Refresh()
  elseif type(err) == "string" and err ~= "" then
    lastRefuse = err
    if self.frame and self.frame.GateStatus then
      self.frame.GateStatus:SetText(err)
    end
  end
  return result, err
end

local function boxText(frame, key)
  local box = frame and frame[key]
  if box and box.GetText then
    return box:GetText()
  end
  return nil
end

local function decreeFields(self, fields)
  if type(fields) == "table" then return fields end
  local frame = self.frame
  if not frame then return {} end
  local line = frame.DecreeLine and frame.DecreeLine.GetText and frame.DecreeLine:GetText() or nil
  local flavor = frame.DecreeFlavor and frame.DecreeFlavor.GetText and frame.DecreeFlavor:GetText() or nil
  return { line = line, flavor = flavor }
end

local function seriesFields(self, fields)
  if type(fields) == "table" then return fields end
  local frame = self.frame
  local kind = nightsDesk.churchKind
  if kind ~= "knighting" and kind ~= "gora" then
    kind = "gathering"
  end
  return {
    kind = kind,
    weekday = nightsDesk.weekdayNow(),
    timeLine = nightsDesk.clock(),
    place = trimText(boxText(frame, "DecreeLine")),
    flavor = trimText(boxText(frame, "DecreeFlavor")),
  }
end

local function firstLiveSeries()
  if not (COB.Nights and COB.Nights.ListSeries) then return nil end
  local list = COB.Nights:ListSeries()
  for i = 1, #list do
    if list[i].withdrawn ~= true then
      return list[i]
    end
  end
  return nil
end

local function nextSeriesDate(seriesId)
  if not (COB.Nights and COB.Nights.Month) then return nil end
  local rows = COB.Nights:Month()
  for i = 1, #rows do
    if rows[i].seriesId == seriesId then
      return rows[i].date
    end
  end
  return nil
end

function Console:StartEvent()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.StartEvent then
    return nil, "runtime is not available"
  end
  local result, err = COB.Runtime:StartEvent()
  if result ~= nil then
    self.selectedFighterA = nil
    self.selectedFighterB = nil
    candidateLocked = false
    fightersLocked = false
    selectedWinnerId = nil
    lastVerdict = nil
    knightingComplete = nil
    pendingConfirm = nil
    gatheringStartedAt = wallNow()
    persistStartedAt(gatheringStartedAt)
    deskTab = "gathering"
  end
  return after(self, result, err)
end

function Console:OpenRite(kind)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.OpenRite then
    return nil, "runtime is not available"
  end
  local snap = currentSnap()
  if currentState(snap) == "RITE" and type(snap) == "table" and snap.riteType == kind then
    return after(self, snap, nil)
  end
  local subjects = nil
  if kind == "Knighting" then
    local candidate
    if type(self.subject) == "table" then
      candidate = ensureSubjectId(self, "human")
    end
    if not isId(candidate) then
      local Knighting = COB.Knighting
      local line
      if Knighting and type(Knighting.GetLine) == "function" then
        line = Knighting:GetLine()
      end
      if type(line) == "table" then
        local head = line[1]
        if type(head) == "table" and isId(head.humanId) then
          candidate = head.humanId
        end
      end
    end
    if isId(candidate) then
      subjects = { candidate = candidate }
    end
  elseif kind == "Gora" then
    local a, b = self.selectedFighterA, self.selectedFighterB
    if not (isId(a) and isId(b)) then
      local pair
      local Gora = COB.Gora
      if Gora and type(Gora.GetSanctioned) == "function" then
        pair = Gora:GetSanctioned()
      end
      if type(pair) == "table" then
        a = pair.fighterA
        b = pair.fighterB
      end
    end
    if isId(a) and isId(b) then
      subjects = { fighters = { a, b } }
    end
  end
  local result, err = COB.Runtime:OpenRite(kind, subjects)
  if result ~= nil then
    deskTab = "gathering"
    if kind == "Knighting" then
      candidateLocked = true
      if subjects and isId(subjects.candidate) then
        self.subject = subjectForHumanId(subjects.candidate, "selection")
      end
    elseif kind == "Gora" then
      lastVerdict = nil
      selectedWinnerId = nil
    end
  end
  return after(self, result, err)
end

function Console:CloseRite()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.CloseRite then
    return nil, "runtime is not available"
  end
  local result, err = COB.Runtime:CloseRite()
  return after(self, result, err)
end

function Console:Continue()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.Continue then
    return nil, "runtime is not available"
  end
  local result, err = COB.Runtime:Continue()
  if result ~= nil then
    lastVerdict = nil
    knightingComplete = nil
    candidateLocked = false
    if not liveSanctionedPair() then
      fightersLocked = false
      selectedWinnerId = nil
    end
    pendingConfirm = nil
  end
  return after(self, result, err)
end

function Console:EndEvent()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.EndEvent then
    return nil, "runtime is not available"
  end
  local result, err = COB.Runtime:EndEvent()
  if result ~= nil then
    self.selectedFighterA = nil
    self.selectedFighterB = nil
    self.subject = nil
    candidateLocked = false
    fightersLocked = false
    selectedWinnerId = nil
    lastVerdict = nil
    knightingComplete = nil
    pendingConfirm = nil
    gatheringStartedAt = nil
    persistStartedAt(nil)
    -- A still-selected target reappears as the working subject.
    refreshTargetSubject(self)
  end
  return after(self, result, err)
end

function Console:KnightThisBeef(humanId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Knighting or not COB.Knighting.KnightThisBeef then
    return nil, "knighting is not available"
  end
  local id = humanId
  if id == nil then
    if type(self.subject) ~= "table" then
      return nil, "Target the Beef you are knighting"
    end
    id = ensureSubjectId(self, "human")
    if id == nil then
      return nil, "Target the Beef you are knighting"
    end
  end
  local result, err = COB.Knighting:KnightThisBeef(id)
  if result ~= nil then
    local human = COB.Store and COB.Store.GetHuman and COB.Store:GetHuman(id)
    knightingComplete = {
      name = human and human.name or (self.subject and self.subject.name),
      toTitle = rankTitle(3) or "Beef Knight",
      humanId = id,
    }
    if deskView().rite == "knighting" then
      candidateLocked = true
    else
      knightingComplete = nil
    end
    if self.subject then
      refreshSubjectRanks(self)
    end
  end
  return after(self, result, err)
end

function Console:ElevateToLord(humanId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Knighting or not COB.Knighting.ElevateToLord then
    return nil, "knighting is not available"
  end
  local id = humanId
  if id == nil and type(self.subject) == "table" then
    id = ensureSubjectId(self, "human")
  end
  local result, err = COB.Knighting:ElevateToLord(id)
  if result ~= nil then
    if deskView().rite == "knighting" then
      local human = COB.Store and COB.Store.GetHuman and COB.Store:GetHuman(id)
      knightingComplete = {
        name = human and human.name or (self.subject and self.subject.name),
        toTitle = rankTitle(4) or "Beef Lord",
        humanId = id,
      }
      candidateLocked = true
    end
    if self.subject then
      refreshSubjectRanks(self)
    end
  end
  return after(self, result, err)
end

function Console:Enqueue(humanId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Knighting or type(COB.Knighting.Enqueue) ~= "function" then
    return nil, "knighting is not available"
  end
  local id = humanId
  if id == nil and type(self.subject) == "table" then
    id = ensureSubjectId(self, "human")
  end
  local result, err = COB.Knighting:Enqueue(id)
  return after(self, result, err)
end

function Console:Skip(humanId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Knighting or type(COB.Knighting.Skip) ~= "function" then
    return nil, "knighting is not available"
  end
  local id = humanId
  if id == nil and type(self.subject) == "table" then
    id = ensureSubjectId(self, "human")
  end
  local result, err = COB.Knighting:Skip(id)
  return after(self, result, err)
end

function Console:Sanction(fighterA, fighterB)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.Sanction then
    return nil, "gora is not available"
  end
  local a = fighterA
  local b = fighterB
  if a == nil then a = self.selectedFighterA end
  if b == nil then b = self.selectedFighterB end
  if not (isId(a) and isId(b)) then
    return after(self, nil, "Set Fighter A and Fighter B first")
  end
  local result, err = COB.Gora:Sanction(a, b)
  if result ~= nil then
    fightersLocked = true
    lastVerdict = nil
    selectedWinnerId = nil
    selectedOutcome = "victor"
    local snap = currentSnap()
    if currentState(snap) == "ASSEMBLY" and COB.Runtime and COB.Runtime.OpenRite then
      COB.Runtime:OpenRite("Gora", { fighters = { a, b } })
    end
  end
  return after(self, result, err)
end

function Console:Dismiss(characterId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.Dismiss then
    return nil, "gora is not available"
  end
  local id = characterId
  if id == nil and type(self.subject) == "table" then
    id = self.subject.characterId
  end
  local ok = COB.Gora:Dismiss(id)
  if not ok then
    return nil, "No petition from that fighter"
  end
  if type(self.subject) == "table" and isId(id) and self.subject.characterId == id then
    self.subject = nil
  end
  if isId(id) and (id == self.selectedFighterA or id == self.selectedFighterB) then
    self.selectedFighterA = nil
    self.selectedFighterB = nil
  end
  self:Refresh()
  return true
end

function Console:DeclareVictor(winnerId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.DeclareVictor then
    return nil, "gora is not available"
  end
  if lastVerdict then
    return after(self, nil, "verdict already recorded")
  end
  local id = winnerId
  if id == nil then
    armProposedWinner()
    id = selectedWinnerId
  end
  if id == nil then
    if type(self.subject) ~= "table" then
      refreshTargetSubject(self)
    end
    if type(self.subject) ~= "table" then
      return after(self, nil, "Target the victor")
    end
    id = ensureSubjectId(self, "character")
    if id == nil then
      return after(self, nil, "Target the victor")
    end
  end
  local result, err = COB.Gora:DeclareVictor(id)
  if result ~= nil then
    lastVerdict = result
    fightersLocked = true
    -- Elevation beat: the victor becomes the working subject.
    local source = type(self.subject) == "table" and self.subject.source or nil
    self.subject = subjectForCharacterId(result.winnerId, source)
    Console._closeRiteAfterVerdict()
  end
  return after(self, result, err)
end

function Console:CowardiceRecorded(fleerId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.CowardiceRecorded then
    return nil, "gora is not available"
  end
  local id = fleerId
  if id == nil then
    if type(self.subject) ~= "table" then
      refreshTargetSubject(self)
    end
    if type(self.subject) ~= "table" then
      return after(self, nil, "Target the fleeing fighter")
    end
    id = ensureSubjectId(self, "character")
    if id == nil then
      return after(self, nil, "Target the fleeing fighter")
    end
  end
  if lastVerdict then
    return after(self, nil, "verdict already recorded")
  end
  local result, err = COB.Gora:CowardiceRecorded(id)
  if result ~= nil then
    lastVerdict = result
    Console._closeRiteAfterVerdict()
  end
  return after(self, result, err)
end

function Console:Void()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.Void then
    return nil, "gora is not available"
  end
  if lastVerdict then
    return after(self, nil, "verdict already recorded")
  end
  local result, err = COB.Gora:Void()
  if result ~= nil then
    lastVerdict = result
    Console._closeRiteAfterVerdict()
  end
  return after(self, result, err)
end

function Console:FreeRuling(text)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.FreeRuling then
    return nil, "gora is not available"
  end
  if text == nil then
    local box = self.frame and self.frame.FreeRulingText
    if box and box.GetText then
      text = box:GetText()
    end
  end
  if lastVerdict then
    return after(self, nil, "verdict already recorded")
  end
  local result, err = COB.Gora:FreeRuling(text)
  if result ~= nil then
    lastVerdict = result
    Console._closeRiteAfterVerdict()
  end
  return after(self, result, err)
end

function Console:FlagMoment(location, now)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Store or not COB.Store.FlagMoment then
    return nil, "store is not available"
  end
  if location == nil and type(GetSubZoneText) == "function" then
    location = trimText(GetSubZoneText())
  end
  local result, err = COB.Store:FlagMoment(location, now)
  return after(self, result, err)
end

function Console:PostDecree(fields)
  if not isRegisteredPope() then return nil, REFUSE end
  if decreeBusy then return nil, "already posting" end
  if not COB.Decree or not COB.Decree.Set then
    return nil, "decree is not available"
  end
  decreeBusy = true
  -- Quiet desk verb: Core Set only. The integrator sends the wire.
  local result, err = COB.Decree:Set(decreeFields(self, fields))
  if result ~= nil and COB.Nights and COB.Nights.SetSeries then
    local today
    local stamp = type(date) == "function" and date
      or (type(os) == "table" and os.date)
    if type(stamp) == "function" then
      local stampOk, stamped = pcall(stamp, "%Y-%m-%d")
      if stampOk then today = stamped end
    end
    COB.Nights:SetSeries({
      kind = "gathering",
      timeLine = result.line,
      place = result.line,
      flavor = result.flavor,
      oneshotDate = today,
    })
  end
  decreeBusy = false
  if result ~= nil then
    deskTab = "decrees"
    self:Refresh()
  end
  return result, err
end

function Console:PostStub(fields)
  local name
  if COB.Group and COB.Group.PlayerName then
    name = COB.Group.PlayerName()
  end
  if not (COB.Sender and COB.Sender.CanWriteStub and COB.Sender:CanWriteStub(name)) then
    return nil, REFUSE
  end
  if not (COB.Nights and COB.Nights.SetStub) then
    return nil, "nights is not available"
  end
  if type(fields) ~= "table" then
    fields = {
      kind = nightsDesk.stubKind,
      date = nightsDesk.dateYmd(),
      timeLine = nightsDesk.clock(),
      place = trimText(boxText(self.frame, "DecreeLine")),
      title = trimText(boxText(self.frame, "StubTitle")),
    }
  end
  local result, err = COB.Nights:SetStub({
    kind = fields.kind == "pvp" and "pvp" or "raid",
    title = fields.title or fields.line,
    timeLine = fields.timeLine or nightsDesk.clock() or fields.line or "",
    place = fields.place or fields.flavor or fields.line or "",
    date = fields.date or nightsDesk.dateYmd(),
    createdBy = name,
  })
  if result ~= nil then
    deskTab = "decrees"
    self:Refresh()
  end
  return result, err
end

function Console:PostSeries(fields)
  if not isRegisteredPope() then return nil, REFUSE end
  if not (COB.Nights and COB.Nights.SetSeries) then
    return nil, "nights is not available"
  end
  local result, err = COB.Nights:SetSeries(seriesFields(self, fields))
  if result ~= nil then
    deskTab = "decrees"
    self:Refresh()
  end
  return result, err
end

function Console:SkipWeek(seriesId, date)
  if not isRegisteredPope() then return nil, REFUSE end
  if not (COB.Nights and COB.Nights.SkipWeek) then
    return nil, "nights is not available"
  end
  local row = firstLiveSeries()
  seriesId = seriesId or (row and row.id)
  date = date or (seriesId and nextSeriesDate(seriesId))
  local result, err = COB.Nights:SkipWeek(seriesId, date)
  if result ~= nil then self:Refresh() end
  return result, err
end

function Console:MoveWeek(seriesId, date, fields)
  if not isRegisteredPope() then return nil, REFUSE end
  if not (COB.Nights and COB.Nights.MoveWeek) then
    return nil, "nights is not available"
  end
  local row = firstLiveSeries()
  seriesId = seriesId or (row and row.id)
  date = date or (seriesId and nextSeriesDate(seriesId))
  fields = type(fields) == "table" and fields or {
    timeLine = nightsDesk.clock(),
    place = trimText(boxText(self.frame, "DecreeLine")),
  }
  local result, err = COB.Nights:MoveWeek(seriesId, date, fields)
  if result ~= nil then self:Refresh() end
  return result, err
end

function Console:WithdrawSeries(seriesId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not (COB.Nights and COB.Nights.WithdrawSeries) then
    return nil, "nights is not available"
  end
  local row = firstLiveSeries()
  seriesId = seriesId or (row and row.id)
  local result, err = COB.Nights:WithdrawSeries(seriesId)
  if result ~= nil then self:Refresh() end
  return result, err
end

function Console:WithdrawStub(id)
  if not canWriteStub() then return nil, REFUSE end
  if not (COB.Nights and COB.Nights.WithdrawStub) then
    return nil, "nights is not available"
  end
  id = id or trimText(boxText(self.frame, "StubTitle"))
  if not id then
    local maybe = trimText(boxText(self.frame, "DecreeLine"))
    if maybe and maybe:find(":", 1, true) then
      id = maybe
    end
  end
  if not id and COB.Nights.ListStubs then
    local stubs = COB.Nights:ListStubs()
    if stubs[1] then id = stubs[1].id end
  end
  local result, err = COB.Nights:WithdrawStub(id)
  if result ~= nil then
    self:Refresh()
    return id
  end
  return result, err
end

function Console:SetCongregationFavorVisible(flag)
  if not isRegisteredPope() then return nil, REFUSE end
  if type(flag) ~= "boolean" then
    return nil, "flag must be a boolean"
  end
  congregationFavorVisible = flag
  if self.frame and self.frame.CongregationFavor then
    self.frame.CongregationFavor:SetChecked(flag)
  end
  return true
end

function Console:SelectCandidateFromTarget()
  if not isRegisteredPope() then return nil, REFUSE end
  local preview = targetPreview or readTargetPreview()
  if type(preview) ~= "table" then
    return nil, "Target the Beef you are knighting"
  end
  self.subject = preview
  local id = ensureSubjectId(self, "human")
  if not isId(id) then
    return nil, "Target the Beef you are knighting"
  end
  candidateLocked = true
  self:Refresh()
  return true
end

function Console:RecordVerdict()
  if lastVerdict then
    return after(self, nil, "verdict already recorded")
  end
  local outcome = selectedOutcome or "victor"
  if outcome == "void" then
    return self:Void()
  end
  if outcome == "free" then
    return self:FreeRuling()
  end
  local pair = liveSanctionedPair()
  if outcome == "cowardice" then
    local fleer = self.subject and self.subject.characterId
    if isId(selectedWinnerId) and pair then
      if selectedWinnerId == pair.fighterA then
        fleer = pair.fighterB
      elseif selectedWinnerId == pair.fighterB then
        fleer = pair.fighterA
      end
    end
    return self:CowardiceRecorded(fleer)
  end
  return self:DeclareVictor(selectedWinnerId)
end

function Console:CancelConfirm()
  pendingConfirm = nil
  self:Refresh()
  return true
end

function Console:AcceptConfirm()
  local pending = pendingConfirm
  pendingConfirm = nil
  if type(pending) ~= "table" or type(pending.action) ~= "string" then
    self:Refresh()
    return true
  end
  if pending.action == "end" then
    local view = deskView()
    if view.rite and currentState(currentSnap()) == "RITE" then
      local closed = self:CloseRite()
      if closed == nil then
        return nil, lastRefuse
      end
    end
    return self:EndEvent()
  end
  if pending.action == "close" then
    return self:CloseRite()
  end
  if pending.action == "voidThenClose" then
    local voided = self:Void()
    if voided == nil and lastRefuse then
      return nil, lastRefuse
    end
    return self:CloseRite()
  end
  if pending.action == "withdraw" then
    return self:WithdrawDecree()
  end
  self:Refresh()
  return true
end

function Console:RequestEndGathering()
  if not isRegisteredPope() then return nil, REFUSE end
  local view = deskView()
  if view.gathering == "inactive" then
    return self:EndEvent()
  end
  if view.rite == "gora" and view.goraPhase == "sanctioned" then
    pendingConfirm = {
      title = "End the Gathering?",
      body = "This Gora is sanctioned but has no verdict. Ending closes the rite.",
      cancelLabel = "Cancel",
      okLabel = "End Gathering",
      action = "end",
    }
    self:Refresh()
    return true
  end
  if view.rite then
    pendingConfirm = {
      title = "End the Gathering?",
      body = "An active rite will be closed and unsaved setup may be discarded.",
      cancelLabel = "Cancel",
      okLabel = "End Gathering",
      action = "end",
    }
    self:Refresh()
    return true
  end
  return self:EndEvent()
end

-- Pope escape: close any open mode and end the gathering. No confirm.
function Console:ForceEndGathering()
  if not isRegisteredPope() then return nil, REFUSE end
  pendingConfirm = nil
  local snap = currentSnap()
  if currentState(snap) == "RITE" then
    local closed, err = self:CloseRite()
    if closed == nil then return nil, err end
  end
  return self:EndEvent()
end

function Console:RequestCloseRite()
  if not isRegisteredPope() then return nil, REFUSE end
  local view = deskView()
  if view.rite == "gora" and view.goraPhase == "sanctioned" then
    pendingConfirm = {
      title = "This Gora is sanctioned but has no verdict.",
      body = "Stay in the Gora, or void it and return to the gathering.",
      cancelLabel = "Stay in Gora",
      okLabel = "Void and leave",
      action = "voidThenClose",
    }
    self:Refresh()
    return true
  end
  return self:CloseRite()
end

function Console:ReturnToGathering()
  if not isRegisteredPope() then return nil, REFUSE end
  local state = currentState(currentSnap())
  if state == "RITE" then
    local closed, err = self:CloseRite()
    if closed == nil then return nil, err end
  end
  state = currentState(currentSnap())
  if state == "CONSEQUENCE" then
    return self:Continue()
  end
  lastVerdict = nil
  knightingComplete = nil
  candidateLocked = false
  self:Refresh()
  return true
end

function Console:WithdrawDecree()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Decree or type(COB.Decree.Clear) ~= "function" then
    return nil, "decree is not available"
  end
  COB.Decree:Clear()
  self:Refresh()
  return true
end
