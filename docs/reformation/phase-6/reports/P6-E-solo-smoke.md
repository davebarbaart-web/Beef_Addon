# Phase 6 Lane E — Solo-smoke rewrite

**Status:** DONE

**Cited:** Ten Laws 1, 6, 9; Bible §14.1–14.2, §18, §19.1, §20, §22.3;
honesty pattern of `docs/phases/v1-checklist.md` and
`docs/phases/dress-rehearsal.md`. Product snapshot 2026-08-15: `/beef` and
minimap (no Decree) open the Records Book; Decree banner if `Decree:Get()`
is set; slash is `/beef`, `/beef minimap`, `/beef console` (OPEN_QUESTIONS
#11); `InspectProgress()` is owner inspection only; schema 7; Fight HUD
only for a real sanctioned pair; Pope list empty until David adds a name
(`Data/Popes.lua` or `ChurchOfBeefDB.ui.popeOverrides` — P6-H in parallel).

Human single-client walk only. All boxes `[ ]`. Appendix A Results not
filled. Addon Lua / TOC / tests / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md`
/ other phase docs / validation sheets not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `docs/phases/solo-smoke.md` | Replaced in place. Quiet Tuesday + hosted surfaces. All boxes `[ ]`. Status **NOT RUN**. |
| `docs/reformation/phase-6/reports/P6-E-solo-smoke.md` | This file |

## What was replaced

The previous file was a **roster-backed V1 ladder smoke**. It cited
`docs/superpowers/specs/2026-07-25-roster-backed-ladder-design.md` as law
and walked a deleted product:

- `/beef` as a Ladder-default frame
- Guild-rank → Beef Prophet band map
- Large-guild Find / `+N more` / 10-row Officer pool
- Officer tab standing correction, Grant-adjacent thresholds, promote
  suggestions, edge toasts
- Blizzard guild-roster promote as the rank-move path
- Dismiss-suggestion / non-officer Officer-tab gates
- Pass/fail that treated empty ladder, Commit/Approve rites, and
  suggestion-vs-promote as the product

That walk is deleted. The archived ladder spec is not cited as law.

## What the new smoke is

A one-client Anniversary walk of shipped Quiet Tuesday and the hosted
surfaces, before two-client and dress rehearsal. Not a Gathering. Not MVP
done.

Structure:

1. **Purpose / law / install** — Bible + Ten Laws; church-of-beef-dev
   skill; never `WTF/`.
2. **Honesty table** — Records Book on `/beef`; Decree hidden until Set;
   Console slash; empty Pope list; HUD not this walk; `InspectProgress`
   named as `/run` only.
3. **Preconditions** — harness green, `_anniversary_` AddOns, `scriptErrors 1`.
4. **Walk 1–8** — load; Quiet Tuesday; Records Book; minimap hide/show;
   Decree `/run` (Console Post if present); `/beef console` refuse-unless-listed;
   `InspectProgress` Goldshire + Book + Console + one sanction cue + QUIET,
   no Store Gora rows; combat `/beef` taint check.
5. **Out of scope / pass-fail / leftovers** — Bible product, not the
   deleted ladder.

Tick instruction matches the checklist: `[x]` plus `— YYYY-MM-DD, character`.
No box is ticked in this authoring pass. No Appendix A Results block.

## Bible sections used

| Section | How the smoke uses it |
|---------|------------------------|
| §14.1 | Decree: one line + optional flavor; banner once per login; minimap replay; no calendar / RSVP |
| §14.2 | Tuesday: almost nothing + Decree; player-opened identity/history is the Records Book |
| §18 | Director Console as stock desks; software never auto-announces or auto-advances |
| §19.1 | Quiet chrome is minimap + active Decree only |
| §20 | `InspectProgress` StartEvent / EndEvent returns to QUIET; not a hosted night |
| §22.3 | Named as later (Gathering / dress rehearsal). This file does not claim done |

Ten Laws 1 (no points / Grant / standing), 6 (Quiet), 9 (six ranks, no
Prophet) are the refuse list for leftover chrome.

## What the script refused to invent

| Temptation | Why refused |
|------------|-------------|
| Tick any walk box or date a pass | Brief: humans tick later |
| Appendix A Results | Lane A / David. Not this file |
| Fight HUD as a solo-smoke beat | Needs a real sanctioned pair. No fake Store rows |
| A Pope character name | Empty shipped list. David adds his own |
| Console Post as the official path | Not on stock desks. `/run` named; Post only "if present" |
| Grant / standing / Prophet / Officer tab | Deleted product |
| `/beef` as empty shell or Ladder | Current product opens the Records Book |
| V1 complete / `POLISH:PASS` / CurseForge | Out of scope |

## Leftovers named (not fixed)

1. Pope list empty until David adds a name — rituals refuse (P6-H path
   named, not stubbed true).
2. No Console Post on the stock desks.
3. Fight HUD / live health — sanctioned pair + Appendix A item 1.
4. Favor, SUMMON, INPUT / Confession.
5. Sound callers unwired except the one `InspectProgress` `sanction` Play.
6. Two-client star, dress-rehearsal chaos, §22.3 Gathering.
7. Other phase docs (`v1-checklist.md`, `dress-rehearsal.md`,
   `two-client-smoke.md`) still carry older honesty in places. Out of lane.

## Verification

- Exclusive files only. No addon Lua, TOC, tests, validation sheets,
  `OPEN_QUESTIONS.md`, `REFORMATION_LOG.md`, or other `docs/phases/` files.
- `solo-smoke.md` has no `[x]` boxes and no dated pass. Status line is
  **NOT RUN**.
- No Appendix A Results filled.
- No Grant / standing / Prophet / Officer-tab success boxes.
- No claim that the HUD appears without a sanctioned pair.
- Player `WTF/` not touched. No git commit.

## Concerns

- `v1-checklist.md` and `dress-rehearsal.md` still describe `/beef` as an
  empty shell and omit `/beef console`. This lane did not edit them.
  A human who opens those files first will read stale host language.
- `two-client-smoke.md` is still the deleted petition / standing walk.
  This smoke points at it as "do this before" the next phase file, not as
  law.
- P6-H may land `Data/Popes.lua` in parallel. The smoke treats an empty
  list as refuse-is-the-pass and tells David to add **his** character.
  It does not invent a name or stub the predicate.
