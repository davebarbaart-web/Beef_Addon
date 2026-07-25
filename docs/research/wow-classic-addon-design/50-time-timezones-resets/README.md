# Track 50 — Time, timezones, weekly resets

**Track id:** `50-time-timezones-resets`  
**Last updated:** 2026-07-25  
**Sole focus:** Client clocks (`GetServerTime` vs local), regional daily/weekly reset anchors, Blizzard season boundaries for ladders, and how those map onto Beef scoring windows / day keys / commit timestamps.  
**Out of scope:** Scoring *amounts* and anti-farm UX (track [26](../26-ladders-points-gamification/)); revision/conflict merge policy beyond “use which clock” (track [27](../27-desync-conflict-resolution/)); BeefNet transport (track [14](../14-addon-messaging-beefnet/)). No addon implementation lives here.

## Product truth (from V1 spec / plan)

| Locked default | Value |
|----------------|-------|
| Target realms | Dreamscythe (Alliance) + Doomhowl (Horde) — **US** TBC Classic Anniversary; independent ladders |
| Official record fields | `revision`, `updatedAt`, `updatedBy` — higher revision wins; equal revision → later `updatedAt`, then officer name |
| Scoring day boundary | Plan exposes `Scoring:GetDayKey(now)` + **per-day caps** per source (instance / ceremony / gora) |
| Instance drip | Combat-active time buckets (~60s) + optional completion bonus |
| Standing decay / season reset | **Off in V1**; “Lent” seasonal reset is a deferred on-brand option |
| Cross-realm time | N/A — no shared church state across realms |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §5–§8, §15–§16; plan Task 4 (`GetDayKey`, daily caps).

## Index

| Note | Covers |
|------|--------|
| [getservertime-vs-local.md](getservertime-vs-local.md) | `time()` / `date()` vs `GetServerTime` vs realm wall-clock vs `GetTime` |
| [weekly-resets-by-region.md](weekly-resets-by-region.md) | US/EU/Asia daily + weekly UTC anchors; Classic raid lockout cadence |
| [season-boundaries-ladders.md](season-boundaries-ladders.md) | Arena/PvP season ends, phase ties, offseasons; implications for guild ladders |
| [beef-scoring-windows.md](beef-scoring-windows.md) | Day keys, caps, buckets, commit timestamps — recommended clock policy for CoB |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Stamp official time with `GetServerTime()`, not `time()`.** Wiki guidance: bare `time()` follows the **local OS clock** and is *not* synchronized across clients; `GetServerTime()` is the server-derived Unix timestamp that *is* synchronized among clients on that realm connection ([API time](https://wowpedia.fandom.com/wiki/API_time); [GetServerTime](https://warcraft.wiki.gg/wiki/API_GetServerTime)). Use it for `updatedAt`, event logs, and day-key math.

2. **Realm wall-clock ≠ absolute sync stamp.** `GetGameTime()` / `C_DateAndTime.GetCurrentCalendarTime()` return realm **hour:minute** (and calendar fields). Useful for “what time is it on the realm?” UI. Do **not** use them alone for ordering commits. `C_DateAndTime.GetServerTimeLocal()` is Unix-shaped but **offset into the realm’s timezone** — a different number than `GetServerTime()`.

3. **CoB guilds are on the US reset schedule.** Dreamscythe / Doomhowl are US Anniversary TBC realms. Community UTC anchors for US/LATAM/OCE: **daily and weekly at 15:00 UTC**, weekly on **Tuesday** ([wowreset.com](https://wowreset.com/); [whenreset](https://whenreset.com/); [Zockify Classic calendar](https://www.zockify.com/classic/calendar/)). EU is Wednesday **04:00 UTC** (changed from 07:00 UTC on 2022-11-16 per wowreset). V1 need not soft-code EU unless shipping overseas.

4. **Beef “day” for caps should follow Blizzard daily reset, not player midnight.** Spec/plan require per-day caps. If `GetDayKey` uses local midnight, a PST player and an AEST traveler on the same US realm get different cap windows and can double-dip or starve unfairly. Prefer a day key derived from `GetServerTime()` relative to **15:00 UTC** (US daily reset) for Anniversary US.

5. **Do not assume Retail countdown APIs on Anniversary.** `C_DateAndTime.GetSecondsUntilWeeklyReset` was added in **Retail 9.0.1** ([Wowpedia](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.GetSecondsUntilWeeklyReset)). Treat availability on Interface **20506** as **unverified** — probe at runtime or compute from published UTC anchors. Never hard-require Retail-only helpers for V1 scoring.

6. **Blizzard PvP seasons already teach the pattern Beef should copy for any future ladder season.** Season ends are announced with **region-local wall times** and Season starts are often “with the weekly reset” ([Kaivax — Season 1 Ends on May 4](https://us.forums.blizzard.com/en/wow/t/season-1-ends-on-may-4/2294275)). Beef V1 has no auto season, but a future “Lent” wipe should be an officer-announced **UTC instant** (or “next US weekly reset”), not “whenever each client’s local Sunday hits.”

7. **Relative session timing still belongs to `GetTime()`.** Bucket intervals (“every ~60s of combat-active time”) are duration math. `GetTime()` (client uptime seconds) is the right tool for intra-session timers; pair with `GetServerTime()` only when persisting *when* the grant happened for day-key / sync.

## Boundary with sibling tracks

| This track (50) | Sibling |
|-----------------|---------|
| Which clock / which UTC boundary | [26](../26-ladders-points-gamification/) — points, FOMO, season *design* psychology |
| `updatedAt` clock choice for tiebreaks | [27](../27-desync-conflict-resolution/) — revision-first merge rules |
| When to fire login sync | [14](../14-addon-messaging-beefnet/) — throttle / settle timing |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / Wowpedia / Blizzard forum blues / UTC reset trackers over gold-seller “timer” blogs when they disagree — but the UTC numbers (US 15:00 / EU 04:00) are consistent across the reputable trackers cited here.
