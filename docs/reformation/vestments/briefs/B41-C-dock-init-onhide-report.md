# B41-C — ConsoleDock Init remounts missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console; B40-C leftover (`Init` remounted `rememberSpecial` then Refresh; a niled OnHide stayed idle in the Init remount body until Refresh as a side effect); brief `docs/reformation/vestments/briefs/B41-C-dock-init-onhide.md`. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. Per-event dismiss (B24-B) stays. B40-C Refresh OnHide remount stays. B39-D Show OnHide remount stays. B36-C Hide OnHide remount stays. B30-D Hide `rememberSpecial` remount stays. B27-D Show / Refresh remount stays. B26-D Init remount stays. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. No sound. Exclusive files only. No commit. Lane is not signed.

Existing-frame `Init`: remount missing OnHide via `wireDockOnHide`, then `rememberSpecial(FRAME_NAME)`, then Refresh (Refresh remount stays). Never replace an existing script. Does not reset drag persist. Does not pop a dismissed dock. Does not rebuild. No OnShow re-wire. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`.

**Isolated count:** 775 passed, 0 failed (`lua tests/test_console_dock.lua`). Isolation wrap stays under `if standalone then` at file load (**24** nil pins). Nested `runB41C()` inside `runB27D()` after `runB40C()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | Nested `runB41C()` inside `runB27D()` after `runB40C()` (no new main-chunk locals). Updated the B36-C, B39-D, and B40-C keep-strings that forbade `wireDockOnHide` in Init. Source pin: Init remounts via `wireDockOnHide` before `rememberSpecial(FRAME_NAME)` then `self:Refresh()`. Helper never replaces; no OnShow / `PlaySound` / `IG_CHARACTER_INFO_*` / rebuild / persist reset. Wipe list, nil OnHide, Init: OnHide restored, dismissed dock stays hidden, `ChurchOfBeefConsoleDock` re-listed once, no sound, no rebuild, drag point unchanged. Third Init does not replace OnHide. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | Existing-frame `Init` remounts missing OnHide (`wireDockOnHide(frame)`), then `rememberSpecial(FRAME_NAME)`, then Refresh. Does not replace an existing script. Does not reset drag persist. Does not pop a dismissed dock. Does not rebuild. Header notes the remount. No `PlaySound`. No parchment. |
| `docs/reformation/vestments/briefs/B41-C-dock-init-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B41-C-dock-init-onhide.diff` | B41-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not add parchment. Did not reset drag persist. Did not commit.

`git diff HEAD` on these two files also includes earlier ConsoleDock batches (working tree already dirty). The brief diff is the B41-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` (frame exists) | `wireDockOnHide(frame)` then `rememberSpecial(FRAME_NAME)` then `self:Refresh()`. Same frame pointer. |
| `Init` (no frame) | Unchanged. `build()` then the remount body (or `return nil` if `CreateFrame` is missing). |
| `wireDockOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire: `lastView.shown = false` and live `dismissedEventId` when the event is live. Do not replace an existing script. Do not wire OnShow. |
| `Refresh` (frame exists) | Unchanged (B40-C). `wireDockOnHide` then `rememberSpecial(FRAME_NAME)` then `mayShow` / `stayDismissed` / `paint`. |
| `Show` (frame exists) | Unchanged (B39-D). `wireDockOnHide` then `rememberSpecial(FRAME_NAME)` then `mayShow` / `paint`. |
| `Hide` (frame exists) | Unchanged (B36-C). `wireDockOnHide` then `rememberSpecial(FRAME_NAME)` then `paint(false)`. |
| Wipe remount | `UISpecialFrames = {}` then nil OnHide, Init lists `ChurchOfBeefConsoleDock` exactly once. |
| Dismiss | Same-event widget Hide then Init stays hidden. Init remount does not pop (Refresh keep). |
| Rebuild | Existing-frame Init does not call `build()` / `CreateFrame`. |
| Persist | Init remount does not `restorePoint` / `savePoint` / assign `consoleDock`. Drag point stays. |
| Sound / dress | None. No `PlaySound`. No `IG_CHARACTER_INFO_*`. No parchment. Title stays `DIRECTOR CONSOLE`. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. Persist `ChurchOfBeefDB.ui.consoleDock`.
- Per-event dismiss (B24-B). Hide is not EndEvent. No dismiss-cooldown.
- B40-C Refresh OnHide remount. B39-D Show OnHide remount. B36-C Hide OnHide remount. B30-D Hide `rememberSpecial` remount. B27-D Show remount. B26-D Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- Isolation wrap. Event-only show. `mayShow` = live event + registered Pope.
- No new main-chunk locals in `test_console_dock.lua`.

## TDD

1. Extended `tests/test_console_dock.lua` (`runB41C()` nested inside `runB27D()` after `runB40C()`: Init remount body has `wireDockOnHide` then `rememberSpecial(FRAME_NAME)` then `self:Refresh()`; helper never replaces; no OnShow / rebuild / `PlaySound` / persist reset; wipe list, nil OnHide, Init restores OnHide, re-lists once, and stays dismissed; third Init keeps identity). Updated the B36-C, B39-D, and B40-C keep-strings that pinned Init has no `wireDockOnHide`. Isolation wrap and existing persist / per-event dismiss / Refresh / Show / Hide remount pins stay.
2. Existing-frame `Init` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then Refresh. Show / Hide / Refresh remount kept. Drag persist not reset. Dismissed dock stays hidden.
3. Green: `lua tests/test_console_dock.lua` — **775 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 775 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **775 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 775 passed, 0 failed. Isolation wrap stays (24 nil pins at file load). Wrap pattern unchanged. `runB41C()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / glue / MainFrame / TOC not edited.
- Existing-frame `Init` remounts a missing OnHide, re-registers `ChurchOfBeefConsoleDock`, Refreshs, and does not rebuild. An existing script is not replaced.
- Wipe-to-empty then dismissed Init lists the name exactly once. Same frame pointer. Third Init keeps OnHide identity. Drag point stays. Dismissed dock stays hidden.
- Per-event dismiss stays. B40-C Refresh OnHide remount stays. B39-D Show OnHide remount stays. B36-C Hide OnHide remount stays. B30-D Hide `rememberSpecial` remount stays. B27-D Show remount stays. B26-D Init remount stays.
- Title / SANCTION / Expand / hidden CloseButton / persist / no-sound / no-parchment stay. No OnShow re-wire.
- `runB41C()` is nested inside `runB27D()` after `runB40C()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `ConsoleDock:Init` / `Hide` / `Show` / `Refresh`. A dropped OnHide that never hits those verbs still leaves `shown` true and dismiss unset; the next Init remounts the handler then Refreshs, and paints the dock again because dismiss was never recorded.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Init()` in this suite is a direct call**, not a real ESC key. Script identity, membership counts, dismiss stay, and drag point are pinned; the client's special-frame walk is not.
- **Third-Init identity is vacuous if restore failed.** `nil == nil` would pass; the restore pin fails first.
- **Nested persist pin is widget `GetPoint`, not the SV table.** Default Init point is `BOTTOMLEFT` 16, 80.
- **B36-C / B39-D / B40-C keep-strings were updated in place** so the prior forbid-`wireDockOnHide` pins do not keep the suite red.

## Status

**DONE_WITH_CONCERNS.** Isolated **775 / 0**. Isolation wrap **24**. Not signed. No Gate / **POLISH:PASS** claim.
