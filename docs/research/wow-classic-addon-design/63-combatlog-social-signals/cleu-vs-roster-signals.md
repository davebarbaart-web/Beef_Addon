# CLEU vs party / roster / regen signals for social scoring

**Track:** [63-combatlog-social-signals](README.md)  
**Last updated:** 2026-07-25  
**Question:** When (if ever) is `COMBAT_LOG_EVENT_UNFILTERED` the right tool for guild social scoring, versus group/roster and combat-flag events?

Confidence: **Doc** = wiki/Blizzard; **Infer** = Beef product conclusion (not Anniversary playtested as CLEU-on).

---

## 1. What CLEU actually answers

[`COMBAT_LOG_EVENT`](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT) / CLEU fire for combat-log lines: casts, damage, heals, auras, deaths, etc. Addons prefer **CLEU** (unfiltered) over `COMBAT_LOG_EVENT` because the filtered event only mirrors the **player’s combat-log window filters** — a global, UI-owned filter set ([2.4 Guide to the New Combat Log](https://wowwiki-archive.fandom.com/wiki/Patch_2.4.0/Consolidated_API_changes/Guide_to_the_New_Combat_Log); [wiki](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT)).

Payload (post-8.0 pattern, present on modern Classic clients) is read with [`CombatLogGetCurrentEventInfo()`](https://warcraft.wiki.gg/wiki/API_CombatLogGetCurrentEventInfo) — the event itself carries no args.

**CLEU is a firehose of combat *detail*.** Social scoring needs coarse *presence* and *session* facts.

---

## 2. What Beef scoring actually needs (§7)

| Needed fact | Spec use | Right event family |
|-------------|----------|--------------------|
| ≥1 **guildmate** in party/raid | Co-play gate | Group roster + guild membership checks ([59](../59-coplay-guildmate-detection/)) |
| In `party` / `raid` / `pvp` instance | Instance-only fuel | PEW + `IsInInstance` / `GetInstanceInfo` ([15](../15-instance-completion-events/)) |
| Entered combat this ~60s bucket | Anti-AFK | `PLAYER_REGEN_DISABLED` sticky flag ([15](../15-instance-completion-events/); [PLAYER_REGEN_DISABLED](https://wowpedia.fandom.com/wiki/PLAYER_REGEN_DISABLED)) |
| Finished content (optional) | Completion bonus | BG winner; optional encounter success ([15](../15-instance-completion-events/)) |
| Who did how much DPS/HPS | Not in V1 product | Would be CLEU / meters — **out of scope** |

None of the V1 grant edges require subevent parsing.

---

## 3. Decision matrix

| Candidate signal | CLEU approach | Prefer instead | Verdict for Beef |
|------------------|---------------|----------------|------------------|
| “Am I grouped with a guildmate?” | Scan CLEU `sourceFlags` / names for party affiliation | `GROUP_ROSTER_UPDATE` + iterate group units + guild check ([GROUP_ROSTER_UPDATE](https://warcraft.wiki.gg/wiki/GROUP_ROSTER_UPDATE)) | **Avoid CLEU** — roster is authoritative for membership |
| “Did I enter combat?” | Any damaging CLEU involving player GUID | `PLAYER_REGEN_DISABLED` / `UnitAffectingCombat("player")` | **Avoid CLEU** — regen is the combat-state event |
| “Was combat *meaningful*?” (not just flag) | CLEU damage thresholds | Spec accepts incidental combat vs AFK; caps handle farm (**Infer**) | **Avoid CLEU** — overfit invites abuse debates |
| “Did a boss die?” | `UNIT_DIED` + NPC ID tables | `ENCOUNTER_END` / `BOSS_KILL` ([15](../15-instance-completion-events/)) | **Avoid CLEU** — already **Low** reliability / high cost in track 15 |
| “Did we clear the dungeon?” | CLEU heuristics | No first-class Classic clear event; buckets + optional final-boss allowlist ([15](../15-instance-completion-events/)) | **Avoid CLEU** |
| “Fairness: who contributed?” | Full CLEU parse | Officer judgment + ceremony/Gora; no meter ranking (**Infer**, [26](../26-ladders-points-gamification/)) | **Never** — toxicity + product drift |
| Guild-night debug dump | Persist CLEU | Session metrics without combat log ([39](../39-guild-calendar-events/beef-guild-night-instrumentation.md)) | **Never** — privacy/noise |

---

## 4. When CLEU *would* be appropriate (narrow, not V1)

CLEU is appropriate when the product **is** a combat parser:

- Boss timers / mechanic alerts (BigWigs, DBM)
- WeakAuras combat triggers
- Damage/heal meters, death recaps
- Diagnostic tools that intentionally view raw CLEU (e.g. developer combat-log viewers)

Church of Beef is explicitly **not** that product ([08 implications](../08-combat-hud-alerts/church-of-beef-implications.md); spec §§1–2).

Hypothetical future Beef phases that still should **not** start with CLEU:

| Desire | Prefer before CLEU |
|--------|--------------------|
| Richer “in pull” telemetry | `ENCOUNTER_START` / `ENCOUNTER_END` |
| Stricter anti-AFK than regen | Rare edge cases only; prototype with regen first |
| Credit for rez / interrupt / utility | Product/Toxicity review first — usually still CLEU hell |

**Infer:** There is no Beef V1 scoring edge where CLEU is the *least* expensive correct tool.

---

## 5. Event cost shape (conceptual)

```text
GROUP_ROSTER_UPDATE     → rare (joins/leaves)     → recompute guildmatePresent
PLAYER_ENTERING_WORLD    → rare (loads)           → recompute instance session
PLAYER_REGEN_DISABLED    → per combat enter       → combatFlag = true
Bucket ticker (~60s)     → once per minute        → grant if session+flag
CLEU                     → many/sec in raid       → wrong duty cycle for social
```

Roster/regen are **bursty and sparse**. CLEU is **continuous under load**. Social addons should match sparse duty cycles ([54 good-looks-like-social](../54-memory-fps-budgets/good-looks-like-social.md)).

---

## 6. Anti-patterns if someone “just adds CLEU”

1. **Register CLEU globally, filter in Lua.** Still wakes the handler on every line; early-return still costs ([performance-cost.md](performance-cost.md)).
2. **Use filtered `COMBAT_LOG_EVENT`.** Depends on the user’s combat-log UI filters — silent false negatives ([2.4 guide](https://wowwiki-archive.fandom.com/wiki/Patch_2.4.0/Consolidated_API_changes/Guide_to_the_New_Combat_Log)).
3. **Treat CLEU timestamps as scoring clocks.** Bucket pacing uses `GetTime()` / day keys use `GetServerTime()` ([50](../50-time-timezones-resets/getservertime-vs-local.md)) — not CLEU forensics.
4. **Infer guildmate presence from CLEU flags.** Misses AFK guildmates who deal no damage; duplicates roster work; range caveats outdoors ([classic-anniversary-cleu-caveats.md](classic-anniversary-cleu-caveats.md)).

---

## 7. Steal / adapt summary

| Steal | Adapt for Beef |
|-------|----------------|
| CLEU for combat detail (wiki) | Leave to boss mods / meters |
| Regen = entered combat (wiki) | Sticky anti-AFK flag for buckets |
| `GROUP_ROSTER_UPDATE` = membership changes | Recompute co-play gate only |
| Track 15 “Avoid CLEU UNIT_DIED” | Extend avoid to **all** V1 scoring |
