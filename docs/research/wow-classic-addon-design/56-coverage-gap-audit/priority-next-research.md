# Priority next research (ranked gaps)

**Audit date:** 2026-07-25 (post–Wave E refresh — **70–72** filled)  
**Parent:** [56-coverage-gap-audit](README.md)  
**Companion:** [track-status-matrix.md](track-status-matrix.md) · [spec-coverage-map.md](spec-coverage-map.md)  
**Live ops checklist:** [`docs/phases/guild-night-playtest.md`](../../../phases/guild-night-playtest.md)

Desk-research shells through track **74** are **filled**. Rank what remains by **V1 blocker risk** — in-client prototypes and ops measurement only. Prefer playtest notes over opening brand-new track numbers.

---

## Closed by prior waves (do not re-queue as empties)

| Prior gap | Resolution |
|-----------|------------|
| **59** co-play detection | Solid — `HasConnectedGuildmateInActiveGroup` recipe |
| **57** scroll / list rows | Solid — fixed Lua pools; Faux if overflow; no Hybrid in V1 |
| **58** StaticPopup confirms | Solid — risk ladder + demote/Prophet/wipe recipes |
| **10** adopt-vs-invent + URLs | Solid — no Masque/LSM hard dep; plain frames |
| **01** UX Beef synthesis | Solid — edge-social mapping |
| **60–66** HC / streamer / patch / CLEU / fairness / dumps / Edit Mode | Solid |
| **§16.5** offline suggestion sync | Solid **67** — local-persist + live fanout; sync = V1.1 flag; in spec §15 |
| **68 / 69 / 73 / 74** | Solid follow-ons (message catalog, officer IA, desktop tests, decision glossary) |
| **70** My Standing breakdown UI | Solid — Wave E (patterns, source chips, progress, density anti-patterns, V1 recommendation) |
| **71** Ceremony & Gora mechanics | Solid — Wave E (stubs, challenge flows, officer close, cousins, URLs) |
| **72** Guild-chat announce API | Solid — Wave E (constraints, CTL, single-announcer, V1 pipeline) |

---

## P0 — In-client / ops (no empty library shells)

### 1. Anniversary in-game prototype for encounter/completion signals (extends **15**)

**Why:** Track 15 still marks `ENCOUNTER_END` / `BOSS_KILL` as **Prototype** on `20506`. Docs + 59/63 cannot close §16.4 alone.

**Deliver:** Short playtest note for TBC 5-mans / raids / BGs; keep completion bonus optional if flaky.

**Unblocks:** Completion bonus ship-or-bucket-only decision.

---

## P1 — Verify in-client; measure under real load

### 2. Live CTL / login-storm budget under real guild load (extends **14 / 47 / 68**, run via **51**)

**Why:** Message catalog (**68**) and sync design are settled; budgets are reasoned, not measured on a live Anniversary guild night.

**Deliver:** One night’s AddonUsage / timing notes; adjust if silent drops appear.

---

### 3. Fresh → Cooked threshold instrumentation night (extends **51 / 64**)

**Why:** Fairness doctrine locked; Cooked@50 is still an ops number.

**Deliver:** Guild-night clipboard results before inventing level-band multipliers.

---

### 4. Brand hex / chrome screenshot lock (extends **23** / glossary rows 78, 81)

**Why:** Spec ships template-native V1; provisional research hex is not law until Anniversary screenshot pass.

**Deliver:** Locked accent constants (or explicit “stay Blizzard-default”) after filter/stream contrast check.

---

### 5. HybridScroll FrameXML checklist on Anniversary (extends **57**)

**Why:** V1 ships fixed pools / Faux; Hybrid only after in-client template verify.

**Deliver:** Checked list on shipping `20506`.

---

## P2 — Optional hardenings & hygiene

### 6. Optional same-instance-ID guildmate harden (extends **59**)

**Deliver:** Playtest whether HOME/INSTANCE + combat gate is enough.

---

### 7. Refresh master URL list (**06**) with 57–74 primaries

**Deliver:** Incremental curation into the single URL list.

---

### 8. Spot-check **74** glossary vs latest §15 (maintenance)

**Why:** Glossary indexes ~81 locks; §15 already has suggestion inbox + CLEU. Keep in sync when playtests change product decisions — not a scrape wave.

**Deliver:** Diff pass only when a decision changes.

---

## P3 — Explicit non-goals / deferred

| Gap | Action |
|-----|--------|
| V1.1 suggestion pull-sync (**67** flag) | Evidence-gated when officers miss petitions |
| Toast anchor presets (**66 / 37**) | V2+ |
| Deep Gora match theater | V3 — do not expand **71** into spectacle chrome |
| Full HC scoring module (**60**) | Future Classic HC port only |
| CLEU behind a feature flag (**63**) | Rejected |
| New tracks **75+** | Only if playtest contradicts a locked decision |

---

## Suggested work packing (post Wave E)

| Wave | Work | Goal | Status |
|------|------|------|:------:|
| **E** | **70** + finish **71** + finish **72** | Close remaining UI/spectacle shells | **Done** |
| **F** | 15 Anniversary playtest (+ brand screenshot if convenient) | Close §16.4 confidence | Open — live |
| **G** | Live CTL measure + 51 threshold night + optional 57/59 verify | Ops confidence | Open — live |
| **H** | 06 URL refresh + V1.1 sync / toast presets | Hygiene + deferred flags | Open — optional |

After each wave: update this file and append to [00-church-of-beef-implications.md](../00-church-of-beef-implications.md) only if product decisions change.

---

## Top remaining gaps (executive)

1. **15** Anniversary in-game verification of encounter/completion events  
2. **14 / 47 / 68 / 51** Live CTL budget under real guild login storm  
3. **51 / 64** Fresh→Cooked threshold instrumentation night  
4. **23** Brand hex / chrome lock after Anniversary screenshot  
5. **57** HybridScroll in-client template checklist (if Hybrid ever considered)  
6. **59** Optional same-instance-ID guildmate harden (playtest)  
7. **06** Master URL list refresh with 57–74 primaries  
8. **74 / §15** Maintenance sync when playtests change decisions
