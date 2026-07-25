# Annotated URLs — debug dumps & player privacy

**Track:** [65-debug-dumps-privacy](README.md)  
**Last updated:** 2026-07-25  
**Purpose:** Primary citations for dump contents, chat/combat logs, BugSack sharing, and privacy redaction. Prefer these over SEO “fix Lua errors” blogs.

---

## A. BugSack / BugGrabber (share unit)

| URL | Annotation |
|-----|------------|
| https://github.com/funkydude/BugSack | Canonical source: session error list + **copy/paste** full stack; requires BugGrabber. |
| https://www.curseforge.com/wow/addons/bugsack | Distribution; confirm Classic TBC / Anniversary flavor when installing. |
| https://www.wowinterface.com/downloads/info5995-BugSack.html | Alternate host; Classic/TBC listed; same copy/paste framing. |
| https://addons.wago.io/addons/bugsack | Wago mirror; Development Tools category. |
| https://addons.wago.io/addons/buggrabber | Grabber role: captures errors; without Sack prints to chat; “useful bug reports” = Grabber+Sack. |
| https://www.curseforge.com/wow/addons/bug-grabber | CurseForge BugGrabber project for flavor downloads. |
| https://www.wowace.com/projects/bug-grabber | Notes embed mode (reduced features / no SV) — authors should not reinvent grabbers lightly. |
| https://www.reddit.com/r/classicwow/comments/1q8eg6k/some_addons_are_gonna_break_in_tbc_here_is_the/ | Player culture (2026 TBC): sack icon → copy → paste to Discord/GitHub/CurseForge. |

---

## B. Chat / combat log disk artifacts

| URL | Annotation |
|-----|------------|
| https://warcraft.wiki.gg/wiki/MACRO_chatlog | `/chatlog` → `Logs\WoWChatLog.txt` — **do not solicit** for Beef bugs. |
| https://warcraft.wiki.gg/wiki/API_LoggingChat | `LoggingChat([newState])` toggles chat file logging — Beef must never enable. Confirm Classic in-client. |
| https://wowpedia.fandom.com/wiki/MACRO_chatlog | Mirror of chatlog macro notes. |
| https://wowpedia.fandom.com/wiki/Combat_Log | `/combatlog` → `Logs\WoWCombatLog.txt`; parser ecosystem — wrong artifact for social ladder support. |
| https://www.warcraftlogs.com/help/start | Combat-log upload culture (`/combatlog`, Advanced Combat Logging) — contrast with Beef diagnostics. |
| http://fishsticks.fobby.net/wow/rp/calsh/chatlogparser.php | Historical parser UI listing **whispers/tells** among chatlog channels — proves sensitivity of `WoWChatLog.txt`. |
| https://github.com/0ldi/ChatLog | Classic-era chat logger cousin (Elephant lineage): persistent chat incl. whispers — same privacy class. |

---

## C. SavedVariables paths & dump workflows

| URL | Annotation |
|-----|------------|
| https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/concepts/saved-variables.md | Clear account vs per-character paths under `WTF\Account\...`. |
| https://github.com/TheMizeGuy/wow-addon-dev/blob/main/references/savedvariables-and-load-order.md | Path table + load-order; example SV bodies can hold name pools. |
| https://us.forums.blizzard.com/en/wow/t/anyone-know-how-saved-variables-work/1388757 | Player-facing account vs character SV locations. |
| https://rpmessner.github.io/til/wow/debugging-addons-with-savedvariables.html | Author-local workflow: dump to SV → `/reload` → read file; also points at `!BugGrabber.lua` on disk — **local**, not player Discord recipe. |
| https://www.wowinterface.com/forums/archive/index.php/t-48899.html | Account folder IDs vs character names; addons cannot see account folder names — don’t ask players to paste WTF trees. |

---

## D. `/dump`, build info, names

| URL | Annotation |
|-----|------------|
| https://warcraft.wiki.gg/wiki/World_of_Warcraft_API | Debugging section: `DevTools_Dump` ≡ `/dump`; `debugstack` / error handlers. |
| https://warcraft.wiki.gg/wiki/Getting_the_current_interface_number | Canonical support ask: `/dump select(4, GetBuildInfo())`. |
| https://wowpedia.fandom.com/wiki/API_UnitName | `/dump UnitName("player")` examples — reporter name disclosure is intentional; third parties are not. |

---

## E. Issue-template / SV escalation culture

| URL | Annotation |
|-----|------------|
| https://github.com/WeakAuras/WeakAuras2/blob/main/.github/ISSUE_TEMPLATE/bug_report.yml | Mature template: BugSack+BugGrabber first; `WeakAuras.lua` SV **only if** failing aura unknown — model for “escalate privately,” not default Beef ask. |
| https://us.forums.blizzard.com/en/wow/t/weakauras-issue/1667547 | Community: “WeakAuras recommends BugSack and BugGrabber” — stack tracing before dumping configs. |

---

## F. Product / sibling research (not duplicated)

| Path | Why linked |
|------|------------|
| [`../19-testing-debugging-qa/script-errors-bugsack.md`](../19-testing-debugging-qa/script-errors-bugsack.md) | Install + `scriptErrors` how-to (QA); 65 adds privacy of pastes. |
| [`../24-policy-tos-compliance/data-exfiltration-forbidden-apis.md`](../24-policy-tos-compliance/data-exfiltration-forbidden-apis.md) | No HTTP telemetry / minimize / sandbox — data-handling only. |
| [`../39-guild-calendar-events/beef-guild-night-instrumentation.md`](../39-guild-calendar-events/beef-guild-night-instrumentation.md) | Session metrics allow/deny (no chat text). |
| [`../48-feature-flags-rollout/README.md`](../48-feature-flags-rollout/README.md) | `COB.DEBUG` / packager strip for debug verbs. |
| [`../05-packaging-community-antipatterns/05-implications-for-church-of-beef.md`](../05-packaging-community-antipatterns/05-implications-for-church-of-beef.md) | Stream-safe defaults (no surprise alt/officer dumps). |
| [`../../../superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Spec §2 in-game; §6.3 self-report; stream spectacle. |
| [`../../../superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | `/beef debug standing` behind `COB.DEBUG`. |

---

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-bugsack-privacy.json`](.raw/search-bugsack-privacy.json) | BugSack / SV / chat-log search |
| [`.raw/search-debug-dumps.json`](.raw/search-debug-dumps.json) | Debug dump / redact search |
| [`.raw/search-wow-logs-sv.json`](.raw/search-wow-logs-sv.json) | Logs folder + SV path search |
| [`.raw/search-chatlog-paths.json`](.raw/search-chatlog-paths.json) | Chat/combat log path search |
| [`.raw/search-error-pii.json`](.raw/search-error-pii.json) | BugGrabber SV / name-leak search |
| [`.raw/search-issue-templates.json`](.raw/search-issue-templates.json) | Author bug-template search |
| [`.raw/search-dump-api.json`](.raw/search-dump-api.json) | `/dump` / UnitName search |
| [`.raw/extract-macro-chatlog.json`](.raw/extract-macro-chatlog.json) | MACRO chatlog extract |
| [`.raw/extract-wa-bug-template.json`](.raw/extract-wa-bug-template.json) | WeakAuras issue template extract |
| [`.raw/extract-sv-debug-til.json`](.raw/extract-sv-debug-til.json) | SV debug TIL extract |
| [`.raw/extract-reddit-bugsack.json`](.raw/extract-reddit-bugsack.json) | r/classicwow BugSack culture extract |

Prefer annotated links above when citing outside this folder.
