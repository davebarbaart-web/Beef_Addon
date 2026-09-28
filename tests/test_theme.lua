-- COB.Theme design system: palette, fonts, stock texture fallbacks.
-- Pure logic — no frames. Manifest is a global another lane generates.
local standalone = (type(assert_eq) ~= "function")
local passed = 0
local failed = 0

if standalone then
  package.path = package.path .. ";./tests/?.lua"
  require("wow_stub")
  ChurchOfBeef = ChurchOfBeef or {}
  ChurchOfBeef._IN_TEST = true
  function assert_eq(a, b, msg)
    if a ~= b then
      failed = failed + 1
      print("FAIL: " .. (msg or "") .. " expected " .. tostring(b) .. " got " .. tostring(a))
    else
      passed = passed + 1
    end
  end
  function assert_true(v, msg)
    assert_eq(not not v, true, msg)
  end
  dofile("addon/ChurchOfBeef/Core/Common.lua")
end

ChurchOfBeef = ChurchOfBeef or {}
ChurchOfBeef._IN_TEST = true

local frames = 0
local savedCreateFrame = CreateFrame
CreateFrame = function(...)
  frames = frames + 1
  if savedCreateFrame then return savedCreateFrame(...) end
end

-- wow_stub does not install RAID_CLASS_COLORS. Exact floats are the contract.
local savedClassColors = RAID_CLASS_COLORS
RAID_CLASS_COLORS = {
  MAGE    = { r = 0.41, g = 0.80, b = 0.94 },
  WARRIOR = { r = 0.78, g = 0.61, b = 0.43 },
}

local savedManifest = ChurchOfBeefMediaManifest
ChurchOfBeefMediaManifest = nil

dofile("addon/ChurchOfBeef/UI/Theme.lua")

local Theme = ChurchOfBeef.Theme
assert_true(Theme ~= nil, "COB.Theme exists")
assert_eq(frames, 0, "Theme mints no frames on load")

--------------------------------------------------------------------------------
-- Color roles: exact 0–255 / 255 floats. Unknown → nil.
--------------------------------------------------------------------------------

local function expect_rgb(role, r8, g8, b8)
  local r, g, b = Theme:Color(role)
  assert_eq(r, r8 / 255, role .. " r")
  assert_eq(g, g8 / 255, role .. " g")
  assert_eq(b, b8 / 255, role .. " b")
end

expect_rgb("iron",         42,  38,  34)
expect_rgb("charcoal",     28,  26,  23)
expect_rgb("parchment",    228, 214, 176)
expect_rgb("parchmentMid", 217, 201, 163)
expect_rgb("gold",         201, 165, 74)
expect_rgb("oxblood",      110, 31,  31)
expect_rgb("silver",       154, 150, 142)
expect_rgb("gathering",    74,  52,  36)
expect_rgb("knighting",    72,  56,  28)
expect_rgb("gora",         36,  48,  58)
expect_rgb("notice",       52,  50,  46)

local ur, ug, ub = Theme:Color("red")
assert_eq(ur, nil, "unknown color role 'red' is nil — red is not a token")
assert_eq(ug, nil, "unknown color role returns no g")
assert_eq(ub, nil, "unknown color role returns no b")
assert_eq(Theme:Color("crimson"), nil, "unknown color role 'crimson' is nil")
assert_eq(Theme:Color(nil), nil, "nil color role is nil")
assert_eq(Theme:Color(1), nil, "numeric color role is nil")

--------------------------------------------------------------------------------
-- ClassColor: RAID_CLASS_COLORS passthrough. Unknown → nil.
--------------------------------------------------------------------------------

local mr, mg, mb = Theme:ClassColor("MAGE")
assert_eq(mr, 0.41, "MAGE r passthrough")
assert_eq(mg, 0.80, "MAGE g passthrough")
assert_eq(mb, 0.94, "MAGE b passthrough")

local wr, wg, wb = Theme:ClassColor("WARRIOR")
assert_eq(wr, 0.78, "WARRIOR r passthrough")
assert_eq(wg, 0.61, "WARRIOR g passthrough")
assert_eq(wb, 0.43, "WARRIOR b passthrough")

local nr, ng, nb = Theme:ClassColor("PALADIN")
assert_eq(nr, nil, "unknown classFile returns nil")
assert_eq(ng, nil, "unknown classFile returns no g")
assert_eq(nb, nil, "unknown classFile returns no b")
assert_eq(Theme:ClassColor("mage"), nil, "classFile lookup is case-sensitive")
assert_eq(Theme:ClassColor(nil), nil, "nil classFile is nil")
assert_eq(Theme:ClassColor(1), nil, "numeric classFile is nil")

local savedColors = RAID_CLASS_COLORS
RAID_CLASS_COLORS = nil
assert_eq(Theme:ClassColor("MAGE"), nil, "missing RAID_CLASS_COLORS returns nil")
RAID_CLASS_COLORS = { MAGE = { r = "nope", g = 1, b = 1 } }
assert_eq(Theme:ClassColor("MAGE"), nil, "non-numeric class entry returns nil")
RAID_CLASS_COLORS = savedColors

--------------------------------------------------------------------------------
-- FontPath: shipped Media path, then stock fallback when the role is cleared.
--------------------------------------------------------------------------------

assert_true(type(Theme.FontSize) == "table", "FontSize table is public")
assert_eq(Theme.FontSize.headline, 22, "headline size")
assert_eq(Theme.FontSize.name, 18, "name size")
assert_eq(Theme.FontSize.label, 12, "label size")
assert_eq(Theme.FontSize.body, 12, "body size")
assert_eq(Theme.FontSize.caption, 12, "caption is the 12px stream floor")
assert_true(Theme.FontSize.headline >= 16, "headline never below 16")
assert_true(Theme.FontSize.name >= 16, "name never below 16")
assert_true(Theme.FontSize.caption >= 12, "caption never below 12")

assert_true(type(Theme.Space) == "table", "Space table is public")
assert_eq(Theme.Space.xs, 4, "xs is 4")
assert_eq(Theme.Space.sm, 8, "sm is 8")
assert_eq(Theme.Space.md, 16, "md is 16")
assert_eq(Theme.Space.lg, 24, "lg is 24")
assert_eq(Theme.Space.rule, 2, "gold hairline is 2px")
assert_eq(Theme.Space.band, 48, "title band is 48")
assert_eq(Theme.Space.footer, 40, "footer band is 40")

local MEDIA = "Interface\\AddOns\\ChurchOfBeef\\Media\\Fonts\\"

local display = Theme:FontPath("display")
assert_true(type(display) == "string", "display FontPath is a string")
assert_true(display:find(MEDIA, 1, true) == 1, "display uses the addon Media prefix")
assert_true(display:find("GrenzeGotisch%-Regular%.ttf") ~= nil
  or display:find("GrenzeGotisch", 1, true) ~= nil, "display is the stream-readable static blackletter")

local label = Theme:FontPath("label")
assert_true(label:find(MEDIA, 1, true) == 1, "label uses the addon Media prefix")
assert_true(label:find("EBGaramond", 1, true) ~= nil, "label is the shipped serif")
assert_true(label:find("EBGaramond%-Regular%.ttf") ~= nil
  or label:find("EBGaramond-Regular", 1, true) ~= nil, "label is static Regular, not [wght]")

local body = Theme:FontPath("body")
assert_true(body:find(MEDIA, 1, true) == 1, "body uses the addon Media prefix")
assert_true(body:find("EBGaramond", 1, true) ~= nil, "body is the shipped serif")

assert_eq(Theme:FontPath("headline"), nil, "unknown font role is nil")
assert_eq(Theme:FontPath(nil), nil, "nil font role is nil")

local savedDisplay = Theme.SHIPPED_FONTS.display
local savedLabel = Theme.SHIPPED_FONTS.label
local savedBody = Theme.SHIPPED_FONTS.body

Theme.SHIPPED_FONTS.display = nil
assert_eq(Theme:FontPath("display"), "Fonts\\MORPHEUS.TTF", "absent display falls back to MORPHEUS")
Theme.SHIPPED_FONTS.display = ""
assert_eq(Theme:FontPath("display"), "Fonts\\MORPHEUS.TTF", "empty display falls back to MORPHEUS")
Theme.SHIPPED_FONTS.display = savedDisplay

Theme.SHIPPED_FONTS.label = nil
assert_eq(Theme:FontPath("label"), "Fonts\\FRIZQT__.TTF", "absent label falls back to FRIZQT")
Theme.SHIPPED_FONTS.label = savedLabel

Theme.SHIPPED_FONTS.body = nil
assert_eq(Theme:FontPath("body"), "Fonts\\FRIZQT__.TTF", "absent body falls back to FRIZQT")
Theme.SHIPPED_FONTS.body = savedBody

assert_true(type(Theme.SHIPPED_FONTS.GrenzeGotisch) == "string", "Grenze Gotisch is inventoried")
assert_true(type(Theme.SHIPPED_FONTS.UnifrakturMaguntia) == "string", "UnifrakturMaguntia is inventoried")
assert_true(type(Theme.SHIPPED_FONTS.EBGaramond) == "string", "EB Garamond is inventoried")
assert_true(type(Theme.SHIPPED_FONTS.Alegreya) == "string", "Alegreya is inventoried")

--------------------------------------------------------------------------------
-- Texture: stock when the manifest is nil; manifest wins; unknown → nil.
--------------------------------------------------------------------------------

local SEMANTIC = {
  "seal_papal",
  "sigil_gora",
  "seal_cowardice",
  "seal_victor",
  "frame_proclamation",
  "frame_proclamation_corner_tl",
  "frame_proclamation_corner_tr",
  "frame_proclamation_corner_bl",
  "frame_proclamation_corner_br",
  "frame_proclamation_edge_top",
  "frame_proclamation_edge_bottom",
  "frame_proclamation_edge_left",
  "frame_proclamation_edge_right",
  "frame_proclamation_center",
  "frame_proclamation_pin_tl",
  "frame_proclamation_pin_tr",
  "frame_proclamation_pin_bl",
  "frame_proclamation_pin_br",
  "bar_stainedglass_fill",
  "bar_favor_fill",
  "sigil_favor",
  "roundel_minimap",
  "roundel_minimap_pushed",
  "roundel_minimap_highlight",
  "parchment_decree",
  "ornament_nail",
  "banner_knighting",
  "rays_sunburst",
  "tome_records",
  "ribbon_bookmark",
  "frame_fightercard",
  "ornament_bullhorn",
  "plate_verb",
  "plate_verb_hover",
  "plate_verb_pressed",
  "glyph_record",
  "glyph_defenses",
  "glyph_headtohead",
  "glyph_stipulation",
  "close_up",
  "close_down",
  "close_highlight",
  "close_disabled",
  "stock_dialog_bg",
  "stock_dialog_border",
  "stock_tooltip_bg",
  "stock_tooltip_border",
  "stock_grabber_up",
  "stock_grabber_down",
  "stock_grabber_highlight",
}

local SEALS = {
  seal_papal = true,
  sigil_gora = true,
  seal_cowardice = true,
  seal_victor = true,
}

local function has_faction(path)
  if path:find("PVP", 1, true) or path:find("PvP", 1, true) or path:find("pvp", 1, true) then
    return true
  end
  if path:find("Alliance", 1, true) or path:find("Horde", 1, true) then
    return true
  end
  if path:find("PVP-Banner", 1, true) or path:find("PVP-Currency", 1, true) then
    return true
  end
  return false
end

ChurchOfBeefMediaManifest = nil
local stockPapal = Theme:Texture("seal_papal")

for i = 1, #SEMANTIC do
  local name = SEMANTIC[i]
  local path = Theme:Texture(name)
  assert_true(type(path) == "string" and path ~= "", name .. " has a stock fallback")
  assert_eq(has_faction(path), false, name .. " stock is not a faction crest")
  if SEALS[name] then
    assert_eq(path:lower():find("skull", 1, true), nil, name .. " stock is not a skull")
    assert_eq(path:find("ClassIcon", 1, true), nil, name .. " stock is not a class icon")
    assert_eq(path:find("Interface\\Icons\\Class", 1, true), nil, name .. " stock is not a class-icon path")
  end
end

assert_eq(Theme:Texture("bar_stainedglass_fill"), "Interface\\TargetingFrame\\UI-StatusBar",
  "stained-glass fill is the tintable status bar")
assert_eq(Theme:Texture("bar_favor_fill"), "Interface\\TargetingFrame\\UI-StatusBar",
  "favor fill is the tintable status bar")
assert_eq(Theme.CloseSize, 32, "close is the stock 32px window X")
assert_eq(Theme:Texture("close_up"), "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
  "close_up is the stock panel X")
assert_eq(type(Theme.CloseButton), "function", "Theme:CloseButton is the shared factory")

assert_eq(Theme:Texture("not_a_texture"), nil, "unknown texture name is nil")
assert_eq(Theme:Texture(nil), nil, "nil texture name is nil")
assert_eq(Theme:Texture(1), nil, "numeric texture name is nil")

local MANIFEST_PATH = "Interface\\AddOns\\ChurchOfBeef\\Media\\Seals\\seal_papal.tga"
ChurchOfBeefMediaManifest = { seal_papal = MANIFEST_PATH }
assert_eq(Theme:Texture("seal_papal"), MANIFEST_PATH, "manifest path wins over stock")
assert_eq(Theme:Texture("sigil_gora"), "Interface\\Buttons\\UI-Quickslot2",
  "names absent from the manifest still use stock")

ChurchOfBeefMediaManifest = { seal_papal = "" }
assert_eq(Theme:Texture("seal_papal"), stockPapal, "empty manifest value falls through to stock")

ChurchOfBeefMediaManifest = { seal_papal = 12 }
assert_eq(Theme:Texture("seal_papal"), stockPapal, "non-string manifest value falls through to stock")

ChurchOfBeefMediaManifest = "not-a-table"
assert_eq(Theme:Texture("seal_papal"), stockPapal, "non-table manifest is ignored")

assert_eq(Theme:Texture("stock_dialog_bg"), "Interface\\DialogFrame\\UI-DialogBox-Background",
  "dialog fill is the LootFrame stock")
assert_eq(Theme:Texture("stock_tooltip_bg"), "Interface\\Tooltips\\UI-Tooltip-Background",
  "tooltip fill is the Inputs stock")
assert_eq(Theme:Texture("stock_grabber_up"), "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up",
  "size grabber is the chat grip")

local dialog = Theme:Backdrop("dialog")
assert_true(type(dialog) == "table", "dialog backdrop exists")
assert_eq(dialog.bgFile, "Interface\\DialogFrame\\UI-DialogBox-Background", "dialog bgFile")
assert_eq(dialog.edgeFile, "Interface\\DialogFrame\\UI-DialogBox-Border", "dialog edgeFile")
assert_eq(dialog.tileSize, 32, "dialog tile matches LootFrame")
assert_eq(dialog.insets.left, 11, "dialog left inset matches LootFrame")
dialog.tileSize = 99
assert_eq(Theme:Backdrop("dialog").tileSize, 32, "Backdrop returns a copy")
assert_eq(Theme:Backdrop("paper").bgFile, "Interface\\QuestFrame\\QuestBG",
  "paper fill is QuestBG")
assert_eq(Theme:Backdrop("missing"), nil, "unknown backdrop kind is nil")

local fake = {
  SetBackdrop = function(self, spec) self._spec = spec end,
  SetBackdropColor = function(self, r, g, b, a)
    self._fill = { r = r, g = g, b = b, a = a }
  end,
  SetBackdropBorderColor = function(self, r, g, b, a)
    self._edge = { r = r, g = g, b = b, a = a }
  end,
}
assert_eq(Theme:ApplyBackdrop(nil, "tooltip"), false, "nil frame is refused")
assert_true(Theme:ApplyBackdrop(fake, "tooltip", "charcoal", "gold", 0.96),
  "ApplyBackdrop paints a tooltip")
assert_eq(fake._cobBackdrop, "tooltip", "kind is recorded")
assert_eq(fake._spec.bgFile, "Interface\\Tooltips\\UI-Tooltip-Background",
  "applied spec is the tooltip table")
assert_eq(fake._fill.a, 0.96, "fill alpha is honored")
assert_eq(type(Theme.PanelButton), "function", "Theme:PanelButton is the shared factory")

--------------------------------------------------------------------------------
-- Restore globals the suite touched.
--------------------------------------------------------------------------------

ChurchOfBeefMediaManifest = savedManifest
RAID_CLASS_COLORS = savedClassColors
CreateFrame = savedCreateFrame
assert_eq(frames, 0, "Theme created no frames during the suite")

if standalone then
  print(string.format("Tests finished: %d passed, %d failed", passed, failed))
  if failed > 0 then os.exit(1) end
end
