# Track 26 — Ladders, points economies, gamification

**Track id:** `26-ladders-points-gamification`  
**Last updated:** 2026-07-25  
**Sole focus:** Ranking UX, season/soft resets, anti-farm incentives, spectacle vs toxicity, and Classic guild “fun-score” economies as they inform Church of Beef’s **rank ladder + standing** (design spec §4, §7, §10, §16).  
**Out of scope:** Guild social chrome / roster UX (track 09); full Attune/Gargul/RP cousin tear-downs (track 13) — only ladder-specific depth here. No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Centerpiece | 7-rank ladder (Fresh Beef → Beef Prophet) |
| Advancement | Hybrid: standing → suggestion; Officer+ approve |
| Point-driven ranks | 1–5 only; Council seat-limited; Prophet unique/bestowed |
| Anti-cheat | Standings = advisory testimony; officer commit = authority |
| Anti-abuse | Combat-gated instance buckets, per-day caps, instance-only co-play |
| Decay / seasons | **Off in V1**; open question if ladder saturates (“Lent” reset) |
| Spectacle | Guild-chat announce on promote/demote; toasts; Gora losses pay |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4, §6.3, §7, §10, §16.

## Index

| Note | Covers |
|------|--------|
| [ranking-ux.md](ranking-ux.md) | List design, local player context, macro vs micro boards, volatility |
| [season-resets.md](season-resets.md) | Soft/hard resets, prestige, honor decay lessons, Beef “Lent” option |
| [anti-farm-incentives.md](anti-farm-incentives.md) | Caps, combat gates, diminishing returns, what not to reward |
| [spectacle-vs-toxicity.md](spectacle-vs-toxicity.md) | Comparison harm, comedy framing, celebrate-more-than-top |
| [classic-guild-fun-score-systems.md](classic-guild-fun-score-systems.md) | EPGP/DKP, attendance, duel trackers — steal only the social mechanics |
| [beef-copy-avoid.md](beef-copy-avoid.md) | Explicit copy / avoid checklist mapped to V1 |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **Beef is already a “better leaderboard” shape** — seven named tiers + local standing + officer gate beats a pure numeric scoreboard. Keep the ladder as **title theater**, not a spreadsheet of raw points ([ranking UX](ranking-ux.md); [UI Patterns: Leaderboard](https://ui-patterns.com/patterns/leaderboard)).

2. **Show “you + neighbors,” not only the elite.** Absolute all-time boards go stale and demotivate rookies; contextual placement (above/below you) and short-horizon movement keep boards alive ([UI Patterns](https://ui-patterns.com/patterns/leaderboard); [Building better leaderboards](https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7)).

3. **V1 no-decay is correct for comedy; plan a soft season before saturation.** Classic honor taught that forced grind-to-maintain is hated (decay later removed); arena seasons prove soft resets re-open aspiration. Prefer optional “Lent” / ceremony reset over continuous decay ([season resets](season-resets.md)).

4. **Anti-farm is already well-aimed in the spec** — combat-gated buckets, daily caps, instance-only co-play, completion bonus, Gora losses pay. Steal diminishing-returns *ideas* from honor/same-target kill curves and Guild Wars anti-farm code; do not build loot-grade EPGP complexity ([anti-farm](anti-farm-incentives.md)).

5. **Spectacle without identity toxicity:** guild-chat announce + demote-as-content + losses-pay keep rivalry playful. Avoid rank-as-identity, time-as-skill, and opaque officer favoritism narratives that poison DKP/EPGP communities ([spectacle vs toxicity](spectacle-vs-toxicity.md)).

6. **Copy officer transparency and participation pay; avoid loot-economy gravity.** EPGP’s EP/GP + decay exists to ration loot fairness — Beef is *not* that. Fun-score cousins (duel W/L logs, attendance pings) are closer cousins than CEPGP tables ([classic guild systems](classic-guild-fun-score-systems.md); [copy/avoid](beef-copy-avoid.md)).

## Provenance

Search dumps and page extracts under [`.raw/`](.raw/). Prefer design-pattern / research / Wowhead / Wowpedia (Warcraft Wiki) sources over pure listicles for claims.
