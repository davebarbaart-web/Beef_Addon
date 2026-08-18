# B10-C — Fighter card persists through the verdict

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Hud, Gora. Do not commit. Keep `1-0`. No `UnitHealth`. No flavor.

## Law

Same persist rule as the HUD (Bible §10.7 composition): remember the last sanctioned pair; stay painted after `GetSanctioned()` is nil while Runtime is not QUIET. Also accept Runtime `subjects.fighters` when Gora has no live pair (congregation). Hide on QUIET / Hide() / EndEvent.

Flip the pin “card hides when the pair clears.”

## Tests

DeclareVictor mid-event → card still shown. QUIET / Hide → hidden. Runtime-subjects-only pair shows. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B10-C-card-persist-report.md` + diff.
