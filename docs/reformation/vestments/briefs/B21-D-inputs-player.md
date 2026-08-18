# B21-D — Petition omits opponent when the player name read fails

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** Net, Codec, Console, glue. Do not commit. WIDTH 328 HEIGHT 72 stay. TitleBar 12px + persist `ui.inputs` stay. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`. No Pope-name lookup. No `PlaySound`. No `TargetUnit`. No `Gora:Petition` locally. Challenge law (B17-C) and trim (B18-A) stay.

## Law

B17-C / B18-A leftover: `petitionOpponent` only compares the player name when `pcall(UnitName, "player")` succeeds. If that read throws, a successful target name is still returned. That can name the local player as opponent.

If the player pcall fails **or** `playerName` is not a string, omit opponent (fail-closed). Target still trimmed. Dest-same and player-same still omit. Missing `UnitName` stays omit.

Anniversary `UnitName(unit)` exists (`classic_anniversary`, 20506) and returns `unitName, unitServer`. Do not invent a realm compare. Do not look up `Data/Popes.lua`.

## Tests

Nest in `runB18A()` (or `runB21D()` inside it). Stub `UnitName("target")` → `"Chuckroast"`, `UnitName("player")` throws, `inputTarget` `"Host"` → `fields.opponent` omitted. Existing unpadded Chuckroast + successful player read still names opponent. Quiet / ESC / TitleBar / isolation wrap stay.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B21-D-inputs-player-report.md` + diff.
