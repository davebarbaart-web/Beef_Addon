# 00b — Community threads digest (primary sources)

**Scope:** Reddit, WoWInterface, Blizzard UI/Classic forums, Cursor forum/HN, and public Discord/recruitment hubs.  
**Date gathered:** 2026-07-26  
**Purpose:** Mine *player/dev complaints and praise* that should shape Church of Beef (CoB) polish + Cursor agent workflow — not invent product law. Spec / `Data/Ranks.lua` still win.

**Method notes**

- Parallel Search + Deep Research (`trun_91f36069f0964480ba9835bc8ae40f06`) + domain-scoped Reddit/WoWI/Blizzard queries.
- Raw search dumps live beside this file as `_search-community-*.json` / `_deep-community-threads.json` (gitignored research noise if desired).
- Some retail toast threads still apply as *UX psychology*; CoB targets Anniversary `20506` and must not import Retail-only APIs.
- Discord “FAQs” are rarely crawlable as single pages; treat **Wowhead Discord index**, **Legacy-WoW Discord lists**, and **Recruitment & Community NA/OC** invites as the public stand-ins.

---

## Executive read (for CoB)

1. **Minimap icons are guilt by association.** Players run collector addons because authors keep dumping buttons. Hide-by-default + LibDBIcon/LDB + clear tooltip beats “another ring icon.”
2. **Toasts that block clicks or combat vision get nuked.** Position, mute-by-type, coalesce, no center-screen modality.
3. **Guild spectacle ≠ trade spam.** Recruitment moved to Discord / server hubs; in-game chat spam is remembered as early-Classic waste. Promote rarity > cadence.
4. **Social rank is a *desired* tooltip signal** — funny or meaningful titles get praise when glanceable.
5. **Cursor rules work when tiny, tiered, and verified outside the prompt.** Always-on bloat and “ask before git” text alone both fail; loops need stop conditions + harnesses.

---

## Theme A — Classic / addon UI polish (toast + minimap)

### A1. Minimap clutter (complaint → library pattern)

| # | Source | Signal |
|---|--------|--------|
| 1 | [Minimap cluttered addon help — Blizzard Classic](https://us.forums.blizzard.com/en/wow/t/minimap-cluttered-addon-help/304044) (2019) | Classic player: buttons “filling the minimap… very cluttered”; asks for a cleaner. |
| 2 | [r/WowUI — tidy minimap buttons](https://www.reddit.com/r/WowUI/comments/8akcqf/help_how_do_i_tidy_up_these_minimap_buttons/) | Community recommends MBB / Minimap Button Frame; slash-config per addon. |
| 3 | [r/wownoob — Minimap Button Frame](https://www.reddit.com/r/wownoob/comments/ph0ims/minimap_button_frame_or_similar_addon) | Explicit want: keep Blizzard buttons, hide *addon* button clutter. |
| 4 | [r/wow — gather minimap buttons](https://www.reddit.com/r/wow/comments/yhjj13/is_there_any_addon_which_would_gather_all_the) | Long-time MBB users hunting replacements; ElvUI users expect ecosystem fit. |
| 5 | [WoWI — Creating minimap button via LibDBIcon](https://www.wowinterface.com/forums/showthread.php?t=57681) | Author struggle wiring LibDBIcon for Classic — library path is the accepted answer. |
| 6 | [WoWI — LibDBIcon … how to hide?](https://www.wowinterface.com/forums/showthread.php?t=57893) | Canonical Ace/LDB pattern: `db.minimap.hide` + `icon:Hide/Show`. |
| 7 | [WoWI — Simple LibDBIcon example](https://www.wowinterface.com/forums/showthread.php?t=59832) | Review thread: tooltip lines for L/R click; persist hide; OptionalDeps; collectors need LDB. |
| 8 | [Blizzard UI — How to add minimap button](https://us.forums.blizzard.com/en/wow/t/how-to-add-a-button-to-the-minimap/367416) | Fizzlemizz points authors to LibDBIcon (WoWI), not custom MiniMapCluster hacks. |
| 9 | [WoWI archive — How to add a Minimap Button](https://www.wowinterface.com/forums/showthread.php?t=54315) | Older custom-button pain (size/border mismatch) — why libraries won. |
| 10 | [LibDBIcon-1.0 (CurseForge)](https://www.curseforge.com/wow/addons/libdbicon-1-0) | De-facto standard lightweight icon. |
| 11 | [Minimap Button Frame (Legacy-WoW)](https://legacy-wow.com/wotlk-addons/minimap-button-frame) | “Gather … into a movable frame” — player praise for *one* toggle. |
| 12 | [High Ground — Best UI addons](https://www.highgroundgaming.com/wow-best-ui-addons) | Still recommends Minimap Button Button / collectors for icon soup. |

**So what for CoB**

- Ship minimap as **opt-in or easily hideable**; register via LibDBIcon/LDB so collectors work.
- Tooltip must document clicks (open `/beef`, standing glance) — WoWI examples treat this as table stakes.
- Do **not** invent a unique MiniMapCluster button that collectors miss.

### A2. Toast / alert annoyance (complaint → mute + move)

| # | Source | Signal |
|---|--------|--------|
| 13 | [Blizzard — Loot/Achievement Toast annoying](https://us.forums.blizzard.com/en/wow/t/lootachievement-toast-window-is-annoying/2205396) | Toast blocks spells mid-combat on guild achieve / delayed loot; wants move/remove. |
| 14 | [Blizzard — WoW Toasts Popup](https://us.forums.blizzard.com/en/wow/t/wow-toasts-popup/1985768) | Players share Options → search “Toast” disable path; Edit Mode omission called out. |
| 15 | [r/WowUI — remove toast notifications](https://www.reddit.com/r/WowUI/comments/zirjaq/help_how_to_remove_toast_notifications/) | Social toasts (friend login etc.) called “small annoying problem.” |
| 16 | [r/wow — disable those popups](https://www.reddit.com/r/wow/comments/1dm5mu6/how_do_i_disable_those_popups/) | Praise for **LS: Toasts** — relocate + filter what shows. |
| 17 | [r/WowUI — Move/Clickthrough/Disable Event Toast](https://www.reddit.com/r/WowUI/comments/1em27i9/addon_moveclickthroughdisable_event_toast) | Center-screen objective toast: “blocking vision” + “blocking clicks”; disable for haters. |
| 18 | [LS: Toasts — WoWI](https://www.wowinterface.com/downloads/info24123-lsToasts.html) | Popular replacement; per-type glow disable; **guild achievement spam** workarounds historically needed; FAQ: can’t half-enable Blizzard system. |
| 19 | [r/CompetitiveWoW — BigWigs vs DBM](https://www.reddit.com/r/CompetitiveWoW/comments/1qgjun0/bigwigs_vs_dbm_midnight) | Baseline expectation: recolor, filter, custom sounds **per timer**. |
| 20 | [Wago — Disable Update Notifications (ElvUI)](https://wago.io/ed1qUMO1o) | Players build WA/ElvUI toggles specifically to kill update nags. |
| 21 | [r/classicwowtbc — essential addons list](https://www.reddit.com/r/classicwowtbc/comments/nhd85b/a_list_of_the_essential_addons_and_weak_auras_for) | Dense default loadout (ElvUI/WA/BW/DBM/…) — new chrome is hostile by default. |
| 22 | [Blizzard — Classic addons vs TBC client](https://us.forums.blizzard.com/en/wow/t/classic-add-ons-will-not-work-in-tbc-at-launch/2226636) | Separate install / reinstall reality for Classic flavors. |
| 23 | [Blizzard — Addon blocked from Blizzard-only action](https://us.forums.blizzard.com/en/wow/t/addon-has-been-blocked-from-an-action-only-available-to-the-blizzard-ui/1394590) | Taint/secure action backlash is a community flashpoint. |

**So what for CoB**

- Celebration toast: **off-axis, non-modal, click-through**, never center-combat.
- Settings: per-event mute (promote / commit / sync / spectacle), position, sound on/off, coalesce bursts.
- Prefer **rare guild-chat spectacle** for promotions over frequent toast spam (unit tests can’t prove spectacle — checklist does).
- Never confuse “announce” with protected guild-rank mutation.

---

## Theme B — Cursor agent autonomy / loops / rules / skills

| # | Source | Signal |
|---|--------|--------|
| 24 | [r/cursor — rules that actually worked](https://www.reddit.com/r/cursor/comments/1r6bfdh/i_spent_way_too_long_figuring_out_cursor_rules/) | Giant single rules file gets ignored; **tier** always-on (tiny) / glob-auto / agent-requested; stale rules worse than none. |
| 25 | [r/cursor — are rules a must-have?](https://www.reddit.com/r/cursor/comments/1l2h3ra/are_cursor_rules_a_musthave_in_your_workflow) | Practitioners: rules “SERIOUSLY improve”; modular `base` + domain files. |
| 26 | [r/cursor — structure .cursorrules](https://www.reddit.com/r/cursor/comments/1iq2grw/how_do_you_structure_your_cursorrules) | `base.mdc` + frontend/backend/security as guardrails not laws. |
| 27 | [r/cursor — golden rule](https://www.reddit.com/r/cursor/comments/1ju63ig/the_one_golden_cursor_rule_that_improved) | “Fix cause not symptom” repeatedly cited as high leverage. |
| 28 | [r/ClaudeCode — rules that actually work (5 evolutions)](https://www.reddit.com/r/ClaudeCode/comments/1onxvpf/my_journey_in_building_rules_that_actually_work/) | Verbosity kills compliance; tiered bootstrap; recursive “be careful” → loop chaos; measure compliance. |
| 29 | [Cursor Forum — Rules f(project) skills f(agent)](https://forum.cursor.com/t/rules-f-project-skills-f-agent/148212) | Rules = coding standards; Skills = how to do a task; AGENTS.md = portable overview; new chat per feature. |
| 30 | [Cursor Forum — Agent-decided rules vs skills](https://forum.cursor.com/t/agent-decided-rules-vs-skills/149087) | Always-apply eats context; agent-requested often silent; skills = frontmatter cheap + slash-activate; chained workflows beat GPT on long todos. |
| 31 | [Cursor Forum — compliance verification / auto-critique](https://forum.cursor.com/t/native-agent-compliance-verification-auto-critique-loops/146556) | “Compliance drift”; manual verify script + second pass works; want native draft→verify→fix. |
| 32 | [r/cursor — repeating endless loops](https://www.reddit.com/r/cursor/comments/1qh4tbf/agent_recently_getting_thrown_into_repeating/) | Same fix applied forever when unmonitored; token burn. |
| 33 | [r/cursor — loop spent $2000](https://www.reddit.com/r/cursor/comments/1szupca/agent_got_stuck_in_a_loop_and_spent_over_2000_in/) | Unattended hard-problem agent + no stop condition = catastrophic spend. |
| 34 | [Cursor Forum — endless loop past review](https://forum.cursor.com/t/cursor-agent-enters-endless-loop-without-progressing-past-review-step/126815) | Agent repeats review message; does not self-correct. |
| 35 | [Cursor Forum — Loop engineering / orchestration](https://forum.cursor.com/t/loop-engineering-and-agent-orchestration-in-cursor/164283) | Community interest in orchestrator + triage + autoreview skills; wake loops. |
| 36 | [r/cursor — autonomous issue→PR?](https://www.reddit.com/r/cursor/comments/1u0jyc8/is_anyone_actually_running_coding_agents/) | Real question: verify assignment, permissions, checks before merge. |
| 37 | [r/cursor — 5 small workflow changes](https://www.reddit.com/r/cursor/comments/1rynskx/after_months_with_ai_coding_agents_these_5_small/) | Persist prefs in rules / AGENTS.md once. |
| 38 | [HN — force-push despite ask-permission rules](https://news.ycombinator.com/item?id=46728766) | Rules are prompts; agent rationalized `--force-with-lease --no-verify`. |
| 39 | [Cursor Docs — Rules](https://cursor.com/docs/rules) | Official: globs, alwaysApply, AGENTS.md for plain md. |
| 40 | [Cursor Blog — agent best practices](https://cursor.com/blog/agent-best-practices) | Plan Mode; **revert and re-plan** > nudge-forward. |
| 41 | [Cursor Blog — governing autonomy / Auto-review](https://cursor.com/blog/agent-autonomy-auto-review) | Product direction: externalize autonomy gates. |

**So what for CoB (agent side)**

- Keep always-on rules **tiny** (architecture + verification); put UI/net deep guidance in glob or skill.
- Skills for install/reload/playtest loops; slash-activate for polish passes.
- Hard stop: `lua tests/run.lua` exit 0, TOC truth, no WTF wipe — outside the model’s “I promise.”
- Never unattended agent on ambiguous polish without spend/iteration caps.
- Prefer new chat / plan file when context saturates (community: compliance drifts mid-thread).

---

## Theme C — Guild recruitment / social progression UX

| # | Source | Signal |
|---|--------|--------|
| 42 | [r/classicwow — tips for guild recruiting](https://www.reddit.com/r/classicwow/comments/19ds8mq/tips_for_guild_recruiting/) | Best channel: starter zones, help + bags — **presence**, not macro spam. |
| 43 | [r/classicwow — where is recruitment spam?](https://www.reddit.com/r/classicwow/comments/refkjt/where_is_the_constant_guild_recruitment_spam_of/) | Trade spam died; SoM/TBC → **server Discord recruit channels**. |
| 44 | [r/classicwow — best way find Anniversary guild](https://www.reddit.com/r/classicwow/comments/1ldfvyr/best_way_to_actualy_find_an_active_guild_on) | Server Discords + semi-guild PuGs as onboarding path. |
| 45 | [r/classicwow — where to recruit members](https://www.reddit.com/r/classicwow/comments/1s63uk3/where_to_recruit_guild_members/) | Warcraft Logs / structured LFG profiles praised over chat spam. |
| 46 | [r/wow — how to find a guild](https://www.reddit.com/r/wow/comments/1fbtdro/how_to_find_a_guild/) | NA/EU recruitment Discords + r/wowguilds; more hoops → more mythic-skewed. |
| 47 | [r/wow — where do people find guilds now](https://www.reddit.com/r/wow/comments/1k1zomz/where_do_people_find_guilds_now) | Reddit, raider.io, Discord, WowProgress, Logs — not Guild Finder. |
| 48 | [r/wow — how do you find these guilds](https://www.reddit.com/r/wow/comments/1628gyv/how_do_you_find_one_of_these_guilds/) | Clarify raid-log vs social vs serious; Discord filters win. |
| 49 | [Blizzard — How to recruit for a guild](https://us.forums.blizzard.com/en/wow/t/how-to-recruit-for-a-guild/2247348) | New GMs struggle; advice requested (process pain is real). |
| 50 | [Blizzard — How do I find Classic guilds?](https://us.forums.blizzard.com/en/wow/t/how-do-i-find-classic-guilds/2167787) | Classic players lost in retail-dominated recruitment boards. |
| 51 | [Blizzard — ClassicRaids destination](https://us.forums.blizzard.com/en/wow/t/the-destination-for-guild-recruitment-classicraids/234965) | External site for Classic guild apply — community fills Blizzard gap. |
| 52 | [EU Classic Guild Recruitment category](https://eu.forums.blizzard.com/en/wow/c/wow-classic/wow-classic-guild-recruitment/250) | Live TBC Anniversary posts: schedule, faction, tone (“relaxed”, “semi-hardcore”) as primary UX. |
| 53 | [US Recruitment hub](https://us.forums.blizzard.com/en/wow/c/recruitment/43) | Progress + raid times dominate successful posts. |
| 54 | [r/WowUI — addon that shows guild rank](https://www.reddit.com/r/WowUI/comments/1qqh7y6/addon_looking_for_addon_that_tells_about_rank_in/) | Players *want* funny/meaningful ranks on tooltip when replacing ElvUI. |
| 55 | [r/CompetitiveWoW — toxic raiding guilds](https://www.reddit.com/r/CompetitiveWoW/comments/g28q3f/toxic_raiding_guilds) | Toxicity = berating, blanket insults — not honest critique; social UX must not amplify shame. |
| 56 | [r/wow — Discord bots for guild](https://www.reddit.com/r/wow/comments/j10r8b/guild_fresh_discord_server_looking_for_bots) | Officers want attendance / progress bots (JEEVES, Raider.IO). |
| 57 | [r/WoWRolePlay — how guilds recruit](https://www.reddit.com/r/WoWRolePlay/comments/1j7sw4x/how_did_you_find_your_guildhow_does_your_guild/) | Presence + reputation > toxic forum treadmills; Discord moderation preferred. |
| 58 | [Wowhead — Community Discord Servers](https://www.wowhead.com/discord-servers) | Canonical public index (class/server/community). |
| 59 | [Legacy-WoW — Discord list + Classic Guilds invite](https://legacy-wow.com/classic-wow-discord/) (via search index) | Public “Classic WoW Guilds” Discord called out for recruit community. |
| 60 | [Recruitment & Community NA/OC Discord invite](https://discord.com/invite/recruitment-community-na-oc-246097056958119944) | Large public recruitment hub (~40k+ members cited on invite). |
| 61 | [Raider.IO Recruitment](https://raider.io/recruitment) | Structured LFG — schedule/performance filters. |
| 62 | [WowProgress FAQ](https://www.wowprogress.com/post/114_FAQ) | Rankings/export culture; ladders are *expected* for serious groups. |

**So what for CoB**

- Ladder UX should feel like **in-guild standing + spectacle**, not a second Guild Finder or trade recruiter.
- Surface rank/title on **tooltip / standing glance / roster**, matching the “funny ranks” desire.
- Officer Commit + guild chat promote: **honest, rare, celebratory** — never berate or spam.
- Discord is where recruitment lives; if CoB ever bridges out, webhook-style officer tooling > in-game spam (V2+; keep V1 ToS-safe).
- Progressive disclosure: new members need clear “what is Beef / how do I rise” without application-form fatigue.

---

## Cross-cutting synthesis

| Domain anti-pattern | Community fix that works | CoB mapping |
|---------------------|--------------------------|-------------|
| Too many always-on UI bits | Hide + collector + settings | Minimap hide; toast mute matrix |
| Notifications block play | Move / click-through / filter by type | Toast policy in settings + coalesce |
| Agent ignores long rules | Tiered short rules + external verify | `.cursor/rules` picker + `lua tests/run.lua` |
| Agent loops / spends | Stop conditions, don’t leave ambiguous jobs unattended | Loop stop skill / spend awareness |
| Guild discovery spam | Discord + presence + clear expectations | In-guild spectacle; no `/2` culture |
| Rank invisible | Tooltip / funny titles | Ladder titles from `Data/Ranks.lua` only |

---

## 12 sharp community-derived rules (for CoB + agents)

1. **Hideable chrome first** — every new always-visible control (minimap, toast anchor) needs a one-click hide that persists.
2. **Never center-modal celebrate** — promotions must not sit on action bars or eat clicks.
3. **Mute by event type** — promote ≠ sync ≠ officer ping; separate toggles + sounds.
4. **Coalesce bursts** — one tray beat five overlapping toasts.
5. **Lib/collector-friendly minimap** — LDB/LibDBIcon + honest tooltip; assume MBB/ElvUI users.
6. **Spectacle is rare** — guild-chat celebrate for true rank crossings; don’t reintroduce trade-spam cadence.
7. **Rank is a glance signal** — title/standing readable from tooltip/minimap hover without opening full UI.
8. **No shame UX** — never frame ladder feedback as berating; toxic-guild threads show how fast social systems rot.
9. **Rules are short tiers** — always-on ≤ small contract; globs for UI/Net; skills for playtest loops.
10. **Verify outside the prompt** — green `lua tests/run.lua`, TOC file truth, no WTF deletes; text “don’t force-push” is not a guardrail.
11. **Stop the loop** — identical tool calls / review thrash → abort, re-plan; never unattended ambiguous polish.
12. **Discord is the lobby; addon is the hearth** — don’t rebuild Guild Finder; make *being in the guild* feel progressive and welcoming.

---

## Gaps (honest)

- Many Discord “FAQ” channels are invite-gated; public evidence is **invite pages + Wowhead/Legacy indexes**, not full FAQ transcripts.
- Retail toast APIs ≠ Anniversary — borrow psychology, not code.
- Deep research suggested WeakAuras-as-primary toast bus / Ace3-heavy patterns; **CoB V1 is plain `COB` modules** — treat WA as optional future bridge, not requirement.
- Interface/API numbers in external posts vary; CoB stays on intentional `20506` until bumped.

---

## Source dump path

- This digest: `docs/research/agent-polish-vision/00b-community-threads-digest.md`
- Supporting JSON: `_search-community-*.json`, `_deep-community-threads.json` in the same folder
