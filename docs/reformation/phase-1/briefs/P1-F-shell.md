# Phase 1 Lane F — Strip ladder/standing IA from the shell

Read: `docs/reformation/phase-0/TEN_LAWS.md`, Law 6. Audit: salvage MainFrame plumbing, discard IA.

## Exclusive files

- `addon/ChurchOfBeef/UI/MainFrame.lua` — keep drag/resize/coalesce; remove Standing / Ladder / Officer tab IA that is a guild-management window. Quiet shell: `/beef` may open a minimal frame or no-op to minimap — do not invent Director Console. No Standing/Ladder/Officer tabs.
- `addon/ChurchOfBeef/UI/LadderTab.lua` — delete the file or gut it so nothing registers. Prefer delete.
- `addon/ChurchOfBeef/UI/OfficerTab.lua` — delete or gut (officer standing correction / Dismiss). Prefer delete.
- `addon/ChurchOfBeef/UI/Status.lua` — no standing/points/grant chip.
- `addon/ChurchOfBeef/UI/Announce.lua` — no promote/excommunicate spectacle. Keep file only if it becomes a no-op stub; prefer delete if unused.
- Related tests you exclusively own if they only cover those tabs: `tests/test_ui.lua`, `tests/test_officer_ui.lua` — rewrite to not require deleted tabs, or delete if they only test standing/officer-queue.

**Do not** edit Toasts, Minimap, StandingTab (Lane E), TOC, bootstrap, `tests/run.lua`.

## Do not invent

Director Console, Decree banner, Event theater.

## Do not git commit.

Report: `docs/reformation/phase-1/reports/P1-F-shell.md`
