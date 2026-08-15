# Phase 0 Lane D — Gora sanction domain rule

Read first: `docs/reformation/phase-0/TEN_LAWS.md` and Bible §10 in full.

## Mission

Create `.cursor/rules/gora-sanction.mdc` so Gora work cannot rebuild typed self-report + points (Audit V4).

## Bible sections you implement

§10.1–10.10 (loop, petition hygiene, rules-as-Pope, Lord milestone, matchmaking, sanction/cards/favor, HUD, adjudication, Records Book, permanence). Law 8.

## Exclusive file

- Create: `.cursor/rules/gora-sanction.mdc`
- Report: `docs/reformation/phase-0/reports/D-gora-sanction.md`

## Frontmatter

```yaml
---
description: Beef Gora is a Pope-sanctioned unmodified duel — petitions, favor, verdicts, no ratings
globs: "**/Core/**/*.lua,**/UI/**/*.lua,**/Net/**/*.lua"
alwaysApply: false
---
```

If YAML globs in this repo are a list, match the style of existing rules (multi-line `globs:` list).

## Must include (actionable bans + required verbs)

- A Gora exists only after **SANCTION BEEF GORA**. Combat is an unmodified WoW duel. No ELO/MMR, no analytics, no betting, no typed-result “Gora.”
- Loop: Petition → assisted matchmaking → Sanction → mute cards → favor → duel → Pope ratifies → records → possible elevation.
- Petition hygiene: expiry, present-and-alive, one-tap dismiss, soft re-petition cooldown, optional named opponent (official only when the Pope announces).
- Ruleset **is** the Pope. Optional one-line stipulation at sanction. No rules engine / picker / stipulations database.
- Matchmaking: level proximity (~2 as guidance the Pope may waive), head-to-head, class display. Software recommends; Pope decides.
- Cards are mute. No generated flavor. Favor is pick-a-side only; split bar; Pope always sees it; congregation display is a Pope toggle. No favor scores/streaks.
- HUD: Event Mode only; defined no-live-health fallback (§10.7). Do not invent a health hack.
- Verdicts: software **proposes**; Pope **DECLARE VICTOR / COWARDICE RECORDED / VOID / free ruling**.
- Elevation: Knight who wins a fair sanctioned match (Pope’s judgment) — attainable milestone. No demotion, no decay, no beating-a-sitting-Lord gate.
- Records are stories; Records Book is superlatives, never a ranked ladder.

## Do not invent

HUD health implementation, exact petition TTL numbers, or extra outcome types. If a number is not in the Bible, do not pick one — OPEN_QUESTIONS or omit.

## Do not

- Edit other files except the report
- `git commit`

## Report contract

Status, sections cited, confirmation that ELO/points/self-report Gora are banned in the rule text.
