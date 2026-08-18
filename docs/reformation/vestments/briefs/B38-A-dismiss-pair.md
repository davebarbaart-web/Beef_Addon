# B38-A — Dismiss drops leftover pair when the dismissed id is in it

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** glue, Gora, Store. Do not commit. `SaveNote` stays nil. No SUMMON. Do not nil `selectedHumanId`.

## Law

Bible §18.1 leftover highlight. B37-A nils `selectedCharacterId` on successful Dismiss. `selectedFighterA` / `B` and `lastRecommendation` still live. `FlagFamousUpset` (~1941–1948) falls through to leftover `selectedFighterA` when the character pick is nil. `Sanction` still uses leftover pair.

Successful Dismiss (`ok` true): if the dismissed id is `selectedFighterA` or `selectedFighterB`, also nil the pair and `lastRecommendation` **before** Refresh. Dismiss of a third id keeps the pair. Failed Dismiss keeps. Do **not** nil `selectedHumanId`. End / Start keeps stay.

## Tests

Nest `runB38A()` after `runB37A()` inside `runB8E()`. Select pair A/B, Dismiss A, pair and Recommend nil; FlagFamousUpset / Sanction without explicit ids do not fire on leftover A. Dismiss of a third id keeps A/B. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B38-A-dismiss-pair-report.md` + diff.
