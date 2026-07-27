# 22 — LLM critique loops for Church of Beef UI polish

**Audience:** Coding agents (and humans directing them) running iterative UI / “game juice” polish in Cursor for Church of Beef.  
**Authority:** Product law in [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../superpowers/specs/2026-07-25-church-of-beef-design.md) (§10 UI, §15); implementer locks in glossary rows 74–81; agent briefing [`docs/superpowers/ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md).  
**Status:** Research → recommended Cursor loop. Not product law — do not invent new visual policy here.  
**Client:** TBC Classic Anniversary (`## Interface: 20506`).

---

## One-line verdict

Use a **constitution-gated generate → evaluate → reflect → revise** loop with a **separate critic**, **hard deterministic gates**, and a **2–3 round cap**. Map CoB’s locked UI doctrine to the “constitution”; never let the LLM invent new visual religion.

---

## 1. Industry patterns (what to steal)

| Pattern | Core idea | Primary sources |
|---------|-----------|-----------------|
| **Reflexion** | Actor acts → Evaluator scores → Self-Reflection writes *verbal* lessons into episodic memory → next trial conditions on that memory. Improves without weight updates. | [Shinn et al., Reflexion (arXiv:2303.11366)](https://arxiv.org/abs/2303.11366); [NeurIPS 2023](https://neurips.cc/virtual/2023/poster/70114); [code](https://github.com/noahshinn/reflexion) |
| **Constitutional AI (CAI)** | Humans write explicit principles; model **critiques then revises** against them (SL-CAI), optionally then RLAIF. Iteration until principles satisfied or a fixed round budget. | [Bai et al., Constitutional AI (arXiv:2212.08073)](https://arxiv.org/abs/2212.08073); overview [CAI self-critique](https://ai.towerofrecords.com/ai/constitutional-ai) |
| **Self-Refine** | Same model as generator / feedback / refiner; stop on max iterations **or** feedback “no further change needed.” Actionable, specific feedback beats vague “make it better.” Gains concentrate in early rounds (~3–4). | [Madaan et al., Self-Refine (arXiv:2303.17651)](https://arxiv.org/abs/2303.17651) |
| **Actor–critic (LLM / code)** | Actor proposes; critic scores / localizes error; revise with external signal (tests, compiler). Classic RL AC + LLM variants (e.g. CodeRL lineage cited in Reflexion). | Reflexion related-work (CodeRL); [LoopGain GVR](https://github.com/loopgain-ai/loopgain) (generate–verify–revise) |
| **Evaluator / LLM-as-judge** | Strong judges can ~match human preference (~80% agreement on MT-Bench) but suffer **position, verbosity, self-enhancement** biases. Prefer rubrics + separate judge model. | [Zheng et al., MT-Bench (NeurIPS 2023)](https://papers.nips.cc/paper_files/paper/2023/hash/91f18a1287b398d378ef22505bf41832-Abstract-Datasets_and_Benchmarks.html); bias notes [rubric LLM-as-judge](https://arxiv.org/html/2602.02219v2) |
| **Loop & critique (production)** | Generator drafts; critic checks **hard constraints**; escalate/`exit` on pass; always `max_iterations` as kill-switch. Directed feedback ≠ blind retry. | [Loop & Critique pattern](https://tuts.localm.dev/agent-design-patterns/loop-and-critique); [CrewAI `max_iter` / `max_retry_limit`](https://docs.crewai.com/v1.15.1/en/learn/customizing-agents) |
| **Stop science** | Fixed caps waste tokens or truncate hard cases; semantic / quality-plateau stop helps; “best round so far” rollback often beats last round. | [Semantic Early-Stopping (alphaXiv)](https://www.alphaxiv.org/abs/2606.27009); [LoopGain](https://github.com/loopgain-ai/loopgain) |
| **Adversarial review** | Builder ≠ critic (different session / model); optional meta-critic filters nitpicks → few high-confidence findings. | Community patterns in sibling search notes (`_search-adversarial-review-protocols.json`) |

**Survey takeaway:** ReAct → Reflexion → heavier search (e.g. LATS) trades tokens for reliability; orchestration must expose **retry / reflection / hard caps** ([multi-agent orchestration survey](https://www.preprints.org/manuscript/202604.2147)).

---

## 2. Mapping patterns → CoB polish

| Industry role | CoB / Cursor role |
|---------------|-------------------|
| **Constitution** | Spec §10 / §15 + glossary 74–81 + UI agent briefing anti-patterns + Classic template doctrine |
| **Actor / Writer** | Implementer agent editing `addon/ChurchOfBeef/UI/**`, bootstrap, TOC |
| **Evaluator (hard)** | `lua tests/run.lua`, TOC file existence, layer rules (UI↛award points; Core↛CreateFrame), Interface `20506` |
| **Evaluator (soft)** | Rubric LLM-as-judge against constitution (checklist PASS/FAIL + evidence) |
| **Critic** | Separate Cursor Task / Bugbot / second model — **not** the same turn that just wrote the frames |
| **Self-reflection memory** | Short bullet “lessons” carried into next polish round (max 3); not a new canon doc |
| **Environment feedback** | `/console scriptErrors 1`, BugGrabber+BugSack, `/reload`, `/beef`, two-client BeefNet when net/UI sync touched |
| **Human preference** | Guild-chat spectacle, toast readability, officer UX — unit tests cannot prove these |

**Non-negotiable split:** Soft LLM critique may only argue *within* locked doctrine. If critique wants new policy (e.g. center-screen WA pulse, standing HP bar), **stop and escalate to spec §15** — do not “polish into” a fork.

---

## 3. Recommended loop architecture (CoB @ Cursor)

```text
                    ┌─────────────────────────────────────┐
                    │  CONSTITUTION (read-only law)         │
                    │  spec §10/§15 · glossary 74–81        │
                    │  ui-polished-direction-for-agents.md  │
                    └─────────────────┬───────────────────┘
                                      │
   ┌──────────────┐   edit    ┌───────▼────────┐
   │ REFLECTION   │◄──────────│  ACTOR         │  Cursor Agent / Task
   │ mem (≤3)     │  lessons  │  implement UI  │
   └──────▲───────┘           └───────┬────────┘
          │                           │ candidate diff
          │                 ┌─────────▼─────────┐
          │                 │ HARD EVALUATOR      │  deterministic
          │                 │ tests · TOC · layers│
          │                 │ taint/API bans      │
          │                 └─────────┬─────────┘
          │                    fail │ │ pass
          │                 ┌───────▼─────────┐
          │                 │ RUBRIC CRITIC     │  separate session/model
          │                 │ constitution +    │
          │                 │ polish rubric     │
          │                 └─────────┬─────────┘
          │              FAIL issues  │  all PASS / budget
          │                 │         │
          └──── reflect ────┘         ▼
                                ┌─────────────┐
                                │ SOFT STOP   │
                                │ or IN-GAME  │  human / two-client
                                │ SPECTACLE   │
                                └─────────────┘
```

### 3.1 Roles in practice

1. **Actor (Builder)** — Implements against build-prep + briefing. Owns the diff. Does **not** self-score as “done.”
2. **Hard Evaluator** — Runs before any LLM judge. Failures are blocking; no critique theater.
3. **Rubric Critic** — Fresh context (new Task / Bugbot / second model). Scores only the rubric + cites file evidence. Prefer **heterogeneous judge** vs builder to reduce self-enhancement bias ([MT-Bench biases](https://tailoredai.substack.com/p/judging-llm-as-a-judge-with-mt-bench)).
4. **Reflector** — Converts FAIL rows into ≤5 actionable lessons (“toast parented under raid frame → move to Beef root”). Append to mem; drop oldest beyond 3 ([Reflexion memory bound](https://arxiv.org/abs/2303.11366)).
5. **Human gate** — Required for announce copy, toast timing, officer confirm feel, streamer coexistence notes.

### 3.2 Cursor wiring (minimal ceremony)

| Step | Cursor practice |
|------|-----------------|
| Scope one surface | One polish card per loop (e.g. “edge toast only”), not whole `/beef` |
| Actor turn | Agent mode; read UI briefing first; edit worktree Lua from parent workspace |
| Hard eval | `./scripts/run-tests.sh` or `cd .worktrees/feat-church-of-beef-v1 && lua tests/run.lua` |
| Critic turn | New Task / Bugbot with **read-only** rubric + diff; no “also fix” in same breath |
| Reflect + revise | Actor resumes with critic FAIL list + mem bullets |
| Cap | **max 2 revise rounds** after first critic (3 Actor attempts total); then human decide |
| Rollback | Keep best-so-far (last hard-green + fewest rubric FAILs); do not ship last noisy round |

Optional: adversarial Builder↔Critic debate only when rubric FAILs disagree or stakes are high (announce / Commit UX). Default CoB polish does **not** need a third meta-critic every round.

---

## 4. Rubrics (CoB polish)

Score each row: **PASS / FAIL / N/A**. Critic must cite path or runtime evidence. Soft preference (“looks nicer”) without a locked principle → **N/A**, not FAIL.

### 4.1 Hard constitution (any FAIL = stop / fix; no aesthetic debate)

| ID | Check |
|----|--------|
| H1 | Offline harness green when Core/Data/harness touched |
| H2 | `ChurchOfBeef.toc` lists only existing files; Interface `20506` unless intentional bump |
| H3 | UI → Core → Data; UI never awards points; Core never `CreateFrame` |
| H4 | No Retail-only APIs; no bots / injection / protected-action bypass / SecureActionButton-for-panels |
| H5 | No custom `Media/` required for V1; missing media must not fail load |
| H6 | Guest on player `uiScale` — never set `uiScale` / `UIParent:SetScale` |

### 4.2 V1 UI doctrine (from briefing / glossary — critic’s soft gate)

| ID | Check |
|----|--------|
| U1 | Classic FrameXML templates (`BasicFrameTemplate`, `UIPanelButtonTemplate`, `BackdropTemplate`, …) |
| U2 | Tabs: Ladder / My Standing / Officer+ only |
| U3 | Opaque high-contrast panels; GameFont*; class color on **names** only |
| U4 | Dual-encode pending / approve / reject (not color-only) |
| U5 | Spectacle = throttled `/g` (officer checkbox, default ON) + private edge toast; **no** center-screen WA pulses |
| U6 | Settings: position + minimap hide + announce only |
| U7 | Standing: **text thresholds** only (no hero StatusBar) |
| U8 | Silent (no SFX) in V1 |
| U9 | No AceAddon / Masque / SharedMedia hard deps; no tip jars; no Streamer Mode code in V1 |

### 4.3 Polish quality (juice — only after H* and U* clear)

| ID | Check |
|----|--------|
| P1 | Hierarchy readable at stream distance (title > standing > next > chips) |
| P2 | Empty / pending / error states have copy (no blank Officer void) |
| P3 | Motion ≤ brief allowance (no spam OnUpdate; toast in/out only) |
| P4 | Taint/lockdown: insecure Beef roots; deferred combat work; see track [`03-taint-lockdown-ux.md`](03-taint-lockdown-ux.md) |
| P5 | Microcopy matches locked tone / IDs (no invented thresholds) |
| P6 | Anti-patterns rejected: Details!-dense roster, item-quality rainbow ranks, ElvUI-flat-as-brand, glass panels |

Critic output format (keep machine-scannable):

```text
ROUND: n
HARD: PASS|FAIL (list H#)
UI:   PASS|FAIL (list U#)
POLISH: score 0–P6 PASS count
ISSUES:
- [Hx|Ux|Px] evidence → actionable fix
REFLECTION_BULLETS: (≤5 for Actor mem)
VERDICT: REVISE | SHIP_TO_INGAME | ESCALATE_SPEC
```

---

## 5. Stop conditions (ordered)

Apply in this priority — first match wins:

| Priority | Condition | Action |
|----------|-----------|--------|
| 0 | Safety / ToS / architecture ban triggered | **Halt**; revert; do not iterate “around” it |
| 1 | Hard Evaluator FAIL | Fix or abort; no rubric theater |
| 2 | Rubric Critic: all H* + U* PASS and P* acceptable (or N/A) | Exit LLM loop → **in-game** checklist |
| 3 | Critic returns only nitpicks / preference with no constitution link | **Stop revising**; ship to human eyes |
| 4 | Same FAIL IDs two rounds in a row with no measurable fix | Escalate (stuck) or ESCALATE_SPEC |
| 5 | `round >= 3` Actor attempts (initial + 2 revises) | **Hard cap** — present best-so-far + residual FAIL list |
| 6 | In-game / two-client spectacle not exercised when UI/Net/SV/slash touched | Not done (verification.mdc) — LLM cannot clear this |

**Do not** use pure “critic score ≥ 85” as the only stop: LLM judges drift ([verbosity / self-preference](https://tailoredai.substack.com/p/judging-llm-as-a-judge-with-mt-bench)). Prefer **binary constitution rows** + small round budget ([Self-Refine stop](https://arxiv.org/abs/2303.17651); [CrewAI caps](https://docs.crewai.com/v1.15.1/en/learn/customizing-agents)).

Semantic convergence / embedding early-stop is optional research ([Semantic Early-Stopping](https://www.alphaxiv.org/abs/2606.27009)); for CoB, **issue-count plateau + hard cap** is enough.

---

## 6. Anti-patterns in the loop itself

| Anti-pattern | Why it hurts CoB |
|--------------|------------------|
| Same agent writes then blesses as “polished” | Self-enhancement bias |
| Infinite “make it more epic” revises | Violates Classic-shell doctrine; burns context |
| Critic invents new brand (gothic Media, SFX on) | Forks V1 law |
| Treating research scrapes as product truth | Spec / glossary win |
| Skipping harness because “UI only” | Bootstrap/TOC/layer breaks still land |
| Claiming V1 complete from green unit tests | Guild spectacle is a product pass |
| Critic dumps 30 nits | Prefer ≤5 high-severity; filter noise (adversarial meta optional) |

---

## 7. Worked mini-loop (edge toast)

1. **Actor:** Implement private edge toast per briefing; Classic fonts; no center pulse.  
2. **Hard:** `lua tests/run.lua` → 0; TOC ok.  
3. **Critic:** U5 FAIL — toast used full-screen fade; P4 FAIL — parented under `UIParent` ok but OnUpdate spam.  
4. **Reflect:** “Edge anchor only; one-shot animation; no WA center.”  
5. **Actor revise #1:** Fix.  
6. **Critic:** all PASS.  
7. **Stop LLM** → in-game: promote path, toast readable, no script errors. Human owns spectacle OK.

---

## 8. Relationship to other tracks

| Doc | Role |
|-----|------|
| [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) | Constitution for UI agents |
| [`22b-agentic-critique-sources.md`](22b-agentic-critique-sources.md) | ≥20-source bibliography + recommended loop |
| [`24-definition-of-done-polish.md`](24-definition-of-done-polish.md) | Soft/hard DoD + human PASS |
| [`31-loop-stop-conditions.md`](31-loop-stop-conditions.md) | Caps, plateau, best-so-far |
| [`03-taint-lockdown-ux.md`](03-taint-lockdown-ux.md) | Hard evaluator criteria for juice |
| `visual-polish-acceptance-checklist` canvas | In-client human gate |
| `.cursor/skills/church-of-beef-dev/SKILL.md` | Install / reload / BugGrabber loop |
| `docs/phases/v1-checklist.md` | Do not claim V1 done until walked |

---

## 9. Expansion — evaluator-optimizer, BIR, and Cursor wiring (2026-07-26)

**Bibliography:** [`22b-agentic-critique-sources.md`](22b-agentic-critique-sources.md) (≥20 sources). Deep extract: `_deep-agentic-critique.extract.md`.

### 9.1 Name the pattern: Bounded Iterative Refinement

[Anthropic — Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) separates **workflows** (predefined paths) from **agents** (dynamic tool loops) and documents an **evaluator-optimizer** workflow: one call generates, another evaluates/feedbacks, route until criteria met or budget exhausted. Fit signals: (1) human feedback would demonstrably improve the artifact; (2) an LLM can supply that feedback.

For CoB polish, use a **workflow with one bounded agentic step** — not overnight autonomous polish. Call it **BIR (Bounded Iterative Refinement)**: hard Verifier first, LLM Critic second, human smoke third, `max_iter ≤ 3` Actor attempts ([Reflexion trial caps](https://arxiv.org/abs/2303.11366); [Self-Refine plateau warning](https://arxiv.org/abs/2303.17651)).

### 9.2 LangGraph / CrewAI / AutoGen stop mechanics

| Framework | Stop knobs | CoB default |
|-----------|------------|-------------|
| [LangGraph evaluator-optimizer](https://langchain-ai.github.io/langgraph/tutorials/workflows/) | Evaluator `pass` **or** iteration ≥ max | Prefer binary constitution PASS + `max_iter=3` |
| [CrewAI Agents](https://docs.crewai.com/en/concepts/agents) | `max_iter` (framework default high), `max_retry_limit` | Override polish agents to **2–3**, not 20 |
| [AutoGen](https://arxiv.org/abs/2308.08155) | `is_termination_msg` **or** `max_round` | Treat as structural kill-switch; still require Verifier |

Never use scalar “score ≥ 85” alone — pair with `decision: pass|revise|reject` ([MT-Bench judge biases](https://arxiv.org/abs/2306.05685)).

### 9.3 Cursor-native dual gate

| Gate | When | Source |
|------|------|--------|
| **Agent Review** (Quick/Deep) | Local, before push | [Agent Review docs](https://cursor.com/docs/agent/agent-review); [forum](https://forum.cursor.com/t/difference-between-bugbot-and-agent-review/163425) |
| **Bugbot** | PR stage | [Bugbot docs](https://cursor.com/docs/bugbot); project `.cursor/BUGBOT.md` for CoB bans |

Complementary, not duplicates. Encode CoB constitution in `BUGBOT.md` / critic prompts (Interface `20506`, layers, no Secure* panels, UI≠scoring).

### 9.4 Structured critic schema (pasteable)

```json
{
  "decision": "pass|revise|reject",
  "hard": ["H1.."],
  "ui": ["U1.."],
  "polish": ["P1.."],
  "violations": [
    {"rule": "U5", "severity": "blocker|major|minor|nit",
     "evidence": "path or shot ID", "fix": "actionable"}
  ],
  "reflection_bullets": ["≤5 for Actor mem"],
  "verdict": "REVISE|SHIP_TO_INGAME|ESCALATE_SPEC"
}
```

Critic must **not** edit code. Fixer is a separate write pass ([ASDLC / ClawHub adversarial patterns](https://asdlc.io/patterns/adversarial-code-review)).

---

## Sources

- Full annotated catalog: [`22b-agentic-critique-sources.md`](22b-agentic-critique-sources.md)
- [Anthropic — Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) (Dec 2024)
- [LangGraph workflows — Evaluator-optimizer](https://langchain-ai.github.io/langgraph/tutorials/workflows/)
- [CrewAI Agents (`max_iter`)](https://docs.crewai.com/en/concepts/agents)
- [Cursor Bugbot](https://cursor.com/docs/bugbot) · [Agent Review](https://cursor.com/docs/agent/agent-review)
- [Reflexion: Language Agents with Verbal Reinforcement Learning (arXiv:2303.11366)](https://arxiv.org/abs/2303.11366) (Mar 2023)
- [Reflexion NeurIPS 2023 poster](https://neurips.cc/virtual/2023/poster/70114)
- [noahshinn/reflexion (GitHub)](https://github.com/noahshinn/reflexion)
- [Constitutional AI: Harmlessness from AI Feedback (arXiv:2212.08073)](https://arxiv.org/abs/2212.08073) (Dec 2022)
- [Constitutional AI: Self-Critique, Revision… (AI Tower)](https://ai.towerofrecords.com/ai/constitutional-ai) (Feb 2026)
- [Self-Refine: Iterative Refinement with Self-Feedback (arXiv:2303.17651)](https://arxiv.org/abs/2303.17651) (Mar 2023)
- [Judging LLM-as-a-Judge with MT-Bench… (NeurIPS 2023)](https://papers.nips.cc/paper_files/paper/2023/hash/91f18a1287b398d378ef22505bf41832-Abstract-Datasets_and_Benchmarks.html)
- [Judging LLM-as-a-Judge summary (Substack)](https://tailoredai.substack.com/p/judging-llm-as-a-judge-with-mt-bench) (Aug 2025)
- [Position bias in rubric LLM-as-a-Judge (arXiv HTML)](https://arxiv.org/html/2602.02219v2) (2026)
- [LLM-Based Multi-Agent Orchestration survey (Preprints)](https://www.preprints.org/manuscript/202604.2147) (Apr 2026)
- [Customize Agents — CrewAI (`max_iter`, `max_retry_limit`)](https://docs.crewai.com/v1.15.1/en/learn/customizing-agents) (2026)
- [Loop & Critique pattern](https://tuts.localm.dev/agent-design-patterns/loop-and-critique)
- [Semantic Early-Stopping for Iterative LLM Agent Loops](https://www.alphaxiv.org/abs/2606.27009) (Jun 2026)
- [loopgain-ai/loopgain](https://github.com/loopgain-ai/loopgain)
- [Reflective Loop Pattern (Medium)](https://medium.com/@vpatil_80538/reflective-loop-pattern-the-llm-powered-self-improving-ai-architecture-7b41b7eacf69) (Apr 2025)

Raw search dumps (follow-up): `_search-llm-critique-loops.json`, `_search-llm-critique-loops-2.json`, `_search-llm-critique-stop.json` in this folder.
