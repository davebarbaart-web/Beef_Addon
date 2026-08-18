# B21-C — interrupt Hide does not pump a queued toast (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B20-D leftover (`interruptShowing` nils `showing` then `Hide()`; OnHide pumped a queued row before Push inserted the interrupter); wiki ESC via `UISpecialFrames`; Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged); brief `docs/reformation/vestments/briefs/B21-C-toast-interrupt.md`. No new kind names. No `PlaySound` on hide / ESC / interrupt. Do not `hideTheater` from the small-toast OnHide. `ChurchOfBeefToast` stays on `UISpecialFrames`. Exclusive files only. No commit. Lane is not signed.

Small-toast `OnHide` idle guard is now `if not self.showing then return`. ESC still advances one (ESC Hide happens while `showing` is set). Empty-pump Hide stays idle. `interruptShowing` still discards the interrupted toast and never re-queues it. Default `KINDS` stay `interrupt = false`. Push may pass `interrupt = true` and a higher `priority`. Pending is not drained.

**Isolated count:** 473 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B21-C pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). Init OnHide source pin is `if not self.showing then return` and no `#pending == 0` in Init. Show one system toast, Show a second (queues), Push `{ kind = "system", text = "interrupt", interrupt = true, priority = 99 }`. Showing text is the interrupter; pending stays 1. B20-D ESC-advance-one pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | Small-toast `OnHide` idle guard: `if not self.showing then return`. Does not call `hideTheater`. No `PlaySound`. No new kind names. `KINDS` stay `interrupt = false`. |
| `docs/reformation/vestments/briefs/B21-C-toast-interrupt-report.md` | This file |
| `docs/reformation/vestments/briefs/B21-C-toast-interrupt.diff` | B21-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound`. Did not `hideTheater` from the small-toast OnHide. Did not commit.

`git diff` vs HEAD on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B21-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| Small `OnHide` idle guard | `if not self.showing then return`. Does not call `hideTheater`. |
| ESC with queue | Advances one. Hide happens while `showing` is set. Remaining pending stays. |
| Empty-pump Hide | `showing` already nil; idle return. No loop. |
| `interruptShowing` | Nils `showing` then `Hide()`. Interrupted toast is discarded; never re-queued. OnHide does not pump the queued row. Push then inserts the interrupter. |
| Interrupt Push | `{ kind = "system", text = "interrupt", interrupt = true, priority = 99 }`. Showing text is the interrupter. Pending count stays 1 (queued row). |
| Default `KINDS` | `interrupt = false`. No new kind names. |
| `ChurchOfBeefToast` | Stays on `UISpecialFrames` once. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound` on hide / ESC / interrupt. |

### Unchanged

- Existing B12-D Proclaim / ESC / UISpecialFrames pins.
- B15-C Quiet-shell `rememberSpecial` pins.
- B18-C HideAll / `theaterGen` pins.
- B19-B single-toast ESC clears `ShowingKind`; later Show still works.
- B20-D ESC-advance-one / empty-pump pins.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: OnHide idle guard `if not self.showing then return`; Show / Show / interrupt Push; showing text is the interrupter; pending stays 1). Isolation wrap untouched.
2. Red: `lua tests/test_ui.lua` — **470 passed, 3 failed**.
3. Implemented OnHide idle guard `if not self.showing then return`.
4. Green: `lua tests/test_ui.lua` — **473 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 473 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **473 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Console / Sound / glue / TOC were not edited.
- Small `OnHide` does not call `hideTheater` and does not `PlaySound`.
- Interrupt Push presents the interrupter and leaves the queued row in `pending`.
- ESC still advances one. Empty-pump Hide stays idle. `ChurchOfBeefToast` stays listed once.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Pump + OnHide + interrupt are pinned; the client's special-frame walk is not.
- **`Init` early-return does not re-wire OnHide.** First create registers the handler; second Init is idempotent on the widget.
- **Empty-pump `#pending == 0` in `pump` is still redundant** after `table.remove` returned nil. Brief asked only the OnHide guard.

## Status

**DONE_WITH_CONCERNS.** Isolated **473 / 0**. Not signed.
