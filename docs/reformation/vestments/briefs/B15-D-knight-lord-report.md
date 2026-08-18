# B15-D — KnightThisBeef refuses Lord+ (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8 / §5 (Knighting writes Beef Knight; elevation is `ElevateToLord`); Law 4; brief `docs/reformation/vestments/briefs/B15-D-knight-lord.md`. A04: no GuildPromote. No `CreateFrame`. Re-knight of a Beef Knight (rank 3) stays allowed. Enqueue still uses `needsKnighting` (1 / 2 / nil only). Isolation stays Common + Ranks + Store + Knighting.

`KnightThisBeef` now refuses when `human.rankId` is a number **≥ 4** (Lord, Butcher, Council). Returns `nil, "already elevated"`. Does not `SetRank`. Does not `AppendCeremony`. Does not dequeue. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 394 passed, 0 failed (`lua tests/test_knighting.lua`). **11** isolation pins under `if standalone then` at file load (Runtime nil).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_knighting.lua` | TDD first. After the rank-3 re-knight pins: ElevateToLord then `KnightThisBeef` is nil / `"already elevated"`; rank stays 4; ceremony log does not grow; elevationAt unchanged; line unchanged. Nested `do` pin: a Store-written Lord still on the line is refused and not dequeued. Same refuse for seeded Butcher (5) and Council (6) in the existing Enqueue already-knighted block. Source names `already elevated`. Isolation wrap stays. No new main-chunk locals. |
| `addon/ChurchOfBeef/Core/Knighting.lua` | After `knownHuman` in `KnightThisBeef`: if `type(human.rankId) == "number"` and `human.rankId >= LORD_ID` then `return nil, "already elevated"`. |
| `docs/reformation/vestments/briefs/B15-D-knight-lord-report.md` | This file |
| `docs/reformation/vestments/briefs/B15-D-knight-lord.diff` | B15-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Store, Console, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add GuildPromote. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Knighting batches (working tree already dirty). The brief diff is the B15-D-only delta.

## Contract

```lua
Knighting:KnightThisBeef(humanId, now)
  -- after knownHuman:
  -- if type(human.rankId) == "number" and human.rankId >= LORD_ID then
  --   return nil, "already elevated"
  -- end
  -- else SetRank(..., 3); AppendCeremony("Knighting", ...); dequeue
```

| Rank | KnightThisBeef |
|------|----------------|
| nil / 1 / 2 | writes 3; appends; dequeues |
| 3 Beef Knight | re-knight writes 3; appends (existing pins) |
| 4 / 5 / 6 | `nil, "already elevated"`; no SetRank; no append; no dequeue |

Keep:

- Enqueue / Insert still refuse rank 3+ as `"already knighted"` via `needsKnighting` (1 / 2 / nil only)
- No GuildPromote / SetGuildRank / CreateFrame
- Isolation wrap stays (Common + Ranks + Store + Knighting)
- `promoteCalls` stay 0

## TDD

1. Extended `tests/test_knighting.lua` first (ElevateToLord then refuse; on-line Lord not dequeued; seeded Butcher / Council refuse; source pin). Isolation wrap untouched. Rank-3 re-knight pins left in place.
2. Red: `lua tests/test_knighting.lua` — **376 passed, 18 failed** (Lord / Butcher / Council were demoted to 3; ceremony log grew; on-line Lord was dequeued; source lacked `already elevated`).
3. Guard after `knownHuman` in `KnightThisBeef` only.
4. Green: `lua tests/test_knighting.lua` — **394 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_knighting.lua   # 394 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_knighting.lua` standalone | **394 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` at file load (Runtime, Gora, Officer, UI, Net, DB, Sender, Archive, Recognition, Popes, Roster). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Store / Console / glue / TOC were not edited.
- Guard is `type(human.rankId) == "number" and human.rankId >= LORD_ID`. Rank 3 still knights. Rank 1 / 2 / nil still knight.
- Failed path does not `SetRank`, does not `AppendCeremony`, does not touch `line`.
- Enqueue still uses `needsKnighting` (1 / 2 / nil). Source has no `GuildPromote` / `SetGuildRank` / `CreateFrame`.
- Isolation asserts stay under `if standalone then`. Runtime is nil at file load. `promoteCalls` stay 0.
- Rank-3 re-knight pins still pass.

## Isolated count

**394 passed, 0 failed.** Isolation wrap: **11**.

## Concerns

- **No client smoke / full harness.** Memory-only Core. Console / glue still not this lane.
- **`ElevateToLord` can still write Lord on a Butcher or Council.** This lane only gates `KnightThisBeef`.
- **A Store `SetRank` to 4 after Enqueue can still leave a Lord on the line.** Enqueue itself still refuses 3+. The refuse path leaves that leftover row in place on purpose.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **394 / 0**. Isolation wrap **11**. Not signed.
