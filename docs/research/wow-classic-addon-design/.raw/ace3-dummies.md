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

# Ace3 for Dummies

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

Ace3 is an addon framework for World of Warcraft to make writing addons easier. It's however not required for writing addons and it's recommended to understand the basics first before using Ace3.[\[1\]](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#cite_note-1)

## Contents

- [1Getting started](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#Getting_started)
- [2Bringing Ace3 to the Party](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#Bringing_Ace3_to_the_Party)
- [3Saying Hello](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#Saying_Hello)
- [4Responding to Events](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#Responding_to_Events)
- [5Chat Commands](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#Chat_Commands)
- [6GUI and Blizzard Interface Options](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#GUI_and_Blizzard_Interface_Options)
- [7Making the Message More Prominent](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#Making_the_Message_More_Prominent)
- [8Saving Configuration Between Sessions](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#Saving_Configuration_Between_Sessions)
  - [8.1User Profiles](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#User_Profiles)
- [9Conclusion](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#Conclusion)

## Getting started

We'll begin with creating a `World of Warcraft\_retail_\Interface\AddOns\WelcomeHome` folder and a . [TOC](https://warcraft.wiki.gg/wiki/TOC_format "TOC format") file inside with the same name:

WelcomeHome.toc

```
## Interface: 120007
## Version: 1.0.0
## Title: WelcomeHome
## Notes: Displays a welcome message when you get to your home zone
## Author: YourName

Core.lua
```

Then create an empty text file called Core.lua in the same directory and start up WoW. After logging in, you should be able to see that your AddOn is being recognized by the game.

![AddOn List](https://warcraft.wiki.gg/images/Tutorial_Ace_1.png?538dbe)

## Bringing Ace3 to the Party

Download Ace3 from [https://www.wowace.com/projects/ace3/files](https://www.wowace.com/projects/ace3/files) and unzip it into a subfolder called `Libs`

There are lots of Ace3 libraries for you to use, but for this tutorial we only need to keep the following libs and you can delete the rest:

[![Tutorial Ace 2.png](https://warcraft.wiki.gg/images/Tutorial_Ace_2.png?287f25)](https://warcraft.wiki.gg/wiki/File:Tutorial_Ace_2.png)

We also need to tell WoW to load the Ace3 files when it loads your addon.

```
## Interface: 120007
## Version: 1.0.0
## Title: WelcomeHome
## Notes: Displays a welcome message when you get to your home zone
## Author: YourName
## SavedVariables: WelcomeHomeDB
## OptionalDeps: Ace3

Libs\LibStub\LibStub.lua
Libs\CallbackHandler-1.0\CallbackHandler-1.0.xml
Libs\AceAddon-3.0\AceAddon-3.0.xml
Libs\AceEvent-3.0\AceEvent-3.0.xml
Libs\AceDB-3.0\AceDB-3.0.xml
Libs\AceDBOptions-3.0\AceDBOptions-3.0.xml
Libs\AceConsole-3.0\AceConsole-3.0.xml
Libs\AceGUI-3.0\AceGUI-3.0.xml
Libs\AceConfig-3.0\AceConfig-3.0.xml

Core.lua
```

📝 _Note 1: `AceConfig` depends on `AceConsole` and `AceGUI` but otherwise the load order does not matter. Just copy it from the Ace3 TOC if you want to be sure._[\[2\]](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#cite_note-2)📝 _Note 2: `AceLocale`, `AceTimer` and `AceComm` are not included in this tutorial._

We've included the [SavedVariables](https://warcraft.wiki.gg/wiki/TOC_format#SavedVariables "TOC format") TOC field which we will need eventually. The [OptionalDeps](https://warcraft.wiki.gg/wiki/TOC_format#OptionalDeps "TOC format") field is in case a user of your addon wants to use Ace3 as a standalone addon instead of the embedded libraries in your Libs folder.

## Saying Hello

Open the Core.lua file and add the following:

```
WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0")

function WelcomeHome:OnInitialize()
	-- Called when the addon is loaded
	self:Print("Hello World!")
end

function WelcomeHome:OnEnable()
	-- Called when the addon is enabled
end

function WelcomeHome:OnDisable()
	-- Called when the addon is disabled
end
```

Copy

This is the basic structure of an Ace3 addon. The first line creates an instance of the AceAddon class using the [NewAddon](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0#title-18) method.

Since we will also be printing to the chat window and accepting slash commands, we include the `AceConsole` [mixin](https://en.wikipedia.org/wiki/Mixin "wikipedia:Mixin") which e.g. includes the [Print](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-3) method.

Following that are three method overrides: `OnInitialize`, `OnEnable`, and `OnDisable` respectively. The first is executed only once when the UI loads and the next two are executed when the addon is enabled and disabled. You can `Enable` and `Disable` Ace addons at will.

Open or [/reload](https://warcraft.wiki.gg/wiki/MACRO_reload "MACRO reload") the game client, you should be able to see your chat message! Before we go any further, go back over to your code and remove the print message. It is generally considered bad form for your addon to toss a bunch of text into the chat window just because it has loaded. Too many addons do this already. You can also remove the `OnDisable` method since we won't be using it.

[![Tutorial Ace 3.png](https://warcraft.wiki.gg/images/Tutorial_Ace_3.png?422f3b)](https://warcraft.wiki.gg/wiki/File:Tutorial_Ace_3.png)

## Responding to Events

This addon will give a welcome message to the player when they arrive in their home zone. How will we know they are in their home zone? Simple, we will respond to the [ZONE\_CHANGED](https://warcraft.wiki.gg/wiki/ZONE_CHANGED "ZONE CHANGED") game [event](https://warcraft.wiki.gg/wiki/Events "Events") which the game fires when the player enters a new (sub)zone.

Before we can register an event, we need to include the [AceEvent](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0) mixin into our addon.

```
WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0", "AceEvent-3.0")
```

Once we've done that, we can use [RegisterEvent](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-1) to respond to the ZONE\_CHANGED event.

```
function WelcomeHome:OnEnable()
	self:RegisterEvent("ZONE_CHANGED")
end
```

Copy

We also need to add the handler for that event. There we can compare our hearthstone location from [GetBindLocation](https://warcraft.wiki.gg/wiki/API_GetBindLocation "API GetBindLocation") with [GetSubZoneText](https://warcraft.wiki.gg/wiki/API_GetSubZoneText "API GetSubZoneText").

```
function WelcomeHome:ZONE_CHANGED()
	local subzone = GetSubZoneText()
	self:Print("You have changed zones!", GetZoneText(), subzone)
	if GetBindLocation() == subzone then
		self:Print("Welcome Home!")
	end
end
```

Copy

_You might be wondering if we should call [UnregisterEvent](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-4) from our OnDisable override, but we don't have to do that because `AceEvent` already does it for us._

Now have your character leave the area he/she is presently in. You should see your message in the chat when you change zone and if you're in the same subzone as your hearthstone location it should give you a friendly message.

[![Tutorial Ace 4.png](https://warcraft.wiki.gg/images/Tutorial_Ace_4.png?97dcc7)](https://warcraft.wiki.gg/wiki/File:Tutorial_Ace_4.png)

## Chat Commands

Now let's add support for slash commands with [RegisterChatCommand](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-5).

```
function WelcomeHome:OnInitialize()
	self:RegisterChatCommand("wh", "SlashCommand")
	self:RegisterChatCommand("welcomehome", "SlashCommand")
end

function WelcomeHome:SlashCommand(msg)
	if msg == "ping" then
		self:Print("pong!")
	else
		self:Print("hello there!")
	end
end
```

Copy

[![Tutorial Ace 5.gif](https://warcraft.wiki.gg/images/Tutorial_Ace_5.gif?d548b3)](https://warcraft.wiki.gg/wiki/File:Tutorial_Ace_5.gif)

## GUI and Blizzard Interface Options

But why stop at chat commands? All cool addons have a **G** raphical **U** ser **I** nterface these days so WelcomeHome shouldn't be any different!

First we define our [options table](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables).

```
local options = {
	name = "WelcomeHome",
	handler = WelcomeHome,
	type = "group",
	args = {
		msg = {
			type = "input",
			name = "Message",
			desc = "The message to be displayed when you get home.",
			usage = "<Your message>",
			get = "GetMessage",
			set = "SetMessage",
		},
	},
}
```

Copy

And the getters/setters for our message. It knows where to look since `handler` is defined.

```
function WelcomeHome:GetMessage(info)
	return self.message
end

function WelcomeHome:SetMessage(info, value)
	self.message = value
end
```

Copy

📝 _Note: the [info](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1) table is an advanced topic, so you can ignore that for now._

Now to include our addon options to the "AddOns" tab, all we need to do is call [RegisterOptionsTable](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0#title-1) and [AddToBlizOptions](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0#title-1). The latter method returns a frame we need for opening our options panel, so we save it in `self.optionsFrame`

```
function WelcomeHome:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome", "WelcomeHome")
	self:RegisterChatCommand("wh", "SlashCommand")
	self:RegisterChatCommand("welcomehome", "SlashCommand")
	-- default values
	self.message = "Welcome Home!"
end
```

Copy

We want the addon to open a GUI for our options if there's no other input and otherwise we'll handle it like a normal chat command.

```
function WelcomeHome:SlashCommand(msg)
	if not msg or msg:trim() == "" then
		Settings.OpenToCategory(self.optionsFrame.name)
	else
		self:Print("hello there!")
	end
end
```

Copy

[![Tutorial Ace 6.png](https://warcraft.wiki.gg/images/Tutorial_Ace_6.png?874f8b)](https://warcraft.wiki.gg/wiki/File:Tutorial_Ace_6.png)

## Making the Message More Prominent

Now let's add display the message somewhere that is a bit more prominent, for example the `UIErrorsFrame` with [AddMessage](https://warcraft.wiki.gg/wiki/API_ScrollingMessageFrame_AddMessage "API ScrollingMessageFrame AddMessage"). We'll also add an option for it.

```
local options = {
	name = "WelcomeHome",
	handler = WelcomeHome,
	type = "group",
	args = {
		msg = {
			type = "input",
			name = "Message",
			desc = "The message to be displayed when you get home.",
			usage = "<Your message>",
			get = "GetMessage",
			set = "SetMessage",
		},
		showOnScreen = {
			type = "toggle",
			name = "Show on Screen",
			desc = "Toggles the display of the message on the screen.",
			get = "IsShowOnScreen",
			set = "ToggleShowOnScreen"
		},
	},
}
```

```
function WelcomeHome:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome", "WelcomeHome")
	self:RegisterChatCommand("wh", "SlashCommand")
	self:RegisterChatCommand("welcomehome", "SlashCommand")
	-- default values
	self.message = "Welcome Home!"
	self.showOnScreen = true
end
```

```
function WelcomeHome:ZONE_CHANGED()
	if GetBindLocation() == GetSubZoneText() then
		if self.showOnScreen then
			UIErrorsFrame:AddMessage(self.message, 1, 1, 1)
		else
			self:Print(self.message)
		end
	end
end
```

```
function WelcomeHome:IsShowOnScreen(info)
	return self.showOnScreen
end

function WelcomeHome:ToggleShowOnScreen(info, value)
	self.showOnScreen = value
end
```

Copy

## Saving Configuration Between Sessions

You may have noticed is that your settings aren't persisted between sessions. When you logout and back in, you will have the default settings again. WoW provides a way to save your settings with [SavedVariables](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions "Saving variables between game sessions"), but there is an Ace way to do it with [AceDB:New](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-2).

```
local defaults = {
	profile = {
		message = "Welcome Home!",
		showOnScreen = true,
	},
}
```

Copy

```
function WelcomeHome:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("WelcomeHomeDB", defaults, true)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome", "WelcomeHome")
	self:RegisterChatCommand("wh", "SlashCommand")
	self:RegisterChatCommand("welcomehome", "SlashCommand")
end
```

- `"WelcomeHomeDB"` refers to our SavedVariables [entry](https://warcraft.wiki.gg/wiki/TOC_format#SavedVariables "TOC format") in the TOC.
- We pass `true` for the third argument of `AceDB:New()` so all characters will share the same "Default" profile. Otherwise if you don't specify anything, all characters will get their own specific profile. See the [AceDB](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0) docs for more information on data types like `profile`.

| Expand📝 Example: How AceDB magic handles defaults |
| --- |
| ```<br>-- https://gist.github.com/Meorawr/8773ae5dadc187a668dba4cfa1164c1d<br>local defaults = {<br>    profile = {<br>        foo = "foo",<br>        bar = "bar",<br>        foobar = "foobar",<br>    },<br>};<br>local db = LibStub("AceDB-3.0"):New("MyAddOn_SavedVars", defaults, true);<br>DevTools_Dump({ db.profile });<br>-- Modify a value; expect 'foo' to change in output.<br>db.profile.foo = 42<br>DevTools_Dump({ db.profile });<br>-- Re-registering defaults effectively simulates what'll happen if you change<br>-- a default value in an addon update.<br>--<br>-- You'll see the following effects:<br>--<br>--   * 'foo' will be unmodified as we changed its value from the default.<br>--   * 'bar' will reflect the new default value below.<br>--   * 'foobar' will be removed as it was a default that no longer exists.<br>--   * 'baz' will be added.<br>--<br>-- Note that if we modified 'foobar' instead of 'foo' above its entry in the<br>-- database would _not_ be removed.<br>defaults = {<br>    profile = {<br>        foo = 123,<br>        bar = 456,<br>        baz = 789,<br>    },<br>};<br>db:RegisterDefaults(defaults);<br>DevTools_Dump({ db.profile });<br>```<br>Copy |

After that we need to update our old variables to the new ones, e.g. `self.message` to `self.db.profile.message`

```
function WelcomeHome:ZONE_CHANGED()
	if GetBindLocation() == GetSubZoneText() then
		if self.db.profile.showOnScreen then
			UIErrorsFrame:AddMessage(self.db.profile.message, 1, 1, 1)
		else
			self:Print(self.db.profile.message)
		end
	end
end
```

```
function WelcomeHome:GetMessage(info)
	return self.db.profile.message
end

function WelcomeHome:SetMessage(info, value)
	self.db.profile.message = value
end

function WelcomeHome:IsShowOnScreen(info)
	return self.db.profile.showOnScreen
end

function WelcomeHome:ToggleShowOnScreen(info, value)
	self.db.profile.showOnScreen = value
end
```

Reload your UI and nothing should change. Except now if you change any of the settings, they will be persisted across restarts.

### User Profiles

The [profiles tab](https://www.wowace.com/projects/ace3/pages/api/ace-dboptions-3-0) lets users change and reset profiles.

[![](https://warcraft.wiki.gg/images/thumb/Tutorial_Ace_7.png/320px-Tutorial_Ace_7.png?4f1994)](https://warcraft.wiki.gg/wiki/File:Tutorial_Ace_7.png)

[Enlarge](https://warcraft.wiki.gg/wiki/File:Tutorial_Ace_7.png "Enlarge")

Profiles

```
function WelcomeHome:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("TestDB", defaults, true)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome_options", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome_options", "WelcomeHome")

	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome_Profiles", profiles)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome_Profiles", "Profiles", "WelcomeHome")
```

## Conclusion

You have started from nothing and created an addon that uses chat commands, responds to events and provides feedback to the user in a couple of different ways. Here is the final version in case you want to cheat and go right to the end.

WelcomeHome.toc

```
## Interface: 110100
## Version: 1.0.0
## Title: WelcomeHome
## Notes: Displays a welcome message when you get to your home zone
## Author: YourName
## SavedVariables: WelcomeHomeDB
## OptionalDeps: Ace3

Libs\LibStub\LibStub.lua
Libs\CallbackHandler-1.0\CallbackHandler-1.0.xml
Libs\AceAddon-3.0\AceAddon-3.0.xml
Libs\AceEvent-3.0\AceEvent-3.0.xml
Libs\AceDB-3.0\AceDB-3.0.xml
Libs\AceDBOptions-3.0\AceDBOptions-3.0.xml
Libs\AceConsole-3.0\AceConsole-3.0.xml
Libs\AceGUI-3.0\AceGUI-3.0.xml
Libs\AceConfig-3.0\AceConfig-3.0.xml

Core.lua
```

Copy

Core.lua

```
WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0", "AceEvent-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

local defaults = {
	profile = {
		message = "Welcome Home!",
		showOnScreen = true,
	},
}

local options = {
	name = "WelcomeHome",
	handler = WelcomeHome,
	type = "group",
	args = {
		msg = {
			type = "input",
			name = "Message",
			desc = "The message to be displayed when you get home.",
			usage = "<Your message>",
			get = "GetMessage",
			set = "SetMessage",
		},
		showOnScreen = {
			type = "toggle",
			name = "Show on Screen",
			desc = "Toggles the display of the message on the screen.",
			get = "IsShowOnScreen",
			set = "ToggleShowOnScreen"
		},
	},
}

function WelcomeHome:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("WelcomeHomeDB", defaults, true)
	AC:RegisterOptionsTable("WelcomeHome_options", options)
	self.optionsFrame = ACD:AddToBlizOptions("WelcomeHome_options", "WelcomeHome")

	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	AC:RegisterOptionsTable("WelcomeHome_Profiles", profiles)
	ACD:AddToBlizOptions("WelcomeHome_Profiles", "Profiles", "WelcomeHome")

	self:RegisterChatCommand("wh", "SlashCommand")
	self:RegisterChatCommand("welcomehome", "SlashCommand")
end

function WelcomeHome:OnEnable()
	self:RegisterEvent("ZONE_CHANGED")
end

function WelcomeHome:ZONE_CHANGED()
	if GetBindLocation() == GetSubZoneText() then
		if self.db.profile.showOnScreen then
			UIErrorsFrame:AddMessage(self.db.profile.message, 1, 1, 1)
		else
			self:Print(self.db.profile.message)
		end
	end
end

function WelcomeHome:SlashCommand(msg)
	if not msg or msg:trim() == "" then
		Settings.OpenToCategory(self.optionsFrame.name)
	else
		self:Print("hello there!")
	end
end

function WelcomeHome:GetMessage(info)
	return self.db.profile.message
end

function WelcomeHome:SetMessage(info, value)
	self.db.profile.message = value
end

function WelcomeHome:IsShowOnScreen(info)
	return self.db.profile.showOnScreen
end

function WelcomeHome:ToggleShowOnScreen(info, value)
	self.db.profile.showOnScreen = value
end
```

Copy

➡️ Follow-up: [Using the BigWigs Packager with GitHub Actions](https://warcraft.wiki.gg/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions "Using the BigWigs Packager with GitHub Actions")

**See also**

- [WelcomeHome: Your first Ace3 Addon](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon "WelcomeHome: Your first Ace3 Addon") \- Original tutorial
- [https://github.com/ketho-wow/HelloAce](https://github.com/ketho-wow/HelloAce) \- Example Ace3 addon

**Patch changes**

- [![Dragonflight](https://warcraft.wiki.gg/images/thumb/Dragonflight-Icon-Inline.png/48px-Dragonflight-Icon-Inline.png?be4c0e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Dragonflight "Dragonflight")**[Patch 10.0.0](https://warcraft.wiki.gg/wiki/Patch_10.0.0/API_changes "Patch 10.0.0/API changes") (2022-10-25):**`InterfaceOptionsFrame_OpenToCategory` was replaced by [Settings.OpenToCategory](https://github.com/Gethe/wow-ui-source/blob/10.0.0/Interface/SharedXML/Settings/Blizzard_Deprecated.lua#L24).


**References**

1. [^](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#cite_ref-1) [http://web.archive.org/web/20130420080122/http://old.wowace.com/Ace3](http://web.archive.org/web/20130420080122/http://old.wowace.com/Ace3)
2. [^](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies#cite_ref-2) [https://authors-old.curseforge.com/forums/world-of-warcraft/general-chat/lua-code-discussion/225419-working-with-aceconsole-3-0#c5](https://authors-old.curseforge.com/forums/world-of-warcraft/general-chat/lua-code-discussion/225419-working-with-aceconsole-3-0#c5)

Retrieved from " [https://warcraft.wiki.gg/wiki/Ace3\_for\_Dummies?oldid=6286652](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies?oldid=6286652)"

[Category](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [HOWTOs](https://warcraft.wiki.gg/wiki/Category:HOWTOs "Category:HOWTOs")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK