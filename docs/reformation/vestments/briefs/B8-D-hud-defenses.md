# B8-D — HUD mute defense count

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Store, FighterCard, Records. Do not commit. No `UnitHealth`. Favor W-F intact. Stock only.

## Law

Bible §10.7 HUD includes defense count. Paint `Store:CountDefenses(id)` as a **mute integer** per fighter. Hide when 0 or method missing. Do not invent odds copy. Do not scrape health.

## Tests

Sanctioned pair + stub or real CountDefenses → integer visible. Zero hides. Health nil. Favor toggle still omits STATE-off paint. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B8-D-hud-defenses-report.md` + diff.
