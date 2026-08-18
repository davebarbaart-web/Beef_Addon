# B40-D — already-hidden Quiet-shell Hide still persists shown = false (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`); B35-D leftover (already-hidden Hide remounts OnHide but leaves stale `shown` because the stub and the client only fire OnHide on a shown→hidden transition); brief `docs/reformation/vestments/briefs/B40-D-shell-hidden-persist.md`. B35-D Hide remount stays. B31-C Show remount stays. B27-C Init remount stays. Exclusive files only. No commit. Lane is not signed.

When the frame exists, `UI:Hide` still remounts `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before `_StopSizing` + `self.frame:Hide()`. After remount it writes `shown = false` on the ui slot via the same `uiDb()` as OnHide, even when the widget is already hidden. The helper still wires only when `GetScript("OnHide")` is nil. An existing script is not replaced. The widget is not rebuilt. OnShow is not re-wired. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. Inputs stay off `UISpecialFrames`.

**Isolated count:** 642 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the load-time `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B40-D pins inside `runB12D()` after the B35-D block (Lua 5.1 200-local cap; no new main-chunk locals; no new `runB12D` locals — reused `hideBody` / `hideWireAt` / `hideRememberAt` / `hideOnShow` / `existingHideShell` / `cuesHideRestore` / `restoredHideOnHide`). Source pin: Hide body writes `shown = false` via `uiDb()` after remount; still no inline `SetScript` / OnShow re-wire / rebuild / `PlaySound`. Runtime: already-hidden + niled OnHide + stale `shown = true` then `UI:Hide()` remounts the handler and persists `shown == false` even though OnHide does not fire. Second already-hidden Hide does not replace OnHide. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/MainFrame.lua` | Exists-path `Hide` writes `local ui = uiDb()` / `if ui then ui.shown = false end` after remount + `_StopSizing` + `self.frame:Hide()`. Does not replace an existing OnHide. Does not rebuild. No OnShow re-wire. No `PlaySound`. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. |
| `docs/reformation/vestments/briefs/B40-D-shell-hidden-persist-report.md` | This file |
| `docs/reformation/vestments/briefs/B40-D-shell-hidden-persist.diff` | B40-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts.lua, RecordsBook, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound` / `IG_CHARACTER_INFO_*`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Quiet-shell / toast batches (working tree already dirty). The brief diff is the B40-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Hide` exists-path | `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `_StopSizing` then `self.frame:Hide()` then `uiDb()` / `ui.shown = false`. |
| `wireShellOnHide` | If `GetScript("OnHide")` is nil, wire `_StopSizing()` then `ui.shown = false`. Do not replace an existing script. Unchanged. ESC persist stays the remounted handler. |
| `rememberSpecial` | Scan-then-append `FRAME_NAME`. Unchanged. |
| Already-hidden Hide | Body write persists `shown = false` even when `frame:Hide()` does not fire OnHide. |
| Show remount | B31-C pair stays. |
| Init remount | Early-return still `rememberSpecial` then `wireShellOnHide`. Create path unchanged. |
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
- B35-D Quiet-shell Hide remount of a missing OnHide.
- B39-C HideAll remount of toast + proclaim ESC names.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()` after B35-D: Hide body writes `shown = false` via `uiDb()` after remount; already-hidden + niled OnHide + stale `shown = true` then Hide persists `shown == false`; remount still restores OnHide; second Hide identity stays; Inputs stay off the list). Isolation wrap and B35-D remount pins untouched.
2. Red: `lua tests/test_ui.lua` — **636 passed, 6 failed** (Hide body missing `uiDb()` / `shown = false`; already-hidden + niled OnHide left `shown` true). B35-D remount / B31-C Show / B27-C Init / B26-B toast / isolation pins stayed green.
3. Exists-path `Hide` writes `local ui = uiDb()` / `if ui then ui.shown = false end` after remount + `_StopSizing` + `self.frame:Hide()`. Existing script is not replaced. Widget is not rebuilt. OnHide remount kept.
4. Green: `lua tests/test_ui.lua` — **642 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 642 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **642 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under the load-time `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora. Main-chunk locals: **75 / 200**. `runB12D()` locals: **56 / 200**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / RecordsBook / Decree / glue / TOC were not edited.
- Exists-path `Hide` still remounts OnHide for ESC, then writes `shown = false` via `uiDb()` so an already-hidden widget does not leave a stale `shown = true`.
- An existing script is not replaced. The widget is not rebuilt. OnShow is not re-wired. No `PlaySound`. Inputs stay off the list.
- New asserts reuse B35-D locals inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **Hide / Show / Init still do not restore a missing OnShow.** Brief forbids OnShow re-wire. A remount that dropped OnShow would skip `shown = true` and the roster kick. Outside this brief.
- **B35-D persist pin no longer exclusively exercises remounted OnHide.** Hide body now writes `shown = false`, so the B35-D "Hide remount persists shown = false" pin passes even if the remounted handler forgot that write. ESC persist still depends on the remounted handler. The already-hidden pin is the body-write proof.
- **Source pin does not lock persist after `frame:Hide` vs before.** It requires `uiDb()` after remount. Live order is remount then `_StopSizing` then `frame:Hide()` then the write.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. Harness `Hide()` is a direct call, not a real ESC key.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then` (not the first helper `if standalone then`). `runB12D()` re-pins four.
- **Inputs-off pin does not load Inputs.** Isolation never `dofile`s `Inputs.lua`. The pin still fails if Hide listed `"ChurchOfBeefInputs"`.
- **`UISpecialFrames = nil` and stub `_G["ChurchOfBeefFrame"]` stay unpinned.** `rememberSpecial` no-ops when the global is not a table. Stub `CreateFrame` still does not mint `_G.ChurchOfBeefFrame`.
- **Exclusive-pair diff is not a vs-HEAD MainFrame delta.** Packet is the B40-D-only persist write + nested pins. `git diff HEAD` on the two files still includes earlier Quiet-shell / toast / HideAll batches.

## Status

**DONE_WITH_CONCERNS.** Isolated **642 / 0**. Not signed. No Gate W / Gate V / **POLISH:PASS** claim.
