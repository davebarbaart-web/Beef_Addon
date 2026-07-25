# Annotated URLs — Track 36

**Last updated:** 2026-07-25  
**Track:** [36-tooltips-menus](README.md)

Steal/adapt notes are for Church of Beef design judgment, not for copying implementation into this research folder.

---

## GameTooltip

| URL | Steal / adapt |
|-----|----------------|
| [GameTooltip object](https://warcraft.wiki.gg/wiki/UIOBJECT_GameTooltip) | **Primary.** Owner vs parent, Show/Hide/ClearLines semantics, scanning tip pattern, method index. |
| [GameTooltip:SetOwner](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetOwner) | Anchor enum (`ANCHOR_RIGHT`, `CURSOR`, `NONE`, …); offset rules; minimal OnEnter/OnLeave example. |
| [GameTooltip:AddLine](https://warcraft.wiki.gg/wiki/API_GameTooltip_AddLine) | Gold default color; header vs body font; **must Show after AddLine**; visible-tip resize caveat. |
| [Frames & Widgets — better-addons](https://www.better-addons.com/frames-widgets) | Secondary tutorial snippet for button + GameTooltip; note Retail/Midnight bias — verify on Classic. |
| [LibQTip-1.0 (WowAce)](https://www.wowace.com/projects/libqtip-1-0) | Multi-column alternative; **release** tips; V1 Beef likely skips. |
| [LibQTip getting started](https://www.wowace.com/projects/libqtip-1-0/pages/getting-started) | Embed/acquire/release lifecycle if V2 minimap dense tip needs it. |

## Dropdowns & context menus

| URL | Steal / adapt |
|-----|----------------|
| [Using UIDropDownMenu](https://warcraft.wiki.gg/wiki/Using_UIDropDownMenu) | **Primary HOWTO.** Init function, nested `level`, `"MENU"` context mode, `ToggleDropDownMenu`, UX warnings (no scroll, avoid deep trees, avoid SetSelected*). |
| [UIDropDownMenu_AddButton](https://warcraft.wiki.gg/wiki/API_UIDropDownMenu_AddButton) | Full `info` key table; tooltipTitle requirement; Classic-only keys noted on wiki. |
| [EasyMenu](https://warcraft.wiki.gg/wiki/API_EasyMenu) | Table-driven menus; named frame requirement; still stock FrameXML → taint. |
| [LibUIDropDownMenu (WowAce)](https://www.wowace.com/projects/libuidropdownmenu) | **Preferred replacement.** LibStub `LibUIDropDownMenu-4.0` call mapping; embed notes; Classic comments. |
| [LibUIDropDownMenu (CurseForge)](https://www.curseforge.com/wow/addons/libuidropdownmenu) | Flavor files (Classic / TBC Classic); download pinning for Anniversary smoke tests. |
| [NoTaint UIDropDownMenu (WoWInterface)](https://www.wowinterface.com/downloads/fileinfo.php?id=22630) | Historical predecessor pattern (renamed FrameXML). |
| [Townlong Yak — UIDropDownMenu taint](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu) | Why stock menus bite social addons; cite alongside track 29. |
| [AddOn Studio — Using UIDropDownMenu](https://addonstudio.org/wiki/WoW:Using_UIDropDownMenu) | Secondary mirror of HOWTO; nested menu example with `ToggleDropDownMenu`. |

## UnitPopup / right-click world

| URL | Steal / adapt |
|-----|----------------|
| [Classic BlackList UnitPopup grayed items](https://us.forums.blizzard.com/en/wow/t/wow-classic-blacklist-addon/346193) | Evidence UnitPopup injection is painful on Classic — supports “no V1 unit-menu commits.” |
| [UnitPopup_ShowMenu secure (WoWInterface)](https://www.wowinterface.com/forums/showthread.php?t=60000) | Modern secure-menu friction; treat as caution, not Classic how-to. |

## Cross-links inside this library

| URL / path | Steal / adapt |
|------------|----------------|
| [29-taint-secure-ui README](../29-taint-secure-ui/README.md) | Dropdowns/popups called out as social minefield; StaticPopup `preferredIndex = 3`. |
| [Design spec §10–§11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Officer tab actions, hide/no-op gates, guild-chat spectacle. |

## Provenance dumps

| Path | Contents |
|------|----------|
| [.raw/search-gametooltip.json](.raw/search-gametooltip.json) | Parallel search: GameTooltip API |
| [.raw/search-uidropdown.json](.raw/search-uidropdown.json) | Parallel search: LibUIDropDownMenu / taint |
| [.raw/search-context-menus.json](.raw/search-context-menus.json) | Parallel search: EasyMenu / context menus |
| [.raw/search-unitpopup.json](.raw/search-unitpopup.json) | Parallel search: UnitPopup |
| [.raw/search-tooltip-libs.json](.raw/search-tooltip-libs.json) | Parallel search: LibQTip |
| [.raw/extract-wiki-core.json](.raw/extract-wiki-core.json) | Extracted wiki pages (SetOwner, AddButton, Using UIDropDownMenu, GameTooltip, EasyMenu) |
