# 02 — Lua `CreateFrame` vs XML templates (Anniversary `20506`)

**Audience:** Coding agents polishing Church of Beef UI.  
**Client:** WoW TBC Classic Anniversary · `## Interface: 20506`.  
**Last updated:** 2026-07-26  
**Authority:** Spec §10 / §15 · [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) · glossary 74–81 · depth in track [35-xml-vs-lua-ui](../wow-classic-addon-design/35-xml-vs-lua-ui/).

Research scrapes (`.firecrawl/`) are **not** product truth. This note is agent guidance; product locks stay in the design spec.

---

## Verdict (one line)

**Stay Lua-primary `CreateFrame` + inherit Classic FrameXML templates.** Author addon XML only when you need a reusable `virtual="true"` template (or HybridScroll’s named button template). Backdrop via `BackdropTemplate`. Juice with short `AnimationGroup` / `C_Timer` fades — never permanent `OnUpdate` business logic, never WA-style center spectacle.

---

## Agent-ready decision tree

```text
Need a widget?
│
├─ Is it Blizzard chrome (panel shell, panel button, close, input box)?
│  └─ YES → CreateFrame(type, nil|name, parent, "ClassicTemplate")
│           Prefer: BasicFrameTemplate, UIPanelButtonTemplate,
│           UIPanelCloseButton, InputBoxTemplate, UICheckButtonTemplate
│           Verify name exists on Anniversary FrameXML before shipping.
│
├─ Is it data-shaped / dynamic (ladder row, officer queue, toast, tab panel)?
│  └─ YES → Pure Lua CreateFrame + CreateFontString / CreateTexture
│           Pool & reuse (frames are never GC’d).
│           No addon XML.
│
├─ Same complex child tree copy-pasted ≥3 times OR HybridScroll CreateButtons?
│  └─ YES → Add UI/Templates.xml with virtual="true" template
│           then CreateFrame(..., "COBYourTemplate")
│           List Templates.xml in TOC before any consumer Lua.
│
├─ Need SetBackdrop / SetBackdropColor / border?
│  └─ YES → CreateFrame(..., "BackdropTemplate")  [or comma-list with others]
│           then SetBackdrop(backdropInfo)
│           Fail-soft: if SetBackdrop nil, CreateTexture BACKGROUND fallback
│           (Beef Toasts.lua already does this).
│
├─ Need text?
│  └─ parent:CreateFontString(nil, "OVERLAY", "GameFontNormal"|…)
│     Prefer GameFont* / stock font objects. Class color on names only.
│
├─ Need art / fill / edge accent?
│  └─ parent:CreateTexture(nil, drawLayer [, template, subLevel])
│     Stock Interface\ paths first. Custom Media/ only post-V1 art pass.
│
└─ Need motion / juice?
   ├─ Discrete delay / hold → C_Timer.After / NewTicker
   ├─ Alpha / translation polish → region:CreateAnimationGroup() + Alpha/Translation
   └─ NEVER → permanent OnUpdate for scoring/net; NEVER center-screen WA pulses
```

### Quick “which wins?” matrix

| Situation | Winner | Why |
|-----------|--------|-----|
| Small–medium social UI; tabs; pools | **Lua** | Faster iteration; stack traces; matches Beef codebase |
| Native Classic look | **Lua + inherit FrameXML** | No custom XML just for chrome |
| New reusable template used many times | **XML `virtual="true"`** | Templates cannot be invented in Lua |
| HybridScroll `CreateButtons` | **XML virtual button** | API expects a named virtual template |
| Large static hierarchy / awkward layer attrs | **XML (or hybrid)** | Declarative layers; rare for Beef |
| Secure / action-button UI | **XML + care** | Out of V1 scope |
| Dynamic lists | **Lua pools** | Natural loops; refresh from Core |

---

## Mechanics agents must not confuse

### `CreateFrame` (runtime)

```text
frame = CreateFrame(frameType [, name, parent, template, id])
```

| Arg | Beef rule |
|-----|-----------|
| `frameType` | `"Frame"`, `"Button"`, `"EditBox"`, `"ScrollFrame"`, … |
| `name` | Prefer `nil` + table keys; named globals only for ESC/`UISpecialFrames` shells |
| `parent` | Frame object (`UIParent` or Beef root) — not a string |
| `template` | Comma-delimited **virtual** template names at creation time |
| `id` | Optional numeric ID |

Hard facts ([CreateFrame](https://warcraft.wiki.gg/wiki/API_CreateFrame), [Wowpedia CreateFrame](https://wowpedia.fandom.com/wiki/API_CreateFrame)):

1. Template `OnLoad` runs **during** `CreateFrame`. `SetScript("OnLoad", …)` afterward does **not** re-fire — init immediately after creation.
2. Frames **cannot be deleted / GC’d** — pool ladder & officer rows.
3. You cannot pass a previously created Lua frame as a “template”; only XML virtual names (or Blizzard’s).
4. Comma-lists for multiple inherits have existed since patch **2.0.1** (TBC-era) — e.g. `"BackdropTemplate,GameTooltipTemplate"` ([forum pattern](https://us.forums.blizzard.com/en/wow/t/backdroptemplate-issues/1125674)).

### Virtual XML templates

```xml
<Frame name="COBRowTemplate" virtual="true">
  <!-- children, layers, scripts -->
</Frame>
```

```lua
CreateFrame("Button", nil, parent, "COBRowTemplate")
```

Rules ([Virtual XML template](https://wowpedia.fandom.com/wiki/Virtual_XML_template), [XML user interface](https://warcraft.wiki.gg/wiki/XML_user_interface)):

- `virtual="true"` + unique `name` at document root (or included XML).
- Templates do **not** live in `_G` as placed frames; they are deferred nodes for inheritance.
- Inheritance via XML `inherits="…"` **or** `CreateFrame` 4th arg.
- Children that need unique globals use `$parent` expansion.
- Duplicate virtual names warn / error — never collide with Blizzard names.
- **Creating** a new template requires XML; **using** one does not.

### Inheritance chains

- Templates may inherit templates (chains).
- Instance attributes can override template attributes.
- Blizzard FrameXML sometimes expects child templates to re-invoke parent `OnLoad` — avoid mirroring deep Blizzard chains; inherit one shallow Classic template and compose the rest in Lua.
- Prefer Lua `parent.closeBtn = CreateFrame(...)` over relying on XML `parentKey` surprises in a Lua-primary addon.

### Load order / TOC

1. Addon `virtual` templates (`.xml`) must load **before** any `CreateFrame(..., "ThatTemplate")`.
2. List files explicitly in `ChurchOfBeef.toc` (or `<Include>` / `<Script>` from XML).
3. Malformed XML fails at login/reload — keep XML tiny when used.
4. Keep non-trivial handlers in named Lua functions; do not bury Core calls inside XML `<OnClick>` blobs.

---

## `BackdropTemplate` on Classic Anniversary

| Fact | Implication for Beef |
|------|----------------------|
| Retail 9.0.1 moved backdrop off raw `Frame:SetBackdrop` onto **`BackdropTemplate` / mixin** | Plain `CreateFrame("Frame")` → `SetBackdrop` is **nil** |
| Backported to Classic flavors in **patch 1.14.0** (2021-09-28); “backwards-compatible code no longer necessary” on modern Classic | Anniversary `20506` **has** `BackdropTemplate` ([BackdropTemplate](https://wowpedia.fandom.com/wiki/BackdropTemplate), [warcraft.wiki.gg BackdropTemplate](https://warcraft.wiki.gg/wiki/BackdropTemplate)) |
| Multiple inherits: `"BackdropTemplate,OtherTemplate"` | Use when a stock template dropped backdrop (tooltip-era breaks) |
| `SetBackdrop(backdropInfo)` / `SetBackdropColor` / `SetBackdropBorderColor` | After inherit; use stock tooltip paths for V1 opaque panels |

**Beef pattern (already in tree):** prefer `CreateFrame(..., "BackdropTemplate")`; if methods missing, fail-soft with `CreateTexture` BACKGROUND ([`UI/Toasts.lua`](../../../addon/ChurchOfBeef/UI/Toasts.lua)). Do **not** invent a Retail-only panel template for borders.

V1 visual lock: **opaque high-contrast panels** — backdrop alpha stays high; no glass/low-alpha fashion.

---

## FontStrings

```lua
local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fs:SetPoint("LEFT", parent, "LEFT", 8, 0)
fs:SetJustifyH("LEFT")
fs:SetText(displayName)
```

| Topic | Rule |
|-------|------|
| API | `Frame:CreateFontString([name, drawLayer, templateName])` ([CreateFontString](https://wowpedia.fandom.com/wiki/API_Frame_CreateFontString)) |
| Font objects | Prefer `GameFontNormal`, `GameFontHighlight`, `GameFontNormalLarge`, `GameFontDisable`, … — inherit via 3rd arg or `SetFontObject` |
| Layers | FontStrings do **not** support texture sublevels; they draw **above** textures on the same draw layer |
| Color | Class color on **player names only**; dual-encode pending/approve/reject (color + text). Do not paint brand scarlet on every string (glossary 81) |
| Dynamic lists | Rebind `:SetText` on pooled rows — do not create unbounded FontStrings per guild member |
| Offline tests | FontString APIs are client-only; keep Core free of them |

---

## Textures

```lua
local tex = parent:CreateTexture(nil, "BACKGROUND")
tex:SetAllPoints(parent)
tex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
-- or: tex:SetColorTexture(r, g, b, a)
```

| Topic | Rule |
|-------|------|
| API | `Frame:CreateTexture([name, drawLayer, templateName, subLevel])` ([CreateTexture](https://wowpedia.fandom.com/wiki/API_Frame_CreateTexture)) |
| Draw layers | `BACKGROUND` → `BORDER` → `ARTWORK` → `OVERLAY` → `HIGHLIGHT` (typical) |
| `subLevel` | `[-8, 7]` for stacking textures within a layer |
| V1 media | Stock `Interface\\…` paths only; custom TGA/`Media/` waits on post-V1 art pass; missing media must not fail load |
| Highlight | Button hover via template or `HIGHLIGHT` texture — prefer stock button templates over hand-rolled glow stacks |
| Seals / heraldry | Later art pass; do not block Task 7–10 |

---

## Polish implications: juice & animation

Product locks (spec §15 / briefing):

- Spectacle = throttled `/g` line + **private edge toast** — **no** center-screen WeakAuras pulses.
- V1 is **silent** (no SFX).
- Guest on player `uiScale` — never set `uiScale` / `UIParent:SetScale`.

### What construction choice enables

| Juice | Prefer | Construction note |
|-------|--------|-------------------|
| Toast fade in/out | `C_Timer` + alpha steps **or** `CreateAnimationGroup` + `Alpha` | Works on Lua-created frames/regions; no XML required ([CreateAnimationGroup](https://warcraft.wiki.gg/wiki/API_AnimatableObject_CreateAnimationGroup)) |
| Toast hold / queue | `C_Timer.After` | Beef already uses hold + fade constants in `Toasts.lua` |
| Tab switch | Instant `:Show`/`:Hide` of panels | No cross-fade needed for V1 process UI |
| Promote feedback | Guild chat + edge toast text | Brand lives in **words**, not animated chrome |
| Row select highlight | Texture vertex color / stock highlight | Pool-friendly; avoid per-row AnimationGroups that never die |
| “Breathing” idle UI | **Do not** | Conflicts with performance rules; UI closed → idle |

### Motion budget (agent checklist)

1. **Prefer Animation objects or `C_Timer` over `OnUpdate`** for visual easing ([OnUpdate guidance](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate); track [04](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md)).
2. If `OnUpdate` is unavoidable (fallback timer without `C_Timer`), **nil the script when done** and hide the helper frame.
3. Cap concurrent toast animations (queue already maxes at 5).
4. No permanent animators on ladder rows while the panel is closed.
5. In combat: insecure Beef frames may show; do not start heavy layout thrash or secure-template work.
6. Do not add XML solely to declare `<Animations>` — Lua `CreateAnimationGroup` is enough for toast-scale juice.

### XML vs juice myth

XML does **not** unlock better animation. `Animation` / `AnimationGroup` exist as XML tags *and* as Lua widget APIs. For Beef’s toast-scale polish, **Lua wins** (same runtime objects, easier to gate and tear down). Reach for XML animations only if a shared virtual template owns a reusable anim definition used by many instances.

---

## Church of Beef mapping (current tree)

| Surface | Construction today | Stay / change |
|---------|-------------------|---------------|
| Main shell | `BasicFrameTemplate` | Stay |
| Tabs | `UIPanelButtonTemplate` + Lua panels | Stay |
| Ladder / Officer rows | Anonymous Lua frames + pools | Stay; XML only if Hybrid or ≥3 identical complex rows |
| Standing inputs | `InputBoxTemplate` / panel buttons | Stay |
| Toasts | `BackdropTemplate` + `GameFontNormal` + timer fade | Stay; optional `AnimationGroup` refactor OK |
| Minimap | Plain `Button` | Stay |
| Addon `Templates.xml` | Absent | Correct for V1 |

Layers: UI may `CreateFrame`; **Core never does**. UI never awards points.

---

## Classic Anniversary verification (before locking new templates)

On a live `20506` client (or matching FrameXML extract):

- [ ] Template name exists (`BasicFrameTemplate`, `UIPanelButtonTemplate`, `BackdropTemplate`, …)
- [ ] Visual chrome matches Classic (not Retail `DefaultPanelTemplate` fashion)
- [ ] `SetBackdrop` works only with `BackdropTemplate` inherit
- [ ] `/console scriptErrors 1` → `/reload` → `/beef` after UI edits
- [ ] If any `.xml` added: TOC order correct; no missing-file TOC entries

---

## Antipatterns (reject in review)

| Antipattern | Prefer |
|-------------|--------|
| Full FrameXML mirror of MainFrame | Lua modules per tab |
| Retail-only templates without Anniversary verify | Classic-verified names |
| `SetBackdrop` without `BackdropTemplate` | Inherit + fail-soft texture |
| New global name per list row | Anonymous + `panel.rows[i]` pool |
| HybridScroll without admitting XML virtual button | Faux/pool Lua lists (track 57) |
| AceGUI / Masque / SharedMedia hard deps for V1 look | Stock templates + GameFont* |
| SecureActionButton “to open `/beef`” | Insecure `:Show()` / `:Hide()` |
| Permanent OnUpdate juice / center WA pulse | Edge toast + `C_Timer` / AnimationGroup |
| Custom Media blocking load | Fallbacks; frame still opens |

---

## Depth links (in-repo)

| Need | Path |
|------|------|
| When XML vs Lua matrix | [35/when-xml-vs-lua.md](../wow-classic-addon-design/35-xml-vs-lua-ui/when-xml-vs-lua.md) |
| Inheritance mechanics | [35/mechanics-inheritance.md](../wow-classic-addon-design/35-xml-vs-lua-ui/mechanics-inheritance.md) |
| Beef UI recommendation | [35/beef-officer-ladder-ui.md](../wow-classic-addon-design/35-xml-vs-lua-ui/beef-officer-ladder-ui.md) |
| List pooling / Hybrid XML trigger | [57-scrollframe-list-rows](../wow-classic-addon-design/57-scrollframe-list-rows/) |
| Events vs OnUpdate | [04/03-events-onupdate-throttling.md](../wow-classic-addon-design/04-toc-api-performance/03-events-onupdate-throttling.md) |
| Agent UI briefing | [ui-polished-direction-for-agents.md](../../superpowers/ui-polished-direction-for-agents.md) |

---

## Sources

- [CreateFrame — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_CreateFrame) (Jan 2026)
- [CreateFrame — Wowpedia](https://wowpedia.fandom.com/wiki/API_CreateFrame)
- [Virtual XML template — Wowpedia](https://wowpedia.fandom.com/wiki/Virtual_XML_template)
- [XML user interface — Warcraft Wiki](https://warcraft.wiki.gg/wiki/XML_user_interface)
- [BackdropTemplate — Wowpedia](https://wowpedia.fandom.com/wiki/BackdropTemplate) (Classic backport note: 1.14.0)
- [BackdropTemplate — Warcraft Wiki](https://warcraft.wiki.gg/wiki/BackdropTemplate)
- [BackdropTemplate issues — Blizzard forums](https://us.forums.blizzard.com/en/wow/t/backdroptemplate-issues/1125674) (multi-inherit pattern)
- [Frame:CreateFontString — Wowpedia](https://wowpedia.fandom.com/wiki/API_Frame_CreateFontString)
- [FontString — Warcraft Wiki](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)
- [Frame:CreateTexture — Wowpedia](https://wowpedia.fandom.com/wiki/API_Frame_CreateTexture)
- [Widget API — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Widget_API)
- [AnimatableObject:CreateAnimationGroup — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_AnimatableObject_CreateAnimationGroup)
- [UIHANDLER OnUpdate — Warcraft Wiki](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate)
- [Frames: XML vs LUA? — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=51507)
- In-repo: track 35, `UI/MainFrame.lua`, `UI/Toasts.lua`, `docs/superpowers/ui-polished-direction-for-agents.md`

Search result dumps (follow-up only): `.firecrawl/02-lua-vs-xml-frames-search.json`, `02-lua-vs-xml-frames-api.json`, `02-lua-vs-xml-frames-wiki.json`.
