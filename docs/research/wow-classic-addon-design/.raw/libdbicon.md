[CurseForge](https://www.wowace.com/) [Register](https://www.wowace.com/register?returnUrl=%2fprojects%2flibdbicon-1-0) [Sign In](https://www.wowace.com/login?returnUrl=%2fprojects%2flibdbicon-1-0)

# [LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0)

## [Addons](https://www.wowace.com/addons)

### LibDBIcon-1.0

- [Table of Contents](https://www.wowace.com/projects/libdbicon-1-0#)

[X](https://www.wowace.com/projects/libdbicon-1-0 "Close Table of Contents")

## Table of Contents

[![Patreon](https://media.forgecdn.net/attachments/190/63/patreon.png)](https://github.com/sponsors/funkydude) Please support my work on [Patreon/GitHub](https://github.com/sponsors/funkydude)

LibDBIcon-1.0 is a small library you can throw in your addon that will create a minimap icon.

Simply get a reference to the library in your addon like so:

`local icon = LibStub("LibDBIcon-1.0")`

This library REQUIRES you use a separate library called LibDataBroker (LDB).
After you've registered your LDB object called "MyLDB", you can do:

`icon:Register("MyLDB", myLDB, savedVarTable)`

Where myLDB is a object reference to your LDB display and savedVarTable is a table where the library can store data like minimap position, radius, etc.

When you create the display, the library will automatically hide or show the icon based on the "hide = true/false" key in savedVarTable. If you want to add an option to hide or show the display, you can hide or show the icon manually during play with:

`icon:Hide("MyLDB")`

`icon:Show("MyLDB")`

So in conclusion, here is a complete example (using Ace3) of how to use this library:

```
local addon = LibStub("AceAddon-3.0"):NewAddon("Bunnies")
local bunnyLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Bunnies", {
	type = "data source",
	text = "Bunnies!",
	icon = "Interface\\Icons\\INV_Chest_Cloth_17",
	OnClick = function() print("BUNNIES ARE TAKING OVER THE WORLD") end,
})
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
	-- Assuming you have a ## SavedVariables: BunniesDB line in your TOC
	self.db = LibStub("AceDB-3.0"):New("BunniesDB", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})
	icon:Register("Bunnies", bunnyLDB, self.db.profile.minimap)
end
```

### About This Project

- Project ID

15552

- Created

Oct 17, 2008

- Last Released File

Jul 16, 2026

- Total Downloads

1,444,872

- License

[Ace3 Style BSD](https://www.wowace.com/project/15552/license)


- [View on CurseForge](https://legacy.curseforge.com/wow/addons/libdbicon-1-0)
- [Report Project](https://www.wowace.com/projects/libdbicon-1-0# "You must be logged in to report a Project.")

### Categories

- [![](https://media.forgecdn.net/avatars/thumbnails/54/446/32/32/636135209667351870.png)](https://www.wowace.com/addons/libraries "Libraries")

### Members

- [![View Funkeh's Profile](https://static-cdn.jtvnw.net/user-default-pictures-uv/75305d54-c7cc-40d1-bb9c-91fbe85943c7-profile_image-50x50.png)](https://www.wowace.com/members/funkeh)





[Funkeh](https://www.wowace.com/members/funkeh) Owner

- [![View nebula169's Profile](https://static-cdn.jtvnw.net/jtv_user_pictures/nebula169-profile_image-8e3d2fa86af441c7-50x50.jpeg)](https://www.wowace.com/members/nebula169)





[nebula169](https://www.wowace.com/members/nebula169) Maintainer


### Recent Files

#### [WoW Retail](https://www.wowace.com/projects/libdbicon-1-0/files?filter-game-version=1738749986%3a517)

- [Download File](https://www.wowace.com/projects/libdbicon-1-0/files/8448436/download "Download File")



[v12.0.3](https://www.wowace.com/projects/libdbicon-1-0/files/8448436)

Jul 16, 2026

- [Download File](https://www.wowace.com/projects/libdbicon-1-0/files/8448433/download "Download File")



[r161-alpha](https://www.wowace.com/projects/libdbicon-1-0/files/8448433)

Jul 16, 2026


#### [WoW Mists of Pandaria Classic](https://www.wowace.com/projects/libdbicon-1-0/files?filter-game-version=1738749986%3a79434)

- [Download File](https://www.wowace.com/projects/libdbicon-1-0/files/8448436/download "Download File")



[v12.0.3](https://www.wowace.com/projects/libdbicon-1-0/files/8448436)

Jul 16, 2026

- [Download File](https://www.wowace.com/projects/libdbicon-1-0/files/8448433/download "Download File")



[r161-alpha](https://www.wowace.com/projects/libdbicon-1-0/files/8448433)

Jul 16, 2026


#### [WoW Wrath Titan Reforged](https://www.wowace.com/projects/libdbicon-1-0/files?filter-game-version=1738749986%3a81212)

- [Download File](https://www.wowace.com/projects/libdbicon-1-0/files/8448436/download "Download File")



[v12.0.3](https://www.wowace.com/projects/libdbicon-1-0/files/8448436)

Jul 16, 2026

- [Download File](https://www.wowace.com/projects/libdbicon-1-0/files/8448433/download "Download File")



[r161-alpha](https://www.wowace.com/projects/libdbicon-1-0/files/8448433)

Jul 16, 2026