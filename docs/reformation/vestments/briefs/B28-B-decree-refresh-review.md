Spec PASS

# B28-B — Decree Refresh hides leftover paint when the line is gone (review)

**Quality:** Approved-with-nits

**Lane:** B28-B Decree Refresh hides leftover paint when the line is gone
**Brief:** `docs/reformation/vestments/briefs/B28-B-decree-refresh.md`
**Writer report:** `docs/reformation/vestments/briefs/B28-B-decree-refresh-report.md`
**Diff:** `docs/reformation/vestments/briefs/B28-B-decree-refresh.diff` (B28-B-only exclusive-pair packet; live `Decree.lua` also carries earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`DecreeBanner:Refresh` / `ensureFrame` / `getDecree` / `wipePaint` / `paint` / empty `Show` / `Hide` / `IsShown`), and `tests/test_decree_ui.lua` (Refresh type / source pins, nested `runB28B()` inside `runB25B()` after `runB27B()`, B27-B Hide wipe / B26-C empty Show, isolation wrap); then ran `lua tests/test_decree_ui.lua` (**369 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Refresh `ensureFrame`; no decree → `wipePaint` + Hide, return false; decree + already shown → `paint`, stay shown, return true; do not Show a hidden banner (Quiet hidden-until-Set / minimap replay); empty `Show()` / `Hide()` wipe stay; Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B27 leftover (Core `Decree:Clear()` leaves a visible banner until Hide or empty Show); `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`; Anniversary `FontString:SetText` accepts `""`; no deputy; no Clear Decree chrome; no custom media; no sound. Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Refresh()` after `Decree:Clear()` still leaves Goldshire / flavor on a visible banner (B27 leftover) | **Pass. Verified.** Live `Refresh` is `ensureFrame()`, then `if not getDecree() then wipePaint(frame)` / `frame:Hide()` / `return false`. Pins: Set Goldshire + flavor, Show, `Decree:Clear()`, `Refresh()` (not Hide/Show) is false, `IsShown` false, both FontStrings `""`, flavor hidden, remount `ChurchOfBeefDecree` once, no sound. Reviewer probe: Clear leaves the banner shown with Goldshire; `GetView().line` is already `nil` while `GetView().shown` is still true; `Refresh()` then blanks both strings, hides flavor, and Hides. Wrapped `frame.Show` **0**; wrapped `frame.Hide` **1**; `HeaderText` `SetText` **0**; Line/Flavor `SetText` **1** each (`wipePaint`). |
| Hidden + Set + Refresh Shows the banner or paints | **Pass. Verified.** Live path: decree present and `not self:IsShown()` returns false with no `paint` and no `:Show()`. Pin: after Clear + Refresh, Set Goldshire, `Refresh()` is false, stays hidden, both FontStrings stay `""`, no sound. Reviewer probe: wrapped `frame.Show` **0**; Hide **0**; Header/Line/Flavor `SetText` **0**. Next `Show()` paints Goldshire. |
| Shown + live Decree Refresh hides, skips paint, or Shows again | **Pass. Verified.** Live path: `self:IsShown()` then `paint(frame, decree)` and return true. Pin: live Set to Shattrath + flavor, `Refresh()` is true, stays shown, new line / flavor, no sound. Reviewer probe: wrapped banner `Show` **0**; Hide **0**; Header/Line/Flavor `SetText` **1** each (`paint`); flavor shown. |
| Refresh invents a line, Plays sound, or adds Clear Decree chrome | **Pass.** Refresh body has no `:Show()`, no `PlaySound`, no `Goldshire`, no `Clear Decree`. `wipePaint` writes `""` only. `Banner.ClearDecree` is nil; `buttonFor("Clear Decree")` is nil; whole-file source has no `Clear Decree`. Reviewer spy: Clear + Refresh and hidden + Set + Refresh leave PlaySound at 0. |
| B27-B Hide wipe / B26-C empty Show dropped | **Pass. Verified.** Empty `Show` is still `ensureFrame()`, `wipePaint(frame)`, Hide, return false. `Hide` is still wipe-when-nil then Hide. Nested `runB26C()` / `runB27B()` still run before `runB28B()`. Pins stay. Reviewer probe: leftover + Hide blanks both strings; leftover + empty Show remounts `ChurchOfBeefDecree` once and blanks. |
| Isolated suite not exit 0 / pins not nested / isolation wrap rewritten | **Pass. Verified.** 369 passed, 0 failed. Writer-reported count matches. `runB28B()` is a nested `local function` inside `runB25B()` after `runB27B()`. Isolation wrap stays under the first `if standalone then`. Source pin `local refreshBody` sits next to B27-B `hideBody` in the existing source-contract block. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`Refresh` after `GetView`; type / source pins + nested `runB28B()`). Sibling dirt in this workspace is other lanes (earlier Decree vestment batches vs HEAD; Toasts, Records, TOC, bootstrap, Console, MainFrame). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Records, glue; no commit; no deputy; no custom media; no sound; no Clear Decree chrome | **Pass.** Named-risk check. Source has no `Deputy` picker / `Media\\` / `Clear Decree`. `Banner.Deputy` / `Banner.ClearDecree` stay nil. Reviewer did not commit. |
| `Refresh()`: `ensureFrame` if needed | **Pass.** Live first line is `local frame = ensureFrame()`. Source pin finds `ensureFrame()`. Nil `CreateFrame` still returns false (`if not frame then return false`). |
| No decree: `wipePaint` then Hide, return false | **Pass.** Live order. Source pin captures `getDecree()` + `wipePaint(frame)` (or `wipePaint(self.frame)` / `LineText:SetText("")`) + `:Hide()`. Reviewer capture is `if not decree then wipePaint(frame)` / `frame:Hide()` / `return false`. |
| Decree + already shown: `paint`, stay shown, return true | **Pass.** Named-risk check. |
| Do not Show a hidden banner (Quiet hidden-until-Set / minimap replay) | **Pass.** Named-risk check. Body has no `:Show()`. |
| Empty `Show()` / `Hide()` wipe stay | **Pass.** Named-risk check. |
| Quiet silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. `MODE` is still `"QUIET"`. `LINE_FONT` is still `Fonts\\MORPHEUS.ttf`. Header is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. Suite `#sounds` is 0 at the end. Reviewer leftover cycle leaves PlaySound at 0. |
| Set, Show, `Clear()`, `Refresh()` (not Hide/Show): `IsShown` false; Line/Flavor `""` | **Pass.** Nested pins in that order. Reviewer probe matches. |
| Hidden + Set + Refresh does not Show | **Pass.** Nested pins. Reviewer probe: banner `Show` stays 0; strings stay `""`. |
| Isolation wrap stays; `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **369 / 0.** |

B27 leftover (Clear leaves a visible Goldshire banner until Hide or empty Show) is closable on the same named Goldshire fixture once something calls `Refresh()`. Law 6 (Quiet silent; hidden-until-Set / minimap replay), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), and no `PlaySound` hold on the exclusive pair. Empty Show / Hide wipe stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Glue does not call Refresh yet. Core `Decree:Clear()` still does not notify the banner | **On contract.** Brief scoped `DecreeBanner:Refresh()`. B28-INT is the wrap (`Decree:Clear` → `DecreeBanner:Refresh`). Reviewer probe: Clear still leaves `IsShown` true and Goldshire on both FontStrings until Refresh / Hide / empty Show. Production `Decree:Clear()` is Core-only on this tree. |
| No client smoke. Live leftover paint after Pope Clear + Refresh is unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Refresh()` is a direct call, not a Pope-console Clear path. Membership remount is pinned; the client's special-frame walk is not | **On contract.** Brief scoped `DecreeBanner:Refresh()`. Remount is existing `ensureFrame` / `rememberSpecial`. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / Refresh wipe / hidden-until-Set

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Runtime locals sit in `runB28B()` inside `runB25B()` so Lua 5.1's 200-local cap does not fire.

**Refresh wipe — Pass.** Nil `getDecree()` after `ensureFrame()` calls `wipePaint(frame)` then Hides and returns false. It does not `paint`, does not `Show`, and does not `PlaySound`. `wipePaint` blanks both FontStrings and Hides flavor. It does not invent a line and does not touch `HeaderText`. Reviewer spy: leftover Goldshire is `""` after Clear + Refresh; banner `Show` stays 0; Hide runs once; header `SetText` stays 0. Second Refresh stays hidden and blank.

**Hidden-until-Set — Pass.** A live Decree while the banner is hidden returns false with no `paint` and no `Show`. Reviewer probe: hidden + Set + Refresh leaves both FontStrings `""` and `Show` at 0; no-frame + Set + Refresh mints a hidden blank widget (`ensureFrame`) and does not Show; Hide-while-set then Refresh leaves the prior Goldshire on the hidden widget (decree still set, so no wipe) and does not Show. Next `Show()` paints.

**Empty Show / Hide stay — Pass.** B26-C empty branch and B27-B Hide wipe are unchanged. Nested `runB26C()` / `runB27B()` still blank leftover Goldshire. Reviewer probe: leftover + empty Show is count 1 and blank; leftover + Hide blanks both strings. Close `OnClick` is still `DecreeBanner:Hide()`; Close after Clear blanks via that Hide path.

---

## Strengths

- The delta is the brief: `ensureFrame`, wipe+Hide when Get is nil, `paint` only when already shown, no `:Show()`. Empty Show / Hide wipe / `wipePaint` / `LINE_FONT` / header / QuestBG were left alone. Banner Show stays off this path (`paint` may `FlavorText:Show`; the parchment frame does not).
- B27 leftover (Clear then a visible Goldshire banner) is closable on the same named Goldshire fixture without going through Hide or empty Show. Hidden + Set + Refresh is pinned **before** the shown-paint pin, so a Refresh that always Show'd or always painted would fail Quiet hidden-until-Set.
- Isolation stayed gated. Runtime pins are inside `runB28B()` nested in `runB25B()` after `runB27B()`. Writer-reported **369 / 0** matched the re-run. Writer-reported red (**347 / 22**) matches the Refresh type / source / leftover-blank / hidden-no-Show asserts a pre-lane banner would fail.
- Quiet stays silent. Reviewer leftover cycle (paint, Clear, Refresh, hidden Set + Refresh, shown live Refresh, Hide wipe, empty Show, widget Hide, Close) leaves PlaySound at 0.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Glue does not call Refresh yet.** Reviewer probe: `Decree:Clear()` still leaves the banner shown with Goldshire / flavor; `GetView().line` is already `nil` while `GetView().shown` is still true. `Refresh()` / `Hide()` / empty `Show()` then blank. Brief scoped `DecreeBanner:Refresh()`. B28-INT is the wrap.

2. **ESC-like widget `frame:Hide()` still leaves leftover paint.** `UISpecialFrames` hides the named frame; that is not `DecreeBanner:Refresh()` or `DecreeBanner:Hide()`. Reviewer probe: after Clear, `Banner.frame:Hide()` hides and `LineText` / `FlavorText` still read Goldshire; a follow-up `Refresh()` then blanks. Close-button `OnClick` goes through `DecreeBanner:Hide()` and does blank. Brief scoped banner `Refresh()`.

### Nit

1. **Source pin `refreshBody` is greedy to EOF** (`function DecreeBanner:Refresh%(%)%s*\n(.+)$`). Hide uses a non-greedy cut at `GetView`. Refresh is last, so the capture is the body today. A later function after `Refresh` would join the pin.

2. **Source pin accepts `wipePaint(frame)` or `wipePaint(self.frame)` or `LineText:SetText("")`.** Flavor `SetText("")` is not a Refresh-body find. Live Refresh calls `wipePaint(frame)`. A body that blanked only `LineText` could still pass the `or` if `FlavorText:SetText("")` lived elsewhere. Runtime pins close both strings.

3. **`:Show()` pin is a Refresh-body string find.** It would not catch `frame.Show(frame)`. Reviewer spy on the widget `Show` method closes that hole (Clear + Refresh and hidden + Set + Refresh stay **0**).

4. **Isolation wrap is load-only.** Eighteen pins under the first `if standalone then`. Nested B28-B does not re-pin them. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B28-B-only `Refresh` + nested pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **369 / 0** was re-run here. Live leftover paint after Pope Clear + Refresh is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **369 passed, 0 failed.** Isolation wrap: **18**.

`Refresh()` calls `ensureFrame()`, then `wipePaint` + Hide when `getDecree()` is nil (return false). A live Decree that is already shown is painted and stays shown (return true). A hidden banner is not Shown. After Set Goldshire + Show + Clear + Refresh (not Hide/Show), `IsShown` is false and both FontStrings are `""`. Hidden + Set + Refresh stays hidden and does not paint. B27-B Hide wipe and B26-C empty Show stay. Quiet stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Isolation stays stub + Common + Decree + Decree UI + Minimap. Isolated `lua tests/test_decree_ui.lua` **369 passed, 0 failed**, exit 0.

Leftovers: glue does not call Refresh (B28-INT); widget `frame:Hide()` after Clear still leaves leftover paint; no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane.
