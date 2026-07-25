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

# WelcomeHome: Your first Ace3 Addon

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

## Contents

- [1Introduction](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Introduction)
- [2Getting Started](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Getting_Started)
- [3Bringing Ace3 to the Party](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Bringing_Ace3_to_the_Party)
- [4Saying Hello](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Saying_Hello)
- [5Responding to Events](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Responding_to_Events)
- [6Reloading Your Addon Without Restarting WoW](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Reloading_Your_Addon_Without_Restarting_WoW)
- [7Working with the WoW API](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Working_with_the_WoW_API)
- [8Chat Commands and Configuration](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Chat_Commands_and_Configuration)
- [9GUI and Blizzard Interface Options](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#GUI_and_Blizzard_Interface_Options)
- [10Making the Message More Prominent](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Making_the_Message_More_Prominent)
- [11Saving Configuration Between Sessions](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Saving_Configuration_Between_Sessions)
- [12Localizing Your Strings with AceLocale](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Localizing_Your_Strings_with_AceLocale)
  - [12.1Adding AceLocale-3.0 to the Project](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Adding_AceLocale-3.0_to_the_Project)
  - [12.2Building the Localization Database](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Building_the_Localization_Database)
  - [12.3Using the Localized Strings in the Addon](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Using_the_Localized_Strings_in_the_Addon)
- [13Conclusion](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Conclusion)
- [14Join the Ace Community](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Join_the_Ace_Community)
- [15Final Source Files](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Final_Source_Files)
  - [15.1WelcomeHome.toc](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#WelcomeHome.toc)
  - [15.2embeds.xml](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#embeds.xml)
  - [15.3Core.lua](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Core.lua)
  - [15.4enUS.lua](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#enUS.lua)
- [16Attribution](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#Attribution)
- [17See also](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon#See_also)

## Introduction

[Ace3](https://wowace.gamepedia.com/Ace3) is an AddOn development framework, like (the now abandoned) [Rock](https://wowace.gamepedia.com/Rock), [Dongle](https://warcraft.wiki.gg/wiki/Dongle "Dongle"), and [Sea](https://warcraft.wiki.gg/wiki/Sea_(add-on) "Sea (add-on)").

Before starting this tutorial, it's recommended to read [Make it Ace'd](https://wowace.gamepedia.com/Make_it_Ace%27d), and [Ace3 Philosophy](https://wowace.gamepedia.com/Ace3#Ace3_Philosophy)

Alternatively, there is the more advanced and official Ace3 [Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) tutorial

## Getting Started

Since this is a tutorial about using the Ace3 libraries, I will start by showing you what we need to do to get a barebones addon loaded into the game.

Every addon is stored in a folder underneath the WoW main folder called `<WoW>\Interface\AddOns`. Each addon goes in its own folder named after the addon. So to get started we will create a new folder called WelcomeHome.

When WoW finds a folder in the addons directory, it looks inside that folder for a Table of Contents (TOC) file that has the same name as the folder. This .TOC file contains a manifest of all the other files that make up the addon and is used by WoW to load your addon.

Let’s go ahead and create a barebones .TOC file called WelcomeHome.toc:

```
## Interface: 40200
## Version: 0.1
## Title: Welcome Home
## Author: Your Name Here
## Notes: Displays a welcome message when you get to your home zone.

Core.lua
```

These are the basic metadata associated with your addon. There are many other attributes you can include in your .TOC file, for a more comprehensive list see the [TOC Format](https://warcraft.wiki.gg/wiki/TOC_format "TOC format").

Then create an empty text file called Core.lua in the same directory and start up WoW. After logging in, you should be able to click the “AddOns” button in the lower left and see that your AddOn is being recognized by the game. Go ahead and make sure that it is enabled before exiting out of that screen and then out of the game.

Step 1 complete! We are in the game. But we aren’t doing anything yet. That is next.

## Bringing Ace3 to the Party

Since this tutorial is about learning to create addons using Ace3, it is time for us to go ahead and bring those [libraries](https://en.wikipedia.org/wiki/Library_%28computing%29) into our addon. Ace3 uses a concept called “Embedded Libraries” that allows mod developers to have the libraries in their codebase without actually duplicating the code when it is loaded along side other mods that use the same libraries.

This means you need to get local copies of the libraries you intend to use. At this point the easiest way to do this is to download them from the Ace SVN files mirror and put them on your system.

Open a browser and go to [http://www.wowace.com/addons/ace3/files/](http://www.wowace.com/addons/ace3/files/). Download Ace3. This is the most recent build of the Ace libraries. Unzip it into a folder called Libs in your addon's directory. Then go ahead and delete all of the new folders and files **except** these:

- AceAddon-3.0
- [AceDB-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0)
- [AceConfig-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0)
- [AceConsole-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0)
- [AceEvent-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0)
- [AceGUI-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-gui-3-0)
- [CallbackHandler-1.0](https://www.wowace.com/projects/callbackhandler)
- [LibStub](https://www.wowace.com/projects/libstub)

_There are lots of Ace3 libraries for you to use, but for this tutorial we only need some of them. For more information on these libraries, please see the [Ace3 API docs](http://www.wowace.com/addons/ace3/pages/)_

You should now have a folder structure something like this:

```
WelcomeHome
    Libs
        AceAddon-3.0
            AceAddon-3.0.lua
            AceAddon-3.0.xml
        AceConfig-3.0
            AceConfigCmd-3.0
            AceConfigDialog-3.0
            AceConfigDropdown-3.0
            AceConfigRegistry-3.0
            AceConfig-3.0.lua
            AceConfig-3.0.xml
        AceConsole-3.0
            AceConsole-3.0.lua
            AceConsole-3.0.xml
        AceDB-3.0
            AceDB-3.0.lua
            AceDB-3.0.xml
        AceEvent-3.0
            AceEvent-3.0.lua
            AceEvent-3.0.xml
        AceGUI-3.0
            widgets
            AceGUI-3.0.lua
            AceGUI-3.0.xml
        CallbackHandler-1.0
            CallbackHandler-1.0.lua
            CallbackHandler-1.0.xml
        LibStub
            LibStub.lua
    Core.lua
    WelcomeHome.toc
```

You now have the necessary Ace3 libraries in your addon's Libs folder, but if you were to launch WoW right now, they wouldn't be loaded. We need to tell WoW to load the files when it loads your addon and for that we're going to use a file called embeds.xml. So create a new file with the text below and save it as "embeds.xml" in the same folder as your .TOC file.

```
<Ui xmlns="http://www.blizzard.com/wow/ui/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.blizzard.com/wow/ui/
..\FrameXML\UI.xsd">
    <Script file="Libs\LibStub\LibStub.lua"/>
    <Include file="Libs\CallbackHandler-1.0\CallbackHandler-1.0.xml"/>
    <Include file="Libs\AceAddon-3.0\AceAddon-3.0.xml"/>
    <Include file="Libs\AceEvent-3.0\AceEvent-3.0.xml"/>
    <Include file="Libs\AceDB-3.0\AceDB-3.0.xml"/>
    <Include file="Libs\AceConsole-3.0\AceConsole-3.0.xml"/>
    <Include file="Libs\AceGUI-3.0\AceGUI-3.0.xml"/>
    <Include file="Libs\AceConfig-3.0\AceConfig-3.0.xml"/>
</Ui>
```

The first line is just some [xml-voodoo](http://www.w3.org/TR/xmlschema-1/#Schemas), just copy and paste. Then it's a line each for all the libraries we want to load. Notice that it's `<Script />` to load [Lua](https://warcraft.wiki.gg/wiki/Lua "Lua") files and `<Include />` to load [XML](https://warcraft.wiki.gg/wiki/XML "XML") files.

It is vital that we load LibStub first, since all the other libs depend on that. Then CallbackHandler that is used by several of our libraries and AceGUI needs to be loaded before AceConfig. Otherwise the order isn't important, but to be safe, the correct load order can be found in the [Ace3.toc](http://forums.wowace.com/showthread.php?p=299390#post299390) file.

Now let's update the .TOC file to include the embeds.xml. We include it above Core.lua to ensure that the libraries are loaded and available before the code in _Core.lua_ is executed.

```
## Interface: 40200
## Version: 0.1
## Title: Welcome Home
## Author: Your Name Here
## Notes: Displays a welcome message when you get to your home zone.
## SavedVariables: WelcomeHomeDB
## OptionalDeps: Ace3
## X-Embeds: Ace3

embeds.xml

Core.lua
```

I've included a few other things in the .TOC that aren't actually required yet (e.g. SavedVariables), but we will need all of that eventually. The **OptionalDeps** part is there in case a user of your addon comes along later and chooses to use a standalone Ace3 instead of using the embedded libraries in your Libs folder and the **X-Embeds** is there to tell updaters what libs it needs to download separately if the user don't want to use the embedded libs.

## Saying Hello

This section is going to move a little faster than we have been moving. Start by opening Core.lua in a [text editor](https://warcraft.wiki.gg/wiki/Lua_editors "Lua editors") and typing in the following code:

```
WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0")

function WelcomeHome:OnInitialize()
    -- Called when the addon is loaded
end

function WelcomeHome:OnEnable()
    -- Called when the addon is enabled
end

function WelcomeHome:OnDisable()
    -- Called when the addon is disabled
end
```

This is the basic starting structure of an Ace3 addon. The first line creates an instance of the AceAddon class using the [\[lib,\_lib,\_...](https://wowace.gamepedia.com/AceAddon-3.0#AceAddon:NewAddon(name,_)) NewAddon\] method. Since we will also be printing to the chat window and accepting slash commands, I've gone ahead and included the mixin for AceConsole. Among other things, this will get us access to the [Print](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-3) method. There also is [print](http://www.lua.org/manual/5.1/manual.html#pdf-print) (with lowercase p), which is a basic Lua function

_[Mixins](https://en.wikipedia.org/wiki/Mixin) are a concept common in many object oriented languages that allow you to bring additional functionality into your class. We're using [LibStub](https://www.wowace.com/projects/libstub/) for embedding/mixing-in our libraries_

Following that are three [method](https://wowace.gamepedia.com/Coding_Tips#Methods) overrides: **OnInitialize**, **OnEnable**, and **OnDisable** respectively. The first is executed only once when the UI loads and the next two are executed when the addon is enabled and disabled. (You can [Enable](http://www.wowace.com/addons/ace3/pages/api/ace-addon-3-0/#w-addon-enable) and [Disable](http://www.wowace.com/addons/ace3/pages/api/ace-addon-3-0/#w-addon-disable) Ace addons at will.)

It is important to note that OnEnable is called at the beginning if the addon is enabled when the UI loads. You will often have to choose which of these two method overrides to use. Generally, you should use the OnInitialize for those things that you don't need to undo and redo if the addon is disabled and enabled. Another important part of this decision has to do with what other things you will need and when you can be sure they are ready. More on this later...

Just to demonstrate that the addon is loading, we will have the addon print "Hello World!" to the chat window by adding one line of code to the OnEnable method.

```
function WelcomeHome:OnEnable()
    self:Print("Hello World!")
end
```

Go ahead and restart WoW and enter in to the game. Once you are in, you should be able to scroll up in the chat window and find your message. You are now the proud author of the WoW version of Hello World!.

Before we go any further, go back over to your code and remove the print message. It is generally considered bad Ace form for your addon to toss a bunch of text into the chat window just because it has loaded. Too many addons do this already and there are other [ways](http://www.wowace.com/addons/ace3/pages/api/ace-addon-3-0/#w-ace-addon-iterate-addons) to find out what Ace addons have loaded. You can also remove the OnDisable method since we won't be using it.

## Responding to Events

So, as I said, this addon will give a welcome message to the player when they arrive in their home zone. How will we know they are in their home zone? Simple, we will respond to one of the [ZONE\_CHANGED](https://warcraft.wiki.gg/wiki/ZONE_CHANGED "ZONE CHANGED") events which the game fires when the player enters a new zone.

I’m sure you are asking yourself “Events? What the heck are those?” It turns out that like many other programming environments, WoW is [event](https://warcraft.wiki.gg/wiki/Events_(API) "Events (API)") driven. Events are raised when things happen in the game and you can fire events when things happen in your code. In fact, without events, your addon would never even know what to do and when to start doing things. Eventually, everything your addon does is in response to an event.

It appears that ZONE\_CHANGED will be the one we want, so let's hook that one by making a few changes to our Core.lua file.

Before we can subscribe to events, we need to get event support into our addon by including another mixin into our addon. We need to change the line where we create our addon to include the AceEvent mixin. Change your first line as shown here:

```
WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0", "AceEvent-3.0")
```

Once we've done that, we will use the [RegisterEvent](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-1) method that is now available to us to subscribe to the ZONE\_CHANGED event. We will replace the OnEnable override with the following code:

```
function WelcomeHome:OnEnable()
    -- Called when the addon is enabled
    self:RegisterEvent("ZONE_CHANGED")
end

We also need to add in the event handler for that event by adding the following code to our <font color="#DDA0DD">Core.lua</font> file:

function WelcomeHome:ZONE_CHANGED()
    self:Print("You have changed zones!")
end
```

You might be wondering if we should call [UnregisterEvent](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0#title-4) from our OnDisable override, but we don't have to do that because AceEvent does it for us.

Now head back into the game and have your character leave the area he/she is presently in. You should see your message go by down in the chat area when you change zone.

## Reloading Your Addon Without Restarting WoW

Before we go any further, I want to show you a trick that will come in handy for you as you work on your addons.

Leave the game up and running, but switch over to your text editor. Change the event handler as follows...

```
function WelcomeHome:ZONE_CHANGED()
    self:Print("This is a different message!")
end
```

Make sure you save your changes and then go back over to the game and switch zones. Which message did you see? The old one.

Why? Because WoW doesn't automatically reload your addon just because you made a change. One way to get your addon reloaded is to restart the game. Ugh. A much better way to get it reloaded is by entering:

```
/reload
```

Your screen will freeze for a minute while the UI reloads itself and all your other addons reload, but when it comes back up you should now be able to switch zones and see the new message.

From now on you can use this technique to reload your mod when you have made changes.

_Note: if you have [AceConsole-2.0](https://wowace.gamepedia.com/AceConsole-2.0) loaded with any of your addons or if you have the standalone version of [Ace3](https://www.wowace.com/projects/ace3/), you can use the following command to reload your UI:_

```
/rl
```

## Working with the WoW API

We now have a method that we know will get called when the player changes zones. But what zone is he in? Where does he keep his hearthstone set?

If we head back over to the [World of Warcraft API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API") page and look in the [Character Functions](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API#Character_Functions "World of Warcraft API") section, we will see the answer to the second question is a function called [GetBindLocation](https://warcraft.wiki.gg/wiki/API_GetBindLocation "API GetBindLocation"). This function returns the subzone name (e.g. "Tarren Mill") that contains the Inn where your hearthstone is set.

Next we need to figure out how to find what subzone we are in. If we look in the [Location Functions](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API#Location_Functions "World of Warcraft API") section of the API docs, we will find a function called [GetSubZoneText](https://warcraft.wiki.gg/wiki/API_GetSubZoneText "API GetSubZoneText") that looks about right. It returns either an empty string (if you aren't in a subzone) or the name of the subzone you are in.

We should be able to simply compare these two values in our event handler to decide whether we are home or not:

```
function WelcomeHome:ZONE_CHANGED()
    if GetBindLocation() == GetSubZoneText() then
        self:Print("Welcome Home!")
    end
end
```

That's it! We should now have a functional addon doing what we want. Reload your UI and test it out.

## Chat Commands and Configuration

But there are still lots of interesting things we can do. Let's start by adding support for the out-of-the-box slash commands by creating an options table at the top of the file and registering it with [AceConfig-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0):

```
WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "WelcomeHome",
    handler = WelcomeHome,
    type = 'group',
    args = {
    },
}

function WelcomeHome:OnInitialize()
    -- Called when the addon is loaded
    LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options, {"welcomehome", "wh"})
end
```

At this point the options table is empty and we haven't provided any commands. For a complete rundown of the structure of the options table, visit the [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables) page.

If you reload the UI and type **/welcomehome** or **/wh**, you should now see a help message in your chat box that prints the Addon name, description and available commands.

Now lets add a command that lets the user change the text that is displayed by updating the options table:

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

This will define a new slash command called **msg** that takes a text argument and uses the functions named to get and set the underlying variables. Let's quickly write those methods:

```
function WelcomeHome:GetMessage(info)
    return self.message
end

function WelcomeHome:SetMessage(info, newValue)
    self.message = newValue
end
```

_Note_: Using the [info](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1) argument is an advanced topic, for beginners it's enough to know that there is such an argument, so just ignore it until you get more familiar with AceConfig.

Then reload your UI and type **/wh** to see the command. Notice that at this point there is no value for the message string. That is because we didn't provide a default.
We can fix that by adding the following line right after the call to [RegisterOptionsTable](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0#title-1):

```
WelcomeHome.message = "Welcome Home!"
```

The final step is to change the print line in our event handler to use the new message:

```
function WelcomeHome:ZONE_CHANGED()
    if GetBindLocation() == GetSubZoneText() then
        self:Print(self.message)
    end
end
```

Play around with it for a little while and see how it works.

## GUI and Blizzard Interface Options

But why stop at chat commands? All cool addons have a **G** raphical **U** ser **I** nterface these days so WelcomeHome shouldn't be any different! When Blizzard remade their Interface Options in [Patch 2.4](https://warcraft.wiki.gg/wiki/Patch_2.4.0#User_interface "Patch 2.4.0") they introduced the ability for addons to add their options to the "AddOns" tab. For this we need first to handle our chat commands slightly different.

```
function WelcomeHome:OnInitialize()
    -- Called when the addon is loaded
    LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
    self:RegisterChatCommand("welcomehome", "ChatCommand")
    self:RegisterChatCommand("wh", "ChatCommand")
    WelcomeHome.message = "Welcome Home!"
end
```

Now to include our addon options to the "Addons" tab, all we need to do is call the [AceConfigDialog-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0) method [AddToBlizOptions](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0#title-1). This method returns a frame we need to specify later to open the Blizzard Interface Options at the page for our options, so we save it in _self.optionsFrame_.

```
function WelcomeHome:OnInitialize()
    -- Called when the addon is loaded
    LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome", "WelcomeHome")
    self:RegisterChatCommand("wh", "ChatCommand")
    self:RegisterChatCommand("welcomehome", "ChatCommand")
    WelcomeHome.message = "Welcome Home!"
end
```

Here we use the AceConsole method [RegisterChatCommand](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0#title-5) to make **/welcomehome** and **/wh** call our ChatCommand method instead. In this function we can do whatever we want. And we want AceConfigDialog to open a GUI for our options if there's no other input, otherwise we'll let AceConfigCmd handle the input like it would before. This way we have both a GUI and chat commands (using the same options table) so our users can use whatever they please.

```
function WelcomeHome:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("wh", "WelcomeHome", input)
    end
end
```

Try it now and see how it works.

## Making the Message More Prominent

Now that we have the addon working, let's tweak it a bit. Let's add a way to display the message somewhere that is a bit more prominent. To do this we will show the message in a frame called **UIErrorsFrame** and add some new options to let the user decide what they want.

_Note: I'm going to assume that you are starting to figure this out and can figure out where this code goes._

First the new options table:

```
local options = {
    name = "WelcomeHome",
    handler = WelcomeHome,
    type = "group",
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "The message text to be displayed",
            usage = "<Your message here>",
            get = "GetMessage",
            set = "SetMessage",
        },
        showInChat = {
            type = "toggle",
            name = "Show in Chat",
            desc = "Toggles the display of the message in the chat window.",
            get = "IsShowInChat",
            set = "ToggleShowInChat",
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

Then the new default values:

```
WelcomeHome.showInChat = false
WelcomeHome.showOnScreen = true
```

Implementations of the new command's get/set methods:

```
function WelcomeHome:IsShowInChat(info)
    return self.showInChat
end

function WelcomeHome:ToggleShowInChat(info, value)
    self.showInChat = value
end

function WelcomeHome:IsShowOnScreen(info)
    return self.showOnScreen
end

function WelcomeHome:ToggleShowOnScreen(info, value)
    self.showOnScreen = value
end
```

And finally the new event handler method:

```
function WelcomeHome:ZONE_CHANGED()
    if GetBindLocation() == GetSubZoneText() then
        if self.showInChat then
            self:Print(self.message)
        end

        if self.showOnScreen then
            UIErrorsFrame:AddMessage(self.message, 1.0, 1.0, 1.0, 5.0)
        end
    end
end
```

_Note: See [ScrollingMessageFrame:AddMessage](https://warcraft.wiki.gg/wiki/API_ScrollingMessageFrame_AddMessage "API ScrollingMessageFrame AddMessage") for more info._

## Saving Configuration Between Sessions

One thing you may have noticed is that your settings about where to show the message aren't persisted between sessions. When you logout and back in, you will have the default settings again. This isn't ideal. We should be saving these settings somehow.

WoW provides a way for you to do this called [Saved Variables](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions "Saving variables between game sessions"), but there is an Ace way to do it with the AceDB method, [New](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-2). We already have the library listed in our .TOC file, and now it's time to use it.

```
local defaults = {
    profile = {
        message = "Welcome Home!",
        showInChat = false,
        showOnScreen = true,
    },
}

function WelcomeHome:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("WelcomeHomeDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome", "WelcomeHome")
    self:RegisterChatCommand("wh", "ChatCommand")
    self:RegisterChatCommand("welcomehome", "ChatCommand")
end
```

(In this example we associate these variables with the Ace3 `profile` "data-type", but you also can associate them with `char`, `class`, `race`, `faction`, `realm` or `global` . See the [AceDB-3.0](http://www.wowace.com/addons/ace3/pages/api/ace-db-3-0/) docs for more information on data-types.)

The string "WelcomeHomeDB" refers to the SavedVariables definition in the [TOC](https://warcraft.wiki.gg/wiki/TOC_format#Official_Tags "TOC format") file. If you don't specify anything for the third argument all characters using the addon will get their own profile. Here we pass the boolean **true**. This means that unless you change profile manually all character will share the same "Default" profile.

After that we need to replace all of the references to the old variables (e.g. self.message or WelcomeHome.message) with **self.db.profile.<variablename>** (e.g. self.db.profile.message). This will require us to change the get/set methods referenced by our options table and our event handler.

Here are the new command get/set methods:

```
function WelcomeHome:GetMessage(info)
    return self.db.profile.message
end

function WelcomeHome:SetMessage(info, newValue)
    self.db.profile.message = newValue
end

function WelcomeHome:IsShowInChat(info)
    return self.db.profile.showInChat
end

function WelcomeHome:ToggleShowInChat(info, value)
    self.db.profile.showInChat = value
end

function WelcomeHome:IsShowOnScreen(info)
    return self.db.profile.showOnScreen
end

function WelcomeHome:ToggleShowOnScreen(info, value)
    self.db.profile.showOnScreen = value
end
```

And here is the new event handler:

```
function WelcomeHome:ZONE_CHANGED()
    if GetBindLocation() == GetSubZoneText() then
        if self.db.profile.showInChat then
            self:Print(self.db.profile.message);
        end

        if self.db.profile.showOnScreen then
            UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
        end
    end
end
```

As you can see, it was just a simple substitution of the old variable with the new AceDB variable. Reload your UI and nothing should change. Except now if you change any of the settings, they will be persisted across restarts.

This whole exercise was a bit silly, of course, because in a real world addon you would start out using AceDB for your configuration data, but now you know what it is for and why you should be using it.

## Localizing Your Strings with AceLocale

One thing a lot of new addon developers (especially those in the U.S.) forget about is how many people will be wanting to use their addon in a non-english version of the game client. This means that there should be a nice easy way for them to localize the strings in your addon into their language. (Or even better, submit the localized strings to you so you can include them in your next release.)

With Ace3, we do this using the [AceLocale-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0) library. This library is not a mixin like the other libraries we've used so far, so the way we use it is a bit different.

### Adding AceLocale-3.0 to the Project

Let's start by grabbing the AceLocale-3.0 folder from the package that we downloaded earlier and putting it into our Libs folder. We also should create our first localization database file. Create an empty file called enUS.lua and save it in the same folder as your .TOC file.

At this point our folder structure should look like this: (See the [original](https://wow.gamepedia.com/WelcomeHome_-_Your_first_Ace3_Addon#Adding_AceLocale-3.0_to_the_Project) for a better view)

```
WelcomeHome
   Libs
      AceAddon-3.0
         AceAddon-3.0.lua
         AceAddon-3.0.xml
      AceConfig-3.0
         AceConfigCmd-3.0
         AceConfigDialog-3.0
         AceConfigDropdown-3.0
         AceConfigRegistry-3.0
         AceConfig-3.0.lua
         AceConfig-3.0.xml
      AceConsole-3.0
         AceConsole-3.0.lua
         AceConsole-3.0.xml
      AceDB-3.0
         AceDB-3.0.lua
         AceDB-3.0.xml
      AceEvent-3.0
         AceEvent-3.0.lua
         AceEvent-3.0.xml
      AceGUI-3.0
         widgets
         AceGUI-3.0.lua
         AceGUI-3.0.xml
      AceLocale-3.0
         AceLocale-3.0.lua
         AceLocale-3.0.xml
      CallbackHandler-1.0
         CallbackHandler-1.0.lua
         CallbackHandler-1.0.xml
      LibStub
         LibStub.lua
   Core.lua
   embeds.xml
   enUS.lua
   WelcomeHome.toc
```

Then, we need to update our embeds.xml file to reference to the newly added _AceLocale-3.0_ as shown here:

```
<Ui xmlns="http://www.blizzard.com/wow/ui/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.blizzard.com/wow/ui/
..\FrameXML\UI.xsd">
    <Script file="Libs\LibStub\LibStub.lua"/>
    <Include file="Libs\CallbackHandler-1.0\CallbackHandler-1.0.xml"/>
    <Include file="Libs\AceAddon-3.0\AceAddon-3.0.xml"/>
    <Include file="Libs\AceEvent-3.0\AceEvent-3.0.xml"/>
    <Include file="Libs\AceDB-3.0\AceDB-3.0.xml"/>
    <Include file="Libs\AceLocale-3.0\AceLocale-3.0.xml"/>
    <Include file="Libs\AceConsole-3.0\AceConsole-3.0.xml"/>
    <Include file="Libs\AceGUI-3.0\AceGUI-3.0.xml"/>
    <Include file="Libs\AceConfig-3.0\AceConfig-3.0.xml"/>
</Ui>
```

And our .TOC file:

```
## Interface: 40200
## Version: 0.1
## Title: Welcome Home
## Author: Your Name Here
## Notes: Displays a welcome message when you get to your home zone.
## SavedVariables: WelcomeHomeDB
## OptionalDeps: Ace3
## X-Embeds: Ace3

embeds.xml

enUS.lua

Core.lua
```

Notice that the localization file comes before the Core.lua file. This is important or your localization database will not be initialized before it is used by the code in your addon.

Since we have updated our .TOC file, you will need to restart WoW to get these changes loaded into the game. The /reload trick won't work this time. Once you've done that, go ahead and login and make sure everything is still working.

### Building the Localization Database

Now that we have a place to put the localized strings for the US English (enUS) version of our Addon, we need to pass through the source code looking for strings that should be localizable. (In your future addon work, I would recommend going ahead and doing this step at the beginning of your development instead of waiting until the end as we did here.)

After taking a pass through _Core.lua_, I added the following lines to enUS.lua:

```
local L = LibStub("AceLocale-3.0"):NewLocale("WelcomeHome", "enUS", true)

-- Chat commands
L["welcomehome"] = true
L["wh"] = true

L["Welcome Home!"] = true -- default message

L["Message"] = true
L["The message to be displayed when you get home."] = true
L["<Your message>"] = true -- usage

L["Show in Chat"] = true
L["Toggles the display of the message in the chat window."] = true

L["Show on Screen"] = true
L["Toggles the display of the message on the screen."] = true
```

This file has two parts. The first part creates a new AceLocale instance with the name "WelcomeHome". "enUS" is the language code for US English and `true` as the third argument tells AceLocale that this is the default locale. The second part is the actual translations. Having the values be `true` makes them the same as their keys. This means that in our code, when we ask for the localized version of "Welcome Home!", we will get "Welcome Home!", or another string depending on the language.

### Using the Localized Strings in the Addon

To use AceLocale in our addon now we ask AceLocale for an instance with translations and it will give us a table for the current locale or the default if it doesn't have a translation for the language the user is playing in.

Now, add the following line to the top of Core.lua, this calls the [GetLocale](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0#title-1) method (be sure you add it above the options table definition).

```
local L = LibStub("AceLocale-3.0"):GetLocale("WelcomeHome")
```

Now we can use this anywhere we need a translated string by putting `L[ ]` around it. For example the first part of our options table now becomes this:

```
local options = {
    name = "WelcomeHome",
    handler = WelcomeHome,
    type = "group",
    args = {
        msg = {
            type = "input",
            name = L["Message"],
            desc = L["The message to be displayed when you get home."],
            usage = L["<Your message>"],
            get = "GetMessage",
            set = "SetMessage",
        },

 ...etc...
```

This process is pretty straightforward, so I won't bother showing all of it here. You can see the final source files at the end of the article to see if you got them all in your addon.

Using AceLocale is a simple way to get good localization support in your addon.

## Conclusion

You have started from nothing and created a localizable addon that uses chat commands, responds to events and provides feedback to the user in a couple of different ways. There are a number of interesting things you can do to this addon if you want to keep going. Some examples:

- Provide a [configuration menu](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables), in addition to slash commands
- Add support for [LibDataBroker](https://github.com/tekkub/libdatabroker-1-1/wiki/) for in e.g. Data Display AddOns [\[1\]](http://forums.wowace.com/showthread.php?t=14903)
- Show different messages when you zone into other areas (e.g. "Welcome to The Badlands, Home of Uldaman!")

You might also want to read WowAce's [Coding Tips](https://wowace.gamepedia.com/Coding_Tips) page, which can prove very useful.

Hopefully that helps you get started with Ace3 development and leads you down the road to successful addon authoring. Best of luck!

## Join the Ace Community

As you get more interested in Ace3 development, you should consider getting involved in the Ace community at [wowace.com](http://www.wowace.com/)

There is a number of resources available:

- [Version control](https://en.wikipedia.org/wiki/Revision_control) server for [Subversion](https://en.wikipedia.org/wiki/Apache_Subversion), [Git](https://en.wikipedia.org/wiki/Git_%28software%29), or [Mercurial](https://en.wikipedia.org/wiki/Mercurial) [\[2\]](https://wowace.gamepedia.com/What_is_the_SVN%3F) [\[3\]](http://kb.wowace.com/projects/packaging-an-addon/)
- [Web-based forum](http://forums.wowace.com/)
- [IRC channel](https://wow.gamepedia.com/IRC)
- [Wiki](https://wow.gamepedia.com/Main_Page) full of documentation and help

You also should consider publishing your Ace3 addon at [wowinterface.com](http://www.wowinterface.com/).

## Final Source Files

Here is the final contents of _WelcomeHome.toc_, _embeds.xml_, _Core.lua_ and _enUS.lua_ in case you want to cheat and go right to the end.

### WelcomeHome.toc

```
## Interface: 40200
## Version: 0.1
## Title: Welcome Home
## Author: Your Name Here
## Notes: Displays a welcome message when you get to your home zone.
## SavedVariables: WelcomeHomeDB
## OptionalDeps: Ace3
## X-Embeds: Ace3

embeds.xml

enUS.lua

Core.lua
```

### embeds.xml

```
<Ui xmlns="http://www.blizzard.com/wow/ui/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.blizzard.com/wow/ui/
..\FrameXML\UI.xsd">
     <Script file="Libs\LibStub\LibStub.lua"/>
     <Include file="Libs\CallbackHandler-1.0\CallbackHandler-1.0.xml"/>
     <Include file="Libs\AceAddon-3.0\AceAddon-3.0.xml"/>
     <Include file="Libs\AceEvent-3.0\AceEvent-3.0.xml"/>
     <Include file="Libs\AceDB-3.0\AceDB-3.0.xml"/>
     <Include file="Libs\AceLocale-3.0\AceLocale-3.0.xml"/>
     <Include file="Libs\AceConsole-3.0\AceConsole-3.0.xml"/>
     <Include file="Libs\AceGUI-3.0\AceGUI-3.0.xml"/>
     <Include file="Libs\AceConfig-3.0\AceConfig-3.0.xml"/>
</Ui>
```

### Core.lua

```
WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("WelcomeHome")

local options = {
    name = "WelcomeHome",
    handler = WelcomeHome,
    type = "group",
    args = {
        msg = {
            type = "input",
            name = L["Message"],
            desc = L["The message to be displayed when you get home."],
            usage = L["<Your message>"],
            get = "GetMessage",
            set = "SetMessage",
        },
        showInChat = {
            type = "toggle",
            name = L["Show in Chat"],
            desc = L["Toggles the display of the message in the chat window."],
            get = "IsShowInChat",
            set = "ToggleShowInChat",
        },
        showOnScreen = {
            type = "toggle",
            name = L["Show on Screen"],
            desc = L["Toggles the display of the message on the screen."],
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen",
        },
    },
}

local defaults = {
    profile =  {
        message = L["Welcome Home!"],
        showInChat = false,
        showOnScreen = true,
    },
}

function WelcomeHome:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("WelcomeHomeDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome", "WelcomeHome")
    self:RegisterChatCommand("wh", "ChatCommand")
    self:RegisterChatCommand("welcomehome", "ChatCommand")
end

function WelcomeHome:OnEnable()
    -- Called when the addon is enabled
    self:RegisterEvent("ZONE_CHANGED")
end

function WelcomeHome:ZONE_CHANGED()
    if GetBindLocation() == GetSubZoneText() then
        if self.db.profile.showInChat then
            self:Print(self.db.profile.message)
        end

        if self.db.profile.showOnScreen then
            UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
        end
    end
end

function WelcomeHome:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("wh", "WelcomeHome", input)
    end
end

function WelcomeHome:GetMessage(info)
    return self.db.profile.message
end

function WelcomeHome:SetMessage(info, newValue)
    self.db.profile.message = newValue
end

function WelcomeHome:IsShowInChat(info)
    return self.db.profile.showInChat
end

function WelcomeHome:ToggleShowInChat(info, value)
    self.db.profile.showInChat = value
end

function WelcomeHome:IsShowOnScreen(info)
    return self.db.profile.showOnScreen
end

function WelcomeHome:ToggleShowOnScreen(info, value)
    self.db.profile.showOnScreen = value
end
```

### enUS.lua

```
local L = LibStub("AceLocale-3.0"):NewLocale("WelcomeHome", "enUS", true)

-- Chat commands
L["welcomehome"] = true
L["wh"] = true

L["Welcome Home!"] = true -- default message

L["Message"] = true
L["The message to be displayed when you get home."] = true
L["<Your message>"] = true -- usage

L["Show in Chat"] = true
L["Toggles the display of the message in the chat window."] = true

L["Show on Screen"] = true
L["Toggles the display of the message on the screen."] = true
```

## Attribution

This is an import from [WelcomeHome - Your first Ace3 Addon](https://wowace.gamepedia.com/WelcomeHome_-_Your_first_Ace3_Addon), which is a continuation from [WelcomeHome - Your first Ace2 Addon](https://wowace.gamepedia.com/WelcomeHome_-_Your_first_Ace2_Addon)

## See also

- [Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies "Ace3 for Dummies") \- Shorter version
- [https://github.com/ketho-wow/HelloAce](https://github.com/ketho-wow/HelloAce) \- Example Ace3 template

Retrieved from " [https://warcraft.wiki.gg/wiki/WelcomeHome:\_Your\_first\_Ace3\_Addon?oldid=6049149](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon?oldid=6049149)"

[Category](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [HOWTOs](https://warcraft.wiki.gg/wiki/Category:HOWTOs "Category:HOWTOs")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK