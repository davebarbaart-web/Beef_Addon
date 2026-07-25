# Raid tiers & season weight

## Tier ladder (TBC Anniversary)

| Tier / era | Raids | Phase (Anniv.) | Social role |
|------------|-------|----------------|-------------|
| Tier 4 | Karazhan, Gruul, Magtheridon | 1 | Founding raid habit; 10-man + entry 25s |
| Tier 5 | SSC, The Eye | 2 | “Serious” progression identity |
| Tier 6 | Hyjal, Black Temple | 3 | Prestige peak of mid-expansion |
| Catch-up / ZA | Zul’Aman | 4 | Faster resets culture historically; recruit-friendly |
| Tier 6 endgame | Sunwell Plateau | 5 | Final testament; roster hardness |

Sources: [Warcraft Tavern phases](https://www.warcrafttavern.com/tbc/guides/phases/), [Wowhead roadmap](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap), [Blizzard Black Temple](https://worldofwarcraft.com/en-us/news/24291476).

## Weighting philosophy (seasonality only)

Track 26 owns point magnitudes. This track only answers whether **tier changes** should change season *policy*:

| Approach | Verdict for Beef |
|----------|------------------|
| Auto-multiply standing gains in new tiers | **No for V1** — silent inflation fights threshold tuning |
| Officer-tunable weights per instance map | Future canon data concern; not seasonality |
| Treat new tier as **season ceremony**, not weight table | **Yes** — matches religious-sports fantasy |
| Snapshot “Tier champions” (most standing gained *during* the phase) | Good post-V1 streamer board; leave lifetime standing intact |
| Demote everyone when Sunwell opens | **No** — Prophet/Council scarcity already protects top; demotions stay manual |

## Why tiers matter more than lockouts for Church seasons

- A lockout is a **cooldown**. A tier unlock is a **chapter**.
- Guild identity language shifts (“Kara team” → “BT progression”) — season names should follow that.
- Catch-up phases (ZA, BoJ, attunement easing in later phases per Tavern/Wowhead notes) change *who can participate*, which is exactly when recruit pacing and optional soft resets matter — not mid-Tier-4 Tuesday.

## Interaction with shared-instance scoring

Spec scores dungeon / raid / BG co-play with guildmates, capped ([spec §7](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Seasonality implications:

1. **Raid nights concentrate standing** in active phases — expected; daily caps blunt farm.
2. **Dead weeks** (waiting for next phase) push value onto Gora + ceremony — design already allows that mix.
3. **Do not** special-case Sunwell kills as auto-Prophet. Rank 7 remains bestowed ([spec §4.1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

## Soft-reset recipes tied to tiers (post-V1 menu)

Ordered from least to most destructive — officers pick one at phase open if saturated:

1. **Label only** — new season name; numbers untouched (V1 default forever is fine).
2. **Seasonal board** — track `standingDeltaThisSeason`; lifetime standing remains for ranks.
3. **Standing haircut** — e.g. −X% standing, ranks unchanged (EPGP-adjacent; see track 26 for decay critique).
4. **Lent** — standing → 0, ranks 1–5 reset to Fresh Beef or to a mercy floor (e.g. Cooked Beef); Council/Prophet untouched or re-anointed.
5. **Schism** — rare: full ladder wipe + new Prophet story (streamer event, not a calendar default).

Recommend documenting the chosen recipe in guild scripture when used — ceremony first, SV second.
