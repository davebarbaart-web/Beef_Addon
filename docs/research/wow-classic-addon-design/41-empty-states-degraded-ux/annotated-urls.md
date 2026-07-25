# Annotated URLs — empty states & degraded UX

Primary sources for track 41. Prefer these over generic “top addons” listicles when deciding empty/degraded copy.

## Product truth (repo)

| URL / path | Steal / adapt note |
|------------|-------------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §7.1, §8.2–§8.3, §10–§11, §13 | Locked: unguilded empty ladder; scoring pause; no soft-lock without addon; login sync + cache; guild-chat spectacle; frame must exist. |
| [`docs/research/wow-classic-addon-design/00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Synthesis: guild-chat promotion as V1 spectacle; revisioned login sync as product. |
| [`docs/research/wow-classic-addon-design/14-addon-messaging-beefnet/beefnet-mapping.md`](../14-addon-messaging-beefnet/beefnet-mapping.md) | Failure table: not in guild → empty ladder / no sends; no peer → keep cache. |
| [`docs/research/wow-classic-addon-design/27-desync-conflict-resolution/`](../27-desync-conflict-resolution/) | What happens *after* sync answers — not the waiting UX. |

## Classic API & lifecycle

| URL | Steal / adapt note |
|-----|-------------------|
| https://wowpedia.fandom.com/wiki/API_IsInGuild | Hard gate for scenario B (`IsInGuild()`). |
| https://wowpedia.fandom.com/wiki/AddOn_loading_process | Don’t flash unguilded / fire sync before login/world settle; SV readable at `ADDON_LOADED`. |
| https://stackoverflow.com/questions/62723031/wow-classic-api-event-for-addon-messages | Cold-login addon message flakiness — delay sync UX (also cited in track 14). |

## Cousin addons — peer / empty / onboarding

| URL | Steal / adapt note |
|-----|-------------------|
| https://www.curseforge.com/wow/addons/attune | Personal `/attune` always works; guild survey explicitly needs peers. |
| https://addons.wago.io/addons/attune | Same activation + survey copy; Classic Era / TBC framing. |
| https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832 | Author pitch: survey guild/groups for shared steps. |
| https://www.curseforge.com/wow/addons/gargul | “Only loot master needs… not required”; `/gl start` solo onboarding. |
| https://addons.wago.io/addons/gargul | Same ML-optional install message; command table. |
| https://github.com/papa-smurf/Gargul/wiki | Index to Version Check / settings — officer tooling pattern. |
| https://github.com/evil-morfar/RCLootCouncil2/wiki | Role-split getting started (council vs ML). |
| https://github.com/evil-morfar/RCLootCouncil2/wiki/Version-Checker | **Gold:** Waiting for response → ~5s → not installed; color coding. |
| https://groups.google.com/g/epgp-discuss/c/cI3TwSHD3ZM | `/rc sync` as opt-in guild settings sync precedent. |
| https://rclootcouncil.com/ | Product framing: full awareness when peers installed; Classic download split. |
| https://thegeneticsguy.github.io/Guild-Roster-Manager/ | Ambient sync + rank-gated editors; personal log *not* synced. |
| https://addons.wago.io/addons/guild-roster-manager | GRM feature snapshot; Classic flavors. |
| https://www.curseforge.com/wow/addons/guild-roster-manager/files/7793866 | Changelog honesty about sync hang edge cases. |
| https://www.wowinterface.com/downloads/info25051-CEPGP.html | Context-sensitive UI; `/cepgp version`; officer-note gates. |
| https://github.com/sadsfae/CEPGP-Retail | README: relevant-only chrome; whisper `!info` for members. |

## Empty-state UX theory (adapt, don’t paste SaaS chrome)

| URL | Steal / adapt note |
|-----|-------------------|
| https://www.nngroup.com/articles/empty-state-interface-design/ | Three jobs: status, learning, pathways — map 1:1 to Beef banners/chips. |
| https://www.eleken.co/blog-posts/empty-state-ux | Types + mistakes: blank panic, vague “no data”, joke-only, overload. |
| https://usertourkit.com/blog/empty-states-that-convert-onboarding-design-patterns | First-use vs no-results vs post-completion; loading→empty order; forward CTA verbs. |
| https://blog.logrocket.com/ux-design/empty-state-ux | Welcome / blank / persuasive types; empty as guidance not void. |
| https://www.uxpin.com/studio/blog/ux-best-practices-designing-the-overlooked-empty-states | Heading + motivation + CTA structure (via Yifrah). |
| https://uxpatterns.dev/patterns/user-feedback/empty-states | Dev-oriented empty-state pattern checklist. |
| https://uxdesign.cc/7-types-of-empty-states-and-how-to-use-them-717006dfaa8a | Seven-type taxonomy (paywall may limit extract — use as secondary). |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-empty-states-core.json`](.raw/search-empty-states-core.json) | Attune / RCL / GRM peer empty search |
| [`.raw/search-onboarding-guild-gates.json`](.raw/search-onboarding-guild-gates.json) | Gargul / CEPGP / loading-process search |
| [`.raw/search-empty-state-ux-theory.json`](.raw/search-empty-state-ux-theory.json) | NN/g-adjacent empty-state theory search |
| [`.raw/search-apis-sync-peers.json`](.raw/search-apis-sync-peers.json) | Version check / peer follow-up search |
| [`.raw/extract-core-pages.json`](.raw/extract-core-pages.json) | Extracts: Eleken, Gargul, Attune, IsInGuild, loading |
| [`.raw/extract-sync-empty-theory.json`](.raw/extract-sync-empty-theory.json) | Extracts: RCL wiki, GRM, NN/g, Yifrah, RCL sync note |
| [`.raw/extract-version-peer-ux.json`](.raw/extract-version-peer-ux.json) | Extracts: RCL Version Checker, Gargul wiki, Attune Wago |
| [`.raw/extract-empty-copy-formula.json`](.raw/extract-empty-copy-formula.json) | Extracts: LogRocket + Tour Kit empty-copy formulas |
