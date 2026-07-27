# 36 — CoB rules / skills / agent-map gap audit

**Date:** 2026-07-26  
**Scope audited:** `.cursor/rules/`, `.cursor/skills/`, `AGENTS.md`, `docs/superpowers/`, `OPTIMIZATIONS.md`  
**Lens:** Hands-off polish-loop development · juice / UI expertise · effective agent goals  
**Status:** Research audit (guidance). Does **not** change product law.  
**Related research (unwired expertise):** this folder — especially `11`, `14`, `16`, `22`, `24`, `25`, `27`, `29`, `30`, `31`.

---

## 0. Executive summary

Church of Beef already has a **strong safety + architecture harness** (always-on rules, install/reload skill, UI doctrine brief, locked design §10/§15). It does **not** yet have an **executable polish operating system** for agents.

The `agent-polish-vision/` track now holds the missing process and juice expertise (definition of done, critique rubric, stop conditions, goal templates, celebration/timing/color notes). Almost none of that is linked from `AGENTS.md`, the project skill, `verification.mdc`, the V1 plan, or `OPTIMIZATIONS.md`.

**One-line gap:** Agents can ship functional Classic UI safely; they cannot run a hands-off *implement → measure → critique → stop* polish loop without the human pasting research paths into the prompt.

---

## 0b. Sourced practices

| Lens | Practice sources |
|------|------------------|
| Hands-off / goals | [21](21-cursor-agent-loops-goals.md), [28](28-hands-off-cursor-workflows.md), Cursor hooks/cloud docs |
| Polish loop | [24](24-definition-of-done-polish.md), [25](25-ui-polish-critique-rubric.md), [29](29-superpowers-loop-patterns.md), [30](30-writing-effective-agent-goals.md), [31](31-loop-stop-conditions.md) |
| Juice expertise (unwired) | [11](11-game-juice-fundamentals.md), [14](14-celebration-spectacle-design.md), [15](15-procedural-ui-animation.md), [16](16-timing-curves-recipes.md) |
| Inventory truth | Live read of `.cursor/rules/`, skill, `AGENTS.md`, superpowers docs (see §8) |

---

## 1. Inventory — what exists

### 1.1 `.cursor/rules/` (15 files)

| File | Mode | Primary job |
|------|------|-------------|
| `architecture-overview.mdc` | alwaysApply | Repo map, layers, authority table, safety invariants |
| `verification.mdc` | alwaysApply | Done-means, install/reload, agent must-nots, research≠law |
| `addon-module-layers.mdc` | globs `addon/**/*.lua` | Module map + coupling |
| `lua-cob-modules.mdc` | globs addon Lua | Style / COB conventions |
| `toc-lifecycle.mdc` | TOC + addon | Load order / events |
| `canon-data.mdc` | Data + canon docs | Numbers only in `Ranks.lua` |
| `build-packaging.mdc` | TOC / pkg / CI | Install/zip/Interface |
| `packaging-assets.mdc` | Media + TOC | Fallbacks, consent, no tip jars |
| `ladder-authority.mdc` | Core ladder/scoring | Revisions, seats, Commit |
| `scoring-coplay.mdc` | Scoring cores | Caps, anti-AFK, suggestions |
| `officer-guild-roster.mdc` | Officer / Net / Officer UI | Rank-index gate |
| `beefnet-messaging.mdc` | Net | Prefix, GUILD, throttle, spectacle line |
| `wow-ui-taint-lockdown.mdc` | UI + bootstrap | Insecure frames, taint footguns |
| `wow-performance.mdc` | Addon tree | Idle closed, no permanent OnUpdate |
| `testing.mdc` | tests + Core/Data | Offline harness how-to |

**Strengths for polish-adjacent work**

- Hard bans agents need (no bots, no Retail APIs, UI↛points, Core↛`CreateFrame`).
- UI taint + performance rules prevent common “juice” disasters.
- Verification already requires in-game smoke when UI/Net/SV/slash touched; spectacle called out as untestable offline.

**Absent from rules (vs polish-loop vision)**

- No implement→critique→fix loop, iteration caps, or “polish: PASS requires human.”
- No pointer to critique rubric (`25`) / DoD (`24`) / stop conditions (`31`).
- No juice vocabulary (anticipation / feedforward / brand-in-words ceremony sizing).
- Authority table in `architecture-overview` omits `ui-polished-direction-for-agents.md` and the decision glossary (those live in `AGENTS.md` / UI brief only).
- No ban on false completion language (“looks polished,” “should work”) for UI claims (research `29` §2 P1 asks for this).

### 1.2 `.cursor/skills/` (1 skill)

| Skill | Role today |
|-------|------------|
| `church-of-beef-dev/SKILL.md` | Resolve `ADDON_ROOT`, run `lua tests/run.lua`, `WOW_ADDONS_DIR` install, `/reload` smoke, optional zip; §5 points at UI brief before `CreateFrame` |

**Present:** Operational Evaluator half of a polish loop (mechanical + client smoke).  
**Missing (explicitly recommended by `29-superpowers-loop-patterns.md` §4.2):** a **§ Polish loop** that names critique pass, rubric, stop conditions, and “harness ≠ spectacle.”  
**Missing:** Dedicated `church-of-beef-polish` skill (open question in research `29` §6).  
**Missing:** Goal-template refusal (“make it nicer” → require `30` anatomy).

### 1.3 `AGENTS.md`

| Covered | Not covered |
|---------|-------------|
| Workspace root vs worktree | `docs/research/agent-polish-vision/` (research library row points only at `wow-classic-addon-design/`) |
| Spec / plan / UI brief / Ranks / skill / rules | Critique rubric, DoD polish, stop conditions, goal templates |
| “UI work is agent-executed” + canvases note | Hands-off polish-loop procedure; adversarial review topology |
| Rules-at-a-glance table | Juice expertise index (timing, celebration, empty states, color) |
| Key don’ts (safety / layers) | “Do not claim polish PASS without human + evidence pack” |

### 1.4 `docs/superpowers/`

| Artifact | What it gives agents | Polish-loop fitness |
|----------|----------------------|---------------------|
| `specs/2026-07-25-church-of-beef-design.md` | Product law §10 UI, §13 success (incl. social spectacle), §15 decisions | Excellent constitution; not a loop |
| `specs/2026-07-25-roster-backed-ladder-design.md` | **Draft** amendment: roster = rank truth; removes Commit/BeefNet rank sync; **defers guild-chat promote spectacle** | Conflicts with main V1 spectacle story (see §3) |
| `ui-polished-direction-for-agents.md` | Authority order, read order, V1 bans, anti-patterns, phased agent jobs | Best in-repo UI doctrine; still no critique cycle / stop caps |
| `plans/2026-07-25-church-of-beef-v1.md` | Task file layout; Task 7+ in-game steps; Task 13 “Final polish” = checklist walk + API grep | Task 13 ≠ juice/critique loop; no rubric scores; no goal templates |

**Canvases (IDE, outside git tree):** `cob-v1-ui-build-prep`, `cob-polished-ui-north-star`, `cob-post-v1-art-commission`, `cob-polish-decision-cards`, `visual-polish-acceptance-checklist` (+ others). UI brief correctly says canvases are orientation; **durable gate for agents without canvases is under-specified** (brief says fall back to brief+spec+glossary — good — but acceptance checklist is canvas-only).

### 1.5 `OPTIMIZATIONS.md`

| Shipped | Backlog |
|---------|---------|
| Skill, rules consolidation, `AGENTS.md`, `.vscode`, `run-tests.sh`, GHA harness | Hooks, TOC drift CI, EmmyLua stubs, justfile, packager, MCP, v1-checklist fill |

**Absent from backlog:** polish-loop skill section; promote DoD/rubric into rules; visual QA protocol tooling; subjective quality harness ideas from research scrapes; “wire agent-polish-vision index into AGENTS.”

### 1.6 Research contrast — expertise that exists but is unwired

**Process / hands-off loop (high leverage, not in rules/skill/AGENTS)**

| Doc | Content agents need |
|-----|---------------------|
| `22-llm-critique-loops.md` | Constitution-gated generate→evaluate→reflect→revise; 2–3 round cap; separate critic |
| `24-definition-of-done-polish.md` | P0–P3 tiers; Gates A–E; critique rounds; human-only PASS |
| `25-ui-polish-critique-rubric.md` | 8×1–5 scorecard (Hierarchy…Taint); ship gates |
| `26-visual-qa-screenshot-protocol.md` | In-client visual evidence protocol |
| `27-multi-agent-adversarial-review.md` | Builder/Critic/Security/Perf/Meta topology for leaps |
| `29-superpowers-loop-patterns.md` | Composite polish loop + **explicit wiring ladder** into skill/rules/plan |
| `30-writing-effective-agent-goals.md` | 8-block goal anatomy + copy-paste templates |
| `31-loop-stop-conditions.md` | Score floors, diminishing returns, blocker taxonomy |

**Juice / UI expertise (high leverage for craft, not in rules/skill)**

| Doc | Content |
|-----|---------|
| `02` Lua vs XML + AnimationGroup juice | Construction decision tree |
| `03` Taint/lockdown for juice | Safe vs unsafe spectacle |
| `04` Media/fonts/textures | Anniversary-safe polish without Retail atlases |
| `05` Minimap / LDB | Tooltip juice; `/beef` remains door |
| `06` Guild roster UI | Ladder IA polish target |
| `07` Chat spectacle UX | `/g` craft, throttle feel |
| `08` SavedVars / settings UX | Tiny settings budget persistence |
| `09` Performance budgets | Juice cost classes |
| `10` Competitive addon case studies | Precedents |
| `11` Game juice fundamentals | Recognition > chrome clicks |
| `12` Social progression loops | Instant / session / legacy layers |
| `13` Rank ladder psychology | Goal-gradient, scarcity, no Council bar |
| `14` Celebration spectacle design | Beat sheets for promote |
| `16` Timing curves recipes | Toast/motion tokens |
| `18` Color hierarchy | Dual-encode; no loot rainbow |
| `20` Empty states / disclosure | Honesty vs sync myths |

**Scrapes:** ~32 `_search-*.json` + `.raw/` — background only; correctly excluded from product truth by `verification.mdc`.

**Series gaps inside research itself (not rules gaps, but note):** no `01`, `15`, `17`, `19`, `21`, `23`, `28`, `32–35` synthesis notes yet; no folder `README` / index linking process vs craft docs.

---

## 2. Gap analysis by lens

### 2.1 Hands-off polish-loop development

| Need (from research 22/24/29/31) | In rules/skill/AGENTS/superpowers/OPTIMIZATIONS? | Gap severity |
|----------------------------------|--------------------------------------------------|--------------|
| Explicit loop: implement → measure → critique → fix → stop | Partial: skill has measure; rules have done-means; **no critique/stop** | **P0** |
| Separate critic (fresh context / role) | Plan mentions subagent-driven-development; **no CoB-specific critic brief** | **P0** |
| Max iterations (2–3) + plateau stop | Only in research `24`/`31` | **P0** |
| Human-only polish PASS | Verification forbids claiming V1 complete; **allows agents to call a surface “polished” after smoke** | **P0** |
| Evidence pack before human ask | Implied by skill checklist; **no required critique log / rubric file** | **P1** |
| Durable ledger across compaction | SDD path mentioned in OPTIMIZATIONS / research; **not in AGENTS or skill** | **P1** |
| `/loop` recipes for CI/playtest (no WoW process control) | Research only; safety bans process control (good) | **P2** |
| Wire research into skill §Polish loop | Explicit recommendation in `29` §4.2 — **not done** | **P0** |
| Promote “no UI done claim without reload smoke” into always-on wording | `verification.mdc` already lists in-game for UI touches; **does not ban vibe language** | **P1** |

### 2.2 Juice / UI expertise

| Need | Where it lives today | Gap severity |
|------|----------------------|--------------|
| Doctrine + bans | UI brief + design §10/§15 + glossary | **Met** (durable) |
| Template / CreateFrame craft | UI brief + rules taint/perf + research `02` | Partial — research unwired |
| Toast / announce ceremony sizing | Spec + brief; recipes in `07`/`14`/`16` | **P1** — agents re-derive |
| Color / a11y dual-encode | Brief + research `18` | **P1** |
| Psychology (no hero StatusBar, Fresh Beef welcome) | Spec + research `12`/`13` | **P1** |
| Empty states / sync honesty | Research `20`; not in UI brief checklist | **P2** |
| Timing / AnimationGroup cookbook | Research `16`/`02`/`09` | **P1** |
| Critique dimensions for juice | Research `25` dim 3 | **P0** (unwired) |
| In-repo acceptance checklist (not canvas-only) | Canvas `visual-polish-acceptance-checklist`; brief fallback is thin | **P1** |

### 2.3 Agent goals

| Need (from research `30`) | Present? | Gap severity |
|---------------------------|----------|--------------|
| Refuse vague “make it nicer” | No skill/rule trigger | **P0** |
| 8-block goal anatomy (intent, AC, critique budget, stop, handoff) | Research only | **P0** |
| Example goals (toast, promote spectacle, BeefNet) | Research `30` templates | **P1** to surface |
| Artifacts on disk (critique.md, QA note) | Not required by skill | **P1** |
| Plan Task 7+/13 accept criteria cite polish DoD | Plan has in-game steps; **no rubric/DoD** | **P1** |
| Orchestrator leap topology (`27`) | Not in AGENTS | **P2** |

---

## 3. Contradictions & friction

| # | Tension | Why it hurts polish agents |
|---|---------|----------------------------|
| **C1** | Main design §10/§13/§15: guild-chat promote spectacle is V1 success. Roster-backed amendment (**Draft**): spectacle **deferred**; Commit/BeefNet rank sync removed. | Agents polishing announce/toasts/Commit can implement against the wrong constitution if they pick the amendment without status check. |
| **C2** | `architecture-overview` / ladder rules assume BeefNet `RANK_COMMIT` authority model; roster amendment voids it. | Domain rules + Net polish goals diverge until amendment is accepted or rejected in §15. |
| **C3** | `wow-ui-taint-lockdown.mdc` prefers “AceGUI / custom / LibUIDropDownMenu” vs EasyMenu; UI brief / deps ban AceAddon hard deps. | Soft contradiction: AceGUI ≠ AceAddon, but agents may pull Ace stack. Prefer wording: “custom frames or LibUIDropDownMenu; no Ace* hard deps in V1.” |
| **C4** | UI brief lists canvas `visual-polish-acceptance-checklist` as QA gate; canvas is outside git. | Hands-off agents in environments without canvases under-verify polish. |
| **C5** | Plan Task 13 “Final polish” = checklist + grep Retail APIs; research DoD = rubric + critique + human PASS. | “Task 13 done” ≠ “polish PASS.” |
| **C6** | `AGENTS.md` research library → `wow-classic-addon-design/` only; polish-vision is the active juice/process track. | Agents never discover `22`–`31` unless told. |
| **C7** | `verification.mdc`: research is guidance; research `24`/`30` ask for mandatory critique before human. | Process stays optional → hands-off loops skip critique. |
| **C8** | Skill §5: “Prefer canvas cob-v1-ui-build-prep when available”; brief says spec wins over canvases. | Aligned if read carefully; agents may treat canvas as law. |
| **C9** | Two score systems in research: rubric `/40` (`25`) vs composite `S` 0–100 (`31`). | Orchestrators may mix bars; needs one promoted default. |
| **C10** | OPTIMIZATIONS “Where to put new guidance” has no row for polish-process research → skill/rules promotion path. | New polish docs keep accumulating unwired. |

---

## 4. What is already good (do not rebuild)

1. **Constitution exists:** design §10/§15 + UI brief + glossary rows 74–81.  
2. **Safety always-on:** verification + architecture prevent ToS/taint disasters during juice work.  
3. **Mechanical Evaluator exists:** `church-of-beef-dev` + `testing.mdc` + GHA.  
4. **Layer purity:** UI never awards points — correct for social juice.  
5. **Research track is rich:** process + craft notes for a full polish OS already written (2026-07-26).  
6. **Honest limits:** spectacle / guild-night reaction correctly marked as human product pass.

---

## 5. Prioritized gap list (actionable)

Ordered for **maximum hands-off polish leverage** first. Items are recommendations; implement only with human approval where they change always-on policy (`OPTIMIZATIONS.md` / §15).

### P0 — Wire the polish OS (blocking hands-off loops)

1. **Extend `church-of-beef-dev` skill** with § Polish loop pointing at `29` §3 + `24` DoD + `25` rubric + `31` stops; state harness ≠ spectacle; max 2–3 critique cycles.  
2. **Link `docs/research/agent-polish-vision/` from `AGENTS.md`** (process docs `22`/`24`/`25`/`29`/`30`/`31` + craft index); keep “research ≠ product law.”  
3. **Add always-on or skill-level ban on false polish claims:** no “polished / looks good” without Gate A–E evidence + critique log; polish PASS is human-only (`24` §7).  
4. **Resolve constitution fork C1/C2:** accept/reject roster-backed amendment in design §15 (or mark amendment clearly superseded) so spectacle/Commit polish goals have one law.  
5. **Surface goal template:** agents must use `30` anatomy (or refuse) for any “polish / juice / make UI nicer” request.

### P1 — Make juice expertise discoverable and measurable

6. **UI brief optional-depth table:** add polish-vision craft docs (`11`, `14`, `16`, `18`, `20`, `02`, `03`) beside wow-classic tracks.  
7. **In-repo acceptance checklist** (promote canvas rows into `docs/superpowers/` or phases) so QA is not canvas-dependent.  
8. **Plan Task 7+ / Task 13:** require offline + in-client + rubric critique steps; cite `24`/`25`; separate “checklist walked” from “polish PASS.”  
9. **Clarify AceGUI wording** in `wow-ui-taint-lockdown.mdc` vs V1 no-Ace deps.  
10. **Pick one score bar** for agents (recommend: `25` scorecard for craft + Gate A–E from `24`; treat `31` composite as orchestrator optional).  
11. **OPTIMIZATIONS backlog row:** “Promote polish-loop skill section / DoD pointers” + “AGENTS index for agent-polish-vision.”  
12. **Artifact convention:** e.g. critique notes under worktree `artifacts/` or `.superpowers/sdd/` (never WTF).

### P2 — Orchestration & DX (nice for leaps, not day-one)

13. **Optional dedicated skill** `church-of-beef-polish` vs section-only (open question `29` §6) — decide once.  
14. **Document leap topology** from `27` in AGENTS for large UI/Net leaps (Builder → Verifier → Critic → Meta → Fixer).  
15. **`/loop` recipes** for CI-green re-critique and playtest reminders (`29` §4.3) — never client automation.  
16. **Visual QA protocol** (`26`) summarized in skill for humans attaching screenshots.  
17. **Research folder README/index** listing process vs craft docs; fill missing series numbers only if needed.  
18. **Architecture authority table:** add UI brief + glossary as read-order pointers (without duplicating policy).

### P3 — Explicit non-goals (keep out of rules)

- Do **not** install unbounded Ralph overnight UI loops without client smoke (`29` §4.5).  
- Do **not** promote research scrapes / `.raw/` to product law.  
- Do **not** add always-on rules for timing curves / psychology essays — keep craft in research + UI brief pointers.  
- Do **not** claim V1 complete from polish rubric alone — still need `docs/phases/v1-checklist.md` + guild-night social check.

---

## 6. Suggested wiring ladder (lightest → heaviest)

Matches research `29` §4; repeated here as the audit recommendation:

| Step | Change | Approval |
|------|--------|----------|
| 1 | Prompt paste: use `29` §3 + `25` + evidence gate | None |
| 2 | `AGENTS.md` index + skill § Polish loop | Maintainer |
| 3 | Plan Task 7+/13 verification bullets cite DoD/rubric | Maintainer |
| 4 | `verification.mdc` one paragraph: polish claims / human PASS | Maintainer (always-on) |
| 5 | Optional polish skill + OPTIMIZATIONS checkboxes | Human opt-in |
| 6 | Spec §15 if process becomes mandatory product law | Product owner |

---

## 7. Coverage matrix (summary)

| Capability | Rules | Skill | AGENTS | Superpowers | OPTIMIZATIONS | Research track |
|-----------|:-----:|:-----:|:------:|:-----------:|:-------------:|:--------------:|
| Safety / layers | ● | ◐ | ● | ● | ◐ | ◐ |
| Install / reload / harness | ◐ | ● | ● | ◐ | ● | ◐ |
| UI doctrine / bans | ◐ | ◐ | ● | ● | ○ | ● |
| Juice craft recipes | ○ | ○ | ○ | ◐ | ○ | ● |
| Critique rubric | ○ | ○ | ○ | ○ | ○ | ● |
| Polish DoD + stops | ○ | ○ | ○ | ○ | ○ | ● |
| Agent goal templates | ○ | ○ | ○ | ○ | ○ | ● |
| Adversarial leap topology | ○ | ○ | ○ | ◐ plan SDD | ○ | ● |
| Hands-off loop (executable) | ○ | ○ | ○ | ○ | ○ | ● (unwired) |

● = present · ◐ = partial / pointer only · ○ = missing

---

## 8. Sources consulted

- `.cursor/rules/*.mdc` (all 15)  
- `.cursor/skills/church-of-beef-dev/SKILL.md`  
- `AGENTS.md`, `OPTIMIZATIONS.md`  
- `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`  
- `docs/superpowers/specs/2026-07-25-roster-backed-ladder-design.md`  
- `docs/superpowers/ui-polished-direction-for-agents.md`  
- `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`  
- `docs/research/agent-polish-vision/*.md` (24 synthesis notes as of audit)  
- Cursor project canvases inventory (presence check only)

---

## 9. CoB-specific application

This audit is already CoB-scoped. Immediate application order (do not implement from this note alone — maintainer approval):

1. **Prompt-only:** paste Goal + polish loop from [30](30-writing-effective-agent-goals.md) / [29](29-superpowers-loop-patterns.md) until wired.  
2. **Index:** add `agent-polish-vision/` row to `AGENTS.md` research library.  
3. **Skill:** add § Polish loop to `church-of-beef-dev` (or optional polish skill — open).  
4. **Rules:** one short paragraph in `verification.mdc` banning false polish completion language.  
5. **Never** fork rank numbers or UI doctrine into research as if they were law.

---

## 10. Agent rules (derived from gaps)

1. When doing UI polish, load rubric [25](25-ui-polish-critique-rubric.md) + DoD [24](24-definition-of-done-polish.md) even if unwired from `AGENTS.md`.  
2. Do not claim the rules/skills harness already includes a polish OS — it does not (see §0).  
3. Do not invent a second always-on rule for juice encyclopedias; keep expertise in this folder until promoted.  
4. Prefer lightest wiring ladder (§6) over shipping a 50-agent swarm ([49](49-adversarial-overengineering.md)).  
5. If research changes product decisions, update design spec §15 — do not leave forks only in this audit.

---

## 11. Open questions

1. Dedicated `church-of-beef-polish` skill vs § inside `church-of-beef-dev`? ([29] §6)  
2. Is `verification.mdc` the right home for “no polish PASS without human,” or only the skill?  
3. Should canvases be listed in `AGENTS.md` as optional, or stay IDE-local only?  
4. Promote timing/celebration pointers into UI brief ([39](39-ui-direction-standards-expansion.md)) before or after M0 process wiring ([53](53-master-roadmap-proposal.md))?  
5. Re-audit after roster-backed ladder amendment lands — Commit/announce assumptions may shift.

---

## 12. Changelog

| Date | Note |
|------|------|
| 2026-07-26 | Initial gap audit vs hands-off polish-loop / juice / agent-goal lenses |
| 2026-07-26 | Added CoB application / agent rules / open questions sections for series completeness |
