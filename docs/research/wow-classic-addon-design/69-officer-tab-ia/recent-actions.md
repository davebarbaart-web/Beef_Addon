# Recent Actions (Officer tab)

**Track:** 69-officer-tab-ia  
**Zone:** D — History  
**Question:** Where does the officer alibi strip live, and what does each row show without becoming CEPGP traffic?

**Doctrine / schema:** [40 approve-reject-audit-logs](../40-officer-moderation-audit/approve-reject-audit-logs.md) · [40 beef-product-patterns](../40-officer-moderation-audit/beef-product-patterns.md).  
This note owns **placement and density only**.

---

## Cousin patterns

| Source | Pattern | Steal for D |
|--------|---------|-------------|
| [RCL Loot History](https://rclootcouncil.com/wiki/Loot-History) | One row per decision; reason; filters; export | One row per officer decision; **no** V1 filters/export |
| [CEPGP traffic](https://www.wowinterface.com/downloads/info25051-CEPGP.html) | Searchable modifications window | Mental model “append-only glance”; not a second full window in V1 |
| Stream audit logs (via [40](../40-officer-moderation-audit/annotated-urls.md)) | Actor + before/after + time | Row shape |

---

## Placement

- **Bottom of Officer tab** (zone D), always Officer+-only with the tab.  
- **Not** a fourth main-frame tab — history is subordinate to the live queue.  
- **Not** on Ladder / My Standing in V1 (members get tooltip / “last official change” per [40 visibility tiers](../40-officer-moderation-audit/approve-reject-audit-logs.md)).

Height budget: ~3–5 visible rows. Overflow → Faux only if needed ([57](../57-scrollframe-list-rows/)); prefer truncate + “older actions not shown” over a history browser.

---

## V1 row shape

| Column | Required | Example |
|--------|----------|---------|
| When | Yes | relative or short server time |
| Actor | Yes | approving officer name |
| Verb | Yes | Approved / Rejected / Demoted / Adjusted / Appointed / Bestowed |
| Subject | Yes | target player |
| Before → after | Yes when ranks/standing change | Knight → Butcher; or standing 400→380 |
| Reason | If stored | demote/reject/wipe reasons from [58](../58-staticpopup-confirms/) / [40](../40-officer-moderation-audit/) |

Data source for V1: applied `RANK_COMMIT`s + **local** reject log ([40](../40-officer-moderation-audit/beef-product-patterns.md)). Do not invent a grow-only shared audit wire type in this track.

---

## Interaction

| Action | V1 |
|--------|-----|
| Click row | Optional: tooltip with full reason / revision id — no navigation required |
| Undo from row | **No** — undo is compensating commit via zone C ([40 undo](../40-officer-moderation-audit/undo-and-compensating-commits.md)) |
| Filter / export | **Later** |
| Auto-scroll on new action | Soft: keep viewport on newest if officer isn’t mid-read |

After a successful Approve from zone B, the new row should appear in D without leaving the tab — closes the “did it stick?” loop.

---

## Empty Recent Actions

Distinct from empty queue:

| State | Message job (copy → [41](../41-empty-states-degraded-ux/)) |
|-------|-------------------------------------------------------------|
| No actions yet this toon | “No officer actions recorded yet.” |
| Queue busy, history empty | Possible on fresh officer alt (per-character SV) — do not imply guild-wide silence |

---

## Anti-patterns

| Anti-pattern | Prefer |
|--------------|--------|
| Full `/rc history` browser in V1 | Compact strip |
| Hiding demotes while showing promotes | Symmetric verbs in D |
| Making D the primary workspace | A+B remain primary |
| Syncing personal “seen” attention into D | Attention is [49](../49-officer-notifications/); D is decisions |

---

## See also

- [tab-zones.md](tab-zones.md)  
- [empty-states-ia.md](empty-states-ia.md)
