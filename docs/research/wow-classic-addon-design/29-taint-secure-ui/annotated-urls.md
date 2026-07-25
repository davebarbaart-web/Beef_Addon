# Annotated URLs — taint, secure UI, combat lockdown

**Track:** 29-taint-secure-ui  
**Last updated:** 2026-07-25  

Steal/adapt notes are for Church of Beef design judgment, not copy-paste implementation.

## Core model

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [Secure Execution and Tainting (warcraft.wiki.gg)](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) | Canonical taint + protected-frame + terminology + Classic note | Teach every Beef UI author the honey model; cite before inventing “secure click” features |
| [Secure Execution and Tainting (Wowpedia mirror)](https://wowpedia.fandom.com/wiki/Secure_Execution_and_Tainting) | Same content family; useful if wiki.gg is under maintenance | Fallback primary |
| [AddOn Studio — Secure Execution and Tainting](https://addonstudio.org/wiki/WoW:Secure_Execution_and_Tainting) | Clear hooksecurefunc “restores prior taint mode” wording | Use when explaining why replace≠hook |
| [Townlong Yak — Taint in World of Warcraft (archive)](https://web.archive.org/web/20210518120056/https://www.townlong-yak.com/taint.log/about.html) | `taint.log` levels, what is *not* logged, unintended-propagation thesis | QA runbook for mysterious action-blocked reports |
| [Iriel guide (Card Place archive of 2006 post)](http://blue.cardplace.com/newcache/us/34224257.htm) | Historical primary cited by wiki | Context only; prefer current wiki for API |

## Secure frames, handlers, drivers

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [SecureTemplates](https://warcraft.wiki.gg/wiki/SecureTemplates) | Family overview of attribute-driven protected widgets | Confirm Beef does **not** need these for V1 |
| [SecureActionButtonTemplate](https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate) | How protected actions are meant to be exposed | Spec compliance: no cast/target buttons |
| [SecureHandlers](https://warcraft.wiki.gg/wiki/SecureHandlers) | Snippet templates + base methods | Last-resort reference if a secure child is ever unavoidable |
| [API SecureHandlerWrapScript](https://warcraft.wiki.gg/wiki/API_SecureHandlerWrapScript) | WrapScript contract + eligible handlers | Advanced only |
| [SecureStateDriver](https://warcraft.wiki.gg/wiki/SecureStateDriver) | AttributeDriver / UnitWatch / throttle + events | Not a Beef ladder tool; know it exists |
| [SecureHandlerStateTemplate (Wowpedia)](https://wowpedia.fandom.com/wiki/SecureHandlerStateTemplate) | `_onstate-*` + RegisterStateDriver example | Contrast: combat-safe show/hide for *protected* frames |
| [RestrictedEnvironment (archive)](https://wowwiki-archive.fandom.com/wiki/RestrictedEnvironment) | What snippets may call | Explains why ladder logic cannot live in snippets |
| [Iriel — Field Guide to Secure Handlers PDF](http://www.iriel.org/wow/docs/SecureHeadersGuide-4.0-r1.pdf) | Deep authoritative SecureHandlers guide | Read before any SecureHandler experiment |
| [SecureHandlers (WoWWiki archive)](https://wowwiki-archive.fandom.com/wiki/SecureHandlers) | Template inventory / FrameXML file map | Cross-check |

## Lockdown & diagnostics

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [API InCombatLockdown](https://warcraft.wiki.gg/wiki/API_InCombatLockdown) | Timing vs REGEN events; protected-frame restrictions list | Gate layout/options apply |
| [API issecurevariable](https://warcraft.wiki.gg/wiki/API_issecurevariable) | Inspect which addon tainted a global | Debug officer-reported blocks |
| [ADDON_ACTION_BLOCKED (Wowpedia)](https://wowpedia.fandom.com/wiki/ADDON_ACTION_BLOCKED) | Event fired when protected call blocked from tainted code | Optional internal telemetry (never spam users) |
| [API ShowUIPanel (Wowpedia)](https://wowpedia.fandom.com/wiki/API_ShowUIPanel) | Combat protection since 8.2.0 | Do not use for Beef windows |
| [better-addons — Security Model](https://www.better-addons.com/security) | Readable overview: taint, lockdown queue pattern, hardware events | Onboarding doc for contributors (secondary to wiki) |
| [Blizzard forum — Showing Elements in Combat Lockdown](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762) | Gello: insecure Show/Hide OK; secure child infects parents; SecureHandlerClick fix | **Highest-value practical thread for Beef** |
| [QuickQuest #36 — panel open in combat](https://github.com/p3lim-wow/QuickQuest/issues/36) | Real addon breakage from ShowUIPanel lockdown | Validates “own frame, not UIPanel” |

## Social / dropdown / popup footguns

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [Townlong Yak — UIDropDownMenu issues (archive)](https://web.archive.org/web/20200715202710/https://www.townlong-yak.com/bugs/PfF9rr-UIDropDownMenu) | Catalog of dropdown taint bugs / fixed vs not | Justify banning stock EasyMenu |
| [LibUIDropDownMenu — WowAce](https://www.wowace.com/projects/libuidropdownmenu) | Namespaced Blizzard dropdown clone; Classic notes | Preferred if context menus are required |
| [LibUIDropDownMenu — CurseForge](https://www.curseforge.com/wow/addons/libuidropdownmenu) | Classic / TBC Classic file channels | Dependency candidate |
| [AddOn Studio — StaticPopup dialogs](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes) | `preferredIndex = 3` taint avoidance note | Officer confirm dialogs |
| [!NoTaint (WowAce)](https://www.wowace.com/projects/notaint?page=2) | Community notes naming StaticPopup_Show among triggers | Treat as hint list, not gospel |
| [WoWInterface — don’t replace AddMessage](https://www.wowinterface.com/forums/showthread.php?t=60069) | Chat hook hygiene | Beef chat spectacle rules |

## FrameXML / source peek

| URL | Why it matters | Steal / adapt for Beef |
|-----|----------------|------------------------|
| [Townlong Yak FrameXML — SecureStateDriver.lua (live)](https://www.townlong-yak.com/framexml/live/SecureStateDriver.lua) | Implementation of drivers | Rarely needed; trust wiki first |
| [Townlong Yak FrameXML — SecureHandlers.lua](https://www.townlong-yak.com/framexml/live/SecureHandlers.lua) | Handler implementation | Same |
| [Gethe wow-ui-source search — SecureHandlerWrapScript](https://github.com/Gethe/wow-ui-source/search?q=SecureHandlerWrapScript) | GitHub mirror search | When verifying patch drift |

## Explicitly not primary for this track

| Topic | Prefer instead |
|-------|----------------|
| OnUpdate / memory / CTL | Track `04-toc-api-performance` |
| BeefNet throttle | Track `14-addon-messaging-beefnet` |
| Combat HUD UX patterns | Track `08-combat-hud-alerts` |
| Retail Secret Values / Midnight | Out of V1; wiki trail “Secret Values” only for contrast |

## Provenance dumps

Raw parallel-cli outputs for audit:

- `.raw/search-taint-secure-core.json`
- `.raw/search-social-footguns.json`
- `.raw/search-secure-handlers.json`
- `.raw/search-popup-dropdown-footguns.json`
- `.raw/extract-wiki-core.json`
- `.raw/extract-dropdown-taint.json`
- `.raw/extract-hooks-security.json`
