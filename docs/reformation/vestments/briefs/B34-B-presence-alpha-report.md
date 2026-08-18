# B34-B — leftover Presence buttons reset alpha (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 Presence is who is here; B33-B dims visible `here == false` with stock `SetAlpha(0.45)`; `acquireRows` leftover Hide (`count + 1` tail, including count `0`) left a dim leftover at `0.45` until reuse; brief `docs/reformation/vestments/briefs/B34-B-presence-alpha.md`. Visible `here == false` stays `0.45` after `paintPresence`. Visible `here ~= false` stays `1`. Petitions / confessions / knighting stay undimmed. No new Presence copy. Console stays plain. `SaveNote` stays nil. No SUMMON. No `UnitIsDead`. Exclusive files only. No commit. Lane is not signed.

`acquireRows` leftover Hide now type-guards `SetAlpha(1)` when present. Shared pools (petitions etc.) get the same leftover reset; those lists never dim. `paintRowButtons` does not `SetAlpha`. `paintPresence` still dims only visible Presence `here == false`.

**Isolated count:** 2398 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB34B()` inside `runB8E()` after `runB33B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB34B()` inside `runB8E()` after `runB33B()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: `acquireRows` leftover tail still Hide and `SetAlpha(1)`; `paintRowButtons` / petitions / confessions / knighting do not `SetAlpha`; `paintPresence` still dims visible `here == false` and adds no offline / away. Behavioral: fail-open here stays 1 / Store ~0.45; nil Roster + Refresh hides leftover Presence buttons at alpha 1; re-paint fail-open here stays 1 / Store ~0.45; petition stays 1. Reuses B33-B `pinAlpha` pattern. SaveNote / SUMMON / parchment / tabs / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Console.lua` | Leftover `acquireRows` Hide type-guards `SetAlpha(1)`. Header notes the leftover reset. No new file locals. Visible Presence dim unchanged. |
| `docs/reformation/vestments/briefs/B34-B-presence-alpha-report.md` | This file |
| `docs/reformation/vestments/briefs/B34-B-presence-alpha.diff` | B34-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Roster, Inputs, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not add "offline" / "away". Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B34-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| Leftover Presence Hide | `acquireRows` `count + 1` tail (including count `0`) Hide, then `SetAlpha(1)` if present. |
| Visible Presence `here == false` | After `paintPresence`, stock `SetAlpha(0.45)`. Unchanged from B33-B. |
| Visible Presence `here ~= false` | `SetAlpha(1)`. |
| Petitions / confessions / knighting | Not dimmed. `paintRowButtons` does not `SetAlpha`. Shared leftover reset to 1 is fine. |
| `presenceLine` | Unchanged. No offline / away / not-here suffix. |
| `SaveNote` | Stays nil. |

### Unchanged

- B33-B visible Presence dim after `paintRowButtons`.
- B21-A fail-open membership. Missing / not-ready Roster still `{}`.
- B18-B / B4-D petition paint. B20-A confession rows. Knighting line paint.
- Stock desk. No parchment. No tabs. No SUMMON. No `UnitIsDead`.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (nested `runB34B()` in `runB8E()` after `runB33B()`: `acquireRows` leftover Hide `SetAlpha(1)`; shared `paintRowButtons` and the other desks do not dim; fail-open here 1 / Store ~0.45; empty Presence leftover hidden `GetAlpha() == 1`; re-paint fail-open here 1 / Store ~0.45; petition stays 1; SaveNote / SUMMON / `UnitIsDead` / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block. Reused B33-B `pinAlpha` / `GetAlpha` stub.
2. Red: `lua tests/test_console.lua` — **2394 passed, 4 failed** (source missing leftover `SetAlpha(1)` / type-guarded `SetAlpha`; hidden dim leftover stayed `0.45`; leftover pool `GetAlpha` stayed `0.45`). Visible here / re-paint here / petition-not-dimmed / `presenceLine` mute / SaveNote / isolation stayed green.
3. `acquireRows` leftover Hide type-guards `SetAlpha(1)`. Visible Presence dim kept in `paintPresence` only.
4. Green: `lua tests/test_console.lua` — **2398 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2398 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2398 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2398 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB34B()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Roster / Inputs / glue / TOC not edited.
- Leftover reset lives in shared `acquireRows`, not `paintRowButtons`. Visible Presence dim stays Presence-only.
- No mute suffix. No "offline" / "away". Fail-open membership unchanged.
- `runB34B()` is nested inside `runB8E()` after `runB33B()`. No new main-chunk locals.
- Isolation wrap stays. `SaveNote` nil. No SUMMON. No `UnitIsDead`.

## Leftovers

- **No client smoke.** Stock leftover `SetAlpha(1)` on Anniversary hidden Presence buttons is unproven; the harness covers the stub alpha and the `acquireRows` source pin.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **`wow_ui_stub` SetAlpha / GetAlpha are no-ops.** The suite pins a tiny recorder on row buttons. The stub file was not edited.
- **Shared leftover reset.** Petition / confession / knighting leftover Hide also `SetAlpha(1)`. Those lists never dim; intended.
- **Empty Presence via nil Roster.** B21-A already pins missing Roster as `{}`. A shrink from 2 visible rows to 1 leftover (non-empty tail) is the same `count + 1` loop and is not separately painted.

## Status

**DONE_WITH_CONCERNS.** Isolated **2398 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim.
