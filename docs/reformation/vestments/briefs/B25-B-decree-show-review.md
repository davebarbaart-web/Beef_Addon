Spec PASS

# B25-B — Empty Decree Show still registers ESC then hides (review)

**Quality:** Approved-with-nits

**Lane:** B25-B Empty Decree Show still registers ESC then hides
**Brief:** `docs/reformation/vestments/briefs/B25-B-decree-show.md`
**Writer report:** `docs/reformation/vestments/briefs/B25-B-decree-show-report.md`
**Diff:** `docs/reformation/vestments/briefs/B25-B-decree-show.diff` (B25-B-only exclusive-pair packet; live `Decree.lua` / `test_decree_ui.lua` also carry earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`Show` empty-Get: `ensureFrame()` then `frame:Hide()` then `return false`; no `paint`; no `frame:Show()`; `ensureFrame` early-return and create-path both `rememberSpecial(FRAME_NAME)`), and `tests/test_decree_ui.lua` (empty-Show source pins, `runB25B()` wipe + Show-only without Init after, B24-D Init uniqueness nest with the leftover Show-without-decree pin tightened, existing Set / Show / Quiet hide / persist / Morpheus pins, isolation wrap); then ran `lua tests/test_decree_ui.lua` (**280 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: `Show()` with nil `getDecree()` still `ensureFrame()` then Hide, return false; do not paint; do not Show the banner; Quiet hidden-until-Set; wiki ESC via `UISpecialFrames` (named `ChurchOfBeefDecree`; do not PlaySound `IG_CHARACTER_INFO_*`); B24-D leftover (`Show()` returned before `ensureFrame`; a wiped list then Show-only never got the name back); Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 (theatrical parchment; header copy / QuestBG stay); `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`; no deputy. Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Empty `Show()` still returns before `ensureFrame` (B24-D leftover) | **Pass. Verified.** Live empty branch is `local frame = ensureFrame()` then `if frame then frame:Hide() end` then `return false`. Source pin captures that body. Pins: wipe `UISpecialFrames` to `{}`, `Show` is false, `IsShown` is false, `ChurchOfBeefDecree` listed once with no Init after. Reviewer probe: wipe leaves count 0; Show-only returns false, same pointer, count 1; wrapped `CreateFrame` saw **0** new calls. B24-D leftover probe (wipe then Show miss) is now count 1, not 0. |
| Empty `Show` paints or Shows the banner | **Pass. Verified.** Empty body has no `paint(` and no `frame:Show()`. `IsShown` stays false. Reviewer spy: `LineText`/`HeaderText` `SetText` **0**; wrapped `frame.Show` **0**; wrapped `frame.Hide` **1**. After Clear of a painted banner, empty Show still hides and does not `SetText`. Later `Set` + `Show` paints the new line. |
| Wipe + Show-only never lists the name, or lists it twice; remount needs Init after | **Pass. Verified.** `runB25B()` is Show-only after wipe — no Init after the first empty Show. Count is 1. Second empty Show stays 1. B24-D nest also pins Show-without-decree lists once, then Init after still once. `rememberSpecial` still dedupes. Reviewer probe: second empty Show create-delta still 0. |
| B24-D Init uniqueness pins dropped or red | **Pass. Verified.** `runB24D()` still has first-create once, wipe-to-0, second Init once + same pointer, third Init once, then the tightened Show-without-decree once + Init after once. Suite **280 / 0** includes that nest. Reviewer probe: wipe + Init still same pointer and count 1; third Init stays 1. |
| `PlaySound` / Quiet no longer silent / `LINE_FONT` flipped | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. `MODE` is still `"QUIET"`. `LINE_FONT` is still `Fonts\\MORPHEUS.ttf` (only other use: `applyFont(line, "GameFontNormalHuge", LINE_FONT, 18)`). Empty-Show source pin refuses `PlaySound`. Whole-file PlaySound pin stays. Suite `#sounds` is 0 at the end. Reviewer spy: empty Show, second empty Show, Clear+Show, and later painting Show leave the PlaySound counter at 0. |
| Isolated suite not exit 0 / pins not in `runB25B()` | **Pass. Verified.** 280 passed, 0 failed. Writer-reported count matches. Runtime remount locals live in `runB25B()` (and the leftover tighten inside `runB24D()`). Isolation wrap stays under the load-time standalone block. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (empty `Show` `ensureFrame` then Hide; empty-Show source pins + `runB25B()` + B24-D leftover tighten). Sibling dirt in this workspace is other lanes (Toasts, Records, TOC, bootstrap, `run.lua`, Console, MainFrame). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Records, glue; no commit; no deputy; no custom media | **Pass.** Named-risk check. Source has no `Deputy` picker / `Media\\`. `Banner.Deputy` pin stays nil. Reviewer did not commit. |
| `Show()`: if `getDecree()` is nil, still `ensureFrame()`, then Hide, return false | **Pass.** Live order. Source pin captures the empty-Get body. Reviewer capture is exactly `ensureFrame()` then `frame:Hide()`. |
| Do not paint. Do not Show the banner. Quiet stays hidden-until-Set | **Pass.** Named-risk check. Init with nil Get still hidden. Empty Show stays hidden. After Clear, Show hides rather than painting blanks. |
| Wiki ESC: named frame on `UISpecialFrames`. `ensureFrame` already `rememberSpecial`s | **Pass.** `FRAME_NAME` is still `ChurchOfBeefDecree`. Early-return and `buildFrame` still `rememberSpecial(FRAME_NAME)`. Wipe + Show-only lists that name once. |
| No `PlaySound` / `IG_CHARACTER_INFO_*`. Quiet silent | **Pass.** Named-risk check. |
| `LINE_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Literal keep-pin. Reviewer read the same assignment. Header copy is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. |
| Wipe + Show-only lists `ChurchOfBeefDecree` once without Init after | **Pass.** `runB25B()` does that. Reviewer probe matches. |
| Existing Set / Show / Quiet hide / persist / Morpheus pins stay | **Pass.** Close / same-session Init / replay `Show` / already-seen-is-not-SV (`decreeSeen` / `alreadySeen` / `shownThisSession`) blocks were not rewritten. `Fonts\\MORPHEUS.ttf` / refuse uppercase TTF / refuse `MORPHEUS_CYR` stay. |
| B24-D Init uniqueness pins stay green | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **280 / 0.** |

B24-D leftover (wiped `UISpecialFrames` then Show-only never got `ChurchOfBeefDecree` back) is closed on the empty-Show path. Law 6 (Quiet silent), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), and no `PlaySound` hold on the exclusive pair. Hidden-until-Set holds: empty Show registers ESC and Hides; it does not raise the banner.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` order is unproven on Anniversary | **Not a miss.** Brief asked isolated green + empty Show `ensureFrame` then Hide + uniqueness once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked membership counts. The client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / empty Show / uniqueness

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). New runtime locals sit in `runB25B()` so Lua 5.1's 200-local cap does not fire.

**Empty Show — Pass.** Nil `getDecree()` calls `ensureFrame()` then Hides the returned frame and returns false. It does not `paint`, does not `frame:Show()`, and does not `PlaySound`. When the banner already exists, `ensureFrame` early-returns after `rememberSpecial` (no rebuild). Reviewer spy: CreateFrame count unchanged across wipe + empty Show and second empty Show. First-create via empty Show (frame nil; extra vs the After-Init brief) still builds hidden, lists the name once, and later Init returns the same pointer.

**Uniqueness — Pass.** Wipe-to-empty then Show-only lists the name once with no Init after. Second empty Show stays once. B24-D first-create / second Init / third Init / Init-after-Show pins stay. Reviewer probe: `UISpecialFrames = nil` then empty Show leaves the global nil (rememberSpecial no-ops); assigning `{}` then Show lists once.

---

## Strengths

- The delta is the brief: empty `Show` is three lines (`ensureFrame`, Hide, `return false`). Paint / banner Show stay on the live-Get path only. Header / QuestBG / `LINE_FONT` / create-path register were left alone.
- Wipe-to-`{}` then Show-only is the leftover close, not only a source `find`. B24-D Init uniqueness was left in place and tightened so Show-without-decree itself re-registers. Reviewer remount still returns the same pointer, Hides once, and plays no sound.
- Isolation stayed gated. Runtime pins are inside `runB25B()`. Writer-reported **280 / 0** matched the re-run. Writer-reported red (**276 / 4**) matches the four asserts old `if self.frame then self.frame:Hide() end` would fail: empty-Show `ensureFrame` string; B24-D wiped + Show-without-decree lists once; B25-B Show-only lists once; second empty Show still once.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. Brief asked empty Show `ensureFrame` then Hide + uniqueness once, not a client walk. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

### Nit

1. **`IsShown` is labeled “does not paint.”** Visibility is not paint. Source `paint(` refuse plus reviewer `SetText` spy (**0**) close the hole. After Clear, leftover `LineText` still reads the old Goldshire line on the hidden widget; the next painting `Show` overwrites. Brief said do not paint, not blank FontStrings.

2. **First-create via empty Show (frame nil) is unpinned.** Brief scoped After Init, then wipe, then Show-only. Probe: Reset then empty Show still builds hidden, lists the name once, and later Init returns the same pointer.

3. **`UISpecialFrames = nil` is unpinned.** `rememberSpecial` no-ops when the global is not a table. Probe: empty Show with nil leaves it nil; assigning `{}` then Show lists the name once. Brief asked wipe to `{}`.

4. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefDecree"]`.** Reviewer probe: `_G.ChurchOfBeefDecree == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap other named-special-frame lanes named.

5. **`LINE_FONT` is re-pinned.** The B19-D / B24-D `Fonts\\MORPHEUS.ttf` source find already sat above the new empty-Show block. Harmless keep-pin.

6. **`emptyShow` is a new main-chunk local.** Runtime pins are nested; the source capture is not. Brief did not require zero new main-chunk locals.

7. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B25-B-only empty Show + pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

8. **Isolation wrap is load-only.** Eighteen pins under the first `if standalone then`. There is no end wrap after later dofiles. Brief said the wrap stays; it did.

9. **No full `lua tests/run.lua`.** Isolated **280 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **280 passed, 0 failed.** Isolation wrap: **18**.

Empty `Show()` calls `ensureFrame()` then Hide and returns false. It does not paint and does not Show the banner. Wipe `UISpecialFrames` to `{}` then Show-only lists `ChurchOfBeefDecree` exactly once without Init after. B24-D Init uniqueness stays green. Quiet stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Isolation stays stub + Common + Decree + Decree UI + Minimap. Isolated `lua tests/test_decree_ui.lua` **280 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
