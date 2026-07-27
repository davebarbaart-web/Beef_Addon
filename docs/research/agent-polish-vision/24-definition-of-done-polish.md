# Definition of Done — Professional polish agent loops

**Track:** `agent-polish-vision` · doc `24`  
**Audience:** Coding agents running UI / UX / juice polish loops; humans signing off polish claims  
**Status:** Research guidance for agent process — **not** product law  
**Locked product truth stays in:** design spec §10 / §15 · glossary rows 68–71, 74–81 · [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md)  
**Date:** 2026-07-26

---

## 0. Purpose

Agents over-claim “polished.” This DoD makes **professional polish** a gated loop with:

1. **Measurable gates** (binary / numeric — agent can fail itself)
2. **Subjective rubric scores** (1–5 dimensions — agent scores + peer critique)
3. **Mandatory critique rounds** (adversarial passes before any human ask)
4. **Human checkpoint criteria** (only a human can PASS polish)

Green `lua tests/run.lua` and a working `/beef` are **preconditions**, not polish.

---

## 1. Scope tiers (do not mix bars)

| Tier | Name | Surfaces | Polish bar |
|------|------|----------|------------|
| **P0** | Process UI | Frame shell, tabs, lists, settings budget, empty states, officer IA, StaticPopup confirms | Classic-native clarity + zero taint/noise |
| **P1** | Feedback juice | Private edge toasts, dual-encoded states, highlight/focus, micro-motion (Alpha/scale only if locked) | Readable, throttled, non-WA, non-spam |
| **P2** | Social spectacle | Guild-chat announce line craft, promote/demote visibility, officer announce checkbox | Stream-skimmable rite; §13.11 social check |
| **P3** | Art / SFX (post-V1) | `Media/`, seals, optional SFX default off | Only after P0–P2 earn it; glossary 79–80 |

**Rule:** A polish loop declares **one primary tier**. Cross-tier work is allowed only as hard-blocker fixes (e.g. toast clipping that breaks P0 readability).

**V1 agents:** P0 + P1 + P2 only. P3 is out of scope unless a human explicitly opens an art/SFX pass.

---

## 2. Authority & anti-fork

Before any polish edit:

1. Spec §10 / §15 and glossary 74–81 win over canvases and this research doc.
2. Rank titles / thresholds come only from `Data/Ranks.lua`.
3. New product choices → log in spec §15; do not leave them only in a PR or this file.
4. Research scrapes (`.firecrawl/`, `**/.raw/`, `_search-*.json`) are **not** acceptance evidence.

---

## 3. Loop contract

```
DECLARE tier + surface list
  → IMPLEMENT (small diff)
  → MEASURE (Gate A–E)
  → SELF-SCORE rubric (all axes)
  → CRITIQUE ROUND (mandatory; see §6)
  → FIX or STOP
  → HUMAN CHECKPOINT (see §7)
  → only then claim POLISH: PASS
```

| Rule | Detail |
|------|--------|
| Max agent iterations | **3** implement→measure→critique cycles without human input |
| Stop-and-ask | Any Gate A fail after 2 attempts; any rubric axis ≤2 after Round 2; any product-law conflict |
| No silent scope creep | Settings budget, Streamer Mode, custom Media, SFX, StatusBar standing — locked off for V1 |
| Evidence pack | Required before human checkpoint (§8) |

---

## 4. Measurable gates (binary — all must PASS)

### Gate A — Integrity (hard fail = abort polish)

| ID | Criterion | How to prove |
|----|-----------|--------------|
| A1 | Offline harness green when Core/Data/harness touched | `lua tests/run.lua` exit `0` from addon checkout |
| A2 | TOC truth | `ChurchOfBeef.toc` lists only existing files; `## Interface: 20506` unless intentionally bumped |
| A3 | Layer law | UI never awards points; Core never `CreateFrame`; Net never invents ranks |
| A4 | Safety | No bots, injection, protected-action bypass, Retail-only APIs, SecureActionButton-for-panel |
| A5 | Load smoke | Install → `/console scriptErrors 1` → `/reload` → zero Lua errors on load |
| A6 | Entry smoke | `/beef` and minimap toggle the **same** real frame; frame exists on fresh SV |

**Any A fail → not polishable. Fix functional defects first.**

### Gate B — V1 surface checklist (P0)

| ID | Criterion | Measurable test |
|----|-----------|-----------------|
| B1 | Tabs exactly Ladder / My Standing / Officer+ | Officer tab hidden when not Officer+; no extra tabs |
| B2 | Template-native chrome | Inherits Classic templates (`BasicFrameTemplate`, `UIPanelButtonTemplate`, `BackdropTemplate`, …); no glass/low-alpha panels |
| B3 | Fonts | `GameFont*` family only for body/labels in V1; no custom font files required |
| B4 | Color law | Class color on **names** only; pending/approve/reject dual-encoded (color **and** text/icon); no item-quality rainbow for ranks; no faction panel skins |
| B5 | Standing | Text thresholds only; **no** hero StatusBar / castbar/XP meter |
| B6 | Settings budget | Only position + minimap hide + announce opt-out; no uiScale/strata/per-event filters |
| B7 | Guest on player scale | Never set `uiScale` / `UIParent:SetScale`; frame parented/clamped correctly |
| B8 | Lists | Fixed row pools; no HybridScrollFrame; Faux only if overflow proven |
| B9 | High-risk confirms | Demote / Council / Prophet / standing wipe → `StaticPopup` with `preferredIndex = 3` (or `STATICPOPUP_NUMDIALOGS`) + named subject |
| B10 | Officer IA | Four zones visible: pending / evidence / rite controls / Recent Actions |
| B11 | Empty / degraded | Not-in-guild, empty ladder, empty pending queue — readable empty states, no nil FontString |
| B12 | Missing media | Delete/rename optional textures → addon still loads; fallbacks used |

### Gate C — Juice & feedback (P1)

| ID | Criterion | Measurable test |
|----|-----------|-----------------|
| C1 | Toast surfaces | Suggestion created, rank approved, Gora/ceremony credit each produce a **private edge toast** (not center-screen WA) |
| C2 | Toast budget | ≤ **2 lines**; ≤ **~90** characters total; one toast visible at a time (queue or coalesce) |
| C3 | Toast duration | Visible **≥3s and ≤6s** at default; does not cover chat edit box or bags at default anchors |
| C4 | Throttle | Burst of 5 events → no stack explosion; last meaningful state still readable |
| C5 | Motion | If any Alpha/scale tween: duration **≤0.35s**, ease-out, no bounce loops; combat: no protected calls |
| C6 | Silence | V1: **zero** `PlaySound` / `PlaySoundFile` on these paths |
| C7 | Highlight | Local player row on Ladder is dual-encoded (not color-only) |

### Gate D — Spectacle (P2)

| ID | Criterion | Measurable test |
|----|-----------|-----------------|
| D1 | Announce path | Approve promote/demote → **one** guild line from approving officer client only |
| D2 | Opt-out UX | Officer tab checkbox **“Announce promotions to guild chat”**; mirrors `ChurchOfBeefDB.ui.announce`; **default ON** |
| D3 | Line craft | Pattern matches locked voice (e.g. “The Church recognizes \<Name\>, elevated to \<Title\>.”); title from `Ranks.lua`; no meme spam / no tip jar |
| D4 | Length | Announce ≤ **120** characters; single line; no newlines |
| D5 | Throttle | Rapid double-approve / replay → **no** duplicate spam (CTL / anti-dup respected) |
| D6 | Privacy | No Streamer Mode code path that silently disables guild announce |
| D7 | Two-client | Officer approve → Member sees ladder update **and** (if announce on) guild sees the line |

### Gate E — Performance & hygiene

| ID | Criterion | Measurable test |
|----|-----------|-----------------|
| E1 | Show/hide | Opening `/beef` does not hitch combat-relevant FPS on a quiet city character (subjective note OK; no busy OnUpdate) |
| E2 | No per-frame waste | No unbounded `OnUpdate` when frame hidden; row rebinds on data change only |
| E3 | SV hygiene | Position save/restore survives `/reload`; announce default ON on fresh DB |
| E4 | Copy IDs | User-facing strings use stable IDs / constants where the build-prep canvas requires them — no hard-forked thresholds in UI strings |
| E5 | Packaging | No ripped Blizzard audio; no unexplained `Media/` in V1 polish; case-consistent `ChurchOfBeef*.lua` |

---

## 5. Subjective rubric (1–5 scores)

Score **after** Gates A–E for the declared tier. Use whole numbers only.

### 5.1 Axes

| Axis | 1 | 3 | 5 |
|------|---|---|---|
| **S1 Clarity** | Must re-read; hierarchy fights itself | Scannable after a beat | Instant: what is my rank / next step / officer job |
| **S2 Classic-native fit** | Retail glass / ElvUI-flat / WA pulse vibe | Mostly template-native with odd edges | Indistinguishable from good Classic process UI |
| **S3 Brand-in-words** | Generic “points updated” / corporate | Some church voice, uneven | Absurd institution voice on spectacle surfaces; officer UI stays procedural |
| **S4 Density discipline** | Details!-dense / meter dashboard | Acceptable with clutter pockets | One job per zone; whitespace earns trust |
| **S5 Juice restraint** | Over-animated or invisible feedback | Feedback present but noisy or timid | Moments feel earned; silence elsewhere |
| **S6 Stream / guild skim** | Announce/toast useless on stream | Readable if you stare | 1080p stream + guild chat skim in one glance |
| **S7 Officer trust** | Fat-finger nuclear rites; unclear evidence | Usable with care | Pending → evidence → rite feels like Gargul/RCLC authority, not a meme board |
| **S8 Empty / error grace** | Nil text, blank panels, scary errors | Survives; copy awkward | Degraded states teach the next action |

### 5.2 Pass thresholds

| Claim | Required |
|-------|----------|
| **POLISH: CANDIDATE** (agent may request human review) | All applicable Gates PASS; **every** scored axis ≥ **3**; mean ≥ **3.5** |
| **POLISH: PASS** (shippable polish for that tier) | Human checkpoint §7 PASS; **every** axis ≥ **3**; mean ≥ **4.0**; no axis marked “blocked by law conflict” |
| **POLISH: FAIL** | Any Gate fail, **or** any axis ≤ **2** after Critique Round 2, **or** human REJECT |

### 5.3 Scoring rules (anti-gaming)

- Self-score **before** critique; critique may **only lower or hold** scores (never raise without new evidence).
- Screenshot or in-client observation required for S1, S2, S5, S6.
- If an axis is N/A for the tier (e.g. S7 on a toast-only P1 loop), mark `N/A` and exclude from mean — **minimum 5 scored axes** for P0 loops.

---

## 6. Mandatory critique rounds

Polish is not done after the implementer smiles. Minimum structure:

### Round 1 — Adversarial self-critique (same agent, different role)

Produce a written critique answering **only** failure probes (not a changelog):

1. Which **anti-pattern** from the UI brief did I nearly ship? (WA pulse, glass, StatusBar standing, rainbow ranks, tip jar, SecureActionButton panel, ElvUI-as-brand, …)
2. What would a **hostile officer** fat-finger on this screen?
3. What would a **streamer at 1080p** miss in the first 2 seconds?
4. What string still sounds like **generic SaaS**?
5. What motion/toast would annoy in a **5-pull dungeon spam** session?
6. Did I invent a **product decision**? If yes → stop and log to §15 / ask human.

**Output artifact:** `polish-critique-r1.md` in the PR description or agent evidence pack (bullet answers, ≤40 lines).

### Round 2 — Fresh-eyes critique (required)

One of:

- A **second agent** with no implementer context (preferred), **or**
- Same agent after explicit context reset with only: screenshots + DoD + brief + “find reasons to REJECT”

Round 2 must:

- Re-score all rubric axes independently
- List **Top 5 REJECT reasons** (even if recommending PASS — empty list only if genuinely nothing)
- Flag any Gate A–E that looks unproven (missing evidence ≠ PASS)

If Round 2 mean < implementer mean by **≥0.5**, implementer may not average up — use the **lower** mean until a fix cycle.

### Round 3 — Human-facing delta (only if still CANDIDATE)

≤15 lines:

- What changed since Round 1
- Remaining risks
- Exact human checks requested from §7

**Mandatory:** Rounds 1 + 2 before any human is asked to PASS. Humans may optionally run Round 3 themselves.

---

## 7. Human checkpoint criteria

Agents may reach **CANDIDATE** only. **PASS requires a human** (maintainer / design owner / playtest lead).

### 7.1 Always required (any polish tier)

Human confirms:

| # | Check | PASS signal |
|---|-------|-------------|
| H1 | In-client Anniversary look | “Looks like Blizzard process UI, not a WA pack” |
| H2 | Script errors | BugGrabber/BugSack clean on the exercised path |
| H3 | No law fork | No new settings/SFX/Media/Streamer/standing-bar without §15 |
| H4 | Evidence pack complete | §8 items present; critiques attached |
| H5 | Rubric agreement | Human scores mean ≥ 4.0 **or** explicitly accepts CANDIDATE mean with written waivers |

### 7.2 Tier-specific human checks

| Tier | Human must do |
|------|----------------|
| **P0** | Open all three tabs; resize/move/clamp; `/reload` position; Officer+ vs Member; empty guild state if possible |
| **P1** | Trigger each toast type once; trigger burst; confirm edge placement and silence |
| **P2** | Two clients: approve a promotion with announce ON → see **one** guild line; toggle OFF → no line; confirm checkbox label/default |
| **P3** | Art/SFX review against commission brief; missing-media load; SFX default off |

### 7.3 Social spectacle human gate (P2 ship / V1 polish complete)

Mirrors spec §13.11 — **not optional** for claiming V1 spectacle polish:

- [ ] Real guild night (or scheduled two-human rehearsal): promotion announced in `/g`
- [ ] At least one **visible human reaction** in guild chat (emoji, reply, hype — not silence)
- [ ] Officer did not need a Discord cross-post for the moment to land

If the promotion is functionally correct but socially invisible → **POLISH: FAIL** for P2 even if Gates pass.

### 7.4 Explicit human REJECT reasons (non-exhaustive)

- “Feels like WeakAuras / Details!”
- “I don’t know what to click as officer”
- “Standing looks like an XP bar”
- “Announce is cringe / too long / meme-spam”
- “Too quiet — I missed my promotion”
- “Too loud — toast/announce storm”
- “Looks Scarlet-painted before we locked hex” (glossary 78/81)

---

## 8. Evidence pack (required for CANDIDATE)

Attach or link in the PR / agent handoff:

1. Declared **tier** + file list touched  
2. Gate A–E checklist with pass/fail + how proven  
3. Rubric table (self + Round 2) with means  
4. Critique Round 1 + Round 2 text  
5. Anniversary screenshots (minimum):
   - Ladder with local highlight  
   - My Standing text thresholds  
   - Officer four-zone (Officer+)  
   - One toast in situ  
   - Guild chat announce line (P2)  
6. Smoke notes: `/reload`, scriptErrors, two-client if Net/announce touched  
7. Explicit “did not add” statement: no Media / SFX / Streamer Mode / uiScale / StatusBar standing (V1)

Missing evidence → human must REJECT or return to agent (not silent PASS).

---

## 9. Master DoD checklist (copy into PR)

### Preconditions

- [ ] Tier declared: P0 / P1 / P2 / P3
- [ ] Read UI brief + spec §10/§15 + glossary 74–81 before `CreateFrame` edits
- [ ] Gate A integrity PASS

### Measurable gates

- [ ] Gate B (P0) PASS or N/A
- [ ] Gate C (P1) PASS or N/A
- [ ] Gate D (P2) PASS or N/A
- [ ] Gate E PASS

### Rubric

- [ ] Self-score complete (axes ≥3, mean ≥3.5 for CANDIDATE)
- [ ] Critique Round 1 written
- [ ] Critique Round 2 written + independent scores
- [ ] Lower-mean rule applied if Round 2 harsher
- [ ] Mean ≥4.0 target for PASS (human may waive in writing)

### Critique & human

- [ ] ≤3 agent fix loops (or stop-and-ask triggered)
- [ ] Evidence pack (§8) attached
- [ ] Human H1–H5 PASS
- [ ] Tier-specific human checks PASS
- [ ] P2: social reaction gate PASS (if claiming spectacle polish)
- [ ] No unresolved product-law fork

### Final claim

- [ ] **POLISH: PASS** for declared tier — human-signed, dated  
- [ ] Or **POLISH: CANDIDATE** returned with open questions  
- [ ] Or **POLISH: FAIL** with top REJECT reasons

---

## 10. What this DoD deliberately rejects

| Fake done | Why rejected |
|-----------|--------------|
| “Looks better in my head / desktop mock” | Anniversary client is visual truth |
| Green unit tests only | Harness does not prove UI/spectacle |
| One self-congratulating critique | Round 2 fresh eyes mandatory |
| Shipping custom art to “feel premium” | Glossary 80 — words + chat first |
| Adding settings to paper over bad defaults | Glossary 75 |
| Center-screen celebration | Spec ban — edge toast + `/g` only |
| Agent declaring PASS | Human checkpoint only |

---

## 11. Relationship to other docs

| Doc | Role |
|-----|------|
| [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) | Doctrine + anti-patterns |
| Design spec §10 / §13 / §15 | Product law + success criteria |
| Glossary 68–71, 74–81 | Normative UI locks |
| [`docs/phases/v1-checklist.md`](../../phases/v1-checklist.md) | Functional V1 completeness (wider than polish) |
| Canvas `visual-polish-acceptance-checklist` | In-client QA companion when present |
| This file | **Process DoD** for agent polish loops |

When this research DoD and the spec disagree, **spec wins** — update §15, then amend this doc.

---

## 12. One-line exit criterion

> **Polish is done when measurable gates pass, two critique rounds cannot find a must-fix, rubric means ≥4.0, and a human — after in-client Anniversary exercise — would rather show the guild the promote line than apologize for the UI.**

---

## 13. Expansion — BIR DoD vs autonomous “done” (2026-07-26)

**Sources:** [`22b-agentic-critique-sources.md`](22b-agentic-critique-sources.md); [Anthropic Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) (coding agents: automated tests help; **human review remains crucial** for system fit).

### 13.1 Three “done” layers (do not collapse)

| Layer | Who can PASS | Evidence |
|-------|--------------|----------|
| **Mechanical done** | Agent + harness | Gate A–E; `lua tests/run.lua` when in scope; TOC truth |
| **Critique done (CANDIDATE)** | Agent loop after Rounds 1–2 | Rubric floors; ≤3 fix cycles; evidence pack §8 |
| **Polish PASS** | **Human only** | In-client Anniversary smoke; P2 social reaction; no law fork |

Self-Refine / Reflexion literature shows loops can **plateau or degrade** without an external oracle ([Self-Refine](https://arxiv.org/abs/2303.17651); [Reflexion](https://arxiv.org/abs/2303.11366)). CoB’s oracle split: **deterministic gates** for Core/Data, **human eyes** for UI/spectacle.

### 13.2 Soft vs hard DoD items

| Hard (binary — no vibe) | Soft (rubric + human) |
|-------------------------|------------------------|
| Harness, TOC, layers, safety, Interface `20506` | S1–S8 axes, stream skim, “Classic-native feel” |
| Dual-encode presence, announce opt-out wiring | Whether toast “feels earned” |
| Two-client sync occurred (logged) | Whether guild **reacted** to `/g` line (§7.3) |

Agents may auto-FAIL hard items. Soft items may reach CANDIDATE; only humans PASS.

### 13.3 Stop-and-ask triggers (aligned with track 31)

Escalate to human **before** burning iteration 3 if:

- Any Gate A fail after 2 attempts  
- Critic demands locked post-V1 work (Media/SFX/Streamer/StatusBar standing)  
- Round 2 mean drops ≥0.5 vs Round 1 with no actionable fix  
- Oscillation (add glow → remove → add)

See [`31-loop-stop-conditions.md`](31-loop-stop-conditions.md) and [`22b`](22b-agentic-critique-sources.md) recommended loop.
