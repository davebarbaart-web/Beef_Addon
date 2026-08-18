# B20-D — ESC on the small toast advances the queue (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B19-B leftover (ESC Hide cleared `showing` and left `pending` waiting for the next Push); wiki ESC via `UISpecialFrames`; Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged); brief `docs/reformation/vestments/briefs/B20-D-toast-pump.md`. No new cue. No `PlaySound` on hide / ESC. `ChurchOfBeefToast` stays on `UISpecialFrames`. Exclusive files only. No commit. Lane is not signed.

Small-toast `OnHide` `bumpGen()`s (invalidates the hold timer), sets `showing` nil, then `pump(self)` so a queued system toast presents. Empty pump returns when `showing` is already nil and pending is empty (Hide-from-empty-pump does not loop). `OnHide` does not call `hideTheater`. ESC advances one; it does not drain the rest of the queue.

**Isolated count:** 455 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B20-D pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). Init OnHide source pins `bumpGen` + `pump(self)`. Empty pump source pins `not self.showing` and `#pending == 0`. Show three system toasts; Hide presents the second; pending drops by one; third stays. Last Hide clears `ShowingKind` without looping. Theater stays shown. No `PlaySound`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | Small-toast `OnHide`: idle guard, then `bumpGen()`, `showing = nil`, `pump(self)`. Empty `pump` returns when `showing` is already nil and pending is empty. Does not call `hideTheater`. No `PlaySound`. |
| `docs/reformation/vestments/briefs/B20-D-toast-pump-report.md` | This file |
| `docs/reformation/vestments/briefs/B20-D-toast-pump.diff` | B20-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound`. Did not `hideTheater` from the small-toast OnHide. Did not commit.

`git diff` vs HEAD on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B20-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| Small `OnHide` | `bumpGen()`, `showing = nil`, `pump(self)`. Idle guard: if `showing` is already nil and pending is empty, return. Does not call `hideTheater`. |
| Empty `pump` | If no next envelope and `showing` is already nil and pending is empty, return (no second Hide). |
| ESC with queue | Advances one. `ShowingKind` / copy is the next envelope. Remaining pending stays. |
| ESC last toast | Frame hides. `ShowingKind` is nil. No loop. |
| `ChurchOfBeefToast` | Stays on `UISpecialFrames` once. |
| `ChurchOfBeefProclaim` | Stays on `UISpecialFrames` once. Theater stays shown when the small toast Hides / pumps. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound` on hide / ESC. |

### Unchanged

- Existing B12-D Proclaim / ESC / UISpecialFrames pins.
- B15-C Quiet-shell `rememberSpecial` pins.
- B18-C HideAll / `theaterGen` pins.
- B19-B single-toast ESC clears `ShowingKind`; later Show still works.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: OnHide `bumpGen` / `pump(self)`; empty-pump guard; three `Show`s then Hide presents the second and leaves the third; last Hide idles; theater stays). Isolation wrap untouched.
2. Red: `lua tests/test_ui.lua` — **440 passed, 15 failed**.
3. Implemented OnHide `bumpGen` + `showing = nil` + `pump(self)`, plus the empty-pump / idle OnHide guard.
4. Green: `lua tests/test_ui.lua` — **455 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 455 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **455 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Console / Sound / glue / TOC were not edited.
- Small `OnHide` does not call `hideTheater` and does not `PlaySound`.
- ESC Hide of a queued stack presents the next envelope and leaves the rest of `pending`.
- Last Hide idles without re-entry. `ChurchOfBeefProclaim` stays listed once. Theater stays shown.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Pump + OnHide are pinned; the client's special-frame walk is not.
- **`interruptShowing` still nils `showing` before Hide.** If pending is non-empty, OnHide may pump the next queued envelope before Push inserts an interrupting one. Default kinds have `interrupt = false`.
- **`Init` early-return does not re-wire OnHide.** First create registers the handler; second Init is idempotent on the widget.

## Status

**DONE_WITH_CONCERNS.** Isolated **455 / 0**. Not signed.
