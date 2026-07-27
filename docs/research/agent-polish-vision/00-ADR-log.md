# 00-ADR-log — Agent-polish synthesis decisions

**Lane:** `docs/research/agent-polish-vision/`  
**Date:** 2026-07-26  
**Status of all entries below:** **Accepted** by user 2026-07-26 (thin promote per [`00-PROMOTE-CHECKLIST.md`](00-PROMOTE-CHECKLIST.md)).  
**Playbook:** [33](33-parallel-synthesis-methods.md) Phase F  
**Conflicts:** [`_wave-synthesis-conflicts.md`](_wave-synthesis-conflicts.md)  
**Standards:** [`00-SYNTHESIS.md`](00-SYNTHESIS.md)

> Research ≠ product law until landed in target files. Do not claim V1 complete.  
> Kill-list items (ADR-0008) stay non-promotes even when Accepted as governor.

---

## Index

| ID | Title | Status |
|----|-------|--------|
| [ADR-0001](#adr-0001-defer-fat-always-on-polish-rules) | Defer fat always-on polish rules; thin spine first | **Accepted** |
| [ADR-0002](#adr-0002-polish-loop-lives-in-church-of-beef-dev) | Polish loop § in `church-of-beef-dev` (not separate skill first) | **Accepted** |
| [ADR-0003](#adr-0003-bounded-critique-caps-and-role-budget) | Critique caps + 1+0–1 role budget | **Accepted** |
| [ADR-0004](#adr-0004-celebration-tier-naming-t0t1) | Celebration tiers T0/T1 for V1 briefing | **Accepted** |
| [ADR-0005](#adr-0005-agent-facing-score-bar) | Agent-facing score bar = Gates + brief + [25] | **Accepted** |
| [ADR-0006](#adr-0006-freeze-spectacle-promote-pending-roster-amendment) | Main-spec Commit→`/g` watched pending roster amendment | **Superseded** |
| [ADR-0007](#adr-0007-process-stays-out-of-design-spec-algorithms) | Process algorithms stay out of design spec | **Accepted** |
| [ADR-0008](#adr-0008-do-not-promote-kill-list-items) | Explicit do-not-promote (49 kill-list) | **Accepted** |
| [ADR-0009](#adr-0009-adopt-roadmap-as-sequencing-not-law) | Adopt [53] milestones as sequencing guidance | **Accepted** |
| [ADR-0010](#adr-0010-ui-brief-absorbs-juice-vocabulary) | UI brief absorbs juice/tiers/motion from [39] | **Accepted** |

---

## ADR-0001: Defer fat always-on polish rules

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Deciders:** synthesis wave (agent) → human accept required  
- **Claims:** 34-rules-01, 36-wire-01, 21b-tax-01, 49-kill-01 · Conflict C-01, C-12  

### Context

[34](34-cursor-rules-polish-proposal.md) proposes four new rules (two always-on). Community + Cloud hygiene say always-on must stay tiny ([00b](00b-community-threads-digest.md), [21b](21b-cursor-loops-source-digest.md)). [49](49-adversarial-overengineering.md) warns against process factories. [36](36-cob-rules-skills-gap-audit.md) recommends lightest wiring first.

### Options

1. Install all four [34] rules immediately  
2. Install zero rules; AGENTS + skill only  
3. **Hybrid:** AGENTS + skill § first; optional later ≤2 thin always-on + glob juice rule  

### Decision

We will **(3)**: do **not** install `.cursor/rules/` polish files in the first promote pass. Wire AGENTS index + skill § + UI brief. Revisit [34] only if compliance still fails after thin spine.

### Consequences

+ Keeps always-on at architecture + verification  
+ Avoids token bloat / ignored rules  
− Agents may skip critique until skill/AGENTS point them  
Follow-up: if needed, prefer `ui-juice-standards.mdc` (glob) over new always-on encyclopedias  

### Rejected options

1 — too heavy before proving thin spine  
2 alone — OK short-term; hybrid allows later glob rule without mandating always-on leaps  

### Links

[34] · [36] · [49] · [00-PROMOTE-CHECKLIST.md](00-PROMOTE-CHECKLIST.md)

---

## ADR-0002: Polish loop lives in `church-of-beef-dev`

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Claims:** 37-skill-01, 29-loop-01, 36-wire-01 · Conflict C-05  

### Context

[37](37-skill-draft-polish-loop.md) is a full skill draft. [29](29-superpowers-loop-patterns.md) / [36](36-cob-rules-skills-gap-audit.md) prefer a § inside the existing ops skill first.

### Options

1. Install `church-of-beef-polish` skill from [37] now  
2. **Add § Polish loop to `church-of-beef-dev`** pointing at [29]/[24]/[25]/[31]/[49]  
3. Neither — prompt paste only  

### Decision

We will **(2)** as the first Accepted promote. Keep [37] as optional later extract if the section grows past ~80 lines.

### Consequences

+ One skill surface for install/reload + polish  
+ Lower discovery cost  
− Section must stay thin (pointer-heavy)  

### Rejected options

1 — premature second skill before AGENTS index exists  
3 — leaves hands-off gap ([36] P0)  

### Links

[37] · [29] · [36] · skill path `.cursor/skills/church-of-beef-dev/SKILL.md`

---

## ADR-0003: Bounded critique caps and role budget

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Claims:** 31-stop-01, 22b-bir-01, 49-kill-01, 22b-writer-01 · Conflicts C-02, C-09  

### Context

Caps disagree: [49] ≤2 critique rounds; [34]/[31] mention 3; [22b] 2 revises / 3 Actor attempts. Swarms look rigorous but thrash UI ([49]).

### Options

1. max_iter = 3 critique rounds always  
2. **max 2 critique→revise rounds; max 3 Actor attempts; then best-so-far or escalate**  
3. Unbounded until critic boredom  

### Decision

We will **(2)**, with role budget **1 implementer + 0–1 critic**; meta-debate **0** for polish; optional multi-critic only for Core/Net/safety.

### Consequences

+ Aligns Self-Refine early-gain + [49] governor  
+ Stops spend thrash ([00b]/[21b])  
− Some craft nits left as debt  

### Rejected options

1 — slightly looser than kill-list spirit  
3 — forbidden by [49]/[31]  

### Links

[22b] · [31] · [49] · [27]

---

## ADR-0004: Celebration tier naming T0/T1

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Claims:** 14-tier-01, 39-tier-01, 07-announce-01 · Conflict C-03  

### Context

[14](14-celebration-spectacle-design.md) uses Small/Medium/Epic; [34]/[39] use T0/T1/T2+. Agents need one briefing table.

### Options

1. Keep Small/Medium/Epic only  
2. Keep T0/T1/T2 only  
3. **Map both: T0=Small private, T1=Medium social, T2+/Epic=out of V1 (or scarce-seat copy inside T1)**  

### Decision

We will **(3)** and promote **T0/T1** as the agent-facing names in the UI brief; retain Small/Medium/Epic as aliases in research.

### Consequences

+ Single table for agents  
+ Preserves [14] craft language  
− Requires brief edit on Accept  

### Rejected options

Epic-as-V1-default — conflicts with silent edge-toast doctrine  

### Links

[14] · [39] · [42] · UI brief (promote target)

---

## ADR-0005: Agent-facing score bar

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Claims:** 25-rubric-01, 24-gate-01, 52-score-01 · Conflict C-04  

### Context

Multiple score systems confuse orchestrators ([36] C9, [52]).

### Options

1. Mandate [31] 0–100 composite in product docs  
2. **Gates A–E + UI brief checklist; [25] as depth; [31] orchestrator-only**  
3. H/U/P binary rows from [22] only  

### Decision

We will **(2)**. Product/agent docs must not embed composite weight math.

### Consequences

+ Auditable binary gates + craft depth  
− Orchestrators wanting one number keep [31] in research  

### Links

[24] · [25] · [31] · [52]

---

## ADR-0006: Freeze spectacle promote pending roster amendment

- **Status:** Superseded — roster-backed amendment Accepted in design spec §15 (2026-07-26)  
- **Date:** 2026-07-26  
- **Claims:** 36-c1, 07-announce-01 · Conflict C-07  

### Context

Draft `docs/superpowers/specs/2026-07-25-roster-backed-ladder-design.md` could remove Commit/BeefNet rank sync and defer guild-chat spectacle while main design still locked `/g` + Commit.

### Options

1. Ignore draft; promote main-spec spectacle immediately as law  
2. Treat draft as current law  
3. Keep main-spec path as working assumption until §15 Accept/Reject  

### Decision (original Accepted stance)

Option **(3)** — watch the Draft; keep Commit→`/g` as interim law until §15 resolved.

### Supersession (2026-07-26)

Design spec §15 now **Accepts** the roster-backed amendment. Product law:

- Church titles from live guild roster (fixed `rankIndex` map)  
- Standing → promote suggestions; officers promote in Blizzard guild UI  
- Addon `RANK_COMMIT` soft-ignored; guild-chat promote announce **deferred**  
- V1 playtest spectacle = edge toast + officer queue + visible Ladder move  

Do not revive Commit→`/g` polish goals without a new §15 row for a roster-diff announcer.

### Links

[36] · [52] · design spec §15 roster-backed Accept · [2026-07-25-roster-backed-ladder-design.md](../../superpowers/specs/2026-07-25-roster-backed-ladder-design.md)

---

## ADR-0007: Process stays out of design-spec algorithms

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Claims:** 52-gap-01, 54-auth-01 · Conflict C-10  

### Context

Temptation to paste Reflexion/swarm/score factories into design spec ([52]).

### Options

1. Full polish OS in design §10/§13  
2. **Pointers + optional minimal §15 rows (human PASS; channels); algorithms in UI brief/skill/research**  
3. Zero mention in product docs  

### Decision

We will **(2)**. Prefer UI brief + skill for process; design spec only for product-normative one-liners if maintainers want them.

### Consequences

+ Spec stays product law  
− Process discoverability depends on AGENTS/brief links  

### Links

[52] · [49] · [54]

---

## ADR-0008: Do not promote kill-list items

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Claims:** 49-kill-01, 42-out-01, 35-pixel-01  

### Context

Research fashion pushes juice OS, swarms, Media, pixel CI, overnight Ralph.

### Decision

We will **explicitly NOT promote** into rules/skills/product docs:

- Unbounded critique loops; ≥3-agent UI swarms; Best-of-N visual races  
- Juice framework / tween bus / intensity matrices / particle seals  
- Custom Media/SFX in V1 Task 7–10; WA center pulses; standing StatusBar  
- Streamer Mode; SecureActionButton panel openers; Ace hard deps  
- Pixel CI / VLM-as-PASS; client process control; overnight unattended UI Ralph  
- Desktop quality scores as substitute for `/reload` + guild-night  
- Research notes as product law without §15  

### Consequences

+ Protects ship schedule ([49])  
− Some craft ambitions wait for post-V1  

### Links

[49] kill-list · [42] · [22b] non-goals

---

## ADR-0009: Adopt roadmap as sequencing, not law

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Claims:** 53-seq-01, 53-claim-01  

### Context

[53](53-master-roadmap-proposal.md) integrates checklist + polish + juice phases + hands-off OS.

### Options

1. Replace `v1-checklist.md` with M0–M8 as completion law  
2. **Treat M0–M8 as recommended sequencing; checklist + §13 remain completion law**  
3. Ignore roadmap  

### Decision

We will **(2)**. Optional later promote of milestone names into `docs/phases/` after human accept — never as substitute for dated checklist walk.

### Consequences

+ Clear agent sequencing  
+ Preserves honest V1 complete gate  

### Links

[53] · `docs/phases/v1-checklist.md`

---

## ADR-0010: UI brief absorbs juice vocabulary

- **Status:** Accepted — Accepted by user 2026-07-26  
- **Date:** 2026-07-26  
- **Claims:** 39-hier-01, 39-tier-01, 52-gap-01 · from [39] §8 / [52] P0  

### Context

Largest agent briefing hole is juice/tiers/motion/critique vocabulary missing from `ui-polished-direction-for-agents.md` ([52], [39]).

### Decision

On Accept, merge **thin** slices into the UI brief: juice hierarchy, T0/T1 table, motion budget, critique obligations, “Done for UI polish,” **announce/ToS ban bullets from [50]**, **perf reject pointers from [51]**, settings-budget restatement, pointers to [30]/[29]/[42]/[49]/[50]/[51]. Do **not** paste full research essays. Scarce seats = stronger T1 only (never T2 theater).

### Consequences

+ Highest-leverage promote for craft **and** safe spectacle  
− Brief grows — keep pointer-heavy; ban bullets beat essays  

### Links

[39] · [52] · [50] · [51] · `docs/superpowers/ui-polished-direction-for-agents.md` · [`00-PROMOTE-CHECKLIST.md`](00-PROMOTE-CHECKLIST.md) Step 2

---

## Acceptance protocol

For each ADR a human wants to bind:

1. Change status `proposed` → `accepted` (or `rejected`) with date + name  
2. Execute matching steps in [`00-PROMOTE-CHECKLIST.md`](00-PROMOTE-CHECKLIST.md)  
3. If product-normative, also log in design spec §15 / glossary  
4. Do **not** silently rewrite Accepted ADRs — supersede with a new ID ([33](33-parallel-synthesis-methods.md))
