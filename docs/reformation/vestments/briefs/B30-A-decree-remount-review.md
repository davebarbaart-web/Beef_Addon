Spec PASS

# B30-A — Decree ensureFrame remounts a missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B30-A Decree ensureFrame remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B30-A-decree-remount.md`
**Writer report:** `docs/reformation/vestments/briefs/B30-A-decree-remount-report.md`
**Diff:** `docs/reformation/vestments/briefs/B30-A-decree-remount.diff` (B30-A-only exclusive-pair packet; live `Decree.lua` also carries earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`ensureFrame` early-return ~284 / `wireDecreeOnHide` / `buildFrame` / `ensureFrame` create / `wipePaint` / empty `Show` / `Hide` / `Refresh`), and `tests/test_decree_ui.lua` (nested `runB30A()` inside `runB25B()` after `runB29B()`, B29-B OnHide wipe / B28-B Refresh wipe / B27-B Hide wipe / B26-C empty Show, isolation wrap); then ran `lua tests/test_decree_ui.lua` (**494 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: `ensureFrame` remounts a missing OnHide when the frame already exists; do **not** replace an existing script; do not Show from OnHide; `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`; no deputy; no Clear Decree chrome; no sound; Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B29 leftover (`ensureFrame` early-return only `rememberSpecial`s; a remount that dropped OnHide stays idle until rebuild). Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Batch 28 already added glue `wrapAlways` on `Decree:Clear` → `DecreeBanner:Refresh`; the writer leftover “Glue does not call Refresh yet” is stale (nit on the report, not a Spec FAIL). Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `ensureFrame` early-return still only `rememberSpecial`s; a dropped OnHide stays idle across Show / Refresh / Init | **Pass. Verified.** Live early-return is `rememberSpecial` then `wireDecreeOnHide(DecreeBanner.frame)`. Pins: nil OnHide, then empty Show / Refresh / Init on the existing frame restores the script; same frame pointer. Reviewer probe: niled script remounts on Show / Refresh / Init; frame pointer stays. |
| Remount replaces an existing OnHide | **Pass. Verified.** `wireDecreeOnHide` is still `if existing then return`. Pins: third Init / Show / Refresh with the script already set keep identity. Reviewer spy: sentinel OnHide survives Init / Show / Refresh. Remounted identity stayed across live Show and widget Hide. |
| OnHide Shows the banner, invents a line, Plays sound, or adds Clear Decree chrome | **Pass.** Handler is unchanged: `if not getDecree() then wipePaint(frame) end`. No `:Show()`, no `paint(`, no `PlaySound`, no `Goldshire`, no `Clear Decree`. Whole-file source has no `PlaySound` / `Clear Decree` / `Media\\` / `Deputy`. Reviewer spy: remounted Clear + widget Hide leaves banner `Show` at **0**, Hide **1**, header `SetText` **0**, PlaySound **0**. |
| Widget Hide after remount / Hide wipe / Refresh wipe / empty Show dropped | **Pass. Verified.** Nested stay pins in `runB30A()` still blank leftover Goldshire on widget Hide after Clear, `DecreeBanner:Hide`, Refresh, and empty Show. Reviewer probe: remounted widget Hide blanks both strings and hides flavor. |
| `PlaySound` / Quiet no longer silent / `LINE_FONT` flipped / header or QuestBG changed | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, or `SOUNDKIT`. `MODE` is still `"QUIET"`. `LINE_FONT` is still `Fonts\\MORPHEUS.ttf`. Header is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. Suite `#sounds` is 0 at the end. Reviewer remount cycle leaves PlaySound at 0. |
| Isolated suite not exit 0 / pins not nested / isolation wrap rewritten | **Pass. Verified.** 494 passed, 0 failed. Writer-reported count matches. `runB30A()` is a nested `local function` inside `runB25B()` after `runB29B()`. Isolation wrap stays under the first `if standalone then`. `luac -l -p`: main chunk **37** locals (cap 200). Packet adds no main-chunk `local`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (early-return `wireDecreeOnHide` after `rememberSpecial`; nested `runB30A()`). Sibling dirt in this workspace is other lanes (earlier Decree vestment batches vs HEAD; Toasts, Records, TOC, bootstrap, Console, MainFrame, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Records, glue; no commit; no deputy; no custom media; no sound; no Clear Decree chrome | **Pass.** Named-risk check. Source has no `Deputy` picker / `Media\\` / `Clear Decree`. `Banner.Deputy` / `Banner.ClearDecree` stay nil. Reviewer did not commit. |
| When the frame already exists, `ensureFrame` calls `wireDecreeOnHide(frame)` after `rememberSpecial` | **Pass.** Live early-return. Source pin: `rememberSpecial` index before `wireDecreeOnHide`. No inline `SetScript("OnHide"`. |
| Do **not** replace an existing script | **Pass.** Named-risk check. Helper still `if existing then return`. |
| Create-path / `buildFrame` stay | **Pass.** `buildFrame` and `ensureFrame` create still call the helper. Hide / Refresh bodies still have no `wireDecreeOnHide`. |
| Do not Show from OnHide | **Pass.** Named-risk check. Handler has no `:Show()`. Reviewer spy: banner `Show` stays **0**. |
| Hide / Refresh / empty Show wipe stay | **Pass.** Named-risk check. |
| Quiet silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Named-risk check. |
| Nil OnHide, then Show / Refresh / Init (frame already exists): script restored. Third call with the script already set: identity stays | **Pass.** Nested pins in that order. Reviewer probe matches. |
| Isolation wrap stays; `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **494 / 0.** |

B29 leftover (dropped OnHide idle until rebuild) is closed on Show / Refresh / Init. Law 6 (Quiet silent), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), and no `PlaySound` hold on the exclusive pair. Hide / Refresh / empty Show wipe stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Glue does not call Refresh yet. Core `Decree:Clear()` still does not notify the banner | **Stale. Nit on the report.** Batch 28 already added glue `wrapAlways` on `Decree:Clear` → `DecreeBanner:Refresh` (`ChurchOfBeef.lua`). Not a Spec FAIL. Isolated suite does not load glue, so Clear in this harness still leaves a visible leftover until Hide / Refresh / empty Show / widget Hide. Production Clear already Refresh-hides. |
| `DecreeBanner:Hide` does not call `ensureFrame`. A dropped OnHide that never hits Show, Refresh, or Init stays idle | **Allowed leftover.** Brief scoped remount on `ensureFrame` (Show / Refresh / Init). Hide wipe of leftover paint still runs on the method itself. Reviewer probe: Hide after a niled script leaves OnHide nil and still blanks Line/Flavor. |
| No client smoke. Live leftover paint after Pope Clear + ESC, and a live remount of a dropped OnHide, are unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `frame:Hide()` is a direct call, not a real ESC key | **On contract.** Brief scoped widget Hide after remount. Script fire and leftover wipe are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / stay paths

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Runtime locals sit in `runB30A()` inside `runB25B()` so Lua 5.1's 200-local cap does not fire.

**Remount — Pass.** Early-return `rememberSpecial` then `wireDecreeOnHide`. Helper wires only when `GetScript("OnHide")` is nil. Show / Refresh / Init hit `ensureFrame`, so a dropped handler is restored on the same frame pointer. A third call with the script already set keeps identity. Reviewer spy: sentinel survives Init / Show / Refresh. Dropped OnHide + widget Hide *without* remount still leaves Goldshire; empty Show then remounts and blanks.

**OnHide wipe after remount — Pass.** Remounted handler still `wipePaint`s when `getDecree()` is nil and does not `paint`, does not `Show`, and does not `PlaySound`. Reviewer spy: leftover Goldshire is `""` after Clear + widget Hide; banner `Show` stays 0; Hide runs once; header `SetText` stays 0.

**Stay paths — Pass.** B29-B widget Hide after Clear, B28-B Refresh wipe, B27-B Hide wipe, and B26-C empty Show are unchanged. Nested stay pins in `runB30A()` still blank leftover Goldshire.

---

## Strengths

- The delta is the brief: one early-return call after `rememberSpecial`. Create-path / `buildFrame` / Hide / Refresh / empty Show / `wipePaint` / `LINE_FONT` / header / QuestBG were left alone. Existing script is not replaced. Banner Show stays off OnHide.
- B29 leftover (dropped OnHide idle until rebuild) is closed on Show / Refresh / Init, then the same named Goldshire fixture still blanks on widget Hide. Identity-stay sits next to the remount pins, so a replace-every-ensureFrame helper would fail.
- Isolation stayed gated. Runtime pins are inside `runB30A()` nested in `runB25B()` after `runB29B()`. Writer-reported **494 / 0** matched the re-run. Writer-reported red (**486 / 8**) matches the early-return missing helper + Show / Refresh / Init leaving OnHide nil + leftover Goldshire / flavor cluster a pre-lane banner would fail.
- Quiet stays silent. Reviewer remount cycle (sentinel, dropped Show / Refresh / Init, leftover widget Hide, Hide / Refresh / empty Show) leaves PlaySound at 0.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`DecreeBanner:Hide` does not remount a missing OnHide.** Brief scoped `ensureFrame`. Hide wipe of leftover paint still runs on the method. A dropped handler that never hits Show, Refresh, or Init stays idle; a follow-up widget Hide then leaves Goldshire.

### Nit

1. **Writer leftover “Glue does not call Refresh yet” is stale.** Production `wrapAlways(COB.Decree, "Clear")` already calls `DecreeBanner:Refresh`. Isolated Clear still leaves a visible leftover because this suite does not load glue. That is isolation, not a missing wrap. Not a Spec FAIL.

2. **Early-return `:Show()` pin is a string find.** It would not catch `frame.Show(frame)` inside `wireDecreeOnHide`. Reviewer spy on the widget `Show` method closes that hole (remounted Clear + widget Hide stays **0**).

3. **Several “does not X” pins are vacuous if the `earlyEnsure` capture is empty.** `assert_eq(find, nil)` passes on `""`. The readable-body assert and the remount / leftover-blank pins are the ones that fail first.

4. **`ensureFrame` create still calls `wireDecreeOnHide` after `buildFrame` already wired.** The second call no-ops (`if existing then return`). Brief said create-path stays. Redundant, not a replace.

5. **Isolation wrap is load-only.** Eighteen pins under the first `if standalone then`. Nested B30-A does not re-pin them. Brief said the wrap stays; it did.

6. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B30-A-only early-return call + nested pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **494 / 0** was re-run here. Live remount of a dropped OnHide after Pope Clear + ESC is unproven on Anniversary. Harness `frame:Hide()` is still not a real ESC key.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **494 passed, 0 failed.** Isolation wrap: **18**.

`ensureFrame` early-return calls `wireDecreeOnHide` after `rememberSpecial`. A missing OnHide is remounted on Show / Refresh / Init when the frame already exists. Existing script identity stays. OnHide does not Show. Hide / Refresh / empty Show wipe stay. Quiet stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Isolation stays stub + Common + Decree + Decree UI + Minimap. Isolated `lua tests/test_decree_ui.lua` **494 passed, 0 failed**, exit 0.

Leftovers: `DecreeBanner:Hide` does not remount a missing OnHide (allowed; brief said `ensureFrame`); writer leftover “Glue does not call Refresh yet” is stale (Batch 28 `wrapAlways` already Refresh-hides on Clear); no client smoke; full harness not run; harness `frame:Hide()` is not a real ESC key.

Do not claim V1 / MVP complete. This review does not sign the lane.
