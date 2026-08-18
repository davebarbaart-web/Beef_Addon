# B11-A — SNAPSHOT last pair / last favor (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20.3 catch-up; §13.1 star; §10.7 persist through verdict; license 2 favor on SNAPSHOT while the Pope toggle is on; brief `docs/reformation/vestments/briefs/B11-A-snapshot.md`.

`BuildResponse` overlays live `GetSanctioned` / last `GetLastSanctioned` (CONSEQUENCE only) onto the **encoded** SNAPSHOT when Runtime subjects lack two fighters. Favor rides the wire only when `Console:GetCongregationFavorVisible() == true` and the outbound subjects name two fighters. Runtime is not mutated. `ApplyResponse` still Restores Bible fields only (`eventId` / `state` / `riteType` / `subjects` / `sequence`). Favor is not a Bible field and stays off Restore. QUIET stays `nil, "no event"`. Isolation stays Common + Runtime + Codec + Snapshot. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 610 passed, 0 failed (`lua tests/test_net_snapshot.lua`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_snapshot.lua` | TDD first. Appended after the closed-set block. In-file `COB.Gora` / `COB.Console` stubs; cleared before isolation wrap. Pins: no Gora / missing methods = `encode_expected`; live pair + ASSEMBLY + empty Runtime fighters; last pair + CONSEQUENCE + toggle on/off; post-Continue ASSEMBLY does not overlay last; Runtime two fighters are kept; `ApplyResponse` of overlay Restores fighters, not favor. Existing `assert_eq(wire, encode_expected(snap))` pins stay. |
| `addon/ChurchOfBeef/Net/Snapshot.lua` | `BuildResponse` overlay. New subjects table on overlay only. Favor is encode-only. `ApplyResponse` unchanged (`bibleFields`). |
| `docs/reformation/vestments/briefs/B11-A-snapshot-report.md` | This file |
| `docs/reformation/vestments/briefs/B11-A-snapshot.diff` | B11-A-only unified diff of the exclusive implementation files |

Did not edit Codec, BeefNet, Gora, glue, Runtime, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not `dofile` Gora / Store / UI. Did not commit.

## Contract

```lua
-- when Runtime subjects lack two fighters:
--   live = Gora:GetSanctioned()           → overlay any non-QUIET state
--   last = Gora:GetLastSanctioned()       → overlay only when state == "CONSEQUENCE"
-- favor (Codec already allows it on SNAPSHOT response):
--   Console:GetCongregationFavorVisible() == true
--     and two fighters are on the outbound subjects
--     live → Gora:GetFavorSplit()
--     last (CONSEQUENCE only) → Gora:GetLastFavorSplit()
-- missing Gora / Console / methods → today's encode_expected path (no overlay)
```

- Overlay writes a new `subjects` table on the encode fields. `Runtime:Snapshot()` is a copy; live Runtime is not assigned.
- Live pair wins over last pair.
- Last pair is **not** overlaid in ASSEMBLY (post-`Continue()`).
- Runtime already has two fighters → keep them.
- Missing Gora / Console / methods → identical to `encode_expected`.
- QUIET → `nil, "no event"` even when Gora stubs exist.
- `ApplyResponse` still `Restore(bibleFields(msg))`. Favor on the wire is dropped before Restore.

## TDD

1. Extended `tests/test_net_snapshot.lua` first (six brief pins + QUIET-with-stubs + live-over-last + missing-method encode_expected + isolation wrap after stub clear).
2. Red: `lua tests/test_net_snapshot.lua` — live overlay wire still Runtime-only (`1:SNAPSHOT:response:1:ASSEMBLY::::1`).
3. Implemented encode-only overlay + toggle-gated favor on `BuildResponse`. `ApplyResponse` untouched.
4. Green: `lua tests/test_net_snapshot.lua` — **610 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_snapshot.lua   # 610 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_snapshot.lua` standalone | **610 passed, 0 failed.** Lua 5.1. Exit 0. |

Existing `assert_eq(wire, encode_expected(snap))` pins still pass (those paths have no `COB.Gora`). Isolation wrap: Net / Store / UI / DB nil at load; Gora / Console stubs nilled and re-asserted at end. `COB.Net` / Store / UI still nil.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). Two-client catch-up smoke was not run.

## Self-review

- Exclusive implementation files only. No new codec kind. No SUMMON. Favor is not persisted and is not Restored.
- `bibleFields` still omits favor. Overlay assigns a new subjects table; it does not write `Runtime` fields.
- Gora / Console are optional reads. Missing module or method is the pre-lane encode path.
- Isolation stays Common + Runtime + Codec + Snapshot. Stubs are in-file tables, then nilled.

## Isolated count

**610 passed, 0 failed.** Isolation wrap stays (Net / Store / UI / DB). Gora / Console stubs cleared.

## Concerns

- **ASSEMBLY live overlay does not Restore.** Runtime refuses subjects in ASSEMBLY. `BuildResponse` still overlays live `GetSanctioned` onto ASSEMBLY (brief: any non-QUIET). `ApplyResponse` of that wire is `nil, "invalid subjects"`. Sanction-before-`OpenRite` catch-up encodes the pair; the congregation Restore will not land it. RITE and CONSEQUENCE overlays Restore. Runtime was not edited.
- **Last favor only on last-pair overlay.** `CloseRite` keeps rite fighters. A CONSEQUENCE snapshot that already has two Runtime fighters does not overlay last and does not call `GetLastFavorSplit`. Verdict catch-up then has the Runtime pair and no last favor on the wire. Glue `_HandleSnapshot` still paints favor only from the decoded message.
- **Kept Runtime fighters + live pair can carry live favor.** `usedLive` stays true so toggle-on `GetFavorSplit` can ride a RITE catch-up that already had fighters. The keep-fighters pin leaves Console nil so `encode_expected` still matches.
- **Incomplete pair is a no-op.** One id or a non-table from Gora → today's encode path.
- **No client / two-client smoke.** Isolated suite only. B11-INT owns STATE last-pair CONSEQUENCE-only overlay.

## Status

**DONE_WITH_CONCERNS.** Isolated **610 / 0**. Not signed.
