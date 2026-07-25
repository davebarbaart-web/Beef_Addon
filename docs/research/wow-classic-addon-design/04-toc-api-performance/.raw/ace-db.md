[CurseForge](https://www.wowace.com/) [Register](https://www.wowace.com/register?returnUrl=%2fprojects%2face3%2fpages%2fapi%2face-db-3-0) [Sign In](https://www.wowace.com/login?returnUrl=%2fprojects%2face3%2fpages%2fapi%2face-db-3-0)

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


### api/AceDB-3.0

- [Table of Contents](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#)

[X](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0 "Close Table of Contents")

## Table of Contents

- [Example](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-1)

- [AceDB:New(tbl, defaults, defaultProfile)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-2)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-2-1)

  - [Usage](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-2-2)
- [DBObjectLib:CopyProfile(name, silent)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-3)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-3-1)
- [DBObjectLib:DeleteProfile(name, silent)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-4)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-4-1)
- [DBObjectLib:GetCurrentProfile()](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-5)

- [DBObjectLib:GetNamespace(name, silent)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-6)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-6-1)

  - [Return value](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-6-2)

  - [Usage](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-6-3)
- [DBObjectLib:GetProfiles(tbl)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-7)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-7-1)
- [DBObjectLib:RegisterDefaults(defaults)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-8)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-8-1)
- [DBObjectLib:RegisterNamespace(name, defaults)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-9)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-9-1)
- [DBObjectLib:ResetDB(defaultProfile)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-10)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-10-1)
- [DBObjectLib:ResetProfile(noChildren, noCallbacks)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-11)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-11-1)
- [DBObjectLib:SetProfile(name)](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-12)

  - [Parameters](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#title-12-1)

**AceDB-3.0** manages the SavedVariables of your addon.

It offers profile management, smart defaults and namespaces for modules.

Data can be saved in different data-types, depending on its intended usage.
The most common data-type is the \`profile\` type, which allows the user to choose
the active profile, and manage the profiles of all of his characters.

The following data types are available:

- **char** Character-specific data. Every character has its own database.

- **realm** Realm-specific data. All of the players characters on the same realm share this database.

- **class** Class-specific data. All of the players characters of the same class share this database.

- **race** Race-specific data. All of the players characters of the same race share this database.

- **faction** Faction-specific data. All of the players characters of the same faction share this database.

- **factionrealm** Faction and realm specific data. All of the players characters on the same realm and of the same faction share this database.

- **locale** Locale specific data, based on the locale of the players game client.

- **global** Global Data. All characters on the same account share this database.

- **profile** Profile-specific data. All characters using the same profile share this database. The user can control which profile should be used.


Creating a new Database using the \`:New\` function will return a new DBObject. A database will inherit all functions
of the DBObjectLib listed here.

If you create a new namespaced child-database (\`:RegisterNamespace\`), you'll get a DBObject as well, but note
that the child-databases cannot individually change their profile, and are linked to their parents profile - and because of that,
the profile related APIs are not available. Only \`:RegisterDefaults\` and \`:ResetProfile\` are available on child-databases.

For more details on how to use AceDB-3.0, see the [AceDB-3.0 Tutorial](https://www.curseforge.com/wiki/invalid-link/).

You may also be interested in [LibDualSpec-1.0](https://www.curseforge.com/wiki/invalid-link/) to do profile switching automatically when switching specs.

### Example

```
MyAddon = LibStub("AceAddon-3.0"):NewAddon("DBExample")

-- declare defaults to be used in the DB
local defaults = {
  profile = {
    setting = true,
  }
}

function MyAddon:OnInitialize()
  -- Assuming the .toc says ## SavedVariables: MyAddonDB
  self.db = LibStub("AceDB-3.0"):New("MyAddonDB", defaults, true)
end
```

## AceDB:New(tbl, defaults, defaultProfile)

Creates a new database object that can be used to handle database settings and profiles.

By default, an empty DB is created, using a character specific profile.

You can override the default profile used by passing any profile name as the third argument,
or by passing _true_ as the third argument to use a globally shared profile called "Default".

Note that there is no token replacement in the default profile name, passing a defaultProfile as "char"
will use a profile named "char", and not a character-specific profile.

### Parameters

tblThe name of variable, or table to use for the databasedefaultsA table of database defaultsdefaultProfileThe name of the default profile. If not set, a character specific profile will be used as the default.
You can also pass _true_ to use a shared global profile called "Default".

### Usage

```
-- Create an empty DB using a character-specific default profile.
self.db = LibStub("AceDB-3.0"):New("MyAddonDB")
```

```
-- Create a DB using defaults and using a shared default profile
self.db = LibStub("AceDB-3.0"):New("MyAddonDB", defaults, true)
```

## DBObjectLib:CopyProfile(name, silent)

Copies a named profile into the current profile, overwriting any conflicting
settings.

### Parameters

nameThe name of the profile to be copied into the current profilesilentIf true, do not raise an error when the profile does not exist

## DBObjectLib:DeleteProfile(name, silent)

Deletes a named profile.

This profile must not be the active profile.

### Parameters

nameThe name of the profile to be deletedsilentIf true, do not raise an error when the profile does not exist

## DBObjectLib:GetCurrentProfile()

Returns the current profile name used by the database

## DBObjectLib:GetNamespace(name, silent)

Returns an already existing namespace from the database object.

### Parameters

nameThe name of the new namespacesilentif true, the addon is optional, silently return nil if its not found

### Return value

the namespace object if found

### Usage

```
local namespace = self.db:GetNamespace('namespace')
```

## DBObjectLib:GetProfiles(tbl)

Returns a table with the names of the existing profiles in the database.

You can optionally supply a table to re-use for this purpose.

### Parameters

tblA table to store the profile names in (optional)

## DBObjectLib:RegisterDefaults(defaults)

Sets the defaults table for the given database object by clearing any
that are currently set, and then setting the new defaults.

### Parameters

defaultsA table of defaults for this database

## DBObjectLib:RegisterNamespace(name, defaults)

Creates a new database namespace, directly tied to the database.

This
is a full scale database in it's own rights other than the fact that
it cannot control its profile individually

### Parameters

nameThe name of the new namespacedefaultsA table of values to use as defaults

## DBObjectLib:ResetDB(defaultProfile)

Resets the entire database, using the string defaultProfile as the new default
profile.

### Parameters

defaultProfileThe profile name to use as the default

## DBObjectLib:ResetProfile(noChildren, noCallbacks)

Resets the current profile to the default values (if specified).

### Parameters

noChildrenif set to true, the reset will not be populated to the child namespaces of this DB objectnoCallbacksif set to true, won't fire the OnProfileReset callback

## DBObjectLib:SetProfile(name)

Changes the profile of the database and all of it's namespaces to the
supplied named profile

### Parameters

nameThe name of the profile to set as the current profile

* * *

- [\_ForgeUser581183](https://www.wowace.com/members/_forgeuser581183)









[![View _ForgeUser581183's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_70x70.png)](https://www.wowace.com/members/_forgeuser581183)





  - Join Date:


     3/7/2008

  - Posts:


     19

  - Member Details

[#1](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0?comment=1)[\_ForgeUser581183](https://www.wowace.com/members/_forgeuser581183)

  - [View User Profile](https://www.wowace.com/members/_forgeuser581183)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=_ForgeUser581183)

Posted Dec 26, 2010

After registering default options using `:RegisterDefaults(defaults)`, you can return to those defaults with:

```
self.db.ResetProfile();
```

Rollback Post to RevisionRollBack

- [WitherVoice](https://www.wowace.com/members/withervoice)


Curse Premium









[![View WitherVoice's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/10ae4ec4-5a61-4cb0-8c34-afdb9f3c62fc-profile_image-70x70.png)](https://www.wowace.com/members/withervoice)





  - Join Date:


     5/23/2007

  - Posts:


     11

  - Member Details

[#2](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0?comment=2)[WitherVoice](https://www.wowace.com/members/withervoice)

  - [View User Profile](https://www.wowace.com/members/withervoice)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=WitherVoice)

Posted Oct 19, 2018

Is there any out-of-the-box way of getting this amazing piece of code to use the default profile as, well, default, instead of creating a new character-specific one in every case? Or is that up to the implementation in each addon?

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

[#3](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0?comment=3)[Sygon\_Paul](https://www.wowace.com/members/sygon_paul)

  - [View User Profile](https://www.wowace.com/members/sygon_paul)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Sygon_Paul)

Posted Oct 24, 2018

In reply to [WitherVoice](https://www.wowace.com/members/WitherVoice):

As per the documentation above, pass _true_ as the last parameter when creating your defaults.

```
AceDB:New(tbl, defaults, defaultProfile)

-- change defaultProfile to true to create a default profile named Default
```

Rollback Post to RevisionRollBack

- [Aiue\_](https://www.wowace.com/members/aiue_)









[![View Aiue_'s Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/d51e1304-b218-44ed-ac07-d7981055ed8d-profile_image-70x70.png)](https://www.wowace.com/members/aiue_)





  - Join Date:


     12/29/2007

  - Posts:


     29

  - Member Details

[#4](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0?comment=4)[Aiue\_](https://www.wowace.com/members/aiue_)

  - [View User Profile](https://www.wowace.com/members/aiue_)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Aiue_)

Posted Oct 15, 2019

"For more details on how to use AceDB-3.0, see the [AceDB-3.0 Tutorial](https://www.curseforge.com/wiki/invalid-link/)." <\- Points to: [https://www.curseforge.com/wiki/invalid-link/](https://www.curseforge.com/wiki/invalid-link/)

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

[#5](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0?comment=5)[Sygon\_Paul](https://www.wowace.com/members/sygon_paul)

  - [View User Profile](https://www.wowace.com/members/sygon_paul)
  - [Send Message](https://www.wowace.com/private-messages/send?recipient=Sygon_Paul)

Posted Aug 7, 2024

You can use the Blizzard global string DEFAULT when using :ResetDB() to create a locale-agnostic profile named "Default" in any of WoW's languages.

self.db:ResetDB(DEFAULT)

Rollback Post to RevisionRollBack

- To post a comment, please [login](https://www.wowace.com/login?returnUrl=%2fprojects%2face3%2fpages%2fapi%2face-db-3-0) or [register](https://www.wowace.com/register?returnUrl=%2fprojects%2face3%2fpages%2fapi%2face-db-3-0) a new account.

DeleteUndeleteSpamNot SpamMerge

Apply to Selected (0)

[Clear Selected](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0#)

Posts Quoted:

Reply

Clear All Quotes