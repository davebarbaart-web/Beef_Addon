# B39-D — ConsoleDock Show remounts missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console; B36-C leftover (`Show` remounted `rememberSpecial` only; a niled OnHide stayed idle until Hide); brief `docs/reformation/vestments/briefs/B39-D-dock-show-onhide.md`. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. Per-event dismiss (B24-B) stays. B36-C Hide OnHide remount stays. B30-D Hide `rememberSpecial` remount stays. B27-D Show / Refresh remount stays. B26-D Init remount stays. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. No sound. Exclusive files only. No commit. Lane is not signed.

Existing-frame `Show`: remount missing OnHide via `wireDockOnHide`, then `rememberSpecial(FRAME_NAME)`. Never replace an existing script. Does not reset drag persist. Does not rebuild. No OnShow re-wire. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`.

**Isolated count:** 630 passed, 0 failed (`lua tests/test_console_dock.lua`). Isolation wrap stays under `if standalone then` at file load (**24** nil pins). Nested `runB39D()` inside `runB27D()` after `runB36C()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | Nested `runB39D()` inside `runB27D()` after `runB36C()` (no new main-chunk locals). Updated the B36-C keep-string that forbade `wireDockOnHide` in Show (source + live nile). Source pin: Show remounts via `wireDockOnHide` before `rememberSpecial(FRAME_NAME)`. Helper never replaces; no OnShow / `PlaySound` / `IG_CHARACTER_INFO_*` / rebuild / persist reset. Wipe list, nil OnHide, Show: OnHide restored, `ChurchOfBeefConsoleDock` re-listed once, no sound, no rebuild, drag point unchanged. Third Show does not replace OnHide. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | Existing-frame `Show` remounts missing OnHide (`wireDockOnHide(frame)`), then `rememberSpecial(FRAME_NAME)`. Does not replace an existing script. Does not reset drag persist. Does not rebuild. Header notes the remount. No `PlaySound`. No parchment. |
| `docs/reformation/vestments/briefs/B39-D-dock-show-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B39-D-dock-show-onhide.diff` | B39-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not add parchment. Did not reset drag persist. Did not commit.

`git diff HEAD` on these two files also includes earlier ConsoleDock batches (working tree already dirty). The brief diff is the B39-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Show` (frame exists) | `wireDockOnHide(frame)` then `rememberSpecial(FRAME_NAME)` then `mayShow` / `paint`. Same frame pointer. |
| `Show` (no frame) | Unchanged. `Init()` then the exists-path, or `hiddenView` + false. |
| `wireDockOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire: `lastView.shown = false` and live `dismissedEventId` when the event is live. Do not replace an existing script. Do not wire OnShow. |
| `Hide` (frame exists) | Unchanged (B36-C). `wireDockOnHide` then `rememberSpecial(FRAME_NAME)` then `paint(false)`. |
| `Refresh` existing-frame | Unchanged. Still remount `rememberSpecial` (B27-D). Does not remount OnHide. |
| `Init` remount | Unchanged (B26-D). Existing-frame Init still remounts `rememberSpecial` then Refresh. Does not remount OnHide. |
| Wipe remount | `UISpecialFrames = {}` then nil OnHide, Show lists `ChurchOfBeefConsoleDock` exactly once. |
| Rebuild | Existing-frame Show does not call `build()` / `CreateFrame` / `Init()`. |
| Persist | Show remount does not `restorePoint` / `savePoint` / assign `consoleDock`. Drag point stays. |
| Sound / dress | None. No `PlaySound`. No `IG_CHARACTER_INFO_*`. No parchment. Title stays `DIRECTOR CONSOLE`. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. Persist `ChurchOfBeefDB.ui.consoleDock`.
- Per-event dismiss (B24-B). Hide is not EndEvent. No dismiss-cooldown.
- B36-C Hide OnHide remount. B30-D Hide `rememberSpecial` remount. B27-D Refresh remount. B26-D Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- Isolation wrap. Event-only show. `mayShow` = live event + registered Pope.
- No new main-chunk locals in `test_console_dock.lua`.

## TDD

1. Extended `tests/test_console_dock.lua` (`runB39D()` nested inside `runB27D()` after `runB36C()`: Show remount body has `wireDockOnHide` then `rememberSpecial(FRAME_NAME)`; helper never replaces; no OnShow / rebuild / `PlaySound` / persist reset; wipe list, nil OnHide, Show restores OnHide and re-lists once; third Show keeps identity). Updated the B36-C keep-string that pinned Show has no `wireDockOnHide`. Isolation wrap and existing persist / per-event dismiss / Init / Refresh / Hide remount pins stay.
2. Existing-frame `Show` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`. Hide / Refresh / Init remount kept. Drag persist not reset.
3. Green: `lua tests/test_console_dock.lua` — **630 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 630 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **630 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 630 passed, 0 failed. Isolation wrap stays (24 nil pins at file load). Wrap pattern unchanged. `runB39D()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / glue / MainFrame / TOC not edited.
- Existing-frame `Show` remounts a missing OnHide, re-registers `ChurchOfBeefConsoleDock`, and does not rebuild. An existing script is not replaced.
- Wipe-to-empty then live Show lists the name exactly once. Same frame pointer. Third Show keeps OnHide identity. Drag point stays.
- Per-event dismiss stays. B36-C Hide OnHide remount stays. B30-D Hide `rememberSpecial` remount stays. B27-D Refresh remount stays. B26-D Init remount stays.
- Title / SANCTION / Expand / hidden CloseButton / persist / no-sound / no-parchment stay. No OnShow re-wire.
- `runB39D()` is nested inside `runB27D()` after `runB36C()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Refresh / Init remount still skip a niled OnHide.** Brief asked Show-only remount and no OnShow re-wire. A niled handler that only hits Refresh or Init stays idle until Show or Hide.
- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `ConsoleDock:Hide` and `ConsoleDock:Show`. A dropped OnHide that never hits those verbs still leaves `shown` true and dismiss unset; next Refresh paints the dock again.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Show()` in this suite is a direct call**, not a real ESC key. Script identity, membership counts, and drag point are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **630 / 0**. Isolation wrap **24**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
