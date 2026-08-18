# B15-C — Quiet shell UISpecialFrames dedupe (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §14.2 (player-opened Quiet is Records Book); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`); wiki "Make frames closable with the Escape key" (named frame on `UISpecialFrames`); Decree `rememberSpecial`; brief `docs/reformation/vestments/briefs/B15-C-shell-special.md`. CONTINUE 2026-08-18 license 4 (stock only). No Ladder / Standing / Officer tabs.

Replaced the bare `table.insert(UISpecialFrames, FRAME_NAME)` with Decree's `rememberSpecial` (type-guard the table, scan, then append). Called once from `UI:Init()` as `rememberSpecial(FRAME_NAME)` for `ChurchOfBeefFrame`. No `PlaySound` / `IG_CHARACTER_INFO_*`. `UI:Toggle` still opens Records Book. Exclusive files only. Did not edit Toasts.lua. No commit. Lane is not signed.

**Isolated count:** 368 passed, 0 failed (`lua tests/test_ui.lua`). Isolation wrap stays under `if standalone then`. B15-C pins nested inside `runB12D()` after the Proclaim pins. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B15-C pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). After Init, `ChurchOfBeefFrame` appears in `UISpecialFrames` exactly once. Forced second build (nil `UI.frame`) still once. Source has `rememberSpecial` / dedupe loop / `rememberSpecial(FRAME_NAME)`. No bare insert, no `IG_CHARACTER_INFO` / `PlaySound`. `BasicFrameTemplate` and `RecordsBook:Toggle` stay. Existing Init pin `UISpecialFrames[1]==ChurchOfBeefFrame` and B12-D Proclaim pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/MainFrame.lua` | Copied Decree `rememberSpecial`. `Init` calls `rememberSpecial(FRAME_NAME)` once. Removed `table.insert(UISpecialFrames, FRAME_NAME)`. |
| `docs/reformation/vestments/briefs/B15-C-shell-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B15-C-shell-special.diff` | B15-C-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Toasts.lua, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Ladder / Standing / Officer tabs. Did not add panel whoosh. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Quiet-shell / Proclaim batches (working tree already dirty). The brief diff is the B15-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `rememberSpecial` | If `UISpecialFrames` is a table, skip when `name` is already listed, else append. Missing table no-ops. |
| `UI:Init` | Calls `rememberSpecial(FRAME_NAME)` once. Named Quiet shell only. |
| `UI:Toggle` | Unchanged. Still opens Records Book when that module is loaded. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| Template | Stays `BasicFrameTemplate`. |

### Unchanged

- Existing Init pin `UISpecialFrames[1] == "ChurchOfBeefFrame"`.
- B12-D Proclaim `rememberSpecial` / OnHide pins.
- Isolation wrap. No new main-chunk locals in `test_ui.lua`.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: count once, forced rebuild dedupe, source pins, BasicFrameTemplate / Toggle / no tabs, isolation). Isolation wrap untouched except the nested pin block.
2. Red: `lua tests/test_ui.lua` — **362 passed, 6 failed**.
3. Implemented Decree-style `rememberSpecial`; `Init` calls it once; removed bare insert.
4. Green: `lua tests/test_ui.lua` — **368 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 368 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **368 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 368 passed, 0 failed. Isolation asserts stay under `if standalone then`. Wrap pattern unchanged. No new main-chunk locals.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Toasts / glue / TOC not edited.
- `rememberSpecial` type-guards a missing table and scans before append.
- After Init, `ChurchOfBeefFrame` is listed once. Second `Init` after nilling `UI.frame` does not duplicate.
- `UI:Toggle` still routes to Records Book. Shell stays `BasicFrameTemplate`. No tabs. No `PlaySound`.
- B15-C pins are nested inside `runB12D()`. No new main-chunk locals.
- Existing Init / B12-D Proclaim pins still pass. Isolation wrap stays.

## Concerns

- **No client smoke.** Real ESC vs `UISpecialFrames` close order is still unproven on Anniversary.
- **`UI:Init` is idempotent and there is no `ResetForTests`.** The harness nils `UI.frame` to force a second `buildFrame` / `rememberSpecial` for the dedupe pin.
- **Harness `UISpecialFrames` is a stub table.** Tests pin membership counts, not the client's `CloseSpecialWindows` walk.
- Earlier `loadUi()` reloads in this suite used to append a second and third `ChurchOfBeefFrame`. `rememberSpecial` now keeps those reloads at one. The client's login path calls `Init` once.

## Status

**DONE_WITH_CONCERNS.** Isolated **368 / 0**. Not signed. No Gate. No POLISH:PASS.
