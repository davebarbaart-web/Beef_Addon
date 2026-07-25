# Track 69 — Officer tab information architecture

**Track id:** `69-officer-tab-ia`  
**Last updated:** 2026-07-25  
**Sole focus:** How the **Officer tab** should be *zoned* — pending queue, evidence panel, Recent Actions, empty slots, and where confirm dialogs interrupt the flow. Steal **IA shape** from RCLC Voting Frame / Gargul RollOff for Church of Beef; do not re-derive scroll pools, StaticPopup APIs, or audit doctrine.  
**Out of scope:** List widget / FauxScroll tech ([57](../57-scrollframe-list-rows/)); confirm dialog recipes & slots ([58](../58-staticpopup-confirms/)); audit schema / undo doctrine ([40](../40-officer-moderation-audit/)); empty-state *copy* inventory ([41](../41-empty-states-degraded-ux/)); offline petition sync policy ([67](../67-offline-officer-suggestion-sync/)); alert channels ([49](../49-officer-notifications/)); My Standing breakdown depth ([70](../70-standing-breakdown-ui/)); shell construction ([35](../35-xml-vs-lua-ui/)). No addon implementation in this folder.

## Product truth (from V1 design spec)

| Locked | Value |
|--------|-------|
| Officer tab (Officer+ only) | Pending suggestions, approve/reject, manual standing correction, demote, Council appoint, Prophet bestow ([§10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Suggestion evidence | Player, current → suggested rank, point breakdown, recent contributing events ([§7.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Approve / Reject | Approve → official rank + sync; Reject → clear suggestion, points remain |
| Authority shape | Hybrid suggest → Officer+ commit — **Gargul ML**, not RCLC multi-voter parliament ([13](../13-cousin-addon-teardowns/steal-avoid-for-beef.md)) |
| High-risk friction | Demote / Council / Prophet / wipe need confirms ([40](../40-officer-moderation-audit/beef-product-patterns.md), [58](../58-staticpopup-confirms/)) |
| Recent Actions | Officer-only last-N approve/reject/demote/adjust ([40](../40-officer-moderation-audit/beef-product-patterns.md)) |

## Index

| Note | Covers |
|------|--------|
| [tab-zones.md](tab-zones.md) | Four-zone Officer tab map + reading order |
| [pending-queue-layout.md](pending-queue-layout.md) | Queue list columns, selection, density limits |
| [evidence-panel.md](evidence-panel.md) | Detail panel for the selected petition |
| [recent-actions.md](recent-actions.md) | History strip placement & row shape |
| [empty-states-ia.md](empty-states-ia.md) | Which zone empties when; pointers to [41](../41-empty-states-degraded-ux/) for copy |
| [confirm-handoffs.md](confirm-handoffs.md) | Which controls leave the tab into a modal; return focus |
| [v1-ia-recommendation.md](v1-ia-recommendation.md) | Locked V1 composition + anti-patterns |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with sibling tracks

| This track (69) | Elsewhere |
|-----------------|-----------|
| *Where* queue / evidence / history sit | [57](../57-scrollframe-list-rows/) — *how* rows scroll/pool |
| *When* a modal interrupts the tab | [58](../58-staticpopup-confirms/) — *how* StaticPopup / custom confirm works |
| *What* Recent Actions means for accountability | [40](../40-officer-moderation-audit/) — schema, undo, griefing |
| *What words* empty states say | [41](../41-empty-states-degraded-ux/) |
| *Whether* offline officers share the queue | [67](../67-offline-officer-suggestion-sync/) |
| *How* officers notice a non-empty queue | [49](../49-officer-notifications/) |
| Cousin product tear-downs | [13](../13-cousin-addon-teardowns/) |
| Standing breakdown presentation depth | [70](../70-standing-breakdown-ui/) |

## Top insights for Beef (read this first)

1. **Officer tab = select → evidence → decide.** Steal Gargul RollOff’s “list + award” and RCLC Voting Frame’s “selected session → candidate detail / More Info” — but **drop** vote columns, session switcher, gear/ilvl grids, and multi-voter chrome ([RCL Voting Frame](https://rclootcouncil.com/wiki/Voting-Frame); [Gargul Rolling Items](https://github.com/papa-smurf/Gargul/wiki/Rolling-Items)).

2. **Four zones, one primary job.** (A) Pending queue, (B) Evidence for the selection, (C) Decision / rite controls, (D) Recent Actions. Zone A+B own the promotion night; C hosts demote/Council/Prophet *outside* the scrolling petition pool ([57](../57-scrollframe-list-rows/beef-ladder-officer-lists.md)); D is a short alibi strip, not CEPGP traffic density.

3. **Approve/Reject stay on the selected row (or evidence footer) with no modal.** Confirm friction is reserved for nuclear rites so officers do not Accept-blind when Prophet appears ([58](../58-staticpopup-confirms/beef-demote-prophet-confirms.md)).

4. **Empty queue is a success state.** Keep zones C+D visible when A is empty so officers can still demote/appoint and glance history — do not collapse the whole tab into a joke banner ([41](../41-empty-states-degraded-ux/scenario-matrix.md) scenario C).

5. **Evidence is testimony, not a spreadsheet.** Spec §7.3’s breakdown + recent events is enough for comedy anti-cheat; full loot-history “More Info” windows are V1.1+ if officers demand them ([40](../40-officer-moderation-audit/approve-reject-audit-logs.md)).

## Recommended V1 composition (one line)

**Master–detail Officer tab: short pending list + evidence panel + static rite controls + compact Recent Actions; Gargul authority, RCLC selection/detail IA, neither’s loot density.**

Detail: [v1-ia-recommendation.md](v1-ia-recommendation.md).

## Provenance

Prefer design spec §7.3 / §10 for product truth; cousin wiki pages in [annotated-urls.md](annotated-urls.md) for IA steal notes. No `.raw/` scrape required for this IA pass — citations reuse [13](../13-cousin-addon-teardowns/), [40](../40-officer-moderation-audit/), [57](../57-scrollframe-list-rows/), [58](../58-staticpopup-confirms/).
