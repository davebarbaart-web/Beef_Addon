# B34-B — leftover Presence buttons reset alpha

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** glue, Roster, Inputs. Do not commit. No “offline” / “away”. `SaveNote` stays nil. No SUMMON.

## Law

Bible §18.1 Presence is who is here. B33-B dims visible `here == false` with stock `SetAlpha(0.45)`. `acquireRows` leftover hide (`~467–469`) and empty-roster `acquireRows(..., 0)` Hide without resetting alpha, so a dim leftover keeps `0.45` until reused.

When hiding leftover Presence buttons (the `count + 1` tail, including count `0`), `SetAlpha(1)` if present. Visible `here == false` stays `0.45` after `paintPresence`. Visible `here ~= false` stays `1`. Petition / confession / knighting rows stay undimmed. No new Presence copy. Console stays plain.

## Tests

Nest `runB34B()` after `runB33B()` inside `runB8E()`. Reuse B33-B `pinAlpha` pattern. Paint fail-open (here + Store dim), then shrink to empty Presence (`COB.Roster = nil` or empty GetPresence path you already pin) and Refresh; leftover hidden Presence buttons `GetAlpha() == 1`. Re-paint fail-open: visible here stays `1`, Store stays `~0.45`. No offline / away / `UnitIsDead`. `SaveNote` nil. Isolation wrap stays. New pins go in the nested function — no new main-chunk locals.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B34-B-presence-alpha-report.md` + diff.
