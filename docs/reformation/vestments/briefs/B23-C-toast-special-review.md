Spec PASS

# B23-C — Init early-return re-registers the small toast special frame (review)

**Quality:** Approved-with-nits

**Lane:** B23-C Init early-return re-registers the small toast special frame
**Brief:** `docs/reformation/vestments/briefs/B23-C-toast-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B23-C-toast-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B23-C-toast-special.diff` (B23-C-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell / HideAll / B19-B / B20-D / B21-C batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (`Toasts:Init` early-return: `rememberSpecial("ChurchOfBeefToast")` then `return self.frame`; create-path OnHide still `if not existing`; idle-return `if not self.showing then return` stays), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C / B19-B / B20-D / B21-C pins, then nested B23-C source + wipe remount + OnHide identity + third-Init uniqueness pins, isolation wrap); then ran `lua tests/test_ui.lua` (**489 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: B20-D leftover (`Init` returned the existing frame and skipped `rememberSpecial`; a wiped `UISpecialFrames` never got `ChurchOfBeefToast` back); Init early-return `rememberSpecial`; do not re-wire OnHide; nest `runB12D()`; uniqueness once; OnHide idle-return when `showing` is nil stays; no `hideTheater` from the small-toast OnHide; no `PlaySound`; no new kind names; default `KINDS` stay `interrupt = false`; wiki ESC via `UISpecialFrames`; Law 6 (Quiet does not drive this file); Law 10 / Bible §19.3 (no close button; clerical copy unchanged). Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Init` early-return still skips `rememberSpecial` (B20-D leftover) | **Pass. Verified.** Live early-return is `rememberSpecial("ChurchOfBeefToast")` then `return self.frame`. Pins: wipe `UISpecialFrames` to `{}`, second Init lists the name once. Reviewer probe: wipe leaves count 0; second Init returns the same frame and count is 1. `Push` after wipe also re-registers (Init is on that path). `ResetForTests` does not nil `self.frame`, so remounts that keep the widget go through this path. |
| Early-return re-wires OnHide | **Pass. Verified.** Early-return body has no `SetScript` / `OnHide`. Pin: `GetScript("OnHide")` identity stays across wipe remount. Reviewer spy: wrapped `frame.SetScript` saw **0** calls on second Init (no wipe), wipe+Init, and third Init. Create path still wires only `if not existing`. |
| Wipe remount duplicates `ChurchOfBeefToast` | **Pass. Verified.** `rememberSpecial` still dedupes. Pins: once before wipe; once after wipe+Init; third Init still once. B19-B first-create uniqueness pins stay (`Init` / second Init without wipe). Reviewer probe: second Init with the name already listed stays 1; wipe+Init+Init stays 1. |
| Small-toast `OnHide` calls `hideTheater` | **Pass.** `Init` body has no `hideTheater`. Live `hideTheater(` sites are the helper plus proclaim `OnHide` and `HideAll` only. OnHide idle-return `if not self.showing then return` stays. Reviewer spy: wrapped theater `root.Hide` saw **0** calls while a small Hide ran beside a shown Proclaim. |
| `PlaySound` / new kind names / `KINDS.interrupt` flipped | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Cue remains `Sound:Play(kind)` from Proclaim only. `KINDS` is still `system` / `debug`, both `interrupt = false`. No new kind names. Suite pins `#played` unchanged on second Init. Reviewer spy: `PlaySound` count stays 0 across Init remounts. |
| Isolated suite not exit 0 / pins not in `runB12D()` | **Pass. Verified.** 489 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()`. Isolation wrap stays under the load-time standalone block. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (early-return `rememberSpecial` + return; nested B23-C pins + header comment). Sibling dirt in this workspace is other lanes (Console, Sound, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, Sound, glue; no commit | **Pass.** Named-risk check. |
| `Init` early-return calls `rememberSpecial("ChurchOfBeefToast")` then returns the existing frame | **Pass.** Live order. Source pin in `runB12D()`. Reviewer capture is exactly that call then return. |
| Do not re-wire OnHide if a script already exists | **Pass.** Named-risk check. Early-return never `SetScript`s. Create path still `if not existing`. |
| Init, wipe `UISpecialFrames` to `{}`, second Init: name listed exactly once | **Pass.** Named-risk check. Third Init is an extra keep-pin. |
| First-create uniqueness pins stay | **Pass.** B19-B `Init` / second Init once-pins stay in the same nest. B23-C re-pins uniqueness before the wipe. |
| Nest pins in `runB12D()`; no new main-chunk locals | **Pass.** B23-C locals (`earlyInit`, `toastOnHide`, `savedSpecial`, `cuesWipe`) sit inside `runB12D()`. Header comment only in the main chunk. |
| OnHide idle-return when `showing` is nil stays; do not `hideTheater` from the small-toast OnHide | **Pass.** Named-risk check. B21-C interrupt pin stays (`"interrupt"`, pending 1). Reviewer probe: ESC after remount still presents `"pump two"` with pending 1. |
| Do not add kind names; default `KINDS` stay `interrupt = false`; no `PlaySound` | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **489 / 0.** |

B20-D leftover (wiped `UISpecialFrames` never got `ChurchOfBeefToast` back) is closed on the early-return path. Law 6 (no Quiet toast kind; Quiet does not drive theater), Law 10 (no close button; clerical copy), and no new cue hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + early-return `rememberSpecial` + uniqueness once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked membership counts. Pump + OnHide + register are pinned; the client's special-frame walk is not. |
| Early-return never re-wires OnHide, even if a remounted frame had lost the script | **On contract / leftover.** Brief: do not re-wire if a script already exists. Probe: `SetScript("OnHide", nil)` then Init leaves the script nil (SetScript delta 0). Name still re-registers. |

---

## Isolation / early-return / uniqueness

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). Reviewer probe: those keys are nil at load. `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**Early-return — Pass.** `if self.frame then` now `rememberSpecial("ChurchOfBeefToast")` then returns the existing frame. It does not `SetScript`, does not mention OnHide, does not `hideTheater`, and does not `PlaySound`. Create-path wire stays after the mint `Hide` and still skips when a script exists. `rememberSpecial("ChurchOfBeefToast")` still runs once on first create.

**Uniqueness — Pass.** `rememberSpecial` still returns when the name is already listed. Wipe-to-empty then Init lists the name once. Third Init stays once. First-create `Init` / second Init once-pins stay. Reviewer probe: `Push` after a wipe (frame kept, list empty) lists the name once and shows the envelope.

---

## Strengths

- The delta is the brief: one early-return `rememberSpecial` before `return self.frame`. Create-path OnHide, idle-return, `KINDS`, and `hideTheater` call sites were left alone.
- Wipe-to-`{}` then second Init is the leftover close, not only a source `find`. B19-B uniqueness / B21-C interrupt / B20-D advance-one pins were left in the same `runB12D()` nest. Reviewer remount still advances one (`"pump two"`, pending 1) and interrupt still presents the interrupter with pending 1.
- Isolation stayed gated. New locals are inside `runB12D()`. Writer-reported **489 / 0** matched the re-run. Writer-reported red (**486 / 3**) matches the three asserts old `if self.frame then return self.frame end` would fail: early-return `rememberSpecial` string; wiped + second Init lists once; third Init lists once.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Early-return never restores a missing OnHide.** Reviewer probe: nil the script, Init, script stays nil. Law asked only: do not re-wire if a script already exists. A remount that dropped the name gets `ChurchOfBeefToast` back; a remount that also dropped the handler does not. Brief did not ask to re-wire.

2. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the Quiet shell and Proclaim while the small toast Hide idles or advances one. Brief asked early-return `rememberSpecial` + uniqueness once, not a client walk. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

### Nit

1. **`UISpecialFrames = nil` is unpinned.** `rememberSpecial` no-ops when the global is not a table. Probe: Init with nil leaves it nil; assigning `{}` then Init lists the name once. Brief asked wipe to `{}`.

2. **`interrupt = false` and idle-return are re-pinned.** Both already live in the B19-B / B21-C block in the same nest. Harmless keep-pins.

3. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefToast"]`.** Reviewer probe: `_G.ChurchOfBeefToast == nil`. Production `CreateFrame("Frame", "ChurchOfBeefToast", …)` does. Same stub gap B12-D / B19-B / B20-D / B21-C named for named special frames.

4. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the B23-C-only early-return + pins. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell / HideAll / B19-B / B20-D / B21-C batches. Report already says this.

5. **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then`. `runB12D()` re-pins four. Brief said the wrap stays; it did.

6. **No full `lua tests/run.lua`.** Isolated **489 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **489 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**.

`Toasts:Init` early-return calls `rememberSpecial("ChurchOfBeefToast")` then returns the existing frame. It does not re-wire OnHide, does not `hideTheater`, and does not `PlaySound`. Wipe `UISpecialFrames` to `{}` then second Init lists the name exactly once. First-create uniqueness pins stay. OnHide idle-return when `showing` is nil stays. Default `KINDS` stay `interrupt = false`. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **489 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
