# Phase 1 Sweep K — DB test cut

**Status:** DONE

**Cited:** Ten Laws 1, 7; Bible §12, §13.1; GATE1 §2 (DB test cut must not become the Pope store); brief `docs/reformation/phase-1/briefs/P1-K-db-tests.md`.

No Pope store, archive, or account-level SV switch. `Core/DB.lua` unread for edits (already `{ version, ui }` after Lane G). TOC / bootstrap / `tests/run.lua` not edited. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files changed

| Path | What changed |
|------|----------------|
| `tests/test_db.lua` | Stopped `dofile` of deleted `Ladder.lua` / `Scoring.lua`. Asserts fresh `{ version, ui }` defaults, Init/Save, leftover-key survival, and unknown-key merge. No standing / suggestion / scoring schema as product. |
| `docs/reformation/phase-1/reports/P1-K-db-tests.md` | This file |

## Verification

- Isolated suite (`tests/test_db.lua` + `Core/DB.lua` only): **36 passed, 0 failed**.
- No `dofile` of `Ladder.lua` or `Scoring.lua`.
- Fresh Init is `{ version = 4, ui }` only. Leftover `ladder` / `scoring` keys on an old table survive Init and are not created when absent.

## Concerns

- TOC still has `## SavedVariablesPerCharacter: ChurchOfBeefDB`. Account-level SV is Phase 2; this lane did not switch it.
- Existing player `ChurchOfBeefDB` may still contain leftover `ladder` / `scoring` tables. Tests assert they are not wiped (Law 7). Phase 2 migration owns that SV.
- Full harness color is integrator-owned. This lane only required the isolated DB suite.
