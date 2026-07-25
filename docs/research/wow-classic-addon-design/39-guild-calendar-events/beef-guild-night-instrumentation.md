# Beef guild-night instrumentation ideas

**Question:** What should one real guild night log so §4.2 thresholds stop being fiction?  
**Answer short:** A **session-scoped metrics dump** (alpha/officer only): standing deltas by source, suggestion→approve funnel, announce reaction, BeefNet health, and who was online. Not a calendar product. Not continuous telemetry to a server.

Anchors: design spec §13 / §16.6; synthesis [00](../00-church-of-beef-implications.md) “Threshold playtest instrumentation.”

## Goals

| Goal | Success signal |
|------|----------------|
| Tune Fresh→Cooked (50?) | ≥1 new member hits suggestion after one full co-play night |
| Tune mid ladder (200 / 500 / 1000) | Officers see suggestions that match “this felt earned” |
| Validate social check | Promotion announce gets human reply in guild chat |
| Validate BeefNet | Offline member catches up next login; no version soft-lock panic |
| Keep ToS/in-game | Metrics stay in SavedVariables or `/beef dump` copy-paste — no HTTP |

## Session definition

Officer (or alpha) runs:

1. `/beef night start` — records `sessionId`, realm, guild, addon version, wall clock, roster online count  
2. Play the night normally  
3. `/beef night stop` — freezes counters; writes `ChurchOfBeefDB.nightLog[sessionId]`  
4. Optional: `/beef night report` — prints a pasteable summary for Discord #officers  

(Names illustrative — research only, no code here.)

## Metrics to capture

### A. Standing economy

| Field | Why |
|-------|-----|
| Per-character Δstanding by source (`instance` / `ceremony` / `gora`) | See which fuel actually moves the ladder |
| Cap hits (anti-farm / per-night caps) | If everyone pegs caps in 20 minutes, weights are wrong |
| Combat-active bucket count vs AFK-discarded buckets | Validates anti-AFK (§7.2) |
| Instance completion bonuses fired | Feeds track 15 reliability questions |

### B. Suggestion → officer funnel

| Field | Why |
|-------|-----|
| Suggestions created (who, from→to title, standing) | Volume vs noise |
| Time-to-first-officer-view (if measurable) | Offline officer problem (§16.5) |
| Approve / reject / ignore counts | Ignore means UI or process failure |
| Minutes from suggestion → `RANK_COMMIT` | Spectacle timing — mid-night vs after everyone left |

### C. Social check (spec §13)

| Field | Why |
|-------|-----|
| Announce attempted? (officer client) | Opt-out accidentally silencing spectacle |
| Announce text length / channel | Stream readability later (track 17) |
| **Manual** “got a reaction?” checkbox | Cannot reliably parse guild chat; officer marks yes/no + optional note |
| Online members at announce time | Context for silence (“only 3 people online”) |

### D. Ceremony thin path

| Field | Why |
|-------|-----|
| Ceremony start/stop timestamps | Duration sanity |
| Attendance marks granted | Compare to “people in raid” mental count |
| Disconnects mid-ceremony (spec §11) | Confirms no credit until clean close |

### E. BeefNet / sync health

| Field | Why |
|-------|-----|
| `RANK_COMMIT` send OK / throttle failures | Track 14 budgets |
| Version mismatch warnings shown | Soft-warn usefulness |
| Peers that applied commit (best-effort hello count) | Not ground truth — directional |
| Post-night: alt/offline login sync success (next day note) | Spec §13.8 |

### F. Context (cheap, high value)

| Field | Why |
|-------|-----|
| Interface build / TOC | Anniversary drift |
| Officer+ characters online during session | Gate capacity |
| Concurrent calendar addons detected (optional `IsAddOnLoaded`) | Coexistence notes — Classic Calendar, Group Calendar, etc. |
| Discord event? (manual yes/no + title string) | Links night to external RSVP without API |

## What not to instrument

| Skip | Reason |
|------|--------|
| Full combat log | Wrong product; privacy/noise |
| Discord RSVP lists | Out of game; ToS/external |
| `C_Calendar` scrape of who Accepted | Fragile; not V1 authority |
| Continuous background logging every login | Privacy + SV bloat; **session-scoped only** |
| Other players’ chat text | Store officer boolean + short note max |

## One-night playtest script (human)

1. Recruit 1 Fresh Beef volunteer + 1 Officer+ with addon  
2. Schedule a normal Discord guild night (no special Beef event required)  
3. `/beef night start` on officer (and volunteer if dual-logging metrics)  
4. Run at least one dungeon/BG with ≥2 guildmates; optional thin ceremony  
5. When volunteer crosses threshold, officer reviews suggestion **while people are still online**  
6. Approve → watch guild chat for reaction; tick social-check box  
7. `/beef night stop` → paste report to officers  
8. Next day: offline member logs in — confirm ladder sync  
9. Adjust `Data/Ranks.lua` thresholds; schedule night 2 only if numbers are absurd

## Success rubric (after night 1)

| Outcome | Action |
|---------|--------|
| No suggestions despite active night | Lower Cooked Beef threshold or raise instance drip |
| Suggestions but no approve (awkward UI) | UX fix before retuning numbers |
| Approve but no chat reaction | Announce copy / timing / opt-out — not thresholds |
| Caps hit by everyone instantly | Tighten anti-farm; don’t raise all thresholds blindly |
| BeefNet desync | Fix track 14 issues before trusting standing data |

## Related

- [14-addon-messaging-beefnet/classic-anniversary-realities.md](../14-addon-messaging-beefnet/classic-anniversary-realities.md) — guild-night messaging checklist  
- [19-testing-debugging-qa](../19-testing-debugging-qa/) — alpha channel before guild night  
- [15-instance-completion-events](../15-instance-completion-events/) — which completion events to trust in the dump