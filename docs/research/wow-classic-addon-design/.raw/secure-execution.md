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

# Secure Execution and Tainting

From Warcraft Wiki

[Jump to navigation](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#mw-head) [Jump to search](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#searchInput)

| [Main Menu](https://warcraft.wiki.gg/wiki/Warcraft_Wiki:Interface_customization "Warcraft Wiki:Interface customization") |
| --- |
| - [WoW API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://warcraft.wiki.gg/wiki/Lua_functions "Lua functions")<br>- [Widget API](https://warcraft.wiki.gg/wiki/Widget_API "Widget API")<br>- [XML schema](https://warcraft.wiki.gg/wiki/XML "XML")<br>- [FrameXML](https://warcraft.wiki.gg/wiki/FrameXML_functions "FrameXML functions")<br>- [Events](https://warcraft.wiki.gg/wiki/Events "Events")<br>- [CVars](https://warcraft.wiki.gg/wiki/Console_variables "Console variables")<br>* * *<br>- [Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences "UI escape sequences")<br>- [API changes](https://warcraft.wiki.gg/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://warcraft.wiki.gg/wiki/HOWTOs "HOWTOs")<br>- ![Discord logo.png](https://warcraft.wiki.gg/images/thumb/Discord_logo.png/12px-Discord_logo.png?4d7bc2)[wowuidev](https://discord.gg/txUg39Vhc6) |

|     |     |
| --- | --- |
| ![Fat cat yearns for the mines](https://warcraft.wiki.gg/images/thumb/Fatcat_miner.png/64px-Fatcat_miner.png?82abc0) | The API wiki is under maintenance<br>Since `2026-07-23T06:08:00Z`, ETA: at least multiple days |

The User Interface API mandates human decision-making, particularly in combat, by protecting many functions from insecure or **tainted** use. This security model was largely introduced in [patch 2.0](https://warcraft.wiki.gg/wiki/Patch_2.0 "Patch 2.0")[\[1\]](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#cite_note-1) and has been a cornerstone of the API ever since.

## Contents

- [1Taint](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#Taint)
  - [1.1What can be tainted?](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#What_can_be_tainted?)
  - [1.2Honey analogy](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#Honey_analogy)
- [2Securely post-hooking](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#Securely_post-hooking)
- [3Protected frames and secure templates](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#Protected_frames_and_secure_templates)
- [4Terminology](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#Terminology)
- [5Impact on gameplay](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#Impact_on_gameplay)
- [6Official statements](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#Official_statements)
- [7External links](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#External_links)
- [8References](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#References)

## Taint

When WoW begins executing Lua code, the execution starts off 'secure' and able to run protected functions in all situations. Execution remains secure until it encounters 'taint' - which is an indicator that a function or object came from an untrusted source (AddOn or /script). The basic idea is that execution becomes 'tainted' as soon as it reads data or code introduced by a third party, and any new data written by already-tainted execution becomes also tainted. If an AddOn spreads taint to important game functions, it will prevent them from working (especially in combat). Taint remains for the rest of the game until the player relogs or reloads the interface, which can be crippling because protected functions will refuse to operate if they detect a potentially insecure execution path.

When the UI first loads, all code and data from Blizzard signed FrameXML and AddOns (plus their saved variables) is secure, and all code and data from third-party AddOns (plus their saved variables) is tainted.

### What can be tainted?

All Lua values and references can be tainted - local variables, global variables, table keys, table values:

- When new values are created (e.g. local x = 2) then they inherit the current taint of their execution path.
- When code accesses secure values, the resulting value will be tainted by the current execution path (but the original value remains clean).
- When code accesses tainted values, the resulting value will remain tainted and the execution path is also tainted.
- When code sets global values, the resulting value has the taint of the execution path.

Function closures can also be tainted, executing a function closure applies its
taint to the current environment.

### Honey analogy

To try to get some intuitive feeling for how taint works, it can help to think of taint as sticky honey.

Addon code is always tainted/sticky, and anything you touch also becomes sticky.

Blizzard has clean hands, but if they touch something that you made sticky, their hands are sticky now too. And the stickiness spreads.

Errors occur when Blizzard tries to call a protected function, if they do so while sticky it errors. And since each addon has a different flavor honey, the error handler does a taste test to see which addon is to blame, and will report this in the error message.

## Securely post-hooking

Taint is inherent to third-party code, but the API provides two powerful functions to avoid spreading taint to protected game functions:

[hooksecurefunc(\["table"\], "name", func)](https://warcraft.wiki.gg/wiki/API_hooksecurefunc "API hooksecurefunc")Addons can 'post-hook' a secure global function, inserting their own custom function to be executed _after_ the original. It receives a copy of the same arguments the original did, but executes afterward to prevent tainting the original.[frame:HookScript("scriptTypeName", func)](https://warcraft.wiki.gg/wiki/API_ScriptObject_HookScript "API ScriptObject HookScript")Similar to SetScript() but the custom function is only executed _after_ others; similarly receiving the same arguments but not spreading taint to already-done execution.

## Protected frames and secure templates

WoW 2.0 also introduced a new Frame concept, protected frames, which can bypass interactivity restrictions during combat. However, the caveat is that these must be created and pre-programmed while out of combat using pre-defined attributes. Once combat begins, the game will manage showing, hiding, sizing and positioning the frames in accordinance with whatever attributes had been previously set. The attributes allow for some logic, but limited to a narrow set of rules that ensure practical human involvement. Notwithstanding, [Secure code](https://warcraft.wiki.gg/wiki/Secure_code "Secure code") is a special case that may bypass these restrictions for additional (but still limited) functionality in combat.

Once a frame has been declared protected it cannot be made unprotected, and protection is generally inherited from specially designed templates such as [SecureTemplates](https://warcraft.wiki.gg/wiki/SecureTemplates "SecureTemplates") (basic capability introduced in Patch 2.0) and [SecureHandlers](https://warcraft.wiki.gg/wiki/SecureHandlers "SecureHandlers") (expanded capability introduced in Patch 3.0).

Control restrictions on protected frames are also applied to their parents and any frames they are anchored to. This is important when anchoring a protected frame to another normally non-protected frame, as it can lead to unexpected and often undesired behavior. This propagation is temporary, and re-anchoring or re-parenting the frame out of combat can release the restriction.

Protected frames are important because they form the basis of the Blizzard action and spell buttons, but also because they allow for some new secure button templates. Since normal AddOn code is tainted, it cannot change targets or perform actions directly, however WoW 2.0 contains a number of secure templates which can be inherited by AddOn code. These secure templates provide one or more secure handlers, usually OnClick, that use frame attributes to perform actions. When a secure template is inherited then any handlers it defines remain secure unless they are overridden by the inheriting frame (or another template).

The secure templates are configured using frame:SetAttribute() methods pertinent to each template, but only outside combat. AddOns should check [InCombatLockdown()](https://warcraft.wiki.gg/wiki/API_InCombatLockdown "API InCombatLockdown") before creating secure frames, setting their attributes, or reconfiguring their attributes.

## Terminology

Since there are a number of similar concepts at work here, the terminology can
be confusing, here's a summary of the common terms and their meanings:

- Secure generally means 'without taint'.
- Secure code refers to either an untainted current execution or an untainted function.
- Values/References/Parameters are sometimes referred to as 'clean', this means the same as 'secure'.
- A protected function is one that can only be successfully called from a secure execution state.
- A protected frame is one that is locked down during combat.
- A protected method is one that cannot be successfully called on a protected frame from a tainted execution state during combat.
- Secure templates are simply XML templates that define secure script handlers, they usually also create protected frames.

## Impact on gameplay

Secure execution profoundly limited what addons could do beginning with Patch 2.0, and was widely perceived as necessary to protect gameplay from cheating. Before this security model, addons were capable of vastly automating gameplay by choosing who to target and what spells to cast.

For example, before an addon might choose what spell (and what rank of that spell) to cast after any left click. Since Patch 2.0, this addon can cast one spell after a left-click and another after a right-click, but the human player must decide which button to click. The addon could still suggest a spell to the human player (by displaying information on the screen) but not make any decisions on the player's behalf.

[World of Warcraft: Classic](https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Classic "World of Warcraft: Classic") uses the modern API, including secure execution and tainting. Consequently, addons cannot perform the blatantly harmful automation in Classic that was technically possible in Vanilla.

## Official statements

2006-10-06 00:00 \| [![Blizzard Entertainment](https://warcraft.wiki.gg/images/Blizz.gif?984542)](https://warcraft.wiki.gg/wiki/Blizzard_Entertainment "Blizzard Entertainment")**[Tyren](https://warcraft.wiki.gg/wiki/Tyren "Tyren")**

Hi there, this notification is meant to inform you of some significant changes regarding the way we're handling UI addons. Over the last few years, we've seen a number of awesome, gameplay-enhancing UI mods along with a fair number of UI mods that run counter to our philosophies regarding what addons should and shouldn't be able to do.

Essentially, we don't want UI mods to make combat-sensitive decisions for players and as such, we've made some changes that block functionality that we feel is counter to the spirit of these philosophies. As such, addons and macros will no longer be capable of casting spells or targeting units.

That being said, our programmers have implemented a host of new functionality in order to allow many popular and benign UI mods to continue to function (once those mods are updated to take advantage of the new functionality), and will be providing some follow-up information on these forums as to how to take advantage of the new functionality.

2006-10-06 00:00 \| [![Blizzard Entertainment](https://warcraft.wiki.gg/images/Blizz.gif?984542)](https://warcraft.wiki.gg/wiki/Blizzard_Entertainment "Blizzard Entertainment")**[slouken](https://warcraft.wiki.gg/wiki/Slouken "Slouken")**

Just to clarify, AddOns and macros will still be able to cast spells (with user interaction of course), they just won't be able to use logic to intelligently pick spells or targets.

## External links

- [Taint in World of Warcraft](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html). Townlong Yak. Archived from [the original](https://www.townlong-yak.com/taint.log/about.html) on 2021-05-18.
- [UIDropDownMenu issues](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu). Townlong Yak. Archived from [the original](https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu) on 2020-07-15.

## References

1. [^](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting#cite_ref-1) Guide to Secure Execution and Tainting, forum post by Community MVP [Iriel](https://warcraft.wiki.gg/wiki/Iriel "Iriel"), 13 Oct 2006; now archived at [Card Place WoW BlueTracker](http://blue.cardplace.com/newcache/us/34224257.htm)

| | Collapse<br>Secure Execution |
| --- |
|  |
| Overview | - Secure Execution and Tainting<br>- [SecureTemplates](https://warcraft.wiki.gg/wiki/SecureTemplates "SecureTemplates")<br>- [SecureHandlers](https://warcraft.wiki.gg/wiki/SecureHandlers "SecureHandlers")<br>- [SecureStateDriver](https://warcraft.wiki.gg/wiki/SecureStateDriver "SecureStateDriver")<br>- [RestrictedEnvironment](https://warcraft.wiki.gg/wiki/RestrictedEnvironment "RestrictedEnvironment") |
|  |
| Global API | - [Protected functions](https://warcraft.wiki.gg/wiki/Category:World_of_Warcraft_API/Protected_Functions "Category:World of Warcraft API/Protected Functions")<br>- [issecure](https://warcraft.wiki.gg/wiki/API_issecure "API issecure")<br>- [issecurevariable](https://warcraft.wiki.gg/wiki/API_issecurevariable "API issecurevariable")<br>- [forceinsecure](https://warcraft.wiki.gg/wiki/API_forceinsecure "API forceinsecure")<br>- [hooksecurefunc](https://warcraft.wiki.gg/wiki/API_hooksecurefunc "API hooksecurefunc")<br>- [securecall](https://warcraft.wiki.gg/wiki/API_securecall "API securecall")<br>- [secureexecuterange](https://warcraft.wiki.gg/wiki/API_secureexecuterange "API secureexecuterange") |
|  |
| SecureTemplates | - [ActionButton](https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate "SecureActionButtonTemplate")<br>- [UnitButton](https://warcraft.wiki.gg/wiki/SecureUnitButtonTemplate "SecureUnitButtonTemplate")<br>- [GroupHeader](https://warcraft.wiki.gg/wiki/SecureGroupHeaderTemplate "SecureGroupHeaderTemplate")<br>- GroupPetHeader |
|  |
| SecureHandlers | - [State](https://warcraft.wiki.gg/wiki/SecureHandlerStateTemplate "SecureHandlerStateTemplate")<br>- [Attribute](https://warcraft.wiki.gg/wiki/SecureHandlerAttributeTemplate "SecureHandlerAttributeTemplate")<br>- [Click](https://warcraft.wiki.gg/wiki/SecureHandlerClickTemplate "SecureHandlerClickTemplate")<br>- [DoubleClick](https://warcraft.wiki.gg/wiki/SecureHandlerDoubleClickTemplate "SecureHandlerDoubleClickTemplate")<br>- Drag<br>- MouseUpDown<br>- MouseWheel<br>- EnterLeave<br>- ShowHide |
|  |
| Widget API | - [Frame:SetAttribute](https://warcraft.wiki.gg/wiki/API_Frame_SetAttribute "API Frame SetAttribute")<br>- [SecureHandlerExecute](https://warcraft.wiki.gg/wiki/API_SecureHandlerExecute "API SecureHandlerExecute")<br>- [SecureHandlerWrapScript](https://warcraft.wiki.gg/wiki/API_SecureHandlerWrapScript "API SecureHandlerWrapScript")<br>- [SecureHandlerUnwrapScript](https://warcraft.wiki.gg/wiki/API_SecureHandlerUnwrapScript "API SecureHandlerUnwrapScript")<br>- [SecureHandlerSetFrameRef](https://warcraft.wiki.gg/wiki/API_SecureHandlerSetFrameRef "API SecureHandlerSetFrameRef") |
|  |
| Secret Values | - [Secret Values](https://warcraft.wiki.gg/wiki/Secret_Values "Secret Values") | |

Retrieved from " [https://warcraft.wiki.gg/wiki/Secure\_Execution\_and\_Tainting?oldid=6651217](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting?oldid=6651217)"

[Category](https://warcraft.wiki.gg/wiki/Special:Categories "Special:Categories"):

- [UI technical details](https://warcraft.wiki.gg/wiki/Category:UI_technical_details "Category:UI technical details")

Cookies help us deliver our services. By using our services, you agree to our use of cookies.

[More information](https://www.indie.io/privacy-policy)OK