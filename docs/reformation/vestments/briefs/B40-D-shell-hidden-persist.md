# B40-D — already-hidden Quiet-shell Hide still persists shown = false

**Exclusive:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

**Do not edit** glue, Toasts.lua, RecordsBook. Do not commit. No `PlaySound`. `test_ui.lua` is shared with Toasts — this lane only; do not edit `Toasts.lua`.

## Law

Wiki: ESC via `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefFrame`. `shown` persist lives on OnHide (B35-D). `UI:Hide` remounts OnHide then `frame:Hide()`. If the frame is already hidden, `frame:Hide()` does not fire OnHide, so a stale `ChurchOfBeefDB.ui.shown = true` stays.

Existing-frame Hide: after remount, write `shown = false` on the ui slot (same `uiDb()` as OnHide) even when the widget is already hidden. Keep OnHide remount for ESC. Do not replace an existing OnHide. Do not rebuild. No OnShow re-wire. Inputs stay off `UISpecialFrames`. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest after the B35-D block inside `runB12D()`. Already-hidden Hide: `shown` becomes false even if OnHide does not fire again. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B40-D-shell-hidden-persist-report.md` + diff.
