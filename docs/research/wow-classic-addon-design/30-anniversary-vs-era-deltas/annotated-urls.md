# Annotated URLs — Anniversary vs Era deltas

**Last updated:** 2026-07-25  
**Use:** Steal/adapt notes for Church of Beef packaging and onboarding. Prefer primary/official sources over listicles when they conflict on install paths.

| URL | What it is | Steal / adapt for Beef |
|-----|------------|------------------------|
| https://warcraft.wiki.gg/wiki/TOC_format | TOC Interface, suffixes, AllowLoadGameType, Anniversary patch notes (`_Classic` widening, `-BCC` removed) | Authoritative packaging rules; Anniversary ≡ `tbc` / `_TBC.toc`; verify Interface via `GetBuildInfo` |
| https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes | TOC `20506`; Kaivax blue-post mirror on shared UI code | Confirms V1 Interface number for 2.5.6; UI API parity note vs Era 1.15.9 |
| https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408 | Official Classic UI update thread (Kaivax) | Shared-code doctrine; nameplate/raid-frame drift; author advice “use 2.5.6 to prep 1.15.9” |
| https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/ | Journalism summary of Jul 2026 UI modernization | Player-facing explanation that default Classic UI ≠ 2007; affects Era + Anniversary together |
| https://us.forums.blizzard.com/en/wow/t/the-burning-crusadeaddons/2226408 | Player thread: copy Interface/WTF Era → Anniversary; CurseForge TBC tab | Support FAQ language for separate client trees |
| https://us.forums.blizzard.com/en/wow/t/update-schedule-for-anniversary-realms/2223745 | Kaivax: Anniversary → TBC pre-patch; Era transfer window closed | Product history: Anniversary and Era are divergent character lives |
| https://mythic-store.com/us/blog/best-tbc-anniversary-addons-full-guide-for-2025 | Explicit `_anniversary_` Win/Mac AddOns paths | **Best clear path citation** for README install instructions |
| https://www.curseforge.com/wow/addons/mikscrollingbattletext-tbc-anniversary/files/7573212 | Author install path `…/_anniversary_/Interface/AddOns/` | Corroborates `_anniversary_`; also shows Interface-number confusion in the wild (`20505` vs retail-looking mistakes) |
| https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set | CurseForge **BCC Anniversary** tab seeding workaround | Addon-manager onboarding steps |
| https://www.mmoexp.com/News/best-wow-tbc-anniversary-addons-and-how-to-set-them-up.html | Same CurseForge seeding narrative | Secondary corroboration |
| https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/ | Popular Anniversary addon stack | Community combat/quest expectations; **distrust** its `_classic_era_` install FAQ |
| https://www.mmojugg.com/news/essential-addons-for-tbc-classic-anniversary-2026-dominate-outland.html | Attune/Questie-centric Phase 1 stack | Shows attention competitors; Beef stays edge social |
| https://playhub.com/blog/wow-anniversary/best-addons-873130 | Another Anniversary must-have list | Cross-check category bias |
| https://warperia.com/tbc-addons/ | TBC addon roundup | Alternate list for stack culture |
| https://www.curseforge.com/wow/addons/attune | Attune — Era + TBC/Wrath attunement tracker | Multi-flavor cousin: expansion data packs, guild progress tab pattern |
| https://addons.wago.io/addons/attune/versions | Attune version matrix (Era vs BCC zips) | Packaging precedent for per-flavor artifacts |
| https://www.curseforge.com/wow/addons/classiccalender-tbc | TBC Anniversary calendar extension | Example of Era tool forked/extended for Anniversary content |
| https://www.mmogah.com/news/tbc-classic-anniversary/best-addons-for-tbc-anniversary-setup-fixes-and-must-have-tools | Pre-patch separate-client advice (often cites `_classic_`) | Useful for “separate client” narrative; verify folder name against `_anniversary_` sources |
| https://news.blizzard.com/en-us/article/24242436/wow-burning-crusade-classic-anniversary-edition-now-live | Official TBC Anniversary live announcement | Product naming / launch context |
| ../../superpowers/specs/2026-07-25-church-of-beef-design.md | Approved V1 design spec | Platform lock, portability seams, install folder name `ChurchOfBeef` |

---

## Conflict resolution rule

If a listicle’s install path disagrees with **Mythic-Store + MSBT author notes + Sportskeeda “Anniversary folder”** language, prefer `_anniversary_`. If Interface numbers disagree, prefer **in-client `GetBuildInfo`** and [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes) over addon changelogs.
