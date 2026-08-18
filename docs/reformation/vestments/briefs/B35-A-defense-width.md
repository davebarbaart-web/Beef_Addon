# B35-A — HUD defense labels SetWidth(28)

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** FighterCard, Console, glue. Do not commit. No `UnitHealth`. No roman numerals. Do not SetWidth names / records / VS.

## Law

Bible §10.7 mute integer. Anniversary `SetWidth(width)` (SimpleScriptRegionResizingAPI). `defenseA` / `defenseB` are unbounded FontStrings (`makeLabel` ~575) anchored `LEFT` of `recordA` / `RIGHT` of `recordB` (~696–697). Two-digit W/L plus a two-digit count can grow into VS / seal.

Cap only the defense labels at **28**. Mint in `build()` after the two defense FontStrings exist (and/or in `paintDefense`). Existing anchors, MUTED tint, `tostring(n)` paint, Hide-when-zero stay. HUD width stays 420. No roman. No `UnitHealth`.

## Tests

Nest `runB35A()` after `runB34A()` inside `runB19C()`. Source pin: `defenseA` / `defenseB` `SetWidth(28)`. After Init and after a nonzero `CountDefenses` paint (existing 3 pin or a two-digit stub), `GetWidth() == 28`. Record / name widths stay untouched. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B35-A-defense-width-report.md` + diff.
