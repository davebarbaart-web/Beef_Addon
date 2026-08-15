# Phase 1 Lane G — Cut Scoring/Ladder calls so Core still loads

Read: `docs/reformation/phase-0/TEN_LAWS.md`. Audit V4, V5.

## Exclusive files

- `addon/ChurchOfBeef/Core/Gora.lua` — remove Scoring/Ladder/Grant/points. Do **not** rebuild sanctioned-duel Gora (Phase 4). A stub that does not award points is OK.
- `addon/ChurchOfBeef/Core/Ceremony.lua` — remove attendance-credit / Grant. Do not rebuild ceremony runtime (Phase 3). Stub OK.
- `addon/ChurchOfBeef/Core/DB.lua` — remove standing/suggestion schema requirements that would error on init. Do not invent the Phase 2 Pope store. Account-level SV is Phase 2; do not switch TOC this lane.
- Report: `docs/reformation/phase-1/reports/P1-G-core-cut.md`

**Do not** edit Roster/Officer except if a one-line Scoring call would crash load — then only remove that call. Prefer not to touch them.

**Do not** edit TOC, bootstrap, `tests/run.lua`.

If `tests/test_gora_ceremony.lua` only tests points, delete it (this lane owns that test file). If it tests pair keys, keep pair-key tests only.

## Do not git commit.
