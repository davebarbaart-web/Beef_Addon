# 54 — Development Standards Handbook (CoB agents)

**Series:** `docs/research/agent-polish-vision/`  
**Audience:** Coding agents (and humans directing them) working Church of Beef  
**Status:** Research handbook / index — **not product law**  
**Last updated:** 2026-07-26  
**Workspace root:** `/Volumes/AI_Design_Drive/Beef_Addon` (keep Cursor here so `.cursor/rules` apply)

> **Promotion rule:** If this handbook conflicts with the design spec, glossary, or always-on rules, **those win**. Promote process into `.cursor/rules/` or skills only after human approval. Do not silently fork rank numbers, UI doctrine, or safety bans into research.

---

## Handbook sections (map)

| § | Topic | Hard truth lives in |
|---|--------|---------------------|
| [0](#0-how-to-use-this-handbook) | How to use | This file |
| [1](#1-authority--workspace) | Authority & workspace | `AGENTS.md`, design spec, glossary |
| [2](#2-module-layers) | Module layers | `addon-module-layers.mdc`, `lua-cob-modules.mdc` |
| [3](#3-tests--verification) | Tests & verification | `testing.mdc`, `verification.mdc`, church-of-beef-dev skill |
| [4](#4-polish-loops) | Polish loops | [29](29-superpowers-loop-patterns.md), [31](31-loop-stop-conditions.md) |
| [5](#5-goals-syntax) | Goals syntax | [30](30-writing-effective-agent-goals.md), [24](24-definition-of-done-polish.md) |
| [6](#6-critique-rubrics-reference) | Critique rubrics | [25](25-ui-polish-critique-rubric.md), UI brief |
| [7](#7-packaging--install) | Packaging & install | `build-packaging.mdc`, `packaging-assets.mdc` |
| [8](#8-safety--tos) | Safety & ToS | `verification.mdc`, [50](50-adversarial-tos-safety.md) |
| [9](#9-major-leap-sop-per-prompt) | Major-leap SOP | [40](40-major-leaps-dev-standards.md) |
| [10](#10-quick-cards) | Quick cards | Below |
| [11](#11-related-index) | Related index | Sibling notes 01–56 |

---

## 0. How to use this handbook

1. **Start here** when spinning up polish or feature work that should finish at professional quality, not “code compiles.”
2. **Follow the authority order** in §1 before inventing process or UI religion.
3. **Copy a Goal block** from §5 into the prompt / task card; fill surface, acceptance, critique rounds, stop.
4. **Run the polish loop** (§4) with evidence gates (§3); score with the rubric (§6).
5. **Stop** when stop conditions fire or human checkpoint is required (§4 / [32](32-human-checkpoint-handoff.md)).
6. **Never claim V1 complete** until `docs/phases/v1-checklist.md` is walked (`verification.mdc`).

This file is a **single entry handbook**. Deep detail stays in rules, skills, and sibling research notes — do not duplicate canon numbers here.

---

## 1. Authority & workspace

### 1.1 Authority order (do not invert)

| Rank | Truth | Path |
|-----:|-------|------|
| 1 | Product law | `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` (§10 UI, §15 decisions) |
| 2 | Implementer locks | `docs/research/wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md` (esp. 68–71, **74–81**) |
| 3 | Machine canon | `addon/ChurchOfBeef/Data/Ranks.lua` (titles, thresholds, seats, officer index) |
| 4 | Always-on agent policy | `.cursor/rules/architecture-overview.mdc`, `verification.mdc` |
| 5 | UI agent briefing | `docs/superpowers/ui-polished-direction-for-agents.md` |
| 6 | Ops loop | `.cursor/skills/church-of-beef-dev/SKILL.md` |
| 7 | This handbook + polish-vision siblings | Guidance only |
| 8 | Research scrapes (`.firecrawl/`, `**/.raw/`, `_search-*.json`) | **Not** product truth |

Lore prose: `docs/canon/` — never put numeric thresholds there.

### 1.2 Workspace layout

| Need | Where |
|------|--------|
| Cursor rules / skills | Beef_Addon root (this repo) |
| Installable addon + `tests/` | Often `.worktrees/feat-church-of-beef-v1/` (gitignored local worktree) |
| Edit addon Lua | From parent workspace into the worktree path — do **not** open the worktree as a separate Cursor workspace |

Resolve `ADDON_ROOT` per church-of-beef-dev §0 (`tests/run.lua` present).

### 1.3 Stack non-negotiables

- Host: **TBC Classic Anniversary** only — `## Interface: 20506`
- Plain global `ChurchOfBeef` / `COB` — no AceAddon in V1
- Announce / track / sync only — **no** bots, injection, protected-action bypass, or gameplay automation
- No Retail / Dragonflight-only APIs

---

## 2. Module layers

### 2.1 Dependency graph

```text
UI  → Core → Data
Net → Core → Data

❌ Core → UI
❌ UI awards points / invents ranks
❌ Net invents ranks / standing without Core apply APIs
❌ Data reads SavedVariables
❌ Core CreateFrame / SendAddonMessage / slash
```

TOC load order = dependency graph: `Data → Core → Net + UI → ChurchOfBeef.lua` (bootstrap last).

### 2.2 Where code belongs

| `COB` key | File | Owns |
|-----------|------|------|
| `Ranks` | `Data/Ranks.lua` | ids, titles, thresholds, seats, officer index max |
| `DB` | `Core/DB.lua` | `ChurchOfBeefDB` shape, defaults, migrate |
| `Officer` | `Core/Officer.lua` | roster rank-index gate (sole commit authority check) |
| `Scoring` | `Core/Scoring.lua` | grants, caps, anti-AFK buckets |
| `Ladder` | `Core/Ladder.lua` | records, suggestions, commits, demote, seats |
| `Net` / `Sync` | `Net/BeefNet.lua`, `Net/Sync.lua` | transport + validate → Core |
| `UI` | `UI/MainFrame.lua` (+ tabs, toasts, minimap) | frames; views over Core |

Prefer extending planned modules over new top-level files. Expand TOC only when the file exists.

### 2.3 Coupling examples

```text
✅ Officer approve: UI → Ladder:Commit → Net broadcast → UI refresh
✅ Peer apply: Net validate Officer+ → Ladder:ApplyRemoteCommit → UI refresh
✅ After commit: direct COB.UI refresh (no AceEvent bus in V1)

❌ Points granted in Toasts, Announce, or tab files
❌ Second officer-gate outside Core/Officer.lua
❌ Hardcoded titles/thresholds in UI copy (use COB.Ranks)
```

### 2.4 Lua / COB style (summary)

- One global; `local COB = ChurchOfBeef`; colon methods
- Expected failures: multi-return `nil, "reason"` — not `error()`
- Getters return **copies**; never expose live tables to UI/Net
- `ResetForTests` no-ops unless `COB._IN_TEST`
- Lua treats `0` as truthy — never `and/or`-coalesce thresholds that may be `0`

Detail: `lua-cob-modules.mdc`, `toc-lifecycle.mdc`.

### 2.5 UI layer extras (V1)

Before any `CreateFrame` / visual work, read `ui-polished-direction-for-agents.md`.

- Insecure frames under `UIParent` / Beef root; `:Show()`/`:Hide()` (not `ShowUIPanel` in combat)
- Tabs: Ladder / My Standing / Officer+ only
- Standing: **text thresholds** only (no hero StatusBar)
- Spectacle: throttled `/g` (officer checkbox) + private edge toast — no center-screen WA pulses
- No custom `Media/` / SFX required in V1 Tasks 7–10; missing media must not fail load
- Guest on player `uiScale` — never set `uiScale` / `UIParent:SetScale`

Taint: `wow-ui-taint-lockdown.mdc`. Perf: `wow-performance.mdc`.

---

## 3. Tests & verification

### 3.1 Done means (per change)

From `verification.mdc` — every agent claim of “done” must satisfy the applicable rows:

| # | Gate | When |
|---|------|------|
| 1 | `lua tests/run.lua` → exit `0` | Core / Data / harness touched |
| 2 | TOC lists only existing files; Interface `20506` unless intentional bump | Always for addon edits |
| 3 | No bots / injection / protected bypass / Retail-only APIs | Always |
| 4 | Install → `/console scriptErrors 1` → `/reload` → exercise path | UI / Net / SV / slash touched |
| 5 | Two clients (Officer+ and Member) | BeefNet / officer / sync |
| 6 | Do **not** claim V1 complete | Until `docs/phases/v1-checklist.md` walked |

Green harness ≠ V1 done. Guild-chat spectacle is a **product pass** — unit tests cannot prove it.

### 3.2 Offline harness

```bash
./scripts/run-tests.sh                 # from Beef_Addon root (resolves worktree)
# or:
cd .worktrees/feat-church-of-beef-v1   # ADDON_ROOT
lua tests/run.lua                      # Lua 5.1 preferred; 5.4 OK for pure logic
```

Healthy: `Tests finished: N passed, 0 failed`.

**Extending tests** (`testing.mdc`):

1. Add `tests/test_<area>.lua` with `assert_eq` / `assert_true`
2. Register suite in `tests/run.lua`
3. `dofile` chunks (not `require`); set `ChurchOfBeef._IN_TEST` via runner
4. Assert threshold `0` explicitly; getters return copies

Do not invent busted / luacheck / extra CI matrices until approved in `OPTIMIZATIONS.md`.

### 3.3 In-client smoke (mandatory for UI/Net)

Ops detail: church-of-beef-dev skill.

```text
1. Resolve ADDON_ROOT
2. Offline tests if Core/Data/harness changed
3. rsync/cp addon/ChurchOfBeef → $WOW_ADDONS_DIR/ChurchOfBeef
4. Enable addon → scriptErrors 1 → /reload → /beef
5. Prefer BugGrabber + BugSack; empty stack for exercised path = pass signal
6. Net/officer: second client
```

**Never** delete/overwrite player `WTF/**/ChurchOfBeefDB.lua` without explicit user ask.

### 3.4 Evidence gate (polish claim language)

Borrow from [29](29-superpowers-loop-patterns.md) P1 — ban:

- “should work”, “looks correct”, “DONE” without fresh command output
- Trusting implementer self-report without diff / re-critique
- Partial lint as proof of client smoke

Acceptable polish claims name **commands run + observed results** (harness exit, BugSack none, checklist rows ticked).

---

## 4. Polish loops

### 4.1 Core idea

Polish quality comes from **gated iteration**, not longer single-pass prompts:

```text
implement → mechanical verify → critique (separate role) → fix → re-verify → re-critique
  → ledger → (human checkpoint if needed)
```

Never self-grade as final. Detail + pattern catalog: [29](29-superpowers-loop-patterns.md).

### 4.2 Composite CoB polish loop (default)

```text
0. Preconditions
   - ADDON_ROOT resolved
   - Authority order locked (§1)
   - Worktree / branch (no silent polish on main)

1. Select slice
   - One checkbox cluster from UI brief / visual-polish checklist
   - Observable acceptance (§5)

2. Implement
   - Touch only planned surface; no layer inversion; no Retail APIs

3. Mechanical verify (§3)
   - Harness / TOC / install /reload as applicable

4. Critique pass (separate role / subagent)
   - Rubric §6 + UI brief anti-patterns + layer rules
   - Dual verdict: spec/checklist ✅ and craft ✅

5. Fix → re-verify → re-critique
   - Cap iterations (suggest 2–3) then escalate — see [31](31-loop-stop-conditions.md)

6. Ledger
   - Slice complete + evidence pointers
   - Not “V1 complete”

7. Optional wake
   - CI green or human “smoked X” — never drive the WoW client process
```

### 4.3 Stop conditions (summary)

Stop looping when any fire (full algorithm: [31](31-loop-stop-conditions.md)):

| Condition | Action |
|-----------|--------|
| Both critique verdicts clean + evidence gate green | Ship slice / hand off |
| Max critique iterations (2–3) | Escalate to human visual pass |
| Product ambiguity (§15 / glossary unclear) | BLOCKED — ask human; do not invent |
| Missing client / cannot smoke UI | BLOCKED — prepare handoff pack [32](32-human-checkpoint-handoff.md) |
| Hard fail on rubric (taint, points in UI, Retail API, tip jar, …) | Reject slice; redesign |
| Diminishing returns (same nits oscillating) | Park debt list; stop |

### 4.4 Role split

| Role | CoB stand-in |
|------|----------------|
| Implementer | Agent editing worktree `addon/ChurchOfBeef/**` |
| Mechanical evaluator | `lua tests/run.lua`, TOC, rsync install |
| Client evaluator | `/reload` + `/beef` + BugSack; two clients for Net |
| Spec reviewer | Checklist vs glossary 74–81 + UI brief |
| Craft reviewer | Rubric §6 + anti-patterns |
| Memory | Git + on-disk ledger — not chat history |

### 4.5 Do not wire

| Temptation | Why not |
|------------|---------|
| Overnight UI loop without client smoke | False-greens spectacle |
| Keystrokes / process control of WoW | Forbidden (§8) |
| Critique that “improves” locked hex/copy | Escalate; don’t invent brand |
| Promoting research to law silently | Update spec §15 / glossary with approval |

---

## 5. Goals syntax

A **Goal** is a tasking contract: full-scope vision → professional polish via critique cycles, with explicit stop and handoff. Templates live in [30](30-writing-effective-agent-goals.md); DoD gates in [24](24-definition-of-done-polish.md). Syntax below is the handbook canonical shape for prompts.

### 5.1 Goal block template

Copy into user prompts, plan tasks, or subagent briefs:

```markdown
## GOAL
**ID:** COB-<area>-<short-slug>
**Surface:** MainFrame | Ladder | Standing | Officer | Toast | Minimap | Net | Core | Packaging
**Intent:** <one sentence — player-visible outcome>

### In scope
- <bullet>

### Out of scope (explicit)
- <bullet>  <!-- e.g. custom Media/, Streamer Mode, V2 juice -->

### Authority locks
- Spec §… / glossary rows … / Ranks.lua (no forked numbers)
- UI brief bans apply: <yes if UI>

### Acceptance (observable)
- [ ] Offline: `lua tests/run.lua` → 0 failed  <!-- if Core/Data/harness -->
- [ ] TOC truth; Interface 20506
- [ ] In-client: scriptErrors → /reload → <exact path>
- [ ] BugSack: none for exercised path
- [ ] <string / UI state expected>
- [ ] Two-client: <if Net/officer>

### Critique
- Rubric: `25-ui-polish-critique-rubric.md` (dimensions …)
- Rounds: max <2–3>
- Separate critic role: required
- Gate: every dim ≥3; Taint + Performance ≥4 for “polish-ready” UI claims

### Stop when
- Acceptance all ✅ AND critique gate met
- OR blocked: <missing client | unclear §15 | …>
- OR max rounds → human checkpoint ([32](32-human-checkpoint-handoff.md))

### Artifacts to leave
- Diff in worktree (no drive-by docs)
- Scorecard filled (§6 template)
- Evidence notes (harness output summary / smoke path)
- Open debt list (if any)

### Safety
- No WTF wipe, no packager upload, no client automation, no Retail APIs
```

### 5.2 Goal quality rules

| Do | Don’t |
|----|-------|
| Name the surface and player path | “Make UI pretty” |
| Observable acceptance (commands, strings, BugSack) | Vibes-only success |
| Cap critique rounds + stop | Unbounded polish loops |
| Cite locks (glossary / spec) | Re-litigate brand hex mid-loop |
| Split V1 vs V2 juice ([42](42-v1-vs-v2-juice-scope.md)) | Scope explosion into Media/SFX |

### 5.3 Minimal vs full Goal

| Mode | Use when | Required fields |
|------|----------|-----------------|
| **Minimal** | Mechanical fix against locked checklist | Intent, acceptance, safety |
| **Full** | UI / spectacle / Net polish slice | All §5.1 fields + rubric dims + artifacts |

### 5.4 Example Goal (abbrev)

```markdown
## GOAL
**ID:** COB-standing-empty-state
**Surface:** Standing
**Intent:** First-open My Standing shows invitation copy + next threshold text, not a blank panel.

### Acceptance
- [ ] /reload → /beef → My Standing: empty-state copy visible when no record
- [ ] Threshold text sourced from COB.Ranks (no hardcoded numbers)
- [ ] BugSack empty; no StatusBar hero meter

### Critique
- Rubric dims: Hierarchy, Lore fit, Classic authenticity, a11y
- Max rounds: 2

### Stop when
- Acceptance ✅ and dims ≥3 — or escalate if copy needs liturgy lock
```

More filled examples: [30](30-writing-effective-agent-goals.md).

---

## 6. Critique rubrics reference

### 6.1 Primary UI scorecard

**Canonical:** [25 — UI polish critique rubric](25-ui-polish-critique-rubric.md)

| # | Dimension | Polish-ready bar (summary) |
|---|-----------|----------------------------|
| 1 | Hierarchy | One focal path; UI never awards points; no center spectacle |
| 2 | Spacing | Classic gutters; toast geometry; no global `uiScale` |
| 3 | Juice | Satisfying but cheap; V1 silent; no WA pulses |
| 4 | Lore fit | Titles/thresholds from `Ranks.lua`; brand in words |
| 5 | Classic authenticity | FrameXML templates; opaque panels; GameFont*; no required custom Media |
| 6 | Performance | Idle when closed; no permanent OnUpdate; combat-safe refresh |
| 7 | Accessibility | Dual-encode state; readable contrast; class color on names only |
| 8 | Taint safety | Insecure frames; no SecureActionButton for panels |

**Suggested gate:** total 32–40 polish-ready; every dim ≥3 and Taint+Perf ≥4 for “V1 UI done” claims. Any **hard fail** → dimension 1 and block ship-polish language.

### 6.2 Scorecard stub (paste into PR / notes)

```text
COB UI critique — <surface>
Client smoke: yes/no    Rounds used: _/_

1 Hierarchy ............. _/5
2 Spacing ............... _/5
3 Juice ................. _/5
4 Lore fit .............. _/5
5 Classic authenticity .. _/5
6 Performance ........... _/5
7 Accessibility ......... _/5
8 Taint safety .......... _/5
Total _/40 | Hard fails: | Verdict:
Top 3 fixes:
```

### 6.3 Non-UI critique lenses

| Work type | Prefer |
|-----------|--------|
| Core / Ladder / Scoring | Harness assertions + layer purity review |
| BeefNet / Sync | Two-client matrix + no rank invention in Net ([45](45-beefnet-sync-status-ux.md)) |
| Packaging | TOC truth, zip root name, Interface `20506` (§7) |
| Safety / ToS | [50](50-adversarial-tos-safety.md) hard bans |
| Perf vs juice | [51](51-adversarial-performance-vs-juice.md) reject criteria |
| Adversarial swarm | [27](27-multi-agent-adversarial-review.md) |

### 6.4 Anti-patterns (instant critique fail)

From UI brief — reject in review:

WA center pulses · Details!-dense rosters · item-quality rainbow ranks · ElvUI-flat as brand · glass/low-alpha panels · SecureActionButton for panels · tip jars · standing-as-HP/castbar · Retail-only templates · forked thresholds in copy/art docs · UI granting points

---

## 7. Packaging & install

### 7.1 Non-negotiables

- Folder basename = TOC basename: `ChurchOfBeef/ChurchOfBeef.toc`
- `## Interface: 20506` (Anniversary only for V1 — no multi-TOC)
- TOC lists **only existing** files; prefer backslashes in TOC paths
- Consistent `ChurchOfBeef*.lua` casing (case-sensitive packaging)
- `## SavedVariablesPerCharacter: ChurchOfBeefDB` — do **not** switch to account-wide
- Zip/install root = `ChurchOfBeef/` — not the monorepo; keep `docs/canon/` out of the zip
- No packager **upload** / CurseForge / Wago / WoWI publish without explicit approval
- Never commit `CF_API_KEY` / store tokens

### 7.2 Install / zip commands

```bash
# Install (prefer rsync --delete for stale file removal)
rsync -a --delete "$ADDON_ROOT/addon/ChurchOfBeef/" "$WOW_ADDONS_DIR/ChurchOfBeef/"

# Optional hand-out zip
cd "$ADDON_ROOT/addon" && zip -r ../ChurchOfBeef.zip ChurchOfBeef
```

Set `WOW_ADDONS_DIR` to the Anniversary `Interface/AddOns` path. Never invent a specific `_classic_*/` folder name.

### 7.3 In-addon assets

- Media lives under `ChurchOfBeef/`; TOC cannot load outside the addon tree
- Missing fonts/textures/sounds must fall back — `/beef` still works
- Quiet by default: no auto-invite, auto-whisper, or ambient `/g` spam
- Promotion announce = one throttled guild line from approving officer only

Detail: `build-packaging.mdc`, `packaging-assets.mdc`. Future packager CI: research track `33-packager-ci-releases/` + `OPTIMIZATIONS.md` (needs approval).

---

## 8. Safety & ToS

### 8.1 Agents must not

| Ban | Why |
|-----|-----|
| Delete/overwrite `WTF/**/ChurchOfBeefDB.lua` without ask | Player data loss |
| `git clean`, force-push, hard reset, wipe `Interface/AddOns` / WoW install | Destructive |
| Packager upload / store publish without approval | Release control |
| Combat automation, external process control of the client | ToS / safety |
| Scrape chat/combat logs for “support dumps” | Consent / stream safety |
| `ResetForTests` / clear ladder outside harness | Corrupts live SV mental model |
| Commit secrets, `.firecrawl/`, research `.raw/` dumps | Hygiene |
| Bots, injection, protected-action bypass | Non-negotiable product law |
| Retail-only APIs on Anniversary build | Load/runtime failure |

### 8.2 Spectacle / chat hygiene

- No surprise dumps of officer notes or alt lists
- No ads / tip jars / donation CTAs in game UI
- Throttle guild announce; officer opt-out respected
- Stream-safe defaults (see [55](55-streamer-guild-event-ux.md), [50](50-adversarial-tos-safety.md))

### 8.3 Research vs code

`docs/research/` guides agents; it does **not** replace a green harness or client smoke. Tooling backlog (`OPTIMIZATIONS.md`) needs human approval before inventing CI, hooks, or MCP automation.

---

## 9. Major-leap SOP (per prompt)

When the user wants a **major development leap** (not a tiny nit), follow [40](40-major-leaps-dev-standards.md). Handbook summary:

```text
1. Pack scope into 1–3 Goal blocks (§5) with out-of-scope walls
2. Parallelize independent research/implement slices (subagents) when useful
3. Each slice: polish loop (§4) + evidence (§3)
4. Mandatory critique round before “ready for human”
5. Leave artifacts: scorecard, debt list, smoke path — not chat-only claims
6. Escalate product forks to spec §15; do not bury policy in Lua comments
```

Hands-off workflow patterns: [28](28-hands-off-cursor-workflows.md). Human playtest handoff: [32](32-human-checkpoint-handoff.md).

---

## 10. Quick cards

### 10.1 Pre-flight (every session)

```text
- [ ] Workspace = Beef_Addon root
- [ ] ADDON_ROOT has tests/run.lua (worktree if needed)
- [ ] Authority: spec > glossary > Ranks.lua > UI brief > research
- [ ] Goal block written for non-trivial work
```

### 10.2 Change checklist

```text
- [ ] Layer direction respected (UI/Net → Core → Data)
- [ ] No rank numbers invented outside Data/Ranks.lua
- [ ] lua tests/run.lua → 0 failed (if Core/Data/harness)
- [ ] TOC truth; Interface 20506
- [ ] UI/Net/SV/slash: install + /reload smoke
- [ ] Net/officer: two-client path
- [ ] Critique scorecard if UI polish claimed
- [ ] No safety bans violated (§8)
```

### 10.3 Prompt paste (short)

```text
Use handbook docs/research/agent-polish-vision/54-development-standards-handbook.md.
Goal syntax §5; polish loop §4; rubric 25; evidence via church-of-beef-dev + verification.mdc.
Do not claim done without fresh harness/smoke. No WTF wipe, no client automation, no packager upload.
```

---

## 11. Related index

| Note | Topic |
|------|--------|
| [21](21-cursor-agent-loops-goals.md) | Community loop/goal practices |
| [22](22-llm-critique-loops.md) | Critique architectures |
| [23](23-self-playtest-patterns.md) | Hybrid self-playtest |
| [24](24-definition-of-done-polish.md) | Polish DoD |
| [25](25-ui-polish-critique-rubric.md) | 1–5 UI scorecard |
| [26](26-visual-qa-screenshot-protocol.md) | Screenshot QA |
| [27](27-multi-agent-adversarial-review.md) | Swarm topology |
| [28](28-hands-off-cursor-workflows.md) | Hands-off playbook |
| [29](29-superpowers-loop-patterns.md) | Superpowers/Cursor loop patterns |
| [30](30-writing-effective-agent-goals.md) | Goal templates + examples |
| [31](31-loop-stop-conditions.md) | Stop / diminishing returns |
| [32](32-human-checkpoint-handoff.md) | Human playtest pack |
| [34](34-cursor-rules-polish-proposal.md) | Proposed rule promotions |
| [37](37-skill-draft-polish-loop.md) | Skill draft (research only) |
| [40](40-major-leaps-dev-standards.md) | Major-leap SOP |
| [41](41-playtest-protocol-automation.md) | Playtest matrices |
| [42](42-v1-vs-v2-juice-scope.md) | Scope walls |
| [48](48-architecture-vs-juice-tensions.md) | Layer vs juice resolutions |
| [49](49-adversarial-overengineering.md) | Kill-list / keep-list |
| [50](50-adversarial-tos-safety.md) | ToS hard bans |
| [51](51-adversarial-performance-vs-juice.md) | Perf reject criteria |
| [53](53-master-roadmap-proposal.md) | Roadmap proposal (not V1 sign-off) |

**Ops / law (normative):**

| Doc | Role |
|-----|------|
| `AGENTS.md` | Workspace map |
| `.cursor/rules/*` | Binding agent policy |
| `.cursor/skills/church-of-beef-dev/SKILL.md` | Install / reload / test |
| `docs/superpowers/ui-polished-direction-for-agents.md` | UI briefing |
| `docs/phases/v1-checklist.md` | V1 completion gate |

---

## 12. Executive summary

Single entry handbook for CoB agents: authority order → layers → verification → polish loop → Goal syntax → rubrics → packaging → safety → major-leap SOP. Deep detail stays in rules, skills, and sibling research notes. Not product law; promote carefully.

---

## 13. Sourced practices

| Area | Sourced from |
|------|----------------|
| Authority / layers | `AGENTS.md`, always-on rules, design spec, glossary |
| Verification | `verification.mdc`, `testing.mdc`, church-of-beef-dev skill |
| Goals / loops | [21](21-cursor-agent-loops-goals.md), [29](29-superpowers-loop-patterns.md), [30](30-writing-effective-agent-goals.md), Cursor docs |
| Critique / DoD | [24](24-definition-of-done-polish.md), [25](25-ui-polish-critique-rubric.md) |
| Hands-off | [28](28-hands-off-cursor-workflows.md), `OPTIMIZATIONS.md` |
| Motion | [15](15-procedural-ui-animation.md), [16](16-timing-curves-recipes.md), [56](56-wow-animationgroup-classic.md) |

---

## 14. CoB-specific application

Use §10 quick cards every session. Resolve `ADDON_ROOT` per skill §0. Edit worktree addon paths from the parent workspace. For UI `CreateFrame`, read the UI brief first. For motion, prefer [15]/[56] over inventing a tween bus.

---

## 15. Agent rules

1. Follow authority order (§1) — research never overrides spec / `Ranks.lua`.  
2. Fill a Goal block (§5) for non-trivial work; refuse “make it nicer” as sole brief.  
3. Run polish loop (§4) with fresh evidence; no false completion language.  
4. Human-only: polish PASS, guild-night spectacle, packager publish, WTF wipes.  
5. Safety bans (§8) are hard stops — not critique nits.  
6. Keep this handbook as index; do not duplicate canon numbers here.

---

## 16. Open questions

1. When to merge handbook pointers into `AGENTS.md` vs keep research-only?  
2. Optional polish skill ([37](37-skill-draft-polish-loop.md)) — approve or fold into church-of-beef-dev?  
3. Hook adoption timing vs handbook “soft” stop-hook recommendations?  
4. Should §6 rubric scores be required artifacts in every UI PR description?  
5. Anniversary AnimationGroup probe results — attach under [56](56-wow-animationgroup-classic.md) when available?

---

## 17. Source links

- `AGENTS.md` · `.cursor/rules/*` · `.cursor/skills/church-of-beef-dev/SKILL.md`  
- `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`  
- `docs/superpowers/ui-polished-direction-for-agents.md`  
- `docs/phases/v1-checklist.md` · `OPTIMIZATIONS.md`  
- Sibling notes indexed in §11 (esp. 15, 21, 24–32, 40, 53, 56)  
- [Cursor agent best practices](https://cursor.com/blog/agent-best-practices) · [Cloud best practices](https://cursor.com/docs/cloud-agent/best-practices.md)

---

## Changelog

| Date | Note |
|------|------|
| 2026-07-26 | Initial Development Standards handbook (outline + content) for CoB agents |
| 2026-07-26 | Added series-standard exec summary / sourced practices / agent rules / open questions / sources; linked 15·21·56 |
