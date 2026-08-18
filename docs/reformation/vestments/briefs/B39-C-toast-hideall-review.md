Spec PASS

# B39-C — HideAll remounts toast and proclaim ESC names (review)

**Quality:** Approved-with-nits

**Lane:** B39-C HideAll remounts toast and proclaim ESC names
**Brief:** `docs/reformation/vestments/briefs/B39-C-toast-hideall.md`
**Writer report:** `docs/reformation/vestments/briefs/B39-C-toast-hideall-report.md`
**Diff:** `docs/reformation/vestments/briefs/B39-C-toast-hideall.diff` (B39-C-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (`HideAll` ~929–942 / `rememberSpecial` ~557–563 / `PROCLAIM_NAME` / `hideTheater` / `theaterHiding` / `bumpGen` / `ResetForTests` / `playTheaterCue` / `wireProclaimEsc` / `Init` early-return remount), and `tests/test_ui.lua` (isolation wrap, nested B39-C pins inside `runB12D()` after the B18-C HideAll block and before B15-C); then ran `lua tests/test_ui.lua` (**621 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames`; B18-C leftover (`HideAll` hid the small toast and the proclaim root without remounting `ChurchOfBeefToast` / `ChurchOfBeefProclaim`; a wiped list stayed idle until the next Proclaim / Show); Law 6 (Quiet does not drive this file; no `PlaySound`); Law 10 / Bible §19.3 (no close button; clerical copy unchanged). `HideAll` remounts `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)` after hide work. Dedupe is scan-then-append. Do not add a close button. Do not `PlaySound`. B18-C HideAll still plays no sound and still tears theater once (`hideTheater` only; no extra `bumpGen`). Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit MainFrame, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| HideAll still skips remount | **Pass. Verified.** Live `HideAll` (~929–942) is `gen + 1`, `hideTheater`, clear pending / showing, hide the small toast, then `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)`. `PROCLAIM_NAME` is `"ChurchOfBeefProclaim"`. Nested: wipe `UISpecialFrames` to `{}`, HideAll lists both names once; second HideAll still once. Reviewer probe: wipe leaves both at 0; HideAll lists each once; second HideAll still once; no-frame HideAll (theater and toast frame nil) still lists both once. Source capture: remount after `hideTheater` and `self.frame:Hide()`. HideAll upvalues include `rememberSpecial` and `PROCLAIM_NAME`. |
| PlaySound added | **Pass. Verified.** Live `Toasts.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. HideAll body has no `PlaySound`. Cue remains `Sound:Play(kind)` from `playTheaterCue` on Proclaim show only. Nested: `#played` unchanged across remount HideAll and second HideAll. Reviewer spy: `Sound:Play` delta **0** and `PlaySound` **0** on wipe+HideAll, second HideAll, nil-table HideAll, and ResetForTests remount. HideAll upvalues are `gen` / `hideTheater` / `clearPending` / `stopMotion` / `resetAnchor` / `rememberSpecial` / `PROCLAIM_NAME` — no `playTheaterCue`. |
| close button added | **Pass. Verified.** HideAll body has no `CreateFrame`. File has no `CreateFrame("Button"` and no ✕. Nested: `findButton(theater.root)` stays nil on remount HideAll. Reviewer probe: `CreateFrame` delta **0** on remounts; `findButton` stays nil; no-frame HideAll still does not mint a button. |
| B18-C sound/theater tear broken | **Pass. Verified.** HideAll body still has `hideTheater` and does not contain `bumpGen`. `hideTheater` still sets `theaterHiding`, increments `theaterGen` once, `root:Hide()`, then clears the flag. B18-C pins stay immediately above this block: HideAll hides the root, `#played` unchanged, leftover flush then next Proclaim accepted and shown, proclaim listed once, no close button. Nested remount HideAll: theater stays torn, no sound. Reviewer spy: one HideAll `theaterGen` +1; second HideAll +1 more; next Proclaim after remount HideAll is accepted and shown. OnHide still re-enters `hideTheater` and returns on `theaterHiding` (wrapper sees 2 entries, `theaterGen` +1). |
| MainFrame.lua edited | **Pass.** Exclusive-pair packet is two hunks on `Toasts.lua` (the two `rememberSpecial` lines after hide work) and `test_ui.lua` (header comment + nested B39-C pins). Packet does not touch `MainFrame.lua` or `Sound.lua`. Sibling dirt vs HEAD on MainFrame / Sound is other lanes. OPEN_QUESTIONS / REFORMATION_LOG / bootstrap / `tests/run.lua` have no B39-C marks. Reviewer did not edit MainFrame. |
| Isolated suite not exit 0 | **Pass. Verified.** **621 passed, 0 failed.** Writer-reported count matches. Pins sit after the B18-C HideAll block inside `runB12D()` (`test_ui.lua` ~830–867), before B15-C. Isolation wrap stays under the load-time standalone block (**11** nils). `runB12D()` still re-pins Console / Hud / Records Book / Gora (**4**). `luac -l -p`: main chunk **75** locals (cap 200; same as B35-D). Packet adds no main-chunk `local`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, MainFrame, Sound; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| HideAll remounts `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)` (or the same string `ChurchOfBeefProclaim`) | **Pass.** Brief vs `Toasts.lua` ~940–941. Nested exact-body pin accepts either form. Live uses `PROCLAIM_NAME`. |
| Remount after tearing theater and hiding the small toast | **Pass.** Live order is hide work, then the two remounts. Reviewer capture: toast remount after `hideTheater` / `frame:Hide()`; proclaim remount after toast remount. |
| Wipe list, HideAll: both names re-listed once, no sound. Second HideAll does not duplicate | **Pass.** Nested pins + reviewer probe. |
| Do not add a close button. Do not `PlaySound` | **Pass.** Named-risk check. |
| B18-C HideAll still plays no sound and still tears theater once | **Pass.** Named-risk check. |
| Nest after the B18-C HideAll block inside `runB12D()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **621 / 0.** Wrap **11**. |

Wiki ESC via `UISpecialFrames` holds on the exclusive pair: a wiped list plus HideAll re-lists `ChurchOfBeefToast` and `ChurchOfBeefProclaim` once. Law 6 holds: HideAll remount plays no sound; Quiet does not drive this file. Law 10 / Bible §19.3 hold: no close button; clerical copy unchanged; no `PlaySound`. B18-C stay: HideAll still has no `bumpGen`, still calls `hideTheater` once per dismiss (`theaterGen` +1), still plays no sound, and the next Proclaim still shows.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke. Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. A live remount that dropped the names is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `HideAll` is a direct call, not a real ESC key | **On contract.** Membership counts are pinned; the client's special-frame walk is not. |
| `ResetForTests` now remounts both names as a HideAll side effect. Frames need not exist for the name remount | **On contract.** Brief scoped `HideAll`. Reviewer probe: ResetForTests after wipe lists both once; no-frame HideAll still lists both. |
| `UISpecialFrames = nil` still no-ops `rememberSpecial` | **On contract.** Brief asked wipe-to-empty uniqueness, not a missing table. Reviewer probe: nil-list HideAll leaves the table nil, plays no sound, and does not `CreateFrame`. |
| Widget Hide / ESC does not remount `rememberSpecial`. `CloseSpecialWindows` / `root:Hide()` bypass `HideAll` | **Allowed leftover.** Brief scoped remount on `HideAll`. Existing B12-D pin still says ESC Hide does not re-register. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B18 leftover (`HideAll` hid the small toast and the proclaim root without remounting `ChurchOfBeefToast` / `ChurchOfBeefProclaim`; a wiped list stayed idle until the next Proclaim / Show) is this lane's spec. It is closed on the exclusive pair.

---

## Isolation / remount / stay paths

**Isolation wrap — Pass.** Load list is still Common + Ranks + Officer + Roster + DB + MainFrame + Status + Minimap + Toasts. Runtime and Sound are dofiled later for Quiet / cue pins. No `dofile` of Console, Hud, Records Book, Gora, Knighting, Net, Inputs, Confession, or glue. Load-time standalone wrap is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Wrap is load-time only (unchanged). `runB12D()` re-pins Console / Hud / Records Book / Gora. Writer's "first `if standalone then`" is the helper block; the wrap is the later load-time standalone. Count is still 11. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**Remount — Pass.** `HideAll` remounts both names after hide work. `rememberSpecial` is scan-then-append. Nested: wipe-to-empty then HideAll lists each once. Reviewer probe: wipe+HideAll lists once; second HideAll still once; no-frame HideAll still lists both; `CreateFrame` delta 0. `ResetForTests` remounts as a HideAll side effect.

**Uniqueness — Pass.** `rememberSpecial` still returns when the name is already listed. B18-C HideAll-keep-once and B12-D InitTheater / second Proclaim / ESC Hide once-pins stay above this block. Nested second HideAll stays once. Reviewer probe: third path (keep-shell HideAll with `ChurchOfBeefFrame` already first) remounts toast + proclaim once and leaves Inputs at 0.

**Stay paths — Pass.** B18-C HideAll no-sound / once-tear / next-Proclaim pins stay immediately above. B12-D Proclaim ESC / UISpecialFrames pins stay. B15-C Quiet-shell `ChurchOfBeefFrame`-first pins run after the nest restores `savedSpecialHideAll`. B19-B / B20-D / B21-C / B23-C / B26-B small-toast ESC / pump / Init remount pins stay later in the same nest. Isolation wrap stays **11**.

---

## Strengths

- The remount is two `rememberSpecial` calls after existing hide work. HideAll does not rebuild, does not `PlaySound`, and does not grow a close button. Failed uniqueness would have to rewrite the helper.
- Wipe-to-empty remount, second-HideAll uniqueness, no-sound, theater-torn, and no-close-button sit next to the B18-C once-tear pins, so a remount that replayed a cue or double-called `bumpGen` would fail.
- `runB12D()` nest is after the B18-C HideAll block and before B15-C. The wipe restores `UISpecialFrames` so `ChurchOfBeefFrame`-first stays. Isolation wrap stays **11**. No new main-chunk locals. Writer-reported **621 / 0** matched the re-run. Writer-reported red (**615 / 6**) matches the wipe remount + uniqueness pins before the two `rememberSpecial` lines.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Wipe + HideAll remounts toast and proclaim only.** `ChurchOfBeefFrame` stays missing until MainFrame remounts or the nest restores the saved list. Brief scoped those two names. Do not expand this exclusive pair to remount the Quiet shell.

2. **Widget Hide / ESC does not remount the names.** `CloseSpecialWindows` / `root:Hide()` still bypass `HideAll`. Existing B12-D pin still says ESC Hide does not re-register. Reviewer probe is HideAll-only.

3. **Next Proclaim after remount HideAll is not an in-lane behavioral pin.** B18-C already pins next Proclaim before the wipe. Reviewer probe: remount HideAll then Proclaim is accepted and shown, counts stay 1.

### Nit

1. **`UISpecialFrames = nil` still no-ops `rememberSpecial`.** Brief asked wipe-to-empty uniqueness. Reviewer probe: nil-list HideAll leaves the table nil.

2. **`ResetForTests` remounts both names** as a HideAll side effect. Harness-only. Frames need not exist.

3. **OnHide still re-enters `hideTheater`.** `theaterHiding` keeps `theaterGen` +1 per HideAll (B18-C stay). Wrapper sees 2 entries; not a double-tear.

4. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the two remount lines + nested pins + header comment. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell batches. Report already says this.

5. **Isolation wrap is load-only.** Eleven pins under the load-time standalone. Writer's "first `if standalone then`" is the helper block. Nested `runB12D()` re-pins four of them.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **621 / 0** was re-run here. Live ESC vs `CloseSpecialWindows` on the shared list is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: HideAll remounts `ChurchOfBeefToast` and `ChurchOfBeefProclaim` after hide work; wipe then HideAll lists both once; no sound; no close button; B18-C still tears theater once and plays no sound; nest after the B18-C HideAll block inside `runB12D()`; isolation wrap stays. Live `HideAll` ~940–941 matches. Brief test pins sit in `runB12D()` after B18-C.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: wipe + HideAll does not remount `ChurchOfBeefFrame`; widget Hide / ESC still does not remount names; next Proclaim after remount HideAll is not an in-lane pin (reviewer probe closed it). Nits listed above.

**3. Isolation count:** **621 passed, 0 failed.** Isolation wrap: **11**.

**4. Law:** Wiki ESC via `UISpecialFrames` holds. After a wiped list, HideAll re-lists toast and proclaim once. Law 6 holds: remount plays no sound. Law 10 / Bible §19.3 hold: no close button; clerical copy unchanged. B18-C stay: no `bumpGen`, `hideTheater` once per dismiss, next Proclaim still shows.

**Leftovers:**
- Wipe + HideAll does not remount `ChurchOfBeefFrame` (Important, not must-fix; required keep — MainFrame owns that name).
- Widget Hide / ESC does not remount the names (reviewer probe: HideAll-only).
- Next Proclaim after remount HideAll is not an in-lane pin (reviewer probe: it still shows).
- `UISpecialFrames = nil` still no-ops `rememberSpecial`.
- `ResetForTests` remounts as a HideAll side effect.
- OnHide still re-enters `hideTheater`; `theaterGen` +1 (B18-C stay).
- Exclusive-pair packet is not a vs-HEAD Toasts delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

`HideAll` remounts `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)` after hide work. Wipe then HideAll lists both once. Second HideAll does not duplicate. No `PlaySound`. No close button. B18-C HideAll still plays no sound and still tears theater once. Pins sit after the B18-C HideAll block inside `runB12D()`. Isolated `lua tests/test_ui.lua` **621 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
