Spec PASS

# B31-C — Quiet shell Show remounts a missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B31-C Quiet shell Show remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B31-C-shell-show-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B31-C-shell-show-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B31-C-shell-show-onhide.diff` (B31-C-only exclusive-pair packet; live `MainFrame.lua` / `test_ui.lua` also carry earlier Quiet-shell / toast / HideAll / B15-C / B19-B / B20-D / B21-C / B23-C / B24-C / B26-B / B27-C / B29-D batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/MainFrame.lua` (`UI:Show` exists-path: `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self.frame:Show()` then `OnStatusChanged`; `wireShellOnHide` wires only when `GetScript("OnHide")` is nil; Init early-return still `rememberSpecial` then `wireShellOnHide`; create path still wires after OnShow; handler is still `UI:_StopSizing()` then `ui.shown = false`; `FRAME_NAME` is `"ChurchOfBeefFrame"`), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C / B19-B / B20-D / B21-C / B23-C / B26-B toast pins, B24-C / B27-C Init remount + nil-OnHide restore, B29-D Proclaim font pins, then nested B31-C source + wipe remount + nil-OnHide Show restore + third-Show identity + restored Hide `_StopSizing` / `shown = false` pins; isolation wrap stays); then ran `lua tests/test_ui.lua` (**582 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: B27 leftover (`UI:Show` skipped a niled OnHide; ESC Hide then skips `_StopSizing` / `ui.shown = false`); wiki ESC via `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); when the frame exists, `Show` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before Show; do not replace an existing script; do not rebuild; Init remount stays; `FRAME_NAME` is `"ChurchOfBeefFrame"`; nest `runB12D()`; B27-C Init / B26-B toast / B29-D Proclaim font pins stay; no `PlaySound`; Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`). Did not mutate `MainFrame.lua` or `test_ui.lua`. Did not commit. Did not edit Toasts, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Show` still skips a missing OnHide when the frame exists (B27 leftover) | **Pass. Verified.** Live exists-path is `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self.frame:Show()`. Helper wires only when `GetScript("OnHide")` is nil. Pins: `SetScript("OnHide", nil)`, Show restores a script; restored Hide persists `shown = false` and `_sizing = false`. Reviewer probe: niled script, Show, `GetScript` is a function; wrapped `SetScript` saw **1** call named `OnHide`. |
| `Show` replaces an existing script | **Pass. Verified.** Helper is `if existing then return`. Pins: third Show after restore keeps `restoredShowOnHide`. Reviewer spy: wrapped `SetScript` saw **0** calls on Show with the create-path script, a sentinel OnHide, and third Show. Sentinel identity stayed. |
| Restore rebuilds or duplicates `ChurchOfBeefFrame` | **Pass. Verified.** Exists-path still uses `self.frame`. Pins: niled Show / third Show keep `existingShowShell`; wipe+Show lists the name once; third Show still once. Reviewer probe: `CreateFrame` delta **0** on remounts; wipe+nil+Show lists once; third Show still once. |
| Restored handler is not the create OnHide (`_StopSizing` / `shown = false` / `PlaySound`) | **Pass.** Create, Init early-return, and Show all call `wireShellOnHide`. Live handler is still `UI:_StopSizing()` then `ui.shown = false`. File has no `PlaySound`. Pins: Show-restored Hide persists `shown = false` and `_sizing = false`. Reviewer probe: same pair after restore. |
| Init remount dropped; Show re-wires OnShow | **Pass. Verified.** Live `Init` early-return is still `rememberSpecial(FRAME_NAME)` then `wireShellOnHide(self.frame)` then `return self.frame`. Create path still wires after OnShow. Show body has no `OnShow` / inline `SetScript`. Pins: B27-C Init remount / third-Init identity stay above this block; Show remount keeps `GetScript("OnShow")` identity. Reviewer spy: restore `SetScript` name is OnHide only; a niled OnShow stays nil after Show; niled OnHide, Init, still restores. |
| Wipe uniqueness / B27-C Init / B26-B toast / B29-D Proclaim pins drop | **Pass. Verified.** B27-C wipe-to-`{}` + Init once / nil-OnHide restore stay in the same nest. B26-B nil-OnHide restore + pump / idle-return pins stay above this block. B29-D `applyHeadlineFont` on Proclaim / InitTheater stays immediately above. Suite green includes those asserts. Reviewer probe: Init remount still restores; `Toasts.lua` was not edited this lane. |
| `PlaySound` / `IG_CHARACTER_INFO_*` / panel whoosh | **Pass.** Live `MainFrame.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Template stays `BasicFrameTemplate`. Suite pins `#played` unchanged on Show remount; Quiet-shell source still has no `PlaySound`. Reviewer spy: `PlaySound` count stays 0 across remounts. |
| Isolated suite not exit 0 / pins not in `runB12D()` | **Pass. Verified.** 582 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()`. Isolation wrap stays under the load-time standalone block. `luac -l -p`: main chunk **75** locals (cap 200; same as B27-C). Packet adds no main-chunk `local`. |
| Exclusive file breach (Toasts.lua / Decree / glue) | **Pass.** Lane implementation is the two named files. Packet is two unified hunks (exists-path `Show` calls; header comment + nested B31-C pins). `Toasts.lua` has no B31-C marks. Sibling dirt in this workspace is other lanes (Toasts, Decree, TOC, bootstrap, `run.lua`). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Decree, glue; no commit | **Pass.** Named-risk check. `tests/test_ui.lua` still *reads* Toasts.lua for prior B12-D / B26-B / B29-D pins; the writer did not edit `Toasts.lua`. |
| When the frame exists, `Show` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before Show | **Pass.** Live order. Source pin in `runB12D()`. Reviewer capture is `wireShellOnHide(self.frame)`, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Show()`. |
| Do not replace an existing script; do not rebuild | **Pass.** Named-risk check. |
| Init remount stays | **Pass.** Named-risk check. |
| Nil the OnHide, Show: script restored. Third Show with the script already set: identity stays | **Pass.** Named-risk check. |
| Existing B27-C Init / B26-B toast / B29-D Proclaim font pins stay | **Pass.** Named-risk check. |
| `FRAME_NAME` is `"ChurchOfBeefFrame"`; no `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Nest pins in `runB12D()`; isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **582 / 0.** |

B27 leftover (a remount that dropped the handler left ESC Hide stuck sizing / `shown` true on the Show exists-path) is closed on `UI:Show`. Law 6 (Quiet silent; no panel whoosh), Law 10 (stock `BasicFrameTemplate`), wiki ESC via `UISpecialFrames`, B27-C Init remount, B26-B toast restore, and B29-D Proclaim font hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `Hide` still does not restore a missing OnHide | **On contract.** Brief scoped Show. Reviewer probe: niled OnHide stays nil across `UI:Hide()`; wipe then Hide leaves the name unlisted. Show / Init restore. |
| Early-return / Show still do not restore a missing OnShow | **On contract.** Brief forbids replacing an existing script and pins Show against OnShow re-wire. Reviewer probe: niled OnShow stays nil after Show. |
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + restore a niled OnHide + third-Show identity. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity + uniqueness. `_StopSizing` / `shown = false` + register are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / restore / uniqueness

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). Reviewer probe: those keys are nil at load. `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**Restore — Pass.** Exists-path `Show` calls `wireShellOnHide` then `rememberSpecial` (no inline `SetScript`), then `frame:Show()`. The helper no-ops when a script exists and writes `_StopSizing` + `shown = false` only when OnHide is nil. Init remount is unchanged. Reviewer spy: restore `SetScript` delta 1 named OnHide; existing / sentinel / third Show delta 0. `CreateFrame` delta 0 on remounts. A niled OnShow is not restored. `Hide()` still does not remount.

**Uniqueness — Pass.** `rememberSpecial` still returns when the name is already listed. Wipe-to-empty then Show lists the name once. Third Show stays once. B15-C first-create / forced-rebuild once-pins and B27-C wipe+Init once-pins stay. Reviewer probe: wipe+nil+Show also lists once; `UISpecialFrames = nil` then Show still restores OnHide and leaves the table nil; assigning `{}` then Show lists once.

---

## Strengths

- The delta is the brief: two calls on the `Show` exists-path. An existing script is not replaced. The widget is not rebuilt. Init remount stays. `FRAME_NAME` stays `"ChurchOfBeefFrame"`.
- B27 leftover (niled OnHide stayed nil across Show; Hide then skipped `_StopSizing` / `shown = false`) is closed with a runtime restore, not only a source `find`. The restored handler is then proven to stop sizing and persist `shown = false`, so a no-op restore would fail.
- Wipe uniqueness, third-Show identity, and `CreateFrame` 0 sit next to the restore pins, so a rebuild or a replace-every-Show helper would fail. Combined wipe+nil+Show is pinned here (stronger than the B27-C restore, which put `savedSpecial` back first).
- B27-C Init / B26-B toast / B29-D Proclaim / isolation pins were left in the same `runB12D()` nest. Isolation stayed gated. New locals are inside `runB12D()`. `Toasts.lua` was not edited.
- Writer-reported **582 / 0** matched the re-run. Writer-reported red (**573 / 9**) matches the exists-path-missing-helper + niled-stayed-nil + wipe-left-unlisted + Hide-without-handler-left-`shown`/`_sizing` cluster that pre-B31-C Show would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Hide` still skips a missing OnHide.** Reviewer probe: niled script stays nil across `UI:Hide()`; wipe then Hide leaves `ChurchOfBeefFrame` unlisted. Show / Init restore. Brief scoped Show. Glue that only Hide()s a niled script would still drop ESC persist / lastView until the next Show / Init.

2. **Handler-less Hide before remount still leaves stale `shown` / `_sizing`.** Reviewer probe: Show, nil OnHide, `Hide()`, widget is hidden, but `ChurchOfBeefDB.ui.shown` stays `true` and `UI._sizing` stays `true`. Next Show remounts the script; a later Hide clears both. Brief scoped restore of the missing script, not a shown-repair of the lost Hide. The suite nils then Show then Hide, so Hide-before-restore is unpinned.

3. **Show still does not restore a missing OnShow.** Reviewer probe: niled OnShow stays nil after Show. Brief forbids OnShow re-wire on this path. A remount that dropped OnShow would skip `shown = true` and the roster kick. Outside this brief.

4. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the Quiet shell, Proclaim, and the small toast together. Brief asked isolated restore + identity, not a client walk.

### Nit

1. **Third-Show identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that. The suite calls Show twice after nil (restore + keep); "third Show" is inherited language.

2. **Show helper order is the reverse of Init.** Init early-return is `rememberSpecial` then `wireShellOnHide`. Show is `wireShellOnHide` then `rememberSpecial`. Brief listed both before Show and did not lock the pair order. Both run before `frame:Show()`.

3. **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then`. `runB12D()` re-pins four. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD MainFrame delta.** Packet is the B31-C-only exists-path calls + nested pins. `git diff HEAD` on the two files still includes earlier Quiet-shell / toast / HideAll / B15-C / B19-B / B20-D / B21-C / B23-C / B24-C / B26-B / B27-C / B29-D batches. Report already says this.

5. **`UISpecialFrames = nil` and stub `_G["ChurchOfBeefFrame"]` stay unpinned.** `rememberSpecial` no-ops when the global is not a table. Stub `CreateFrame` still does not mint `_G.ChurchOfBeefFrame`. Brief asked wipe uniqueness and a niled OnHide restore, not those edges. Reviewer probe: nil-list Show still restores OnHide and leaves the table nil. Harness `Hide()` is still not ESC.

6. **No full `lua tests/run.lua`.** Isolated **582 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **582 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**. Main-chunk locals: **75 / 200**.

`UI:Show` on an existing frame calls `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` before `self.frame:Show()`. A missing OnHide gets the same `_StopSizing` + `shown = false` handler as create / Init. An existing script is not replaced. The frame is not rebuilt. Init remount stays. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. No `PlaySound`. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **582 passed, 0 failed**, exit 0.

### Leftovers

- `Hide` still does not remount a niled OnHide or re-list `ChurchOfBeefFrame`.
- Handler-less Hide can leave stale `shown` / `_sizing` until a later Hide.
- Show / Init still do not restore a missing OnShow.
- No Anniversary ESC / `CloseSpecialWindows` smoke; harness `Hide()` is not a real ESC key.
- Isolated suite only (full `tests/run.lua` not run).
- Exclusive-pair diff is the B31-C-only delta, not vs HEAD.

Do not claim V1 / MVP complete. This review does not sign the lane.
