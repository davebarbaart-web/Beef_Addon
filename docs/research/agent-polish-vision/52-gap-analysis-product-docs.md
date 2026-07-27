# 52 — Gap analysis: product docs vs polish-loop / agent-goal methodology

**Lane:** `docs/research/agent-polish-vision/`  
**Date:** 2026-07-26  
**Status:** Research gap audit — **not** product law. Identifies doc updates; does **not** implement them.  
**Audience:** Maintainers deciding what to promote from this research lane into product / agent briefing surfaces.

**Product docs in scope:**

| Doc | Path |
|-----|------|
| Design spec | `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` |
| V1 plan | `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md` |
| Phases | `docs/phases/v1-checklist.md`, `docs/phases/guild-night-playtest.md` |
| UI direction | `docs/superpowers/ui-polished-direction-for-agents.md` |

**Adjacent (not product law, but needed for wiring):** `AGENTS.md`, `.cursor/rules/verification.mdc`, `.cursor/skills/church-of-beef-dev/SKILL.md`, glossary `74-v1-decision-glossary/`.

**Methodology corpus (emerging, this folder):** especially `22`, `23`, `24`, `25`, `26`, `27`, `29`, `30`, `31`, `32`, `37`, `38`, `39`, `40`, `42`, plus adversarial brakes `49`–`51`.

**Related amendment (watch):** `docs/superpowers/specs/2026-07-25-roster-backed-ladder-design.md` (Draft) can remove Commit/announce assumptions that polish goals currently encode — resolve before promoting spectacle-loop language that assumes officer `RANK_COMMIT` → `/g`.

---

## 1. Executive summary

Product docs already lock **what** V1 is (ladder, hybrid approve, Classic shell, brand-in-words spectacle, §13 success criteria). They barely describe **how agents iterate polish** without over-claiming done.

The research lane now has a coherent methodology:

1. **Agent goals** as contracts (intent · acceptance · critique budget · artifacts · stop · human handoff) — `30`  
2. **Polish loop** (implement → hard verify → separate critique → fix → ledger) — `22`, `29`, `37`  
3. **Definition of Done for polish** (gates A–E, rubrics, human-only PASS) — `24`, `25`  
4. **Stop conditions** (caps, plateau, best-so-far, lock rejection) — `31`, `49`  
5. **Human checkpoints / visual evidence** — `32`, `23`, `26`  
6. **Juice / celebration vocabulary** missing from the UI brief — `38`, `39`, `42`

**Gap type:** process + agent briefing under-specification — not missing ladder/scoring product decisions.

**Promotion doctrine:** Absorb a **thin spine** into product/agent docs. Keep score factories, multi-critic swarms, and overnight Ralph loops in research (see `49`). Spec §15 / glossary remain the only place new *product* locks land.

---

## 2. What product docs already cover well

| Area | Where | Enough for agents? |
|------|-------|--------------------|
| Hard safety / ToS | Spec §2; plan Global Constraints; verification.mdc | Yes |
| Layer authority | Spec §6; plan; AGENTS.md | Yes |
| Rank / threshold canon | Spec §4; `Data/Ranks.lua`; glossary | Yes (numbers stay out of lore) |
| UI chrome doctrine | Spec §10; UI brief; glossary 74–81 | Yes for *bans* and shell |
| Spectacle product intent | Spec §10 + §13.11; UI brief anti-patterns | Yes for *channels* (`/g` + edge toast) |
| Functional V1 done | Spec §13; `v1-checklist.md` | Yes for *feature* completeness |
| Live playtest ops | `guild-night-playtest.md` + track 51 | Yes for guild-night field |
| Agent-executed UI stance | UI brief + AGENTS.md | Yes (“agents build UI”) |
| Offline vs client truth | verification.mdc; church-of-beef-dev; checklist preamble | Partially — evidence gate exists; polish DoD does not |

**Bottom line:** Agents know the religion and the bans. They do not have a product-facing contract for “polish goal → critique → stop → human PASS.”

---

## 3. Methodology needs (compressed)

| Need ID | Need | Primary research homes |
|---------|------|------------------------|
| **M1** | Goal anatomy (8 blocks / compact dispatch) | `30` |
| **M2** | Critique ≠ self-bless; separate critic; ≤3 revise rounds | `22`, `25`, `27`, `29` |
| **M3** | Hard evaluator before soft LLM judge | `22`, `24` Gate A, verification.mdc |
| **M4** | Polish DoD distinct from V1 checklist | `24` (CANDIDATE vs PASS; human-only PASS) |
| **M5** | Explicit stop / plateau / best-so-far / lock rejection | `31`, `49` |
| **M6** | Human checkpoint types H0–H5 + artifact pack | `32` |
| **M7** | Visual QA / self-playtest without client automation | `23`, `26` |
| **M8** | Juice hierarchy + celebration tiers + motion budget | `38`, `39`, `42` |
| **M9** | Plan tasks list offline + in-client + critique evidence | `29` §4.4, `40` |
| **M10** | Skill / rule wiring (ops) without forking product law | `37`, `29` §4 |

---

## 4. Gap matrix (product doc × need)

Legend: **Have** = usable as-is · **Thin** = mentioned but not agent-operable · **Gap** = absent · **N/A** = wrong layer for that doc.

| Need | Design spec | V1 plan | `v1-checklist` | Guild-night playtest | UI direction brief |
|------|-------------|---------|----------------|----------------------|--------------------|
| **M1 Goals** | Gap | Thin (task steps, not goal contracts) | N/A | N/A | Gap (no dispatch template) |
| **M2 Critique loop** | Gap | Gap (Task 13 = walk checklist) | Gap | Thin (Spectacle Watcher role) | Thin (anti-patterns only; no roles/caps) |
| **M3 Hard before soft** | Thin (§13.1) | Thin (per-task “in-game verify”) | Have (preamble) | Have (BugSack) | Thin (“Anniversary smoke”) |
| **M4 Polish DoD** | Gap (§13 = functional) | Gap | Gap (functional only) | N/A (field, not polish DoD) | Gap (“Done means” = `/beef` works) |
| **M5 Stop conditions** | Gap | Gap | Gap | N/A | Gap |
| **M6 Human checkpoints** | Thin (§13.11 human) | Thin | Have (dated ticks) | Have | Thin |
| **M7 Visual evidence** | Gap | Gap | Gap | Thin (reaction checkbox) | Thin (canvas pointer) |
| **M8 Juice / tiers / motion** | Thin (channels + silent) | Gap | Gap | Thin (spectacle goal) | **Gap** (largest briefing hole — `39` §2) |
| **M9 Task evidence** | N/A | **Gap** for Tasks 7–10, 13 | Thin | N/A | Thin (phased table) |
| **M10 Skill pointer** | N/A | Thin (SDD/executing-plans) | N/A | Points at church-of-beef-dev | Points at rules; no polish-loop skill |

### 4.1 Design spec — concrete gaps

| § | Today | Missing for methodology |
|---|-------|-------------------------|
| §10 UI | Locks surfaces, announce, settings, Standing text, silent SFX | No juice hierarchy; no celebration tiers; no motion budget; no “agent may not invent tiers” |
| §13 Success | Functional + social check | No distinction **feature done** vs **surface polish PASS**; no critique/evidence requirement |
| §13.1 Verification | Client + BeefNet + missing media + doc review | No adversarial critique / evidence pack; no ban on claiming polish from harness alone (implied elsewhere, not here) |
| §14 Phase map | V1–V4 product phases | No pointer to juice roadmap partition (`38`/`42`) — optional one-liner only |
| §15 Decisions | Strong product locks | No process decisions yet (e.g. “polish PASS is human-signed”; “critique mandatory for UI/announce”) — only add if maintainers want them normative |
| §16 Open questions | Threshold/playtest items | Could list process open questions from `29` §6 / `37` without blocking V1 |

**Do not** dump Reflexion / score composites / swarm topologies into the design spec. At most: short “agent polish” subsection or §15 rows + pointers.

### 4.2 V1 plan — concrete gaps

| Location | Today | Missing |
|----------|-------|---------|
| Header | Requires SDD or executing-plans | No link to goal template (`30`) or polish loop (`29`/`37`) |
| Global Constraints | Excellent product/safety | No “UI polish claims need critique + client smoke” |
| Tasks 7–10 | Implement + in-game verify bullets | No critique cycle, no artifact path, no stop/handoff, no screenshot/scenario IDs |
| Task 13 “Final polish pass” | Walk checklist + Retail grep | Underspecified vs `24`/`42`: reads as functional cleanup, not gated polish slices; no ban on Media creep; no human POLISH:PASS |
| Self-review table | Spec ↔ task map | No polish/spectacle quality row |

**Risk:** Agents treat Task 13 as “README + greps + claim polished.” Research `49` flags this as schedule theft.

### 4.3 Phases — concrete gaps

| Doc | Today | Missing |
|-----|-------|---------|
| `v1-checklist.md` | Spec §13 walkable; offline boxes ticked | No polish-tier rows; no link to visual checklist / evidence pack; no “POLISH:CANDIDATE ≠ V1 complete” |
| `guild-night-playtest.md` | Strong H4 field protocol | Could name H3 spectacle checkpoint explicitly; optional link to agent handoff pack (`32`) for pre-night agent prep |

### 4.4 UI direction brief — concrete gaps

Highest-leverage product-adjacent doc for agents. Current strengths: authority order, bans, phased V1/V1.1/art, canvas map.

| Hole | Why it hurts | Research ready to merge |
|------|--------------|-------------------------|
| No juice hierarchy | Agents invent WA juice or skip feedback | `39` §3, `38` |
| No celebration tiers | Credit toast == Prophet rite | `39` §6 |
| No motion budget | Permanent OnUpdate / bounce loops | `39` §4 |
| No mandatory critique checklist | Self-merge “looks fine” | `39` §7 (C1–C10), `25` |
| “Done means” too weak | `/beef` works ≠ polish | `24` CANDIDATE/PASS; `42` V1 IN/OUT |
| No goal / loop pointer | Humans paste vague “make nicer” | `30` compact template; `29` §3; `37` |
| No stop conditions | Endless synonym polish | `31` one-screen checklist (thin pointer) |

`39` §8 already proposes the briefing merge shape — this gap doc endorses that path.

---

## 5. Conflicts & caution (do not promote blindly)

| Tension | Detail | Recommendation |
|---------|--------|----------------|
| **Over-process vs ship** | `22`/`27`/`31` can grow into a juice OS; `49` says cut | Promote thin spine only; cite `49` in plan/brief as anti-pattern |
| **Multiple rubrics** | `22` H/U/P · `25` 8×1–5 · `24` S1–S8 · `31` 0–100 composite | Product docs should pick **one** agent-facing checklist (prefer `39` C1–C10 + UI brief bans). Leave numeric scorecards in research |
| **Agent PASS vs human PASS** | `24` forbids agent POLISH:PASS | Spec/checklist should say human signs spectacle/polish; agents claim CANDIDATE only |
| **Roster-backed amendment** | Draft removes Commit/`RANK_COMMIT` announce path | Freeze promote-spectacle goal language until amendment accepted or rejected; update §10/§13/plan if accepted |
| **Research ≠ law** | Entire `agent-polish-vision/` folder | Updates must land in spec/brief/plan/phases — not “agents must obey note 31” |

---

## 6. Ordered doc update list

Implement later, in this order (dependencies first). Each item is a **doc edit**, not code.

### P0 — Agent briefing (unblocks polish without new product features)

1. **`docs/superpowers/ui-polished-direction-for-agents.md`**  
   - Merge thin slices from `39` §8: juice hierarchy, celebration tiers (V1 lock), motion budget, critique obligations (inline C1–C10 or short pointer + stop rules).  
   - Add “Done for UI polish” = hard smoke + critique clean + human eyes for spectacle; green harness insufficient.  
   - Point to goal compact template (`30` §4) and composite polish loop (`29` §3) as **process guidance** (not law).  
   - Point at `42` for V1 IN/OUT polish scope.  
   - Keep canvases secondary; spec still wins.

### P1 — Plan tasks that agents actually execute

2. **`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`**  
   - Global Constraints: one bullet — UI/Net/SV/slash changes require client smoke; polish claims require critique evidence; no Media/SFX in Tasks 7–10.  
   - Tasks **7–10**: append acceptance shaped like `30` (offline / in-game / polish anti-patterns); require short critique note or PR section; max 2–3 revise cycles before human.  
   - Task **13**: redefine as **gated polish slices** (P0/P1/P2 from `24`) against UI brief + `v1-checklist`, not “chore commit.” Explicit: no custom Media; human signs social check; do not claim V1 complete from offline-only.  
   - Header: optional “for polish work, prefer goal template in research `30` + UI brief.”

### P2 — Walkable completion surfaces

3. **`docs/phases/v1-checklist.md`**  
   - Supporting checks: optional “UI polish evidence” subsection — critique attached, Anniversary smoke for each tab, announce ON/OFF trial — **without** making numeric rubrics normative.  
   - Clarify: ticking functional §13 ≠ automatic polish PASS.  
   - Keep dated human ticks as the only V1-complete gate.

4. **`docs/phases/guild-night-playtest.md`**  
   - Label spectacle row as checkpoint **H3** (from `32`); link agent preflight/handoff expectations lightly.  
   - Do not import full swarm protocol.

### P3 — Spec: only what must be product law

5. **`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`**  
   - Prefer **minimal** edits:  
     - §10: optional short juice hierarchy + “celebration tier locked in UI brief / glossary if promoted.”  
     - §13.1: “Desktop harness does not prove UI polish or §13.11; agents must not claim polish PASS.”  
     - §15: only if maintainers want normative process rows, e.g. *UI polish PASS is human-signed*; *V1 spectacle channels remain `/g` + edge toast*.  
   - Avoid embedding loop algorithms, score weights, or skill install instructions.  
   - If roster-backed amendment is accepted first, amend §10/§13 announce/Commit language **before** promoting Commit-centric polish goals.

### P4 — Ops wiring (not product docs; do after or with P0)

6. **`.cursor/skills/church-of-beef-dev/SKILL.md`** — short “Polish loop” pointer to UI brief + research `29`/`37` (or install `37` as separate skill after human approval).  
7. **`.cursor/rules/verification.mdc`** — one bullet: no UI “polished/done” claim without `/reload` smoke + (for promote path) human/spectacle acknowledgment that tests cannot prove.  
8. **`AGENTS.md`** — link polish-loop skill/brief; keep map short.  
9. **Glossary `74`** — only if celebration tiers / motion budgets become normative locks (rows), not for process prose.

### P5 — Explicitly defer (research stays research)

| Item | Why defer |
|------|-----------|
| Full `31` composite score algorithm | Too heavy for product; keep orchestrator-only |
| Default multi-agent swarm (`27`) | Optional for leaps; not V1 product law (`49`) |
| Installing `37` skill | Needs human approval; draft already complete |
| Artifact path under `docs/research/.../artifacts/` | Useful; not a product-doc requirement |
| Canvases as sole DoD | Remain orientation; brief + checklist are durable |

---

## 7. Suggested “thin spine” (what good looks like after updates)

```text
Human writes GOAL (30 compact) 
  → Agent implements one V1-IN surface (42 / UI brief)
  → Hard gates (verification + church-of-beef-dev)
  → Critique (UI brief C-checklist / 25 as depth)
  → Stop (31 / 49: cap, plateau, locks win)
  → Human checkpoint (32 H0–H3)
  → v1-checklist only for “V1 complete”
```

Product docs should **name and point** at this spine. They should **not** re-host the entire research library.

---

## 8. Coverage summary

| Methodology need | Covered in product docs today? | Primary update target |
|------------------|--------------------------------|------------------------|
| Agent goals | No | Plan Tasks 7–13 + UI brief pointer |
| Polish loop / critique | No | UI brief + plan Task 13 |
| Polish DoD vs V1 done | No | `v1-checklist` + UI brief; light spec §13.1 |
| Stop conditions | No | UI brief (short); depth in `31`/`49` |
| Human checkpoints | Partial (§13.11, guild-night) | guild-night + `32` pointer |
| Juice / tiers / motion | Partial (channels only) | **UI brief** (from `39`) |
| Anti-overengineering | No | Plan Task 13 + cite `49` |

---

## 8b. Sourced practices (methodology corpus)

| Practice | Where researched | Product-doc implication |
|----------|------------------|-------------------------|
| Verifiable agent goals | [21](21-cursor-agent-loops-goals.md), [30](30-writing-effective-agent-goals.md), Cursor best practices | Plan / Task 7+ acceptance bullets |
| Implement → critique → stop | [22](22-llm-critique-loops.md), [29](29-superpowers-loop-patterns.md), [31](31-loop-stop-conditions.md) | Thin spine in UI brief + skill — not full swarm in spec |
| Human-only polish PASS | [24](24-definition-of-done-polish.md) | Checklist / phases — do not let agents tick “polished” |
| Evidence before claims | Superpowers verification-before-completion; `verification.mdc` | Already partial; extend to UI polish language |
| Anti-overengineering | [49](49-adversarial-overengineering.md)–[51](51-adversarial-performance-vs-juice.md) | Keep score factories out of product law |

---

## 8c. CoB-specific application

Promote **pointers and one-page spines** into:

| Target | Absorb |
|--------|--------|
| `AGENTS.md` | Link this folder + Goal anatomy one-liner |
| UI brief | Juice vocabulary index → [38](38-juice-spectacle-roadmap.md)/[39](39-ui-direction-standards-expansion.md) |
| `church-of-beef-dev` | § Polish loop |
| `v1-checklist.md` / playtest | Human polish / spectacle gates already implied by §13 — name them |
| Design spec §15 | Only if process becomes mandatory product law |

Do **not** paste rubrics wholesale into the design spec.

---

## 8d. Agent rules

1. Treat this file as a **backlog of doc edits**, not permission to rewrite product law.  
2. When implementing polish, follow research methodology even if product docs lag.  
3. If a gap requires a product decision, open a §15 row — do not encode policy only in Lua.  
4. Prefer thin promotions ([36](36-cob-rules-skills-gap-audit.md) ladder) over duplicating this folder into always-on rules.  
5. Re-read roster-backed amendment before promoting Commit→`/g` spectacle loop text.

---

## 9. Open questions (for maintainers — not blockers for the gap doc)

1. Promote process rows into **spec §15**, or keep process only in UI brief + skill?  
2. Separate `church-of-beef-polish-loop` skill (`37`) vs section on `church-of-beef-dev` (`29` §4.2)?  
3. Which single critique artifact is mandatory in-repo — PR body, `artifacts/<slug>-critique.md`, or checklist ticks only?  
4. Accept or reject **roster-backed ladder** before locking promote-spectacle polish goals?  
5. After one guild night, lock toast hold times / demotion announce template (`39` §9) into glossary vs leave tunable?

---

## 10. Source index (this audit)

**Product:** design spec; V1 plan; `v1-checklist.md`; `guild-night-playtest.md`; `ui-polished-direction-for-agents.md`; draft roster-backed amendment.  

**Methodology:** `22-llm-critique-loops.md`, `23-self-playtest-patterns.md`, `24-definition-of-done-polish.md`, `25-ui-polish-critique-rubric.md`, `26-visual-qa-screenshot-protocol.md`, `27-multi-agent-adversarial-review.md`, `29-superpowers-loop-patterns.md`, `30-writing-effective-agent-goals.md`, `31-loop-stop-conditions.md`, `32-human-checkpoint-handoff.md`, `37-skill-draft-polish-loop.md`, `38-juice-spectacle-roadmap.md`, `39-ui-direction-standards-expansion.md`, `40-major-leaps-dev-standards.md`, `42-v1-vs-v2-juice-scope.md`, `49-adversarial-overengineering.md`.

**Ops:** `AGENTS.md`, `verification.mdc`, `church-of-beef-dev/SKILL.md`.

---

## 11. One-line exit for this audit

> Product docs define the church; research now defines the polish factory — promote only the thin goal→critique→stop→human spine into the UI brief and plan Tasks 7/13, keep score swarms out of the spec, and never let a green harness certify spectacle.
