# Phase 2 Lane D — Account SV hook / demo-key ignore

**Status:** DONE

**Cited:** Ten Laws 7; Bible §12.1, §13.1; Audit V6; handoff Phase 2 migration sentence; GATE1 §3d; brief `docs/reformation/phase-2/briefs/P2-D-migration.md`.

Empty `store` hook only. No human / character / Gora APIs. Leftover `ladder` / `scoring` / `suggestions` are not imported and not wiped. TOC / bootstrap / `tests/run.lua` / Store / UI / Net not edited. No commit. Player `WTF/` not touched. `OPEN_QUESTIONS.md` unchanged.

## Files changed

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/Core/DB.lua` | `SCHEMA_VERSION` 4→5. Fresh SV is `{ version, ui, store }`. `applyDefaults` ensures `store = {}` if missing. Leftover demo keys are left in place and are not copied into `store`. |
| `tests/test_db.lua` | Asserts schema 5, empty store hook, leftover survival + no import, dirty demo Init/Save without error, unknown-key merge, and no humans/characters/Gora APIs on `DB`. |
| `docs/reformation/phase-2/reports/P2-D-migration.md` | This file |

## Schema

- **`SCHEMA_VERSION`:** 5 (bumped because the `store` hook was added).
- Fresh Init: `{ version = 5, ui, store = {} }`.
- `store` is an empty table hook. No humans, characters, ranks, ceremony, Gora, archive, or notebook rows.

## Verification

- Isolated suite (`tests/test_db.lua` + `Core/DB.lua` only): **109 passed, 0 failed**.
- Dirty demo / per-character shapes (empty table, string version, non-table `ui`, leftover `ladder` / `scoring` / `suggestions`) Init and Save without error.
- Leftover nested payload survives Init and Save and is not copied into `store`.
- Unknown root / `ui` / `store` keys survive. Downgrade keeps a higher version stamp.

## Concerns

- Integrator already flipped TOC to `## SavedVariables: ChurchOfBeefDB`. This lane did not edit TOC.
- Existing player `ChurchOfBeefDB` may still contain leftover `ladder` / `scoring` / `suggestions`. They remain on disk and are not Church history. Lane A owns store rows.
- Full harness color is integrator-owned. This lane only required the isolated DB suite. `tests/run.lua` was not edited.
