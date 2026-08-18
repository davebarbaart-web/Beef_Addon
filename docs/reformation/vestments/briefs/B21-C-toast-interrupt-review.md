Spec PASS

# B21-C — interrupt Hide does not pump a queued toast (review)

**Quality:** Approved-with-nits

**Lane:** B21-C interrupt Hide does not pump a queued toast
**Brief:** `docs/reformation/vestments/briefs/B21-C-toast-interrupt.md`
**Writer report:** `docs/reformation/vestments/briefs/B21-C-toast-interrupt-report.md`
**Diff:** `docs/reformation/vestments/briefs/B21-C-toast-interrupt.diff` (B21-C-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell / HideAll / B19-B / B20-D batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (small-toast `OnHide` after the create-time `Hide`: `if not self.showing then return`, then `bumpGen()`, `showing = nil`, `pump(self)`; `interruptShowing` still nils `showing` then `Hide()`), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C / B19-B / B20-D pins, then nested B21-C source + Show / Show / interrupt Push pins, isolation wrap); then ran `lua tests/test_ui.lua` (**473 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: B20-D leftover (`interruptShowing` nils `showing` then `Hide()`; OnHide pumped a queued row before Push inserted the interrupter); OnHide idle-return when showing is already nil; interrupt Push presents the interrupter and leaves queued pending 1; ESC still advances one; empty-pump Hide stays idle; `interruptShowing` discards and never re-queues; nest `runB12D()`; no `PlaySound` on hide / ESC / interrupt; no `hideTheater` from the small-toast OnHide; wiki ESC via `UISpecialFrames`; Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged). Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `interruptShowing` Hide still pumps a queued row before Push inserts the interrupter (B20-D leftover) | **Pass. Verified.** Small `OnHide` is now `if not self.showing then return`. Pins: Show / Show / Push `{ interrupt = true, priority = 99 }` presents `"interrupt"`, `PendingCount() == 1`. Reviewer probe: nilling `showing` then `Hide()` while one row is queued leaves the frame hidden, `ShowingKind` nil, pending still 1 (no pump). Same interrupt on debug kinds. |
| Interrupt Push drains pending or re-queues the interrupted toast | **Pass. Verified.** Pin pending stays 1. Probe: ESC after interrupt presents `"queued second"` (not `"shown first"`); second ESC idles. Two queued + interrupt: showing is the interrupter, pending stays 2; two ESC advances present the two queued rows; the interrupted copy never returns. Empty-pending interrupt presents the new envelope and leaves pending 0. |
| ESC no longer advances one | **Pass.** B20-D three-`Show` pins stay in the same nest and still pass. Reviewer probe: same advance (`"pump two"`, pending 1). After interrupt, one ESC presents the leftover queued row. |
| Hide-from-empty-pump re-enters `OnHide` and loops | **Pass.** Empty `pump` still returns when `showing` is already nil. Last ESC: frame hidden, `ShowingKind` nil, no invented pending. OnHide idle-return no longer needs empty pending. Probe: invoking the OnHide script twice while idle stays hidden / nil / empty. |
| Small-toast `OnHide` calls `hideTheater` | **Pass.** `Init` body has no `hideTheater`. Live `hideTheater(` call sites are proclaim `OnHide` and `HideAll` only. Pin: theater root stays shown across B20-D pump Hide. Reviewer spy: wrapped theater `root.Hide` saw **0** calls while interrupt Hide presented the interrupter. |
| `PlaySound` / `IG_CHARACTER_INFO_*` on hide / ESC / interrupt | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Cue remains `Sound:Play(kind)` from `playTheaterCue` on Proclaim show only. Suite pins `#played` unchanged across interrupt. Reviewer spy: `PlaySound` count stays 0 on interrupt Hide and the following ESC. |
| Isolated suite not exit 0 / pins not in `runB12D()` | **Pass. Verified.** 473 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()`. Isolation wrap stays under the first `if standalone then`. |
| Exclusive file breach / new kind names | **Pass.** Lane implementation is the two named files. Packet is two hunks (OnHide idle guard; nested B21-C source + Show / Show / interrupt pins + header comment). Default `KINDS` stay `system` / `debug` with `interrupt = false`. Sibling dirt in this workspace is other lanes (Console, Sound, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, Sound, glue; no commit | **Pass.** Named-risk check. |
| Small-toast `OnHide` idle-returns when `showing` is already nil (`if not self.showing then return`) | **Pass.** Live SetScript body. Source pin in `runB12D()`. Init body has no `#pending == 0`. Reviewer nil-then-Hide probe. |
| Interrupt Push presents the interrupter and leaves queued pending 1 | **Pass.** Named-risk check. Showing text is the distinguisher; leftover would have painted the queued copy with pending still 1. |
| ESC still advances one (Hide happens while `showing` is set) | **Pass.** Named-risk check. B20-D pins stay. |
| Empty-pump Hide stays idle; `interruptShowing` discards and never re-queues | **Pass.** Named-risk check. |
| Do not add new kind names; default `KINDS` stay `interrupt = false`; do not drain pending | **Pass.** `KINDS` is still two rows, both `interrupt = false`. Probe: `Push({ priority = 99 })` without `interrupt` queues. Two queued + interrupt leaves pending 2. |
| No `PlaySound` on hide / ESC / interrupt; no `hideTheater` from the small-toast `OnHide` | **Pass.** Named-risk check. |
| `ChurchOfBeefToast` stays on `UISpecialFrames`; nest pins in `runB12D()` | **Pass.** `rememberSpecial("ChurchOfBeefToast")` unchanged. Once-pins stay through Init / second Init / ESC / interrupt. New asserts sit in `runB12D()` after the B20-D block. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **473 / 0.** |

B20-D leftover (queued row presenting before Push inserts the interrupter) is closed on interrupt Hide. ESC advance-one is unchanged. Law 6 (no Quiet toast kind; Quiet does not drive theater), Law 10 (no close button; clerical copy), and no new cue hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + OnHide idle-return + interrupt present + pending 1. Client walk is not this lane. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked Hide simulating ESC. Pump + OnHide + interrupt are pinned; the client's special-frame walk is not. |
| `Init` early-return does not re-wire OnHide | **On contract.** First create registers the handler; second Init is idempotent on the widget. Probe: `GetScript("OnHide")` is the same function. |
| Empty-pump `#pending == 0` is still redundant after `table.remove` returned nil | **On contract.** Brief asked only the OnHide guard. Pump idle wording is unchanged. |

---

## Isolation / OnHide / interrupt

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). Reviewer probe: those keys are nil at load. `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**OnHide — Pass.** Create-time `Hide` is before `SetScript("OnHide")`, so mint does not pump. Handler idle-returns when `showing` is already nil (interrupt Hide and empty-pump Hide). ESC Hide happens while `showing` is set, so it still `bumpGen()`, nils `showing`, and `pump(self)`. No `hideTheater`, no `PlaySound`, no close button. `rememberSpecial("ChurchOfBeefToast")` stays after the wire. `if self.frame then return` still skips a second wire / second register.

**Interrupt / pending — Pass.** `interruptShowing` still discards the current envelope (never re-queues) and nils `showing` before `Hide()`. OnHide no longer pumps. Push then `insertPending`s the interrupter and `pump`s because `showing` is nil. Default kinds stay `interrupt = false`; equal-priority `interrupt = true` does not beat the showing envelope (`priority >` is unchanged). B20-D ESC-advance-one pins stay.

---

## Strengths

- The delta is the brief: one OnHide guard change. Interrupt Hide idles; ESC Hide still pumps one; empty-pump Hide still idles. Theater and small stack stay separate.
- Showing-text pin is the leftover close, not only a source `find`. Pending count alone would have passed on the old pump-before-insert path. B20-D / B19-B / B12-D / B15-C / B18-C pins were left in the same `runB12D()` nest.
- Isolation stayed gated. New locals are inside `runB12D()`. Writer-reported **473 / 0** matched the re-run. Writer-reported red (**470 / 3**) matches the three asserts old OnHide would fail: idle-guard string, `#pending == 0` still in Init, showing text is the interrupter.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the Quiet shell and Proclaim while the small toast Hide now idles (interrupt) or advances one (ESC). Brief asked OnHide idle-return + interrupt present, not a client walk. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

### Nit

1. **Pending identity is unpinned.** Brief asked count 1. The pin does not read the queued copy. Reviewer probe: ESC after interrupt presents `"queued second"`; `"shown first"` does not return.

2. **Empty-pump `#pending == 0` is still redundant** after `table.remove` returned nil. The live empty-`pump` guard is really `if not self.showing then return`. Brief asked that wording on OnHide only; the pin matches.

3. **`Init` early-return does not re-`rememberSpecial` or re-wire OnHide.** Probe: OnHide function identity stays. First create is the live path. Writer already named this.

4. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefToast"]`.** Reviewer probe: `_G.ChurchOfBeefToast == nil`. Production `CreateFrame("Frame", "ChurchOfBeefToast", …)` does. Same stub gap B12-D / B19-B / B20-D named for named special frames.

5. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the B21-C-only OnHide guard + pins. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell / HideAll / B19-B / B20-D batches. Report already says this.

6. **No full `lua tests/run.lua`.** Isolated **473 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **473 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**.

Small-toast `OnHide` idle-returns when `showing` is already nil. Interrupt Push presents the interrupter and leaves queued pending 1. ESC still advances one. Empty-pump Hide stays idle. `interruptShowing` discards the interrupted toast and never re-queues it. `OnHide` does not call `hideTheater` and does not `PlaySound`. `ChurchOfBeefToast` stays on `UISpecialFrames` once. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **473 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
