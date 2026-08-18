# B23-C — Init early-return re-registers the small toast special frame

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Console, Sound, glue. Do not commit. No `PlaySound`. Do not `hideTheater` from small-toast OnHide. OnHide idle-return when `showing` is nil stays. Nest pins in `runB12D()`.

## Law

B20-D leftover: `Toasts:Init` returns the existing frame and skips `rememberSpecial`. A wiped `UISpecialFrames` (or a remount that lost the name) never gets `ChurchOfBeefToast` back.

On the early-return path, call `rememberSpecial("ChurchOfBeefToast")` then return the frame. Do not re-wire OnHide if a script already exists. Do not add kind names. Default `KINDS` stay `interrupt = false`.

## Tests

Init, wipe `UISpecialFrames` to `{}`, second Init: name is listed exactly once. First-create uniqueness pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B23-C-toast-special-report.md` + diff.
