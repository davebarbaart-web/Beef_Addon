# Phase 1 Sweep K — DB test cut

Read: `docs/reformation/phase-0/TEN_LAWS.md`, `GATE1_DESIGN_LEAD_DIRECTIVE.md` §2 (DB test cut must not become the Pope store).

## Exclusive files

- `tests/test_db.lua`
- Report: `docs/reformation/phase-1/reports/P1-K-db-tests.md`

**Do not** edit `Core/DB.lua` unless a one-line comment is required. Prefer tests only. Do not edit TOC.

## Mission

Stop `dofile`ing deleted `Ladder.lua` / `Scoring.lua`. Assert what ships: `{ version, ui }` defaults, Init/Save without standing/suggestion/scoring schema. Leftover SV keys on an old table may survive (Law 7) — do not require them, do not wipe them as product.

Do **not** invent the Phase 2 Pope store, archive, or account-level SV switch.

Isolated suite must pass.

## Do not git commit.
