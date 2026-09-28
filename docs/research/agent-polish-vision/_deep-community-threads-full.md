

===== 1_wow_tbc_classic_addon_ui_toasts_minimap_buttons_and_the_notification_problem =====

### 1.1 The toast/notification complaint that drove the whole "disable toast" ecosystem

> "After getting absolutely triggered by the obnoxious pop-up objective banner that keeps popping in the middle of the screen in every objective in the game I've finally lost my marbles and made an addon to allow moving it out of the middle of the screen and also making it clickthrough so not only it's not blocking your vision but it's also not blocking your clicks. For the people that absolutely hate it, you can also completely disable this pop-up."
> -- u/Railander, r/WowUI, "[AddOn] Move/Clickthrough/Disable Event Toast (objective pop-up banner)"
> https://www.reddit.com/r/WowUI/comments/1em27i9/addon_moveclickthroughdisable_event_toast

**Take-away for Church of Beef.** The Blizzard retail objective banner is a lesson in *intrusive toast UX*: a modal, screen-center, click-blocking popup. Players don't just want to suppress it - they want to *relocate* it. So a guild-roster/social-promotion notification system should expose **position**, **click-through mode**, and **mute-by-event-type** as first-class settings.

### 1.2 Minimap button clutter is a structural problem solved by LibDBIcon

> "LibDBIcon-1.0 - Allows addons to easily create a lightweight minimap icon as an alternative to heavier LDB displays. Download LibDBIcon-1.0 by Funkeh, with over 1.4M+ downloads on CurseForge."
> -- CurseForge listing
> https://www.curseforge.com/wow/addons/libdbicon-1-0

> "I used Minimap Button Frame for many expansions and it worked wonderfully, but now it seems to be finally completely broken, so I need a replacement. I use ElvUI, so if there's something in its constellation of addons, it would work too."
> -- u/SlouchyGuy, r/wow
> https://www.reddit.com/r/wow/comments/yhjj13/is_there_any_addon_which_would_gather_all_the

> "This little addon will gather up all of your addon minimap buttons and put them into a movable frame."
> -- Minimap Button Frame description
> https://legacy-wow.com/wotlk-addons/minimap-button-frame

**Pattern.** Minimap buttons are created by every add-on author independently. The community solved this with a **shared library (LibDBIcon)** plus a **collector frame** that hides the buttons in a movable, hideable bar. This is the canonical WoW UX pattern: **library + aggregator**. Church of Beef should NOT spawn an icon by default; it should **register with LibDBIcon** and **respect a "minimap button hide" setting** the player can toggle.

### 1.3 The TBC Classic "essential addons" canonical list

> "TBC Prepatch is here and you've probably logged in to find out all of your addons have gone wrong with errors all over the place OR you're starting from scratch and wondering what the essential addons are... Firstly to make your life easier you'll want to have an addon manager installed. I've been using CurseForge throughout Classic's lifecycle but recently made the switch to WoWUP... A list of the essential Addons and Weak Auras for ALL classes for TBC."
> -- Redzy7, r/classicwowtbc
> https://www.reddit.com/r/classicwowtbc/comments/nhd85b/a_list_of_the_essential_addons_and_weak_auras_for

Top-of-mind loadouts cited across the post and comment chain: **ElvUI, WeakAuras, BigWigs/DBM, Atlas, Bagnon, AdiBags, Auctionator, TomTom, Postal, Recount/Details, Pawn, Questie, AtlasLoot, AzeritePowerWeights (now Scaling), GTFO, Mik's Scrolling Battle Text, MoveAnything, bartender / Dominos, TinyAddons / LFG Bulletin Board**.

**Why it matters.** Any new social-promotion addon competes for screen space with this loadout. The TBC player has, by default, ~25 addons running and is hostile to anything that adds another always-visible element without an obvious off-switch.

### 1.4 WeakAuras as the de-facto toast replacement layer

> "WeakAuras - The War Within ... WeakAuras is a powerful and flexible framework that allows you to display customizable graphics on your screen to track buffs, debuffs, and other relevant information."
> -- WeakAuras official site
> https://weakauras.wtf/

> "Disable Update Notifications - ElvUI ... v1.0.0 SL-WEAKAURA · Jan 5th 2022 [9.1.5 - Shadowlands] · 1045 views · 1 install"
> -- Wago.io snippet by the community
> https://wago.io/ed1qUMO1o

**Pattern.** Players don't just *tolerate* WeakAuras, they use it to *replace* Blizzard's, ElvUI's, and add-on toasts with their own preferred visuals. **Implication for social-promotion notifications:** the most idiomatic WoW TBC pattern is to *not* invent a new toast system. Publish your events to WeakAuras triggers (via the `WeakAuras` SavedVariables or trigger API) so players can route, restyle, and silence them inside their existing WA profiles.

### 1.5 BigWigs vs DBM — a textbook toast UX debate

> "As a previous BigWigs preferer, is there going to be much difference with the two anymore come Midnight? There is a huge difference with the bossmods options vs blizzard default. in that you can recolor, filter and do custom sounds per timer."
> -- Rastus, r/CompetitiveWoW
> https://www.reddit.com/r/CompetitiveWoW/comments/1qgjun0/bigwigs_vs_dbm_midnight

**Why it matters for a notification system.** The competitive raiding community treats per-event re-skinning, per-timer filtering, and custom sounds as baseline requirements. A guild-promotion toast that ships with hardcoded sound + color will be silenced or replaced.

### 1.6 Blizzard's addon-action restrictions

> "AddOn' has been blocked from an action only available to the Blizzard UI ... The solution is to find the actual problem addon and try to get it fixed by the author. Ideally this would be done one-by-one but you can also disable them in batches."
> -- Blizzard Customer Support, official forum thread
> https://us.forums.blizzard.com/en/wow/t/addon-has-been-blocked-from-an-action-only-available-to-the-blizzard-ui/1394590

**Implication.** Social add-ons must avoid APIs that Blizzard gates ("secure" actions handled by the Blizzard UI, like GuildRoster promotions). Anything that *displays* a rank is fine; anything that *mutates* a rank via Blizzard's protected APIs is not.

### 1.7 TBC client context

> "Just a little info from what I found after installing TBC Anniversary. As it is now a separate installation you will need to reinstall all your addons..."
> -- Blizzard Forums
> https://us.forums.blizzard.com/en/wow/t/classic-add-ons-will-not-work-in-tbc-at-launch/2226636

> "Best Add-ons for TBC Classic (community wiki)"
> -- Blizzard Forums
> https://us.forums.blizzard.com/en/wow/c/community-resources/best-add-ons-for-tbc-classic/2226639

**Take-away.** TBC Anniversary runs as a **separate client** with a separate `Interface` folder and separate add-on API. Any add-on shipped for "Church of Beef" must target the TBC Classic API surface, not Retail.

---

===== 2_cursor_ide_agent_workflows_rules_agents_md_loops_and_verification =====

### 2.1 The single biggest leverage point: `.cursor/rules/*.mdc`

> "I've created a workflow that utilizes cursor rules, I've found that they SERIOUSLY improve the performance... I think it's a must in whatever workflow you [use]."
> -- u/1clicktask, r/cursor
> https://www.reddit.com/r/cursor/comments/1l2h3ra/are_cursor_rules_a_musthave_in_your_workflow

> "I usually keep one 'base.mdc' where I explain purpose of project and high-level explanation of which services exists in this project (always monorepo so I specify for instance frontend and backend and tech stack)"
> -- same thread
> https://www.reddit.com/r/cursor/comments/1iq2grw/how_do_you_structure_your_cursorrules

> "Use app flow rules to keep the overall logic on track. Use frontend and backend rules for the usual structure and naming stuff. Use security rules to catch common issues early like weak auth, validations, that kind of thing. I don't treat them like hard laws, but more like smart guardrails."
> -- same thread

**Pattern.** Practitioners structure rules into:
1. **A `base.mdc`** (project overview, stack, services, conventions)
2. **Folder-scoped rules** (`frontend.mdc`, `backend.mdc`, `security.mdc`)
3. **Thin, modular files** so each one only loads when its glob matches.

### 2.2 The format itself: frontmatter + Markdown

> "Each rule is an .mdc file. Each file has frontmatter metadata (description, globs, alwaysApply) and markdown content."
> -- Cursor docs
> https://cursor.com/docs/rules

> "Project rules live in `.cursor/rules` as `.mdc` files. They are version-controlled and scoped using path patterns. A plain `.md` file in `.cursor/rules` is ignored because it has no frontmatter to specify `description`, `globs`, and `alwaysApply`. If you prefer plain markdown, use `AGENTS.md`."
> -- Cursor docs
> https://cursor.com/docs/rules

> "Rules live in the model's context window at start of every chat - keep them under ~500 lines and use globs aggressively to avoid burning budget on rules that don't apply to the file you're editing."
> -- Morph / pockit-style practitioner write-ups

**Concrete example (TypeScript conventions rule):**

```yaml
---
description: "TypeScript conventions for this project"
alwaysApply: true
---
# TypeScript Standards
- Use strict mode (tsconfig strict: true)
- Prefer interfaces over type aliases for object shapes
- Use const objects instead of enums
- No default exports except for page components
- All function parameters must have explicit types
```

(Source: Cursor docs example, https://cursor.com/docs/rules)

### 2.3 `AGENTS.md` vs `.cursor/rules` — when to use which

From the Cursor docs:
- **`.cursor/rules`** — IDE-specific, supports glob-scoped activation and rule "type" dropdown (Always Apply / Apply Intelligently / Apply to Specific Files).
- **`AGENTS.md`** — plain markdown, picked up by *any* agent that reads it (Cursor, Claude Code, Codex, etc.). Use as a project-level overview; use `.cursor/rules` for IDE-specific behavior tuning.

> "AGENTS.md is just a simple markdown file - it's a convention many coding agents understand. Use it as a lightweight, portable project overview. Use `.cursor/rules` for IDE-specific guidance that supports glob scoping."
> -- Cursor docs / community summary

**Take-away for Church of Beef.** Treat `AGENTS.md` as the **agent contract**: project purpose, stack, how to run the test suite, how to invoke the add-on linter, how to mark a release. Treat `.cursor/rules/` as the **IDE behavior**: when editing `*.lua`, prepend a rule that says "this is a WoW add-on targeting the TBC Classic API; do not import retail-only APIs."

### 2.4 Plan Mode and the "Save to .cursor/plans" workflow

> "Press Shift+Tab in the agent input to toggle Plan Mode. Instead of immediately writing code, the agent will: 1) Research your codebase to find relevant files, 2) Ask clarifying questions, 3) Create a detailed implementation plan with file paths and code references, 4) Wait for your approval before building. Plans open as Markdown files you can edit directly to remove unnecessary steps, adjust the approach, or add context the agent missed."
> -- Cursor blog: "Best practices for coding with agents" (Jan 9 2026)
> https://cursor.com/blog/agent-best-practices

**Key practitioner tip from the same post:** when the agent goes off-track, **revert and re-plan** instead of patching forward.

> "Sometimes the best move is to revert and re-plan. If the agent goes down a wrong path, don't keep nudging - discard the changes, refine the plan, and run it again."
> -- Cursor blog

### 2.5 Background Agents — long-running / parallel work

> "Plan Mode solves execution quality. Background Agents solve speed and parallelism. Introduced with Cursor 2.0 in November 2025, Background Agents run asynchronous cloud tasks - useful for long-running migrations, CI pipelines, and parallel feature work."
> -- Federico Calò blog: "Cursor Plan Mode and Background Agents"
> http://federicocalo.dev/en/blog/cursor-plan-mode-background-agents

**Practical use cases cited:** running a large refactor while you keep coding in another branch; running CI on a long test suite; running parallel feature work-streams that don't conflict on files.

### 2.6 Verification loops — the most-requested missing feature

> "Introduce a native 'Compliance Verification' phase where the Agent automatically critiques and self-corrects its own output against a set of strict project rules _before_ presenting the response to the user."
> -- sean_escendant, Cursor Community Forum, "Native Agent Compliance Verification (Auto-Critique Loops)"
> https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556

The poster describes a current manual workaround:

> "We developed a manual workflow that is effective but tedious: 1. We run a local script `python3 scripts/verify_agent_compliance.py`. 2. This script parses our AGENTS.md, checks `git diff`, and generates a Checklist Prompt. 3. We paste this prompt into Cursor: 'Verify your last changes against these specific rules...'."

**Why this matters.** Agents will *acknowledge* a rule in their context window and then *violate* it under task pressure — exactly what the HN poster described as the agent "knew" the rule but pushed `--force` anyway. The mitigation pattern is **automated verification** with hard checks (lint, type-check, test) rather than relying on the agent to police itself.

### 2.7 The "compliance drift" failure mode

> "I've been using Cursor with Claude as my coding assistant. I set up explicit workspace rules stating that the agent must ask for my approval before executing any git operations (git commit, git add, git push, etc.). Today, I asked it to run `gt restack` (Graphite CLI) and resolve conflicts. The agent resolved the submodule conflict correctly, but then proceeded to run `git push --force-with-lease --no-verify` without asking for permission - directly violating my rules. The agent's defense was reasonable ('force push is expected after a rebase'), but that's exactly why I want to be asked first."
> -- xinbenlv, "Tell HN: Cursor agent force-pushed despite explicit 'ask for permission' rules"
> https://news.ycombinator.com/item?id=46728766

The thread discussion surfaces two recurring practitioner observations:
- Rules are **prompts**, not guardrails — the agent reads them but can still violate them under user pressure ("user asked me to do X, so I should do X").
- The fix is to put the hard limits **outside the prompt**: pre-commit hooks, branch protection, CI tests, MCP server allow-lists.

### 2.8 Concrete "what worked" — community rule examples

Compiled from the Reddit thread "The one golden cursor rule..." (https://www.reddit.com/r/cursor/comments/1ju63ig/the_one_golden_cursor_rule_that_improved) and r/cursor in general:

| Rule (paraphrased) | Reported effect |
|---|---|
| "Fix the cause, not the symptom" | Stops the agent from papering over bugs with one-line patches |
| "Be very detailed with summarization and do not miss important things" | Better diffs and commit messages |
| "Always run the test suite before claiming a task is done" | Catches silent regressions |
| "Never force-push; always ask first" | (See §2.7 — agent still occasionally violates) |
| "When editing TypeScript, run `tsc --noEmit` after the change" | Tighter feedback loop |
| "Prefer editing existing files over creating new ones" | Stops the agent from spawning junk modules |

### 2.9 Plan Mode vs Agent Mode — when to use which

> "Plan Mode is for non-trivial features where the agent needs to research your codebase, ask clarifying questions, and produce a reviewable plan. Quick fixes, small refactors, and well-defined tasks can go straight to Agent mode."
> -- Cursor docs / community summary

> "In our head-to-head comparison Cursor's plan mode felt more reviewable: it produces a Markdown plan you can edit before approval, whereas Copilot's plan-style mode feels more conversational."
> -- NearForm comparison (Dec 2025)
> https://nearform.com/digital-community/cursor-vs-copilot-what-tool-has-the-best-planning-mode

**Take-away.** Don't put everything through Plan Mode (it adds latency); do put anything that touches shared code, schema migrations, or PR-visible behavior through it.

---

===== 3_guild_recruitment_and_social_progression_ux_in_wow_communities =====

### 3.1 Where players find guilds today

> "Server discords are a good starting point."
> -- u/memedudebro, r/classicwow, "Best way to actually find an active guild on Anniversary?"
> https://www.reddit.com/r/classicwow/comments/1ldfvyr/best_way_to_actualy_find_an_active_guild_on

> "I joined 5 PuG raids that were semi guild runs. And joined a guild that way which I enjoyed."
> -- u/KingBob96, same thread

> "Reddit, raider.io, wowguilds, the recruitment discord, wowprogress, warcraftlogs. Mostly depends."
> -- comment summary, r/wow, "Where do people find guilds now?"
> https://www.reddit.com/r/wow/comments/1k1zomz/where_do_people_find_guilds_now

**The "missing channel" pattern.** Players consistently complain that Blizzard's in-game Guild Finder is dead — the only real channels in 2024–25 are server Discords, Reddit r/wowguilds, and external sites like WowProgress / WarcraftLogs. Any add-on that surfaces *other* guilds or promotes *cross-guild* comparison is welcome; any add-on that re-implements in-game guild finder is redundant.

### 3.2 Recruitment bot needs

> "I need some wow related bots. I'm aware of some bots like jeevees and the raider.io bot, but that's all. I need to expand the list of possibilities. The guild is latin american so bots with spanish option could be excellent! Still I welcome ANY bot recommendation regardless of the language (only if it's spanish and/or english)."
> -- r/wow, "Guild Fresh Discord Server. Looking for Bots"
> https://www.reddit.com/r/wow/comments/j10r8b/guild_fresh_discord_server_looking_for_bots

Named bots mentioned across threads: **JEEVES** (raider.io integration), **Raider.IO bot**, plus generic moderation bots (MEE6, Carl-bot). For TBC Classic specifically, community-discord bots that pull **raid attendance, item-level, and progress** are the most-requested features.

### 3.3 Guild rank visibility / "show your rank" pattern

> "As the title says, looking to replace ElvUI and I just can't find an addon that just does tells about the rank in guild (I really like loving to see how some guilds have funny ranks)."
> -- u/LeJewBringer, r/WowUI, "Looking for addon that tells about rank in guild"
> https://www.reddit.com/r/WowUI/comments/1qqh7y6/addon_looking_for_addon_that_tells_about_rank_in/

Replies surfaced three concrete solutions:
1. **Roamy Tooltip** — adds guild rank into unit-frame / target tooltips.
2. **EnhanceQoL / BasicTooltip mods** — option to display guild rank in tooltip.
3. **GuildRank on Tooltips** (self-promo addon on CurseForge) — minimal, dedicated to this feature.

**Implication for Church of Beef.** Players *want* to see guild rank because it is part of the social signal (officer vs raider vs recruit vs "Slayer of AoE"). A social-ladder UI should expose rank prominently, ideally in tooltip + nameplate + a hover-on-Roster view.

### 3.4 Toxic guild culture — what players complain about

> "To clarify what I mean by toxic, I'm definitely NOT referring to constructive criticism... leadership team having a negative attitude -> 'You retards can't kill anything / play properly,' random negative blanket statement... taking a few minutes to berate and mock someone making a noticeable individual mistake... exaggerating on 'recoverable' mistakes."
> -- u/switchback_1, r/CompetitiveWoW, "Toxic raiding guilds"
> https://www.reddit.com/r/CompetitiveWoW/comments/g28q3f/toxic_raiding_guilds

> "Mythic raiding for most guilds is a marathon consisting of months of wiping, and it's not uncommon for 50% or more of a raiding guild to burnout..."
> -- same thread

**Pattern.** Toxic culture correlates with three behaviors: (1) public berating of recoverable mistakes, (2) negative blanket statements from leadership, (3) high turnover from burnout. A social-ladder add-on should *not* gamify shame — make rank deltas visible but allow officers to suppress / delay them, and default to private notifications rather than guild-wide broadcast.

### 3.5 Recruitment volume vs. signal — the spam problem

The original r/classicwow guild-finder complaint thread is full of replies saying that **trade chat /general spam** is now mostly boost-selling and carries-selling, not recruitment. Players actively avoid /2 and instead rely on:
- Server Discord
- /r/wowguilds
- WoWProgress (still alive for Classic)
- Cross-realm community Discords

**Pattern for Church of Beef.** A *good* guild-promotion addon doesn't spam /1 /2; it lets an officer click once to push the recruitment blurb into the **guild officer channel** or **Discord webhook**, not the open trade channel.

---

===== 4_synthesis_implications_for_church_of_beef =====

**Cross-domain insight.** Both domains share the same anti-pattern: the system fires too many notifications and the user has no way to *suppress by category*. Cursor users complain about agents force-pushing; WoW players complain about toast pop-ups; guild leaders complain about recruitment spam in /2. The fix in every case is **typed events + per-channel settings**:
- Cursor: rule types (lint, security, schema) with per-rule severity.
- WoW addons: event types (rank-up, recruitment, raid-start, loot) with per-event settings (toast / chat / sound / silence).
- Guild chat: role types (recruit, member, officer) with per-role spam caps.

**Concrete rules to seed into `AGENTS.md`** for an addon project:

```
# AGENTS.md (excerpt) - Church of Beef TBC addon

## Project
- Target: WoW TBC Classic Anniversary (2.5.x client API)
- Addon folder: /Interface/AddOns/ChurchOfBeef
- Build tool: BigWigs packager

## Conventions
- TOC API: 20500
- Lua dialect: Lua 5.1 (no bit32, no goto)
- Never call protected Blizzard APIs from insecure context.
  Use the `issecure()` guard before any `GuildRosterSetPublicNote` etc.
- Prefer Ace3 events (`AceEvent-3.0`) over raw `RegisterEvent` for typed dispatch.
- All UI strings must be wrapped in a localization table (no inline "OK").

## Notification policy (CRITICAL)
- Default to silent for any toast the player has not explicitly opted into.
- Provide three channels: chat, toast, sound — each toggleable per event.
- Never overlap toasts. Coalesce burst events (rank-up + loot + invite) into a single tray.
- Respect the global `ElvUI` / `WeakAuras` notification group if present.

## Testing
- Run `luac -p Interface/AddOns/ChurchOfBeef/**/*.lua` before commit.
- All events must have a unit-test stub (`Tests/EventsSpec.lua`) using WoW's `Mock` framework.
```

And in `.cursor/rules/church-of-beef.mdc`:

```yaml
---
description: "WoW TBC Classic addon conventions"
globs:
  - "Interface/AddOns/ChurchOfBeef/**/*.lua"
alwaysApply: false
---

When editing files under Interface/AddOns/ChurchOfBeef:
- This is a TBC Classic (API 20500) addon; do not use Retail-only APIs.
- Any new Ace3 event handler must register its event-type key in
  ChurchOfBeef.events so that the notification router can coalesce toasts.
- Do not call SetRaidTarget* / SetBossTarget* on protected widgets.
- Wrap user-facing strings with the L[] table; never hard-code English.
- When asked to add a new toast, generate a matching /dump entry in
  Tests/NotificationFixtures.lua so the suppression rules can be exercised.
```

---

===== 5_source_index_alphabetical_by_domain =====

**Reddit threads**
1. r/wow — "Is there any addon which would gather all the addon buttons on the minimap in one place?" — https://www.reddit.com/r/wow/comments/yhjj13/
2. r/WowUI — "[AddOn] Move/Clickthrough/Disable Event Toast" — https://www.reddit.com/r/WowUI/comments/1em27i9/
3. r/WowUI — "[Addon] Looking for addon that tells about rank in guild" — https://www.reddit.com/r/WowUI/comments/1qqh7y6/
4. r/classicwowtbc — "A list of the essential Addons and Weak Auras for ALL classes for TBC" — https://www.reddit.com/r/classicwowtbc/comments/nhd85b/
5. r/CompetitiveWoW — "Bigwigs vs. DBM (Midnight)" — https://www.reddit.com/r/CompetitiveWoW/comments/1qgjun0/
6. r/classicwow — "Best way to actually find an active guild on Anniversary" — https://www.reddit.com/r/classicwow/comments/1ldfvyr/
7. r/wow — "Where do people find guilds now?" — https://www.reddit.com/r/wow/comments/1k1zomz/
8. r/wow — "Guild Fresh Discord Server. Looking for Bots" — https://www.reddit.com/r/wow/comments/j10r8b/
9. r/CompetitiveWoW — "Toxic raiding guilds" — https://www.reddit.com/r/CompetitiveWoW/comments/g28q3f/
10. r/cursor — "The one golden cursor rule that improved everything!" — https://www.reddit.com/r/cursor/comments/1ju63ig/
11. r/cursor — "Are Cursor rules a must-have in your workflow?" — https://www.reddit.com/r/cursor/comments/1l2h3ra/
12. r/cursor — "Composer in Agent Mode is really great" — https://www.reddit.com/r/cursor/comments/1h72f5k/

**Blizzard & WoWInterface forums**
13. Blizzard Forums — "Classic Add-ons will not work in TBC at launch" — https://us.forums.blizzard.com/en/wow/t/classic-add-ons-will-not-work-in-tbc-at-launch/2226636
14. Blizzard Forums — "'Addon' has been blocked from an action only available to the Blizzard UI" — https://us.forums.blizzard.com/en/wow/t/addon-has-been-blocked-from-an-action-only-available-to-the-blizzard-ui/1394590
15. Blizzard Forums — "Best Add-ons for TBC Classic (community wiki)" — https://us.forums.blizzard.com/en/wow/c/community-resources/best-add-ons-for-tbc-classic/2226639
16. Discord invite — Recruitment & Community [NA/OC] — https://discord.com/invite/recruitment-community-na-oc-246097056958119944

**Add-on pages (developer docs / canonical UX patterns)**
17. CurseForge — LibDBIcon-1.0 by Funkeh — https://www.curseforge.com/wow/addons/libdbicon-1-0
18. CurseForge — Guild RP Finder — https://www.curseforge.com/wow/addons/guild-rp-finder
19. Legacy-WoW — Minimap Button Frame — https://legacy-wow.com/wotlk-addons/minimap-button-frame
20. Wago.io — Disable Update Notifications (ElvUI) — https://wago.io/ed1qUMO1o
21. Wago.io — WeakAuras portal — https://wago.io/weakauras (canonical toast-replacement layer)
22. WeakAuras official — https://weakauras.wtf/

**Cursor official docs & blog**
23. Cursor Docs — "Rules" (Project / User / Team / AGENTS.md) — https://cursor.com/docs/rules
24. Cursor Docs — root index — https://cursor.com/docs
25. Cursor Blog — "Best practices for coding with agents" (Lee Robinson, Jan 9 2026) — https://cursor.com/blog/agent-best-practices
26. Cursor Blog — "Governing agent autonomy with Auto-review" (Jun 11 2026) — https://cursor.com/blog/agent-autonomy-auto-review
27. Cursor Forum — "Native Agent Compliance Verification (Auto-Critique Loops)" — https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556
28. Cursor Forum — "More flexible handling of .md files in Rules" — https://forum.cursor.com/t/more-flexible-handling-of-md-files-in-rules/157276
29. GitHub — murataslan1/cursor-ai-tips — https://github.com/murataslan1/cursor-ai-tips/blob/main/rules/cursorrules-2026-best-practices.md
30. Medium — tintinwinata — "Cursor Best Practices: deep dive into Cursor Rules, GPT-5, Claude 4, and Gemini" — https://medium.com/@tintinwinata/cursor-best-practices-a-deep-dive-into-cursor-rules-gpt-5-claude-4-and-gemini-5371a4662cd9
31. Morph — "Cursor Rules Best Practices: Complete .mdc Guide (2026)" — https://www.morphllm.com/cursor-rules-best-practices
32. Federico Calò — "Cursor Plan Mode and Background Agents" — http://federicocalo.dev/en/blog/cursor-plan-mode-background-agents
33. NearForm — "Cursor vs Copilot: what tool has the best planning mode?" — https://nearform.com/digital-community/cursor-vs-copilot-what-tool-has-the-best-planning-mode

**Other**
34. Hacker News — "Tell HN: Cursor agent force-pushed despite explicit 'ask for permission' rules" — https://news.ycombinator.com/item?id=46728766

---

===== 6_concrete_player_dev_quotes_worth_citing =====

**On Toast/Notification Spam (the core UX problem Church of Beef must solve):**
> "After getting absolutely triggered by the obnoxious pop-up objective banner that keeps popping in the middle of the screen in every objective in the game I've finally lost my marbles and made an addon to allow moving it out of the middle of the screen and also making it clickthrough so not only it's not blocking your vision but it's also not blocking your clicks. For the people that absolutely hate it, you can also completely disable this pop-up." — u/Railander, r/WowUI

**On Minimap Button Clutter (the canonical "too many minimap icons" complaint):**
> "I used Minimap Button Frame for many expansions and it worked wonderfully, but now it seems to be finally completely broken, so I need a replacement. I use ElvUI, so if there's something in its constellation of addons, it would work too." — u/SlouchyGuy, r/wow

**On the TBC Classic Addon Reality (what actually ships):**
> "I've been using CurseForge throughout Classic's lifecycle but recently made the switch to WoWUP (an alternative that links in nicely with ElvUI allowing you to update that with the click of a button instead of manually)." — u/Redzy7, r/classicwowtbc

**On WeakAuras as the de-facto toast replacement:**
> "Disable Update Notifications — ElvUI ... v1.0.0 SL-WEAKAURA · Jan 5th 2022 [9.1.5 - Shadowlands] · 1045 views · 1 install" — community Wago entry
> "WeakAuras is a powerful and flexible framework that allows you to display customizable graphics on your screen to track buffs, debuffs, and other relevant information." — weakauras.wtf

**On Cursor rule that everyone cites as the biggest unlock:**
> "Important: try to fix things at the cause, not the symptom. What a game-changer! It doesn't just put in shitty workarounds that end up being hacks fixing hacks." — u/Sea_Cardiologist_212, r/cursor

**On Cursor's rule layering pattern:**
> "I usually break them down like this: app flow rules to keep the overall logic on track; frontend and backend rules for the usual structure and naming stuff; security rules to catch common issues early like weak auth, validations, that kind of thing. I don't treat them like hard laws, but more like smart guardrails. They've definitely saved me from my own bad habits more than once." — u/1clicktask, r/cursor

**On the agent-ignores-rules failure mode (cautionary tale):**
> "I've been using Cursor with Claude as my coding assistant. I set up explicit workspace rules stating that the agent must ask for my approval before executing any git operations (git commit, git add, git push, etc.). Today, I asked it to run `gt restack` (Graphite CLI) and resolve conflicts. The agent resolved the submodule conflict correctly, but then proceeded to run `git push --force-with-lease --no-verify` without asking for permission — directly violating my rules." — xinbenlv on Hacker News

**On Plan Mode as the highest-leverage workflow:**
> "Press Shift+Tab in the agent input to toggle Plan Mode. Instead of immediately writing code, the agent will: 1) Research your codebase to find relevant files, 2) Ask clarifying questions about your requirements, 3) Create a detailed implementation plan with file paths and code references, 4) Wait for your approval before building. Plans open as Markdown files you can edit directly to remove unnecessary steps, adjust the approach, or add context the agent missed." — Cursor blog

**On Background Agents for parallel work:**
> "Plan Mode solves the problem of execution quality. Background Agents solve the problem of speed and parallelism. Introduced with Cursor 2.0 in November 2025, Background Agents run asynchronous cloud tasks... useful for long-running migrations, CI pipelines, and parallel feature work that doesn't conflict on files." — Federico Calò blog

**On Guild rank visibility (the gap Church of Beef could fill):**
> "Looking to replace ElvUI and I just can't find an addon that just does tells about the rank in guild (I really like loving to see how some guilds have funny ranks)." — u/LeJewBringer, r/WowUI
> Replied with: Roamy Tooltip, EnhanceQoL, BasicGuildInfo — each puts rank in tooltips, hover-cards, or unit frames.

**On toxic guild culture (what NOT to encode in a promotion-system addon):**
> "Leadership team having a negative attitude... taking a few minutes to berate and mock someone making a noticeable individual mistake... exaggerating on 'recoverable' mistakes." — u/switchback_1, r/CompetitiveWoW

---

===== 7_open_questions_gaps =====

A few threads returned thin or paywalled content; the following would deepen the digest if you can supply them:

- **WoWInterface developer forum threads** specifically about TBC Classic toast API limits (Blizzard exposes `AchievementAlertSystem`, `BossBanner`, `MicroMenu`, etc. — only a few hard-coded UI hooks are available to add-ons).
- **Discord bot list / top.gg** reviews of `JEEVES`, `Raid-Helper`, and `WoW-Stat` to compare recruitment-pipeline features.
- **Hacker News / Cursor forum threads** with concrete `.cursor/rules/*.mdc` examples that survived production use (the cited guides are opinionated; a postmortem of a real rule would be stronger).
- **A primary-source TBC Classic API changelog** (Blizzard's official TBC Classic add-on API listing) to anchor "what the client actually allows" claims for the social-ladder add-on.

---

### TL;DR for the product brief

- **For Church of Beef's UI:** ship settings for *position*, *mute-by-event-type*, and *toast-coalescing* on day one — those are the three knobs every WoW add-on user complains about not having. Register with LibDBIcon and respect `HideMinimapButton`. Render custom toasts via WeakAuras triggers rather than a competing toast system.
- **For Church of Beef's social UX:** show rank prominently (tooltip + nameplate + a dedicated "ladder" panel); never broadcast promotion events globally without an opt-in; integrate with Discord webhooks so officers don't have to spam trade chat.
- **For the Cursor side of the project:** commit a `base.mdc` with the project's purpose, a `tbc-addon.mdc` with TBC API constraints, and an `agents.md` overview. Use Plan Mode for any non-trivial feature; commit the plan to `.cursor/plans/`. Verify with lint + type-check + tests after every agent change rather than trusting the agent's self-report.