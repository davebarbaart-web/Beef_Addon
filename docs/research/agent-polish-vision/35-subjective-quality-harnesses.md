# 35 — Subjective UI quality harnesses for agents

**Audience:** Coding agents polishing Church of Beef UI (and humans approving polish loops).  
**Last updated:** 2026-07-26  
**Client:** TBC Classic Anniversary (`## Interface: 20506`).  
**Authority:** Spec §10 / §15 · [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) · glossary 74–81 · in-game QA in track [19](../wow-classic-addon-design/19-testing-debugging-qa/) · offline Core harness in track [73](../wow-classic-addon-design/73-desktop-lua-testing/).  
**Search dumps (not product law):** [`_search-subjective-quality-harnesses.json`](_search-subjective-quality-harnesses.json), [`_search-subjective-quality-harnesses-2.json`](_search-subjective-quality-harnesses-2.json), [`_search-subjective-quality-harnesses-3.json`](_search-subjective-quality-harnesses-3.json).

Research is guidance. Do not fork brand hex, announce policy, or “done” criteria here — lock those in the design spec / glossary.

---

## Verdict (one line)

**Ship a three-layer polish gate: (1) doctrine checklist automation, (2) short rubric scores on in-client screenshots, (3) optional pairwise A/B when two candidates exist — and treat golden PNGs as curated references, not CI pixelmatch.**

---

## 1. Why subjective quality needs a harness

Church of Beef V1 already has:

| Gate | Proves | Does **not** prove |
|------|--------|--------------------|
| `lua tests/run.lua` | Core/Data/Net-validate logic | Frames, spectacle, chrome feel |
| In-game QA checklist ([19](../wow-classic-addon-design/19-testing-debugging-qa/church-of-beef-qa-checklist.md)) | Load, tabs, Commit, BeefNet, announce | Whether the UI feels “churchy but Classic-native” |
| Spec anti-patterns + build-prep canvas | Policy bans | That an agent stopped polishing at the right time |

Subjective polish fails in predictable agent ways: endless Reflexion-style critique loops, vibe scores (“looks good 8/10”), density creep, and inventing brand chrome before the Anniversary screenshot lock. A harness gives agents **discrete fail/pass signals**, **stop criteria**, and a place to attach evidence (screenshots + scorecards) without claiming V1 complete from desktop alone.

Track [73](../wow-classic-addon-design/73-desktop-lua-testing/beef-v1-recommendation.md) already marks **headless screenshot / UI tests** as a non-goal for the Lua harness. That constraint stands. This note proposes a **lightweight, agent-usable** layer *beside* that harness — not a WoW emulator or Chromatic pipeline.

---

## 2. Four evaluation families (industry map)

### 2.1 Rubric scoring (single-answer grading)

Score one artifact against named criteria with a discrete scale (e.g. 0–2 or pass/warn/fail), then aggregate.

**Evidence pattern:** Mixed automatic checks + LLM-as-judge rubric for polish/alignment ([Portal UX Agent](https://arxiv.org/html/2511.00843v1)); VLM critics with multi-dimension scores and a quality ceiling on iterative refinement ([GameUIAgent](https://arxiv.org/html/2603.14724)); production guidance to specify rubrics with examples and JSON scores ([LLM-as-Judge Best Practices 2026](https://futureagi.com/blog/llm-as-judge-best-practices-2026/); [LangSmith LLM-as-a-judge](https://docs.langchain.com/langsmith/llm-as-judge?mode=ui)).

**Strengths for agents:** Explainable fails (“Standing uses StatusBar — ban”); maps cleanly to CoB doctrine rows.  
**Weaknesses:** Absolute scores drift; vague “visual polish 1–10” is noise ([same practices guide](https://futureagi.com/blog/llm-as-judge-best-practices-2026/)). Prefer **decomposed, non-redundant criteria** ([RRD / rubric refinement](https://arxiv.org/html/2602.05125v1); [Openlayer judge guide](https://www.openlayer.com/blog/post/llm-as-judge-evaluation-guide)).

### 2.2 Pairwise comparison

Present A vs B; judge picks winner (or tie). Preferable when absolute scores are unreliable — classic preference testing also uses image pairwise for concept testing ([OpinionX pairwise overview](https://www.opinionx.co/blog/pairwise-comparison)).

**Bias control (mandatory if used):** Position bias is real; conservative mitigation is **swap order and require consistent winner**, else tie ([MT-Bench / Chatbot Arena](https://arxiv.org/abs/2306.05685); [position-bias notes](https://mbrenndoerfer.com/writing/position-bias-in-llm-judges); [IJCNLP position-bias study](https://aclanthology.org/2025.ijcnlp-long.18/)). Also watch verbosity / “more chrome = better” bias — CoB doctrine often prefers *less*.

**Strengths:** Good for “toast before vs after” polish PRs.  
**Weaknesses:** Needs two candidates; swap doubles cost; ties need a human or doctrine fallback.

### 2.3 Golden screenshots (visual regression)

Capture a baseline image; fail on unexpected pixel/diff ([Playwright `toHaveScreenshot`](https://playwright.dev/docs/test-snapshots) via pixelmatch; [Chromatic / Storybook visual tests](https://www.chromatic.com/storybook)).

**Strengths:** Catches accidental layout shifts in web/Storybook worlds; baselines are reviewable in git.  
**Weaknesses for CoB:** No stable headless WoW renderer in V1; OS/font/GPU flake even when you *can* screenshot ([Playwright warning](https://playwright.dev/docs/test-snapshots)); Classic UI scale / resolution / other addons change pixels constantly. **Do not put pixelmatch in GHA for Anniversary frames.**

**Adapted use:** Curated **golden gallery** (human-approved PNGs under research or docs assets) as *references for judges and humans*, updated only with intentional `--accept` reviews — not as a red CI gate.

### 2.4 Checklist automation

Boolean or enum checks derived from locked policy (typography, states, a11y, consistency) — the traditional UI review list pattern ([UI design checklist examples](https://www.desisle.com/resources/ui-design-checklist); [Code Labs Academy checklist framing](https://codelabsacademy.com/blog/ui-design-checklist)). Agents excel when items are **machine-checkable from Lua / TOC / copy IDs**, not “feels premium.”

**CoB already has seeds:** `ui-polished-direction-for-agents.md` non-negotiables, glossary 74–81, canvas `visual-polish-acceptance-checklist`, track 19 QA checklist. The harness job is to **compile those into a scorable agent form** with evidence slots.

---

## 3. What works for agents (synthesis)

| Pattern | Agent-usable today? | Best CoB role |
|---------|---------------------|---------------|
| Doctrine checklist (code + copy) | Yes — grep / TOC / frame inventory | Hard gate before any polish claim |
| Rubric on screenshots + Lua | Yes — multimodal agent or human+agent | Soft gate for density / hierarchy / Classic-native feel |
| Pairwise A/B | Yes — when two candidates | Optional when iterating toast / officer chrome |
| Golden pixel CI | No for WoW V1 | Reject as CI; allow curated gallery only |
| Unbounded self-critique loops | Harmful past ceiling ([GameUIAgent quality ceiling](https://arxiv.org/html/2603.14724); Reflexion-style loops) | Cap trials; stop on checklist green + rubric floor |

**Mixed-methods is the winning shape:** automatic/structural checks first, then rubric judgment, human checklist only for ambiguity ([Portal UX Agent evaluation section](https://arxiv.org/html/2511.00843v1)).

---

## 4. Proposed lightweight harness for Church of Beef

Name: **COB Polish Gate (v0)** — docs + agent procedure; no new CI service required. Optional later tooling stays in [`OPTIMIZATIONS.md`](../../../OPTIMIZATIONS.md) until approved.

### 4.1 Surfaces under test (fixed set)

Keep the matrix tiny (one composition per surface):

| ID | Surface | Evidence |
|----|---------|----------|
| `S1` | Ladder tab (populated) | PNG + note uiScale |
| `S2` | My Standing (text thresholds) | PNG |
| `S3` | Officer tab (pending row) | PNG — Officer+ only |
| `S4` | Empty / not-in-guild | PNG |
| `S5` | Private edge toast (promote) | PNG or short clip note |
| `S6` | Guild-chat announce line | Chat log paste (no screenshot of other players’ UI required) |

Minimap button optional (`S7`) after Task 7 lands.

### 4.2 Layer A — Checklist automation (hard gate)

Agent fills a scorecard. Items are **pass / fail / n/a**. Any **fail** blocks “polish done.”

**A1 — Doctrine (from agent briefing + glossary)**

- [ ] Classic FrameXML shell (`BasicFrameTemplate` / panel buttons / GameFont*) — no ElvUI-flat brand skin  
- [ ] No custom `Media/` required for V1; missing media does not error  
- [ ] Tabs only: Ladder / My Standing / Officer+  
- [ ] Standing: **text thresholds only** — no hero `StatusBar` / castbar metaphor  
- [ ] Class color on **names** only; pending/approve/reject dual-encoded (not color-only)  
- [ ] No WA-style center spectacle; toast = private edge  
- [ ] Settings surface ≤ position + minimap hide + announce  
- [ ] Silent (no SFX) unless later unlocked  
- [ ] Guest on player `uiScale` — addon never sets `uiScale` / `UIParent:SetScale`  
- [ ] No SecureActionButton “to open a panel”; no tip jars; no Streamer Mode code in V1  

**A2 — Structural (cheap static checks)**

- [ ] `ChurchOfBeef.toc` lists only existing files; Interface `20506` unless intentional bump  
- [ ] UI modules do not call scoring/award APIs; no Core→UI / Core `CreateFrame`  
- [ ] Copy IDs / strings avoid forked thresholds (numbers only from `Data/Ranks.lua`)  
- [ ] `lua tests/run.lua` exit 0 if Core/Data touched in the same change  

**A3 — In-client smoke (from track 19, subset)**

- [ ] `/console scriptErrors 1` → `/reload` → `/beef` opens a real frame  
- [ ] BugSack clean for Church of Beef on the exercised path  
- [ ] Officer tab hidden for member; visible for Officer+  

Layer A is mostly **deterministic**. Prefer scripts/greps over LLM for A1–A2 when possible.

### 4.3 Layer B — Rubric scoring (soft gate)

Run only after Layer A is green. Score each surface `S1–S6` on **four criteria**, each `0 / 1 / 2`:

| Criterion | `0` | `1` | `2` |
|-----------|-----|-----|-----|
| **Hierarchy** | Competing heroes / dense Details!-like roster | Readable but flat | One clear primary (ladder/title/standing) |
| **Classic-native** | Retail glass / custom gothic shell / WA pulse | Mixed | Template-native shell; brand in words |
| **Density** | Scroll of chips/stats/rainbow ranks | Slightly busy | Sparse; dual-encode states without clutter |
| **Spectacle budget** | Center screen / noisy SFX / spam `/g` | Toast or chat slightly loud | Throttled `/g` + quiet edge toast per spec |

**Pass rule (v0):** For every required surface, mean ≥ **1.5** and no criterion at `0`.  
**Output format (agent must emit JSON-ish markdown):**

```markdown
### Polish scorecard — <date> — <commit/shortsha>
| Surface | Hierarchy | Classic-native | Density | Spectacle | Notes |
|---------|-----------|----------------|---------|-----------|-------|
| S1 | 2 | 2 | 1 | 2 | ... |
**Layer A:** PASS/FAIL  
**Layer B:** PASS/FAIL  
**Stop:** ship | fix-list | needs-human
```

Judge instructions for agents:

1. Prefer **screenshots + Lua diff** over memory of the design.  
2. Penalize verbosity / extra chrome (length bias mitigation — [practices](https://futureagi.com/blog/llm-as-judge-best-practices-2026/)).  
3. Do not invent hex tokens; template-native until Anniversary brand lock (glossary 78/81).  
4. If unsure between `1` and `2`, pick `1` and list a concrete fix.

### 4.4 Layer C — Pairwise (optional)

Use when an agent (or PR) produces **two** candidates for the same surface (e.g. toast layout).

Protocol:

1. Blind labels `A` / `B` (filenames shuffled).  
2. Ask: “Which better matches CoB doctrine (Classic shell, sparse, edge toast)?”  
3. **Swap order and re-ask**; accept only if the same candidate wins twice; else **tie → human** ([MT-Bench mitigation](https://arxiv.org/abs/2306.05685)).  
4. Winner still must pass Layer A + B — pairwise never overrides a doctrine fail.

### 4.5 Golden gallery (reference, not CI)

Suggested layout (create when first screenshots exist; do not invent pixels):

```text
docs/research/agent-polish-vision/golden/
  README.md          # how to capture (Anniversary, uiScale, no other UI packs)
  S1-ladder.png
  S2-standing.png
  ...
```

Rules:

- Capture on Anniversary only; note resolution + `uiScale` in README.  
- Update goldens only with explicit human “accept” (same spirit as Playwright `--update-snapshots` ([docs](https://playwright.dev/docs/test-snapshots))).  
- Agents may **compare qualitatively** to goldens; they must not fail a PR on pixel diff.  
- Never commit other players’ real names in storefront-bound shots without consent (privacy track 65).

### 4.6 Stop criteria (anti-thrash)

| Condition | Action |
|-----------|--------|
| Layer A fail | Fix code; no rubric loop |
| Layer B fail with concrete fix-list ≤ 5 items | One more implement pass, then re-score |
| Layer B still fail after **2** critique cycles | Stop; escalate to human with scorecard + PNGs |
| Layer A+B pass | Stop polishing that surface — ship |
| Pairwise tie | Human picks; do not spin |

This mirrors the empirical “quality ceiling” on VLM refinement loops ([GameUIAgent](https://arxiv.org/html/2603.14724)): more iterations past a threshold buy little and can regress.

### 4.7 Where it lives in the workflow

```text
Implement UI change
    → lua tests/run.lua (if Core/Data)
    → install /reload /beef smoke
    → Layer A checklist
    → capture S* PNGs
    → Layer B rubric (agent)
    → optional Layer C pairwise
    → attach scorecard in PR / agent handoff
    → human walks track 19 for guild/net/spectacle
```

**Not V1-complete:** Filling this scorecard does not replace `docs/phases/v1-checklist.md` or two-client BeefNet labs ([verification rule](../../../.cursor/rules/verification.mdc)).

---

## 5. Explicit non-goals (v0)

- Chromatic / Playwright / Storybook visual CI for WoW frames  
- Full WoW UI emulator or headless `CreateFrame` renderer  
- Replacing BugGrabber smoke or two-client guild labs  
- Numeric “brand hex” enforcement before Anniversary screenshot lock  
- Auto-uploading screenshots that contain account/character PII  
- Unbounded agent critique until score == 2.0 everywhere  

---

## 6. Possible later upgrades (needs human approval)

Park in `OPTIMIZATIONS.md` if pursued:

1. **Scripted Layer A greps** — e.g. fail if UI Lua contains `StatusBar`, `SecureActionButtonTemplate`, `SetScale` on UIParent.  
2. **Scorecard template file** — `docs/phases/polish-scorecard.md` checked into PRs.  
3. **Cursor hook** — remind agents to run polish gate when `addon/ChurchOfBeef/UI/**` changes (hooks backlog already deferred).  
4. **Human gold-set calibration** — 10–20 labeled “good/bad” Anniversary shots to sanity-check agent rubrics ([calibration discipline](https://futureagi.com/blog/llm-as-judge-best-practices-2026/)).  

---

## 7. Sources

- [Portal UX Agent — automatic checks + LLM-as-a-Judge](https://arxiv.org/html/2511.00843v1)  
- [GameUIAgent — VLM reflection, quality ceiling](https://arxiv.org/html/2603.14724)  
- [Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena](https://arxiv.org/abs/2306.05685)  
- [Position Bias in LLM-as-a-Judge (IJCNLP 2025)](https://aclanthology.org/2025.ijcnlp-long.18/)  
- [Position bias measurement and mitigation](https://mbrenndoerfer.com/writing/position-bias-in-llm-judges)  
- [LLM-as-Judge Best Practices 2026](https://futureagi.com/blog/llm-as-judge-best-practices-2026/)  
- [Openlayer — LLM as Judge Guide](https://www.openlayer.com/blog/post/llm-as-judge-evaluation-guide)  
- [Rethinking Rubric Generation (RRD)](https://arxiv.org/html/2602.05125v1)  
- [LangSmith — define an LLM-as-a-judge evaluator](https://docs.langchain.com/langsmith/llm-as-judge?mode=ui)  
- [Playwright — Visual comparisons](https://playwright.dev/docs/test-snapshots)  
- [Chromatic — Visual testing for Storybook](https://www.chromatic.com/storybook)  
- [OpinionX — Pairwise comparison](https://www.opinionx.co/blog/pairwise-comparison)  
- [UI Design Checklist (Desisle)](https://www.desisle.com/resources/ui-design-checklist)  
- In-repo: [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md), [73 desktop testing recommendation](../wow-classic-addon-design/73-desktop-lua-testing/beef-v1-recommendation.md), [19 QA checklist](../wow-classic-addon-design/19-testing-debugging-qa/church-of-beef-qa-checklist.md)

---

## 8. Bottom line for implementers

Use **COB Polish Gate (v0):** hard doctrine/structural checklist → short 4-axis rubric on six surfaces → optional swapped pairwise → curated goldens as references only. Cap critique at two cycles. Keep `lua tests/run.lua` and two-client labs as the authority for logic and net; this harness only disciplines *subjective* polish so agents know when to stop.

---

## 9. Expansion — BIR + VLM ceiling + sources catalog (2026-07-26)

**Catalog:** [`22b-agentic-critique-sources.md`](22b-agentic-critique-sources.md).

### 9.1 Wire Polish Gate into evaluator-optimizer

| Layer | Maps to industry role | Stop |
|-------|----------------------|------|
| A checklist | Deterministic Verifier | Fail → fix; no rubric |
| B rubric | Evaluator (LLM-as-judge) | Mean ≥1.5, no zeros |
| C pairwise | Voting / preference ([MT-Bench](https://arxiv.org/abs/2306.05685)) | Swap twice or human |
| Human smoke | External selector ([CAI](https://arxiv.org/abs/2212.08073) / Anthropic) | Only path to PASS polish |

This is [Anthropic evaluator-optimizer](https://www.anthropic.com/engineering/building-effective-agents) with CoB’s hard split: **offline Core harness ≠ subjective UI**.

### 9.2 VLM ceiling (do not thrash)

[GameUIAgent](https://arxiv.org/html/2603.14724) and deep-research VLM notes: iterative vision refine hits a **quality ceiling** and can regress. CoB: **2** Layer-B cycles max, then escalate with PNGs ([26](26-visual-qa-screenshot-protocol.md)). Prefer ScreenAI-class UI models for presence/layout questions ([ScreenAI](https://arxiv.org/abs/2402.04615)) still as **advisory**.

### 9.3 Definition of Done bridge

- Layer A+B PASS → **POLISH: CANDIDATE** evidence for [`24`](24-definition-of-done-polish.md)  
- Human H1–H5 + tier checks → **POLISH: PASS**  
- Never let Layer B “2.0 everywhere” substitute for BugSack / two-client / guild reaction

### 9.4 Optional later: BUGBOT.md doctrine rows

Encode Layer A1 machine-checkable bans into `.cursor/BUGBOT.md` scoped to `addon/ChurchOfBeef/UI/**` ([Bugbot project rules](https://cursor.com/docs/bugbot)) — park under `OPTIMIZATIONS.md` until a human approves the file.
