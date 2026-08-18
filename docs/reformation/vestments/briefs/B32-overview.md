# Batch 32 — HUD lastPair forget + confession Dismiss + called reset + marker clear-prior

**Cited:** Bible §10.7 HUD exits with the Gora consequence; §9 confession queue on the Pope console only; §13.4 free text never theater; §8 raid marks on the **current** subject. License 4 stock only. One Console leftover this batch. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No second Dismiss button. No roman HUD numerals.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B32-A | `UI/Hud.lua`, `tests/test_hud.lua` | Non-Gora RITE/CONSEQUENCE `forgetPersist`s lastPair so Knighting Continue stays hidden. Nest after `runB21B()`. |
| B32-B | `UI/Console.lua`, `tests/test_console.lua` | `Dismiss` also calls `Confession:Dismiss`. Nest after `runB31A()`. |
| B32-C | `Core/Confession.lua`, `tests/test_confession.lua` | Latest `Receive` clears `called`. |
| B32-D | `UI/Markers.lua`, `tests/test_markers.lua` | New Mark* clears the previous remembered unit (index 0). |
| B32-INT | `ChurchOfBeef.lua`, `tests/test_wire_glue.lua` | `afterRuntime` / `afterEndEvent` Refresh Hud (skip inspect). |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
