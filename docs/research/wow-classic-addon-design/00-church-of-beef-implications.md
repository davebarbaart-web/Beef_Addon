# Implications for Church of Beef (Synthesis)

**Last updated:** 2026-07-25 (post–Wave E refresh appended)  
**Lane:** Synthesis (library root)  
**Maps to:** [Church of Beef V1 design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Companion index:** [README](README.md) · [Master references](06-annotated-master-reference-list.md) · [Gap audit 56](56-coverage-gap-audit/) · tracks [01](01-ux-patterns/)–[74](74-v1-decision-glossary/)

This document turns Classic addon ecosystem research into **decisions and risks for Church of Beef**. It does not restate the full spec; it pressures the spec against how contemporary Classic addons actually behave.

---

## Top implications (executive)

1. **Stay an edge social tool, never a combat HUD.** Classic “must-have” stacks center combat info near the character; chat/minimap/guild tools stay at the edges ([UX patterns](02-ux-patterns-classic.md); [Overgear TBC Anniversary addons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons)). Beef’s ladder/toasts/minimap entry must not compete with DBM/WA/Plater center mass.

2. **Plain frames in V1 are correct; theatrical chrome is V2.** Spec §10 already allows plain Classic frames. ElvUI/clean-UI aesthetics dominate “modern Classic,” but Beef’s brand wants gothic/Scarlet pageantry later ([visual language](03-visual-language-reference.md); [Tukui ElvUI](https://tukui.org/elvui)). Ship readable defaults first; do not block V1 on media.

3. **Anniversary install trees are a real support burden.** Separate client folders mean separate `Interface/AddOns` and WTF trees ([client/TOC](01-client-flavors-and-toc.md); community Anniversary setup guides). Guild onboarding docs must say “Anniversary folder,” not “Classic Era AddOns.”

4. **`## Interface: 20506` (verify live) is non-negotiable packaging.** Wrong Interface → out-of-date / invisible in the addon list ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)). Prefer a single-flavor TOC for V1; multi-Interface / `_TBC.toc` when porting (spec §12).

5. **BeefNet on `GUILD` matches Classic policy; throttle is mandatory.** Custom CHANNEL addon messaging was killed for Classic social reasons ([Wowhead / Blizzard 1.13.3](https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371)); GUILD/PARTY/RAID/WHISPER remain valid. Prefix budgets and silent drops are real ([SendAddonMessage](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage); Classic loot-addon war stories). Prefer commits + login sync over chatty SCORE_EVENT spam; use ChatThrottleLib-style pacing ([ChatThrottleLib](https://www.wowace.com/projects/chatthrottlelib)).

6. **Revisioned login sync is the product, not a nice-to-have.** Live broadcasts only reach online peers. Spec §8.3 (revision numbers, `SYNC_REQUEST` / `SYNC_STATE`, reply-storm suppression) is exactly how guild tools survive Classic throttle culture. Treat SV as a cache of officer commits, not a server ([persistence](05-persistence-and-profiles.md)).

7. **Officer gate as anti-cheat is ecosystem-honest.** Self-reported SavedVariables are editable; Classic will not give you a trusted score server. Spec §6.3 (advisory standings, human approve) matches loot-council / attunement-survey patterns more than meters. Validate commits; do not cryptographically “prove” points.

8. **Do not pull Ace3 for V1 unless options explode.** Ace is dominant and well documented ([Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)), but plain `CreateFrame` + per-char SV matches the V1 plan. Embed LibDBIcon / ChatThrottleLib later if needed ([Ace & libs](04-ace3-and-libraries.md)).

9. **Secure/taint rules reinforce the hard “no automation” line.** Classic uses the modern secure-execution model ([Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)). Beef may suggest, announce, and record; it must never cast, target, or move. Keep UI as ordinary frames; avoid secure-template complexity.

10. **Guild-chat promotion lines are the V1 spectacle budget.** Spec success criterion §13.11 is social reaction, not chrome. One throttled plain-text announce from the approving officer (visible without the addon) is the cheapest stream-readable moment — more important than ornate frames.

---

## Spec section map

### §1–2 Purpose & hard restrictions

| Spec stance | Ecosystem implication |
|-------------|----------------------|
| Social / RP / stream theater, not raid DPS | Own an underserved niche; most “top addon” lists ignore guild culture tools ([02](02-ux-patterns-classic.md)) |
| No protected-action circumvention | Aligns with Classic secure API reality ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)) |
| Announce / track / coordinate OK | Same design space as Attune surveys, Gargul officer flows, RP directories — steal UX, not combat logic |

**Implication:** Market and TOC Notes should read as a guild institution tool, not a combat helper, to set expectations and avoid “why isn’t this WeakAuras” confusion.

### §3 V1 scope vs deferred

| In scope | Research reinforcement |
|----------|------------------------|
| Ladder, thin Gora/ceremony, instance co-play, BeefNet, basic UI | Matches “start small essential set” advice in Anniversary guides ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons)) |
| Deferred ceremonial dashboard / favor bar / deep Gora theater | Correct — V2+ can learn toast choreography from WA culture without shipping WA density in V1 ([03](03-visual-language-reference.md)) |

**Implication:** First `/beef` open must show Ladder + My Standing immediately; Officer tab gated; stubs must not dominate chrome.

### §4 Rank ladder & hybrid advancement

| Spec stance | Implication |
|-------------|-------------|
| Suggest → Officer+ approve | Officer queue UX ≈ loot council / survey pending lists ([02](02-ux-patterns-classic.md)) |
| Ranks 1–5 grindable; Council seats; unique Prophet | UI must make non-threshold ranks obvious (no fake “points to Council”) |
| Manual demotion / excommunication | High-drama officer actions deserve `confirm`-style friction ([AceConfig confirm pattern](https://www.wowace.com/projects/ace3/pages) — steal UX even without Ace) |

**Implication:** Standing breakdown for officers should be a short event list, not a Details!-style meter.

### §5–6 Architecture & authority

| Spec stance | Implication |
|-------------|-------------|
| Machine canon inside addon (`Data/Ranks.lua`) | TOC can only load addon-folder files — research confirms packaging constraint; keep `docs/canon/` prose-only |
| Roster rank-index Officer+ check | Guild rank *names* are arbitrary; index threshold is the right Classic pattern |
| Queue/drop if roster not loaded | Common Classic race: addon messages before `GUILD_ROSTER_UPDATE` |

**Implication:** Never apply unverified `RANK_COMMIT`; soft-fail is better than a forged ladder.

### §7 Scoring

| Spec stance | Implication |
|-------------|-------------|
| Instance drip + completion + anti-AFK combat | Instance-complete APIs can be flaky on Classic-era clients (open question §16.4) — design Core so completion bonus is optional |
| Caps / no open-world loops | Prevents farm meta; matches “don’t spam events” performance hygiene |
| Gora losses pay | Social design > pure ladder optimization; keeps challenge culture alive |

**Implication:** Prefer event-driven instance tracking over heavy `OnUpdate`; batch SV writes.

### §8 BeefNet

| Spec stance | Ecosystem evidence |
|-------------|-------------------|
| Prefix `COB`, channel `GUILD` | CHANNEL banned; GUILD allowed ([Wowhead](https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371)) |
| Colon-delimited small payloads | Prefer over large AceSerializer dumps for V1; Classic throttle lore shows large syncs fail intermittently ([Blizzard forums — SendAddonMessage problems](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054)) |
| Throttling | ChatThrottleLib exists to pace outbound chat/addon traffic ([WowAce](https://www.wowace.com/projects/chatthrottlelib)); wiki documents per-prefix allowances ([SendAddonMessage](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage)) |
| Login sync + revisions | Required because offline members miss broadcasts; reply-storm suppression is standard guild-sync hygiene |
| Players without addon must not soft-lock | Guild chat announce covers them; ladder features degrade gracefully |

**Implication:** Default `SCORE_EVENT` to local-first or rare; `RANK_COMMIT` / sync are the bandwidth budget.

**Retail contrast (do not copy into V1):** Midnight-era encounter messaging restrictions are a future port concern ([Midnight addon notes](https://github.com/Plaitrix/WoW-Midnight-Addon-Template/blob/main/docs-site/docs/midnight.md)), not Anniversary V1 scope — but “queue during restricted windows” is a useful mental model if Classic ever tightens further.

### §9 Persistence

| Spec stance | Implication |
|-------------|-------------|
| `SavedVariablesPerCharacter: ChurchOfBeefDB` | Matches ladder-as-character-progress culture ([05](05-persistence-and-profiles.md); [TOC SavedVariables](https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables)) |
| Alts start Fresh Beef | On-brand; document in guild README so players don’t file “bug” reports |
| No server | Officer copies + revisions are the authority story |

**Implication:** If UI prefs later need account-wide profiles, split “Church data” from “UI profile” — do not put official ladder state in a swappable cosmetic profile ([05](05-persistence-and-profiles.md)).

### §10 UI

| Spec stance | Implication |
|-------------|-------------|
| `/beef` + minimap | De facto Classic entry pattern; LibDBIcon is the coexistence-friendly button path ([04](04-ace3-and-libraries.md); [LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0)) |
| Tabs: Ladder / My Standing / Officer | Tabbed tool window (AtlasLoot/Auctionator-lite), not ElvUI installer |
| Media fallback | Required — missing fonts must not hard-error (spec) |
| Frame always created | Fixes “slash works, nothing appears” class of bugs |
| ElvUI coexistence | Unique frame name/strata; no global skinning; respect button collectors ([03](03-visual-language-reference.md)) |
| Stream readability | High-contrast text; one toast; large enough titles for 720p streams |

**Implication:** Default Blizzard UI on Anniversary is already drifting modern ([Blizzard Watch, Jul 2026](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)). “Plain Classic frames” still read as Classic-native relative to ElvUI, not as 2007 pixel-perfect nostalgia.

### §11–13 Errors, portability, success

| Spec stance | Implication |
|-------------|-------------|
| Soft-warn on BeefNet version mismatch | Prevents half-applied ladders across guild nights |
| Isolate TOC / instance / messaging for Classic+ | Correct portability seam ([01](01-client-flavors-and-toc.md)) |
| Social check: visible guild-chat reaction | Primary acceptance test; instrument announce opt-out carefully so officers don’t silence spectacle by accident |

### §16 Open questions (research nudges)

| Open question | Research nudge |
|---------------|----------------|
| Alt policy | Account SV vs doctrine — wait for guild leadership; V1 per-char is consistent with ecosystem norms for progress |
| Council seats | Product decision, not tech |
| Standing decay / Lent reset | On-brand seasonal systems; no Classic API blocker |
| Instance completion detection | Prototype early; keep bucket-only fallback |
| Suggestion queue sync | Same sync machinery as ladder; extend if officers miss messages while offline |
| Threshold tuning | Needs one real guild night — not a research library problem |

---

## What to steal vs avoid

| Steal / adapt | Avoid |
|---------------|--------|
| Slash + minimap entry | Center-screen combat overlays |
| Officer pending queues (Attune/Gargul-like) | Spreadsheet density (Auctionator/TSM) |
| Throttled guild broadcast as spectacle | High-frequency addon message spam |
| LibDBIcon / CTL when embedding | Hard `## Dependencies` that break solo load |
| Plain frames → later skin tokens | Requiring LibSharedMedia / ElvUI in V1 |
| Confirm dialogs for demote / Prophet | Auto-promote, auto-cast, auto-target |
| Revisioned state merge | “Last packet wins” without revisions |

---

## Suggested next research topics

> **Superseded as the active queue (2026-07-25).** Items 1–6 and 8 below were largely filled by tracks 13–17, 28, 39, and 51. Use the ranked gap list in [56-coverage-gap-audit/priority-next-research.md](56-coverage-gap-audit/priority-next-research.md) instead. Historical list retained for provenance:

1. **Classic Anniversary instance / dungeon-complete event matrix** — which events fire reliably on `Interface 20506` for 5-mans, raids, BGs (feeds scoring §7 and open question §16.4). → *Filled as docs in [15](15-instance-completion-events/); Anniversary in-game prototype still open.*
2. **Guild roster timing & Officer+ edge cases** — `GUILD_ROSTER_UPDATE` races, offline officers, rank-index remaps after guild reorgs. → *[16](16-guild-roster-officer-edges/).*
3. **BeefNet payload size budget** — measure practical GUILD prefix throughput with CTL; design `SYNC_STATE` chunking before the ladder grows. → *Reasoned budgets in [14](14-addon-messaging-beefnet/) / [47](47-login-storms-guild-scale/); live guild-night measure still useful.*
4. **Minimap button collector compatibility matrix** — LibDBIcon vs hand-rolled vs Addon Compartment (if present on Anniversary). → *[28](28-minimap-addon-compartment/).*
5. **Stream overlay readability pass** — font sizes, toast duration, announce copy length at 720p/1080p captures. → *[17](17-stream-overlay-readability/) / [32](32-microcopy-tone-voice/).*
6. **Closest cousin addon teardown** — Attune guild survey, Gargul officer UX, one RP directory addon: screenshot IA, not code copy. → *[13](13-cousin-addon-teardowns/).*
7. **Classic+ / future messaging restrictions watch** — track whether Anniversary inherits Retail encounter messaging clamps. → *Still a watch item; see [12](12-classic-vs-retail-philosophy/) / [14](14-addon-messaging-beefnet/).*
8. **Threshold playtest instrumentation** — what to log for one guild night to replace §4.2 placeholders. → *[51](51-guild-night-playbook/) / [39](39-guild-calendar-events/).*

---

## Wave refresh — 2026-07-25

Cross-track consensus after research waves through track **55** (gap inventory: [56](56-coverage-gap-audit/)). Does not replace the Top implications above; adds what the filled library now agrees on.

1. **V1 architecture is research-settled.** Plain frames + per-char SV + rank-index Officer+ + revisioned `GUILD` BeefNet (`COB`) + optional completion bonus is the consistent stack across 00, 04, 14, 16, 21, 27, 34, 35 — Ace3/Masque/LSM remain optional later, not load-bearing.
2. **Officer approval is the product security model.** Tracks 16, 24, 26, 27, and 40 all converge: self-reported standing is advisory testimony; validate `RANK_COMMIT` senders; audit/transparency beats cryptography for a comedy guild tool.
3. **No Classic first-class dungeon-complete event.** Track 15: ship combat-gated instance drip + BG end; treat 5-man/raid “clear” as optional/allowlisted/officer-manual until Anniversary playtest proves `ENCOUNTER_END` / `BOSS_KILL` coverage.
4. **Spectacle budget is guild chat + one toast, not chrome.** Tracks 17, 32, 49, 51: throttled officer announce visible without the addon is the §13.11 success path; stream contrast and copy length matter more than gothic art in V1.
5. **Login sync and anti-storm design are mandatory, not polish.** Tracks 14, 27, 47: delay sync after enter-world; revision ≥ ignore; single-responder suppression; CTL pacing — Classic silent drops make “blast the whole ladder” unsafe.
6. **Market white space is theatrical standing, not loot points.** Tracks 13, 26, 52: sit beside CLM/RCLC/GRM/TRP3; never market as DKP/attendance/RP profile; Council seats + unique Prophet keep the ladder from being a pure grind.
7. **Degrade hard; never soft-lock the guild.** Tracks 41, 48, 55: not-in-guild empty states, version soft-warn, missing media fallbacks, players without the addon still see chat spectacle.
8. **Largest remaining research holes are detection + list/confirm UI.** Empty shells **59** (guildmate co-play), **57** (scroll lists), **58** (StaticPopup confirms), plus finishing thin **10** and the **15** Anniversary prototype — see [priority-next-research.md](56-coverage-gap-audit/priority-next-research.md).

---

## Wave refresh — 2026-07-25 (post-fill 57–67 + 01/10)

Cross-track consensus after filling shells **57–67** and repairing thin **01 / 10** (gap inventory refresh: [56](56-coverage-gap-audit/)). Does not replace Top implications or the prior Wave refresh; adds what the fill wave newly agrees on.

1. **Co-play is a group-roster predicate, not proximity or CLEU.** Tracks **59** + **63**: iterate the active `LE_PARTY_CATEGORY_*` group, require a connected guildmate via `UnitIsInMyGuild` / roster fallback, gate drip on player combat (`PLAYER_REGEN_DISABLED`). Do not register `COMBAT_LOG_EVENT_UNFILTERED` for standing.
2. **Ladder/officer lists are fixed Lua pools in V1.** Track **57**: seven rank bands + a small suggestion row pool; add `FauxScrollFrame` only on overflow; defer Hybrid until Anniversary FrameXML is verified — matches Lua-primary **35**.
3. **High-drama officer actions need StaticPopup friction.** Track **58**: demote / Council / Prophet / wipe get named modals (`preferredIndex` hygiene); approve/reject stays label-clear without a ceremony modal.
4. **§16.5 offline suggestion sync is intentionally thin in V1.** Track **67**: local-persist + live `SUGGESTION` fanout to online Officer+; no suggestion payload inside `SYNC_STATE`; officer pull-on-login is a **V1.1** flag if playtest proves on-duty coverage fails.
5. **Fairness is the Fresh→Cooked hook, not catch-up math.** Track **64**: low-level instances count fully; no Min-EP / account inheritance; Cooked@50 remains an ops tune (**51**), not a second points economy.
6. **Anniversary Edit Mode is contested space; Beef owns Layer C only.** Track **66**: independent movable `/beef` panel + fixed toast defaults; never register with Edit Mode or anchor to Blizzard HUD widgets players rearrange.
7. **HC/Doomhowl is brand + future port, not V1 scoring code — but two rules are cheap everywhere.** Track **60**: pause grants while dead/ghost; keep “Beef Gora” lexicographically far from `/makgora`.
8. **Streamer/privacy and debug dumps are redaction problems, not spectacle blockers.** Tracks **61** + **65**: respect privacy CVars where they hide names; guild-chat announce remains the §13.11 path; `/beef debug` ships allow/deny lists so ladder caches do not paste into BugSack shares.
9. **Largest remaining library holes moved past 57–67.** Follow-ons still open: empty **70** (My Standing breakdown), thin **71** (ceremony/Gora mechanics), thin **72** (guild-chat announce pipeline). Outside shells: the **15** Anniversary playtest, **74**/spec §15 sync with fill-wave locks, and live CTL measurement. See [priority-next-research.md](56-coverage-gap-audit/priority-next-research.md).

---

## Wave refresh — 2026-07-25 (post–Wave E: 70–72 filled)

Cross-track consensus after filling follow-on shells **70–72** (gap inventory refresh: [56](56-coverage-gap-audit/)). Does not replace Top implications or prior Wave refreshes; adds what Wave E newly agrees on.

1. **My Standing is a personal story tab, not a meter dashboard.** Track **70**: text thresholds + short grant history + source chips; refuse DKP/EPGP density and castbar-style XP chrome for Task 8 (thin StatusBar optional post-playtest).
2. **Ceremony/Gora are officer-gated state machines with human clicks.** Track **71**: credit on clean close / recorded outcome only; mid-disconnect gets no auto credit; no PvP automation or V3 match theater in V1 stubs.
3. **Guild spectacle is one approving-officer `/g` line.** Track **72**: `GUILD` channel, 255-safe copy, product single-announcer + CTL shaping — N peers must not each announce on `RANK_COMMIT` replay.
4. **Desk research is closed through track 74.** Largest remaining gaps are live: **15** Anniversary encounter prototype, CTL/login-storm measure, Fresh→Cooked threshold night, brand screenshot lock. Ops entry: [`docs/phases/guild-night-playtest.md`](../../phases/guild-night-playtest.md). Do not open tracks **75+** unless a playtest contradicts [74](74-v1-decision-glossary/) / spec §15.

---

## Sources (synthesis lane)

Primary and secondary sources used for this synthesis (also curated in [06](06-annotated-master-reference-list.md)):

- [TOC format — Warcraft Wiki](https://warcraft.wiki.gg/wiki/TOC_format)
- [C_ChatInfo.SendAddonMessage — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage)
- [Secure Execution and Tainting — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)
- [ChatThrottleLib — WowAce](https://www.wowace.com/projects/chatthrottlelib)
- [Ace3 Getting Started — WowAce](https://www.wowace.com/projects/ace3/pages/getting-started)
- [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0)
- [WoW Classic 1.13.3 addon channel change — Wowhead](https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371)
- [Classic SendAddonMessage problems — Blizzard forums](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054)
- [Blizzard Watch — Classic/Anniversary UI modernization (Jul 2026)](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)
- [ElvUI — Tukui](https://tukui.org/elvui)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons)
- Design spec & plan in `docs/superpowers/`
- Sibling tracks [01](01-client-flavors-and-toc.md)–[05](05-persistence-and-profiles.md) and `.raw/` scrape corpus
