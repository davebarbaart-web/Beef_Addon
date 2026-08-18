# B41-D — Toasts Init remounts ChurchOfBeefProclaim

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** glue, MainFrame.lua. Do not commit. No `PlaySound`. `test_ui.lua` is shared with MainFrame — this lane only; do not edit `MainFrame.lua`.

## Law

Wiki: ESC via `UISpecialFrames`. HideAll remounts `ChurchOfBeefToast` and `ChurchOfBeefProclaim` (B39-C). Existing-frame Init remounts only `ChurchOfBeefToast` + `wireSmallOnHide`, so a wiped proclaim name stays idle until HideAll / Proclaim.

Existing-frame Init: remount `rememberSpecial("ChurchOfBeefToast")` (keep) and `rememberSpecial(PROCLAIM_NAME)` / `ChurchOfBeefProclaim`. Keep `wireSmallOnHide`. Do not add a close button. Do not PlaySound. Do not tear theater.

## Tests

Nest after the B39-C HideAll block inside `runB12D()`. Wipe list, Init: both names re-listed once, no sound. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B41-D-toast-init-proclaim-report.md` + diff.
