# B8-C — Fighter card mute defense count

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Store, HUD, Records. Do not commit. Card stays mute. Keep `1-0`. No `UnitHealth`. No generated flavor.

## Law

Bible §10.6 tale of the tape includes defenses. Paint `Store:CountDefenses(id)` as a **mute integer** on each plate. Hide the line when the count is 0 or the method is missing. Do not write copy like "defenses of the realm." Stock GameFont. Honorific line stays. Keep H2H as `1-0`.

## Tests

Seed a linked Lord + post-elevation win (or stub `CountDefenses`) → plate shows the integer. Zero hides. Isolation wrap stays. Health stays nil.

`lua tests/test_fighter_card.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B8-C-card-defenses-report.md` + diff.
