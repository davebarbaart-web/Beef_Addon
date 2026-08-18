# B16-A — ElevateToLord refuses Butcher / Council (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8 / §5 (elevation writes Beef Lord; Butcher is display-only; Council is a different rank); Law 4; brief `docs/reformation/vestments/briefs/B16-A-elevate-refuse.md`. No GuildPromote. No `CreateFrame`. Re-elevate of a Beef Lord (rank 4) stays allowed (`stillLord` pin). Fresh / Cooked / Knight still elevate. `KnightThisBeef` rank ≥ 4 refuse stays. Isolation stays Common + Ranks + Store + Knighting.

`ElevateToLord` now refuses when `human.rankId` is a number **> LORD_ID** (Butcher 5 / Council 6). Returns `nil, "already elevated"`. Does not `SetRank`. Does not `AppendCeremony`. Does not dequeue. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 419 passed, 0 failed (`lua tests/test_knighting.lua`). **11** isolation pins under `if standalone then` at file load (Runtime nil).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_knighting.lua` | TDD first. After `stillLord`: Cooked (rank 2) still elevates. After the B15-D Butcher / Council `KnightThisBeef` refuse: `ElevateToLord` is nil / `"already elevated"`; ranks stay 5 / 6; ceremony log does not grow; elevationAt stays nil. Nested `do` pin: a Store-written Butcher still on the line is refused and not dequeued (cleanup Skip after). Isolation wrap stays. No new main-chunk locals. |
| `addon/ChurchOfBeef/Core/Knighting.lua` | After `knownHuman` in `ElevateToLord`: if `type(human.rankId) == "number"` and `human.rankId > LORD_ID` then `return nil, "already elevated"`. |
| `docs/reformation/vestments/briefs/B16-A-elevate-refuse-report.md` | This file |
| `docs/reformation/vestments/briefs/B16-A-elevate-refuse.diff` | B16-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Store, Console, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add GuildPromote. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Knighting batches (working tree already dirty). The brief diff is the B16-A-only delta.

## Contract

```lua
Knighting:ElevateToLord(humanId, now)
  -- after knownHuman:
  -- if type(human.rankId) == "number" and human.rankId > LORD_ID then
  --   return nil, "already elevated"
  -- end
  -- else SetRank(..., 4); AppendCeremony("Elevation", ...); dequeue
```

| Rank | ElevateToLord |
|------|----------------|
| nil / 1 / 2 / 3 | writes 4; appends; dequeues |
| 4 Beef Lord | re-elevate writes 4; appends (`stillLord`) |
| 5 / 6 | `nil, "already elevated"`; no SetRank; no append; no dequeue |

Keep:

- `KnightThisBeef` still refuses rank ≥ 4 as `"already elevated"`
- Enqueue / Insert still refuse rank 3+ as `"already knighted"` via `needsKnighting` (1 / 2 / nil only)
- No GuildPromote / SetGuildRank / CreateFrame
- Isolation wrap stays (Common + Ranks + Store + Knighting)
- `promoteCalls` stay 0

## TDD

1. Extended `tests/test_knighting.lua` first (Cooked still elevates; seeded Butcher / Council refuse; on-line Butcher not dequeued). Isolation wrap untouched. `stillLord` and `KnightThisBeef` rank ≥ 4 pins left in place.
2. Red: `lua tests/test_knighting.lua` — **403 passed, 16 failed** (Butcher / Council were demoted to 4; ceremony log grew; elevationAt written; on-line Butcher was dequeued).
3. Guard after `knownHuman` in `ElevateToLord` only (`>` LORD_ID, not `>=`).
4. Green: `lua tests/test_knighting.lua` — **419 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_knighting.lua   # 419 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_knighting.lua` standalone | **419 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` at file load (Runtime, Gora, Officer, UI, Net, DB, Sender, Archive, Recognition, Popes, Roster). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Store / Console / glue / TOC were not edited.
- Guard is `type(human.rankId) == "number" and human.rankId > LORD_ID`. Rank 4 still elevates. Rank 1 / 2 / 3 / nil still elevate.
- Failed path does not `SetRank`, does not `AppendCeremony`, does not touch `line`.
- `KnightThisBeef` still uses `>= LORD_ID`. Enqueue still uses `needsKnighting` (1 / 2 / nil). Source has no `GuildPromote` / `SetGuildRank` / `CreateFrame`.
- Isolation asserts stay under `if standalone then`. Runtime is nil at file load. `promoteCalls` stay 0.
- `stillLord` pin still passes.

## Isolated count

**419 passed, 0 failed.** Isolation wrap: **11**.

## Concerns

- **No client smoke / full harness.** Memory-only Core. Console / glue still not this lane.
- **A Store `SetRank` to 5 after Enqueue can still leave a Butcher on the line.** Enqueue itself still refuses 3+. The refuse path leaves that leftover row in place on purpose; the test Skip is cleanup only.
- Lane is unsigned. No Gate or POLISH claim.

## Status

**DONE_WITH_CONCERNS.** Isolated **419 / 0**. Isolation wrap **11**. Not signed.
