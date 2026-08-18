# B19-B — Small toast ESC via UISpecialFrames

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Console, Sound, glue. Do not commit. No close ✕. No new cue. Clerical copy unchanged. Proclaim `ChurchOfBeefProclaim` stay. No `PlaySound` on show / hide / ESC (wiki example `IG_CHARACTER_INFO_*` is forbidden). Nest new pins inside `runB12D()` (200-local).

## Law

Wiki: a **named** frame on `UISpecialFrames` Hides on ESC. `ChurchOfBeefProclaim` already uses `rememberSpecial`. `ChurchOfBeefToast` is named and ESC-immune.

In `Init`, `rememberSpecial("ChurchOfBeefToast")` (dedupe helper already in file). Wire `OnHide` on the small frame so ESC Hide syncs `showing` (nil) and does not leave pump stuck. Do not call theater `hideTheater` from the small-toast OnHide. Do not PlaySound.

Quiet still does not drive this file. Do not mint a Quiet toast kind.

## Tests

After Init (or Show/Push so the frame exists): `ChurchOfBeefToast` is listed once on `UISpecialFrames`. Hide (simulating ESC) clears `ShowingKind`. A later Push/Show still works. Proclaim special-frame pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B19-B-toast-esc-report.md` + diff.
