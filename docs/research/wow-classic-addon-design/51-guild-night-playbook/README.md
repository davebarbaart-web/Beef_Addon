# Track 51 — Guild-night playbook & instrumentation

**Track id:** `51-guild-night-playbook`  
**Last updated:** 2026-07-25  
**Lane:** Ops / playtest runbook (no implementation code)  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4.2 (thresholds), §7 (scoring), §10 (spectacle announce), §13 / §13.11 (success + social check), §16.6 (threshold tuning open question); synthesis nudge #8 in [00-church-of-beef-implications.md](../00-church-of-beef-implications.md)

**Scope:** How to *run* the first real Church of Beef guild night — install ladder, facilitator roles, live observation, and the measurement sheet that replaces draft thresholds (50 / 200 / 500 / 1000). Human process first; addon features are assumed buildable from the V1 plan.

**Out of scope:**

| Topic | Where it lives |
|-------|----------------|
| Calendar / RSVP / in-game event APIs | Track 39 (do not duplicate here) — schedule the night with Discord / whatever the guild already uses |
| BeefNet prefix, CTL budgets, sync chunking | [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/) |
| Conflict / revision merge policy | [27-desync-conflict-resolution](../27-desync-conflict-resolution/) |
| Lab scenarios, BugSack, alpha channels (deep) | [19-testing-debugging-qa](../19-testing-debugging-qa/) — this track *consumes* those, does not redefine them |
| Scoring formula implementation | Core / plan Task ladder; this track only defines what to *observe* |

## Index

| Note | Topic |
|------|--------|
| [operational-runbook.md](operational-runbook.md) | T−7d → post-night operational runbook |
| [instrumentation-and-thresholds.md](instrumentation-and-thresholds.md) | What to measure; how to retune §4.2 |
| [facilitator-roles.md](facilitator-roles.md) | Named facilitator roles for the night |
| [annotated-urls.md](annotated-urls.md) | Analogues & primary URLs (ops, not calendar APIs) |

## Top insights for Church of Beef

1. **Threshold tuning is a one-night field study, not a library problem.** Spec §16.6 and synthesis #8 already say this — Track 51 is the clipboard for that night.
2. **Pacing rule is the acceptance bar for Cooked Beef.** A new member’s *first full dungeon night with guildmates* should produce Fresh → Cooked suggestion eligibility (spec §4.2). If nobody hits 50, weights are too stingy; if half the roster hits Knight in one evening, thresholds (or drip) are too soft.
3. **Spectacle is a pass criterion separate from “addon works.”** Spec §13.11: at least one promotion with a *visible guild-chat reaction*. Instrument announce opt-out so officers do not silence the only public proof of success.
4. **Borrow facilitator patterns from loot-council / points addons, not from calendars.** RCLootCouncil “test before raid,” CEPGP officer-note discipline, and GuildHelper multi-client culture map cleanly to Beef’s Officer tab + BeefNet — without scheduling APIs.
5. **Keep roles thin.** One Night Lead, one Score Desk (instrumentation), one Spectacle Watcher (chat/stream), optional Tech Spotter (BugSack). More cooks → delayed approvals and muted comedy.
6. **Dreamscythe and Doomhowl are separate nights.** Spec §5: independent ladders per guild/realm/faction — run the playbook twice if both guilds launch; never expect cross-sync.

## Boundary map

```
Schedule the night ──► Discord / guild habit (not this track; not calendar API research)
Install + smoke     ──► Track 19 QA checklist patterns
Live night ops      ──► THIS TRACK
Net / desync issues ──► Tracks 14 / 27 (escalate, don’t redesign mid-night)
Retune Ranks.lua    ──► Instrumentation sheet → officer decision → canon data change
```

## Provenance

Product truth from the V1 design spec and plan. Ecosystem analogues linked in [annotated-urls.md](annotated-urls.md). No `.raw/` scrapes required for this ops track; cite existing research tracks where technical detail is needed.
