ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef

-- Shared Quiet night-row language for the Nights parchment and the `/beef`
-- week strip (Bible §14.1). One occurrence per row. The UI never concatenates
-- nights into a single FontString. Event kind sits on a bookmark ribbon —
-- a tag, not a headline. Display/blackletter is forbidden on row ink.
-- Parchment rows keep Theme label/body serif. Card rows use stock GameFont*
-- (Law 10). Kind chips are dark rite cloth + parchment ink — never oxblood.
local NightRows = {
  MODE = "QUIET",
}
COB.NightRows = NightRows

local STUB_CUE = "Sign up on Discord"
local GOING = "Going"
local EMPTY = "No nights posted this week."
local MONTHS = {
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
}
local KIND = {
  gathering = "Gathering",
  knighting = "Knighting",
  gora = "Gora",
}
local RIBBON_H = 20
local RIBBON_PAD = 12
local RIBBON_MIN = 80
local RIBBON_MAX_CARD = 140
local RIBBON_MAX_PARCHMENT = 180

local function themeColor(role)
  if not (COB.Theme and COB.Theme.Color) then return nil end
  local r, g, b = COB.Theme:Color(role)
  if type(r) ~= "number" then return nil end
  return r, g, b
end

local function themeFont(role)
  if COB.Theme and COB.Theme.FontPath then
    return COB.Theme:FontPath(role)
  end
end

local function applyFont(fs, template, role, size, stock)
  if not fs then return end
  if not stock then
    local path = themeFont(role)
    local used = false
    if path and fs.SetFont then
      local ok, applied = pcall(fs.SetFont, fs, path, size or 12, "")
      used = ok and applied and true or false
    end
    if not used and fs.SetFontObject then
      local font = template
      if type(template) == "string" then font = _G[template] end
      if font then pcall(fs.SetFontObject, fs, font) end
    end
    fs._cobFontRole = role
    fs._cobFontPath = path
    return
  end
  if fs.SetFontObject then
    local font = template
    if type(template) == "string" then font = _G[template] end
    if font then pcall(fs.SetFontObject, fs, font) end
  end
  local want = size or 12
  if want < 12 then want = 12 end
  if fs.GetFont and fs.SetFont then
    local path, _, flags = fs:GetFont()
    if type(path) ~= "string" or path == "" then
      local font = template
      if type(template) == "string" then font = _G[template] end
      if type(font) == "table" and font.GetFont then
        path, _, flags = font:GetFont()
      end
    end
    if type(path) == "string" and path ~= "" then
      pcall(fs.SetFont, fs, path, want, flags or "")
    end
  end
  fs._cobFontRole = role
  fs._cobFontPath = nil
end

local function colorText(fs, role)
  if not fs or not fs.SetTextColor then return end
  local r, g, b = themeColor(role)
  if r then fs:SetTextColor(r, g, b, 1) end
  fs._cobColorRole = role
end

local function themeTexture(name)
  if COB.Theme and type(COB.Theme.Texture) == "function" then
    return COB.Theme:Texture(name)
  end
end

local function applyTexture(tex, name)
  if not tex then return false end
  local path = themeTexture(name)
  tex._cobTextureName = name
  tex._cobTexture = path
  if type(path) ~= "string" or not tex.SetTexture then return false end
  local ok = pcall(tex.SetTexture, tex, path)
  return ok and true or false
end

function NightRows.KindRole(row)
  if type(row) ~= "table" then return "gathering" end
  if row.source == "stub" then return "notice" end
  if row.kind == "knighting" then return "knighting" end
  if row.kind == "gora" then return "gora" end
  return "gathering"
end

local function ribbonMax(variant)
  if variant == "card" then return RIBBON_MAX_CARD end
  return RIBBON_MAX_PARCHMENT
end

function NightRows.RibbonWidth(fs, text, variant)
  if type(text) ~= "string" or text == "" then return RIBBON_MIN end
  local measured
  if fs and type(fs.GetStringWidth) == "function" then
    local w = fs:GetStringWidth()
    if type(w) == "number" and w > 0 then measured = w end
  end
  if not measured then measured = #text * 7 end
  local w = math.floor(measured + RIBBON_PAD * 2 + 0.5)
  if w < RIBBON_MIN then w = RIBBON_MIN end
  local maxW = ribbonMax(variant)
  if w > maxW then w = maxW end
  return w
end

function NightRows.DressRibbon(tex, fs, role, text, variant)
  if not tex then return end
  local cloth = type(role) == "string" and role or "gathering"
  local r, g, b = themeColor(cloth)
  if type(r) == "number" then
    if tex.GetTexture and tex:GetTexture() and tex.SetVertexColor then
      pcall(tex.SetVertexColor, tex, r, g, b, 1)
    elseif tex.SetColorTexture then
      tex:SetColorTexture(r, g, b, 1)
    elseif tex.SetVertexColor then
      pcall(tex.SetVertexColor, tex, r, g, b, 1)
    end
  end
  tex._cobColorRole = cloth
  if tex.SetHeight then tex:SetHeight(RIBBON_H) end
  local label = type(text) == "string" and text or ""
  if fs then
    if fs.SetText then fs:SetText(label) end
    colorText(fs, "parchment")
    if fs.SetMaxLines then fs:SetMaxLines(1) end
  end
  if tex.SetWidth then tex:SetWidth(NightRows.RibbonWidth(fs, label, variant)) end
end

local function fillRole(tex, role, a)
  if not tex then return end
  local r, g, b = themeColor(role)
  if not r then return end
  if tex.SetColorTexture then
    tex:SetColorTexture(r, g, b, a or 1)
  elseif tex.SetVertexColor then
    tex:SetVertexColor(r, g, b, a or 1)
  end
end

function NightRows.KindLabel(row)
  if type(row) ~= "table" then return "" end
  if row.source == "stub" then
    return type(row.title) == "string" and row.title or ""
  end
  return KIND[row.kind] or "Gathering"
end

function NightRows.DateLabel(row)
  if type(row) ~= "table" or type(row.date) ~= "string" then return "" end
  local y, m, d = row.date:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  if not y then return row.date end
  local month = MONTHS[tonumber(m)]
  if not month then return row.date end
  return month .. " " .. tostring(tonumber(d))
end

function NightRows.WhereLine(row)
  if type(row) ~= "table" then return "" end
  local place = type(row.place) == "string" and row.place or ""
  local timeLine = type(row.timeLine) == "string" and row.timeLine or ""
  if place ~= "" and timeLine ~= "" then
    return place .. " · " .. timeLine
  end
  if place ~= "" then return place end
  return timeLine
end

function NightRows.IsChurch(row)
  return type(row) == "table" and row.source ~= "stub" and type(row.key) == "string"
end

function NightRows.Present(row)
  local church = NightRows.IsChurch(row)
  return {
    date = NightRows.DateLabel(row),
    kind = NightRows.KindLabel(row),
    where = NightRows.WhereLine(row),
    church = church,
    going = church and (type(row.goingCount) == "number" and row.goingCount or 0) or nil,
    cue = (type(row) == "table" and row.source == "stub") and STUB_CUE or nil,
  }
end

function NightRows.Metrics(width, height, variant)
  if type(width) ~= "number" or width <= 0 then width = 400 end
  if type(height) ~= "number" or height <= 0 then
    height = variant == "card" and 160 or 240
  end
  -- Card NightList is shorter than the week plate. Height must not force
  -- one-line rows or titles clip into "SUNDAY SERVICE · S…".
  local compact
  if variant == "card" then
    compact = width < 300
  else
    compact = width < 360 or height < 180
  end
  local rowH = 42
  if variant == "card" then
    rowH = compact and 36 or 44
  elseif compact then
    rowH = 36
  end
  local visible
  if variant == "card" then
    visible = 3
  else
    visible = math.max(3, math.min(8, math.floor(height / rowH)))
  end
  return {
    compact = compact,
    twoLine = not compact,
    rowH = rowH,
    dateW = compact and 52 or 64,
    actionW = 64,
    font = 12,
    visible = visible,
    variant = variant == "card" and "card" or "parchment",
    ribbonH = RIBBON_H,
    ribbonMin = RIBBON_MIN,
    ribbonMax = ribbonMax(variant),
  }
end

local function setShown(widget, show)
  if not widget then return end
  if show then
    if widget.Show then widget:Show() end
  elseif widget.Hide then
    widget:Hide()
  end
end

local function buildRow(parent, variant)
  local stock = variant == "card"
  local row = CreateFrame("Frame", nil, parent)
  row:SetHeight(40)

  local dateFs = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  applyFont(dateFs, "GameFontNormalSmall", "label", 12, stock)
  colorText(dateFs, "iron")
  if dateFs.SetJustifyH then dateFs:SetJustifyH("LEFT") end
  if dateFs.SetWordWrap then dateFs:SetWordWrap(false) end
  if dateFs.SetMaxLines then dateFs:SetMaxLines(1) end
  row.Date = dateFs

  local kindRibbon = row:CreateTexture(nil, "ARTWORK")
  kindRibbon:SetHeight(RIBBON_H)
  kindRibbon:SetWidth(RIBBON_MIN)
  if not applyTexture(kindRibbon, "ribbon_bookmark") then
    fillRole(kindRibbon, "gathering", 1)
  end
  kindRibbon._cobColorRole = "gathering"
  row.KindRibbon = kindRibbon

  local kindFace = stock and "GameFontNormalSmall" or "GameFontNormal"
  local kindFs = row:CreateFontString(nil, "OVERLAY", kindFace)
  applyFont(kindFs, kindFace, "label", 12, stock)
  colorText(kindFs, "parchment")
  if kindFs.SetJustifyH then kindFs:SetJustifyH("CENTER") end
  if kindFs.SetWordWrap then kindFs:SetWordWrap(false) end
  if kindFs.SetMaxLines then kindFs:SetMaxLines(1) end
  row.Kind = kindFs

  local whereFace = stock and "GameFontNormalSmall" or "GameFontNormal"
  local whereFs = row:CreateFontString(nil, "OVERLAY", whereFace)
  applyFont(whereFs, whereFace, "body", 12, stock)
  colorText(whereFs, "iron")
  if whereFs.SetJustifyH then whereFs:SetJustifyH("LEFT") end
  if whereFs.SetWordWrap then whereFs:SetWordWrap(false) end
  if whereFs.SetMaxLines then whereFs:SetMaxLines(1) end
  row.Where = whereFs

  local cueFs = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  applyFont(cueFs, "GameFontNormalSmall", "label", 12, stock)
  colorText(cueFs, "oxblood")
  if cueFs.SetJustifyH then cueFs:SetJustifyH("RIGHT") end
  if cueFs.SetWordWrap then cueFs:SetWordWrap(false) end
  if cueFs.SetMaxLines then cueFs:SetMaxLines(1) end
  row.Cue = cueFs

  local going
  if COB.Theme and type(COB.Theme.PanelButton) == "function" then
    going = COB.Theme:PanelButton(row, GOING)
  end
  if not going then
    going = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
  end
  going:SetWidth(64)
  going:SetHeight(18)
  if rawget(going, "Label") == nil then
    rawset(going, "Label", {
      SetText = function(_, text)
        if going.SetText then going:SetText(text) end
      end,
      GetText = function()
        if going.GetText then return going:GetText() end
      end,
    })
  end
  going:SetScript("OnClick", function(self)
    if type(self._cobKey) ~= "string" then return end
    local host = row._cobHost
    if host and type(host.onGoing) == "function" then
      host.onGoing(self._cobKey)
    end
  end)
  row.Going = going

  local rule = row:CreateTexture(nil, "ARTWORK")
  rule:SetHeight(1)
  fillRole(rule, "iron", 0.35)
  row.Rule = rule

  row:Hide()
  return row
end

local function layoutRow(row, metrics)
  local dateW = metrics.dateW
  local actionW = metrics.actionW
  local pad = 4
  row:SetHeight(metrics.rowH)
  row.Date:ClearAllPoints()
  row.Date:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -pad)
  row.Date:SetWidth(dateW)
  row.Going:ClearAllPoints()
  row.Going:SetPoint("RIGHT", row, "RIGHT", 0, 0)
  row.Going:SetWidth(actionW)
  row.Cue:ClearAllPoints()
  row.Cue:SetPoint("RIGHT", row, "RIGHT", 0, 0)
  row.Cue:SetWidth(actionW)
  row.KindRibbon:ClearAllPoints()
  row.KindRibbon:SetPoint("TOPLEFT", row.Date, "TOPRIGHT", 6, 2)
  row.KindRibbon:SetHeight(metrics.ribbonH or RIBBON_H)
  row.Kind:ClearAllPoints()
  row.Kind:SetPoint("TOPLEFT", row.KindRibbon, "TOPLEFT", 6, -1)
  row.Kind:SetPoint("BOTTOMRIGHT", row.KindRibbon, "BOTTOMRIGHT", -6, 1)
  if row.Kind.SetJustifyH then row.Kind:SetJustifyH("CENTER") end
  row.Where:ClearAllPoints()
  if metrics.twoLine then
    row.Where:SetPoint("TOPLEFT", row.Date, "BOTTOMLEFT", 0, -3)
    row.Where:SetPoint("RIGHT", row, "RIGHT", -(actionW + 6), 0)
  else
    row.Where:SetPoint("LEFT", row.KindRibbon, "RIGHT", 6, 0)
    row.Where:SetPoint("RIGHT", row, "RIGHT", -(actionW + 6), 0)
  end
  row.Rule:ClearAllPoints()
  row.Rule:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 0)
  row.Rule:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)
end

local function paintRow(row, data, metrics)
  if not data then
    row._cobKey = nil
    row.Going._cobKey = nil
    row.Date:SetText("")
    row.Kind:SetText("")
    row.Where:SetText("")
    row.Cue:SetText("")
    if row.Going.Label then row.Going.Label:SetText(GOING) end
    if row.KindRibbon then
      row.KindRibbon:SetWidth(RIBBON_MIN)
      setShown(row.KindRibbon, false)
    end
    setShown(row.Going, false)
    setShown(row.Cue, false)
    setShown(row, false)
    return
  end
  local view = NightRows.Present(data)
  layoutRow(row, metrics)
  row.Date:SetText(view.date)
  if row.KindRibbon then
    NightRows.DressRibbon(
      row.KindRibbon,
      row.Kind,
      NightRows.KindRole(data),
      view.kind,
      metrics.variant
    )
    setShown(row.KindRibbon, view.kind ~= "")
  else
    row.Kind:SetText(view.kind)
    colorText(row.Kind, "parchment")
  end
  row.Where:SetText(view.where)
  setShown(row.Where, view.where ~= "")
  if view.church then
    row.Going._cobKey = data.key
    row.Going.Label:SetText(GOING .. " " .. tostring(view.going or 0))
    setShown(row.Going, true)
    setShown(row.Cue, false)
    row.Cue:SetText("")
  else
    row.Going._cobKey = nil
    setShown(row.Going, false)
    row.Cue:SetText(view.cue or "")
    setShown(row.Cue, view.cue ~= nil)
  end
  setShown(row, true)
end

local function relayout(host)
  local parent = host.frame
  local width = parent.GetWidth and parent:GetWidth() or 0
  local height = parent.GetHeight and parent:GetHeight() or 0
  local metrics = NightRows.Metrics(width, height, host.variant)
  host.metrics = metrics
  local data = host.data or {}
  local n = #data
  local maxOff = n > metrics.visible and (n - metrics.visible) or 0
  if host.offset > maxOff then host.offset = maxOff end
  if host.offset < 0 then host.offset = 0 end
  if n == 0 then
    host.empty:SetText(EMPTY)
    setShown(host.empty, true)
    for i = 1, #host.rows do
      paintRow(host.rows[i], nil, metrics)
    end
    return metrics
  end
  setShown(host.empty, false)
  host.empty:SetText("")
  for i = 1, #host.rows do
    local row = host.rows[i]
    if i <= metrics.visible then
      row:ClearAllPoints()
      row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -((i - 1) * metrics.rowH))
      row:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
      paintRow(row, data[host.offset + i], metrics)
    else
      paintRow(row, nil, metrics)
    end
  end
  return metrics
end

function NightRows:Attach(parent, opts)
  if type(parent) ~= "table" then return nil end
  if parent._cobNightHost then return parent._cobNightHost end
  if type(CreateFrame) ~= "function" then return nil end
  opts = type(opts) == "table" and opts or {}
  local pool = type(opts.pool) == "number" and opts.pool or 8
  if pool < 3 then pool = 3 end
  if pool > 8 then pool = 8 end
  local variant = opts.variant == "card" and "card" or "parchment"

  local empty = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  applyFont(empty, "GameFontNormal", "body", 12, variant == "card")
  colorText(empty, "iron")
  if empty.SetJustifyH then empty:SetJustifyH("CENTER") end
  if empty.SetWordWrap then empty:SetWordWrap(true) end
  empty:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
  empty:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
  empty:SetText(EMPTY)

  local host = {
    frame = parent,
    empty = empty,
    rows = {},
    offset = 0,
    data = {},
    variant = variant,
    onGoing = opts.onGoing,
    pool = pool,
  }
  for i = 1, pool do
    local row = buildRow(parent, variant)
    row._cobHost = host
    host.rows[i] = row
  end
  if parent.EnableMouseWheel then parent:EnableMouseWheel(true) end
  if parent.SetScript then
    parent:SetScript("OnMouseWheel", function(_, delta)
      if type(delta) ~= "number" then return end
      host.offset = host.offset - (delta > 0 and 1 or -1)
      relayout(host)
    end)
  end
  parent._cobNightHost = host
  return host
end

function NightRows:Paint(host, rows)
  if type(host) ~= "table" or type(host.rows) ~= "table" then return false end
  local data = {}
  if type(rows) == "table" then
    for i = 1, #rows do
      if type(rows[i]) == "table" then
        data[#data + 1] = rows[i]
      end
    end
  end
  host.data = data
  host.offset = 0
  relayout(host)
  return true
end

function NightRows:Host(parent)
  return parent and parent._cobNightHost or nil
end
