# B26-A — Selected pair dies with the event

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Gora, glue. Do not commit. `SaveNote` stays nil. Nest new pins in `runB8E()` as `runB26A()` after `runB25A()` — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

B25 leftover: successful Start/End nil `lastRecommendation` but leave `selectedFighterA` / `selectedFighterB`. A later petition-path Recommend then inherits `hadSelected` and suppresses `"  names  "`.

On successful `StartEvent` / `EndEvent` (`result ~= nil`), also set `selectedFighterA = nil` and `selectedFighterB = nil` **before** `after()`. Failed Start / failed End / Continue keep the pair. `lastRecommendation` clear stays. B25-A gate stays. No “DEMANDED”. `SaveNote` stays nil.

## Tests

SelectFighters + named petition + Recommend: both names, no `"  names  "` (B25 keep). EndEvent then StartEvent + named petition + Recommend **without** SelectFighters: `"  names  "` present. Failed Start while live keeps the selected pair (hadSelected still true). Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B26-A-sel-lifetime-report.md` + diff.
