![Thank you for reaching out to us!](https://content.overwolf.com/support-freshdesk/assets/thank-you-crow.webp)

# Thank you for reaching out to us!

## Your ticket has been successfully submitted.

You'll receive an email with your ticket details, and our support will contact you within 48-72 hours.

[View my ticket](https://support.curseforge.com/support/tickets) [Continue to Home](https://support.curseforge.com/support/home)

## Automatic Packaging

Modified on: Wed, 21 Feb, 2024 at 5:36 PM

### Take me to...

- [Configuring the Repository Webhook](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging#%E2%80%8B%E2%80%8BConfiguring-the-Repository-Webhook)
- [Configuring the Repository Webhook on GitHub or Bitbucket](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging#Configuring-the-Repository-Webhook-on-GitHub-or-Bitbucket)
- [Automatically Marking Your Files as Alpha, Beta, or Release](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging#Automatically-Marking-Your-Files-as-Alpha,-Beta,-or-Release)
- [File Packaging Configuration](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging#File-Packaging-Configuration)
- [Replacement Tokens](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging#Replacement-Tokens)
- [Alpha replacements](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging#Alpha-replacements)

* * *

## Configuring the Repository Webhook

### Generate a CurseForge API token

First, you’ll need to generate an API token. To do this, navigate to your [API tokens page](https://www.curseforge.com/account/api-tokens). From here, give the token a descriptive name such as "Webhooks." Once the token has been generated, move to Step 2 in order to configure the webhook on GitHub or Bitbucket.

### Configuring the Repository Webhook on GitHub or Bitbucket

| GitHub | Bitbucket |
| --- | --- |
| First, go to “Webhooks & Services” under settings for your repository and click the “Add Webhook“ button. | First, go to “Hooks” under settings for your repository, and under “Select a hook…” pick “POST” and then click the “Add hook” button. |
| For the Payload URL, use one of the following values, based on the site where your project resides: | For the URL field, use one of the following values, based on the site where your project resides: |
| [https://www.curseforge.com/api/projects/](https://www.curseforge.com/api/projects/) **{projectID}**/package?token= **{token}** |
| Replace {projectID} with the ID from the About This Project section of your project’s Overview page on CurseForge, and {token} with the token we just generated above. Leave all other settings at their defaults. | Replace {projectID} with the ID from the About This Project section of your project’s Overview page on CurseForge, and {token} with the token we just generated above. |

## Automatically Marking Your Files as Alpha, Beta, or Release

When packaging is triggered on your repository, the generated file’s release type will automatically be set based on two factors:

1. If configured to package all commits, the latest untagged commit will be packaged and will be marked as an alpha.
2. Otherwise, when a tagged commit is pushed, it will be flagged as either alpha, beta, or release depending on the tag itself:
   - If the tag contains the word “alpha”, for example “1.0-alpha” or “1.0.alpha7”, it will be marked as an alpha file.
   - If instead the tag contains the word “beta,” it will be marked as a beta file.

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

```generic

```

Generic

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

Turns into `--[===[@debug` and `--@end-debug]===]`.

`--[===[@non-debug@` and `--@end-non-debug@]===]`

Turns into `--@non-debug@` and `--@end-non-debug@`.

XML

`<!--@debug@-->` (insert code here) `<!--@end-debug@-->`

Turns into `<!--@debug` (insert code here) `@end-debug@-->`.

`<!--@non-debug@` (insert code here) `@end-non-debug@-->`

Turns into `<!--@non-debug@-->` (insert code here) `<!--@end-non-debug@-->`.

TOC

`#@debug@` and `#@end-debug@>`

Turns into `#@debug@` and `#@end-debug@`, as well as adding a # to the beginning of each line in-between.

### **Exclude from packaging**

These occur based on filetype, as they tend to tie into the comment system for the file.

`--@do-not-package@` and `--@end-do-not-package@` (for Lua)

`<!--@do-not-package@-->` and `<!--@end-do-not-package@-->` (for XML)

`<!--@do-not-package@-->` (insert code here) `<!--@end-do-not-package@-->`

#@do-not-package@ and #@end-do-not-package@ (for TOC)

Removes everything between the @do-not-package@ and @end-do-not-package@ tags including the 2 tags themselves. This may cause line numbers of subsequent lines to change. The typical usage is at the end of Lua files surrounding debugging functions and other code that end users should never see/execute.

You will still need to comment out the @do-not-package@ and @end-do-not-package@ tags for the relevant file types.

### Alpha replacements

Occurs for packaged files that are Alpha release status. The transformations are filetype-based, as they tend to tie into the comment style for the file. The text between tokens isn't removed so, that line numbers stay the same; it is simply commented out.

This is useful for inserting extra debugging information that you want your alpha testers to have, but don't want to appear in release versions.

**Lua**

`--@alpha@` and `--@end-alpha@`

Turns into `--[===[@alpha` and `--@end-alpha]===]`.

`--[===[@non-alpha@` and `--@end-non-alpha@]===]`

Turns into `--@non-alpha@` and `--@end-non-alpha@`.

Example:

```generic

```

Generic

This would make the assert take place in development mode and alpha zips, but not for release and beta.

**XML**

`<!--@alpha@-->` and(insert code here) `<!--@end-alpha@-->`

`Turns into <!--@alpha` (insert code here) `@end-alpha@-->`.

`<!--@non-alpha@` (insert code here) `@end-non-alpha@-->`

Turns into ` <!--@non-alpha@-->` and(insert code here) ` <!--@end-non-alpha@-->`.

**TOC**

`#@alpha@` and `#@end-alpha@`

Turns into `#@alpha@` and `#@end-alpha@`, as well as adding a # to the beginning of each line in-between.

Was this article helpful?
Yes
No

Send feedback

Sorry we couldn't be helpful. Help us improve this article with your feedback.

### Related Articles

- [InZOI - Test your mod locally before publishing it](https://support.curseforge.com/support/solutions/articles/9000268828-inzoi-test-your-mod-locally-before-publishing-it)

- [Repository Keyword Substitutions](https://support.curseforge.com/support/solutions/articles/9000197910-repository-keyword-substitutions)

- [The Sims 4 Mods And CC Troubleshooting](https://support.curseforge.com/support/solutions/articles/9000222156-the-sims-4-mods-and-cc-troubleshooting)

- [The Sims 4 Mods - Getting Started](https://support.curseforge.com/support/solutions/articles/9000221982-the-sims-4-mods-getting-started)

- [Table Flip Simulator Moderation Guidelines](https://support.curseforge.com/support/solutions/articles/9000276094-table-flip-simulator-moderation-guidelines)

- [CurseForge App - Getting Started](https://support.curseforge.com/support/solutions/articles/9000193488-curseforge-app-getting-started)

- [CurseForge Premium - Switching to Tebex Payment System](https://support.curseforge.com/support/solutions/articles/9000237396-curseforge-premium-switching-to-tebex-payment-system)

- [CurseForge Server Affiliation Program FAQ](https://support.curseforge.com/support/solutions/articles/9000240602-curseforge-server-affiliation-program-faq)

- [Installing Minecraft Mods and Modpacks](https://support.curseforge.com/support/solutions/articles/9000196984-installing-minecraft-mods-and-modpacks)

- [Tremendous Payments FAQ](https://support.curseforge.com/support/solutions/articles/9000255367-tremendous-payments-faq)


### Need more help?

- [**Contact support** \\
\\
Tell us more and we help you](https://support.curseforge.com/support/tickets/new)
- [**Ask Discord community** \\
\\
Get Discord community help](https://discord.com/invite/curseforge)
- [**Suggest a feature** \\
\\
Share your ideas](https://curseforge-ideas.overwolf.com/)

![Article views count](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging/hit)