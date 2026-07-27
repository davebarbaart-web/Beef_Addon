# 49 — Adversarial critic: over-engineering polish (protect the ship)

**Lane:** `docs/research/agent-polish-vision/` — **hostile process review**, not product law  
**Audience:** Humans and agents tempted to “scale quality” with more loops, more agents, more juice  
**Last updated:** 2026-07-26  

**Authority (do not invert):**

1. Design spec §3 / §10 / §13 / §15 — `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`
2. Walkable done bar — `docs/phases/v1-checklist.md`
3. UI brief bans — `docs/superpowers/ui-polished-direction-for-agents.md`
4. Ops evidence — `.cursor/rules/verification.mdc` · `.cursor/skills/church-of-beef-dev/SKILL.md`
5. This note — **cut scope**; if it conflicts with locked §15, **spec wins**

**Siblings:** [29-superpowers-loop-patterns.md](./29-superpowers-loop-patterns.md) (thin pro-loop spine) · [31-loop-stop-conditions.md](./31-loop-stop-conditions.md) (caps) · [21-cursor-agent-loops-goals.md](./21-cursor-agent-loops-goals.md) (Cursor goals/hooks) · [21b-cursor-loops-source-digest.md](./21b-cursor-loops-source-digest.md) (annotated bibliography) · [37-skill-draft-polish-loop.md](./37-skill-draft-polish-loop.md) (draft skill — not installed) · [28](./28-hands-off-cursor-workflows.md) (hands-off).

Research scrapes (`.firecrawl/`, `**/.raw/`, `_search-*.json`) and agent-process fashion are **not** product truth. Spec §15 / glossary / `verification.mdc` win on conflict.

---

## Verdict (one line)

**Ship the social ladder that works in guild chat — not a juice OS, not a 50-agent polish cult.** Every extra critique round, parallel swarm, or AnimationGroup that does not move a `v1-checklist.md` box is schedule theft dressed as craft.

---

## What Church of Beef V1 actually is

| Fact | Implication for polish process |
|------|--------------------------------|
| Social guild ladder + officer Commit + BeefNet | Correctness and two-client sync beat micro-timing recipes |
| Spectacle = one throttled `/g` line + private edge toast | Not WA center pulses, particle systems, or SFX stacks |
| V1 silent; no custom `Media/` | “Juice system” has almost nowhere legal to live |
| Classic shell + GameFont*; brand in words | Art/heraldry polish is **post-V1** by doctrine |
| Green `lua tests/run.lua` ≠ V1 done | Client + guild-night social check are the real gates |
| Spec success criterion 11 is *human reaction in guild chat* | Agents cannot A/B-test spectacle with more subagents |

If the flock does not notice a promotion in `/g`, V1 failed — even if fifty agents agreed the toast easing curve is “chef’s kiss.”

---

## Attack surface 1 — Polish loops that never stop

### Failure mode

Writer → Critic → Refiner → Meta-critic → “one more pass” until the diff is taste churn. Industry patterns exist because **unbounded critique burns tokens and often degrades the answer**:

| Pattern | What it warns | Source |
|---------|---------------|--------|
| Semantic early-stop | Stop when meaning + quality plateau across Writer↔Critic drafts | [arXiv:2606.27009](https://arxiv.org/abs/2606.27009) |
| CrewAI `max_iter` / retry limits | Caps are safety bounds, not quality oracles | [CrewAI agents](https://docs.crewai.com/en/concepts/agents); [community retries](https://community.crewai.com/t/limit-agent-retries/1657) |
| Ralph-style loops | Always set max iterations + verifiable completion promise | [ghuntley/ralph](https://ghuntley.com/ralph/); [forum Ralph guide](https://forum.cursor.com/t/ralph-cursor-guide/149998) |
| Cursor stop hooks | `followup_message` can grind forever without `loop_limit` | [Hooks docs](https://cursor.com/docs/hooks.md); [Tiwari on stop](https://tiwarivikas.in/writing/cursor-hooks-agent-loop) |
| Forum / Reddit burn reports | Agents stuck in review/diagnostic loops; spend spikes | [forum endless review](https://forum.cursor.com/t/cursor-agent-enters-endless-loop-without-progressing-past-review-step/126815); [r/cursor $2000 loop](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/) |

CoB already has a hard product stop: checklist boxes and locked §15. Ignoring that stop and optimizing for “craft score” invents a second product.

### How it shows up here

- Re-litigating brand hex, Standing bars, Streamer Mode, SFX, ceremonial dashboard — all **locked out or deferred**
- Critique against canvases / research tracks instead of glossary 74–81 + UI brief
- Claiming “polish complete” from desktop screenshots of mock layout while BeefNet / officer Commit are unproven
- Overnight Ralph-style loops editing `UI/*` without install → `/reload` → BugSack

### Cut rule

| Cap | Rule |
|-----|------|
| Critique rounds | **≤ 2** per slice (implement → critique → fix → optional re-critique). Then human eyes or next checklist item |
| Slice size | One observable checklist cluster; no “make the addon feel premium” epics |
| Stop signal | Spec/checklist ✅ + mechanical verify ✅ — **not** “critic still has nits” |
| Ambiguity | Escalate to human / §15 log — do **not** invent policy in the loop |

Doc 29’s composite loop is useful **only** when steps 3 and 6 (mechanical verify + ledger) stay mandatory and step 4 stays short. The moment critique becomes the product, kill the loop.

---

## Attack surface 2 — Fifty-agent swarms

### Failure mode

Parallel “auditor / adversary / pragmatist / juice lead / psychology lead / …” looks like rigor. For a small Lua addon with a locked UI doctrine, it is **coordination tax**: conflicting nits, context pollution, false confidence from consensus on the wrong metric, and burned budget before two clients touch BeefNet.

Published multi-agent review patterns themselves warn: filter to high-confidence findings; meta-review / consensus to kill false positives; do not replace human review on critical paths. Scaling *reviewer count* without scaling *evidence* is theater.

| Practice | Takeaway for CoB | Source |
|----------|------------------|--------|
| Adversarial consensus (2–3 models) | Discard 1/3-only nits; keep 2/3+ or challenged majors | [Agentic Engineers multi-model review](https://agentic-engineers.net/2026/04/22/multi-model-adversarial-code-review.html) |
| ASDLC / ClawHub adversarial review | High-signal findings only; separate builder from critic | [ASDLC pattern](https://asdlc.io/patterns/adversarial-code-review); [ClawHub skill](https://clawhub.ai/reikys/adversarial-code-review) |
| Cross-model debate repos | Useful for security/logic — overkill for toast easing | [alecnielsen/adversarial-review](https://github.com/alecnielsen/adversarial-review); [addyosmani/adverse](https://github.com/addyosmani/adverse) |
| Cursor best practices | Plan + review diffs; parallel explore ≠ 50 polish agents | [Cursor agent best practices](https://cursor.com/blog/agent-best-practices) |
| Cursor multi-agent skepticism | Parallel agents are coordination, not free rigor | [Elegant Software — multi-agent](https://www.elegantsoftwaresolutions.com/blog/cursor-multi-agent-not-what-you-think) |

### How it shows up here

- One agent per research track (timing, color, prestige, celebration, fonts…) all filing PRs against the same toast
- Best-of-N UI variants when V1 chrome is template-native by law
- Swarm “synthesis” docs that restate the UI brief without moving code
- Cloud fleets polishing `docs/research/` while `v1-checklist.md` stays mostly unchecked

### Cut rule

| Role budget (V1) | Allowed |
|------------------|---------|
| Implementer | 1 |
| Critic / reviewer | 0–1 (diff vs spec + layers + safety) |
| Meta-reviewer / debate rounds | **0** for polish; optional once for security/BeefNet forgery paths |
| Parallel explorers | OK for **research** scrapes only — not for simultaneous UI edits |
| Hard ban | ≥3 agents editing the same frame tree; ≥5 agents on one “juice” slice |

**Default ship path:** one coding agent + `church-of-beef-dev` evidence + optional single adversarial pass on Net/Core. Not a swarm.

---

## Attack surface 3 — Juice systems

### Failure mode

“Juice” (screen shake, staggered overshoot, layered SFX, particle seals, prestige chroma) is a **game-feel stack**. CoB V1 is a **process UI + social announce**. Building a reusable juice framework (central tween bus, ranked intensity tables, OnUpdate drivers, SharedMedia hooks) before the ladder commits and syncs is classic over-engineering: elegant API, empty product.

This is the AI-coding form of **YAGNI** — agents love abstractions and “systems” when a show/hide + guild line would ship ([YAGNI refresher](https://builtin.com/software-engineering-perspectives/yagni); [YAGNI × AI](https://blog.flurdy.com/2026/02/yagni-100-with-ai); [agentic YAGNI pattern](https://aipatternbook.com/yagni)). Community “anti-overengineering” rule packs (e.g. [Ponytail](https://openclawapi.org/en/blog/2026-06-21-ponytail-overengineering-fix)) exist because models default to *more code*. CoB’s UI brief already bans most of the juice OS — do not reintroduce it as a research-driven platform.

### How it shows up here

- Permanent `OnUpdate` for decorative motion
- Center-screen WA-style promotion pulses (explicit anti-pattern)
- Custom `Media/`, Masque, SharedMedia, ripped Blizzard audio
- Timing-curve recipe libraries applied to every tab switch
- Rank-colored rainbow chrome; glass/low-alpha panels; standing-as-castbar
- Settings sprawl (strata, scale, per-event announce filters) beyond locked budget

### Cut rule

| V1 juice allowance | Reality |
|--------------------|---------|
| Guild chat line | **Keep** — primary spectacle |
| Private edge toast (short Alpha / show-hide) | **Keep** — fail-soft, no business logic in OnUpdate |
| Tab / panel open feel | Optional one-shot fade; stock templates preferred |
| Everything else | **Post-V1 art / spectacle pass** |

If juice needs a “system,” it is already too big for V1.

---

## Kill-list (do not build / do not run for V1 ship)

Cut these even if a research note or canvas makes them sound inevitable:

1. **Unbounded Writer↔Critic polish loops** (no max rounds, no checklist stop)
2. **≥3-agent adversarial debate / 50-agent swarms** on UI or “feel”
3. **Best-of-N visual variants** racing locked Classic shell doctrine
4. **Juice framework / tween bus / intensity matrices / particle seals**
5. **Custom `Media/`, commissioned heraldry, SFX packs** during Task 7–10
6. **WA center pulses, screen flash, camera shake, chat-frame hijack animations**
7. **Standing hero StatusBar / meter-dashboard chrome** (text thresholds only)
8. **Streamer Mode code, tip jars, SecureActionButton panel openers**
9. **AceAddon / Masque / SharedMedia hard deps; Retail-only templates**
10. **Permanent `OnUpdate` for scoring, net, or decoration**
11. **Settings beyond** position + minimap hide + announce opt-out
12. **Promoting research process notes to product law** without §15
13. **Overnight unattended UI loops** without client smoke
14. **Agent keystrokes / process control of the WoW client**
15. **Desktop “quality harness” scores** as substitute for `/reload` + guild-night criterion 11
16. **Parallel polish agents** rewriting the same `UI/*.lua` without a single owner
17. **Re-opening deferred V2 theater** (confessions feed, ceremonial dashboard) as “polish”
18. **Tooling binge** from `OPTIMIZATIONS.md` backlog without human approval (hooks, packager upload, stub empires)
19. **Critique that invents hex / copy / thresholds** instead of escalating
20. **Claiming V1 complete** from green harness or unanimous agent aesthetic vote

---

## Keep-list (protect shipping)

Keep only what moves locked success criteria or prevents known failure modes:

1. **`docs/phases/v1-checklist.md`** as the done bar — walk and date boxes
2. **`lua tests/run.lua` exit 0** when Core/Data/harness change
3. **TOC truth** + `## Interface: 20506`
4. **Install → `scriptErrors 1` → `/reload` → `/beef`** for UI/Net/SV/slash
5. **Two-client Officer+ / Member** for BeefNet commit + login sync
6. **Forged `RANK_COMMIT` rejection** (checklist §9)
7. **Throttled officer `/g` announce** + per-officer opt-out (default ON)
8. **Private edge toast** — short, non-center, no SFX required
9. **Lua `CreateFrame` + Classic FrameXML templates**; pool rows
10. **Layer law:** UI→Core→Data; UI never awards; Net never invents ranks; Core never `CreateFrame`
11. **`Data/Ranks.lua` as sole numeric canon**; lore docs stay number-free
12. **UI brief anti-patterns** as a short reject list (not a design studio)
13. **Thin polish loop from doc 29** — implement → mechanical verify → ≤2 critique → ledger — **caps enforced by this note**
14. **One optional adversarial review** on Core/Net/safety diffs (high-confidence bugs only)
15. **BugGrabber + BugSack** on test accounts
16. **Silent fail-soft** for missing media (vacuous in V1; keep the habit)
17. **Settings budget:** position, minimap, announce only
18. **Human guild-night social check** (criterion 11) — cannot be agent-swarmed away
19. **Escalate product ambiguity** to spec §15 / glossary — do not fork in research
20. **Ship Classic-looking process UI** that officers can Commit with; art pass later

---

## Decision tree (when an agent proposes “more polish”)

```text
Does this change tick or unblock a v1-checklist.md row?
├─ NO  → Is it a Critical/Important bug (taint, wrong rank, BeefNet forge, script error)?
│        ├─ YES → Fix with thin loop (verify in client)
│        └─ NO  → PARK / kill (post-V1 or reject)
└─ YES → Implement smallest slice → mechanical verify → optional 1 critique
         → stop at checklist evidence (not at critic boredom)
```

---

## Counter-arguments (and why they lose for V1)

| Claim | Rebuttal |
|-------|----------|
| “More agents find more bugs” | Diminishing returns; CoB’s killer bugs need **two clients**, not more reviewers of the same diff |
| “Juice makes promotions feel real” | Spec already chose **guild chat** as the cheap spectacle; juice frameworks compete with Commit/sync time |
| “Polish loops are industry best practice” | Best practice includes **stop conditions**; CoB’s stops are checklist + §15, not aesthetic convergence |
| “Research tracks imply we must implement them” | Tracks are depth-on-dispute; doctrine says scrapes ≠ law |
| “We’ll go faster in parallel” | Parallel UI authors thrash TOC, pools, and frame ownership; serialize polish, parallelize only research |

---

## Relationship to other notes

| Doc | Use |
|-----|-----|
| [29-superpowers-loop-patterns.md](./29-superpowers-loop-patterns.md) | Adopt thin spine; this note is the **governor** (caps + kill-list) |
| [14-celebration-spectacle-design.md](./14-celebration-spectacle-design.md) | Prefer announce+toast; reject WA-scale celebration |
| [16-timing-curves-recipes.md](./16-timing-curves-recipes.md) | Optional seasoning for allowed fades — not a platform |
| [02-lua-vs-xml-frames.md](./02-lua-vs-xml-frames.md) | Frame tech; still no juice OS |
| UI brief | Non-negotiable V1 bans |

---

## Community failure modes (Cursor forum / Reddit)

These are **process caution** stories — not CoB product requirements:

1. **Endless review / diagnostic loops** — agent never exits polish/review ([forum](https://forum.cursor.com/t/cursor-agent-enters-endless-loop-without-progressing-past-review-step/126815); [diagnostic loop](https://forum.cursor.com/t/cursor-ai-agent-gets-stuck-in-diagnostic-loop-instead-of-completing-tasks/161838)).
2. **Spend spikes from stuck agents** — users report four-figure burns on looping agents ([r/cursor](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/); related [repeating loop](https://www.reddit.com/r/cursor/comments/1qh4tbf/agent_recently_getting_thrown_into_repeating/)).
3. **Loop-engineering fashion** — long threads on autonomous orchestration ([forum loop engineering](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283); [more autonomous](https://forum.cursor.com/t/loop-engineering-more-autonomous-development/163082); [native auto-critique request](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)) — steal *stop conditions*, not the factory.
4. **Ralph without client gates** — useful for harness-green Core; toxic for UI spectacle ([forum Ralph](https://forum.cursor.com/t/ralph-cursor-guide/149998); [ghuntley](https://ghuntley.com/ralph/); Reddit skepticism that Ralph is always needed once subagents exist: [r/ClaudeCode](https://www.reddit.com/r/ClaudeCode/comments/1r5ticb/cmv_ralph_loops_are_no_longer_needed_with/)).

**CoB translation:** prefer checklist + `church-of-beef-dev` evidence over fashion loops; never unattended UI Ralph overnight.

---

## What “enough polish process” looks like (minimum factory)

| Layer | Keep | Reject |
|-------|------|--------|
| Goal | One slice + acceptance ([21](./21-cursor-agent-loops-goals.md), [30](./30-writing-effective-agent-goals.md)) | “Make it premium” |
| Implement | One owner agent | Best-of-N visual races on locked chrome |
| Verify | Harness / TOC / `/reload` | Desktop mock as truth |
| Critique | ≤2 rounds, ≤5 findings ([31](./31-loop-stop-conditions.md), [27](./27-multi-agent-adversarial-review.md)) | Meta-debate rounds on toast |
| Stop | Checklist / plateau / cap ([31](./31-loop-stop-conditions.md)) | Critic boredom |
| Human | Guild-night criterion 11 | Agent aesthetic vote |

Optional future skill ([37](./37-skill-draft-polish-loop.md)) and rules proposal ([34](./34-cursor-rules-polish-proposal.md)) must stay **thin** — this note is the governor if either fattens.

---

## External sources

> Research ≠ product law. Cite for process caution only; locked UI/announce/rank decisions stay in the design spec + glossary + `Data/Ranks.lua`.

**Cursor official / blog**

- [Best practices for coding with agents](https://cursor.com/blog/agent-best-practices) (Jan 2026)
- [Hooks](https://cursor.com/docs/hooks.md)
- [Cloud Agent Best Practices](https://cursor.com/docs/cloud-agent/best-practices.md)
- [Rules](https://cursor.com/docs/rules.md) · [Skills](https://cursor.com/docs/skills.md)

**Cursor forum**

- [Ralph Cursor Guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)
- [Agent enters endless loop past review](https://forum.cursor.com/t/cursor-agent-enters-endless-loop-without-progressing-past-review-step/126815)
- [Diagnostic loop instead of completing](https://forum.cursor.com/t/cursor-ai-agent-gets-stuck-in-diagnostic-loop-instead-of-completing-tasks/161838)
- [Loop engineering & orchestration](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283)
- [Loop engineering — more autonomous](https://forum.cursor.com/t/loop-engineering-more-autonomous-development/163082)
- [Native compliance / auto-critique loops (feature request)](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)
- [Skills vs Commands vs Rules](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875)

**Reddit**

- [r/cursor — agent stuck, high spend](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/)
- [r/cursor — repeating loop](https://www.reddit.com/r/cursor/comments/1qh4tbf/agent_recently_getting_thrown_into_repeating/)
- [r/ClaudeCode — Ralph vs subagents](https://www.reddit.com/r/ClaudeCode/comments/1r5ticb/cmv_ralph_loops_are_no_longer_needed_with/)

**GitHub / community tooling**

- [ghuntley — Ralph](https://ghuntley.com/ralph/)
- [alecnielsen/adversarial-review](https://github.com/alecnielsen/adversarial-review)
- [addyosmani/adverse](https://github.com/addyosmani/adverse)
- [ASDLC — Adversarial Code Review](https://asdlc.io/patterns/adversarial-code-review)
- [ClawHub — adversarial-code-review](https://clawhub.ai/reikys/adversarial-code-review)
- [hellotommmy/cursor-loop](https://github.com/hellotommmy/cursor-loop)

**Research / essays (stop & YAGNI)**

- [Semantic Early-Stopping for Iterative LLM Agent Loops (arXiv:2606.27009)](https://arxiv.org/abs/2606.27009) (Jun 2026)
- [Multi-Model Adversarial Code Review](https://agentic-engineers.net/2026/04/22/multi-model-adversarial-code-review.html) (Apr 2026)
- [CrewAI — Agents (`max_iter`)](https://docs.crewai.com/en/concepts/agents)
- [CrewAI community — limit retries](https://community.crewai.com/t/limit-agent-retries/1657)
- [Cursor Hooks on the agent loop (Tiwari)](https://tiwarivikas.in/writing/cursor-hooks-agent-loop) (Apr 2026)
- [YAGNI (Built In)](https://builtin.com/software-engineering-perspectives/yagni)
- [YAGNI × 100 with AI](https://blog.flurdy.com/2026/02/yagni-100-with-ai) (Feb 2026)
- [Agentic coding — YAGNI pattern](https://aipatternbook.com/yagni)
- [Ponytail — curing overengineering](https://openclawapi.org/en/blog/2026-06-21-ponytail-overengineering-fix) (Jun 2026)
- [Elegant Software — Cursor multi-agent](https://www.elegantsoftwaresolutions.com/blog/cursor-multi-agent-not-what-you-think)

**In-repo (local doctrine, not external)**

- `docs/phases/v1-checklist.md`, UI brief, `.cursor/rules/verification.mdc`
- Scrapes: `_search-community-cursor-reddit.json`, `_search-llm-critique-stop.json`, `_search-ralph-wiggum-community.json`

---

## Bottom line

**Kill the factory. Keep the checklist.**  
V1 ships when officers can Commit, peers sync, and guild chat notices — not when the agent swarm achieves consensus on juice.
)
