# B19-C — lastPair does not paint through a non-Gora RITE

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, glue. Do not commit. No `UnitHealth`. B16-C pickPair and B17-D livePair Gora-RITE gates stay. Favor W-F intact. Dress stays stock.

## Law

Bible §10.7: HUD persists through a **Gora** verdict. B9-E lastPair until QUIET still applies to ASSEMBLY / CONSEQUENCE. B17-D leftover: after a Gora, `lastPair` still paints during a later Knighting RITE.

`displayPair`: if `lastPair` would be used and Runtime snapshot is `RITE` with a `riteType` that is not `"Gora"`, return nil (do not paint). Keep:

- live `GetSanctioned` still shows during Knighting (existing pin)
- lastPair after Continue (ASSEMBLY, no riteType) still paints
- lastPair during Gora CONSEQUENCE still paints
- QUIET still hides

`health` stays nil.

## Tests

After `reset()`: OpenRite Gora with two fighters, Refresh (remember lastPair), OpenRite Knighting with a candidate (no Sanction) → Refresh `shown == false` (or not those leftover Gora names). Existing Sanction-during-Knighting pin stays shown. Continue persist pin stays. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B19-C-hud-rite-report.md` + diff.
