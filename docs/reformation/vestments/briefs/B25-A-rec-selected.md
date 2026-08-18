# B25-A — Selected pair does not inherit the Recommend names token

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Gora, glue. Do not commit. `SaveNote` stays nil. Petition `"  names  "` stays. Nest new pins in `runB8E()` — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

B22-A leftover: `Gora:Recommend` flags `namedOpponent` from live petitions even when the Pope already selected those two. The desk then paints `"  names  "` as if Recommend discovered the challenge.

Before resolving the pair, if `selectedFighterA` and `selectedFighterB` are already two different ids, store `namedOpponent = false` on `lastRecommendation` (still store the pair). Petition-path Recommend (no selected pair) still stores Core `namedOpponent == true` and paints `"  names  "`. B22-A / B24-A pins stay. No “DEMANDED”. `SaveNote` stays nil.

## Tests

SelectFighters(a, b) + `Gora:Petition(b, a)` + `Console:Recommend()`: Recommendation has both names and **no** `"  names  "`. Clear selection + named petition + Recommend: token present (B22-A keep). Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B25-A-rec-selected-report.md` + diff.
