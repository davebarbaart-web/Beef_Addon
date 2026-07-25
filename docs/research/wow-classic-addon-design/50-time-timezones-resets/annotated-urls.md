# Annotated URLs — time, timezones, resets

Primary sources for track 50. Prefer these over gold-seller timer blogs when deciding clock policy; UTC anchors are cross-checked across multiple trackers.

## Client time APIs

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_GetServerTime | Canonical `GetServerTime()` — server-derived Unix stamp; Added 6.2.0; contrasts with local `time()`. **Use for `updatedAt` / day keys.** |
| https://wowpedia.fandom.com/wiki/API_GetServerTime | Mirror of the above. |
| https://wowpedia.fandom.com/wiki/API_time | Documents that bare `time()` is local OS clock, **not** synced; explicitly recommends `GetServerTime` for sync. Side-by-side examples with `GetGameTime` / `GetServerTimeLocal`. |
| https://warcraft.wiki.gg/wiki/API_GetGameTime | Realm hour:minute wall-clock; instance-shard timezone caveats. Display only. |
| https://warcraft.wiki.gg/wiki/API_C_DateAndTime.GetCurrentCalendarTime | Realm calendar fields (hour/minute/date). Flavor / calendar UI. |
| https://wowpedia.fandom.com/wiki/API_C_DateAndTime.GetServerTimeLocal | Unix-like value **offset into realm TZ** — not interchangeable with `GetServerTime()`. |
| https://wowpedia.fandom.com/wiki/API_C_DateAndTime.GetSecondsUntilWeeklyReset | Retail helper (Added 9.0.1). **Probe before relying on Anniversary 20506.** |
| https://breezewiki.com/wowpedia/wiki/API_C_DateAndTime.GetSecondsUntilWeeklyReset | Readable mirror if Fandom blocks. |
| https://github.com/Stanzilla/WoWUIBugs/issues/533 | Referenced from GetServerTime wiki — UI bug tracker context for server-time edge cases. |

## Regional reset timers (UTC)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowreset.com/ | Clean UTC statement: US weekly Tue **15:00 UTC**; EU Wed **04:00 UTC**; daily same clocks; notes EU 2022 shift from 07:00 → 04:00. |
| https://wowreset.com/us.html | US/LATAM/OCE-only view of the same anchors. |
| https://whenreset.com/ | UTC-first countdown UX; reinforces Tue 15:00 / daily 15:00 for US. |
| https://www.zockify.com/classic/calendar/ | Classic raid reset calendar; documents Anniversary unified reset **time-of-day** = daily reset; NA vs EU calendars; Ony/ZG/AQ20 cadences. |
| https://lfcarry.com/guides/wow-weekly-reset | Secondary confirmation of US Tue 15:00 / EU Wed 04:00 UTC. |
| https://wowvendor.com/media/wow/weekly-reset-timer/ | Popular timer page; useful for local-time marketing strings — prefer UTC from wowreset when they disagree on EST wording. |
| https://us.forums.blizzard.com/en/wow/t/wow-classic-era-20th-anniversary-edition-not-sod-raid-reset-timers/2103640 | Player + reply: Anniversary 40-mans (except Ony) reset Tuesday; points at classicraidreset calendars. |

## Season / ladder boundaries

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/PvP_season | Season end → offseason week, point conversion, rating reset on new season — pattern library for any future Lent. |
| https://wowpedia.fandom.com/wiki/PvP_season | Mirror + Classic season tables. |
| https://us.forums.blizzard.com/en/wow/t/season-1-ends-on-may-4/2294275 | **Kaivax primary:** Anniversary S1 end as PDT/EDT absolute time; S2 starts **with weekly reset** Tue May 19. Gold-standard announcement shape. |
| https://dotesports.com/wow/news/when-does-wow-tbc-classic-arena-season-one-end | Community summary of season end riding weekly reset (historical TBC Classic). |
| https://soffe.github.io/ClassicEraHonorCalculator/ | Era honor **weekly** reset countdowns — analogy for week-scoped ladders, not CoB V1. |

## Realm placement (CoB)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://guildsofwow.com/looking-for-guild/anniversary-us/dreamscythe | Dreamscythe listed under Americas · TBC Anniversary → **US reset table**. |
| https://classic-armory.org/anniversary/us/dreamscythe | Armory path `anniversary/us/dreamscythe` confirms US region. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §7–§8, §15–§16 | Scoring sources, caps intent, revision/`updatedAt`, Lent deferred, US dual-guild scope. |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) Task 4 | `GetDayKey(now)`, daily caps, bucket grants. |
| [`../27-desync-conflict-resolution/`](../27-desync-conflict-resolution/) | Why `updatedAt` is tiebreak-only after revision. |
| [`../26-ladders-points-gamification/`](../26-ladders-points-gamification/) | Season/FOMO psychology — complement, not clock policy. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-getservertime.json`](.raw/search-getservertime.json) | `GetServerTime` / `time()` / calendar APIs |
| [`.raw/search-weekly-resets.json`](.raw/search-weekly-resets.json) | Regional weekly/daily reset trackers + Classic calendars |
| [`.raw/search-season-boundaries.json`](.raw/search-season-boundaries.json) | Arena seasons, phase ties, ladder reset design |
| [`.raw/search-wiki-time-apis.json`](.raw/search-wiki-time-apis.json) | wiki.gg time API cluster |
| [`.raw/search-cob-realms.json`](.raw/search-cob-realms.json) | Dreamscythe / Doomhowl region + UTC resets |
| [`.raw/search-reset-countdown-apis.json`](.raw/search-reset-countdown-apis.json) | Countdown helpers vs Classic |
| [`.raw/search-classic-api-availability.json`](.raw/search-classic-api-availability.json) | Season blue + Classic API notes |
| [`.raw/extract-wowpedia-api-time.md`](.raw/extract-wowpedia-api-time.md) | Extract of API `time` docs |
| [`.raw/extract-wowreset.md`](.raw/extract-wowreset.md) | Extract of wowreset.com UTC FAQ |
