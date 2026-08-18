# B20-A — Confession inbox click + called token

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Confession.lua, Gora, glue. Do not commit. `SaveNote` stays nil. No fan-out. No Sound / Toasts / SendChatMessage on CallForward. No second Dismiss plate (`Console:Dismiss` stays Gora). Nest new pins in `runB8E()` — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

Bible §9 (queue + call the next participant); §13.4 (text stays on the Pope desk); §18.1. Core already stores `called`. The desk paints a FontString only — Call Forward needs `selectedCharacterId` from Presence.

Mirror Presence / Petition / Knighting: `ConfessionRows = {}` on build. `paintConfessions` uses `paintRowButtons` on `ConfessionChild` when `#rows > 0` (hide `ConfessionList`); empty stays `"No confessions."` on the list.

Click: `SelectCharacter(row.characterId)` then Refresh. `confessionLine` appends mute `"  called"` when `row.called == true` (same mechanical token as `"  needs Knighting"`). Do not write “DEMANDED”, “CALLED FORWARD”, or any oratory.

Existing CallForward pins stay (Pope gate, no sound, no chat).

## Tests

Init + stub queue with one row: a Confession row button exists; click sets `selectedCharacterId`. After `CallForward` + Refresh, painted line contains `"  called"`. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B20-A-confession-click-report.md` + diff.
