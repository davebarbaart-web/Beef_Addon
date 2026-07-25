# Track 70 — Standing breakdown & My Standing UI

**Track id:** `70-standing-breakdown-ui`  
**Last updated:** 2026-07-25  
**Sole focus:** How Classic / social-score UIs answer **“why do I have N points?”** — personal summary, source chips, progress to next title, short event story — without DKP / EPGP spreadsheet density. Church of Beef **My Standing** tab design recommendations (spec §7, §10; plan Task 8).  
**Out of scope (do not duplicate):** Ladder economies, season resets, anti-farm math, spectacle vs toxicity, ranking-list UX ([26](../26-ladders-points-gamification/)); list scroll / row pools ([57](../57-scrollframe-list-rows/)); officer approve queue chrome ([40](../40-officer-moderation-audit/)); empty-state copy ([41](../41-empty-states-degraded-ux/)); lore string bible ([53](../53-beef-lore-ui-bible/)). No addon implementation in this folder.

## Product truth (from V1 spec + plan)

| Locked / planned | Value |
|------------------|-------|
| Tab | **My Standing** — points, next threshold, recent contributing events ([§10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Sources (3) | Shared instance co-play · Ceremony · Beef Gora ([§7.1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Point-driven titles | Ranks 1–5 only; Council / Prophet have **no** point threshold ([§4](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Authority | Standing = advisory testimony; officer commit = official ([§6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Plan StandingTab | Standing total, current title, next point threshold (or “Appointed ranks only”), last ~10 grant lines from history ring buffer (max 20) |

Sources: design spec §4, §6.3, §7, §10; plan Task 8 (`UI/StandingTab.lua`).

## Index

| Note | Covers |
|------|--------|
| [classic-score-breakdown-patterns.md](classic-score-breakdown-patterns.md) | How Classic cousins show “why N” without loot tables |
| [source-chips.md](source-chips.md) | Source labels / chips / badges vs filter UI |
| [progress-to-next-title.md](progress-to-next-title.md) | Next-threshold progress without fake XP / castbar wars |
| [density-antipatterns.md](density-antipatterns.md) | What DKP/EPGP/meter density looks like — and how to refuse it |
| [beef-v1-recommendation.md](beef-v1-recommendation.md) | **Recommended V1 My Standing composition** |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with track 26

| This track (70) | Track 26 |
|-----------------|----------|
| Personal **My Standing** layout | Macro ladder / ranking boards |
| Source chips + event story lines | Point economies, seasons, anti-farm incentives |
| Progress-to-next-title readout | “You + neighbors” leaderboard pattern |
| Anti-spreadsheet density on the *personal* tab | Toxicity / spectacle of public boards |

If a claim is about seven rank bands or guild-wide ranking psychology, it belongs in [26](../26-ladders-points-gamification/) — cite, don’t rewrite.

## Top insights for Beef (read this first)

1. **My Standing is a biography strip, not a ledger.** Healthy Classic analogues (Attune personal tree, Blizzard reputation watched bar, HonorSpy “estimate my progress,” CEPGP Standings Tracker *history* pane) answer three questions in order: **where am I → what’s next → what just happened.** They do not open with a sortable EP/GP matrix.

2. **Three source channels → three chips, not three columns.** Spec already has Instance / Ceremony / Gora. Show them as compact **source badges** (static labels) on the summary and on each history line. Interactive filter chips are optional later; V1 can use plain-text prefixes (`[Instance]`, `[Gora]`, `[Ceremony]`).

3. **Progress is determinate text first; bar second.** Blizzard reputation teaches `current / max within standing` via watched faction info (`GetWatchedFactionInfo` bounds). Beef should lead with **“N standing · M to Cooked Beef”** (or equivalent). A thin StatusBar is optional; never a castbar-shaped fake XP bar that fights ElvUI skins.

4. **“Why N” lives in a short event list.** Plan already caps history (~10 visible, ring ≤20). Each line = source chip + plain verb + amount + optional instance/opponent hint. That is the transparency officers need for §7.3 breakdowns — not a Details!-style meter essay.

5. **Appointed ranks kill the progress bar on purpose.** At Butcher+ eligibility for Council/Prophet, replace next-threshold chrome with **“Appointed ranks only”** (plan Task 8; lore bible [53](../53-beef-lore-ui-bible/)). Do not invent “points to Prophet.”

6. **DKP density is the failure mode, not the cousin to copy.** CEPGP guild windows and raid trackers prove guilds will tolerate spreadsheets for *loot*. Comedy standing must look like Attune’s personal clarity + Auctionator-lite summary, never OpenDKP columns.

## Recommended V1 composition (one line)

**Header (title + standing + next) → three source chips with today/cap hint → capped recent-events list; no spreadsheet.**

Detail: [beef-v1-recommendation.md](beef-v1-recommendation.md).

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer design spec + plan for product truth; Attune / reputation / HonorSpy / CEPGP-tracker listings for cousin UX; NN/g + chip pattern articles for progress / badge language.
