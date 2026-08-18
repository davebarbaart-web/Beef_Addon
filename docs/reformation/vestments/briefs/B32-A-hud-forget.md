# B32-A — Non-Gora hide forgets lastPair

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** FighterCard, glue. Do not commit. No `UnitHealth`. No roman numerals. Defense integers stay arabic mute. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

B19-C / B21-B hide lastPair through Knighting RITE and CONSEQUENCE but do not `forgetPersist`. `Runtime:Continue` after Knighting is ASSEMBLY with `riteType` nil, so `displayPair` (~299) returns lastPair and the Gora HUD comes back. Bible §10.7: the HUD exits with that Gora consequence.

When `displayPair` refuses lastPair because state is RITE or CONSEQUENCE and `riteType ~= "Gora"`, call `forgetPersist()` then return nil. Gora CONSEQUENCE / ASSEMBLY Continue persist stay (riteType is Gora, or state is ASSEMBLY without a prior forget). QUIET still forgets in `Refresh`. No live health. No sound.

## Tests

Nest `runB32A()` after `runB21B()` inside `runB19C()`. After the B21-B Knighting CONSEQUENCE hide, `Continue` + `Refresh`: `shown == false`, names `""`. Gora Continue persist pin stays. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B32-A-hud-forget-report.md` + diff.
