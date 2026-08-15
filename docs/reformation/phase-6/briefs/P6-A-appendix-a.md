# Phase 6 Lane A — Appendix A validation sheets (items 1–4)

Read: Bible Appendix A (all 13 items); §10.7 (HUD fallback); §13.1 / §13.4 (sender); §8 / §5 (roster); `docs/design/OPEN_QUESTIONS.md` (#2, #8). Gate 5 is closed. Handoff Phase 6: every Appendix A item becomes a task with a written result in `docs/validation/`. Items 1–4 are load-bearing — validate in-game early, not last.

## Exclusive files

- `docs/validation/README.md` (create)
- `docs/validation/A01-live-health.md` (create)
- `docs/validation/A02-duel-messages.md` (create)
- `docs/validation/A03-sender-integrity.md` (create)
- `docs/validation/A04-guild-roster.md` (create)
- Report: `docs/reformation/phase-6/reports/P6-A-appendix-a.md`

**Do not** edit addon Lua, TOC, tests, `OPEN_QUESTIONS.md`, `docs/phases/**`, or items 5–13 sheets (later lane). Do not invent in-game results.

## Mission

Create the validation ledger. Each item-1–4 sheet must name, from the Bible only:

- Dependent feature
- Bible fallback if the API fails
- What to do on the live Anniversary TBC client (`Interface: 20506`)
- Owner: **David** (agents cannot close an in-game item)
- **Result: NOT RUN**

Do not resolve OPEN_QUESTIONS #2 (HUD final form waits on A01). Do not treat the coded no-health HUD as a validation pass. Do not invent auto-propose from duel chat (A02 fallback is already the shipped manual verdict). Do not invent a 40-client proof (A03). Do not invent a guild-rank map or code `GuildPromote` (A04). Do not code `#8`.

`README.md` lists all 13 Appendix A items with status. Items 5–13: title + "sheet later" only.

## Do not git commit.
