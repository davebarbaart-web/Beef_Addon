Spec PASS

# B29-C — Fighter card Show / Refresh restore a missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B29-C Fighter card Show / Refresh restore a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B29-C-card-show-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B29-C-card-show-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B29-C-card-show-onhide.diff` (B29-C-only exclusive-pair packet; live `FighterCard.lua` also carries earlier card batches vs HEAD / untracked tree)
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/FighterCard.lua` (`wireCardOnHide` / `build` / `FighterCard:Init` / `Refresh` / `Show` / `Hide` / `paintHidden` / `hiddenView` / `forgetPersist` / `rememberSpecial` / `NAME_FONT`), and `tests/test_fighter_card.lua` (isolation wrap, persist / health-nil / Morpheus / B28-D Init pins, nested `runB29C()` inside `runB28D()` after the B28-D pins); then ran `lua tests/test_fighter_card.lua` (**574 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); B28 leftover: `Show` / `Refresh` skipped a niled OnHide when the frame already existed; when the frame exists, `Show` and `Refresh` call `wireCardOnHide(frame)`; do not replace an existing script; do not rebuild; Init remount stays; no `UnitHealth`; lastPair until QUIET; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Did not mutate `FighterCard.lua` or `test_fighter_card.lua`. Did not commit. Did not edit Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Show` / `Refresh` still skip a missing OnHide when the frame exists (B28 leftover) | **Pass. Verified.** Live exists-paths call `wireCardOnHide(frame)` after the nil-frame `Init` branch. Helper wires only when `GetScript("OnHide")` is nil. Pins: `SetScript("OnHide", nil)`, Show restores; nil again, Refresh restores. Reviewer probe: niled script, Show, `GetScript` is a function; wrapped `SetScript` saw **1** call named `OnHide`. Same for Refresh. |
| `Show` / `Refresh` replace an existing script | **Pass. Verified.** Helper is `if existing then return`. Pins: third Show after Refresh restore keeps `afterRefresh`. Reviewer spy: wrapped `SetScript` saw **0** OnHide calls on Show / Refresh with the restored script and with a sentinel OnHide. Create-path / sentinel identity stayed. |
| Restore rebuilds or duplicates `ChurchOfBeefFighterCard` | **Pass. Verified.** `Show` / `Refresh` still use the existing `frame`. Pins: niled Show / Refresh / third Show `createCalls` 0. Reviewer probe: `CreateFrame` delta **0** across remounts, third Show, Init remount, sentinel Show / Refresh. No new `CreateFrame` on the exists-path. |
| Restored handler is not the create OnHide (`lastView` / `paintHidden` / `hiding` / `forgetPersist` / `PlaySound`) | **Pass.** Create, Init, Show, and Refresh all call `wireCardOnHide`. Live handler is still `lastView = hiddenView()` then `paintHidden` unless `hiding`. Helper has no `forgetPersist`, `PlaySound`, or `CreateFrame`. Pins: restored fire sets `lastView.shown` false; Refresh still paints Chuckroast / Tendermage; `health` nil. Reviewer probe: same pair after restore; source has no `PlaySound` / `UnitHealth`. |
| Init remount dropped; lastPair forgotten on remount OnHide; ASSEMBLY after QUIET revives; `NAME_FONT` / `UnitHealth` / close ✕ | **Pass. Verified.** Live `Init` is still `build()` if `frame` is nil, then `wireCardOnHide(frame)`, `rememberSpecial`, `Refresh`. `forgetPersist` still lives only on Quiet / `ResetForTests`. Pins: B28-D Init remount / third-Init identity stay above `runB29C()`; B29-C re-reads Init `wireCardOnHide`; restored OnHide does not clear `Gora:GetSanctioned()`; Refresh paints both names; suite persist / ASSEMBLY-after-QUIET / Morpheus / health-nil pins stay. Reviewer probe: Init still remounts a niled script; EndEvent then Refresh is hidden; later StartEvent still hidden. Live `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. Source has no `UnitHealth`, `CloseButton`, `✕`, `CreateFrame("Button"`, or `MORPHEUS_CYR`. Reviewer probe: `countType(widget, "Button")` is **0**. |
| Existing persist / health-nil / Morpheus / B28-D Init / isolation pins drop | **Pass. Verified.** Those blocks sit above `runB29C()`. Isolation wrap is still **17** nils under `if standalone then`. Suite green includes those asserts. Reviewer probe: wrap keys (Net / UI / Hud / Toasts / Console / Decree / RecordsBook / Sound) are nil at load. |
| Isolated suite not exit 0 / new main-chunk pin block | **Pass. Verified.** 574 passed, 0 failed. Writer-reported count matches. New pin locals live in `runB29C()` nested inside `runB28D()`. Isolation wrap stays under the load-time standalone block. `luac -l -p`: main chunk **59** locals (cap 200; same as B28-D). |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two unified hunks (Show / Refresh exists-path `wireCardOnHide`; header comment + nested `runB29C()`). Sibling dirt in this workspace is other lanes (`Hud.lua`, `ChurchOfBeef.lua`, `tests/run.lua`). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud, glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Seventeen `dofile`-neighbor nils unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| When the frame exists, `Show` and `Refresh` call `wireCardOnHide(frame)` | **Pass.** Named-risk check. |
| Do not replace an existing script; do not rebuild | **Pass.** Named-risk check. |
| Init remount stays | **Pass.** Named-risk check. |
| Nil the OnHide, Show: script restored. Nil again, Refresh: restored. Third Show with the script already set: identity stays | **Pass.** Named-risk check. |
| Existing persist / health-nil / Morpheus / B28-D Init pins stay | **Pass.** Named-risk check. |
| No `UnitHealth`; no close button; lastPair until QUIET; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`; no `PlaySound` | **Pass.** Named-risk check. |
| Nest new pins; isolation wrap stays; `lua tests/test_fighter_card.lua` exit 0 | **Pass.** **574 / 0.** |

B28 leftover (`Show` / `Refresh` skipped a niled OnHide when the frame already existed, so glue that remounts only via Show / Refresh dropped ESC lastView sync) is closed on the Show / Refresh exists-paths. Init remount from B28-D stays. Law 6 (Quiet after End does not keep the card), Law 10 (no close ✕), §10.6 mute tape (no `UnitHealth`, no `PlaySound`), lastPair until QUIET, and B20-C Morpheus hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary ESC vs `CloseSpecialWindows` order is unproven | **Not a miss.** Brief asked isolated green + restore a niled OnHide + third-Show identity. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` / `stub.fire` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity and lastView sync. The client's special-frame walk is not. |
| `Hide` still does not remount OnHide | **On contract.** Brief scoped Show / Refresh. Reviewer probe: niled OnHide stays nil across `Hide()`; Show / Refresh / Init restore. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / restore / persist

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Runtime + Gora + FighterCard. No `dofile` of Hud, UI shell, Net, DB, or glue. Standalone wrap is still 17 nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, DecreeBanner, RecordsBook). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). New asserts sit in `runB29C()` inside `runB28D()` so Lua 5.1's 200-local cap does not fire.

**Restore — Pass.** `Show` and `Refresh` call `wireCardOnHide` on the exists-path (no inline `SetScript`). The helper no-ops when a script exists and writes `lastView = hiddenView()` then `paintHidden` unless `hiding` only when OnHide is nil. Init remount is unchanged. Reviewer spy: restore `SetScript` delta 1 named OnHide on niled Show and on niled Refresh; existing / sentinel / third Show delta 0. `CreateFrame` delta 0 on remounts. A niled OnShow is not restored. `Hide()` still does not remount.

**Persist — Pass.** Restored OnHide still syncs `lastView` without `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. Reviewer probe: EndEvent then Refresh is hidden; ASSEMBLY after QUIET does not revive. `health` stays nil. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.

---

## Strengths

- The delta is the brief: two `wireCardOnHide(frame)` calls on the Show / Refresh exists-paths. An existing script is not replaced. The widget is not rebuilt. Init remount stays. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B28 leftover (niled OnHide stayed nil across Show / Refresh; fire then skipped `lastView` / `paintHidden`) is closed with a runtime restore, not only a source `find`. The restored handler is then proven to hide the view and leave lastPair, so a no-op restore would fail.
- Third-Show identity, `CreateFrame` 0, and Refresh lastPair / health-nil sit next to the restore pins, so a rebuild or a replace-every-Show helper would fail.
- Persist / health-nil / Morpheus / B28-D Init / isolation pins were left above the nest. Isolation stayed gated. New locals are inside `runB29C()` inside `runB28D()`.
- Writer-reported **574 / 0** matched the re-run. Writer-reported red (**568 / 6**) matches the exists-path-missing-helper + niled-stayed-nil + fire/lastView cluster that pre-B29-C Show / Refresh would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Hide` still skips a missing OnHide.** Reviewer probe: niled script stays nil across `FighterCard:Hide()`; Show / Refresh / Init restore. Brief scoped Show / Refresh. Glue that only Hide()s a niled script would still drop ESC lastView sync until the next Show / Refresh / Init.

2. **Handler-less Hide before remount still leaves stale `lastView.shown`.** Reviewer probe: Show, nil OnHide, `Hide()` (stub does not fire a missing script), view stays `shown == true` while `IsShown` is false. Next Show / Refresh paints the live pair again. Brief scoped restore of the missing script, not a shown-repair of the lost Hide.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the card with other listed chrome. Brief asked isolated restore + identity, not a client walk.

### Nit

1. **Third-Show identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

2. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. `runB29C()` does not re-pin them. Brief said the wrap stays; it did.

3. **Exclusive-pair diff is not a vs-HEAD FighterCard delta.** Packet is the B29-C-only exists-path calls + nested pins. The two exclusive files are untracked in this workspace; `git diff HEAD` on sibling files still includes other lanes. Report already says this.

4. **`runB29C()` adds no new main-chunk local.** Brief asked isolation wrap stays, not zero new chunk locals. Pin locals sit inside the nest. `luac` main chunk is **59 / 200**.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **574 / 0** was re-run here. Live ESC after a remount that dropped the handler is unproven on Anniversary.

6. **Source does not string-pin `if existing then return` on the Show / Refresh bodies.** `GetScript` presence plus the third-Show / sentinel identity pins close the hole. Reviewer spy confirms existing / sentinel Show / Refresh `SetScript` delta 0.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **574 passed, 0 failed.** Isolation wrap: **17**.

`Show` and `Refresh` wire a missing OnHide through the same `wireCardOnHide` helper as `build()` / `Init`. An existing script is not replaced. The frame is not rebuilt. Init remount stays. Restored OnHide still syncs `lastView` without forgetting lastPair. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. No `UnitHealth`. No close button. No `PlaySound`. Pins live in `runB29C()` inside `runB28D()`. Isolated `lua tests/test_fighter_card.lua` **574 passed, 0 failed**, exit 0.

**Leftovers:** `Hide` still does not remount a niled OnHide; handler-less Hide can leave stale `lastView.shown`; no Anniversary ESC / `CloseSpecialWindows` smoke; isolated suite only (full `tests/run.lua` not run).

Do not claim V1 / MVP complete. This review does not sign the lane.
