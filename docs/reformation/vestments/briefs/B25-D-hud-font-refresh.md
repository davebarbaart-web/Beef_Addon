# B25-D — HUD re-applies Morpheus on Refresh

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, glue. Do not commit. No `UnitHealth`. B16-C / B17-D / B19-C / B21-B gates stay. Favor W-F intact. Dress stays stock.

## Law

B22-B leftover: `applyNameFont` runs only in `build()`. A later font reset would not re-apply.

When `Refresh` paints a shown pair, call `applyNameFont` on `nameA` and `nameB`. Hidden Refresh does not need it. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Fallback `GameFontHighlight` stays. No `MORPHEUS_CYR`. `health` stays nil.

## Tests

Source pin: `applyNameFont` is called from `Refresh` / `paintShown` (not only `build`). Existing persist / lastPair / `1-0` / health-nil / Morpheus path pins stay. Isolation wrap stays. Nest if the 200-local cap is tight.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B25-D-hud-font-refresh-report.md` + diff.
