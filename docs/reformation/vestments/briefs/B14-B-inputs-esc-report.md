# B14-B — Inputs confess box ESC ClearFocus (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.1 / §18.5 (congregation input; inputs never trigger public theater); Law 6 / §19.1 (Event chrome; Quiet hide is Runtime); Law 10 / §19.3 (Inputs stay stock); wiki "Make frames closable with the Escape key" (focused EditBoxes swallow ESC — `OnEscapePressed`); Anniversary `SimpleEditBoxAPI` (`ClearFocus`, `SetMultiLine`); brief `docs/reformation/vestments/briefs/B14-B-inputs-esc.md`. No Pope-name lookup. No SUMMON. No `PlaySound`. Do not register Inputs on `UISpecialFrames`.

On the confess box, `SetMultiLine(true)` and `SetScript("OnEscapePressed")` are type-guarded. The handler type-guards `ClearFocus` and does not Hide the Inputs panel. `SetAutoFocus(false)` stays. WIDTH 328 / HEIGHT 72 / box height 22 stay. Missing methods fail-closed (skip). Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 294 passed, 0 failed (`lua tests/test_inputs.lua`). Isolation wrap stays under `if standalone then` (24 original pins; 6 re-pins in `runB14B()`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Source contains `OnEscapePressed` / `ClearFocus` / `SetMultiLine`. Source does not contain `UISpecialFrames`, `SUMMON`, `PlaySound`, `.tga` / `.blp` / `.ttf`, `Popes`, `IsRegisteredPope`. After Init in Event: `editBox()` has `OnEscapePressed`; `SetFocus`; `stub.fire` does not error; `HasFocus()` is false; frame stays shown; `GetView().shown` stays true. Geometry 328×72 / box 22. Confess `GetText` pin re-checked. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | After `SetAutoFocus(false)`: type-guard `SetMultiLine(true)`; type-guard `SetScript("OnEscapePressed")` that `ClearFocus`es only. Does not Hide. Not on `UISpecialFrames`. |
| `docs/reformation/vestments/briefs/B14-B-inputs-esc-report.md` | This file |
| `docs/reformation/vestments/briefs/B14-B-inputs-esc.diff` | B14-B-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Net, Console, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Inputs to `UISpecialFrames`. Did not look up a Pope name. Did not commit.

The exclusive pair is untracked in this checkout. The brief diff is the B14-B-only delta, not a whole-file add.

## Contract

| Surface | Role |
|---------|------|
| Confess `EditBox` | After create: if `type(SetMultiLine) == "function"`, `SetMultiLine(true)`. If `type(SetScript) == "function"`, wire `OnEscapePressed`. Handler `ClearFocus`es when that API exists. Missing APIs no-op. |
| Hide | Not called from the box. ESC unfocuses only. Panel hide stays Runtime Quiet. |
| `UISpecialFrames` | Not used. Event input chrome is not ESC-dismissed. |
| Geometry | WIDTH 328, HEIGHT 72, box height 22. `SetAutoFocus(false)` stays. |
| Sound / lookup | None. No `PlaySound`. No Pope-name lookup. Whisper target stays `SetInputTarget`. |

### Unchanged

- Stock `InputBoxTemplate` / `UIPanelButtonTemplate`. Petition / Confess / Catch up verbs.
- Quiet refuse. Confess `GetText` when no arg. Catchup `RequestSnapshot` on the injected target.
- Isolation wrap. No slash. No Net / Console / glue edits.

## TDD

1. Extended `tests/test_inputs.lua` first (`runB14B()`: wiring, `SetFocus`, fire, ClearFocus, no Hide, geometry, Confess `GetText`, source pins, isolation re-pins). Isolation wrap untouched.
2. Red: `lua tests/test_inputs.lua` — **281 passed, 13 failed**.
3. Implemented type-guarded `SetMultiLine(true)` and `OnEscapePressed` → `ClearFocus` on the confess box.
4. Green: `lua tests/test_inputs.lua` — **294 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 294 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **294 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 24 original isolation asserts stay under `if standalone then`. `runB14B()` re-pins Console / Popes / Sender / Sound / Hud / slash.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Net / Console / glue / TOC not edited.
- `SetMultiLine`, `SetScript`, and `ClearFocus` are type-guarded. Missing methods no-op.
- `stub.fire(box, "OnEscapePressed")` does not error. `HasFocus()` is false. Frame stays shown. `GetView().shown` stays true.
- Source contains `OnEscapePressed`, `ClearFocus`, `SetMultiLine`. Source does not contain `UISpecialFrames`, `SUMMON`, `PlaySound`, `.tga` / `.blp` / `.ttf`, `Popes`, `IsRegisteredPope`.
- WIDTH 328 / HEIGHT 72 / box height 22. `SetAutoFocus(false)` stays. Existing Confess `GetText` pins pass.
- Isolation wrap stays.

## Concerns

- **No client smoke.** Real ESC vs a focused `InputBoxTemplate` on Anniversary is unproven. **POLISH:CANDIDATE** only.
- **Harness `ClearFocus` is a stub flag.** Tests pin `_focused` and `GetScript`, not the client's keyboard walk.
- **`SetMultiLine(true)` on a 22px box is unsmoked.** The brief forbids growing HEIGHT or the box. Wrapped confession text may clip until a later geometry lane.
- **Missing `SetScript` fail-closed** leaves the default EditBox ESC swallow with no `ClearFocus`. That is the brief's skip, not a Hide.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
