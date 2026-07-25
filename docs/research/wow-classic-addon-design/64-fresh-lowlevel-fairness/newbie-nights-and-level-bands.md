# Newbie nights & level-banded credits

**Track:** 64 · **Scope:** Social “lowbie / alt night” practices and whether Beef should weight standing by character level.  
**Not in scope:** How to schedule nights (track [51](../51-guild-night-playbook/) / Discord habit). Instance-complete API reliability (track [15](../15-instance-completion-events/)).

## 1. What “newbie night” means in Classic guild culture

Guilds already run informal catch-up nights without points addons:

- Low-level dungeon spam for new recruits and alts (RFC → VC → Stocks → SM, etc.).
- Alt gearing / boost nights once the guild is mostly capped.
- “Help the new guy attune / quest” sessions that some DKP guilds wanted to *meter* ([Guild Addon help](https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778)).

These nights are **social catch-up**. Points systems either ignore them (raid-only DKP) or try to invent XP/time meters. Beef’s co-play source already covers the healthy case: **any instance with a guildmate**, combat-gated, daily-capped ([spec §7](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

## 2. Three credit models for low-level content

| Model | Rule | Pros | Cons |
|-------|------|------|------|
| **A. Flat instance drip (V1 default)** | Same bucket/completion weights at all levels | Simple; RFC night = real Beef; matches “first dungeon night” pacing | High-level heroic spam may outpace lowbie nights in *absolute* points/hour if weights ignore content difficulty |
| **B. Level-band bonus** | Mild multiplier while character level is below a band (e.g. &lt; max-level − N) or while in a “catch-up ceremony” | Makes shepherding nights feel intentional | Extra canon knobs; can be gamed by parking alts; smells like spreadsheet |
| **C. Ceremony overlay** | Officer starts “Newbie Liturgy” / alt night ceremony → flat grant on close | Human theater; anti-farm (officer presence); no level math | Requires an officer online; not automatic |

**Research recommendation:** Ship **A**. Use **C** for advertised newbie/alt nights. Consider **B** only if Track 51 playtest shows Fresh Beef characters cannot hit ~50 in one full low-level night while 70s trivially farm Cooked in an hour of heroics *and* that imbalance hurts comedy.

## 3. Level-banding precedents (game systems, not DKP)

Blizzard already level-gates *some* credit:

- Classic honor: HK requires the victim be high enough level (**not gray**) ([Honor system (Classic)](https://wowpedia.fandom.com/wiki/Honor_system_(Classic))).
- XP and quest rewards scale by level difference (green/yellow/orange/red/gray) — cultural literacy for “this content is for you.”

Loot DKP systems rarely band by *character level*; they band by **raid tier / main vs offspec**. Fun-score cousins that track “levels gained” are closer to Beef’s helper instinct — and closer to AFK abuse ([Guild Addon help](https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778); track 26 anti-farm).

**Implication:** If Beef ever level-bands, band **recipient level** (boost the lowbie’s drip) or **ceremony tag**, not “XP delta per minute.”

## 4. Who should get credit on a newbie night?

| Participant | V1 credit (recommended) |
|-------------|-------------------------|
| Low-level recruit / alt in the instance | Full co-play drip + completion |
| Max-level guildmate shepherding | Full co-play drip + completion (same rules) |
| Officer who closes a ceremony | Ceremony grant to attendees listed at close |
| Guildmate online but not in the instance | Nothing (no open-world / Discord-idle score) |

Shepherds must earn standing too, or veterans stop showing up for comedy duty. Do **not** make newbie night “points only for the baby” — that recreates unpaid helper labor from bad DKP cultures.

## 5. Anti-patterns specific to low-level fairness

| Anti-pattern | Why it fails |
|--------------|--------------|
| Raid-only standing | Fresh Beef alts invisible for weeks |
| Min-EP-style “N raids before first title” | Kills the §4.2 pacing hook |
| Auto XP-gain meters | AFK / leech / booster farms |
| Hidden “officer liked the newbie” multipliers | Favoritism narrative (DKP poison) |
| Account merge so alts skip Fresh | Breaks doctrine; bank-alt Prophet risk (track 25) |
| Gray-content = zero Beef | Punishes the exact nights that onboard people |

## 6. Ops hook (pointer only)

How to *run* the night (roles, clipboard, threshold retune) lives in [51-guild-night-playbook](../51-guild-night-playbook/). This track only asserts: **instrument a low-level guild dungeon night as a first-class Cooked Beef path**, not a dry run before “real” scoring starts at 70.
