ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Player-opened Quiet identity/history (Bible §14.2). Theatrical parchment
-- (Law 10 / §10.9 / §19.3). Not a sortable ladder. Toggle / Show / Hide only.
-- Hide remounts a missing OnHide before rememberSpecial then frame:Hide().
-- Show remounts a missing OnHide, then paint / frame:Show(). Existing-frame
-- Init remounts a missing OnHide, then rememberSpecial. OnHide remounts
-- rememberSpecial so ESC still re-lists. Do not reset pageIndex. The UI never
-- records outcomes, never narrates, and never tells jokes.
--
-- The book is the Church's records behind the player card — Chronicle first,
-- superlatives only when held. The retired `/beef` Home spread (identity,
-- honorifics, the Decree block) lives on the player card now; the card opens
-- this book via ShowFromCard. Back, Close, and ESC return to that card.
-- Dismiss hides without bouncing so the two surfaces never stack. The book
-- has no Home spread. Marked moments stay in the Store; a later phase owns
-- their display.
--
-- Records are chronicle-first: the Chronicle leaf is always the first records
-- page and renders Store:GetCeremonyLog() newest-first as dated record lines
-- (fixed patterns per ceremony type; unknown types render the type token,
-- naming only ids with exactly one character/human resolution — never
-- invented prose). Consecutive Knighting rows that share a Gathering event
-- id, or the same calendar date when no event id is stored, collapse into
-- one tranche line — a sitting, not each promotion. Ledger entries paint
-- one FontString per row on a fixed two-line stride with no medallions; the
-- Chronicle spans both leaves (slots 1–7 on the left body column, 8–14 on
-- the right leaf); rows past the pool are not painted. Superlative pages
-- exist only when held (at least one entry), in canonical §10.9 order.
--
-- Composed tome: charcoal title band, two parchment leaves meeting at
-- center ±1, charcoal footer carrying a gold leaf caption with edge-aware
-- Previous / Next. Page title lives on the left leaf; a low-alpha papal
-- watermark (seal_papal) sits on the right leaf of superlative pages only.
-- Medallions stride with the body
-- (Theme.Space.lg). Dress resolves through Theme. Chrome title and page
-- titles use FontPath("label") — serif small-caps. Display/blackletter is
-- reserved for proclamation headlines and fighter names; page titles are
-- neither. Body uses FontPath("body") at Theme.FontSize body
-- floor (charcoal on parchment). Chrome title is gold on the charcoal band.
-- Page titles stay oxblood on parchment (U-M). Opaque LeftLeafFill /
-- RightLeafFill sit under letterboxed tome_records so GoldEdge cannot leak
-- through the spread margin. Leaves use Texture("tome_records") (stock
-- fallback until the spread art lands). Entry medallions use
-- Texture("seal_papal") on a fixed slot pool created once; paint() only
-- shows/hides.
-- Superlative counts paint as Arabic numbers. RecordsBook.toRoman still
-- wraps Common.RomanNumeral for leaf captions and returns "" when Common
-- returns nil, matching the old public contract.
local RecordsBook = {
  MODE = "QUIET",
}
COB.RecordsBook = RecordsBook

local FRAME_NAME = "ChurchOfBeefRecordsBook"
local MEDALLION_POOL = 8

-- Chronicle ledger geometry: the 14px body face measures a 22px line pitch
-- (serif ascent+descent+leading), so each dated entry owns a fixed two-line
-- stride — one wrap never collides with the next entry. The pool holds seven
-- slots per leaf — the left body column and the right leaf — so the Chronicle
-- spans the spread; rows past the pool are simply not painted (newest-first
-- preserved).
local CHRONICLE_LINE_PX = 22
local CHRONICLE_STRIDE = CHRONICLE_LINE_PX * 2
local CHRONICLE_POOL_PER_LEAF = 7
local CHRONICLE_POOL = CHRONICLE_POOL_PER_LEAF * 2

-- Canonical §10.9 order lives on the Core keeper; the book only presents.
local PAGE_TITLES = (COB.Records and COB.Records.TITLES) or {}

local pageIndex = 1
-- Set by ShowFromCard; Close / ESC OnHide then restore the player card.
-- Back always returns.
-- Bare Show leaves this false so isolated dumps do not pop the card.
local openedFromCard = false

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

local function space(key, fallback)
  local sizes = COB.Theme and COB.Theme.Space
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
  return fallback
end

local function themeFontSize(key, fallback)
  local sizes = COB.Theme and COB.Theme.FontSize
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
  return fallback
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
    local ok, applied = pcall(fs.SetFont, fs, path, size or themeFontSize("name", 16), "")
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
  local whole = 0
  if type(n) == "number" then whole = math.floor(n) end
  if whole < 0 then whole = 0 end
  return tostring(whole)
end

local function applyParchment(tex)
  if not tex then return end
  if tex.SetHorizTile then tex:SetHorizTile(false) end
  if tex.SetVertTile then tex:SetVertTile(false) end
  if applyTexture(tex, "tome_records") then
    -- Generated masters keep a transparent production safety margin. Crop it
    -- here so the parchment reaches the leaf edges instead of painting a pale
    -- rectangle inside another pale rectangle.
    if tex.SetTexCoord then pcall(tex.SetTexCoord, tex, 0.10, 0.90, 0.10, 0.90) end
    return
  end
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

local function dressDarkPlate(btn)
  if not btn then return end
  local plate = btn._cobPlate
  if not plate then
    plate = btn:CreateTexture(nil, "ARTWORK")
    if plate.SetAllPoints then plate:SetAllPoints(btn) end
    btn._cobPlate = plate
  end
  fillRole(plate, "charcoal")
  btn._cobPlateRole = "charcoal"
end

local function labelButton(button, text, template)
  if not button then return end
  local fs = button:CreateFontString(nil, "OVERLAY", template or "GameFontNormal")
  applyFont(fs, template or "GameFontNormal", "label", 14)
  applyInk(fs, "gold")
  if fs.SetAllPoints then fs:SetAllPoints(button) end
  if fs.SetText then fs:SetText(text) end
  if button.SetFontString then button:SetFontString(fs) end
  button:SetText(text)
  dressDarkPlate(button)
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

-- Superlative math is Core (Core/Records.lua). The book paints; it does not
-- compute. Missing keeper → no superlative pages (the Chronicle still shows).
local function buildSuperlatives()
  local Records = COB.Records
  if not (Records and type(Records.Pages) == "function") then return {} end
  return Records:Pages()
end

--------------------------------------------------------------------------------
-- Chronicle: the dated ledger of what actually happened
--------------------------------------------------------------------------------

-- Chronicle name resolution. Knighting/Elevation participants are human ids
-- (Core/Knighting.lua); Gora ruling participants are character ids
-- (Core/Gora.lua: victor is winner-then-loser, cowardice is fleer-then-other,
-- void/free are fighterA-then-fighterB); Recognition rows are
-- character-then-human when present (Core/Recognition.lua).
local function humanName(id)
  if type(id) ~= "number" then return nil end
  if not (COB.Store and type(COB.Store.GetHuman) == "function") then return nil end
  local row = COB.Store:GetHuman(id)
  return row and row.name or nil
end

local function characterName(id)
  if type(id) ~= "number" then return nil end
  if not (COB.Store and type(COB.Store.GetCharacter) == "function") then return nil end
  local row = COB.Store:GetCharacter(id)
  return row and row.name or nil
end

-- WoW exposes date() as a global; the desktop harness mirrors it or falls
-- back to os.date. A missing/non-numeric wall stamp is no prefix, not an error.
local function dateStamp(at)
  if type(at) ~= "number" then return nil end
  local fn = date
  if type(fn) ~= "function" and type(os) == "table" and type(os.date) == "function" then
    fn = os.date
  end
  if type(fn) ~= "function" then return nil end
  local ok, stamp = pcall(fn, "%b %d", at)
  if not ok or type(stamp) ~= "string" or stamp == "" then return nil end
  return stamp
end

-- A Knighting sitting is one Chronicle line. Group by Gathering event id
-- when the row has one; otherwise by calendar date. Unstamped rows never
-- merge — each stays its own line. Record lines, never narration (Law 4).
local function isEventId(n)
  return type(n) == "number" and n == math.floor(n) and n >= 1
end

local function knightingGroupKey(entry)
  if type(entry) ~= "table" then return nil end
  if isEventId(entry.eventId) then
    return "e:" .. tostring(entry.eventId)
  end
  local stamp = dateStamp(entry.at)
  if stamp then
    return "d:" .. stamp
  end
  return nil
end

local function joinNames(names)
  if #names == 1 then return names[1] end
  if #names == 2 then return names[1] .. " and " .. names[2] end
  local head = {}
  for i = 1, #names - 1 do
    head[i] = names[i]
  end
  return table.concat(head, ", ") .. ", and " .. names[#names]
end

-- Unique humans first-seen; unresolved first-ids still count so a broken
-- row does not vanish from the tranche tally.
local NAMED_TRANCHE_MAX = 3

local function knightingCeremonyLine(rows)
  if type(rows) ~= "table" or #rows == 0 then
    return "A Knighting was held."
  end
  local names = {}
  local seen = {}
  local unnamed = 0
  -- rows arrive newest-first from the ledger walk; name in sitting order.
  for i = #rows, 1, -1 do
    local ids = type(rows[i].participantIds) == "table" and rows[i].participantIds or {}
    local id = ids[1]
    local name = humanName(id)
    if name then
      if not seen[id] then
        seen[id] = true
        names[#names + 1] = name
      end
    else
      unnamed = unnamed + 1
    end
  end
  local count = #names + unnamed
  if count <= 1 then
    if names[1] then return names[1] .. " was Knighted." end
    return "A Knighting was held."
  end
  if unnamed == 0 and #names <= NAMED_TRANCHE_MAX then
    return joinNames(names) .. " were Knighted."
  end
  return tostring(count) .. " were Knighted."
end

-- Record lines, never narration (Law 4). Fixed patterns per ceremony type;
-- unknown future types render the type token, naming a participant only when
-- exactly one of character/human resolution succeeds for that id.
local function ceremonyLine(entry)
  local kind = type(entry.type) == "string" and entry.type or ""
  local ids = type(entry.participantIds) == "table" and entry.participantIds or {}

  if kind == "Knighting" then
    return knightingCeremonyLine({ entry })
  elseif kind == "Elevation" then
    local name = humanName(ids[1])
    if name then return name .. " rose to Beef Lord." end
    return "An elevation was held."
  elseif kind == "victor" then
    local winner = characterName(ids[1])
    local loser = characterName(ids[2])
    if winner and loser then
      return winner .. " declared victor over " .. loser .. "."
    end
    -- Never name the loser when the winner does not resolve, and never fall
    -- through to the generic token path: a broken victor row stays bare.
    if winner then return winner .. " declared victor." end
    return "A victor was declared."
  elseif kind == "cowardice" then
    local name = characterName(ids[1])
    if name then return "Cowardice recorded: " .. name .. "." end
    return "Cowardice recorded."
  elseif kind == "void" then
    local names = {}
    local first = characterName(ids[1])
    local second = characterName(ids[2])
    if first then names[#names + 1] = first end
    if second then names[#names + 1] = second end
    if #names > 0 then
      return "A bout was voided: " .. table.concat(names, ", ") .. "."
    end
    return "A bout was voided."
  elseif kind == "free" then
    local text = type(entry.text) == "string" and entry.text or nil
    if text and text ~= "" then return "Free ruling: " .. text end
    return "Free ruling."
  end

  -- Unknown types, Recognition included: the type token plus resolved names.
  -- Adjudicated attribution rule for unknown future types: name a participant
  -- only when exactly one of character/human resolution succeeds for that id.
  -- Both (an id collision across the two sequences) or neither → no name.
  local names = {}
  for i = 1, #ids do
    local name
    if kind == "Recognition" then
      if i == 1 then
        name = characterName(ids[i])
      else
        name = humanName(ids[i])
      end
    else
      local charResolved = characterName(ids[i])
      local humanResolved = humanName(ids[i])
      if (charResolved ~= nil) ~= (humanResolved ~= nil) then
        name = charResolved or humanResolved
      end
    end
    if name then names[#names + 1] = name end
  end
  if #names > 0 then
    if kind ~= "" then return kind .. ": " .. table.concat(names, ", ") .. "." end
    return table.concat(names, ", ") .. "."
  end
  if kind ~= "" then return kind .. "." end
  return nil
end

local function datedLine(line, at)
  if not line then return nil end
  local stamp = dateStamp(at)
  if stamp then return stamp .. " — " .. line end
  return line
end

local function chronicleLine(entry)
  return datedLine(ceremonyLine(entry), entry and entry.at)
end

local function knightingTrancheLine(rows)
  if type(rows) ~= "table" or #rows == 0 then return nil end
  return datedLine(knightingCeremonyLine(rows), rows[1].at)
end

local function flushKnighting(entries, group)
  if not group then return end
  local line = knightingTrancheLine(group.rows)
  if line then entries[#entries + 1] = line end
end

-- Newest first. Consecutive Knighting rows that share a group key collapse
-- into one sitting. Other ceremony types stay one dated line per row.
local function chroniclePage()
  local entries = {}
  if COB.Store and type(COB.Store.GetCeremonyLog) == "function" then
    local log = COB.Store:GetCeremonyLog()
    if type(log) == "table" then
      local group
      for i = #log, 1, -1 do
        local entry = log[i]
        if type(entry) == "table" then
          if entry.type == "Knighting" then
            local key = knightingGroupKey(entry)
            if group and group.key and key and group.key == key then
              group.rows[#group.rows + 1] = entry
            else
              flushKnighting(entries, group)
              group = { key = key, rows = { entry } }
            end
          else
            flushKnighting(entries, group)
            group = nil
            local line = chronicleLine(entry)
            if line then entries[#entries + 1] = line end
          end
        end
      end
      flushKnighting(entries, group)
    end
  end
  return { title = "Chronicle", entries = entries }
end

-- Records area: the Chronicle first, then held superlatives in canonical
-- §10.9 order. A superlative page exists only when it has at least one entry.
local function buildPages()
  local pages = { chroniclePage() }
  local supers = buildSuperlatives()
  for i = 1, #supers do
    local page = supers[i]
    if type(page.entries) == "table" and #page.entries >= 1 then
      pages[#pages + 1] = page
    end
  end
  return pages
end

local function bodyText(page)
  if type(page) ~= "table" or type(page.entries) ~= "table" then
    return "No entries recorded."
  end
  if page.title == "Chronicle" then
    -- Ledger rows paint in the fixed-stride entry slots, not the body well;
    -- the well carries only the honest empty line.
    return "Nothing has been written yet."
  end
  if #page.entries == 0 then
    return "No entries recorded."
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

local function setShown(widget, shown)
  if not widget then return end
  if shown then
    if widget.Show then widget:Show() end
  elseif widget.Hide then
    widget:Hide()
  end
end

local function paint(pages)
  local frame = RecordsBook.frame
  if not frame then return end
  -- Pages always build: there is no Home spread to short-circuit them.
  if type(pages) ~= "table" then
    pages = buildPages()
  end
  local n = #pages
  if pageIndex < 1 then pageIndex = 1 end
  if n >= 1 and pageIndex > n then pageIndex = n end
  local page = pages[pageIndex]
  local isChronicle = type(page) == "table" and page.title == "Chronicle"
  -- Edge-aware turns: Previous only off the first leaf, Next only off the
  -- last. The caption names where the reader stands.
  setShown(frame.PrevButton, pageIndex > 1)
  setShown(frame.NextButton, pageIndex < n)
  if frame.LeafCaption and frame.LeafCaption.SetText then
    local title = page and page.title or ""
    frame.LeafCaption:SetText("Leaf " .. toRoman(pageIndex) .. " of " .. toRoman(n) .. " \194\183 " .. title)
  end
  setShown(frame.RightSeal, not isChronicle)
  local ledgerLines = {}
  if isChronicle and type(page.entries) == "table" then
    ledgerLines = page.entries
  end
  if frame.TitleText then
    applyFont(frame.TitleText, "GameFontNormalHuge", "display", 26)
    applyInk(frame.TitleText, "gold")
    frame.TitleText:SetText("The Records Book")
  end
  if frame.PageTitle and frame.PageTitle.SetText then
    applyFont(frame.PageTitle, "GameFontNormalLarge", "label", 20)
    applyInk(frame.PageTitle, "oxblood")
    frame.PageTitle:SetText(page and page.title or "")
  end
  if frame.Body and frame.Body.SetText then
    applyFont(frame.Body, "GameFontNormal", "body", 14)
    applyInk(frame.Body, "charcoal")
    if #ledgerLines > 0 then
      -- Ledger rows paint in the fixed-stride entry slots below; the body
      -- well carries only the honest empty line.
      frame.Body:SetText("")
    else
      frame.Body:SetText(bodyText(page))
    end
  end
  -- Chronicle ledger: fixed slot pool, one FontString per entry on a fixed
  -- two-line stride. Rows past the pool are simply not painted. paint() only
  -- shows/hides and sets text; never mints frames here.
  local chronSlots = frame.ChronicleEntries
  if type(chronSlots) == "table" then
    for i = 1, #chronSlots do
      local slot = chronSlots[i]
      if slot then
        local line = ledgerLines[i]
        if line then
          if slot.SetText then slot:SetText(line) end
          if slot.Show then slot:Show() end
        else
          if slot.SetText then slot:SetText("") end
          if slot.Hide then slot:Hide() end
        end
      end
    end
  end
  -- Fixed medallion pool: show one slot per superlative entry. The Chronicle
  -- leaf shows none — the papal seal marks a superlative holder, not a ledger
  -- bullet. Never mint frames here.
  local slots = frame.Medallions
  local entries = page and page.entries
  local entryCount = (type(entries) == "table") and #entries or 0
  if isChronicle then entryCount = 0 end
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
  local pages = buildPages()
  local n = #pages
  local nextIndex = pageIndex + delta
  if nextIndex < 1 then nextIndex = 1 end
  if nextIndex > n then nextIndex = n end
  pageIndex = nextIndex
  paint(pages)
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

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

local function showPlayerCard()
  local card = COB.PlayerCard
  if not (type(card) == "table" and type(card.Show) == "function") then return end
  pcall(card.Show, card)
end

-- ESC Hide via UISpecialFrames bypasses RecordsBook:Hide. Restore a
-- missing OnHide; never replace an existing script. Remount
-- rememberSpecial so ESC still re-lists. Do not reset pageIndex.
-- Do not wire OnShow. Close / ESC return to the card only when the
-- card opened the book (ShowFromCard).
local function wireBookOnHide(widget)
  if not widget then return end
  if type(widget.SetScript) ~= "function" then return end
  local existing = type(widget.GetScript) == "function" and widget:GetScript("OnHide")
  if existing then return end
  widget:SetScript("OnHide", function()
    rememberSpecial(FRAME_NAME)
    if openedFromCard then
      openedFromCard = false
      showPlayerCard()
    end
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

local TOME_MIN_W, TOME_MIN_H = 620, 500
local TOME_DEFAULT_W, TOME_DEFAULT_H = 680, 520
local TOME_LAYOUT_VERSION = 2
local TOME_MARGIN = 40

local function parentWH()
  local parent = UIParent
  local w = parent and parent.GetWidth and parent:GetWidth()
  local h = parent and parent.GetHeight and parent:GetHeight()
  if type(w) ~= "number" or w <= 0 then w = nil end
  if type(h) ~= "number" or h <= 0 then h = nil end
  return w, h
end

local function clampTomeSize(w, h)
  if type(w) ~= "number" or w ~= w then w = TOME_DEFAULT_W end
  if type(h) ~= "number" or h ~= h then h = tomeHeight() end
  if w < TOME_MIN_W then w = TOME_MIN_W end
  if h < TOME_MIN_H then h = TOME_MIN_H end
  local pw, ph = parentWH()
  if pw then w = math.min(w, math.max(TOME_MIN_W, pw - TOME_MARGIN)) end
  if ph then h = math.min(h, math.max(TOME_MIN_H, ph - TOME_MARGIN)) end
  return math.floor(w + 0.5), math.floor(h + 0.5)
end

local function savePoint(frame)
  local slot = uiSlot()
  if not slot then return end
  local point, _, relativePoint, x, y = frame:GetPoint(1)
  if type(point) ~= "string" or type(x) ~= "number" or type(y) ~= "number" then return end
  slot.point = { point = point, relativePoint = relativePoint or point, x = x, y = y }
end

local function saveSize(frame)
  local slot = uiSlot()
  if not slot or not frame then return end
  local w, h = frame:GetWidth(), frame:GetHeight()
  if type(w) ~= "number" or type(h) ~= "number" then return end
  w, h = clampTomeSize(w, h)
  slot.w = w
  slot.h = h
end

local function restoreSize(frame)
  if not frame then return end
  local slot = uiSlot()
  local w, h = TOME_DEFAULT_W, TOME_DEFAULT_H
  if type(slot) == "table" and slot.layoutVersion == TOME_LAYOUT_VERSION then
    if type(slot.w) == "number" then w = slot.w end
    if type(slot.h) == "number" then h = slot.h end
  end
  w, h = clampTomeSize(w, h)
  frame:SetWidth(w)
  frame:SetHeight(h)
  if type(slot) == "table" then
    slot.layoutVersion = TOME_LAYOUT_VERSION
    slot.w, slot.h = w, h
  end
end

local function applyTomeBounds(frame)
  if not frame then return end
  local pw, ph = parentWH()
  local maxW = pw and math.max(TOME_MIN_W, pw - TOME_MARGIN) or 1200
  local maxH = ph and math.max(TOME_MIN_H, ph - TOME_MARGIN) or 1200
  if type(frame.SetResizeBounds) == "function" then
    frame:SetResizeBounds(TOME_MIN_W, TOME_MIN_H, maxW, maxH)
  else
    if type(frame.SetMinResize) == "function" then
      frame:SetMinResize(TOME_MIN_W, TOME_MIN_H)
    end
    if type(frame.SetMaxResize) == "function" then
      frame:SetMaxResize(maxW, maxH)
    end
  end
end

local function onTomeSizeChanged(frame)
  if not frame or frame._cobClamping then return end
  local w, h = frame:GetWidth(), frame:GetHeight()
  local cw, ch = clampTomeSize(w, h)
  if cw ~= w or ch ~= h then
    frame._cobClamping = true
    frame:SetWidth(cw)
    frame:SetHeight(ch)
    frame._cobClamping = false
  end
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
  frame:SetResizable(true)
  frame:SetClampedToScreen(true)
  if type(frame.EnableMouseWheel) == "function" then
    frame:EnableMouseWheel(true)
  end
  if type(frame.SetScript) == "function" then
    frame:SetScript("OnMouseWheel", onMouseWheel)
  end
  frame:SetWidth(TOME_DEFAULT_W)
  frame:SetHeight(TOME_DEFAULT_H)
  restoreSize(frame)
  applyTomeBounds(frame)
  frame:Hide()

  -- After the initial Hide so create does not fire OnHide remount.
  wireBookOnHide(frame)

  local sm = space("sm", 8)
  local md = space("md", 16)
  local xs = space("xs", 4)
  local lg = space("lg", 24)
  local xl = space("xl", 32)
  local ruleH = space("rule", 2)
  local bandH = 56
  local footerH = 48
  local sealPx = 40

  local iron = frame:CreateTexture(nil, "BACKGROUND")
  iron:SetAllPoints(frame)
  fillRole(iron, "iron", 0.96)
  frame.Iron = iron

  local gold = frame:CreateTexture(nil, "BORDER")
  gold:SetPoint("TOPLEFT", frame, "TOPLEFT", ruleH, -ruleH)
  gold:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -ruleH, ruleH)
  fillRole(gold, "gold", 1)
  frame.GoldEdge = gold

  local titleBand = frame:CreateTexture(nil, "ARTWORK")
  titleBand:SetPoint("TOPLEFT", frame, "TOPLEFT", xs, -xs)
  titleBand:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -xs, -xs)
  if titleBand.SetHeight then titleBand:SetHeight(bandH) end
  fillRole(titleBand, "charcoal")
  frame.TitleBand = titleBand

  local footerBand = frame:CreateTexture(nil, "ARTWORK")
  footerBand:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", xs, xs)
  footerBand:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -xs, xs)
  if footerBand.SetHeight then footerBand:SetHeight(footerH) end
  fillRole(footerBand, "charcoal")
  frame.FooterBand = footerBand

  -- Opaque parchment under each leaf so letterboxed tome art cannot
  -- show the gold plate through its margin.
  local leftFill = frame:CreateTexture(nil, "ARTWORK")
  leftFill:SetPoint("TOPLEFT", titleBand, "BOTTOMLEFT", 0, 0)
  leftFill:SetPoint("BOTTOMLEFT", footerBand, "TOPLEFT", 0, 0)
  leftFill:SetPoint("RIGHT", frame, "CENTER", -1, 0)
  fillRole(leftFill, "parchment", 1)
  if leftFill.SetDrawLayer then leftFill:SetDrawLayer("ARTWORK", 0) end
  frame.LeftLeafFill = leftFill

  -- Leaves sit flush under the boards and meet at the gutter (±1).
  local parchment = frame:CreateTexture(nil, "ARTWORK")
  parchment:SetPoint("TOPLEFT", titleBand, "BOTTOMLEFT", 0, 0)
  parchment:SetPoint("BOTTOMLEFT", footerBand, "TOPLEFT", 0, 0)
  parchment:SetPoint("RIGHT", frame, "CENTER", -1, 0)
  applyParchment(parchment)
  if parchment.SetDrawLayer then parchment:SetDrawLayer("ARTWORK", 1) end
  frame.Parchment = parchment

  local rightFill = frame:CreateTexture(nil, "ARTWORK")
  rightFill:SetPoint("TOPRIGHT", titleBand, "BOTTOMRIGHT", 0, 0)
  rightFill:SetPoint("BOTTOMRIGHT", footerBand, "TOPRIGHT", 0, 0)
  rightFill:SetPoint("LEFT", frame, "CENTER", 1, 0)
  fillRole(rightFill, "parchment", 1)
  if rightFill.SetDrawLayer then rightFill:SetDrawLayer("ARTWORK", 0) end
  frame.RightLeafFill = rightFill

  local rightLeaf = frame:CreateTexture(nil, "ARTWORK")
  rightLeaf:SetPoint("TOPRIGHT", titleBand, "BOTTOMRIGHT", 0, 0)
  rightLeaf:SetPoint("BOTTOMRIGHT", footerBand, "TOPRIGHT", 0, 0)
  rightLeaf:SetPoint("LEFT", frame, "CENTER", 1, 0)
  applyParchment(rightLeaf)
  if rightLeaf.SetDrawLayer then rightLeaf:SetDrawLayer("ARTWORK", 1) end
  frame.RightLeaf = rightLeaf

  local gutter = frame:CreateTexture(nil, "OVERLAY")
  gutter:SetWidth(ruleH)
  gutter:SetPoint("TOP", titleBand, "BOTTOM", 0, 0)
  gutter:SetPoint("BOTTOM", footerBand, "TOP", 0, 0)
  fillRole(gutter, "gold", 1)
  frame.Gutter = gutter

  local seal = frame:CreateTexture(nil, "OVERLAY")
  applyTexture(seal, "seal_papal")
  local sr, sg, sb = themeColor("gold")
  if type(sr) == "number" and seal.SetVertexColor then
    seal:SetVertexColor(sr, sg, sb, 1)
  end
  seal._cobColorRole = "gold"
  seal:SetWidth(sealPx)
  seal:SetHeight(sealPx)
  seal:SetPoint("LEFT", titleBand, "LEFT", md, 0)
  frame.Seal = seal

  local close = COB.Theme:CloseButton(frame, function() RecordsBook:Hide() end)
  close:SetPoint("RIGHT", titleBand, "RIGHT", -sm, 0)
  frame.CloseButton = close

  local church
  if COB.Theme and type(COB.Theme.PanelButton) == "function" then
    church = COB.Theme:PanelButton(frame, "Back")
  end
  if not church then
    church = CreateFrame("Button", nil, frame)
    labelButton(church, "Back")
  end
  church:SetWidth(56)
  church:SetHeight(lg)
  church:SetPoint("RIGHT", close, "LEFT", -sm, 0)
  church:SetScript("OnClick", function() RecordsBook:ReturnToCard() end)
  frame.ChurchButton = church

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  title:SetPoint("LEFT", seal, "RIGHT", sm, 0)
  title:SetPoint("RIGHT", church, "LEFT", -sm, 0)
  if title.SetJustifyH then title:SetJustifyH("CENTER") end
  if title.SetWordWrap then title:SetWordWrap(false) end
  applyFont(title, "GameFontNormalHuge", "display", 26)
  applyInk(title, "gold")
  title:SetText("The Records Book")
  frame.TitleText = title

  local pageTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  pageTitle:SetPoint("TOPLEFT", parchment, "TOPLEFT", md, -md)
  pageTitle:SetPoint("RIGHT", parchment, "RIGHT", -md, 0)
  applyFont(pageTitle, "GameFontNormalLarge", "label", 20)
  applyInk(pageTitle, "oxblood")
  if pageTitle.SetJustifyH then pageTitle:SetJustifyH("LEFT") end
  pageTitle:SetText("")
  frame.PageTitle = pageTitle

  local rule = frame:CreateTexture(nil, "OVERLAY")
  rule:SetHeight(ruleH)
  rule:SetPoint("TOPLEFT", pageTitle, "BOTTOMLEFT", 0, -sm)
  rule:SetPoint("RIGHT", parchment, "RIGHT", -md, 0)
  fillRole(rule, "gold", 1)
  frame.TitleRule = rule

  local body = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  body:SetPoint("TOPLEFT", rule, "BOTTOMLEFT", lg, -md)
  body:SetPoint("RIGHT", parchment, "RIGHT", -md, 0)
  body:SetPoint("BOTTOM", footerBand, "TOP", 0, sm)
  applyFont(body, "GameFontNormal", "body", 14)
  applyInk(body, "charcoal")
  if body.SetJustifyH then body:SetJustifyH("LEFT") end
  if body.SetJustifyV then body:SetJustifyV("TOP") end
  if body.SetWordWrap then body:SetWordWrap(true) end
  if body.SetMaxLines then body:SetMaxLines(MEDALLION_POOL) end
  body:SetText("")
  frame.Body = body

  -- Entry medallions: fixed pool. paint() shows/hides; never rebuilds.
  -- Sit in the left-leaf gutter, one stride per body line, on superlative
  -- pages only — the Chronicle leaf renders no medallions.
  frame.Medallions = {}
  for i = 1, MEDALLION_POOL do
    local slot = frame:CreateTexture(nil, "OVERLAY")
    dressMedallion(slot)
    slot:SetWidth(md)
    slot:SetHeight(md)
    slot:SetPoint("TOPRIGHT", body, "TOPLEFT", -sm, -(i - 1) * lg)
    if slot.Hide then slot:Hide() end
    frame.Medallions[i] = slot
  end
  frame.Medallion = frame.Medallions[1]

  -- Chronicle ledger slots: fixed pool, one FontString per entry on a fixed
  -- two-line stride so a single wrap never collides with the next entry.
  -- Slots 1–7 hang on the left body column, 8–14 on the right leaf — the
  -- Chronicle spans the spread. paint() shows/hides and sets text; never
  -- rebuilds.
  frame.ChronicleEntries = {}
  for i = 1, CHRONICLE_POOL do
    local slot = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    if i <= CHRONICLE_POOL_PER_LEAF then
      slot:SetPoint("TOPLEFT", body, "TOPLEFT", 0, -(i - 1) * CHRONICLE_STRIDE)
      slot:SetPoint("RIGHT", body, "RIGHT", 0, 0)
    else
      local row = i - CHRONICLE_POOL_PER_LEAF - 1
      slot:SetPoint("TOPLEFT", rightLeaf, "TOPLEFT", md, -(md + row * CHRONICLE_STRIDE))
      slot:SetPoint("RIGHT", rightLeaf, "RIGHT", -md, 0)
    end
    applyFont(slot, "GameFontNormal", "body", 14)
    applyInk(slot, "charcoal")
    if slot.SetJustifyH then slot:SetJustifyH("LEFT") end
    if slot.SetJustifyV then slot:SetJustifyV("TOP") end
    if slot.SetWordWrap then slot:SetWordWrap(true) end
    if slot.SetMaxLines then slot:SetMaxLines(2) end
    slot:SetText("")
    if slot.Hide then slot:Hide() end
    frame.ChronicleEntries[i] = slot
  end

  -- Superlative leaves: a quiet papal watermark on the right leaf.
  local rightSeal = frame:CreateTexture(nil, "ARTWORK")
  rightSeal:SetWidth(160)
  rightSeal:SetHeight(160)
  rightSeal:SetPoint("CENTER", rightLeaf, "CENTER", 0, 0)
  applyTexture(rightSeal, "seal_papal")
  if rightSeal.SetAlpha then rightSeal:SetAlpha(0.18) end
  rightSeal:Hide()
  frame.RightSeal = rightSeal

  local titleBar = CreateFrame("Frame", nil, frame)
  titleBar:SetPoint("TOPLEFT", titleBand, "TOPLEFT", sm, 0)
  local closeW = (close.GetWidth and close:GetWidth()) or 32
  local backW = (church.GetWidth and church:GetWidth()) or 56
  titleBar:SetPoint("TOPRIGHT", titleBand, "TOPRIGHT", -(backW + closeW + sm + sm), 0)
  titleBar:SetHeight(bandH)
  titleBar:EnableMouse(true)
  titleBar:RegisterForDrag("LeftButton")
  titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
  titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    savePoint(frame)
    saveSize(frame)
  end)
  frame.TitleBar = titleBar

  local footerBar = CreateFrame("Frame", nil, frame)
  footerBar:SetPoint("TOPLEFT", footerBand, "TOPLEFT", 0, 0)
  footerBar:SetPoint("BOTTOMRIGHT", footerBand, "BOTTOMRIGHT", 0, 0)
  footerBar:EnableMouse(true)
  frame.FooterBar = footerBar

  local caption = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  caption:SetPoint("CENTER", footerBand, "CENTER", 0, 0)
  applyFont(caption, "GameFontNormal", "label", 14)
  applyInk(caption, "gold")
  if caption.SetJustifyH then caption:SetJustifyH("CENTER") end
  caption:SetText("")
  frame.LeafCaption = caption

  local prev
  if COB.Theme and type(COB.Theme.PanelButton) == "function" then
    prev = COB.Theme:PanelButton(frame, "\226\128\185 PREVIOUS")
  end
  if not prev then
    prev = CreateFrame("Button", nil, frame)
    labelButton(prev, "\226\128\185 PREVIOUS")
  end
  prev:SetWidth(112)
  prev:SetHeight(xl)
  prev:SetPoint("LEFT", footerBand, "LEFT", md, 0)
  prev._cobPlateRole = "charcoal"
  prev:SetScript("OnClick", function() turn(-1) end)
  frame.PrevButton = prev

  local nextBtn
  if COB.Theme and type(COB.Theme.PanelButton) == "function" then
    nextBtn = COB.Theme:PanelButton(frame, "NEXT \226\128\186")
  end
  if not nextBtn then
    nextBtn = CreateFrame("Button", nil, frame)
    labelButton(nextBtn, "NEXT \226\128\186")
  end
  nextBtn:SetWidth(112)
  nextBtn:SetHeight(xl)
  nextBtn:SetPoint("RIGHT", footerBand, "RIGHT", -md, 0)
  nextBtn._cobPlateRole = "charcoal"
  nextBtn:SetScript("OnClick", function() turn(1) end)
  frame.NextButton = nextBtn

  wireChildWheel(frame.TitleBar)
  wireChildWheel(frame.CloseButton)
  wireChildWheel(frame.ChurchButton)
  wireChildWheel(frame.FooterBar)
  wireChildWheel(frame.PrevButton)
  wireChildWheel(frame.NextButton)

  local grip = CreateFrame("Button", nil, frame)
  grip:SetWidth(18)
  grip:SetHeight(18)
  grip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
  grip:EnableMouse(true)
  grip:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  local grabUp = themeTexture("stock_grabber_up")
  local grabDown = themeTexture("stock_grabber_down")
  local grabHi = themeTexture("stock_grabber_highlight")
  if grabUp and grip.SetNormalTexture then grip:SetNormalTexture(grabUp) end
  if grabDown and grip.SetPushedTexture then grip:SetPushedTexture(grabDown) end
  if grabHi and grip.SetHighlightTexture then grip:SetHighlightTexture(grabHi) end
  if not grabUp then
    local gripPlate = grip:CreateTexture(nil, "ARTWORK")
    if gripPlate.SetAllPoints then gripPlate:SetAllPoints(grip) end
    fillRole(gripPlate, "iron")
  end
  grip:SetScript("OnMouseDown", function(_, button)
    if button == "RightButton" then
      frame:SetWidth(TOME_DEFAULT_W)
      frame:SetHeight(TOME_DEFAULT_H)
      saveSize(frame)
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
  end)
  frame.SizeGrip = grip
  if type(frame.HookScript) == "function" then
    frame:HookScript("OnSizeChanged", function()
      onTomeSizeChanged(frame)
    end)
  elseif type(frame.SetScript) == "function" then
    frame:SetScript("OnSizeChanged", function() onTomeSizeChanged(frame) end)
  end
  if type(frame.RegisterEvent) == "function" then
    frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
    frame:RegisterEvent("UI_SCALE_CHANGED")
    if type(frame.HookScript) == "function" then
      frame:HookScript("OnEvent", function()
        applyTomeBounds(frame)
        onTomeSizeChanged(frame)
      end)
    end
  end

  restorePoint(frame)
  rememberSpecial(FRAME_NAME)
  return frame
end

function RecordsBook:ResetForTests()
  if not COB._IN_TEST then return false end
  pageIndex = 1
  openedFromCard = false
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
  if pageIndex < 1 then pageIndex = 1 end
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

function RecordsBook:ShowFromCard()
  openedFromCard = true
  return self:Show()
end

function RecordsBook:Dismiss()
  openedFromCard = false
  return self:Hide()
end

function RecordsBook:ReturnToCard()
  openedFromCard = false
  self:Hide()
  showPlayerCard()
  return true
end
