# Event / API reliability matrix (Classic → Beef)

**Track:** [15-instance-completion-events](README.md)  
**Last updated:** 2026-07-25  
**Reliability legend:** **High** (safe V1 dependency) · **Medium** (use with guards) · **Low** (prototype or avoid for grants) · **N/A** (wrong tool)

Confidence notes:

- Claims tagged **Doc** are from wiki / Blizzard forum / community API docs in [annotated-sources.md](annotated-sources.md).
- Claims tagged **Infer** are design conclusions for Beef (not in-game verified on `20506`).
- Claims tagged **Prototype** need Anniversary playtest before scoring depends on them.

---

## 1. Zoning & instance identity

| Signal | API / event | Classic availability | Reliability | False positives / pitfalls | Beef use |
|--------|-------------|----------------------|-------------|----------------------------|----------|
| Enter/leave instance (loading screen) | `PLAYER_ENTERING_WORLD` (`isInitialLogin`, `isReloadingUi`) | All Classic (**Doc**) | **High** for “loading screen happened” | Also fires on login & `/reload` — must re-evaluate instance state, not treat as “entered dungeon” (**Doc**) | Start/stop co-play session; refresh `IsInInstance` / `GetInstanceInfo` |
| Am I instanced? | `IsInInstance()` → `inInstance`, `instanceType` | Added **1.11.0 / 1.13.2** (**Doc**) | **High** on PEW | Types: `none`, `party`, `raid`, `pvp`, `arena`, `scenario` — filter to dungeon/raid/BG only; ignore cities/`none` (**Doc**) | Gate all instance scoring |
| Instance metadata | `GetInstanceInfo()` → name, `instanceType`, difficulty, maxPlayers, instanceID, … | All Classic family (**Doc**) | **High** when in instance | Extra Retail-era returns may be nil/unused on Anniv; don’t require LFG dungeon IDs (**Infer**) | Label events (“Hellfire Ramparts”); difficulty for caps later |
| Subzone / channel zone change | `ZONE_CHANGED`, `ZONE_CHANGED_NEW_AREA`, `ZONE_CHANGED_INDOORS` | All Classic | **Low** for instance enter | Community reports: zoning into instance often **does not** fire zone events; PEW is the correct hook (**Doc** — WoWInterface) | Avoid for instance detection |
| Map coordinate tricks at PEW | `GetPlayerMapPosition` / map updates around PEW | Legacy | **Low** | Old notes: coords can be `0,0` mid-transition; second map update later (**Doc** — archive Events/P) | Avoid; use `IsInInstance` |

**Beef rule:** On every PEW, compute `qualifying = instanceType ∈ {party, raid, pvp}` (optionally include `arena` if guild arenas should score — default **off** for V1 social co-play). Cities and open world never pay ([spec §7.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 2. Encounter / boss kill (progress, not clear)

| Signal | API / event | Classic availability | Reliability | False positives / pitfalls | Beef use |
|--------|-------------|----------------------|-------------|----------------------------|----------|
| Encounter ended | `ENCOUNTER_END`: `encounterID`, `encounterName`, `difficultyID`, `groupSize`, `success` | Fires on Classic (**Doc** — Classic bug report). Retail add: **5.4.7** (**Doc**). Anniv coverage of all TBC bosses: **Prototype** | **Medium** when using `success` + `encounterID` | `success == 0` = wipe — never grant. `encounterName` can be `"*"` on zhCN (ruRU suspected) — **never key grants on name** (**Doc**). IDs ≠ Encounter Journal IDs (**Doc**). Not every trash pack is an encounter. | Optional: log kill; optional allowlisted “final boss” complete; never raw spam `SCORE_EVENT` |
| Encounter started | `ENCOUNTER_START`: id, name, difficulty, groupSize | Same family as END (**Doc** / **Infer**) | **Medium** | Engage ≠ kill; wipes restart | Anti-AFK context / “in a pull” telemetry only |
| Boss killed | `BOSS_KILL`: `encounterID`, `encounterName` | Added **6.1.0 / 1.13.2** — present on Classic Era UI source (**Doc**) | **Medium** | Also fires for **open-world** bosses (**Doc**). Name locale risk same class as END (**Infer**). May duplicate END. | Prefer as corroboration of kill; require `IsInInstance()` + `party`/`raid` before any credit |
| Boss unit engage | `INSTANCE_ENCOUNTER_ENGAGE_UNIT` | Exists on Classic-family event lists (**Doc**) | **Low** for scoring | Engage spam; no success bit | Skip for V1 points |
| Combat log UNIT_DIED | `COMBAT_LOG_EVENT_UNFILTERED` | All Classic | **Low** for “boss” | Requires NPC ID tables; pets/totems/adds; combat log range; high CPU — wrong for a social addon (**Infer**) | Avoid |

### What “dungeon complete” would require (no API)

Classic 5-mans have **no** LFG completion reward event. A heuristic “clear” needs:

1. Allowlist of **final** encounterIDs per `instanceID` / map, **and**
2. `ENCOUNTER_END`/`BOSS_KILL` with `success`, **and**
3. Acceptance of false negatives (skip last boss, leave early, wing instances, broken ID coverage)

**Infer:** Too brittle for automatic standing that drives promotion suggestions. Prefer buckets + BG complete; leave PvE complete as optional/prototype.

---

## 3. Lockouts, saves, resets

| Signal | API / event | Classic availability | Reliability | False positives / pitfalls | Beef use |
|--------|-------------|----------------------|-------------|----------------------------|----------|
| Request lockout snapshot | `RequestRaidInfo()` → async `UPDATE_INSTANCE_INFO` | Long-standing (**Doc** — since ~1.11 family for saved info) | **Medium** for “what am I saved to” | Not instantaneous; must wait for event before reading (**Doc**) | Officer debug / My Standing “saved to X”; not a grant edge |
| Read lockouts | `GetSavedInstanceInfo(index)` → name, lockoutId, reset, difficulty, locked, isRaid, maxPlayers, numEncounters, encounterProgress, … | Added **1.11.0** (**Doc**) | **Medium** | First boss often creates lockout ≠ full clear. Heroic daily vs raid ID semantics differ. Index list changes over time. | Optional enrichment of suggestion breakdown |
| Reset all instances | `ResetInstances()` | All Classic (**Doc**) | N/A (player action) | Signals **farming**, not finishing | Never grant; may inform anti-farm telemetry later |
| System reset chat | `CHAT_MSG_SYSTEM` matching reset strings | All Classic | **Low** | Locale-dependent strings; noisy | Avoid for grants |

---

## 4. Battlegrounds / arenas

| Signal | API / event | Classic availability | Reliability | False positives / pitfalls | Beef use |
|--------|-------------|----------------------|-------------|----------------------------|----------|
| Match has a winner | `GetBattlefieldWinner()` → `nil` / `0` / `1` / `255` | Classic BG API (**Doc**) | **High** once non-nil | Poll/react when scoreboard updates; leaving early may miss if not careful — grant once per battlefield instance id (**Infer**) | **Best completion bonus** for `pvp` |
| Scoreboard / status updates | `UPDATE_BATTLEFIELD_SCORE`, `UPDATE_BATTLEFIELD_STATUS` | Classic family (**Infer** / common addon practice) | **Medium** | Fire often; use as “check winner now,” not as grant themselves | Trigger to re-read `GetBattlefieldWinner` |
| Arena end | Same winner API (team colors) | TBC has arenas | **Medium** | Spec co-play is dungeon/raid/BG — decide if arenas count (**product**) | Default exclude unless guild wants them |

---

## 5. Combat / anti-AFK (bucket fuel)

| Signal | API / event | Classic availability | Reliability | False positives / pitfalls | Beef use |
|--------|-------------|----------------------|-------------|----------------------------|----------|
| Enter combat | `PLAYER_REGEN_DISABLED` | All Classic (**Doc**) | **High** | PvP flag / incidental combat near entrance still counts — acceptable vs pure AFK (**Infer**) | Set `sawCombatThisBucket = true` |
| Leave combat | `PLAYER_REGEN_ENABLED` | All Classic | **High** | — | Optional |
| Poll combat | `UnitAffectingCombat("player")` | All Classic | **High** | Misses “was in combat earlier this minute” if only polled at bucket end — prefer sticky flag from REGEN_DISABLED (**Infer**) | Spec plan allows either; sticky flag is safer |

---

## 6. Retail-only / do-not-use on Anniv V1

| Signal | Why excluded |
|--------|----------------|
| `LFG_COMPLETION_REWARD`, RDF/M+ complete flows | Not the Anniversary 5-man social model |
| Challenge Mode / `C_ChallengeMode` / keystone complete | Retail / later progression Classic |
| Scenario completion APIs | `scenario` type not a TBC Anniv scoring target |
| Midnight encounter messaging clamps | Portability watch only ([implications](../00-church-of-beef-implications.md)); irrelevant to detection |

---

## 7. False-positive matrix (grants)

| Bad trigger | Why it fires | Mitigation |
|-------------|--------------|------------|
| Login / reload inside instance | PEW | Require guildmate check + combat before first bucket; don’t grant complete on PEW |
| Standing at portal with guildmate | In instance, no combat | Combat sticky flag per bucket ([spec §7.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Wipe | `ENCOUNTER_END` success 0 | Require `success == 1` |
| World boss outdoors | `BOSS_KILL` | Require `IsInInstance()` and type filter |
| Locale `"*"` name match fails | `ENCOUNTER_END` name | Key on `encounterID` only |
| Mid-run leave / partial clear | No event | Don’t invent complete; buckets already paid fair share |
| Instance reset spam farming | Reset APIs / chat | Daily caps; ignore resets |
| Duplicate END + BOSS_KILL | Both fire | Dedupe by encounterID + instanceID + time window |
| Solo instance / no guildmate | Valid instance | Co-play gate (≥1 guildmate in party/raid) — separate from this track’s APIs |

---

## 8. Suggested detector architecture (no code — policy only)

```text
PEW / (optional) delayed recheck
  → GetInstanceInfo / IsInInstance
  → if type in {party,raid,pvp} and guildmate in group:
        session.active = true

On PLAYER_REGEN_DISABLED (while session.active):
  → session.combatFlag = true

Every N seconds (plan: 60s):
  → if session.active and combatFlag → GrantInstanceBucket; clear flag

Completion (optional layer):
  → if type == pvp and GetBattlefieldWinner() ~= nil → GrantInstanceComplete (once)
  → if type in {party,raid} and ENCOUNTER_END success
        and encounterID in FinalBossAllowlist[instanceID]
        → GrantInstanceComplete (once)   [PROTOTYPE — ship off by default]
  → else: no PvE complete grant (buckets only)  [matches §16.4 fallback]
```

---

## 9. Anniversary playtest checklist

Run on Dreamscythe/Doomhowl Anniv with `/etrace` or a temporary logger (not shipped):

1. Enter Hellfire Ramparts with guildmate → PEW + `party` + name/id.
2. AFK at entrance 2+ minutes → **0** buckets.
3. Combat trash → ≥1 bucket.
4. Kill first boss → does `ENCOUNTER_END` and/or `BOSS_KILL` fire? Log raw args (id, name, success).
5. Kill final boss → same; note whether a distinct “complete” ever appears (expect **no**).
6. Wipe on a boss → `success == 0` only.
7. Finish a BG → when does `GetBattlefieldWinner` flip; grant once.
8. zhCN or non-enUS client if available → confirm name `"*"`; grants must still work via id.
9. `/reload` inside dungeon → no complete grant; session resumes cleanly.
10. Reset instances after a run → no grant.

Record outcomes back into this matrix’s **Prototype** cells after the first guild night.
