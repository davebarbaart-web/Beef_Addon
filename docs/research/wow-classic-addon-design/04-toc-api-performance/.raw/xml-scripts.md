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

# <Scripts>

From Warcraft Wiki

< [XML](https://warcraft.wiki.gg/wiki/XML "XML")

[Jump to navigation](https://warcraft.wiki.gg/wiki/XML/Scripts#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/XML/Scripts#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

**Lua error in Module:Wowapi/category at line 20: attempt to index local 'data' (a nil value).**

|     |     |
| --- | --- |
| ![Fat cat yearns for the mines](https://warcraft.wiki.gg/images/thumb/Fatcat_miner.png/64px-Fatcat_miner.png?82abc0) | The API wiki is under maintenance<br>Since `2026-07-23T06:08:00Z`, ETA: at least multiple days |

<Scripts> (child of [Frame](https://warcraft.wiki.gg/wiki/XML/Frame "XML/Frame"), [AnimationGroup](https://warcraft.wiki.gg/wiki/XML/AnimationGroup "XML/AnimationGroup") or [Animation](https://warcraft.wiki.gg/wiki/XML/Animation "XML/Animation")) contains [widget script handlers](https://warcraft.wiki.gg/wiki/Widget_script_handlers "Widget script handlers") such as <OnLoad> or <OnUpdate>.

```
<Scripts>
 	<OnLoad function="" />
 	<OnUpdate>
 		<!-- Lua code -->
 	</OnUpdate>
 	<!-- See [[widget script handlers]] for the full list -->
</Scripts>
```

Copy

## Contents

- [1Child elements](https://warcraft.wiki.gg/wiki/XML/Scripts#Child_elements)
- [2Patch changes](https://warcraft.wiki.gg/wiki/XML/Scripts#Patch_changes)
- [3See also](https://warcraft.wiki.gg/wiki/XML/Scripts#See_also)
- [4References](https://warcraft.wiki.gg/wiki/XML/Scripts#References)

## Child elements

Each widget script may enclose Lua code between the tags.

| Name | Type | Default | Comment |
| --- | --- | --- | --- |
| function | xs:string? |  | Name of a function instead of Lua code between the XML tags |
| method | xs:string? |  | Name of a widget method instead of Lua code between the XML tags |
| inherit | [ui:SCRIPTINHERITTYPE](https://warcraft.wiki.gg/wiki/Ui:SCRIPTINHERITTYPE "Ui:SCRIPTINHERITTYPE")? | none | Hooks (`prepend`, `append`) other scripts inherited through an XML virtual template |
| intrinsicOrder | [ui:SCRIPTINTRINSICORDERTYPE](https://warcraft.wiki.gg/wiki/Ui:SCRIPTINTRINSICORDERTYPE "Ui:SCRIPTINTRINSICORDERTYPE")? | none | Hooks (`precall`, `postcall`) other scripts when copied as an [intrinsic frame](https://warcraft.wiki.gg/wiki/Intrinsic_frame "Intrinsic frame") |
| autoEnableInput | xs:boolean? | true |  |

## Patch changes

- [![Legion](https://warcraft.wiki.gg/images/Legion-Logo-Small.png?7a5440)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Legion "Legion")**[Patch 7.3.0](https://warcraft.wiki.gg/wiki/Patch_7.3.0/API_changes "Patch 7.3.0/API changes") (2017-08-29):** Attribute _autoEnableInput_ added.[\[1\]](https://warcraft.wiki.gg/wiki/XML/Scripts#cite_note-1)

- [![Legion](https://warcraft.wiki.gg/images/Legion-Logo-Small.png?7a5440)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Legion "Legion")**[Patch 7.1.0](https://warcraft.wiki.gg/wiki/Patch_7.1.0/API_changes "Patch 7.1.0/API changes") (2016-10-25):** Attribute _intrinsicOrder_ added.[\[2\]](https://warcraft.wiki.gg/wiki/XML/Scripts#cite_note-2)

- [![Legion](https://warcraft.wiki.gg/images/Legion-Logo-Small.png?7a5440)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Legion "Legion")**[Patch 7.0.3](https://warcraft.wiki.gg/wiki/Patch_7.0.3/API_changes "Patch 7.0.3/API changes") (2016-07-19):** Attribute _method_ added.[\[3\]](https://warcraft.wiki.gg/wiki/XML/Scripts#cite_note-3)

- [![Warlords of Draenor](https://warcraft.wiki.gg/images/WoD-Logo-Small.png?be5b60)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Warlords_of_Draenor "Warlords of Draenor")**[Patch 6.1.0](https://warcraft.wiki.gg/wiki/Patch_6.1.0/API_changes "Patch 6.1.0/API changes") (2015-02-24):** Attribute _inherit_ added.[\[4\]](https://warcraft.wiki.gg/wiki/XML/Scripts#cite_note-4)


## See also

- [ScriptObject](https://warcraft.wiki.gg/wiki/UIOBJECT_ScriptObject "UIOBJECT ScriptObject")

## References

1. [^](https://warcraft.wiki.gg/wiki/XML/Scripts#cite_ref-1) 2017-08-28,  UI.xsd, [version 7.3.0.24920](https://www.townlong-yak.com/framexml/24920/UI.xsd#351), near line 351, archived at Townlong-Yak
2. [^](https://warcraft.wiki.gg/wiki/XML/Scripts#cite_ref-2) 2016-10-25,  UI.xsd, [version 7.1.0.22908](https://www.townlong-yak.com/framexml/22908/UI.xsd#117), near line 117, archived at Townlong-Yak
3. [^](https://warcraft.wiki.gg/wiki/XML/Scripts#cite_ref-3) 2016-07-19,  UI.xsd, [version 7.0.3.22267](https://www.townlong-yak.com/framexml/22267/UI.xsd#350), near line 350, archived at Townlong-Yak
4. [^](https://warcraft.wiki.gg/wiki/XML/Scripts#cite_ref-4) 2015-02-26,  UI.xsd, [version 6.1.0.19702](https://www.townlong-yak.com/framexml/19702/UI.xsd#109), near line 109, archived at Townlong-Yak

Retrieved from " [https://warcraft.wiki.gg/wiki/XML/Scripts?oldid=6769820](https://warcraft.wiki.gg/wiki/XML/Scripts?oldid=6769820)"

[Category](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [XML elements](https://warcraft.wiki.gg/wiki/Category:XML_elements "Category:XML elements")

Hidden category:

- [Pages with script errors](https://warcraft.wiki.gg/wiki/Category:Pages_with_script_errors "Category:Pages with script errors")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK