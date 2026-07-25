# Annotated URLs — Testing / Debugging / QA Track

**Last updated:** 2026-07-25  
**Track:** [19-testing-debugging-qa](README.md)

Steal/adapt notes are for **Church of Beef QA process**, not for copying combat-addon patterns.

---

## Errors and CVars

| URL | Annotation |
|-----|------------|
| [https://warcraft.wiki.gg/wiki/Console_variables](https://warcraft.wiki.gg/wiki/Console_variables) | Canonical CVar list; `scriptErrors` default `0`, Account scope — why testers see silent failures. |
| [https://www.wowace.com/projects/rarity/pages/faq/how-to-enable-and-disable-script-errors-lua-errors](https://www.wowace.com/projects/rarity/pages/faq/how-to-enable-and-disable-script-errors-lua-errors) | Author-facing FAQ: `/console scriptErrors 1\|0`, reload caveat — copy into Beef contributor README later. |
| [https://us.forums.blizzard.com/en/wow/t/lua-error-display/789150](https://us.forums.blizzard.com/en/wow/t/lua-error-display/789150) | Community confirmation of `scriptErrors 1` / `0` toggle. |
| [https://eu.forums.blizzard.com/en/wow/t/lua-errors-logs/84307](https://eu.forums.blizzard.com/en/wow/t/lua-errors-logs/84307) | Notes UI checkbox removal; points authors to CVar or BugSack/Swatter. |
| [https://wowinterface.com/forums/showthread.php?t=59013](https://wowinterface.com/forums/showthread.php?t=59013) | `SetCVar("scriptErrors", …)` ≡ `/console`; culture: fix, don’t silence. |

## BugGrabber / BugSack

| URL | Annotation |
|-----|------------|
| [https://github.com/funkydude/BugSack](https://github.com/funkydude/BugSack) | Source + feature summary; requires BugGrabber; copy/paste stacks for reports. |
| [https://www.curseforge.com/wow/addons/bugsack](https://www.curseforge.com/wow/addons/bugsack) | Distribution; confirm Classic TBC / Anniversary flavor when installing. |
| [https://www.wowinterface.com/downloads/info5995-BugSack.html](https://www.wowinterface.com/downloads/info5995-BugSack.html) | Alternate host; lists Classic/TBC compatibility. |
| [https://www.wowinterface.com/downloads/fileinfo.php?id=23141](https://www.wowinterface.com/downloads/fileinfo.php?id=23141) | BugGrabber: grabber vs display roles; chat fallback without Sack. |
| [https://addons.wago.io/addons/buggrabber](https://addons.wago.io/addons/buggrabber) | Wago mirror; same “use with BugSack” guidance. |
| [https://www.curseforge.com/wow/addons/bug-grabber](https://www.curseforge.com/wow/addons/bug-grabber) | CurseForge BugGrabber project page for flavor downloads. |

## Alpha / Beta channels and packaging

| URL | Annotation |
|-----|------------|
| [https://wowup.io/guide/my-addons/addons](https://wowup.io/guide/my-addons/addons) | Per-addon Stable/Alpha/Beta; “accept tier or newer” semantics; CurseForge + WowUpHub. |
| [https://wowup.io/guide/my-addons/overview](https://wowup.io/guide/my-addons/overview) | Client selector / update-all — keep Anniversary isolate. |
| [https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging) | Untagged→alpha; tag words alpha/beta; `@alpha@` debug blocks — officer pipe design. |
| [https://github.com/BigWigsMods/packager](https://github.com/BigWigsMods/packager) | De-facto packager; `{alpha}`/`{beta}` tokens; CI upload pattern. |
| [https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons) | Multi-TOC + CurseForge App flavor tagging — QA when porting. |

## TOC / Interface verification

| URL | Annotation |
|-----|------------|
| [https://warcraft.wiki.gg/wiki/TOC_format](https://warcraft.wiki.gg/wiki/TOC_format) | Interface numbers, multi-Interface commas, suffixes, `GetBuildInfo` dump — primary TOC QA bible. |
| [https://github.com/p3lim/toc-interface-updater](https://github.com/p3lim/toc-interface-updater) | CI helper for Interface bumps; `tbc`/`anniversary` flavor aliases. |

## Secure / lockdown

| URL | Annotation |
|-----|------------|
| [https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) | Taint + protected frames model Classic inherits — why Beef stays on ordinary frames. |
| [https://wowpedia.fandom.com/wiki/API_InCombatLockdown](https://wowpedia.fandom.com/wiki/API_InCombatLockdown) | `InCombatLockdown()` probe for combat QA scripts. |
| [https://www.better-addons.com/security](https://www.better-addons.com/security) | Practical lockdown limits + `PLAYER_REGEN_ENABLED` queue pattern. |
| [https://github.com/Amadeus-/WoWAddonDevGuide/blob/master/10_Advanced_Techniques.md](https://github.com/Amadeus-/WoWAddonDevGuide/blob/master/10_Advanced_Techniques.md) | Queue-after-combat idiom; Classic vs newer restriction APIs. |
| [https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762) | Social/loot addon author pain — Show/Hide during combat; reinforces mid-combat UI tests. |

## Guild-tool QA culture (scenario inspiration)

| URL | Annotation |
|-----|------------|
| [https://www.curseforge.com/wow/addons/guildhelperclassic](https://www.curseforge.com/wow/addons/guildhelperclassic) | Early-alpha debug spam warning; multi-member share / offline telephone sync analogies for BeefNet tests. |
| [https://legacy-wow.com/mop-addons/guild-2-guild/](https://legacy-wow.com/mop-addons/guild-2-guild/) | Encourages multiple online addon users for stability — justifies multi-client lab. |

## Product anchor (repo)

| URL / path | Annotation |
|------------|------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | §11 edges, §13 success, §13.1 two-character verification — checklist source of truth. |

---

## Raw research artifacts

JSON/markdown extracts from this pass live under [`.raw/`](.raw/) (search + extract dumps). Prefer the annotated links above when citing in other docs.
