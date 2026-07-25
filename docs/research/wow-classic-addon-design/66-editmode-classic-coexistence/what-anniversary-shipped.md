# What Anniversary actually shipped (Edit Mode + modern UI)

**Track:** [66-editmode-classic-coexistence](README.md)  
**Last updated:** 2026-07-25  
**Claim standard:** Prefer Kaivax / PTR notes; secondary press only when they quote those blues.

---

## 1. Timeline (Anniversary-centric)

| When | What shipped | Source |
|------|--------------|--------|
| **2025-11-18** | BCC Anniversary PTR notes: **“Edit Mode added as a quality-of-life option for players’ user interfaces.”** Framed alongside other Anniversary QoL (account-wide attune bags, etc.). Blizzard also floated that UI QoL like Edit Mode *could* reach Classic Era later. | [PTR Development Notes](https://us.forums.blizzard.com/en/wow/t/the-burning-crusade-classic-anniversary-ptr-development-notes/2201610); [Warcraft Tavern summary](https://www.warcrafttavern.com/tbc/news/edit-mode-is-coming-to-the-ui-for-tbc-classic-anniversary-edition/) |
| **~2026-01-13** | TBC Anniversary **pre-patch** live; Edit Mode present in the live Anniversary client. Community immediately calls it shortened vs Retail and disruptive to existing UI addons. | [EU “Built-in Edit Mode”](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446) (2026-01-14); [EU “Fix Edit Mode”](https://eu.forums.blizzard.com/en/wow/t/fix-edit-mode/602113) (2026-01-19); [Dvalin UI / built-in Edit Mode demos](https://www.youtube.com/watch?v=DwWtdytD3oU) |
| **Patch 2.5.5 era** | Anniversary raid-frame option lineage described as **The War Within**–era frames (shared modern UI path). | [Kaivax — UI Updates](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408); [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes) |
| **2026-07 (~2.5.6)** | Anniversary bump **2.5.5 → 2.5.6**: service systems + **nameplate and raid frame** updates aligned with **Midnight** offering. | Same Kaivax post / wiki mirror |
| **2026-07-17 hotfixes** (Anniversary) | Extra Options + Edit Mode knobs: raid-frame health/bg colors; dispel indicators (default off); Edit Mode **Layout Template, Opacity, Aura Icon Size** for raid frames; nameplate **class color** options; aura-preview / compare-tooltip bugfixes. | [Kaivax Update July 17](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408); [Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/) |
| **Week of 2026-07-19** | Classic Era / SoD / Hardcore **1.15.9**: Edit Mode + analogous nameplate/raid-frame changes. Authors told **1.15.9 addon API ≈ 2.5.6**; use Anniversary as prep. Expect third-party breakage until updates. | Kaivax; [Warcraft Tavern Era note](https://www.warcrafttavern.com/wow-classic/news/user-interface-update-coming-to-wow-classic-era-sod-hardcore/) |

**Important correction for product language:** Do not say “Anniversary only got Edit Mode in July 2026.” Anniversary had Edit Mode from pre-patch; July 2026 modernized **plates/frames** and **expanded Edit Mode options** on those systems, then pushed Edit Mode into Era/SoD/HC.

---

## 2. What Edit Mode is on Classic (vs Retail marketing)

### Official pitch

- Retail: HUD Edit Mode (Dragonflight+) lets players move/configure default UI without addons — Escape → Edit Mode; blue-highlighted elements; layouts with share/import ([Wowhead Edit Mode guide](https://www.wowhead.com/guide/ui/ui-and-hud-edit-mode-guide)).
- Anniversary: Blizzard billed the same family of tool as **optional UI QoL**, not as a content system ([PTR notes](https://us.forums.blizzard.com/en/wow/t/the-burning-crusade-classic-anniversary-ptr-development-notes/2201610)).

### What players reported on Anniversary (Jan 2026)

These are **community reports**, not a Blizzard feature matrix — useful as coexistence stress tests:

| Complaint theme | Detail (forums) |
|-----------------|-----------------|
| Shortened vs Retail | Primary action bar / micro menu / bags less editable than expected; artwork/gryphon toggles disputed | [Built-in Edit Mode](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446) |
| Chat regressions | Main chat movable only via Edit Mode; hard to tuck to screen edge; tab/edit-box overlap | Same + [Fix Edit Mode](https://eu.forums.blizzard.com/en/wow/t/fix-edit-mode/602113) |
| Raid frames | Stacking / range highlight / healer usability regressions vs old Classic layout | Same threads |
| Addon conflict | Dragonflight UI, ElvUI, MoveAnything called out as superior or broken-around | [Built-in Edit Mode](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446) |
| No full off-switch | Desire to disable Edit Mode / restore pre-Edit Mode standard UI; “Classic” preset still modern tooling | Same; [Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/) |
| Forced modern chrome | Extra action bars, bag overlap, cooldown numbers on default UI | [Built-in Edit Mode](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446); [Fix Edit Mode](https://eu.forums.blizzard.com/en/wow/t/fix-edit-mode/602113) |

**Coexistence takeaway:** On Anniversary, Edit Mode is both a **player layout tool** and a **source of default-UI instability**. Addon authors cannot assume a stable 2007 chrome baseline.

---

## 3. What the Jul 2026 modernization actually changed

From Kaivax ([forum](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408); wiki mirror [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes)):

### Shared-code doctrine

- All Classic versions share code with modern WoW (hardware, graphics/accessibility, widescreen, Battle.net).
- Shared code also imports modern UI elements to “fill gaps” in original UI.
- Raid-frame history called out explicitly: Classic 2019 shipped BfA-era modern raid frames → Anniversary 2.5.5 War Within frames → **2.5.6 Midnight-aligned** raid-frame option.

### Player-facing knobs (post-2.5.6 / Jul 17)

**Raid frames**

- Interface options: health bar color, background color
- Show/hide dispellable debuff indicators (default **off**)
- Edit Mode: Layout Template, Opacity, Aura Icon Size
- Edit Mode preview bugfix for oversized aura icons

**Nameplates**

- Interface / CVar path to color friendly or enemy plates by **player class color**
- Documented interim chat commands (later to Options):
  - `nameplateShowClassColor`
  - `nameplateShowFriendlyClassColor`
  - `raidFramesDispelIndicatorOverlay` (disable dispel highlights)

### Author-facing warning

- “Some third-party addons may experience errors until they are updated by their authors.”
- 1.15.9 ≈ 2.5.6 UI addon API — test on Anniversary 2.5.6 for Era readiness.

### What Blizzard Watch adds (editorial, Jul 22)

- Appearance of plates/frames read as closer to **Midnight** styling.
- Classic Edit Mode preset exists, but **existence of Edit Mode itself** is already a modern shift; no real permanent visual rollback ([article](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)).

---

## 4. What did *not* ship (scope discipline)

Do **not** invent these as Anniversary first-party features without a primary cite:

| Not established as Anniversary Edit Mode deliverable | Notes |
|------------------------------------------------------|-------|
| Full Retail Cooldown Manager / boss timeline / built-in damage meter as Classic parity | Retail Edit Mode guide documents modern Retail HUD extras ([Wowhead](https://www.wowhead.com/guide/ui/ui-and-hud-edit-mode-guide)); Anniversary forum reception describes a **restricted** Edit Mode, not Retail feature parity |
| Addon Compartment / Retail micro-menu parity | Separate track ([28-minimap-addon-compartment](../28-minimap-addon-compartment/)); Jul 2026 wave is plates/frames/Edit Mode |
| Ability for arbitrary third-party frames to appear in Edit Mode without a library | Blizzard highlights its own systems; Expanded/Ferroz-style libs exist for opt-in registration ([Edit Mode Expanded](https://www.curseforge.com/wow/addons/edit-mode-expanded)) |
| A supported “disable Edit Mode / 2007 UI” toggle | Players repeatedly ask; Blizzard’s answer path is Options + CVars + Classic preset, not a full rollback |

---

## 5. Flavor matrix (Beef packaging context)

| Flavor | Edit Mode | Modern plates/frames wave | Beef V1 |
|--------|-----------|---------------------------|---------|
| TBC Anniversary | Since pre-patch Jan 2026; Jul 2026 expanded raid-frame Edit Mode options | 2.5.5 → 2.5.6 Midnight align | **Target** |
| Classic Era / SoD / HC | Added with **1.15.9** (week of Jul 19, 2026) | Same wave | Not V1 |
| Retail | Full Edit Mode product surface | N/A | Contrast only |

Cross-ref packaging: [30-anniversary-vs-era-deltas/api-ui-deltas.md](../30-anniversary-vs-era-deltas/api-ui-deltas.md).
