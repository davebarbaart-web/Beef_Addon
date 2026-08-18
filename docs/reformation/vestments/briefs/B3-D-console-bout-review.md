# B3-D — Console proposed bout + stipulation (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** B3-D Console proposed bout + stipulation (stock)
**Brief:** `docs/reformation/vestments/briefs/B3-D-console-bout.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B3-D-console-bout-report.md`
**Diff:** `docs/reformation/vestments/briefs/B3-D-console-bout.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff; then made one focused check per named risk (stock only; `Sanction` reads the stipulation box; no Net). Law cited: CONTINUE 2026-08-18 license 4 (Console stays plain); Bible §10.3 / §18.1 / §19.3 / Law 10; Batch 2 critique §A.3. Did not mutate addon code, did not re-run git or the harness, and did not treat writer counts as verified. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Stock only | **Pass.** New chrome is `GameFontNormal` / `GameFontHighlightSmall` plus `stockEdit` (`InputBoxTemplate`, `SetAutoFocus(false)`). Labels are `PROPOSED BOUT` and `STIPULATION`. Frame stays `BasicFrameTemplate`. No parchment, QuestBG, custom media, jokes, `OnUpdate`, or `UIParent:SetScale`. Desk grew with stock points (`GORA_VERB_Y`, `DESK_H` 336, frame 636). |
| Sanction reads stipulation box | **Pass.** Button calls `Console:Sanction()` with no args. `if stipulation == nil` reads `frame.Stipulation:GetText()` and forwards it. Trim stays Gora’s `trimLine`. Empty / whitespace box → Gora stores `nil`. An explicit third argument wins, including `""`. |
| No Net | **Pass.** Provided `Console.lua` has no `COB.Net`, `SendDecree`, `SendState`, `SendFavor`, or `SendAddonMessage`. `after()` is still Refresh / `playCue` / `refreshHud`. Suite stubs Net on the box-`Sanction` path and pins both counters at 0. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / Toasts / Store / Net / HUD / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. |
| Stock-pragmatic Console; no parchment; no jokes; no winner picker | **Pass.** Named-risk check. `WinnerPicker` / `PickWinner` stay nil. No fighter dropdown. `DECLARE VICTOR` still uses `selectedCharacterId`. |
| `GetProposedBout()` → `{ fighterA, fighterB, label }` or empty; `label` is `"NameA vs NameB"` from Store names when both ids are selected, else `""`; mutating the copy does not change Console | **Pass.** Fresh table each call. `isId` only. Label set only when both ids and both `characterName` results are present. Suite mutates empty and pair copies; next read is unchanged. |
| Refresh paints `frame.ProposedBout` | **Pass.** `paintProposedBout` runs from `Refresh`. Petition click already `SelectFighters` + `Refresh` when a named opponent exists. Suite pins paint and clear. |
| Proposed bout slot above SANCTION (`Name vs Name`) + one-line STIPULATION `InputBoxTemplate` | **Pass.** Headers at −144 / −164; verbs moved to `GORA_VERB_Y = 186`. Pairing is a FontString. Box is `InputBoxTemplate`, auto-focus off. |
| `Sanction()` already forwards a 3rd arg — read the box when omitted; empty box omits / nil stipulation; trim stays Gora’s | **Pass.** Named-risk check. Console does not trim. |
| Do not call Net; isolation stays under `if standalone then`; existing favor / decree / free-ruling pins stay green | **Pass.** Isolation cluster and standalone summary print are unchanged and still gated. New pins sit in the shared body. W-E favor / PostDecree / FREE RULING blocks are still in the file. EditBox count is now 4. |

CONTINUE license 4 (Director Console stays plain; stock textures/fonts only this wave), Bible §10.3 (one-line remembered stipulation, no picker), Law 10 functional desk, and Batch 2 §A.3 (pairing slot above SANCTION) are met.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload` smoke; taller Gora desk unproven on Anniversary | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. |
| Long Store names may clip; desk does not wrap | **Not a miss.** Brief named a one-line slot, not wrap. |
| Integrator still owns any wire after sanction | **Not a miss.** Brief forbade Net in this file. |

---

## Strengths

- The slot is a readout, not a second authority. `GetProposedBout` copies selected ids and Store names; `SANCTION` still writes only through `Gora:Sanction`.
- Box-read matches FREE RULING: omitted arg reads the EditBox; explicit arg wins; empty / whitespace become Gora `nil`. Trim was not reimplemented in UI.
- Layout grew the desk and frame instead of shrinking the petition scroller. Verbs stay one click. No parchment leaked onto the plain desk.
- Suite covers the brief list plus copy safety, one-id empty label, whitespace omit, explicit `""`, and Net counters. Isolation stayed gated. Winner-picker nils are pinned.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Stipulation box sits flush on SANCTION.** Box is 22px at −164; verbs start at −186. Zero gap. Unsmoked on Anniversary fonts.

2. **Pairing FontString has no width.** `paintProposedBout` sets text only. Long names clip. Writer disclosed it.

3. **Missing Store name falls back to `tostring(id)`.** `characterName` is pre-existing. Both ids selected with no Store name would label `"1 vs 2"`, not `""`. The brief’s happy path (Store names) is what the suite pins.

4. **Presence click does not load a pair.** `onPetitionClick` calls `SelectFighters` only when `namedOpponentId` is set. Brief asked for the slot and `GetProposedBout`, not a two-tap pair from Presence.

5. **Net pin counts only `SendDecree` / `SendState`.** That is what the suite named. The file has no Net references at all.

6. **Suite header is stale.** It still says the Pope predicate is always false and the suite does not stub a Pope list. The B3-D block uses the existing `Sender.IsRegisteredPope` wrap. Isolation itself stayed under `if standalone then`.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Writer-reported isolated `tests/test_console.lua` **439 / 0** was **not** re-run here. Do not treat that count as verified.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B3-D vestment contract: a stock pairing slot and one-line STIPULATION box on the Director Console; `Sanction()` reads the box when the third argument is omitted; trim and persist stay Gora’s; no parchment, no winner picker, no Net. Named risks are clean. Minors are flush packing, clip, and unsmoked desk height — not trust-breakers.

Writer-reported isolated **439 passed, 0 failed** was not re-run. Do not claim V1 / MVP complete. This review does not sign the lane.
