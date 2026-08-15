# Phase 2 Lane D — Account SV hook / demo-key ignore

Read: Ten Laws 7; Bible §12.1, §13.1; Audit V6; handoff Phase 2 migration sentence; `GATE1_DESIGN_LEAD_DIRECTIVE.md` §3d (this is the phase that may flip SV scope).

## Exclusive files

- `addon/ChurchOfBeef/Core/DB.lua`
- `tests/test_db.lua`
- Report: `docs/reformation/phase-2/reports/P2-D-migration.md`

**Do not** edit TOC (integrator flips `## SavedVariablesPerCharacter` → `## SavedVariables: ChurchOfBeefDB`). Do not edit bootstrap, `tests/run.lua`, Store, UI.

## Mission

Test-first against current `DB.lua`, then change it.

Handoff: old per-character DB on first load — **preserve nothing product-side, but don't error.**

That means:

- Keep `{ version, ui }` working (window/minimap prefs).
- Ensure a `store` table exists as `{}` if missing — do **not** invent human/character schema here (Lane A).
- Leftover `ladder` / `scoring` / `suggestions` keys: **do not read as product**, do not migrate into `store`, do not wipe (Law 7 never-delete of unknown keys; they are not Church history and they are not imported).
- Init/Save must not error on a dirty demo SV.
- Bump `SCHEMA_VERSION` only if you add the `store` hook.

Do not implement Store APIs. Do not implement Archive. Do not touch player `WTF/`.

Isolated `test_db.lua` must pass. Full harness may still be 489 until integrator lists new suites — do not add suites to `run.lua`.

## Do not invent

Pope store rows, Rite, Archive, registered Pope, account-id linker.

## Do not git commit.
