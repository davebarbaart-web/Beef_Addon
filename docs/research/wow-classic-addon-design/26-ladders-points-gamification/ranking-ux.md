# Ranking UX for social ladders

**Track:** 26 · **Scope:** How to present ranks and standing so the ladder feels alive, fair, and scannable — not like a raid spreadsheet or PvP ladder anxiety machine.

## Spec anchor

V1 UI: **Ladder** (seven ranks + occupants + local highlight), **My Standing** (points, next threshold, recent events), Officer queue with breakdown ([design spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

## What research says works

### 1. A board must move on a human timescale

A leaderboard dies when nobody can climb in a session or a guild night. Tie visible progress to scores that can change *significantly in an acceptable amount of time*; stale boards lose attention fast ([Building better leaderboards — UX Collective](https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7)).

**Beef implication:** Early threshold (Fresh → Cooked at ~50) matching “first dungeon night” is the right UX hook. Later thresholds should still produce *visible* My Standing movement even when title changes are rare.

### 2. Absolute top-N lists need a “you are here” rail

Pattern guidance: list a fixed number of competitors, but **show the user’s placement and who sits immediately above/below** so climbing stays imaginable without staring at unreachable elites. Prefer contextual / friends / local cohorts over global strangers. Default short windows (weekly/daily) when all-time boards stagnate ([UI Patterns: Leaderboard](https://ui-patterns.com/patterns/leaderboard)).

**Beef implication:** Ladder tab = seven *title buckets* (macro structure). My Standing = personal progress + recent events (micro feedback). Optionally surface “nearest rivals” (same rank band, points delta) without inventing a second global sort of raw standing that reintroduces grind anxiety.

### 3. Macro + micro boards beat one giant list

Educational game research distinguishes **macro** leaderboards (overall content / season) from **micro** boards (subsection / activity). Design objectives include minimizing relative deprivation and failure spirals while maximizing reachable success ([PMC8097522](https://pmc.ncbi.nlm.nih.gov/articles/PMC8097522/)).

**Beef implication:**

| Surface | Role |
|---------|------|
| Ladder tab | Macro: who holds which *title* |
| My Standing | Micro: personal score, next threshold, event log |
| Gora / ceremony toasts | Micro: immediate feedback loop |
| Guild-chat line | Spectacle ping for non-addon members |

Do **not** collapse everything into one dense points table (anti-pattern already noted in auction/loot UX tracks).

### 4. Parallel goals > single “be #1”

Even a simple ordered list creates multiple goals at once: beat the person above you, reach a milestone, aspire to the top ([UX Collective](https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7)). Named tiers already encode this; raw Elo-style ladders often collapse to one goal.

**Beef implication:** Keep titles as the primary visual; standing numbers support eligibility, they should not dominate the chrome.

### 5. Use leaderboards only where competition is the point

UI Patterns: use when the community is *already* competitive; introducing boards into non-competitive spaces invites gaming and non-constructive behavior ([UI Patterns](https://ui-patterns.com/patterns/leaderboard)).

**Beef implication:** Church of Beef *is* rivalry comedy — the ladder fits. Still: keep it opt-in spectacle (minimap/`/beef`), not a forced always-on combat HUD overlay.

## Ranking UX checklist (Ladder + Standing)

| Do | Don’t |
|----|-------|
| Seven scannable rank rows with occupants | Auctionator-density columns of every point source |
| Local player highlight + current title | Fake health bars / unit-frame metaphors for standing |
| Next-threshold progress on My Standing | Hiding progress until officer opens the queue |
| Recent contributing events (why you scored) | Opaque “+points” with no story |
| Officer view of breakdown before commit | Auto-promote on threshold |
| Optional “weekly movers” later | Defaulting to all-time raw standing sort as the hero view |

## Relation to other tracks

- Visual language / unit-frame anti-patterns: see library UX tracks — do not restyle the ladder as raid frames.
- Cousin tear-downs (Attune progress trees): borrow *progress clarity*, not survey density (track 13 — not duplicated here).
