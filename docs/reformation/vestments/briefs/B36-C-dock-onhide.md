# B36-C — ConsoleDock Hide remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** Console, glue. Do not commit. No `PlaySound`.

## Law

Wiki: ESC closes a **named** frame on `UISpecialFrames`. Dock OnHide (~212–221) is the only writer of `lastView.shown = false` and live `dismissedEventId`. `Hide` (~325–330) remounts `rememberSpecial` then `paint(false)`. Niled OnHide then ESC / `frame:Hide()` leaves `shown` true and dismiss unset; next Refresh paints the dock again.

Extract a small `wireDockOnHide` (never replace an existing script). Existing-frame `Hide`: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `paint(false)`. `FRAME_NAME` stays `ChurchOfBeefConsoleDock`. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest after `runB30D()` inside `runB27D()`. Source pin: Hide calls the OnHide remount before `paint(false)`. Wipe list, nil OnHide, Show a live dock, Hide: OnHide restored, `GetView().shown == false`, live dismiss set, `ChurchOfBeefConsoleDock` re-listed once, no sound. Third Hide does not replace OnHide. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B36-C-dock-onhide-report.md` + diff.
