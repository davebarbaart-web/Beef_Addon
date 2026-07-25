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

# Patch 2.5.6/API changes

From Warcraft Wiki

< [Patch 2.5.6](https://warcraft.wiki.gg/wiki/Patch_2.5.6 "Patch 2.5.6")

[Jump to navigation](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

|     |     |
| --- | --- |
| [![Icon-api-48x48.png](https://warcraft.wiki.gg/images/Icon-api-48x48.png?6b6990)](https://warcraft.wiki.gg/wiki/File:Icon-api-48x48.png) | **This article documents [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries") made in [Patch 2.5.6](https://warcraft.wiki.gg/wiki/Patch_2.5.6 "Patch 2.5.6").** <br>- Previous patch: [Patch 2.5.5](https://warcraft.wiki.gg/wiki/Patch_2.5.5/API_changes "Patch 2.5.5/API changes"). |

## Contents

- [1Resources](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes#Resources)
- [2Blue posts](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes#Blue_posts)

## Resources

- TOC: `20506`
- Diffs: [wow-ui-source](https://github.com/Gethe/wow-ui-source/compare/2.5.5..2.5.6), [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources/compare/2.5.5...2.5.6)

## Blue posts

**User Interface Updates in Classic** \| 2026-07-10 05:10 \| [![Blizzard Entertainment](https://warcraft.wiki.gg/images/Blizz.gif?984542)](https://warcraft.wiki.gg/wiki/Blizzard_Entertainment "Blizzard Entertainment")**[Kaivax](https://warcraft.wiki.gg/wiki/Kaivax "Kaivax")**

Hello,

This week, we updated Burning Crusade Classic Anniversary from patch 2.5.5 to patch 2.5.6. Although this patch was almost entirely to support critical service systems, it also included changes to nameplates and raid frames. We’d like to tell you about these changes, highlight options you have to edit some of the user interface (UI), and look forward to patch 1.15.9 coming to WoW Classic soon.

**UI Using Shared Code**

All versions of WoW Classic share code with modern World of Warcraft. The games gain significant benefits from this, including the support of modern hardware, additional options for graphics and accessibility, widescreen support, and the ability to integrate with Battle.net services in the first place.

This shared code also allows the introduction of UI elements to fill gaps in the original World of Warcraft UI. For instance, the original Burning Crusade only supported the “drag out” raid group UI from the Raid Frame. With the release of WoW Classic in 2019, the game included an additional option to use raid frames from modern World of Warcraft. This means that WoW Classic launched in 2019 with Battle for Azeroth’s raid frames, and then with patch 2.5.5, Burning Crusade Classic Anniversary utilized frames from The War Within. With patch 2.5.6, the game’s raid frame option has aligned with updates to modern World of Warcraft, now matching the offering from Midnight.

**Modifications Using Chat Commands**

Since we released patch 2.5.6, we’ve been listening to community feedback, and we recognize that players are looking for ways to modify their nameplates and raid frames that were updated. In addition to the settings that exist in the Options menu, players can use the following chat commands for further customization:

- Nameplate Class Color (Enemy Units):

```
/script C_CVar.SetCVar("nameplateShowClassColor", 1);
```

Copy

- Nameplate Class Color (Friendly Units):

```
/script C_CVar.SetCVar("nameplateShowFriendlyClassColor", 1);
```

Copy

- Disabling Raid Frame Dispel Highlights:

```
/script C_CVar.SetCVar("raidFramesDispelIndicatorOverlay", 0);
```

Copy

We’re currently working on surfacing these settings in the Options menu itself, so that players will have access to them there, in addition to the option to use chat commands. We expect to implement this next week.

**Upcoming WoW Classic Patch 1.15.9 – Week of July 19**

Similar to this week’s Burning Crusade Classic Anniversary patch, the WoW Classic games (Classic Era, Season of Discovery, Hardcore) will receive a similar patch with the start of weekly regional maintenance the week of July 19. As with the Burning Crusade Classic Anniversary patch, this patch will bring in Edit Mode and changes to players’ nameplates and raid frames to the WoW Classic games.

Some third-party addons may experience errors until they are updated by their authors. As all versions of World of Warcraft share most of their UI code, the addon API in 1.15.9 very closely matches the addon API from 2.5.6. For addon authors, we encourage you to use 2.5.6 as an environment for updating addons to be compatible with 1.15.9.

We will continue to refine our updates in the future, so that we’re providing additional options for players to modify settings wherever possible.

Thank you, as always, for your passion and feedback.

[View original post](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)

Retrieved from " [https://warcraft.wiki.gg/wiki/Patch\_2.5.6/API\_changes?oldid=6778086](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes?oldid=6778086)"

[Category](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [API patch changes](https://warcraft.wiki.gg/wiki/Category:API_patch_changes "Category:API patch changes")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK