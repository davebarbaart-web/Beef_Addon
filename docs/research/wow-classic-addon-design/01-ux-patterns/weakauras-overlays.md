# WeakAuras-Style Overlays

**Surface:** Custom anchored icons, bars, text, glows for combat/procs  
**Flavors:** All Classic; pack content is expansion-specific (Wago)

---

## Dominant patterns

| Pattern | Exemplars | Notes |
|---------|-----------|-------|
| Runtime aura engine | [WeakAuras](https://www.curseforge.com/wow/addons/weakauras-2) | Player-authored displays |
| Importable class packs | Wago.io TBC/Era/Cata packs | Anniversary guides lean hard on WA for class UX ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)) |
| Center-screen priority icons | Typical raid WA layouts | Procs/cooldowns in fovea |
| Progressive disclosure | Load conditions (combat, zone, group) | Hide noise out of context |
| Companion boss timers | BigWigs / DBM bars (related, not WA) | Edge/center timer bars |

WeakAuras is treated as infrastructure: many “class addons” are WA packs that require the host addon first ([Overgear class section](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).

---

## Version notes

| Flavor | Notes |
|--------|-------|
| **Era / SoD** | SoD especially WA-heavy (runes, new skills) |
| **Anniv** | Dense Wago ecosystem for TBC classes/raids |
| **Cata** | Same WA UX; different trigger APIs/spell IDs |

---

## Relevance to Church of Beef

- V1 **toasts** (suggestion, rank approved, Gora/ceremony credit) should learn WA’s good manners: **brief, high-contrast, then clear** — not persistent center HUD ([design spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- Do not require WeakAuras as a dependency.
- V2 ceremonial spectacle can borrow “spotlight for N seconds” choreography; keep it social, not rotational.

## Sources

- [WeakAuras — CurseForge](https://www.curseforge.com/wow/addons/weakauras-2)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/) (class WA packs)
- [Wago.io](https://wago.io/) (import culture)
