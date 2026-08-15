ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Event Mode toast engine. Quiet Mode does not drive this file (Law 6).
-- Grant-driven kinds (suggest, credit, demote, excommunicate) are gone.
-- Promote / rite copy builders and those KINDS are gone — nothing live
-- called them. Engine remains: system / debug and Push. Do not invent
-- Event Mode kinds here (Phase 4).
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

local pending = {}
local recentKeys = {}
local gen = 0
local arrivalSeq = 0

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

local function tryBackdrop(frame)
  if frame.SetBackdrop then
    frame:SetBackdrop({
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true,
      tileSize = 16,
      edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    -- Opaque iron scrim (stream-readable); dual-encode meaning in words, not hue.
    if frame.SetBackdropColor then
      frame:SetBackdropColor(0, 0, 0, 1)
    end
    if frame.SetBackdropBorderColor then
      local edge = (COB.UI and COB.UI.Palette and COB.UI.Palette.HeavyEdge)
        or { 0.65, 0.55, 0.35, 1 }
      frame:SetBackdropBorderColor(edge[1], edge[2], edge[3], edge[4] or 1)
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
-- Public API
--------------------------------------------------------------------------------

function Toasts:Init()
  if self.frame then return self.frame end
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
    bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    if bg.SetVertexColor then bg:SetVertexColor(0, 0, 0, 1) end
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
---   Celebrate(kind, fieldsTable)            → system / debug only
--- fields: { detail?, text?, dedupeKey?, hold?, priority? }
--- Unknown / excised kinds (promote, rite, grant family) do not mint copy.
function Toasts:Celebrate(kind, fields)
  -- Plain string → system toast (back-compat for early call sites).
  if type(kind) == "string" and fields == nil then
    if not KINDS[kind] then
      return self:Push({ kind = "system", text = kind })
    end
    return false, "invalid"
  end

  fields = type(fields) == "table" and fields or {}
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
  bumpGen()
  clearPending()
  stopMotion(self.frame)
  self.showing = nil
  if self.frame then
    resetAnchor(self.frame)
    if self.frame.SetAlpha then self.frame:SetAlpha(1) end
    self.frame:Hide()
  end
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
