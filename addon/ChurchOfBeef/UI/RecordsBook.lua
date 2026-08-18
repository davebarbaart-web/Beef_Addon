ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Player-opened Quiet identity/history (Bible §14.2). Theatrical parchment
-- superlatives (Law 10 / §10.9 / §19.3). Not a sortable ladder. Toggle / Show /
-- Hide only. Hide remounts a missing OnHide before rememberSpecial
-- then frame:Hide(). Show remounts a missing OnHide, then paint /
-- frame:Show(). Existing-frame Init remounts a missing OnHide, then
-- rememberSpecial. OnHide remounts rememberSpecial so ESC still
-- re-lists. Do not reset pageIndex. The UI never records outcomes,
-- never narrates, and never tells jokes.
--
-- Tome dress (lane U-H) resolves every color, font, and texture through
-- Theme. Chrome title and page titles use FontPath("label") — serif
-- small-caps. Display/blackletter is reserved for proclamation headlines
-- and fighter names; page titles are neither. Body and moment scripture
-- use FontPath("body"). Leaves use Texture("tome_records") (stock
-- fallback until the spread art lands). Entry medallions use
-- Texture("seal_papal") on a fixed slot pool created once; paint() only
-- shows/hides. Ribbons use Texture("ribbon_bookmark").
-- RecordsBook.toRoman wraps Common.RomanNumeral and returns "" when
-- Common returns nil, matching the old public contract.
local RecordsBook = {
  MODE = "QUIET",
}
COB.RecordsBook = RecordsBook

local FRAME_NAME = "ChurchOfBeefRecordsBook"
local MEDALLION_POOL = 8

local PAGE_TITLES = {
  "Most Sanctioned Victories",
  "Longest Streak",
  "Most Successful Defenses",
  "The Iron Chin",
  "Greatest Rivalry",
  "Famous Upsets",
  "The Undefeated",
  "The Glorious Martyr",
  "Tournament Champions",
}

local pageIndex = 1

local function deepcopy(value)
  if type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do
    out[deepcopy(k)] = deepcopy(v)
  end
  return out
end

local function themeColor(role)
  local Theme = COB.Theme
  if not (Theme and type(Theme.Color) == "function") then return nil end
  return Theme:Color(role)
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

local function fill(tex, r, g, b, a)
  if not tex then return end
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, a)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, a)
  end
  tex._cobColor = { r = r, g = g, b = b, a = a }
end

local function fillRole(tex, role, a)
  if not tex then return end
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  fill(tex, r, g, b, a or 1)
  tex._cobColorRole = role
end

local function applyInk(fs, role, a)
  if not fs then return end
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  if fs.SetTextColor then fs:SetTextColor(r, g, b, a or 1) end
  fs._cobColor = { r = r, g = g, b = b, a = a or 1 }
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

local function applyFont(fs, template, role, size)
  if not fs then return end
  local path = role and themeFont(role) or nil
  local used = false
  if path and fs.SetFont then
    local ok, applied = pcall(fs.SetFont, fs, path, size or 16, "")
    used = ok and applied and true or false
  end
  if not used and fs.SetFontObject then
    local font = template
    if type(template) == "string" then font = _G[template] end
    if font then pcall(fs.SetFontObject, fs, font) end
  end
  fs._cobFontRole = role
  fs._cobFontPath = path
  fs._cobFontSize = size
end

-- Public alias keeps the old contract: "" on invalid input. Common.RomanNumeral
-- returns nil+err for the same cases; floor first so 14.9 still paints XIV.
local function toRoman(n)
  if type(n) ~= "number" then return "" end
  local roman = COB.Common and COB.Common.RomanNumeral
  if type(roman) ~= "function" then return "" end
  local s = roman(math.floor(n))
  if type(s) == "string" then return s end
  return ""
end

RecordsBook.toRoman = toRoman

local function displayCount(n)
  if type(n) ~= "number" then n = 0 end
  return toRoman(n)
end

local function applyParchment(tex)
  if not tex then return end
  if applyTexture(tex, "tome_records") then return end
  fillRole(tex, "parchment", 0.94)
end

local function tomeHeight()
  local parent = UIParent
  local h = parent and parent.GetHeight and parent:GetHeight()
  if type(h) == "number" and h > 0 then
    return math.floor(h * 0.7 + 0.5)
  end
  return 480
end

local function labelButton(button, text, template)
  if not button then return end
  local fs = button:CreateFontString(nil, "OVERLAY", template or "GameFontNormal")
  applyFont(fs, template or "GameFontNormal", "label", 12)
  applyInk(fs, "gold")
  if button.SetFontString then button:SetFontString(fs) end
  button:SetText(text)
end

local function dressRibbon(btn)
  if not btn then return end
  local path = themeTexture("ribbon_bookmark")
  btn._cobTextureName = "ribbon_bookmark"
  btn._cobTexture = path
  if type(path) == "string" and btn.SetNormalTexture then
    pcall(btn.SetNormalTexture, btn, path)
  end
end

local function dressMedallion(slot)
  if not slot then return end
  applyTexture(slot, "seal_papal")
  local r, g, b = themeColor("gold")
  if type(r) == "number" and slot.SetVertexColor then
    slot:SetVertexColor(r, g, b, 1)
  end
  slot._cobColorRole = "gold"
end

local function emptyPages()
  local pages = {}
  for i = 1, #PAGE_TITLES do
    pages[i] = { title = PAGE_TITLES[i], entries = {} }
  end
  return pages
end

local function longestWinStreak(gora)
  local current, longest = 0, 0
  local results = gora and gora.results
  if type(results) ~= "table" then return 0 end
  for i = 1, #results do
    local won = results[i].won
    if won == true then
      current = current + 1
      if current > longest then longest = current end
    elseif won == false then
      current = 0
    end
  end
  return longest
end

local function foughtCount(gora)
  local results = gora and gora.results
  if type(results) ~= "table" then return 0 end
  return #results
end

local function charName(characters, id)
  local row = characters[id]
  return row and row.name or nil
end

local function indexCharacters(list)
  local byId = {}
  if type(list) ~= "table" then return byId end
  for i = 1, #list do
    local row = list[i]
    if type(row) == "table" and type(row.id) == "number" then
      byId[row.id] = row
    end
  end
  return byId
end

-- OPEN_QUESTIONS #9: sitting-Lord victories after elevationAt. Prefer Store.
-- Same walk if the method is missing. Never a stored increment.
local function deriveDefenses(gora, elevationAt)
  if type(elevationAt) ~= "number" then return 0 end
  local results = gora and gora.results
  if type(results) ~= "table" then return 0 end
  local n = 0
  for i = 1, #results do
    local result = results[i]
    if result and result.won == true then
      local at = result.at
      if type(at) == "number" and at >= elevationAt then
        n = n + 1
      end
    end
  end
  return n
end

local function countDefenses(characterId, gora, humanId)
  if COB.Store and type(COB.Store.CountDefenses) == "function" then
    local n = COB.Store:CountDefenses(characterId)
    if type(n) == "number" then return n end
    return 0
  end
  if type(humanId) ~= "number" then return 0 end
  local human = COB.Store and COB.Store.GetHuman and COB.Store:GetHuman(humanId)
  local elevationAt = human and human.elevationAt
  return deriveDefenses(gora, elevationAt)
end

local function maxHolders(rows, key)
  local best = nil
  for i = 1, #rows do
    local v = rows[i][key]
    if type(v) == "number" and (best == nil or v > best) then
      best = v
    end
  end
  if best == nil or best < 1 then return {} end
  local holders = {}
  for i = 1, #rows do
    if rows[i][key] == best then
      holders[#holders + 1] = rows[i]
    end
  end
  return holders
end

local function pairKey(a, b)
  if a < b then return a, b else return b, a end
end

local function buildPages()
  local pages = emptyPages()
  if not (COB.Store and COB.Store.Snapshot) then return pages end
  local snap = COB.Store:Snapshot()
  local list = snap and snap.characters
  if type(list) ~= "table" then return pages end

  local byId = indexCharacters(list)
  local measured = {}
  for i = 1, #list do
    local ch = list[i]
    local gora = ch.gora
    if type(ch) == "table" and type(gora) == "table" then
      local wins = gora.wins
      local losses = gora.losses
      if type(wins) ~= "number" then wins = 0 end
      if type(losses) ~= "number" then losses = 0 end
      measured[#measured + 1] = {
        characterId = ch.id,
        name = ch.name,
        humanId = ch.humanId,
        wins = wins,
        losses = losses,
        streak = longestWinStreak(gora),
        fought = foughtCount(gora),
        gora = gora,
      }
    end
  end

  local function put(title, entries)
    for i = 1, #pages do
      if pages[i].title == title then
        pages[i].entries = entries
        return
      end
    end
  end

  local victoryRows = {}
  for i = 1, #measured do
    victoryRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      wins = measured[i].wins,
    }
  end
  put("Most Sanctioned Victories", maxHolders(victoryRows, "wins"))

  local streakRows = {}
  for i = 1, #measured do
    streakRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      streak = measured[i].streak,
    }
  end
  put("Longest Streak", maxHolders(streakRows, "streak"))

  local defenseRows = {}
  for i = 1, #measured do
    defenseRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      defenses = countDefenses(measured[i].characterId, measured[i].gora, measured[i].humanId),
    }
  end
  put("Most Successful Defenses", maxHolders(defenseRows, "defenses"))

  local chinRows = {}
  for i = 1, #measured do
    chinRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      fought = measured[i].fought,
    }
  end
  put("The Iron Chin", maxHolders(chinRows, "fought"))

  local pairMap = {}
  local pairList = {}
  for i = 1, #measured do
    local ch = measured[i]
    local heads = ch.gora.headToHeads
    if type(heads) == "table" then
      for h = 1, #heads do
        local row = heads[h]
        local oppId = row and row.opponentId
        if type(oppId) == "number" and oppId ~= ch.characterId then
          local lo, hi = pairKey(ch.characterId, oppId)
          local key = tostring(lo) .. ":" .. tostring(hi)
          local pairing = pairMap[key]
          if not pairing then
            pairing = { lo = lo, hi = hi, fights = 0, scoreLo = 0, scoreHi = 0 }
            pairMap[key] = pairing
            pairList[#pairList + 1] = pairing
          end
          local fights = row.fights
          if type(fights) ~= "number" then fights = 0 end
          if fights > pairing.fights then pairing.fights = fights end
          local wins = row.wins
          local losses = row.losses
          if type(wins) ~= "number" then wins = 0 end
          if type(losses) ~= "number" then losses = 0 end
          if ch.characterId == lo then
            pairing.scoreLo = wins
            pairing.scoreHi = losses
          else
            pairing.scoreHi = wins
            pairing.scoreLo = losses
          end
        end
      end
    end
  end
  local bestFights = nil
  for i = 1, #pairList do
    local n = pairList[i].fights
    if type(n) == "number" and (bestFights == nil or n > bestFights) then
      bestFights = n
    end
  end
  local rivalries = {}
  if type(bestFights) == "number" and bestFights >= 1 then
    for i = 1, #pairList do
      local pairing = pairList[i]
      if pairing.fights == bestFights then
        rivalries[#rivalries + 1] = {
          characterIdA = pairing.lo,
          characterIdB = pairing.hi,
          nameA = charName(byId, pairing.lo),
          nameB = charName(byId, pairing.hi),
          fights = pairing.fights,
          scoreA = pairing.scoreLo,
          scoreB = pairing.scoreHi,
        }
      end
    end
  end
  put("Greatest Rivalry", rivalries)

  local seenUpset = {}
  local upsets = {}
  for i = 1, #measured do
    local ch = measured[i]
    local results = ch.gora.results
    if type(results) == "table" then
      for r = 1, #results do
        local result = results[r]
        if result and result.famousUpset == true and type(result.opponentId) == "number" then
          local lo, hi = pairKey(ch.characterId, result.opponentId)
          local at = result.at
          if type(at) ~= "number" then at = 0 end
          local key = tostring(at) .. ":" .. tostring(lo) .. ":" .. tostring(hi)
          if not seenUpset[key] then
            seenUpset[key] = true
            local winnerId, loserId = ch.characterId, result.opponentId
            if result.won == false then
              winnerId, loserId = result.opponentId, ch.characterId
            end
            upsets[#upsets + 1] = {
              characterId = winnerId,
              opponentId = loserId,
              name = charName(byId, winnerId),
              opponentName = charName(byId, loserId),
              at = result.at,
            }
          end
        end
      end
    end
  end
  put("Famous Upsets", upsets)

  local unbeaten = {}
  for i = 1, #measured do
    local row = measured[i]
    if row.wins >= 1 and row.losses == 0 then
      unbeaten[#unbeaten + 1] = {
        characterId = row.characterId,
        name = row.name,
        wins = row.wins,
      }
    end
  end
  put("The Undefeated", unbeaten)

  local martyrRows = {}
  for i = 1, #measured do
    martyrRows[i] = {
      characterId = measured[i].characterId,
      name = measured[i].name,
      losses = measured[i].losses,
    }
  end
  put("The Glorious Martyr", maxHolders(martyrRows, "losses"))

  -- Tournament Champions: empty until tournaments exist. Do not invent an engine.
  put("Tournament Champions", {})

  return pages
end

local function bodyText(page)
  if type(page) ~= "table" or type(page.entries) ~= "table" or #page.entries == 0 then
    return ""
  end
  local lines = {}
  local title = page.title
  for i = 1, #page.entries do
    local e = page.entries[i]
    local line
    if title == "Greatest Rivalry" then
      line = string.format("%s  %s – %s  %s",
        e.nameA or "", displayCount(e.scoreA or 0), displayCount(e.scoreB or 0), e.nameB or "")
    elseif title == "Famous Upsets" then
      line = string.format("%s over %s", e.name or "", e.opponentName or "")
    elseif title == "The Undefeated" then
      line = e.name or ""
    elseif title == "Most Sanctioned Victories" then
      line = string.format("%s — %s", e.name or "", displayCount(e.wins or 0))
    elseif title == "Longest Streak" then
      line = string.format("%s — %s", e.name or "", displayCount(e.streak or 0))
    elseif title == "Most Successful Defenses" then
      line = string.format("%s — %s", e.name or "", displayCount(e.defenses or 0))
    elseif title == "The Iron Chin" then
      line = string.format("%s — %s", e.name or "", displayCount(e.fought or 0))
    elseif title == "The Glorious Martyr" then
      line = string.format("%s — %s", e.name or "", displayCount(e.losses or 0))
    else
      line = e.name or ""
    end
    if type(e.citation) == "string" and e.citation ~= "" then
      line = line .. "\n" .. e.citation
    end
    lines[#lines + 1] = line
  end
  return table.concat(lines, "\n")
end

local function localPlayerKey()
  if type(UnitName) ~= "function" then return nil end
  if not (COB.Names and COB.Names.Key) then return nil end
  return COB.Names.Key(UnitName("player"))
end

-- Local human honorifics only. No character match or no human bind → empty.
local function localHonorifics()
  local key = localPlayerKey()
  if not key then return {} end
  if not (COB.Store and COB.Store.Snapshot) then return {} end
  local snap = COB.Store:Snapshot()
  local list = snap and snap.characters
  if type(list) ~= "table" then return {} end
  local humanId
  for i = 1, #list do
    local ch = list[i]
    if type(ch) == "table" and COB.Names.Key(ch.name) == key then
      humanId = ch.humanId
      break
    end
  end
  if type(humanId) ~= "number" then return {} end
  local human = COB.Store.GetHuman and COB.Store:GetHuman(humanId)
  local raw = human and human.honorifics
  if type(raw) ~= "table" then return {} end
  local titles = {}
  for i = 1, #raw do
    if type(raw[i]) == "string" and raw[i] ~= "" then
      titles[#titles + 1] = raw[i]
    end
  end
  return titles
end

-- Location first, then Pope scripture when present. No invented copy.
local function momentLines()
  if not (COB.Store and COB.Store.GetMarkedMoments) then return {} end
  local moments = COB.Store:GetMarkedMoments()
  if type(moments) ~= "table" then return {} end
  local lines = {}
  for i = 1, #moments do
    local row = moments[i]
    if type(row) == "table" then
      local loc = row.location
      if type(loc) == "string" and loc ~= "" then
        lines[#lines + 1] = loc
      end
      local scripture = row.scripture
      if type(scripture) == "string" and scripture ~= "" then
        lines[#lines + 1] = scripture
      end
    end
  end
  return lines
end

local function identityText(rows)
  if type(rows) ~= "table" or #rows == 0 then return "" end
  return table.concat(rows, "\n")
end

local function paint()
  local frame = RecordsBook.frame
  if not frame then return end
  local pages = buildPages()
  local n = #pages
  if pageIndex < 1 then pageIndex = 1 end
  if n >= 1 and pageIndex > n then pageIndex = n end
  local page = pages[pageIndex]
  if frame.TitleText then
    applyFont(frame.TitleText, "GameFontNormalHuge", "label", 20)
    applyInk(frame.TitleText, "gold")
  end
  if frame.PageTitle and frame.PageTitle.SetText then
    applyFont(frame.PageTitle, "GameFontNormalLarge", "label", 18)
    applyInk(frame.PageTitle, "oxblood")
    frame.PageTitle:SetText(page and page.title or "")
  end
  if frame.Body and frame.Body.SetText then
    applyFont(frame.Body, "GameFontNormal", "body", 12)
    applyInk(frame.Body, "charcoal")
    frame.Body:SetText(bodyText(page))
  end
  if frame.Honorifics and frame.Honorifics.SetText then
    applyFont(frame.Honorifics, "GameFontNormalLarge", "label", 18)
    applyInk(frame.Honorifics, "charcoal")
    frame.Honorifics:SetText(identityText(localHonorifics()))
  end
  if frame.Moments and frame.Moments.SetText then
    applyFont(frame.Moments, "GameFontNormal", "body", 12)
    applyInk(frame.Moments, "charcoal")
    frame.Moments:SetText(identityText(momentLines()))
  end
  -- Fixed medallion pool: show one slot per entry. Never mint frames here.
  local slots = frame.Medallions
  local entries = page and page.entries
  local entryCount = (type(entries) == "table") and #entries or 0
  if type(slots) == "table" then
    for i = 1, #slots do
      local slot = slots[i]
      if slot then
        if i <= entryCount then
          dressMedallion(slot)
          if slot.Show then slot:Show() end
        elseif slot.Hide then
          slot:Hide()
        end
      end
    end
  end
end

local function turn(delta)
  local n = #PAGE_TITLES
  local nextIndex = pageIndex + delta
  if nextIndex < 1 then nextIndex = 1 end
  if nextIndex > n then nextIndex = n end
  pageIndex = nextIndex
  paint()
end

-- Wheel up Previous, wheel down Next. Shared by the outer frame and chrome
-- that sits on top of it (TitleBar, Close, ribbons, Previous, Next).
local function onMouseWheel(_, delta)
  if type(delta) ~= "number" then return end
  if delta > 0 then
    turn(-1)
  elseif delta < 0 then
    turn(1)
  end
end

local function wireChildWheel(child)
  if not child then return end
  if type(child.EnableMouseWheel) == "function" then
    child:EnableMouseWheel(true)
  end
  if type(child.SetScript) == "function" then
    child:SetScript("OnMouseWheel", onMouseWheel)
  end
end

local function jumpToTitle(title)
  for i = 1, #PAGE_TITLES do
    if PAGE_TITLES[i] == title then
      pageIndex = i
      paint()
      return
    end
  end
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

-- ESC Hide via UISpecialFrames bypasses RecordsBook:Hide. Restore a
-- missing OnHide; never replace an existing script. Remount
-- rememberSpecial so ESC still re-lists. Do not reset pageIndex.
-- Do not wire OnShow.
local function wireBookOnHide(widget)
  if not widget then return end
  if type(widget.SetScript) ~= "function" then return end
  local existing = type(widget.GetScript) == "function" and widget:GetScript("OnHide")
  if existing then return end
  widget:SetScript("OnHide", function()
    rememberSpecial(FRAME_NAME)
  end)
end

local function uiSlot()
  if type(ChurchOfBeefDB) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui) ~= "table" then return nil end
  if type(ChurchOfBeefDB.ui.recordsBook) ~= "table" then
    ChurchOfBeefDB.ui.recordsBook = {}
  end
  return ChurchOfBeefDB.ui.recordsBook
end

local function savePoint(frame)
  local slot = uiSlot()
  if not slot then return end
  local point, _, relativePoint, x, y = frame:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  slot.point = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local ANCHORS = {
  TOPLEFT = true, TOP = true, TOPRIGHT = true,
  LEFT = true, CENTER = true, RIGHT = true,
  BOTTOMLEFT = true, BOTTOM = true, BOTTOMRIGHT = true,
}

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

local function buildFrame()
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent)
  frame:SetFrameStrata("DIALOG")
  if frame.SetToplevel then frame:SetToplevel(true) end
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  if type(frame.EnableMouseWheel) == "function" then
    frame:EnableMouseWheel(true)
  end
  if type(frame.SetScript) == "function" then
    frame:SetScript("OnMouseWheel", onMouseWheel)
  end
  frame:SetWidth(720)
  frame:SetHeight(tomeHeight())
  frame:Hide()

  -- After the initial Hide so create does not fire OnHide remount.
  wireBookOnHide(frame)

  local iron = frame:CreateTexture(nil, "BACKGROUND")
  iron:SetAllPoints(frame)
  fillRole(iron, "iron", 0.96)
  frame.Iron = iron

  local gold = frame:CreateTexture(nil, "BORDER")
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
  fillRole(gold, "gold", 1)
  frame.GoldEdge = gold

  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
  parchment:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 8)
  parchment:SetPoint("RIGHT", frame, "CENTER", -6, 0)
  applyParchment(parchment)
  frame.Parchment = parchment

  local rightLeaf = frame:CreateTexture(nil, "ARTWORK")
  rightLeaf:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
  rightLeaf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
  rightLeaf:SetPoint("LEFT", frame, "CENTER", 6, 0)
  applyParchment(rightLeaf)
  frame.RightLeaf = rightLeaf

  local gutter = frame:CreateTexture(nil, "OVERLAY")
  gutter:SetWidth(2)
  gutter:SetPoint("TOP", frame, "TOP", 0, -10)
  gutter:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)
  fillRole(gutter, "gold", 1)
  frame.Gutter = gutter

  local seal = frame:CreateTexture(nil, "OVERLAY")
  applyTexture(seal, "seal_papal")
  local sr, sg, sb = themeColor("gold")
  if type(sr) == "number" and seal.SetVertexColor then
    seal:SetVertexColor(sr, sg, sb, 1)
  end
  seal._cobColorRole = "gold"
  seal:SetWidth(28)
  seal:SetHeight(28)
  seal:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -16)
  frame.Seal = seal

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  title:SetPoint("TOP", frame, "TOP", 0, -22)
  applyFont(title, "GameFontNormalHuge", "label", 20)
  applyInk(title, "gold")
  title:SetText("The Records Book")
  frame.TitleText = title

  local pageTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  pageTitle:SetPoint("TOP", title, "BOTTOM", 0, -14)
  applyFont(pageTitle, "GameFontNormalLarge", "label", 18)
  applyInk(pageTitle, "oxblood")
  pageTitle:SetText("")
  frame.PageTitle = pageTitle

  local rule = frame:CreateTexture(nil, "OVERLAY")
  rule:SetHeight(1)
  rule:SetPoint("TOP", pageTitle, "BOTTOM", 0, -8)
  rule:SetPoint("LEFT", frame, "LEFT", 28, 0)
  rule:SetPoint("RIGHT", frame, "CENTER", -16, 0)
  fillRole(rule, "gold", 1)
  frame.TitleRule = rule

  local body = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  body:SetPoint("TOP", rule, "BOTTOM", 0, -16)
  body:SetPoint("LEFT", frame, "LEFT", 36, 0)
  body:SetPoint("RIGHT", frame, "CENTER", -16, 0)
  applyFont(body, "GameFontNormal", "body", 12)
  applyInk(body, "charcoal")
  if body.SetJustifyH then body:SetJustifyH("LEFT") end
  body:SetText("")
  frame.Body = body

  -- Right leaf is identity, not a tenth superlative page (§12.1 / §14.2 / §15).
  local honorifics = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  honorifics:SetPoint("TOP", frame, "TOP", 0, -98)
  honorifics:SetPoint("LEFT", frame, "CENTER", 20, 0)
  honorifics:SetPoint("RIGHT", frame, "RIGHT", -28, 0)
  applyFont(honorifics, "GameFontNormalLarge", "label", 18)
  applyInk(honorifics, "charcoal")
  if honorifics.SetJustifyH then honorifics:SetJustifyH("LEFT") end
  if honorifics.SetJustifyV then honorifics:SetJustifyV("TOP") end
  if honorifics.SetWordWrap then honorifics:SetWordWrap(true) end
  honorifics:SetText("")
  frame.Honorifics = honorifics

  local moments = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  moments:SetPoint("TOP", honorifics, "BOTTOM", 0, -16)
  moments:SetPoint("LEFT", frame, "CENTER", 20, 0)
  moments:SetPoint("RIGHT", frame, "RIGHT", -28, 0)
  applyFont(moments, "GameFontNormal", "body", 12)
  applyInk(moments, "charcoal")
  if moments.SetJustifyH then moments:SetJustifyH("LEFT") end
  if moments.SetJustifyV then moments:SetJustifyV("TOP") end
  if moments.SetWordWrap then moments:SetWordWrap(true) end
  moments:SetText("")
  frame.Moments = moments

  -- Entry medallions: fixed pool. paint() shows/hides; never rebuilds.
  frame.Medallions = {}
  for i = 1, MEDALLION_POOL do
    local slot = frame:CreateTexture(nil, "OVERLAY")
    dressMedallion(slot)
    slot:SetWidth(16)
    slot:SetHeight(16)
    slot:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -108 - (i - 1) * 22)
    if slot.Hide then slot:Hide() end
    frame.Medallions[i] = slot
  end
  frame.Medallion = frame.Medallions[1]

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -4)
  titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -36, -4)
  titleBar:SetHeight(28)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
  end)
  frame.TitleBar = titleBar

  local close = CreateFrame("Button", nil, frame)
  close:SetWidth(24)
  close:SetHeight(24)
  close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
  labelButton(close, "Close")
  close:SetScript("OnClick", function() RecordsBook:Hide() end)
  frame.CloseButton = close

  local function addRibbon(label, title)
    local btn = CreateFrame("Button", nil, frame)
    btn:SetWidth(88)
    btn:SetHeight(20)
    labelButton(btn, label)
    btn:SetScript("OnClick", function() jumpToTitle(title) end)
    return btn
  end

  local victoriesRibbon = addRibbon("Victories", "Most Sanctioned Victories")
  victoriesRibbon:SetPoint("BOTTOM", frame, "BOTTOM", -96, 42)
  dressRibbon(victoriesRibbon)
  frame.VictoriesRibbon = victoriesRibbon

  local rivalriesRibbon = addRibbon("Rivalries", "Greatest Rivalry")
  rivalriesRibbon:SetPoint("BOTTOM", frame, "BOTTOM", 0, 42)
  dressRibbon(rivalriesRibbon)
  frame.RivalriesRibbon = rivalriesRibbon

  local martyrsRibbon = addRibbon("Martyrs", "The Glorious Martyr")
  martyrsRibbon:SetPoint("BOTTOM", frame, "BOTTOM", 96, 42)
  dressRibbon(martyrsRibbon)
  frame.MartyrsRibbon = martyrsRibbon

  local prev = CreateFrame("Button", nil, frame)
  prev:SetWidth(96)
  prev:SetHeight(22)
  prev:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 24, 16)
  labelButton(prev, "Previous")
  prev:SetScript("OnClick", function() turn(-1) end)
  frame.PrevButton = prev

  local nextBtn = CreateFrame("Button", nil, frame)
  nextBtn:SetWidth(96)
  nextBtn:SetHeight(22)
  nextBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, 16)
  labelButton(nextBtn, "Next")
  nextBtn:SetScript("OnClick", function() turn(1) end)
  frame.NextButton = nextBtn

  wireChildWheel(frame.TitleBar)
  wireChildWheel(frame.CloseButton)
  wireChildWheel(frame.VictoriesRibbon)
  wireChildWheel(frame.RivalriesRibbon)
  wireChildWheel(frame.MartyrsRibbon)
  wireChildWheel(frame.PrevButton)
  wireChildWheel(frame.NextButton)

  restorePoint(frame)
  rememberSpecial(FRAME_NAME)
  return frame
end

function RecordsBook:ResetForTests()
  if not COB._IN_TEST then return false end
  pageIndex = 1
  if self.frame then self.frame:Hide() end
  return true
end

function RecordsBook:Init()
  if self.frame then
    wireBookOnHide(self.frame)
    rememberSpecial(FRAME_NAME)
    return self.frame
  end
  if type(CreateFrame) ~= "function" then return nil end
  self.frame = buildFrame()
  return self.frame
end

function RecordsBook:IsShown()
  return self.frame and self.frame:IsShown() and true or false
end

function RecordsBook:Show()
  local frame = self:Init()
  if not frame then return false end
  wireBookOnHide(frame)
  paint()
  frame:Show()
  return true
end

function RecordsBook:Hide()
  if self.frame then
    wireBookOnHide(self.frame)
    rememberSpecial(FRAME_NAME)
    self.frame:Hide()
  end
  return true
end

function RecordsBook:Toggle()
  if self:IsShown() then
    return self:Hide()
  end
  return self:Show()
end

function RecordsBook:GetPages()
  return deepcopy(buildPages())
end
