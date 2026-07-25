# Track 65 — Debug dumps, logging, and player privacy

**Track id:** `65-debug-dumps-privacy`  
**Last updated:** 2026-07-25  
**Sole focus:** What `/beef debug`-style dumps should and should not include; chat/combat log vs BugSack traces; character names and identifiers; how Classic authors share stacks safely; Church of Beef privacy policy for diagnostics.  
**Out of scope:** QA process, alpha channels, combat-lockdown checklists, and BugSack *install/how-to* (track [19](../19-testing-debugging-qa/) — cite only for privacy depth); Blizzard ToS/EULA automation and monetization (track [24](../24-policy-tos-compliance/) — cite only for data-handling overlap); BeefNet wire budgets ([14](../14-addon-messaging-beefnet/)); SV migration mechanics ([21](../21-savedvariables-migration/)). No addon code or commits in this folder.

## Product truth (from V1 spec + plan)

| Locked stance | Source |
|---------------|--------|
| Fully in-game; no external controller / phone-home | Design spec §2 |
| Per-character `ChurchOfBeefDB` | Design spec §3.1 / §9 |
| Stream-friendly spectacle (officer-opt-out announces) | Design spec §8 / §10 |
| Dev `/beef debug …` behind `COB.DEBUG` (default false); harden/strip before release | Plan Task 8; track [48](../48-feature-flags-rollout/) |
| Standing is self-reported; officer approve is anti-cheat | Design spec §6.3 |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md); [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md).

## Index

| Note | Covers |
|------|--------|
| [debug-dump-allow-deny.md](debug-dump-allow-deny.md) | Allow / deny lists for `/beef debug` (and cousins like night-report dumps) |
| [chat-logs-and-disk-artifacts.md](chat-logs-and-disk-artifacts.md) | `WoWChatLog.txt`, combat logs, WTF SavedVariables paths — what not to ask for |
| [names-and-identifiers.md](names-and-identifiers.md) | Character names, realms, account folder IDs, stream-safety |
| [bugsack-safe-sharing.md](bugsack-safe-sharing.md) | How Classic authors share BugSack / BugGrabber traces without oversharing |
| [beef-privacy-policy.md](beef-privacy-policy.md) | Explicit Church of Beef diagnostics & privacy policy |
| [annotated-urls.md](annotated-urls.md) | Annotated primary URLs |

## Top insights for Beef (read this first)

1. **A debug dump is a support *summary*, not a SavedVariables zip.** Useful paste: addon version, `GetBuildInfo()` / Interface, BeefNet major, `COB.DEBUG` / flag snapshot, *your* standing + pending suggestion counts, last error id/message if any. Useless or harmful paste: full `ChurchOfBeefDB`, full guild roster, officer notes, whispers, chat logs, or `!BugGrabber.lua` wholesale ([SV layout](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/concepts/saved-variables.md); [WA bug template still asks for SV only when aura-unknown](https://github.com/WeakAuras/WeakAuras2/blob/main/.github/ISSUE_TEMPLATE/bug_report.yml)).

2. **Chat logging is a different product from BugSack.** `/chatlog` writes `Logs\WoWChatLog.txt` and can capture guild, whispers, and more ([MACRO chatlog](https://warcraft.wiki.gg/wiki/MACRO_chatlog)). Beef must never enable chat logging and must never request `WoWChatLog.txt` for ladder bugs. Combat logs (`/combatlog` → `WoWCombatLog.txt`) are for parsers like [Warcraft Logs](https://www.warcraftlogs.com/help/start) — irrelevant to Church of Beef support.

3. **BugSack copy/paste of one stack is the safe default; the BugGrabber SV file is not.** Community culture: install BugGrabber+BugSack → copy one error → paste to Discord/GitHub with version + repro ([r/classicwow TBC guidance](https://www.reddit.com/r/classicwow/comments/1q8eg6k/some_addons_are_gonna_break_in_tbc_here_is_the/); [BugSack features](https://github.com/funkydude/BugSack)). Stacks may still embed names if the error string concatenated `UnitName` — redact other players before a *public* issue.

4. **Names are guild-public but Discord/GitHub-public is a different audience.** Prefer counts and roles (“3 pending Fresh→Cooked”) over dumping every member. Reporter’s own character name is usually fine; third-party names and WTF account-folder IDs are not for public pastes ([Phanx: account folder names unavailable to addons](https://www.wowinterface.com/forums/archive/index.php/t-48899.html)).

5. **Gate verbose dumps the same way you gate forge helpers.** Plan already: `/beef debug` behind `COB.DEBUG` / packager strip ([48](../48-feature-flags-rollout/)). Release builds should expose at most a short `/beef status` (version + sync health) without ladder dumps or roster tables.

6. **Data-handling stance matches track 24 minimize rule, applied to support artifacts.** No HTTP telemetry; session-scoped night metrics stay local or officer-pasteable summaries ([39 instrumentation](../39-guild-calendar-events/beef-guild-night-instrumentation.md)); diagnostics never become a side channel for harvesting the guild.

## Boundary with sibling tracks

| Topic | Lives in |
|-------|----------|
| How to enable `scriptErrors`, install BugSack, alpha channels, QA checklist | [19](../19-testing-debugging-qa/) |
| EULA data-mining, sandbox no-sockets, forbidden API classes | [24](../24-policy-tos-compliance/) `data-exfiltration-forbidden-apis.md` |
| What fields go into a guild-night metrics dump (product instrumentation) | [39](../39-guild-calendar-events/beef-guild-night-instrumentation.md) |
| Whether debug slash ships in Release | [48](../48-feature-flags-rollout/) |
| **What a dump may contain / how to share it without leaking players** | **This track** |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer warcraft.wiki.gg macros/APIs, BugSack/BugGrabber project pages, and mature author issue templates over SEO “how to fix Lua error” blogs.
