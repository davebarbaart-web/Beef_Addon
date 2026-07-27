# 05 — Minimap / LDB patterns for standing glance

**Series:** `docs/research/agent-polish-vision/`  
**Last updated:** 2026-07-26  
**Audience:** Agents polishing Church of Beef entry UX (minimap + optional LDB).  
**Product law still wins:** design spec §10 / §15 · glossary 68 / 75 · UI brief. This note is pattern guidance, not a silent fork.

---

## One-line verdict

**Keep `/beef` as the real door.** Treat the minimap as a **standing glance + same-frame toggle**. Ship custom today; migrate to **LibDBIcon + LDB** when collectors bite (track 28 / 42). Juice lives in a **short hover tooltip**, not a second spreadsheet on the rim.

---

## Return path (what to ship, in order)

| Phase | Ship | Why |
|-------|------|-----|
| **V1 now** | Custom `UI/Minimap.lua` (already) + richer tooltip + click labels | Zero embeds; matches dep policy trigger 0→2 ([42](../wow-classic-addon-design/42-soft-deps-embeds/beef-v1-dependency-policy.md)) |
| **V1 polish** | Tooltip = title · standing · next · click map; left = `/beef` toggle | Standing glance without opening My Standing ([70](../wow-classic-addon-design/70-standing-breakdown-ui/beef-v1-recommendation.md)) |
| **Collector pain** | Embed `LibStub` → `LibDataBroker-1.1` → `LibDBIcon-1.0`; one LDB object; register after SV ready | De facto Classic launcher shape ([LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0), [track 28](../wow-classic-addon-design/28-minimap-addon-compartment/)) |
| **LDB bar bonus** | Same object visible on Bazooka / Titan / Arcana | Free second surface; no extra UI code ([28 coexistence](../wow-classic-addon-design/28-minimap-addon-compartment/coexistence-hide-norms.md)) |
| **Never Anniv-only** | Retail Addon Compartment as sole entry | Compartment is DF+; Anniv has no tray ([28 README](../wow-classic-addon-design/28-minimap-addon-compartment/README.md)) |

**Hard invariants (locked elsewhere):**

- Minimap click and `/beef` toggle the **same** frame ([spec §10](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- Hide preference is first-class; slash must still work ([glossary 75](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md)).
- No rank pins on the minimap ([01 minimap](../wow-classic-addon-design/01-ux-patterns/minimap.md)).
- Frame created on load / first `/beef`, never only inside `OnClick` ([28 launcher recs](../wow-classic-addon-design/28-minimap-addon-compartment/beef-launcher-recommendations.md)).

---

## Current checkout (baseline)

`addon/ChurchOfBeef/UI/Minimap.lua` today:

- Plain `CreateFrame("Button", …, Minimap)` — **no LibDBIcon**.
- Left/right registered; **both call `COB.UI:Toggle()`** (no differentiated affordance yet).
- Tooltip: title + “Click to open… /beef”.
- Hide via `ChurchOfBeefDB.ui.minimapHide` / `COB.Minimap:SetShown`.

That is a valid **V1a** path under dependency policy. Polish work is mostly **tooltip juice + click map**, not a forced embed.

---

## LibDBIcon vs custom

### Custom (hand-rolled Minimap child)

| Pros | Cons |
|------|------|
| Zero LibStub / LDB surface area; offline tests stay dumb | Collectors (HidingBar, MinimapButtonButton, Anniv bags) may miss or mis-place the button |
| Full control of textures / drag / angle | Square minimap / shape helpers often ignored |
| Matches “prefer zero libs until pain” ([42](../wow-classic-addon-design/42-soft-deps-embeds/beef-v1-dependency-policy.md)) | No free LDB bar presence |

Author culture still prefers LDB over scratch buttons when coexistence matters ([WoWInterface — Phanx](https://www.wowinterface.com/forums/showthread.php?t=51533)).

### LibDBIcon + LibDataBroker

| Pros | Cons |
|------|------|
| Collector-friendly shape; hide/show + angle in a saved table ([WowAce LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0)) | Embed cost: LibStub + LDB + LibDBIcon |
| Classic + Classic TBC flavors still shipping (v12.x, Jul 2026) ([CurseForge LibDBIcon](https://www.curseforge.com/wow/addons/libdbicon-1-0)) | AceDB sample is common; Beef can pass a plain SV table instead |
| Same object feeds LDB bars | Still not a substitute for `/beef` |

**Contract (author-facing):** create LDB object → after SV exists → `icon:Register("ChurchOfBeef", obj, db.minimap)` → `db.minimap.hide` + `Hide`/`Show` for the settings toggle ([WowAce](https://www.wowace.com/projects/libdbicon-1-0)). Prefer `OnTooltipShow(tooltip)` so LibDBIcon (or Bazooka) owns anchor/clear/show; you only `AddLine` ([LDB data specs](https://github.com/tekkub/libdatabroker-1-1/wiki/Data-specifications)).

### Decision for Beef polish

| Question | Answer |
|----------|--------|
| Must V1 embed LibDBIcon? | **No** — custom is shipped; embed on **collector friction** (track 42 trigger 2). |
| Preferred long-term shape? | **LibDBIcon + LDB**, same hide key semantics as today. |
| Acceptable interim? | Custom that **behaves** like LibDBIcon: named button, hide flag, slash-sufficient, drag optional. |

---

## LDB type: launcher vs data source (standing glance)

Tekkub’s specs ([Data specifications](https://github.com/tekkub/libdatabroker-1-1/wiki/Data-specifications), [How to provide a dataobject](https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject)):

| `type` | Meaning | Bar UI | Fit for Beef |
|--------|---------|--------|--------------|
| `"launcher"` | Icon + `OnClick`; no live `text` | Button on bar / minimap | **Primary** — panel toggle, not a ticker |
| `"data source"` | Requires `text` (+ optional `value`/`suffix`/`label`) | Always-up feed (FPS-style) | Optional **later** if guild wants “Cooked · 38” on a broker bar |

**Recommendation:**

1. **V1 / V1 polish:** Prefer `type = "launcher"` (or custom button with launcher semantics). Standing glance lives in **`OnTooltipShow`**, not in a mutating `text` field that needs update storms.
2. **V1.5+ optional:** Dual-mode or second object — `data source` with short `text` like `Cooked 38` **only if** playtest wants bar glance without hover. Update `text` on standing dirty (event/coalesce), never `OnUpdate` ([performance rule](../../.cursor/rules/wow-performance.mdc)).
3. Do **not** use LibDBIcon’s WowAce sample `type = "data source"` + static `"Bunnies!"` as the semantic model for a social panel — that sample is about registration, not product type ([WowAce](https://www.wowace.com/projects/libdbicon-1-0)).

LDB’s original pitch: detach plugins from Titan/FuBar and let users skip minimap warts by not installing a display ([LibDataBroker README](https://github.com/tekkub/libdatabroker-1-1)). Beef should treat LDB as **optional discovery**, not as authority for ranks.

---

## Tooltips with juice (standing glance)

### Job of the hover

Answer in **one hover**, without opening `/beef`:

1. What is my **Church title**?
2. What is my **standing**?
3. What is **next** (or “appointed ranks only”)?
4. How do I **open** / what do clicks do?

My Standing tab still owns history chips and story lines ([70](../wow-classic-addon-design/70-standing-breakdown-ui/beef-v1-recommendation.md)). Tooltip ≠ tab.

### Density budget (tooltip)

| Line | Content | Notes |
|------|---------|-------|
| 1 | `Church of Beef` (or branded title) | `SetText` / yellow header |
| 2 | Current title · standing number | e.g. `Cooked Beef · 38` — one currency only |
| 3 | Next threshold **or** appointed copy | Text remaining; no fake bar for Council/Prophet |
| 4 | Optional one-liner state | Petition pending / unguilded / capped today — **one** of these |
| 5–6 | Click map (grey) | See affordances below |
| — | Slash reminder | `/beef` once, not every line |

**Hard caps:** ≤ **6** body lines; ≤ **~60** characters per line; **no** history rows, source chips, officer queue, or guild matrix on the tip ([70 density antipatterns](../wow-classic-addon-design/70-standing-breakdown-ui/density-antipatterns.md)).

### Juice without noise

| Do | Don’t |
|----|-------|
| Sparse liturgy in the **title** only ([32 copy](../wow-classic-addon-design/32-microcopy-tone-voice/beef-copy-guidelines.md)) | Steak puns on every line |
| Dual-encode state in words (“Petition pending”) | Color-only meaning |
| `AddDoubleLine("Standing", "38")` for scanability ([GameTooltip:AddDoubleLine](https://wowpedia.fandom.com/wiki/API_GameTooltip_AddDoubleLine)) | Custom FontString tooltips from scratch ([Phanx](https://www.wowinterface.com/forums/showthread.php?t=51533)) |
| Refresh tip contents on enter from Core getters (copies) | Cache stale standing for a whole session |
| Guard `if not tooltip or not tooltip.AddLine then return end` | Assume the display always passes `GameTooltip` |

### Example shape (conceptual)

```text
Church of Beef
Cooked Beef · 38 standing
12 to Beef Knight
Left-click: open ladder
Right-click: My Standing   ← only if wired
/beef always works
```

Implement with `OnTooltipShow` (LDB) or `GameTooltip:SetOwner` + `AddLine` / `AddDoubleLine` (custom). Call `:Show()` after lines; `AddLine` alone does not show ([GameTooltip notes](https://wowpedia.fandom.com/wiki/UIOBJECT_GameTooltip)).

---

## Click affordances

Classic community convention (examples: [WoWInterface LibDBIcon sample](https://www.wowinterface.com/forums/showthread.php?t=59832), [Tidy Plates paste](https://pastebin.com/dmEgbFu7), [r/wowaddondev minimap tutorial](https://www.reddit.com/r/wowaddondev/comments/1esk1p2/creating_a_wow_addon_part_12_creating_a_minimap/)):

| Button | Common pattern | Beef recommendation |
|--------|----------------|---------------------|
| **Left** | Toggle main UI | **Locked:** same as `/beef` → `COB.UI:Toggle()` |
| **Right** | Options / secondary panel | **V1 polish:** open main frame on **My Standing** tab if easy; else same toggle + tip says so. Settings are starved (position / minimap hide / announce) — do **not** invent a right-click options tree yet ([glossary 75](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md)). |
| **Middle** | Rare (config category) | **Skip** in V1 |
| **Shift/Alt+click** | Power-user | **Skip** — undiscoverable for guild installs |
| **Drag** | Reposition on rim | LibDBIcon handles; custom may keep angle SV |

**Rules:**

1. Document the map **in the tooltip** every time (`Left-click: …`). Grey body text (~0.8, 0.8, 0.8).
2. `RegisterForClicks` must match what you handle; today’s code registers Right but ignores button — either wire Right or stop registering it.
3. Cousin social pattern: HonorSpy uses **right-click → options** and slash for show ([HonorSpy](https://legacy-wow.com/classic-addons/honorspy/)). Beef’s settings budget is thinner; prefer Right → Standing glance tab over a full options menu.
4. Never require a secure frame for open/toggle ([LDB quicklauncher](https://github.com/tekkub/libdatabroker-1-1/wiki/Data-specifications); [taint rule](../../.cursor/rules/wow-ui-taint-lockdown.mdc)).

---

## Accessibility of info density

“Glance” fails if the tip is a DKP table or a joke wall. Apply the same density ethics as My Standing, stricter:

| Concern | Pattern |
|---------|---------|
| **Cognitive load** | Three facts max above the fold (title, standing, next). Everything else is click chrome. |
| **Colorblind / stream** | Words for pending/capped; class color only on **player names** if ever shown — not on the tip header ([UI brief](../../superpowers/ui-polished-direction-for-agents.md)). |
| **Scale / UIParent** | Guest on player `uiScale`; GameTooltip inherits — do not SetScale the tip. |
| **Combat** | Hover tip OK; do not create protected widgets. Opening `/beef` stays insecure Show/Hide. |
| **Hidden icon** | Players hide buttons or bag them ([r/classicwow clutter](https://www.reddit.com/r/classicwow/comments/ffa99x/any_idea_of_an_addon_i_can_use_to_sort_out_the/)). Glance must also be reachable via **My Standing tab** and slash — tooltip is convenience, not sole HUD. |
| **LDB bar text** | If `data source` lands later, keep bar text ≤ ~12–16 chars (`Cooked 38`); detail stays on hover. |
| **Screen reader / motor** | WoW has no real SR path; compensate with **predictable left-click** and **slash parity**, not hover-only features. |
| **Error states** | Unguilded / no roster: tip says so in one line; do not invent standing progress ([70 states](../wow-classic-addon-design/70-standing-breakdown-ui/beef-v1-recommendation.md)). |

### Anti-patterns (refuse on the rim)

- Full guild ladder or CEPGP columns in the tip.
- Source chip strip + last-10 history (that is the Standing tab).
- Pulsing icon / WA-style alert for every +1 standing.
- Dual LDB objects that both open different “truths.”
- Tooltip that awards or suggests promote (UI never awards points).

---

## Pattern catalog (steal / adapt)

| Pattern | Steal | Adapt for Beef |
|---------|-------|----------------|
| LDB launcher + LibDBIcon register | [WowAce](https://www.wowace.com/projects/libdbicon-1-0), [Tekkub launcher](https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject) | Plain SV table; no AceAddon |
| `OnTooltipShow` fill-only | [LDB specs](https://github.com/tekkub/libdatabroker-1-1/wiki/Data-specifications), [Phanx](https://www.wowinterface.com/forums/showthread.php?t=51533) | Standing triple + click map |
| Left open / Right secondary | [WoWI sample](https://www.wowinterface.com/forums/showthread.php?t=59832), HonorSpy options | Right → Standing tab; settings stay starved |
| Hide + slash hygiene | [28 coexistence](../wow-classic-addon-design/28-minimap-addon-compartment/coexistence-hide-norms.md) | `minimapHide` / LibDBIcon `hide` |
| Collector bag reality | HidingBar / MinimapButtonButton | Smoke-test when embedding |
| Personal estimate vs guild table | HonorSpy “search one” vs full standings | Tip = personal; Ladder tab = guild titles |

---

## Implementer checklist (polish)

- [ ] Tooltip answers title / standing / next in ≤3 lines.
- [ ] Click map printed; left = `/beef` toggle; right behavior documented and wired (or unregistered).
- [ ] `/beef` works with icon hidden or collected.
- [ ] No standing grant / Net / CreateFrame in Core from this path — UI reads Core copies only.
- [ ] If embedding: register after `ADDON_LOADED` SV init; OptionalDeps LibDBIcon OK; **embed** so solo load works.
- [ ] Soft-test: stock minimap, hide toggle, optional HidingBar, optional Bazooka ([28 checklist](../wow-classic-addon-design/28-minimap-addon-compartment/coexistence-hide-norms.md)).

---

## Related research (do not duplicate)

| Track / doc | Owns |
|-------------|------|
| [28-minimap-addon-compartment](../wow-classic-addon-design/28-minimap-addon-compartment/) | Collectors, compartment, LibDBIcon contract, launcher ship decision |
| [42-soft-deps-embeds](../wow-classic-addon-design/42-soft-deps-embeds/) | When to embed LDB stack |
| [70-standing-breakdown-ui](../wow-classic-addon-design/70-standing-breakdown-ui/) | My Standing tab density (tooltip is a **strict subset**) |
| [01-ux-patterns/minimap.md](../wow-classic-addon-design/01-ux-patterns/minimap.md) | Surface UX / no rank pins |
| [UI polished direction](../../superpowers/ui-polished-direction-for-agents.md) | V1 chrome doctrine |

Raw search dumps (not product truth): `.raw/minimap-ldb-patterns.json`, `.raw/ldb-standing-glance.json` beside this folder.

---

## Sources

- [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0)
- [LibDBIcon-1.0 — CurseForge](https://www.curseforge.com/wow/addons/libdbicon-1-0)
- [LibDataBroker — How to provide a dataobject](https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject)
- [LibDataBroker — Data specifications](https://github.com/tekkub/libdatabroker-1-1/wiki/Data-specifications)
- [LibDataBroker — GitHub README](https://github.com/tekkub/libdatabroker-1-1)
- [Minimap Button Tooltip — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=51533)
- [Simple LibDBIcon example — WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=59832)
- [Creating a Minimap Button — r/wowaddondev](https://www.reddit.com/r/wowaddondev/comments/1esk1p2/creating_a_wow_addon_part_12_creating_a_minimap/)
- [GameTooltip:AddDoubleLine — Wowpedia](https://wowpedia.fandom.com/wiki/API_GameTooltip_AddDoubleLine)
- [HonorSpy — Legacy-WoW](https://legacy-wow.com/classic-addons/honorspy/)
- In-repo: tracks 28, 42, 70; `addon/ChurchOfBeef/UI/Minimap.lua`; design spec §10
