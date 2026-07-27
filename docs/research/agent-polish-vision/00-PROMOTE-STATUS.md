# 00-PROMOTE-STATUS — Thin wiring landed

**Lane:** `docs/research/agent-polish-vision/`  
**Date:** 2026-07-26  
**Trigger:** User accepted full polish-vision package (ADRs 0001–0010)  
**Governor:** [49](49-adversarial-overengineering.md) — thin promote, not a 50-agent rule factory  
**Wiring audit:** [`00-CURSOR-WIRING-AUDIT.md`](00-CURSOR-WIRING-AUDIT.md) (re-verified 2026-07-26)

> Research ≠ product law. Agents may claim **POLISH:CANDIDATE** only.  
> Do **not** claim V1 complete or tick human checklist boxes from this promote.

---

## Promoted (landed)

| Step | Target | What landed |
|------|--------|-------------|
| 0 | [`00-ADR-log.md`](00-ADR-log.md) | ADRs **0001–0010** Accepted 2026-07-26; **ADR-0006 Superseded** the same day by roster-backed §15 Accept. |
| 1 | `AGENTS.md` | Index tightened (SYNTHESIS + adversarial + ADR + this status); polish/juice one-liner; pointer that major UI polish uses brief + skill §; Rules table lists glob `ui-juice-standards`; link to wiring audit. |
| 2 | `docs/superpowers/ui-polished-direction-for-agents.md` | Juice hierarchy; T0/T1 (+ aliases); motion/perf budget; settings budget; critique checklist + stop caps; Done labels; roster-backed constitution (ADR-0006 superseded). Classic shell / Media / SFX / center WA **still locked out**. |
| 3 | `.cursor/skills/church-of-beef-dev/SKILL.md` | § **Polish loop** (BIR: verify→critique→revise, ≤2 revises, human PASS). Description triggers polish/juice/spectacle; documents “§ is enough” (no second skill). |
| 4 | `.cursor/rules/verification.mdc` | Bullet 7: `POLISH:CANDIDATE` only; human PASS / V1 complete; pointer to synthesis. |
| 5 | Plan | Global Constraints polish pointer; Task 7 acceptance note; Task 13 “not art commission / polish ≠ V1 complete”. |
| 6 | `docs/phases/v1-checklist.md` + `guild-night-playtest.md` | Polish ≠ V1 complete note; optional polish-evidence supporting check; H3/H4 spectacle pointer. |
| — | `.cursor/rules/architecture-overview.mdc` | Major UI polish → brief + skill § + juice glob; not a rule factory. |
| — | `.cursor/rules/ui-juice-standards.mdc` | **Glob** (not always-on): T0/T1, announce bans, motion, critique Qs — ADR-0001 preferred follow-up. |
| — | `OPTIMIZATIONS.md` | Approval-needed backlog: `stop` hook (Core/Data), Cloud `environment.json`, Cloud scope ban (from [28](28-hands-off-cursor-workflows.md)). **Not implemented.** |
| — | [`00-CURSOR-WIRING-AUDIT.md`](00-CURSOR-WIRING-AUDIT.md) | Audit of live wiring vs Accepted ADRs; confirms thin spine sufficient. |

---

## Deferred (explicit)

| Item | Why |
|------|-----|
| Separate skill from [37](37-skill-draft-polish-loop.md) | ADR-0002 — skill § first; § still ≪ 80 lines → **skill § is enough** (audit) |
| Always-on `major-leaps` / `agent-self-critique` / picker `agent-polish-loop` from [34](34-cursor-rules-polish-proposal.md) | ADR-0001 + adversarial Step 7 — revisit only if thin spine fails in practice; juice **glob** already landed |
| Glossary rows for T0/T1 as product law | Brief-only until soak + guild night (open Q4) |
| Design spec §13.1 / §15 process one-liners | ADR-0007 — optional later if maintainers want normative process rows |
| [53](53-master-roadmap-proposal.md) M0–M8 names into phases | ADR-0009 — sequencing guidance only; checklist remains completion law |
| Toast mute / dwell → glossary | Spec: only after playtest proves noise |
| Unlock Media / SFX / center WA / StatusBar | ADR-0008 kill-list + V1 OUT |
| Hooks / Cloud env implementation | Listed in `OPTIMIZATIONS.md`; needs human approval |
| Roster-diff `/g` announce | Deferred by roster-backed amendment §2 / §14 until playtest asks for it |
| [34] patches to `wow-ui-taint-lockdown` / `wow-performance` juice rows | Nice-to-have; covered by juice glob + existing OnUpdate / Secure* bans |

---

## Wiring audit result (2026-07-26)

| Finding | Result |
|---------|--------|
| Thin spine (AGENTS → brief → skill § → verification) | **Complete** vs Accepted ADRs |
| UI brief vs SYNTHESIS absorb list (ADR-0010) | **Complete** |
| `ui-juice-standards.mdc` | **Present** (was under-indexed in prior status); tightened this pass |
| Second polish skill [37] | **Not installed** — intentional; skill § enough |
| [34] four-rule factory | **Not installed** — intentional; only juice glob |
| Kill-list / Media unlock / V1-complete claim | **Clean** |
| Addon Lua this pass | **None** — Anniversary reinstall skipped |

---

## Next human playtest gates

| Gate | Who | Evidence |
|------|-----|----------|
| **H0 / H1** [`solo-smoke.md`](../../phases/solo-smoke.md) | Human | Install + `/reload` + roster ladder + suggestion → guild-UI promote |
| **H2** Optional two-client `SUGGESTION` fanout | Officer+ + Member | Petition appears on officer queue; ranks still from roster |
| **H3** Spectacle craft | Deferred | Roster-diff `/g` announcer not in V1; edge toast + Ladder move only |
| **H4** Guild night | Human | [`guild-night-playtest.md`](../../phases/guild-night-playtest.md) pacing + roster promote |
| **H5** Full `v1-checklist.md` walk | Human | Dated ticks — only then claim V1 complete |
| **Polish PASS** | Human | Per-surface craft sign-off after `POLISH:CANDIDATE` |

Agents prepare artifact packs ([32](32-human-checkpoint-handoff.md)); they do not self-PASS.

---

## Kill-list compliance

No juice OS, no UI swarm rules, no Media/SFX unlock, no pixel CI, no overnight UI Ralph, no claim of V1 complete from this wiring pass.

---

## Addon UI impl (same day)

Parallel UI agents landed on `addon/ChurchOfBeef/` (not the empty worktree). Reconcile + harness note: [`00-IMPL-STATUS.md`](00-IMPL-STATUS.md). Pre-playtest readiness plan (2026-07-26) aligned docs/copy/status to roster-backed solo smoke. Offline suite green; still **POLISH:CANDIDATE** only until human [`solo-smoke.md`](../../phases/solo-smoke.md).
