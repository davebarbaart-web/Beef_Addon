# Phase 4 Lane E — Director Console (stock desks)

**Status:** DONE

**Cited:** Ten Laws 3, 4, 6, 10; Bible §18.1–18.3, §20.2, §8, §10.6, §19.3; `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/wow-ui-taint-lockdown.mdc`; brief `docs/reformation/phase-4/briefs/P4-E-console.md`. Lanes C and D are signed.

Pope working tool. Stock-template functional desks. Not Quiet congregation chrome. Not theatrical parchment. The UI never tells jokes. No narration. Ritual verbs call signed Core only when `Sender:IsRegisteredPope(local)` is true — always false today; the list was not stubbed true. No TOC / bootstrap / `tests/run.lua` / MainFrame / Minimap / Toasts / Runtime / Gora / Knighting / Store / Net / `OPEN_QUESTIONS.md` edits. No `Data/Popes.lua`. No slash. No `GuildPromote`. No Notebook persist. No HUD / Records / Decree / favor / INPUT. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | Created first. Isolated suite: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Console. Isolation asserts wrapped in `if standalone then`. |
| `addon/ChurchOfBeef/UI/Console.lua` | Created after the suite. Stock desks + gated one-click verbs. |
| `docs/reformation/phase-4/reports/P4-E-console.md` | This file |

`Data/Ranks.lua` is dofiled in the suite only so Store / Knighting titles resolve. Roster is not loaded; Presence tests install a table stub.

## Mode

`COB.Console.MODE = "event"` — Event Mode Pope working tool (Bible §18, §20.2). `/beef` stays the Quiet empty shell. This frame is `Toggle` / `Show` / `Hide` only.

## Desks

| Desk | Role |
|------|------|
| Presence | Display from Roster (who's here) + Store (Church rank, needs-Knighting). Copies. Unlinked roster names are here with no invented rank. |
| Knighting | `KnightThisBeef` / `ElevateToLord` with a caller-supplied human id. No queue store, targeting, or raid markers. |
| Gora | Petitions (present-and-alive from roster name → character id), Sanction, Dismiss, DECLARE VICTOR, COWARDICE RECORDED, VOID, FREE RULING. |
| MARK THIS MOMENT | `Store:FlagMoment`. No location picker. |
| Notebook | Disabled label only. No notes table. |

Runtime one-clicks on this desk: `StartEvent` (zero-config Tuesday start — no event-setup fields), `OpenRite` for the four named types, `CloseRite`, `Continue`, `EndEvent`. No EditBoxes.

## Gate

`Sender:IsRegisteredPope` of the local player. Missing Sender is refuse. Expected failure is `nil, "not the registered pope"`. Buttons exist for the harness; they do not fire on a live client. The suite wraps the predicate in one section to prove the true branch, then restores it. That is not a Pope list.

## Verification

- Isolated suite: **215 passed, 0 failed**.
- Lua 5.1.5. `lua tests/test_console.lua` exits 0.
- No `GuildPromote` / `SetGuildRank`. No slash. No `CreateFrame` in Core. No `Data/Popes.lua`.
- No `dofile` of MainFrame / Minimap / Toasts / DB / Net / Officer / Archive / Recognition / Roster / Hud / RecordsBook / TOC / bootstrap / `tests/run.lua`.

This lane did not edit `tests/run.lua`. The runner will report `test_console` as unlisted until the integrator lists it. Do not treat that as a product miss.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `UI/Console.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_console` to `tests/run.lua`. Do not wire a slash; `/beef` stays the Quiet shell.
- **#8:** registered-Pope list still always false. Console is fail-closed until that list exists.
- Knighting queue, targeting assist, raid markers, guild-rank promotion where the API permits, proclamation, stipulation line, Notebook persist, Fight HUD, Records Book, Decree, favor / INPUT.

## Concerns

- Anyone who can call `COB.Console` verbs still hits the Sender gate. The gate is the fail-closed predicate, not a workspace Pope file.
- Presence without a live Roster is empty. That is display, not a ritual gate.
- `OPEN_QUESTIONS.md` was not edited. Do not claim V1 / MVP complete. Client smoke and a human Gathering (Bible §22.3) are not this lane. No `POLISH:CANDIDATE` — the file is not in the TOC and was not `/reload` smoked.
