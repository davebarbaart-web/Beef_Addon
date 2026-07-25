# Annotated URLs — co-play / guildmate detection

Primary sources for track 59. Prefer these when deciding how Beef detects “playing with guildmates.”

## Group membership & UnitIds

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_IsInGroup | `IsInGroup([groupType])`; HOME vs INSTANCE; dual-group note; Classic add **5.0.4 / 1.13.2**. Steal category argument for BG vs manual dungeon. |
| https://warcraft.wiki.gg/wiki/API_GetNumGroupMembers | Count including self; default category INSTANCE-if-applicable; BG returns BG raid size. Prefer for “am I grouped?” resilience. |
| https://addonstudio.org/wiki/WoW:API_TYPE_partyCategoryType | Clear HOME vs INSTANCE definitions and dual-group leader example. |
| https://warcraft.wiki.gg/wiki/GROUP_ROSTER_UPDATE | Recompute guildmate set; debounce (replaces old PARTY/RAID roster events). |
| https://wowwiki-archive.fandom.com/wiki/UnitId | `partyN` excludes player; `raidN` includes player; pets are separate tokens — avoid false units. |
| https://www.wowinterface.com/forums/showthread.php?t=56134 | Practitioner pattern: `IsInGroup`/`IsInRaid` + `GetNumGroupMembers` + `raidN`/`partyN`. |
| https://www.wowinterface.com/forums/showthread.php?t=56146 | Iteration pitfalls; note that `IsInGroup()` can rarely lie — corroborate with member count. |

## Guildmate identity

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://addonstudio.org/wiki/WoW:World_of_Warcraft_API | Lists `UnitIsInMyGuild("unit")` alongside group APIs — primary same-guild UnitId check. |
| https://warcraft.wiki.gg/wiki/API_GetGuildInfo | Guild string for a unit; **proximity-limited** (portrait distance) — false-negative trap if used alone. |
| https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo | Roster names often `Name-Realm`; offline rows remain — pair with track 16 refresh rules. |
| https://wowwiki-archive.fandom.com/wiki/API_GetRaidRosterInfo | Raid/BG names; `online`/`isDead`/`zone`; **`Name-Server` in cross-realm BGs**. |
| [`../16-guild-roster-officer-edges/`](../16-guild-roster-officer-edges/) | Roster throttle, login nil guild, rank edges — cache readiness for name fallback. |
| [`../25-multi-toon-realm-edges/`](../25-multi-toon-realm-edges/) | Normalize `Name-Realm` keys; no cross-church ladder. |

## AFK, connected, proximity

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowwiki-archive.fandom.com/wiki/API_UnitIsAFK | AFK flag API — telemetry only; not V1 pay gate. |
| https://addonstudio.org/wiki/WoW:World_of_Warcraft_API | Also documents `UnitIsConnected` / friendly-unit AFK notes in the unit section. |
| https://wowwiki-archive.fandom.com/wiki/API_UnitInRange | ~40yd heal-range; party/raid only — **reject** as co-play requirement. |
| https://warcraft.wiki.gg/wiki/API_CheckInteractDistance | Interaction bands; combat-restricted on modern clients — wrong tool for standing. |
| https://www.reddit.com/r/classicwow/comments/1amv8o5/psa_new_115_build_removes_range_checking_from/ | Classic Era 1.15 range-check cuts in instances — reinforces “don’t depend on proximity APIs.” |

## Instance / combat inputs (do not re-research here)

| URL / path | Why |
|------------|-----|
| [`../15-instance-completion-events/`](../15-instance-completion-events/) | PEW, `IsInInstance`, combat sticky, BG completion — **inputs** to co-play credit. |
| https://warcraft.wiki.gg/wiki/API_IsInInstance | Qualifying `party`/`raid`/`pvp` gate for §7.2. |
| https://warcraft.wiki.gg/wiki/PLAYER_REGEN_DISABLED | Anti-AFK combat enter (track 15 authority). |

## Cross-realm context

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowwiki-archive.fandom.com/wiki/API_GetRaidRosterInfo | Cross-realm BG `Name-Server` form — normalize before roster match. |
| https://us.forums.blizzard.com/en/wow/t/cross-realm-partiesgroupingraiding/974655 | Classic community resistance to cross-realm PvE — context for keeping guild-local credit. |
| https://www.wowhead.com/news/cross-realm-guilds-coming-in-the-war-within-expansion-unrestricted-cross-realm-335897 | Retail/TWW cross-realm guilds — **not** Anniversary V1 topology. |

## Product / cousin intent

| URL / path | Why it matters for Beef |
|------------|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778 | Officers want time-in-group / help incentives with guildmates — same co-play instinct; avoid ungated time scores. |
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §7.1–7.2, §6.3 | Shared instance definition, anti-AFK, caps, officer anti-cheat. |
| [`../26-ladders-points-gamification/anti-farm-incentives.md`](../26-ladders-points-gamification/anti-farm-incentives.md) | Caps, no city co-play, combat-gated buckets. |
| [`../26-ladders-points-gamification/classic-guild-fun-score-systems.md`](../26-ladders-points-gamification/classic-guild-fun-score-systems.md) | Steal co-presence; avoid open-world time DKP. |

## Cousin iteration reference (pattern only)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://github.com/abl/AddOns/blob/master/DBM-Core/DBM-Core.lua | Battle-tested `GetGroupMembers` raid/party iterators + `UnitIsConnected` filters — steal iteration shape, not boss-mod scope. |

## Provenance dumps

| Path | Contents |
|------|----------|
| [`.raw/search-group-guildmate.json`](.raw/search-group-guildmate.json) | Group/roster API search |
| [`.raw/search-proximity-instance-group.json`](.raw/search-proximity-instance-group.json) | Proximity / subgroup search |
| [`.raw/extract-core-apis.json`](.raw/extract-core-apis.json) | IsInGroup / GetNumGroupMembers / GROUP_ROSTER_UPDATE |
| [`.raw/extract-archive-apis.json`](.raw/extract-archive-apis.json) | GetRaidRosterInfo, UnitInRange, UnitIsAFK, CheckInteractDistance |
| [`.raw/extract-community-signals.json`](.raw/extract-community-signals.json) | Guild-addon-help + Classic range PSA |
| [`.raw/search-unitisinguild-categories.json`](.raw/search-unitisinguild-categories.json) | GetGuildInfo proximity + categories |
| [`.raw/search-crossrealm-coplay.json`](.raw/search-crossrealm-coplay.json) | Cross-realm grouping context |
