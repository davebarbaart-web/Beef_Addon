ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Player-opened Quiet identity/history (Bible §14.2). Theatrical parchment
-- superlatives (Law 10 / §10.9 / §19.3). Not a sortable ladder. Toggle / Show /
-- Hide only. The UI never records outcomes, never narrates, and never tells jokes.
local RecordsBook = {
  MODE = "QUIET",
}
COB.RecordsBook = RecordsBook

local FRAME_NAME = "ChurchOfBeefRecordsBook"
local TITLE_FONT = "Interface\\AddOns\\ChurchOfBeef\\Media\\RecordsTitle.ttf"
local SEAL_TEXTURE = "Interface\\AddOns\\ChurchOfBeef\\Media\\records-seal"

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

local function fill(tex, r, g, b, a)
  if not tex then return end
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, a)
  else
    tex:SetTexture("Interface\\Buttons\\WHITE8X8")
    if tex.SetVertexColor then tex:SetVertexColor(r, g, b, a) end
  end
end

local function applyFont(fs, template, path, size)
  if not fs then return end
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
end

local function labelButton(button, text, template)
  if not button then return end
  local fs = button:CreateFontString(nil, "OVERLAY", template or "GameFontNormal")
  applyFont(fs, template or "GameFontNormal")
  if button.SetFontString then button:SetFontString(fs) end
  if fs.SetTextColor then fs:SetTextColor(0.45, 0.32, 0.12, 1) end
  button:SetText(text)
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

  -- Most Successful Defenses: empty until a derived defense stat exists
  -- (OPEN_QUESTIONS #9). Do not invent an increment from elevationAt.
  put("Most Successful Defenses", {})

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
    if title == "Greatest Rivalry" then
      lines[#lines + 1] = string.format("%s  %d – %d  %s",
        e.nameA or "", e.scoreA or 0, e.scoreB or 0, e.nameB or "")
    elseif title == "Famous Upsets" then
      lines[#lines + 1] = string.format("%s over %s", e.name or "", e.opponentName or "")
    elseif title == "The Undefeated" then
      lines[#lines + 1] = e.name or ""
    elseif title == "Most Sanctioned Victories" then
      lines[#lines + 1] = string.format("%s — %d", e.name or "", e.wins or 0)
    elseif title == "Longest Streak" then
      lines[#lines + 1] = string.format("%s — %d", e.name or "", e.streak or 0)
    elseif title == "The Iron Chin" then
      lines[#lines + 1] = string.format("%s — %d", e.name or "", e.fought or 0)
    elseif title == "The Glorious Martyr" then
      lines[#lines + 1] = string.format("%s — %d", e.name or "", e.losses or 0)
    else
      lines[#lines + 1] = e.name or ""
    end
  end
  return table.concat(lines, "\n")
end

local function paint()
  local frame = RecordsBook.frame
  if not frame then return end
  local pages = buildPages()
  local n = #pages
  if pageIndex < 1 then pageIndex = 1 end
  if n >= 1 and pageIndex > n then pageIndex = n end
  local page = pages[pageIndex]
  if frame.PageTitle and frame.PageTitle.SetText then
    frame.PageTitle:SetText(page and page.title or "")
  end
  if frame.Body and frame.Body.SetText then
    frame.Body:SetText(bodyText(page))
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

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
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
  frame:SetWidth(540)
  frame:SetHeight(400)
  frame:Hide()

  local iron = frame:CreateTexture(nil, "BACKGROUND")
  iron:SetAllPoints(frame)
  fill(iron, 0.08, 0.07, 0.06, 0.96)
  frame.Iron = iron

  local gold = frame:CreateTexture(nil, "BORDER")
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
  fill(gold, 0.72, 0.62, 0.38, 1)
  frame.GoldEdge = gold

  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
  parchment:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
  fill(parchment, 0.78, 0.70, 0.52, 0.94)
  frame.Parchment = parchment

  local seal = frame:CreateTexture(nil, "OVERLAY")
  seal:SetTexture(SEAL_TEXTURE)
  seal:SetWidth(36)
  seal:SetHeight(36)
  seal:SetPoint("BOTTOM", frame, "BOTTOM", 0, 28)
  frame.Seal = seal

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  title:SetPoint("TOP", frame, "TOP", 0, -28)
  applyFont(title, "GameFontNormalHuge", TITLE_FONT, 20)
  if title.SetTextColor then title:SetTextColor(0.45, 0.32, 0.12, 1) end
  title:SetText("The Records Book")
  frame.TitleText = title

  local pageTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  pageTitle:SetPoint("TOP", title, "BOTTOM", 0, -18)
  applyFont(pageTitle, "GameFontNormalLarge")
  if pageTitle.SetTextColor then pageTitle:SetTextColor(0.42, 0.12, 0.10, 1) end
  pageTitle:SetText("")
  frame.PageTitle = pageTitle

  local body = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  body:SetPoint("TOP", pageTitle, "BOTTOM", 0, -22)
  body:SetPoint("LEFT", frame, "LEFT", 36, 0)
  body:SetPoint("RIGHT", frame, "RIGHT", -36, 0)
  applyFont(body, "GameFontNormal")
  if body.SetTextColor then body:SetTextColor(0.18, 0.12, 0.08, 1) end
  if body.SetJustifyH then body:SetJustifyH("CENTER") end
  body:SetText("")
  frame.Body = body

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
  if self.frame then return self.frame end
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
  paint()
  frame:Show()
  return true
end

function RecordsBook:Hide()
  if self.frame then self.frame:Hide() end
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
