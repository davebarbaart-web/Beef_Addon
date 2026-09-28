ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode Fight HUD (Bible §10.7, §19.2 / §19.3). Compact spectator card.
-- Appears at sanction. Congregation pair arrives as Runtime subjects.fighters
-- (STATE); they never Sanction locally. livePair is GetSanctioned(), else
-- subjects.fighters while ASSEMBLY (Pope-sanctioned pair on the wire) or
-- while RITE and riteType Gora (B17-D). Remember it as lastPair. Persist lastPair
-- when both Gora and Runtime fighters are empty and the event is still live
-- (B9-E), except lastPair does not paint during a non-Gora RITE (B19-C)
-- or a non-Gora CONSEQUENCE (B21-B); a refuse forgets lastPair so
-- Knighting Continue stays hidden (B32-A).
-- Hide on QUIET / EndEvent / no last pair. A new live pair replaces
-- the remembered pair. clickPlate pick pair never uses lastPair (B11-B):
-- Pope (IsRegisteredPope local) → GetSanctioned() only; congregation →
-- Runtime subjects.fighters while ASSEMBLY or while RITE and riteType
-- Gora (B16-C). Empty-store names paint from COB._lastCastNames.
-- Isolated suite with a live GetSanctioned still sends even if Sender
-- is nil. No verdict qualifier. Names use Theme:FontPath("label") at
-- Theme.FontSize.name (≥ 16) — glanceable serif, not blackletter.
-- Refresh re-applies on a shown pair (B25-D) and restores class tint
-- after SetFontObject (B34-A). Format line is Level · Title · Class
-- only (the name lives on nameA/nameB). Records, defenses, vs, and
-- favor use Theme label/body.
-- Live health is raid/party unit tokens only (David 2026-09-14):
-- player / raid1–40 / party1–4 via UnitHealth. No nameplate scrape,
-- no combat-log HP, no out-of-group guess. Unbound fighters keep the
-- mute rail. UNIT_HEALTH while shown; roster events rebind. Favor split is
-- Pope-local from Gora (gora pair only), or congregation broadcast
-- only, and only while the pair is still pickable. After a ruling the
-- footer reads Ruled and the split hides until Continue (#110). No
-- winner string unless a winner id is already on Pope STATE subjects
-- (it is not — do not invent one). Hover: Click to pick this side.
-- Footer Pick a side before the first pick.
-- Pope plate click records locally via RecordFavorFromSender(player
-- name) — no store id, no self-whisper. Congregation still SendFavor;
-- a missing local id uses placeholder 1 (apply ignores it).
-- Quiet forgetPersist also nils broadcastFavor (License 2 / §10.6)
-- per-event); it does not nil favorTarget (dest persist, B37-B).
-- Dress is Theme HUD-B: one iron Event-Mode bar. Charcoal identity
-- halves (nameFieldA/B, gold hairline) hold the class-tinted names,
-- Theme.Space.sm stained-glass rails, and the format line. Theme.Space.rule
-- is the gold divide; Theme.Space.footer is the favor register — not a
-- leftover gadget row. The proclamation-center parchment slot stays hidden.
-- Mute class-tinted rails via Theme:Texture("bar_stainedglass_fill"),
-- favor fills via Theme:Texture("bar_favor_fill"), crest via
-- Theme:Texture("sigil_gora") — never a faction crest. Small
-- Theme:Texture("sigil_favor") sits on the favor/pick label. Mute rails are
-- decorative identity when a fighter is not in the local raid/party.
-- A bound fighter's rail hides and a thicker stained-glass StatusBar
-- tracks HP. Damage leaves a muted-gold loss trail that drains, then
-- OnUpdate clears. No sound. No permanent ticker.
-- Defense count is Store:CountDefenses as a
-- mute integer per fighter; hide when 0 or the method is missing.
-- Painted defenses, W/L, and head-to-head are Arabic (0 paints 0).
-- Favor percentages stay Arabic. Defense labels
-- are SetWidth(28) so two-digit W/L plus a count cannot grow into
-- VS / seal (B35-A).
-- No sound. No toasts. Cards stay mute.
local Hud = {
  MODE = "Event",
  COPY = {
    favorHint = "Click to pick this side.",
    pickSide = "Pick a side",
    ruled = "Ruled",
    favor = "FAVOR",
  },
}
COB.Hud = Hud

local FRAME_NAME = "ChurchOfBeefHud"
local WIDTH, HEIGHT = 420, 100
-- Closed-wire INPUT still requires an id. Apply ignores it (Task 6).
local PLACEHOLDER_CHARACTER_ID = 1
-- The name, format, matchup, and favor rows require 92 UI units at the
-- supported 12px typography floor. Compressing below this makes the HUD
-- mathematically responsive but visually unusable on compact screens.
local MIN_HEIGHT = 92
local TOP_INSET = -24
local EN_DASH = "\226\128\147"
local FORMAT_DOT = " \194\183 "

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

local frame = nil
local lastView = nil
local lastPair = nil
local lastPopeFavor = nil
local broadcastFavor = nil
local favorTarget = nil
local localCharacterId = nil
local persistRuled = false
local sawPickable = false
local leftoverAfterContinue = false
local prevRuntimeState = nil
-- Raid/party HP only. Methods are attached after applyBarFill.
-- motion.A/B: live snaps; ghost drains toward live after a hit.
local liveHealth = {
  unitA = nil,
  unitB = nil,
  eventsOn = false,
  ticking = false,
  motion = {
    A = { live = nil, ghost = nil, flash = 0 },
    B = { live = nil, ghost = nil, flash = 0 },
  },
}
local HEALTH_DRAIN = 80
local HEALTH_FLASH = 5

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function hiddenView()
  return {
    shown = false,
    mode = "Event",
    fighterA = nil,
    fighterB = nil,
    headToHead = nil,
    health = nil,
    favor = nil,
    ruled = false,
  }
end

local function uiDb()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then ChurchOfBeefDB.ui = {} end
  return ChurchOfBeefDB.ui
end

local function savePoint(widget)
  local db = uiDb()
  if not db then return end
  local point, _, relativePoint, x, y = widget:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  db.hud = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function restorePoint(widget)
  local db = uiDb()
  local p = db and db.hud
  widget:ClearAllPoints()
  local relative = type(p) == "table" and (p.relativePoint or p.point) or nil
  if type(p) == "table" and ANCHORS[p.point] and ANCHORS[relative]
      and type(p.x) == "number" and type(p.y) == "number" then
    widget:SetPoint(p.point, UIParent, relative, p.x, p.y)
  else
    widget:SetPoint("TOP", UIParent, "TOP", 0, TOP_INSET)
  end
end

local function hudHeight()
  local parent = UIParent
  local h = parent and parent.GetHeight and parent:GetHeight()
  if type(h) == "number" and h > 0 then
    local budget = math.floor(h * 0.12 + 0.5)
    if budget < MIN_HEIGHT then return MIN_HEIGHT end
    if budget < HEIGHT then return budget end
    return HEIGHT
  end
  return HEIGHT
end

local function themeColor(role)
  if not (COB.Theme and COB.Theme.Color) then return nil end
  local r, g, b = COB.Theme:Color(role)
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
    return nil
  end
  return r, g, b
end

local function themeColorTable(role)
  local r, g, b = themeColor(role)
  if r == nil then return nil end
  return { r = r, g = g, b = b }
end

local function themeTexture(name)
  if not (COB.Theme and COB.Theme.Texture) then return nil end
  local path = COB.Theme:Texture(name)
  if type(path) ~= "string" or path == "" then return nil end
  return path
end

local function themeFont(role)
  if not (COB.Theme and COB.Theme.FontPath) then return nil end
  local path = COB.Theme:FontPath(role)
  if type(path) ~= "string" or path == "" then return nil end
  return path
end

local function themeFontSize(key, floor)
  local sizes = COB.Theme and COB.Theme.FontSize
  local n = type(sizes) == "table" and sizes[key] or nil
  if type(n) == "number" then
    if type(floor) == "number" and n < floor then return floor end
    return n
  end
  if type(floor) == "number" then return floor end
  return 12
end

local function space(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
  return fallback
end

local function applyTexture(tex, path)
  if not tex or type(path) ~= "string" or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  if ok then
    tex._cobTexture = path
    return true
  end
  return false
end

local function fill(tex, r, g, b, a)
  if not tex then return end
  a = a or 1
  if tex.SetColorTexture then
    pcall(tex.SetColorTexture, tex, r, g, b, a)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, a)
  end
  tex._cobColor = { r = r, g = g, b = b, a = a }
end

local function applyParchment(tex)
  if not tex then return end
  -- Theme:Texture("frame_proclamation_center") — parchment fill; stock QuestBG.
  if applyTexture(tex, themeTexture("frame_proclamation_center")) then return end
  local r, g, b = themeColor("parchmentMid")
  if r then fill(tex, r, g, b, 0.94) end
end

local function tintSeal(tex)
  if not tex then return end
  local gold = themeColorTable("gold")
  if not applyTexture(tex, themeTexture("sigil_gora")) then
    if gold then fill(tex, gold.r, gold.g, gold.b, 1) end
    return
  end
  if gold and tex.SetVertexColor then
    tex:SetVertexColor(gold.r, gold.g, gold.b, 1)
    tex._cobColor = { r = gold.r, g = gold.g, b = gold.b, a = 1 }
  end
end

local function tintRail(rail, color)
  if not rail then return end
  local ink = themeColorTable("silver")
  if type(color) == "table"
      and type(color.r) == "number"
      and type(color.g) == "number"
      and type(color.b) == "number" then
    ink = color
  end
  applyTexture(rail, themeTexture("bar_stainedglass_fill"))
  if not ink then return end
  if rail.SetVertexColor then
    rail:SetVertexColor(ink.r, ink.g, ink.b, 0.85)
  end
  rail._cobColor = { r = ink.r, g = ink.g, b = ink.b, a = 0.85 }
end

local function tint(fs, color)
  if not fs or type(color) ~= "table" then return end
  local r, g, b = color.r, color.g, color.b
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then return end
  if fs.SetTextColor then fs:SetTextColor(r, g, b) end
  fs._cobColor = { r = r, g = g, b = b }
end

local function classFile(class)
  if type(class) ~= "string" then return nil end
  local file = class:gsub("%s+", ""):upper()
  if file == "" then return nil end
  return file
end

local function classColor(class)
  local file = classFile(class)
  if not file or not (COB.Theme and COB.Theme.ClassColor) then return nil end
  local r, g, b = COB.Theme:ClassColor(file)
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
    return nil
  end
  return { r = r, g = g, b = b }
end

local function churchTitle(characterId)
  if not COB.Store or not COB.Store.RankForCharacter then return nil end
  local rankId = COB.Store:RankForCharacter(characterId)
  if rankId == nil then return nil end
  if not (COB.Ranks and COB.Ranks.Title) then return nil end
  local title = COB.Ranks.Title(rankId)
  if type(title) ~= "string" or title == "" or title == "Unknown" then return nil end
  return title
end

local function eventLive()
  if not COB.Runtime or not COB.Runtime.Snapshot then return false end
  local snap = COB.Runtime:Snapshot()
  return type(snap) == "table" and snap.state ~= "QUIET"
end

local function goraPair()
  if not COB.Gora or not COB.Gora.GetSanctioned then return nil end
  local pair = COB.Gora:GetSanctioned()
  if type(pair) ~= "table" then return nil end
  if pair.fighterA == nil or pair.fighterB == nil then return nil end
  return pair
end

local function runtimePair()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then return nil end
  local subjects = snap.subjects
  if type(subjects) ~= "table" then return nil end
  local fighters = subjects.fighters
  if type(fighters) ~= "table" then return nil end
  local a, b = fighters[1], fighters[2]
  if type(a) ~= "number" or type(b) ~= "number" then return nil end
  return { fighterA = a, fighterB = b }
end

-- Congregation arm: Pope already sanctions in ASSEMBLY. Show that pair
-- from Runtime subjects, not only during a Gora RITE.
local function congregationPair()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then return nil end
  if snap.state == "ASSEMBLY" then
    return runtimePair()
  end
  if snap.state == "RITE" and snap.riteType == "Gora" then
    return runtimePair()
  end
  return nil
end

local function livePair()
  local gora = goraPair()
  if gora then return gora end
  return congregationPair()
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

local function isLocalPope()
  local Sender = COB.Sender
  if not Sender or type(Sender.IsRegisteredPope) ~= "function" then
    return false
  end
  return Sender:IsRegisteredPope(localSender()) == true
end

local function favorPercents(a, b)
  if a + b == 0 then
    return 0, 0
  end
  local pctA = math.floor(100 * a / (a + b))
  return pctA, 100 - pctA
end

local function favorView(split)
  if type(split) ~= "table" then return nil end
  local a, b = split.a, split.b
  if type(a) ~= "number" or type(b) ~= "number" then return nil end
  local pctA, pctB = favorPercents(a, b)
  return { a = a, b = b, pctA = pctA, pctB = pctB }
end

local function resolveFavor()
  if isLocalPope() then
    if goraPair() then
      if not (COB.Gora and COB.Gora.GetFavorSplit) then
        lastPopeFavor = nil
        return nil
      end
      lastPopeFavor = favorView(COB.Gora:GetFavorSplit())
      return lastPopeFavor
    end
    return lastPopeFavor
  end
  return favorView(broadcastFavor)
end

local function rememberPair(pair)
  lastPair = { fighterA = pair.fighterA, fighterB = pair.fighterB }
end

local function forgetPersist()
  lastPair = nil
  lastPopeFavor = nil
  broadcastFavor = nil
  persistRuled = false
  sawPickable = false
  leftoverAfterContinue = false
end

local function displayPair()
  local live = livePair()
  if live then
    rememberPair(live)
    return live
  end
  if lastPair then
    if COB.Runtime and COB.Runtime.Snapshot then
      local snap = COB.Runtime:Snapshot()
      if type(snap) == "table"
          and (snap.state == "RITE" or snap.state == "CONSEQUENCE")
          and snap.riteType ~= "Gora" then
        forgetPersist()
        return nil
      end
    end
    return lastPair
  end
  return nil
end

local function tintBar(bar, color)
  if not bar then return end
  local ink = themeColorTable("silver")
  if type(color) == "table"
      and type(color.r) == "number"
      and type(color.g) == "number"
      and type(color.b) == "number" then
    ink = color
  end
  if not ink then return end
  if bar.SetStatusBarColor then
    bar:SetStatusBarColor(ink.r, ink.g, ink.b)
  end
  bar._cobColor = { r = ink.r, g = ink.g, b = ink.b }
end

local function hideFavorWidgets()
  if not frame then return end
  if frame.favorLabel and frame.favorLabel.Hide then frame.favorLabel:Hide() end
  if frame.favorSigil and frame.favorSigil.Hide then frame.favorSigil:Hide() end
  if frame.barA and frame.barA.Hide then frame.barA:Hide() end
  if frame.barB and frame.barB.Hide then frame.barB:Hide() end
  if frame.pctA then
    frame.pctA:SetText("")
    if frame.pctA.Hide then frame.pctA:Hide() end
  end
  if frame.pctB then
    frame.pctB:SetText("")
    if frame.pctB.Hide then frame.pctB:Hide() end
  end
end

local function paintRuledFooter()
  hideFavorWidgets()
  if not frame or not frame.favorLabel then return end
  frame.favorLabel:SetText(Hud.COPY.ruled)
  tint(frame.favorLabel, themeColorTable("silver"))
  if frame.favorLabel.Show then frame.favorLabel:Show() end
end

local function paintFavor(favor, fighterA, fighterB)
  if not frame then return end
  if persistRuled then
    paintRuledFooter()
    return
  end
  if not favor then
    hideFavorWidgets()
    return
  end
  local label = Hud.COPY.favor
  if favor.a + favor.b == 0 then
    label = Hud.COPY.pickSide
  end
  frame.favorLabel:SetText(label)
  tint(frame.favorLabel, themeColorTable("silver"))
  -- Percents carry live information: parchment on iron (10.4:1), not silver (5.1:1).
  tint(frame.pctA, themeColorTable("parchment"))
  tint(frame.pctB, themeColorTable("parchment"))
  if frame.favorLabel.Show then frame.favorLabel:Show() end
  if frame.favorSigil and frame.favorSigil.Show then frame.favorSigil:Show() end
  frame.pctA:SetText(tostring(favor.pctA) .. "%")
  frame.pctB:SetText(tostring(favor.pctB) .. "%")
  if frame.pctA.Show then frame.pctA:Show() end
  if frame.pctB.Show then frame.pctB:Show() end
  if frame.barA.SetMinMaxValues then frame.barA:SetMinMaxValues(0, 100) end
  if frame.barB.SetMinMaxValues then frame.barB:SetMinMaxValues(0, 100) end
  if frame.barA.SetValue then frame.barA:SetValue(favor.pctA) end
  if frame.barB.SetValue then frame.barB:SetValue(favor.pctB) end
  tintBar(frame.barA, fighterA and fighterA.nameColor)
  tintBar(frame.barB, fighterB and fighterB.nameColor)
  if frame.barA.Show then frame.barA:Show() end
  if frame.barB.Show then frame.barB:Show() end
end

-- Display persist may use lastPair. Favor picks close when the live
-- pair is gone. Isolated suite: a live GetSanctioned still sends
-- even if Sender is nil (existing Sanctioned plate-click pins).
-- Congregation leftovers send during ASSEMBLY sanction or a Gora RITE
-- (B16-C). A blank favorTarget is not a refusal: Net resolves the
-- default whisper destination (Lane W). SetFavorTarget stays an override.
local function pickPair()
  local gora = goraPair()
  if gora then return gora end
  if isLocalPope() then return nil end
  return congregationPair()
end

local function runtimeState()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then return nil end
  return snap.state
end

-- #110: lastPair persist after a pickable fight reads as ruled until
-- Continue (CONSEQUENCE → ASSEMBLY). STATE subjects have no winner id
-- without a beat field — hide favor; do not invent a winner string.
local function updateRuledFlags(showing)
  local state = runtimeState()
  local canPick = pickPair() ~= nil
  if canPick then
    sawPickable = true
    leftoverAfterContinue = false
    persistRuled = false
  elseif showing then
    if prevRuntimeState == "CONSEQUENCE" and state == "ASSEMBLY" then
      leftoverAfterContinue = true
      persistRuled = false
    elseif sawPickable and not leftoverAfterContinue then
      persistRuled = true
    end
  end
  prevRuntimeState = state
end

local function clickPlate(side)
  local pair = pickPair()
  if not pair then return end
  local pickId = (side == "A") and pair.fighterA or pair.fighterB
  if isLocalPope() then
    local sender = localSender()
    if type(sender) ~= "string" or sender == "" then return end
    if not (COB.Gora and type(COB.Gora.RecordFavorFromSender) == "function") then
      return
    end
    local ok = COB.Gora:RecordFavorFromSender(sender, pickId)
    if ok then
      Hud:Refresh()
    end
    return
  end
  local characterId = localCharacterId
  if type(characterId) ~= "number" then
    characterId = PLACEHOLDER_CHARACTER_ID
  end
  Hud:PickFavor(pickId, favorTarget, characterId)
end

local function headToHeadFor(character, opponentId)
  if type(character) ~= "table" or type(character.gora) ~= "table" then return nil end
  local list = character.gora.headToHeads
  if type(list) ~= "table" then return nil end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and row.opponentId == opponentId then
      local fights = row.fights
      if type(fights) == "number" and fights > 0 then
        return {
          wins = row.wins or 0,
          losses = row.losses or 0,
          fights = fights,
        }
      end
    end
  end
  return nil
end

local function stashedName(id)
  local stash = COB._lastCastNames
  if type(stash) ~= "table" then return nil end
  if type(stash.byId) == "table" and type(stash.byId[id]) == "string" then
    return stash.byId[id]
  end
  if type(stash.fighterA) == "string" or type(stash.fighterB) == "string"
      or type(stash.candidate) == "string" then
    if not COB.Runtime or not COB.Runtime.Snapshot then
      return nil
    end
    local snap = COB.Runtime:Snapshot()
    local subjects = type(snap) == "table" and snap.subjects or nil
    if type(subjects) ~= "table" then return nil end
    if subjects.candidate == id and type(stash.candidate) == "string" then
      return stash.candidate
    end
    if type(subjects.fighters) == "table" then
      if subjects.fighters[1] == id and type(stash.fighterA) == "string" then
        return stash.fighterA
      end
      if subjects.fighters[2] == id and type(stash.fighterB) == "string" then
        return stash.fighterB
      end
    end
  end
  return nil
end

local function defenseCount(characterId)
  if not (COB.Store and type(COB.Store.CountDefenses) == "function") then
    return nil
  end
  local n = COB.Store:CountDefenses(characterId)
  if type(n) ~= "number" then return nil end
  local whole = math.floor(n)
  if whole <= 0 then return nil end
  return whole
end

local function fighterFrom(id)
  local ch = COB.Store and COB.Store.GetCharacter and COB.Store:GetCharacter(id) or nil
  if type(ch) ~= "table" then
    return {
      id = id,
      name = stashedName(id) or "",
      level = nil,
      title = nil,
      wins = 0,
      losses = 0,
      nameColor = nil,
      defenses = defenseCount(id),
    }
  end
  local gora = type(ch.gora) == "table" and ch.gora or {}
  return {
    id = id,
    name = ch.name,
    class = ch.class,
    level = ch.level,
    title = churchTitle(id),
    wins = gora.wins or 0,
    losses = gora.losses or 0,
    nameColor = classColor(ch.class),
    defenses = defenseCount(id),
  }
end

local function arabicCount(n)
  local whole = 0
  if type(n) == "number" then whole = math.floor(n) end
  if whole < 0 then whole = 0 end
  return tostring(whole)
end

local function recordText(fighter)
  return arabicCount(fighter.wins or 0) .. EN_DASH .. arabicCount(fighter.losses or 0)
end

local function formatLine(fighter)
  local parts = {}
  if type(fighter.level) == "number" then
    parts[#parts + 1] = tostring(fighter.level)
  end
  if type(fighter.title) == "string" and fighter.title ~= "" then
    parts[#parts + 1] = fighter.title
  end
  if type(fighter.class) == "string" and fighter.class ~= "" then
    parts[#parts + 1] = fighter.class
  end
  if #parts == 0 then return "" end
  return table.concat(parts, FORMAT_DOT)
end

local function levelText(fighter)
  if type(fighter.level) ~= "number" then return "" end
  return tostring(fighter.level)
end

local function defenseText(n)
  if type(n) ~= "number" or n <= 0 then return "" end
  return arabicCount(n)
end

local function paintDefense(side, n)
  local fs = frame["defense" .. side]
  if not fs then return end
  fs:SetWidth(28)
  tint(fs, themeColorTable("silver"))
  if type(n) == "number" and n > 0 then
    fs:SetText(defenseText(n))
    if fs.Show then fs:Show() end
  else
    fs:SetText("")
    if fs.Hide then fs:Hide() end
  end
end

local function paintFighter(side, fighter)
  local nameFS = frame["name" .. side]
  local levelFS = frame["level" .. side]
  local titleFS = frame["title" .. side]
  local recordFS = frame["record" .. side]
  nameFS:SetText(fighter.name or "")
  levelFS:SetText(levelText(fighter))
  titleFS:SetText(formatLine(fighter))
  recordFS:SetText(recordText(fighter))
  tint(nameFS, fighter.nameColor or themeColorTable("parchment"))
  tint(levelFS, themeColorTable("silver"))
  tint(titleFS, themeColorTable("parchment"))
  tint(recordFS, themeColorTable("silver"))
  paintDefense(side, fighter.defenses)
  tintRail(frame["rail" .. side], fighter.nameColor)
end

local function paintHidden()
  lastView = hiddenView()
  if not frame then return lastView end
  frame.nameA:SetText("")
  frame.nameB:SetText("")
  frame.levelA:SetText("")
  frame.levelB:SetText("")
  frame.titleA:SetText("")
  frame.titleB:SetText("")
  frame.recordA:SetText("")
  frame.recordB:SetText("")
  paintDefense("A", nil)
  paintDefense("B", nil)
  if frame.headToHead.Hide then frame.headToHead:Hide() end
  hideFavorWidgets()
  if liveHealth.clear then liveHealth.clear() end
  frame:Hide()
  return lastView
end

local function applyFont(fs, role, sizeKey, minSize)
  if not fs then return end
  local path = themeFont(role)
  local size = themeFontSize(sizeKey, minSize)
  local used = false
  if type(path) == "string" and fs.SetFont then
    local ok = pcall(fs.SetFont, fs, path, size)
    used = ok and true or false
    if used then
      fs._cobFont = path
      fs._cobFontSize = size
    end
  end
  if not used and fs.SetFontObject then
    local font = GameFontHighlight
    if type(font) == "string" then font = _G[font] end
    if font then pcall(fs.SetFontObject, fs, font) end
  end
end

local function applyNameFont(fs)
  applyFont(fs, "label", "name", 16)
end

local function applyLabelFont(fs, sizeKey)
  local key = sizeKey or "label"
  -- Theme.FontSize.caption is the 12px stream floor (10px failed in-client).
  local floor = (key == "caption") and 12 or nil
  applyFont(fs, "label", key, floor)
end

local function paintShown(pair)
  local fighterA = fighterFrom(pair.fighterA)
  local fighterB = fighterFrom(pair.fighterB)
  local h2h = nil
  if COB.Store and COB.Store.GetCharacter then
    local chA = COB.Store:GetCharacter(pair.fighterA)
    h2h = headToHeadFor(chA, pair.fighterB)
  end

  paintFighter("A", fighterA)
  paintFighter("B", fighterB)
  if h2h then
    frame.headToHead:SetText(recordText(h2h))
    tint(frame.headToHead, themeColorTable("silver"))
    if frame.headToHead.Show then frame.headToHead:Show() end
  else
    frame.headToHead:SetText("")
    if frame.headToHead.Hide then frame.headToHead:Hide() end
  end

  local favor = resolveFavor()
  if persistRuled or not pickPair() then
    favor = nil
  end
  paintFavor(favor, fighterA, fighterB)
  local health = nil
  if liveHealth.sync then
    health = liveHealth.sync(fighterA, fighterB)
  end

  lastView = {
    shown = true,
    mode = "Event",
    fighterA = fighterA,
    fighterB = fighterB,
    headToHead = h2h,
    health = health,
    favor = favor,
    ruled = persistRuled == true,
  }
  applyNameFont(frame.nameA)
  applyNameFont(frame.nameB)
  tint(frame.nameA, fighterA.nameColor or themeColorTable("parchment"))
  tint(frame.nameB, fighterB.nameColor or themeColorTable("parchment"))
  -- Class-tinted names sit on charcoal identity halves. The QuestBG
  -- parchment slot is an art drop target and must stay hidden.
  if frame.parchment and frame.parchment.Hide then frame.parchment:Hide() end
  frame:Show()
  return lastView
end

local function makeLabel(parent, name, template, justify)
  local fs = parent:CreateFontString(name, "OVERLAY", template or "GameFontNormal")
  if fs.SetJustifyH and justify then fs:SetJustifyH(justify) end
  return fs
end

local function applyBarFill(bar, semantic)
  local path = themeTexture(semantic)
  if not bar or type(path) ~= "string" then return end
  if bar.SetStatusBarTexture then
    pcall(bar.SetStatusBarTexture, bar, path)
  end
  bar._cobTexture = path
end

local function namesSame(a, b)
  return COB.Names and COB.Names.Same and COB.Names.Same(a, b)
end

local function unitName(unit)
  if type(UnitName) ~= "function" then return nil end
  local ok, name = pcall(UnitName, unit)
  if not ok or type(name) ~= "string" or name == "" then return nil end
  return name
end

local function countedGroup(fn, cap)
  if type(fn) ~= "function" then return 0 end
  local ok, raw = pcall(fn)
  local n = ok and tonumber(raw) or 0
  if n < 1 then return 0 end
  if n > cap then n = cap end
  return n
end

-- Same token walk as Markers.resolveUnit, plus TBC GetNumRaidMembers /
-- GetNumPartyMembers. A count above a 5-man party is a raid even when
-- IsInRaid is missing from the catalog.
local function groupSizeAndPrefix()
  local raidN = countedGroup(GetNumRaidMembers, 40)
  if raidN > 0 then return raidN, "raid" end
  local n = countedGroup(GetNumGroupMembers, 40)
  if n > 0 then
    local inRaid = false
    if type(IsInRaid) == "function" then
      local rok, raid = pcall(IsInRaid)
      inRaid = rok and raid and true or false
    end
    if inRaid or n > 5 then
      return n, "raid"
    end
    if n > 4 then n = 4 end
    return n, "party"
  end
  local partyN = countedGroup(GetNumPartyMembers, 4)
  if partyN > 0 then return partyN, "party" end
  return 0, nil
end

local function groupUnitFor(name)
  if type(name) ~= "string" or name == "" then return nil end
  if namesSame(unitName("player"), name) then
    return "player"
  end
  local size, prefix = groupSizeAndPrefix()
  if size < 1 or type(prefix) ~= "string" then return nil end
  for i = 1, size do
    local unit = prefix .. i
    if namesSame(unitName(unit), name) then
      return unit
    end
  end
  return nil
end

local function readGroupVitals(unit)
  if type(unit) ~= "string" or unit == "" then return nil end
  if type(UnitExists) == "function" then
    local ok, exists = pcall(UnitExists, unit)
    if ok and exists == false then return nil end
  end
  if type(UnitHealth) ~= "function" or type(UnitHealthMax) ~= "function" then
    return nil
  end
  local cur = UnitHealth(unit)
  local max = UnitHealthMax(unit)
  if type(cur) ~= "number" or type(max) ~= "number" or max <= 0 then
    return nil
  end
  if cur < 0 then cur = 0 end
  if cur > max then cur = max end
  return {
    cur = cur,
    max = max,
    pct = math.floor((100 * cur / max) + 0.5),
  }
end

local function setHealthEvents(on)
  if not frame or type(frame.RegisterEvent) ~= "function" then return end
  if liveHealth.eventsOn == on then return end
  liveHealth.eventsOn = on
  local ev = on and frame.RegisterEvent or frame.UnregisterEvent
  if type(ev) ~= "function" then return end
  pcall(ev, frame, "UNIT_HEALTH")
  pcall(ev, frame, "UNIT_MAXHEALTH")
  pcall(ev, frame, "RAID_ROSTER_UPDATE")
  pcall(ev, frame, "GROUP_ROSTER_UPDATE")
end

local function stopHealthTick()
  liveHealth.ticking = false
  if frame and frame.SetScript then
    frame:SetScript("OnUpdate", nil)
  end
end

local function resetMotionSide(side)
  local slot = liveHealth.motion[side]
  if slot then
    slot.live = nil
    slot.ghost = nil
    slot.flash = 0
  end
  if not frame then return end
  local ghost = frame["healthGhost" .. side]
  local bar = frame["health" .. side]
  if ghost and ghost.Hide then ghost:Hide() end
  if bar and bar.SetAlpha then bar:SetAlpha(1) end
end

local function hideHealthSide(side)
  if not frame then return end
  resetMotionSide(side)
  local bar = frame["health" .. side]
  local rail = frame["rail" .. side]
  if bar and bar.Hide then bar:Hide() end
  if rail and rail.Show then rail:Show() end
end

local function motionBusy(slot)
  if not slot or slot.live == nil then return false end
  if slot.flash > 0 then return true end
  return type(slot.ghost) == "number" and slot.ghost > slot.live + 0.4
end

local function tickSide(side, elapsed)
  local slot = liveHealth.motion[side]
  if not motionBusy(slot) then return false end
  local ghostBar = frame and frame["healthGhost" .. side]
  local bar = frame and frame["health" .. side]
  if slot.ghost > slot.live then
    slot.ghost = slot.ghost - HEALTH_DRAIN * elapsed
    if slot.ghost < slot.live then slot.ghost = slot.live end
    if ghostBar then
      if ghostBar.SetValue then ghostBar:SetValue(slot.ghost) end
      if ghostBar.Show then ghostBar:Show() end
    end
  end
  if slot.ghost <= slot.live + 0.4 then
    slot.ghost = slot.live
    if ghostBar and ghostBar.Hide then ghostBar:Hide() end
  end
  if slot.flash > 0 then
    slot.flash = slot.flash - HEALTH_FLASH * elapsed
    if slot.flash < 0 then slot.flash = 0 end
    if bar and bar.SetAlpha then
      bar:SetAlpha(1 - 0.35 * slot.flash)
    end
  elseif bar and bar.SetAlpha then
    bar:SetAlpha(1)
  end
  return motionBusy(slot)
end

function liveHealth.tick(_, elapsed)
  elapsed = tonumber(elapsed) or 0
  if elapsed < 0 then elapsed = 0 end
  local busyA = tickSide("A", elapsed)
  local busyB = tickSide("B", elapsed)
  if not busyA and not busyB then stopHealthTick() end
end

local function startHealthTick()
  if liveHealth.ticking or not frame or type(frame.SetScript) ~= "function" then
    return
  end
  liveHealth.ticking = true
  frame:SetScript("OnUpdate", liveHealth.tick)
end

local function paintHealthSide(side, pct, color)
  if not frame then return end
  local bar = frame["health" .. side]
  local ghost = frame["healthGhost" .. side]
  local rail = frame["rail" .. side]
  local slot = liveHealth.motion[side]
  if type(pct) ~= "number" or not bar then
    hideHealthSide(side)
    if not motionBusy(liveHealth.motion.A) and not motionBusy(liveHealth.motion.B) then
      stopHealthTick()
    end
    return
  end
  if bar.SetMinMaxValues then bar:SetMinMaxValues(0, 100) end
  if bar.SetValue then bar:SetValue(pct) end
  tintBar(bar, color)
  if ghost then
    if ghost.SetMinMaxValues then ghost:SetMinMaxValues(0, 100) end
    tintBar(ghost, themeColorTable("gold"))
    if ghost.SetAlpha then ghost:SetAlpha(0.55) end
  end
  local prev = slot and slot.live
  if slot then
    if prev == nil then
      slot.live = pct
      slot.ghost = pct
      slot.flash = 0
      if ghost and ghost.Hide then ghost:Hide() end
    elseif pct < prev then
      slot.live = pct
      if slot.ghost == nil or slot.ghost < prev then slot.ghost = prev end
      slot.flash = 1
      if bar.SetAlpha then bar:SetAlpha(0.65) end
      if ghost then
        if ghost.SetValue then ghost:SetValue(slot.ghost) end
        if ghost.Show then ghost:Show() end
      end
    else
      slot.live = pct
      if slot.ghost == nil or slot.ghost < pct then slot.ghost = pct end
      if ghost and slot.ghost <= pct + 0.4 and ghost.Hide then ghost:Hide() end
    end
  end
  if rail and rail.Hide then rail:Hide() end
  if bar.Show then bar:Show() end
  if motionBusy(liveHealth.motion.A) or motionBusy(liveHealth.motion.B) then
    startHealthTick()
  end
end

function liveHealth.clear()
  liveHealth.unitA = nil
  liveHealth.unitB = nil
  hideHealthSide("A")
  hideHealthSide("B")
  stopHealthTick()
  setHealthEvents(false)
end

function liveHealth.paint(colorA, colorB)
  if not frame then return nil end
  if colorA == nil and lastView and lastView.fighterA then
    colorA = lastView.fighterA.nameColor
  end
  if colorB == nil and lastView and lastView.fighterB then
    colorB = lastView.fighterB.nameColor
  end
  local vitA = readGroupVitals(liveHealth.unitA)
  local vitB = readGroupVitals(liveHealth.unitB)
  local pctA = vitA and vitA.pct or nil
  local pctB = vitB and vitB.pct or nil
  paintHealthSide("A", pctA, colorA)
  paintHealthSide("B", pctB, colorB)
  if vitA and vitB
      and COB.Gora
      and type(COB.Gora.ConsiderRaidHealth) == "function" then
    COB.Gora:ConsiderRaidHealth(vitA.cur, vitB.cur)
  end
  if pctA == nil and pctB == nil then
    return nil
  end
  return { a = pctA, b = pctB }
end

function liveHealth.sync(fighterA, fighterB)
  liveHealth.unitA = groupUnitFor(fighterA and fighterA.name)
  liveHealth.unitB = groupUnitFor(fighterB and fighterB.name)
  setHealthEvents(true)
  return liveHealth.paint(
    fighterA and fighterA.nameColor,
    fighterB and fighterB.nameColor
  )
end

function liveHealth.onEvent(event, unit)
  if event == "DISPLAY_SIZE_CHANGED" or event == "UI_SCALE_CHANGED" then
    if frame then
      frame:SetHeight(hudHeight())
      restorePoint(frame)
    end
    return
  end
  if not frame or not frame:IsShown() then return end
  if event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
    if unit == nil and type(arg1) == "string" then unit = arg1 end
    if unit ~= liveHealth.unitA and unit ~= liveHealth.unitB then
      return
    end
    local health = liveHealth.paint()
    if lastView and lastView.shown then
      lastView.health = health
    end
    return
  end
  if event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED"
      or event == "GROUP_ROSTER_UPDATE" then
    if lastView and lastView.shown then
      lastView.health = liveHealth.sync(lastView.fighterA, lastView.fighterB)
    end
  end
end

local function build()
  local parent = UIParent
  local widget = CreateFrame("Frame", FRAME_NAME, parent, "BackdropTemplate")
  local height = hudHeight()
  widget:SetSize(WIDTH, height)
  widget:SetMovable(true)
  widget:SetClampedToScreen(true)
  if widget.EnableMouse then widget:EnableMouse(true) end
  if widget.RegisterForDrag then widget:RegisterForDrag("LeftButton") end
  if widget.SetFrameStrata then widget:SetFrameStrata("HIGH") end
  local sm = space("sm", 8)
  local xs = space("xs", 4)
  local md = space("md", 16)
  local rule = space("rule", 2)
  -- A 12%-of-screen HUD is 92px tall at 1024x768. Reserve roughly the
  -- bottom third for favor so the name, format, and record rows retain a
  -- real 60px identity band instead of stacking on one another.
  local footerH = math.min(space("footer", 40), math.floor(height * 0.31))
  local sealSlot = space("seal", 28)
  local glyph = space("glyph", 14)
  if footerH + rule >= height then
    footerH = math.floor(height / 3)
  end
  local identityH = height - footerH - rule
  local notch = math.floor(sealSlot / 2)

  widget.iron = widget:CreateTexture(nil, "BACKGROUND")
  if widget.iron.SetAllPoints then widget.iron:SetAllPoints(widget) end
  do
    local r, g, b = themeColor("iron")
    if r then fill(widget.iron, r, g, b, 0.94) end
  end

  widget.parchment = widget:CreateTexture(nil, "BACKGROUND")
  if widget.parchment.ClearAllPoints then widget.parchment:ClearAllPoints() end
  widget.parchment:SetPoint("TOPLEFT", widget, "TOPLEFT", sm, -sm)
  widget.parchment:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -sm, sm)
  applyParchment(widget.parchment)
  if widget.parchment.Hide then widget.parchment:Hide() end

  -- Identity band: two charcoal halves, one gold-rimmed register.
  -- The seal notch is Theme.Space.seal, not a leftover card gap.
  widget.nameFieldEdgeA = widget:CreateTexture(nil, "BORDER")
  widget.nameFieldEdgeB = widget:CreateTexture(nil, "BORDER")
  widget.nameFieldA = widget:CreateTexture(nil, "BORDER")
  widget.nameFieldB = widget:CreateTexture(nil, "BORDER")
  do
    local r, g, b = themeColor("gold")
    if r then
      fill(widget.nameFieldEdgeA, r, g, b, 1)
      fill(widget.nameFieldEdgeB, r, g, b, 1)
    end
  end
  do
    local r, g, b = themeColor("charcoal")
    if r then
      fill(widget.nameFieldA, r, g, b, 1)
      fill(widget.nameFieldB, r, g, b, 1)
    end
  end
  widget.nameFieldEdgeA:SetPoint("TOPLEFT", widget, "TOPLEFT", 0, 0)
  widget.nameFieldEdgeA:SetPoint("BOTTOMLEFT", widget, "TOPLEFT", 0, -identityH)
  widget.nameFieldEdgeA:SetPoint("RIGHT", widget, "CENTER", -notch, 0)
  widget.nameFieldEdgeB:SetPoint("TOPRIGHT", widget, "TOPRIGHT", 0, 0)
  widget.nameFieldEdgeB:SetPoint("BOTTOMRIGHT", widget, "TOPRIGHT", 0, -identityH)
  widget.nameFieldEdgeB:SetPoint("LEFT", widget, "CENTER", notch, 0)
  widget.nameFieldA:SetPoint("TOPLEFT", widget.nameFieldEdgeA, "TOPLEFT", 1, -1)
  widget.nameFieldA:SetPoint("BOTTOMRIGHT", widget.nameFieldEdgeA, "BOTTOMRIGHT", -1, 1)
  widget.nameFieldB:SetPoint("TOPLEFT", widget.nameFieldEdgeB, "TOPLEFT", 1, -1)
  widget.nameFieldB:SetPoint("BOTTOMRIGHT", widget.nameFieldEdgeB, "BOTTOMRIGHT", -1, 1)

  widget.goldRule = widget:CreateTexture(nil, "ARTWORK")
  widget.goldRule:SetPoint("TOPLEFT", widget, "TOPLEFT", 0, -identityH)
  widget.goldRule:SetPoint("TOPRIGHT", widget, "TOPRIGHT", 0, -identityH)
  if widget.goldRule.SetHeight then widget.goldRule:SetHeight(rule) end
  do
    local r, g, b = themeColor("gold")
    if r then fill(widget.goldRule, r, g, b, 0.90) end
  end

  widget.footerField = widget:CreateTexture(nil, "BACKGROUND")
  do
    -- Favor register is the iron bar; percents sit parchment-on-iron.
    local r, g, b = themeColor("iron")
    if r then fill(widget.footerField, r, g, b, 1) end
  end
  widget.footerField:SetPoint("TOPLEFT", widget, "TOPLEFT", 0, -(identityH + rule))
  widget.footerField:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", 0, 0)

  widget.seal = widget:CreateTexture(nil, "ARTWORK")
  widget.seal:SetSize(sealSlot, sealSlot)
  widget.seal:SetPoint("TOP", widget, "TOP", 0, -xs)
  tintSeal(widget.seal)

  widget.nameA = makeLabel(widget, nil, "GameFontHighlight", "LEFT")
  widget.nameB = makeLabel(widget, nil, "GameFontHighlight", "RIGHT")
  applyNameFont(widget.nameA)
  applyNameFont(widget.nameB)
  widget.titleA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.titleB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.levelA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.levelB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.recordA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.recordB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.defenseA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.defenseB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  widget.vs = makeLabel(widget, nil, "GameFontNormal", "CENTER")
  widget.headToHead = makeLabel(widget, nil, "GameFontNormal", "CENTER")
  widget.favorLabel = makeLabel(widget, nil, "GameFontHighlightSmall", "CENTER")
  widget.pctA = makeLabel(widget, nil, "GameFontNormal", "LEFT")
  widget.pctB = makeLabel(widget, nil, "GameFontNormal", "RIGHT")
  applyLabelFont(widget.titleA, "label")
  applyLabelFont(widget.titleB, "label")
  if widget.titleA.SetWordWrap then widget.titleA:SetWordWrap(false) end
  if widget.titleB.SetWordWrap then widget.titleB:SetWordWrap(false) end
  if widget.titleA.SetNonSpaceWrap then widget.titleA:SetNonSpaceWrap(false) end
  if widget.titleB.SetNonSpaceWrap then widget.titleB:SetNonSpaceWrap(false) end
  do
    local formatH = themeFontSize("label", 12)
    if widget.titleA.SetHeight then widget.titleA:SetHeight(formatH) end
    if widget.titleB.SetHeight then widget.titleB:SetHeight(formatH) end
  end
  applyLabelFont(widget.levelA, "caption")
  applyLabelFont(widget.levelB, "caption")
  applyLabelFont(widget.recordA, "label")
  applyLabelFont(widget.recordB, "label")
  applyLabelFont(widget.defenseA, "caption")
  applyLabelFont(widget.defenseB, "caption")
  do
    -- Fixed-height ledger rows keep font metric differences between clients
    -- from pushing the record baseline through the identity/favor divider.
    local recordH = themeFontSize("label", 12)
    local defenseH = themeFontSize("caption", 12)
    if widget.recordA.SetHeight then widget.recordA:SetHeight(recordH) end
    if widget.recordB.SetHeight then widget.recordB:SetHeight(recordH) end
    if widget.defenseA.SetHeight then widget.defenseA:SetHeight(defenseH) end
    if widget.defenseB.SetHeight then widget.defenseB:SetHeight(defenseH) end
  end
  applyLabelFont(widget.vs, "caption")
  applyLabelFont(widget.headToHead, "caption")
  do
    -- Give the compact center stack concrete boxes. FontStrings without an
    -- explicit height can report a zero-height anchor on older clients and
    -- drop the matchup record into the favor register.
    local centerLineH = themeFontSize("caption", 12)
    if widget.vs.SetHeight then widget.vs:SetHeight(centerLineH) end
    if widget.headToHead.SetHeight then widget.headToHead:SetHeight(centerLineH) end
  end
  applyLabelFont(widget.favorLabel, "label")
  applyLabelFont(widget.pctA, "label")
  applyLabelFont(widget.pctB, "label")

  widget.barA = CreateFrame("StatusBar", nil, widget)
  widget.barB = CreateFrame("StatusBar", nil, widget)
  applyBarFill(widget.barA, "bar_favor_fill")
  applyBarFill(widget.barB, "bar_favor_fill")
  if widget.barA.SetMinMaxValues then widget.barA:SetMinMaxValues(0, 100) end
  if widget.barB.SetMinMaxValues then widget.barB:SetMinMaxValues(0, 100) end
  if widget.barA.SetHeight then widget.barA:SetHeight(sm) end
  if widget.barB.SetHeight then widget.barB:SetHeight(sm) end

  widget.favorSigil = widget:CreateTexture(nil, "ARTWORK")
  widget.favorSigil:SetSize(glyph, glyph)
  applyTexture(widget.favorSigil, themeTexture("sigil_favor"))
  do
    local gold = themeColorTable("gold")
    if gold and widget.favorSigil.SetVertexColor then
      widget.favorSigil:SetVertexColor(gold.r, gold.g, gold.b, 1)
      widget.favorSigil._cobColor = { r = gold.r, g = gold.g, b = gold.b, a = 1 }
    end
  end

  widget.pickA = CreateFrame("Button", nil, widget)
  widget.pickB = CreateFrame("Button", nil, widget)
  if widget.pickA.EnableMouse then widget.pickA:EnableMouse(true) end
  if widget.pickB.EnableMouse then widget.pickB:EnableMouse(true) end
  if widget.GetFrameLevel and widget.pickA.SetFrameLevel then
    local above = (widget:GetFrameLevel() or 1) + 5
    widget.pickA:SetFrameLevel(above)
    if widget.pickB.SetFrameLevel then widget.pickB:SetFrameLevel(above) end
  end

  widget.nameA:SetPoint("TOPLEFT", widget.nameFieldA, "TOPLEFT", md, -xs)
  widget.nameB:SetPoint("TOPRIGHT", widget.nameFieldB, "TOPRIGHT", -md, -xs)
  widget.vs:SetPoint("TOP", widget.seal, "BOTTOM", 0, 0)
  widget.vs:SetText("VS")
  tint(widget.vs, themeColorTable("silver"))

  widget.railA = widget:CreateTexture(nil, "ARTWORK")
  widget.railB = widget:CreateTexture(nil, "ARTWORK")
  if widget.railA.SetHeight then widget.railA:SetHeight(sm) end
  if widget.railB.SetHeight then widget.railB:SetHeight(sm) end
  widget.railA:SetPoint("TOPLEFT", widget.nameA, "BOTTOMLEFT", 0, -xs)
  widget.railA:SetPoint("RIGHT", widget.nameFieldA, "RIGHT", -md, 0)
  widget.railB:SetPoint("TOPRIGHT", widget.nameB, "BOTTOMRIGHT", 0, -xs)
  widget.railB:SetPoint("LEFT", widget.nameFieldB, "LEFT", md, 0)
  tintRail(widget.railA, nil)
  tintRail(widget.railB, nil)

  widget.healthGhostA = CreateFrame("StatusBar", nil, widget)
  widget.healthGhostB = CreateFrame("StatusBar", nil, widget)
  widget.healthA = CreateFrame("StatusBar", nil, widget)
  widget.healthB = CreateFrame("StatusBar", nil, widget)
  applyBarFill(widget.healthGhostA, "bar_stainedglass_fill")
  applyBarFill(widget.healthGhostB, "bar_stainedglass_fill")
  applyBarFill(widget.healthA, "bar_stainedglass_fill")
  applyBarFill(widget.healthB, "bar_stainedglass_fill")
  if widget.healthGhostA.SetMinMaxValues then widget.healthGhostA:SetMinMaxValues(0, 100) end
  if widget.healthGhostB.SetMinMaxValues then widget.healthGhostB:SetMinMaxValues(0, 100) end
  if widget.healthA.SetMinMaxValues then widget.healthA:SetMinMaxValues(0, 100) end
  if widget.healthB.SetMinMaxValues then widget.healthB:SetMinMaxValues(0, 100) end
  if widget.healthGhostA.SetHeight then widget.healthGhostA:SetHeight(sm) end
  if widget.healthGhostB.SetHeight then widget.healthGhostB:SetHeight(sm) end
  if widget.healthA.SetHeight then widget.healthA:SetHeight(sm) end
  if widget.healthB.SetHeight then widget.healthB:SetHeight(sm) end
  widget.healthGhostA:SetPoint("TOPLEFT", widget.railA, "TOPLEFT", 0, 0)
  widget.healthGhostA:SetPoint("BOTTOMRIGHT", widget.railA, "BOTTOMRIGHT", 0, 0)
  widget.healthGhostB:SetPoint("TOPLEFT", widget.railB, "TOPLEFT", 0, 0)
  widget.healthGhostB:SetPoint("BOTTOMRIGHT", widget.railB, "BOTTOMRIGHT", 0, 0)
  widget.healthA:SetPoint("TOPLEFT", widget.railA, "TOPLEFT", 0, 0)
  widget.healthA:SetPoint("BOTTOMRIGHT", widget.railA, "BOTTOMRIGHT", 0, 0)
  widget.healthB:SetPoint("TOPLEFT", widget.railB, "TOPLEFT", 0, 0)
  widget.healthB:SetPoint("BOTTOMRIGHT", widget.railB, "BOTTOMRIGHT", 0, 0)
  if widget.GetFrameLevel then
    local glass = (widget:GetFrameLevel() or 1) + 2
    if widget.healthGhostA.SetFrameLevel then widget.healthGhostA:SetFrameLevel(glass) end
    if widget.healthGhostB.SetFrameLevel then widget.healthGhostB:SetFrameLevel(glass) end
    if widget.healthA.SetFrameLevel then widget.healthA:SetFrameLevel(glass + 1) end
    if widget.healthB.SetFrameLevel then widget.healthB:SetFrameLevel(glass + 1) end
  end
  widget.healthGhostA:Hide()
  widget.healthGhostB:Hide()
  widget.healthA:Hide()
  widget.healthB:Hide()

  -- Format uses the identity half. Record + defense stack under it so
  -- `70 · Beef Knight · Warrior` at label 12 has ≥116px and cannot
  -- wrap onto the favor row. Inner gutter is Theme.Space.md, not a
  -- 68px tally steal.
  widget.titleA:SetPoint("TOPLEFT", widget.railA, "BOTTOMLEFT", 0, -xs)
  widget.titleA:SetPoint("RIGHT", widget.nameFieldA, "RIGHT", -md, 0)
  widget.titleB:SetPoint("TOPRIGHT", widget.railB, "BOTTOMRIGHT", 0, -xs)
  widget.titleB:SetPoint("LEFT", widget.nameFieldB, "LEFT", md, 0)
  if widget.titleA.SetMaxLines then widget.titleA:SetMaxLines(1) end
  if widget.titleB.SetMaxLines then widget.titleB:SetMaxLines(1) end

  widget.levelA:SetPoint("TOPLEFT", widget.titleA, "BOTTOMLEFT", 0, -rule)
  widget.levelB:SetPoint("TOPRIGHT", widget.titleB, "BOTTOMRIGHT", 0, -rule)
  widget.levelA:Hide()
  widget.levelB:Hide()
  widget.recordA:SetPoint("TOPLEFT", widget.titleA, "BOTTOMLEFT", 0, -rule)
  widget.recordB:SetPoint("TOPRIGHT", widget.titleB, "BOTTOMRIGHT", 0, -rule)
  widget.defenseA:SetPoint("LEFT", widget.recordA, "RIGHT", sm, 0)
  widget.defenseB:SetPoint("RIGHT", widget.recordB, "LEFT", -sm, 0)
  widget.defenseA:SetWidth(28)
  widget.defenseB:SetWidth(28)
  widget.defenseA:Hide()
  widget.defenseB:Hide()
  -- The compact center column carries matchup context under VS. Keeping it
  -- above the gold rule leaves the footer exclusively for the favor split.
  widget.headToHead:SetPoint("TOP", widget.vs, "BOTTOM", 0, 0)
  widget.headToHead:Hide()

  widget.favorLabel:SetPoint("BOTTOM", widget, "BOTTOM", 0, sm)
  widget.favorLabel:SetText(Hud.COPY.pickSide)
  widget.favorSigil:SetPoint("RIGHT", widget.favorLabel, "LEFT", -xs, 0)
  widget.pctA:SetPoint("BOTTOMLEFT", widget, "BOTTOMLEFT", md, sm)
  widget.pctB:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -md, sm)
  widget.barA:SetPoint("LEFT", widget.pctA, "RIGHT", xs, 0)
  widget.barA:SetPoint("RIGHT", widget.favorSigil, "LEFT", -xs, 0)
  widget.barA:SetPoint("BOTTOM", widget, "BOTTOM", 0, sm)
  widget.barB:SetPoint("RIGHT", widget.pctB, "LEFT", -xs, 0)
  widget.barB:SetPoint("LEFT", widget.favorLabel, "RIGHT", xs, 0)
  widget.barB:SetPoint("BOTTOM", widget, "BOTTOM", 0, sm)
  widget.favorLabel:Hide()
  widget.favorSigil:Hide()
  widget.pctA:Hide()
  widget.pctB:Hide()
  widget.barA:Hide()
  widget.barB:Hide()

  widget.pickA:SetPoint("TOPLEFT", widget.nameFieldA, "TOPLEFT", 0, 0)
  widget.pickA:SetPoint("BOTTOMRIGHT", widget.nameFieldA, "BOTTOMRIGHT", 0, 0)
  widget.pickB:SetPoint("TOPLEFT", widget.nameFieldB, "TOPLEFT", 0, 0)
  widget.pickB:SetPoint("BOTTOMRIGHT", widget.nameFieldB, "BOTTOMRIGHT", 0, 0)
  local function plateEnter(self)
    if not pickPair() then
      if GameTooltip and GameTooltip.Hide then GameTooltip:Hide() end
      return
    end
    if type(GameTooltip) ~= "table" then return end
    if GameTooltip.SetOwner then GameTooltip:SetOwner(self, "ANCHOR_TOP") end
    if GameTooltip.SetText then GameTooltip:SetText(Hud.COPY.favorHint) end
    if GameTooltip.Show then GameTooltip:Show() end
  end
  local function plateLeave()
    if GameTooltip and GameTooltip.Hide then GameTooltip:Hide() end
  end
  widget.pickA:SetScript("OnClick", function()
    clickPlate("A")
  end)
  widget.pickB:SetScript("OnClick", function()
    clickPlate("B")
  end)
  widget.pickA:SetScript("OnEnter", plateEnter)
  widget.pickB:SetScript("OnEnter", plateEnter)
  widget.pickA:SetScript("OnLeave", plateLeave)
  widget.pickB:SetScript("OnLeave", plateLeave)

  widget:SetScript("OnDragStart", function(self)
    if self.StartMoving then self:StartMoving() end
  end)
  widget:SetScript("OnDragStop", function(self)
    if self.StopMovingOrSizing then self:StopMovingOrSizing() end
    savePoint(self)
  end)
  if type(widget.RegisterEvent) == "function" then
    widget:RegisterEvent("DISPLAY_SIZE_CHANGED")
    widget:RegisterEvent("UI_SCALE_CHANGED")
    if type(widget.SetScript) == "function" then
      widget:SetScript("OnEvent", function(_, event, unit)
        liveHealth.onEvent(event, unit)
      end)
    end
  end
  widget:Hide()
  return widget
end

function Hud:Init()
  if not frame then
    frame = build()
    restorePoint(frame)
  end
  self:Refresh()
  return frame
end

function Hud:IsShown()
  return frame ~= nil and frame:IsShown() == true
end

function Hud:GetView()
  if lastView == nil then lastView = hiddenView() end
  return deepcopy(lastView)
end

function Hud:Refresh()
  if not frame then
    self:Init()
    return self:GetView()
  end
  if not eventLive() then
    forgetPersist()
    prevRuntimeState = runtimeState()
    paintHidden()
    return self:GetView()
  end
  local pair = displayPair()
  updateRuledFlags(pair ~= nil)
  if not pair then
    paintHidden()
    return self:GetView()
  end
  paintShown(pair)
  return self:GetView()
end

function Hud:SetBroadcastFavor(favor)
  if type(favor) ~= "table" then
    broadcastFavor = nil
    return
  end
  local a, b = favor.a, favor.b
  if type(a) ~= "number" or type(b) ~= "number" then
    broadcastFavor = nil
    return
  end
  broadcastFavor = { a = a, b = b }
end

function Hud:SetFavorTarget(target)
  if type(target) == "string" and target ~= "" then
    favorTarget = target
  else
    favorTarget = nil
  end
end

function Hud:SetLocalCharacterId(characterId)
  if type(characterId) == "number" then
    localCharacterId = characterId
  else
    localCharacterId = nil
  end
end

-- A blank target is not a refusal: Net:SendFavor resolves the default
-- destination (last accepted STATE sender, then the listed Pope).
function Hud:PickFavor(pickId, target, characterId)
  if type(characterId) ~= "number" then
    return nil, "no character"
  end
  if not (COB.Net and COB.Net.SendFavor) then
    return nil, "no net"
  end
  return COB.Net:SendFavor({ characterId = characterId, pick = pickId }, target)
end

function Hud:ResetForTests()
  if not COB._IN_TEST then return false end
  broadcastFavor = nil
  favorTarget = nil
  localCharacterId = nil
  forgetPersist()
  lastView = hiddenView()
  if frame then
    paintHidden()
  end
  return true
end
