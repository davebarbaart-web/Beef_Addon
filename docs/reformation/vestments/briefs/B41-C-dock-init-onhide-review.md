Spec PASS

# B41-C — ConsoleDock Init remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B41-C ConsoleDock Init remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B41-C-dock-init-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B41-C-dock-init-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B41-C-dock-init-onhide.diff` (B41-C-only exclusive-pair packet; live `ConsoleDock.lua` / `test_console_dock.lua` are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`wireDockOnHide` ~202–217 / existing-frame `Init` remount ~271–280 / `Refresh` remount ~287–317 / `Show` remount ~319–336 / `Hide` remount ~338–344 / create-path `build` ~219–269 / `rememberSpecial` ~191–197 / persist `savePoint` / `restorePoint` ~136–155), and `tests/test_console_dock.lua` (isolation wrap, persist / ESC / B24-B per-event dismiss / B26-D Init remount / B27-D Show / Refresh remount / B30-D Hide remount / B36-C Hide OnHide remount / B39-D Show OnHide remount / B40-C Refresh OnHide remount pins, nested `runB41C()` inside `runB27D()` after `runB40C()`, plus the B36-C / B39-D / B40-C Init keep-string updates); then ran `lua tests/test_console_dock.lua` (**775 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); B40-C leftover (`Init` remounted `rememberSpecial` then Refresh; a niled OnHide stayed idle in the Init remount body until Refresh as a side effect); existing-frame `Init` remounts a missing OnHide (`wireDockOnHide`), then `rememberSpecial(FRAME_NAME)`, then Refresh (Refresh remount stays). Never replace an existing script. Do **not** reset drag persist. Do **not** pop a dismissed dock (Refresh keep). No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`. B40-C Refresh OnHide remount stays. B39-D Show OnHide remount stays. B36-C Hide OnHide remount stays. B30-D Hide `rememberSpecial` remount stays. B27-D Show remount stays. B26-D Init remount stays. B24-B `eventId` dismiss stays. Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit glue, Console, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Init still skips `wireDockOnHide` | **Pass. Verified.** Live existing-frame `Init` (~271–280) is `wireDockOnHide(frame)` then `rememberSpecial(FRAME_NAME)` then `self:Refresh()`. Helper (~202–217) wires only when `GetScript("OnHide")` is nil. Nested source pin: `wireAt < rememberAt < refreshAt`; remount body has no inline `SetScript`. Nested wrap: wipe list, nil OnHide, Init restores OnHide and lists `ChurchOfBeefConsoleDock` once. B36-C / B39-D / B40-C keep-strings now expect `wireDockOnHide` in the Init remount body. Reviewer spy: wrapped `SetScript` saw **1** call named `OnHide` on the niled Init. Reviewer probe: OnHide is already restored when `Refresh` starts, so this is the Init remount body, not a Refresh side effect. Not-pope Init and QUIET Init still remount then stay hidden. Shown-dock niled Init remounts and stays painted. Already-hidden `ConsoleDock:Init()` still restores the handler. |
| Existing OnHide replaced | **Pass. Verified.** Helper is `if existing then return`. Nested: second Init and third Init keep the restored identity; third Init still lists the name once. Create-path identity is not inlined (`SetScript("OnHide"` absent from `build`; create-path calls the helper after create-time Hide). Reviewer spy: wrapped `SetScript` saw **0** OnHide calls on the second and third Init. Reviewer probe: a sentinel OnHide survives `ConsoleDock:Init` / a third Init and still fires only if a later Hide runs it. Show / Refresh / Hide remount still use the same helper. |
| Drag persist reset | **Pass. Verified.** Remount body has no `restorePoint` / `savePoint` / `consoleDock`. Nested: GetPoint after Init matches the pre-wipe Init point (all five returns). Reviewer probe: saved `ChurchOfBeefDB.ui.consoleDock` table identity and `x` / `y` stay; widget stays `TOPLEFT` 24, 90. `restorePoint` still lives only in `build()`. `savePoint` still lives only on TitleBar `OnDragStop`. |
| Dismissed dock popped | **Pass. Verified.** Nested path: widget Hide records dismiss, then nil OnHide, then Init. `GetView().shown` is false; widget stays hidden on first / second / third Init. Reviewer probe: remounted handler then `Show` then widget Hide sets `shown` false and same-event Init stays hidden. Sentinel Init after a real dismiss also stays hidden. Shown-dock niled Init stays painted (not a dismiss). |
| `PlaySound` | **Pass.** Live `ConsoleDock.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Init remount body has neither. Nested wrap: `PlaySound` / `PlaySoundFile` / `PlaySoundKitID` stay **0** across remount Init and third Init. Suite-end pin is still `sounds == 0`. Reviewer spy matches. No `IG_CHARACTER_INFO_*`. No OnShow re-wire. |
| Keep-strings not updated | **Pass. Verified.** Brief: B26-D / later pins that forbade `wireDockOnHide` in Init must be updated in this exclusive test file. Live B36-C (~1032–1033), B39-D (~1188–1189), and B40-C (~1349–1350) now expect `wireDockOnHide` in the Init remount body. No leftover `assert_eq(remountInit:find("wireDockOnHide"…), nil)` and no leftover `Init remount does not remount OnHide` string. B26-D's own `runB26D()` never forbade the helper (it pinned `rememberSpecial` + Refresh only). Isolated suite **775 / 0**; a leftover forbid-string would fail those asserts. |
| Not nested after `runB40C()` | **Pass.** `runB41C()` is a nested `local function` inside `runB27D()` after the `runB40C()` call (`test_console_dock.lua` ~1447 / ~1458–1619). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: test main chunk still **56** locals (cap 200), same as B40-C. ConsoleDock file locals stay **35** (no new helper). |
| Isolated suite not exit 0 | **Pass. Verified.** 775 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**24** nil pins). `runB41C()` re-pins 5 of them. Packet is the two named files. Both exclusive files are still untracked vs HEAD. Sibling dirt vs HEAD (Console, MainFrame, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, REFORMATION_LOG) is other lanes. Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Console, MainFrame; no commit; no `PlaySound` | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Init: remount missing OnHide (`wireDockOnHide`), then `rememberSpecial(FRAME_NAME)`, then Refresh (Refresh remount stays) | **Pass.** Named-risk check. Brief vs `ConsoleDock.lua` ~276–278. Nested exact-block pin + reviewer SetScript spy + Refresh-entry probe. |
| Never replace an existing script | **Pass.** Named-risk check. |
| Do **not** reset drag persist | **Pass.** Named-risk check. Nested GetPoint + reviewer SV probe. |
| Do **not** pop a dismissed dock (Refresh keep) | **Pass.** Named-risk check. Nested stay-hidden + remounted-handler dismiss probe. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. Nested `CreateFrame` spy is **0**. Live `GetScript("OnShow")` stays nil after remount. |
| Update the B26-D / later keep-strings that forbade `wireDockOnHide` in Init | **Pass.** Named-risk check. B36-C / B39-D / B40-C now expect the remount. Isolated suite **775 / 0**. |
| Wipe list, nil OnHide, Init: OnHide restored, `ChurchOfBeefConsoleDock` re-listed once, no sound | **Pass.** Nested runtime pins. Reviewer probe matches. |
| Third Init does not replace OnHide | **Pass.** Named-risk check. |
| Nest `runB41C()` after `runB40C()` inside `runB27D()`; isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **775 / 0.** Wrap **24**. |

Wiki ESC via a named `UISpecialFrames` entry holds on the exclusive pair: existing-frame `Init` remounts a missing OnHide so a later widget Hide / ESC can sync `shown` false and live dismiss. Law 6 / §19.4 hold: remount Init is silent; no `IG_CHARACTER_INFO_*` whoosh. Law 10 / license 4 hold: stock Event Mode dock; title stays `DIRECTOR CONSOLE`; CloseButton stays hidden; no parchment. Bible §18.1 collapsible Director Console holds. B40-C Refresh remount, B39-D Show remount, B36-C Hide remount, B30-D Hide `rememberSpecial` remount, B27-D Show remount, B26-D Init remount, and B24-B `eventId` dismiss stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Widget Hide / ESC does not remount a niled OnHide. `CloseSpecialWindows` / `frame:Hide()` still bypass `ConsoleDock:Init` / `Hide` / `Show` / `Refresh`. A dropped OnHide that never hits those verbs still leaves `shown` true and dismiss unset; the next Init remounts the handler then Refreshs, and paints the dock again because dismiss was never recorded | **On contract.** The missing handler cannot remount itself. Brief scoped remount on existing-frame `Init` of a dock that already recorded dismiss, not a shown-repair of a raw widget Hide. Reviewer probe: Show, nil OnHide, `frame:Hide()` leaves `GetView().shown` true and OnHide nil; the next `ConsoleDock:Init` remounts the handler and paints because dismiss was never recorded. After a remounted Init of a **recorded** dismiss, the dock stays hidden. After a remounted Show, widget Hide **does** dismiss and same-event Init stays hidden. |
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven; a live remount that dropped the name is simulated by `UISpecialFrames = {}`; a dropped handler is simulated by `SetScript("OnHide", nil)` | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Init()` is a direct call, not a real ESC key; script identity, membership counts, dismiss stay, and drag point are pinned; the client's special-frame walk is not | **On contract.** Brief asked those pins on `ConsoleDock:Init`. Reviewer widget Hide closed the remount-when-present dismiss path on the stub. |
| Third-Init identity is vacuous if restore failed. `nil == nil` would pass; the restore pin fails first | **On contract.** The restore pin is the one that fails first; the identity pin is a keep after that. |
| Nested persist pin is widget `GetPoint`, not the SV table. Default Init point is `BOTTOMLEFT` 16, 80 | **On contract.** Brief asked no persist reset. Reviewer probe: saved `ui.consoleDock` table identity and `TOPLEFT` 24, 90 survive Init remount. |
| B36-C / B39-D / B40-C keep-strings were updated in place so the prior forbid-`wireDockOnHide` pins do not keep the suite red | **On contract.** Brief required those updates. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B40 leftover (`Init` remounted `rememberSpecial` then Refresh only; a niled OnHide stayed idle in the Init remount body until Refresh as a side effect) is this lane's spec. It is closed on the exclusive pair for the `ConsoleDock:Init` path.

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB / glue / MainFrame. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap is load-time only (unchanged). `runB41C()` re-pins **5** (Hud, Toasts, DecreeBanner, RecordsBook, slash). New remount locals sit in `runB41C()` inside `runB27D()` after `runB40C()`.

**Remount — Pass.** `wireDockOnHide` no-ops when a script exists and writes `lastView.shown` false plus live `dismissedEventId` only when OnHide later fires. Existing-frame Init remounts the missing handler, then remounts `rememberSpecial`, then Refresh. Create-path calls the helper after create-time `widget:Hide()` so mint Hide does not fire the remount; the Init remount body then no-ops. Show remount stays `wireDockOnHide` then `rememberSpecial` then `mayShow` / `paint`. Hide remount stays `wireDockOnHide` then `rememberSpecial` then `paint(false)`. Refresh remount stays `wireDockOnHide` then `rememberSpecial` then `mayShow` / `stayDismissed` / `paint`. Reviewer spy: restore `SetScript` delta 1 named OnHide on niled Init; existing / sentinel / third Init delta 0. `CreateFrame` delta 0 on remounts. Reviewer probe: niled handler is already restored when Refresh starts; niled handler + widget Hide does not remount; already-hidden `ConsoleDock:Init()` still restores the handler. Same frame pointer.

**Keep — Pass.** B40-C Refresh OnHide remount stays. B39-D Show OnHide remount stays. B36-C Hide OnHide remount stays. B30-D Hide `rememberSpecial` remount stays. B27-D Show remount stays. B26-D Init remount stays. B24-B `eventId` dismiss stays. `rememberSpecial` scan-then-append stays. Missing table no-ops. Wipe-to-empty, nil OnHide after a recorded dismiss, Init lists `ChurchOfBeefConsoleDock` once, restores OnHide, stays hidden, and keeps the same pointer. Third Init stays once, keeps identity, and stays dismissed. Drag point stays. Persist `ui.consoleDock` stays. Title / SANCTION + Expand / hidden CloseButton / no-sound / no-parchment stay. Isolation wrap stays. No new main-chunk locals.

---

## Strengths

- The delta is the brief: one call on the existing-frame `Init` path (`wireDockOnHide(frame)` immediately before the B26-D `rememberSpecial(FRAME_NAME)` then Refresh). An existing script is not replaced. Show / Hide / Refresh remount, persist helpers, create-path order, title, SANCTION + Expand, and hidden CloseButton were left alone. No new main-chunk test local and no new file local.
- B40's leftover (niled OnHide stayed idle in the Init remount body until Refresh as a side effect) is closed on `ConsoleDock:Init` with a source order pin and a runtime restore, not a second register helper. Reviewer Refresh-entry probe proves the handler is already restored before Refresh runs. Third-Init identity sits next to the wipe remount, so a replace-every-Init helper would fail.
- Stay-dismissed, persist GetPoint, `CreateFrame` 0, Show / Refresh / Hide keep, and wipe+Init uniqueness sit next to the restore pins, so a rebuild, a persist rewrite, or a dismissed pop would fail.
- The B36-C / B39-D / B40-C keep-strings that forbade `wireDockOnHide` in Init were updated in place, so this remount cannot land while the prior pins still expect a skip. Nest is after `runB40C()` inside `runB27D()`.
- Isolation stayed gated. Writer-reported **775 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `ConsoleDock:Init` / `Hide` / `Show` / `Refresh`. Reviewer probe: Show, nil OnHide, `frame:Hide()` leaves `GetView().shown` true and OnHide nil; the next Init remounts the handler then Refreshs and paints because dismiss was never recorded. Brief scoped remount on existing-frame `Init` of a dock that already recorded dismiss. A dropped handler that never hits those verbs stays idle until Init / Show / Hide / Refresh.

### Nit

1. **Third-Init identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

2. **Nested persist pin is widget `GetPoint`, not the SV table.** Default Init point is `BOTTOMLEFT` 16, 80. Reviewer probe: a saved `ui.consoleDock` table identity and `TOPLEFT` 24, 90 survive Init remount.

3. **B36-C / B39-D / B40-C Init keep-strings were updated in place.** Necessary so the prior forbid-`wireDockOnHide` pins do not keep the suite red. B26-D's own `runB26D()` never forbade the helper. Not a scope breach.

4. **Runtime restore-after-Init also passes if only Refresh remounted.** Nested `GetScript ~= nil` after `Init()` cannot by itself prove the Init body (Init still calls Refresh). Nested source order pin plus reviewer Refresh-entry / SetScript spies close that gap.

5. **Exclusive-pair diff is not a vs-HEAD ConsoleDock delta.** Packet is the B41-C-only Init remount + nested pins + B36-C / B39-D / B40-C keep-string updates. Both exclusive files are still untracked vs HEAD and also carry earlier dock batches. Report already says this.

6. **Isolation wrap is load-only.** Twenty-four pins under the first `if standalone then`. Nested B41-C re-pins five of them. Brief said the wrap stays; it did.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **775 / 0** was re-run here. Live ESC vs `CloseSpecialWindows` after a dropped OnHide is unproven on Anniversary. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Init remounts a missing OnHide via `wireDockOnHide`, then `rememberSpecial(FRAME_NAME)`, then Refresh; never replace an existing script; do not reset drag persist; do not pop a dismissed dock; no OnShow re-wire; no rebuild; no `PlaySound`; update the keep-strings that forbade `wireDockOnHide` in Init; wipe list, nil OnHide, Init restores OnHide and re-lists `ChurchOfBeefConsoleDock` once with no sound; third Init does not replace OnHide; nest after `runB40C()`. Live `Init` ~276–278 and `wireDockOnHide` ~202–217 match. Brief test pins sit in `runB41C()` after `runB40C()` inside `runB27D()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftover: widget Hide / ESC still cannot remount a niled OnHide (brief scoped `ConsoleDock:Init`; a raw Hide that never recorded dismiss will paint on the next Init). Nits listed above.

**3. Isolation count:** **775 passed, 0 failed.** Isolation wrap: **24**. `runB41C()` re-pins: **5**. Main-chunk locals: **56 / 200**. ConsoleDock file locals: **35**.

**4. Law:** Wiki ESC via `UISpecialFrames` holds. After a remounted Init, a present OnHide can sync dismiss on widget Hide. Law 6 / §19.4 hold: remount Init is silent. Law 10 / license 4 hold: stock Event Mode dock; no parchment; CloseButton hidden. Bible §18.1 holds. B40-C / B39-D / B36-C remounts stay. Drag persist stays. A recorded dismiss stays hidden.

**Leftovers:**
- Widget Hide / ESC does not remount a niled OnHide (Important, not must-fix; brief scoped `ConsoleDock:Init`). A raw Hide after a niled handler leaves `shown` true; the next Init remounts and paints.
- Third-Init identity is vacuous if restore failed.
- Nested persist pin is GetPoint, not the SV table (reviewer probe: SV stays).
- B36-C / B39-D / B40-C keep-strings were updated in place (necessary).
- Runtime restore-after-Init also passes via Refresh side effect (source order + Refresh-entry spy closed it).
- Exclusive-pair packet is not a vs-HEAD ConsoleDock delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Init` remounts a missing OnHide via `wireDockOnHide`, then `rememberSpecial(FRAME_NAME)`, then Refresh. An existing OnHide is not replaced. Drag persist stays. A dismissed dock stays hidden. No OnShow re-wire. No rebuild. No `PlaySound`. Wipe `UISpecialFrames` to `{}`, nil OnHide after a recorded dismiss, Init restores OnHide, lists `ChurchOfBeefConsoleDock` exactly once, stays hidden, and keeps the same pointer. Third Init keeps OnHide identity. B36-C / B39-D / B40-C keep-strings updated. `runB41C()` is nested inside `runB27D()` after `runB40C()`. Isolated `lua tests/test_console_dock.lua` **775 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
