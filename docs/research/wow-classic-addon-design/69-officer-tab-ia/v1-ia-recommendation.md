# V1 recommendation — Officer tab IA

**Track:** 69-officer-tab-ia  
**Status:** Research recommendation for implementers of `UI/OfficerTab.lua` (plan Task 9). Not a spec fork — if product locks change, update the design-spec decisions log.

---

## Locked composition

**Master–detail Officer tab with four zones:**

1. **A Pending queue** — short FIFO list; name + rank delta; one selection.  
2. **B Evidence** — §7.3 breakdown + recent events; Approve / Reject in footer (no modal).  
3. **C Rites** — static standing adjust / demote / Council / Prophet (outside scroll pool).  
4. **D Recent Actions** — last N actor/verb/subject/before→after rows.

Authority shape: **Gargul ML** (single Officer+ actor). Detail IA: **RCLC selection → evidence**. Density: neither loot table.

ASCII map: [tab-zones.md](tab-zones.md).

---

## Steal / avoid (IA)

| Steal | From | Avoid |
|-------|------|-------|
| Select row → decide | [Gargul RollOff](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items) | Start/Stop/Timer roll theater |
| Confirm before award-like nuclear commits | [Gargul Awarding](https://github.com/papa-smurf/Gargul/wiki/Awarding-Items) | Confirm on every Approve |
| Selected subject → side detail | [RCLC Voting Frame](https://rclootcouncil.com/wiki/Voting-Frame) | Votes, gear, ilvl Diff, session rail |
| One history row per decision | [RCL Loot History](https://rclootcouncil.com/wiki/Loot-History) | Export / mass-delete / filter UI in V1 |
| Empty queue teaches quietly | [13 / Gargul start](../13-cousin-addon-teardowns/gargul.md), [41](../41-empty-states-degraded-ux/) | Blank tab / “no data” / grey disabled Officer tab |

---

## Decision defaults

| Topic | V1 default |
|-------|------------|
| A‖B layout | Side-by-side when width allows; stacked otherwise — never a second tab for evidence |
| Auto-select | Oldest pending on show; advance after decide |
| Approve/Reject confirm | None |
| Nuclear confirms | Demote / Council / Prophet / wipe — handoff per [confirm-handoffs.md](confirm-handoffs.md) |
| Empty queue | Keep C+D; quiet empty in A/B |
| Recent Actions depth | ~3–5 visible; derive from commits + local rejects ([40](../40-officer-moderation-audit/beef-product-patterns.md)) |
| Offline missing petitions | Honesty via status/chip + [67](../67-offline-officer-suggestion-sync/) — not fake inbox chrome |

---

## Implementer checklist (IA only)

- [ ] Officer+ gate hides the whole tab ([48](../48-feature-flags-rollout/officer-role-gates.md), spec §11)  
- [ ] Zones A–D present per [tab-zones.md](tab-zones.md)  
- [ ] Queue columns stay thin ([pending-queue-layout.md](pending-queue-layout.md))  
- [ ] Evidence shows all five §7.3 fields ([evidence-panel.md](evidence-panel.md))  
- [ ] Rites not inside the suggestion scroll pool ([57](../57-scrollframe-list-rows/beef-ladder-officer-lists.md))  
- [ ] Confirm handoffs only for nuclear actions ([confirm-handoffs.md](confirm-handoffs.md) → [58](../58-staticpopup-confirms/))  
- [ ] Empty slots follow [empty-states-ia.md](empty-states-ia.md); strings from [41](../41-empty-states-degraded-ux/)  
- [ ] No vote UI, no SoftRes matrices, no Award Later bag chrome  

---

## Explicitly later (not this track)

| Later | Owner |
|-------|-------|
| Shared suggestion catch-up inbox | [67](../67-offline-officer-suggestion-sync/) V1.1 |
| Full history browser / export | [40](../40-officer-moderation-audit/) |
| Dual-officer ack | [40](../40-officer-moderation-audit/) |
| Floating “More Info” module | Optional if B overflows — still IA’d here as non-goal for V1 |
| Standing breakdown art pass | [70](../70-standing-breakdown-ui/), [02](../02-visual-language/) |

---

## One-line doctrine

**Queue for attention, evidence for judgment, rites for power, history for the alibi — and only the last three kinds of power earn a modal.**
