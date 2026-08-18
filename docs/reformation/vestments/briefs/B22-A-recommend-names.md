# B22-A — Recommendation paints the named-opponent token

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Gora, Inputs, Net, glue. Do not commit. `SaveNote` stays nil. No “DEMANDED” / narration. Stock desk. No new codec kind. Nest new pins in `runB8E()` — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

Bible §10.2 / §18.1. `Gora:Recommend` already returns `{ namedOpponent = true }` when either petition names the other combatant. `Console:Recommend` stores `lastRecommendation` without that flag. `paintRecommendation` / `suggestionLabel` stay `nameA vs nameB` plus mute H2H.

When `result.namedOpponent == true`, store the flag on `lastRecommendation` and append mute `"  names  "` to the painted suggestion (same mechanical token as petition `left .. "  names  " .. right` and `"  called"`). Do not write “DEMANDED”. Do not change petitionLine. Do not Sanction.

The B21-A source pin that greps `left .. "  names  " .. right` as “Recommend names token stays parked” is the **petition** line — keep that grep, retarget the message (petition token stays). Add a recommendation-line pin for `"  names  "`.

## Tests

Isolation stays the console suite. After two characters + `Gora:Petition(b, a)` + `Console:Recommend()` (no selected pair, so named petition wins): `frame.Recommendation:GetText()` contains `"  names  "` and both names. Unnamed pair Recommend still has no token. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B22-A-recommend-names-report.md` + diff.
