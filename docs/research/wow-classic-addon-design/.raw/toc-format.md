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

# TOC format

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/TOC_format#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/TOC_format#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

|     |     |
| --- | --- |
| ![Fat cat yearns for the mines](https://warcraft.wiki.gg/images/thumb/Fatcat_miner.png/64px-Fatcat_miner.png?82abc0) | The API wiki is under maintenance<br>Since `2026-07-23T06:08:00Z`, ETA: at least multiple days |

## Contents

- [1Rules](https://warcraft.wiki.gg/wiki/TOC_format#Rules)
- [2File loading order](https://warcraft.wiki.gg/wiki/TOC_format#File_loading_order)
- [3Interface version](https://warcraft.wiki.gg/wiki/TOC_format#Interface_version)
  - [3.1Determining the interface version](https://warcraft.wiki.gg/wiki/TOC_format#Determining_the_interface_version)
    - [3.1.1GetBuildInfo](https://warcraft.wiki.gg/wiki/TOC_format#GetBuildInfo)
    - [3.1.2Warcraft Wiki](https://warcraft.wiki.gg/wiki/TOC_format#Warcraft_Wiki)
- [4Per-line conditional directives](https://warcraft.wiki.gg/wiki/TOC_format#Per-line_conditional_directives)
- [5Per-file variables](https://warcraft.wiki.gg/wiki/TOC_format#Per-file_variables)
- [6Client-specific TOC files](https://warcraft.wiki.gg/wiki/TOC_format#Client-specific_TOC_files)
- [7AddOns list formatting](https://warcraft.wiki.gg/wiki/TOC_format#AddOns_list_formatting)
  - [7.1Title](https://warcraft.wiki.gg/wiki/TOC_format#Title)
  - [7.2Notes](https://warcraft.wiki.gg/wiki/TOC_format#Notes)
  - [7.3Category](https://warcraft.wiki.gg/wiki/TOC_format#Category)
  - [7.4Group](https://warcraft.wiki.gg/wiki/TOC_format#Group)
  - [7.5IconTexture](https://warcraft.wiki.gg/wiki/TOC_format#IconTexture)
  - [7.6IconAtlas](https://warcraft.wiki.gg/wiki/TOC_format#IconAtlas)
- [8Addon compartment integration](https://warcraft.wiki.gg/wiki/TOC_format#Addon_compartment_integration)
  - [8.1AddonCompartmentFunc](https://warcraft.wiki.gg/wiki/TOC_format#AddonCompartmentFunc)
  - [8.2AddonCompartmentFuncOnEnter](https://warcraft.wiki.gg/wiki/TOC_format#AddonCompartmentFuncOnEnter)
  - [8.3AddonCompartmentFuncOnLeave](https://warcraft.wiki.gg/wiki/TOC_format#AddonCompartmentFuncOnLeave)
- [9Loading conditions](https://warcraft.wiki.gg/wiki/TOC_format#Loading_conditions)
  - [9.1LoadOnDemand](https://warcraft.wiki.gg/wiki/TOC_format#LoadOnDemand)
  - [9.2Dependencies](https://warcraft.wiki.gg/wiki/TOC_format#Dependencies)
  - [9.3OptionalDeps](https://warcraft.wiki.gg/wiki/TOC_format#OptionalDeps)
  - [9.4LoadWith](https://warcraft.wiki.gg/wiki/TOC_format#LoadWith)
  - [9.5LoadManagers](https://warcraft.wiki.gg/wiki/TOC_format#LoadManagers)
  - [9.6AllowLoadGameType](https://warcraft.wiki.gg/wiki/TOC_format#AllowLoadGameType)
  - [9.7OnlyBetaAndPTR](https://warcraft.wiki.gg/wiki/TOC_format#OnlyBetaAndPTR)
  - [9.8DefaultState](https://warcraft.wiki.gg/wiki/TOC_format#DefaultState)
- [10Saved variables](https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables)
  - [10.1LoadSavedVariablesFirst](https://warcraft.wiki.gg/wiki/TOC_format#LoadSavedVariablesFirst)
  - [10.2SavedVariables](https://warcraft.wiki.gg/wiki/TOC_format#SavedVariables)
  - [10.3SavedVariablesPerCharacter](https://warcraft.wiki.gg/wiki/TOC_format#SavedVariablesPerCharacter)
- [11Informational](https://warcraft.wiki.gg/wiki/TOC_format#Informational)
- [12Uncategorized](https://warcraft.wiki.gg/wiki/TOC_format#Uncategorized)
  - [12.1AllowAddOnTableAccess](https://warcraft.wiki.gg/wiki/TOC_format#AllowAddOnTableAccess)
- [13Restricted](https://warcraft.wiki.gg/wiki/TOC_format#Restricted)
  - [13.1AllowLoad](https://warcraft.wiki.gg/wiki/TOC_format#AllowLoad)
  - [13.2EscalateErrorDuringLoad](https://warcraft.wiki.gg/wiki/TOC_format#EscalateErrorDuringLoad)
  - [13.3LoadFirst](https://warcraft.wiki.gg/wiki/TOC_format#LoadFirst)
  - [13.4SavedVariablesMachine](https://warcraft.wiki.gg/wiki/TOC_format#SavedVariablesMachine)
  - [13.5UseSecureEnvironment](https://warcraft.wiki.gg/wiki/TOC_format#UseSecureEnvironment)
- [14Details](https://warcraft.wiki.gg/wiki/TOC_format#Details)
- [15Patch changes](https://warcraft.wiki.gg/wiki/TOC_format#Patch_changes)
  - [15.1Modern](https://warcraft.wiki.gg/wiki/TOC_format#Modern)
  - [15.2Classic Progression](https://warcraft.wiki.gg/wiki/TOC_format#Classic_Progression)
  - [15.3Classic Era](https://warcraft.wiki.gg/wiki/TOC_format#Classic_Era)
  - [15.4Classic Titan Reforged](https://warcraft.wiki.gg/wiki/TOC_format#Classic_Titan_Reforged)
  - [15.5Classic Anniversary](https://warcraft.wiki.gg/wiki/TOC_format#Classic_Anniversary)
- [16See also](https://warcraft.wiki.gg/wiki/TOC_format#See_also)
- [17References](https://warcraft.wiki.gg/wiki/TOC_format#References)

`.toc` files contain information about the addon (e.g. addon name, addon description, addon saved variables). They also specify the loading order for the addon's `.lua` and `.xml` files. A `.toc` file is mandatory for an addon. The filename of the `.toc` file must match the folder it's inside, otherwise the `.toc` file won't load.

## Rules

The `.toc` file and folder name must match. For example `..\Interface\AddOns\MyAddon\MyAddon.toc`

The `.toc` file can optionally have the following elements:

- Metadata as `## Directive: Value`
- Comments as `# this is a comment`
- A list of files as `myFile.xml` or `subfolder\myFile.lua`

Whitespace before `#` will be interpreted as the start of a filename. However, the client trims whitespace around metadata values (after the colon).

Backslashes `\` are recommended instead of forward slashes for paths to prevent issues with `Include` tags.

Example `.toc` file:

```
## Interface: 120007
## Title: MyAddonName
## Notes: Brief description about what MyAddonName does to help people find it
## Version: 1.0.0

# This line is a comment

MyFrame.xml
MyCode.lua
lib\MyCode.lua
anotherfolder\MoreCode.xml
```

Copy

## File loading order

The `.toc` file includes a list of files to be loaded. The files are loaded in order, from top to bottom.

Not every file in your addon must appear in the `.toc` file. This is because `.xml` files can load files using `<Script file="AnotherFile.lua" />` or `<Include file="alsoLoadThis.xml" />`. Also, functions such as `Texture:SetTexture()` and `PlaySoundFile()` can specify image files and sound files contained within the addon folder and subfolders.

## Interface version

"Interface" is the WoW version the addon was made for. WoW uses this number to tell if an addon is out of date.

If an addon has an older interface version than the user's current WoW client version, the addon is classified as out of date. If you don't specify an Interface version, WoW will always treat the addon as out of date.

If the game version is 10.2.7, then the interface version is 100207:

```
## Interface: 100207
```

Copy

For addons that support multiple client flavors with one TOC file, multiple interface versions can be specified delimited by commas:

```
## Interface: 120007, 50504, 38001, 20506, 11509
```

Copy

### Determining the interface version

#### GetBuildInfo

Type `/dump (select(4, GetBuildInfo()))` in the chat box. This example shows the interface version during 9.2.7.

[![Enter the text "/dump select(4, GetBuildInfo())" into the chat window to display the Interface version](https://warcraft.wiki.gg/images/GetBuildInfo-Tutorial.gif?6f5d2c)](https://warcraft.wiki.gg/wiki/File:GetBuildInfo-Tutorial.gif "Demonstration of obtaining the Interface version from the chat window.")

#### Warcraft Wiki

This wiki maintains a template of the [latest interfaces](https://warcraft.wiki.gg/wiki/Template:API_LatestInterface "Template:API LatestInterface") for each game type. A table of its values is shown below (these values are updated by contributors, so they may be out of date).

| Game type | Interface |
| --- | --- |
| [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | Mainline Beta | `120001` |
| [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | Mainline Test | `120100` |
| [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | Mainline | `120007` |
| [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria") | Classic Beta | `50500` |
| [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria") | Classic Test | `50504` |
| [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria") | Classic | `50504` |
| [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria") | Mists Test | `50504` |
| [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria") | Mists | `50504` |
| [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm_Classic "Cataclysm") | Cata | `40402` |
| [![Wrath of the Lich King](https://warcraft.wiki.gg/images/Wrath-Logo-Small.png?6705fd)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Wrath_of_the_Lich_King_Classic "Wrath of the Lich King") | Titan Reforged | `38001` |
| [![Wrath of the Lich King](https://warcraft.wiki.gg/images/Wrath-Logo-Small.png?6705fd)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Wrath_of_the_Lich_King_Classic "Wrath of the Lich King") | Wrath | `30405` |
| [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Burning_Crusade_Classic "Burning Crusade") | TBC Test | `20506` |
| [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Burning_Crusade_Classic "Burning Crusade") | TBC | `20506` |
| [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic") | Vanilla Test | `11508` |
| [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic") | Vanilla | `11509` |

## Per-line conditional directives

TOC files support the use of conditional directives for metadata directive and file reference lines. Conditions take the form \[Directive value...\]. The following conditions are supported:

| Condition | Description | Client version |
| --- | --- | --- |
| \[AllowLoad ...\] | Restricts the metadata or file to in-game or glue screen environments. Functionally inoperable for addons, as only Blizzard code works in the glue screen environment. |  |
| \[AllowLoadGameType ...\] | Restricts the metadata or file to specific game types. Multiple game types are supported, delimited by commas, with the same values used by the AllowLoadGameType directive. | Added for files in 11.1.5. Added for metadata in 12.0.7. |
| \[AllowLoadTextLocale ...\] | Restricts a metadata or file to specific client text locales. Multiple locale names are supported, delimited by commas, using the same four letter locale names as returned by [GetLocale](https://warcraft.wiki.gg/wiki/API_GetLocale "API GetLocale"), eg. "enUS" and "frFR". | Added for files in 11.2.0.61787. Added for metadata in 12.0.7. |

Conditions can appear anywhere in a file reference line, but for reasons of compatibility should generally only ever be used at the end of a line as follows.

```
## Interface: 120007
## Title: My Cool Addon

# This will only be loaded on Mainline.
MainlineOnly.lua [AllowLoadGameType mainline]

# This will only be loaded in Vanilla or TBC.
VanillaOrTBC.lua [AllowLoadGameType vanilla, tbc]

# This will only be loaded under English or French client locales.
EnglishOrFrenchOnly [AllowLoadTextLocale enUS, frFR]
```

Copy

## Per-file variables

TOC files support the use of variable expansions within file references.

Variables of the form \[Variable\] can be used within file references. The following variables are currently supported by the client.

| Variable | Description | Client version |
| --- | --- | --- |
| \[Family\] | Expands out to either Mainline or Classic based upon the current active game type. | Added in 11.1.5 |
| \[Game\] | Expands out to either Standard, Vanilla, TBC, Wrath, Cata, Mists, WoWLabs, or WoWHack based upon the current active game type. | Added in 11.1.5 |
| \[TextLocale\] | Expands out to either enUS, deDE, frFR, etc. based upon the configured text locale of the game client. | Added in 11.2.0.61787 |

```
## Interface: 120007
## Title: My Cool Addon

# This will load "Mainline\File.lua" or "Classic\File.lua"
# as appropriate for the current client.
[Family]\File.lua

# This will load "Standard\File.lua", "Mists\File.lua", "Cata\File.lua", ...
# as appropriate for the current client.
[Game]\File.lua

# This will load "Localization\enUS.lua", "Localization\frFR.lua", ...
# as appropriate for the current client text locale.
Localization\[TextLocale].lua
```

Copy

## Client-specific TOC files

Addons can ship multiple `.toc` files with different filename suffixes tailored for individual clients.[\[1\]](https://warcraft.wiki.gg/wiki/TOC_format#cite_note-WoWUIBug#68-1) The WoW client first searches for the special file names as shown below, and if none are found, uses `AddonName.toc`

Note that comma-delimited interface versions or per-file conditional loading directives should be preferred over the use of client-specific TOC files where possible.

| Game Type | Expansion/Mode | Suffix |
| --- | --- | --- |
| `standard` | [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | [Midnight](https://warcraft.wiki.gg/wiki/Midnight "Midnight") excluding [Plunderstorm](https://warcraft.wiki.gg/wiki/Plunderstorm "Plunderstorm") | `AddonName_Standard.toc` |
| `mists` | [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria") | [Mists of Pandaria Classic](https://warcraft.wiki.gg/wiki/Mists_of_Pandaria_Classic "Mists of Pandaria Classic") | `AddonName_Mists.toc` |
| `cata` | [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm_Classic "Cataclysm") | [Cataclysm Classic](https://warcraft.wiki.gg/wiki/Cataclysm_Classic "Cataclysm Classic") | `AddonName_Cata.toc` |
| `wrath` | [![Wrath of the Lich King](https://warcraft.wiki.gg/images/Wrath-Logo-Small.png?6705fd)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Wrath_of_the_Lich_King_Classic "Wrath of the Lich King") | [Wrath of the Lich King Classic](https://warcraft.wiki.gg/wiki/Wrath_of_the_Lich_King_Classic "Wrath of the Lich King Classic") and [Titan Reforged](https://warcraft.wiki.gg/wiki/Titan_Reforged "Titan Reforged") | `AddonName_Wrath.toc` |
| `tbc` | [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Burning_Crusade_Classic "Burning Crusade") | Burning Crusade [Classic](https://warcraft.wiki.gg/wiki/Burning_Crusade_Classic "Burning Crusade Classic") & [Classic Anniversary Edition](https://warcraft.wiki.gg/wiki/Burning_Crusade_Classic_Anniversary_Edition "Burning Crusade Classic Anniversary Edition") | `AddonName_TBC.toc` |
| `vanilla` | [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic") | [World of Warcraft Classic](https://warcraft.wiki.gg/wiki/World_of_Warcraft_Classic "World of Warcraft Classic") | `AddonName_Vanilla.toc` |
| `plunderstorm` | [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | [Plunderstorm](https://warcraft.wiki.gg/wiki/Plunderstorm "Plunderstorm") | `AddonName_WoWLabs.toc` |
| `wowhack` | [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | Unknown | `AddonName_WoWHack.toc` |
| `mainline` | [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | [Midnight](https://warcraft.wiki.gg/wiki/Midnight "Midnight") including [Plunderstorm](https://warcraft.wiki.gg/wiki/Plunderstorm "Plunderstorm") and the unknown mode | `AddonName_Mainline.toc` |
| `classic` |  | All [Classic](https://warcraft.wiki.gg/wiki/Classic "Classic") expansions | `AddonName_Classic.toc` |

- Clients also recognize legacy suffixes `-WOTLKC` and `-BCC`.
- The `_Mainline` and `_Classic` suffixes have a lower priority than other suffixes that target specific expasions/modes. For example, having both a `_Cata.toc` and `_Classic.toc` file will result in the former being used on Cataclysm Classic clients, and the latter in all other Classic clients.

## AddOns list formatting

The following directives change how an AddOn appears in the AddOns list. Both may be coloured using [UI escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences") (e.g. `|c########|r`), or [localized](https://warcraft.wiki.gg/wiki/Localization "Localization") by appending a hyphen and the locale code (e.g.`Title-enGB`). Later entries overwrite earlier ones, so the non-localized fallback should go first.

### Title

Name displayed in the AddOns list.

```
## Title: Waiting for Godot
## Title-frFR: En attendant Godot
```

Copy

### Notes

Tooltip displayed in the AddOns list.

```
## Notes: This word is |cFFFF0000red|r
```

Copy

### Category

Category name displayed in the AddOns list, displayed as a collapsible header entry.

It is **strongly recommended** that you stick to the translated category names found on the [Addon Categories](https://warcraft.wiki.gg/wiki/Addon_Categories "Addon Categories") page. This will ensure that your addon is consistently located with other addons in the same category across all locales.

```
## Category: This is a test
## Category-deDE: Dies ist ein Test
```

Copy

### Group

Addon used for grouping entries together in the AddOns list.

- The Group value must be the name of the main addon.
- Grouped addons are displayed in the addon list as indented sub-lists. These lists cannot be collapsed, unlike Categories.
  - Nested groups are not supported by the addon list.
- If no Group has been manually specified, the client will attempt to automatically deduce membership of a group.
  - Installed addons will be scanned to locate pairs of addons where the base name of one addon is a complete prefix of another, and where any form of dependency relation exists between the two in either direction.

```
## Group: FooAuras
```

Copy

### IconTexture

Path to a texture file to be shown as the icon for this addon in the addon list. Optional.

```
## IconTexture: Interface\Icons\TEMP
```

Copy

### IconAtlas

Name of a texture atlas to be shown as the icon for this addon in the addon list. Optional, and has a lower priority than IconTexture if both are set.

```
## IconAtlas: TaskPOI-Icon
```

Copy

## Addon compartment integration

[![Dragonflight](https://warcraft.wiki.gg/images/thumb/Dragonflight-Icon-Inline.png/48px-Dragonflight-Icon-Inline.png?be4c0e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Dragonflight "Dragonflight") The following directives will control the registration of the addon into the [Addon compartment](https://warcraft.wiki.gg/wiki/Addon_compartment "Addon compartment") dropdown accessible from the minimap.

### AddonCompartmentFunc

Name of a global function to be executed when the dropdown list button for this addon has been clicked. This field is required to have the addon be shown in the Addon Compartment list.

```
## AddonCompartmentFunc: MyAddon_OnAddonCompartmentClick
```

Copy

### AddonCompartmentFuncOnEnter

Name of a global function to be executed when this dropdown list button for this addon has been highlighted. Optional.

```
## AddonCompartmentFuncOnEnter: MyAddon_OnAddonCompartmentEnter
```

Copy

### AddonCompartmentFuncOnLeave

Name of a global function to be executed when this dropdown list button for this addon is no longer highlighted. Optional.

```
## AddonCompartmentFuncOnLeave: MyAddon_OnAddonCompartmentLeave
```

Copy

## Loading conditions

The following directives control when an AddOn loads, and any dependencies that must or may load first.

### LoadOnDemand

`1` to delay loading until `LoadAddOn()`.

```
## LoadOnDemand: 1
```

Copy

### Dependencies

AddOns that must load first. Aliases include `RequiredDeps` and any word beginning with `Dep`.

```
## Dependencies: someAddOn, someOtherAddOn
```

Copy

### OptionalDeps

AddOns that should load first if available.

```
## OptionalDeps: someAddOn, someOtherAddOn
```

Copy

### LoadWith

AddOns that, once loaded, trigger this one to load. Implies _LoadOnDemand_.

```
## LoadWith: someAddOn, someOtherAddOn
```

Copy

### LoadManagers

AddOns that, if present, trigger this one to behave as _LoadOnDemand_. See [AddonLoader](https://warcraft.wiki.gg/wiki/AddonLoader "AddonLoader") for an example.

```
## LoadManagers: someAddOn, someOtherAddOn
```

Copy

### AllowLoadGameType

Restricts loading this addon to specific client flavors. Multiple values may be supplied, delimited by commas. Note that game modes may be restricted to disallow loading of insecure addons.

| Game Type | Expansion/Mode |
| --- | --- |
| `standard` | [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | [Midnight](https://warcraft.wiki.gg/wiki/Midnight "Midnight") excluding [Plunderstorm](https://warcraft.wiki.gg/wiki/Plunderstorm "Plunderstorm") |
| `mists` | [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria") | [Mists of Pandaria Classic](https://warcraft.wiki.gg/wiki/Mists_of_Pandaria_Classic "Mists of Pandaria Classic") |
| `cata` | [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm_Classic "Cataclysm") | [Cataclysm Classic](https://warcraft.wiki.gg/wiki/Cataclysm_Classic "Cataclysm Classic") |
| `wrath` | [![Wrath of the Lich King](https://warcraft.wiki.gg/images/Wrath-Logo-Small.png?6705fd)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Wrath_of_the_Lich_King_Classic "Wrath of the Lich King") | [Wrath of the Lich King Classic](https://warcraft.wiki.gg/wiki/Wrath_of_the_Lich_King_Classic "Wrath of the Lich King Classic") and [Titan Reforged](https://warcraft.wiki.gg/wiki/Titan_Reforged "Titan Reforged") |
| `tbc` | [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Burning_Crusade_Classic "Burning Crusade") | Burning Crusade [Classic](https://warcraft.wiki.gg/wiki/Burning_Crusade_Classic "Burning Crusade Classic") and [Classic Anniversary Edition](https://warcraft.wiki.gg/wiki/Burning_Crusade_Classic_Anniversary_Edition "Burning Crusade Classic Anniversary Edition") |
| `vanilla` | [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic") | [World of Warcraft Classic](https://warcraft.wiki.gg/wiki/World_of_Warcraft_Classic "World of Warcraft Classic") |
| `plunderstorm` | [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | [Plunderstorm](https://warcraft.wiki.gg/wiki/Plunderstorm "Plunderstorm") |
| `wowhack` | [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | Unknown |
| `mainline` | [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/36px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight") | [Midnight](https://warcraft.wiki.gg/wiki/Midnight "Midnight") including [Plunderstorm](https://warcraft.wiki.gg/wiki/Plunderstorm "Plunderstorm") and the unknown mode |
| `classic` |  | All [Classic](https://warcraft.wiki.gg/wiki/Classic "Classic") expansions |

### OnlyBetaAndPTR

`1` if an addon should only be loadable in Beta or PTR clients.

```
## OnlyBetaAndPTR: 1
```

Copy

### DefaultState

`disabled` to require the user to explicitly enable the AddOn in the AddOns list.

```
## DefaultState: disabled
```

Copy

## Saved variables

_Main article: [Saving variables between game sessions](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions "Saving variables between game sessions")_

### LoadSavedVariablesFirst

`1` if SavedVariables file(s) should be loaded before all script files for this addon.

### SavedVariables

Variables saved in `WTF/[account]/SavedVariables`.

```
## SavedVariables: MyAddOnNameFoo, MyAddOnNameBar
```

Copy

### SavedVariablesPerCharacter

Variables saved in `WTF/[account]/[server]/[character]/SavedVariables`.

```
## SavedVariablesPerCharacter: MyAddOnNameAnotherVariable
```

Copy

## Informational

The following metadata may be accessed using [GetAddOnMetadata](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata "API GetAddOnMetadata")().

AuthorThe AddOn author's name, displayedVersionThe AddOn version. Some automatic updating tools may prefer that this string begins with a numeric version number.X-\_\_\_\_\_Any custom metadata prefixed by "X-", such as "X-Date", "X-Website" or "X-Feedback"

## Uncategorized

### AllowAddOnTableAccess

`1` to allow the retrieval of the [namespace table](https://warcraft.wiki.gg/wiki/Using_the_AddOn_namespace "Using the AddOn namespace") of this addon via [C\_AddOns.GetAddOnLocalTable](https://warcraft.wiki.gg/wiki/API_C_AddOns.GetAddOnLocalTable "API C AddOns.GetAddOnLocalTable").

```
## AllowAddOnTableAccess: 1
```

Copy

## Restricted

The following tags are inaccessible to third-party AddOns.

### AllowLoad

Restricts loading this addon to either the [GlueXML](https://warcraft.wiki.gg/wiki/API_IsOnGlueScreen "API IsOnGlueScreen") or [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML "FrameXML") environments.

| Value | Environment |
| --- | --- |
| `Both` | Allow this addon to load without restriction in all environments. |
| `Game` | Only load this addon in the FrameXML environment. |
| `Glue` | Only load this addon in the GlueXML environment. |

### EscalateErrorDuringLoad

Boolean directive that appears to have no effect in public clients.

### LoadFirst

`1` if a secure addon is not permitted to be disabled and should be loaded before any other addons without this flag.

### SavedVariablesMachine

List of global variable names to be persisted across all accounts on the same machine.

### UseSecureEnvironment

`1` if all files present in an addon should be loaded into a private function environment.

## Details

- WoW reads up to the first 1024 characters of each line only. Additional characters are ignored and do not cause an error.
- Newly created/added files and even complete addons are detected when doing a `/reload` after the game has started.

## Patch changes

### Modern

- [![Midnight](https://warcraft.wiki.gg/images/thumb/Midnight-Petopia-Logo.png/40px-Midnight-Petopia-Logo.png?28a8f3)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Midnight "Midnight")**[Patch 12.0.7](https://warcraft.wiki.gg/wiki/Patch_12.0.7/API_changes "Patch 12.0.7/API changes") (2026-06-16):** Added support for per-metadata conditional directives.

- [![The War Within](https://warcraft.wiki.gg/images/thumb/TheWarWithin-Petopia-Logo.png/40px-TheWarWithin-Petopia-Logo.png?c7c8d5)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_The_War_Within "The War Within")**[Patch 11.2.0](https://warcraft.wiki.gg/wiki/Patch_11.2.0/API_changes "Patch 11.2.0/API changes") (2025-08-05):** Added the inline `TextLocale` variable and `AllowLoadTextLocale` conditional directive.

- [![The War Within](https://warcraft.wiki.gg/images/thumb/TheWarWithin-Petopia-Logo.png/40px-TheWarWithin-Petopia-Logo.png?c7c8d5)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_The_War_Within "The War Within")**[Patch 11.1.7](https://warcraft.wiki.gg/wiki/Patch_11.1.7/API_changes "Patch 11.1.7/API changes") (2025-06-17):** Added the `AllowAddOnTableAccess` field.

- [![The War Within](https://warcraft.wiki.gg/images/thumb/TheWarWithin-Petopia-Logo.png/40px-TheWarWithin-Petopia-Logo.png?c7c8d5)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_The_War_Within "The War Within")**[Patch 11.1.5](https://warcraft.wiki.gg/wiki/Patch_11.1.5/API_changes "Patch 11.1.5/API changes") (2025-04-22):**
  - Added support for per-file conditional directives and variables.
  - Added the `LoadSavedVariablesFirst` field.
  - `AllowLoadGameType` is now usable by insecure addons.
- [![The War Within](https://warcraft.wiki.gg/images/thumb/TheWarWithin-Petopia-Logo.png/40px-TheWarWithin-Petopia-Logo.png?c7c8d5)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_The_War_Within "The War Within")**[Patch 11.1.0](https://warcraft.wiki.gg/wiki/Patch_11.1.0/API_changes "Patch 11.1.0/API changes") (2025-02-25):** Added the `Category` and `Group` fields.

- [![The War Within](https://warcraft.wiki.gg/images/thumb/TheWarWithin-Petopia-Logo.png/40px-TheWarWithin-Petopia-Logo.png?c7c8d5)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_The_War_Within "The War Within")**[Patch 11.0.0](https://warcraft.wiki.gg/wiki/Patch_11.0.0/API_changes "Patch 11.0.0/API changes") (2024-07-23):**
  - Added the restricted `UseSecureEnvironment` metadata field.
  - Removed the `SuppressLocalTableRef` metadata field.
- [![Dragonflight](https://warcraft.wiki.gg/images/thumb/Dragonflight-Icon-Inline.png/48px-Dragonflight-Icon-Inline.png?be4c0e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Dragonflight "Dragonflight")**[Patch 10.2.7](https://warcraft.wiki.gg/wiki/Patch_10.2.7/API_changes "Patch 10.2.7/API changes") (2024-05-07):**
  - Added support for comma-delimited `Interface` versions.
  - Added the restricted `SuppressLocalTableRef` metadata field.
  - Renamed `AllowLoadByGameMode` to `AllowLoadGameType`, and `GuardedAddOn` to `LoadFirst`.
- [![Dragonflight](https://warcraft.wiki.gg/images/thumb/Dragonflight-Icon-Inline.png/48px-Dragonflight-Icon-Inline.png?be4c0e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Dragonflight "Dragonflight")**[Patch 10.2.6](https://warcraft.wiki.gg/wiki/Patch_10.2.6/API_changes "Patch 10.2.6/API changes") (2024-03-19):** Added the restricted `AllowLoadByGameMode` metadata field.

- [![Dragonflight](https://warcraft.wiki.gg/images/thumb/Dragonflight-Icon-Inline.png/48px-Dragonflight-Icon-Inline.png?be4c0e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Dragonflight "Dragonflight")**[Patch 10.1.0](https://warcraft.wiki.gg/wiki/Patch_10.1.0/API_changes "Patch 10.1.0/API changes") (2023-05-02):**
  - Added `IconAtlas`, `IconTexture`, and [Addon compartment](https://warcraft.wiki.gg/wiki/Addon_compartment "Addon compartment") related metadata fields.
  - Added the restricted `GuardedAddOn` metadata field.
- [![Shadowlands](https://warcraft.wiki.gg/images/thumb/Shadowlands-Icon-Inline.png/48px-Shadowlands-Icon-Inline.png?d84a63)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Shadowlands "Shadowlands")**[Patch 9.1.0](https://warcraft.wiki.gg/wiki/Patch_9.1.0/API_changes "Patch 9.1.0/API changes") (2021-06-29):** Multiple TOC files are now supported using a suffix to disambiguate Classic, BCC and Retail.[\[1\]](https://warcraft.wiki.gg/wiki/TOC_format#cite_note-WoWUIBug#68-1)

- [![Shadowlands](https://warcraft.wiki.gg/images/thumb/Shadowlands-Icon-Inline.png/48px-Shadowlands-Icon-Inline.png?d84a63)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Shadowlands "Shadowlands")**[Patch 9.0.1](https://warcraft.wiki.gg/wiki/Patch_9.0.1/API_changes "Patch 9.0.1/API changes") (2020-10-13):**`/reload` recognizes changes to TOC metadata and entirely new files in the `Interface/AddOns/` directory tree.

- [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm "Cataclysm")**[Patch 4.0.1](https://warcraft.wiki.gg/wiki/Patch_4.0.1/API_changes "Patch 4.0.1/API changes") (2010-10-12):**`/reload` recognizes changes to the file order.

- [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_The_Burning_Crusade "Burning Crusade")**[Patch 2.1.0](https://warcraft.wiki.gg/wiki/Patch_2.1.0/API_changes "Patch 2.1.0/API changes") (2007-05-22):** Added the `LoadManagers` metadata field.

- [![World of Warcraft](https://warcraft.wiki.gg/images/WoW_Icon_update.png?d4be1e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft "World of Warcraft")**[Patch 1.11.0](https://warcraft.wiki.gg/wiki/Patch_1.11.0/API_changes "Patch 1.11.0/API changes") (2006-06-19):** Added the `Secure` metadata field.

- [![World of Warcraft](https://warcraft.wiki.gg/images/WoW_Icon_update.png?d4be1e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft "World of Warcraft")**[Patch 1.9.0](https://warcraft.wiki.gg/wiki/Patch_1.9.0/API_changes "Patch 1.9.0/API changes") (2006-01-03):** Added the `LoadWith` metadata field.


### Classic Progression

- [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria")**[Patch 5.5.1](https://warcraft.wiki.gg/wiki/Patch_5.5.1/API_changes "Patch 5.5.1/API changes") (2025-09-23):** Includes all Modern changes up to 11.2.0.

- [![Mists of Pandaria](https://warcraft.wiki.gg/images/Mists-Logo-Small.png?f96b23)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Mists_of_Pandaria_Classic "Mists of Pandaria")**[Patch 5.5.0](https://warcraft.wiki.gg/wiki/Patch_5.5.0/API_changes "Patch 5.5.0/API changes") (2025-07-01):** Includes all Modern changes up to 11.1.7.

- [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm_Classic "Cataclysm")**[Patch 4.4.1](https://warcraft.wiki.gg/wiki/Patch_4.4.1/API_changes "Patch 4.4.1/API changes") (2024-10-29):** Includes all Modern changes up to 11.0.0.

- [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm_Classic "Cataclysm")**[Patch 4.4.0](https://warcraft.wiki.gg/wiki/Patch_4.4.0/API_changes "Patch 4.4.0/API changes") (2024-04-30):**
  - Includes all Modern changes up to 10.2.7.
  - The behavior of the `_Classic` TOC suffix has changed such that it now loads on all Classic clients, and not just Classic Era.
- [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Burning_Crusade_Classic "Burning Crusade")**[Patch 2.5.3](https://warcraft.wiki.gg/wiki/Patch_2.5.3/API_changes "Patch 2.5.3/API changes") (2022-01-18):**`/reload` recognizes changes to TOC metadata and entirely new files in the `Interface/AddOns/` directory tree.

- [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Burning_Crusade_Classic "Burning Crusade")**[Patch 2.5.1](https://warcraft.wiki.gg/wiki/Patch_2.5.1/API_changes "Patch 2.5.1/API changes") (2021-05-18):** Multiple TOC files are now supported using a suffix to disambiguate Classic, BCC and Retail.[\[1\]](https://warcraft.wiki.gg/wiki/TOC_format#cite_note-WoWUIBug#68-1)

- [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic")**[Patch 1.13.2](https://warcraft.wiki.gg/wiki/Patch_1.13.2/API_changes "Patch 1.13.2/API changes") (2019-08-26):** Includes all Modern changes up to 8.1.0.


### Classic Era

- [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic")**[Patch 1.15.8](https://warcraft.wiki.gg/wiki/Patch_1.15.8/API_changes "Patch 1.15.8/API changes") (2025-10-21):** Includes all Modern changes up to 11.2.0.

- [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic")**[Patch 1.15.4](https://warcraft.wiki.gg/wiki/Patch_1.15.4/API_changes "Patch 1.15.4/API changes") (2024-09-24):** Includes all Modern changes up to 11.0.0.

- [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic")**[Patch 1.14.0](https://warcraft.wiki.gg/wiki/Patch_1.14.0/API_changes "Patch 1.14.0/API changes") (2021-09-28):**
  - Includes all Classic Progression changes up to 2.5.2.
  - `/reload` recognizes changes to TOC metadata and entirely new files in the `Interface/AddOns/` directory tree.
- [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic")**[Patch 1.13.7](https://warcraft.wiki.gg/wiki/Patch_1.13.7/API_changes "Patch 1.13.7/API changes") (2021-04-20):** Multiple TOC files are now supported using a suffix to disambiguate Classic, BCC and Retail.[\[1\]](https://warcraft.wiki.gg/wiki/TOC_format#cite_note-WoWUIBug#68-1)


### Classic Titan Reforged

- [![Wrath of the Lich King](https://warcraft.wiki.gg/images/Wrath-Logo-Small.png?6705fd)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Wrath_of_the_Lich_King_Classic "Wrath of the Lich King")**Patch 3.80.0 (2025-11-18):**
  - Includes all Classic Era changes up to 1.15.8.
  - The behavior of the `_Classic` TOC suffix has changed such that it now loads on all Classic clients, and not just Classic Era.

### Classic Anniversary

- [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Burning_Crusade_Classic "Burning Crusade")**[Patch 2.5.5](https://warcraft.wiki.gg/wiki/Patch_2.5.5/API_changes "Patch 2.5.5/API changes") (2026-01-13):**
  - Includes all all Classic Era changes up to 1.15.8.
  - The behavior of the `_Classic` TOC suffix has changed such that it now loads on all Classic clients, and not just Classic Era.
  - The legacy TOC suffix `-BCC` is no longer supported.

## See also

- [GetAddOnInfo](https://warcraft.wiki.gg/wiki/API_GetAddOnInfo "API GetAddOnInfo") returns basic information about an addon.
- [Using the AddOn namespace](https://warcraft.wiki.gg/wiki/Using_the_AddOn_namespace "Using the AddOn namespace") describes the parameters passed to each file.

## References

1. ^ [a](https://warcraft.wiki.gg/wiki/TOC_format#cite_ref-WoWUIBug#68_1-0)[b](https://warcraft.wiki.gg/wiki/TOC_format#cite_ref-WoWUIBug#68_1-1)[c](https://warcraft.wiki.gg/wiki/TOC_format#cite_ref-WoWUIBug#68_1-2)[d](https://warcraft.wiki.gg/wiki/TOC_format#cite_ref-WoWUIBug#68_1-3)Meo [![Inv g fishingbobber 05.png](https://warcraft.wiki.gg/images/thumb/Inv_g_fishingbobber_05.png/12px-Inv_g_fishingbobber_05.png?97dd2c)](https://warcraft.wiki.gg/wiki/File:Inv_g_fishingbobber_05.png) rawr. [Multiple Interface Version Support](https://github.com/Stanzilla/WoWUIBugs/issues/68#issuecomment-889431675). WoWUIBugs.

| | Collapse<br>Authoring |
| --- |
|  |
| | Global API | - [GetBuildInfo](https://warcraft.wiki.gg/wiki/API_GetBuildInfo "API GetBuildInfo")<br>- [GetExpansionLevel](https://warcraft.wiki.gg/wiki/API_GetExpansionLevel "API GetExpansionLevel")<br>- [C\_AddOns.GetAddOnMetadata](https://warcraft.wiki.gg/wiki/API_C_AddOns.GetAddOnMetadata "API C AddOns.GetAddOnMetadata")<br>- [C\_Seasons.GetActiveSeason](https://warcraft.wiki.gg/wiki/API_C_Seasons.GetActiveSeason "API C Seasons.GetActiveSeason") | |
|  |
| | Docs | - [WOW\_PROJECT\_ID](https://warcraft.wiki.gg/wiki/WOW_PROJECT_ID "WOW PROJECT ID")<br>- TOC format<br>- [Addon Categories](https://warcraft.wiki.gg/wiki/Addon_Categories "Addon Categories") | |
|  |
| | Tutorials | - [Using the BigWigs Packager with GitHub Actions](https://warcraft.wiki.gg/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions "Using the BigWigs Packager with GitHub Actions") | | |

Retrieved from " [https://warcraft.wiki.gg/wiki/TOC\_format?oldid=6767089](https://warcraft.wiki.gg/wiki/TOC_format?oldid=6767089)"

[Category](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [UI technical details](https://warcraft.wiki.gg/wiki/Category:UI_technical_details "Category:UI technical details")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK