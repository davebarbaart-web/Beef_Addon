Spec PASS

# B24-B — Dock dismiss is per Runtime eventId (review)

**Quality:** Approved-with-nits

**Lane:** B24-B Dock dismiss is per Runtime eventId
**Brief:** `docs/reformation/vestments/briefs/B24-B-dock-event.md`
**Writer report:** `docs/reformation/vestments/briefs/B24-B-dock-event-report.md`
**Diff:** `docs/reformation/vestments/briefs/B24-B-dock-event.diff` (B24-B-only exclusive-pair packet; both exclusive files are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`dismissedEventId`, `currentEventId` / `stayDismissed`, OnHide after create-time `Hide`, `Refresh` / `Show` / `ResetForTests`, `rememberSpecial`, CloseButton hide, `ui.consoleDock`), and `tests/test_console_dock.lua` (source `eventId` / no `cooldown`, B23-B same-event Hide + Refresh stay-hidden, B24-B EndEvent-without-Refresh then StartEvent + Refresh shown, persist remount still keys `eventId`, title / hidden CloseButton / `UISpecialFrames` / no-sound keep-pins, isolation wrap); then ran `lua tests/test_console_dock.lua` (**314 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: dismiss keyed to Runtime `Snapshot().eventId` (number); new event shows; same-event Hide + Refresh stays hidden; no `PlaySound`. B23-B leftover (boolean `dismissed` stuck across `EndEvent` without Refresh). Bible §18.1 / §20 event lifetime; Law 6 / §19.4 (Quiet is silent; no `PlaySound` / `IG_CHARACTER_INFO_*`); Law 10 / §19.3 (functional / stock); wiki ESC `UISpecialFrames` + named frame; CONTINUE 2026-08-18 license 4 (stock only). Title stays exactly `DIRECTOR CONSOLE`. CloseButton hidden. Persist stays. `UISpecialFrames` stays. Hide is not EndEvent. No dismiss-cooldown number. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit Console.lua, Hud, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Boolean `dismissed` still stuck after ESC then `EndEvent` without Refresh; next `StartEvent` + Refresh stays hidden (B23-B leftover) | **Pass. Verified.** `dismissed` is gone. OnHide while live remembers numeric `Snapshot().eventId`. `stayDismissed` is `mayShow` and current id equals remembered id. Pins: first id is a number; widget Hide keeps it and is not EndEvent; EndEvent without Refresh is QUIET and leaves the view hidden; next StartEvent is a new number; Refresh **shows**. Reviewer probe: EndEvent leftover snapshot still carries the old `eventId` with state `QUIET`; StartEvent + Refresh still shows because the new id does not match. `EndEvent` call count stays 0 across widget Hide + same-event Refresh. |
| Same-event Hide + Refresh re-shows | **Pass. Verified.** B23-B pins stay (widget Hide → `IsShown` false, `GetView().shown` false, Runtime `ASSEMBLY`; Refresh stays hidden; second dismiss + Refresh stays hidden). B24-B block re-pins same-event Hide + Refresh after the new event. Reviewer probe: RITE / CONSEQUENCE / `Continue` keep the same `eventId` and stay hidden across Refresh. |
| `Show()` or `ResetForTests` does not clear; new `eventId` / nil / QUIET does not clear | **Pass. Verified.** `Show()` nils `dismissedEventId` then paints if `mayShow`. `ResetForTests` nils before and after widget `Hide()`. Not-`mayShow` Refresh nils twice around `paint(false)`. Live Refresh that is not `stayDismissed` nils then paints shown. Pins: `Show()` after dismiss paints; Quiet Refresh then StartEvent + Refresh shows; B24-B new-id Refresh shows. Reviewer probe: Pope-false Refresh after dismiss then Pope-true Refresh shows (double-clear is still load-bearing). Poison `Snapshot` with `eventId` nil or `"7"` while ASSEMBLY: Refresh shows. |
| `PlaySound` / `IG_CHARACTER_INFO_*` on hide / Refresh / Show | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. No `cooldown`. Suite `sounds == 0` through widget Hide, EndEvent-without-Refresh, new-event Refresh, same-event Refresh, persist. Reviewer spy: same counter stays 0. |
| Hide ends the event | **Pass. Verified.** Widget Hide and `ConsoleDock:Hide()` leave Runtime `ASSEMBLY` (RITE / CONSEQUENCE / Continue probes stay those states / same `eventId`). Source has no `Runtime:EndEvent`. `UISpecialFrames` count stays 1. |
| Title / CloseButton / persist / `UISpecialFrames` broken | **Pass.** `TITLE` is still exactly `DIRECTOR CONSOLE`. CloseButton stays `Hide()`d. `rememberSpecial` / `ui.consoleDock` / `ANCHORS` unchanged. Re-shown and persist remount re-pin title, hidden CloseButton, once-list, OnHide / `dismissed` / `eventId` / no `cooldown`. |
| Isolated suite not exit 0 | **Pass. Verified.** 314 passed, 0 failed. Writer-reported count matches. Writer-reported red (**310 / 4**) matches the four asserts a boolean `dismissed` would still fail (source `eventId`, persist `eventId`, new-event view shown, new-event widget shown). B23-B was **280**; 280 + 2 source `eventId` pins + 2 reset asserts in the new block + 30 B24-B behavior pins = **314**. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (`dismissed` → `dismissedEventId` + `currentEventId` / `stayDismissed` + Refresh / Show / Reset; source `eventId` + B24-B block + persist `eventId`). Both files are still untracked vs HEAD. Sibling dirt in this workspace is other lanes (Console, Hud, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console.lua, Hud, glue; no commit | **Pass.** Named-risk check. |
| Key dismiss to Runtime `Snapshot().eventId` (number). OnHide while live: remember that id | **Pass.** `currentEventId` returns a number or nil. OnHide (after create-time `Hide`, Toasts existing-script guard): `lastView.shown = false`; if `eventLive()` and the id is a number, set `dismissedEventId`. Boolean `dismissed` is gone. |
| Refresh: if `mayShow` and current `eventId` equals the remembered id, stay hidden | **Pass.** `stayDismissed` is that predicate. B23-B same-event pins stay. B24-B same-event Hide + Refresh stays hidden. |
| A new `eventId` (or `eventId` nil / QUIET) clears dismiss and may show | **Pass.** Named-risk check. QUIET / not-`mayShow` clears and paints hidden. New id or nil while `mayShow` clears and paints shown. |
| `Show()` still clears dismiss. `ResetForTests` clears it | **Pass.** First line of `Show()` is `dismissedEventId = nil`. Reset nils before and after widget `Hide()`. |
| B23-B same-event ESC + Refresh stay-hidden pins stay | **Pass.** The B23-B block is intact and still green. |
| StartEvent + Pope shown; widget Hide hidden; EndEvent (no Refresh); StartEvent + Refresh **shown** (new eventId); same-event Hide + Refresh still hidden | **Pass.** Suite B24-B block plus reviewer probes. |
| Title `DIRECTOR CONSOLE`; CloseButton hidden; persist stays; `UISpecialFrames` stays; Hide is not EndEvent; no `PlaySound` / `IG_CHARACTER_INFO_*`; no dismiss-cooldown number | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **314 / 0.** Wrap still **24** under `if standalone then`. |

Bible §18.1 / §20 (event lifetime; collapsible Director Console stays titled `DIRECTOR CONSOLE`; persist stays), Law 6 (no panel whoosh), and Law 10 / license 4 (stock dock, hidden CloseButton) hold on the exclusive pair. The B23-B leftover (boolean dismiss surviving `EndEvent` without Refresh) is closed.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; harness `Hide()` is not a live Escape key vs `CloseSpecialWindows` | **Not a miss.** Brief asked isolated green + widget Hide as the ESC stand-in. **POLISH:CANDIDATE** only. |
| `paint(false)` while shown and live also remembers `eventId`; `ConsoleDock:Hide()` stays hidden across Refresh | **On contract.** Brief named widget `Hide()`. API Hide `Hide()`s the widget, so OnHide matches. See leftover. |
| Not-`mayShow` Refresh still clears dismiss twice so a live-event OnHide from that paint cannot stick | **On contract.** Brief: new `eventId` / nil / QUIET clears. Not-`mayShow` is the Quiet / Pope-false / missing-Sender path B23-B already required. Reviewer probe: Pope-false then Pope-true Refresh shows. |
| Runtime `EndEvent` leaves `eventId` on the snapshot (state QUIET); this lane treats QUIET as a clear | **On contract.** `stayDismissed` requires `mayShow` (`eventLive()` is `state ~= "QUIET"`). Leftover id cannot keep dismiss through Quiet. Reviewer probe: leftover id equals the dismissed id; StartEvent + Refresh still shows. |
| Full `lua tests/run.lua` not run; Gate W / Gate V stay OPEN; lane unsigned | **Not a miss.** Brief asked the isolated suite. This review does not sign the lane. |
| Parked desk `namedOpponent`; B22-D nits (`_G` mint, first-`build` nil table, suite pins list membership) | **On contract.** Overview parks the Console leftover. B22-D nits are unchanged and not this law. |

B24-INT glue is not required. `refreshEventFurniture` already calls `ConsoleDock:Refresh`. The leftover was Refresh staying hidden on a **new** `eventId` after `EndEvent` without an intervening Quiet Refresh.

---

## Isolation / OnHide / Refresh

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap text is unchanged. Reviewer probe: UI / Hud / Store / Toasts / Net / DB are nil at load. Wrap is load-time only.

**OnHide — Pass.** Hook is after create-time `Hide`, so Quiet Init does not fire teardown. `eventLive()` is `runtimeState() ~= "QUIET"`. Remembered value is numeric `currentEventId()`, not a boolean. Create-time path: Init then StartEvent + Refresh shows (dismiss did not stick). Existing-script guard matches Toasts. Widget Hide and API Hide both sync `lastView.shown` and, while live, remember the id. Hide does not call `EndEvent` and plays no sound.

**Refresh / Show / eventId — Pass.** Same id + `mayShow` paints hidden and keeps the id (ASSEMBLY / RITE / CONSEQUENCE / Continue). New id clears and paints shown. Nil / non-number id while live does not `stayDismissed`. Quiet / Pope-false / missing Sender Refresh clear so a later legal Refresh can show. `Show()` clears then paints. `ResetForTests` clears before and after `Hide()`. Dismiss is a module local, not `ChurchOfBeefDB`.

---

## Strengths

- The delta is the brief: boolean `dismissed` becomes `dismissedEventId` keyed to Runtime `eventId`. No close button, no hide sound, no EndEvent, no cooldown number. Title / persist / `UISpecialFrames` / SANCTION + Expand left alone.
- B23-B's leftover (ESC then `EndEvent` without Refresh left dismiss set; next StartEvent + Refresh stayed hidden) is closed on the same ESC stand-in, not a second furniture API. Same-event Hide + Refresh pins stay.
- `stayDismissed` requires `mayShow`, so the Runtime leftover (`EndEvent` keeps `eventId` on a QUIET snapshot) cannot restick dismiss. Not-`mayShow` double-clear and Reset double-clear stay load-bearing.
- Isolation wrap and `mayShow` were not rewritten. Source still has no `PlaySound`. CloseButton stays hidden.
- Writer-reported **314 / 0** matched the re-run. Writer-reported red **310 / 4** matches the four asserts old boolean dismiss would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`ConsoleDock:Hide()` / `paint(false)` while shown and live also remembers `eventId`.** Reviewer probe: API Hide then Refresh stays hidden until `Show()`, a new `eventId`, or a not-`mayShow` Refresh. Glue `hideInputsAndDock` (inspect inbound) still calls that API; after inspect, the next `refreshEventFurniture` Refresh would stay hidden for that event. Brief scoped widget `Hide()`. No INT glue required.

### Nit

1. **`EndEvent` itself does not nil `eventId` or dismiss.** Only Quiet / not-`mayShow` Refresh, a mismatched / nil id, `Show()`, and `ResetForTests` do. Reviewer probe: EndEvent leftover snapshot still has the old number; this lane treats QUIET as a clear. Production `afterEndEvent` already Refresh()es while QUIET. Brief asked EndEvent without Refresh then StartEvent + Refresh **shown**.

2. **Existing-script guard skips the dismiss hook if `OnHide` is already set.** Reviewer poison from B23-B still applies: pre-set OnHide on create → widget Hide leaves `GetView().shown` true and Refresh re-shows. Stub `BasicFrameTemplate` does not set OnHide; production template is TitleText + CloseButton. Brief asked the Toasts guard.

3. **Harness `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.** B22-D leftover. Brief / suite still allow `GetName()`. Anniversary named `CreateFrame` sets the global.

4. **First-`build` with a nil `UISpecialFrames` is not queued; suite pins list membership, not a special-frame walk.** B22-D leftovers. Client table exists. Harness Hide is a direct call.

5. **Isolation wrap is load-only.** Persist `dofile` does not re-assert the 24 nil-module pins. Wrap text is unchanged.

6. **Exclusive-pair diff is not a vs-HEAD dock delta.** Both files are still untracked. Packet is the B24-B-only `eventId` key + pins vs the pre-lane working tree. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **314 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **314 passed, 0 failed.** Isolation wrap: **24**.

Dismiss is keyed to Runtime `eventId`. OnHide while live remembers that number. Refresh stays hidden while `mayShow` and the id matches. A new `eventId` (or nil / QUIET) clears and may show. Same-event Hide + Refresh stays hidden. `Show()` and `ResetForTests` clear. Hide is not EndEvent and plays no sound. Title stays `DIRECTOR CONSOLE`. CloseButton stays hidden. Persist and `UISpecialFrames` stay. Isolated `lua tests/test_console_dock.lua` **314 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
