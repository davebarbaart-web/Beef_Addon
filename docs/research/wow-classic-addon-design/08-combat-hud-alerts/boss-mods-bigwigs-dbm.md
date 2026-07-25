# Boss Mods: BigWigs & DBM

**Last updated:** 2026-07-25  
**Surface:** Encounter timers, raid warnings, pull alerts

---

## Role in the Classic stack

For TBC Anniversary group content, a boss mod is treated as near-mandatory: timers and warnings for dangerous mechanics ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/); [Playhub](https://playhub.com/blog/wow-anniversary/best-addons-873130); [MMOGAH](https://www.mmogah.com/news/tbc-classic-anniversary/best-addons-for-tbc-anniversary-setup-fixes-and-must-have-tools)). Legacy directories still list DBM as “often required by raiding guilds” ([Legacy-WoW DBM](https://legacy-wow.com/tbc-burning-crusade-classic-wow-addons/deadly-boss-mods-dbm-tbc-classic/)).

Players typically pick **one** of:

| Addon | Positioning (public) |
|-------|----------------------|
| [BigWigs](https://www.curseforge.com/wow/addons/big-wigs) | “Modular and lightweight approach” to boss tools ([GitHub](https://github.com/BigWigsMods/BigWigs); [Wago Addons](https://addons.wago.io/?search=bigwigs)); guides call out cleaner / less intrusive setups ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/); [MMOEXP](https://www.mmoexp.com/News/best-wow-tbc-anniversary-addons-and-how-to-set-them-up.html)) |
| [DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods) | “Fight info that's easy to process at a glance”; focuses on “what's happening to you, and what YOU need to do about it” ([CurseForge](https://www.curseforge.com/wow/addons/deadly-boss-mods)) |

TBC encounter content is packaged as expansion modules — e.g. [BigWigs_BurningCrusade](https://github.com/BigWigsMods/BigWigs_BurningCrusade) covers Karazhan, SSC, TK, Hyjal, BT, Sunwell, ZA, world bosses, etc. Core repo TOCs include `BigWigs_TBC.toc` / `Init_TBC.lua` ([BigWigs GitHub tree](https://github.com/BigWigsMods/BigWigs)).

---

## Shared UX patterns

Regardless of brand, Classic boss mods converge on:

1. **Dedicated bar anchors** — usually upper / top-center, user-movable.
2. **Tiered alerts** — informational timers vs personal “you must move/act” cues.
3. **Audio + visual pairing** for high-stakes events; visual-only for soft info.
4. **Per-encounter modularity** — only relevant fight scripts matter; keeps mental load and options sane ([BigWigs modular description](https://github.com/BigWigsMods/BigWigs)).
5. **Glanceable language** — short ability names, countdowns, icons — not lore paragraphs ([DBM glanceability claim](https://www.curseforge.com/wow/addons/deadly-boss-mods)).
6. **User configurability** — disable noisy abilities, move anchors, mute sounds (Playhub notes BigWigs customization as a differentiator ([Playhub](https://playhub.com/blog/wow-anniversary/best-addons-873130))).

Community shorthand: DBM often seen as more “everything on” / casual-friendly; BigWigs as more minimal — both own the **same screen real estate** during pulls ([MMOEXP](https://www.mmoexp.com/News/best-wow-tbc-anniversary-addons-and-how-to-set-them-up.html)).

---

## What “urgency” means here

Boss-mod urgency is **life-or-wipe** urgency. Channels escalate:

- Bar only → bar + sound → emphatic on-screen message / flash for personal lethal assignments.

That escalation ladder is sacred. Social toasts that mimic DBM center yells or BigWigs pull bars will be read as combat noise (or worse, ignored when a real mechanic fires).

---

## Relevance to Church of Beef

| Borrow | Never ship |
|--------|------------|
| Modular event → display separation | Encounter timers, pull countdowns, ability warnings |
| Throttle / disable noisy categories in options | Screen flash / shake for promotions |
| “Tell the player what *they* need to do” for officer queue copy | Competing top-center bars during raids |
| Lightweight default footprint | High-frequency SCORE_EVENT spam as combat-style alerts |

BeefNet already prefers **commits and coarse events** over high-frequency spam ([design spec §8.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) — same spirit as boss-mod performance culture.

**Combat-aware silence:** defer chat-facing announcements and heavy toasts while `InCombatLockdown` / in active pulls when practical; guild-chat promotion lines should remain rare and officer-throttled (already in spec §10).

## Sources

- [BigWigs — CurseForge](https://www.curseforge.com/wow/addons/big-wigs)
- [BigWigs — GitHub](https://github.com/BigWigsMods/BigWigs)
- [BigWigs_BurningCrusade — GitHub](https://github.com/BigWigsMods/BigWigs_BurningCrusade)
- [DBM — CurseForge](https://www.curseforge.com/wow/addons/deadly-boss-mods)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [Playhub — Best Addons for TBC Classic Anniversary](https://playhub.com/blog/wow-anniversary/best-addons-873130)
- [MMOEXP — Best WoW TBC Anniversary Addons](https://www.mmoexp.com/News/best-wow-tbc-anniversary-addons-and-how-to-set-them-up.html)
