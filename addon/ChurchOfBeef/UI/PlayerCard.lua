ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Player card — `/beef`. Bible §12.5 (the profile aggregates the character's
-- story), §14.2 (player-opened Quiet identity/history), §22.1 item 7.
-- MODE QUIET: opened by the player, never unbidden. Home answers four
-- clerical questions from existing keepers: who you are, the posted
-- gathering, the first three sanctioned-victory stories, and the latest
-- Chronicle lines. It is not a feed, not a calendar, and it never shows a
-- position among members — §10.9 permanently rejects a sorted ladder.
-- Comparison is Church rank, distinctions held, head-to-heads.
-- A live guild rank name fills the gold plate when the store has no human
-- row. Canon titles also get the §5 relationship line. Any other live
-- guild name uses the newness line — the Pope has not written you yet.
-- No Church title and no guild name: the gold plate stays empty; the
-- newness line still stands. That is display, not a store write and not
-- a seventh Church rank. A live event changes the ribbon, not the title.
-- Theatrical parchment via Theme (Law 10). Ink discipline: charcoal / iron /
-- oxblood text on parchment; gold, parchment, and class color only on
-- charcoal plates. Clerical copy only. The UI never narrates, never jokes.
local PlayerCard = { MODE = "QUIET", view = "home" }
COB.PlayerCard = PlayerCard

local FRAME_NAME = "ChurchOfBeefPlayerCard"
local CARD_W, CARD_H = 600, 536
local CARD_H_QUIET = 444
local MID_H = 180
local MID_QUIET = 88
-- THIS WEEK is the primary home column. Gora is a narrower rail; Chronicle
-- stays full-bleed under the pair. 2:1 reads as hierarchy and gives the
-- night list room for two-line rows (NightRows compact trips below 360).
local WEEK_SHARE = 2 / 3
local CHRONICLE_H = 96
local HOME_BOTTOM = 8
local FOOTER_H = 36
local LEDGER_COL = { name = 8, record = 196, streak = 292, last = 392 }
local PORTRAIT_PX = 56
local MAX_VICTORIES = 3
local MAX_CHRONICLE = 2
local MAX_LEDGER = 8
local LEDGER_ROW_H = 22
local EN_DASH = "\226\128\147"
local MIDDLE_DOT = " \194\183 "
-- Full-surface parchment masters keep a 12% transparent safety margin.
local SURFACE_U0, SURFACE_U1 = 0.12, 0.88

local COPY = {
  church = "Church of Beef",
  unrecordedLine = "The Pope has not written you yet. That is normal.",
  unranked = "UNRANKED",
  unrankedLine = "Recorded, no rank yet.",
  gathering = "GATHERING",
  decree = "DECREE",
  knighting = "KNIGHTING",
  gora = "GORA",
  confession = "CONFESSION",
  proclamation = "PROCLAMATION",
  goraLabel = "BEEF GORA",
  victoriesLabel = "MOST SANCTIONED VICTORIES",
  weekLabel = "THIS WEEK",
  streak = "Streak ",
  defenses = "Defenses ",
  goraPrefix = "Gora ",
  noDecree = "No nights posted this week.",
  noGora = "No sanctioned Goras are on the record.",
  yourRecord = "Your record ",
  chronicleLabel = "FROM THE CHRONICLE",
  chronicleSilent = "THE CHRONICLE IS SILENT",
  chronicleEmpty = "No sitting has been written.",
  readDecree = "OPEN NIGHTS",
  going = "Going",
  theRecord = "THE RECORD",
  readMore = "READ MORE",
  navChurch = "CHURCH",
  navGora = "GORA",
  records = "RECORDS",
  desk = "THE DESK",
  knighted = "Knighted ",
  level = "Level ",
  lastVictor = "victor over ",
  lastFell = "fell to ",
  lastCowardice = "cowardice vs ",
  lastVoid = "void vs ",
  lastRuling = "ruling vs ",
}
PlayerCard.COPY = COPY

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do out[deepcopy(k)] = deepcopy(v) end
  return out
end

local function themeColor(role)
  local Theme = COB.Theme
  if not (Theme and type(Theme.Color) == "function") then return nil end
  return Theme:Color(role)
end

local function classColor(classFile)
  local Theme = COB.Theme
  if not (Theme and type(Theme.ClassColor) == "function") then return nil end
  return Theme:ClassColor(classFile)
end

local function themeFont(role)
  local Theme = COB.Theme
  if not (Theme and type(Theme.FontPath) == "function") then return nil end
  return Theme:FontPath(role)
end

local function themeTexture(name)
  local Theme = COB.Theme
  if not (Theme and type(Theme.Texture) == "function") then return nil end
  return Theme:Texture(name)
end

local function space(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
  if type(sizes) == "table" and type(sizes[key]) == "number" then return sizes[key] end
  return fallback
end

local function localSender()
  if type(UnitName) == "function" then
    return UnitName("player")
  end
  return nil
end

local function isListedPope()
  local Sender = COB.Sender
  if not Sender or type(Sender.IsRegisteredPope) ~= "function" then
    return false
  end
  return Sender:IsRegisteredPope(localSender()) == true
end

local function fontSize(key, fallback)
  local sizes = COB.Theme and COB.Theme.FontSize
  if type(sizes) == "table" and type(sizes[key]) == "number" then return sizes[key] end
  return fallback
end

local function fillRole(tex, role, alpha)
  if not tex then return end
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, alpha or 1)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, alpha or 1)
  end
  tex._cobColorRole = role
end

local function applyInk(fs, role)
  if not fs then return end
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  if fs.SetTextColor then fs:SetTextColor(r, g, b, 1) end
  fs._cobColorRole = role
end

local function applyTexture(tex, name)
  if not tex then return false end
  local path = themeTexture(name)
  tex._cobTextureName = name
  tex._cobTexture = path
  if type(path) ~= "string" or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  return ok and true or false
end

local function applyStockObject(fs, template, size)
  if fs.SetFontObject then
    local font = type(template) == "string" and _G[template] or template
    if font then pcall(fs.SetFontObject, fs, font) end
  end
  -- GameFontNormalSmall is 10px on Anniversary. Floor stays 12.
  local want = size or 12
  if want < 12 then want = 12 end
  if not (fs.GetFont and fs.SetFont) then return end
  local path, _, flags = fs:GetFont()
  if type(path) ~= "string" or path == "" then
    local font = type(template) == "string" and _G[template] or template
    if type(font) == "table" and font.GetFont then
      path, _, flags = font:GetFont()
    end
  end
  if type(path) == "string" and path ~= "" then
    pcall(fs.SetFont, fs, path, want, flags or "")
  end
end

local function applyFont(fs, template, role, size)
  if not fs then return end
  -- Display/blackletter is nameplate only (Church of Beef, name, Church rank).
  -- Never paint that face in all caps — Grenze reads as a ransom note.
  -- Every other string on this window is stock GameFont*.
  if role == "display" then
    local path = themeFont("display")
    local used = false
    if path and fs.SetFont then
      local ok, applied = pcall(fs.SetFont, fs, path, size or fontSize("name", 16), "")
      used = ok and applied ~= false
    end
    if not used then applyStockObject(fs, template, size or fontSize("name", 16)) end
    fs._cobFontRole = "display"
    fs._cobFontPath = path
    fs._cobFontSize = size
    return
  end
  applyStockObject(fs, template, size)
  fs._cobFontRole = role
  fs._cobFontPath = nil
  fs._cobFontSize = size
end

local function arabicCount(n)
  local whole = 0
  if type(n) == "number" then whole = math.floor(n) end
  if whole < 0 then whole = 0 end
  return tostring(whole)
end

local function arabicPair(a, b)
  return arabicCount(a) .. EN_DASH .. arabicCount(b)
end

local function stamp(at, fmt)
  if type(at) ~= "number" then return nil end
  local fn = type(date) == "function" and date or (type(os) == "table" and os.date) or nil
  if type(fn) ~= "function" then return nil end
  local ok, s = pcall(fn, fmt or "%b %d, %Y", at)
  if ok and type(s) == "string" then return s end
  return nil
end

local function safeCall(fn, ...)
  if type(fn) ~= "function" then return nil end
  local ok, a, b = pcall(fn, ...)
  if not ok then return nil end
  return a, b
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

local function wireCardOnHide(widget)
  if not widget or type(widget.SetScript) ~= "function" then return end
  local existing = type(widget.GetScript) == "function" and widget:GetScript("OnHide")
  if existing then return end
  widget:SetScript("OnHide", function()
    rememberSpecial(FRAME_NAME)
    PlayerCard.view = "home"
    if type(widget.UnregisterEvent) == "function" then
      pcall(widget.UnregisterEvent, widget, "GUILD_ROSTER_UPDATE")
      pcall(widget.UnregisterEvent, widget, "PLAYER_GUILD_UPDATE")
      pcall(widget.UnregisterEvent, widget, "UNIT_PORTRAIT_UPDATE")
    end
  end)
end

local function kickRoster()
  local Roster = COB.Roster
  if type(Roster) ~= "table" then return end
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

local function listenForGuild(frame)
  if not frame or type(frame.RegisterEvent) ~= "function" then return end
  pcall(frame.RegisterEvent, frame, "GUILD_ROSTER_UPDATE")
  pcall(frame.RegisterEvent, frame, "PLAYER_GUILD_UPDATE")
  pcall(frame.RegisterEvent, frame, "UNIT_PORTRAIT_UPDATE")
  if type(frame.SetScript) ~= "function" then return end
  if type(frame.GetScript) == "function" and frame:GetScript("OnEvent") then return end
  frame:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_PORTRAIT_UPDATE" and unit ~= nil and unit ~= "player" then
      return
    end
    kickRoster()
    if PlayerCard.frame and PlayerCard.frame:IsShown() then
      PlayerCard:Refresh()
    end
  end)
end

local function uiSlot()
  if type(ChurchOfBeefDB) ~= "table" or type(ChurchOfBeefDB.ui) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui.playerCard) ~= "table" then ChurchOfBeefDB.ui.playerCard = {} end
  return ChurchOfBeefDB.ui.playerCard
end

local LAYOUT_VERSION = 3

local function yieldFirstSheet()
  -- Name is split so the card source never contains the first-launch
  -- module token (tests forbid reopening that sheet).
  local sheet = COB["Wel" .. "come"]
  if not (type(sheet) == "table" and type(sheet.IsShown) == "function") then return end
  if sheet:IsShown() ~= true then return end
  local frame = sheet.frame
  if frame and frame.Hide then frame:Hide() end
end

local function stampLayout()
  local slot = uiSlot()
  if slot then slot.layoutVersion = LAYOUT_VERSION end
end

local function savePoint(frame)
  local slot = uiSlot()
  if not slot then return end
  local point, _, relativePoint, x, y = frame:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  slot.point = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(frame)
  local slot = uiSlot()
  local p = slot and slot.point
  frame:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    frame:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
end

--------------------------------------------------------------------------------
-- Model: derived from the Store, Records, Ranks, Decree, and the local unit
--------------------------------------------------------------------------------

local function nameKey(name)
  if not (COB.Names and type(COB.Names.Key) == "function") then return nil end
  return COB.Names.Key(name)
end

local function playerIdentity()
  local name = safeCall(UnitName, "player")
  if type(name) ~= "string" or name == "" then name = nil end
  local class, classFile = safeCall(UnitClass, "player")
  if type(class) ~= "string" then class = nil end
  if type(classFile) ~= "string" then classFile = nil end
  local level = safeCall(UnitLevel, "player")
  if type(level) ~= "number" then level = nil end
  local guildName, guildRank
  if type(GetGuildInfo) == "function" then
    local ok, a, b = pcall(GetGuildInfo, "player")
    if ok then
      if type(a) == "string" and a ~= "" then guildName = a end
      if type(b) == "string" and b ~= "" then guildRank = b end
    end
  end
  local Roster = COB.Roster
  if type(Roster) == "table" and name then
    if not guildRank and type(Roster.GetGuildRankName) == "function" then
      local ok, value = pcall(Roster.GetGuildRankName, Roster, name)
      if ok and type(value) == "string" and value ~= "" then guildRank = value end
    end
  end
  return name, class, classFile, level, guildName, guildRank
end

local function findCharacter(snapshot, name)
  local key = nameKey(name)
  if not key then return nil end
  local list = type(snapshot) == "table" and snapshot.characters or nil
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and nameKey(row.name) == key then return row end
  end
  return nil
end

local function runtimeView()
  local Runtime = COB.Runtime
  if type(Runtime) ~= "table" or type(Runtime.Snapshot) ~= "function" then
    return nil, nil
  end
  local snap = safeCall(Runtime.Snapshot, Runtime)
  if type(snap) ~= "table" then return nil, nil end
  local state = type(snap.state) == "string" and snap.state or nil
  local rite = type(snap.riteType) == "string" and snap.riteType or nil
  return state, rite
end

local function leftoverRibbonRole(copy)
  if copy == COPY.knighting then return "knighting" end
  if copy == COPY.gora then return "gora" end
  return "gathering"
end

-- Clerical event category. Never paint QUIET / ASSEMBLY / RITE / CONSEQUENCE.
local function ribbonCopy(state, riteType)
  if state == "RITE" or state == "CONSEQUENCE" then
    if riteType == "Knighting" then return COPY.knighting end
    if riteType == "Gora" then return COPY.gora end
    if riteType == "Confession" then return COPY.confession end
    if riteType == "Proclamation" then return COPY.proclamation end
    return COPY.gathering
  end
  if state == "ASSEMBLY" then return COPY.gathering end
  return COPY.decree
end

local function findHuman(snapshot, humanId)
  if type(humanId) ~= "number" then return nil end
  local list = type(snapshot) == "table" and snapshot.humans or nil
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and row.id == humanId then return row end
  end
  return nil
end

local function knightedAt(snapshot, humanId)
  if type(humanId) ~= "number" then return nil end
  local log = type(snapshot) == "table" and snapshot.ceremonyLog or nil
  if type(log) ~= "table" then return nil end
  local at = nil
  for i = 1, #log do
    local row = log[i]
    if type(row) == "table" and row.type == "Knighting"
        and type(row.participantIds) == "table" and row.participantIds[1] == humanId
        and type(row.at) == "number" then
      if at == nil or row.at > at then at = row.at end
    end
  end
  return at
end

local function victoryFront()
  local Records = COB.Records
  if type(Records) == "table" and type(Records.VictoryFront) == "function" then
    local rows = Records:VictoryFront(MAX_VICTORIES)
    if type(rows) == "table" then return rows end
  end
  if type(Records) == "table" and type(Records.FighterStories) == "function" then
    local stories = Records:FighterStories()
    if type(stories) ~= "table" then return {} end
    local out = {}
    for i = 1, math.min(#stories, MAX_VICTORIES) do
      out[i] = stories[i]
    end
    return out
  end
  return {}
end

local function lastLine(story)
  if type(story) ~= "table" or type(story.last) ~= "table" then return "" end
  local last = story.last
  local opp = type(last.opponentName) == "string" and last.opponentName or "an opponent"
  if last.ruling == "cowardice" then
    return COPY.lastCowardice .. opp
  end
  if last.ruling == "void" then
    return COPY.lastVoid .. opp
  end
  if last.ruling == "free" then
    return COPY.lastRuling .. opp
  end
  if last.won == true then return COPY.lastVictor .. opp end
  if last.won == false then return COPY.lastFell .. opp end
  return ""
end

local function buildModel()
  local name, class, classFile, level, guildName, guildRank = playerIdentity()
  local snapshot = {}
  if COB.Store and type(COB.Store.Snapshot) == "function" then
    snapshot = COB.Store:Snapshot() or {}
  end
  local model = {
    name = name, class = class, classFile = classFile, level = level,
    guildName = guildName, guildRank = guildRank,
    entered = false, rankId = nil, rankTitle = nil, relationship = nil,
    knightedAt = nil, honorific = nil, record = nil,
    rivalries = {}, distinctions = {},
    victories = {}, stories = {}, chronicle = {},
    decree = nil, runtimeState = nil, riteType = nil,
  }
  model.runtimeState, model.riteType = runtimeView()

  local character = findCharacter(snapshot, name)
  if character then
    if not model.class and type(character.class) == "string" then model.class = character.class end
    if not model.classFile and type(model.class) == "string" then model.classFile = string.upper(model.class) end
    if not model.level and type(character.level) == "number" then model.level = character.level end

    local human = findHuman(snapshot, character.humanId)
    if human then
      model.entered = true
      local Ranks = COB.Ranks
      if type(human.rankId) == "number" and type(Ranks) == "table" then
        model.rankId = human.rankId
        if type(Ranks.Title) == "function" then model.rankTitle = Ranks.Title(human.rankId) end
        if type(Ranks.Relationship) == "function" then model.relationship = Ranks.Relationship(human.rankId) end
      end
      model.knightedAt = knightedAt(snapshot, human.id)
      if type(human.honorifics) == "table" and type(human.honorifics[1]) == "string" then
        model.honorific = human.honorifics[1]
      end
    end

    local Records = COB.Records
    if type(Records) == "table" and type(Records.Summary) == "function" then
      local summary = Records:Summary(character.id)
      if type(summary) == "table" then
        model.record = {
          wins = summary.wins, losses = summary.losses, fought = summary.fought,
          longestStreak = summary.longestStreak, defenses = summary.defenses,
        }
        local rivals = type(summary.rivalries) == "table" and summary.rivalries or {}
        for i = 1, math.min(#rivals, 3) do
          model.rivalries[i] = { name = rivals[i].opponentName, wins = rivals[i].wins, losses = rivals[i].losses }
        end
      end
    end
    if type(Records) == "table" and type(Records.HeldBy) == "function" then
      local held = Records:HeldBy(character.id)
      if type(held) == "table" then
        for i = 1, #held do model.distinctions[#model.distinctions + 1] = held[i] end
      end
    end
    if human and type(human.honorifics) == "table" then
      for i = 1, #human.honorifics do
        if type(human.honorifics[i]) == "string" then
          model.distinctions[#model.distinctions + 1] = human.honorifics[i]
        end
      end
    end
  end

  if not model.entered and not model.rankTitle then
    local Ranks = COB.Ranks
    if type(Ranks) == "table" and type(Ranks.IdForTitle) == "function" then
      local rankId = Ranks.IdForTitle(model.guildRank)
      if type(rankId) == "number" then
        model.rankId = rankId
        if type(Ranks.Title) == "function" then model.rankTitle = Ranks.Title(rankId) end
        if type(Ranks.Relationship) == "function" then model.relationship = Ranks.Relationship(rankId) end
      end
    end
  end

  if COB.Nights and type(COB.Nights.Week) == "function" then
    local week = COB.Nights:Week()
    if type(week) == "table" and #week > 0 then model.nights = week end
  end
  if (not model.nights or #model.nights == 0)
      and COB.Decree and type(COB.Decree.Get) == "function" then
    local row = COB.Decree:Get()
    if type(row) == "table" and type(row.line) == "string" and row.line ~= "" then
      model.decree = { line = row.line, flavor = row.flavor }
    end
  end

  local Records = COB.Records
  model.victories = victoryFront()
  if type(Records) == "table" and type(Records.FighterStories) == "function" then
    local stories = Records:FighterStories()
    if type(stories) == "table" then model.stories = stories end
  end
  if type(Records) == "table" and type(Records.ChroniclePreview) == "function" then
    local preview = Records:ChroniclePreview(MAX_CHRONICLE)
    if type(preview) == "table" then model.chronicle = preview end
  end
  return model
end

local function paintStrings(model)
  local s = {}
  s.name = model.name or ""
  local format = {}
  if model.level then format[#format + 1] = COPY.level .. tostring(model.level) end
  if model.class then format[#format + 1] = model.class end
  s.format = table.concat(format, MIDDLE_DOT)
  if model.rankTitle then
    s.rank = model.rankTitle
    s.relationship = model.relationship or ""
  elseif model.entered then
    s.rank = COPY.unranked
    s.relationship = COPY.unrankedLine
  elseif type(model.guildRank) == "string" and model.guildRank ~= "" then
    s.rank = model.guildRank
    s.relationship = COPY.unrecordedLine
  else
    s.rank = ""
    s.relationship = COPY.unrecordedLine
  end
  s.honorific = type(model.honorific) == "string" and model.honorific or ""
  local when = stamp(model.knightedAt)
  s.knighted = when and (COPY.knighted .. when) or ""
  local guild = {}
  if model.guildName then guild[#guild + 1] = model.guildName end
  if model.guildRank then guild[#guild + 1] = model.guildRank end
  s.guild = table.concat(guild, MIDDLE_DOT)
  local record = model.record
  s.fought = (record and type(record.fought) == "number") and record.fought or 0
  if s.fought > 0 then
    s.record = COPY.goraPrefix .. arabicPair(record.wins, record.losses)
  else
    s.record = ""
  end
  local live = type(model.runtimeState) == "string" and model.runtimeState ~= "QUIET"
  s.ribbon = ribbonCopy(model.runtimeState, model.riteType)
  s.nights = type(model.nights) == "table" and model.nights or {}
  if #s.nights > 0 then
    s.weekTitle = ""
    s.weekFlavor = ""
    s.weekEmpty = false
  elseif model.decree then
    s.weekTitle = model.decree.line
    s.weekFlavor = type(model.decree.flavor) == "string" and model.decree.flavor or ""
    s.weekEmpty = false
  else
    s.weekTitle = COPY.noDecree
    s.weekFlavor = ""
    s.weekEmpty = true
  end
  s.gatheringLive = live
  s.promoted = #s.nights > 0 or model.decree ~= nil
  s.goingRows = {}
  s.victories = {}
  local youKey = nameKey(model.name)
  local youInFront = false
  for i = 1, MAX_VICTORIES do
    local row = model.victories[i]
    if row and type(row.name) == "string" then
      local yours = youKey ~= nil and nameKey(row.name) == youKey
      if yours then youInFront = true end
      s.victories[i] = {
        name = row.name,
        record = arabicPair(row.wins, row.losses),
        wins = row.wins,
        yours = yours,
      }
    end
  end
  s.yourLine = ""
  if s.fought > 0 and not youInFront then
    s.yourLine = COPY.yourRecord .. arabicPair(record.wins, record.losses)
  end
  s.stories = {}
  for i = 1, #model.stories do
    local story = model.stories[i]
    s.stories[i] = {
      name = story.name,
      record = arabicPair(story.wins, story.losses),
      streak = (story.currentStreak or 0) > 0 and (COPY.streak .. arabicCount(story.currentStreak)) or "",
      last = lastLine(story),
      yours = youKey ~= nil and nameKey(story.name) == youKey,
    }
  end
  s.chronicle = {}
  for i = 1, math.min(#model.chronicle, MAX_CHRONICLE) do
    local row = model.chronicle[i]
    s.chronicle[i] = {
      headline = row.headline,
      body = row.body,
    }
  end
  return s
end

--------------------------------------------------------------------------------
-- Frame
--------------------------------------------------------------------------------

local function plate(frame, layer, role, alpha)
  local tex = frame:CreateTexture(nil, layer or "ARTWORK")
  fillRole(tex, role, alpha or 1)
  return tex
end

local function placeNail(frame, key, point, x, y)
  local nail = frame:CreateTexture(nil, "OVERLAY")
  local n = space("nail", 8)
  nail:SetWidth(n)
  nail:SetHeight(n)
  nail:SetPoint(point, frame, point, x, y)
  if not applyTexture(nail, "ornament_nail") then
    fillRole(nail, "iron")
  else
    local r, g, b = themeColor("iron")
    if type(r) == "number" and nail.SetVertexColor then
      pcall(nail.SetVertexColor, nail, r, g, b, 1)
    end
  end
  frame[key] = nail
  return nail
end

local function homeInnerWidth(frame)
  local home = frame and frame.HomePane
  local w = home and home.GetWidth and home:GetWidth()
  if type(w) == "number" and w > 0 then return w end
  return CARD_W - space("xs", 4) * 2 - space("md", 16) * 2
end

local function placeHomeColumns(frame)
  local home = frame and frame.HomePane
  local week = frame and frame.WeekPlate
  local gora = frame and frame.GoraPlate
  if not (home and week and gora) then return end
  local gap = space("sm", 8)
  local homeW = homeInnerWidth(frame)
  local weekW = math.floor(homeW * WEEK_SHARE + 0.5)
  local goraW = homeW - weekW - gap
  local minGora = 140
  if goraW < minGora then
    goraW = minGora
    weekW = homeW - goraW - gap
  end
  if week.ClearAllPoints then week:ClearAllPoints() end
  week:SetPoint("TOPLEFT", home, "TOPLEFT", 0, 0)
  week:SetWidth(weekW)
  if gora.ClearAllPoints then gora:ClearAllPoints() end
  gora:SetPoint("TOPRIGHT", home, "TOPRIGHT", 0, 0)
  gora:SetWidth(goraW)
end

local function ledgerHeight(n)
  if type(n) == "number" and n >= 6 then return CARD_H end
  return CARD_H_QUIET
end

local function label(frame, template, role, size, ink, justify)
  local fs = frame:CreateFontString(nil, "OVERLAY", template)
  applyFont(fs, template, role, size)
  applyInk(fs, ink)
  if fs.SetJustifyH then fs:SetJustifyH(justify or "LEFT") end
  if fs.SetWordWrap then fs:SetWordWrap(false) end
  fs:SetText("")
  return fs
end

local function dressVerb(btn)
  if not btn then return end
  local bg = btn._cobPlate
  if not bg then return end
  if applyTexture(bg, "plate_verb") then
    if bg.SetAllPoints then bg:SetAllPoints(btn) end
  else
    fillRole(bg, "charcoal", 1)
  end
end

local function plateButton(parent, text, w, h)
  local btn = CreateFrame("Button", nil, parent)
  btn:SetWidth(w)
  btn:SetHeight(h)
  local bg = btn:CreateTexture(nil, "ARTWORK")
  if bg.SetAllPoints then bg:SetAllPoints(btn) end
  btn._cobPlate = bg
  dressVerb(btn)
  local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  applyFont(fs, "GameFontNormal", "label", 12)
  applyInk(fs, "gold")
  if fs.SetAllPoints then fs:SetAllPoints(btn) end
  if fs.SetJustifyH then fs:SetJustifyH("CENTER") end
  fs:SetText(text)
  if btn.SetFontString then btn:SetFontString(fs) end
  btn:SetText(text)
  if btn.SetScript then
    btn:SetScript("OnEnter", function()
      if applyTexture(bg, "plate_verb_hover") then
        if bg.SetAllPoints then bg:SetAllPoints(btn) end
      end
    end)
    btn:SetScript("OnLeave", function()
      dressVerb(btn)
    end)
  end
  return btn
end

local function dressInset(box, role, alpha)
  if not box then return end
  box._cobColorRole = role
  -- One stock container. Homemade gold rims plus parchment_decree
  -- (already framed) were the double box.
  local edge = rawget(box, "Edge")
  if edge and edge.Hide then edge:Hide() end
  local fill = rawget(box, "Fill")
  if fill and fill.Hide then fill:Hide() end
  if COB.Theme and type(COB.Theme.ApplyBackdrop) == "function" then
    COB.Theme:ApplyBackdrop(box, "tooltip", role or "parchment", "gold", alpha or 1)
  end
end

local function insetPanel(parent)
  local box
  local ok, minted = pcall(CreateFrame, "Frame", nil, parent, "BackdropTemplate")
  if ok and minted then
    box = minted
  else
    box = CreateFrame("Frame", nil, parent)
  end
  dressInset(box, "parchment", 1)
  return box
end

local function footerButton(parent, text, w, h)
  local btn
  if COB.Theme and type(COB.Theme.PanelButton) == "function" then
    btn = COB.Theme:PanelButton(parent, text)
  end
  if not btn then btn = plateButton(parent, text, w, h) end
  btn:SetWidth(w)
  btn:SetHeight(h)
  return btn
end

local function setShown(widget, shown)
  if not widget then return end
  if shown then
    if widget.Show then widget:Show() end
  else
    if widget.Hide then widget:Hide() end
  end
end

local function portraitParentShown(tex)
  local parent = tex.GetParent and tex:GetParent()
  return parent ~= nil and type(parent.IsShown) == "function" and parent:IsShown() == true
end

-- SetPortraitTexture is blank on a hidden texture (TBC). Seal first so a
-- failed or early call never leaves the gold ring as a solid square.
local function paintPortrait(tex)
  if not tex then return end
  local card = PlayerCard.frame
  if card then
    local seal = card.PortraitSeal
    if seal then applyTexture(seal, "seal_papal_small") end
  end
  applyTexture(tex, "seal_papal_small")
  tex._cobPortrait = "seal"
  if not portraitParentShown(tex) then return end
  if type(SetPortraitTexture) ~= "function" then return end
  local ok = pcall(SetPortraitTexture, tex, "player")
  if ok then tex._cobPortrait = "player" end
end

local function buildFrame()
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent)
  frame:SetFrameStrata("DIALOG")
  if frame.SetToplevel then frame:SetToplevel(true) end
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  if frame.SetResizable then frame:SetResizable(false) end
  frame:SetWidth(CARD_W)
  frame:SetHeight(CARD_H)
  frame:Hide()
  wireCardOnHide(frame)

  local xs, sm, md = space("xs", 4), space("sm", 8), space("md", 16)
  local ruleH = space("rule", 2)
  local bandH = space("band", 48)
  local sealPx = space("seal", 28)

  local iron = plate(frame, "BACKGROUND", "iron", 0.96)
  iron:SetAllPoints(frame)
  frame.Iron = iron
  local gold = plate(frame, "BORDER", "gold", 1)
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", ruleH, -ruleH)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -ruleH, ruleH)
  frame.GoldEdge = gold

  local titleBand = plate(frame, "ARTWORK", "charcoal", 1)
  titleBand:SetPoint("TOPLEFT", frame, "TOPLEFT", xs, -xs)
  titleBand:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -xs, -xs)
  titleBand:SetHeight(bandH)
  frame.TitleBand = titleBand

  local seal = frame:CreateTexture(nil, "OVERLAY")
  seal:SetWidth(sealPx)
  seal:SetHeight(sealPx)
  seal:SetPoint("LEFT", titleBand, "LEFT", md, 0)
  applyTexture(seal, "seal_papal_small")
  frame.Seal = seal

  local church = label(frame, "GameFontNormalLarge", "display", fontSize("name", 16), "gold")
  church:SetPoint("LEFT", seal, "RIGHT", sm, 0)
  church:SetText(COPY.church)
  frame.ChurchLabel = church

  local close = COB.Theme:CloseButton(frame, function() PlayerCard:Hide() end)
  close:SetPoint("RIGHT", titleBand, "RIGHT", -sm, 0)
  frame.CloseButton = close

  local footerBand = plate(frame, "ARTWORK", "charcoal", 1)
  footerBand:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", xs, xs)
  footerBand:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -xs, xs)
  footerBand:SetHeight(FOOTER_H)
  frame.FooterBand = footerBand

  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", titleBand, "BOTTOMLEFT", 0, 0)
  parchment:SetPoint("BOTTOMRIGHT", footerBand, "TOPRIGHT", 0, 0)
  if applyTexture(parchment, "parchment_decree") then
    if parchment.SetTexCoord then
      pcall(parchment.SetTexCoord, parchment, SURFACE_U0, SURFACE_U1, SURFACE_U0, SURFACE_U1)
    end
  else
    fillRole(parchment, "parchment", 0.94)
  end
  frame.Parchment = parchment

  -- Identity must be a child frame. A charcoal texture on the root
  -- shares ARTWORK with parchment_decree; the file texture won in
  -- Goldshire and the strip read as cream parchment (11:41 pixels).
  -- Week / Gora already sit on HomePane for the same reason.
  local identityBox = CreateFrame("Frame", nil, frame)
  identityBox:SetPoint("TOPLEFT", parchment, "TOPLEFT", md, -md)
  identityBox:SetPoint("TOPRIGHT", parchment, "TOPRIGHT", -md, -md)
  identityBox:SetHeight(84)
  frame.IdentityBox = identityBox
  local identity = plate(identityBox, "ARTWORK", "charcoal", 1)
  if identity.SetAllPoints then identity:SetAllPoints(identityBox) end
  frame.IdentityPlate = identity
  local idRule = plate(identityBox, "OVERLAY", "gold", 1)
  idRule:SetPoint("BOTTOMLEFT", identityBox, "BOTTOMLEFT", 0, 0)
  idRule:SetPoint("BOTTOMRIGHT", identityBox, "BOTTOMRIGHT", 0, 0)
  idRule:SetHeight(ruleH)
  frame.IdentityRule = idRule

  -- Gold rim is four slivers, never a solid 60×60 fill. The 11:41 Goldshire
  -- card showed that slab when SetPortraitTexture left the face blank.
  local rim = 2
  local portraitWell = plate(identityBox, "OVERLAY", "charcoal", 1)
  if portraitWell.SetDrawLayer then pcall(portraitWell.SetDrawLayer, portraitWell, "OVERLAY", 1) end
  portraitWell:SetPoint("LEFT", identityBox, "LEFT", sm + rim, 0)
  portraitWell:SetWidth(PORTRAIT_PX)
  portraitWell:SetHeight(PORTRAIT_PX)
  frame.PortraitWell = portraitWell
  local function rimBar(key, a, relA, ax, ay, b, relB, bx, by, w, h)
    local bar = plate(identityBox, "OVERLAY", "gold", 1)
    if bar.SetDrawLayer then pcall(bar.SetDrawLayer, bar, "OVERLAY", 1) end
    bar:SetPoint(a, portraitWell, relA, ax, ay)
    bar:SetPoint(b, portraitWell, relB, bx, by)
    if w then bar:SetWidth(w) end
    if h then bar:SetHeight(h) end
    frame[key] = bar
    return bar
  end
  rimBar("PortraitRimT", "BOTTOMLEFT", "TOPLEFT", -rim, 0, "BOTTOMRIGHT", "TOPRIGHT", rim, 0, nil, rim)
  rimBar("PortraitRimB", "TOPLEFT", "BOTTOMLEFT", -rim, 0, "TOPRIGHT", "BOTTOMRIGHT", rim, 0, nil, rim)
  rimBar("PortraitRimL", "TOPRIGHT", "TOPLEFT", 0, 0, "BOTTOMRIGHT", "BOTTOMLEFT", 0, 0, rim, nil)
  rimBar("PortraitRimR", "TOPLEFT", "TOPRIGHT", 0, 0, "BOTTOMLEFT", "BOTTOMRIGHT", 0, 0, rim, nil)
  -- Older callers and dumps still name the ring; the top sliver is enough.
  frame.PortraitRing = frame.PortraitRimT
  local portraitSeal = identityBox:CreateTexture(nil, "OVERLAY")
  if portraitSeal.SetDrawLayer then pcall(portraitSeal.SetDrawLayer, portraitSeal, "OVERLAY", 2) end
  portraitSeal:SetPoint("CENTER", portraitWell, "CENTER", 0, 0)
  portraitSeal:SetWidth(PORTRAIT_PX)
  portraitSeal:SetHeight(PORTRAIT_PX)
  applyTexture(portraitSeal, "seal_papal_small")
  frame.PortraitSeal = portraitSeal
  local portrait = identityBox:CreateTexture(nil, "OVERLAY")
  if portrait.SetDrawLayer then pcall(portrait.SetDrawLayer, portrait, "OVERLAY", 3) end
  portrait:SetPoint("CENTER", portraitWell, "CENTER", 0, 0)
  portrait:SetWidth(PORTRAIT_PX)
  portrait:SetHeight(PORTRAIT_PX)
  frame.Portrait = portrait

  local name = label(identityBox, "GameFontNormalLarge", "display", fontSize("name", 18), "parchment")
  name:SetPoint("TOPLEFT", portraitWell, "TOPRIGHT", sm, -2)
  name:SetPoint("RIGHT", identityBox, "CENTER", -md, 0)
  if name.SetMaxLines then name:SetMaxLines(1) end
  frame.NameText = name

  local format = label(identityBox, "GameFontNormalSmall", "label", 12, "parchment")
  format:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
  frame.FormatLine = format

  local record = label(identityBox, "GameFontNormalSmall", "label", 12, "gold", "LEFT")
  record:SetPoint("LEFT", format, "RIGHT", sm, 0)
  record:SetPoint("TOP", format, "TOP", 0, 0)
  frame.RecordText = record

  local knighted = label(identityBox, "GameFontNormalSmall", "label", 12, "silver")
  knighted:SetPoint("TOPLEFT", format, "BOTTOMLEFT", 0, -2)
  knighted:SetPoint("RIGHT", identityBox, "CENTER", -md, 0)
  frame.KnightedText = knighted

  local rank = label(identityBox, "GameFontNormalHuge", "display", fontSize("headline", 22), "gold", "RIGHT")
  rank:SetPoint("TOPRIGHT", identityBox, "TOPRIGHT", -md, -sm)
  rank:SetPoint("LEFT", identityBox, "CENTER", md, 0)
  if rank.SetMaxLines then rank:SetMaxLines(1) end
  frame.RankText = rank
  local rankPlate = identity
  frame.RankPlate = rankPlate

  local honorific = label(identityBox, "GameFontNormalSmall", "label", 12, "parchment", "RIGHT")
  honorific:SetPoint("TOPRIGHT", rank, "BOTTOMRIGHT", 0, -2)
  honorific:SetPoint("LEFT", identityBox, "CENTER", md, 0)
  frame.HonorificText = honorific

  local relationship = label(identityBox, "GameFontNormalSmall", "body", 12, "parchment", "RIGHT")
  relationship:SetPoint("TOPRIGHT", honorific, "BOTTOMRIGHT", 0, -2)
  relationship:SetPoint("LEFT", identityBox, "CENTER", md, 0)
  frame.RelationshipText = relationship

  local guild = label(identityBox, "GameFontNormalSmall", "label", 12, "silver", "LEFT")
  guild:SetPoint("TOPLEFT", knighted, "BOTTOMLEFT", 0, -2)
  guild:SetPoint("RIGHT", identityBox, "CENTER", -md, 0)
  frame.GuildText = guild

  local home = CreateFrame("Frame", nil, frame)
  home:SetPoint("TOPLEFT", identityBox, "BOTTOMLEFT", 0, -sm)
  home:SetPoint("BOTTOMRIGHT", parchment, "BOTTOMRIGHT", -md, HOME_BOTTOM)
  frame.HomePane = home

  local week = insetPanel(home)
  week:SetPoint("TOPLEFT", home, "TOPLEFT", 0, 0)
  week:SetHeight(MID_H)
  frame.WeekPlate = week
  frame.GatheringPlate = week

  local weekHead = label(week, "GameFontNormal", "label", 12, "oxblood")
  weekHead:SetPoint("TOPLEFT", week, "TOPLEFT", sm, -sm)
  weekHead:SetText(COPY.weekLabel)
  frame.WeekLabel = weekHead

  local ribbon = week:CreateTexture(nil, "OVERLAY")
  ribbon:SetWidth(80)
  ribbon:SetHeight(20)
  ribbon:SetPoint("TOPLEFT", weekHead, "BOTTOMLEFT", 0, -xs)
  applyTexture(ribbon, "ribbon_bookmark")
  frame.DecreeRibbon = ribbon

  local gatheringLabel = label(week, "GameFontNormalSmall", "label", 12, "parchment", "CENTER")
  gatheringLabel:SetPoint("TOPLEFT", ribbon, "TOPLEFT", xs, -1)
  gatheringLabel:SetPoint("BOTTOMRIGHT", ribbon, "BOTTOMRIGHT", -xs, 1)
  gatheringLabel:SetText(COPY.decree)
  frame.GatheringLabel = gatheringLabel

  local sigil = week:CreateTexture(nil, "OVERLAY")
  sigil:SetWidth(16)
  sigil:SetHeight(16)
  sigil:SetPoint("LEFT", weekHead, "RIGHT", sm, 0)
  applyTexture(sigil, "sigil_gora_small")
  frame.DecreeSigil = sigil

  local nightList = CreateFrame("Frame", nil, week)
  nightList:SetPoint("TOPLEFT", ribbon, "BOTTOMLEFT", 0, -sm)
  nightList:SetPoint("RIGHT", week, "RIGHT", -sm, 0)
  nightList:SetPoint("BOTTOMLEFT", week, "BOTTOMLEFT", sm, 30)
  nightList:Hide()
  frame.NightList = nightList

  local decree = label(week, "GameFontNormal", "body", 12, "iron")
  decree:SetPoint("TOPLEFT", ribbon, "BOTTOMLEFT", 0, -sm)
  decree:SetPoint("RIGHT", week, "RIGHT", -sm, 0)
  if decree.SetWordWrap then decree:SetWordWrap(true) end
  if decree.SetMaxLines then decree:SetMaxLines(4) end
  frame.DecreeText = decree

  local flavor = label(week, "GameFontNormalSmall", "body", 12, "parchment")
  flavor:SetPoint("TOPLEFT", decree, "BOTTOMLEFT", 0, -xs)
  flavor:SetPoint("RIGHT", week, "RIGHT", -sm, 0)
  if flavor.SetWordWrap then flavor:SetWordWrap(true) end
  if flavor.SetMaxLines then flavor:SetMaxLines(2) end
  flavor:Hide()
  frame.FlavorText = flavor

  local readDecree = footerButton(week, COPY.readDecree, 108, 22)
  readDecree:SetPoint("BOTTOMLEFT", week, "BOTTOMLEFT", sm, sm)
  readDecree:SetScript("OnClick", function() PlayerCard:OpenDecree() end)
  readDecree:Hide()
  frame.ReadDecreeButton = readDecree

  frame.NightGoing = {}
  for i = 1, 4 do
    local going = footerButton(week, COPY.going, 64, 18)
    going:SetScript("OnClick", function(self)
      PlayerCard:TapGoing(self._cobKey)
    end)
    going:Hide()
    frame.NightGoing[i] = going
  end
  frame.GoingButton = frame.NightGoing[1]

  local gora = insetPanel(home)
  gora:SetPoint("TOPRIGHT", home, "TOPRIGHT", 0, 0)
  gora:SetHeight(MID_H)
  frame.GoraPlate = gora
  placeHomeColumns(frame)

  local goraGlyph = gora:CreateTexture(nil, "OVERLAY")
  goraGlyph:SetWidth(14)
  goraGlyph:SetHeight(14)
  goraGlyph:SetPoint("TOPLEFT", gora, "TOPLEFT", sm, -sm)
  applyTexture(goraGlyph, "glyph_record")
  goraGlyph:Hide()
  frame.GoraGlyph = goraGlyph

  local goraHead = label(gora, "GameFontNormal", "label", 12, "oxblood")
  goraHead:SetPoint("TOPLEFT", gora, "TOPLEFT", sm, -sm)
  goraHead:SetText(COPY.goraLabel)
  frame.GoraLabel = goraHead

  local vicHead = label(gora, "GameFontNormalSmall", "label", 12, "iron")
  vicHead:SetPoint("TOPLEFT", goraHead, "BOTTOMLEFT", 0, -xs)
  vicHead:SetText(COPY.victoriesLabel)
  vicHead:Hide()
  frame.VictoriesLabel = vicHead

  frame.VictoryLines = {}
  frame.VictoryRecords = {}
  local prev = goraHead
  for i = 1, MAX_VICTORIES do
    local row = CreateFrame("Frame", nil, gora)
    row:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -xs)
    row:SetPoint("RIGHT", gora, "RIGHT", -sm, 0)
    row:SetHeight(16)
    local line = label(row, "GameFontNormal", "body", 12, "charcoal")
    line:SetPoint("LEFT", row, "LEFT", 0, 0)
    line:SetPoint("RIGHT", row, "RIGHT", -56, 0)
    if line.SetMaxLines then line:SetMaxLines(1) end
    local rec = label(row, "GameFontNormalSmall", "label", 12, "iron", "RIGHT")
    rec:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    rec:SetWidth(52)
    frame.VictoryLines[i] = line
    frame.VictoryRecords[i] = rec
    frame.VictoryLines[i]._cobRow = row
    prev = row
  end
  local goraEmpty = label(gora, "GameFontNormalSmall", "body", 12, "iron")
  goraEmpty:SetPoint("TOPLEFT", goraHead, "BOTTOMLEFT", 0, -xs)
  goraEmpty:SetPoint("RIGHT", gora, "RIGHT", -sm, 0)
  if goraEmpty.SetWordWrap then goraEmpty:SetWordWrap(true) end
  if goraEmpty.SetMaxLines then goraEmpty:SetMaxLines(2) end
  frame.GoraEmptyText = goraEmpty

  local theRecord = footerButton(gora, COPY.theRecord, 108, 22)
  theRecord:SetPoint("BOTTOMRIGHT", gora, "BOTTOMRIGHT", -sm, sm)
  theRecord:SetScript("OnClick", function() PlayerCard:ShowGora() end)
  frame.RecordLedgerButton = theRecord

  local yourLine = label(gora, "GameFontNormalSmall", "label", 12, "oxblood")
  yourLine:SetPoint("LEFT", gora, "LEFT", sm, 0)
  yourLine:SetPoint("RIGHT", theRecord, "LEFT", -sm, 0)
  yourLine:SetPoint("BOTTOM", theRecord, "BOTTOM", 0, 2)
  frame.YourRecordText = yourLine

  local chronicle = insetPanel(home)
  chronicle:SetPoint("TOPLEFT", week, "BOTTOMLEFT", 0, -sm)
  chronicle:SetPoint("TOPRIGHT", gora, "BOTTOMRIGHT", 0, -sm)
  chronicle:SetHeight(CHRONICLE_H)
  frame.ChroniclePlate = chronicle

  local chronHead = label(chronicle, "GameFontNormal", "label", 12, "oxblood")
  chronHead:SetPoint("TOPLEFT", chronicle, "TOPLEFT", sm, -sm)
  chronHead:SetPoint("RIGHT", chronicle, "RIGHT", -108, 0)
  chronHead:SetText(COPY.chronicleLabel)
  frame.ChronicleLabel = chronHead

  frame.ChronicleHeadlines = {}
  frame.ChronicleBodies = {}
  local chronPrev = chronHead
  for i = 1, MAX_CHRONICLE do
    local head = label(chronicle, "GameFontNormal", "label", 12, "oxblood")
    head:SetPoint("TOPLEFT", chronPrev, "BOTTOMLEFT", 0, -xs)
    head:SetPoint("RIGHT", chronicle, "RIGHT", -100, 0)
    local body = label(chronicle, "GameFontNormalSmall", "body", 12, "charcoal")
    body:SetPoint("TOPLEFT", head, "BOTTOMLEFT", 0, -1)
    body:SetPoint("RIGHT", chronicle, "RIGHT", -100, 0)
    frame.ChronicleHeadlines[i] = head
    frame.ChronicleBodies[i] = body
    chronPrev = body
  end
  local chronEmpty = label(chronicle, "GameFontNormalSmall", "body", 12, "iron")
  chronEmpty:SetPoint("TOPLEFT", chronHead, "BOTTOMLEFT", 0, -xs)
  chronEmpty:SetPoint("RIGHT", chronicle, "RIGHT", -100, 0)
  frame.ChronicleEmptyText = chronEmpty

  local readMore = footerButton(chronicle, COPY.readMore, 88, 22)
  readMore:SetPoint("TOPRIGHT", chronicle, "TOPRIGHT", -sm, -sm)
  readMore:SetScript("OnClick", function() PlayerCard:OpenRecords() end)
  frame.ReadMoreButton = readMore

  local ledger = CreateFrame("Frame", nil, frame)
  ledger:SetPoint("TOPLEFT", identityBox, "BOTTOMLEFT", 0, -sm)
  ledger:SetPoint("BOTTOMRIGHT", parchment, "BOTTOMRIGHT", -md, HOME_BOTTOM)
  ledger:Hide()
  frame.GoraLedger = ledger

  local ledgerBox = insetPanel(ledger)
  ledgerBox:SetAllPoints(ledger)
  frame.LedgerBox = ledgerBox
  local ledgerHead = label(ledgerBox, "GameFontNormal", "label", 12, "oxblood")
  ledgerHead:SetPoint("TOPLEFT", ledgerBox, "TOPLEFT", sm, -sm)
  ledgerHead:SetText(COPY.goraLabel)
  frame.LedgerLabel = ledgerHead
  local colFighter = label(ledgerBox, "GameFontNormalSmall", "label", 12, "iron")
  colFighter:SetPoint("TOPLEFT", ledgerHead, "BOTTOMLEFT", LEDGER_COL.name, -sm)
  colFighter:SetText("Fighter")
  local colRecord = label(ledgerBox, "GameFontNormalSmall", "label", 12, "iron")
  colRecord:SetPoint("TOPLEFT", ledgerHead, "BOTTOMLEFT", LEDGER_COL.record, -sm)
  colRecord:SetText("Record")
  local colStreak = label(ledgerBox, "GameFontNormalSmall", "label", 12, "iron")
  colStreak:SetPoint("TOPLEFT", ledgerHead, "BOTTOMLEFT", LEDGER_COL.streak, -sm)
  colStreak:SetText("Streak")
  local colLast = label(ledgerBox, "GameFontNormalSmall", "label", 12, "iron")
  colLast:SetPoint("TOPLEFT", ledgerHead, "BOTTOMLEFT", LEDGER_COL.last, -sm)
  colLast:SetText("Last Gora")
  frame.LedgerCols = { colFighter, colRecord, colStreak, colLast }

  frame.LedgerRows = {}
  local rowPrev = colFighter
  for i = 1, MAX_LEDGER do
    local row = CreateFrame("Frame", nil, ledgerBox)
    row:SetPoint("TOPLEFT", rowPrev, "BOTTOMLEFT", 0, -xs)
    row:SetPoint("RIGHT", ledgerBox, "RIGHT", -(sm + 22), 0)
    row:SetHeight(18)
    -- Rows hang from the Fighter header, so cell x is relative to that
    -- origin — not a second copy of LEDGER_COL.name.
    local origin = LEDGER_COL.name
    row.Name = label(row, "GameFontNormal", "body", 12, "charcoal")
    if row.Name.SetMaxLines then row.Name:SetMaxLines(1) end
    row.Name:SetPoint("LEFT", row, "LEFT", LEDGER_COL.name - origin, 0)
    row.Record = label(row, "GameFontNormal", "body", 12, "charcoal")
    row.Record:SetPoint("LEFT", row, "LEFT", LEDGER_COL.record - origin, 0)
    row.Streak = label(row, "GameFontNormalSmall", "label", 12, "iron")
    row.Streak:SetPoint("LEFT", row, "LEFT", LEDGER_COL.streak - origin, 0)
    row.Last = label(row, "GameFontNormalSmall", "body", 12, "iron")
    row.Last:SetPoint("LEFT", row, "LEFT", LEDGER_COL.last - origin, 0)
    row.Last:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    if row.Last.SetMaxLines then row.Last:SetMaxLines(1) end
    local rule = plate(row, "BACKGROUND", "gold", 0.22)
    rule:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 0)
    rule:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)
    rule:SetHeight(1)
    row.Rule = rule
    frame.LedgerRows[i] = row
    rowPrev = row
  end
  local ledgerEmpty = label(ledgerBox, "GameFontNormalSmall", "body", 12, "iron")
  ledgerEmpty:SetPoint("TOPLEFT", colFighter, "BOTTOMLEFT", 0, -sm)
  frame.LedgerEmptyText = ledgerEmpty

  local scroll
  local ok, widget = pcall(CreateFrame, "ScrollFrame", FRAME_NAME .. "GoraScroll", ledgerBox, "FauxScrollFrameTemplate")
  if ok then
    scroll = widget
  else
    ok, widget = pcall(CreateFrame, "ScrollFrame", FRAME_NAME .. "GoraScroll", ledgerBox, "UIPanelScrollFrameTemplate")
    if ok then
      scroll = widget
    else
      scroll = CreateFrame("ScrollFrame", FRAME_NAME .. "GoraScroll", ledgerBox)
    end
  end
  scroll:SetPoint("TOPRIGHT", ledgerBox, "TOPRIGHT", -2, -(sm + 28))
  scroll:SetPoint("BOTTOMRIGHT", ledgerBox, "BOTTOMRIGHT", -2, sm)
  scroll:SetWidth(26)
  if scroll.SetScript then
    scroll:SetScript("OnVerticalScroll", function(self, offset)
      if type(FauxScrollFrame_OnVerticalScroll) ~= "function" then return end
      FauxScrollFrame_OnVerticalScroll(self, offset, LEDGER_ROW_H, function()
        if PlayerCard.view == "gora" and PlayerCard.frame then
          PlayerCard:Refresh()
        end
      end)
    end)
  end
  frame.LedgerScroll = scroll

  local navChurch = footerButton(frame, COPY.navChurch, 88, 26)
  navChurch:SetPoint("LEFT", footerBand, "LEFT", md, 0)
  navChurch:SetScript("OnClick", function() PlayerCard:ShowHome() end)
  frame.NavChurch = navChurch
  local navGora = footerButton(frame, COPY.navGora, 88, 26)
  navGora:SetPoint("LEFT", navChurch, "RIGHT", sm, 0)
  navGora:SetScript("OnClick", function() PlayerCard:ShowGora() end)
  frame.NavGora = navGora
  local records = footerButton(frame, COPY.records, 88, 26)
  records:SetPoint("LEFT", navGora, "RIGHT", sm, 0)
  records:SetScript("OnClick", function() PlayerCard:OpenRecords() end)
  frame.RecordsButton = records
  local desk = footerButton(frame, COPY.desk, 88, 26)
  desk:SetPoint("RIGHT", footerBand, "RIGHT", -md, 0)
  desk:SetScript("OnClick", function() PlayerCard:OpenDesk() end)
  desk:Hide()
  frame.DeskButton = desk

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetPoint("TOPLEFT", titleBand, "TOPLEFT", 0, 0)
  titleBar:SetPoint("BOTTOMRIGHT", titleBand, "BOTTOMRIGHT", -(56 + md), 0)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)
  frame.TitleBar = titleBar

  -- Retired stacked-story widgets: tests and older callers may still name them.
  frame.GoraRule = frame.GoraPlate and rawget(frame.GoraPlate, "Edge")
  frame.RivalriesRule = nil
  frame.RivalriesLabel = nil
  frame.RivalryLines = {}
  frame.DistinctionsRule = nil
  frame.DistinctionsLabel = nil
  frame.DistinctionsText = nil
  frame.StreakText = record
  frame.DefensesText = record

  placeNail(frame, "NailTL", "TOPLEFT", sm, -sm)
  placeNail(frame, "NailTR", "TOPRIGHT", -sm, -sm)
  placeNail(frame, "NailBL", "BOTTOMLEFT", sm, sm)
  placeNail(frame, "NailBR", "BOTTOMRIGHT", -sm, sm)

  if frame.SetScript then
    frame:SetScript("OnShow", function()
      paintPortrait(frame.Portrait)
    end)
  end

  restorePoint(frame)
  rememberSpecial(FRAME_NAME)
  return frame
end

local function paintHome(frame, s)
  setShown(frame.HomePane, true)
  setShown(frame.GoraLedger, false)
  frame.GatheringLabel:SetText(s.ribbon)
  if COB.NightRows and type(COB.NightRows.DressRibbon) == "function" then
    COB.NightRows.DressRibbon(
      frame.DecreeRibbon,
      frame.GatheringLabel,
      leftoverRibbonRole(s.ribbon),
      s.ribbon,
      "card"
    )
  else
    applyInk(frame.GatheringLabel, "parchment")
  end
  frame.WeekLabel:SetText(COPY.weekLabel)
  local hasNights = type(s.nights) == "table" and #s.nights > 0
  local decreeOnly = (not hasNights) and not s.weekEmpty
  local xs, sm = space("xs", 4), space("sm", 8)
  if decreeOnly and (s.promoted or s.gatheringLive) then
    dressInset(frame.WeekPlate, "charcoal", 1)
    applyInk(frame.WeekLabel, "gold")
    applyFont(frame.DecreeText, "GameFontNormal", "body", 12)
    applyInk(frame.DecreeText, "parchment")
  else
    dressInset(frame.WeekPlate, "parchment", 1)
    applyInk(frame.WeekLabel, "oxblood")
    applyFont(frame.DecreeText, "GameFontNormal", "body", 12)
    applyInk(frame.DecreeText, "iron")
  end
  if hasNights then
    frame.DecreeText:SetText("")
    setShown(frame.DecreeText, false)
    setShown(frame.FlavorText, false)
    frame.FlavorText:SetText("")
    if frame.NightList and COB.NightRows and COB.NightRows.Attach then
      local host = COB.NightRows:Attach(frame.NightList, {
        variant = "card",
        pool = 4,
        onGoing = function(key)
          PlayerCard:TapGoing(key)
        end,
      })
      COB.NightRows:Paint(host, s.nights)
      setShown(frame.NightList, true)
    end
  else
    if frame.NightList then setShown(frame.NightList, false) end
    frame.DecreeText:SetText(s.weekEmpty and COPY.noDecree or s.weekTitle)
    setShown(frame.DecreeText, true)
    if s.weekFlavor ~= "" then
      frame.FlavorText:SetText(s.weekFlavor)
      applyInk(frame.FlavorText, (s.promoted or s.gatheringLive) and "parchment" or "charcoal")
      if frame.FlavorText.SetMaxLines then
        frame.FlavorText:SetMaxLines((s.promoted or s.gatheringLive) and 1 or 2)
      end
      frame.FlavorText:ClearAllPoints()
      frame.FlavorText:SetPoint("TOPLEFT", frame.DecreeText, "BOTTOMLEFT", 0, -xs)
      frame.FlavorText:SetPoint("RIGHT", frame.WeekPlate, "RIGHT", -sm, 0)
      if s.promoted then
        frame.FlavorText:SetPoint("BOTTOM", frame.ReadDecreeButton, "TOP", 0, xs)
      end
      setShown(frame.FlavorText, true)
    else
      frame.FlavorText:SetText("")
      setShown(frame.FlavorText, false)
    end
  end
  setShown(frame.ReadDecreeButton, s.promoted)
  if frame.NightGoing then
    for i = 1, #frame.NightGoing do
      local btn = frame.NightGoing[i]
      btn._cobKey = nil
      setShown(btn, false)
    end
  end
  -- Posted nights wear their own kind ribbons. The column bookmark is only
  -- leftover Decree copy or a live ceremony name.
  local showRibbon
  if hasNights then
    showRibbon = s.gatheringLive == true
  else
    showRibbon = (not s.weekEmpty) or s.gatheringLive
  end
  setShown(frame.DecreeRibbon, showRibbon)
  setShown(frame.GatheringLabel, showRibbon)
  setShown(frame.DecreeSigil, s.promoted and not hasNights)
  frame.DecreeText:ClearAllPoints()
  if showRibbon then
    frame.DecreeText:SetPoint("TOPLEFT", frame.DecreeRibbon, "BOTTOMLEFT", 0, -sm)
  else
    frame.DecreeText:SetPoint("TOPLEFT", frame.WeekLabel, "BOTTOMLEFT", 0, -xs)
  end
  frame.DecreeText:SetPoint("RIGHT", frame.WeekPlate, "RIGHT", -sm, 0)
  if frame.NightList then
    frame.NightList:ClearAllPoints()
    if showRibbon then
      frame.NightList:SetPoint("TOPLEFT", frame.DecreeRibbon, "BOTTOMLEFT", 0, -sm)
    else
      frame.NightList:SetPoint("TOPLEFT", frame.WeekLabel, "BOTTOMLEFT", 0, -xs)
    end
    frame.NightList:SetPoint("RIGHT", frame.WeekPlate, "RIGHT", -sm, 0)
    if s.promoted then
      frame.NightList:SetPoint("BOTTOMLEFT", frame.ReadDecreeButton, "TOPLEFT", 0, xs)
    else
      frame.NightList:SetPoint("BOTTOMLEFT", frame.WeekPlate, "BOTTOMLEFT", sm, sm)
    end
  end

  local hasVictories = #s.victories > 0
  setShown(frame.VictoriesLabel, false)
  setShown(frame.GoraEmptyText, not hasVictories)
  if hasVictories then
    frame.GoraEmptyText:SetText("")
    for i = 1, MAX_VICTORIES do
      local row = s.victories[i]
      if row then
        frame.VictoryLines[i]:SetText(row.name)
        applyInk(frame.VictoryLines[i], row.yours and "oxblood" or "charcoal")
        frame.VictoryRecords[i]:SetText(row.record)
        applyInk(frame.VictoryRecords[i], row.yours and "oxblood" or "iron")
        setShown(frame.VictoryLines[i], true)
        setShown(frame.VictoryRecords[i], true)
        setShown(frame.VictoryLines[i]._cobRow, true)
      else
        frame.VictoryLines[i]:SetText("")
        frame.VictoryRecords[i]:SetText("")
        setShown(frame.VictoryLines[i], false)
        setShown(frame.VictoryRecords[i], false)
        setShown(frame.VictoryLines[i]._cobRow, false)
      end
    end
  else
    frame.GoraEmptyText:SetText(COPY.noGora)
    for i = 1, MAX_VICTORIES do
      frame.VictoryLines[i]:SetText("")
      frame.VictoryRecords[i]:SetText("")
      setShown(frame.VictoryLines[i], false)
      setShown(frame.VictoryRecords[i], false)
      setShown(frame.VictoryLines[i]._cobRow, false)
    end
  end
  if s.yourLine ~= "" then
    frame.YourRecordText:SetText(s.yourLine)
    applyInk(frame.YourRecordText, "oxblood")
    setShown(frame.YourRecordText, true)
  else
    frame.YourRecordText:SetText("")
    setShown(frame.YourRecordText, false)
  end

  local weekLoud = s.promoted or s.gatheringLive
  local goraLoud = hasVictories
  local rowH = (weekLoud or goraLoud) and MID_H or MID_QUIET
  if hasNights and COB.NightRows and COB.NightRows.Metrics then
    local weekW = frame.WeekPlate.GetWidth and frame.WeekPlate:GetWidth() or 260
    local metrics = COB.NightRows.Metrics(weekW, rowH, "card")
    local vis = math.min(metrics.visible, #s.nights)
    local listH = vis * metrics.rowH
    local chrome = sm + 16 + (showRibbon and 26 or 0) + (s.promoted and 30 or sm)
    rowH = math.max(rowH, math.min(240, chrome + listH))
  end
  -- Paired insets share a row. THIS WEEK is the wide primary column;
  -- Gora is the rail. Quiet is chrome and copy, not a shorter box.
  placeHomeColumns(frame)
  frame.WeekPlate:SetHeight(rowH)
  frame.GoraPlate:SetHeight(rowH)
  if hasNights and frame.NightList and COB.NightRows then
    local host = COB.NightRows:Host(frame.NightList)
    if host then COB.NightRows:Paint(host, s.nights) end
  end
  local gap = sm
  frame.ChroniclePlate:ClearAllPoints()
  frame.ChroniclePlate:SetPoint("TOPLEFT", frame.HomePane, "TOPLEFT", 0, -(rowH + gap))
  frame.ChroniclePlate:SetPoint("TOPRIGHT", frame.HomePane, "TOPRIGHT", 0, -(rowH + gap))
  frame.ChroniclePlate:SetHeight(CHRONICLE_H)
  if rowH <= MID_QUIET then
    frame:SetHeight(CARD_H_QUIET)
  else
    frame:SetHeight(CARD_H + math.max(0, rowH - MID_H))
  end

  local hasChronicle = #s.chronicle > 0
  setShown(frame.ChronicleEmptyText, not hasChronicle)
  if hasChronicle then
    frame.ChronicleEmptyText:SetText("")
    for i = 1, MAX_CHRONICLE do
      local row = s.chronicle[i]
      if row then
        frame.ChronicleHeadlines[i]:SetText(row.headline)
        frame.ChronicleBodies[i]:SetText(row.body)
        setShown(frame.ChronicleHeadlines[i], true)
        setShown(frame.ChronicleBodies[i], true)
      else
        frame.ChronicleHeadlines[i]:SetText("")
        frame.ChronicleBodies[i]:SetText("")
        setShown(frame.ChronicleHeadlines[i], false)
        setShown(frame.ChronicleBodies[i], false)
      end
    end
  else
    frame.ChronicleEmptyText:SetText(COPY.chronicleSilent .. "\n" .. COPY.chronicleEmpty)
    for i = 1, MAX_CHRONICLE do
      frame.ChronicleHeadlines[i]:SetText("")
      frame.ChronicleBodies[i]:SetText("")
      setShown(frame.ChronicleHeadlines[i], false)
      setShown(frame.ChronicleBodies[i], false)
    end
  end
  setShown(frame.ReadMoreButton, true)
end

local function paintLedger(frame, s)
  setShown(frame.HomePane, false)
  setShown(frame.GoraLedger, true)
  frame:SetHeight(ledgerHeight(#s.stories))
  local has = #s.stories > 0
  setShown(frame.LedgerEmptyText, not has)
  if not has then
    frame.LedgerEmptyText:SetText(COPY.noGora)
  else
    frame.LedgerEmptyText:SetText("")
  end
  local offset = 0
  if frame.LedgerScroll and type(FauxScrollFrame_GetOffset) == "function" then
    offset = FauxScrollFrame_GetOffset(frame.LedgerScroll) or 0
  end
  if frame.LedgerScroll and type(FauxScrollFrame_Update) == "function" then
    FauxScrollFrame_Update(frame.LedgerScroll, #s.stories, MAX_LEDGER, LEDGER_ROW_H)
  end
  for i = 1, MAX_LEDGER do
    local row = frame.LedgerRows[i]
    local story = s.stories[i + offset]
    if story then
      row.Name:SetText(story.name)
      applyInk(row.Name, story.yours and "oxblood" or "charcoal")
      row.Record:SetText(story.record)
      applyInk(row.Record, "charcoal")
      row.Streak:SetText(story.streak)
      row.Last:SetText(story.last)
      setShown(row, true)
    else
      row.Name:SetText("")
      row.Record:SetText("")
      row.Streak:SetText("")
      row.Last:SetText("")
      setShown(row, false)
    end
  end
end

local function paint(frame, model)
  local s = paintStrings(model)
  paintPortrait(frame.Portrait)
  frame.NameText:SetText(s.name)
  local r, g, b = classColor(model.classFile)
  if type(r) == "number" and frame.NameText.SetTextColor then
    frame.NameText:SetTextColor(r, g, b, 1)
    frame.NameText._cobColorRole = "class"
  else
    applyInk(frame.NameText, "parchment")
  end
  frame.FormatLine:SetText(s.format)
  frame.RankText:SetText(s.rank)
  -- Church titles keep the display face. UNRANKED and a live guild name
  -- that is not a canon title stay gold but do not take the 22px slot —
  -- the 11:41 Goldshire card made the empty plate as loud as Beef Knight.
  if s.rank == COPY.unranked or (s.rank ~= "" and not model.rankTitle) then
    applyFont(frame.RankText, "GameFontNormal", "label", 14)
  elseif s.rank ~= "" then
    applyFont(frame.RankText, "GameFontNormalHuge", "display", fontSize("headline", 22))
  end
  if s.rank ~= "" then applyInk(frame.RankText, "gold") end
  if s.honorific ~= "" then
    frame.HonorificText:SetText("\"" .. s.honorific .. "\"")
    setShown(frame.HonorificText, true)
  else
    frame.HonorificText:SetText("")
    setShown(frame.HonorificText, false)
  end
  frame.RelationshipText:ClearAllPoints()
  local idPlate = frame.IdentityBox or frame.IdentityPlate
  if s.rank == "" then
    local under = (s.knighted ~= "" and frame.KnightedText) or frame.FormatLine
    frame.RelationshipText:SetPoint("TOPLEFT", under, "BOTTOMLEFT", 0, -2)
    frame.RelationshipText:SetPoint("RIGHT", idPlate, "CENTER", -space("md", 16), 0)
    if frame.RelationshipText.SetJustifyH then frame.RelationshipText:SetJustifyH("LEFT") end
  else
    local under = (s.honorific ~= "" and frame.HonorificText) or frame.RankText
    frame.RelationshipText:SetPoint("TOPRIGHT", under, "BOTTOMRIGHT", 0, -2)
    frame.RelationshipText:SetPoint("LEFT", idPlate, "CENTER", space("md", 16), 0)
    if frame.RelationshipText.SetJustifyH then frame.RelationshipText:SetJustifyH("RIGHT") end
  end
  frame.RelationshipText:SetText(s.relationship)
  frame.KnightedText:SetText(s.knighted)
  frame.RecordText:SetText(s.record)
  frame.GuildText:SetText(s.guild or "")
  setShown(frame.GuildText, false)

  if PlayerCard.view == "gora" then
    paintLedger(frame, s)
  else
    paintHome(frame, s)
  end

  if isListedPope() then
    setShown(frame.DeskButton, true)
  else
    setShown(frame.DeskButton, false)
  end
end

--------------------------------------------------------------------------------
-- Public
--------------------------------------------------------------------------------

function PlayerCard:Init()
  if self.frame then
    wireCardOnHide(self.frame)
    rememberSpecial(FRAME_NAME)
    return self.frame
  end
  if type(CreateFrame) ~= "function" then return nil end
  self.frame = buildFrame()
  return self.frame
end

function PlayerCard:GetModel()
  return deepcopy(buildModel())
end

function PlayerCard:IsShown()
  return self.frame ~= nil and self.frame:IsShown() == true
end

function PlayerCard:Refresh()
  if not self.frame then return false end
  paint(self.frame, buildModel())
  return true
end

local function dismissBook()
  local book = COB.RecordsBook
  if type(book) ~= "table" then return end
  if type(book.IsShown) ~= "function" or book:IsShown() ~= true then return end
  if type(book.Dismiss) == "function" then
    pcall(book.Dismiss, book)
  elseif type(book.Hide) == "function" then
    pcall(book.Hide, book)
  end
end

function PlayerCard:Show()
  dismissBook()
  local frame = self:Init()
  if not frame then return false end
  if type(ChurchOfBeefDB) == "table" then
    if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
    if COB.Nights and COB.Nights.BoardRevision then
      ChurchOfBeefDB.ui.nightsSeenRevision = COB.Nights:BoardRevision()
    end
  end
  if COB.Minimap and type(COB.Minimap.RefreshGlow) == "function" then
    pcall(COB.Minimap.RefreshGlow, COB.Minimap)
  end
  self.view = "home"
  wireCardOnHide(frame)
  rememberSpecial(FRAME_NAME)
  kickRoster()
  listenForGuild(frame)
  paint(frame, buildModel())
  yieldFirstSheet()
  frame:Show()
  if frame.Raise then pcall(frame.Raise, frame) end
  stampLayout()
  paintPortrait(frame.Portrait)
  return true
end

function PlayerCard:Hide()
  if self.frame then
    wireCardOnHide(self.frame)
    rememberSpecial(FRAME_NAME)
    self.view = "home"
    self.frame:Hide()
  end
  return true
end

function PlayerCard:Toggle()
  if self:IsShown() then return self:Hide() end
  return self:Show()
end

function PlayerCard:ShowHome()
  self.view = "home"
  if self.frame then paint(self.frame, buildModel()) end
  return true
end

function PlayerCard:ShowGora()
  dismissBook()
  self.view = "gora"
  if not self.frame then self:Init() end
  if self.frame then
    if self.frame.LedgerScroll and type(FauxScrollFrame_SetOffset) == "function" then
      FauxScrollFrame_SetOffset(self.frame.LedgerScroll, 0)
    end
    paint(self.frame, buildModel())
    yieldFirstSheet()
    if not self.frame:IsShown() then self.frame:Show() end
    if self.frame.Raise then pcall(self.frame.Raise, self.frame) end
    stampLayout()
    paintPortrait(self.frame.Portrait)
  end
  return true
end

function PlayerCard:OpenRecords()
  local book = COB.RecordsBook
  if not (type(book) == "table" and type(book.Show) == "function") then return false end
  self:Hide()
  if type(book.ShowFromCard) == "function" then
    return book:ShowFromCard()
  end
  return book:Show()
end

function PlayerCard:TapGoing(occurrenceKey)
  if type(occurrenceKey) ~= "string" or occurrenceKey == "" then
    return false
  end
  if not (COB.Nights and COB.Nights.SetGoing) then
    return false
  end
  local me = localSender()
  if COB.Sender and type(COB.Sender.IsRegisteredPope) == "function"
      and COB.Sender:IsRegisteredPope(me) == true then
    local on = COB.Nights.IsGoing and COB.Nights:IsGoing(occurrenceKey, me)
    local ok = COB.Nights:SetGoing(occurrenceKey, me, on ~= true)
    if ok and COB.Net and type(COB.Net.SendNights) == "function" then
      pcall(COB.Net.SendNights, COB.Net)
    end
    self:Refresh()
    return ok and true or false
  end
  if COB.Net and type(COB.Net.SendGoing) == "function" then
    local ok = COB.Net:SendGoing({ occurrence = occurrenceKey })
    return ok and true or false
  end
  return false
end

function PlayerCard:OpenDecree()
  local banner = COB.DecreeBanner
  if not (type(banner) == "table" and type(banner.Show) == "function") then return false end
  return banner:Show()
end

function PlayerCard:OpenDesk()
  local canDesk = isListedPope()
  if not canDesk and COB.Sender and type(COB.Sender.CanWriteStub) == "function" then
    canDesk = COB.Sender:CanWriteStub(localSender()) == true
  end
  if not canDesk then return false end
  local Console = COB.Console
  if not (type(Console) == "table" and type(Console.Show) == "function") then
    return false
  end
  Console:Show()
  return true
end

function PlayerCard:ResetForTests()
  if not COB._IN_TEST then return false end
  self.view = "home"
  if self.frame then
    if self.frame.LedgerScroll and type(FauxScrollFrame_SetOffset) == "function" then
      FauxScrollFrame_SetOffset(self.frame.LedgerScroll, 0)
    end
    self.frame:Hide()
  end
  return true
end
