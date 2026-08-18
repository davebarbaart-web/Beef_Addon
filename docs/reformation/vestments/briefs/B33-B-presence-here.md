# B33-B — Presence rows honor here == false

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Roster, glue. Do not commit. `SaveNote` stays nil. Nest `runB33B()` inside `runB8E()` after `runB32B()`. No new main-chunk locals. No SUMMON. No `UnitIsDead`. No new word ("offline" / "away").

## Law

Bible §18.1 Presence is who is here. `GetPresence` already writes `here` (true on roster, false on fail-open Store). `presenceLine` / `paintRowButtons` ignore it. Fail-open looks live.

After `paintRowButtons` for Presence only, if `row.here == false`, stock `SetAlpha(0.45)` on that row button; otherwise `SetAlpha(1)`. Do **not** add a mute suffix. Do not change fail-open membership. Do not gray petitions / confessions / knighting. Console stays plain. `SaveNote` nil.

## Tests

Fail-open Store-only row (`here == false`): presence button `GetAlpha` / stub alpha is ~0.45. Roster `here == true` stays 1. Petition rows are not dimmed by this. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B33-B-presence-here-report.md` + diff.
