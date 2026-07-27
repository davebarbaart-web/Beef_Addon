# 27 — Multi-agent adversarial review for Church of Beef leaps

**Audience:** Parent/orchestrator agents and humans who want one prompt to drive a large but safe development leap (feature slice, polish pass, Net harden, UI juice).  
**Authority:** Product law in `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`; always-on rules in `.cursor/rules/` (`architecture-overview`, `verification`); operational loop in `.cursor/skills/church-of-beef-dev/SKILL.md`.  
**This doc is guidance, not product truth.** It does not replace a green `lua tests/run.lua`, TOC truth, or in-game smoke.  
**Search dumps:** `_search-multi-agent-adversarial-review.json`, `_search-adversarial-review-protocols.json`, `_search-llm-critique-loops.json`, `_search-cursor-agent-loops.json`.

---

## 1. Why adversarial review (not more builder tokens)

LLMs grade their own homework poorly: same session, same priors, same helpfulness bias. Industry patterns converge on **role separation + fresh context + filter noise**:

| Pattern | Core idea | Sources |
|---------|-----------|---------|
| **Builder → Critic → Meta-reviewer** | Author, hostile critic, then a third agent that culls false positives / nitpicks (~2 high-signal comments) | [Adversarial Code Review (ClawHub)](https://clawhub.ai/reikys/adversarial-code-review), [OpenClaw skill summary](https://llmbase.ai/openclaw/adversarial-code-review/) |
| **Spec-gated Critic** | Critic rejects against **contracts**, not taste; PASS or remediable violations | [ASDLC Adversarial Code Review](https://asdlc.io/patterns/adversarial-code-review) |
| **Parallel specialist swarm** | Security / performance / architecture / style lanes, then synthesis | [agent-code-review-swarm](https://lobehub.com/skills/ruvnet-claude-flow-agent-code-review-swarm) |
| **Cross-model debate** | Two models review independently, then critique each other’s findings | [alecnielsen/adversarial-review](https://github.com/alecnielsen/adversarial-review) (debate loop; [D3](https://arxiv.org/abs/2410.04663)) |
| **Partner reviews, never host** | Route heavy critique to a *different* agent host/model than the builder | [frankbria/adversarial-review](https://github.com/frankbria/adversarial-review) |
| **Reflexion / self-critique** | Actor → Evaluator → verbal reflection memory (strong for test-fail loops; weak as sole security gate) | [Reflexion](https://arxiv.org/abs/2303.11366) |
| **Cursor harness practices** | Plan first; Agent Review / Bugbot; parallel agents + judging; review ≠ build | [Cursor agent best practices](https://cursor.com/blog/agent-best-practices) (Jan 2026) |

**Negation blindness:** Critics underweight “DO NOT …” clauses unless those bans are also enforced by **deterministic gates** (harness, TOC check, layer grep). ASDLC calls this out explicitly — for Beef, always-on rules + `lua tests/run.lua` are the Context Gates; LLM critics are the Review Gate.

---

## 2. Church of Beef constraints that shape the swarm

Beef is not a generic web app. The swarm must encode **domain failure modes**, not OWASP-only checklists.

| Constraint | Why it matters in review | Rule / skill |
|------------|--------------------------|--------------|
| Announce / track / sync only — no bots, injection, protected-action bypass | Security critic’s primary job is *ToS + Classic secure model*, not CVE theater | `verification.mdc`, `wow-ui-taint-lockdown.mdc` |
| Layers: UI→Core→Data, Net→Core→Data; never Core→UI | Architecture critic greps coupling smells | `addon-module-layers.mdc` |
| UI never awards points; Net never invents ranks | Domain critic on Commit / apply paths | `ladder-authority.mdc`, `scoring-coplay.mdc` |
| BeefNet: `COB` / `GUILD`, Officer+ gate, ≤255 body, throttle | Net + security lanes | `beefnet-messaging.mdc` |
| Perf: idle when UI closed; no permanent OnUpdate; SV ≪ 1 MB | Performance critic | `wow-performance.mdc` |
| Offline harness for Core/Data; client smoke for UI/Net/SV | Deterministic gate before LLM debate | `church-of-beef-dev` skill, `testing.mdc` |
| Workspace: edit worktree from parent `Beef_Addon` | Orchestrator must set `ADDON_ROOT` correctly | `AGENTS.md` |
| Research ≠ policy | Swarm may cite this track; must not silently fork rank numbers / product decisions | Spec decisions log |

**Done means (swarm exit):** green harness when Core/Data/harness touched; TOC lists only existing files; Interface stays `20506` unless intentional; no safety violations; in-game path exercised when UI/Net/SV/slash touched. Guild spectacle is a **human product pass** — unit tests and critics cannot prove stream-readable ceremony.

---

## 3. Role catalog (Builder / Critic / Security / Performance + Beef extras)

Map industry roles onto Cursor capabilities already available in this workspace.

| Role | Mission | Writes code? | Cursor mapping | Beef “constitution” (prime with) |
|------|---------|--------------|----------------|----------------------------------|
| **Orchestrator (Leap Captain)** | Scope leap, pick topology tier, spawn agents, merge findings, decide stop | Rarely (prompts + checklists) | Parent agent | One leap = one plan slice; never claim V1 complete |
| **Planner** | File list, acceptance checks, risk tags (Net/UI/Core) | No (plan only) | Plan Mode / plan subagent | Spec § + plan task IDs; ask before inventing policy |
| **Builder** | Implement the leap | Yes | `generalPurpose` / main Agent | Extend planned modules; TOC only for existing files |
| **Verifier (deterministic)** | Run gates; report pass/fail evidence | No | Shell / `church-of-beef-dev` | `lua tests/run.lua` exit 0; TOC truth |
| **Critic (architecture / domain)** | Spec + layer + authority violations | No (findings only) | `bugbot` and/or primed `explore`/`generalPurpose` read-only | “AI builder likely broke layers / officer gate / canon — find them” |
| **Security** | ToS, taint/lockdown, BeefNet trust, privacy dumps, no Retail APIs | No | `security-review` + Beef custom instructions | No automation; no unverified `RANK_COMMIT`; no WTF scrapes |
| **Performance** | OnUpdate, combat storms, SV growth, login sync storms, UI rebuild churn | No | Primed read-only agent (or thermo-nuclear quality lane if used) | Idle when closed; ≤10 Hz dirty UI; CTL pacing |
| **Meta-reviewer (Moderator)** | Deduplicate, drop nits, score confidence×priority, output ≤N findings | No | Fresh small agent / parent synthesis | Target ~2–5 fixable items; reject style-only noise |
| **Fixer** | Apply only Moderator-approved items | Yes | Fresh Builder (prefer different model than first Builder) | No drive-by refactors |
| **Human Acceptance** | Spectacle, two-client Net, stream feel | — | User | Required for Net/officer/spectacle leaps |

**Optional lanes** (spawn only when the leap touches that surface):

| Lane | Trigger | Focus |
|------|---------|--------|
| **Taint / UX juice** | Any `CreateFrame`, toast, slash, StaticPopup, announce | Doc `03-taint-lockdown-ux.md` + track 29/58/72 |
| **Canon / ranks** | `Data/Ranks.lua` or threshold claims | Numbers only in Ranks.lua; prose stays in `docs/canon/` |
| **Privacy** | Debug dump, BugSack share, chat scrape temptation | Track 65 — never scrape chat/combat for “support” |
| **Best-of-N Builder** | Hard algorithmic Core puzzle | Parallel worktrees + judge (Cursor parallel agents) — **not** default for UI polish |

---

## 4. Recommended swarm topology for this repo

### 4.1 Default: **Leap Fan-In** (recommended)

Use for most “development leaps per prompt” — one feature slice or polish pass in a single orchestrated turn (or short multi-turn).

```text
                         Orchestrator (parent — owns stop)
                                    |
                 Planner --> Builder --> Verifier (lua tests / TOC)
                                            |
                                         green?
                                            |
              +---------- parallel read-only critics -----------+
              |            |              |                     |
           Critic       Security     Performance          Optional Taint
           (domain)      (+ ToS)       (Classic)           (if UI juice)
              |            |              |                     |
              +------------+------+-------+---------------------+
                                  |
                            Meta-review  (filter --> <=5 findings)
                                  |
                               Fixer --> Verifier again
                                  |
                         Human smoke if UI / Net / SV
```

**Why this topology for Beef**

1. **Deterministic gate before LLM debate** — cheap reject of broken Core; critics should not argue over red tests.  
2. **Parallel specialists** match Cursor’s ability to launch multiple subagents; avoids serial “one mega-reviewer” context mush.  
3. **Meta-reviewer is non-negotiable** — specialist swarms otherwise drown the Fixer in style nits ([ClawHub adversarial pattern](https://clawhub.ai/reikys/adversarial-code-review)).  
4. **Fixer is a separate write pass** — critics stay read-only (ASDLC Moderator separation).  
5. Maps cleanly onto existing tools: `bugbot` + `security-review` + shell harness + optional primed performance agent.

### 4.2 Topology tiers (when to spend agents)

| Tier | Name | Agents | When |
|------|------|--------|------|
| **T0** | Solo Builder + Verifier | 1 writer + harness | Typo, comment, single-file pure Data tweak with tests |
| **T1** | Builder → Critic → Fix | +1 `bugbot` (or primed critic) | Small Core/UI change; no Net |
| **T2** | **Leap Fan-In (default)** | Builder + Verifier + Critic + Security + Perf + Meta + Fixer | Multi-file leap, any officer/Net/UI juice, “polish vision” passes |
| **T3** | Debate Fan-In | T2 + second critic model/host + short debate | BeefNet protocol, officer gate, sync storm risk, authz paths |
| **T4** | Plan Critique then Leap | Cross-model plan critique → then T2/T3 build | New subsystem or ambiguous product leap (versioned plan_v1 → critique → plan_v2) |

**Do not** run T3/T4 on every toast color tweak — noise kills trust and burns budget ([ClawHub: when NOT to use](https://clawhub.ai/reikys/adversarial-code-review)).

### 4.3 Cursor-native wiring (practical)

| Step | Action |
|------|--------|
| Plan | Plan Mode or planner subagent; cite plan task + files under `.worktrees/feat-church-of-beef-v1/` when addon absent on `main` |
| Build | One Builder; avoid parallel writers on same files |
| Verify | `./scripts/run-tests.sh` or `lua tests/run.lua` from `ADDON_ROOT` |
| Review fan-out | Launch **in parallel**: `bugbot` (branch/uncommitted), `security-review` with Beef custom instructions, performance agent primed with `wow-performance.mdc` |
| Meta | Parent or fresh agent: keep only high confidence × high priority; drop “prefer Ace3”, rename-nits, speculative Retail advice |
| Fix | Fresh Fixer; re-run Verifier |
| Human | Install → `/console scriptErrors 1` → `/reload` → `/beef`; Officer+Member for Net |

**Priming trick (critics):** Explicitly state the Builder was an AI agent and likely introduced subtle bugs / layer breaks / trust holes. Neutral “please review” prompts under-detect ([ClawHub](https://clawhub.ai/reikys/adversarial-code-review)).

**Cross-model:** Prefer a different model family for Security/Critic than for Builder when the host allows it. Same-model self-review is better than nothing if fresh-context + adversarial priming, but weaker than partner-host review.

---

## 5. Per-prompt leap contract (copy into orchestrator prompts)

```text
LEAP:
  Goal: <one sentence>
  Tier: T0 | T1 | T2 | T3 | T4
  Surfaces: Core | Data | Net | UI | Docs | Tests
  ADDON_ROOT: <resolved path>
  Spec anchors: <§ or plan task ids>
  Out of scope: <explicit>

PIPELINE:
  1. Plan (files + acceptance + risk tags)
  2. Build (single writer)
  3. Verifier: lua tests/run.lua; TOC exists-check; Interface 20506
  4. Parallel critics (read-only): Domain, Security, Performance [, Taint if UI]
  5. Meta-review → ≤5 findings (confidence + priority + category)
  6. Fixer → Verifier again
  7. Stop. Human smoke if UI/Net/SV/slash. Do not claim V1 complete.

FINDING SCHEMA:
  - category: bug | security | performance | layers | beefnet | taint | canon | test-gap
  - confidence: high | medium | low
  - priority: high | medium | low
  - location: path:line
  - impact: one sentence
  - fix: concrete remediation
  Report only confidence≥medium AND priority≥medium unless security/ToS.
```

### Security critic — Beef custom instructions (paste)

```text
Church of Beef (WoW TBC Classic Anniversary, Interface 20506).
Flag: bots/automation, protected-action bypass, Retail-only APIs, Core→UI,
UI awarding points, Net inventing ranks, RANK_COMMIT without Officer+ roster gate,
custom CHANNEL addon chat, unbounded SV / chat scrapes, WTF wipe suggestions,
missing throttle on BeefNet, Secure* templates used for social panels.
Do not demand cryptographic anti-cheat. Standings are advisory; officer Commit is trust.
```

### Performance critic — Beef custom instructions (paste)

```text
Social addon budgets: UI closed → events only; no permanent OnUpdate for business logic;
no full ladder rebuild per BeefNet message; dirty UI ≤10 Hz when open; login sync bursty then quiet;
prefer ≪1 MB SV; cache roster lookups. Flag combat-time UI storms and ChatThrottle violations.
```

---

## 6. Anti-patterns (Beef-specific)

| Anti-pattern | Why it fails here |
|--------------|-------------------|
| Builder self-review in same thread | Echo chamber; misses layer / officer-gate bugs |
| Five critics with no Moderator | Alert fatigue; Fixer chases nits |
| Critics that rewrite code | Contaminates evidence; lose audit trail |
| Skipping harness because “UI only” | Often false — Core refresh paths still move |
| Claiming Net/spectacle done after green Lua | Needs two clients + human eyes |
| Swarm that invents rank thresholds | Canon fork — edit `Data/Ranks.lua` only via intentional product change |
| Ralph/infinite loop without Verifier | Autonomous loops need hard exit (`tests/run.lua`, max iterations); not a substitute for Security lane on Net |
| Parallel Builders on one checkout | Merge chaos; use best-of-N worktrees only for hard Core puzzles |

---

## 7. Mapping leaps → topology (quick picker)

| Leap type | Tier | Required critics | Human gate |
|-----------|------|------------------|------------|
| `Data/Ranks` threshold change | T2 | Domain + Canon + tests | Product confirm |
| Ladder / Scoring / Officer Core | T2–T3 | Domain + Security + tests | Optional |
| BeefNet / Sync | T3 | Security + Perf + Domain | Two clients |
| UI toast / ceremony juice | T2 | Taint + Perf + Domain | `/beef` smoke + spectacle feel |
| Docs / research only | T0–T1 | — | — |
| Packager / CI | T1 | Security (no secrets) | Human approve upload |

---

## 8. Relation to existing repo practices

| Existing piece | Role in swarm |
|----------------|---------------|
| `.cursor/rules/*.mdc` | Critic constitutions (deterministic + promptable) |
| `bugbot` / `security-review` skills | Ready-made Critic / Security lanes |
| `church-of-beef-dev` skill | Verifier + install/smoke script |
| Plan “subagent-driven development” | Builder-per-task; this doc adds the **adversarial fan-in after the leap** |
| Thermo-nuclear review subagents (if plugin present) | Optional heavy Critic for branch audits — still feed Meta-reviewer |
| Research library `wow-classic-addon-design/` | Depth tracks for critics; not a substitute for green harness |

---

## 9. Recommendation (normative for this research track)

1. **Adopt Leap Fan-In (T2) as the default swarm** for Church of Beef development leaps per prompt.  
2. **Always** run Verifier before and after Fixer when Core/Data/harness change.  
3. **Always** include Security when Net, officer gate, slash, announce, or SV paths change.  
4. **Always** include Performance + Taint when UI juice / frames / combat-time UX change.  
5. **Meta-review to ≤5 findings**; Fixer may not expand scope.  
6. Use T3 debate only on trust/sync surfaces; T4 plan critique before large ambiguous leaps.  
7. Keep research scrapes (`.firecrawl/`, `**/.raw/`, `_search-*.json`) out of product commits; this markdown is the durable artifact.

---

## 10. Expansion — industry + community patterns (2026-07-26)

**Catalog:** [`22b-agentic-critique-sources.md`](22b-agentic-critique-sources.md).

### 10.1 Anthropic parallelization → CoB critic fan-out

[Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) describes **sectioning** (specialist prompts in parallel) and **voting** (same task, diverse prompts). CoB Leap Fan-In is sectioning: Domain / Security / Perf (/ Taint). Do **not** default to voting on every toast — use voting only when a finding’s blocker status is disputed (maps to T3).

Evaluator-optimizer fits the Fixer loop **after** Meta-review, not as a substitute for the Verifier.

### 10.2 Cursor: Agent Review + Bugbot + BUGBOT.md

| Stage | Tool | CoB use |
|-------|------|---------|
| Pre-push | [Agent Review](https://cursor.com/docs/agent/agent-review) Quick/Deep | Local Critic lane |
| PR | [Bugbot](https://cursor.com/docs/bugbot) | Team gate; inline findings |
| Constitution | `.cursor/BUGBOT.md` (+ nested) | Interface `20506`, layers, ToS, BeefNet trust |

Forum guidance: they **complement**, not duplicate ([Bugbot vs Agent Review](https://forum.cursor.com/t/difference-between-bugbot-and-agent-review/163425)).

### 10.3 Reddit “Review Council” lesson

[r/ClaudeAI Review Council](https://www.reddit.com/r/ClaudeAI/comments/1tk5utf/multiagent_code_review_review_council_to_get/) and [writer≠reviewer](https://www.reddit.com/r/ClaudeAI/comments/1qdgi36/i_built_a_multiagent_system_that_enforces_code/): cross-model review helps **only if** an orchestrator **rejects false positives** and the writer never self-approves. That is our Meta-reviewer. Role drift (“same agent is PM + Dev + QA”) is a known failure — keep roles in the Leap contract.

### 10.4 AutoGen / CrewAI caps

Treat [AutoGen `max_round`](https://arxiv.org/abs/2308.08155) and [CrewAI `max_iter`](https://docs.crewai.com/en/concepts/agents) as **budget walls**. CoB polish: 2 full adversarial rounds then Meta-synthesis only ([31](31-loop-stop-conditions.md)). Debate ([Du et al.](https://arxiv.org/abs/2305.14325), [D3](https://arxiv.org/abs/2410.04663)) is optional on BeefNet — not default for UI juice ([49](49-adversarial-overengineering.md)).

---

## Sources

- Full catalog: [`22b-agentic-critique-sources.md`](22b-agentic-critique-sources.md)
- [Best practices for coding with agents · Cursor](https://cursor.com/blog/agent-best-practices) (Jan 2026)
- [Adversarial Code Review — ClawHub](https://clawhub.ai/reikys/adversarial-code-review)
- [Adversarial Code Review — ASDLC pattern](https://asdlc.io/patterns/adversarial-code-review) (updated 2026-06-30)
- [agent-code-review-swarm](https://lobehub.com/skills/ruvnet-claude-flow-agent-code-review-swarm)
- [alecnielsen/adversarial-review](https://github.com/alecnielsen/adversarial-review) (cross-model debate)
- [frankbria/adversarial-review](https://github.com/frankbria/adversarial-review) (partner-host review)
- [Adversarial Review · OpenReview](https://openreview.net/forum?id=fOHvpLs6zp) (structured disagreement protocol)
- [D3: Debate, Deliberate, Decide](https://arxiv.org/abs/2410.04663)
- [Reflexion: Language Agents with Verbal Reinforcement Learning](https://arxiv.org/abs/2303.11366)
- [Security code review with LLMs](https://arxiv.org/abs/2401.16310)
- Workspace: `AGENTS.md`, `.cursor/rules/`, `.cursor/skills/church-of-beef-dev/SKILL.md`
