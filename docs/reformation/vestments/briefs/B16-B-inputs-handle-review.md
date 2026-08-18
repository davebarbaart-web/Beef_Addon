Spec PASS

# B16-B — Inputs TitleBar drag handle (review)

**Quality:** Approved-with-nits

**Lane:** B16-B Inputs TitleBar drag handle
**Brief:** `docs/reformation/vestments/briefs/B16-B-inputs-handle.md`
**Writer report:** `docs/reformation/vestments/briefs/B16-B-inputs-handle-report.md`
**Diff:** `docs/reformation/vestments/briefs/B16-B-inputs-handle.diff` (exclusive-pair packet: `UI/Inputs.lua` + `tests/test_inputs.lua`)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`build` TitleBar / root `SetMovable` + `SetClampedToScreen` / `savePoint` / `restorePoint` / B14-B ESC / persist `db.inputs`), and `tests/test_inputs.lua` (`runB15A()` TitleBar persist pins, Quiet hide, ESC / `UISpecialFrames` re-pins, isolation wrap); then ran `lua tests/test_inputs.lua` (**419 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: TitleBar 12–14px drag; no root `RegisterForDrag`; HEIGHT 72; persist `ChurchOfBeefDB.ui.inputs`; ESC `ClearFocus`; not `UISpecialFrames`. Bible §13.1 / §18.5 (congregation input; inputs never trigger public theater); Law 6 / §19.1 (Event chrome; Quiet hide is Runtime); Law 10 / §19.3 (Inputs stay stock; no title string); ConsoleDock TitleBar drag persist (`addon/ChurchOfBeef/UI/ConsoleDock.lua`); CONTINUE 2026-08-18 license 4 (stock only). Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit Net, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Exclusive file breach (Net / Console / glue) | **Pass.** Provided diff is two `diff --git` hunks: `UI/Inputs.lua` and `tests/test_inputs.lua`. Live handle sites match that slice (TitleBar child; root `RegisterForDrag` / root drag scripts gone; TitleBar drop saves the root widget). Sibling dirt in this workspace is other lanes. |
| TitleBar is not a 12–14px TOPLEFT/TOPRIGHT handle | **Pass. Verified.** Live `SetHeight(12)`, `SetPoint` TOPLEFT / TOPRIGHT on the root at `0`,`0`, `EnableMouse(true)`, `RegisterForDrag("LeftButton")`. Pin: `rawget(frame, "TitleBar")` exists; height 12–14; TOPLEFT/TOPRIGHT relative the root; `OnDragStart` / `OnDragStop` on TitleBar; `GetNumRegions() == 0`. Reviewer probe: height **12**; points `TOPLEFT` / `TOPRIGHT` at `0`,`0`; no TitleBar children or regions. |
| Root still `RegisterForDrag` / still has drag scripts | **Pass. Verified.** Source: no `widget:RegisterForDrag`, no root `OnDragStart` / `OnDragStop`. Pin: root scripts nil after Init, after `dofile` restore, Quiet restore, and missing-DB rebuild. Reviewer probe: same. Root stays `SetMovable(true)` + `SetClampedToScreen(true)`. |
| Persist key drifts off `ChurchOfBeefDB.ui.inputs` | **Pass. Verified.** `savePoint` still writes `db.inputs = { point, relativePoint, x, y }`. Persist pins fire **TitleBar** `OnDragStop` (dock pattern), not root. Pin: after TitleBar drop of `TOPLEFT` / `24` / `90`, saved keys are those four and `relativeTo == nil`. Reviewer probe: saved keys exactly `point,relativePoint,x,y`; a planted `junk` / `relativeTo` is replaced on the next TitleBar drop. |
| HEIGHT grown / title string added | **Pass. Verified.** Constants still `328, 72`. Persist-path pins 328×72. Source has no `CreateFontString`, `TitleText`, or `titleBar:SetText`. Reviewer probe: source still `328, 72`; TitleBar `GetNumRegions() == 0`. |
| ESC `ClearFocus` broken; Inputs listed on `UISpecialFrames` | **Pass. Verified.** Persist-path re-pins: box ESC still `ClearFocus`s and does not Hide; `ChurchOfBeefInputs` is not listed. Source still has `SetMultiLine(true)` / `OnEscapePressed` / `ClearFocus` and no `UISpecialFrames`. Reviewer probe: wrapped `frame.Hide` saw **0** calls on ESC; `#UISpecialFrames == 0`. |
| Isolated suite not exit 0 | **Pass. Verified.** 419 passed, 0 failed. Writer-reported count matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Net, Console, glue; no commit | **Pass.** Named-risk check. |
| Thin `TitleBar` child height 12–14, TOPLEFT/TOPRIGHT, `EnableMouse`, `RegisterForDrag("LeftButton")` | **Pass.** Live height **12**. Source pins `titleBar:EnableMouse(true)` and `titleBar:RegisterForDrag("LeftButton")`. Stub `EnableMouse` / `RegisterForDrag` are silent no-ops, so runtime flags are source-pinned, not `_mouseEnabled`. |
| TitleBar `StartMoving`s the **root**; `OnDragStop` `StopMovingOrSizing`s then `savePoint`s the root | **Pass.** Handlers close on `widget`, not `titleBar`. Pin: TitleBar start sets `frame._moving`; TitleBar drop clears it and writes `ui.inputs`. |
| Remove root `RegisterForDrag` so buttons do not steal the handle | **Pass.** Named-risk check. Buttons stay `BOTTOMLEFT` / `BOTTOM` / `BOTTOMRIGHT` + 10. They do not overlap the 12px strip. |
| Root stays `SetMovable` + `SetClampedToScreen`; default still `BOTTOM` / `UIParent` / `0` / `80` | **Pass.** Persist pins `_movable` / `_clamped`. Invalid / missing DB still fall back `BOTTOM` `0`,`80`. Reviewer probe: invalid `relativePoint` and string `x` also fall back; missing `relativePoint` uses `point`. |
| Do not grow HEIGHT; do not add a title string | **Pass.** Named-risk check. |
| Persist key stays `ChurchOfBeefDB.ui.inputs`; persist pins fire TitleBar `OnDragStop` | **Pass.** Named-risk check. `dofile` + `Init` still restores `TOPLEFT` / `24` / `90` parented to `UIParent`. |
| TitleBar exists; root has no `OnDragStart` (or `RegisterForDrag` cleared) | **Pass.** Both: TitleBar exists; root scripts nil; source root `RegisterForDrag` gone. |
| Quiet hide, ESC `ClearFocus`, not on `UISpecialFrames`, isolation wrap stay | **Pass.** Named-risk check. Quiet Init with a saved point still hides and still restores. |
| WIDTH 328 HEIGHT 72; `SetMultiLine(true)` stays; no Pope-name lookup; no `PlaySound` | **Pass.** Source pins and `sounds == 0` through the persist block. No `Popes` / `IsRegisteredPope` / `SUMMON` / custom media / `OnUpdate`. |
| Isolation wrap stays; `lua tests/test_inputs.lua` exit 0 | **Pass. Verified.** **419 / 0.** Wrap is still **24** pins under the first `if standalone then`. `runB14B()` re-pins 6; `runB15A()` re-pins the same six for B15-A and again for B16-B. |

Bible §13.1 / §18.5 (injected whisper target; inputs never trigger public theater), Law 6 (Quiet chrome stays off), and Law 10 / license 4 (stock Event chrome, no title string, no custom media, no `PlaySound`) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; harness `GetPoint` / `SetPoint` is a stub | **Not a spec miss.** Brief asked isolated `tests/test_inputs.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Confess box overlaps the lower 4px of the 12px handle | **Leftover — not a miss.** Brief froze HEIGHT 72 and did not ask to move the B14-B box (`TOP` / `-8` / height 22). Exclusive grab is the top 8px plus 12px side gutters. See leftover. |
| Real `StopMovingOrSizing` may rewrite the widget point before save | **Not a miss.** Brief asked save after `StopMovingOrSizing`. Tests pin the stub: `SetPoint` then TitleBar drop stores that point. HUD / B14-C leftover. |
| `rawget(frame, "TitleBar")` avoids the stub capital-key error when absent | **On contract.** After implement, `frame.TitleBar == rawget(frame, "TitleBar")`. Reviewer probe: same. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

---

## Isolation / TitleBar / persist / ESC

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. **24** nil-module / no-slash pins under the first `if standalone then`. Wrap text is unchanged. Persist `dofile` reloads Inputs only. End-of-`runB15A` re-pins Console / Popes / Sender / Sound / Hud / slash for B15-A and again for B16-B. Reviewer probe after persist `dofile`: Console / Hud / Popes / Net / UI / DB stay nil.

**TitleBar — Pass.** Child of the root, height 12 (inside 12–14), TOPLEFT/TOPRIGHT, `EnableMouse`, `RegisterForDrag("LeftButton")`. Drag start `StartMoving`s the root. Drag stop `StopMovingOrSizing`s the root then `savePoint(widget)`. Root has no `OnDragStart` / `OnDragStop` / `RegisterForDrag`. No title string.

**Persist — Pass.** TitleBar drop, not root. Flat four-field table on `ChurchOfBeefDB.ui.inputs`, no frame. `dofile` + `Init` restores parented to `UIParent`. Invalid point / invalid relative / non-number `x` fall back to `BOTTOM` `0`,`80`. Missing global: default restore; save no-ops. `ResetForTests` still leaves SV.

**Quiet / ESC — Pass.** Saved point does not punch a Quiet hole. Box ESC still `ClearFocus`s and does not Hide. Not on `UISpecialFrames`. WIDTH / HEIGHT stay 328×72.

---

## Strengths

- B15-A leftover (root drag stolen by the three buttons) is closed on the exclusive pair: drag is a 12px TitleBar, dock persist pattern, persist key unchanged.
- B14-B ESC / `SetMultiLine(true)` / not-`UISpecialFrames` stay. No `PlaySound`, no `OnUpdate`, no custom media, no Pope lookup, no title string, HEIGHT not grown.
- Persist pins were rewritten to fire TitleBar, not left as root-script asserts that would go green for the wrong reason.
- Writer-reported **419 / 0** and **24** isolation pins matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Confess box still occludes 4px of the 12px handle in the center.** Box stays `TOP` / `-8` / height 22 / width 304. TitleBar is 12px at the top and is created first, so the later box can eat y `-8`…`-12` across the middle 304px. Exclusive grab is the top **8px** plus **12px** side gutters. Brief froze HEIGHT and did not ask to move the box. Buttons do not overlap the strip. In-game drag leftover is only partly closed. **POLISH:CANDIDATE** only.

### Minor

1. **Harness `StopMovingOrSizing` does not rewrite `GetPoint`.** The suite `SetPoint`s then fires TitleBar `OnDragStop`. Anniversary may emit a different relative / offset after the stop. HUD / B14-C leftover.

2. **TitleBar `EnableMouse` / `RegisterForDrag` are source-pinned, not runtime-pinned.** Stub both are silent no-ops (`_mouseEnabled` stays nil on root and TitleBar). Live calls exist.

3. **TitleBar offsets `0`,`0` are code-true, not suite-pinned.** Pins check point names and relative frame only. Reviewer probe: both points are `0`,`0`.

4. **B16-B isolation re-pins duplicate the B15-A six.** Same Console / Popes / Sender / Sound / Hud / slash cluster, new labels only. Wrap of **24** is unchanged.

5. **Invalid-relative and non-number `x` stay code-true, not suite-pinned.** The suite still only plants `MIDDLE-OF-NOWHERE` as `point`. Reviewer probe: invalid `relativePoint` and string `x` fall back; missing `relativePoint` uses `point`.

6. **`uiDb()` will create `ChurchOfBeefDB.ui` when the global exists without `ui`.** HUD / B15-A same. Brief no-ops only a missing global. Reviewer probe: `ChurchOfBeefDB = {}` then TitleBar drop creates `ui.inputs`.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **419 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** `lua tests/test_inputs.lua` **419 passed, 0 failed**, exit 0. Isolation wrap **24**.

TitleBar is a 12px TOPLEFT/TOPRIGHT handle that `StartMoving`s the root and writes flat `{ point, relativePoint, x, y }` to `ChurchOfBeefDB.ui.inputs` on drop. Root `RegisterForDrag` / root drag scripts are gone. Root stays `SetMovable` + `SetClampedToScreen`. Default / invalid / missing-DB still `BOTTOM` / `UIParent` / `0` / `80`. HEIGHT 72 stays. ESC still `ClearFocus` only. Not on `UISpecialFrames`. No title string. No Pope lookup. No `PlaySound`. Confess box still overlaps the lower 4px of the handle; that leftover is not a brief miss.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
