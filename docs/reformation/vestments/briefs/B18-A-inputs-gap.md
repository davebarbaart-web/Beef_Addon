# B18-A — Inputs confess box below TitleBar + trim opponent

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** Net, Codec, Console, glue. Do not commit. WIDTH 328 HEIGHT 72 stay. TitleBar 12px + persist `ui.inputs` stay. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`. No Pope-name lookup. No `PlaySound`. Challenge law (B17-C) stays.

## Law

B16-B leftover: confess box is `TOP` / `-8` / height 22, so it eats the lower 4px of the 12px handle. Move the box to `TOP` / `-14` (fully below the 12px strip). Do not grow HEIGHT. Buttons stay `BOTTOM` + 10.

B17-C leftover: whitespace-only / padded `UnitName` still reaches `SendPetition`. Trim the target name (`^%s+` / `%s+$`) before `Names.Same`. After trim, empty → omit opponent. `"  Chuckroast  "` becomes `"Chuckroast"`.

## Tests

TitleBar height 12 stays. Confess box TOP offset is `-14` (or ≤ -12). Existing opponent pins stay. New: stub target `"   "` omits opponent; stub `"  Chuckroast  "` sends `opponent = "Chuckroast"`. Quiet / ESC / persist / isolation wrap stay.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B18-A-inputs-gap-report.md` + diff.
