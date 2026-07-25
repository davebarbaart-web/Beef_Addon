# CLEU performance cost for a social Classic addon

**Track:** [63-combatlog-social-signals](README.md)  
**Last updated:** 2026-07-25  
**Maps to budgets:** [54-memory-fps-budgets](../54-memory-fps-budgets/beef-budgets.md), [good-looks-like-social.md](../54-memory-fps-budgets/good-looks-like-social.md)

---

## 1. Duty cycle mismatch

| Addon class | Typical CLEU stance | Acceptable idle/combat CPU |
|-------------|---------------------|----------------------------|
| Boss mod / WeakAuras / meters | CLEU is core | Visible cost during encounters is expected |
| Social guild ladder (Beef) | CLEU optional → **none** | Must be invisible next to the above ([54](../54-memory-fps-budgets/good-looks-like-social.md)) |

Track 54 rule: **Do not steal combat-addon budget.** Guildmates already run DBM / WeakAuras / ElvUI. Beef must stay out of their AddonUsage top offenders during pulls.

Deep research in [04](../04-toc-api-performance/) notes raid combat with many boss mods can cost **−3 to −10 FPS**, attributed largely to **CLEU event volume**, and that mature CLEU consumers (e.g. BigWigs patterns) throttle and batch rather than do heavy work synchronously per event. A social addon that registers CLEU without that engineering still **joins the subscriber list** for every line.

---

## 2. What “just listen and return” still costs

Even a handler that only does:

```text
On CLEU → CombatLogGetCurrentEventInfo() → if not interesting return
```

pays, per event:

1. Frame event dispatch into the addon
2. A function call into the combat-log getter
3. Lua branch / GUID compare noise

At raid CLEU rates (community/engineering consensus: **hundreds of events per second** under load — see [04 BigWigs throttling notes](../04-toc-api-performance/.raw/wow-classic-toc-api-perf.md)), that is continuous work **exactly when** FPS is scarcest.

**Infer for Beef:** There is no V1 feature whose value exceeds that tax. Regen fires once per combat enter; roster fires on membership change.

---

## 3. Budget table (design targets)

From [beef-budgets.md](../54-memory-fps-budgets/beef-budgets.md):

| Context | Beef target | CLEU-on risk |
|---------|-------------|--------------|
| Idle, UI closed | &lt; ~0.1 ms/s attributed | Low if CLEU quiet outdoors — still unnecessary registration |
| 25-man with full UI stack | Not in top CPU offenders | **High** — CLEU wakeups during pulls |
| Memory | Small structured tables | CLEU history caches are a common meter pattern — avoid |

**QA gate if CLEU ever appears in a branch:** AddonUsage during a boss pull must show Beef still bottom-tier vs disabled. Expect failure unless CLEU is unregistered.

---

## 4. Comparison: preferred sparse events

| Event | Rate in a dungeon hour | Work per fire (V1) |
|-------|------------------------|--------------------|
| `GROUP_ROSTER_UPDATE` | Tens | Recompute `guildmatePresent` |
| `PLAYER_ENTERING_WORLD` | Few | Refresh instance session |
| `PLAYER_REGEN_DISABLED` | Per pull / re-engage | Set sticky `combatFlag` |
| 60s bucket ticker | ~60/hour while instanced | One grant check |
| CLEU | Tens of thousands+ | Discard almost everything |

Sparse events match [04 events-vs-OnUpdate guidance](../04-toc-api-performance/03-events-onupdate-throttling.md): scoring should be event-driven and **coarse**.

---

## 5. Secondary costs beyond CPU

| Cost | Why CLEU hurts social products |
|------|--------------------------------|
| Complexity | Prefix/suffix tables, flags, GUID parsing, locale names |
| False confidence | Missing events (range, ACL bugs) look like “player AFK” |
| Product drift | Easy to slide into meter / interrupt scoring ([26](../26-ladders-points-gamification/)) |
| Privacy | Persisting CLEU ≈ full combat surveillance ([39](../39-guild-calendar-events/beef-guild-night-instrumentation.md) — skip full combat log) |

---

## 6. Recommendation tied to cost

**Do not register CLEU in V1.** Prefer:

- Roster + guildmate detection ([59](../59-coplay-guildmate-detection/))
- Instance session + regen anti-AFK ([15](../15-instance-completion-events/))
- Optional encounter/BG completion without CLEU ([15](../15-instance-completion-events/))

If a future design doc claims CLEU is required, it must show a **measured** AddonUsage win over regen/roster alternatives on Anniversary — not a Retail meter tutorial.
