Spec PASS

# B26-C — Empty Decree Show blanks leftover line paint (review)

**Quality:** Approved-with-nits

**Lane:** B26-C Empty Decree Show blanks leftover line paint
**Brief:** `docs/reformation/vestments/briefs/B26-C-decree-wipe.md`
**Writer report:** `docs/reformation/vestments/briefs/B26-C-decree-wipe-report.md`
**Diff:** `docs/reformation/vestments/briefs/B26-C-decree-wipe.diff` (B26-C-only exclusive-pair packet; live `Decree.lua` / `test_decree_ui.lua` also carry earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`DecreeBanner:Show` empty-Get: `ensureFrame()` then `wipePaint(frame)` then `frame:Hide()` then `return false`; `wipePaint` blanks `LineText` / `FlavorText` and Hides flavor; no `paint(`; no `frame:Show()`; `ensureFrame` early-return and create-path both `rememberSpecial(FRAME_NAME)`), and `tests/test_decree_ui.lua` (empty-Show source pins, nested `runB26C()` inside `runB25B()` after uniqueness restore, suite Clear path after Orgrimmar, B25-B wipe + Show-only uniqueness, existing Set / Show / Quiet hide / persist / Morpheus pins, isolation wrap); then ran `lua tests/test_decree_ui.lua` (**302 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: empty `Show()` `ensureFrame`s, blanks `LineText` / `FlavorText` (`SetText("")`; hide flavor), then Hide, return false; do not Show the banner; do not invent a line; B25-B ESC remount stays; Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`; no deputy; no custom media; no sound. Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Empty `Show()` still leaves leftover Goldshire / flavor on the hidden widget (B25-B leftover) | **Pass. Verified.** Live empty branch is `ensureFrame()` then `wipePaint(frame)` then `frame:Hide()` then `return false`. `wipePaint` `SetText("")`s `LineText` and `FlavorText` and Hides flavor. Pins: Set Goldshire + flavor, Show, `Decree:Clear()`, empty Show is false, `IsShown` false, both FontStrings `""`, flavor hidden. Suite Clear after Orgrimmar pins the same. Reviewer probe: leftover starts as Goldshire; after Clear + empty Show both strings are `""`; later Set + Show paints Orgrimmar; Clear + empty Show blanks that too. |
| Empty `Show` paints, Shows the banner, or invents a line | **Pass. Verified.** Empty body has no `paint(frame` and no `frame:Show()`. `wipePaint` writes `""` only. `IsShown` stays false. Reviewer spy: wrapped `frame.Show` **0**; wrapped `frame.Hide` **1**; `HeaderText` `SetText` **0** (header stays the fixed copy; no invented line). Second empty Show still hidden with blank line/flavor. |
| B25-B wipe + Show-only uniqueness dropped; remount needs Init after | **Pass. Verified.** `runB25B()` wipe-to-`{}` then Show-only still lists `ChurchOfBeefDecree` once with no Init after. Second empty Show stays 1. Nested `runB26C()` wipe-to-`{}` after Clear + empty Show is still 1; second empty Show after Clear still 1. `rememberSpecial` still dedupes. Reviewer probe: B25-B remount after the leftover cycle is still count 1 and hidden. |
| `PlaySound` / Quiet no longer silent / `LINE_FONT` flipped / header or QuestBG changed | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. `MODE` is still `"QUIET"`. `LINE_FONT` is still `Fonts\\MORPHEUS.ttf`. Header is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. Empty-Show source pin refuses `PlaySound`. Whole-file PlaySound pin stays. Suite `#sounds` is 0 at the end. Reviewer spy: leftover Show, Clear, empty Show, second empty Show, later paint, and wipe leave the PlaySound counter at 0. |
| Isolated suite not exit 0 / pins not nested in `runB25B()` / new main-chunk locals | **Pass. Verified.** 302 passed, 0 failed. Writer-reported count matches. `runB26C()` is a nested `local function` inside `runB25B()` after uniqueness restore. Packet adds no main-chunk `local`. Isolation wrap stays under the load-time standalone block. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`wipePaint` + empty `Show` call; source pins + nested `runB26C()` + suite Clear blanks). Sibling dirt in this workspace is other lanes (earlier Decree vestment batches vs HEAD; Toasts, Records, TOC, bootstrap, Console, MainFrame). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Records, glue; no commit; no deputy; no custom media; no sound | **Pass.** Named-risk check. Source has no `Deputy` picker / `Media\\`. `Banner.Deputy` pin stays nil. Reviewer did not commit. |
| Empty `Show()`: `ensureFrame()`, blank `LineText` / `FlavorText` (`SetText("")`; hide flavor), then Hide, return false | **Pass.** Live order. Source pin captures `ensureFrame()` + `wipePaint(frame)` (or `LineText:SetText("")`) + Hide. Reviewer capture is exactly that block. |
| Do not Show the banner. Do not invent a line | **Pass.** Named-risk check. |
| B25-B ESC remount stays. Wipe + Show-only lists `ChurchOfBeefDecree` once | **Pass.** Named-risk check. Same uniqueness after Clear + empty Show. |
| Quiet silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Named-risk check. |
| Set a Decree, Show, Clear, empty Show: `IsShown` false; `LineText` / `FlavorText` are `""` | **Pass.** Nested pins in that order. Suite Clear after Orgrimmar also pins blank line/flavor and hidden flavor. |
| Isolation wrap stays; `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **302 / 0.** |

B25-B leftover (empty `Show` `ensureFrame`s then Hide, leftover `LineText` / `FlavorText` still hold the last Goldshire line on the hidden widget) is closed on the same Goldshire fixture, not a second paint language. Law 6 (Quiet silent), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), and no `PlaySound` hold on the exclusive pair. Hidden-until-Set holds: empty Show blanks leftover paint and Hides; it does not raise the banner.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Wipe is on empty `Show` only. `Decree:Clear()` and `DecreeBanner:Hide()` do not blank FontStrings. A banner left visible after Core Clear (no follow-up empty Show) can still display Goldshire | **On contract.** Brief scoped empty `Show`. Reviewer probe: Clear leaves the banner shown with Goldshire; Hide then still reads Goldshire until empty `Show`. Minimap after Clear Toggles `/beef` and does not call empty `Show`. |
| No client smoke. Live leftover paint after a Pope Clear + minimap replay is unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked membership counts. The client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / empty Show / uniqueness

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). New runtime locals sit in `runB26C()` inside `runB25B()` so Lua 5.1's 200-local cap does not fire.

**Empty Show wipe — Pass.** Nil `getDecree()` calls `ensureFrame()`, `wipePaint(frame)`, Hides, returns false. It does not `paint`, does not `frame:Show()`, and does not `PlaySound`. `wipePaint` blanks both FontStrings and Hides flavor. It does not invent a line and does not touch `HeaderText`. When the banner already exists, `ensureFrame` early-returns after `rememberSpecial` (no rebuild). Reviewer spy: leftover Goldshire is `""` after Clear + empty Show; `frame.Show` stays 0; Hide runs once; header `SetText` stays 0.

**Uniqueness — Pass.** B25-B wipe-to-empty then Show-only still lists the name once with no Init after. Second empty Show stays once. After Clear, wipe-to-`{}` then empty Show is still once; second empty Show after Clear stays once. Reviewer probe: B25-B remount after the leftover cycle is still count 1.

---

## Strengths

- The delta is the brief: `wipePaint` plus three lines on the empty `Show` branch (`ensureFrame`, wipe, Hide). Paint / banner Show stay on the live-Get path only. Header / QuestBG / `LINE_FONT` / create-path register were left alone.
- B25-B's leftover (hidden widget still holding Goldshire after empty Show) is closed on the same named Goldshire fixture, not a second paint language. B25-B wipe + Show-only uniqueness was left in place and re-pinned after Clear.
- Isolation stayed gated. Runtime pins are inside `runB26C()` nested in `runB25B()`. Writer-reported **302 / 0** matched the re-run. Writer-reported red (**292 / 11**) matches the leftover-blank / empty-`SetText` asserts a B25-B empty Show would fail.
- Quiet stays silent. Reviewer leftover cycle (paint, Clear, empty Show, second empty Show, later paint, wipe) leaves PlaySound at 0.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Wipe is on empty `Show` only.** Reviewer probe: `Decree:Clear()` leaves the banner shown with Goldshire / flavor; `GetView().line` is already `nil` while `GetView().shown` is still true. `DecreeBanner:Hide()` hides and does not blank. Minimap after Clear Toggles `/beef` and does not call empty `Show`, so that click does not close the leftover. Brief scoped empty `Show`. The Pope desk has `PostDecree` (calls `Show` after Set) and no Clear verb on this exclusive pair.

### Nit

1. **Source pin accepts `wipePaint(frame)` or `LineText:SetText("")`.** Flavor `SetText("")` is a whole-file find, not an empty-Show-body find. Live empty branch calls `wipePaint`. A body that blanked only `LineText` could still pass the `or` if `FlavorText:SetText("")` lived elsewhere.

2. **Second empty Show after Clear does not re-pin flavor `IsShown`.** Line/flavor text stay `""`. Reviewer probe: flavor stays hidden.

3. **Isolation wrap is load-only.** Eighteen pins under the first `if standalone then`. Nested B26-C does not re-pin them. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B26-C-only wipe + nested pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **302 / 0** was re-run here. Live leftover paint after a Pope Clear + minimap click is unproven on Anniversary.

6. **First-create via empty Show (frame nil) is unpinned.** Brief scoped leftover after a painted Show. Probe: Reset then empty Show still builds hidden, blanks line, lists the name once, and later Init returns the same pointer.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **302 passed, 0 failed.** Isolation wrap: **18**.

Empty `Show()` calls `ensureFrame()`, `wipePaint`s leftover `LineText` / `FlavorText`, Hides, and returns false. It does not Show the banner and does not invent a line. After Set Goldshire + Show + Clear + empty Show, `IsShown` is false and both FontStrings are `""`. B25-B wipe + Show-only uniqueness stays. Quiet stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Isolation stays stub + Common + Decree + Decree UI + Minimap. Isolated `lua tests/test_decree_ui.lua` **302 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
