# Roster-backed Ladder Implementation Plan

> **For agentic workers:** Execute task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Ladder mirrors the live WoW guild roster via fixed `rankIndex`→Church map; standing only creates promote suggestions that officers fulfill in Blizzard’s guild UI.

**Architecture:** New `Core/Roster.lua` owns the roster snapshot and ladder view. `Ladder` keeps standing + suggestions only. BeefNet rank commits become ignored. Officer tab is dismiss + standing correction.

**Tech Stack:** Lua 5.1, plain `ChurchOfBeef` / `COB`, desktop `tests/run.lua`, Anniversary `20506`.

## Global Constraints

- Interface `20506`; no Retail-only APIs; no guild promote/demote API calls
- UI→Core→Data; UI never awards points; Net never invents ranks
- Fixed map: guild index 0→Prophet … 6+→Fresh Beef (`Ranks.ChurchRankIdForGuildIndex`)
- `lua tests/run.lua` exit 0 required after Core/Data/harness/UI stub changes

### Task 1: Canon map + Roster module
### Task 2: Ladder standing/suggestions + Scoring hook
### Task 3: DB migration + bootstrap roster events
### Task 4: Net/Sync ignore rank authority
### Task 5: UI Ladder / Standing / Officer slim
### Task 6: Tests + rules/spec decisions log
