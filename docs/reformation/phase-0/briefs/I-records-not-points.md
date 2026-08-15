# Phase 0 Lane I — Records, not points

Read first: `docs/reformation/phase-0/TEN_LAWS.md`, Bible §4.6, §4.9, §10.9, §15, §17.

## Mission

Create `.cursor/rules/records-not-points.mdc` so Core/Data work cannot rebuild standing, Grant(), thresholds, or activity leaderboards (Audit V1, V2).

## Bible sections you implement

§4.6, §4.9, §5 (ranks are relationships, not thresholds), §10.9, §15, §17. Laws 1, 2, 9.

## Exclusive file

- Create: `.cursor/rules/records-not-points.mdc`
- Report: `docs/reformation/phase-0/reports/I-records-not-points.md`

## Frontmatter

Description: ban points/XP/thresholds; records are stories; ranks listed. Globs for Core/Data/UI. `alwaysApply: false`.

## Must include

- **Banned:** points, XP, currencies, dailies, streaks-as-economy, thresholds, engagement scores, contribution numbers, hours/combat-minutes, activity leaderboards, Grant/standing/suggestion machinery.
- Ranks exactly: Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher (raid-team role, display-only this phase), Beef Council. No thresholds. No Beef Prophet. The Pope is not a rank.
- How ranks are actually attained (one line each, from §5 / §10.4): Fresh = recruitment; Cooked = outside addon (Discord) reflected when Council promotes; Knight = ceremony (KNIGHT THIS BEEF); Lord = fair sanctioned Gora + Pope judgment (attainable); Butcher = human raid-team designation; Council = human judgment, prunable.
- Records are stories (W/L, streaks as *narrative record*, defenses, head-to-heads, rulings). No meters, duration stats, per-class win rates.
- Records Book = parchment superlatives (§10.9 list). No sortable ranked ladder.
- Honorifics: Pope-granted, cosmetic text, no mechanical benefits.
- Recognition of quiet Knights is non-mechanical (visibility + human recognition). No service scores.
- Different contributions stay distinguishable — no single number may collapse them.

## Do not

- Rebalance a points system
- `git commit`
- Edit other files except the report

## Report contract

Status, sections cited, grep-oriented ban list (standing, Grant, threshold, suggestion, elo, leaderboard, prophet) present in the rule.
