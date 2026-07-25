# WeakAuras Combat Packs

**Last updated:** 2026-07-25  
**Surface:** Custom trigger → display overlays; Wago import culture

---

## What WeakAuras is in Classic

[WeakAuras](https://www.curseforge.com/wow/addons/weakauras-2) is the framework almost every Anniversary guide points to for customizable combat graphics — buffs, debuffs, cooldowns, procs, resources, encounter helpers ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/); [Playhub](https://playhub.com/blog/wow-anniversary/best-addons-873130); [MMOGAH](https://www.mmogah.com/news/tbc-classic-anniversary/best-addons-for-tbc-anniversary-setup-fixes-and-must-have-tools)). Wago hosts flavor-specific libraries (e.g. [Classic WeakAuras](https://wago.io/classic-weakauras), [WotLK WeakAuras](https://wago.io/wotlk-weakauras)) and the addon itself on [Wago Addons](https://addons.wago.io/?search=weakauras).

Overgear’s FAQ distinction is useful for product language:

- **Addon** = standalone systems (meters, boss mods, bags).
- **WeakAura** = lightweight situation-based alert **inside** WeakAuras, imported as strings ([Overgear — Difference Between Add-ons and Weakauras](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).

---

## Combat-pack UX conventions

Successful packs (Luxthos-style and class packs cited in Overgear) share:

| Convention | Practice |
|------------|----------|
| **Group imports** | One group covers rotation + CDs + resources + utilities ([Luxthos Mage Classic Era](https://www.luxthos.com/mage-weakauras-for-world-of-warcraft-classic-era-hardcore/)) |
| **Trigger ≠ display** | Conditions (buff present, CD ready) drive icons/bars/text/sounds |
| **Building blocks** | Icon, progress bar, text — rarely large permanent banners |
| **Near-character anchors** | Glance-down combat cluster |
| **Show when relevant** | Hide idle noise; display on trigger |
| **Import + customize** | `/wa` → Import; users expect to move/scale after install |

Anniversary class lists are dense with Wago links (rogue energy tickers, shaman swing timers, warlock packs, warrior packs, etc.) ([Overgear class sections](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)). That ecosystem **owns** center-lower HUD real estate for power users and streamers.

---

## Spectacle lesson (for later Beef phases)

WeakAuras culture is also how streamers stage **brief centered spectacle** — a large icon/text that appears for a moment then clears. That is the only combat-adjacent pattern vaguely useful for ceremonial theater (V2+ dashboard), and only **out of combat** or as a short toast — never as an always-on church HUD during a boss pull.

V1 should stay closer to **system toast + guild chat** than to WA packs ([design spec §10, §14](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## Relevance to Church of Beef

| Do | Don’t |
|----|-------|
| Separate “event happened” from “how we show it” in code/IA | Bundle a WeakAuras dependency or ship WA strings as product |
| Brief toast → clear (WA show/hide discipline) | Occupy the rotation icon cluster |
| Optional later “ceremony moment” polish inspired by WA spectacle | Track combat buffs, procs, or boss auras |

Hard restriction reminder: no combat assistance or decision-making ([design spec §2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

## Sources

- [WeakAuras — CurseForge](https://www.curseforge.com/wow/addons/weakauras-2)
- [Wago — Classic WeakAuras](https://wago.io/classic-weakauras)
- [Wago Addons — WeakAuras search](https://addons.wago.io/?search=weakauras)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [Playhub — Best Addons for TBC Classic Anniversary](https://playhub.com/blog/wow-anniversary/best-addons-873130)
- [Luxthos — Mage WeakAuras Classic Era](https://www.luxthos.com/mage-weakauras-for-world-of-warcraft-classic-era-hardcore/)
- [Wago — Luxthos Mage (Classic Era)](https://wago.io/njif6ohzh)
