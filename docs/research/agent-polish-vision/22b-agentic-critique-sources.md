# 22b — Agentic critique sources (≥20)

**Audience:** Agents and humans wiring Church of Beef polish / review loops.  
**Companion tracks:** [`22-llm-critique-loops.md`](22-llm-critique-loops.md), [`24-definition-of-done-polish.md`](24-definition-of-done-polish.md), [`25-ui-polish-critique-rubric.md`](25-ui-polish-critique-rubric.md), [`26-visual-qa-screenshot-protocol.md`](26-visual-qa-screenshot-protocol.md), [`27-multi-agent-adversarial-review.md`](27-multi-agent-adversarial-review.md), [`31-loop-stop-conditions.md`](31-loop-stop-conditions.md), [`33-parallel-synthesis-methods.md`](33-parallel-synthesis-methods.md), [`35-subjective-quality-harnesses.md`](35-subjective-quality-harnesses.md).  
**Status:** Research bibliography + stealable patterns — **not** product law. Spec §10/§15 + glossary 74–81 win.  
**Client constraint:** Lua 5.1 Anniversary addon (`## Interface: 20506`); offline `lua tests/run.lua` for Core/Data; **human in-game smoke** required for UI / Net / SV / slash / spectacle.  
**Date:** 2026-07-26  
**Provenance:** Parallel deep research `trun_91f36069f0964480a5f638b6b4648212` + parallel-cli searches in this folder (`_search-langgraph-eval-opt.json`, `_search-crewai-autogen-critique.json`, `_search-cursor-bugbot-patterns.json`, `_search-vlm-visual-qa.json`, `_search-reflexion-cai-selfrefine.json`, `_search-anthropic-eval-opt.json`, `_search-reddit-agent-critique.json`, `_search-youtube-multiagent.json`, `_search-bugbot-docs.json`, `_deep-agentic-critique.json`).

---

## Shared pattern (one sentence)

Across arXiv, LangGraph/CrewAI/AutoGen, Cursor Bugbot, and community review councils, critique systems converge on **Generate → Critique → Revise → Stop** with an **external termination oracle** — never an unbounded self-score ([Anthropic — Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents); extract in `_deep-agentic-critique.extract.md`).

For CoB, prefer **Bounded Iterative Refinement (BIR)** as a **workflow** (deterministic gates + capped LLM critique), not a fully autonomous agent that “polishes forever.”

---

## Annotated source catalog (≥20)

| # | Source | Kind | Steal for CoB |
|---|--------|------|----------------|
| 1 | [Reflexion (arXiv:2303.11366)](https://arxiv.org/abs/2303.11366) | arXiv | Actor → Evaluator → verbal reflection memory; **≤3 trials** then stop; sliding-window mem |
| 2 | [Self-Refine (arXiv:2303.17651)](https://arxiv.org/abs/2303.17651) | arXiv | Same-model feedback loop; gains early; **plateau/degrade after ~3**; needs external oracle |
| 3 | [Constitutional AI (arXiv:2212.08073)](https://arxiv.org/abs/2212.08073) | arXiv | Explicit principles → critique → revise; revision **budget** + external selector; CoB “constitution” = spec/glossary/UI brief |
| 4 | [MT-Bench / LLM-as-Judge (arXiv:2306.05685)](https://arxiv.org/abs/2306.05685) | arXiv | Position / verbosity / self-enhancement biases; **swap order**; anchored multi-point scales |
| 5 | [Multi-Agent Debate (arXiv:2305.14325)](https://arxiv.org/abs/2305.14325) | arXiv | Short debate rounds; task-dependent gains; can **regress** — use only on trust/Net stakes |
| 6 | [LATS (arXiv:2310.04406)](https://arxiv.org/abs/2310.04406) | arXiv | Reflection + MCTS; needs **executable reward**; for CoB Core = harness; for UI = human smoke, not LATS |
| 7 | [D3: Debate, Deliberate, Decide (arXiv:2410.04663)](https://arxiv.org/abs/2410.04663) | arXiv | Structured disagreement before decide; maps to Meta-reviewer filtering |
| 8 | [AutoGen (arXiv:2308.08155)](https://arxiv.org/abs/2308.08155) · [MSR AutoGen](https://www.microsoft.com/en-us/research/project/autogen/) | arXiv + docs | Multi-agent conversation; critic/reviewer personas; termination via message **or** `max_round` |
| 9 | [Anthropic — Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) (Dec 2024) | Industry | **Evaluator-optimizer** workflow; clear criteria + measurable iteration value; start simple; coding agents still need **human review** for system fit |
| 10 | [LangGraph workflows tutorial — Evaluator-optimizer](https://langchain-ai.github.io/langgraph/tutorials/workflows/) | Docs | Canonical generate → evaluate → route; stop on pass **or** `max_iter` |
| 11 | [LangChain — Reflection Agents](https://www.langchain.com/blog/reflection-agents) | Blog + YT | Basic reflection → Reflexion → LATS; fixed `MAX_ITERATIONS`; [YouTube](https://www.youtube.com/watch?v=v5ymBTXNqtk) |
| 12 | [CrewAI Agents — `max_iter` / `max_retry_limit`](https://docs.crewai.com/en/concepts/agents) | Docs | Hard caps as kill-switch (default `max_iter` high — **lower for CoB polish to 2–3**) |
| 13 | [CrewAI Tasks](https://docs.crewai.com/en/concepts/tasks) | Docs | Task retries / guardrail failure bounds; do not confuse with quality oracle |
| 14 | [Cursor — Agent best practices](https://cursor.com/blog/agent-best-practices) (Jan 2026) | Blog | Verifiable goals (tests); Agent Review ≠ build; parallel agents + careful human review |
| 15 | [Cursor — Agent Review docs](https://cursor.com/docs/agent/agent-review) | Docs | Local Quick/Deep review before push |
| 16 | [Cursor — Bugbot docs](https://cursor.com/docs/bugbot) | Docs | PR-stage review; `.cursor/BUGBOT.md` project rules; Team/repo rules merge order |
| 17 | [Cursor forum — Bugbot vs Agent Review](https://forum.cursor.com/t/difference-between-bugbot-and-agent-review/163425) | Community | Complementary stages: local early gate + PR gate; different prompts can catch different bugs |
| 18 | [Cursor forum — Agent coding practices](https://forum.cursor.com/t/whats-the-best-practice-coding-with-cursor-agent/164491/7) | Community | `/agent-review`; `BUGBOT.md` custom criteria; subagents keep main context clean |
| 19 | [r/ClaudeAI — Review Council](https://www.reddit.com/r/ClaudeAI/comments/1tk5utf/multiagent_code_review_review_council_to_get/) | Reddit | Cross-model adversarial review + orchestrator that **pushes back** on false positives |
| 20 | [r/ClaudeAI — Writer ≠ reviewer](https://www.reddit.com/r/ClaudeAI/comments/1qdgi36/i_built_a_multiagent_system_that_enforces_code/) | Reddit | Enforce independent review + tests; “role drift” risk when one model wears many hats |
| 21 | [ScreenAI (arXiv:2402.04615)](https://arxiv.org/abs/2402.04615) · [Google Research blog](https://research.google/blog/screenai-a-visual-language-model-for-ui-and-visually-situated-language-understanding/) | arXiv | UI-specialized VLM; layout/QA stronger than generic VLMs — still not a WoW client driver |
| 22 | [UW — Using Vision LLMs For UI Testing (PDF)](https://courses.cs.washington.edu/courses/cse503/25wi/final-reports/Using%20Vision%20LLMs%20For%20UI%20Testing.pdf) | Academia | Screenshot → VLM → action loop on **web** (Playwright); CoB analog is **human capture → agent Read**, not process control |
| 23 | [ASDLC — Adversarial Code Review](https://asdlc.io/patterns/adversarial-code-review) | Pattern | Spec-gated critic; Context Gates (deterministic) vs Review Gate (LLM) |
| 24 | [ClawHub — Adversarial Code Review](https://clawhub.ai/reikys/adversarial-code-review) | Pattern | Builder → Critic → Meta-filter; ~2 high-signal findings; when **not** to swarm |
| 25 | [YouTube — LangGraph Reflection Agents (LangChain)](https://www.youtube.com/watch?v=v5ymBTXNqtk) | YouTube | Timestamps for Reflexion + LATS; reinforces iteration caps |
| 26 | [YouTube — LangGraph Crash Course #6 Reflection](https://www.youtube.com/watch?v=7seQ788aN_E) | YouTube | Cyclical draft → evaluate → approve/refine |
| 27 | [GameUIAgent — VLM reflection / quality ceiling](https://arxiv.org/html/2603.14724) | arXiv HTML | Iterative VLM polish hits a **ceiling**; more rounds can regress |
| 28 | [Portal UX Agent](https://arxiv.org/html/2511.00843v1) | arXiv HTML | Mixed automatic checks + LLM-as-judge for UX |
| 29 | [LangSmith — LLM-as-a-judge](https://docs.langchain.com/langsmith/llm-as-judge?mode=ui) | Docs | Rubrics + structured scores in production evals |
| 30 | [Anthropic — Claude Code best practices](https://www.anthropic.com/engineering/claude-code-best-practices) | Blog | Explore → plan → code; give the model a way to **verify** its work |

---

## CoB mapping table (source idea → repo practice)

| Idea from sources | Church of Beef practice |
|-------------------|-------------------------|
| Constitution / principles | Spec §10/§15 + glossary 74–81 + [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) |
| Environment reward (Reflexion / LATS) | `lua tests/run.lua`, TOC existence, layer greps — **not** the live client |
| Evaluator-optimizer | Builder → Hard Verifier → Rubric Critic → Fixer; `max_iter` **2–3** |
| Separate judge / Bugbot | Fresh Cursor Task / Agent Review / Bugbot; prefer different model than Builder |
| `BUGBOT.md` rules | Encode ToS, layers, Interface `20506`, no Secure* panels, UI≠scoring |
| AutoGen `max_round` / CrewAI `max_iter` | Hard caps in track [`31`](31-loop-stop-conditions.md); best-so-far rollback |
| MT-Bench biases | Binary H*/U* rows over vibe scores; pairwise swap if A/B ([`35`](35-subjective-quality-harnesses.md)) |
| VLM UI QA | Human PNG capture → agent `Read` ([`26`](26-visual-qa-screenshot-protocol.md)); never automate WoW |
| Human oversight (Anthropic coding agents) | Install → `/console scriptErrors 1` → `/reload` → `/beef`; two-client for BeefNet |
| Meta-filter / Review Council | ≤5 findings; drop nits; orchestrator pushes back on FP |

---

## Recommended CoB loop (cited)

```text
1. DECLARE surface + tier (24) — constitution locked (22 / CAI)
2. BUILD — single writer (27 T2 Leap Fan-In)
3. HARD VERIFY — lua tests/run.lua · TOC · layers · Interface 20506
      [Reflexion/LATS env signal; Anthropic “verify your work”]
4. RUBRIC CRITIQUE — separate session/model; structured PASS/FAIL (22, 25)
      [Evaluator-optimizer; MT-Bench bias controls; Bugbot/Agent Review]
5. REFLECT ≤5 lessons → REVISE (max 2 revises / 3 Actor attempts)
      [Reflexion mem bound; Self-Refine early gains]
6. STOP on: hard fail | all H*+U* PASS | nit-only | plateau | max_iter
      [31; LangGraph route; CrewAI/AutoGen caps]
7. VISUAL QA (if UI) — human PNG → agent Read (26, 35) — VLM advisory only
      [ScreenAI / GameUIAgent ceiling; no client bots]
8. HUMAN SMOKE — BugSack path; Officer+Member if Net; spectacle not unit-testable
      [verification.mdc; Anthropic human review for system fit]
```

**Do not claim V1 complete** until [`docs/phases/v1-checklist.md`](../../phases/v1-checklist.md) is walked.

---

## Source dumps (machine)

| File | Contents |
|------|----------|
| `_deep-agentic-critique.json` | Deep research run (primary synthesis) |
| `_deep-agentic-critique.extract.md` | Readable extract of fields 1–8 |
| `_search-langgraph-eval-opt.json` | LangGraph evaluator-optimizer / reflection |
| `_search-crewai-autogen-critique.json` | CrewAI / AutoGen caps |
| `_search-cursor-bugbot-patterns.json` | Cursor Agent Review / Bugbot |
| `_search-bugbot-docs.json` | Bugbot vs Agent Review + `BUGBOT.md` |
| `_search-vlm-visual-qa.json` | ScreenAI / VLM UI testing |
| `_search-reflexion-cai-selfrefine.json` | Reflexion / CAI / Self-Refine |
| `_search-anthropic-eval-opt.json` | Building Effective Agents |
| `_search-reddit-agent-critique.json` | Review Council / writer≠reviewer |
| `_search-youtube-multiagent.json` | LangChain Reflection Agents video |

---

## Explicit non-goals

- Treating this bibliography as product law  
- Automating in-game capture via process control / bots  
- Pixelmatch CI for Anniversary frames  
- Unbounded CrewAI-default `max_iter` (20) on polish passes  
- Claiming spectacle polish from green harness alone  
