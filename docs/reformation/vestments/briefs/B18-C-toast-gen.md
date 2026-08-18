# B18-C — HideAll does not double-bump theaterGen

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Console, Sound, glue. Do not commit. No `PlaySound` on Hide / ESC / show. `ChurchOfBeefProclaim` stays on `UISpecialFrames`. Clerical copy unchanged. Nest new pins inside `runB12D()` (200-local).

## Law

`HideAll` calls `bumpGen()` then `hideTheater()`, and `hideTheater` also increments `theaterGen`. `root:Hide()` fires OnHide → `hideTheater` again. One dismiss can burn multiple generations.

`HideAll` should tear theater down **once**. Either: `HideAll` calls `hideTheater` only (no extra `bumpGen`), and OnHide is a no-op when the root is already the HideAll hide; or OnHide calls a no-bump hide. After HideAll, the next `Proclaim` must still show (existing B12-D pin).

Do not add a close button. Do not PlaySound on hide.

## Tests

Existing Proclaim / ESC / UISpecialFrames pins stay. Add a nested pin: Proclaim → HideAll → Proclaim still accepted and theater root shown. Source pin: `HideAll` body does not call both `bumpGen` and `hideTheater`. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B18-C-toast-gen-report.md` + diff.
