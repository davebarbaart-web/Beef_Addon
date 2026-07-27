# 00-SYNTHESIS-ADVERSARIAL — Hostile review of the polish-vision SYNTHESIS pack

**Lane:** `docs/research/agent-polish-vision/`  
**Date:** 2026-07-26  
**Role:** Fresh adversary (not the reduce author)  
**Reviewed:** [`00-SYNTHESIS.md`](00-SYNTHESIS.md) · [`00-ADR-log.md`](00-ADR-log.md) · [`00-PROMOTE-CHECKLIST.md`](00-PROMOTE-CHECKLIST.md) · [`00-INDEX.md`](00-INDEX.md)  
**Governors:** [49](49-adversarial-overengineering.md) · [50](50-adversarial-tos-safety.md) · [51](51-adversarial-performance-vs-juice.md) · [36](36-cob-rules-skills-gap-audit.md)  
**Product law:** `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` §2 / §10 / §13.11 / §15  

> Research ≠ product law. This note does **not** Accept ADRs or edit `.cursor/` / product docs.  
> Minimal Blocker patches were applied to SYNTHESIS / ADR-0010 / PROMOTE-CHECKLIST (see §Patches).

---

## Verdict (one screen)

The reduce is **directionally right**: thin promote, kill juice OS, human PASS, authority stack restated, [49] kill-list preserved. It is **not safe to treat as a complete agent briefing surface** without the ToS announce corridor and settings-budget honesty that [50] + design §10 already lock.

**Blockers found:** 4 (all patched in-pack).  
**Safe to promote now:** discovery-only wiring (AGENTS index) + keeping research as research.  
**Needs human decision:** roster amendment (ADR-0006), celebration tier lock into glossary, any always-on rule / skill install, UI brief merge content.

---

## Severity-ranked findings

### Blocker

| ID | Finding | Attack | Fix / status |
|----|---------|--------|--------------|
| **B1** | SYNTHESIS §A under-specified announce safety | Agents reading only SYNTHESIS + juice hierarchy could invent peer `/g` echo, multi-line liturgy, announce-on-suggestion, or mute-Commit-via-opt-out. [50] C1–C8 / A5 are product-adjacent hard bans; pack previously pointed at [50] only for Secure*/Retail. | **Patched:** §A.1 MUST-NOTs for officer-only, no peer echo, no liturgy/sync announce, opt-out = chat only, auto-congrats/Secure*/tip jars/RAID_WARNING. PROMOTE Step 2 + ADR-0010 now require thin [50] bullets. |
| **B2** | “mute-by-type when settings allow” vs locked settings budget | Design §10 / §15: V1 prefs = position + minimap + announce; **toast mute only if playtest proves noise**; **no per-event announce filters**. “Mute-by-type” reads as settings sprawl / filter matrix — contradicts product law and [49] kill #11. F4 overclaimed mute as high-confidence V1. | **Patched:** F4 + §A.3 caps + PROMOTE Step 2 settings restatement. |
| **B3** | F9 / scarce-seat wording licensed T2+/Epic | “T2+/Epic parked **(or scarce-seat only)**” can be read as Council/Prophet unlocking Epic theater. Spec spectacle = one `/g` + edge toast; [50] forbids multi-line / center pulses. | **Patched:** F9 + §A.3 — scarce seats = stronger **T1** copy/dwell only; T2 stays parked. |
| **B4** | PROMOTE Step 2 could land juice vocabulary without ToS/perf bans | Highest-leverage promote (UI brief) listed hierarchy/tiers/motion but omitted [50]/[51]. That is how unsafe spectacle advice ships “as craft.” | **Patched:** Step 2 absorb list + ADR-0010 decision text. |

### Major

| ID | Finding | Attack | Recommendation |
|----|---------|--------|----------------|
| **M1** | Step 3 embeds ADR-0003 without requiring Accept | Skill § hardcodes “max 2 critique rounds” while Step 0 only required 0001/0002/0006/0008/0010. Silent conflict: process law lands without its ADR. | **Patched:** Step 0 minimum includes **0003**; Step 3 requires 0002+0003. |
| **M2** | “Accept 0001–0010” ritual invites process factory | [49] / [36] want lightest wiring. Accepting ten ADRs at once recreates the polish OS the pack claims to defer. | **Patched:** “Do not Accept-all in one ritual.” Humans: Accept per step. |
| **M3** | Motion ms bands looked normative | §A.4 “enter ~160–300 ms” + slide px read as MUST; F12 correctly says low confidence / needs smoke. Agents will cargo-cult timing recipes ([49] attack surface 3). | **Patched:** mark provisional; cite F12; forbid uiScale confusion; add [51] dirty-paint / idle notes. |
| **M4** | LibDBIcon “if deps allow” temptation | Soft path to Ace/LDB hard deps for “collector-friendly” polish. C-06 / plan: plain button OK. | **Patched:** plain button V1-default; LibDBIcon only if already a dep. |
| **M5** | ADR-0006 vs Step 2 Commit→`/g` vocabulary | Main spec still locks officer `/g`; draft roster amendment defers it ([36] C1). Pack correctly OPEN-flags but UI brief merge still teaches Commit-centric T1. Risk: agents polish announce against wrong constitution if Draft later wins. | Keep working-assumption language; **human must Accept/Reject Draft before** glossary / §15 locks; do not treat Step 2 as resolving C-07. |
| **M6** | Score-bar stack still heavy for agents | Gates A–E + brief checklist + [25] depth + optional [31] is three systems. ADR-0005 is right to demote [31], but Step 3 still points at [25] — fine if “depth,” bad if agents invent `/40` ship gates. | On skill § land: say **Gates + brief anti-patterns first**; [25] optional depth; never paste composite math. |
| **M7** | Soft overshoot / frame scale can reintroduce juice OS | Allowed “soft overshoot” / scale on toast title edges toward intensity recipes [49] kills. Frame-local scale ≠ `uiScale`, but agents blur the line. | Prefer Show/Hide + alpha; treat overshoot as optional one-shot; never document a tween bus. |
| **M8** | [53] roadmap in SYNTHESIS §C.5 | Even labeled “proposal,” M0–M8 next to DoD invites replacing `v1-checklist.md`. ADR-0009 is correct; Step 6 must stay checklist-primary. | Do not promote milestone names until human Accept of 0009 **and** checklist confusion is real. |
| **M9** | Missing human gate: announce copy / CTL | Pack correctly parks copy taste, but promote of “announce craft” (P2 / Task 13) without pointing at officer-only + CTL + ≤255 can still spam. | When Step 5/6 land, cite [50] pre-merge checklist, not only [07]/[14] craft. |
| **M10** | INDEX stale on reduce outputs | `00-INDEX` counts 3 reduce outputs; adversarial + patches not listed. Discovery gap for the next agent. | Nit-level index update (optional); not product-blocking. |

### Nit

| ID | Finding | Note |
|----|---------|------|
| **N1** | Claim-id soup | Useful for audit; hostile to agents. Promote must stay pointer-heavy, never paste claim tables into AGENTS/brief. |
| **N2** | “click-through” toast | Ambiguous (mouse-disabled vs click-dismiss). Prefer “non-modal; does not steal combat clicks.” |
| **N3** | Officer AttentionKit / RaidNotice | [50] allows local pending-queue AttentionKit; SYNTHESIS silent. OK omission if agents don’t invent RAID_WARNING from silence — Step 2 ban bullets cover S4. |
| **N4** | CERQual “high” on F1–F7 | Social spectacle success is human-gated; “high” is for *doctrine alignment*, not *empirically proven craft*. Don’t confuse with PASS. |
| **N5** | Handbook [54] / digests size | Lane is already a factory; SYNTHESIS reduce is the right compression. Resist promoting [54] wholesale (already in §G / non-promotes). |
| **N6** | AceGUI minority (E) | Correctly flagged; do not “resolve” by installing Ace*. |

---

## What to KEEP

Do not throw out the reduce because of B1–B4 — the spine is sound:

1. **Authority stack** — spec/glossary → UI brief → `20506`/always-on → research.  
2. **Juice hierarchy with `/g` first** — aligns §13.11; chat > toast > chrome.  
3. **V1 IN/OUT partition** — Media/SFX/StatusBar/WA/Streamer Mode/dashboard parked.  
4. **Role budget 1 + 0–1 critic** — [49] governor honored (ADR-0003).  
5. **POLISH:CANDIDATE vs human PASS vs V1 complete** — correct separation of powers.  
6. **ADR-0001 thin spine** — defer fat always-on [34] rules.  
7. **ADR-0002 skill § first** — not a second skill cult.  
8. **ADR-0006 OPEN freeze** — refuses silent constitution fork.  
9. **ADR-0008 kill-list promote ban** — juice OS / swarms / pixel CI / overnight Ralph.  
10. **ADR-0009 checklist remains law** — M0–M8 sequencing only.  
11. **PROMOTE lightest-first ladder** — Steps 1→3 before optional rules.  
12. **§G struck list** — matches [49] keep/kill spirit.  
13. **Honest limits** — agents cannot A/B criterion 11; harness ≠ spectacle.

---

## What to STRIKE or rewrite

| Location | Strike / rewrite |
|----------|------------------|
| SYNTHESIS F4 / §A.3 | ~~mute-by-type when settings allow~~ → coalesce + toast mute **post-playtest only**; no per-event filters (**done**) |
| SYNTHESIS F9 / scarce seats | ~~T2+/Epic … or scarce-seat only~~ → T2 parked; scarce = T1 copy only (**done**) |
| SYNTHESIS §A (pre-patch) | Missing [50] announce MUST-NOTs → **added** |
| SYNTHESIS §A.4 | Normative ms → **provisional** + [51] idle/dirty notes (**done**) |
| SYNTHESIS A.5 #4 | LibDBIcon soft sell → plain button default (**done**) |
| PROMOTE Step 2 | Juice without ToS/perf → **absorb [50]/[51] bullets** (**done**) |
| PROMOTE Step 0/3 | Accept set missing 0003; Accept-all ritual → **fixed** |
| ADR-0010 | Juice-only merge → include [50]/[51] + settings (**done**) |
| Still open (no silent rewrite) | Roster Draft vs main spectacle — **human §15 only** |
| Still open | Dedicated [37] skill, glossary T0/T1, toast dwell lock — **human after soak** |
| Do not promote | Full [25] scorecard, [31] composite math, [34] four rules, [53] as completion law, [54] handbook dump |

---

## Safe to promote now vs needs human decision

### Safe to promote now (discovery / research hygiene only)

These do **not** change product law or always-on behavior:

| Item | Why safe |
|------|----------|
| **PROMOTE Step 1** — `AGENTS.md` index row + “research ≠ law” one-liner | Closes [36] C6 discovery gap; no doctrine change |
| Keep all ADRs **Proposed** until human signs | Pack already says this |
| Point agents at `00-SYNTHESIS` + this adversarial note | Second-agent governor [49] asked for |
| Continue implementing against **current accepted** main spec | ADR-0006 option (3) — not Draft-as-law |

### Needs human decision (do not land quietly)

| Item | Why blocked on human |
|------|----------------------|
| **ADR-0006 / roster-backed Draft** | Constitution fork for Commit / BeefNet / `/g` ([36] C1/C2) |
| **PROMOTE Step 2** — UI brief merge | Product-facing craft + ToS bullets; Accept ADR-0010 (+ 0004 naming if tiers ship) |
| **PROMOTE Step 3** — skill § Polish loop | Changes ops skill; needs 0002+0003 Accept |
| **PROMOTE Step 4** — `verification.mdc` bullet | Always-on surface; even one bullet needs maintainer |
| **PROMOTE Steps 5–6** — plan / phases wording | Touches execution law / checklist semantics |
| **Step 7 optional rules / [37] skill / glossary T0/T1** | Premature rule factory until thin spine fails |
| **Toast mute / dwell → glossary** | Spec: only after playtest proves noise |
| **Celebration tiers as glossary 74 vs brief-only** | SYNTHESIS open Q4 |
| **Any claim of V1 complete or POLISH:PASS** | Human + checklist / guild-night only |

### Explicitly not safe (ever from this pack alone)

- Install all of [34] + [37] + swarm [27]  
- Juice framework / Media / SFX / StatusBar / WA center / Streamer Mode  
- Pixel CI / VLM PASS / WoW process control / overnight UI Ralph  
- Treating research CERQual “high” as ship authorization  
- Promoting Draft roster amendment by “polish convenience”

---

## Attack lenses (coverage)

| Lens | Result |
|------|--------|
| Over-engineering | Pack self-governs via [49]/ADR-0001/0008; residual risk = Accept-all + score-stack (M2/M6) |
| Product-law contradiction | B2 mute-by-type; B3 T2 scarce-seat; settings budget — **patched**. Roster fork remains OPEN (M5). |
| Unsafe spectacle | B1/B4 missing [50] corridor — **patched**. Watch announce-craft tasks (M9). |
| Performance footguns | §A.4 was motion-only; under-cited [51] — **patched** dirty coalesce / idle. Soft overshoot still a juice-OS nose (M7). |
| Premature rule factory | ADR-0001 good; Step 4 optional bullet OK if deferred; Step 7 correctly gated. |
| Missing human gates | PASS/V1 complete correct; M1 skill-without-0003 **patched**; C-07 still human. |
| Silent conflicts | C-07 vs Step 2 vocabulary; 0003 vs Step 0; [50]/[51] absent from promote — addressed or flagged. |

---

## Patches applied this pass (minimal)

| File | Change |
|------|--------|
| [`00-SYNTHESIS.md`](00-SYNTHESIS.md) | F4/F9 wording; §A.1 ToS MUST-NOTs; §A.3 caps/scarce seats; §A.4 provisional ms + [51]; A.5 LibDBIcon default; §I adversary pointer |
| [`00-PROMOTE-CHECKLIST.md`](00-PROMOTE-CHECKLIST.md) | Step 0 Accept set + anti-Accept-all; Step 2 [50]/[51]/settings; Step 3 requires ADR-0003 |
| [`00-ADR-log.md`](00-ADR-log.md) | ADR-0010 decision includes [50]/[51] + scarce-seat clarification |

**Not edited:** `.cursor/rules/`, skills, design spec, UI brief, plan, phases, glossary.

---

## Recommended human sequence (after this review)

```text
1. Read SoF + §G + this adversarial note
2. Accept ADR-0001 + 0008 (governor) — no file edits required
3. Optionally land Step 1 (AGENTS index) — safe discovery
4. Decide ADR-0006 (roster Draft) before treating Commit→/g polish as immutable law
5. Accept 0010 (+0004 if desired) → Step 2 UI brief with ToS/perf bullets
6. Accept 0002+0003 → Step 3 skill §
7. Defer Step 4–7 until thin spine fails or checklist confusion is real
```

---

## Bottom line

**Keep the thin spine. Strike settings sprawl and T2 loopholes. Never promote juice vocabulary without the [50] announce corridor.**  
Blocker count after patch: **0 open in-pack** (4 found, 4 patched). Remaining ship risk is **human process** (Accept-all, C-07, brief merge quality) — not missing research.

---

## Return summary (for orchestrator)

| Field | Value |
|-------|--------|
| Path | `docs/research/agent-polish-vision/00-SYNTHESIS-ADVERSARIAL.md` |
| Blockers found | **4** (B1–B4; patched in SYNTHESIS / ADR / PROMOTE) |
| Blockers still open | **0** in-pack; constitution C-07 remains human |
| Safe to promote now | AGENTS index (Step 1); keep ADRs Proposed; main-spec implementation continuing under ADR-0006 watch |
