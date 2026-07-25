# Annotated Master Reference List

**Last updated:** 2026-07-25  
**Lane:** Synthesis (library root)  
**Purpose:** Curated URLs for Church of Beef design decisions — what each source is good for, and what to steal/adapt.  
**Related:** [README](README.md) · [Implications](00-church-of-beef-implications.md) · tracks [01](01-ux-patterns/)–[74](74-v1-decision-glossary/) · fill wave [57](57-scrollframe-list-rows/)–[74](74-v1-decision-glossary/)

Prefer primary wiki / WowAce / Blizzard / Tukui over listicles when making technical claims. Listicles are fine for “what players install” culture only.

---

## A. Official / wiki API & packaging

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| TOC format | https://warcraft.wiki.gg/wiki/TOC_format | Interface versions, SavedVariables directives, client-specific TOC suffixes, AllowLoadGameType | V1 single TOC `## Interface: 20506`; `SavedVariablesPerCharacter: ChurchOfBeefDB`; later multi-flavor / `_TBC.toc` for ports |
| SendAddonMessage | https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage | Prefix registration, channel types, throttle / result enums | BeefNet prefix `COB` on `GUILD`; small payloads; respect per-prefix allowance |
| Secure execution & tainting | https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting | Why addons cannot automate combat; Classic uses modern secure model | Hard line: announce/suggest only; ordinary frames; no secure-action complexity |
| Ace3 for Dummies | https://warcraft.wiki.gg/wiki/Ace3_for_Dummies | Conceptual Ace onboarding | Optional V2; reinforces “learn vanilla load order first” |
| WelcomeHome (first Ace3 addon) | https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon | Minimal AceAddon lifecycle example | Lifecycle timing analogue for plain `ADDON_LOADED` DB init |

---

## B. Libraries & frameworks

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Ace3 Getting Started | https://www.wowace.com/projects/ace3/pages/getting-started | OnInitialize/OnEnable, AceDB timing, embeds | Do not create DB at file load; embed pattern if adopting Ace later |
| AceConfig options tables | https://www.wowace.com/projects/ace3/pages | Declarative options UI conventions | Confirm dialogs for demote / Prophet / standing wipe even without Ace |
| Ace3 on CurseForge | https://www.curseforge.com/wow/addons/ace3 | Distribution / version presence | Soft OptionalDeps only if needed |
| ChatThrottleLib (WowAce) | https://www.wowace.com/projects/chatthrottlelib | Outbound chat/addon pacing to avoid disconnects / silent drops | Pace BeefNet and guild-chat announces |
| ChatThrottleLib (wiki mirror) | https://wowpedia.fandom.com/wiki/ChatThrottleLib | API details / priority streams | HIGH for commits, BULK for optional sync chunks |
| LibStub (CurseForge) | https://www.curseforge.com/wow/addons/libstub | Versioned shared lib loader | Always first if embedding any lib |
| LibDBIcon-1.0 | https://www.wowace.com/projects/libdbicon-1-0 | Standard minimap button via DataBroker | Preferred minimap path for collector coexistence |
| WowAce library directory | https://www.wowace.com/addons | Discover maintained Classic-capable libs | Prefer embed over hard Dependencies |

---

## C. Classic policy history (comms)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Wowhead — 1.13.3 CHANNEL ban | https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371 | Why GUILD/PARTY/RAID/WHISPER matter | Confirms BeefNet `GUILD` choice; never design around custom channels |
| Blizzard EU — 1.13.3 Lua API change | https://eu.forums.blizzard.com/en/wow/t/classic-patch-1-13-3-lua-api-change/111998 | Official social-dynamics rationale | Invisible cross-realm channel spam is unwanted — stay guild-scoped |
| Blizzard US — SendAddonMessage throttle reports | https://us.forums.blizzard.com/en/wow/t/classic-changes-to-cchatinfosendaddonmessage/544278 | Intermittent Classic throttle behavior | Don’t burst 40 commits in a loop; batch / CTL |
| Blizzard US — SendAddonMessage problems (loot sync) | https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054 | Large payload sync failures even with CTL | Prefer revisioned small commits + login sync over multi-KB dumps |
| Midnight addon messaging notes (Retail contrast) | https://github.com/Plaitrix/WoW-Midnight-Addon-Template/blob/main/docs-site/docs/midnight.md | Future encounter-time messaging clamps | Out of V1 scope; watch if Classic inherits similar rules |

---

## D. UI culture & visual language

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| ElvUI (Tukui) | https://tukui.org/elvui | Dominant full UI replacement; Anniversary layout notes | Coexist: unique frames, no global skin; theatrical chrome later without requiring ElvUI |
| Blizzard Watch — Classic UI modernization (2026-07-22) | https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/ | Default Classic UI drifting toward modern raid/nameplate options | “Plain Classic frames” ≠ frozen 2007; still avoid Retail-only APIs |
| Overgear — TBC Anniversary top addons | https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/ | What players actually stack (combat/quest/UI) | Beef is edge social tool; start-small packaging philosophy |
| Warperia — TBC addons | https://warperia.com/tbc-addons/ | Alternate Anniversary addon roundup | Cross-check category bias (combat-heavy) |
| Medium — UI philosophy 2026 | https://medium.com/@debonikawow/best-ui-for-wow-complete-guide-for-a-perfect-interface-in-2026-7c03bc12dce7 | “Info gravity” near character vs edges | Keep Beef off center combat HUD (retail-skewed; use carefully) |

---

## E. Persistence & profiles (conceptual)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| TOC — Saved variables section | https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables | Account vs per-character SV | Ladder/standing per-char; later split UI profile if needed |
| AceDB section in Getting Started | https://www.wowace.com/projects/ace3/pages/getting-started | char/realm/profile/global mental model | Vocabulary for future prefs without adopting Ace yet |

---

## F. Security model explainers (secondary)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Better-Addons — Security model | https://www.better-addons.com/security | Approachable InCombatLockdown / queue-after-combat patterns | Ordinary social UI rarely needs secure frames; still respect lockdown if touching protected APIs |
| AddOn Studio — Secure execution | https://addonstudio.org/wiki/WoW:Secure_Execution_and_Tainting | Alternate mirror of taint concepts | Same lesson: suggest ≠ decide combat |

---

## G. Spec & plan (repo-local)

| Source | Path | Use for |
|--------|------|---------|
| V1 design spec | [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Product truth: ladder, BeefNet, officer gate, scoring |
| V1 implementation plan | [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | File layout, `Interface 20506`, module boundaries |

---

## H. Library-internal corpus

| Path | Role |
|------|------|
| [`.raw/`](.raw/) | Scraped pages + search JSON for audit / re-synthesis |
| [01–74 track docs](README.md#library-index) | Deep dives; prefer updating those over bloating this list |
| [00 implications](00-church-of-beef-implications.md) | Decision-oriented synthesis |
| Fill-wave annotated lists | [57](57-scrollframe-list-rows/annotated-urls.md)–[73](73-desktop-lua-testing/annotated-urls.md) — fuller corpora; this file keeps the steal/adapt shortlist. Track [74](74-v1-decision-glossary/) is glossary-only (no primary URL corpus). |

---

## I. ScrollFrame / list rows (track 57)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| ScrollFrame archive | https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame/Archive | True vs Faux vs Hybrid; fidgeting warning | Prefer virtual lists for ladder/officer queues |
| FauxScrollFrame HOWTO | https://warcraft.wiki.gg/wiki/Making_a_scrollable_list_using_FauxScrollFrameTemplate | Offset → rebind visible rows | Default V1 list mental model |
| HybridScrollFrame | https://warcraft.wiki.gg/wiki/HybridScrollFrame | `CreateButtons` + update pattern | Only after Anniversary template verify; XML item template tax |
| CreateFrame | https://warcraft.wiki.gg/wiki/API_CreateFrame | Frames not GC’d; template inherit | Pool/reuse row frames |
| FauxScroll in pure Lua | https://www.wowinterface.com/forums/showthread.php?t=45810 | CreateFrame + Faux without XML | Fits Lua-primary Officer/Ladder shell |
| HonorSpy (Classic Hybrid) | https://github.com/kakysha/HonorSpy | Rank-style Hybrid + XML item template | Pattern proof; don’t copy AceGUI shell |

---

## J. StaticPopup & confirms (track 58)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Creating simple pop-ups (AddOn Studio) | https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes | `StaticPopupDialogs` fields, `data`/`data2`, `preferredIndex` notes | Demote / Prophet / wipe confirms |
| StaticPopup_Show | https://warcraft.wiki.gg/wiki/API_StaticPopup_Show | Canonical show signature / return frame-or-nil | Stable dialog keys; format args over rewriting `text` |
| AceConfig confirm semantics | https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables | `confirm` / `confirmText` on options | Settings-cousin pattern even without Ace UI |
| Gargul — Awarding Items | https://github.com/papa-smurf/Gargul/wiki/Awarding-Items | Confirm-before-commit loot UX | Name the subject; block one-click nuclear actions |

---

## K. Co-play / guildmate detection (track 59)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| IsInGroup | https://warcraft.wiki.gg/wiki/API_IsInGroup | HOME vs INSTANCE categories | §7.2 co-play group gate |
| GetNumGroupMembers | https://warcraft.wiki.gg/wiki/API_GetNumGroupMembers | Count including self; category defaults | Corroborate “am I grouped?” |
| partyCategoryType | https://addonstudio.org/wiki/WoW:API_TYPE_partyCategoryType | HOME/INSTANCE definitions | Dual-group BG vs dungeon clarity |
| GROUP_ROSTER_UPDATE | https://warcraft.wiki.gg/wiki/GROUP_ROSTER_UPDATE | Roster form/join/leave | Debounced guildmate-set recompute |
| GetGuildInfo | https://warcraft.wiki.gg/wiki/API_GetGuildInfo | Unit guild string | Proximity-limited — don’t use alone |
| GetGuildRosterInfo | https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo | Roster `Name-Realm` / offline rows | Name-normalize fallback (track 16) |
| IsInInstance | https://warcraft.wiki.gg/wiki/API_IsInInstance | `party`/`raid`/`pvp` gate | Qualifying instance buckets only |
| PLAYER_REGEN_DISABLED | https://warcraft.wiki.gg/wiki/PLAYER_REGEN_DISABLED | Enter combat | Sticky anti-AFK for instance credit |

---

## L. Hardcore / Doomhowl edges (track 60)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Rules of Engagement — Classic Hardcore | https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft | Permadeath, Mak’gora, dungeon lockouts, anti-boost | Scoring-surface bible for any future HC port — not V1 |
| Wowhead — TBC Anniversary roadmap | https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap | Dreamscythe vs Doomhowl/Soulseeker paths | Brand vs live-guild check; independent ladders |
| Anniversary HC transfer close | https://www.warcrafttavern.com/wow-classic/news/anniversary-transfers-for-hardcore-and-classic-era-close-january-12th/ | Jan 2026 transfer window | No TBC Hardcore; stayers remain Classic HC |
| HC addons allowed | https://us.forums.blizzard.com/en/wow/t/no-addons/1658472 | AddOns OK on HC | Failure mode = wrong folder, not a ban |

---

## M. Streamer mode & privacy (track 61)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Console variables | https://warcraft.wiki.gg/wiki/Console_variables | CVar scope / SetCVar | Streamer-alt checklist; don’t invent privacy CVars |
| AdvancedInterfaceOptions cvars.lua | https://github.com/Stanzilla/AdvancedInterfaceOptions/blob/master/cvars.lua | Maps Social/Names CVars to tooltips | Which CVars are “real” options |
| Ignore | https://wowpedia.fandom.com/wiki/Ignore | Ignore suppresses guild chat | “Ignored officer → missed promote” failure mode |
| StreamerMode (CurseForge) | https://www.curseforge.com/wow/addons/streamermode | Name/BattleTag obfuscator | Coexistence: does **not** mask Beef frames |
| UnitName | https://wowpedia.fandom.com/wiki/API_UnitName | Lua always sees real names | Obfuscation is display-only |

---

## N. Patch-day / Interface bump (track 62)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| UI FAQ — AddOns (Patch Day) | https://warcraft.wiki.gg/wiki/UI_FAQ/AddOns | Load Outdated OK; don’t hand-edit TOC | Guild-comms doctrine on bump day |
| Patch 2.5.6 / API changes | https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes | Anniversary TOC `20506` + Kaivax notes | Model: read patch page + smoke |
| Getting the current Interface number | https://warcraft.wiki.gg/wiki/Getting_the_current_interface_number | GetBuildInfo folklore | Canonical support ask: `/dump select(4, GetBuildInfo())` |
| Kaivax — UI Updates in Classic | https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408 | Shared modern UI code; addon breakage risk | Treat UI-sync patches as hotfix-risk |
| CurseForge — create/submit project | https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project | Supported Version / Release file fields | Listing “Unsupported” vs actually broken |
| toc-interface-updater | https://github.com/p3lim/toc-interface-updater | CI PR signal for Interface moves | Detect ≠ auto-ship to guild |

---

## O. CLEU / social scoring signals (track 63)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| COMBAT_LOG_EVENT | https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT | CLEU payload / Classic range notes | **V1 does not** score from CLEU |
| CombatLogGetCurrentEventInfo | https://warcraft.wiki.gg/wiki/API_CombatLogGetCurrentEventInfo | Post-8.0 getter pattern | If anyone prototypes CLEU, use getter — never ship for standing |
| CLEU range decreased (Kaivax) | https://us.forums.blizzard.com/en/wow/t/in-game-combat-log-range-decreased/370390 | ~50 yd outdoor CLEU radius | No open-world CLEU social credit |

Prefer coarse events in **§K** (`GROUP_ROSTER_UPDATE`, `PLAYER_REGEN_DISABLED`) over combat-log parsers.

---

## P. Fresh / low-level fairness (track 64)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| EPGPWeb — system help | http://www.epgpweb.com/help/system | Decay / Base GP / Min EP priming | Steal decay framing; **avoid** Min EP on Fresh→Cooked |
| EPGP (Wowpedia) | https://wowpedia.fandom.com/wiki/EPGP | Worked examples + newcomer converge | Anti-pattern for early Beef ranks |
| Classic officers — how did you DKP | https://us.forums.blizzard.com/en/wow/t/how-did-you-dkp/1645502 | Caps, trials, alt/bench practice | Catch-up needs design, not raw lifetime standing |
| Honor system (Classic) | https://wowpedia.fandom.com/wiki/Honor_system_(Classic) | HK only vs non-gray targets | Precedent for level-banded *credit*, not Beef weights |
| Leaderboard UX pattern | https://ui-patterns.com/patterns/leaderboard | Absolute boards demotivate rookies | Title buckets + My Standing over global sort |

---

## Q. Debug dumps & privacy (track 65)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| BugSack | https://github.com/funkydude/BugSack | Session errors + copy/paste stack | Preferred share unit (with BugGrabber) |
| MACRO chatlog | https://warcraft.wiki.gg/wiki/MACRO_chatlog | `/chatlog` → `WoWChatLog.txt` | **Do not solicit** chatlogs for Beef bugs |
| LoggingChat | https://warcraft.wiki.gg/wiki/API_LoggingChat | Toggles chat file logging | Beef must never enable |
| WeakAuras bug template | https://github.com/WeakAuras/WeakAuras2/blob/main/.github/ISSUE_TEMPLATE/bug_report.yml | BugSack first; SV only if needed | Escalate privately — not default Discord ask |

---

## R. Edit Mode / modernized Classic coexistence (track 66)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| PTR notes — BCC Anniversary | https://us.forums.blizzard.com/en/wow/t/the-burning-crusade-classic-anniversary-ptr-development-notes/2201610 | Edit Mode committed as UI QoL | Timeline anchor — not a Jul-2026 surprise |
| Kaivax — UI Updates in Classic | https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408 | Shared-code doctrine; Edit Mode raid knobs | Coexistence assumptions (also §N) |
| EU — Built-in Edit Mode pain | https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446 | ElvUI/MoveAnything conflict; chat clamps | Keep `/beef` independent; don’t parent to chat/bars |
| Edit Mode Expanded | https://www.curseforge.com/wow/addons/edit-mode-expanded | Third-party Edit Mode bridge | Opt-in only — not a V1 hard dep |
| EME — Authors library usage | https://github.com/teelolws/EditModeExpanded/wiki/Authors:-Library-Usage | `RegisterFrame` cost model | V2 soft-dep reference only |

Blizzard Watch modernization piece already listed in **§D**.

---

## S. Offline suggestion sync & BeefNet catalog (tracks 67–68)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| RegisterAddonMessagePrefix | https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix | Prefix must register before delivery | `COB` register-before-receive |
| CHAT_MSG_ADDON | https://warcraft.wiki.gg/wiki/CHAT_MSG_ADDON | Receive tuple / sender string | Filter `COB` + `GUILD`; Officer+ gate on sender |
| ChatThrottleLib (wiki.gg) | https://warcraft.wiki.gg/wiki/ChatThrottleLib | NORMAL vs BULK priorities | Map commits vs sync chunks |
| RCLC Synchronizer | https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer | Consent, union vs overwrite, BULK CTL | Shape for **V1.1** suggestion catch-up only |
| Attune | https://www.curseforge.com/wow/addons/attune | Survey reaches online peers only | Same offline-blank failure mode as §16.5 |
| Guild Roster Manager | https://www.curseforge.com/wow/addons/guild-roster-manager | Timestamp sync; personal-log split | Don’t sync officer attention logs |
| Exponential backoff + jitter | https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter | Full jitter > aligned retries | `SYNC_REQUEST` retry discipline (values in track 47) |
| AceComm-3.0 API | https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0 | Optional multi-frame helper | **Not** a license for multi-KB logical ladder blobs |
| Classic addon-message cold login (SO) | https://stackoverflow.com/questions/62723031/wow-classic-api-event-for-addon-messages | Cold-login send failures | Settle before HELLO / `SYNC_REQUEST` |

SendAddonMessage / Classic throttle blues already in **§A** / **§C**.

---

## T. Officer tab IA (track 69)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| RCLC Voting Frame | https://rclootcouncil.com/wiki/Voting-Frame | Session → table → selection → side detail | Master–detail pending queue; avoid vote/ilvl chrome |
| RCLC Loot History | https://rclootcouncil.com/wiki/Loot-History | One row per decision + reason | Recent Actions cousin; defer filters/export |
| RCLC Classic | https://www.curseforge.com/wow/addons/rclootcouncil-classic | Classic-family distribution | Confirms Voting Frame culture on client family |
| Gargul — Rolling Items | https://github.com/papa-smurf/Gargul/wiki/Rolling-Items | List → select → Award + note | Map to pending → Approve + evidence |
| Gargul — Awarding Items | https://github.com/papa-smurf/Gargul/wiki/Awarding-Items | Confirm handoff | Nuclear actions only (also §J) |

---

## U. Desktop Lua testing (track 73)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| busted | https://github.com/lunarmodules/busted | Canonical Lua test runner | Optional migrate off homemade asserts |
| busted docs | https://lunarmodules.github.io/busted/ | describe/it, spies/stubs | Vocabulary if harness grows |
| PersoLootRoll Test.lua | https://raw.githubusercontent.com/shrugal/PersoLootRoll/master/Test.lua | Fat desktop WoW mock reference | Steal dual-path idea; don’t copy whole mock |
| leafo — Lua + GitHub Actions | https://leafo.net/guides/testing-lua-modules-with-github-actions.html | `gh-actions-lua` + luarocks recipe | Future 5.1 job for `lua tests/run.lua` |
| Introduction to Lua (Wowpedia) | https://wowpedia.fandom.com/wiki/Introduction_to_Lua | WoW = Lua 5.1 | Pin CI / avoid 5.4-only Core syntax |
| WowAddonDevGuide — publishing CI/CD | https://www.wowaddondev.guide/docs/publishing-cicd | luacheck `std = "lua51"` | Lint sibling; keep separate from packager |

---

## V. Standing breakdown / My Standing UI (track 70)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Reputation | https://warcraft.wiki.gg/wiki/Reputation | Named standing tiers + points-to-next | Vocabulary stays “standing,” not “rep” |
| GetWatchedFactionInfo | https://warcraft.wiki.gg/wiki/API_GetWatchedFactionInfo | min/max/value inside current band | Remaining-to-next-title progress model |
| Attune spotlight (Arcane Intellect) | https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/ | Personal tree = where / next / evidence | Flatten to My Standing summary + event list; survey separate |
| CEPGP Standings Tracker | https://www.curseforge.com/wow/addons/cepgp-standings-tracker | Date-ordered personal change log | History lines without CEPGP matrix |
| NN/g progress indicators | https://www.nngroup.com/articles/progress-indicators/ | Visibility of system status | Standing should move when grants apply |
| DuelBook | https://www.curseforge.com/wow/addons/duelbook | Personal rivalry W/L lines | Gora history cousin for My Standing; not official score |

HonorSpy personal-progress glance already in **§I**; Attune CurseForge listing already in **§S**.

---

## W. Ceremony / Gora mechanics (track 71)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| AcceptDuel | https://warcraft.wiki.gg/wiki/API_AcceptDuel | Client duel accept API | Exists — Beef must **not** auto-call |
| StartDuel | https://wowpedia.fandom.com/wiki/API_StartDuel | Challenge a player by unit/name | World theater only; never silent `/beef` automation |
| DUEL_FINISHED | https://warcraft.wiki.gg/wiki/DUEL_FINISHED | Fired when a duel ends | Optional Record prefill; never alone writes standing |
| Dueling | https://warcraft.wiki.gg/wiki/Dueling | Consensual duel framing | Matches theatrical Gora (no ladder stakes from client) |
| UI Add-On Development Policy | https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534 | No playing the game for the user | Human click for score rites |
| Immersion | https://www.curseforge.com/wow/addons/immersion | Skip-friendly immersion chrome | Ceremony stub time budget — out of the way when not wanted |
| Guild Raid Attendance | https://www.curseforge.com/wow/addons/guild-raid-attendance | Admin attendance editor + save gate | Close/Record cousin; avoid EPGP/CSV product scope |

Gargul Award / confirm density already in **§J** / **§T**. HC Mak’gora naming stays in **§L** / track 60.

---

## X. Guild-chat announce API (track 72)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| SendChatMessage (Wowpedia) | https://wowpedia.fandom.com/wiki/API_SendChatMessage | Signature; 255 truncate; HW table | V1 spectacle = `"GUILD"`; no MessageQueue for `/g` |
| C_ChatInfo.SendChatMessage | https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendChatMessage | Modern mirror; HasRestrictions | Prefer if Anniversary dumps show `C_ChatInfo` live |
| SendChatMessage (AddOn Studio) | https://addonstudio.org/wiki/WoW:API_SendChatMessage | 255 max; 10+ msgs → high RTT | Pace announces; malformed links disconnect lore |
| DBM — Classic chat restriction | https://twitter.com/deadlybossmods/status/1176685822223011842 | CHANNEL + outdoor SAY/YELL blocked; guild OK | Citation: GUILD permitted from addon code |
| MessageQueue | https://github.com/LenweSaralonde/MessageQueue | HW queue for SAY/YELL/CHANNEL | Proof V1 does **not** need it for guild announce |
| GuildControlGetRankFlags | https://wowpedia.fandom.com/wiki/API_GuildControlGetRankFlags | guildchat_speak vs officer flags | Officer+ index ≠ speak; warn if announce no-ops |
| IsInGuild | https://warcraft.wiki.gg/wiki/API_IsInGuild | Guild membership guard | Guard before send; empty-state when not in guild |
| Gargul — Announcing Loot | https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat | Authority client posts; peers don’t echo | Approving officer announces; single-announcer pattern |
| RCL — Options (announce) | https://rclootcouncil.com/wiki/Options | ML award announce; consideration fanout | Steal ownership; avoid per-item consideration spam |

CTL pacing already in **§B** / **§S**; Ignore receive-side already in **§M**.

---

## Quick “start here” shortlist (10)

If you only open ten URLs before coding UI/Net:

1. https://warcraft.wiki.gg/wiki/TOC_format  
2. https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage  
3. https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting  
4. https://www.wowace.com/projects/chatthrottlelib  
5. https://www.wowace.com/projects/libdbicon-1-0  
6. https://www.wowace.com/projects/ace3/pages/getting-started  
7. https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371  
8. https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/  
9. https://tukui.org/elvui  
10. https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons  

Plus the local design spec (always).

For fill-wave UI/Net work, also prefer: FauxScroll HOWTO (§I), StaticPopup howto (§J), IsInGroup + GROUP_ROSTER_UPDATE (§K), BugSack (§Q), RCLC Voting Frame (§T), Reputation + GetWatchedFactionInfo (§V), SendChatMessage GUILD (§X).

---

## Maintenance

- When a track doc cites a durable new primary source, add one row here with a Beef-specific “steal/adapt” note.
- Do not duplicate long excerpts; link out and keep annotations to one or two lines.
- Mark Retail/Midnight-only sources explicitly so they are not mistaken for Anniversary APIs.
- Prefer track `annotated-urls.md` files for deep corpora; keep this list curated (high-value primaries only).
- Track **74** is glossary-only (repo links) — no primary URL pull expected unless it grows a corpus.
