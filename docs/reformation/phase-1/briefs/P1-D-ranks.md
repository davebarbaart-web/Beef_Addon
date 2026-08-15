# Phase 1 Lane D — Six-rank canon, no thresholds

Read: `docs/reformation/phase-0/TEN_LAWS.md`, Bible §5, Law 9. Current `addon/ChurchOfBeef/Data/Ranks.lua`.

## Exclusive files

- Rewrite: `addon/ChurchOfBeef/Data/Ranks.lua`
- Rewrite: `tests/test_ranks.lua` (must pass; no threshold / Prophet / OfficerRankIndexMax tests)
- Report: `docs/reformation/phase-1/reports/P1-D-ranks.md`

**Do not** edit TOC or other modules.

## Must

Ranks **exactly** (ids 1–6, no 7): Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council.

- No `threshold`. No `kind == "points"`. No Beef Prophet. No `ProphetUnique`. No `OfficerRankIndexMax`. No `NeedsRite`. No `IsPointDriven`. No `Threshold`.
- Keep `Title(id)` and a list/by-id table.
- Butcher: comment that it is a raid-team role designation, display-only this phase.
- **Guild-rank display-vs-truth stub (§5):** `ChurchRankIdForGuildIndex` must **not** treat GM as Prophet or encode the old 0→7 map. Stub: return `nil` (Church store is truth; roster index is display only). Do not invent a new numeric mapping.
- Do **not** invent `CouncilSeats` as a number (Bible does not give one). Omit it.

Keep `ChurchOfBeef` / `COB` bootstrap style (`lua-cob-modules.mdc`).

Run `lua tests/run.lua` only if you can without depending on deleted Scoring/Ladder — if the runner still lists dead suites, do not edit `run.lua`; note it.

## Do not git commit.
