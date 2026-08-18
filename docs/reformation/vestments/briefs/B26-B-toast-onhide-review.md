Spec PASS

# B26-B — Toast Init restores a missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B26-B Toast Init restores a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B26-B-toast-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B26-B-toast-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B26-B-toast-onhide.diff` (B26-B-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell / HideAll / B19-B / B20-D / B21-C / B23-C / B24-C batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (`Toasts:Init` early-return: `rememberSpecial("ChurchOfBeefToast")` then `wireSmallOnHide(self, self.frame)` then `return self.frame`; `wireSmallOnHide` wires only when `GetScript("OnHide")` is nil; create path calls the same helper after the mint Hide; idle-return `if not self.showing then return` then `bumpGen` / nil showing / `pump`), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C / B19-B / B20-D / B21-C / B23-C pins, then nested B26-B source + nil-OnHide restore + third-Init identity + pump / idle-return pins; wipe uniqueness / isolation wrap stay); then ran `lua tests/test_ui.lua` (**528 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: B23-C leftover (`Init` early-return `rememberSpecial`s but never restores a missing OnHide; a remount that dropped the handler leaves ESC Hide idle); wiki ESC via `UISpecialFrames`; Init early-return `rememberSpecial` then wire the **same** idle-return handler as create if OnHide is nil; do not replace an existing script; do not rebuild; nest `runB12D()`; uniqueness once; no `hideTheater` from the small-toast OnHide; no `PlaySound`; no new kind names; default `KINDS` stay `interrupt = false`; Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged). Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit Decree, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Init` early-return still skips a missing OnHide (B23-C leftover) | **Pass. Verified.** Live early-return is `rememberSpecial("ChurchOfBeefToast")` then `wireSmallOnHide(self, self.frame)` then `return self.frame`. Helper wires only when `GetScript("OnHide")` is nil. Pins: `SetScript("OnHide", nil)`, second Init restores a script; restored Hide still pumps `"restore two"` and idle-returns after the last. Reviewer probe: niled script, Init, `GetScript` is non-nil; wrapped `SetScript` saw **1** call. |
| Early-return replaces an existing script | **Pass. Verified.** Helper is `if not existing then`. Pins: wipe remount keeps the create-path identity; third Init after restore keeps `restoredOnHide`. Reviewer spy: wrapped `SetScript` saw **0** calls on second Init (script already set), wipe+existing, a sentinel OnHide, and third Init. Sentinel identity stayed. |
| Restore rebuilds or duplicates `ChurchOfBeefToast` | **Pass. Verified.** Early-return still returns `self.frame`. Pins: niled Init returns `existingToast`; third Init does not rebuild; restore uniqueness stays 1. B23-C wipe-to-`{}` + second Init once-pins stay. Reviewer probe: `CreateFrame` delta **0** on remounts; wipe+nil+Init lists the name once; third Init still once. |
| Restored handler is not the create idle-return (`hideTheater` / `PlaySound` / no pump) | **Pass.** Create and early-return both call `wireSmallOnHide`. Live handler is still `if not self.showing then return` then `bumpGen` / nil showing / `pump(self)`. `hideTheater(` sites stay the helper, proclaim `OnHide`, and `HideAll` only. File has no `PlaySound`. Pins: restored Hide presents `"restore two"` with pending 0, then idle-returns. Reviewer probe: same pump / idle-return after restore. |
| `PlaySound` / new kind names / `KINDS.interrupt` flipped | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Cue remains `Sound:Play(kind)` from Proclaim only. `KINDS` is still `system` / `debug`, both `interrupt = false`. No new kind names. Suite pins `#played` unchanged on restore Init. Reviewer spy: `PlaySound` count stays 0 across remounts. |
| Isolated suite not exit 0 / pins not in `runB12D()` | **Pass. Verified.** 528 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()`. Isolation wrap stays under the load-time standalone block. `luac -l -p`: main chunk **75** locals (cap 200). Packet adds no main-chunk `local`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two unified hunks (extract `wireSmallOnHide` + early-return call; header comment + nested B26-B pins). Sibling dirt in this workspace is other lanes (Console, Decree, Records, MainFrame, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Decree, Records, glue; no commit | **Pass.** Named-risk check. |
| `Init` early-return `rememberSpecial`s, then wires the same idle-return handler if OnHide is nil | **Pass.** Live order. Source pin in `runB12D()`. Reviewer capture is that call, then `wireSmallOnHide`, then `return self.frame`. |
| Do not replace an existing script; do not rebuild | **Pass.** Named-risk check. |
| Nil the OnHide, second Init: script is restored; third Init identity stays | **Pass.** Named-risk check. |
| Wipe `UISpecialFrames` uniqueness pins stay | **Pass.** B23-C wipe-to-`{}` + second Init once / third Init once stay in the same nest. B19-B first-create uniqueness pins stay. |
| Nest pins in `runB12D()`; no new main-chunk locals | **Pass.** B26-B locals (`wireBody`, `cuesRestore`, `existingToast`, `restoredOnHide`) sit inside `runB12D()`. Header comment only in the main chunk. |
| OnHide idle-return when `showing` is nil stays; do not `hideTheater` from the small-toast OnHide | **Pass.** Named-risk check. B21-C interrupt pin stays (`"interrupt"`, pending 1). |
| Do not add kind names; default `KINDS` stay `interrupt = false`; no `PlaySound` | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **528 / 0.** |

B23-C leftover (a remount that dropped the handler left ESC Hide idle) is closed on the early-return path. Law 6 (no Quiet toast kind; Quiet does not drive theater), Law 10 (no close button; clerical copy), and no new cue hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + restore a niled OnHide + third-Init identity + uniqueness stays. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity + uniqueness. Pump + idle-return + register are pinned; the client's special-frame walk is not. |
| Quiet-shell Init early-return still does not restore a missing OnHide (B24-C) | **On contract.** Outside this exclusive pair. |
| Lane is unsigned | **On contract.** This review does not sign the lane. |

---

## Isolation / restore / uniqueness

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). Reviewer probe: those keys are nil at load. `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**Restore — Pass.** `if self.frame then` still `rememberSpecial`s, then `wireSmallOnHide` (no inline `SetScript`), then returns the existing frame. The helper no-ops when a script exists and writes the idle-return handler only when OnHide is nil. Create path calls the same helper after the mint Hide. Reviewer spy: restore `SetScript` delta 1; existing / sentinel / third Init delta 0. `CreateFrame` delta 0 on remounts.

**Uniqueness — Pass.** `rememberSpecial` still returns when the name is already listed. B23-C wipe-to-empty then Init lists the name once. Third Init stays once. First-create `Init` / second Init once-pins stay. Restore Init (list already populated) stays 1. Reviewer probe: wipe+nil+Init also lists once.

---

## Strengths

- The delta is the brief: extract the create-path idle-return into `wireSmallOnHide` and call it from early-return. An existing script is not replaced. `KINDS`, `hideTheater` call sites, and Proclaim wiring were left alone.
- B23-C's leftover (niled OnHide stayed nil across Init) is closed with a runtime restore, not only a source `find`. The restored handler is then proven to pump one and idle-return, so a no-op restore would fail.
- Wipe uniqueness / existing-script identity / B21-C interrupt / B20-D advance-one pins were left in the same `runB12D()` nest. Isolation stayed gated. New locals are inside `runB12D()`.
- Writer-reported **528 / 0** matched the re-run. Writer-reported red (**518 / 10**) matches the helper-missing + niled-stayed-nil + Hide-without-handler-did-not-pump cluster that pre-extract early-return would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Handler-less Hide before remount still leaves stale `showing`.** Reviewer probe: Show two, nil OnHide, `Hide()`, Init restores the script, but `ShowingKind` stays `"system"` and a later `Show` queues behind the leftover (`IsShown` stays false; a second `Hide()` no-ops because the widget is already hidden). Brief scoped restore of the missing script, not a showing-repair. The suite nils after `theaterReset()`, so Hide-before-restore is unpinned.

2. **Quiet-shell Init early-return still does not restore a missing OnHide.** B24-C only `rememberSpecial`s. Outside this exclusive pair.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the Quiet shell and Proclaim while the small toast Hide idles or advances one. Brief asked isolated restore + identity, not a client walk.

### Nit

1. **`initBody:find("OnHide")` matches the `wireSmallOnHide` substring.** The first `OnHide` in `Toasts:Init` is the helper name, not a `SetScript` / comment. The `wireBody` idle-return pins and the runtime restore close the hole.

2. **Third-Init identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

3. **B26-B uniqueness pin is not a wiped-list remount.** Restore runs after `savedSpecial` is put back. Combined wipe+nil is unpinned; reviewer probe lists the name once.

4. **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then`. `runB12D()` re-pins four. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the B26-B-only helper extract + nested pins. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell / HideAll / B19-B / B20-D / B21-C / B23-C batches. Report already says this.

6. **`UISpecialFrames = nil` and stub `_G["ChurchOfBeefToast"]` stay unpinned.** `rememberSpecial` no-ops when the global is not a table. Stub `CreateFrame` still does not mint `_G.ChurchOfBeefToast`. Brief asked wipe uniqueness to stay and a niled OnHide restore, not those edges. Harness `Hide()` is still not ESC.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **528 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**.

`Toasts:Init` early-return `rememberSpecial`s then `wireSmallOnHide`s. A missing OnHide gets the same idle-return handler as create. An existing script is not replaced. The frame is not rebuilt. Wipe uniqueness pins stay. Default `KINDS` stay `interrupt = false`. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **528 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
