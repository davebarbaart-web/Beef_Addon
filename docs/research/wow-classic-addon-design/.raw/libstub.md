[![promotional banner](https://media.forgecdn.net/banners-image-urls/banners-image-url_87348f68-3700-493e-860b-27ca0f2510b0.webp)![mobile promotional banner](https://media.forgecdn.net/banners-image-urls/banners-image-url_5470a2ea-c09b-44b9-b9d9-108c8f9083cc.webp)](https://links.curseforge.com/mc_modjam_2026_top)

[![LibStub logo](https://www.curseforge.com/images/flame.svg)](https://www.curseforge.com/wow/addons/libstub#project-logo)

# LibStub

- By
[![Kaelten](https://static-cdn.jtvnw.net/jtv_user_pictures/kaelten-profile_image-b4e83627186bd6e1-150x150.jpeg)Kaelten\\
![GrandArtisan tier icon](https://www.curseforge.com/images/legends/grand-artisan-icon.svg)](https://www.curseforge.com/members/kaelten)


Universal Library Stub

Download

- [Description](https://www.curseforge.com/wow/addons/libstub)
- [Files](https://www.curseforge.com/wow/addons/libstub/files?page=1&pageSize=20&showAlphaFiles=hide)
- [Gallery](https://www.curseforge.com/wow/addons/libstub/gallery)
- [Relations](https://www.curseforge.com/wow/addons/libstub/relations/dependencies)
- [Issues](https://legacy.curseforge.com/wow/addons/libstub/issues)

LibStub is a minimalistic versioning library that allows other libraries to easily register themselves and upgrade. It is meant to be a cross-community library sharing system.
LibStub is hereby placed in the Public Domain
Credits: Kaelten, Cladhaire, ckknight, Mikk, Ammo, Nevcairiel, joshborke

## LibStub-1.0 API

### :GetLibrary(major \[, silent\])

#### Returns

The table instance of a registered library or nil if not found and the minor version of the library as the second return value.

#### Arguments

major
The name of the library you are requesting
silent
(Optional) Suppresses errors when the library is not found

### :IterateLibraries()

#### Returns

An iterator over the registered major libraries.

### :NewLibrary(major , minor)

#### Returns

The table to be used by the library as well as the minor version of the previously registered library, if any.

#### Arguments

major
The name of the library you are requesting
minor
The minor for the registering library

## Who uses LibStub?

- **Ace3**, for which it was originally designed


- **Rock**, ckknight's framework


- Norganna has announced that the next major version of Auctioneer will use it for its libraries


- Some Dongle-related libraries use it.


- ... and hopefully many more to come!


## How to include LibStub in a library or addon

### Library

if using the WoWAce repositories

- setup an external pointing to <tt>svn://svn.wowace.com/wow/libstub/mainline/trunk</tt> in the .pkgmeta file

- disable nolib creation by adding <tt>enable-nolib-creation: no</tt> to the .pkgmeta file

- set up your <library>.toc file to load LibStub.lua (in case you support stand alone loading of the lib)

- don't load LibStub via the xml file ment for embedded loading of your lib

- don't set LibStub as X-embeded or OptDep


otherwise

- get a copy of the current version

- copy LibStub.lua into your library's folder

- set up your <library>.toc file to load LibStub.lua (in case you support stand alone loading of the lib)

- don't load LibStub via the xml file ment for embedded loading of your lib

- don't set LibStub as X-embeded or OptDep


### AddOn

if using the WoWAce repositories

- set up an external pointing to <tt>svn://svn.wowace.com/wow/libstub/mainline/trunk</tt> in the .pkgmeta file

- set up your <addon>.toc or embeds.xml file to load LibStub.lua

- don't set LibStub as X-embeded or OptDep


otherwise

- get a copy of the current version

- copy LibStub.lua into your addon's folder or a subfolder of it

- set up your <addon>.toc or embeds.xml file to load LibStub.lua

- don't set LibStub as X-embeded or OptDep


## Examples

### Basic example

```
local lib = LibStub:NewLibrary("MyLibrary-1.0", 1)

if not lib then
  return	-- already loaded and no upgrade necessary
end

lib.somearray = lib.somearray or {}

if not lib.frame then
  lib.frame=CreateFrame("Frame")
end

function lib:SomeFunction()
  -- do stuff here
end

function lib:SomeOtherFunction()
  -- do other stuff here
end

local function OnUpdate()
  -- timing stuff here
end

lib.frame:SetScript("OnUpdate", OnUpdate);
```

### Using revision control system tags for minor version

```
local lib = LibStub:NewLibrary("MyLibrary-1.0", "$Revision: 12345$")
```

Do be aware that moving a library from one repository to another will change revision numbers. Do not ever let it slide backwards. If you are caught in this situation, you might want to use something like:

```
local lib = LibStub:NewLibrary("MyLibrary-1.0",
  12345+tonumber(strmatch("%d+","$Revision: 2$"))
)
```

### Embedding / Mixing in

This is a convention rather than a function of the specification, but all Ace3 and Rock related libraries use the following semantics for doing embedding / mixing in (specifically, libraries with an .Embed() member can be specified as embeds during addon object creation rather than having to embed them explicitly):

```
lib.mixinTargets = lib.mixinTargets or {}
local mixins = {"SomeFunction", "SomeOtherFunction" }

function lib:Embed(target)
  for _,name in pairs(mixins) do
    target[name] = lib[name]
  end
  lib.mixinTargets[target] = true
end
```

... and at the end of the file, we handle library upgrades by simply re-embedding the library in all positions where it has previously been embedded / mixed in:

```
for target,_ in pairs(mixinTargets) do
  lib:Embed(target)
end
```

## The LibStub Team

![GrandArtisan tier frame](https://www.curseforge.com/images/legends/grand-artisan-tier-frame-large.svg)![profile avatar](https://static-cdn.jtvnw.net/jtv_user_pictures/kaelten-profile_image-b4e83627186bd6e1-150x150.jpeg)

[Kaelten](https://www.curseforge.com/members/kaelten)

Owner

![GrandArtisan tier icon](https://www.curseforge.com/images/legends/grand-artisan-icon.svg)

- 6

Followers

- 39

Projects

- 23.8M

Downloads


[Donate](https://www.paypal.com/cgi-bin/webscr?return=https://www.curseforge.com/projects/libstub&cn=Add+special+instructions+to+the+addon+author()&business=kaelten%40gmail.com&bn=PP-DonationsBF:btn_donateCC_LG.gif:NonHosted&cancel_return=https://www.curseforge.com/projects/libstub&lc=US&item_name=LibStub+(from+www.curseforge.com)&cmd=_donations&rm=1&no_shipping=1&currency_code=USD) Follow

### Members

[![profile avatar](https://static-cdn.jtvnw.net/user-default-pictures-uv/dbdc9198-def8-11e9-8681-784f43822e80-profile_image-50x50.png)\\
\\
jnwhiteh\\
\\
![GrandArtisan tier icon](https://www.curseforge.com/images/legends/grand-artisan-icon.svg)\\
\\
Author](https://www.curseforge.com/members/jnwhiteh) [![profile avatar](https://static-cdn.jtvnw.net/jtv_user_pictures/d859523e-7884-43d4-838d-3d6ec2ece485-profile_image-50x50.png)\\
\\
nevcairiel\\
\\
![GrandArtisan tier icon](https://www.curseforge.com/images/legends/grand-artisan-icon.svg)\\
\\
Author](https://www.curseforge.com/members/nevcairiel)

## More from Kaelten [View all](https://www.curseforge.com/members/Kaelten)

- ![Ace3 project image](https://media.forgecdn.net/avatars/thumbnails/64/118/256/256/636150154000533476.png)

[Go to Ace3 Project Page](https://www.curseforge.com/wow/addons/ace3 "Go to Ace3 Project Page")



### [Ace3](https://www.curseforge.com/wow/addons/ace3 "Go to Ace3 Project Page")





ByKaelten





  - 10.1M
  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

AddOn development framework

  - 10.1M
  - February 3, 2026

  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

[View](https://www.curseforge.com/wow/addons/ace3 "Go to Ace3 Project Page")

[Install](https://www.curseforge.com/wow/addons/ace3/install/7571919)

- ![OneCore-1.0 project image](https://www.curseforge.com/images/flame.svg)

[Go to OneCore-1.0 Project Page](https://www.curseforge.com/wow/addons/onecore "Go to OneCore-1.0 Project Page")



### [OneCore-1.0](https://www.curseforge.com/wow/addons/onecore "Go to OneCore-1.0 Project Page")





ByKaelten





  - 117.2K
  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

OneCore is the centralized code shared between the OneBag Suite

  - 117.2K
  - November 15, 2022

  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)
  - +1

[View](https://www.curseforge.com/wow/addons/onecore "Go to OneCore-1.0 Project Page")

[Install](https://www.curseforge.com/wow/addons/onecore/install/4087811)

- ![OneBag3 project image](https://media.forgecdn.net/avatars/thumbnails/63/25/256/256/636142226325326023.png)

[Go to OneBag3 Project Page](https://www.curseforge.com/wow/addons/onebag3 "Go to OneBag3 Project Page")



### [OneBag3](https://www.curseforge.com/wow/addons/onebag3 "Go to OneBag3 Project Page")





ByKaelten





  - 2.9M
  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

OneBag is a replacement for the default game bags that combines all the bags into one frame.

  - 2.9M
  - May 19, 2021

  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

[View](https://www.curseforge.com/wow/addons/onebag3 "Go to OneBag3 Project Page")

[Install](https://www.curseforge.com/wow/addons/onebag3/install/3315500)

- ![OneBank3 project image](https://media.forgecdn.net/avatars/thumbnails/63/329/256/256/636142289132630642.png)

[Go to OneBank3 Project Page](https://www.curseforge.com/wow/addons/onebank3 "Go to OneBank3 Project Page")



### [OneBank3](https://www.curseforge.com/wow/addons/onebank3 "Go to OneBank3 Project Page")





ByKaelten





  - 825.8K
  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

OneBank3 will combine all the bank bags into one frame.

  - 825.8K
  - May 19, 2021

  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

[View](https://www.curseforge.com/wow/addons/onebank3 "Go to OneBank3 Project Page")

[Install](https://www.curseforge.com/wow/addons/onebank3/install/3315792)

- ![Ace3 project image](https://media.forgecdn.net/avatars/thumbnails/64/118/256/256/636150154000533476.png)

[Go to Ace3 Project Page](https://www.curseforge.com/wow/addons/ace3 "Go to Ace3 Project Page")



### [Ace3](https://www.curseforge.com/wow/addons/ace3 "Go to Ace3 Project Page")





ByKaelten





  - 10.1M
  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

AddOn development framework

  - 10.1M
  - February 3, 2026

  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

[View](https://www.curseforge.com/wow/addons/ace3 "Go to Ace3 Project Page")

[Install](https://www.curseforge.com/wow/addons/ace3/install/7571919)

- ![OneCore-1.0 project image](https://www.curseforge.com/images/flame.svg)

[Go to OneCore-1.0 Project Page](https://www.curseforge.com/wow/addons/onecore "Go to OneCore-1.0 Project Page")



### [OneCore-1.0](https://www.curseforge.com/wow/addons/onecore "Go to OneCore-1.0 Project Page")





ByKaelten





  - 117.2K
  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

OneCore is the centralized code shared between the OneBag Suite

  - 117.2K
  - November 15, 2022

  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)
  - +1

[View](https://www.curseforge.com/wow/addons/onecore "Go to OneCore-1.0 Project Page")

[Install](https://www.curseforge.com/wow/addons/onecore/install/4087811)

- ![OneBag3 project image](https://media.forgecdn.net/avatars/thumbnails/63/25/256/256/636142226325326023.png)

[Go to OneBag3 Project Page](https://www.curseforge.com/wow/addons/onebag3 "Go to OneBag3 Project Page")



### [OneBag3](https://www.curseforge.com/wow/addons/onebag3 "Go to OneBag3 Project Page")





ByKaelten





  - 2.9M
  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

OneBag is a replacement for the default game bags that combines all the bags into one frame.

  - 2.9M
  - May 19, 2021

  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

[View](https://www.curseforge.com/wow/addons/onebag3 "Go to OneBag3 Project Page")

[Install](https://www.curseforge.com/wow/addons/onebag3/install/3315500)

- ![OneBank3 project image](https://media.forgecdn.net/avatars/thumbnails/63/329/256/256/636142289132630642.png)

[Go to OneBank3 Project Page](https://www.curseforge.com/wow/addons/onebank3 "Go to OneBank3 Project Page")



### [OneBank3](https://www.curseforge.com/wow/addons/onebank3 "Go to OneBank3 Project Page")





ByKaelten





  - 825.8K
  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

OneBank3 will combine all the bank bags into one frame.

  - 825.8K
  - May 19, 2021

  - [Addons](https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=relevancy)

[View](https://www.curseforge.com/wow/addons/onebank3 "Go to OneBank3 Project Page")

[Install](https://www.curseforge.com/wow/addons/onebank3/install/3315792)