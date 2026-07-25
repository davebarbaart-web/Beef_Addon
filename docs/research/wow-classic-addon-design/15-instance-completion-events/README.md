# Track 15 — Instance / dungeon completion & encounter event reliability

**Track id:** `15-instance-completion-events`  
**Last updated:** 2026-07-25  
**Client focus:** TBC Classic Anniversary (`Interface` **20506**), with Classic Era notes where the same modernized API surface applies.  
**Scope:** Which game events/APIs can (and cannot) detect zoning into instances, boss kills, “run finished,” lockout/reset, and BG end — reliability, false positives, and Beef scoring implications.  
**Out of scope:** Guild-roster/Officer+ races, BeefNet payload budgets, combat HUD UX, addon packaging (other tracks).

## Spec anchors

Church of Beef V1 ([design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)):

| Spec bit | Relevance |
|----------|-----------|
| §7.1 Shared instance drip + **completion bonus** | Needs a trustworthy “finished content” signal |
| §7.2 Anti-AFK (combat during bucket) | Separate, reliable combat events |
| §16.4 Open question | Completion detection may be flaky → bucket-only fallback |
| Plan Task 11 (`Core/Instance.lua`) | `PLAYER_ENTERING_WORLD` + buckets + optional complete grant |

## Docs in this track

| Note | Contents |
|------|----------|
| [event-reliability-matrix.md](event-reliability-matrix.md) | Event/API matrix: purpose, Classic availability, reliability, false positives, Beef use |
| [annotated-sources.md](annotated-sources.md) | Annotated primary URLs used for claims |
| [`.raw/`](.raw/) | Parallel search/extract JSON provenance |

## Top insights for Beef (read this first)

1. **There is no Classic first-class “dungeon complete” event** comparable to Retail Challenge Mode / M+ end. Treat §7 completion bonus as **optional** and design so drip buckets alone can hit the Fresh→Cooked pacing rule ([spec §4.2 / §16.4](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

2. **Zone with `PLAYER_ENTERING_WORLD` + `IsInInstance` / `GetInstanceInfo`, not `ZONE_CHANGED*`.** PEW fires on loading screens (login, reload, instance transitions); `IsInInstance` is documented as correct immediately on PEW. `ZONE_CHANGED` / `ZONE_CHANGED_NEW_AREA` are historically unreliable for instance enter ([WoWInterface thread](https://wowinterface.com/forums/showthread.php?t=19130); [IsInInstance](https://warcraft.wiki.gg/wiki/API_IsInInstance); [PLAYER_ENTERING_WORLD](https://warcraft.wiki.gg/wiki/PLAYER_ENTERING_WORLD)).

3. **Boss progress ≠ run complete.** Prefer `ENCOUNTER_END` with `success == 1`, or `BOSS_KILL`, as *progress* signals — never as automatic full-clear credit without an allowlisted “final boss” map (and even then false negatives on skips / multi-wing). Both events exist on Classic-family clients (`BOSS_KILL` tagged **6.1.0 / 1.13.2**); `ENCOUNTER_END` is confirmed firing on Classic but **locale-broken names** (`"*"` on zhCN, likely ruRU) ([BOSS_KILL](https://warcraft.wiki.gg/wiki/BOSS_KILL); [ENCOUNTER_END](https://wowpedia.fandom.com/wiki/ENCOUNTER_END); [Classic bug report](https://us.forums.blizzard.com/en/wow/t/encounterend-payload-issue/439290)).

4. **Battlegrounds are the reliable completion case.** When `GetBattlefieldWinner()` becomes non-`nil` (0 Horde / 1 Alliance / 255 draw), the match has ended — best Classic analogue to “completion bonus” for the `pvp` instance type ([GetBattlefieldWinner](https://warcraft.wiki.gg/wiki/API_GetBattlefieldWinner)).

5. **Lockout APIs are laggy “saved” state, not a finish toast.** `RequestRaidInfo` → `UPDATE_INSTANCE_INFO` → `GetSavedInstanceInfo` tells you lockouts; useful for officers/debug, bad as sole auto-suggest trigger (async, not “just now,” first-boss lock ≠ full clear) ([RequestRaidInfo](https://wowpedia.fandom.com/wiki/API_RequestRaidInfo); [UPDATE_INSTANCE_INFO](https://wowpedia.fandom.com/wiki/UPDATE_INSTANCE_INFO); [GetSavedInstanceInfo](https://wowpedia.fandom.com/wiki/API_GetSavedInstanceInfo)).

6. **Resets are anti-signals for farming, not scores.** `ResetInstances` / system “instances reset” chatter mean fresh farms — do **not** grant completion; if anything, they argue for stricter daily caps ([ResetInstances](https://warcraft.wiki.gg/wiki/API_ResetInstances)).

7. **Anti-AFK should use combat events, not completion.** `PLAYER_REGEN_DISABLED` / `UnitAffectingCombat("player")` are the right bucket gates ([PLAYER_REGEN_DISABLED](https://warcraft.wiki.gg/wiki/PLAYER_REGEN_DISABLED)).

## Recommended V1 policy (research conclusion)

| Signal | V1 stance for Beef points |
|--------|---------------------------|
| In `party` / `raid` / `pvp` with guildmate + combat bucket | **Ship** — primary standing fuel |
| BG end (`GetBattlefieldWinner` non-nil) | **Ship** as completion bonus (cap) |
| `ENCOUNTER_END` success / `BOSS_KILL` | **Optional** progress toast / officer-facing log only — **do not** auto-grant full dungeon completion without allowlist + in-game prototype |
| Full 5-man / raid “clear” | **Defer** or officer-manual; no reliable single event |
| Instance reset | **Ignore** for grants |

**Prototype gate (still required):** confirm on Anniversary `20506` which of `ENCOUNTER_END` / `BOSS_KILL` fire for TBC 5-mans vs raids (wiki confirms Classic-family presence; Anniversary-specific coverage is not fully proven from docs alone — matches open question §16.4).

## Version shorthand

| Tag | Meaning |
|-----|---------|
| **Anniv** | TBC Classic Anniversary (Beef V1) |
| **Era** | Classic Era / HC / SoD family |
| **All Classic** | Shared modernized Classic client APIs |
| **Retail-only** | Do not use for V1 |
