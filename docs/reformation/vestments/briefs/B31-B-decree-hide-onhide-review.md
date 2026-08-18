Spec PASS

# B31-B — Decree Hide remounts a missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B31-B Decree Hide remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B31-B-decree-hide-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B31-B-decree-hide-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B31-B-decree-hide-onhide.diff` (B31-B-only exclusive-pair packet; live `Decree.lua` also carries earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`DecreeBanner:Hide` ~336 / `wireDecreeOnHide` / `ensureFrame` early-return / `buildFrame` / `ensureFrame` create / `wipePaint` / empty `Show` / `Refresh` / `LINE_FONT`), and `tests/test_decree_ui.lua` (isolation wrap, B29-B OnHide wipe / B28-B Refresh wipe / B27-B Hide wipe / B26-C empty Show / B30-A ensureFrame remount, nested `runB31B()` inside `runB25B()` after `runB30A()`); then ran `lua tests/test_decree_ui.lua` (**565 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Hide remounts a missing OnHide; do **not** replace an existing script; do not Show from OnHide; `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`; no deputy; no Clear Decree chrome; no sound; Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); Wiki ESC / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); B30 leftover (`DecreeBanner:Hide` skipped a niled OnHide; ESC last-wipe would drop until ensureFrame). Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Writer leftover “Isolated suite does not load bootstrap glue” is isolation, not a missing wrap; Batch 28 already added glue `wrapAlways` on `Decree:Clear` → `DecreeBanner:Refresh`. Reading that leftover as “glue does not Refresh on Clear” is **STALE** (nit on the report, not a Spec FAIL). Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Hide` still skips a missing OnHide when the frame exists (B30 leftover) | **Pass. Verified.** Live `Hide` is `if self.frame then wireDecreeOnHide(self.frame)` then wipe when Get is nil, then `self.frame:Hide()`. Helper wires only when `GetScript("OnHide")` is nil. Pins: `SetScript("OnHide", nil)`, Hide restores; same frame pointer. Reviewer probe: niled script, Hide, `GetScript` is a function; wrapped `SetScript` saw **1** call named `OnHide`. Hide body has `wireDecreeOnHide` before `wipePaint` / `:Hide()`. |
| `Hide` replaces an existing script | **Pass. Verified.** Helper is still `if existing then return`. Pins: second Hide and third Hide after restore keep `afterHide`. Reviewer spy: wrapped `SetScript` saw **0** OnHide calls on Hide with the restored script and with a sentinel OnHide. Sentinel identity stayed. |
| Restore rebuilds, Shows, or `ensureFrame`s | **Pass. Verified.** `Hide` does not call `ensureFrame`, `buildFrame`, or `CreateFrame`. Pins: niled Hide / second Hide / third Hide same frame pointer; Hide body has no `ensureFrame` / `CreateFrame` / `:Show()`. Reviewer probe: `CreateFrame` delta **0** across remounts and third Hide. Hide with no frame (never built) CreateFrame delta **0**; frame stays nil. |
| Restored handler Shows the banner, invents a line, Plays sound, or adds Clear Decree chrome | **Pass.** Handler is unchanged: `if not getDecree() then wipePaint(frame) end`. No `:Show()`, no `paint(`, no `PlaySound`, no `Goldshire`, no `Clear Decree`. Whole-file source has no `PlaySound` / `Clear Decree` / `Media\\` / `Deputy`. Reviewer spy: remounted Clear + widget Hide leaves banner `Show` at **0**, Hide **1**, header `SetText` **0**, PlaySound **0**. Direct fire of remounted OnHide after Clear: Show **0**, LineText `""`. |
| Widget Hide after remount / Hide wipe / Refresh wipe / empty Show / ensureFrame remount dropped | **Pass. Verified.** Nested stay pins in `runB31B()` still remount on empty Show / Refresh / Init and still blank leftover Goldshire on widget Hide after Clear, `DecreeBanner:Hide`, Refresh, and empty Show. Reviewer probe: remounted widget Hide blanks both strings and hides flavor; Show / Refresh / Init still remount a niled script on the same frame. |
| `PlaySound` / Quiet no longer silent / `LINE_FONT` flipped / header or QuestBG changed / deputy / Clear Decree chrome | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, or `SOUNDKIT`. `MODE` is still `"QUIET"`. `LINE_FONT` is still `Fonts\\MORPHEUS.ttf`. Header is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. `Banner.Deputy` / `Banner.ClearDecree` stay nil. Suite `#sounds` is 0 at the end. Reviewer remount cycle leaves PlaySound at 0. |
| Isolated suite not exit 0 / pins not nested / isolation wrap rewritten | **Pass. Verified.** 565 passed, 0 failed. Writer-reported count matches. `runB31B()` is a nested `local function` inside `runB25B()` after `runB30A()`. Isolation wrap stays under the first `if standalone then`. `luac -l -p`: main chunk **37** locals (cap 200; same as B30-A). Packet adds no main-chunk `local`. Retired B29-B / B30-A “Hide does not call `wireDecreeOnHide`” source pins. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (Hide exists-path `wireDecreeOnHide` before wipe/Hide; header comment + nested `runB31B()`). Sibling dirt in this workspace is other lanes (Toasts, Records, TOC, bootstrap, `ChurchOfBeef.lua`). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Records, glue; no commit; no deputy; no custom media; no sound; no Clear Decree chrome | **Pass.** Named-risk check. Source has no `Deputy` picker / `Media\\` / `Clear Decree`. `Banner.Deputy` / `Banner.ClearDecree` stay nil. Reviewer did not commit. |
| When the frame exists, `Hide` calls `wireDecreeOnHide(self.frame)` before wipe/Hide | **Pass.** Live exists-path. Source pin: `wireDecreeOnHide` index before `wipePaint` and before `:Hide()`. No inline `SetScript("OnHide"`. |
| Do **not** replace an existing script | **Pass.** Named-risk check. Helper still `if existing then return`. Third Hide identity stays. |
| ensureFrame remount stays | **Pass.** Early-return / create-path / `buildFrame` still call the helper. Nested Show / Refresh / Init remount stay pins. |
| Do not Show from OnHide | **Pass.** Named-risk check. Handler has no `:Show()`. Reviewer spy: remount Hide / remounted Clear + widget Hide / direct OnHide fire stay **0**. |
| Existing widget-Hide-after-Clear wipe / Refresh / empty Show stay | **Pass.** Named-risk check. |
| Quiet silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Named-risk check. |
| Nil the OnHide, Hide: script restored. Third Hide with the script already set: identity stays | **Pass.** Nested pins in that order. Reviewer probe matches. |
| Isolation wrap stays; `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **565 / 0.** |

B30 leftover (niled OnHide stayed nil across `DecreeBanner:Hide`; later ESC then skipped wipe until ensureFrame) is closed on the Hide exists-path. ensureFrame remount from B30-A stays. Law 6 (Quiet silent), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), no deputy, no Clear Decree chrome, and no `PlaySound` hold on the exclusive pair. Hide / Refresh / empty Show wipe stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Isolated suite does not load bootstrap glue. A parchment left *visible* after Clear with no follow-up Hide / empty Show / Refresh / widget Hide can still display Goldshire in this suite. Installed `wrapAlways` Clear→Refresh is outside this exclusive lane | **Isolation leftover. Not a miss.** Do **not** read this as “glue does not Refresh on Clear.” That reading is **STALE**. Batch 28 already added glue `wrapAlways(COB.Decree, "Clear")` → `DecreeBanner:Refresh` (`ChurchOfBeef.lua`). Nit on the report, not a Spec FAIL. Isolated Clear still leaves a visible leftover because this suite does not load glue. Production Clear already Refresh-hides. |
| Widget Hide / ESC does not remount a niled OnHide. A dropped OnHide that never hits `DecreeBanner:Hide`, Show, Refresh, or Init stays idle | **Allowed leftover.** Brief scoped remount on `DecreeBanner:Hide`. The missing handler cannot remount itself. Reviewer probe: Show, Clear, nil OnHide, `frame:Hide()` leaves Goldshire and OnHide nil. |
| Hide still does not call `ensureFrame` / `rememberSpecial`. A wiped `UISpecialFrames` + Hide-only leaves ESC membership idle until Show / Refresh / Init | **Allowed leftover.** Brief said remount OnHide, not remount special-frame membership. Hide body has no `ensureFrame` / `rememberSpecial`. |
| No client smoke. Live leftover paint after Pope Clear + ESC, and a live remount of a dropped OnHide, are unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `frame:Hide()` is a direct call, not a real ESC key | **On contract.** Script fire and leftover wipe are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / stay paths

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap is load-time only (unchanged). Runtime locals sit in `runB31B()` inside `runB25B()` after `runB30A()` so Lua 5.1's 200-local cap does not fire.

**Remount — Pass.** Exists-path `wireDecreeOnHide(self.frame)` then wipe when Get is nil, then Hide. Helper wires only when `GetScript("OnHide")` is nil. A third Hide with the script already set keeps identity. Reviewer spy: restore `SetScript` delta 1 named OnHide on niled Hide; existing / sentinel / third Hide delta 0. `CreateFrame` delta 0 on remounts. Hide with no frame does not `ensureFrame`. ensureFrame Show / Refresh / Init remount stay.

**OnHide wipe after remount — Pass.** Remounted handler still `wipePaint`s when `getDecree()` is nil and does not `paint`, does not `Show`, and does not `PlaySound`. Reviewer spy: leftover Goldshire is `""` after Clear + widget Hide; banner `Show` stays 0; Hide runs once; header `SetText` stays 0.

**Stay paths — Pass.** B30-A ensureFrame remount, B29-B widget Hide after Clear, B28-B Refresh wipe, B27-B Hide wipe, and B26-C empty Show are unchanged. Nested stay pins in `runB31B()` still remount on Show / Refresh / Init and still blank leftover Goldshire.

---

## Strengths

- The delta is the brief: one `wireDecreeOnHide(self.frame)` call on the Hide exists-path, before wipe/Hide. An existing script is not replaced. The widget is not rebuilt. ensureFrame remount stays. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B30 leftover (niled OnHide stayed nil across Hide; later ESC then skipped wipe until ensureFrame) is closed with a runtime restore, not only a source `find`. The restored handler is then proven to blank leftover Goldshire on widget Hide, so a no-op restore would fail.
- Third-Hide identity, `CreateFrame` 0, and Hide / Refresh / empty Show wipe sit next to the restore pins, so a rebuild or a replace-every-Hide helper would fail.
- B29-B / B30-A “Hide does not call `wireDecreeOnHide`” pins were retired. Isolation stayed gated. New locals are inside `runB31B()` inside `runB25B()` after `runB30A()`.
- Writer-reported **565 / 0** matched the re-run. Writer-reported red (**561 / 4**) matches the exists-path-missing-helper + niled-stayed-nil cluster that pre-B31-B Hide would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Widget Hide / ESC does not remount a niled OnHide.** Reviewer probe: Show, Clear, nil OnHide, `frame:Hide()` leaves Goldshire and OnHide nil. `DecreeBanner:Hide()` now remounts then wipe/Hide, so that path syncs. Brief scoped remount on `DecreeBanner:Hide`, not a shown-repair of a raw widget Hide. A dropped handler that never hits Hide / Show / Refresh / Init stays idle.

2. **Hide still does not call `ensureFrame` / `rememberSpecial`.** A wiped `UISpecialFrames` + Hide-only leaves ESC membership idle until Show / Refresh / Init. Brief asked OnHide remount, not special-frame remembership.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the parchment with other listed chrome. Brief asked isolated restore + identity, not a client walk.

### Nit

1. **“Glue does not Refresh on Clear” is STALE.** Writer leftover #1 correctly says the isolated suite does not load glue and that installed `wrapAlways` is outside this exclusive lane. Reading that as a missing Clear→Refresh wrap is stale. Batch 28 `wrapAlways(COB.Decree, "Clear")` already Refresh-hides. Nit on the report, not a Spec FAIL.

2. **Third-Hide identity is vacuous if restore failed.** These asserts do not stop. `nil == nil` would pass on a niled leftover. The restore pin is the one that fails first; the identity pin is a keep after that.

3. **Several “does not X” pins are string finds on `hideBody`.** They would not catch `frame.Show(frame)` inside `wireDecreeOnHide`. Reviewer spy on the widget `Show` method closes that hole (niled Hide / remounted Clear + widget Hide / direct OnHide fire stay **0**).

4. **Isolation wrap is load-only.** Eighteen pins under the first `if standalone then`. Nested B31-B does not re-pin them. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B31-B-only exists-path call + nested pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **565 / 0** was re-run here. Live remount of a dropped OnHide after Pope Clear + ESC is unproven on Anniversary. Harness `frame:Hide()` is still not a real ESC key.

7. **`runB31B()` adds no new main-chunk local.** Brief asked isolation wrap stays, not zero new chunk locals. Pin locals sit inside the nest. `luac` main chunk is **37 / 200**.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **565 passed, 0 failed.** Isolation wrap: **18**.

`Hide` wires a missing OnHide through the same `wireDecreeOnHide` helper as `buildFrame` / `ensureFrame`, then wipe/Hide. An existing script is not replaced. The frame is not rebuilt. ensureFrame remount stays. OnHide does not Show. Quiet stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. No deputy. No Clear Decree chrome. No `PlaySound`. Pins live in `runB31B()` inside `runB25B()` after `runB30A()`. Isolated `lua tests/test_decree_ui.lua` **565 passed, 0 failed**, exit 0.

**Leftovers:** widget Hide / ESC does not remount a niled OnHide (handler cannot remount itself); Hide still does not call `ensureFrame` / `rememberSpecial`; isolated suite leftover after Clear is isolation (Batch 28 `wrapAlways` already Refresh-hides — “glue does not Refresh on Clear” is STALE); no Anniversary ESC / `CloseSpecialWindows` smoke; isolated suite only (full `tests/run.lua` not run); harness `frame:Hide()` is not a real ESC key.

Do not claim V1 / MVP complete. This review does not sign the lane.
