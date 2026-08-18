# B13-C — Records Book mouse wheel

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** Console, glue. Do not commit. Stock textures/fonts only. No invented empty-page copy. PAGE_TITLES stay 9. No sound.

## Law

Theatrical tome (Bible §14.2). After the named frame exists, type-guard `EnableMouseWheel(true)` and `OnMouseWheel`. Positive delta (wheel up) → `turn(-1)` Previous; negative → `turn(1)` Next. Missing APIs no-op. No permanent `OnUpdate`. Anniversary `EnableMouseWheel` is SimpleScriptRegionAPI.

## Tests

After Init/Show, frame has OnMouseWheel. Source contains EnableMouseWheel. `stub.fire(frame, "OnMouseWheel", -1)` turns the leaf the same way Next does (pin a page title). Empty-leaf body stays `""`. Isolation wrap stays.

`lua tests/test_records.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B13-C-records-wheel-report.md` + diff.
