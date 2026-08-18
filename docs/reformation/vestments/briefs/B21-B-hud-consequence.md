# B21-B — lastPair does not paint through a non-Gora CONSEQUENCE

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, glue. Do not commit. No `UnitHealth`. B16-C pickPair, B17-D livePair, and B19-C RITE lastPair gates stay. Favor W-F intact. Dress stays stock.

## Law

Bible §10.7: HUD persists through a **Gora** verdict. B19-C leftover: after a Gora lastPair, a later Knighting RITE hides, but Knighting **CONSEQUENCE** (`riteType ~= "Gora"`) can still paint lastPair.

`displayPair`: if `lastPair` would be used and Runtime snapshot is `RITE` **or** `CONSEQUENCE` with `riteType` that is not `"Gora"`, return nil. Keep:

- live `GetSanctioned` still shows during Knighting (existing pin)
- lastPair during Gora CONSEQUENCE still paints
- lastPair after Continue (ASSEMBLY, no riteType) still paints
- B19-C Knighting RITE hide stays
- QUIET still hides

`health` stays nil. No `UnitIsDead`.

## Tests

Nest `runB21B()` (Lua 5.1 200-local; do not add main-chunk locals). After the B19-C Knighting hide: `CloseRite` → CONSEQUENCE / Knighting → Refresh `shown == false` (leftover Gora names stay unpainted). Gora CONSEQUENCE / ASSEMBLY persist pins stay. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B21-B-hud-consequence-report.md` + diff.
