# B25-A — Selected pair does not inherit the Recommend names token (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.1 Recommend; B22 leftover (`Gora:Recommend` flags `namedOpponent` from live petitions even when the Pope already selected those two); brief `docs/reformation/vestments/briefs/B25-A-rec-selected.md`. `Console:Recommend` computes `hadSelected` from two different selected ids **before** `recommendPair` / `SelectFighters`. Store `namedOpponent = (not hadSelected) and result.namedOpponent == true`. Pair is still stored. Gora:Recommend is still called. Petition-path Recommend (no selected pair) still stores Core `namedOpponent == true` and paints `"  names  "`. B22-A / B24-A pins stay. `SaveNote` stays nil. No "DEMANDED". Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1841 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB25A()` inside `runB8E()` after `runB24A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB25A()` inside `runB8E()` after `runB24A()` (Lua 5.1 200-local cap; no new main-chunk locals). SelectFighters + named petition + Recommend paints both names and **no** `"  names  "`. Reset + no SelectFighters + named petition + Recommend keeps the token (B22-A). Source pins: `hadSelected` before `recommendPair` / `SelectFighters`; store gated by `hadSelected`. Petition line `"  names  "` stays. SaveNote / SUMMON / parchment / tabs / no DEMANDED. Isolation wrap stays. B24-A later-StartEvent keep clears leftover selected fighters so the petition-path paint pin stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | `Recommend` computes `hadSelected` before resolving the pair. Store `namedOpponent` only when Recommend did not already have a selected pair. Still stores the pair. Still calls `Gora:Recommend`. Still `SelectFighters`. Paint unchanged. Header notes the gate. No new file locals. |
| `docs/reformation/vestments/briefs/B25-A-rec-selected-report.md` | This file |
| `docs/reformation/vestments/briefs/B25-A-rec-selected.diff` | B25-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not change `"  names  "` paint. Did not invent "DEMANDED". Did not define `SaveNote`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B25-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Console:Recommend` | Compute `hadSelected` from two different selected ids **before** `recommendPair` / `SelectFighters`. On success, store the pair. Store `namedOpponent` only when `hadSelected` is false and Core flagged it. |
| `paintRecommendation` | Unchanged. Appends `"  names  "` when `lastRecommendation.namedOpponent == true`. |
| Petition line | Unchanged. Still paints `"  names  "` for a named opponent. |
| `SaveNote` | Stays nil. |

### Unchanged

- `"  names  "` paint. No "DEMANDED".
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.
- B22-A petition-path token. B24-A Start/End clear of `lastRecommendation`.

## TDD

1. Extended `tests/test_console.lua` first (`runB25A()` nested in `runB8E()` after `runB24A()`: selected pair + named petition paints both names and no `"  names  "`; Reset + no SelectFighters keeps the token; source / SaveNote / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1834 passed, 5 failed** (selected-pair Recommendation still painted `  names  `; `hadSelected` source / order / gated-store pins missing). Petition-path keep stayed green.
3. `Recommend` computes `hadSelected` before `recommendPair` / `SelectFighters`. Store `namedOpponent = (not hadSelected) and result.namedOpponent == true`.
4. After the store gate, B24-A's later-StartEvent Recommend still had leftover selected fighters from the first Recommend's `SelectFighters`, so its petition-path paint pin failed (1838 passed, 1 failed). Cleared that leftover pair in `runB24A()` so the keep stays a no-selection Recommend.
5. Green: `lua tests/test_console.lua` — **1841 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1841 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1841 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1841 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Gora / glue / TOC not edited.
- `hadSelected` is computed before `recommendPair` / `SelectFighters`. Successful Recommend still stores the pair and still calls Core.
- Petition-path Recommend still stores Core `namedOpponent` and paints `"  names  "`. Petition line paint unchanged. `SaveNote` nil. No DEMANDED.
- `runB25A()` is nested inside `runB8E()` after `runB24A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Successful StartEvent / EndEvent still do not clear `selectedFighterA` / `selectedFighterB`.** A prior Recommend's `SelectFighters` can linger into the next gathering and suppress the names token unless the desk clears the pair (B24-A keep now does that in-harness).
- **No client smoke.** Live desk paint after SelectFighters + named petition + Recommend is unproven on Anniversary.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
