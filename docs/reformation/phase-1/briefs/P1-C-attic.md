# Phase 1 Lane C — Attic Instance and Quest

Read: `docs/reformation/phase-0/TEN_LAWS.md`. Audit §4 (shelve). Bible §14.3 later-phase Expeditions.

## Exclusive files

- Move (do not delete): `addon/ChurchOfBeef/Core/Instance.lua` → `attic/Core/Instance.lua`
- Move: `addon/ChurchOfBeef/Core/Quest.lua` → `attic/Core/Quest.lua`
- Delete or move to `attic/tests/` their scoring-wired tests: `tests/test_instance.lua`, `tests/test_quest.lua` (prefer move to attic if they test sensing; delete if they only test grants)
- Report: `docs/reformation/phase-1/reports/P1-C-attic.md`

**Do not** edit TOC / bootstrap / `tests/run.lua`. Do not ship attic in the TOC.

## Mission

Scoring wiring dies. Sensing primitives are a head start on later Expeditions — attic, never shipped.

Write `attic/README.md` (one short paragraph): not shipped; Expedition witnessing later; do not load from TOC.

## Do not git commit.
