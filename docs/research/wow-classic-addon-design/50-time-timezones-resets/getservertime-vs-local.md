# GetServerTime vs local time vs realm wall-clock

**Track:** 50 — time, timezones, resets  
**Question:** Which WoW client clock should Church of Beef trust for scoring windows and sync timestamps?

## 1. The four clocks addons actually mix up

| API | What it represents | Synced across guildmates? | Spoofable by changing OS clock? |
|-----|--------------------|---------------------------|----------------------------------|
| `time()` / `date()` | Local machine Unix / formatted local time ([API time](https://wowpedia.fandom.com/wiki/API_time)) | **No** | **Yes** |
| `GetServerTime()` | Server-derived Unix timestamp ([GetServerTime](https://warcraft.wiki.gg/wiki/API_GetServerTime); added Patch 6.2.0) | **Yes** (wiki: synchronized among clients) | Practically no (client caches offset from server) |
| `GetGameTime()` / `C_DateAndTime.GetCurrentCalendarTime()` | Realm **wall-clock** hour:minute (+ calendar fields) | Same realm display time | N/A (display of realm time) |
| `C_DateAndTime.GetServerTimeLocal()` | Unix-like stamp **shifted into realm timezone** | Same “realm local” interpretation | Same family as server time APIs |
| `GetTime()` | Seconds since client process start (uptime) | No — per machine session | No (not wall clock) |

Wiki example (EU player on US Moon Guard, same instant) shows `time()` ≈ `GetServerTime()` numerically when clocks are honest, while `date()` prints local wall time and `GetGameTime()` prints **realm** hour — illustrating that “looks close” is not “same semantics” ([API time](https://wowpedia.fandom.com/wiki/API_time)).

## 2. Why `time()` is unsafe for Beef

From the wiki notes on `time()`:

- It is Lua `os.time` in the global namespace.
- With no args, it uses the **local clock** → **not synchronized among clients**.
- Explicit recommendation: prefer `GetServerTime()` when you want a server-based value.

Failure modes if Beef used `time()` for `updatedAt` or day keys:

1. **Clock skew tiebreaks.** Spec §8.3: equal revision → later `updatedAt` wins. Two officers with drifted OS clocks can invert “who wrote last.”
2. **Cap window shopping.** A player who sets the OS clock forward can roll a new local “day” and refill daily caps (advisory standing still needs officer approval — but inflated suggestions waste officers and poison trust).
3. **Traveler / dual-boot oddities.** Same Battle.net account, different machines, different local midnights → inconsistent personal day keys even without malice.

## 3. What `GetServerTime()` is (and is not)

**Is:** A Unix epoch seconds value derived from the connection’s server time offset (client stores delta at connect; Lua call returns immediately from cache — same pattern discussed historically for minute-granularity realm clocks on older APIs).

**Is not:**

- A guarantee of *sub-second* agreement with every other client at the exact same nanosecond (small drift between cache refreshes is normal; wiki examples show 1–2s differences next to `time()`).
- The same number as `GetServerTimeLocal()` (timezone-shifted).
- A substitute for `GetTime()` when you need smooth relative timers inside one session.

**Beef rule:** Persist and transmit **`updatedAt = GetServerTime()`** (integer seconds). Display with `date()` only for UI (“committed 3 minutes ago”) after converting, or show relative age.

## 4. Realm wall-clock pitfalls (`GetGameTime`)

[GetGameTime](https://warcraft.wiki.gg/wiki/API_GetGameTime) returns hours/minutes for “realm time.” Older wiki commentary (still relevant as a caution) notes that **instance/PvP shard servers** can disagree with the login realm’s timezone for some players (Oceanic / low-pop edge cases). For CoB:

- Fine for flavor UI (“realm clock says 20:04”).
- **Bad** as the sole input to “is it Tuesday reset yet?” without converting through a UTC policy.
- Minute precision only — useless for 60s bucket boundaries.

## 5. Relative time: buckets and anti-AFK

Plan Task 4: instance drip every ~60s if combat occurred in the bucket.

| Concern | Prefer |
|---------|--------|
| “Has 60s elapsed since last bucket tick?” | `GetTime()` delta (or `GetServerTime()` delta — either works; `GetTime()` is traditional for OnUpdate pacing) |
| “Which scoring day does this grant belong to?” | `GetServerTime()` → day key (see [beef-scoring-windows.md](beef-scoring-windows.md)) |
| “Did combat happen this bucket?” | Combat flag / `UnitAffectingCombat` / CLEU — not a clock |

Combat log event timestamps are their own story (often compared against server/local in community threads); for V1 anti-AFK, **combat presence in the bucket** is enough — do not invent CLEU clock forensics.

## 6. Classic Anniversary availability notes

| API | Anniversary / TBC Classic expectation |
|-----|----------------------------------------|
| `time` / `date` / `GetTime` / `GetGameTime` | Ancient; available |
| `GetServerTime` | Present on modern Classic clients (wiki Added 6.2.0; Classic trees inherited it) — **still verify once in-game on 20506** |
| `C_DateAndTime.*` | Partially backported on Classic flavors; treat each helper as **probe-before-rely** |
| `GetSecondsUntilWeeklyReset` / `GetSecondsUntilDailyReset` | Retail 9.0.1+ family — **do not assume** on TBC Anniversary |

## 7. Steal / adapt summary

| Steal | Adapt for Beef |
|-------|----------------|
| Wiki’s hard line: sync → `GetServerTime` | All official `updatedAt`, SCORE_EVENT times, day keys |
| Realm calendar APIs for display | Optional “realm time” in ceremony UI only |
| `GetTime` for pacing | Bucket ticker only |
| Never trust OS local midnight for economy | Day key from US daily reset UTC (CoB) |
