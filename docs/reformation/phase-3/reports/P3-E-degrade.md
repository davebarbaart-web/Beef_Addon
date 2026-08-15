# Phase 3 Lane E — Pope-disconnect degrade (not a sixth state)

**Status:** DONE

**Cited:** Ten Laws 4, 5, 6; Bible §20.3; brief `docs/reformation/phase-3/briefs/P3-E-degrade.md`; `.cursor/rules/ceremony-runtime.mdc` (Disconnect). Lane A is signed.

Harness-driven degrade flag only. No TOC / bootstrap / `tests/run.lua` / BeefNet / Codec / Snapshot / Sender / UI / DB edits. Not a sixth state. No `holdSeconds`. No auto-EndEvent. No toast. No second Quiet notice (`_WarnVersion` stays in BeefNet). No congregation takeover. Does not write `ChurchOfBeefDB`. No `CreateFrame`. No commit. `OPEN_QUESTIONS.md` unchanged. Hold duration stays unspecified.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_runtime.lua` | Existing Lane A cases kept. `awaitingPope` allowed on Snapshot when set. Degrade cases added. |
| `addon/ChurchOfBeef/Core/Runtime.lua` | `MarkPopeLost` / `ClearPopeLost`. Snapshot / Restore round-trip `awaitingPope` if set. |
| `docs/reformation/phase-3/reports/P3-E-degrade.md` | This file |

## Degrade

§20.3: on Pope disconnect, clients hold last state, then degrade to a quiet-leaning **"awaiting the Pope"** presentation. That is **Event Mode degraded** — not Quiet chrome, not a toast/pip, not `AWAITING_POPE`. No client promotes itself.

`MarkPopeLost()` while not QUIET sets `awaitingPope = true`. State / rite / subjects / sequence / event id do not change. From QUIET it returns `nil, err` and leaves the object unchanged.

`ClearPopeLost()` clears the flag (Pope resumed). State unchanged. Sequence unchanged. Idempotent when unset.

The flag is present on Snapshot only when true. Restore keeps it only when `awaitingPope == true` and state is not QUIET. QUIET Restore drops the flag. Non-true values are not set. `AWAITING_POPE` remains an illegal state.

Pope verbs still run (the Pope client is the writer). They do not clear the flag except `EndEvent` → QUIET, which cannot carry Event Mode degraded. No second writer. No self-promotion API.

## API

| Method | Role |
|--------|------|
| `StartEvent()` | QUIET → ASSEMBLY. Extra args ignored. |
| `OpenRite(type, subjects?)` | ASSEMBLY → RITE. Closed types only. Optional `{ candidate, fighters }`. |
| `CloseRite()` | RITE → CONSEQUENCE. Keeps rite type and subjects. |
| `Continue()` | CONSEQUENCE → ASSEMBLY. Clears rite type and subjects. |
| `EndEvent()` | ASSEMBLY or CONSEQUENCE → QUIET. Clears rite type, subjects, and `awaitingPope`. |
| `MarkPopeLost()` | While not QUIET, set `awaitingPope`. Not a transition. |
| `ClearPopeLost()` | Clear `awaitingPope`. Not a transition. |
| `Snapshot()` | Copy of the event object (`awaitingPope` only if set) |
| `Restore(snap)` | Replace live state from a Bible-shaped object; round-trips `awaitingPope` if set |
| `ResetForTests()` | No-op unless `COB._IN_TEST` |

Getters and verb successes return copies. `MarkPopeLost` / `ClearPopeLost` return a copy on success. Expected failures are `nil, err`. Restore success is `true`.

## Verification

- Isolated suite (`Core/Common.lua` + `Core/Runtime.lua`): **648 passed, 0 failed**.
- Lua 5.1. No `CreateFrame`. No `dofile` of Ranks / Store / Archive / Recognition / DB / UI / Net / Codec / Snapshot / Sender.
- `lua tests/test_runtime.lua` exits 0.
- Existing Lane A cases remain green. Degrade cases cover ASSEMBLY / RITE / CONSEQUENCE, QUIET refuse, Clear, Snapshot / Restore round-trip, no auto-EndEvent, no holdSeconds, no toast / `_WarnVersion` / Promote.

## Leftovers (other lanes — not fixed)

- **Presentation:** congregation theater that reads `awaitingPope` and paints “awaiting the Pope.” This lane is the flag only.
- **Net:** who calls `MarkPopeLost` / `ClearPopeLost` on disconnect / resume. BeefNet version-mismatch Quiet notice is unchanged. Do not add a second notice here.
- **Persist:** Snapshot into `ChurchOfBeefDB` so the Pope console resumes after disconnect (§20.3) remains later.
- Hold duration stays unspecified. §20.4 five / thirty is a chaos-test quality bar, not a timer.

## Concerns

- `awaitingPope` is a degrade flag on the event object, not a Bible §20.2 broadcast field and not a sixth state. Restore of extras still drops `holdTimeout` / `holdSeconds` / narration / attendance.
- Pope verbs remain ungated (same leftover as Lane A / Store). This lane does not add a congregation lock. Later Net/UI must not treat `MarkPopeLost` as a promotion.
- `OPEN_QUESTIONS.md` was not edited. Hold duration remains unspecified.
