# 21b — Cursor loops / goals / autonomous polish — source digest

**Lane:** Annotated bibliography for [`21-cursor-agent-loops-goals.md`](21-cursor-agent-loops-goals.md) and [`28-hands-off-cursor-workflows.md`](28-hands-off-cursor-workflows.md)  
**Also cited from:** [`29`](29-superpowers-loop-patterns.md) · [`31`](31-loop-stop-conditions.md) · [`37`](37-skill-draft-polish-loop.md) · [`49`](49-adversarial-overengineering.md)  
**Last updated:** 2026-07-26  
**Count:** ≥40 annotated entries (target ≥25); unique http(s) URLs in-file ≈54  
**Method:** Open-web search (Cursor docs/forum/changelog, Reddit, GitHub, blogs, YouTube, arXiv) + Parallel deep research `trun_91f36069f0964480a21f26d9c2e014e7` (`_deep-cursor-agent-loops-v2.md`)

Credibility legend: **P** = primary/official · **I** = implementer/repo · **C** = community report · **A** = academic · **S** = secondary synthesis  

> **Research ≠ product law.** This digest orients process design only; CoB product locks stay in the design spec / glossary / `verification.mdc`.

---

## External sources

This brief **is** the External sources companion for [`21`](21-cursor-agent-loops-goals.md). Entries below are grouped by venue with takeaways. Prefer primary (**P**) over secondary synthesis (**S**) when wiring hooks or skills.

---

## Official Cursor / product

### 1. Cursor — Best practices for coding with agents (blog) — **P**
- **URL:** https://cursor.com/blog/agent-best-practices  
- **Date:** 2026-01-09  
- **Takeaway:** Plan Mode first; lean rules; skills for dynamic workflows; **stop-hook grind** until scratchpad `DONE` / tests pass; TDD as verifiable goals; parallel worktrees + multi-model; Cloud for todo-list tasks; review carefully.

### 2. Cursor Docs — Hooks — **P**
- **URL:** https://cursor.com/docs/hooks  
- **Takeaway:** Agent-loop extension point; `stop` / `subagentStop` return `followup_message`; default `loop_limit` 5 (`null` = uncapped); permission allow/deny/ask; `failClosed` for security-sensitive hooks.

### 3. Cursor Docs — Cloud Agent Best Practices — **P**
- **URL:** https://cursor.com/docs/cloud-agent/best-practices  
- **Takeaway:** Environment → secrets/egress → `AGENTS.md`/skills → mold tools agents can use; treat agent as low-context human.

### 4. Cursor Docs — Cloud Agents — **P**
- **URL:** https://cursor.com/docs/cloud-agent  
- **Takeaway:** Isolated VMs, parallel runs, laptop optional; build/test/browser in VM; hooks on lifecycle.

### 5. Cursor Docs — Worktrees — **P**
- **URL:** https://cursor.com/docs/configuration/worktrees  
- **Takeaway:** Isolated checkouts per agent; `.cursor/worktrees.json` setup; `/worktree` and `/best-of-n` in editor; cleanup settings.

### 6. Cursor Docs — Subagents — **P**
- **URL:** https://cursor.com/docs/subagents  
- **Takeaway:** Isolated context; foreground vs background; parent must pass context; compose with worktrees for overlapping edits.

### 7. Cursor Changelog — **P**
- **URL:** https://cursor.com/changelog  
- **Takeaway:** Automations (`/automate`, GitHub/Slack triggers, computer use); cloud env setup; Team MCPs; evolving agent-window features (track before citing version-specific max parallel counts).

### 8. Cursor Forum — Auto-review Run Mode — **P**
- **URL:** https://forum.cursor.com/t/auto-review-run-mode/161922  
- **Date:** 2026-05-29  
- **Takeaway:** Allowlist → sandbox → classifier for longer runs; **not a security boundary**; steer via custom instructions / permissions.

### 9. Cursor Forum — Skills vs Commands vs Rules — **P/C**
- **URL:** https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875  
- **Takeaway:** Official taxonomy: Rules (system), Commands (`/`), Skills (portable, agent-decided), Subagents (isolated parallel). Prefer skills for deep loop runbooks.

### 10. Releasebot — Cursor release notes digest — **S**
- **URL:** https://releasebot.io/updates/cursor  
- **Takeaway:** Cloud conversation hooks (`stop`, etc.), `/babysit`, `/in-cloud`, local↔cloud handoff — useful for AFK PR loops.

---

## Ralph / Wiggum & loop engineering

### 11. Geoffrey Huntley — Ralph Wiggum as a “software engineer” — **P**
- **URL:** https://ghuntley.com/ralph/  
- **Date:** 2025-07-14 (updated through 2026)  
- **Takeaway:** Canonical `while :; do cat PROMPT.md | …; done`; one item per loop; tune “signs”; specs in files; faith in eventual consistency; monolithic Ralph > premature multi-agent.

### 12. Geoffrey Huntley — Loop engineering / everything is a Ralph loop — **P**
- **URL:** https://ghuntley.com/loop  
- **Takeaway:** Distinguishes Ralph (fresh spawn) from in-session `/loop`; “writing the program that prompts the agent.”

### 13. Cursor Forum — Ralph Cursor Guide — **C**
- **URL:** https://forum.cursor.com/t/ralph-cursor-guide/149998  
- **Date:** 2026-01-26  
- **Takeaway:** Fresh context + persistent code; Plan → CLI loop; **external verification** only; later comment: modern models + subagent orchestration may replace pure Ralph for some users.

### 14. Anthropic — Claude Code `ralph-wiggum` plugin README — **I**
- **URL:** https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum  
- **Takeaway:** Stop-hook intercepts exit; same prompt; `--completion-promise` / `--max-iterations`; files + git as memory.

### 15. agrimsingh/ralph-wiggum-cursor — **I**
- **URL:** https://github.com/agrimsingh/ralph-wiggum-cursor  
- **Takeaway:** Cursor CLI Ralph with `RALPH_TASK.md`, guardrails/signs, gutter detection, parallel worktrees, PR workflow.

### 16. cursor.directory — Ralph Loop plugin — **I**
- **URL:** https://cursor.directory/plugins/ralph-loop  
- **Takeaway:** Scratchpad state + skills (`ralph-loop`, `cancel-ralph`); completion promise pattern for IDE.

### 17. hexsprite/cursor-ralph — **I**
- **URL:** https://github.com/hexsprite/cursor-ralph  
- **Takeaway:** Documents Cursor **5-iteration stop-hook limit** and macOS osascript workaround for longer in-session Ralph.

### 18. hellotommmy/cursor-loop — **I**
- **URL:** https://github.com/hellotommmy/cursor-loop  
- **Takeaway:** Replicates Claude `/loop` via hooks + `validation_command` between iterations; explicit `loop_limit`.

### 19. OthmanAdi/planning-with-files (Cursor docs) — **I**
- **URL:** https://github.com/OthmanAdi/planning-with-files/blob/master/docs/cursor.md  
- **Takeaway:** `task_plan.md` + stop hook auto-continues until phases complete (capped retries) — goal-on-disk pattern.

### 20. YC / repomirror — “Coding agent in a while loop shipped 6 repos overnight” — **C**
- **URL:** https://github.com/repomirrorhq/repomirror/blob/main/repomirror.md  
- **Takeaway:** Field evidence for overnight Ralph-style loops when specs + tests exist.

### 21. snwfdhmp/awesome-ralph — **S**
- **URL:** https://github.com/snwfdhmp/awesome-ralph  
- **Takeaway:** Index of Ralph implementations/tools across stacks.

### 22. Agent Patterns — Ralph Wiggum loop — **S**
- **URL:** https://www.agentpatterns.ai/loop-engineering/ralph-wiggum-loop  
- **Takeaway:** Pattern writeup: fresh context, progress files, quality cliffs when context fills.

### 23. aiagentskit — Ralph Wiggum AI Loop explained — **S**
- **URL:** https://aiagentskit.com/blog/ralph-wiggum-ai-loop-technique  
- **Date:** 2026-01-31  
- **Takeaway:** Best/worst use cases; TDD feedback; Cursor/Claude/Aider ports; AFK coding framing.

### 24. leanware — Ralph Wiggum AI Agents (2026) — **S**
- **URL:** https://leanware.co/insights/ralph-wiggum-ai-coding  
- **Date:** 2026-01-28  
- **Takeaway:** Spec quality; review diffs not only outcomes; Ralph complements interactive Cursor rather than replacing it.

---

## Multitask / parallel / hands-off Cursor

### 25. agentpatterns.ai — Cursor `/multitask` — **S**
- **URL:** https://agentpatterns.ai/tools/cursor/multitask-subagents  
- **Takeaway:** Queue parallelization + auto-decomposition; background subagents; compose with `/worktree`; caveats (cost fan-out, sequential deps, merge pain).

### 26. Engincan Veske — Parallel agents with git worktrees — **C**
- **URL:** https://engincanveske.substack.com/p/running-parallel-agents-in-cursor  
- **Date:** 2026-04  
- **Takeaway:** Practical daily workflow; Plan+Agent per worktree; scope agents to avoid conflicts.

### 27. baeseokjae — Cursor Agent Best Practices 2026 — **S**
- **URL:** https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026  
- **Date:** 2026-05-11  
- **Takeaway:** Planner–Worker–Judge; lean always-apply rules; AGENTS.md vs rules; parallel worktree hygiene; testable done-conditions.

### 28. Vikas Tiwari — Cursor Hooks sit on the agent loop — **S**
- **URL:** https://tiwarivikas.in/writing/cursor-hooks-agent-loop  
- **Date:** 2026-04-16  
- **Takeaway:** Clear mental model of hooks vs lint; stop follow-ups; failClosed; start with one formatter then shell gates.

### 29. Cupcake / EQTY — Cursor harness reference — **S**
- **URL:** https://cupcake.eqtylab.io/reference/harnesses/cursor/  
- **Takeaway:** Compact schema notes for stop follow-ups and permission JSON (handy when writing hooks).

### 30. AlphaSignal — Auto-review cuts approval prompts — **S**
- **URL:** https://alphasignal.ai/news/cursor-s-auto-review-cuts-agent-approval-prompts-by-84-using-ai  
- **Date:** 2026-05-29  
- **Takeaway:** Industry read on why Auto-review exists (AFK duration vs click fatigue).

---

## Reddit / forum community (loops & autonomy)

### 31. r/cursor — Agentic Ask → plan.md → implement loop — **C**
- **URL:** https://www.reddit.com/r/cursor/comments/1rnqke6/agentic_coding_workflow_ask_planmd_implement_loop/  
- **Date:** 2026-03  
- **Takeaway:** Structured agentic engineering (not vibe coding); plan file as durable goal; compares Codex vs Cursor for multi-iteration loops.

### 32. r/cursor — Endless repeating fix loops — **C**
- **URL:** https://www.reddit.com/r/cursor/comments/1qh4tbf/agent_recently_getting_thrown_into_repeating/  
- **Date:** 2026-01  
- **Takeaway:** Unmonitored agents thrash same edit; need Stop + caps + better done criteria.

### 33. r/cursor — Agent loop spent ~$2000 — **C**
- **URL:** https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/  
- **Date:** 2026-04  
- **Takeaway:** Hard cost of uncapped AFK; spending limits mandatory for grind/Ralph.

### 34. r/cursor — Autonomous mode / wrapper; “Google ralph loops” — **C**
- **URL:** https://www.reddit.com/r/cursor/comments/1redmcm/autonomous_mode_wrapper_for_cursor/  
- **Date:** 2026-02  
- **Takeaway:** Community points to Ralph; TUI/tmux; “let agent finish bookkeeping” after interactive session.

### 35. r/cursor — Running agents issue→PR autonomously? — **C**
- **URL:** https://www.reddit.com/r/cursor/comments/1u0jyc8/is_anyone_actually_running_coding_agents/  
- **Date:** 2026-06  
- **Takeaway:** Questions verification/permissions for fully unattended PR workflows; human review still expected.

### 36. r/cursor — Cursor Agent running 24/7? — **C**
- **URL:** https://www.reddit.com/r/cursor/comments/1imvoqv/cursor_agent_running_247/  
- **Date:** 2025-02  
- **Takeaway:** Early appetite for backlog-driven continuous agents; foreshadows Automations/Ralph.

### 37. r/cursor — Anyone have good use cases for `/multitask`? — **C**
- **URL:** https://www.reddit.com/r/cursor/comments/1td4gc0/anyone_have_good_use_cases_for_cursor_multitask/  
- **Takeaway:** Community still exploring Multitask ROI (linked from related threads); treat as experimental fan-out.

### 38. Cursor Forum — Loop Engineering & orchestration — **C**
- **URL:** https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283  
- **Date:** 2026-06/07  
- **Takeaway:** Steinberger-style wake-every-N-minutes orchestrator; desire for multi-repo loops in Cursor Agents Window/CLI.

### 39. Cursor Forum — Loop Engineering feature request — **C**
- **URL:** https://forum.cursor.com/t/loop-engineering-more-autonomous-development/163082  
- **Date:** 2026-06  
- **Takeaway:** Proposed Research→Architect→Dev→Test→Review agent template with acceptance criteria.

### 40. Cursor Forum — Native Compliance Verification (Auto-Critique) — **C**
- **URL:** https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556  
- **Date:** 2025-12  
- **Takeaway:** Compliance drift vs `AGENTS.md`; manual verify script works; asks for native draft→critique→fix before user sees output.

### 41. Cursor Forum — Diagnostic loop instead of completing — **C**
- **URL:** https://forum.cursor.com/t/cursor-ai-agent-gets-stuck-in-diagnostic-loop-instead-of-completing-tasks/161838  
- **Date:** 2026-05  
- **Takeaway:** Auth/prompt blockers cause endless scan loops — preflight env for AFK.

### 42. r/ClaudeAI — Ralph endorsement thread (cited in deep research) — **C**
- **URL:** https://www.reddit.com/r/ClaudeAI/comments/1qlqaub  
- **Takeaway:** Community crystallization around Ralph as “official explainer” pattern (cross-tool, not Cursor-only).

---

## Academic & cross-tool

### 43. Shinn et al. — Reflexion — **A**
- **URL:** https://arxiv.org/abs/2303.11366  
- **Takeaway:** Verbal self-reflection + episodic memory improves agents without weight updates; template for critique ledgers between polish rounds.

### 44. Madaan et al. — Self-Refine — **A**
- **URL:** https://arxiv.org/abs/2303.17651  
- **Takeaway:** Iterative self-feedback; diminishing returns after a few rounds — justify critique caps.

### 45. Bai et al. — Constitutional AI — **A**
- **URL:** https://arxiv.org/abs/2212.08073  
- **Takeaway:** Critique/revise against written principles — map to CoB UI constitution (spec/brief), not free-form taste.

### 46. Aider — Chat modes (architect/ask/code) — **P**
- **URL:** https://aider.chat/docs/usage/modes.html  
- **Takeaway:** Separate planning discussion from editing; architect→editor dual-model loop; human ask/code bounce.

### 47. Aider — Loop feature discussion — **C**
- **URL:** https://github.com/Aider-AI/aider/issues/1841  
- **Takeaway:** Community desire for autonomous loops; Aider core remains conversational/HITL.

### 48. Devin — Product / autonomous engineer category — **P**
- **URL:** https://devin.ai/  
- **Takeaway:** Task→VM→PR async teammate; same mental model as Cursor Cloud (gates, not keystrokes).

### 49. Cognition — Introducing Devin — **P**
- **URL:** https://www.cognition.ai/blog/introducing-devin  
- **Takeaway:** Category-defining autonomous coding loop (plan/implement/test/PR).

### 50. prommer.net — Always-on AI coding agents 2026 — **S**
- **URL:** https://prommer.net/en/tech/guides/always-on-ai-coding-agents/  
- **Date:** 2026-07  
- **Takeaway:** Taxonomy: message-driven harnesses vs cloud async agents (Devin, Cursor Background, Copilot, Codex, Jules).

---

## YouTube / talks

### 51. Dev Interrupted — Inventing the Ralph Wiggum Loop (Huntley #256) — **C**
- **URL:** https://www.youtube.com/watch?v=C1YNGy6qusg  
- **Takeaway:** Origin story; bash loops + deterministic context allocation.

### 52. Geoffrey Huntley — Ralph Wiggum (why Claude Code plugin isn’t it) — **C**
- **URL:** https://www.youtube.com/watch?v=O2bBWDoxO4s  
- **Takeaway:** Fresh-context purity vs stop-hook in-session approximations.

### 53. Tool Use — Ryan Carson Explains The Ralph Wiggum Loop — **C**
- **URL:** https://www.youtube.com/watch?v=08xOaAN7zv0  
- **Takeaway:** Practitioner popularization (also referenced in Huntley’s blog ecosystem).

### 54. NeuralNine — How I Write My AGENTS.md Files — **C**
- **URL:** https://www.youtube.com/watch?v=6w88NVf2_lY  
- **Date:** 2026-01-19  
- **Takeaway:** Vendor-agnostic durable agent memory; complements loop state files.

---

## Local / in-repo anchors (not web, but binding for CoB)

| Artifact | Role |
|----------|------|
| `~/.cursor/skills-cursor/loop/SKILL.md` | Cursor `/loop` timed/dynamic wakes |
| `docs/research/agent-polish-vision/22`, `29`, `30`, `31` | Critique, superpowers patterns, goals, stop conditions |
| `.cursor/rules/verification.mdc` | Offline harness + in-game gates |
| `OPTIMIZATIONS.md` | Hooks/CI backlog needing approval |
| `_deep-cursor-agent-loops-v2.md` | Parallel deep-research dump for this topic |

---

## Quick conflict notes (synthesis hygiene)

1. **Ralph vs `/loop`:** Fresh process (Ralph) ≠ in-session interval (Cursor `/loop` skill or Claude `/loop`). Stack them; don’t synonymize.  
2. **Multitask max agents:** Community posts cite “up to 8”; always re-check [changelog](https://cursor.com/changelog) before treating as hard product law.  
3. **Skills channel:** Older posts say Skills/Subagents nightly-only; by mid-2026 they are widely available — verify in current Cursor build.  
4. **Auto-review ≠ security:** Forum + docs agree; CoB must keep deny hooks for packager/WTF.  
5. **Autonomy reality:** Reddit + forum show thrash/cost failures; unattended loops need caps + external verify + human gates for UI/Net.

---

## Search dump index

| File | Focus |
|------|-------|
| `_search-cursor-agent-loops.json` | Ralph ports, forum guide |
| `_search-cursor-loops-docs.json` | Hooks, Multitask, grind skills |
| `_search-ralph-wiggum-community.json` | Huntley, Claude plugin, CLIs |
| `_search-community-cursor-reddit.json` | Reddit/forum failure + loop engineering |
| `_search-cursor-agent-loops-goals.json` | Official best practices, planning-with-files, cursor-loop |
| `_search-hands-off-cursor.json` | Cloud, Auto-review, parallel agents |
| `_search-aider-reflexion-youtube.json` | Academic + Aider + worktrees |
| `_deep-cursor-agent-loops-v2.md` | Deep-research synthesis |
