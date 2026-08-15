# Phase 6 Lane G — Guild-night playtest rewrite

**Status:** DONE

**Cited:** Bible §7, §14.1, §18, §20, §22.3; Ten Laws 1, 4, 5, 6, 8; companions `docs/phases/dress-rehearsal.md` (chaos night) and `docs/phases/v1-checklist.md` (§22.3 walk). Product honesty 2026-08-15: Quiet Tuesday + hosted Records / Decree / Console; rituals refuse until the Pope character is listed; Fight HUD needs a real sanctioned pair; no favor; no SUMMON; `#8` Council designation still open; A01–A04 Results NOT RUN (owner David).

Human guild-night prep only. Small Gathering attempt after solo-smoke + two-client-smoke. Not the streamed MVP. Not a second dress rehearsal. All boxes `[ ]`. Addon Lua / TOC / tests / `dress-rehearsal.md` / `v1-checklist.md` / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `docs/phases/guild-night-playtest.md` | Replaced in place. Roster-backed Score Desk night deleted. Small Gathering prep. All boxes `[ ]`. |
| `docs/reformation/phase-6/reports/P6-G-guild-night.md` | This file |

## Mission

Rewrite the guild-night file as prep for a small real Gathering (Bible §7 / §4.11 Tuesday floor). Point at the signed companions. Stay honest about what this checkout cannot walk. Do not invent a pass path that fakes Store Gora rows.

## What the script is

A Pope-client + congregation-client night. Floor is two Anniversary clients in the same guild.

Structure:

1. **Purpose / law / companions** — live guild night after the two smokes; Bible + Ten Laws + install skill; never `WTF/`; `v1-checklist.md` is the §22.3 walk; `dress-rehearsal.md` is the five deliberate failures.
2. **Honesty (2026-08-15)** — hosted Records / Decree / Console; listing gate; HUD pair contract; leftovers named.
3. **Facilitators** — Pope (David) + one congregation client. No Score Desk.
4. **Preconditions** — harness green; two clients; Pope listed; Decree posted; `scriptErrors` 1; prior smokes as load/presence only.
5. **Night goals** — assembly under a Decree; Knighting if earned; sanctioned Gora with HUD if a real pair exists; records persist; Quiet before and after.
6. **Walk** — Quiet → Assembly → Knighting (or skip) → Gora (or skip) → Close. Bible-expect vs tonight on each beat.
7. **Capture** — human-observable yes/no. No standing Δ, threshold, Score Desk, instance drip, or Cooked eligibility points.
8. **Research rule** — expand only on a Bible contradiction; orchestrator appends `OPEN_QUESTIONS.md`.

## What was cut

- Roster-backed standing, Score Desk, Cooked eligibility points, suggestion fanout
- Newbie standing Δ / Cooked-50 / Knight-200 targets
- Instance / Ceremony / Gora source-mix and daily caps
- Suggestion → guild-promote latency
- Ladder honesty / Spectacle Watcher / Night Lead
- Research playbook `docs/research/wow-classic-addon-design/51-guild-night-playbook/` as law
- Archived roster amendment / parent design spec §15 as law
- Retune-thresholds-in-`Data/Ranks.lua` after-night chore
- Dreamscythe vs Doomhowl independent-ladder nights
- The five dress-rehearsal failures (pointed at, not copied)

## What the script refused to invent

| Temptation | Why refused |
|------------|-------------|
| Fake Store Gora rows / `InspectProgress` as the night | HUD and Records would look full without a Gathering |
| Stub `IsRegisteredPope` / treat the name “Pope” as listed | Codes around the listing gate |
| `/run Decree:Set` so a banner appears | Invents Console Post |
| Favor vote via raid marks, whispers, or `/s` tallies as product | Invents favor |
| SUMMON ping / gathering-point message | Invents stretch-MVP protocol |
| Tick any walk box or Status: NOT RUN | Brief: humans tick later with date + character |
| Walk A01–A04 Results | Owner David; **NOT RUN** |
| Designated-Council UX | `#8` still open |
| Claim V1 / MVP complete if the small night goes well | §22.3 is the streamed Gathering on `v1-checklist.md` |
| Duplicate late arrival / reload / Pope disconnect / no-show / disputed Gora | That script is `dress-rehearsal.md` |

## Verification

- Exclusive files only. No addon Lua, TOC, tests, `dress-rehearsal.md`, `v1-checklist.md`, `OPEN_QUESTIONS.md`, or `REFORMATION_LOG.md`.
- `guild-night-playtest.md` has no `[x]` boxes and no dated pass. Status line is **NOT RUN**.
- Capture table has no standing Δ, threshold, Score Desk, instance drip, or Cooked eligibility.
- Five chaos failures are a pointer, not a second script.
- `#8` listing is a precondition, not a stub. Favor, SUMMON, live health, and A01–A04 stay leftover.
- Player `WTF/` not touched. No git commit.

## Leftovers (other lanes / David — not fixed)

- **P6-E / P6-F:** `solo-smoke.md` and `two-client-smoke.md` may still describe the deleted ladder until those lanes land. This night points at them as prior smokes and tells humans not to walk Score Desk boxes here.
- **P6-H:** `Data/Popes.lua` + Sender read of the list / `popeOverrides`. This night requires the Pope listed; it does not create the file.
- **P6-I:** Console Post Decree, Sound callers, `Hud:Refresh`. This night forbids `/run Decree:Set`.
- **David:** A01–A04 Results stay **NOT RUN**.
- **`#8` Council designation:** still open. Orchestrator appends `OPEN_QUESTIONS.md` if a walked night finds a Bible contradiction. This lane did not edit that file.
- **Favor, SUMMON, live HUD health:** still leftover. Do not invent them so this night can pass.

## Concerns

- A guild can walk Quiet, a posted Decree, and the human Gathering tonight. Rituals still refuse until the Pope character is listed. The script says stop — not stub.
- If Console Post is leftover on the checkout, the Decree precondition stays unchecked. Do not manufacture a banner.
- If no one has earned Knighting, or no real Gora pair exists, those sections skip. That is honest, not a fail.
- Congregation theater still requires Pope-originated STATE. A local Console on the Pope client is not congregation theater.
- Do not claim V1 / MVP complete. Do not claim `POLISH:PASS`. The streamed Gathering remains the definition of done.
