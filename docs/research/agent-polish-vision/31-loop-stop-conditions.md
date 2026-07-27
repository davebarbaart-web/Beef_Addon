# 31 — Loop stop conditions for continuous AI polish

**Audience:** Coding agents (and orchestrators) running Builder → Critic → Refine polish loops on Church of Beef.  
**Last updated:** 2026-07-26  
**Status:** Research synthesis for polish orchestration — **not** product law. Product locks stay in the [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md), [UI agent brief](../../superpowers/ui-polished-direction-for-agents.md), and [glossary 74](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md).  
**Related local research:** [`03-taint-lockdown-ux.md`](03-taint-lockdown-ux.md), [21](./21-cursor-agent-loops-goals.md), [21b](./21b-cursor-loops-source-digest.md), [22](./22-llm-critique-loops.md), [29](./29-superpowers-loop-patterns.md), [49](./49-adversarial-overengineering.md); scrapes `_search-llm-critique-stop.json`, `_search-multi-agent-adversarial-review.json`, `_search-adversarial-review-protocols.json`.  
**Research ≠ product law** — stop math here does not override checklist / §15.

---

## 1. Why stop conditions matter here

Continuous polish loops (Writer/Builder + Critic + optional Meta-Critic) improve UI juice, copy, and ladder chrome — until they don’t. Without explicit exits they:

- Burn tokens after semantic convergence (same toast, rephrased)
- Oscillate between taste axes (more gothic vs more Classic shell)
- Re-open locked V1 decisions (custom Media, SFX, Streamer Mode, Secure* “fixes”)
- Degrade a known-good revision while chasing rubric noise

External corroboration:

| Failure | Evidence |
|---------|----------|
| Writer↔Critic overspend when meaning plateaus | [Semantic Early-Stopping (arXiv:2606.27009)](https://arxiv.org/abs/2606.27009) |
| Unbounded agent retries | [CrewAI `max_iter`](https://docs.crewai.com/en/concepts/agents); [limit retries thread](https://community.crewai.com/t/limit-agent-retries/1657) |
| Ralph without max iterations / completion promise | [ghuntley/ralph](https://ghuntley.com/ralph/); [An Tran — Ralph loop](https://antran.app/blogs/2026/ralph_wiggum/); [forum Ralph](https://forum.cursor.com/t/ralph-cursor-guide/149998) |
| Cursor agents stuck in loops (cost / no progress) | [forum review loop](https://forum.cursor.com/t/cursor-agent-enters-endless-loop-without-progressing-past-review-step/126815); [r/cursor spend](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/) |
| Stop-hook grind needs `loop_limit` | [Hooks](https://cursor.com/docs/hooks.md); [Tiwari](https://tiwarivikas.in/writing/cursor-hooks-agent-loop); [Cupcake](https://cupcake.eqtylab.io/reference/harnesses/cursor/) |

**Doctrine:** Hard gates are non-negotiable; soft polish stops on *diminishing returns* or *cap*, then ships the **best-so-far** revision — not the last revision.

---

## 2. Loop roles (minimal)

| Role | Job | Must not |
|------|-----|----------|
| **Builder** | Implement / revise against brief + diff scope | Award points from UI; invent rank thresholds; touch Blizzard secure paths |
| **Critic(s)** | Score + list actionable findings vs rubric | Rewrite product law; demand Retail APIs; nitpick forever |
| **Meta / Moderator** | Filter false positives; resolve critic conflicts; emit stop/continue | Expand scope mid-loop |
| **Verifier (deterministic)** | `lua tests/run.lua`, TOC existence, layer bans | Be replaced by LLM “looks fine” |

Critics are advisory. **Verifier + hard gates** can veto a soft “ship” score.

---

## 3. Finding taxonomy (drives stop vs continue)

Every critic finding must carry:

| Field | Values | Use |
|-------|--------|-----|
| `severity` | `blocker` · `major` · `minor` · `nit` | Stop logic |
| `confidence` | `high` · `medium` · `low` | Conflict filter |
| `category` | `safety` · `layers` · `toc` · `canon` · `ux` · `copy` · `motion` · `perf` · `style` | Authority |
| `actionable` | bool | Drop if false |
| `reopen_locked` | bool | If true → reject finding (do not iterate) |

**Blockers (never soft-stop past these):**

- Bots / injection / protected-action bypass / combat automation
- Retail-only APIs on Anniversary `20506`
- Core→UI or UI awarding points / Net inventing ranks
- TOC lists missing files; Interface silently bumped
- Harness red when Core/Data/harness touched
- Taint footguns from polish juice (EasyMenu, Secure* for panels, ShowUIPanel for Beef windows) — see [`03-taint-lockdown-ux.md`](03-taint-lockdown-ux.md)

**Nits** never alone justify another iteration after the quality floor is met.

---

## 4. Score model (0–100 composite)

Critics emit a structured scorecard. Prefer **weighted composite** over vibes.

| Axis | Weight | What “100” means for CoB V1 |
|------|--------|------------------------------|
| **Hard compliance** | 0.35 | Layers, TOC, Interface 20506, no Retail APIs, no Secure* panel tricks, UI≠scoring |
| **Product fidelity** | 0.25 | Spec §10/§15 + glossary 74–81 + UI brief (Classic shell, announce+toast spectacle, Settings budget) |
| **UX clarity** | 0.20 | Ladder / Standing / Officer IA readable; empty states; dual-encode status; no WA center pulses |
| **Juice quality** | 0.10 | Toast/copy/motion tasteful; brand in words; no glass panels / item-quality rainbow ranks |
| **Perf / hygiene** | 0.10 | No per-frame waste; no chat spam; media-optional load |

```text
S = 100 * Σ (weight_i * axis_i/100)
```

If any **blocker** is open → treat `S` as `min(S, 49)` regardless of juice scores (hard ceiling).

### Default thresholds (tune per surface)

| Surface | Ship floor `S_ship` | Strong ship `S_strong` | Notes |
|---------|---------------------|------------------------|-------|
| Core / Data / BeefNet | 90 | 95 | Prefer verifier green + zero blockers |
| Officer / Commit UI | 85 | 92 | Confirms + named subject for nuclear rites |
| Ladder / Standing chrome | 80 | 88 | Text thresholds; no hero StatusBar |
| Toast / microcopy / motion | 75 | 85 | Taste saturates early |
| Docs-only polish | 70 | 80 | Cap iterations harder |

**Pass rule:** `S >= S_ship` **and** `open_blockers == 0` **and** verifier OK (when in scope).  
**Strong pass:** also `S >= S_strong` **and** no open `major` with `confidence >= high`.

Do **not** burn rounds chasing 100 on juice axes once strong pass holds.

---

## 5. Diminishing returns (semantic + score)

Stop polishing when improvement stalls — even if a critic still has nits.

### Signals (use ≥2 before declaring plateau)

1. **Score delta:** `|S_t − S_{t−1}| < δ` for `P` consecutive rounds  
   - Default: `δ = 2` points, `P = 2` (toast/copy); `δ = 1`, `P = 2` (Core)
2. **Finding churn:** Same finding IDs reappear after a “fix,” or severity only drops `nit↔minor`
3. **Diff churn:** Patch touches only whitespace, rename-without-behavior, or copy synonyms
4. **Oscillation:** Round `t` reverts round `t−1` intent (e.g. add glow → remove glow → add glow)
5. **Scope creep flag:** Critic asks for post-V1 art, SFX, Streamer Mode, Masque, tip jars

### Best-so-far rollback

Keep `rev_best = argmax_t S_t` among revisions that pass hard gates + verifier.  
On plateau, **cap hit**, or **degradation** (`S_t < S_best − δ_deg`, default `δ_deg = 3`): restore `rev_best`, stop.  
Never ship the last churny revision by default.

Research note: pure max-iteration caps waste easy tasks; pure LLM judges every round can dominate cost ([Self-Refine](https://arxiv.org/abs/2303.17651) still needs a stop; [MT-Bench judge caveats](https://tailoredai.substack.com/p/judging-llm-as-a-judge-with-mt-bench)). Prefer **cheap signals** (score delta, finding count, verifier) over embedding pipelines unless orchestration already has them — [2606.27009](https://arxiv.org/abs/2606.27009) studies judge-efficient early-stop; CoB can approximate with issue-count plateau ([22](./22-llm-critique-loops.md)). Loop-gain / best-so-far tooling inspiration: [loopgain-ai/loopgain](https://github.com/loopgain-ai/loopgain); reflective loop essays ([Medium reflective loop](https://medium.com/@vpatil_80538/reflective-loop-pattern-the-llm-powered-self-improving-ai-architecture-7b41b7eacf69)).

---

## 6. Max iterations & budgets

Caps are **failsafes**, not the primary quality signal.

| Loop class | `max_iter` (critique→revise cycles) | Notes |
|------------|-------------------------------------|-------|
| Hotfix (harness red / taint blocker) | 4 | Stop earlier on green verifier |
| Feature polish (one UI surface) | 3 | Default for `/beef` tab juice |
| Adversarial multi-critic pass | 2 full rounds | Then moderator synthesis only |
| Microcopy / toast wording only | 2 | Taste saturates |
| Plan / design critique (pre-code) | 2 versioned cycles | `plan_v1 → critiques → plan_v2` then freeze |

Additional hard stops:

- **Wall-clock / token budget** (orchestrator-defined) → ship best-so-far + report residual
- **Human interrupt** → freeze; do not auto-resume into new scope
- **Verifier regress** twice on same axis → stop and escalate (do not thrash)

`max_iter` counts **revise** attempts after the initial draft, not critic-only rereads.

---

## 7. When to stop critiquing (decision table)

| Condition | Action |
|-----------|--------|
| Any open `blocker` | Continue (or escalate if `max_iter` exhausted) |
| Verifier fail in scope | Continue; ignore juice nits until green |
| `S >= S_strong` and no high-confidence `major` | **STOP — ship** |
| `S >= S_ship`, only `minor`/`nit` left, plateau signals | **STOP — ship** |
| Plateau + `S >= S_ship` | **STOP — ship best-so-far** |
| Plateau + `S < S_ship` | **STOP — escalate** (human / reopen plan); do not silent-ship |
| Oscillation detected | **STOP — ship best-so-far**; park disputed taste in backlog |
| Critic demands locked post-V1 work | Reject finding; do not iterate |
| `max_iter` reached | **STOP — ship best-so-far** if hard gates hold; else escalate |
| Critics disagree only on `nit`/`style` | Moderator drops; **STOP** if floor met |

**Stop critiquing ≠ stop verifying.** A final deterministic check still runs after the last accepted revise.

---

## 8. Conflict resolution when critics disagree

### 8.1 Authority stack (highest wins)

1. **Hard safety / ToS / Classic API reality** (Anniversary `20506`)
2. **Design spec §15 + glossary locks**
3. **UI agent brief** (Classic shell; brand in words)
4. **Machine canon** `Data/Ranks.lua` (never fork numbers into copy)
5. **Layer rules** (UI→Core→Data; Net→Core→Data; Core never `CreateFrame`)
6. **Deterministic verifier** (harness, TOC file existence)
7. **Multi-critic consensus** on soft UX
8. **Single critic taste**

A low-authority critic cannot override a high-authority lock.

### 8.2 Cross-validation rules

Assume 2–3 critics (e.g. Auditor / Adversary / Pragmatist) or Builder-self + external critic. Industry adversarial review systems explicitly **discard single-reviewer-only nits** after challenge rounds ([Agentic Engineers multi-model review](https://agentic-engineers.net/2026/04/22/multi-model-adversarial-code-review.html); [ASDLC adversarial review](https://asdlc.io/patterns/adversarial-code-review); [alecnielsen/adversarial-review](https://github.com/alecnielsen/adversarial-review); [OpenReview disagreement protocol](https://openreview.net/forum?id=fOHvpLs6zp)).

| Situation | Resolution |
|-----------|------------|
| ≥2 critics agree on finding with `confidence ≥ medium` | Accept into backlog for this loop |
| Only one critic flags; others reject as FP | Keep only if `severity ≥ major` **and** `confidence = high` **and** maps to authority ≤6; else drop |
| Split on taste (motion intensity, copy flavor) | Prefer **Pragmatist / product brief**; else keep current; log as non-blocking |
| Split on “is this a blocker?” | Escalate to authority stack; if still unclear → treat as `major`, one fix attempt, then escalate to human |
| Meta-reviewer rejects | Finding dropped for this loop (may reappear next human-requested pass) |
| Critic A wants more spectacle; Critic B cites announce throttle / no WA pulses | **B wins** (spec) |
| Critic wants custom Media / SFX in V1 | **Reject** (brief + glossary) |

### 8.3 Moderator synthesis output

Moderator emits exactly one of:

```text
CONTINUE { top_findings: [...≤5 actionable...], reject: [...], S, S_best }
SHIP     { rev: best-so-far|current, residual_nits: [...], S }
ESCALATE { reason, blockers|plateau_below_floor|oscillation, artifacts }
```

Cap actionable CONTINUE findings at **5** (prefer ≤3). Noise kills loops.

### 8.4 Debate budget

If using adversarial debate (critics critique each other):

- **Max 1 cross-exam round** per polish iteration
- Exit debate early when both sides mark `EXIT_SIGNAL` or no `blocker`/`major` remains disputed
- Do not run debate after soft ship threshold already met

---

## 9. Stop-condition algorithm (normative for orchestrators)

Pseudocode agents can execute literally:

```text
INPUT:
  scope, surface, S_ship, S_strong, max_iter
  δ, P, δ_deg          # defaults: 2, 2, 3 (see §5–§6)
  critics[], verifier

STATE:
  t ← 0
  rev[0] ← Builder.initial(scope)
  history ← []
  rev_best ← null
  S_best ← -∞
  plateau ← 0

FUNCTION HardOK(rev):
  return open_blockers(rev) == 0
     AND verifier.ok(rev)          # skip only if scope excludes harness/TOC
     AND not violates_locks(rev)

LOOP:
  card_t ← run_critics(rev[t], critics)     # scores + findings
  card_t ← moderator.filter(card_t)         # drop FP, apply §8
  S_t ← composite_score(card_t)             # §4; blockers cap S
  history.append({t, S_t, card_t, rev[t]})

  IF HardOK(rev[t]) AND S_t > S_best:
    rev_best ← rev[t]
    S_best ← S_t

  # --- terminal: strong ship ---
  IF HardOK(rev[t]) AND S_t >= S_strong
     AND no_high_confidence_major(card_t):
    RETURN SHIP(rev[t], residual=nits_only(card_t))

  # --- terminal: floor + only soft residue ---
  IF HardOK(rev[t]) AND S_t >= S_ship
     AND max_severity(card_t) <= minor:
    RETURN SHIP(rev[t], residual=card_t.findings)

  # --- diminishing returns ---
  IF t >= 1 AND abs(S_t - S_{t-1}) < δ:
    plateau ← plateau + 1
  ELSE:
    plateau ← 0

  IF plateau >= P OR oscillating(history) OR scope_creep_only(card_t):
    IF rev_best != null AND HardOK(rev_best) AND S_best >= S_ship:
      RETURN SHIP(rev_best, residual=open_soft(card_t), reason=plateau)
    ELSE:
      RETURN ESCALATE(reason=plateau_below_floor, history)

  # --- degradation rollback ---
  IF rev_best != null AND S_t < S_best - δ_deg:
    rev[t] ← rev_best
    RETURN SHIP(rev_best, residual=open_soft(card_t), reason=rollback)

  # --- iteration cap ---
  IF t >= max_iter:
    IF rev_best != null AND HardOK(rev_best):
      RETURN SHIP(rev_best, residual=open_findings(card_t), reason=max_iter)
    ELSE:
      RETURN ESCALATE(reason=max_iter_hard_fail, history)

  # --- continue: only actionable, authority-valid, ≤5 findings ---
  todo ← top_actionable(card_t, limit=5)
  IF todo is empty:
    IF HardOK(rev[t]) AND S_t >= S_ship:
      RETURN SHIP(rev[t])
    ELSE:
      RETURN ESCALATE(reason=no_actionable_path, history)

  rev[t+1] ← Builder.revise(rev[t], todo)
  t ← t + 1
  GOTO LOOP
```

### One-screen checklist (agents)

```text
□ Hard gates green? (safety, layers, TOC, API, harness if in scope)
□ S >= S_ship for this surface?
□ Any high-confidence major left? → fix or escalate
□ Score/findings plateau for P rounds? → ship best-so-far
□ Oscillating taste? → ship best-so-far; don’t flip again
□ Critic vs lock? → lock wins; drop finding
□ t == max_iter? → ship best-so-far or escalate if HardOK false
□ Prefer best-so-far over last revision
```

---

## 10. Church of Beef–specific stop smells

Stop (or reject the finding) immediately if the loop starts demanding:

| Smell | Why stop |
|-------|----------|
| Custom `Media/`, seals pack, SFX default-on | Post-V1; brief forbids Task 7–10 art |
| Center-screen WA pulses / glass panels | Anti-pattern in UI brief |
| `SecureActionButton` “so it works in combat” | Taint/lockdown footgun |
| Standing as StatusBar / item-quality rank colors | Locked against |
| Options sprawl beyond position / minimap / announce | Settings budget |
| Forking thresholds into lore/copy docs | Canon is `Ranks.lua` only |
| “One more pass” with only synonym copy edits | Classic diminishing returns |

---

## 11. What “done” means vs product V1 done

| Claim | Required |
|-------|----------|
| **Polish loop done** | Algorithm returned `SHIP` or human accepted `ESCALATE` disposition |
| **Change done (agent)** | Verification rules: harness when Core/Data touched; TOC truth; no safety violations |
| **V1 complete** | Still only `docs/phases/v1-checklist.md` walked — loops must not claim this |

Guild-chat spectacle remains a **product / in-client** pass; unit tests and critic scores cannot certify it. After `SHIP`, prefer install → `/console scriptErrors 1` → `/reload` → `/beef` when UI/Net/SV/slash were touched.

---

## 12. Mapping stop signals → Cursor harness knobs

| This doc | Cursor / community knob | CoB use |
|----------|-------------------------|---------|
| `max_iter` | Hook `loop_limit` / Ralph max iterations | Default polish 3; harness grind ≤5 ([21](./21-cursor-agent-loops-goals.md)) |
| Plateau / thrash | Semantic early-stop patience | Two no-progress iters → ship best-so-far |
| Hard gates | Verifier + rules + TOC | Never soft-stop past blockers |
| Moderator ≤5 findings | Adversarial consensus filter | Paste into critique prompts |
| Human interrupt | User stop / no re-arm `/loop` | Freeze scope |
| Spectacle done | **Not** automatable | Guild-night / `/reload` human |

Do **not** encode “rubric score ≥ 85” into a stop hook — subjective ([21](./21-cursor-agent-loops-goals.md)).

---

## External sources

> Research ≠ product law. If a stop rule should become mandatory agent policy, promote via human-approved rules/skills and/or spec §15 — not by citing this file alone.

**Cursor official / forum / Reddit**

- [Hooks](https://cursor.com/docs/hooks.md)
- [Best practices for coding with agents](https://cursor.com/blog/agent-best-practices)
- [Ralph Cursor Guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)
- [Endless loop past review](https://forum.cursor.com/t/cursor-agent-enters-endless-loop-without-progressing-past-review-step/126815)
- [Diagnostic loop](https://forum.cursor.com/t/cursor-ai-agent-gets-stuck-in-diagnostic-loop-instead-of-completing-tasks/161838)
- [Loop engineering & orchestration](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283)
- [Native compliance / auto-critique](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)
- [r/cursor — high-spend stuck loop](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/)
- [r/cursor — infinite loop issue](https://www.reddit.com/r/cursor/comments/1qjl5i4/cursor_infinite_loop_issue_anyone_else/)
- [r/ClaudeCode — Ralph vs subagents](https://www.reddit.com/r/ClaudeCode/comments/1r5ticb/cmv_ralph_loops_are_no_longer_needed_with/)

**Research / frameworks**

- [Semantic Early-Stopping for Iterative LLM Agent Loops (arXiv:2606.27009)](https://arxiv.org/abs/2606.27009) (Jun 2026)
- [alphaXiv mirror](https://www.alphaxiv.org/abs/2606.27009)
- [Self-Refine (arXiv:2303.17651)](https://arxiv.org/abs/2303.17651)
- [Reflexion (arXiv:2303.11366)](https://arxiv.org/abs/2303.11366)
- [CrewAI — customize agents / `max_iter`](https://docs.crewai.com/v1.15.1/en/learn/customizing-agents)
- [CrewAI — Agents concepts](https://docs.crewai.com/en/concepts/agents)
- [CrewAI community — limit retries](https://community.crewai.com/t/limit-agent-retries/1657)
- [Loop & Critique pattern](https://tuts.localm.dev/agent-design-patterns/loop-and-critique)
- [Reflective Loop Pattern (Medium)](https://medium.com/@vpatil_80538/reflective-loop-pattern-the-llm-powered-self-improving-ai-architecture-7b41b7eacf69)
- [Judging LLM-as-a-Judge summary](https://tailoredai.substack.com/p/judging-llm-as-a-judge-with-mt-bench)
- [loopgain-ai/loopgain](https://github.com/loopgain-ai/loopgain)

**Adversarial review / consensus**

- [Multi-Model Adversarial Code Review](https://agentic-engineers.net/2026/04/22/multi-model-adversarial-code-review.html)
- [ASDLC — Adversarial Code Review](https://asdlc.io/patterns/adversarial-code-review)
- [alecnielsen/adversarial-review](https://github.com/alecnielsen/adversarial-review)
- [addyosmani/adverse](https://github.com/addyosmani/adverse)
- [OpenReview — Adversarial Review protocol](https://openreview.net/forum?id=fOHvpLs6zp)
- [ClawHub — adversarial-code-review](https://clawhub.ai/reikys/adversarial-code-review)

**Ralph / Cursor loop tooling**

- [ghuntley — Ralph](https://ghuntley.com/ralph/)
- [An Tran — Ralph Wiggum loop](https://antran.app/blogs/2026/ralph_wiggum/)
- [hellotommmy/cursor-loop](https://github.com/hellotommmy/cursor-loop)
- [Cupcake — Cursor stop followup](https://cupcake.eqtylab.io/reference/harnesses/cursor/)
- [Tiwari — Hooks on the agent loop](https://tiwarivikas.in/writing/cursor-hooks-agent-loop)
- [agrimsingh/ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor)

**In-repo scrapes**

- `_search-llm-critique-stop.json`, `_search-multi-agent-adversarial-review.json`, `_search-adversarial-review-protocols.json`, `_search-community-cursor-reddit.json`

---

## 13. Expansion — literature stop recipes → CoB defaults (2026-07-26)

**Catalog:** [`22b-agentic-critique-sources.md`](22b-agentic-critique-sources.md). Extract: `_deep-agentic-critique.extract.md` §2.

### 13.1 Per-paper / per-framework caps (steal the numbers)

| System | Cap / stop | CoB takeaway |
|--------|------------|--------------|
| [Reflexion](https://arxiv.org/abs/2303.11366) | ~3 trials; env pass | Actor attempts ≤3; harness = env |
| [Self-Refine](https://arxiv.org/abs/2303.17651) | Exp up to 5; plateau ~3 | Prefer **3**; warn degrade |
| [Constitutional AI](https://arxiv.org/abs/2212.08073) | Revision budget + external selector | Constitution rows + human/smoke selector |
| [LangGraph eval-opt](https://langchain-ai.github.io/langgraph/tutorials/workflows/) | `pass` **or** max_iter | Binary decision + cap |
| [CrewAI](https://docs.crewai.com/en/concepts/agents) | `max_iter` / `max_retry_limit` | Lower polish to 2–3 (ignore default 20) |
| [AutoGen](https://arxiv.org/abs/2308.08155) | termination msg **or** `max_round` | Structural wall only |
| [LATS](https://arxiv.org/abs/2310.04406) | Expansion×depth budget | Only where harness scores; **not** for UI juice |
| [MT-Bench](https://arxiv.org/abs/2306.05685) | Judge turn caps + swap | Never scalar-only ship |

### 13.2 Four orthogonal stops (each sufficient)

From deep research synthesis — any one ends the LLM polish loop:

1. **Hard `max_iters`** (default 3 Actor attempts)  
2. **Pass signal** (all H*+U* PASS / critic `decision=pass`) — trust once; do not re-enter on nits  
3. **Score / finding plateau** (`δ`, `P` from §5) → ship **best-so-far**  
4. **Deterministic Verifier** — if red, no soft stop; if green and only nits, skip further LLM rounds  

Pair every numeric `S` with a **decision** enum so the model cannot game the metric.

### 13.3 CoB surface defaults (unchanged, reaffirmed)

| Surface | `max_iter` | `S_ship` | Human after SHIP? |
|---------|------------|----------|-------------------|
| Toast / microcopy | 2 | 75 | Yes if UI path |
| Ladder / Standing chrome | 3 | 80 | Yes |
| Officer / Commit | 3 | 85 | Yes |
| BeefNet / Sync | 2 adversarial + Meta | 90 | **Two clients** |
| Core / Data | 4 hot-fix / 3 polish | 90 | Optional |

Guild spectacle remains **outside** the algorithm — see verification.mdc.
