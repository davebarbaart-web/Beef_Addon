# 09 — Guild, Community & Social Addon Design

**Track date:** 2026-07-25  
**Scope:** Classic / TBC Classic guild, community, and social addon patterns — belonging, rituals, status, shared identity.  
**Constraint:** Design research only. No addon code.  
**Product lens:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)

## Why this track exists

Church of Beef is explicitly a **social guild and streamer-event** addon, not a combat tool. The closest living ecosystem is guild management: enriched rosters, calendars/RSVPs, attendance ledgers, loot-council / DKP standing systems, recognition shoutouts, and (conceptually) Discord ↔ game bridges.

## Documents in this folder

| Doc | Contents |
|-----|----------|
| [addon-landscape.md](addon-landscape.md) | Notable Classic-relevant guild/social addons by category |
| [patterns-belonging-rituals-status.md](patterns-belonging-rituals-status.md) | Cross-cutting design patterns (belonging, rituals, status, identity) |
| [officer-queues-and-ledgers.md](officer-queues-and-ledgers.md) | Officer UX: voting queues, audit trails, fair standing |
| [discord-bridges-conceptual.md](discord-bridges-conceptual.md) | Out-of-game community layer (conceptual only for V1) |
| [implications-for-church-of-beef.md](implications-for-church-of-beef.md) | Steal / adapt / avoid mapped to the V1 spec |
| [annotated-urls.md](annotated-urls.md) | Annotated URL bibliography |

## Provenance

- Parallel deep research: [`.raw/guild-social-deep.md`](.raw/guild-social-deep.md) (run `trun_91f36069f0964480b9da827881728251`)
- Web search JSON under [`.raw/`](.raw/)
- Primary pages: CurseForge / Wago / GitHub wiki / Guilds of WoW / Warcraft Tavern

## Hard product boundaries (do not forget)

From the V1 spec: **fully in-game**, Lua/XML, no external process controlling gameplay, no Retail-only APIs. Discord bridges and web platforms are **inspirational patterns**, not V1 dependencies.
