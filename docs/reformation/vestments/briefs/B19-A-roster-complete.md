# B19-A — Petitions fail-open until Roster is complete

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Roster, Gora, glue. Do not commit. `SaveNote` stays nil. No `UnitIsDead`. No new empty-state copy. Nest new pins in `runB8E()` / a nested function — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

Bible §10.2 (present-and-alive pool). `Roster:IsComplete` exists so “not in members” is not a refusal during the login seed (only the player name is seeded). `presentCharacterIds` today keys on `Roster.ready` and then name-matches members, so a seed snapshot hides every petitioner who is not the local player.

- If Roster is missing / `ready ~= true` / `members` is not a table: keep returning `{}` (existing empty).
- If Roster is ready but **not** complete: fail-open — mark every Store snapshot character id present. Do not invent an alive scrape.
- If Roster is complete: keep the current member-name filter.

Complete detection: `type(Roster.IsComplete) == "function"` and `Roster:IsComplete() == true`, else `Roster.complete == true` (existing harness stubs set the field, not the method).

Do not rewrite `GetPresence`. Do not change `"No one on the roster yet."`. Do not invent “DEMANDED”.

## Tests

Existing petition pins that stub `ready = true` without `complete` must stay green (fail-open still shows store petitioners).

Nested pin: `complete = true` (or `IsComplete` → true), members contain only one of two petitioners → `GetPetitions` is that one. `complete = false`, members only the local name, second Store character petitioned → that petition still appears.

Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B19-A-roster-complete-report.md` + diff.
