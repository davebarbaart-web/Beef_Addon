Spec PASS

# B6-C — ElevateToLord leaves the knighting line (review)

**Quality:** Approved-with-nits

**Lane:** B6-C ElevateToLord leaves the knighting line (Core)
**Brief:** `docs/reformation/vestments/briefs/B6-C-lord-line.md`
**Writer report:** `docs/reformation/vestments/briefs/B6-C-lord-line-report.md`
**Diff:** `docs/reformation/vestments/briefs/B6-C-lord-line.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

Task-scoped gate only. Reviewer read the brief, the report, `Core/Knighting.lua`, and `tests/test_knighting.lua`; then ran `lua tests/test_knighting.lua` (**336 passed, 0 failed, exit 0**, Lua 5.1.5). Did not mutate the working tree except this review file. Did not edit `Knighting.lua` or the suite. Did not commit.

This review does not sign the lane.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Successful `ElevateToLord` removes that `humanId` from the local line (same as `KnightThisBeef`) | **Pass.** After `SetRank(..., 4)` succeeds, `_Expire` then `line[human.id] = nil`. Enqueue → ElevateToLord → `GetLine` does not contain that id (single-row flip of the B5-A leftover pin). Middle-of-line elevation drops only that id; oldest and newest stay. |
| `queue` / `AdvanceQueue` / `NextCandidate` / `next` stay nil | **Pass.** Line and `nextSeq` remain file-local. `Knighting.queue` / `next` / `AdvanceQueue` / `NextCandidate` are nil after elevation removal. Source has no `AdvanceQueue` / `NextCandidate` function. Removal is not auto-advance. |
| No `GuildPromote` | **Pass.** Source has neither `GuildPromote` nor `SetGuildRank` (nor `CreateFrame`, chat, addon message, or `ChurchOfBeefDB`). Planted promote counters stay at 0 on ElevateToLord, including the three-person removal block. |
| No Runtime calls | **Pass.** Read as no Runtime *verbs*, same as B5-A / same-as-KnightThisBeef. ElevateToLord does not call `OpenRite` / `EndEvent` / `CloseRite` / `Continue` / `KnightThisBeef`. Planted verb stub stays at `riteCalls == 0`. Snapshot expire-read is the existing `_Expire` path, not a ceremony drive. Remainder is not knighted. |
| Isolated green; isolation wrap stays | **Pass. Verified.** `lua tests/test_knighting.lua` — 336 passed, 0 failed, exit 0. **11** nil-module pins remain under `if standalone then` at file load. Runtime is nil at load. |
| Exclusive files; no Console / Store / commit | **Pass.** Provided diff is two `diff --git` hunks: `Core/Knighting.lua` and `tests/test_knighting.lua`. Writer did not list Console, Store, TOC, or `run.lua`. |

Bible §8 / §10.4 and Law 4 hold on this pair: elevation is its own Pope verb; software never auto-knights the remainder; taking the elevated human off the line is the Pope already having clicked, not `AdvanceQueue`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `KnightThisBeef` can still write rank 3 on an already-Lord human if the Pope clicks by id | **Not a miss.** Brief forbade Store edits. This lane takes them off `GetLine` so the desk no longer offers that row. Residual is the pre-existing `SetRank` one-way-gate hole. See Important. |
| No shared `leaveLine` helper | **Acceptable.** Brief said same as `KnightThisBeef`, not a refactor of it. The two-line success tail is duplicated on purpose. |
| ElevateToLord during a live `Runtime.Snapshot` event is not separately pinned | **Acceptable as a miss of coverage, not of the verb.** KnightThisBeef event-line removal stays. ElevateToLord uses the same expire-then-nil pair. See Minor. |
| No client `/reload` | **Expected.** Memory-only Core; no Quiet chrome. |

---

## Named risks

| Risk | Verdict |
|---|---|
| ElevateToLord removes that human | **Clean.** Flipped leftover-Lord pin: Enqueue → ElevateToLord → `#GetLine() == 0` and `lineHas(id) == false`. Three-person: middle id gone; others stay, unknighted. |
| `queue` / `AdvanceQueue` / `NextCandidate` / `next` nil | **Clean.** Public names stay nil after elevation removal. File-local map only. |
| GuildPromote | **Clean.** No promote API in source. Stub counters stay at 0. |
| Runtime verbs / auto-knight | **Clean.** `riteCalls` stay 0. Remainder rank stays nil. ElevateToLord never calls `KnightThisBeef` or `OpenRite`. |
| Isolated green | **Clean.** Re-run here: 336 / 0, exit 0. Isolation wrap still gated at file load. |

---

## Strengths

- The B5-A leftover-Lord pin is actually flipped, not papered over. A later Enqueue of the elevated human still refuses `already knighted` and does not restore the row.
- Success order matches `KnightThisBeef`: `SetRank` first; failed row returns before expire/nil. Refused unknown id does not dequeue. Off-line / second elevation does not scramble the remainder.
- Law 4 stays structural. Elevation writes rank 4 only. The next humans are not knighted. No public `queue`. No GuildPromote.
- Existing B3 / B5-A pins (no Lord write from `KnightThisBeef`, no Runtime verbs, no promote, no Prophet / Demote / Grant, event-scope when `Snapshot` is loaded, isolated Enqueue when it is not) still pass on this re-run.
- Exclusive packet matches the diff. Writer-reported 336 / 0 matches.

---

## Issues

### Critical

None.

### Important

1. **`KnightThisBeef` will still write rank 3 on a Lord if the Pope clicks by raw id.** `Store:SetRank` has no one-way gate. This lane correctly drops the human from `GetLine`, so the desk no longer offers **KNIGHT THIS BEEF** on that row. Anyone who knights by id from a roster pick (not the line) still demotes a Lord. Pre-existing Store hole; Store was exclusive-forbidden. Not a spec miss — name it so a later lane does not treat GetLine-clean as rank-monotonic.

### Minor

1. **ElevateToLord is not pinned on a live `Runtime.Snapshot` event.** The new three-person block plants OpenRite / EndEvent / CloseRite / Continue with **no** `Snapshot`, so `runtimeLoaded()` is false and `_Expire` is a no-op there. Event-scope still only knights. Same function pair as `KnightThisBeef`; unproven for this verb.

2. **Failed `SetRank` does not dequeue is claimed, not asserted.** After `knownHuman` succeeds, `SetRank(..., 4)` only fails on an unknown rank id — dead with the real Store. The early return is in source. A swapped failing Store is unpinned.

3. **Insert-after-elevation is unpinned.** Enqueue-after-elevation is. Both share `addToLine`; Insert would also refuse `already knighted`.

4. **`assert_eq(COB.Runtime, nil, "line tests start with Runtime unloaded")` is still not under `if standalone then`.** Pre-existing B5-A nit. Isolated run is unaffected. Writer did not run `tests/run.lua` (brief-correct).

5. **Client `/reload` was not run.** Expected for a memory-only Core module with no chrome.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.** Gate PASS for this lane's contract. Do not sign.

The exclusive pair does what the brief asked: successful `ElevateToLord` removes that human from the local line (same tail as `KnightThisBeef`), `queue` / `AdvanceQueue` / `NextCandidate` / `next` stay nil, no GuildPromote, no Runtime verbs, no auto-knight of the remainder, isolation wrap stays. Isolated `lua tests/test_knighting.lua` was re-run here and finished **336 passed, 0 failed**. The nit that remains product-visible is raw-id `KnightThisBeef` still being able to walk 4 → 3 — not a GetLine leftover, and not this lane's Store to fix.

Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
