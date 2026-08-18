Spec PASS

# B27-B — Decree Hide blanks leftover paint when the line is gone (review)

**Quality:** Approved-with-nits

**Lane:** B27-B Decree Hide blanks leftover paint when the line is gone
**Brief:** `docs/reformation/vestments/briefs/B27-B-decree-hide.md`
**Writer report:** `docs/reformation/vestments/briefs/B27-B-decree-hide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B27-B-decree-hide.diff` (B27-B-only exclusive-pair packet; live `Decree.lua` also carries earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`DecreeBanner:Hide` / `wipePaint` / `getDecree` / empty `Show` / Close `OnClick`), and `tests/test_decree_ui.lua` (B27-B Hide source pins, nested `runB27B()` inside `runB25B()` after `runB26C()`, B26-C empty-Show wipe / uniqueness, isolation wrap); then ran `lua tests/test_decree_ui.lua` (**328 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: `Hide()` if `getDecree()` is nil and a frame exists, `wipePaint` then Hide; if a Decree is still active, just Hide (next Show paints); do not invent a line; do not Show; B26-C empty Show wipe stays; Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`; Anniversary `FontString:SetText` accepts `""`; no deputy; no custom media; no sound. Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Hide()` after `Decree:Clear()` still leaves Goldshire / flavor on the hidden (or still-shown) FontStrings (B26 leftover) | **Pass. Verified.** Live `Hide` is `if self.frame then` / `if not getDecree() then wipePaint(self.frame) end` / `self.frame:Hide()` / `return true`. Pins: Set Goldshire + flavor, Show, `Decree:Clear()`, `Hide()` (not Show) is true, `IsShown` false, both FontStrings `""`, flavor hidden, no sound. Reviewer probe: leftover starts as Goldshire; Clear leaves the banner shown with Goldshire; `Hide()` then blanks both strings and hides flavor. Wrapped `frame.Show` **0**; wrapped `frame.Hide` **1**; `HeaderText` `SetText` **0**. |
| Hide while a Decree is still set wipes, paints, or Shows | **Pass. Verified.** Active path skips `wipePaint` and only Hides. Pin: Hide while set succeeds, stays hidden, no sound; next Show paints Goldshire / flavor. Brief does not require a wipe pin. Reviewer probe: after Hide-while-set, `LineText` / `FlavorText` still hold Goldshire / flavor; next Show paints the same. |
| Hide invents a line, Shows the banner, or plays sound | **Pass.** Hide body has no `paint(`, no `:Show()`, no `PlaySound`, no `Goldshire`. `wipePaint` writes `""` only. Reviewer spy: Hide after Clear does not call `frame.Show` and does not increment PlaySound. |
| B26-C empty Show wipe / uniqueness dropped | **Pass. Verified.** Empty `Show` is still `ensureFrame()`, `wipePaint(frame)`, Hide, return false. Nested `runB26C()` still runs before `runB27B()`. Pins: Clear + empty Show blanks both strings; remount once; second empty Show stays blank and once. Reviewer probe: after a leftover cycle, empty Show remounts `ChurchOfBeefDecree` once and blanks; after Clear + Hide, empty Show remounts once; second empty Show stays 1. |
| `PlaySound` / Quiet no longer silent / `LINE_FONT` flipped / header or QuestBG changed | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. `MODE` is still `"QUIET"`. `LINE_FONT` is still `Fonts\\MORPHEUS.ttf`. Header is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. Hide / empty-Show / whole-file PlaySound pins stay. Suite `#sounds` is 0 at the end. Reviewer leftover cycle leaves PlaySound at 0. |
| Isolated suite not exit 0 / pins not nested / isolation wrap rewritten | **Pass. Verified.** 328 passed, 0 failed. Writer-reported count matches. `runB27B()` is a nested `local function` inside `runB25B()` after `runB26C()`. Isolation wrap stays under the first `if standalone then`. Source pin `local hideBody` sits next to B26-C `emptyShow` in the existing source-contract block. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`Hide` wipe-when-nil; Hide source pins + nested `runB27B()`). Sibling dirt in this workspace is other lanes (earlier Decree vestment batches vs HEAD; Toasts, Records, TOC, bootstrap, Console, MainFrame). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Records, glue; no commit; no deputy; no custom media; no sound | **Pass.** Named-risk check. Source has no `Deputy` picker / `Media\\`. `Banner.Deputy` pin stays nil. Reviewer did not commit. |
| `Hide()`: if `getDecree()` is nil and a frame exists, `wipePaint` then Hide | **Pass.** Live order. Source pin captures `getDecree()` + `wipePaint(self.frame)` (or `wipePaint(frame)` / `LineText:SetText("")`) + `:Hide()`. Reviewer capture is `if not getDecree() then wipePaint(self.frame) end` then `self.frame:Hide()`. |
| If a Decree is still active, just Hide (next Show paints). Do not invent a line. Do not Show | **Pass.** Named-risk check. |
| B26-C empty Show wipe stays | **Pass.** Named-risk check. |
| Quiet silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Named-risk check. |
| Set a Decree, Show, `Clear()`, `Hide()` (not Show): `IsShown` false; `LineText` / `FlavorText` are `""` | **Pass.** Nested pins in that order. Reviewer probe matches. |
| Hide while a Decree is still set does not require a wipe pin | **Pass.** Pins Hide + next Show paints. Reviewer probe: leftover text stays until that Show. |
| Isolation wrap stays; `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **328 / 0.** |

B26 leftover (`Hide()` after Clear still leaves Goldshire on the FontStrings; wipe was empty `Show` only) is closed on the same named Goldshire fixture, not a second paint language. Law 6 (Quiet silent), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), and no `PlaySound` hold on the exclusive pair. Empty Show uniqueness stays. Hidden-until-Set holds: Hide after Clear blanks leftover paint and Hides; it does not raise the banner.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Core `Decree:Clear()` still does not wipe the banner. A parchment left visible after Clear with no follow-up Hide or empty Show can still display Goldshire | **On contract.** Brief scoped `Hide()`. Reviewer probe: Clear leaves `IsShown` true and Goldshire on both FontStrings; `GetView().line` is already `nil` while `GetView().shown` is still true. Hide or empty Show then blanks. Production `Decree:Clear()` is Core-only on this tree (tests call it; the Pope desk has `PostDecree`, no Clear verb on this exclusive pair). |
| No client smoke. Live leftover paint after Pope Clear + Close / ESC Hide is unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key. Close-button Hide after Clear now wipes; the client's special-frame walk is not | **On contract.** Brief scoped `DecreeBanner:Hide()`. Close `OnClick` is `DecreeBanner:Hide()`; reviewer probe: Close after Clear blanks both strings. Widget `frame:Hide()` (ESC-like) after Clear hides and leaves Goldshire. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / Hide wipe / empty Show

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Runtime locals sit in `runB27B()` inside `runB25B()` so Lua 5.1's 200-local cap does not fire.

**Hide wipe — Pass.** Nil `getDecree()` with a frame calls `wipePaint(self.frame)` then Hides and returns true. It does not `paint`, does not `Show`, and does not `PlaySound`. `wipePaint` blanks both FontStrings and Hides flavor. It does not invent a line and does not touch `HeaderText`. Active `getDecree()` skips the wipe. No frame: Hide still returns true and does not `ensureFrame`. Reviewer spy: leftover Goldshire is `""` after Clear + Hide; `frame.Show` stays 0; Hide runs once; header `SetText` stays 0. Hide-while-set leaves the leftover strings; next Show paints.

**Empty Show uniqueness — Pass.** B26-C empty branch is unchanged. Nested `runB26C()` still blanks leftover Goldshire on empty Show and remounts once. Reviewer probe: leftover cycle + empty Show is count 1 and blank; Clear + Hide + empty Show is still count 1; second empty Show stays 1.

---

## Strengths

- The delta is the brief: four lines on `Hide()` gated on `not getDecree()`, then the existing Hide. Empty Show / `wipePaint` / `LINE_FONT` / header / QuestBG were left alone. Paint / banner Show stay off this path.
- B26 leftover (Clear then `Hide()` still holding Goldshire) is closed on the same named Goldshire fixture, not a second paint language. Hide-while-set is pinned **before** cleanup so a blanket wipe on every Hide would still pass the next-Show paint; the probe shows the active path really is just Hide.
- Isolation stayed gated. Runtime pins are inside `runB27B()` nested in `runB25B()` after `runB26C()`. Writer-reported **328 / 0** matched the re-run. Writer-reported red (**323 / 5**) matches the `getDecree` / `wipePaint` / leftover-blank asserts a pre-lane Hide would fail.
- Quiet stays silent. Reviewer leftover cycle (paint, Clear, Hide, Hide-while-set, Close, empty Show) leaves PlaySound at 0. Close after Clear uses the same `DecreeBanner:Hide` path and blanks.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Core `Decree:Clear()` still does not wipe the banner.** Reviewer probe: Clear leaves the banner shown with Goldshire / flavor; `GetView().line` is already `nil` while `GetView().shown` is still true. `Hide()` or empty `Show` then blanks. Brief scoped `Hide()`. Production Clear is not a desk verb on this exclusive pair.

2. **ESC-like widget `frame:Hide()` still leaves leftover paint.** `UISpecialFrames` hides the named frame; that is not `DecreeBanner:Hide()`. Reviewer probe: after Clear, `Banner.frame:Hide()` hides and `LineText` / `FlavorText` still read Goldshire. Close-button `OnClick` goes through `DecreeBanner:Hide()` and does blank. Brief scoped the banner Hide.

### Nit

1. **Source pin accepts `wipePaint(self.frame)` or `wipePaint(frame)` or `LineText:SetText("")`.** Flavor `SetText("")` is a whole-file find, not a Hide-body find. Live Hide calls `wipePaint(self.frame)`. A body that blanked only `LineText` could still pass the `or` if `FlavorText:SetText("")` lived elsewhere. Runtime pins close both strings.

2. **Hide-while-set does not pin leftover text.** Brief said no wipe pin. Next Show paints. Reviewer probe: leftover Goldshire / flavor stay on the hidden widget until that Show.

3. **Writer report says “No new main-chunk locals.”** Packet adds `local hideBody` in the existing source-contract block (same place as B26-C `emptyShow`). Runtime pins are nested. Brief required the wrap to stay, not a zero-local source block.

4. **Isolation wrap is load-only.** Eighteen pins under the first `if standalone then`. Nested B27-B does not re-pin them. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B27-B-only Hide wipe + nested pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **328 / 0** was re-run here. Live leftover paint after Pope Clear + Close / ESC is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **328 passed, 0 failed.** Isolation wrap: **18**.

`Hide()` calls `wipePaint` when `getDecree()` is nil and a frame exists, then Hides. Active Decree just Hides; next Show paints. After Set Goldshire + Show + Clear + Hide (not Show), `IsShown` is false and both FontStrings are `""`. B26-C empty Show wipe and uniqueness stay. Quiet stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Isolation stays stub + Common + Decree + Decree UI + Minimap. Isolated `lua tests/test_decree_ui.lua` **328 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
