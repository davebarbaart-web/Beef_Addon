# Track 48 — Feature flags & staged rollout inside addons

**Track id:** `48-feature-flags-rollout`  
**Last updated:** 2026-07-25  
**Sole focus:** How Classic (and Classic-capable) addons gate risky or incomplete features — SavedVariables toggles, officer/ML authority surfaces, wire/protocol version gates, packaging build-type blocks, and distribution channels — mapped to Church of Beef V1→V2 rollout.  
**Out of scope:** BeefNet wire framing depth (track [14](../14-addon-messaging-beefnet/)); roster API edges (track [16](../16-guild-roster-officer-edges/)); SV schema migration mechanics (track [21](../21-savedvariables-migration/)); QA channel how-to duplication beyond rollout implications (track [19](../19-testing-debugging-qa/)). No addon implementation lives here.

## Product truth (from V1 spec + plan)

| Locked default | Value |
|----------------|-------|
| Risky authority | Officer+ only for `RANK_COMMIT` / Officer tab |
| Soft UI gate | Officer tab hidden for non-officers; approve no-ops |
| Wire gate | BeefNet major mismatch → soft warn; discard incompatible commits |
| Spectacle opt-out | Per-officer announce toggle in UI prefs |
| Dev-only | Plan: `/beef debug …` behind `COB.DEBUG = true` (default false) |
| V2 (deferred) | Ceremonial dashboard, confessions feed, richer scripture, stream contrast |
| Distribution (when public) | Alpha = officer/volunteer pipe; Release = guild-wide |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6.2–6.3, §8.2, §10–§11, §14; plan Task 5 / Task 8 debug note.

## Index

| Note | Covers |
|------|--------|
| [gate-layers.md](gate-layers.md) | Taxonomy: five gate layers Classic addons actually use |
| [sv-feature-flags.md](sv-feature-flags.md) | SavedVariables toggles, debug modes, defaults merge |
| [officer-role-gates.md](officer-role-gates.md) | Officer+ / ML / council authority patterns |
| [version-protocol-gates.md](version-protocol-gates.md) | Addon + protocol version skew, peer version checks |
| [packaging-and-channels.md](packaging-and-channels.md) | `@alpha@` / `@debug@` / `@do-not-package@`, CurseForge & WowUp channels |
| [beef-v1-v2-rollout.md](beef-v1-v2-rollout.md) | Explicit V1→V2 staged rollout playbook for Church of Beef |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **There is no LaunchDarkly in WoW.** Classic “feature flags” are local: SV booleans, role checks, wire major versions, and *what zip you installed*. Design gates as layered deny rules, not a remote config service.

2. **Separate “who may mutate church state” from “who may see experimental UI.”** Spec already: Officer+ for commits; members may suggest. V2 spectacle can ship **off by default** in `ChurchOfBeefDB.ui` without opening the commit path.

3. **Officer gate ≠ packaging gate ≠ channel gate.** Hiding the Officer tab from members does not protect guildmates from a bad BeefNet build. Use Alpha channel (or Discord zip) for risky protocol changes; keep Release boring.

4. **Build-type keywords are the ecosystem’s compile-time flags.** BigWigs packager / CurseForge Automatic Packaging strip or comment `@debug@`, `@alpha@`, `@do-not-package@` blocks so debug slash verbs and verbose sync dumps never ship in Release ([packager README](https://github.com/BigWigsMods/packager); [CurseForge Automatic Packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging)).

5. **Version gates belong on the wire, not only in TOC.** Spec §8.2 / §11: major mismatch soft-warns and drops commits. Cousin pattern: Gargul’s `/gl version` surfaces who is stale or missing the addon ([Gargul Version Check](https://github.com/papa-smurf/Gargul/wiki/Version-Check)).

6. **V1→V2 should prefer thin stubs + SV flags over dual-code forever.** Spec already ships thin Gora/ceremony stubs. V2 dashboard/confessions should load behind a local `ui.features.*` (or equivalent) default-off flag, then graduate to always-on once guild nights prove them — without a second addon.

7. **Never put ladder authority behind an experimental flag that members can flip.** Standing is self-reported; officer approval is anti-cheat (spec §6.3). Experimental flags may soften *spectacle* and *local scoring heuristics*, not who may emit `RANK_COMMIT`.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer CurseForge / BigWigs packager / WowUp / cousin wikis / V1 spec over listicles.
