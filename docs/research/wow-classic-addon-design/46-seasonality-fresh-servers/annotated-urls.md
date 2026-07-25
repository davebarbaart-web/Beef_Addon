# Annotated URLs — seasonality, fresh servers, lockouts, raid tiers

Primary sources for track 46. Prefer calendars and wiki mechanics over booster listicles when deciding season policy.

## Fresh realms & Anniversary progression

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowhead.com/classic/guide/fresh-servers-roadmap-phases | Classic 20th Anniversary **fresh** launch roadmap: empty realms, phased Classic content, HC vs normal, progression into TBC — defines “fresh” as a founding event, not a weekly wipe. |
| https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap | TBC Anniversary realm list (Dreamscythe PvE, Doomhowl HC stays Classic), GDKP ban, faction balance, phase outline — realm-identity source for independent ladders. |
| https://www.warcrafttavern.com/tbc/guides/phases/ | Dated Anniversary phase table (pre-patch 13 Jan 2026, P1 5 Feb, P2 14 May, P3 27 Aug, P4/P5 autumn TBA) + raid/arena contents — best single map for Church season boundaries. |
| https://wowclassicui.com/2026/02/16/tbc-classic-anniversary-roadmap-2026/ | Secondary roadmap corroboration (features, dual spec, Chronoboon) — use to confirm QoL context, not as sole date authority. |
| https://classic-armory.org/anniversary/us/dreamscythe | Live Dreamscythe armory flavor — reminder the V1 guild home is a real populated Anniversary realm. |

## Official / blue calendar beats

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://worldofwarcraft.com/en-us/news/24291476 | Official **Black Temple / Phase 3** timing (27 Aug 2026) and Arena Season 2→3 transition with weekly restarts — template for “phase open = Church season ceremony,” not standing auto-wipe. |
| https://us.forums.blizzard.com/en/wow/t/tbc-anniversary-install-is-live/2226013 | Client/install reality when realms flipped to TBC Anniversary — seasonality includes **client tree** moves, not only in-game patches. |
| https://us.forums.blizzard.com/en/wow/t/what-happened-to-realm-dreamscythe/2227089 | Player confusion at TBC flip — expect support questions; ladder SV lives under the Anniversary install path. |

## Lockouts & saved instances

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowpedia.fandom.com/wiki/Raid_lockout | Lockout types; **strict ID** for Classic→Sunwell; Tuesday/Wednesday calendar notes; heroic daily reset — weekly rhythm without inventing Beef weekly standing wipes. |
| https://warcraft.wiki.gg/wiki/API_GetSavedInstanceInfo | Addon API to read saves (name, id, reset, encounters) — optional post-V1 flavor/debug only; not V1 scoring authority. |
| https://warcraft.wiki.gg/wiki/API_GetNumSavedInstances | Companion enumerator for saved instances. |
| https://us.forums.blizzard.com/en/wow/t/raid-lockout/8720 | Classic-era player explanation of ID saves / pug ID theft social failure modes — officer lore, not scoring rules. |
| https://classicraidreset.com/ | External reset countdown tool — useful for humans; Beef should not depend on it. |

## PvP seasons (parallel calendar — do not drive standing wipes)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/PvP_season | How arena seasons reset ratings/rewards; Classic seasons track phases — cite when explaining why Beef seasons follow **raids**, not Gladiator ladders. |
| https://worldofwarcraft.blizzard.com/en-us/news/23670022/honor-system-updates-for-burning-crusade-classic | Historical BCC honor/arena framing (linked from PvP season refs) — context only. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3–§5, §7, §9, §16.3 | Dreamscythe/Doomhowl, no decay V1, Lent open door, scoring sources, per-character SV. |
| [`../26-ladders-points-gamification/`](../26-ladders-points-gamification/) | Gamification core — do not duplicate; seasons *when*, not points *how*. |
| [`../15-instance-completion-events/`](../15-instance-completion-events/) | Completion detection reliability — orthogonal to lockout calendar. |
| [`../30-anniversary-vs-era-deltas/`](../30-anniversary-vs-era-deltas/) | Client/TOC deltas — install trees when seasons span Classic→TBC. |
| [`../25-multi-toon-realm-edges/`](../25-multi-toon-realm-edges/) | Multi-toon/realm edges — transfers and alts under season breaks. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-classic-seasons-fresh.json`](.raw/search-classic-seasons-fresh.json) | Parallel search: fresh servers, Anniversary phases, Dreamscythe/Doomhowl |
| [`.raw/search-lockouts-api.json`](.raw/search-lockouts-api.json) | Parallel search: raid lockouts, GetSavedInstanceInfo |
| [`.raw/search-official-phases-realms.json`](.raw/search-official-phases-realms.json) | Parallel search: official phase beats, weekly reset |
| [`.raw/extract-phases-lockouts.json`](.raw/extract-phases-lockouts.json) | Extracts: Tavern phases, Raid lockout, PvP season |
| [`.raw/extract-official-roadmaps.json`](.raw/extract-official-roadmaps.json) | Extracts: Blizzard/Wowhead roadmaps (if present) |
| [`.raw/extract-saved-instance-api.json`](.raw/extract-saved-instance-api.json) | Extracts: saved-instance APIs (if present) |
