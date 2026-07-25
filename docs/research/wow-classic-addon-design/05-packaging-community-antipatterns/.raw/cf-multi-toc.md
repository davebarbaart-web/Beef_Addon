![Thank you for reaching out to us!](https://content.overwolf.com/support-freshdesk/assets/thank-you-crow.webp)

# Thank you for reaching out to us!

## Your ticket has been successfully submitted.

You'll receive an email with your ticket details, and our support will contact you within 48-72 hours.

[View my ticket](https://support.curseforge.com/support/tickets) [Continue to Home](https://support.curseforge.com/support/home)

## Multi-TOC for World of Warcraft Addons

Modified on: Wed, 28 Feb, 2024 at 2:00 PM

### **Take me to...**

- [Introduction to TOC](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons#Introduction-to-TOC)
- [Creating your TOC files](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons#Creating-your-TOC-files)
- [How to Tag Flavors in your CurseForge Addon File Page](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons#How-to-Tag-Flavors-in-your-CurseForge-Addon-File-Page)

* * *

## **Introduction to TOC**

TOC (Table of Contents) files contain information about your addon (such as the addon name and description.) In addition the TOC file contains instructions on how the addon should be loaded by the Blizzard client.

Multi-TOC is a new feature which was implemented by Blizzard following the release of The Burning Crusade game version. The feature allows a single addon to have multiple TOC files. This means that you can have a single project that supports different game versions, often referred to as ‘instances’ or ‘flavors’. By having a single project suited for different flavors,  your project becomes more accessible for users and saves you time in setting up multiple project pages, uploading files or editing multiple change logs.

Multi-TOC requires certain prerequisites to be correctly loaded in-game, as well as additional steps so that the CurseForge App correctly loads the relevant file when launching each of the game versions.

The following community-created articles can be used as a reference for creating TOC files:

- [https://wowpedia.fandom.com/wiki/TOC\_format](https://wowpedia.fandom.com/wiki/TOC_format)
- [https://github.com/Stanzilla/WoWUIBugs/issues/68#issuecomment-889431675](https://github.com/Stanzilla/WoWUIBugs/issues/68#issuecomment-889431675)

_Please note that these articles are not part of CurseForge or Blizzard. As such CurseForge and Blizzard are not responsible for any content shown on these websites or providing further support regarding the information provided in these community created articles._

* * *

## **Creating your TOC files**

Every TOC file needs to start with the addon name used in the parent folder (For example addon\_name.toc in the addon\_name folder). If you don’t use the same name - the CurseForge validator may fail the upload or the addon will not be recognized by the Blizzard client.

Additionally, each TOC file needs to contain an interface number which indicates which World of Warcraft flavor the file is referring to. With each new World of Warcraft version the interface needs to be updated according to the new number.

Interface version numbers for each flavor can be found in the community articles mentioned above.

Example from the [Questie addon](https://www.curseforge.com/wow/addons/questie):

![](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/9148607414/original/02eFGHvXot4cFlqSCRzQBXpYyvj_kTVCLw.png?1641473897)

_In the example above, a single project supports two flavors - Burning Crusade and Classic._

![](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/9148607415/original/mvzy9cZDEVyPUIkiKPZt5EMTEGwZvPapKA.png?1641473897)

![](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/9148607416/original/i0EimzYySudHg872gAE32J94ogxSGP4qdQ.png?1641473897)

_In the screenshots above you can can see the interface # specified for each file, both made available in the Folder Name. The .toc file names and the Parent folder name are both ‘Questie’, ensuring that the CurseForge App correctly associates each file with the relevant flavour in-app._

Note \- It is under the responsibility of the addon authors to make sure this is up to date and that the project is flagged correctly on CurseForge. You can [Contact an Author](https://support.curseforge.com/en/support/solutions/articles/9000197201-contacting-an-author) or report and issue for them in case they have not set up the file correctly.

* * *

## **How to Tag Flavors in your CurseForge Addon File Page**

When uploading the file you can tag which versions are supported:

![](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/9148608206/original/KiQ-hHuoBXAowJpIClPMkbctHKnKeJxfLg.png?1641474375)

In this example the addon does not support World of Warcraft Retail but it does support version 2.5.2 of World of Warcraft Burning Crusade and version 1.14.1 or World of Warcraft Classic.

The project will also show this in the website under the Project details

![](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/9148608402/original/6Vx7Gy6T2EExEfP21mTzEiCgoMu31QNH1Q.png?1641474521)

Note \- You can always edit your file tags if needed.

Was this article helpful?
Yes
No

Send feedback

Sorry we couldn't be helpful. Help us improve this article with your feedback.

### Related Articles

- [World of Warcraft Addons - FAQ and Troubleshooting](https://support.curseforge.com/support/solutions/articles/9000198422-world-of-warcraft-addons-faq-and-troubleshooting)

- [CurseForge App - Getting Started](https://support.curseforge.com/support/solutions/articles/9000193488-curseforge-app-getting-started)

- [Updating Addons for New World of Warcraft Classic Expansions](https://support.curseforge.com/support/solutions/articles/9000202351-updating-addons-for-new-world-of-warcraft-classic-expansions)

- [Linux Troubleshooting](https://support.curseforge.com/support/solutions/articles/9000265088-linux-troubleshooting)

- [CurseForge File Processor Errors - Per Game](https://support.curseforge.com/support/solutions/articles/9000210425-curseforge-file-processor-errors-per-game)

- [CurseForge Known Issues](https://support.curseforge.com/support/solutions/articles/9000196615-curseforge-known-issues)

- [Project Localization](https://support.curseforge.com/support/solutions/articles/9000197356-project-localization)

- [CurseForge Error Messages](https://support.curseforge.com/support/solutions/articles/9000218280-curseforge-error-messages)

- [CurseForge Troubleshooting](https://support.curseforge.com/support/solutions/articles/9000194900-curseforge-troubleshooting)

- [How to Load Data Packs into Your Minecraft World](https://support.curseforge.com/support/solutions/articles/9000267956-how-to-load-data-packs-into-your-minecraft-world)


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

![Article views count](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons/hit)