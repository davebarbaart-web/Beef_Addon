Spec PASS

# B24-C — Quiet shell Init early-return re-registers ESC (review)

**Quality:** Approved-with-nits

**Lane:** B24-C Quiet shell Init early-return re-registers ESC
**Brief:** `docs/reformation/vestments/briefs/B24-C-shell-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B24-C-shell-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B24-C-shell-special.diff` (B24-C-only exclusive-pair packet; live `MainFrame.lua` / `test_ui.lua` also carry earlier Quiet-shell / toast / HideAll / B15-C / B19-B / B23-C batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/MainFrame.lua` (`UI:Init` early-return: `rememberSpecial(FRAME_NAME)` then `return self.frame`; create-path still `buildFrame` + OnShow / OnHide + `rememberSpecial(FRAME_NAME)`; `rememberSpecial` still scan-then-append), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C / B19-B / B20-D / B21-C / B23-C pins, then nested B24-C source + wipe remount + frame / OnShow / OnHide identity + third-Init uniqueness pins, isolation wrap); then ran `lua tests/test_ui.lua` (**507 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: B23-C leftover on the Quiet shell (`UI:Init` returned the existing frame and skipped `rememberSpecial`; a wiped `UISpecialFrames` never got `ChurchOfBeefFrame` back); wiki ESC via `UISpecialFrames`; Init early-return `rememberSpecial(FRAME_NAME)`; no rebuild; do not re-wire OnShow / OnHide; nest `runB12D()`; uniqueness once; B15-C scan-then-append stays; no `PlaySound` / `IG_CHARACTER_INFO_*`; Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`). Did not mutate `MainFrame.lua` or `test_ui.lua`. Did not commit. Did not edit Toasts, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Init` early-return still skips `rememberSpecial` (B23-C leftover on the shell) | **Pass. Verified.** Live early-return is `rememberSpecial(FRAME_NAME)` then `return self.frame`. Pins: wipe `UISpecialFrames` to `{}`, second Init lists `ChurchOfBeefFrame` once. Reviewer probe: wipe leaves count 0; second Init returns the same frame and count is 1. Source capture of the early-return body is exactly that call then return. Bootstrap `COB.UI:Init()` is the production remount that hits this path. |
| Early-return rebuilds the Quiet shell | **Pass. Verified.** Early-return body has no `buildFrame` / `CreateFrame` / `SetScript`. Pin: `COB.UI:Init()` equals `existingShell` and `COB.UI.frame` stays that widget. Reviewer spy: wrapped `CreateFrame` saw **0** calls on second Init (no wipe), wipe+Init, and third Init. Forced rebuild (`self.frame = nil`) still mints a new widget and is the B15-C path, not this one. |
| Early-return re-wires OnShow / OnHide | **Pass. Verified.** Early-return body has no `SetScript` / `OnShow` / `OnHide`. Pins: `GetScript("OnShow")` / `GetScript("OnHide")` identity stay across wipe remount. Reviewer spy: wrapped `frame.SetScript` saw **0** calls on second Init, wipe+Init, and third Init. Create path still wires both scripts after `buildFrame`. |
| Wipe remount duplicates `ChurchOfBeefFrame` | **Pass. Verified.** `rememberSpecial` still dedupes (`UISpecialFrames[i] == name` then return; else `# + 1`). Pins: once before wipe; once after wipe+Init; third Init still once. B15-C first-create / forced-rebuild uniqueness pins stay. Reviewer probe: second Init with the name already listed stays 1; wipe+Init+Init stays 1; nil-`frame` rebuild stays 1. Live source has **2** `rememberSpecial(FRAME_NAME)` sites (early-return + create). |
| `PlaySound` / `IG_CHARACTER_INFO_*` / panel whoosh | **Pass.** Live `MainFrame.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Template stays `BasicFrameTemplate`. Suite pins `#played` unchanged on second Init. B15-C silent-source pins stay. Reviewer probe: source `find` of those strings is nil. |
| Isolated suite not exit 0 / pins not in `runB12D()` | **Pass. Verified.** 507 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()`. Isolation wrap stays under the load-time standalone block. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (early-return `rememberSpecial` + return; nested B24-C pins + header comment). Sibling dirt in this workspace is other lanes (Toasts, Console, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Console, glue; no commit | **Pass.** Named-risk check. |
| No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Nest pins in `runB12D()`; no new main-chunk locals | **Pass.** B24-C locals (`shellEarly`, `shellOnShow`, `shellOnHide`, `existingShell`, `cuesShellWipe`) sit inside `runB12D()`. Header comment only in the main chunk. |
| `Init` early-return calls `rememberSpecial(FRAME_NAME)` then returns the existing frame | **Pass.** Live order. Source pin in `runB12D()`. Reviewer capture is exactly that call then return. |
| Do not rebuild | **Pass.** Named-risk check. |
| Do not re-wire OnShow / OnHide | **Pass.** Named-risk check. |
| B15-C uniqueness stays (scan then append; first-create / rebuild once-pins stay) | **Pass.** Helper body unchanged. B15-C forced-rebuild block sits above this nest and still passes. B24-C re-pins uniqueness before the wipe. |
| `UI:Init`, wipe `UISpecialFrames` to `{}`, second Init: `ChurchOfBeefFrame` listed exactly once | **Pass.** Named-risk check. Third Init is an extra keep-pin. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **507 / 0.** |

B23-C leftover on the Quiet shell (wiped `UISpecialFrames` never got `ChurchOfBeefFrame` back) is closed on the early-return path. Law 6 (Quiet silent; no panel whoosh), Law 10 (stock `BasicFrameTemplate`), wiki ESC via `UISpecialFrames`, and B15-C uniqueness hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Decree `ensureFrame` still skips `rememberSpecial` on early-return | **Not this lane.** Brief exclusive pair is MainFrame + `test_ui.lua`. Live `Decree.lua` already has the B24-D-shaped early-return `rememberSpecial(FRAME_NAME)` (sibling packet). Report leftover is stale vs this workspace, not a B24-C miss. |
| Parked Console leftover (selected-pair inherit of Core `namedOpponent`) | **Not this lane.** Overview parks it for a later Console batch. |
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + early-return `rememberSpecial` + uniqueness once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked membership counts. Register + uniqueness are pinned; the client's special-frame walk is not. |
| Early-return never re-wires OnShow / OnHide, even if a remounted frame had lost the scripts | **On contract / leftover.** Brief: do not re-wire. Probe: `SetScript("OnShow" / "OnHide", nil)` then Init leaves both nil (SetScript delta 0). Name still re-registers. |

---

## Isolation / early-return / uniqueness

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). Reviewer probe: those keys are nil at load. `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire.

**Early-return — Pass.** `if self.frame then` now `rememberSpecial(FRAME_NAME)` then returns the existing frame. It does not `SetScript`, does not mention OnShow / OnHide, does not call `buildFrame`, and does not `PlaySound`. Create-path wire and `rememberSpecial(FRAME_NAME)` still run after the mint. Sibling Inits (Toasts / Decree / Console / …) stay on the create path only.

**Uniqueness — Pass.** `rememberSpecial` still returns when the name is already listed. Wipe-to-empty then Init lists `ChurchOfBeefFrame` once. Third Init stays once. First-create and forced-rebuild once-pins stay. Reviewer probe: `UI:Init` after a wipe does not restore `ChurchOfBeefProclaim` or `ChurchOfBeefToast` (those names are other lanes).

---

## Strengths

- The delta is the brief: one early-return `rememberSpecial(FRAME_NAME)` before `return self.frame`. Create-path OnShow / OnHide, B15-C `rememberSpecial`, and the scan-then-append helper were left alone.
- Wipe-to-`{}` then second Init is the leftover close, not only a source `find`. Frame identity and OnShow / OnHide identity are pinned. B15-C uniqueness / B12-D Proclaim / B23-C toast remount pins were left in the same `runB12D()` nest.
- Isolation stayed gated. New locals are inside `runB12D()`. Writer-reported **507 / 0** matched the re-run. Writer-reported red (**504 / 3**) matches the three asserts old `if self.frame then return self.frame end` would fail: early-return `rememberSpecial` string; wiped + second Init lists once; third Init lists once.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Early-return never restores a missing OnShow / OnHide.** Reviewer probe: nil both scripts, Init, both stay nil. Law asked: do not re-wire. A remount that dropped the name gets `ChurchOfBeefFrame` back; a remount that also dropped the handlers does not.

2. **`UI:Show` / `UI:Toggle` do not call `Init` when `self.frame` already exists.** Reviewer probe: wipe the list, `Show` / `Toggle` (Records Book unloaded), count stays 0; a later `Init` lists the name once. Production `/beef` prefers `RecordsBook:Toggle` and never hits this shell remount. Brief scoped the early-return of `Init`, which bootstrap calls.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the Quiet shell and Proclaim together. Brief asked early-return `rememberSpecial` + uniqueness once, not a client walk. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

### Nit

1. **`UISpecialFrames = nil` is unpinned.** `rememberSpecial` no-ops when the global is not a table. Probe: Init with nil leaves it nil; assigning `{}` then Init lists the name once. Brief asked wipe to `{}`.

2. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFrame"]`.** Reviewer probe: `_G.ChurchOfBeefFrame == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap B12-D / B15-C / B23-C named for named special frames.

3. **Exclusive-pair diff is not a vs-HEAD MainFrame delta.** Packet is the B24-C-only early-return + pins. `git diff HEAD` on the two files still includes earlier Quiet-shell / toast / B15-C batches. Report already says this.

4. **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then`. `runB12D()` re-pins four. Brief said the wrap stays; it did.

5. **Writer Decree leftover is stale vs live tree.** `ensureFrame` already calls `rememberSpecial(FRAME_NAME)` on early-return (B24-D). Not a B24-C miss.

6. **No full `lua tests/run.lua`.** Isolated **507 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **507 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**.

`UI:Init` early-return calls `rememberSpecial(FRAME_NAME)` then returns the existing frame. It does not rebuild, does not re-wire OnShow / OnHide, and does not `PlaySound`. Wipe `UISpecialFrames` to `{}` then second Init lists `ChurchOfBeefFrame` exactly once. First-create / rebuild uniqueness pins stay. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **507 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
