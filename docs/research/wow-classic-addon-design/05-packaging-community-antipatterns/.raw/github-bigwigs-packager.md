[Skip to content](https://github.com/BigWigsMods/packager#start-of-content)

You signed in with another tab or window. [Reload](https://github.com/BigWigsMods/packager) to refresh your session.You signed out in another tab or window. [Reload](https://github.com/BigWigsMods/packager) to refresh your session.You switched accounts on another tab or window. [Reload](https://github.com/BigWigsMods/packager) to refresh your session.Dismiss alert

{{ message }}

### Uh oh!

There was an error while loading. [Please reload this page](https://github.com/BigWigsMods/packager).

[BigWigsMods](https://github.com/BigWigsMods)/ **[packager](https://github.com/BigWigsMods/packager)** Public

- [Notifications](https://github.com/login?return_to=%2FBigWigsMods%2Fpackager) You must be signed in to change notification settings
- [Fork\\
62](https://github.com/login?return_to=%2FBigWigsMods%2Fpackager)
- [Star\\
182](https://github.com/login?return_to=%2FBigWigsMods%2Fpackager)


Use this GitHub action with your project

Add this Action to an existing workflow or create a new one

[View on Marketplace](https://github.com/marketplace/actions/wow-packager)

master

[**4** Branches](https://github.com/BigWigsMods/packager/branches) [**31** Tags](https://github.com/BigWigsMods/packager/tags)

[Go to Branches page](https://github.com/BigWigsMods/packager/branches)[Go to Tags page](https://github.com/BigWigsMods/packager/tags)

Go to file

Code

Open more actions menu

## Folders and files

| Name | Name | Last commit message | Last commit date |
| --- | --- | --- | --- |
| ## Latest commit<br>[![nebularg](https://avatars.githubusercontent.com/u/1010803?v=4&size=40)](https://github.com/nebularg)[nebularg](https://github.com/BigWigsMods/packager/commits?author=nebularg)<br>[Normalize api token env vars](https://github.com/BigWigsMods/packager/commit/36b4c3b7b7bd17c835ad8c83fed4976c067edfbe)<br>last monthJun 17, 2026<br>[36b4c3b](https://github.com/BigWigsMods/packager/commit/36b4c3b7b7bd17c835ad8c83fed4976c067edfbe) · last monthJun 17, 2026<br>## History<br>[706 Commits](https://github.com/BigWigsMods/packager/commits/master/) <br>Open commit details<br>[View commit history for this file.](https://github.com/BigWigsMods/packager/commits/master/) 706 Commits |
| [.gitattributes](https://github.com/BigWigsMods/packager/blob/master/.gitattributes ".gitattributes") | [.gitattributes](https://github.com/BigWigsMods/packager/blob/master/.gitattributes ".gitattributes") | [Split pandoc install into another script](https://github.com/BigWigsMods/packager/commit/edbd9c083265eaee7dcd40d7d9b509bc1c6f7b4d "Split pandoc install into another script") | 2 years agoDec 18, 2024 |
| [.gitignore](https://github.com/BigWigsMods/packager/blob/master/.gitignore ".gitignore") | [.gitignore](https://github.com/BigWigsMods/packager/blob/master/.gitignore ".gitignore") | [Add .gitignore](https://github.com/BigWigsMods/packager/commit/44618b6f547fa14b597cf191ab50995856f52d96 "Add .gitignore") | 7 years agoAug 12, 2019 |
| [README.md](https://github.com/BigWigsMods/packager/blob/master/README.md "README.md") | [README.md](https://github.com/BigWigsMods/packager/blob/master/README.md "README.md") | [Normalize api token env vars](https://github.com/BigWigsMods/packager/commit/36b4c3b7b7bd17c835ad8c83fed4976c067edfbe "Normalize api token env vars") | last monthJun 17, 2026 |
| [action.yml](https://github.com/BigWigsMods/packager/blob/master/action.yml "action.yml") | [action.yml](https://github.com/BigWigsMods/packager/blob/master/action.yml "action.yml") | [Add installing svn if needed](https://github.com/BigWigsMods/packager/commit/6b07139b9679523ba8128998eca5e107283e343b "Add installing svn if needed") | 2 years agoDec 18, 2024 |
| [release.sh](https://github.com/BigWigsMods/packager/blob/master/release.sh "release.sh") | [release.sh](https://github.com/BigWigsMods/packager/blob/master/release.sh "release.sh") | [Normalize api token env vars](https://github.com/BigWigsMods/packager/commit/36b4c3b7b7bd17c835ad8c83fed4976c067edfbe "Normalize api token env vars") | last monthJun 17, 2026 |
| [setup-packager.sh](https://github.com/BigWigsMods/packager/blob/master/setup-packager.sh "setup-packager.sh") | [setup-packager.sh](https://github.com/BigWigsMods/packager/blob/master/setup-packager.sh "setup-packager.sh") | [Action: Fix svn install check when passing multiple args](https://github.com/BigWigsMods/packager/commit/dbfa9d7d18932711fa50293340ccffccbf88d952 "Action: Fix svn install check when passing multiple args  Fixes #180") | last yearJan 16, 2025 |
| View all files |

## Repository files navigation

# release.sh

[Permalink: release.sh](https://github.com/BigWigsMods/packager#releasesh)

**release.sh** generates an addon zip file from a Git, SVN, or Mercurial
checkout.

**release.sh** works by creating a new project directory (`.release` by
default), copying files from the checkout into the project directory, checking
out external repositories then copying their files into the project directory,
then moves subdirectories into the project root. The project directory is then
zipped to create a distributable addon zip file which can also be uploaded to
CurseForge, WoWInterface, Wago, and GitHub (as a release).

**release.sh** assumes that tags (Git annotated tags and SVN tags) are named for
the version numbers for the project. It will identify if the HEAD is tagged and
use that as the current version number. It will search back through parent
commits for the previous tag and generate a changelog containing the commits
since that tag.

## Building with GitHub Actions

[Permalink: Building with GitHub Actions](https://github.com/BigWigsMods/packager#building-with-github-actions)

For a full example workflow, please check out the [wiki page](https://github.com/BigWigsMods/packager/wiki/GitHub-Actions-workflow).

### Example using [options](https://github.com/BigWigsMods/packager\#usage)

[Permalink: Example using options](https://github.com/BigWigsMods/packager#example-using-options)

```
- uses: BigWigsMods/packager@v2
  with:
    args: -p 1234 -w 5678 -a he54k6bL
```

### What changed with v2.3.0?

[Permalink: What changed with v2.3.0?](https://github.com/BigWigsMods/packager#what-changed-with-v230)

1. The `## Interface:` and `## Interface-[Type]:` values can be a comma
separated list of values.

2. Every interface value in every (non-external) TOC file will be included as a
supported version when uploading to CurseForge, Wago, and WowInterface. This
behavior differs from v2.2.2.

When detecting versions, the `package-as` TOC file is parsed first, then TOC
files in `move-folders` paths. In v2.2.2, the first interface value found
for a game type was used and the rest were ignored. So if you had 100207 in
your main TOC file, but missed updating 100206 in your modules, the final
version would just be `10.2.7`. But now the final version will include _all_
interface versions, meaning it will be `10.2.7,10.2.6`.

You can still use `-g` to override version detection entirely, but it is
still kind of the nuclear option.

3. Fallback TOC files are no longer needed. If you create a TOC file with only
`## Interface-[Type]:` lines and use TOC file creation (splitting), the
original TOC file is not included.

4. The base `## Interface:` doesn't affect splitting, and will just be carried
through to the fallback TOC file.


## Customizing the build

[Permalink: Customizing the build](https://github.com/BigWigsMods/packager#customizing-the-build)

**release.sh** uses the TOC file to determine the package name for the project.
You can also set the CurseForge project id (`-p`), the WoWInterface addon
id (`-w`) or the Wago project id (`-a`) by adding the following to the TOC file:

```
## X-Curse-Project-ID: 1234
## X-WoWI-ID: 5678
## X-Wago-ID: he54k6bL
```

Your CurseForge project id can be found on the addon page in the "About Project"
side box.

Your WoWInterface addon id is in the url for the addon, eg, the "5678"
in [https://wowinterface.com/downloads/info5678-MyAddon](https://wowinterface.com/downloads/info5678-MyAddon).

Your Wago project id can be found on the developer dashboard.

### The PackageMeta file

[Permalink: The PackageMeta file](https://github.com/BigWigsMods/packager#the-packagemeta-file)

**release.sh** can read a **.pkgmeta** file and supports the following
directives. See the [wiki page](https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File)
for more info.

- _externals_ (Git, SVN, and Mercurial) Caveats: An external's .pkgmeta is only
parsed for ignore and externals will not have localization keywords replaced.
- _ignore_
- _plain-copy_
- _license-output_
- _changelog-title_
- _manual-changelog_
- _move-folders_
- _package-as_
- _enable-nolib-creation_ (defaults to no) Caveats: nolib packages will only be
uploaded to GitHub and attached to a release. Unlike with the CurseForge
packager, manually uploaded nolib packages will not be used by the client when
users have enabled downloading libraries separately.
- _enable-toc-creation_ (defaults to no) Create game type specific TOC files
from your TOC file if you have multiple `## Interface-[Type]:` lines.
- _tools-used_
- _required-dependencies_
- _optional-dependencies_
- _embedded-libraries_ Note: All fetched externals will be marked as embedded,
overriding any manually set relations in the pkgmeta.

You can also use a few directives for WoWInterface uploading.

- _wowi-archive-previous_ : `yes|no` (defaults to yes) Archive the previous
release.
- _wowi-create-changelog_ : `yes|no` (defaults to yes) Generate a changelog
using BBCode that will be set when uploading. A manual changelog will always
be used instead if set in the .pkgmeta.
- _wowi-convert-changelog_ : `yes|no` (defaults to yes) Convert a manual
changelog in Markdown format to BBCode if you have [pandoc](http://pandoc.org/)
installed; otherwise, the manual changelog will be used as-is. If set to `no`
when using a generated changelog, Markdown will be used instead of BBCode.
**Note:**: Markdown support is experimental and needs to be requested on a
per-project basis.

### String replacements

[Permalink: String replacements](https://github.com/BigWigsMods/packager#string-replacements)

**release.sh** supports the following repository substitution keywords when
copying the files from the checkout into the project directory. See the
[wiki page](https://github.com/BigWigsMods/packager/wiki/Repository-Keyword-Substitutions)
for more info.

- _@ [localization](https://github.com/BigWigsMods/packager/wiki/Localization-Substitution)(locale="locale", format="format", ...)@_
  - _escape-non-ascii_
  - _handle-unlocalized_
  - _handle-subnamespaces="concat"_
  - _key_
  - _namespace_
  - _same-key-is-true_
  - _table-name_
- _@file-revision@_
- _@project-revision@_
- _@file-hash@_
- _@project-hash@_
- _@file-abbreviated-hash@_
- _@project-abbreviated-hash@_
- _@file-author@_
- _@project-author@_
- _@file-date-iso@_
- _@project-date-iso@_
- _@file-date-integer@_
- _@project-date-integer@_
- _@file-timestamp@_
- _@project-timestamp@_
- _@project-version@_
- _@build-date@_
- _@build-date-iso@_
- _@build-date-integer@_
- _@build-timestamp@_

### Build type keywords

[Permalink: Build type keywords](https://github.com/BigWigsMods/packager#build-type-keywords)

Specific keywords used in a comment at the start (`@keyword@`) and end
(`@end-keyword@`) of a block of code can be used to conditionally run that code
based on the build type. If the build type does not match, the block of code
is comment out so line numbers do not change.

Supported keywords and when the code block will run:

- `alpha`: in untagged builds.
- `debug`: never. Code will only run when using an unpackaged source.
- `do-not-package`: never. Same as `debug` except removed from the packaged
file.
- `no-lib-strip`: _(not supported in Lua files)_ in any build other than a
_nolib_ build.
- `retail`,`version-retail`,`version-classic`,`version-bcc`,`version-wrath`,
`version-cata`, `version-mists`: based on game version.

`do-not-package` is a bit special. Everything between the tags, including the
tags themselves, will always be removed from the packaged file. This will cause
the line numbers of subsequent lines to change, which can result in bug report
line numbers not matching the source code. The typical usage is at the end of
Lua files surrounding debugging functions and other code that end users should
never see or execute.

All keywords except `do-not-package` can be prefixed with `non-` to inverse the
logic. When doing this, the keywords should start and end a **block comment**
as shown below.

More examples are available on the [wiki page](https://github.com/BigWigsMods/packager/wiki/Repository-Keyword-Substitutions#debug-replacements).

#### In Lua files

[Permalink: In Lua files](https://github.com/BigWigsMods/packager#in-lua-files)

`--@keyword@` and `--@end-keyword@`

turn into `--[===[@keyword` and `--@end-keyword]===]`.

`--[===[@non-keyword@` and `--@end-non-keyword@]===]`

turn into `--@non-keyword@` and `--@end-non-keyword@`.

#### In XML files

[Permalink: In XML files](https://github.com/BigWigsMods/packager#in-xml-files)

**Note:** XML doesn't allow nested comments so make sure not to nest keywords.
If you need to nest keywords, you can do so in the TOC instead.

`<!--@keyword@-->` and `<!--@end-keyword@-->`

turn into `<!--@keyword` and `@end-keyword@-->`.

`<!--@non-keyword@` and `@end-non-keyword@-->`

turn into `<!--@non-keyword@-->` and `<!--@end-non-keyword@-->`.

#### In TOC files

[Permalink: In TOC files](https://github.com/BigWigsMods/packager#in-toc-files)

The lines with `#@keyword@` and `#@end-keyword@` get removed, as well as every
line in-between.

The lines with `#@non-keyword@` and `#@end-non-keyword@` get removed, as well as
removing a '# ' (note the space) at the beginning of each line in-between.

### Changing the file name

[Permalink: Changing the file name](https://github.com/BigWigsMods/packager#changing-the-file-name)

**release.sh** uses the file name template `"{package-name}-{project-version}{nolib}{classic}"`
for the addon zip file. This can be changed with the `-n` switch (`release.sh -n "{package-name}-{project-version}"`).

These tokens are always replaced with their value:

- `{package-name}`
- `{project-revision}`
- `{project-hash}`
- `{project-abbreviated-hash}`
- `{project-author}`
- `{project-date-iso}`
- `{project-date-integer}`
- `{project-timestamp}`
- `{project-version}`
- `{game-type}`
- `{release-type}`

These tokens are "flags" and are conditionally shown prefixed with a dash based
on the build type:

- `{alpha}`
- `{beta}`
- `{nolib}`
- `{classic}`

`{classic}` has some additional magic:

1. It will show as the non-retail build type, so `-classic`, `-bcc`, `-wrath`,
`-cata`, or `-mists`.
2. It will not be shown if `-classic`, `-bcc`, `-wrath`, `-cata`, or `-mists`
is in the project version (tag).
3. If it is included in the file name (it is by default) and #2 does not apply,
it will also be appended to the file label (i.e., the name shown in the file
list on CurseForge).

## Building for multiple game versions

[Permalink: Building for multiple game versions](https://github.com/BigWigsMods/packager#building-for-multiple-game-versions)

**release.sh** automatically detects what game version(s) the addon supports.
You only need to run a build once and the file will be tagged with the
appropriate versions when uploaded.

For builds with multiple game types, you won't be able to use [build version keywords](https://github.com/BigWigsMods/packager#build-type-keywords)
(e.g., `@version-retail@` ... `@end-version-retail@`) in Lua files for
controlling what code blocks execute based on the build version, you need to
switch to plain old Lua control statements. Fortunately, there are some
[constants](https://warcraft.wiki.gg/wiki/WOW_PROJECT_ID) set by Blizzard you
can use for this. If you use these keywords in XML files, you will have to
reorganize your includes in the appropriate TOC files.

### Multiple TOC files

[Permalink: Multiple TOC files](https://github.com/BigWigsMods/packager#multiple-toc-files)

You can create [multiple TOC files](https://warcraft.wiki.gg/wiki/TOC_format#Multiple_client_flavors),
one for each supported game type, and **release.sh** will use them to set the
build's game version.

### Single TOC file

[Permalink: Single TOC file](https://github.com/BigWigsMods/packager#single-toc-file)

**release.sh** can support multiple game versions with the use of additional
`## Interface-[Type]` lines in your TOC file.

```
## Interface: 100207
## Interface-Classic: 11502
## Interface-Cata: 40400
```

#### Using TOC file creation (splitting)

[Permalink: Using TOC file creation (splitting)](https://github.com/BigWigsMods/packager#using-toc-file-creation-splitting)

When using multiple `## Interface-[Type]` lines in a single TOC file, you
can use the `-S` command line option or add `enable-toc-creation: yes` to your
`.pkgmeta` file to automatically generate game type specific TOC files using
your existing preprocessing logic. The fallback TOC file will use the base
interface value as it's version.

For each `## Interface-[Type]` line, a new TOC file is created. In the above
example, **release.sh** would create `MyAddon_Vanilla.toc` and
`MyAddon_Cata.toc`, based on `MyAddon.toc` applying each game type's processing
logic and rewriting the interface version and also copy `MyAddon.toc` processed
as retail. You can also not include a fallback TOC file to prevent the addon
from displaying for unsupported versions by not including a base interface
value.

#### Using comma separated interface values

[Permalink: Using comma separated interface values](https://github.com/BigWigsMods/packager#using-comma-separated-interface-values)

The game client for 10.2.7 and 4.4.0 have added the option to specify multiple
interface versions delimited by commas.

```
## Interface: 11502, 100207, 40400, 110000
```

The above example would mark an addon compatible with the latest version of all
client flavors and The War Within alpha.

Other game client versions will stop processing the line when it hits the comma,
So until Classic Era also supports multiple versions, if you include the Classic
Era interface version first, all three game clients will load the addon
correctly.

That said, just because you _can_ include a bunch of interface versions doesn't
mean you _should_ start adding upcoming versions you haven't tested your addon
against.

### Single game version

[Permalink: Single game version](https://github.com/BigWigsMods/packager#single-game-version)

You can specify what version of the game you're targeting with the `-g` switch.
As the game officially supports multiple game versions, manually setting the
version should only be used if you have a specific reason for creating and
uploading multiple packages.

If you specify a single game type (`release.sh -g classic`), the game version
will be set based on the appropriate TOC `## Interface-[Type]` value. You can
also completely override version detection by passing a version number
(`release.sh -g 1.15.2`) or a list of versions (`release.sh -g "3.4.3,1.15.2"`).

## Building locally

[Permalink: Building locally](https://github.com/BigWigsMods/packager#building-locally)

The recommended way to include **release.sh** in a project is to:

1. Create a `.release` subdirectory in the root of your checkout.
2. Ignore the `.release` subdirectory in your `.gitignore`.
3. Copy **release.sh** into the `.release` directory.
4. (Optionally) Create a `.env` file in the `.release` directory filled with
your upload secrets. (KEY=value pairs each on a new line)
5. Run **release.sh**.

## Usage

[Permalink: Usage](https://github.com/BigWigsMods/packager#usage)

```
Usage: release.sh [options]
  -c               Skip copying files into the package directory.
  -d               Skip uploading.
  -e               Skip checkout of external repositories.
  -l               Skip @localization@ keyword replacement.
  -L               Only do @localization@ keyword replacement (skip upload to CurseForge).
  -o               Keep existing package directory, overwriting its contents.
  -s               Create a stripped-down "nolib" package.
  -S               Create a package supporting multiple game types from a single TOC file.
  -u               Use Unix line-endings.
  -z               Skip zip file creation.
  -t topdir        Set top-level directory of checkout.
  -r releasedir    Set directory containing the package directory. Defaults to "$topdir/.release".
  -p curse-id      Set the project id used on CurseForge for localization and uploading. (Use 0 to unset the TOC value)
  -w wowi-id       Set the addon id used on WoWInterface for uploading. (Use 0 to unset the TOC value)
  -a wago-id       Set the project id used on Wago Addons for uploading. (Use 0 to unset the TOC value)
  -g game-version  Set the game version to use for uploading.
  -m pkgmeta.yaml  Set the pkgmeta file to use.
  -n "{template}"  Set the package zip file name and upload label. Use "-n help" for more info.
```

```
Usage: release.sh -n "{template}"
  Set the package zip file name and upload file label. There are several string
  substitutions you can use to include version control and build type information in
  the file name and upload label.

  The default file name is "{package-name}-{project-version}{nolib}{classic}".
  The default upload label is "{project-version}{classic}{nolib}".

  To set both, separate with a ":", i.e, "{file template}:{label template}".
  If either side of the ":" is blank, the default will be used. Not including a ":"
  will set the file name template, leaving upload label as default.

  Tokens: {package-name}{project-revision}{project-hash}{project-abbreviated-hash}
          {project-author}{project-date-iso}{project-date-integer}{project-timestamp}
          {project-version}{game-type}{release-type}

  Flags:  {alpha}{beta}{nolib}{classic}

  Tokens are always replaced with their value. Flags are shown prefixed with a dash
  depending on the build type.
```

### Uploading

[Permalink: Uploading](https://github.com/BigWigsMods/packager#uploading)

**release.sh** uses following environment variables for uploading:

- `CF_API_TOKEN` \- a [CurseForge API token](https://authors.curseforge.com/#/settings/api-tokens),
required for the CurseForge API to fetch localization and upload files.
- `WOWI_API_TOKEN` \- a [WoWInterface API token](https://www.wowinterface.com/downloads/filecpl.php?action=apitokens),
required for uploading to WoWInterface.
- `WAGO_API_TOKEN` \- a [Wago Addons API token](https://addons.wago.io/account/apikeys),
required for uploading to Wago Addons.
- `GITHUB_API_TOKEN` \- a [GitHub personal access token](https://github.com/settings/personal-access-tokens),
required for uploading to GitHub.

**release.sh** will attempt to load environment variables from a `.env` file in
the topdir or current working directory. You can also edit **release.sh** and
enter the tokens near the top of the file.

### Dependencies

[Permalink: Dependencies](https://github.com/BigWigsMods/packager#dependencies)

**release.sh** is mostly POSIX-compatible, so it should run in any Unix-like
environment provided the following are available:

- bash >= 4.3
- awk
- grep
- sed
- curl
- zip
- version control software as needed:
  - git >= 2.13.0
  - subversion >= 1.7.0
  - mercurial >= 3.9.0 (pre-3.9 will have issues with [secure connections](https://www.mercurial-scm.org/wiki/SecureConnections))
- [jq](https://stedolan.github.io/jq/download/) >= 1.5 (when uploading)
- [pandoc](https://pandoc.org/installing.html) >= 1.19.2 (optional)

## About

Generate an addon zip file from a Git, SVN, or Mercurial checkout.

### Topics

[addon](https://github.com/topics/addon) [curseforge](https://github.com/topics/curseforge) [wago](https://github.com/topics/wago) [wow](https://github.com/topics/wow) [wowinterface](https://github.com/topics/wowinterface)

### Resources

[Readme](https://github.com/BigWigsMods/packager#readme-ov-file)

[Activity](https://github.com/BigWigsMods/packager/activity)

[Custom properties](https://github.com/BigWigsMods/packager/custom-properties)

### Stars

[**182** stars](https://github.com/BigWigsMods/packager/stargazers)

### Watchers

[**10** watching](https://github.com/BigWigsMods/packager/watchers)

### Forks

[**62** forks](https://github.com/BigWigsMods/packager/forks)

[Report repository](https://github.com/contact/report-content?content_url=https%3A%2F%2Fgithub.com%2FBigWigsMods%2Fpackager&report=BigWigsMods+%28user%29)

## Releases

## Used by

## Contributors

## Languages

You can’t perform that action at this time.