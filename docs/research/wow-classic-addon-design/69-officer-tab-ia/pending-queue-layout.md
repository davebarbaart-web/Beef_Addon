# Pending queue layout

**Track:** 69-officer-tab-ia  
**Zone:** A — Pending queue  
**Question:** What does each petition row show, how does selection work, and what density is banned?

Widget pooling / scroll → [57](../57-scrollframe-list-rows/beef-ladder-officer-lists.md). Offline who sees which rows → [67](../67-offline-officer-suggestion-sync/).

---

## Cousin patterns (IA only)

### Gargul RollOff list

[Rolling Items](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items): rolls accumulate in a list; ML **selects a row** then **Award**. Duplicate nonsense is marked (`[2]`, `[3]`).

**Steal:** Selection before commit; visible “this row is active”; soft flag for implausible / duplicate petitions.  
**Avoid:** Start/Stop/Timer/Clear theater for comedy ranks.

### RCLC candidate table

[Voting Frame](https://rclootcouncil.com/wiki/Voting-Frame): sortable multi-column table (name, guild rank, role, response, ilvl, diff, gear, votes, notes, roll); yellow selection; ML right-click Award.

**Steal:** Clear selection highlight; one active subject for detail.  
**Avoid:** Vote / gear / ilvl / Diff / Role columns; right-click Award as the only path (Beef Approve should be a labeled button).

---

## V1 row content (queue)

Keep the queue **scannable in one column cluster**. Put depth in zone B.

| Field | In queue row? | Notes |
|-------|---------------|-------|
| Character name | **Required** | WoW name (TRP3 RP name later — [13](../13-cousin-addon-teardowns/steal-avoid-for-beef.md)) |
| Current → suggested rank | **Required** | Short titles (“Cooked → Knight”) |
| Standing total (or vs threshold) | Optional one number | Full breakdown → B |
| Freshness (“2h ago”) | Optional | `GetServerTime` age — [50](../50-time-timezones-resets/) |
| Soft “implausible” badge | Nice if cheap | Advisory only ([40](../40-officer-moderation-audit/beef-product-patterns.md)) |
| Point breakdown lines | **No** | Evidence panel |
| Event log | **No** | Evidence panel |
| Approve / Reject | Prefer **B footer**; OK on selected row only | Never on every unselected row if it causes misclicks |
| Demote / Prophet | **Never** | Zone C |

Recommended visible pool size remains 8–12 ([57](../57-scrollframe-list-rows/beef-ladder-officer-lists.md)) — IA assumption: guild nights rarely need a spreadsheet.

---

## Selection model

1. Opening the Officer tab with a non-empty queue **auto-selects the oldest pending** (FIFO comedy mercy) or the row that triggered the last toast ([49](../49-officer-notifications/)) — pick one rule and stick to it.  
2. Clicking a row rebinds zone B.  
3. After Approve/Reject clears the row, **advance selection** to the next oldest (Gargul “keep awarding” flow) rather than blanking B until a click.  
4. Empty queue → B shows empty-evidence state ([empty-states-ia.md](empty-states-ia.md)).

---

## Sort / filter (V1 stance)

| Behavior | V1 |
|----------|-----|
| Default order | Oldest first (queue fairness) |
| Click-to-sort columns | **No** — RCLC energy; officers have few rows |
| Filter by rank / response | **No** |
| “Remove from consideration” | Reject is enough |

---

## Anti-patterns

| Anti-pattern | Prefer |
|--------------|--------|
| Auctionator-density columns for standing | Name + rank delta + select |
| Approve on every visible row without selection | Select → B CTAs (or only selected row buttons) |
| Mixing rite controls into the scroll pool | Static zone C ([57](../57-scrollframe-list-rows/beef-ladder-officer-lists.md)) |
| Treating queue as shared inbox UX copy | Local/live fanout honesty ([67](../67-offline-officer-suggestion-sync/)) — status chip, not fake sync chrome |

---

## See also

- [evidence-panel.md](evidence-panel.md)  
- [tab-zones.md](tab-zones.md)
