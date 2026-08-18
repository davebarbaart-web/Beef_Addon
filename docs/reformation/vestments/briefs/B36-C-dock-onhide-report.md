# B36-C — ConsoleDock Hide remounts missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console; B30 leftover (`Hide` remounted `rememberSpecial` then `paint(false)` only; a niled OnHide then ESC / `frame:Hide()` left `shown` true and dismiss unset; next Refresh painted the dock again); brief `docs/reformation/vestments/briefs/B36-C-dock-onhide.md`. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. Per-event dismiss (B24-B) stays. B30-D Hide `rememberSpecial` remount stays. B27-D Show / Refresh remount stays. B26-D Init remount stays. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. No sound. Exclusive files only. No commit. Lane is not signed.

Extracted `wireDockOnHide` (never replace an existing script; no OnShow). Existing-frame `Hide`: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `paint(false)`. Create-path calls the helper after create-time `widget:Hide()`. Does not rebuild. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`.

**Isolated count:** 563 passed, 0 failed (`lua tests/test_console_dock.lua`). Isolation wrap stays under `if standalone then` at file load (**24** nil pins). Nested `runB36C()` inside `runB27D()` after `runB30D()`. No new main-chunk locals (create-path order pin reused `hideAt` / `onHideAt`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | Nested `runB36C()` inside `runB27D()` after `runB30D()` (no new main-chunk locals). Source pin: Hide remounts via `wireDockOnHide` before `rememberSpecial(FRAME_NAME)` then `paint(false)`. Helper never replaces; no OnShow / `PlaySound` / `IG_CHARACTER_INFO_*` / rebuild. Create-path order pin now checks `widget:Hide()` then `wireDockOnHide` inside `build()`. Wipe list, nil OnHide, Show a live dock, Hide: OnHide restored, `GetView().shown == false`, live dismiss set (same-event Refresh stays hidden), `ChurchOfBeefConsoleDock` re-listed once, no sound, no rebuild. Third Hide does not replace OnHide. Show / Refresh / Init remount do not remount OnHide. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | Extracted `wireDockOnHide` (never replace an existing script; no OnShow). Create-path calls it after create-time Hide. Existing-frame `Hide` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `paint(false)`. Does not rebuild. Does not Show. Header notes the remount. No `PlaySound`. No parchment. |
| `docs/reformation/vestments/briefs/B36-C-dock-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B36-C-dock-onhide.diff` | B36-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not add parchment. Did not change per-event dismiss. Did not change Init / Show / Refresh remount. Did not commit.

`git diff HEAD` on these two files also includes earlier ConsoleDock batches (working tree already dirty). The brief diff is the B36-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `wireDockOnHide` | If `GetScript("OnHide")` is nil, wire: `lastView.shown = false` and live `dismissedEventId` when the event is live. Do not replace an existing script. Do not wire OnShow. |
| `Hide` (frame exists) | `wireDockOnHide(frame)` then `rememberSpecial(FRAME_NAME)` then `paint(false)`. Same frame pointer. |
| `Hide` (no frame) | Unchanged. `paint(false)` only. |
| `build()` | Unchanged except create-path calls `wireDockOnHide(widget)` after create-time `widget:Hide()`. |
| `Refresh` existing-frame | Unchanged. Still remount `rememberSpecial` (B27-D). Does not remount OnHide. |
| `Show` existing-frame | Unchanged. Still remount `rememberSpecial` (B27-D). Does not remount OnHide. Does not re-wire OnShow. |
| `Init` remount | Unchanged (B26-D). Existing-frame Init still remounts `rememberSpecial` then Refresh. Does not remount OnHide. |
| Wipe remount | `UISpecialFrames = {}` then nil OnHide, Show live, Hide lists `ChurchOfBeefConsoleDock` exactly once. |
| Rebuild | Existing-frame Hide does not call `build()` / `CreateFrame` / `Show`. |
| Dismiss | B24-B `eventId` key stays. Same-event Hide + Refresh stays hidden (live dismiss set). |
| Sound / dress | None. No `PlaySound`. No `IG_CHARACTER_INFO_*`. No parchment. Title stays `DIRECTOR CONSOLE`. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. Persist `ChurchOfBeefDB.ui.consoleDock`.
- Per-event dismiss (B24-B). Hide is not EndEvent. No dismiss-cooldown.
- B30-D Hide `rememberSpecial` remount. B27-D Show / Refresh remount. B26-D Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- Isolation wrap. Event-only show. `mayShow` = live event + registered Pope.
- No new main-chunk locals in `test_console_dock.lua`.

## TDD

1. Extended `tests/test_console_dock.lua` (`runB36C()` nested inside `runB27D()` after `runB30D()`: Hide remount body has `wireDockOnHide` then `rememberSpecial(FRAME_NAME)` then `paint(false)`; helper never replaces; no OnShow / rebuild / `PlaySound`; wipe list, nil OnHide, Show live, Hide restores OnHide and sets live dismiss; third Hide keeps identity). Create-path OnHide order pin reused `hideAt` / `onHideAt` (no new main-chunk locals). Isolation wrap and existing persist / per-event dismiss / Init / Show / Refresh / Hide remount pins untouched except that order pin.
2. Extracted `wireDockOnHide`. Existing-frame `Hide` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `paint(false)`. Create-path calls the helper after create-time Hide. Show / Refresh / Init remount kept.
3. Green: `lua tests/test_console_dock.lua` — **563 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 563 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **563 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 563 passed, 0 failed. Isolation wrap stays (24 nil pins at file load). Wrap pattern unchanged. `runB36C()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / glue / TOC not edited.
- Existing-frame `Hide` remounts a missing OnHide, re-registers `ChurchOfBeefConsoleDock`, and does not rebuild. An existing script is not replaced.
- Wipe-to-empty then live Show + Hide lists the name exactly once. Same frame pointer. Third Hide keeps OnHide identity.
- Per-event dismiss stays. Same-event Hide + Refresh stays hidden. B30-D Hide `rememberSpecial` remount stays. B27-D Show / Refresh remount stays. B26-D Init remount stays.
- Title / SANCTION / Expand / hidden CloseButton / persist / no-sound / no-parchment stay. No OnShow re-wire.
- `runB36C()` is nested inside `runB27D()` after `runB30D()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `ConsoleDock:Hide`. A dropped OnHide that never hits `ConsoleDock:Hide` still leaves `shown` true and dismiss unset; next Refresh paints the dock again.
- **Show / Refresh / Init remount do not remount OnHide.** Brief asked Hide-only remount and no OnShow re-wire. A niled handler that only hits Show / Refresh / Init stays idle.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` in this suite is a direct call**, not a real ESC key. Script identity, dismiss, and membership counts are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **563 / 0**. Isolation wrap **24**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
