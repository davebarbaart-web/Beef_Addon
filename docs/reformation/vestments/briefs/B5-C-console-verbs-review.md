Spec PASS

# B5-C — Console line, recommend, call-forward, zone mark (review)

**Quality:** Approved-with-nits

**Lane:** B5-C Console line, recommend, call-forward, zone mark (stock)
**Brief:** `docs/reformation/vestments/briefs/B5-C-console-verbs.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B5-C-console-verbs-report.md`
**Diff:** `docs/reformation/vestments/briefs/B5-C-console-verbs.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/Console.lua`, and `tests/test_console.lua`; then ran `lua tests/test_console.lua`. Law cited: Bible §8, §9, §10.2, §18.1; Law 10 / §19.3; CONTINUE 2026-08-18 license 4 (Director Console stays plain). Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `GetKnightingLine` copies `Knighting:GetLine()` or `{}` | **Pass.** Missing module / missing `GetLine` / non-table line → `{}`. Else a new array of shallow row copies. `name` is filled from `Store:GetHuman` when absent. Suite nils `GetLine` → empty; mutates a copy’s `.name`; next read stays `Steve`. B5-A is in the tree, so Enqueue / Skip / GetLine pin the real Core API (stub only if those methods are missing). |
| Enqueue / Skip are stock, not ritual | **Pass.** Both are `stockButton` / `UIPanelButtonTemplate`. Not pushed into `RitualButtons`. Labels `Enqueue` and `Skip`. `KNIGHT THIS BEEF` / `ELEVATE TO LORD` stay ritual plates. Methods pope-gate and call `Knighting:Enqueue` / `Skip` with `selectedHumanId`. No Sound. Suite pins template, furniture, refuse-closed, button click, and Core reach. |
| Recommend never Sanctions | **Pass.** `Console:Recommend` calls only `Gora:Recommend`. `Gora:Recommend` itself is a suggestion table (levels / named-opponent flag / H2H copy) and does not write a live pair. Success → `SelectFighters` + mute `nameA vs nameB` plus `1-0` when fighter A’s Store row has H2H. No `demanded` / `odds` / `meeting`. Pair order: selected fighters, else first named-opponent petition, else first two petitions. Suite spies `Gora.Sanction` at 0 and pins `GetSanctioned() == nil` for selected / petition / named / button paths. |
| CallForward no theater | **Pass.** `Confession:CallForward` then `Refresh`. Does not call `after()`, Toasts, `SendChatMessage`, or `playCue`. Suite stubs Sound / Toasts / chat and pins 0 on the method and the button. |
| FlagMoment uses `GetSubZoneText` when `location` is nil | **Pass.** Existing Pope gate and `Store:FlagMoment` stay. `location == nil` and `type(GetSubZoneText) == "function"` → `trimText` (empty / whitespace → nil). Explicit location is not replaced. `wow_ui_stub` does not define the API, so the older harness pin (`FlagMoment()` location nil) still holds. B5-C stubs the API and pins trim, blank → nil, and explicit win. |
| `SaveNote` nil | **Pass.** `Console.SaveNote` is nil at API scan, after B4-D, at the B5-C open, and after the B5-C block. Source has no `WHISPER ALL`. Notebook is still a label. |
| Sound `after()` pins kept | **Pass.** Ritual cues are unchanged: `knighting`, `elevation`, `sanction`, `verdict`, `cowardice`. `after()` still plays only when a cue is passed. New verbs add no cues (Enqueue / Skip / Recommend use `after` with no cue; CallForward does not use `after`). Pre-existing StartEvent / Dismiss / FlagMoment / PostDecree / EndEvent silence pins remain. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_console.lua`: **630 passed, 0 failed**, exit 0. Isolation cluster is still `if standalone then` (17 nil-module pins, including `COB.Confession == nil`). Suite does not `dofile` `Confession.lua`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Knighting / Confession / Gora / Markers / Toasts; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. |
| Console stays plain / stock; no Notebook persist; no WHISPER ALL; keep theater `after()` cues | **Pass.** New chrome is `UIPanelButtonTemplate` + `GameFontHighlightSmall` + the existing tooltip-panel `scrollList`. No parchment, QuestBG, custom media, jokes, `OnUpdate`, or `UIParent:SetScale`. Named-risk checks for SaveNote, WHISPER ALL, and Sound pins. |
| `GetKnightingLine()` returns `Knighting:GetLine()` copies if the module exists, else `{}`; paint names from Store | **Pass.** Named-risk check. |
| Stock `Line` / `Enqueue` → `Knighting:Enqueue(selectedHumanId)`; `Skip` is `stockButton`, not ritual; keep KNIGHT THIS BEEF / ELEVATE TO LORD as ritual plates | **Pass.** Named-risk check. Visible label is `Enqueue` (brief’s `Line` / `Enqueue` slash). The line itself is the stock list under the Knighting header. |
| `Recommend()` calls `Gora:Recommend` for the proposed pair (selected, else first two petitions / named opponent); success `SelectFighters`; never Sanction; mute `nameA vs nameB` plus `1-0` if H2H exists; no `demanded` / `odds` | **Pass.** Named-risk check. Named-opponent is tried before “first two petitions” when selection is empty — a legal reading of the brief’s slash. |
| `CallForward(characterId)` → `Confession:CallForward`; Refresh; no Toasts, `SendChatMessage`, or Sound | **Pass.** Named-risk check. |
| `FlagMoment`: if `location` is nil and `GetSubZoneText` is a function, pass the trimmed string (empty → nil); existing Pope gate stays | **Pass.** Named-risk check. |
| Tests: stub Knighting line APIs only when missing; Recommend does not call Sanction; CallForward does not play Sound; FlagMoment zone stub; isolation wrap stays; SaveNote still nil; `lua tests/test_console.lua` exit 0 | **Pass.** Isolation stayed gated. This review re-ran the isolated suite. |

CONTINUE license 4 (Director Console stays plain), Bible §8 (ritual Knighting plates stay; line furniture is not a ritual), §9 (CallForward marks the desk inbox only), §10.2 / §10.5 (Recommend proposes, never sanctions; mute numeric, no odds), and §18.1 (stock Director verbs) are met.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; desk grew (`DESK_H` 400, frame 700) | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. See Issues. |
| Knighting line APIs stubbed until B5-A | **Stale, not a miss.** B5-A `GetLine` / `Enqueue` / `Skip` are in this checkout. The stub is a fallback only. |
| `Confession.lua` not loaded; CallForward proven against a stub | **Not a miss.** Brief allowed a stub. Integrator still wires B4-C. Console adds no theater path. |
| Recommendation H2H reads fighter A’s Store row only | **Not a miss.** Same `h2hScore` helper as petition H2H. Brief paints `1-0` when a row exists; it did not name a reverse lookup. |
| Furniture buttons stay visually enabled for a non-Pope; clicks still refuse | **Not a miss.** Same Dismiss pattern as B4-D. Brief took Enqueue / Skip / Recommend / Call Forward off `ritual` / `applyGate`. |
| Button label is `Enqueue` (brief said `Line` / `Enqueue`) | **Not a miss.** The line is the list; the verb button is `Enqueue`. |

---

## Strengths

- Recommend is a proposal, not a Gora. It cannot write `GetSanctioned()`, and the suite proves that with a Sanction spy rather than a comment.
- CallForward is a desk mark. It skips `after()` entirely, so it cannot pick up a leftover cue, toast, or chat send.
- GetKnightingLine never hands out the live line. Names come from Store. Enqueue / Skip stay furniture beside ritual plates that still play `knighting` / `elevation`.
- FlagMoment zone-fill is opt-in on a missing argument and fail-closed when `GetSubZoneText` is absent (this harness). Empty subzone becomes nil, not `""`.
- Isolation stayed under `if standalone then`. Theater Sound pins from the earlier desk were not deleted. Isolated **630 / 0** was re-run here.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Line-name pin reads a hidden FontString.** When the line is non-empty, `paintKnightingLine` still `SetText`s `frame.KnightingList` and then `Hide`s it in favor of row buttons. The suite asserts `Steve` on `GetText()`, not on the visible row. The name is also painted on the buttons via `knightingLine`; the pin does not prove that.

2. **Confession inbox lost height.** B4-D’s 70px scroller is now 56px so Call Forward fits. Call Forward sits at −372 in a 400px desk — flush with the panel bottom. Unsmoked on Anniversary.

3. **Recommendation FontString has no width.** It is pointed at the Recommend button’s right edge. Long Store names plus `1-0` will clip in the remaining ~190px of the Gora column.

4. **`lastRecommendation` survives `EndEvent`.** `ResetForTests` clears it; a live End Event does not. A Pope who leaves the desk open after QUIET can still see the last mute pair. Desk-only; not theater.

5. **Suite header is still stale.** It still says the Pope predicate is always false and the suite does not stub a Pope list. B5-C uses the existing `Sender.IsRegisteredPope` wrap. Isolation itself stayed gated.

6. **GetKnightingLine copies are shallow `pairs`.** Mutating `.name` is pinned. Nested tables on a future line row would still alias. B5-A `GetLine` already returns flat `{ humanId, rankId, eventId, seq }` copies, so this is defensive-double, not a leak today.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **630 / 0** was re-run here. Client path was not.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

This is the B5-C vestment contract: a stock knighting line with Enqueue / Skip furniture, Recommend that never Sanctions, CallForward that never leaves the desk, FlagMoment zone-fill from `GetSubZoneText` when location is omitted, `SaveNote` still nil, theater `after()` cues kept. Named risks are clean. Nits are a hidden-FontString paint pin, a shorter confession inbox, clip, and unsmoked desk height — not trust-breakers.

Isolated `lua tests/test_console.lua` **630 passed, 0 failed**, exit 0. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
