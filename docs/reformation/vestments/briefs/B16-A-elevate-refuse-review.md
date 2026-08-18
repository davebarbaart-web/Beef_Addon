Spec PASS

# B16-A — ElevateToLord refuses Butcher / Council (review)

**Quality:** Approved-with-nits

**Lane:** B16-A ElevateToLord refuses Butcher / Council
**Brief:** `docs/reformation/vestments/briefs/B16-A-elevate-refuse.md`
**Writer report:** `docs/reformation/vestments/briefs/B16-A-elevate-refuse-report.md`
**Diff:** `docs/reformation/vestments/briefs/B16-A-elevate-refuse.diff` (B16-A-only exclusive-pair packet; live `Knighting.lua` also carries earlier knighting batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Core/Knighting.lua` (`ElevateToLord` after `knownHuman`), and `tests/test_knighting.lua` (`stillLord` pin, new Cooked elevate pin, B15-D Butcher / Council `KnightThisBeef` refuse, then ElevateToLord refuse + on-line Butcher leftover); then ran `lua tests/test_knighting.lua` (**419 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §8 / §5 (elevation writes Beef Lord; Butcher is display-only; Council is a different rank); Law 4; no GuildPromote. Isolation Common + Ranks + Store + Knighting only. Did not mutate `Knighting.lua` or `test_knighting.lua`. Did not commit. Did not edit Store, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `ElevateToLord` still `SetRank(..., 4)` on Butcher / Council (silent demotion) | **Pass. Verified.** After `knownHuman`: `type(human.rankId) == "number" and human.rankId > LORD_ID` returns `nil, "already elevated"`. Pins: seeded 5 / 6 stay 5 / 6; `elevationAt` stays nil; ceremony log stays 0. Reviewer spies: refuse does not call `Store:SetRank` or `AppendCeremony`. Direct `Store:SetRank(id, 4)` still writes 4 onto a Butcher — that is the hole this verb closes. |
| Re-elevate of Beef Lord (rank 4) blocked | **Pass.** Guard is `>` LORD_ID, not `>=`. Existing `stillLord` pin stays (`rankId == 4`, `elevationAt` unchanged, ceremony grows). Reviewer probe: rank 4 writes 4; one `SetRank` / one `AppendCeremony`. |
| Refuse writes Store, appends ceremony, or dequeues | **Pass. Verified.** Pins: ranks 5 / 6; `elevationAt` nil; ceremony 0; empty line stays 0; Store-written Butcher still on the line after refuse. Reviewer spies: `SetRank` / `AppendCeremony` counts stay 0 on 5 / 6 / on-line Butcher. Probe: on-line Council also leaves `#GetLine() == 1`. |
| Fresh / Cooked / Knight no longer elevate | **Pass.** Fresh pin stays (nil rank → 4). New Cooked pin after `stillLord`. Knight elevate pins stay. Reviewer probe: nil / 2 / 3 each write 4 and append. |
| `KnightThisBeef` rank ≥ 4 refuse broken | **Pass.** Live guard is still `>= LORD_ID`. B15-D Butcher / Council knighting pins sit immediately above the new Elevate pins and still pass. Reviewer probe: Lord / Butcher still `"already elevated"`; rank 3 still knights. |
| `GuildPromote` / `CreateFrame` | **Pass.** Source has no `GuildPromote` / `SetGuildRank` / `CreateFrame`. `promoteCalls` stay 0 on refuse and success paths. Suite source pins still find `already elevated` and no promote APIs. |
| Isolated suite not exit 0 | **Pass. Verified.** 419 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (three-line `>` guard; Cooked pin + Butcher / Council Elevate pins + on-line leftover). Sibling dirt in this workspace is other lanes (Store canonize / ceremony text, Console, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Store / Console / glue; no commit; no GuildPromote; no `CreateFrame` | **Pass.** Named-risk check. |
| Isolation stays Common + Ranks + Store + Knighting | **Pass.** Four `dofile`s unchanged. Load wrap still **11** nil-module pins under `if standalone then`. |
| Refuse when `human.rankId` is a number **> LORD_ID** (5 / 6); return `nil, "already elevated"` | **Pass.** `LORD_ID` is 4. Pins cover 5 / 6. Source names `already elevated`. |
| Do not write Store; do not append ceremony; do not dequeue | **Pass.** Named-risk check. Guard returns before `SetRank` / `AppendCeremony` / `_Expire` / `line[human.id] = nil`. |
| Re-elevate of a Beef Lord (rank 4) stays allowed (`stillLord` pin) | **Pass.** Named-risk check. |
| Fresh / Cooked / Knight still elevate | **Pass.** Named-risk check. |
| `KnightThisBeef` rank ≥ 4 refuse stays | **Pass.** Named-risk check. |
| Seed Butcher (5) and Council (6) like the B15-D Enqueue / KnightThisBeef block | **Pass.** Same `CreateHuman` + `SetRank` humans. Elevate pins sit immediately after that refuse block. Combined ceremony / line / `promoteCalls` pins after both Elevate refuses. |
| Isolation wrap stays; `promoteCalls` stay 0 | **Pass.** Wrap untouched. Refuse and on-line leftover re-pin `promoteCalls == 0`. |
| `lua tests/test_knighting.lua` exit 0 | **Pass.** **419 / 0.** |

Bible §8 / §5 (elevation writes Beef Lord; Butcher is a display-only raiding designation; Council is a different rank) hold on the exclusive pair. The silent demotion B15-D named as leftover is closed on this verb. Law 4 holds: the refuse does not invent a rite or auto-advance the line.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| A Store `SetRank` to 5 after Enqueue can still leave a Butcher on the line | **On contract.** Brief: do not dequeue; leave the line unchanged. Pin and probe both keep that leftover row. Enqueue itself still refuses 3+. Cleanup `Skip` is test-only. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

Console already calls `COB.Knighting:ElevateToLord`. Bootstrap `wrapAfter` still runs only when `result ~= nil`, so a nil refuse does not proclaim or `sendState`. B16-INT glue is not required.

---

## Isolation / refuse / re-elevate

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Knighting. No `dofile` of Runtime / Gora / UI / Net / DB. Standalone wrap is still 11 nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Archive, Recognition, Popes, Roster). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged).

**Refuse — Pass.** `ElevateToLord` reads `Store:GetHuman` (a deepcopy). Numeric `rankId > 4` returns before any write. Butcher / Council stay put. Ceremony log does not grow. `elevationAt` is not touched. On-line leftovers stay on the line. Rank 4 still writes 4 and appends.

**Re-elevate / lower ranks — Pass.** `stillLord` stays. Cooked (2) is newly pinned next to it. Fresh (nil) and Knight (3) pins stay in later / earlier blocks. `KnightThisBeef` is still `>= 4`. `needsKnighting` is untouched (1 / 2 / nil).

---

## Strengths

- The guard is three lines after `knownHuman` and before `SetRank`. Failed path cannot append or touch `line`. Comparator is `>`, so rank 4 is not swept up.
- B15-D's leftover (this verb writing 4 onto 5 / 6) is closed on the same seeded humans, not a second fixture language.
- `stillLord` and `KnightThisBeef` rank ≥ 4 pins were left in place. Fresh / Knight elevate pins stay. Cooked is an extra keep-pin.
- On-line leftover is pinned the way the brief asked: Enqueue a needs-knighting human, `SetRank` to 5, refuse, line unchanged.
- Isolation wrap and `needsKnighting` were not rewritten. Source still has no `GuildPromote`. `promoteCalls` stay 0.
- Writer-reported **419 / 0** matched the re-run. Writer-reported red count (**403 / 16**) matches the new refuse asserts that old `SetRank(..., 4)` would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Store:SetRank` can still write rank 4 onto a Butcher or Council.** Reviewer probe: direct `SetRank(id, 4)` demotes. Brief scoped this lane to `ElevateToLord`. Administrative Store writes stay Store. Console / glue already go through this verb; no INT glue required.

### Nit

1. **Guard is `type(...) == "number"` only.** Brief asked for a number > 4. Store `SetRank` / `knownRank` write integer ids, so a live human row is numeric. Reviewer probe: a fake `GetHuman` that returns `rankId = "5"` still elevates (one `SetRank` / one append). Not a Store path.

2. **On-line Council leftover is unpinned.** Only the Store-written Butcher is pinned. Probe: Enqueue then `SetRank` 6, refuse, `#GetLine() == 1`, no `SetRank` / append.

3. **Writer report overclaims "No new main-chunk locals."** Brief did not require that. The suite added `cookedLord` / `cookedElev` / `butcherElev` / `councilElev` in the main chunk; only the on-line Butcher sits in a nested `do`. Harmless.

4. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. There is no end wrap after Runtime stubs. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Knighting delta.** Packet is the B16-A-only guard + pins. `git diff HEAD` on the two files still includes earlier knighting batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **419 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **419 passed, 0 failed.** Isolation wrap: **11**.

`ElevateToLord` refuses numeric `rankId > 4` with `"already elevated"`. It does not `SetRank`, does not append ceremony, does not dequeue, and does not GuildPromote. Re-elevate of rank 4 still writes 4 and appends. Rank nil / 2 / 3 still elevate. `KnightThisBeef` still refuses rank ≥ 4. Isolation stays Common + Ranks + Store + Knighting. Isolated `lua tests/test_knighting.lua` **419 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
