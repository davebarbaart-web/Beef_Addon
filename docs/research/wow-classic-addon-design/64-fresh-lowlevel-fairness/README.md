# Track 64 — Fresh / low-level fairness & catch-up

**Track id:** `64-fresh-lowlevel-fairness`  
**Last updated:** 2026-07-25  
**Sole focus:** How Classic guild fun-score / points cultures treat **new members, low-level characters, and alts** — catch-up, newbie nights, level-banded credits — and what that implies for **Fresh Beef → Cooked Beef pacing**.  
**Out of scope:** Ladder/points gamification core (thresholds psychology, anti-farm, ranking UX, EPGP tables as product) — [26](../26-ladders-points-gamification/). Alt SV identity & account merge doctrine — [25](../25-multi-toon-realm-edges/). Content-phase seasons / Lent resets — [46](../46-seasonality-fresh-servers/). Guild-night facilitator runbook — [51](../51-guild-night-playbook/). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked default | Value |
|----------------|-------|
| Default rank | **Fresh Beef** at 0 standing ([§4](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| First hook | First full dungeon night with guildmates → Fresh → Cooked suggestion eligibility ([§4.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Draft Cooked threshold | 50 standing (tunable; playtest owns the number) |
| Alts | Per-character SV; each alt starts Fresh Beef ([§9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Decay | Off in V1 ([§4.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Co-play source | Instance types only, combat-gated buckets + daily caps ([§7](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Open doors | Alt linking §16.1; Lent/decay if saturated §16.3; threshold tuning §16.6 |

## Index

| Note | Covers |
|------|--------|
| [classic-catchup-patterns.md](classic-catchup-patterns.md) | How DKP/EPGP/fun-score guilds treat newcomers & alts (steal/avoid) |
| [newbie-nights-and-level-bands.md](newbie-nights-and-level-bands.md) | Newbie/alt nights; level-banded credit ideas |
| [fresh-beef-pacing.md](fresh-beef-pacing.md) | Implications mapped to Fresh → Cooked pacing |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with sibling tracks

| This track (64) | Elsewhere |
|-----------------|-----------|
| *Whether* lowbies/alts feel the ladder is reachable in week one | Track 26: how boards, caps, and toxicity work in general |
| Catch-up / priming patterns from loot economies (as warnings) | Track 26: do not re-litigate EPGP as Beef UX |
| Level-band & newbie-night *credit framing* | Track 15: instance-complete signal reliability |
| “Alt starts Fresh” as fairness/pacing choice | Track 25: SV keys, rename, account merge options |
| Soft season as *late* catch-up valve | Track 46: when phases trigger season labels |
| Measuring the first dungeon night | Track 51: clipboard / facilitator roles |

## Top insights for Beef (read this first)

1. **Loot catch-up tools are the wrong transplant.** EPGP’s catch-up is **percentage decay** plus a **Min EP roadblock** and **Base GP floor** so new/idle members neither leapfrog veterans nor get infinite PR ([EPGPWeb — The System](http://www.epgpweb.com/help/system); [Wowpedia: EPGP](https://wowpedia.fandom.com/wiki/EPGP)). Beef is not loot priority. Do **not** invent Min-EP-style “attend N raids before Cooked Beef.” The pacing rule already *is* the onboarding product.

2. **DKP inflation is the real Fresh Beef enemy.** Long-running no-decay DKP leaves newcomers unable to compete; hard caps and zerosum exist because veterans never stop earning ([MMORPG.com DKP thread](https://forums.mmorpg.com/discussion/239047/how-to-make-a-dkp-system-work); Classic forum war stories where “new people catching up didn’t happen” — [How Did You DKP?](https://us.forums.blizzard.com/en/wow/t/how-did-you-dkp/1645502)). Beef’s answer is **named early titles + scarce top seats**, not a spendable bank. Keep standing numbers secondary so “everyone else has 4000 standing” does not feel like unpaid slave DKP.

3. **V1 already chose the healthy newcomer shape.** Fast Fresh → Cooked, slow mid ladder, appointed Council/Prophet. That matches leaderboard research: boards die when rookies cannot move in a session; show “you + neighbors,” not unreachable elites ([UI Patterns: Leaderboard](https://ui-patterns.com/patterns/leaderboard); [Building better leaderboards](https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7)). Protect the *first night* hook harder than any late-game catch-up formula.

4. **Per-character alts are fairness *and* theater — not a bug.** Spec §9 + track 25: flesh proves itself anew. Classic DKP culture often restricted alt bids / filtered alts in tables ([WebDKP alt filters](https://webdkp.com/addon); forum anecdotes of alts bidding vs mains — [How Did You DKP?](https://us.forums.blizzard.com/en/wow/t/how-did-you-dkp/1645502)). Beef should document “alts start Fresh” in guild copy; do not silently gift Cooked to bank alts.

5. **Low-level instance co-play must fully count.** Officers historically wanted incentives for helping / leveling guildmates ([Guild Addon help](https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778)). Spec already credits any instance type with a guildmate — RFC/VC nights are first-class Beef, not “practice until 70.” Do not gate standing to raids or max-level content.

6. **Newbie nights → ceremony credit, not a second points economy.** Social ops (Discord “newbie night,” alt dungeon night) map cleanly to officer **Ceremony** close grants (§7.1). Prefer a flat ceremony bump for attendees over inventing XP-gain trackers (AFK-farm candy — already flagged in track 26).

7. **Level-band multipliers are optional flavor, not V1 necessity.** Classic honor already level-gates credit (HK only if target is not gray — [Honor system (Classic)](https://wowpedia.fandom.com/wiki/Honor_system_(Classic))). For Beef, equal drip + daily caps is enough if Fresh → Cooked hits in one night. If playtest shows 70s farming heroics outpace 20s in RFC for the *same* comedy intent, consider a mild “under-cap level band” bonus or ceremony — not a spreadsheet of per-bracket weights.

## Recommended policy sketch (research → product)

| Situation | Recommended Beef response |
|-----------|---------------------------|
| Brand-new guild recruit | Fresh Beef @ 0; first guild dungeon night → Cooked eligibility (tune 50) |
| Veteran’s fresh alt | Same as recruit — no account inheritance in V1 |
| Newbie / alt dungeon night | Co-play drip + optional Ceremony close grant; announce one Cooked if earned |
| Mid-ladder “I joined late” | Titles + My Standing neighbors; officer adjust only for comedy/corrections — not silent EP inject |
| Ladder saturation (many Butchers) | Track 46 / §16 Lent or raise thresholds — not Min EP |
| Want “catch-up points” | Prefer ceremony / Gora participation / soft season label over permanent newbie multiplier |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer EPGPWeb / Wowpedia / Blizzard forums / UX pattern sources for claims. Product locks stay in the design spec.
