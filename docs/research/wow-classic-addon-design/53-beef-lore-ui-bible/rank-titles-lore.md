# Rank titles — lore for UI

**Purpose:** Gloss each canon title so ladder rows, toasts, tooltips, and officer copy stay theologically consistent.  
**Numbers:** Thresholds and seat counts live only in `addon/ChurchOfBeef/Data/Ranks.lua` (and prose notes in `docs/canon/` when authored). This file must not invent alternate thresholds.

Canonical order (spec §4), lowest → highest:

| Order | Title | Tier |
|------:|-------|------|
| 1 | Fresh Beef | Point-driven flock |
| 2 | Cooked Beef | Point-driven flock |
| 3 | Beef Knight | Point-driven flock |
| 4 | Beef Lord | Point-driven flock |
| 5 | Beef Butcher | Point-driven flock |
| 6 | Beef Council | Appointed, seat-limited |
| 7 | Beef Prophet | Bestowed, unique (default) |

---

## Doctrine shared by all titles

1. **Exact string, exact casing.** UI and guild chat always use the table’s Title cell.  
2. **Hybrid salvation.** Crossing a threshold makes you *suggestion-eligible*; Officer+ approval makes the title real.  
3. **Flesh proves itself anew.** V1 alts start Fresh Beef with zero standing (spec §9, §16.1). Flavor: the meat is per-character.  
4. **Scarcity at the top.** Council and Prophet are clergy fantasy, not grind completionism.  
5. **Independent churches.** Dreamscythe Alliance and Doomhowl Horde each run their own ladder — never “server-wide Prophet.”

---

## Title cards

### 1 — Fresh Beef

| Field | Canon gloss |
|-------|-------------|
| **Fantasy** | Raw initiate; newly joined meat of the flock |
| **How earned** | Default starting title |
| **UI gloss (short)** | New to the Church |
| **Officer note** | Not a demotion insult by default — it is the door |
| **Announce** | Usually silent on *join*; first spectacle is elevation to Cooked Beef |

### 2 — Cooked Beef

| Field | Canon gloss |
|-------|-------------|
| **Fantasy** | Proven over flame; first real belonging |
| **How earned** | Point-driven suggestion → approve (pacing: first full guild dungeon night should aim here — spec §4.2) |
| **UI gloss** | First rites complete |
| **Do not** | Call this “veteran” — that belongs higher |

### 3 — Beef Knight

| Field | Canon gloss |
|-------|-------------|
| **Fantasy** | Armed devotee; pageantry of the Scarlet-holy absurd |
| **How earned** | Point-driven |
| **UI gloss** | Sworn blade of the Church |
| **Spectacle** | Spec exemplar announce uses this title — treat as the “readable middle” of the ladder |

### 4 — Beef Lord

| Field | Canon gloss |
|-------|-------------|
| **Fantasy** | Temporal authority in the flock; landed swagger without Council keys |
| **How earned** | Point-driven |
| **UI gloss** | High flock nobility |
| **Do not** | Imply guild-bank / invite powers — those are WoW ranks |

### 5 — Beef Butcher

| Field | Canon gloss |
|-------|-------------|
| **Fantasy** | Master of the craft; apex of *earned* meat before clergy |
| **How earned** | Point-driven — last threshold rank |
| **UI gloss** | Apex of earned standing |
| **UI warning** | Ladder must not imply “next: grind to Council” |

### 6 — Beef Council

| Field | Canon gloss |
|-------|-------------|
| **Fantasy** | Governance body; seats, not a scoreboard rung |
| **How earned** | **Appointed** by officers; default seat cap (configurable in machine canon) |
| **UI gloss** | Seated clergy — appointment only |
| **Liturgy verb** | *seat* / *appoint* — never “elevated to Beef Council” after points |
| **Empty seats** | Show vacant seats as doctrine of scarcity, not failure |

### 7 — Beef Prophet

| Field | Canon gloss |
|-------|-------------|
| **Fantasy** | Living voice of the Beef God; unique mantle |
| **How earned** | **Bestowed** by officer decree only; default one living Prophet |
| **UI gloss** | Anointed — not grindable |
| **Liturgy verb** | *anoint* / *bestow* |
| **Spectacle** | Treat as an event night, not a quiet SV write |

---

## Demotion & excommunication (title-facing)

| Action | Lore stance | Title handling |
|--------|-------------|----------------|
| Step demote | Rivalry / comedy / correction | Announce *returned to {lower title}* |
| Excommunicate (opt-in wording) | Nuclear public drama | Same rank change; sacred verb reserved for Council/Prophet falls or explicit officer choice |
| Left guild | Record retained but hidden (spec §11) | No “heretic forever” UI in V1 — hide, restore on return |

There is **no automatic decay** in V1. Seasonal “Lent” reset is an open on-brand option later (spec §16.3) — do not imply decay in current strings.

---

## Ladder UI labeling rules

| Surface | Rule |
|---------|------|
| Rank column | Exact title only |
| Tier subtitle | “Earned” (1–5) / “Appointed” (6) / “Bestowed” (7) — plain words OK |
| Progress to next | Show standing → next threshold **only** for 1–5; hide fake bars for Council/Prophet |
| Local highlight | “You: {Title}” — sacred title, procedural pronoun |
| Tooltip lore | One short gloss from the cards above; no multi-paragraph scripture in V1 |

---

## Open lore questions (do not invent UI answers yet)

From spec §16 — leave undecided in strings:

1. Alt linking vs permanent “flesh anew”  
2. Exact Council seat count (default 4 until leadership locks)  
3. Whether Lent/decay seasons exist  

UI may say “appointed” / “bestowed” without promising future seasons.
