# WoW Classic Addon Design — Research Library

**Started:** 2026-07-25  
**Purpose:** Lasting design/ecosystem reference for Church of Beef (Beef_Addon).  
**Status:** Living library — tracks **00–74** filled for V1 desk research. Implementer entrypoint: [74-v1-decision-glossary](74-v1-decision-glossary/). Gap audit: [56-coverage-gap-audit](56-coverage-gap-audit/). Live gaps → [guild-night playtest](../../phases/guild-night-playtest.md).  
**Scope:** Research and design knowledge only. Addon code lives in `.worktrees/feat-church-of-beef-v1/`.

## How to use this library

1. Read the [Church of Beef V1 design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) first.
2. Skim this index, then open the track that matches your question.
3. Start with [implications synthesis](00-church-of-beef-implications.md) for product decisions; use [01–74](#library-index) for depth; use the [master reference list](06-annotated-master-reference-list.md) when you need a primary URL.
4. When research changes a product decision, update the design spec’s decisions log — do not silently fork policy into these notes.

## Related repo docs (outside this folder)

| Path | Role |
|------|------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Approved V1 product/architecture spec |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | Implementation plan (`Interface: 20506`, module layout) |
| `docs/canon/`, `docs/phases/` | Lore prose / phase checklists (placeholders as of library start) |

Notion is not used by this repo; local markdown is the deliverable.

## Library index

Root docs and focused research tracks. Open a link even if a sibling track is still being filled.

| Track | Topic |
|-------|--------|
| [00-church-of-beef-implications.md](00-church-of-beef-implications.md) | **Synthesis** — implications mapped to the V1 design spec |
| [01-ux-patterns/](01-ux-patterns/) | Dominant Classic UX patterns by UI surface |
| [02-visual-language/](02-visual-language/) | Classic-native visual language and ElvUI coexistence |
| [03-ace-libs-options/](03-ace-libs-options/) | Ace3, LibStub, and options/config conventions |
| [04-toc-api-performance/](04-toc-api-performance/) | TOC, API constraints, and performance practices |
| [05-packaging-community-antipatterns/](05-packaging-community-antipatterns/) | Packaging, distribution, and community antipatterns |
| [06-annotated-master-reference-list.md](06-annotated-master-reference-list.md) | **Curated master URL list** with steal/adapt notes |
| [07-immersion-roleplay-flavor/](07-immersion-roleplay-flavor/) | Immersion, roleplay, and flavor presentation patterns |
| [08-combat-hud-alerts/](08-combat-hud-alerts/) | Combat HUD and alert UX patterns |
| [09-guild-social-community/](09-guild-social-community/) | Guild, social, and community addon patterns |
| [10-skinning-masque-sharedmedia/](10-skinning-masque-sharedmedia/) | Skinning via Masque, SharedMedia, and related libs |
| [11-onboarding-settings-ux/](11-onboarding-settings-ux/) | Onboarding and settings UX patterns |
| [12-classic-vs-retail-philosophy/](12-classic-vs-retail-philosophy/) | Classic vs Retail design philosophy contrast |
| [13-cousin-addon-teardowns/](13-cousin-addon-teardowns/) | Attune/Gargul/RP cousin UX tear-downs |
| [14-addon-messaging-beefnet/](14-addon-messaging-beefnet/) | GUILD addon messages, CTL, sync budgets |
| [15-instance-completion-events/](15-instance-completion-events/) | Dungeon/instance event reliability |
| [16-guild-roster-officer-edges/](16-guild-roster-officer-edges/) | Roster timing & Officer+ gates |
| [17-stream-overlay-readability/](17-stream-overlay-readability/) | Streamer/capture readability |
| [18-localization-i18n/](18-localization-i18n/) | Locale norms |
| [19-testing-debugging-qa/](19-testing-debugging-qa/) | Classic addon QA |
| [20-sound-sfx-feedback/](20-sound-sfx-feedback/) | Sound/SFX feedback design |
| [21-savedvariables-migration/](21-savedvariables-migration/) | SavedVariables migration patterns |
| [22-slash-commands-ux/](22-slash-commands-ux/) | Slash-command UX conventions |
| [23-color-brand-tokens/](23-color-brand-tokens/) | Color and brand token systems |
| [24-policy-tos-compliance/](24-policy-tos-compliance/) | Policy and ToS compliance for addons |
| [25-multi-toon-realm-edges/](25-multi-toon-realm-edges/) | Multi-toon and realm edge cases |
| [26-ladders-points-gamification/](26-ladders-points-gamification/) | Ladders, points, and gamification |
| [27-desync-conflict-resolution/](27-desync-conflict-resolution/) | Desync and conflict resolution |
| [28-minimap-addon-compartment/](28-minimap-addon-compartment/) | Minimap button and Addon Compartment |
| [29-taint-secure-ui/](29-taint-secure-ui/) | Taint and secure UI constraints |
| [30-anniversary-vs-era-deltas/](30-anniversary-vs-era-deltas/) | Anniversary vs Era client deltas |
| [31-listing-copy-discovery/](31-listing-copy-discovery/) | Listing copy and discovery |
| [32-microcopy-tone-voice/](32-microcopy-tone-voice/) | Microcopy, tone, and voice |
| [33-packager-ci-releases/](33-packager-ci-releases/) | Packager, CI, and release channels |
| [34-lua-module-architecture/](34-lua-module-architecture/) | Lua module architecture patterns |
| [35-xml-vs-lua-ui/](35-xml-vs-lua-ui/) | XML vs Lua UI construction |
| [36-tooltips-menus/](36-tooltips-menus/) | Tooltips and context menus |
| [37-movable-frames-anchors/](37-movable-frames-anchors/) | Movable frames and anchors |
| [38-keybinds-bindings/](38-keybinds-bindings/) | Keybinds and Bindings.xml |
| [39-guild-calendar-events/](39-guild-calendar-events/) | Guild calendar and events |
| [40-officer-moderation-audit/](40-officer-moderation-audit/) | Officer moderation and audit |
| [41-empty-states-degraded-ux/](41-empty-states-degraded-ux/) | Empty states and degraded UX |
| [42-soft-deps-embeds/](42-soft-deps-embeds/) | Soft dependencies and embeds |
| [43-ui-scale-pixel-perfection/](43-ui-scale-pixel-perfection/) | UI scale and pixel perfection |
| [44-custom-textures-media-packaging/](44-custom-textures-media-packaging/) | Custom textures and media packaging |
| [45-licensing-maintainer-norms/](45-licensing-maintainer-norms/) | Licensing and maintainer norms |
| [46-seasonality-fresh-servers/](46-seasonality-fresh-servers/) | Seasonality and fresh servers |
| [47-login-storms-guild-scale/](47-login-storms-guild-scale/) | Login storms and guild scale |
| [48-feature-flags-rollout/](48-feature-flags-rollout/) | Feature flags and rollout |
| [49-officer-notifications/](49-officer-notifications/) | Officer notifications |
| [50-time-timezones-resets/](50-time-timezones-resets/) | Time, timezones, and resets |
| [51-guild-night-playbook/](51-guild-night-playbook/) | Guild night playbook |
| [52-competitor-market-map/](52-competitor-market-map/) | Competitor and market map |
| [53-beef-lore-ui-bible/](53-beef-lore-ui-bible/) | Beef lore UI bible |
| [54-memory-fps-budgets/](54-memory-fps-budgets/) | Memory and FPS budgets |
| [55-graceful-degradation/](55-graceful-degradation/) | Graceful degradation |
| [56-coverage-gap-audit/](56-coverage-gap-audit/) | **Gap audit (post–Wave E 2026-07-25)** — 00–74 solid; remaining gaps are live playtests |
| [57-scrollframe-list-rows/](57-scrollframe-list-rows/) | Ladder/officer list scroll patterns |
| [58-staticpopup-confirms/](58-staticpopup-confirms/) | Confirm dialogs |
| [59-coplay-guildmate-detection/](59-coplay-guildmate-detection/) | Co-play presence detection |
| [60-hardcore-doomhowl-edges/](60-hardcore-doomhowl-edges/) | HC/Doomhowl edges |
| [61-streamer-mode-privacy/](61-streamer-mode-privacy/) | Streamer mode / privacy CVars |
| [62-patch-day-interface-bump/](62-patch-day-interface-bump/) | Interface bump runbook |
| [63-combatlog-social-signals/](63-combatlog-social-signals/) | CLEU for social scoring (or avoid) |
| [64-fresh-lowlevel-fairness/](64-fresh-lowlevel-fairness/) | Newbie/alt fairness |
| [65-debug-dumps-privacy/](65-debug-dumps-privacy/) | Debug dump privacy |
| [66-editmode-classic-coexistence/](66-editmode-classic-coexistence/) | Edit Mode / modern UI coexistence |
| [67-offline-officer-suggestion-sync/](67-offline-officer-suggestion-sync/) | Offline officer suggestion-queue sync policy |
| [68-beefnet-message-catalog/](68-beefnet-message-catalog/) | BeefNet message types & wire budgets |
| [69-officer-tab-ia/](69-officer-tab-ia/) | Officer tab information architecture |
| [70-standing-breakdown-ui/](70-standing-breakdown-ui/) | My Standing / breakdown UI |
| [71-ceremony-gora-mechanics/](71-ceremony-gora-mechanics/) | Ceremony & Gora ritual mechanics |
| [72-guild-chat-announce-api/](72-guild-chat-announce-api/) | Guild-chat announce API & throttling |
| [73-desktop-lua-testing/](73-desktop-lua-testing/) | Desktop Lua / CI unit testing |
| [74-v1-decision-glossary/](74-v1-decision-glossary/) | Locked V1 decision glossary |

Prior flat sketches at this folder root (`01-client-flavors-and-toc.md`, `02-ux-patterns-classic.md`, `03-visual-language-reference.md`, `04-ace3-and-libraries.md`, `05-persistence-and-profiles.md`) are superseded by the track folders above when those tracks are filled; prefer the folders as canonical.

## Provenance

- Scraped primary pages and search result JSON live under [`.raw/`](.raw/) (and per-track `.raw/` where used) for auditability.
- Prefer citing wiki / WowAce / CurseForge / Tukui / Blizzard Watch over secondary “top 10” listicles when making technical claims.
- Synthesis lane does its own research; tracks 01–74 deepen topics without being required for a first read of `00`.

## Client focus for Church of Beef

| Flavor | Relevance to V1 |
|--------|-----------------|
| **TBC Classic Anniversary** | Primary V1 target (`Interface` **20506** per plan/spec) |
| Classic Era / SoD / Hardcore | Same family; separate install trees; API drift possible |
| Cataclysm / MoP Classic | Different Interface numbers; useful for TOC multi-flavor patterns only |
| Retail / Midnight | Out of V1 scope — contrast only (what *not* to depend on) |

## Suggested next research topics

**Desk shells 00–74 are filled.** Ranked remaining gaps (almost all live/ops): [56-coverage-gap-audit/priority-next-research.md](56-coverage-gap-audit/priority-next-research.md).  
Guild-night checklist: [`docs/phases/guild-night-playtest.md`](../../phases/guild-night-playtest.md).  
Cross-track consensus refresh: end of [00-church-of-beef-implications.md](00-church-of-beef-implications.md).
