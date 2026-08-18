Spec PASS

# B26-A — Selected pair dies with the event (review)

**Quality:** Approved-with-nits

**Lane:** B26-A Selected pair dies with the event
**Brief:** `docs/reformation/vestments/briefs/B26-A-sel-lifetime.md`
**Writer report:** `docs/reformation/vestments/briefs/B26-A-sel-lifetime-report.md`
**Diff:** `docs/reformation/vestments/briefs/B26-A-sel-lifetime.diff` (B26-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`StartEvent` / `EndEvent` / `Continue` / `Recommend` / `paintRecommendation` / `after()` / `SelectFighters` / `ResetForTests`), and `tests/test_console.lua` (isolation wrap, nested `runB26A()` inside `runB8E()` after `runB25A()`, plus the B24-A source-string update); then ran `lua tests/test_console.lua` (**1922 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 / §18.1 Recommend; B25 leftover (successful Start / End nil `lastRecommendation` but leave `selectedFighterA` / `selectedFighterB`, so a later petition-path Recommend inherits `hadSelected` and suppresses `"  names  "`); successful Start / End (`result ~= nil`) also nil the selected pair **before** `after()`; failed Start / failed End / Continue keep the pair; `lastRecommendation` clear stays; B25-A gate stays; nest `runB8E()`; `SaveNote` nil. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Successful Start / End still leave `selectedFighterA` / `selectedFighterB` (B25 leftover; later petition-path Recommend inherits `hadSelected`) | **Pass. Verified.** Live `StartEvent` / `EndEvent` set `lastRecommendation = nil` then `selectedFighterA` / `selectedFighterB` = nil when `result ~= nil`, then `return after(...)`. Pin: End then later Start + named petition + Recommend **without** `SelectFighters` paints `"  names  "` and both names. Reviewer probe matches. |
| Clear runs **after** `after()`, so the first Refresh still paints a leftover pair / `hadSelected` | **Pass. Verified.** Live order is `lastRecommendation = nil` then the two selected nils then `return after(...)`. Source pins match those exact blocks. `after()` Refresh / cue / HUD only when `result ~= nil`. Reviewer Refresh spy: first `after()` Refresh on successful End, and on `Console:StartEvent` after a `Runtime:EndEvent` leftover, already has both ids nil; ProposedBout and Recommendation are already `""`. |
| Failed Start (already live) clears the pair | **Pass. Verified.** `result == nil` skips the nil writes. Pin: `StartEvent` while live returns nil; both ids stay; Recommend still has no `"  names  "` (`hadSelected` still true). Reviewer spy: failed Start does not Refresh via `after()`. |
| Failed End / Continue clear the pair | **Pass.** Same `result ~= nil` guard on End. Live `Continue` is still `return after(self, result, err)` with no nil write. Pins: End from RITE returns nil and keeps both ids; Continue returns to ASSEMBLY and keeps both ids; Recommend after Continue still has no `"  names  "`. Reviewer spy: failed End / Continue do not wipe the pair. |
| `lastRecommendation` clear dropped; B25-A `hadSelected` gate dropped | **Pass.** `lastRecommendation = nil` stays first in both success blocks. `Recommend` still computes `hadSelected` from two different selected ids **before** `recommendPair` / `SelectFighters` and stores `namedOpponent = (not hadSelected) and result.namedOpponent == true`. Selected-pair pin: both names, **no** `"  names  "`; Core return is still `namedOpponent == true`. Source pins: `hadAt < pairAt` and `hadAt < pickAt`. |
| Petition-path Recommend after End then Start still suppresses `"  names  "` | **Pass. Verified.** Nested B26-A: End + later Start leaves both ids nil; named petition + Recommend without `SelectFighters` paints `"  names  "` and both names. Reviewer probe matches, including after a Runtime leftover then `Console:StartEvent`. |
| Paint invents “DEMANDED”; `paintRecommendation` / petition line change; `SaveNote` defined | **Pass.** `paintRecommendation` still appends `'  names  '` only when `lastRecommendation.namedOpponent == true`. `petitionLine` is still `left .. "  names  " .. right`. Source has no `DEMANDED`, no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. `Console.SaveNote` nil before and after the nested block. |
| New main-chunk locals / not nested in `runB8E()` | **Pass.** `runB26A()` is a nested `local function` inside `runB8E()` after `runB25A()`. Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 | **Pass. Verified.** 1922 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach (Gora / glue this lane) | **Pass.** Lane packet is two `diff --git` hunks (header lifetime note + two selected-pair nils in the existing `result ~= nil` blocks; header comment + nested `runB26A()` + two B24-A source-string updates). Workspace Gora / glue dirt vs HEAD is earlier batches, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Nine `dofile`s unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| On successful `StartEvent` / `EndEvent` (`result ~= nil`), also nil `selectedFighterA` / `selectedFighterB` **before** `after()` | **Pass.** Named-risk check. |
| Failed Start (already live) / failed End / Continue keep the pair | **Pass.** Named-risk check. |
| `lastRecommendation` clear stays | **Pass.** Named-risk check. |
| B25-A `hadSelected` gate stays; selected-pair + named petition paints both names and **no** `"  names  "` | **Pass.** Named-risk check. |
| End then Start + named petition + Recommend without `SelectFighters` paints `"  names  "` | **Pass.** Nested pins + reviewer probe. |
| No “DEMANDED”; `"  names  "` paint unchanged | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| Nest new pins in `runB8E()` after `runB25A()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **1922 / 0.** |

Bible §10.2 / §18.1 / §20 hold on the exclusive pair: the seated pair is desk memory for the current gathering, not a Quiet leftover after End or a carry into the next Start. Law 4 holds: the desk does not invent “DEMANDED” or narrate. The B25-A gate still marks a discovered named challenge, not a pair the Pope already seated. After End then Start, a petition-path Recommend is discovered again and paints `"  names  "`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| B24-A later-Start keep still calls `SelectFighters(nil, nil)` in-harness | **Leftover, not must-fix.** Now redundant with the desk lifetime. Did not weaken B24-A. See Nit. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / clear / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Gora's callers beyond that list, UI shell, Net, DB, or glue. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B26-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Clear-before-`after` — Pass.** `after()` Refresh only when `result ~= nil`. Start and End nil `lastRecommendation` first, then both selected ids, so that Refresh paints an empty Recommendation and an empty ProposedBout. `paintRecommendation` still reads `lastRecommendation` only. `GetProposedBout` still reads the selected ids. Reviewer spy: first End Refresh and first leftover-Start Refresh already have both ids nil. Hide / Show after a successful End does not resurrect the pair.

**Keep — Pass.** Failed Start (already live), Continue, and failed End from RITE keep both ids and keep `hadSelected` (Recommend still has no `"  names  "`). OpenRite / CloseRite on the way to those pins also leave the pair (no nil write). Reviewer probes: failed End from QUIET after a Runtime leftover, and Pope-refuse Start / End, also keep. `Recommend` still writes the B25-A gated flag. `ResetForTests` still nils.

---

## Strengths

- The wipe is two assignments on each existing `result ~= nil` block, immediately after `lastRecommendation = nil` and before `after()`. Failed paths cannot empty the pair. Continue is untouched. `Recommend` / `paintRecommendation` are untouched.
- B25-A's leftover (desk still seating last gathering's pair, so a later petition-path Recommend inherits `hadSelected` and suppresses `"  names  "`) is closed on the same named-petition fixture, not a second paint language.
- Failed Start, failed End, and Continue are pinned **before** the success wipe, so a blanket nil on every verb would fail those keeps. The End-then-Start petition-path pin would fail if only `lastRecommendation` cleared.
- B25-A selected-pair keep still runs first: both names, no `"  names  "`, Core still returns `namedOpponent == true`.
- `"  names  "` append, `hadSelected` gate, gated store, `SaveNote` nil, and no DEMANDED stay source-pinned. Isolation wrap was not rewritten. `runB26A()` is nested inside `runB8E()` after `runB25A()`.
- Writer-reported **1922 / 0** matched the re-run. Writer-reported first red (**1915 / 7**) matches leftover selected ids after End / later Start, suppressed `"  names  "`, and missing selected-pair source pins. The later **1920 / 2** matches B24-A's exact clear-before-`after` strings after the selected nils landed.

**B24-A source-string update — did not weaken B24-A.** The two finds now include the selected-pair nils so `lastRecommendation` clear still pins inside the same success blocks. Empty-paint after End / later Start, failed Start / failed End / Continue, and leftover `Runtime:EndEvent` then `Console:StartEvent` for the names line are untouched.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Runtime:EndEvent` still leaves `selectedFighterA` / `selectedFighterB`.** Reviewer probe: bypass then Refresh still has both ids; next `Console:StartEvent` clears them (first `after()` Refresh already nil). Brief scoped this lane to Console Start / End. The Pope desk already goes through `Console:EndEvent`. Not glue.

### Nit

1. **Later-Start selected-nil pin is already-empty from EndEvent.** `successful StartEvent leaves selected A/B nil` does not independently prove StartEvent's own write. The source pin closes the hole; reviewer spy after a Runtime leftover confirms StartEvent's first `after()` Refresh is already nil and the following petition-path Recommend paints `"  names  "`.

2. **`runB24A()` later-Start keep still calls `SelectFighters(nil, nil)` before the petition-path Recommend.** Required so B24-A stayed green after B25-A's gate. After this wipe the harness clear is redundant. Assert copy (“later StartEvent has no leftover selected A/B”) still describes the harness wipe. Lifetime pins are intact.

3. **Failed End from QUIET and Pope-refuse Start / End are unpinned.** Brief asked already-live Start and failed End. Those other nil returns also skip the wipe. Probe: leftover pair stays.

4. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Nested B26-A re-pins four of them plus Popes after restore. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B26-A-only selected-pair wipe + nested pins + two B24-A source-string lines. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1922 / 0** was re-run here. Live desk after End Event / next Start Event then petition-path Recommend is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1922 passed, 0 failed.** Isolation wrap: **17**.

Successful `StartEvent` / `EndEvent` nil `selectedFighterA` / `selectedFighterB` before `after()`, after `lastRecommendation = nil`. Failed Start (already live) / failed End / Continue keep the pair. B25-A `hadSelected` gate stays: a seated pair still drops `"  names  "`. End then Start then named Recommend without `SelectFighters` paints `"  names  "`. `SaveNote` stays nil. `runB26A()` is nested inside `runB8E()`. Isolated `lua tests/test_console.lua` **1922 passed, 0 failed**, exit 0. `Runtime:EndEvent` leftover selected fighters remain parked. The B24-A harness clear did not weaken B24-A lifetime.

Do not claim V1 / MVP complete. This review does not sign the lane.
