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
--   gathering  night-chip umber (weekly Church night)
--   knighting  night-chip bronze (sacred elevation; dark, not bright gold)
--   gora       night-chip steel (sanctioned combat)
--   notice     night-chip pewter (Discord stub)
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
-- Typography: display = Grenze Gotisch Regular; label/body = EB Garamond
-- Regular. Grenze keeps the blackletter/ecclesiastical voice while remaining
-- legible in 18–22px stream captures; Unifraktur remains inventoried for
-- larger decorative use.
-- Anniversary SetFont does not reliably load variable TTFs, and a "[wght]"
-- filename can fail the file lookup — both drop the surface to Friz and
-- read as an unfinished addon. SHIPPED_FONTS therefore points at static
-- Regular instances (fontTools instancer, 2026-08-18). The google/fonts
-- variable sources stay on disk as inventory; Grenze Gotisch Regular and
-- Alegreya Regular are the swap candidates.
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
--   close_up, close_down, close_highlight, close_disabled
-- Close chrome is Theme:CloseButton — the stock 32px window X. Surfaces
-- must not invent CLOSE word plates. Missing stock art falls back to a
-- gold X so load never fails.
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
  gathering    = { 74,  52,  36  }, -- #4A3424
  knighting    = { 72,  56,  28  }, -- #48381C
  gora         = { 36,  48,  58  }, -- #24303A
  notice       = { 52,  50,  46  }, -- #34322E
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
  display = "GrenzeGotisch/GrenzeGotisch-Regular.ttf",
  label   = "EBGaramond/EBGaramond-Regular.ttf",
  body    = "EBGaramond/EBGaramond-Regular.ttf",
  -- inventory (static Regular; variable sources remain beside these)
  GrenzeGotisch      = "GrenzeGotisch/GrenzeGotisch-Regular.ttf",
  UnifrakturMaguntia = "UnifrakturMaguntia/UnifrakturMaguntia-Book.ttf",
  EBGaramond         = "EBGaramond/EBGaramond-Regular.ttf",
  Alegreya           = "Alegreya/Alegreya-Regular.ttf",
}

-- Recommended sizes for dress lanes. Blackletter (headline / name) never
-- below 16. caption is serif only and never below the 12px stream floor
-- (10px on parchment failed the 2026-08-18 in-client pass).
Theme.FontSize = {
  headline = 22,
  name     = 18,
  label    = 12,
  body     = 12,
  caption  = 12,
}

-- Shared rhythm for theatrical composition. Surfaces read these instead of
-- inventing 5/6/10/14 leftovers. rule is the gold hairline thickness.
Theme.Space = {
  xs     = 4,
  sm     = 8,
  md     = 16,
  lg     = 24,
  xl     = 32,
  rule   = 2,
  band   = 48,
  footer = 40,
  nail   = 8,
  seal   = 28,
  glyph  = 14,
  close  = 32,
}

-- Stock UIPanelCloseButton size. Theme:CloseButton reads this so every
-- player-opened window uses the same X.
Theme.CloseSize = 32

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

  -- Minimap roundel: neutral disc when custom bull art is unavailable.
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

  -- Stock window X (UIPanelCloseButtonNoScripts on Anniversary).
  close_up        = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
  close_down      = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down",
  close_highlight = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight",
  close_disabled  = "Interface\\Buttons\\UI-Panel-MinimizeButton-Disabled",

  -- Shared FrameXML chrome (LootFrame dialog; tooltip used by Inputs).
  stock_dialog_bg          = "Interface\\DialogFrame\\UI-DialogBox-Background",
  stock_dialog_border      = "Interface\\DialogFrame\\UI-DialogBox-Border",
  stock_tooltip_bg         = "Interface\\Tooltips\\UI-Tooltip-Background",
  stock_tooltip_border     = "Interface\\Tooltips\\UI-Tooltip-Border",
  stock_grabber_up         = "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up",
  stock_grabber_down       = "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down",
  stock_grabber_highlight  = "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight",
}

-- Anniversary-verified backdrop tables. dialog matches LootFrame.lua.
Theme.BACKDROP = {
  dialog = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
  },
  tooltip = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  },
  paper = {
    bgFile = "Interface\\QuestFrame\\QuestBG",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 256,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  },
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

-- Shared window close. Parent may be a real client userdata frame.
-- Does not mint frames at load. Caller owns Show/Hide.
function Theme:CloseButton(parent, onClick)
  if type(CreateFrame) ~= "function" or parent == nil then return nil end
  local size = Theme.CloseSize
  if type(size) ~= "number" then size = 32 end

  local button
  local ok, minted = pcall(CreateFrame, "Button", nil, parent, "UIPanelCloseButtonNoScripts")
  if ok and minted then
    button = minted
  else
    button = CreateFrame("Button", nil, parent)
  end
  if not button then return nil end

  button:SetWidth(size)
  button:SetHeight(size)
  button._cobClose = true

  local function dress(method, name, extra)
    local setter = button[method]
    if type(setter) ~= "function" then return false end
    local path = Theme:Texture(name)
    if type(path) ~= "string" or path == "" then return false end
    if extra then
      return pcall(setter, button, path, extra)
    end
    return pcall(setter, button, path)
  end

  local painted = dress("SetNormalTexture", "close_up")
  dress("SetPushedTexture", "close_down")
  dress("SetHighlightTexture", "close_highlight", "ADD")
  dress("SetDisabledTexture", "close_disabled")

  if not painted and button.CreateFontString then
    local fs = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    if fs then
      local r, g, b = Theme:Color("gold")
      if fs.SetTextColor and type(r) == "number" then
        fs:SetTextColor(r, g, b, 1)
      end
      if fs.SetAllPoints then fs:SetAllPoints(button) end
      if fs.SetJustifyH then fs:SetJustifyH("CENTER") end
      if fs.SetText then fs:SetText("X") end
      if button.SetFontString then button:SetFontString(fs) end
    end
    if button.SetText then button:SetText("X") end
  end

  if type(onClick) == "function" and button.SetScript then
    button:SetScript("OnClick", onClick)
  end
  return button
end

function Theme:Backdrop(kind)
  local spec = Theme.BACKDROP[kind]
  if type(spec) ~= "table" then return nil end
  local out = {
    bgFile = spec.bgFile,
    edgeFile = spec.edgeFile,
    tile = spec.tile,
    tileSize = spec.tileSize,
    edgeSize = spec.edgeSize,
  }
  if type(spec.insets) == "table" then
    out.insets = {
      left = spec.insets.left,
      right = spec.insets.right,
      top = spec.insets.top,
      bottom = spec.insets.bottom,
    }
  end
  return out
end

local function widgetFn(frame, name)
  if frame == nil or type(name) ~= "string" then return nil end
  local ok, fn = pcall(function() return frame[name] end)
  if ok and type(fn) == "function" then return fn end
  return nil
end

function Theme:ApplyBackdrop(frame, kind, fillRole, edgeRole, fillAlpha)
  if frame == nil then return false end
  local spec = Theme:Backdrop(kind)
  if not spec then return false end
  local setBackdrop = widgetFn(frame, "SetBackdrop")
  if not setBackdrop then return false end
  local ok = pcall(setBackdrop, frame, spec)
  if not ok then return false end
  local fr, fg, fb = Theme:Color(fillRole or "charcoal")
  local setColor = widgetFn(frame, "SetBackdropColor")
  if type(fr) == "number" and setColor then
    pcall(setColor, frame, fr, fg, fb, fillAlpha or 1)
  end
  local er, eg, eb = Theme:Color(edgeRole or "gold")
  local setBorder = widgetFn(frame, "SetBackdropBorderColor")
  if type(er) == "number" and setBorder then
    pcall(setBorder, frame, er, eg, eb, 1)
  end
  frame._cobBackdrop = kind
  return true
end

function Theme:PanelButton(parent, text, onClick)
  if type(CreateFrame) ~= "function" or parent == nil then return nil end
  local button
  local ok, minted = pcall(CreateFrame, "Button", nil, parent, "UIPanelButtonTemplate")
  if ok and minted then
    button = minted
    button._cobStockTemplate = "UIPanelButtonTemplate"
  else
    button = CreateFrame("Button", nil, parent)
  end
  if not button then return nil end
  if type(text) == "string" and button.SetText then button:SetText(text) end
  if type(onClick) == "function" and button.SetScript then
    button:SetScript("OnClick", onClick)
  end
  return button
end
