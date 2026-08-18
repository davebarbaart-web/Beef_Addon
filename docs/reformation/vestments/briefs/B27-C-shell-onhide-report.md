# B27-C — Quiet shell Init restores a missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`); B26 leftover (`UI:Init` early-return `rememberSpecial`s but never restores a missing OnHide; ESC Hide then skips `_StopSizing` / `ui.shown = false`); brief `docs/reformation/vestments/briefs/B27-C-shell-onhide.md`. B24-C wipe uniqueness stays. B26-B toast pins stay. Exclusive files only. No commit. Lane is not signed.

`UI:Init` early-return (`if self.frame then`) still calls `rememberSpecial(FRAME_NAME)`, then `wireShellOnHide(self.frame)`. The helper wires only when `GetScript("OnHide")` is nil. Create path calls the same helper. An existing script is not replaced. OnShow is not re-wired. No rebuild.

**Isolated count:** 548 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B27-C pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). B24-C early-return pin now allows `wireShellOnHide`; still no inline `SetScript` / OnShow re-wire / rebuild. Source pin: helper holds `_StopSizing` + `shown = false`. Nil OnHide, second Init restores the script; third Init keeps identity. Restored handler still stops sizing and persists `shown = false`. Wipe `UISpecialFrames` uniqueness / B24-C rememberSpecial / B26-B toast pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/MainFrame.lua` | Extracted `wireShellOnHide(frame)`. Early-return `rememberSpecial`s then calls the helper. Create path calls the same helper. Does not replace an existing script. Does not re-wire OnShow. Does not rebuild. No `PlaySound`. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. |
| `docs/reformation/vestments/briefs/B27-C-shell-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B27-C-shell-onhide.diff` | B27-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts.lua, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound` / `IG_CHARACTER_INFO_*`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Quiet-shell / toast batches (working tree already dirty). The brief diff is the B27-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` early-return | `rememberSpecial(FRAME_NAME)` then `wireShellOnHide(self.frame)`; return the existing frame. |
| `wireShellOnHide` | If `GetScript("OnHide")` is nil, wire `_StopSizing()` then `ui.shown = false`. Do not replace an existing script. |
| Create path | Same helper after OnShow. Then `rememberSpecial(FRAME_NAME)`. |
| Wipe remount | `UISpecialFrames = {}` then second Init lists `ChurchOfBeefFrame` exactly once. Existing OnHide identity stays. |
| Missing OnHide remount | `SetScript("OnHide", nil)` then second Init restores the handler. Third Init keeps identity. |
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
- B24-C wipe uniqueness / existing-script identity / no OnShow re-wire.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: `wireShellOnHide` source; early-return calls the helper and does not `SetScript` inline; nil OnHide then second Init restores; third Init identity stays; restored handler still `_StopSizing`s / persists `shown = false`). Isolation wrap and wipe uniqueness pins untouched except the B24-C early-return source pin now expects the helper call.
2. Red: `lua tests/test_ui.lua` — **539 passed, 9 failed** (`wireShellOnHide` missing; early-return source missing the helper; niled OnHide stayed nil after second Init; Hide without a handler left `shown` true and `_sizing` true). Wipe uniqueness / existing-script identity / OnShow / B26-B toast / isolation pins stayed green.
3. Extracted `wireShellOnHide(frame)`. Early-return and create both call it. Existing script is not replaced. OnShow is not re-wired.
4. Green: `lua tests/test_ui.lua` — **548 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 548 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **548 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Decree / glue / TOC were not edited.
- Early-return re-registers `ChurchOfBeefFrame` and restores a missing OnHide. An existing script is not replaced.
- Wipe-to-empty then second Init lists the name exactly once. Third Init still once.
- Restored OnHide still calls `_StopSizing` and persists `shown = false`. No `PlaySound`. OnShow is not re-wired.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **Early-return still does not restore a missing OnShow.** Only OnHide is remounted. A remount that dropped OnShow would skip `shown = true` and the roster kick. Outside this brief.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts and script identity are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **548 / 0**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
