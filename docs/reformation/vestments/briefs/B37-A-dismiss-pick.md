# B37-A — successful Dismiss drops leftover character pick

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** glue, Gora, Confession. Do not commit. `SaveNote` stays nil. No SUMMON.

## Law

Bible §18.1 leftover highlight. B36-B EndEvent nils `selectedCharacterId`. Live `Dismiss` (~1696–1708) still `id = characterId or self.selectedCharacterId` and never nils the pick, so one-click CallForward / DeclareVictor still resolves the dismissed petitioner.

Successful Dismiss (`ok` true, including Confession-only success) nils `selectedCharacterId` **before** Refresh. Failed Dismiss keeps. Do **not** nil `selectedHumanId` (knighting pick is separate). End / Start / Refresh keeps stay. `SaveNote` nil.

## Tests

Nest `runB37A()` after `runB36B()` inside `runB8E()`. Select a character, successful Dismiss, `selectedCharacterId` is nil; CallForward / DeclareVictor without an explicit id do not fire on the leftover. Failed Dismiss keeps the id. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B37-A-dismiss-pick-report.md` + diff.
