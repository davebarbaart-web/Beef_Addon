Wowpedia

We have moved to Warcraft Wiki. [Click here](https://wowpedia.fandom.com/wiki/Forum:Vote_to_Leave_Fandom "Forum:Vote to Leave Fandom") for information and the new URL.

READ MORE

[Fandom homepage](https://www.fandom.com/)

[Wowpedia](https://wowpedia.fandom.com/wiki/Wowpedia)

[Switch to Light Theme](https://wowpedia.fandom.com/wiki/ChatThrottleLib# "Switch to Light Theme")

[Sign In](https://auth.fandom.com/signin?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib&metadata=header-signin-button)

Don't have an account?

[Create a Free Account](https://auth.fandom.com/register?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib&metadata=header-registration-button)

* * *

[Sign In](https://auth.fandom.com/signin?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib&metadata=header-signin-button)

Advertisement


[Skip to content](https://wowpedia.fandom.com/wiki/ChatThrottleLib#page-header)

## Contents

- [1Communications libraries already using ChatThrottleLib](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Communications_libraries_already_using_ChatThrottleLib)
- [2ChatThrottleLib APIs](https://wowpedia.fandom.com/wiki/ChatThrottleLib#ChatThrottleLib_APIs)
  - [2.1ChatThrottleLib:SendChatMessage](https://wowpedia.fandom.com/wiki/ChatThrottleLib#ChatThrottleLib:SendChatMessage)
  - [2.2ChatThrottleLib:SendAddonMessage](https://wowpedia.fandom.com/wiki/ChatThrottleLib#ChatThrottleLib:SendAddonMessage)
- [3Notes on outbound rate](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Notes_on_outbound_rate)
- [4Throttling algorithms](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Throttling_algorithms)
  - [4.1Per-stream shaping](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Per-stream_shaping)
  - [4.2Prioritization](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Prioritization)
- [5Change Log](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Change_Log)
  - [5.1v7](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v7)
  - [5.2v9](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v9)
  - [5.3v10](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v10)
  - [5.4v11](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v11)
  - [5.5v12](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v12)
  - [5.6v14](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v14)
  - [5.7v15](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v15)
  - [5.8v16](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v16)
  - [5.9v17](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v17)
  - [5.10v18](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v18)
  - [5.11v19](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v19)
  - [5.12v20](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v20)
  - [5.13v20-30200](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v20-30200)
  - [5.14v21](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v21)
  - [5.15v22](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v22)
- [6How to use ChatThrottleLib](https://wowpedia.fandom.com/wiki/ChatThrottleLib#How_to_use_ChatThrottleLib)

[Edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Fveaction%3Dedit&uselang=en&metadata=article-registration-edit-article)[Sign In to Save](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Fcollections%3Dsave&uselang=en&metadata=collections-save-button)

in: [AddOns](https://wowpedia.fandom.com/wiki/Category:AddOns "Category:AddOns"), [Function Libraries](https://wowpedia.fandom.com/wiki/Category:Function_Libraries "Category:Function Libraries")

# ChatThrottleLib

[Sign In to SaveSave](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Fcollections%3Dsave&uselang=en&metadata=collections-save-button "Sign In to Save") [Edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Fveaction%3Dedit&uselang=en&metadata=article-registration-edit-article)

- [History](https://wowpedia.fandom.com/wiki/ChatThrottleLib?action=history)
- [Purge](https://wowpedia.fandom.com/wiki/ChatThrottleLib?action=purge)
- [Talk (9)](https://wowpedia.fandom.com/wiki/Talk:ChatThrottleLib)

| ChatThrottleLib |
| --- |
| Library for addons to share throttled chat communication |
| Details |
| Author | [Mikk](https://wowpedia.fandom.com/wiki/User:Mikk "User:Mikk") |
| Links |
| Releases | [WoWInterface](https://www.wowinterface.com/downloads/info5207)<br>[CurseForge](https://www.curseforge.com/wow/addons/13662) |

[![AddOn](https://static.wikia.nocookie.net/wowpedia/images/4/46/Addonicon.gif/revision/latest?cb=20060731112900)](https://wowpedia.fandom.com/wiki/AddOn "AddOn")

**AddOn article**

This page describes fan-made scripting using the World of Warcraft [API](https://wowpedia.fandom.com/wiki/API "API") which has had notable impact on the game's development/history.

**ChatThrottleLib** is a small, embeddable library by [Mikk](https://wowpedia.fandom.com/wiki/User:Mikk "User:Mikk") that keeps outbound chat and addon communication from exceeding the output rate limit in WoW that otherwise causes players to disconnect from the server. It also has a number of features that will help you make your addon communication run smoother!

Benefits of using ChatThrottleLib:

- You keep players from getting disconnected when your addon sends too much data
- You can easily _prioritize_ your traffic in three priorities
- Communication to different peers is handled as individual flows. A long stream of data to "Alice" doesn't interrupt short bursts of traffic to "Bob".
- All AddOns using ChatThrottleLib count toward the same maximum, so multiple addons can't cause an overload. Priorities ensure that **real-time traffic is still real-time**. And addons are given a fair share of bandwidth, so **one addon can't lock all others out**.

[![ChatThrottleLib throughput sample](https://static.wikia.nocookie.net/wowpedia/images/f/f4/ChatThrottleLib.gif/revision/latest/scale-to-width-down/180?cb=20060730204300)](https://static.wikia.nocookie.net/wowpedia/images/f/f4/ChatThrottleLib.gif/revision/latest?cb=20060730204300)

ChatThrottleLib throughput sample

ChatThrottleLib does:

- **Round-robin traffic shaping** of different communication paths
- **Prioritization** of messages according to three predefined priorities: "BULK", "NORMAL" and "ALERT"
- **NO** queueing of traffic needlessly. No lag is introduced until it needs to be.
- **Adaptive throttling** based on chat traffic bypassing the library
- **Adaptive throttling** based on framerate

## Contents

- [1Communications libraries already using ChatThrottleLib](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Communications_libraries_already_using_ChatThrottleLib)
- [2ChatThrottleLib APIs](https://wowpedia.fandom.com/wiki/ChatThrottleLib#ChatThrottleLib_APIs)
  - [2.1ChatThrottleLib:SendChatMessage](https://wowpedia.fandom.com/wiki/ChatThrottleLib#ChatThrottleLib:SendChatMessage)
  - [2.2ChatThrottleLib:SendAddonMessage](https://wowpedia.fandom.com/wiki/ChatThrottleLib#ChatThrottleLib:SendAddonMessage)
- [3Notes on outbound rate](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Notes_on_outbound_rate)
- [4Throttling algorithms](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Throttling_algorithms)
  - [4.1Per-stream shaping](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Per-stream_shaping)
  - [4.2Prioritization](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Prioritization)
- [5Change Log](https://wowpedia.fandom.com/wiki/ChatThrottleLib#Change_Log)
  - [5.1v7](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v7)
  - [5.2v9](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v9)
  - [5.3v10](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v10)
  - [5.4v11](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v11)
  - [5.5v12](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v12)
  - [5.6v14](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v14)
  - [5.7v15](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v15)
  - [5.8v16](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v16)
  - [5.9v17](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v17)
  - [5.10v18](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v18)
  - [5.11v19](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v19)
  - [5.12v20](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v20)
  - [5.13v20-30200](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v20-30200)
  - [5.14v21](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v21)
  - [5.15v22](https://wowpedia.fandom.com/wiki/ChatThrottleLib#v22)
- [6How to use ChatThrottleLib](https://wowpedia.fandom.com/wiki/ChatThrottleLib#How_to_use_ChatThrottleLib)

## Communications libraries already using ChatThrottleLib\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D1&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

- [AceComm](https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0) ( [Ace](https://wowpedia.fandom.com/wiki/Ace_(AddOns) "Ace (AddOns)")'s communications library)
- Telepathy (Sky's replacement as of 1.12)

If you are communicating through these libraries, you do not need to worry about throttling at all. And if you are depending on them / including them, ChatThrottleLib is already there and does not need to be included again; you can use it directly for regular chat.

## ChatThrottleLib APIs\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D2&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

### ChatThrottleLib:SendChatMessage\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D3&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

```
ChatThrottleLib:SendChatMessage("prio", "prefix",   "text", "chattype", "language", "destination"[, "queueName"[, callbackFn, callbackArg]]);
```

prioString - "BULK", "NORMAL" or "ALERT".prefixString - a unique identifier for your addon (or class of traffic). This is only for traffic shaping purposes; prefixes are used in creating unique flows that are processed round-robin inside each priority.

The following parameters are the same as the [SendChatMessage](https://wowpedia.fandom.com/wiki/API_SendChatMessage "API SendChatMessage")() API:

textString - the text to be sentchattypeString - "SAY", "WHISPER", "CHANNEL", etc...languageString or nildestinationString or nil - Used for WHISPER, CHANNEL..

The following parameters are optional:

queueNameString or nil - specific queue to place message in rather than prefix+chattype+destinationcallbackFnFunction - function to call when this message goes out the wire. May be called immediately (recursively).callbackArgAny - an argument to pass to callbackFn

### ChatThrottleLib:SendAddonMessage\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D4&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

```
ChatThrottleLib:SendAddonMessage("prio",  "prefix", "text", "chattype"[, "target"[, "queueName"[, callbackFn, callbackArg]]]);
```

prioString - "BULK", "NORMAL", or "ALERT".

The following parameters are the same as the [SendAddonMessage](https://wowpedia.fandom.com/wiki/API_SendAddonMessage "API SendAddonMessage")() API:

prefixString - a unique identifier for your addon (or class of traffic)textString - the text to be sentchattypeString - "PARTY", "RAID", "GUILD", "BATTLEGROUND", "WHISPER"targetString - Only used for "WHISPER" chats (added in WoW 2.1) -- which player to whisper to.

The following parameters are optional:

queueNameString or nil - specific queue to place message in rather than prefix+chattype+destinationcallbackFnFunction - function to call when this message goes out the wire. May be called immediately (recursively).callbackArgAny - an argument to pass to callbackFn

## Notes on outbound rate\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D5&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

The World of Warcraft servers will disconnect you if you generate too much output. This is not limited to chat output; any type of output can cause it. Some of you may have noticed that holding down your right mouse button and wiggling it wildly for an extended time can kick you off.

In my own testing, I've found that a data rate of 3000 CPS will cause a disconnect if sustained for more than a few seconds. There seems to be an input buffer of something along the lines of 32KBytes serverside. Filling it would be what causes the kick.

A total output of 2000 CPS seems safe.

ChatThrottleLib will allow **bursts of up to 4000 bytes** and after that **throttle its output to 800 CPS**, to allow room for actual game events. This used to be 8000/1000 but some servers seem more sensitive than others. See this [cosmosui.org forum thread](http://www.cosmosui.org/forums/viewtopic.php?t=15916).

ChatThrottleLib will also assume that there's a 40-byte overhead associated with sending messages, so if you're sending "hi", it will count as 42 bytes for traffic shaping purposes. It's fairly unscientific, I'm assuming it's fair estimate of source + destination + chattype + some envisioned protocol overhead.

40 bytes seems a bit on the high side for sending data, possibly because the sender does not need to be included (obviously), but it seems about right on the receiving end from measuring actual network traffic (excluding ethernet+IP+TCP headers).

As of v11, ChatThrottleLib also assumes that the server-side rate limiter is somewhat cranky shortly after logon and zoning, and only allows a tenth of the normal rate for the first 5 seconds. This is based on observations from PartyQuests, which used to send the entire quest log (plus texts) to party members - immediately after login if you are logging in to a player still in a party. It has been seen to cause disconnects on at least one server.

## Throttling algorithms\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D6&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

There are two types of traffic shaping going on in ChatThrottleLib.

### Per-stream shaping\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D7&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

Each prefix + chattype (+ destination) tuple is treated as a separate stream. Streams output is simply round-robined, i.e. they get the same amount of messages per second. Not necessarily the same CPS though. Doing full-out data rate shaping seemed like unnecessary overhead for very little gain.

### Prioritization\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D8&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

Traffic in the three priorities will be fully data rate shaped so that the net output stays at 800 CPS. Higher priorities do not force lower priority traffic out of the way utterly. In a fully loaded system (with full output in all priorities), each priority gets 1/3rd of the available bandwidth.

It is fully balanced. Examples of attempted transmit rates and actual output results:

- **BULK** 500 CPS. **NORMAL** 500 CPS. **ALERT** 200 CPS

  - Bulk gets 300
  - Normal gets 300
  - Alert gets 200

- **BULK** 1500 CPS. **NORMAL** 200 CPS. **ALERT** 500 CPS

  - Bulk gets 300
  - Normal gets 200
  - Alert gets 300

- **BULK** 1200 CPS. **NORMAL** 0 CPS. **ALERT** 100 CPS

  - Bulk gets 700
  - Normal gets 0
  - Alert gets 100

- **BULK** 0 CPS. **NORMAL** 400 CPS. **ALERT** 300 CPS

  - Bulk gets 0
  - Normal gets 400
  - Alert gets 300

_The total load here is less than the CPS limit, and everyone gets what they ask for._

See [this example graph](https://wowpedia.fandom.com/wiki/File:ChatThrottleLib.gif "File:ChatThrottleLib.gif") for an illustration of how output in different priorities will be shaped over time.

If you would like to see rate changes in action during development, load ChatThrottleStats.lua in your addon. It displays a small string in the top left corner of your screen showing current rate through the library, burst availability, and rate of traffic bypassing the library. FPS based throttling being in effect causes the string to go red.

## Change Log\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D9&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

### v7\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D10&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

- Adaptive throttling according to FPS
- Adaptive throttling according to traffic bypassing the lib
- Allow prefix to be nil in :SendChatMessage()

### v9\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D11&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

- Fix SendAddonMessage() hook ending up feeding messages to SendChatMessage(). OOPS! Thank god for test realms.

### v10\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D12&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

- Will no longer "hook" SendAddonMessage if it doesn't exist. Might fool some addon into thinking that an 1.11 client is 1.12.

### v11\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D13&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Aug 25 2006_

- _Some_ servers (sometimes?) seem to be cranky about lots of data being sent right after logon, such as e.g. PartyQuests will do if you log in while a member of a party. ChatThrottleLib v11 clamps the maximum output rate to a tenth for the 5 first seconds after logon (and zoning, just to be safe) in an attempt to work around it. I have not been able to reproduce this bug myself though, so it's somewhat of a stab in the dark.

### v12\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D14&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Sep 14 2006_

- Decrease max CPS to 800. Decrease max burst to 4000 bytes. See this [cosmosui.org forum thread](http://www.cosmosui.org/forums/viewtopic.php?t=15916).

### v14\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D15&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Apr 4 2007_

- Bump .toc up to 2.0. Some minor internal code shuffling. (v12 worked just fine in wow 2.0 too, for what it's worth)

### v15\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D16&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Apr 8 2007_

- Add new "target" parameter to SendAddonMessage. Gets introduced in WoW 2.1 to support the new "WHISPER" addon channel.

- Move constants (max cps, burst size, etc) from locals to member variables to allow tweaking from outside sources.

### v16\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D17&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Apr 14 2007_

- Use secure hooks of SendAddonMessage/SendChatMessage. Should not affect anything.

### v17\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D18&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_May 27 2007_

- Add a check that :SendAddonMessage text+prefix isn't longer than 254 bytes, as this causes a disconnect, which then may be misinterpreted as a speed problem.

- Localize a stray "msg" variable that ended up in the global namespace.

### v18\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D19&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Aug 21 2007_

- Fix a repeating (~10 times per second) error that would occur if you talked to more than 25 destinations simultaneously (as in "had queued data for more than 25").

- Add a check that :SendChatMessage text isn't longer than 255, which causes a disconnect.

- Fix cases where ChatThrottleLib is embedded inside another Lua file where "ChatThrottleLib" is a local variable, as is the case inside "AceComm-2.0.lua". This would often cause two separate copies of CTL to be loaded, making it NOT obey speed limits (each copy has its own max). I blame ckknight :-P

### v19\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D20&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Nov 11 2007_

- Add optional `queueName` argument at the end of both Send functions. Useful for libs/addons that require in-sequence delivery of messages with different prefixes.

### v20\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D21&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Oct 15 2008_

- `prefix` is no longer optional for SendChatMessage, in anticipation of the global `this` disappearing.
- The standalone ChatThrottleLib addon is no longer LoD due to the 3.0.2 LoD bug.

### v20-30200\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D22&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Aug 5 2009_

- The standalone ChatThrottleLib addon is again LoD

### v21\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D23&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Aug 7 2009_

- Added optional callback(+arg) parameters to the :Send()s. This callback will be called (with the given arg) when the message is pushed out the wire. This \_MAY\_ happen immediately (recursively)!

- Yanked upgrade path support for pre-v16 ChatThrottleLibs (pre-WoW 2.0). There is minimal arse-saving code + alerts should this be detected.

### v22\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D24&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Mar 27 2011_

- Will now autodetect 4.1+ wow and allow SendAddonMessage text size up to 255 characters. No, the limit is not 256. Anything above 255 is silently stripped by the client.

## How to use ChatThrottleLib\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FChatThrottleLib%3Faction%3Dedit%26section%3D25&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

- Download ChatThrottleLib from [wowinterface.com](http://www.wowinterface.com/downloads/info5207-ChatThrottleLib.html).

(Alternatively, SVN extern it from **[svn://svn.wowace.com/wow/chatthrottlelib/mainline/trunk](svn://svn.wowace.com/wow/chatthrottlelib/mainline/trunk)**)

**Method 1:**

- Copy ChatThrottleLib.lua into your addon directory
- Add "ChatThrottleLib.lua" to your .toc file

**Method 2:**

- Copy the entire ChatThrottleLib folder into your addon directory, as a sub folder
- Add "ChatThrottleLib/ChatThrottleLib.xml" to your .toc file

You're done, and can now use ChatThrottleLib:SendChatMessage and ChatThrottleLib:SendAddonMessage to send your messages!

The library has built-in checks for if it has already been loaded, and avoids loading again if so.

If your addon has a newer version of the library than one that has already been loaded, it will replace the old version.

Note that you should never ever take local copies of ChatThrottleLib:SendChatMessage et al, since that prevents proper upgrading, and is likely to cause severe breakage:

```
    local SendChatMsg = ChatThrottleLib.SendChatMessage  -- never ever do this!!!!
```

Categories

Community content is available under [CC BY-SA 3.0](https://www.fandom.com/licensing) unless otherwise noted.

- [Fantasy](https://www.fandom.com/fancentral/fantasy)
- [World of Warcraft](https://www.fandom.com/universe/world-of-warcraft)

Advertisement


silver-surfer-storage-html

Wowpedia


We have moved to Warcraft Wiki. [Click here](https://wowpedia.fandom.com/wiki/Forum:Vote_to_Leave_Fandom "Forum:Vote to Leave Fandom") for information and the new URL.

CLOSE


[Search this wiki](https://wowpedia.fandom.com/wiki/Special:Search?scope=internal&query=&h=1&isFromHighlightActions=on)

[Search all wikis](https://wowpedia.fandom.com/wiki/Special:Search?scope=cross-wiki&query=&h=1&isFromHighlightActions=on)

RL Storage

![](https://ad-delivery.net/px.gif?ch=2)![](https://ad.doubleclick.net/favicon.ico?ad=300x250&ad_box_=1&adnet=1&showad=1&size=250x250)![](https://ad-delivery.net/px.gif?ch=1&e=0.2840912981768985)