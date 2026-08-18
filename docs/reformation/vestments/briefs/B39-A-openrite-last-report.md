# B39-A — OpenRite Gora does not reopen the last pair (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 leftover highlight; §10.7 persist is the Gora pair, not the next rite; B10-INT: post-Continue ASSEMBLY does not overlay last pair; `Console:OpenRite("Gora")` still fell through to `GetLastSanctioned` when the desk pair was empty, so a later Open Gora reopened the finished bout; brief `docs/reformation/vestments/briefs/B39-A-openrite-last.md`. Live `GetSanctioned` fallback stays. `GetLastSanctioned` fallback is dropped. Selected `selectedFighterA` / `B` still win. Knighting OpenRite unchanged. End / Start / Dismiss keeps stay. `SaveNote` stays nil. No SUMMON. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 2798 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB39A()` inside `runB8E()` after `runB38A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB39A()` inside `runB8E()` after `runB38A()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pins: OpenRite Gora still uses selected A/B and live `GetSanctioned`, does not name `GetLastSanctioned`; Knighting still prefers `selectedHumanId` then `GetLine`; Start / End / Dismiss keep strings stay. Behavioral: live sanctioned fallback; selected pair still wins over last; Sanction A/B, OpenRite, CloseRite, rule, Continue; second OpenRite Gora without a desk pair does not pass leftover last fighters onto Runtime subjects. Knighting line-head keep. B11-C last-only VOID pin retargeted to the same refuse. SaveNote / SUMMON / parchment / tabs / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Console.lua` | `OpenRite("Gora")` keeps selected A/B, then live `GetSanctioned` only. Drops the `GetLastSanctioned` fall-through. Header notes leftover last pair is persist, not the next rite. Knighting OpenRite unchanged. No new file locals. |
| `docs/reformation/vestments/briefs/B39-A-openrite-last-report.md` | This file |
| `docs/reformation/vestments/briefs/B39-A-openrite-last.diff` | B39-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Gora, Store, Runtime, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B39-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Console:OpenRite("Gora")` | Selected `selectedFighterA` / `B` (both ids) win. Else live `Gora:GetSanctioned()` when that method exists and the pair is a table. Does **not** fall back to `GetLastSanctioned`. Missing live pair / ids → `subjects` stay nil. |
| `Console:OpenRite("Knighting")` | Unchanged. `selectedHumanId`, else `Knighting:GetLine()` head. |
| Live sanctioned fallback | Unchanged. StartEvent + Sanction A/B with no desk pair still opens Runtime subjects `{A, B}`. |
| Leftover last pair | After rule + Continue, `GetLastSanctioned` may still hold A/B. OpenRite Gora without a desk pair does not pass those ids to Runtime. |
| `SaveNote` | Stays nil. |

### Unchanged

- End / Start / Dismiss keeps (B36-B / B37-A / B38-A).
- Knighting OpenRite line-head fallback (B12-B).
- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (`runB39A()` nested in `runB8E()` after `runB38A()`: OpenRite source has live `GetSanctioned` and does not name `GetLastSanctioned`; Knighting / Start / End / Dismiss keeps stay; live sanctioned fallback; selected pair still wins; Sanction A/B, rule, Continue; second OpenRite Gora without a desk pair does not put leftover last fighters on Runtime subjects; Knighting line-head keep; SaveNote / SUMMON / isolation). B11-C last-only VOID pin retargeted to the refuse. Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **2789 passed, 9 failed** (B11-C last-only still attached leftover last fighters; OpenRite source still named `GetLastSanctioned`; Continue leftover wrap passed leftover A/B onto Runtime subjects). Live fallback / selected-wins / Knighting keep / Start / End / Dismiss keep / SaveNote / isolation stayed green.
3. `OpenRite("Gora")` keeps selected A/B, then live `GetSanctioned` only. Drops the `GetLastSanctioned` block. Knighting / Start / End / Dismiss kept.
4. After the Console patch, four leftover-id pins still failed: `fighters and fighters[1] == id` short-circuits to `nil` when `fighters` is nil, not `false`. Those compares were rewritten to `(fighters and fighters[1]) == id`.
5. Green: `lua tests/test_console.lua` — **2798 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2798 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2798 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2798 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB39A()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / Gora / Store / Runtime / TOC not edited.
- OpenRite Gora no longer falls through to `GetLastSanctioned`. Live `GetSanctioned` stays. Selected A/B still win.
- Knighting OpenRite unchanged. End / Start / Dismiss keeps stay.
- Sanction A/B, rule, Continue; OpenRite Gora without a desk pair does not put leftover last fighters on Runtime subjects.
- `runB39A()` is nested inside `runB8E()` after `runB38A()`. No new main-chunk locals.
- Isolation wrap stays. `SaveNote` nil. No SUMMON.

## Leftovers

- **OpenRite Gora after Continue still opens with nil subjects.** Runtime accepts Gora without fighters. The wrap proves leftover A/B are not passed. Not a refuse of the rite.
- **B11-C last-only VOID path is now a refuse pin, not a separate Continue sequence.** Same leftover last pair; B39-A is the named Continue sequence.
- **Selected pair vs a live `GetSanctioned` pair is still not a race pin.** Selected-wins VOIDs first, then selects. Live code short-circuits whenever both selected ids are set.
- **`GetLastSanctioned` still exists on Gora.** Persist is unchanged. Console just does not read it on OpenRite.
- **Knighting last-pair overlay is wire (B38-B / B39-INT), not this lane.**
- **No client smoke.** Live desk Open Gora after Continue (empty subjects / no leftover last pair) is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.

## Status

**DONE_WITH_CONCERNS.** Isolated **2798 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
