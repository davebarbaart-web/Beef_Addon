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

# InCombatLockdown

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/API_InCombatLockdown#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/API_InCombatLockdown#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

|     |     |
| --- | --- |
| ![Fat cat yearns for the mines](https://warcraft.wiki.gg/images/thumb/Fatcat_miner.png/64px-Fatcat_miner.png?82abc0) | The API wiki is under maintenance<br>Since `2026-07-23T06:08:00Z`, ETA: at least multiple days |

Returns true if the combat lockdown restrictions are active.

```
inLockdown = InCombatLockdown()
```

## Returns

inLockdownboolean \- true if lockdown restrictions are currently in effect, false otherwise.

## Details

- Combat lockdown begins _after_ the [PLAYER\_REGEN\_DISABLED](https://warcraft.wiki.gg/wiki/PLAYER_REGEN_DISABLED "PLAYER REGEN DISABLED") event fires, and ends _before_ the [PLAYER\_REGEN\_ENABLED](https://warcraft.wiki.gg/wiki/PLAYER_REGEN_ENABLED "PLAYER REGEN ENABLED") event fires.

### Restrictions

While in combat:

- Programatic modification of macros or bindings is not allowed.
- Some things can't be done on "Protected" frames, their parents, or any frame they are anchored to. These include, but are not restricted to:
  - Hiding the frame using Hide widget method.
  - Showing the frame using Show widget method.
  - Changing the frame's attributes (custom attributes are used by Blizzard secure templates to set up their behavior).
  - Moving the frame by resetting frame's points or anchors (movements initiated by user are still allowed while in combat).

Retrieved from " [https://warcraft.wiki.gg/wiki/API\_InCombatLockdown?oldid=6588239](https://warcraft.wiki.gg/wiki/API_InCombatLockdown?oldid=6588239)"

[Categories](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [API systems/RestrictedActions](https://warcraft.wiki.gg/wiki/Category:API_systems/RestrictedActions "Category:API systems/RestrictedActions")
- [API functions](https://warcraft.wiki.gg/wiki/Category:API_functions "Category:API functions")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK