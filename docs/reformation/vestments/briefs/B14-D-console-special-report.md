# B14-D — Console UISpecialFrames dedupe (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (Director Console stock desk); Law 10 / §19.3 (functional / stock templates); Law 6 / §19.4 (Quiet is silent; no panel whoosh); wiki "Make frames closable with the Escape key" (named frame on `UISpecialFrames`); Decree `rememberSpecial`; brief `docs/reformation/vestments/briefs/B14-D-console-special.md`. CONTINUE 2026-08-18 license 4 (stock only). `SaveNote` stays nil. No SUMMON.

Replaced the bare `table.insert(UISpecialFrames, FRAME_NAME)` with Decree's `rememberSpecial` (type-guard the table, scan, then append). Called once at the end of `buildFrame()` for `ChurchOfBeefConsoleFrame`. Does not register scroll child names. No `PlaySound` / `IG_CHARACTER_INFO_*`. `stockEdit` ClearFocus (B13-D) unchanged — the box still does not Hide the desk. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 1332 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then`. Nested `runB14D()` inside `runB8E()` after `runB13D()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB14D()` inside `runB8E()` after `runB13D()` (Lua 5.1 200-local cap; no new main-chunk locals). After Init, `ChurchOfBeefConsoleFrame` appears in `UISpecialFrames` exactly once. ResetForTests + Init still once. Forced second `buildFrame` (nil `Console.frame`) still once. Pre-existing name does not add a second. Source has `rememberSpecial` / dedupe loop / `ChurchOfBeefConsoleFrame`. No bare insert, no scroll-child register, no `IG_CHARACTER_INFO` / `PlaySound` / `SaveNote` / SUMMON / parchment / tabs. Isolation wrap stays. B13-D ClearFocus pin still wired. |
| `addon/ChurchOfBeef/UI/Console.lua` | Copied Decree `rememberSpecial`. `buildFrame` calls `rememberSpecial(FRAME_NAME)` once. Removed `table.insert(UISpecialFrames, FRAME_NAME)`. |
| `docs/reformation/vestments/briefs/B14-D-console-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B14-D-console-special.diff` | B14-D-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Store, Gora, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not Hide the desk from EditBox ESC. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B14-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `rememberSpecial` | If `UISpecialFrames` is a table, skip when `name` is already listed, else append. Missing table no-ops. |
| `buildFrame` | Calls `rememberSpecial(FRAME_NAME)` once. Named desk only. |
| Scroll children | Not registered. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| `stockEdit` | Unchanged. OnEscapePressed still ClearFocus; does not Hide. |
| `SaveNote` | Stays nil. |

### Unchanged

- Stock `InputBoxTemplate` / `SetAutoFocus(false)` / Archive multiline. Seven EditBoxes.
- Desk scroll, CeremonyLog, ritual verbs.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB14D()` nested in `runB8E()` after `runB13D()`: count once, ResetForTests + Init, forced rebuild dedupe, pre-existing name, source pins, SaveNote / SUMMON / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1325 passed, 7 failed**.
3. Implemented Decree-style `rememberSpecial`; `buildFrame` calls it once; removed bare insert.
4. Green: `lua tests/test_console.lua` — **1332 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1332 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1332 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** isolation asserts stay under `if standalone then` (12 wrap sites). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Store / Gora / glue / TOC not edited.
- `rememberSpecial` type-guards a missing table and scans before append.
- After Init, `ChurchOfBeefConsoleFrame` is listed once. Second `buildFrame` does not duplicate. Pre-seeded name does not add a second.
- Scroll child names are not registered. `SaveNote` nil. No SUMMON / parchment / tabs / `PlaySound`.
- `runB14D()` is nested inside `runB8E()` after `runB13D()`. No new main-chunk locals.
- B13-D ClearFocus pins still pass. Isolation wrap stays.

## Concerns

- **No client smoke.** Real ESC vs focused EditBox vs `UISpecialFrames` close order is still unproven together on Anniversary. **POLISH:CANDIDATE** only.
- **`ResetForTests` does not nil `Console.frame`.** `Init` is idempotent, so the harness nils `Console.frame` to force a second `buildFrame` for the dedupe pin.
- **Harness `UISpecialFrames` is a stub table.** Tests pin membership counts, not the client's `CloseSpecialWindows` walk.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
