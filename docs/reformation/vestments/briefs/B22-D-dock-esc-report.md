# B22-D — Event dock ESC via UISpecialFrames (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (collapsible Director Console dock); Law 10 / §19.3 (functional / stock templates); Law 6 / §19.4 (Quiet is silent; no panel whoosh); wiki "Make frames closable with the Escape key" (named frame on `UISpecialFrames`); Toasts / Console `rememberSpecial`; brief `docs/reformation/vestments/briefs/B22-D-dock-esc.md`. CONTINUE 2026-08-18 license 4 (stock only). Title stays exactly `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. No custom media. No `PlaySound`.

`build()` calls `rememberSpecial(FRAME_NAME)` once for `ChurchOfBeefConsoleDock` (Decree-shaped helper: type-guard the table, scan, then append). Does not add a close button. Does not `PlaySound` / `IG_CHARACTER_INFO_*` on hide. Hide is not EndEvent. `mayShow` (live event + registered Pope) stays. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 233 passed, 0 failed (`lua tests/test_console_dock.lua`). **24** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | TDD first. Source `rememberSpecial` / dedupe scan / `rememberSpecial(FRAME_NAME)`. No bare insert, no `IG_CHARACTER_INFO` / `PlaySound`. After Init the name is listed once; second Init does not duplicate; Init survives a missing table. After Init + StartEvent + Pope: `GetName()` is `ChurchOfBeefConsoleDock`; listed once; second Init still once. Hide hides; Runtime stays ASSEMBLY. Quiet / persist / title / SANCTION + Expand / hidden CloseButton pins stay. Persist remounts still once. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | Copied Toasts / Console `rememberSpecial`. `build()` calls `rememberSpecial(FRAME_NAME)` once. CloseButton stays hidden. No hide sound. Hide still `paint(false)` only. |
| `docs/reformation/vestments/briefs/B22-D-dock-esc-report.md` | This file |
| `docs/reformation/vestments/briefs/B22-D-dock-esc.diff` | B22-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console.lua, Hud, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a close button or custom media. Did not commit.

Both exclusive files were untracked at lane start. The brief diff is the B22-D-only delta vs the pre-lane text.

## Contract

| Surface | Role |
|---------|------|
| `ChurchOfBeefConsoleDock` | Named `BasicFrameTemplate`. Already created; now remembered. |
| `rememberSpecial` | If `UISpecialFrames` is a table, skip when `name` is already listed, else append. Missing table no-ops. |
| `build()` | Calls `rememberSpecial(FRAME_NAME)` once. Named dock only. |
| Hide | `paint(false)`. Not EndEvent. No hide sound. |
| CloseButton | Stays hidden. No new close chrome. |
| `mayShow` | Live event + registered Pope. Quiet hide stays. |
| Persist | `ChurchOfBeefDB.ui.consoleDock` unchanged. Title stays `DIRECTOR CONSOLE`. SANCTION + Expand stay. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. No whisper, toast, favor, cue.
- No `PlaySound`. No custom media. No `OnUpdate`.
- Isolation wrap. Event-only show.

## TDD

1. Extended `tests/test_console_dock.lua` first (source helper pins; once after Init; second Init no duplicate; missing-table type-guard; StartEvent + Pope name once; Hide is not EndEvent; persist remount still once). Isolation wrap untouched. Existing Quiet / persist / title / SANCTION + Expand pins stayed.
2. Red: `lua tests/test_console_dock.lua` — **222 passed, 11 failed**.
3. Implemented Decree-shaped `rememberSpecial`; `build()` calls it once.
4. Green: `lua tests/test_console_dock.lua` — **233 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 233 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **233 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 24 pins under `if standalone then` (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / Hud / glue / TOC not edited.
- `rememberSpecial` type-guards a missing table and scans before append. Call is `rememberSpecial(FRAME_NAME)` in `build()`.
- After Init + StartEvent + Pope, `GetName()` is `ChurchOfBeefConsoleDock` and the name is listed once. Second Init does not duplicate. Persist remounts stay at one.
- Hide hides the widget; Runtime stays ASSEMBLY. Quiet hide stays. Title / SANCTION / Expand / hidden CloseButton stay.
- Source has no `PlaySound` / `IG_CHARACTER_INFO` / bare `table.insert(UISpecialFrames`. No close button added. Persist `ui.consoleDock` stays.
- Isolation wrap stays.

## Concerns

- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. Harness `UISpecialFrames` is a stub table. **POLISH:CANDIDATE** only.
- **ESC Hide()s the widget, not `ConsoleDock:Hide()`.** Classic iterates `UISpecialFrames` and calls the frame's `Hide()`. `lastView.shown` may stay true until the next `Refresh` / `ConsoleDock:Hide()`. This lane did not add an `OnHide` hook.
- **`Init` is idempotent.** Second Init does not re-call `build()`. Dedupe is exercised by persist `dofile` remounts and by `ResetForTests` + rebuild. A missing table at first `build()` is not queued until another build.
- Gate W stays OPEN. Gate V stays OPEN.

## Leftover (not this lane)

Parked (later Console batch): desk `after()` double cue. Not closed here.

## Status

**DONE_WITH_CONCERNS.** Isolated **233 / 0**. Isolation wrap **24**. Not signed. No Gate W / Gate V / **POLISH:PASS** / V1 claim.
