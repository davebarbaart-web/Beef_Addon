# B15-INT — Batch 15 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20.3 / §8 / §18.5. B15-A/B/C/D Spec PASS.

Successful `Knighting:Enqueue` / `Skip` / `Insert` / `KnightThisBeef` / `ElevateToLord` now `sendState()`. Failed verbs do not. Candidate overlay rules unchanged. Last pair still stays off post-Continue ASSEMBLY. Console harness pin no longer expects KNIGHT THIS BEEF to demote a Lord. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_inputs.lua         # 386 passed, 0 failed
lua tests/test_records.lua        # 420 passed, 0 failed
lua tests/test_ui.lua             # 368 passed, 0 failed
lua tests/test_knighting.lua      # 394 passed, 0 failed
lua tests/test_console.lua        # 1334 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 11055 passed, 0 failed
```

TOC `## Interface: 20506`. `EnableMouseWheel` is SimpleScriptRegionAPI. Persist uses HUD `GetPoint` / `SetPoint`. No `PlaySound` on ESC / show / hide.

## Concerns

- Pope writer Runtime still stays empty until `OpenRite` (overlay is encode-only).
- `ElevateToLord` can still write Lord on Butcher / Council.
- Inputs / dock persist are harness-stubbed; real `StopMovingOrSizing` may rewrite the point.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
