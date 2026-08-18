# B8-A — Store derived CountDefenses

**Exclusive:** `addon/ChurchOfBeef/Core/Store.lua`, `tests/test_store.lua`

**Do not edit** Gora.lua, RecordsBook, HUD, FighterCard. Do not commit. Do **not** write `gora.defenses` or `defenseCount`. Existing `gora.defenses == nil` pins stay true.

## Law

OPEN_QUESTIONS #9: a defense is a victory by a sitting Beef Lord in a sanctioned Gora **after** `elevationAt`, or opponent **Cowardice Recorded** (that writes `won == true` on the non-fleer). Voids and free rulings are not defenses. Not a title-defense system. Not an increment field.

```lua
n = Store:CountDefenses(characterId)
```

- Unknown / invalid id → `0` (or nil + err; prefer `0` so UI paint is cheap).
- No linked human, or human has no `elevationAt` → `0`.
- Walk that character's `gora.results`. Count a row when `result.at >= elevationAt` and `result.won == true`.
- Do not require current `rankId == 4` (leaving Lord does not delete `elevationAt`; Law 7).
- Do not count `won == false`, `won == nil`, void, or free.
- Do not invent notable / famousUpset coupling.
- Snapshot/Restore unchanged. `gora.defenses` stays stripped on write.

## Tests

Keep every existing `gora.defenses == nil` pin. Add: Lord + two post-elevation wins → 2. Pre-elevation win → not counted. Void / free → not counted. Cowardice on the Lord (`won == true`, ruling cowardice) → counted. Unlinked character → 0. Isolation wrap stays.

`lua tests/test_store.lua` exit 0.

Report `docs/reformation/vestments/briefs/B8-A-defenses-report.md` + diff.
