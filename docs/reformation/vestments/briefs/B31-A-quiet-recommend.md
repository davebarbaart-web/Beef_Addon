# B31-A — Refresh in QUIET drops a leftover Recommend line

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Dock, glue. Do not commit. `SaveNote` stays nil. Nest `runB31A()` inside `runB8E()` after `runB29A()`. Do not add main-chunk locals.

## Law

B24 leftover pin: `Runtime:EndEvent` then `Console:Refresh` leaves `lastRecommendation`. InspectProgress / glue EndEvent bypass the desk. The mute `"  names  "` line must die with the event (B26-A).

In `Console:Refresh`, before `paintRecommendation`: if Runtime `GetState` is nil or `"QUIET"`, set `lastRecommendation = nil`. Do **not** nil `selectedFighterA` / `selectedFighterB` here (a Pope may pick a pair in QUIET before Start Event). StartEvent / EndEvent pair-clear stay. Continue still does not clear. `SaveNote` stays nil. No SUMMON. No parchment.

## Tests

Update the B24-A leftover pin in place: after `Runtime:EndEvent()` + `Refresh`, Recommendation text is `""`. Keep the StartEvent-clears pin. Add a source pin that Refresh nils `lastRecommendation` when state is QUIET. Recommend during a live event still paints. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B31-A-quiet-recommend-report.md` + diff.
