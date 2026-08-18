Spec PASS

# B12-D — Proclaim ESC dismiss (review)

**Quality:** Approved-with-nits

**Lane:** B12-D Proclaim ESC dismiss
**Brief:** `docs/reformation/vestments/briefs/B12-D-toast-esc.md`
**Writer report:** `docs/reformation/vestments/briefs/B12-D-toast-esc-report.md`
**Diff:** `docs/reformation/vestments/briefs/B12-D-toast-esc.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/Toasts.lua`, and `tests/test_ui.lua`; then ran `lua tests/test_ui.lua`. Isolated result: **345 passed, 0 failed**, exit 0, Lua **5.1.5**. Law cited: wiki "Make frames closable with the Escape key"; Bible §19.3 / Law 10 (theatrical Proclaim, no close ✕); Law 6 (Quiet does not drive this file); CONTINUE 2026-08-18 license 4 (stock only). Did not mutate `Toasts.lua` or `test_ui.lua`. Did not commit. This review does not sign the lane.

HideAll double-bump of `theaterGen` is an accepted leftover.

---

## Named gates (must-fix)

| Gate | Verdict |
|---|---|
| `ChurchOfBeefProclaim` on `UISpecialFrames` | **Pass.** `PROCLAIM_NAME = "ChurchOfBeefProclaim"`. `CreateFrame("Frame", PROCLAIM_NAME, UIParent)`. `rememberSpecial(PROCLAIM_NAME)` from `wireProclaimEsc` after the create-time `Hide`, and again on the early-return `InitTheater` path. Type-guard: `type(UISpecialFrames) ~= "table"` no-ops. Dedupe by name before append. After Proclaim: listed once; second `InitTheater` / second Proclaim do not duplicate. |
| `ChurchOfBeefToast` not registered | **Pass.** `Toasts:Init` still names `ChurchOfBeefToast` and never calls `rememberSpecial`. Live `rememberSpecial` is only invoked with `PROCLAIM_NAME`. After Proclaim (toast stack already minted earlier in the suite): `countSpecial("ChurchOfBeefToast") == 0`. |
| `OnHide` teardown | **Pass.** `SetScript("OnHide")` → `hideTheater` (gen bump + `Hide`). Wired after the initial `Hide` so mint does not tear down. Stub `Hide` is transition-only, so the inner `Hide` from `hideTheater` does not re-enter. ESC `Hide` then leftover timer then next Proclaim still shows. |
| No `PlaySound` / `IG_CHARACTER_INFO` on ESC | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Cue remains `Sound:Play(kind)` from `playTheaterCue` on Proclaim show only. `hideTheater` / `OnHide` do not play. Suite pins `#played` unchanged across ESC `Hide`. |
| No new sound names | **Pass.** Exclusive diff does not touch `Sound.lua` or `THEATER_KINDS`. `playTheaterCue` still `pcall` → `sound:Play(kind)` with the existing five theater kinds. |
| Clerical copy intact | **Pass.** Exclusive diff does not touch `clericalCopy`. Pins still exact: `A Beef Gora is Sanctioned`, `Cowardice recorded: Thickcut. So ruled by the Beef Pope.`, `Victor declared: Thickcut.`, `Void.`, `The bout is set aside.`, `Free ruling.`, `RISE, BEEF KNIGHT\nBeefina`, `RISE, BEEF LORD\nJuicyj`. No `"found worthy"`. Morpheus / no-`SendChatMessage` pins stay. |
| Isolated suite exit 0 | **Pass.** Reviewer ran `lua tests/test_ui.lua`: **345 passed, 0 failed**, exit 0. Matches the writer report. Isolation asserts and the standalone summary stay under `if standalone then`. New locals live in `runB12D()`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit FighterCard, Sound, glue; no commit | **Pass.** Provided diff is two hunks: `UI/Toasts.lua` and `tests/test_ui.lua`. Live B12-D sites match that slice (`rememberSpecial` / `wireProclaimEsc` / `runB12D()`). |
| Register theatrical root `ChurchOfBeefProclaim` on `UISpecialFrames` (dedupe); type-guard a missing table | **Pass.** Named-gate check. Decree-shaped helper. |
| ESC `Hide()`s that root; hook `OnHide` so `hideTheater` (or equivalent gen bump) runs | **Pass.** Named-gate check. Leftover Hide does not stick the next Proclaim. |
| Do **not** put `ChurchOfBeefToast` on `UISpecialFrames` | **Pass.** Named-gate check. |
| Quiet Mode still does not drive this file | **Pass.** `theaterAllowed` still refuses missing Runtime, nil snapshot, and `state == "QUIET"` before copy, show, chat, or Sound. Quiet / missing-Runtime pins stay. |
| Stock only; no new sound names; clerical copy only; no close ✕ | **Pass.** Named-gate checks. `EnableMouse(false)` kept. `findButton(root) == nil` on the ESC path. |
| Source contains `UISpecialFrames`; existing clerical / Morpheus / no-`SendChatMessage` pins stay; isolation wrap stays | **Pass.** `runB12D()` re-pins source `UISpecialFrames`, Morpheus, and `SendChatMessage(`. Isolation cluster unchanged. |
| `lua tests/test_ui.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 345 / 0. Writer claimed that ceiling and no more. |

Wiki ESC registration, Law 10 (no close ✕ on theater), Law 6 (Quiet does not drive toasts), and license 4 (stock, no new cue names) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; ESC vs `UISpecialFrames` order (Proclaim shares the list with `ChurchOfBeefFrame`) unproven on Anniversary | **Not a spec miss.** Brief asked isolated green + registration + OnHide teardown. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| `hideTheater` from `OnHide` double-bumps `theaterGen` on the HideAll path | **Accepted leftover.** Harmless; leftover timers stay invalid. |
| Small toast stack remains ESC-immune | **Not a miss.** Brief forbids registering `ChurchOfBeefToast`. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked registration + OnHide teardown, not a `CloseSpecialWindows` walk. |

---

## Strengths

- The delta is the brief: Decree-shaped `rememberSpecial`, `OnHide` → `hideTheater`, register `ChurchOfBeefProclaim` only, wire after the create-time `Hide`.
- Early-return `InitTheater` re-calls `wireProclaimEsc` so a second mint path still dedupes instead of skipping registration.
- Leftover-timer pin is the real teardown test, not only `GetScript("OnHide") ~= nil`.
- Cue path is unchanged (`Sound:Play(kind)`). ESC Hide plays nothing. Clerical strings were not rewritten.
- Isolation stayed gated. New asserts sit in `runB12D()` so Lua 5.1’s 200-local cap does not fire. Isolated **345 / 0** was re-run here and matches the writer report.

---

## Must-fix

None.

---

## Leftover (Minor)

1. **No `/reload` smoke.** `CloseSpecialWindows` order vs `ChurchOfBeefFrame` (and any other named special frames) is unproven on Anniversary. One ESC may hide every shown special frame. **POLISH:CANDIDATE** only.

2. **Harness `Hide()` is not ESC.** Registration and OnHide teardown are pinned. The client’s special-frame walk is not. Stub `CreateFrame` also does not mint `_G[name]` (except FauxScrollFrame bars); production `CreateFrame("Frame", PROCLAIM_NAME, …)` does. That does not fail the brief.

3. **HideAll double-bumps `theaterGen`.** `hideTheater` `Hide` → `OnHide` → `hideTheater` again. Accepted leftover. Harmless.

4. **Source “does not register toast” pins are literal.** They look for `rememberSpecial("ChurchOfBeefToast")` and `insert(UISpecialFrames, "ChurchOfBeefToast")`. Live append is `UISpecialFrames[#UISpecialFrames + 1] = name` with `PROCLAIM_NAME`. The runtime `countSpecial("ChurchOfBeefToast") == 0` pin (after `Init` has already minted the small stack) is the real gate.

5. **Missing-table type-guard is un-pinned.** `rememberSpecial` no-ops when `UISpecialFrames` is not a table. B12-C pinned that path; B12-D does not. Live code still has the guard.

6. **`#played` is the Sound:Play wrapper, not `PlaySound`.** Combined with the source `IG_CHARACTER_INFO` pin and a live-file grep of zero `PlaySound` calls, ESC is still silent. A later `PlaySound` of a different kit name could miss both pins.

7. **No full `lua tests/run.lua`.** Isolated 345 / 0 was re-run here. Runner listing was not (exclusive lane; `run.lua` not edited).

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

This is the B12-D contract: `ChurchOfBeefProclaim` is on `UISpecialFrames` once; `ChurchOfBeefToast` is not; `OnHide` runs `hideTheater`; ESC Hide does not play `PlaySound` / `IG_CHARACTER_INFO` and does not stick the next Proclaim; clerical copy / Morpheus / no-`SendChatMessage` pins stay; isolated suite green. Named must-fix gates are clean. The nits cluster on client ESC vs harness `Hide`, the accepted HideAll gen double-bump, and brittle source pins for the toast-stack exclusion.

Isolated **345 passed, 0 failed** verified. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
