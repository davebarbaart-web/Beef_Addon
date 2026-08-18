Spec PASS

# B24-A — Recommendation clears when the event ends or a new one starts (review)

**Quality:** Approved-with-nits

**Lane:** B24-A Recommendation clears when the event ends or a new one starts
**Brief:** `docs/reformation/vestments/briefs/B24-A-rec-lifetime.md`
**Writer report:** `docs/reformation/vestments/briefs/B24-A-rec-lifetime-report.md`
**Diff:** `docs/reformation/vestments/briefs/B24-A-rec-lifetime.diff` (B24-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`StartEvent` / `EndEvent` / `Continue` / `Recommend` / `paintRecommendation` / `ResetForTests` / `after()`), and `tests/test_console.lua` (isolation wrap, nested `runB24A()` inside `runB8E()` after `runB23A()`); then ran `lua tests/test_console.lua` (**1766 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §18.1 / §20 event lifetime; B22-A leftover (`lastRecommendation` only cleared in `ResetForTests`); `lastRecommendation = nil` on successful Start / End (`result ~= nil`) **before** `after()`; Continue keeps; failed Start keeps; nest `runB8E()`. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `lastRecommendation` still only cleared in `ResetForTests` (desk keeps `"  names  "` after End / later Start) | **Pass. Verified.** Successful `StartEvent` / `EndEvent` set `lastRecommendation = nil` when `result ~= nil`. Pins: `EndEvent` then Refresh is `""` (no names token); later `StartEvent` still `""`; `Runtime:EndEvent` leftover then `Console:StartEvent` paints `""`. Three `lastRecommendation = nil` writes: `ResetForTests`, Start, End. |
| Clear runs **after** `after()`, so the first Refresh still paints the leftover | **Pass. Verified.** Live order is `if result ~= nil then lastRecommendation = nil end` then `return after(...)`. Source pins match that exact block on Start / End. Leftover `StartEvent` pin observes `after()`'s own Refresh. Reviewer Refresh spy: first `after()` Refresh on successful End and leftover Start is already `""`. |
| `Continue` clears the table | **Pass.** Live `Continue` is still `return after(self, result, err)` with no nil write. Pin: text stays `namedText` after Continue + Refresh. Reviewer spy: Continue's `after()` Refresh still paints the names line. |
| Failed Start (already live) clears | **Pass.** `result == nil` skips the nil write. Pin: `StartEvent` while live returns nil; Refresh keeps `namedText`. Reviewer spy: failed Start does not Refresh via `after()`. |
| Failed End clears | **Pass.** Same `result ~= nil` guard. Pin: `EndEvent` from RITE returns nil; Refresh keeps `namedText`. Reviewer spy: failed End does not Refresh via `after()`. Probe: failed End from QUIET after a Runtime leftover also keeps the line. |
| Recommend drops `namedOpponent`; `"  names  "` paint changes; “DEMANDED” | **Pass.** `Recommend` still stores `{ fighterA, fighterB, namedOpponent = result.namedOpponent == true }`. `paintRecommendation` still appends `'  names  '`. Pins: named Recommend paints both names + token; new Recommend after later Start paints again. Source has no `DEMANDED`. |
| `SaveNote` defined; SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. |
| New main-chunk locals / not nested in `runB8E()` | **Pass.** `runB24A()` is a nested `local function` inside `runB8E()` after `runB23A()`. Packet adds no main-chunk `local`. Header comment only at file top. |
| Isolated suite not exit 0 | **Pass. Verified.** 1766 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (header lifetime note + two clear-before-`after` blocks; header comment + nested `runB24A()`). Sibling dirt in this workspace is other lanes (earlier Console batches vs HEAD). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Nine `dofile`s unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| On successful `StartEvent` / `EndEvent` (`result ~= nil`), `lastRecommendation = nil` **before** `after()` | **Pass.** Named-risk check. |
| Failed Start (already live) / failed End keep the table | **Pass.** Named-risk check. |
| `Continue` does not clear | **Pass.** Named-risk check. |
| `Recommend` still stores the flag; `"  names  "` paint unchanged; no “DEMANDED” | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| Named Recommend paints `"  names  "`; End then Refresh is `""`; later Start still empty; new Recommend paints again | **Pass.** Nested pins in that order. |
| Nest new pins in `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **1766 / 0.** |

Bible §18.1 / §20 hold on the exclusive pair: the suggestion is desk memory for the current gathering, not a Quiet leftover after End or a carry into the next Start. Law 4 holds: the desk does not invent “DEMANDED” or narrate. Law 6 holds: Quiet after End does not keep Event suggestion chrome on this line.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Selected-pair inherit of Core `namedOpponent` stays parked | **On contract.** Batch 24 overview parks it. Not this exclusive pair. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| `Runtime:EndEvent` bypass is harness-only | **On contract.** Brief scoped Console Start / End. The bypass exists so StartEvent's own clear is visible after EndEvent already emptied the line. Reviewer probe: that leftover stays until `Console:StartEvent`. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / clear / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Gora's callers beyond that list, UI shell, Net, DB, or glue. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B24-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Clear-before-`after` — Pass.** `after()` Refresh / cue / HUD only when `result ~= nil`. Start and End nil the table first, so that Refresh paints `""`. `paintRecommendation` still reads `lastRecommendation` only. Reviewer spy: first End Refresh and first leftover-Start Refresh are already empty. Hide / Show after a successful Start does not resurrect the line.

**Keep — Pass.** Failed Start (already live), Continue, and failed End from RITE keep `namedText`. OpenRite / CloseRite on the way to those pins also re-paint the same line (no nil write). Reviewer probes: failed End from QUIET after a Runtime leftover, and Pope-refuse Start / End, also keep. `Recommend` still writes the flag. `ResetForTests` still nils.

---

## Strengths

- The clear is three lines on each verb, gated on `result ~= nil`, immediately before `after()`. Failed paths cannot empty the line. Continue is untouched.
- B22-A's leftover (desk still painting `"  names  "` after End / next Start) is closed on the same named-petition fixture, not a second paint language.
- Failed Start, Continue, and failed End are pinned **before** the success empty-paint, so a blanket nil on every verb would fail those keeps.
- `Runtime:EndEvent` leftover then `Console:StartEvent` proves StartEvent's own clear, not only EndEvent's.
- `"  names  "` append, `namedOpponent` store, `SaveNote` nil, and no DEMANDED stay source-pinned. Isolation wrap was not rewritten. `runB24A()` is nested inside `runB8E()` after `runB23A()`.
- Writer-reported **1766 / 0** matched the re-run. Writer-reported red count (**1760 / 6**) matches the new empty-paint / leftover-Start / source-before-`after` asserts that ResetForTests-only clear would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Runtime:EndEvent` still leaves `lastRecommendation`.** Reviewer probe: bypass then Refresh still paints the names line; next `Console:StartEvent` clears it. Brief scoped this lane to Console Start / End. The Pope desk already goes through `Console:EndEvent`. Not glue.

### Nit

1. **EndEvent empty-paint pin calls `Refresh` again after `after()` already Refresh'd.** A clear-*after*-`after` on End would still pass that extra Refresh. The leftover StartEvent pin and the source pin close the hole; reviewer spy confirms End's first `after()` Refresh is already `""`.

2. **Failed End from QUIET and Pope-refuse Start / End are unpinned.** Brief asked already-live Start and failed End. Those other nil returns also skip the clear. Probe: leftover line stays.

3. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Nested B24-A re-pins four of them plus Popes after restore. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B24-A-only clear + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1766 / 0** was re-run here. Live desk paint after End Event / next Start Event is unproven on Anniversary.

6. **Parked Batch 24 Console leftover** (selected-pair inherit of Core `namedOpponent`) is other work. Not this exclusive pair.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1766 passed, 0 failed.** Isolation wrap: **17**.

Successful `StartEvent` / `EndEvent` set `lastRecommendation = nil` before `after()` so Refresh paints empty. Failed Start (already live) / failed End / Continue keep the table. `Recommend` still stores `namedOpponent`. `"  names  "` paint is unchanged. `SaveNote` stays nil. `runB24A()` is nested inside `runB8E()`. Isolated `lua tests/test_console.lua` **1766 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
