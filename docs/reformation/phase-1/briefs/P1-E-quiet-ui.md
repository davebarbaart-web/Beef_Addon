# Phase 1 Lane E — Standing tab, grant toasts, minimap pip

Read: `docs/reformation/phase-0/TEN_LAWS.md`, `quiet-event-modes.mdc`, Law 6. Audit V8, V9.

## Exclusive files

- Delete: `addon/ChurchOfBeef/UI/StandingTab.lua`
- Delete: `tests/test_standing_ui.lua`
- Edit: `addon/ChurchOfBeef/UI/Toasts.lua` — remove grant-driven kinds: suggest, credit, demote, excommunicate. Keep the engine. Do not invent Event Mode kinds yet (Phase 4). A leftover empty/system path that never fires in Quiet is OK if it is not a standing feed.
- Edit: `addon/ChurchOfBeef/UI/Minimap.lua` — keep the button; **delete grant/petition pip behavior**. Quiet: presence only.
- Edit: `tests/test_minimap.lua` — drop pip/grant assertions; keep button show/hide if present.
- Report: `docs/reformation/phase-1/reports/P1-E-quiet-ui.md`

**Do not** edit MainFrame, LadderTab, OfficerTab, TOC, bootstrap, `tests/run.lua`.

## Do not git commit.
