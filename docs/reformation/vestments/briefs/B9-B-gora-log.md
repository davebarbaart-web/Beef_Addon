# B9-B — Gora ruling ceremony log

**Exclusive:** `addon/ChurchOfBeef/Core/Gora.lua`, `tests/test_gora.lua`

**Do not edit** Store, Knighting, Console. Do not commit. Famous Upsets stay not computed. Favor stays memory-only.

## Law

`FreeRuling` already appends `("free", { a, b }, now, line)`. After successful `writeBoth`, the other three rulings append type-only:

```lua
Store:AppendCeremony("victor", { winnerId, loserId }, now)
Store:AppendCeremony("cowardice", { fleerId, otherId }, now)
Store:AppendCeremony("void", { a, b }, now)
```

No 4th-arg text on these three (software never narrates). Missing AppendCeremony is OK. Refused verbs do not append. Pair still clears. Do not auto-set `famousUpset`.

## Tests

DeclareVictor / CowardiceRecorded / Void each append the matching type and two ids. No text/scripture. FreeRuling pins stay. Famous Upsets not computed pin stays. Isolation wrap stays.

`lua tests/test_gora.lua` exit 0.

Report `docs/reformation/vestments/briefs/B9-B-gora-log-report.md` + diff.
