Spec PASS

# B24-D — Decree ensureFrame re-registers ESC (review)

**Quality:** Approved-with-nits

**Lane:** B24-D Decree ensureFrame re-registers ESC
**Brief:** `docs/reformation/vestments/briefs/B24-D-decree-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B24-D-decree-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B24-D-decree-special.diff` (B24-D-only exclusive-pair packet; live `Decree.lua` / `test_decree_ui.lua` also carry earlier Decree vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`ensureFrame` after `if DecreeBanner.frame then`: `rememberSpecial(FRAME_NAME)` then `return DecreeBanner.frame`; create-path `buildFrame` still registers once), and `tests/test_decree_ui.lua` (early-return source pins, existing first-create ESC membership pin, nested `runB24D()` wipe remount + third-Init uniqueness + Show-miss then Init, existing Quiet hide / persist / Morpheus pins, isolation wrap); then ran `lua tests/test_decree_ui.lua` (**265 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named `ChurchOfBeefDecree`; do not PlaySound `IG_CHARACTER_INFO_*`); B24-C leftover / B23-C leftover shape (`ensureFrame` returned the existing banner and skipped `rememberSpecial`; a wiped list never got the Decree name back); `ensureFrame` early-return `rememberSpecial`; no rebuild; no `PlaySound`; Quiet silent; `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`; header copy / QuestBG stay; Law 6 / §19.4; Law 10 / Bible §19.3. Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `ensureFrame` early-return still skips `rememberSpecial` (B24-C leftover) | **Pass. Verified.** Live early-return is `rememberSpecial(FRAME_NAME)` then `return DecreeBanner.frame`. Pins: wipe `UISpecialFrames` to `{}`, second Init lists `ChurchOfBeefDecree` once. Reviewer probe: wipe leaves count 0; second Init returns the same pointer and count is 1; wrapped `CreateFrame` saw **0** new calls on that remount. `ResetForTests` nils `self.frame`, so a later Init hits `buildFrame` again and still lists the name once. |
| Early-return rebuilds the banner | **Pass. Verified.** Early-return body has no `buildFrame` / `CreateFrame`. Pins: second Init returns `Banner.frame` and the first-create `frame`. Reviewer spy: CreateFrame count unchanged across wipe+Init, third Init, and Show-with-decree remount. Header copy / QuestBG / `LINE_FONT` stay on the same widget. |
| Wipe remount duplicates `ChurchOfBeefDecree` | **Pass. Verified.** `rememberSpecial` still dedupes. Pins: once before wipe; once after wipe+Init; third Init still once. Reviewer probe: fourth Init stays 1; Show with a live Decree after a wipe lists once. |
| `PlaySound` / Quiet no longer silent / `LINE_FONT` flipped | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. `MODE` is still `"QUIET"`. `LINE_FONT` is still `Fonts\\MORPHEUS.ttf` (only other use: `applyFont(line, "GameFontNormalHuge", LINE_FONT, 18)`). Source pins refuse `PlaySound` on the early-return and on the whole file; Morpheus / `MORPHEUS.TTF` / `MORPHEUS_CYR` keep-pins stay. Suite `#sounds` is 0 at the end. Reviewer spy: remounts leave the PlaySound counter at 0. |
| Isolated suite not exit 0 / pins not nested | **Pass. Verified.** 265 passed, 0 failed. Writer-reported count matches. Runtime locals live in `runB24D()`. Isolation wrap stays under the load-time standalone block. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (early-return `rememberSpecial` + return; source pins + nested `runB24D()`). Sibling dirt in this workspace is other lanes (Toasts, Records, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts, Records, glue; no commit; no deputy; no custom media | **Pass.** Named-risk check. Source has no `Deputy` / `Media\\`. `Banner.Deputy` pin stays nil. |
| `ensureFrame` early-return calls `rememberSpecial(FRAME_NAME)` then returns the existing banner | **Pass.** Live order. Source pin captures the early-return body. Reviewer capture is exactly that call then return. |
| Do not rebuild; do not PlaySound; header copy / QuestBG stay | **Pass.** Named-risk check. `HEADER` is still `A GATHERING HAS BEEN DECREED`. `PARCHMENT_TEXTURE` is still `Interface\\QuestFrame\\QuestBG`. |
| Init / Show so the frame exists, wipe `UISpecialFrames` to `{}`, `ensureFrame` path (second Init or Show): name listed exactly once | **Pass.** Named-risk check. Lane closed second Init. Third Init is an extra keep-pin. Reviewer probe: Show with a live Decree after a wipe also remounts once (unpinned; still `ensureFrame`). |
| Existing Quiet hide / persist / Morpheus pins stay | **Pass.** Close / same-session Init / `Hide` / already-seen-is-not-SV (`decreeSeen` / `alreadySeen` / `shownThisSession`) blocks were not rewritten. `Fonts\\MORPHEUS.ttf` / refuse uppercase TTF / refuse `MORPHEUS_CYR` stay; B24-D re-pins the same path. |
| Isolation wrap stays; `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **265 / 0.** |

B24-C leftover (wiped `UISpecialFrames` never got `ChurchOfBeefDecree` back) is closed on the early-return path. Law 6 (Quiet silent), Law 10 (theatrical parchment; header / QuestBG / Morpheus stay), and no `PlaySound` hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` order is unproven on Anniversary | **Not a miss.** Brief asked isolated green + early-return `rememberSpecial` + uniqueness once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked membership counts. The client's special-frame walk is not. |
| `Show()` with no active Decree still returns before `ensureFrame`. A wipe then Show-only (empty Get) does not put the name back until Init or a Show that paints | **On contract / leftover.** Brief allowed second Init or Show. This lane closed Init. Probe: Show miss after wipe leaves count 0 and the same pointer; the following Init lists the name once. Show with a live Decree after wipe remounts through `ensureFrame` (count 1, no rebuild). |

---

## Isolation / early-return / uniqueness

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Decree + Decree UI + Minimap. No `dofile` of Toasts / Records / Console / glue / DB / Store / Runtime / Net. Standalone wrap is still **18** nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). New runtime locals sit in `runB24D()` so Lua 5.1's 200-local cap does not fire.

**Early-return — Pass.** `if DecreeBanner.frame then` → `rememberSpecial(FRAME_NAME)` then returns the existing frame. It does not `buildFrame`, does not `CreateFrame`, and does not `PlaySound`. Create-path `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once after `restorePoint`. `rememberSpecial` still type-guards a missing table and returns when the name is already listed.

**Uniqueness — Pass.** Wipe-to-empty then Init lists the name once. Third Init stays once. First-create membership pin stays above the nest. Reviewer probe: Show-with-decree after a wipe lists once; `UISpecialFrames = nil` then Init leaves the global nil; assigning `{}` then Init lists once.

---

## Strengths

- The delta is the brief: one early-return `rememberSpecial(FRAME_NAME)` before `return DecreeBanner.frame`. Create-path register, Quiet hide / persist, header / QuestBG, and `LINE_FONT` were left alone.
- Wipe-to-`{}` then second Init is the leftover close, not only a source `find`. First-create ESC membership and Morpheus keep-pins were left in place. Reviewer remount still returns the same pointer and plays no sound.
- Isolation stayed gated. Runtime pins are inside `runB24D()`. Writer-reported **265 / 0** matched the re-run. Writer-reported red (**261 / 4**) matches the four asserts old `if DecreeBanner.frame then return DecreeBanner.frame end` would fail: early-return `rememberSpecial` string; wiped + second Init lists once; third Init lists once; wiped + Init after Show miss lists once.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Show()` with no active Decree still returns before `ensureFrame`.** Reviewer probe: wipe, Show miss, count stays 0. Brief allowed second Init or Show; Init remounts. A Show that paints (live Get) does remount. Hidden unused banner after a hypothetical list wipe is not an ESC surface until the next Init or painting Show.

2. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. Brief asked early-return `rememberSpecial` + uniqueness once, not a client walk. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

### Nit

1. **`UISpecialFrames = nil` is unpinned.** `rememberSpecial` no-ops when the global is not a table. Probe: Init with nil leaves it nil; assigning `{}` then Init lists the name once. Brief asked wipe to `{}`.

2. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefDecree"]`.** Reviewer probe: `_G.ChurchOfBeefDecree == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap other named-special-frame lanes named.

3. **`LINE_FONT` is re-pinned.** The B19-D `Fonts\\MORPHEUS.ttf` source find already sat above the new early-return block. Harmless keep-pin.

4. **`earlyEnsure` is a new main-chunk local.** Runtime pins are nested; the source capture is not. Brief did not require zero new main-chunk locals.

5. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B24-D-only early-return + pins. `git diff HEAD` on the two files still includes earlier Decree vestment batches. Report already says this.

6. **Isolation wrap is load-only.** Eighteen pins under the first `if standalone then`. There is no end wrap after later dofiles. Brief said the wrap stays; it did.

7. **No full `lua tests/run.lua`.** Isolated **265 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **265 passed, 0 failed.** Isolation wrap: **18**.

`ensureFrame` early-return calls `rememberSpecial(FRAME_NAME)` then returns the existing banner. It does not rebuild and does not `PlaySound`. Wipe `UISpecialFrames` to `{}` then second Init lists `ChurchOfBeefDecree` exactly once. Quiet stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay. Isolation stays stub + Common + Decree + Decree UI + Minimap. Isolated `lua tests/test_decree_ui.lua` **265 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
