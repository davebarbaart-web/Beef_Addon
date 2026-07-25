# Chat logs, combat logs, and WTF disk artifacts

**Track:** [65-debug-dumps-privacy](README.md)  
**Last updated:** 2026-07-25  
**Purpose:** Map on-disk player artifacts that look like “debug evidence” but are privacy bombs — and what Beef support should ask for instead.

---

## 1. Blizzard chat log (`/chatlog`)

| Fact | Source |
|------|--------|
| Toggle | `/chatlog` macro |
| Output file | `World of Warcraft\Logs\WoWChatLog.txt` (under the client tree; Classic flavors use their `_classic_*` install root) |
| API | `LoggingChat([newState])` gets/sets logging to that file ([API_LoggingChat](https://warcraft.wiki.gg/wiki/API_LoggingChat) — confirm Classic availability in-client) |

**Privacy:** Chat logs routinely include **guild, party/raid, say/yell, and whispers** depending on what the player’s chat filters show. Historical community tools even expose checkboxes for “Tells/whispers” when parsing `WoWChatLog.txt` ([Calsh chat log parser](http://fishsticks.fobby.net/wow/rp/calsh/chatlogparser.php)). That is private correspondence among guildmates — not a ladder bug report.

**Beef policy:** Never call `LoggingChat(true)`. Never instruct testers to attach `WoWChatLog.txt` for Church of Beef issues. If spectacle timing is in question, use the officer **manual** “got a reaction?” checkbox from [39](../39-guild-calendar-events/beef-guild-night-instrumentation.md), not a chat scrape.

---

## 2. Combat log (`/combatlog`)

| Fact | Source |
|------|--------|
| Toggle | `/combatlog` |
| Output | `Logs\WoWCombatLog.txt` |
| Ecosystem use | Upload to parsers ([Warcraft Logs getting started](https://www.warcraftlogs.com/help/start); [Combat Log wiki](https://wowpedia.fandom.com/wiki/Combat_Log)) |

Combat logs are dense with **player names, pets, abilities, and fight context**. They are the right artifact for raid analysis and the wrong artifact for a social rank addon.

**Beef policy:** Do not request combat logs. Do not auto-enable combat logging. (DBM/Loggerhead-style auto-log is a raid-tool pattern — out of product class.)

---

## 3. Addon chat loggers (Elephant / ChatLog cousins)

Third-party chat log addons persist more lines than Blizzard’s chat frame, often including per-channel enable toggles and copy/paste of history ([0ldi/ChatLog README](https://github.com/0ldi/ChatLog) — Vanilla-era fork documenting whisper/guild capture and disk save). Same privacy class as `WoWChatLog.txt`.

**Beef policy:** Do not depend on them. Do not ask officers to paste Elephant/ChatLog exports into public bug threads.

---

## 4. SavedVariables on disk (WTF)

| Scope | Typical path |
|-------|----------------|
| Account-wide | `WTF\Account\<AccountFolder>\SavedVariables\<Addon>.lua` |
| Per-character | `WTF\Account\<AccountFolder>\<Realm>\<Character>\SavedVariables\<Addon>.lua` |

Documented across [SavedVariables concept notes](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/concepts/saved-variables.md), [Blizzard forums](https://us.forums.blizzard.com/en/wow/t/anyone-know-how-saved-variables-work/1388757), and [dev references](https://github.com/TheMizeGuy/wow-addon-dev/blob/main/references/savedvariables-and-load-order.md).

**Privacy hazards in paths and files:**

- `<AccountFolder>` is often a **numeric Battle.net-era id**, not the character name ([WoWInterface archive discussion](https://www.wowinterface.com/forums/archive/index.php/t-48899.html)).
- Per-character files sit under **realm + character** folder names.
- File bodies can hold **guild caches, standing maps, UI profiles, and error archives** (e.g. BugGrabber DB).

Author-side workflow of dumping debug tables into a dedicated SV then reading the file after `/reload` is a **local** technique ([Debugging WoW Addons with SavedVariables](https://rpmessner.github.io/til/wow/debugging-addons-with-savedvariables.html)) — fine on the author’s machine; not a player support recipe that ends in Discord attachments.

**Beef policy:** Prefer in-game curated dumps ([debug-dump-allow-deny.md](debug-dump-allow-deny.md)). If an alpha volunteer must send `ChurchOfBeefDB` for a migration bug, send **privately**, strip unrelated keys, and never commit player SV into the repo.

---

## 5. BugGrabber / BugSack on disk

| Artifact | Role |
|----------|------|
| `WTF\...\SavedVariables\!BugGrabber.lua` (name varies by package) | Persisted error objects (message + stack) when save-to-file is enabled |
| BugSack UI copy buffer | Session viewer → clipboard |

Errors are captured for reporting ([BugGrabber Wago blurb](https://addons.wago.io/addons/buggrabber); [BugSack](https://github.com/funkydude/BugSack)). The **SV file** is a multi-addon archive; the **one-stack copy** is the share unit. See [bugsack-safe-sharing.md](bugsack-safe-sharing.md).

---

## 6. What to ask for instead (support matrix)

| Symptom | Ask for | Do not ask for |
|---------|---------|----------------|
| Lua error / broken `/beef` | BugSack copy of **one** stack + addon version + `GetBuildInfo` dump | Full `!BugGrabber.lua`, ElvUI SV |
| Ladder / sync wrong | Curated `/beef` status dump + repro | Full `ChurchOfBeefDB`, roster CSV |
| “Announce felt silent” | Officer night-report social-check boolean + online count | `WoWChatLog.txt` |
| FPS / hitch | Profile notes from [54](../54-memory-fps-budgets/) | Combat log |
| Suspected ToS/exfiltration worry | Point at [24](../24-policy-tos-compliance/) data-handling — Beef does not HTTP | N/A |

---

## 7. Data-handling bridge to track 24

Track 24 already states: combat/chat log files on disk are **player-owned**; external upload tools are separate apps; Lua has no general networking ([data-exfiltration-forbidden-apis.md](../24-policy-tos-compliance/data-exfiltration-forbidden-apis.md)). This track adds the **support hygiene** rule: Church of Beef maintainers will not *solicit* those files as a normal bug-report input, because social content (whispers, officer chat) is out of proportion to ladder defects.
