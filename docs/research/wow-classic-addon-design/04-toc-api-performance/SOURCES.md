# Sources — Track 04

**Collected:** 2026-07-25  
**Methods:** Parallel deep research (`pro-fast`, run `trun_91f36069f0964480b226011299249e76`); Firecrawl scrape/search into `.raw/`.

---

## Primary (prefer these)

| Source | URL | Used for |
|--------|-----|----------|
| TOC format | https://warcraft.wiki.gg/wiki/TOC_format | Interface table, suffixes, metadata, SavedVariables directives, AllowLoadGameType |
| Patch 2.5.5 API changes | https://warcraft.wiki.gg/wiki/Patch_2.5.5/API_changes | TOC `20505` |
| Patch 2.5.6 API changes | https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes | TOC `20506`; Kaivax Classic UI modernization notes |
| Saving variables between game sessions | https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions | SV scopes, ADDON_LOADED / PLAYER_LOGOUT |
| Handling events | https://warcraft.wiki.gg/wiki/Handling_events | Event registration patterns |
| UIHANDLER OnUpdate | https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate | OnUpdate cost, throttle, C_Timer guidance |
| API InCombatLockdown | https://warcraft.wiki.gg/wiki/API_InCombatLockdown | Lockdown timing and restrictions |
| Secure Execution and Tainting | https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting | Taint model, protected frames, secure templates, Classic note |
| AceDB-3.0 | https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0 | AceDB scopes / profile defaults |

Local scrapes: `.raw/toc-format.md`, `saving-variables.md`, `handling-events.md`, `onupdate.md`, `incombatlockdown.md`, `secure-execution.md`, `ace-db.md`, `patch-255-api.md`, `patch-256-api.md`.

---

## Secondary

| Source | URL | Used for |
|--------|-----|----------|
| Getting the current interface number (Wowpedia) | https://wowpedia.fandom.com/wiki/Getting_the_current_interface_number | Cross-check GetBuildInfo practice |
| UIHANDLER OnUpdate (Wowpedia) | https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate | Cross-check OnUpdate guidance |
| Addon profiling forum thread | https://us.forums.blizzard.com/en/wow/t/questions-about-new-feature-addon-profiling/2080486 | Profiler-era performance discourse |
| Blizzard Watch — Classic UI modernization (Jul 2026) | https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/ | Anniversary/Era UI modernization context |
| TBC Anniversary roadmap (Wowhead) | https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap | Anniversary timeline context (not Interface authority) |
| Parallel deep research output | `.raw/wow-classic-toc-api-perf.{json,md}` | Synthesis; **reconciled against wiki** where numbers disagreed |

---

## Reconciliation notes

- Deep research briefly cited TBC Anniversary as `20504`; **patch notes + wiki table win**: live Anniversary line is **`20506`** as of 2.5.6 documentation scraped 2026-07-25.
- Soft FPS/ms budgets in [05-performance-norms.md](05-performance-norms.md) are **community norms**, not Blizzard-published SLAs — labeled as such.
- AceDB documentation assumes account-wide `## SavedVariables:`; Church of Beef V1 product choice is per-character TOC SV — see [02-savedvariables.md](02-savedvariables.md).

---

## Product documents (in-repo)

- Design spec: `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`
- Sibling library index: `docs/research/wow-classic-addon-design/README.md` (this track is self-contained under `04-toc-api-performance/`)
