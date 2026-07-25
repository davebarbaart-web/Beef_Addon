# Minimap

**Surface:** Minimap chrome, tracking, addon launcher buttons  
**Flavors:** All Classic

---

## Dominant patterns

| Pattern | Exemplars | Notes |
|---------|-----------|-------|
| Shape / scale / position | [ElvUI](https://tukui.org/elvui), [Leatrix Maps](https://www.curseforge.com/wow/addons/leatrix-maps) | Square minimap common in “clean” UIs |
| Gathering / quest pins on minimap | GatherMate2, Questie | Pin density is a player complaint when overdone |
| **Addon minimap button** | [LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0) + LibDataBroker | De facto launcher standard |
| Button collectors | MinimapButtonCollector, MBB-style addons | Collapse many addon icons into one |

LibDBIcon registers an LDB object, stores position/hide in a saved table, and supports `Hide`/`Show` ([WowAce LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0)).

---

## Version notes

| Flavor | Notes |
|--------|-------|
| **All Classic** | Minimap button sprawl is universal; collectors are common |
| **Anniv** | Same LibDBIcon ecosystem as Era/Cata; separate install tree means separate button layout saves |

---

## Relevance to Church of Beef

- Spec requires a **minimap button** toggling the same frame as `/beef` ([design spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- Prefer LibDBIcon-compatible behavior (or hand-rolled that collectors can grab).
- Ship a **hide minimap button** preference eventually; slash must remain enough.
- Do not add extra minimap pins for ranks — that fights Questie/GatherMate.

## Sources

- [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0)
- [Leatrix Maps — CurseForge](https://www.curseforge.com/wow/addons/leatrix-maps)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- Design spec §10
