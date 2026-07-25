# Track 46 — Seasonality, fresh servers, lockouts, raid tiers

**Track id:** `46-seasonality-fresh-servers`  
**Last updated:** 2026-07-25  
**Sole focus:** How Classic **fresh realms**, **content phases**, **raid lockouts**, and **raid tiers** should shape Church of Beef **points seasons and resets** — not the ladder/points core itself.  
**Out of scope:** Threshold numbers, anti-farm caps, suggestion UX, EPGP/DKP psychology, toxicity of leaderboards — see [26-ladders-points-gamification](../26-ladders-points-gamification/). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Platform | TBC Classic Anniversary (`Interface` **20506** per plan) |
| Guild footprint | Alliance **Dreamscythe**, Horde **Doomhowl** — **independent ladders**, no cross-realm state ([spec §5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Standing | Points only go up in V1; **no automatic decay** ([spec §4.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Open door | If the ladder saturates, revisit **seasonal resets or decay** — a “Lent” season reset is on-brand ([spec §16.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Scoring sources | Shared instance co-play, ceremony, Beef Gora — instance types only for co-play ([spec §7](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Alts | Per-character; alt starts Fresh Beef ([spec §9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |

## Index

| Note | Covers |
|------|--------|
| [fresh-servers-and-realm-identity.md](fresh-servers-and-realm-identity.md) | Anniversary fresh launch → TBC progression; Dreamscythe / Doomhowl caveats |
| [content-phases-as-beef-seasons.md](content-phases-as-beef-seasons.md) | TBC Anniversary phase calendar → recommended Beef season boundaries |
| [lockouts-and-weekly-rhythm.md](lockouts-and-weekly-rhythm.md) | Strict raid IDs, Tuesday/Wednesday resets, what Beef should (not) do with lockouts |
| [raid-tiers-and-season-weight.md](raid-tiers-and-season-weight.md) | Tier 4→5→6→ZA→Sunwell as social eras, not auto-weight tables |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with track 26

| This track (46) | Track 26 |
|-----------------|----------|
| *When* seasons start/end relative to Blizzard phases & fresh launches | *How* points, ranks, leaderboards, and toxicity work |
| Lockout calendar as guild rhythm | Anti-farm caps, drip rates, suggestion UX |
| Soft vs hard reset policies for saturation | EPGP decay math and ranking psychology |
| Realm / faction independence under Anniversary progression | Canon rank ladder titles and thresholds |

Do not re-litigate Fresh Beef → Beef Prophet here. Do not invent new scoring sources. This track only answers: **what Blizzard calendar events should trigger a Church season label, soft refresh, or (post-V1) hard reset.**

## Top insights for Beef (read this first)

1. **Align Church seasons to content phases, not to arena PvP seasons.** Blizzard’s TBC Anniversary cadence is a five-phase PvE unlock schedule (plus pre-patch), with arena seasons riding alongside. Beef is a guild social ladder, not Conquest. Prefer “Season of Karazhan / Overlords / Black Temple …” named after the phase’s raid story — not Gladiator title resets. Arena season resets ([PvP season](https://warcraft.wiki.gg/wiki/PvP_season)) are a *parallel* calendar; optionally announce them as streamer spectacle, never as automatic standing wipes.

2. **V1 should stay “eternal standing + optional season *label*,” not auto-wipe.** Spec locks no decay. The right V1 product is: a `seasonId` / season name in UI copy (and optional officer ceremony at phase open), while standing and ranks persist. Hard resets (“Lent,” phase wipe) remain the §16 open door for when Butcher saturates — implement as **officer-authored season commit**, not silent client calendar magic.

3. **Fresh-server psychology is already baked into Anniversary history.** 20th Anniversary realms launched empty (Nov 2024) and *progressed* into TBC rather than wiping characters ([Wowhead Fresh roadmap](https://www.wowhead.com/classic/guide/fresh-servers-roadmap-phases), [Wowhead TBC Anniversary roadmap](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap)). Beef should treat “fresh” as a **one-time community origin myth**, not a recurring weekly mechanic. New guild recruits still start Fresh Beef; the *realm* does not re-fresh mid-expansion.

4. **Dreamscythe ≠ Doomhowl as client/progression peers.** Dreamscythe is the NA Anniversary **PvE** realm that moved into TBC. Doomhowl is the NA **Hardcore** realm that **stays Classic-only**; HC characters transfer to a PvE realm to continue into TBC ([Wowhead server list](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap)). Spec brand copy (“Horde on Doomhowl”) may describe community identity more than “same install tree.” V1 TBC addon installs on Dreamscythe (and any Horde guild that transferred); do not assume a live TBC Doomhowl ladder without verifying the current guild home.

5. **Raid lockouts are weekly rhythm, not points authority.** Classic/TBC raids use **strict instance-based lockouts** (saved to a Raid ID until calendar reset — typically Tuesday NA / Wednesday EU) ([Raid lockout](https://wowpedia.fandom.com/wiki/Raid_lockout)). That creates one meaningful “raid week” per character per raid. Beef’s co-play scoring already uses instance presence + caps; lockouts should inform **officer expectations and anti-double-count intuition**, not become a second scoring system. Reading `GetSavedInstanceInfo` is optional flavor/debug later — not a V1 dependency.

6. **New raid tiers are the natural soft-reset ceremony.** When Phase 3 opens Black Temple / Hyjal ([official news](https://worldofwarcraft.com/en-us/news/24291476)), the social meta reboots even if standing numbers do not. Recommended post-V1 pattern: officer “New Testament” ceremony → optional standing soft-decay or seasonal leaderboard snapshot → ranks retained unless clergy decrees otherwise. Matches on-brand Lent language without fighting the no-decay V1 lock.

7. **Per-day caps already approximate Blizzard’s daily heroic reset; don’t invent a second weekly standing reset in V1.** Heroics reset daily; raids weekly. Spec §7.2 already has per-day caps on instance drip. A *weekly* Beef standing reset would fight raid-week storytelling (attendance over a lockout) and is worse than phase-boundary seasons.

## Recommended policy sketch (research → product)

| Horizon | Blizzard clock | Beef response (recommended) |
|---------|----------------|-----------------------------|
| V1 ship | Mid Phase 2 → Phase 3 | No standing wipe. Optional UI season name = current content phase. |
| Phase open (e.g. Aug 27 2026 BT) | New raid tier + often new arena season | Officer ceremony + season label bump; standing persists unless leadership opts into §16 reset. |
| Ladder saturation | Many members at Beef Butcher | Soft options first (raise thresholds, appoint Council scarcity). Hard “Lent” reset only via officer season commit. |
| True fresh realm / expansion port | New empty servers or Classic+ | New guild ladders start empty by definition (new SV / new guild). Do not carry Dreamscythe history cross-realm. |
| Weekly lockout | Tuesday/Wednesday | Narrative “raid week”; keep scoring caps daily; never auto-demote on reset. |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer design spec for product locks; Wowhead / Warcraft Tavern / Blizzard news for Anniversary calendars; wiki for lockout mechanics.
