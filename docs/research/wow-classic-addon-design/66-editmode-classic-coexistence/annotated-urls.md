# Annotated URLs — Edit Mode / modernized Classic UI coexistence

**Last updated:** 2026-07-25  
**Usage:** Primary citation list for track 66. Prefer Kaivax / PTR notes over listicles when making product arguments.

---

## First-party / blue posts (Anniversary + Classic wave)

| URL | What it is | Church of Beef relevance |
|-----|------------|--------------------------|
| [PTR Development Notes — BCC Anniversary](https://us.forums.blizzard.com/en/wow/t/the-burning-crusade-classic-anniversary-ptr-development-notes/2201610) (2025-11-18) | Official PTR notes: **Edit Mode added as UI QoL**; notes QoL UI options may later reach Classic Era | Anchors *when* Anniversary Edit Mode was committed — not a Jul-2026 surprise |
| [User Interface Updates in Classic — Kaivax](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408) (2026-07-10; Jul 17 update) | Shared modern UI code doctrine; 2.5.5 War Within → 2.5.6 Midnight raid frames; nameplate/raid options; Edit Mode raid-frame knobs; 1.15.9 Edit Mode for Era/SoD/HC; third-party breakage warning; 2.5.6≈1.15.9 API advice | Canonical Jul 2026 modernization source for Beef coexistence assumptions |
| [Patch 2.5.6/API changes (wiki)](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes) | Mirrors Kaivax blues + CVar chat commands for plates/dispel overlays | Stable cite when forums are noisy; packaging cross-check with `20506` |

---

## Press / secondary summaries of the blues

| URL | What it is | Church of Beef relevance |
|-----|------------|--------------------------|
| [Warcraft Tavern — Edit Mode coming to TBC Anniversary](https://www.warcrafttavern.com/tbc/news/edit-mode-is-coming-to-the-ui-for-tbc-classic-anniversary-edition/) (2025-11-18) | Early coverage of PTR Edit Mode line; notes lack of Classic implementation detail at announce time | Use for timeline + “Retail tool landing on CoB’s flavor” |
| [Warcraft Tavern — UI update to Era/SoD/HC](https://www.warcrafttavern.com/wow-classic/news/user-interface-update-coming-to-wow-classic-era-sod-hardcore/) (2026-07-10) | Summarizes Anniversary 2.5.6 plates/frames and Edit Mode arriving to other Classic modes in 1.15.9 | Clarifies Anniversary-first vs Era-follow wave |
| [Blizzard Watch — modernized Classic/Anniversary UI](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/) (2026-07-22) | Editorial: Midnight-like plate/frame look; Edit Mode Classic preset ≠ visual rollback; shared-code maintenance motive | Explains why “plain Classic frames” ≠ 2007 freeze; supports distinct Beef window identity |
| [MMO-Champion — UI Updates in Classic](https://www.mmo-champion.com/content/14360-User-Interface-Updates-in-WoW-Classic) (2026-07-10) | Short mirror of Kaivax third-party addon warning | Quick secondary cite |

---

## Anniversary player reception (coexistence stress tests)

| URL | What it is | Church of Beef relevance |
|-----|------------|--------------------------|
| [EU forums — Built-in Edit Mode](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446) (2026-01) | Shortened vs Retail; DFUI/ElvUI/MoveAnything conflict; chat edge clamps; raid-frame healer pain; Classic preset still broken for #NoChanges | Warns against half-baked layout managers; keep `/beef` simple and independent |
| [EU forums — Fix “Edit Mode”](https://eu.forums.blizzard.com/en/wow/t/fix-edit-mode/602113) (2026-01) | Chat/raid breakage; overlap of bars/bags/tooltips; desire to disable Edit Mode | Reinforces: do not parent to chat/bars; expect default UI instability |
| [US forums — Anniversary/ERA needs new UI?](https://us.forums.blizzard.com/en/wow/t/anniversaryera-needs-the-new-ui-and-high-resolution-textures/2204244?page=3) | Polarized modern UI vs purist fight | Mixed guild taste on Dreamscythe/Doomhowl — optional aesthetics only |
| [US forums — Classic+ wants Retail UI editor](https://us.forums.blizzard.com/en/wow/t/one-retail-change-i-would-genuinely-dig-for-classic-is-the-modern-ui-editor/2137436) (2025-07) | Split wish for grid editor vs refusal of modern UI | Optional modernization demand ≠ Beef product identity |

---

## Retail Edit Mode reference (contrast only)

| URL | What it is | Church of Beef relevance |
|-----|------------|--------------------------|
| [Wowhead — UI and HUD Edit Mode Guide](https://www.wowhead.com/guide/ui/ui-and-hud-edit-mode-guide) (updated 2026-06) | How Retail Edit Mode works: Escape menu, blue elements, layouts, share/import; mentions Cooldown Manager | Contrast doc — what Retail players expect; what CoB must **not** require or brand |
| [US forums — Programmatically modifying UI while respecting Edit Mode](https://us.forums.blizzard.com/en/wow/t/programmatically-modifying-the-ui-while-respecting-edit-mode/2036818) (2024-12) | Author pattern for writing/activating Edit Mode layouts for Blizzard systems | Shows complexity; **anti-pattern for Beef V1** (do not inject layouts) |

---

## Third-party Edit Mode bridges

| URL | What it is | Church of Beef relevance |
|-----|------------|--------------------------|
| [CurseForge — Edit Mode Expanded](https://www.curseforge.com/wow/addons/edit-mode-expanded) | Expands Blizzard Edit Mode; Classic TBC builds; ships author library | Proof custom frames are opt-in; V1 should not hard-depend |
| [GitHub — teelolws/EditModeExpanded](https://github.com/teelolws/EditModeExpanded) | Source + feature list (custom frame move/resize, per Edit Mode profile save) | Technical provenance for Expanded behavior |
| [EME wiki — Authors: Library Usage](https://github.com/teelolws/EditModeExpanded/wiki/Authors:-Library-Usage) (2025-12) | `RegisterFrame` / resize / hide / reposition API | Cost model if V2 ever soft-deps Expanded |
| [CurseForge — FerrozEditModeLib](https://www.curseforge.com/wow/addons/ferrozeditmodelib) | Lightweight Register helper (Retail-leaning) | Alternate opt-in pattern; not a V1 dep |

---

## Adjacent Beef research (do not duplicate)

| Path / URL | Role |
|------------|------|
| [12 — rejected-from-retail.md](../12-classic-vs-retail-philosophy/rejected-from-retail.md) | Product reject: Edit Mode as identity |
| [12 — annotated-urls.md](../12-classic-vs-retail-philosophy/annotated-urls.md) | Broader Classic vs Retail citation set |
| [30 — api-ui-deltas.md](../30-anniversary-vs-era-deltas/api-ui-deltas.md) | Flavor packaging + shared-UI delta matrix |
| [37 — beef-toast-panel-placement.md](../37-movable-frames-anchors/beef-toast-panel-placement.md) | Concrete default anchors / toast rules |
| [02 — classic-native-vs-retail.md](../02-visual-language/01-classic-native-vs-retail.md) | Visual identity under modernization drift |
| [28 — annotated-urls.md](../28-minimap-addon-compartment/annotated-urls.md) | Jul 2026 wave ≠ Addon Compartment |

---

## Demo / community UI (secondary)

| URL | What it is | Church of Beef relevance |
|-----|------------|--------------------------|
| [YouTube — Dvalin UI 1.0 for TBC Classic](https://www.youtube.com/watch?v=DwWtdytD3oU) | Addon-free UI built with Anniversary built-in Edit Mode | Shows players *will* rearrange default HUD; Beef must not assume stock positions |
| [Threads — Dvalin UI announce](https://www.threads.com/@dvalingaming/post/DTh8Ex3iIbZ/tbc-classic-anniversary-just-got-a-built-in-ui-edit-mode-so-i-put-it-to-use-and) (2026-01-15) | Same: Edit Mode used as full UI authoring on Anniversary | Reinforces contested screen real estate |

---

## Internal research provenance

| Path | What it is |
|------|------------|
| [`.raw/search-editmode-shipped.json`](.raw/search-editmode-shipped.json) | Parallel search: what shipped Jul 2026 / Anniversary |
| [`.raw/search-coexistence-api.json`](.raw/search-coexistence-api.json) | Parallel search: third-party registration / conflicts |
| [`.raw/search-systems-list.json`](.raw/search-systems-list.json) | Parallel search: Edit Mode systems / Expanded |
| [`.raw/extract-primary-blues.json`](.raw/extract-primary-blues.json) | Extracts: Kaivax, Blizzard Watch, Tavern, wiki |
| [`.raw/extract-coexistence.json`](.raw/extract-coexistence.json) | Extracts: Expanded, EU threads, Wowhead guide |
| [`.raw/extract-systems-ptr.json`](.raw/extract-systems-ptr.json) | Extracts: PTR notes, Era Tavern, Expanded GitHub |
| [`.raw/extract-wiki-editmode.json`](.raw/extract-wiki-editmode.json) | Extracts: EME library usage, Wowhead guide (wiki Edit_Mode fetch failed) |

---

## Suggested citation order for design reviews

1. Shipped timeline — [PTR notes](https://us.forums.blizzard.com/en/wow/t/the-burning-crusade-classic-anniversary-ptr-development-notes/2201610) + [Kaivax Jul 2026](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)  
2. No rollback / shared code — [Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)  
3. Coexistence pain — [EU Built-in Edit Mode](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446)  
4. Third-party opt-in only — [Edit Mode Expanded](https://www.curseforge.com/wow/addons/edit-mode-expanded) + [library wiki](https://github.com/teelolws/EditModeExpanded/wiki/Authors:-Library-Usage)  
5. Beef placement — this track’s [beef-panel-toast-implications.md](beef-panel-toast-implications.md) + [track 37](../37-movable-frames-anchors/beef-toast-panel-placement.md)
