# B13-D — Console EditBox ESC ClearFocus

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Store, Gora, glue. Do not commit. Console stays **stock**. `SaveNote` stays nil. No SUMMON. No `PlaySound`.

## Law

Focused EditBoxes swallow ESC and block `UISpecialFrames` (wiki: Make frames closable with the Escape key — OnEscapePressed). In `stockEdit`, type-guard `SetScript("OnEscapePressed", …)` that `ClearFocus`s. All stock boxes (Stipulation, FreeRuling, Decree, Archive, Canonize, Honorific) inherit it. Do not Hide the console from the box (ClearFocus only).

Lua 5.1 200-local cap: nest new pins inside `runB8E()` / a new nested function.

## Tests

`ArchiveBox` / `DecreeLine` have OnEscapePressed. `stub.fire(box, "OnEscapePressed")` does not error. Source contains `OnEscapePressed` and `ClearFocus`. `SaveNote` nil. No SUMMON / parchment / tabs. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B13-D-console-esc-report.md` + diff.
