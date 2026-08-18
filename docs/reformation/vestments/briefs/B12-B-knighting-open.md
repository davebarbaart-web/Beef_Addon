# B12-B — Open Knighting line fallback

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Knighting.lua, Runtime, glue. Do not commit. Console stays **stock**. `SaveNote` stays nil. No SUMMON.

## Law

`Console:OpenRite("Knighting")` already uses `selectedHumanId` when set. If it is missing, fall back to the **head** of `Knighting:GetLine()` (`rows[1].humanId`) when that is an id. Selected human still wins. Gora fallback from B11-C stays. Other rites unchanged.

Lua 5.1 200-local cap: nest new pins inside `runB8E()` / a new nested function. Do not add locals to the main chunk.

## Tests

Pope-predicate wrap: Enqueue a human, **no** `SelectHuman` → `OpenRite("Knighting")` Runtime subjects.candidate is that human id.

`SelectHuman` still wins over a different line head.

`SaveNote` nil. No SUMMON / parchment / tabs. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B12-B-knighting-open-report.md` + diff.
