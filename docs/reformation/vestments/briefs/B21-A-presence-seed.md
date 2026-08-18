# B21-A — Presence fail-opens until Roster is complete

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Roster, Gora, glue. Do not commit. `SaveNote` stays nil. No `UnitIsDead`. No new empty-state copy. Do not invent “DEMANDED”. Nest new pins in `runB8E()` / a nested function — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

Bible §10.2 (present-and-alive pool). B19-A leftover: `presentCharacterIds` fail-opens Store character ids while Roster is ready but not complete; `GetPresence` still lists seed members only. The seed window can look empty on Presence while petitions already show Store people.

Mirror the petition complete-detection (`IsComplete() == true` if the method exists, else `Roster.complete == true`):

- If Roster is missing / `ready ~= true` / `members` is not a table: keep returning `{}`.
- If Roster is complete: keep the current member walk (`here = true`, unlinked roster names stay).
- If Roster is ready but **not** complete: keep that member walk, then **append** Store snapshot characters whose name key is not already in the rows. Appended Store-only rows use `here = false`. Do not invent they are in the room. Do not invent ranks — copy Store human rank the same way the member walk does. Do not invent an alive scrape.

Do not change `"No one on the roster yet."`. Do not rewrite `presentCharacterIds`. Do not add a second Dismiss. Recommend `"  names  "` stays parked.

Flip the two B19-A asserts that say GetPresence is not fail-open (same nested `runB19A` or a new `runB21A()` after `runB20A()`). Complete-path Presence stays one member.

## Tests

Isolation stays the console suite. Incomplete seed (members only Beefina, Store also has Chuckroast): `GetPresence` lists both; Chuckroast `here == false` and carries `characterId`. Complete roster still lists members only. Not-ready / missing Roster still `{}`. Clicking a fail-open Store row selects that `characterId`. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B21-A-presence-seed-report.md` + diff.
