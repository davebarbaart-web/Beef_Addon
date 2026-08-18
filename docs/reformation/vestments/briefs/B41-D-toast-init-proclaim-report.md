# B41-D — Toasts Init remounts ChurchOfBeefProclaim (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames`; B39 leftover (existing-frame Init remounted only `ChurchOfBeefToast` + `wireSmallOnHide`, so a wiped `ChurchOfBeefProclaim` stayed idle until HideAll / Proclaim); Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged); brief `docs/reformation/vestments/briefs/B41-D-toast-init-proclaim.md`. No `PlaySound`. Do not add a close button. Do not tear theater. Exclusive files only. No commit. Lane is not signed.

Existing-frame `Toasts:Init` still remounts `rememberSpecial("ChurchOfBeefToast")` and `wireSmallOnHide`, and now also remounts `rememberSpecial(PROCLAIM_NAME)` / `ChurchOfBeefProclaim`. Dedupe is scan-then-append. No close button. No `PlaySound`. Init does not call `hideTheater`. First-create Init is unchanged.

**Isolated count:** 664 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the load-time `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B41-D pins inside `runB12D()` after the B39-C HideAll block (Lua 5.1 200-local cap; no new main-chunk locals; no new `runB12D` locals — reused `hideAllBody` / `savedSpecialHideAll` / `cuesHideAllRemount`). Source pin: early-return remounts `ChurchOfBeefToast` and `PROCLAIM_NAME` / `ChurchOfBeefProclaim`; keeps `wireSmallOnHide`; no `PlaySound`; no `hideTheater`; no `CreateFrame`. Wipe `UISpecialFrames` to `{}`, Init: both names re-listed once, no sound, theater stays shown, no close button. Second Init does not duplicate. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | Existing-frame `Init` remounts `rememberSpecial(PROCLAIM_NAME)` after `rememberSpecial("ChurchOfBeefToast")`. Keeps `wireSmallOnHide`. Does not add a close button. Does not `PlaySound`. Does not tear theater. |
| `docs/reformation/vestments/briefs/B41-D-toast-init-proclaim-report.md` | This file |
| `docs/reformation/vestments/briefs/B41-D-toast-init-proclaim.diff` | B41-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, MainFrame, Sound, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound`. Did not add a close button. Did not commit.

`git diff` vs HEAD on these two files also includes earlier toast / Quiet-shell batches (working tree already dirty). The brief diff is the B41-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| Existing-frame `Init` | `rememberSpecial("ChurchOfBeefToast")` then `rememberSpecial(PROCLAIM_NAME)` then `wireSmallOnHide(self, self.frame)` then `return self.frame`. |
| Wipe remount | `UISpecialFrames = {}` then Init lists both names exactly once. Second Init still once. Theater stays shown. |
| `wireSmallOnHide` | Kept. Helper still wires only when `GetScript("OnHide")` is nil. |
| Theater | Init does not call `hideTheater`. Shown proclaim root stays shown. |
| Close | No close button. No ✕. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound` on Init / ESC / hide. |

### Unchanged

- Existing B12-D Proclaim / ESC / UISpecialFrames pins.
- B15-C Quiet-shell `rememberSpecial` pins (`ChurchOfBeefFrame` stays first after restore).
- B18-C HideAll / `theaterGen` pins.
- B19-B / B20-D / B21-C / B23-C / B26-B small-toast ESC / pump / Init remount pins.
- B39-C HideAll remount of toast + proclaim ESC names.
- First-create `Init` still remounts only `ChurchOfBeefToast`.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()` after the B39-C HideAll block: early-return remounts both names and keeps `wireSmallOnHide`; wipe `UISpecialFrames` to `{}`, Init lists both once; no sound; theater stays shown; second Init does not duplicate). Isolation wrap and B39-C pins untouched.
2. Red: `lua tests/test_ui.lua` — **661 passed, 3 failed**.
3. Existing-frame `Init` remounts `rememberSpecial(PROCLAIM_NAME)` after `rememberSpecial("ChurchOfBeefToast")`. `wireSmallOnHide` stays.
4. Green: `lua tests/test_ui.lua` — **664 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 664 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **664 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under the load-time `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora. Main-chunk locals: **75 / 200**. `runB12D()` locals: **56 / 200**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. MainFrame / Sound / glue / TOC were not edited.
- Existing-frame Init remounts both ESC names. Wipe-to-empty then Init lists each exactly once. Second Init still once.
- `wireSmallOnHide` stays. Theater stays shown. No close button. No `PlaySound`.
- New asserts reuse B39-C locals inside `runB12D()`. Isolation wrap stays. `UISpecialFrames` is restored so B15-C `ChurchOfBeefFrame`-first stays.

## Leftovers

- **First-create Init still remounts only `ChurchOfBeefToast`.** Brief scoped the existing-frame path. A missing toast frame then Init will not put `ChurchOfBeefProclaim` back until HideAll / Proclaim / InitTheater.
- **Wipe + Init remounts toast and proclaim only.** `ChurchOfBeefFrame` stays missing until MainFrame remounts or the nest restores the saved list. Required keep — MainFrame owns that name.
- **Widget Hide / ESC does not remount the names.** `CloseSpecialWindows` / `root:Hide()` still bypass Init. Existing B12-D pin still says ESC Hide does not re-register.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. A live remount that dropped the names is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Init` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not.
- **`UISpecialFrames = nil` still no-ops `rememberSpecial`.** Brief asked wipe-to-empty uniqueness, not a missing table.
- **Isolation wrap is load-only.** Eleven pins under the load-time standalone. `runB12D()` re-pins four.
- **Exclusive-pair packet is not a vs-HEAD Toasts delta.** Packet is the one remount line + nested pins + header comment. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell / HideAll batches.
- **`hideAllBody` is reused** for the Init early-return extract after the B39-C HideAll source pins. No new `runB12D` local.

## Status

**DONE_WITH_CONCERNS.** Isolated **664 / 0**. Not signed. No Gate W / Gate V / **POLISH:PASS** claim.
