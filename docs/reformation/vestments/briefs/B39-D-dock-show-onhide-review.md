Spec PASS

# B39-D — ConsoleDock Show remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B39-D existing-frame ConsoleDock Show remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B39-D-dock-show-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B39-D-dock-show-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B39-D-dock-show-onhide.diff` (B39-D-only exclusive-pair packet; live `ConsoleDock.lua` / `test_console_dock.lua` are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`wireDockOnHide` ~200–215 / existing-frame `Show` remount then `rememberSpecial(FRAME_NAME)` ~315–332 / `Hide` remount ~334–340 / `Refresh` remount ~284–313 / `Init` remount ~269–277 / create-path `build` ~217–267 / `rememberSpecial` ~189–195 / persist `savePoint` / `restorePoint`), and `tests/test_console_dock.lua` (isolation wrap, persist / ESC / B24-B per-event dismiss / B26-D Init remount / B27-D Show / Refresh remount / B30-D Hide remount / B36-C Hide OnHide remount pins, nested `runB39D()` inside `runB27D()` after `runB36C()`, plus the B36-C Show keep-string update); then ran `lua tests/test_console_dock.lua` (**630 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); B36-C leftover (`Show` remounted `rememberSpecial` only; a niled OnHide stayed idle until Hide); existing-frame `Show` remounts a missing OnHide (never replace), then `rememberSpecial(FRAME_NAME)`; do **not** reset drag persist; no OnShow re-wire; no rebuild; no `PlaySound` / `IG_CHARACTER_INFO_*`; B36-C Hide OnHide remount stays; B30-D Hide `rememberSpecial` remount stays; B27-D Refresh remount stays; B26-D Init remount stays; B24-B `eventId` dismiss stays. Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit glue, Console, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Show still skips `wireDockOnHide` | **Pass. Verified.** Live existing-frame `Show` is `wireDockOnHide(frame)` then `rememberSpecial(FRAME_NAME)` then `mayShow` / `paint`. Nested source pin: remount body has `wireAt < rememberAt`. B36-C keep-string now expects `wireDockOnHide` in the Show body. Nested runtime: wipe list, nil OnHide, Show restores a script. Reviewer spy: wrapped `SetScript` saw **1** call named `OnHide` on the niled Show. Reviewer probe: not-pope Show still remounts then `paint(false)`. |
| Existing OnHide replaced | **Pass. Verified.** Helper is `if existing then return`. Nested: second Show and third Show keep `restored`; source pin `if existing then return`. Reviewer spy: wrapped `SetScript` saw **0** OnHide calls on the second and third Show. Reviewer probe: a sentinel OnHide survives Show. Hide remount still uses the same helper. |
| Drag persist reset | **Pass. Verified.** Remount body has no `restorePoint` / `savePoint` / `consoleDock`. Nested: GetPoint after Show matches the pre-wipe Init point (all five returns). Reviewer probe: saved `ChurchOfBeefDB.ui.consoleDock` table identity and `x` / `y` stay; widget stays `TOPLEFT` 24, 90. `restorePoint` still lives only in `build()`. `savePoint` still lives only on TitleBar `OnDragStop`. |
| `PlaySound` | **Pass.** File has no `PlaySound` / `IG_CHARACTER_INFO`. Show body and remount body have neither. Nested: first Show and third Show leave `sounds` unchanged. Suite-end pin is still `sounds == 0`. Reviewer spy: remount / third Show / persist Show stay 0. |
| B36-C keep-string not updated (suite red) | **Pass. Verified.** Both B36-C pins that forbade Show remount now expect it: `showBody` finds `wireDockOnHide`; live nile then Show asserts `GetScript("OnHide") ~= nil`. Isolated suite **630 / 0**. A leftover forbid-string would fail those two asserts. |
| Not nested after `runB36C()` | **Pass.** `runB39D()` is a nested `local function` inside `runB27D()` after the `runB36C()` call (`test_console_dock.lua` ~1112 / ~1122–1273). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: test main chunk still **56** locals (cap 200), same as B36-C. ConsoleDock file locals stay **35** (no new helper). |
| Isolated suite not exit 0 / wrap rewritten / exclusive breach | **Pass. Verified.** 630 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**24** nil pins). `runB39D()` re-pins 5 of them. Packet is the two named files. Both exclusive files are still untracked vs HEAD. Sibling dirt vs HEAD (Console, MainFrame, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, REFORMATION_LOG) is other lanes. Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Console, MainFrame; no commit; no `PlaySound` | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Show: remount missing OnHide (`wireDockOnHide`), then `rememberSpecial(FRAME_NAME)` | **Pass.** Brief vs `ConsoleDock.lua` ~324–325. Nested exact-block pin + reviewer SetScript spy. |
| Never replace an existing script | **Pass.** Named-risk check. |
| Do **not** reset drag persist | **Pass.** Named-risk check. Nested GetPoint + reviewer SV probe. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. Nested `CreateFrame` spy is **0**. Live `GetScript("OnShow")` stays nil after remount. |
| Update the B36-C keep-string that forbade `wireDockOnHide` in Show | **Pass.** Named-risk check. Source + live nile both updated in place. |
| Wipe list, nil OnHide, Show: OnHide restored, `ChurchOfBeefConsoleDock` re-listed once, no sound | **Pass.** Nested runtime pins. Reviewer probe matches. |
| Third Show does not replace OnHide | **Pass.** Named-risk check. |
| Nest `runB39D()` after `runB36C()` inside `runB27D()`; isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **630 / 0.** Wrap **24**. |

Wiki ESC via a named `UISpecialFrames` entry holds on the exclusive pair: existing-frame `Show` remounts a missing OnHide so a later widget Hide / ESC can sync `shown` false and live dismiss. Law 6 / §19.4 hold: remount Show is silent; no `IG_CHARACTER_INFO_*` whoosh. Law 10 / license 4 hold: stock Event Mode dock; title stays `DIRECTOR CONSOLE`; CloseButton stays hidden; no parchment. Bible §18.1 collapsible Director Console holds. B36-C Hide remount, B30-D Hide `rememberSpecial` remount, B27-D Refresh remount, B26-D Init remount, and B24-B `eventId` dismiss stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Refresh / Init remount still skip a niled OnHide | **On contract.** Brief asked Show-only remount and no OnShow re-wire. Nested Refresh / Init refuse pins stay. Reviewer probe: niled script stays nil across Refresh and Init; the next Show remounts. |
| Widget Hide / ESC does not remount a niled OnHide. `CloseSpecialWindows` / `frame:Hide()` still bypass `ConsoleDock:Show` and `ConsoleDock:Hide` | **On contract.** The missing handler cannot remount itself. Brief scoped remount on existing-frame `Show`. Reviewer probe: Show, nil OnHide, `frame:Hide()` leaves `GetView().shown` true and OnHide nil; the next `ConsoleDock:Show` remounts and paints. After a remounted Show, widget Hide **does** dismiss and same-event Refresh stays hidden. |
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven; a live remount that dropped the name is simulated by `UISpecialFrames = {}`; a dropped handler is simulated by `SetScript("OnHide", nil)` | **Not a miss.** Brief asked isolated green + wipe-to-`{}` then Show restores OnHide and lists once. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Show()` is a direct call, not a real ESC key; script identity, membership counts, and drag point are pinned; the client's special-frame walk is not | **Not a miss.** Brief asked those pins on `ConsoleDock:Show`. Reviewer widget Hide closed the remount-when-present dismiss path on the stub. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B36 leftover (`Show` remounted `rememberSpecial` only; a niled OnHide stayed idle until Hide) is this lane's spec. It is closed on the exclusive pair when the next show goes through `ConsoleDock:Show`.

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB / glue / MainFrame. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap is load-time only (unchanged). `runB39D()` re-pins **5** (Hud, Toasts, DecreeBanner, RecordsBook, slash). New remount locals sit in `runB39D()` inside `runB27D()` after `runB36C()`.

**Existing-frame remount — Pass.** `Show` calls `wireDockOnHide(frame)` when `frame` exists, then `rememberSpecial(FRAME_NAME)`, then `mayShow` / `paint`. The helper no-ops when a script exists and writes `lastView.shown` false plus live `dismissedEventId` only when OnHide later fires. It does not `build()`, does not `CreateFrame`, does not `PlaySound`, does not `restorePoint` / `savePoint`, and does not wire OnShow. Failed / not-pope Show still remounts then `paint(false)`. Hide remount stays `wireDockOnHide` then `rememberSpecial` then `paint(false)`. Refresh and Init remount still call `rememberSpecial(FRAME_NAME)` and do not remount OnHide. Reviewer spy: restore `SetScript` delta 1 named OnHide on niled Show; existing / sentinel / third Show delta 0. `CreateFrame` delta 0 on remounts.

**Keep — Pass.** Wipe-to-empty, nil OnHide, Show lists `ChurchOfBeefConsoleDock` once, restores OnHide, and keeps the same pointer. Third Show stays once and keeps identity. Drag point stays. Persist `ui.consoleDock` stays. Hide remount still restores a niled script when Show is not the remounter (reviewer probe). Same-event Hide + Refresh stays hidden. B24-B `eventId` dismiss stays. Title / SANCTION + Expand / hidden CloseButton / no-sound / no-parchment stay. Isolation wrap stays. No new main-chunk locals.

---

## Strengths

- The delta is one call on the existing-frame `Show` path: `wireDockOnHide(frame)` immediately before the B27-D `rememberSpecial(FRAME_NAME)`. Hide / Refresh / Init remount, persist helpers, create-path order, title, SANCTION + Expand, and hidden CloseButton were left alone. No new main-chunk test local and no new file local.
- B36 leftover (niled OnHide stayed nil across `Show`; later ESC then skipped dismiss until Hide) is closed on `ConsoleDock:Show` with a runtime restore, not only a source `find`. Reviewer probe: remounted Show then widget Hide sets `shown` false and same-event Refresh stays hidden.
- Third-Show identity, `CreateFrame` 0, persist GetPoint, Refresh / Init refuse, and wipe+Show uniqueness sit next to the restore pins, so a rebuild, a replace-every-Show helper, a persist rewrite, or a Refresh remount would fail.
- The B36-C keep-string that forbade `wireDockOnHide` in Show was updated in place (source + live nile), so this remount cannot land while the prior pin still expects a skip. Nest is after `runB36C()` inside `runB27D()`.
- Isolation stayed gated. Writer-reported **630 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Widget Hide / ESC does not remount a niled OnHide.** Reviewer probe: Show, nil OnHide, `frame:Hide()` leaves `GetView().shown` true and OnHide nil; Refresh paints again. `ConsoleDock:Show()` now remounts then paints, so the next Show path syncs. Brief scoped remount on existing-frame `Show`, not a shown-repair of a raw widget Hide. A dropped handler that never hits `ConsoleDock:Show` or `ConsoleDock:Hide` stays idle.

2. **Refresh / Init remount still skip a niled OnHide.** Brief asked Show-only remount and no OnShow re-wire. Reviewer probe: niled script stays nil across Refresh and Init; the next Show remounts.

3. **B39-D live pin checks `GetScript ~= nil`, not that the remounted handler dismisses.** Nested wipe + Show asserts presence, uniqueness, persist point, and third-Show identity. Reviewer probe closed the ESC-after-remount dismiss path (widget Hide then same-event Refresh stays hidden). Do not expand this exclusive pair to pin dismiss unless a later lane asks.

### Nit

1. **Third-Show identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

2. **B36-C live Hide remount is no longer independently hit in the nested B36-C path.** That block now nils OnHide, Shows (remounts), then Hides (helper no-ops because a script exists). Hide remount order stays source-pinned. Reviewer probe: niled shown widget + `ConsoleDock:Hide` without a remounting Show still restores and dismisses.

3. **Nested persist pin is widget `GetPoint`, not the SV table.** Default Init point is `BOTTOMLEFT` 16, 80. Reviewer probe: a saved `ui.consoleDock` table identity and `TOPLEFT` 24, 90 survive Show remount.

4. **B36-C exact Show keep-strings were updated in place.** Necessary so the prior forbid-`wireDockOnHide` pin does not keep the suite red. Not a scope breach.

5. **Exclusive-pair diff is not a vs-HEAD ConsoleDock delta.** Packet is the B39-D-only Show remount + nested pins + B36-C keep-string updates. Both exclusive files are still untracked vs HEAD and also carry earlier dock batches. Report already says this.

6. **Isolation wrap is load-only.** Twenty-four pins under the load-time `if standalone then`. `runB39D()` re-pins five. Brief said the wrap stays; it did.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **630 / 0** was re-run here. Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Show remounts a missing OnHide via `wireDockOnHide` then `rememberSpecial(FRAME_NAME)`; never replace an existing script; do not reset drag persist; no OnShow re-wire; no rebuild; no `PlaySound`; wipe list, nil OnHide, Show restores OnHide and re-lists `ChurchOfBeefConsoleDock` once with no sound; third Show does not replace OnHide; B36-C keep-string updated; nest after `runB36C()`. Live `Show` ~324–325 matches. Brief test pins sit in `runB39D()` after `runB36C()` inside `runB27D()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: widget Hide / ESC cannot remount a niled OnHide (required keep; next `Show` remounts); Refresh / Init still skip a niled OnHide (required keep); B39-D live pin is presence, not dismiss (reviewer probe closed dismiss). Nits listed above.

**3. Isolation count:** **630 passed, 0 failed.** Isolation wrap: **24**. `runB39D()` re-pins: **5**. Main-chunk locals: **56 / 200**. ConsoleDock file locals: **35**.

**4. Law:** Wiki ESC via `UISpecialFrames` holds. After a remounted Show, a present OnHide can sync dismiss on widget Hide. Law 6 / §19.4 hold: remount Show is silent. Law 10 / license 4 hold: stock Event Mode dock; no parchment; CloseButton hidden. Bible §18.1 holds. B36-C Hide remount stays. Drag persist stays.

**Leftovers:**
- Widget Hide / ESC does not remount a niled OnHide (Important, not must-fix; required keep).
- Refresh / Init remount still skip a niled OnHide (Important, not must-fix; required keep).
- B39-D live pin is `GetScript ~= nil`, not dismiss (reviewer probe: remounted Show then widget Hide dismisses).
- B36-C nested Hide remount is no longer independently hit after the Show remount (reviewer probe: Hide-only remount still works).
- Nested persist pin is GetPoint, not the SV table (reviewer probe: SV stays).
- B36-C keep-strings were updated in place (necessary).
- Exclusive-pair packet is not a vs-HEAD ConsoleDock delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Show` remounts a missing OnHide via `wireDockOnHide` then `rememberSpecial(FRAME_NAME)`. Does not replace an existing script. Does not reset drag persist. No OnShow re-wire. No rebuild. No `PlaySound`. Wipe `UISpecialFrames` to `{}`, nil OnHide, Show restores OnHide, lists `ChurchOfBeefConsoleDock` exactly once, and keeps the same pointer. Third Show keeps OnHide identity. B36-C keep-string updated. `runB39D()` is nested inside `runB27D()` after `runB36C()`. Isolated `lua tests/test_console_dock.lua` **630 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
