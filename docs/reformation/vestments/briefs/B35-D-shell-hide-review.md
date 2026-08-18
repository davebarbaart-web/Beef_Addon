Spec PASS

# B35-D — Quiet-shell Hide remounts OnHide + persist (review)

**Quality:** Approved-with-nits

**Lane:** B35-D Quiet-shell Hide remounts OnHide + persist
**Brief:** `docs/reformation/vestments/briefs/B35-D-shell-hide.md`
**Writer report:** `docs/reformation/vestments/briefs/B35-D-shell-hide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B35-D-shell-hide.diff` (B35-D-only exclusive-pair packet; live `MainFrame.lua` / `test_ui.lua` also carry earlier Quiet-shell / toast / HideAll / B15-C / B19-B / B20-D / B21-C / B23-C / B24-C / B26-B / B27-C / B29-D / B31-C batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/MainFrame.lua` (`UI:Hide` exists-path: `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self:_StopSizing()` then `self.frame:Hide()`; `wireShellOnHide` wires only when `GetScript("OnHide")` is nil; Show remount is still the same pair before `frame:Show()`; Init early-return is still `rememberSpecial` then `wireShellOnHide`; create path still wires after OnShow; handler is still `UI:_StopSizing()` then `ui.shown = false`; `FRAME_NAME` is `"ChurchOfBeefFrame"`; Hide body does not write `shown`), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C / B19-B / B20-D / B21-C / B23-C / B26-B toast pins, B24-C / B27-C Init remount + nil-OnHide restore, B29-D Proclaim font pins, B31-C Show remount + Show-restored Hide `_StopSizing` / `shown = false`, then nested B35-D source + Show-so-transition + wipe remount + nil-OnHide Hide restore + persist + third-Hide identity + Inputs-off pins; isolation wrap stays); then ran `lua tests/test_ui.lua` (**607 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: B31-C leftover (`UI:Hide` skipped a niled OnHide; `shown` stayed true and Init `wasShown` reopened the shell); wiki ESC via `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); when the frame exists, `Hide` remounts `wireShellOnHide` + `rememberSpecial(FRAME_NAME)` (same pair as Show) before `_StopSizing` + `frame:Hide()`; never replace an existing OnHide; no OnShow re-wire; no rebuild; no `PlaySound`; persist `shown = false`; `FRAME_NAME` stays `ChurchOfBeefFrame`; Inputs stay off `UISpecialFrames`; nest after B31-C inside `runB12D()`; Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`). Did not mutate `MainFrame.lua` or `test_ui.lua`. Did not commit. Did not edit Toasts, RecordsBook, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Hide` still skips a missing OnHide when the frame exists (B31 leftover) | **Pass. Verified.** Live exists-path is `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self:_StopSizing()` then `self.frame:Hide()`. Helper wires only when `GetScript("OnHide")` is nil. Pins: Show (real transition), wipe, `SetScript("OnHide", nil)`, `shown = true`, `UI:Hide()` restores a script and persists `shown == false`. Reviewer probe: niled script on a shown frame, Hide, `GetScript` is a function; wrapped `SetScript` saw **1** call named `OnHide`; `shown` is false and `_sizing` is false. |
| `Hide` replaces an existing script | **Pass. Verified.** Helper is `if existing then return`. Pins: third Hide after restore keeps `restoredHideOnHide`. Reviewer spy: wrapped `SetScript` saw **0** calls on Hide with the create-path script, a sentinel OnHide, and third Hide. Sentinel identity stayed. Create-path identity stayed. |
| Restore rebuilds or duplicates `ChurchOfBeefFrame` | **Pass. Verified.** Exists-path still uses `self.frame`. Pins: niled Hide / third Hide keep `existingHideShell`; wipe+Hide lists the name once; third Hide still once. Reviewer probe: `CreateFrame` delta **0** on remounts; wipe+nil+Hide lists once; third Hide still once. |
| Restored handler is not the create OnHide (`_StopSizing` / `shown = false` / `PlaySound`) | **Pass.** Create, Init early-return, Show, and Hide all call `wireShellOnHide`. Live handler is still `UI:_StopSizing()` then `ui.shown = false`. Hide body does not write `shown` (ESC persist stays the helper). File has no `PlaySound`. Pins: Hide remount persists `shown == false`. Reviewer probe: same persist after restore; `_sizing` is false. |
| Show / Init remount dropped; Hide re-wires OnShow | **Pass. Verified.** Live `Init` early-return is still `rememberSpecial(FRAME_NAME)` then `wireShellOnHide(self.frame)` then `return self.frame`. Show is still `wireShellOnHide` then `rememberSpecial` then `frame:Show()`. Hide body has no `OnShow` / inline `SetScript`. Pins: B31-C Show remount / B27-C Init remount stay above this block; Hide remount keeps `GetScript("OnShow")` identity. Reviewer spy: restore `SetScript` name is OnHide only; a niled OnShow stays nil after Hide; niled OnHide, Init / Show, still restore. |
| Wipe uniqueness / B31-C Show / B27-C Init / B26-B toast pins drop | **Pass. Verified.** B31-C wipe-to-`{}` + Show once / nil-OnHide restore / Show-restored Hide persist stay immediately above. B27-C wipe-to-`{}` + Init once / nil-OnHide restore stay in the same nest. B26-B nil-OnHide restore + pump / idle-return pins stay above this block. Suite green includes those asserts. Reviewer probe: Init and Show remount still restore; `Toasts.lua` was not edited this lane. |
| `PlaySound` / `IG_CHARACTER_INFO_*` / panel whoosh | **Pass.** Live `MainFrame.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Template stays `BasicFrameTemplate`. Suite pins `#played` unchanged on Hide remount; Quiet-shell source still has no `PlaySound`. Reviewer spy: `PlaySound` count stays 0 across remounts. |
| Inputs land on `UISpecialFrames` | **Pass.** Hide only `rememberSpecial(FRAME_NAME)`. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. Pin: `countSpecial("ChurchOfBeefInputs") == 0` after remount. Live `Inputs.lua` still has no `UISpecialFrames` / `rememberSpecial`. Isolation suite does not load Inputs. |
| Isolated suite not exit 0 / pins not after B31-C in `runB12D()` | **Pass. Verified.** 607 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()` immediately after the B31-C Show-restored persist pins. Isolation wrap stays under the load-time standalone block. `luac -l -p`: main chunk **75** locals (cap 200; same as B31-C). Packet adds no main-chunk `local`. |
| Exclusive file breach (Toasts.lua / RecordsBook / Decree / glue) | **Pass.** Lane implementation is the two named files. Packet is two unified hunks (exists-path `Hide` calls; header comment + nested B35-D pins). Sibling dirt in this workspace is other lanes (Toasts, Decree, RecordsBook, TOC, bootstrap, `run.lua`). OPEN_QUESTIONS / REFORMATION_LOG have no B35-D marks. Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit RecordsBook, Toasts source behavior beyond the shared suite, glue; no commit | **Pass.** Named-risk check. `tests/test_ui.lua` still *reads* Toasts.lua for prior B12-D / B26-B / B29-D pins; the writer did not edit `Toasts.lua`. |
| Existing-frame `Hide` remounts `wireShellOnHide` + `rememberSpecial(FRAME_NAME)` (same pair as Show) before `_StopSizing` + `frame:Hide()` | **Pass.** Live order is `wireShellOnHide` then `rememberSpecial` then `_StopSizing` then `frame:Hide()`. Source pin in `runB12D()` requires the helpers before `frame:Hide()` and still `_StopSizing`. Reviewer capture is wire < remember < `_StopSizing` < `frame:Hide`. |
| Never replace an existing OnHide | **Pass.** Named-risk check. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Persist `shown = false` | **Pass.** Remounted OnHide writes it on a shown→hidden transition. Hide body does not write `shown`. Pins + reviewer probe. |
| `FRAME_NAME` stays `"ChurchOfBeefFrame"`; Inputs stay off `UISpecialFrames` | **Pass.** Named-risk check. |
| Wipe `UISpecialFrames`, nil OnHide, set `shown = true`, `UI:Hide()`: OnHide restored, `shown == false`, `ChurchOfBeefFrame` re-listed once, no sound, no rebuild. Third Hide does not duplicate | **Pass.** Named-risk check. Suite Shows first so Hide is a real transition (stub / client fire OnHide only then). |
| Nest after the B31-C block inside `runB12D()`; isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **607 / 0.** |

B31 leftover (a remount that dropped the handler left `UI:Hide` without persist; Init `wasShown` reopened the shell) is closed on `UI:Hide` when Hide is a real shown→hidden transition. Law 6 (Quiet silent; no panel whoosh), Law 10 (stock `BasicFrameTemplate`), wiki ESC via `UISpecialFrames`, B31-C Show remount, B27-C Init remount, and B26-B toast restore hold on the exclusive pair.

### Law check

| Law | Verdict |
|---|---|
| Law 6 / §19.4 — Quiet is silent; no panel whoosh | **Pass.** Hide remount has no `PlaySound` / `IG_CHARACTER_INFO_*` / `SOUNDKIT`. Suite `#played` is unchanged. |
| Law 10 / Bible §19.3 — functional Quiet shell stays stock | **Pass.** Template stays `BasicFrameTemplate`. No custom media / whoosh on Hide. |
| Wiki ESC — named frame on `UISpecialFrames`; `wireShellOnHide` is the only writer of `ui.shown = false` on ESC | **Pass.** Hide remounts `rememberSpecial(FRAME_NAME)` and `wireShellOnHide`. Hide body does not write `shown`. ESC still depends on the remounted handler, not on `UI:Hide` being the closer. |
| Inputs stay off `UISpecialFrames` | **Pass.** Hide does not list `ChurchOfBeefInputs`. |

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Early-return still does not restore a missing OnShow | **On contract.** Brief forbids OnShow re-wire. Reviewer probe: niled OnShow stays nil after Hide. |
| Already-hidden Hide remounts the script but leaves `shown` true until a later real hide | **On contract leftover.** Brief persist is via remounted OnHide. Stub (and the client) only fire OnHide on a shown→hidden transition. Suite Shows first. Reviewer probe confirms the leftover. |
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + restore a niled OnHide + persist + third-Hide identity. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity + uniqueness + persist. The client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / restore / uniqueness

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). Reviewer probe: those keys are nil at load. `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net / Inputs. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire. Writer's "first `if standalone then`" is the helper block; the wrap is the later load-time standalone. Count is still 11.

**Restore — Pass.** Exists-path `Hide` calls `wireShellOnHide` then `rememberSpecial` (no inline `SetScript`), then `_StopSizing`, then `frame:Hide()`. The helper no-ops when a script exists and writes `_StopSizing` + `shown = false` only when OnHide is nil. Show / Init remounts are unchanged. Reviewer spy: restore `SetScript` delta 1 named OnHide; existing / sentinel / third Hide delta 0. `CreateFrame` delta 0 on remounts. A niled OnShow is not restored. Hide body does not write `shown`.

**Uniqueness — Pass.** `rememberSpecial` still returns when the name is already listed. Wipe-to-empty then Hide lists the name once. Third Hide stays once. B15-C first-create / forced-rebuild once-pins, B27-C wipe+Init once-pins, and B31-C wipe+Show once-pins stay. Reviewer probe: wipe+nil+Hide also lists once; `UISpecialFrames = nil` then Hide still restores OnHide and leaves the table nil; assigning `{}` then Hide lists once. `ChurchOfBeefInputs` stays 0.

---

## Strengths

- The delta is the brief: two calls on the `Hide` exists-path, same pair as Show, then the existing `_StopSizing` + `frame:Hide()`. An existing script is not replaced. The widget is not rebuilt. Show / Init remounts stay. `FRAME_NAME` stays `"ChurchOfBeefFrame"`.
- B31 leftover (niled OnHide stayed nil across Hide; `shown` stayed true and Init `wasShown` reopened the shell) is closed with a runtime restore on a real hide transition, not only a source `find`. Persist is proven after remount, so a no-op restore would fail. Hide body does not write `shown`, so the persist pin actually exercises the remounted handler.
- Wipe uniqueness, third-Hide identity, Inputs-off, and no-rebuild sit next to the restore pins, so a rebuild or a replace-every-Hide helper would fail. Combined wipe+nil+Hide is pinned here.
- B31-C Show / B27-C Init / B26-B toast / isolation pins were left in the same `runB12D()` nest. Isolation stayed gated. New locals are inside `runB12D()`. `Toasts.lua` / RecordsBook / Decree were not edited.
- Writer-reported **607 / 0** matched the re-run. Writer-reported red (**599 / 8**) matches the exists-path-missing-helper + niled-stayed-nil + wipe-left-unlisted + Hide-without-handler-left-`shown` cluster that pre-B35-D Hide would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Already-hidden Hide remounts the script but leaves stale `shown`.** Reviewer probe: Show, Hide (widget already hidden), nil OnHide, `shown = true`, `UI:Hide()` restores the handler and `_StopSizing`s in the body, but `ChurchOfBeefDB.ui.shown` stays `true` because OnHide does not fire. Init `wasShown` would still reopen after that sequence. Brief persist assumes a shown→hidden transition; the suite Shows first. Glue that only Hide()s an already-hidden niled script would still drop persist until a later real hide.

2. **Hide still does not restore a missing OnShow.** Reviewer probe: niled OnShow stays nil after Hide. Brief forbids OnShow re-wire on this path. A remount that dropped OnShow would skip `shown = true` and the roster kick. Outside this brief.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the Quiet shell, Proclaim, and the small toast together. Brief asked isolated restore + persist + identity, not a client walk.

### Nit

1. **Third-Hide identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that. The suite calls Hide twice after nil (restore + keep); "third Hide" is inherited language.

2. **Source pin does not lock remount before `_StopSizing`.** It requires the helpers before `frame:Hide()` and that `_StopSizing` is present. Live order is wire then remember then `_StopSizing` then Hide (brief law). A swap of remount and `_StopSizing` would still pass the pin.

3. **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then` (not the first helper `if standalone then`). `runB12D()` re-pins four. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD MainFrame delta.** Packet is the B35-D-only exists-path calls + nested pins. `git diff HEAD` on the two files still includes earlier Quiet-shell / toast / HideAll / B15-C / B19-B / B20-D / B21-C / B23-C / B24-C / B26-B / B27-C / B29-D / B31-C batches. Report already says this.

5. **`UISpecialFrames = nil` and stub `_G["ChurchOfBeefFrame"]` stay unpinned.** `rememberSpecial` no-ops when the global is not a table. Stub `CreateFrame` still does not mint `_G.ChurchOfBeefFrame`. Brief asked wipe uniqueness and a niled OnHide restore, not those edges. Reviewer probe: nil-list Hide still restores OnHide and leaves the table nil. Harness `Hide()` is still not ESC.

6. **Inputs-off pin does not load Inputs.** Isolation never `dofile`s `Inputs.lua`. The pin still fails if Hide listed `"ChurchOfBeefInputs"`. Live Inputs file has no special-frame register.

7. **No full `lua tests/run.lua`.** Isolated **607 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **607 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**. Main-chunk locals: **75 / 200**.

`UI:Hide` on an existing frame calls `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` before `_StopSizing` + `self.frame:Hide()`. A missing OnHide gets the same `_StopSizing` + `shown = false` handler as create / Init / Show. An existing script is not replaced. The frame is not rebuilt. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. No `PlaySound`. Inputs stay off the list. Pins live in `runB12D()` after B31-C. Isolated `lua tests/test_ui.lua` **607 passed, 0 failed**, exit 0.

### Leftovers

- Already-hidden Hide remounts OnHide but leaves stale `shown` until a later real hide.
- Hide / Show / Init still do not restore a missing OnShow.
- No Anniversary ESC / `CloseSpecialWindows` smoke; harness `Hide()` is not a real ESC key.
- Isolated suite only (full `tests/run.lua` not run).
- Exclusive-pair diff is the B35-D-only delta, not vs HEAD.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W / Gate V / POLISH:PASS.
