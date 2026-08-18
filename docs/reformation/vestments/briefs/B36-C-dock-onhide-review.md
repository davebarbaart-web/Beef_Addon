Spec PASS

# B36-C — ConsoleDock Hide remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B36-C ConsoleDock Hide remounts missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B36-C-dock-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B36-C-dock-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B36-C-dock-onhide.diff` (B36-C-only exclusive-pair packet; live `ConsoleDock.lua` / `test_console_dock.lua` are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`wireDockOnHide` / `build` create-time `widget:Hide()` then helper / existing-frame `Hide` remount then `rememberSpecial(FRAME_NAME)` then `paint(false)` / `Init` / `Show` / `Refresh` remount stay), and `tests/test_console_dock.lua` (isolation wrap, persist / ESC / B24-B per-event dismiss / B26-D Init remount / B27-D Show / Refresh remount / B30-D Hide remount pins, `runB36C()` nested inside `runB27D()` after `runB30D()`); then ran `lua tests/test_console_dock.lua` (**563 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); B30 leftover (`Hide` remounted `rememberSpecial` then `paint(false)` only; a niled OnHide then ESC / `frame:Hide()` left `shown` true and dismiss unset; next Refresh painted the dock again); existing-frame `Hide` remounts a missing OnHide (never replace), then `rememberSpecial(FRAME_NAME)`, then `paint(false)`; `FRAME_NAME` stays `ChurchOfBeefConsoleDock`; no OnShow re-wire; no rebuild; B30-D Hide `rememberSpecial` remount stays; B27-D Show / Refresh remount stays; B26-D Init remount stays; B24-B `eventId` dismiss stays. Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Existing-frame `Hide` still skips a missing OnHide (B30 leftover) | **Pass. Verified.** Live `Hide` is `if frame then wireDockOnHide(frame)` then `rememberSpecial(FRAME_NAME)` then `paint(false)`. Helper wires only when `GetScript("OnHide")` is nil. Pins: wipe list, nil OnHide, Show live, Hide restores; `GetView().shown` false; same-event Refresh stays hidden. Reviewer probe: niled script, Hide, `GetScript` is a function; wrapped `SetScript` saw **1** call named `OnHide`. Hide body order is wire then remember then `paint(false)`. |
| `Hide` / helper replaces an existing script | **Pass. Verified.** Helper is `if existing then return`. Pins: second Hide and third Hide after restore keep `restored`. Reviewer spy: wrapped `SetScript` saw **0** OnHide calls on Hide with the restored script and with a sentinel OnHide. Sentinel identity stayed. |
| Restore rebuilds, Shows, or remounts OnShow | **Pass. Verified.** Hide remount body has no `build()` / `CreateFrame` / `:Show()` / `self:Show` / `OnShow` / `PlaySound`. Pins: wrapped `CreateFrame` saw 0 calls on live Show+Hide after nile; third Hide same pointer. Reviewer probe: `CreateFrame` delta **0** on remount Hide, wipe-while-shown Hide, and no-frame Hide. Show / Refresh / Init bodies have no `wireDockOnHide`. Reviewer probe: niled script stays nil across Show, Refresh, and Init. |
| Live dismiss not set / same-event Refresh pops / B30-D remember remount dies | **Pass. Verified.** Show live then remount Hide: OnHide restored, widget hidden, not `EndEvent`, same-event Refresh stays hidden, `ChurchOfBeefConsoleDock` listed once. B30-D wipe+Hide uniqueness and B27-D / B26-D remount pins sit above the nest and stay green. Reviewer probe: remount Hide then Refresh stays hidden; `EndEvent` then `StartEvent` + Refresh **shows**; `Show()` after dismiss **shows**. Live source has **5** `rememberSpecial(FRAME_NAME)` sites (`build()` + Init + Refresh + Show + Hide). |
| Title / CloseButton / persist / SANCTION + Expand / sound / parchment / `FRAME_NAME` | **Pass.** `FRAME_NAME` is still `ChurchOfBeefConsoleDock`. `TITLE` is still exactly `DIRECTOR CONSOLE`. CloseButton stays `Hide()`d. `ui.consoleDock` / `ANCHORS` / stock `BasicFrameTemplate` / SANCTION + Expand pins stay after the nest. Source has no `PlaySound`, `IG_CHARACTER_INFO`, `parchment`, or `cooldown`. `OnShow` appears only in a helper comment (`Do not wire OnShow`). Suite `sounds == 0`. Reviewer spy: remount / dismiss / new-event path stays 0. |
| New main-chunk local breaks the Lua 5.1 200-local cap | **Pass.** `runB36C` is a nested `local function` inside `runB27D()` after `runB30D()`. Create-path order pin reused `hideAt` / `onHideAt`. No new main-chunk local. `luac -l -p tests/test_console_dock.lua`: main chunk **56 locals** (cap 200), same as B30-D. ConsoleDock file locals are **35** (`wireDockOnHide` is the new file local). |
| Isolated suite not exit 0 / exclusive file breach | **Pass. Verified.** 563 passed, 0 failed. Writer-reported count matches. Lane implementation is the two named files. Packet is two hunks (extract helper + create-path call + existing-frame `Hide` remount; header comment + create-path order rematch + nested `runB36C()`). Both exclusive files are still untracked vs HEAD. Sibling dirt in this workspace is other lanes (Console, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, REFORMATION_LOG). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, glue; no commit; no `PlaySound` | **Pass.** Named-risk check. B36-C packet does not touch `Console.lua`. |
| Extract `wireDockOnHide` (never replace an existing script). No OnShow re-wire | **Pass.** Helper is `if existing then return`. Body has no `OnShow` / `PlaySound` / `CreateFrame` / `build()`. Create-path and existing-frame `Hide` call the helper. |
| Existing-frame `Hide`: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `paint(false)` | **Pass.** Live order. Source pin in `runB36C()`: `wireDockOnHide` before `rememberSpecial` before `paint(false)`. No-frame `Hide` still `paint(false)` only. |
| `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. Do not rebuild | **Pass.** Named-risk check. |
| Wipe list, nil OnHide, Show a live dock, Hide: OnHide restored, `GetView().shown == false`, live dismiss set, name listed once, no sound | **Pass.** Nested runtime pins. Reviewer probe matches. |
| Third Hide does not replace OnHide | **Pass.** Named-risk check. |
| Tests after `runB30D()` inside `runB27D()`. Isolation wrap stays. `lua tests/test_console_dock.lua` exit 0 | **Pass.** **563 / 0.** Wrap still **24** under `if standalone then`. `runB36C()` sits inside `runB27D()` after `runB30D()`. |

The leftover (niled OnHide stayed nil across `Hide`; later ESC / `frame:Hide()` left `shown` true and dismiss unset; next Refresh painted the dock again) is closed on the existing-frame `ConsoleDock:Hide` path while the widget is still shown: remount then `paint(false)` fires the restored handler and sets live dismiss. Create-path still wires after create-time Hide. Law 6 (no panel whoosh), Law 10 / license 4 (stock dock, hidden CloseButton), wiki ESC via `UISpecialFrames`, B24-B `eventId` dismiss, B30-D Hide `rememberSpecial` remount, B27-D Show / Refresh remount, and B26-D Init remount hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Widget Hide / ESC does not remount a niled OnHide. `CloseSpecialWindows` / `frame:Hide()` still bypass `ConsoleDock:Hide`. A dropped OnHide that never hits `ConsoleDock:Hide` still leaves `shown` true and dismiss unset; next Refresh paints the dock again | **Allowed leftover.** Brief scoped remount on `ConsoleDock:Hide`. The missing handler cannot remount itself. Reviewer probe: Show, nil OnHide, `frame:Hide()` leaves `GetView().shown` true and OnHide nil; Refresh paints again. |
| Show / Refresh / Init remount do not remount OnHide. A niled handler that only hits those paths stays idle | **Allowed leftover.** Brief asked Hide-only remount and no OnShow re-wire. Reviewer probe: niled script stays nil across Show, Refresh, and Init. |
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven; a live remount that dropped the name is simulated by `UISpecialFrames = {}`; a dropped handler is simulated by `SetScript("OnHide", nil)` | **Not a miss.** Brief asked isolated green + wipe-to-`{}` then live Show + Hide restores OnHide and lists once. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key; script identity, dismiss, and membership counts are pinned; the client's special-frame walk is not | **Not a miss.** Brief asked those pins on `ConsoleDock:Hide`. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / dismiss

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB / glue. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap is load-time only (unchanged). `runB36C()` re-pins **5** (Hud, Toasts, DecreeBanner, RecordsBook, slash). New remount locals sit in `runB36C()` inside `runB27D()` after `runB30D()`.

**Existing-frame remount — Pass.** `Hide` calls `wireDockOnHide(frame)` when `frame` exists, then `rememberSpecial(FRAME_NAME)`, then `paint(false)`. The helper no-ops when a script exists and writes `lastView.shown = false` plus live `dismissedEventId` only when OnHide is nil. It does not `build()`, does not `CreateFrame`, does not `PlaySound`, and does not `Show`. Create-path `build()` still calls `widget:Hide()` then `wireDockOnHide(widget)`. B26-D Init remount and B27-D Refresh / Show remount still call `rememberSpecial(FRAME_NAME)` and do not remount OnHide. Reviewer spy: restore `SetScript` delta 1 named OnHide on niled Hide; existing / sentinel / third Hide delta 0. `CreateFrame` delta 0 on remounts. Hide with no frame does not `Init`.

**Dismiss / uniqueness — Pass.** Wipe-to-empty, nil OnHide, Show live, Hide lists `ChurchOfBeefConsoleDock` once, restores OnHide, and keeps the same pointer. Third Hide stays once and keeps identity. Same-event Hide + Refresh stays hidden. Reviewer probe: remount Hide is not `EndEvent`; next StartEvent + Refresh shows; `Show()` after dismiss shows. First-create ESC membership pin, B26-D wipe+Init pin, B27-D wipe+Refresh / wipe+Show pins, B30-D wipe+Hide pin, and persist uniqueness-once pin stay above / below the nest.

---

## Strengths

- The delta is the brief: extract `wireDockOnHide` (never replace), call it from create-path after create-time Hide, and call it on existing-frame `Hide` before `rememberSpecial(FRAME_NAME)` then `paint(false)`. Show / Refresh / Init remount, B30-D Hide `rememberSpecial`, B24-B `eventId` dismiss, title, persist, SANCTION + Expand, and hidden CloseButton were left alone. No new main-chunk test local.
- B30 leftover (niled OnHide stayed nil across `Hide`; later ESC then skipped dismiss) is closed on the shown `ConsoleDock:Hide` path with a runtime restore, not only a source `find`. Same-event Refresh after remount Hide stays hidden, so a no-op restore would fail.
- Third-Hide identity, `CreateFrame` 0, Show-does-not-remount, and wipe+Hide uniqueness sit next to the restore pins, so a rebuild, a replace-every-Hide helper, or a Show remount would fail.
- Create-path order pin was rematched onto `build()` (`widget:Hide()` then `wireDockOnHide`) so the file-scope `SetScript("OnHide"` find (now the helper, above create-time Hide) cannot invert the order pin.
- Isolation stayed gated. Remount locals are inside `runB36C()` inside `runB27D()` after `runB30D()`. Writer-reported **563 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Widget Hide / ESC does not remount a niled OnHide.** Reviewer probe: Show, nil OnHide, `frame:Hide()` leaves `GetView().shown` true and OnHide nil; Refresh paints again. `ConsoleDock:Hide()` now remounts then `paint(false)`, so that path syncs while the widget is still shown. Brief scoped remount on `ConsoleDock:Hide`, not a shown-repair of a raw widget Hide. A dropped handler that never hits `ConsoleDock:Hide` stays idle.

2. **`ConsoleDock:Hide` after an already-hidden niled widget Hide remounts the script and paints `shown` false, but OnHide does not fire, so dismiss stays unset.** Reviewer probe: Show, nil OnHide, `frame:Hide()`, then `ConsoleDock:Hide` restores the handler and `GetView().shown` is false; same-event Refresh still **shows**. Stub `Hide` no-ops when already hidden. Brief asked Show a live dock then `Hide` (widget still shown; `paint(false)` fires the restored handler). Not a miss.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames` and calls `Frame:Hide`, not `ConsoleDock:Hide`. One real ESC may still hide the dock together with other named Beef frames. Brief asked Hide remount + restore + uniqueness once, not a client walk.

### Nit

1. **Third-Hide identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

2. **`src:find("rememberSpecial(FRAME_NAME)")` as “build still rememberSpecial” matches any of the five sites.** Live `build()` still has the call before `return widget` (first find is that site). The remount captures are the pins that actually prove the Hide site.

3. **File-top create-path pin reuses `hideAt` / `onHideAt`.** First finds are file-scope `widget:Hide()` and `SetScript("OnHide"` (helper, now *before* create-time Hide); then both are rematched inside `build()`. The rematch compare is the real order pin. No new main-chunk local.

4. **`UISpecialFrames = nil` is unpinned inside `runB36C()`.** Older pin above the nest still proves `Init` survives a missing table. Probe: Hide with nil leaves it nil; assigning `{}` then Hide lists the name once. Brief asked wipe to `{}`.

5. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.** Reviewer probe: `_G.ChurchOfBeefConsoleDock == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap other named-special-frame lanes named.

6. **Exclusive-pair diff is not a vs-HEAD ConsoleDock delta.** Packet is the B36-C-only helper + Hide remount + pins. Both exclusive files are still untracked vs HEAD and also carry earlier dock batches. Report already says this.

7. **Isolation wrap is load-only.** Twenty-four pins under the load-time `if standalone then`. `runB36C()` re-pins five. Brief said the wrap stays; it did.

8. **No full `lua tests/run.lua`.** Isolated **563 / 0** was re-run here.

9. **Show / Refresh / Init still skip a niled OnHide.** Brief asked Hide-only remount. Named as leftover, not a miss.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **563 passed, 0 failed.** Isolation wrap: **24**. `runB36C()` re-pins: **5**. Main-chunk locals: **56 / 200**. ConsoleDock file locals: **35**.

`ConsoleDock:Hide` on an existing frame calls `wireDockOnHide(frame)` then `rememberSpecial(FRAME_NAME)` then `paint(false)`. The helper does not replace an existing script and does not wire OnShow. Wipe `UISpecialFrames` to `{}`, nil OnHide, Show a live dock, Hide restores OnHide, sets `GetView().shown` false, sets live dismiss, lists `ChurchOfBeefConsoleDock` exactly once, and keeps the same pointer. Third Hide keeps OnHide identity. No rebuild. No `PlaySound`. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. B30-D Hide `rememberSpecial` remount stays. B27-D Show / Refresh remount stays. B26-D Init remount stays. Persist / title / SANCTION + Expand / hidden CloseButton stay. No new main-chunk local. Isolated `lua tests/test_console_dock.lua` **563 passed, 0 failed**, exit 0.

### Leftovers

- Widget Hide / ESC does not remount a niled OnHide. A dropped handler that never hits `ConsoleDock:Hide` leaves `shown` true and dismiss unset; next Refresh paints again.
- `ConsoleDock:Hide` after an already-hidden niled widget Hide remounts the script but does not fire OnHide, so dismiss stays unset and Refresh can still show.
- Show / Refresh / Init remount do not remount OnHide.
- No `/reload` smoke; real ESC vs `CloseSpecialWindows` is unproven. ESC walks names and calls `Frame:Hide`, not `ConsoleDock:Hide`.
- Full `lua tests/run.lua` not run.
- Harness membership counts are pinned; the client's special-frame walk is not. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.
- Exclusive-pair diff is the B36-C-only delta, not vs HEAD.

Do not claim V1 / MVP complete. This review does not sign the lane.
