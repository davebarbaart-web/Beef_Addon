# B7-A — Store Canonize + Famous Upset flag

**Exclusive:** `addon/ChurchOfBeef/Core/Store.lua`, `tests/test_store.lua`

**Do not edit** Gora.lua (Famous Upsets stay not computed there), Console, Archive.lua, RecordsBook. Do not commit. No generated scripture. Law 7: never delete moments.

## Law

Bible §16: MARK is live; **CANONIZE** is cold, Pope-authored text. Software supplies the seal, never the scripture.

```lua
Store:CanonizeMoment(momentId, text)
Store:FlagFamousUpset(characterId, opponentId)
```

**CanonizeMoment:** `momentId` is a marked-moment id. `text` required, trimmed, no `"\n"`. Sets `scripture` on that row (copy out). Unknown id refuse. Empty refuse. Does not invent location or prose.

**FlagFamousUpset:** find the **latest** `gora.results` row on `characterId` whose `opponentId` matches and `won == true`. Set `famousUpset = true`. No match → refuse. Do not compute “upset” from levels/records. Do not set `notable` unless already set.

Replace the old pin `Store.Canonize == nil` (that was “not this Phase 2 lane”). Snapshot/Restore must keep `scripture` and the flagged result.

## Tests

FlagMoment → CanonizeMoment paints scripture. Newline refuse. FlagFamousUpset after a victor RecordGoraResult. Latest of two wins wins. Loss/void refuse. Isolation wrap stays.

`lua tests/test_store.lua` exit 0.

Report `docs/reformation/vestments/briefs/B7-A-store-chronicle-report.md` + diff.
