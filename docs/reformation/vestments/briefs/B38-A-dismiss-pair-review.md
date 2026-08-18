Spec PASS

# B38-A — Dismiss drops leftover pair when the dismissed id is in it (review)

**Quality:** Approved-with-nits

**Lane:** B38-A successful Dismiss of fighter A or B also nils leftover pair + lastRecommendation
**Brief:** `docs/reformation/vestments/briefs/B38-A-dismiss-pair.md`
**Writer report:** `docs/reformation/vestments/briefs/B38-A-dismiss-pair-report.md`
**Diff:** `docs/reformation/vestments/briefs/B38-A-dismiss-pair.diff` (B38-A-only exclusive-pair packet; live `Console.lua` / `test_console.lua` also carry earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Dismiss` ~1703–1723 / stock Dismiss ~729–731 / `StartEvent` ~1493–1505 / `EndEvent` ~1576–1590 / `Refresh` ~1115–1141 / `FlagFamousUpset` ~1945–1968 / `Sanction` ~1684–1701 / `Recommend` ~1647–1671 / `SelectFighters` / `GetProposedBout` / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB38A()` inside `runB8E()` after `runB37A()`, plus the B32-B / B37-A Dismiss success source-string updates); then ran `lua tests/test_console.lua` (**2674 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §18.1 leftover highlight; B37-A nils `selectedCharacterId` on successful Dismiss; live `FlagFamousUpset` still fell through to leftover `selectedFighterA` when the character pick was nil, and `Sanction` still used the leftover pair. Successful `Dismiss` (`ok` true): if the dismissed id is `selectedFighterA` or `selectedFighterB`, also nils the pair and `lastRecommendation` **before** Refresh. Dismiss of a third id keeps the pair. Failed Dismiss keeps. Does **not** nil `selectedHumanId`. B37-A `selectedCharacterId` nil stays. End / Start / Refresh keeps stay. `SaveNote` nil. No SUMMON. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit glue, Gora, Store, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Successful Dismiss of A still leaves `selectedFighterA` / `B` and `lastRecommendation` (leftover FlagFamousUpset / Sanction still fire) | **Pass. Verified.** Live `Dismiss` on `ok` nils `selectedCharacterId`, then if `isId(id)` and the id is A or B nils `lastRecommendation` and the pair, then `Refresh()`. Nested: Dismiss A nils pair + Recommendation + proposed bout; leftover FlagFamousUpset / Sanction without explicit ids refuse and the wraps record `nil`, not leftover A/B. Reviewer spy: first Dismiss A Refresh already has pair nil, character nil, human kept, proposed bout nil. Reviewer probe: Dismiss B, implicit `Dismiss()`, Confession-only pair member, and stock `OnClick` also nil the pair and empty Recommend. |
| Clear runs **after** Refresh so first paint still shows leftover pair | **Pass. Verified.** Live order is character nil, then matching-pair nil, then Refresh. Source pin matches that exact block. Reviewer spy: first Gora Dismiss A Refresh and first Confession-only pair-member Refresh already have A/B nil. After success, `Recommendation` is `""` and `GetProposedBout` is empty. Hide / Show after success does not resurrect the pair. |
| Failed Dismiss / third-id Dismiss wipe the pair | **Pass. Verified.** `ok` false skips the nil and skips Refresh. Nested: unpetitioned D keeps pair, Recommend, character, and human. Third-id C keeps A/B and Recommend, and still nils `selectedCharacterId` (B37-A). Reviewer probe: Pope-refuse, Gora-missing, and both-false (Gora false + Confession false) keep the pair and do not Refresh. Third-id first Refresh still has A/B. |
| Successful Dismiss nils `selectedHumanId` | **Pass. Verified.** Dismiss body has no `selectedHumanId = nil`. Nested: failed / third-id / Dismiss A keep `selectedHumanId`. Reviewer spy: first Refresh still has the human. Leftover `KnightThisBeef` still resolves that human. |
| B37-A `selectedCharacterId` nil dropped | **Pass. Verified.** Success block still starts with `self.selectedCharacterId = nil` before the pair `if`. Nested third-id and Dismiss A both assert character nil. Reviewer spy: first Refresh already has character nil. |
| End / Start / Refresh keeps dropped | **Pass.** `StartEvent` still nils only `lastRecommendation` and the fighter pair. `EndEvent` still nils human / character / pair on `result ~= nil` before `after()`. Refresh body still does not name either pick or `selectedFighterA`. Nested source + third-id Refresh keep still pass. Reviewer probe: Start keeps human / character and still nils the pair; desk End still nils all three; ASSEMBLY Refresh keeps pair + Recommend. |
| `SaveNote` defined / SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` is nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Dismiss body has no `after(`. Nested chrome pins stay. |
| New main-chunk locals / not nested after `runB37A()` | **Pass.** `runB38A()` is a nested `local function` inside `runB8E()` after the `runB37A()` call (`test_console.lua` ~5430 / ~5602–5604). Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua` (`lastRecommendation` / `isId` already existed). |
| Isolated suite not exit 0 / wrap rewritten / exclusive breach | **Pass. Verified.** 2674 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB38A()` re-pins 4 of them plus `COB.Popes`. Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Gora, Store; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Successful Dismiss (`ok` true): if dismissed id is A or B, nil pair + `lastRecommendation` **before** Refresh | **Pass.** Brief vs `Console.lua` ~1713–1720. Nested exact-block pin + reviewer Refresh spy. |
| Dismiss of a third id keeps the pair | **Pass.** Named-risk check. |
| Failed Dismiss keeps | **Pass.** Named-risk check. |
| Do **not** nil `selectedHumanId` | **Pass.** Named-risk check. |
| B37-A `selectedCharacterId` nil stays | **Pass.** Named-risk check. |
| End / Start / Refresh keeps stay | **Pass.** Named-risk check. |
| Leftover FlagFamousUpset / Sanction without an explicit id do not fire on leftover A | **Pass.** Named-risk check. |
| `SaveNote` stays nil. No SUMMON | **Pass.** Named-risk check. |
| Nest `runB38A()` after `runB37A()` inside `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2674 / 0.** Wrap **17**. |

Bible §18.1 holds on the exclusive pair: after a successful Dismiss of a pair member, leftover FlagFamousUpset / Sanction no longer resolve the leftover fighters, and Recommend paint / proposed bout empty with the pair. Law 3 / Law 4 hold: clearing leftover pair memory is not an auto-ritual; leftover Sanction refuses; the software does not narrate. Law 5 holds: UI does not invent a rank. Law 6 / License 4 hold: Console stays a plain Event Mode Pope desk; `SaveNote` stays nil; no SUMMON. The knighting pick stays on `selectedHumanId` (B36-B End is still the human wipe). B37-A character nil and B32-B dual-reach stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Sanction leftover is wrap-plus-refuse (`a Gora needs two different combatants`) | **On contract.** Brief asked leftover Sanction not to fire on leftover A. Wrap records `nil, nil`. Pre-fix the same call sanctioned leftover A/B. |
| FlagFamousUpset leftover is wrap-plus-refuse (`invalid character id`) | **On contract.** Wrap records `nil, nil`. Fallback is `selectedCharacterId` else fighter A; both are nil after Dismiss A. |
| Dismiss B is source-pinned, not a separate behavioral case | **On contract.** Condition is `id == selectedFighterA or id == selectedFighterB`. Reviewer probe: Dismiss B nils pair + Recommend, leftover Flag / Sanction refuse, human stays. |
| Confession-only success with a pair member is not separately pinned | **On contract.** Same `ok` block. Isolation wrap does not load `Confession.lua`. Reviewer stub: Confession-only Dismiss of A, first Refresh already has pair nil, human stays. |
| QUIET Refresh still nils `lastRecommendation` (B31-A); third-id Recommend-keep is ASSEMBLY-only | **On contract.** Nested third-id keep is after `StartEvent`. Reviewer probe: QUIET Refresh keeps the pair and empties Recommend. A Quiet-desk Dismiss of a third id would still empty Recommend paint even though the pair stays. |
| No client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B37 leftover (successful Dismiss niled the character pick but left `selectedFighterA` / `B` and `lastRecommendation`, so leftover FlagFamousUpset / Sanction still resolved the dismissed fighter) is this lane's spec. It is closed on the exclusive pair.

---

## Isolation / clear / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, Roster, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). Nested B38-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Clear-before-Refresh — Pass.** `Dismiss` Refreshs only when `ok` is true. The success block nils `selectedCharacterId` first, then the matching pair + `lastRecommendation`, so that Refresh cannot paint a leftover proposed bout / Recommend line and leftover FlagFamousUpset / Sanction resolve nil. Fallback `characterId or self.selectedCharacterId` stays. Reviewer spy: first Gora Dismiss A Refresh and first Confession-only pair-member Refresh already have pair nil and human kept. Isolated first Refresh paints empty Recommend. Hide / Show after success does not resurrect the pair. Stock `OnClick` (`GetScript("OnClick")`, stub `:Click()` is a no-op) also nils the pair when the pick is A.

**Keep — Pass.** Failed Dismiss (unpetitioned), Pope-refuse, Gora-missing, and both-false keep the pair and do not Refresh. Third-id Dismiss keeps A/B and Recommend and still nils `selectedCharacterId`. Successful Start after a pick keeps human / character and still nils the pair. ASSEMBLY Refresh does not nil the pair. Successful End still nils human / character / pair (B36-B). `selectedHumanId` is never written in Dismiss. `SaveNote` nil. No SUMMON / parchment / tabs. Dismiss still does not go through `after()`.

---

## Strengths

- The wipe is one `isId` + A-or-B guard on the existing `ok` block, immediately before Refresh. Failed paths and third-id Dismiss cannot empty the pair. StartEvent, EndEvent, and Refresh were left alone.
- Failed Dismiss keep, third-id keep, human keep, B37-A character nil, Start / Refresh keeps, and leftover FlagFamousUpset / Sanction sit next to the success wipe, so a blanket pair nil on every Dismiss, a human wipe, or a Refresh wipe would fail.
- Leftover FlagFamousUpset / Sanction are pinned as refuse **and** as wraps that still reach Store / Gora with `nil`, not leftover A/B.
- `runB38A()` sits after `runB37A()` inside `runB8E()`. Isolation wrap stays **17**. No new main-chunk locals. Writer-reported **2674 / 0** matched the re-run. Writer-reported red (**2659 / 15**) matches a missing pair nil plus leftover FlagFamousUpset / Sanction fire.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Live Presence `"> "` / `SelectionStatus` still paint via leftover `selectedHumanId` after Dismiss.** Brief forbade nilling the knighting pick. Isolated suite has Roster nil, so `GetPresence` is `{}` and `paintSelection` falls through to `characterName(nil)` → `"No one selected"` even though the human id is still set. Leftover `KnightThisBeef` still resolves that human (reviewer probe). Do not expand this exclusive pair to wipe the human.

2. **Dismiss B and Confession-only pair-member are not in-lane behavioral pins.** Condition covers B; same `ok` block covers Confession-only. Reviewer probe closed both. Isolation wrap forbids loading Confession.

3. **`OpenRite("Gora")` after Dismiss A still opens a Gora rite with nil subjects.** Runtime accepts Gora without fighters. Subjects are not leftover A/B (reviewer wrap). Brief named FlagFamousUpset / Sanction, not OpenRite.

### Nit

1. **FlagFamousUpset / Sanction leftover is wrap-plus-refuse.** Without a pair, Store returns `invalid character id` and Gora returns `a Gora needs two different combatants`. Brief allowed refuse or no-op. Wrap proves the resolved ids are nil.

2. **Dismiss B is source-only in the nested suite.** Reviewer probe closed the live path.

3. **QUIET Refresh still nils `lastRecommendation` (B31-A).** Third-id Recommend-keep is ASSEMBLY-only. Reviewer probe: QUIET Refresh keeps the pair and empties Recommend.

4. **B32-B / B37-A exact Refresh source strings were updated in place.** Necessary so Refresh still pins inside the same success block after the pair nil. Not a scope breach.

5. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B38-A-only Dismiss pair-clear + nested pins + B32-B / B37-A keep-string updates. Report already says this.

6. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B38-A re-pins four of them plus Popes. Brief said the wrap stays; it did.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2674 / 0** was re-run here. Live desk after Dismiss A (empty proposed bout / no leftover Sanction) is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: successful Dismiss of A or B nils the pair and `lastRecommendation` before Refresh; third-id Dismiss keeps the pair; failed Dismiss keeps; do not nil `selectedHumanId`; B37-A `selectedCharacterId` nil stays; End / Start / Refresh keeps stay; leftover FlagFamousUpset / Sanction without an explicit id do not fire on leftover A; `SaveNote` nil. Live `Dismiss` ~1713–1720 matches. Brief test pins sit in `runB38A()` after `runB37A()` inside `runB8E()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: live Presence / SelectionStatus still paint via leftover `selectedHumanId` (required keep); Dismiss B / Confession-only pair-member are not in-lane behavioral pins (reviewer probe closed them); OpenRite Gora still succeeds with nil subjects (not leftover A/B). Nits listed above.

**3. Isolation count:** **2674 passed, 0 failed.** Isolation wrap: **17**.

**4. Law:** Bible §18.1 holds. After a successful Dismiss of a pair member, leftover one-click FlagFamousUpset / Sanction no longer resolve the leftover fighters. Law 3 / Law 4 hold: the wipe is desk memory, not an auto-ritual; leftover Sanction refuses. Law 5 holds: UI does not invent a rank. Law 6 / License 4 hold: stock Event Mode desk; `SaveNote` stays nil; no SUMMON. Knighting pick stays on `selectedHumanId` until End.

**Leftovers:**
- Live Presence `"> "` / `SelectionStatus` still paint via leftover `selectedHumanId` after Dismiss (Important, not must-fix; required keep).
- Dismiss B / Confession-only pair-member are not in-lane behavioral pins (reviewer probe: they nil the pair).
- `OpenRite("Gora")` after Dismiss A still opens with nil subjects (not leftover A/B).
- FlagFamousUpset / Sanction leftover is wrap-plus-refuse.
- QUIET Refresh still empties Recommend (B31-A) even when the pair stays.
- B32-B / B37-A Refresh source strings were updated in place (necessary).
- Exclusive-pair packet is not a vs-HEAD Console delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Successful `Dismiss` of A or B nils the pair and `lastRecommendation` before Refresh. Third-id Dismiss keeps the pair. Failed Dismiss keeps. Does not nil `selectedHumanId`. B37-A `selectedCharacterId` nil stays. End / Start / Refresh keeps stay. Leftover FlagFamousUpset / Sanction without an explicit id refuse. `SaveNote` stays nil. No SUMMON. `runB38A()` is nested inside `runB8E()` after `runB37A()`. Isolated `lua tests/test_console.lua` **2674 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
