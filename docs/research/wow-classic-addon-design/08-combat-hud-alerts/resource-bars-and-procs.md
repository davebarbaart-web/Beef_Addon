# Resource Bars & Proc Alerts

**Last updated:** 2026-07-25  
**Surface:** Class resources, energy/mana helpers, proc / “window” alerts

---

## Dominant patterns

| Pattern | Exemplars | Notes |
|---------|-----------|-------|
| Near-character resource displays | WeakAuras packs (e.g. energy tickers, rage bars), class-specific bars ([Druid Bar Classic](https://www.curseforge.com/wow/addons/druid-bar-classic)) | Sit in the lower-center combat cluster |
| Discrete pips for small integers | Combo points / holy-power style WA layouts; Retail PRD as cultural reference | Pips beat continuous bars for 0–N resources |
| Proc flash / large centered icon | Legacy Power Auras culture → modern WeakAuras | Brief, high-contrast; disappears when proc ends |
| Threshold alerts | Mana reminders, ammo counters ([Wago AmmoCounter](https://wago.io/RBRS5rMYN)) | Fire only when crossing a line |
| Swing timers / DoT uptime | Class WA packs (rogue energy, shaman swing, warlock DoTs) | Dense combat-only HUD |

Overgear’s class sections show how TBC Anniversary players track resources and procs almost entirely via **WeakAuras packs** (shaman totems/procs, rogue energy, warrior rage/swing, warlock DoTs, priest mana) layered on the WeakAuras addon ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/); [Wago Classic WeakAuras hub](https://wago.io/classic-weakauras)). Playhub lists WeakAuras explicitly for cooldowns, buffs/debuffs, trinket procs, resource thresholds, and damage windows ([Playhub](https://playhub.com/blog/wow-anniversary/best-addons-873130)).

### Retail vs Classic note

Retail ships a built-in Personal Resource Display; Classic/TBC Anniversary does **not** — players recreate the pattern with addons/WA (deep-research capability table in [`.raw/combat-hud-deep.md`](.raw/combat-hud-deep.md)). IceHUD-style full HUDs appear in older TBC addon directories but are niche relative to WA + bar movers ([Legacy-WoW IceHUD](https://legacy-wow.com/tbc-burning-crusade-classic-wow-addons/icehud/)).

---

## Design norms for procs

1. **Transient by default** — show when active/usable; hide when not.
2. **One primary proc channel** — competitive packs avoid five simultaneous center flashes.
3. **Icon + optional short text** — glanceable; avoid paragraphs.
4. **Optional sound** — distinctive short cue; user-muteable.
5. **Anchor near the character** for combat resources — this zone is **owned** by WA/combat tools.

Luxthos-style Classic packs advertise complete setups covering **rotational abilities, cooldowns, resources, and utilities** as importable groups ([Luxthos — Mage WeakAuras Classic Era](https://www.luxthos.com/mage-weakauras-for-world-of-warcraft-classic-era-hardcore/); [Wago — Luxthos Mage Classic Era](https://wago.io/njif6ohzh)). That density is exactly what Beef must not imitate on-screen during combat.

---

## Relevance to Church of Beef

Church of Beef has **no class resources to track**. Transferable ideas only:

| Steal | Avoid |
|-------|-------|
| Short-lived “window” presentation for ceremony/Gora moments (later phases) | Always-on resource bars or pip strips |
| Gold/green “good news” accents for promotions | Center-screen proc flash for standing drips |
| Threshold language in My Standing (“X to next rank”) as **panel text**, not HUD alert spam | Combat-style threshold beeps |

Standing gains from shared instance presence already require combat for anti-AFK ([design spec §7.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) — that is scoring logic, **not** a reason to draw a combat resource HUD.

## Sources

- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [Playhub — Best Addons for TBC Classic Anniversary](https://playhub.com/blog/wow-anniversary/best-addons-873130)
- [Wago — Classic WeakAuras](https://wago.io/classic-weakauras)
- [Luxthos — Mage WeakAuras Classic Era](https://www.luxthos.com/mage-weakauras-for-world-of-warcraft-classic-era-hardcore/)
- [Druid Bar Classic — CurseForge](https://www.curseforge.com/wow/addons/druid-bar-classic)
- [`.raw/combat-hud-deep.md`](.raw/combat-hud-deep.md)
