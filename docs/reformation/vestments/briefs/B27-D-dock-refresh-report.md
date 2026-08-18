# B27-D — Dock Refresh / Show remount ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do not PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console; B26 leftover (`Refresh` / `Show` skipped `rememberSpecial`; a wiped list then Refresh-only or Show-only never put `ChurchOfBeefConsoleDock` back); brief `docs/reformation/vestments/briefs/B27-D-dock-refresh.md`. Per-event dismiss (B24-B) stays. B26-D Init remount stays. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. No sound. Exclusive files only. No commit. Lane is not signed.

When the frame already exists, `ConsoleDock:Refresh` and `ConsoleDock:Show` call `rememberSpecial(FRAME_NAME)`. They do not rebuild. Create-via-Refresh still gets the name from `build()`; the extra call is fine (deduped). Wipe `UISpecialFrames` to `{}` then Refresh-only lists `ChurchOfBeefConsoleDock` exactly once. Wipe again, Show-only lists it once. Same frame pointer. Same-event Hide + Refresh stays hidden.

**Isolated count:** 414 passed, 0 failed (`lua tests/test_console_dock.lua`). Isolation wrap stays under `if standalone then` at file load (**24** nil pins). Nested `runB27D()` after `runB26D()`. One new main-chunk local (`runB27D`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | TDD first. Nested `runB27D()` after `runB26D()`. Source pin: existing-frame Refresh remount body (after nil-frame `GetView` return … before `mayShow`) has `rememberSpecial(FRAME_NAME)`, no `build()` / `CreateFrame` / `PlaySound`. Existing-frame Show remount body (after nil-frame `return false` … before `mayShow`) has `rememberSpecial(FRAME_NAME)`, no `build()` / `CreateFrame` / `Init()` / `PlaySound`. B26-D Init remount body stays. Init, wipe `UISpecialFrames` to `{}`, Refresh-only: `ChurchOfBeefConsoleDock` listed exactly once. Wipe again, Show-only: listed once. Same frame pointer. Wrapped `CreateFrame` saw 0 calls. B24-B same-event Hide + Refresh stays hidden. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | Existing-frame `Refresh` and `Show` call `rememberSpecial(FRAME_NAME)`. Do not rebuild. `build()` and Init remount stay. No `PlaySound`. No parchment. Header notes the remount. |
| `docs/reformation/vestments/briefs/B27-D-dock-refresh-report.md` | This file |
| `docs/reformation/vestments/briefs/B27-D-dock-refresh.diff` | B27-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not add parchment. Did not change per-event dismiss. Did not change Init remount. Did not commit.

`git diff HEAD` on these two files also includes earlier ConsoleDock batches (working tree already dirty). The brief diff is the B27-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Refresh` existing-frame | `rememberSpecial(FRAME_NAME)` after the nil-frame return. Same frame pointer. |
| `Show` existing-frame | `rememberSpecial(FRAME_NAME)` after the nil-frame return. Same frame pointer. |
| Create path | Unchanged. `build()` still calls `rememberSpecial(FRAME_NAME)` once. Create-via-Refresh still registers there; the extra call is fine. |
| `Init` remount | Unchanged (B26-D). Existing-frame Init still remounts then Refresh. |
| Wipe remount | `UISpecialFrames = {}` then Refresh-only lists `ChurchOfBeefConsoleDock` exactly once. Wipe again, Show-only lists it once. |
| Rebuild | Existing-frame Refresh / Show do not call `build()` / `CreateFrame`. |
| Dismiss | B24-B `eventId` key stays. Same-event Hide + Refresh stays hidden. |
| Sound / dress | None. No `PlaySound`. No parchment. Title stays `DIRECTOR CONSOLE`. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. Persist `ChurchOfBeefDB.ui.consoleDock`.
- Per-event dismiss (B24-B). Hide is not EndEvent. No dismiss-cooldown.
- B26-D Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- Isolation wrap. Event-only show. `mayShow` = live event + registered Pope.

## TDD

1. Extended `tests/test_console_dock.lua` first (`runB27D()` after `runB26D()`: Refresh / Show remount bodies have `rememberSpecial(FRAME_NAME)`; Init, wipe `UISpecialFrames` to `{}`, Refresh-only lists the name once; wipe again, Show-only lists once; same frame pointer; no rebuild; B24-B same-event dismiss stays; B26-D Init remount stays; persist / ESC / isolation). Isolation wrap and existing persist / per-event dismiss / Init remount pins untouched.
2. Red: `lua tests/test_console_dock.lua` — **408 passed, 6 failed** (Refresh / Show remount bodies missing `rememberSpecial(FRAME_NAME)`; wiped list stayed 0 after Refresh-only and Show-only). Same-frame / no-rebuild / B24-B dismiss / B26-D Init remount / persist pins stayed green.
3. Existing-frame `Refresh` and `Show` call `rememberSpecial(FRAME_NAME)`. `build()` and Init remount kept.
4. Green: `lua tests/test_console_dock.lua` — **414 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 414 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **414 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 414 passed, 0 failed. Isolation wrap stays (24 nil pins at file load). Wrap pattern unchanged. `runB27D()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / glue / TOC not edited.
- Existing-frame `Refresh` / `Show` re-register `ChurchOfBeefConsoleDock` and do not rebuild.
- Wipe-to-empty then Refresh-only lists the name exactly once. Wipe again, Show-only lists once. Same frame pointer.
- Per-event dismiss stays. Same-event Hide + Refresh stays hidden. B26-D Init remount stays.
- Title / SANCTION / Expand / hidden CloseButton / persist / no-sound / no-parchment stay.
- `runB27D()` is nested after `runB26D()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness membership counts are pinned;** the client's special-frame walk is not. `Hide()` in this suite is a direct call, not a real ESC key.
- **Parked Console leftover** (overview): selected-pair inherit of Core `namedOpponent`. Sibling B27-A, not this lane.

## Status

**DONE_WITH_CONCERNS.** Isolated **414 / 0**. Isolation wrap **24**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
