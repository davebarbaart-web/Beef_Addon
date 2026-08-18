# B33-B — Presence rows honor here == false (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 Presence is who is here; `GetPresence` already writes `here` (true on roster, false on fail-open Store); `presenceLine` / `paintRowButtons` ignored it; brief `docs/reformation/vestments/briefs/B33-B-presence-here.md`. Fail-open membership stays. No mute suffix / "offline" / "away". Petitions / confessions / knighting are not dimmed. `SaveNote` stays nil. No SUMMON. No `UnitIsDead`. Exclusive files only. No commit. Lane is not signed.

`paintPresence` (~832) still paints `presenceLine` and `paintRowButtons`. After that Presence-only pool walk, `row.here == false` stock `SetAlpha(0.45)` on the row button; otherwise `SetAlpha(1)`. `paintRowButtons` itself does not dim. Console stays plain.

**Isolated count:** 2297 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB33B()` inside `runB8E()` after `runB32B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB33B()` inside `runB8E()` after `runB32B()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: `paintPresence` after `paintRowButtons` honors `here == false` with `SetAlpha(0.45)` / else `SetAlpha(1)`; `paintRowButtons` / petitions / confessions / knighting do not `SetAlpha`; `presenceLine` still ignores `here` and adds no offline / away. Behavioral: fail-open Store-only row stub alpha ~0.45; roster `here == true` stays 1; petition row stays 1. Tiny `SetAlpha` / `GetAlpha` stub because `wow_ui_stub` lists the names as no-ops. SaveNote / SUMMON / parchment / tabs / isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Console.lua` | After `paintRowButtons` in `paintPresence` only, type-guarded `SetAlpha(0.45)` when `here == false`, else `SetAlpha(1)`. Header notes the dim. No new file locals. Fail-open membership unchanged. |
| `docs/reformation/vestments/briefs/B33-B-presence-here-report.md` | This file |
| `docs/reformation/vestments/briefs/B33-B-presence-here.diff` | B33-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Roster, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add parchment, tabs, or SUMMON. Did not define `SaveNote`. Did not add a mute suffix. Did not commit.

`git diff HEAD` on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B33-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| Presence `here == false` | After `paintRowButtons`, stock `SetAlpha(0.45)` on that row button. |
| Presence `here ~= false` | `SetAlpha(1)`. |
| `presenceLine` | Unchanged. Name / rank / needs Knighting. No offline / away / not-here suffix. |
| `GetPresence` fail-open | Unchanged. Roster `here = true`; Store-only `here = false`. Membership walk stays. |
| Petitions / confessions / knighting | Not dimmed. `paintRowButtons` does not `SetAlpha`. |
| `SaveNote` | Stays nil. |

### Unchanged

- B21-A fail-open membership. Complete roster still lists members only.
- B18-B / B4-D petition paint. B20-A confession rows. Knighting line paint.
- B32-B Dismiss / CallForward pins.
- Stock desk. No parchment. No tabs. No SUMMON. No `UnitIsDead`.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- No new file locals in `Console.lua`.

## TDD

1. Extended `tests/test_console.lua` first (nested `runB33B()` in `runB8E()` after `runB32B()`: `paintPresence` source honors `here == false` with `SetAlpha(0.45)` / else `SetAlpha(1)`; shared `paintRowButtons` and the other desks do not dim; `presenceLine` stays mute of `here`; fail-open Store-only stub alpha ~0.45; roster `here == true` stays 1; petition row stays 1; SaveNote / SUMMON / `UnitIsDead` / parchment / tabs / isolation). Isolation wrap untouched except the new nested pin block. Tiny `SetAlpha` / `GetAlpha` stub records alpha because the harness names are no-ops.
2. Red: `lua tests/test_console.lua` — **2293 passed, 4 failed** (source missing `here == false` / `SetAlpha(0.45)` / `SetAlpha(1)` in `paintPresence`; fail-open stub alpha stayed 1). Roster-here / petition-not-dimmed / `presenceLine` mute / SaveNote / isolation stayed green.
3. `paintPresence` walks the Presence pool after `paintRowButtons` and type-guards `SetAlpha`. Fail-open membership kept.
4. Green: `lua tests/test_console.lua` — **2297 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 2297 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **2297 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 2297 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged. `runB33B()` re-pins 4 of them plus `COB.Popes`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Roster / glue / TOC not edited.
- Presence-only dim after `paintRowButtons`. Shared row painter does not gray other desks.
- No mute suffix. No "offline" / "away". Fail-open membership unchanged.
- `runB33B()` is nested inside `runB8E()` after `runB32B()`. No new main-chunk locals.
- Isolation wrap stays. `SaveNote` nil. No SUMMON. No `UnitIsDead`.

## Leftovers

- **No client smoke.** Stock `SetAlpha(0.45)` on Anniversary Presence rows is unproven; the harness covers the stub alpha and the Presence-only source pin.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **`wow_ui_stub` SetAlpha / GetAlpha are no-ops.** The suite pins a tiny recorder on row buttons. The stub file was not edited.
- **Fail-open still lists Store-only names.** Only alpha changes. A later lane would have to decide whether incomplete Roster should hide those rows — not this brief.

## Status

**DONE_WITH_CONCERNS.** Isolated **2297 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
