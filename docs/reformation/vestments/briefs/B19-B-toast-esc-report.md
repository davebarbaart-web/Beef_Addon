# B19-B — Small toast ESC via UISpecialFrames (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** wiki "Make frames closable with the Escape key" (named frame on `UISpecialFrames`); Law 6 (Quiet does not drive this file; no Quiet toast kind); Law 10 / Bible §19.3 (no close button; clerical copy unchanged); brief `docs/reformation/vestments/briefs/B19-B-toast-esc.md`. CONTINUE 2026-08-18 license 4 (stock only). No new cue. `IG_CHARACTER_INFO_*` forbidden. `ChurchOfBeefProclaim` stays.

`Init` calls `rememberSpecial("ChurchOfBeefToast")` (existing dedupe helper). Small-frame `OnHide` syncs `showing` to nil so ESC Hide does not leave the pump thinking a hidden toast is still up. `OnHide` does not call `hideTheater`. No `PlaySound` on ESC / show / hide. No close ✕. Clerical copy unchanged. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 415 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B19-B pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). After Init / Show / Push: `ChurchOfBeefToast` is on `UISpecialFrames` once. Hide clears `ShowingKind`. Later Show still works. Small OnHide does not hide theater. No `PlaySound`. No close ✕. B12-D toast-absent pins inverted. Proclaim special-frame pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | After the create-time Hide: type-guarded `OnHide` sets `showing` nil. `rememberSpecial("ChurchOfBeefToast")`. Does not call `hideTheater`. No `PlaySound`. |
| `docs/reformation/vestments/briefs/B19-B-toast-esc-report.md` | This file |
| `docs/reformation/vestments/briefs/B19-B-toast-esc.diff` | B19-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a close button. Did not add `PlaySound`. Did not mint a Quiet toast kind. Did not commit.

`git diff` vs HEAD on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B19-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `ChurchOfBeefToast` | Named small stack. `rememberSpecial` onto `UISpecialFrames` from `Init`. Missing table no-ops. Second Init does not duplicate. |
| Small `OnHide` | Sets `showing` nil. Does not call `hideTheater`. Wired after the create-time Hide. |
| Next Push / Show | After ESC Hide, `ShowingKind` is nil and a later Push / Show still presents. |
| `ChurchOfBeefProclaim` | Stays on `UISpecialFrames` once. Theater stays shown when the small toast Hides. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound` / `IG_CHARACTER_INFO_*` on ESC, show, or hide. |
| Copy | Clerical only. No close ✕. No new cue. No Quiet toast kind. |

### Unchanged

- Existing B12-D Proclaim / ESC / UISpecialFrames pins (Proclaim once; OnHide teardown; leftover Hide does not stick the next Proclaim).
- B15-C Quiet-shell `rememberSpecial` pins.
- B18-C HideAll / `theaterGen` pins.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: source `rememberSpecial("ChurchOfBeefToast")`; Init OnHide / no `hideTheater` / no `PlaySound`; listed once; Hide clears `ShowingKind`; later Show works; theater stays). Isolation wrap untouched.
2. Red: `lua tests/test_ui.lua` — **402 passed, 13 failed**.
3. Implemented `OnHide` → `showing = nil` and `rememberSpecial("ChurchOfBeefToast")` in `Init`.
4. Green: `lua tests/test_ui.lua` — **415 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 415 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **415 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Console / Sound / glue / TOC were not edited.
- `rememberSpecial` type-guards `UISpecialFrames` and dedupes. Call is the literal `rememberSpecial("ChurchOfBeefToast")` in `Init`.
- `OnHide` syncs `showing` only. It does not call `hideTheater` and does not `PlaySound`.
- Hide (simulating ESC) clears `ShowingKind`. A later Show still presents.
- `ChurchOfBeefProclaim` stays listed once. Small Hide leaves the theater root shown.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Registration + OnHide sync are pinned; the client's special-frame walk is not.
- **ESC does not drain `pending`.** OnHide only clears `showing`. A queued toast waits until the next Push / Show pumps. Pump is not stuck (`showing` is nil).
- **`Init` early-return does not re-call `rememberSpecial`.** First create registers; second Init is idempotent on the widget.

## Status

**DONE_WITH_CONCERNS.** Isolated **415 / 0**. Not signed.
