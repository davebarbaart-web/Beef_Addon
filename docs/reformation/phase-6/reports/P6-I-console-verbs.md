# Phase 6 Lane I — Console Post Decree + Sound callers + Hud:Refresh

**Status:** DONE

**Cited:** Ten Laws 3, 4, 6, 10; Bible §14.1, §18.1–18.2, §19.4, §20.2; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/ui-juice-standards.mdc`. Gate 5 leftover: no Console Post Decree; Sound callers unwired; Hud:Refresh not called from Console.

Writer only. Exclusive files: `UI/Console.lua`, `tests/test_console.lua`, this report. Sound.lua / Hud.lua / Decree.lua / Sender.lua / Popes.lua / TOC / bootstrap / `tests/run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / MainFrame / Minimap were not edited. No commit. Player `WTF/` not touched.

## Files written

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/UI/Console.lua` | `PostDecree`; stock Decree desk; Event-Mode `Sound:Play` after listed Core verbs; `Hud:Refresh` after Gora verbs + EndEvent. |
| `tests/test_console.lua` | Extended. Isolation asserts stay `if standalone then`. dofile `Core/Decree.lua`. Sound / Hud / DecreeBanner are stubs. |
| `docs/reformation/phase-6/reports/P6-I-console-verbs.md` | This file |

## Post Decree

`Console:PostDecree(fields)` is a Quiet desk verb on the Event Mode working tool.

- Refuses unless `Sender:IsRegisteredPope(local)` — `nil, "not the registered pope"`.
- Calls `COB.Decree:Set` (`line` required, `flavor` optional). Header **A GATHERING HAS BEEN DECREED** is UI copy, not stored.
- On success: `Refresh()`; if `COB.DecreeBanner.Show` exists, call it (Pope sees the parchment). No Sound.
- Desk: two `InputBoxTemplate` EditBoxes + `UIPanelButtonTemplate` **Post Decree**. Law 10 functional. No parchment on the desk.
- No calendar, RSVP, deputy, recurrence, attendance. No Decree wire kind. Congregation does not receive a broadcast (leftover — not invented).

## Sound callers

After a successful Core verb (`result ~= nil`), `pcall(COB.Sound.Play, Sound, name)` if `Sound.Play` exists. Missing or exploding Sound does not fail the verb.

| Verb | Cue |
|------|-----|
| Sanction | sanction |
| DeclareVictor | verdict |
| Void | verdict |
| FreeRuling | verdict |
| CowardiceRecorded | cowardice |
| ElevateToLord | elevation |
| KnightThisBeef | knighting |

Silent: Dismiss, FlagMoment, PostDecree, StartEvent, OpenRite, CloseRite, Continue, EndEvent. No auto-play on Runtime transitions. No extra cues. No Canonization.

## Hud:Refresh

After successful Sanction, DeclareVictor, CowardiceRecorded, Void, FreeRuling, and EndEvent, if `COB.Hud.Refresh` exists, call it. Console does not invent fighters, set health, or write Store Gora rows.

## Verification

- Isolated suite: **293 passed, 0 failed**.
- Lua 5.1. `lua tests/test_console.lua` exits 0.
- Isolation (standalone): no UI shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot.
- PostDecree refuses when the predicate is false; when wrapped true, sets line/flavor and does not call Sound.
- Successful Sanction / Knight / Elevate / verdict / cowardice record the matching `Sound:Play` name.
- StartEvent does not play. Successful Sanction / EndEvent call stubbed `Hud.Refresh`.
- No `GuildPromote`. No slash. No `#8` list. Core was not edited.

This lane did not edit `tests/run.lua`. The runner already lists `test_console`.

## Leftovers (other lanes — not fixed)

- **#8:** `IsRegisteredPope` stays fail-closed. Buttons exist; they do not fire on a live client.
- **Decree wire:** congregation still does not receive a posted Decree. Not invented.
- **`/beef console`:** integrator leftover. Not this file.
- **Deputy (#5), Favor, INPUT, SUMMON, GuildPromote, Notebook persist, live HUD health, fake characters, Canonization.**

## What this lane refused to invent

A Decree broadcast kind; `/beef console`; a Pope list; calendar / RSVP / deputy / recurrence / attendance; extra sound cues; Sound on Quiet PostDecree or Runtime transitions; HUD fighters / health / Store writes from UI; parchment on the Console desk; narration.

## Concerns

- `#8` still blocks a live Gathering. This lane wired callers behind the existing gate.
- Congregation Decree remains local-Pope-only until a later wire lane.
- `OPEN_QUESTIONS.md` was not edited. Do not claim V1 / MVP complete. No `POLISH:PASS`. Client `/reload` smoke and a human Gathering (Bible §22.3) are not this lane.
