# B12-A — ASSEMBLY may carry subjects

**Exclusive:** `addon/ChurchOfBeef/Core/Runtime.lua`, `tests/test_runtime.lua`

**Do not edit** Snapshot, glue, Codec, Gora. Do not commit. No auto-advance. No sixth state. No holdSeconds.

## Law

Bible §20: broadcast state carries **active subjects** (candidate, fighters) with the event. ASSEMBLY is a live event. Today's `parseEvent` refuses any subjects in ASSEMBLY, so a Sanction-before-OpenRite STATE / SNAPSHOT cannot Restore on congregation clients.

```lua
-- QUIET: subjects must stay empty (candidate nil, fighters nil)
-- ASSEMBLY: riteType still nil; candidate and/or fighters MAY Restore
-- RITE / CONSEQUENCE: unchanged (riteType required)
-- StartEvent / Continue / EndEvent still write emptySubjects()
```

Do not let OpenRite auto-fire. Do not persist Runtime to SV.

## Tests

Existing ASSEMBLY-empty after StartEvent / Continue pins stay.

Add: Restore ASSEMBLY with `{ fighters = { 8, 9 } }` and no riteType succeeds; Snapshot keeps both ids. Restore ASSEMBLY with `{ candidate = 7 }` succeeds. Restore QUIET with fighters still `invalid subjects`. Restore ASSEMBLY with a riteType still refused.

`lua tests/test_runtime.lua` exit 0.

Report `docs/reformation/vestments/briefs/B12-A-runtime-assembly-report.md` + diff.
