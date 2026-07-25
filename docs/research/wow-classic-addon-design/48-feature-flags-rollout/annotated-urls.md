# Annotated URLs — feature flags & staged rollout

Primary sources for track 48. Prefer these when deciding how Beef stages risky features.

## Packaging & build-type gates

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://github.com/BigWigsMods/packager | Canonical packager: `@alpha@`, `@debug@`, `@do-not-package@`, flavor `version-*` keywords — compile-time feature flags. |
| https://github.com/BigWigsMods/packager/wiki/Repository-Keyword-Substitutions | Deeper keyword / debug-replacement examples (linked from README). |
| https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging | Untagged→alpha; tag words `alpha`/`beta`; `--@alpha@` asserts kept in alpha not release/beta. |
| https://www.curseforge.com/wow/addons/wow-build-tools | Modern packager-parity tooling; documents same build-type token family. |
| https://github.com/BigWigsMods/packager/blob/master/release.sh | Implementation reference for how alpha/debug filters rewrite Lua/TOC/XML. |

## Distribution channels (cohort rollout)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowup.io/guide/my-addons/addons | Per-addon Stable/Alpha/Beta; “accept tier or newer”; not stranded on stale alpha. |
| https://wowup.io/guide/my-addons/overview | Client/folder separation context when testing Anniversary vs other trees. |
| https://us.forums.blizzard.com/en/wow/t/curseforge-automatic-packaging-for-classic/495126 | Classic-era author discussion of CF packaging / flavor tagging culture. |

## Role / authority cousins

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://github.com/papa-smurf/Gargul/wiki/Version-Check | Peer version / missing-addon surface — soft install skew UX. |
| https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat | ML-driven announce + settings toggles (noise vs authority split). |
| https://github.com/papa-smurf/Gargul/wiki/Importing-Soft-Reserves | Broadcast gated to master looter — privileged emit pattern. |
| https://rclootcouncil.com/wiki/Options | Personal vs Master Looter Options; temp group copy; council lists. |
| https://rclootcouncil.com/ | Product framing: ML/GL session authority for loot. |
| https://www.curseforge.com/wow/addons/rclootcouncil-classic | Classic flavor distribution presence (council denser than Beef V1). |

## SavedVariables / persistence (flag storage)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions | No built-in schema/flags — authors own defaults + migrations. |
| https://warcraft.wiki.gg/wiki/SavedVariables | Account vs character paths; load timing implications for flag reads. |
| https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables | TOC directives for what gets persisted. |
| https://github.com/TheMizeGuy/wow-addon-dev/blob/main/references/savedvariables-and-load-order.md | Load-order reminder: SV ready at `ADDON_LOADED`, not file scope. |
| https://addonstudio.org/wiki/WoW%3ASaving_variables_between_game_sessions | Alternate mirror of persistence basics. |

## Debug / experimental culture (secondary)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.curseforge.com/wow/addons/all-the-things | Large-addon culture: Debug Mode in settings; retiring debug prints in changelogs. |
| https://wowpedia.fandom.com/wiki/API_GetAddOnMetadata | Read TOC `Version` for peer compare / support strings (Retail deprecation note — verify Classic API before depending). |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6.2–6.3, §8, §10–§11, §14 | Officer gate, proto discard, announce opt-out, V2 phase map. |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | `COB.DEBUG`, officer gate task, harden-debug before release. |
| [`../14-addon-messaging-beefnet/beefnet-mapping.md`](../14-addon-messaging-beefnet/beefnet-mapping.md) | Wire version gate mapping. |
| [`../16-guild-roster-officer-edges/README.md`](../16-guild-roster-officer-edges/README.md) | Rank-index Officer+ mechanics. |
| [`../19-testing-debugging-qa/alpha-channels.md`](../19-testing-debugging-qa/alpha-channels.md) | QA-oriented channel ladder (complements this track). |
| [`../21-savedvariables-migration/schema-versioning-migration.md`](../21-savedvariables-migration/schema-versioning-migration.md) | Schema ≠ feature flag; migration rules for new `ui.features` keys. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-feature-flags-rollout.json`](.raw/search-feature-flags-rollout.json) | Broad SV / flag search |
| [`.raw/search-packaging-channels.json`](.raw/search-packaging-channels.json) | Packager / CurseForge / WowUp search |
| [`.raw/search-officer-experimental.json`](.raw/search-officer-experimental.json) | RCLC / Attune / experimental search |
| [`.raw/search-experimental-toggles.json`](.raw/search-experimental-toggles.json) | ATT / WA / metadata search |
| [`.raw/extract-primary-pages.json`](.raw/extract-primary-pages.json) | Extracted primary pages |
| [`.raw/curseforge-automatic-packaging.md`](.raw/curseforge-automatic-packaging.md) | CF packaging excerpts |
| [`.raw/bigwigs-packager-readme.md`](.raw/bigwigs-packager-readme.md) | Packager README excerpts |
| [`.raw/wowup-my-addons.md`](.raw/wowup-my-addons.md) | WowUp channel excerpts |
| [`.raw/gargul-version-check.md`](.raw/gargul-version-check.md) | Gargul version check excerpts |
| [`.raw/gargul-announce.md`](.raw/gargul-announce.md) | Gargul announce excerpts |
| [`.raw/rclootcouncil-options.md`](.raw/rclootcouncil-options.md) | RCLC options excerpts |
