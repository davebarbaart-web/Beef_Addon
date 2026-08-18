# B18-C — HideAll does not double-bump theaterGen (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / Law 10 (theatrical Proclaim, no close ✕); Law 6 (Quiet does not drive this file); brief `docs/reformation/vestments/briefs/B18-C-toast-gen.md`. CONTINUE 2026-08-18 license 4 (stock only). No new cue names. `ChurchOfBeefProclaim` stays on `UISpecialFrames`. Clerical copy unchanged.

`HideAll` no longer calls `bumpGen()` beside `hideTheater`. Small-toast `gen` still increments inline so leftover hold / fade timers stay invalid. `hideTheater` guards re-entry: `root:Hide()` → OnHide → `hideTheater` is a no-op while the HideAll hide is in flight, so one dismiss bumps `theaterGen` once. Proclaim → HideAll → Proclaim still accepted and the theater root shows. No `PlaySound` on hide. No close ✕. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 382 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B18-C pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: `HideAll` body does not call both `bumpGen` and `hideTheater`. Proclaim → HideAll → leftover timer → Proclaim still accepted and root shown. No sound. `ChurchOfBeefProclaim` stays once. No close button. Existing Proclaim / ESC / UISpecialFrames pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | `hideTheater` re-entry guard (`theaterHiding`). `HideAll` increments `gen` inline and calls `hideTheater` only. |
| `docs/reformation/vestments/briefs/B18-C-toast-gen-report.md` | This file |
| `docs/reformation/vestments/briefs/B18-C-toast-gen.diff` | B18-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a close button. Did not add `PlaySound` on hide. Did not commit.

`git diff` vs HEAD on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B18-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `HideAll` | Increments small-toast `gen` inline. Calls `hideTheater` once. Does not call `bumpGen`. |
| `hideTheater` | Bumps `theaterGen` once per dismiss. Re-entry from OnHide is a no-op. |
| OnHide | Still calls `hideTheater`. When HideAll already hid the root, the guard no-ops. ESC leftover Hide still invalidates the hold timer. |
| Next Proclaim | After HideAll, `Proclaim` is accepted and the theater root is shown. |
| `ChurchOfBeefProclaim` | Stays on `UISpecialFrames` once. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound` on Hide / ESC / HideAll. |
| Copy | Clerical only. No close ✕. |

### Unchanged

- Existing B12-D Proclaim / ESC / UISpecialFrames pins.
- B15-C Quiet-shell `rememberSpecial` pins.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: HideAll body source pin; Proclaim → HideAll → Proclaim shown; no sound; special-frame / no-close pins). Isolation wrap untouched.
2. Red: `lua tests/test_ui.lua` — **381 passed, 1 failed** (`HideAll` body still called both `bumpGen` and `hideTheater`).
3. Re-entry guard on `hideTheater`. `HideAll` dropped the `bumpGen()` call.
4. Green: `lua tests/test_ui.lua` — **382 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 382 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **382 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Console / Sound / glue / TOC were not edited.
- `HideAll` body contains `hideTheater` and does not contain `bumpGen`.
- OnHide during HideAll does not increment `theaterGen` a second time.
- Next Proclaim after HideAll is accepted and the root is shown.
- No `PlaySound` on hide. No close ✕. `ChurchOfBeefProclaim` stays on `UISpecialFrames`.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** HideAll vs real ESC vs leftover `THEATER_HOLD` is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **`ChurchOfBeefToast` remains ESC-immune.** Brief forbids registering the small stack.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **382 / 0**. Not signed.
