ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode theatrical proclamation/verdict beats (Law 6) — the one toast
-- engine. Quiet Mode does not drive this file. Grant-driven kinds are gone.
-- Promote / rite copy builders and those KINDS are gone. The small-toast
-- engine (Show / Push / Celebrate and its queue and frame) is retired: it
-- had zero callers. Proclaim is the only entry: sanction / verdict /
-- cowardice / knighting / elevation.
-- Clerical copy only. Never generate oratory. Never SendChatMessage.
-- Theatrical dress (color, font, texture) resolves only through COB.Theme,
-- so this file holds no color or path literals.
local Toasts = { MODE = "Event" }
COB.Toasts = Toasts

local THEATER_KINDS = {
  sanction = true,
  verdict = true,
  cowardice = true,
  knighting = true,
  elevation = true,
}

local THEATER_HOLD = 5
local PROCLAIM_NAME = "ChurchOfBeefProclaim"
local DIM_ALPHA = 0.45
local PANEL_FALLBACK_W = 420
-- Locked parchment inset. Not Theme.Space (4/8/16…); the frame art is cut for 12.
local PROCLAIM_INSET = 12
-- Full-surface masters retain the production pack's 12% transparent safety
-- margin. Crop that margin at render time instead of shipping edge-touching
-- source art.
local SURFACE_U0, SURFACE_U1 = 0.12, 0.88

local theaterGen = 0

local function after(seconds, fn)
  if C_Timer and C_Timer.After then
    C_Timer.After(seconds, fn)
    return
  end
  -- One-shot fallback only; script cleared when done (no permanent OnUpdate).
  local ticker = CreateFrame("Frame")
  local elapsed = 0
  ticker:SetScript("OnUpdate", function(self, delta)
    elapsed = elapsed + (delta or 0)
    if elapsed >= seconds then
      self:SetScript("OnUpdate", nil)
      fn()
    end
  end)
end

local function themeColor(role)
  local Theme = COB.Theme
  if type(Theme) ~= "table" or type(Theme.Color) ~= "function" then
    return nil
  end
  local r, g, b = Theme:Color(role)
  if type(r) ~= "number" then return nil end
  return r, g, b
end

local function themeTexture(name)
  local Theme = COB.Theme
  if type(Theme) ~= "table" or type(Theme.Texture) ~= "function" then
    return nil
  end
  local path = Theme:Texture(name)
  if type(path) ~= "string" or path == "" then return nil end
  return path
end

local function themeFontPath(role)
  local Theme = COB.Theme
  if type(Theme) ~= "table" or type(Theme.FontPath) ~= "function" then
    return nil
  end
  local path = Theme:FontPath(role)
  if type(path) ~= "string" or path == "" then return nil end
  return path
end

local function themeFontSize(key)
  local Theme = COB.Theme
  local sizes = type(Theme) == "table" and Theme.FontSize or nil
  if type(sizes) ~= "table" then return nil end
  local n = sizes[key]
  if type(n) ~= "number" then return nil end
  return n
end

local function space(key, fallback)
  local Theme = COB.Theme
  local sizes = type(Theme) == "table" and Theme.Space or nil
  if type(sizes) == "table" and type(sizes[key]) == "number" then
    return sizes[key]
  end
  return fallback
end

local function applySlot(tex, name)
  if not tex then return nil end
  local path = themeTexture(name)
  tex._cobName = name
  tex._cobPath = path
  if path and tex.SetTexture then
    pcall(tex.SetTexture, tex, path)
  end
  if name == "frame_proclamation_center" and tex.SetTexCoord then
    pcall(tex.SetTexCoord, tex, SURFACE_U0, SURFACE_U1, SURFACE_U0, SURFACE_U1)
  end
  return path
end

local function applyTint(tex, role, a)
  local r, g, b = themeColor(role)
  if type(r) ~= "number" then return end
  if not a then a = 1 end
  if tex and tex.SetVertexColor then
    pcall(tex.SetVertexColor, tex, r, g, b, a)
  end
  if tex then
    tex._cobRole = role
    tex._cobR, tex._cobG, tex._cobB, tex._cobA = r, g, b, a
  end
  return r, g, b
end

local function applyFill(tex, role, a)
  local r, g, b = themeColor(role)
  if type(r) ~= "number" or not tex then return end
  if not a then a = 1 end
  tex._cobRole = role
  tex._cobR, tex._cobG, tex._cobB, tex._cobA = r, g, b, a
  if tex.SetColorTexture then
    pcall(tex.SetColorTexture, tex, r, g, b, a)
    return r, g, b
  end
  applySlot(tex, "bar_stainedglass_fill")
  if tex.SetVertexColor then
    pcall(tex.SetVertexColor, tex, r, g, b, a)
  end
  return r, g, b
end

local function applyTextColor(fs, role)
  local r, g, b = themeColor(role)
  if type(r) ~= "number" or not fs or not fs.SetTextColor then return end
  pcall(fs.SetTextColor, fs, r, g, b, 1)
  fs._cobRole = role
  fs._cobR, fs._cobG, fs._cobB, fs._cobA = r, g, b, 1
end

--------------------------------------------------------------------------------
-- Theatrical overlay (sanction / verdict / cowardice / knighting / elevation)
--------------------------------------------------------------------------------

local function theaterAllowed()
  local runtime = COB.Runtime
  if type(runtime) ~= "table" or type(runtime.Snapshot) ~= "function" then
    return false
  end
  local snap = runtime:Snapshot()
  local state = type(snap) == "table" and snap.state or nil
  if state == nil or state == "QUIET" then
    return false
  end
  return true
end

local function applyHeadlineFont(fs, theater, overrideSize)
  if not fs then return end
  local path = themeFontPath("display")
  local size = overrideSize or themeFontSize("headline")
  if type(size) ~= "number" or size < 16 then size = 22 end
  local used = false
  if path and fs.SetFont then
    local ok, applied = pcall(fs.SetFont, fs, path, size)
    used = ok and applied and true or false
  end
  if not used and fs.SetFontObject then
    local font = GameFontNormalLarge
    if type(font) == "string" then font = _G[font] end
    if font then pcall(fs.SetFontObject, fs, font) end
  end
  if theater then theater.headlineFontPath = path end
  fs._cobFontPath = path
end

local function applyBodyFont(fs, theater)
  if not fs then return end
  local path = themeFontPath("body")
  local size = themeFontSize("body")
  if type(size) ~= "number" then size = 12 end
  local used = false
  if path and fs.SetFont then
    local ok, applied = pcall(fs.SetFont, fs, path, size)
    used = ok and applied and true or false
  end
  if not used and fs.SetFontObject then
    local font = GameFontNormal
    if type(font) == "string" then font = _G[font] end
    if font then pcall(fs.SetFontObject, fs, font) end
  end
  if theater then theater.bodyFontPath = path end
  fs._cobFontPath = path
end

-- headline, body, chat. Chat may differ from the panel split (B9-D victor echo).
local function clericalCopy(kind, fields)
  if type(fields) ~= "table" then fields = {} end

  if kind == "sanction" then
    local a, b = fields.fighterA, fields.fighterB
    if type(a) ~= "string" or a == "" or type(b) ~= "string" or b == "" then
      return nil
    end
    -- Pomp headline stays. One plain gloss line under it (Task 13).
    local parts = { "A sanctioned duel.", a, "VS", b }
    local head = "A Beef Gora is Sanctioned"
    local body = table.concat(parts, "\n")
    return head, body, head .. "\n" .. body
  end

  if kind == "cowardice" then
    local name = fields.name
    if type(name) ~= "string" or name == "" then return nil end
    local line = "Cowardice recorded: " .. name .. " fled. So ruled by the Beef Pope."
    return line, "", line
  end

  if kind == "verdict" then
    local ruling = fields.ruling
    if ruling == "victor" then
      local name = fields.name
      if type(name) ~= "string" or name == "" then return nil end
      local chat = "Victor declared: " .. name .. ". So ruled by the Beef Pope."
      return "VICTOR DECLARED", name .. ". So ruled by the Beef Pope.", chat
    end
    if ruling == "void" then
      return "This fight does not count.", "", "This fight does not count."
    end
    if ruling == "free" then
      local text = fields.text
      if type(text) == "string" and text ~= "" then return text, "", text end
      return "Free ruling.", "", "Free ruling."
    end
  end

  if kind == "knighting" then
    local name = fields.name
    if type(name) ~= "string" or name == "" then return nil end
    return "RISE, BEEF KNIGHT", name, "RISE, BEEF KNIGHT\n" .. name
  end

  if kind == "elevation" then
    local name = fields.name
    if type(name) ~= "string" or name == "" then return nil end
    return "RISE, BEEF LORD", name, "RISE, BEEF LORD\n" .. name
  end

  return nil
end

local function accentRole(kind, fields)
  if kind == "cowardice" then return "oxblood" end
  if kind == "verdict" and type(fields) == "table" and fields.ruling == "victor" then
    return "gold"
  end
  if kind == "knighting" or kind == "elevation" then return "gold" end
  return "iron"
end

local function sealNameFor(kind, fields)
  if kind == "cowardice" then return "seal_cowardice" end
  if kind == "verdict" and type(fields) == "table" and fields.ruling == "victor" then
    return "seal_victor"
  end
  return "seal_papal"
end

local function panelWidth()
  local parentW
  if UIParent and UIParent.GetWidth then
    parentW = UIParent:GetWidth()
  end
  if type(parentW) == "number" and parentW > 0 then
    return math.floor(parentW / 3)
  end
  return PANEL_FALLBACK_W
end

local function playTheaterCue(kind)
  local sound = COB.Sound
  if type(sound) ~= "table" or type(sound.Play) ~= "function" then return end
  pcall(function()
    sound:Play(kind)
  end)
end

local function rememberSpecial(name)
  if type(UISpecialFrames) ~= "table" then return end
  for i = 1, #UISpecialFrames do
    if UISpecialFrames[i] == name then return end
  end
  UISpecialFrames[#UISpecialFrames + 1] = name
end

local theaterHiding = false

local function hideTheater(self)
  -- OnHide re-enters after root:Hide(); one dismiss bumps theaterGen once.
  if theaterHiding then return end
  theaterHiding = true
  theaterGen = theaterGen + 1
  local t = self.theater
  if t and t.root then t.root:Hide() end
  theaterHiding = false
end

local function wireProclaimEsc(self, root)
  if not root then return end
  if type(root.EnableMouse) == "function" then
    root:EnableMouse(true)
  end
  if type(root.SetScript) == "function" then
    local existing = type(root.GetScript) == "function" and root:GetScript("OnHide")
    if not existing then
      root:SetScript("OnHide", function()
        hideTheater(self)
      end)
    end
    if not (type(root.GetScript) == "function" and root:GetScript("OnMouseUp")) then
      root:SetScript("OnMouseUp", function()
        hideTheater(self)
      end)
    end
  end
  rememberSpecial(PROCLAIM_NAME)
end

local function mintTex(parent, layer)
  if not parent or type(parent.CreateTexture) ~= "function" then return nil end
  return parent:CreateTexture(nil, layer or "ARTWORK")
end

local function placeBox(tex, point, rel, relPoint, x, y, w, h)
  if not tex then return end
  if tex.ClearAllPoints then tex:ClearAllPoints() end
  tex:SetPoint(point, rel, relPoint, x, y)
  if w then tex:SetWidth(w) end
  if h then tex:SetHeight(h) end
end

local function isBannered(kind)
  return kind == "knighting" or kind == "elevation"
end

local function headlinePx()
  local size = themeFontSize("headline")
  if type(size) ~= "number" or size < 16 then return 22 end
  return size
end

-- The center-third sheet is intentionally narrow. Keep blackletter at a
-- stream-readable floor, but step down long fixed clerical lines before
-- wrapping so their capitals do not scrape the parchment edge.
local function responsiveHeadlinePx(text)
  local size = headlinePx()
  local chars = type(text) == "string" and #text or 0
  if chars > 22 then
    return math.max(18, size - 4)
  end
  if chars > 16 then
    return math.max(20, size - 2)
  end
  return size
end

local function bodyLeadPx()
  local size = themeFontSize("body")
  if type(size) ~= "number" then size = 12 end
  return size + space("xs", 4)
end

local function stampPx()
  return space("seal", 28)
end

local function bannerPx()
  -- Top ribbon on the sheet — not a second parchment fill.
  return space("band", 48)
end

local function theaterFloor()
  -- Four bands keep the four-line sanction body inside its parchment at the
  -- 1024x768 stream target. Short verdicts use the same steady silhouette
  -- rather than visibly collapsing between ceremony beats.
  return space("band", 48) * 4
end

-- Blackletter advance is ~1em. The old 0.7em char-split clipped long
-- clerical headlines (cowardice / free ruling) on the center-third sheet.
local function wrappedLines(text, px, innerW)
  if type(text) ~= "string" or text == "" then return 0 end
  if type(px) ~= "number" or px <= 0 then
    px = themeFontSize("body") or 12
  end
  if type(innerW) ~= "number" or innerW <= 0 then
    innerW = PANEL_FALLBACK_W - PROCLAIM_INSET * 2
  end
  local per = math.floor(innerW / px)
  if per < 1 then per = 1 end
  local total = 0
  for line in string.gmatch(text .. "\n", "(.-)\n") do
    if line == "" then
      total = total + 1
    else
      local rows = 1
      local used = 0
      for word in string.gmatch(line, "%S+") do
        local wlen = #word
        if used == 0 then
          if wlen <= per then
            used = wlen
          else
            rows = rows + math.ceil(wlen / per) - 1
            used = wlen % per
          end
        elseif used + 1 + wlen <= per then
          used = used + 1 + wlen
        else
          rows = rows + 1
          if wlen <= per then
            used = wlen
          else
            rows = rows + math.ceil(wlen / per) - 1
            used = wlen % per
          end
        end
      end
      total = total + rows
    end
  end
  return math.max(1, total)
end

local function headlineLines(headline, width)
  local innerW = (type(width) == "number" and width or PANEL_FALLBACK_W) - PROCLAIM_INSET * 2
  local lines = wrappedLines(headline, headlinePx(), innerW)
  if lines < 1 then lines = 1 end
  -- Grenze Gotisch overshoots a tight wrap; one slack row when wrapping.
  if lines > 1 then lines = lines + 1 end
  return lines
end

local function headlineBlockH(headline, width)
  return headlineLines(headline, width) * (headlinePx() + space("xs", 4))
end

local function headBlock(kind, headline, width)
  local topBlock = isBannered(kind) and bannerPx() or stampPx()
  return topBlock + space("sm", 8) + headlineBlockH(headline, width)
end

local function composeHeight(kind, headline, body, width)
  local inset = PROCLAIM_INSET
  local sm = space("sm", 8)
  local rule = space("rule", 2)
  -- Hairline accent is always reserved so charcoal wrap is not clipped by it.
  local h = inset + headBlock(kind, headline, width) + sm + rule
  if type(body) == "string" and body ~= "" then
    local innerW = (type(width) == "number" and width or PANEL_FALLBACK_W) - inset * 2
    local bodyPx = themeFontSize("body")
    if type(bodyPx) ~= "number" then bodyPx = 12 end
    local lines = wrappedLines(body, bodyPx, innerW)
    if lines < 1 then lines = 1 end
    h = h + sm + lines * bodyLeadPx() + sm
  end
  return math.max(theaterFloor(), h + inset + sm)
end

local function layoutTheaterDress(t, w, h, kind, hasBody, headline)
  if not t or not t.panel then return end
  local panel = t.panel
  local inset = PROCLAIM_INSET
  local xs = space("xs", 4)
  local sm = space("sm", 8)
  local md = space("md", 16)
  local c = space("md", 16)
  local pin = space("sm", 8)
  local rule = space("rule", 2)
  local stamp = stampPx()
  local bannerH = bannerPx()
  local bannered = isBannered(kind)

  if t.center then
    if t.center.ClearAllPoints then t.center:ClearAllPoints() end
    t.center:SetPoint("TOPLEFT", panel, "TOPLEFT", inset, -inset)
    t.center:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -inset, inset)
  end
  placeBox(t.cornerTL, "TOPLEFT", panel, "TOPLEFT", 0, 0, c, c)
  placeBox(t.cornerTR, "TOPRIGHT", panel, "TOPRIGHT", 0, 0, c, c)
  placeBox(t.cornerBL, "BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 0, c, c)
  placeBox(t.cornerBR, "BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0, c, c)
  if t.edgeTop then
    if t.edgeTop.ClearAllPoints then t.edgeTop:ClearAllPoints() end
    t.edgeTop:SetPoint("TOPLEFT", t.cornerTL, "TOPRIGHT", 0, 0)
    t.edgeTop:SetPoint("TOPRIGHT", t.cornerTR, "TOPLEFT", 0, 0)
    t.edgeTop:SetHeight(c)
  end
  if t.edgeBottom then
    if t.edgeBottom.ClearAllPoints then t.edgeBottom:ClearAllPoints() end
    t.edgeBottom:SetPoint("BOTTOMLEFT", t.cornerBL, "BOTTOMRIGHT", 0, 0)
    t.edgeBottom:SetPoint("BOTTOMRIGHT", t.cornerBR, "BOTTOMLEFT", 0, 0)
    t.edgeBottom:SetHeight(c)
  end
  if t.edgeLeft then
    if t.edgeLeft.ClearAllPoints then t.edgeLeft:ClearAllPoints() end
    t.edgeLeft:SetPoint("TOPLEFT", t.cornerTL, "BOTTOMLEFT", 0, 0)
    t.edgeLeft:SetPoint("BOTTOMLEFT", t.cornerBL, "TOPLEFT", 0, 0)
    t.edgeLeft:SetWidth(c)
  end
  if t.edgeRight then
    if t.edgeRight.ClearAllPoints then t.edgeRight:ClearAllPoints() end
    t.edgeRight:SetPoint("TOPRIGHT", t.cornerTR, "BOTTOMRIGHT", 0, 0)
    t.edgeRight:SetPoint("BOTTOMRIGHT", t.cornerBR, "TOPRIGHT", 0, 0)
    t.edgeRight:SetWidth(c)
  end
  placeBox(t.pinTL, "TOPLEFT", panel, "TOPLEFT", xs, -xs, pin, pin)
  placeBox(t.pinTR, "TOPRIGHT", panel, "TOPRIGHT", -xs, -xs, pin, pin)
  placeBox(t.pinBL, "BOTTOMLEFT", panel, "BOTTOMLEFT", xs, xs, pin, pin)
  placeBox(t.pinBR, "BOTTOMRIGHT", panel, "BOTTOMRIGHT", -xs, xs, pin, pin)

  local topBlock = bannered and bannerH or stamp
  local stack = headBlock(kind, headline, w)
  local inner = (type(h) == "number" and h or theaterFloor()) - inset * 2
  local top = inset
  if (not hasBody) and inner > stack then
    top = inset + math.floor((inner - stack) / 2)
  end

  if t.banner then
    if t.banner.ClearAllPoints then t.banner:ClearAllPoints() end
    -- Ribbon hangs from the sheet top. Never stretch it as a second fill.
    t.banner:SetPoint("TOPLEFT", panel, "TOPLEFT", inset, -inset)
    t.banner:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -inset, -inset)
    t.banner:SetHeight(bannerH)
  end

  -- Seal stays on the parchment (ribbon medallion, or top of the field).
  if bannered then
    placeBox(t.seal, "CENTER", t.banner or panel, "CENTER", 0, 0, stamp, stamp)
  else
    placeBox(t.seal, "TOP", panel, "TOP", 0, -top, stamp, stamp)
  end

  -- Halo around the seal only — not a root-scale panel pulse.
  if t.rays then
    local ray = stamp + md * 2
    placeBox(t.rays, "CENTER", t.seal or panel, "CENTER", 0, 0, ray, ray)
  end

  local textTop = top + topBlock + sm
  if t.headline then
    if t.headline.ClearAllPoints then t.headline:ClearAllPoints() end
    t.headline:SetPoint("TOPLEFT", panel, "TOPLEFT", inset, -textTop)
    t.headline:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -inset, -textTop)
    if t.headline.SetHeight then
      t.headline:SetHeight(headlineBlockH(headline, w))
    end
  end
  if t.tint then
    if t.tint.ClearAllPoints then t.tint:ClearAllPoints() end
    if t.headline then
      t.tint:SetPoint("TOPLEFT", t.headline, "BOTTOMLEFT", md, -sm)
      t.tint:SetPoint("TOPRIGHT", t.headline, "BOTTOMRIGHT", -md, -sm)
    else
      t.tint:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", inset, inset)
      t.tint:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -inset, inset)
    end
    t.tint:SetHeight(rule)
  end
  if t.copy then
    if t.copy.ClearAllPoints then t.copy:ClearAllPoints() end
    if t.headline then
      t.copy:SetPoint("TOPLEFT", t.headline, "BOTTOMLEFT", 0, -(sm + rule + sm))
      t.copy:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -inset, inset)
    else
      t.copy:SetPoint("TOPLEFT", panel, "TOPLEFT", inset, -textTop)
      t.copy:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -inset, inset)
    end
  end
end

local function dressTheater(t, kind, fields)
  if not t then return end
  fields = type(fields) == "table" and fields or {}
  local bannered = isBannered(kind)
  local sealName = sealNameFor(kind, fields)
  local role = accentRole(kind, fields)

  if not applySlot(t.center, "frame_proclamation_center") then
    applySlot(t.center, "frame_proclamation")
  end
  applySlot(t.cornerTL, "frame_proclamation_corner_tl")
  applySlot(t.cornerTR, "frame_proclamation_corner_tr")
  applySlot(t.cornerBL, "frame_proclamation_corner_bl")
  applySlot(t.cornerBR, "frame_proclamation_corner_br")
  applySlot(t.edgeTop, "frame_proclamation_edge_top")
  applySlot(t.edgeBottom, "frame_proclamation_edge_bottom")
  applySlot(t.edgeLeft, "frame_proclamation_edge_left")
  applySlot(t.edgeRight, "frame_proclamation_edge_right")
  applySlot(t.pinTL, "frame_proclamation_pin_tl")
  applySlot(t.pinTR, "frame_proclamation_pin_tr")
  applySlot(t.pinBL, "frame_proclamation_pin_bl")
  applySlot(t.pinBR, "frame_proclamation_pin_br")
  applyTint(t.cornerTL, "iron", 1)
  applyTint(t.cornerTR, "iron", 1)
  applyTint(t.cornerBL, "iron", 1)
  applyTint(t.cornerBR, "iron", 1)
  applyTint(t.edgeTop, "iron", 1)
  applyTint(t.edgeBottom, "iron", 1)
  applyTint(t.edgeLeft, "iron", 1)
  applyTint(t.edgeRight, "iron", 1)

  t.sealName = sealName
  t.sealPath = applySlot(t.seal, sealName)
  t.accentRole = role
  local r, g, b = applyTint(t.seal, role, 1)
  t.accentR, t.accentG, t.accentB = r, g, b
  applyFill(t.tint, role, 1)
  applyTint(t.pinTL, role, 1)
  applyTint(t.pinTR, role, 1)
  applyTint(t.pinBL, role, 1)
  applyTint(t.pinBR, role, 1)

  t.bannerName = "banner_knighting"
  t.bannerPath = applySlot(t.banner, "banner_knighting")
  if t.banner then
    if bannered then t.banner:Show() else t.banner:Hide() end
  end

  t.raysName = "rays_sunburst"
  t.raysPath = applySlot(t.rays, "rays_sunburst")
  applyTint(t.rays, "gold", 1)
  if t.rays then
    if t.rays.SetBlendMode then
      pcall(t.rays.SetBlendMode, t.rays, "ADD")
    end
    t.rays._blend = "ADD"
    if bannered then t.rays:Show() else t.rays:Hide() end
  end
end

function Toasts:InitTheater()
  if self.theater and self.theater.root then
    wireProclaimEsc(self, self.theater.root)
    return self.theater
  end
  if type(CreateFrame) ~= "function" then return nil end

  local root = CreateFrame("Frame", PROCLAIM_NAME, UIParent)
  root:SetFrameStrata("FULLSCREEN_DIALOG")
  if root.EnableMouse then root:EnableMouse(true) end
  if root.SetAllPoints then
    root:SetAllPoints(UIParent)
  else
    root:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
    root:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
  end
  root:Hide()

  local dim = root:CreateTexture(nil, "BACKGROUND")
  dim:SetAllPoints(root)
  applyFill(dim, "charcoal", DIM_ALPHA)

  local panel = CreateFrame("Frame", "ChurchOfBeefProclaimPanel", root)
  if panel.EnableMouse then panel:EnableMouse(true) end
  if panel.SetScript then
    panel:SetScript("OnMouseUp", function()
      hideTheater(self)
    end)
  end

  local center = mintTex(panel, "BACKGROUND")
  applySlot(center, "frame_proclamation_center")
  local cornerTL = mintTex(panel, "BORDER")
  local cornerTR = mintTex(panel, "BORDER")
  local cornerBL = mintTex(panel, "BORDER")
  local cornerBR = mintTex(panel, "BORDER")
  local edgeTop = mintTex(panel, "BORDER")
  local edgeBottom = mintTex(panel, "BORDER")
  local edgeLeft = mintTex(panel, "BORDER")
  local edgeRight = mintTex(panel, "BORDER")
  local pinTL = mintTex(panel, "OVERLAY")
  local pinTR = mintTex(panel, "OVERLAY")
  local pinBL = mintTex(panel, "OVERLAY")
  local pinBR = mintTex(panel, "OVERLAY")
  local banner = mintTex(panel, "ARTWORK")
  applySlot(banner, "banner_knighting")
  if banner then banner:Hide() end
  -- Additive halo behind the seal, on the sheet — not a root-scale pulse.
  local rays = mintTex(panel, "OVERLAY")
  if rays and rays.SetBlendMode then
    pcall(rays.SetBlendMode, rays, "ADD")
  end
  if rays then rays._blend = "ADD" end
  applySlot(rays, "rays_sunburst")
  if rays then rays:Hide() end
  local seal = mintTex(panel, "OVERLAY")
  applySlot(seal, "seal_papal")
  local tint = mintTex(panel, "OVERLAY")

  local headline = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  headline:SetPoint("TOPLEFT", panel, "TOPLEFT", PROCLAIM_INSET, -PROCLAIM_INSET)
  headline:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -PROCLAIM_INSET, -PROCLAIM_INSET)
  headline:SetJustifyH("CENTER")
  headline:SetJustifyV("TOP")
  if headline.SetWordWrap then headline:SetWordWrap(true) end
  if headline.SetMaxLines then headline:SetMaxLines(6) end
  applyHeadlineFont(headline)

  local copy = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  copy:SetPoint("TOPLEFT", headline, "BOTTOMLEFT", 0, -space("sm", 8))
  copy:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -PROCLAIM_INSET, PROCLAIM_INSET)
  copy:SetJustifyH("CENTER")
  copy:SetJustifyV("TOP")
  if copy.SetWordWrap then copy:SetWordWrap(true) end
  if copy.SetMaxLines then copy:SetMaxLines(4) end
  applyBodyFont(copy)

  self.theater = {
    root = root,
    dim = dim,
    rays = rays,
    panel = panel,
    center = center,
    cornerTL = cornerTL,
    cornerTR = cornerTR,
    cornerBL = cornerBL,
    cornerBR = cornerBR,
    edgeTop = edgeTop,
    edgeBottom = edgeBottom,
    edgeLeft = edgeLeft,
    edgeRight = edgeRight,
    pinTL = pinTL,
    pinTR = pinTR,
    pinBL = pinBL,
    pinBR = pinBR,
    banner = banner,
    seal = seal,
    tint = tint,
    headline = headline,
    copy = copy,
    dimAlpha = DIM_ALPHA,
  }
  -- After the initial Hide so create does not fire OnHide teardown.
  wireProclaimEsc(self, root)
  return self.theater
end

--- Event Mode proclamation / verdict / cowardice / knighting / elevation.
--- Clerical copy only. fields: { fighterA, fighterB, name, ruling, text }
--- @return ok boolean, reason string|nil
function Toasts:Proclaim(kind, fields)
  if type(kind) ~= "string" or not THEATER_KINDS[kind] then
    return false, "invalid"
  end
  if not theaterAllowed() then
    return false, "quiet"
  end

  fields = type(fields) == "table" and fields or {}
  local headline, body, chat = clericalCopy(kind, fields)
  if type(headline) ~= "string" or headline == "" then
    return false, "invalid"
  end
  if type(body) ~= "string" then body = "" end
  if type(chat) ~= "string" or chat == "" then
    if body == "" then
      chat = headline
    else
      chat = headline .. "\n" .. body
    end
  end

  local theater = self:InitTheater()
  if not theater then return false, "invalid" end

  local w = panelWidth()
  local h = composeHeight(kind, headline, body, w)
  theater.panel:SetWidth(w)
  theater.panel:SetHeight(h)
  if theater.panel.ClearAllPoints then theater.panel:ClearAllPoints() end
  theater.panel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  dressTheater(theater, kind, fields)
  layoutTheaterDress(theater, w, h, kind, body ~= "", headline)

  theater.headline:SetText(headline)
  applyHeadlineFont(theater.headline, theater, responsiveHeadlinePx(headline))
  applyTextColor(theater.headline, "charcoal")
  theater.copy:SetText(body)
  applyBodyFont(theater.copy, theater)
  applyTextColor(theater.copy, "charcoal")
  theater.inkRole = "charcoal"
  if body ~= "" then
    theater.copy:Show()
  else
    theater.copy:Hide()
  end
  theater.dimAlpha = DIM_ALPHA
  applyFill(theater.dim, "charcoal", DIM_ALPHA)

  theater.root:Show()
  theater.panel:Show()

  if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
    DEFAULT_CHAT_FRAME:AddMessage(chat)
  end

  playTheaterCue(kind)

  theaterGen = theaterGen + 1
  local myGen = theaterGen
  after(THEATER_HOLD, function()
    if theaterGen ~= myGen then return end
    if theater.root then theater.root:Hide() end
  end)

  return true
end

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

function Toasts:Init()
  return self:InitTheater()
end

function Toasts:HideAll()
  hideTheater(self)
  rememberSpecial(PROCLAIM_NAME)
end

function Toasts:ResetForTests()
  if not COB._IN_TEST then return false end
  self:HideAll()
  return true
end
