# B16-C — Congregation picks only during Gora RITE

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** Gora, glue. Do not commit. No `UnitHealth`. No lastPair clicks (B11-B). Favor still W-F. Dress stays stock.

## Law

Congregation `pickPair` today accepts any RITE with Runtime fighters. A Knighting RITE that somehow carries leftover fighters would SendFavor. Require `snap.riteType == "Gora"` in addition to `state == "RITE"`. Pope path unchanged: live `GetSanctioned()` only.

Existing congregation RITE pick pins use `OpenRite("Gora", …)` — they must stay green. Add a Knighting RITE + two Runtime fighters pin: plate click does **not** SendFavor.

## Tests

Keep B11-B leftover-ruling Pope pins. Congregation Gora RITE still sends. Knighting RITE + fighters + SetFavorTarget + local id: `OnClick` sends 0. Isolation wrap stays. `health` nil.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B16-C-hud-gora-report.md` + diff.
