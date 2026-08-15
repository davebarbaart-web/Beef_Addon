# Phase 1 Lane D — Six-rank canon, no thresholds

**Status:** DONE

**Cited:** Ten Laws 1, 9; Bible §5; brief `docs/reformation/phase-1/briefs/P1-D-ranks.md`.

Six ranks, ids 1–6. No thresholds, no points `kind`, no Beef Prophet, no `CouncilSeats`. `ChurchRankIdForGuildIndex` stubs to `nil` (Church store is truth; roster index is display only). No TOC / `tests/run.lua` edits. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

- `addon/ChurchOfBeef/Data/Ranks.lua` — rewrite
- `tests/test_ranks.lua` — rewrite
- `docs/reformation/phase-1/reports/P1-D-ranks.md` — this report

## Canon table

| id | title |
|----|-------|
| 1 | Fresh Beef |
| 2 | Cooked Beef |
| 3 | Beef Knight |
| 4 | Beef Lord |
| 5 | Beef Butcher (raid-team role; display-only this phase — comment only) |
| 6 | Beef Council |

Kept: `List`, `ById`, `Title(id)` (unknown id → `"Unknown"`), `ChurchRankIdForGuildIndex` (always `nil`).

Removed: `threshold`, `kind`, `Threshold`, `IsPointDriven`, `NeedsRite`, `ProphetUnique`, `OfficerRankIndexMax`, `CouncilSeats`, id 7 / Beef Prophet.

## Verification

Isolated `tests/test_ranks.lua`: 49 passed, 0 failed.

`lua tests/run.lua`: **not green** (133 passed, 18 failed). Runner still lists dead suites from other lanes (`test_ladder`, `test_standing_ui`, `test_instance`, `test_quest` missing; several suites `dofile` deleted `Core/Ladder.lua`). Did not edit `tests/run.lua`.

## Leftover callers (not fixed)

Integrator / other lanes:

- `Core/Officer.lua` — `OfficerRankIndexMax` gate; `IsOfficerIndex` now fails closed
- `Core/Roster.lua` — still maps via `ChurchRankIdForGuildIndex`; every id is now `nil`
- `UI/LadderTab.lua` — `kind` / `CouncilSeats` / `ProphetUnique`
- `UI/OfficerTab.lua` — "Beef Prophet" footer copy

Tests that still encode the old 0→7 / Prophet / officer-max product:

- `tests/test_roster.lua`
- `tests/test_officer.lua`
- `tests/test_officer_ui.lua`
- `tests/test_ui.lua`

## Concerns

- Bible §5 names a later display-vs-truth reconcile; this lane stubs the map to `nil` and does not invent slot numbers. Phase 5 owns reconciliation.
- `Officer:IsOfficerIndex` is now always false until that module is reworked. Out of this lane.
