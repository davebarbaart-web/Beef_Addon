Spec PASS

# B36-D — Decree Hide remounts UISpecialFrames membership (review)

**Quality:** Approved-with-nits

**Lane:** B36-D Decree Hide remounts UISpecialFrames membership
**Brief:** `docs/reformation/vestments/briefs/B36-D-decree-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B36-D-decree-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B36-D-decree-special.diff` (B36-D-only exclusive-pair packet; live `Decree.lua` also carries earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`DecreeBanner:Hide` ~336 / `rememberSpecial` / `wireDecreeOnHide` / `ensureFrame` early-return / `buildFrame` / `wipePaint` / empty `Show` / `Refresh` / `FRAME_NAME` / `LINE_FONT`), and `tests/test_decree_ui.lua` (isolation wrap, B31-B Hide OnHide remount / B30-A ensureFrame remount / B29-B OnHide wipe / B28-B Refresh wipe / B27-B Hide wipe / B26-C empty Show / B25-B Show-only uniqueness, nested `runB36D()` inside `runB25B()` after `runB31B()`); then ran `lua tests/test_decree_ui.lua` (**615 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); existing-frame `Hide`: `rememberSpecial(FRAME_NAME)` then existing OnHide remount + wipe-if-empty + `frame:Hide()`; never replace an existing OnHide; no OnShow re-wire; no rebuild; no `PlaySound`; no Clear Decree chrome; `FRAME_NAME` is `ChurchOfBeefDecree`; Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B31 leftover (`DecreeBanner:Hide` remounted OnHide but skipped `rememberSpecial`; a wiped list + Hide-only left ESC idle until Show / Refresh / Init). Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit glue, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Existing-frame `Hide` still skips `rememberSpecial` (B31 leftover) | **Pass. Verified.** Live exists-path is `rememberSpecial(FRAME_NAME)` then `wireDecreeOnHide(self.frame)` then wipe when Get is nil, then `self.frame:Hide()`. Pins: wipe `UISpecialFrames` to `{}`, Hide lists `ChurchOfBeefDecree` once. Reviewer probe: wipe leaves count 0; Hide returns true, same frame pointer, count is 1; second and third Hide still 1. Source capture: rem < wire < wipe < `:Hide()`. |
| `Hide` replaces an existing OnHide | **Pass. Verified.** Helper is still `if existing then return`. Pins: Hide after wipe keeps `existingOnHide`; second and third Hide keep identity. Reviewer spy: wrapped `SetScript` saw **0** calls on Hide with the create-path script and with a sentinel OnHide. Sentinel identity stayed. Niled Hide then saw **1** call named `OnHide`. |
| Restore / remount rebuilds, Shows, or `ensureFrame`s | **Pass. Verified.** `Hide` does not call `ensureFrame`, `buildFrame`, or `CreateFrame`. Pins: wipe Hide / second Hide / third Hide / remount-stay same frame pointer; Hide body has no `ensureFrame` / `CreateFrame` / `:Show()` / `OnShow`. Reviewer probe: `CreateFrame` delta **0** across remounts and third Hide. Hide with no frame (after `ResetForTests`) CreateFrame delta **0**; frame stays nil. |
| Hide re-wires OnShow, Plays sound, or adds Clear Decree chrome | **Pass.** Hide body has no `OnShow`, no `PlaySound`, no `IG_CHARACTER_INFO`, no `Clear Decree`. Whole-file source has no `PlaySound` / `Clear Decree` / `Media\\` / `Deputy`. Pins: `GetScript("OnShow")` stays nil; `#sounds` unchanged. Reviewer spy: remount / third Hide / niled remount / Close stay PlaySound **0**. `Banner.Deputy` / `Banner.ClearDecree` stay nil. |
| B31-B OnHide remount / ensureFrame remount / Hide wipe dropped | **Pass. Verified.** Nested stay pins in `runB36D()` still remount a niled OnHide and still list the name once. `runB31B()` still runs immediately above. Early-return / `buildFrame` still `rememberSpecial` then `wireDecreeOnHide`. Reviewer probe: empty Show / Refresh still remount both the name and a niled OnHide; Clear + `DecreeBanner:Hide` still blanks leftover Goldshire. |
| Isolated suite not exit 0 / pins not after `runB31B()` in `runB25B()` / isolation wrap rewritten | **Pass. Verified.** 615 passed, 0 failed. Writer-reported count matches. `runB36D()` is a nested `local function` inside `runB25B()` after `runB31B()`. Isolation wrap stays under the load-time standalone block (18 nils). `luac -l -p`: main chunk **37** locals (cap 200; same as B31-B). Packet adds no main-chunk `local`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (Hide exists-path `rememberSpecial(FRAME_NAME)` before OnHide remount + wipe + Hide; header comment + nested `runB36D()`). OPEN_QUESTIONS / REFORMATION_LOG have no B36-D marks. Sibling dirt in this workspace is other lanes. Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Console; no commit; no deputy; no custom media; no sound; no Clear Decree chrome | **Pass.** Named-risk check. Source has no `Deputy` picker / `Media\\` / `Clear Decree`. `Banner.Deputy` / `Banner.ClearDecree` stay nil. Reviewer did not commit. |
| Existing-frame `Hide`: `rememberSpecial(FRAME_NAME)` then existing OnHide remount + wipe-if-empty + `frame:Hide()` | **Pass.** Live exists-path. Source pin: `rememberSpecial(FRAME_NAME)` index before `wireDecreeOnHide`, `wipePaint`, and `:Hide()`. No inline `SetScript("OnHide"`. Reviewer capture is rem < wire < wipe < `self.frame:Hide()`. |
| Never replace an existing OnHide | **Pass.** Named-risk check. Helper still `if existing then return`. Third Hide identity stays. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| `FRAME_NAME` is `ChurchOfBeefDecree`. Wipe `UISpecialFrames`, Hide: re-listed once. Third Hide does not duplicate | **Pass.** Nested pins in that order. Reviewer probe matches. Close `OnClick` is still `DecreeBanner:Hide()` and remounts the name once. |
| ensureFrame remount stays. Isolation wrap stays. Nest after `runB31B()` inside `runB25B()` | **Pass.** Early-return still `rememberSpecial` then `wireDecreeOnHide`. Refresh body still has no `wireDecreeOnHide`. |
| Quiet silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Named-risk check. |
| `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **615 / 0.** |

B31 leftover (`DecreeBanner:Hide` remounted OnHide but skipped `rememberSpecial`; a wiped list + Hide-only left ESC idle until Show / Refresh / Init) is closed on the Hide exists-path. Law 6 (Quiet silent), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), wiki ESC via `UISpecialFrames`, no deputy, no Clear Decree chrome, and no `PlaySound` hold on the exclusive pair. B31-B OnHide remount stays.

### Law check

| Law | Verdict |
|---|---|
| Law 6 / §19.4 — Quiet is silent | **Pass.** Hide remount has no `PlaySound` / `IG_CHARACTER_INFO_*` / `SOUNDKIT`. Suite `#sounds` is unchanged. Reviewer remount cycle stays 0. `MODE` is still `"QUIET"`. |
| Law 10 / Bible §19.3 / §14.1 — theatrical parchment; header / QuestBG stay | **Pass.** `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. No Clear Decree chrome. No deputy. |
| Wiki ESC — named frame on `UISpecialFrames` | **Pass.** `FRAME_NAME` stays `"ChurchOfBeefDecree"`. Hide remounts `rememberSpecial(FRAME_NAME)`. Wipe-to-empty then Hide lists the name once. Third Hide still once. |

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Widget Hide / ESC does not remount `rememberSpecial`. `CloseSpecialWindows` / `frame:Hide()` bypass `DecreeBanner:Hide`. A wiped list that never hits Hide / Show / Refresh / Init stays idle | **Allowed leftover.** Brief scoped remount on `DecreeBanner:Hide`. Reviewer probe: Show, wipe the list, `frame:Hide()` leaves count 0. Close still remounts because Close `OnClick` calls `DecreeBanner:Hide()`. |
| `ResetForTests` still calls `self.frame:Hide()` directly and does not remount | **Allowed leftover.** Harness-only. Brief scoped production Hide. |
| `UISpecialFrames = nil` still no-ops `rememberSpecial` | **On contract.** Brief asked wipe-to-empty uniqueness, not a missing table. Reviewer probe: nil-list Hide still keeps OnHide identity and leaves the table nil. |
| Isolated suite does not load bootstrap glue. A parchment left *visible* after Clear with no follow-up Hide, empty Show, Refresh, or widget Hide can still display Goldshire in this suite | **Isolation leftover. Not a miss.** Do **not** read this as “glue does not Refresh on Clear.” That reading is **STALE**. Batch 28 already added glue `wrapAlways(COB.Decree, "Clear")` → `DecreeBanner:Refresh`. Isolated Clear still leaves a visible leftover because this suite does not load glue. |
| No client smoke. Real ESC vs `CloseSpecialWindows` on `ChurchOfBeefDecree` is unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **On contract.** Membership counts are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / stay paths

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Writer's "first `if standalone then`" is the helper block; the wrap is the later load-time standalone. Count is still 18. Runtime locals sit in `runB36D()` inside `runB25B()` after `runB31B()` so Lua 5.1's 200-local cap does not fire.

**Remount — Pass.** Exists-path `rememberSpecial(FRAME_NAME)` then `wireDecreeOnHide(self.frame)` then wipe when Get is nil, then Hide. Helper wires only when `GetScript("OnHide")` is nil. A third Hide with the script already set keeps identity. Reviewer spy: existing / sentinel / third Hide `SetScript` delta 0; niled Hide delta 1 named OnHide. `CreateFrame` delta 0 on remounts. Hide with no frame does not `ensureFrame`. ensureFrame Show / Refresh / Init remount stay.

**Uniqueness — Pass.** `rememberSpecial` still returns when the name is already listed. Wipe-to-empty then Hide lists `ChurchOfBeefDecree` once. Third Hide stays once. Reviewer probe: wipe+Hide also lists once; third Hide still once; `UISpecialFrames = nil` then Hide leaves the table nil. Close `OnClick` remounts once.

**Stay paths — Pass.** B31-B Hide OnHide remount, B30-A ensureFrame remount, B29-B widget Hide after Clear, B28-B Refresh wipe, B27-B Hide wipe, and B26-C empty Show are unchanged. Nested stay pins in `runB36D()` still remount a missing OnHide and still list the name once.

---

## Strengths

- The delta is the brief: one `rememberSpecial(FRAME_NAME)` call on the Hide exists-path, before the existing OnHide remount + wipe + Hide. An existing script is not replaced. The widget is not rebuilt. ensureFrame remount stays. `FRAME_NAME` stays `"ChurchOfBeefDecree"`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B31 leftover (wiped list + Hide-only left ESC idle until Show / Refresh / Init) is closed with a runtime remount, not only a source `find`. Wipe-to-empty then Hide lists the name once, so a no-op remount would fail.
- Third-Hide identity, `CreateFrame` 0, no OnShow, and B31-B OnHide remount sit next to the special-frame pins, so a rebuild or a replace-every-Hide helper would fail.
- Isolation stayed gated. New locals are inside `runB36D()` inside `runB25B()` after `runB31B()`. Writer-reported **615 / 0** matched the re-run. Writer-reported red (**607 / 8**) matches the exists-path-missing-`rememberSpecial` + wiped-list-stayed-0 cluster that pre-B36-D Hide would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Widget Hide / ESC does not remount `rememberSpecial`.** Reviewer probe: Show, wipe the list, `frame:Hide()` leaves count 0. `DecreeBanner:Hide()` now remounts then wipe/Hide, so that path syncs. Brief scoped remount on `DecreeBanner:Hide`, not a shown-repair of a raw widget Hide. A dropped name that never hits Hide / Show / Refresh / Init stays idle. Close still remounts because it calls `DecreeBanner:Hide()`.

2. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the parchment with other listed chrome. Brief asked isolated remount + uniqueness once, not a client walk.

### Nit

1. **Writer's "first `if standalone then`" is the helper block.** Isolation wrap is the later load-time standalone. Eighteen pins stay there. Same report wording leftover as earlier Decree lanes. Not a Spec FAIL.

2. **"Glue does not Refresh on Clear" is STALE** if that is how leftover #4 is read. Writer leftover correctly says the isolated suite does not load glue. Batch 28 `wrapAlways(COB.Decree, "Clear")` already Refresh-hides. Nit on the report, not a Spec FAIL.

3. **Several “does not X” pins are string finds on `hideBody`.** They would not catch `rememberSpecial` inside a helper alias. Reviewer probe on wipe+Hide count 1 / `CreateFrame` 0 / `SetScript` 0 closes that hole.

4. **Isolation wrap is load-only.** Eighteen pins under the load-time `if standalone then`. Nested B36-D does not re-pin them. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B36-D-only exists-path call + nested pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

6. **`UISpecialFrames = nil` and stub `_G["ChurchOfBeefDecree"]` stay unpinned.** `rememberSpecial` no-ops when the global is not a table. Brief asked wipe uniqueness. Reviewer probe: nil-list Hide leaves the table nil. Harness `Hide()` is still not ESC.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **615 / 0** was re-run here. Live remount of a dropped name after ESC is unproven on Anniversary.

8. **`runB36D()` adds no new main-chunk local.** Brief asked isolation wrap stays, not zero new chunk locals. Pin locals sit inside the nest. `luac` main chunk is **37 / 200**.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **615 passed, 0 failed.** Isolation wrap: **18**. Main-chunk locals: **37 / 200**.

`DecreeBanner:Hide` on an existing frame calls `rememberSpecial(FRAME_NAME)` then `wireDecreeOnHide(self.frame)` then wipe-if-empty then `frame:Hide()`. An existing OnHide is not replaced. The frame is not rebuilt. `FRAME_NAME` stays `"ChurchOfBeefDecree"`. No `PlaySound`. No Clear Decree chrome. Pins live in `runB36D()` inside `runB25B()` after `runB31B()`. Isolated `lua tests/test_decree_ui.lua` **615 passed, 0 failed**, exit 0.

**Leftovers:** widget Hide / ESC does not remount `rememberSpecial` (handler / `CloseSpecialWindows` cannot remount the list); `ResetForTests` still widget-Hides; `UISpecialFrames = nil` still no-ops; isolated suite leftover after Clear is isolation (Batch 28 `wrapAlways` already Refresh-hides — “glue does not Refresh on Clear” is STALE); no Anniversary ESC / `CloseSpecialWindows` smoke; isolated suite only (full `tests/run.lua` not run); harness `Hide()` is not a real ESC key.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W / Gate V / POLISH:PASS.
