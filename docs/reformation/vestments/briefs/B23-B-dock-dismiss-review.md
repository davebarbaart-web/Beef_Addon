Spec PASS

# B23-B — ESC on the Event dock stays hidden until Show or QUIET (review)

**Quality:** Approved-with-nits

**Lane:** B23-B ESC on the Event dock stays hidden until Show or QUIET
**Brief:** `docs/reformation/vestments/briefs/B23-B-dock-dismiss.md`
**Writer report:** `docs/reformation/vestments/briefs/B23-B-dock-dismiss-report.md`
**Diff:** `docs/reformation/vestments/briefs/B23-B-dock-dismiss.diff` (B23-B-only exclusive-pair packet; both exclusive files are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`dismissed`, `OnHide` after create-time `Hide`, `Refresh` / `Show` / `ResetForTests`, `rememberSpecial`, CloseButton hide, `ui.consoleDock`), and `tests/test_console_dock.lua` (source OnHide-after-Hide / `dismissed` / no `cooldown`, widget Hide / Refresh stay / Show / EndEvent / Quiet Refresh, persist remount still hooks OnHide, title / hidden CloseButton / `UISpecialFrames` / no-sound keep-pins, isolation wrap); then ran `lua tests/test_console_dock.lua` (**280 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: OnHide dismiss while event live; Refresh stays hidden; Show() or QUIET clears; no PlaySound; Hide is not EndEvent. Wiki ESC is `UISpecialFrames` + named frame (B22-D leftover: widget `Hide()` left `GetView().shown` true and `Refresh` re-showed). Bible §18.1 (collapsible Director Console); Law 6 / §19.4 (Quiet is silent; no `PlaySound` / `IG_CHARACTER_INFO_*`); Law 10 / §19.3 (functional / stock); Toasts create-time Hide then OnHide; CONTINUE 2026-08-18 license 4 (stock only). Title stays exactly `DIRECTOR CONSOLE`. CloseButton hidden. Persist stays. `UISpecialFrames` stays. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit Console.lua, Hud, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Widget `Hide()` (ESC) still leaves `GetView().shown` true; next `Refresh` re-shows (B22-D leftover) | **Pass. Verified.** `OnHide` (after create-time `Hide`) sets `lastView.shown = false` and, when `eventLive()`, `dismissed = true`. Pins: widget `Hide()` → `IsShown` false, `GetView().shown == false`, Runtime `ASSEMBLY`. `Refresh` stays hidden. Reviewer probe: same; `Runtime:EndEvent` call count stays 0 across widget Hide + Refresh. |
| `Refresh` while dismissed and `mayShow` re-shows | **Pass. Verified.** Live `Refresh`: not `mayShow` clears dismiss and paints hidden; `dismissed` paints hidden and keeps the flag; else paints shown. Pins: Refresh after widget Hide stays hidden / `ASSEMBLY`. Second dismiss + Refresh stays hidden. Reviewer probe: RITE and CONSEQUENCE dismiss also stay hidden across Refresh. |
| `Show()` or QUIET does not clear dismiss | **Pass. Verified.** `Show()` sets `dismissed = false` then paints if `mayShow`. Not-`mayShow` Refresh clears dismiss (twice, around `paint(false)`). Pins: `Show()` after dismiss paints; EndEvent Refresh hides; later StartEvent + Refresh shows; Quiet Refresh then StartEvent + Refresh shows. Reviewer probe: Pope-false Refresh after dismiss then Pope-true Refresh shows (double-clear is load-bearing). `Show()` while Quiet also clears; next StartEvent + Refresh shows. |
| `PlaySound` / `IG_CHARACTER_INFO_*` on hide / Refresh / Show | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. No `cooldown`. Suite `sounds == 0` through widget Hide, Refresh, Show, EndEvent / Quiet path, persist. Reviewer spy: same counter stays 0. |
| Hide ends the event | **Pass. Verified.** Widget Hide and `ConsoleDock:Hide()` leave Runtime `ASSEMBLY` (RITE / CONSEQUENCE probes stay those states). Source has no `Runtime:EndEvent`. `UISpecialFrames` count stays 1. |
| Title / CloseButton / persist / `UISpecialFrames` broken | **Pass.** `TITLE` is still exactly `DIRECTOR CONSOLE`. CloseButton stays `Hide()`d. `rememberSpecial` / `ui.consoleDock` / `ANCHORS` unchanged. Re-shown and persist remount re-pin title, hidden CloseButton, once-list, OnHide / `dismissed` / no `cooldown`. |
| Isolated suite not exit 0 | **Pass. Verified.** 280 passed, 0 failed. Writer-reported count matches. Writer-reported red (**267 / 13**) matches the thirteen source / persist / behavior asserts that a dock without OnHide / `dismissed` would fail (B22-D was **233**; 233 + 47 new pins = 280). |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (`dismissed` + OnHide + Refresh / Show / Reset; source / widget-Hide / persist pins). Both files are still untracked vs HEAD. Sibling dirt in this workspace is other lanes (Console, Hud, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console.lua, Hud, glue; no commit | **Pass.** Named-risk check. |
| OnHide after create-time Hide (Toasts existing-script guard); if event live, remember dismiss; `lastView.shown = false` | **Pass.** `widget:Hide()` then `SetScript("OnHide", ...)`. Guard is `GetScript("OnHide")` then set only when missing. Body: ensure `lastView`, `shown = false`, `if eventLive() then dismissed = true`. Source pin: create Hide byte-offset is before OnHide. |
| `Refresh`: not `mayShow` → clear dismiss and paint hidden; dismiss set → paint hidden and keep dismiss | **Pass.** Named-risk check. Frameless not-`mayShow` also clears. |
| `Show()` clears dismiss then paints if `mayShow` | **Pass.** First line of `Show()` is `dismissed = false`. Quiet Show still returns false and paints hidden. |
| `ResetForTests` clears dismiss | **Pass.** Clears before and after widget `Hide()` so a live-event OnHide cannot stick. Harness gate `_IN_TEST` stays. |
| No `PlaySound` / `IG_CHARACTER_INFO_*`; no dismiss-cooldown number | **Pass.** Named-risk check. |
| Hide is not EndEvent; `UISpecialFrames` stays; CloseButton hidden; title `DIRECTOR CONSOLE`; persist stays | **Pass.** Named-risk check. |
| StartEvent + Pope shown; widget Hide → `IsShown` false, `GetView().shown == false`, Runtime ASSEMBLY; Refresh stays hidden; Show paints; EndEvent / Quiet Refresh hidden and a later StartEvent + Refresh shows | **Pass.** Suite block plus reviewer probes. |
| Isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **280 / 0.** Wrap still **24** under `if standalone then`. |

Bible §18.1 (collapsible Director Console stays titled `DIRECTOR CONSOLE`; persist stays), Law 6 (no panel whoosh), Law 10 / license 4 (stock dock, hidden CloseButton), and the B22-D leftover (ESC `Hide()` must not be undone by glue `refreshEventFurniture`) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; harness `Hide()` is not a live Escape key vs `CloseSpecialWindows` | **Not a miss.** Brief asked isolated green + widget Hide as the ESC stand-in. **POLISH:CANDIDATE** only. |
| `paint(false)` while shown and live also sets dismiss; `ConsoleDock:Hide()` stays hidden across Refresh | **On contract.** Brief named widget `Hide()`. API Hide `Hide()`s the widget, so OnHide matches. See leftover. |
| Not-`mayShow` Refresh clears dismiss twice so a live-event OnHide from that paint cannot stick | **On contract.** Brief: not `mayShow` clears dismiss and paints hidden. Reviewer probe: Pope-false then Pope-true Refresh shows. |
| Full `lua tests/run.lua` not run; Gate W / Gate V stay OPEN; lane unsigned | **Not a miss.** Brief asked the isolated suite. This review does not sign the lane. |
| Parked desk `lastRecommendation` / `namedOpponent`; B22-D nits (`_G` mint, first-`build` nil table, suite pins list membership) | **On contract.** Overview parks the Console leftovers. B22-D nits are unchanged and not this law. |

B23-INT glue is not required. `refreshEventFurniture` already calls `ConsoleDock:Refresh`; the leftover was Refresh re-showing, which this flag closes.

---

## Isolation / OnHide / Refresh

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap text is unchanged. Reviewer probe: UI / Console / Hud / Store / Toasts / Net are nil at load. Wrap is load-time only.

**OnHide — Pass.** Hook is after create-time `Hide`, so Quiet Init does not fire teardown. `eventLive()` is `runtimeState() ~= "QUIET"`. Create-time path: Init then StartEvent + Refresh shows (dismiss did not stick). Existing-script guard matches Toasts. Widget Hide and API Hide both sync `lastView.shown` and, while live, set dismiss. Hide does not call `EndEvent` and plays no sound.

**Refresh / Show / Quiet — Pass.** Dismissed + `mayShow` paints hidden and keeps the flag (ASSEMBLY / RITE / CONSEQUENCE). `Show()` clears then paints. Quiet / Pope-false / missing Sender Refresh clear dismiss so a later legal Refresh can show. `ResetForTests` clears before and after `Hide()`. Dismiss is a module local, not `ChurchOfBeefDB`.

---

## Strengths

- The delta is the brief: one `dismissed` flag, Toasts-shaped OnHide after create Hide, Refresh / Show / Reset honor the three-way law. No close button, no hide sound, no EndEvent, no cooldown number. Title / persist / `UISpecialFrames` / SANCTION + Expand left alone.
- B22-D's leftover (widget Hide left `shown` true; glue Refresh re-showed) is closed on the same ESC stand-in, not a second furniture API.
- Not-`mayShow` double-clear and Reset double-clear are load-bearing: `paint(false)` / harness `Hide()` fire OnHide while the event can still be live. Pope-false then Pope-true Refresh shows.
- Isolation wrap and `mayShow` were not rewritten. Source still has no `PlaySound`. CloseButton stays hidden.
- Writer-reported **280 / 0** matched the re-run. Writer-reported red **267 / 13** matches the thirteen asserts that old `paint(mayShow())` / missing OnHide would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`ConsoleDock:Hide()` / `paint(false)` while shown and live also sets dismiss.** Reviewer probe: API Hide then Refresh stays hidden until `Show()` or a not-`mayShow` Refresh. Glue `hideInputsAndDock` (inspect inbound) calls that API; after inspect, the next `refreshEventFurniture` Refresh would stay hidden. Brief scoped widget `Hide()`. No INT glue required.

### Nit

1. **`EndEvent` itself does not clear dismiss.** Only Quiet / not-`mayShow` Refresh, `Show()`, and `ResetForTests` do. Reviewer probe: EndEvent then StartEvent + Refresh without an intervening Quiet Refresh stays hidden. Production `afterEndEvent` already Refresh()es while QUIET. Brief asked EndEvent / Quiet Refresh.

2. **Existing-script guard skips the dismiss hook if `OnHide` is already set.** Reviewer poison: pre-set OnHide on create → widget Hide leaves `GetView().shown` true and Refresh re-shows. Stub `BasicFrameTemplate` does not set OnHide; production template is TitleText + CloseButton. Brief asked the Toasts guard.

3. **Harness `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.** B22-D leftover. Brief / suite still allow `GetName()`. Anniversary named `CreateFrame` sets the global.

4. **First-`build` with a nil `UISpecialFrames` is not queued; suite pins list membership, not a special-frame walk.** B22-D leftovers. Client table exists. Harness Hide is a direct call.

5. **Isolation wrap is load-only.** Persist `dofile` does not re-assert the 24 nil-module pins. Wrap text is unchanged.

6. **Exclusive-pair diff is not a vs-HEAD dock delta.** Both files are still untracked. Packet is the B23-B-only flag + pins vs the pre-lane working tree. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **280 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **280 passed, 0 failed.** Isolation wrap: **24**.

OnHide after create-time Hide remembers dismiss while the event is live and sets `lastView.shown` false. Refresh stays hidden while dismissed. `Show()` or a Quiet / not-`mayShow` Refresh clears. Hide is not EndEvent and plays no sound. Title stays `DIRECTOR CONSOLE`. CloseButton stays hidden. Persist and `UISpecialFrames` stay. Isolated `lua tests/test_console_dock.lua` **280 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
