# V-INT — Proclaim glue (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** V-INT Proclaim glue (after V-B)
**Brief:** `docs/reformation/vestments/briefs/V-INT-proclaim.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/V-INT-proclaim-report.md`
**Diff:** `docs/reformation/vestments/briefs/V-INT-proclaim.diff` was **absent**. Reviewer read `InstallWire` wraps in `addon/ChurchOfBeef/ChurchOfBeef.lua` (`characterName` / `proclaim` / five Gora `wrapAfter`s), the Proclaim block in `tests/test_wire_glue.lua`, and the V-INT log line.
**Exclusive files:** `addon/ChurchOfBeef/ChurchOfBeef.lua` (`InstallWire` only), `tests/test_wire_glue.lua`, `docs/REFORMATION_LOG.md` (verdict only)

Task-scoped gate only. Reviewer read the brief, CONTINUE license 4 / Gate V wording, the writer report, and the InstallWire wraps once; then made one focused check per named risk. Did not mutate the working tree except this review file. Did not re-run git or the harness. Writer-reported **224 / 0** and **6920 / 0** are claims — do not treat them as verified.

This review does not sign the lane. **Gate V is not closed.**

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only. Do not edit Toasts.lua / Gora.lua / Console.lua / Store. Do not commit | **Pass** (scope-limited). Named-risk check: glue lives in bootstrap locals + `InstallWire`. Gora result shapes were read for interop only. Sibling vestment/wire files are dirty from other lanes and were not treated as this writer’s diff. No exclusive-lane `.diff` was present to prove a negative across the tree. |
| After successful (non-nil) Gora returns, call `Toasts:Proclaim` when that function exists | **Pass.** Same `wrapAfter` as the wire: `result ~= nil` then the after-fn. Missing `Toasts` or `Proclaim` returns before the call. |
| `Gora:Sanction` → kind `sanction`; names from Store; optional `stipulation` from the result | **Pass.** `characterName(result.fighterA/B)` fills `fighterA` / `fighterB` only when Store returns a non-empty name. `stipulation` is copied when the result has one. Matches V-B `clericalCopy` fields. Gora’s `copySanctioned` returns those ids + line. |
| `Gora:DeclareVictor` → `verdict`, `ruling = "victor"`, winner name | **Pass.** `fields.name` from `characterName(result.winnerId)`. Gora returns `{ ruling = "victor", winnerId }`. |
| `Gora:Void` → `verdict`, `ruling = "void"` | **Pass.** Hard-coded fields. No invented names. |
| `Gora:FreeRuling` → `verdict`, `ruling = "free"`, `text` from the result | **Pass.** Copies `result.text` when present. Gora returns `{ ruling = "free", text = line }`. |
| `Gora:CowardiceRecorded` → kind `cowardice`, fleer name | **Pass.** Named-risk / brief test: kind is clerical `cowardice`, not a verdict. `fields.name` from `characterName(result.fleerId)`. |
| Skip while `COB._inspecting` | **Pass.** `proclaim()` uses the existing `skipSend()` (`_inspecting == true`). Same flag InspectProgress already sets. |
| Missing Toasts / Proclaim → no-op; do not throw | **Pass.** Named-risk check: early return, then `pcall` around Proclaim. Suite nils `COB.Toasts` and still gets a successful Sanction. |
| Do not invent names if Store has no character — omit that field | **Pass.** `characterName` is Store `GetCharacter` only, `pcall`’d. Missing Store, failed lookup, non-table row, or empty/non-string `name` → `nil` → field omitted. No `"Fighter A"`, no `UnitName` fallback, no Pope name. |
| Do not `SendChatMessage` | **Pass.** Named-risk check: `ChurchOfBeef.lua` has no `SendChatMessage`. InspectProgress still uses `DEFAULT_CHAT_FRAME:AddMessage` (pre-existing). |
| Console `after()` may still `Sound:Play` the same cue; accept the double cue; do not edit Console or Sound | **Pass.** Console `after()` still `playCue`s `sanction` / `verdict` / `cowardice` on success. Writer did not touch Console or Sound. Double cue accepted by the brief. |
| Tests: stub Pope + `Toasts.Proclaim`; Sanction names both fighters; Cowardice is clerical; InspectProgress does not Proclaim | **Pass.** Spy records kind + fields. Sanction pins both Store names + stipulation. Cowardice pins `cowardice` + fleer. InspectProgress spy stays 0. Extra pins: victor / void / free, `_inspecting` live Sanction, refused Sanction, missing Toasts. Unwraps restore Gora / Toasts / `_wireInstalled`. Isolation cluster stays under `if standalone then`. |
| `lua tests/test_wire_glue.lua` and `lua tests/run.lua` exit 0 | **Writer claim only.** Not re-run here. |
| Do not claim Gate V or POLISH:PASS | **Pass.** Report is `DONE_WITH_CONCERNS` and leaves Gate V **OPEN**. Log line says **Do not claim Gate V or POLISH:PASS.** |

CONTINUE license 4 applies as “V-B already shipped; this lane only wires it.” Bible §10.8 verbs, Law 4 (no invented copy), and Law 6 (inspect / Quiet do not mint theater from this glue) are met on the wraps. Sanction still requires a live event, so a refused Quiet-time Sanction does not Proclaim.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Console Event-cue `after()` and `Toasts:Proclaim` may play the same §19.4 cue twice | **Not a miss.** Brief accepts the double cue and forbids Console / Sound edits. |
| `InspectProgress` still does not call Gora verbs; `_inspecting` is pinned both on InspectProgress and on a live Sanction | **Correct.** Named risk is the Proclaim skip, not a new inspect body. |
| No client `/reload` smoke | **Expected.** POLISH:CANDIDATE only. Do not claim POLISH:PASS. |
| Do not claim Gate V closed | **Honored.** |

---

## Named risks

| Risk | Verdict |
|---|---|
| InspectProgress does not Proclaim | **Clean.** Inspect body still only Sets a Decree, Shows surfaces, and `StartEvent` / `EndEvent` (plus a direct `Sound:Play`). It never calls a Gora verb. Suite: `#proclaimSpy == 0` after InspectProgress. Defense in depth: `_inspecting` also gates `proclaim()`, and a live Sanction taken with the flag set is pinned silent. |
| Missing Toasts no-ops | **Clean.** `proclaim()` returns when `Toasts` or `Toasts.Proclaim` is missing. `pcall` if the function exists. Suite nils `COB.Toasts`; Sanction still returns a pair and no error. |
| Names from Store only | **Clean.** One helper: `Store:GetCharacter(id).name`. Omit on miss. Sanction / victor / cowardice spies pin Store-created names (`Chuckroast` / `Tendermage`), not ids and not invented strings. |
| No `SendChatMessage` | **Clean.** None in `ChurchOfBeef.lua`. Glue does not add chat. |
| Toasts.lua / Gora.lua / Console.lua not edited | **Clean in this review’s scope.** Exclusive work is bootstrap + glue suite + log verdict. Those three keepers were not used as V-INT edit targets. Without the missing `.diff`, this is not a tree-wide proof. |

---

## Strengths

- Layer law holds. Core does not call UI. Theater is a bootstrap `wrapAfter` on already-successful Pope verbs, same pattern as SendState.
- Fail-closed: inspecting, missing Toasts / Proclaim, `pcall` on GetCharacter and Proclaim, `result ~= nil` so refused verbs stay silent.
- Field map matches V-B: `fighterA` / `fighterB` / `stipulation`, `ruling` + `name` / `text`, clerical `cowardice` kind. Glue does not mint sentences.
- Quiet inspect cannot leak a sanction toast: InspectProgress does not Sanction, and `_inspecting` would drop Proclaim if a verb ran anyway. A no-event Sanction refuses and does not Proclaim.
- Suite covers the brief’s three named paths plus the refuse / inspect-flag / missing-Toasts edges, and unwraps Gora so a later file is not left wrapped.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Congregation clients do not Proclaim from this glue.** Bible §10.1 wants the sanction proclamation on every installed client; congregation theater is supposed to render from Pope-originated broadcasts. The brief only named local Gora wraps. Sanction still does not `SendState` (W-INT never wrapped it). Out of this exclusive contract — leftover for Gate V / a later inbound wrap, not a spec miss.

2. **Last glue test nils `COB.Toasts` and the restore is gated on the table existing.** `origProclaim` is not put back. `test_wire_glue.lua` is last in `tests/run.lua` today, so this is not a known successor poison. The missing-Toasts pin should restore the prior table.

3. **Omit-name and “Toasts exists, Proclaim missing” are implemented, not pinned.** Sanction already requires `knownCharacter`, so the happy path always has rows. Empty-name omit and a table-without-function no-op are untested.

4. **Idempotent InstallWire is pinned on STATE, not on Proclaim.** Same `_wireInstalled` gate. A second install cannot double-wrap today.

5. **Log says `DONE`; report says `DONE_WITH_CONCERNS`.** Both correctly refuse Gate V / POLISH:PASS. Honesty nit only.

6. **Client `/reload` smoke was not run.** Pope-desk double cue (Console `after()` + Proclaim) needs a human ear. Congregation paint is not this lane.

---

## Assessment

**Spec PASS. Quality: Approved.**

The wraps do what the brief asked: after a successful Gora Sanction / DeclareVictor / Void / FreeRuling / CowardiceRecorded, bootstrap calls `Toasts:Proclaim` with Store names (or omits the field), skips while `_inspecting`, and no-ops if Toasts / Proclaim is missing. No `SendChatMessage`. No invented names. InspectProgress does not Proclaim. Console and Sound stay unedited; the double §19.4 cue is the accepted leftover.

Writer-reported isolated `tests/test_wire_glue.lua` **224 / 0** and full harness **6920 / 0** were **not** re-run here.

No Critical or Important findings. Do not block on the Minors. **Do not sign Gate V.** Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
