ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode toast engine + theatrical proclamation/verdict beats (Law 6).
-- Quiet Mode does not drive this file. Grant-driven kinds are gone.
-- Promote / rite copy builders and those KINDS are gone.
-- Engine: system / debug via Push; sanction / verdict / cowardice /
-- knighting / elevation via Proclaim.
-- Clerical copy only. Never generate oratory. Never SendChatMessage.
-- Theatrical dress (color, font, texture) resolves only through COB.Theme.
-- Small system/debug toasts stay unornamented; they also take Theme tokens
-- so this file holds no color or path literals.
local Toasts = {}
COB.Toasts = Toasts

local MAX_QUEUE = 5
local DEDUPE_WINDOW = 10
local SLIDE_PX = 16
local ENTER_DUR = 0.25
local EXIT_DUR = 0.18
local INTERRUPT_DUR = 0.08
local ANCHOR_Y = -160

-- Kind defaults: priority, hold (s), may it interrupt a lower toast.
--
-- Combat soft-defer is deliberately not here. It was carried as a per-kind flag that
-- no code read, which is worse than not having it: the table looked like policy while
-- toasts popped mid-pull regardless. The hook point is documented at its call site in
-- Push, and the flag comes back with the code that honours it.
local KINDS = {
  system  = { priority = 30, hold = 3.5, interrupt = false },
  debug   = { priority = 10, hold = 2.0, interrupt = false },
}

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
local SLICE_CORNER = 18
local SLICE_PIN = 12
local SEAL_SIZE = 56

local pending = {}
local recentKeys = {}
local gen = 0
local arrivalSeq = 0
local theaterGen = 0

local function now()
  if type(GetTime) == "function" then
    local t = GetTime()
    if type(t) == "number" then return t end
  end
  if type(time) == "function" then
    local t = time()
    if type(t) == "number" then return t end
  end
  return 0
end

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

local function bumpGen()
  gen = gen + 1
  return gen
end

local function clampPriority(p)
  if type(p) ~= "number" then return nil end
  if p < 0 then return 0 end
  if p > 100 then return 100 end
  return p
end

local function truncate(text)
  if type(text) ~= "string" then return text end
  if #text <= 120 then return text end
  return text:sub(1, 117) .. "..."
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

local function applySlot(tex, name)
  if not tex then return nil end
  local path = themeTexture(name)
  tex._cobName = name
  tex._cobPath = path
  if path and tex.SetTexture then
    pcall(tex.SetTexture, tex, path)
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
end

local function tryBackdrop(frame)
  if frame.SetBackdrop then
    -- Functional scrim only — Theme tokens, no theatrical ornament.
    frame:SetBackdrop({
      bgFile = themeTexture("bar_stainedglass_fill"),
      edgeFile = themeTexture("frame_proclamation_edge_top"),
      tile = true,
      tileSize = 16,
      edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    local r, g, b = themeColor("charcoal")
    if frame.SetBackdropColor and r then
      frame:SetBackdropColor(r, g, b, 1)
    end
    local ir, ig, ib = themeColor("iron")
    if frame.SetBackdropBorderColor and ir then
      frame:SetBackdropBorderColor(ir, ig, ib, 1)
    end
    return true
  end
  return false
end

local function resetAnchor(frame)
  if not frame then return end
  if frame.ClearAllPoints then frame:ClearAllPoints() end
  frame:SetPoint("TOP", UIParent, "TOP", 0, ANCHOR_Y)
end

local function probeAlpha(anim, fromA, toA)
  if anim.SetFromAlpha and anim.SetToAlpha then
    anim:SetFromAlpha(fromA)
    anim:SetToAlpha(toA)
  elseif anim.SetChange then
    anim:SetChange(toA - fromA)
  end
end

-- Motion groups are stored on the frame itself, so read them back with rawget: an
-- inherited key would not be one of ours.
local function animGroup(frame, key)
  local g = rawget(frame, key)
  if type(g) == "table" then return g end
  return nil
end

-- Every probe below is a real portability check, not a test accommodation: a client
-- without AnimationGroup support has to fall through to the stepped C_Timer fade
-- rather than error, and the toast still has to appear.
local function ensureMotion(frame)
  if rawget(frame, "_cobMotionReady") then return end
  -- Mark ready first so a failed probe does not re-enter.
  rawset(frame, "_cobMotionReady", true)

  local create = frame.CreateAnimationGroup
  if type(create) ~= "function" then return end
  local gin = create(frame)
  if type(gin) ~= "table" then return end
  local ain = gin.CreateAnimation and gin:CreateAnimation("Alpha")
  if type(ain) ~= "table" then return end

  gin:SetLooping("NONE")
  ain:SetDuration(ENTER_DUR)
  ain:SetSmoothing("OUT")
  ain:SetOrder(1)
  probeAlpha(ain, 0, 1)
  local tin = gin:CreateAnimation("Translation")
  if type(tin) == "table" then
    tin:SetOffset(0, -SLIDE_PX)
    tin:SetDuration(ENTER_DUR)
    tin:SetSmoothing("OUT")
    tin:SetOrder(1)
  end
  gin:SetScript("OnFinished", function()
    resetAnchor(frame)
    if frame.SetAlpha then frame:SetAlpha(1) end
  end)
  rawset(frame, "cobFadeIn", gin)

  local gout = frame:CreateAnimationGroup()
  if type(gout) ~= "table" then return end
  gout:SetLooping("NONE")
  local aout = gout:CreateAnimation("Alpha")
  if type(aout) ~= "table" then return end
  aout:SetDuration(EXIT_DUR)
  aout:SetSmoothing("IN")
  aout:SetOrder(1)
  probeAlpha(aout, 1, 0)
  local tout = gout:CreateAnimation("Translation")
  if type(tout) == "table" then
    tout:SetOffset(0, SLIDE_PX)
    tout:SetDuration(EXIT_DUR)
    tout:SetSmoothing("IN")
    tout:SetOrder(1)
  end
  rawset(frame, "cobFadeOut", gout)

  local gsnap = frame:CreateAnimationGroup()
  if type(gsnap) ~= "table" then return end
  gsnap:SetLooping("NONE")
  local asnap = gsnap:CreateAnimation("Alpha")
  if type(asnap) ~= "table" then return end
  asnap:SetDuration(INTERRUPT_DUR)
  asnap:SetSmoothing("IN")
  probeAlpha(asnap, 1, 0)
  rawset(frame, "cobSnapOut", gsnap)
end

local function stopMotion(frame)
  if not frame then return end
  local gin = animGroup(frame, "cobFadeIn")
  if gin and type(gin.Stop) == "function" then gin:Stop() end
  local gout = animGroup(frame, "cobFadeOut")
  if gout and type(gout.Stop) == "function" then gout:Stop() end
  local gsnap = animGroup(frame, "cobSnapOut")
  if gsnap and type(gsnap.Stop) == "function" then gsnap:Stop() end
end

local function kindDefaults(kind)
  return KINDS[kind] or KINDS.system
end

local function normalize(envelope)
  if type(envelope) == "string" then
    envelope = { kind = "system", text = envelope }
  end
  if type(envelope) ~= "table" then return nil end

  local text = envelope.text
  if type(text) ~= "string" or text == "" then return nil end

  local kind = envelope.kind
  if type(kind) ~= "string" or not KINDS[kind] then kind = "system" end
  local def = kindDefaults(kind)

  local priority = clampPriority(envelope.priority) or def.priority
  local hold = envelope.hold
  if type(hold) ~= "number" or hold <= 0 then hold = def.hold end

  local interrupt = envelope.interrupt
  if interrupt == nil then interrupt = def.interrupt end

  local motion = envelope.motion
  if COB._IN_TEST then motion = "snap" end
  if type(motion) ~= "string" then motion = "edge" end

  arrivalSeq = arrivalSeq + 1
  return {
    kind = kind,
    priority = priority,
    text = truncate(text),
    dedupeKey = type(envelope.dedupeKey) == "string" and envelope.dedupeKey or nil,
    hold = hold,
    interrupt = interrupt and true or false,
    motion = motion,
    _arrival = arrivalSeq,
  }
end

local function pruneRecent(at)
  local cutoff = at - DEDUPE_WINDOW
  for key, seen in pairs(recentKeys) do
    if seen < cutoff then recentKeys[key] = nil end
  end
end

local function findPendingKey(key)
  for i = 1, #pending do
    if pending[i].dedupeKey == key then return i end
  end
  return nil
end

local function insertPending(e)
  local i = 1
  while i <= #pending do
    if e.priority > pending[i].priority then break end
    i = i + 1
  end
  table.insert(pending, i, e)
end

local function lowestPendingIndex()
  if #pending == 0 then return nil end
  local worst = 1
  for i = 2, #pending do
    local a, b = pending[i], pending[worst]
    if a.priority < b.priority
      or (a.priority == b.priority and a._arrival < b._arrival) then
      worst = i
    end
  end
  return worst
end

local function clearPending()
  for i = #pending, 1, -1 do pending[i] = nil end
end

--------------------------------------------------------------------------------
-- Presenter
--------------------------------------------------------------------------------

local pump -- forward decl

local function fadeOutThen(self, envelope, done, snap)
  local frame = self.frame
  local myGen = gen
  local finish = function()
    if gen ~= myGen then return end
    if frame then
      stopMotion(frame)
      resetAnchor(frame)
      if frame.SetAlpha then frame:SetAlpha(1) end
      frame:Hide()
    end
    done()
  end

  if envelope.motion == "snap" or COB._IN_TEST or not (frame and frame.SetAlpha) then
    finish()
    return
  end

  ensureMotion(frame)
  local group = snap and animGroup(frame, "cobSnapOut") or animGroup(frame, "cobFadeOut")
  if group and type(group.Play) == "function" then
    group:SetScript("OnFinished", finish)
    if frame.SetAlpha then frame:SetAlpha(1) end
    group:Play()
    return
  end

  -- Stepped C_Timer alpha fallback (no AnimationGroup).
  local dur = snap and INTERRUPT_DUR or EXIT_DUR
  local steps = snap and 2 or 4
  local i = 0
  local function step()
    if gen ~= myGen then return end
    i = i + 1
    frame:SetAlpha(1 - (i / steps))
    if i < steps then
      after(dur / steps, step)
    else
      finish()
    end
  end
  step()
end

local function fadeIn(self, envelope)
  local frame = self.frame
  if envelope.motion == "snap" or COB._IN_TEST or not (frame and frame.SetAlpha) then
    if frame.SetAlpha then frame:SetAlpha(1) end
    return
  end

  ensureMotion(frame)
  local gin = animGroup(frame, "cobFadeIn")
  if gin and type(gin.Play) == "function" then
    stopMotion(frame)
    resetAnchor(frame)
    if frame.SetPoint then
      frame:ClearAllPoints()
      frame:SetPoint("TOP", UIParent, "TOP", 0, ANCHOR_Y + SLIDE_PX)
    end
    frame:SetAlpha(0)
    gin:Play()
    return
  end

  frame:SetAlpha(0)
  local steps = 3
  local i = 0
  local myGen = gen
  local function step()
    if gen ~= myGen then return end
    i = i + 1
    frame:SetAlpha(i / steps)
    if i < steps then after(ENTER_DUR / steps, step) end
  end
  step()
end

local function present(self, envelope)
  self.showing = envelope
  local frame = self.frame
  frame.text:SetText(envelope.text)
  resetAnchor(frame)
  if frame.SetAlpha then frame:SetAlpha(1) end
  frame:Show()
  fadeIn(self, envelope)

  local myGen = gen
  after(envelope.hold, function()
    if gen ~= myGen then return end
    if self.showing ~= envelope then return end
    fadeOutThen(self, envelope, function()
      if gen ~= myGen then return end
      self.showing = nil
      pump(self)
    end, false)
  end)
end

pump = function(self)
  local nextEnv = table.remove(pending, 1)
  if not nextEnv then
    -- Hide-from-empty-pump re-enters OnHide; do not loop.
    if not self.showing and #pending == 0 then
      return
    end
    self.showing = nil
    if self.frame then self.frame:Hide() end
    return
  end
  present(self, nextEnv)
end

local function interruptShowing(self)
  local cur = self.showing
  if not cur then return end
  bumpGen()
  stopMotion(self.frame)
  -- Discard the interrupted toast; never re-queue.
  self.showing = nil
  if self.frame then
    if self.frame.SetAlpha then self.frame:SetAlpha(1) end
    resetAnchor(self.frame)
    self.frame:Hide()
  end
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

local function applyHeadlineFont(fs, theater)
  if not fs then return end
  local path = themeFontPath("display")
  local size = themeFontSize("headline")
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
    local parts = { a, "VS", b }
    if type(fields.stipulation) == "string" and fields.stipulation ~= "" then
      parts[#parts + 1] = fields.stipulation
    end
    local head = "A Beef Gora is Sanctioned"
    local body = table.concat(parts, "\n")
    return head, body, head .. "\n" .. body
  end

  if kind == "cowardice" then
    local name = fields.name
    if type(name) ~= "string" or name == "" then return nil end
    local line = "Cowardice recorded: " .. name .. ". So ruled by the Beef Pope."
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
      return "Void.", "", "Void."
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
  if type(root.SetScript) == "function" then
    local existing = type(root.GetScript) == "function" and root:GetScript("OnHide")
    if not existing then
      root:SetScript("OnHide", function()
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

local function layoutTheaterDress(t, w, h)
  if not t or not t.panel then return end
  local panel = t.panel
  local inset = 6
  if t.center then
    if t.center.ClearAllPoints then t.center:ClearAllPoints() end
    t.center:SetPoint("TOPLEFT", panel, "TOPLEFT", inset, -inset)
    t.center:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -inset, inset)
  end
  local c = SLICE_CORNER
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
  local p = SLICE_PIN
  placeBox(t.pinTL, "TOPLEFT", panel, "TOPLEFT", 4, -4, p, p)
  placeBox(t.pinTR, "TOPRIGHT", panel, "TOPRIGHT", -4, -4, p, p)
  placeBox(t.pinBL, "BOTTOMLEFT", panel, "BOTTOMLEFT", 4, 4, p, p)
  placeBox(t.pinBR, "BOTTOMRIGHT", panel, "BOTTOMRIGHT", -4, 4, p, p)
  placeBox(t.seal, "TOP", panel, "TOP", 0, 16, SEAL_SIZE, SEAL_SIZE)
  if t.banner then
    if t.banner.ClearAllPoints then t.banner:ClearAllPoints() end
    t.banner:SetPoint("TOPLEFT", panel, "TOPLEFT", inset, -inset)
    t.banner:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -inset, inset)
  end
  if t.tint then
    if t.tint.ClearAllPoints then t.tint:ClearAllPoints() end
    t.tint:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 10, 10)
    t.tint:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -10, 10)
    t.tint:SetHeight(6)
  end
  if t.rays then
    if t.rays.ClearAllPoints then t.rays:ClearAllPoints() end
    t.rays:SetPoint("CENTER", panel, "CENTER", 0, 0)
    t.rays:SetWidth(math.floor((w or PANEL_FALLBACK_W) * 1.4))
    t.rays:SetHeight(math.max(180, math.floor((h or 140) * 1.6)))
  end
end

local function dressTheater(t, kind, fields)
  if not t then return end
  fields = type(fields) == "table" and fields or {}
  local bannered = (kind == "knighting" or kind == "elevation")
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
  if root.EnableMouse then root:EnableMouse(false) end
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

  -- Additive sunburst sits on the root so the panel/banner paints in front.
  local rays = mintTex(root, "BACKGROUND")
  if rays and rays.SetBlendMode then
    pcall(rays.SetBlendMode, rays, "ADD")
  end
  if rays then rays._blend = "ADD" end
  applySlot(rays, "rays_sunburst")
  if rays then rays:Hide() end

  local panel = CreateFrame("Frame", "ChurchOfBeefProclaimPanel", root)
  if panel.EnableMouse then panel:EnableMouse(false) end

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
  local seal = mintTex(panel, "OVERLAY")
  applySlot(seal, "seal_papal")
  local tint = mintTex(panel, "OVERLAY")

  local headline = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  headline:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -36)
  headline:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, -36)
  headline:SetJustifyH("CENTER")
  headline:SetJustifyV("TOP")
  if headline.SetWordWrap then headline:SetWordWrap(true) end
  applyHeadlineFont(headline)

  local copy = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  copy:SetPoint("TOPLEFT", headline, "BOTTOMLEFT", 0, -8)
  copy:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -16, 20)
  copy:SetJustifyH("CENTER")
  copy:SetJustifyV("MIDDLE")
  if copy.SetWordWrap then copy:SetWordWrap(true) end
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
--- Clerical copy only. fields: { fighterA, fighterB, name, ruling, text, stipulation }
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
  local joined = headline
  if body ~= "" then joined = headline .. "\n" .. body end
  local lines = 1
  for _ in joined:gmatch("\n") do lines = lines + 1 end
  local h = math.max(160, 64 + lines * 24)
  theater.panel:SetWidth(w)
  theater.panel:SetHeight(h)
  if theater.panel.ClearAllPoints then theater.panel:ClearAllPoints() end
  theater.panel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  layoutTheaterDress(theater, w, h)
  dressTheater(theater, kind, fields)

  theater.headline:SetText(headline)
  applyHeadlineFont(theater.headline, theater)
  applyTextColor(theater.headline, "charcoal")
  theater.copy:SetText(body)
  applyBodyFont(theater.copy, theater)
  applyTextColor(theater.copy, "charcoal")
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

local function wireSmallOnHide(self, frame)
  if not frame then return end
  if type(frame.SetScript) == "function" then
    local existing = type(frame.GetScript) == "function" and frame:GetScript("OnHide")
    if not existing then
      frame:SetScript("OnHide", function()
        -- interruptShowing / empty-pump Hide: showing already nil; do not pump.
        if not self.showing then return end
        bumpGen()
        self.showing = nil
        pump(self)
      end)
    end
  end
end

function Toasts:Init()
  if self.frame then
    rememberSpecial("ChurchOfBeefToast")
    rememberSpecial(PROCLAIM_NAME)
    wireSmallOnHide(self, self.frame)
    return self.frame
  end
  if type(CreateFrame) ~= "function" then return nil end

  local frame = CreateFrame("Frame", "ChurchOfBeefToast", UIParent, "BackdropTemplate")
  if not frame then
    frame = CreateFrame("Frame", "ChurchOfBeefToast", UIParent)
  end
  -- Rubric/toast-sizing: ~280–360 × 64–96; grow copy down before width.
  frame:SetWidth(360)
  frame:SetHeight(72)
  frame:SetPoint("TOP", UIParent, "TOP", 0, ANCHOR_Y)
  frame:SetFrameStrata("HIGH")
  -- Classic AG Translation paints offset while mouse hit-test stays at the
  -- pre-anim anchor (research 56). Toast is display-only — no buttons; keep
  -- mouse off for the whole envelope while slide polish remains.
  if frame.EnableMouse then frame:EnableMouse(false) end
  frame:Hide()
  if frame.SetAlpha then frame:SetAlpha(1) end

  if not tryBackdrop(frame) then
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(frame)
    applyFill(bg, "charcoal", 1)
  end

  local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
  text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
  text:SetJustifyH("CENTER")
  text:SetJustifyV("MIDDLE")
  if text.SetWordWrap then text:SetWordWrap(true) end
  frame.text = text

  -- Re-clamp after monitor / scale changes (track 43); guest on player uiScale.
  if frame.RegisterEvent then
    frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
    frame:RegisterEvent("UI_SCALE_CHANGED")
    frame:SetScript("OnEvent", function()
      resetAnchor(frame)
    end)
  end

  self.frame = frame
  self.showing = nil
  -- After the initial Hide so create does not fire OnHide teardown.
  wireSmallOnHide(self, frame)
  rememberSpecial("ChurchOfBeefToast")
  return frame
end

--- Preferred structured entry. string → Show; table → envelope.
--- @return ok boolean, reason string|nil
function Toasts:Push(envelope)
  local e = normalize(envelope)
  if not e then return false, "invalid" end
  if not self:Init() then return false, "invalid" end

  local at = now()
  pruneRecent(at)

  if e.dedupeKey then
    local idx = findPendingKey(e.dedupeKey)
    if idx then
      return false, "deduped"
    end
    if self.showing and self.showing.dedupeKey == e.dedupeKey then
      return false, "deduped"
    end
    local seen = recentKeys[e.dedupeKey]
    if seen and (at - seen) < DEDUPE_WINDOW then
      return false, "deduped"
    end
  end

  -- Soft-defer while in combat is intentionally OFF. Hook point: enqueue to a
  -- deferList here and drain it on PLAYER_REGEN_ENABLED.

  if self.showing and e.interrupt and e.priority > self.showing.priority then
    interruptShowing(self)
  end

  if #pending >= MAX_QUEUE then
    local worst = lowestPendingIndex()
    if worst and e.priority > pending[worst].priority then
      table.remove(pending, worst)
    else
      return false, "overflow"
    end
  end

  if e.dedupeKey then recentKeys[e.dedupeKey] = at end
  insertPending(e)

  if not self.showing then
    pump(self)
  end
  return true
end

--- Back-compat. Equivalent to Push({ kind = "system", text = text }).
function Toasts:Show(text)
  local ok = self:Push({ kind = "system", text = text })
  return ok and true or false
end

--- Convenience entry. Builds UI-owned copy; never touches Core.
--- Forms:
---   Celebrate(text)                         → system
---   Celebrate(kind, fieldsTable)            → system / debug, or Proclaim
--- fields: { detail?, text?, dedupeKey?, hold?, priority?,
---           fighterA?, fighterB?, name?, ruling?, stipulation? }
--- Theater kinds (sanction / verdict / cowardice / knighting / elevation) go to Proclaim.
--- Unknown / excised kinds (promote, rite, grant family) do not mint copy.
function Toasts:Celebrate(kind, fields)
  -- Plain string → system toast (back-compat for early call sites).
  -- Theater kind names are not copy; they must go through Proclaim.
  if type(kind) == "string" and fields == nil then
    if THEATER_KINDS[kind] then
      return self:Proclaim(kind, {})
    end
    if not KINDS[kind] then
      return self:Push({ kind = "system", text = kind })
    end
    return false, "invalid"
  end

  fields = type(fields) == "table" and fields or {}
  if type(kind) == "string" and THEATER_KINDS[kind] then
    return self:Proclaim(kind, fields)
  end
  if type(kind) ~= "string" or not KINDS[kind] then kind = "system" end

  local text = fields.text
  if type(text) ~= "string" or text == "" then
    if kind == "system" or kind == "debug" then
      text = fields.detail
    end
  end

  if type(text) ~= "string" or text == "" then return false, "invalid" end

  return self:Push({
    kind = kind,
    text = text,
    dedupeKey = fields.dedupeKey,
    hold = fields.hold,
    priority = fields.priority,
    interrupt = fields.interrupt,
    motion = fields.motion,
  })
end

function Toasts:HideAll()
  gen = gen + 1
  hideTheater(self)
  clearPending()
  stopMotion(self.frame)
  self.showing = nil
  if self.frame then
    resetAnchor(self.frame)
    if self.frame.SetAlpha then self.frame:SetAlpha(1) end
    self.frame:Hide()
  end
  rememberSpecial("ChurchOfBeefToast")
  rememberSpecial(PROCLAIM_NAME)
end

function Toasts:ResetForTests()
  if not COB._IN_TEST then return false end
  self:HideAll()
  for k in pairs(recentKeys) do recentKeys[k] = nil end
  arrivalSeq = 0
  return true
end

function Toasts:PendingCount()
  return #pending
end

function Toasts:ShowingKind()
  return self.showing and self.showing.kind or nil
end
