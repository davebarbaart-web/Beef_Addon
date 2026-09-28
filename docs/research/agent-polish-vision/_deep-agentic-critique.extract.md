# Deep research extract — agentic critique
run: trun_91f36069f0964480a5f638b6b4648212

## 1_the_shared_pattern_across_the_literature

Every system you named — Reflexion, Self-Refine, Constitutional AI, MT-Bench judging, multi-agent debate, LATS, LangGraph's evaluator-optimizer, AutoGen's group chat, CrewAI's iterative tasks, Cursor's Bugbot — converges on the same four-stage loop:

> **Generate → Critique → Revise → Stop.**

The differences are *how* each stage is implemented and *what counts as "good enough"*. Concrete answers to your four sub-questions (stop conditions, role separation, rubric design, VLM failure modes) sit in §2–§7; §8 collapses them into a Core + Smoke plan that fits a WoW Classic Lua addon where offline determinism matters and the live client can only be exercised by a human in-game.

A useful upstream framing: Anthropic's "Building Effective Agents" distinguishes *workflows* (predetermined paths) from *agents* (dynamic, tool-using). For an addon build pipeline you want **workflows with one bounded agentic step** — fully autonomous self-improvement loops have repeatedly been shown to *degrade* code after a few iterations (see Self-Refine §2.2 and Bugbot §6). The right mental model is **Bounded Iterative Refinement (BIR)**, not autonomous agents.

---

## 2_stop_conditions_concrete_recipes

The literature is unusually consistent: every paper that loops LLM-on-LLM **has to add an external termination oracle** because the loop itself does not converge.

### 2.1 Reflexion (Shinn et al., 2023, arXiv:2303.11366)
* **Architecture**: Actor → Evaluator (binary pass/fail) → Self-Reflection → memory buffer of reflections.
* **Cap**: paper uses **up to 3 trials** on HumanEval, then either passes or fails. They show diminishing returns past 2 reflections even on the hardest problems.
* **Termination**: (a) unit test pass, (b) trial cap reached. The reflection memory is **bounded by a sliding window**, not unbounded.

### 2.2 Self-Refine (Madaan et al., 2023, arXiv:2303.17651)
* Single same-model feedback loop: `output → feedback → refine`.
* **Iteration cap in experiments: 5**. Authors explicitly note quality plateaus or *degrades* on dialog/math tasks after 3 iterations.
* No convergence criterion — relies entirely on iteration count. Treat this as a warning: **Self-Refine with no oracle can drift**.

### 2.3 Constitutional AI (Bai et al., 2022, arXiv:2212.08073)
* **SL stage**: sample a principle from the constitution → critique the response against it → revise. The loop is sampled **N times per response** (typically 4–16 in the paper) and the *best* revised response is chosen.
* Termination: (a) sampled-revision budget exhausted, (b) no principle violated. Critically, **a separate non-helpfulness model selects the final answer** — the loop itself never says "done."
* **Practical implication**: a hard revision budget *plus* an external selector is the safer pattern than a single loop trying to self-terminate.

### 2.4 MT-Bench / LLM-as-Judge (Zheng et al., 2023, arXiv:2306.05685)
* Not a refinement loop — it's a *judging* loop with **two reference comparisons and swap-of-position to debias**. Termination: max turns (2 in MT-Bench).
* Documents three biases the judge carries into any loop:
  * **Position bias**: ~75% agreement when reference swaps (model prefers first/second depending on order).
  * **Verbosity bias**: longer answers score higher independent of quality.
  * **Self-enhancement bias**: GPT-4 prefers GPT-4 outputs ~10% over Claude.
* These biases apply whether you are ranking two candidates or scoring one revision — bake in position swapping and length normalization.

### 2.5 Multi-Agent Debate (Du et al., 2023, arXiv:2305.14325)
* Two-round debate among multiple instances; termination when (a) majority agrees, (b) rounds exhausted.
* Improvement is *task-dependent*: arithmetic and factuality gain, but math proofs and some reasoning tasks can **regress** when forced into adversarial framings. Use debate selectively — not as a default polish step.

### 2.6 LATS — Language Agent Tree Search (Zhou et al., 2023, arXiv:2310.04406)
* Full MCTS: selection → expansion → simulation → backprop, with the **environment as the reward signal** (in their case, code execution).
* **Budget**: explicit max expansions × max depth (e.g. 8 expansions × depth 5). Without an executable ground truth, LATS collapses to Self-Refine.
* **Hard lesson for addon work**: LATS only works when the environment can score candidate code deterministically — which a Lua addon running inside the WoW client cannot, except for the parts you can host in a Lua interpreter sandbox.

### 2.7 LangGraph Evaluator-Optimizer (the canonical pattern)
The `langchain-ai/langgraph` workflows tutorial codifies the loop as:

```
STATE = { messages: [...], iteration: int, score: float }

generate(state)     # produces candidate
evaluate(state)     # returns {"score": int, "feedback": str, "decision": "pass"|"revise"}
route(state)        # if score >= threshold OR iteration >= max_iter → END, else → generate
```

Stop conditions, in priority order:
1. **Evaluator emits `decision: pass`** — the only "I'm done" signal a model reliably gives.
2. **Score ≥ threshold** (numeric quality bar; must be calibrated against a held-out set, not a vibes threshold).
3. **Iteration cap** (default 3–5).
4. **No-change streak** (e.g. two consecutive revisions with diff < N lines → loop is grinding, stop).
5. **Time / cost budget** (per-task and global — your wallet is the real wall).

### 2.8 Cursor's Bugbot (Jan 2026 blog)
* Generator agent proposes fix → Reviewer agent scores against a fixed rubric → revision loop. Stop on reviewer pass or budget.
* The published metric: 40 experiments over 11 versions, **resolution rate 52% → 70%**, bugs flagged per run 0.4 → 0.7. The 0.7 number is critical — pushing more flags raised precision cost, so they cap rather than maximize.

### 2.9 AutoGen Group Chat
* Termination: a speaker says a phrase matching `is_termination_msg(content)` regex, **or** `max_round` is hit (default 12). No "quality" gate — purely structural. For real stop conditions you need an external judge.

### 2.10 CrewAI
* Per-task `max_iter` (commonly 5–25). When hit, the task is marked FAILED with the best-so-far artifact. There is no intrinsic convergence check.

### Synthesis — what to actually use

For an offline-deterministic Lua addon core, treat the loop as a state machine with **four orthogonal stop conditions**, each independently sufficient:

| Condition | Why it matters | Typical value |
|---|---|---|
| **Hard `max_iters`** | Wall-clock and cost bound | 3 (rarely 5) |
| **Pass signal** | The model claims done; trust it once, never twice in a row | n/a |
| **Score threshold + plateaus** | Two consecutive identical or lower scores | `Δscore < 0.05 for 2 rounds` |
| **Deterministic checks first** | If static checks pass, skip the loop entirely | n/a |

Never use *just* a numeric score. Pair it with a reviewer **decision** ("pass / revise / abort") because scalar-only loops reward the model to game the metric.

---

## 3_role_separation_what_each_persona_should_and_should_not_do

The single most common architectural mistake is collapsing the generator and the critic into one model with one prompt. Even Constitutional AI — which is essentially self-critique — uses **two different sampling temperatures** and explicitly *samples* a principle before each critique. The papers and industry practice converge on four canonical roles:

| Role | Reads | Writes | Allowed to do | **Forbidden** |
|---|---|---|---|---|
| **Generator** | spec, prior diff, critique | new code | propose; cite evidence | declare pass |
| **Critic / Evaluator** | spec, candidate diff, tests, static analysis | structured verdict `{decision, score, evidence, fix}` | cite line numbers | edit code |
| **Verifier** | candidate diff | PASS/FAIL on **deterministic** checks (luac, lua-language-server diagnostics, custom Lua test harness) | enforce hard rules | give prose feedback |
| **Selector** | N candidates + scores | chosen artifact + reason | tie-break | rewrite code |

The Critic's output schema — this is the single most useful piece of machinery to copy — should always look like:

```
{
  "decision": "pass" | "revise" | "reject",
  "score":    0.0-1.0,
  "violations": [
    { "rule": "no_globals_in_core", "evidence": "line 42: WoWGlobal = …",
      "severity": "blocker" | "major" | "minor", "fix": "…" }
  ],
  "summary": "…"
}
```

### Why three roles and not two

Cursor's Bugbot blog is explicit: the *generator* and *reviewer* use different prompts and (in their hill-climbing harness) different model weights. AutoGen's GroupChat assigns a fixed persona per speaker. CrewAI's Crew assigns a fixed role per Agent. Across all of them:

* **Self-critique alone does not work** beyond 2–3 iterations; the model converges to defending its own output (Self-Refine §5.3, Constitutional AI §4.2).
* **A second model instance** with a different system prompt (and ideally a different model family) catches what the first one rationalizes away.
* **Deterministic verification must run before and independently of the LLM judge** — the Verifier's pass is a hard gate.

### Role separation for the Lua addon specifically

| Role | Person | What it does |
|---|---|---|
| Generator | LLM A (e.g. Claude Sonnet) | Writes `Core.lua`, addon frame XML, event handlers. Receives diff + structured critique only. |
| Critic | LLM B (e.g. a different model or the same model, fresh context) | Reads diff + Blizzard API docs chunk + generated code. Outputs the structured verdict above. |
| Verifier | Static | `luac -p`, `luacheck`, custom Lua test harness stubbing the WoW API surface. **Always runs; failure is a blocker regardless of the LLM critic.** |
| Selector | Static / user | If multiple candidates survive, pick highest critic score; if tie, pick shortest diff. **No LLM.** |

---

## 4_rubric_design_what_actually_anchors_a_critic

The MT-Bench paper is the canonical reference, but the rubric design lessons transfer to your reviewer because they are about LLM-as-judge robustness in general.

### 4.1 Anchored multi-point scales beat open-ended scoring
* MT-Bench uses an **L1–L10** scale with explicit anchor descriptions at each level (no anchoring ⇒ near-uniform 7/10 from judge models).
* For your Lua reviewer: anchor every dimension (correctness, perf, Blizzard-API compliance, edge cases, readability) with two- or three-line descriptions. Without anchors, every revision will hover near your threshold.

### 4.2 Multiple targeted dimensions beat one composite score
* MT-Bench evaluates on **writing, math, reasoning, factuality, coding** etc. separately and then aggregates.
* For an addon, the natural dimensions are:
  * `blizzard_api_correctness` (does it use live APIs and not removed ones, correct event names)
  * `state_machine_soundness` (proper registration/unregistration on PLAYER_LOGIN/LOGOUT)
  * `compatibility_windows` (TOC fields, restricted APIs in Classic Era vs TBC vs WotLK Classic)
  * `performance` (OnUpdate throttling, table reuse, no string concat in hot paths)
  * `ui_layout_readability` (read by VLM critic — see §7)
  * `edge_cases` (death, instance transitions, logout mid-cast, etc.)

A composite score hides where the regression is. Use per-dimension scoring.

### 4.3 Self-preference / format bias
* MT-Bench finds GPT-4 systematically prefers its own outputs. For you, this means **never let the critic be the same model family as the generator** for scoring that influences revision direction; only allow it for separate verification tasks. (Constitutional AI sidesteps this by using a *separate* judge model trained from the same base with different fine-tuning.)

### 4.4 Tie-break rules
* MT-Bench handles ties by forcing the judge to declare a winner; you should mirror this: the Selector above breaks ties on **shortest diff**, not on critic score. The critic is biased; the diff is auditable.

---

## 5_visual_qa_with_vlms_where_it_breaks_for_addon_ui_screenshots

You will, inevitably, want a vision model to grade "does this frame / unit frame / minimap button look right?" Several failure modes are documented and reproducible.

### 5.1 Fine-grained perception is unreliable
* Modern VLM judges are weak at tasks requiring fine-grained pixel-level comparison: "is the debuff border thickness exactly 2 px?", "is the icon at row 3 col 5?" They will confidently say yes to images where the relevant detail is a few pixels. They are **better at coarse presence/absence** ("is the minimap button there at all?") than at *correct* presence/absence ("is the button in the *correct quadrant*?").
* Implication: **gold test must be deterministic pixel diff** for fine geometry, not VLM judgment. Use VLM only for coarse semantic checks.

### 5.2 Position and order bias
* Mirrors MT-Bench's position bias: VLMs in "compare these two screenshots" mode prefer whichever they see first (or whichever they see second, depending on prompt). For sequential "did this revision improve?" prompts the same bias applies — later positions get a slight edge.
* Mitigation: **(a) never feed both old and new at once**; (b) present with randomized labels; (c) ask for a verdict and a confidence; (d) throw out low-confidence verdicts.

### 5.3 Frame-rate / temporal blindness
* VLMs operate on a static image. WoW UI is animated (action bar cooldowns, combat pulses, threat flashes, animated textures). A still frame may legitimately look "wrong" while the game is fine, or look "fine" while a visual regression only shows up over multiple frames.
* Implication: VLM critique is for **layout, alignment, palette, visibility** — never for animation correctness. Multi-frame comparison is needed for animation.

### 5.4 Resolution / downscaling artifacts
* Real WoW renders at 1080p–4K with UI scale, but the framebuffer the addon code touches is logical, not physical. If you pipe screenshots through a VLM at low res, subtle font kerning and overlay offsets are lost. **Render at 1× and 2× UI scale, both**, and present the higher-res crop for the VLM to inspect a localized region.

### 5.5 "Looks fine" hallucination on small UI
* VLMs default to high ratings on UI screenshots because the prior is "UI usually looks fine." They miss missing elements more often than they misflag present ones. Set the threshold asymmetrically: **flag aggressively on any "missing element" claim, accept leniently on "looks fine" claims.**

### 5.6 Multi-monitor and full-screen quirks
* In full-screen exclusive mode the WoW framebuffer may not be capturable without `PrintScreen` hotkey or DXGI capture. In windowed mode you get the actual UI but with OS chrome around it. Pick one mode and stick to it for the screenshot test set.

---

## 6_community_industry_patterns_worth_stealing

* **Anthropic Claude Code best practices**: "explore → plan → code", "give Claude a way to verify its own work" (tests, type checker), "use subagents for review." The *verify your own work* line is the most under-appreciated — for you it means the Verifier role (§3) is not optional.
* **Cursor Bugbot**: generator + reviewer + a curated *bug set* for hill-climbing. The lesson: maintain a tiny **regression corpus of known WoW API footguns** (renamed APIs between Classic versions, removed APIs, secure-frame restrictions) and grade every revision against it. This is your "BIRD/Spider" for addon code.
* **Aider repomap**: feeds the generator only the relevant subset of the repo. For a multi-file addon (Core + Modules + SavedVars + Events + UI), the analog is **explicit per-task context**: "you may only read `Core.lua` and `Events.lua` for this fix."
* **Reddit / r/ClaudeCode, r/cursor, r/LocalLLaMA recurring recipes** consistently converge on:
  1. write the test first (or at least the assertion), let the model fill the impl;
  2. one revision per failure mode, never bundle fixes;
  3. always re-run the full static-analysis suite after a revision;
  4. if the diff is bigger than the file, throw it out and start over.

---

## 7_the_worked_pattern_offline_testable_core_human_in_game_smoke

A WoW Classic addon (Lua 5.1, WoW API 1.14 / 3.4.x depending on era, plus the live client on PTR) is unusually well-suited to this architecture because the *Core* is pure Lua and the *UI / live integration* is inherently visual and stateful — exactly the boundary the literature says you should not let one model cross.

### 7.1 Architecture

```
┌─────────────────────────────────────────────┐
│  Core (pure Lua, offline-deterministic)     │
│   - state machine, SavedVariables, logic    │
│   - Blizzard API calls injected as seams   │
│   - ships with Lua test harness             │
└────────────┬────────────────────────────────┘
             │ thin shim
┌────────────▼────────────────────────────────┐
│  Blizzard-API stub layer (seams)            │
│   - CreateFrame, GetUnitName, etc. faked    │
│   - allows headless `lua CoreTest.lua` run  │
└─────────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────┐
│  Human in-game smoke (visual + interactive) │
│   - in-game /run slash commands              │
│   - /reload, /console, scripted UI test     │
│   - screenshot grid → VLM critique (opt)    │
└─────────────────────────────────────────────┘
```

### 7.2 Core review loop (offline, automated)
* **Inputs**: change request + diff + failing test (when present) + prior critic verdict.
* **Generate**: `llm_generate(spec, prior_verdict) -> patch`.
* **Verify (deterministic, blocking)**: `luac -p`, `luacheck`, `busted`-style harness on the stubbed Blizzard API. **Pass required before any LLM judge is consulted.** This is your "Verifier" — it doesn't need an LLM.
* **Critique (LLM, advisory only)**: a *different* model role reads the diff and outputs the structured verdict from §3. Critiques that conflict with the verifier are dropped.
* **Stop**:
  1. Verifier passes AND critic `decision == pass`;
  2. score plateau (no improvement over 2 rounds);
  3. `max_iters == 3`;
  4. cost budget per PR exceeded.
* **Default `max_iters = 3`** — consistent with Reflexion's experiments and well below Self-Refine's drift threshold.

### 7.3 In-game smoke (human-in-the-loop)
* The literature on agent loops *cannot* cover this: no offline environment scores it. Treat it as a **Definition of Done checklist the human runs**, not as something the loop can automate. Concrete items:
  * `/reload` clean — no Lua errors in BugSack/VoiceOver
  * No taint on restricted frames (`/etrace` or similar)
  * Each interactive feature (right-click menu, drag, settings panel) does the documented thing
  * SavedVariables round-trip across `/reload`
  * On a freshly-installed client, the addon loads without manual intervention
  * Does not interact badly with the top 5 addons in the user's class-specific WeakAuras/BigWigs suite (your test partner is the user)
* **Frequency**: every PR. A 15-minute smoke checklist beats any automated UI test for addon UX regressions.

### 7.4 Optional: VLM-assisted visual smoke
* When the change is UI-affecting, capture a **grid of screenshots** at fixed UI scales (1.0 and 1.25) with the addon enabled, blank UI for baseline, and a "control" screenshot of a known-good previous build.
* Feed to a VLM critic with this rubric:
  1. Element present at expected quadrant? (yes/no)
  2. Element overlaps game-critical UI? (yes/no)
  3. Colors contrast adequately against typical backdrops? (1–3)
  4. Text legible at the captured UI scale? (1–3)
* **Never** treat VLM output as the pass/fail signal. Use it to **flag** for human eyes. Concrete numbers from the literature: fine-grained perception is unreliable; **element-presence** checks are usable; **fine pixel diff** is not.

### 7.5 Role-separation contract for the agent harness

| Agent role | Sees | Writes | Forbidden |
|---|---|---|---|
| Generator | spec + critic's structured verdict + last 3 diffs | new patch | declare pass; call Blizzard API not on seam list |
| Critic (fresh context, ideally different model) | spec + diff + test results | structured verdict | rewrite code; declare pass without evidence |
| Verifier (no LLM) | source + stubs | pass/fail per check | give subjective feedback |

The Critic and Verifier are deliberately **independent and adversarial** — the Critic cannot override the Verifier, the Verifier cannot give prose feedback. This is the structural lesson from Constitutional AI: the *process* of critique must be separable from the *artifact* being critiqued.

### 7.6 Concrete rubric for the Critic (Lua / WoW Classic)
A working rubric to drop into the prompt:

```
Decision criteria (mark pass only if ALL blockers = 0 and majors = 0):
BLOCKER:
  - hard-codes global state into a frame member
  - assumes a Blizzard API that returns table but does not nil-guard
  - uses a removed/renamed API in the targeted Classic client version
  - modifies or hooks a protected (blizzard-owned) function
MAJOR:
  - registers an event without unregistering on PLAYER_LOGOUT
  - O(n) scan inside an OnUpdate hot loop without throttle
  - SavedVariables write on every tick (not on relevant events only)
  - string concatenation or table.create inside OnUpdate
  - frame strata misuse (FRAME_STRATA stays in WORLD vs DIALOG)
MINOR:
  - magic numbers without constants
  - missing local declaration for hot-path variables
  - missing :SetPoint() anchor strings vs numeric positions
```

This is the rubric's job: **convert subjective critique into structured, enumerable signals** that feed the stop-condition machine and let you count regressions over time.

### 7.7 What the loop does NOT do (be honest about it)
* It does not catch every visual regression — that's the human smoke test.
* It does not catch cross-addon interaction regressions — that's the human smoke test.
* It does not catch every Blizzard-API edge case that only shows up on a specific retail/PTR build — that's a manual checklist on the target client.
* It does, reliably: catch missing nil-guards, taint-able table writes, removed API usage, event-leak bugs, perf hot-path problems, and obvious logic regressions. **That is a very high bar already**, and most addon bugs in the wild are exactly these.

---

## 8_synthesis_why_this_architecture_wins_for_lua_addons

Three structural facts about Lua addons make this pattern uniquely effective:

1. **The Core is fully unit-testable offline.** The Lua interpreter is small and standard; Blizzard's API surface is finite and well-documented. Stubbing is cheap. Most logic bugs live in the Core.
2. **The UI layer is exactly where automated critique is weakest.** The literature is consistent that VLMs miss fine-grained perception, animation, and game-context-dependent aesthetics. Don't fight that — route UI verification to the human in-game, and let the loop work where it is strong: textual, semantic, deterministic.
3. **Revisions are cheap, deploys are cheap.** Unlike ML training, a Lua patch is milliseconds to write and seconds to test. So a small `max_iters` cap (3) costs almost nothing, and the marginal value of the 4th iteration is empirically close to zero.

So: **deterministic verifier first, LLM critic second (separate model/role), human visual smoke third**, with a hard 3-iteration cap and per-PR cost budget, structured verdict schema, and an explicit rubric that converts the LLM's qualitative feedback into countable signals that survive into your next PR.

---

## appendix_source_urls

* Reflexion — https://arxiv.org/abs/2303.11366
* Self-Refine — https://arxiv.org/abs/2303.17651
* Constitutional AI — https://arxiv.org/abs/2212.08073
* MT-Bench / LLM-as-Judge — https://arxiv.org/abs/2306.05685
* Multi-Agent Debate (Du et al.) — https://arxiv.org/abs/2305.14325
* LATS — https://arxiv.org/abs/2310.04406
* LangGraph Workflows (Evaluator-Optimizer) — https://langchain-ai.github.io/langgraph/tutorials/workflows/
* Anthropic — *Building Effective Agents* — https://www.anthropic.com/research/building-effective-agents
* Anthropic — *Claude Code Best Practices* — https://www.anthropic.com/engineering/claude-code-best-practices
* Cursor — *Building a better Bugbot* — https://cursor.com/blog/building-bugbot
* CrewAI Tasks (max_iter) — https://docs.crewai.com/en/concepts/tasks
* AutoGen GroupChat (is_termination_msg / max_round) — https://microsoft.github.io/autogen/stable/user-guide/core-user-guide/framework/agent-and-agent-runtime.html
</answer>

## Basis field answers

### 1_the_shared_pattern_across_the_literature


_confidence: medium_

### 2_stop_conditions_concrete_recipes


_confidence: high_

### 3_role_separation_what_each_persona_should_and_should_not_do


_confidence: medium_

### 4_rubric_design_what_actually_anchors_a_critic


_confidence: medium_

### 5_visual_qa_with_vlms_where_it_breaks_for_addon_ui_screenshots


_confidence: medium_

### 6_community_industry_patterns_worth_stealing


_confidence: medium_

### 7_the_worked_pattern_offline_testable_core_human_in_game_smoke


_confidence: medium_

### 8_synthesis_why_this_architecture_wins_for_lua_addons


_confidence: medium_

### appendix_source_urls


_confidence: high_
