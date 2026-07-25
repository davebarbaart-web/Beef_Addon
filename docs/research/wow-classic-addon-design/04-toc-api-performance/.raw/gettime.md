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

# GetTime

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/API_GetTime#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/API_GetTime#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

|     |     |
| --- | --- |
| ![Fat cat yearns for the mines](https://warcraft.wiki.gg/images/thumb/Fatcat_miner.png/64px-Fatcat_miner.png?82abc0) | The API wiki is under maintenance<br>Since `2026-07-23T06:08:00Z`, ETA: at least multiple days |

Returns the system uptime of your computer in seconds, with millisecond precision.

```
seconds = GetTime()
```

## Contents

- [1Returns](https://warcraft.wiki.gg/wiki/API_GetTime#Returns)
- [2Details](https://warcraft.wiki.gg/wiki/API_GetTime#Details)
- [3Patch changes](https://warcraft.wiki.gg/wiki/API_GetTime#Patch_changes)
- [4See also](https://warcraft.wiki.gg/wiki/API_GetTime#See_also)

## Returns

secondsnumber \- The current system uptime in seconds, e.g. 60123.558

## Details

- This value is only updated once per rendered frame. Finer-grained timers are available using [GetTimePreciseSec](https://warcraft.wiki.gg/wiki/API_GetTimePreciseSec "API GetTimePreciseSec")() or [debugprofilestop](https://warcraft.wiki.gg/wiki/API_debugprofilestop "API debugprofilestop")().
- It is possible for this function to return identical values across consecutive frames if a low resolution [timing method](https://warcraft.wiki.gg/wiki/CVar_timingMethod "CVar timingMethod") is in use while running at a high framerate.

## Patch changes

- [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm "Cataclysm")**[Patch 4.3.0](https://warcraft.wiki.gg/wiki/Patch_4.3.0/API_changes "Patch 4.3.0/API changes") (2011-11-29):** Only updates once every OnUpdate[\[1\]](http://www.wowinterface.com/forums/showthread.php?t=41919#6)


## See also

- [time](https://warcraft.wiki.gg/wiki/API_time "API time")(), [date](https://warcraft.wiki.gg/wiki/API_date "API date")()
- [GetGameTime](https://warcraft.wiki.gg/wiki/API_GetGameTime "API GetGameTime")()
- [GetTimePreciseSec](https://warcraft.wiki.gg/wiki/API_GetTimePreciseSec "API GetTimePreciseSec")()
- [CVar timingMethod](https://warcraft.wiki.gg/wiki/CVar_timingMethod "CVar timingMethod")

Retrieved from " [https://warcraft.wiki.gg/wiki/API\_GetTime?oldid=6588121](https://warcraft.wiki.gg/wiki/API_GetTime?oldid=6588121)"

[Categories](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [API systems/SystemTime](https://warcraft.wiki.gg/wiki/Category:API_systems/SystemTime "Category:API systems/SystemTime")
- [API functions](https://warcraft.wiki.gg/wiki/Category:API_functions "Category:API functions")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK