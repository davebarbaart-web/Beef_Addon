-- Offline scene-graph dump for dressed UI surfaces.
-- Tool, not a harness suite (name is preview_dump.lua, not test_*.lua).
-- Runner: lua tests/preview_dump.lua
package.path = package.path .. ";./tests/?.lua;./addon/ChurchOfBeef/?.lua;./addon/ChurchOfBeef/?/?.lua"

require("wow_stub")

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local stub = require("wow_ui_stub")
stub.install()

UnitClass = function() return "Warrior", "WARRIOR" end
UnitLevel = function() return 70 end

dofile("addon/ChurchOfBeef/Core/Common.lua")
dofile("addon/ChurchOfBeef/UI/Theme.lua")
dofile("addon/ChurchOfBeef/UI/NightRows.lua")
dofile("addon/ChurchOfBeef/Core/Nights.lua")
dofile("addon/ChurchOfBeef/Media/manifest.lua")
dofile("addon/ChurchOfBeef/Data/Ranks.lua")
dofile("addon/ChurchOfBeef/Data/Popes.lua")
dofile("addon/ChurchOfBeef/Core/Store.lua")
dofile("addon/ChurchOfBeef/Core/Records.lua")
dofile("addon/ChurchOfBeef/Core/Runtime.lua")
dofile("addon/ChurchOfBeef/Core/Gora.lua")
dofile("addon/ChurchOfBeef/Core/Knighting.lua")
dofile("addon/ChurchOfBeef/Core/Sender.lua")
dofile("addon/ChurchOfBeef/Core/Decree.lua")
dofile("addon/ChurchOfBeef/Core/Confession.lua")
dofile("addon/ChurchOfBeef/UI/Toasts.lua")
dofile("addon/ChurchOfBeef/UI/Hud.lua")
dofile("addon/ChurchOfBeef/UI/FighterCard.lua")
dofile("addon/ChurchOfBeef/UI/Inputs.lua")
dofile("addon/ChurchOfBeef/UI/Decree.lua")
dofile("addon/ChurchOfBeef/UI/RecordsBook.lua")
dofile("addon/ChurchOfBeef/UI/PlayerCard.lua")
dofile("addon/ChurchOfBeef/UI/Console.lua")
dofile("addon/ChurchOfBeef/UI/Minimap.lua")

local COB = ChurchOfBeef
local Theme = COB.Theme
local SavedSender = COB.Sender

PlaySound = function() end
PlaySoundFile = function() end
PlaySoundKitID = function() end

DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or { AddMessage = function() end }

local function positiveEnv(name, fallback)
  local n = tonumber(os.getenv(name) or "")
  if type(n) ~= "number" or n <= 0 then return fallback end
  return math.floor(n + 0.5)
end

local SCREEN_W = positiveEnv("COB_PREVIEW_WIDTH", 1024)
local SCREEN_H = positiveEnv("COB_PREVIEW_HEIGHT", 768)
local OUT_DIR = os.getenv("COB_PREVIEW_DIR") or "docs/design/renders/preview"
os.execute("mkdir -p " .. OUT_DIR)

UIParent:SetWidth(SCREEN_W)
UIParent:SetHeight(SCREEN_H)
Minimap:SetWidth(140)
Minimap:SetHeight(140)
Minimap:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -8, 16)

--------------------------------------------------------------------------------
-- JSON
--------------------------------------------------------------------------------

local function json_escape(s)
  s = tostring(s)
  local parts = {}
  for i = 1, #s do
    local c = s:sub(i, i)
    local b = string.byte(c)
    if c == "\\" then
      parts[i] = "\\\\"
    elseif c == '"' then
      parts[i] = '\\"'
    elseif c == "\n" then
      parts[i] = "\\n"
    elseif c == "\r" then
      parts[i] = "\\r"
    elseif c == "\t" then
      parts[i] = "\\t"
    elseif b < 32 then
      parts[i] = string.format("\\u%04x", b)
    else
      parts[i] = c
    end
  end
  return table.concat(parts)
end

local function json_encode(value, seen)
  local ty = type(value)
  if ty == "nil" then
    return "null"
  elseif ty == "boolean" then
    return value and "true" or "false"
  elseif ty == "number" then
    if value ~= value or value == math.huge or value == -math.huge then
      return "null"
    end
    return tostring(value)
  elseif ty == "string" then
    return '"' .. json_escape(value) .. '"'
  elseif ty == "table" then
    seen = seen or {}
    if seen[value] then return "null" end
    seen[value] = true
    local isArray = true
    local n = 0
    for k, _ in pairs(value) do
      n = n + 1
      if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
        isArray = false
        break
      end
    end
    if isArray then
      for i = 1, n do
        if value[i] == nil then isArray = false break end
      end
    end
    if isArray then
      local parts = {}
      for i = 1, n do
        parts[i] = json_encode(value[i], seen)
      end
      return "[" .. table.concat(parts, ",") .. "]"
    end
    local keys = {}
    for k, _ in pairs(value) do
      if type(k) == "string" then keys[#keys + 1] = k end
    end
    table.sort(keys)
    local parts = {}
    for i = 1, #keys do
      local k = keys[i]
      parts[#parts + 1] = '"' .. json_escape(k) .. '":' .. json_encode(value[k], seen)
    end
    return "{" .. table.concat(parts, ",") .. "}"
  end
  return "null"
end

local function write_json(path, value)
  local f, err = io.open(path, "w")
  if not f then error("write " .. path .. ": " .. tostring(err)) end
  f:write(json_encode(value))
  f:write("\n")
  f:close()
end

--------------------------------------------------------------------------------
-- Scene walk
--------------------------------------------------------------------------------

local DUMP_TYPES = {
  Frame = true, Button = true, CheckButton = true, EditBox = true,
  Slider = true, ScrollFrame = true, StatusBar = true, GameTooltip = true,
  Texture = true, FontString = true,
}

local function isVisible(widget)
  local w = widget
  while w do
    if w._shown == false then return false end
    w = w._parent
  end
  return true
end

local function collect(root, list, seen)
  if type(root) ~= "table" or seen[root] then return end
  seen[root] = true
  if not DUMP_TYPES[root._type] then return end
  if isVisible(root) then
    list[#list + 1] = root
  end
  local kids = root._children or {}
  for i = 1, #kids do collect(kids[i], list, seen) end
  local regions = root._regions or {}
  for i = 1, #regions do collect(regions[i], list, seen) end
end

local function colorTable(c)
  if type(c) ~= "table" then return nil end
  local r = c.r or c[1]
  local g = c.g or c[2]
  local b = c.b or c[3]
  local a = c.a or c[4]
  if type(r) ~= "number" then return nil end
  return { r = r, g = g, b = b, a = a }
end

local function dumpWidget(widget, ids)
  local rec = {
    id = ids[widget],
    type = widget._type,
    name = widget._name,
    layer = widget._layer,
    subLayer = widget._subLayer,
    strata = widget._strata,
    frameLevel = widget._frameLevel,
    template = widget._template,
    shown = widget._shown ~= false,
    alpha = widget._alpha,
    ignoreParentAlpha = widget._ignoreParentAlpha,
    clipsChildren = widget._clipsChildren,
    width = widget._width,
    height = widget._height,
    parent = widget._parent and ids[widget._parent] or nil,
    points = {},
  }

  local pts = widget._points or {}
  for i = 1, #pts do
    local p = pts[i]
    rec.points[#rec.points + 1] = {
      point = p.point,
      relativeTo = type(p.relativeTo) == "table" and ids[p.relativeTo] or nil,
      relativePoint = p.relativePoint,
      x = p.x,
      y = p.y,
    }
  end

  if widget._backdrop then rec.backdrop = widget._backdrop end
  rec.backdropColor = colorTable(widget._backdropColor)
  rec.backdropBorderColor = colorTable(widget._backdropBorderColor)

  if widget._type == "Texture" or widget._type == "StatusBar" then
    rec.texture = widget._texture or widget._cobTexture or widget._cobPath
    rec.colorTexture = colorTable(widget._colorTexture)
    rec.vertexColor = colorTable(widget._vertexColor) or colorTable(widget._cobColor)
    if not rec.vertexColor and widget._cobR then
      rec.vertexColor = { r = widget._cobR, g = widget._cobG, b = widget._cobB, a = widget._cobA }
    end
    rec.blendMode = widget._blendMode or widget._blend
    rec.texCoord = widget._texCoord
    rec.horizTile = widget._horizTile
    rec.vertTile = widget._vertTile
    rec.gradient = widget._gradient
    rec.cobName = widget._cobName
  end

  if widget._type == "StatusBar" then
    rec.statusBarTexture = widget._statusBarTexture or widget._cobTexture
    rec.statusBarColor = colorTable(widget._statusBarColor) or colorTable(widget._cobColor)
    rec.minValue = widget._min
    rec.maxValue = widget._max
    rec.value = widget._value
    rec.orientation = widget._orientation
  end

  if widget._type == "FontString" or widget._type == "EditBox" then
    rec.text = widget._text
    rec.fontPath = widget._fontPath or widget._cobFont or widget._cobFontPath
    rec.fontSize = widget._fontSize or widget._cobFontSize
    rec.fontFlags = widget._fontFlags
    rec.fontRole = widget._cobFontRole
    rec.textColor = colorTable(widget._textColor) or colorTable(widget._cobColor)
    rec.justifyH = widget._justifyH
    rec.justifyV = widget._justifyV
    rec.wordWrap = widget._wordWrap
    rec.maxLines = widget._maxLines
    rec.shadowColor = colorTable(widget._shadowColor)
    rec.shadowOffset = widget._shadowOffset
  end

  if widget._type == "Button" or widget._type == "CheckButton" then
    rec.text = widget._text
    rec.normalTexture = widget._normalTexture or widget._cobNormalTexture
    rec.pushedTexture = widget._pushedTexture or widget._cobPushedTexture
    rec.highlightTexture = widget._highlightTexture or widget._cobHighlightTexture
    rec.disabledTexture = widget._disabledTexture
    rec.checked = widget._checked
    rec.enabled = widget._enabled
    local fs = widget._fontString
    if fs and fs._text then
      rec.fontStringText = fs._text
      if rec.text == nil then rec.text = fs._text end
    end
  end

  if widget._type == "Slider" then
    rec.minValue = widget._min
    rec.maxValue = widget._max
    rec.value = widget._value
    rec.orientation = widget._orientation
    rec.thumbTexture = widget._thumbTexture
  end

  if widget._type == "ScrollFrame" then
    rec.verticalScroll = widget._verticalScroll
    rec.scrollChild = widget._scrollChild and ids[widget._scrollChild] or nil
  end

  if widget._type == "CheckButton" then
    rec.checkedTexture = widget._checkedTexture
  end

  return rec
end

local function dumpRoots(roots)
  local list = {}
  local seen = {}
  for i = 1, #roots do collect(roots[i], list, seen) end

  -- Always emit UIParent so the compositor has a sized origin, even if the
  -- walk started on Minimap (Minimap is not parented to UIParent).
  if UIParent and not seen[UIParent] then
    table.insert(list, 1, UIParent)
  elseif UIParent then
    local found = false
    for i = 1, #list do
      if list[i] == UIParent then found = true break end
    end
    if not found then table.insert(list, 1, UIParent) end
  end

  local ids = {}
  for i = 1, #list do ids[list[i]] = i end

  -- relativeTo may point at a widget that is hidden (so not in `list`).
  -- Give those targets ids too so the compositor can still chain.
  local extra = {}
  for i = 1, #list do
    local pts = list[i]._points or {}
    for j = 1, #pts do
      local rel = pts[j].relativeTo
      if type(rel) == "table" and ids[rel] == nil then
        extra[#extra + 1] = rel
        ids[rel] = #list + #extra
      end
    end
    local parent = list[i]._parent
    if type(parent) == "table" and ids[parent] == nil then
      extra[#extra + 1] = parent
      ids[parent] = #list + #extra
    end
  end
  for i = 1, #extra do list[#list + 1] = extra[i] end

  local widgets = {}
  for i = 1, #list do
    widgets[i] = dumpWidget(list[i], ids)
  end

  local rootIds = {}
  for i = 1, #roots do
    if ids[roots[i]] then rootIds[#rootIds + 1] = ids[roots[i]] end
  end
  if ids[UIParent] then
    local has = false
    for i = 1, #rootIds do if rootIds[i] == ids[UIParent] then has = true end end
    if not has then table.insert(rootIds, 1, ids[UIParent]) end
  end

  return {
    screen = { width = SCREEN_W, height = SCREEN_H },
    roots = rootIds,
    widgets = widgets,
  }
end

--------------------------------------------------------------------------------
-- Theme snapshot
--------------------------------------------------------------------------------

local THEME_TEXTURE_NAMES = {
  "seal_papal", "sigil_gora", "seal_cowardice", "seal_victor",
  "frame_proclamation",
  "frame_proclamation_corner_tl", "frame_proclamation_corner_tr",
  "frame_proclamation_corner_bl", "frame_proclamation_corner_br",
  "frame_proclamation_edge_top", "frame_proclamation_edge_bottom",
  "frame_proclamation_edge_left", "frame_proclamation_edge_right",
  "frame_proclamation_center",
  "frame_proclamation_pin_tl", "frame_proclamation_pin_tr",
  "frame_proclamation_pin_bl", "frame_proclamation_pin_br",
  "bar_stainedglass_fill", "bar_favor_fill", "sigil_favor",
  "roundel_minimap", "roundel_minimap_pushed", "roundel_minimap_highlight",
  "parchment_decree", "ornament_nail", "banner_knighting", "rays_sunburst",
  "tome_records", "ribbon_bookmark", "frame_fightercard", "ornament_bullhorn",
  "plate_verb", "plate_verb_hover", "plate_verb_pressed",
  "glyph_record", "glyph_defenses", "glyph_headtohead", "glyph_stipulation",
  "close_up", "close_down", "close_highlight", "close_disabled",
  "stock_dialog_bg", "stock_dialog_border",
  "stock_tooltip_bg", "stock_tooltip_border",
  "stock_grabber_up", "stock_grabber_down", "stock_grabber_highlight",
}

local THEME_COLOR_ROLES = {
  "iron", "charcoal", "parchment", "parchmentMid", "gold", "oxblood", "silver",
}

local function dumpTheme()
  local palette = {}
  for i = 1, #THEME_COLOR_ROLES do
    local role = THEME_COLOR_ROLES[i]
    local r, g, b = Theme:Color(role)
    palette[role] = { r, g, b }
  end
  local fontPath = {}
  for _, role in ipairs({ "display", "label", "body" }) do
    fontPath[role] = Theme:FontPath(role)
  end
  local textures = {}
  for i = 1, #THEME_TEXTURE_NAMES do
    local name = THEME_TEXTURE_NAMES[i]
    textures[name] = Theme:Texture(name)
  end
  local classColors = {}
  if type(RAID_CLASS_COLORS) == "table" then
    for k, v in pairs(RAID_CLASS_COLORS) do
      if type(v) == "table" then
        classColors[k] = { r = v.r, g = v.g, b = v.b }
      end
    end
  end
  return {
    palette = palette,
    fontPath = fontPath,
    fontSize = Theme.FontSize,
    textures = textures,
    classColors = classColors,
  }
end

--------------------------------------------------------------------------------
-- Fixtures
--------------------------------------------------------------------------------

local function resetCores()
  if COB.Store and COB.Store.ResetForTests then COB.Store:ResetForTests() end
  if COB.Runtime and COB.Runtime.ResetForTests then COB.Runtime:ResetForTests() end
  if COB.Gora and COB.Gora.ResetForTests then COB.Gora:ResetForTests() end
  if COB.Decree and COB.Decree.ResetForTests then COB.Decree:ResetForTests() end
  if COB.Nights and COB.Nights.ResetForTests then COB.Nights:ResetForTests() end
  if COB.DecreeBanner and COB.DecreeBanner.ResetForTests then COB.DecreeBanner:ResetForTests() end
  if COB.Knighting and COB.Knighting.ResetForTests then COB.Knighting:ResetForTests() end
  if COB.Confession and COB.Confession.ResetForTests then COB.Confession:ResetForTests() end
  if COB.Toasts and COB.Toasts.ResetForTests then COB.Toasts:ResetForTests() end
  if COB.Hud and COB.Hud.ResetForTests then COB.Hud:ResetForTests() end
  if COB.FighterCard and COB.FighterCard.ResetForTests then COB.FighterCard:ResetForTests() end
  if COB.Inputs and COB.Inputs.ResetForTests then COB.Inputs:ResetForTests() end
  if COB.RecordsBook and COB.RecordsBook.ResetForTests then COB.RecordsBook:ResetForTests() end
  if COB.PlayerCard and COB.PlayerCard.ResetForTests then COB.PlayerCard:ResetForTests() end
  if COB.Console and COB.Console.ResetForTests then COB.Console:ResetForTests() end
  if COB.DecreeBanner and COB.DecreeBanner.Hide then COB.DecreeBanner:Hide() end
  if COB.Minimap and COB.Minimap.button then COB.Minimap.button:Hide() end
  if Minimap then Minimap:Hide() end
  COB.Roster = nil
  COB.Sender = SavedSender
  stub.playerName = "Thedave"
  stub.guildRankIndex = nil
end

local function twoChars()
  local a = COB.Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
  local b = COB.Store:CreateCharacter({ name = "Tendermage", class = "Mage", level = 68 })
  return a, b
end

local function rankBoth(charA, charB, rankA, rankB)
  local humanA = COB.Store:CreateHuman({ name = "Chuck" })
  local humanB = COB.Store:CreateHuman({ name = "Tender" })
  COB.Store:LinkCharacter(charA.id, humanA.id)
  COB.Store:LinkCharacter(charB.id, humanB.id)
  COB.Store:SetRank(humanA.id, rankA or 3)
  COB.Store:SetRank(humanB.id, rankB or 1)
  return humanA, humanB
end

local function recordBout(a, b, winner)
  COB.Store:RecordGoraResult(a.id, {
    opponentId = b.id, ruling = "victor", won = (winner == a),
  })
  COB.Store:RecordGoraResult(b.id, {
    opponentId = a.id, ruling = "victor", won = (winner == b),
  })
end

-- Shape of the Goldshire Pope SavedVariables on 2026-09-14: Thedave
-- entered without a rank, 2–1 vs Regularbeef, posted Decree, live Gora rite.
-- Not a store write — preview only.
local function seedGoldshire()
  local dave = COB.Store:CreateCharacter({ name = "Thedave", class = "Warrior", level = 70 })
  local beef = COB.Store:CreateCharacter({ name = "Regularbeef", class = "Hunter", level = 36 })
  local hDave = COB.Store:CreateHuman({ name = "Thedave" })
  local hBeef = COB.Store:CreateHuman({ name = "Regularbeef" })
  COB.Store:LinkCharacter(dave.id, hDave.id)
  COB.Store:LinkCharacter(beef.id, hBeef.id)
  COB.Store:SetRank(hBeef.id, 3)
  COB.Store:AppendCeremony("Knighting", { hBeef.id }, 1789444424)
  recordBout(beef, dave, beef)
  recordBout(dave, beef, dave)
  recordBout(dave, beef, dave)
  COB.Store:AppendCeremony("victor", { dave.id, beef.id }, 1789444670)
  COB.Decree:Set({ line = "TODAY IS THE DAY FOR BEEF", flavor = "TESTING BEEF FLAVOR HERE" })
  COB.Runtime:StartEvent()
  COB.Runtime:OpenRite("Gora")
  stub.playerName = "Thedave"
  stub.guildRankIndex = 0
  stub.guildRankName = "Beef Prophet"
  return dave, beef
end

-- Live Pope store after the Tonyswife bout: Regularbéef 3–3 (last victor),
-- Thedave 3–2, Tonyswife 0–1. Same wins + streak ties Regularbéef first
-- by recency. UTF-8 name matches SavedVariables.
local REGULARBEEF = "Regularb\195\169ef"
local function seedGoldshireFight()
  local dave = COB.Store:CreateCharacter({ name = "Thedave", class = "Warrior", level = 70 })
  local beef = COB.Store:CreateCharacter({ name = REGULARBEEF, class = "Hunter", level = 36 })
  local tony = COB.Store:CreateCharacter({ name = "Tonyswife", class = "Mage", level = 16 })
  local hDave = COB.Store:CreateHuman({ name = "Thedave" })
  local hBeef = COB.Store:CreateHuman({ name = REGULARBEEF })
  local hTony = COB.Store:CreateHuman({ name = "Tonyswife" })
  COB.Store:LinkCharacter(dave.id, hDave.id)
  COB.Store:LinkCharacter(beef.id, hBeef.id)
  COB.Store:LinkCharacter(tony.id, hTony.id)
  COB.Store:SetRank(hBeef.id, 4)
  COB.Store:AppendCeremony("Elevation", { hBeef.id }, 1789447164)
  recordBout(beef, dave, beef)
  recordBout(dave, beef, dave)
  recordBout(dave, beef, dave)
  recordBout(beef, dave, beef)
  recordBout(dave, beef, dave)
  COB.Store:AppendCeremony("victor", { dave.id, beef.id }, 1789447382)
  recordBout(beef, tony, beef)
  COB.Store:AppendCeremony("victor", { beef.id, tony.id }, 1789448676)
  stub.playerName = "Thedave"
  stub.guildRankIndex = 0
  stub.guildRankName = "Beef Prophet"
  return dave, beef
end

-- Quiet night with a posted Decree — live store after the Tonyswife bout.
local function seedGoldshireNow()
  local dave, beef = seedGoldshireFight()
  COB.Decree:Set({ line = "Big raid today", flavor = "Nov 4th" })
  return dave, beef
end

local function seedGoldshireLedger()
  local dave, beef = seedGoldshireFight()
  COB.Decree:Set({ line = "TODAY IS THE DAY FOR BEEF", flavor = "TESTING BEEF FLAVOR HERE" })
  COB.Runtime:StartEvent()
  COB.Runtime:OpenRite("Gora")
  return dave, beef
end

local function history32()
  local a, b = twoChars()
  rankBoth(a, b, 3, 1)
  for _ = 1, 3 do
    assert(COB.Gora:Sanction(a.id, b.id))
    assert(COB.Gora:DeclareVictor(a.id))
  end
  for _ = 1, 2 do
    assert(COB.Gora:Sanction(a.id, b.id))
    assert(COB.Gora:DeclareVictor(b.id))
  end
  return a, b
end

local function asPope()
  stub.playerName = "Thedave"
end

local function seedDeskPeople()
  local a, b = twoChars()
  rankBoth(a, b, 2, 3)
  local popeChar = COB.Store:CreateCharacter({ name = "Thedave", class = "Warrior", level = 70 })
  local popeHuman = COB.Store:CreateHuman({ name = "David" })
  COB.Store:LinkCharacter(popeChar.id, popeHuman.id)
  COB.Store:SetRank(popeHuman.id, 6)
  COB.Roster = {
    ready = true,
    complete = false,
    members = {
      [COB.Names.Key("Thedave")] = { name = "Thedave", guildRankIndex = 0 },
      [COB.Names.Key("Chuckroast")] = { name = "Chuckroast", guildRankIndex = 6 },
      [COB.Names.Key("Tendermage")] = { name = "Tendermage", guildRankIndex = 6 },
    },
  }
  return a, b
end

local function showDesk()
  asPope()
  COB.Console:Show()
  assert(COB.Console:IsShown() == true, "console shown")
end

--------------------------------------------------------------------------------
-- Scenarios
--------------------------------------------------------------------------------

local SCENARIOS = {
  {
    name = "decree",
    run = function()
      COB.Decree:Set({
        line = "Goldshire Inn — Sunday, 7:00 PM",
        flavor = "Bring a friend.",
      })
      COB.DecreeBanner:Init()
      assert(COB.DecreeBanner:Show() == true, "decree banner")
    end,
  },
  {
    name = "nights_board",
    run = function()
      COB.Nights:SetSeries({
        kind = "gathering",
        weekday = 5,
        timeLine = "7:00 PM",
        place = "Goldshire Inn",
      })
      local week = COB.Nights:Week()
      assert(type(week) == "table" and #week >= 1, "week has a gathering")
      COB.Nights:SetStub({
        kind = "raid",
        title = "Kara Thursday",
        timeLine = "8:00 PM",
        place = "Karazhan",
        date = week[1].date,
      })
      assert(COB.DecreeBanner:Show() == true, "nights parchment")
      local host = COB.NightRows:Host(COB.DecreeBanner.frame.NightList)
      assert(host and host.rows[1]:IsShown() and host.rows[2]:IsShown(), "two night rows")
      assert(host.rows[1].Kind:GetText() ~= host.rows[2].Kind:GetText(), "rows are distinct")
    end,
  },
  {
    name = "proclaim_sanction",
    run = function()
      COB.Runtime:StartEvent()
      assert(COB.Toasts:Proclaim("sanction", {
        fighterA = "Chuckroast",
        fighterB = "Tendermage",
        stipulation = "Come as you are",
      }) == true, "proclaim sanction")
    end,
  },
  {
    name = "proclaim_victor",
    run = function()
      COB.Runtime:StartEvent()
      assert(COB.Toasts:Proclaim("verdict", {
        ruling = "victor",
        name = "Chuckroast",
      }) == true, "proclaim victor")
    end,
  },
  {
    name = "proclaim_cowardice",
    run = function()
      COB.Runtime:StartEvent()
      assert(COB.Toasts:Proclaim("cowardice", {
        name = "Tendermage",
      }) == true, "proclaim cowardice")
    end,
  },
  {
    name = "proclaim_knighting",
    run = function()
      COB.Runtime:StartEvent()
      assert(COB.Toasts:Proclaim("knighting", {
        name = "Chuckroast",
      }) == true, "proclaim knighting")
    end,
  },
  {
    name = "fightercard",
    run = function()
      COB.Runtime:StartEvent()
      local a, b = history32()
      assert(COB.Gora:Sanction(a.id, b.id, "no potions"))
      assert(COB.FighterCard:Show() == true, "fighter card")
    end,
  },
  {
    name = "hud",
    run = function()
      COB.Runtime:StartEvent()
      local a, b = history32()
      assert(COB.Gora:Sanction(a.id, b.id))
      -- Congregation path: Pope client reads Gora:GetFavorSplit (empty
      -- here). Suites nil Sender so broadcast favor paints instead.
      COB.Sender = nil
      COB.Hud:SetBroadcastFavor({ a = 13, b = 12 })
      local view = COB.Hud:Refresh()
      assert(view and view.shown == true, "hud shown")
      assert(view.favor and view.favor.pctA == 52 and view.favor.pctB == 48,
        "hud favor 52/48")
    end,
  },
  {
    name = "event_inputs",
    run = function()
      stub.playerName = "Chuckroast"
      COB.Sender = {
        IsRegisteredPope = function() return false end,
      }
      COB.Runtime:StartEvent()
      local localChar = COB.Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
      COB.Inputs:SetInputTarget("Thedave")
      COB.Inputs:SetLocalCharacterId(localChar.id)
      COB.Inputs:Init()
      assert(COB.Inputs:Show() == true, "event inputs shown")
    end,
  },
  {
    -- The player card: a Beef Knight with a record, a rival, a distinction,
    -- and a posted Decree.
    name = "card",
    run = function()
      local a, b = twoChars()
      local humanA = rankBoth(a, b, 3, 1)
      COB.Store:AppendCeremony("Knighting", { humanA.id }, 1700000000)
      recordBout(a, b, a)
      recordBout(a, b, a)
      COB.Store:AppendCeremony("victor", { a.id, b.id }, 1700000200)
      COB.Store:AddHonorific(humanA.id, "Duke of the Fountain")
      COB.Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
      stub.playerName = "Chuckroast"
      stub.guildRankIndex = 6
      assert(COB.PlayerCard:Show() == true, "card shown")
      local model = COB.PlayerCard:GetModel()
      assert(model.rankTitle == "Beef Knight", "card rank")
      assert(model.record and model.record.wins == 2, "card record")
      assert(COB.PlayerCard.frame.RankText:GetText() == "Beef Knight", "rank plate")
    end,
  },
  {
    name = "card_one",
    run = function()
      local a, b = twoChars()
      COB.Store:RecordGoraResult(a.id, { opponentId = b.id, ruling = "victor", won = true })
      stub.playerName = "Chuckroast"
      stub.guildRankIndex = 6
      assert(COB.PlayerCard:Show() == true, "one-fighter card shown")
      assert(COB.PlayerCard.frame.VictoryLines[1]:GetText() == "Chuckroast", "one name")
      assert(COB.PlayerCard.frame.VictoryLines[2]:IsShown() == false, "no second name")
    end,
  },
  {
    name = "card_front",
    run = function()
      local a, b = twoChars()
      local c = COB.Store:CreateCharacter({ name = "Brisketh", class = "Rogue", level = 69 })
      local d = COB.Store:CreateCharacter({ name = "Sirloin", class = "Paladin", level = 70 })
      local humanA = rankBoth(a, b, 3, 1)
      COB.Store:AppendCeremony("Knighting", { humanA.id }, 1700000000)
      recordBout(a, b, a)
      recordBout(a, c, a)
      recordBout(a, d, a)
      recordBout(c, b, c)
      recordBout(c, d, c)
      recordBout(b, d, b)
      COB.Store:AppendCeremony("victor", { a.id, d.id }, 1700000300)
      COB.Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
      stub.playerName = "Chuckroast"
      stub.guildRankIndex = 6
      assert(COB.PlayerCard:Show() == true, "three-up card shown")
      assert(COB.PlayerCard.frame.VictoryLines[1]:GetText() == "Chuckroast", "front 1")
      assert(COB.PlayerCard.frame.VictoryLines[3]:GetText() == "Tendermage", "front 3")
    end,
  },
  {
    name = "card_outsider",
    run = function()
      local a, b = twoChars()
      local c = COB.Store:CreateCharacter({ name = "Brisketh", class = "Rogue", level = 69 })
      local d = COB.Store:CreateCharacter({ name = "Sirloin", class = "Paladin", level = 70 })
      recordBout(a, b, a)
      recordBout(a, c, a)
      recordBout(a, d, a)
      recordBout(c, b, c)
      recordBout(c, d, c)
      recordBout(b, d, b)
      stub.playerName = "Sirloin"
      stub.guildRankIndex = 6
      assert(COB.PlayerCard:Show() == true, "outsider card shown")
      assert(COB.PlayerCard.frame.YourRecordText:IsShown() == true, "personal line shown")
    end,
  },
  {
    name = "card_gora",
    run = function()
      local a, b = twoChars()
      local c = COB.Store:CreateCharacter({ name = "Brisketh", class = "Rogue", level = 69 })
      local d = COB.Store:CreateCharacter({ name = "Sirloin", class = "Paladin", level = 70 })
      local humanA = rankBoth(a, b, 3, 1)
      COB.Store:AppendCeremony("Knighting", { humanA.id }, 1700000000)
      recordBout(a, b, a)
      recordBout(a, c, a)
      recordBout(a, d, a)
      recordBout(c, b, c)
      recordBout(c, d, c)
      recordBout(b, d, b)
      stub.playerName = "Chuckroast"
      stub.guildRankIndex = 6
      assert(COB.PlayerCard:Show() == true, "card shown")
      assert(COB.PlayerCard:ShowGora() == true, "gora ledger shown")
      assert(COB.PlayerCard.view == "gora", "ledger view")
      assert(COB.PlayerCard.frame.LedgerRows[1].Name:GetText() == "Chuckroast", "ledger order")
    end,
  },
  {
    name = "card_gora_full",
    run = function()
      local champ = COB.Store:CreateCharacter({ name = "Chuckroast", class = "Warrior", level = 70 })
      local human = COB.Store:CreateHuman({ name = "Chuck" })
      COB.Store:LinkCharacter(champ.id, human.id)
      COB.Store:SetRank(human.id, 3)
      for i = 1, 10 do
        local opp = COB.Store:CreateCharacter({ name = string.format("Beef%02d", i), class = "Warrior", level = 70 })
        recordBout(champ, opp, champ)
      end
      stub.playerName = "Chuckroast"
      stub.guildRankIndex = 6
      assert(COB.PlayerCard:ShowGora() == true, "full ledger shown")
      assert(#COB.PlayerCard:GetModel().stories == 11, "eleven fighters")
      assert(COB.PlayerCard.frame.LedgerScroll.ScrollBar:IsShown() == true, "thumb shown")
    end,
  },
  {
    -- Posted Decree, no sanctioned Goras: loud week, aligned empty Gora.
    name = "card_live",
    run = function()
      COB.Decree:Set({ line = "TODAY IS THE DAY FOR BEEF", flavor = "TESTING BEEF FLAVOR HERE" })
      stub.playerName = "Thedave"
      stub.guildRankIndex = 6
      stub.guildRankName = "Beef Prophet"
      assert(COB.PlayerCard:Show() == true, "live Decree card shown")
      assert(COB.PlayerCard.frame.DecreeText:GetText() == "TODAY IS THE DAY FOR BEEF", "live line")
    end,
  },
  {
    -- Current Goldshire Pope client: entered-unranked Thedave, two-up
    -- Gora, posted Decree, live Gora ribbon.
    name = "card_goldshire",
    run = function()
      seedGoldshire()
      assert(COB.PlayerCard:Show() == true, "goldshire card shown")
      assert(COB.PlayerCard.frame.RankText:GetText() == "UNRANKED", "store row beats guild title")
      assert(COB.PlayerCard.frame.VictoryLines[1]:GetText() == "Thedave", "front 1")
      assert(COB.PlayerCard.frame.VictoryLines[2]:GetText() == "Regularbeef", "front 2")
      assert(COB.PlayerCard.frame.GatheringLabel:GetText() == "GORA", "live Gora ribbon")
    end,
  },
  {
    name = "card_goldshire_now",
    run = function()
      seedGoldshireNow()
      assert(COB.PlayerCard:Show() == true, "quiet-night card shown")
      assert(COB.PlayerCard.frame.RankText:GetText() == "UNRANKED", "store row")
      assert(COB.PlayerCard.frame.GatheringLabel:GetText() == "DECREE", "quiet ribbon")
      assert(COB.PlayerCard.frame.VictoryLines[1]:GetText() == REGULARBEEF, "front 1 is recency after the tied 3-win")
      assert(COB.PlayerCard.frame.VictoryLines[2]:GetText() == "Thedave", "front 2")
      assert(COB.PlayerCard.frame.VictoryLines[3]:GetText() == "Tonyswife", "front 3")
    end,
  },
  {
    name = "card_goldshire_gora",
    run = function()
      seedGoldshireLedger()
      assert(COB.PlayerCard:ShowGora() == true, "goldshire ledger shown")
      assert(COB.PlayerCard.frame.LedgerRows[1].Name:GetText() == REGULARBEEF, "ledger 1")
      assert(COB.PlayerCard.frame.LedgerRows[2].Name:GetText() == "Thedave", "ledger 2")
      assert(COB.PlayerCard.frame.LedgerRows[3].Name:GetText() == "Tonyswife", "ledger 3")
    end,
  },
  {
    name = "card_decree",
    run = function()
      COB.Decree:Set({ line = "Goldshire Inn — Sunday, 7:00 PM", flavor = "The Gathering." })
      stub.playerName = "Beefina"
      assert(COB.PlayerCard:Show() == true, "decree-only card shown")
      assert(COB.PlayerCard.frame.DecreeText:GetText() == "Goldshire Inn — Sunday, 7:00 PM", "decree line")
      assert(COB.PlayerCard.frame.GoraEmptyText:IsShown() == true, "no Goras yet")
    end,
  },
  {
    name = "card_nights",
    run = function()
      COB.Nights:SetSeries({
        kind = "gathering",
        weekday = 5,
        timeLine = "7:00 PM",
        place = "Goldshire Inn",
      })
      local week = COB.Nights:Week()
      assert(type(week) == "table" and #week >= 1, "week has a gathering")
      COB.Nights:SetStub({
        kind = "raid",
        title = "Kara Thursday",
        timeLine = "8:00 PM",
        place = "Karazhan",
        date = week[1].date,
      })
      stub.playerName = "Beefina"
      assert(COB.PlayerCard:Show() == true, "nights card shown")
      local host = COB.NightRows:Host(COB.PlayerCard.frame.NightList)
      assert(host and host.rows[1]:IsShown() and host.rows[2]:IsShown(), "week has two rows")
      assert(COB.PlayerCard.frame.DecreeText:IsShown() ~= true, "blob is hidden")
    end,
  },
  {
    -- Empty store: the card's honest empty states.
    name = "card_empty",
    run = function()
      stub.playerName = "Beefina"
      assert(COB.PlayerCard:Show() == true, "empty card shown")
      local model = COB.PlayerCard:GetModel()
      assert(model.entered == false, "not entered")
      assert(model.decree == nil, "no decree")
      assert(COB.PlayerCard.frame.RankText:GetText() == "", "unwritten gold plate is empty")
      assert(COB.PlayerCard.frame.RelationshipText:GetText() == "The Pope has not written you yet. That is normal.",
        "unwritten newness is the relationship line")
    end,
  },
  {
    -- Chronicle-first records: a small ceremony log plus held superlatives.
    name = "records",
    run = function()
      local a, b = twoChars()
      local humanA, humanB = rankBoth(a, b, 3, 1)
      COB.Store:AppendCeremony("Knighting", { humanA.id }, 1700000000)
      recordBout(a, b, a)
      COB.Store:AppendCeremony("victor", { a.id, b.id }, 1700000100)
      recordBout(a, b, a)
      COB.Store:AppendCeremony("victor", { a.id, b.id }, 1700000200)
      recordBout(a, b, b)
      COB.Store:AppendCeremony("victor", { b.id, a.id }, 1700000300)
      COB.Store:AppendCeremony("Recognition", { b.id, humanB.id }, 1700000400)
      assert(COB.RecordsBook:Show() == true, "records book")
      local pages = COB.RecordsBook:GetPages()
      assert(pages[1].title == "Chronicle", "chronicle first")
      assert(#pages >= 2, "a held superlative renders")
      -- The ledger paints one FontString per entry slot, not the body well.
      local painted = {}
      for i = 1, #COB.RecordsBook.frame.ChronicleEntries do
        local slot = COB.RecordsBook.frame.ChronicleEntries[i]
        if slot:IsShown() then painted[#painted + 1] = slot:GetText() or "" end
      end
      local body = table.concat(painted, "\n")
      assert(body:find("was Knighted.", 1, true) ~= nil, "chronicle paints the Knighting")
      assert(body:find("declared victor over", 1, true) ~= nil, "chronicle paints the rulings")
      -- Prove a held superlative leaf renders, then rest back on the Chronicle.
      assert(stub.fire(COB.RecordsBook.frame.NextButton, "OnClick"), "next leaf control wired")
      assert(COB.RecordsBook.frame.PageTitle:GetText() == "Most Sanctioned Victories",
        "held superlative renders")
      local supBody = COB.RecordsBook.frame.Body:GetText() or ""
      assert(supBody:find("Chuckroast", 1, true) ~= nil, "superlative names the holder")
      for _ = 1, 3 do stub.fire(COB.RecordsBook.frame.PrevButton, "OnClick") end
      assert(COB.RecordsBook.frame.PageTitle:GetText() == "Chronicle", "rests on the Chronicle")
    end,
  },
  {
    -- Empty store: the dump rests on the Chronicle leaf so the empty ledger
    -- line renders.
    name = "records_empty",
    run = function()
      assert(COB.RecordsBook:Show() == true, "empty records book")
      assert(COB.RecordsBook.frame.Body:GetText() == "Nothing has been written yet.",
        "empty chronicle line")
      local pages = COB.RecordsBook:GetPages()
      assert(#pages == 1 and pages[1].title == "Chronicle", "only the chronicle leaf")
      assert(COB.RecordsBook.frame.PageTitle:GetText() == "Chronicle",
        "rests on the Chronicle for the dump")
      assert(COB.RecordsBook.frame.Body:GetText() == "Nothing has been written yet.",
        "the empty chronicle line renders into the dump")
    end,
  },
  {
    name = "console",
    run = function()
      asPope()
      COB.Runtime:StartEvent()
      local a, b = twoChars()
      rankBoth(a, b, 3, 1)
      local popeChar = COB.Store:CreateCharacter({ name = "Thedave", class = "Warrior", level = 70 })
      local popeHuman = COB.Store:CreateHuman({ name = "David" })
      COB.Store:LinkCharacter(popeChar.id, popeHuman.id)
      COB.Store:SetRank(popeHuman.id, 6)
      COB.Roster = {
        ready = true,
        complete = false,
        members = {
          [COB.Names.Key("Thedave")] = { name = "Thedave", guildRankIndex = 0 },
          [COB.Names.Key("Chuckroast")] = { name = "Chuckroast", guildRankIndex = 6 },
          [COB.Names.Key("Tendermage")] = { name = "Tendermage", guildRankIndex = 6 },
        },
      }
      COB.Gora:Petition(a.id)
      COB.Console:Show()
      assert(COB.Console:IsShown() == true, "console shown")
    end,
  },
  {
    name = "console_inactive",
    run = function()
      seedDeskPeople()
      showDesk()
      assert(COB.Console:GetDeskState().gathering == "inactive", "inactive gathering")
    end,
  },
  {
    name = "console_active",
    run = function()
      local a = seedDeskPeople()
      COB.Runtime:StartEvent()
      COB.Gora:Petition(a.id)
      showDesk()
      assert(COB.Console:GetDeskState().gathering == "active", "active gathering")
    end,
  },
  {
    name = "console_knighting",
    run = function()
      local a = seedDeskPeople()
      COB.Console:StartEvent()
      COB.Console:SelectCharacter(a.id)
      COB.Console:OpenRite("Knighting")
      showDesk()
      assert(COB.Console:GetDeskState().rite == "knighting", "knighting setup")
    end,
  },
  {
    name = "console_knighting_done",
    run = function()
      local a = seedDeskPeople()
      COB.Console:StartEvent()
      COB.Console:SelectCharacter(a.id)
      COB.Console:OpenRite("Knighting")
      assert(COB.Console:KnightThisBeef(), "knight the candidate")
      showDesk()
      assert(COB.Console:GetDeskState().knightingPhase == "complete", "knighting complete")
    end,
  },
  {
    name = "console_gora_setup",
    run = function()
      local a, b = seedDeskPeople()
      COB.Console:StartEvent()
      COB.Console:SelectCharacter(a.id)
      COB.Console:SetFighterA()
      COB.Console:SelectCharacter(b.id)
      COB.Console:SetFighterB()
      COB.Console:OpenRite("Gora")
      showDesk()
      assert(COB.Console:GetDeskState().goraPhase == "setup", "gora setup")
    end,
  },
  {
    name = "console_gora_live",
    run = function()
      local a, b = seedDeskPeople()
      COB.Console:StartEvent()
      COB.Console:SelectCharacter(a.id)
      COB.Console:SetFighterA()
      COB.Console:SelectCharacter(b.id)
      COB.Console:SetFighterB()
      COB.Console:OpenRite("Gora")
      assert(COB.Console:Sanction(), "sanction")
      showDesk()
      assert(COB.Console:GetDeskState().goraPhase == "sanctioned", "gora sanctioned")
    end,
  },
  {
    name = "console_gora_done",
    run = function()
      local a, b = seedDeskPeople()
      COB.Console:StartEvent()
      COB.Console:SelectCharacter(a.id)
      COB.Console:SetFighterA()
      COB.Console:SelectCharacter(b.id)
      COB.Console:SetFighterB()
      COB.Console:OpenRite("Gora")
      assert(COB.Console:Sanction(), "sanction")
      assert(COB.Console:DeclareVictor(a.id), "record victor")
      showDesk()
      assert(COB.Console:GetDeskState().goraPhase == "complete", "gora complete")
    end,
  },
  {
    name = "console_decrees",
    run = function()
      seedDeskPeople()
      COB.Decree:Set({
        line = "Goldshire Inn — Sunday, 7:00 PM",
        flavor = "Bring your appetite.",
      })
      showDesk()
      COB.Console:SetTab("decrees")
      assert(COB.Console:GetTab() == "decrees", "decrees tab")
    end,
  },
  {
    name = "console_chronicle",
    run = function()
      seedDeskPeople()
      COB.Console:StartEvent()
      COB.Console:FlagMoment("Goldshire Inn")
      showDesk()
      COB.Console:SetTab("chronicle")
      assert(COB.Console:GetTab() == "chronicle", "chronicle tab")
    end,
  },
  {
    name = "console_church",
    run = function()
      seedDeskPeople()
      showDesk()
      COB.Console:SetTab("church")
      assert(COB.Console:GetTab() == "church", "church tab")
    end,
  },
  {
    name = "minimap",
    run = function()
      Minimap:Show()
      local button = COB.Minimap:Init()
      assert(button ~= nil, "minimap button")
      button:Show()
    end,
    roots = function()
      return { UIParent, Minimap }
    end,
  },
}

--------------------------------------------------------------------------------
-- Run
--------------------------------------------------------------------------------

write_json(OUT_DIR .. "/theme.json", dumpTheme())
print("wrote " .. OUT_DIR .. "/theme.json")

local failed = 0
for i = 1, #SCENARIOS do
  local sc = SCENARIOS[i]
  local ok, err = pcall(function()
    resetCores()
    asPope()
    sc.run()
    local roots = sc.roots and sc.roots() or { UIParent }
    local scene = dumpRoots(roots)
    scene.scenario = sc.name
    write_json(OUT_DIR .. "/" .. sc.name .. ".json", scene)
    print(string.format("wrote %s/%s.json (%d widgets)", OUT_DIR, sc.name, #scene.widgets))
  end)
  if not ok then
    failed = failed + 1
    print("FAIL " .. sc.name .. ": " .. tostring(err))
  end
end

if failed > 0 then
  print(string.format("preview_dump finished: %d failed", failed))
  os.exit(1)
end
print(string.format("preview_dump finished: %d scenarios at %dx%d", #SCENARIOS, SCREEN_W, SCREEN_H))
