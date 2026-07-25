# UIDropDownMenu vs LibUIDropDownMenu

**Last updated:** 2026-07-25  
**Track:** [36-tooltips-menus](README.md)

---

## 1. What stock UIDropDownMenu is

FrameXML template `UIDropDownMenuTemplate` drives both:

- **Dropdown list boxes** (settings pickers with a visible current value)
- **Context menus** (`UIDropDownMenu_Initialize(..., "MENU")` + `ToggleDropDownMenu`)

Same init / `info` table / `UIDropDownMenu_AddButton` machinery ([Using UIDropDownMenu](https://warcraft.wiki.gg/wiki/Using_UIDropDownMenu)).

Core APIs:

| API | Role |
|-----|------|
| `UIDropDownMenu_Initialize(frame, initFn [, displayMode])` | Bind builder; `"MENU"` = context chrome |
| `UIDropDownMenu_CreateInfo()` | Recycled info table (prefer over `{}` garbage) |
| `UIDropDownMenu_AddButton(info [, level])` | Append item; **pass `level` for submenus** |
| `ToggleDropDownMenu(1, nil, frame, anchor, x, y)` | Open/close; `"cursor"` for context |
| `CloseDropDownMenus()` | Close all levels |
| `EasyMenu(menuList, menuFrame, …)` | Table-driven shortcut over the same system ([EasyMenu](https://warcraft.wiki.gg/wiki/API_EasyMenu)) |

Frame **must be named** for dropdowns to work ([EasyMenu details](https://warcraft.wiki.gg/wiki/API_EasyMenu); [Using UIDropDownMenu](https://warcraft.wiki.gg/wiki/Using_UIDropDownMenu)).

### Info-table keys Beef would actually use

From [UIDropDownMenu_AddButton](https://warcraft.wiki.gg/wiki/API_UIDropDownMenu_AddButton):

| Key | Role |
|-----|------|
| `text` | Required label |
| `func` / `arg1` / `arg2` | Click handler |
| `disabled` / `isTitle` / `notCheckable` | Structure |
| `hasArrow` / `menuList` | Nested levels |
| `checked` | Current selection |
| `tooltipTitle` (+ `tooltipText`) | Hover help on menu rows (title required or tip fails) |
| `keepShownOnClick` | Multi-toggle menus |

Wiki advice: avoid deep nested config trees; avoid `UIDropDownMenu_SetSelected*` families — prefer `info.checked` + `UIDropDownMenu_SetText` ([Using UIDropDownMenu — General advice](https://warcraft.wiki.gg/wiki/Using_UIDropDownMenu)). No scrolling: too many items → clipped / unreachable.

---

## 2. Why stock is dangerous for addons

Stock globals / frames are shared with Blizzard UI and use protected paths. Third-party use has a long history of **tainting** Blizzard dropdowns (unit menus, bags, etc.) until `/reload` ([LibUIDropDownMenu About](https://www.wowace.com/projects/libuidropdownmenu); [Townlong Yak UIDropDownMenu bug](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu); [track 29 README](../29-taint-secure-ui/README.md)).

`EasyMenu` is not safer — it is a thin wrapper that still calls `UIDropDownMenu_Initialize` on your frame ([EasyMenu](https://warcraft.wiki.gg/wiki/API_EasyMenu)).

**Beef stance (aligned with track 29):** do not call stock `UIDropDownMenu_*` / `EasyMenu` / `ToggleDropDownMenu` from Church of Beef.

---

## 3. LibUIDropDownMenu-4.0

[LibUIDropDownMenu](https://www.wowace.com/projects/libuidropdownmenu) (also [CurseForge](https://www.curseforge.com/wow/addons/libuidropdownmenu)) is a LibStub library that ships renamed copies of FrameXML dropdown / EasyMenu code so addon menus do not share Blizzard’s protected frames.

| Stock | Library |
|-------|---------|
| `UIDropDownMenu_Initialize` | `LibDD:UIDropDownMenu_Initialize` |
| `UIDropDownMenu_CreateInfo` | `LibDD:UIDropDownMenu_CreateInfo` |
| `UIDropDownMenu_AddButton` | `LibDD:UIDropDownMenu_AddButton` |
| `CloseDropDownMenus` | `LibDD:CloseDropDownMenus` |
| `CreateFrame(..., "UIDropDownMenuTemplate")` | `LibDD:Create_UIDropDownMenu(name, parent)` |
| Constants `UIDROPDOWNMENU_*` | Prefixed `L_UIDROPDOWNMENU_*` |

Prep:

```lua
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
```

Embed `LibUIDropDownMenu.xml`; depend on LibStub / `!LibUIDropDownMenu` as documented ([WowAce project page](https://www.wowace.com/projects/libuidropdownmenu)).

### Classic / TBC notes

- CurseForge lists **Classic** and **Classic TBC** file flavors; last release snapshot in research dump: **v4.26** (Feb 2024) ([CurseForge](https://www.curseforge.com/wow/addons/libuidropdownmenu)).
- Community comments: some 4.22 builds broke Era/Wrath embeds; TBC Classic needed BackdropTemplate fixes historically ([WowAce comments](https://www.wowace.com/projects/libuidropdownmenu)). **Pin and smoke-test on Anniversary (`Interface` 20506) before shipping.**
- Predecessor: NoTaint UIDropDownMenu ([WoWInterface](https://www.wowinterface.com/downloads/fileinfo.php?id=22630)) — same idea; LibUIDropDownMenu-4.0 is the maintained LibStub form.

---

## 4. AceGUI / options alternative

If Beef already embeds Ace3 for options (track 03), **AceGUI dropdown widgets** avoid hand-rolling UIDropDownMenu for settings. For in-frame Officer filters (e.g. “pending only”), either:

- AceGUI dropdown inside the Beef window, or
- LibUIDropDownMenu for a Classic-native looking picker

Do not mix stock FrameXML dropdowns “just for one filter.”

---

## 5. Decision matrix for Beef

| UI need | Prefer | Avoid |
|---------|--------|-------|
| Settings enum (V2 options) | AceConfig / AceGUI | Stock UIDropDownMenu |
| In-panel filter (Officer queue) | LibUIDropDownMenu or AceGUI | Stock EasyMenu |
| Right-click on Beef row | LibUIDropDownMenu `"MENU"` mode | Stock EasyMenu; UnitPopup |
| Confirm approve/demote | StaticPopup / Ace dialog | Dropdown item as sole confirm |

Taint deep-dive remains in [29-taint-secure-ui](../29-taint-secure-ui/).
