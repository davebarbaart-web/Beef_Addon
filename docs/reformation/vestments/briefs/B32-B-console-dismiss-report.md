# B32-B — Console Dismiss also reaches the confession inbox (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §9 confession queue on the Pope console only; `Confession:Dismiss` already exists; `Console:Dismiss` (~1669) only called `Gora:Dismiss`; one stock Dismiss button (707); brief `docs/reformation/vestments/briefs/B32-B-console-dismiss.md`. Gora path and `"gora is not available"` stay. CallForward pins stay. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

`Console:Dismiss` still refuses when Gora is missing. It resolves one `id` (`characterId` or `selectedCharacterId`), calls `Gora:Dismiss(id)`, and if `COB.Confession.Dismiss` is a function, calls that with the same id. Refresh if either returns true. Return true if either succeeded. Isolated suite often has Confession nil — Gora-only Dismiss stays. One stock Dismiss button. No `PlaySound`. No theater.

**Isolated count:** 2220 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB32B()` inside `runB8E()` after `runB31A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB32B()` inside `runB8E()` after `runB31A()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: Dismiss resolves one `id`, reaches `Gora:Dismiss(id)`, type-guards `Confession.Dismiss`, reaches `Confession:Dismiss(id)`, Refreshs when either succeeded; `"gora is not available"` / CallForward / one stock Dismiss stay. Behavioral: Confession stub records the id and Gora still receives it; Confession success still returns true when Gora has no petition; Confession table without `Dismiss` stays Gora-only; missing Confession: Gora Dismiss still true; missing `Gora.Dismiss` still refuses `"gora is not available"`. No Sound / Toasts / chat. SaveNote / SUMMON / parchment / tabs / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Console.lua` | Dismiss resolves one id, calls Gora, then Confession when `Dismiss` exists. Refresh if either returns true. Return true if either succeeded. Gora-missing refuse stays. Header notes the inbox reach. No new file locals. No second button. |
| `docs/reformation/vestments/briefs/B32-B-console-dismiss-report.md` | This file |
| `docs/reformation/vestments/briefs/B32-B-console-dismiss.diff` | B32-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Confession.lua, Dock, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not add a second Dismiss button. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B32-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Dismiss` (Gora missing) | `nil, "gora is not available"`. Confession is not called. |
| `Dismiss` (not registered Pope) | Unchanged. `nil, REFUSE`. |
| `Dismiss` (Confession.Dismiss exists) | Same `id` to Gora then Confession. Refresh / true if either succeeded. |
| `Dismiss` (Confession nil or no `Dismiss`) | Gora-only. Isolated suite default. |
| Stock Dismiss button | Unchanged. One `UIPanelButtonTemplate`. Calls `Console:Dismiss()`. |
| `CallForward` | Unchanged. |
| `SaveNote` | Stays nil. |

### Unchanged

- B20-A / B4-D one stock Dismiss. No per-row Dismiss. No fan-out.
- B5-C / B20-A CallForward pins.
- B31-A Quiet Recommend drop. B26-A pair-clear. Continue does not clear.
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (nested `runB32B()` in `runB8E()` after `runB31A()`: Dismiss source resolves one id and type-guards Confession; stub Confession.Dismiss records the id and Gora still receives it; missing Confession stays Gora-true; `"gora is not available"` / CallForward / one Dismiss / SaveNote / SUMMON / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **2210 passed, 10 failed** (source missing `local id` / `Gora:Dismiss(id)` / Confession type-guard / `Confession:Dismiss(id)`; stub Dismiss not reached; either-succeeded still returned Gora's false). Gora-only missing Confession / Confession-without-Dismiss / `"gora is not available"` / one button / CallForward / SaveNote / isolation stayed green.
3. Dismiss resolves one `id`, calls `Gora:Dismiss(id)`, then `Confession:Dismiss(id)` when that function exists. Refresh / return true if either succeeded. Gora-missing refuse kept.
4. Green: `lua tests/test_console.lua` — **2220 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2220 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2220 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2220 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB32B()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Confession.lua / glue / TOC not edited.
- One stock Dismiss. No second button. No `after()` / Sound / Toasts / chat.
- Gora path and `"gora is not available"` stay. Isolated Gora-only stays when Confession is nil.
- Same id reaches both when Confession.Dismiss exists. Either-succeeded Refresh / true.
- `runB32B()` is nested inside `runB8E()` after `runB31A()`. No new main-chunk locals.
- Isolation wrap stays. CallForward pins stay. `SaveNote` nil. No SUMMON.

## Leftovers

- **Confession.lua was not loaded or edited.** Isolated suite still stubs Confession. Real `Confession:Dismiss` inbox removal is B32-C / a later Core pin, not this lane.
- **No client smoke.** Stock Dismiss on Anniversary (petition + inbox, same id) is unproven; the harness covers the stub reach and Gora-only keep.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Either-succeeded Refresh** when Gora has no petition is console-only. The desk still has one Dismiss; it does not grow a confession-only plate.

## Status

**DONE_WITH_CONCERNS.** Isolated **2220 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
