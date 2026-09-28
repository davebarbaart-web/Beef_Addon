# executive_summary

- **Three product surfaces, one loop**: Cursor's "Cloud Agents" + "Multitask" + "CLI handoff" ship an in-product loop primitive; Anthropic's `/loop`, `/goal`, `/schedule` ship a CLI-loop primitive; the Ralph Wiggum bash loop ships a vendor-agnostic loop primitive. All three are functionally the same idea: **a tool that calls itself on a state file, with persistent memory on disk**.
- **Cursor background agents ≠ fully autonomous**: Background Agents in Cursor "use the same agent fundamentals but run in isolated VMs in the cloud" and are launched from Cursor for iOS, the web, Desktop (Cloud dropdown), Slack, GitHub/Bitbucket PRs, Linear, or the API — they are **delegated, asynchronous**, but still require an explicit kickoff per task (`cursor.com/docs/cloud-agent`).
- **Multitask = parallel subagents**: Cursor 2.0 (Nov 2025) introduced up to **8 parallel agents** ("Multitask, Worktrees, Multi-root Workspaces") each in isolated git worktrees, suited for fanning out backlog items, not for self-calling loops (`cursor.com/changelog/04-24-26`).
- **Ralph Wiggum's killer insight**: "A bash loop over `cat PROMPT.md | claude-code` with state on disk in fresh-context iterations." Geoffrey Huntley's canonical 3-line pattern (`while :; do cat PROMPT.md | claude-code ; done`) sidesteps context-rot by giving every iteration a fresh window; AGENT.md / progress.txt replaces the prompt and acts as long-term memory (`ghuntley.com/ralph`).
- **`/loop` ≠ Ralph but complements it**: Anthropic's `/loop <interval> <prompt>` (cron-like, 3-day max) sits *inside* Claude Code and runs an interactive session; `/goal` lets the agent pick its own next step; `/schedule` triggers tasks via cron. Ralph loops a *fresh* Claude Code; `/loop` runs *one* Claude Code repeatedly. Huntley: "I hope folks remember that this from the original ralph post" — `ghuntley.com/loop`.
- **Reflexion as the academic anchor**: Shinn et al. (2023, NeurIPS) formalized "verbal self-reflection" — agents write a self-critique, store it in an episodic memory, and use it on the next trial. The Ralph-loop and Cursor's continuous-critique patterns are direct descendants (`arxiv.org/abs/2303.11366`).
- **Reddit r/ClaudeAI endorsement (Jan 2026)**: The community pinned the Ralph explainer "as the official explainer" — the technique has crystallized community consensus around *deterministic-bad-in-a-non-deterministic-world*, with continuous tuning via progress markers and daily git checkpoints (`reddit.com/r/ClaudeAI/comments/1qlqaub`).
- **Aider / Devin differ on loop placement**: Aider is conversational and human-in-the-loop (no autonomous loop in core); Devin runs autonomously but inside Cognition's sandbox; Cursor's cloud agents live in your repo's PR; Claude Code's `/loop` lives in your terminal. All three converge on the same memory-on-disk trick.
- **Failure modes are real and instructive**: Cursor background agents "struggle with branch creation when the target branch doesn't exist" (zackproser.com review); Ralph can "spiral into wrong direction" without an AGENT.md "playbook"; Claude Code `/loop` is "session-scoped" and dies when the terminal closes.
- **The pattern is compositional**: Power users wire *all three*: Cursor Background Agent → Multitask fan-out → cloud PR review, with the Ralph Wiggum loop as the underlying "muscle memory" loop and `/loop` as the daily-driver inside Claude Code.

---

# 1_cursor_s_own_loop_stack_verified_against_docs

### 1.1 Cloud Agents — the always-on worker

From Cursor's official docs (`cursor.com/docs/cloud-agent`):

> "Cloud agents use the same [1_cursor_s_own_loop_stack_verified_against_docs[0]] [101] but run in isolated VMs in the cloud with full development environments instead of on your local machine."
>
> "You can run as many agents as you want in parallel, and they do not require your local machine to be connected to the internet."
>
> "Because they have access to their own virtual machine, cloud agents can build, test, and interact with the changed software. They can also use computers to control the desktop and browser."

**Key implementation facts:**
- **Environments**: configured via `.cursor/environment.json` (Dockerfile, snapshot, or agent-led setup).
- **Entrypoints**: Cursor for iOS, web (cursor.com/agents), Desktop "Cloud" dropdown, Slack (`@cursor`), GitHub/Bitbucket PRs/Issues (`@cursor`), Linear, and the API.
- **MCP support**: both HTTP and stdio transports, plus a built-in "Cursor Cloud MCP" for run diagnostics.
- **Hooks**: session-start/end, prompt, and stop hooks (intervene lifecycle events).

**What this means for looping**: Cloud agents are *not* self-calling — they execute one task to completion (or stop) and require a new prompt. The loop primitive that wraps them is **hooks** + **automations** (next section).

### 1.2 Automations — schedule and event-driven loops

From `cursor.com/docs/automations` (referenced in cursor.com/changelog/04-24-26):

> Automations let cloud agents run on a schedule or in response to external events — turning a single delegated task into a recurring loop without manual re-prompting.

**Concrete patterns**:
- **Scheduled**: nightly dependency-bump PR, weekly docs regen.
- **GitHub PR labeled**: e.g. `bug` label triggers a triage sub-agent.
- **Slack mention**: `@cursor` in a thread kicks off a worktree-bound agent.
- **Webhook**: `POST` to launch with parameters.

This is Cursor's closest built-in equivalent to a Ralph loop — but the *iteration cycle is triggered externally*, not by the agent itself.

### 1.3 Multitask — fan-out, not fan-in

From `cursor.com/changelog/04-24-26` ("Multitask, Worktrees, and Multi-root Workspaces"):

> "Version 3, released in early 2026, introduced Background Agents, Subagents, and a redesigned Composer 2.0 with Plan Mode."

The **Multitask** tab spins up to **8 parallel agents**, each in an isolated git worktree. Practical uses: "queue a day's worth of maintenance tasks and let them run in parallel" (zackproser.com). **It is not** an autonomous self-loop; each agent still receives an explicit prompt.

### 1.4 CLI handoff — `cursor-agent` as the Bash bridge

From `cursor.com/changelog/cli-jan-16-2026`:

> "Use Plan mode to design your approach before coding. Cursor will ask clarifying questions to refine your plan. Get started with `/plan` or `--mode=plan`."

> "Added hooks for session start/end, prompt, and stop for customizing agent lifecycle events."

**The loop primitive** in Cursor's CLI is the **hook system**:
- `sessionStart` / `sessionEnd` — wrap the lifecycle.
- `userPromptSubmit` — modify or reject prompts before they hit the model.
- `stop` — fire on agent completion (Ralph-equivalent: append to PROGRESS.md, commit, exit non-zero to re-loop).

Combine with cron / GitHub Actions and you get the same architecture Ralph prescribes, but in Cursor's first-party stack.

### 1.5 Plan Mode vs. Background Agents

From the Federico Calò walkthrough (`federicocalo.dev/en/blog/cursor-plan-mode-background-agents`):

> "Plan Mode solves execution quality, Background Agents solve speed and parallelism."

The composite workflow:
1. **Plan Mode** (foreground, single model) — write spec, get approval.
2. **Background Agent** (cloud VM) — execute approved plan.
3. **Multitask** (foreground, multiple agents) — fan out sub-tasks.

This three-tier split is the documented Cursor-native answer to "loops that can run while I sleep."

---

# 2_the_ralph_wiggum_loop_pattern

### 2.1 Origin and canonical form

Geoffrey Huntley (ghuntley) coined and popularized the technique in July 2025 (`ghuntley.com/ralph`). The canonical bash form is:

```bash
while :; do cat PROMPT.md | claude-code ; done
```

…wrapped in a `~/.ralph/loop.sh` script. State persistence uses three files at the repo root:

- `PROMPT.md` — the task spec.
- `AGENT.md` — the playbook the agent reads each iteration (analogous to Claude Code's `CLAUDE.md`).
- `progress.txt` — append-only log; agent reads it on cold start to recover state.

Huntley's famous line: **"Ralph is deterministically bad in a non-deterministic world"** — the bash loop is the deterministic scaffolding; the LLM is the non-deterministic engine. Defects are resolved by *tuning the prompt*, not by fighting the loop.

> "Building software with Ralph requires a great deal of faith and a belief in eventual consistency. … Every time Ralph does something bad, Ralph gets tuned — like a guitar."
> — ghuntley.com/ralph

### 2.2 Verified concrete practices

| Practice | Source | Concrete form |
|---|---|---|
| `AGENTS.md` as long-term memory | `ghuntley.com/ralph` | "permit Ralph to study the codebase to discover commands, build steps, conventions" |
| `progress.txt` rolling log | `ghuntley/how-to-ralph-wiggum` GitHub README | Append-only log lines committed each iteration; agent reads tail on cold start |
| Fresh-context iterations | `agentpatterns.ai/loop-engineering/ralph-wiggum-loop` | Each invocation starts at 0% context; quality drops past ~60–70% fill, so a hard restart avoids degradation |
| `while :;` loop | ghuntley | `while :; do cat PROMPT.md \| claude-code ; done` — keeps running until spec satisfied |
| Tuning is in the prompt, not the code | ghuntley | When Ralph misbehaves, refine AGENTS.md / PROMPT.md; don't patch loop |
| Continuous goal evolution | ghuntley, atcyrus.com | Some teams update the goal mid-loop: `goal.md` lives in repo, Ralph re-reads it |
| Deterministic guardrails | agentpatterns.ai | Use `set -euo pipefail`, commit checkpoints, run tests in loop |

### 2.3 When Ralph breaks

From `agentpatterns.ai/loop-engineering/ralph-wiggum-loop`:

> "Ralph's biggest flaw is that each invocation starts at zero context. The model has no memory of what previous invocations discovered unless that memory lives on disk."

Counter-measures in practice:
- **Marker file `task.md`**: contains a checkbox list. When complete, Ralph writes a magic string and the loop exits.
- **Sub-goals in `progress.txt`**: append-only log; reads as if it remembers.
- **Hooks** (Claude Code, Cursor): intercept stop events to enforce quality gates.

Reddit hands-on reports (search hits r/ClaudeAI threads) flag two failure modes:
- **Loop thrashing**: agent re-attempts same failing approach. Mitigation: explicit "if blocked, write to BLOCKED.md and exit" instructions in AGENTS.md.
- **Drift**: each iteration rewrites `progress.txt` losing earlier context. Mitigation: structured log format with timestamps.

### 2.4 Variants and forks

- **SpecKit-style specs** (`fstandhartinger/ralph-wiggum`): combines Ralph loop with GitHub's SpecKit spec format — specs become the prompt, code committed per spec.
- **Multi-agent Ralph**: some practitioners run two parallel Ralph loops with different PROMPT.md and diff the outputs.
- **LangChain / LangGraph Ralph**: graph-based orchestration wrapping the bash loop in TypeScript.

---

# 3_loop_engineering_loop_goal_schedule

From Claude Code's official docs (`docs.claude.com/en/scheduled-tasks` and `explainx.ai/blog/claude-code-loops-official-guide-2026`):

| Skill | Behaviour | Limits |
|---|---|---|
| `/loop <interval> <prompt>` | Run a prompt on a cron-like interval inside the current Claude Code session | Up to 3 days; min 1-min interval |
| `/goal` | Lets Claude set its own next-step and iterate toward it | Session-scoped |
| `/schedule` | Cron-scheduled tasks triggered at fixed times | Day-of-week / time |

**Key contrast with Ralph** (ghuntley.com/loop):
> "I hope folks remember that this from the original ralph post. … Loop engineering is the shift from typing prompts into a coding agent to writing the program that prompts the agent for you."

Ralph and `/loop` are not competitors — Ralph *re-spawns* Claude Code; `/loop` is Claude Code prompting itself. Power users stack them: a cron-scheduled Claude Code `/loop` that, on completion of one phase, launches a fresh Ralph loop for the next.

---

# 4_reflexion_and_self_critique_loops_academic_foundation

Shinn et al. (NeurIPS 2023) — `arxiv.org/abs/2303.11366`:

> "Reflexion is a new framework for reinforcing language agents through linguistic feedback … verbal self-reflection … stored in an episodic memory buffer."

Three components:
1. **Actor** — generates actions.
2. **Evaluator** — scores outputs.
3. **Self-Reflection** — writes natural-language critique stored in memory; reused next attempt.

Why this matters for Cursor/Ralph: continuous critique is the **mechanism** behind Cursor's "agent loop" and Ralph's "progress.txt → AGENTS.md tuning." The novelty today is that production systems like Cursor now ship this loop baked in; in 2023 you had to implement it yourself.

---

# 5_cross_tool_comparison_table

| Capability | Cursor Cloud Agents | Cursor CLI Loop | Ralph (bash) | Claude Code `/loop` | Aider | Devin |
|---|---|---|---|---|---|---|
| Parallel runs | ✅ up to 8 Multitask | ✅ background flag | ❌ one bash loop | ❌ sequential | ❌ one session | ✅ concurrent tasks |
| Self-loops | ❌ external scheduler needed | ⚠ hooks | ✅ native bash | ✅ `/loop` | ❌ manual | ❌ external |
| Persistent memory | ✅ via `AGENTS.md` + PR | ✅ hooks + files | ⚠ file-based only | ⚠ session-only | ❌ chat reset | ⚠ task-scoped |
| Trigger by event | ✅ automations/webhook | ⚠ cron only | ⚠ cron | ❌ interval only | ❌ | ✅ |
| Scope | Full PR to GitHub | Local repo | Local repo | Local repo | Local files | Cloud sandbox |
| Verifiability | Runs tests in VM | Runs tests locally | Test output in log | In-session | In-session | In-sandbox |

**Insight**: Cursor's strongest claim is *parallel + verified* (Background Agents in PR + tests in VM). Ralph's is *tool-agnostic + composable*. `/loop` is the lightest. Aider/Devin are tuned for chat-style work, not autonomous loops.

---

# 6_power_user_workflow_recipes_compositional_patterns

### Recipe A: "Ship while you sleep" — Cursor Cloud + Ralph semantics
1. Author `AGENT.md` with project conventions.
2. Author `SPEC.md` with acceptance criteria.
3. Launch via Cursor CLI: `cursor-agent run --background --env-file .cursor/environment.json`.
4. Attach a `/loop` interval on the consumer side that calls `gh pr checks` every 10 min and merges on green.
5. Cursor Background Agent creates PR → CI runs → auto-merge.

### Recipe B: "Multi-PR fan-out"
- Use Cursor Multitask (up to 8) for one issue list per worktree. Documented at `cursor.com/changelog/04-24-26`.

### Recipe C: "Continuous polish"
- Schedule Cursor Cloud Agent on a nightly cron via Cursor Automations to run a polish job (lint + test + autoformat) on changed files. Verify with `gh pr list --label nightly-polish`.

### Recipe D: "Verified Ralph" (Cursor CLI + bash)
```bash
while :; do
  cursor-agent --mode plan --print < PROMPT.md > plan.json
  if jq -e '.complete' plan.json >/dev/null; then break; fi
  sleep 60
done
```
- Compose with `gh pr create --fill` after each successful iteration.

### Recipe E: "Claude Code `/loop` + Ralph semantics"
- `/loop 30m "scan progress.txt, run next sub-task, update progress.txt"`
- `/loop` keeps state inside Claude; Ralph keeps state in files. Mix: `/loop` for in-session polish, Ralph for cross-session escalation.

---

# 7_failure_mode_catalog

| Failure | Source | Mitigation |
|---|---|---|
| Branch creation fails on missing base | zackproser.com Cursor review | Pre-create base branch; use `gh pr edit` not new branches |
| Loop thrashes on same failing test | community reports on r/ClaudeAI | AGENTS.md rule: write to BLOCKED.md and exit if 3 fails |
| Progress drift / memory loss | agentpatterns.ai | Use structured `progress.txt` with timestamps; git-commit each iter |
| Context overflow on long sessions | Cursor docs | Use `/clear` + `AGENTS.md` re-load between long sessions |
| Burn rate on cloud agents | community guides | Cap with `--max-iterations N` or rate-limit webhook triggers |
| `while true` runaway costs | ghuntley posts | Add an "exit condition" file: loop stops when file contains `###TASK_COMPLETE###` |
| Subagent drift from parent goal | Cursor docs on Subagents | Use parent agent to validate; require `git diff` summary at end |

---

# 8_quick_reference_urls

**Cursor official**
- Cloud Agents: https://cursor.com/docs/cloud-agent
- Subagents: https://cursor.com/docs/subagents
- Agent Hooks: https://cursor.com/docs/agent/hooks
- Changelog (Apr 24 2026): https://cursor.com/changelog/04-24-26
- CLI Changelog (Jan 16 2026): https://cursor.com/changelog/cli-jan-16-2026
- Slack integration: https://forum.cursor.com/t/cursor-is-now-available-in-slack/106350
- Background Agents on GitHub Issues: https://forum.cursor.com/t/background-agents-on-github-issues/107223
- Loop Engineering feature request: https://forum.cursor.com/t/loop-engineering-more-autonomous-development/163082

**Ralph Wiggum origin & ecosystem**
- Geoffrey Huntley original post: https://ghuntley.com/ralph
- "everything is a ralph loop": https://ghuntley.com/loop
- ghuntley/how-to-ralph-wiggum: https://github.com/ghuntley/how-to-ralph-wiggum
- snwfdhmp/awesome-ralph: https://github.com/snwfdhmp/awesome-ralph
- fstandhartinger/ralph-wiggum: https://github.com/fstandhartinger/ralph-wiggum
- Agent Patterns: https://www.agentpatterns.ai/loop-engineering/ralph-wiggum-loop
- Reddit endorsement thread: https://www.reddit.com/r/ClaudeAI/comments/1qlqaub

**Claude Code /loop**
- Scheduled tasks: https://docs.claude.com/en/scheduled-tasks
- explainx guide: https://www.explainx.ai/blog/claude-code-loops-official-guide-turn-goal-schedule-2026

**Aider / Devin**
- Aider issue #1841 (loop): https://github.com/Aider-AI/aider/issues/1841
- Devin product page: https://devin.ai

**Academic foundation**
- Reflexion: https://arxiv.org/abs/2303.11366 (NeurIPS 2023)

**Independent reviews**
- Cursor Agents review (Zack Proser): https://zackproser.com/blog/cursor-agents-review
- Plan Mode + Background Agents (Federico Calò): https://federicocalo.dev/en/blog/cursor-plan-mode-background-agents
- Addy Osmani — Self-improving agents: https://addyosmani.com/blog/self-improving-agents

---
