# Phase 4 Lane G — Records Book (superlatives, not a ladder)

Read: Ten Laws 1, 6, 10; Bible §10.9, §14.2; `.cursor/rules/records-not-points.mdc`; `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`. OPEN_QUESTIONS #3 is a veto list — ship the Bible MVP names; do not add a "#1 rating."

## Exclusive files

- `addon/ChurchOfBeef/UI/RecordsBook.lua` (create)
- `tests/test_records.lua` (create)
- Report: `docs/reformation/phase-4/reports/P4-G-records.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, MainFrame, Console, Hud, Store, Net. **Do not** add a new slash.

## Mission

Test-first. Isolated suite with `wow_ui_stub` + Common + Ranks + Store + RecordsBook. Standalone wrap.

**Mode:** player-opened Quiet identity/history (§14.2). Theatrical (Law 10 ecclesiastical). Not a sortable ranked ladder. The UI never tells jokes. No points, standing, or Grant.

Bible MVP pages (display from Store Gora records; do not invent extra categories):

- Most Sanctioned Victories
- Longest Streak (sanctioned-Gora W/L streak only)
- Most Successful Defenses — **omit or show empty** until a derived defense stat exists (OPEN_QUESTIONS #9; do not invent an increment)
- The Iron Chin (most Goras fought)
- Greatest Rivalry (most-fought pairing + running score)
- Famous Upsets — **Pope-flagged only** (`famousUpset` on Store results). Never compute.
- The Undefeated
- The Glorious Martyr (most losses)
- Tournament Champions — empty until tournaments exist. Do not invent a tournament engine.

`Toggle` / `Show` / `Hide` only. No feed. No auto-open. No sound.

## Do not git commit.
