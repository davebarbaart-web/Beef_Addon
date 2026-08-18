Spec PASS

# B5-A — Knighting line (review)

**Quality:** Approved-with-nits

**Lane:** B5-A Knighting line (Core)
**Brief:** `docs/reformation/vestments/briefs/B5-A-knighting-line.md`
**Writer report:** `docs/reformation/vestments/briefs/B5-A-knighting-line-report.md`
**Diff:** `docs/reformation/vestments/briefs/B5-A-knighting-line.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

Task-scoped gate only. Reviewer read the brief, the report, `Core/Knighting.lua`, and `tests/test_knighting.lua`; then ran `lua tests/test_knighting.lua` (**306 passed, 0 failed, exit 0**). Did not mutate the working tree except this review file. Did not edit `Knighting.lua` or the suite. Did not commit.

This review does not sign the lane.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Local line; `Knighting.queue` / `next` / `AdvanceQueue` / `NextCandidate` stay nil | **Pass.** Line and `nextSeq` are file-local. `Knighting.line` is nil. Existing pins plus post-removal pins still assert the four public names are nil. Source has no `AdvanceQueue` / `NextCandidate` / `OpenRite` function. |
| `Enqueue` / `Insert` / `Skip` / `GetLine` | **Pass.** All four exist. Enqueue and Insert append if rank is nil/1/2. Already-in-line is a no-op success (no duplicate, no reorder). Skip removes without writing rank. GetLine is copies, oldest-first, `{ humanId, rankId }` only. |
| `KnightThisBeef` removes that human; does not call Runtime verbs; does not write Lord | **Pass.** After a successful `SetRank(..., 3)` the human is dropped from the line. Others stay unknighted. Off-line knighting does not touch the remainder. Runtime stub (`OpenRite` / `EndEvent` / `CloseRite` / `Continue`) stays at zero. Rank written is 3, never 4. |
| No `GuildPromote` / `SetGuildRank` | **Pass.** Source has neither symbol (nor `CreateFrame`, chat, addon message, or `ChurchOfBeefDB`). Planted promote / frame counters stay at 0 across knight, elevate, and line verbs. |
| Event-scoped when Runtime is loaded; isolated suite still Enqueues | **Pass.** Gate is `Runtime` present **and** `Snapshot` is a function (same shape as Gora / Confession). QUIET / missing `eventId` → Enqueue/Insert `nil, "no event"`; GetLine empty after expire. Same `eventId` survives RITE / CONSEQUENCE / return to ASSEMBLY. New `eventId` wipes. Isolated load: Runtime is nil and Enqueue works. |
| Isolated green; isolation wrap stays | **Pass. Verified.** `lua tests/test_knighting.lua` — 306 passed, 0 failed, exit 0. **11** nil-module pins remain under `if standalone then` at file load. Runtime is nil at load. |
| Exclusive files; no Console / Runtime / Store / TOC / `run.lua` / commit | **Pass.** Provided diff is the two exclusive files. Writer did not list TOC / `run.lua` / Console edits. `test_knighting` was already on the harness list. |

Bible §8 and Law 4 hold on this pair: the Pope can see who is next; latecomers append; software never auto-calls `KnightThisBeef` or `OpenRite`. Removal after the Pope clicks is not `AdvanceQueue`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Integrator must list TOC / wire B5-C | **Not a miss.** Brief forbade Console / TOC / `run.lua`. |
| Enqueue and Insert share one add path | **Acceptable.** Brief named the already-in-line no-op on Insert; applying it to Enqueue prevents a second row or a reorder. See Minor. |
| ElevateToLord does not dequeue | **Not a miss.** Brief: elevation does not use the line. Suite pins the leftover row and the live rank 4. See Important. |
| GetLine has no present-and-alive filter | **Not a miss.** Targeting / marks are B5-B. Console paints names (B5-C). |
| Event-scope keys off `Snapshot` being a function | **Acceptable.** Brief's isolated exception is "Runtime missing." A Runtime table without `Snapshot` is the pre-existing verb stub in this suite; calling `Snapshot()` on it would error. Matches Gora / Confession. |
| No client `/reload` smoke | **Expected.** Memory-only Core; no Quiet chrome. |

---

## Named risks

| Risk | Verdict |
|---|---|
| Local line / no public queue | **Clean.** File-local map. No `queue` / `next` / `AdvanceQueue` / `NextCandidate` / `GetQueue`. |
| KnightThisBeef removal is not auto-advance | **Clean.** Only the clicked human leaves. The next oldest is not knighted. No Runtime verb fires. |
| GuildPromote | **Clean.** No promote API in source. Stub counters stay at 0. |
| Event-scope when Runtime loaded | **Clean.** QUIET, missing `eventId`, new `eventId`, and rite-state survival are pinned with an inline `Snapshot` stub. Isolation still Enqueues. |
| Isolated green | **Clean.** Re-run here: 306 / 0, exit 0. |

---

## Strengths

- The line is process memory, not a public `queue`. Getters copy. Mutating a GetLine row cannot rewrite who is waiting.
- Enqueue / Insert never knight and never `OpenRite`. KnightThisBeef still only writes Beef Knight. Law 4 is structural, not a comment.
- Expire follows the Gora / Confession `liveEventId` rule (QUIET / non-id wipes; same event survives rite changes) **except** the brief-required isolated hole: missing Runtime does not refuse.
- Existing B3 pins (no Lord write, no Runtime verbs, no promote, no Prophet / Demote / Grant) stayed. The new line tests sit under the same isolation wrap.
- Failed `SetRank` does not dequeue. Successful knighting of someone already off the line does not scramble the remainder.

---

## Issues

### Critical

None.

### Important

1. **A Lord can remain on the knighting line, and `KnightThisBeef` will still write rank 3.** ElevateToLord does not dequeue (brief-correct). `Store:SetRank` will happily walk 4 → 3. The suite pins the leftover rank-4 row and never then knights that human. B5-C paints `GetLine`. If the desk offers **KNIGHT THIS BEEF** on that row, the Pope demotes a Lord by clicking the line. Pre-existing verb + new leftover. Not a spec miss — name it for the console lane.

### Minor

1. **Enqueue and Insert are the same function.** Brief listed two verbs and named the no-op on Insert. Sharing `addToLine` is the safe reading (no duplicate, no reorder). There is no "insert ahead of the current candidate" path. Bible §8 latecomers are append-only here.

2. **`Knighting:_Expire` is an extra public colon method.** Not in the brief API. Same shape as Gora / Confession. Harmless if nobody else calls it; it is still surface.

3. **Expire wipe does not reset `nextSeq`.** `ResetForTests` does. After QUIET the line is empty, so order is fine. Sloppy versus the harness reset, not a scope bug.

4. **Enqueue / Insert / Skip returns are copies in source, not mutated in the suite.** The mutation pin is `GetLine()[1]`. An implementer could return the live entry from Enqueue and still pass.

5. **Suite only knights the head of the line.** Implementation drops `line[human.id]` for any id. A middle-of-line click is unpinned.

6. **`assert_eq(COB.Runtime, nil, "line tests start with Runtime unloaded")` is not under `if standalone then`.** `test_knighting` already runs in `tests/run.lua` *before* `test_runtime`, and earlier suites do not assign Runtime today. Reorder or a prior suite that leaves Runtime loaded turns the full harness red. Isolated run is unaffected. Writer did not run `tests/run.lua` (brief-correct).

7. **`addToLine` calls `liveEventId()` twice** (gate, then store). A Snapshot that flipped between the two would store a different `eventId` than the gate. Impossible in this stub; not worth a second clock.

8. **Client `/reload` was not run.** Expected for a memory-only Core module with no chrome.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.** Gate PASS for this lane's contract. Do not sign.

The exclusive pair does what the brief asked: a local knighting line (not `queue` / `AdvanceQueue` / `NextCandidate`), Enqueue / Insert / Skip / GetLine, successful `KnightThisBeef` removes that human without Runtime verbs or a Lord write, no GuildPromote, event-scope when `Runtime.Snapshot` is loaded, isolated Enqueue when it is not. Isolated `lua tests/test_knighting.lua` was re-run here and finished **306 passed, 0 failed**. The nits that matter for the next lane are the leftover Lord on the line (demote if the desk knights them) and Enqueue/Insert as one append path — not trust-breakers for B5-A.

Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
