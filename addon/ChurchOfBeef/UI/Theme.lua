ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Church of Beef design system (lane U-B). Theatrical surfaces resolve every
-- color, font, and texture through this module. Surfaces must never hardcode
-- color literals, font paths, or Media/ paths.
--
-- Color roles (Theme:Color):
--   gold       sacred / affirmative / victory
--   oxblood    rulings and finality — red means nothing else anywhere
--   parchment  content (light); parchmentMid is the aged mid tone
--   iron       chrome (dark iron); charcoal is the deeper ground
--   silver     aged metal / quiet secondary
-- Unknown role → nil (no invented tint).
--
-- Class colors (Theme:ClassColor): passthrough of RAID_CLASS_COLORS[classFile]
-- as r,g,b. Lookup is the FrameXML key (WARRIOR, MAGE, …). Unknown classFile,
-- a missing table, or a non-numeric entry → nil. Dress lanes may fall back to
-- Theme:Color("silver"); Theme never invents a class tint.
--
-- Fonts (Theme:FontPath):
--   display  blackletter — proclamation headlines and fighter names ONLY,
--            never below ~16px (see Theme.FontSize.headline / .name)
--   label    serif small caps — format lines and ledger labels
--   body     serif — running text
-- SHIPPED_FONTS role keys point at OFL files under Media/Fonts/. Family keys
-- record what actually landed (both blackletter and both serif candidates).
-- Absent or empty role → stock: display Fonts\MORPHEUS.TTF, label/body
-- Fonts\FRIZQT__.TTF. Missing media must not fail load.
--
-- Variable-font caveat: google/fonts ships Grenze Gotisch, EB Garamond, and
-- Alegreya as variable TTFs only (filename "[wght]"). UnifrakturMaguntia is
-- the one static blackletter. Typography LOCKED 2026-08-18 (David delegated
-- the pick): display = UnifrakturMaguntia (static — no default-instance
-- weight gamble; the traditional fraktur is the Church's voice), label/body
-- = EBGaramond (variable, but its default instance is regular 400 — the
-- book serif the ledger wants). Grenze Gotisch and Alegreya stay on disk as
-- the alternates; a swap is the one-line SHIPPED_FONTS edit below.
--
-- Textures (Theme:Texture):
--   1. global ChurchOfBeefMediaManifest[name] (generated Media/manifest.lua;
--      may be nil) — value is a full Interface\AddOns\ChurchOfBeef\Media\ path
--   2. curated STOCK table in this file (Blizzard stock; never a faction
--      crest, never a plain skull for a seal, never a class icon for a seal)
--   3. nil
-- Bar fills are grayscale/white-tintable so SetVertexColor can apply class
-- colors.
--
-- Semantic names and the proclamation 9-slice scheme:
--   seal_papal, sigil_gora, seal_cowardice, seal_victor
--   frame_proclamation                 single-piece fallback
--   frame_proclamation_corner_{tl,tr,bl,br}
--   frame_proclamation_edge_{top,bottom,left,right}
--   frame_proclamation_center          parchment fill
--   frame_proclamation_pin_{tl,tr,bl,br}  iron corner-pin ornaments
--   bar_stainedglass_fill, bar_favor_fill, sigil_favor
--   roundel_minimap, roundel_minimap_pushed, roundel_minimap_highlight
--   parchment_decree, ornament_nail, banner_knighting, rays_sunburst
--   tome_records, ribbon_bookmark, frame_fightercard, ornament_bullhorn
--   plate_verb, plate_verb_hover, plate_verb_pressed
--   glyph_record, glyph_defenses, glyph_headtohead, glyph_stipulation
-- Fighter-card parchment reuses the proclamation center fill when custom
-- art lands; the single frame_fightercard name is the whole-card fallback.

local Theme = {}
COB.Theme = Theme

--------------------------------------------------------------------------------
-- Palette
--------------------------------------------------------------------------------

-- Integer 0–255 channels. Color() divides by 255 so callers get 0–1 floats.
local PALETTE = {
  iron         = { 42,  38,  34  }, -- #2A2622
  charcoal     = { 28,  26,  23  }, -- #1C1A17
  parchment    = { 228, 214, 176 }, -- #E4D6B0
  parchmentMid = { 217, 201, 163 }, -- #D9C9A3
  gold         = { 201, 165, 74  }, -- #C9A54A
  oxblood      = { 110, 31,  31  }, -- #6E1F1F
  silver       = { 154, 150, 142 }, -- #9A968E
}

function Theme:Color(role)
  local rgb = PALETTE[role]
  if not rgb then return nil end
  return rgb[1] / 255, rgb[2] / 255, rgb[3] / 255
end

function Theme:ClassColor(classFile)
  if type(classFile) ~= "string" then return nil end
  local colors = _G.RAID_CLASS_COLORS
  if type(colors) ~= "table" then return nil end
  local entry = colors[classFile]
  if type(entry) ~= "table" then return nil end
  local r, g, b = entry.r, entry.g, entry.b
  if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
    return nil
  end
  return r, g, b
end

--------------------------------------------------------------------------------
-- Fonts
--------------------------------------------------------------------------------

local MEDIA_FONTS = "Interface\\AddOns\\ChurchOfBeef\\Media\\Fonts\\"

local STOCK_FONTS = {
  display = "Fonts\\MORPHEUS.TTF",
  label   = "Fonts\\FRIZQT__.TTF",
  body    = "Fonts\\FRIZQT__.TTF",
}

-- Role keys drive FontPath. Family keys are the on-disk inventory (both
-- blackletter candidates, both serif candidates). Swap a role key after the
-- in-client pick; do not hardcode these paths outside this file.
Theme.SHIPPED_FONTS = {
  display = "UnifrakturMaguntia/UnifrakturMaguntia-Book.ttf",
  label   = "EBGaramond/EBGaramond[wght].ttf",
  body    = "EBGaramond/EBGaramond[wght].ttf",
  -- inventory
  GrenzeGotisch      = "GrenzeGotisch/GrenzeGotisch[wght].ttf",
  UnifrakturMaguntia = "UnifrakturMaguntia/UnifrakturMaguntia-Book.ttf",
  EBGaramond         = "EBGaramond/EBGaramond[wght].ttf",
  Alegreya           = "Alegreya/Alegreya[wght].ttf",
}

-- Recommended sizes for dress lanes. Blackletter (headline / name) never
-- below 16. caption is serif only.
Theme.FontSize = {
  headline = 22,
  name     = 18,
  label    = 12,
  body     = 12,
  caption  = 10,
}

function Theme:FontPath(role)
  if STOCK_FONTS[role] == nil then return nil end
  local shipped = Theme.SHIPPED_FONTS[role]
  if type(shipped) == "string" and shipped ~= "" then
    return MEDIA_FONTS .. shipped:gsub("/", "\\")
  end
  return STOCK_FONTS[role]
end

--------------------------------------------------------------------------------
-- Textures
--------------------------------------------------------------------------------

-- Stock fallbacks: verified in classic_anniversary / classic_era FrameXML
-- where noted, or already used in this addon. No PVP / faction-crest paths,
-- no skull seals, no class-icon seals. Bars are UI-StatusBar (tintable).
local STOCK = {
  -- Seals / sigils: circular metal slots, tintable. Not icons.
  seal_papal      = "Interface\\Buttons\\UI-EmptySlot-White",
  sigil_gora      = "Interface\\Buttons\\UI-Quickslot2",
  seal_cowardice  = "Interface\\Buttons\\UI-EmptySlot",
  seal_victor     = "Interface\\Buttons\\UI-EmptySlot-White",

  -- Proclamation frame: parchment fill + iron dialog chrome + stud pins.
  frame_proclamation            = "Interface\\QuestFrame\\QuestBG",
  frame_proclamation_corner_tl  = "Interface\\DialogFrame\\UI-DialogBox-Corner",
  frame_proclamation_corner_tr  = "Interface\\DialogFrame\\UI-DialogBox-Corner",
  frame_proclamation_corner_bl  = "Interface\\DialogFrame\\UI-DialogBox-Corner",
  frame_proclamation_corner_br  = "Interface\\DialogFrame\\UI-DialogBox-Corner",
  frame_proclamation_edge_top   = "Interface\\Tooltips\\UI-Tooltip-Border",
  frame_proclamation_edge_bottom = "Interface\\Tooltips\\UI-Tooltip-Border",
  frame_proclamation_edge_left  = "Interface\\Tooltips\\UI-Tooltip-Border",
  frame_proclamation_edge_right = "Interface\\Tooltips\\UI-Tooltip-Border",
  frame_proclamation_center     = "Interface\\QuestFrame\\QuestBG",
  frame_proclamation_pin_tl     = "Interface\\Buttons\\UI-RadioButton",
  frame_proclamation_pin_tr     = "Interface\\Buttons\\UI-RadioButton",
  frame_proclamation_pin_bl     = "Interface\\Buttons\\UI-RadioButton",
  frame_proclamation_pin_br     = "Interface\\Buttons\\UI-RadioButton",

  -- Tintable grayscale fills (class / fighter color applied in dress).
  bar_stainedglass_fill = "Interface\\TargetingFrame\\UI-StatusBar",
  bar_favor_fill        = "Interface\\TargetingFrame\\UI-StatusBar",
  sigil_favor           = "Interface\\Buttons\\UI-CheckBox-Up",

  -- Minimap roundel: neutral disc until the bull art lands.
  roundel_minimap            = "Interface\\Minimap\\UI-Minimap-Background",
  roundel_minimap_pushed     = "Interface\\Buttons\\UI-Quickslot-Depress",
  roundel_minimap_highlight  = "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight",

  parchment_decree  = "Interface\\QuestFrame\\QuestBG",
  ornament_nail     = "Interface\\Buttons\\UI-SliderBar-Button-Horizontal",
  banner_knighting  = "Interface\\QuestFrame\\QuestBG",
  rays_sunburst     = "Interface\\Cooldown\\star4",
  tome_records      = "Interface\\Spellbook\\Spellbook-Icon",
  ribbon_bookmark   = "Interface\\QuestFrame\\UI-QuestLogSortTab-Middle",
  frame_fightercard = "Interface\\QuestFrame\\QuestBG",
  ornament_bullhorn = "Interface\\Buttons\\UI-EmptySlot-White",

  -- Console sacred-verb plates (the one ornament the plain desk may wear).
  plate_verb         = "Interface\\Buttons\\UI-Panel-Button-Up",
  plate_verb_hover   = "Interface\\Buttons\\UI-Panel-Button-Highlight",
  plate_verb_pressed = "Interface\\Buttons\\UI-Panel-Button-Down",

  -- Ledger glyphs: stock marks, not class icons.
  glyph_record      = "Interface\\Spellbook\\Spellbook-Icon",
  glyph_defenses    = "Interface\\Buttons\\UI-CheckBox-Up",
  glyph_headtohead  = "Interface\\Buttons\\UI-RadioButton",
  glyph_stipulation = "Interface\\Buttons\\UI-CheckBox-Check",
}

function Theme:Texture(name)
  if type(name) ~= "string" then return nil end
  local manifest = _G.ChurchOfBeefMediaManifest
  if type(manifest) == "table" then
    local path = manifest[name]
    if type(path) == "string" and path ~= "" then
      return path
    end
  end
  return STOCK[name]
end
