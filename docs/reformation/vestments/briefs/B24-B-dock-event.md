# B24-B — Dock dismiss is per Runtime eventId

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** Console.lua, Hud, glue. Do not commit. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist stays. `UISpecialFrames` stays. No `PlaySound` / `IG_CHARACTER_INFO_*`. Hide is not EndEvent. No dismiss-cooldown number.

## Law

B23-B leftover: `dismissed` is a boolean. ESC then `EndEvent` **without** Refresh leaves dismiss set; the next `StartEvent` + Refresh stays hidden because `mayShow` is true and dismiss is still true.

Key dismiss to Runtime `Snapshot().eventId` (number). OnHide while live: remember that `eventId`. Refresh: if `mayShow` and the current `eventId` equals the remembered id, stay hidden. A new `eventId` (or `eventId` nil / QUIET) clears dismiss and may show. `Show()` still clears dismiss. `ResetForTests` clears it.

B23-B same-event ESC + Refresh stay-hidden pins stay.

## Tests

StartEvent + Pope: shown. Widget Hide: hidden. EndEvent (no Refresh). StartEvent + Refresh: **shown** (new eventId). Same-event Hide + Refresh still hidden. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B24-B-dock-event-report.md` + diff.
