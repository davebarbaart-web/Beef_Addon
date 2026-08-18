# B5-D — Theater toast display face (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3; Law 10; Batch 4 critique (one display face); V-stock FrameXML `Fonts\MORPHEUS.ttf`; brief `docs/reformation/vestments/briefs/B5-D-toast-face.md`. CONTINUE 2026-08-18 license 4 (stock only). B3-A clerical / Quiet / Sound:Play pins kept.

Event Mode Proclaim overlays use one stock display face on the **headline** FontString: `pcall` `SetFont` `Fonts\MORPHEUS.ttf` (FrameXML lowercase). Fallback remains `GameFontNormalLarge`. Body stays `GameFontNormal`. Clerical copy is unchanged. Quiet still refuses. Dim 0.45. No close button. No new cue names. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | `theaterCopy()` concatenates headline + body so B3-A exact pins stay. Headline / body split pins on sanction, cowardice, victor, knighting, elevation. Source-pin `MORPHEUS` + soft-pin `MORPHEUS.ttf`. System toast stays `GameFontNormal`. Isolation wrap stays. Sound:Play name pins kept. Quiet refuse kept. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | `theater.headline` FontString. `applyHeadlineFont` `pcall` `SetFont` `Fonts\MORPHEUS.ttf` size 18; `GameFontNormalLarge` fallback. First clerical line on the headline; remainder on `copy` (`GameFontNormal`). Single-line beats hide the empty body. |
| `docs/reformation/vestments/briefs/B5-D-toast-face-report.md` | This file |
| `docs/reformation/vestments/briefs/B5-D-toast-face.diff` | B5-D-only unified diff of the exclusive files |

Did not edit Sound.lua, Console, Hud, Decree, Records, FighterCard, Core, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not invent a cue name. Did not `SendChatMessage`. Did not commit.

## Contract

### Display face

| Surface | Face |
|---------|------|
| Proclaim **headline** | `GameFontNormalLarge` template; `pcall` `SetFont` `Fonts\MORPHEUS.ttf` (18). Fallback `SetFontObject(GameFontNormalLarge)` if `SetFont` is missing or returns false. |
| Proclaim **body** | `GameFontNormal`. No `SetFont`. |
| System / debug toast | `GameFontNormal` unchanged. |

`clericalCopy` strings are unchanged. Paint splits on the first newline:

| Kind | Headline | Body |
|------|----------|------|
| `sanction` | `A Beef Gora is Sanctioned` | names / VS / stipulation |
| `knighting` | `RISE, BEEF KNIGHT` | name |
| `elevation` | `RISE, BEEF LORD` | name |
| `cowardice` / `verdict` | the full clerical sentence | empty (hidden) |

Quiet / missing Runtime still return `false, "quiet"` and do not show. Dim **0.45** (≤ 0.5). No close button. Cue remains `Sound:Play(kind)` when Sound exists.

## TDD

1. Extended `test_ui.lua` first (headline FontString, FrameXML path source-pin, split pins, `theaterCopy()` join so B3-A exact strings stay green). Isolation wrap untouched.
2. Implemented `Toasts.lua` headline + `applyHeadlineFont` + `splitHeadline`.
3. Green: `lua tests/test_ui.lua` — **321 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 321 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **321 passed, 0 failed.** Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**321 passed, 0 failed.**

## Self-review

- Exclusive files only. Quiet refuses. B3-A kind pins and Sound:Play **name** pins stay.
- Isolation asserts stay under `if standalone then`.
- Source has no `SendChatMessage(`, `COB.Console`, `COB.Gora`, `COB.Knighting`, or generated oratory.
- Stock path is FrameXML lowercase `.ttf` (not the `.TTF` form B4-E used). No `Media\`. Flags omitted on `SetFont`.
- System / debug `Push` still `GameFontNormal`.

## Concerns

- **No client smoke.** Stock Morpheus at height 18 is unsmoked on 20506. Missing font falls back to `GameFontNormalLarge` (`pcall`; truthy `SetFont` return required). License 4 / brief require stock paths. **POLISH:CANDIDATE** only.
- **Harness `SetFont` is a no-op.** `wow_ui_stub` ignores `SetFont` / `GetFont`. Headlines keep the `GameFontNormalLarge` template in the suite. Soft `GetFont` pin does not fail. Real client path is unproven.
- **Stock Morpheus is not the Batch 4 custom blackletter.** License 4 forbids shipping a font file. One stock face is the brief; the render-derived OFL face is a later licensed step.
- **Single-line verdicts / cowardice** put the whole clerical sentence on the headline (no body). That matches “headlines only” without rewriting copy.
- Integrator still lists the files in the TOC and `run.lua`. Console / Knighting still do not call Proclaim.

## Status

**DONE_WITH_CONCERNS.** Isolated **321 / 0**. Not signed. **POLISH:CANDIDATE.**
