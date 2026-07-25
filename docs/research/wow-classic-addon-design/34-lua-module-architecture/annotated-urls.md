# Annotated URLs — Lua module architecture

Primary sources for track 34. Prefer these over “best addon structure” listicles. Ace **options/DB** URLs belong in track 03; TOC **Interface/performance** URLs belong in track 04.

## AceAddon lifecycle & modules

| URL | Steal / adapt for Beef |
|-----|------------------------|
| https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0 | Canonical `OnInitialize` / `OnEnable` / `OnDisable`; `NewModule`, enable/disable, default module libs/state. **Steal the two-phase lifecycle semantics; do not adopt NewModule for V1 Core.** |
| https://www.wowace.com/projects/ace3/pages/getting-started | File setup (`Core.lua` vs addon-named main file), embeds.xml role, AceDB-after-OnInitialize rule, AceEvent as mixin. **Steal init timing rules for plain bootstrap.** |
| https://github.com/WoWUIDev/Ace3/blob/master/AceAddon-3.0/AceAddon-3.0.lua | Implementation reference: safecall around optional lifecycle methods. Read-only research. |
| https://gist.github.com/Jakobud/99d772b1bb578359f03205f6069f3b44 | Classic-era Ace bootstrap layout (toc → embeds → Core). **Contrast only** — shows what Beef deliberately skips. |

## Loading order & SavedVariables timing

| URL | Steal / adapt for Beef |
|-----|------------------------|
| https://wowpedia.fandom.com/wiki/AddOn_loading_process | Sequential TOC load → SV after last file → `ADDON_LOADED` → `PLAYER_LOGIN` → `PLAYER_ENTERING_WORLD`. **Authoritative init checklist.** |
| https://warcraft.wiki.gg/wiki/AddOn_loading_process | Preferred mirror of the same article when reachable. |
| https://warcraft.wiki.gg/wiki/Create_a_WoW_AddOn_in_15_Minutes | Plain multi-file addon, SV on `ADDON_LOADED`, private `local _, ns = ...` namespace. **Closest tutorial shape to Beef.** |
| https://github.com/TheMizeGuy/wow-addon-dev/blob/main/references/savedvariables-and-load-order.md | Handy cheat sheet; **cross-check** SV-before-vs-after-file claims against Wowpedia before treating as gospel. |

## Internal event bus

| URL | Steal / adapt for Beef |
|-----|------------------------|
| https://www.wowace.com/projects/callbackhandler | CallbackHandler `:Fire` / `RegisterCallback`; documents AceEvent’s dual registries. **Pattern library for a future plugin bus — not a V1 dependency.** |
| https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0 | `RegisterEvent` vs `RegisterMessage` / `SendMessage`. **Clarify Blizzard events ≠ internal messages ≠ BeefNet.** |
| https://github.com/hurricup/WoW-Ace3/blob/master/AceEvent-3.0/AceEvent-3.0.lua | Compact source showing CallbackHandler wiring for events + messages. |

## Modular Classic addons (examples, not templates)

| URL | Steal / adapt for Beef |
|-----|------------------------|
| https://legacy-wow.com/classic-addons/skada-classic/ | Skada as modular meter with optional views — **Ace NewModule use-case** Beef does not share. |
| https://github.com/abl/AddOns/blob/master/Skada/Skada.lua | Example `NewAddon("Skada", …)` root (mirror/archive). Contrast with plain `COB` root. |
| https://www.wowinterface.com/downloads/info25146-SkadaClassic.html | Runtime stacks showing per-module `OnEnable` / `NewModule` — evidence of Ace module pattern in Classic installs. |

## Product truth (repo)

| URL / path | Steal / adapt for Beef |
|------------|------------------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §5–§6 | Locked repo layout + runtime component graph. |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | Locked file tree, TOC order, bootstrap event split. |
| [`docs/research/wow-classic-addon-design/04-ace3-and-libraries.md`](../04-ace3-and-libraries.md) | Flat Ace decision frame (“No Ace V1”) — do not duplicate here; link when library choice resurfaces. |

## Intentionally deferred to other tracks

| Topic | Track |
|-------|-------|
| AceConfig / AceDB / LibDBIcon / embeds policy | [03-ace-libs-options](../03-ace-libs-options/) |
| TOC Interface, dependencies, performance | [04-toc-api-performance](../04-toc-api-performance/) |
| GUILD prefix, CTL, sync timing hostility | [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/) |
| SV schema / wipe safety | [21-savedvariables-migration](../21-savedvariables-migration/) |
