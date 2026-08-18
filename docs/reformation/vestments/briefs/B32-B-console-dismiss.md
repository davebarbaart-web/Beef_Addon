# B32-B — Console Dismiss also reaches the confession inbox

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Confession.lua, glue. Do not commit. `SaveNote` stays nil. Nest `runB32B()` inside `runB8E()` after `runB31A()`. No new main-chunk locals. No second Dismiss button. No Toasts / Sound / chat.

## Law

Bible §9: the addon organizes the confession **queue** on the Pope console only. `Confession:Dismiss` already exists. `Console:Dismiss` (~1669) only calls `Gora:Dismiss`. One stock Dismiss button (707). No second button. No fan-out. No theater.

Keep the Gora path and the `"gora is not available"` refuse. Also, if `COB.Confession.Dismiss` exists, call it with the same id. Refresh if either returns true. Return true if either succeeded. Isolated suite often has Confession nil — Gora-only Dismiss stays. CallForward pins stay. No `PlaySound`. No `SaveNote`.

## Tests

Stub Confession with `Dismiss` that records the id: `Console:Dismiss(id)` reaches it and still reaches Gora. Missing Confession: Gora Dismiss still true. No Sound / Toasts / chat. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B32-B-console-dismiss-report.md` + diff.
