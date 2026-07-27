# 37 — Skill draft: Church of Beef polish loop

**Status:** Research draft only — **not installed** under `.cursor/skills/`.  
**Audience:** Maintainers deciding whether to promote this to a project skill.  
**Companion ops skill (already installed):** [`.cursor/skills/church-of-beef-dev/SKILL.md`](../../../.cursor/skills/church-of-beef-dev/SKILL.md)  
**Patterns drawn from:** Cursor `create-skill`, Cursor `loop`, Reflexion / writer→critic loops, Ralph-style iteration with hard stop caps, CoB UI authority pack.  
**Companions:** [29](./29-superpowers-loop-patterns.md) · [31](./31-loop-stop-conditions.md) · [21](./21-cursor-agent-loops-goals.md) · [21b](./21b-cursor-loops-source-digest.md) · [34](./34-cursor-rules-polish-proposal.md) · [49](./49-adversarial-overengineering.md) · [28](./28-hands-off-cursor-workflows.md).

**Proposed install path (later, human approval):**

```
.cursor/skills/church-of-beef-polish-loop/SKILL.md
```

Do **not** copy there until a human accepts this draft. Keep edits in this research file until then.  
**Authority reminder:** this draft is research — **not** product law. Spec §15 / glossary / UI brief win on conflict.

---

## Ready-to-install `SKILL.md` (copy below the line)

```markdown
---
name: church-of-beef-polish-loop
description: >-
  Run an iterative polish loop on Church of Beef UI, copy, toasts, officer
  chrome, or guild spectacle. Use when the user asks to polish, juice, critique
  loop, visual QA, acceptance-checklist pass, tighten microcopy, fix taint/UX
  footguns, or refine /beef frames after a green harness. Complements
  church-of-beef-dev (install/reload/test). Before CreateFrame or visual edits,
  read docs/superpowers/ui-polished-direction-for-agents.md. Stop on rubric
  pass, max iterations, or thrash — never invent product law from research.
---

# Church of Beef — polish loop

Iterative **make → verify → critique → refine** for social UI juice.  
Policy stays in `.cursor/rules/` + design spec; install/reload ops stay in
**church-of-beef-dev**. This skill is the *quality loop*, not a second packaging
bible.

## When to use / when not to

| Use this | Use church-of-beef-dev instead | Stop and ask human |
|----------|--------------------------------|--------------------|
| Polish existing UI/copy/toast/announce feel | First-time install path unknown | Spec vs glossary conflict |
| Critique pass after Task 7+ UI lands | Need `lua tests/run.lua` only | Want custom `Media/` / SFX in V1 |
| Tighten Standing/Ladder/Officer chrome | Slash/bootstrap smoke only | Product threshold / rank title change |
| Taint/lockdown UX hardening for juice | Zip / AddOns copy only | Claim “V1 complete” |

Green harness ≠ polish done. In-client Anniversary smoke is visual truth.

## 0. Preconditions

1. Workspace root = `Beef_Addon` (so `.cursor/rules` apply).
2. Resolve `ADDON_ROOT` exactly as **church-of-beef-dev** §0 (`tests/run.lua` present).
3. Read authority **before** any polish edit (do not invert):

| Order | Source |
|------:|--------|
| 1 | `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` §10 / §15 |
| 2 | Glossary rows 68–71, **74–81** (`docs/research/wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md`) |
| 3 | `addon/ChurchOfBeef/Data/Ranks.lua` for titles/thresholds only |
| 4 | `docs/superpowers/ui-polished-direction-for-agents.md` |
| 5 | Canvas `cob-v1-ui-build-prep` / `visual-polish-acceptance-checklist` when present |
| 6 | Depth tracks under `docs/research/agent-polish-vision/` + `wow-classic-addon-design/` only if disputed |

If canvas and spec disagree → **spec wins**. Log new product choices in spec §15; never fork law into research or UI Lua comments alone.

## 1. Scope one polish slice

Pick **one** surface per loop run (or per iteration). Examples:

- Ladder tab layout / contrast / empty states
- My Standing text thresholds + microcopy
- Officer Commit confirm / pending dual-encode
- Edge toast + `/g` announce throttle feel
- Settings budget (position / minimap / announce only)
- Combat-open + taint hygiene for the above

Write the slice in one line and keep it visible each iteration:

```
POLISH_SLICE: <surface> — <observable outcome>
MAX_ITERS: 3
```

Default `MAX_ITERS = 3` (hard cap 5). Prefer small diffs over redesign.

## 2. Acceptance rubric (pass / fail)

Score the slice against this checklist. **Must-pass** items block “done”.

### Must-pass (V1)

```
- [ ] Classic FrameXML templates; opaque high-contrast panels; GameFont*
- [ ] Class color on names only; pending/approve/reject dual-encoded (not color-only)
- [ ] Standing = text thresholds only (no hero StatusBar / HP bar)
- [ ] Spectacle = throttled guild line + private edge toast; no center-screen WA pulse
- [ ] Settings budget unchanged unless slice is settings: position, minimap, announce
- [ ] Silent (no SFX); no new custom Media/ for Tasks 7–10
- [ ] UI → Core → Data; UI never awards points; Core never CreateFrame
- [ ] No SecureActionButton / ShowUIPanel / EasyMenu / Retail-only APIs
- [ ] Guest on player uiScale — never set uiScale / UIParent:SetScale
- [ ] TOC lists only existing files; Interface 20506 unless intentional bump
- [ ] No bots, injection, protected-action bypass, or gameplay automation
```

### Slice-pass (pick relevant)

```
- [ ] Empty / loading / not-in-guild states readable (no blank mystery panel)
- [ ] Microcopy matches CoB tone; no tip jars / donation CTAs
- [ ] Officer tab gated; roster-not-ready soft state OK
- [ ] Announce opt-out honored; officer send-once (no duplicate spam)
- [ ] Toast does not steal focus / block bags; parented under Beef root
- [ ] Mid-combat open /reload path: no sticky taint on Blizzard UI
```

### Explicit anti-patterns (auto-fail)

WA center pulses · Details!-dense rosters · item-quality rainbow ranks ·
ElvUI-flat-as-brand · glass/low-alpha panels · standing-as-castbar ·
forking thresholds into copy docs · Secure* “just to open the panel”

## 3. Loop body (each iteration)

```
for iter = 1 .. MAX_ITERS do
  1. Critique   — rubric + diff vs POLISH_SLICE (see §4)
  2. Plan       — ≤3 concrete code edits; no architecture tourism
  3. Implement  — smallest change that addresses top fail
  4. Offline    — if Core/Data/harness touched: lua tests/run.lua → 0
  5. Install    — church-of-beef-dev §2 (WOW_ADDONS_DIR rsync)
  6. Smoke      — church-of-beef-dev §3 (/console scriptErrors 1, /reload, /beef)
  7. Re-score   — tick rubric; record PASS / FAIL + one-line note
  8. Stop?      — see §5
end
```

**Human-in-the-loop smoke:** if the agent cannot drive the client, ask the user
to run the smoke steps and paste errors / screenshots, then continue from
Critique. Optional: use Cursor **loop** skill to wait on a wake (“user replied”
or a file drop) — do **not** busy-spin shell sleep without a purpose.

### Per-iteration log (keep short)

```
### Polish iter N/MAX
Slice: …
Changed: <files>
Offline: skipped | pass | fail (detail)
Client smoke: pending | pass | fail (detail)
Rubric: M must-pass left; top issue: …
Decision: continue | stop-pass | stop-cap | stop-thrash | escalate
```

## 4. Critique protocol

Do **not** grade your own homework with vibes only.

1. **Rubric-first:** walk Must-pass, then Slice-pass, then Anti-patterns.
2. **Authority diff:** any edit that changes rank numbers, announce policy,
   settings budget, or spectacle shape → stop; that is a spec change, not polish.
3. **Adversarial pass (preferred when slice is juicy):**
   - Builder = this session’s implementer notes
   - Critic = fresh read of changed files + UI brief bans (or a separate
     review subagent / second model if available)
   - Keep ≤5 findings; drop nitpicks; confidence + severity required
4. **Verbal reflection (Reflexion-style):** one paragraph max — what failed,
   what to try next, what not to retry. Bound memory to last 1–3 reflections
   so context does not rot.
5. **Research depth:** open `docs/research/agent-polish-vision/` tracks
   (e.g. taint `03`, settings `08`) only for disputed mechanics — scrapes and
   `_search-*.json` are not product truth.

Critique output template:

```
VERDICT: fail | pass | escalate
MUST_FAIL: <ids or none>
FIX_NEXT: <single actionable change>
DO_NOT: <retry that already failed / out-of-scope temptation>
```

## 5. Stop criteria (priority order)

Halt the loop when the first matching rule fires:

| Priority | Condition | Agent action |
|--------:|-----------|--------------|
| 1 | Must-pass all green **and** slice outcome observed (or user confirms smoke) | `stop-pass` — summarize evidence |
| 2 | Spec/glossary/law conflict or missing product decision | `escalate` — no silent fork |
| 3 | Same fix failed twice / file thrash / oscillating edits | `stop-thrash` — report blocker |
| 4 | `iter == MAX_ITERS` with remaining fails | `stop-cap` — list residual debt |
| 5 | User says stop / pause | stop immediately |

**Semantic early-stop:** if two consecutive iterations change only comments,
spacing, or equivalent copy churn with no rubric movement → `stop-thrash`.

Never claim V1 complete from a polish loop. Never delete
`WTF/**/ChurchOfBeefDB.lua` unless the user explicitly asks.

## 6. Verification gates (evidence before “done”)

| Claim | Required evidence |
|-------|-------------------|
| Offline OK | Fresh `lua tests/run.lua` exit 0 this iteration (when applicable) |
| Installed | rsync/copy into `$WOW_ADDONS_DIR/ChurchOfBeef` |
| UI smoke OK | `/reload` + `/beef` with `scriptErrors` 1; note BugSack if present |
| Net/officer OK | Two-client note when announce/Commit/sync touched |
| Polish OK | Rubric ticks + what was seen in client (or user attestation) |

No completion language without the matching evidence in the same turn.

## 7. Optional timed wait (Cursor loop)

When blocked on in-game human feedback:

1. Ask for the exact smoke steps + what to report back.
2. If the user wants a recurring nudge, use the **loop** skill
   (`/loop 10m …`) with a unique sentinel — do not invent a second scheduler.
3. On wake: read latest user notes → Critique → continue or stop.
4. On user stop: kill loop PID; do not re-arm.

Polish loops are usually **interactive**, not AFK Ralph overnight — CoB visual
truth needs the Anniversary client.

## 8. Checklist (copy and tick)

```
- [ ] POLISH_SLICE + MAX_ITERS declared
- [ ] Authority pack read (spec §10/§15, glossary 74–81, UI brief)
- [ ] Iteration log started
- [ ] Each iter: critique → tiny fix → offline (if needed) → install → smoke
- [ ] Stop reason recorded (pass | cap | thrash | escalate)
- [ ] Residual debt listed (if any) — no fake “done”
- [ ] No Media/SFX/Retail APIs/Secure panel hacks introduced
- [ ] Product law unchanged (or escalated, not sneaked)
```

## Do not duplicate

| Concern | Lives in |
|---------|----------|
| Install / rsync / `/reload` / zip | `church-of-beef-dev` |
| Layer / taint / packaging / canon numbers | `.cursor/rules/` |
| Rank thresholds / titles | `Data/Ranks.lua` |
| Product decisions | design spec §15 |
| Tooling backlog | `OPTIMIZATIONS.md` (needs approval) |
| Research scrapes | `docs/research/**` — guidance only |

## Promotion note (maintainers)

When installing: drop only the fenced `SKILL.md` body into
`.cursor/skills/church-of-beef-polish-loop/SKILL.md`. Optionally add
`reference.md` linking acceptance canvases — keep SKILL.md under 500 lines.
```

---

## Design rationale (research — not part of installed skill)

### Why a separate skill from `church-of-beef-dev`

| Skill | Job |
|-------|-----|
| `church-of-beef-dev` | Resolve checkout → test → install → smoke |
| `church-of-beef-polish-loop` | Bound critique/refine cycles against UI law + stop rules |

Ops without critique ships “works” without “feels like CoB”. Critique without
ops invents polish on disk the client never loads.

Cursor’s own model: **Rules = always/on-glob policy; Skills = deep how-tos loaded on match; Hooks = mechanical gates** ([Skills docs](https://cursor.com/docs/skills.md); [Rules docs](https://cursor.com/docs/rules.md); forum taxonomy threads [skills vs commands vs rules](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875), [rules vs skills vs commands vs hooks](https://forum.cursor.com/t/rules-vs-skills-vs-commands-vs-hooks/151829)). Polish procedure is a *workflow* → **skill**, not another always-on encyclopedia (token hygiene: [Cloud best practices](https://cursor.com/docs/cloud-agent/best-practices.md); community guides [RockB 2026](https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026/), [heyuan110](https://www.heyuan110.com/posts/ai/2026-01-19-cursor-agent-best-practices/)).

### Why not put the whole loop in `.cursor/rules/`

| Put in rules ([34](./34-cursor-rules-polish-proposal.md)) | Put in this skill |
|----------------------------------------------------------|-------------------|
| Thin always-on: major leap + self-critique gate | Full rubric + iteration log templates |
| File-scoped juice bans on `UI/**` | Smoke hand-off to `church-of-beef-dev` |
| Stop caps as policy one-liners | `MAX_ITERS`, thrash heuristics, critique templates |

Forum consensus: agents sometimes **ignore** skills if descriptions are weak or rules already overflow context ([agent ignores skill](https://forum.cursor.com/t/agent-ignores-skill/149017); [r/cursor skills vs commands](https://www.reddit.com/r/cursor/comments/1qn4spg/whats_the_difference_between_skills_and_commands/)). Keep the skill description trigger-rich (polish / juice / critique loop / visual QA) and the body under ~500 lines per Cursor create-skill guidance.

### Loop pattern choices (sourced)

| Choice | Why | Sources |
|--------|-----|---------|
| Writer → critic → refine + hard `MAX_ITERS` | Reflexion / Self-Refine; avoid unbounded burn | [Reflexion](https://arxiv.org/abs/2303.11366); [Self-Refine](https://arxiv.org/abs/2303.17651); [loop & critique](https://tuts.localm.dev/agent-design-patterns/loop-and-critique) |
| Rubric-first stop | LLMs self-grade poorly; constitution beats vibes | [Constitutional AI](https://arxiv.org/abs/2212.08073); [MT-Bench judge issues](https://tailoredai.substack.com/p/judging-llm-as-a-judge-with-mt-bench) |
| Thrash / plateau → stop | Semantic early-stop without embedding infra | [arXiv:2606.27009](https://arxiv.org/abs/2606.27009); [31](./31-loop-stop-conditions.md) |
| No overnight Ralph by default | UI truth needs Anniversary client; Ralph needs completion promise + max iter | [ghuntley/ralph](https://ghuntley.com/ralph/); [forum Ralph](https://forum.cursor.com/t/ralph-cursor-guide/149998); [49](./49-adversarial-overengineering.md) |
| Cursor `/loop` only for human/CI wakes | Fixed ticks ≠ drive WoW; sentinel wakes OK | Local `loop` skill; [Hooks](https://cursor.com/docs/hooks.md); [21](./21-cursor-agent-loops-goals.md) |
| Adversarial optional, ≤5 findings | Precision over nit spam | [Agentic Engineers review](https://agentic-engineers.net/2026/04/22/multi-model-adversarial-code-review.html); [27](./27-multi-agent-adversarial-review.md) |
| Evidence before “done” | Superpowers / Cursor iron law | [verification-before-completion](https://cursor.com/blog/agent-best-practices); [29](./29-superpowers-loop-patterns.md) P1 |

### Authoring checklist (when promoting)

From Cursor create-skill / community skill packs ([awesome-cursor-skills grind skill](https://github.com/spencerpauly/awesome-cursor-skills/blob/main/resources/grinding-until-pass/SKILL.md); [ibuildwith.ai rules/skills/commands](https://www.ibuildwith.ai/blog/cursor-rules-skills-and-commands-oh-my-when-to-use-each/)):

1. YAML `name` + trigger-rich `description` (when to use / when not).  
2. Point at authority files; do not paste the entire UI brief.  
3. Optional `reference.md` for canvases — keep `SKILL.md` lean.  
4. Prefer progressive disclosure: must-pass checklist first, deep research links last.  
5. After install: smoke that `/church-of-beef-polish-loop` (or description match) loads; confirm agent still reads UI brief before `CreateFrame`.

### Open questions before install

1. Default `MAX_ITERS` 3 vs 5 for larger surfaces (Officer tab)?
2. Require BugGrabber + BugSack mention as hard vs soft?
3. Should promotion also add a one-page `reference.md` that only links canvases
   + `agent-polish-vision/03` + `08`?
4. Auto-invoke from description triggers, or
   `disable-model-invocation: true` until the loop is battle-tested?
5. Install skill **before** or **after** rules proposal [34](./34-cursor-rules-polish-proposal.md)? (Recommend: thin rules first, skill second.)

### Suggested commit message when promoting (do not commit from this draft)

```
docs(skills): add church-of-beef-polish-loop skill

Bound UI juice iterations with rubric, smoke gates, and stop rules.
```

---

## External sources

> Research ≠ product law. Do not install this skill or treat its rubric as overriding glossary locks without human approval.

**Cursor official**

- [Skills](https://cursor.com/docs/skills.md)
- [Rules](https://cursor.com/docs/rules.md)
- [Hooks](https://cursor.com/docs/hooks.md)
- [Best practices for coding with agents](https://cursor.com/blog/agent-best-practices) (Jan 2026)
- [Cloud Agent Best Practices](https://cursor.com/docs/cloud-agent/best-practices.md)

**Cursor forum / Reddit**

- [Skills vs Commands vs Rules](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875) (Jan 2026)
- [Rules vs Skills vs Commands vs Hooks](https://forum.cursor.com/t/rules-vs-skills-vs-commands-vs-hooks/151829) (Mar 2026)
- [What is the difference between skills and rules?](https://forum.cursor.com/t/what-is-the-difference-between-skills-and-rules/149765)
- [Agent ignores skill](https://forum.cursor.com/t/agent-ignores-skill/149017)
- [Ralph Cursor Guide](https://forum.cursor.com/t/ralph-cursor-guide/149998)
- [Native compliance / auto-critique loops](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)
- [r/cursor — Skills vs Commands](https://www.reddit.com/r/cursor/comments/1qn4spg/whats_the_difference_between_skills_and_commands/)

**GitHub / community guides**

- [spencerpauly/awesome-cursor-skills — grinding-until-pass](https://github.com/spencerpauly/awesome-cursor-skills/blob/main/resources/grinding-until-pass/SKILL.md)
- [Just-Agent Oh-Reflective-loop cursor-loop skill](https://github.com/Just-Agent/Oh-Reflective-loop-skills/blob/main/cursor-loop/SKILL.md)
- [hellotommmy/cursor-loop](https://github.com/hellotommmy/cursor-loop)
- [ibuildwith.ai — Rules, Skills, Commands](https://www.ibuildwith.ai/blog/cursor-rules-skills-and-commands-oh-my-when-to-use-each/)
- [RockB — Cursor Agent Best Practices 2026](https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026/)
- [heyuan110 — Cursor Agent Best Practices](https://www.heyuan110.com/posts/ai/2026-01-19-cursor-agent-best-practices/) (Jan 2026)
- [ghuntley — Ralph](https://ghuntley.com/ralph/)

**Loop / critique research**

- [Reflexion (arXiv:2303.11366)](https://arxiv.org/abs/2303.11366)
- [Self-Refine (arXiv:2303.17651)](https://arxiv.org/abs/2303.17651)
- [Constitutional AI (arXiv:2212.08073)](https://arxiv.org/abs/2212.08073)
- [Semantic Early-Stopping (arXiv:2606.27009)](https://arxiv.org/abs/2606.27009)
- [Loop & Critique pattern](https://tuts.localm.dev/agent-design-patterns/loop-and-critique)
- [Judging LLM-as-a-Judge (summary)](https://tailoredai.substack.com/p/judging-llm-as-a-judge-with-mt-bench)
- [Multi-Model Adversarial Code Review](https://agentic-engineers.net/2026/04/22/multi-model-adversarial-code-review.html)

**In-repo**

- `.cursor/skills/church-of-beef-dev/SKILL.md` (ops companion)
- Local Cursor skills: `create-skill`, `loop` (authoring / wake patterns)
- Scrapes: `_search-cursor-review-skills.json`, `_search-community-cursor-agent.json`, `_search-reflexion-cai-selfrefine.json`
