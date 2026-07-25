- [AddOns](https://www.wowinterface.com/addons.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)
  - [AddOn Manager](https://www.minion.gg/)
  - [Latest 200](https://www.wowinterface.com/downloads/latest.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)
  - [Browse](https://www.wowinterface.com/addons.php)
  - [Upload AddOn](https://www.wowinterface.com/downloads/upload-update.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)
  - [Search AddOns](https://www.wowinterface.com/downloads/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&)
  - [Projects](https://wowinterface.com/forums/showthread.php?t=52623)
    - [Author Portals](https://www.wowinterface.com/listportals.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)
    - [Git Repositories](http://git.wowinterface.com/)
    - [SVN Repositories](http://svn.wowinterface.com/)
  - [Options](https://wowinterface.com/forums/showthread.php?t=52623)
    - [Email Feeds](https://www.wowinterface.com/downloads/filecpl.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&action=feeds)
    - [Preference](https://www.wowinterface.com/downloads/filecpl.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&action=modifyoptions)
    - [Download History](https://www.wowinterface.com/downloads/filecpl.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&action=showdlhistory)

- [News](https://www.wowinterface.com/community.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)

- [Forums](https://www.wowinterface.com/forums/index.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)
  - [New posts](https://www.wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=getnew)
  - [Today's Posts](https://www.wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=getdaily)
  - [Search Forum](https://www.wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&)
  - [Categories](https://www.wowinterface.com/forums/index.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)
    - [General](https://www.wowinterface.com/forums/forumdisplay.php?f=142)
    - [AddOns, Comps, Macros](https://www.wowinterface.com/forums/forumdisplay.php?f=8)
    - [Featured Projects](https://www.wowinterface.com/forums/forumdisplay.php?f=27)
    - [Developer](https://www.wowinterface.com/forums/forumdisplay.php?f=11)
    - [Site Forums](https://www.wowinterface.com/forums/forumdisplay.php?f=4)
  - [Mark Forums Read](https://www.wowinterface.com/forums/forumdisplay.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=markread)
  - [Subscribed Threads](https://www.wowinterface.com/forums/subscription.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)
  - [Open Buddy List](https://wowinterface.com/forums/showthread.php?t=52623#)
  - [Members List](https://www.wowinterface.com/forums/memberlist.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&)

- [Help](https://www.wowinterface.com/forums/faq.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)

- [Login](https://www.wowinterface.com/login.php)
- [Sign up](https://www.wowinterface.com/forums/register.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)

[WoWInterface](https://wowinterface.com/forums/index.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)» [Developer Discussions](https://wowinterface.com/forums/forumdisplay.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&f=11)» [Lua/XML Help](https://wowinterface.com/forums/forumdisplay.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&f=16)

» **HybridScrollFrame\_CreateButtons / buttonTemplate Question**

|     |
| --- |
| Go to Page... |
|  |

|     |
| --- |
| [Reply](https://wowinterface.com/forums/newreply.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newreply&noquote=1&p=310402) |

|     |     |
| --- | --- |
| [**View First Unread**](https://wowinterface.com/forums/showthread.php?t=52623#post310402) | [Thread Tools](https://wowinterface.com/forums/showthread.php?t=52623&nojs=1#goto_threadtools)![](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/misc/menu_open.gif) |

|     |     |
| --- | --- |
| 08-17-15, 02:33 PM | # [**1**](https://wowinterface.com/forums/showpost.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&p=310402&postcount=1) |
| [Spiderkeg](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=37882)

A Deviate Faerie Dragon

|     |
| --- |
|  |

Join Date: Sep 2006

Posts: 18 | **HybridScrollFrame\_CreateButtons / buttonTemplate Question**<br>* * *<br>First off, thanks in advance.<br>I have created a working hybrid scroll frame using the HybridScrollFrame API. However, my question revolves around the HybridScrollFrame\_CreateButtons function:<br>Code:<br>```<br>function HybridScrollFrame_CreateButtons (self, buttonTemplate, initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)<br>		...<br>		button = CreateFrame("BUTTON", buttonName .. 1, scrollChild, buttonTemplate);<br>```<br>The function requires a buttonTemplate param to be passed in, and at the moment I have a simple XML file with a few lines of code for a button, that's it.<br>I would prefer to keep everything as Lua, so is there any way for me to create a template using Lua that I can pass into this function and that will actually work?<br>I realize that, as a fallback solution, I could duplicate this function and alter it to fit my simple needs, but before doing so I figure I'd ask here.<br>Any thoughts? |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://wowinterface.com/forums/newreply.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newreply&p=310402) |

|     |
| --- |
| Spiderkeg |
| [View Public Profile](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=37882) |
| [Send a private message to Spiderkeg](https://wowinterface.com/forums/private.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newpm&u=37882) |
| [Find More Posts by Spiderkeg](https://wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=finduser&u=37882) |

|     |     |
| --- | --- |
| 08-17-15, 03:12 PM | # [**2**](https://wowinterface.com/forums/showpost.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&p=310403&postcount=2) |
| [Lombra](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051)

A Molten Giant

[![Lombra's Avatar](https://wowinterface.com/forums/image.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051&dateline=1412635461)](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051)

|     |
| --- |
| [![AddOn Author - Click to view addons](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/misc/badges/author-list-link.gif)](https://www.wowinterface.com/downloads/author-42051.html) |

Join Date: Nov 2006

Posts: 553 | No, you can only create templates using XML.<br>\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_<br>_Grab your sword and fight the Horde!_ |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://wowinterface.com/forums/newreply.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newreply&p=310403) |

|     |
| --- |
| Lombra |
| [View Public Profile](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051) |
| [Send a private message to Lombra](https://wowinterface.com/forums/private.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newpm&u=42051) |
| [Find More Posts by Lombra](https://wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=finduser&u=42051) |

|     |     |
| --- | --- |
| 08-17-15, 03:20 PM | # [**3**](https://wowinterface.com/forums/showpost.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&p=310404&postcount=3) |
| [Spiderkeg](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=37882)

A Deviate Faerie Dragon

|     |
| --- |
|  |

Join Date: Sep 2006

Posts: 18 | |     |
| --- |
| Originally Posted by **Lombra** [![View Post](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/viewpost.gif)](https://wowinterface.com/forums/showthread.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&p=310403#post310403)<br>No, you can only create templates using XML. |

So if I want an all-Lua solution, creating my own function based on the given Blizzard function would be my best option, yes? |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://wowinterface.com/forums/newreply.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newreply&p=310404) |

|     |
| --- |
| Spiderkeg |
| [View Public Profile](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=37882) |
| [Send a private message to Spiderkeg](https://wowinterface.com/forums/private.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newpm&u=37882) |
| [Find More Posts by Spiderkeg](https://wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=finduser&u=37882) |

|     |     |
| --- | --- |
| 08-18-15, 03:55 AM | # [**4**](https://wowinterface.com/forums/showpost.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&p=310415&postcount=4) |
| [Lombra](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051)

A Molten Giant

[![Lombra's Avatar](https://wowinterface.com/forums/image.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051&dateline=1412635461)](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051)

|     |
| --- |
| [![AddOn Author - Click to view addons](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/misc/badges/author-list-link.gif)](https://www.wowinterface.com/downloads/author-42051.html) |

Join Date: Nov 2006

Posts: 553 | Yeah, or you can reuse some of the original function for some initialization logic. I've done this myself numerous times for hybrid scrolls. I don't use it any longer, but this is what I found in some old code:<br>Code:<br>```<br>local BUTTON_HEIGHT = 18<br>local BUTTON_OFFSET = 2<br>local buttons = {}<br>scrollFrame.buttons = buttons<br>for i = 1, (ceil(scrollFrame:GetHeight() / BUTTON_HEIGHT) + 1) do<br>	local button = createButton(scrollFrame.scrollChild)<br>	if i == 1 then<br>		button:SetPoint("TOPLEFT", 2, -1)<br>	else<br>		button:SetPoint("TOPLEFT", buttons[i - 1], "BOTTOMLEFT", 0, -BUTTON_OFFSET)<br>	end<br>	buttons[i] = button<br>end<br>HybridScrollFrame_CreateButtons(scrollFrame, nil, nil, nil, nil, nil, nil, -BUTTON_OFFSET)<br>```<br>\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_<br>_Grab your sword and fight the Horde!_ |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://wowinterface.com/forums/newreply.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newreply&p=310415) |

|     |
| --- |
| Lombra |
| [View Public Profile](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051) |
| [Send a private message to Lombra](https://wowinterface.com/forums/private.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newpm&u=42051) |
| [Find More Posts by Lombra](https://wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=finduser&u=42051) |

|     |     |
| --- | --- |
| 08-18-15, 07:58 AM | # [**5**](https://wowinterface.com/forums/showpost.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&p=310418&postcount=5) |
| [Spiderkeg](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=37882)

A Deviate Faerie Dragon

|     |
| --- |
|  |

Join Date: Sep 2006

Posts: 18 | |     |
| --- |
| Originally Posted by **Lombra** [![View Post](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/viewpost.gif)](https://wowinterface.com/forums/showthread.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&p=310415#post310415)<br>Yeah, or you can reuse some of the original function for some initialization logic. I've done this myself numerous times for hybrid scrolls. I don't use it any longer, but this is what I found in some old code:<br>Code:<br>```<br>local BUTTON_HEIGHT = 18<br>local BUTTON_OFFSET = 2<br>local buttons = {}<br>scrollFrame.buttons = buttons<br>for i = 1, (ceil(scrollFrame:GetHeight() / BUTTON_HEIGHT) + 1) do<br>	local button = createButton(scrollFrame.scrollChild)<br>	if i == 1 then<br>		button:SetPoint("TOPLEFT", 2, -1)<br>	else<br>		button:SetPoint("TOPLEFT", buttons[i - 1], "BOTTOMLEFT", 0, -BUTTON_OFFSET)<br>	end<br>	buttons[i] = button<br>end<br>HybridScrollFrame_CreateButtons(scrollFrame, nil, nil, nil, nil, nil, nil, -BUTTON_OFFSET)<br>``` |

Fascinating, thank you. I can't help but be curious, what is your approach now? |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://wowinterface.com/forums/newreply.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newreply&p=310418) |

|     |
| --- |
| Spiderkeg |
| [View Public Profile](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=37882) |
| [Send a private message to Spiderkeg](https://wowinterface.com/forums/private.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newpm&u=37882) |
| [Find More Posts by Spiderkeg](https://wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=finduser&u=37882) |

|     |     |
| --- | --- |
| 08-18-15, 08:46 AM | # [**6**](https://wowinterface.com/forums/showpost.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&p=310419&postcount=6) |
| [Lombra](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051)

A Molten Giant

[![Lombra's Avatar](https://wowinterface.com/forums/image.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051&dateline=1412635461)](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051)

|     |
| --- |
| [![AddOn Author - Click to view addons](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/misc/badges/author-list-link.gif)](https://www.wowinterface.com/downloads/author-42051.html) |

Join Date: Nov 2006

Posts: 553 | Well, I still do essentially the same thing, but I've made a small framework out of it, implementing more of the logic myself and making some other changes allowing me deploy and use scroll frames quickly. At the core it still uses some of the hybrid scroll functions provided by Blizzard. I found myself using these scroll frames in many projects, so it seemed worth the effort!<br>\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_<br>_Grab your sword and fight the Horde!_ |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://wowinterface.com/forums/newreply.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newreply&p=310419) |

|     |
| --- |
| Lombra |
| [View Public Profile](https://wowinterface.com/forums/member.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&u=42051) |
| [Send a private message to Lombra](https://wowinterface.com/forums/private.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newpm&u=42051) |
| [Find More Posts by Lombra](https://wowinterface.com/forums/search.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=finduser&u=42051) |

|     |
| --- |
| [Reply](https://wowinterface.com/forums/newreply.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=newreply&noquote=1&p=310402) |

|     |     |     |
| --- | --- | --- |
| [Go Back](https://wowinterface.com/forums/showthread.php?t=52623# "Go Back") | [WoWInterface](https://wowinterface.com/forums/index.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b)» [Developer Discussions](https://wowinterface.com/forums/forumdisplay.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&f=11)» [Lua/XML Help](https://wowinterface.com/forums/forumdisplay.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&f=16)»<br> HybridScrollFrame\_CreateButtons / buttonTemplate Question | **«** [Previous Thread](https://wowinterface.com/forums/showthread.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&t=52623&goto=nextoldest)<br>\|<br>[Next Thread](https://wowinterface.com/forums/showthread.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&t=52623&goto=nextnewest) **»** |

|     |
| --- |
| Thread Tools |
| [Show Printable Version](https://wowinterface.com/forums/printthread.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&t=52623) |
| [Email this Page](https://wowinterface.com/forums/sendmessage.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=sendtofriend&t=52623) |

| | [![](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/collapse_thead.gif)](https://wowinterface.com/forums/showthread.php?t=52623#top)<br> Posting Rules |
| --- |
| You **may not** post new threads<br>You **may not** post replies<br>You **may not** post attachments<br>You **may not** edit your posts<br>* * *<br>[vB code](https://wowinterface.com/forums/misc.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=bbcode) is **On**<br>[Smilies](https://wowinterface.com/forums/misc.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=showsmilies) are **On**<br>[\[IMG\]](https://wowinterface.com/forums/misc.php?s=aeab0f9b55dc2201a0c0e0a29fe9826b&do=bbcode#imgcode) code is **On**<br>HTML code is **Off** | | |     |
| --- |
|  | |

WoWInterface

- [Home](https://www.wowinterface.com/)
- [Contact WoWInterface](https://mmoui.com/?s=aeab0f9b55dc2201a0c0e0a29fe9826b&contact)
- [Terms of Service](http://mmoui.com/?tos)
- [Privacy Statement](http://mmoui.com/?privacy)
- [Top](https://wowinterface.com/forums/showthread.php?t=52623#top)

AddOn Sites

- [Cube World Mods](http://www.cwmods.com/)
- [ESOUI](http://www.esoui.com/)
- [EQInterface](http://www.eqinterface.com/)
- [EQ2Interface](http://www.eq2interface.com/)
- [LotROInterface](http://www.lotrointerface.com/)
- [Riftui](http://www.riftui.com/)
- [SecretUI](http://www.secretui.com/)
- [Swtorui](http://www.swtorui.com/)
- [WoWInterface](http://www.wowinterface.com/)

![MMOUI](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/layout/mmoui-copyright.png)

© 2004 - 2025 MMOUI

vBulletin © 2026, Jelsoft Enterprises Ltd