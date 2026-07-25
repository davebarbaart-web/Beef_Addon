# Evidence panel

**Track:** 69-officer-tab-ia  
**Zone:** B — Evidence  
**Question:** What does the officer see for the *selected* petition so Approve/Reject is informed comedy judgment?

Standing presentation polish for members → track [70](../70-standing-breakdown-ui/). Dispute / reject doctrine → [40](../40-officer-moderation-audit/disputed-scores.md).

---

## Spec contract (§7.3)

Officers see:

1. Player  
2. Current rank  
3. Suggested rank  
4. Point breakdown  
5. Recent contributing events  

Approve → commit. Reject → clear suggestion; **points remain** unless corrected.

---

## Cousin “evidence” analogues

| Cousin | Surface | Beef steal |
|--------|---------|------------|
| [RCLC More Info](https://rclootcouncil.com/wiki/Voting-Frame) | Side window: last awards, totals from Loot History | **Selection → detail**; keep V1 *inline* in B, not a second floating module |
| [Gargul note field](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items) | Short MS/OS / prio note on the decision | One-line officer note *optional later*; standing breakdown is the note |
| Attune “who’s on step” | Progress context for readiness | Breakdown sources = “why this petition exists” |

**Avoid:** RCLC gear icons, ilvl Diff, vote hover lists — wrong evidence for ranks.

---

## V1 panel anatomy

```text
┌─ Evidence ─────────────────────────────────────┐
│  Beefina                          Freshness 2h │
│  Cooked Beef  →  Beef Knight                   │
│  Standing 420 / 400 (threshold)                │
│────────────────────────────────────────────────│
│  Breakdown (short)                             │
│   · Instance co-play …… 280                    │
│   · Gora ………………… 80                             │
│   · Ceremony …………… 60                            │
│────────────────────────────────────────────────│
│  Recent events (last ~5)                       │
│   · RFC with GuildieA · +40 · yesterday        │
│   · …                                          │
│────────────────────────────────────────────────│
│  [ Approve: Beef Knight ]   [ Reject ]         │
│  (Reject helper: points remain — microcopy 41) │
└────────────────────────────────────────────────┘
```

### Field rules

| Block | Rule |
|-------|------|
| Identity | Name always; class color optional, never required for meaning |
| Rank delta | Plain titles; no fake XP bar that fights ElvUI ([02](../02-visual-language/03-steal-adapt-matrix.md)) |
| Breakdown | Source totals only — not every SCORE_EVENT |
| Recent events | Cap ~5 lines; “more on My Standing” if needed later ([70](../70-standing-breakdown-ui/)) |
| Implausible soft badge | Optional strip above breakdown (“Standing climbed unusually fast”) — never auto-reject |
| CTAs | Approve label names the destination rank; Reject is secondary (destructive to petition, not to points) |

---

## Decision CTA placement

**Recommended:** Approve / Reject in the **evidence footer** (master–detail).  
**Acceptable:** Buttons only on the **selected** queue row if the frame is too short for a footer.  
**Banned:** Modal confirm on every Approve ([58](../58-staticpopup-confirms/beef-demote-prophet-confirms.md) §7).

Optional reject reason enum (no blocking modal) lives beside Reject — product depth in [40](../40-officer-moderation-audit/beef-product-patterns.md); IA only reserves a short control slot.

---

## Empty / no-selection states

| Condition | Panel shows |
|-----------|-------------|
| Queue empty | Celebratory-quiet empty ([empty-states-ia.md](empty-states-ia.md)); CTAs hidden/disabled |
| Queue non-empty, nothing selected yet | Should not happen if auto-select works; else “Select a petition” |
| Selection’s data incomplete (sync lag) | Show known fields; chip “breakdown still settling” — do not invent numbers |

---

## What evidence is *not*

- Not the Ladder tab  
- Not a full audit export  
- Not officer free-text notes as the system of record (privacy — [65](../65-debug-dumps-privacy/))  
- Not co-play detection algorithm docs — only human-readable event lines ([59](../59-coplay-guildmate-detection/beef-scoring-map.md) §5)

---

## See also

- [pending-queue-layout.md](pending-queue-layout.md)  
- [confirm-handoffs.md](confirm-handoffs.md) — Approve does not hand off; rites do
