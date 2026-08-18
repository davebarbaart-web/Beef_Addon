# B39-A — OpenRite Gora does not reopen the last pair

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** glue, Gora, Store, Runtime. Do not commit. `SaveNote` stays nil. No SUMMON. Do not nil `selectedHumanId`.

## Law

Bible §18.1 leftover highlight; §10.7 persist is the Gora pair, not the next rite. B10-INT: post-Continue ASSEMBLY does not overlay last pair. `Console:OpenRite("Gora")` (~1531–1552) still falls through to `GetLastSanctioned` when the desk pair is empty, so a later Open Gora reopens the finished bout.

Keep the live `GetSanctioned` fallback. Drop the `GetLastSanctioned` fallback. Selected `selectedFighterA` / `B` still win. Knighting OpenRite unchanged. End / Start / Dismiss keeps stay.

## Tests

Nest `runB39A()` after `runB38A()` inside `runB8E()`. Sanction A/B, rule, Continue; OpenRite Gora without a desk pair does **not** put leftover last fighters on Runtime subjects. Live sanctioned fallback stays. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B39-A-openrite-last-report.md` + diff.
