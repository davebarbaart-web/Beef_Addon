Spec PASS

# B11-C — Console mouse wheel + Open Gora subjects (review)

**Quality:** Approved-with-nits

**Lane:** B11-C Console mouse wheel + Open Gora subjects (stock)
**Brief:** `docs/reformation/vestments/briefs/B11-C-console-wheel.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B11-C-console-wheel-report.md`
**Diff:** `docs/reformation/vestments/briefs/B11-C-console-wheel.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/Console.lua` (`buildFrame` `DeskScroll` wheel / `OpenRite("Gora")` / `SaveNote` / SUMMON / tab / parchment / `OnUpdate`), and `tests/test_console.lua` (`runB11C()` nested inside `runB8E()`); then ran `lua tests/test_console.lua`. Law cited: Bible §18.1 (glanceable Director Console); Law 10 / §19.3 (Director Console stays stock-pragmatic); Bible §20.2 (Open Rite is a Pope console action); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain). Anniversary `EnableMouseWheel` (SimpleScriptRegionAPI, default false) and `GetVerticalScrollRange` (SimpleScrollFrameAPI) confirmed on `classic_anniversary` 2.5.6. Did not mutate addon code. Did not edit Store or Gora. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Type-guarded `EnableMouseWheel` + `OnMouseWheel` on `DeskScroll` | **Pass.** After `DeskScroll` create / `SetScrollChild` / `SetVerticalScroll(0)`, `type(deskScroll.EnableMouseWheel) == "function"` then `EnableMouseWheel(true)`. `type(deskScroll.SetScript) == "function"` then `SetScript("OnMouseWheel", …)`. Handler type-guards `GetVerticalScroll` / `SetVerticalScroll` / `GetVerticalScrollRange` as functions, requires number `current` / `range` / `delta`, steps `current - delta * 36`, clamps to `[0, range]`. Missing APIs or non-number reads no-op. Anniversary SimpleScriptRegionAPI lists `EnableMouseWheel([enable])` (default false). |
| No permanent `OnUpdate` | **Pass.** Live file has no `SetScript("OnUpdate"`. `DeskScroll` and the outer frame `GetScript("OnUpdate")` are nil. Source pin refuses `deskScroll:SetScript("OnUpdate"`. |
| `OpenRite("Gora")` selected pair wins; else live then last | **Pass.** Both selected ids (`isId(a) and isId(b)`) skip the fallback. Else `COB.Gora:GetSanctioned()` when that method exists; pair must be a table with two ids, else `GetLastSanctioned()`. Then the same `isId` gate writes `subjects = { fighters = { a, b } }`. Knighting still uses `selectedHumanId` only. Confession / Proclamation still pass `subjects = nil`. Missing Gora / methods / ids leave subjects empty. |
| `SaveNote` nil; no SUMMON; no parchment; no tabs | **Pass.** `Console.SaveNote` / `GetNotes` / `CopyCeremonySummary` / `CeremonySummary` are nil. Source has no `function Console:SaveNote`, `SUMMON THE FAITHFUL`, `CopyCeremonySummary`, `Parchment`, or `PanelTabButtonTemplate`. No SUMMON / COPY SUMMARY / WHISPER ALL / RSVP chrome. |
| Isolated green; 200-local nest | **Pass.** Reviewer ran `lua tests/test_console.lua` on Lua **5.1.5**: **1175 passed, 0 failed**, exit 0. No `too many local variables`. B11-C pins live in `runB11C()` nested inside `runB8E()`. Isolation cluster is still `if standalone then` (17 nil-module pins at file load). B11-C re-pins Archive + Quiet shell + Toasts. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, Gora, glue, TOC; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. Live B11-C sites match that slice (wheel after `DeskScroll` create; Gora fallback inside `OpenRite`; `runB11C()` nest). Store / Gora / TOC / `ChurchOfBeef.lua` are dirty from other exclusive lanes, not this packet. |
| Console stays stock; `SaveNote` stays nil; no SUMMON; no parchment; no tabs | **Pass.** Named-risk check. No new chrome. Wheel is a script on the existing stock `UIPanelScrollFrameTemplate`. |
| After creating `DeskScroll`, type-guard `EnableMouseWheel(true)` and `OnMouseWheel`; modest step (36px); missing APIs no-op; no permanent `OnUpdate` | **Pass.** Named-risk check. Harness `GetVerticalScroll` / `GetVerticalScrollRange` are noops that return nil, so the handler no-ops after the type-guard. Brief / reviewer instructions allow pinning wiring, not offset. `stub.fire(..., "OnMouseWheel", -1)` does not error. |
| `OpenRite("Gora")` uses selected pair when both ids are set; else `GetSanctioned()` then `GetLastSanctioned()`; selected still wins; other rite kinds unchanged | **Pass.** Named-risk check. Pope-predicate wrap: `StartEvent` + `Sanction(a,b)` with no selected fighters → Runtime subjects `{ a.id, b.id }`. Selected pair wins over `GetLastSanctioned` after VOID. Last-pair-only fallback after VOID with no selection. |
| New pins nested (Lua 5.1 200-local cap); isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** Nested `runB11C()`. Isolation stayed gated. Isolated **1175 / 0**. |

Bible §18.1 (glanceable stock desk), Law 10 / §19.3 (Director Console stays plain), §20.2 (Open Rite is a Pope verb), and CONTINUE (no SUMMON; no post-show clipboard; `SaveNote` nil) are met. §18.1 still wants to minimize scrolling; wheel makes the 780/1050 desk reachable. That tension is leftover, not a miss.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; 36px vs stock `UIPanelScrollFrameTemplate` thumb unproven on Anniversary | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Harness scroll getters are noops; tests pin wiring and “fire does not error,” not a moved offset | **Not a miss.** Reviewer instructions say the same. Production still calls the guarded client methods. See leftover. |
| One-sided selected pair (only A or only B) falls through to the Gora pair | **Not a miss.** Brief said “when both ids are set.” |
| Last-pair fallback after VOID still opens from ASSEMBLY (Runtime independent of Gora) | **Not a miss.** Brief asked `GetLastSanctioned` as the second fallback. Catch-up overlay of last pair onto STATE remains B11-A / B11-INT. |
| Bible §18.1 still wants to minimize scrolling | **Not a miss.** Brief asked for the wheel on the existing tall child. |

---

## Strengths

- Wheel is a type-guarded script on the existing stock desk `ScrollFrame`, not a new chrome surface and not an `OnUpdate` poll.
- Gora subject fallback is ordered and gated: selected pair (both ids) → live `GetSanctioned` → `GetLastSanctioned`. Other rite kinds were not opened as a place to invent subjects.
- `SaveNote` is still absent. There is no SUMMON chrome, no parchment, no tabs, no second clipboard.
- Isolation stayed gated. New asserts sit in `runB11C()` so Lua 5.1’s 200-local cap does not fire. Isolated **1175 / 0** was re-run here and matches the writer report.

---

## Must-fix

None.

---

## Leftover (Minor)

1. **No `/reload` smoke.** Nested list `ScrollFrame`s (Presence / Gora / Confession / Line / CeremonyLog) will eat the wheel when the cursor is over those lists. 36px vs the stock template thumb is unproven on Anniversary. **POLISH:CANDIDATE** only.

2. **Harness getters are noops.** `GetVerticalScroll` / `GetVerticalScrollRange` return nil, so the handler returns before `SetVerticalScroll`. Tests correctly pin wiring (`OnMouseWheel` present, `EnableMouseWheel` type-guarded in source, fire does not error), not a moved offset.

3. **Selected pair vs a live `GetSanctioned` pair is not pinned.** The selected-wins case VOIDs first, so it only races `GetLastSanctioned`. Live code short-circuits whenever both selected ids are set, so a live pair cannot win. Worth a pin if a later console lane touches `OpenRite`.

4. **`EnableMouseWheel(true)` is source-pinned, not runtime-pinned.** Stub `EnableMouseWheel` is a noop and stores no flag. A deleted call with the type-guard string left in a comment would still go green.

5. **`find("36", 1, true)` is a substring pin.** Today it only hits the header comment and `delta * 36`. A later unrelated `136` / `360` would keep the pin green.

6. **Parchment source pin is `find("Parchment")`.** Comments already say lowercase `parchment`. A real `QuestBG` / `QuestParchment` texture would also miss that pin. Live file has neither.

7. **Nested `runB8E()` / `runB11C()`** is still the Lua 5.1 local-cap workaround. Fine as long as the next console lane nests again instead of adding locals to `runB8E()`.

8. **No full `lua tests/run.lua`.** Isolated **1175 / 0** was re-run here. That does not prove the client path.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

This is the B11-C vestment contract: type-guarded desk-body mouse wheel (36px, no `OnUpdate`), `OpenRite("Gora")` subjects from the selected pair when both ids are set else live then last sanctioned pair, Console stays plain, `SaveNote` nil, no SUMMON, no parchment, no tabs. Named risks are clean. Isolated suite is green.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
