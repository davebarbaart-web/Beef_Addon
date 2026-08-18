Spec PASS

# B14-B — Inputs confess box ESC ClearFocus (review)

**Quality:** Approved-with-nits

**Lane:** B14-B Inputs confess box ESC ClearFocus
**Brief:** `docs/reformation/vestments/briefs/B14-B-inputs-esc.md`
**Writer report:** `docs/reformation/vestments/briefs/B14-B-inputs-esc-report.md`
**Diff:** `docs/reformation/vestments/briefs/B14-B-inputs-esc.diff` (exclusive-pair packet: `UI/Inputs.lua` + `tests/test_inputs.lua`)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/Inputs.lua` (`build()` confess box after `SetAutoFocus(false)`), and `tests/test_inputs.lua` (`runB14B()` plus the existing Quiet / Event / isolation pins); then ran `lua tests/test_inputs.lua` (**294 passed, 0 failed**, exit 0, Lua 5.1.5) and a throwaway probe that does not live in the exclusive files. Law cited: wiki “Make frames closable with the Escape key” (focused EditBoxes swallow ESC via `OnEscapePressed`; the wiki’s parent-`Hide` example is the thing this lane forbids); Bible §13.1 / §18.5 (congregation input; whisper target injected); Law 6 / §19.1 (Event chrome; Quiet hide is Runtime); Law 10 / §19.3 (Inputs stay stock); Anniversary `SimpleEditBoxAPI` (`ClearFocus()`, `SetMultiLine([multiline])` on classic_anniversary). Isolation wow_ui_stub + Common + Runtime + Inputs. Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit Net, Console, glue, TOC, bootstrap, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `OnEscapePressed` Hides the Inputs panel | **Pass. Verified.** After `SetAutoFocus(false)`, `type(box.SetScript) == "function"` then `SetScript("OnEscapePressed", …)`. Handler type-guards `ClearFocus` and calls it. No `Hide`, `Inputs:Hide`, `paintHidden`, or `GetParent():Hide` in the handler. Pin: `stub.fire` does not error; `HasFocus() == false`; `frame:IsShown()` stays true; `GetView().shown` stays true. Reviewer probe: wrapped `frame.Hide` saw **0** calls on ESC; shown/view stayed true; focus cleared. |
| Inputs registered on `UISpecialFrames` | **Pass.** Source has no `UISpecialFrames` / `tinsert`. Pin: name `ChurchOfBeefInputs` is not listed. Probe: `#UISpecialFrames == 0`. Hide stays Runtime Quiet, not ESC dismiss of Event chrome. |
| `SetMultiLine` unguarded or geometry grown | **Pass.** `type(box.SetMultiLine) == "function"` then `SetMultiLine(true)` immediately after create / `SetAutoFocus(false)`. WIDTH 328, HEIGHT 72, box height 22, `_autoFocus == false` pinned in `runB14B()`. Probe: 328 / 72 / 22 / autofocus false. |
| Pope-name lookup / SUMMON / `PlaySound` / custom media | **Pass.** Source has no `UISpecialFrames`, `SUMMON`, `PlaySound`, `.tga` / `.blp` / `.ttf`, `Popes`, `IsRegisteredPope`. Whisper stays `SetInputTarget`. Stock `InputBoxTemplate` / `UIPanelButtonTemplate`. Event chrome only (`MODE = "Event"`). |
| Quiet hide broken | **Pass.** `paintHidden` still runs from Quiet Init / Quiet Show / `readyToSend` / Catchup / Refresh / `EndEvent`. Existing Quiet pins stay. Probe: after Event ESC, `EndEvent` then `Refresh` hides the widget (`Hide` count 1) and `GetView().shown == false`. |
| Isolated suite not exit 0 | **Pass. Verified.** 294 passed, 0 failed. Writer-reported count matches. |
| Exclusive file / isolation breach | **Pass.** Provided diff is two `diff --git` hunks. Load list is still wow_ui_stub + Common + Runtime + Inputs. Isolation wrap stays under `if standalone then` (24 original nil-module pins; `runB14B()` re-pins Console / Popes / Sender / Sound / Hud / slash). Sibling dirt in this workspace is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Net, Console, glue; no commit; Inputs stay stock Event chrome | **Pass.** Named-risk check. No SUMMON. No custom media. |
| Type-guard `SetScript("OnEscapePressed")` on the confess box that `ClearFocus`es only; do not Hide the panel from the box | **Pass.** Named-risk check. Missing `SetScript` / `ClearFocus` no-op. |
| Type-guard `SetMultiLine(true)` after creating the box; keep WIDTH / HEIGHT 72 / box height 22 | **Pass.** Named-risk check. `SetAutoFocus(false)` stays. |
| Do not register Inputs on `UISpecialFrames` | **Pass.** Named-risk check. |
| No Pope-name lookup; whisper target stays `SetInputTarget`; Quiet hide unchanged | **Pass.** Named-risk check. |
| After Init in Event: `editBox()` has `OnEscapePressed`; `stub.fire` does not error; `HasFocus()` false; frame / `GetView().shown` stay true | **Pass.** Nested in `runB14B()` (Lua 5.1 200-local cap). Fire is `pcall`’d. Confess `GetText` after ESC still sends. |
| Source contains `OnEscapePressed`, `ClearFocus`, `SetMultiLine`; source does not contain `UISpecialFrames`, Pope lookup, `SUMMON`, `PlaySound`, custom `.tga/.blp/.ttf` | **Pass.** Main-chunk pins plus `runB14B()` re-pins, including type-guard literals. |
| Isolation wrap stays; `lua tests/test_inputs.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** **294 / 0.** Writer claimed that ceiling and no more. |

Wiki ESC (focused EditBox swallows the key; this lane ClearFocuses instead of the wiki’s parent-`Hide` sample), §13.1 / §18.5 (injected target, no Pope lookup), Law 6 (Quiet hide is Runtime, not ESC), Law 10 (stock Event chrome), and Anniversary `SimpleEditBoxAPI` (`ClearFocus` and `SetMultiLine` exist on classic_anniversary / 20506) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs focused `InputBoxTemplate` on Anniversary unproven | **Not a spec miss.** Brief asked isolated green + `GetScript` / `stub.fire` / source pins. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Harness `ClearFocus` is a stub `_focused` flag | **Not a miss.** Brief asked `HasFocus()` after fire. Production still calls the guarded client method. See leftover. |
| `SetMultiLine(true)` on a 22px box is unsmoked; wrapped text may clip | **On contract.** Brief forbids growing HEIGHT or the box. Geometry pins stay. See leftover. |
| Missing `SetScript` fail-closed leaves the default EditBox ESC swallow with no `ClearFocus` | **On contract.** Brief: missing methods skip, no throw. |
| Gate W stays OPEN. Gate V stays OPEN. | **Not a miss.** Batch 14 overview already holds those gates open. |

---

## Isolation / ESC / Quiet hide

**Isolation wrap — Pass.** `dofile` list is Common + Runtime + Inputs. No Console / Popes / Sound / Hud / slash. End-of-`runB14B` re-pins stay gated. Suite `PlaySound` spy is a test global; production source has none.

**ESC — Pass.** Confess box only. Handler ClearFocuses when the API exists. Panel stays shown. Not on `UISpecialFrames`. Probe Hide count on the ESC path is 0.

**Quiet hide — Pass.** Event ESC does not change hide ownership. `paintHidden` still follows Runtime QUIET. Probe after `EndEvent` + `Refresh`: hidden.

---

## Strengths

- The delta is the brief: two type-guards on the existing confess box. No new chrome, no `UISpecialFrames`, no Pope lookup, no sound.
- The wiki parent-`Hide` example was not copied. Hide sites remain `paintHidden` / create-time `widget:Hide()` / `Inputs:Hide` / harness reset.
- Geometry and `SetAutoFocus(false)` were re-pinned, not assumed. Confess `GetText` still works after unfocus.
- New locals sit in `runB14B()` so Lua 5.1’s 200-local cap does not fire. Isolation stayed gated. Isolated **294 / 0** was re-run here and matches the writer report.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`SetMultiLine(true)` on a 22px `InputBoxTemplate` is unsmoked and may clip wrapped confession text.** Brief forbids growing HEIGHT or the box, so this lane cannot fix layout. Later geometry work owns clipping. **POLISH:CANDIDATE** only.

### Nit

1. **No `/reload` smoke.** Client ESC while the confess box is focused still swallows the key (wiki). First ESC should unfocus; a later ESC must not dismiss Event Inputs because the panel is not on `UISpecialFrames`. Same-keypress close is not claimed and is not this lane.

2. **Harness `ClearFocus` / `HasFocus` are `_focused` flags.** `stub.fire` calls the handler with the widget as `self`. Tests pin that flag and `GetScript`, not the client’s keyboard walk.

3. **`SetMultiLine(true)` is source-pinned, not behavior-pinned.** Stub `SetMultiLine` is a generic noop (`IsMultiLine()` returns nil). Exclusive files cannot extend `wow_ui_stub.lua`. Production still type-guards the Anniversary method.

4. **Missing-API no-op is un-pinned.** `SetScript` / `ClearFocus` / `SetMultiLine` type-guards exist. The suite never strips those methods and re-inits.

5. **`pcall` around `stub.fire` does not check `fire`’s boolean.** A missing script still yields `pcall` success (`fired == true`, `fireErr == nil`). `GetScript ~= nil` and `HasFocus() == false` cover the miss. Duplicate source pins in the main chunk and `runB14B()` are redundant, not wrong.

6. **No full `lua tests/run.lua`.** Isolated **294 / 0** was re-run here. Runner listing was not (exclusive lane; `run.lua` not edited).

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** 294 passed, 0 failed.

Confess box type-guards `SetMultiLine(true)` and `OnEscapePressed` → `ClearFocus` only. The box does not Hide the Inputs panel. Inputs are not on `UISpecialFrames`. No Pope-name lookup, SUMMON, `PlaySound`, or custom media. WIDTH 328 / HEIGHT 72 / box 22 stay. Quiet hide is still Runtime. Isolation wrap stays. Isolated `lua tests/test_inputs.lua` **294 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
