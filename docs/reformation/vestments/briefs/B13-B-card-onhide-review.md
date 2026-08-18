Spec PASS

# B13-B — Fighter card OnHide lastView (review)

**Quality:** Approved-with-nits

**Lane:** B13-B Fighter card OnHide lastView
**Brief:** `docs/reformation/vestments/briefs/B13-B-card-onhide.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B13-B-card-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B13-B-card-onhide.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/FighterCard.lua` (`OnHide` / `hiding` / `paintHidden` / `forgetPersist` / `Hide`), and `tests/test_fighter_card.lua` (source `OnHide`, `stub.fire` / `frame:Hide` lastView pins, persist, QUIET forget, isolation wrap); then ran `lua tests/test_fighter_card.lua` and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet hides Event chrome); Law 10 / §19.3 (theatrical card, stock ESC, no close ✕); B12-C leftover that ESC `Hide()`s the named widget, not `FighterCard:Hide()`. Did not mutate `FighterCard.lua` or `test_fighter_card.lua`. Did not edit Hud, glue, or Toasts. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Widget `Hide` leaves `lastView.shown` true | **Pass. Verified.** `SetScript("OnHide")` after the create-time `Hide`. Handler writes `lastView = hiddenView()` before the `hiding` check. Live card: `stub.fire(frame, "OnHide")` and `frame:Hide()` both pin `GetView().shown == false`. Widget is dismissed (`IsShown() == false` on the `frame:Hide()` path). |
| `lastPair` forgotten before QUIET | **Pass.** `OnHide` does not call `forgetPersist`. `paintHidden` / `FighterCard:Hide()` still do not. `forgetPersist` remains `Refresh` / `Show` when not `eventLive`, plus `ResetForTests`. Suite Refresh after fire / widget Hide still paints Chuckroast / Tendermage. Reviewer probe (not in the suite): `DeclareVictor` (live pair nil) then widget `Hide` then `Refresh` still paints Chuckroast; widget `Hide` then `DeclareVictor` then `Refresh` still paints. QUIET `Refresh` still forgets; later ASSEMBLY does not revive. |
| Infinite OnHide recursion | **Pass.** `paintHidden` sets `hiding` before `frame:Hide()` and clears it after. `OnHide` returns when `hiding` is already true. Suite: second `FighterCard:Hide()`, `stub.fire` while hidden, then Refresh — no hang. Isolated run completed. Stub `Hide` is transition-only; the guard is for `fire` while shown (`OnHide` → `paintHidden` → `Hide` → `OnHide` again). |
| `PlaySound` / close ✕ / `UnitHealth` | **Pass.** Live source has no `PlaySound`, `PlaySoundFile`, `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `C_NamePlate`, `ShowUIPanel`, `StatusBar`, or `✕`. No `CreateFrame("Button"`. `countType(frame, "Button") == 0`. `EnableMouse(false)` unchanged. Suite stubs those APIs; OnHide block and suite end pin `sounds == 0` and `healthReads == 0`. `health` stays nil. |
| Isolated suite not exit 0 | **Pass. Verified.** Reviewer ran `lua tests/test_fighter_card.lua` on Lua **5.1.5**: **482 passed, 0 failed**, exit 0. Matches the writer report. Isolation cluster is still `if standalone then` (**17** nil-module pins). Wrap was not rewritten. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud, glue, Toasts; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/FighterCard.lua` and `tests/test_fighter_card.lua`. Live B13-B sites match that slice (`hiding` + `OnHide` after create `Hide`; new OnHide block + rebuild `GetScript` pin). |
| Hook `OnHide` to set `lastView` to the hidden view **without** forgetting lastPair | **Pass.** Named-risk check. Handler is `lastView = hiddenView()` then, if not already hiding, `paintHidden()`. |
| `paintHidden` / `Hide()` must not recurse forever | **Pass.** Named-risk check. Double guard: `OnHide` and `paintHidden` both bail when `hiding`. |
| Show a live card; `stub.fire` or `frame:Hide()` → `GetView().shown == false` | **Pass.** Both paths are pinned. |
| Refresh while the event is live still paints the remembered pair | **Pass.** After fire and after widget Hide: `shown == true`, names Chuckroast / Tendermage, widget shown. Subjects Hide+Refresh pin from B10-C stays. |
| QUIET still forgets | **Pass.** `EndEvent` then `Refresh`: `shown == false`; later `StartEvent` Refresh does not revive. Existing ASSEMBLY-after-QUIET block stays. |
| Isolation wrap stays | **Pass.** 17 nil-module pins still under `if standalone then`. |
| No close ✕; no `PlaySound`; no `UnitHealth`; lastPair until QUIET | **Pass.** Named-risk checks. |
| `lua tests/test_fighter_card.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 482 / 0. Writer claimed that polish ceiling and no more. |

Bible §10.6 / §10.7 (mute tape; persist through the verdict), Law 6 (Quiet hides Event chrome), Law 10 (stock FrameXML ESC, no close-button joke chrome), and the B3-B / B4-E / B6-D / B8-C / B10-C / B12-C mute-tape pins hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; harness pins `OnHide` via `stub.fire` and `frame:Hide()`, not a live Escape key | **Not a spec miss.** Brief asked isolated green. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Harness `Hide()` is transition-only; already-hidden `Hide()` does not re-fire `OnHide` | **Not a miss.** Matches client FrameXML. The `hiding` guard is for `fire` while shown. Suite uses `stub.fire` for the already-hidden path. |
| A01 still NOT RUN; `health` is nil; no `UnitHealth` | **Not a miss.** Brief forbade opening it. |
| Hud / Toasts / glue were not edited | **Not a miss.** Exclusive card-only OnHide. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. Already listed. |

---

## Strengths

- The B12-C leftover is the actual fix: ESC / widget `Hide()` now writes `lastView.shown = false`. `OnHide` does not call `forgetPersist`.
- Recursion guard is the brief's shape: flag set before `frame:Hide()`, `OnHide` returns on re-entry, flag cleared after. Create-time `Hide` is still before `SetScript`, so mint does not run teardown.
- Mute tape stayed mute: no close ✕, no `ShowUIPanel`, no `UnitHealth`, no sound on OnHide, no `StatusBar`. Painted W–L / H2H stay `1-0`.
- Isolation stayed gated (17). Writer-reported 482 / 0 matches the reviewer run (448 prior ESC suite + the OnHide block).

---

## Must-fix

None.

---

## Leftover (Minor)

1. **New “did not forget lastPair” pins are live-pair pins.** After `stub.fire` / `frame:Hide()`, `Gora:GetSanctioned()` is still non-nil, so `Refresh` would repaint even if `OnHide` had called `forgetPersist()`. The product path is still correct (`forgetPersist` is not in `OnHide` / `paintHidden`; reviewer probe after `DeclareVictor` still persists). The suite does not pin that combination.

2. **`src:find("OnHide")` is satisfied by the file header comment.** The runtime pin is `frame:GetScript("OnHide") ~= nil` (and the rebuild copy). A deleted `SetScript` that left the comment would still pass the source string.

3. **`stub.fire` while shown is not pinned as a widget dismiss.** Fire → `paintHidden` does `Hide()` the widget (reviewer probe: `IsShown() == false`). The suite only pins `GetView().shown` on that path, then Refresh.

4. **No `/reload` smoke and no `CloseSpecialWindows` fire.** The suite pins the script and widget `Hide()`. It never hides via the FrameXML loop. **POLISH:CANDIDATE** only.

5. **Harness `CreateFrame` does not mint `_G[FRAME_NAME]`.** Production CreateFrame-with-a-name does; Anniversary `CloseSpecialWindows` looks up that global. Pre-existing B12-C leftover.

6. **Glue can undo ESC.** `showFighterCard` is `Show` then `Refresh`. Inbound STATE with two fighter ids does the same. That is the specified persist contract (Refresh after Hide still paints). On a live event, ESC is a temporary dismiss until the next Show/Refresh.

7. **B10-C Refresh-lazy forget is unchanged.** `Hide()` / `OnHide` never forget. Glue `afterEndEvent` still `Hide()`s without `Refresh`. A QUIET Hide that never Refreshs can revive on a later ASSEMBLY Refresh. Pre-existing; not opened by this lane.

8. **`hiding` is not cleared on error.** If `paintHidden` threw between `hiding = true` and `hiding = false`, later `paintHidden` would no-op the widget Hide. Single-threaded Lua; plates are FontStrings. Not a client miss.

9. **No full `lua tests/run.lua`.** Isolated 482 / 0 was re-run here. That does not prove the client path.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

This is the B13-B vestment contract: widget `Hide` / `OnHide` syncs `lastView.shown` to false without forgetting `lastPair` until QUIET; `paintHidden` / `Hide` cannot recurse forever; no close ✕, no `PlaySound`, no `UnitHealth`. Named risks are clean. Isolated suite is green.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
