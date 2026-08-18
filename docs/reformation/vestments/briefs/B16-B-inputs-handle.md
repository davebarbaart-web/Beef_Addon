# B16-B — Inputs TitleBar drag handle

**Exclusive:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

**Do not edit** Net, Console, glue. Do not commit. WIDTH 328 HEIGHT 72 stay. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`. No Pope-name lookup. No `PlaySound`. Persist key stays `ChurchOfBeefDB.ui.inputs`.

## Law

B15-A registered drag on the **root**. Petition / Catch up / Confess and the confess box occupy most of the 72px bar, so in-game drag is a leftover. Add a thin `TitleBar` child (height 12–14, TOPLEFT/TOPRIGHT, `EnableMouse`, `RegisterForDrag("LeftButton")`) that `StartMoving`s the root and `savePoint`s on `OnDragStop` after `StopMovingOrSizing`. Remove root `RegisterForDrag` so buttons do not steal the handle. Root stays `SetMovable` + `SetClampedToScreen`. Default point still `BOTTOM` / `UIParent` / `0` / `80`.

Do not grow HEIGHT. Do not add a title string (stock functional chrome; no jokes).

## Tests

Update persist pins to fire **TitleBar** `OnDragStop` (dock pattern), not root. TitleBar exists. Root has no `OnDragStart` (or RegisterForDrag cleared). Quiet hide, ESC ClearFocus, not on `UISpecialFrames`, isolation wrap stay.

`lua tests/test_inputs.lua` exit 0.

Report `docs/reformation/vestments/briefs/B16-B-inputs-handle-report.md` + diff.
