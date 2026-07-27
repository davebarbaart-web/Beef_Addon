# 21 — Cursor agent loops, goals, continuous critique & autonomous polish

**Lane:** `docs/research/agent-polish-vision/` (agent process research — **not** product law)  
**Last updated:** 2026-07-26  
**Audience:** Maintainers / coding agents designing polish and Core loops for Church of Beef  
**Companions:** [`21b-cursor-loops-source-digest.md`](21b-cursor-loops-source-digest.md) · [`28-hands-off-cursor-workflows.md`](28-hands-off-cursor-workflows.md) · [`22-llm-critique-loops.md`](22-llm-critique-loops.md) · [`29-superpowers-loop-patterns.md`](29-superpowers-loop-patterns.md) · [`30-writing-effective-agent-goals.md`](30-writing-effective-agent-goals.md) · [`31-loop-stop-conditions.md`](31-loop-stop-conditions.md)  
**Search dumps:** `_search-cursor-agent-loops.json`, `_search-cursor-loops-docs.json`, `_search-ralph-wiggum-community.json`, `_search-community-cursor-reddit.json`, `_search-cursor-agent-loops-goals.json`, `_search-hands-off-cursor.json`, `_deep-cursor-agent-loops-v2.md`

---

## 0. One-line verdict

Autonomous polish is not “longer Agent turns.” It is a **closed loop**: durable goal on disk → act → **external verify** → critique/reflect → revise → **hard stop** — with Cursor providing three complementary engines (**session `stop` hooks**, **fresh-context Ralph / CLI loops**, **parallel Multitask / Cloud / Automations**). LLMs self-grade poorly; tests, grep, harness exit codes, and a second critic decide “done.”

---

## 1. Taxonomy of “loops” (do not conflate)

| Loop family | What repeats | Memory | Stop signal | Cursor surface |
|-------------|--------------|--------|-------------|----------------|
| **A. Intra-turn tool loop** | Model ↔ tools until it stops | Chat context | Model decides / user Stop | Default Agent |
| **B. Session grind (`stop` hook)** | Same conversation, auto follow-up | Chat + files | `followup_message` empty, `loop_limit`, DONE marker | [Hooks `stop`](https://cursor.com/docs/hooks) |
| **C. Fresh-context Ralph** | New agent process each iter | **Git / files only** | External verify (tests/grep) | CLI `agent -p` + bash / plugins |
| **D. Timed wake (`/loop` skill)** | Interval or event wake in session | Chat + shell sentinels | User stop / no re-arm | Cursor skill `loop` |
| **E. Parallel Multitask** | Many subagents once | Isolated contexts (± worktrees) | Each subagent ends | `/multitask`, Agents Window |
| **F. Cloud / Automations** | Event or schedule kicks VM agent | Branch + PR | Task/PR complete | [Cloud Agents](https://cursor.com/docs/cloud-agent), [Automations](https://cursor.com/docs/cloud-agent/automations) |
| **G. Critique cycle** | Implement → judge → fix | Rubric + reflection bullets | Cap rounds / plateau | Separate Task / Bugbot / second model |

**CoB mapping:** Core/Data → prefer **C + B** with `./scripts/run-tests.sh`. UI juice → **G** with human eyes ([`22`](22-llm-critique-loops.md)). Guild spectacle → never claim from A–F alone.

---

## 2. Official Cursor stack (verified)

### 2.1 Plan Mode → goals before code

Cursor’s own guidance: planning is the highest-leverage habit; Plan Mode researches, asks, writes a reviewable plan, waits for approval ([Agent best practices](https://cursor.com/blog/agent-best-practices)). Save plans to `.cursor/plans/` so later agents inherit durable goals. If the build diverges, **revert and refine the plan** rather than patching via chat.

**Goal quality rule (Cursor):** agents need *verifiable* targets — types, linters, tests — not vibes. Same post: “Agents can’t fix what they don’t know about.”

### 2.2 Hooks on the agent loop

[Hooks docs](https://cursor.com/docs/hooks): scripts observe/control stages via JSON over stdio. Critical for loops:

- **`stop`:** fires when the agent loop ends; may return `followup_message` to auto-submit the next user message (grind / Ralph-in-session).
- **`loop_count`:** how many auto-followups already fired (starts at 0).
- **`loop_limit`:** default **5**; set `null` to uncapped (dangerous — see §7).
- **`subagentStop`:** same follow-up pattern for subagents.
- **`beforeShellExecution` / `beforeMCPExecution`:** allow | deny | ask — hard gates for AFK runs.
- Failures default **fail-open** unless `failClosed: true` (use for secrets).

Canonical grind example in [Agent best practices](https://cursor.com/blog/agent-best-practices): `stop` → read scratchpad → if missing `DONE` and under max iterations → `followup_message` continue. Same pattern appears in [planning-with-files](https://github.com/OthmanAdi/planning-with-files/blob/master/docs/cursor.md) (phases in `task_plan.md`) and community [cursor-loop](https://github.com/hellotommmy/cursor-loop).

### 2.3 Skills, commands, rules, subagents

Forum clarification ([Skills vs Commands vs Rules](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875)):

| Artifact | Activation | Use for loops |
|----------|------------|---------------|
| Rules | Always / globs / intelligent | Short invariants (layers, Interface 20506) |
| Commands | `/` (agent may invoke) | `/review`, `/pr`, polish checklists |
| Skills | Agent-decided or `/` | Deep runbooks (`church-of-beef-dev`, `/loop`) |
| Subagents | Parallel / background | Isolated explore / implement / verify |

Skills keep encyclopedias out of always-on context; hooks enforce what soft text cannot.

### 2.4 Multitask, worktrees, `/best-of-n`

- **`/multitask`:** async background subagents — parallelize queued prompts or auto-decompose a large request ([agentpatterns.ai Multitask note](https://agentpatterns.ai/tools/cursor/multitask-subagents); changelog era Cursor 3.2+). Subagents get **no parent history** — parent must pass context in the dispatch prompt ([Subagents docs](https://cursor.com/docs/subagents)).
- **Worktrees:** filesystem isolation for parallel edits; configure `.cursor/worktrees.json` ([Worktrees](https://cursor.com/docs/configuration/worktrees)). Compose Multitask + worktrees when file overlap is likely.
- **`/best-of-n`:** same prompt, multiple models/worktrees; human picks winner ([Agent best practices](https://cursor.com/blog/agent-best-practices)).

Multitask is **fan-out**, not a self-calling polish loop. Use it for independent slices; serialize coupled Core↔UI↔Net work.

### 2.5 Cloud Agents, Automations, `/babysit`

Cloud agents run in isolated VMs, clone → branch → PR; laptop can close ([Cloud Agents](https://cursor.com/docs/cloud-agent)). Best practices: env first, secrets/egress, `AGENTS.md` + skills, mold tools for agents ([Cloud best practices](https://cursor.com/docs/cloud-agent/best-practices)).

Automations (2026): `/automate`, GitHub/Slack triggers, computer-use demos ([Changelog](https://cursor.com/changelog)). Cloud conversation hooks (`stop`, `beforeSubmitPrompt`, …) enable self-correcting remote loops ([Releasebot digest](https://releasebot.io/updates/cursor)).

`/babysit` / `/in-cloud`: keep PR/CI iteration off the local chat.

### 2.6 Auto-review run mode

Cursor 3.6 **Auto-review**: Shell/MCP/Fetch → allowlist → sandbox → classifier; fewer approval prompts for longer runs ([Forum announcement](https://forum.cursor.com/t/auto-review-run-mode/161922)). Official caveat: **not a security boundary** — use hooks + CI for hard policy.

### 2.7 Built-in `/loop` skill (Cursor)

Local skill (`~/.cursor/skills-cursor/loop/SKILL.md`):

- `/loop [interval] <prompt>` — fixed schedule (`5m`, `30s`, `2h`) or **dynamic** self-paced wakes.
- Mechanism: background shell emits sentinel (`AGENT_LOOP_TICK_*` / `AGENT_LOOP_WAKE_*`) + `notify_on_output` so the agent wakes without busy-polling.
- Disabled in **cloud** environments.
- Distinct from Claude Code’s `/loop` (session cron inside Claude) and from Ralph (fresh process).

**CoB uses:** wake on CI, wait for human `/reload` notes, or periodic “re-read critique ledger” — not for burning tokens while idle.

---

## 3. Ralph / Wiggum loops (fresh context, persistent code)

### 3.1 Canonical idea

[Geoffrey Huntley](https://ghuntley.com/ralph/) (Jul 2025): *“Ralph is a Bash loop.”*

```bash
while :; do cat PROMPT.md | claude-code ; done
```

Philosophy: **deterministically bad in a nondeterministic world** — tune prompts/specs (“signs”), don’t blame the loop. **One item per loop**; code/git is memory; context window is working memory only. Prefer monolithic single-repo Ralph over premature multi-agent meshes.

Related Huntley: [everything is a Ralph loop / loop engineering](https://ghuntley.com/loop) — shift from typing into an agent to **writing the program that prompts the agent**.

### 3.2 Why it works (forum + implementations)

[Ralph Cursor Guide](https://forum.cursor.com/t/ralph-cursor-guide/149998):

1. LLMs grade their own homework poorly.  
2. Long chats accumulate cost and confusion.  
3. Fresh CLI agent each iteration (~cheap context) + disk/git persistence.  
4. Stop on **external verification** (`grep` count, `tsc`, tests), never on “I am done.”

Two-phase recipe: **Plan Mode** (smart model) → atomic mechanical tasks + verify commands → **bash loop** spawning `agent -p` (cheaper model OK).

### 3.3 Ecosystem ports

| Port | Mechanism | Notes |
|------|-----------|-------|
| [anthropics/claude-code ralph-wiggum plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) | Stop hook re-feeds same prompt; `--completion-promise`, `--max-iterations` | In-session Ralph |
| [agrimsingh/ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor) | Cursor CLI + `RALPH_TASK.md` checkboxes + guardrails + parallel worktrees | Gutter detection, signs in `.ralph/guardrails.md` |
| [ericzakariasson/ralph-loop-plugin](https://github.com/ericzakariasson/ralph-loop-plugin) / [cursor.directory](https://cursor.directory/plugins/ralph-loop) | Scratchpad + stop hook | IDE plugin form |
| [hexsprite/cursor-ralph](https://github.com/hexsprite/cursor-ralph) | Stop hook + osascript past Cursor’s 5-iter limit | macOS workaround |
| [hellotommmy/cursor-loop](https://github.com/hellotommmy/cursor-loop) | Hooks + `loop-config.json` validation_command | Claude `/loop` analogue |

Community blogs: [aiagentskit Ralph explainer](https://aiagentskit.com/blog/ralph-wiggum-ai-loop-technique), [leanware](https://leanware.co/insights/ralph-wiggum-ai-coding), [awesomeclaude](https://awesomeclaude.ai/ralph-wiggum), YC field report [repomirror](https://github.com/repomirrorhq/repomirror/blob/main/repomirror.md).

**Good for:** mechanical migrations, harness-green Core fixes, lint/type grind.  
**Bad for:** taste/spectacle, architecture, security-critical paths, ambiguous “make UI nicer.”

---

## 4. Continuous critique & goals (research → practice)

### 4.1 Academic spine

| Paper / pattern | Mechanism | Transfer |
|-----------------|-----------|----------|
| [Reflexion](https://arxiv.org/abs/2303.11366) (Shinn et al., NeurIPS 2023) | Actor → Evaluator → verbal reflection → episodic memory | Keep short “lessons” on disk between polish rounds |
| [Self-Refine](https://arxiv.org/abs/2303.17651) (Madaan et al.) | Feedback ↔ refine; gains early (~3–4 rounds) | Cap critique cycles; actionable feedback |
| [Constitutional AI](https://arxiv.org/abs/2212.08073) | Critique/revise against written principles | CoB constitution = spec §10/§15 + UI brief + glossary |

See also [`22-llm-critique-loops.md`](22-llm-critique-loops.md) for CoB-specific critique architecture.

### 4.2 Production critique patterns

- **Planner–Worker–Judge** with external `tasks.md` done-conditions ([2026 agent best practices writeup](https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026)).
- **Native compliance verification request** — draft → verify against `AGENTS.md` → fix before user sees ([Forum FR](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)); today approximate with `stop` hook + compliance script or separate critic Task.
- **Bugbot / Agent Review** — second pass after generation ([Agent best practices](https://cursor.com/blog/agent-best-practices)).
- **Aider architect/editor** — separate reasoner vs editor models ([Aider modes](https://aider.chat/docs/usage/modes.html)); ask↔code bounce as lighter human loop.

### 4.3 Effective goals (summary)

Full templates: [`30-writing-effective-agent-goals.md`](30). Minimum for a loopable goal:

1. Player-facing intent  
2. Authority pointers (spec / `Ranks.lua` / UI brief)  
3. Binary acceptance + **commands** that prove it  
4. Critique budget (N rounds, separate critic)  
5. Artifacts to leave (diff, QA note, critique log)  
6. Stop conditions (max iter, blockers, reopen-locked)  
7. Human-only gates (spectacle, two-client Net, publish)

---

## 5. Adjacent ecosystems (steal patterns, not brands)

| System | Loop placement | Lesson for CoB |
|--------|----------------|----------------|
| **Claude Code `/loop` `/goal` `/schedule`** | In-session cron / self-pacing | Cursor `/loop` skill is the analogue; Ralph is the fresh-spawn analogue |
| **Aider** | Human ask→code; architect/editor dual call | Split plan vs edit; no built-in overnight Ralph in core ([issue #1841](https://github.com/Aider-AI/aider/issues/1841) discusses looping) |
| **Devin** | Cloud VM task ownership → PR | Same category as Cursor Cloud; humans at gates not keystrokes ([devin.ai](https://devin.ai/), [Cognition intro](https://www.cognition.ai/blog/introducing-devin)) |
| **OpenClaw / always-on harnesses** | Message-driven local agents | Event wake > busy poll ([2026 agents survey](https://prommer.net/en/tech/guides/always-on-ai-coding-agents/)) |
| **Steinberger-style orchestrator** | Wake every N minutes, triage threads | Forum: [Loop Engineering in Cursor](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283); maps to Automations + `/loop` |

---

## 6. CoB-recommended loop recipes

### Recipe L1 — Core/Data grind (offline-complete)

```
Plan Mode → mechanical tasks + verify: ./scripts/run-tests.sh
Optional: stop hook followup until exit 0 or loop_limit
Ralph CLI only if many mechanical file transforms remain
Human: none unless bootstrap/SV touched
```

### Recipe L2 — UI polish (critique-gated)

```
Read ui-polished-direction-for-agents.md
Implement under UI/ only
Separate critic Task vs rubric (22 / 25)
Max 2–3 soft rounds; hard gates: layers, TOC, 20506, harness if shared code
Human: /reload + /beef + BugSack (mandatory)
```

### Recipe L3 — Parallel safe slices

```
/multitask or worktrees:
  A: docs/research only
  B: Core module X + tests
Never parallelize Data/Ranks.lua or ChurchOfBeef.toc
```

### Recipe L4 — Cloud Core / CI babysit

```
environment.json with Lua 5.1 + scripts/run-tests.sh
Cloud agent on feature branch → PR
/babysit or Automation on workflow_run
Human: merge + Anniversary smoke
```

### Recipe L5 — Timed wake (not grind)

```
/loop 15m "If CI red on PR #N, diagnose; else idle summary"
or dynamic wake on log/file event
Stop when human says stop; kill sleeper PID
```

---

## 7. Failure modes (must design against)

| Failure | Evidence | Mitigation |
|---------|----------|------------|
| Fix–refix thrash | [r/cursor endless loops](https://www.reddit.com/r/cursor/comments/1qh4tbf/agent_recently_getting_thrown_into_repeating/) | Max iterations; “3 strikes → BLOCKED.md”; new chat |
| Cost runaway AFK | [~$2000 loop](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/) | Cap `loop_limit`; spending alerts; never uncapped stop hooks unattended |
| Diagnostic loop on auth | [Forum diagnostic loop](https://forum.cursor.com/t/cursor-ai-agent-gets-stuck-in-diagnostic-loop-instead-of-completing-tasks/161838) | Pre-auth `gh`; deny interactive prompts in AFK |
| Self-done lies | Ralph guide | External verify only |
| Multitask merge hell | Multitask writeups | Worktrees + disjoint ownership |
| Context rot | Huntley + Cursor blog | Fresh chat / Ralph rotation; lean always-apply rules |
| Compliance drift | [Auto-critique FR](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556) | Critic pass + hooks |
| Soft “security” | Auto-review docs | Hooks `failClosed` + CI |

Stop science for polish scores: [`31-loop-stop-conditions.md`](31).

---

## 8. YouTube / long-form (orientation)

| Video | Why watch |
|-------|-----------|
| [Inventing the Ralph Wiggum Loop — Huntley (#256)](https://www.youtube.com/watch?v=C1YNGy6qusg) | Origin, bash-loop theory |
| [Ralph Wiggum (why Claude Code’s plugin isn’t it)](https://www.youtube.com/watch?v=O2bBWDoxO4s) | Fresh vs in-session loops |
| [Ryan Carson Explains The Ralph Wiggum Loop](https://www.youtube.com/watch?v=08xOaAN7zv0) | Practitioner framing |
| [How I Write My AGENTS.md Files](https://www.youtube.com/watch?v=6w88NVf2_lY) | Durable goals / agent memory |

---

## 9. What CoB should adopt next (research → OPTIMIZATIONS)

Already strong: rules, `AGENTS.md`, `church-of-beef-dev`, `scripts/run-tests.sh`, GHA skip honesty.  
Highest leverage (needs human approval per `OPTIMIZATIONS.md`):

1. Project `stop` hook: harness follow-up when addon/tests touched (`loop_limit` ≤ 5).  
2. `beforeShellExecution` deny for packager upload / WTF wipe / force-push.  
3. `.cursor/worktrees.json` + Multitask playbook (parent workspace invariant).  
4. Cloud `environment.json` with Lua 5.1 for Core-only AFK.  
5. Optional critic skill that loads polish rubric — never invents visual religion.

**Do not** claim V1 complete from any loop until `docs/phases/v1-checklist.md` is walked.

---

## External sources

> Research ≠ product law. Full annotated bibliography (credibility tags, dates, takeaways): [`21b-cursor-loops-source-digest.md`](21b-cursor-loops-source-digest.md).

**Cursor official**

- [Best practices for coding with agents](https://cursor.com/blog/agent-best-practices)
- [Hooks](https://cursor.com/docs/hooks) · [Cloud Agent Best Practices](https://cursor.com/docs/cloud-agent/best-practices)
- [Cloud Agents](https://cursor.com/docs/cloud-agent) · [Automations](https://cursor.com/docs/cloud-agent/automations)
- [Worktrees](https://cursor.com/docs/configuration/worktrees) · [Subagents](https://cursor.com/docs/subagents)
- [Rules](https://cursor.com/docs/rules) · [Skills](https://cursor.com/docs/skills)
- [Changelog](https://cursor.com/changelog) · [Run Modes](https://cursor.com/docs/agent/security/run-modes)

**Cursor forum**

- [Ralph Cursor Guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)
- [Skills vs Commands vs Rules](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875)
- [Loop engineering & orchestration](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283)
- [Native compliance / auto-critique loops](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)
- [Endless loop past review](https://forum.cursor.com/t/cursor-agent-enters-endless-loop-without-progressing-past-review-step/126815)
- [Diagnostic loop](https://forum.cursor.com/t/cursor-ai-agent-gets-stuck-in-diagnostic-loop-instead-of-completing-tasks/161838)
- [Auto-review Run Mode](https://forum.cursor.com/t/auto-review-run-mode/161922)
- [Long-running agents](https://forum.cursor.com/t/share-your-experience-with-long-running-agents/151697)

**Reddit / community**

- [r/cursor — repeating loop](https://www.reddit.com/r/cursor/comments/1qh4tbf/agent_recently_getting_thrown_into_repeating/)
- [r/cursor — high-spend stuck loop](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/)
- [r/cursor — Ask / plan.md / implement](https://www.reddit.com/r/cursor/comments/1rnqke6/agentic_coding_workflow_ask_planmd_implement_loop/)
- [Multitask / subagents pattern note](https://agentpatterns.ai/tools/cursor/multitask-subagents)

**GitHub / Ralph / research**

- [ghuntley — Ralph](https://ghuntley.com/ralph/)
- [agrimsingh/ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor)
- [anthropics/claude-code ralph-wiggum plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- [hellotommmy/cursor-loop](https://github.com/hellotommmy/cursor-loop)
- [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files/blob/master/docs/cursor.md)
- [Reflexion (arXiv:2303.11366)](https://arxiv.org/abs/2303.11366) · [Self-Refine (arXiv:2303.17651)](https://arxiv.org/abs/2303.17651)

**YouTube (orientation)** — see §8.

**Siblings:** [21b](21b-cursor-loops-source-digest.md) · [28](28-hands-off-cursor-workflows.md) · [29](29-superpowers-loop-patterns.md) · [31](31-loop-stop-conditions.md) · [49](49-adversarial-overengineering.md)
