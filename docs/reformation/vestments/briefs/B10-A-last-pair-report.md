# B10-A — Gora last pair / last favor (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 persist through verdict; §13.1 star; license 2 favor on STATE; brief `docs/reformation/vestments/briefs/B10-A-last-pair.md`. Review must-fix: last pair is event-scoped.

`GetLastSanctioned` / `GetLastFavorSplit` snapshot the pair and then-current favor split on successful `clearLive` (victor / cowardice / void / free). `lastSanctioned` stores `eventId` for expire. `GetSanctioned` stays nil after a ruling. `GetFavorSplit` stays `{0,0}` without a live pair. New `Sanction` nils last. `_Expire` wipes last when there is no event **or** when `lastSanctioned.eventId ~=` the live event id (same pattern as `favorEventId`). Ruling → EndEvent → StartEvent with no GetLast in QUIET → first GetLast of the new event is nil / `{0,0}`. Memory-only. Never SV. Famous Upsets stay not computed. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 505 passed, 0 failed (`lua tests/test_gora.lua`). **10** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_gora.lua` | TDD first, then review must-fix pin: DeclareVictor → EndEvent → StartEvent with **no** GetLast in QUIET → `GetLastSanctioned` nil and `GetLastFavorSplit` `{0,0}`. Existing last-pair / Famous Upsets / isolation pins stay. |
| `addon/ChurchOfBeef/Core/Gora.lua` | `clearLive` snapshots `eventId` on `lastSanctioned`. `_Expire` calls `wipeLast()` when a live event id exists and `lastSanctioned.eventId ~= eventId`. Getter copies stay ids only. |
| `docs/reformation/vestments/briefs/B10-A-last-pair-report.md` | This file (updated after Spec FAIL) |
| `docs/reformation/vestments/briefs/B10-A-last-pair.diff` | B10-A-only unified diff of the exclusive implementation files vs the pre-lane working tree (not regenerated this pass) |

Did not edit Hud, glue, Codec, TOC, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Gora:GetLastSanctioned()   -- { fighterA, fighterB } or nil
Gora:GetLastFavorSplit()   -- { a = n, b = n }; missing → {0,0}
```

- Snapshot only on successful `clearLive`. Compute the split before nilling `sanctioned`.
- Internal last row stores `eventId`. Getter copies do not leak it (ids only; no stipulation).
- Successful new `Sanction` nils last so STATE does not keep the old bout once a new one is live.
- `_Expire` with no event **or** `lastSanctioned.eventId ~=` live event id wipes last pair + last split.
- `GetFavorSplit()` with no live pair stays `{0,0}`. Do not auto-set `famousUpset`.

## TDD

1. Extended `tests/test_gora.lua` first (API, DeclareVictor last ids + pre-ruling split, new Sanction nils last, QUIET expire, ResetForTests, copies, Famous Upsets / isolation pins stay).
2. Red: `lua tests/test_gora.lua` — `GetLastSanctioned` nil (`attempt to call method 'GetLastSanctioned' (a nil value)`).
3. Added last locals, `clearLive` snapshot, wipe on expire / Sanction / ResetForTests, getters.
4. Green: `lua tests/test_gora.lua` — **493 passed, 0 failed**.
5. Spec FAIL: last pair was not event-scoped. Added StartEvent pin (no GetLast in QUIET). Red without `eventId` + mismatch wipe. Snapshot `eventId` in `clearLive`; `_Expire` wipes when `lastSanctioned.eventId ~= eventId`.
6. Green: `lua tests/test_gora.lua` — **505 passed, 0 failed**. StartEvent pin holds.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_gora.lua   # 505 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_gora.lua` standalone | **505 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**StartEvent pin:** DeclareVictor → EndEvent → StartEvent with no Gora GetLast in QUIET → `GetLastSanctioned()` nil, `GetLastFavorSplit()` `{0,0}`. Same-event last still holds before EndEvent. `GetSanctioned` nil after ruling. `GetFavorSplit` `{0,0}` without a live pair. Famous Upsets not computed.

**Isolated count:** 10 pins under `if standalone then` at file load (Net, UI, DB, Officer, Archive, Recognition, Popes, Sender, Codec, Snapshot). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run. Hud, glue, and Codec were not edited.

## Self-review

- Exclusive implementation files only. Getters still return copies. Expected failures are `nil, err`.
- Snapshot sits inside `clearLive`, after both Store writes succeed. Failed / refused rulings do not invent last.
- `eventId` is stored on the internal last row only. `GetLastSanctioned` still copies `fighterA` / `fighterB`.
- Source has no `famousUpset` write. No Narrate. Favor map is unchanged; last split is a separate memory snapshot.
- Isolation asserts stay under `if standalone then`.

## Isolated count

**505 passed, 0 failed.** Isolation wrap: **10**.

## Concerns

- **Last pair is ids only.** `GetLastSanctioned` copies `fighterA` / `fighterB`. No stipulation. `eventId` is internal. B10-INT / HUD must not expect a decree line on last.
- **New Sanction nils last immediately.** Same-pair re-sanction also wipes. STATE drops the previous bout as soon as a new Sanction succeeds, not at the next `clearLive`.
- **GetLast\* call `_Expire`.** Reading last after EndEvent / QUIET still nils it. The StartEvent pin now covers the production leak (no GetLast in QUIET). Glue must still read last while the event is live if it needs the pair for STATE.
- **`{0,0}` is both missing and empty.** Distinguish via `GetLastSanctioned() == nil`. Live `GetFavorSplit` stays `{0,0}` without a pair even when last split is non-zero.
- **Unrulied expire does not snapshot.** `_Expire` with no event (or a live event whose `sanctioned.eventId` mismatches) clears the live pair without `clearLive`. Last is not invented. A prior same-event last stays until event-id mismatch / no-event expire / new Sanction / ResetForTests.
- **Favor map still survives Void** (existing pin). Last split is a separate snapshot computed before the pair is nilled.
- **Nested `runLastPair`.** Extra locals live in a helper. Isolation wrap was not moved.
- **`.diff` not regenerated** this must-fix pass. Report + exclusive implementation files are the source of truth.
- **No client smoke / full harness / glue.** Memory-only Core. B10-B / B10-C / B10-INT own persist paint and `stateFields`.

## Status

**DONE_WITH_CONCERNS.** Isolated **505 / 0**. Isolation wrap **10**. StartEvent pin holds. Not signed.
