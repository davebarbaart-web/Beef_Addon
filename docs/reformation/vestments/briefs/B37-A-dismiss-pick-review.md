Spec PASS

# B37-A — successful Dismiss drops leftover character pick (review)

**Quality:** Approved-with-nits

**Lane:** B37-A successful Dismiss drops leftover character pick
**Brief:** `docs/reformation/vestments/briefs/B37-A-dismiss-pick.md`
**Writer report:** `docs/reformation/vestments/briefs/B37-A-dismiss-pick-report.md`
**Diff:** `docs/reformation/vestments/briefs/B37-A-dismiss-pick.diff` (B37-A-only exclusive-pair packet; live `Console.lua` / `test_console.lua` also carry earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Dismiss` ~1699–1714 / stock Dismiss ~725–727 / `CallForward` ~1669–1677 / `DeclareVictor` ~1716–1723 / `CowardiceRecorded` ~1725–1731 / `StartEvent` ~1489–1501 / `EndEvent` ~1572–1586 / `Refresh` ~1111–1137 / `paintSelection` ~930–949 / `paintPresence` selected predicate ~871–873 / `paintPetitions` ~912–914 / `paintConfessions` ~1031–1033 / `SelectHuman` / `SelectCharacter` / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB37A()` inside `runB8E()` after `runB36B()`, plus the B32-B Dismiss Refresh source-string update); then ran `lua tests/test_console.lua` (**2573 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §18.1 leftover highlight; B36-B EndEvent nils `selectedCharacterId`; live `Dismiss` still resolved `id = characterId or self.selectedCharacterId` and never niled the pick, so one-click CallForward / DeclareVictor still resolved the dismissed petitioner. Successful `Dismiss` (`ok` true, including Confession-only) nils `selectedCharacterId` **before** Refresh. Failed Dismiss keeps. Does **not** nil `selectedHumanId` (knighting pick is separate). End / Start / Refresh keeps stay. `SaveNote` nil. No SUMMON. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit glue, Gora, Confession, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Successful Dismiss still leaves `selectedCharacterId` (B36 leftover; leftover CallForward / DeclareVictor still resolve the dismissed petitioner) | **Pass. Verified.** Live `Dismiss` sets `selectedCharacterId = nil` then `self:Refresh()` only when `ok` is true. Nested: pick + Start + failed Dismiss keep; successful Gora Dismiss nils character and keeps human; leftover CallForward / DeclareVictor without an explicit id do not fire on the leftover. Reviewer spy: first Dismiss Refresh already has `selectedCharacterId` nil. |
| Clear runs **after** Refresh, so the first paint still highlights the dismissed petitioner / leftover verbs still resolve | **Pass. Verified.** Live order is character nil then Refresh. Source pin matches that exact block. Reviewer spy: first Gora Dismiss Refresh already has character nil and human kept; isolated `SelectionStatus` is already `"No one selected"`. Hide / Show after success does not resurrect the character pick. |
| Failed Dismiss clears the pick | **Pass. Verified.** `ok` false skips the nil and skips Refresh. Nested: Dismiss with no petition returns false and keeps both ids. Reviewer probe: failed Dismiss Refresh count is 0; Pope-refuse, Gora-missing (`"gora is not available"`), and both-false (Gora false + Confession false) also keep. |
| Successful Dismiss nils `selectedHumanId` (knighting pick dies) | **Pass. Verified.** Dismiss body has no `selectedHumanId = nil`. Nested: Gora success and Confession-only keep `selectedHumanId`. Reviewer spy: first Refresh still has the human; leftover `KnightThisBeef` / `BeginRecognition` still resolve that human. |
| Confession-only success (`ok` true via inbox, Gora false) leaves the character pick | **Pass. Verified.** Live `if Confession:Dismiss(id) then ok = true end` then the same success block. Nested stub + reviewer probe: Confession-only returns true, first Refresh already has character nil, human stays. |
| End / Start / Refresh keeps dropped | **Pass.** `StartEvent` still nils only `lastRecommendation` and the fighter pair. `EndEvent` still nils human / character on `result ~= nil` before `after()`. Refresh body still does not name either pick. Nested source + behavioral keeps still pass. Reviewer probe: Start keeps both; desk End still nils both. |
| Leftover CallForward / DeclareVictor without an explicit id still fire on the leftover | **Pass. Verified.** Nested: isolated CallForward refuses (`confession is not available`); stub CallForward is invoked with `nil`, not the leftover character; DeclareVictor wrap records `nil` and refuses. Reviewer probe: CowardiceRecorded wrap records `nil`; FlagFamousUpset does not use the leftover character; BeginRecognition character fallback is nil. |
| `SaveNote` defined; SUMMON / parchment / tabs; Dismiss fans out through `after()` | **Pass.** `Console.SaveNote` is nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Dismiss body has no `after(`. Nested chrome pins stay. |
| New main-chunk locals / not nested in `runB8E()` after `runB36B()` | **Pass.** `runB37A()` is a nested `local function` inside `runB8E()` after the `runB36B()` call (`test_console.lua` ~5256–5266 / ~5419–5421). Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 / isolation wrap rewritten / exclusive breach | **Pass. Verified.** 2573 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB37A()` re-pins 4 of them plus `COB.Popes`. Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Gora, Confession; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Successful Dismiss (`ok` true, including Confession-only) nils `selectedCharacterId` **before** Refresh | **Pass.** Brief vs `Console.lua` ~1709–1712. Nested exact-block pin + reviewer Refresh spy. |
| Failed Dismiss keeps the pick | **Pass.** Named-risk check. |
| Do **not** nil `selectedHumanId` (knighting pick is separate) | **Pass.** Named-risk check. |
| End / Start / Refresh keeps stay | **Pass.** Named-risk check. |
| CallForward / DeclareVictor without an explicit id do not fire on the leftover | **Pass.** Named-risk check. |
| `SaveNote` stays nil. No SUMMON | **Pass.** Named-risk check. |
| Nest `runB37A()` after `runB36B()` inside `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2573 / 0.** Wrap **17**. |

Bible §18.1 holds on the exclusive pair: after a successful Dismiss, one-click CallForward / DeclareVictor no longer resolve the dismissed petitioner. Law 3 / Law 4 hold: clearing leftover character memory is not an auto-ritual; leftover DeclareVictor refuses; the software does not narrate. Law 5 holds: UI does not invent a rank. Law 6 / License 4 hold: Console stays a plain Event Mode Pope desk; `SaveNote` stays nil; no SUMMON. The knighting pick stays on `selectedHumanId` (B36-B End is still the human wipe). B32-B dual-reach and isolated Gora-only Dismiss stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| DeclareVictor leftover is wrap-only; without a sanctioned pair it would still refuse `no sanctioned gora` | **On contract.** Brief asked refuse or no-op, not a live verdict. Wrap records a nil id. Reviewer probe: CowardiceRecorded wrap also records nil. |
| CowardiceRecorded / FlagFamousUpset / Recognition also read `selectedCharacterId` and were not separately pinned | **On contract.** Brief named CallForward / DeclareVictor. Reviewer probe: Cowardice / Flag / BeginRecognition character fallback also resolve nil after Dismiss. |
| Presence highlight after Dismiss is Refresh with a nil character pick; not a separate click-highlight paint pin | **On contract.** Brief tests measure nil `selectedCharacterId` + leftover character verbs. Isolated `GetPresence` is `{}` while Roster is nil, so `paintSelection` falls through to `characterName(nil)` → `"No one selected"`. Reviewer Roster stub: first Dismiss Refresh still paints `Selected: Beefina` and Presence `"> "` because `selectedHumanId` stays. That keep is required. |
| Explicit-id Dismiss of a different character also nils the pick (unconditional on `ok`) | **On contract.** Brief said successful Dismiss nils `selectedCharacterId`. It did not say "only when the dismissed id matches the pick." Reviewer probe: `Dismiss(otherId)` succeeds and nils the leftover pick; human stays. |
| No client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Confession.lua was not loaded; leftover CallForward no-op is a stub | **On contract.** Isolation wrap forbids loading Confession. Isolated refuse is the nil-module path. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B36 leftover (Dismiss never niled the character pick, so leftover CallForward / DeclareVictor still resolved the dismissed petitioner) is this lane's spec. It is closed on the exclusive pair.

---

## Isolation / clear / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, Roster, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). Nested B37-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Clear-before-Refresh — Pass.** `Dismiss` Refreshs only when `ok` is true. The success block nils `selectedCharacterId` first, so that Refresh cannot paint a leftover character pick and leftover character verbs resolve nil. Fallback `characterId or self.selectedCharacterId` stays. Reviewer spy: first Gora Dismiss Refresh and first Confession-only Refresh already have character nil and human kept. Isolated first Refresh paints `"No one selected"`. Hide / Show after success does not resurrect the character pick. Stock `OnClick` (`GetScript("OnClick")`, stub `:Click()` is a no-op) also nils character and keeps human.

**Keep — Pass.** Failed Dismiss (no petition), Pope-refuse, Gora-missing, and both-false keep both ids and do not Refresh. Successful Start after a pick keeps human / character. Refresh does not nil the pick. Successful End still nils both (B36-B). `selectedHumanId` is never written in Dismiss. `SaveNote` nil. No SUMMON / parchment / tabs. Dismiss still does not go through `after()`.

---

## Strengths

- The wipe is one assignment on the existing `ok` block, immediately before Refresh. Failed paths cannot empty the pick. StartEvent, EndEvent, and Refresh were left alone.
- Failed Dismiss keep, human keep, Start / Refresh keeps, and leftover CallForward / DeclareVictor sit next to the success wipe, so a blanket nil on every verb, a human wipe, or a Refresh wipe would fail.
- Confession-only success is pinned on the same fixture after the Gora wipe, so a Gora-only rewrite would fail.
- Leftover CallForward is pinned as isolated refuse **and** as a stub that still reaches Confession with `nil`. DeclareVictor is wrapped on the resolved id, not only asserted as `selectedCharacterId == nil`.
- `runB37A()` sits after `runB36B()` inside `runB8E()`. Isolation wrap stays **17**. No new main-chunk locals. Writer-reported **2573 / 0** matched the re-run. Writer-reported red (**2567 / 6**) matches a missing character nil plus leftover CallForward / DeclareVictor fire.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Live Presence `"> "` / `SelectionStatus` still paint via leftover `selectedHumanId` after Dismiss.** Brief forbade nilling the knighting pick. Isolated suite has Roster nil, so the first Dismiss Refresh paints `"No one selected"` even though the human id is still set. Reviewer Roster stub: first Dismiss Refresh already has character nil and still paints `Selected: Beefina` plus Presence `"> Beefina  Fresh Beef  needs Knighting"`. Leftover `KnightThisBeef` / `BeginRecognition` still resolve that human. Do not expand this exclusive pair to wipe the human.

2. **Other `selectedCharacterId` fallbacks are not in-lane pins.** CowardiceRecorded / FlagFamousUpset / BeginRecognition also read the pick. After Dismiss they resolve nil on the character side (reviewer probe). Brief named CallForward / DeclareVictor.

### Nit

1. **DeclareVictor leftover is wrap-only.** Without a sanctioned pair, Core still refuses `no sanctioned gora`. Brief allowed refuse or no-op. Wrap proves the resolved id is nil.

2. **Stub CallForward still reaches Confession with `nil` (`callCount == 1`).** Brief forbade firing on the leftover. Existing `id or selected*` fallback is unchanged.

3. **Explicit-id Dismiss of a different character also nils the leftover pick.** Unconditional on `ok`. Reviewer probe closed it. Not a miss.

4. **Presence row `"> "` leftover highlight is not an in-lane pin.** Isolated `GetPresence` is `{}`. Reviewer Roster stub closed the human-keep paint. Petition / confession row predicates are character-only and drop with the nil.

5. **B32-B exact Refresh source string was updated in place.** Necessary so Refresh still pins inside the same success block after the character nil. Not a scope breach.

6. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B37-A-only Dismiss pick-clear + nested pins + B32-B keep-string update. Report already says this.

7. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B37-A re-pins four of them plus Popes. Brief said the wrap stays; it did.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2573 / 0** was re-run here. Live desk after Dismiss (no leftover CallForward on the dismissed petitioner) is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: successful Dismiss (`ok` true, including Confession-only) nils `selectedCharacterId` before Refresh; failed Dismiss keeps; do not nil `selectedHumanId`; End / Start / Refresh keeps stay; leftover CallForward / DeclareVictor without an explicit id do not fire on the leftover; `SaveNote` nil. Live `Dismiss` ~1709–1712 matches. Brief test pins sit in `runB37A()` after `runB36B()` inside `runB8E()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: live Presence / SelectionStatus still paint via leftover `selectedHumanId` (required keep); other character fallbacks are not in-lane pins (reviewer probe closed them). Nits listed above.

**3. Isolation count:** **2573 passed, 0 failed.** Isolation wrap: **17**.

**4. Law:** Bible §18.1 holds. After a successful Dismiss, leftover one-click CallForward / DeclareVictor no longer resolve the dismissed petitioner. Law 3 / Law 4 hold: the wipe is desk memory, not an auto-ritual; leftover DeclareVictor refuses. Law 5 holds: UI does not invent a rank. Law 6 / License 4 hold: stock Event Mode desk; `SaveNote` stays nil; no SUMMON. Knighting pick stays on `selectedHumanId` until End.

**Leftovers:**
- Live Presence `"> "` / `SelectionStatus` still paint via leftover `selectedHumanId` after Dismiss (Important, not must-fix; required keep).
- CowardiceRecorded / FlagFamousUpset / Recognition character fallbacks are not in-lane pins (reviewer probe: they resolve nil).
- DeclareVictor leftover is wrap-only.
- Explicit-id Dismiss of a different character also nils the leftover pick (on contract).
- Isolated suite stubs Confession (real inbox removal is not an in-lane pin).
- B32-B Refresh source string was updated in place (necessary).
- Exclusive-pair packet is not a vs-HEAD Console delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Successful `Dismiss` nils `selectedCharacterId` before Refresh. Failed Dismiss keeps. Does not nil `selectedHumanId`. End / Start / Refresh keeps stay. Leftover CallForward / DeclareVictor without an explicit id refuse or no-op. `SaveNote` stays nil. No SUMMON. `runB37A()` is nested inside `runB8E()` after `runB36B()`. Isolated `lua tests/test_console.lua` **2573 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
