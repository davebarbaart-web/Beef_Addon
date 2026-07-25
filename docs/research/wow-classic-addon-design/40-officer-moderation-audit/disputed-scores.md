# Disputed scores

**Maps to:** Spec §6.3 (advisory standings), §7.2–§7.3 (anti-abuse, approve/reject), §10 My Standing / Officer queue  
**Question:** What happens when a member’s standing testimony and officer judgment disagree?

---

## Spec failure mode (intended)

> Standings are advisory testimony; officer approval is the real anti-cheat.  
> If someone inflates their own numbers, the failure mode is an officer laughing at an implausible suggestion — which is acceptable, and arguably content.

Also locked:

- **Reject** → suggestion clears; **points remain** unless officer corrects.
- Officers see player, current rank, suggested rank, point breakdown, recent events.
- Caps, anti-AFK combat buckets, instance-only co-play reduce (not eliminate) farm.

Disputes are therefore **normal product traffic**, not exceptional support tickets.

---

## Dispute classes

| Class | Symptom | Officer response |
|-------|---------|------------------|
| **Implausible inflate** | Jump to threshold with thin/empty event log | Reject; optional standing wipe/adjust; comedy note |
| **Honest desync** | Member offline missed caps / double-counted locally | Reject or approve with manual adjust; explain |
| **Source disagreement** | “I did ceremony / Gora” vs officer memory | Prefer ceremony closer / Gora recorder as human witness; adjust |
| **Threshold politics** | Eligible but officers want slower pace | Reject with reason; points remain (spec) — member stays eligible to re-suggest |
| **Post-approve regret** | Guild thinks promote was wrong | Compensating demote ([undo note](undo-and-compensating-commits.md)) |

---

## UX that reduces dispute heat

### Officer queue (must-have quality)

Per pending suggestion:

- Standing total vs threshold for suggested rank  
- Breakdown by source (instance / ceremony / Gora)  
- Recent contributing events (short list, not Details!)  
- “Implausible?” soft heuristic later (optional): e.g. standing >> sum of visible events — **advisory badge only**, never auto-reject  

### Reject path

- One-click reject is fine for comedy rejects.  
- **Optional reason** (short enum + free text): `Not earned yet` / `Needs review` / `Standing corrected` / `On-brand no`.  
- Member-facing outcome on My Standing: **Rejected** with reason if provided; else “Officers declined this elevation; standing unchanged.”

### Points-remain semantics (communicate explicitly)

Members will hear “rejected” as “points deleted.” Microcopy should state the spec rule: standing stays; only official rank is gated. If officers wipe standing, that is a **separate, confirmed** action with its own audit event.

### Member appeal (process, light product)

V1 can stay social (Discord / officer whisper). Later: “Request review” re-pokes officers without re-granting points. Avoid automated appeal spam.

---

## Relation to loot-system drama

[Guild Order — loot systems](https://guildorder.com/games/wow/guides/loot-systems-dkp-vs-epgp) notes loot/officer disputes are often the same conflict: trust in named humans. Beef’s hybrid model is closer to **wishlist/eligibility + loot council final call** than pure EPGP:

- Formula-ish eligibility (thresholds)  
- Human approve (council)  

Disputes spike when the **rubric is unpublished** (“why didn’t I get elevated?” → “we discussed it”). Publish standing sources and reject norms in guild docs / in-addon help blurb.

---

## What not to build in V1

- Cryptographic proof of instance time  
- Auto-ban for “cheating” SV edits  
- Public shaming toasts for rejected cheaters (keep comedy opt-in, officer-triggered)  
- Full adversarial meter wars over every drip point  

---

## Insight

The product win is **legible rejection**: officers have evidence; members get a clear non-destructive outcome; standing wipes stay rare, confirmed, and logged.
