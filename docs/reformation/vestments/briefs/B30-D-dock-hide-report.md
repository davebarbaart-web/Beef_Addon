# B30-D — Event dock Hide remounts ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do not PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console; B27 leftover (`Hide` skipped `rememberSpecial`; a wiped list then Hide-only never put `ChurchOfBeefConsoleDock` back); brief `docs/reformation/vestments/briefs/B30-D-dock-hide.md`. Per-event dismiss (B24-B) stays. B27-D Show / Refresh remount stays. B26-D Init remount stays. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. No sound. Exclusive files only. No commit. Lane is not signed.

When the frame already exists, `ConsoleDock:Hide` calls `rememberSpecial(FRAME_NAME)` then `paint(false)`. It does not rebuild. It does not Show. Create-path uniqueness still dedupes (`rememberSpecial` scan-then-append from `build()`). Show / Refresh remount (B27-D) stays. Init remount (B26-D) stays. Same-event Hide + Refresh stays hidden.

**Isolated count:** 476 passed, 0 failed (`lua tests/test_console_dock.lua`). Isolation wrap stays under `if standalone then` at file load (**24** nil pins). Nested `runB30D()` inside `runB27D()` after the B27-D isolation wrap. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | TDD first. Nested `runB30D()` inside `runB27D()` after the B27-D isolation wrap (no new main-chunk locals). Source pin: Hide remount body has `rememberSpecial(FRAME_NAME)` then `paint(false)`, no `build()` / `CreateFrame` / `PlaySound` / `Show`. B27-D Show / Refresh remount source pins stay. B26-D Init remount source pin stays. Init, wipe `UISpecialFrames` to `{}`, Hide: `ChurchOfBeefConsoleDock` listed exactly once. Same frame pointer. Wrapped `CreateFrame` saw 0 calls. B27-D wiped Refresh-only / Show-only still list once. B24-B same-event Hide + Refresh stays hidden. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | Existing-frame `Hide` calls `rememberSpecial(FRAME_NAME)` then `paint(false)`. Do not rebuild. Do not Show. `build()` and Init / Show / Refresh remount stay. Header notes Hide remount. No `PlaySound`. No parchment. |
| `docs/reformation/vestments/briefs/B30-D-dock-hide-report.md` | This file |
| `docs/reformation/vestments/briefs/B30-D-dock-hide.diff` | B30-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not add parchment. Did not change per-event dismiss. Did not change Init / Show / Refresh remount. Did not commit.

`git diff HEAD` on these two files also includes earlier ConsoleDock batches (working tree already dirty). The brief diff is the B30-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Hide` (frame exists) | `rememberSpecial(FRAME_NAME)` then `paint(false)`. Same frame pointer. |
| `Hide` (no frame) | Unchanged. `paint(false)` only. |
| `Refresh` existing-frame | Unchanged. Still remount (B27-D). |
| `Show` existing-frame | Unchanged. Still remount (B27-D). |
| `Init` remount | Unchanged (B26-D). Existing-frame Init still remounts then Refresh. |
| Create path | Unchanged. `build()` still calls `rememberSpecial(FRAME_NAME)` once. |
| Wipe remount | `UISpecialFrames = {}` then Hide lists `ChurchOfBeefConsoleDock` exactly once. |
| Rebuild | Existing-frame Hide does not call `build()` / `CreateFrame` / `Show`. |
| Dismiss | B24-B `eventId` key stays. Same-event Hide + Refresh stays hidden. |
| Sound / dress | None. No `PlaySound`. No parchment. Title stays `DIRECTOR CONSOLE`. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. Persist `ChurchOfBeefDB.ui.consoleDock`.
- Per-event dismiss (B24-B). Hide is not EndEvent. No dismiss-cooldown.
- B27-D Show / Refresh remount. B26-D Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- Isolation wrap. Event-only show. `mayShow` = live event + registered Pope.
- No new main-chunk locals in `test_console_dock.lua`.

## TDD

1. Extended `tests/test_console_dock.lua` first (`runB30D()` nested inside `runB27D()` after the B27-D isolation wrap: Hide remount body has `rememberSpecial(FRAME_NAME)` then `paint(false)`; Init, wipe `UISpecialFrames` to `{}`, Hide lists the name once; same frame pointer; no rebuild; B27-D Show/Refresh remount stays; B26-D Init remount stays; B24-B same-event dismiss stays; persist / ESC / isolation). Isolation wrap and existing persist / per-event dismiss / Init / Show / Refresh remount pins untouched.
2. Red: `lua tests/test_console_dock.lua` — **474 passed, 2 failed** (Hide remount body missing `rememberSpecial(FRAME_NAME)`; wiped list stayed 0 after Hide). Same-frame / no-rebuild / B27-D Show/Refresh / B26-D Init remount / B24-B dismiss / persist pins stayed green.
3. Existing-frame `Hide` calls `rememberSpecial(FRAME_NAME)` then `paint(false)`. `build()` and Init / Show / Refresh remount kept.
4. Green: `lua tests/test_console_dock.lua` — **476 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 476 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **476 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 476 passed, 0 failed. Isolation wrap stays (24 nil pins at file load). Wrap pattern unchanged. `runB30D()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / glue / TOC not edited.
- Existing-frame `Hide` re-registers `ChurchOfBeefConsoleDock` and does not rebuild.
- Wipe-to-empty then Hide lists the name exactly once. Same frame pointer.
- Per-event dismiss stays. Same-event Hide + Refresh stays hidden. B27-D Show / Refresh remount stays. B26-D Init remount stays.
- Title / SANCTION / Expand / hidden CloseButton / persist / no-sound / no-parchment stay.
- `runB30D()` is nested inside `runB27D()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness membership counts are pinned;** the client's special-frame walk is not. `Hide()` in this suite is a direct call, not a real ESC key. ESC still walks names and calls `Frame:Hide`, not `ConsoleDock:Hide`.
- **Parked Console leftover** (overview): no Console leftover this batch. Sibling lanes own Decree / card / Records.

## Status

**DONE_WITH_CONCERNS.** Isolated **476 / 0**. Isolation wrap **24**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
