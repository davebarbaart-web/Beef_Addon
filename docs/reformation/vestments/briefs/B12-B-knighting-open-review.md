Spec PASS

# B12-B — Open Knighting line fallback (review)

**Quality:** Approved-with-nits

**Lane:** B12-B Open Knighting line fallback (stock)
**Brief:** `docs/reformation/vestments/briefs/B12-B-knighting-open.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B12-B-knighting-open-report.md`
**Diff:** `docs/reformation/vestments/briefs/B12-B-knighting-open.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/Console.lua` (`OpenRite("Knighting")` / `OpenRite("Gora")` / `SaveNote` / SUMMON / tab / parchment), and `tests/test_console.lua` (`runB12B()` nested inside `runB8E()`); then ran `lua tests/test_console.lua`. Law cited: Bible §18.1 (glanceable Director Console); Law 10 / §19.3 (Director Console stays stock-pragmatic); Bible §20.2 (Open Rite is a Pope console action; broadcast carries active subjects); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain). Did not mutate addon code. Did not edit Knighting, Runtime, or glue. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `SaveNote` defined | **Pass.** No `function Console:SaveNote`. No `SaveNote =`. `Console.SaveNote` / `GetNotes` / `CopyCeremonySummary` / `CeremonySummary` stay nil. Source pin and runtime pin both green. |
| SUMMON / parchment / tabs | **Pass.** Source has no `SUMMON THE FAITHFUL`, `CopyCeremonySummary`, `Parchment`, or `PanelTabButtonTemplate`. No SUMMON / COPY SUMMARY / WHISPER ALL / RSVP chrome. Frame stays `BasicFrameTemplate` + stock list/button templates. Comments still say the desk is not parchment (lowercase). |
| Selected human ignored | **Pass.** `OpenRite("Knighting")` pins `candidate = self.selectedHumanId` first. Fallback runs only `if not isId(candidate)`. Pope-predicate wrap: `SelectHuman(pickHuman)` wins over a different `GetLine()[1]` head. |
| `GetLine` head unused when no selection | **Pass.** Missing / non-id selection reads `COB.Knighting:GetLine()` when that method exists, then `line[1].humanId` when that is an id. Pope-predicate wrap: `Enqueue` with no `SelectHuman` → Runtime `subjects.candidate` is that id. Snapshot matches. |
| Gora fallback broken | **Pass.** `elseif kind == "Gora"` is untouched: selected pair when both ids, else `GetSanctioned()` then `GetLastSanctioned()`. B11-C pins still run in this suite (live pair, selected wins, last-pair-only). Confession / Proclamation still leave `subjects = nil`. |
| Too many locals | **Pass.** New Console locals sit inside `OpenRite`, not the main chunk. New test pins live in `runB12B()` nested inside `runB8E()`. Isolated suite loaded on Lua 5.1.5 with no `too many local variables`. |
| Suite not exit 0 | **Pass.** Reviewer ran `lua tests/test_console.lua` on Lua **5.1.5**: **1232 passed, 0 failed**, exit 0. Matches the writer report. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Knighting, Runtime, glue; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. Live `OpenRite("Knighting")` and `runB12B()` match that slice. Knighting / Runtime / TOC / `ChurchOfBeef.lua` are dirty from other exclusive lanes, not this packet. |
| Console stays stock; `SaveNote` stays nil; no SUMMON | **Pass.** Named-risk check. No new chrome. |
| `OpenRite("Knighting")` uses `selectedHumanId` when that is an id; else `Knighting:GetLine()[1].humanId` when that is an id; selected still wins | **Pass.** Named-risk check. Type-guarded: missing Knighting / `GetLine` / non-table line / non-table head / non-id `humanId` leave subjects empty (today’s empty-subjects open). |
| Gora fallback from B11-C stays; other rites unchanged | **Pass.** Named-risk check. Only `Knighting` and `Gora` write subjects. |
| Nest new pins (`runB8E()` / nested function); isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** Nested `runB12B()`. Isolation cluster is still `if standalone then` (17 nil-module pins at file load). B12-B re-pins Archive + Quiet shell + Toasts. Isolated **1232 / 0**. |

Bible §18.1 (glanceable stock desk), Law 10 / §19.3 (Director Console stays plain), §20.2 (Open Rite is a Pope verb; subjects travel on the event), and CONTINUE (no SUMMON; no post-show clipboard; `SaveNote` nil) are met.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload` | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Empty line / missing `GetLine` still opens Knighting with empty subjects | **Not a miss.** Brief asked fallback when the head is an id. Missing / empty / non-id head is today’s empty-subjects open, not a new refuse. |
| Fallback reads `Knighting:GetLine()`, not `Console:GetKnightingLine()` | **Not a miss.** Brief named `Knighting:GetLine()` `rows[1].humanId`. Store name paint is display-only. Same `humanId` when the row is an id. |
| B12-A ASSEMBLY Restore is a different lane | **Not a miss.** This packet only fills OpenRite subjects on the Pope console. |
| Gate W / Gate V stay OPEN | **Not a miss.** Overview forbids signing polish or claiming those gates closed. |

---

## Strengths

- Fallback is ordered and gated: selected id → `GetLine` head id → empty subjects. It does not invent a candidate and does not open Knighting from the painted desk copy.
- Selected human still wins when that human is **not** on the line. That is stronger than “selected beats a different head” and matches “selected human still wins.”
- Gora’s live-then-last pair path was left as `elseif`. Other rite kinds were not opened as a place to invent subjects.
- `SaveNote` is still absent. There is no SUMMON chrome, no parchment, no tabs, no second clipboard.
- Isolation stayed gated. New asserts sit in `runB12B()` so Lua 5.1’s 200-local cap does not fire. Isolated **1232 / 0** was re-run here and matches the writer report.

---

## Must-fix

None.

---

## Leftover (Minor)

1. **No `/reload` smoke.** Line-head fallback is a Pope console verb against live `Knighting:GetLine()`. Harness cannot prove the desk click. **POLISH:CANDIDATE** only.

2. **Empty line / missing `GetLine` / non-id head are unpinned.** Live code leaves `subjects` nil. Worth a pin if a later console lane touches `OpenRite`.

3. **Confession / Proclamation subjects are unpinned in B12-B.** Live `OpenRite` still only writes subjects for Knighting and Gora. A later `elseif` would not fail this nest.

4. **Two-person line is unpinned.** Head is `line[1]` after `GetLine`’s seq sort. One Enqueue is enough for the brief; a second body would only document “head, not the whole line.”

5. **Parchment source pin is `find("Parchment")`.** Comments already say lowercase `parchment`. A real `QuestBG` / `QuestParchment` texture would also miss that pin. Live file has neither.

6. **Nested `runB8E()` / `runB12B()`** is still the Lua 5.1 local-cap workaround. Fine as long as the next console lane nests again instead of adding locals to `runB8E()`.

7. **No full `lua tests/run.lua`.** Isolated **1232 / 0** was re-run here. That does not prove the client path.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

This is the B12-B vestment contract: `OpenRite("Knighting")` subjects from `selectedHumanId` when that is an id, else the head of `Knighting:GetLine()` when that `humanId` is an id; Gora fallback stays; Console stays plain; `SaveNote` nil; no SUMMON; no parchment; no tabs. Named risks are clean. Isolated suite is green.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
