## Navigation menu

### Namespaces

English

### Views

More

### Search

[Visit the main page](https://warcraft.wiki.gg/ "Visit the main page")

### Navigation

### Wiki community

### World of Warcraft

### Franchise

### Useful pages

### Lore

### Tools

# CreateFrame

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/API_CreateFrame#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/API_CreateFrame#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

**Lua error in Module:Wowapi/category at line 21: bad argument #2 to 'format' (string expected, got nil).**

|     |     |
| --- | --- |
| ![Fat cat yearns for the mines](https://warcraft.wiki.gg/images/thumb/Fatcat_miner.png/64px-Fatcat_miner.png?82abc0) | The API wiki is under maintenance<br>Since `2026-07-23T06:08:00Z`, ETA: at least multiple days |

Creates a [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame "UIOBJECT Frame") object.

```
frame = CreateFrame(frameType [, name [, parent [, template [, id]]]])
```

## Contents

- [1Arguments](https://warcraft.wiki.gg/wiki/API_CreateFrame#Arguments)
- [2Returns](https://warcraft.wiki.gg/wiki/API_CreateFrame#Returns)
- [3Frame types](https://warcraft.wiki.gg/wiki/API_CreateFrame#Frame_types)
- [4Details](https://warcraft.wiki.gg/wiki/API_CreateFrame#Details)
- [5Example](https://warcraft.wiki.gg/wiki/API_CreateFrame#Example)
- [6Patch changes](https://warcraft.wiki.gg/wiki/API_CreateFrame#Patch_changes)
- [7See also](https://warcraft.wiki.gg/wiki/API_CreateFrame#See_also)
- [8References](https://warcraft.wiki.gg/wiki/API_CreateFrame#References)

## Arguments

frameTypestring \- Type of the frame; e.g. "Frame" or "Button".namestring? \- Globally accessible name to assign to the frame, or `nil` for an anonymous frame.parent[Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame "UIOBJECT Frame")? \- Parent object to assign to the frame, or `nil` to be parentless; cannot be a string. Can also be set with [Region:SetParent](https://warcraft.wiki.gg/wiki/API_Region_SetParent "API Region SetParent")()templatestring? \- Comma-delimited list of [virtual XML templates](https://warcraft.wiki.gg/wiki/Virtual_XML_template "Virtual XML template") to inherit; see also a [complete list](https://github.com/Ketho/BlizzardInterfaceResources/blob/live/Resources/Templates.lua) of FrameXML templates.idnumber? \- ID to assign to the frame. Can also be set with [Frame:SetID](https://warcraft.wiki.gg/wiki/API_Frame_SetID "API Frame SetID")()

## Returns

frame[Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame "UIOBJECT Frame") \- The created Frame object or one of the other frame type objects.

## Frame types

Possible frame types are available from the [XML schema](https://warcraft.wiki.gg/wiki/XML_schema "XML schema") ( [UI.xsd](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_SharedXML/UI.xsd))

|     |     |
| --- | --- |
| - [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame "UIOBJECT Frame")<br>- ArchaeologyDigSiteFrame<br>- Browser<br>- [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button "UIOBJECT Button")<br>- [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton "UIOBJECT CheckButton")<br>- Checkout<br>- [CinematicModel](https://warcraft.wiki.gg/wiki/UIOBJECT_CinematicModel "UIOBJECT CinematicModel")<br>- [ColorSelect](https://warcraft.wiki.gg/wiki/UIOBJECT_ColorSelect "UIOBJECT ColorSelect")<br>- [Cooldown](https://warcraft.wiki.gg/wiki/UIOBJECT_Cooldown "UIOBJECT Cooldown")<br>- [DressUpModel](https://warcraft.wiki.gg/wiki/UIOBJECT_DressUpModel "UIOBJECT DressUpModel")<br>- [EditBox](https://warcraft.wiki.gg/wiki/UIOBJECT_EditBox "UIOBJECT EditBox")<br>- FogOfWarFrame<br>- [GameTooltip](https://warcraft.wiki.gg/wiki/UIOBJECT_GameTooltip "UIOBJECT GameTooltip")<br>- [MessageFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_MessageFrame "UIOBJECT MessageFrame") | - [Model](https://warcraft.wiki.gg/wiki/UIOBJECT_Model "UIOBJECT Model")<br>- [ModelScene](https://warcraft.wiki.gg/wiki/UIOBJECT_ModelScene "UIOBJECT ModelScene")<br>- [MovieFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_MovieFrame "UIOBJECT MovieFrame")<br>- [OffScreenFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_OffScreenFrame "UIOBJECT OffScreenFrame")<br>- [PlayerModel](https://warcraft.wiki.gg/wiki/UIOBJECT_PlayerModel "UIOBJECT PlayerModel")<br>- QuestPOIFrame<br>- ScenarioPOIFrame<br>- [ScrollFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame "UIOBJECT ScrollFrame")<br>- [SimpleHTML](https://warcraft.wiki.gg/wiki/UIOBJECT_SimpleHTML "UIOBJECT SimpleHTML")<br>- [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider "UIOBJECT Slider")<br>- [StatusBar](https://warcraft.wiki.gg/wiki/UIOBJECT_StatusBar "UIOBJECT StatusBar")<br>- [TabardModel](https://warcraft.wiki.gg/wiki/UIOBJECT_TabardModel "UIOBJECT TabardModel")<br>- UnitPositionFrame |

## Details

- Fires the frame's [OnLoad](https://warcraft.wiki.gg/wiki/UIHANDLER_OnLoad "UIHANDLER OnLoad") script, if it has one from an inherited template.
- Frames cannot be deleted or garbage collected, so it may be preferable to [reuse](https://warcraft.wiki.gg/wiki/API_CreateFramePool "API CreateFramePool") them.
- [Intrinsic frames](https://warcraft.wiki.gg/wiki/Intrinsic_frame "Intrinsic frame") may also be used.

## Example

- Shows a texture which is also parented to UIParent so it will be have the same UI scale and hidden when toggled with `Alt-Z`

[![](https://warcraft.wiki.gg/images/API_CreateFrame_mushroom.png?a45734)](https://warcraft.wiki.gg/wiki/File:API_CreateFrame_mushroom.png)

[Enlarge](https://warcraft.wiki.gg/wiki/File:API_CreateFrame_mushroom.png "Enlarge")

[inv\_mushroom\_11](https://github.com/Gethe/wow-ui-textures/blob/live/ICONS/INV_Mushroom_11.PNG)

```
local f = CreateFrame("Frame", nil, UIParent)
f:SetPoint("CENTER")
f:SetSize(64, 64)

f.tex = f:CreateTexture()
f.tex:SetAllPoints(f)
f.tex:SetTexture("interface/icons/inv_mushroom_11")
```

Copy

- Creates a button which inherits textures and widget scripts from [UIPanelButtonTemplate](https://www.townlong-yak.com/framexml/go/UIPanelButtonTemplate)

[![](https://warcraft.wiki.gg/images/Button_Click_me.png?96ae9b)](https://warcraft.wiki.gg/wiki/File:Button_Click_me.png)

[Enlarge](https://warcraft.wiki.gg/wiki/File:Button_Click_me.png "Enlarge")

Click me

```
local btn = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
btn:SetPoint("CENTER")
btn:SetSize(100, 40)
btn:SetText("Click me")
btn:SetScript("OnClick", function(self, button, down)
	print("Pressed", button, down and "down" or "up")
end)
btn:RegisterForClicks("AnyDown", "AnyUp")
```

Copy

- Displays an [animated model](https://wow.tools/mv/?filedataid=125041&type=m2) for a [DisplayID](https://warcraft.wiki.gg/wiki/DisplayID "DisplayID").

```
local m = CreateFrame("PlayerModel")
m:SetPoint("CENTER")
m:SetSize(200, 200)
m:SetDisplayInfo(21723) -- murloccostume.m2
```

Copy

- Registers for events being fired, like chat messages and when you start/stop moving.

```
local function OnEvent(self, event, ...)
	print(event, ...)
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_CHANNEL")
f:RegisterEvent("PLAYER_STARTED_MOVING")
f:RegisterEvent("PLAYER_STOPPED_MOVING")
f:SetScript("OnEvent", OnEvent)
```

Copy

## Patch changes

- [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_The_Burning_Crusade "Burning Crusade")**[Patch 2.0.1](https://warcraft.wiki.gg/wiki/Patch_2.0.1/API_changes "Patch 2.0.1/API changes") (2006-12-05):** The fourth argument, _inheritFrame_, now accepts comma-separated values.

- [![World of Warcraft](https://warcraft.wiki.gg/images/WoW_Icon_update.png?d4be1e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft "World of Warcraft")**[Patch 1.11.0](https://warcraft.wiki.gg/wiki/Patch_1.11.0/API_changes "Patch 1.11.0/API changes") (2006-06-19):** Added fourth argument, _inheritFrame_.[\[1\]](https://warcraft.wiki.gg/wiki/API_CreateFrame#cite_note-1)

- [![World of Warcraft](https://warcraft.wiki.gg/images/WoW_Icon_update.png?d4be1e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft "World of Warcraft")**[Patch 1.10.0](https://warcraft.wiki.gg/wiki/Patch_1.10.0/API_changes "Patch 1.10.0/API changes") (2006-03-28):** Added.[\[2\]](https://warcraft.wiki.gg/wiki/API_CreateFrame#cite_note-2)


## See also

- [CreateFramePool](https://warcraft.wiki.gg/wiki/API_CreateFramePool "API CreateFramePool")()

## References

1. [^](https://warcraft.wiki.gg/wiki/API_CreateFrame#cite_ref-1)[![Blizzard Entertainment](https://warcraft.wiki.gg/images/Blizz.gif?984542)](https://warcraft.wiki.gg/wiki/Blizzard_Entertainment "Blizzard Entertainment")[slouken](https://warcraft.wiki.gg/wiki/Slouken "Slouken") 2006-05-23. [Re: Upcoming 1.11 Changes - Concise List](http://blue.cardplace.com/cache/wow-interface-customization/343889.htm). Archived from [the original](http://forums.worldofwarcraft.com/thread.aspx?fn=wow-interface-customization&t=343889&p=#post382611)
2. [^](https://warcraft.wiki.gg/wiki/API_CreateFrame#cite_ref-2) [Iriel](https://warcraft.wiki.gg/wiki/Iriel "Iriel") 2005-12-28. [Upcoming 1.10 Changes - Concise List](http://blue.cardplace.com/cache/wow-interface-customization/286547.htm). Archived from [the original](http://forums.worldofwarcraft.com/thread.aspx?fn=wow-interface-customization&t=286547&p=#post286547)

Retrieved from " [https://warcraft.wiki.gg/wiki/API\_CreateFrame?oldid=6779954](https://warcraft.wiki.gg/wiki/API_CreateFrame?oldid=6779954)"

Hidden category:

- [Pages with script errors](https://warcraft.wiki.gg/wiki/Category:Pages_with_script_errors "Category:Pages with script errors")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK