Spec PASS

# B28-D — Fighter card Init restores a missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B28-D Fighter card Init restores a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B28-D-card-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B28-D-card-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B28-D-card-onhide.diff` (B28-D-only exclusive-pair packet; live `FighterCard.lua` also carries earlier card batches vs HEAD / untracked tree)
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/FighterCard.lua` (`wireCardOnHide` / `build` / `FighterCard:Init` / `Refresh` / `Show` / `Hide` / `paintHidden` / `hiddenView` / `forgetPersist` / `rememberSpecial` / `NAME_FONT`), and `tests/test_fighter_card.lua` (isolation wrap, persist / OnHide lastView / health-nil / Morpheus pins, nested `runB28D()` after the rebuild pins); then ran `lua tests/test_fighter_card.lua` (**528 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); B13-B create-path OnHide syncs `lastView` then `paintHidden` unless `hiding`; Init remounts a missing OnHide with the **same** handler as `build()`; do not replace an existing script; do not rebuild; no `UnitHealth`; lastPair until QUIET; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Did not mutate `FighterCard.lua` or `test_fighter_card.lua`. Did not commit. Did not edit Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Init` still skips a missing OnHide (B13-B leftover: remount `rememberSpecial`s only) | **Pass. Verified.** Live `Init` is `build()` if `frame` is nil, then `wireCardOnHide(frame)`, `rememberSpecial`, `Refresh`. Helper wires only when `GetScript("OnHide")` is nil. Pins: `SetScript("OnHide", nil)`, second Init restores a script; restored fire sets `lastView.shown` false. Reviewer probe: niled script, Init, `GetScript` is a function; wrapped `SetScript` saw **1** call named `OnHide`. |
| `Init` replaces an existing script | **Pass. Verified.** Helper is `if existing then return`. Pins: third Init after restore keeps `restored`. Reviewer spy: wrapped `SetScript` saw **0** calls on Init with the create-path script, a sentinel OnHide, and third Init. Create-path identity and sentinel identity stayed. |
| Restore rebuilds or duplicates `ChurchOfBeefFighterCard` | **Pass. Verified.** `Init` still returns the existing `frame`. Pins: niled Init returns the same widget; `createCalls` 0; `countSpecial` stays 1. Reviewer probe: `CreateFrame` delta **0** on remounts; third Init still 0. |
| Restored handler is not the create OnHide (`lastView` / `paintHidden` / `hiding` / `forgetPersist` / `PlaySound`) | **Pass.** Create and Init both call `wireCardOnHide`. Live handler is still `lastView = hiddenView()` then `paintHidden` unless `hiding`. Helper has no `forgetPersist`, `PlaySound`, or `CreateFrame`. Pins: restored fire sets `lastView.shown` false; Refresh still paints Chuckroast / Tendermage; `health` nil. Reviewer probe: same pair after restore; source has no `PlaySound` / `UnitHealth`. |
| lastPair forgotten on remount OnHide; ASSEMBLY after QUIET revives; `NAME_FONT` / `UnitHealth` / close ✕ | **Pass. Verified.** `forgetPersist` still lives only on Quiet / `ResetForTests`. Pins: restored OnHide does not clear `Gora:GetSanctioned()`; Refresh paints both names; suite persist / ASSEMBLY-after-QUIET / Morpheus / health-nil pins stay. Reviewer probe: EndEvent then Refresh is hidden; later StartEvent still hidden. Live `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. Source has no `UnitHealth`, `CloseButton`, `✕`, or `MORPHEUS_CYR`. |
| Existing persist / OnHide lastView / health-nil / Morpheus / isolation pins drop | **Pass. Verified.** Those blocks sit above `runB28D()`. Isolation wrap is still **17** nils under `if standalone then`. Suite green includes those asserts. Reviewer probe: wrap keys are nil at load. |
| Isolated suite not exit 0 / new main-chunk pin block | **Pass. Verified.** 528 passed, 0 failed. Writer-reported count matches. New pin locals live in `runB28D()`. Isolation wrap stays under the load-time standalone block. `luac -l -p`: main chunk **59** locals (cap 200). |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two unified hunks (extract `wireCardOnHide` + create-path / Init calls; header comment + nested `runB28D()`). Sibling dirt in this workspace is other lanes (`Hud.lua`, `ChurchOfBeef.lua`, `tests/run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud, glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Seventeen `dofile`-neighbor nils unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| On Init, if the frame exists and `GetScript("OnHide")` is nil, wire the **same** handler as `build()` | **Pass.** Named-risk check. |
| Do not replace an existing script; do not rebuild | **Pass.** Named-risk check. |
| Extract `wireCardOnHide(widget)` if that avoids duplication | **Pass.** Create-path and Init both call the helper. Init / create-path have no inline `SetScript("OnHide"`. |
| Nil the OnHide, second Init: script is restored; third Init identity stays | **Pass.** Named-risk check. |
| Existing persist / OnHide lastView / health-nil / Morpheus pins stay | **Pass.** Named-risk check. |
| No `UnitHealth`; lastPair until QUIET; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Named-risk check. |
| Nest new pins; isolation wrap stays; `lua tests/test_fighter_card.lua` exit 0 | **Pass.** **528 / 0.** |

B13-B leftover (Init remounted ESC but a dropped OnHide stayed nil, so ESC Hide skipped `lastView` / `paintHidden`) is closed on the Init path. Law 6 (Quiet after End does not keep the card), Law 10 (no close ✕), §10.6 mute tape (no `UnitHealth`, no `PlaySound`), lastPair until QUIET, and B20-C Morpheus hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary ESC vs `CloseSpecialWindows` order is unproven | **Not a miss.** Brief asked isolated green + restore a niled OnHide + third-Init identity. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` / `stub.fire` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity and lastView sync. The client's special-frame walk is not. |
| Show / Refresh with an existing frame still do not remount OnHide | **On contract.** Brief scoped Init. Reviewer probe: niled OnHide stays nil across `Show` and `Refresh`; `Init` restores. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / restore / persist

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Runtime + Gora + FighterCard. No `dofile` of Hud, UI shell, Net, DB, or glue. Standalone wrap is still 17 nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, DecreeBanner, RecordsBook). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). New asserts sit in `runB28D()` so Lua 5.1's 200-local cap does not fire.

**Restore — Pass.** `Init` still `rememberSpecial`s, then Refreshs, and now `wireCardOnHide`s (no inline `SetScript`). The helper no-ops when a script exists and writes `lastView = hiddenView()` then `paintHidden` unless `hiding` only when OnHide is nil. Create path `Hide()`s then calls the same helper. Reviewer spy: restore `SetScript` delta 1 named OnHide; existing / sentinel / third Init delta 0. `CreateFrame` delta 0 on remounts. A niled OnShow is not restored.

**Persist — Pass.** Restored OnHide still syncs `lastView` without `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. Reviewer probe: EndEvent then Refresh is hidden; ASSEMBLY after QUIET does not revive. `health` stays nil. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.

---

## Strengths

- The delta is the brief: extract the create-path OnHide into `wireCardOnHide` and call it from Init. An existing script is not replaced. The widget is not rebuilt. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B13-B leftover (niled OnHide stayed nil across Init; fire then skipped `lastView` / `paintHidden`) is closed with a runtime restore, not only a source `find`. The restored handler is then proven to hide the view and leave lastPair, so a no-op restore would fail.
- Third-Init identity, `CreateFrame` 0, and `countSpecial` 1 sit next to the restore pin, so a rebuild or a replace-every-Init helper would fail.
- Persist / OnHide lastView / health-nil / Morpheus / isolation pins were left above the nest. Isolation stayed gated. New locals are inside `runB28D()`.
- Writer-reported **528 / 0** matched the re-run. Writer-reported red (**514 / 14**) matches the helper-missing + create-path-still-inline + niled-stayed-nil + fire/lastView cluster that pre-extract Init would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Show` / `Refresh` still skip a missing OnHide when `frame` already exists.** Reviewer probe: niled script stays nil across `Show` and `Refresh`; `Init` restores. Brief scoped Init. Glue that remounts only via Show / Refresh would still drop ESC lastView sync.

2. **Handler-less Hide before remount still leaves stale `lastView.shown`.** Reviewer probe: Show, nil OnHide, `Hide()` (stub does not fire a missing script), view stays `shown == true` while `IsShown` is false. Next `Init` Refresh paints the live pair again. Brief scoped restore of the missing script, not a shown-repair of the lost Hide.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the card with other listed chrome. Brief asked isolated restore + identity, not a client walk.

### Nit

1. **Third-Init identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

2. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. `runB28D()` does not re-pin them. Brief said the wrap stays; it did.

3. **Exclusive-pair diff is not a vs-HEAD FighterCard delta.** Packet is the B28-D-only helper extract + nested pins. The two exclusive files are untracked in this workspace; `git diff HEAD` on sibling files still includes other lanes. Report already says this.

4. **`runB28D()` is one new main-chunk local.** Brief asked isolation wrap stays, not zero new chunk locals. Pin locals sit inside the nest. `luac` main chunk is **59 / 200**.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **528 / 0** was re-run here. Live ESC after a remount that dropped the handler is unproven on Anniversary.

6. **Source does not string-pin `if existing then return`.** `GetScript` presence plus the third-Init / sentinel identity pins close the hole. Reviewer spy confirms existing / sentinel Init `SetScript` delta 0.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **528 passed, 0 failed.** Isolation wrap: **17**.

`Init` wires a missing OnHide through the same `wireCardOnHide` helper as `build()`. An existing script is not replaced. The frame is not rebuilt. Restored OnHide still syncs `lastView` without forgetting lastPair. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. No `UnitHealth`. Pins live in `runB28D()`. Isolated `lua tests/test_fighter_card.lua` **528 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
