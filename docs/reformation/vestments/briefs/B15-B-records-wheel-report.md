# B15-B — Records Book wheel on chrome (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §14.2 (player-opened Quiet identity/history); Law 10 / §19.3 (theatrical parchment tome); Law 6 / §19.4 (Quiet is silent); brief `docs/reformation/vestments/briefs/B15-B-records-wheel.md`; B13-C outer-frame wheel. Anniversary `EnableMouseWheel` is SimpleScriptRegionAPI (the region under the cursor gets the event). PAGE_TITLES stay 9.

B13-C already wheels the outer named frame. TitleBar (`EnableMouse`), CloseButton, VictoriesRibbon, RivalriesRibbon, MartyrsRibbon, PrevButton, and NextButton sit on top and eat the wheel. One extracted `onMouseWheel` (delta > 0 → `turn(-1)` Previous; delta < 0 → `turn(1)` Next) is shared. Outer-frame hook stays type-guarded (`type(frame.EnableMouseWheel)` / `SetScript`). Children get type-guarded `EnableMouseWheel(true)` + `SetScript("OnMouseWheel", onMouseWheel)` via `wireChildWheel`. Non-number delta no-ops. Missing APIs no-op. No permanent `OnUpdate`. No `PlaySound` on wheel. Empty leaf body stays `""`. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 420 passed, 0 failed (`lua tests/test_records.lua`). **11** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. After Init/Show, TitleBar, CloseButton, VictoriesRibbon, RivalriesRibbon, MartyrsRibbon, PrevButton, NextButton have `OnMouseWheel`. `stub.fire(TitleBar, "OnMouseWheel", -1)` pins `Longest Streak` (Next). `stub.fire(PrevButton, "OnMouseWheel", 1)` returns to `Most Sanctioned Victories` (Previous). Empty body `""`. No sound. No `OnUpdate`. PAGE_TITLES stay 9. Outer-frame pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Extracted `onMouseWheel`. Outer-frame hook now calls that handler. `wireChildWheel` type-guards `EnableMouseWheel(true)` + `SetScript` on the seven named children. |
| `docs/reformation/vestments/briefs/B15-B-records-wheel-report.md` | This file |
| `docs/reformation/vestments/briefs/B15-B-records-wheel.diff` | B15-B-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit MainFrame, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add, rename, or delete `PAGE_TITLES`. Did not add custom media or `PlaySound`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B15-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| Extracted `onMouseWheel` | Number `delta` only. `> 0` → `turn(-1)` Previous. `< 0` → `turn(1)` Next. `== 0` no-op. |
| Outer named frame | Existing type-guarded `EnableMouseWheel(true)` + `SetScript("OnMouseWheel", onMouseWheel)` kept. |
| TitleBar, CloseButton, ribbons, Prev, Next | Type-guarded `EnableMouseWheel(true)` + same handler. |
| Permanent `OnUpdate` | None. |
| Empty leaf | `Body` text stays `""`. No invented copy. |
| `PAGE_TITLES` | Nine Bible names, Bible order. |
| Sound | None. Source has no `PlaySound`. No `PlaySound` on wheel. |

### Unchanged

- Left-leaf superlatives, right-leaf identity, ribbon jumps, prev/next clicks, roman paint, stock QuestBG / MORPHEUS / `UI-Quickslot2`.
- Quiet, no search, not a ladder. Show / Hide still do not write Store.
- Isolation wrap (11 pins).

## TDD

1. Extended `tests/test_records.lua` first (named children have `OnMouseWheel`; TitleBar `-1` → Next; PrevButton `1` → Previous; empty body `""`; no sound; no `OnUpdate`; nine titles). Outer-frame pins and isolation wrap untouched.
2. Red: `lua tests/test_records.lua` — **410 passed, 10 failed**.
3. Extracted `onMouseWheel`; kept the outer-frame hook; type-guarded `wireChildWheel` on the seven named children.
4. Green: `lua tests/test_records.lua` — **420 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 420 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **420 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. MainFrame / glue / TOC / bootstrap not edited.
- One handler. Outer-frame `type(frame.EnableMouseWheel)` pin still matches source.
- TitleBar `-1` turns to `Longest Streak`. PrevButton `1` turns back to `Most Sanctioned Victories`.
- Empty-leaf `Body` stays `""`. `PAGE_TITLES` remains the nine Bible names.
- Source has no `PlaySound`, no `OnUpdate`, no `Media\\`. Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Chrome hover on Anniversary (TitleBar / Close / ribbons / Previous / Next) is unproven in-game.
- **Stub `EnableMouseWheel` is a noop** and stores no flag. Tests pin `GetScript("OnMouseWheel")` + `stub.fire`, not a runtime enabled bit.
- **FontStrings / parchment textures** were not in the brief's named list and are not wired. If a mouse-enabled region other than those seven still sits on top, it can still eat the wheel.
- `delta == 0` no-ops. Brief named `> 0` and `< 0` only.

## Status

**DONE_WITH_CONCERNS.** Not signed.
