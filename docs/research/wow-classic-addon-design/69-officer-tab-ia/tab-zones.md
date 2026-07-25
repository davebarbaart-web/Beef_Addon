# Officer tab — zone map

**Track:** 69-officer-tab-ia  
**Question:** What regions exist on the Officer tab, and in what order should an Approving Officer’s eye move?

---

## Spec surfaces that must land somewhere

From §10 + §7.3 + [40 V1 patterns](../40-officer-moderation-audit/beef-product-patterns.md):

| Product surface | Zone |
|-----------------|------|
| Pending suggestions list | **A — Queue** |
| Player / ranks / standing breakdown / recent events | **B — Evidence** |
| Approve / Reject | **B footer** (or selected row in A — pick one; see below) |
| Manual standing correction | **C — Rites** |
| Demote / Council appoint / Prophet bestow | **C — Rites** |
| Recent Actions (last N) | **D — History** |
| Thin Gora / Ceremony stubs | **C** or chrome footer — not inside A |

---

## Recommended V1 layout (desktop Classic frame)

```text
┌─ Officer tab ─────────────────────────────────────────────┐
│  [status chip: sync / no peers — owned by 41, not IA art] │
├──────────────────────────┬────────────────────────────────┤
│ A  PENDING QUEUE         │ B  EVIDENCE                    │
│    (select one row)      │    name · from→to · standing    │
│                          │    breakdown · recent events   │
│                          │    [ Approve ]  [ Reject ]     │
├──────────────────────────┴────────────────────────────────┤
│ C  RITES (static)                                         │
│    Standing adjust · Demote · Council · Prophet           │
│    (+ thin Gora/Ceremony stubs if space)                  │
├───────────────────────────────────────────────────────────┤
│ D  RECENT ACTIONS (last N, compact)                       │
└───────────────────────────────────────────────────────────┘
```

**Reading order:** A → B → decide → (optional) C for nuclear / correction → D only when checking the alibi.

This mirrors:

| Cousin | Steal | Avoid |
|--------|-------|-------|
| [Gargul RollOff](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items) | List of candidates + Award on selection; note/evidence beside | Timer / Start-Stop roll theater; raid-warning density |
| [RCLC Voting Frame](https://rclootcouncil.com/wiki/Voting-Frame) | Selected session → detail + “More Info” side panel | Vote buttons, session icon rail, gear/ilvl/diff columns, Disenchant |

---

## Zone contracts

### A — Pending queue

- **Job:** Scan who needs a blessing; select one.  
- **Density:** Name + from→to rank (+ optional freshness age). No multi-column loot spreadsheet.  
- **Scroll:** Pool/Faux owned by [57](../57-scrollframe-list-rows/) — IA only requires “short list, one selection.”  
- **Not here:** Demote / Prophet / wipe buttons (fat-finger risk).

### B — Evidence

- **Job:** Make junk suggestions funny and obvious (spec §6.3).  
- **Content:** Spec §7.3 fields only for V1.  
- **Primary CTAs:** Approve / Reject live here (or on the selected A-row — see [pending-queue-layout.md](pending-queue-layout.md)).  
- **Not here:** Full guild ladder; CEPGP traffic; vote tallies.

### C — Rites

- **Job:** Officer-initiated power *outside* the petition queue.  
- **Always visible** even when A is empty (officers still need demote/appoint).  
- **Handoff:** High-risk controls open confirms ([confirm-handoffs.md](confirm-handoffs.md)); never commit on first click.

### D — Recent Actions

- **Job:** “Who did what” glance after raid night ([40](../40-officer-moderation-audit/transparency-norms.md)).  
- **Compact:** Last N rows; no export UI in V1.  
- **Data:** Derived from commits + local reject log ([40](../40-officer-moderation-audit/beef-product-patterns.md)) — this track does not invent a new protocol type.

---

## Alternate compact layout (narrow frame)

If the main `/beef` frame is too narrow for A‖B side-by-side:

1. **A full-width** (queue).  
2. **B full-width below A** (evidence expands on selection).  
3. **C** then **D** stacked.

Do **not** put B in a second tab — that breaks “select → see → decide” in one glance (RCLC keeps detail on the same Voting Frame).

---

## Explicit non-zones (V1)

| Tempting region | Why not |
|-----------------|---------|
| Session / item icon rail (RCLC left column) | Beef has no multi-item loot session |
| Vote status / council tally | Hybrid ladder ≠ voting council |
| Award Later bag | Offline petition policy is [67](../67-offline-officer-suggestion-sync/), not a ML bag UI |
| Version checker table | Chip/footer only ([41](../41-empty-states-degraded-ux/)); full peer list later |
| Minimap badge chrome | [49](../49-officer-notifications/) |

---

## See also

- [pending-queue-layout.md](pending-queue-layout.md)  
- [evidence-panel.md](evidence-panel.md)  
- [v1-ia-recommendation.md](v1-ia-recommendation.md)
