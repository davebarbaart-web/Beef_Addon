Wowpedia

We have moved to Warcraft Wiki. [Click here](https://wowpedia.fandom.com/wiki/Forum:Vote_to_Leave_Fandom "Forum:Vote to Leave Fandom") for information and the new URL.

READ MORE

[Fandom homepage](https://www.fandom.com/)

[Wowpedia](https://wowpedia.fandom.com/wiki/Wowpedia)

[Switch to Light Theme](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions# "Switch to Light Theme")

[Sign In](https://auth.fandom.com/signin?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions&metadata=header-signin-button)

Don't have an account?

[Create a Free Account](https://auth.fandom.com/register?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions&metadata=header-registration-button)

* * *

[Sign In](https://auth.fandom.com/signin?source=mw&redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions&metadata=header-signin-button)

Advertisement


[Skip to content](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#page-header)

## Contents

- [1BigWigs packager](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#BigWigs_packager)
- [2Getting started](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Getting_started)
- [3PackageMeta file](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#PackageMeta_file)
  - [3.1Local and external embeds](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Local_and_external_embeds)
- [4TOC file](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#TOC_file)
- [5GitHub workflow](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#GitHub_workflow)
  - [5.1Environment variables](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Environment_variables)
- [6Creating a release](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Creating_a_release)
- [7Multiple client flavors](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Multiple_client_flavors)
- [8Troubleshooting](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Troubleshooting)
  - [8.1Why am I getting "resource not accessible by integration" errors in my workflow?](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Why_am_I_getting_%22resource_not_accessible_by_integration%22_errors_in_my_workflow?)
- [9See also](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#See_also)
- [10References](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#References)

[Edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Fveaction%3Dedit&uselang=en&metadata=article-registration-edit-article)[Sign In to Save](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Fcollections%3Dsave&uselang=en&metadata=collections-save-button)

in: [HOWTOs](https://wowpedia.fandom.com/wiki/Category:HOWTOs "Category:HOWTOs")

# Using the BigWigs Packager with GitHub Actions

[Sign In to SaveSave](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Fcollections%3Dsave&uselang=en&metadata=collections-save-button "Sign In to Save") [Edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Fveaction%3Dedit&uselang=en&metadata=article-registration-edit-article)

- [History](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions?action=history)
- [Purge](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions?action=purge)
- [Talk (0)](https://wowpedia.fandom.com/wiki/Talk:Using_the_BigWigs_Packager_with_GitHub_Actions?action=edit&redlink=1)

| [Main Menu](https://wowpedia.fandom.com/wiki/Wowpedia:Interface_customization "Wowpedia:Interface customization") |
| --- |
| - [WoW API](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API "World of Warcraft API")<br>- [Lua API](https://wowpedia.fandom.com/wiki/Lua_functions "Lua functions")<br>- [FrameXML util](https://wowpedia.fandom.com/wiki/FrameXML_functions "FrameXML functions")<br>* * *<br>- [Widget API](https://wowpedia.fandom.com/wiki/Widget_API "Widget API")<br>- [Widget scripts](https://wowpedia.fandom.com/wiki/Widget_script_handlers "Widget script handlers")<br>- [XML schema](https://wowpedia.fandom.com/wiki/XML_schema "XML schema")<br>- [Events](https://wowpedia.fandom.com/wiki/Events "Events")<br>- [CVars](https://wowpedia.fandom.com/wiki/Console_variables "Console variables")<br>* * *<br>- [Macro commands](https://wowpedia.fandom.com/wiki/Macro_commands "Macro commands")<br>- [Combat Log](https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT "COMBAT LOG EVENT")<br>- [Escape sequences](https://wowpedia.fandom.com/wiki/UI_escape_sequences "UI escape sequences")<br>- [Hyperlinks](https://wowpedia.fandom.com/wiki/Hyperlinks "Hyperlinks")<br>- [API changes](https://wowpedia.fandom.com/wiki/API_change_summaries "API change summaries")<br>- [HOWTOs](https://wowpedia.fandom.com/wiki/HOWTOs "HOWTOs")<br>- [![Discord logo](https://static.wikia.nocookie.net/wowpedia/images/d/d0/Discord_logo.png/revision/latest/scale-to-width-down/12?cb=20220301221829)](https://discord.gg/txUg39Vhc6)[wowuidev](https://discord.gg/txUg39Vhc6) |

If you maintain multiple addons on [CurseForge](https://www.curseforge.com/wow/addons), [WowInterface](https://www.wowinterface.com/addons.php) and [Wago](https://addons.wago.io/) while also embedding any libraries it can be bothersome just to update them.

## Contents

- [1BigWigs packager](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#BigWigs_packager)
- [2Getting started](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Getting_started)
- [3PackageMeta file](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#PackageMeta_file)
  - [3.1Local and external embeds](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Local_and_external_embeds)
- [4TOC file](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#TOC_file)
- [5GitHub workflow](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#GitHub_workflow)
  - [5.1Environment variables](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Environment_variables)
- [6Creating a release](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Creating_a_release)
- [7Multiple client flavors](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Multiple_client_flavors)
- [8Troubleshooting](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Troubleshooting)
  - [8.1Why am I getting "resource not accessible by integration" errors in my workflow?](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#Why_am_I_getting_%22resource_not_accessible_by_integration%22_errors_in_my_workflow?)
- [9See also](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#See_also)
- [10References](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#References)

## BigWigs packager\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D1&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

The [BigWigs packager](https://github.com/BigWigsMods/packager) has a couple of advantages over the [CurseForge packager](https://support.curseforge.com/en/support/solutions/articles/9000197281-automatic-packaging) and supports:

- Uploading to CurseForge, WowInterface, Wago, and GitHub (as a [release](https://docs.github.com/en/free-pro-team@latest/github/administering-a-repository/releasing-projects-on-github)).
- Packaging for [multiple](https://github.com/BigWigsMods/packager#building-for-multiple-game-versions) game versions.
- Using [GitHub Actions](https://github.com/features/actions) to automate your workflow.

The documentation is available on the project page:

- [Preparing the PackageMeta File](https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File)
- [Repository Keyword Substitutions](https://github.com/BigWigsMods/packager/wiki/Repository-Keyword-Substitutions)
- [Localization Substitution](https://github.com/BigWigsMods/packager/wiki/Localization-Substitution)
- [GitHub Actions workflow](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow)

## Getting started\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D2&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

For this tutorial you will need:

- To be familiar with [Git](https://git-scm.com/), guides like [try.github.io](https://try.github.io/) and [git - the simple guide](https://rogerdudler.github.io/git-guide/) will help you on your way.
- To install the [Git client](https://git-scm.com/downloads) or one of the available GUI clients. VS Code has [integrated Git support](https://code.visualstudio.com/docs/editor/versioncontrol).
- A [GitHub](https://github.com/) repository.

The basic idea is: create a local Git repository -> make some changes -> stage your changes -> commit them locally -> push the commits to a remote repository.

[![API Git Diagram](https://static.wikia.nocookie.net/wowpedia/images/2/2f/API_Git_Diagram.png/revision/latest/scale-to-width-down/690?cb=20201226030218)](https://static.wikia.nocookie.net/wowpedia/images/2/2f/API_Git_Diagram.png/revision/latest?cb=20201226030218)

## PackageMeta file\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D3&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

The [PackageMeta file](https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File) configures the packager. It's mostly used for embedding any external libraries, for example the [Ace3 framework](https://www.wowace.com/projects/ace3):

**.pkgmeta**

```
package-as: MyAddOn

externals:
  Libs/LibStub: https://repos.wowace.com/wow/libstub/trunk
  Libs/CallbackHandler-1.0: https://repos.wowace.com/wow/callbackhandler/trunk/CallbackHandler-1.0
  Libs/AceAddon-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceAddon-3.0
  Libs/AceComm-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceComm-3.0
  Libs/AceConfig-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceConfig-3.0
  Libs/AceConsole-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceConsole-3.0
  Libs/AceDB-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceDB-3.0
  Libs/AceDBOptions-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceDBOptions-3.0
  Libs/AceEvent-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceEvent-3.0
  Libs/AceGUI-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceGUI-3.0
  Libs/AceHook-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceHook-3.0
  Libs/AceLocale-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceLocale-3.0
  Libs/AceSerializer-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceSerializer-3.0
  Libs/AceTimer-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceTimer-3.0
```

### Local and external embeds\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D4&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

Listing external embeds is convenient for packaging the latest version of a library instead of hardcoding it.

When the libaries are packaged externally, you naturally would still want to have your own local Ace3 libs in your working copy without checking them out to the repository:

- Use e.g. Ace3 standalone by dropping the [Ace3](https://www.wowace.com/projects/ace3) in the `AddOns` folder and specifying `## OptionalDeps: Ace3` in your TOC. A library can be used standalone if it has a TOC file.
- Or put the Ace3 libs in the `Libs` folder and exclude it from the repository with [.gitignore](https://git-scm.com/docs/gitignore)

## TOC file\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D5&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

The project IDs should be listed in the [TOC](https://wowpedia.fandom.com/wiki/TOC_format "TOC format") file (or alternatively as `-p curse-id`, `-w wowi-id`, and `-a wago-id` arguments in the workflow).

- The Curse ID is listed on the project page, e.g. 399282 on [https://www.curseforge.com/wow/addons/hidetutorial](https://www.curseforge.com/wow/addons/hidetutorial)
- The WoWInterface ID is in the URL, e.g. 25635 in [https://www.wowinterface.com/downloads/info25635-HideTutorial.html](https://www.wowinterface.com/downloads/info25635-HideTutorial.html)
- The Wago project ID is listed on the [developer dashboard](https://addons.wago.io/developers).

The `@project-version@` [substitution keyword](https://github.com/BigWigsMods/packager/wiki/Repository-Keyword-Substitutions) is the tag name if on a tag, otherwise the short revision.

**MyAddOn.toc**

```
## Interface: 120005
## Version: @project-version@
## Title: MyAddOn
## Notes: Does something neat
## Author: Your Name
## X-Curse-Project-ID: 123456
## X-WoWI-ID: 12345
## X-Wago-ID: abcdef12

MyAddOn.lua
```

## GitHub workflow\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D6&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

A [workflow](https://docs.github.com/en/free-pro-team@latest/actions/reference#workflow-syntax) is a configurable automated process made up of one or more jobs. You can reference the detailed [GitHub Actions workflow](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow) example on the BigWigs wiki or use the below one.

**.github/workflows/release.yml**

```
name: Release AddOn # description of this workflow, can be anything you want

# triggers when pushing a tag
on:
  push:
    tags:
      - '**'

env:
  CF_API_KEY: ${{ secrets.CF_API_KEY }}
  WOWI_API_TOKEN: ${{ secrets.WOWI_API_TOKEN }}
  WAGO_API_TOKEN: ${{ secrets.WAGO_API_TOKEN }}
  # for github releases, this secret is automatically provided to the workflow
  # this must be explicitly configured with read-write permissions on the repository
  GITHUB_OAUTH: ${{ secrets.GITHUB_TOKEN }}

jobs:
  release: # "release" is a job, you can name it anything you want
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0 # reads history for commit changelog

      - uses: BigWigsMods/packager@v2
```

### Environment variables\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D7&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

The workflow accesses encrypted environment variables a.k.a. [secrets](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets), they can be created via `Settings -> Secrets -> New repository secret`

Generate the API tokens and assign them to your secrets:

- `CF_API_KEY` [https://wow.curseforge.com/account/api-tokens](https://wow.curseforge.com/account/api-tokens)
- `WOWI_API_TOKEN` [https://www.wowinterface.com/downloads/filecpl.php?action=apitokens](https://www.wowinterface.com/downloads/filecpl.php?action=apitokens)
- `WAGO_API_TOKEN` [https://addons.wago.io/account/apikeys](https://addons.wago.io/account/apikeys)

![Tutorial BigWigs 1](https://static.wikia.nocookie.net/wowpedia/images/a/a4/Tutorial_BigWigs_1.png/revision/latest/scale-to-width-down/940?cb=20201226044117)

## Creating a release\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D8&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

Make sure your workflow and TOC file with project IDs are committed and pushed. (Note that if you push an initial workflow at the same time with a tag, then the workflow will not trigger yet. Try pushing another tag.)

Now when pushing a new tag GitHub should automatically package a .zip file and upload to CurseForge, WoWInterface and GitHub releases!

![Tutorial BigWigs 2](https://static.wikia.nocookie.net/wowpedia/images/c/c3/Tutorial_BigWigs_2.png/revision/latest?cb=20201226054903)

## Multiple client flavors\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D9&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

_Reference: [Building for multiple game versions](https://github.com/BigWigsMods/packager#building-for-multiple-game-versions), [GitHub Actions workflow](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow)_

- Addons can check the current game flavor with the [WOW\_PROJECT\_ID](https://wowpedia.fandom.com/wiki/WOW_PROJECT_ID "WOW PROJECT ID") constant.
- The packager can automatically generate [multiple TOC](https://wowpedia.fandom.com/wiki/TOC_format#Multiple_client_flavors "TOC format") files, for example this will create one zip file with three different TOCs: `AddonName.toc`, `AddonName_Wrath.toc`, `AddonName_Vanilla.toc`

**AddonName.toc**

```
## Interface: 120005
## Interface-Wrath: 30405
## Interface-Classic: 11508
```

```
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - uses: BigWigsMods/packager@v2
        # automatically generates game type specific TOC files
        with:
          args: -S
```

## Troubleshooting\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D10&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

### Why am I getting "resource not accessible by integration" errors in my workflow?\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D11&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

As of February 2023 the default permissions granted to the automatically generated `GITHUB_TOKEN` for new repositories were changed to only allow read-only access[\[1\]](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#cite_note-1). You will need to [modify the permissions of the token](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#setting-the-permissions-of-the-github_token-for-your-repository) and grant it write access to allow the packager to publish releases to your repository.

## See also\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D12&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

- Kemayo: [World of Warcraft addon packaging but with GitHub Actions this time](https://davidlynch.org/blog/2020/09/world-of-warcraft-addon-packaging-but-with-github-actions-this-time/)
- WowInterface: [Guide: Automagically package and publish addons](https://www.wowinterface.com/forums/showthread.php?t=55801) (TravisCI)
- Example reference addon: [https://github.com/ketho-wow/HideTutorial](https://github.com/ketho-wow/HideTutorial)
- [Symlinking AddOn folders](https://wowpedia.fandom.com/wiki/Symlinking_AddOn_folders "Symlinking AddOn folders")

| | Collapse<br>Authoring |
| --- |
|  |
| | Global API | - [GetBuildInfo](https://wowpedia.fandom.com/wiki/API_GetBuildInfo "API GetBuildInfo")<br>- [GetExpansionLevel](https://wowpedia.fandom.com/wiki/API_GetExpansionLevel "API GetExpansionLevel")<br>- [GetAddOnMetadata](https://wowpedia.fandom.com/wiki/API_C_AddOns.GetAddOnMetadata "API C AddOns.GetAddOnMetadata") | |
|  |
| | Docs | - [WOW\_PROJECT\_ID](https://wowpedia.fandom.com/wiki/WOW_PROJECT_ID "WOW PROJECT ID")<br>- [TOC format](https://wowpedia.fandom.com/wiki/TOC_format "TOC format") | |
|  |
| | Tutorials | - **Using the BigWigs Packager with GitHub Actions** | | |

## References\[ [Sign in to edit](https://auth.fandom.com/signin?redirect=https%3A%2F%2Fwowpedia.fandom.com%2Fwiki%2FUsing_the_BigWigs_Packager_with_GitHub_Actions%3Faction%3Dedit%26section%3D13&uselang=en&metadata=article-registration-edit-article-section "Sign in to edit")\]

1. [^](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions#cite_ref-1) [https://github.blog/changelog/2023-02-02-github-actions-updating-the-default-github\_token-permissions-to-read-only/](https://github.blog/changelog/2023-02-02-github-actions-updating-the-default-github_token-permissions-to-read-only/)

Categories

Community content is available under [CC BY-SA 3.0](https://www.fandom.com/licensing) unless otherwise noted.

- [Fantasy](https://www.fandom.com/fancentral/fantasy)
- [World of Warcraft](https://www.fandom.com/universe/world-of-warcraft)

Advertisement


silver-surfer-storage-html

RL Storage

![](https://ad-delivery.net/px.gif?ch=2)![](https://ad.doubleclick.net/favicon.ico?ad=300x250&ad_box_=1&adnet=1&showad=1&size=250x250)![](https://ad-delivery.net/px.gif?ch=1&e=0.31673778746986747)

Wowpedia


We have moved to Warcraft Wiki. [Click here](https://wowpedia.fandom.com/wiki/Forum:Vote_to_Leave_Fandom "Forum:Vote to Leave Fandom") for information and the new URL.

CLOSE


[Search this wiki](https://wowpedia.fandom.com/wiki/Special:Search?scope=internal&query=&h=1&isFromHighlightActions=on)

[Search all wikis](https://wowpedia.fandom.com/wiki/Special:Search?scope=cross-wiki&query=&h=1&isFromHighlightActions=on)