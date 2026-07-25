# Track: Combat HUD, Cooldowns, Resources, Alerts

**Track id:** `08-combat-hud-alerts`  
**Last updated:** 2026-07-25  
**Scope:** Classic / TBC Anniversary combat HUD design patterns — cooldown managers, resource bars, proc alerts, boss-mod warnings, WeakAuras combat packs, nameplate/threat UX.  
**Out of scope:** Addon implementation, Retail-only APIs as dependencies, Church of Beef product features that would assist combat decisions.

## Why this track exists

Church of Beef is explicitly **not** a raid-optimization or combat-assistance tool ([design spec §1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Competitive players still run a dense combat stack (boss mods, WeakAuras, OmniCC, nameplates). This track documents that stack so Beef UI can:

1. **Stay out of the way** of combat HUD real estate
2. **Borrow** urgency / toast / glanceability norms that players already understand
3. **Avoid** red-alert / center-screen / boss-bar patterns that train panic or compete with BigWigs/DBM

## Index

| Note | Topic |
|------|--------|
| [hud-atlas-and-urgency.md](hud-atlas-and-urgency.md) | Screen zones, color urgency, sound vs visual, clutter rules |
| [cooldown-managers.md](cooldown-managers.md) | OmniCC, TellMeWhen, ClassicSpellActivations, bar overlays |
| [resource-bars-and-procs.md](resource-bars-and-procs.md) | Resource bars, proc glows, class WA packs |
| [boss-mods-bigwigs-dbm.md](boss-mods-bigwigs-dbm.md) | BigWigs / DBM warning design |
| [weakauras-combat-packs.md](weakauras-combat-packs.md) | WeakAuras + Wago combat import culture |
| [nameplates-and-threat.md](nameplates-and-threat.md) | Plater / TidyPlates / Kui / ThreatClassic2 |
| [annotated-urls.md](annotated-urls.md) | Annotated URLs + Church of Beef relevance |
| [church-of-beef-implications.md](church-of-beef-implications.md) | Synthesis mapped to V1 (toasts, guild announce, non-combat) |

## Provenance

| Artifact | Role |
|----------|------|
| [`.raw/combat-hud-deep.md`](.raw/combat-hud-deep.md) | Parallel deep-research export (`pro-fast`) |
| [`.raw/combat-hud-deep.json`](.raw/combat-hud-deep.json) | Deep-research metadata + structured fields |
| [`.raw/search-*.json`](.raw/) | Parallel web-search result dumps |
| [`.raw/extract-*.json`](.raw/) | Primary-page extracts (CurseForge, GitHub, Wago) |

## Client focus

| Flavor | Notes for this track |
|--------|----------------------|
| **Anniv (TBC)** | Primary — Overgear/Playhub/MMO lists treat BigWigs, DBM, WeakAuras, OmniCC, Plater as the combat baseline |
| **Era / SoD / Hardcore** | Same HUD atlas; WA packs and boss modules differ by expansion |
| **Retail** | Contrast only (built-in PRD / Edit Mode) — do not depend on for V1 |

## Hard product reminder

Per [design spec §2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md): no combat decision-making, no protected-action circumvention, no automation. Research here informs **presentation etiquette**, not rotation helpers.
