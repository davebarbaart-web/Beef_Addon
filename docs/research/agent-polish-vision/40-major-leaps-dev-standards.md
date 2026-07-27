# 40 — Major-leaps development standards (agent SOP)

**Audience:** Coding agents (and humans directing them) building Church of Beef.  
**Last updated:** 2026-07-26  
**Status:** Process guidance for high-leverage agent turns — **not** product law.  
**Authority (product):** [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) · [V1 plan](../../superpowers/plans/2026-07-25-church-of-beef-v1.md) · `Data/Ranks.lua`.  
**Authority (ops):** [`AGENTS.md`](../../../AGENTS.md) · [`.cursor/rules/`](../../../.cursor/rules/) · [church-of-beef-dev skill](../../../.cursor/skills/church-of-beef-dev/SKILL.md) · [`verification.mdc`](../../../.cursor/rules/verification.mdc).

Research scrapes and this note are **guidance**. A green harness and client smoke still win. Do not claim V1 complete until `docs/phases/v1-checklist.md` is walked.

---

## Verdict (one line)

**Every user prompt should ship a vertical slice (or a locked plan + critique package) — not a timid half-edit.** Pack scope, fan out parallel subagents, run mandatory critique, pass CoB verification gates, leave durable artifacts.

---

## 0. Layout truth (never guess paths)

| Role | Path |
|------|------|
| Cursor workspace (rules / skills) | `/Volumes/AI_Design_Drive/Beef_Addon` |
| Addon checkout (`ADDON_ROOT`) when absent on `main` | `.worktrees/feat-church-of-beef-v1/` |
| Installable unit | `$ADDON_ROOT/addon/ChurchOfBeef/` |
| Offline harness | `$ADDON_ROOT/tests/run.lua` |
| Convenience runner from workspace | `./scripts/run-tests.sh` |
| Product law | `docs/superpowers/` + `Data/Ranks.lua` |
| Lore (no numbers) | `docs/canon/` |
| This track | `docs/research/agent-polish-vision/` |

**Rule:** Open **Beef_Addon** as the workspace. Edit worktree Lua from the parent. Do not open the worktree alone (no `.cursor/` copy).

Resolve checkout before any Lua edit or test:

```bash
# Prefer cwd if harness exists; else common worktree
test -f tests/run.lua && ADDON_ROOT="$PWD"
test -z "${ADDON_ROOT:-}" && test -f .worktrees/feat-church-of-beef-v1/tests/run.lua \
  && ADDON_ROOT="$PWD/.worktrees/feat-church-of-beef-v1"
```

If `ADDON_ROOT` cannot be resolved → **stop**. Do not invent addon files on docs-only `main`.

---

## 1. What counts as a “major leap”

A turn is a major leap when it moves **at least one** of these by a full notch (not a stub commit):

| Leap type | Done looks like |
|-----------|-----------------|
| **Vertical slice** | Data/Core/Net/UI path wired end-to-end for one plan task (or a coherent sub-slice), with TOC truth + tests/smoke matching the layers touched |
| **Authority lock** | Spec/plan/Ranks decision closed with decisions-log update; no silent forks into research |
| **Harness leap** | New or extended `tests/` coverage for Core/Data behavior that previously had none; `lua tests/run.lua` green |
| **Client leap** | UI/Net/SV/slash change installed and exercised (`/reload`, `/beef`, two-client if guild/net) |
| **Process leap** | Only when user asked for process: durable SOP/plan/critique package that unblocks the next implementation turn |

**Anti-leaps (reject as “done”):**

- Drive-by refactors unrelated to the ask
- “Started X” with no runnable path
- Docs that restate the plan without a decision or checklist advance
- Green claims without running the harness when Core/Data/harness changed
- Listing missing files in `ChurchOfBeef.toc`
- Touching player `WTF/**/ChurchOfBeefDB.lua` without explicit ask

**Leap size target:** Prefer one **plan task** (or a clearly named half-task with a hard cut line) over many micro-PRs. Pack adjacent files in the same layer dependency chain into the same turn when they share one acceptance criterion.

---

## 2. Scope packing (before tools)

At the start of every substantive prompt, write a **Scope Card** (keep it short; paste into the turn’s working notes):

```text
GOAL:          <one sentence outcome>
IN:            <files/modules/layers in scope>
OUT:           <explicit non-goals>
ACCEPT:        <testable checks — harness / TOC / client / two-client>
PARALLEL:      <2–N subagent jobs or “solo — reason”>
CRITIQUE:      <plan critique | code adversarial | both>
ARTIFACTS:     <paths that will exist when done>
STOP:          <what would force a question back to the human>
```

### Packing rules

1. **Pack by dependency, not by file count.** If Core scoring changes, pack harness fixtures in the same leap. If UI reads standing, pack the Core read API it needs — do not leave UI on fake data unless the plan says so.
2. **Respect layers.** UI→Core→Data; Net→Core→Data. Never Core→UI. UI never awards points; Net never invents ranks; Core never `CreateFrame`; Data never reads SV.
3. **Extend planned modules** (`Core/Ladder.lua`, `Net/BeefNet.lua`, …) over new top-level files. Expand TOC only for files that exist.
4. **One acceptance story.** If two unrelated features appear in the prompt, split into two leaps (or two parallel subagents with a merge plan) — do not interleave half-done threads.
5. **Ask only on STOP conditions:** missing `ADDON_ROOT`, ambiguous product lock, destructive ops, packager upload, WTF wipe, or conflicting spec vs plan.

### Prompt quality bar (for humans directing agents)

Weak: “improve the ladder UI a bit.”  
Strong: “Implement Standing tab rows from Core standing API; pool frames; `/beef` smoke; no scoring in UI; update TOC if new file; leave screenshot checklist in the turn summary.”

---

## 3. Parallel subagents (default, not optional)

When the Scope Card lists ≥2 independent discovery or delivery tracks, **fan out in one message**. Do not serialize research that has no shared mutable state.

### CoB-shaped parallel bundles

| Bundle | Parallel jobs | Merge owner |
|--------|---------------|-------------|
| **Explore → Build** | (A) locate modules/spec cites (B) harness patterns (C) UI direction doc | Parent implements |
| **Core + Tests** | (A) implement Core/Data (B) draft/extend `tests/` cases against the same acceptance | Parent reconciles + runs harness |
| **UI polish** | (A) FrameXML/template research note (B) taint/lockdown checklist (C) implement CreateFrame path | Parent merges; no Core→UI |
| **Net / guild** | (A) BeefNet message shapes (B) officer gate (C) two-client smoke script notes | Parent; never claim green from unit tests alone |
| **Adversarial review** | (A) builder summary (B) critic (C) meta-filter | Parent applies fixes |

### Subagent contract (paste into Task prompts)

```text
WORKSPACE: /Volumes/AI_Design_Drive/Beef_Addon
ADDON_ROOT: .worktrees/feat-church-of-beef-v1  (or resolved)
EDIT ONLY: <paths>
DO NOT: invent ranks; Retail APIs; Core→UI; delete WTF; force-push; packager upload
RETURN: findings + file paths + open questions (no drive-by extras)
```

### Parallel anti-patterns

- Two agents editing the same file without a merge owner
- “Explore the whole repo” when a grep would do
- Cloud/worktree agents unless the user explicitly asked
- Parallel “fix the same bug” without a single evidence owner

---

## 4. Mandatory critique rounds

Critique is a **gate**, not a vibe. Skip only for trivial typo/TOC-one-liner turns (and still run verification if code/tests touched).

### 4.1 Plan / design leaps — versioned critique

```text
plan_v1  →  critique_a  →  critique_b (different angle or model if available)
         →  revise     →  plan_v2 (or ship plan if no blocking findings)
```

**Critic priming (use verbatim intent):**

> You are reviewing an AI-authored CoB plan. Assume subtle layer violations, Anniversary API mistakes, and missing verification. Be blunt. Score each finding: confidence high|medium|low, priority high|medium|low. Categories: layer | api | canon | verification | scope | safety. Only report medium+ confidence.

**Meta-filter:** Drop nits and duplicates. Keep roughly **2–5** actionable, high-priority findings. Author must accept, reject-with-reason, or defer-with-ticket for each.

### 4.2 Implementation leaps — adversarial review

Minimum loop after the first green harness (or after UI install for UI-only):

1. **Builder** — intent + diff summary + acceptance map  
2. **Reviewer** — primed critic on the diff (layers, taint, BeefNet trust, TOC, tests)  
3. **Meta-reviewer** — filter to high-signal only  
4. **Fix pass** — address surviving findings; re-run gates  

**Stop the critique loop when:**

- No high-priority findings remain, **or**
- Two consecutive rounds add only low-priority nits, **or**
- Hard cap: **3** critique→fix cycles (then escalate remaining highs to the human)

Do not burn tokens polishing prose while `lua tests/run.lua` is red.

### 4.3 CoB critique checklist (reviewer must scan)

- [ ] Layer arrows respected (no Core→UI; UI no awards; Net no rank invention)
- [ ] No Retail / DF-only APIs; Interface `20506` unless intentional bump
- [ ] Rank numbers only from `Data/Ranks.lua` (not canon prose)
- [ ] TOC lists only existing files; load order = dependency graph
- [ ] Harness updated if Core/Data behavior changed; `_IN_TEST` / `ResetForTests` not abused outside tests
- [ ] UI work read `docs/superpowers/ui-polished-direction-for-agents.md` before CreateFrame
- [ ] Safety: no bots, injection, protected-action bypass, combat automation

---

## 5. Verification gates (must pass before “done”)

Gates are ordered. Fail → fix or stop; do not narrate success past a failed gate.

### Gate A — Resolve

- [ ] `ADDON_ROOT` has `tests/run.lua` and `addon/ChurchOfBeef/`
- [ ] Workspace is Beef_Addon (rules apply)

### Gate B — Offline harness (Core / Data / harness edits)

```bash
# from workspace root (preferred)
./scripts/run-tests.sh
# or
cd "$ADDON_ROOT" && lua tests/run.lua   # exit 0 required
```

- Prefer Lua 5.1; 5.4 OK for pure logic.
- Non-zero exit → not done.
- Suite skipped because module not built yet → OK only if that module is still OUT of scope.

### Gate C — TOC truth

- [ ] `ChurchOfBeef.toc` references only files that exist
- [ ] `## Interface: 20506` unless the human intentionally bumped
- [ ] New Lua files that should load are listed in dependency order

### Gate D — Safety

- [ ] No bots, injection, protected-action bypass, gameplay automation
- [ ] No Retail-only APIs
- [ ] No secrets / `.firecrawl/` / research `.raw/` staged for commit

### Gate E — In-game (UI / Net / SV / slash)

Follow the skill loop:

1. `rsync`/`cp` `$ADDON_ROOT/addon/ChurchOfBeef/` → `$WOW_ADDONS_DIR/ChurchOfBeef/`
2. `/console scriptErrors 1` (prefer BugGrabber + BugSack)
3. `/reload` → `/beef` → exercise the changed path
4. BeefNet / officer / sync → **two clients** (Officer+ and Member)

Unit tests **cannot** prove guild-chat spectacle; say so explicitly if that path was touched.

### Gate F — Claim hygiene

- [ ] Do not mark V1 complete unless `docs/phases/v1-checklist.md` is filled and walked
- [ ] Research notes never override spec / Ranks.lua

---

## 6. Artifact expectations (every major leap)

A leap without artifacts is a chat ghost. Leave the next agent (or human) something durable.

### Always (implementation turns)

| Artifact | Expectation |
|----------|-------------|
| **Code** | In `$ADDON_ROOT/addon/ChurchOfBeef/…` (correct layer) |
| **TOC** | Updated iff files added/renamed |
| **Tests** | Extended under `$ADDON_ROOT/tests/` when Core/Data behavior changes |
| **Turn summary** | Goal · files · gates run (pass/fail) · leftover risks · next leap |

### When relevant

| Artifact | When |
|----------|------|
| Scope Card | Every substantive prompt (can live in agent notes; promote to plan if multi-session) |
| Critique log | `plan_vN` / findings accepted|rejected — attach to PR or plan section |
| Spec decisions log | Product policy changed |
| Research note | New durable guidance under `docs/research/…` (this track or domain track) |
| Smoke checklist | UI/Net changes — bullet list the human can click through in-game |
| Mermaid / data-flow | Multi-module Net/Core changes |

### Naming & placement

- Plan tasks → follow `docs/superpowers/plans/…` file layout; do not invent parallel “v1b” trees
- Agent polish vision notes → `docs/research/agent-polish-vision/NN-kebab.md`
- Do **not** commit scrapes (`.firecrawl/`, `**/.raw/`)
- Do **not** write new markdown the user did not ask for outside the leap’s artifact list

### Definition of Done (copy/paste)

```text
- [ ] Scope Card IN/OUT honored
- [ ] Parallel jobs merged by one owner
- [ ] Critique round completed (or trivial exemption noted)
- [ ] Gate B if Core/Data/harness touched: lua tests/run.lua → 0
- [ ] Gate C TOC truth
- [ ] Gate D safety
- [ ] Gate E if UI/Net/SV/slash touched (two-client if guild/net)
- [ ] Artifacts listed with paths
- [ ] No silent product forks; Ranks/spec still authority
```

---

## 7. Standard operating procedure (SOP)

Use this as the default loop for every non-trivial user prompt.

```text
1. ORIENT
   - Read AGENTS.md pointers + relevant .cursor/rules for touched layers
   - Resolve ADDON_ROOT; abort if missing
   - For UI CreateFrame: read ui-polished-direction-for-agents.md first

2. SCOPE CARD
   - Write GOAL / IN / OUT / ACCEPT / PARALLEL / CRITIQUE / ARTIFACTS / STOP
   - Pack a vertical slice; cut extras into OUT

3. FAN-OUT
   - Launch independent explore/build/review subagents in one wave
   - Parent holds merge ownership and product locks

4. BUILD
   - Implement in layer order: Data → Core → Net/UI → bootstrap/TOC
   - Extend planned modules; keep ChurchOfBeef / COB globals; no AceAddon in V1

5. VERIFY (Gates A→F as applicable)
   - ./scripts/run-tests.sh or lua tests/run.lua
   - TOC + safety
   - Install/reload/smoke when client-facing

6. CRITIQUE
   - Adversarial review (builder → critic → meta → fix)
   - Cap 3 cycles; escalate leftover highs

7. ARTIFACT + HAND-OFF
   - Paths, gate results, smoke steps, next leap recommendation
   - Commit only if the user asked
```

### Minimal SOP (tiny turns)

```text
ORIENT → SCOPE (3 lines) → BUILD → VERIFY → HAND-OFF
```

Critique may be a self-pass against §4.3 if the diff is &lt; ~20 lines and touches one layer — still run Gate B/C when applicable.

### Escalation (STOP)

Stop and ask the human when:

- Addon checkout / worktree missing
- Spec and plan disagree on a lock
- Need to wipe WTF, force-push, hard-reset, or publish to CurseForge/Wago/WoWI
- Two-client or guild spectacle required and no second client available — report **partial** leap with explicit Gate E debt

---

## 8. Quick reference card

| Lever | CoB default |
|-------|-------------|
| Workspace | `Beef_Addon` root |
| Code | `.worktrees/feat-church-of-beef-v1/addon/ChurchOfBeef/` |
| Tests | `lua tests/run.lua` or `./scripts/run-tests.sh` |
| Interface | `20506` |
| Parallel | Default for ≥2 independent tracks |
| Critique | Mandatory except trivial; cap 3 fix cycles |
| Done | Gates + artifacts; harness ≠ V1 complete |

---

## 9. Relationship to other docs

| Doc | Role vs this SOP |
|-----|------------------|
| `AGENTS.md` | Map / links — follow it; this SOP is the **velocity & quality loop** |
| `church-of-beef-dev` skill | Concrete install/reload/test commands |
| `verification.mdc` | Hard done/safety rules this SOP operationalizes |
| `OPTIMIZATIONS.md` | Tooling backlog needing human approval — do not implement from here |
| Spec / plan / Ranks | Product truth — this SOP never overrides them |

---

## 10. Sources (process patterns)

Synthesized for CoB from agent-harness practice and multi-agent review patterns (Cursor agent best practices; adversarial builder→critic→meta review; versioned plan critique; generate→critique→stop caps). Scrapes under `_search-*.json` in this folder are raw input only — not product law.
