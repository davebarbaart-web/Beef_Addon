ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Director Console (Bible §18.1–18.3, §20.2). Mode: Event Mode Pope working
-- tool. Not Quiet congregation chrome. Not theatrical parchment.
-- Law 10 functional / stock templates. The UI never tells jokes.
-- Allowed ornaments only: title-bar Theme:Texture("seal_papal") (~20px)
-- and iron plates Theme:Texture("plate_verb" / hover / pressed) as
-- SetNormalTexture / SetHighlightTexture / SetPushedTexture on
-- SANCTION BEEF GORA and KNIGHT THIS BEEF. Desk panel ground is
-- Theme:Color("charcoal") (deeper ground, not iron chrome). Every
-- other button stays stock. Arabic numerals stay. Red means nothing.
-- Ritual verbs call signed Core only when Sender:IsRegisteredPope(local)
-- is true. That predicate is fail-closed until the registered-Pope list (#8).
-- Toggle / Show / Hide only. No slash. No GuildPromote. No Notebook persist.
-- Favor pane is Pope-desk readout (not congregation theater). Congregation
-- display is a per-event memory toggle. Proposed bout is a stock pairing slot
-- above SANCTION plus a one-line STIPULATION box. Named petitions append a
-- mute numeric H2H when Store has history. Confession inbox is a stock list
-- on this desk only — never theater. Rows click-select the character; a
-- called row appends mute "  called". Dismiss is stock furniture, not a ritual
-- plate. Console:Dismiss reaches Gora:Dismiss and, when Confession.Dismiss
-- exists, that inbox too (same id). Successful Dismiss (ok true, including
-- Confession-only) nils selectedCharacterId before Refresh so leftover
-- CallForward / DeclareVictor cannot fire on a dismissed petitioner.
-- If the dismissed id is selectedFighterA or selectedFighterB, also nils
-- the pair and lastRecommendation before Refresh so leftover
-- FlagFamousUpset / Sanction cannot fire on a leftover fighter.
-- Dismiss of a third id keeps the pair. Failed Dismiss keeps the pick
-- and the pair. Does not nil selectedHumanId.
-- Isolated Gora-only Dismiss stays when Confession is nil. Knighting line
-- is a stock list plus Enqueue / Skip furniture.
-- Recommend proposes a pair and never Sanctions. lastRecommendation
-- and the selected fighter pair clear on successful StartEvent / EndEvent
-- (before after() Refresh); successful EndEvent also nils selectedHumanId
-- and selectedCharacterId so leftover CallForward / Dismiss /
-- KnightThisBeef cannot fire on a dead pick. Successful StartEvent
-- does not nil human / character — Quiet pick then Start then
-- OpenRite / KnightThisBeef must keep. Failed Start / failed End /
-- Continue keep the table, the pair, and the pick. Refresh in QUIET
-- (or when Runtime state is nil) nils lastRecommendation before
-- paintRecommendation; it does not nil the selected pair or the pick.
-- A selected pair does not inherit Core namedOpponent onto
-- lastRecommendation.
-- CallForward marks the inbox
-- only — no Toasts, chat, or Sound. FlagMoment may read GetSubZoneText when
-- location is omitted. GRANT HONORIFIC writes Store:AddHonorific (Pope-authored
-- plain text; empty and embedded newline refuse). Recognition Begin / Complete /
-- Cancel pass confirmer "pope" only — no Council button, no self-service, no
-- UnitName bind, no auto-Complete on the 30s metadata duration. Archive export
-- fills ArchiveBox and pcalls CopyToClipboard with that blob only when the Os
-- API exists. Import Check-then-Import; bad blob refuses and does not wipe.
-- CanonizeMoment writes Store scripture (latest marked moment / box text when
-- omitted). FlagFamousUpset writes Store from the proposed bout (victor =
-- selected character if set, else fighterA) and never computes an upset. No
-- Sound, Toasts, or SendChatMessage on those three. ArchiveBox is type-guarded
-- SetMultiLine(true) and taller than one line when the Anniversary API exists.
-- Stock GameFontNormal ARCHIVE / CANONIZE labels sit by those boxes. No
-- post-show ceremony summary. SaveNote stays nil. Post Decree writes Core
-- (Decree:Set); BeefNet broadcast is bootstrap glue. Law 6: Decree is Quiet;
-- Sound is not played. CeremonyLog is a stock scroll of Store ceremony rows,
-- newest first: type token, type-routed names, optional Pope text. Knighting /
-- Elevation use GetHuman; Gora rulings use GetCharacter; Recognition is
-- character then human. Missing Store log is an empty list. No generated
-- knighting prose.
-- Layout: two-column stock desk, large targets. Outer frame height 780 with
-- a stock ScrollFrame around the desk body (child stays tall). Type-guarded
-- EnableMouseWheel + OnMouseWheel steps 36px; missing scroll APIs no-op.
-- stockEdit type-guards OnEscapePressed to ClearFocus; the box does not Hide
-- the desk. Missing SetScript / ClearFocus no-op. Named desk is on
-- UISpecialFrames via rememberSpecial (dedupe). Init / Show /
-- Refresh / Hide remount rememberSpecial when the frame already exists.
-- Refresh remounts a missing OnHide before rememberSpecial.
-- Hide remounts a missing OnHide before rememberSpecial then
-- frame:Hide(). OnHide remounts rememberSpecial so ESC still
-- re-lists. Do not reset selection / pair / Recommend. No
-- panel whoosh on show / hide / ESC. Do not register scroll children.
-- No permanent OnUpdate. Open Gora subjects use the selected pair when both
-- ids are set, else live Gora:GetSanctioned() only. Does not fall back to
-- GetLastSanctioned (leftover last pair is persist, not the next rite).
-- Open Knighting subjects use selectedHumanId, else the head of
-- Knighting:GetLine() when that humanId is an id. Scrollable Presence /
-- Gora / Confession / Line / CeremonyLog lists, click-to-select. Presence
-- fail-opens Store names (here = false) until Roster is complete. After
-- paintRowButtons, here == false rows use stock SetAlpha(0.45); here
-- rows stay 1. Leftover acquireRows Hide resets SetAlpha(1) so a dim
-- leftover does not keep 0.45. No mute suffix. Petitions / confessions
-- / knighting are not dimmed. Not parchment. Not collapsible tabs
-- (desks stay glanceable without window switching).
local Console = {
  MODE = "event",
}
COB.Console = Console

local FRAME_NAME = "ChurchOfBeefConsoleFrame"
local REFUSE = "not the registered pope"
local DEFAULT_WIDTH, DEFAULT_HEIGHT = 780, 780
local DESK_CHILD_H = 1050
local BTN_W, BTN_H, BTN_GAP = 172, 28, 8
local COL_W, COL_GAP = 370, 12
local ROW_H = 20
local DESK_H = 400
local GORA_VERB_Y = 222
local congregationFavorVisible = true
local lastSeenEventId
local lastRecommendation
local DECREE_HEADER = "A GATHERING HAS BEEN DECREED"
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

local function trimText(text)
  if COB.Names and COB.Names.Trim then
    return COB.Names.Trim(text)
  end
  if type(text) ~= "string" then return nil end
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then return nil end
  return text
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
  db.console = { point = point, relativePoint = relativePoint or point, x = x, y = y }
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

local function header(parent, text)
  local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fs:SetText(text)
  fs:SetJustifyH("LEFT")
  return fs
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

-- Iron plates: Theme plate paths as button textures. SANCTION BEEF GORA
-- and KNIGHT THIS BEEF only. Missing Theme leaves stock chrome.
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
  box:SetWidth(width or 520)
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

local function panel(parent)
  local box = CreateFrame("Frame", nil, parent)
  local bg = box:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(box)
  bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
  -- Desk ground: charcoal (deeper ground), not iron chrome.
  local r, g, b = themeColor("charcoal")
  if bg.SetVertexColor and type(r) == "number" then
    bg:SetVertexColor(r, g, b, 1)
    bg._cobColor = { r = r, g = g, b = b, a = 1, role = "charcoal" }
  end
  box.Bg = bg
  return box
end

local function scrollList(parent, name, width, height)
  local scroll = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
  scroll:SetWidth(width)
  scroll:SetHeight(height)
  local child = CreateFrame("Frame", nil, scroll)
  child:SetWidth(width - 22)
  child:SetHeight(height)
  scroll:SetScrollChild(child)
  local fs = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  fs:SetPoint("TOPLEFT", child, "TOPLEFT", 2, -2)
  fs:SetWidth(width - 26)
  fs:SetJustifyH("LEFT")
  fs:SetJustifyV("TOP")
  fs:SetText("")
  return scroll, child, fs
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

local function presenceLine(row)
  local line = row.name or ""
  if row.rankTitle then
    line = line .. "  " .. row.rankTitle
  end
  if row.needsKnighting then
    line = line .. "  needs Knighting"
  end
  return line
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
  local left = characterName(row.characterId) or tostring(row.characterId)
  if row.namedOpponentId ~= nil then
    local right = characterName(row.namedOpponentId) or tostring(row.namedOpponentId)
    local line = left .. "  names  " .. right
    local score = h2hScore(row.characterId, row.namedOpponentId)
    if score then
      line = line .. "  " .. score
    end
    return line
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

local function suggestionLabel(fighterA, fighterB)
  local nameA = characterName(fighterA)
  local nameB = characterName(fighterB)
  if not nameA or not nameB then return "" end
  local line = nameA .. " vs " .. nameB
  local score = h2hScore(fighterA, fighterB)
  if score then
    line = line .. "  " .. score
  end
  return line
end

local function confessionLine(row)
  local name = characterName(row.characterId)
  if type(name) ~= "string" or name == "" then
    if type(row.name) == "string" and row.name ~= "" then
      name = row.name
    elseif row.characterId ~= nil then
      name = tostring(row.characterId)
    else
      name = ""
    end
  end
  local line
  local text = row.text
  if type(text) == "string" and text ~= "" then
    if name ~= "" then
      line = name .. "  " .. text
    else
      line = text
    end
  else
    line = name
  end
  if row.called == true then
    line = line .. "  called"
  end
  return line
end

local function participantName(id, kind, index)
  if not isId(id) then return nil end
  local Store = COB.Store
  if type(Store) ~= "table" then return nil end
  local humanName
  if type(Store.GetHuman) == "function" then
    local human = Store:GetHuman(id)
    if type(human) == "table" and type(human.name) == "string" and human.name ~= "" then
      humanName = human.name
    end
  end
  local charName
  if type(Store.GetCharacter) == "function" then
    local ch = Store:GetCharacter(id)
    if type(ch) == "table" and type(ch.name) == "string" and ch.name ~= "" then
      charName = ch.name
    end
  end
  if kind == "Knighting" or kind == "Elevation" then
    return humanName
  end
  if kind == "victor" or kind == "cowardice" or kind == "void"
      or kind == "free" or kind == "Gora" then
    return charName
  end
  if kind == "Recognition" then
    if index == 1 then
      return charName
    end
    return humanName
  end
  return charName or humanName
end

local function ceremonyLine(row)
  local parts = {}
  local kind = row.type
  if type(kind) == "string" and kind ~= "" then
    parts[#parts + 1] = kind
  end
  local ids = row.participantIds
  if type(ids) == "table" then
    for i = 1, #ids do
      local name = participantName(ids[i], kind, i)
      if name then
        parts[#parts + 1] = name
      end
    end
  end
  local text = row.text
  if type(text) == "string" and text ~= "" then
    parts[#parts + 1] = text
  end
  return table.concat(parts, "  ")
end

local function acquireRows(pool, parent, count, width)
  pool = pool or {}
  for i = 1, count do
    local btn = pool[i]
    if not btn then
      btn = CreateFrame("Button", nil, parent)
      btn:SetHeight(ROW_H)
      local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      fs:SetPoint("LEFT", btn, "LEFT", 4, 0)
      fs:SetJustifyH("LEFT")
      btn:SetFontString(fs)
      btn.Label = fs
      pool[i] = btn
    end
    btn:SetWidth(width)
    if btn.Label then btn.Label:SetWidth(width - 8) end
    btn:ClearAllPoints()
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -((i - 1) * ROW_H))
    btn:Show()
  end
  for i = count + 1, #pool do
    local leftover = pool[i]
    leftover:Hide()
    if leftover.SetAlpha then
      leftover:SetAlpha(1)
    end
  end
  return pool
end

local function paintRowButtons(pool, parent, rows, lineOf, selectedOf, onClick)
  local width = (parent.GetWidth and parent:GetWidth()) or 300
  pool = acquireRows(pool, parent, #rows, width - 4)
  for i = 1, #rows do
    local row = rows[i]
    local btn = pool[i]
    local label = lineOf(row)
    if selectedOf(row) then
      label = "> " .. label
    end
    btn:SetText(label)
    if btn.Label then btn.Label:SetText(label) end
    btn._row = row
    btn:SetScript("OnClick", onClick)
  end
  parent:SetHeight(math.max(80, #rows * ROW_H + 4))
  return pool
end

local function placeRow(parent, y, buttons)
  for i = 1, #buttons do
    buttons[i]:SetPoint("TOPLEFT", parent, "TOPLEFT", (i - 1) * (BTN_W + BTN_GAP), -y)
  end
  return y + BTN_H + BTN_GAP
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

-- ESC Hide via UISpecialFrames bypasses Console:Hide. Restore a
-- missing OnHide; never replace an existing script. Remount
-- rememberSpecial so ESC still re-lists. Do not reset selection /
-- pair / Recommend. Do not wire OnShow.
local function wireConsoleOnHide(widget)
  if not widget then return end
  if type(widget.SetScript) ~= "function" then return end
  local existing = type(widget.GetScript) == "function" and widget:GetScript("OnHide")
  if existing then return end
  widget:SetScript("OnHide", function()
    rememberSpecial(FRAME_NAME)
  end)
end

local function buildFrame()
  local frame = CreateFrame("Frame", FRAME_NAME, UIParent, "BasicFrameTemplate")
  frame:SetFrameStrata("MEDIUM")
  frame:SetToplevel(true)
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:SetWidth(DEFAULT_WIDTH)
  frame:SetHeight(DEFAULT_HEIGHT)
  restorePoint(frame)
  frame:Hide()

  -- After the initial Hide so create does not fire OnHide remount.
  wireConsoleOnHide(frame)

  frame.RitualButtons = {}

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

  local deskScroll = CreateFrame("ScrollFrame", FRAME_NAME .. "DeskScroll", frame, "UIPanelScrollFrameTemplate")
  deskScroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -30)
  deskScroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 12)
  local content = CreateFrame("Frame", nil, deskScroll)
  content:SetWidth(DEFAULT_WIDTH - 28)
  content:SetHeight(DESK_CHILD_H)
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

  local function ritual(label, onClick)
    local btn = stockButton(content, label, onClick)
    frame.RitualButtons[#frame.RitualButtons + 1] = btn
    return btn
  end

  frame.RuntimeState = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.RuntimeState:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
  frame.RuntimeState:SetJustifyH("LEFT")
  frame.RuntimeState:SetText("QUIET")

  frame.GateStatus = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.GateStatus:SetPoint("LEFT", frame.RuntimeState, "RIGHT", 12, 0)
  frame.GateStatus:SetJustifyH("LEFT")
  frame.GateStatus:SetText("")

  frame.SelectionStatus = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.SelectionStatus:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -16)
  frame.SelectionStatus:SetJustifyH("LEFT")
  frame.SelectionStatus:SetText("No one selected")

  local y = 34
  y = placeRow(content, y, {
    ritual("Start Event", function() Console:StartEvent() end),
    ritual("Close Rite", function() Console:CloseRite() end),
    ritual("Continue", function() Console:Continue() end),
    ritual("End Event", function() Console:EndEvent() end),
  })
  y = placeRow(content, y, {
    ritual("Open Knighting", function() Console:OpenRite("Knighting") end),
    ritual("Open Gora", function() Console:OpenRite("Gora") end),
    ritual("Open Confession", function() Console:OpenRite("Confession") end),
    ritual("Open Proclamation", function() Console:OpenRite("Proclamation") end),
  })
  y = y + 6

  local left = panel(content)
  left:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  left:SetWidth(COL_W)
  left:SetHeight(DESK_H)
  local presenceHead = header(left, "Presence")
  presenceHead:SetPoint("TOPLEFT", left, "TOPLEFT", 10, -8)
  local presenceScroll, presenceChild, presenceList = scrollList(
    left, FRAME_NAME .. "PresenceScroll", COL_W - 28, 150)
  presenceScroll:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -26)
  frame.PresenceList = presenceList
  frame.PresenceChild = presenceChild
  frame.PresenceRows = {}
  local knightHead = header(left, "Knighting")
  knightHead:SetPoint("TOPLEFT", left, "TOPLEFT", 10, -142)
  local knightScroll, knightChild, knightList = scrollList(
    left, FRAME_NAME .. "KnightingScroll", COL_W - 28, 56)
  knightScroll:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -158)
  frame.KnightingList = knightList
  frame.KnightingChild = knightChild
  frame.KnightingRows = {}
  local enqueueBtn = stockButton(left, "Enqueue", function() Console:Enqueue() end)
  enqueueBtn:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -220)
  frame.Enqueue = enqueueBtn
  local skipBtn = stockButton(left, "Skip", function() Console:Skip() end)
  skipBtn:SetPoint("TOPLEFT", left, "TOPLEFT", 8 + BTN_W + BTN_GAP, -220)
  frame.Skip = skipBtn
  local knightBtn = ritual("KNIGHT THIS BEEF", function() Console:KnightThisBeef() end)
  knightBtn:SetParent(left)
  knightBtn:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -254)
  plateVerb(knightBtn)
  frame.KnightThisBeef = knightBtn
  local lordBtn = ritual("ELEVATE TO LORD", function() Console:ElevateToLord() end)
  lordBtn:SetParent(left)
  lordBtn:SetPoint("TOPLEFT", left, "TOPLEFT", 8 + BTN_W + BTN_GAP, -254)
  local confessionHead = header(left, "Confession")
  confessionHead:SetPoint("TOPLEFT", left, "TOPLEFT", 10, -290)
  local confessionScroll, confessionChild, confessionList = scrollList(
    left, FRAME_NAME .. "ConfessionScroll", COL_W - 28, 56)
  confessionScroll:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -306)
  frame.ConfessionList = confessionList
  frame.ConfessionChild = confessionChild
  frame.ConfessionRows = {}
  local callBtn = stockButton(left, "Call Forward", function() Console:CallForward() end)
  callBtn:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -372)
  frame.CallForward = callBtn

  local right = panel(content)
  right:SetPoint("TOPLEFT", content, "TOPLEFT", COL_W + COL_GAP, -y)
  right:SetWidth(COL_W)
  right:SetHeight(DESK_H)
  local goraHead = header(right, "Gora")
  goraHead:SetPoint("TOPLEFT", right, "TOPLEFT", 10, -8)
  local favorHead = header(right, "FAVOR")
  favorHead:SetPoint("TOPLEFT", right, "TOPLEFT", 10, -26)
  frame.FavorLabel = favorHead
  frame.FavorSplit = right:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.FavorSplit:SetPoint("LEFT", favorHead, "RIGHT", 12, 0)
  frame.FavorSplit:SetJustifyH("LEFT")
  frame.FavorSplit:SetText("0 / 0")
  frame.FavorCount = right:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.FavorCount:SetPoint("LEFT", frame.FavorSplit, "RIGHT", 12, 0)
  frame.FavorCount:SetJustifyH("LEFT")
  frame.FavorCount:SetText("0")
  local congBtn, congLabel = stockCheck(right, "Congregation sees favor")
  congBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -46)
  congLabel:SetPoint("LEFT", congBtn, "RIGHT", 4, 0)
  frame.CongregationFavor = congBtn
  frame.CongregationFavorLabel = congLabel
  local petitionScroll, petitionChild, petitionList = scrollList(
    right, FRAME_NAME .. "PetitionScroll", COL_W - 28, 70)
  petitionScroll:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -70)
  frame.PetitionsList = petitionList
  frame.PetitionChild = petitionChild
  frame.PetitionRows = {}
  local boutHead = header(right, "PROPOSED BOUT")
  boutHead:SetPoint("TOPLEFT", right, "TOPLEFT", 10, -144)
  frame.ProposedBout = right:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.ProposedBout:SetPoint("LEFT", boutHead, "RIGHT", 12, 0)
  frame.ProposedBout:SetJustifyH("LEFT")
  frame.ProposedBout:SetText("")
  local stipHead = header(right, "STIPULATION")
  stipHead:SetPoint("TOPLEFT", right, "TOPLEFT", 10, -164)
  frame.Stipulation = stockEdit(right, COL_W - 130)
  frame.Stipulation:SetPoint("LEFT", stipHead, "RIGHT", 8, 0)
  local recommendBtn = stockButton(right, "Recommend", function() Console:Recommend() end)
  recommendBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -186)
  frame.Recommend = recommendBtn
  frame.Recommendation = right:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.Recommendation:SetPoint("LEFT", recommendBtn, "RIGHT", 8, 0)
  frame.Recommendation:SetJustifyH("LEFT")
  frame.Recommendation:SetText("")
  local sanctionBtn = ritual("SANCTION BEEF GORA", function() Console:Sanction() end)
  sanctionBtn:SetParent(right)
  sanctionBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -GORA_VERB_Y)
  plateVerb(sanctionBtn)
  frame.Sanction = sanctionBtn
  local dismissBtn = stockButton(right, "Dismiss", function() Console:Dismiss() end)
  dismissBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8 + BTN_W + BTN_GAP, -GORA_VERB_Y)
  frame.Dismiss = dismissBtn
  local victorBtn = ritual("DECLARE VICTOR", function() Console:DeclareVictor() end)
  victorBtn:SetParent(right)
  victorBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -GORA_VERB_Y - BTN_H - BTN_GAP)
  local cowardBtn = ritual("COWARDICE RECORDED", function() Console:CowardiceRecorded() end)
  cowardBtn:SetParent(right)
  cowardBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8 + BTN_W + BTN_GAP, -GORA_VERB_Y - BTN_H - BTN_GAP)
  local voidBtn = ritual("VOID", function() Console:Void() end)
  voidBtn:SetParent(right)
  voidBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -GORA_VERB_Y - 2 * (BTN_H + BTN_GAP))
  local freeBtn = ritual("FREE RULING", function() Console:FreeRuling() end)
  freeBtn:SetParent(right)
  freeBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8 + BTN_W + BTN_GAP, -GORA_VERB_Y - 2 * (BTN_H + BTN_GAP))
  frame.FreeRulingText = stockEdit(right, COL_W - 16)
  frame.FreeRulingText:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -GORA_VERB_Y - 3 * (BTN_H + BTN_GAP))

  y = y + DESK_H + 12
  local logHead = header(content, "CeremonyLog")
  logHead:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  frame.CeremonyLogLabel = logHead
  y = y + 16
  local logScroll, logChild, logList = scrollList(
    content, FRAME_NAME .. "CeremonyLogScroll", 746, 70)
  logScroll:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  frame.CeremonyLog = logList
  frame.CeremonyLogChild = logChild
  frame.CeremonyLogRows = {}
  y = y + 78
  local decreeHead = header(content, DECREE_HEADER)
  decreeHead:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  frame.DecreeHeader = decreeHead
  y = y + 18
  frame.DecreeLine = stockEdit(content, 560)
  frame.DecreeLine:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -y)
  local postBtn = ritual("Post Decree", function() Console:PostDecree() end)
  postBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 572, -y + 2)
  y = y + 28
  frame.DecreeFlavor = stockEdit(content, 560)
  frame.DecreeFlavor:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -y)
  local momentBtn = ritual("MARK THIS MOMENT", function() Console:FlagMoment() end)
  momentBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 572, -y + 2)
  y = y + 30

  frame.HonorificText = stockEdit(content, 560)
  frame.HonorificText:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -y)
  local honorBtn = ritual("GRANT HONORIFIC", function() Console:GrantHonorific() end)
  honorBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 572, -y + 2)
  y = y + 28
  y = placeRow(content, y, {
    ritual("Begin Recognition", function() Console:BeginRecognition() end),
    ritual("Complete Recognition", function() Console:CompleteRecognition() end),
    ritual("Cancel Recognition", function() Console:CancelRecognition() end),
  })
  frame.ArchiveLabel = header(content, "ARCHIVE")
  frame.ArchiveLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  y = y + 16
  frame.ArchiveBox = stockEdit(content, 560)
  frame.ArchiveBox:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -y)
  if type(frame.ArchiveBox.SetMultiLine) == "function" then
    frame.ArchiveBox:SetMultiLine(true)
    frame.ArchiveBox._multiline = true
    frame.ArchiveBox:SetHeight(72)
  end
  local exportBtn = ritual("EXPORT ARCHIVE", function() Console:ExportArchive() end)
  exportBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 572, -y + 2)
  y = y + 76
  y = placeRow(content, y, {
    ritual("IMPORT ARCHIVE", function() Console:ImportArchive() end),
    ritual("FLAG UPSET", function() Console:FlagFamousUpset() end),
  })
  frame.CanonizeLabel = header(content, "CANONIZE")
  frame.CanonizeLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  y = y + 16
  frame.CanonizeText = stockEdit(content, 560)
  frame.CanonizeText:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -y)
  local canonBtn = ritual("CANONIZE", function() Console:CanonizeMoment() end)
  canonBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 572, -y + 2)
  y = y + 28

  local notebook = header(content, "Notebook")
  notebook:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  frame.NotebookLabel = notebook

  rememberSpecial(FRAME_NAME)

  return frame
end

local function onPresenceClick(btn)
  local row = btn and btn._row
  if not row then return end
  Console:SelectHuman(row.humanId)
  Console:SelectCharacter(row.characterId)
  Console:Refresh()
end

local function onPetitionClick(btn)
  local row = btn and btn._row
  if not row then return end
  Console:SelectCharacter(row.characterId)
  if row.namedOpponentId ~= nil then
    Console:SelectFighters(row.characterId, row.namedOpponentId)
  end
  Console:Refresh()
end

local function onKnightingClick(btn)
  local row = btn and btn._row
  if not row then return end
  Console:SelectHuman(row.humanId)
  Console:Refresh()
end

local function onConfessionClick(btn)
  local row = btn and btn._row
  if not row then return end
  Console:SelectCharacter(row.characterId)
  Console:Refresh()
end

local function paintPresence(frame, rows)
  if not frame.PresenceList then return end
  local lines = {}
  for i = 1, #rows do
    lines[#lines + 1] = presenceLine(rows[i])
  end
  local body = table.concat(lines, "\n")
  if body == "" then body = "No one on the roster yet." end
  frame.PresenceList:SetText(body)
  if #rows == 0 then
    frame.PresenceList:Show()
    if frame.PresenceChild then
      frame.PresenceRows = acquireRows(frame.PresenceRows, frame.PresenceChild, 0, 100)
      frame.PresenceChild:SetHeight(80)
    end
  else
    frame.PresenceList:Hide()
    if not frame.PresenceChild then return end
    frame.PresenceRows = paintRowButtons(
      frame.PresenceRows,
      frame.PresenceChild,
      rows,
      presenceLine,
      function(row)
        return (row.humanId ~= nil and row.humanId == Console.selectedHumanId)
          or (row.characterId ~= nil and row.characterId == Console.selectedCharacterId)
      end,
      onPresenceClick
    )
    for i = 1, #rows do
      local btn = frame.PresenceRows[i]
      if btn and btn.SetAlpha then
        if rows[i].here == false then
          btn:SetAlpha(0.45)
        else
          btn:SetAlpha(1)
        end
      end
    end
  end
end

local function paintPetitions(frame, petitions)
  if not frame.PetitionsList then return end
  local lines = {}
  for i = 1, #petitions do
    lines[#lines + 1] = petitionLine(petitions[i])
  end
  local body = table.concat(lines, "\n")
  if body == "" then body = "No petitions." end
  frame.PetitionsList:SetText(body)
  if #petitions == 0 then
    frame.PetitionsList:Show()
    if frame.PetitionChild then
      frame.PetitionRows = acquireRows(frame.PetitionRows, frame.PetitionChild, 0, 100)
      frame.PetitionChild:SetHeight(80)
    end
  else
    frame.PetitionsList:Hide()
    if not frame.PetitionChild then return end
    frame.PetitionRows = paintRowButtons(
      frame.PetitionRows,
      frame.PetitionChild,
      petitions,
      petitionLine,
      function(row)
        return row.characterId ~= nil and row.characterId == Console.selectedCharacterId
      end,
      onPetitionClick
    )
  end
end

local function paintRuntime(frame)
  if not frame.RuntimeState then return end
  if COB.Runtime and COB.Runtime.Snapshot then
    local snap = COB.Runtime:Snapshot()
    frame.RuntimeState:SetText((snap and snap.state) or "")
  else
    frame.RuntimeState:SetText("")
  end
end

local function paintSelection(frame, presence)
  if not frame.SelectionStatus then return end
  local name
  for i = 1, #presence do
    local row = presence[i]
    if (row.humanId ~= nil and row.humanId == Console.selectedHumanId)
        or (row.characterId ~= nil and row.characterId == Console.selectedCharacterId) then
      name = row.name
      break
    end
  end
  if not name then
    name = characterName(Console.selectedCharacterId)
  end
  if name then
    frame.SelectionStatus:SetText("Selected: " .. name)
  else
    frame.SelectionStatus:SetText("No one selected")
  end
end

local function applyGate(frame)
  local ok = isRegisteredPope()
  if frame.GateStatus then
    frame.GateStatus:SetText(ok and "" or REFUSE)
  end
  local buttons = frame.RitualButtons or {}
  for i = 1, #buttons do
    if ok then
      buttons[i]:Enable()
    else
      buttons[i]:Disable()
    end
  end
  if frame.CongregationFavor then
    if ok then
      frame.CongregationFavor:Enable()
    else
      frame.CongregationFavor:Disable()
    end
  end
end

local function currentEventId()
  if not COB.Runtime or not COB.Runtime.Snapshot then return nil end
  local snap = COB.Runtime:Snapshot()
  if type(snap) ~= "table" then return nil end
  return snap.eventId
end

local function syncCongregationToggle()
  local eventId = currentEventId()
  if eventId ~= lastSeenEventId then
    lastSeenEventId = eventId
    congregationFavorVisible = true
  end
end

local function paintFavor(frame)
  if not frame then return end
  local split = Console:GetFavorSplit()
  if frame.FavorSplit then
    frame.FavorSplit:SetText(tostring(split.a) .. " / " .. tostring(split.b))
  end
  if frame.FavorCount then
    frame.FavorCount:SetText(tostring(Console:GetFavorCount()))
  end
  if frame.CongregationFavor then
    frame.CongregationFavor:SetChecked(congregationFavorVisible)
  end
end

local function paintProposedBout(frame)
  if not frame or not frame.ProposedBout then return end
  local bout = Console:GetProposedBout()
  frame.ProposedBout:SetText(bout.label or "")
end

local function paintConfessions(frame, rows)
  if not frame or not frame.ConfessionList then return end
  local lines = {}
  for i = 1, #rows do
    lines[#lines + 1] = confessionLine(rows[i])
  end
  local body = table.concat(lines, "\n")
  if body == "" then body = "No confessions." end
  frame.ConfessionList:SetText(body)
  if #rows == 0 then
    frame.ConfessionList:Show()
    if frame.ConfessionChild then
      frame.ConfessionRows = acquireRows(frame.ConfessionRows, frame.ConfessionChild, 0, 100)
      frame.ConfessionChild:SetHeight(56)
    end
  else
    frame.ConfessionList:Hide()
    if not frame.ConfessionChild then return end
    frame.ConfessionRows = paintRowButtons(
      frame.ConfessionRows,
      frame.ConfessionChild,
      rows,
      confessionLine,
      function(row)
        return row.characterId ~= nil and row.characterId == Console.selectedCharacterId
      end,
      onConfessionClick
    )
  end
end

local function paintKnightingLine(frame, rows)
  if not frame or not frame.KnightingList then return end
  local lines = {}
  for i = 1, #rows do
    lines[#lines + 1] = knightingLine(rows[i])
  end
  local body = table.concat(lines, "\n")
  if body == "" then body = "No one in line." end
  frame.KnightingList:SetText(body)
  if #rows == 0 then
    frame.KnightingList:Show()
    if frame.KnightingChild then
      frame.KnightingRows = acquireRows(frame.KnightingRows, frame.KnightingChild, 0, 100)
      frame.KnightingChild:SetHeight(56)
    end
  else
    frame.KnightingList:Hide()
    if not frame.KnightingChild then return end
    frame.KnightingRows = paintRowButtons(
      frame.KnightingRows,
      frame.KnightingChild,
      rows,
      knightingLine,
      function(row)
        return row.humanId ~= nil and row.humanId == Console.selectedHumanId
      end,
      onKnightingClick
    )
  end
end

local function paintRecommendation(frame)
  if not frame or not frame.Recommendation then return end
  local rec = lastRecommendation
  local label = ""
  if type(rec) == "table" and isId(rec.fighterA) and isId(rec.fighterB) then
    label = suggestionLabel(rec.fighterA, rec.fighterB)
    if rec.namedOpponent == true then
      label = label .. "  names  "
    end
  end
  frame.Recommendation:SetText(label)
end

local function paintCeremonyLog(frame, rows)
  if not frame or not frame.CeremonyLog then return end
  local lines = {}
  for i = 1, #rows do
    lines[#lines + 1] = ceremonyLine(rows[i])
  end
  local body = table.concat(lines, "\n")
  if body == "" then body = "No ceremony yet." end
  frame.CeremonyLog:SetText(body)
  if frame.CeremonyLogChild then
    frame.CeremonyLogChild:SetHeight(math.max(70, #rows * ROW_H + 4))
  end
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
  local presence = self:GetPresence()
  paintRuntime(self.frame)
  paintPresence(self.frame, presence)
  paintPetitions(self.frame, self:GetPetitions())
  paintSelection(self.frame, presence)
  paintFavor(self.frame)
  paintProposedBout(self.frame)
  paintConfessions(self.frame, self:GetConfessions())
  paintKnightingLine(self.frame, self:GetKnightingLine())
  local state
  if COB.Runtime and COB.Runtime.Snapshot then
    local snap = COB.Runtime:Snapshot()
    if type(snap) == "table" then
      state = snap.state
    end
  end
  if state == nil or state == "QUIET" then
    lastRecommendation = nil
  end
  paintRecommendation(self.frame)
  paintCeremonyLog(self.frame, self:GetCeremonyLog())
  applyGate(self.frame)
end

function Console:Show()
  if not self.frame then self:Init() end
  if not self.frame then return end
  rememberSpecial(FRAME_NAME)
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
  if not self.frame then self:Init() end
  if not self.frame then return end
  if self.frame:IsShown() then self:Hide() else self:Show() end
end

function Console:ResetForTests()
  if not COB._IN_TEST then return false end
  self.selectedHumanId = nil
  self.selectedCharacterId = nil
  self.selectedFighterA = nil
  self.selectedFighterB = nil
  congregationFavorVisible = true
  lastSeenEventId = currentEventId()
  lastRecommendation = nil
  if self.frame then
    if self.frame.CongregationFavor then
      self.frame.CongregationFavor:SetChecked(true)
    end
    self:Hide()
  end
  return true
end

--------------------------------------------------------------------------------
-- Presence / petitions (display)
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
      local rankId = human and human.rankId or nil
      local needs = false
      if human then
        needs = rankId == nil or rankId == 1 or rankId == 2
      end
      rows[#rows + 1] = {
        name = member.name,
        here = true,
        guildRankIndex = member.guildRankIndex,
        rankId = rankId,
        rankTitle = rankTitle(rankId),
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
        local rankId = human and human.rankId or nil
        local needs = false
        if human then
          needs = rankId == nil or rankId == 1 or rankId == 2
        end
        rows[#rows + 1] = {
          name = ch.name,
          here = false,
          guildRankIndex = nil,
          rankId = rankId,
          rankTitle = rankTitle(rankId),
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

function Console:GetConfessions()
  local Confession = COB.Confession
  if type(Confession) ~= "table" or type(Confession.GetQueue) ~= "function" then
    return {}
  end
  local queue = Confession:GetQueue()
  if type(queue) ~= "table" then return {} end
  local out = {}
  for i = 1, #queue do
    local row = queue[i]
    if type(row) == "table" then
      local copy = {}
      for k, v in pairs(row) do
        copy[k] = v
      end
      out[#out + 1] = copy
    end
  end
  return out
end

function Console:GetCeremonyLog()
  if not COB.Store or type(COB.Store.GetCeremonyLog) ~= "function" then
    return {}
  end
  local log = COB.Store:GetCeremonyLog()
  if type(log) ~= "table" then return {} end
  local out = {}
  for i = #log, 1, -1 do
    local row = log[i]
    if type(row) == "table" then
      local copy = {}
      for k, v in pairs(row) do
        copy[k] = v
      end
      out[#out + 1] = copy
    end
  end
  return out
end

function Console:SelectHuman(humanId)
  if humanId ~= nil and not isId(humanId) then return nil, "invalid human id" end
  self.selectedHumanId = humanId
  return true
end

function Console:SelectCharacter(characterId)
  if characterId ~= nil and not isId(characterId) then return nil, "invalid character id" end
  self.selectedCharacterId = characterId
  return true
end

function Console:SelectFighters(fighterA, fighterB)
  self.selectedFighterA = fighterA
  self.selectedFighterB = fighterB
  return true
end

function Console:GetProposedBout()
  local a, b = self.selectedFighterA, self.selectedFighterB
  local out = { label = "" }
  if isId(a) then out.fighterA = a end
  if isId(b) then out.fighterB = b end
  if out.fighterA and out.fighterB then
    local nameA = characterName(out.fighterA)
    local nameB = characterName(out.fighterB)
    if nameA and nameB then
      out.label = nameA .. " vs " .. nameB
    end
  end
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

function Console:SetCongregationFavorVisible(flag)
  if type(flag) ~= "boolean" then
    return nil, "flag must be a boolean"
  end
  congregationFavorVisible = flag
  if self.frame and self.frame.CongregationFavor then
    self.frame.CongregationFavor:SetChecked(flag)
  end
  return true
end

--------------------------------------------------------------------------------
-- Ritual verbs — fail closed unless the local sender is a registered Pope
--------------------------------------------------------------------------------

-- Theater owns §19.4 cues when Toasts.Proclaim exists (live client).
-- Isolated suite does not load Toasts — Sound:Play stays for harness pins.
-- Do not call Proclaim from this desk.
local function playCue(name)
  local Toasts = COB.Toasts
  if type(Toasts) == "table" and type(Toasts.Proclaim) == "function" then
    return
  end
  local Sound = COB.Sound
  if type(Sound) ~= "table" or type(Sound.Play) ~= "function" then
    return
  end
  pcall(Sound.Play, Sound, name)
end

local function refreshHud()
  local Hud = COB.Hud
  if type(Hud) ~= "table" or type(Hud.Refresh) ~= "function" then
    return
  end
  pcall(Hud.Refresh, Hud)
end

local function showDecreeBanner()
  local banner = COB.DecreeBanner
  if type(banner) ~= "table" or type(banner.Show) ~= "function" then
    return
  end
  pcall(banner.Show, banner)
end

-- Integrator (bootstrap) broadcasts on Core writes. Do not call Net here.
local function after(self, result, err, cue, wantHud)
  if result ~= nil then
    self:Refresh()
    if cue then playCue(cue) end
    if wantHud then refreshHud() end
  end
  return result, err
end

local function decreeFields(self, fields)
  if type(fields) == "table" then return fields end
  local frame = self.frame
  if not frame then return {} end
  local line = frame.DecreeLine and frame.DecreeLine.GetText and frame.DecreeLine:GetText() or nil
  local flavor = frame.DecreeFlavor and frame.DecreeFlavor.GetText and frame.DecreeFlavor:GetText() or nil
  return { line = line, flavor = flavor }
end

function Console:StartEvent()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.StartEvent then
    return nil, "runtime is not available"
  end
  local result, err = COB.Runtime:StartEvent()
  if result ~= nil then
    lastRecommendation = nil
    self.selectedFighterA = nil
    self.selectedFighterB = nil
  end
  return after(self, result, err)
end

function Console:OpenRite(kind)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.OpenRite then
    return nil, "runtime is not available"
  end
  local subjects = nil
  if kind == "Knighting" then
    local candidate = self.selectedHumanId
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
  return after(self, result, err)
end

function Console:EndEvent()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.EndEvent then
    return nil, "runtime is not available"
  end
  local result, err = COB.Runtime:EndEvent()
  if result ~= nil then
    lastRecommendation = nil
    self.selectedFighterA = nil
    self.selectedFighterB = nil
    self.selectedHumanId = nil
    self.selectedCharacterId = nil
  end
  return after(self, result, err, nil, true)
end

function Console:KnightThisBeef(humanId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Knighting or not COB.Knighting.KnightThisBeef then
    return nil, "knighting is not available"
  end
  local result, err = COB.Knighting:KnightThisBeef(humanId or self.selectedHumanId)
  return after(self, result, err, "knighting")
end

function Console:ElevateToLord(humanId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Knighting or not COB.Knighting.ElevateToLord then
    return nil, "knighting is not available"
  end
  local result, err = COB.Knighting:ElevateToLord(humanId or self.selectedHumanId)
  return after(self, result, err, "elevation")
end

function Console:Enqueue(humanId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Knighting or type(COB.Knighting.Enqueue) ~= "function" then
    return nil, "knighting is not available"
  end
  local result, err = COB.Knighting:Enqueue(humanId or self.selectedHumanId)
  return after(self, result, err)
end

function Console:Skip(humanId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Knighting or type(COB.Knighting.Skip) ~= "function" then
    return nil, "knighting is not available"
  end
  local result, err = COB.Knighting:Skip(humanId or self.selectedHumanId)
  return after(self, result, err)
end

local function recommendPair(self)
  local a, b = self.selectedFighterA, self.selectedFighterB
  if isId(a) and isId(b) and a ~= b then
    return a, b
  end
  local petitions = self:GetPetitions()
  for i = 1, #petitions do
    local row = petitions[i]
    if isId(row.characterId) and isId(row.namedOpponentId) and row.characterId ~= row.namedOpponentId then
      return row.characterId, row.namedOpponentId
    end
  end
  if #petitions >= 2 and isId(petitions[1].characterId) and isId(petitions[2].characterId)
      and petitions[1].characterId ~= petitions[2].characterId then
    return petitions[1].characterId, petitions[2].characterId
  end
  return nil, nil
end

function Console:Recommend(fighterA, fighterB)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or type(COB.Gora.Recommend) ~= "function" then
    return nil, "gora is not available"
  end
  local hadSelected = isId(self.selectedFighterA) and isId(self.selectedFighterB)
    and self.selectedFighterA ~= self.selectedFighterB
  local a, b = fighterA, fighterB
  if not isId(a) or not isId(b) then
    a, b = recommendPair(self)
  end
  if not isId(a) or not isId(b) then
    return nil, "a Gora needs two different combatants"
  end
  local result, err = COB.Gora:Recommend(a, b)
  if result ~= nil then
    self:SelectFighters(a, b)
    lastRecommendation = {
      fighterA = a,
      fighterB = b,
      namedOpponent = (not hadSelected) and result.namedOpponent == true,
    }
  end
  return after(self, result, err)
end

function Console:CallForward(characterId)
  if not isRegisteredPope() then return nil, REFUSE end
  local Confession = COB.Confession
  if type(Confession) ~= "table" or type(Confession.CallForward) ~= "function" then
    return nil, "confession is not available"
  end
  local ok = Confession:CallForward(characterId or self.selectedCharacterId)
  if ok then self:Refresh() end
  return ok
end

function Console:Sanction(fighterA, fighterB, stipulation)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.Sanction then
    return nil, "gora is not available"
  end
  if stipulation == nil then
    local box = self.frame and self.frame.Stipulation
    if box and box.GetText then
      stipulation = box:GetText()
    end
  end
  local result, err = COB.Gora:Sanction(
    fighterA or self.selectedFighterA,
    fighterB or self.selectedFighterB,
    stipulation
  )
  return after(self, result, err, "sanction", true)
end

function Console:Dismiss(characterId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.Dismiss then
    return nil, "gora is not available"
  end
  local id = characterId or self.selectedCharacterId
  local ok = COB.Gora:Dismiss(id)
  if COB.Confession and type(COB.Confession.Dismiss) == "function" then
    if COB.Confession:Dismiss(id) then ok = true end
  end
  if ok then
    self.selectedCharacterId = nil
    if isId(id) and (id == self.selectedFighterA or id == self.selectedFighterB) then
      lastRecommendation = nil
      self.selectedFighterA = nil
      self.selectedFighterB = nil
    end
    self:Refresh()
  end
  return ok
end

function Console:DeclareVictor(winnerId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.DeclareVictor then
    return nil, "gora is not available"
  end
  local result, err = COB.Gora:DeclareVictor(winnerId or self.selectedCharacterId)
  return after(self, result, err, "verdict", true)
end

function Console:CowardiceRecorded(fleerId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.CowardiceRecorded then
    return nil, "gora is not available"
  end
  local result, err = COB.Gora:CowardiceRecorded(fleerId or self.selectedCharacterId)
  return after(self, result, err, "cowardice", true)
end

function Console:Void()
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.Void then
    return nil, "gora is not available"
  end
  local result, err = COB.Gora:Void()
  return after(self, result, err, "verdict", true)
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
  local result, err = COB.Gora:FreeRuling(text)
  return after(self, result, err, "verdict", true)
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
  if not COB.Decree or not COB.Decree.Set then
    return nil, "decree is not available"
  end
  -- Quiet desk verb: Core Set only. Integrator sends the wire.
  local result, err = COB.Decree:Set(decreeFields(self, fields))
  if result ~= nil then
    self:Refresh()
    showDecreeBanner()
  end
  return result, err
end

local function honorificText(self, text)
  if text == nil then
    local box = self.frame and self.frame.HonorificText
    if box and box.GetText then
      text = box:GetText()
    end
  end
  local trimmed = trimText(text)
  if not trimmed then
    return nil, "honorific text required"
  end
  if trimmed:find("\n", 1, true) then
    return nil, "honorific text must be one line"
  end
  return trimmed
end

local function wallNow()
  if COB.Clock and type(COB.Clock.Wall) == "function" then
    return COB.Clock.Wall()
  end
  if type(time) == "function" then
    return time()
  end
  return nil
end

function Console:GrantHonorific(humanId, text)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Store or type(COB.Store.AddHonorific) ~= "function" then
    return nil, "store is not available"
  end
  local title, titleErr = honorificText(self, text)
  if not title then return nil, titleErr end
  local result, err = COB.Store:AddHonorific(humanId or self.selectedHumanId, title)
  return after(self, result, err)
end

function Console:BeginRecognition(humanId, characterId)
  if not isRegisteredPope() then return nil, REFUSE end
  local Recognition = COB.Recognition
  if type(Recognition) ~= "table" or type(Recognition.Begin) ~= "function" then
    return nil, "recognition is not available"
  end
  local result, err = Recognition:Begin(
    humanId or self.selectedHumanId,
    characterId or self.selectedCharacterId,
    "pope",
    wallNow()
  )
  return after(self, result, err)
end

function Console:CompleteRecognition()
  if not isRegisteredPope() then return nil, REFUSE end
  local Recognition = COB.Recognition
  if type(Recognition) ~= "table" or type(Recognition.Complete) ~= "function" then
    return nil, "recognition is not available"
  end
  local result, err = Recognition:Complete(wallNow())
  return after(self, result, err)
end

function Console:CancelRecognition()
  if not isRegisteredPope() then return nil, REFUSE end
  local Recognition = COB.Recognition
  if type(Recognition) ~= "table" or type(Recognition.Cancel) ~= "function" then
    return nil, "recognition is not available"
  end
  local result, err = Recognition:Cancel()
  return after(self, result, err)
end

local function archiveBlob(self, blob)
  if blob ~= nil then return blob end
  local box = self.frame and self.frame.ArchiveBox
  if box and box.GetText then
    return box:GetText()
  end
  return nil
end

local function latestMomentId()
  if not COB.Store or type(COB.Store.GetMarkedMoments) ~= "function" then
    return nil
  end
  local moments = COB.Store:GetMarkedMoments()
  if type(moments) ~= "table" or #moments < 1 then return nil end
  local last = moments[#moments]
  if type(last) ~= "table" then return nil end
  return last.id
end

local function canonizeText(self, text)
  if text ~= nil then return text end
  local box = self.frame and self.frame.CanonizeText
  if box and box.GetText then
    return box:GetText()
  end
  return nil
end

function Console:ExportArchive()
  if not isRegisteredPope() then return nil, REFUSE end
  local Archive = COB.Archive
  if type(Archive) ~= "table" or type(Archive.Export) ~= "function" then
    return nil, "archive is not available"
  end
  local blob, err = Archive:Export()
  if type(blob) ~= "string" then
    return nil, err
  end
  local box = self.frame and self.frame.ArchiveBox
  if box and box.SetText then
    box:SetText(blob)
  end
  if type(CopyToClipboard) == "function" then
    pcall(CopyToClipboard, blob)
  end
  self:Refresh()
  return blob
end

function Console:ImportArchive(blob)
  if not isRegisteredPope() then return nil, REFUSE end
  local Archive = COB.Archive
  if type(Archive) ~= "table"
      or type(Archive.Check) ~= "function"
      or type(Archive.Import) ~= "function" then
    return nil, "archive is not available"
  end
  blob = archiveBlob(self, blob)
  local checked, checkErr = Archive:Check(blob)
  if not checked then
    return nil, checkErr
  end
  local result, err = Archive:Import(blob)
  return after(self, result, err)
end

function Console:CanonizeMoment(momentId, text)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Store or type(COB.Store.CanonizeMoment) ~= "function" then
    return nil, "store is not available"
  end
  if momentId == nil then
    momentId = latestMomentId()
  end
  local result, err = COB.Store:CanonizeMoment(momentId, canonizeText(self, text))
  return after(self, result, err)
end

function Console:FlagFamousUpset(characterId, opponentId)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Store or type(COB.Store.FlagFamousUpset) ~= "function" then
    return nil, "store is not available"
  end
  local a, b = self.selectedFighterA, self.selectedFighterB
  if not isId(a) then a = nil end
  if not isId(b) then b = nil end
  if characterId == nil then
    if isId(self.selectedCharacterId) then
      characterId = self.selectedCharacterId
    else
      characterId = a
    end
  end
  if opponentId == nil then
    if characterId == a and isId(b) then
      opponentId = b
    elseif characterId == b and isId(a) then
      opponentId = a
    end
  end
  local result, err = COB.Store:FlagFamousUpset(characterId, opponentId)
  return after(self, result, err)
end
