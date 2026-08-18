Spec PASS

# B30-B — Fighter card Hide remounts a missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B30-B Fighter card Hide remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B30-B-card-hide-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B30-B-card-hide-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B30-B-card-hide-onhide.diff` (B30-B-only exclusive-pair packet; live `FighterCard.lua` also carries earlier card batches vs HEAD / untracked tree)
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/FighterCard.lua` (`wireCardOnHide` / `build` / `FighterCard:Init` / `Refresh` / `Show` / `Hide` / `paintHidden` / `hiddenView` / `forgetPersist` / `rememberSpecial` / `NAME_FONT`), and `tests/test_fighter_card.lua` (isolation wrap, persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh pins, nested `runB30B()` inside `runB28D()` after `runB29C()`); then ran `lua tests/test_fighter_card.lua` (**613 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); B29 leftover: `Hide` skipped a niled OnHide when the frame already existed; when the frame exists, `Hide` calls `wireCardOnHide(frame)` before `paintHidden`; do not replace an existing script; do not rebuild; Show / Refresh / Init remount stay; no `UnitHealth`; lastPair until QUIET; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Did not mutate `FighterCard.lua` or `test_fighter_card.lua`. Did not commit. Did not edit Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Hide` still skips a missing OnHide when the frame exists (B29 leftover) | **Pass. Verified.** Live `Hide` is `if frame then wireCardOnHide(frame) end` then `paintHidden()`. Helper wires only when `GetScript("OnHide")` is nil. Pins: `SetScript("OnHide", nil)`, Hide restores; `GetView().shown` is false. Reviewer probe: niled script, Hide, `GetScript` is a function; wrapped `SetScript` saw **1** call named `OnHide`. Hide body has `wireCardOnHide` before `paintHidden`. |
| `Hide` replaces an existing script | **Pass. Verified.** Helper is `if existing then return`. Pins: second Hide and third Hide after restore keep `afterHide`. Reviewer spy: wrapped `SetScript` saw **0** OnHide calls on Hide with the restored script and with a sentinel OnHide. Sentinel identity stayed. |
| Restore rebuilds or `Init`s a missing frame | **Pass. Verified.** `Hide` does not call `Init` or `CreateFrame`. Pins: niled Hide / second Hide / third Hide `createCalls` 0. Reviewer probe: `CreateFrame` delta **0** across remounts, third Hide, and Init remount. Hide with no frame (never built) CreateFrame delta **0**; view still hidden. No new `CreateFrame` on the exists-path. |
| Restored handler is not the create OnHide (`lastView` / `paintHidden` / `hiding` / `forgetPersist` / `PlaySound`) | **Pass.** Create, Init, Show, Refresh, and Hide all call `wireCardOnHide`. Live handler is still `lastView = hiddenView()` then `paintHidden` unless `hiding`. Helper has no `forgetPersist`, `PlaySound`, or `CreateFrame`. Pins: restored fire sets `lastView.shown` false; Refresh still paints Chuckroast / Tendermage; `health` nil. Reviewer probe: same pair after restore; source has no `PlaySound` / `UnitHealth`. Hide does not remount a niled OnShow. |
| Show / Refresh / Init remount dropped; lastPair forgotten on remount OnHide; ASSEMBLY after QUIET revives; `NAME_FONT` / `UnitHealth` / close ✕ | **Pass. Verified.** Live Init / Show / Refresh still call `wireCardOnHide` on the exists-path. `forgetPersist` still lives only on Quiet / `ResetForTests`. Pins: B28-D Init remount / B29-C Show/Refresh remount stay above `runB30B()`; B30-B re-reads those bodies; restored OnHide does not clear `Gora:GetSanctioned()`; Refresh paints both names; suite persist / ASSEMBLY-after-QUIET / Morpheus / health-nil pins stay. Reviewer probe: Init / Show / Refresh still remount a niled script; EndEvent then Refresh is hidden; later StartEvent still hidden. Live `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. Source has no `UnitHealth`, `CloseButton`, `✕`, `CreateFrame("Button"`, or `MORPHEUS_CYR`. Reviewer probe: `countType(widget, "Button")` is **0**. |
| Existing persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh / isolation pins drop | **Pass. Verified.** Those blocks sit above `runB30B()`. Isolation wrap is still **17** nils under `if standalone then`. Suite green includes those asserts. Reviewer probe: wrap keys (Net / UI / Hud / Toasts / Console / Decree / RecordsBook / Sound) are nil at load. |
| Isolated suite not exit 0 / new main-chunk pin block | **Pass. Verified.** 613 passed, 0 failed. Writer-reported count matches. New pin locals live in `runB30B()` nested inside `runB28D()` after `runB29C()`. Isolation wrap stays under the load-time standalone block. `luac -l -p`: main chunk **59** locals (cap 200; same as B28-D / B29-C). |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two unified hunks (Hide exists-path `wireCardOnHide` before `paintHidden`; header comment + nested `runB30B()`). Sibling dirt in this workspace is other lanes (`Hud.lua`, `ChurchOfBeef.lua`, `tests/run.lua`). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud, glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Seventeen `dofile`-neighbor nils unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| When the frame exists, `Hide` calls `wireCardOnHide(frame)` before `paintHidden` | **Pass.** Named-risk check. |
| Do not replace an existing script; do not rebuild | **Pass.** Named-risk check. |
| Show / Refresh / Init remount stay | **Pass.** Named-risk check. |
| Nil the OnHide, Hide: script restored. Third Hide with the script already set: identity stays | **Pass.** Named-risk check. |
| Restored fire still sets `lastView.shown` false and does not forget lastPair | **Pass.** Named-risk check. |
| Existing persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh pins stay | **Pass.** Named-risk check. |
| No `UnitHealth`; no close button; lastPair until QUIET; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`; no `PlaySound` | **Pass.** Named-risk check. |
| Nest `runB30B()` after `runB29C()`; isolation wrap stays; `lua tests/test_fighter_card.lua` exit 0 | **Pass.** **613 / 0.** |

B29 leftover (`Hide` skipped a niled OnHide when the frame already existed, so glue that only Hide()s dropped ESC lastView sync) is closed on the Hide exists-path. Show / Refresh / Init remount from B29-C / B28-D stay. Law 6 (Quiet after End does not keep the card), Law 10 (no close ✕), §10.6 mute tape (no `UnitHealth`, no `PlaySound`), lastPair until QUIET, and B20-C Morpheus hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary ESC vs `CloseSpecialWindows` order is unproven | **Not a miss.** Brief asked isolated green + restore a niled OnHide + third-Hide identity. A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` / `stub.fire` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity and lastView sync. The client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / restore / persist

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Runtime + Gora + FighterCard. No `dofile` of Hud, UI shell, Net, DB, or glue. Standalone wrap is still 17 nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, DecreeBanner, RecordsBook). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). New asserts sit in `runB30B()` inside `runB28D()` after `runB29C()` so Lua 5.1's 200-local cap does not fire.

**Restore — Pass.** `Hide` calls `wireCardOnHide` on the exists-path (no inline `SetScript`) before `paintHidden`. The helper no-ops when a script exists and writes `lastView = hiddenView()` then `paintHidden` unless `hiding` only when OnHide is nil. Show / Refresh / Init remount are unchanged. Reviewer spy: restore `SetScript` delta 1 named OnHide on niled Hide; existing / sentinel / third Hide delta 0. `CreateFrame` delta 0 on remounts. A niled OnShow is not restored. Hide with no frame does not `Init`.

**Persist — Pass.** Restored OnHide still syncs `lastView` without `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. Reviewer probe: EndEvent then Refresh is hidden; ASSEMBLY after QUIET does not revive. `health` stays nil. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.

---

## Strengths

- The delta is the brief: one `wireCardOnHide(frame)` call on the Hide exists-path, before `paintHidden`. An existing script is not replaced. The widget is not rebuilt. Show / Refresh / Init remount stay. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B29 leftover (niled OnHide stayed nil across Hide; later ESC then skipped `lastView` / `paintHidden`) is closed with a runtime restore, not only a source `find`. The restored handler is then proven to hide the view and leave lastPair, so a no-op restore would fail.
- Third-Hide identity, `CreateFrame` 0, and Refresh lastPair / health-nil sit next to the restore pins, so a rebuild or a replace-every-Hide helper would fail.
- Persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh / isolation pins were left above the nest. Isolation stayed gated. New locals are inside `runB30B()` inside `runB28D()` after `runB29C()`.
- Writer-reported **613 / 0** matched the re-run. Writer-reported red (**610 / 3**) matches the exists-path-missing-helper + niled-stayed-nil + fire/lastView cluster that pre-B30-B Hide would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Handler-less widget Hide before remount still leaves stale `lastView.shown`.** Reviewer probe: Show, nil OnHide, `widget:Hide()` (stub does not fire a missing script), view stays `shown == true` while `IsShown` is false. `FighterCard:Hide()` now remounts then `paintHidden`, so that path syncs. Brief scoped remount on `FighterCard:Hide`, not a shown-repair of a raw widget Hide.

2. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the card with other listed chrome. Brief asked isolated restore + identity, not a client walk.

### Nit

1. **Third-Hide identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

2. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. `runB30B()` does not re-pin them. Brief said the wrap stays; it did.

3. **Exclusive-pair diff is not a vs-HEAD FighterCard delta.** Packet is the B30-B-only exists-path call + nested pins. The two exclusive files are untracked in this workspace; `git diff HEAD` on sibling files still includes other lanes. Report already says this.

4. **`runB30B()` adds no new main-chunk local.** Brief asked isolation wrap stays, not zero new chunk locals. Pin locals sit inside the nest. `luac` main chunk is **59 / 200**.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **613 / 0** was re-run here. Live ESC after a remount that dropped the handler is unproven on Anniversary.

6. **Source does not string-pin `if existing then return` on the Hide body.** `GetScript` presence plus the third-Hide / sentinel identity pins close the hole. Reviewer spy confirms existing / sentinel Hide `SetScript` delta 0.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **613 passed, 0 failed.** Isolation wrap: **17**.

`Hide` wires a missing OnHide through the same `wireCardOnHide` helper as `build()` / `Init` / `Show` / `Refresh`, then `paintHidden`. An existing script is not replaced. The frame is not rebuilt. Show / Refresh / Init remount stay. Restored OnHide still syncs `lastView` without forgetting lastPair. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. No `UnitHealth`. No close button. No `PlaySound`. Pins live in `runB30B()` inside `runB28D()` after `runB29C()`. Isolated `lua tests/test_fighter_card.lua` **613 passed, 0 failed**, exit 0.

**Leftovers:** handler-less widget Hide can leave stale `lastView.shown`; no Anniversary ESC / `CloseSpecialWindows` smoke; isolated suite only (full `tests/run.lua` not run).

Do not claim V1 / MVP complete. This review does not sign the lane.
