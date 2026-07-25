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

# UIHANDLER OnUpdate

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

Invoked when drawing the user interface (many times per second).

```
(self, elapsed)
```

## Payload

self[ScriptObject](https://warcraft.wiki.gg/wiki/UIOBJECT_ScriptObject "UIOBJECT ScriptObject") \- The updated widget.elapsednumber \- The time in seconds since the last OnUpdate dispatch, but excluding time when the user interface was not being drawn such as while zoning into the game world[\[ _citation needed_\]](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Citation "Warcraft Wiki:Citation")

## Details

- Preceeded by handlers associated with processing user input.
- Blocked by [hiding](https://warcraft.wiki.gg/wiki/API_Region_Hide "API Region Hide") a frame or its parent.
- OnUpdate is resource intensive because it fires as often as the client can draw new frames -- potentially hundreds of FPS with modern computers.
  - It is usually better to substitute [C\_Timer.After](https://warcraft.wiki.gg/wiki/API_C_Timer.After "API C Timer.After")() or [C\_Timer.NewTicker](https://warcraft.wiki.gg/wiki/API_C_Timer.NewTicker "API C Timer.NewTicker")() to skip frames, or to apply an [Animation](https://warcraft.wiki.gg/wiki/UIOBJECT_Animation "UIOBJECT Animation") for animating a widget.
  - Alternatively, throttle slower parts of an OnUpdate handler by measuring the passage of time and only performing work as often as reasonably necessary.

## Examples

Throttles a workload no more than once every 0.05 seconds:

```
local frame = CreateFrame("FRAME")
local timeElapsed = 0
frame:HookScript("OnUpdate", function(self, elapsed)
	timeElapsed = timeElapsed + elapsed
	if timeElapsed > 0.05 then
		timeElapsed = 0
		-- do something
	end
end)
```

Copy

Executes a workload 20 times per second. If FPS is slower than 20, the workload repeats until caught up.

```
local frame = CreateFrame("FRAME")
local timeElapsed = 0
frame:HookScript("OnUpdate", function(self, elapsed)
	timeElapsed = timeElapsed + elapsed
	while (timeElapsed > 0.05) do
		timeElapsed = timeElapsed - 0.05
		-- do something
	end
end)
```

Copy

Retrieved from " [https://warcraft.wiki.gg/wiki/UIHANDLER\_OnUpdate?oldid=3167340](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate?oldid=3167340)"

[Categories](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [Widget script handlers](https://warcraft.wiki.gg/wiki/Category:Widget_script_handlers "Category:Widget script handlers")
- [Statements needing citations](https://warcraft.wiki.gg/wiki/Category:Statements_needing_citations "Category:Statements needing citations")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK