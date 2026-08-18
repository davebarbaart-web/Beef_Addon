# B31-A — Refresh in QUIET drops a leftover Recommend line (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20 QUIET has no event pair; B26-A selection/recommend dies with the event; B24 leftover (`Runtime:EndEvent` then `Console:Refresh` left `lastRecommendation`, so mute `"  names  "` survived InspectProgress / glue EndEvent); brief `docs/reformation/vestments/briefs/B31-A-quiet-recommend.md`. B24-A StartEvent / EndEvent clear-before-`after` stays. B26-A selected-pair lifetime stays. Continue still does not clear. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

`Console:Refresh` now reads Runtime `Snapshot().state` before `paintRecommendation`. If that state is nil or `"QUIET"`, it sets `lastRecommendation = nil`. It does not nil `selectedFighterA` / `selectedFighterB`. StartEvent / EndEvent pair-clear stay. Continue still does not clear. The B24-A leftover pin now expects empty Recommendation text after `Runtime:EndEvent` + `Refresh`. The StartEvent-clears pin stays.

**Isolated count:** 2145 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB31A()` inside `runB8E()` after `runB29A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. B24-A leftover pin updated in place: `Runtime:EndEvent` + `Refresh` now expects `""` (leftover closed). StartEvent-clears pin kept. Nested `runB31A()` inside `runB8E()` after `runB29A()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: Refresh has `state == nil or state == "QUIET"` then `lastRecommendation = nil` before `paintRecommendation`; Refresh does not name `selectedFighterA` / `selectedFighterB`. Behavioral: QUIET pick survives Refresh; live Recommend still paints `"  names  "` + both names; `Runtime:EndEvent` + Refresh paints empty and has no names token. B26-A Start/End pair-clear / Continue / SaveNote / SUMMON / parchment / tabs / no `DEMANDED`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | Refresh reads Runtime `Snapshot().state`. Nil or `"QUIET"` nils `lastRecommendation` before `paintRecommendation`. Does not nil the selected pair. StartEvent / EndEvent pair-clear stay. Continue unchanged. Header notes the Quiet drop. No new file locals. |
| `docs/reformation/vestments/briefs/B31-A-quiet-recommend-report.md` | This file |
| `docs/reformation/vestments/briefs/B31-A-quiet-recommend.diff` | B31-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Dock, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not add `GetState` on Runtime. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B31-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Refresh` (state nil or `"QUIET"`) | `lastRecommendation = nil` before `paintRecommendation`. |
| `Refresh` (ASSEMBLY / RITE / CONSEQUENCE) | Leaves `lastRecommendation`. Live Recommend still paints. |
| `Refresh` selected pair | Unchanged. Does not nil `selectedFighterA` / `selectedFighterB`. |
| `StartEvent` / `EndEvent` | Unchanged. Still nil `lastRecommendation` and the selected pair before `after()`. |
| `Continue` | Unchanged. Does not clear `lastRecommendation`. |
| B24-A leftover pin | `Runtime:EndEvent` + `Refresh` paints `""`. StartEvent-clears pin stays. |
| `SaveNote` | Stays nil. |

### Unchanged

- B26-A successful Start / End nil the selected pair before `after()`.
- B24-A StartEvent / EndEvent `lastRecommendation` clear-before-`after`. Failed Start / failed End / Continue keep the table.
- B25-A `hadSelected` gate. `"  names  "` paint.
- B29-A Hide remount. B28-A Show / Refresh remount. B27-A Init remount. B14-D uniqueness.
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (B24-A leftover pin in place → empty string; nested `runB31A()` in `runB8E()` after `runB29A()`: Refresh source nils `lastRecommendation` when state is nil or QUIET, before `paintRecommendation`, and does not name the selected pair; QUIET pick survives Refresh; live Recommend still paints; `Runtime:EndEvent` + Refresh paints empty; B26-A pair-clear / Continue / SaveNote / SUMMON / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **2139 passed, 6 failed** (B24 leftover still painted `"  names  "`; Refresh source missing the Quiet drop; B31-A leftover + names-token pins). Live Recommend / QUIET selected-pair keep / StartEvent-clears / B26-A / Continue / SaveNote / isolation stayed green.
3. Refresh reads `Snapshot().state` and nils `lastRecommendation` when that state is nil or `"QUIET"`, before `paintRecommendation`. Selected pair untouched. StartEvent / EndEvent / Continue kept.
4. Green: `lua tests/test_console.lua` — **2145 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2145 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2145 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2145 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB31A()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Dock / glue / TOC not edited.
- Refresh drops `lastRecommendation` in QUIET (and when Runtime state is nil). It does not nil the selected pair.
- `Runtime:EndEvent` then `Refresh` paints empty. Live Recommend still paints. StartEvent-clears pin stays.
- B26-A selected-pair lifetime stays. Continue does not clear. `SaveNote` nil. No SUMMON / parchment / tabs / `DEMANDED`.
- `runB31A()` is nested inside `runB8E()` after `runB29A()`. No new main-chunk locals.
- Isolation wrap stays.
- Runtime has no `GetState`; Console reads the existing `Snapshot().state` (nil or `"QUIET"`).

## Leftovers

- **Runtime has no `GetState`.** Exclusive pair cannot add one. Refresh uses `Snapshot().state`, matching `paintRuntime` / `currentEventId`. A later Core `GetState` is not this lane.
- **No client smoke.** InspectProgress / glue EndEvent on Anniversary is unproven; the harness covers `Runtime:EndEvent` + `Refresh` and a live Recommend keep.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Continue still does not clear** `lastRecommendation` while the event is live (ASSEMBLY after CONSEQUENCE). Intentional.
- **A QUIET selected pair survives Refresh.** Intentional so a Pope can pick before Start Event.

## Status

**DONE_WITH_CONCERNS.** Isolated **2145 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
