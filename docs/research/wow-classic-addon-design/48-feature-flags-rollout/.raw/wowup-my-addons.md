# Source: https://wowup.io/guide/my-addons/addons

WowUp logo

* Home
* Guide
* Addons

Search

* WowUp
  
    + Overview
    + Keyboard Shortcuts
    + WowUp Addon
    + WowUp Hub
* My Addons
  
    + Overview
    + Addons
    + Import/Export
    + Settings
* Get Addons
  
+ Overview
* Options
  
    + WoW Clients
    + Application
    + Addons
    + Debug

# Addons in Depth

Obviously this is why you're here, to manage your World of Warcraft addons. There are lots of things you can do
with your addons like change what release channel you want, ignore or auto update them and much more.

## Addon Details

You can show extra details for an addon by clicking it's name or by double clicking the row itself. From here you
can see the full addon description and a link to the provider's website.

You can also see the most current changelogs for your selected addon. This is available for _most_ addon
providers.

Some providers also allow us to show an image gallery so you can have a better idea of what you're getting.

## Auto Update

Addons with this symbol will be updated every hour automatically for you if an update is available.

You can enable auto update by right clicking the addon and selecting the Auto Update checkbox.

Currently WowUp will automatically check for new updates once every hour.

## Channels

If you want to try addon updates faster than they are available and stable you can change the addon channel to
Alpha or Beta.

This can be done by right clicking the addon and selecting Channel > and checking one of the
Stable/Alpha/Beta checkboxes.

When you set a desired channel it means that you will accept that level of build (Alpha/Beta/Stable) not that you **only** want that channel. So if you set your channel to Alpha, you may still get a stable version installed.
WowUp will install the latest build of an addon regardless of selected channel.

The reason that this is not a strict channel setting is that authors will likely only create new alphas when a new
patch is coming out and then stop once it's released. This would leave you stranded on a potentially old version
which is not desirable.

##### Note

This feature only works for providers that offer pre-release versions. This includes WowUpHub and Curseforge.

## Multiple Providers

Often referred to as "hot swapping" addons with this symbol have the ability to switch between available
providers.

You can switch between providers of this addon by right clicking on the row and selecting Providers.

This operation is essentially the same as un-installing the existing addon and then re-installing it from the
other addon provider. This is just a simpler way to accomplish that.

##### Note

In order for this to work the addon author must put some information in the toc file of their addon so that we
can identify what id maps to each provider they choose.

* X-Curse-Project-ID
* X-Tukui-ProjectID
* X-WoWI-ID

## Ignore

You can ignore certain addons that you do not want to worry about updating, such as very old addons or those
maintained in a custom way.

You can ignore an addon by right clicking on it and selecting the Ignore checkbox.

## Re-Install

You can have WowUp re-install the same version if you need by right clicking the addon and selecting Re-Install.

## Remove

WowUp can remove move the addon and all associated folders from your system if you right click and select Remove.

## Warning States

There are various things that can happen causing the addon to be "lost". Typically we see this when a provider
(CurseForge, TukUI, etc) removes or blocks an addon.

When this state occurs we will notify you that something went wrong but not set it to ignored since the provider
may fix it on their own.

[GitHub logo](https://github.com/jliddev/WowUp)

[Patreon logo](https://www.patreon.com/jliddev)

[Discord logo](https://discord.gg/rk4F5aD)

Privacy Policy

Terms of Service
