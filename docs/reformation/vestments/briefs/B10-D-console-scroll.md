# B10-D — Glanceable Console scroll

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Store, Gora. Do not commit. Console stays **stock**. `SaveNote` stays nil. No SUMMON. No post-show summary.

## Law

The desk grew to 1050px. Bible §18.1: glanceable, movable, large targets. Keep every desk; put the **content** on a stock `ScrollFrame` (same pattern as Presence / CeremonyLog lists — `CreateFrame("ScrollFrame", …)` type-guarded). Outer frame height **780**. Child can stay tall.

Do not collapse desks into tabs. Do not parchment the console.

Anniversary has SimpleScrollFrameAPI (`SetScrollChild`, `SetVerticalScroll`). Type-guard missing APIs.

## Tests

Frame height 780. A ScrollFrame exists for the desk body. CeremonyLog / Archive / Canonize / SaveNote pins stay. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B10-D-console-scroll-report.md` + diff.
