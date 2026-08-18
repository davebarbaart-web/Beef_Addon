# B13-A — ASSEMBLY overlay ApplyResponse (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20.3 catch-up; §13.1 star; B12-A ASSEMBLY Restore; B11-A live `GetSanctioned` overlay; brief `docs/reformation/vestments/briefs/B13-A-snapshot-apply.md`.

`ApplyResponse` of B11-A's live ASSEMBLY overlay wire Restores the stub fighters and lands ASSEMBLY. Favor stays off Restore even when the overlay wire carried it. `BuildResponse` still does not mutate Runtime. Last pair is still not overlaid onto ASSEMBLY. Isolation stays Common + Runtime + Codec + Snapshot. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 640 passed, 0 failed (`lua tests/test_net_snapshot.lua`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_snapshot.lua` | TDD first. After the live-overlay encode pins: `ApplyResponse(liveWire)` is true; landed state is ASSEMBLY; fighters are `{31,32}`; `BuildResponse` leave-Runtime-empty pin; favor is nil on Restore of `liveWire` and of `liveFavWire`. Isolation wrap stays. |
| `addon/ChurchOfBeef/Net/Snapshot.lua` | **No B13-A delta.** `ApplyResponse` already `Restore(bibleFields(msg))`. B12-A already lets Runtime Restore fighters in ASSEMBLY. |
| `docs/reformation/vestments/briefs/B13-A-snapshot-apply-report.md` | This file |
| `docs/reformation/vestments/briefs/B13-A-snapshot-apply.diff` | Exclusive-pair `git diff` of `Snapshot.lua` + `test_net_snapshot.lua` (includes already-on-disk B11-A overlay hunks plus this lane's Apply pins) |

Did not edit Runtime, Codec, Gora, glue, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not `dofile` Gora / Store / UI. Did not commit.

## Contract

```lua
-- B11-A already encodes live GetSanctioned onto ASSEMBLY SNAPSHOT when
-- Runtime subjects lack two fighters.
-- ApplyResponse(liveWire) == true
-- landed.state == "ASSEMBLY"
-- landed.subjects.fighters == stub ids
-- BuildResponse does not mutate Runtime
-- landed.favor == nil   -- favor is not a Bible field
-- last pair is not overlaid onto ASSEMBLY
```

- `ApplyResponse` still `Restore(bibleFields(msg))`. Bible fields: `eventId` / `state` / `riteType` / `subjects` / `sequence`.
- Favor on the wire is dropped before Restore.
- Last pair remains CONSEQUENCE-only (existing pin 4). This lane does not overlay last pair onto ASSEMBLY.

## TDD

1. Extended `tests/test_net_snapshot.lua` first (Apply of `liveWire` + Apply of favor-carrying `liveFavWire`; BuildResponse unchanged pin immediately before the Apply block).
2. Green without a Snapshot.lua change: `lua tests/test_net_snapshot.lua` — **640 passed, 0 failed**.
3. B12-A already opened ASSEMBLY Restore. `ApplyResponse` already Restores Bible fields only. No production edit this lane.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_snapshot.lua   # 640 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_snapshot.lua` standalone | **640 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Isolation wrap: Net / Store / UI / DB nil at load; Gora / Console stubs nilled and re-asserted at end. `COB.Net` / Store / UI still nil.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). Two-client catch-up smoke was not run.

## Self-review

- Exclusive implementation files only. No new codec kind. No last-pair overlay on ASSEMBLY. Favor is not Restored.
- `Snapshot.lua` `ApplyResponse` is unchanged. The pin is the missing ASSEMBLY land (B11-A Applied CONSEQUENCE / RITE overlays only).
- Isolation stays Common + Runtime + Codec + Snapshot. Stubs stay in-file, then nilled.

## Isolated count

**640 passed, 0 failed.** Isolation wrap stays (Net / Store / UI / DB). Gora / Console stubs cleared.

## Concerns

- **`Snapshot.lua` has no B13-A hunk.** The exclusive-pair diff still contains the B11-A `BuildResponse` overlay (already on disk). This lane only added the Apply pin. Restore of ASSEMBLY fighters is B12-A Runtime law, not a Snapshot rewrite.
- **Pope verbs still wipe subjects.** `StartEvent` / `Continue` still write empty Runtime fighters. Congregation Restore of the overlaid ASSEMBLY wire now lands `{31,32}`. The Pope writer's live Runtime stays empty until `OpenRite`.
- **No client / two-client smoke.** Isolated suite only. Sanction-before-`OpenRite` catch-up still needs a human pair.

## Status

**DONE_WITH_CONCERNS.** Isolated **640 / 0**. Not signed.
