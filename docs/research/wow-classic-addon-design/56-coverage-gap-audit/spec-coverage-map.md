# Spec coverage map

**Audit date:** 2026-07-25 (post–Wave E refresh — **70–72** filled)  
**Spec:** [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Parent:** [56-coverage-gap-audit](README.md)  
**Note:** Tracks **57–67**, thin repairs on **01 / 10**, and Wave E **70–72** are filled; grades below reflect that. Remaining Partials are live playtest / ops, not empty shells.

Coverage grades:

| Grade | Meaning |
|-------|---------|
| **Well-covered** | Multiple solid tracks; enough to implement without new library waves |
| **Partial** | Solid docs exist, but a named gap, prototype, or empty shell remains |
| **Under-researched** | Spec requirement lacks a filled track or only has scattered mentions |

---

## §1 Purpose

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Social guild / streamer-event tool (not raid DPS) | Well-covered | 00, 08, 09, 12, 52 |
| Ceremonies, theatrical PvP, persistent ranks | Well-covered | 07, 09, 13, 26, 53 |
| V1 centerpiece = rank ladder + titles | Well-covered | 00, 26, 53 |

---

## §2 Hard technical restrictions

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| TBC Classic Anniversary V1; no Retail-only APIs | Well-covered | 04, 12, 30 |
| Lua/XML only; fully in-game | Well-covered | 24, 34, 35 |
| No bots / protected-action circumvention | Well-covered | 08, 24, 29 |
| May announce / track / sync / ceremony | Well-covered | 09, 14, 24 |

---

## §3 V1 product scope

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Seven display titles + standing sources | Well-covered | 26, 53 |
| Beef Gora thin challenge + outcome | Partial | 09, 13, 26 + **71** thin (finish mechanics; V3 theater still deferred) |
| Ceremony start/close + attendance | Partial | 09, 39, 51 — officer-run flow covered; in-game ceremony chrome intentionally thin |
| Shared instance presence with guildmates | Well-covered | 15 (instance signals) + **59** (`HasConnectedGuildmateInActiveGroup`) |
| Promotion suggestions + Officer+ approve | Well-covered | 09, 13, 16, 40, 49 |
| `/beef` + minimap ladder UI | Well-covered | 11, 22, 28, 35 |
| Per-character `ChurchOfBeefDB` | Well-covered | 04, 21, 25 |
| BeefNet sync of official ranks | Well-covered | 14, 27, 47 |
| Deferred V2+ spectacle / Classic+ | Well-covered (as deferral) | 00, 12, 17, 48 |

---

## §4 Rank ladder (canon)

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Hybrid suggest → Officer+ approve | Well-covered | 00, 09, 26, 40 |
| Ranks 1–5 point-driven; Council seats; unique Prophet | Well-covered | 26, 40, 53 |
| Draft thresholds + Fresh→Cooked pacing rule | Partial | 26, 39, 51 — numbers are playtest ops, not missing research |
| No auto-decay; manual demotion first-class | Well-covered | 26, 40, 32 |
| Confirm friction for demote / Prophet / wipe | Well-covered | **58** StaticPopup recipes + 40 audit doctrine |

---

## §5 Repository structure

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Machine canon inside addon (`Data/Ranks.lua`) | Well-covered | 00, 05, 33, 34 |
| Independent ladders per guild/realm (Dreamscythe / Doomhowl) | Well-covered | 25, 30, 46, **60** (HC port deltas; V1 = Anniversary) |
| Filename / packaging discipline | Well-covered | 05, 33, 45 |

---

## §6 Runtime architecture & authority

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Score → suggestion → officer → RANK_COMMIT → sync → UI | Well-covered | 00, 14, 27, 34 |
| Officer+ via roster rank-index (not rank names) | Well-covered | 16, 40 |
| Queue/drop if roster not loaded | Well-covered | 16, 41, 55 |
| Standings advisory; officer is anti-cheat | Well-covered | 00, 24, 26, 40 |
| Name/realm normalization for sender match | Well-covered | 16, 25 |

---

## §7 Scoring rules

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Instance drip + completion + ceremony + Gora weights | Partial | 15, 26, 50 — weights tunable; completion optional |
| Anti-AFK combat gate; daily caps; instance-types only | Well-covered | 15, 26, 54 |
| Gora losses pay (participation) | Well-covered | 26 |
| Reliable “dungeon complete” on Anniversary | Partial | **15** documents no first-class clear event; **prototype gate** open (§16.4) |
| Detect ≥1 guildmate in party/raid/BG | Well-covered | **59** predicate + false-positive matrix |
| Avoid CLEU as scoring engine | Well-covered | **63** explicit avoid + strong-justification bar; 15 matrix |
| Fresh/low-level fairness while leveling | Well-covered | **64** doctrine (no Min-EP; lowbies count); thresholds remain ops (**51**) |

---

## §8 BeefNet

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Prefix `COB`, channel `GUILD`, small payloads | Well-covered | 14 |
| Message types HELLO / SCORE_EVENT / SUGGESTION / RANK_COMMIT / SYNC_* | Well-covered | 14, 27 |
| Officer-only RANK_COMMIT validation | Well-covered | 14, 16, 27 |
| Revisioned merge; login sync; reply-storm suppression | Well-covered | 14, 27, 47 |
| CTL-style throttling; avoid SCORE_EVENT spam | Well-covered | 14, 47, 54 |
| Measured live payload / chunk budget under guild load | Partial | 14/47 reasoned budgets; no live guild-night measurement yet (use 51) |
| Suggestion queue sync for offline officers (§16.5) | Well-covered (research) | **67** V1 = local-persist + live fanout; pull sync = V1.1 flag — promote into spec decisions log |

---

## §9 Persistence

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Per-character SV; cache of officer commits | Well-covered | 21, 25, 27 |
| Alts start Fresh Beef | Well-covered | 21, 25 |
| Schema versioning / corruption recovery | Well-covered | 21 |
| Guild-scoped cache keys on gquit/join | Partial | 25 flags contamination risk — implementers must follow; no separate track needed |

---

## §10 V1 UI

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| `/beef` movable frame; minimap toggle | Well-covered | 11, 22, 28, 37 |
| Tabs: Ladder / My Standing / Officer | Well-covered | 09, 13, 26, 35, 41 |
| Thin Gora / ceremony stubs | Well-covered | 09, 35, 36 + **71** (state machines, officer close, cousins) |
| My Standing breakdown rows | Well-covered | **70** (composition, chips, progress, density anti-patterns; text thresholds for Task 8) |
| Toasts + guild-chat promote announce | Well-covered | 17, 20, 32, 49 + **72** (single-announcer `/g` pipeline) |
| Media fallback; frame always created | Well-covered | 10, 41, 44, 55 |
| Scrollable ladder / suggestion lists | Well-covered | **57** fixed pools / Faux; Hybrid deferred pending in-client verify |
| Context menus / tooltips for officer actions | Well-covered | 36 |
| Plain Classic frames; theatrical chrome later | Well-covered | 02, 10, 12, 23 |
| Edit Mode / modernized Anniversary UI coexistence | Well-covered | **66** + 02/12/37 — own movers; no EM registration in V1 |

---

## §11 Error and edge handling

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Not in guild / not Officer+ / version mismatch | Well-covered | 41, 48, 55 |
| Replay-safe commits; roster-not-ready | Well-covered | 16, 27 |
| Disconnect mid-ceremony | Well-covered | 41, 55 + **71** (no credit until clean close / manual credit) |
| Player leaves guild (retain/hide) | Well-covered | 25, 41 |
| Graceful degradation / partial sync | Well-covered | 55 |

---

## §12 Portability (Classic+)

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Isolate TOC / instance / messaging seams | Well-covered | 04, 14, 15, 30, 34 |
| Multi-flavor packaging patterns | Well-covered | 30, 33 |

---

## §13 Success criteria & verification

| Requirement | Grade | Primary tracks |
|-------------|:-----:|----------------|
| Load, `/beef` frame, seven ranks visible | Well-covered | 19, 22, 35 |
| Co-play / Gora / ceremony grant standing | Partial | **59** + **71** researched; still needs **15** Anniversary prototype + build |
| Suggestion → officer approve → BeefNet peer update | Well-covered (design) | 14, 16, 19, 27 |
| Offline member reconciles via login sync | Well-covered (design) | 14, 27, 47 |
| Non-officer forge rejected | Well-covered | 16, 24, 27 |
| Social check: guild-chat reaction on promote | Well-covered | 17, 32, 51, **72** |
| Guild-night instrumentation sheet | Well-covered | 39, 51 |

---

## §14 Phase map

| Phase | Grade | Tracks |
|-------|:-----:|--------|
| V1 ladder / thin stubs / BeefNet | Well-covered | Most of 00–55 |
| V2 ceremonial dashboard / scripture | Partial (intentionally light) | 07, 17, 20, 44, 53 |
| V3 Gora theater | Under-researched (OK — deferred) | — |
| V4 Classic+ | Partial | 12, 30 |

---

## §15 Decisions log

All locked decisions in §15 are reflected across 00 + domain tracks. No research contradiction found that would force a silent fork. When research changes a decision, update the spec log (library README rule).

---

## §16 Open questions

| Open question | Research status | Tracks |
|---------------|-----------------|--------|
| 1 Alt policy | Well-covered as V1 per-char doctrine; future merge undecided | 21, 25 |
| 2 Council seat count | Product/leadership — not a research gap | 26, 40 |
| 3 Standing decay / Lent | Well-covered options; off in V1 | 26, 46, 50 |
| 4 Instance completion detection | **Partial** — matrix done; Anniversary playtest still open | 15 |
| 5 Suggestion queue sharing | **Closed in §15** — local-persist + live fanout; V1.1 pull flag (**67**) | 14, 27, 49, **67** |
| 6 Threshold tuning | Ops — playbook ready | 51, 64 |

---

## Coverage heat map (V1 must-work)

| Must-work item (spec §3.1 / §13) | Grade |
|---------------------------------|:-----:|
| Rank ladder display | Well-covered |
| Standing from Gora / ceremony / co-play | Partial → **gap: 15 Anniversary playtest** (59 + 71 filled) |
| Promotion suggestions | Well-covered |
| Officer+ approve/reject | Well-covered |
| `/beef` + minimap | Well-covered |
| Per-char SV | Well-covered |
| BeefNet official sync | Well-covered |
| Login reconciliation | Well-covered |
| Guild-chat spectacle announce | Well-covered |
| Scrollable dense lists | Well-covered (**57**) |
| High-drama confirms | Well-covered (**58**) |
