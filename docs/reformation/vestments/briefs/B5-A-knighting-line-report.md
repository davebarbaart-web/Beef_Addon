# B5-A — Knighting line (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8; Law 4; brief `docs/reformation/vestments/briefs/B5-A-knighting-line.md`.

Memory-only knighting line on the Pope's client. Not a public `queue`, not `AdvanceQueue`. Software never auto-advances or auto-knights. No GuildPromote / SetGuildRank. No CreateFrame. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 306 passed, 0 failed (`lua tests/test_knighting.lua`). **11** isolation pins under `if standalone then` at file load (Runtime nil).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_knighting.lua` | Kept existing knight / Lord / pin suite. Added line API, copies, latecomer Insert, Skip, rank 3+ refuse, KnightThisBeef removal, inline Runtime.Snapshot expire stub, ResetForTests, source greps. Isolation wrap stays. |
| `addon/ChurchOfBeef/Core/Knighting.lua` | Local `line` table. Enqueue / Insert / Skip / GetLine / ResetForTests. Successful KnightThisBeef removes that human. Event-scope only when `Runtime.Snapshot` is loaded. |
| `docs/reformation/vestments/briefs/B5-A-knighting-line-report.md` | This file |
| `docs/reformation/vestments/briefs/B5-A-knighting-line.diff` | B5-A-only unified diff of the exclusive implementation files |

Did not edit Console, Runtime, Store, TOC, `tests/run.lua`, `ChurchOfBeef.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Knighting:Enqueue(humanId)   -- append if needs Knighting (rank nil/1/2)
Knighting:Insert(humanId)    -- latecomer append (same rules; already-in-line is a no-op success)
Knighting:Skip(humanId)      -- remove without knighting
Knighting:GetLine()          -- copies, oldest-first; { humanId, rankId }
Knighting:ResetForTests()    -- _IN_TEST only; wipe the line
```

Existing pins stay:

- `Knighting.queue` / `next` / `AdvanceQueue` / `NextCandidate` are nil
- `KnightThisBeef` does not call Runtime verbs and does not write Lord

Rules:

- Unknown / non-human id → refuse (`invalid human id` / `unknown human` from Store).
- Rank 3+ → `nil, "already knighted"`. ElevateToLord does not enqueue or dequeue.
- Runtime missing (isolated suite): Enqueue / Insert / GetLine work with no event gate.
- Runtime loaded (`Snapshot` is a function): no live `eventId` / QUIET → Enqueue / Insert refuse `no event`; GetLine empty after expire. Same `eventId` survives RITE / CONSEQUENCE / return to ASSEMBLY.
- Successful `KnightThisBeef` removes that human. Never auto-calls KnightThisBeef. Never OpenRite.
- Getters return copies. Line is process memory only.

## TDD

1. Existing suite pins stayed (no public queue, no Runtime verbs from KnightThisBeef, no Lord write).
2. Extended `test_knighting.lua` with line / expire / removal tests (inline Snapshot stub; Runtime still nil at file load).
3. Implemented the local line in `Knighting.lua`.
4. Green: `lua tests/test_knighting.lua` — **306 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_knighting.lua   # 306 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_knighting.lua` standalone | 306 passed, 0 failed. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Isolation asserts stay under `if standalone then`. Runtime is nil at file load.
- Line lives in a local table. `Knighting.line` is nil. No `GetQueue`.
- Enqueue / Insert never call KnightThisBeef or OpenRite. KnightThisBeef removal is not AdvanceQueue.
- Source has no `GuildPromote`, `SetGuildRank`, `CreateFrame`, `SendChatMessage`, `SendAddonMessage`, or `ChurchOfBeefDB`.
- Event-scope matches Confession/Gora expire, except missing Runtime does **not** refuse (isolated suite).

## Concerns

- **Integrator glue is still required.** TOC, `run.lua`, and Console were not edited. B5-C paints `GetLine` / Enqueue / Skip.
- **Enqueue and Insert share one add path.** Already-in-line is a no-op success for both so the line cannot duplicate or reorder. The brief named that no-op on Insert; Enqueue follows the same rule.
- **ElevateToLord does not touch the line.** A human already waiting can be elevated and remain until Skip or KnightThisBeef. GetLine then shows rank 4. Brief: elevation does not use the line.
- **GetLine has no present-and-alive filter.** Targeting / raid marks are B5-B. Console paints names from Store (B5-C).
- **Event-scope keys off `Runtime.Snapshot` being a function**, not merely `COB.Runtime` existing. The existing no-Snapshot Runtime stub in this suite stays unscoped.
- Client `/reload` was not run. Memory-only Core has no Quiet chrome to smoke.

## Status

**DONE_WITH_CONCERNS.** Not signed.
