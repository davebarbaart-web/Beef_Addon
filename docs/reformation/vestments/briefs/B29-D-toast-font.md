# B29-D — Proclaim re-applies Morpheus on the headline

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** MainFrame.lua, Decree, glue. Do not commit. No `PlaySound` / `IG_CHARACTER_INFO_*`. No new kind names. Nest in `runB12D()`.

## Law

B22 leftover pattern: `applyHeadlineFont` runs only in `InitTheater` build. A later font reset would not re-apply.

When `Proclaim` paints a shown beat, call `applyHeadlineFont` on `theater.headline`. Hidden / refused Proclaim does not need it. `HEADLINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Fallback `GameFontNormalLarge` stays. No `MORPHEUS_CYR`. No new cue names.

## Tests

Source pin: `applyHeadlineFont` is called from `Proclaim` (not only `InitTheater`). Existing clerical copy / ESC / B26-B OnHide / B27-C shell pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B29-D-toast-font-report.md` + diff.
