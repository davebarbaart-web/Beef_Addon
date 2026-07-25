# Annotated URLs — XML vs Lua UI

Primary sources for track 35. Prefer these when deciding how Beef builds frames.

## Core API and schema

| URL | Annotation |
|-----|------------|
| https://warcraft.wiki.gg/wiki/XML_user_interface | Canonical “two approaches” article: XML layout + Lua behavior; template rules (`virtual`, `inherits`, `$parent`); scripts guidance. **Steal:** mental model that they are complementary. |
| https://warcraft.wiki.gg/wiki/Virtual_XML_template | Virtual/deferred nodes; inherit from XML *or* `CreateFrame` 4th arg; templates not in `_G`; FrameXML template catalogs. **Steal:** only create templates in XML. |
| https://wowpedia.fandom.com/wiki/API_CreateFrame | `CreateFrame` args; comma-delimited templates; OnLoad-on-inherit; examples with `UIPanelButtonTemplate`. **Steal:** Lua + Blizzard template pattern for buttons. |
| https://warcraft.wiki.gg/wiki/API_CreateFrame | wiki.gg mirror of CreateFrame (prefer when available). |
| https://addonstudio.org/wiki/WoW:API_CreateFrame | Notes: inherit frames must be XML `virtual`; OnLoad only from inheritance at create time; frames cannot be deleted. **Steal:** pool ladder rows. |
| https://addonstudio.org/wiki/WoW:UI_XML_tutorial | Full XML tutorial: Ui root, layers, template rules, `$parent`, override behavior. **Adapt:** only if/when Beef adds `.xml`. |

## Blizzard templates and extraction

| URL | Annotation |
|-----|------------|
| https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298 | Gello: **Classic** `BasicFrameTemplate`; modern `DefaultPanelTemplate`; dialog templates; point to SharedUIPanelTemplates. **Steal for Beef:** Classic shell = BasicFrameTemplate path. |
| https://www.townlong-yak.com/framexml/live/SharedUIPanelTemplates.xml | Browsable SharedUIPanel template source (live/mainline-oriented — verify Classic). **Use:** name lookup before inheriting. |
| https://github.com/Ketho/BlizzardInterfaceResources/blob/mainline/Resources/Templates.lua | Compiled template name list (mainline bias). **Use:** discovery, then Classic-check. |
| https://wowpedia.fandom.com/wiki/Viewing_Blizzard%27s_interface_code | How to extract / view FrameXML. **Use:** Anniversary template verification. |

## Author practice / maintainability

| URL | Annotation |
|-----|------------|
| https://www.wowinterface.com/forums/showthread.php?t=51507 | **Frames: XML vs LUA?** — still the best short debate: templates need XML; Lua fine for small/medium; load-time vs runtime; hybrid scrollframe note; debug ergonomics. **Steal:** Lua-first for Beef V1. |
| https://www.wowinterface.com/forums/showthread.php?t=59738 | CreateFrame without template = blank frame; 4th arg inherits; recreating templates in Lua means copying all regions. **Steal:** inherit, don’t rebuild chrome. |
| https://stackoverflow.com/questions/1972722/lua-vs-xml-for-data-storage | Side note: many addons bootstrap XML then build in Lua; SV are `.lua`. **Adapt:** folklore only — not a V1 requirement. |

## Related library / plan context (not FrameXML)

| URL | Annotation |
|-----|------------|
| https://www.wowace.com/projects/ace3/pages/getting-started | Ace3 / embeds.xml — relevant if V2 options explode; **not** required for V1 ladder construction. |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | Locked: XML optional, CreateFrame primary, `UI/*.lua` module layout. |
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Lua/XML only; plain Classic frames V1. |

## Intentionally not expanded here

| Topic | See instead |
|-------|-------------|
| Colors, gothic chrome, ElvUI | Tracks 02 / 10 / 23 |
| Slash / tab IA | Tracks 22 / 01 |
| Secure templates / taint | Track 29 |
