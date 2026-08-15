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
local Console = {
  MODE = "event",
}
COB.Console = Console

local FRAME_NAME = "ChurchOfBeefConsoleFrame"
local REFUSE = "not the registered pope"
local DEFAULT_WIDTH, DEFAULT_HEIGHT = 560, 720
local DECREE_HEADER = "A GATHERING HAS BEEN DECREED"

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

local function header(parent, text)
  local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fs:SetText(text)
  fs:SetJustifyH("LEFT")
  return fs
end

local function stockButton(parent, label, onClick)
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btn:SetWidth(150)
  btn:SetHeight(22)
  btn:SetText(label)
  btn:SetScript("OnClick", onClick)
  return btn
end

local function stockEdit(parent, width)
  local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
  box:SetWidth(width or 520)
  box:SetHeight(20)
  box:SetAutoFocus(false)
  return box
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
  frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  frame:Hide()

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
  titleBar:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
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
  content:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -30)
  content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -12, 12)
  frame.Content = content

  local y = 0
  local function place(widget, x, height)
    widget:SetPoint("TOPLEFT", content, "TOPLEFT", x or 0, -y)
    y = y + (height or 18) + 4
  end

  frame.RuntimeState = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.RuntimeState:SetJustifyH("LEFT")
  frame.RuntimeState:SetText("QUIET")
  place(frame.RuntimeState, 0, 16)

  local startBtn = stockButton(content, "Start Event", function() Console:StartEvent() end)
  startBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  local closeRiteBtn = stockButton(content, "Close Rite", function() Console:CloseRite() end)
  closeRiteBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 154, -y)
  local continueBtn = stockButton(content, "Continue", function() Console:Continue() end)
  continueBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 308, -y)
  local endBtn = stockButton(content, "End Event", function() Console:EndEvent() end)
  endBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(y + 26))
  y = y + 52

  local openK = stockButton(content, "Open Knighting", function() Console:OpenRite("Knighting") end)
  openK:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  local openG = stockButton(content, "Open Gora", function() Console:OpenRite("Gora") end)
  openG:SetPoint("TOPLEFT", content, "TOPLEFT", 154, -y)
  local openC = stockButton(content, "Open Confession", function() Console:OpenRite("Confession") end)
  openC:SetPoint("TOPLEFT", content, "TOPLEFT", 308, -y)
  local openP = stockButton(content, "Open Proclamation", function() Console:OpenRite("Proclamation") end)
  openP:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(y + 26))
  y = y + 52

  local presenceHead = header(content, "Presence")
  place(presenceHead, 0, 16)
  frame.PresenceList = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.PresenceList:SetJustifyH("LEFT")
  frame.PresenceList:SetJustifyV("TOP")
  frame.PresenceList:SetWidth(520)
  frame.PresenceList:SetText("")
  place(frame.PresenceList, 0, 72)

  local knightHead = header(content, "Knighting")
  place(knightHead, 0, 16)
  local knightBtn = stockButton(content, "KNIGHT THIS BEEF", function()
    Console:KnightThisBeef()
  end)
  knightBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  local lordBtn = stockButton(content, "ELEVATE TO LORD", function()
    Console:ElevateToLord()
  end)
  lordBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 154, -y)
  y = y + 30

  local goraHead = header(content, "Gora")
  place(goraHead, 0, 16)
  frame.PetitionsList = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.PetitionsList:SetJustifyH("LEFT")
  frame.PetitionsList:SetJustifyV("TOP")
  frame.PetitionsList:SetWidth(520)
  frame.PetitionsList:SetText("")
  place(frame.PetitionsList, 0, 48)

  local sanctionBtn = stockButton(content, "SANCTION BEEF GORA", function()
    Console:Sanction()
  end)
  sanctionBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  local dismissBtn = stockButton(content, "Dismiss", function()
    Console:Dismiss()
  end)
  dismissBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 154, -y)
  y = y + 26
  local victorBtn = stockButton(content, "DECLARE VICTOR", function()
    Console:DeclareVictor()
  end)
  victorBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  local cowardBtn = stockButton(content, "COWARDICE RECORDED", function()
    Console:CowardiceRecorded()
  end)
  cowardBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 154, -y)
  local voidBtn = stockButton(content, "VOID", function()
    Console:Void()
  end)
  voidBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 308, -y)
  y = y + 26
  local freeBtn = stockButton(content, "FREE RULING", function()
    Console:FreeRuling()
  end)
  freeBtn:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
  y = y + 30

  local momentBtn = stockButton(content, "MARK THIS MOMENT", function()
    Console:FlagMoment()
  end)
  place(momentBtn, 0, 22)

  local notebook = header(content, "Notebook")
  place(notebook, 0, 16)
  frame.NotebookLabel = notebook

  local decreeHead = header(content, DECREE_HEADER)
  place(decreeHead, 0, 16)
  frame.DecreeHeader = decreeHead
  frame.DecreeLine = stockEdit(content, 520)
  place(frame.DecreeLine, 0, 20)
  frame.DecreeFlavor = stockEdit(content, 520)
  place(frame.DecreeFlavor, 0, 20)
  local postBtn = stockButton(content, "Post Decree", function()
    Console:PostDecree()
  end)
  place(postBtn, 0, 22)

  if type(UISpecialFrames) == "table" then
    table.insert(UISpecialFrames, FRAME_NAME)
  end

  return frame
end

local function paintPresence(frame, rows)
  if not frame.PresenceList then return end
  local lines = {}
  for i = 1, #rows do
    local row = rows[i]
    local line = row.name or ""
    if row.rankTitle then
      line = line .. "  " .. row.rankTitle
    end
    if row.needsKnighting then
      line = line .. "  needs Knighting"
    end
    lines[#lines + 1] = line
  end
  frame.PresenceList:SetText(table.concat(lines, "\n"))
end

local function paintPetitions(frame, petitions)
  if not frame.PetitionsList then return end
  local lines = {}
  for i = 1, #petitions do
    local row = petitions[i]
    local line = tostring(row.characterId)
    if row.namedOpponentId ~= nil then
      line = line .. "  names  " .. tostring(row.namedOpponentId)
    end
    lines[#lines + 1] = line
  end
  frame.PetitionsList:SetText(table.concat(lines, "\n"))
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
  paintRuntime(self.frame)
  paintPresence(self.frame, self:GetPresence())
  paintPetitions(self.frame, self:GetPetitions())
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
