# B34-A — HUD re-tints names after applyNameFont

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** FighterCard, Console, glue. Do not commit. No `UnitHealth`. No roman numerals. No defense `SetWidth`.

## Law

Law 10 / §19.3: fighter names carry class color. `paintFighter` tints `nameA` / `nameB` (`tint` → `SetTextColor` + `_cobColor`). `paintShown` then calls `applyNameFont`. Wiki `FontInstance:SetTextColor(r,g,b)`; `SetFontObject` applies the font object's color (`GameFontHighlight` is white). Harness `SetFont` / `SetFontObject` are often no-ops, so `_cobColor` can look fine while live Anniversary wipes the class tint.

After `applyNameFont(frame.nameA)` / `nameB` in `paintShown`, restore tint from `fighterA.nameColor or INK` and `fighterB.nameColor or INK` (same `tint` helper). Keep `NAME_FONT` / `GameFontHighlight` fallback. `build()` mint apply stays before fighters exist — do not invent a mint tint. Hidden paint stays empty.

## Tests

Nest after `runB32A()` inside `runB19C()`. Source pin: `paintShown` body still calls `applyNameFont` and then `tint` (or `SetTextColor`) on `nameA` / `nameB` after the font apply. Wrap `nameA`/`nameB` `SetFontObject` (and `SetFont` if you want) to wipe `_cobColor` / `SetTextColor(1,1,1)`, then Refresh a live Gora pair; `_cobColor` / view `nameColor` must return to Warrior / Mage. Existing class-color pins stay. Isolation wrap stays. No `UnitHealth`.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B34-A-hud-tint-report.md` + diff.
