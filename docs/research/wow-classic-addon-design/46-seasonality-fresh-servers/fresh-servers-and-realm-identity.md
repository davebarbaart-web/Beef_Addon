# Fresh servers & realm identity

## What “fresh” means for Anniversary

WoW Classic **20th Anniversary** opened **fresh progression realms** on **21 November 2024** — empty economies, phased Classic content, then a planned transition into Burning Crusade rather than a permanent Era freeze ([Wowhead Fresh roadmap](https://www.wowhead.com/classic/guide/fresh-servers-roadmap-phases)).

TBC Classic Anniversary **did not open a second empty TBC shard** for those communities. The same Anniversary realms **progressed** into Outland (pre-patch **13 Jan 2026**, TBC launch **5 Feb 2026** per community roadmaps such as [Warcraft Tavern phases](https://www.warcrafttavern.com/tbc/guides/phases/) and [Wowhead TBC Anniversary roadmap](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap)).

**Implication for Beef:** “fresh server” energy already happened once for this flock. Church seasons during TBC should feel like **liturgical seasons inside a living congregation**, not like wiping the realm. Character and guild continuity across Classic→TBC is the product truth of Anniversary.

## Realm list (Anniversary → TBC)

Documented TBC Anniversary realm set ([Wowhead](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap)):

| Region | Realm | Type | TBC progression |
|--------|-------|------|-----------------|
| NA | Dreamscythe | PvE | Yes — primary Alliance home in brand copy |
| NA | Nightslayer | PvP | Yes |
| EU | Thunderstrike | PvE | Yes |
| EU | Spineshatter | PvP | Yes |
| AU–NA | Maladath | PvP | Yes |
| NA | Doomhowl | Hardcore | **No** — remains Classic; transfer to PvE to enter TBC |
| EU | Soulseeker | Hardcore | **No** — same HC rule |

Extra Anniversary constraints that matter socially (not for BeefNet): faction creation locks on PvP imbalance; **no GDKP** on NA/EU Anniversary ([Wowhead](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap)).

## Spec vs realm-type nuance

Design brand context: Alliance on Dreamscythe, Horde on Doomhowl ([spec §3.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Architecture: **each guild = independent ladder**, no cross-realm state ([spec §5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

| Fact | Beef consequence |
|------|------------------|
| Dreamscythe is on the TBC Anniversary client | V1 target install path is valid here |
| Doomhowl is Hardcore / Classic-only unless transferred | A Horde “Doomhowl” identity may now live on Dreamscythe (or another PvE) after transfer — verify guild home before assuming one SV/realm |
| Two factions = two guilds even on one PvE realm | Still two ladders; BeefNet is GUILD-scoped |
| Fresh launch was a shared origin | Lore/ceremony can reference “the Grazing of ’24”; scoring must not assume realm wipe |

## When Beef should treat a launch as a hard season break

| Event | Hard break? | Why |
|-------|-------------|-----|
| Mid-phase weekly reset | No | Lockout only; standing persists |
| New content phase (SSC, BT, …) | Soft by default | Label + ceremony; optional officer reset later |
| Guild transfers to a new realm | Yes for that guild’s continuity story | New peers, new BeefNet mesh; treat as new congregation unless officers explicitly migrate commits |
| Blizzard opens a *new* empty fresh wave | Yes | Empty ladder is correct; do not import foreign SV |
| Classic+ / new product line | Yes (future port) | Spec already scopes Classic+ out of V1 |

## Transfer / HC edge for alts

Spec alts start Fresh Beef on each character. HC→PvE transfers create **new TBC characters on a different realm flavor** with no shared SV. That matches doctrine (“the flesh must prove itself anew”) and avoids inventing account merge for seasonality reasons.
