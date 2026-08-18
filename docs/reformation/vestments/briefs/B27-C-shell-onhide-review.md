Spec PASS

# B27-C — Quiet shell Init restores a missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B27-C Quiet shell Init restores a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B27-C-shell-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B27-C-shell-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B27-C-shell-onhide.diff` (B27-C-only exclusive-pair packet; live `MainFrame.lua` / `test_ui.lua` also carry earlier Quiet-shell / toast / HideAll / B15-C / B19-B / B20-D / B21-C / B23-C / B24-C / B26-B batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/MainFrame.lua` (`UI:Init` early-return: `rememberSpecial(FRAME_NAME)` then `wireShellOnHide(self.frame)` then `return self.frame`; `wireShellOnHide` wires only when `GetScript("OnHide")` is nil; create path calls the same helper after OnShow; handler is still `UI:_StopSizing()` then `ui.shown = false`), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C / B19-B / B20-D / B21-C / B23-C / B26-B toast pins, then nested B24-C / B27-C source + wipe remount + nil-OnHide restore + third-Init identity + restored Hide `_StopSizing` / `shown = false` pins; wipe uniqueness / isolation wrap stay); then ran `lua tests/test_ui.lua` (**548 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: B26 leftover (`UI:Init` early-return `rememberSpecial`s but never restores a missing OnHide; ESC Hide then skips `_StopSizing` / `ui.shown = false`); wiki ESC via `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); Init early-return `rememberSpecial` then wire the **same** OnHide as create if OnHide is nil; do not replace an existing script; do not re-wire OnShow; do not rebuild; nest `runB12D()`; uniqueness once; B24-C rememberSpecial / B26-B toast pins stay; no `PlaySound`; Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`). Did not mutate `MainFrame.lua` or `test_ui.lua`. Did not commit. Did not edit Toasts, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Init` early-return still skips a missing OnHide (B26 leftover) | **Pass. Verified.** Live early-return is `rememberSpecial(FRAME_NAME)` then `wireShellOnHide(self.frame)` then `return self.frame`. Helper wires only when `GetScript("OnHide")` is nil. Pins: `SetScript("OnHide", nil)`, second Init restores a script; restored Hide persists `shown = false` and `_sizing = false`. Reviewer probe: niled script, Init, `GetScript` is a function; wrapped `SetScript` saw **1** call. |
| Early-return replaces an existing script | **Pass. Verified.** Helper is `if existing then return`. Pins: wipe remount keeps the create-path identity; third Init after restore keeps `restoredShellOnHide`. Reviewer spy: wrapped `SetScript` saw **0** calls on second Init (script already set), a sentinel OnHide, and third Init. Sentinel identity stayed. |
| Restore rebuilds or duplicates `ChurchOfBeefFrame` | **Pass. Verified.** Early-return still returns `self.frame`. Pins: niled Init returns `existingShell`; third Init does not rebuild; restore uniqueness stays 1. B24-C wipe-to-`{}` + second Init once-pins stay. Reviewer probe: `CreateFrame` delta **0** on remounts; wipe+nil+Init lists the name once; third Init still once. |
| Restored handler is not the create OnHide (`_StopSizing` / `shown = false` / `PlaySound`) | **Pass.** Create and early-return both call `wireShellOnHide`. Live handler is still `UI:_StopSizing()` then `ui.shown = false`. File has no `PlaySound`. Pins: restored Hide persists `shown = false` and `_sizing = false`. Reviewer probe: same pair after restore. |
| Early-return re-wires OnShow | **Pass. Verified.** Early-return body has no `OnShow` / inline `SetScript`. Helper body has no `OnShow`. Pins: `GetScript("OnShow")` identity stays across wipe remount and restore Init. Reviewer spy: restore `SetScript` name is OnHide only; a niled OnShow stays nil after Init. |
| Wipe uniqueness / B24-C rememberSpecial / B26-B toast pins drop | **Pass. Verified.** B24-C wipe-to-`{}` + second Init once / third Init once stay in the same nest. B15-C first-create / forced-rebuild uniqueness pins stay. B26-B nil-OnHide restore + pump / idle-return pins stay above this block. Suite green includes those asserts. Reviewer probe: `Toasts:Init` keeps the small-toast OnHide identity; `ChurchOfBeefToast` stays listed once. |
| `PlaySound` / `IG_CHARACTER_INFO_*` / panel whoosh | **Pass.** Live `MainFrame.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Template stays `BasicFrameTemplate`. Suite pins `#played` unchanged on restore Init; Quiet-shell source still has no `PlaySound`. Reviewer spy: `PlaySound` count stays 0 across remounts. |
| Isolated suite not exit 0 / pins not in `runB12D()` | **Pass. Verified.** 548 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()`. Isolation wrap stays under the load-time standalone block. `luac -l -p`: main chunk **75** locals (cap 200). Packet adds no main-chunk `local`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two unified hunks (extract `wireShellOnHide` + early-return / create calls; header comment + B24-C pin update + nested B27-C pins). Sibling dirt in this workspace is other lanes (Toasts, Decree, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Decree, glue; no commit | **Pass.** Named-risk check. |
| `Init` early-return `rememberSpecial`s, then wires the same OnHide as create if OnHide is nil | **Pass.** Live order. Source pin in `runB12D()`. Reviewer capture is `rememberSpecial(FRAME_NAME)`, then `wireShellOnHide(self.frame)`, then `return self.frame`. |
| Do not replace an existing script; do not re-wire OnShow; do not rebuild | **Pass.** Named-risk check. |
| Nil the shell OnHide, second Init: script is restored; third Init identity stays | **Pass.** Named-risk check. |
| Wipe `UISpecialFrames` uniqueness / B24-C rememberSpecial / B26-B toast pins stay | **Pass.** Named-risk check. B24-C early-return pin now allows `wireShellOnHide` (brief license); still no inline `SetScript` / OnShow re-wire / rebuild. |
| Nest pins in `runB12D()`; no new main-chunk locals | **Pass.** B27-C locals (`wireShell`, `cuesShellRestore`, `restoredShellOnHide`) sit inside `runB12D()`. Header comment only in the main chunk. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **548 / 0.** |

B26 leftover (a remount that dropped the handler left ESC Hide stuck sizing / `shown` true) is closed on the early-return path. Law 6 (Quiet silent; no panel whoosh), Law 10 (stock `BasicFrameTemplate`), wiki ESC via `UISpecialFrames`, B24-C uniqueness, and B26-B toast restore hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Early-return still does not restore a missing OnShow | **On contract.** Brief forbids re-wiring OnShow. Reviewer probe: niled OnShow stays nil after Init. |
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + restore a niled OnHide + third-Init identity + uniqueness stays. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity + uniqueness. `_StopSizing` / `shown = false` + register are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / restore / uniqueness

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). Reviewer probe: those keys are nil at load. `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**Restore — Pass.** `if self.frame then` still `rememberSpecial`s, then `wireShellOnHide` (no inline `SetScript`), then returns the existing frame. The helper no-ops when a script exists and writes `_StopSizing` + `shown = false` only when OnHide is nil. Create path calls the same helper after OnShow. Reviewer spy: restore `SetScript` delta 1; existing / sentinel / third Init delta 0. `CreateFrame` delta 0 on remounts. A niled OnShow is not restored.

**Uniqueness — Pass.** `rememberSpecial` still returns when the name is already listed. B24-C wipe-to-empty then Init lists the name once. Third Init stays once. B15-C first-create / forced-rebuild once-pins stay. Restore Init (list already populated) stays 1. Reviewer probe: wipe+nil+Init also lists once.

---

## Strengths

- The delta is the brief: extract the create-path OnHide into `wireShellOnHide` and call it from early-return. An existing script is not replaced. OnShow stays create-only. `FRAME_NAME` stays `"ChurchOfBeefFrame"`.
- B26 leftover (niled OnHide stayed nil across Init; Hide then skipped `_StopSizing` / `shown = false`) is closed with a runtime restore, not only a source `find`. The restored handler is then proven to stop sizing and persist `shown = false`, so a no-op restore would fail.
- The B24-C early-return pin that forbade `OnHide` on that path was updated as the brief allowed. `wireShellOnHide` contains the substring `OnHide`; keeping the old forbid would have been a false fail. Inline `SetScript` / OnShow / rebuild forbids stay.
- Wipe uniqueness / existing-script identity / B26-B toast restore / B15-C forced-rebuild pins were left in the same `runB12D()` nest. Isolation stayed gated. New locals are inside `runB12D()`.
- Writer-reported **548 / 0** matched the re-run. Writer-reported red (**539 / 9**) matches the helper-missing + niled-stayed-nil + Hide-without-handler-left-`shown`/`_sizing` cluster that pre-extract early-return would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Handler-less Hide before remount still leaves stale `shown` / `_sizing`.** Reviewer probe: Show, nil OnHide, `Hide()`, Init restores the script, but `ChurchOfBeefDB.ui.shown` stays `true` and `UI._sizing` stays `true` (`IsShown` is already false; a second `Hide()` no-ops because the widget is already hidden). A later Show / Hide cycle fires the restored handler and clears both. Brief scoped restore of the missing script, not a shown-repair. The suite nils then Init then Show / Hide, so Hide-before-restore is unpinned.

2. **Early-return still does not restore a missing OnShow.** Reviewer probe: niled OnShow stays nil after Init. Brief forbids re-wiring OnShow. A remount that dropped OnShow would skip `shown = true` and the roster kick. Outside this brief.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the Quiet shell, Proclaim, and the small toast together. Brief asked isolated restore + identity, not a client walk.

### Nit

1. **Helper is `wireShellOnHide(frame)`, not the brief's optional `wireShellOnHide(self, frame)`.** Brief said extract that form if it keeps `SetScript` out of the early-return body. The extract does that. Source pin matches `%(frame%)`. Not a miss.

2. **Third-Init identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

3. **B27-C uniqueness pin is not a wiped-list remount.** Restore runs after `savedSpecial` is put back. Combined wipe+nil is unpinned; reviewer probe lists the name once.

4. **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then`. `runB12D()` re-pins four. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD MainFrame delta.** Packet is the B27-C-only helper extract + nested pins. `git diff HEAD` on the two files still includes earlier Quiet-shell / toast / HideAll / B15-C / B19-B / B20-D / B21-C / B23-C / B24-C / B26-B batches. Report already says this.

6. **`UISpecialFrames = nil` and stub `_G["ChurchOfBeefFrame"]` stay unpinned.** `rememberSpecial` no-ops when the global is not a table. Stub `CreateFrame` still does not mint `_G.ChurchOfBeefFrame`. Brief asked wipe uniqueness to stay and a niled OnHide restore, not those edges. Harness `Hide()` is still not ESC.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **548 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**.

`UI:Init` early-return `rememberSpecial`s then `wireShellOnHide`s. A missing OnHide gets the same `_StopSizing` + `shown = false` handler as create. An existing script is not replaced. OnShow is not re-wired. The frame is not rebuilt. Wipe uniqueness / B24-C rememberSpecial / B26-B toast pins stay. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **548 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
