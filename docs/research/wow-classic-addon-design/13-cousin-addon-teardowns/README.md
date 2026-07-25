# Track 13 — Cousin-addon UX tear-downs

**Date:** 2026-07-25  
**Scope:** UX / product patterns only (screens, queues, sync, announces). No addon code.  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Why this track:** Spec synthesis already flags Attune / Gargul / RP directories as the closest social cousins ([00 implications §suggested topics](../00-church-of-beef-implications.md)). Tracks [01](../01-ux-patterns/) only name them; this folder deepens IA and sync behavior.

## Documents in this track

| Doc | Subject |
|-----|---------|
| [attune.md](attune.md) | Attune — progress trees, guild survey, raid planner, announce options |
| [gargul.md](gargul.md) | Gargul — master-looter queues, awards, chat announces, softres broadcast |
| [rp-directory-trp3-mrp.md](rp-directory-trp3-mrp.md) | Total RP 3 / MyRolePlay — directory, titles, MSP peer exchange |
| [steal-avoid-for-beef.md](steal-avoid-for-beef.md) | Cross-cutting steal / avoid map for Church of Beef V1 |
| [annotated-urls.md](annotated-urls.md) | Annotated primary URLs used in this track |

Raw search/extract JSON lives under [`.raw/`](.raw/) for auditability.

## Selection rationale

| Cousin | Why it is a cousin of Beef |
|--------|----------------------------|
| **Attune** | Shared guild progress visibility + soft dependency on peers installing the addon |
| **Gargul** | Officer-led decision queue; plain-chat spectacle; ML-only authority pattern |
| **TRP3 / MRP** | Social identity directory + titles; peer profile sync without a server |

**Not primary cousins (mentioned only for contrast):** RCLootCouncil (voting council UX denser than Beef’s single Officer+ approve), Questie (progress spam anti-pattern).

## Client note

V1 target is **TBC Classic Anniversary**. Attune and Gargul ship Classic / Classic TBC flavors; TRP3 historically had a Classic build and now advertises Classic & TBC compatibility on WowInterface. Always install the Anniversary client’s `Interface/AddOns` tree.
