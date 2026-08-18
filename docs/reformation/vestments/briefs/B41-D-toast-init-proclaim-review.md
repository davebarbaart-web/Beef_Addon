Spec PASS

# B41-D — Toasts Init remounts ChurchOfBeefProclaim (review)

**Quality:** Approved-with-nits

**Lane:** B41-D Toasts Init remounts ChurchOfBeefProclaim
**Brief:** `docs/reformation/vestments/briefs/B41-D-toast-init-proclaim.md`
**Writer report:** `docs/reformation/vestments/briefs/B41-D-toast-init-proclaim-report.md`
**Diff:** `docs/reformation/vestments/briefs/B41-D-toast-init-proclaim.diff` (B41-D-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (`Init` existing-frame ~771–777 / first-create ~823–825 / `rememberSpecial` ~557–563 / `PROCLAIM_NAME` ~42 / `wireSmallOnHide` ~755–769 / `HideAll` ~930–943 / `hideTheater` ~567–575 / `InitTheater` / `playTheaterCue`), and `tests/test_ui.lua` (isolation wrap, nested B41-D pins inside `runB12D()` after the B39-C HideAll block and before B15-C); then ran `lua tests/test_ui.lua` (**664 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames`; B39 leftover (existing-frame Init remounted only `ChurchOfBeefToast` + `wireSmallOnHide`, so a wiped `ChurchOfBeefProclaim` stayed idle until HideAll / Proclaim); Law 6 (Quiet does not drive this file; no `PlaySound`); Law 10 / Bible §19.3 (no close button; clerical copy unchanged). Existing-frame `Init` remounts `rememberSpecial("ChurchOfBeefToast")` then `rememberSpecial(PROCLAIM_NAME)`, keeps `wireSmallOnHide`, and returns the existing frame. Dedupe is scan-then-append. Do not add a close button. Do not `PlaySound`. Do not tear theater. First-create Init is unchanged. Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit MainFrame, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Init still skips ChurchOfBeefProclaim remount | **Pass. Verified.** Live existing-frame `Init` (~771–777) is `rememberSpecial("ChurchOfBeefToast")` then `rememberSpecial(PROCLAIM_NAME)` then `wireSmallOnHide(self, self.frame)` then `return self.frame`. `PROCLAIM_NAME` is `"ChurchOfBeefProclaim"`. Nested source pin: early-return remounts toast and proclaim (`PROCLAIM_NAME` or the same string). Nested wrap: wipe list, Init lists both once; second Init still once. Reviewer probe matches; third Init still once. Bytecode: early-return upvalues are `rememberSpecial` / `PROCLAIM_NAME` / `wireSmallOnHide` — no `hideTheater`. |
| toast name remount dropped | **Pass. Verified.** Existing-frame `Init` still remounts `rememberSpecial("ChurchOfBeefToast")` before the proclaim remount. Nested pin and B23-C later wipe+Init still list toast once. Reviewer probe: wipe+Init lists toast once; first-create still lists toast once. HideAll toast remount (~941) stays. |
| PlaySound | **Pass. Verified.** Live `Toasts.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Early-return body has no `PlaySound`. Cue remains `Sound:Play(kind)` from `playTheaterCue` on Proclaim show only. Nested: `#played` unchanged across remount Init and second Init. Reviewer spy: `Sound:Play` delta **0** and `PlaySound` / `PlaySoundFile` **0** on wipe+Init, second Init, third Init, nil-list Init, and widget Hide. |
| close button added | **Pass. Verified.** Early-return body has no `CreateFrame`. File has no `CreateFrame("Button"` and no ✕. Nested: `findButton(theater.root)` and `findButton(Toasts.frame)` stay nil on remount Init. Reviewer probe: `CreateFrame` delta **0** on remounts; `findButton` stays nil on toast and theater. |
| theater torn | **Pass. Verified.** Early-return body has no `hideTheater`. Nested: Proclaim shows the root, wipe+Init keeps it shown, second Init still shown. Reviewer probe: same theater root pointer; shown stays true across wipe+Init / second Init / nil-list Init. HideAll still tears (B39-C / B18-C stay). |
| MainFrame.lua edited | **Pass.** Exclusive-pair packet is one hunk on `Toasts.lua` (`rememberSpecial(PROCLAIM_NAME)` on the existing-frame path) and `test_ui.lua` (header comment + nested B41-D pins). Packet does not touch `MainFrame.lua` or `Sound.lua`. Live MainFrame has no B41-D marks. Sibling dirt vs HEAD on MainFrame / Sound / bootstrap / TOC is other lanes. OPEN_QUESTIONS / REFORMATION_LOG / `tests/run.lua` have no B41-D marks. Reviewer did not edit MainFrame. |
| Isolated suite not exit 0 | **Pass. Verified.** **664 passed, 0 failed.** Writer-reported count matches. Pins sit after the B39-C HideAll block inside `runB12D()` (`test_ui.lua` ~871–923), before B15-C. Isolation wrap stays under the load-time standalone block (**11** nils). `runB12D()` still re-pins Console / Hud / Records Book / Gora (**4**). `luac -l -p`: main chunk **75** locals (cap 200); `runB12D()` **56** locals. Packet adds no main-chunk `local`. New asserts reuse `hideAllBody` / `savedSpecialHideAll` / `cuesHideAllRemount`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, MainFrame; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Init remounts `rememberSpecial("ChurchOfBeefToast")` (keep) and `rememberSpecial(PROCLAIM_NAME)` / `ChurchOfBeefProclaim` | **Pass.** Brief vs `Toasts.lua` ~773–774. Nested exact-body pin accepts either proclaim form. Live uses `PROCLAIM_NAME`. |
| Keep `wireSmallOnHide` | **Pass.** Live ~775. Helper still wires only when `GetScript("OnHide")` is nil. Nested source pin + B26-B later restore stay. |
| Wipe list, Init: both names re-listed once, no sound. Second Init does not duplicate | **Pass.** Nested pins + reviewer probe. |
| Do not add a close button. Do not `PlaySound`. Do not tear theater | **Pass.** Named-risk check. |
| Nest after the B39-C HideAll block inside `runB12D()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **664 / 0.** Wrap **11**. |

Wiki ESC via `UISpecialFrames` holds on the exclusive pair: a wiped list plus existing-frame Init re-lists `ChurchOfBeefToast` and `ChurchOfBeefProclaim` once. Law 6 holds: Init remount plays no sound; Quiet does not drive this file. Law 10 / Bible §19.3 hold: no close button; clerical copy unchanged; no `PlaySound`. B39-C HideAll remount stays. B18-C HideAll still tears theater once. Theater stays shown across Init.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| First-create Init still remounts only `ChurchOfBeefToast` | **On contract.** Brief scoped the existing-frame path. Reviewer probe: missing toast frame then Init lists toast once and proclaim **0**; a second Init (now existing-frame) lists proclaim once. |
| Wipe + Init remounts toast and proclaim only. `ChurchOfBeefFrame` stays missing until MainFrame remounts or the nest restores the saved list | **On contract.** Required keep — MainFrame owns that name. Reviewer probe: wipe+Init leaves `ChurchOfBeefFrame` at 0. Nest restores `savedSpecialHideAll` before B15-C. |
| Widget Hide / ESC does not remount the names. `CloseSpecialWindows` / `root:Hide()` still bypass Init | **Allowed leftover.** Brief scoped remount on existing-frame Init. Existing B12-D pin still says ESC Hide does not re-register. Reviewer probe: wipe then widget Hide leaves both at 0. |
| `UISpecialFrames = nil` still no-ops `rememberSpecial` | **On contract.** Brief asked wipe-to-empty uniqueness, not a missing table. Reviewer probe: nil-list Init leaves the table nil, plays no sound, and does not `CreateFrame`. |
| No client smoke. Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. A live remount that dropped the names is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Init` is a direct call, not a real ESC key | **On contract.** Membership counts are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B39 leftover (existing-frame Init remounted only `ChurchOfBeefToast` + `wireSmallOnHide`, so a wiped `ChurchOfBeefProclaim` stayed idle until HideAll / Proclaim) is this lane's spec. It is closed on the exclusive pair for the existing-frame `Init` path.

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Officer + Roster + DB + MainFrame + Status + Minimap + Toasts. Runtime and Sound are dofiled later for Quiet / cue pins. No `dofile` of Console, Hud, Records Book, Gora, Knighting, Net, Inputs, Confession, or glue. Load-time standalone wrap is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Wrap is load-time only (unchanged). `runB12D()` re-pins Console / Hud / Records Book / Gora. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**Remount — Pass.** Existing-frame `Init` remounts toast then proclaim, then `wireSmallOnHide`. `rememberSpecial` is scan-then-append. Nested: wipe-to-empty then Init lists each once. Reviewer probe: wipe+Init lists once; second / third Init still once; `CreateFrame` delta 0; same toast and theater pointers. First-create Init still remounts only toast. `HideAll` still remounts both after hide work.

**Keep — Pass.** B39-C HideAll remount stays. B18-C HideAll no-sound / once-tear / next-Proclaim pins stay immediately above. B12-D Proclaim ESC / UISpecialFrames pins stay. B15-C Quiet-shell `ChurchOfBeefFrame`-first pins run after the nest restores `savedSpecialHideAll`. B19-B / B20-D / B21-C / B23-C / B26-B small-toast ESC / pump / Init remount / OnHide restore pins stay later in the same nest. `wireSmallOnHide` still no-ops when a script exists. Isolation wrap stays **11**. No `PlaySound`. No close button. No `hideTheater` on Init.

---

## Strengths

- The delta is one `rememberSpecial(PROCLAIM_NAME)` on the existing-frame path. `wireSmallOnHide` stays. Init does not rebuild, does not `PlaySound`, and does not tear theater. Failed uniqueness would have to rewrite the helper.
- Wipe-to-empty remount, second-Init uniqueness, no-sound, theater-stays-shown, and no-close-button sit next to the B39-C HideAll remount, so a remount that replayed a cue or called `hideTheater` would fail.
- `runB12D()` nest is after the B39-C HideAll block and before B15-C. The wipe restores `UISpecialFrames` so `ChurchOfBeefFrame`-first stays. Isolation wrap stays **11**. No new main-chunk locals. Writer-reported **664 / 0** matched the re-run. Writer-reported red (**661 / 3**) matches the three proclaim remount pins before the one remount line.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **First-create Init still remounts only `ChurchOfBeefToast`.** Brief scoped the existing-frame path. A missing toast frame then Init will not put `ChurchOfBeefProclaim` back until HideAll / Proclaim / InitTheater / a later existing-frame Init. Reviewer probe: mint lists toast once and proclaim 0; the next Init lists proclaim once.

2. **Wipe + Init remounts toast and proclaim only.** `ChurchOfBeefFrame` stays missing until MainFrame remounts or the nest restores the saved list. Required keep — MainFrame owns that name. Do not expand this exclusive pair to remount the Quiet shell.

3. **Widget Hide / ESC does not remount the names.** `CloseSpecialWindows` / `root:Hide()` still bypass Init. Existing B12-D pin still says ESC Hide does not re-register. Reviewer probe: wipe then widget Hide leaves both at 0.

4. **Init remounts the proclaim name, not a niled proclaim OnHide.** Brief asked `rememberSpecial(PROCLAIM_NAME)` and to keep `wireSmallOnHide`. A dropped proclaim `OnHide` stays idle until `InitTheater` / `wireProclaimEsc`. Reviewer probe: niled proclaim OnHide survives Init; `InitTheater` restores it.

### Nit

1. **`hideAllBody` is reused** for the Init early-return extract after the B39-C HideAll source pins. No new `runB12D` local. HideAll source pins already ran.

2. **`UISpecialFrames = nil` still no-ops `rememberSpecial`.** Brief asked wipe-to-empty uniqueness. Reviewer probe: nil-list Init leaves the table nil.

3. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the one remount line + nested pins + header comment. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell / HideAll batches. Report already says this.

4. **Isolation wrap is load-only.** Eleven pins under the load-time standalone. `runB12D()` re-pins four.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **664 / 0** was re-run here. Live ESC vs `CloseSpecialWindows` on the shared list is unproven on Anniversary.

6. **B23-C later wipe+Init now also remounts proclaim** as an existing-frame side effect. Toast uniqueness pins still pass; proclaim stay-once pins later in the nest still pass.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Init remounts `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)` / `ChurchOfBeefProclaim`; keep `wireSmallOnHide`; wipe then Init lists both once; no sound; no close button; do not tear theater; nest after the B39-C HideAll block inside `runB12D()`; isolation wrap stays. Live `Init` ~771–777 matches. Brief test pins sit in `runB12D()` after B39-C.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: first-create Init still remounts only toast; wipe + Init does not remount `ChurchOfBeefFrame`; widget Hide / ESC still does not remount names; Init remounts the proclaim name, not a niled proclaim OnHide. Nits listed above.

**3. Isolation count:** **664 passed, 0 failed.** Isolation wrap: **11**.

**4. Law:** Wiki ESC via `UISpecialFrames` holds. After a wiped list, existing-frame Init re-lists toast and proclaim once. Law 6 holds: remount plays no sound. Law 10 / Bible §19.3 hold: no close button; clerical copy unchanged. B39-C HideAll remount stays. B18-C HideAll still tears theater once. Init does not tear theater.

**Leftovers:**
- First-create Init still remounts only `ChurchOfBeefToast` (Important, not must-fix; brief scoped existing-frame).
- Wipe + Init does not remount `ChurchOfBeefFrame` (required keep — MainFrame owns that name).
- Widget Hide / ESC does not remount the names (reviewer probe: Init-only).
- Init remounts the proclaim name, not a niled proclaim OnHide (brief scoped `rememberSpecial` + `wireSmallOnHide`).
- `hideAllBody` is reused; no new `runB12D` local.
- `UISpecialFrames = nil` still no-ops `rememberSpecial`.
- Exclusive-pair packet is not a vs-HEAD Toasts delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Init` remounts `rememberSpecial("ChurchOfBeefToast")` then `rememberSpecial(PROCLAIM_NAME)`, then `wireSmallOnHide`. Wipe then Init lists both once. Second Init does not duplicate. No `PlaySound`. No close button. Theater stays shown. First-create Init still remounts only toast. Pins sit after the B39-C HideAll block inside `runB12D()`. Isolated `lua tests/test_ui.lua` **664 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
