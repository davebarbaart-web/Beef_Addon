# B17-C — Inputs Petition may name the current target

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** Net, Codec, Console, glue. Do not commit. WIDTH 328 HEIGHT 72 stay. TitleBar drag / persist `ui.inputs` stay. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`. No Pope-name lookup. No `PlaySound`. No `Gora:Petition` locally.

## Law

Bible §10.2 / §18.5. Whisper dest is still `inputTarget` (injected). The desired opponent is the current WoW target when that name is **not** the whisper dest and **not** the local player.

`Inputs:Petition`:

- Ready-to-send unchanged (Event, target, local character id).
- `pcall(UnitName, "target")`. If the name is a non-empty string and `COB.Names.Same` is false vs `inputTarget` and false vs `pcall(UnitName, "player")`, pass `opponent = name` in the `SendPetition` fields table.
- Otherwise send `{ characterId = localCharacterId }` only (existing pins stay green — stub `UnitName("target")` is nil today).
- Do not look up `Data/Popes.lua`. Do not TargetUnit. Do not SendChatMessage.

Anniversary `UnitName(unit)` exists (`classic_anniversary`, 20506). Missing `UnitName` stays fail-closed (omit opponent).

## Tests

Existing Petition spies stay `fields.opponent == nil` (or absent) when target is unset. New block: stub `UnitName("target")` → `"Chuckroast"`, inputTarget `"Host"`, player `"Beefina"` → `SendPetition` fields include `opponent = "Chuckroast"` and `target = "Host"`. Target names-same Host → omit opponent. Target names-same player → omit opponent. Quiet / TitleBar / ESC / isolation wrap stay.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B17-C-inputs-challenge-report.md` + diff.
