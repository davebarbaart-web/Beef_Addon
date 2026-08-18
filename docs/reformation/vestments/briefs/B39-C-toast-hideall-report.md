# B39-C — HideAll remounts toast and proclaim ESC names (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames`; B18-C leftover (`HideAll` hid the small toast and proclaim root without remounting `ChurchOfBeefToast` / `ChurchOfBeefProclaim`; a wiped list stayed idle until the next Proclaim / Show); Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged); brief `docs/reformation/vestments/briefs/B39-C-toast-hideall.md`. No `PlaySound`. Do not add a close button. B18-C HideAll still plays no sound and still tears theater once. Exclusive files only. No commit. Lane is not signed.

`Toasts:HideAll` now remounts `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)` after tearing theater and hiding the small toast. Dedupe is scan-then-append. No close button. No `PlaySound`. `ResetForTests` still calls `HideAll` only.

**Isolated count:** 621 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B39-C pins inside `runB12D()` after the B18-C HideAll block (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: HideAll body remounts `ChurchOfBeefToast` and `PROCLAIM_NAME` / `ChurchOfBeefProclaim`; no `PlaySound`; no `CreateFrame`. Wipe `UISpecialFrames` to `{}`, HideAll: both names re-listed once, no sound, theater stays torn, no close button. Second HideAll does not duplicate. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | `HideAll` remounts `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)` after hide work. Does not add a close button. Does not `PlaySound`. Still calls `hideTheater` once (no extra `bumpGen`). |
| `docs/reformation/vestments/briefs/B39-C-toast-hideall-report.md` | This file |
| `docs/reformation/vestments/briefs/B39-C-toast-hideall.diff` | B39-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, MainFrame, Sound, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound`. Did not add a close button. Did not commit.

`git diff` vs HEAD on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B39-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `HideAll` | `gen + 1`, `hideTheater` once, clear pending / showing, hide the small toast. Then remount `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)`. |
| Wipe remount | `UISpecialFrames = {}` then HideAll lists both names exactly once. Second HideAll still once. |
| B18-C | HideAll still plays no sound. Still tears theater once (`hideTheater` only; no extra `bumpGen`). Next Proclaim still shows (existing pin). |
| Close | No close button. No ✕. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound` on HideAll / ESC / hide. |

### Unchanged

- Existing B12-D Proclaim / ESC / UISpecialFrames pins.
- B15-C Quiet-shell `rememberSpecial` pins (`ChurchOfBeefFrame` stays first after restore).
- B18-C HideAll / `theaterGen` pins.
- B19-B / B20-D / B21-C / B23-C / B26-B small-toast ESC / pump / Init remount pins.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()` after the B18-C HideAll block: HideAll body remounts both names; wipe `UISpecialFrames` to `{}`, HideAll lists both once; no sound; theater stays torn; second HideAll does not duplicate). Isolation wrap and B18-C pins untouched.
2. Red: `lua tests/test_ui.lua` — **615 passed, 6 failed**.
3. `HideAll` remounts `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)` after hide work.
4. Green: `lua tests/test_ui.lua` — **621 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 621 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **621 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. MainFrame / Sound / glue / TOC were not edited.
- HideAll remounts both ESC names. Wipe-to-empty then HideAll lists each exactly once. Second HideAll still once.
- B18-C still plays no sound and still tears theater once. No close button. No `PlaySound`.
- New test locals live in `runB12D()`. Isolation wrap stays. `UISpecialFrames` is restored so B15-C `ChurchOfBeefFrame`-first stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. A live remount that dropped the names is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `HideAll` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not.
- **`ResetForTests` now remounts both names** as a HideAll side effect. Frames need not exist for the name remount.

## Status

**DONE_WITH_CONCERNS.** Isolated **621 / 0**. Not signed.
