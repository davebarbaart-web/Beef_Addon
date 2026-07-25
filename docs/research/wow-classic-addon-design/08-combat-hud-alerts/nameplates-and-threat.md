# Nameplates & Threat Visualization

**Last updated:** 2026-07-25  
**Surface:** Enemy/friendly plates, aggro coloring, threat meters

---

## Dominant patterns

| Pattern | Exemplars | Signal |
|---------|-----------|--------|
| Scriptable / highly configurable plates | [Plater Nameplates](https://www.curseforge.com/wow/addons/plater-nameplates) | Debuff tracking, threat coloring, WA-like scripting; Wago/Companion culture ([Legacy-WoW Plater](https://legacy-wow.com/tbc-burning-crusade-classic-wow-addons/plater-nameplates/); [Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)) |
| Legacy tidy / threat plate lineage | Tidy Plates / Threat Plates (cited in older Anniversary lists) | Border/health color by aggro state ([MMOGAH mentions Tidy Plates](https://www.mmogah.com/news/tbc-classic-anniversary/best-addons-for-tbc-anniversary-setup-fixes-and-must-have-tools)) |
| Aesthetic plate skins | [KuiNameplates](https://legacy-wow.com/tbc-burning-crusade-classic-wow-addons/kuinameplates/) | “Prettier” plates; still combat-edge UI |
| Dedicated threat meter | [ThreatClassic2](https://www.curseforge.com/wow/addons/threatclassic2) | Simple threat meter for Classic & TBC Classic; LibThreatClassic2 successor to ClassicThreatMeter ([CurseForge](https://www.curseforge.com/wow/addons/threatclassic2); [wowisclassic description](https://www.wowisclassic.com/en/addons/threatclassic2)) |

Anniversary combat lists routinely include Plater (and sometimes ThreatClassic) next to boss mods and OmniCC ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).

---

## Threat color language

Threat UIs train a **tri-state (or binary) color code** that players read without numbers:

- **Red** — you have aggro / tanking threat problem for non-tanks  
- **Yellow / orange** — close / gaining  
- **Green / cool** — safe / low threat  

Deep-research synthesis for this track: prefer discrete states over percentage shading; keep plates small at the **edges** so they don’t crowd foveal combat ([`.raw/combat-hud-deep.md`](.raw/combat-hud-deep.md)).

ThreatClassic2 emphasizes accurate Classic threat tables via **LibThreatClassic2** and coexistence with other displays (e.g. Details tiny threat) sharing the library ([wowisclassic](https://www.wowisclassic.com/en/addons/threatclassic2)).

---

## Arena / PvP frames (adjacent)

[Gladius](https://www.curseforge.com/wow/addons/gladius) / sArena-style enemy frames pack class icons, DR timers, and cooldowns into a **predictable peripheral strip** for arena — high density justified by GCD-speed decisions. Useful only as a reminder that **PvP density ≠ social density**; Beef Gora is theatrical, not an arena CD tracker ([design spec §3.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## Relevance to Church of Beef

| Steal | Avoid |
|-------|-------|
| Discrete state colors people already understand (safe / caution / hot) for **non-combat** status chips if ever needed | Drawing on nameplates or threat meters |
| Edge placement for ambient info | Red “aggro” styling for ladder toasts |
| Library coexistence mindset (don’t fight Details/Plater) | Any plate scripting or combat targeting aids |

Nameplates are **irrelevant to V1 features**; they matter as **sacred combat periphery** Beef must not invade.

## Sources

- [Plater Nameplates — CurseForge](https://www.curseforge.com/wow/addons/plater-nameplates)
- [ThreatClassic2 — CurseForge](https://www.curseforge.com/wow/addons/threatclassic2)
- [ThreatClassic2 — wowisclassic](https://www.wowisclassic.com/en/addons/threatclassic2)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [Legacy-WoW — Plater / Kui listings](https://legacy-wow.com/tbc-burning-crusade-classic-wow-addons/)
- [MMOGAH — Best Addons for TBC Anniversary](https://www.mmogah.com/news/tbc-classic-anniversary/best-addons-for-tbc-anniversary-setup-fixes-and-must-have-tools)
