# Phase 6 Lane C — Dress-rehearsal script

**Status:** DONE

**Cited:** Ten Laws 4, 5, 6; Bible §22.3, §20.4, §20.1–20.3, §7, §10, §18; `.cursor/rules/ceremony-runtime.mdc` (Chaos test); brief `docs/reformation/phase-6/briefs/P6-C-rehearsal.md`. Gate 5 is closed.

Human run-of-show only. Guild-only, unstreamed. Five deliberate failures, on purpose. Shipped skeleton vs leftover marked honestly. No `#8`, no SUMMON protocol, no favor channel, no hosted Console invented so the script can pass. Rehearsal not ticked done. Addon Lua / TOC / tests / `docs/validation/**` / `docs/phases/v1-checklist.md` / `OPEN_QUESTIONS.md` not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `docs/phases/dress-rehearsal.md` | Created. Human run-of-show + leftover map + five failures. All boxes `[ ]`. Release gate **NOT RUN**. |
| `docs/reformation/phase-6/reports/P6-C-rehearsal.md` | This file |

## Mission

Author the dress rehearsal the Bible names as the public-release gate (§22.3): late arrival, UI reload, disconnect including the Pope’s, no-show petitioner, interrupted or disputed Gora. Quality bar from §20.4 / the ceremony-runtime rule: a confused client is acceptable for five seconds and embarrassing for thirty — observational, not a coded timeout, not `holdSeconds`.

## What the script is

A Pope-client + congregation-client night. Floor is two Anniversary clients in the same guild. More bodies preferred (live-event failures need a crowd).

Structure:

1. **Honest map** — what Gate 5 actually shipped vs leftover (`#8`, unhosted Console / HUD / Records, no Post, unwired Sound, no favor, no SUMMON, INPUT codec-only).
2. **Night 0** — Quiet / install walk the skeleton can prove (minimap, empty `/beef`, HELLO, fail-closed theater).
3. **Nights 1–3** — Assembly, Knighting, Gora as human staging, each beat tagged Bible-expect vs tonight.
4. **Five failures** — human action, Bible expect, tonight leftover, scribe timing blanks. Unticked.
5. **Close / next morning** — persist and Records Book leftover named.
6. **Release-gate pass** — the §22.3 block, explicitly **NOT RUN**, with a line that the current skeleton cannot satisfy it.

Pre-reformation `solo-smoke.md` / `two-client-smoke.md` / `guild-night-playtest.md` are pointed at as the deleted points ladder — not this night. Offline `test_ceremony_chaos.lua` is named as a precondition, not a substitute.

## What the script refused to invent

| Temptation | Why refused |
|------------|-------------|
| `/run Console:Toggle` / `Runtime:StartEvent` as the official path | Invents a hosted Console so the night can “pass” |
| `/run Decree:Set` so a banner appears | Invents Console Post |
| Stub `IsRegisteredPope` true / add `Data/Popes.lua` | Codes `#8` |
| Favor vote via raid marks, whispers, or `/s` tallies as product | Invents favor |
| SUMMON ping / gathering-point message | Invents stretch-MVP protocol |
| Tick Release gate or any walk box | Brief: do not tick the rehearsal as done |
| Hold-timer seconds for “awaiting the Pope” | §20.4 is a quality bar, not a constant |
| Treat local SV Decree on a congregation client as canonical theater | GATE5 leftover; not Pope-originated STATE |

## Shipped vs leftover (as written)

**Shipped skeleton the night can actually exercise:** Quiet minimap + empty `/beef`; Decree banner only if account SV already holds a line; HELLO presence; Core machines exist and do not auto-advance or auto-declare; event/store/decree persist hooks; combat is WoW’s by absence.

**Leftover the night must not fake:** `#8` fail-closed rituals and STATE / SNAPSHOT; unhosted Console / HUD / Records; no Console Post; unwired Sound; no favor; no SUMMON; no live INPUT; no guild promote from Core; no `MarkPopeLost` caller or degrade paint.

## Verification

- Exclusive files only. No addon Lua, TOC, tests, validation sheets, `v1-checklist.md`, or `OPEN_QUESTIONS.md`.
- `dress-rehearsal.md` has no `[x]` boxes and no dated pass. Status line is **NOT RUN**.
- Five failures are present by name and match §22.3 / §20.4 / the brief.
- `#8`, SUMMON, favor, and a hosted Console are named leftover, not supplied as a pass path.
- Player `WTF/` not touched. No git commit.

## Leftovers (other lanes — not fixed)

- Lane B owns `docs/phases/v1-checklist.md` and should point here. This lane did not edit that file.
- Lane A owns `docs/validation/**`. This script does not invent Appendix A results.
- Product leftovers stay product leftovers. This lane does not host Console / HUD / Records, wire Sound, or code `#8`.

## Concerns

- A guild can walk Night 0 and the human Gathering tonight. They cannot pass the Release-gate block on this skeleton. The script says so in the map, in each leftover beat, and on the gate itself.
- Paper-prototype console notes are allowed as scribe work and are explicitly **not** this rehearsal (§22.3 pre-code validation is a different gate).
- Do not claim V1 / MVP complete. Do not claim `POLISH:PASS`. A human Gathering on stream remains the definition of done.
