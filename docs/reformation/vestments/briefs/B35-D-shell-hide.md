# B35-D — Quiet-shell Hide remounts OnHide + persist

**Exclusive:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

**Do not edit** RecordsBook, Toasts source behavior beyond the shared suite, glue. Do not commit. No `PlaySound`. Inputs stay off `UISpecialFrames`.

## Law

Wiki: ESC closes a **named** frame listed on `UISpecialFrames`. `wireShellOnHide` is the only writer of `ui.shown = false` on ESC. `UI:Show` remounts `wireShellOnHide` + `rememberSpecial` (B31-C). `UI:Hide` (~602–606) is `_StopSizing` then `frame:Hide()` only. Niled OnHide then Hide leaves `ChurchOfBeefDB.ui.shown == true`; `Init` `wasShown` reopens the shell.

Existing-frame `Hide`: remount `wireShellOnHide` + `rememberSpecial(FRAME_NAME)` (same pair as Show), then `_StopSizing` + `frame:Hide()`. Never replace an existing OnHide. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`. `FRAME_NAME` stays `ChurchOfBeefFrame`.

## Tests

Nest after the B31-C block inside `runB12D()` (before the standalone isolation asserts). Source pin: `UI:Hide` body calls `wireShellOnHide` and `rememberSpecial` before `frame:Hide()`. Wipe `UISpecialFrames`, nil OnHide, set `shown = true`, `UI:Hide()`: OnHide restored, `shown == false`, `ChurchOfBeefFrame` re-listed once, no sound, no rebuild. Third Hide does not duplicate. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B35-D-shell-hide-report.md` + diff.
