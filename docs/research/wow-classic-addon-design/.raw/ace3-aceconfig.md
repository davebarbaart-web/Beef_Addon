[CurseForge](https://www.wowace.com/) [Register](https://www.wowace.com/register?returnUrl=%2fprojects%2face3%2fpages%2face-config-3-0-options-tables) [Sign In](https://www.wowace.com/login?returnUrl=%2fprojects%2face3%2fpages%2face-config-3-0-options-tables)

[![](https://media.forgecdn.net/avatars/thumbnails/64/118/62/62/636150154000533476.png)](https://media.forgecdn.net/avatars/64/118/636150154000533476.png)

# [Ace3](https://www.wowace.com/projects/ace3)

## [Addons](https://www.wowace.com/addons)

### Pages

- [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)

- [AceDB-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial)

- [AceGUI-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-gui-3-0-tutorial)

- [AceGUI-3.0 Widgets](https://www.wowace.com/projects/ace3/pages/ace-gui-3-0-widgets)

- [api](https://www.wowace.com/projects/ace3/pages/api)
  - [AceAddon-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0)

  - [AceBucket-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-bucket-3-0)

  - [AceComm-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0)

  - [AceConfig-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0)

  - [AceConfigCmd-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-cmd-3-0)

  - [AceConfigDialog-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0)

  - [AceConfigRegistry-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-registry-3-0)

  - [AceConsole-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0)

  - [AceDB-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0)

  - [AceDBOptions-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-dboptions-3-0)

  - [AceEvent-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0)

  - [AceGUI-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-gui-3-0)

  - [AceHook-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-hook-3-0)

  - [AceLocale-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0)

  - [AceSerializer-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-serializer-3-0)

  - [AceTab-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-tab-3-0)

  - [AceTimer-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-timer-3-0)
- [Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)


### AceConfig-3.0 Options Tables

- [Table of Contents](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#)

[X](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables "Close Table of Contents")

## Table of Contents

- [The Basics](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-1)

- [Common Parameters](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-2)

- [Item Types](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3)

  - [execute](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-1)

  - [input](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-2)

  - [toggle](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-3)

  - [range](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-4)

  - [select](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-5)

  - [multiselect](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-6)

  - [color](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-7)

  - [keybinding](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-8)

  - [header](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-9)

  - [description](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-10)

  - [group](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-3-11)
- [Callback Handling](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4)

  - [Callback Arguments](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1)

  - [Callback Example](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-2)
- [Custom controls](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-5)


The AceOptions table format is a standardized way of representing the commands available to control an addon.

An example table, very minimalistic:

```
myOptionsTable = {
  type = "group",
  args = {
    enable = {
      name = "Enable",
      desc = "Enables / disables the addon",
      type = "toggle",
      set = function(info,val) MyAddon.enabled = val end,
      get = function(info) return MyAddon.enabled end
    },
    moreoptions={
      name = "More Options",
      type = "group",
      args={
        -- more options go here
      }
    }
  }
}
```

## The Basics

Every option table has to start with a head `group` node. It can have a name and an icon, but only the group-type and the `args` table are required.

You can nest groups as deep as you need them to be, and include any options on any level. Of course not everything makes sense from a UI design perspective.

Nearly all parameters can be inherited through the table tree. For example, you can define one `get` handler on the group, and all member nodes (or member nodes of sub-groups) will use this `get` handler, unless overriden.

Currently inherited are: `set, get, func, confirm, validate, disabled, hidden`

The keys used in the option tables can contain all printable chars. If you use spaces in the keys, and intend to use your option table with a Command Line interface like AceConfigCmd-3.0, make sure your keys do not collide, as AceConfigCmd-3.0 maps the spaces to underscores, so "foo bar" and "foo\_bar" would collide.

Most parameters can also be a function reference, which is called when the value is requested. Every function called by AceConfig will be called with an info table as its first parameter. The info table contains information about the current position in the tree, the type of UI displaying the options, and the options table itself.

For more details on the info table, see [Callback Arguments](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1).

## Common Parameters

The following parameters apply to all types of nodes and groups, and control the general layout of the options.

- **name** (string\|function) - Display name for the option
- **desc** (string\|function) - description for the option _(or nil for a self-describing name)_
- **descStyle** (string) - "inline" if you want the description to show below the option in a GUI (rather than as a tooltip). _Currently only supported by AceGUI "Toggle"._
- **validate** (methodname\|function\|false) - validate the input/value before setting it. return a string (error message) to indicate error.
- **confirm**(methodname\|function\|boolean) - prompt for confirmation before changing a value

  - **true** \- display "name - desc", or contents of .confirmText
  - **function** \- return a string (prompt to display) or true (as above), or false to skip the confirmation step
- **order** (number\|methodname\|function) - relative position of item (default = 100, 0=first, -1=last)
- **disabled** (methodname\|function\|boolean) - disabled but visible
- **hidden**(methodname\|function\|boolean) - hidden (but usable if you can get to it, i.e. via commandline)

  - **guiHidden** (boolean) - hide this from graphical UIs (dialog, dropdown)
  - **dialogHidden** (boolean) - hide this from dialog UIs
  - **dropdownHidden** (boolean) - hide this from dropdown UIs
  - **cmdHidden** (boolean)- hide this from commandline
  - Note that only `hidden` can be a function, the specialized hidden cases cannot.
- **icon**(string\|function) - path to icon texture

  - **iconCoords** (table\|methodname\|function) - arguments to pass to SetTexCoord, e.g. {0.1,0.9,0.1,0.9}.
- **handler** (table) - object on which getter/setter functions are called if they are declared as strings rather than function references
- **type** (string) - "execute", "input", "group", etc; see below
- **width**(string) - "double", "half", "full", "normal", or numeric, in a GUI provide a hint for how wide this option needs to be. (optional support in implementations)

  - default is nil (not set)
  - double, half - increase / decrease the size of the option
  - full - make the option the full width of the window
  - normal - use the default widget width defined for the implementation (useful to overwrite widgets that default to "full")
  - any number - multiplier of the default width, ie. 0.5 equals "half", 2.0 equals "double"

## Item Types

### execute

A execute option will simply run 'func'. In a GUI, this would be a button.

If _image_ is set, it'll display a clickable image instead of a default GUI button.

- **func** (function\|methodname) - function to execute
- **image**(string\|function) - path to image texture, if this is a function it can optionally return the width and height of the image as the 2nd and 3rd value, these will be used instead of imageWidth and imageHeight.

  - **imageCoords** (table\|methodname\|function) - arguments to pass to SetTexCoord, e.g. {0.1,0.9,0.1,0.9}.
  - **imageWidth** (number) - Width of the displayed image
  - **imageHeight** (number) - Height of the displayed image

### input

A simple text input, with an optional validate string or function to match the text against.

- **get** (function\|methodname) - getter function
- **set**(function\|methodname) - setter function
- **multiline** (boolean\|integer) - if true will be shown as a multiline editbox in dialog implementations (Integer = # of lines in editbox)
- **pattern** (string) - optional validation pattern. (Use the validate field for more advanced checks!)
- **usage** (string) - usage string (displayed if pattern mismatches and in console help messages)

### toggle

A simple checkbox

- **get** (function\|methodname) - getter function
- **set** (function\|methodname) - setter function
- **tristate** (boolean) - Make the toggle a tri-state checkbox. Values are cycled through unchecked (false), checked (true), greyed (nil) - in that order.

### range

A option for configuring numeric values in a specific range. In a GUI, a slider.

- **min** \- min value
- **max** \- max value
- **softMin** \- "soft" minimal value, used by the UI for a convenient limit while allowing manual input of values up to min/max
- **softMax** \- "soft" maximal value, used by the UI for a convenient limit while allowing manual input of values up to min/max
- **step** \- step value: "smaller than this will break the code" (default=no stepping limit)
- **bigStep** \- a more generally-useful step size. Support in UIs is optional.
- **get** (function\|methodname) - getter function
- **set** (function\|methodname) - setter function
- **isPercent** (boolean) - represent e.g. 1.0 as 100%, etc. (default=false)

**Note**:

The "step" checking will only work if you specify valid values for "min" and "max". Especially when using "softMin" and "softMax", "min" and "max" are still required for "step" to function!

If no "min" or "max" are specified, the manual input of the range control will accept any and all values!

### select

Only one of the values can be selected. In a dropdown menu implementation it would likely be a radio group, in a dialog likely a dropdown combobox.

- **values** (table\|function) - \[key\]=value pair table to choose from, key is the value passed to "set", value is the string displayed
- **sorting** (table\|function) - Optional sorted array-style table with the keys of the values table as values to sort the options.
- **get** (function\|methodname) - getter function
- **set** (function\|methodname) - setter function
- **style** \- "dropdown", "radio" (optional support in implementations)

### multiselect

Basically multiple "toggle" elements condensed into a group of checkboxes, or something else that makes sense in the interface.

- **values** (table\|function) - \[key\]=value pair table to choose from, key is the value passed to "set", value is the string displayed
- **get** (function\|methodname) - will be called for every key in values with the key name as last parameter
- **set** (function\|methodname) - will be called with keyname, state as parameters
- **tristate** (boolean) - Make the checkmarks tri-state. Values are cycled through unchecked (false), checked (true), greyed (nil) - in that order.

### color

Opens a color picker form, in GUI possibly a button to open that.

- **get** (function\|methodname) - getter function
- **set** (function\|methodname) - setter function
- **hasAlpha** (boolean) - indicate if alpha is adjustable (default false)

Getter/setter functions use 4 arguments/returns: r,g,b,a. If hasAlpha is false/nil, alpha will always be set() as 1.0.

### keybinding

- **get** (function\|methodname) - getter function
- **set** (function\|methodname) - setter function

### header

A heading.

In commandline and dropdown UIs shows as a heading, in a dialog UI it will additionaly provide a break in the layout.

- **name** is the text to display in the heading.

### description

A paragraph of text to appear next to other options in the config, optionally with an image in front of it.

- **name** is the text to display
- **fontSize** is the size of the text. Three pre-defined values are allowed: "large", "medium", "small". Defaults to "small".
- **image**(string\|function) - path to image texture, if this is a function it can optionally return the width and height of the image as the 2nd and 3rd value, these will be used instead of imageWidth and imageHeight.

  - **imageCoords** (table\|methodname\|function) - arguments to pass to SetTexCoord, e.g. {0.1,0.9,0.1,0.9}.
  - **imageWidth** (number) - Width of the displayed image
  - **imageHeight** (number) - Height of the displayed image

### group

The first table in an AceOptions table is implicitly a group. You can have more levels of groups by simply adding another table with type="group" under the first args table.

- **args** subtable with more items/groups in it
- **plugins** subtable, containing named tables with more args in them, e.g.

```
plugins["myPlugin"]={
  option1={...}, option2={...}, group1={...} }
plugins["otherPlugin"]={...}
```

This allows modules and libraries to easily add more content to an addon's options table.

- **childGroups**argument, decides how children groups of this group are displayed:

  - "tree" (the default) - as child nodes in a tree control
  - "tab" - as tabs
  - "select" - as a dropdown list

Only dialog-driven UIs are assumed to behave differently for all types.

- **inline**(boolean) - show as a bordered box in a dialog UI, or at the parent's level with a separate heading in commandline and dropdown UIs.

  - **cmdInline** (boolean) - as above, only obeyed by commandline
  - **guiInline** (boolean) - as above, only obeyed by graphical UIs
  - **dropdownInline** (boolean) - as above, only obeyed by dropdown UIs
  - **dialogInline** (boolean) - as above, only obeyed by dialog UIs

## Callback Handling

- For each set/get/func/validate/confirm callback attempted, the tree will ALWAYS be traversed toward the root until such a directive is found. Similarly, if callbacks are given as strings, the tree will be traversed to find a "handler" argument.

- To declare that an inherited value is NOT to be used even though a parent has it, set it to false. This is primarily useful for validate and confirm, but is allowed for all inherited values including "handler".

### Callback Arguments

All callback receive a standardized set of arguments:

`(info, value[, value2, ...]).`

In detail, the info table contains:

- An "options" member pointing at the root of the options table
- The name of the slash command at position 0, or empty string ("") if not a slash.
- The name of the first group traversed into at position 1
- The node name at position n (may be 1 if at the root level)
  - **Hint:** Use info\[#info\] to get the leaf node name, info\[#info-1\] for the parent, and so on!
- An "arg" member if set in the node.
- A "handler" member which is the handler object for the current option.
- A "type" member which is the type of the current option.
- An "option" member pointing at the current option.
- "uiType" and "uiName" members, which are the same as the parameters passed when retrieving the options table from AceConfigRegistry-3.0

The callback may _not_ assume ownership of the infotable. The config parser is assumed to reuse it. It may also contain more members, but these are outside the spec and may change at any time - _do not use information in undocumented infotable members._

! Callbacks on the form handler:"methodname" will of course be passed the handler object as the first ("self") argument.

### Callback Example

```
local function mySetterFunc(info, value)
  db[info[#info]] = value   -- we use the db names in our settings for Zzz
  print("The " .. info[#info] .. " was set to: " .. tostring(value) )
end
```

## Custom controls

You can register a custom control with AceGUI and use it in an AceConfigDialog displayed table. This is currently supported for almost all simple control types, except "select" with style="radio", but not for groups or other complex types.

This method is currently only supported in AceConfigDialog-3.0, using the **dialogControl** attribute.

Example usage with AceGUI-3.0-SharedMediaWidgets:

```
local media = LibStub("LibSharedMedia-3.0")
self.options = {
  type = "group",
  args = {
    texture = {
      type = "select",
      name = "Texture",
      desc = "Set the statusbar texture.",
      values = media:HashTable("statusbar"),
      dialogControl = "LSM30_Statusbar",
    },
  }
}
```

Widget API requred to be implemented by custom AceGUI widgets when used with AceConfigDialog-3.0 (this part of the spec is not finalised)

- **type = 'input'**
  - **:SetDisabled**(disabled)

    - disabled - boolean, whether the control is disabled
  - **:SetLabel**(text)

    - text - string, The name of the option to be displayed
  - **:SetText**(text)

    - text - string, the contents of the EditBox.
  - Callback **OnEnterPressed**(text), fired when the text has changed and should be saved.
- **type = 'select'**
  - **:SetDisabled**(disabled)

    - diasbled - boolean, whether the control is disabled
  - **:SetValue**(value)

    - value - string, The value that is currently selected.
  - **:SetList**(list)

    - list - table, A { value = text } table of the options to be displayed.
  - **:SetLabel**(text)

    - text - string, The name of the option to be displayed
  - Callback **OnValueChanged**(value), fired when a value is selected, this must be a key from the list table.

Both should also fire **OnEnter** and **OnLeave** callbacks for tooltips to work.

* * *

- [\_ForgeUser337058](https://www.wowace.com/members/_forgeuser337058)









[![View _ForgeUser337058's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_70x70.png)](https://www.wowace.com/members/_forgeuser337058)





  - Join Date:


     10/12/2007

  - Posts:


     1

  - Member Details

[#1](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=1)[\_ForgeUser337058](https://www.wowace.com/members/_forgeuser337058)

  - [View User Profile](https://www.wowace.com/members/_forgeuser337058)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=_ForgeUser337058)

Posted Jan 6, 2012

Hi everybody!

Is there a way to influence the text alignment in a select -> dropdown item?
I would like to so something similar to a justifyH = "LEFT" to align the text in the dropdown menu to the left. Is this possible?

Thanks in advance!

Rollback Post to RevisionRollBack

- [Sortul](https://www.wowace.com/members/sortul)


Curse Premium









[![View Sortul's Profile](https://static-cdn.jtvnw.net/user-default-pictures-uv/215b7342-def9-11e9-9a66-784f43822e80-profile_image-70x70.png)](https://www.wowace.com/members/sortul)





  - Join Date:


     1/16/2010

  - Posts:


     9

  - Member Details

[#2](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=2)[Sortul](https://www.wowace.com/members/sortul)

  - [View User Profile](https://www.wowace.com/members/sortul)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Sortul)

Posted Jul 31, 2017

How does the command line/options table handle Localization?

Rollback Post to RevisionRollBack

- [\_ForgeUser17317630](https://www.wowace.com/members/_forgeuser17317630)









[![View _ForgeUser17317630's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_70x70.png)](https://www.wowace.com/members/_forgeuser17317630)





  - Join Date:


     10/7/2014

  - Posts:


     1

  - Member Details

[#3](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=3)[\_ForgeUser17317630](https://www.wowace.com/members/_forgeuser17317630)

  - [View User Profile](https://www.wowace.com/members/_forgeuser17317630)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=_ForgeUser17317630)

Posted Jan 19, 2018

When using groups is it possible to use Blizzards Addon "group"/subpage system? So that there are pages on the very left and not inside the actual config frame.

Rollback Post to RevisionRollBack

- [Forge\_User\_11256823](https://www.wowace.com/members/forge_user_11256823)









[![View Forge_User_11256823's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_70x70.png)](https://www.wowace.com/members/forge_user_11256823)





  - Join Date:


     1/19/2018

  - Posts:


     1

  - Member Details

[#4](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=4)[Forge\_User\_11256823](https://www.wowace.com/members/forge_user_11256823)

  - [View User Profile](https://www.wowace.com/members/forge_user_11256823)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Forge_User_11256823)

Posted Jan 19, 2018

In reply to [Danielps1](https://www.wowace.com/members/Danielps1):

**Figured something out myself: checkout "childGroups" this lets you configure this atleast a bit.**

Rollback Post to RevisionRollBack

- [Charles082986](https://www.wowace.com/members/charles082986)









[![View Charles082986's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/deea0a21-1515-4c44-8d8a-02525b5fe5eb-profile_image-70x70.png)](https://www.wowace.com/members/charles082986)





  - Join Date:


     4/3/2018

  - Posts:


     6

  - Member Details

[#5](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=5)[Charles082986](https://www.wowace.com/members/charles082986)

  - [View User Profile](https://www.wowace.com/members/charles082986)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Charles082986)

Posted May 1, 2018

I'm trying to create a growing list of options.

Each time the "Add New" button is clicked, a new row of options should be added to the end of the table.  I'm not sure how to make a "group" option appear like this, though.

| Item ID | Item Name | Point Value | Hot Item |
| --- | --- | --- | --- |
| 12345 | Dreamleaf | 15 | \[ChkBox\] |

Rollback Post to RevisionRollBack

- [zallanon](https://www.wowace.com/members/zallanon)









[![View zallanon's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/3b69c270-72a4-453f-8b34-57cf2648eb19-profile_image-70x70.jpg)](https://www.wowace.com/members/zallanon)





  - Location:


  - Join Date:


     10/15/2008

  - Posts:


     1

  - Member Details

[#6](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=6)[zallanon](https://www.wowace.com/members/zallanon)

  - [View User Profile](https://www.wowace.com/members/zallanon)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=zallanon)

Posted Aug 11, 2018

Getting an error thrown on login:

Date: 2018-08-11 12:36:13

ID: 1

Error occured in: Global

Count: 1

Message: ..\\AddOns\\Ace3\\AceEvent-3.0\\AceEvent-3.0.lua line 33:

Attempt to register unknown event "TRADE\_SKILL\_UPDATE"

Debug:

(tail call): ?

(tail call): ?

\[C\]: RegisterEvent()

Ace3\\AceEvent-3.0\\AceEvent-3.0.lua:33: OnUsed()

...Ons\\Ace3\\CallbackHandler-1.0\\CallbackHandler-1.0.lua:168: RegisterEvent()

AckisRecipeList\\Core.lua:421:

AckisRecipeList\\Core.lua:416

(tail call): ?

\[C\]: ?

\[string "safecall Dispatcher\[1\]"\]:9:

\[string "safecall Dispatcher\[1\]"\]:5

(tail call): ?

Ace3\\AceAddon-3.0\\AceAddon-3.0.lua:558: EnableAddon()

Ace3\\AceAddon-3.0\\AceAddon-3.0.lua:651:

Ace3\\AceAddon-3.0\\AceAddon-3.0.lua:636

\[C\]: ?

\[C\]: LoadAddOn()

..\\FrameXML\\UIParent.lua:445: UIParentLoadAddOn()

..\\FrameXML\\UIParent.lua:488: CombatLog\_LoadUI()

..\\FrameXML\\UIParent.lua:1193:

..\\FrameXML\\UIParent.lua:1089

\[C\]: ?

Rollback Post to RevisionRollBack

- [Testerle](https://www.wowace.com/members/testerle)


Curse Premium









[![View Testerle's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/29eb5433-1c13-4ebc-8d0a-1a631a07c98e-profile_image-70x70.png)](https://www.wowace.com/members/testerle)





  - Join Date:


     4/15/2013

  - Posts:


     1

  - Member Details

[#7](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=7)[Testerle](https://www.wowace.com/members/testerle)

  - [View User Profile](https://www.wowace.com/members/testerle)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Testerle)

Posted Aug 15, 2018

In reply to [Zallanon](https://www.wowace.com/members/Zallanon):

AckisRecipeList is outdated.

Rollback Post to RevisionRollBack

- [Melenkurion](https://www.wowace.com/members/melenkurion)









[![View Melenkurion's Profile](https://static-cdn.jtvnw.net/user-default-pictures-uv/dbdc9198-def8-11e9-8681-784f43822e80-profile_image-70x70.png)](https://www.wowace.com/members/melenkurion)





  - Location:


     Pasadena

  - Join Date:


     9/13/2008

  - Posts:


     1

  - Member Details

[#8](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=8)[Melenkurion](https://www.wowace.com/members/melenkurion)

  - [View User Profile](https://www.wowace.com/members/melenkurion)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Melenkurion)

Posted Oct 18, 2018

Can't figure out where to post lua errors, so here goes:

Date: 2018-10-18 17:29:48

ID: 3

Error occured in: Global

Count: 1

Message: ..\\AddOns\\Ace3\\AceEvent-3.0\\AceEvent-3.0.lua line 33:

Attempt to register unknown event "TRADE\_SKILL\_UPDATE"

Debug:

\[C\]: RegisterEvent()

Ace3\\AceEvent-3.0\\AceEvent-3.0.lua:33: OnUsed()

...Ons\\Ace3\\CallbackHandler-1.0\\CallbackHandler-1.0.lua:168: RegisterEvent()

AckisRecipeList\\Core.lua:421:

AckisRecipeList\\Core.lua:416

(tail call): ?

\[C\]: ?

\[string "safecall Dispatcher\[1\]"\]:9:

\[string "safecall Dispatcher\[1\]"\]:5

(tail call): ?

Ace3\\AceAddon-3.0\\AceAddon-3.0.lua:558: EnableAddon()

Ace3\\AceAddon-3.0\\AceAddon-3.0.lua:651:

Ace3\\AceAddon-3.0\\AceAddon-3.0.lua:636

\[C\]: ?

\[C\]: LoadAddOn()

..\\FrameXML\\UIParent.lua:446: UIParentLoadAddOn()

..\\FrameXML\\UIParent.lua:565: TimeManager\_LoadUI()

..\\FrameXML\\UIParent.lua:1192:

..\\FrameXML\\UIParent.lua:1090

Locals:

None

AddOns:

Swatter, v8.0.6162 (SwimmingSeadragon)

Ace3, v

AckisRecipeList, v7.3.0.1

AckisRecipeListQuickScan, v7.3.0.1

ACP, vr259

AdvancedInterfaceOptions, v1.2.8

Altoholic, vr190

Atlas, vv1.44.03

AtlasArena, vv1.07.02

AtlasBattlegrounds, vv1.44.00

AtlasBurningCrusade, vv1.44.00

AtlasCataclysm, vv1.44.00

AtlasClassicWoW, vv1.44.00

AtlasClassOrderHalls, vv1.44.00

AtlasDungeonLocs, vv1.44.00

AtlasLegion, vv1.44.00

AtlasMistsofPandaria, vv1.44.00

AtlasOutdoorRaids, vv1.44.00

AtlasScenarios, vv1.44.00

AtlasTransportation, vv1.44.00

AtlasWarlordsofDraenor, vv1.44.00

AtlasWorldEvents, vv3.24

AtlasWrathoftheLichKing, vv1.44.00

AtlasLoot, vv8.08.01

AtlasLootBattleforAzeroth, vv8.08.01

AtlasLootBurningCrusade, vv8.08.01

AtlasLootCataclysm, vv8.08.01

AtlasLootClasses, vv3.1

AtlasLootClassic, vv8.08.01

AtlasLootLegion, vv8.08.01

AtlasLootMistsofPandaria, vv8.08.01

AtlasLootSource, vv0.3

AtlasLootWarlordsofDraenor, vv8.08.01

AtlasLootWrathoftheLichKing, vv8.08.01

AtlasMajorCitiesEnhanced, vv1.16

AucAdvanced, v8.0.6122 (SwimmingSeadragon)

auccheapsearcher, v20180721

AucFilterBasic, v8.0.6149 (SwimmingSeadragon)

AucStatHistogram, v8.0.6151 (SwimmingSeadragon)

AucStatiLevel, v8.0.6155 (SwimmingSeadragon)

AucStatPurchased, v8.0.6152 (SwimmingSeadragon)

AucStatSimple, v8.0.6153 (SwimmingSeadragon)

AucStatStdDev, v8.0.6154 (SwimmingSeadragon)

AucUtilFixAH, v8.0.6156 (SwimmingSeadragon)

AutoTurnIn, v7.0.9

BarrelsOEasy, v1.1.11

BattlePetBreedID, vr179

BeanCounter, v8.0.6157 (SwimmingSeadragon)

CanIMogIt, v8.0.0v1.13

CollectionShop, v3.06

CurrencySorter, v

DataStore, vr65

DataStoreAchievements, vr47

DataStoreAgenda, vr29

DataStoreAuctions, vr50

DataStoreCharacters, vr43

DataStoreContainers, vr59

DataStoreCrafts, vr82

DataStoreCurrencies, vr38

DataStoreGarrisons, vr24

DataStoreInventory, vr53

DataStoreMails, vr52

DataStorePets, vr44

DataStoreQuests, vr46

DataStoreReputations, vr43

DataStoreSpells, vr32

DataStoreStats, vr31

DataStoreTalents, vr61

DBMCore, v8.0.13

DBMDefaultSkin, v

DBMStatusBarTimers, v

DBMVPVEM, v8.0.4

DejaCharacterStats, v800r103

Details, v

DetailsDmgRank, v

DetailsDpsTuning, v

DetailsEncounterDetails, v

DetailsRaidCheck, v

DetailsStreamer, v

DetailsTimeAttack, v

DetailsTinyThreat, v

DetailsVanguard, v

FishingBuddy, v1.9.19

GarrisonCommanderBroker, v3.0.0 1.1.0

GnomeSequencer, v7.3.0.1

Grail, v097

GrailQuestsenUS, v27178

HandyNotes, vv1.5.3

HandyNotesArgus, vv0.10

HandyNotesBattleForAzerothTreasures, v1

HandyNotesBrokenShore, vv1.29

HandyNotesCamelFigurines, v1.3

HandyNotesDraenorTreasures, v1.21

HandyNotesHigherDimensionalLearning, v1

HandyNotesHigherLearning, v8.0.0.0

HandyNotesKosumoth, v1

HandyNotesLegionRaresTreasures, v1.1

HandyNotesLegionTreasures, v1

HandyNotesLorewalkers, v1

HandyNotesLostAndFound, v1

HandyNotesLunarFestival, vv1.5

HandyNotesSpecialNPCsEtc, v1.1.1-Beta

HandyNotesSummerFestival, vv1.5

HandyNotesSuramarLeylines, v1

HandyNotesSuramarTelemancy, v1

HandyNotesTimelessIsleChests, v1.20

HandyNotesTimelessTreasures, v1.0.7

HealBot, v8.0.1.0

HiddenArtifactTracker, v

KeystoneManager, v8.0.2

LibSharedMedia30, v3.0-104

MacroToolkit, vv7.3.0.2

MasterPlanA, vA

MikScrollingBattleText, v5.7.149

MinimalArchaeology, v8.0.12.1

NPCScan, v8.0.1.13

OmniCC, v8.0.9

Outfitter, v5.20.3

Overachiever, v1.0.4

OverachieverCache, v1.0.4

Paste, v1.4.10

PersonalLootHelper, v2.17

PetBattleTeams, v3.3.10

PetTracker, v8.0.6

PetTrackerBreeds, v8.0.6

PetTrackerSwitcher, v8.0.6

PetTrackerUpgrades, v8.0.6

PremadeAutoAccept, v1.0.1

RSA, vr508-Release

RSADruid, v

SavedInstances, v8.0.6

SellJunk, v3.0.16

SharedMedia, v3.1.0-191

SharedMediaAdditionalFonts, v1.0.26

SharedMediaAdditionalSounds, v7.0

SilentWorldQuestOptions, v8.0.1

SilverDragon, vv4.0.13

SilverDragonBattleForAzeroth, vv4.0.13

SilverDragonBurningCrusade, vv4.0.13

SilverDragonCataclysm, vv4.0.13

SilverDragonLegion, vv4.0.13

SilverDragonMists, vv4.0.13

SilverDragonVanilla, vv4.0.13

SilverDragonWarlords, vv4.0.13

SilverDragonWrath, vv4.0.13

Stubby, v8.0.6161 (SwimmingSeadragon)

Titan, v5.14.12.80000

TitanBag, v5.14.12.80000

TitanClock, v5.14.12.80000

TitanGold, v5.14.12.80000

TitanLocation, v5.14.12.80000

TitanLootType, v5.14.12.80000

TitanPerformance, v5.14.12.80000

TitanRepair, v5.14.12.80000

TitanVolume, v5.14.12.80000

TitanXP, v5.14.12.80000

TomTom, vv80001-1.0.2

TradeSkillInfo, vv2.4.1

TransmogShop, v2.01

WorldQuestTracker, v

xanMortarPestle, v3.2

BlizRuntimeLib\_enUS v8.0.1.80000 <none>

(ck=1274)

Rollback Post to RevisionRollBack

- [FranekWoW](https://www.wowace.com/members/franekwow)









[![View FranekWoW's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/6887fc93-8337-4e05-87b5-597d8c3f1a3d-profile_image-70x70.png)](https://www.wowace.com/members/franekwow)





  - Location:


  - Join Date:


     4/17/2008

  - Posts:


     2

  - Member Details

[#9](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=9)[FranekWoW](https://www.wowace.com/members/franekwow)

  - [View User Profile](https://www.wowace.com/members/franekwow)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=FranekWoW)

Posted Dec 22, 2018

It probably sounds silly but I can't figure out how to call a getter from command line? I am doing an example WelcomeHome with Ace3 and have both a getter and a setter in option:

```
local options = {
    name = "MyAddOn",
    handler = MyAddOn,
    type = 'group',
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "The message to be displayed when you get home.",
            usage = "<Your message>",
            get = function(info) return MyAddOn.message end,
            set = function(info, val) MyAddOn.message = val end,
        },
    },
}
```

This addon works fine. I can set a new message by calling a setter: "/ma msg <new message>". I can't display the current message. I tried "/ma msg" but it simply assigns an empty string to "message" var. So I always call a setter when I use command "/ma msg".

Rollback Post to RevisionRollBack

- [Sygon\_Paul](https://www.wowace.com/members/sygon_paul)


Community Moderators









[![View Sygon_Paul's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/cc805114-8c53-47e3-a0d1-936c29221428-profile_image-70x70.png)](https://www.wowace.com/members/sygon_paul)





  - Location:


     Edmonton

  - Join Date:


     5/8/2006

  - Posts:


     462

  - Member Details

[#10](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=10)[Sygon\_Paul](https://www.wowace.com/members/sygon_paul)

  - [View User Profile](https://www.wowace.com/members/sygon_paul)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Sygon_Paul)

Posted Jan 7, 2019

In reply to [Melenkurion](https://www.wowace.com/members/Melenkurion):

Delete AckisRecipeList, both addons. They no longer work, and Blizzard's crafting UI has a tab that shows which recipes you are missing and where to get them. That should get rid of your error.

As for posting errors, see the [Issues tab](https://www.wowace.com/projects/ace3/issues) in the top bar of Ace3's main page? That's the correct place. But your bug/issue is that you have an addon that no longer works which is mucking up the place.

Notes: Added where to enter bug reports.

Last edited by [Sygon\_Paul](https://www.wowace.com/members/sygon_paul): Jan 7, 2019

Rollback Post to RevisionRollBack

- [Kabulla](https://www.wowace.com/members/kabulla)









[![View Kabulla's Profile](https://static-cdn.jtvnw.net/user-default-pictures-uv/ebb84563-db81-4b9c-8940-64ed33ccfc7b-profile_image-70x70.png)](https://www.wowace.com/members/kabulla)





  - Location:


  - Join Date:


     1/12/2006

  - Posts:


     15

  - Member Details

[#11](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=11)[Kabulla](https://www.wowace.com/members/kabulla)

  - [View User Profile](https://www.wowace.com/members/kabulla)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Kabulla)

Posted Sep 9, 2019

Hi and thx for all our work, to start with...

Is there a Ace3 project for classic, taht I might hav missed?

thx again,

Kabulla

Rollback Post to RevisionRollBack

- [Sygon\_Paul](https://www.wowace.com/members/sygon_paul)


Community Moderators









[![View Sygon_Paul's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/cc805114-8c53-47e3-a0d1-936c29221428-profile_image-70x70.png)](https://www.wowace.com/members/sygon_paul)





  - Location:


     Edmonton

  - Join Date:


     5/8/2006

  - Posts:


     462

  - Member Details

[#12](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=12)[Sygon\_Paul](https://www.wowace.com/members/sygon_paul)

  - [View User Profile](https://www.wowace.com/members/sygon_paul)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Sygon_Paul)

Posted Oct 10, 2019

In reply to [Kabulla](https://www.wowace.com/members/kabulla):

There is not a seperate Ace3 for Classic. Use the current one.

Rollback Post to RevisionRollBack

- [bsmorgan](https://www.wowace.com/members/bsmorgan)


Curse Premium









[![View bsmorgan's Profile](https://static-cdn.jtvnw.net/user-default-pictures-uv/ce57700a-def9-11e9-842d-784f43822e80-profile_image-70x70.png)](https://www.wowace.com/members/bsmorgan)





  - Location:


     Colorado Springs

  - Join Date:


     2/25/2005

  - Posts:


     576

  - Member Details

[#13](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=13)[bsmorgan](https://www.wowace.com/members/bsmorgan)

  - [View User Profile](https://www.wowace.com/members/bsmorgan)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=bsmorgan)

Posted Oct 12, 2019

I have a couple of sliders (type = "range") for which I'd like to set a default value so the first time they are displayed, they show the default.

For type = "toggle", I can set the value and the first time the options are displayed, they reflect that value. I looked in the documentation and didn't find an answer.

Rollback Post to RevisionRollBack

- [jlelz](https://www.wowace.com/members/jlelz)









[![View jlelz's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/a6f06a70-9d7d-4735-9d9d-95f6fd29dd45-profile_image-70x70.png)](https://www.wowace.com/members/jlelz)





  - Join Date:


     9/30/2019

  - Posts:


     1

  - Member Details

[#14](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables?comment=14)[jlelz](https://www.wowace.com/members/jlelz)

  - [View User Profile](https://www.wowace.com/members/jlelz)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=jlelz)

Posted Jun 23, 2023

In reply to [bsmorgan](https://www.wowace.com/members/bsmorgan):

clearly it's been some years since this was posted. prob few will have this issue but...

the reason this happens is that there is a mismatch in the datatype coming from the get function, as relates to the min,max values.

in other words.. when dealing with range widget, min,max and get() value need to be the same data type.

example:

if your min and max are both integers

and your get() returns a string

a default value will not be displayed in the widget

Rollback Post to RevisionRollBack

- To post a comment, please [login](https://www.wowace.com/login?returnUrl=%2fprojects%2face3%2fpages%2face-config-3-0-options-tables) or [register](https://www.wowace.com/register?returnUrl=%2fprojects%2face3%2fpages%2face-config-3-0-options-tables) a new account.

DeleteUndeleteSpamNot SpamMerge

Apply to Selected (0)

[Clear Selected](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#)

Posts Quoted:

Reply

Clear All Quotes