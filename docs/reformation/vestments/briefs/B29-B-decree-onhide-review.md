Spec PASS

# B29-B — Decree OnHide blanks leftover paint when the line is gone (review)

**Quality:** Approved-with-nits

**Lane:** B29-B Decree OnHide blanks leftover paint when the line is gone
**Brief:** `docs/reformation/vestments/briefs/B29-B-decree-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B29-B-decree-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B29-B-decree-onhide.diff` (B29-B-only exclusive-pair packet; live `Decree.lua` also carries earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`wireDecreeOnHide` ~157 / `buildFrame` / `ensureFrame` create / `getDecree` / `wipePaint` / empty `Show` / `Hide` / `Refresh`), and `tests/test_decree_ui.lua` (OnHide source pins, nested `runB29B()` inside `runB25B()` after `runB28B()`, B28-B Refresh wipe / B27-B Hide wipe / B26-C empty Show, isolation wrap); then ran `lua tests/test_decree_ui.lua` (**427 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: widget `frame:Hide()` after Core Clear (ESC via `UISpecialFrames`) must blank leftover Goldshire; OnHide: if `getDecree()` is nil, `wipePaint`; do **not** replace an existing OnHide; do not Show from OnHide; `Refresh` / empty `Show` / `Hide()` wipe stay; Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B28 leftover (widget Hide bypasses `DecreeBanner:Hide` and leaves Goldshire after Core Clear); `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`; Anniversary `FontString:SetText` accepts `""`; no deputy; no Clear Decree chrome; no custom media; no sound. Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Batch 28 already added glue `wrapAlways` on `Decree:Clear` → `DecreeBanner:Refresh`; the writer leftover “Glue does not call Refresh yet” is stale (nit on the report, not a Spec FAIL). `ensureFrame` early-return not remounting OnHide is an allowed leftover (brief said create-path). Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Widget `frame:Hide()` after `Decree:Clear()` still leaves Goldshire / flavor (B28 leftover: ESC via `UISpecialFrames` bypasses `DecreeBanner:Hide`) | **Pass. Verified.** Live OnHide is `if not getDecree() then wipePaint(frame) end`. Create-path (`buildFrame` / `ensureFrame` create) calls `wireDecreeOnHide`. Pins: Set Goldshire + flavor, Show, `Decree:Clear()`, widget `frame:Hide()` (not `DecreeBanner:Hide` / Refresh) is hidden, both FontStrings `""`, flavor hidden, no sound. Reviewer probe: Clear leaves the banner shown with Goldshire (`GetView().line` nil, `GetView().shown` true); widget Hide then blanks both strings and hides flavor. Wrapped `frame.Show` **0**; wrapped `frame.Hide` **1**; `HeaderText` `SetText` **0**; Line/Flavor `SetText` **1** each (`wipePaint`). |
| OnHide Shows the banner, invents a line, Plays sound, or adds Clear Decree chrome | **Pass.** Handler has no `:Show()`, no `paint(`, no `PlaySound`, no `Goldshire`, no `Clear Decree`. `wipePaint` writes `""` only. `Banner.ClearDecree` is nil; `Banner.Deputy` is nil; whole-file source has no `Clear Decree` / `PlaySound` / `Media\\`. Reviewer spy: Clear + widget Hide leaves PlaySound at 0 and banner `Show` at 0. |
| `wireDecreeOnHide` / Init replaces an existing OnHide | **Pass. Verified.** Helper is `if existing then return`. Pins: Init after Show keeps create-path identity; widget Hide keeps the same script. Reviewer spy: sentinel OnHide survives Init. Create-path identity stayed across widget Hide. |
| B28-B Refresh wipe / B27-B Hide wipe / B26-C empty Show dropped | **Pass. Verified.** Nested `runB28B()` / `runB27B()` / `runB26C()` still run before `runB29B()`. Stay pins in `runB29B()` re-blank leftover Goldshire on Hide / Refresh / empty Show. Reviewer probe: leftover + Hide / Refresh / empty Show each blank both strings; wrapped banner `Show` **0**; Hide **1**. |
| `PlaySound` / Quiet no longer silent / `LINE_FONT` flipped / header or QuestBG changed | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. `MODE` is still `"QUIET"`. `LINE_FONT` is still `Fonts\\MORPHEUS.ttf`. Header is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. Suite `#sounds` is 0 at the end. Reviewer leftover cycle leaves PlaySound at 0. |
| Isolated suite not exit 0 / pins not nested / isolation wrap rewritten | **Pass. Verified.** 427 passed, 0 failed. Writer-reported count matches. `runB29B()` is a nested `local function` inside `runB25B()` after `runB28B()`. Isolation wrap stays under the first `if standalone then`. `luac -l -p`: main chunk **37** locals (cap 200). Packet adds no main-chunk `local`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`wireDecreeOnHide` + create-path calls; nested `runB29B()`). Sibling dirt in this workspace is other lanes (earlier Decree vestment batches vs HEAD; Toasts, Records, TOC, bootstrap, Console, MainFrame, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Records, glue; no commit; no deputy; no custom media; no sound; no Clear Decree chrome | **Pass.** Named-risk check. Source has no `Deputy` picker / `Media\\` / `Clear Decree`. `Banner.Deputy` / `Banner.ClearDecree` stay nil. Reviewer did not commit. |
| Wire OnHide: if `getDecree()` is nil, `wipePaint`. Do not replace an existing OnHide | **Pass.** Live helper. Source pin captures `if existing then return` + `getDecree()` + `wipePaint(frame)` (or `LineText:SetText("")`). Reviewer capture is that order. |
| Extract `wireDecreeOnHide(frame)` so SetScript stays out of Hide/Refresh | **Pass.** `buildFrame` and `ensureFrame` create call the helper. Hide / Refresh bodies have no `SetScript` / `wireDecreeOnHide`. |
| `Refresh` / empty `Show` / `Hide()` wipe stay | **Pass.** Named-risk check. |
| Do not Show from OnHide | **Pass.** Named-risk check. Handler has no `:Show()`. Reviewer spy: banner `Show` stays **0**. |
| Quiet silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Named-risk check. |
| Set, Show, `Clear()`, widget `frame:Hide()` (not `DecreeBanner:Hide` / Refresh): `IsShown` false; Line/Flavor `""` | **Pass.** Nested pins in that order. Reviewer probe matches. |
| Isolation wrap stays; `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **427 / 0.** |

B28 leftover (widget `frame:Hide()` after Clear still holding Goldshire) is closed on the same named Goldshire fixture. Law 6 (Quiet silent), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), and no `PlaySound` hold on the exclusive pair. Refresh / Hide / empty Show wipe stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Glue does not call Refresh yet. Core `Decree:Clear()` still does not notify the banner | **Stale. Nit on the report.** Batch 28 already added glue `wrapAlways` on `Decree:Clear` → `DecreeBanner:Refresh` (`ChurchOfBeef.lua`). Not a Spec FAIL. Isolated suite does not load glue, so Clear in this harness still leaves a visible leftover until Hide / Refresh / empty Show / widget Hide. Production Clear already Refresh-hides. |
| `ensureFrame` early-return does not remount a missing OnHide | **Allowed leftover.** Brief scoped create-path. Reviewer probe: niled OnHide stays nil across Init / Show / Refresh; a follow-up widget Hide then leaves Goldshire. |
| No client smoke. Live leftover paint after Pope Clear + ESC is unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `frame:Hide()` is a direct call, not a real ESC key | **On contract.** Brief scoped widget Hide after Clear. Script fire and leftover wipe are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / OnHide wipe / stay paths

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Runtime locals sit in `runB29B()` inside `runB25B()` so Lua 5.1's 200-local cap does not fire.

**OnHide wipe — Pass.** Create-path wires once when `GetScript("OnHide")` is nil. Nil `getDecree()` calls `wipePaint(frame)` and does not `paint`, does not `Show`, and does not `PlaySound`. `wipePaint` blanks both FontStrings and Hides flavor. It does not invent a line and does not touch `HeaderText`. Active `getDecree()` skips the wipe. Reviewer spy: leftover Goldshire is `""` after Clear + widget Hide; banner `Show` stays 0; Hide runs once; header `SetText` stays 0. Hide-while-set leaves the leftover strings; next Show paints. Second Hide on an already-hidden widget does not re-fire OnHide (stub matches the client transition).

**Stay paths — Pass.** B28-B Refresh wipe, B27-B Hide wipe, and B26-C empty Show are unchanged. Nested stay pins in `runB29B()` still blank leftover Goldshire. Reviewer probe: leftover + Hide / Refresh / empty Show each blank both strings with banner `Show` at 0.

---

## Strengths

- The delta is the brief: extract `wireDecreeOnHide`, wire on create-path only, wipe when Get is nil, do not Show, do not replace an existing script. Refresh / empty Show / Hide wipe / `wipePaint` / `LINE_FONT` / header / QuestBG were left alone. Banner Show stays off this path.
- B28 leftover (Clear then widget Hide still holding Goldshire) is closed on the same named Goldshire fixture, not a second paint language. Init identity sits next to the leftover-blank pin, so a replace-every-Init helper would fail.
- Isolation stayed gated. Runtime pins are inside `runB29B()` nested in `runB25B()` after `runB28B()`. Writer-reported **427 / 0** matched the re-run. Writer-reported red (**413 / 14**) matches the helper-missing + create-path OnHide nil + leftover Goldshire / flavor cluster a pre-lane banner would fail; the `assert_eq(find, nil)` “does not X” pins are vacuous on an empty capture and stayed green.
- Quiet stays silent. Reviewer leftover cycle (paint, Clear, widget Hide, Hide-while-set, Banner Hide, Refresh, empty Show, sentinel Init) leaves PlaySound at 0.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`ensureFrame` early-return does not remount a missing OnHide.** Brief scoped create-path. Reviewer probe: niled script stays nil across Init / Show / Refresh; widget Hide then leaves Goldshire. A remount that dropped the handler stays idle until the frame is rebuilt.

### Nit

1. **Writer leftover “Glue does not call Refresh yet” is stale.** Production `wrapAlways(COB.Decree, "Clear")` already calls `DecreeBanner:Refresh`. Isolated Clear still leaves a visible leftover because this suite does not load glue. That is isolation, not a missing wrap. Not a Spec FAIL.

2. **Source pin accepts `wipePaint(frame)` or `LineText:SetText("")`.** Flavor `SetText("")` is not a wire-body find. Live OnHide calls `wipePaint(frame)`. A body that blanked only `LineText` could still pass the `or` if `FlavorText:SetText("")` lived elsewhere. Runtime pins close both strings.

3. **`:Show()` pin is a wire-body string find.** It would not catch `frame.Show(frame)`. Reviewer spy on the widget `Show` method closes that hole (Clear + widget Hide stays **0**).

4. **Several “does not X” pins are vacuous if the `wireDecree` capture is empty.** `assert_eq(find, nil)` passes on `""`. The readable-body assert and the leftover-blank pins are the ones that fail first.

5. **`ensureFrame` create calls `wireDecreeOnHide` after `buildFrame` already wired.** The second call no-ops (`if existing then return`). Brief asked both sites. Redundant, not a replace.

6. **Isolation wrap is load-only.** Eighteen pins under the first `if standalone then`. Nested B29-B does not re-pin them. Brief said the wrap stays; it did.

7. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B29-B-only helper + nested pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **427 / 0** was re-run here. Live leftover paint after Pope Clear + ESC is unproven on Anniversary. Harness `frame:Hide()` is still not a real ESC key.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **427 passed, 0 failed.** Isolation wrap: **18**.

`wireDecreeOnHide` wires OnHide only when `GetScript("OnHide")` is nil. OnHide `wipePaint`s when `getDecree()` is nil and does not Show. `buildFrame` and `ensureFrame` create call the helper. After Set Goldshire + Show + Clear + widget `frame:Hide()` (not `DecreeBanner:Hide` / Refresh), `IsShown` is false and both FontStrings are `""`. Init does not replace OnHide. B28-B Refresh wipe, B27-B Hide wipe, and B26-C empty Show stay. Quiet stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Isolation stays stub + Common + Decree + Decree UI + Minimap. Isolated `lua tests/test_decree_ui.lua` **427 passed, 0 failed**, exit 0.

Leftovers: `ensureFrame` early-return does not remount a missing OnHide (allowed; brief said create-path); writer leftover “Glue does not call Refresh yet” is stale (Batch 28 `wrapAlways` already Refresh-hides on Clear); no client smoke; full harness not run; harness `frame:Hide()` is not a real ESC key.

Do not claim V1 / MVP complete. This review does not sign the lane.
