# Action Bars

**Surface:** Action bars, stance/form paging, button cooldowns, bar fading  
**Flavors:** All Classic; bar count / paging quirks differ by expansion

---

## Dominant patterns

| Pattern | Exemplars | What players expect |
|---------|-----------|---------------------|
| Fully movable multi-bar layouts | [Bartender4](https://www.curseforge.com/wow/addons/bartender4), [Dominos](https://www.curseforge.com/wow/addons/dominos), [ElvUI](https://tukui.org/elvui) bars | Drag, scale, padding, hide Blizzard art |
| Stance / form / page switching | Bartender, Dominos, ElvUI | Bars swap with stance/stealth/form |
| Numeric cooldown text on buttons | [OmniCC](https://www.curseforge.com/wow/addons/omni-cc) | Readable seconds on icons |
| Proc / “spell activation” glow | ClassicSpellActivations, WeakAuras | Light up when a proc is usable |
| Hide unused bars / fade out of combat | ElvUI, Bartender options | Clean idle screen |

Anniversary roundups list Bartender4, Dominos, and ElvUI as the standard interface stack for bars ([Overgear TBC Anniversary](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).

---

## Version notes

| Flavor | Notes |
|--------|-------|
| **Era / SoD** | Fewer baseline bars than modern retail; SoD runes/skills often tracked via WeakAuras more than bar paging |
| **Anniv (TBC)** | Classic bar paging + pet/stance bars still central; ElvUI changelog historically tracks Classic/TBC keybind and paging edge cases |
| **Cata+** | More abilities → denser bars or heavier WeakAuras reliance; same mover UX |

---

## Classic-native vs modern feel

- **Native:** Keep button borders/artwork; bars along bottom like 2006–07.
- **Modern Classic:** Borderless icon strips, centered “action camera” clusters, combat fade.

---

## Relevance to Church of Beef

- Do **not** occupy action-bar real estate or bind combat keys.
- **Do** steal: movable frame, clamp-to-screen, saved position, optional fade — patterns players already know from bar movers ([design spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

## Sources

- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [Bartender4 — CurseForge](https://www.curseforge.com/wow/addons/bartender4)
- [Dominos — CurseForge](https://www.curseforge.com/wow/addons/dominos)
- [OmniCC — CurseForge](https://www.curseforge.com/wow/addons/omni-cc)
- [ElvUI — Tukui](https://tukui.org/elvui)
