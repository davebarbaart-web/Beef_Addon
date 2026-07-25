# Content phases as Beef seasons

## Blizzard’s calendar (TBC Anniversary)

Community synthesis of Anniversary dates ([Warcraft Tavern](https://www.warcrafttavern.com/tbc/guides/phases/), cross-checked with [Wowhead roadmap](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap) and [official Phase 3 news](https://worldofwarcraft.com/en-us/news/24291476)):

| Phase | Approx. Anniversary date | Headline raids / content | Arena (parallel) |
|-------|--------------------------|---------------------------|------------------|
| Pre-patch | 2026-01-13 | Races, JC, Dark Portal event | Skirmishes |
| Phase 1 | 2026-02-05 (raids ~Feb 19) | Karazhan, Gruul, Magtheridon | Season 1 |
| Phase 2 | 2026-05-14 | Serpentshrine, Tempest Keep: The Eye | Season 2 |
| Phase 3 | **2026-08-27** (official) | Hyjal, Black Temple | Season 3 (starts with weekly restarts per Blizzard) |
| Phase 4 | Autumn 2026 (TBA) | Zul’Aman, catch-up / BoJ era | — |
| Phase 5 | Autumn 2026 (TBA) | Sunwell, Quel’Danas, Magisters’ Terrace | Season 4 |

Phase lengths are **months**, not weeks — closer to liturgical seasons than to weekly raid lockouts.

## Mapping rule

**One Beef season ≈ one content phase** (or pre-patch as Season 0).

| Blizzard phase | Suggested Church season name (flavor only) | Standing policy |
|----------------|--------------------------------------------|-----------------|
| Pre-patch | Season of the Portal / Advent | Persist (V1) |
| Phase 1 | Season of Karazhan (Tier 4) | Persist |
| Phase 2 | Season of the Overlords (Tier 5) | Persist |
| Phase 3 | Season of the Temple (Tier 6) | Persist; best soft-reset ceremony window |
| Phase 4 | Season of Zul’Aman | Persist; catch-up era — good time for recruit pacing, not wipes |
| Phase 5 | Season of the Sunwell | Persist; end-of-testament snapshot optional |

Names are canon *prose* candidates for `docs/canon/` later — not machine IDs. Machine side (post-V1) wants a monotonic `seasonId` officers can advance.

## What a “season” means at each product layer

| Layer | V1 | Post-V1 if saturation hurts |
|-------|----|-----------------------------|
| UI label | Optional “Season of …” footer / officer-set string | Same + history of prior season names |
| Standing points | Unchanged (no decay) | Soft % decay, or zero standing with **ranks kept**, or full Lent wipe |
| Ranks 1–5 | Persist | Usually persist; demotions stay manual |
| Council / Prophet | Persist (scarcity already protects prestige) | Re-anoint ceremony optional |
| Seasonal leaderboard | Out of V1 | Snapshot top standings at phase end for stream clips |
| BeefNet | No season field required | Optional `SEASON_COMMIT` from Officer+ so all clients share the label |

## Do not couple to arena season resets

Arena seasons reset personal ratings and rotate gear ([PvP season](https://warcraft.wiki.gg/wiki/PvP_season)). Classic arena seasons historically track phases. That is useful for **streamer calendar** (“Season 3 opens with weekly restarts” — [Blizzard BT post](https://worldofwarcraft.com/en-us/news/24291476)) but a bad trigger for wiping guild standing: PvP alts and non-arena members would feel punished for a ladder they do not climb.

**Rule:** Church season boundaries follow **raid tier unlocks**; arena season notes are ceremony/streamer garnish only.

## Why phase boundaries beat weekly resets for hard policy

1. **Social story changes** when a new tier opens — attendance, attunements, spectacle — matching “New Testament” language.
2. Spec pacing already wants early ranks fast and later ranks slow ([spec §4.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)); wiping every Tuesday destroys that curve.
3. EPGP-style continuous decay is track-26 territory and was consciously **not** chosen for V1; phase-gated officer Lent is the on-brand alternative ([spec §16.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

## Officer playbook (no code)

At each phase open:

1. Announce the new season name in guild chat / stream.
2. Optionally run a ceremony (existing scoring source).
3. Decide explicitly: **persist standing** (default) vs **Lent reset** (saturation only).
4. If reset: treat as officer corrections / future season commit — same authority model as promotions (Officer+ is anti-cheat).
5. Never auto-reset because the client noticed Tuesday maintenance.
