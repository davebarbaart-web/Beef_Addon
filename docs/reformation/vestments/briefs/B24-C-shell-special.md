# B24-C — Quiet shell Init early-return re-registers ESC

**Exclusive:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

**Do not edit** Toasts, Console, glue. Do not commit. No `PlaySound` / `IG_CHARACTER_INFO_*`. Nest pins in `runB12D()`.

## Law

Wiki ESC: named frame on `UISpecialFrames`. `UI:Init` returns the existing frame and skips `rememberSpecial`. A wiped list never gets `ChurchOfBeefFrame` back (same leftover B23-C closed for the small toast).

On the early-return path, call `rememberSpecial(FRAME_NAME)` then return the frame. Do not rebuild. Do not re-wire OnShow / OnHide. B15-C uniqueness stays.

## Tests

`UI:Init`, wipe `UISpecialFrames` to `{}`, second `Init`: `ChurchOfBeefFrame` listed exactly once. First-create / rebuild uniqueness pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B24-C-shell-special-report.md` + diff.
