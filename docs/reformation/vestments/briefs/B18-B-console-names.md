# B18-B — Console petition challenge line is pinned

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Gora, Inputs, Net, glue. Do not commit. `SaveNote` stays nil. No "DEMANDED" / narration. Stock desk. No new codec kind. Nest new pins in `runB8E()` or a `do` block — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

Bible §10.2 / §18.1. `petitionLine` already paints `left .. "  names  " .. right` plus mute H2H when `namedOpponentId` is set. Click already `SelectFighters`. B17 lands named opponents on `Gora:Petition`. This lane **pins** that desk path. Do not change the copy. Do not invent flavor.

If a Refresh paint path is missing the line on the list FontString, wire the existing `petitionLine` — do not write new prose.

## Tests

Isolation stays the console suite. After StartEvent + two known characters + `Gora:Petition(a, b)` (or Console path that ends in a named petition), `GetPetitions` / painted line contains `"  names  "`. Clicking that row selects both fighter ids (existing SelectFighters). Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B18-B-console-names-report.md` + diff.
