Spec PASS

# B19-B — Small toast ESC via UISpecialFrames (review)

**Quality:** Approved-with-nits

**Lane:** B19-B Small toast ESC via UISpecialFrames
**Brief:** `docs/reformation/vestments/briefs/B19-B-toast-esc.md`
**Writer report:** `docs/reformation/vestments/briefs/B19-B-toast-esc-report.md`
**Diff:** `docs/reformation/vestments/briefs/B19-B-toast-esc.diff` (B19-B-only exclusive-pair packet; live `Toasts.lua` / `test_ui.lua` also carry earlier toast / Quiet-shell / HideAll batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Toasts.lua` (`Init` after the create-time `Hide`: type-guarded `OnHide` → `showing = nil`, then `rememberSpecial("ChurchOfBeefToast")`), and `tests/test_ui.lua` (`runB12D()` B12-D / B15-C / B18-C pins, inverted toast-absent pins, nested B19-B block, isolation wrap); then ran `lua tests/test_ui.lua` (**415 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki "Make frames closable with the Escape key" (named frame on `UISpecialFrames`); Law 6 (Quiet does not drive this file; no Quiet toast kind); Law 10 / Bible §19.3 (no close ✕; clerical copy unchanged); CONTINUE 2026-08-18 license 4 (stock only; no `PlaySound` / `IG_CHARACTER_INFO_*`). Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. Did not edit Console, Sound, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `ChurchOfBeefToast` still ESC-immune / duplicated on `UISpecialFrames` | **Pass. Verified.** Named `CreateFrame("Frame", "ChurchOfBeefToast", …)`. `Init` calls `rememberSpecial("ChurchOfBeefToast")` after the create-time `Hide`. Helper type-guards a missing table and dedupes by name. Pins: after Init / second Init / ESC Hide / small Hide beside theater, listed once. B12-D toast-absent pins inverted (source `rememberSpecial`; `countSpecial == 1` after Proclaim). Reviewer probe: `UISpecialFrames = nil` still mints the widget and leaves the global nil; restore + recreate lists once. |
| ESC Hide leaves `showing` set (pump stuck) | **Pass. Verified.** Small `OnHide` sets `self.showing = nil` only. Pins: Hide clears `ShowingKind`; later `Show` presents new copy. Reviewer probe: leftover hold timer after Hide does not restore `ShowingKind` or re-show; queued toast stays pending; next `Show` pumps (not stuck). |
| Small-toast `OnHide` calls `hideTheater` | **Pass. Verified.** `Init` body has no `hideTheater`. Live `hideTheater(` call sites are proclaim `OnHide` and `HideAll` only. Pin: theater root stays shown across small Hide. Reviewer spy: wrapped theater `root.Hide` saw **0** calls. |
| `PlaySound` / `IG_CHARACTER_INFO_*` on show / hide / ESC | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Cue remains `Sound:Play(kind)` from `playTheaterCue` on Proclaim show only. `Init` / small `OnHide` / `HideAll` do not play. Suite pins `#played` unchanged across toast Hide. Reviewer spy: `PlaySound` count stays 0 on Push Hide / HideAll / Init. |
| Close ✕ / new cue / Quiet toast kind / clerical rewrite | **Pass.** Diff does not touch `clericalCopy`, `KINDS`, `THEATER_KINDS`, or `Sound.lua`. `KINDS` stays system / debug. `EnableMouse(false)` stays; no `CreateFrame("Button")` / CloseButton / ✕. Pin: `findButton(frame) == nil`. Quiet `Proclaim` still returns `"quiet"`. |
| `ChurchOfBeefProclaim` special-frame / OnHide teardown broken | **Pass.** Proclaim once-pins stay through toast register, second Init, ESC Hide, and small Hide beside theater. Theatrical `OnHide` still → `hideTheater`. B12-D leftover-Hide and B18-C HideAll pins stay in the same `runB12D()`. |
| Isolated suite not exit 0 / pins not in `runB12D()` | **Pass. Verified.** 415 passed, 0 failed. Writer-reported count matches. New locals live in `runB12D()`. Isolation wrap stays under the first `if standalone then`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`Init` OnHide + `rememberSpecial`; inverted B12-D pins + nested B19-B block). Sibling dirt in this workspace is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, Sound, glue; no commit | **Pass.** Named-risk check. |
| `rememberSpecial("ChurchOfBeefToast")` from `Init` (existing dedupe helper); missing table no-ops | **Pass.** Named-risk check. Literal call is in `Init`, not a bare `insert`. |
| Wire `OnHide` on the small frame so ESC Hide syncs `showing` (nil) and does not leave the pump stuck | **Pass.** Named-risk check. Wired after the create-time `Hide` (`if not existing`). Does not `pump` from `OnHide`; next Push / Show does. |
| Do not call theater `hideTheater` from the small-toast `OnHide` | **Pass.** Named-risk check. |
| Do not `PlaySound` on show / hide / ESC (`IG_CHARACTER_INFO_*` forbidden) | **Pass.** Named-risk check. |
| `ChurchOfBeefProclaim` stays; no close ✕; no new cue; clerical copy unchanged | **Pass.** Named-risk check. |
| Quiet still does not drive this file; do not mint a Quiet toast kind | **Pass.** `theaterAllowed` still refuses missing Runtime / `QUIET`. `KINDS` unchanged. Probe: Quiet `Proclaim` → `false, "quiet"`. |
| After Init (or Show/Push): listed once; Hide clears `ShowingKind`; later Push/Show still works; Proclaim pins stay; isolation wrap stays; nest in `runB12D()` | **Pass.** Nested after B15-C / B18-C. Second Init does not duplicate. |
| `lua tests/test_ui.lua` exit 0 | **Pass.** **415 / 0.** |

Wiki ESC registration, Law 6 (no Quiet toast kind; Quiet does not drive theater), Law 10 (no close ✕; clerical copy), and license 4 (stock; no new cue / `IG_CHARACTER_INFO_*`) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary | **Not a miss.** Brief asked isolated green + registration + OnHide sync. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked registration + Hide simulating ESC. |
| ESC does not drain `pending`; a queued toast waits until the next Push / Show pumps | **On contract.** Brief: sync `showing` nil so the pump is not stuck; later Push/Show still works. Pin and probe both keep the leftover row and pump on the next Show. |
| `Init` early-return does not re-call `rememberSpecial` | **On contract.** First create registers; second Init is idempotent on the widget. Brief asked listed once, not re-register on every Init. |

---

## Isolation / OnHide / pump

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net. New asserts sit in `runB12D()` so Lua 5.1’s 200-local cap does not fire.

**OnHide / register — Pass.** Create-time `Hide` is before `SetScript("OnHide")`, so mint does not clear `showing`. Handler is `self.showing = nil` only: no `hideTheater`, no `PlaySound`, no `pump`, no `bumpGen`. `rememberSpecial` is the existing helper (type-guard + name dedupe). `if self.frame then return` still skips a second wire / second register.

**Pump not stuck — Pass.** After Hide, `ShowingKind` is nil, so `Push` / `Show` takes the `if not self.showing then pump` branch. Leftover hold is saved by `if self.showing ~= envelope then return`. Pending is not drained here; the next Show presents the leftover first, then the new row waits. That matches the brief’s later-Push/Show pin, not a stuck `showing`.

---

## Strengths

- The delta is the brief: Decree-shaped `rememberSpecial("ChurchOfBeefToast")`, small `OnHide` → `showing = nil`, wired after the create-time `Hide`, no `hideTheater`, no `PlaySound`.
- Theater and small stack stay separate. Proclaim once-pins and leftover-Hide / HideAll pins were left in the same `runB12D()` nest. Small Hide spy does not touch the proclaim root.
- B12-D’s toast-absent pins were inverted in place instead of a second fixture language. Cue path is unchanged (`Sound:Play` from Proclaim only). Clerical strings and `KINDS` were not rewritten.
- Isolation stayed gated. New locals are inside `runB12D()`. Writer-reported **415 / 0** matched the re-run. Writer-reported red (**402 / 13**) matches the inverted + behavior pins that old Init (no register / no OnHide sync) would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. `ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, and `ChurchOfBeefToast` now share the list; one real ESC may hide all three. Brief asked registration + OnHide sync, not a client walk. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

2. **Harness `Hide()` is not ESC.** Registration and OnHide sync are pinned. The client’s special-frame walk is not. Stub `CreateFrame` also does not mint `_G["ChurchOfBeefToast"]` (reviewer probe: `_G.ChurchOfBeefToast == nil`); production `CreateFrame("Frame", "ChurchOfBeefToast", …)` does. Same stub gap B12-D named for Proclaim.

### Nit

1. **ESC does not `pump` pending.** OnHide only clears `showing`. Probe: Hide with one queued row leaves `PendingCount() == 1`; the next `Show` presents the leftover first. Writer already named this. Brief does not ask a drain.

2. **`Init` early-return does not re-`rememberSpecial`.** Probe: wipe the list, second Init leaves count 0; nil `self.frame` then Init registers once. First create is the live path. Proclaim’s `InitTheater` early-return still re-calls `wireProclaimEsc`; this lane does not copy that.

3. **Early inverted `countSpecial("ChurchOfBeefToast") == 1` after Proclaim is order-dependent.** Proclaim does not `Init` the small stack. That pin is green because an earlier main-chunk `Show` already registered. The later B19-B `Init()` pins are the independent register check.

4. **OnHide does not `bumpGen` / `stopMotion`.** Leftover hold is gen-unguarded except the `showing ~= envelope` check (probe: flush after Hide does not re-show). Production fade-in may still tick alpha on a hidden widget until the next `present`. Harmless; next Show `resetAnchor`s.

5. **Exclusive-pair diff is not a vs-HEAD Toasts delta.** Packet is the B19-B-only OnHide + pins. `git diff HEAD` on the two files still includes earlier toast / Quiet-shell / HideAll batches. Report already says this.

6. **No full `lua tests/run.lua`.** Isolated **415 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **415 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**.

`ChurchOfBeefToast` is named and `rememberSpecial`’d onto `UISpecialFrames` once. Small `OnHide` syncs `showing` to nil, does not call `hideTheater`, and does not `PlaySound`. Hide simulating ESC clears `ShowingKind`; a later Show still presents. `ChurchOfBeefProclaim` stays listed once. Quiet still refuses Proclaim; no Quiet toast kind. Pins live in `runB12D()`. Isolated `lua tests/test_ui.lua` **415 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
