# B36-D — Decree Hide remounts UISpecialFrames membership

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** glue, Console. Do not commit. No Clear Decree chrome. No `PlaySound`.

## Law

Wiki: ESC needs a **named** frame on `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefDecree`. `Hide` (~336–345) remounts `wireDecreeOnHide` only. `rememberSpecial` lives on `buildFrame` / `ensureFrame`. Wiped list + Hide-only leaves ESC idle until Show / Refresh / Init.

Existing-frame `Hide`: `rememberSpecial(FRAME_NAME)` then existing OnHide remount + wipe-if-empty + `frame:Hide()`. Never replace an existing OnHide. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`. No Clear chrome.

## Tests

Nest after `runB31B()` inside `runB25B()`. Source pin: Hide body calls `rememberSpecial` before `frame:Hide()`. Wipe `UISpecialFrames`, Hide: `ChurchOfBeefDecree` re-listed once. Third Hide does not duplicate. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B36-D-decree-special-report.md` + diff.
