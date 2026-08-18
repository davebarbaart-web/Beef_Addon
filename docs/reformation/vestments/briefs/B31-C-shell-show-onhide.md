# B31-C — Quiet shell Show remounts a missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

**Do not edit** Toasts.lua, Decree, glue. Do not commit. No `PlaySound` / `IG_CHARACTER_INFO_*`. Nest in `runB12D()`.

## Law

B27 leftover: `UI:Show` skips a niled OnHide. ESC lastView / `_StopSizing` would drop.

When the frame exists, `Show` calls `wireShellOnHide(self.frame)` and `rememberSpecial(FRAME_NAME)` before Show. Do **not** replace an existing script. Do not rebuild. Init remount stays. `FRAME_NAME` is `"ChurchOfBeefFrame"`.

## Tests

Nil the OnHide, Show: script restored. Third Show with the script already set: identity stays. Existing B27-C Init / B26-B toast / B29-D Proclaim font pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B31-C-shell-show-onhide-report.md` + diff.
