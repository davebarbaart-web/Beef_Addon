Spec PASS

# B19-D — Decree line uses FrameXML Morpheus casing (review)

**Quality:** Approved-with-nits

**Lane:** B19-D Decree line uses FrameXML Morpheus casing
**Brief:** `docs/reformation/vestments/briefs/B19-D-decree-font.md`
**Writer report:** `docs/reformation/vestments/briefs/B19-D-decree-font-report.md`
**Diff:** `docs/reformation/vestments/briefs/B19-D-decree-font.diff` (B19-D-only exclusive-pair packet; live `Decree.lua` also carries earlier vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Decree.lua` (`LINE_FONT`, `applyFont`, line `applyFont(..., LINE_FONT, 18)`), and `tests/test_decree_ui.lua` (new source pins after the parchment-fill asserts, then existing paint / Quiet hide / persist / `UISpecialFrames` pins and the isolation wrap); then ran `lua tests/test_decree_ui.lua` (**246 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / license 4 stock only; `LINE_FONT` `Fonts\\MORPHEUS.ttf`; `applyFont` fallback stays; no deputy; Quiet silent; no `MORPHEUS_CYR`. Isolation wow_ui_stub + Common + Decree + Decree UI + Minimap only. Did not mutate `Decree.lua` or `test_decree_ui.lua`. Did not commit. Did not edit Toasts, Records, FighterCard, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `LINE_FONT` still `Fonts\\MORPHEUS.TTF` (V-A leftover; `SetFont` fail → Huge GameFont) | **Pass. Verified.** Live assignment is `local LINE_FONT = "Fonts\\MORPHEUS.ttf"`. Only other mention is `applyFont(line, "GameFontNormalHuge", LINE_FONT, 18)`. Anniversary FrameXML GlueFonts names `Fonts\MORPHEUS.ttf`. Suite source pin finds `Fonts\\MORPHEUS.ttf` and refuses `MORPHEUS.TTF`. Reviewer spy: truthy `SetFont` on the Huge line is path `Fonts\MORPHEUS.ttf`, size 18. |
| `applyFont` fallback dropped | **Pass. Verified.** `SetFont` still `pcall`s; `used` still requires a truthy return; `SetFontObject(template)` still runs when `used` is false. Packet does not touch the helper. Suite still pins `SetFontObject`. Reviewer probe: `SetFont` nil and `SetFont` throw both fall through to `GameFontNormalHuge` when that global exists. |
| GlueFonts `MORPHEUS_CYR` used | **Pass.** Source has no `MORPHEUS_CYR`. Suite refuses it. Anniversary GlueFonts still has `Fonts\MORPHEUS_CYR.TTF` as the localization face; this lane did not take it. |
| Deputy / sound / custom media | **Pass.** `Banner.Deputy` / `PlayCue` stay nil. Source has no `PlaySound` / `PlaySoundFile` / `Media\\`. Close is the only button. Stored `deputy` is still not a view field. Suite `sounds == 0` stays. |
| Body `FRIZQT` / header / church / QuestBG / crosses changed | **Pass.** `BODY_FONT` is still `Fonts\\FRIZQT__.TTF`. `HEADER` / `CHURCH_NAME` / `QuestBG` / no `✠` stay. Reviewer spy: header / flavor / church `SetFont` paths are `FRIZQT__.TTF` (10 / 12 / 10). |
| Existing paint / Quiet hide / persist / `UISpecialFrames` pins broken | **Pass.** Those blocks are still in the suite and still pass. Isolation wrap is still the 18 load-time nils. |
| Isolated suite not exit 0 | **Pass. Verified.** 246 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`LINE_FONT` casing; five source pins). Sibling dirt in this workspace is other lanes (Toasts ESC, Records, FighterCard, glue). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Toasts / Records / FighterCard / glue; no commit | **Pass.** Named-risk check. |
| Isolation stays wow_ui_stub + Common + Decree + Decree UI + Minimap | **Pass.** Four `dofile`s unchanged. Load wrap still **18** nil-module / slash pins under `if standalone then`. |
| `LINE_FONT` is `Fonts\\MORPHEUS.ttf` (FrameXML / Toasts casing) | **Pass.** Live local and line `applyFont` call. Toasts already uses `Fonts\\MORPHEUS.ttf`. |
| `applyFont` still falls back to GameFont if `SetFont` fails | **Pass.** Named-risk check. FontString `SetFont` on anniversary returns `success` bool; the truthy check is the client contract. |
| Body `FRIZQT__.TTF` stays | **Pass.** Named-risk check. |
| Header copy, church name, QuestBG, no cross glyphs stay | **Pass.** Named-risk check. |
| No `MORPHEUS_CYR` | **Pass.** Named-risk check. |
| No deputy; Quiet silent; no custom media; no sound | **Pass.** Named-risk check. `MODE` is still `QUIET`. |
| Source pin for `Fonts\\MORPHEUS.ttf`; existing paint / Quiet hide / persist / `UISpecialFrames` pins stay | **Pass.** New pins sit immediately after the aged-fill asserts. Keep-blocks were not rewritten. |
| Isolation wrap stays | **Pass.** Wrap untouched. Reviewer probe: those keys are nil at load. |
| `lua tests/test_decree_ui.lua` exit 0 | **Pass.** **246 / 0.** |

Bible §19.3 / license 4 stock only hold on the exclusive pair. The V-A casing leftover on the Decree line is closed. Law 6 holds: no sound, no deputy, Quiet stays a parchment banner.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Records Book and FighterCard still use `Fonts\\MORPHEUS.TTF` | **On contract.** Out of exclusive pair. V-A leftover continues there. Toasts already matches FrameXML. |
| `applyFont` fallback is source-pinned, not client-proven | **On contract.** Brief asked to keep the helper, not to prove missing-face load in-game. Reviewer probe with `GameFont*` globals confirmed both fail arms. |
| No client / `/reload` smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

No INT glue is required. Decree already paints through `applyFont(line, ..., LINE_FONT, 18)`.

---

## Isolation / font / Quiet

**Isolation wrap — Pass.** Load list is still stub + Common + Core Decree + Decree UI + Minimap. No `dofile` of Store / Runtime / Net / Console / HUD / Records / Toasts / Sound / MainFrame. Standalone wrap is still 18 nils (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame `UI.Init`). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged).

**Line font — Pass.** `LINE_FONT` is `Fonts\\MORPHEUS.ttf`. It is applied only to `LineText`. Header / flavor / church stay `BODY_FONT`. `applyFont` is unchanged. No `MORPHEUS_CYR`.

**Quiet / deputy — Pass.** No `PlaySound`. No deputy chrome or view field. Header copy, church name, QuestBG, and no-cross contract stay. Suite `sounds == 0` stays.

---

## Strengths

- The change is one assignment. `applyFont`, paint, Quiet hide, persist, and `UISpecialFrames` were left alone.
- Source pins refuse the old `.TTF` and the GlueFonts CYR face, and they keep `FRIZQT__.TTF` and `SetFontObject`. Writer-reported red (**244 / 2**) matches those two new fails against a still-uppercase `LINE_FONT`.
- Toasts already uses the FrameXML path; this lane matches that face instead of inventing a third casing.
- Isolation wrap and existing keep-pins were not rewritten. No deputy, no sound, no custom media.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Records Book and FighterCard still use `Fonts\\MORPHEUS.TTF`.** Reviewer probe: `PAGE_TITLE_FONT` / `NAME_FONT` are still uppercase. Brief scoped this lane to Decree. V-A leftover continues on those theatrical surfaces.

### Nit

1. **Suite pins are source-greps.** Stub `SetFont` is a nil-returning no-op, and the suite does not install `GameFont*` globals, so `applyFont` never records a live path and never reaches `SetFontObject` during `lua tests/test_decree_ui.lua`. Reviewer spy with a truthy `SetFont` confirmed the Huge line gets `Fonts\MORPHEUS.ttf` at 18.

2. **`applyFont` fallback is unproven in the suite.** Same stub gap. Reviewer probe with `GameFontNormalHuge` present confirmed nil-return and throw both call `SetFontObject`. Brief asked to keep the helper, not to add a runtime pin.

3. **`SetFontObject` pin is any occurrence.** `labelButton` also calls `applyFont` without a path. The helper body still has the fallback the brief named.

4. **Isolation wrap is load-only.** Eighteen pins under `if standalone then` at file load. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Decree delta.** Packet is the B19-D-only casing + pins. `git diff HEAD` on the two files still includes earlier vestment batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **246 / 0** was re-run here. Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` is not walked in-game this lane.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **246 passed, 0 failed.** Isolation wrap: **18**.

Decree `LINE_FONT` is `Fonts\\MORPHEUS.ttf`. `applyFont` still falls back to GameFont when `SetFont` fails. Body `FRIZQT__.TTF` stays. No `MORPHEUS_CYR`, no deputy, Quiet stays silent. Isolation stays stub + Common + Decree + Decree UI + Minimap. Isolated `lua tests/test_decree_ui.lua` **246 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
