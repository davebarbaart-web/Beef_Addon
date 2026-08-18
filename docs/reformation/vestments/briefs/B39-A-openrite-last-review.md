Spec PASS

# B39-A — OpenRite Gora does not reopen the last pair (review)

**Quality:** Approved-with-nits

**Lane:** B39-A `OpenRite("Gora")` does not fall through to `GetLastSanctioned` when the desk pair is empty
**Brief:** `docs/reformation/vestments/briefs/B39-A-openrite-last.md`
**Writer report:** `docs/reformation/vestments/briefs/B39-A-openrite-last-report.md`
**Diff:** `docs/reformation/vestments/briefs/B39-A-openrite-last.diff` (B39-A-only exclusive-pair packet; live `Console.lua` / `test_console.lua` also carry earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`OpenRite` ~1508–1551 / header ~68–70 / Knighting branch ~1514–1531 / `StartEvent` ~1494–1506 / `EndEvent` ~1571–1585 / `Dismiss` ~1703–1723 / stock Open Gora ~632 / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB39A()` inside `runB8E()` after `runB38A()`, plus the B11-C last-only VOID pin retarget); then ran `lua tests/test_console.lua` (**2798 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §18.1 leftover highlight; §10.7 persist is the Gora pair, not the next rite; B10-INT: post-Continue ASSEMBLY does not overlay last pair. Live `OpenRite("Gora")` still uses selected `selectedFighterA` / `B` when both ids are set, else live `Gora:GetSanctioned()` only. The `GetLastSanctioned` fall-through is gone. Knighting OpenRite still prefers `selectedHumanId` then `GetLine` head. End / Start / Dismiss keeps stay. `SaveNote` nil. No SUMMON. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit glue, Gora, Store, Runtime, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| `GetLastSanctioned` fallback still present | **Pass. Verified.** Live `OpenRite` Gora branch (~1532–1547) has no `GetLastSanctioned` call. The only remaining name is the header note that leftover last pair is persist, not the next rite. Nested source pin: `OpenRite` body `find("GetLastSanctioned")` is nil. Nested Continue wrap: second `OpenRite("Gora")` after Sanction / CloseRite / VOID / Continue passes `nil` fighters, not leftover A/B, while `GetLastSanctioned` still holds A/B. Reviewer spy: leftover OpenRite calls `GetLastSanctioned` **0** times. B11-C last-only VOID is now a refuse pin (subjects nil; leftover A/B not attached). Stock `Open Gora` OnClick after Continue also passes nil fighters and does not call last. Invalid live pair table, missing `GetSanctioned`, one selected id plus leftover last, and Hide / Show after Continue all stay off last. |
| Live `GetSanctioned` fallback dropped | **Pass. Verified.** Live fallback stays: when both selected ids are missing, `Gora:GetSanctioned()` is read if the method exists; a table pair assigns `a` / `b`; `isId` still gates `subjects = { fighters = { a, b } }`. Nested: Start + Sanction with no desk pair opens Runtime subjects `{liveA, liveB}`. Reviewer spy: that path calls `GetSanctioned` and does not call `GetLastSanctioned`. |
| Selected A/B no longer win | **Pass. Verified.** Live short-circuit is still `if not (isId(a) and isId(b))` before the live read. Nested VOID leftover + `SelectFighters(selA, selB)` attaches sel, not last. Reviewer probe: selected pair also wins over a **live** sanctioned pair (live `GetSanctioned` is not consulted). One selected id alone does not win and does not reopen last. |
| Knighting OpenRite changed | **Pass. Verified.** Knighting branch is still `selectedHumanId`, else `Knighting:GetLine()` head when `humanId` is an id. Nested source pin + line-head keep. Reviewer probe: selected human still wins over the line head. Confession / Proclamation still pass `subjects = nil`. |
| `SaveNote` / SUMMON | **Pass.** `Console.SaveNote` is nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Nested chrome pins stay. Reviewer probe: no SUMMON button after the leftover sequence. |
| Not nested after `runB38A()` | **Pass.** `runB39A()` is a nested `local function` inside `runB8E()` after the `runB38A()` call (`test_console.lua` ~5608 / ~5618–5794). Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 | **Pass. Verified.** 2798 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB39A()` re-pins 4 of them plus `COB.Popes`. Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Gora, Store, Runtime; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Keep the live `GetSanctioned` fallback | **Pass.** Named-risk check. Brief vs `Console.lua` ~1534–1543. |
| Drop the `GetLastSanctioned` fallback | **Pass.** Named-risk check. Nested Continue wrap + reviewer last-call spy. |
| Selected `selectedFighterA` / `B` still win | **Pass.** Named-risk check. |
| Knighting OpenRite unchanged | **Pass.** Named-risk check. |
| End / Start / Dismiss keeps stay | **Pass.** `StartEvent` still nils only `lastRecommendation` and the fighter pair. `EndEvent` still nils human / character / pair on `result ~= nil`. Nested exact-block pins stay. Reviewer probe: Start keeps human / character and still nils the pair; desk End still nils all three; failed / third-id Dismiss keeps the pair and does not nil `selectedHumanId`. |
| Sanction A/B, rule, Continue; OpenRite Gora without a desk pair does **not** put leftover last fighters on Runtime subjects | **Pass.** Nested wrap records `nil` / `nil`. Runtime subjects have no leftover last fighters. |
| `SaveNote` stays nil. No SUMMON | **Pass.** Named-risk check. |
| Nest `runB39A()` after `runB38A()` inside `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2798 / 0.** Wrap **17**. |

Bible §18.1 holds on the exclusive pair: after Continue, leftover last fighters are persist, not the next Open Gora. §10.7 persist stays on Gora (`GetLastSanctioned` still exists); Console no longer reads it to reopen the bout. B10-INT holds for this desk path: post-Continue ASSEMBLY Open Gora does not overlay last pair. Law 3 / Law 4 hold: dropping last fallback is not an auto-ritual; the next rite does not invent a pair; the software does not narrate. Law 5 holds: UI does not invent a rank. Law 6 / License 4 hold: Console stays a plain Event Mode Pope desk; `SaveNote` stays nil; no SUMMON. Knighting OpenRite stays on `selectedHumanId` then line head.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| OpenRite Gora after Continue still opens with nil subjects | **On contract.** Brief asked leftover last fighters not on Runtime subjects, not a refuse of the rite. Runtime accepts Gora without fighters. Wrap proves leftover A/B are not passed. |
| B11-C last-only VOID path is now a refuse pin | **On contract.** Same leftover last pair; B39-A is the named Continue sequence. Exclusive test file had to stop expecting last-pair attach. Reviewer Continue wrap + last-call spy closed the named path. |
| Selected pair vs a live `GetSanctioned` pair is still not a race pin | **On contract.** Live code short-circuits whenever both selected ids are set. Reviewer probe: selected wins; live is not consulted. |
| `GetLastSanctioned` still exists on Gora | **On contract.** Persist is unchanged. Console just does not read it on OpenRite. Brief forbade editing Gora. |
| Knighting last-pair overlay is wire (B38-B / B39-INT) | **On contract.** Not this exclusive pair. Glue `stateFields` still overlays last on RITE / CONSEQUENCE (`canCarryLast`); post-Continue ASSEMBLY already refuses last. |
| No client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B11 leftover (`OpenRite("Gora")` fell through to `GetLastSanctioned` when the desk pair was empty, so a later Open Gora reopened the finished bout) is this lane's spec. It is closed on the exclusive pair.

---

## Isolation / clear / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, Roster, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). Nested B39-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Clear-before-Open — Pass.** After rule + Continue, live `GetSanctioned` is nil, desk pair is empty, and `GetLastSanctioned` still holds A/B. `OpenRite("Gora")` does not read last, so Runtime subjects stay empty rather than leftover A/B. Reviewer spy: first leftover OpenRite already has last-call count 0 and wrap fighters nil. Hide / Show after Continue does not resurrect a desk pair. Stock `OnClick` (`GetScript("OnClick")`) matches.

**Keep — Pass.** Live `GetSanctioned` fallback stays. Selected A/B still win (including over a live pair). Knighting OpenRite unchanged. Failed / third-id Dismiss keeps the pair. Successful Start after a pick keeps human / character and still nils the pair. Successful End still nils human / character / pair (B36-B). `GetLastSanctioned` still exists on Gora. `SaveNote` nil. No SUMMON / parchment / tabs.

---

## Strengths

- The cut is one fall-through block on the existing Gora branch. Selected A/B, live `GetSanctioned`, Knighting, Start, End, and Dismiss were left alone.
- Live fallback, selected-wins, Continue leftover wrap, Knighting line-head, and Start / End / Dismiss keeps sit next to the drop, so a blanket subject wipe, a dropped live fallback, or a Knighting rewrite would fail.
- Leftover OpenRite is pinned as a wrap that still reaches Runtime with `nil` fighters, not leftover A/B, while Gora persist still holds the last pair.
- `runB39A()` sits after `runB38A()` inside `runB8E()`. Isolation wrap stays **17**. No new main-chunk locals. Writer-reported **2798 / 0** matched the re-run. Writer-reported red (**2789 / 9**) matches a still-present last fallback plus the B11-C last-only attach pin.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **`OpenRite("Gora")` after Continue still opens with nil subjects.** Runtime accepts Gora without fighters. The wrap proves leftover A/B are not passed. Brief named leftover last fighters, not a refuse of the rite.

2. **Glue still overlays last pair on RITE / CONSEQUENCE.** `ChurchOfBeef.lua` `stateFields` still reads `GetLastSanctioned` when `canCarryLast` (RITE / CONSEQUENCE). Post-Continue ASSEMBLY already refuses last. Not this exclusive pair. Writer named the Knighting overlay as wire (B38-B / B39-INT).

3. **Selected pair vs a live `GetSanctioned` pair is not an in-lane behavioral pin.** Live short-circuit covers it. Reviewer probe closed it.

### Nit

1. **B11-C last-only VOID is source-retargeted, not the named Continue sequence.** Necessary so the suite does not still expect last-pair attach. Same leftover last pair; B39-A is the Continue wrap.

2. **B11-C comment still says "StartEvent for last-pair fallback".** Asserts were retargeted; the nearby comment was not.

3. **One selected id, invalid live pair, missing `GetSanctioned`, stock Open Gora, and Hide / Show after Continue are reviewer probes, not nested pins.** All stay off last.

4. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B39-A-only last-fallback drop + nested pins + B11-C last-only retarget. Report already says this.

5. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B39-A re-pins four of them plus Popes. Brief said the wrap stays; it did.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2798 / 0** was re-run here. Live desk Open Gora after Continue (empty subjects / no leftover last pair) is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: keep live `GetSanctioned`; drop `GetLastSanctioned`; selected A/B still win; Knighting OpenRite unchanged; End / Start / Dismiss keeps stay; Sanction A/B, rule, Continue; OpenRite Gora without a desk pair does not put leftover last fighters on Runtime subjects; `SaveNote` nil. Live `OpenRite` ~1532–1547 matches. Brief test pins sit in `runB39A()` after `runB38A()` inside `runB8E()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: OpenRite Gora after Continue still opens with nil subjects (required keep of the rite); glue last overlay on RITE / CONSEQUENCE is not this exclusive pair; selected-vs-live is not an in-lane pin (reviewer probe closed it). Nits listed above.

**3. Isolation count:** **2798 passed, 0 failed.** Isolation wrap: **17**.

**4. Law:** Bible §18.1 holds. After Continue, leftover last fighters are persist, not the next Open Gora. §10.7 persist stays on Gora; Console no longer reads it to reopen the bout. B10-INT holds for this desk path. Law 3 / Law 4 hold: the drop is desk subject choice, not an auto-ritual; the next rite does not invent a pair. Law 5 holds: UI does not invent a rank. Law 6 / License 4 hold: stock Event Mode desk; `SaveNote` stays nil; no SUMMON. Knighting OpenRite stays on `selectedHumanId` then line head.

**Leftovers:**
- `OpenRite("Gora")` after Continue still opens with nil subjects (Important, not must-fix; rite is not refused).
- Glue still overlays last pair on RITE / CONSEQUENCE (not this exclusive pair).
- Selected pair vs live `GetSanctioned` is not an in-lane pin (reviewer probe: selected wins).
- B11-C last-only VOID is now a refuse pin; nearby comment still says last-pair fallback.
- One selected id / invalid live / missing `GetSanctioned` / stock Open Gora / Hide-Show are reviewer probes.
- Exclusive-pair packet is not a vs-HEAD Console delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

`OpenRite("Gora")` keeps selected A/B, then live `GetSanctioned` only. `GetLastSanctioned` fallback is gone. Knighting OpenRite unchanged. End / Start / Dismiss keeps stay. After Sanction / rule / Continue, OpenRite Gora without a desk pair does not put leftover last fighters on Runtime subjects. `SaveNote` stays nil. No SUMMON. `runB39A()` is nested inside `runB8E()` after `runB38A()`. Isolated `lua tests/test_console.lua` **2798 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
