Spec PASS

# B13-D — Console EditBox ESC ClearFocus (review)

**Quality:** Approved-with-nits

**Lane:** B13-D Console EditBox ESC ClearFocus
**Brief:** `docs/reformation/vestments/briefs/B13-D-console-esc.md`
**Writer report:** `docs/reformation/vestments/briefs/B13-D-console-esc-report.md`
**Diff:** `docs/reformation/vestments/briefs/B13-D-console-esc.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/Console.lua` (`stockEdit` / seven `InputBoxTemplate` boxes / `SaveNote` / SUMMON / parchment / tabs), and `tests/test_console.lua` (`runB13D()` nested inside `runB8E()`); then ran `lua tests/test_console.lua`. Law cited: wiki “Make frames closable with the Escape key” (focused EditBoxes swallow ESC and block `UISpecialFrames`); Bible §18.1 (Director Console stock desk); Law 10 / §19.3 (functional / stock templates); Law 6 / §19.4 (Quiet is silent; no `PlaySound`); CONTINUE 2026-08-18 license 4 (stock only; `SaveNote` stays nil; no SUMMON). Did not mutate `Console.lua` or `test_console.lua`. Did not edit Store, Gora, glue, TOC, bootstrap, or `tests/run.lua`. Did not commit. This review does not sign the lane.

---

## Named gates (must-fix)

| Gate | Verdict |
|---|---|
| `OnEscapePressed` on `stockEdit` | **Pass.** After `SetAutoFocus(false)`, `type(box.SetScript) == "function"` then `SetScript("OnEscapePressed", …)`. Handler type-guards `ClearFocus` and calls it. Missing `SetScript` / `ClearFocus` no-op. All seven stock boxes go through `stockEdit`: Stipulation, FreeRulingText, DecreeLine, DecreeFlavor, ArchiveBox, CanonizeText, HonorificText. After Init, each has `GetScript("OnEscapePressed")`. |
| Hide console from the box | **Pass.** Handler is ClearFocus only. No `Hide`, `Console:Hide`, or parent Hide. Suite pins `Console:IsShown() == true` after ArchiveBox and DecreeLine fire. Reviewer probe: fire on all seven boxes ClearFocuses each and leaves the desk shown. Close-button `Console:Hide` and `UISpecialFrames` registration of the named frame are unchanged and are not called from the box. |
| `SaveNote` defined | **Pass.** `Console.SaveNote` is nil before and after B13-D. Source has no `function Console:SaveNote` and no `Console.SaveNote =`. `GetNotes` / `CopyCeremonySummary` / `CeremonySummary` stay nil. |
| SUMMON / parchment / tabs | **Pass.** No `SUMMON THE FAITHFUL` chrome or source string. No `COPY SUMMARY` / `WHISPER ALL` / `RSVP`. Source has no `Parchment`, `PanelTabButtonTemplate`, or `PlaySound`. EditBox count stays 7. Console stays `InputBoxTemplate` / stock fonts. |
| Too many locals | **Pass.** `runB13D()` is a nested local inside `runB8E()`. No new main-chunk locals. Isolated suite ran on Lua **5.1.5** with no `too many local variables`. |
| Isolated suite not exit 0 | **Pass. Verified.** Reviewer ran `lua tests/test_console.lua`: **1286 passed, 0 failed**, exit 0. Matches the writer report. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, Gora, glue; no commit; Console stays stock | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. Live `stockEdit` site and `runB13D()` nest match that slice. Sibling dirt in this workspace is other lanes. |
| Type-guard `SetScript("OnEscapePressed")` in `stockEdit` that `ClearFocus`es; all named stock boxes inherit | **Pass.** Named-gate check. Brief names Stipulation, FreeRuling, Decree, Archive, Canonize, Honorific. Live Decree is two boxes (Line + Flavor); both inherit. |
| Do not Hide the console from the box (ClearFocus only) | **Pass.** Named-gate check. |
| Lua 5.1 200-local cap: nest new pins inside `runB8E()` / a new nested function | **Pass.** `runB13D()` inside `runB8E()`, same nest as B9-C through B12-B. |
| Tests: ArchiveBox / DecreeLine have OnEscapePressed; `stub.fire` does not error; source contains `OnEscapePressed` and `ClearFocus`; `SaveNote` nil; no SUMMON / parchment / tabs; isolation wrap stays | **Pass.** Fire is `pcall`’d and pins `fired == true` / `fireErr == nil` / `HasFocus() == false`. Source pins the script name, `ClearFocus`, type-guarded `SetScript`, `stockEdit`, and the bans. Isolation stays under `if standalone then` (file-load cluster of 17 nil-module pins; B13-D re-pins Archive + Quiet shell + Toasts). |
| `lua tests/test_console.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 1286 / 0. Writer claimed that ceiling and no more. |

Wiki ESC (focused EditBox swallows the key; ClearFocus lets `UISpecialFrames` close on a later ESC), §18.1 / Law 10 (stock desk), Law 6 (no `PlaySound`), and license 4 (`SaveNote` nil; no SUMMON; Console stays plain) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs focused EditBox vs `UISpecialFrames` close order unproven on Anniversary | **Not a spec miss.** Brief asked isolated green + ClearFocus, not a `CloseSpecialWindows` walk. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Harness `ClearFocus` is a stub flag | **Not a miss.** Brief asked `GetScript` + `stub.fire` + source `ClearFocus`. Production still calls the guarded client method. See leftover. |
| `DecreeFlavor` also inherits | **Not a miss.** Brief named Decree; both Decree boxes go through `stockEdit`. |
| Gate W stays OPEN. Gate V stays OPEN. | **Not a miss.** Overview already holds those gates open. |

---

## Strengths

- The delta is the brief: one type-guarded script on the existing `stockEdit` helper. No new chrome, no new EditBox, no Hide from the box.
- Inheritance is the helper, not seven copy-pasted handlers. Suite pins `GetScript` on all seven; fire pins ArchiveBox and DecreeLine.
- `SaveNote` stays absent. SUMMON / parchment / tabs / `PlaySound` stay absent. Isolation stayed gated. New locals sit in `runB13D()`.
- Isolated **1286 / 0** was re-run here and matches the writer report.

---

## Must-fix

None.

---

## Leftover (Minor)

1. **No `/reload` smoke.** Client ESC while an EditBox is focused still swallows the key (wiki). First ESC should unfocus; a later ESC should close via `UISpecialFrames` on `ChurchOfBeefConsole`. Same-keypress close is not claimed and is not this lane. **POLISH:CANDIDATE** only.

2. **Harness `ClearFocus` / `HasFocus` are `_focused` flags.** `stub.fire` calls the handler with the widget as `self`. Tests pin that flag and `GetScript`, not the client's keyboard walk.

3. **Five inherited boxes are GetScript-only.** Stipulation / FreeRuling / DecreeFlavor / Honorific / Canonize are not fired in the suite. Reviewer probe: each ClearFocuses and leaves the desk shown. Brief only named ArchiveBox / DecreeLine fire.

4. **Missing-API no-op is un-pinned.** `SetScript` and `ClearFocus` type-guards exist. The suite never strips those methods and re-inits.

5. **Source pins are literal.** `Parchment` is case-sensitive (`true`); live comments already say lowercase “parchment.” `function Console:SaveNote` would miss `Console.SaveNote =`. Runtime `Console.SaveNote == nil` is the real SaveNote gate.

6. **No full `lua tests/run.lua`.** Isolated **1286 / 0** was re-run here. Runner listing was not (exclusive lane; `run.lua` not edited).

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

**Must-fix:** none.

This is the B13-D contract: `stockEdit` type-guards `OnEscapePressed` → `ClearFocus`; the box does not Hide the desk; all stock boxes inherit; `SaveNote` stays nil; no SUMMON / parchment / tabs; new pins nested under `runB8E()`; isolated suite green. Named must-fix gates are clean. The nits cluster on client ESC vs harness fire, five GetScript-only inherit pins, and brittle source strings.

Isolated **1286 passed, 0 failed** verified. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
