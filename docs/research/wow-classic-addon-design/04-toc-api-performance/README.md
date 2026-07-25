# Track 04 — TOC / Interface Versioning / SavedVariables / Performance / Combat Lockdown

**Date:** 2026-07-25  
**Scope:** Packaging metadata, persistence, event/OnUpdate cost, combat lockdown, and performance norms for WoW Classic addons (2024–2026).  
**Product lens:** Church of Beef V1 on **TBC Classic Anniversary** (`Interface` **20506**).  
**Out of scope here:** Addon implementation, BeefNet protocol details (see sibling tracks), UI chrome.

## Documents

| File | Topic |
|------|--------|
| [01-interface-versions-and-toc.md](01-interface-versions-and-toc.md) | Classic flavor Interface numbers, TOC metadata, suffixes, multi-client packaging |
| [02-savedvariables.md](02-savedvariables.md) | Account vs per-character SV, load order, AceDB scopes |
| [03-events-onupdate-throttling.md](03-events-onupdate-throttling.md) | Events vs OnUpdate, timers, throttling patterns |
| [04-combat-lockdown.md](04-combat-lockdown.md) | `InCombatLockdown`, protected frames, taint, deferral |
| [05-performance-norms.md](05-performance-norms.md) | Profiler context, soft budgets, social-addon norms |
| [06-church-of-beef-constraints.md](06-church-of-beef-constraints.md) | Top technical constraints mapped to the V1 design spec |
| [SOURCES.md](SOURCES.md) | Annotated citations |

## Provenance

- Parallel deep research: `.raw/wow-classic-toc-api-perf.{json,md}` (run `trun_91f36069f0964480b226011299249e76`)
- Firecrawl scrapes of primary wiki / Ace / patch notes under `.raw/`
- **Prefer scraped wiki + patch TOC numbers over secondary summaries** when they disagree (e.g. live TBC Interface is **20506**, not older deep-research guesses)

## How to verify Interface live

In the target client chat:

```
/dump (select(4, GetBuildInfo()))
```

See [TOC format — Determining the interface version](https://warcraft.wiki.gg/wiki/TOC_format#Determining_the_interface_version).
