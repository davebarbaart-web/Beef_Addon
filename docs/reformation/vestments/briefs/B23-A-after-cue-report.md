# B23-A — Theater owns §19.4 cues when Proclaim exists (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.4 (five cues; theater owns them); V-INT leftover (Console `after()` `playCue` and `Toasts:Proclaim` → `playTheaterCue` played the same name twice); brief `docs/reformation/vestments/briefs/B23-A-after-cue.md`. `playCue` now returns without `Sound:Play` when `COB.Toasts` is a table and `type(Toasts.Proclaim) == "function"`. Isolated suite does not load Toasts — existing Sound stub pins stay green. Cue arguments on the verbs stay. Console does not call Proclaim or Net. `SaveNote` stays nil. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1693 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB23A()` inside `runB8E()` after `runB22A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB23A()` inside `runB8E()` after `runB22A()` (Lua 5.1 200-local cap; no new main-chunk locals). Existing Sound stub pins untouched. Nested: `COB.Toasts = { Proclaim = function() end }`, KnightThisBeef then Sanction do not append to the Sound spy and do not call Proclaim. Source pins: Proclaim guard, cue arguments stay, isolated `Sound.Play` path stays, no `Toasts:Proclaim` / `Toasts.Proclaim(` call, SaveNote / SUMMON / parchment / tabs. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | `playCue` no-ops when `Toasts` is a table and `Proclaim` is a function. `Sound:Play` path stays for the isolated suite. Verb `after(..., cue)` arguments unchanged. No Proclaim. No Net. |
| `docs/reformation/vestments/briefs/B23-A-after-cue-report.md` | This file |
| `docs/reformation/vestments/briefs/B23-A-after-cue.diff` | B23-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not remove cue arguments. Did not call Proclaim or Net. Did not define `SaveNote`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B23-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `playCue` | If `COB.Toasts` is a table and `type(Toasts.Proclaim) == "function"`, return. Else `Sound:Play` when Sound exists. |
| `after` | Still passes the existing cue names. Does not call Proclaim or Net. |
| Isolated suite | Does not load Toasts. Existing Sound stub pins (knighting / elevation / sanction / verdict / cowardice) stay. |
| Live client | Theater owns the §19.4 cue via Proclaim. Desk `after()` does not play it again. |
| `SaveNote` | Stays nil. |

### Unchanged

- Cue arguments on Sanction / KnightThisBeef / ElevateToLord / the four rulings.
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- Existing Sound stub pin block (main chunk).

## TDD

1. Extended `tests/test_console.lua` first (`runB23A()` nested in `runB8E()` after `runB22A()`: Toasts.Proclaim stub; KnightThisBeef + Sanction do not append to the Sound spy and do not Proclaim; source / SaveNote / isolation). Isolation wrap and existing Sound pins untouched.
2. Red: `lua tests/test_console.lua` — **1690 passed, 3 failed** (KnightThisBeef and Sanction still appended to the Sound spy; source guard `type(Toasts.Proclaim) == "function"` missing). Existing Sound pins stayed green.
3. `playCue` returns when Proclaim exists. Isolated `Sound.Play` path kept. Cue arguments kept.
4. Green: `lua tests/test_console.lua` — **1693 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1693 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1693 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1693 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Toasts / Sound / glue / TOC not edited.
- `playCue` no-ops when Proclaim exists. Isolated Sound pins stay.
- Cue arguments stay. No Proclaim. No Net. `SaveNote` nil.
- `runB23A()` is nested inside `runB8E()` after `runB22A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **`lastRecommendation` lifetime across EndEvent** stays parked (Batch 23 overview).
- **Selected-pair inherit of Core `namedOpponent`** stays parked (Batch 23 overview).
- **No client smoke.** Pope-desk single cue (theater owns via Proclaim) vs congregation paint is unproven on Anniversary. Harness stubs Toasts; it does not load `Toasts.lua`.
- **ElevateToLord and the four rulings share `playCue`.** Nested spies cover KnightThisBeef and Sanction only. Source pins keep the other cue arguments.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
