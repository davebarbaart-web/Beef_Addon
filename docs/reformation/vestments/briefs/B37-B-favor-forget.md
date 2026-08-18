# B37-B — Quiet forget also drops leftover congregation favor

**Exclusive:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

**Do not edit** glue, Gora, Console. Do not commit. No `UnitHealth`. No roman numerals.

## Law

License 2 / §10.6 favor is per-event. `forgetPersist` (~303–306) nils `lastPair` / `lastPopeFavor` only. Quiet `Refresh` (~763–766) then `paintHidden`. `broadcastFavor` stays, so a later live pair paints leftover last-event favor until `SetBroadcastFavor(nil)`.

`forgetPersist` also nils `broadcastFavor`. Do **not** nil `favorTarget` (dest persist, like Inputs dest). Hidden paint stays empty. No `UnitHealth`.

## Tests

Nest `runB37B()` after `runB35A()` inside `runB19C()`. SetBroadcastFavor a split, Quiet Refresh, view.favor is nil; a later live pair without a new SetBroadcastFavor still has no leftover favor. Existing STATE-off / class-color pins stay. Isolation wrap stays.

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/B37-B-favor-forget-report.md` + diff.
