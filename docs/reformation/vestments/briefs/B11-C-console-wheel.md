# B11-C — Console mouse wheel + Open Gora subjects

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Store, Gora, glue, TOC. Do not commit. Console stays **stock**. `SaveNote` stays nil. No SUMMON. No post-show summary. No parchment. No tabs.

## Law

1. **Wheel.** Anniversary `EnableMouseWheel` exists on SimpleScriptRegionAPI (default false). After creating `DeskScroll`, type-guard `EnableMouseWheel(true)` and `SetScript("OnMouseWheel", …)`. The handler type-guards `GetVerticalScroll` / `SetVerticalScroll` / `GetVerticalScrollRange` and moves by a modest step (36px is fine). Missing APIs → no-op. Do not add a permanent `OnUpdate`.

2. **Open Gora subjects.** `Console:OpenRite("Gora")` already uses `selectedFighterA/B` when both ids are set. If either is missing, fall back to `Gora:GetSanctioned()` then `Gora:GetLastSanctioned()` (two ids). Selected pair still wins when both are set. Other rite kinds unchanged. `SaveNote` stays nil.

Lua 5.1 200-local cap: nest new pins inside the existing `runB8E()` chunk (same as B10-D), or a new nested function. Do not add locals to the main chunk.

## Tests

Inside the nested chunk:

- `DeskScroll` has an `OnMouseWheel` script; source contains `EnableMouseWheel`.
- `stub.fire(frame.DeskScroll, "OnMouseWheel", -1)` does not error.
- Pope-predicate wrap: `StartEvent` + `Sanction(a,b)` with **no** selected fighters → `OpenRite("Gora")` Runtime subjects are `{ a.id, b.id }`.
- Selected pair still wins over `GetLastSanctioned`.
- `SaveNote` nil. No SUMMON / CopyCeremonySummary / parchment / tabs. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B11-C-console-wheel-report.md` + diff.
