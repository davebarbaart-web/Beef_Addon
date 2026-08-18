# B36-B — End Event drops leftover human / character selection

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** glue, Knighting, Confession. Do not commit. `SaveNote` stays nil. No SUMMON.

## Law

Bible §18.1 leftover highlight. B26-A already nils `selectedFighterA` / `B` on successful Start / End. After End, leftover `selectedHumanId` / `selectedCharacterId` still feed CallForward / Dismiss / KnightThisBeef / Presence highlight.

Successful **EndEvent** (`result ~= nil`) also nils `selectedHumanId` and `selectedCharacterId` before `after()`. Fighter-pair clear stays.

Successful **StartEvent** does **not** nil human / character — Pope may pick in QUIET then Start then OpenRite / KnightThisBeef. Refresh does **not** nil selection (B31-A). Failed End / Continue keep. `SaveNote` nil. No SUMMON.

## Tests

Nest `runB36B()` after `runB34B()` inside `runB8E()`. Select a human + character, successful EndEvent, both ids nil; CallForward / Dismiss / KnightThisBeef without an explicit id refuse or no-op (do not fire on the leftover). StartEvent after a Quiet pick keeps the human id. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B36-B-end-select-report.md` + diff.
