Spec PASS

# B15-D — KnightThisBeef refuses Lord+ (review)

**Quality:** Approved-with-nits

**Lane:** B15-D KnightThisBeef refuses Lord+
**Brief:** `docs/reformation/vestments/briefs/B15-D-knight-lord.md`
**Writer report:** `docs/reformation/vestments/briefs/B15-D-knight-lord-report.md`
**Diff:** `docs/reformation/vestments/briefs/B15-D-knight-lord.diff` (B15-D-only exclusive-pair packet; live `Knighting.lua` also carries earlier knighting batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Core/Knighting.lua` (`KnightThisBeef` after `knownHuman`), and `tests/test_knighting.lua` (rank-3 re-knight pins, then ElevateToLord refuse, on-line Lord leftover, seeded Butcher / Council); then ran `lua tests/test_knighting.lua` (**394 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §8 / §5 (Knighting writes Beef Knight; elevation is `ElevateToLord`); Law 4; A04 no GuildPromote. Isolation Common + Ranks + Store + Knighting only. Did not mutate `Knighting.lua` or `test_knighting.lua`. Did not commit. Did not edit Store, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `KnightThisBeef` still `SetRank(..., 3)` on Lord / Butcher / Council | **Pass. Verified.** After `knownHuman`: `type(human.rankId) == "number" and human.rankId >= LORD_ID` returns `nil, "already elevated"`. Pins: ElevateToLord then refuse; rank stays 4; seeded 5 / 6 stay 5 / 6. Reviewer spies: refuse does not call `Store:SetRank`. Direct `Store:SetRank(id, 3)` still demotes a Lord — that is the hole this verb closes. |
| Re-knight of Beef Knight (rank 3) blocked | **Pass.** Existing re-knight pins stay above the new ElevateToLord block and still pass (`again.rankId == 3`, ceremony grows). Later blocks still re-knight a Knight. Reviewer probe: rank 3 writes 3 and appends; `SetRank` / `AppendCeremony` increment. |
| Refuse writes Store, appends ceremony, or dequeues | **Pass. Verified.** Pins: Lord rank / `elevationAt` / ceremony count unchanged; empty line stays 0; Store-written Lord still on the line after refuse. Reviewer spies: `SetRank` and `AppendCeremony` counts unchanged on Lord / 5 / 6 / on-line Lord. Probe: on-line Butcher / Council also leave `#GetLine() == 2`. |
| Rank 1 / 2 / nil no longer knight | **Pass.** Existing Fresh / Cooked / unenrolled pins stay. Reviewer probe: nil / 1 / 2 still write 3. |
| Enqueue / Insert `needsKnighting` widened | **Pass.** Helper is still `rankId == nil or rankId == 1 or rankId == 2`. Exclusive-pair hunk does not touch it. Rank 3+ Enqueue / Insert still `"already knighted"`. |
| `GuildPromote` / `CreateFrame` | **Pass.** Source has no `GuildPromote` / `SetGuildRank` / `CreateFrame`. `promoteCalls` stay 0 on refuse and success paths. |
| Isolated suite not exit 0 | **Pass. Verified.** 394 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (three-line guard; suite pins + source name). Sibling dirt in this workspace is other lanes (Store canonize / upset text, Console, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Store / Console / glue; no commit; no GuildPromote; no `CreateFrame` | **Pass.** Named-risk check. |
| Isolation stays Common + Ranks + Store + Knighting | **Pass.** Four `dofile`s unchanged. Load wrap still **11** nil-module pins under `if standalone then`. |
| Refuse when `human.rankId` is a number **≥ 4**; return `nil, "already elevated"` | **Pass.** `LORD_ID` is 4. Pins cover 4 / 5 / 6. Source names `already elevated`. |
| Do not write Store; do not append ceremony; do not dequeue | **Pass.** Named-risk check. Guard returns before `SetRank` / `AppendCeremony` / `_Expire` / `line[human.id] = nil`. |
| Re-knight of a Beef Knight (rank 3) stays allowed | **Pass.** Named-risk check. |
| Rank 1 / 2 / nil still knight | **Pass.** Named-risk check. |
| After existing re-knight pins: ElevateToLord then refuse; rank stays 4; ceremony does not grow; `elevationAt` unchanged | **Pass.** Sits immediately after the rank-3 re-knight pins. Nested `do` then pins a Store-written Lord still on the line. |
| Seed Butcher (5) and Council (6) the same way Enqueue tests do — refuse both | **Pass.** Same `CreateHuman` + `SetRank` block. Combined ceremony / line / `promoteCalls` pins after both refuses. |
| Enqueue still uses `needsKnighting` (1 / 2 / nil only) | **Pass.** Named-risk check. |
| Isolation wrap stays; no new main-chunk locals | **Pass.** Wrap untouched. On-line Lord pins sit in a nested `do`. |
| `lua tests/test_knighting.lua` exit 0 | **Pass.** **394 / 0.** |

Bible §8 (KNIGHT THIS BEEF writes Beef Knight) and §5 (Lord / Butcher / Council are not that write) hold on the exclusive pair. Elevation remains a different verb. Law 4 holds: the refuse does not invent a rite or auto-advance the line.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `ElevateToLord` can still write Lord on a Butcher or Council | **On contract.** Exclusive pair gates `KnightThisBeef` only. `ElevateToLord` is unchanged in the packet. Reviewer probe: Butcher / Council still become 4 via that verb. Leftover, not a miss. |
| A Store `SetRank` to 4 after Enqueue can still leave a Lord on the line | **On contract.** Brief: do not dequeue; leave the line unchanged. Pin and probe both keep that leftover row. Enqueue itself still refuses 3+. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign either. |

---

## Isolation / refuse / enqueue

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Knighting. No `dofile` of Runtime / Gora / UI / Net / DB. Standalone wrap is still 11 nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Archive, Recognition, Popes, Roster). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged).

**Refuse — Pass.** `KnightThisBeef` reads `Store:GetHuman` (a deepcopy). Numeric `rankId >= 4` returns before any write. Lord / Butcher / Council stay put. Ceremony log does not grow. `elevationAt` is not touched. On-line leftovers stay on the line. Rank 3 still writes 3 and appends.

**Enqueue — Pass.** `needsKnighting` is still 1 / 2 / nil. Rank 3+ still `"already knighted"`. That string is not this lane's refuse.

---

## Strengths

- The guard is three lines after `knownHuman` and before `SetRank`. Failed path cannot append or touch `line`.
- Rank-3 re-knight pins were left in place, then elevation / refuse was added under them. Fresh / Cooked / unenrolled knight pins stay.
- On-line leftover is pinned the way the brief asked: Enqueue a needs-knighting human, `SetRank` to 4, refuse, line unchanged.
- Butcher / Council are seeded in the existing Enqueue already-knighted block, not a second fixture language.
- Isolation wrap and `needsKnighting` were not rewritten. Nested `do` avoids a new main-chunk local. Source names `already elevated`. `promoteCalls` stay 0.
- Writer-reported **394 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`ElevateToLord` still writes rank 4 on a Butcher or Council.** Reviewer probe: both become 4. Brief scoped this lane to `KnightThisBeef`. Elevation of display-only / Council ranks is leftover.

### Minor

1. **Guard is `type(...) == "number"` only.** Brief asked for a number ≥ 4. Store `SetRank` / `knownRank` write integer ids, so a live human row is numeric. Reviewer probe: a fake `GetHuman` that returns `rankId = "4"` still knights (one `SetRank` / one append). Not a Store path.

2. **On-line Butcher / Council leftovers are unpinned.** Only the Store-written Lord is pinned. Probe: Enqueue then `SetRank` 5 / 6, refuse both, `#GetLine() == 2`, ceremony 0.

3. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. There is no end wrap after Runtime stubs. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD Knighting delta.** Packet is the B15-D-only guard + pins. `git diff HEAD` on the two files still includes earlier knighting batches. Report already says this.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **394 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **394 passed, 0 failed.** Isolation wrap: **11**.

`KnightThisBeef` refuses numeric `rankId >= 4` with `"already elevated"`. It does not `SetRank`, does not append ceremony, does not dequeue, and does not GuildPromote. Re-knight of rank 3 still writes 3 and appends. Rank 1 / 2 / nil still knight. Enqueue still uses `needsKnighting`. Isolation stays Common + Ranks + Store + Knighting. Isolated `lua tests/test_knighting.lua` **394 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
