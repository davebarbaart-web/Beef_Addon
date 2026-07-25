# Annotated URL list — minimap collectors & Addon Compartment

**Last updated:** 2026-07-25  
**Legend:** ★ primary technical · ◆ ecosystem / product · ○ secondary / opinion

---

## LibDBIcon & LDB

| URL | Annotation |
|-----|------------|
| ★ https://www.wowace.com/projects/libdbicon-1-0 | Canonical LibDBIcon docs: Register, hide/Show, AceDB sample. Steal the saved-table contract. |
| ★ https://www.curseforge.com/wow/addons/libdbicon-1-0 | Flavor matrix (Classic + Classic TBC + Retail…); download/version truth. |
| ★ https://github.com/tekkub/libdatabroker-1-1/wiki/How-to-provide-a-dataobject | LDB `launcher` vs `data source` patterns. Prefer launcher for Beef. |
| ○ https://www.wowinterface.com/forums/showthread.php?t=54315 | Author culture: don’t hand-roll; use LDB + LibDBIcon for interoperability. |
| ○ https://www.wowinterface.com/forums/showthread.php?t=59832 | End-to-end embed example (toc / embeds.xml / Register). |
| ○ https://www.wowace.com/projects/libdbicon-1-0/files/8448436 | Confirms Jul 2026 support list includes Classic 1.15.x and BC Classic 2.5.x. |

---

## Collectors & LDB displays

| URL | Annotation |
|-----|------------|
| ★ https://www.curseforge.com/wow/addons/hidingbar | Modern collector: LDB + minimap grab; Classic/TBC flavors; MBB successor. Primary Anniv coexistence target. |
| ★ https://www.curseforge.com/wow/addons/minimapbuttonbutton | High-install single-button collector; active Classic + Classic TBC releases. |
| ◆ https://www.curseforge.com/wow/addons/mbb-classic | Legacy Classic MBB; points to HidingBar. Historical only. |
| ◆ https://www.curseforge.com/wow/addons/mbb | Retail MBB page; same HidingBar successor banner. |
| ◆ https://github.com/vallantv/MBBClassic | README states HidingBar supersedes MBB. |
| ◆ https://addons.wago.io/addons/minimapbuttoncollector | Anniv-targeted collector (Interface 20505). Proof Anniv players still need bags. |
| ○ https://arcaneintellect.com/minimap-button-bag-mbb-world-of-warcraft-wow-addon-spotlight | Player UX of MBB (expand, Ctrl+Right detach, slash). Behavior template. |
| ◆ https://www.curseforge.com/wow/addons/bazooka | LDB display bar with Classic/TBC flavors — free second surface if Beef ships LDB. |
| ○ https://us.forums.blizzard.com/en/wow/t/minimap-cluttered-addon-help/304044 | Classic player pain: cluttered minimap. |
| ○ https://www.reddit.com/r/classicwow/comments/ffa99x/any_idea_of_an_addon_i_can_use_to_sort_out_the/ | Norm: hide buttons + use slash commands. |

---

## Addon Compartment

| URL | Annotation |
|-----|------------|
| ★ https://warcraft.wiki.gg/wiki/Addon_compartment | Feature definition, TOC + manual RegisterAddon, 10.0/10.1 patches. Retail source of truth. |
| ★ https://warcraft.wiki.gg/wiki/TOC_format | `AddonCompartmentFunc*` fields; Classic Era/Anniv “includes Modern TOC changes” caveats. |
| ★ https://github.com/Meorawr/LibDBCompartment | LDB→compartment helper; **explicit no-op on unsupported flavors**. Key Anniv judgment input. |
| ◆ https://wowpedia.fandom.com/wiki/Addon_compartment | Mirror of wiki; taint warning on manual registration. |
| ○ https://www.reddit.com/r/wow/comments/13a7hwf/addon_developers_please_start_using_the_new/ | Retail social pressure to adopt compartment. |
| ○ https://www.mmo-champion.com/threads/2652468-Unwanted-button-on-minimap | Explains compartment is Blizzard UI; no default disable. |
| ○ https://www.townlong-yak.com/addons/acf | Retail compartment filter addon — players hide entries. |
| ○ https://us.forums.blizzard.com/en/wow/t/addon-compartment/1921072 | Author/player request for compartment visibility toggles. |
| ○ https://github.com/TheMizeGuy/wow-addon-dev/blob/main/references/toc-format.md | Concise third-party TOC notes tagging compartment as Dragonflight+. |

---

## Classic / Anniv UI context (negative evidence for compartment)

| URL | Annotation |
|-----|------------|
| ◆ https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/ | Jul 2026 Classic/Anniv UI pass = nameplates/raid frames/Edit Mode, not compartment. |
| ◆ https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408 | Official thread for that UI update set. |

---

## Product anchors (in-repo)

| Path | Annotation |
|------|------------|
| `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` §10 | `/beef` + minimap toggle same frame. |
| `docs/research/wow-classic-addon-design/01-ux-patterns/minimap.md` | Surface UX; do not duplicate — compartment depth lives here in track 28. |
| `docs/research/wow-classic-addon-design/04-ace3-and-libraries.md` | LibDBIcon placement in lib strategy. |
| `docs/research/wow-classic-addon-design/00-church-of-beef-implications.md` | Called out this compatibility matrix as a research gap — this track fills it. |
