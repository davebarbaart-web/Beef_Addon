# Pre-playtest readiness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the roster-backed V1 build honest and solo-smokeable before hardcore Anniversary playtesting — green harness, matching checklists, no Commit-era dead ends.

**Architecture:** Product law is the Accepted roster-backed amendment (`docs/superpowers/specs/2026-07-25-roster-backed-ladder-design.md`). Church titles come from the live guild roster; standing creates promote suggestions; officers promote in Blizzard’s guild UI. This plan does **not** add V2 theater, Media, SFX, or roster-diff `/g` announce.

**Tech Stack:** Lua 5.1 (WoW), desktop harness `lua tests/run.lua`, Anniversary `## Interface: 20506`.

## Global Constraints

- Platform: TBC Classic Anniversary only (`20506`)
- No bots, injection, protected-action bypass, or gameplay automation
- No Retail-only APIs; no guild promote/demote API calls from the addon
- UI→Core→Data / Net→Core→Data; Core never CreateFrame
- Agents claim **POLISH:CANDIDATE** only; humans walk dated checklist ticks
- Do not claim V1 complete from this plan

## File structure (touched)

```
addon/ChurchOfBeef/
  Core/Ladder.lua          # CorrectStanding → MaybeSuggest
  Net/BeefNet.lua          # suggestion / version-warn copy
  UI/Status.lua            # roster-aware mesh states
  UI/LadderTab.lua         # learning banner (via Status)
  UI/StandingTab.lua       # petition copy
  UI/Toasts.lua            # suggest copy
docs/phases/
  v1-checklist.md          # roster-backed success criteria
  guild-night-playtest.md  # solo-first night goals
  solo-smoke.md            # NEW — amendment §10 walkthrough
docs/superpowers/specs/
  2026-07-25-church-of-beef-design.md  # §13/§15 reconcile
docs/superpowers/ui-polished-direction-for-agents.md
docs/research/agent-polish-vision/
  00-ADR-log.md            # ADR-0006 superseded
  00-PROMOTE-STATUS.md     # H-gates for roster era
.cursor/rules/
  officer-guild-roster.mdc
  beefnet-messaging.mdc
  scoring-coplay.mdc
  ui-juice-standards.mdc
AGENTS.md
scripts/install-anniversary.sh
tests/test_ladder.lua
tests/test_ui.lua
```

---

### Task 1: Standing correction enqueues suggestions

**Files:** `Core/Ladder.lua`, `tests/test_ladder.lua`

- [x] **Step 1: Write failing test** — after `CorrectStanding` to a threshold with roster map, assert a new suggestion and that `Net:OnLocalSuggestion` would fire (spy or count `#GetSuggestions()` + `isNew` via re-call pattern matching Scoring).

- [x] **Step 2: Implement** — `CorrectStanding` calls `SetStanding`, then `MaybeSuggest`; if `isNew`, call `COB.Net:OnLocalSuggestion` (same boundary as `Scoring:Grant`).

- [x] **Step 3: Run** `lua tests/run.lua` — exit 0.

---

### Task 2: Roster-aware status / kill false “empty ladder” banner

**Files:** `UI/Status.lua`, `tests/test_ui.lua`

- [x] **Step 1: When sync ends with no peer merges but live roster has occupants, treat as `ready`** (not `no_peers` / not “cached ladder”).
- [x] **Step 2: Soften chip copy** — “Syncing peers…”, “Using local standing”, “No addon peers”.
- [x] **Step 3: Update `test_ui.lua`** — reset Roster before empty-peer cases; assert roster-filled solo GM stays `ready` with banner hidden.
- [x] **Step 4: Run harness.**

---

### Task 3: Member/officer copy matches guild-UI promote

**Files:** `Net/BeefNet.lua`, `UI/Toasts.lua`, `UI/StandingTab.lua`, `UI/OfficerTab.lua` (queue label only if cheap)

- [x] Replace Commit-era “recognized / petitions” with roster promote wording (amendment §7–§8).
- [x] Soften version-warn: protocol mismatch, not “share ranks”.
- [x] Officer queue row: `Promote Name → Title (guild UI)` or keep short row + evidence line (evidence already correct).
- [x] Run harness (UI tests that assert toast strings).

---

### Task 4: Playtest docs + install script

**Files:** `docs/phases/v1-checklist.md`, `guild-night-playtest.md`, new `solo-smoke.md`, `scripts/install-anniversary.sh`

- [x] Rewrite checklist criteria 7–11 to amendment §11 (roster mirror, Dismiss, guild-UI promote, no forged-commit path, spectacle deferred).
- [x] Guild-night: solo-first pacing + roster promote; defer `/g` social check.
- [x] Add `docs/phases/solo-smoke.md` matching amendment §10.
- [x] Install script points at `solo-smoke.md` + updated checklist.

---

### Task 5: Spec / ADR / rules reconcile

**Files:** design spec §13/§14/§15 rows, ADR-0006, PROMOTE-STATUS, UI brief constitution watch, `AGENTS.md`, four Cursor rules above.

- [x] Mark superseded Commit→`/g` / RANK_COMMIT-authority rows; point at roster amendment.
- [x] ADR-0006 → Superseded by §15 Accept (2026-07-26).
- [x] H-gates: H1 solo smoke; H2 optional two-client suggestion fanout; H3 spectacle deferred.
- [x] Rules: Commit path → Dismiss + guild UI; BeefNet soft-ignore `RANK_COMMIT`.

---

### Task 6: Verify + install

- [x] `./scripts/run-tests.sh` → 0 failed
- [x] TOC lists only existing files; Interface `20506`
- [x] `./scripts/install-anniversary.sh` when Anniversary AddOns path exists
- [x] Stop. Do **not** tick human checklist boxes. Hand human `docs/phases/solo-smoke.md`.
