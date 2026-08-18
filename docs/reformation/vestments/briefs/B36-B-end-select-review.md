Spec PASS

# B36-B — End Event drops leftover human / character selection (review)

**Quality:** Approved-with-nits

**Lane:** B36-B End Event drops leftover human / character selection
**Brief:** `docs/reformation/vestments/briefs/B36-B-end-select.md`
**Writer report:** `docs/reformation/vestments/briefs/B36-B-end-select-report.md`
**Diff:** `docs/reformation/vestments/briefs/B36-B-end-select.diff` (B36-B-only exclusive-pair packet; live `Console.lua` / `test_console.lua` also carry earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`EndEvent` ~1569–1583 / `StartEvent` ~1486–1498 / `Refresh` ~1108–1134 / `Continue` / `after()` ~1468–1475 / `paintSelection` / `paintPresence` selected predicate / `CallForward` / `Dismiss` / `KnightThisBeef` / `SelectHuman` / `SelectCharacter` / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB36B()` inside `runB8E()` after `runB34B()`, plus B24-A / B26-A / B27-A / B28-A / B29-A / B31-A EndEvent source-string updates); then ran `lua tests/test_console.lua` (**2490 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §18.1 leftover highlight; B26-A already nils `selectedFighterA` / `B` on successful Start / End; leftover `selectedHumanId` / `selectedCharacterId` still fed CallForward / Dismiss / KnightThisBeef / Presence highlight after End. Successful `EndEvent` (`result ~= nil`) also nils human / character **before** `after()`. Fighter-pair clear stays. Successful `StartEvent` does **not** nil human / character. Refresh does **not** nil selection (B31-A). Failed End / Continue keep. `SaveNote` nil. No SUMMON. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit glue, Knighting, Confession, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Successful End still leaves `selectedHumanId` / `selectedCharacterId` (B26 leftover; leftover CallForward / Dismiss / KnightThisBeef / Presence highlight) | **Pass. Verified.** Live `EndEvent` sets `lastRecommendation = nil` then the fighter pair then `selectedHumanId` / `selectedCharacterId` = nil when `result ~= nil`, then `return after(...)`. Nested: Quiet pick + Start + failed End + Continue keep both ids; successful End nils both ids and the pair. Reviewer spy: first `after()` Refresh already has both ids nil. |
| Clear runs **after** `after()`, so the first Refresh still paints leftover highlight / leftover verbs still resolve | **Pass. Verified.** Live order is pair nil then human / character nil then `return after(...)`. Source pin matches that exact block. `after()` Refresh only when `result ~= nil`. Reviewer spy: first End Refresh already paints `SelectionStatus` `"No one selected"`; with a ready Roster, Presence `"> "` prefix is already gone on that same Refresh. |
| Successful StartEvent nils human / character (Pope cannot Quiet-pick then Start then OpenRite / KnightThisBeef) | **Pass. Verified.** Live `StartEvent` still nils only `lastRecommendation` and the fighter pair. StartEvent body does not name `selectedHumanId` / `selectedCharacterId`. Nested: Quiet pick + Refresh + Start keeps both ids; OpenRite Knighting still uses the pick. Reviewer probe: Start `after()` Refresh still paints `Selected: Beefina`. |
| Refresh nils the pick (B31-A contract; Quiet pick before Start dies) | **Pass. Verified.** Refresh body does not name human / character or the pair. Nested: Quiet pick then `Refresh` keeps both ids. Reviewer probe: `Runtime:EndEvent` leftover + desk `Refresh` still keeps the pick and still highlights (desk `EndEvent` is the wipe). |
| Failed End / Continue clear the pick | **Pass.** Same `result ~= nil` guard on End. Live `Continue` is still `return after(self, result, err)` with no nil write. Nested: End from RITE returns nil and keeps both ids; Continue returns to ASSEMBLY and keeps both ids. Reviewer probe: failed End from QUIET, Pope-refuse End, and failed Start (already live) also keep. |
| Fighter-pair clear dropped; `lastRecommendation` clear dropped | **Pass.** Pair nils stay in both success blocks. Nested source + behavioral pins: successful End still nils A / B; StartEvent still nils A / B only. `lastRecommendation = nil` stays first. |
| Leftover CallForward / Dismiss / KnightThisBeef without an explicit id still fire on the leftover | **Pass. Verified.** Nested: isolated CallForward refuses (`confession is not available`); stub CallForward is invoked with `nil`, not the leftover character; Dismiss wrap records `nil`; KnightThisBeef wrap records `nil` and rank stays Fresh Beef. Reviewer probe: live Dismiss before End still uses `selectedCharacterId`; after End, ElevateToLord / Enqueue / DeclareVictor / CowardiceRecorded / GrantHonorific also resolve nil. |
| `SaveNote` defined; SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` is nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Nested chrome pins stay. |
| New main-chunk locals / not nested in `runB8E()` after `runB34B()` | **Pass.** `runB36B()` is a nested `local function` inside `runB8E()` after `runB34B()` (brief L17 vs `test_console.lua` ~5078–5088 / ~5255–5257). Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 / isolation wrap rewritten / exclusive breach | **Pass. Verified.** 2490 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB36B()` re-pins 4 of them plus `COB.Popes`. Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Knighting, Confession; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Successful `EndEvent` (`result ~= nil`) also nils `selectedHumanId` / `selectedCharacterId` **before** `after()` | **Pass.** Brief L11 vs `Console.lua` ~1575–1582. Nested exact-block pin + reviewer Refresh spy. |
| Fighter-pair clear stays | **Pass.** Named-risk check. |
| Successful `StartEvent` does **not** nil human / character | **Pass.** Brief L13 vs `StartEvent` ~1492–1497. Nested keep + OpenRite Knighting. |
| Refresh does **not** nil selection (B31-A) | **Pass.** Named-risk check. |
| Failed End / Continue keep | **Pass.** Named-risk check. |
| CallForward / Dismiss / KnightThisBeef without an explicit id refuse or no-op (do not fire on the leftover) | **Pass.** Named-risk check. |
| `SaveNote` stays nil. No SUMMON | **Pass.** Named-risk check. |
| Nest `runB36B()` after `runB34B()` inside `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2490 / 0.** Wrap **17**. |

Bible §18.1 holds on the exclusive pair: after End, the desk no longer highlights a dead pick and leftover one-click verbs do not resolve that pick. Law 3 / Law 4 hold: clearing leftover memory is not an auto-ritual; leftover `KnightThisBeef` refuses and rank stays Fresh Beef; the software does not narrate. Law 5 holds: UI does not invent a rank. Law 6 / License 4 hold: Console stays a plain Event Mode Pope desk; `SaveNote` stays nil; no SUMMON. B26-A pair-clear and B31-A Refresh-does-not-nil-the-pick stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `Gora:_Expire` wipes petitions in QUIET; leftover Dismiss cannot be proven by petition survival | **On contract.** Brief asked refuse or no-op, not petition survival. Wrap records a nil id. Reviewer probe: live Dismiss before End still uses `selectedCharacterId`. |
| ElevateToLord / Enqueue / Skip / AddHonorific / Recognition also read `selected*` and were not separately pinned | **On contract.** Brief named CallForward / Dismiss / KnightThisBeef. Reviewer probe: Elevate / Enqueue / DeclareVictor / Cowardice / GrantHonorific also resolve nil after End. |
| Presence highlight after End is `after()` Refresh with nils; not a separate click-highlight paint pin | **On contract.** Brief tests measure nil ids + leftover verbs. Reviewer probe: first End Refresh already paints `"No one selected"`; with a ready Roster, Presence `"> "` is already gone. Isolated suite has `Roster` nil so Presence rows are empty. |
| No client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Confession.lua was not loaded; leftover CallForward no-op is a stub | **On contract.** Isolation wrap forbids loading Confession. Isolated refuse is the nil-module path. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B26 leftover (human / character pick surviving End and feeding leftover verbs / highlight) is this lane's spec. It is closed on the exclusive pair.

---

## Isolation / clear / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, Roster, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). Nested B36-B re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Clear-before-`after` — Pass.** `after()` Refresh only when `result ~= nil`. End nils `lastRecommendation`, then the pair, then human / character, so that Refresh paints `"No one selected"` and leftover verbs resolve nil. Reviewer spy: first End Refresh already has both ids and the pair nil. Hide / Show after a successful End does not resurrect the pick. End from CONSEQUENCE also nils (same success block).

**Keep — Pass.** Successful Start after a Quiet pick keeps human / character (OpenRite Knighting still uses the pick). Refresh does not nil the pick or the pair, including after a glue-style `Runtime:EndEvent`. Failed End from RITE, failed End from QUIET, Pope-refuse End, failed Start (already live), and Continue keep both ids. `SaveNote` nil. No SUMMON / parchment / tabs.

---

## Strengths

- The wipe is two assignments on the existing End `result ~= nil` block, immediately after the B26-A pair clear and before `after()`. StartEvent, Refresh, and Continue were left alone.
- Failed End, Continue, Quiet-pick Start keep, and Refresh keep sit next to the success wipe, so a blanket nil on every verb or a Refresh wipe would fail.
- Leftover CallForward / Dismiss / KnightThisBeef are pinned as refuse or no-op with wrapped ids, not only as `selected* == nil`. Isolated CallForward refuse sits next to a stub that still reaches Confession with `nil`.
- `runB36B()` sits after `runB34B()` inside `runB8E()`. Isolation wrap stays **17**. No new main-chunk locals. Writer-reported **2490 / 0** matched the re-run. Writer-reported red (**2479 / 12**) matches a missing End pick-clear plus the older exact EndEvent source strings.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **`Runtime:EndEvent` leftover still keeps the desk pick.** Brief forbade Refresh from nilling selection (B31-A). Glue / InspectProgress that bypass `Console:EndEvent` still leave human / character and still highlight until a desk End. Same sibling pattern as B24 / B31 for Recommend. Do not expand this exclusive pair.

2. **Other `selected*` fallbacks are not in-lane pins.** ElevateToLord / Enqueue / Skip / GrantHonorific / Recognition / DeclareVictor / CowardiceRecorded also read the pick. After End they resolve nil (reviewer probe). Brief named three verbs.

### Nit

1. **Presence row `"> "` leftover highlight is not an in-lane pin.** Isolated `GetPresence` is `{}` while Roster is nil; `paintSelection` falls through to `characterName`. Reviewer Roster stub: Quiet pick paints `> Beefina  Fresh Beef  needs Knighting`; first End Refresh drops the prefix and paints `"No one selected"`.

2. **Stub CallForward still reaches Confession with `nil` (`callCount == 1`).** Brief allowed refuse or no-op and forbade firing on the leftover. Existing `id or selected*` fallback is unchanged.

3. **Dismiss petition-survival pin was dropped.** `Gora:_Expire` clears petitions in QUIET. Wrap on the resolved id is the proof. Correct.

4. **Earlier EndEvent exact-block pins (B24-A / B26-A / B27-A / B28-A / B29-A / B31-A) were updated in place.** Necessary so the pair-clear still pins inside the same success block. Not a scope breach.

5. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B36-B-only End pick-clear + nested pins + keep-string updates. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2490 / 0** was re-run here. Live desk after End Event (no leftover highlight / no leftover Knight) is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **2490 passed, 0 failed.** Isolation wrap: **17**.

Successful `EndEvent` nils `selectedHumanId` / `selectedCharacterId` after the fighter-pair clear and **before** `after()`. Successful `StartEvent` does not nil human / character. Refresh does not nil selection. Failed End / Continue keep. Leftover CallForward / Dismiss / KnightThisBeef without an explicit id refuse or no-op. `SaveNote` stays nil. No SUMMON. `runB36B()` is nested inside `runB8E()` after `runB34B()`. Isolated `lua tests/test_console.lua` **2490 passed, 0 failed**, exit 0.

Leftovers: glue-style `Runtime:EndEvent` still keeps the pick (B31-A keep); other `selected*` verbs are not in-lane pins (reviewer probe closed them); Presence `"> "` is not an in-lane pin (reviewer Roster stub closed it); no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.
