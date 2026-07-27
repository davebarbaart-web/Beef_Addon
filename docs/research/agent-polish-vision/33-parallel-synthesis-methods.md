# 33 — Parallel synthesis methods (50+ briefs → coherent standards)

**Audience:** Coding agents (and humans) consolidating a large wave of parallel research briefs into standards, checklists, and locked decisions for Church of Beef polish.  
**Last updated:** 2026-07-26  
**Status:** Research methods note for the `agent-polish-vision/` lane — **not** product law. Locked product decisions stay in the [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) and [glossary 74](../wow-classic-addon-design/74-v1-decision-glossary/locked-v1-decisions.md).  
**Scope:** Process only. Does not invent rank thresholds, Net policy, or UI chrome.

---

## 1. The problem (why naive merge fails)

A parallel wave of **50+ agent briefs** produces high coverage and high duplication. Collapsing them with a single “summarize everything” pass loses signal in three predictable ways:

1. **Majority washout** — rare but decisive constraints (e.g. Anniversary-only API, taint footguns) disappear under volume.
2. **False consensus** — agents paraphrase each other; agreement looks like evidence when it is echo.
3. **Hallucinated glue** — multi-document LLM summarization can invent bridging claims; studies of multi-document summarization report very high hallucination rates when models stitch topic material across sources ([From Single to Multi… NAACL Findings 2025](https://aclanthology.org/2025.findings-naacl.293/)).

**Goal of this playbook:** turn many briefs into **few standards** while keeping (a) provenance, (b) dissent, and (c) reversible decision records.

---

## 2. Output ladder (what “done” looks like)

| Layer | Artifact | Authority |
|-------|----------|-----------|
| L0 Briefs | Numbered notes + `_search-*.json` in this folder | Evidence only |
| L1 Claim index | `claims-index.md` or cluster sheets (claims with source IDs) | Working memory |
| L2 Theme standards | Concise standards docs (like `02`, `03`, `08`) | Agent guidance — not law |
| L3 Decision records | ADR / MADR-style records for conflicts that need a pick | Proposed → Accepted only after human/spec alignment |
| L4 Product law | Spec / glossary / `Data/Ranks.lua` | Sole policy truth |

Never promote L2 → L4 without an explicit L3 decision and a human (or glossary) accept. Research scrapes and `_search-*.json` are **not** product truth ([architecture overview](../../../AGENTS.md)).

---

## 3. Synthesis playbook (next wave — follow in order)

Copy this checklist into the wave prompt. Do not skip phases to “save a pass.”

### Phase A — Inventory (no synthesis yet)

1. List every brief path + one-line topic.
2. Tag each brief: `client-api` | `ux-juice` | `ceremony` | `net-guild` | `sv-settings` | `perf` | `process` | `other`.
3. Mark **depth**: primary-cited / secondary-only / opinion-heavy / empty-shell.
4. Drop or quarantine briefs that are pure duplicate of an older library track; link out instead of re-merging.

**Exit:** inventory table + count of actionable briefs.

### Phase B — Atomic claims (atomize before you cluster)

From each brief, extract **atomic claims** — one testable assertion per row:

| Field | Rule |
|-------|------|
| `claim_id` | Stable, e.g. `03-taint-01` |
| `claim` | Present tense, ≤2 sentences |
| `claim_type` | `fact` · `norm` · `pattern` · `anti-pattern` · `open-question` · `product-lock` |
| `evidence` | Primary URL(s) or “agent inference — unverified” |
| `confidence_raw` | Author’s stated certainty (if any) |
| `conflicts_with` | Other `claim_id`s if known |
| `beef_surface` | toast / officer / slash / announce / ladder / SV / Net / n/a |

**Hard rule:** Prefer quoting or paraphrasing *with* a source over paraphrasing another agent. Unsourced agent prose → `claim_type = open-question` or mark `unverified`.

**Exit:** claim sheet (spreadsheet or markdown table). Expect 3–15 claims per solid brief; 150–400 claims for a 50-brief wave is normal.

### Phase C — Affinity clustering (bottom-up themes)

Use classic affinity / KJ-style mapping — group by similarity, then name clusters, then relate clusters ([Affinity Mapping… User Interviews](https://www.userinterviews.com/blog/affinity-mapping-ux-research-data-synthesis); [Affinity diagrams — Maze](https://maze.co/blog/affinity-diagrams/); [Codecademy — Affinity Diagrams](https://www.codecademy.com/resources/docs/uiux/affinity-diagram)):

1. **One claim per note** (already done in Phase B).
2. **Cluster without pre-labels** first — resist forcing the inventory tags from Phase A.
3. **Name clusters** with a short insight sentence, not a noun pile (“Combat-time Show/Hide must defer” > “Lockdown”).
4. **Split fat clusters** (>25 claims) by sub-affinity; **merge** tiny synonym clusters.
5. **Zoom out** — draw edges: depends-on / conflicts-with / supersedes / same-as-library-track-N.
6. **Promote outliers** that touch safety, ToS, Anniversary API, or locked glossary items into a dedicated `signal-critical` pile — never bury them in “misc.”

Optional hierarchy (codes → themes), adapted from UX synthesis practice ([Looppanel — UX Research Synthesis](https://www.looppanel.com/blog/ux-research-synthesis)):

- Descriptive codes (topic)
- Process codes (what agents/players do)
- Constraint codes (must / must-not)
- Emotion / spectacle codes (juice intensity) — keep separate from constraint codes so “feels premium” never overrides “causes taint.”

**Exit:** 8–20 named clusters + outlier pile + cross-cluster edge list.

### Phase D — Map-reduce write (cluster → mini-standard)

Do **not** feed all 50 briefs into one context window.

| Step | Who | Input | Output |
|------|-----|-------|--------|
| Map | One agent per cluster (or batch of ≤3 small clusters) | Claims + source briefs for that cluster only | Draft standard section: rules, anti-patterns, open questions, citations |
| Reduce | One synthesizer | All map drafts + conflict register | Unified standards doc(s) + ADR stubs for unresolved conflicts |
| Adversarial pass | Fresh agent | Reduce output + claim index | List of dropped claims, invented glue, majority-wash risks |

Hierarchical / map-reduce style processing is a deliberate alternative to stuffing the full corpus into one long context ([LLM×MapReduce — ACL 2025](https://aclanthology.org/2025.acl-long.1341)).

**Reduce prompt constraints (pasteable):**

```text
You may ONLY assert claims present in the claim index or map drafts.
Every MUST/MUST-NOT needs ≥1 claim_id.
If sources conflict, emit a Conflict row — do not pick a winner unless
claim_type=product-lock or an Accepted ADR already exists.
Preserve the outlier pile as § Minority / signal-critical.
Mark any sentence you add for readability that is not in the index as [glue].
```

**Exit:** draft L2 standards + conflict register + adversarial delta list.

### Phase E — Conflict resolution (explicit, typed)

Classify every conflict before resolving:

| Type | Example | Default resolution |
|------|---------|-------------------|
| **A. Fact clash** | API exists vs does not on `20506` | Re-verify against primary wiki / client; loser → struck claim |
| **B. Norm clash** | Prefer Ace vs plain frames | Prefer locked spec/glossary; else ADR |
| **C. Scope clash** | V1 vs V2+ juice | Park V2 in “later”; do not dilute V1 standard |
| **D. Echo false-consensus** | 12 agents repeat one unsourced tip | Downgrade to `unverified` until primary found |
| **E. Context mismatch** | Retail advice applied to Classic | Tag `wrong-client`; exclude from Anniversary standards |
| **F. Priority clash** | Spectacle vs taint safety | Safety / ToS / lockdown wins; spectacle yields |

**Resolution protocol:**

1. Write the conflict in one sentence + list supporting `claim_id`s on each side.
2. Apply authority order: **glossary/spec → Anniversary primary docs → solid library tracks → new briefs → unsourced agent opinion**.
3. If still undecided and architecturally significant → **ADR (pending)** (Phase F).
4. If low-risk / reversible → pick a provisional norm, mark `provisional`, time-box re-open.
5. Record the outcome in the conflict register (never only in chat).

**Disagree-and-commit:** once an ADR is Accepted, later briefs cite it; they do not silently re-litigate. To change course, **supersede** the ADR — do not edit history away ([ADR practices](https://adr.github.io/ad-practices); [henu-wang ADR guide](https://github.com/henu-wang/architecture-decision-records)).

### Phase F — ADR / MADR decision records

Use Architecture Decision Records for choices that bind agents across files. Prefer a lean Nygard-style or MADR shape ([adr.github.io MADR](https://adr.github.io/madr/); [AWS ADR guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/welcome.html); [EM Tools ADR guide](https://www.em-tools.io/frameworks/architecture-decision-records)):

**When to write an ADR**

- Two+ clusters prescribe incompatible MUST rules
- Choice affects TOC, layers, Net, SV scope, or secure/taint surface
- You need a durable “why” for a future agent that will not read 50 briefs

**When not to**

- Pure restatement of already-locked glossary items (link instead)
- Local style nits with no cross-module impact
- Temporary experiment / spike (use a dated note, not Accepted ADR)

**Statuses:** `proposed` → `accepted` | `rejected` | `deprecated` | `superseded by ADR-XXXX`.  
**Do not silently rewrite Accepted ADRs** — supersede ([ADR writing guidance](https://github.com/henu-wang/architecture-decision-records)).

**Template (drop into `docs/research/agent-polish-vision/decisions/` or promote to spec decisions log when product-binding):**

```markdown
# ADR-XXXX: <short imperative title>

- Status: proposed | accepted | rejected | superseded by ADR-YYYY
- Date: YYYY-MM-DD
- Deciders: <human / agent wave id>
- Claims: <claim_ids>

## Context
What conflict or force makes a decision necessary? (link clusters)

## Options
1. …  2. …  3. …

## Decision
We will …

## Consequences
Positive / negative / follow-ups (tests, TOC, in-game smoke)

## Rejected options
Why not — one line each (signal preservation)

## Links
Spec §§ · library tracks · briefs · supersedes
```

**Y-statement** (optional, for small reversible norms) — from common ADR practice:

> In the context of …, facing …, we decided … and neglected …, to achieve …, accepting ….

**Definition of ready / done** (adapted from AD practice checklists on [adr.github.io AD Practices](https://adr.github.io/ad-practices)): problem clear; alternatives listed; trade-offs explicit; stakeholders (or product owner) time-boxed; documentation path chosen; review/smoke plan named.

### Phase G — Confidence grading (adapted CERQual)

Before calling a cluster “standard,” grade each **finding** (cluster-level synthesis sentence), not each raw claim. GRADE-CERQual assesses confidence in qualitative synthesis findings via methodological limitations, coherence, adequacy, and relevance ([CERQual intro — PubMed](https://pubmed.ncbi.nlm.nih.gov/29384079/); [Cochrane Methods note](https://methods.cochrane.org/news/applying-grade-cerqual-qualitative-evidence-synthesis-findings-new-series-papers); [Summary of Qualitative Findings tables](https://pubmed.ncbi.nlm.nih.gov/29384082)).

| Component (CERQual) | Beef research adaptation |
|---------------------|---------------------------|
| Methodological limitations | Thin scrape? No primary? Retail-only source? |
| Coherence | Do claims in the cluster actually say the same thing? |
| Adequacy | Enough independent sources, or one blog echoed 20×? |
| Relevance | Applies to Anniversary `20506` social addon? |

**Output labels for standards prose:**

| Label | Meaning | Agent behavior |
|-------|---------|----------------|
| `high` | Multiple primaries, coherent, on-client | MAY use MUST |
| `moderate` | Solid but thin or partly secondary | SHOULD / prefer |
| `low` | Sparse, echo-heavy, or partial client mismatch | MAY / optional |
| `very-low` | Speculative | Do not ship as rule; keep as open question |

Publish a short **Summary of Findings** table at the top of each L2 standard (finding → confidence → key claim_ids). This is the decision-maker view CERQual expects in SoQF-style tables.

### Phase H — Signal preservation pack (ship with every reduce)

Every reduce commit or PR description should include:

1. **Consensus standards** (high/moderate findings)
2. **Minority report** — claims that lost the vote but remain plausible (with `claim_id`s)
3. **Outlier / signal-critical** — safety, ToS, taint, Net authority, SV wipe risks
4. **Open questions** — needs client smoke or human lock
5. **Struck / superseded** — what we explicitly discarded and why
6. **Coverage gaps** — topics with zero adequate claims (do not invent filler)

If the minority report is empty on a contentious topic, the reduce likely washed signal — re-run adversarial pass.

### Phase I — Promote carefully

| Destination | Gate |
|-------------|------|
| Update L2 polish note (`NN-*.md`) | Phases A–H complete for that topic |
| New ADR under `decisions/` | Conflict typed; options listed |
| Spec / glossary | Human accept; research alone insufficient |
| `Data/Ranks.lua` | Never from research synthesis |

---

## 4. Conflict register format

Keep one running file per wave, e.g. `_wave-synthesis-conflicts.md`:

```markdown
| ID | Type | Summary | Side A (claims) | Side B (claims) | Resolution | ADR |
|----|------|---------|-----------------|-----------------|------------|-----|
| C-01 | A fact | Does X API exist on 20506? | 12-a03 | 12-b07 | Verified absent → strike B | — |
| C-02 | B norm | Toast parent under UIParent vs Beef root | 03-… | 07-… | Accepted ADR-0007 | ADR-0007 |
```

---

## 5. Anti-patterns (do not do)

| Anti-pattern | Why it hurts | Do instead |
|--------------|--------------|------------|
| One-shot “merge 50 files” summary | MDS hallucination + majority wash ([NAACL Findings 2025](https://aclanthology.org/2025.findings-naacl.293/)) | Map-reduce by cluster |
| Voting by agent count | Echo chambers win | Authority order + CERQual adequacy |
| Editing Accepted ADRs in place | Loses why/history | Supersede |
| Promoting research to product law | Forks canon | L3 ADR → human → glossary/spec |
| Dropping orphans as “noise” | Often the real constraint | Signal-critical pile |
| Mixing Retail and Anniversary claims | Silent wrong standards | `wrong-client` tag |
| Standards without claim_ids | Un-auditable | Every MUST cites claims |
| Re-clustering forever | No ship | Time-box Phase C; ADR the rest |

---

## 6. Roles for a parallel agent wave

| Role | Count | Job |
|------|------:|-----|
| Brief authors | N | Produce L0 with citations |
| Claim extractors | 2–4 | Phase B; no clustering opinions |
| Affinity facilitators | 1–2 | Phase C; may not write final MUST rules |
| Map writers | = clusters | Phase D map |
| Reducer | 1 | Phase D reduce + register |
| Adversary | 1 (fresh context) | Hunt dropped signal + invented glue |
| ADR clerk | 1 | Phase F stubs; does not auto-accept product locks |

**Separation matter:** the adversary must not be the reducer. Claim extractors should not also be the sole reducer.

---

## 7. Definition of done (wave synthesis)

A wave is synthesizable into standards when:

- [ ] Inventory complete; empty shells linked or dropped  
- [ ] Claim index covers all non-dropped briefs  
- [ ] Clusters named; outliers parked, not deleted  
- [ ] Map drafts exist per cluster; reduce produced L2 prose  
- [ ] Conflict register has an outcome or ADR for every Type A/B/E clash  
- [ ] SoQF-style confidence labels on each standard finding  
- [ ] Minority + signal-critical sections non-empty when conflicts existed  
- [ ] Adversarial pass recorded; invented `[glue]` removed or sourced  
- [ ] No L4 product edits without human/spec path  

Offline tests (`lua tests/run.lua`) do not validate synthesis quality — process gates above do. In-game smoke still required when L2 standards touch UI / Net / SV / slash ([verification rules](../../../.cursor/rules/verification.mdc)).

---

## 8. Minimal templates (copy-paste)

### 8.1 Claim row

```text
claim_id: 08-sv-04
claim: ChurchOfBeefDB is SavedVariablesPerCharacter; alts do not share standing.
claim_type: product-lock
evidence: design spec §9; ChurchOfBeef.toc
beef_surface: SV
conflicts_with: —
```

### 8.2 Cluster header

```text
## Cluster: Defer protected frame mutation until regen
Insight: … 
Claims: 03-…, 03-…
Confidence (draft): moderate
Edges: conflicts-with Cluster "Always show officer confirm immediately"
Library: track 29-taint-secure-ui
```

### 8.3 Minority report stub

```text
## Minority / signal-critical
- [claim_id] … — kept because …; not in consensus MUST list
```

---

## 9. Suggested file layout for the next wave

```text
docs/research/agent-polish-vision/
  NN-topic-brief.md          # L0
  _search-*.json             # provenance (not standards)
  _wave-<name>-inventory.md  # Phase A
  _wave-<name>-claims.md     # Phase B
  _wave-<name>-clusters.md   # Phase C
  _wave-<name>-conflicts.md  # Phase E register
  decisions/
    ADR-XXXX-title.md        # Phase F
  33-parallel-synthesis-methods.md  # this playbook
```

Promote only stable L2 notes and Accepted ADRs that humans endorsed; keep `_wave-*` as working papers.

---

## 10. One-page playbook (paste into next wave prompt)

```text
PARALLEL SYNTHESIS — FOLLOW 33-parallel-synthesis-methods.md

1. Inventory briefs (tag + depth). No merging yet.
2. Extract atomic claims with claim_id, type, evidence, beef_surface.
3. Affinity-cluster bottom-up; name with insight sentences; park outliers.
4. Map: one draft standard per cluster from claims only.
5. Reduce: unify; build conflict register; no silent winners.
6. Resolve conflicts by type + authority order; ADR anything binding.
7. Grade findings (CERQual-adapted): high/moderate/low/very-low.
8. Ship: standards + minority/signal-critical + open questions + struck list.
9. Adversarial pass on the reduce output (fresh agent).
10. Promote to spec/glossary only with human accept.

FORBIDDEN: one-shot merge of 50+ files; voting by agent count;
editing Accepted ADRs in place; treating _search JSON as product law.
```

---

## 11. Expansion — synthesizing *critique-loop* research into standards (2026-07-26)

When the wave topic is agent process (tracks 22–35), apply the same playbook with these claim-type hints:

| Claim type | Examples from [`22b`](22b-agentic-critique-sources.md) | Promote to |
|------------|--------------------------------------------------------|------------|
| `pattern` | Evaluator-optimizer; Leap Fan-In; BIR | L2 process notes (22, 27, 31) |
| `norm` | max_iter=3; writer≠reviewer; best-so-far | L2 + optional ADR if binding agents |
| `anti-pattern` | Unbounded Self-Refine; pixel CI for WoW; critic invents Media | L2 MUST-NOT |
| `product-lock` | Interface `20506`; UI≠scoring; no center WA | Already L4 — **link**, do not re-decide |
| `open-question` | Whether to add `.cursor/BUGBOT.md` in-repo | Human / OPTIMIZATIONS |

**Authority order for process conflicts:** verification.mdc + architecture rules → UI brief / glossary → Anthropic/LangGraph primary docs → arXiv patterns → Reddit/YouTube recipes → unsourced agent opinion.

**Adversarial reduce check (critique waves):** Did we keep the signal that **human in-game smoke cannot be closed by LLM judges**? If the reduce implies desktop-only polish PASS, the adversary must FAIL the draft ([Anthropic coding-agent caveat](https://www.anthropic.com/engineering/building-effective-agents); CoB verification.mdc).

Map-reduce still wins over one-shot merge of 50 process briefs ([NAACL MDS hallucination](https://aclanthology.org/2025.findings-naacl.293/)).

---

## Sources

- [Affinity Mapping: How to Synthesize User Research Data in 5 Steps — User Interviews](https://www.userinterviews.com/blog/affinity-mapping-ux-research-data-synthesis) (Jan 2025)
- [Affinity Diagrams — Codecademy](https://www.codecademy.com/resources/docs/uiux/affinity-diagram) (Jun 2025)
- [Affinity diagrams — Maze](https://maze.co/blog/affinity-diagrams/) (Oct 2025)
- [How to create an affinity map for research — Think Company](https://www.thinkcompany.com/blog/affinity-mapping-in-ux) (updated 2026)
- [UX Research Synthesis Methods — Looppanel](https://www.looppanel.com/blog/ux-research-synthesis)
- [Applying GRADE-CERQual… introduction — PubMed](https://pubmed.ncbi.nlm.nih.gov/29384079/) (2018)
- [CERQual overall assessment / SoQF tables — PubMed](https://pubmed.ncbi.nlm.nih.gov/29384082/) (2018)
- [Applying GRADE-CERQual — Cochrane Methods](https://methods.cochrane.org/news/applying-grade-cerqual-qualitative-evidence-synthesis-findings-new-series-papers) (2018)
- [GRADE-CERQual fidelity evaluation — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10369711)
- [From Single to Multi: How LLMs Hallucinate in Multi-Document Summarization — ACL Anthology](https://aclanthology.org/2025.findings-naacl.293/) (2025)
- [LLM×MapReduce — ACL Anthology](https://aclanthology.org/2025.acl-long.1341) (2025)
- [Markdown Architectural Decision Records — adr.github.io/madr](https://adr.github.io/madr/)
- [AD Practices — adr.github.io](https://adr.github.io/ad-practices)
- [Architecture Decision Records — AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/welcome.html)
- [ADRs: Template & Guide — EM Tools](https://www.em-tools.io/frameworks/architecture-decision-records) (Jul 2026)
- [ADR templates & best practices — henu-wang/architecture-decision-records](https://github.com/henu-wang/architecture-decision-records)
- [architecture-decision-record org catalog — GitHub](https://github.com/architecture-decision-record/architecture-decision-record)

Search provenance (follow-up):  
`_search-parallel-synthesis-methods.json`, `_search-synthesis-clustering-conflict.json`, `_search-adr-lifecycle.json`, `_search-conflict-signal-preservation.json` in this folder.
