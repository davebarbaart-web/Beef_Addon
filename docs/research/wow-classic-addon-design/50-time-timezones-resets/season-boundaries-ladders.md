# Season boundaries for ladders

**Track:** 50 — time, timezones, resets  
**Question:** How does Blizzard bound PvP / content seasons, and what should a guild ladder (Beef) learn?

## 1. What “season” means in WoW (vs Beef)

| Kind | Who owns the boundary | Typical length | Reset behavior |
|------|----------------------|----------------|----------------|
| **Arena / PvP season** | Blizzard | ~11–20 weeks historically; Anniversary can be shorter | Personal ratings reset; rewards cut over; often **1-week offseason** ([PvP season — Warcraft Wiki](https://warcraft.wiki.gg/wiki/PvP_season)) |
| **Content phase** (Karazhan → SSC/TK → …) | Blizzard patch calendar | Weeks–months | Unlocks raids/systems; may coincide with Arena season swaps |
| **Raid lockout week** | Regional weekly reset | 7 days | Lockouts / weeklies — not a ladder wipe |
| **Beef standing season** (future “Lent”) | Guild / officers (product) | Spec: deferred | Optional standing wipe or decay — **not** automatic in V1 |

V1 Church of Beef is a **monotone standing ladder** (no decay). Season research here is for (a) not accidentally coupling Beef UI to Arena season, and (b) designing a future Lent reset correctly.

## 2. How Blizzard announces season edges (Anniversary example)

Blue post pattern for TBC Classic Anniversary Season 1 → 2 ([Kaivax — Season 1 Ends on May 4](https://us.forums.blizzard.com/en/wow/t/season-1-ends-on-may-4/2294275)):

- **Season end** given as a precise **region-local wall time** (example: US “10:00 p.m. PDT Monday May 4” / “1:00 a.m. EDT Tuesday May 5”).
- **Season start** tied to **weekly reset** (“Season 2 will start with the weekly reset on Tuesday, May 19”).
- Rewards distributed at season-start reset, not necessarily at the moment ladders freeze.

Community coverage matches the same coupling: Arena Season 1 end / Season 2 start ride phase and weekly-reset language ([Dot Esports TBC Classic S1 end](https://dotesports.com/wow/news/when-does-wow-tbc-classic-arena-season-one-end); Anniversary Phase 2 writeups tying S2 to phase launch).

**Design lesson:** Authoritative seasons are **announced instants + regional weekly alignment**, never “the week of May 19 in your local timezone.”

## 3. Offseason gap

Wiki summary for modern PvP seasons: after a season ends, rated play may be unavailable for about a week while Conquest/Arena points convert and eligibility is computed ([PvP season](https://warcraft.wiki.gg/wiki/PvP_season)). Anniversary players complained about short seasons + multi-week gaps in the same blue threads — socially hot, mechanically clear: **there is a defined gap**, not a seamless rollover.

If Beef ever adds seasons:

- Prefer **instant cutover** (standing archived at `GetServerTime() >= T`) or **officer-fired Lent ceremony**.
- Avoid silent “offseason” where the UI looks broken unless that theater is intentional.

## 4. Guild / comedy-church ladders should not auto-bind to Arena season

Reasons:

1. **Different goals.** Arena seasons reset *competitive MMR*. Beef ranks are social titles; wiping them every Arena season destroys church continuity.
2. **Phase coupling is Blizzard’s, not the guild’s.** CoB may want a Lent wipe mid-phase or never.
3. **Two CoB guilds** (Dreamscythe / Doomhowl) share US reset clocks but are independent churches — each would need its own Lent decree anyway.

Optional **display** only: “Blizzard Arena Season 2 is live” as flavor — never as the standing wipe trigger unless officers opt in.

## 5. Classic Era honor weeks (contrast)

Era / SoD honor calculators countdown to the **next weekly honor reset** per region ([Classic Honor Calculator](https://soffe.github.io/ClassicEraHonorCalculator/)). That is another “ladder week” system — weekly, not multi-month. Useful analogy for **weekly capped currencies**, closer to Beef’s **daily** caps than to Arena seasons.

## 6. Future Lent / decay — recommended boundary policy

From spec open questions: standing decay off; Lent is on-brand if the ladder saturates.

Recommended policy if revisited:

| Decision | Recommendation |
|----------|----------------|
| Clock | `GetServerTime()` instant stored in officer commit / guild decree message |
| Alignment | Default suggestion: **next US weekly reset (Tuesday 15:00 UTC)** after officer vote — matches player mental model of “new week” |
| Scope | Standing and/or titles — product choice; Prophet/Council may be exempt |
| Sync | Decree is a `RANK_COMMIT`-class or dedicated season message with revision; peers must not invent local Lent |
| UX | Announce in guild chat + ladder banner with **UTC and local preview** |

## 7. Steal / adapt summary

| Steal from Blizzard seasons | Adapt for Beef |
|----------------------------|----------------|
| Announce end as absolute time; start on weekly reset | Lent decree = UTC `T` or “next weekly” |
| Offseason is explicit | Don’t strand UI in undefined state |
| Ratings reset; cosmetics/history remain meaningful | Soft archive: hide old season standings, keep lore titles optional |
| Do not silently follow Arena | V1: ignore Arena season for scoring |
