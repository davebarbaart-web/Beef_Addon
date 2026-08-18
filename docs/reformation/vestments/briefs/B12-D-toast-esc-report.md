# B12-D — Proclaim ESC dismiss (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / Law 10 (theatrical Proclaim, no close ✕); Law 6 (Quiet does not drive this file); wiki "Make frames closable with the Escape key"; brief `docs/reformation/vestments/briefs/B12-D-toast-esc.md`. CONTINUE 2026-08-18 license 4 (stock only). No new cue names. `IG_CHARACTER_INFO_*` forbidden.

The theatrical root `ChurchOfBeefProclaim` is registered on `UISpecialFrames` (dedupe, type-guard a missing table). ESC `Hide()`s that root. `OnHide` runs `hideTheater` (gen bump) so a leftover Hide cannot leave the next Proclaim stuck. `ChurchOfBeefToast` (small system/debug stack) is not registered. No close ✕. No `PlaySound` on ESC / show / hide. Clerical copy / Morpheus / no-`SendChatMessage` pins stay. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested `runB12D()` (Lua 5.1 200-local cap). After Proclaim: `UISpecialFrames` contains `ChurchOfBeefProclaim` once; second InitTheater / Proclaim does not duplicate; `ChurchOfBeefToast` is absent. Source contains `UISpecialFrames` and does not register the small stack. OnHide teardown; ESC Hide then leftover timer then next Proclaim still shows. No `IG_CHARACTER_INFO`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | `rememberSpecial` (Decree-shaped). `wireProclaimEsc` after the initial Hide. `OnHide` → `hideTheater`. Register `ChurchOfBeefProclaim` only. `Toasts:Init` still names `ChurchOfBeefToast` and does not register it. |
| `docs/reformation/vestments/briefs/B12-D-toast-esc-report.md` | This file |
| `docs/reformation/vestments/briefs/B12-D-toast-esc.diff` | B12-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit FighterCard, Sound, glue, TOC, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media. Did not invent a cue name. Did not `SendChatMessage`. Did not commit.

`git diff` vs HEAD on these two files also includes Batches 3–11 (working tree already dirty). The brief diff is the B12-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `ChurchOfBeefProclaim` | Named theatrical root. `rememberSpecial` onto `UISpecialFrames`. Missing table no-ops. Second InitTheater / Proclaim does not duplicate. |
| `OnHide` | Calls `hideTheater` (bumps `theaterGen`, Hide no-op if already hidden). Wired after the create-time Hide so mint does not tear down. |
| `ChurchOfBeefToast` | Small system/debug stack. Not on `UISpecialFrames`. |
| Sound | Cue remains `Sound:Play(kind)` from Proclaim only. No `PlaySound` / `IG_CHARACTER_INFO_*` on ESC, show, or hide. |
| Copy | Clerical only. Morpheus headlines unchanged. No close ✕. |

Quiet / missing Runtime still refuse and do not show. Quiet Mode does not drive this file.

## TDD

1. Extended `test_ui.lua` first (`runB12D()`: register-once, no toast register, OnHide, leftover Hide does not stick the next Proclaim, source pins). Isolation wrap untouched.
2. Red: `lua tests/test_ui.lua` — **339 passed, 6 failed** (no `UISpecialFrames`, count 0, no OnHide).
3. Implemented `rememberSpecial` + `wireProclaimEsc` + `OnHide` → `hideTheater`.
4. Green: `lua tests/test_ui.lua` — **345 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 345 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **345 passed, 0 failed.** Exit 0. |

**Isolated count:** 345 passed, 0 failed. Isolation asserts stay under `if standalone then`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. FighterCard / Sound / glue / TOC not edited.
- `rememberSpecial` type-guards `UISpecialFrames`. Dedupe by name. Only `PROCLAIM_NAME`.
- `OnHide` is set after the initial `root:Hide()` so create does not bump `theaterGen`.
- Stub `Hide()` on an already-hidden frame does not re-enter `OnHide`.
- Source has `UISpecialFrames` and does not register `ChurchOfBeefToast`. No `IG_CHARACTER_INFO`. No `SendChatMessage(`. Morpheus pin stays.
- Isolation wrap stays. New locals are inside `runB12D()`.
- No new sound names. No close ✕.

## Concerns

- **No client smoke.** ESC vs `UISpecialFrames` order (Proclaim shares the list with `ChurchOfBeefFrame`) is unproven on Anniversary. **POLISH:CANDIDATE** only.
- **`hideTheater` from `OnHide` double-bumps `theaterGen` on the HideAll path** (`hideTheater` Hide → OnHide → `hideTheater` again). Harmless; leftover timers stay invalid.
- **Small toast stack remains ESC-immune.** Brief forbids registering `ChurchOfBeefToast`.
- Harness `Hide()` is a direct call, not a real ESC key. Registration + OnHide teardown are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **345 / 0**. Not signed. **POLISH:CANDIDATE.**
