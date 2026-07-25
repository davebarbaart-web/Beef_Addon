# Beef V1 decide/avoid — CLEU for social scoring

**Track:** [63-combatlog-social-signals](README.md)  
**Last updated:** 2026-07-25  
**Audience:** Implementers of `Core/Instance` / scoring hooks; reviewers tempted to “borrow” meter/boss-mod CLEU patterns.  
**Decision:** **Avoid CLEU for Beef V1** unless a future change meets the strong-justification bar below (none does today).

This is the short synthesis the coverage gap audit asked for ([56 priority item 9](../56-coverage-gap-audit/priority-next-research.md)): an explicit “do not use CLEU for V1 standing” note so scope cannot creep back in through combat-addon habits.

---

## 1. Locked recommendation

| Item | V1 stance |
|------|-----------|
| `RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")` | **Do not ship** |
| `RegisterEvent("COMBAT_LOG_EVENT")` (filtered) | **Do not ship** — worse: depends on UI filters |
| Dormant CLEU behind a feature flag | **Do not leave registered** — dispatch cost remains while registered |
| Alpha-only CLEU experiment | Allowed only as a throwaway profiler harness; must be deleted before Release |
| Standing / suggestions / SCORE_EVENT inputs | **Never** derived from CLEU subevents |

**One-liner:** Church of Beef scores *who you played with* and *whether you were in combat*, not *what the combat log said*.

---

## 2. Why avoid (arguments, not vibes)

### Product / ToS shape

- Spec §§1–2: social ladder and spectacle — not combat assistance ([design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- CLEU is the native hot path of meters, WeakAuras, and boss mods ([08 implications](../08-combat-hud-alerts/church-of-beef-implications.md)).

### Correct cheaper APIs already exist

| Needed | API family | Owned by |
|--------|------------|----------|
| Guildmate in group | `GROUP_ROSTER_UPDATE` + group unit iteration + guild check | [59](../59-coplay-guildmate-detection/) |
| In dungeon/raid/BG | `PLAYER_ENTERING_WORLD` + `IsInInstance` / `GetInstanceInfo` | [15](../15-instance-completion-events/) |
| Anti-AFK combat | `PLAYER_REGEN_DISABLED` sticky flag (± `UnitAffectingCombat`) | [15](../15-instance-completion-events/) |
| Completion / progress | BG winner; optional `ENCOUNTER_END` / `BOSS_KILL` | [15](../15-instance-completion-events/) |

CLEU `UNIT_DIED` for bosses is already **Avoid** in the instance matrix ([15 event matrix](../15-instance-completion-events/event-reliability-matrix.md)).

### CPU / FPS

- Raid CLEU is high volume; combat stacks already pay for it ([04](../04-toc-api-performance/), [54](../54-memory-fps-budgets/beef-budgets.md)).
- Beef’s budget: stay invisible during pulls — CLEU registration fights that ([performance-cost.md](performance-cost.md)).

### Classic Anniversary reliability caveats

- Outdoor ~50 yd range; instances unrestricted → worst volume where Beef runs ([classic-anniversary-cleu-caveats.md](classic-anniversary-cleu-caveats.md); [Kaivax hotfix](https://us.forums.blizzard.com/en/wow/t/in-game-combat-log-range-decreased/370390)).
- Advanced Combat Logging can drop in-game CLEU events relative to file logs ([WoWUIBugs #326](https://github.com/Stanzilla/WoWUIBugs/issues/326) — Mainline; treat as hostility-to-CLEU evidence).
- Filtered CLEU variant is non-deterministic across player UI settings ([2.4 guide](https://wowwiki-archive.fandom.com/wiki/Patch_2.4.0/Consolidated_API_changes/Guide_to_the_New_Combat_Log)).

### Privacy / culture

- Full combat-log instrumentation is explicitly out for guild-night dumps ([39](../39-guild-calendar-events/beef-guild-night-instrumentation.md)).
- CLEU-based “contribution” scoring invites meter toxicity ([26](../26-ladders-points-gamification/)).

### Taint / lockdown

- CLEU itself is not a secure-template path, but combat-time CLEU work competes with protected UI and pull noise. Spec/UI guidance already prefers deferring social spectacle during combat ([08](../08-combat-hud-alerts/church-of-beef-implications.md)). Prefer not adding a combat-hot-path listener at all.

---

## 3. Strong-justification bar (when CLEU could be reconsidered)

CLEU may be revisited **only if all** of the following are true. **None are true for V1.**

1. **Missing fact:** A shipped scoring rule requires a combat detail that regen + encounter/BG APIs cannot supply (documented in spec, not a wishlist).
2. **Measured necessity:** AddonUsage / `scriptProfile` on Anniversary `20506` shows a CLEU-backed prototype is *cheaper or equally invisible* vs the sparse-event design during a 25-man pull — written evidence, not anecdote.
3. **Scoped registration:** CLEU is registered only inside an active scoring session (instanced + guildmate present) and **unregistered** otherwise; handler does GUID/subevent short-circuit with zero allocations.
4. **No grant from fragile subevents:** No standing from `UNIT_DIED` NPC tables, damage totals, or interrupt counts without a separate product/toxicity review.
5. **Officer/product sign-off:** Explicit acceptance that Beef is taking on combat-parser maintenance and Classic CLEU caveats.

If any item fails → **keep avoid**.

---

## 4. Implementer checklist (V1)

- [ ] No CLEU / `COMBAT_LOG_EVENT` in TOC-loaded Lua for Release.
- [ ] Anti-AFK uses regen (or poll sticky) per [15](../15-instance-completion-events/).
- [ ] Co-play gate uses group/guild APIs per [59](../59-coplay-guildmate-detection/).
- [ ] Completion uses BG/encounter APIs per [15](../15-instance-completion-events/) — not CLEU.
- [ ] Code review rejects PRs that add CLEU “for fairness” or “for better AFK detection” without meeting §3.

---

## 5. Pointers (do not rebuild here)

| Topic | Read |
|-------|------|
| CLEU vs roster decision matrix | [cleu-vs-roster-signals.md](cleu-vs-roster-signals.md) |
| Anniversary range / spellId / ACL | [classic-anniversary-cleu-caveats.md](classic-anniversary-cleu-caveats.md) |
| FPS budgets | [performance-cost.md](performance-cost.md) |
| URLs | [annotated-urls.md](annotated-urls.md) |
| Instance/encounter (not CLEU) | [15](../15-instance-completion-events/) |
| Combat HUD non-goals | [08](../08-combat-hud-alerts/) |
