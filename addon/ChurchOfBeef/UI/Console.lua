ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Director Console (Bible §18.1–18.3, §20.2). Mode: Event Mode Pope working
-- tool. Not Quiet congregation chrome. Not theatrical parchment.
-- Law 10 functional / stock templates. The UI never tells jokes.
-- Ritual verbs call signed Core only when Sender:IsRegisteredPope(local)
-- is true. That predicate is fail-closed until the registered-Pope list (#8).
-- Toggle / Show / Hide only. No slash. No GuildPromote. No Notebook persist.
-- No favor / INPUT. Post Decree is a Quiet desk verb on this Event tool
-- (Law 6: Decree is Quiet; Sound is not played). No Decree wire kind.
-- Layout: two-column stock desk, large targets, scrollable Presence / Gora
-- lists, click-to-select. Not parchment. Not collapsible tabs (desks stay
-- glanceable without window switching).
local Console = {
  MODE = "event",
}
COB.Console = Console

local FRAME_NAME = "ChurchOfBeefConsoleFrame"
local REFUSE = "not the registered pope"
local DEFAULT_WIDTH, DEFAULT_HEIGHT = 780, 580
local BTN_W, BTN_H, BTN_GAP = 172, 28, 8
local COL_W, COL_GAP = 370, 12
local ROW_H = 20
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

local function stockEdit(parent, width)
  local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
  box:SetWidth(width or 520)
  box:SetHeight(22)
  box:SetAutoFocus(false)
  return box
end

local function panel(parent)
  local box = CreateFrame("Frame", nil, parent)
  local bg = box:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(box)
  bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
  if bg.SetVertexColor then
    bg:SetVertexColor(0.08, 0.08, 0.08, 1)
  end
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

local function petitionLine(row)
  local left = characterName(row.characterId) or tostring(row.characterId)
  if row.namedOpponentId ~= nil then
    local right = characterName(row.namedOpponentId) or tostring(row.namedOpponentId)
    return left .. "  names  " .. right
  end
  return left
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
    pool[i]:Hide()
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

  local close = frame.CloseButton
  if close then
    if close.HookScript then
      close:HookScript("OnClick", function() Console:Hide() end)
    else
      close:SetScript("OnClick", function() Console:Hide() end)
    end
  end

  local content = CreateFrame("Frame", nil, frame)
  content:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -30)
  content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, 12)
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
  left:SetHeight(248)
  local presenceHead = header(left, "Presence")
  presenceHead:SetPoint("TOPLEFT", left, "TOPLEFT", 10, -8)
  local presenceScroll, presenceChild, presenceList = scrollList(
    left, FRAME_NAME .. "PresenceScroll", COL_W - 28, 150)
  presenceScroll:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -26)
  frame.PresenceList = presenceList
  frame.PresenceChild = presenceChild
  frame.PresenceRows = {}
  local knightHead = header(left, "Knighting")
  knightHead:SetPoint("TOPLEFT", left, "TOPLEFT", 10, -182)
  local knightBtn = ritual("KNIGHT THIS BEEF", function() Console:KnightThisBeef() end)
  knightBtn:SetParent(left)
  knightBtn:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -202)
  local lordBtn = ritual("ELEVATE TO LORD", function() Console:ElevateToLord() end)
  lordBtn:SetParent(left)
  lordBtn:SetPoint("TOPLEFT", left, "TOPLEFT", 8 + BTN_W + BTN_GAP, -202)

  local right = panel(content)
  right:SetPoint("TOPLEFT", content, "TOPLEFT", COL_W + COL_GAP, -y)
  right:SetWidth(COL_W)
  right:SetHeight(248)
  local goraHead = header(right, "Gora")
  goraHead:SetPoint("TOPLEFT", right, "TOPLEFT", 10, -8)
  local petitionScroll, petitionChild, petitionList = scrollList(
    right, FRAME_NAME .. "PetitionScroll", COL_W - 28, 92)
  petitionScroll:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -26)
  frame.PetitionsList = petitionList
  frame.PetitionChild = petitionChild
  frame.PetitionRows = {}
  local sanctionBtn = ritual("SANCTION BEEF GORA", function() Console:Sanction() end)
  sanctionBtn:SetParent(right)
  sanctionBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -124)
  local dismissBtn = ritual("Dismiss", function() Console:Dismiss() end)
  dismissBtn:SetParent(right)
  dismissBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8 + BTN_W + BTN_GAP, -124)
  local victorBtn = ritual("DECLARE VICTOR", function() Console:DeclareVictor() end)
  victorBtn:SetParent(right)
  victorBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -124 - BTN_H - BTN_GAP)
  local cowardBtn = ritual("COWARDICE RECORDED", function() Console:CowardiceRecorded() end)
  cowardBtn:SetParent(right)
  cowardBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8 + BTN_W + BTN_GAP, -124 - BTN_H - BTN_GAP)
  local voidBtn = ritual("VOID", function() Console:Void() end)
  voidBtn:SetParent(right)
  voidBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8, -124 - 2 * (BTN_H + BTN_GAP))
  local freeBtn = ritual("FREE RULING", function() Console:FreeRuling() end)
  freeBtn:SetParent(right)
  freeBtn:SetPoint("TOPLEFT", right, "TOPLEFT", 8 + BTN_W + BTN_GAP, -124 - 2 * (BTN_H + BTN_GAP))

  y = y + 260
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

  local notebook = header(content, "Notebook")
  notebook:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  frame.NotebookLabel = notebook

  if type(UISpecialFrames) == "table" then
    table.insert(UISpecialFrames, FRAME_NAME)
  end

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
  end
end

local function paintPetitions(frame, petitions)
  if not frame.PetitionsList then return end
  local lines = {}
  for i = 1, #petitions do
    local row = petitions[i]
    lines[#lines + 1] = tostring(row.characterId)
      .. (row.namedOpponentId ~= nil and ("  names  " .. tostring(row.namedOpponentId)) or "")
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
end

--------------------------------------------------------------------------------
-- Lifecycle
--------------------------------------------------------------------------------

function Console:Init()
  if self.frame then return self.frame end
  if type(CreateFrame) ~= "function" then return nil end
  self.frame = buildFrame()
  return self.frame
end

function Console:Refresh()
  if not self.frame then return end
  local presence = self:GetPresence()
  paintRuntime(self.frame)
  paintPresence(self.frame, presence)
  paintPetitions(self.frame, self:GetPetitions())
  paintSelection(self.frame, presence)
  applyGate(self.frame)
end

function Console:Show()
  if not self.frame then self:Init() end
  if not self.frame then return end
  self.frame:Show()
  self:Refresh()
end

function Console:Hide()
  if not self.frame then return end
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
  if self.frame then self:Hide() end
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

--------------------------------------------------------------------------------
-- Ritual verbs — fail closed unless the local sender is a registered Pope
--------------------------------------------------------------------------------

local function playCue(name)
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
  return after(self, result, err)
end

function Console:OpenRite(kind)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Runtime or not COB.Runtime.OpenRite then
    return nil, "runtime is not available"
  end
  local subjects = nil
  if kind == "Knighting" and isId(self.selectedHumanId) then
    subjects = { candidate = self.selectedHumanId }
  elseif kind == "Gora" then
    local a, b = self.selectedFighterA, self.selectedFighterB
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

function Console:Sanction(fighterA, fighterB, stipulation)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Gora or not COB.Gora.Sanction then
    return nil, "gora is not available"
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
  local ok = COB.Gora:Dismiss(characterId or self.selectedCharacterId)
  if ok then self:Refresh() end
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
  local result, err = COB.Gora:FreeRuling(text)
  return after(self, result, err, "verdict", true)
end

function Console:FlagMoment(location, now)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Store or not COB.Store.FlagMoment then
    return nil, "store is not available"
  end
  local result, err = COB.Store:FlagMoment(location, now)
  return after(self, result, err)
end

function Console:PostDecree(fields)
  if not isRegisteredPope() then return nil, REFUSE end
  if not COB.Decree or not COB.Decree.Set then
    return nil, "decree is not available"
  end
  local result, err = COB.Decree:Set(decreeFields(self, fields))
  if result ~= nil then
    self:Refresh()
    showDecreeBanner()
  end
  return result, err
end
