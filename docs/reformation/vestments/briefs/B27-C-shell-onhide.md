# B27-C — Quiet shell Init restores a missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

**Do not edit** Toasts.lua, Decree, glue. You **may** update the B24-C early-return pin in `test_ui.lua` that currently forbids OnHide on that path. Do not commit. No `PlaySound` / `IG_CHARACTER_INFO_*`. Nest in `runB12D()`.

## Law

B26 leftover: Quiet-shell `UI:Init` early-return `rememberSpecial`s but never restores a missing OnHide. ESC Hide then skips `_StopSizing` / `ui.shown = false`.

On the early-return path: `rememberSpecial(FRAME_NAME)`; if `GetScript("OnHide")` is nil, wire the **same** OnHide as create (`UI:_StopSizing()` then `ui.shown = false`). Do **not** replace an existing script. Do not re-wire OnShow. Do not rebuild.

Extract `wireShellOnHide(self, frame)` if that keeps SetScript out of the early-return body. `FRAME_NAME` is `"ChurchOfBeefFrame"`.

## Tests

Nil the shell OnHide, second Init: script is restored. Third Init with the script already set: identity stays. Wipe `UISpecialFrames` uniqueness / B24-C rememberSpecial / B26-B toast pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B27-C-shell-onhide-report.md` + diff.
