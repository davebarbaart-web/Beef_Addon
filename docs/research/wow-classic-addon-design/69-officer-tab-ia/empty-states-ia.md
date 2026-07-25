# Empty states — Officer tab IA slots

**Track:** 69-officer-tab-ia  
**Question:** Which *zones* empty, and what must remain visible?  

**Copy / scenario matrix:** [41 beef-copy-ux-map](../41-empty-states-degraded-ux/beef-copy-ux-map.md) · [41 scenario-matrix](../41-empty-states-degraded-ux/scenario-matrix.md).  
This note only maps **structure**. Do not re-author microcopy here.

---

## Zone emptiness matrix

| Condition | A Queue | B Evidence | C Rites | D Recent Actions |
|-----------|---------|------------|---------|------------------|
| First-time Officer+, no petitions | Empty success | Empty success | **Visible** | Empty or thin |
| Quiet night after clearing queue | Empty success | Empty success | Visible | Populated |
| Petitions present | List | Bound to selection | Visible | Visible |
| Not Officer+ | Tab **hidden** (spec §11) — not grey soup | — | — | — |
| Unguilded | Tab hidden or unreachable with guild gate | — | — | — |
| Sync pending | Show local queue if any; don’t clear A | Don’t flash blank | Visible | Keep cache |

**Rule:** Empty A never removes C. Officers still need demote / Council / Prophet when nobody is petitioning.

---

## Empty-success vs error

| Kind | When | IA treatment |
|------|------|--------------|
| Celebratory / quiet empty | No petitions ([41](../41-empty-states-degraded-ux/) A/C officer) | Banner or centered line **inside A** (or A+B merged message); C+D unchanged |
| Hard gate | Not in guild / not Officer+ | Don’t show a broken Officer tab — hide ([41 antipatterns](../41-empty-states-degraded-ux/beef-copy-ux-map.md)) |
| System status | Syncing / cached / no officers online | **Status chip** above zones — not an A-body error when queue is simply empty |
| Authority offline (member) | N/A on Officer tab | Member Standing copy in [41](../41-empty-states-degraded-ux/); officers alone still use local tab |

Do **not** label an empty queue as “sync broken” ([67](../67-offline-officer-suggestion-sync/v1-recommendation.md) UX honesty).

---

## Cousin empty lessons

| Cousin | Lesson |
|--------|--------|
| Gargul `/gl start` | Teach alone; empty decision UI is OK ([13](../13-cousin-addon-teardowns/gargul.md)) |
| RCLC Voting Frame | Frame appears when session matters — Beef uses toast/badge ([49](../49-officer-notifications/)) then this tab; empty tab ≠ missing session chrome |
| Attune personal tree | Structure visible before data — keep C chrome even when A is empty |

---

## Selection edge empties

| Edge | A | B |
|------|---|---|
| Last petition approved | Empty success | Transition to empty success (don’t leave stale player) |
| Rejected | Row gone; select next | Rebind or empty |
| Soft-expired row removed ([67](../67-offline-officer-suggestion-sync/)) | Same as reject clear | Same |

---

## Acceptance checklist (IA review)

- [ ] Empty queue still shows rites (C)  
- [ ] Empty queue copy is success-tone slot in A/B, not full-tab wipe  
- [ ] Status chips don’t replace empty-queue messaging  
- [ ] Non-officers never see disabled Officer chrome  
- [ ] Recent Actions empty ≠ queue empty (different slots)

---

## See also

- [tab-zones.md](tab-zones.md)  
- [recent-actions.md](recent-actions.md)
