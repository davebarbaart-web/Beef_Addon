# B38-A — Dismiss drops leftover pair when the dismissed id is in it (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 leftover highlight; B37-A nils `selectedCharacterId` on successful Dismiss; `selectedFighterA` / `B` and `lastRecommendation` still lived, so `FlagFamousUpset` (~1941–1948) fell through to leftover `selectedFighterA` when the character pick was nil and `Sanction` still used the leftover pair; brief `docs/reformation/vestments/briefs/B38-A-dismiss-pair.md`. Successful `Dismiss` (`ok` true): if the dismissed id is `selectedFighterA` or `selectedFighterB`, also nils the pair and `lastRecommendation` **before** Refresh. Dismiss of a third id keeps the pair. Failed Dismiss keeps. Does **not** nil `selectedHumanId`. B37-A `selectedCharacterId` nil stays. End / Start keeps stay. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 2674 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB38A()` inside `runB8E()` after `runB37A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB38A()` inside `runB8E()` after `runB37A()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pins: Dismiss success block still nils `selectedCharacterId`, then nils `lastRecommendation` and the pair when the dismissed id is A or B, then Refresh; does not nil `selectedHumanId`; Start / End / Refresh keep strings stay. Behavioral: select pair A/B + Recommend; failed Dismiss keeps pair and Recommend; Dismiss of a third id keeps A/B and Recommend; Dismiss A nils pair and Recommend; FlagFamousUpset / Sanction without explicit ids do not fire on leftover A. B32-B / B37-A Dismiss success source pins updated to the same block. SaveNote / SUMMON / parchment / tabs / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Console.lua` | Successful `Dismiss` (`ok` true): B37-A `selectedCharacterId` nil stays; if the dismissed id is `selectedFighterA` or `selectedFighterB`, also nils the pair and `lastRecommendation` before Refresh. Dismiss of a third id keeps the pair. Failed Dismiss unchanged. Does not nil `selectedHumanId`. Header notes the pair lifetime. No new file locals. |
| `docs/reformation/vestments/briefs/B38-A-dismiss-pair-report.md` | This file |
| `docs/reformation/vestments/briefs/B38-A-dismiss-pair.diff` | B38-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Gora, Store, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B38-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Console:Dismiss` | On `ok` true (Gora or Confession-only), `selectedCharacterId = nil`. If the dismissed id is `selectedFighterA` or `selectedFighterB`, also `lastRecommendation = nil` and nil the pair. Then `Refresh()`. Dismiss of a third id keeps the pair. Failed Dismiss keeps. Does not nil `selectedHumanId`. Fallback `characterId or self.selectedCharacterId` stays. |
| `Console:StartEvent` | Unchanged. Still nils only `lastRecommendation` and the pair. Does not nil human / character. |
| `Console:EndEvent` | Unchanged. Still nils human / character / pair on success (B36-B). |
| `Console:Refresh` | Unchanged. Does not nil the pick or the pair. QUIET still nils `lastRecommendation` (B31-A). |
| FlagFamousUpset / Sanction | Unchanged fallbacks (`selectedCharacterId` else fighterA; selected pair). After a successful Dismiss of A they resolve nil and refuse. |
| `SaveNote` | Stays nil. |

### Unchanged

- B37-A successful Dismiss nils `selectedCharacterId`. Failed Dismiss keeps the character pick.
- B32-B Dismiss still reaches Confession when present (same resolved id). Isolated Gora-only Dismiss stays when Confession is nil.
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB38A()` nested in `runB8E()` after `runB37A()`: Dismiss source nils character, then pair + `lastRecommendation` when the dismissed id is A or B, before Refresh, and does not nil human; Start / End / Refresh keeps stay; select pair A/B + Recommend; failed Dismiss keeps; third-id Dismiss keeps A/B and Recommend; Dismiss A nils pair and Recommend; leftover FlagFamousUpset / Sanction without an explicit id refuse or no-op; SaveNote / SUMMON / isolation). B32-B / B37-A success-block pins updated to the new string. Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **2659 passed, 15 failed** (Dismiss source missing pair nil; Dismiss A left `selectedFighterA` / `B` and Recommendation; FlagFamousUpset wrap fired leftover A/B; Sanction without ids sanctioned leftover A/B). Failed Dismiss keep / third-id keep / human keep / B37-A character nil / Start / Refresh keep / SaveNote / isolation stayed green.
3. `Dismiss` keeps `selectedCharacterId = nil` when `ok` is true. If `isId(id)` and the id is `selectedFighterA` or `selectedFighterB`, also nils `lastRecommendation` and the pair, before `Refresh()`. Does not nil `selectedHumanId`. Start / End / Refresh kept.
4. Green: `lua tests/test_console.lua` — **2674 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2674 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2674 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2674 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB38A()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / Gora / Store / TOC not edited.
- Successful Dismiss of a pair member nils the pair and `lastRecommendation` before Refresh. Third-id Dismiss keeps. Failed Dismiss keeps. Does not nil `selectedHumanId`. B37-A character nil stays.
- End / Start / Refresh keeps stay.
- Leftover FlagFamousUpset / Sanction without an explicit id do not fire on leftover A.
- `runB38A()` is nested inside `runB8E()` after `runB37A()`. No new main-chunk locals.
- Isolation wrap stays. `SaveNote` nil. No SUMMON.

## Leftovers

- **Sanction leftover is wrap-plus-refuse.** After Dismiss A, `Gora:Sanction(nil, nil)` refuses `a Gora needs two different combatants`. The wrap proves the resolved ids are nil, not leftover A/B. Pre-fix, the same call sanctioned leftover A/B.
- **FlagFamousUpset leftover is wrap-plus-refuse.** Store is still invoked with `nil, nil` and returns `invalid character id`. The wrap proves the resolved victor is not leftover A.
- **Dismiss B is source-pinned, not a separate behavioral case.** The condition is `id == selectedFighterA or id == selectedFighterB`. Only Dismiss A is exercised live.
- **Confession-only success with a pair member is not separately pinned.** The same `ok` block runs; B32-B dual-reach stays. Isolation wrap does not load `Confession.lua`.
- **QUIET Refresh still nils `lastRecommendation` (B31-A).** Third-id Recommend-keep is proven in ASSEMBLY after `StartEvent`. A Quiet-desk Dismiss of a third id would still empty the Recommend paint via Refresh even though the pair stays.
- **No client smoke.** Live desk after Dismiss A (empty proposed bout / no leftover Sanction) is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.

## Status

**DONE_WITH_CONCERNS.** Isolated **2674 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
