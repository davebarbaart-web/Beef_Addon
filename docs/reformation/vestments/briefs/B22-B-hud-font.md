# B22-B — HUD fighter names use FrameXML Morpheus casing

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, glue. Do not commit. No `UnitHealth`. B16-C / B17-D / B19-C / B21-B gates stay. Favor W-F intact. Dress stays stock.

## Law

Bible §19.3 / license 4 stock only. Theatrical HUD names still use `GameFontHighlight`. Decree / Toasts / Records / FighterCard already use `Fonts\\MORPHEUS.ttf`.

Add `NAME_FONT = "Fonts\\MORPHEUS.ttf"`. Apply only to `nameA` / `nameB` via a pcall `SetFont` helper (size 14 or 16). Fallback `SetFontObject(GameFontHighlight)` when `SetFont` fails. Titles, records, defenses, vs, favor stay GameFont. Do not use `MORPHEUS_CYR`.

`health` stays nil. lastPair CONSEQUENCE gate stays. No drag-persist rewrite.

## Tests

Source pin for `Fonts\\MORPHEUS.ttf` on the HUD file. Refuse `MORPHEUS.TTF` and `MORPHEUS_CYR`. Existing persist / Gora-RITE / lastPair / `1-0` / health-nil pins stay. Isolation wrap stays. Nest new pins if the 200-local cap is tight.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B22-B-hud-font-report.md` + diff.
