Spec PASS

# B20-D — ESC on the small toast advances the queue (review)

**Quality:** Approved-with-nits

**Lane:** B20-D ESC on the small toast advances the queue
**Brief:** `docs/reformation/vestments/briefs/B20-D-toast-pump.md`
**Writer report:** `docs/reformation/vestments/briefs/B20-D-toast-pump-report.md`
**Diff:** `docs/reformation/vestments/briefs/B20-D-toast-pump.diff` (B20-D-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell / HideAll / B19-B batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (empty `pump` idle return; small-toast `OnHide` after the create-time `Hide`: idle guard, then `bumpGen()`, `showing = nil`, `pump(self)`), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C / B19-B pins, then nested B20-D source + three-`Show` + theater-beside pins, isolation wrap); then ran `lua tests/test_ui.lua` (**455 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: B19-B leftover (ESC Hide cleared `showing` and left `pending` waiting for the next Push); OnHide `bumpGen` + pump; advance one; no `hideTheater` from the small-toast OnHide; no `PlaySound` on hide / ESC; nest in `runB12D()`; wiki ESC via `UISpecialFrames`; Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged). Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| ESC Hide still clears `showing` and leaves `pending` waiting for the next Push (B19-B leftover) | **Pass. Verified.** Small `OnHide` idle-guards, then `bumpGen()`, `self.showing = nil`, `pump(self)`. Pins: three `Show`s, Hide presents `"pump two"`, `PendingCount() == 1`. Reviewer probe: same advance on debug kinds; natural `advance(3.5)` also presents the next envelope and leaves the rest. |
| ESC drains the rest of the queue | **Pass. Verified.** Third envelope stays through the first Hide; second Hide presents it; last Hide idles with `PendingCount() == 0`. Probe: snapshot-style special-frame walk and a live `IsShown`-then-Hide walk both leave one queued row. |
| Hide-from-empty-pump re-enters `OnHide` and loops | **Pass. Verified.** Empty `pump` returns when `showing` is already nil (and `#pending == 0`). Last Hide: frame hidden, `ShowingKind` nil, no invented pending. Reviewer probe: invoking the OnHide script twice while idle stays hidden / nil / empty. |
| Small-toast `OnHide` calls `hideTheater` | **Pass. Verified.** `Init` body has no `hideTheater`. Live `hideTheater(` call sites are proclaim `OnHide` and `HideAll` only (def + two calls). Pin: theater root stays shown across pump Hide. Reviewer spy: wrapped theater `root.Hide` saw **0** calls while the small stack advanced. |
| `PlaySound` / `IG_CHARACTER_INFO_*` on hide / ESC / pump | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Cue remains `Sound:Play(kind)` from `playTheaterCue` on Proclaim show only. Suite pins `#played` unchanged across ESC pump and empty-pump Hide. Reviewer spy: `PlaySound` count stays 0 on Show / Hide / HideAll / Init. |
| Isolated suite not exit 0 / pins not in `runB12D()` | **Pass. Verified.** 455 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()`. Isolation wrap stays under the first `if standalone then`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (empty-pump idle return; OnHide `bumpGen` + `pump`; nested B20-D pins + header comment). Sibling dirt in this workspace is other lanes (Console, Sound, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, Sound, glue; no commit | **Pass.** Named-risk check. |
| Small-toast `OnHide` `bumpGen()` then `showing = nil` then `pump(self)` | **Pass.** Live order in the SetScript body is idle guard → `bumpGen()` → `self.showing = nil` → `pump(self)`. Wired after the create-time `Hide` (`if not existing`). Source pins + reviewer order probe. |
| Re-entry: empty `pump` / Hide-from-pump does not loop (`showing` already nil and pending empty → return) | **Pass.** Named-risk check. Guard lives on both empty `pump` and idle `OnHide`. |
| Advance one; do not drain pending to empty on ESC | **Pass.** Named-risk check. Three-`Show` pin is stronger than the brief's two. |
| Do not `hideTheater` from the small-toast `OnHide` | **Pass.** Named-risk check. |
| No `PlaySound` on hide / ESC | **Pass.** Named-risk check. |
| `ChurchOfBeefToast` stays on `UISpecialFrames`; nest pins in `runB12D()` | **Pass.** `rememberSpecial("ChurchOfBeefToast")` unchanged. Once-pins stay through Init / second Init / ESC pump / theater-beside pump. New asserts sit in `runB12D()` after the B19-B block. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **455 / 0.** |

B19-B leftover (queued toast waiting for the next Push) is closed on ESC Hide. Law 6 (no Quiet toast kind; Quiet does not drive theater), Law 10 (no close ✕; clerical copy), and no new cue hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + OnHide `bumpGen` + pump + advance one. Reviewer snapshot-walk: shell and theater hide; toast advances one and stays shown. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked Hide simulating ESC. Pump + OnHide are pinned; the client's special-frame walk is not. |
| `interruptShowing` still nils `showing` before Hide; a pending row can present before Push inserts an interrupting envelope | **On contract / leftover.** Brief scoped ESC / default kinds (`interrupt = false`). Probe: `Push({ interrupt = true, priority = 90 })` while one row is queued presents the queued copy and leaves the interrupter pending. Empty-pending interrupt still presents the new envelope. |
| `Init` early-return does not re-wire OnHide | **On contract.** First create registers the handler; second Init is idempotent on the widget. Probe: `GetScript("OnHide")` is the same function. |

---

## Isolation / OnHide / pump

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**OnHide — Pass.** Create-time `Hide` is before `SetScript("OnHide")`, so mint does not pump. Handler is idle-return when `showing` is already nil and pending is empty; otherwise `bumpGen()` (invalidates the hold timer), `showing = nil`, `pump(self)`. No `hideTheater`, no `PlaySound`, no close button. `rememberSpecial("ChurchOfBeefToast")` stays after the wire. `if self.frame then return` still skips a second wire / second register.

**Pump / advance-one — Pass.** `pump` pops one envelope and `present`s it. Empty pending + already-idle `showing` returns without a second Hide. Last ESC and last hold both idle. `bumpGen` on dismiss is real: reviewer fired only the older hold after ESC presented the second envelope — copy and pending stayed. B19-B single-toast ESC pin stays in the same nest (Hide with no queue still clears `ShowingKind`; later Show still works).

---

## Strengths

- The delta is the brief: OnHide `bumpGen` + nil + `pump`, empty-pump idle return, advance one, no `hideTheater`, no `PlaySound`. Theater and small stack stay separate.
- Three-`Show` drain pin plus a theater-beside pair is the real leftover close, not only a source `find("pump(self)")`. B19-B / B12-D / B15-C / B18-C pins were left in the same `runB12D()` nest.
- Hold expiry and ESC now share OnHide. Reviewer `advance(3.5)` presents the next envelope and leaves the rest; a gen-invalidated leftover hold does not restore the dismissed copy.
- Isolation stayed gated. New locals are inside `runB12D()`. Writer-reported **455 / 0** matched the re-run. Writer-reported red (**440 / 15**) matches the new source / present / pending / theater-pump asserts that old OnHide (`showing = nil` only) would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`interruptShowing` nils `showing` then `Hide()`. ** If pending is non-empty, OnHide sees `showing == nil` and `#pending > 0`, skips the idle guard, and pumps the queued row before Push inserts the interrupter. Reviewer probe: showing text is the queued copy; `PendingCount() == 1` (the interrupter). Default `KINDS` stay `interrupt = false`. Brief did not ask to change `interruptShowing`.

2. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. Reviewer snapshot-walk and live walk: shell and theater hide; the small toast Hide pumps the next envelope and the frame stays shown. One real ESC may still hide the Quiet shell and Proclaim while advancing the toast. Brief asked OnHide pump, not a client walk. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

### Nit

1. **Empty-pump `#pending == 0` is redundant after `table.remove` returned nil.** The live guard is really `if not self.showing then return`. Brief asked that wording; the pin matches the source strings.

2. **OnHide idle guard uses the same `showing` nil + empty pending test.** That is what lets the interrupt leftover pump when `showing` is already nil. A `not self.showing then return` OnHide guard would have kept interrupt + empty-pump Hide idle and still advanced ESC (showing is set on ESC). Not a brief miss.

3. **`Init` early-return does not re-`rememberSpecial` or re-wire OnHide.** Probe: wipe `UISpecialFrames`, second Init leaves toast count 0; OnHide function identity stays. First create is the live path. Writer already named this.

4. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefToast"]`.** Reviewer probe: `_G.ChurchOfBeefToast == nil`. Production `CreateFrame("Frame", "ChurchOfBeefToast", …)` does. Same stub gap B12-D / B19-B named for named special frames.

5. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the B20-D-only pump guard + OnHide + pins. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell / HideAll / B19-B batches. Report already says this.

6. **No full `lua tests/run.lua`.** Isolated **455 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **455 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**.

Small-toast `OnHide` `bumpGen()`s, nils `showing`, and `pump(self)`. Empty pump / idle OnHide return so Hide-from-empty-pump does not loop. ESC advances one and does not drain the rest of the queue. `OnHide` does not call `hideTheater` and does not `PlaySound`. `ChurchOfBeefToast` stays on `UISpecialFrames` once. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **455 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
