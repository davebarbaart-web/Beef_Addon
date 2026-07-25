# Annotated URL References

**Last updated:** 2026-07-25  
**Legend:** ★★★ primary / authoritative · ★★ strong secondary · ★ sentiment or illustrative  
**Steal/adapt** = what Church of Beef should take; not a license claim.

Local scrapes/search JSON for audit: [`.raw/`](.raw/).

---

## A. Packaging & distribution (primary)

| URL | Ann. | Why it matters | Steal / adapt for Beef |
|-----|------|----------------|------------------------|
| [CurseForge — Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project) | ★★★ | Official project fields, English description rule, categories, moderation gate, file upload | Draft CF page before code freeze; English Guild/RP framing |
| [CurseForge — Project Submission Guide and Tips](https://support.curseforge.com/support/solutions/articles/9000199552-project-submission-guide-and-tips) | ★★★ | Logo ≥400×400 1:1 PNG; summary/category tips; screenshot guidance | Brand logo + clean ladder screenshots |
| [CurseForge — Automatic Packaging](https://support.curseforge.com/en/support/solutions/articles/9000197281-automatic-packaging) | ★★★ | Webhook packaging, alpha/beta tags, `.pkgmeta` / `pkgmeta.yaml` | Adopt when repo is public |
| [CurseForge — Multi-TOC for WoW Addons](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons) | ★★★ | Folder/TOC name match; flavor tagging on file page; Questie example | Tag **Burning Crusade Classic** correctly for Anniversary |
| [CurseForge — WoW Addons FAQ](https://support.curseforge.com/support/solutions/articles/9000198422-world-of-warcraft-addons-faq-and-troubleshooting) | ★★ | Player-facing install troubleshooting links | FAQ snippet for README |
| [Wago Addons API docs](https://docs.wago.io/) | ★★★ | `X-Wago-ID`, `WAGO_API_TOKEN`, packager + manual multipart upload schema | Dual-publish path |
| [Wago Addons home](https://addons.wago.io/) | ★★ | Flavor filters (incl. Burning Crusade Classic); Guild / Roleplay categories | Category language check |
| [BigWigsMods/packager](https://github.com/BigWigsMods/packager) | ★★★ | De-facto zip+upload to CF / WoWI / Wago / GitHub; TOC `X-*-ID` keys | Standard CI once IDs exist |
| [Wowpedia — Using BigWigs Packager with GHA](https://wowpedia.fandom.com/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions) | ★★ | Workflow examples, `.pkgmeta` patterns | Copy structure, not retail Interface numbers |
| [Warcraft Wiki — TOC format](https://warcraft.wiki.gg/wiki/TOC_format) | ★★★ | Interface lists, `_TBC` suffix for BC Classic + Anniversary, out-of-date rules | V1 `20506` + future port suffixes |
| [WowInterface Developer FAQ hub](https://www.wowinterface.com/forums/faq.php?faq=developer) | ★★ | Legacy hub author tooling (Git/SVN/zip) | Optional third publish target |
| [WowInterface — Automagically package guide](https://www.wowinterface.com/forums/showthread.php?t=55801) | ★★ | Community packaging automation thread | Historical context for CI culture |

---

## B. Accessibility & client options

| URL | Ann. | Why it matters | Steal / adapt for Beef |
|-----|------|----------------|------------------------|
| [Blizzard — Colorblind support Patch 6.1](https://worldofwarcraft.blizzard.com/en-gb/news/17964863/new-colorblind-support-in-patch-61) | ★★★ | Official filters + tooltip text enhancements | Test rank colors under all three + strength |
| [Blizzard Watch — DF accessibility consolidation](https://blizzardwatch.com/2022/07/27/accessibility-options-dragonflight/) | ★★ | Player-facing roundup: contrast, photosensitivity, TTS, move pad | Quiet defaults; high-contrast text; no strobe ceremonies |
| [Warcraft Wiki — Addon compartment](https://warcraft.wiki.gg/wiki/TOC_format#Addon_compartment_integration) | ★★ | Retail minimap compartment TOC API | Portability note only for Classic+ / future |

---

## C. Community density / clean UI (sentiment)

| URL | Ann. | Why it matters | Steal / adapt for Beef |
|-----|------|----------------|------------------------|
| [r/classicwow — default UI hot take](https://www.reddit.com/r/classicwow/comments/1hbv7lq/hot_take_default_ui_looks_better_than_90_of_your/) | ★ | Classic aesthetic pushback against stacked UIs | Don’t require ElvUI; feel native |
| [r/wowhardcore — clean UI difference](https://www.reddit.com/r/wowhardcore/comments/1rd6o45/a_clean_ui_can_make_a_difference/) | ★ | HC minimalism as virtue | Edge ladder, low chrome |
| [r/WowUI — LunaUI clean pack](https://www.reddit.com/r/WowUI/comments/1rr6mh9/free_highly_optimised_lunaui_clean_efficient/) | ★ | “Warcrafty” clean packs still market hard | Brand can be ornate **inside** a small panel |
| [Wago UI Packs search](https://uipacks.wago.io/search) | ★★ | “Simple and Clean” is a product category | Screenshot language: clean + ceremonial |
| [Medium — Best UI 2026](https://medium.com/@debonikawow/best-ui-for-wow-complete-guide-for-a-perfect-interface-in-2026-7c03bc12dce7) | ★ | Density-with-purpose rhetoric (often retail-leaning) | Apply purpose test to every Beef widget |
| [YouTube — Cleanest UI Classic](https://www.youtube.com/watch?v=U-WHO_PyU2A) | ★ | Popular clean-Classic tutorial genre | Match thumbnail expectations on CF |

---

## D. Complaints & anti-patterns

| URL | Ann. | Why it matters | Steal / adapt for Beef |
|-----|------|----------------|------------------------|
| [Blizzard forums — minimap cluttered (Classic)](https://us.forums.blizzard.com/en/wow/t/minimap-cluttered-addon-help/304044) | ★★★ | Direct Classic minimap-button complaint | Hideable single button + `/beef` |
| [Blizzard forums — break the guild spam addon (2025)](https://us.forums.blizzard.com/en/wow/t/as-long-as-youre-breaking-addons-break-the-guild-spam-addon/2196741) | ★★★ | Modern hostility to guild invite/whisper spam | Zero auto-invite/whisper; careful chat |
| [r/classicwow — minimap mess](https://www.reddit.com/r/classicwow/comments/ffa99x/any_idea_of_an_addon_i_can_use_to_sort_out_the/) | ★ | “Most addons can turn off minimap buttons; use slash cmds” | Document `/beef` in Notes |
| [Icy Veins — Guild Spam Silencer](https://www.icy-veins.com/wow/news/tired-of-guild-spam-heres-how-the-guild-spam-silencer-addon-brings-peace-to-your-chat/) | ★★ | Market for *suppressing* guild spam tools | Do not become the problem those addons solve |
| [CurseForge — Global Ignore List](https://www.curseforge.com/wow/addons/global-ignore-list) | ★ | Players install entire stacks to fight chat noise | Keep Beef quiet by default |
| [Wowhead — Best Addons Classic Fresh](https://www.wowhead.com/classic/news/the-best-addons-for-wow-classic-fresh-351334) | ★★ | What “must have” lists emphasize (QoL, not social theater) | Position Beef as guild culture, not Fresh must-have |

---

## E. Platform comparison / managers (context)

| URL | Ann. | Why it matters | Steal / adapt for Beef |
|-----|------|----------------|------------------------|
| [r/wow — Wago Addon Manager vs CurseForge](https://www.reddit.com/r/wow/comments/1eaa5y5/wago_addon_manager_vs_curseforge/) | ★ | Players split managers | Dual-publish reduces friction |
| [Blizzard forums — WoWUp / Curse / Wago](https://us.forums.blizzard.com/en/wow/t/wow-up-curse-wago/2292441) | ★ | Multi-client updater ecosystem | Don’t assume single storefront |
| [GitHub — Publish on Wago? (AdiBags)](https://github.com/arkayenro/arkinventory/issues/1555) | ★ | Author migration chatter to Wago | Confirms Wago as expected second home |

---

## F. Research artifacts (this track)

| Path | Notes |
|------|-------|
| [`.raw/wow-packaging-community-antipatterns-deep.md`](.raw/wow-packaging-community-antipatterns-deep.md) | Parallel deep-research draft — verify before treating as policy |
| [`.raw/wow-packaging-community-antipatterns-deep.json`](.raw/wow-packaging-community-antipatterns-deep.json) | Structured basis + metadata |
| [`.raw/search-*.json`](.raw/) | Firecrawl search result sets |
| [`.raw/cf-*.md`](.raw/), [`.raw/wago-*.md`](.raw/), [`.raw/wiki-toc-format.md`](.raw/), etc. | Scraped primaries |
