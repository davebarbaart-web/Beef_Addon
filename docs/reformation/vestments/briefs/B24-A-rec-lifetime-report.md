# B24-A — Recommendation clears when the event ends or a new one starts (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 / §20 event lifetime; B22-A leftover (`lastRecommendation` only cleared in `ResetForTests`); brief `docs/reformation/vestments/briefs/B24-A-rec-lifetime.md`. On successful `StartEvent` and `EndEvent` (`result ~= nil`), `lastRecommendation = nil` **before** `after()` so Refresh paints empty. Failed Start (already live) / failed End keep the table. `Continue` does not clear. `Recommend` still stores `namedOpponent`. `"  names  "` paint unchanged. `SaveNote` stays nil. No "DEMANDED". Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1766 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB24A()` inside `runB8E()` after `runB23A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB24A()` inside `runB8E()` after `runB23A()` (Lua 5.1 200-local cap; no new main-chunk locals). Named Recommend paints `"  names  "`. Failed Start while live keeps the line. Continue keeps the line. Failed End from RITE keeps the line. `EndEvent` then Refresh is `""`. Later `StartEvent` still empty. New Recommend paints again. `Runtime:EndEvent` bypass leaves the leftover; `Console:StartEvent` clears it. Source pins: clear-before-`after` on Start/End, Continue does not clear, namedOpponent store + `"  names  "` append stay, SaveNote / SUMMON / parchment / tabs / no DEMANDED. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | Successful `StartEvent` / `EndEvent` set `lastRecommendation = nil` before `after()`. Failed Start / failed End / Continue unchanged. Recommend still stores `namedOpponent`. Paint unchanged. Header notes the lifetime. No new file locals. |
| `docs/reformation/vestments/briefs/B24-A-rec-lifetime-report.md` | This file |
| `docs/reformation/vestments/briefs/B24-A-rec-lifetime.diff` | B24-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not change `"  names  "` paint. Did not invent "DEMANDED". Did not define `SaveNote`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B24-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Console:StartEvent` | On `result ~= nil`, `lastRecommendation = nil` before `after()` so Refresh paints empty. Failed Start (already live) keeps the table. |
| `Console:EndEvent` | Same clear-before-`after` on success. Failed End (not ASSEMBLY / CONSEQUENCE) keeps the table. |
| `Console:Continue` | Unchanged. Does not clear. |
| `Console:Recommend` | Still stores `{ fighterA, fighterB, namedOpponent = result.namedOpponent == true }`. |
| `paintRecommendation` | Unchanged. `nameA vs nameB` + mute H2H. Appends `"  names  "` when `namedOpponent == true`. |
| `SaveNote` | Stays nil. |

### Unchanged

- `"  names  "` paint. No "DEMANDED".
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB24A()` nested in `runB8E()` after `runB23A()`: named Recommend paints `"  names  "`; failed Start / Continue / failed End keep the line; EndEvent then Refresh is `""`; later StartEvent still empty; new Recommend paints again; Runtime EndEvent bypass then Console StartEvent clears leftover; source / SaveNote / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1760 passed, 6 failed** (EndEvent / later StartEvent / leftover StartEvent still painted `Tendermage vs Chuckroast  names  `; source pins for clear-before-`after` missing). Failed-Start / Continue / failed-End keep pins stayed green.
3. `StartEvent` and `EndEvent` set `lastRecommendation = nil` when `result ~= nil`, before `after()`. Continue and Recommend kept.
4. Green: `lua tests/test_console.lua` — **1766 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1766 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1766 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1766 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Gora / glue / TOC not edited.
- Successful Start / End clear before Refresh. Failed Start / failed End / Continue keep the table.
- Recommend still stores `namedOpponent`. `"  names  "` paint unchanged. `SaveNote` nil. No DEMANDED.
- `runB24A()` is nested inside `runB8E()` after `runB23A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Selected-pair inherit of Core `namedOpponent`** stays parked (Batch 24 overview; later Console batch).
- **No client smoke.** Live desk paint after End Event / next Start Event is unproven on Anniversary.
- **`Runtime:EndEvent` bypass is harness-only.** The Pope desk always goes through `Console:EndEvent`. The bypass exists so StartEvent's own clear is visible after EndEvent already emptied the line.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
