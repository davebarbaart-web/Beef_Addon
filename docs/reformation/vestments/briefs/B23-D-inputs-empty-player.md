# B23-D — Empty player name omits petition opponent

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** Net, Codec, Console, glue. Do not commit. WIDTH 328 HEIGHT 72 stay. TitleBar persist stays. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`. No Pope-name lookup. No `PlaySound`. Challenge law (B17-C) and player-pcall fail-closed (B21-D) stay.

## Law

B21-D leftover: `""` and `"   "` from `UnitName("player")` are strings, so fail-closed does not run; `Names.Same` is false and the target is named as opponent.

Trim the player name (`^%s+` / `%s+$`) like the target. After trim, empty or non-string → omit opponent. pcall fail still omits. Successful `"Beefina"` + `"Chuckroast"` still names opponent. Dest-same still omits. Missing `UnitName` stays omit.

Anniversary `UnitName(unit)` exists (`classic_anniversary`, 20506). Do not invent a realm compare.

## Tests

Nest in `runB18A()` / `runB21D()`. Stub target `"Chuckroast"`, player `""` or `"   "`, dest `"Host"` → opponent omitted. Existing unpadded Chuckroast + successful player still names opponent. Isolation wrap stays.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B23-D-inputs-empty-player-report.md` + diff.
