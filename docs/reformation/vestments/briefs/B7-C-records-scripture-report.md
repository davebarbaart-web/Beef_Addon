# B7-C — Records Book canonized scripture (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §16, §10.9, §14.2, §19.3; Law 4, Law 10; brief `docs/reformation/vestments/briefs/B7-C-records-scripture.md`. CONTINUE 2026-08-18 license 4 (stock only). B6-B identity leaf kept.

Right parchment leaf already paints marked-moment **locations**. If a moment has `scripture` (Pope text), that string paints **after** the location. No “on this day” copy. `PAGE_TITLES` stays the nine Bible names. Famous Upsets still read `famousUpset` only. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 356 passed, 0 failed (`lua tests/test_records.lua`). **11** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Source pin reads `scripture`; book does not `CanonizeMoment`. Seed `FlagMoment("Goldshire Inn")` + scripture field (or `CanonizeMoment` when Store has it) → right leaf contains `The fountain ran red` after the location, not `ordained`. `PAGE_TITLES` count 9. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | `momentLines` paints `location` then `scripture` when present. `PAGE_TITLES` untouched. No generated prose. |
| `docs/reformation/vestments/briefs/B7-C-records-scripture-report.md` | This file |
| `docs/reformation/vestments/briefs/B7-C-records-scripture.diff` | B7-C-only unified diff of the exclusive implementation files |

Did not edit PAGE_TITLES, Console, Store, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

### Right leaf (moments)

| Widget | Source | Empty |
|--------|--------|--------|
| `frame.Moments` | `Store:GetMarkedMoments()` — each row’s `location` (if nonempty), then that row’s `scripture` (if nonempty) | Nil / empty location or scripture omitted. No date, no `at`, no invented line. |

Location-only moments still paint the location (B6-B). Scripture is Pope text as stored. The book does not write `FlagMoment` or `CanonizeMoment`.

`PAGE_TITLES` stays the nine Bible names. Left `Body` stays superlatives. Famous Upsets still require the Pope `famousUpset` flag.

### Unchanged

- `PAGE_TITLES` — nine Bible names, Bible order. OPEN_QUESTIONS #3 parked.
- Honorifics resolve, ribbons, prev/next, roman paint, stock QuestBG / MORPHEUS / `UI-Quickslot2`.
- Quiet, no sound, no search, not a ladder. Show / Hide still do not write Store.

## TDD

1. Extended `test_records.lua` first (scripture source pin, seed FlagMoment + scripture field, after-location paint, no `ordained`, nine titles). Isolation wrap untouched.
2. Red: `moment.scripture` unread; seeded text absent from the right leaf.
3. Implemented `momentLines` location-then-scripture paint.
4. Green: `lua tests/test_records.lua` — **356 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 356 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | 356 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Nine Bible titles unchanged vs this lane’s baseline.
- Source has no `Media\\`, `ordained`, `folk hero`, `on this day`, `unrecognized`, `PlaySound`, `SLASH_`, `AddHonorific`, `FlagMoment`, or `CanonizeMoment`. Source reads `scripture`.
- UI reads Store copies only. It does not mark or canonize.
- Seeded Pope text paints after the location. Missing scripture adds nothing.
- Quiet: no sound, no tenth page, no jokes.

## Concerns

- **No client smoke.** Location + scripture share one `Moments` FontString. Long Pope text may wrap under honorifics. **POLISH:CANDIDATE** only.
- **B7-A not landed here.** Store still has no `CanonizeMoment`. The suite seeds `scripture` via `Snapshot`/`Restore` and will call `CanonizeMoment` when that API exists. Production paint only reads `GetMarkedMoments()`.
- **Locationless + scripture** would still paint the scripture line (location omitted). Not pinned; B6-B still omits empty locations.
- Famous Upsets path was not changed. Existing `famousUpset` pins still pass.
- Integrator glue was not required. `/reload` was not run.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
