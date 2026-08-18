Spec PASS

# B9-A — Knighting / elevation ceremony log (review)

**Quality:** Approved-with-nits

**Lane:** B9-A Knighting / elevation ceremony log
**Brief:** `docs/reformation/vestments/briefs/B9-A-knighting-log.md`
**Writer report:** `docs/reformation/vestments/briefs/B9-A-knighting-log-report.md`
**Diff:** `docs/reformation/vestments/briefs/B9-A-knighting-log.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

Task-scoped gate only. Reviewer read the brief, the report, the exclusive-pair diff, `Core/Knighting.lua`, and `tests/test_knighting.lua`; then ran `lua tests/test_knighting.lua` (**361 passed, 0 failed**, exit 0, Lua 5.1). Did not mutate the working tree except this review file. Did not edit `Knighting.lua` or the suite. Did not edit Store, Console, Gora, Toasts. Did not commit.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Type-only `AppendCeremony` after a **successful** write | **Pass.** Both verbs `SetRank` first. `if not row then return nil, setErr` is before the append. Call is 3-arg: `AppendCeremony("Knighting", { humanId }, now)` / `AppendCeremony("Elevation", { humanId }, now)`. No 4th-arg text. |
| No narration / scripture / generated flavor | **Pass.** Source has no `scripture`, `narration`, `Proclaim`, `Narrate`, or flavor string. Suite still pins `Knighting.Narrate` / `Proclaim` nil. Successful rows pin `text` / `scripture` / `narration` nil. |
| No `GuildPromote` | **Pass.** Source has no `GuildPromote` / `SetGuildRank` / `CreateFrame` / chat / addon message / `ChurchOfBeefDB`. Planted promote counters stay at 0 on both verbs. End-of-file source scan pins remain. |
| No `queue` / `AdvanceQueue` | **Pass.** Line and `nextSeq` stay file-local. `Knighting.queue` / `next` / `AdvanceQueue` / `NextCandidate` stay nil. Removal after the Pope clicks is still `line[human.id] = nil`, not a queue advance. Remainder is not knighted. |
| Refused verb does not append; re-click may append again (Law 7) | **Pass.** Unknown / name / key / zero / nil knighting leave `#GetCeremonyLog() == 0`. Unknown elevation leaves the log empty. Re-knight and re-elevate append a second row of the same type with the second `now`. |
| Isolated green; isolation wrap stays | **Pass. Verified.** `lua tests/test_knighting.lua` — 361 passed, 0 failed, exit 0. **11** nil-module pins remain under `if standalone then` at file load. Runtime is nil at load. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store / Console / Gora / Toasts; no commit; no generated scripture | **Pass.** Provided diff is two `diff --git` hunks: `Core/Knighting.lua` and `tests/test_knighting.lua`. Implementation is the two 3-arg appends after successful `SetRank`. Sibling dirt on Store / Gora / Console / Toasts / TOC / bootstrap / `run.lua` is other lanes on this uncommitted tree, not this packet. |
| After successful `KnightThisBeef` / `ElevateToLord`, if `Store.AppendCeremony` exists, type token + human id + time only | **Pass.** Guard is `if Store.AppendCeremony then`. Tokens are exactly `"Knighting"` and `"Elevation"`. Participant list is `{ humanId }` (one store integer). `now` is the verb argument. Store's `wall(now)` fills omitted time — same clock `SetRank` already uses. |
| No 4th-arg text; no `scripture` / `narration` | **Pass.** Call sites are three arguments. First-success pins cover `text` / `scripture` / `narration` nil. Re-click pins `text` nil again. |
| Flip the old `#GetCeremonyLog() == 0` pins after those verbs | **Pass.** Those pins now expect 1. The old “does not append ceremony narration” wording is gone. Empty-log pins remain only on refuse paths. |
| A refused verb does not append | **Pass.** Unknown knighting and the refused-knighting batch pin 0. Unknown elevation pins 0. Name-string elevation is refused before `SetRank` (implementation); that refuse is not re-pinned on the log (see Minor). |
| Re-knight / re-elevate may append again | **Pass.** Count goes 1 → 2. Type stays. Second `at` is the second `now`. |
| Keep: no GuildPromote / CreateFrame; ElevateToLord still dequeues; no auto-knight; isolation wrap stays | **Pass.** Dequeue is still `_Expire` then `line[human.id] = nil` after a successful write. Enqueue still does not knight. Existing line / event-scope / no-Runtime-verb / no-Prophet pins still pass on this re-run. |
| Tests: successful KnightThisBeef → one `Knighting` row; ElevateToLord → `Elevation`; unknown human → log unchanged; `lua tests/test_knighting.lua` exit 0 | **Pass. Verified.** 361 / 0. Writer-reported count matches. |

Bible §18.1 (“what just happened”) is a type token + id + time, not Chronicle voice. Law 4 holds: the software does not narrate. Law 7 holds: a second click appends; nothing is deleted. The memory-only line is not a `queue`. Guild-rank write stays later Console (A04 pending).

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `AppendCeremony` return is ignored | **Not a miss.** Brief: append after a successful write. Rank + dequeue do not depend on the log row. Same pattern as Recognition. Current Store cannot fail this 3-arg call with a valid human id. |
| Missing `AppendCeremony` is unpinned | **Acceptable.** Brief licenses the existence guard. It does not require a stub-nil pin (B9-B does). Isolated suite always loads Store. See Minor. |
| Clock-omitted `now` is unpinned on ceremony `at` | **Acceptable.** `ElevateToLord` without `now` still pins `elevationAt` via Store's clock. Append passes the same nil `now`; Store `wall` fills `at`. Correct, unpinned. See Minor. |
| No client smoke / full harness | **Expected.** Memory-only Core. B9-C paints the desk. |

---

## Strengths

- The empty-log pins were actually flipped, not papered over. “No narration” is now `text` / `scripture` / `narration` nil on a real row, which is what those pins always meant.
- Append sits after `SetRank` success and before dequeue. A refused unknown / non-id never reaches the log. A failed write cannot append.
- Type tokens match the brief exactly (`Knighting`, `Elevation`) — not lowercase rite slang, not `ordained`, not a sentence.
- Re-click is append-only. Second knighting does not elevate. Second elevation does not overwrite `elevationAt`. Law 7 and §10.4 stay structural.
- Exclusive packet is six lines of Core plus the flipped / added pins. Store was not forked. `GuildPromote`, `queue`, and `AdvanceQueue` did not come back.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor (leftover nits)

1. **Missing-`AppendCeremony` guard is untested.** Source has the brief's `if Store.AppendCeremony`. B9-B stubs the method off and pins the bout still writes. This suite never nils it. Isolated load always has Store.

2. **Clock-omitted ceremony `at` is unpinned.** The `ElevateToLord` / `Clock.Wall → 55555` block pins `elevationAt` only. Implementation passes `now` through; Store `wall` would stamp `55555`. A later hardcoded `at` would still go green here.

3. **Name-string `ElevateToLord` does not re-pin the log.** Unknown elevation pins 0, then a name-string refuse, then a successful elevate of the seeded human. If the name-string had appended, the next success would be row 2 and nobody would notice. Knighting covers the equivalent with a batch pin after name / key / zero / nil. Implementation refuses before `SetRank`.

4. **Re-click pins `text` nil, not `scripture` / `narration`.** First success already pins all three. A later 4th-arg-only on the second click would still fail the `text` pin.

5. **Later blocks do not re-pin the log.** The two-knighting “do not write Lord” path, the Gora-win path, and the line-removal / event-scope knightings all append as a side effect and never say so. Dedicated blocks already own the contract.

6. **Enqueue / Skip / Insert do not pin “log unchanged.”** They do not call `AppendCeremony`. Fine as coverage, not a hole in the verbs.

7. **`KnightThisBeef` on a sitting Lord still writes rank 3 and now also appends `Knighting`.** Pre-existing `SetRank` one-way-gate hole (B6-C Important). This lane correctly logs a successful write. GetLine no longer offers that row. Raw-id click is still a demote-plus-log. Store was exclusive-forbidden.

8. **No `/reload` and no full `lua tests/run.lua`.** Isolated suite was re-run here. Console paint is B9-C.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.** Gate PASS for this lane's contract. Do not sign.

The exclusive pair does what the brief asked: after a successful `SetRank`, type-only `AppendCeremony("Knighting"|"Elevation", { humanId }, now)` when the method exists; no 4th-arg text; refused verbs leave the log alone; re-click appends again; no GuildPromote; no `queue` / `AdvanceQueue`; ElevateToLord still dequeues; isolation wrap still **11** gated pins. Isolated `lua tests/test_knighting.lua` was re-run here and finished **361 passed, 0 failed**. Leftovers are unpinned missing-guard / omitted-`now` `at` / name-string elevation log, not trust-breakers.

Must-fix list: **none.**

Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
