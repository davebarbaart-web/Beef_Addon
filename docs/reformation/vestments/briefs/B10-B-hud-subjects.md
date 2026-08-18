# B10-B — HUD reads Runtime subjects (congregation)

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, glue, FighterCard. Do not commit. No `UnitHealth`. Favor W-F intact.

## Law

Congregation clients never call `Gora:Sanction`. The star pair arrives as STATE `subjects.fighters`. Bible §10.7 still wants the HUD.

`livePair` / `displayPair`: if `GetSanctioned()` is nil, and Runtime snapshot has `subjects.fighters` with two ids, use that pair. Remember it as lastPair. Hide when QUIET. Persist lastPair when both Gora and Runtime fighters are empty but the event is still live (B9-E).

Do not invent a pair. Health nil.

## Tests

No Gora sanction. Runtime StartEvent + OpenRite("Gora", { fighters = { a.id, b.id } }) → HUD shown with those ids. QUIET hides. Existing persist-after-DeclareVictor pins stay. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B10-B-hud-subjects-report.md` + diff.
