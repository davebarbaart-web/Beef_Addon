# 00-SYNTHESIS — Unified agent-polish standards

**Lane:** `docs/research/agent-polish-vision/`  
**Date:** 2026-07-26  
**Status:** L2 research standards (Phase D–H reduce) — **not** product law  
**Playbook:** [33](33-parallel-synthesis-methods.md)  
**Working papers:** [`_wave-synthesis-inventory.md`](_wave-synthesis-inventory.md) · [`_wave-synthesis-claims.md`](_wave-synthesis-claims.md) · [`_wave-synthesis-clusters.md`](_wave-synthesis-clusters.md) · [`_wave-synthesis-conflicts.md`](_wave-synthesis-conflicts.md)  
**ADRs:** [`00-ADR-log.md`](00-ADR-log.md) (all **Accepted** 2026-07-26) · **Promote:** [`00-PROMOTE-CHECKLIST.md`](00-PROMOTE-CHECKLIST.md) · **Status:** [`00-PROMOTE-STATUS.md`](00-PROMOTE-STATUS.md)

> **Authority stack (do not invert):** design spec / glossary → UI agent brief → Anniversary `20506` APIs & always-on rules → this research.  
> Research ≠ product law. Do not claim V1 complete. Prefer thin promote ([49](49-adversarial-overengineering.md)).

Every MUST/MUST-NOT below cites `claim_id`s from the claim index unless marked `[glue]`.

---

## Summary of findings (CERQual-adapted)

| # | Finding | Conf. | Key claim_ids |
|---|---------|-------|---------------|
| F1 | V1 spectacle = throttled officer `/g` + private edge toast; never center WA | **high** | 11b-filter-02/03, 07-announce-01, 42-in-01 |
| F2 | Juice hierarchy: chat > toast > in-panel > short motion > SFX > art | **high** | 39-hier-01, 11-kelly-01, 11b-filter-04 |
| F3 | Motion: short purposeful fades; no permanent OnUpdate / shake / particles / idle glow | **high** | 11b-filter-01/05, 16-time-01, 09-perf-01, 56-ag-01 |
| F4 | Hideable minimap + coalesce toasts; settings stay starved (toast mute only post-playtest) | **high** | 00b-toast-01, 00b-mini-01, 08-set-01 |
| F5 | Polish loop = hard verify → separate critique → capped revise → human PASS | **high** | 22b-bir-01, 24-pass-01, 31-stop-01, 22b-human-01 |
| F6 | Default ship path: 1 implementer + optional 1 critic; no UI swarm | **high** | 49-kill-01, 49-keep-01, C-09 |
| F7 | V1 IN/OUT partition blocks Media/SFX/StatusBar/dashboard polish | **high** | 42-in-01, 42-out-01, 24-tier-01 |
| F8 | Wire polish OS thinly (AGENTS → skill § → brief); rules optional | **moderate** | 36-wire-01, 52-gap-01, 34-rules-01 |
| F9 | Celebration tiers T0/T1 for V1; T2+/Epic parked (scarce seats = stronger T1 copy only) | **moderate** | 14-tier-01, 39-tier-01, C-03 |
| F10 | Agent score bar = Gates A–E + brief checklist; [25] depth; [31] optional | **moderate** | 25-rubric-01, 52-score-01, C-04 |
| F11 | Roster-backed amendment may fork Commit/`/g` assumptions | **open** | 36-c1, C-07 |
| F12 | Exact ms toast dwells / AnimationGroup edge cases need client smoke | **low** | 16-time-01, 56-ag-01 |

---

## A. WoW Classic UI / juice craft

### A.1 Non-negotiables (Anniversary social guest UI)

| MUST / MUST-NOT | Claims |
|-----------------|--------|
| MUST target `## Interface: 20506`; no Retail-only APIs | 50-retail-01 |
| MUST use Classic templates + opaque high-contrast + `GameFont*` | 42-in-01, 24-gate-01 (B2/B3) |
| MUST dual-encode status; class color on **names** only | 18-dual-01 |
| MUST NOT set `uiScale` / `UIParent:SetScale` | 11b-filter-06 |
| MUST NOT use Secure* / protected paths for ceremony chrome | 03-taint-01, 50-tos-01 |
| MUST NOT award points or invent ranks from UI/Net | 48-layer-01 |
| MUST NOT ship custom `Media/` / mandatory SFX in V1 | 11b-filter-04, 42-out-01 |
| MUST NOT peer-echo `/g` on `RANK_COMMIT` / sync; announce = approving officer only | 50-C1/C2, 07-announce-01 |
| MUST NOT multi-line liturgy, announce on suggestion/score/login sync, or re-announce without dedup | 50-C3/C4/C5 |
| MUST NOT treat announce opt-out as mute-Commit or mute-toast | 50-C6, design §10 |
| MUST NOT auto-congrats bots, center WA pulses, RAID_WARNING SFX, tip jars, Secure* panel openers | 50-A5/J1/S4/P1/A2 |

### A.2 Juice hierarchy (spend from the top)

1. **Guild chat** — one throttled promote/demote line (officer; announce default ON) — 07-announce-01, 39-hier-01  
2. **Private edge toast** — addon users; queue-capped; non-modal; click-through — 11b-filter-02, 00b-toast-01  
3. **In-panel feedback** — rebind, highlight, dual-encode — 11-hicks-01  
4. **Short motion** — alpha/offset/scale on Beef frames; self-clear — 16-time-01, 56-ag-01  
5. **SFX** — post-V1, default off — 11b-filter-04  
6. **Custom art** — post-V1 art pass — 42-out-01  

If a promotion night skips (1), polish has failed §13.11 even if (2)–(4) look great — 39-hier-01, 22b-human-01.

### A.3 Celebration tiers (unified naming)

| Tier | Alias ([14](14-celebration-spectacle-design.md)) | Triggers | Channels | V1? |
|------|--------------------------------------------------|----------|----------|-----|
| **T0** Private | Small | Suggestion; Gora/ceremony credit | Edge toast only | YES |
| **T1** Social | Medium | Officer Commit promote/demote | Officer `/g` + recipient toast | YES |
| **T2+** / Epic | Epic / theater | Dashboards, SFX stacks, center theater | Beyond V1 budget | NO (park) |

**Caps:** one guild line (officer-origin); concurrent toast ≈ 1 (coalesce); toast mute only if playtest proves noise (not per-event announce filters); promote dwell > credit — 46-conc-01, 00b-toast-01, design §10.  
**Scarce seats (Council/Prophet):** longer toast dwell / stronger copy **inside T1 only** — never unlocks T2+/Epic, center pulses, or multi-line `/g` — 14-tier-01, 50-C3.

### A.4 Motion / perf budget

| Allowed | Forbidden |
|---------|-----------|
| Show/Hide + short alpha; brief `AnimationGroup`/`C_Timer` on Beef frames (self-clear; idle = no updater) | Permanent `OnUpdate` for juice/scoring/net |
| Toast slide/offset small; **provisional** enter ~160–300 ms (smoke before locking) | UIParent shake, full-screen flash, particles, ModelFrame ceremonies |
| Local row highlight; optional one-shot title scale (frame-local — never `uiScale`/`UIParent:SetScale`) | Idle breathing glow; tab crossfade of whole shell; per-row forever animators |
| Coalesce bursts; dirty-flag paint ≤~10 Hz when open; no full ladder rebuild per toast/message | Combat-fovea center modality; paint-per-`CHAT_MSG_ADDON` |

Claims: 11b-filter-01/05, 16-time-01, 09-perf-01, 56-ag-01, 11b-filter-02, 51-R1/R4. Exact ms bands = F12 (low confidence).

### A.5 Chrome community rules (from [00b](00b-community-threads-digest.md))

1. Hideable always-visible chrome (minimap) with persisted pref — 00b-mini-01  
2. Never center-modal celebrate — 00b-toast-01  
3. Mute by event type; coalesce — 00b-toast-01  
4. Collector-friendly minimap — **plain hideable button is V1-default**; LibDBIcon only if already a dep (do not add Ace/LDB hard deps for polish) — C-06  
5. Rank as glance signal (tooltip / standing) — 00b-guild-01  
6. No shame UX — 00b-guild-01  

### A.6 Critique questions (before “done” on UI)

From [34](34-cursor-rules-polish-proposal.md) / [39](39-ui-direction-standards-expansion.md):

1. Would a member without the addon still notice a promotion?  
2. Does chrome still read as Blizzard if custom tint fails?  
3. Can an officer Approve in combat without taint pain?  
4. Is announce still one throttled line with opt-out honoring SV?

---

## B. Cursor loops / goals / hands-off polish

### B.1 Taxonomy (keep distinct)

| Primitive | Job | Claims |
|-----------|-----|--------|
| **Rules** | Short persistent policy | 21b-tax-01 |
| **Skills** | How to run a loop (install/reload/polish) | 21b-tax-01, 37-skill-01 |
| **Hooks** | Mechanical allow/deny/followup (`OPTIMIZATIONS.md`) | 21b-ralph-01 |
| **Goals** | Task contracts with AC + stop | 30-goal-01 |
| **Ralph** | Fresh-process grind | ≠ Cursor `/loop` — 21b-ralph-01 |

### B.2 Default CoB polish loop (BIR)

```text
DECLARE surface + tier (P0|P1|P2) + Goal
  → IMPLEMENT one vertical slice
  → HARD VERIFY (harness if Core/Data; TOC; install→/reload→path)
  → RUBRIC CRITIQUE (separate role/session; ≤2 revise rounds)
  → FIX P0/P1 only → re-verify
  → STOP (see §D) → HUMAN CANDIDATE→PASS
  → Ledger; never claim V1 complete
```

Claims: 22b-bir-01, 29-loop-01, 40-leap-01, 24-pass-01. Sources: [22b](22b-agentic-critique-sources.md), [29](29-superpowers-loop-patterns.md), [54](54-development-standards-handbook.md).

### B.3 Role budget (V1)

| Role | Count | Claims |
|------|------:|--------|
| Implementer | 1 | 49-keep-01 |
| Critic | 0–1 | 22b-writer-01, 49-kill-01 |
| Meta-debate / ≥3 UI agents | **0** | 49-kill-01, C-09 |
| Parallel research explorers | OK | 49 (research only) |

### B.4 Goals

- Refuse “make it nicer / premium” without Goal anatomy — 30-goal-01  
- Pack major leaps (one observable path) — 40-leap-01  
- Templates: [30](30-writing-effective-agent-goals.md); handbook shape: [54](54-development-standards-handbook.md) §5  

### B.5 Hands-off constraints

| MUST | MUST NOT |
|------|----------|
| External verify outside the prompt (harness, TOC) | Trust “I promise” / vibe done |
| Cap iterations + spending awareness | Unattended ambiguous UI polish |
| New chat / plan when context saturates | Overnight UI Ralph without H1 smoke |
| Human PNG for visual QA | Automate WoW client / pixel CI |

Claims: 00b-loop-01, 21b-ralph-01, 26-vqa-01, 35-pixel-01, 22b-human-01.

---

## C. CoB-specific V1 scope + celebration

### C.1 What V1 is (process UI + social announce)

From [49](49-adversarial-overengineering.md) / [42](42-v1-vs-v2-juice-scope.md) / spec:

- Social guild ladder + officer Commit + BeefNet sync  
- Spectacle budget = `/g` + edge toast; Classic shell; brand in words  
- Silent; no custom Media; Standing = text thresholds  
- Success criterion 11 = human guild-chat reaction — agents cannot A/B it  

### C.2 V1 IN (polish allowed)

Process UI shell/tabs/ladder/standing text/officer IA · edge toasts · announce craft · minimap hide+tooltip · empty/sync honesty · dual-encode · short fades — 42-in-01, 53 M2.

### C.3 V1 OUT (park)

Media/heraldry · SFX packs · standing StatusBar · WA center · Streamer Mode · tip jars · AceAddon/Masque/SharedMedia hard deps · ceremonial dashboard / confessions · juice OS / tween bus · settings sprawl beyond position/minimap/announce — 42-out-01, 49 kill-list.

### C.4 Settings budget

| Pref | V1 |
|------|-----|
| Frame position | Always |
| Minimap show/hide | Yes |
| Announce opt-out | Yes (default ON) |
| Toast mute | Only if guild-night proves noise |
| Else | Out |

Claim: 08-set-01.

### C.5 Roadmap sequencing (proposal — not checklist substitute)

[53](53-master-roadmap-proposal.md): **M0** process wire → **M1** functional spine → **M2** P0–P1 juice → **M3** two-client → **M4** guild night P2 → **M5** human V1 declaration → M6–M8 post-V1.  
Do **not** pull V2 theater into M2 — 53-seq-01, 42-out-01.

### C.6 Polish tiers ↔ juice

| Polish tier ([24](24-definition-of-done-polish.md)) | Juice |
|----------------------------------------------------|-------|
| P0 Process UI | Shell, tabs, empty states, officer IA |
| P1 Feedback | Edge toasts, micro-motion, dual-encode |
| P2 Social spectacle | `/g` craft + §13.11 |
| P3 Art/SFX | Post-V1 only |

---

## D. Verification / DoD / stop conditions

### D.1 Done means (mechanical — always)

From `verification.mdc` + 24-gate-01 / 49-keep-01:

1. `lua tests/run.lua` exit 0 when Core/Data/harness changed  
2. TOC truth; Interface `20506`  
3. Safety: no bots/injection/protected bypass/Retail APIs  
4. UI/Net/SV/slash → install → `scriptErrors 1` → `/reload` → path  
5. BeefNet/officer → two clients  
6. Do **not** claim V1 complete until `docs/phases/v1-checklist.md` walked  

Green harness ≠ V1 done ≠ polish PASS — 53-claim-01, 22b-human-01.

### D.2 Polish DoD language

| Label | Who | Meaning |
|-------|-----|---------|
| **POLISH: CANDIDATE** | Agent | Gates pass + critique clean enough to ask human |
| **POLISH: PASS** | Human only | Signed craft/spectacle for that surface/tier |
| **V1 complete** | Human only | Full dated checklist incl. guild-night |

Claim: 24-pass-01. Ban vibe language (“looks polished,” “should work”) without evidence — [54](54-development-standards-handbook.md) §3.4.

### D.3 Agent-facing score bar (provisional)

1. **Gates A–E** from [24](24-definition-of-done-polish.md) (binary)  
2. **UI brief anti-patterns + C-checklist** (when [39](39-ui-direction-standards-expansion.md) merged)  
3. **[25](25-ui-polish-critique-rubric.md)** dimensions as depth (≥3 polish-ready; taint/perf higher bar)  
4. **[31](31-loop-stop-conditions.md)** composite — orchestrator optional only  

Resolution: C-04 / ADR-0005.

### D.4 Stop conditions (any one)

| Stop | Action |
|------|--------|
| Hard Gate A fail | Abort polish; fix functional |
| Critique clean (no P0/P1) + evidence green | Ship CANDIDATE / hand off |
| Nit-only / plateau / oscillating taste | Park debt; stop |
| Max **2** critique→revise rounds (**3** Actor attempts) | Best-so-far or escalate — C-02 |
| Finding `reopen_locked` | Reject finding; do not iterate |
| Product ambiguity | BLOCKED — escalate §15; do not invent |
| Cannot smoke UI/Net | BLOCKED — handoff pack [32](32-human-checkpoint-handoff.md) |

Claims: 31-stop-01, 31-best-01, 49-kill-01.

### D.5 Human checkpoints (H0–H5)

[32](32-human-checkpoint-handoff.md) / [53](53-master-roadmap-proposal.md): H0 install → H1 smoke → H2 two-client → H3 spectacle → H4 guild night → H5 full V1 walk. Agents prepare artifact packs; they do not self-PASS.

---

## E. Minority / signal-critical

| Item | Status | Why kept |
|------|--------|----------|
| Roster-backed ladder Draft may defer `/g` / Commit | **OPEN** C-07 | Wrong constitution if agents polish announce against draft |
| AceGUI wording vs no-Ace hard deps | Minority | Prefer custom/LibUIDropDownMenu; no Ace* hard deps — [36] C3 |
| LibDBIcon as community standard vs plain button | Resolved provisional C-06 | Hideability > library brand |
| Exact toast dwell ms (3.5–8 s bands) | Low confidence | Needs guild-night / stream smoke — [14],[16] |
| AnimationGroup quirks on `20506` | Low | Verify in client — [56] |
| Dedicated polish skill vs skill § | Provisional C-05 | Section-first |
| Process rows in design §15 | Provisional C-10 | Prefer brief+skill |

---

## F. Open questions (human)

1. Accept or reject **roster-backed ladder** before locking promote-spectacle polish goals? ([36](36-cob-rules-skills-gap-audit.md), [52](52-gap-analysis-product-docs.md))  
2. Install any of [34](34-cursor-rules-polish-proposal.md) always-on rules, or stop at AGENTS + skill §?  
3. Dedicated [37](37-skill-draft-polish-loop.md) skill vs section-only?  
4. Promote celebration tier table into glossary 74 vs UI brief only?  
5. After one guild night, lock toast mute / dwell into glossary?  

---

## G. Struck / do-not-promote

From [49](49-adversarial-overengineering.md) + adversarial reduce:

- Unbounded Writer↔Critic loops; ≥3-agent UI swarms; Best-of-N visual races on locked chrome  
- Juice framework / tween bus / particle seals / custom Media during Task 7–10  
- WA center pulses, screen flash, camera shake, chat-frame hijack anim  
- Standing hero StatusBar; Streamer Mode; SecureActionButton panel openers  
- Pixelmatch CI; VLM as polish PASS; overnight unattended UI Ralph  
- Promoting research process notes to product law without §15  
- Claiming V1 complete from harness or agent aesthetic vote  
- Dumping full UI brief into `alwaysApply: true`  

---

## H. Coverage gaps

| Gap | Note |
|-----|------|
| Thin external sourcing on mid/late series | [00-thoroughness-audit.md](00-thoroughness-audit.md) Top 15 deepen queue — standards still usable |
| Discord FAQ transcripts | [00b] honest gap — public invites only |
| Canvas-only acceptance checklist | [36] C4 — promote in-repo rows when wiring UI brief |
| Claim index condensed (~90 not 400) | Time-boxed per [33]; revisit if ADR contested |

---

## I. Adversarial pass notes (reducer self-check)

| Risk | Mitigation in this reduce |
|------|---------------------------|
| Invented glue | Tier naming map marked provisional; authority stack restated |
| Majority wash of taint | C1 / signal-critical pile explicit |
| Desktop-only polish PASS | F5/F finding + §D forbid |
| Over-promoting [34] factory | ADR-0001 defers rules; checklist thin |
| Ignoring [49] | Kill-list copied into §G and promote checklist |
| Under-wiring [50]/[51] into §A | Announce MUST-NOTs + dirty-paint/OnUpdate envelopes added (adversarial 2026-07-26) |
| mute-by-type / T2 scarce-seat license | Struck; aligned to design §10 settings + T1-only scarce copy |

**Fresh-adversary:** [`00-SYNTHESIS-ADVERSARIAL.md`](00-SYNTHESIS-ADVERSARIAL.md) — re-read before any `.cursor/` / product-doc install.

---

## Related

- Index: [00-INDEX.md](00-INDEX.md)  
- ADRs: [00-ADR-log.md](00-ADR-log.md)  
- Promote steps: [00-PROMOTE-CHECKLIST.md](00-PROMOTE-CHECKLIST.md)  
- Handbook depth: [54](54-development-standards-handbook.md)  
- Roadmap proposal: [53](53-master-roadmap-proposal.md)
