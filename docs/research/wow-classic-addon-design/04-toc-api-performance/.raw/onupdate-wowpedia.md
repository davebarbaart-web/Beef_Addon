Wowpedia

We have moved to Warcraft Wiki. [Click here](https://wowpedia.fandom.com/wiki/Forum:Vote_to_Leave_Fandom "Forum:Vote to Leave Fandom") for information and the new URL.

READ MORE

[Fandom homepage](https://www.fandom.com/)

[Wowpedia](https://wowpedia.fandom.com/wiki/Wowpedia)

[Switch to Light Theme](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate# "Switch to Light Theme")

[Sign In](https://auth.fandom.com/signin?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate&metadata=header-signin-button)

Don't have an account?

[Create a Free Account](https://auth.fandom.com/register?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate&metadata=header-registration-button)

* * *

[Sign In](https://auth.fandom.com/signin?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate&metadata=header-signin-button)

Advertisement


[Skip to content](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate#page-header)

[Edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate%3Fveaction%3Dedit&uselang=en&metadata=article-registration-edit-article)[Sign In to Save](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate%3Fcollections%3Dsave&uselang=en&metadata=collections-save-button)

in: [Widget script handlers](https://wowpedia.fandom.com/wiki/Category:Widget_script_handlers "Category:Widget script handlers"), [Statements needing citations](https://wowpedia.fandom.com/wiki/Category:Statements_needing_citations "Category:Statements needing citations")

# Script OnUpdate

[Sign In to SaveSave](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate%3Fcollections%3Dsave&uselang=en&metadata=collections-save-button "Sign In to Save") [Edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate%3Fveaction%3Dedit&uselang=en&metadata=article-registration-edit-article)

- [History](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate?action=history)
- [Purge](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate?action=purge)
- [Talk (1)](https://wowpedia.fandom.com/wiki/Talk:UIHANDLER_OnUpdate)

| [Main Menu](https://wowpedia.fandom.com/wiki/Wowpedia:Interface_customization "Wowpedia:Interface customization") |
| --- |
| - [WoW API](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://wowpedia.fandom.com/wiki/Lua_functions "Lua functions")<br>- [FrameXML util](https://wowpedia.fandom.com/wiki/FrameXML_functions "FrameXML functions")<br>* * *<br>- [Widget API](https://wowpedia.fandom.com/wiki/Widget_API "Widget API")<br>- [Widget scripts](https://wowpedia.fandom.com/wiki/Widget_script_handlers "Widget script handlers")<br>- [XML schema](https://wowpedia.fandom.com/wiki/XML_schema "XML schema")<br>- [Events](https://wowpedia.fandom.com/wiki/Events "Events")<br>- [CVars](https://wowpedia.fandom.com/wiki/Console_variables "Console variables")<br>* * *<br>- [Macro commands](https://wowpedia.fandom.com/wiki/Macro_commands "Macro commands")<br>- [Combat Log](https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://wowpedia.fandom.com/wiki/UI_escape_sequences "UI escape sequences")<br>- [Hyperlinks](https://wowpedia.fandom.com/wiki/Hyperlinks "Hyperlinks")<br>- [API changes](https://wowpedia.fandom.com/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://wowpedia.fandom.com/wiki/HOWTOs "HOWTOs")<br>- [![Discord logo](https://static.wikia.nocookie.net/wowpedia/images/d/d0/Discord_logo.png/revision/latest/scale-to-width-down/12?cb=20220301221829)](https://discord.gg/txUg39Vhc6)[wowuidev](https://discord.gg/txUg39Vhc6) |

|     |     |
| --- | --- |
| ![AquaDed](https://static.wikia.nocookie.net/wowpedia/images/9/98/AquaDed.png/revision/latest/scale-to-width-down/64?cb=20231015140510) | The API is no longer being updated here until further notice. |

Invoked when drawing the user interface (many times per second).

```
(self, elapsed)
```

## Payload\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate%3Faction%3Dedit%26section%3D1&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

self[ScriptObject](https://wowpedia.fandom.com/wiki/UIOBJECT_ScriptObject "UIOBJECT ScriptObject") \- The updated widget.elapsednumber \- The time in seconds since the last OnUpdate dispatch, but excluding time when the user interface was not being drawn such as while zoning into the game world[\[ _citation needed_\]](https://wowpedia.fandom.com/wiki/Wowpedia:Citation "Wowpedia:Citation")

## Details\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate%3Faction%3Dedit%26section%3D2&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

- Preceeded by handlers associated with processing user input.
- Blocked by [hiding](https://wowpedia.fandom.com/wiki/API_Region_Hide "API Region Hide") a frame or its parent.
- OnUpdate is resource intensive because it fires as often as the client can draw new frames -- potentially hundreds of FPS with modern computers.
  - It is usually better to substitute [C\_Timer.After](https://wowpedia.fandom.com/wiki/API_C_Timer.After "API C Timer.After")() or [C\_Timer.NewTicker](https://wowpedia.fandom.com/wiki/API_C_Timer.NewTicker "API C Timer.NewTicker")() to skip frames, or to apply an [Animation](https://wowpedia.fandom.com/wiki/UIOBJECT_Animation "UIOBJECT Animation") for animating a widget.
  - Alternatively, throttle slower parts of an OnUpdate handler by measuring the passage of time and only performing work as often as reasonably necessary.

## Examples\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUIHANDLER_OnUpdate%3Faction%3Dedit%26section%3D3&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

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

Categories

Community content is available under [CC BY-SA 3.0](https://www.fandom.com/licensing) unless otherwise noted.

- [Fantasy](https://www.fandom.com/fancentral/fantasy)
- [World of Warcraft](https://www.fandom.com/universe/world-of-warcraft)

Advertisement


silver-surfer-storage-html

RL Storage

Wowpedia


We have moved to Warcraft Wiki. [Click here](https://wowpedia.fandom.com/wiki/Forum:Vote_to_Leave_Fandom "Forum:Vote to Leave Fandom") for information and the new URL.

CLOSE


[Search this wiki](https://wowpedia.fandom.com/wiki/Special:Search?scope=internal&query=&h=1&isFromHighlightActions=on)

[Search all wikis](https://wowpedia.fandom.com/wiki/Special:Search?scope=cross-wiki&query=&h=1&isFromHighlightActions=on)

![](https://ad-delivery.net/px.gif?ch=2)![](https://ad.doubleclick.net/favicon.ico?ad=300x250&ad_box_=1&adnet=1&showad=1&size=250x250)![](https://ad-delivery.net/px.gif?ch=1&e=0.8650019734802782)