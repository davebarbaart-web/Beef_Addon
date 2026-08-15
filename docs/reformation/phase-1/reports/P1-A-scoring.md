# Phase 1 Lane A — Delete Scoring

**Status:** DONE

**Cited:** Ten Laws 1, 2; Bible §4.6, §4.9; Audit V1; brief `docs/reformation/phase-1/briefs/P1-A-scoring.md`.

No replacement scorer. No TOC / bootstrap / `tests/run.lua` edits. No other Core/UI edits. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files deleted

- `addon/ChurchOfBeef/Core/Scoring.lua` — points engine (`Grant*`, daily caps, anti-AFK buckets, history)
- `tests/test_scoring.lua` — suite for that engine

## Leftover callers (not fixed)

Integrator-owned (this lane must not edit):

- `addon/ChurchOfBeef/ChurchOfBeef.toc` — still lists `Core\Scoring.lua`
- `tests/run.lua` — still lists `"test_scoring"`

Lane G (`Core/Gora.lua`, `Core/Ceremony.lua`, `Core/DB.lua`):

- `Core/Gora.lua` — `COB.Scoring` / `GrantGora` in `RecordResult` (hard-fails `"scoring unavailable"` if missing)
- `Core/Ceremony.lua` — `COB.Scoring` / `GrantCeremony` on Close (nil-guarded)
- `Core/DB.lua` — `defaultScoring()`, `db.scoring`, `COB.Scoring:ImportState` / `ExportState` (nil-guarded)

Lane C (attic Instance/Quest):

- `Core/Instance.lua` — `_Grant` → `GrantBattlegroundEnd` / `GrantInstanceBucket` (nil-guarded)
- `Core/Quest.lua` — `_Grant` → `GrantQuestBucket` (nil-guarded)

Other Core (comment only):

- `Core/Ladder.lua` — comment names Scoring as the promote-suggestion boundary

UI (nil-guarded; other lanes):

- `UI/StandingTab.lua` — `COB.Scoring:GetHistory`
- `UI/OfficerTab.lua` — `COB.Scoring:GetGranted` / `GetHistory`

Tests that `dofile` the deleted file (will fail when those suites run):

- `tests/test_db.lua`
- `tests/test_gora_ceremony.lua`
- `tests/test_instance.lua`
- `tests/test_quest.lua`
- `tests/test_ui.lua`
- `tests/test_officer_ui.lua`
- `tests/test_standing_ui.lua`
- `tests/test_minimap.lua`
- `tests/test_net_validate.lua`

`ChurchOfBeef.lua` has no Scoring references.
