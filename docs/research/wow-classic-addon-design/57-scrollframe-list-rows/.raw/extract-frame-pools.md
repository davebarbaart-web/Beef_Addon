- [AddOns](https://www.wowinterface.com/addons.php?s=875d688c28387c0715712444e69677c8)
  - [AddOn Manager](https://www.minion.gg/)
  - [Latest 200](https://www.wowinterface.com/downloads/latest.php?s=875d688c28387c0715712444e69677c8)
  - [Browse](https://www.wowinterface.com/addons.php)
  - [Upload AddOn](https://www.wowinterface.com/downloads/upload-update.php?s=875d688c28387c0715712444e69677c8)
  - [Search AddOns](https://www.wowinterface.com/downloads/search.php?s=875d688c28387c0715712444e69677c8&)
  - [Projects](https://www.wowinterface.com/forums/showthread.php?t=58069)
    - [Author Portals](https://www.wowinterface.com/listportals.php?s=875d688c28387c0715712444e69677c8)
    - [Git Repositories](http://git.wowinterface.com/)
    - [SVN Repositories](http://svn.wowinterface.com/)
  - [Options](https://www.wowinterface.com/forums/showthread.php?t=58069)
    - [Email Feeds](https://www.wowinterface.com/downloads/filecpl.php?s=875d688c28387c0715712444e69677c8&action=feeds)
    - [Preference](https://www.wowinterface.com/downloads/filecpl.php?s=875d688c28387c0715712444e69677c8&action=modifyoptions)
    - [Download History](https://www.wowinterface.com/downloads/filecpl.php?s=875d688c28387c0715712444e69677c8&action=showdlhistory)

- [News](https://www.wowinterface.com/community.php?s=875d688c28387c0715712444e69677c8)

- [Forums](https://www.wowinterface.com/forums/index.php?s=875d688c28387c0715712444e69677c8)
  - [New posts](https://www.wowinterface.com/forums/search.php?s=875d688c28387c0715712444e69677c8&do=getnew)
  - [Today's Posts](https://www.wowinterface.com/forums/search.php?s=875d688c28387c0715712444e69677c8&do=getdaily)
  - [Search Forum](https://www.wowinterface.com/forums/search.php?s=875d688c28387c0715712444e69677c8&)
  - [Categories](https://www.wowinterface.com/forums/index.php?s=875d688c28387c0715712444e69677c8)
    - [General](https://www.wowinterface.com/forums/forumdisplay.php?f=142)
    - [AddOns, Comps, Macros](https://www.wowinterface.com/forums/forumdisplay.php?f=8)
    - [Featured Projects](https://www.wowinterface.com/forums/forumdisplay.php?f=27)
    - [Developer](https://www.wowinterface.com/forums/forumdisplay.php?f=11)
    - [Site Forums](https://www.wowinterface.com/forums/forumdisplay.php?f=4)
  - [Mark Forums Read](https://www.wowinterface.com/forums/forumdisplay.php?s=875d688c28387c0715712444e69677c8&do=markread)
  - [Subscribed Threads](https://www.wowinterface.com/forums/subscription.php?s=875d688c28387c0715712444e69677c8)
  - [Open Buddy List](https://www.wowinterface.com/forums/showthread.php?t=58069#)
  - [Members List](https://www.wowinterface.com/forums/memberlist.php?s=875d688c28387c0715712444e69677c8&)

- [Help](https://www.wowinterface.com/forums/faq.php?s=875d688c28387c0715712444e69677c8)

- [Login](https://www.wowinterface.com/login.php)
- [Sign up](https://www.wowinterface.com/forums/register.php?s=875d688c28387c0715712444e69677c8)

[WoWInterface](https://www.wowinterface.com/forums/index.php?s=875d688c28387c0715712444e69677c8)» [Developer Discussions](https://www.wowinterface.com/forums/forumdisplay.php?s=875d688c28387c0715712444e69677c8&f=11)» [Lua/XML Help](https://www.wowinterface.com/forums/forumdisplay.php?s=875d688c28387c0715712444e69677c8&f=16)

» **Dynamically adding and removing frames?**

|     |
| --- |
| Go to Page... |
|  |

|     |
| --- |
| [Reply](https://www.wowinterface.com/forums/newreply.php?s=875d688c28387c0715712444e69677c8&do=newreply&noquote=1&p=336248) |

|     |     |
| --- | --- |
| [**View First Unread**](https://www.wowinterface.com/forums/showthread.php?t=58069#post336248) | [Thread Tools](https://www.wowinterface.com/forums/showthread.php?t=58069&nojs=1#goto_threadtools)![](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/misc/menu_open.gif) |

|     |     |
| --- | --- |
| 06-29-20, 09:27 PM | # [**1**](https://www.wowinterface.com/forums/showpost.php?s=875d688c28387c0715712444e69677c8&p=336248&postcount=1) |
| [hux4](https://www.wowinterface.com/forums/member.php?s=875d688c28387c0715712444e69677c8&u=347786)

A Kobold Labourer

|     |
| --- |
|  |

Join Date: Jun 2020

Posts: 1 | **Dynamically adding and removing frames?**<br>* * *<br>Hello! I'm new to creating addons and playing around with my first one. The bulk of my addon is a queue'ing system where players will be added to a queue and then a frame with their name / location / spot in queue will show up. As more people queue, more frames are added dynamically under the other frames. <br>I am wondering what the best way to approach this is? Ideally it would be an array of frames than are added one after another and then removed from the first spot onward. I know you cant "remove" a frame, so thats another thing I have to tackle.<br>Anyway, would appreciate any steering or ideas on how should I approach this.<br>Thanks. |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://www.wowinterface.com/forums/newreply.php?s=875d688c28387c0715712444e69677c8&do=newreply&p=336248) |

|     |
| --- |
| hux4 |
| [View Public Profile](https://www.wowinterface.com/forums/member.php?s=875d688c28387c0715712444e69677c8&u=347786) |
| [Send a private message to hux4](https://www.wowinterface.com/forums/private.php?s=875d688c28387c0715712444e69677c8&do=newpm&u=347786) |
| [Find More Posts by hux4](https://www.wowinterface.com/forums/search.php?s=875d688c28387c0715712444e69677c8&do=finduser&u=347786) |

|     |     |
| --- | --- |
| 06-30-20, 01:25 AM | # [**2**](https://www.wowinterface.com/forums/showpost.php?s=875d688c28387c0715712444e69677c8&p=336249&postcount=2) |
| [Fizzlemizz](https://www.wowinterface.com/forums/member.php?s=875d688c28387c0715712444e69677c8&u=281326)

I did that?

[![Fizzlemizz's Avatar](https://www.wowinterface.com/forums/image.php?s=875d688c28387c0715712444e69677c8&u=281326&dateline=1323801005)](https://www.wowinterface.com/forums/member.php?s=875d688c28387c0715712444e69677c8&u=281326)

|     |
| --- |
| [![Premium Member](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/misc/badges/premium-badge.gif)](https://www.wowinterface.com/premium.php?s=875d688c28387c0715712444e69677c8&)<br>[![AddOn Author - Click to view addons](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/misc/badges/author-list-link.gif)](https://www.wowinterface.com/portal281326.html) |

Join Date: Dec 2011

Posts: 2,028 | At it's simplest, you have a table of "active" frames. As they become no-longer "active" you move the frame to a "pool" table of inactive frames (delete the frame reference from the active table and add it to the inactive table). <br>If you need a new frame and the pool is empty, you create a new frame and add it to the active table otherwise take one from the pool table(delete the frame reference from the inactive table and add it to the active table).<br>This becomes more involved if you want to have frame types for different purposes and how far you want to abstract the pool concept but the general idea is the same.<br>To add a new active frame:<br>Lua Code:<br>```<br>local frame<br>if #MyInactiveFrameTable > 0 then -- 1 or more frames in the inactive table<br>      frame = MyInactiveFrameTable[1] -- grab the 1st one<br>      tremove(MyInactiveFrameTable, 1) -- and remove it from the table<br>else -- otherwise<br>      -- create a new frame<br>      frame = CreateFream(...)<br>       -- add frame elements<br>end<br>tinsert(MyActiveFrameTable, frame)  -- add the frame to the active table<br>-- update "frame" with new information to display<br>```<br>To "deactivate" active frame:<br>Lua Code:<br>```<br>tinsert(MyInactiveFrameTable, MyActiveFrameTable[1]) <br>tremove(MyActiveFrameTable, 1)<br>```<br>\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_<br>Fizzlemizz<br>Maintainer of [Discord Unit Frames](https://www.wowinterface.com/downloads/info20607-DiscordUnitFrames.html) and [Discord Art](https://www.wowinterface.com/downloads/info21942-DiscordArt.html).<br>Author of [FauxMazzle](https://www.wowinterface.com/downloads/info22624-FauxMazzle.html), [FauxMazzleHUD](https://www.wowinterface.com/downloads/info24871-FauxMazzleHUD.html) and [Move Pad Plus.](https://www.wowinterface.com/downloads/info23723-MovePadPlus.html)<br>* * *<br>_Last edited by Fizzlemizz : 06-30-20 at 03:01 AM._ |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://www.wowinterface.com/forums/newreply.php?s=875d688c28387c0715712444e69677c8&do=newreply&p=336249) |

|     |
| --- |
| Fizzlemizz |
| [View Public Profile](https://www.wowinterface.com/forums/member.php?s=875d688c28387c0715712444e69677c8&u=281326) |
| [Send a private message to Fizzlemizz](https://www.wowinterface.com/forums/private.php?s=875d688c28387c0715712444e69677c8&do=newpm&u=281326) |
| [Find More Posts by Fizzlemizz](https://www.wowinterface.com/forums/search.php?s=875d688c28387c0715712444e69677c8&do=finduser&u=281326) |

|     |     |
| --- | --- |
| 06-30-20, 06:03 AM | # [**3**](https://www.wowinterface.com/forums/showpost.php?s=875d688c28387c0715712444e69677c8&p=336263&postcount=3) |
| [SDPhantom](https://www.wowinterface.com/forums/member.php?s=875d688c28387c0715712444e69677c8&u=34145)

A Pyroguard Emberseer

[![SDPhantom's Avatar](https://www.wowinterface.com/forums/image.php?s=875d688c28387c0715712444e69677c8&u=34145&dateline=1423817608)](https://www.wowinterface.com/forums/member.php?s=875d688c28387c0715712444e69677c8&u=34145)

|     |
| --- |
| [![AddOn Author - Click to view addons](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/misc/badges/author-list-link.gif)](https://www.wowinterface.com/downloads/author-34145.html) |

Join Date: Jul 2006

Posts: 2,404 | To answer a question that shows up a lot here, frames cannot be "removed" from memory. They stay persistent throughout an entire session. The best you can do is recycle frames by use of "Frame Pools".

Here's a simpler way and keeping a separate table just for active frames in a frame pool is unnecessary if you're already keeping track of them in other parts of your code.

Lua Code:

```
local FramePool={};



local function FramePool_Acquire()

    return table.remove(FramePool) or CreateFrame("Frame");--   Returns a frame if there is one in the pool or creates one if empty

end



local function FramePool_Release(frame)

    table.insert(frame);--  Stores frame in pool

end
```

Note: You should create a different pool for each frame template you wish to use in order to keep them from getting mixed up.

If you're feeling adventurous, you might want to take a look at Blizzard's implementation of frame and object pools in [SharedXML\\Pools.lua](https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/Pools.lua).

You'll want to pay attention to [**CreateFramePool()**](https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/Pools.lua#L144-L148) for a singilar frame pool and [**CreatePoolCollection()**](https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/Pools.lua#L222-L226) to manage different templates.

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

[WoWInterface AddOns](https://www.wowinterface.com/downloads/author-34145.html)

|     |
| --- |
| "All I want is a pretty girl, a decent meal, and the right to shoot lightning at fools."<br>-Anders (Dragon Age: Origins - Awakening) |

* * *

_Last edited by SDPhantom : 06-30-20 at 06:09 AM._ |
|  | [![Reply With Quote](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/quote.gif)](https://www.wowinterface.com/forums/newreply.php?s=875d688c28387c0715712444e69677c8&do=newreply&p=336263) |

|     |
| --- |
| SDPhantom |
| [View Public Profile](https://www.wowinterface.com/forums/member.php?s=875d688c28387c0715712444e69677c8&u=34145) |
| [Send a private message to SDPhantom](https://www.wowinterface.com/forums/private.php?s=875d688c28387c0715712444e69677c8&do=newpm&u=34145) |
| [Find More Posts by SDPhantom](https://www.wowinterface.com/forums/search.php?s=875d688c28387c0715712444e69677c8&do=finduser&u=34145) |

|     |
| --- |
| [Reply](https://www.wowinterface.com/forums/newreply.php?s=875d688c28387c0715712444e69677c8&do=newreply&noquote=1&p=336248) |

|     |     |     |
| --- | --- | --- |
| [Go Back](https://www.wowinterface.com/forums/showthread.php?t=58069# "Go Back") | [WoWInterface](https://www.wowinterface.com/forums/index.php?s=875d688c28387c0715712444e69677c8)» [Developer Discussions](https://www.wowinterface.com/forums/forumdisplay.php?s=875d688c28387c0715712444e69677c8&f=11)» [Lua/XML Help](https://www.wowinterface.com/forums/forumdisplay.php?s=875d688c28387c0715712444e69677c8&f=16)»<br> Dynamically adding and removing frames? | **«** [Previous Thread](https://www.wowinterface.com/forums/showthread.php?s=875d688c28387c0715712444e69677c8&t=58069&goto=nextoldest)<br>\|<br>[Next Thread](https://www.wowinterface.com/forums/showthread.php?s=875d688c28387c0715712444e69677c8&t=58069&goto=nextnewest) **»** |

|     |
| --- |
| Thread Tools |
| [Show Printable Version](https://www.wowinterface.com/forums/printthread.php?s=875d688c28387c0715712444e69677c8&t=58069) |
| [Email this Page](https://www.wowinterface.com/forums/sendmessage.php?s=875d688c28387c0715712444e69677c8&do=sendtofriend&t=58069) |

| | [![](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/buttons/collapse_thead.gif)](https://www.wowinterface.com/forums/showthread.php?t=58069#top)<br> Posting Rules |
| --- |
| You **may not** post new threads<br>You **may not** post replies<br>You **may not** post attachments<br>You **may not** edit your posts<br>* * *<br>[vB code](https://www.wowinterface.com/forums/misc.php?s=875d688c28387c0715712444e69677c8&do=bbcode) is **On**<br>[Smilies](https://www.wowinterface.com/forums/misc.php?s=875d688c28387c0715712444e69677c8&do=showsmilies) are **On**<br>[\[IMG\]](https://www.wowinterface.com/forums/misc.php?s=875d688c28387c0715712444e69677c8&do=bbcode#imgcode) code is **On**<br>HTML code is **Off** | | |     |
| --- |
|  | |

WoWInterface

- [Home](https://www.wowinterface.com/)
- [Contact WoWInterface](https://mmoui.com/?s=875d688c28387c0715712444e69677c8&contact)
- [Terms of Service](http://mmoui.com/?tos)
- [Privacy Statement](http://mmoui.com/?privacy)
- [Top](https://www.wowinterface.com/forums/showthread.php?t=58069#top)

AddOn Sites

- [Cube World Mods](http://www.cwmods.com/)
- [ESOUI](http://www.esoui.com/)
- [EQInterface](http://www.eqinterface.com/)
- [EQ2Interface](http://www.eq2interface.com/)
- [LotROInterface](http://www.lotrointerface.com/)
- [Riftui](http://www.riftui.com/)
- [SecretUI](http://www.secretui.com/)
- [Swtorui](http://www.swtorui.com/)
- [WoWInterface](https://www.wowinterface.com/)

![MMOUI](https://cdn-wow.mmoui.com/images/style_mmoi_wowi2/layout/mmoui-copyright.png)

© 2004 - 2025 MMOUI

vBulletin © 2026, Jelsoft Enterprises Ltd