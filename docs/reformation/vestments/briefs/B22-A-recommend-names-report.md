# B22-A — Recommendation paints the named-opponent token (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.1; brief `docs/reformation/vestments/briefs/B22-A-recommend-names.md`. `Gora:Recommend` already returns `{ namedOpponent = true }` when either petition names the other combatant. `Console:Recommend` now stores that flag on `lastRecommendation`. `paintRecommendation` appends mute `"  names  "` when the flag is true. `nameA vs nameB` + mute H2H stay. `petitionLine` (`left .. "  names  " .. right`) stays. No "DEMANDED". `SaveNote` stays nil. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1645 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB22A()` inside `runB8E()` after `runB21A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB22A()` inside `runB8E()` after `runB21A()` (Lua 5.1 200-local cap; no new main-chunk locals). Retargeted the B21-A grep of `left .. "  names  " .. right` to "petition names token stays". After two characters + `Gora:Petition(b, a)` + `Console:Recommend()` (no selected pair): Recommendation text contains `"  names  "` and both names. Unnamed pair Recommend still has no token. Source pins: store `result.namedOpponent == true`, append `label = label .. "  names  "`, petitionLine copy stays. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | `Console:Recommend` stores `namedOpponent = result.namedOpponent == true` on `lastRecommendation`. `paintRecommendation` appends mute `"  names  "` when `rec.namedOpponent == true`. `suggestionLabel` / H2H / `petitionLine` unchanged. |
| `docs/reformation/vestments/briefs/B22-A-recommend-names-report.md` | This file |
| `docs/reformation/vestments/briefs/B22-A-recommend-names.diff` | B22-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Gora, Inputs, Net, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent "DEMANDED". Did not define `SaveNote`. Did not change `petitionLine`. Did not Sanction. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B22-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Gora:Recommend` | Unchanged. Already returns `namedOpponent = true` when either petition names the other combatant. |
| `Console:Recommend` | Stores `{ fighterA, fighterB, namedOpponent = result.namedOpponent == true }` on `lastRecommendation`. Still does not Sanction. |
| `paintRecommendation` | `nameA vs nameB` + mute H2H. Appends `"  names  "` only when `namedOpponent == true`. |
| `petitionLine` | Unchanged: `left .. "  names  " .. right`. |
| `SaveNote` | Stays nil. |

### Unchanged

- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- `suggestionLabel` / mute H2H. No "DEMANDED".
- B21-A grep of `left .. "  names  " .. right` stays (message retargeted).

## TDD

1. Extended `tests/test_console.lua` first (`runB22A()` nested in `runB8E()` after `runB21A()`: named petition + Recommend paints `"  names  "` and both names; unnamed pair has no token; B21-A grep retargeted; source / SaveNote / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1642 passed, 3 failed** (named Recommend reached Gora and returned `namedOpponent = true`, but the suggestion line had no token; source pins for store + append were missing).
3. `lastRecommendation` stores the flag. `paintRecommendation` appends `"  names  "`. `petitionLine` kept.
4. Green: `lua tests/test_console.lua` — **1645 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1645 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1645 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1645 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Gora / Inputs / Net / glue / TOC not edited.
- Named-opponent Recommend paints mute `"  names  "`. Unnamed pair does not.
- `petitionLine` unchanged. `SaveNote` nil. No DEMANDED.
- `runB22A()` is nested inside `runB8E()` after `runB21A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Desk `after()` double cue** stays parked (Batch 22 overview).
- **No client smoke.** Live Recommend paint vs Refresh after `Gora:Recommend` is unproven on Anniversary.
- **Named token is mechanical, not oratory.** Same mute token as petition `left .. "  names  " .. right`. The software does not announce the callout (Bible §10.2).
- **Selected pair can still inherit the flag.** `Gora:Recommend` sets `namedOpponent` from live petitions even when the Pope already selected the pair. This lane paints that Core flag; it does not change pair selection.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
