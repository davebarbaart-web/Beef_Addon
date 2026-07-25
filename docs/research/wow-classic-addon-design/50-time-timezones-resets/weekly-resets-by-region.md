# Weekly (and daily) resets by region

**Track:** 50 — time, timezones, resets  
**Question:** When does Blizzard’s content week flip, and which schedule applies to Church of Beef?

## 1. UTC anchors (current community consensus)

Cross-checked trackers agree on these **UTC** anchors ([wowreset.com](https://wowreset.com/); [wowreset US](https://wowreset.com/us.html); [whenreset.com](https://whenreset.com/); [Zockify Classic calendar](https://www.zockify.com/classic/calendar/); [LFCarry weekly reset](https://lfcarry.com/guides/wow-weekly-reset)):

| Region | Daily reset | Weekly reset |
|--------|-------------|--------------|
| **US / Latin America / Oceanic** | Every day **15:00 UTC** | **Tuesday 15:00 UTC** |
| **Europe** | Every day **04:00 UTC** | **Wednesday 04:00 UTC** |

**EU historical note:** EU reset moved from **07:00 UTC → 04:00 UTC** on **2022-11-16** ([wowreset.com FAQ](https://wowreset.com/)). Do not copy pre-2022 EU guides.

**Asia (CN / KR / TW):** Frequently cited as **23:00 UTC** for daily reset in secondary FAQs; less critical for CoB V1 (US Anniversary guilds). Confirm from a Blizzard-primary or region-local source before shipping KR/TW builds.

Local-clock marketing (“Tuesday 11 AM EST”, “10 AM EST”, “CET Wednesday 5 AM”) drifts with DST labeling. **Prefer UTC** in design docs and code comments.

## 2. What the weekly reset actually clears (Classic context)

On Classic-family realms, the global weekly moment is the cadence players plan raids around:

- **7-day raid lockouts** (MC / BWL / AQ40 / Naxx-style, and TBC 25s when present) flip on the regional weekly day ([Zockify](https://www.zockify.com/classic/calendar/); Blizzard forum confirmation that 40-mans besides Ony reset Tuesday on US Anniversary — [forum thread](https://us.forums.blizzard.com/en/wow/t/wow-classic-era-20th-anniversary-edition-not-sod-raid-reset-timers/2103640)).
- **Shorter lockouts** (Classic Ony 5-day; ZG / AQ20 3-day) run on their own calendars but share the **same time-of-day** as daily reset since Anniversary unification ([Zockify](https://www.zockify.com/classic/calendar/)).
- Retail-only systems (Great Vault, M+ weekly) appear in many timer sites — ignore for Anniversary TBC scoring design.

Daily reset refreshes daily quests / many “once per day” activities at the same UTC clock as above.

## 3. Church of Beef realm mapping

| Realm | Flavor | Region for resets |
|-------|--------|-------------------|
| Dreamscythe | TBC Classic Anniversary, US | **US table** (Tue / daily 15:00 UTC) |
| Doomhowl | TBC Classic Anniversary, US | **US table** |

Evidence: guild-finder / armory listings place Dreamscythe under Americas · TBC Anniversary ([Guilds of WoW](https://guildsofwow.com/looking-for-guild/anniversary-us/dreamscythe); [ClassicArmory](https://classic-armory.org/anniversary/us/dreamscythe)). Spec: separate guilds, no cross-realm church state — both still share the **same regional reset clock**.

## 4. Computing “seconds until reset” without Retail APIs

If `C_DateAndTime.GetSecondsUntilWeeklyReset` is missing on 20506:

1. Take `now = GetServerTime()`.
2. Find next Tuesday ≥ now whose UTC hour/min/sec == 15:00:00 (US).
3. `seconds = next - now`.

Same pattern for daily: next 15:00 UTC boundary.

**Do not** use `date("!*t", GetServerTime())` carelessly without confirming the client’s `date` UTC flag behavior in-game — verify once on Anniversary; if `!*t` is unavailable/broken in the sandbox, compute with integer arithmetic on Unix seconds (`now % 86400` relative to a known epoch aligned to 15:00 UTC).

## 5. Maintenance & exceptions

Scheduled maintenance can delay the *practical* availability of lockouts even when the timer hits. Blue posts and in-game raid info remain authoritative for “can I enter?” Community calendars are planning tools, not guarantees ([wowreset disclaimer](https://wowreset.com/)).

For Beef scoring caps, a delayed raid lockout **does not** need to delay the day key — unless product later ties a ceremonial weekly to lockouts.

## 6. Steal / adapt summary

| Steal | Adapt for Beef |
|-------|----------------|
| US 15:00 UTC daily + Tuesday weekly | Default day-key and any future “Beef week” |
| EU 04:00 UTC Wed | Document only; unused while CoB is US-only |
| Classic lockout calendars | Optional guild calendar flavor — not scoring authority |
| UTC-first presentation | Microcopy: “resets with the realm day (15:00 UTC)” for officers |
