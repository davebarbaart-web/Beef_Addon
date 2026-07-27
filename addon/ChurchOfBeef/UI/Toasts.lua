ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Private edge toast. Displays Core / Net outcomes only — never grants standing,
-- never guild-chats, never center-screen pulses. Silent V1 (glossary 79).
-- Architecture: docs/research/agent-polish-vision/46-toast-celebration-system.md
local Toasts = {}
COB.Toasts = Toasts

local MAX_QUEUE = 5
local DEDUPE_WINDOW = 10
local SLIDE_PX = 16
local ENTER_DUR = 0.25
local EXIT_DUR = 0.18
local INTERRUPT_DUR = 0.08
local ANCHOR_Y = -160

-- Kind defaults: priority, hold (s), interrupt lower?, combat soft-defer (V1: unused).
local KINDS = {
  promote = { priority = 90, hold = 7.0, interrupt = true,  deferInCombat = false },
  demote  = { priority = 85, hold = 7.0, interrupt = true,  deferInCombat = false },
  excommunicate = { priority = 85, hold = 7.0, interrupt = true, deferInCombat = false },
  suggest = { priority = 70, hold = 6.0, interrupt = true,  deferInCombat = false },
  rite    = { priority = 65, hold = 4.5, interrupt = true,  deferInCombat = false },
  credit  = { priority = 40, hold = 4.0, interrupt = false, deferInCombat = true },
  system  = { priority = 30, hold = 3.5, interrupt = false, deferInCombat = true },
  debug   = { priority = 10, hold = 2.0, interrupt = false, deferInCombat = true },
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
      frame:SetBackdropBorderColor(0.65, 0.55, 0.35, 1)
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

local function animGroup(frame, key)
  -- rawget only: desktop stubs __index-cache a noop function for unknown keys,
  -- which is truthy and must never be treated as an AnimationGroup (cobFadeIn).
  local g = rawget(frame, key)
  if type(g) == "table" then return g end
  return nil
end

local function clearStubNoop(frame, key)
  local g = rawget(frame, key)
  if type(g) == "function" then
    rawset(frame, key, nil)
  end
end

local function ensureMotion(frame)
  if rawget(frame, "_cobMotionReady") then return end
  -- Mark ready first so a failed probe does not re-enter and re-pollute keys.
  rawset(frame, "_cobMotionReady", true)
  clearStubNoop(frame, "cobFadeIn")
  clearStubNoop(frame, "cobFadeOut")
  clearStubNoop(frame, "cobSnapOut")

  -- Desktop stubs answer unknown methods with noops that return nil — only a
  -- real AnimationGroup table means the client supports motion groups.
  local create = frame.CreateAnimationGroup
  if type(create) ~= "function" then return end
  local gin = create(frame)
  if type(gin) ~= "table" then return end
  -- CreateAnimation must also yield a real anim table (stub groups return nil).
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
    deferInCombat = envelope.deferInCombat,
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
  -- V1: discard interrupted toast (credits/system); never re-queue.
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
      -- Coalesce pending credits (burst totals); other kinds drop as deduped.
      if pending[idx].kind == "credit" or e.kind == "credit" then
        pending[idx].text = e.text
        pending[idx].hold = e.hold
        pending[idx].priority = math.max(pending[idx].priority, e.priority)
        return true, "deduped"
      end
      return false, "deduped"
    end
    if self.showing and self.showing.dedupeKey == e.dedupeKey then
      if e.kind == "credit" then
        self.showing.text = e.text
        if self.frame and self.frame.text then
          self.frame.text:SetText(e.text)
        end
        return true, "deduped"
      end
      return false, "deduped"
    end
    local seen = recentKeys[e.dedupeKey]
    if seen and (at - seen) < DEDUPE_WINDOW then
      return false, "deduped"
    end
  end

  -- Soft-defer credits/system in combat is intentionally OFF for V1.
  -- Hook point: enqueue to a deferList and drain on PLAYER_REGEN_ENABLED.

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

--- Convenience ceremony entry. Builds UI-owned copy; never touches Core.
--- Forms:
---   Celebrate(text)                         → system
---   Celebrate(kind, fieldsTable)            → structured
--- fields: { name?, title?, detail?, text?, standingDelta?, attendees?,
---           verb?, dedupeKey?, hold?, priority? }
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
    if kind == "promote" or kind == "demote" or kind == "excommunicate" then
      if fields.name and fields.title then
        text = string.format("%s is now %s.", fields.name, fields.title)
      end
    elseif kind == "suggest" then
      if fields.name and fields.title then
        text = string.format("Promote %s to %s in the guild roster.", fields.name, fields.title)
      elseif fields.title then
        -- UTF-8 em dash (same bytes as Net local-eligibility copy).
        text = string.format("Eligible for %s \226\128\148 officers can promote you in the guild roster.", fields.title)
      end
    elseif kind == "credit" then
      if type(fields.attendees) == "number" then
        text = string.format("Ceremony closed: %d attendee(s) credited", fields.attendees)
      elseif fields.detail and type(fields.standingDelta) == "number" then
        text = string.format("Gora %s: %+d standing", fields.detail, fields.standingDelta)
      end
    elseif kind == "rite" then
      if fields.name and type(fields.standingDelta) == "number" then
        text = string.format("%s: %d standing", fields.name, fields.standingDelta)
      elseif fields.verb and fields.name and fields.title then
        text = string.format("%s: %s → %s", fields.verb, fields.name, fields.title)
      end
    elseif kind == "system" or kind == "debug" then
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
