# B26-D — Console dock Init remounts ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do not PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console; B22-D leftover (`rememberSpecial` lived only in `build()`; a wiped list then second Init never put `ChurchOfBeefConsoleDock` back); brief `docs/reformation/vestments/briefs/B26-D-dock-special.md`. Per-event dismiss (B24-B) stays. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. No sound. Exclusive files only. No commit. Lane is not signed.

`ConsoleDock:Init` still builds once. When the frame already exists, `Init` calls `rememberSpecial(FRAME_NAME)` then Refresh. It does not rebuild. Create-path `build()` still registers once. Wipe `UISpecialFrames` to `{}` then second Init lists `ChurchOfBeefConsoleDock` exactly once and returns the same frame pointer.

**Isolated count:** 353 passed, 0 failed (`lua tests/test_console_dock.lua`). Isolation wrap stays under `if standalone then` at file load (**24** nil pins). Nested `runB26D()` after B24-B. One new main-chunk local (`runB26D`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | TDD first. Nested `runB26D()` after B24-B. Source pin: existing-frame remount body (`if not frame then return nil end` … `return frame`) has `rememberSpecial(FRAME_NAME)` then `self:Refresh()`, no `build()` / `CreateFrame` / `PlaySound`. Init, wipe `UISpecialFrames` to `{}`, second Init: `ChurchOfBeefConsoleDock` listed exactly once. Same frame pointer. Third Init still once. Wrapped `CreateFrame` saw 0 calls on remount. Same-event Hide + Refresh stays hidden. Persist / per-event dismiss / ESC / title / SANCTION + Expand pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | Existing-frame `Init` calls `rememberSpecial(FRAME_NAME)` then Refresh. Does not rebuild. `build()` still registers once. No `PlaySound`. No parchment. Header notes the remount. |
| `docs/reformation/vestments/briefs/B26-D-dock-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B26-D-dock-special.diff` | B26-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not add parchment. Did not change per-event dismiss. Did not commit.

`git diff HEAD` on these two files also includes earlier ConsoleDock batches (working tree already dirty). The brief diff is the B26-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` existing-frame | `rememberSpecial(FRAME_NAME)` then `Refresh`. Same frame pointer. |
| Create path | Unchanged. `build()` still calls `rememberSpecial(FRAME_NAME)` once. |
| Wipe remount | `UISpecialFrames = {}` then second Init lists `ChurchOfBeefConsoleDock` exactly once. |
| Rebuild | Existing-frame path does not call `build()` / `CreateFrame`. |
| Dismiss | B24-B `eventId` key stays. Same-event Hide + Refresh stays hidden. |
| Sound / dress | None. No `PlaySound`. No parchment. Title stays `DIRECTOR CONSOLE`. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. Persist `ChurchOfBeefDB.ui.consoleDock`.
- Per-event dismiss (B24-B). Hide is not EndEvent. No dismiss-cooldown.
- `rememberSpecial` scan-then-append. Missing table no-ops.
- Isolation wrap. Event-only show. `mayShow` = live event + registered Pope.

## TDD

1. Extended `tests/test_console_dock.lua` first (`runB26D()` after B24-B: remount source has `rememberSpecial(FRAME_NAME)` then Refresh; Init, wipe `UISpecialFrames` to `{}`, second Init lists the name once and returns the same frame; no rebuild; same-event dismiss stays; persist / ESC / isolation). Isolation wrap and existing persist / per-event dismiss / ESC pins untouched.
2. Red: `lua tests/test_console_dock.lua` — **349 passed, 4 failed** (remount source missing `rememberSpecial(FRAME_NAME)`; wiped list stayed 0 after second / third Init; dismiss-after-wipe count stayed 0). Same-frame / no-rebuild / Refresh / persist / B24-B dismiss pins stayed green.
3. Existing-frame `Init` calls `rememberSpecial(FRAME_NAME)` then Refresh. `build()` kept.
4. Green: `lua tests/test_console_dock.lua` — **353 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 353 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **353 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 353 passed, 0 failed. Isolation wrap stays (24 nil pins at file load). Wrap pattern unchanged. `runB26D()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / glue / TOC not edited.
- Existing-frame `Init` re-registers `ChurchOfBeefConsoleDock` and does not rebuild.
- Wipe-to-empty then second Init lists the name exactly once. Third Init still once. Same frame pointer.
- Per-event dismiss stays. Same-event Hide + Refresh stays hidden.
- Title / SANCTION / Expand / hidden CloseButton / persist / no-sound / no-parchment stay.
- `runB26D()` is nested after B24-B. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness membership counts are pinned;** the client's special-frame walk is not. `Hide()` in this suite is a direct call, not a real ESC key.
- **`Refresh` / `Show` on an existing frame still skip `rememberSpecial`.** This lane closed Init. A wipe then Refresh-only or Show-only does not put the name back until Init.
- **Parked Console leftover** (overview): selected-pair inherit of Core `namedOpponent`. Sibling B26-A, not this lane.

## Status

**DONE_WITH_CONCERNS.** Isolated **353 / 0**. Isolation wrap **24**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
