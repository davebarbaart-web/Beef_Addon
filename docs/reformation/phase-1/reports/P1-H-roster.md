# Phase 1 Lane H — Roster cut (sensing only)

**Status:** DONE

**Cited:** Ten Laws 1, 7, 9; Bible §5, §12; brief `docs/reformation/phase-1/briefs/P1-H-roster.md`; `GATE1_DESIGN_LEAD_DIRECTIVE.md` §2–3.

Guild-roster sensing kept (names, `guildRankIndex`, completeness, local-player seed). Members stay when `ChurchRankIdForGuildIndex` is nil. No Church-id map invented. No Presence desk, display-vs-truth reconcile, or Church store.

Dead engines deleted: `GetLadderView`, `SweepDeparted` caller, `ClearSatisfiedSuggestions`, Ladder standing merge. No standing field. No history prune.

**Not edited (per brief):** TOC, `ChurchOfBeef.lua`, `tests/run.lua`, MainFrame, Officer, BeefNet, DB.

**No commit made.** `OPEN_QUESTIONS.md` unchanged.

## Files written

- `addon/ChurchOfBeef/Core/Roster.lua` — cut
- `tests/test_roster.lua` — rewrite to the sensing contract; does not `dofile` Ladder/Scoring
- `docs/reformation/phase-1/reports/P1-H-roster.md` — this report

## Kept

`NameKey`, `IsReady`, `IsComplete`, `GetGeneration`, `GetOccupantCount`, `GetChurchRankId` (nil this phase), `GetGuildRankIndex`, `HasMember`, `SetOnChanged`, `AttachLibrary`, `Refresh` (lib → API → local-player seed; empty update does not wipe a good snapshot; leave-guild clears the live snapshot only), `ResetForTests`. Officer `rosterCache` write stays so Net/Officer sensing still has a walk.

## Removed

| Symbol | Why |
|--------|-----|
| `GetLadderView` | Standing-shaped row merge; ClassColorCode walk is the UI leftovers lane |
| `ClearSatisfiedSuggestions` | Suggestion engine is dead (Lane B) |
| `sweepDeparted` / `sweptDeparted` | Law 7 — no departed-member history prune |

## Verification

Isolated `tests/test_roster.lua` (Common + Ranks + Roster, ranks-style load): **46 passed, 0 failed.**

`lua tests/run.lua`: **374 passed, 2 failed.** Failures are other-lane suites that still `dofile` deleted `Core/Ladder.lua`. Did not edit `tests/run.lua`.

## Leftover callers (not fixed)

### Deleted APIs

| File | Call |
|------|------|
| `addon/ChurchOfBeef/UI/MainFrame.lua:209` | `ClassColorCode` walks `Roster:GetLadderView` (guarded; now always `{}`). P1-L owns this cut. |

`UI/Status.lua` no longer calls `GetLadderView` (uses `IsReady` only).

### Other lanes (saw, did not touch)

| File | What remains |
|------|----------------|
| `tests/test_net_validate.lua:11` | `dofile("addon/ChurchOfBeef/Core/Ladder.lua")` — harness abort |
| `tests/test_net_adversarial.lua:14` | same `dofile` — harness abort |

Officer and BeefNet still call kept sensing (`Refresh`, `IsReady`, `IsComplete`, `HasMember`, `AttachLibrary`, `SetOnChanged`). Those are not leftover deleted-API callers.

## Concerns

- Roster presence may stay empty of Church ids until the display-vs-truth rework. This lane does not invent that map (directive §2).
- `churchRankId` is still stored as the stub result (`nil`). That is not a map.
- Human `/reload` smoke is owner David (directive §3e). Not claimed here.
