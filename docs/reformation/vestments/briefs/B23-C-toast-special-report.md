# B23-C — Init early-return re-registers the small toast special frame (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B20-D leftover (`Toasts:Init` returned the existing frame and skipped `rememberSpecial`; a wiped `UISpecialFrames` never got `ChurchOfBeefToast` back); wiki ESC via `UISpecialFrames`; Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged); brief `docs/reformation/vestments/briefs/B23-C-toast-special.md`. No new kind names. Default `KINDS` stay `interrupt = false`. No `PlaySound`. Do not `hideTheater` from the small-toast OnHide. OnHide idle-return when `showing` is nil stays. Exclusive files only. No commit. Lane is not signed.

`Toasts:Init` early-return (`if self.frame then`) now calls `rememberSpecial("ChurchOfBeefToast")` then returns the frame. It does not re-wire OnHide. Create-path uniqueness still dedupes. First-create uniqueness pins stay.

**Isolated count:** 489 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B23-C pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: early-return body has `rememberSpecial("ChurchOfBeefToast")` and no `SetScript` / `OnHide`. Init, wipe `UISpecialFrames` to `{}`, second Init: name listed exactly once. OnHide function identity stays. First-create uniqueness pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | Early-return calls `rememberSpecial("ChurchOfBeefToast")` then returns the frame. Does not re-wire OnHide. Does not call `hideTheater`. No `PlaySound`. No new kind names. `KINDS` stay `interrupt = false`. |
| `docs/reformation/vestments/briefs/B23-C-toast-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B23-C-toast-special.diff` | B23-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound`. Did not `hideTheater` from the small-toast OnHide. Did not commit.

`git diff` vs HEAD on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B23-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` early-return | `rememberSpecial("ChurchOfBeefToast")` then return the existing frame. |
| Early-return OnHide | Not re-wired if a script already exists. This path does not `SetScript`. |
| Create path | Unchanged. Wires OnHide only when none exists; then `rememberSpecial`. |
| Wipe remount | `UISpecialFrames = {}` then second Init lists `ChurchOfBeefToast` exactly once. |
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
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: early-return source has `rememberSpecial("ChurchOfBeefToast")`; Init, wipe `UISpecialFrames` to `{}`, second Init lists the name once; OnHide identity stays). Isolation wrap and first-create uniqueness pins untouched.
2. Red: `lua tests/test_ui.lua` — **486 passed, 3 failed**.
3. Early-return calls `rememberSpecial("ChurchOfBeefToast")` then returns the frame.
4. Green: `lua tests/test_ui.lua` — **489 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 489 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **489 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Console / Sound / glue / TOC were not edited.
- Early-return re-registers `ChurchOfBeefToast` and does not re-wire OnHide.
- Wipe-to-empty then second Init lists the name exactly once. Third Init still once.
- Small `OnHide` idle-return when `showing` is nil stays. Does not call `hideTheater`. No `PlaySound`.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not.
- **Early-return never re-wires OnHide**, even if a remounted frame had lost the script. Law asked only: do not re-wire if a script already exists.

## Status

**DONE_WITH_CONCERNS.** Isolated **489 / 0**. Not signed.
