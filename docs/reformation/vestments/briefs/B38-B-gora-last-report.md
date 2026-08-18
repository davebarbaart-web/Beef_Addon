# B38-B — last-pair SNAPSHOT overlay is Gora-only (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 persist is the Gora pair; B32-A HUD already forgets leftover lastPair when `riteType ~= "Gora"`; B11-A last overlay; B14-A candidate overlay. Brief `docs/reformation/vestments/briefs/B38-B-gora-last.md`. `BuildResponse` (~93–102) overlaid `GetLastSanctioned` on **any** CONSEQUENCE with fewer than two fighters. After Gora → Continue → Knighting CloseRite, the wire still carried leftover last Gora pair.

Last-pair overlay only when `snap.riteType == "Gora"`. Live `GetSanctioned` overlay stays. Candidate overlay stays B14-A (ASSEMBLY / RITE Knighting). Existing Gora CONSEQUENCE last-pair pins (~651) stay. Runtime is not mutated. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 826 passed, 0 failed (`lua tests/test_net_snapshot.lua`). Isolation wrap stays under `if standalone then` at file end (**7** nil pins: Net / Store / UI / DB / Gora / Console / Knighting). Load isolation **4**. B14-A candidate Apply isolation **3**. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_snapshot.lua` | TDD first. Appended after the B14-A block (~1033), before the isolation wrap. In-file `COB.Gora` last-pair stub. Pins: Gora empty CONSEQUENCE + `GetLastSanctioned` still overlays `{41,42}`; Knighting CONSEQUENCE + last pair stub does **not** overlay leftover fighters (wire is `encode_expected`; fighter count 0; leftover last favor omitted). Isolation wrap stays. Existing ~651 Gora last overlay pins untouched. |
| `addon/ChurchOfBeef/Net/Snapshot.lua` | Last-pair arm is `CONSEQUENCE` **and** `snap.riteType == "Gora"`. Live `GetSanctioned` overlay unchanged. B14-A candidate overlay unchanged. `ApplyResponse` unchanged. |
| `docs/reformation/vestments/briefs/B38-B-gora-last-report.md` | This file |
| `docs/reformation/vestments/briefs/B38-B-gora-last.diff` | B38-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Codec, Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add dest on Codec. Did not `dofile` Gora / Knighting / Store / UI. Did not commit.

`git diff HEAD` on these two files also includes earlier Snapshot batches (working tree already dirty). The brief diff is the B38-B-only delta.

## Contract

```lua
-- when Runtime subjects have fewer than two fighters:
--   GetSanctioned overlay stays (any live event state)
--   GetLastSanctioned overlay only when
--     snap.state == "CONSEQUENCE" and snap.riteType == "Gora"
--   do NOT overlay last pair on Knighting / Confession / other CONSEQUENCE
--   do NOT overlay last pair on ASSEMBLY (existing post-Continue refuse)
--   do NOT overlay last pair on QUIET (BuildResponse still nil, "no event")
-- B14-A candidate overlay stays ASSEMBLY / RITE Knighting
-- Runtime already has two fighters → do not replace them (existing)
```

- Overlay writes a new `subjects` table on the encode fields. `Runtime:Snapshot()` is a copy; live Runtime is not assigned.
- `usedLast` (and last favor) only set when the Gora CONSEQUENCE last overlay runs. Knighting CONSEQUENCE leftover last favor is not invented.
- Live pair still wins over last pair in Gora CONSEQUENCE when Runtime fighters are missing (existing).
- `ApplyResponse` still `Restore(bibleFields(msg))`. Favor on the wire is dropped before Restore.

## TDD

1. Extended `tests/test_net_snapshot.lua` first (Gora empty CONSEQUENCE last overlay stay; Knighting CONSEQUENCE leftover refuse + no leftover last favor; isolation wrap after stub clear). Existing ~651 Gora last pins and B14-A candidate pins untouched.
2. Red: `lua tests/test_net_snapshot.lua` — **823 passed, 3 failed.** Knighting CONSEQUENCE wire still carried leftover `41,42` and last favor `3,1`.
3. Gated last-pair overlay to `snap.state == "CONSEQUENCE" and snap.riteType == "Gora"`. Live overlay and B14-A candidate overlay untouched.
4. Green: `lua tests/test_net_snapshot.lua` — **826 passed, 0 failed.**

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_snapshot.lua   # 826 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_snapshot.lua` standalone | **826 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Existing Gora empty CONSEQUENCE last overlay (~651) still passes. B14-A candidate pins still pass. Isolation wrap: Net / Store / UI / DB nil at load; Gora / Console / Knighting stubs nilled and re-asserted at end.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). Two-client catch-up smoke was not run.

## Self-review

- Exclusive implementation files only. No new codec kind. No dest on Codec. No SUMMON. Favor is not persisted and is not Restored.
- One-line gate. Live `GetSanctioned` overlay is still ungated. B14-A candidate overlay is still ASSEMBLY / RITE Knighting.
- Existing Gora CONSEQUENCE last-pair pins (~651) and the B38-B re-pin both overlay `{41,42}`.
- Knighting CONSEQUENCE leftover last pair is encode-only refuse. Runtime stays empty.
- Isolation stays Common + Runtime + Codec + Snapshot. Stubs are in-file tables, then nilled.
- No new main-chunk locals.

## Isolated count

**826 passed, 0 failed.** Isolation wrap stays (Net / Store / UI / DB). Gora / Console / Knighting stubs cleared.

## Leftovers

- **No client / two-client smoke.** Isolated encode pin only. Gora → Continue → Knighting CloseRite whisper catch-up was not walked. Late join during a later Knighting CONSEQUENCE still needs a human pair.
- **Confession / Proclamation CONSEQUENCE leftovers are not separately pinned.** The gate is `riteType == "Gora"`; only Knighting is the named leftover refuse.
- **Gora → Continue → Knighting is not a separate sequence pin.** Fresh `OpenRite("Knighting")` + `CloseRite` plus a last-pair stub is the refuse. Same gate.
- **Live `GetSanctioned` during non-Gora CONSEQUENCE still overlays.** Brief keeps that path. Not re-pinned in the B38-B block (existing ASSEMBLY / Gora live pins stay).
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **826 / 0**. Isolation wrap **7**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
