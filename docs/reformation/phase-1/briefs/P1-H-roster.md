# Phase 1 Sweep H — Roster cut

Read: `docs/reformation/phase-0/TEN_LAWS.md`, `docs/reformation/phase-1/GATE1_DESIGN_LEAD_DIRECTIVE.md` §2–3.

## Exclusive files

- `addon/ChurchOfBeef/Core/Roster.lua`
- `tests/test_roster.lua`
- Report: `docs/reformation/phase-1/reports/P1-H-roster.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, MainFrame, Officer, BeefNet, DB.

## Mission

Keep guild-roster **sensing** (names, `guildRankIndex`, completeness, local-player seed). Members stay even when `ChurchRankIdForGuildIndex` is nil — do not invent a Church-id map.

Cut dead engines: `SweepDeparted`, `ClearSatisfiedSuggestions`, Ladder standing merge. **Delete `GetLadderView`** (ClassColorCode is the UI leftovers lane). No standing field. No history prune.

Rewrite `test_roster.lua` to the sensing contract only. Do not `dofile` Ladder/Scoring. Isolated suite must pass.

## Do not invent

Display-vs-truth reconcile, Presence desk, Church store, Prophet, thresholds.

## Do not git commit.
