# B6-C — ElevateToLord leaves the knighting line (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8, §10.4; Law 4; B5-A nit; brief `docs/reformation/vestments/briefs/B6-C-lord-line.md`.

Successful `ElevateToLord` removes that `humanId` from the local knighting line, same as `KnightThisBeef`. Software never auto-knights. No Runtime verbs. No GuildPromote. `queue` / `AdvanceQueue` / `NextCandidate` / `next` stay nil. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 336 passed, 0 failed (`lua tests/test_knighting.lua`). **11** isolation pins under `if standalone then` at file load (Runtime nil).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_knighting.lua` | Flipped the leftover-Lord pins. Enqueue → ElevateToLord → GetLine does not contain that id. Others stay; refused / off-line elevate does not dequeue; no Runtime / GuildPromote / queue names. Isolation wrap stays. |
| `addon/ChurchOfBeef/Core/Knighting.lua` | After successful `SetRank(..., 4)`, expire then `line[human.id] = nil`. Failed SetRank does not dequeue. |
| `docs/reformation/vestments/briefs/B6-C-lord-line-report.md` | This file |
| `docs/reformation/vestments/briefs/B6-C-lord-line.diff` | B6-C-only unified diff of the exclusive implementation files |

Did not edit Console, Store, TOC, `tests/run.lua`, Runtime, `ChurchOfBeef.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Knighting:ElevateToLord(humanId, now)  -- SetRank 4; on success, drop that human from the local line
```

Existing pins stay:

- `Knighting.queue` / `next` / `AdvanceQueue` / `NextCandidate` are nil
- ElevateToLord does not call Runtime verbs and does not auto-knight the remainder
- KnightThisBeef still writes rank 3 only and still removes only the clicked human
- No GuildPromote / SetGuildRank

Rules:

- Enqueue → ElevateToLord → GetLine does not contain that id.
- Others stay, unknighted. Removal is not AdvanceQueue.
- Refused ElevateToLord (unknown id) does not dequeue.
- Elevating a human already off the line, or never on it, does not scramble the remainder.
- Failed `SetRank` does not dequeue.

## TDD

1. Flipped the B5-A leftover-Lord pins and added the three-person removal / refuse / off-line cases.
2. Red: `lua tests/test_knighting.lua` — 326 passed, 10 failed (elevated id still on the line).
3. Mirrored the KnightThisBeef success tail on `ElevateToLord`.
4. Green: `lua tests/test_knighting.lua` — **336 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_knighting.lua   # 336 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_knighting.lua` standalone | 336 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` at file load (Runtime, Gora, Officer, UI, Net, DB, Sender, Archive, Recognition, Popes, Roster).

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Isolation asserts stay under `if standalone then`. Runtime is nil at file load.
- Line stays file-local. `Knighting.queue` / `next` / `AdvanceQueue` / `NextCandidate` remain nil after elevation removal.
- ElevateToLord never calls KnightThisBeef or OpenRite. The remainder is not knighted.
- Source has no `GuildPromote`, `SetGuildRank`, `CreateFrame`, `SendChatMessage`, `SendAddonMessage`, or `ChurchOfBeefDB`.
- Success path matches KnightThisBeef: `SetRank` first; only then `_Expire` and `line[human.id] = nil`.

## Concerns

- **`KnightThisBeef` can still write rank 3 on an already-Lord human** if the Pope clicks by id. `Store:SetRank` has no one-way gate. This lane only takes them off the line so GetLine no longer offers them as next.
- **No shared `leaveLine` helper.** The two-line success tail is duplicated with KnightThisBeef on purpose (same as, not a refactor of, the knighting verb).
- **ElevateToLord during a live `Runtime.Snapshot` event is not separately pinned.** KnightThisBeef event-line removal stays. The expire-then-nil path is the same function pair.
- Client `/reload` was not run. Memory-only Core has no Quiet chrome to smoke.

## Status

**DONE_WITH_CONCERNS.** Not signed.
