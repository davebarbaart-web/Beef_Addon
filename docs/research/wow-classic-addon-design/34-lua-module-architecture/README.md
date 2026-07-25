# Track 34 — Lua module architecture & code organization

**Track id:** `34-lua-module-architecture`  
**Last updated:** 2026-07-25  
**Sole focus:** How quality Classic addons carve Lua into modules — AceAddon `NewModule` vs plain namespaces, file/folder layout, init order, and internal event-bus patterns — plus architecture recommendations for Church of Beef V1.  
**Out of scope:** Ace3 library catalog, options/DB UX, LibStub embedding conventions (track [03](../03-ace-libs-options/), flat sketch [04-ace3-and-libraries.md](../04-ace3-and-libraries.md)); TOC metadata, Interface flavors, API/performance budgets (track [04](../04-toc-api-performance/), flat sketch [01-client-flavors-and-toc.md](../01-client-flavors-and-toc.md)). No addon implementation lives here.

## Product truth (from V1 spec + plan)

| Locked default | Value |
|----------------|-------|
| Organization | Plain global namespace `ChurchOfBeef` / `COB` — **not** AceAddon |
| Layers | `Data/` (canon) → `Core/` (pure logic) → `Net/` + `UI/` (adapters) → bootstrap |
| Testability | Core must load under desktop Lua via `dofile` + stubs |
| Bootstrap timing | `ADDON_LOADED` → DB; `PLAYER_LOGIN` → UI / Net / Sync |
| TOC file order | Data → Core → Net → UI → `ChurchOfBeef.lua` last |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §5–§6; [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) (Architecture + File structure).

## Index

| Note | Covers |
|------|--------|
| [aceaddon-modules-vs-namespaces.md](aceaddon-modules-vs-namespaces.md) | AceAddon `NewModule` vs plain tables / private `ns` — when each wins |
| [file-layout-patterns.md](file-layout-patterns.md) | Folder conventions quality Classic addons use; TOC load order for modules |
| [init-order.md](init-order.md) | File-scope vs `ADDON_LOADED` / `PLAYER_LOGIN` / PEW; Ace lifecycle mapping |
| [event-bus-patterns.md](event-bus-patterns.md) | CallbackHandler, AceEvent messages, frame dispatch, direct Core calls |
| [beef-v1-architecture.md](beef-v1-architecture.md) | Explicit Beef V1 recommendations mapped to plan modules |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **V1 should stay plain-namespace, not AceAddon.** AceAddon’s value is optional module enable/disable, library mixins, and a standardized `OnInitialize`/`OnEnable` schedule ([AceAddon-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0)). Beef’s plan already locks a thinner equivalent: `ChurchOfBeef = ChurchOfBeef or {}` plus explicit `Init`/`OnLogin` hooks. Ace would add embed weight without buying Core offline testability.

2. **“Module” for Beef means a table on `COB`, not `NewModule`.** Quality Ace addons (e.g. Skada) use `NewModule` for toggleable feature packs under one AceAddon root. Beef’s Core files are **always-on pure tables** (`COB.Ladder`, `COB.Scoring`, …) so desktop `dofile` tests never need LibStub.

3. **TOC order is the dependency graph.** Within an addon, files run top-to-bottom as listed; SavedVariables apply after the last file; then `ADDON_LOADED` fires ([AddOn loading process](https://wowpedia.fandom.com/wiki/AddOn_loading_process)). Plan TOC — Data → Core → Net → UI → bootstrap last — matches that: define tables first, wire lifecycle last.

4. **Mirror Ace’s two-phase lifecycle without Ace.** Ace: `OnInitialize` ≈ after addon fully loaded (SV ready); `OnEnable` ≈ `PLAYER_LOGIN` (world data present) ([AceAddon API](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0)). Beef plan: DB on `ADDON_LOADED`; UI/Net/Sync on `PLAYER_LOGIN`. Do not fan BeefNet sync or guild-roster gates at file scope.

5. **Prefer direct Core calls over a heavy internal bus in V1.** AceEvent’s `RegisterMessage`/`SendMessage` (CallbackHandler under the hood) is ideal when many optional modules subscribe ([CallbackHandler](https://www.wowace.com/projects/callbackhandler), [AceEvent](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0)). Beef has a fixed Core→UI/Net fan-out — `COB.UI:RefreshLadder()` after commit is clearer and easier to stub than a message mesh.

6. **Keep Core free of frames and Net free of scoring policy.** Spec §6 flow is events → Core scoring → suggestion → officer → BeefNet → peers → UI. If UI or Net starts owning points/caps, offline tests and Classic+ ports both break.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer WowAce / Wowpedia / Warcraft Wiki / V1 plan over gist tutorials for lifecycle claims. Do not treat this track as a substitute for [03 Ace libs](../03-ace-libs-options/) or [04 TOC/API](../04-toc-api-performance/).
