# Ladder Eligibility & Rites Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship Approach 1 eligibility tags (Knight/Lord rite checklists), raid-weighted standing + quest fellowship, and soft Prophet-only Council copy — without changing roster-backed title authority.

**Architecture:** Standing/rite flags stay in Ladder SV; Scoring gains raid/quest grant paths; Ceremony/Gora set rite flags; Officer tab displays checklists. Titles still come only from `Core/Roster`.

**Tech Stack:** Lua 5.1, plain `COB` global, desktop harness `lua tests/run.lua`, Interface `20506`.

## Global Constraints

- No auto guild promote/demote; no `RANK_COMMIT` authority revival
- UI never awards points; Core never `CreateFrame`
- No Retail-only APIs; no CLEU for scoring
- Exact thresholds stay in `Data/Ranks.lua`; no numbers in `docs/canon/`
- Digital-flock one-time grant: **out of first slice**
- Do not claim V1 complete / POLISH:PASS
- Prefer not committing unless the user asks (session rule)

## File map

| File | Change |
|------|--------|
| `Data/Ranks.lua` | `NeedsRite(toRankId)` helper |
| `Core/Ladder.lua` | rite flags + suggestion checklist fields |
| `Core/DB.lua` | schema v3; persist rites |
| `Core/Scoring.lua` | raid amounts; quest source + cap |
| `Core/Instance.lua` | pass instanceType into grants |
| `Core/Quest.lua` | **new** quest fellowship tracker |
| `Core/Ceremony.lua` | honoree + knighted flag on close |
| `Core/Gora.lua` | `goraLordWin` when beat a Lord |
| `ChurchOfBeef.toc` / `ChurchOfBeef.lua` | load Quest; wire events |
| `UI/OfficerTab.lua` | checklist + Council copy |
| `UI/StandingTab.lua` | knighting honoree + label |
| `tests/*` | ladder/scoring/quest/gora_ceremony/officer_ui |
| `.cursor/rules/scoring-coplay.mdc` | align with amendment |

---

## Task 1: Ladder rite flags + suggestion checklist

- [x] Add `COB.Ranks.NeedsRite(toRankId)` → `"knighted"` (id 3) / `"goraLordWin"` (id 4) / nil
- [x] Persist `knighted` / `goraLordWin` on standing records
- [x] `SetRiteFlag` / `HasRiteFlag` / export-import
- [x] `MaybeSuggest` / `GetSuggestions` copies include `standingMet`, `riteKind`, `riteMet`
- [x] Tests in `test_ladder.lua`
- [x] `lua tests/run.lua` green

## Task 2: Scoring raid weight + quest source

- [x] Raid bucket/complete point keys; `GrantInstanceBucket/Complete` accept instanceType
- [x] Quest source + `GrantQuestBucket` + daily cap below instance
- [x] Instance module passes `raid` vs `party`/`pvp`
- [x] Tests in `test_scoring.lua` / `test_instance.lua`
- [x] Harness green

## Task 3: Quest fellowship module

- [x] New `Core/Quest.lua` (party + guildmate, not in instance, activity-gated buckets)
- [x] Events: group/zone/combat + `QUEST_TURNED_IN` when present
- [x] TOC + bootstrap wiring
- [x] `tests/test_quest.lua` registered
- [x] Harness green

## Task 4: Ceremony knighting + Gora Lord rite

- [x] Ceremony honoree; on close set `knighted` if knighting label + honoree attended
- [x] Gora win vs mapped Lord → `goraLordWin` on winner
- [x] StandingTab: ceremony label + honoree field
- [x] Tests in `test_gora_ceremony.lua`
- [x] Harness green

## Task 5: Officer UI checklists + Council copy

- [x] Evidence shows Standing / Rite lines for Knight & Lord
- [x] Soft footer: Council appointed by Beef Prophet
- [x] Breakdown includes `quest`
- [x] Officer UI tests updated
- [x] Harness green

## Task 6: Rule sync + install smoke

- [x] Update `.cursor/rules/scoring-coplay.mdc` for quest + roster dismiss path
- [x] Reinstall addon; note in-game smoke checklist for user
