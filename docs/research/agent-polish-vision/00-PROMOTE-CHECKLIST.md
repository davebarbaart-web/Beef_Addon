# 00-PROMOTE-CHECKLIST — Thin wiring into AGENTS / skills / rules / UI brief

**Lane:** `docs/research/agent-polish-vision/`  
**Date:** 2026-07-26  
**Status:** Thin promote **executed** 2026-07-26 — see [`00-PROMOTE-STATUS.md`](00-PROMOTE-STATUS.md)  
**Governor:** [49](49-adversarial-overengineering.md) kill-list — prefer thin promote over swarming forever  
**Standards:** [`00-SYNTHESIS.md`](00-SYNTHESIS.md) · **ADRs:** [`00-ADR-log.md`](00-ADR-log.md) (all **Accepted** 2026-07-26)

> **Hard rules for this checklist**  
> - Research ≠ product law until Accepted + landed in the target file.  
> - Do **not** edit `.cursor/rules/` or install skills in the research wave itself.  
> - Do **not** claim V1 complete.  
> - Do **not** promote kill-list items (ADR-0008).  
> - Skip any step whose ADR is Rejected.

---

## Principle

```text
Lightest first → prove compliance → only then add always-on / second skill
```

Matches [36](36-cob-rules-skills-gap-audit.md) §6 and ADR-0001/0002.

---

## Ordered steps (minimal)

### Step 0 — Preconditions (human)

- [x] Read [`00-SYNTHESIS.md`](00-SYNTHESIS.md) SoF + §G struck list  
- [x] Accept or Reject ADRs **0001–0010** — **Accepted by user 2026-07-26** (full package; thin landing only)  
- [x] **ADR-0006:** Accepted stance — main-spec Commit→`/g` remains law until Draft formally merged into §15; Draft watched, not adopted  
- [x] Confirm workspace remains `Beef_Addon` root (so `.cursor/` applies)  
- [x] Thin promote (not rule factory) — Steps 1–6 landed; Step 7 optional rules deferred  

**Exit:** Written Accept/Reject on ADR log (status lines).

---

### Step 1 — `AGENTS.md` index (ADR-0001 / [36] P0)

**Target:** `/Volumes/AI_Design_Drive/Beef_Addon/AGENTS.md`  
**Change (minimal):**

1. In “Where to look” table, add row:

   | Agent polish research (process + juice; ≠ law) | `docs/research/agent-polish-vision/` — start at `00-SYNTHESIS.md` / `00-INDEX.md` |

2. Optional one-liner under Rules at a glance / How to run:

   > Polish / juice asks: Goal anatomy ([30](30-writing-effective-agent-goals.md)); loop ([29](29-superpowers-loop-patterns.md)); stop ([31](31-loop-stop-conditions.md)); governor ([49](49-adversarial-overengineering.md)). Research ≠ product law.

**Do not:** paste rubrics, score math, or full celebration essays into AGENTS.md.

**Exit:** Agents can discover the lane without a human paste.

---

### Step 2 — UI brief thin merge (ADR-0010 / [52] P0 / [39] §8)

**Target:** `docs/superpowers/ui-polished-direction-for-agents.md`  
**Absorb from** [39](39-ui-direction-standards-expansion.md) + [`00-SYNTHESIS.md`](00-SYNTHESIS.md) §A — **thin**:

- [x] Juice hierarchy (chat > toast > in-panel > motion > SFX > art)  
- [x] Celebration tiers **T0 / T1** (+ alias note Small/Medium; T2+/Epic out; scarce seats = stronger T1 only)  
- [x] Motion budget (no permanent OnUpdate; no center WA; short self-clearing fades OK; ms bands provisional)  
- [x] **Announce / ToS corridor** from [50](50-adversarial-tos-safety.md): officer-only one `/g` line; no peer echo; no multi-line liturgy; no announce on suggestion/score/sync; opt-out = chat only; no auto-congrats / Secure* / tip jars / RAID_WARNING SFX  
- [x] **Perf reject pointers** from [51](51-adversarial-performance-vs-juice.md): idle quiet; dirty coalesce; no paint-per-message; no forever row/minimap animators  
- [x] Critique obligations (4 questions + “harness ≠ spectacle”)  
- [x] Done for UI polish = smoke + critique CANDIDATE + human PASS for spectacle  
- [x] Settings budget restated: position + minimap + announce; toast mute only post-playtest; no per-event announce filters / uiScale  
- [x] Pointers: [42](42-v1-vs-v2-juice-scope.md) IN/OUT · [30](30-writing-effective-agent-goals.md) · [29](29-superpowers-loop-patterns.md) · [49](49-adversarial-overengineering.md) · [50](50-adversarial-tos-safety.md) · [51](51-adversarial-performance-vs-juice.md)

**Do not:** unlock Media/SFX; invent brand hex; paste [25] full scorecard; reopen Standing StatusBar; paste full [50]/[51] essays (ban bullets only).

**Exit:** UI agents have shared vocabulary without opening 50 briefs.

---

### Step 3 — Skill § Polish loop (ADR-0002 + **ADR-0003** / [36] P0)

**Requires:** ADR-0002 **and** ADR-0003 Accepted (skill text embeds max 2 critique rounds / 1+0–1 roles).  
**Target:** `.cursor/skills/church-of-beef-dev/SKILL.md`  
**Add short section** (pointer-heavy, ~30–50 lines max):

```markdown
## Polish loop (UI / toast / announce / empty states)

1. Require a Goal (surface, acceptance, max 2 critique rounds) — research 30
2. Implement one V1-IN slice only — research 42; refuse V1-OUT
3. Mechanical verify (this skill § tests/install/reload)
4. Separate critique vs UI brief + research 25; fix P0/P1 only
5. Stop: clean / plateau / max rounds / reopen-locked — research 31, 49
6. Claim POLISH:CANDIDATE only; human PASS; never claim V1 complete
7. No WoW process control; no overnight unattended UI Ralph
```

Point at `docs/superpowers/ui-polished-direction-for-agents.md` (post–Step 2).

**Do not:** install separate `37` skill yet (ADR-0002); do not duplicate [54] handbook.

**Exit:** Hands-off polish path exists in the ops skill.

---

### Step 4 — `verification.mdc` one bullet (optional early / ADR-0001 deferred rules)

**Target:** `.cursor/rules/verification.mdc`  
**Add under Done means** (single bullet, not a new always-on file):

> **Polish / spectacle:** do not claim UI “polished/done” without `/reload` smoke for touched paths; guild-chat spectacle and POLISH:PASS are human/product passes — harness cannot prove them. See UI brief + skill § Polish loop.

**Do not:** add four new always-on rules from [34] in this step.

**Exit:** False completion language constrained without bloating always-on count.

---

### Step 5 — Plan Task 7–10 / 13 bullets ([52] P1)

**Target:** `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`  
**Minimal:**

- [ ] Global Constraints: polish claims need critique evidence; no Media/SFX in Tasks 7–10; cite [49]  
- [ ] Tasks 7–10: offline / in-game / anti-pattern acceptance shaped like [30]  
- [ ] Task 13: gated polish slices + human social check; **not** art commission  

**Do not:** redefine Task 13 as Media pass.

**Exit:** Executing agents stop treating Task 13 as “chore + claim polished.”

---

### Step 6 — Phases clarify polish ≠ V1 complete ([52] P2)

**Target:** `docs/phases/v1-checklist.md` (and lightly `guild-night-playtest.md`)

- [ ] Note: functional ticks ≠ automatic POLISH:PASS  
- [ ] Optional “UI polish evidence attached?” supporting check (no numeric rubric law)  
- [ ] Guild-night: label spectacle row as H3/H4 pointer to [32](32-human-checkpoint-handoff.md)

**Exit:** Checklist remains the only V1-complete gate.

---

### Step 7 — Optional later (only if Step 1–4 still fail)

| Item | ADR | Condition |
|------|-----|-----------|
| Glob rule `ui-juice-standards.mdc` from [34] §4.4 | 0001 revisit | UI agents still invent WA juice after brief merge |
| Picker rule `agent-polish-loop.mdc` | 0001 | Skill § ignored in practice |
| Thin always-on `agent-self-critique.mdc` **or** `major-leaps-per-prompt.mdc` (pick **one**, not both first) | 0001 / 0003 | Compliance drift proven |
| Extract [37](37-skill-draft-polish-loop.md) as dedicated skill | 0002 | Skill § exceeds ~80 lines |
| Design spec §13.1 / §15 one-liners (human PASS; harness ≠ spectacle) | 0007 | Maintainers want normative process rows |
| Glossary rows for T0/T1 if product-locked | 0004 | After brief soak + guild night |
| `docs/phases/` milestone names from [53] | 0009 | Sequencing confusion persists |
| `OPTIMIZATIONS.md` backlog row for polish wiring | [36] | Tracking hygiene |

**Hard cap:** do not jump from Step 1 to “install all of [34] + [37] + swarm [27].”

---

## Explicit non-promotes (stop here)

Do **not** wire any of these (ADR-0008 / [49]):

1. Unbounded critique / Ralph overnight on UI  
2. Multi-agent polish swarms (≥3 on one frame tree)  
3. Juice OS / tween bus / intensity matrices  
4. Custom Media / SFX / heraldry as “final polish”  
5. Pixel CI / VLM PASS / client automation  
6. Always-on dump of full UI brief or [54] handbook  
7. Score-factory math into design spec  
8. Research scrapes / `_search-*.json` as acceptance evidence  

---

## Smoke after promote (when files land)

| Change | Smoke |
|--------|-------|
| AGENTS.md only | New chat: agent finds `00-SYNTHESIS` when asked about polish |
| UI brief | Open UI file ask → agent cites T0/T1 + bans |
| Skill § | Ask “polish toasts” → skill path + max 2 critique rounds |
| verification bullet | Agent refuses “polished” without reload path |
| UI/Net code (if any) | `lua tests/run.lua` + install → `/reload` → `/beef` |

---

## Definition of done for *this promote*

- [x] Steps **1–3** landed (AGENTS + UI brief + skill §)  
- [x] Step **4** landed (`verification.mdc` polish bullet)  
- [x] ADR log statuses updated for what shipped  
- [x] No kill-list item introduced  
- [x] No claim that V1 is complete  
- [x] Steps 5–6 light pointers landed; Step 7 optional rules **deferred**  

**Enough process:** agents can run Goal → verify → critique → stop → human without a 50-brief paste.  
**Not enough to invent:** a juice platform or rule cult ([49](49-adversarial-overengineering.md)).

---

## Quick map: step → sources

| Step | Primary briefs |
|------|----------------|
| 1 AGENTS | [36], [52], [00-SYNTHESIS] |
| 2 UI brief | [39], [14], [42], [11b], [00b] |
| 3 Skill § | [29], [24], [25], [31], [37], [49] |
| 4 verification | [34] §5.1 (thin), [24], [22b] |
| 5 Plan | [52], [30], [40], [49] |
| 6 Phases | [52], [32], [53] |
| 7 Optional rules | [34], ADR-0001 |
