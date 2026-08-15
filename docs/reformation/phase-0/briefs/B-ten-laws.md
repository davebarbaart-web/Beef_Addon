# Phase 0 Lane B — Ten Laws always-on rule

Read first: `docs/reformation/phase-0/TEN_LAWS.md` and Bible sections cited below.

## Mission

Create `.cursor/rules/ten-laws.mdc` so every future agent session carries the Ten Laws. This is workspace law, not a blog post.

## Bible sections you implement

Handoff §2 (verbatim intent) plus Bible §4.2, §4.4, §4.6, §4.8, §4.9, §5, §6, §10, §12, §13.1, §17, §19.1, §19.3.

## Exclusive file

- Create: `.cursor/rules/ten-laws.mdc`
- Report: `docs/reformation/phase-0/reports/B-ten-laws.md`

## Frontmatter

```yaml
---
description: Ten Laws of the Reformation — banned economies, Pope sovereignty, Quiet Mode, star topology
alwaysApply: true
---
```

## Content requirements

- Open with: product law is `docs/design/Game_Design_Bible_v1.1.1.md`; on conflict the Bible wins.
- Numbered Ten Laws, each with the Bible section cite from `TEN_LAWS.md`.
- Keep the hard-safety paragraph (no automation / injection / protected-action bypass; Lua/XML; Interface 20506; Classic+ guarded reads).
- One short “agents must not invent product answers” line pointing at `docs/design/OPEN_QUESTIONS.md`.
- Concise (create-rule skill: prefer under ~80 lines). Actionable. No jokes in the rule text (Law 10).
- Do **not** add thresholds, points, Prophet, or officer-as-ritualist language even as “legacy.”

## Do not

- Edit any other file except the report
- `git commit`
- Soften a ban (“no points except…”)

## Report contract

Status, file path, sections cited, any OPEN_QUESTIONS appended.
