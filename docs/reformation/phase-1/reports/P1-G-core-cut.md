# Phase 1 Lane G — Cut Scoring/Ladder calls so Core still loads

**Status:** DONE

**Cited:** Ten Laws 1, 4, 8; Bible §4.6, §4.9, §10, §20; Audit V4, V5; brief `docs/reformation/phase-1/briefs/P1-G-core-cut.md`.

No sanctioned-Gora rebuild (Phase 4). No ceremony-runtime rebuild (Phase 3). No Pope store invented (Phase 2). TOC / bootstrap / `tests/run.lua` not edited. Roster / Officer not edited. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files changed

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/Core/Gora.lua` | Removed `GrantGora`, Scoring hard-fail, `SetRiteFlag` / `goraLordWin`, pair-pay cooldown (`paid`, `ResultCooldown`, `CooldownRemaining`). Kept pair-key challenge notes. `RecordResult` is a no-points stub that only clears a pending pair. |
| `addon/ChurchOfBeef/Core/Ceremony.lua` | Removed `GrantCeremony`, attendance sampling / Mark, attendee points, `SetRiteFlag` / knighting-on-close. Session stub: Start / Close / Cancel / IsActive only. |
| `addon/ChurchOfBeef/Core/DB.lua` | Init no longer requires `ladder.records`, `ladder.suggestions`, or `scoring`. No `ImportState` / `ExportState` into deleted modules. Fresh SV is `{ version, ui }` only. Leftover standing/scoring keys on an existing SV are left in place. |
| `tests/test_gora_ceremony.lua` | Points / Grant / Ladder / ceremony-credit / Standing-tab coverage removed. Pair-key tests only (direction, case/realm fold, cancel, expiry). |
| `docs/reformation/phase-1/reports/P1-G-core-cut.md` | This file |

## Verification

- Pair-key suite (Common + `test_gora_ceremony.lua`): 16 assertions, all pass. The suite also ran clean inside `lua tests/run.lua`.
- DB Init / Save with Scoring and Ladder absent: fresh SV has no ladder/scoring; old leftover keys survive; Save returns true.
- Full harness is still red (`150 passed, 17 failed`) for integrator-owned leftovers (missing `test_ladder` / attic-moved suites; other suites still `dofile` deleted Ladder). Not fixed here.

## Concerns

- `Gora:RecordResult` remains as a typed-result stub (no points). Audit V4 bans that model as product; Phase 4 must replace it, not grow it.
- Ceremony Start/Close still officer-gated session flags. That is not attendance credit, but it is also not the §20 runtime.
- `tests/test_db.lua` still asserts standing/suggestion/scoring round-trip and `dofile`s deleted modules. Out of this lane.
- TOC still lists deleted `Core/Scoring.lua` and `Core/Ladder.lua`. In-game load will fail until the integrator lane edits the TOC. Out of this lane.
- Existing player `ChurchOfBeefDB` may still contain leftover `ladder` / `scoring` tables. This lane does not wipe them (Law 7 / never-delete). Phase 2 migration owns that SV.
