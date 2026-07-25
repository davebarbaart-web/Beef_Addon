# Track 59 — Co-play / guildmate presence detection

**Track id:** `59-coplay-guildmate-detection`  
**Last updated:** 2026-07-25  
**Client focus:** TBC Classic Anniversary (`Interface` **20506**), with Classic Era notes where the same modernized group APIs apply.  
**Scope:** How Classic addons detect “playing with guildmates” (party/raid roster, instance groups, proximity limits), false positives, AFK, and cross-realm edges — mapped to Beef §7 shared-instance credit.  
**Out of scope:** Instance enter/leave, combat buckets, completion/BG-end events (inputs from [15-instance-completion-events](../15-instance-completion-events/) only). No addon implementation in this folder.

## Spec anchors

Church of Beef V1 ([design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)):

| Spec bit | Relevance |
|----------|-----------|
| §7.1 Shared instance | ≥1 other **guildmate** in party/raid inside dungeon / raid / BG; peer need **not** run the addon |
| §7.2 Anti-AFK + instance-only | Combat-gated buckets; no city / open-world co-play |
| §7.2 Caps | Daily drip caps; officer adjust |
| §6.3 Officer is anti-cheat | Local detection is advisory testimony |
| Plan Task 11 (`Core/Instance.lua`) | Needs a reliable `hasGuildmateInGroup` predicate |

## Docs in this track

| Note | Contents |
|------|----------|
| [detection-methods.md](detection-methods.md) | Party/raid iteration, guildmate predicates, HOME vs INSTANCE, proximity (and why not) |
| [false-positives-afk-crossrealm.md](false-positives-afk-crossrealm.md) | False positives/negatives, AFK, offline, cross-realm / BG strangers |
| [beef-scoring-map.md](beef-scoring-map.md) | Predicate → credit pipeline; V1 ship/defer matrix |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |
| [`.raw/`](.raw/) | Parallel search/extract provenance |

## Relationship to track 15 (do not duplicate)

Track 15 owns **where/when** scoring sessions exist. This track owns **who** must be present.

| From track 15 (inputs only) | This track adds |
|-----------------------------|-----------------|
| `PLAYER_ENTERING_WORLD` + `IsInInstance` / `GetInstanceInfo` | Guildmate-in-group check |
| Qualifying types: `party` / `raid` / `pvp` | Which UnitIds / roster APIs prove “guildmate” |
| Combat sticky for buckets (`PLAYER_REGEN_DISABLED`) | AFK / idle edges that combat does **not** cover |
| BG end / optional completion | Still require guildmate predicate at grant time |

## Top insights for Beef (read this first)

1. **Guildmate credit is a group-roster problem, not a proximity problem.** V1 should iterate `partyN` / `raidN` (or DBM-style iterators), then ask “same guild?” via `UnitIsInMyGuild(unit)` with a **normalized guild-roster name fallback**. Do not require yards-apart checks for credit ([UnitId](https://wowwiki-archive.fandom.com/wiki/UnitId); [IsInGroup](https://warcraft.wiki.gg/wiki/API_IsInGroup)).

2. **Always query the group that matches the instance.** Use `LE_PARTY_CATEGORY_INSTANCE` inside BGs (and any automatic instance group) and `LE_PARTY_CATEGORY_HOME` for manual dungeon/raid parties. Omitting the category defaults to INSTANCE when one exists — easy false negative if guildies are only in the home party ([IsInGroup](https://warcraft.wiki.gg/wiki/API_IsInGroup); [partyCategoryType](https://addonstudio.org/wiki/WoW:API_TYPE_partyCategoryType)).

3. **`GetGuildInfo(unit)` is a false friend for co-play.** Wiki: it only works in close portrait-load proximity and drops after leaving the area ([GetGuildInfo](https://warcraft.wiki.gg/wiki/API_GetGuildInfo)). Prefer `UnitIsInMyGuild` on group UnitIds; fall back to matching `UnitName` / realm against a cached guild roster (track [16](../16-guild-roster-officer-edges/)).

4. **Proximity APIs are not Beef’s anti-AFK.** `UnitInRange` is ~40yd heal range and party/raid-only ([UnitInRange](https://wowwiki-archive.fandom.com/wiki/API_UnitInRange)). `CheckInteractDistance` is interaction-band only and has been combat/instance-restricted on modern clients / Classic 1.15-era range cuts ([CheckInteractDistance](https://warcraft.wiki.gg/wiki/API_CheckInteractDistance); [Classic range PSA](https://www.reddit.com/r/classicwow/comments/1amv8o5/psa_new_115_build_removes_range_checking_from/)). Spec already gates buckets on **player combat** — keep that.

5. **`UnitIsAFK` is optional telemetry, not a pay gate.** AFK flag is voluntary and easily cleared; offline/DC uses `UnitIsConnected` / raid `online` ([UnitIsAFK](https://wowwiki-archive.fandom.com/wiki/API_UnitIsAFK); [GetRaidRosterInfo](https://wowwiki-archive.fandom.com/wiki/API_GetRaidRosterInfo)). Require connected guildmate + combat bucket.

6. **Cross-realm strangers in BG instance raids must not pay.** Classic church ladders are guild-local (Dreamscythe ≠ Doomhowl — track [25](../25-multi-toon-realm-edges/)). BG rosters return `Name-Server` for other-realm players ([GetRaidRosterInfo](https://wowwiki-archive.fandom.com/wiki/API_GetRaidRosterInfo)). Only credit if the unit resolves as **your guild**, not merely “in the BG raid.”

7. **Peer addon is irrelevant.** Spec §7.1: guildmates need not run Church of Beef. Detection is pure client Unit/roster APIs — never wait for BeefNet `HELLO`.

## Recommended V1 predicate (research conclusion)

```
qualifyingInstance          ← track 15 (party|raid|pvp)
AND hasConnectedGuildmateInActiveGroup
AND (for drip bucket) playerCombatInBucket  ← track 15 / §7.2
```

**Ship** that predicate. **Defer** proximity scoring, open-world co-play, and “same zone as offline guildie” heuristics.

## Version shorthand

| Tag | Meaning |
|-----|---------|
| **Anniv** | TBC Classic Anniversary (Beef V1) |
| **Era** | Classic Era / HC / SoD family |
| **All Classic** | Shared modernized Classic client APIs (`IsInGroup` family added **5.0.4 / 1.13.2**) |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / WoWWiki archive / Blizzard forums over listicles.
