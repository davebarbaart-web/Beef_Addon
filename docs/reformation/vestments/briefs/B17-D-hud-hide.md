# B17-D — HUD does not paint leftover fighters during a non-Gora RITE

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, glue. Do not commit. No `UnitHealth`. No lastPair clicks (B11-B). Congregation pickPair Gora-RITE gate stays (B16-C). Favor still W-F. Dress stays stock.

## Law

Bible §10.7: HUD persists through a **Gora** verdict via `lastPair`. B16-C gated **sends** only. `livePair()` still returns ungated `runtimePair()`, so a Knighting RITE that carries leftover `subjects.fighters` still **paints** the fight HUD.

Gate the `runtimePair()` arm of `livePair()` the same way as congregation `pickPair`: `state == "RITE"` **and** `riteType == "Gora"`. `goraPair()` (live `GetSanctioned`) stays first — a sanctioned pair still shows during Knighting (existing pin). `displayPair` still falls through to `lastPair` when live is nil (Continue persist until QUIET).

## Tests

Keep: sanctioned pair still shown after `OpenRite("Knighting")`; lastPair persist after Continue; B16-C send-0 on Knighting leftover plates.

Add after `reset()` (so lastPair is empty): `OpenRite("Knighting", { candidate, fighters = { id, id } })` with no Sanction → `Hud:Refresh()` `shown == false` (or hidden). Do not paint those leftover fighter ids. `health` nil.

Isolation wrap stays.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B17-D-hud-hide-report.md` + diff.
