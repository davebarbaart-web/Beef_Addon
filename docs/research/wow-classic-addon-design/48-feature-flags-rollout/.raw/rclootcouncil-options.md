# Source: https://rclootcouncil.com/wiki/Options

Frontpage feedback

# Options  
Access:

* `/rc config` or `/rc c`
* or through Interface -> AddOns

Contains descriptions of every option in RCLootCouncil. Each option is named after its' (english) in-game name so it's easily searchable. All major categories also have direct links below:

### Table of Contents

General Settings

* General
  
    + General
    + Buttons
    + Response
    + Frame Options
    + Loot History
* Appearance
  
    + Skins
    + Customize Appearance
* Profile

Master Looter Options

* General
  
    + Looting Options
    + Voting Options
    + Ignore Options
* Awards
  
    + Auto Award
    + Auto Award BoE's
    + Award Reasons
* Announcements
  
    + Award Announcement
    + Announce Considerations
* Buttons and Responses
  
    + Buttons and Responses
    + Additional Buttons
    + Timeout
    + More Info
    + Reponse from chat
* Council
  
    + Current Council
    + Add Council
    + Group Council Members

## General Settings

Most of these settings are personal options with no importance for the rest of the group. These settings are not shared with the group when you're the master looter.

#### General

* **Active**  
  Enabled by default. Disabling this will turn off RCLootCouncil for all intents and purposes, meaning you won't receive any loot requests or other visual indications of RCLootCouncil being active. Background stuff like version syncing are still active. If used in a raid group, a "Disabled" response is sent to the master looter whenever a loot session is started. This option is reset on every logout/reload. If you're the Master Looter this is the only way of turning off automatic handling of loot.
* _Classic only: Some options remain here in the Classic version that has been moved to frame options in retail._
* **Append realm names**  
  Disabled by default. When enabled, all player names not from your own realm will be displayed as "player-realm". When disabled, only the player name is shown.
* **Use /rc**  
  Enabled by default. When disabled, RCLootCouncil no longer registers its chat commands on `/rc` , meaning it can be used for ready check. RCLootCouncil commands are still available with `/rclc` . Note: changing this requires a `/reload` to take effect.

#### Buttons

* **Test**  
  Clicking this is the same as doing "/rc test 3". The usual restrictions apply.
* **Version Check**  
  A shortcut for "/rc version" - opens the version frame. See Version Checker .
* **Sync**  
  A shortcut for "/rc sync" - opens the synchronizer frame. See Synchronizer

#### Response

* **Auto Pass**  
  Enabled by default. When enabled, any item that can't be used by your class will be auto passed on. Essentially it's the same as clicking "Pass" on those items, only it's automatic and shows up as "autopass" in the voting frame.
* **Auto Pass Trinkets**  
  Enabled by default. When enabled, any trinket your class cannot use (according to the Dungeon Journal) is auto passed. If disabled, trinkets are never auto passed.
* **Silent Auto Pass**  
  Disabled by default. When enabled, you won't get a message when an item is auto passed.
* **Auto pass BoE**  
  Enabled by default. When enabled, all Bind on Equip items will get auto passed like any other item. If disabled, BoE items will never get auto passed.
* **Print Responses**  
  Disabled by default. When enabled, any time you click a response in the loot frame, that response is also printed to the chat.
* **Guild Groups Only** _Retail Only_  
  Enabled by default. When enabled, RCLootCouncil will only automatically pass group loot items if you're currently in a guild group, i.e more than 80% of the raid members are in your guild, or 60% of party members.
  
  If you want to use RCLootCouncil in non guild groups, everyone in your raid will need to disable this option!

#### Frame options

* **Auto Open**  
  Enabled by default. When enabled, any time a session starts the voting frame will automatically open, provided the master looter has allowed you it. Otherwise a message is displayed, letting you know a session has begun, and the voting frame can be opened with "/rc open".
* **Auto Close**  
  Disabled by default. When enabled, the voting frame will close automatically when the master looter ends the session, i.e. when the last item is awarded.
* **Minimize in combat**  
  Disabled by default. When enabled, all RCLootCouncil frames will automatically be minimized when entering combat. Frames will be maximized again once combat ends.
* **Auto Trade**  
  Disabled by default. When enabled, items are automatically added to the trade window whenever you trade with a candidate that has won an item currently sitting in your inventory. If disabled, you'll get a popup asking for permission to add the item(s) whenever you open a trade window with the winner.
* **Spec Icon** _Retail Only_  
  Disabled by default. When enabled, the class icon in the voting frame is replaced with an icon of the candidates' current specialization.
* **Chat Frame**  
  Select which chat frame you want RCLootCouncil to send messages to. The default is your main chatframe.

#### Loot History

Unlike most settings here, which are bound to a specific Ace3 profile , the loot history stores its data on a faction-realm profile. This means every character on the same realm and faction shares the same loot history , and it cannot be changed through the profile section.

* **Enable Loot History**  
  Enabled by default. When enabled, any award handled with RCLootCouncil is registered and saved in the loot history , whenever the master looter sends it. The actual data is stored in the RCLootCouncil Saved Variables file.
* **Send History**  
  Enabled by default. When enabled, sends out loot history data when ever you award an item as the master looter. Requires "Enable Loot History" to be enabled to function. This does nothing for non master looters. As master looter, you can disable this to only track loot history locally.
* **Send to Guild**  
  Disabled by default. When enabled, this will send all history entries (created when awarding) to your guild members instead of the group members. This allows you to have a combined guild loot history (e.g. if your guild runs two raid groups). The downside is any non-guildmember won't receive the history.
* **Open the Loot History**  
  A shortcut for "/rc history" \- opens the loot history.
* **Clear Loot History**  
  Clicking this will clear the entire loot history. Doing this is not recoverable, and thus it has a confirmation pop-up.
* **Mass Deletion**  
  This is covered in the Loot History Module .

## Appearance

These settings are purely cosmetic and personal, and are not shared with the group.

#### Skins

Any changes to skins are immidiately applied, so it's helpful to have a frame open (such as the version frame, "/rc v") to see the changes.

* **Skins**  
  Contains a list of the default and user created skins. Selecting one will switch every RCLootCouncil frame to use that skin. Skins are a term of a collection of background and borer textures and colors. The currently selected skin is editable using the options below.
* **Save Skin**  
  Saves the currently selected textures and colors as a skin. Any changes must be saved, otherwise they are lost when logging out. Already saved skins are overwritten if the same name is given.
* **Delete Skin**  
  Clicking this will delete the currently selected skin from the list. This cannot be undone, and thus has a confirmation pop-up.
* **Reset Skins**  
  This will reset all default skins to their default appearance. Has confirmation pop-up. Note: this will not remove or alter any user created skins.

#### Customize appearance

Texture files are gathered through LibSharedMedia-3.0. This means other addons can have provided some of the textures, which will also remove them again should said addon be removed.

* **Background** and **Background Color**  
  Select a background and its' color to use in your skin. Note: some backgrounds accepts colors better than others.
* **Border** and **Border Color**  
  Select a border and its' color to use in your skin.
* **Reset**  
  Reverts the skin back to how it looked when it was last saved.

## Profile

Standard Ace3 profile selection. Note: any changes here does not affect the loot history. Changing most of these will trigger a UI reload.

* **Reset Profile**  
  Resets the current selected profile to the default settings. This will effectively reset all changes made to options in RCLootCouncil and any modules storing data within the same profile (which most do).
* **New**  
  Creates a new profile using default settings.
* **Existing Profiles**  
  Switch between profiles. Every option, except the loot history itself, described on this page is bound to this profile.
* **Copy from**  
  Select a profile to copy into your "Current Profile". This will overwrite everything in your "Current Profile".
* **Delete a Profile**  
  Deletes your "Current Profile". This is irreversible, use with caution. Has confirmation.

# Master Looter

The majority of these settings determines the layout and permissions for everyone in the group. Changing these will only have an effect when you're the master looter. Note, your settings are only temporarily copied to the group - nothing will be overwritten on their end (use the synchronizer for that).

## General

* **Usage**  
  Choose when you want to use RCLootCouncil. In this section, "use" and "enabled" refers to when to handle dropped loot. 3 options are available:
  
    + _Ask me every time Group Loot is enabled_ \- default. Will produce a pop-up asking if you want to use RCLootCouncil any time you're in a group and enter an instance.
    + _Always use RCLootCouncil with Group Loot_ \- automatically enables RCLootCouncil whenever you're the group leader in an instance with Group Loot enabled, i.e. all raids. A message is still printed as a reminder when RCLootCouncil is enabled.
    + _Never use RCLootCouncil_ \- selecting this will never prompt you to start using RCLootCouncil. Currently there's no way to use RCLootCouncil with this selected.
* **Only use in raids**  
  Enabled by default. Selecting this will only make the above settings apply when you're in a raid group. _This has nothing to do with raid instances, only the fact that your group has been converted to a raid._
  
  Note neither of these options directly disables RCLootCouncil at any point, and most features are always useable. It's even possible to render these usage options irrelevant depending on other selected options.
* **Out of Raid Support**  
  Disabled by default. When enabled, any time you're in group with 8 people or more, anyone outside of an instance will automatically send a "Out of Raid" response, as they would not be eligible for the loot. Enabling this basically prevents you from awarding items outside an instance, including test sessions(!), but is useful if you frequently have players sit outside the raid.

#### _Classic_

* **Usage**  
  In the Classic version, these options are shown instead:
  
    + _Ask me every time I become Master Looter_ \- default. Will produce a pop-up asking if you want to use RCLootCouncil any time you become Master Looter.
    + _Always use RCLootCouncil when I'm Master Looter_ \- automatically enables RCLootCouncil whenever you become the Master Looter. A message is still printed as a reminder when RCLootCouncil is enabled.
    + _Never use RCLootCouncil_ \- selecting this will never prompt you to start using RCLootCouncil. Currently there's no way to use RCLootCouncil with this selected.
* **Leader Usage**  
  Enabled by default. Selecting this will make the above selection also apply when you're the group leader and enter a raid instance. E.g. " _Ask me every time I become Master Looter_ " essentially becomes " _Ask me every time I'm group leader and enter a raid_ ". This is in addition to the "Usage" setting, not a replacement - i.e. ask me when I'm master looter OR enter a raid as leader.
* **Use with Group Loot**  
  Disabled by default. Allows you to use RCLootCouncil with the group loot loot method when enabled. The Group Leader acts as the Master Looter for all intents and purposes with this enabled, and will still need to loot all corpses to have loot added, but otherwise the addon works as with Master Loot. The only real difference is that nothing is given out or marked for trading when items are awarded - basically relying on raiders pressing the correct group loot button after an award. Awards are recorded as is, and ensuring that items actually goes to the right candidate is your group's responsibility.

#### Looting Options

Most of these settings only applies when RCLootCouncil handles loot, as per the settings above. As a reminder, a session refers to a set of items being rolled on and voted for. A session is started by the master looter, and only then will people see the loot frame and councilmembers the voting frame. _Note: "Auto Award" is not affeted by these options._

* **Skip Session Frame**  
  _Named **Auto Start** in Classic._  
  Disabled by default. When enabled, this will essentially skip the session frame step, and start a session with all eligible items. When disabled, you'll see the session frame with an editable list of items before starting the session. See also: Session Setup .
* **Alt click Looting** _Classic only_  
  Enabled by default. When enabled, this allows you to add items from the WoW loot list by holding ALT and clicking on an item. Items are added to the session frame, and it can only be done before a session is started. The session frame doesn't need to be shown for this to work, but it only works on items in the WoW loot list - use "/rc add" for other items.
* **Sort Items**  
  Enabled by default. When enabled, items in the session frame are sorted as they are added to the list, which will be the order they appear in the loot- and voting frame. If disabled, items are added in the order they are dropped. Items are sorted according to:
  
    1. equipment slot: head, neck, ...
    2. trinket category name
    3. subType: junk(armor token), plate, mail, ...
    4. relicType: Arcane, Life, ..
    5. Item level from high to low
    6. The sum of item stats; items with bonuses(socket, leech, etc) are sorted first.
    7. Item name
* **Auto Add Items**  
  _Named **Auto Loot** in Classic._  
  Enabled by default. When enabled, this will automatically gather all eligible items and either add them to the session frame, or start a session, depending on the "Auto Start" setting. If disabled, nothing will happen when you open a loot list - in which case "Alt click Looting" is recommended.
* **Loot Everything** _Classic Only_  
  Enabled by default. "Auto Loot" only handles wearable items, but by enabling this, non-wearables are also handled. These include Tier tokens, relics, mounts, reagents and more.
* **Auto Add BoEs**  
  _Name **Autoloot BoE** in Classic._  
  Enabled by default. When enabled, Bind on Equip items are handled like any other item. Disable if you never want them handled automatically.
* **Trade Messages** _Retail Only_  
  Enabled by default. When enabled, RCLootCouncil will print a confirmation to the chat window whenever a candidate succesfully trades an item to the winner.
* **Allow Keeping** _Retail Only_  
  Disabled by default. When enabled, RCLootCouncil will ask a candidate if they want to keep any tradeable item they receive via a popup. If they click yes, the item is not added to the session, otherwise the item is added as normal.
* **Award Later**  
  Disabled by default. When enabled, "Award Later" in the session frame is automatically checked.
* **Auto Group Loot** _Retail Only_  
  Enabled by default. When enabled, all group members will automatically pass on group loot while you as the Master Looter automatically greeds on all group loot. This causes all loot to almost immediately end up in your bags from where a session can be started. When disabled, RCLootCouncil doesn't do anything and everyone will see the normal group loot interface.

#### Voting Options

As a reminder, the Master Looter is always considered part of the council.

* **Self Vote**  
  Enabled by default. When enabled, this allows council members to vote for themselves. If disabled, no one can ever vote on themselves.
* **Multi Vote**  
  Enabled by default. When enabled, council members have an unlimited number of votes. If disabled, every one can only vote once per item.
* **Notes** _Classic Only_  
  Enabled by default. Enables candidates to attach a note to their roll that can be seen in the voting frame.
* **Anonymous Voting**  
  Disabled by default. When enabled, council members won't be able to see who has voted on a candidate when hovering over the number of votes.
* **ML Sees voting**  
  Disabled by default. Requires "Anonymous Voting". When enabled, this allows the Master Looter only to see who has voted on a particular candidate, but not anyone else.
* **Hide Votes**  
  Disabled by default. When enabled, council members will not be able to see the number of votes before they have voted themselves. This is done per item, so council members will have to vote at least once to see votes on a particular item. This does not prevent them from seeing how many (upper right) have voted.
* **Observe**  
  Disabled by default. When enabled, this allows non council members to see the voting frame like a regular council member, except it doesn't them to vote. When disabled, only council members are able to open or see the voting frame.
* **Add Rolls**  
  Disabled by default. When enabled, this will automatically add 1-100 random rolls to all items in a session. This is the equivalent of clicking "Add Rolls" in the right click menu on all items. Multiple copies of the same item receive the same roll - otherwise each item gets a different roll, and all rolls are sent to the council. The rolls themselves are the same as each candidate doing a "/roll" except they are guaranteed to be different so ties are impossible.
* **Require Notes**  
  Disabled by default. When enabled, this will require candidates to put a note on all their responses via the Loot Frame. If they don't, the roll won't be registered; the Loot Frame will stay open, and a message will tell them what went wrong. The `pass` button is exempt from the rule.

#### Ignore Options

These items will never be handled automatically.

* **Add Item**  
  Adds an item to list of ignored items. This input can be either an itemID, item name, item string, or item link - anything that's accepted by [`GetItemInfoInstant`](https://wow.gamepedia.com/API_GetItemInfoInstant) .
* **Ignore List**  
  The list of ignored items. Click an item to remove it. This list might not be cached when first opened - if that happens, switch to another tab and back again, and they should all appear normally.

## Awards

#### Auto Award

Most of these settings are hidden if the group is disabled.

* **Auto Award**  
  Disabled by default. When enabled, this allows you to automatically give out any equipable items. Do be careful, as auto awards are done instantly without any confirmation.
* **Quality Limits**  
  These control the quality an item must have to be auto awarded. Both limits are included, meaning to automatically give out only _rare_ items (blue) both the upper and lower limit should be set to rare. The group's loot threshold will automatically be lowered when RCLootCouncil is handling loot if required.  
  _Note: Poor and Common (grey and white) items cannot be auto awarded to anyone but yourself due to Blizzard restrictions._
* **Auto Award to**  
  Determines who should receive auto awards. A list of current group members are displayed when in a group, otherwise you must input the recipients name manually.
* **Reason**  
  This is the reason used in the loot history and/or when announcing the award. This is selected among the Award Reasons .

#### Auto Award Reputation Items

**_Classic Only_**  
Basically the same as Auto Award but for reputation items such as Coins and Bijous from Zul'Gurub.

* **Auto Award Reputation Items**  
  Disabled by default. Enable to automatically award reputation items.
* **Mode**  
  The method to use when awarding reputation items. There's currently two modes available:
  
    1. **Personal**  
         This is basically a copy of auto awards where you chose a candidate to receive all the items. A seperate `Auto Award To` input box for selecting the candidate appears when this is selected.
    2. **Round Robin**  
         Selecting this mode will distribute the items in a round robin fashion, ensuring all candidates receives one item before anyone receives their second. Note that all items are considered to be of equal value, i.e. there's no difference between receiving Zul'Gurub coins or bijous.
* **Reason**  
  The reason used when auto awarding reputation items. You may want to create a new one below for this.

#### Auto Award BoE's

Mostly the same as Auto Award , except this will only auto award BoE (Bind on Equip) items that are epic (purple colored), Equippable and not a bag. It's independent of the normal auto award, and will be handled first in case the item fits both categories.

_Retail_ \- Note this works whether you've enabled Auto Loot BoE options or not.

* **Auto Awards BoE's**  
  Disabled by default. When enabled, the below options become available.
* **Auto Award To**  
  Determines who should receive BoE auto awards. A list of current group members are displayed when in a group, otherwise you must input the recipients name manually.
* **Reason**  
  This is the reason used in the loot history and/or when announcing the award. This is selected among the Award Reasons .

#### Award Reasons

This is a list of separate award reasons that can be used instead of the normal responses. This allows you to setup reasons that only the Master Looter can choose from, and chose if it should be logged in the loot history. It also determines which reason should be used when clicking the disenchant button.

* **Number of Reasons**  
  Change the number of award reasons you want, up to 10. Defaults to 3.

Each reason has its' own line of options, each controlling only that reason:

1. **Name**  
   The name of this reason as it will appear in menus and the loot history.
2. **Color**  
   The color of the name.
3. **Log**  
   If checked, this reason will be saved in the loot history when ever an item is awarded using it. If unchecked, it'll never get saved.
4. **Disenchant**  
   If checked, this is the reason used when awarded items with the disenchant button in the voting frame. Only one reason can be selected for this.
5. **Move up**  
   Moves the row 1 line up.
6. **Move down**  
   Moves the row 1 line down.

* **Reset**  
  Resets all Award Reasons options back to default. Has confirmation pop-up.

## Announcements

Most of these settings are hidden if the group is disabled.

#### Award Announcement

* **Announce Awards**  
  Enabled by default. When enabled, this will announce when you award an item according to the settings below. You can announce in up to two different channels at once - each with a different text, if required. Disable to never announce awards.
* **Channels**  
  Select which channel to announce in or "None" to disable. "Group" is a dynamic option that will output to a channel relevant to your current group (party or raid). The "Chat" options simply outputs to your own chat. The message will be printed to your chat if the channel is invalid at the time of announcement. Do note the message will be sent directly as if you wrote it yourself.
* **Message**  
  The message to send to the channel when awarding items. There's a handful of keyword substitutions available - each will be replaced with the following:
  
    + & **i** \- item link of the awarded item.
    + & **l** \- item level of the item.
    + & **p** \- name of the player receiving the loot.
    + & **r** \- reason or response the item was awarded for.
    + & **s** \- session id, order of the item in the voting frame.
    + & **t** \- item type, as shown in the voting frame.
    + & **n** \- roll, if rolls were added to that session.
    + & **o** \- the original owner of the item.
    + & **m** \- the winner's supplied note, or "none".

#### Announce Considerations

* **Announce Considerations**  
  Disabled by default. When enabled, this will announce the items in a session when it starts. This is constructed of two things: a "header" message followed by a message for each item.
* **Channel**  
  As above - see Award Announcement .
* **Message**  
  The header message. This is the first message that's sent.
* **Message for each item**  
  After the header a message for each item is sent according to the order in the voting frame. The following keyword substitutions are available:
  
    + & **s** \- session id, order of the item in the voting frame.
    + & **i** \- item link of the awarded item.
    + & **l** \- item level of the item.
    + & **t** \- item type, as shown in the voting frame.
* **Reset**  
  This will reset all announcements options to their default values. Has confirmation pop-up.

## Buttons and Responses

Each response is paired with a button.
You have a set of buttons (max 10) available for a number of different loot slots and categories. You can customize each of these buttons are their response as you like. Each category also have a predefined pass button that can't be altered, and will always be furthest to the right in the loot frame.

#### Buttons and Responses

This is the default category for items that doesn't have their own.

* **Number of buttons**  
  Choose how many buttons you want in this category, up to 10.

Each button has it's own line and the order determines the order on the loot frame (left to right) as well as the sorting order anywhere else. Each button has the following settings:

1. **Button**  
   The text that will appear on the loot frame buttons. Should be kept short to avoid making the loot frame unnecessary wide.
2. **Response color**  
   The color responses will have anywhere the response appears.
3. **Response**  
   The response text. Unlike the button text, this is the result of pressing the button, i.e. what's shown in the voting frame. This should resemble the button text, but can be longer as there's more room for it.
4. **Move Up**  
   Moves the row 1 line up.
5. **Move Down**  
   moves the row 1 line down.

#### Additional Buttons

This section allows you to add different buttons and responses for a specific type of items. This is evaluated by the item's inventory slot type - these are pretty self explanatory - however you also have two groups of slot types available; _Azerite Armor_ and _Weapons_ .

_Azerite Armor_ is basically head, shoulder, and chest slot combined, and if enabled all of these item types will use these buttons.

_Weapons_ include all one-handed and two-handed weapons, but not off hands only items.

**Note:** if you specify multiple slots an item can fit, e.g. head and Azerite Armor, the most specific slots' buttons are chosen, in this case the head slot. All items use the default buttons and responses if no additional buttons have been created.

* **Slot**  
  The item slot for which you want to add specific buttons to.
* **Add Button**  
  Click to add a new section of options for the selected slot.

All of the additional buttons follows the exact same layout as the normal buttons, with the exception of the added _Remove_ button to the section, which simply removes the additional buttons. All additional buttons and responses are also generically blank when created.

#### Timeout

* **Enable Timeout**  
  Enabled by default. When enabled, items appearing in the loot frame will have a timer. Candidates must respond before this runs out, or their response will be marked as "Timeout". If disabled, the loot frame will never time out.
* **Length**  
  The length of the timeout - changeable in 5 second steps, from 0 to 200. While 0 seconds is allowed (and will result in an instant timeout for everyone) do consider candidates needs time to respond, and with up to 5 items at a time, that could be a while. I do not recommend less than 30 seconds.

#### More Info

"More Info" is the name of the latest award history in the voting frame, which shows the latest 5 items received by the selected candidate, filtered by responses. This is the options for that filter.

* **Number of Responses**  
  This controls which responses should show up in the more info. The number is tied to the order of the responses in the "Buttons and Responses" section, i.e. selecting 1 will only show awards that matches the first response in either button category (by default that means _"MainSpec/Need"_ ). Selecting 2 will show awards matching the first two responses in each category, and so on

#### Response from chat

* **Accept whispers**  
  Enabled by default. When enabled, players can also whisper the Master Looter to add their info to the voting frame. Primarily intended for people that hasn't installed the addon for any reason, but it could replace the loot frame entirely. By default, only a candidates name, class and role are available in the voting frame - the rest (spec, guildrank, response, ilvl and items) are sent by the addon. A player without RCLootCouncil installed can have their response added to the voting frame by whispering the Master Looter with the following syntax:
  
  `session response [item1][item2]`
  
  Here's a break down of what that means:
  
    + **Session**  
        _Mandatory_ . Indicates which session (item) the response belongs to. This number corresponds to the order of items in the voting frame, and the session id from "Announce Considerations" .
    + **Response**  
        _Optional_ . If this isn't provided, the response will be registered as the first response in the category, i.e. "MainSpec/Need" by default. This response can be replaced with any of the keywords the Master Looter has chosen for a particular response. By default this includes numbers for each response (1: MainSpec/Need, 2: OffSpec/Greed, 3: Minor Upgrade), and shorthands like "need" and "greed". Passing is not possible - just don't respond.
    + **[item1]** & **[item2]**  
        _Optional_ . Your current gear that the item you're rolling for will replace. While optional, these should really be provided, as that it's the only way council members can see what item you're currently wearing - not supplying it most likely means no loot. This is the itemlink produced by shift-clicking an item.
  
  A player can always whisper `rchelp` to the Master Looter for a quick overview of this, along with a list of the available responses and their meanings.
* **Examples**  
  Assuming Potdisc is the Master Looter and using default settings:
  
    + `/w Potdisc 1`  
        Sets your response for session 1 as "MainSpec/Need", and your currently equipped item will not be sent.
    + `/w Potdisc 2 [Some_Item]`  
        Sets your response for session 2 as "MainSpec/Need" and shows your [Some\_Item] in the voting frame.
    + `/w Potdisc 1 3`  
        Sets your response for session 1 as "Minor Upgrade" without showing your current equipped item.
    + `/w Potdisc 4 greed [Some_Item1]\[Some_Item2]`  
        Sets your response for session 4 as "Offspec/Greed" and shows both your [Some\_Item1] and [Some\_Item2] in the voting frame.
        
        This of cause also works for tier tokens and relics (if those are enabled), e.g. a tier token drops, `/w Potdisc 1 1` would set the response for session 1 as the first button in the tier tokens category ("4 Piece" by default). Note: Tier tokens and relics share the same keywords as the normal loot buttons.
* **Keywords** The list of keywords used to transform a simple keyword into a response equal to clicking a button in the loot frame. There's one entry for each button, and each entry can have as many keywords as you want. Only A-Z, a-z and 0-9 is accepted as keywords - anything else is considered a separation between keywords.

## Council

#### Current Council

* **Current Council**  
  Shows a list of the current council members. Click on one to remove said council member from the council. Do note that council members should be set before starting a session, but are otherwise updated immediately.
* **Remove All**  
  Click to remove all council members. Has confirmation.

#### Add Council

From here you can add council members from your guild. You can either add specific members, or add all members at or above a specific guild rank.

* **Add Ranks**  
  All your guild ranks are present in the dropdown menu. Select a rank to add all members from that rank _and above_ to the council. You can verify they have been added by selecting a rank from the side list and see all members have a checkmark, or just check the "Current Council" tab .
* **Specific Rank**  
  Each guild rank is listed on the left, and clicking either will show the members of that rank, and whether they're a member of the council (as indicated by a checkmark). Click on any member to remove them from the council.

#### Group Council Members

A list of everyone in your current group. This shows you the council members in your current group, and allows you to quickly edit your council without going through specific guild ranks. This is also the only way to add non guild members to the council.

**RCLootCouncil**

* [Addon](https://www.curseforge.com/wow/addons/rclootcouncil)
* History Explorer
* [Wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki)
* **Modules**
* [RCLootCouncil - GroupGear](https://www.curseforge.com/wow/addons/rclootcouncil-groupgear)
* [RCLootCouncil - ExtraUtilities](https://www.curseforge.com/wow/addons/rclootcouncil-extrautilities)
* [RCLootCouncil - Classic](https://www.curseforge.com/wow/addons/rclootcouncil-classic/)

**Community** [Curseforge](https://www.curseforge.com/wow/addons/rclootcouncil) [Discord](http://discord.rclootcouncil.com) [Github](https://github.com/evil-morfar/RCLootCouncil2) [Become a Patron](https://www.patreon.com/bePatron?u=22734500)

World of Warcraft, Warcraft and Blizzard Entertainment are trademarks or registered trademarks of Blizzard Entertainment, Inc.

RCLootCouncil is not affiliated with Blizzard.
