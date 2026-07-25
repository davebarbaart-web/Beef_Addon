# Source: https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging

# Curseforge Support

 Enter your search term here...

Search

 Contact support

Thank you for reaching out to us!

# Thank you for reaching out to us!

## Your ticket has been successfully submitted.

You'll receive an email with your ticket details, and our support will contact you within 48-72 hours.

View my ticket Continue to Home

* Home
* Authors support
* Project support
* Automatic Packaging

## Automatic Packaging

Modified on: Wed, 21 Feb, 2024 at 5:36 PM

### Take me to...

* Configuring the Repository Webhook
* Configuring the Repository Webhook on GitHub or Bitbucket
* Automatically Marking Your Files as Alpha, Beta, or Release
* File Packaging Configuration
* Replacement Tokens
* Alpha replacements

* * *

## Configuring the Repository Webhook

### Generate a CurseForge API token

First, you’ll need to generate an API token. To do this, navigate to your [API tokens page](https://www.curseforge.com/account/api-tokens) . From here, give the token a descriptive name such as "Webhooks." Once the token has been generated, move to Step 2 in order to configure the webhook on GitHub or Bitbucket.

### Configuring the Repository Webhook on GitHub or Bitbucket

|GitHub |Bitbucket |
| --- | --- |
|First, go to “Webhooks & Services” under settings for your repository and click the “Add Webhook“ button. |First, go to “Hooks” under settings for your repository, and under “Select a hook…” pick “POST” and then click the “Add hook” button. |
|For the Payload URL, use one of the following values, based on the site where your project resides: |For the URL field, use one of the following values, based on the site where your project resides: |
|<https://www.curseforge.com/api/projects/> **{projectID}** /package?token= **{token}** |
|Replace {projectID} with the ID from the About This Project section of your project’s Overview page on CurseForge, and {token} with the token we just generated above. Leave all other settings at their defaults. |Replace {projectID} with the ID from the About This Project section of your project’s Overview page on CurseForge, and {token} with the token we just generated above. |

## Automatically Marking Your Files as Alpha, Beta, or Release

When packaging is triggered on your repository, the generated file’s release type will automatically be set based on two factors:

1. If configured to package all commits, the latest untagged commit will be packaged and will be marked as an alpha.
2. Otherwise, when a tagged commit is pushed, it will be flagged as either alpha, beta, or release depending on the tag itself:
   
    + If the tag contains the word “alpha”, for example “1.0-alpha” or “1.0.alpha7”, it will be marked as an alpha file.
    + If instead the tag contains the word “beta,” it will be marked as a beta file.

## File Packaging Configuration

You can optionally configure the way your file is packaged by including a [YAML](https://en.wikipedia.org/wiki/YAML) file named either "pkgmeta.yaml" or ".pkgmeta" in the root of your repository. Each of these behaviors are optional:

1. Specify the name of the packaged file. If omitted, the packaged file will be named after the project's URL slug.
2. Inclusion of libraries or code from other projects.
3. Move files and folders.
4. Ignore files and folders.
5. Specify dependencies on other projects, if they are available on the site.
6. Specify tools used in the development of your project, if they are available on the site.
7. Override compilation of repository commit messages with a manually-written change log.
8. Inclusion of the project license in the packaged file.

**An example, with all of the options utilized:**

```
package-as: KillerCupcakes  
enable-nolib-creation: no  
  
externals:  
    libs/LibDialog:  
        url: <https://github.com/wildstarnasa/LibDialog.git>  
        tag: latest # if this line is left out, the latest version (even if it's not a tag) is assumed  
    libs/GeminiAddon:  
        url: [https://github.com/wildstarnasa/GeminiAddon.git](https://github.com/wildstarnasa/GeminiAddon.git)        tag: 1337.0.10 # This is an example. Please use an actual tag if you are targeting a specific version.  
  
move-folders:  
    KillerCupcakes/Modules/Fire: KillerCupcakesOnFire # This moves KillerCupcakes/Modules/Fire to the same level as KillerCupcakes, as KillerCupCakesOnFire  
    KillerCupcakes/Modules/Sky: KillerCupcakesInTheSky  
  
ignore: # Files and directories beginning with a dot (such as .git) are automatically ignored, as is the pgkmeta file itself.  
    - Scripts  
    - Some/File.txt  
  
required-dependencies:  
    - 221710-dear-cupcake  
  
optional-dependencies:  
    - 220002-junkit  
  
manual-changelog: CHANGELOG.txt  
  
license-output: LICENSE.txt  
  
tools-used:  
    - data-tools
```

## Replacement Tokens

When repositories are packaged, certain keyword substitutions take place on text files.

### **Simple replacements**

@file-revision@

@file-hash@

The current revision/hash of the file. For example: 106c634df4b3dd4691bf24e148a23e9af35165ea

@project-revision@

@project-hash@

The hash of the entire project in hex form. e.g. `106c634df4b3dd4691bf24e148a23e9af35165ea`

@file-abbreviated-hash@

The abbreviated hash of the file in hex form. e.g. `106c63`

@project-abbreviated-hash@

The abbreviated hash of the entire project in hex form. e.g. `106c63`

@file-author@

The name of the last author of the file.

@project-author@

The name of the last author of the entire project.

@file-date-iso@

The last changed date (by UTC) of the file in ISO 8601. e.g. `2014-05-01T12:34:56Z`

@project-date-iso@

The last changed date (by UTC) of the entire project in ISO 8601. e.g. `2014-05-01T12:34:56Z`

@file-date-integer@

The last changed date (by UTC) of the file in a readable integer fashion. e.g. `20140501123456`

@project-date-integer@

The last changed date (by UTC) of the entire project in a readable integer fashion. e.g. `2014050123456`

@file-timestamp@

The last changed date (by UTC) of the file in POSIX timestamp. e.g. `1209663296`

@project-timestamp@

Turns into the last changed date (by UTC) of the entire project in POSIX timestamp. e.g. `1209663296`

@project-version@

An approximate version of the project. The tag name if on a tag, otherwise the short revision.

### **Debug replacements**

These occur based on filetype, as they tend to tie into the comment system for the file.

The insides aren't removed so that line numbers stay the same, they just cause them to be commented out.

Lua

`--@debug@` and `--@end-debug@`

Turns into `--[===[@debug` and `--@end-debug]===]` .

`--[===[@non-debug@` and `--@end-non-debug@]===]`

Turns into `--@non-debug@` and `--@end-non-debug@` .

XML  
`` (insert code here) ``

Turns into `` .

``

Turns into `` (insert code here) `` .

TOC

`#@debug@` and `#@end-debug@>`

Turns into `#@debug@` and `#@end-debug@` , as well as adding a # to the beginning of each line in-between.

### **Exclude from packaging**

These occur based on filetype, as they tend to tie into the comment system for the file.

`--@do-not-package@` and `--@end-do-not-package@` (for Lua)

`` and `` (for XML)  
`` (insert code here) ``

\#@do-not-package@ and #@end-do-not-package@ (for TOC)

Removes everything between the @do-not-package@ and @end-do-not-package@ tags including the 2 tags themselves. This may cause line numbers of subsequent lines to change. The typical usage is at the end of Lua files surrounding debugging functions and other code that end users should never see/execute.

You will still need to comment out the @do-not-package@ and @end-do-not-package@ tags for the relevant file types.

### Alpha replacements

Occurs for packaged files that are Alpha release status. The transformations are filetype-based, as they tend to tie into the comment style for the file. The text between tokens isn't removed so, that line numbers stay the same; it is simply commented out.

This is useful for inserting extra debugging information that you want your alpha testers to have, but don't want to appear in release versions.

**Lua**

`--@alpha@` and `--@end-alpha@`

Turns into `--[===[@alpha` and `--@end-alpha]===]` .

`--[===[@non-alpha@` and `--@end-non-alpha@]===]`

Turns into `--@non-alpha@` and `--@end-non-alpha@` .

Example:

```
--@alpha@  
assert(everythingIsOkay())  
--@end-alpha@
```

This would make the assert take place in development mode and alpha zips, but not for release and beta.

**XML**

`` and(insert code here) ``

`Turns into ` .

``

Turns into ` ` and(insert code here) ` ` .

**TOC**

`#@alpha@` and `#@end-alpha@`

Turns into `#@alpha@` and `#@end-alpha@` , as well as adding a # to the beginning of each line in-between.

Did you find it helpful? Yes No

Send feedback

Sorry we couldn't be helpful. Help us improve this article with your feedback.

### Related Articles

### Need more help?

* #### Contact support Tell us more and we help you
* [#### Ask Discord community Get Discord community help](https://discord.com/invite/curseforge)
* [#### Suggest a feature Share your ideas](https://curseforge-ideas.overwolf.com/)

back to top

[](https://www.curseforge.com/)

Ⓒ 2025 Overwolf. All rights reserved.

* [Terms of service](https://legal.overwolf.com/docs/overwolf/website/terms-of-use/)
* [Privacy Policy](https://legal.overwolf.com/docs/overwolf/website/privacy-policy/)
* [Licenses](https://support.overwolf.com/support/solutions/articles/9000203492-licenses-we-use)
* [Mod Author Terms](https://legal.overwolf.com/docs/curseforge/mod-authors-terms)

* [](https://www.instagram.com/curseforgeofficial "Instagram")
* [](https://www.tiktok.com/@curseforge "Tiktok")
* [](https://www.youtube.com/@CurseForge "YouTube")
* [](https://www.reddit.com/r/CurseForge "Reddit")
* [](https://x.com/CurseForge "X")
* [](https://discord.gg/curseforge "Discord")

Article views count
