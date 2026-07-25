# Anti-farm incentives and point economies

**Track:** 26 · **Scope:** How to keep standing from becoming AFK/instance camping or SavedVariables inflation theater — without building a loot-grade DKP machine.

## Spec anchor (already strong)

From design spec §7.2 / §7.1:

| Control | Spec intent |
|---------|-------------|
| Anti-AFK | Instance time bucket pays only if player entered combat in that bucket |
| Completion bonus | Reward finishing dungeons/BGs, not loitering |
| Per-day caps | Especially on instance drip |
| Instance-only co-play | No city / open-world loop farming |
| Gora losses pay | Participation > win-only meta |
| Officer adjust | Human correction for abuse / jokes |
| Advisory standing | Self-reported points; officer is anti-cheat (§6.3) |

## Patterns worth stealing

### 1. Diminishing returns on repeated easy farms

Classic honor applies heavy DR to repeated kills of the *same* target within a day, resetting on a daily boundary — variety pays, camping one corpse does not ([Boosting-Ground](https://boosting-ground.com/wow-classic/guides/pvp-guides/wow-classic-honor-system)). Guild Wars “anti-farm code” similarly reduces benefit of repeating the same location/quest ([Guild Wars Wiki: Anti-farm code](https://wiki.guildwars.com/wiki/Anti-farm_code)).

**Beef adapt:**

- Cap **same instance ID / same map** drip per day harder than “any dungeon.”
- Cap **Gora vs same opponent** per day (stops duel-farm rings).
- Cap **ceremony credit** once per ceremony id (already implied by officer close).

### 2. Reward outcomes, not presence

Completion bonuses beat pure time-on-task. Spec already pairs drip + completion. Prefer **short combat-active buckets** over long idle timers.

**Avoid:** Paying for “in group with guildmate in Stormwind.” That recreates classic AFK honor / AV AFK culture (widely documented as a farm vector in Classic communities).

### 3. Separate “effort” from “prize” (EPGP lesson, not EPGP product)

EPGP’s core insight: measuring effort (EP) separately from loot cost (GP) avoids zero-sum unfairness where the same boss awards different value based on loot RNG ([Wowpedia: EPGP](https://wowpedia.fandom.com/wiki/EPGP)).

**Beef adapt (lightweight):**

- Standing sources are already separated (instance / ceremony / Gora).
- Keep officer UI breakdown by source — transparency is the anti-toxicity tool, not PR ratios.
- Do **not** introduce GP-like spend currency for titles in V1.

### 4. Caps beat cryptography

Self-reported SV will always be editable. Spec correctly rejects crypto anti-cheat. Caps + implausible-suggestion laughter + officer reject is the right Classic-addon stance (§6.3).

**Practical officer heuristics (document in Officer tab later):**

- Suggestion with 100% instance points and zero combat events → reject / adjust.
- Same two players trading Gora wins all week → cap already should choke; else manual.
- Sudden jump past threshold with empty event log → treat as comedy confession, not “proof.”

## Incentive polarity (what the economy teaches)

| If you reward… | Players will… |
|----------------|---------------|
| Win-only Gora | Dodge challenges; ladder dies |
| Loss + draw participation | Show up for spectacle |
| Pure time in instance | AFK at entrance |
| Combat-gated buckets + completion | Actually run content |
| Unlimited drip | Multi-box / marathon farm |
| Daily caps | Play a guild night, then stop |
| Auto-promote on points | Edit SV / spam farm |
| Officer suggestion gate | Perform for humans |

## Anti-patterns to reject

1. **Points for everything** (“pointsification”) — extrinsic noise that crowds out comedy ([XQA: gamification beyond PBL](https://xqa.io/blog/gamification-in-ux-design-2026)).
2. **Streak guilt** for logging in daily — wrong tone for a church of beef.
3. **Hidden multipliers** officers can grant without audit — Classic DKP toxicity narratives center favoritism ([Blizzard forum: DKP and EPGP systems](https://us.forums.blizzard.com/en/wow/t/dkp-and-epgp-systems/1791081)).
4. **Open-world / city co-play scoring** — unpoliceable farm.
5. **Cross-realm shared standing** — out of scope; each guild is its own economy.

## Tuning order (playtest)

1. First-night → Cooked Beef pacing (spec rule).
2. Daily instance cap so a single marathon cannot skip Knight→Lord.
3. Same-opponent Gora DR.
4. Only then consider season soft-reset ([season-resets.md](season-resets.md)).
