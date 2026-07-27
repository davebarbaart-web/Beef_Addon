# 34 — Cursor rules proposal: polish loops, juice, major leaps, self-critique

**Audience:** Maintainers deciding whether to install new `.cursor/rules/*.mdc` files.  
**Status:** Research proposal — **not installed**. Do **not** overwrite `.cursor/rules/` until a human approves.  
**Date:** 2026-07-26  
**Companion tracks (same folder, may land in parallel):** [31](./31-loop-stop-conditions.md), [36](./36-cob-rules-skills-gap-audit.md), [37](./37-skill-draft-polish-loop.md), [38](./38-juice-spectacle-roadmap.md), [39](./39-ui-direction-standards-expansion.md), [40](./40-major-leaps-dev-standards.md), [21](./21-cursor-agent-loops-goals.md), [49](./49-adversarial-overengineering.md).  
**Hooks / loop bibliography:** [21](./21-cursor-agent-loops-goals.md) · [21b](./21b-cursor-loops-source-digest.md) · [28](./28-hands-off-cursor-workflows.md).  

**Authority on conflict:** design spec §10 / §15 → glossary 74–81 → `docs/superpowers/ui-polished-direction-for-agents.md` → existing always-on rules → this proposal.  
**Research ≠ product law** — installing these rules does not change announce policy, ranks, or Interface `20506`.

---

## 1. Why new rules

Community taxonomy (official + forum): **Rules** = short persistent policy; **Skills** = deep workflows; **Hooks** = mechanical allow/deny/followup; **Commands** = user-invoked prompts ([Rules](https://cursor.com/docs/rules.md); [Skills](https://cursor.com/docs/skills.md); [Hooks](https://cursor.com/docs/hooks.md); [forum: skills vs commands vs rules](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875); [forum: rules vs skills vs commands vs hooks](https://forum.cursor.com/t/rules-vs-skills-vs-commands-vs-hooks/151829); [r/cursor skills vs commands](https://www.reddit.com/r/cursor/comments/1qn4spg/whats_the_difference_between_skills_and_commands/)).

Today’s `.cursor/rules/` encode **architecture, verification, layers, and Classic safety** well. They do **not** encode:

| Gap | Symptom today |
|-----|----------------|
| Polish loops | Agents ship one pass and call it done; no critique → revise → stop algorithm |
| Juice standards | UI direction lives in a markdown brief; rule picker never surfaces celebration/toast/motion bans during `UI/**` edits |
| Major leaps per prompt | Agents nibble (one file, one checkbox) instead of packing a verifiable vertical slice |
| Self-critique | `verification.mdc` checks harness/smoke; nothing forces adversarial self-review of feel, copy, or spectacle |

**Design constraint from `OPTIMIZATIONS.md`:** keep always-on rules few (currently 2). New always-on rules must stay thin; heavy juice detail is file-scoped.

**Why thin matters (external):** Cloud / agent best practices warn that bloated always-apply context starves codebase retrieval ([Cloud best practices](https://cursor.com/docs/cloud-agent/best-practices.md); [RockB token hygiene](https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026/); [heyuan110](https://www.heyuan110.com/posts/ai/2026-01-19-cursor-agent-best-practices/); [PromptHub rules roundup](https://www.prompthub.us/blog/top-cursor-rules-for-coding-agents)). Community “I spent too long on Cursor rules” posts converge on: small always-on core + glob/intelligent rules + skills for procedures ([r/cursor rules journey](https://www.reddit.com/r/cursor/comments/1r6bfdh/i_spent_way_too_long_figuring_out_cursor_rules/); [forum rules ↔ skills ↔ agent](https://forum.cursor.com/t/rules-f-project-skills-f-agent/148212); [blink.new rules guide](https://blink.new/blog/cursor-rules-guide)).

**Anti-pattern this proposal refuses:** dumping the entire UI brief into `alwaysApply: true` (see [49](./49-adversarial-overengineering.md) — process factory tax).

---

## 1b. Mapping proposal → Cursor primitives

| Concern | Proposed vehicle | Why |
|---------|------------------|-----|
| Vertical-slice packing | `major-leaps-per-prompt.mdc` always-on | Cheap behavioral nudge every turn |
| Critique before “done” | `agent-self-critique.mdc` always-on | Complements `verification.mdc` evidence |
| Full polish algorithm | `agent-polish-loop.mdc` picker **or** skill [37](./37-skill-draft-polish-loop.md) | Too long for always-on |
| Juice bans / celebration tiers | `ui-juice-standards.mdc` globs on `UI/**` | Load only when editing frames |
| Install/reload commands | Keep in `church-of-beef-dev` skill | Ops ≠ policy ([forum taxonomy](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875)) |
| Unattended grind | Optional future **hooks** (`OPTIMIZATIONS.md`) | Not rules text ([Hooks](https://cursor.com/docs/hooks.md); [21](./21-cursor-agent-loops-goals.md)) |

If skill [37](./37-skill-draft-polish-loop.md) lands, prefer **overlapping lightly**: rules = stop/critique *policy*; skill = iteration log + rubric templates. Do not duplicate 400 lines in both.

---

## 2. Inventory of existing rules (touch / leave)

| File | `alwaysApply` / globs | Action |
|------|----------------------|--------|
| `architecture-overview.mdc` | always | **Patch** — one line pointing at polish rules + UI brief |
| `verification.mdc` | always | **Patch** — spectacle / polish “done means” bullets |
| `wow-ui-taint-lockdown.mdc` | UI + bootstrap | **Patch** — juice-safe checklist pointer |
| `wow-performance.mdc` | addon Lua/XML | **Patch** — motion/OnUpdate budget for juice |
| `packaging-assets.mdc` | ChurchOfBeef assets | Leave (already consent/spectacle) |
| `addon-module-layers.mdc` | `**/addon/**/*.lua` | Leave |
| `lua-cob-modules.mdc` | `**/addon/**/*.lua` | Leave |
| `toc-lifecycle.mdc` | TOC/lifecycle | Leave |
| `canon-data.mdc` | ranks/canon | Leave |
| `ladder-authority.mdc` | ladder | Leave |
| `scoring-coplay.mdc` | scoring | Leave |
| `officer-guild-roster.mdc` | officer | Leave |
| `beefnet-messaging.mdc` | net | Leave |
| `build-packaging.mdc` | packaging | Leave |
| `testing.mdc` | tests/Core/Data | Leave |

**Also update (not a rule file):** `AGENTS.md` “Rules at a glance” table once rules are installed — see §7.

---

## 3. Proposed new rule files (install list)

Install under `.cursor/rules/` **only after approval**:

1. **`major-leaps-per-prompt.mdc`** — always-on, thin — every substantive prompt packs a vertical slice  
2. **`agent-self-critique.mdc`** — always-on, thin — mandatory critique gate before “done”  
3. **`agent-polish-loop.mdc`** — description-picked (not always-on) — build → critique → revise → verify → stop  
4. **`ui-juice-standards.mdc`** — `UI/**` (+ toast/announce paths) — V1 juice floor + bans  

**Optional later (not in this install batch):** fold stop-condition detail from `31-loop-stop-conditions.md` into `agent-polish-loop.mdc` if that doc disagrees; keep skill `37` as the operational loop, rules as policy.

---

## 4. Full proposed rule text (copy-paste ready)

### 4.1 NEW — `.cursor/rules/major-leaps-per-prompt.mdc`

```markdown
---
description: Pack each prompt into a major verifiable leap — no nibble-sized agent turns
alwaysApply: true
---

# Major leaps per prompt

## Non-negotiables

- One user prompt → one **vertical slice** the user can feel or verify — not a drive-by edit
- Prefer parallel exploration (subagents / batched reads) over serial “read one file then ask”
- Stop when the slice is verified; do not open a second feature without ask

## What counts as a leap (pick ≥1)

| Leap type | Example done-state |
|-----------|-------------------|
| Core/Data | New behavior + `lua tests/run.lua` exit 0 |
| UI surface | Frame/tab/toast path works after install + `/reload` |
| Net/sync | Spec’d message path; note 2-client need if untested |
| Polish | Named juice moment (toast, announce, empty state) passes critique gate |
| Docs/rules | Spec/glossary/plan updated when product truth moved |

## Anti-nibbles (reject)

- “I added a stub; next prompt can wire it”
- Touching three unrelated systems with no single demo path
- Research-only churn when the user asked for working addon behavior
- Claiming progress without the verification row for that leap type

## Scope packing

1. Restate the slice in one sentence (outcome, not file list)
2. List files you will touch; drop anything outside the slice
3. Name the verification command or in-game path **before** editing
4. If the ask is huge, propose 2–3 leap-sized cuts and execute the first unless told otherwise

Worktree: edit `.worktrees/feat-church-of-beef-v1/` from Beef_Addon workspace — see `AGENTS.md`.
```

### 4.2 NEW — `.cursor/rules/agent-self-critique.mdc`

```markdown
---
description: Mandatory self-critique before claiming done on Church of Beef changes
alwaysApply: true
---

# Agent self-critique gate

## Non-negotiables

- Do not say “done” until a **critique pass** runs against the change
- Critique is adversarial: hunt failures, not confirmations
- High-confidence + high-severity findings only in the user summary (≤3 bullets)
- Product law wins: spec §15 / glossary / `Data/Ranks.lua` over vibes

## When required

| Change touches… | Critique lens (ask explicitly) |
|-----------------|--------------------------------|
| `UI/**`, toasts, announce | Juice bans, Classic shell, dual-encode, taint |
| Core / Data / tests | Layer purity, thresholds from `Ranks.lua`, harness |
| Net / Sync / officer | Forgery, roster gate, revision/replay, spam |
| Copy / empty states | Tone, procedural officer labels, no tip jars |
| Any “polish” / “juice” ask | Full polish loop (`agent-polish-loop.mdc`) |

Trivial typos / comment-only: skip critique; still don’t invent product policy.

## Mini protocol (same turn)

1. **Builder claim** — what shipped (1 sentence)
2. **Critic pass** — answer: What feels cheap? What violates V1 locks? What breaks in combat / without guild / offline?
3. **Revise or waive** — fix P0/P1 now; list waived P2 with reason
4. **Verify** — `verification.mdc` row for the leap type

## Ban list for fake critique

- “Looks good to me” with no checklist
- Nitpicking whitespace while skipping spectacle / layer / safety
- Grading only desktop tests when UI/Net was touched
```

### 4.3 NEW — `.cursor/rules/agent-polish-loop.mdc`

```markdown
---
description: Polish-loop workflow for CoB UI/juice — build, critique, revise, verify, stop
alwaysApply: false
---

# Agent polish loop (Church of Beef)

Use when the user asks for polish, juice, spectacle, UI feel, toasts, announce copy, empty states, or “make it feel finished.” Policy stays here; install/reload ops stay in `.cursor/skills/church-of-beef-dev`.

## Loop (max 3 critique rounds per prompt)

```
Read brief + locks → Implement slice → Critique → Revise → Verify → Stop?
```

| Round | Agent job |
|-------|-----------|
| 0 | Read `ui-polished-direction-for-agents.md` + relevant spec §10/§15 rows |
| 1 | Ship the leap (`major-leaps-per-prompt.mdc`) |
| 2 | Self-critique (`agent-self-critique.mdc`) + juice checklist (`ui-juice-standards.mdc`) |
| 3 | Fix P0/P1 only; re-verify |

## Stop conditions (any one)

- Two consecutive rounds add only cosmetic nits (diminishing returns)
- Critique finds no P0/P1 against locks
- Verification gate green for the slice (harness and/or in-game path)
- Hit **3** critique rounds → summarize residual risk; do not infinite-loop
- Critics disagree on taste → **spec/glossary wins**; else prefer the stricter Classic/safety reading

## Hard bans inside the loop

- No bots, injection, protected-action bypass, SecureActionButton “for panels”
- No Retail-only APIs; Interface stays `20506` unless intentionally bumping
- UI never awards points; Net never invents ranks
- Do not invent brand hex, SFX, or custom `Media/` during V1 Task 7–10
- Do not claim V1 complete from a polish loop alone

## Hand-off

If stuck on product taste: log options, do not fork policy into research. Update spec §15 when a new lock is chosen.
```

### 4.4 NEW — `.cursor/rules/ui-juice-standards.mdc`

```markdown
---
description: V1 UI juice & spectacle standards — toasts, announce, motion, bans for CoB
globs:
  - "**/addon/**/UI/**/*.lua"
  - "**/addon/**/UI/**/*.xml"
  - "**/ChurchOfBeef/ChurchOfBeef.lua"
alwaysApply: false
---

# UI juice standards (V1)

**Doctrine:** Classic Blizzard shell for process UI; brand in words (guild chat + private toasts). Custom gothic/heraldry only after V1 earns it.

Before `CreateFrame` work: read `docs/superpowers/ui-polished-direction-for-agents.md`.

## Non-negotiables

- Inherit Classic templates (`BasicFrameTemplate`, `UIPanelButtonTemplate`, `BackdropTemplate`, …)
- Opaque high-contrast panels; `GameFont*`; class color on **names** only
- Dual-encode pending / approve / reject (color + word/icon — never hue alone)
- Spectacle = throttled `/g` line (officer checkbox, default ON) + private edge toast
- Standing: **text thresholds** only (no hero StatusBar / HP meter)
- Silent (no SFX) in V1; missing media must not fail load
- Guest on player `uiScale` — never set `uiScale` / `UIParent:SetScale`

## Celebration tiers (V1)

| Tier | Trigger | Channels | Cap |
|------|---------|----------|-----|
| T0 Private | Suggestion, Gora/ceremony credit | Edge toast only | Coalesce; no chat |
| T1 Social | Officer Commit promote/demote | Officer `/g` + recipient toast | One guild line; no peer echo |
| T2+ | — | **Out of V1** | No WA center pulses, no multi-line liturgy |

## Motion / timing

- Prefer show/hide + short alpha on **Beef-owned insecure** frames
- No permanent `OnUpdate` for juice; disable scripts when idle (`wow-performance.mdc`)
- No center-screen alert frames for social ranks
- Stagger only inside Beef toast stack; never hitch combat

## Anti-patterns (reject)

WA center pulses · Details!-dense rosters · item-quality rainbow for ranks · ElvUI-flat brand · glass/low-alpha panels · SecureActionButton for panels · tip jars · standing-as-castbar · Retail templates unverified on Anniversary · forking thresholds into copy

## Critique questions (before done)

1. Would a member without the addon still notice a promotion?
2. Does this still read as Blizzard chrome if custom tint fails?
3. Can an officer complete Approve in combat without taint/lockdown pain?
4. Is announce still one throttled line with opt-out honoring SV?
```

---

## 5. Proposed patches to existing rules

### 5.1 PATCH — `verification.mdc`

Add after item 5 in “Done means (per change)” (renumber 6 → 7):

```markdown
6. **Polish / spectacle** (UI juice, toasts, announce, empty states): pass
   `agent-self-critique.mdc` + `ui-juice-standards.mdc` checklists; guild-chat
   spectacle still needs a human/client pass — harness cannot prove it.
7. **Do not claim V1 complete** until `docs/phases/v1-checklist.md` is filled and walked.
```

(Replace the current sole item 6 with the above 6+7.)

### 5.2 PATCH — `architecture-overview.mdc`

Under **Edit preferences**, append:

```markdown
- UI / juice / polish prompts: follow `ui-juice-standards.mdc`, `agent-polish-loop.mdc`,
  and `docs/superpowers/ui-polished-direction-for-agents.md` — do not invent a third UI religion
- Substantive prompts: pack a major leap (`major-leaps-per-prompt.mdc`) and run self-critique
  before claiming done (`agent-self-critique.mdc`)
```

### 5.3 PATCH — `wow-ui-taint-lockdown.mdc`

Under **Product UX edges**, append:

```markdown
## Juice safety

- Polish features use the same insecure-frame rules as the rest of `/beef`
- Prefer precreated toast frames; never Secure* templates for ceremony chrome
- Shipping checklist for social juice: `docs/research/agent-polish-vision/03-taint-lockdown-ux.md`
  (research) + `ui-juice-standards.mdc` (policy once installed)
```

### 5.4 PATCH — `wow-performance.mdc`

Under **Do / don’t**, add one row:

```markdown
| Toast/announce juice on events + short timers | Permanent OnUpdate “animation director” |
```

And under **Cross-cutting throttle**:

```markdown
- Juice: coalesce toasts; never full ladder rebuild per toast; guild announce stays one line
```

---

## 6. Install plan (when approved)

1. Write the four new `.mdc` files from §4 (exact text).  
2. Apply patches in §5.  
3. Update `AGENTS.md` “Rules at a glance” with a **Polish / agent process** row.  
4. Optionally add polish-loop skill from `37-skill-draft-polish-loop.md` — skill = ops, rules = policy.  
5. Do **not** mark research as product law; if juice tiers change, amend spec §15 first.  
6. Smoke: open a UI file → confirm `ui-juice-standards` attaches; ask a polish question → confirm polish-loop description is pickable.

**Rollback:** delete the four new files and revert the four patches; always-on surface returns to architecture + verification only.

---

## 7. AGENTS.md snippet (install-time)

```markdown
| Polish / agent process | `major-leaps-per-prompt`, `agent-self-critique`, `agent-polish-loop`, `ui-juice-standards` |
```

Point UI work at `docs/superpowers/ui-polished-direction-for-agents.md` (already present).

---

## 8. Explicit non-goals

- No Ralph/while-true automation in rules (optional skill/hooks later; needs `OPTIMIZATIONS.md` approval)
- No always-on dump of full UI brief (token cost) — brief stays a required read via juice rule
- No changing Interface `20506`, AceAddon stance, or officer/announce locks via this proposal
- No overwriting player WTF or force-push policies

---

## 9. Acceptance for this research doc

- [x] Full installable text for each new rule  
- [x] Concrete patches for existing rules  
- [x] Always-on count stays small (2 → 4 thin always-on; heavy juice file-scoped)  
- [ ] Human approval before any `.cursor/rules/` write  

---

## 10. Quick reference — proposed filenames

| Path | Role |
|------|------|
| `.cursor/rules/major-leaps-per-prompt.mdc` | NEW · always-on |
| `.cursor/rules/agent-self-critique.mdc` | NEW · always-on |
| `.cursor/rules/agent-polish-loop.mdc` | NEW · picker |
| `.cursor/rules/ui-juice-standards.mdc` | NEW · UI globs |
| `.cursor/rules/verification.mdc` | PATCH |
| `.cursor/rules/architecture-overview.mdc` | PATCH |
| `.cursor/rules/wow-ui-taint-lockdown.mdc` | PATCH |
| `.cursor/rules/wow-performance.mdc` | PATCH |

---

## 11. Community evidence → CoB rule shape

| External lesson | How this proposal uses it |
|-----------------|---------------------------|
| Keep always-on lean ([docs](https://cursor.com/docs/rules.md), [RockB](https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026/)) | Only two thin new always-on files; juice is globbed |
| Skills hold procedures ([Skills](https://cursor.com/docs/skills.md), [forum](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875)) | Point polish algorithm at [37](./37-skill-draft-polish-loop.md) / picker rule — not a novel |
| Agents ignore vague skills ([forum](https://forum.cursor.com/t/agent-ignores-skill/149017)) | Juice rule forces brief read; description must match polish verbs |
| Self-critique / compliance loops requested ([forum](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)) | `agent-self-critique.mdc` is the lightweight in-repo answer |
| Overengineering defaults under AI ([YAGNI×AI](https://blog.flurdy.com/2026/02/yagni-100-with-ai), [Ponytail](https://openclawapi.org/en/blog/2026-06-21-ponytail-overengineering-fix)) | Polish loop hard-bans custom Media/SFX; governor [49](./49-adversarial-overengineering.md) |
| Stop caps beat infinite polish ([31](./31-loop-stop-conditions.md), [arXiv:2606.27009](https://arxiv.org/abs/2606.27009)) | Max 3 critique rounds in `agent-polish-loop.mdc` |
| Evidence before done ([blog](https://cursor.com/blog/agent-best-practices)) | Patch `verification.mdc` polish/spectacle row |

---

## External sources

> Research ≠ product law. Do not write these `.mdc` files until a human approves; do not treat this proposal as overriding glossary locks.

**Cursor official**

- [Rules](https://cursor.com/docs/rules.md)
- [Skills](https://cursor.com/docs/skills.md)
- [Hooks](https://cursor.com/docs/hooks.md)
- [Best practices for coding with agents](https://cursor.com/blog/agent-best-practices) (Jan 2026)
- [Cloud Agent Best Practices](https://cursor.com/docs/cloud-agent/best-practices.md)
- [Agent Review](https://cursor.com/docs/agent/agent-review.md) (related review surface)

**Cursor forum / Reddit**

- [Skills vs Commands vs Rules](https://forum.cursor.com/t/skills-vs-commands-vs-rules/148875)
- [Rules vs Skills vs Commands vs Hooks](https://forum.cursor.com/t/rules-vs-skills-vs-commands-vs-hooks/151829)
- [What is the difference between skills and rules?](https://forum.cursor.com/t/what-is-the-difference-between-skills-and-rules/149765)
- [Rules / project skills / agent](https://forum.cursor.com/t/rules-f-project-skills-f-agent/148212)
- [Agent ignores skill](https://forum.cursor.com/t/agent-ignores-skill/149017)
- [Native compliance / auto-critique loops](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556)
- [r/cursor — figuring out Cursor rules](https://www.reddit.com/r/cursor/comments/1r6bfdh/i_spent_way_too_long_figuring_out_cursor_rules/)
- [r/cursor — Skills vs Commands](https://www.reddit.com/r/cursor/comments/1qn4spg/whats_the_difference_between_skills_and_commands/)

**Guides / GitHub**

- [RockB — Cursor Agent Best Practices 2026](https://baeseokjae.github.io/posts/cursor-agent-best-practices-2026/)
- [heyuan110 — Cursor Agent Best Practices](https://www.heyuan110.com/posts/ai/2026-01-19-cursor-agent-best-practices/)
- [ibuildwith.ai — Rules, Skills, Commands](https://www.ibuildwith.ai/blog/cursor-rules-skills-and-commands-oh-my-when-to-use-each/)
- [PromptHub — Top Cursor Rules](https://www.prompthub.us/blog/top-cursor-rules-for-coding-agents)
- [blink.new — Cursor rules guide](https://blink.new/blog/cursor-rules-guide)
- [murataslan1/cursor-ai-tips](https://github.com/murataslan1/cursor-ai-tips)
- [spencerpauly/awesome-cursor-skills](https://github.com/spencerpauly/awesome-cursor-skills/blob/main/resources/grinding-until-pass/SKILL.md)

**Overengineering / stop (process caution)**

- [YAGNI × 100 with AI](https://blog.flurdy.com/2026/02/yagni-100-with-ai)
- [Ponytail — curing overengineering](https://openclawapi.org/en/blog/2026-06-21-ponytail-overengineering-fix)
- [Semantic Early-Stopping (arXiv:2606.27009)](https://arxiv.org/abs/2606.27009)
- [Agentic coding — YAGNI pattern](https://aipatternbook.com/yagni)
- [HN — Cursor AI Rules Directory](https://news.ycombinator.com/item?id=41346156)
- [dev.to — Agent skills are the new dotfiles](https://dev.to/max_quimby/agent-skills-are-the-new-dotfiles-1g1i)
- [21b source digest](./21b-cursor-loops-source-digest.md) (hooks/rules adjacent URLs)

**In-repo**

- `OPTIMIZATIONS.md` (hooks/tooling backlog needs approval)
- Scrapes: `_search-community-cursor-agent.json`, `_search-cursor-review-skills.json`
