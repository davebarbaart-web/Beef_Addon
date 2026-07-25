# Annotated URLs — ScrollFrame / list rows

Primary sources for track 57. Prefer these when choosing scroll/list patterns for Beef.

## Scroll models (canonical)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame/Archive | Defines true vs Faux vs Hybrid templates; **fidgeting** warning for multi-textured ScrollChild content; when *not* to use true scroll for lists. |
| https://warcraft.wiki.gg/wiki/Making_a_scrollable_list_using_FauxScrollFrameTemplate | End-to-end Faux HOWTO: `OnVerticalScroll`, `FauxScrollFrame_Update`, offset → rebind visible rows; FriendsFrame as richer reference. **Steal:** virtual-list mental model. |
| https://warcraft.wiki.gg/wiki/HybridScrollFrame | Hybrid create/update pattern; `CreateButtons` + `update` + `HybridScrollFrame_Update`. **Adapt:** only after Anniversary template verify; expects XML item template. |
| https://wowpedia.fandom.com/wiki/HybridScrollFrame | Mirror if wiki.gg API pages are under maintenance. |

## Author practice (Lua + pools)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowinterface.com/forums/showthread.php?t=45810 | **FauxScrollFrame in pure Lua** — CreateFrame + template; row buttons; initialize Update on show. Page 2: pass **function** to `FauxScrollFrame_OnVerticalScroll`, not its return value. |
| https://www.wowinterface.com/forums/showthread.php?t=52623 | Hybrid `CreateButtons` requires XML `virtual` button template — Lombra: templates cannot be created in Lua. Direct tension with Lua-primary V1. |
| https://www.wowinterface.com/forums/showthread.php?t=58069 | Frames cannot be removed; acquire/release frame pools; separate pools per template; pointer to Blizzard `Pools.lua` / `CreateFramePool`. |
| https://warcraft.wiki.gg/wiki/API_CreateFrame | Frames not GC’d; reuse preferred; template inherit via 4th arg. |

## Classic / Anniversary context

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/ | Anniversary/Era share code with contemporary retail; UI modernization / Edit Mode. **Implication:** Hybrid *may* exist on TBC Anniversary — still verify; do not assume 2019 Era FrameXML. |
| https://github.com/kakysha/HonorSpy | Classic cousin using `HybridScrollFrame` + addon XML `HybridScrollListItemTemplate` for a long rank-style list. **Steal:** pattern proof; **don’t** copy AceGUI shell. |
| https://www.townlong-yak.com/framexml/latest/go/FauxScrollFrameTemplate | Browse Faux template source (flavor may be mainline — confirm Anniversary extract). |
| https://www.townlong-yak.com/framexml/latest/go/HybridScrollFrameTemplate | Browse Hybrid template when verifying names against Classic build. |
| https://wowpedia.fandom.com/wiki/Viewing_Blizzard%27s_interface_code | How to extract FrameXML for the client you ship against. |

## FrameXML / template discovery (supporting)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://github.com/Gethe/wow-ui-source | Upstream-ish UI source browser; branch names drift — use for discovery, confirm on Anniversary. |
| https://www.wowinterface.com/forums/showthread.php?t=51507 | XML vs Lua debate; notes Hybrid/XML cases — owned by track 35; listed here only as list-adjacent context. |

## Product / sibling tracks (not scroll APIs)

| URL / path | Why it matters for Beef |
|------------|-------------------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Ladder + officer queue product surface. |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | Task 8 = 7 bands; Task 9 = officer list actions. |
| [`../35-xml-vs-lua-ui/beef-officer-ladder-ui.md`](../35-xml-vs-lua-ui/beef-officer-ladder-ui.md) | Lua-primary shell; pool rows; Hybrid as XML escape hatch. |
| [`../54-memory-fps-budgets/beef-budgets.md`](../54-memory-fps-budgets/beef-budgets.md) | Open/refresh ms budgets; dirty paint. |

## Intentionally not expanded here

| Topic | See instead |
|-------|-------------|
| MainFrame / tab / XML-vs-Lua policy | Track [35](../35-xml-vs-lua-ui/) |
| Idle CPU / GC patterns broadly | Track [54](../54-memory-fps-budgets/) |
| Officer attention kit | Track [49](../49-officer-notifications/) |
| Context menus on rows | Track [36](../36-tooltips-menus/) |

## Provenance dumps

Local search/scrape artifacts: [`.raw/`](.raw/) (wiki extracts, WoWInterface threads, HonorSpy Hybrid XML, Anniversary UI modernization note).
