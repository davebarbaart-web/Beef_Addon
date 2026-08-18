Spec PASS

# B18-C — HideAll does not double-bump theaterGen (review)

**Quality:** Approved-with-nits

**Lane:** B18-C HideAll does not double-bump theaterGen
**Brief:** `docs/reformation/vestments/briefs/B18-C-toast-gen.md`
**Writer report:** `docs/reformation/vestments/briefs/B18-C-toast-gen-report.md`
**Diff:** `docs/reformation/vestments/briefs/B18-C-toast-gen.diff` (B18-C-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (`HideAll` / `hideTheater` / `theaterHiding` / OnHide), and `tests/test_ui.lua` (existing B12-D Proclaim / ESC / UISpecialFrames pins, then nested B18-C HideAll source + Proclaim → HideAll → Proclaim pins inside `runB12D()`); then ran `lua tests/test_ui.lua` (**382 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: HideAll must not double-bump `theaterGen`; next Proclaim still shows; no `PlaySound` on hide; nest in `runB12D()`; Bible §19.3 / Law 10 (theatrical Proclaim, no close ✕); Law 6 (Quiet does not drive this file); B12-D leftover (HideAll `hideTheater` → OnHide → `hideTheater`). Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit Console, Sound, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `HideAll` still double-bumps `theaterGen` (`bumpGen` + `hideTheater`, or `hideTheater` + OnHide) | **Pass. Verified.** Live `HideAll` is `gen = gen + 1` then `hideTheater(self)` — no `bumpGen` call. `hideTheater` sets `theaterHiding`, increments `theaterGen` once, `root:Hide()`, then clears the flag. OnHide re-entry returns before a second increment. Reviewer spies: HideAll upvalues are `gen` / `hideTheater` / `clearPending` / `stopMotion` / `resetAnchor` (no `bumpGen`). One dismiss: `theaterGen` +1, one `Hide`, one OnHide, flag false after. `bumpGen` never wrote `theaterGen`; the real double-bump was OnHide re-entry. |
| Next `Proclaim` stuck / hidden after HideAll | **Pass.** Suite: Event void → HideAll hides the root → leftover `flushTimers` → next `Proclaim` accepted and `IsShown`. Reviewer probe without flush: next `Proclaim` still shown. Leftover `THEATER_HOLD` from the first beat then fired by hand: root stays shown. |
| `PlaySound` / `IG_CHARACTER_INFO` on Hide / ESC / HideAll | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Cue remains `Sound:Play(kind)` from `playTheaterCue` on Proclaim show only. Suite pins `#played` unchanged across HideAll. Reviewer spies: `Sound:Play` +0 and `PlaySound` +0 on HideAll. ESC no-sound pin stays. |
| New pins not nested in `runB12D()` (200-local) | **Pass.** B18-C source + functional pins sit after the ESC block and before B15-C, all inside `runB12D()`. File header names that nest. No new main-chunk locals. |
| Existing Proclaim / ESC / UISpecialFrames pins broken | **Pass.** Those asserts stay above the B18-C block in the same function and still pass. `ChurchOfBeefProclaim` stays once after HideAll. `findButton(root) == nil` on ESC and HideAll. |
| Isolated suite not exit 0 | **Pass. Verified.** 382 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`theaterHiding` + HideAll `gen = gen + 1`; nested B18-C pins). Sibling dirt in this workspace is other lanes (Console, Sound, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Console / Sound / glue; no commit | **Pass.** Named-risk check. |
| `HideAll` tears theater down once: `hideTheater` only (no extra `bumpGen`), and OnHide is a no-op while that hide is in flight | **Pass.** Named-risk check. Small-toast `gen` still increments inline so leftover hold / fade timers stay invalid. |
| After HideAll, next `Proclaim` is accepted and the theater root is shown | **Pass.** Named-risk check. |
| Source pin: `HideAll` body does not call both `bumpGen` and `hideTheater` | **Pass.** Live body has `hideTheater` and does not contain `bumpGen`. |
| Nest new pins inside `runB12D()` (Lua 5.1 200-local) | **Pass.** Named-risk check. |
| Existing Proclaim / ESC / UISpecialFrames pins stay | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** First standalone cluster is still **11** nil-module pins. `runB12D()` still re-pins Console / Hud / Records Book / Gora. |
| No `PlaySound` on Hide / ESC / show; no close ✕; clerical copy unchanged; `ChurchOfBeefProclaim` stays on `UISpecialFrames` | **Pass.** File has no `PlaySound` / `CreateFrame("Button"`. `EnableMouse(false)` kept. Packet does not touch `clericalCopy`. Special-frame count stays 1. |
| `lua tests/test_ui.lua` exit 0 | **Pass.** **382 / 0.** |

Bible §19.3 / Law 10 (theatrical Proclaim, no close ✕) and Law 6 (Quiet does not drive this file) hold on the exclusive pair. The B12-D accepted leftover (one HideAll dismiss burning two `theaterGen` values via OnHide re-entry) is closed. `bumpGen` remains the small-toast helper (`interruptShowing`).

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; HideAll vs real ESC vs leftover `THEATER_HOLD` unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Exclusive lane; `run.lua` not edited. |
| `ChurchOfBeefToast` remains ESC-immune | **On contract.** Brief / B12-D forbid registering the small stack. Source pin against `rememberSpecial("ChurchOfBeefToast")` stays. |
| Writer report says leftover timer then Proclaim | **Overclaim.** Live pin is HideAll → `flushTimers` → Proclaim (same shape as B12-D). Brief asked Proclaim → HideAll → Proclaim shown. Reviewer leftover-then-shown probe still shown. |
| Gate W / Gate V stay OPEN; lane unsigned | **On contract.** This review does not sign the lane. |

B18-INT glue is not required. `HideAll` is already the public dismiss; `ResetForTests` already calls it.

---

## Isolation / HideAll / theaterGen

**Isolation wrap — Pass.** Standalone load list is still Common + Ranks + Officer + Roster + DB + MainFrame + Status + Minimap + Toasts; Runtime + Sound are dofiled later for Quiet / cue pins. No `dofile` of Console / Hud / Records Book / Gora / Knighting / Net. First wrap is still 11 nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Reviewer probe: those keys are nil after Toasts load. `runB12D()` still re-pins Console / Hud / Records Book / Gora. Wrap is load-time only (unchanged).

**HideAll — Pass.** Body increments small-toast `gen` once, calls `hideTheater` once, then clears pending / motion / the small stack. It does not call `bumpGen`. `ChurchOfBeefProclaim` is not re-registered. No close button. No cue.

**theaterGen — Pass.** `hideTheater` is the only increment on dismiss. Re-entry from OnHide no-ops while `theaterHiding`. Reviewer spies: one shown HideAll is +1; ESC `root:Hide()` is +1; HideAll while already hidden is +1 (one call, not a double-bump); two HideAlls after a show are +2. Next Proclaim still shows. Leftover first-beat hold cannot hide it.

---

## Strengths

- The real B12-D leftover is closed: OnHide cannot increment `theaterGen` a second time during the HideAll hide. `bumpGen` was never a `theaterGen` writer; the writer still added the re-entry guard instead of only renaming the small-toast increment.
- Next Proclaim is pinned in the same `runB12D()` nest as ESC / UISpecialFrames, so Lua 5.1’s 200-local cap does not fire and those keep-pins still run.
- Small-toast `gen` still moves, so HideAll does not revive a leftover hold / fade. Existing pending / showing HideAll pins stay.
- Cue path is unchanged (`Sound:Play(kind)` on Proclaim only). HideAll / ESC play nothing. Clerical copy and `ChurchOfBeefProclaim` registration were not rewritten.
- Writer-reported **382 / 0** matched the re-run. Writer-reported red (**381 / 1**) matches the new source pin that old `bumpGen()` + `hideTheater` would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **The suite does not pin a single `theaterGen` increment.** The TDD red was only the `bumpGen` string in the `HideAll` body. Proclaim → HideAll → Proclaim already showed before the guard: `Proclaim` itself increments `theaterGen` before it schedules hold, and the pin `flushTimer`s while the root is already hidden. Dropping `theaterHiding` would still go green. Live code and reviewer spies close the law; the nested pins do not.

### Nit

1. **Source pin is `not (has bumpGen and has hideTheater)`.** It passes if `HideAll` calls neither. The functional hide pin covers teardown. Live body does call `hideTheater`.

2. **`gen = gen + 1` is a source-pin dodge of `bumpGen()`.** Functionally the same small-toast increment `HideAll` already needed. Brief forbade calling both names, not killing small-toast `gen`.

3. **Writer report overclaims leftover-timer order.** Brief asked Proclaim → HideAll → Proclaim shown. The pin flushes before the second Proclaim, same as B12-D.

4. **`HideAll` body regex requires `ResetForTests` to stay the next function.** Brief did not forbid a later helper between them. Harmless today.

5. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the B18-C-only guard + inlined `gen` + nested pins. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **382 / 0** was re-run here.

7. **Isolation wrap is load-only.** Eleven pins under the first `if standalone then`; four re-pins at the end of `runB12D()`. Brief said the wrap stays; it did.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **382 passed, 0 failed.** Isolation wrap: **11**.

`HideAll` no longer calls `bumpGen` beside `hideTheater`. `hideTheater` re-entry from OnHide is a no-op, so one dismiss increments `theaterGen` once. Next `Proclaim` is still accepted and the theater root shows. HideAll plays no sound, adds no close ✕, and leaves `ChurchOfBeefProclaim` on `UISpecialFrames` once. New pins live in `runB12D()`. Isolation wrap stays. Isolated `lua tests/test_ui.lua` **382 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
