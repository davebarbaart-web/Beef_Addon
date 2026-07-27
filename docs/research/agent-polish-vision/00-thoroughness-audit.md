# 00 — Thoroughness audit (`agent-polish-vision`)

**Date:** 2026-07-26  
**Scope:** All `*.md` briefs under `docs/research/agent-polish-vision/`  
**Ignored:** `_search-*.json` scrapes, `.raw/`, other non-brief artifacts  
**Pass type:** Audit only — **no deepening** in this pass  

---

## 1. Inventory summary

| Metric | Value |
|--------|------:|
| Markdown briefs audited | **54** |
| Numbered range | `01`–`56` |
| Missing numbers | **15**, **21** (no files) |
| Word-count range | ~1,616 – ~3,589 |
| Median words | ~2,223 |
| Briefs with ≥1 external `http(s)` URL | **28** |
| Briefs with **zero** external URLs | **26** |
| Briefs with a Sources / References-style heading | **~33** |

**None of the briefs are empty stubs.** The floor is ~1.6k words. “Thin” here means **short relative to the series** and/or **weak external sourcing** (repo-only synthesis, name-dropped papers, or a single wiki link), not a title-only placeholder.

Word counts are whitespace-token estimates (`\S+`). External URLs are unique `http://` / `https://` occurrences (relative repo links do **not** count as external).

---

## 2. Scoring rubric (used in this audit)

| Label | Meaning |
|-------|---------|
| **substantial** | Typically ≥2k words **and** solid external citations (≥5–8+ URLs) or equivalent density |
| **moderate** | Usable body; some external URLs (or strong in-repo depth) but not citation-rich |
| **moderate-light-src** | Decent length, but only a handful of external URLs for a topic that wants more |
| **thin** | Bottom quartile length **and** ≤1 external URL (or zero) |
| **thin-unsourced** | Under ~2.3k words, **zero** external URLs |
| **moderate-unsourced** | ~2.3–2.8k words, zero external URLs (body OK; sourcing gap) |
| **substantial-unsourced** | ≥~2.8k words, zero external URLs (long internal synthesis; still citation-poor) |

**Deepen priority** weights: (1) low word count, (2) zero/few external URLs, (3) topics that normally need Blizzard / wiki / academic / Cursor docs citations (taint, perf, media, sound, agent loops).

---

## 3. Full brief inventory

| # | File | Words (est.) | External URLs? | Sources heading? | Substance |
|---|------|-------------:|:--------------:|:----------------:|-----------|
| 01 | `01-classic-ui-architecture.md` | ~2988 | Y (14) | Y | substantial |
| 02 | `02-lua-vs-xml-frames.md` | ~2017 | Y (14) | Y | substantial |
| 03 | `03-taint-lockdown-ux.md` | ~1903 | **N (0)** | n | **thin** |
| 04 | `04-media-fonts-textures.md` | ~2042 | Y (3) | Y | moderate-light-src |
| 05 | `05-minimap-ldb-patterns.md` | ~1998 | Y (13) | Y | substantial |
| 06 | `06-guild-roster-ui.md` | ~2036 | Y (12) | Y | substantial |
| 07 | `07-chat-spectacle-ux.md` | ~1880 | Y (11) | Y | substantial† |
| 08 | `08-savedvars-settings-ux.md` | ~2032 | Y (9) | Y | substantial |
| 09 | `09-performance-budgets.md` | ~1616 | Y (1) | n | **thin** |
| 10 | `10-competitive-addon-case-studies.md` | ~3158 | Y (11) | Y | substantial |
| 11 | `11-game-juice-fundamentals.md` | ~2826 | Y (22) | Y | substantial |
| 12 | `12-social-progression-loops.md` | ~2003 | Y (9) | Y | substantial |
| 13 | `13-rank-ladder-psychology.md` | ~2010 | Y (10) | Y | substantial |
| 14 | `14-celebration-spectacle-design.md` | ~2503 | Y (11) | Y | substantial |
| 15 | — | — | — | — | **missing** |
| 16 | `16-timing-curves-recipes.md` | ~2039 | Y (8) | Y | substantial |
| 17 | `17-ui-sound-design.md` | ~2223 | Y (3) | n | moderate-light-src |
| 18 | `18-color-hierarchy-readability.md` | ~2085 | Y (9) | Y | substantial |
| 19 | `19-onboarding-ux.md` | ~2638 | Y (7) | Y | substantial |
| 20 | `20-empty-states-disclosure.md` | ~2092 | Y (4) | Y | moderate |
| 21 | — | — | — | — | **missing** |
| 22 | `22-llm-critique-loops.md` | ~2065 | Y (15) | Y | substantial |
| 23 | `23-self-playtest-patterns.md` | ~1943 | Y (7) | Y | moderate |
| 24 | `24-definition-of-done-polish.md` | ~2887 | **N (0)** | n | substantial-unsourced |
| 25 | `25-ui-polish-critique-rubric.md` | ~2667 | **N (0)** | n | moderate-unsourced |
| 26 | `26-visual-qa-screenshot-protocol.md` | ~2557 | **N (0)** | n | moderate-unsourced |
| 27 | `27-multi-agent-adversarial-review.md` | ~2373 | Y (11) | Y | substantial |
| 28 | `28-hands-off-cursor-workflows.md` | ~2473 | Y (18) | Y | substantial |
| 29 | `29-superpowers-loop-patterns.md` | ~1940 | **N (0)** | Y | **thin** |
| 30 | `30-writing-effective-agent-goals.md` | ~3589 | Y (1) | Y | substantial‡ |
| 31 | `31-loop-stop-conditions.md` | ~2242 | **N (0)** | Y | thin-unsourced |
| 32 | `32-human-checkpoint-handoff.md` | ~2672 | **N (0)** | n | moderate-unsourced |
| 33 | `33-parallel-synthesis-methods.md` | ~2804 | Y (18) | Y | substantial |
| 34 | `34-cursor-rules-polish-proposal.md` | ~2130 | **N (0)** | Y | thin-unsourced |
| 35 | `35-subjective-quality-harnesses.md` | ~2142 | Y (14) | Y | substantial |
| 36 | `36-cob-rules-skills-gap-audit.md` | ~2960 | **N (0)** | Y | substantial-unsourced |
| 37 | `37-skill-draft-polish-loop.md` | ~1926 | **N (0)** | n | **thin** |
| 38 | `38-juice-spectacle-roadmap.md` | ~2090 | **N (0)** | n | thin-unsourced |
| 39 | `39-ui-direction-standards-expansion.md` | ~2169 | **N (0)** | n | thin-unsourced |
| 40 | `40-major-leaps-dev-standards.md` | ~2374 | **N (0)** | Y | moderate-unsourced |
| 41 | `41-playtest-protocol-automation.md` | ~2840 | **N (0)** | n | substantial-unsourced |
| 42 | `42-v1-vs-v2-juice-scope.md` | ~1817 | **N (0)** | n | **thin** |
| 43 | `43-canon-lore-presentation-ux.md` | ~2605 | **N (0)** | Y | moderate-unsourced |
| 44 | `44-officer-commit-ux-juice.md` | ~2201 | **N (0)** | n | thin-unsourced |
| 45 | `45-beefnet-sync-status-ux.md` | ~2647 | **N (0)** | Y | moderate-unsourced |
| 46 | `46-toast-celebration-system.md` | ~2357 | **N (0)** | n | moderate-unsourced |
| 47 | `47-minimap-standing-glance-ux.md` | ~1876 | **N (0)** | n | **thin** |
| 48 | `48-architecture-vs-juice-tensions.md` | ~2542 | **N (0)** | n | moderate-unsourced |
| 49 | `49-adversarial-overengineering.md` | ~1855 | **N (0)** | Y | **thin** |
| 50 | `50-adversarial-tos-safety.md` | ~2098 | Y (5) | Y | moderate |
| 51 | `51-adversarial-performance-vs-juice.md` | ~2363 | **N (0)** | n | moderate-unsourced |
| 52 | `52-gap-analysis-product-docs.md` | ~2624 | **N (0)** | Y | moderate-unsourced |
| 53 | `53-master-roadmap-proposal.md` | ~2642 | **N (0)** | n | moderate-unsourced |
| 54 | `54-development-standards-handbook.md` | ~3505 | **N (0)** | Y | substantial-unsourced |
| 55 | `55-streamer-guild-event-ux.md` | ~1768 | Y (10) | Y | substantial† |
| 56 | `56-wow-animationgroup-classic.md` | ~2519 | Y (12) | Y | substantial |

† Short body but citation-dense — length is the gap, not sourcing.  
‡ Longest brief, but almost unsourced externally (1 arXiv link); mostly templates + local doctrine.

---

## 4. Patterns

### 4.1 What is already in good shape

Early **tech / UX research** lanes (`01`–`02`, `05`–`08`, `10`–`14`, `16`, `18`–`19`, `22`, `27`–`28`, `33`, `35`, `56`) generally have:

- Multi-section structure with doctrine / matrices / CoB mapping  
- Real external URLs (warcraft.wiki.gg, GitHub, CurseForge, arXiv, Cursor docs, NN/g, Blizzard forums)  
- Explicit Sources (or equivalent) blocks  

### 4.2 Systemic gap: mid/late series is repo-only

From roughly **`24` onward**, many briefs are **internal synthesis** (spec, glossary, sister tracks under `wow-classic-addon-design/`, `.cursor/rules`). That is useful, but **26 of 54** have **zero** `http(s)` citations. Agents cannot verify claims against primary docs without leaving the repo.

Common anti-patterns:

- “Source index” that **names** papers/skills without URLs (`29`, `49`)  
- “Where to deepen” tables that only point at sister research tracks (`03`, `09`, `17`) — good for navigation, weak as external evidence  
- Process proposals (`34`, `37`, `38`, `39`, `40`) with no Cursor / Superpowers / industry citations  

### 4.3 Length distribution (shortest → longest)

**Shortest 10:** `09` (~1616) · `55` (~1768) · `42` (~1817) · `49` (~1855) · `47` (~1876) · `07` (~1880) · `03` (~1903) · `37` (~1926) · `29` (~1940) · `23` (~1943)

**Longest 5:** `30` (~3589) · `54` (~3505) · `10` (~3158) · `01` (~2988) · `36` (~2960)

---

## 5. Top 15 deepen targets

Ranked for **thinness + weak external sourcing + topic leverage**. Do **not** deepen in this pass — queue only.

| Rank | File | Words | Ext. URLs | Why deepen |
|-----:|------|------:|----------:|------------|
| 1 | `09-performance-budgets.md` | ~1616 | 1 | Shortest brief; only one Wowpedia `OnUpdate` link; numeric budgets need wiki/forum/profiler citations beyond sister tracks |
| 2 | `42-v1-vs-v2-juice-scope.md` | ~1817 | 0 | Thin scope map; no external phase/spectacle analogues; ends with related-notes only |
| 3 | `49-adversarial-overengineering.md` | ~1855 | 0 | Source index is name-only (early-stopping, Cursor, CoB rules) — needs URLs + concrete failure cases |
| 4 | `47-minimap-standing-glance-ux.md` | ~1876 | 0 | Product UX brief with zero external LDB/minimap/tooltip citations |
| 5 | `03-taint-lockdown-ux.md` | ~1903 | 0 | High-stakes Classic topic; defers entirely to sister tracks — needs warcraft.wiki.gg / secure-frame primaries |
| 6 | `37-skill-draft-polish-loop.md` | ~1926 | 0 | Skill draft with no links to Cursor `create-skill` / loop / Reflexion primaries |
| 7 | `29-superpowers-loop-patterns.md` | ~1940 | 0 | Lists local skill paths only; no public Superpowers/Cursor URLs |
| 8 | `55-streamer-guild-event-ux.md` | ~1768 | 10 | Second-shortest body — citations exist, but content depth lags peers; expand stream/guild-event patterns |
| 9 | `38-juice-spectacle-roadmap.md` | ~2090 | 0 | Roadmap with cross-links only; no external spectacle/cadence references |
| 10 | `34-cursor-rules-polish-proposal.md` | ~2130 | 0 | Rules proposal unsourced against Cursor rules docs / community patterns |
| 11 | `31-loop-stop-conditions.md` | ~2242 | 0 | Relies on local `_search-*.json` mentions; needs citable stop-condition literature |
| 12 | `39-ui-direction-standards-expansion.md` | ~2169 | 0 | Standards expansion without external motion/juice/a11y citations |
| 13 | `44-officer-commit-ux-juice.md` | ~2201 | 0 | Officer UX juice; zero external confirm/ceremony UX sources |
| 14 | `04-media-fonts-textures.md` | ~2042 | 3 | Light external set for a packaging-heavy topic; deepen LSM/TGA/atlas primaries |
| 15 | `17-ui-sound-design.md` | ~2223 | 3 | Mostly “where to deepen” into sister track; few first-party sound API / a11y URLs in-brief |

### Near-misses (next wave, not in top 15)

- `51-adversarial-performance-vs-juice.md` — unsourced adversarial twin of `09`  
- `40-major-leaps-dev-standards.md` — process SOP, zero URLs  
- `46-toast-celebration-system.md` — architecture body OK, unsourced  
- `30-writing-effective-agent-goals.md` — long but **1** external URL; citation pass would help  
- `25` / `26` / `32` — moderate length, unsourced process/QA (lower leverage than all-zero short briefs)

---

## 6. Gaps / series holes

| Hole | Note |
|------|------|
| **15** | Number skipped — no brief file |
| **21** | Number skipped — no brief file |
| Index / README | No series index markdown (only this audit as `00-`) |

If `15` / `21` were intended topics, they remain **unwritten** (worse than thin).

---

## 7. Method notes

- Inventory via filesystem glob of `[0-9]*.md` (54 files as of audit date).  
- External URL = unique `http(s)://…` in file body.  
- Relative links to `docs/`, `.cursor/`, `addon/`, and `wow-classic-addon-design/` counted as **internal**, not external.  
- `_search-*.json` ignored per request (scrapes are inputs, not briefs).  
- Substance labels are auditor judgment using the rubric in §2; they are not automated CI gates.

---

## 8. Recommended next pass (out of scope here)

1. Deepen the **Top 15** with annotated external URLs + 1–2 worked examples each.  
2. Citation pass on all **zero-URL** briefs ≥2.4k words (`24`–`26`, `32`, `36`, `40`–`41`, `43`, `45`–`46`, `48`, `51`–`54`).  
3. Decide whether missing **15** / **21** should be created or formally retired in a series README.
