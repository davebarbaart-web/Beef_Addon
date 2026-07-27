# 47 — Minimap standing glance UX (Church of Beef)

**Lane:** Agent polish vision · edge launcher + at-a-glance standing  
**Audience:** Agents polishing `UI/Minimap.lua` (and any later LibDBIcon path) — not a product-law fork  
**Last updated:** 2026-07-26  
**Status:** Research synthesis for polish — **not** product law. Spec §10 / §15, glossary 68 / 75 / 76, and [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.

**Authority (do not invert):**

1. Design spec §10 / §15 — `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`
2. Machine canon — `addon/ChurchOfBeef/Data/Ranks.lua` (`COB.Ranks`) — titles/thresholds only here
3. Implementer locks — glossary rows 68, 75, 76 ([locked-v1-decisions](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md))
4. This note — presentation + Classic-safe interaction; log any new product choice in the spec decisions log

**Related:** [01 minimap](../wow-classic-addon-design/01-ux-patterns/minimap.md) · [28 launcher](../wow-classic-addon-design/28-minimap-addon-compartment/beef-launcher-recommendations.md) · [70 progress / standing](../wow-classic-addon-design/70-standing-breakdown-ui/) · [08 settings UX](./08-savedvars-settings-ux.md) · [03 taint](./03-taint-lockdown-ux.md) · [13 ladder psychology](./13-rank-ladder-psychology.md)

**Implementation today:** hand-rolled `ChurchOfBeefMinimapButton` in `addon/ChurchOfBeef/UI/Minimap.lua` — stock food icon + tracking border; tooltip is brand + “Click to open… /beef”; left-click → `COB.UI:Toggle()`.

**Numbers:** Do not restate standing thresholds in this doc. UI reads `COB.Ranks` / Core getters at runtime.

---

## 1. Verdict (one screen)

The minimap button is a **Classic edge launcher with a standing glance in the GameTooltip**, not a second My Standing panel glued to the map. Idle chrome stays a single ~31×31 ringed icon. Hover reveals **current title · standing · distance to next point-driven title** (or appointed-only copy) · optional petition line · `/beef` reminder. Click toggles the same insecure frame as `/beef`. No StatusBar, no center HUD, no Questie-style rank pins, no Retail Addon Compartment dependency.

---

## 2. Jobs to be done

| Job | Where it lives | Must not become |
|-----|----------------|-----------------|
| Discover the addon | Visible icon (default shown) + slash | Hidden-by-default wart |
| Open the church UI | Left-click = `/beef` toggle | SecureActionButton / `ShowUIPanel` |
| Know my title at a glance | Tooltip line 1–2 (title + standing) | Floating FontString over the map |
| Know progress to next threshold | Tooltip “N to {NextTitle}” | Minimap castbar / XP skin |
| Know if officers owe me a look | Tooltip petition line (+ optional dual-encoded icon cue) | Pulsing WA center alert |
| Stay out of combat HUD | Edge cluster only | Nameplate / unit-frame chrome |
| Survive collectors / clean UIs | Hide pref + slash always works | Compartment-only entry on Anniv |

---

## 3. Classic constraints (hard)

| Constraint | Implication for glance UX |
|------------|---------------------------|
| Anniversary `20506`; no Retail-only APIs | No Addon Compartment as sole door; no Edit Mode widgets; verify templates in-client |
| Product frames insecure | Button is plain `CreateFrame("Button", …, Minimap)` (or LibDBIcon later); `:Show()`/`:Hide()` only |
| UI → Core → Data | Tooltip **reads** Ladder/Scoring/Ranks; never awards points or invents ranks |
| Glossary 76 / spec §10 | Progress is **text thresholds** first; no hero StatusBar on the map |
| Performance (social idle) | Build tooltip on `OnEnter` only; **no** permanent `OnUpdate` to animate glance |
| Taint / lockdown | Click may open insecure `/beef` in combat; never inherit secure templates “to open a panel” |
| Minimap hostility | One hideable icon; no extra rank pins fighting Questie/GatherMate ([01](../wow-classic-addon-design/01-ux-patterns/minimap.md)) |
| Collectors | Prefer LibDBIcon-shaped behavior when embedding ([28](../wow-classic-addon-design/28-minimap-addon-compartment/beef-launcher-recommendations.md)); hand-rolled OK if smoke-tested |
| Media fallbacks | Stock `Interface\\Icons\\…` + tracking border until art pass; missing TGA must not fail load |
| Settings budget (glossary 75) | Minimap hide only — no glance density sliders, strata pickers, or “show bar on map” prefs in V1 |

---

## 4. Information architecture — three layers

Think **icon · tooltip · panel**, not one overloaded wart.

```text
┌─ LAYER A: Idle icon (always cheap) ─────────────────────────┐
│  Ringed Classic minimap button                               │
│  Stock / brand icon                                          │
│  Optional quiet petition cue (dot/border tint + not color-only)│
└──────────────────────────────────────────────────────────────┘
         hover
┌─ LAYER B: Standing glance (GameTooltip) ─────────────────────┐
│  Brand + title + standing + next / appointed + petition + slash│
└──────────────────────────────────────────────────────────────┘
         left-click
┌─ LAYER C: Full church UI (/beef) ────────────────────────────┐
│  Ladder / My Standing / Officer — detail, history, rites     │
└──────────────────────────────────────────────────────────────┘
```

**Rule:** If it needs history, source chips, or officer actions, it belongs in Layer C — not the tooltip.

---

## 5. Wireframe-in-prose

### 5.1 Idle (no hover)

Around the circular Classic minimap, among other addon warts, sits one Church of Beef button: stock meat/food icon (or later `Media` seal), Blizzard `MiniMap-TrackingBorder`, zoom highlight on mouseover. No numbers painted on the icon. If the local player has a pending promote suggestion, a small dual-encoded cue may appear (e.g. gold corner pip **and** a distinct border state) — never a hue-only badge. Button may be dragged along the ring (persist `ui.minimapAngle`) if already supported; collectors may swallow it — slash still works.

### 5.2 Hover — GameTooltip (standing glance)

Owner: the button; anchor: `ANCHOR_LEFT` (or LibDBIcon default). Opaque Classic tooltip chrome — no glass custom tip frame in V1.

**Point-driven member (ranks Fresh Beef → Beef Butcher), mid-grind:**

```text
Church of Beef                          ← yellow title line (GameTooltip:AddLine default)
Cooked Beef · 38 standing               ← white; title from canon, standing from Core
12 to Beef Knight                       ← white; remaining = next threshold − standing (clamp ≥ 0)
Left-click: open ladder  ·  /beef       ← gray hint line
```

**Eligible / petition pending:**

```text
Church of Beef
Beef Knight · 210 standing
0 to Beef Lord                          ← or “Eligible — waiting on officers”
Petition pending officers               ← dual-encode: word first; soft gold optional
Left-click: open ladder  ·  /beef
```

**Appointed band (Council / Prophet) — no fake grind:**

```text
Church of Beef
Beef Council · 1040 standing            ← standing may still exist; not a ladder rung
Appointed ranks only                    ← same copy family as My Standing
Left-click: open ladder  ·  /beef
```

**Unguilded / scoring paused:**

```text
Church of Beef
Not in a guild                          ← honest empty; no invented progress
Left-click: open ladder  ·  /beef
```

**Fresh install / zero standing:**

```text
Church of Beef
Fresh Beef · 0 standing                 ← endowed membership, not “unranked”
N to Cooked Beef                        ← N from canon at runtime, not hardcoded in docs
Left-click: open ladder  ·  /beef
```

Keep the tip to **≤5 lines**. Juice = specific title + remaining + petition honesty — not lore walls, not source-chip dumps, not officer queue depth.

### 5.3 Click

| Input | Behavior |
|-------|----------|
| Left-click | `COB.UI:Toggle()` — same as `/beef` |
| Right-click (optional V1.1) | Prefer **no** competing menu in V1; if added later: “Hide minimap button” confirm or jump to My Standing tab — never a secure dropdown |
| Drag | Reposition on ring; save angle only |

Do **not** open Blizzard guild UI, options, or StaticPopup from the minimap click path in V1.

### 5.4 After click — panel handoff

Opening `/beef` should land on the player’s last tab (if persisted) or Ladder; **do not** force My Standing every click — the glance already answered “where am I?” Forcing Standing every time trains players to treat the panel as a meter, not a church.

---

## 6. Data bindings (UI reads only)

| Tooltip / cue slot | Source |
|--------------------|--------|
| Brand header | Static “Church of Beef” |
| Official title | Local player ladder record → `COB.Ranks.Title(rankId)` |
| Standing integer | Core standing getter for local player (advisory) |
| Next line | Same rules as `StandingTab` `nextThresholdCopy`: point-driven → remaining to next point-driven title; else “Appointed ranks only” |
| Petition line | Pending suggestion for local player, if any |
| Unguilded | `IsInGuild` / empty-state track 41 |
| Icon petition cue | Same pending flag; dual-encode |

**DRY:** Extract one small helper (e.g. `COB.UI.StandingGlanceLines()` or shared with StandingTab) so minimap tooltip and My Standing header cannot drift. Thresholds always via `COB.Ranks.Threshold` / `IsPointDriven` — never literals in UI strings as policy.

---

## 7. Interaction & motion budget

| Moment | Behavior |
|--------|----------|
| Hover enter | Rebuild tip from Core; `GameTooltip:Show()` |
| Hover leave | `GameTooltip:Hide()` |
| Standing grant while tip shown | Optional: refresh tip if still owned by this button; **no** bounce animation |
| Rank commit / sync | Update pending cue on next paint / next enter — no OnUpdate pulse |
| Combat | Click + tip OK on insecure button; do not defer glance text |
| Hidden via settings | Button `:Hide()`; `/beef` remains |

**Silent V1:** no SFX on hover/click (spec §10).

---

## 8. Do / Don’t

| Do | Don’t |
|----|-------|
| One hideable Classic wart | Rank pins, second floating “glance frame,” XP bar on the map |
| Text titles/thresholds from `Data/Ranks.lua` | Hardcode “50 to Cooked” in copy docs or Lua |
| “N to {NextTitle}” / “Appointed ranks only” | Imply points unlock Council/Prophet |
| Dual-encode petition | Color-only pip; WA center pulse |
| Left-click = `/beef` toggle | SecureActionButton; compartment-only entry |
| Stock icon until art pass | Fail load on missing `Media/` |
| Build tip on `OnEnter` | Permanent `OnUpdate` for “live” glance |
| Keep tip ≤5 lines | Dump recent rites / source chips into tooltip |

---

## 9. Phased recommendation

| Phase | Minimap glance |
|-------|----------------|
| **V1 (now)** | Enrich hand-rolled tooltip with title · standing · next/appointed · petition · slash; left-click toggle; hide pref; stock icon; optional quiet petition cue |
| **V1 + embed trigger** | Migrate to LibDBIcon + LDB `launcher` when coexistence pain appears ([28](../wow-classic-addon-design/28-minimap-addon-compartment/beef-launcher-recommendations.md)); keep same tip contract via LDB `OnTooltipShow` |
| **V1.1** | Optional right-click hide; optional open-to-Standing once if playtest asks — still no map bar |
| **Art / spectacle pass** | Brand TGA under `Media/` with fallback; tip copy stays text-first |

---

## 10. Acceptance checklist (in-client)

- [ ] Icon visible by default; hide persists across `/reload`
- [ ] `/beef` works with icon hidden or collected
- [ ] Hover shows current canon title + standing without opening the panel
- [ ] Point-driven: remaining line matches My Standing math
- [ ] Butcher+ / Council / Prophet: “Appointed ranks only” — no fake next threshold
- [ ] Pending suggestion: worded petition line (and optional dual-encoded cue)
- [ ] Unguilded: honest empty, not fabricated progress
- [ ] Left-click toggles same frame as slash; works in combat if panel stays insecure
- [ ] No StatusBar / floating number on the minimap
- [ ] No script errors with `/console scriptErrors 1` when tip builds with missing ladder record

---

## 11. Explicit non-goals

- LibDBIcon / Ace hard dependency for the glance itself (embed when triggered, glossary 67)
- Retail Addon Compartment as Anniversary entry
- Standing-as-HP meter on or beside the minimap
- Tooltip liturgy, tip jars, or streamer name-mask controls (Streamer Mode is post-V1)
- Guild-wide neighbor ranks on hover (“you vs Beefina”)

---

## 12. Community & industry patterns (why this shape)

### 12.1 Classic minimap politics

Players call crowded rims “minimap herpes” and reach for collectors ([r/wow — mini map buttons](https://www.reddit.com/r/wow/comments/mgwv60/if_you_use_a_lot_of_addons_with_mini_map_buttons/); [Blizzard forums — Miniimap cluttered](https://us.forums.blizzard.com/en/wow/t/minimap-cluttered-addon-help/304044)). Anniversary collectors exist specifically for TBC Classic Anniversary ([MinimapButtonCollector — GitHub](https://github.com/mikarregui/MinimapButtonCollector)). Implication for CoB:

| Community pressure | CoB response |
|--------------------|--------------|
| Too many warts | **One** icon; hide pref first-class; slash always works |
| Collectors swallow icons | Tip contract must not depend on icon visibility for core play |
| Authors reinvent buttons poorly | Prefer LibDBIcon when embedding pain appears ([WoWI — LibDBIcon example](https://www.wowinterface.com/forums/showthread.php?t=59832); [CurseForge LibDBIcon](https://www.curseforge.com/wow/addons/libdbicon-1-0)) |
| Hand-rolled tip bugs | Use `GameTooltip:AddLine` / LDB `OnTooltipShow` — do not invent FontStrings each enter ([WoWI — Minimap Button Tooltip](https://www.wowinterface.com/forums/showthread.php?t=51533); [Phanx guidance in-thread](https://www.wowinterface.com/forums/showpost.php?p=304870&postcount=2)) |

### 12.2 Progressive disclosure (tooltip ≠ panel)

UX progressive disclosure: show a **summary**, reveal detail on demand ([NN/g — Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/); [Microsoft — Progressive disclosure controls](https://learn.microsoft.com/en-us/windows/win32/uxguide/ctrl-progressive-disclosure-controls)). Map to CoB layers:

1. **Idle icon** — existence + optional petition cue (feedforward).  
2. **Tooltip** — standing glance (title · standing · next/appointed · petition).  
3. **`/beef`** — history, officer queue, rites.

If the tip grows past ~5 lines, agents are smuggling Layer C into Layer B — cut, don’t add a second floating frame.

### 12.3 Glance readability (capture + contrast)

Stream and accessibility practice both punish glass/low-contrast overlays:

- Body text ≥ **4.5:1** against the tip panel fill ([WCAG 1.4.3 Contrast Minimum](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html); [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)).  
- Prefer stock opaque `GameTooltip` chrome over custom translucent tips.  
- Dual-encode petition state (word + pip) — color alone fails color-vision users ([Material — Accessibility / color](https://m3.material.io/foundations/accessible-design/overview)).

### 12.4 What HonorSpy / LDB teach (steal carefully)

Cousin pattern: personal estimate on hover, dense table in the panel ([HonorSpy Classic listings](https://legacy-wow.com/classic-addons/honorspy/); LDB `launcher` vs `data source` — [LibDataBroker data specs](https://github.com/tekkub/libdatabroker-1-1/wiki/Data-specifications)). Steal the **personal glance**; do **not** steal live-updating rim text that needs permanent `OnUpdate`.

---

## 13. Decision one-liner

**Minimap = Classic launcher wart; standing glance = GameTooltip juice (title · standing · next/appointed · petition); click = `/beef`. Text numbers from Core/canon; never put a progress bar on the map.**

---

## External sources

Research orientation only — **not** product law. Spec §10 / glossary 68–76 win on conflict.

1. [LibDBIcon-1.0 — CurseForge](https://www.curseforge.com/wow/addons/libdbicon-1-0) — de facto Classic minimap launcher library.  
2. [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0) — author docs / register contract.  
3. [LibDataBroker — How to provide a dataobject](https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject) — launcher object shape.  
4. [LibDataBroker — Data specifications](https://github.com/tekkub/libdatabroker-1-1/wiki/Data-specifications) — `OnTooltipShow` / type norms.  
5. [WoWInterface — Minimap Button Tooltip](https://www.wowinterface.com/forums/showthread.php?t=51533) — prefer LDB + LibDBIcon; GameTooltip hygiene.  
6. [WoWInterface — Simple LibDBIcon example](https://www.wowinterface.com/forums/showthread.php?t=59832) — register + tip + click map.  
7. [Blizzard forums — How to add a button to the minimap](https://us.forums.blizzard.com/en/wow/t/how-to-add-a-button-to-the-minimap/367416) — author starting point → LibDBIcon.  
8. [Blizzard forums — Minimap cluttered addon help](https://us.forums.blizzard.com/en/wow/t/minimap-cluttered-addon-help/304044) — player pain with wart rings.  
9. [r/wow — lots of mini map buttons](https://www.reddit.com/r/wow/comments/mgwv60/if_you_use_a_lot_of_addons_with_mini_map_buttons/) — collectors / DataBroker culture.  
10. [MinimapButtonCollector — GitHub (TBC Classic Anniversary)](https://github.com/mikarregui/MinimapButtonCollector) — modern Anniversary collector reality.  
11. [NN/g — Progressive Disclosure](https://www.nngroup.com/articles/progressive-disclosure/) — tip = summary; panel = detail.  
12. [W3C — WCAG 1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) · [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/) — tip text vs panel fill.  
13. [Wowpedia — GameTooltip:AddDoubleLine](https://wowpedia.fandom.com/wiki/API_GameTooltip_AddDoubleLine) — Classic tip API.  
14. [r/wowaddondev — Creating a minimap button](https://www.reddit.com/r/wowaddondev/comments/1esk1p2/creating_a_wow_addon_part_12_creating_a_minimap/) — contemporary author walkthrough.  
)
