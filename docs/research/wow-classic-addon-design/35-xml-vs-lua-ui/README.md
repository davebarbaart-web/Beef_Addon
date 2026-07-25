# Track 35 — FrameXML / XML UI vs pure Lua UI

**Track id:** `35-xml-vs-lua-ui`  
**Last updated:** 2026-07-25  
**Sole focus:** When Classic addons use FrameXML XML templates vs `CreateFrame` Lua; inheritance (`virtual` / `inherits`); maintainability tradeoffs; recommendation for Beef officer/ladder UI construction.  
**Out of scope (do not duplicate):** Visual language / ElvUI coexistence ([02](../02-visual-language/)), surface UX patterns ([01](../01-ux-patterns/)), Masque/SharedMedia skinning ([10](../10-skinning-masque-sharedmedia/)), color tokens ([23](../23-color-brand-tokens/)), Ace options trees ([03](../03-ace-libs-options/)), secure/taint deep dive ([29](../29-taint-secure-ui/)), slash UX ([22](../22-slash-commands-ux/)). No addon implementation in this folder.

## Product truth (from V1 spec + plan)

| Locked / planned | Value |
|------------------|-------|
| Allowed tech | Lua and XML only (no external UI) |
| Plan default | **XML optional; Lua `CreateFrame` primary** |
| UI modules | `UI/MainFrame.lua`, `LadderTab`, `StandingTab`, `OfficerTab`, Minimap, Toasts |
| Visual bar | Plain Classic frames in V1; theatrical chrome later |
| AceGUI | Not required for V1 |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §2, §10; [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) Tech Stack + Task 7.

## Index

| Note | Covers |
|------|--------|
| [mechanics-inheritance.md](mechanics-inheritance.md) | XML + Lua complementarity; `CreateFrame`; virtual templates; `inherits` / `$parent` / `parentKey` |
| [when-xml-vs-lua.md](when-xml-vs-lua.md) | Decision matrix, community consensus, maintainability, load vs runtime |
| [beef-officer-ladder-ui.md](beef-officer-ladder-ui.md) | Concrete recommendation for MainFrame / ladder / officer queue |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **XML and Lua are complementary, not rivals.** XML predefines widget trees; Lua runs behavior and can also create/manipulate widgets. Pure-XML UIs do not exist — scripts always land in Lua ([XML user interface](https://warcraft.wiki.gg/wiki/XML_user_interface)).

2. **`CreateFrame` inherits Blizzard templates without writing XML.** Fourth argument is a comma-delimited list of virtual template names (`"BasicFrameTemplate"`, `"UIPanelButtonTemplate"`, …). Templates themselves must be authored in XML with `virtual="true"` — you cannot invent new FrameXML templates from Lua alone ([CreateFrame](https://wowpedia.fandom.com/wiki/API_CreateFrame); [Virtual XML template](https://warcraft.wiki.gg/wiki/Virtual_XML_template)).

3. **Author consensus for small/medium addons: Lua-first is fine.** WoWInterface authors note Lua is easier to debug; XML shines for large static trees, layer tags (`useParentLevel`), hybrid scrollframes, and *creating* reusable templates. After load, neither approach is meaningfully “more efficient” at runtime ([Frames: XML vs LUA?](https://www.wowinterface.com/forums/showthread.php?t=51507)).

4. **Classic-native chrome is a template inheritance problem, not an XML-file problem.** Gello’s Classic guidance: `BasicFrameTemplate` (title + close) works on Classic; pull button/dialog looks from SharedUIPanel templates via `inherits` / `CreateFrame` 4th arg ([Blizzard UI & Macro thread](https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298)).

5. **Beef V1 should stay Lua-primary + inherit FrameXML templates.** Matches the locked plan (“XML optional”). Build MainFrame / tabs / ladder rows / officer actions in `CreateFrame` Lua; inherit `BasicFrameTemplate` / `UIPanelButtonTemplate` / `UIPanelCloseButton` (and Classic-verified cousins) for Blizzard look. Defer custom `.xml` until you need a *shared Beef virtual template* reused many times or a hybrid scrollframe Blizzard expects in XML.

6. **Ladder/officer lists are dynamic — Lua wins.** Row pools, show/hide, Approve/Reject wiring, and roster-driven refresh are imperative. XML is a poor home for “N guild members × standing columns.” Keep Core→UI adapters thin; reuse frames (they cannot be GC’d) ([CreateFrame notes](https://addonstudio.org/wiki/WoW:API_CreateFrame)).

## Boundary with visual tracks

| Concern | Owner |
|---------|--------|
| How frames are *constructed* (XML vs Lua, inheritance) | **This track (35)** |
| How they *look* (gothic chrome, fonts, ElvUI) | 02 / 10 / 23 |
| Where they *sit* (edge social, not combat HUD) | 01 / 02-ux |
| Secure templates / taint | 29 (Beef V1: ordinary insecure frames only) |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / Wowpedia / WoWInterface / Blizzard UI forum over listicles.
