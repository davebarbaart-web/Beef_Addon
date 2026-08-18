# B35-D — Quiet-shell Hide remounts OnHide + persist (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`); B31-C leftover (`UI:Hide` skipped a niled OnHide; `shown` stayed true and Init `wasShown` reopened the shell); brief `docs/reformation/vestments/briefs/B35-D-shell-hide.md`. B31-C Show remount stays. B27-C Init remount stays. B26-B toast pins stay. Exclusive files only. No commit. Lane is not signed.

When the frame exists, `UI:Hide` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before `_StopSizing` + `self.frame:Hide()`. The helper wires only when `GetScript("OnHide")` is nil. An existing script is not replaced. The widget is not rebuilt. OnShow is not re-wired. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. Inputs stay off `UISpecialFrames`.

**Isolated count:** 607 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B35-D pins inside `runB12D()` after the B31-C block (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: `Hide` body calls `wireShellOnHide` and `rememberSpecial(FRAME_NAME)` before `self.frame:Hide()`; still `_StopSizing`; no inline `SetScript` / OnShow re-wire / rebuild / `PlaySound`. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. Show so Hide is a real transition; wipe `UISpecialFrames`; nil OnHide; `shown = true`; `UI:Hide()` restores the script, persists `shown == false`, lists `ChurchOfBeefFrame` once, plays no sound, does not rebuild. Third Hide does not duplicate. Inputs stay off the list. B31-C Show / B27-C Init / B26-B toast pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/MainFrame.lua` | When the frame exists, `Hide` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before `_StopSizing` + `self.frame:Hide()`. Does not replace an existing script. Does not rebuild. No OnShow re-wire. No `PlaySound`. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. |
| `docs/reformation/vestments/briefs/B35-D-shell-hide-report.md` | This file |
| `docs/reformation/vestments/briefs/B35-D-shell-hide.diff` | B35-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts.lua, RecordsBook, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound` / `IG_CHARACTER_INFO_*`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Quiet-shell / toast batches (working tree already dirty). The brief diff is the B35-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Hide` exists-path | `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `_StopSizing` then `self.frame:Hide()`. |
| `wireShellOnHide` | If `GetScript("OnHide")` is nil, wire `_StopSizing()` then `ui.shown = false`. Do not replace an existing script. Unchanged. |
| `rememberSpecial` | Scan-then-append `FRAME_NAME`. Unchanged. |
| Show remount | B31-C pair stays. |
| Init remount | Early-return still `rememberSpecial` then `wireShellOnHide`. Create path unchanged. |
| Missing OnHide remount | `SetScript("OnHide", nil)` then Hide restores the handler. Third Hide keeps identity. |
| Wipe remount | `UISpecialFrames = {}` then Hide lists `ChurchOfBeefFrame` exactly once. |
| Restored OnHide | Still calls `_StopSizing`. Still persists `shown = false`. |
| Inputs | Stay off `UISpecialFrames`. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| Template | Stays `BasicFrameTemplate`. |
| `FRAME_NAME` | `"ChurchOfBeefFrame"`. |

### Unchanged

- Existing Init pin `UISpecialFrames[1] == "ChurchOfBeefFrame"`.
- B15-C Quiet-shell `rememberSpecial` / forced-rebuild uniqueness pins.
- B12-D Proclaim / ESC / UISpecialFrames pins.
- B18-C HideAll / `theaterGen` pins.
- B19-B / B20-D / B21-C / B23-C / B26-B small-toast pins.
- B24-C / B27-C Quiet-shell Init early-return `rememberSpecial` + missing OnHide restore.
- B29-D Proclaim `applyHeadlineFont` on a shown beat.
- B31-C Quiet-shell Show remount of a missing OnHide.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()` after B31-C: `Hide` body calls `wireShellOnHide` + `rememberSpecial(FRAME_NAME)` before `frame:Hide`; nil OnHide then Hide restores; wipe remounts the name once; `shown == false`; third Hide identity stays; Inputs stay off the list). Isolation wrap and B31-C Show / B27-C Init / B26-B toast pins untouched.
2. Red: `lua tests/test_ui.lua` — **599 passed, 8 failed** (`Hide` body missing the helpers; niled OnHide stayed nil after Hide; wipe left `ChurchOfBeefFrame` unlisted; Hide without a handler left `shown` true). B31-C Show / B27-C Init / B26-B toast / isolation pins stayed green.
3. Exists-path `Hide` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before `_StopSizing` + `self.frame:Hide()`. Existing script is not replaced. Widget is not rebuilt. Show remount kept.
4. Green: `lua tests/test_ui.lua` — **607 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 607 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **607 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / RecordsBook / Decree / glue / TOC were not edited.
- Exists-path `Hide` re-registers `ChurchOfBeefFrame` and restores a missing OnHide. An existing script is not replaced.
- Wipe-to-empty then Hide lists the name exactly once. Third Hide still once.
- Restored OnHide still calls `_StopSizing` and persists `shown = false`. No `PlaySound`. OnShow is not re-wired. Inputs stay off the list.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **Early-return still does not restore a missing OnShow.** Only OnHide is remounted. A remount that dropped OnShow would skip `shown = true` and the roster kick. Outside this brief.
- **Already-hidden Hide does not fire OnHide.** The stub (and the client) only fire OnHide on a shown→hidden transition. A niled handler plus `shown = true` plus Hide while already hidden remounts the script but leaves `shown` true until a later real hide. The suite Shows first so Hide is a real transition.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts and script identity are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **607 / 0**. Not signed. No Gate / **POLISH:PASS** claim.
