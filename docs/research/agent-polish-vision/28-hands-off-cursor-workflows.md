# 28 — Hands-off Cursor workflows (applied to Beef_Addon)

**Lane:** Agent / DevEx research (not product canon)  
**Last updated:** 2026-07-26 (expanded: `/loop`, Ralph, Multitask caveats, cost/failure modes, critique stacking)  
**Audience:** Maintainers who want larger leaps per prompt with less mid-turn babysitting  
**Companion backlog:** [`OPTIMIZATIONS.md`](../../../OPTIMIZATIONS.md) (hooks/CI items need human approval before implement)  
**Companions:** [`21-cursor-agent-loops-goals.md`](21-cursor-agent-loops-goals.md) · [`21b-cursor-loops-source-digest.md`](21b-cursor-loops-source-digest.md) · [`22-llm-critique-loops.md`](22-llm-critique-loops.md) · [`30-writing-effective-agent-goals.md`](30-writing-effective-agent-goals.md) · [`31-loop-stop-conditions.md`](31-loop-stop-conditions.md)  
**Search dumps:** [`_search-hands-off-cursor.json`](_search-hands-off-cursor.json), `_search-community-cursor-reddit.json`, `_search-cursor-loops-docs.json`, `_deep-cursor-agent-loops-v2.md`

---

## Executive summary

Hands-off Cursor work is not “trust the model more.” It is a **stack**: soft policy (rules / `AGENTS.md`) → deep runbooks (skills) → hard gates (hooks + CI) → parallel isolation (worktrees / Multitask / `/best-of-n`) → long-running autonomy (Cloud Agents + Automations / `/babysit`) → optional **Ralph / grind loops** that stop on *external* verify. Power users front-load *verifiable done criteria* and environment setup so they review **outcomes** (diff, green harness, PR) instead of every shell approve.

**Pick the loop engine deliberately** (full taxonomy in [`21`](21-cursor-agent-loops-goals.md)):

| Engine | Hands-off role | Beef fit |
|--------|----------------|----------|
| **`stop` hook grind** | Same chat continues until DONE / tests / `loop_limit` | Core harness follow-up (approve via OPTIMIZATIONS) |
| **Ralph / CLI fresh context** | New `agent -p` each iter; git is memory | Mechanical migrations; overnight Core transforms |
| **`/loop` skill (timed wake)** | Interval/event wakes without busy-poll | CI babysit, wait-for-human `/reload` — not token grind |
| **Multitask / Cloud** | Parallel or AFK VM work | Disjoint scopes; Core/docs Cloud; UI human-eyed |

Beef_Addon already has the soft layer in good shape (2 always-on rules, file-scoped domain rules, `AGENTS.md`, `church-of-beef-dev` skill, `scripts/run-tests.sh`, GHA that runs when `tests/run.lua` exists). The biggest remaining leaps are: **(1)** stop/secret/TOC hooks (deferred in `OPTIMIZATIONS.md`), **(2)** Cloud/`environment.json` so agents can run Lua 5.1 without a local machine, **(3)** parallel worktree playbooks that respect “workspace = parent repo, edit Lua in `.worktrees/…`”, **(4)** treating in-game smoke as a separate human gate, and **(5)** hard **cost/iteration caps** so AFK never repeats community cost-runaway failures ([r/cursor ~$2k loop](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/)).

---

## Sourced practices

Primary sources for the stack below: [Cursor Hooks](https://cursor.com/docs/hooks.md), [Rules](https://cursor.com/docs/rules.md), [Skills](https://cursor.com/docs/skills.md), [Cloud best practices](https://cursor.com/docs/cloud-agent/best-practices.md), [Run Modes](https://cursor.com/docs/agent/security/run-modes.md), [Agent best practices (blog)](https://cursor.com/blog/agent-best-practices), [Worktrees](https://cursor.com/docs/configuration/worktrees.md), [Ralph original](https://ghuntley.com/ralph/), [Ralph Cursor Guide](https://forum.cursor.com/t/ralph-cursor-guide/149998), [Auto-review forum](https://forum.cursor.com/t/auto-review-run-mode/161922), [Multitask pattern note](https://agentpatterns.ai/tools/cursor/multitask-subagents). Full annotated bibliography: [`21b`](21b-cursor-loops-source-digest.md). Loop taxonomy: [`21`](21-cursor-agent-loops-goals.md).

---

## 1. The power-user stack (layered)

```
Plan Mode (goal + verify criteria)
        ↓
Rules + AGENTS.md     ← always-on policy, how to run/test
Skills                ← deep how-tos, loaded on demand
Hooks                 ← allow/deny/ask + stop follow-up until green
        ↓
Local: Auto-review / Run Everything + worktrees + /multitask + /best-of-n
Cloud: environment.json + repo hooks + /babysit + Automations
        ↓
CI: deterministic gate (lua tests) · optional restricted CLI agent
```

| Layer | Soft vs hard | Beef today | Hands-off gap |
|-------|--------------|------------|---------------|
| Rules / `AGENTS.md` | Soft guidance | Strong | Keep lean; don’t grow always-on |
| Skills | Soft, on-demand | `church-of-beef-dev` | Optional slash commands for common leaps |
| Hooks | Hard enforce / auto-loop | Deferred | Highest leverage next (tests, secrets, TOC) |
| Worktrees / Multitask | Parallelism | Manual `.worktrees/feat-…` | Codify `.cursor/worktrees.json` + prompt patterns |
| Cloud Agents | Unattended VM | Not set up | Needs Lua env + test path on branch |
| CI | Hard merge gate | Soft-skip on docs-only `main` | Real gate once addon/tests land on default branch |

**Hard truth from Cursor docs:** Rules and Auto-review are **not** a security boundary. Use hooks with `failClosed: true` for secrets/destructive ops, plus CI for merge truth. ([Hooks](https://cursor.com/docs/hooks.md), [Run Modes](https://cursor.com/docs/agent/security/run-modes.md), [Cloud best practices](https://cursor.com/docs/cloud-agent/best-practices.md))

---

## 2. Capability notes (what “hands-off” actually means)

### 2.1 Hooks

- Config: project `.cursor/hooks.json` (+ scripts under `.cursor/hooks/`), user `~/.cursor/hooks.json`, Enterprise team hooks.
- Decisions: `permission` = `allow` | `deny` | `ask` (not “warn”). Exit code `2` = deny. Failures default **fail-open** unless `failClosed: true`.
- **`stop` / `subagentStop`:** return `followup_message` to auto-continue (e.g. “tests failed — fix”). Default `loop_limit` = **5** (`null` = uncapped).
- Cloud Agents run **repo** command hooks only (no `~/.cursor` user hooks; no prompt-based hooks). Recent changelogs extended cloud support to conversation hooks (`beforeSubmitPrompt`, `stop`, etc.). ([Hooks](https://cursor.com/docs/hooks.md), [Release notes](https://releasebot.io/updates/cursor))
- Canonical grind pattern: `stop` → run tests → if failing / scratchpad incomplete → inject follow-up. ([Agent best practices](https://cursor.com/blog/agent-best-practices))

**Beef mapping (approve via `OPTIMIZATIONS.md` first):**

| Hook | Behavior | Why |
|------|----------|-----|
| `beforeShellExecution` | `deny` packager upload / force-push / `git clean` / WTF wipe patterns | Matches `verification.mdc` “agents must not” |
| `stop` | If agent touched `addon/**` or `tests/**` (or worktree equivalents), run `./scripts/run-tests.sh` with `REQUIRE_TESTS=1`; on fail, `followup_message` | Closes the Core/Data loop without human “did you run tests?” |
| `beforeSubmitPrompt` or secret scan on edit | Block `CF_API_KEY`, Wago/WoWI tokens, `.firecrawl/`, `**/.raw/` | Release safety |
| Optional TOC check | Fail if `ChurchOfBeef.toc` lists missing files | Packaging truth |

Keep change-detection conservative: prefer “run harness when checkout has tests” over fragile path heuristics — the deferral note in `OPTIMIZATIONS.md` is still valid if the hook is noisy.

### 2.2 Rules & `AGENTS.md`

- Precedence: Team → Project → User. Agent Chat only (not Tab / Inline Edit).
- Keep always-apply small; use globs / intelligent / `@rule` for the rest. Prefer `@file` over pasting style guides. ([Rules](https://cursor.com/docs/rules.md))
- Cloud best practice: `AGENTS.md` = how a low-context human runs and debugs the repo. ([Cloud best practices](https://cursor.com/docs/cloud-agent/best-practices.md))
- Community token hygiene: keep always-apply context lean (rules + `AGENTS.md`); move encyclopedias to skills. ([community guidance](https://www.builder.io/blog/cursor-tips-agents-md))

**Beef already matches the recommended shape:**

- Always-on: `architecture-overview.mdc`, `verification.mdc` (≤2–3 target in `OPTIMIZATIONS.md`).
- File-scoped: layers, ladder, BeefNet, TOC, packaging, UI taint, etc.
- Map: `AGENTS.md` points at worktree layout + `./scripts/run-tests.sh`.

**Do not** fork policy into research tracks or grow a third always-on rule for “be autonomous.” Autonomy belongs in hooks + verify criteria.

### 2.3 Skills

- Discovered from `.cursor/skills/`, user skills, plugins; catalog at session start; full `SKILL.md` loaded when description matches (or `/skill-name`). ([Skills](https://cursor.com/docs/skills.md))
- Skills ≠ subagents: skills = repeatable workflows; subagents = isolated parallel specialists.
- Built-ins that reduce babysitting: `/babysit`, `/loop`, `/best-of-n`, `/create-hook`, Plan Mode → Build (incl. Build in Parallel).

**Beef:** Keep operational how-to in `church-of-beef-dev`. Optional future skills (approval-gated):

- `/cob-core` — Plan → implement Core/Data → `lua tests/run.lua` → stop.
- `/cob-ui` — Force-read UI direction doc → CreateFrame only in UI → install + `/reload` checklist (human in loop).
- `/cob-net` — Two-client BeefNet lab checklist (never claim green from unit tests alone).

### 2.4 Cloud Agents (formerly Background Agents)

- Isolated VM → branch → PR; no local Run Modes approval UX. Effectiveness ≈ **env quality** (`.cursor/environment.json`, snapshot/Dockerfile, secrets, egress). ([Cloud Agents](https://cursor.com/docs/cloud-agent.md), [Setup](https://cursor.com/docs/cloud-agent/setup.md))
- `/in-cloud` for long work without blocking local chat; `/babysit` for PR/CI feedback loops. ([Changelog summary](https://releasebot.io/updates/cursor))
- Best practices order: env → access → skills/`AGENTS.md` → tools molded for agents. ([Best practices](https://cursor.com/docs/cloud-agent/best-practices.md))

**Beef constraints:**

- Offline harness is VM-friendly (Lua 5.1 + `tests/run.lua`).
- In-game `/reload`, two-client guild, spectacle = **cannot** be Cloud-complete; Cloud owns Core/Data/Net-validate/docs; human owns client smoke.
- Today `main` often lacks `tests/`; Cloud must either run against feature branch checkout or fail honestly (same as GHA skip message).

### 2.5 Multitask Mode & Agents Window

- `/multitask`: async subagents in parallel instead of queueing. ([Multi-agent](https://cursor.com/help/ai-features/multi-agent.md))
- Plan → **Build in Parallel** for independent plan steps.
- Enter queues; `Cmd+Enter` interrupts/redirects. ([Agent overview](https://cursor.com/docs/agent/overview.md))

**Beef parallelization cuts (safe):**

| Parallel OK | Serialize |
|-------------|-----------|
| Research track digests | Edits to `Data/Ranks.lua` (single authority) |
| Docs vs Core harness | UI + Net that share SV shape |
| Independent Core modules with clear interfaces | TOC load-order / bootstrap last |
| Bugbot/security review vs feature work | Officer Commit + announce pipeline |

### 2.6 Worktrees & `/best-of-n`

- Cursor can create/manage git worktrees per agent; `.cursor/worktrees.json` for `setup-worktree` install steps. ([Worktrees](https://cursor.com/docs/configuration/worktrees.md))
- `/best-of-n`: same prompt, multiple models, isolated worktrees; **compare only** — human picks winner. ([Agent best practices](https://cursor.com/blog/agent-best-practices))
- Practical tip: scope agents to disjoint paths to avoid apply/merge pain. ([Parallel agents + worktrees](https://engincanveske.substack.com/p/running-parallel-agents-in-cursor))

**Beef-specific layout (do not fight it):**

```
Beef_Addon/                          ← Cursor workspace (rules/skills)
  .worktrees/feat-church-of-beef-v1/ ← addon + tests (often)
  .cursor/ rules, skills
  docs/
```

- Always open **parent** `Beef_Addon`, not the worktree alone (no `.cursor/` copy there).
- Agent worktrees for experiments should still read rules from parent; prefer editing under the feat worktree path or a branch that contains `addon/`.
- Future: `.cursor/worktrees.json` that copies nothing heavy but documents `lua` on PATH and points at `./scripts/run-tests.sh`.

### 2.7 CI gates & Automations

| Pattern | Role for hands-off |
|---------|-------------------|
| GHA `lua-tests.yml` | Merge truth when `tests/run.lua` present; honest skip on docs-only `main` |
| Cursor Automations | On “GitHub CI completed” → comment/fix or Slack; event-driven without you watching |
| `/babysit` | Cloud agent watches PR checks/conflicts |
| CLI `agent -p` in CI | Restricted autonomy: agent edits, CI owns `git`/`gh` ([GitHub Actions](https://cursor.com/docs/cli/github-actions.md)) |

**Beef CI contract (already aligned with research track 73):**

> Green `lua tests/run.lua` = Core/Data/Net-validate logic held. It does **not** mean Anniversary UI, BeefNet transport, or guild spectacle works.

Packager upload / CurseForge publish remains human-approved (`OPTIMIZATIONS.md`, `verification.mdc`).

### 2.8 Local autonomy settings

| Mode | Use when |
|------|----------|
| **Auto-review** (default) | Day-to-day Beef work — fewer prompts, still classifier/sandbox |
| **Allowlist** | Paranoid sessions (release secrets nearby) |
| **Run Everything** | Trusted long Core/Data grind with hooks + CI behind you |

Auto-review (Cursor 3.6+) routes Shell/MCP/Fetch through allowlist → sandbox → classifier to cut interruptions. It is still not a security boundary. ([Auto-review notes](https://www.totalum.app/blog/cursor-auto-review-totalum), [Run Modes](https://cursor.com/docs/agent/security/run-modes.md))

---

## 3. Beef_Addon gap analysis

### Already in place (use freely)

- Workspace-root rules + skill + `AGENTS.md`
- `scripts/run-tests.sh` worktree resolution
- GHA Lua 5.1 harness with honest skip
- Layer/canon/verification non-negotiables encoded as rules
- Dev skill covers install / `/reload` / two-client notes

### Highest-leverage next (needs approval)

1. **Project hooks** — secret deny + `stop` test grind (P1 in `OPTIMIZATIONS.md`)
2. **TOC drift check** — script shared by hook and optional CI job
3. **Cloud `environment.json`** — Lua 5.1 + `bash scripts/run-tests.sh` on feature branch
4. **`.cursor/worktrees.json`** — one-line setup for parallel agent checkouts
5. **Slash/skill wrappers** for Core-only vs UI vs Net lab (reduce prompt variance)

### Explicit non-automations (keep human)

- Guild-chat spectacle / promote ceremony product pass
- Two-client Officer+ / Member BeefNet labs
- Deleting player `WTF/**/ChurchOfBeefDB.lua`
- Packager store upload
- Claiming V1 complete without `docs/phases/v1-checklist.md` walk

---

## 4. Workflow playbook (copy/paste)

### Playbook A — Major Core/Data leap (least babysitting)

1. **Plan Mode** with explicit done criteria:  
   `Done = ./scripts/run-tests.sh exit 0; no TOC missing files; no Retail APIs; layers respected.`
2. Refine the plan until file list and test expectations are crisp; then **Build** (or Build in Parallel for independent modules).
3. Local: **Auto-review** or **Run Everything** if hooks exist.
4. Single agent owns `Data/` + `Core/`; do not parallel-edit `Ranks.lua` with another agent.
5. You review: harness log + diff. Skip mid-turn shell approvals unless classifier pings.
6. In-game only if bootstrap/SV touched — otherwise defer client.

### Playbook B — UI polish pass (agent-executed, human-eyed)

1. Prompt must `@` or force skill path to `docs/superpowers/ui-polished-direction-for-agents.md`.
2. Agent implements under `addon/ChurchOfBeef/UI/` only; Core stays point-free.
3. Agent runs offline tests if any shared types/helpers moved; then **install** via skill (`WOW_ADDONS_DIR`).
4. **You** run `/console scriptErrors 1` → `/reload` → `/beef`. Agent does not claim visual done.
5. Optional: Cloud explores API docs while local agent edits frames — Multitask, disjoint scopes.

### Playbook C — Parallel research / docs vs code

1. Enable **Multitask** / Agents Window.
2. Agent 1: docs/research only. Agent 2: worktree on feat branch for Lua.
3. Merge policy: research never silently forks rank numbers — point at `Data/Ranks.lua` / design decisions log.
4. Apply worktree when green; discard losers.

### Playbook D — `/best-of-n` for hard design forks

Use when two approaches compete (e.g. toast choreography, Net validate edge cases):

1. Same prompt + verify criteria to 2–3 models in worktrees.
2. Compare diffs + harness results.
3. Human picks; apply one; delete others.
4. Do **not** best-of-n on `Ranks.lua` threshold edits without a single canon owner.

### Playbook E — Cloud + babysit (unattended)

1. Ensure branch has `tests/run.lua` (or Cloud will skip/fail like GHA).
2. Kick Cloud for: Core fix, CI failure, doc sync, PR polish.
3. `/babysit` on the PR until checks green.
4. You: merge review + any Anniversary smoke listed in the skill.
5. Never give Cloud packager publish secrets without explicit officer approval.

### Playbook F — Prompt shape for “one leap”

```
Goal: <one vertical slice>
Checkout: edit under .worktrees/feat-church-of-beef-v1 (workspace stays Beef_Addon)
Constraints: layers UI→Core→Data; Interface 20506; no bots/automation
Verify offline: ./scripts/run-tests.sh (exit 0) before claiming done
Verify in-game: <none | /beef smoke | two-client Net> — do not fake in-game with unit tests
Out of scope: <explicit>
```

Larger leaps come from **tighter verify criteria + isolation**, not longer prose.

---

## 5. Recommended operating defaults for this repo

| Setting / artifact | Recommendation |
|--------------------|----------------|
| Workspace folder | Always `Beef_Addon` root |
| Run mode | Auto-review day-to-day; Run Everything only with hooks |
| Always-on rules | Stay at 2; put new policy in globs or skill |
| After Core/Data edit | Harness required (rule today; hook tomorrow) |
| After UI/Net/SV/slash | Human client smoke (skill today; never fully hands-off) |
| Parallel agents | Disjoint paths; one owner for `Ranks.lua` / TOC |
| Cloud | Core/Data/docs only until env ships |
| CI | Treat GHA green as necessary, not sufficient for V1 |
| Commits / PRs | Still human-requested (user rules) — hands-off ≠ silent push |

---

## 6. Phased adoption (aligns with `OPTIMIZATIONS.md`)

| Phase | Action | Babysitting delta |
|-------|--------|-------------------|
| **0 — Now** | Use Playbooks A–F with existing rules/skill/CI | Fewer “run tests?” nudges if prompts include verify block |
| **1 — Approve hooks** | Secret deny + `stop` harness loop + optional TOC | Stops incomplete Core turns |
| **2 — Worktree config** | `.cursor/worktrees.json` + document Multitask cuts | Safer parallel leaps |
| **3 — Cloud env** | `environment.json` + Lua 5.1 on feature branch | True background Core/CI work |
| **4 — Automations** | CI-completed → fix/`/babysit` | PR merges without watching logs |
| **5 — Packager CI** | Alpha zip only; no upload tokens in tree | Release prep, still human publish |

---

## 7. Loop engines for hands-off (expanded)

### 7.1 `/loop` skill (timed / dynamic wake) — not a grind

Cursor’s built-in skill (`~/.cursor/skills-cursor/loop/SKILL.md`):

- Syntax: `/loop [interval] <prompt>` (e.g. `5m`, `30s`, `2h`) or dynamic self-paced wakes.
- Mechanism: background shell emits a unique sentinel; `notify_on_output` wakes the agent. Prefer event watches over busy polling.
- **Disabled in cloud** environments.
- **Use for:** “check CI every 15m”, “when human drops a smoke note, continue”, Steinberger-style orchestrator wakes ([Forum loop engineering](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283)).
- **Do not use for:** “keep fixing until tests pass” — that is a **`stop` hook** or Ralph loop with external verify ([Agent best practices grind](https://cursor.com/blog/agent-best-practices)).

### 7.2 Session grind (`stop` → `followup_message`)

Official pattern: hooks on `stop` return a follow-up until scratchpad contains `DONE` or `loop_count` hits `loop_limit` (default **5**) ([Hooks](https://cursor.com/docs/hooks.md)). Community ports: [planning-with-files](https://github.com/OthmanAdi/planning-with-files/blob/master/docs/cursor.md), [cursor-loop](https://github.com/hellotommmy/cursor-loop).

**Beef mapping (approval-gated):** on stop, if checkout has tests and agent touched addon/tests → run `./scripts/run-tests.sh`; on fail, follow-up “fix until green”; on pass or cap, stop and leave harness log.

Never set `loop_limit: null` for unattended Beef sessions.

### 7.3 Ralph / Wiggum (fresh context)

Canonical idea ([Huntley](https://ghuntley.com/ralph/)): `while :; do cat PROMPT.md | agent ; done` — **code/git is memory**, conversation is disposable. Cursor adaptation ([Forum guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)): Plan Mode → mechanical tasks + grep/test verify → bash loop spawning `agent -p`. Ports: [ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor), [Claude plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum), [cursor.directory Ralph Loop](https://cursor.directory/plugins/ralph-loop).

| Use Ralph when | Avoid Ralph when |
|----------------|------------------|
| Many mechanical file transforms | UI taste / spectacle |
| Clear grep/test done criteria | Architecture / security-sensitive |
| Overnight Core migrations | Ambiguous “make nicer” |

Some power users now prefer one orchestrating agent + subagents over bash Ralph ([forum comment on Ralph guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)) — still keep **external verify**.

### 7.4 Multitask / worktrees / `/best-of-n`

- `/multitask`: async subagents; parent context **not** inherited — pass everything needed in the dispatch ([Multitask note](https://agentpatterns.ai/tools/cursor/multitask-subagents)).
- Compose with worktrees when edits overlap ([Worktrees](https://cursor.com/docs/configuration/worktrees.md), [Substack parallel guide](https://engincanveske.substack.com/p/running-parallel-agents-in-cursor)).
- Cap fan-out; community reports accidental spawn storms and merge pain.
- `/best-of-n`: compare models; **human** picks winner ([Agent best practices](https://cursor.com/blog/agent-best-practices)).

### 7.5 Continuous critique (hands-off ≠ self-graded)

Stack a **separate critic** after implement (Task / Bugbot / second model). Academic spine: Reflexion / Self-Refine / CAI — see [`22`](22-llm-critique-loops.md). Forum desire for native compliance verification before user sees output ([Auto-critique FR](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)). Soft polish caps: [`31`](31-loop-stop-conditions.md).

**Beef:** Critic may score against UI brief + layers; may **not** invent visual religion or reopen glossary locks.

### 7.6 Cross-tool comparison (what to steal)

| Capability | Cursor | Ralph bash | Claude `/loop` | Aider | Devin |
|------------|--------|------------|----------------|-------|-------|
| Fresh-context loop | CLI + bash | Native | No (in-session) | Manual | Task-scoped VM |
| Timed wake | `/loop` skill | cron | `/loop` | — | schedule/product |
| Parallel | Multitask / Cloud | parallel ports | limited | — | parallel sessions |
| Verify | Hooks + CI | grep/tests | in-session | tests in chat | sandbox tests |
| Best for CoB | Day-to-day + Cloud Core | Overnight mechanical | — | Ask/architect split idea | Mental model only |

---

## 8. Failure modes & hard caps (community-proven)

| Failure | Source | Hands-off mitigation |
|---------|--------|----------------------|
| Fix–refix thrash | [r/cursor endless loops](https://www.reddit.com/r/cursor/comments/1qh4tbf/agent_recently_getting_thrown_into_repeating/) | Max iterations; 3-strike → `BLOCKED.md`; new chat |
| Cost runaway AFK | [~$2000 loop](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/) | Spending limits; `loop_limit` ≤ 5; no uncapped stop |
| Diagnostic auth loop | [Forum](https://forum.cursor.com/t/cursor-ai-agent-gets-stuck-in-diagnostic-loop-instead-of-completing-tasks/161838) | Pre-auth `gh`; deny interactive prompts |
| Self-declared done | [Ralph guide](https://forum.cursor.com/t/ralph-cursor-guide/149998) | Only harness/grep/CI decide |
| Multitask merge hell | [Multitask note](https://agentpatterns.ai/tools/cursor/multitask-subagents) | Worktrees + disjoint ownership |
| Compliance drift | [Auto-critique FR](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556) | Critic pass + lean always-on rules |

---

## 9. Anti-patterns (Beef-specific)

- Opening `.worktrees/feat-church-of-beef-v1` as the Cursor workspace (rules/skills vanish).
- Parallel agents both editing `Data/Ranks.lua` or `ChurchOfBeef.toc`.
- Claiming “V1 done” from green desktop tests.
- Growing always-on rules until context is mostly policy.
- Hooks that fail-open on secret scans.
- Cloud Agents with packager publish credentials “for convenience.”
- Mid-turn redirecting a healthy Plan→Build instead of fixing the plan.
- Using `/loop` as a substitute for test grind (burns idle ticks).
- Uncapped Ralph/`stop` loops overnight without spending alerts.
- Multitask on sequential Net↔UI↔SV feature slices.

---

## 10. Sources

**Official / primary**

- [Cursor Hooks](https://cursor.com/docs/hooks.md)
- [Cursor Rules](https://cursor.com/docs/rules.md)
- [Cursor Skills](https://cursor.com/docs/skills.md)
- [Cloud Agent Best Practices](https://cursor.com/docs/cloud-agent/best-practices.md)
- [Cloud Agents](https://cursor.com/docs/cloud-agent.md) · [Setup](https://cursor.com/docs/cloud-agent/setup.md)
- [Run Modes (Auto-review / Allowlist / Run Everything)](https://cursor.com/docs/agent/security/run-modes.md)
- [Worktrees](https://cursor.com/docs/configuration/worktrees.md)
- [Subagents](https://cursor.com/docs/subagents)
- [Multi-agent / Multitask](https://cursor.com/help/ai-features/multi-agent.md)
- [Agents Window](https://cursor.com/docs/agent/agents-window.md)
- [Agent best practices (blog)](https://cursor.com/blog/agent-best-practices) — Plan Mode, grind `stop` hook, parallel worktrees, Cloud
- [CLI GitHub Actions](https://cursor.com/docs/cli/github-actions.md) · [Automations](https://cursor.com/docs/cloud-agent/automations.md)
- [Changelog](https://cursor.com/changelog) · [Releasebot digest](https://releasebot.io/updates/cursor)
- [Auto-review announcement](https://forum.cursor.com/t/auto-review-run-mode/161922)

**Ralph / loops / community**

- [Huntley — Ralph](https://ghuntley.com/ralph/) · [Huntley — loop engineering](https://ghuntley.com/loop)
- [Ralph Cursor Guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)
- [agrimsingh/ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor)
- [anthropics/claude-code ralph-wiggum](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- [hellotommmy/cursor-loop](https://github.com/hellotommmy/cursor-loop)
- [planning-with-files (Cursor)](https://github.com/OthmanAdi/planning-with-files/blob/master/docs/cursor.md)
- [agentpatterns.ai Multitask](https://agentpatterns.ai/tools/cursor/multitask-subagents)
- [Parallel agents + worktrees](https://engincanveske.substack.com/p/running-parallel-agents-in-cursor)
- [r/cursor cost runaway](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/)
- [r/cursor endless loops](https://www.reddit.com/r/cursor/comments/1qh4tbf/agent_recently_getting_thrown_into_repeating/)
- [Loop engineering forum](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283)
- [Auto-critique FR](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)
- [Reflexion](https://arxiv.org/abs/2303.11366) · [Self-Refine](https://arxiv.org/abs/2303.17651)
- Annotated digest: [`21b-cursor-loops-source-digest.md`](21b-cursor-loops-source-digest.md) (≥40 sources)

**In-repo:** `AGENTS.md`, `OPTIMIZATIONS.md`, `.cursor/skills/church-of-beef-dev/SKILL.md`, `.github/workflows/lua-tests.yml`, research `73-desktop-lua-testing`

---

## 11. One-page playbook card

```
HANDS-OFF BEEF
1. Plan with verify criteria (harness ± client).
2. Edit from parent workspace → worktree Lua paths.
3. Soft: rules/AGENTS/skill · Hard: hooks+CI (when approved).
4. Parallel only on disjoint scopes; one Ranks/TOC owner.
5. Cloud for Core/CI/PR babysit; human for /reload & guild net.
6. Review outcomes (diff + exit 0 + smoke), not every tool call.
7. Cap every loop (loop_limit / max Ralph iters / spend alerts).
8. Critique ≠ implementer; spectacle stays human-gated.
```

---

## 12. CoB-specific application (index)

| Leap type | Hands-off ceiling | Human still required |
|-----------|-------------------|----------------------|
| Core/Data + harness | High (hooks + CI when approved) | Diff review; commit/PR ask |
| UI chrome / toast motion | Medium (implement + critique) | `/reload` smoke; polish PASS |
| BeefNet / officer Commit | Low–medium | Two-client smoke |
| Guild-chat spectacle | None autonomous | Guild-night reaction (§13.11) |
| Packager publish | Denied to agents | Explicit human upload |

Deep playbooks: §§2–6 above. Loop engines: §7. Goal/loop syntax: [21](21-cursor-agent-loops-goals.md), [30](30-writing-effective-agent-goals.md).

---

## 13. Agent rules

1. Keep Cursor workspace on **Beef_Addon** root; edit worktree Lua from parent.  
2. Put verifiable done criteria in the Plan / Goal before large leaps.  
3. Do not treat green `lua tests/run.lua` as V1 UI or spectacle done.  
4. Do not grow always-on rules; prefer globs / skills / this research lane.  
5. Do not enable hooks, Cloud publish secrets, or packager upload without `OPTIMIZATIONS.md` approval.  
6. Parallel agents only on disjoint paths; one owner for `Ranks.lua` / TOC.  
7. Stop / followup / Ralph loops must cap (`loop_limit` / max iterations); emit best-so-far + handoff when capped.  
8. Prefer `/loop` for wakes, `stop` hooks/Ralph for verify-until-green — never conflate.  
9. Never claim AFK polish complete without a separate critic pass or human eyes for UI.

---

## 14. Open questions

1. Approve Phase-1 hooks (secret deny + stop harness) this milestone or after addon lands on default branch CI?  
2. `.cursor/worktrees.json` content — pin `feat-church-of-beef-v1` or ephemeral Multitask trees?  
3. Cloud `environment.json`: install Lua 5.1 via apt vs vendored binary?  
4. Should `/beef` smoke ever be partially automated (screenshots only) without driving the WoW process? ([26](26-visual-qa-screenshot-protocol.md))  
5. When to promote thin hands-off bullets into `AGENTS.md` vs leave in research ([36](36-cob-rules-skills-gap-audit.md))?  
6. Adopt a checked-in Ralph script for Core migrations, or wait for stop-hook grind only?  
7. Spending alert threshold for unattended Multitask / Cloud fan-out?
