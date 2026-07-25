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

# C\_ChatInfo.SendAddonMessage

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

|     |     |
| --- | --- |
| ![Fat cat yearns for the mines](https://warcraft.wiki.gg/images/thumb/Fatcat_miner.png/64px-Fatcat_miner.png?82abc0) | The API wiki is under maintenance<br>Since `2026-07-23T06:08:00Z`, ETA: at least multiple days |

## Contents

- [1Arguments](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Arguments)
- [2Returns](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Returns)
- [3Chat types](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Chat_types)
- [4Details](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Details)
  - [4.1C\_ChatInfo.SendAddonMessageLogged](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#C_ChatInfo.SendAddonMessageLogged)
- [5Message throttling](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Message_throttling)
- [6Example](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Example)
- [7Libraries](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Libraries)
- [8Patch changes](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Patch_changes)
  - [8.1Retail](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Retail)
  - [8.2Classic](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Classic)
- [9See also](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#See_also)
- [10References](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#References)

|     |     |
| --- | --- |
| ![Inv gizmo supersappercharge.png](https://warcraft.wiki.gg/images/thumb/Inv_gizmo_supersappercharge.png/32px-Inv_gizmo_supersappercharge.png?3f65de) | Please use [ChatThrottleLib](https://warcraft.wiki.gg/wiki/ChatThrottleLib "ChatThrottleLib") or [AceComm](https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0) – otherwise you will blow up the server. |

Sends a message over an addon comm channel.

```
result = C_ChatInfo.SendAddonMessage(prefix, message [, chatType [, target]])
       = C_ChatInfo.SendAddonMessageLogged
```

## Arguments

prefixstring \- Message prefix, can be used as your addon identifier; at most 16 characters.messagestring \- Text to send, at most 255 characters. All characters (decimal ID 1-255) are permissible except NULL (ASCII 0).chatTypestring?`= "PARTY"` \- The addon channel to send to.targetstring\|number? \- The player name or custom channel number receiving the message for `"WHISPER"` or `"CHANNEL"` chatTypes.

## Returns

resultEnum.SendAddonMessageResult \- Result code indicating if the message has been enqueued by the API for submission. This does not mean that the message has yet been sent, and may still be subject to any server-side throttling.

| Value | Field | Description |
| --- | --- | --- |
| 0 | Success |  |
| 1 | InvalidPrefix |  |
| 2 | InvalidMessage |  |
| 3 | AddonMessageThrottle |  |
| 4 | InvalidChatType |  |
| 5 | NotInGroup |  |
| 6 | TargetRequired |  |
| 7 | InvalidChannel |  |
| 8 | ChannelThrottle |  |
| 9 | GeneralError |  |
| 10 | NotInGuild | 11.1.0 |
| 11 | AddOnMessageLockdown | 12.0.0 |
| 12 | TargetOffline | 12.0.0 |

## Chat types

| chatType | Retail | Classic | Description |
| --- | --- | --- | --- |
| "PARTY" | ✔️ | ✔️ | Addon message to party members. |
| "RAID" | ✔️ | ✔️ | Addon message to raid members. If not in a raid group, the message will instead be sent on the PARTY chat type. |
| "INSTANCE\_CHAT" | ✔️ | ✔️ | Addon message to grouped players in instanced content such as dungeons, raids and battlegrounds. |
| "GUILD" | ✔️ | ✔️ | Addon message to guild members. Prints a _"You are not in a guild."_ system message if you're not in a guild. |
| "OFFICER" | ✔️ | ✔️ | Addon message to guild officers. |
| "WHISPER" | ✔️ | ✔️ | Addon message to a player. Only works for players on the same or any [connected](https://warcraft.wiki.gg/wiki/Connected_Realms "Connected Realms") realms. Use player name as target argument. Prints a _"Player is offline."_ system message if the target is offline. |
| "CHANNEL" | ✔️ | ❌ | Addon message to a custom chat channel. Use channel number as target argument. <br>Disabled on Classic to prevent players communicating over custom chat channels. |
| "SAY"[\[1\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-1.13.3-1) | ❌ | ✔️ | Addon message to players within /say range. Subject to heavy throttling and certain specific characters are disallowed.[\[2\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-valid_SAY/YELL_characters-2) |
| "YELL"[\[1\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-1.13.3-1) | ❌ | ✔️ | Addon message to players within /yell range. Subject to heavy throttling and certain specific characters are disallowed.[\[2\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-valid_SAY/YELL_characters-2) |

## Details

- Recipients must register a prefix using [C\_ChatInfo.RegisterAddonMessagePrefix](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix "API C ChatInfo.RegisterAddonMessagePrefix")() to receive its messages via [CHAT\_MSG\_ADDON](https://warcraft.wiki.gg/wiki/CHAT_MSG_ADDON "CHAT MSG ADDON"). This prefix can be max **16 characters** long and it's recommended to use the addon name if possible so other authors can easily see which addon a registered prefix belongs to.
- Prior to [Patch 11.0.0](https://warcraft.wiki.gg/wiki/Patch_11.0.0 "Patch 11.0.0"), Blizzard has provided a deprecation wrapper for this API that shifts the result code to the second return position. A forward-compatible way to reliably access the enum return value is to use a negative [select](https://warcraft.wiki.gg/wiki/API_select "API select") index to grab the last return value.

### C\_ChatInfo.SendAddonMessageLogged

Addons transmitting user-generated content should use this API so recipients can report violations of the [Code of Conduct](https://us.battle.net/support/en/article/42673).

- Fires [CHAT\_MSG\_ADDON\_LOGGED](https://warcraft.wiki.gg/wiki/CHAT_MSG_ADDON_LOGGED "CHAT MSG ADDON LOGGED") when receiving messages sent via this function.
- _The message has to be plain text for the game masters to read it._ Moreover, the messages will silently fail to be sent if it contains an unsupported non-printable character. Some amount of metadata is tolerated, but should be kept as minimal as possible to keep the messages readable for Blizzard's game masters. [\[3\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-3)
- This function has been introduced as a solution to growing issues of harassment and doxxing via addon communications, where players would use addons to send content against the terms of service to other players (roleplaying addons are particularly affected as they offer a free form canvas to share a RP profiles). As regular addon messages are not logged they cannot be seen by game master, they had no way to act upon this content. If you use this function, game masters will be able to check the addon communication logs in case of a report and act upon the content. Users should report addon content that is against the terms of service using Blizzard's support website via the [Harassment in addon text](https://battle.net/support/help/product/wow/197/1501/channels) option.

## Message throttling

Communications on all chat types are subject to a per-prefix throttle. Additionally, if too much data is being sent simultaneously on separate prefixes then the client **may be disconnected**. For this reason it is strongly recommended to use [ChatThrottleLib](https://warcraft.wiki.gg/wiki/ChatThrottleLib "ChatThrottleLib") or [AceComm](https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0) to manage the queueing of messages.

- Each registered prefix is given an allowance of 10 addon messages that can be sent.
- Each message sent on a prefix reduces this allowance by 1.
- If the allowance reaches zero, further attempts to send messages on the same prefix will fail, returning `Enum.SendAddonMessageResult.AddonMessageThrottle` to the caller.
- Each prefix regains its allowance at a rate of 1 message per second, up to the original maximum of 10 messages.
- This restriction does not apply to whispers outside of instanced content.
- All numbers provided above are the default values, however these can be dynamically reconfigured by the server at any time.

## Example

Whispers yourself an addon message when you login or /reload

```
local prefix = "SomePrefix123"
local playerName = UnitName("player")

local function OnEvent(self, event, ...)
	if event == "CHAT_MSG_ADDON" then
		print(event, ...)
	elseif event == "PLAYER_ENTERING_WORLD" then
		local isLogin, isReload = ...
		if isLogin or isReload then
			C_ChatInfo.SendAddonMessage(prefix, "You can't see this message", "WHISPER", playerName)
			C_ChatInfo.RegisterAddonMessagePrefix(prefix)
			C_ChatInfo.SendAddonMessage(prefix, "Hello world!", "WHISPER", playerName)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEvent)
```

Copy

## Libraries

There is a server-side throttle on in-game addon communication so it's recommended to serialize, compress and encode data before you send them over the addon comms channel.

**Serialize:**

- [C\_EncodingUtil.SerializeCBOR](https://warcraft.wiki.gg/wiki/API_C_EncodingUtil.SerializeCBOR "API C EncodingUtil.SerializeCBOR") and [C\_EncodingUtil.DeserializeCBOR](https://warcraft.wiki.gg/wiki/API_C_EncodingUtil.DeserializeCBOR "API C EncodingUtil.DeserializeCBOR")
- [C\_EncodingUtil.SerializeJSON](https://warcraft.wiki.gg/wiki/API_C_EncodingUtil.SerializeJSON "API C EncodingUtil.SerializeJSON") and [C\_EncodingUtil.DeserializeJSON](https://warcraft.wiki.gg/wiki/API_C_EncodingUtil.DeserializeJSON "API C EncodingUtil.DeserializeJSON")
- [LibSerialize](https://github.com/rossnichols/LibSerialize) ( [stats](https://www.townlong-yak.com/globe/wut/#q:LibSerialize))
- [AceSerializer](https://www.wowace.com/projects/ace3/pages/api/ace-serializer-3-0)

**Compress/Encode:**

- [C\_EncodingUtil.CompressString](https://warcraft.wiki.gg/wiki/API_C_EncodingUtil.CompressString "API C EncodingUtil.CompressString") and [C\_EncodingUtil.DecompressString](https://warcraft.wiki.gg/wiki/API_C_EncodingUtil.DecompressString "API C EncodingUtil.DecompressString")
- [LibDeflate](https://github.com/SafeteeWoW/LibDeflate) ( [stats](https://www.townlong-yak.com/globe/wut/#q:LibDeflate))
- [LibCompress](https://www.wowace.com/projects/libcompress) ( [stats](https://www.townlong-yak.com/globe/wut/#q:LibCompress))

**Comms:**

- [ChatThrottleLib](https://www.wowace.com/projects/chatthrottlelib) ( [docs](https://warcraft.wiki.gg/wiki/ChatThrottleLib "ChatThrottleLib"), [stats](https://www.townlong-yak.com/globe/wut/#q:ChatThrottleLib))
- [AceComm](https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0)

The LibSerialize project page has detailed examples[\[4\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-4) and documentation for using LibSerialize + LibDeflate and AceComm:

```
-- Dependencies: AceAddon-3.0, AceComm-3.0, LibSerialize, LibDeflate
MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceComm-3.0")
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

function MyAddon:OnEnable()
    self:RegisterComm("MyPrefix")
end

-- With compression (recommended):
function MyAddon:Transmit(data)
    local serialized = LibSerialize:Serialize(data)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)
    self:SendCommMessage("MyPrefix", encoded, "WHISPER", UnitName("player"))
end

function MyAddon:OnCommReceived(prefix, payload, distribution, sender)
    local decoded = LibDeflate:DecodeForWoWAddonChannel(payload)
    if not decoded then return end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return end
    local success, data = LibSerialize:Deserialize(decompressed)
    if not success then return end

    -- Handle `data`
end
```

Copy

## Patch changes

#### Retail

- [![Dragonflight](https://warcraft.wiki.gg/images/thumb/Dragonflight-Icon-Inline.png/48px-Dragonflight-Icon-Inline.png?be4c0e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Dragonflight "Dragonflight")**[Patch 10.2.7](https://warcraft.wiki.gg/wiki/Patch_10.2.7/API_changes "Patch 10.2.7/API changes") (2024-05-07):** All chat types are now subject to a per-prefix throttle. Now returns a result code, rather than a boolean.

- [![Dragonflight](https://warcraft.wiki.gg/images/thumb/Dragonflight-Icon-Inline.png/48px-Dragonflight-Icon-Inline.png?be4c0e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Dragonflight "Dragonflight")**[Patch 10.2.0](https://warcraft.wiki.gg/wiki/Patch_10.2.0/API_changes "Patch 10.2.0/API changes") (2023-11-07):** The "PARTY" chat type now has a per-prefix throttle.

- [![Dragonflight](https://warcraft.wiki.gg/images/thumb/Dragonflight-Icon-Inline.png/48px-Dragonflight-Icon-Inline.png?be4c0e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Dragonflight "Dragonflight")**[Patch 10.0.2](https://warcraft.wiki.gg/wiki/Patch_10.0.2/API_changes "Patch 10.0.2/API changes") (2022-11-15):** The "RAID" chat type now has a per-prefix throttle as of a hotfix build around Jan 12 2023.

- [![Battle for Azeroth](https://warcraft.wiki.gg/images/thumb/BattleForAzeroth-Logo-Small.png/40px-BattleForAzeroth-Logo-Small.png?25e36c)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Battle_for_Azeroth "Battle for Azeroth")**[Patch 8.0.1](https://warcraft.wiki.gg/wiki/Patch_8.0.1/API_changes "Patch 8.0.1/API changes") (2018-07-17):** Moved to `C_ChatInfo.SendAddonMessage()` and added `C_ChatInfo.SendAddonMessageLogged()`

- [![Warlords of Draenor](https://warcraft.wiki.gg/images/WoD-Logo-Small.png?be5b60)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Warlords_of_Draenor "Warlords of Draenor")**[Patch 6.0.2](https://warcraft.wiki.gg/wiki/Patch_6.0.2/API_changes "Patch 6.0.2/API changes") (2014-10-14):** Added "CHANNEL" chat type.

- [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm "Cataclysm")**[Patch 4.1.0](https://warcraft.wiki.gg/wiki/Patch_4.1.0/API_changes "Patch 4.1.0/API changes") (2011-04-26):** Added "OFFICER" chat type. Addons should now register which prefixes they want to receive addon messages for using [C\_ChatInfo.RegisterAddonMessagePrefix](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix "API C ChatInfo.RegisterAddonMessagePrefix")()[\[5\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-4.1.0-5)

- [![Burning Crusade](https://warcraft.wiki.gg/images/Bc_icon.gif?6fe702)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_The_Burning_Crusade "Burning Crusade")**[Patch 2.1.0](https://warcraft.wiki.gg/wiki/Patch_2.1.0/API_changes "Patch 2.1.0/API changes") (2007-05-22):** Added "WHISPER" chat type was, as servers will begin to rate throttle regular whispers to alleviate [spam](https://warcraft.wiki.gg/wiki/Spam "Spam") problems.

- [![World of Warcraft](https://warcraft.wiki.gg/images/WoW_Icon_update.png?d4be1e)](https://warcraft.wiki.gg/wiki/World_of_Warcraft "World of Warcraft")**[Patch 1.12.0](https://warcraft.wiki.gg/wiki/Patch_1.12.0/API_changes "Patch 1.12.0/API changes") (2006-08-22):** Added as `SendAddonMessage()`[\[6\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-1.12.0-6)


#### Classic

- [![Cataclysm](https://warcraft.wiki.gg/images/Cata-Logo-Small.png?cd16d8)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Cataclysm_Classic "Cataclysm")**[Patch 4.4.0](https://warcraft.wiki.gg/wiki/Patch_4.4.0/API_changes "Patch 4.4.0/API changes") (2024-04-30):** All chat types are now subject to a per-prefix throttle. Now returns a result code, rather than a boolean.

- [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic")**[Patch 1.13.4](https://warcraft.wiki.gg/wiki/Patch_1.13.4/API_changes "Patch 1.13.4/API changes") (2020-03-10):** Addon comms are now more severely rate throttled (Applied in a hotfix during build 32466 on May 24 2020) [\[7\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-7)

- [![World of Warcraft: Classic](https://warcraft.wiki.gg/images/WoW_Icon_Classic.png?251bc2)](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic")**[Patch 1.13.3](https://warcraft.wiki.gg/wiki/Patch_1.13.3/API_changes "Patch 1.13.3/API changes") (2019-12-10):** "SAY" and "YELL" are now supported chat types, coincident with removing "CHANNEL" to prevent looking-for-group style addons from proliferating in Classic.[\[1\]](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_note-1.13.3-1)


## See also

- [C\_ChatInfo.GetRegisteredAddonMessagePrefixes](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.GetRegisteredAddonMessagePrefixes "API C ChatInfo.GetRegisteredAddonMessagePrefixes")()
- [C\_ChatInfo.IsAddonMessagePrefixRegistered](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.IsAddonMessagePrefixRegistered "API C ChatInfo.IsAddonMessagePrefixRegistered")()
- [BNSendGameData](https://warcraft.wiki.gg/wiki/API_BNSendGameData "API BNSendGameData")() \- Battle.net equivalent.

## References

1. ^ [a](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-1.13.3_1-0)[b](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-1.13.3_1-1)[c](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-1.13.3_1-2)[![Blizzard Entertainment](https://warcraft.wiki.gg/images/Blizz.gif?984542)](https://warcraft.wiki.gg/wiki/Blizzard_Entertainment "Blizzard Entertainment")[Kaivax](https://warcraft.wiki.gg/wiki/Kaivax "Kaivax") 2019-12-09. [\[WoW Classic\] Patch 1.13.3 Lua API Change](https://us.forums.blizzard.com/en/wow/t/wow-classic-patch-1133-lua-api-change/384543).
2. ^ [a](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-valid_SAY/YELL_characters_2-0)[b](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-valid_SAY/YELL_characters_2-1)LenweSaralonde 2019-12-20. [String with special characters truncated when sent with C\_ChatInfo.SendAddonMessage() over SAY and YELL](https://github.com/Stanzilla/WoWUIBugs/issues/23).
3. [^](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-3)[![Blizzard Entertainment](https://warcraft.wiki.gg/images/Blizz.gif?984542)](https://warcraft.wiki.gg/wiki/Blizzard_Entertainment "Blizzard Entertainment") TheDanW 2018-06-14. [#wowuidev IRC chat](http://infobot.rikers.org/%23wowuidev/20180614.html.gz).
4. [^](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-4) Ross Nichols. [LibSerialize](https://github.com/rossnichols/LibSerialize#libserialize).
5. [^](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-4.1.0_5-0)[![Blizzard Entertainment](https://warcraft.wiki.gg/images/Blizz.gif?984542)](https://warcraft.wiki.gg/wiki/Blizzard_Entertainment "Blizzard Entertainment")[Zarhym](https://warcraft.wiki.gg/wiki/Zarhym "Zarhym") 2011-03-12. [Patch 4.1: Addon Messages Will Be Filtered](https://blue.mmo-champion.com/topic/163377-patch-41-addon-messages-will-be-filtered/).
6. [^](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-1.12.0_6-0)[![Blizzard Entertainment](https://warcraft.wiki.gg/images/Blizz.gif?984542)](https://warcraft.wiki.gg/wiki/Blizzard_Entertainment "Blizzard Entertainment")[slouken](https://warcraft.wiki.gg/wiki/Slouken "Slouken") 2006-07-12. [Re: Upcoming 1.12 changes - Concise List](http://blue.cardplace.com/cache/wow-interface-customization/412845.htm). Archived from [the original](http://forums.worldofwarcraft.com/thread.aspx?fn=wow-interface-customization&t=412845&p=#post413354)
7. [^](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#cite_ref-7) Questie 2020-05-25. [QuestieSerializer.lua (LUA) errors #1974](https://github.com/AeroScripts/QuestieDev/issues/1974).

Retrieved from " [https://warcraft.wiki.gg/wiki/API\_C\_ChatInfo.SendAddonMessage?oldid=6734853](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage?oldid=6734853)"

[Categories](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [API systems/ChatInfo](https://warcraft.wiki.gg/wiki/Category:API_systems/ChatInfo "Category:API systems/ChatInfo")
- [API functions](https://warcraft.wiki.gg/wiki/Category:API_functions "Category:API functions")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK