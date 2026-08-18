# B5-A — Knighting line (not an auto-queue)

**Exclusive:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

**Do not edit** Console, Runtime, Store, TOC, run.lua. Do not commit. No GuildPromote / SetGuildRank. No CreateFrame.

## Law

Bible §8: the Pope sees who needs Knighting and who is next; latecomers insert; **software never auto-advances or auto-knights** (Law 4). Existing suite pins stay:

- `Knighting.queue` == nil (no public field named `queue`)
- `Knighting.next` == nil
- `Knighting.AdvanceQueue` == nil
- `Knighting.NextCandidate` == nil
- `KnightThisBeef` does not call Runtime verbs and does not write Lord

Keep the line in a **local** table.

```lua
Knighting:Enqueue(humanId)   -- append if needs Knighting (rank nil/1/2)
Knighting:Insert(humanId)    -- latecomer append (same rules; already-in-line is a no-op success)
Knighting:Skip(humanId)      -- remove without knighting
Knighting:GetLine()          -- copies, oldest-first; { humanId, rankId }
Knighting:ResetForTests()    -- _IN_TEST only; wipe the line
```

- Unknown / non-human id → refuse.
- Rank 3+ → refuse `already knighted` (or similar). ElevateToLord does not use the line.
- Event-scoped **when Runtime is loaded**: no live eventId / QUIET → Enqueue/Insert refuse `no event`; GetLine empty after expire. If Runtime is missing, Enqueue still works (isolated suite).
- Successful `KnightThisBeef` **removes that human** from the line (the Pope already clicked — not AdvanceQueue).
- Never auto-call KnightThisBeef. Never OpenRite.

## Tests

Keep existing pins. Add line tests with an inline Runtime.Snapshot stub for expire. Isolation wrap stays (`Runtime` nil at file load). `lua tests/test_knighting.lua` exit 0.

Report `docs/reformation/vestments/briefs/B5-A-knighting-line-report.md` + diff.
