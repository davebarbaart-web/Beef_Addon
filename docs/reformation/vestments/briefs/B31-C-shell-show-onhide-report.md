# B31-C — Quiet shell Show remounts a missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`); B27 leftover (`UI:Show` skipped a niled OnHide; ESC Hide then skips `_StopSizing` / `ui.shown = false`); brief `docs/reformation/vestments/briefs/B31-C-shell-show-onhide.md`. B27-C Init remount stays. B26-B toast pins stay. B29-D Proclaim font pins stay. Exclusive files only. No commit. Lane is not signed.

When the frame exists, `UI:Show` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before `self.frame:Show()`. The helper wires only when `GetScript("OnHide")` is nil. An existing script is not replaced. The widget is not rebuilt. Init remount stays. `FRAME_NAME` stays `"ChurchOfBeefFrame"`.

**Isolated count:** 582 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B31-C pins inside `runB12D()` after B29-D (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: `Show` body calls `wireShellOnHide` and `rememberSpecial(FRAME_NAME)` before `self.frame:Show()`; no inline `SetScript` / OnShow re-wire / rebuild / `PlaySound`. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. Nil OnHide, Show restores the script; wiped `UISpecialFrames` remounts the name once; third Show keeps identity. Restored handler still stops sizing and persists `shown = false`. B27-C Init / B26-B toast / B29-D Proclaim font pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/MainFrame.lua` | When the frame exists, `Show` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before `self.frame:Show()`. Does not replace an existing script. Does not rebuild. Init remount stays. No `PlaySound`. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. |
| `docs/reformation/vestments/briefs/B31-C-shell-show-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B31-C-shell-show-onhide.diff` | B31-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts.lua, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound` / `IG_CHARACTER_INFO_*`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Quiet-shell / toast batches (working tree already dirty). The brief diff is the B31-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Show` exists-path | `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self.frame:Show()` then `OnStatusChanged`. |
| `wireShellOnHide` | If `GetScript("OnHide")` is nil, wire `_StopSizing()` then `ui.shown = false`. Do not replace an existing script. Unchanged. |
| `rememberSpecial` | Scan-then-append `FRAME_NAME`. Unchanged. |
| Init remount | Early-return still `rememberSpecial` then `wireShellOnHide`. Create path unchanged. |
| Missing OnHide remount | `SetScript("OnHide", nil)` then Show restores the handler. Third Show keeps identity. |
| Wipe remount | `UISpecialFrames = {}` then Show lists `ChurchOfBeefFrame` exactly once. |
| Restored OnHide | Still calls `_StopSizing`. Still persists `shown = false`. |
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
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()` after B29-D: `Show` body calls `wireShellOnHide` + `rememberSpecial(FRAME_NAME)` before `frame:Show`; nil OnHide then Show restores; wipe remounts the name once; third Show identity stays; restored handler still `_StopSizing`s / persists `shown = false`). Isolation wrap and B27-C Init / B26-B toast / B29-D Proclaim pins untouched.
2. Red: `lua tests/test_ui.lua` — **573 passed, 9 failed** (`Show` body missing the helpers; niled OnHide stayed nil after Show; wipe left `ChurchOfBeefFrame` unlisted; Hide without a handler left `shown` true and `_sizing` true). B27-C Init / B26-B toast / B29-D Proclaim / isolation pins stayed green.
3. Exists-path `Show` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before `self.frame:Show()`. Existing script is not replaced. Widget is not rebuilt. Init remount kept.
4. Green: `lua tests/test_ui.lua` — **582 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 582 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **582 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Decree / glue / TOC were not edited.
- Exists-path `Show` re-registers `ChurchOfBeefFrame` and restores a missing OnHide. An existing script is not replaced.
- Wipe-to-empty then Show lists the name exactly once. Third Show still once.
- Restored OnHide still calls `_StopSizing` and persists `shown = false`. No `PlaySound`. OnShow is not re-wired.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **`Hide` still does not restore a missing OnHide.** Exists-path `Hide` only `_StopSizing`s then `frame:Hide()`. A remount that dropped the handler still skips persist / lastView until Init or Show. Outside this brief.
- **Early-return still does not restore a missing OnShow.** Only OnHide is remounted. A remount that dropped OnShow would skip `shown = true` and the roster kick. Outside this brief.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts and script identity are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **582 / 0**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
