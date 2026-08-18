# B9-A — Knighting / elevation ceremony log (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1; Law 4, Law 7; brief `docs/reformation/vestments/briefs/B9-A-knighting-log.md`.

Type-only `Store:AppendCeremony` after a successful `KnightThisBeef` / `ElevateToLord`. No 4th-arg text. No scripture / narration. A refused verb does not append. Re-knight / re-elevate may append again (append-only). Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 361 passed, 0 failed (`lua tests/test_knighting.lua`). **11** isolation pins under `if standalone then` at file load (Runtime nil).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_knighting.lua` | Flipped the empty-log pins (those meant “no narration,” not “no log”). Successful KnightThisBeef → one `Knighting` row, no text/scripture/narration. ElevateToLord → one `Elevation` row. Re-click appends again. Unknown / refused verbs leave the log unchanged. Isolation wrap stays. |
| `addon/ChurchOfBeef/Core/Knighting.lua` | After successful `SetRank`, if `Store.AppendCeremony` exists: `AppendCeremony("Knighting", { humanId }, now)` / `AppendCeremony("Elevation", { humanId }, now)`. Failed write does not append. ElevateToLord still dequeues. |
| `docs/reformation/vestments/briefs/B9-A-knighting-log-report.md` | This file |
| `docs/reformation/vestments/briefs/B9-A-knighting-log.diff` | B9-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Store, Console, Gora, Toasts, TOC, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Store:AppendCeremony("Knighting", { humanId }, now)   -- after successful KnightThisBeef
Store:AppendCeremony("Elevation", { humanId }, now)   -- after successful ElevateToLord
```

Type token + human id + time only. No 4th-arg text. No `scripture` / `narration`.

Keep:

- No GuildPromote / SetGuildRank / CreateFrame
- No `queue` / `AdvanceQueue` / `NextCandidate`
- ElevateToLord still dequeues that human
- No auto-knight
- Isolation wrap stays (Common + Ranks + Store + Knighting)

## TDD

1. Flipped `#GetCeremonyLog() == 0` after the two verbs; added type / ids / `at` / nil text-scripture-narration pins; unknown / refused → log unchanged; re-click appends again.
2. Implemented the two 3-arg appends after successful `SetRank`.
3. Green: `lua tests/test_knighting.lua` — **361 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_knighting.lua   # 361 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_knighting.lua` standalone | **361 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` at file load (Runtime, Gora, Officer, UI, Net, DB, Sender, Archive, Recognition, Popes, Roster). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run. Console paint is B9-C.

## Self-review

- Exclusive implementation files only. Store was Read, not edited.
- Append is 3-arg. No generated scripture. `Knighting.Narrate` / `Proclaim` stay nil.
- Refused unknown / name / key / zero / nil do not append. Re-knight and re-elevate append again (Law 7).
- ElevateToLord still expires then `line[human.id] = nil`. No GuildPromote. No CreateFrame.
- Isolation asserts stay under `if standalone then`. Runtime is nil at file load.

## Isolated count

**361 passed, 0 failed.** Isolation wrap: **11**.

## Concerns

- **`AppendCeremony` return is ignored.** After a successful `SetRank`, a failed append would still dequeue and return the rank row. Current Store cannot fail this 3-arg call with a valid human id. Same pattern as Recognition.
- **Missing `AppendCeremony` is unpinned.** The isolated suite always loads Store. The existence guard is untested except by that load.
- **Clock-omitted `now` is unpinned on the log.** `ElevateToLord` without `now` still pins `elevationAt` via Store's clock; ceremony `at` in that block is not pinned.
- **No client smoke / full harness.** Memory-only Core. B9-C paints the ceremony-log desk.

## Status

**DONE_WITH_CONCERNS.** Isolated **361 / 0**. Isolation wrap **11**. Not signed.
