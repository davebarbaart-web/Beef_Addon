# Beef V1 recommendation — My Standing tab

**Track:** 70  
**Maps to:** Spec §7, §10 · Plan Task 8 (`UI/StandingTab.lua`) · Scoring history ring (`GetHistory`, max 20)  
**Status:** Design recommendation for implementers — no code in this folder.

---

## One-line verdict

Ship My Standing as **title · standing · next · three source badges · ~10 story lines**. Reuse that attribution model on Officer suggestion rows. Do not ship a DKP grid.

---

## Layout (top → bottom)

```text
┌─────────────────────────────────────────────┐
│  Cooked Beef                                │  ← current official title (hero)
│  38 standing                                │  ← advisory standing total
│  12 to Beef Knight                          │  ← or “Appointed ranks only”
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒  │  ← optional thin StatusBar
│  [Petition pending]                         │  ← only if suggestion open
├─────────────────────────────────────────────┤
│  Instance +12/40   Ceremony +0   Gora +5    │  ← source chips (today/cap if known)
├─────────────────────────────────────────────┤
│  Recent rites                               │
│  [Instance] +3 · Shadow Labyrinth           │
│  [Gora]     +2 · vs Name — loss             │
│  [Ceremony] +10 · Sunday Rite               │
│  … up to ~10 lines                          │
├─────────────────────────────────────────────┤
│  Last bless: OfficerX · date   Synced/cache │  ← optional footer (actor / sync)
└─────────────────────────────────────────────┘
```

Visual language: plain Classic chrome first ([02](../02-visual-language/05-implications-for-church-of-beef.md)); parchment/heraldry later.

---

## Data bindings (conceptual)

| UI slot | Reads from |
|---------|------------|
| Title | Official ladder record for local player (`rankId` → canon title) |
| Standing | Local / advisory standing used for suggestions |
| Next line | Next point-driven threshold from canon, else appointed copy |
| Bar | Optional; same numbers as next line |
| Petition badge | Pending suggestion for local player |
| Source chips | Today granted + caps from scoring day bucket |
| History | `COB.Scoring:GetHistory(player)` newest first, show ~10 |
| Footer actor | Last `RANK_COMMIT` `updatedBy` if present ([40](../40-officer-moderation-audit/)) |

List widget: FontString-heavy history may use true ScrollFrame if needed; prefer capped list so scroll is rare ([57](../57-scrollframe-list-rows/)).

---

## History line format (V1)

Minimum fields per grant:

1. Source badge (`Instance` / `Ceremony` / `Gora` / `Officer`)  
2. Signed amount (`+N` / rare negative adjust)  
3. Short plain clause (instance name, ceremony name, Gora opponent + outcome)

Omit: EP/GP, ratios, DPS, combat log spam, full party roster.

---

## States checklist

| State | Standing tab behavior |
|-------|------------------------|
| Fresh install, 0 standing | Title Fresh Beef; “N to Cooked Beef”; empty events copy from [41](../41-empty-states-degraded-ux/) |
| After first dungeon night | Visible movement on standing + instance lines |
| At/over threshold | Remaining 0 / Eligible + petition badge |
| Rejected petition | Points remain; optional reject reason line |
| Butcher+ | “Appointed ranks only”; hide grind bar |
| Unguilded | Scoring paused empty-state; no fake progress |
| Caps exhausted | Chip shows capped; history may note cap |

---

## Shared with Officer tab (DRY product rule)

Officer pending row summary should use the **same source vocabulary and last-N events**, not a parallel “EP breakdown.” Approve/Reject buttons stay Officer-only ([40](../40-officer-moderation-audit/)).

---

## Explicit V1 non-goals

| Non-goal | Parked in |
|----------|-----------|
| Guild-wide standing sort / neighbors rail | [26](../26-ladders-points-gamification/) (optional later) |
| Filterable chip toggles | This track — V1.1 optional |
| Lifetime source pie / export CSV | Post-V1 |
| Per-drip guild chat | Spec §10 — toasts only for credit events |
| Masque/LSM dependency for bars | [10](../10-skinning-masque-sharedmedia/) |

---

## Acceptance criteria (research → UI)

Implementers can treat My Standing as done for V1 research when:

1. A member can answer **“what’s my title, standing, and what’s next?”** in one glance.  
2. A member can answer **“why did standing move?”** from the last ~10 lines.  
3. A member can see **which source is capped today** without opening settings.  
4. No screen in the tab requires horizontal scrolling or column-sort headers.  
5. Council/Prophet paths never show a fake point threshold.
