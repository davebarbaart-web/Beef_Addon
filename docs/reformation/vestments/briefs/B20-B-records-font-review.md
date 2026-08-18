Spec PASS

# B20-B — Records title uses FrameXML Morpheus casing (review)

**Quality:** Approved-with-nits

**Lane:** B20-B Records title uses FrameXML Morpheus casing
**Brief:** `docs/reformation/vestments/briefs/B20-B-records-font.md`
**Writer report:** `docs/reformation/vestments/briefs/B20-B-records-font-report.md`
**Diff:** `docs/reformation/vestments/briefs/B20-B-records-font.diff` (B20-B-only exclusive-pair packet; live `RecordsBook.lua` also carries earlier vestment batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`PAGE_TITLE_FONT`, `FALLBACK_TITLE_FONT`, `PAGE_TITLES`, `applyFont`, title / page-title `applyFont(..., PAGE_TITLE_FONT, 20|18)`), and `tests/test_records.lua` (new source pins after the stock-font asserts, then existing page / identity / wheel pins and the isolation wrap); then ran `lua tests/test_records.lua` (**425 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / license 4 stock only; `PAGE_TITLE_FONT` `Fonts\\MORPHEUS.ttf`; `applyFont` fallback stays; PAGE_TITLES stay 9; no category remap (#3); no `MORPHEUS_CYR`. Isolation wow_ui_stub + Common + Ranks + Store + RecordsBook only. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit Decree, Toasts, FighterCard, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `PAGE_TITLE_FONT` still `Fonts\\MORPHEUS.TTF` (V-A leftover; `SetFont` fail → Huge / Large GameFont) | **Pass. Verified.** Live assignment is `local PAGE_TITLE_FONT = "Fonts\\MORPHEUS.ttf"`. Applied only on `TitleText` (`GameFontNormalHuge`, 20) and `PageTitle` (`GameFontNormalLarge`, 18). Anniversary FrameXML / Decree / Toasts name `Fonts\MORPHEUS.ttf`. Suite source pin finds `Fonts\\MORPHEUS.ttf` and refuses `MORPHEUS.TTF`. Reviewer spy: truthy `SetFont` on those two strings is path `Fonts\MORPHEUS.ttf`, sizes 20 / 18. Body / honorifics / moments stay path-less GameFont. |
| `applyFont` fallback dropped | **Pass. Verified.** `SetFont` still `pcall`s the title face; `used` still requires a truthy return; FRIZQT still runs when `path ~= FALLBACK_TITLE_FONT`; `SetFontObject(template)` still runs when `used` is false. Packet does not touch the helper. Suite still pins `FRIZQT__.TTF` and `SetFontObject`. Reviewer probe: nil-return and always-throw both fall through to `GameFontNormalHuge` when that global exists; first-call throw then succeeds on `Fonts\FRIZQT__.TTF`. |
| GlueFonts `MORPHEUS_CYR` used | **Pass.** Source has no `MORPHEUS_CYR`. Suite refuses it. Anniversary GlueFonts still has `Fonts\MORPHEUS_CYR.TTF` as the localization face; this lane did not take it. |
| `PAGE_TITLES` remapped or no longer 9 | **Pass.** Live table is still the nine Bible names in Bible order. `GetPages()` is 9; first is Most Sanctioned Victories, last is Tournament Champions. Ribbons still jump to existing titles (Victories / Rivalries / Martyrs). Identity / scripture leaves stay off the tenth-page hole. OPEN_QUESTIONS #3 is untouched. |
| Roman tallies / wheel pins broken | **Pass.** `toRoman(14)` is still `XIV`. Wheel / chrome-wheel / `EnableMouseWheel` keep-blocks are still in the suite and still pass. |
| Isolated suite not exit 0 | **Pass. Verified.** 425 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two hunks (`PAGE_TITLE_FONT` casing; five source pins). Sibling dirt in this workspace is other lanes (Decree, Toasts, FighterCard, glue, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Decree / Toasts / FighterCard / glue; no commit | **Pass.** Named-risk check. |
| Isolation stays wow_ui_stub + Common + Ranks + Store + RecordsBook | **Pass.** Four `dofile`s unchanged. Load wrap still **11** nil-module pins under `if standalone then`. |
| `PAGE_TITLE_FONT` is `Fonts\\MORPHEUS.ttf` (FrameXML / Decree / Toasts casing) | **Pass.** Live local and both title `applyFont` calls. Decree `LINE_FONT` and Toasts `HEADLINE_FONT` already use `Fonts\\MORPHEUS.ttf`. |
| `applyFont` fallback stays (title face, then FRIZQT, then GameFont) | **Pass.** Named-risk check. FontString `SetFont` on anniversary returns `success` bool; the truthy check is the client contract. |
| Fallback face stays `FRIZQT__.TTF` | **Pass.** `applyFont` upvalue is `Fonts\\FRIZQT__.TTF`. Suite pins the face. |
| `PAGE_TITLES` stay 9; no category remap (#3) | **Pass.** Named-risk check. |
| Roman tallies stay; wheel pins stay | **Pass.** Named-risk check. |
| No `MORPHEUS_CYR` | **Pass.** Named-risk check. |
| Source pin for `Fonts\\MORPHEUS.ttf`; existing page / identity / wheel pins stay | **Pass.** New pins sit immediately after the stock-font asserts. Keep-blocks were not rewritten. |
| Isolation wrap stays | **Pass.** Wrap untouched. Reviewer probe: those keys are nil at load. |
| `lua tests/test_records.lua` exit 0 | **Pass.** **425 / 0.** |

Bible §19.3 / license 4 stock only hold on the exclusive pair. The V-A casing leftover on the Records title face is closed. Law 10 holds: the tome stays theatrical parchment, stock Morpheus, no custom media. OPEN_QUESTIONS #3 is not answered here.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| FighterCard still uses `Fonts\\MORPHEUS.TTF` | **On contract.** Out of exclusive pair. At review time live `NAME_FONT` is already `Fonts\\MORPHEUS.ttf` (sibling B20-C dirt). V-A leftover is not this lane's hole. |
| `applyFont` fallback is source-pinned, not client-proven | **On contract.** Brief asked to keep the helper, not to prove missing-face load in-game. Reviewer probe with `GameFont*` globals confirmed both fail arms and the FRIZQT middle arm. |
| No client / `/reload` smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

No INT glue is required. Records already paints titles through `applyFont(..., PAGE_TITLE_FONT, 20|18)`.

---

## Isolation / font / titles

**Isolation wrap — Pass.** Load list is still stub + Common + Ranks + Store + RecordsBook. No `dofile` of Runtime / Gora / Net / Console / HUD / Decree / Toasts / Sound / MainFrame. Standalone wrap is still 11 nils (Runtime, Gora, Officer, MainFrame, BeefNet, DB, Sender, Minimap, Toasts, Console, Hud). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged).

**Title font — Pass.** `PAGE_TITLE_FONT` is `Fonts\\MORPHEUS.ttf`. It is applied only to the chrome title and the leaf title. Body / honorifics / moments / ribbon labels stay GameFont without that path. `applyFont` is unchanged. Fallback face stays `FRIZQT__.TTF`. No `MORPHEUS_CYR`.

**PAGE_TITLES / Roman / wheel — Pass.** Nine Bible names, Bible order. No tenth page. `toRoman` still paints XIV / IV / IX. Wheel keep-pins stay. Quiet stays silent (`MODE` is still `QUIET`; suite `sounds == 0` stays).

---

## Strengths

- The change is one assignment. `applyFont`, `PAGE_TITLES`, Roman tallies, wheel wiring, and identity leaves were left alone.
- Source pins refuse the old `.TTF` and the GlueFonts CYR face, and they keep `FRIZQT__.TTF` and `SetFontObject`. Writer-reported red (**423 / 2**) matches those two new fails against a still-uppercase `PAGE_TITLE_FONT`.
- Decree and Toasts already use the FrameXML path; this lane matches that face instead of inventing a third casing.
- Isolation wrap and existing page / identity / wheel pins were not rewritten. No custom media, no generated prose, no category remap.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None. The V-A uppercase leftover on this surface is closed. Sibling theatrical faces are out of pair.

### Nit

1. **Suite pins are source-greps.** Stub `SetFont` is a nil-returning no-op, and the suite does not install `GameFont*` globals, so `applyFont` never records a live path and never reaches a proven `SetFontObject` during `lua tests/test_records.lua`. Reviewer spy with a truthy `SetFont` confirmed the Huge title gets `Fonts\MORPHEUS.ttf` at 20 and the Large page title at 18.

2. **`applyFont` fallback is unproven in the suite.** Same stub gap. Reviewer probe with `GameFontNormalHuge` present confirmed nil-return and throw both call `SetFontObject`, and a first-call throw then succeeds on `FRIZQT__.TTF`. Brief asked to keep the helper, not to add a runtime pin.

3. **`SetFontObject` pin is any occurrence.** `labelButton` also calls `applyFont` without a path. The helper body still has the fallback the brief named.

4. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Records delta.** Packet is the B20-B-only casing + pins. `git diff HEAD` on the two files still includes earlier vestment batches (stock QuestBG, FRIZQT middle arm, Roman, wheel). Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **425 / 0** was re-run here. Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` is not walked in-game this lane.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **425 passed, 0 failed.** Isolation wrap: **11**.

Records `PAGE_TITLE_FONT` is `Fonts\\MORPHEUS.ttf`. `applyFont` still falls back to FRIZQT then GameFont when `SetFont` fails. `PAGE_TITLES` stay 9. No category remap. No `MORPHEUS_CYR`. Isolation stays stub + Common + Ranks + Store + RecordsBook. Isolated `lua tests/test_records.lua` **425 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
