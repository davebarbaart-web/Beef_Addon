# Track: Dominant UX Patterns (Classic)

**Track id:** `01-ux-patterns`  
**Last updated:** 2026-07-25  
**Scope:** Contemporary Classic UI patterns only — Era / Anniversary (TBC) / Cataclysm Classic / Season of Discovery where they differ.  
**Out of scope:** Ace3 internals, packaging, performance deep-dives, visual-language art direction as separate tracks.

## Inventory note

A prior monolithic sketch lived at `../02-ux-patterns-classic.md`. **This folder is the canonical UX-patterns track.** Prefer these focused notes; do not expand the old single-file dump.

Church of Beef V1 UI constraints (slash `/beef`, minimap toggle, ladder / standing / officer tabs, toasts, guild-chat announce) are in the [design spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md).

**Beef synthesis:** [church-of-beef-synthesis.md](church-of-beef-synthesis.md) — maps every surface note below to V1 (edge social tool, officer queue, toasts, ladder ≠ raid frames).

## Index

| Note | Surface |
|------|---------|
| [church-of-beef-synthesis.md](church-of-beef-synthesis.md) | **Synthesis** — Track 01 → Church of Beef V1 decisions |
| [action-bars.md](action-bars.md) | Action bars, paging, cooldowns on buttons |
| [unit-frames.md](unit-frames.md) | Player/target/party unit frames |
| [raid-frames.md](raid-frames.md) | Raid/party grid frames, healer click-cast |
| [nameplates.md](nameplates.md) | Nameplates / Plater / default CVars |
| [bags.md](bags.md) | Bags, bank, inventory browsers |
| [minimap.md](minimap.md) | Minimap chrome + addon buttons |
| [weakauras-overlays.md](weakauras-overlays.md) | WeakAuras-style combat overlays |
| [chat.md](chat.md) | Chat enhancement + social broadcast norms |
| [loot.md](loot.md) | Loot distribution / council UIs |
| [auction.md](auction.md) | Auction house / economy UIs |
| [quest-helpers.md](quest-helpers.md) | Questie, leveling guides, attunement trackers |

## Cross-cutting mental model

Critical **combat** info clusters near the character (center-lower). **Social / utility** tools live at edges (chat, minimap, meters, guild tools). Church of Beef is social theater — treat it like a guild/minimap tool, not a WeakAuras HUD.

## Version shorthand used in notes

| Tag | Meaning |
|-----|---------|
| **Era** | Classic Era / Vanilla-line clients |
| **Anniv** | TBC Classic Anniversary (Beef V1 target) |
| **SoD** | Season of Discovery (Era-family, different systems) |
| **Cata** | Cataclysm Classic (and later progression Classic where noted) |
| **All Classic** | Pattern common across flavors |

## Primary source clusters

- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [Tukui / ElvUI](https://tukui.org/elvui)
- [Blizzard Watch — Classic UI modernization (Jul 2026)](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)
- [LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0)
- CurseForge project pages for named addons (linked in each note)
