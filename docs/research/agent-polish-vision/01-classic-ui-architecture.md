# Classic / TBC Anniversary Addon UI Architecture

**Audience:** Cursor agents polishing Church of Beef UI (`## Interface: 20506`)  
**Status:** Research brief (guidance — not product law)  
**Date:** 2026-07-26  
**Host:** WoW Burning Crusade Classic Anniversary · plain global `ChurchOfBeef` / `COB` · no AceAddon in V1  

**Authority order when this brief conflicts with locked product docs:**

1. Design spec — `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`
2. UI agent briefing — `docs/superpowers/ui-polished-direction-for-agents.md`
3. Cursor rules — especially `addon-module-layers`, `toc-lifecycle`, `wow-ui-taint-lockdown`, `wow-performance`
4. This research brief + deeper tracks under `docs/research/wow-classic-addon-design/`

**Checkout note:** Prefer editing `addon/ChurchOfBeef/` from the Beef_Addon workspace root. The local worktree path `.worktrees/feat-church-of-beef-v1/` may be absent; do not open a worktree as a separate Cursor workspace.

---

## 1. Verdict for Church of Beef

Classic social UIs win when they are **insecure FrameXML-template shells**, **Lua-primary**, **layer-strict**, and **pool-driven**. Beef V1 already matches that pattern: `BasicFrameTemplate` main window under `UIParent`, tab panels as views over Core, `:Show()` / `:Hide()` (not `ShowUIPanel`), dirty-flag refresh when open, no AceAddon bus.

Agents polishing UI should deepen *craft* (factories, row pools, contrast, copy) without inventing a second architecture, Retail chrome, or Core→UI coupling.

---

## 2. TOC patterns and load order

### 2.1 Hard TOC rules

From [TOC format (Warcraft Wiki)](https://warcraft.wiki.gg/wiki/TOC_format) and [Wowpedia TOC format](https://wowpedia.fandom.com/wiki/TOC_format):

| Rule | Why it matters for Beef |
|------|-------------------------|
| Folder name must match `.toc` basename (`ChurchOfBeef/ChurchOfBeef.toc`) | Wrong name → silent “addon missing” |
| Files load **top-to-bottom** in the TOC list | Defines module dependency order |
| Prefer backslashes in TOC paths (`Data\Ranks.lua`) | Wiki recommendation for `Include` / path consistency |
| `## Interface:` must match client or addon is Out of Date | V1 lock: **`20506`** (TBC / Anniversary line) |
| Only list files that exist | Missing TOC entries fail load |
| `## SavedVariablesPerCharacter: ChurchOfBeefDB` | Product choice — alts start Fresh Beef |

Verify live Interface with `/dump (select(4, GetBuildInfo()))` after patches ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)).

### 2.2 Beef load graph (locked)

```text
Data/Ranks.lua
  → Core/*  (Ladder, Scoring, Officer, …, DB)
  → Net/*   (BeefNet, Sync)
  → UI/*    (MainFrame, tabs, Minimap, Toasts, Announce)
  → ChurchOfBeef.lua   (bootstrap LAST)
```

Lifecycle ([`toc-lifecycle.mdc`](../../../.cursor/rules/toc-lifecycle.mdc)):

1. TOC scripts execute (namespace tables attach; **no SV writes**)
2. Client restores `ChurchOfBeefDB` (may be nil first run)
3. `ADDON_LOADED` + `arg1 == "ChurchOfBeef"` → `COB:OnLoad()` → `COB.DB:Init()`
4. `PLAYER_LOGIN` → `COB:OnLogin()` → `UI:Init`, `Net:Init`, `Sync:OnLogin`, instance wiring
5. `/beef` → `COB.UI:Toggle()` only

Never read/write SavedVariables before the named `ADDON_LOADED` gate. Never put bootstrap earlier than UI/Net in the TOC.

### 2.3 Multi-flavor TOC (out of V1 scope)

Suffixes (`_TBC.toc`, `_Mainline.toc`, comma-Interfaces) exist for multi-client packaging ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)). V1 ships **Anniversary-only** `## Interface: 20506`. Do not widen flavors “for polish.”

---

## 3. Frame hierarchy

### 3.1 Recommended tree (matches current MainFrame)

```text
UIParent
└── ChurchOfBeefFrame          -- named; BasicFrameTemplate; MEDIUM; movable; clamped
    ├── TitleBar (drag strip)  -- anonymous; StartMoving / StopMovingOrSizing
    ├── Tab buttons            -- UIPanelButtonTemplate; layout L→R
    ├── Content                -- anonymous host; allPoints inset
    │   ├── Ladder panel       -- one visible tab panel at a time
    │   ├── Standing panel
    │   └── Officer panel      -- officerOnly; hidden for members
    ├── Footer FontString      -- GameFont*; scripture placeholder
    └── CloseButton            -- template close or UIPanelCloseButton
```

Plus **sibling** product surfaces (not parented under raid/action-bar trees):

- Minimap button (hideable; `/beef` remains canonical entry)
- Toast frames (short-lived insecure frames)
- Optional confirm modal (own insecure dialog — not secure templates)

Register the main frame name in `UISpecialFrames` so Escape closes it (already done in `UI/MainFrame.lua`).

### 3.2 Parenting and strata laws

| Do | Don’t |
|----|-------|
| Parent product chrome to `UIParent` or Beef-owned roots | Parent under raid frames, action bars, or other protected trees |
| Keep strata modest (`MEDIUM` + `SetToplevel`) | Fight ElvUI/WA with `TOOLTIP`/`DIALOG` noise by default |
| Store **anchors as plain SV fields** (point, relativePoint, x, y) | Persist frame references in SavedVariables |
| Guest on player `uiScale` | Call `SetCVar("uiScale")` or `UIParent:SetScale` |

### 3.3 CreateFrame fundamentals

From [CreateFrame (Warcraft Wiki)](https://warcraft.wiki.gg/wiki/API_CreateFrame), [CreateFrame (Wowpedia)](https://wowpedia.fandom.com/wiki/API_CreateFrame), and [AddOn Studio CreateFrame notes](https://addonstudio.org/wiki/WoW:API_CreateFrame):

```lua
frame = CreateFrame(frameType [, name, parent, template, id])
```

- **Fourth argument** = comma-delimited list of **virtual XML templates** (e.g. `"BasicFrameTemplate"`, `"UIPanelButtonTemplate"`, `"BackdropTemplate"`).
- Templates must be authored in XML with `virtual="true"` — Lua cannot invent new FrameXML templates ([Virtual XML template](https://warcraft.wiki.gg/wiki/Virtual_XML_template); [XML user interface](https://warcraft.wiki.gg/wiki/XML_user_interface)).
- Inherited **OnLoad runs during `CreateFrame`**; `SetScript("OnLoad", …)` after create does **not** fire — put post-create setup immediately after `CreateFrame`.
- **Frames cannot be deleted or GC’d** — hide + reuse / pool, or you leak until `/reload`.
- Prefer **anonymous** frames (`name = nil`) for rows; keep local references. Named frames pollute `_G`.
- Parent must be a **frame object**, not a string.

Gello’s Classic guidance: use `BasicFrameTemplate` for Classic shells; treat modern Retail panel templates as a different look path ([Blizzard UI forum](https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298)).

### 3.4 Insecure by design (combat)

Classic uses the modern secure/taint model ([Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)). Social windows should stay **insecure** so officers can open `/beef` in a dungeon.

| OK in combat | Avoid / defer |
|--------------|---------------|
| `:Show()` / `:Hide()` on **own insecure** frames | `ShowUIPanel` / `HideUIPanel` on protected panels |
| Updating FontStrings / textures | `SetPoint` / `SetParent` on **protected** widgets |
| BeefNet apply + Core table mutations | Inheriting `SecureActionButtonTemplate` “to open a panel” |
| Dirty-flag refresh of ladder text | Creating secure-template children under the Beef root |

Gello: once a secure child exists, protection walks **up the parent chain** and combat lockdown freezes show/hide of the whole tree ([combat lockdown thread](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)). Beef must never take that path for V1.

---

## 4. Module boundaries (plain global, no AceAddon)

### 4.1 Layer law

```text
UI  → Core → Data
Net → Core → Data

❌ Core → UI / CreateFrame / slash / SendAddonMessage
❌ UI awards points or invents ranks
❌ Net invents ranks without Core apply APIs
```

| Module | Owns | Must not |
|--------|------|----------|
| `Data/Ranks.lua` | Titles, thresholds, seats, officer index | UI strings that fork numbers elsewhere |
| `Core/*` | Ladder, scoring, officer gate, SV shape | `CreateFrame`, chat send, slash |
| `Net/*` | Prefix `COB`, validate, dispatch into Core | Rank invention, frame construction |
| `UI/*` | Frames, tabs, toasts, minimap | Point grants, commit authority |
| `ChurchOfBeef.lua` | Events, `/beef`, Init wiring | Business logic |

Namespace bootstrap in every file:

```lua
ChurchOfBeef = ChurchOfBeef or {}
local COB = ChurchOfBeef
```

After Commit / remote apply: call `COB.UI:RefreshLadder()` (or `MarkDirty`) directly — **no AceEvent bus in V1**.

### 4.2 Tab = view, not store

Pattern already in `UI/MainFrame.lua`:

- `UI:RegisterTab({ name, label, officerOnly, owner })`
- `owner:OnCreate(panel)` builds widgets once
- `owner:OnRefresh(panel)` rebinds from Core getters (**copies**, never live tables)
- Closed window → no paint (`_RefreshActive` early-outs)

TOC order of tab files decides registration order → tab button order.

### 4.3 Cousin addon lessons (construction only)

| Cousin pattern | Steal | Reject |
|----------------|-------|--------|
| Guild ladder / attunement UIs (e.g. HonorSpy-style lists) | Fixed or faux-scrolled **row pools**, officer actions as buttons | Meter density, parse culture chrome |
| DBM / large Classic stacks | Event-driven modules, local refs, sparse globals | AceAddon requirement for Core (breaks desktop harness) |
| ElvUI / skinning suites | Optional coexistence later | Hard-dep Masque/SharedMedia in V1; flat “Retail glass” as brand |
| Retail DF options / Edit Mode libs | Nothing for V1 entry | Branding `/beef` as Edit Mode; Addon Compartment as sole launcher |

Author consensus for small/medium addons: **Lua-first is fine**; XML shines for large static trees and *creating* reusable templates ([WoWInterface — Frames: XML vs LUA?](https://www.wowinterface.com/forums/showthread.php?t=51507)).

---

## 5. Reusable frame factories (agent patterns)

Factories are **Lua functions**, not Ace widgets. Keep them in `UI/` helpers or local to a tab file. Prefer inherit Blizzard chrome over hand-drawing borders.

### 5.1 Shell factory (already the MainFrame pattern)

```lua
local frame = CreateFrame("Frame", "ChurchOfBeefFrame", UIParent, "BasicFrameTemplate")
frame:SetSize(480, 360)
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:EnableMouse(true)
frame:Hide()
-- TitleText from template; drag strip; content inset; UISpecialFrames
```

### 5.2 Button factory

```lua
local function MakePanelButton(parent, text, width, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(width or 100, 22)
  b:SetText(text)
  b:SetScript("OnClick", onClick)
  return b
end
```

([Wowpedia CreateFrame examples](https://wowpedia.fandom.com/wiki/API_CreateFrame) use this exact template inheritance pattern.)

### 5.3 Label / value row factory

```lua
local function MakeTextRow(parent, font)
  local row = CreateFrame("Frame", nil, parent)
  row:SetHeight(16)
  row.label = row:CreateFontString(nil, "OVERLAY", font or "GameFontNormal")
  row.value = row:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
  row.label:SetPoint("LEFT", row, "LEFT", 0, 0)
  row.value:SetPoint("RIGHT", row, "RIGHT", 0, 0)
  return row
end
```

Use `GameFont*` only in V1 (agent UI briefing). Class color on **character names** only — not rank titles as item-quality rainbow.

### 5.4 Backdrop panels (when needed)

Anniversary clients share modern backdrop mixin usage: inherit `"BackdropTemplate"` and call backdrop APIs on that frame ([BackdropTemplate issues — Blizzard UI forum](https://us.forums.blizzard.com/en/wow/t/backdroptemplate-issues/1125674)). Prefer template-native chrome first; do not paint brand hex fills in V1.

### 5.5 Row pool factory (lists)

Frames persist for the session ([CreateFrame notes](https://addonstudio.org/wiki/WoW:API_CreateFrame); [Warcraft Wiki CreateFrame](https://warcraft.wiki.gg/wiki/API_CreateFrame)):

```lua
local function AcquireRow(pool, parent, factory)
  local row = table.remove(pool.free)
  if not row then
    row = factory(parent)
    pool.all[#pool.all + 1] = row
  end
  row:Show()
  return row
end

local function ReleaseAll(pool)
  for i = 1, #pool.all do
    pool.all[i]:Hide()
    pool.free[#pool.free + 1] = pool.all[i]
  end
end
```

**V1 scale:** seven ladder bands + a short officer queue → fixed pools beat HybridScroll. Add [FauxScrollFrame](https://warcraft.wiki.gg/wiki/Making_a_scrollable_list_using_FauxScrollFrameTemplate) only when viewport < data. Hybrid often wants an XML `virtual` button template — defer until a real need (track 57).

### 5.6 When to add addon XML

Add `UI/Templates.xml` **only if**:

- The same complex row layout is copy-pasted ≥3 times → `virtual="true"` template
- Hybrid scroll CreateButtons requires a named virtual button template
- Designers need a declarative shell separate from Lua

Until then: **no `.xml` in the TOC** (matches plan + track 35).

---

## 6. Retail-only / Retail-first APIs to avoid (or gate hard)

V1 target is Anniversary `20506`. Treat the following as **forbidden defaults** unless a locked port task + in-client probe says otherwise:

| API / pattern | Why avoid on Beef V1 | Safer Classic path |
|---------------|----------------------|--------------------|
| `DefaultPanelTemplate` / DF “modern panel” chrome | Retail look; Classic shell is `BasicFrameTemplate` ([Gello](https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298)) | `BasicFrameTemplate`, `UIPanelButtonTemplate` |
| `## AddonCompartmentFunc*` as sole entry | Dragonflight compartment UX; Anniv presence not guaranteed ([TOC Addon compartment notes](https://warcraft.wiki.gg/wiki/TOC_format); track 28) | Minimap button + `/beef` |
| Edit Mode registration libs (`EditModeExpanded`, etc.) | Custom frames are invisible to Edit Mode unless registered; wrong product metaphor (track 66) | Drag + `ChurchOfBeefDB.ui.point` |
| Retail `ScrollBox` / modern collection list widgets | Newer list stack; Classic lists use Faux/Hybrid/ScrollFrame | Fixed pool or FauxScrollFrame |
| `Settings.Register*` / modern Settings API assumptions | Options UI churn across flavors | Tiny settings on-frame (position, minimap hide, announce) |
| Blind `C_AddOns.*` without fallback | Namespace churn vs legacy `IsAddOnLoaded` (track 55) | Probe both if soft-deps ever appear |
| Secure templates / state drivers for panels | Protects parent chain; blocks combat toggle ([secure model](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)) | Insecure frames + `:Show()` |
| Stock `UIDropDownMenu_*` / `EasyMenu` | Known taint vector ([LibUIDropDownMenu](https://www.wowinterface.com/downloads/info24408-LibUIDropDownMenu.html)) | Custom buttons, or LibUIDropDownMenu if menus appear |
| Center-screen WA-style pulses for social | Spec / UI briefing ban | Guild chat line + edge toast |
| AceAddon / AceGUI / AceEvent for Core+UI | Offline harness + V1 simplicity | Plain `COB` tables |

**Portability rule:** if a tutorial says “Dragonflight+”, assume **guilty until Anniversary `/dump` proves it**.

---

## 7. Actionable rules for Cursor agents

1. **Read before CreateFrame:** `docs/superpowers/ui-polished-direction-for-agents.md` → spec §10/§15 → glossary 74–81 → this brief → `wow-ui-taint-lockdown` / `wow-performance`.
2. **Extend, don’t fork:** put polish in `UI/MainFrame.lua` and tab files; expand TOC only for files that exist.
3. **Lua-primary + inherit templates:** `CreateFrame(..., "BasicFrameTemplate"|"UIPanelButtonTemplate"|…)` — do not hand-rebuild Blizzard chrome.
4. **UI is a view:** call Core getters; never grant standing or invent rank ids in OnClick.
5. **Pool or fixed rows:** never `CreateFrame` per BeefNet message or per guild member forever.
6. **Dirty-flag paint:** mark dirty on data change; refresh only when window shown; coalesce storms ≤ ~10 Hz when open.
7. **Insecure toggles:** `:Show()` / `:Hide()`; no `ShowUIPanel` for `/beef`.
8. **Hook, don’t replace:** `HookScript` / `hooksecurefunc` on Blizzard widgets; never overwrite `ChatFrame.AddMessage`.
9. **SV hygiene:** persist numbers/strings/booleans for UI position; never frame userdata.
10. **Silent media fallbacks:** missing textures/fonts must not fail load; V1 needs no custom `Media/`.
11. **Officer tab gating:** show only when `COB.Officer:LocalIsOfficer()`; listen to guild roster events.
12. **No AceAddon** for V1 Core/UI; keep desktop `lua tests/run.lua` green when Core/Data change.
13. **Interface stays `20506`** unless intentionally bumping after live verify.
14. **Confirm destructive officer actions** (demote, Prophet, Council) with friction — own modal or careful StaticPopup (`preferredIndex = 3`).
15. **Spectacle stays thin:** one throttled `/g` line + private toast — not a Retail activity feed.

---

## 8. Anti-patterns (reject in review)

| Anti-pattern | Why it fails Classic / Beef |
|--------------|----------------------------|
| AceAddon `NewModule` UI for V1 | Couples load to LibStub; hurts offline Core tests |
| `SecureActionButtonTemplate` to open `/beef` | Protects the tree; combat lockdown |
| Parenting Beef under ElvUI/raid containers | Layout/taint coupling |
| CreateFrame-per-row with no pool | Session memory leak ([CreateFrame cannot delete](https://warcraft.wiki.gg/wiki/API_CreateFrame)) |
| Full ladder rebuild on every addon message | Combat hitch; violates performance rule |
| Retail glass / low-alpha panels | Spec + Classic rejection of glossy defaults |
| Standing as StatusBar / “HP bar” | Spec / briefing ban |
| Item-quality rainbow for ranks | Wrong metaphor |
| Threshold numbers forked into UI copy | Canon lives in `Data/Ranks.lua` only |
| `SetScript` wiping Blizzard OnClick | Breaks template sounds / taint risk — use `HookScript` |
| Listing missing files in TOC | Load failure |
| Addon Compartment-only entry on Anniv | May be inert; strands players |
| Permanent `OnUpdate` for ladder paint | Idle cost; use events + dirty flags |
| Core calling `COB.UI` for logic side effects beyond refresh | Layer inversion — refresh OK; decisions belong in Core |

---

## 9. Polish checklist (agents + human smoke)

### 9.1 Architecture / load

- [ ] TOC order still Data → Core → Net → UI → bootstrap
- [ ] Every TOC path exists; backslashes; `## Interface: 20506`
- [ ] `ADDON_LOADED` gated; UI/Net init on `PLAYER_LOGIN`
- [ ] No Core `CreateFrame`; no UI point grants
- [ ] Offline: `lua tests/run.lua` exits `0` after Core/Data edits

### 9.2 Frame craft

- [ ] Main shell inherits Classic-verified template (`BasicFrameTemplate`)
- [ ] Buttons inherit `UIPanelButtonTemplate` (or verified cousin)
- [ ] Movable, clamped, position restored from `ChurchOfBeefDB.ui`
- [ ] Escape closes via `UISpecialFrames`
- [ ] Anonymous pooled/fixed rows; no global names per row
- [ ] Officer tab hidden for non-officers; visible after roster update

### 9.3 Combat / taint

- [ ] `/beef` opens in combat (insecure path)
- [ ] No secure templates under Beef root
- [ ] No stock UIDropDownMenu for officer actions
- [ ] Confirms do not taint action bars (own modal preferred)

### 9.4 Visual / UX polish (V1 bar)

- [ ] Opaque high-contrast panels; `GameFont*` hierarchy readable at stream distance
- [ ] Dual-encode pending / approve / reject (color **and** text/icon — not color alone)
- [ ] Class color on names only
- [ ] Standing uses **text thresholds**, not hero StatusBar
- [ ] Footer placeholder only — no lore system
- [ ] Minimap hide setting works; `/beef` still works when icon hidden
- [ ] Missing media cannot break load
- [ ] No tip jars, ads, or donation CTAs

### 9.5 In-game smoke (required when UI touched)

```text
install addon/ChurchOfBeef → Interface/AddOns/ChurchOfBeef
/console scriptErrors 1
/reload
/beef  → tabs render; drag; Escape closes
earn/suggest path → Standing + Officer queue refresh
officer Commit → ladder refresh + announce/toast path
combat → toggle /beef still works
```

Prefer BugGrabber + BugSack. Guild/net paths need two clients (Officer+ and Member).

---

## 10. Mapping to existing Beef research

| Topic | Deeper track |
|-------|----------------|
| XML vs Lua | `docs/research/wow-classic-addon-design/35-xml-vs-lua-ui/` |
| Taint / lockdown | `…/29-taint-secure-ui/` |
| Scroll / pools | `…/57-scrollframe-list-rows/` |
| TOC / Interface | `…/04-toc-api-performance/` |
| Minimap / compartment | `…/28-minimap-addon-compartment/` |
| Edit Mode coexistence | `…/66-editmode-classic-coexistence/` |
| Classic vs Retail taste | `…/12-classic-vs-retail-philosophy/` |
| StaticPopup confirms | `…/58-staticpopup-confirms/` |

This brief is the **agent-facing synthesis** for polish work; those tracks remain the deep reference libraries.

---

## 11. Sources

Primary / cited in this brief:

- [TOC format — Warcraft Wiki](https://warcraft.wiki.gg/wiki/TOC_format) (Jul 2026 Interface tables)
- [TOC format — Wowpedia](https://wowpedia.fandom.com/wiki/TOC_format)
- [CreateFrame — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_CreateFrame)
- [CreateFrame — Wowpedia](https://wowpedia.fandom.com/wiki/API_CreateFrame)
- [CreateFrame — AddOn Studio](https://addonstudio.org/wiki/WoW:API_CreateFrame) (cannot delete frames; OnLoad timing; virtual inherit)
- [Virtual XML template — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Virtual_XML_template)
- [XML user interface — Warcraft Wiki](https://warcraft.wiki.gg/wiki/XML_user_interface)
- [Secure Execution and Tainting — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)
- [Showing Elements in Combat Lockdown — Blizzard UI forum (Gello)](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)
- [Creating a simple GUI element with XML — Blizzard UI forum (Gello, Classic templates)](https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298)
- [BackdropTemplate issues — Blizzard UI forum](https://us.forums.blizzard.com/en/wow/t/backdroptemplate-issues/1125674)
- [Frames: XML vs LUA? — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=51507)
- [LibUIDropDownMenu — WoWInterface](https://www.wowinterface.com/downloads/info24408-LibUIDropDownMenu.html)
- [FauxScrollFrame HOWTO — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Making_a_scrollable_list_using_FauxScrollFrameTemplate)

**wowprogramming.com:** historically mirrored the same Widget/CreateFrame reference material as Wowpedia; prefer **warcraft.wiki.gg** / Wowpedia links above as the maintained mirrors (Wowpedia itself redirects readers to Warcraft Wiki for ongoing updates).

**In-repo implementation anchors:**

- `addon/ChurchOfBeef/ChurchOfBeef.toc`
- `addon/ChurchOfBeef/ChurchOfBeef.lua`
- `addon/ChurchOfBeef/UI/MainFrame.lua` (+ tab modules)
- `.cursor/rules/` (layers, TOC lifecycle, taint, performance)
- `docs/superpowers/ui-polished-direction-for-agents.md`

**Search provenance** (not product truth): `_search-classic-ui-arch.json`, `_search-retail-apis-classic.json`, `_search-classic-templates.json` in this folder.

---

*End of brief. Update the design spec decisions log if polish work changes product policy — do not silently fork policy into research alone.*
