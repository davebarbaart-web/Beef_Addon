Spec PASS

# B40-C — ConsoleDock Refresh remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B40-C existing-frame ConsoleDock Refresh remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B40-C-dock-refresh-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B40-C-dock-refresh-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B40-C-dock-refresh-onhide.diff` (B40-C-only exclusive-pair packet; live `ConsoleDock.lua` / `test_console_dock.lua` are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`wireDockOnHide` ~201–216 / existing-frame `Refresh` remount then `rememberSpecial(FRAME_NAME)` ~285–315 / `Show` remount ~317–334 / `Hide` remount ~336–342 / `Init` remount ~270–278 / create-path `build` ~218–268 / `rememberSpecial` ~190–196 / persist `savePoint` / `restorePoint`), and `tests/test_console_dock.lua` (isolation wrap, persist / ESC / B24-B per-event dismiss / B26-D Init remount / B27-D Show / Refresh remount / B30-D Hide remount / B36-C Hide OnHide remount / B39-D Show OnHide remount pins, nested `runB40C()` inside `runB27D()` after `runB39D()`, plus the B36-C and B39-D Refresh keep-string updates); then ran `lua tests/test_console_dock.lua` (**702 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); B39-D leftover (`Refresh` remounted `rememberSpecial` only; a niled OnHide stayed idle until Show / Hide); existing-frame `Refresh` remounts a missing OnHide (never replace), then `rememberSpecial(FRAME_NAME)`; do **not** reset drag persist; do **not** pop a dismissed dock; no OnShow re-wire; no rebuild; no `PlaySound` / `IG_CHARACTER_INFO_*`; B39-D Show OnHide remount stays; B36-C Hide OnHide remount stays; B30-D Hide `rememberSpecial` remount stays; B27-D Show remount stays; B26-D Init remount stays; B24-B `eventId` dismiss stays. Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit glue, Console, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Refresh still skips `wireDockOnHide` | **Pass. Verified.** Live existing-frame `Refresh` is `wireDockOnHide(frame)` then `rememberSpecial(FRAME_NAME)` then `mayShow` / `stayDismissed` / `paint`. Nested source pin: remount body has `wireAt < rememberAt`. B36-C and B39-D keep-strings now expect `wireDockOnHide` in the Refresh body. Nested runtime: wipe list, nil OnHide, Refresh restores a script. Reviewer spy: wrapped `SetScript` saw **1** call named `OnHide` on the niled Refresh. Reviewer probe: not-pope Refresh and QUIET Refresh still remount then `paint(false)`. Shown-dock niled Refresh remounts and stays painted. |
| Existing OnHide replaced | **Pass. Verified.** Helper is `if existing then return`. Nested: second Refresh and third Refresh keep `restored`; source pin `if existing then return`. Reviewer spy: wrapped `SetScript` saw **0** OnHide calls on the second and third Refresh. Reviewer probe: a sentinel OnHide survives Refresh. Show / Hide remount still use the same helper. |
| Drag persist reset | **Pass. Verified.** Remount body has no `restorePoint` / `savePoint` / `consoleDock`. Nested: GetPoint after Refresh matches the pre-wipe Init point (all five returns). Reviewer probe: saved `ChurchOfBeefDB.ui.consoleDock` table identity and `x` / `y` stay; widget stays `TOPLEFT` 24, 90. `restorePoint` still lives only in `build()`. `savePoint` still lives only on TitleBar `OnDragStop`. |
| Dismissed dock popped | **Pass. Verified.** Nested path: widget Hide records dismiss, then nil OnHide, then Refresh. `stay.shown` is false; widget stays hidden on first / second / third Refresh. Reviewer probe: remounted handler then `Show` then widget Hide sets `shown` false and same-event Refresh stays hidden. Sentinel Refresh after a real dismiss also stays hidden. |
| `PlaySound` | **Pass.** File has no `PlaySound` / `IG_CHARACTER_INFO`. Refresh body and remount body have neither. Nested: first Refresh and third Refresh leave `sounds` unchanged. Suite-end pin is still `sounds == 0`. Reviewer spy: remount / third Refresh / persist Refresh stay 0. |
| Not nested after `runB39D()` | **Pass.** `runB40C()` is a nested `local function` inside `runB27D()` after the `runB39D()` call (`test_console_dock.lua` ~1276 / ~1287–1444). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: test main chunk still **56** locals (cap 200), same as B39-D. ConsoleDock file locals stay **35** (no new helper). |
| Isolated suite not exit 0 | **Pass. Verified.** 702 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**24** nil pins). `runB40C()` re-pins 5 of them. Packet is the two named files. Both exclusive files are still untracked vs HEAD. Sibling dirt vs HEAD (Console, MainFrame, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, REFORMATION_LOG) is other lanes. Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Console, MainFrame; no commit; no `PlaySound` | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Refresh: remount missing OnHide (`wireDockOnHide`), then `rememberSpecial(FRAME_NAME)` | **Pass.** Brief vs `ConsoleDock.lua` ~300–301. Nested exact-block pin + reviewer SetScript spy. |
| Never replace an existing script | **Pass.** Named-risk check. |
| Do **not** reset drag persist | **Pass.** Named-risk check. Nested GetPoint + reviewer SV probe. |
| Do **not** pop a dismissed dock | **Pass.** Named-risk check. Nested stay-hidden + remounted-handler dismiss probe. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. Nested `CreateFrame` spy is **0**. Live `GetScript("OnShow")` stays nil after remount. |
| Update the B36-C and B39-D keep-strings that forbade `wireDockOnHide` in Refresh | **Pass.** Both now expect `wireDockOnHide` in the Refresh body. Isolated suite **702 / 0**. A leftover forbid-string would fail those asserts. |
| Wipe list, nil OnHide, Refresh: OnHide restored, `ChurchOfBeefConsoleDock` re-listed once, no sound | **Pass.** Nested runtime pins. Reviewer probe matches. |
| Third Refresh does not replace OnHide | **Pass.** Named-risk check. |
| Nest `runB40C()` after `runB39D()` inside `runB27D()`; isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **702 / 0.** Wrap **24**. |

Wiki ESC via a named `UISpecialFrames` entry holds on the exclusive pair: existing-frame `Refresh` remounts a missing OnHide so a later widget Hide / ESC can sync `shown` false and live dismiss. Law 6 / §19.4 hold: remount Refresh is silent; no `IG_CHARACTER_INFO_*` whoosh. Law 10 / license 4 hold: stock Event Mode dock; title stays `DIRECTOR CONSOLE`; CloseButton stays hidden; no parchment. Bible §18.1 collapsible Director Console holds. B39-D Show remount, B36-C Hide remount, B30-D Hide `rememberSpecial` remount, B27-D Show remount, B26-D Init remount, and B24-B `eventId` dismiss stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Init remount body still skips a niled OnHide | **On contract.** Brief asked Refresh-only remount and no OnShow re-wire. Nested Init refuse pin stays (`wireDockOnHide` absent from the Init remount body). Reviewer probe: Init then Refresh remounts as a Refresh side effect and stays dismissed. |
| Widget Hide / ESC does not remount a niled OnHide. `CloseSpecialWindows` / `frame:Hide()` still bypass `ConsoleDock:Show` / `Hide` / `Refresh` | **On contract.** The missing handler cannot remount itself. Brief scoped remount on existing-frame `Refresh`. Reviewer probe: Show, nil OnHide, `frame:Hide()` leaves `GetView().shown` true and OnHide nil; the next `ConsoleDock:Refresh` remounts the handler and paints because dismiss was never recorded. After a remounted Refresh of a **recorded** dismiss, the dock stays hidden. After a remounted Show, widget Hide **does** dismiss and same-event Refresh stays hidden. |
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven; a live remount that dropped the name is simulated by `UISpecialFrames = {}`; a dropped handler is simulated by `SetScript("OnHide", nil)` | **Not a miss.** Brief asked isolated green + wipe-to-`{}` then Refresh restores OnHide and lists once. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Refresh()` is a direct call, not a real ESC key; script identity, membership counts, dismiss stay, and drag point are pinned; the client's special-frame walk is not | **Not a miss.** Brief asked those pins on `ConsoleDock:Refresh`. Reviewer widget Hide closed the remount-when-present dismiss path on the stub. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B39 leftover (`Refresh` remounted `rememberSpecial` only; a niled OnHide stayed idle until Show / Hide) is this lane's spec. It is closed on the exclusive pair when the next paint goes through `ConsoleDock:Refresh`.

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB / glue / MainFrame. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap is load-time only (unchanged). `runB40C()` re-pins **5** (Hud, Toasts, DecreeBanner, RecordsBook, slash). New remount locals sit in `runB40C()` inside `runB27D()` after `runB39D()`.

**Existing-frame remount — Pass.** `Refresh` calls `wireDockOnHide(frame)` when `frame` exists, then `rememberSpecial(FRAME_NAME)`, then `mayShow` / `stayDismissed` / `paint`. The helper no-ops when a script exists and writes `lastView.shown` false plus live `dismissedEventId` only when OnHide later fires. It does not `build()`, does not `CreateFrame`, does not `PlaySound`, does not `restorePoint` / `savePoint`, and does not wire OnShow. Failed / not-pope / QUIET Refresh still remounts then `paint(false)`. Show remount stays `wireDockOnHide` then `rememberSpecial` then `mayShow` / `paint`. Hide remount stays `wireDockOnHide` then `rememberSpecial` then `paint(false)`. Init remount still calls `rememberSpecial(FRAME_NAME)` and has no `wireDockOnHide` in its own body; it then calls `Refresh`, which remounts. Reviewer spy: restore `SetScript` delta 1 named OnHide on niled Refresh; existing / sentinel / third Refresh delta 0. `CreateFrame` delta 0 on remounts.

**Keep — Pass.** Wipe-to-empty, nil OnHide after a recorded dismiss, Refresh lists `ChurchOfBeefConsoleDock` once, restores OnHide, stays hidden, and keeps the same pointer. Third Refresh stays once, keeps identity, and stays dismissed. Drag point stays. Persist `ui.consoleDock` stays. Show remount still restores a niled script when Refresh is not the remounter (source pin). Hide remount still restores a niled script when Show / Refresh are not the remounter (reviewer probe). Same-event Hide + Refresh stays hidden. B24-B `eventId` dismiss stays. Title / SANCTION + Expand / hidden CloseButton / no-sound / no-parchment stay. Isolation wrap stays. No new main-chunk locals.

---

## Strengths

- The delta is one call on the existing-frame `Refresh` path: `wireDockOnHide(frame)` immediately before the B27-D `rememberSpecial(FRAME_NAME)`. Show / Hide / Init remount, persist helpers, create-path order, title, SANCTION + Expand, and hidden CloseButton were left alone. No new main-chunk test local and no new file local.
- B39 leftover (niled OnHide stayed nil across `Refresh`; later ESC then skipped dismiss until Show / Hide) is closed on `ConsoleDock:Refresh` with a runtime restore, not only a source `find`. Nested wipe + dismiss-then-nil Refresh stays hidden. Reviewer probe: remounted handler then Show then widget Hide sets `shown` false and same-event Refresh stays hidden.
- Third-Refresh identity, `CreateFrame` 0, persist GetPoint, stay-dismissed, Show / Hide keep, Init body refuse, and wipe+Refresh uniqueness sit next to the restore pins, so a rebuild, a replace-every-Refresh helper, a persist rewrite, or a dismissed pop would fail.
- The B36-C and B39-D keep-strings that forbade `wireDockOnHide` in Refresh were updated in place, so this remount cannot land while the prior pins still expect a skip. Nest is after `runB39D()` inside `runB27D()`.
- Isolation stayed gated. Writer-reported **702 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Widget Hide / ESC does not remount a niled OnHide.** Reviewer probe: Show, nil OnHide, `frame:Hide()` leaves `GetView().shown` true and OnHide nil; Refresh remounts the handler and paints because dismiss was never recorded. Brief scoped remount on existing-frame `Refresh` of a dock that already recorded dismiss, not a shown-repair of a raw widget Hide. A dropped handler that never hits `ConsoleDock:Show`, `ConsoleDock:Hide`, or `ConsoleDock:Refresh` stays idle.

2. **Init remount body still skips a niled OnHide.** Brief asked Refresh-only remount and no OnShow re-wire. Nested Init refuse pin stays. Reviewer probe: Init then Refresh remounts as a Refresh side effect and stays dismissed.

3. **B40-C live pin checks `GetScript ~= nil` and stay-hidden after a dismiss recorded before the nil.** Nested wipe + Refresh asserts presence, uniqueness, persist point, third-Refresh identity, and does-not-pop. Reviewer probe closed the remounted-handler dismiss path (`Show` then widget Hide then same-event Refresh stays hidden). Do not expand this exclusive pair to pin that path unless a later lane asks.

### Nit

1. **Third-Refresh identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

2. **B36-C live Hide remount is no longer independently hit in the nested B36-C path.** That block still nils OnHide, Shows (remounts), then Hides (helper no-ops because a script exists). Hide remount order stays source-pinned. Reviewer probe: niled shown widget + `ConsoleDock:Hide` without a remounting Show / Refresh still restores and dismisses.

3. **Nested persist pin is widget `GetPoint`, not the SV table.** Default Init point is `BOTTOMLEFT` 16, 80. Reviewer probe: a saved `ui.consoleDock` table identity and `TOPLEFT` 24, 90 survive Refresh remount.

4. **B36-C and B39-D exact Refresh keep-strings were updated in place.** Necessary so the prior forbid-`wireDockOnHide` pins do not keep the suite red. Not a scope breach.

5. **Exclusive-pair diff is not a vs-HEAD ConsoleDock delta.** Packet is the B40-C-only Refresh remount + nested pins + B36-C / B39-D keep-string updates. Both exclusive files are still untracked vs HEAD and also carry earlier dock batches. Report already says this.

6. **Isolation wrap is load-only.** Twenty-four pins under the load-time `if standalone then`. `runB40C()` re-pins five. Brief said the wrap stays; it did.

7. **`runB40C()` body is over-indented** relative to `runB39D()`, and `remountRefresh:find("build()")` is asserted twice. Cosmetic only.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **702 / 0** was re-run here. Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Refresh remounts a missing OnHide via `wireDockOnHide` then `rememberSpecial(FRAME_NAME)`; never replace an existing script; do not reset drag persist; do not pop a dismissed dock; no OnShow re-wire; no rebuild; no `PlaySound`; wipe list, nil OnHide, Refresh restores OnHide and re-lists `ChurchOfBeefConsoleDock` once with no sound; third Refresh does not replace OnHide; nest after `runB39D()`. Live `Refresh` ~300–301 matches. Brief test pins sit in `runB40C()` after `runB39D()` inside `runB27D()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: widget Hide / ESC cannot remount a niled OnHide (required keep; next Refresh remounts, and a raw Hide that never recorded dismiss will paint); Init body still skips `wireDockOnHide` (required keep; Refresh side effect remounts); B40-C live pin is presence plus stay-hidden after a pre-nil dismiss (reviewer probe closed remounted-handler dismiss). Nits listed above.

**3. Isolation count:** **702 passed, 0 failed.** Isolation wrap: **24**. `runB40C()` re-pins: **5**. Main-chunk locals: **56 / 200**. ConsoleDock file locals: **35**.

**4. Law:** Wiki ESC via `UISpecialFrames` holds. After a remounted Refresh, a present OnHide can sync dismiss on widget Hide. Law 6 / §19.4 hold: remount Refresh is silent. Law 10 / license 4 hold: stock Event Mode dock; no parchment; CloseButton hidden. Bible §18.1 holds. B39-D Show remount and B36-C Hide remount stay. Drag persist stays. A recorded dismiss stays hidden.

**Leftovers:**
- Widget Hide / ESC does not remount a niled OnHide (Important, not must-fix; required keep). A raw Hide after a niled handler leaves `shown` true; the next Refresh remounts and paints.
- Init remount body still skips a niled OnHide (Important, not must-fix; required keep; Refresh side effect remounts).
- B40-C live pin is `GetScript ~= nil` plus stay-hidden after a pre-nil dismiss (reviewer probe: remounted handler then Show then widget Hide dismisses).
- B36-C nested Hide remount is no longer independently hit after the Show remount (reviewer probe: Hide-only remount still works).
- Nested persist pin is GetPoint, not the SV table (reviewer probe: SV stays).
- B36-C / B39-D keep-strings were updated in place (necessary).
- Exclusive-pair packet is not a vs-HEAD ConsoleDock delta.
- Isolation wrap is load-only.
- `runB40C()` over-indent and duplicate `build()` pin.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Refresh` remounts a missing OnHide via `wireDockOnHide` then `rememberSpecial(FRAME_NAME)`. Does not replace an existing script. Does not reset drag persist. Does not pop a dismissed dock. No OnShow re-wire. No rebuild. No `PlaySound`. Wipe `UISpecialFrames` to `{}`, nil OnHide after a recorded dismiss, Refresh restores OnHide, lists `ChurchOfBeefConsoleDock` exactly once, stays hidden, and keeps the same pointer. Third Refresh keeps OnHide identity. B36-C / B39-D keep-strings updated. `runB40C()` is nested inside `runB27D()` after `runB39D()`. Isolated `lua tests/test_console_dock.lua` **702 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
