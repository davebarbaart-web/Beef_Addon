# Annotated URLs — CLEU / social scoring signals

**Track:** [63-combatlog-social-signals](README.md)  
**Last updated:** 2026-07-25  
**Rule:** Only URLs that informed this track’s claims. Steal/adapt notes are Beef-specific.

Provenance JSON/MD under [`.raw/`](.raw/).

---

## Primary CLEU / combat-log API docs

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| `COMBAT_LOG_EVENT` (wiki.gg) | https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT | CLEU vs filtered event; payload via getter; Classic range/spellId patch notes; Advanced Combat Log | Prefer CLEU only if building a combat parser — **V1 does not** |
| `COMBAT_LOG_EVENT` (Wowpedia) | https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT | Cross-check Classic hotfix bullets | Same avoid stance |
| `CombatLogGetCurrentEventInfo` | https://warcraft.wiki.gg/wiki/API_CombatLogGetCurrentEventInfo | Post-8.0 payload access pattern | If anyone prototypes CLEU, use getter — never ship it for scoring |
| Combat Log Event Changes (Blizzard) | https://us.battle.net/forums/en/wow/topic/20762318007 | Official note: payload moved off the event (8.0) | Confirms modern Classic/Retail-shaped API |
| 2.4 Guide to the New Combat Log | https://wowwiki-archive.fandom.com/wiki/Patch_2.4.0/Consolidated_API_changes/Guide_to_the_New_Combat_Log | Filtered vs UNFILTERED design intent; global filters | Never use filtered `COMBAT_LOG_EVENT` for grants |
| Blue Tracker 2.4 CLEU note | https://www.bluetracker.gg/wow/topic/eu-en/2405449147-05-02-240-guide-to-the-new-combat-log/ | Mirror of Slouken CLEU guidance | Historical confirmation |

---

## Coarse alternatives (what Beef should use)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| `PLAYER_REGEN_DISABLED` (Wowpedia) | https://wowpedia.fandom.com/wiki/PLAYER_REGEN_DISABLED | Enter combat = hate list or PvP action | Sticky anti-AFK flag for instance buckets |
| `PLAYER_REGEN_DISABLED` (wiki.gg) | https://warcraft.wiki.gg/wiki/PLAYER_REGEN_DISABLED | Same event on current wiki | Cross-check if fandom extract flakes |
| `GROUP_ROSTER_UPDATE` | https://warcraft.wiki.gg/wiki/GROUP_ROSTER_UPDATE | Fires on group/raid form/disband/join/leave; added **5.0.4 / 1.13.2** | Recompute guildmate co-play gate — not CLEU flags |

---

## Classic range / hotfix history

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| In-Game Combat Log Range Decreased (Kaivax) | https://us.forums.blizzard.com/en/wow/t/in-game-combat-log-range-decreased/370390 | 50-yard in-game CLEU radius; does not affect file raid logs | Do not invent open-world CLEU social credit |
| Wowhead: range reduced | https://www.wowhead.com/classic/news/in-game-combat-log-range-reduced-to-50-yards-in-classic-wow-296592 | Secondary report of 2019 hotfix | Corroboration only |
| Wiki Classic notes (2020-06-22 unrestricted in instances) | https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT | Dungeons/raids unrestricted; outdoor still ~50 yd | Instance CLEU = high volume — worse for Beef CPU |

---

## Reliability / Advanced Logging caveats

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| WoWUIBugs #326 ACL CLEU drops | https://github.com/Stanzilla/WoWUIBugs/issues/326 | Advanced Combat Logging can omit in-game CLEU events (Mainline, Blizzard-acked) | Don’t depend on CLEU completeness for standing |
| Stack Overflow CLEU example (Classic) | https://stackoverflow.com/questions/58345386/wow-classic-1-13-addons-events-combat-text-update-how-to-fix-my-code | Canonical “register CLEU + getter” snippet | Pattern for combat tools — **not** for CoB scoring |

---

## Portability / product-boundary (secondary)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Midnight CLEU removal migration note | https://github.com/Xerrion/DragonShout/issues/28 | Retail direction: CLEU leaving addon surface | Design Beef on coarse events *now*; Anniv not Midnight |
| Wick’s Combat Log (CurseForge TBC) | https://www.curseforge.com/wow/addons/wicks-combat-log | Proves CLEU viewers exist for Classic TBC | Diagnostic niche — Beef must not become one |
| WoWInterface CLEU timing thread | https://www.wowinterface.com/forums/showthread.php?t=20649 | CLEU timing vs `GetTime` jitter | Reinforces: don’t use CLEU clocks for Beef buckets |

---

## Internal repo anchors

| Source | Path | Use for |
|--------|------|---------|
| This track decide/avoid | [`beef-v1-recommendation.md`](beef-v1-recommendation.md) | V1 ship gate + strong-justification bar |
| Gap audit ask (item 9) | [`../56-coverage-gap-audit/priority-next-research.md`](../56-coverage-gap-audit/priority-next-research.md) | Why this synthesis exists |
| Design spec §7 | [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Co-play + anti-AFK + instance-only |
| Track 15 matrix (CLEU UNIT_DIED = Avoid) | [`../15-instance-completion-events/event-reliability-matrix.md`](../15-instance-completion-events/event-reliability-matrix.md) | Prior reject of CLEU for boss grants |
| Track 08 implications | [`../08-combat-hud-alerts/church-of-beef-implications.md`](../08-combat-hud-alerts/church-of-beef-implications.md) | Stay off combat HUD / CLEU culture |
| Track 54 social perf shape | [`../54-memory-fps-budgets/good-looks-like-social.md`](../54-memory-fps-budgets/good-looks-like-social.md) | No combat-log-heavy duty cycle |
| Track 39 “no full combat log” | [`../39-guild-calendar-events/beef-guild-night-instrumentation.md`](../39-guild-calendar-events/beef-guild-night-instrumentation.md) | Instrumentation privacy |
| Track 50 CLEU clocks note | [`../50-time-timezones-resets/getservertime-vs-local.md`](../50-time-timezones-resets/getservertime-vs-local.md) | Anti-AFK ≠ CLEU timestamp forensics |
| Track 04 CLEU FPS / BigWigs throttle | [`../04-toc-api-performance/.raw/wow-classic-toc-api-perf.md`](../04-toc-api-performance/.raw/wow-classic-toc-api-perf.md) | CLEU volume as FPS cost |

---

## Deliberately not relied on

- Bot / automation forum CLEU snippets (OwnedCore etc.) — wrong domain for Beef design.
- FFXIV / other-game “combat log” tutorials from search noise.
- Rebuilding combat HUD atlas ([08](../08-combat-hud-alerts/)) or full instance event matrix ([15](../15-instance-completion-events/)) inside this track.
