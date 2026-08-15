# Phase 4 Lane E — Director Console (stock desks)

Read: Ten Laws 3, 4, 6, 10; Bible §18.1–18.3, §20.2, §8, §10.6; `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/wow-ui-taint-lockdown.mdc`. Lanes C and D are signed.

## Exclusive files

- `addon/ChurchOfBeef/UI/Console.lua` (create)
- `tests/test_console.lua` (create)
- Report: `docs/reformation/phase-4/reports/P4-E-console.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, MainFrame, Minimap, Status, Toasts, Runtime, Gora, Knighting, Store, Net. **Do not** create `Data/Popes.lua`. **Do not** add a new slash. Integrator lists the file after it exists.

## Mission

Test-first. Isolated suite with `wow_ui_stub` + Common + Runtime + Store + Gora + Knighting + Console. Wrap isolation asserts in `if standalone then`.

**Mode:** Pope working tool (Law 10 **functional** / stock templates). Not Quiet congregation chrome. Not theatrical parchment. The UI never tells jokes. No narration.

Bible desks only: **Presence** (who's here / ranks / needs-Knighting from Roster + Store — display), **Knighting** (buttons call `KnightThisBeef` / `ElevateToLord` with a caller-supplied human id — do not invent a queue store), **Gora** (petitions, Sanction, verdict buttons), **MARK THIS MOMENT** (`Store:FlagMoment`). **Notebook** persist is unspecified — do not invent a notes table; omit the desk or show a disabled label.

- `Toggle` / `Show` / `Hide` only. No new slash. `/beef` stays the Quiet empty shell.
- Ritual verbs run only when `Sender:IsRegisteredPope` of the local player is true. Today that is always false — buttons exist for the harness, they do not fire on a live client. Do not stub the list true.
- `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent` are one-click Runtime verbs on this desk. Zero-config Tuesday start = `StartEvent` with no event-setup fields.
- No auto-advance. No generated proclamation text. No `GuildPromote`.
- No favor bar, INPUT channel, HUD, Records Book, or Decree in this file.

## Do not git commit.
