# B39-C — HideAll remounts toast and proclaim ESC names

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** glue, MainFrame, Sound. Do not commit. No `PlaySound`. Do not own `MainFrame.lua` (`test_ui.lua` is shared — this lane only).

## Law

Wiki: ESC via `UISpecialFrames`. HideAll (~929–940) hides the small toast and the proclaim root without remounting `ChurchOfBeefToast` / `ChurchOfBeefProclaim`. A wiped list stays idle until the next Proclaim / Show.

HideAll remounts `rememberSpecial("ChurchOfBeefToast")` and `rememberSpecial(PROCLAIM_NAME)` (or the same string `ChurchOfBeefProclaim`). Do not add a close button. Do not PlaySound. B18-C HideAll still plays no sound and still tears theater once.

## Tests

Nest after the B18-C HideAll block inside `runB12D()`. Wipe list, HideAll: both names re-listed once, no sound. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B39-C-toast-hideall-report.md` + diff.
