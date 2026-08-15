# Phase 5 Lane B — Decree banner + minimap replay

Read: Ten Laws 6, 10; Bible §14.1, §14.2, §19.3; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/wow-ui-taint-lockdown.mdc`. Lane A must be signed first.

## Exclusive files

- `addon/ChurchOfBeef/UI/Decree.lua` (create)
- `tests/test_decree_ui.lua` (create)
- `addon/ChurchOfBeef/UI/Minimap.lua`
- `tests/test_minimap.lua`
- Report: `docs/reformation/phase-5/reports/P5-B-decree-ui.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, MainFrame, Console, HUD, Records Book, Status, Toasts, Store, Runtime, Net. **Do not** add a new slash. Integrator lists `UI/Decree.lua` after it exists.

## Mission

Test-first. Isolated suite with `wow_ui_stub` + Common + Decree + Decree UI + Minimap. Wrap isolation asserts in `if standalone then`.

**Mode:** Quiet Mode theatrical parchment (Law 10). The one Quiet feature beyond minimap presence. The UI never tells jokes. No sound.

Bible §14.1: shown **once per login** as a parchment banner; thereafter reachable from the minimap. That is the entire feature.

- Paint the fixed header **A GATHERING HAS BEEN DECREED**, then `Get().line`, then optional `Get().flavor`. Do not invent a title field.
- `Init` (called from `Minimap:Init` so PLAYER_LOGIN / `UI:Init` reaches it without touching bootstrap): if `Decree:Get()` is non-nil, show the banner **once** this session. If Get is nil, stay silent — no empty parchment.
- "Once per login" is a **session** flag, not a SavedVariables key. `/reload` may show it again (PLAYER_LOGIN). Do not persist "already seen."
- Thereafter: minimap **left-click** shows the banner again when a Decree is active; when Get is nil, keep today's `UI:Toggle`. Do not add a right-click menu, a second button, or a new slash.
- Tooltip may name the Decree when one is active. Presence only. No pip, no RSVP, no countdown.
- Hard bound: no calendar, RSVP, reminders, recurrence, attendance, deputy picker.
- No Event Mode chrome. No Console / HUD / Records host from this file.

## Do not invent

Deputy UX (#5), Decree wire, SUMMON, `#8`, extra Quiet surfaces, sound, Grant/standing.

## Do not git commit.
