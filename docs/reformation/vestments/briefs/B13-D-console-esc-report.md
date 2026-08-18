# B13-D — Console EditBox ESC ClearFocus (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (Director Console stock desk); Law 10 / §19.3 (functional / stock templates); Law 6 / §19.4 (Quiet is silent; no `PlaySound`); wiki "Make frames closable with the Escape key" (focused EditBoxes swallow ESC and block `UISpecialFrames`); brief `docs/reformation/vestments/briefs/B13-D-console-esc.md`. CONTINUE 2026-08-18 license 4 (stock only). `SaveNote` stays nil. No SUMMON.

In `stockEdit`, `SetScript("OnEscapePressed")` is type-guarded and `ClearFocus`es the box. All stock boxes (Stipulation, FreeRuling, Decree, Archive, Canonize, Honorific) inherit it. The box does not Hide the console. Missing `SetScript` / `ClearFocus` no-op. No `PlaySound`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 1286 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB13D()` inside `runB8E()` (Lua 5.1 200-local cap; no new main-chunk locals). ArchiveBox / DecreeLine have `OnEscapePressed`. `stub.fire` does not error and ClearFocuses. Console stays shown. Other stock boxes inherit. Source contains `OnEscapePressed` / `ClearFocus` / type-guarded `SetScript`. `SaveNote` nil. No SUMMON / parchment / tabs / `PlaySound`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | In `stockEdit`, after `SetAutoFocus(false)`: `type(box.SetScript) == "function"` then `OnEscapePressed`. Handler type-guards `ClearFocus` and does not Hide. |
| `docs/reformation/vestments/briefs/B13-D-console-esc-report.md` | This file |
| `docs/reformation/vestments/briefs/B13-D-console-esc.diff` | B13-D-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Store, Gora, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B13-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `stockEdit` | If `type(SetScript) == "function"`, wire `OnEscapePressed`. Handler `ClearFocus`es when that API exists. Missing APIs no-op. |
| Hide | Not called from the box. ESC unfocuses; `UISpecialFrames` can close the desk. |
| Inheritance | Stipulation, FreeRuling, Decree line/flavor, Archive, Canonize, Honorific all go through `stockEdit`. |
| Sound | None. Source has no `PlaySound`. |
| `SaveNote` | Stays nil. |

### Unchanged

- Stock `InputBoxTemplate` / `SetAutoFocus(false)` / Archive multiline. Seven EditBoxes.
- Desk scroll, CeremonyLog, ritual verbs, `UISpecialFrames` registration of the named console frame.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_console.lua` first (`runB13D()`: wiring, fire, ClearFocus, no Hide, source pins, SaveNote / SUMMON / parchment / tabs). Isolation wrap untouched.
2. Red: `lua tests/test_console.lua` — **1273 passed, 13 failed**.
3. Implemented type-guarded `OnEscapePressed` → `ClearFocus` in `stockEdit`.
4. Green: `lua tests/test_console.lua` — **1286 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1286 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1286 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** isolation asserts stay under `if standalone then` (11 wrap sites). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Store / Gora / glue / TOC not edited.
- `SetScript` and `ClearFocus` are type-guarded. Missing methods no-op.
- `stub.fire(box, "OnEscapePressed")` does not error. ArchiveBox and DecreeLine ClearFocus. Console stays shown.
- All seven stock EditBoxes inherit the handler. `SaveNote` nil. No SUMMON / parchment / tabs / `PlaySound`.
- New test locals are inside `runB13D()` nested in `runB8E()`. No new main-chunk locals.
- Isolation wrap stays.

## Concerns

- **No client smoke.** Real ESC vs focused EditBox vs `UISpecialFrames` close order is unproven on Anniversary. **POLISH:CANDIDATE** only.
- **Harness `ClearFocus` is a stub flag.** Tests pin `_focused` and `GetScript`, not the client's keyboard walk.
- **`DecreeFlavor` is also a stockEdit box** and inherits the same handler. Brief named Decree; both Decree boxes are covered.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
