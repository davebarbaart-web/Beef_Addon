# B15-B — Records Book wheel on chrome

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** MainFrame, glue. Do not commit. PAGE_TITLES stay the nine Bible titles. No generated prose. No custom media. No `PlaySound` on wheel.

## Law

B13-C wired `EnableMouseWheel` + `OnMouseWheel` on the **outer** frame. TitleBar (`EnableMouse`), Close, ribbons, Previous, and Next sit on top and eat the wheel in-game (SimpleScriptRegionAPI: the region under the cursor gets the event).

Extract one handler (wheel up `turn(-1)` Previous, down `turn(1)` Next). Type-guard `EnableMouseWheel(true)` + `SetScript("OnMouseWheel", …)` on:

- `frame.TitleBar`
- `frame.CloseButton`
- `frame.VictoriesRibbon` / `RivalriesRibbon` / `MartyrsRibbon`
- `frame.PrevButton`
- `frame.NextButton`

Keep the outer-frame hook. Empty body stays `""`. Roman paint unchanged. Stock textures only.

## Tests

After Init: those named children have `OnMouseWheel`. `stub.fire(TitleBar, "OnMouseWheel", -1)` turns Next (same as outer). `stub.fire(PrevButton, "OnMouseWheel", 1)` turns Previous. PAGE_TITLES count stays 9. Outer-frame pins stay. Isolation wrap stays.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B15-B-records-wheel-report.md` + diff.
