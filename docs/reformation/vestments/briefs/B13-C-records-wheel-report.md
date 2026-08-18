# B13-C — Records Book mouse wheel (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §14.2 (player-opened Quiet identity/history); Law 10 / §19.3 (theatrical parchment tome); Law 6 / §19.4 (Quiet is silent); brief `docs/reformation/vestments/briefs/B13-C-records-wheel.md`. Anniversary `EnableMouseWheel` is SimpleScriptRegionAPI (default false). CONTINUE 2026-08-18 license 4 (stock only). PAGE_TITLES stay 9.

After the named `ChurchOfBeefRecordsBook` frame exists, `EnableMouseWheel(true)` and `OnMouseWheel` are type-guarded. Wheel up (`delta > 0`) calls `turn(-1)` (Previous). Wheel down (`delta < 0`) calls `turn(1)` (Next). Non-number delta no-ops. Missing APIs no-op. No permanent `OnUpdate`. No sound. Empty leaf body stays `""`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 391 passed, 0 failed (`lua tests/test_records.lua`). **11** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Source contains type-guarded `EnableMouseWheel` and `SetScript("OnMouseWheel"`. After Init/Show, frame has `OnMouseWheel`. `stub.fire(frame, "OnMouseWheel", -1)` pins `Longest Streak` (same as Next). Wheel up returns to `Most Sanctioned Victories`. Empty-leaf body stays `""`. No `OnUpdate`. No sound. PAGE_TITLES stay 9. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | After `EnableMouse` / clamp on the named frame: `type(frame.EnableMouseWheel) == "function"` then `EnableMouseWheel(true)`; `type(frame.SetScript) == "function"` then `OnMouseWheel`. Handler type-guards number `delta`; `> 0` → `turn(-1)`; `< 0` → `turn(1)`. |
| `docs/reformation/vestments/briefs/B13-C-records-wheel-report.md` | This file |
| `docs/reformation/vestments/briefs/B13-C-records-wheel.diff` | B13-C-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Console, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add, rename, or delete `PAGE_TITLES`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B13-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| Named frame wheel | If `type(EnableMouseWheel) == "function"`, `EnableMouseWheel(true)`. If `type(SetScript) == "function"`, `OnMouseWheel`. Handler no-ops unless `delta` is a number. `delta > 0` → `turn(-1)` Previous. `delta < 0` → `turn(1)` Next. `delta == 0` no-op. Missing APIs no-op. |
| Permanent `OnUpdate` | None. |
| Empty leaf | `Body` text stays `""`. No invented copy. |
| `PAGE_TITLES` | Nine Bible names, Bible order. |
| Sound | None. Source has no `PlaySound`. |

### Unchanged

- Left-leaf superlatives, right-leaf identity, ribbons, prev/next buttons, roman paint, stock QuestBG / MORPHEUS / `UI-Quickslot2`.
- Quiet, no search, not a ladder. Show / Hide still do not write Store.

## TDD

1. Extended `tests/test_records.lua` first (`EnableMouseWheel` source pin, type-guard pin, `OnMouseWheel` wiring, `stub.fire(..., -1)` → `Longest Streak`, wheel up Previous, empty body `""`, no `OnUpdate`, no sound, nine titles). Isolation wrap untouched.
2. Red: `lua tests/test_records.lua` — **384 passed, 7 failed**.
3. Implemented type-guarded `EnableMouseWheel(true)` + `OnMouseWheel` on the named frame.
4. Green: `lua tests/test_records.lua` — **391 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 391 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **391 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / glue / TOC not edited.
- Wheel APIs are type-guarded. Missing methods and non-number delta no-op.
- `stub.fire(frame, "OnMouseWheel", -1)` turns to `Longest Streak`, same pin as Next.
- Empty-leaf `Body` stays `""`. `PAGE_TITLES` remains the nine Bible names.
- Source has no `PlaySound`, no `OnUpdate`, no `Media\\`. Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Wheel feel on Anniversary (hover over title bar / ribbons / buttons vs parchment) is unproven. **POLISH:CANDIDATE** only.
- **Stub `EnableMouseWheel` is a noop** and stores no flag. Tests pin source type-guard + `GetScript("OnMouseWheel")` + fire, not a runtime enabled bit.
- **Wheel is on the outer named frame**, not on every mouse-enabled child. TitleBar / buttons do not call `EnableMouseWheel`. If Classic delivers wheel only to the topmost mouse-enabled region, hovering chrome may not turn leaves. Not invented-fixed this lane.
- `delta == 0` no-ops. Brief named `> 0` and negative only.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
