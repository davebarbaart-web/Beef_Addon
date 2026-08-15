# Phase 1 Lane B — Delete Ladder standing machinery

**Status:** DONE

**Cited:** Ten Laws 1 and 7; Audit V1, V6; Bible §4.6, §4.9, §12; brief `docs/reformation/phase-1/briefs/P1-B-ladder.md`.

**Not edited (per brief):** `ChurchOfBeef.toc`, `ChurchOfBeef.lua`, `tests/run.lua`, or any other module.

**No commit made.**

## Files deleted

| Path | Why |
|------|-----|
| `addon/ChurchOfBeef/Core/Ladder.lua` | Standing store, promote suggestions, rite flags, `SweepDeparted` (Law 7 / Audit V6) |
| `tests/test_ladder.lua` | Dead suite for the deleted subject |

No lite ladder was kept. Persistence patterns are recorded below only — not ported into a new file.

## Persistence patterns (docs only; Phase 2 reuse)

From the deleted module. Keep the *patterns*, not the standing store (handoff Phase 2).

- **Revision:** a module-local `revision` integer, bumped on every write. `GetRevision()` lets a tab cache a sorted list across repaints.
- **Batch:** `BeginBatch` / `EndBatch` with `batchDepth` and `batchDirty`. Nested batches are legal. `persist()` bumps revision always; it defers `COB.DB:Save()` while `batchDepth > 0` and flushes once on the outermost `EndBatch` if dirty.
- **Load vs save:** `ImportState` / `ImportSuggestions` replace in-memory tables and bump revision but do **not** call Save (they *are* the load). Export writes storage shape, not enriched display copies.

## Leftover callers (not fixed)

Guarded `if COB.Ladder then` sites will no-op. Unguarded `dofile` of the deleted file will fail when those suites run. TOC still lists the missing file.

### Out of this lane (explicitly left)

| File | Call |
|------|------|
| `addon/ChurchOfBeef/ChurchOfBeef.toc:10` | `Core\Ladder.lua` still listed |
| `addon/ChurchOfBeef/ChurchOfBeef.lua:61–68` | `WireSuggestionFanout` → `COB.Ladder:SetOnSuggestion` (guarded; returns false) |
| `tests/run.lua:32` | `"test_ladder"` still registered |

### Addon runtime

| File | Calls |
|------|-------|
| `Core/DB.lua:105–107, 134–138` | `ImportState` / `ImportSuggestions` / `ExportState` / `ExportSuggestions` (guarded; `db.ladder` shape remains) |
| `Core/Roster.lua:70–75` | `SweepDeparted` after a complete roster (guarded; Law 7 banned path now dead) |
| `Core/Roster.lua:295–309` | `ClearSatisfiedSuggestions` → `GetSuggestions` / `RejectSuggestion` |
| `Core/Roster.lua:316–323` | `GetLadderView` still reads `GetStanding` / `GetRecord` (standing falls to 0) |
| `Core/Ceremony.lua:249–251` | `SetRiteFlag(honoree, "knighted", true)` (guarded) |
| `Core/Gora.lua:249–251` | `SetRiteFlag(winner, "goraLordWin", true)` (guarded) |
| `Net/BeefNet.lua:455–463` | `ReleaseHeld` → `BeginBatch` / `EndBatch` |
| `Net/BeefNet.lua:512–515` | `HandleSuggestion` → `ImportSuggestion` (returns `"ladder unavailable"`) |
| `UI/OfficerTab.lua:95–101, 253–264, 323, 361` | `GetSuggestions`, `GetRevision`, `GetRecord`, `HasOfficialRecord`, `RejectSuggestion`, `CorrectStanding` |
| `UI/StandingTab.lua:223–224, 924` | `GetSuggestions`, `GetRecord` |
| `UI/LadderTab.lua:536, 1412` | `GetLadderView`, `GetRecord` (UI tab file itself is not this lane) |
| `UI/Minimap.lua:41–46, 102–103` | `HasSuggestion` / `GetSuggestions`, `GetRecord` |

### Tests that `dofile` the deleted file

These will fail at load when the harness reaches them. Not fixed.

- `tests/test_db.lua`
- `tests/test_gora_ceremony.lua`
- `tests/test_minimap.lua`
- `tests/test_net_adversarial.lua`
- `tests/test_net_validate.lua`
- `tests/test_officer_ui.lua`
- `tests/test_roster.lua`
- `tests/test_standing_ui.lua`
- `tests/test_ui.lua`

### Not leftover `COB.Ladder` callers

- `UI/MainFrame.lua` and `UI/Status.lua` call `Roster:GetLadderView`, not `COB.Ladder`.
- `UI/LadderTab.lua`’s `COB.LadderTab` namespace is the UI tab, not the deleted Core store.
- `tests/test_instance.lua` and `tests/test_quest.lua` no longer reference Ladder (other lanes).
- `Core/Scoring.lua` / `tests/test_scoring.lua` already gone (Lane A).
