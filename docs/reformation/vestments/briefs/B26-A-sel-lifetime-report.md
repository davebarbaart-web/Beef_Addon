# B26-A — Selected pair dies with the event (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.1 Recommend; B25 leftover (successful Start/End nil `lastRecommendation` but leave `selectedFighterA` / `selectedFighterB`, so a later petition-path Recommend inherits `hadSelected` and suppresses `"  names  "`); brief `docs/reformation/vestments/briefs/B26-A-sel-lifetime.md`. On successful `StartEvent` / `EndEvent` (`result ~= nil`), also set `selectedFighterA = nil` and `selectedFighterB = nil` **before** `after()`. Failed Start / failed End / Continue keep the pair. `lastRecommendation` clear stays. B25-A `hadSelected` gate stays. `SaveNote` stays nil. No "DEMANDED". Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1922 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB26A()` inside `runB8E()` after `runB25A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB26A()` inside `runB8E()` after `runB25A()` (Lua 5.1 200-local cap; no new main-chunk locals). SelectFighters + named petition + Recommend paints both names and **no** `"  names  "` (B25 keep). Failed Start while live keeps the pair (Recommend still has no token). Failed End from RITE keeps the pair. Continue keeps the pair. EndEvent then StartEvent + named petition + Recommend **without** SelectFighters paints `"  names  "`. Source pins: Start/End success blocks nil both selected ids (and `lastRecommendation`) before `after()`; Continue does not; `hadSelected` gate stays. SaveNote / SUMMON / parchment / tabs / no DEMANDED. Isolation wrap stays. B24-A source strings updated so `lastRecommendation` clear still pins inside the same success blocks. |
| `addon/ChurchOfBeef/UI/Console.lua` | Successful `StartEvent` / `EndEvent` also nil `selectedFighterA` / `selectedFighterB` before `after()`. `lastRecommendation = nil` stays first in both blocks. Failed Start / failed End / Continue unchanged. B25-A `hadSelected` gate unchanged. Header notes the pair lifetime. No new file locals. |
| `docs/reformation/vestments/briefs/B26-A-sel-lifetime-report.md` | This file |
| `docs/reformation/vestments/briefs/B26-A-sel-lifetime.diff` | B26-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not change `"  names  "` paint. Did not invent "DEMANDED". Did not define `SaveNote`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B26-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Console:StartEvent` | On `result ~= nil`, `lastRecommendation = nil` then `selectedFighterA` / `selectedFighterB` = nil before `after()`. Failed Start (already live) keeps the pair. |
| `Console:EndEvent` | Same clear-before-`after` on success. Failed End (not ASSEMBLY / CONSEQUENCE) keeps the pair. |
| `Console:Continue` | Unchanged. Does not clear the pair. |
| `Console:Recommend` | Unchanged. `hadSelected` still computed before `recommendPair` / `SelectFighters`. Store `namedOpponent` only when `hadSelected` is false and Core flagged it. |
| `paintRecommendation` | Unchanged. Appends `"  names  "` when `lastRecommendation.namedOpponent == true`. |
| `SaveNote` | Stays nil. |

### Unchanged

- `"  names  "` paint. No "DEMANDED".
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.
- B25-A `hadSelected` gate. B24-A `lastRecommendation` clear.

## TDD

1. Extended `tests/test_console.lua` first (`runB26A()` nested in `runB8E()` after `runB25A()`: selected-pair Recommend keeps both names and no `"  names  "`; failed Start / failed End / Continue keep the pair; EndEvent then StartEvent + named Recommend without SelectFighters paints the token; source / SaveNote / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1915 passed, 7 failed** (EndEvent / later StartEvent still left selected ids 1/2; petition-path Recommend after End then Start still suppressed `"  names  "`; Start/End source pins for selected-pair nils missing). B25 keep / failed-Start keep / Continue keep / SaveNote / isolation stayed green.
3. `StartEvent` and `EndEvent` set `selectedFighterA = nil` and `selectedFighterB = nil` when `result ~= nil`, after `lastRecommendation = nil`, before `after()`. Continue and Recommend kept.
4. After the Console patch, B24-A's exact source strings for clear-before-`after` failed (1920 passed, 2 failed). Updated those two finds so `lastRecommendation` clear still pins inside the blocks that now also nil the selected pair.
5. Green: `lua tests/test_console.lua` — **1922 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1922 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1922 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1922 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Gora / glue / TOC not edited.
- Successful Start / End nil the selected pair before Refresh. Failed Start / failed End / Continue keep the pair. `lastRecommendation` clear stays.
- B25-A `hadSelected` gate unchanged. Petition-path Recommend after End then Start paints `"  names  "`. `SaveNote` nil. No DEMANDED.
- `runB26A()` is nested inside `runB8E()` after `runB25A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **B24-A later-StartEvent keep still calls `SelectFighters(nil, nil)` in-harness.** That belt-and-suspenders clear is now redundant with the desk lifetime; left as a B24/B25 keep.
- **No client smoke.** Live desk after End Event / next Start Event then petition-path Recommend is unproven on Anniversary.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
