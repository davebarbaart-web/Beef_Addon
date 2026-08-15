# Phase 3 Lane A — Ceremony runtime (Core state machine)

**Status:** DONE

**Cited:** Ten Laws 4, 5, 6; Bible §20.1–20.3, §4.11; brief `docs/reformation/phase-3/briefs/P3-A-runtime.md`; `.cursor/rules/ceremony-runtime.mdc`.

Pope-owned in-memory state machine only. No TOC / bootstrap / `tests/run.lua` / Store / Archive / Recognition / BeefNet / UI edits. No auto-advance, narration, hold-timeout, “awaiting the Pope,” Director Console, Decree, Grant, attendance, or Net send. Does not write `ChurchOfBeefDB`. No `CreateFrame`. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_runtime.lua` | Created first. Isolated suite: Common + Runtime. |
| `addon/ChurchOfBeef/Core/Runtime.lua` | Created after the suite. Pope verbs and Snapshot / Restore. |
| `docs/reformation/phase-3/reports/P3-A-runtime.md` | This file |

## Machine

States, named only: **QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET**.

StartEvent is one action with zero configuration (§4.11). OpenRite accepts only `Knighting`, `Gora`, `Confession`, `Proclamation`. Illegal transitions return `nil, err` and leave the event object unchanged. Sequence increments only on success. Nothing auto-declares, auto-continues, or narrates (Law 4).

Event object fields (Bible §20.2 only): `eventId`, `state`, `riteType` (or nil), `subjects` (`candidate` / `fighters` — ids or nil), `sequence`. Monotonic integer event ids; sequence is global and keeps incrementing across events. Snapshot / Restore copy that object so the Pope can resume after disconnect (§20.3). Extra snapshot keys are ignored and not kept. Persist into SV is an integrator / later lane.

## API

| Method | Role |
|--------|------|
| `StartEvent()` | QUIET → ASSEMBLY. Extra args ignored. |
| `OpenRite(type, subjects?)` | ASSEMBLY → RITE. Closed types only. Optional `{ candidate, fighters }`. |
| `CloseRite()` | RITE → CONSEQUENCE. Keeps rite type and subjects. |
| `Continue()` | CONSEQUENCE → ASSEMBLY. Clears rite type and subjects. |
| `EndEvent()` | ASSEMBLY or CONSEQUENCE → QUIET. Keeps event id; clears rite type and subjects. |
| `Snapshot()` | Copy of the event object |
| `Restore(snap)` | Replace live state from a Bible-shaped object |
| `ResetForTests()` | No-op unless `COB._IN_TEST` |

Getters and verb successes return copies. Expected failures are `nil, err`. Restore success is `true`.

## Verification

- Isolated suite (`Core/Common.lua` + `Core/Runtime.lua`): **492 passed, 0 failed**.
- Lua 5.1. No `CreateFrame`. No `dofile` of Ranks / Store / Archive / Recognition / DB / UI / Net.
- `lua tests/test_runtime.lua` exits 0.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `Core/Runtime.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_runtime` to `tests/run.lua`. Full harness will report the new suite as unlisted until then.
- **Lane B:** encode/decode of this event object. This lane does not send or receive.
- **Later:** persist Snapshot into `ChurchOfBeefDB`, Director Console verbs, congregation theater, whisper snapshot request, registered-Pope list (#8).
- Subjects are ids only. This module does not look up Store rows.

## Concerns

- EndEvent from RITE is illegal; the Pope must CloseRite (CONSEQUENCE) or the rite stays open. That is the §20.1 skeleton, not auto-advance.
- Sequence does not reset on a new event. Clients that reconcile “latest Pope sequence” can keep a single counter.
- `OPEN_QUESTIONS.md` was not edited. Hold duration, snapshot wire schema, and opcode strings remain unspecified.
