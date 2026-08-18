# B26-B — Toast Init restores a missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B23-C leftover (`Toasts:Init` early-return `rememberSpecial`s but never restores a missing OnHide; a remount that dropped the handler leaves ESC Hide idle); wiki ESC via `UISpecialFrames`; Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged); brief `docs/reformation/vestments/briefs/B26-B-toast-onhide.md`. No new kind names. Default `KINDS` stay `interrupt = false`. No `PlaySound`. Do not `hideTheater` from the small-toast OnHide. OnHide idle-return when `showing` is nil stays. Exclusive files only. No commit. Lane is not signed.

`Toasts:Init` early-return (`if self.frame then`) still calls `rememberSpecial("ChurchOfBeefToast")`, then `wireSmallOnHide(self, self.frame)` if `GetScript("OnHide")` is nil. An existing script is not replaced. Create path calls the same helper after the initial Hide. No rebuild.

**Isolated count:** 528 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B26-B pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: `wireSmallOnHide` holds the idle-return handler; Init create + early-return both call it; no inline `SetScript` on early-return. Nil OnHide, second Init restores the script; third Init keeps identity. Restored handler still pumps / idle-returns. Wipe `UISpecialFrames` uniqueness / B23-C pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | Extracted `wireSmallOnHide(self, frame)`. Early-return `rememberSpecial`s then wires only when OnHide is missing. Create path calls the same helper. Does not replace an existing script. Does not rebuild. Does not call `hideTheater`. No `PlaySound`. No new kind names. `KINDS` stay `interrupt = false`. |
| `docs/reformation/vestments/briefs/B26-B-toast-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B26-B-toast-onhide.diff` | B26-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Decree, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound`. Did not `hideTheater` from the small-toast OnHide. Did not commit.

`git diff` vs HEAD on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B26-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` early-return | `rememberSpecial("ChurchOfBeefToast")` then `wireSmallOnHide(self, self.frame)`; return the existing frame. |
| `wireSmallOnHide` | If `GetScript("OnHide")` is nil, wire the idle-return handler (`if not self.showing then return` then `bumpGen` / nil showing / `pump`). Do not replace an existing script. |
| Create path | Same helper after the initial Hide, then `rememberSpecial`. |
| Wipe remount | `UISpecialFrames = {}` then second Init lists `ChurchOfBeefToast` exactly once. Existing OnHide identity stays. |
| Missing OnHide remount | `SetScript("OnHide", nil)` then second Init restores the handler. Third Init keeps identity. |
| OnHide idle-return | `if not self.showing then return` stays. Does not call `hideTheater`. |
| Default `KINDS` | `interrupt = false`. No new kind names. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound` on Init / ESC / hide. |

### Unchanged

- Existing B12-D Proclaim / ESC / UISpecialFrames pins.
- B15-C Quiet-shell `rememberSpecial` pins.
- B18-C HideAll / `theaterGen` pins.
- B19-B single-toast ESC clears `ShowingKind`; later Show still works.
- B20-D ESC-advance-one / empty-pump pins.
- B21-C interrupt Hide idle guard; queued row stays pending.
- B23-C wipe uniqueness / existing-script identity pins.
- B24-C Quiet-shell early-return `rememberSpecial` (this lane does not restore shell OnHide).
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: `wireSmallOnHide` source; early-return calls the helper; nil OnHide then second Init restores; third Init identity stays; restored handler still pumps / idle-returns). Isolation wrap and wipe uniqueness pins untouched except the early-return source pin now expects the helper call.
2. Red: `lua tests/test_ui.lua` — **518 passed, 10 failed** (`wireSmallOnHide` missing; early-return source missing the helper; niled OnHide stayed nil after second Init; Hide without a handler did not pump). Wipe uniqueness / existing-script identity / isolation pins stayed green.
3. Extracted `wireSmallOnHide`. Early-return and create both call it. Existing script is not replaced.
4. Green: `lua tests/test_ui.lua` — **528 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 528 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **528 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Decree / Records / glue / TOC were not edited.
- Early-return re-registers `ChurchOfBeefToast` and restores a missing OnHide. An existing script is not replaced.
- Wipe-to-empty then second Init lists the name exactly once. Third Init still once.
- Small `OnHide` idle-return when `showing` is nil stays. Does not call `hideTheater`. No `PlaySound`. `KINDS.interrupt` stays false.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts and script identity are pinned; the client's special-frame walk is not.
- **Quiet-shell Init early-return still does not restore a missing OnHide.** B24-C only `rememberSpecial`s. That leftover is outside this exclusive pair.

## Status

**DONE_WITH_CONCERNS.** Isolated **528 / 0**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
