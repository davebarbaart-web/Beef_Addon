# 29 — Superpowers / Cursor loop patterns for polish

**Lane:** `docs/research/agent-polish-vision/` (agent process research — not product law)  
**Date:** 2026-07-26  
**Sources inspected (local):**

| Skill | Path |
|-------|------|
| Loop (Cursor) | `~/.cursor/skills-cursor/loop/SKILL.md` |
| Babysit (related) | `~/.cursor/skills-cursor/babysit/SKILL.md` |
| Verification before completion | `~/.cursor/plugins/cache/cursor-public/superpowers/.../verification-before-completion/SKILL.md` |
| Brainstorming | `.../brainstorming/SKILL.md` |
| Subagent-driven development | `.../subagent-driven-development/SKILL.md` |
| Executing plans | `.../executing-plans/SKILL.md` |
| Writing plans / finishing branch (adjacent) | same Superpowers plugin tree |

**CoB workspace anchors:** `AGENTS.md`, `.cursor/rules/verification.mdc`, `.cursor/skills/church-of-beef-dev/SKILL.md`, `docs/superpowers/ui-polished-direction-for-agents.md`.  
**Companions:** [21](./21-cursor-agent-loops-goals.md) (Cursor goals/hooks) · [21b](./21b-cursor-loops-source-digest.md) (source digest) · [31](./31-loop-stop-conditions.md) · [37](./37-skill-draft-polish-loop.md) · [49](./49-adversarial-overengineering.md) (governor) · [28](./28-hands-off-cursor-workflows.md).

This note extracts **reusable polish-loop patterns** from those skills. It does **not** change V1 product decisions — research ≠ product law. Scrapes under `_search-*.json` are background only.

---

## 1. Verdict (what to steal)

Polish quality in agent workflows comes from **gated iteration**, not from longer single-pass prompts:

1. **Evidence gate** before any “done / polished / looks good” claim.  
2. **Separate roles** — implement → critique → fix → re-critique (never self-grade as final).  
3. **Durable memory outside chat** — ledger / checklist / git, so compaction does not re-do or skip work.  
4. **Wake-driven cadence** when waiting on client smoke, CI, or human eyes — not busy polling.  
5. **Human gates** only where judgment is product/visual; mechanical gates stay autonomous.

CoB already has half of this (`lua tests/run.lua`, install/reload, UI direction brief). The missing piece for **visual / spectacle polish** is an explicit **implement → critique against checklist → fix → re-verify** loop with a hard stop on false completion.

---

## 2. Pattern catalog

### P1 — Evidence before claims (verification-before-completion)

Aligned with Cursor’s public agent guidance: plan with verifiable goals; review diffs harder as agents go faster ([agent best practices](https://cursor.com/blog/agent-best-practices)); Cloud agents need `AGENTS.md` written for a low-context teammate ([cloud best practices](https://cursor.com/docs/cloud-agent/best-practices.md)).

**Iron law:** no completion, satisfaction, or “passing” language without a **fresh** verification command run in the same turn.

| Claim type | Fresh evidence required |
|------------|-------------------------|
| Tests pass | Full harness output, exit 0 |
| Bug fixed | Symptom re-tested (not “code looks right”) |
| Agent finished | VCS diff + independent check — not subagent self-report |
| Requirements met | Line-by-line checklist vs plan/spec |

**Polish translation:** “UI feels polished” is not a claim. Acceptable claims:

- `lua tests/run.lua` → 0 failed (Core/Data).  
- TOC lists only existing files; Interface `20506`.  
- In-client: `/console scriptErrors 1` → `/reload` → `/beef` exercised; BugSack empty for that path.  
- Checklist rows from `ui-polished-direction-for-agents.md` / visual-polish canvas ticked with observed results.

**Anti-patterns to copy into CoB agent rules:** “should work”, “looks correct”, trusting implementer “DONE” without diff/review, partial lint as proof of client smoke.

---

### P2 — Design → approve → plan → implement (brainstorming)

Hard gate: **no implementation** until a design is presented and approved; then write spec → user reviews → **writing-plans** only.

Loop shape:

```
explore → clarify (1Q at a time) → 2–3 approaches → design sections (approve each)
  → write spec → self-review (placeholders / contradictions / scope / ambiguity)
  → user reviews spec → writing-plans → execute
```

**Polish translation:**

- Visual / IA changes that touch brand or §10/§15: brainstorm/spec gate first (do not “just tweak frames”).  
- Mechanical polish against an already-locked checklist (contrast, tab labels, toast position) can skip full brainstorm — still need evidence gate (P1).  
- Spec self-review checklist maps cleanly to polish-doc hygiene: no TBD thresholds, no forked numbers outside `Data/Ranks.lua`.

---

### P3 — Implement → task review → fix → re-review (subagent-driven-development)

Core loop per task:

```
fresh implementer → (questions?) → implement + test + self-review + commit
  → review package (diff file) → task reviewer (spec ✅ + quality ✅)
  → if Critical/Important: fix subagent → re-review
  → ledger: Task N complete
→ … next task …
→ whole-branch review → finishing-a-development-branch
```

Patterns worth keeping for polish:

| Pattern | Why it polishes |
|---------|-----------------|
| Fresh subagent per task | Avoids context pollution; “code is memory” |
| Dual verdict (spec + quality) | Spec compliance ≠ craft |
| Diff-as-file handoff | Reviewer sees reality, not narrative |
| Fix then **re-review** | No “fixed, trust me” |
| Progress ledger on disk | Survives compaction; prevents re-dispatch |
| Model tiering | Cheap for mechanical; capable for final branch review |
| Continuous execution | Don’t ask “continue?” between tasks unless blocked |

**Polish translation (UI / spectacle):**

- Implementer: apply one polish slice (e.g. Standing empty states).  
- Reviewer rubric: glossary 74–81 + `ui-polished-direction-for-agents.md` anti-patterns + layer rules (UI never awards points).  
- “⚠️ Cannot verify from diff” (in-client look) → controller must resolve via install/reload smoke, not mark complete from Lua alone.

---

### P4 — Plan checkpoints in a parallel session (executing-plans)

Same spine, human-paced: load plan → critical review → execute tasks with listed verifications → stop on blockers → finishing-a-development-branch.

Use when subagents unavailable or work is tightly coupled. Prefer **subagent-driven-development** when Task tool exists.

**Polish translation:** V1 plan Task 13 (“Final polish pass”) and UI Tasks 7+ should list **offline + in-client** verification steps explicitly so executing-plans cannot skip the client.

---

### P5 — Scheduled / event wake loops (Cursor `loop`)

Community / product surface for the same idea: **stop hooks** that inject `followup_message` until tests/plan say DONE ([Hooks](https://cursor.com/docs/hooks.md); [Cupcake Cursor harness](https://cupcake.eqtylab.io/reference/harnesses/cursor/); [planning-with-files](https://github.com/OthmanAdi/planning-with-files/blob/master/docs/cursor.md); [hellotommmy/cursor-loop](https://github.com/hellotommmy/cursor-loop); [Tiwari](https://tiwarivikas.in/writing/cursor-hooks-agent-loop)). Forum threads on “loop engineering” and long-running agents are fashion signals — steal wake + cap patterns, not unbounded autonomy ([loop engineering](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283); [long-running agents](https://forum.cursor.com/t/share-your-experience-with-long-running-agents/151697); [Ralph guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)).

`/loop [interval] <prompt>` — two modes:

| Mode | Mechanism | Use for polish |
|------|-----------|----------------|
| **Fixed** | Background `sleep` + `AGENT_LOOP_TICK_<purpose>` sentinel + `notify_on_output` | Periodic re-check of CI, or “every 10m remind to smoke `/beef` after human plays” |
| **Dynamic** | Run now; arm watcher (`AGENT_LOOP_WAKE_*`) and/or long heartbeat sleep | Wait for git ref / CI green / log line; then re-run critique prompt |

Rules: unique sentinel, no duplicate loops, run prompt once immediately on arm, track PID to stop, prefer monitored shell over cron.

**Polish translation:**

- Do **not** use fixed loops to hammer `/reload` or invent client automation (safety: no process control of WoW).  
- Valid: loop on **CI** (`lua-tests.yml`), or dynamic wake after human says “smoked Standing tab”.  
- Prompt payload must name the checklist file + evidence commands.

---

### P6 — Merge-ready babysit (related Cursor skill)

Until PR mergeable: conflicts → unresolved comments → CI green; push scoped fixes; re-watch. Do not weaken CI to pass.

**Polish translation:** After polish PR, babysit until harness green + review comments on visual anti-patterns resolved. Spectacle copy nits from humans count as merge blockers if they contradict locked liturgy.

---

### P7 — Bite-sized tasks with built-in test cycles (writing-plans)

Each task ends with an independently testable deliverable; steps are 2–5 minutes; Global Constraints copied verbatim into every task’s implied requirements.

**Polish translation:** Split “make UI pretty” into checklist-backed slices (tab chrome, Standing text thresholds, toast edge placement, announce throttle copy). Each slice names its verify command(s).

---

## 3. Composite “polish loop” (recommended for CoB)

Compose P1 + P3 + CoB ops skill into one **agent polish loop**:

```text
0. Preconditions
   - ADDON_ROOT resolved (church-of-beef-dev §0)
   - Authority order: design spec §10/§15 > glossary 74–81 > Ranks.lua > UI brief > research
   - Worktree / branch (never polish on main without consent)

1. Select slice
   - One checkbox cluster from ui-polished-direction / visual-polish-acceptance-checklist
   - Write acceptance criteria that are observable (reload path, BugSack, expected strings)

2. Implement (fresh context if using subagents)
   - Touch only planned UI/Net surface; no Core→UI inversion; no Retail APIs

3. Mechanical verify (P1 — mandatory)
   - If Core/Data/harness touched: `lua tests/run.lua` exit 0
   - TOC truth + Interface 20506
   - Install → scriptErrors → /reload → exercise slice

4. Critique pass (separate role / subagent)
   - Rubric: UI brief anti-patterns + glossary rows + layer rules
   - Verdicts: spec/checklist ✅ and craft ✅ (or list Critical/Important)

5. Fix → re-verify → re-critique (P3)
   - Loop until both verdicts clean or escalate product ambiguity to human

6. Ledger
   - Append slice complete + evidence pointers (command outputs / BugSack “none”)
   - Do not claim V1 complete until docs/phases/v1-checklist.md walked

7. Optional wake (P5)
   - Only for CI or human-gated smoke — never drive the game client
```

**Stop conditions:** BLOCKED (missing client, unclear §15), max critique iterations (suggest 2–3), or human rejects direction (return to brainstorming P2).

---

## 4. How to wire into Church of Beef

Research stays non-normative until promoted. Suggested wiring ladder (lightest → heaviest):

### 4.1 Immediate (no new files) — agent prompts

When asking for polish work, paste:

- “Use the polish loop in `docs/research/agent-polish-vision/29-superpowers-loop-patterns.md` §3.”  
- “Evidence gate: church-of-beef-dev + verification.mdc; no done without `/reload` smoke if UI touched.”  
- “Critique against `docs/superpowers/ui-polished-direction-for-agents.md` anti-patterns.”

### 4.2 Skill extension (recommended)

Extend `.cursor/skills/church-of-beef-dev/SKILL.md` with a short **§ Polish loop** that:

1. Points here for process patterns.  
2. Reuses existing install/reload checklist as the **Evaluator** (P1/P3).  
3. States: unit tests never prove guild-chat spectacle — product pass remains human/two-client.

Keep policy in `.cursor/rules/`; skill stays operational.

### 4.3 Optional Cursor `/loop` recipes

| Recipe | Prompt gist |
|--------|-------------|
| `/loop` dynamic after CI | On `lua-tests` green, re-run polish critique for open UI diff |
| `/loop 15m` during playtest | Remind: walk visual-polish checklist rows N–M; report gaps only |

Sentinel names: `AGENT_LOOP_TICK_cob_polish`, `AGENT_LOOP_WAKE_cob_ci`.

### 4.4 Plan / SDD integration

- In `docs/superpowers/plans/...`: Task 7+ and Task 13 should require **subagent-driven-development** (or executing-plans) with Global Constraints citing Interface `20506`, no custom Media in V1, UI→Core→Data.  
- Progress ledger path (if adopting SDD): e.g. `.superpowers/sdd/progress.md` under the **addon worktree** (gitignored scratch) — do not put player WTF paths there.  
- Per-task reviewer constraints block: copy glossary 74–81 one-liners + UI brief bans verbatim.

### 4.5 Do not wire

| Temptation | Why not |
|------------|---------|
| Ralph-style overnight loop editing UI without client smoke | Violates evidence gate; spectacle false-greens |
| Loop that sends keystrokes / controls WoW | Forbidden by verification.mdc / safety |
| Promoting this research to product law silently | Update design spec §15 / glossary if process becomes mandatory |
| Critique-only loops that “improve” locked hex/copy without approval | Brand/hex locks are glossary — escalate, don’t invent |

### 4.6 Authority reminder

| Truth | Location |
|-------|----------|
| Product / UI law | `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` |
| Agent UI briefing | `docs/superpowers/ui-polished-direction-for-agents.md` |
| Done / safety | `.cursor/rules/verification.mdc` |
| Install / reload / tests | `.cursor/skills/church-of-beef-dev/SKILL.md` |
| This process note | `docs/research/agent-polish-vision/29-superpowers-loop-patterns.md` (guidance) |

---

## 5. Mapping skills → CoB “Evaluator”

| Superpowers / Cursor role | CoB stand-in |
|---------------------------|--------------|
| Actor / implementer | Agent editing `addon/ChurchOfBeef/UI/*` (worktree) |
| Mechanical evaluator | `lua tests/run.lua`, TOC check, rsync install |
| Client evaluator | `/reload` + `/beef` + BugSack; two clients for BeefNet |
| Spec reviewer | Checklist vs glossary 74–81 + UI brief |
| Craft reviewer | Anti-patterns (WA pulses, rainbow ranks, glass panels, …) |
| Self-reflection memory | Ledger + git commits (not chat history) |
| Completion promise | Checklist rows + v1-checklist — not vibes |

---

## 6. Open questions (for later promotion)

1. Should a dedicated `.cursor/skills/church-of-beef-polish/SKILL.md` exist, or only a section on the dev skill?  
2. Max critique iterations before mandatory human visual pass?  
3. Promote “no UI completion claim without reload smoke” into `verification.mdc` as an always-on rule (likely yes)?  

Until answered, treat §3 as the default agent procedure for polish slices.

---

## 7. Community overlay (Cursor forum / Reddit / GitHub)

| Theme | Steal | Reject for CoB polish |
|-------|-------|------------------------|
| Evidence + plan first | [Cursor blog](https://cursor.com/blog/agent-best-practices); [heyuan110](https://www.heyuan110.com/posts/ai/2026-01-19-cursor-agent-best-practices/); [RockB](https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026/) | Vibes-only “looks good” |
| Stop-hook grind | [Hooks](https://cursor.com/docs/hooks.md); [cursor-loop](https://github.com/hellotommmy/cursor-loop); [grind skill](https://github.com/spencerpauly/awesome-cursor-skills/blob/main/resources/grinding-until-pass/SKILL.md) | Uncapped `followup_message` on UI |
| Ralph | [forum](https://forum.cursor.com/t/ralph-cursor-guide/149998); [ghuntley](https://ghuntley.com/ralph/); [agrimsingh/ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor) | Overnight UI without `/reload` |
| Loop engineering | [forum](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283); [maxmilian/loop-engineering](https://github.com/maxmilian/loop-engineering) | Factory sprawl ([49](./49-adversarial-overengineering.md)) |
| Ask→plan→implement Reddit loop | [r/cursor workflow](https://www.reddit.com/r/cursor/comments/1rnqke6/agentic_coding_workflow_ask_planmd_implement_loop/) | Skipping human for spectacle |
| Auto-critique feature asks | [forum](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556) | Treating critique as product |

**Governor:** if §3 fattens into parallel juice swarms, defer to [49](./49-adversarial-overengineering.md). Stop math lives in [31](./31-loop-stop-conditions.md). Goal anatomy lives in [21](./21-cursor-agent-loops-goals.md) / [30](./30-writing-effective-agent-goals.md).

---

## External sources

> Research ≠ product law. Patterns here stay guidance until promoted into skills/rules with human approval.

**Cursor official**

- [Best practices for coding with agents](https://cursor.com/blog/agent-best-practices) (Jan 2026)
- [Hooks](https://cursor.com/docs/hooks.md)
- [Cloud Agent Best Practices](https://cursor.com/docs/cloud-agent/best-practices.md)
- [Skills](https://cursor.com/docs/skills.md) · [Rules](https://cursor.com/docs/rules.md)
- [Worktrees](https://cursor.com/docs/configuration/worktrees.md)
- [Agent overview](https://cursor.com/docs/agent/overview.md)

**Cursor forum**

- [Ralph Cursor Guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)
- [Loop engineering & orchestration](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283)
- [Loop engineering — more autonomous](https://forum.cursor.com/t/loop-engineering-more-autonomous-development/163082)
- [Share experience with long-running agents](https://forum.cursor.com/t/share-your-experience-with-long-running-agents/151697)
- [Native compliance / auto-critique loops](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)
- [How do hooks work in Cursor CLI?](https://forum.cursor.com/t/how-do-hooks-work-in-cursor-cli/150201)
- [Skills vs Commands vs Rules](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875)
- [Introducing Cursor Automations](https://forum.cursor.com/t/introducing-cursor-automations/153733)

**Reddit / HN**

- [r/cursor — Ask / plan.md / implement loop](https://www.reddit.com/r/cursor/comments/1rnqke6/agentic_coding_workflow_ask_planmd_implement_loop/)
- [r/ClaudeCode — Ralph Wiggum](https://www.reddit.com/r/ClaudeCode/comments/1q91bwp/github_ghuntleyhowtoralphwiggum_the_ralph_wiggum)
- [HN — Ralph Wiggum discussion](https://news.ycombinator.com/item?id=46508290)

**GitHub / community**

- [OthmanAdi/planning-with-files — Cursor](https://github.com/OthmanAdi/planning-with-files/blob/master/docs/cursor.md)
- [hellotommmy/cursor-loop](https://github.com/hellotommmy/cursor-loop)
- [spencerpauly/awesome-cursor-skills — grinding-until-pass](https://github.com/spencerpauly/awesome-cursor-skills/blob/main/resources/grinding-until-pass/SKILL.md)
- [agrimsingh/ralph-wiggum-cursor](https://github.com/agrimsingh/ralph-wiggum-cursor)
- [maxmilian/loop-engineering](https://github.com/maxmilian/loop-engineering)
- [Cupcake — Cursor harness (stop followup)](https://cupcake.eqtylab.io/reference/harnesses/cursor/)
- [ghuntley — Ralph](https://ghuntley.com/ralph/)
- [Tiwari — Cursor Hooks on the agent loop](https://tiwarivikas.in/writing/cursor-hooks-agent-loop)
- [RockB — Cursor Agent Best Practices 2026](https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026/)
- [heyuan110 — Cursor Agent Best Practices](https://www.heyuan110.com/posts/ai/2026-01-19-cursor-agent-best-practices/)
- [danielsinewe/ralph-cursor](https://github.com/danielsinewe/ralph-cursor)
- [Just-Agent Oh-Reflective-loop cursor-loop skill](https://github.com/Just-Agent/Oh-Reflective-loop-skills/blob/main/cursor-loop/SKILL.md)
- [Releasebot — Cursor updates](https://releasebot.io/updates/cursor)
- [imhurt/cursor-lab — subagents and hooks](https://github.com/imhurt/cursor-lab-materials/blob/main/docs/5-subagents-and-hooks.md)
- [21b source digest](./21b-cursor-loops-source-digest.md) (full annotated set)

**Local skills inspected (not URLs)**

- Cursor `loop`, `babysit`; Superpowers `verification-before-completion`, `brainstorming`, `subagent-driven-development`, `executing-plans`, `writing-plans`

**In-repo scrapes**

- `_search-cursor-loops-docs.json`, `_search-cursor-loops-community.json`, `_search-ralph-wiggum-community.json`, `_search-hands-off-cursor.json`
