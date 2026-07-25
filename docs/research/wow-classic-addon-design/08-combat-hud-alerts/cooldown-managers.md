# Cooldown Managers & Button Enrichment

**Last updated:** 2026-07-25  
**Surface:** Action-bar cooldowns, icon groups, spell-activation glows

---

## Dominant patterns

| Pattern | Exemplars | What players expect |
|---------|-----------|---------------------|
| Numeric CD text on existing buttons | [OmniCC](https://www.curseforge.com/wow/addons/omni-cc) | Readable seconds over Blizzard swipe; no new HUD region |
| Icon-group trackers (grids of CDs/buffs) | [TellMeWhen](https://www.curseforge.com/wow/addons/tellmewhen), WeakAuras groups | Movable icon packs; state via color/alpha/glow |
| Proc / activation overlays on bars | [ClassicSpellActivations](https://www.curseforge.com/wow/addons/classicspellactivations) | Ability “lights up” when a proc/condition is usable |
| Aura duration readability | [ClassicAuraDurations](https://www.curseforge.com/wow/addons/classicauradurations) | Clear remaining time on buffs/debuffs where default UI is weak |
| Full custom CD/proc displays | [WeakAuras](https://www.curseforge.com/wow/addons/weakauras-2) + Wago packs | Importable combat packs near character |

Anniversary guides list OmniCC and ClassicSpellActivations in the core combat toolkit ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/); [Playhub](https://playhub.com/blog/wow-anniversary/best-addons-873130)). OmniCC is described as putting **numeric cooldown timers on abilities and items**, making readiness “far more responsive and modern” without inventing a new panel ([MMOEXP](https://www.mmoexp.com/News/best-wow-tbc-anniversary-addons-and-how-to-set-them-up.html); [Overgear OmniCC blurb](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).

---

## Design lessons (cooldown family)

### OmniCC — enrich, don’t occupy

- Overlays text on widgets the player already watches.
- Lowest screen-cost countdown representation.
- Teaches social addons: **prefer augmenting an existing surface** (guild chat line, minimap button badge) over a new floating combat-style timer.

### TellMeWhen / icon groups — state, not sprawl

- Tracked abilities live in **configurable groups** (rows/grids).
- Status is conveyed by **ready / on CD / missing** via color, alpha, or glow — not by spawning unique frame types per spell.
- Users expect **drag, scale, lock**.

### ClassicSpellActivations — transient readiness

- Highlights when a proc/condition makes a spell usable ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).
- Pattern: **momentary glow**, not a permanent banner.

---

## Version notes

| Flavor | Notes |
|--------|-------|
| **Anniv (TBC)** | OmniCC + ClassicSpellActivations + WA packs are the common “readable rotation” trio in roundups |
| **Era / SoD** | Same OmniCC habit; SoD/HC often lean harder on WA packs for runes/skills |
| **Retail contrast** | More built-in cooldown text / Edit Mode — Classic players still expect OmniCC-class readability |

---

## Relevance to Church of Beef

| Do | Don’t |
|----|-------|
| Steal **glanceable numeric / short-lived state** for toasts (e.g., “pending suggestion”) | Ship cooldown trackers, GCD tickers, or spell-activation helpers |
| Keep social UI **off the action-bar cluster** | Glow/red-pulse like a proc ready indicator for routine events |
| Throttle / batch notices the way CD UIs avoid spam | Spawn a new icon per standing drip |

See also: [hud-atlas-and-urgency.md](hud-atlas-and-urgency.md), [weakauras-combat-packs.md](weakauras-combat-packs.md).

## Sources

- [OmniCC — CurseForge](https://www.curseforge.com/wow/addons/omni-cc)
- [ClassicSpellActivations — CurseForge](https://www.curseforge.com/wow/addons/classicspellactivations)
- [ClassicAuraDurations — CurseForge](https://www.curseforge.com/wow/addons/classicauradurations)
- [TellMeWhen — CurseForge](https://www.curseforge.com/wow/addons/tellmewhen)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [MMOEXP — Best WoW TBC Anniversary Addons](https://www.mmoexp.com/News/best-wow-tbc-anniversary-addons-and-how-to-set-them-up.html)
