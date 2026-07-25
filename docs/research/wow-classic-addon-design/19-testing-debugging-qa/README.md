# Track: Testing, Debugging, and QA (Classic Addons)

**Track id:** `19-testing-debugging-qa`  
**Last updated:** 2026-07-25  
**Lane:** Independent research (QA / debugging only)  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §11 (edge cases), §13 (success criteria), §13.1 (verification approach)

**Scope:** How Classic addon authors surface Lua errors, distribute pre-release builds, validate TOC flavors, exercise guild/net scenarios, and respect combat-lockdown limits — plus a Beef-specific QA checklist.

**Out of scope:** Ace3 internals, packaging antipatterns as a product topic (see track 05), UX surface research (track 01), BeefNet protocol design (spec / synthesis), addon implementation code.

## Index

| Note | Topic |
|------|--------|
| [script-errors-bugsack.md](script-errors-bugsack.md) | `/console scriptErrors`, BugGrabber + BugSack |
| [alpha-channels.md](alpha-channels.md) | WowUp / CurseForge alpha–beta–release channels |
| [multi-flavor-toc-testing.md](multi-flavor-toc-testing.md) | Multi-flavor TOC / Interface verification |
| [mock-guild-scenarios.md](mock-guild-scenarios.md) | Mock / multi-character guild QA scenarios |
| [combat-lockdown-testing.md](combat-lockdown-testing.md) | Combat lockdown testing limits |
| [church-of-beef-qa-checklist.md](church-of-beef-qa-checklist.md) | Recommended V1 QA checklist for Church of Beef |
| [annotated-urls.md](annotated-urls.md) | Curated annotated URL list for this track |

## Top insights for Church of Beef

1. **Always develop with errors visible.** Default client hides Lua errors (`scriptErrors` defaults to `0`). Enable via `/console scriptErrors 1` and prefer BugGrabber + BugSack for copyable stacks during guild playtests.
2. **Alpha channel is the officer/tester pipe.** CurseForge/WowUp Stable/Alpha/Beta lets a small cohort pull pre-release builds without shipping every commit as Release. Untagged/CI alphas are the ecosystem norm.
3. **V1 TOC test is one client, one Interface.** Anniversary `20506` (verify live) is the gate; multi-TOC / multi-Interface is a portability rehearsal, not a V1 blocker — but wrong folder = silent “addon missing.”
4. **Guild/net QA needs two clients minimum.** Spec §13.1 already requires member + officer; extend that with offline sync, roster-not-loaded, and non-officer forge attempts.
5. **Combat lockdown is a QA dimension, not a combat-HUD problem.** Beef must prove ordinary frames still open/update during combat and that nothing requires secure templates or protected actions.
6. **Spectacle is a pass criterion.** A promotion with no guild-chat reaction fails §13.11 even if every unit test of logic would pass.

## Provenance

Scraped search/extract artifacts live under [`.raw/`](.raw/) for auditability.
