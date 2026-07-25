# File layout patterns (Classic-quality)

**Track:** [34-lua-module-architecture](README.md)  
**Does not cover:** TOC `## Interface` flavors, packaging, performance → [04](../04-toc-api-performance/). Embedding `Libs/` / `embeds.xml` detail → [03](../03-ace-libs-options/).

## Common layouts in the wild

### A. Ace “Core.lua + embeds” (framework default)

```
MyAddon/
  MyAddon.toc          # embeds.xml then Core.lua (and more)
  embeds.xml           # LibStub + Ace* includes
  Libs/...
  Core.lua             # NewAddon + lifecycle
  Modules/Foo.lua      # NewModule definitions
  Locales/...
```

Documented in [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) and community bootstraps such as [Jakobud’s Classic Ace gist](https://gist.github.com/Jakobud/99d772b1bb578359f03205f6069f3b44): libs first via XML, then main code; locales loaded before code that reads `L[]`.

### B. Ace modular feature packs (Skada-shaped)

```
Skada/
  Skada.lua            # AceAddon root
  modules/
    Deaths.lua         # NewModule("Deaths") …
  BarDisplay.lua
  Libs/...
```

Feature code lives under `modules/`; each file registers a module at load time. Good when users disable modes; poor when every file must participate in offline tests.

### C. Plain multi-file namespace (wiki / Beef-shaped)

```
HelloWorld/            # wiki multi-file example
  HelloWorld.toc       # Core.lua then Options.lua
  Core.lua
  Options.lua
```

Wiki guidance: split logic across files; share via global root or private `ns` ([Create a WoW AddOn…](https://warcraft.wiki.gg/wiki/Create_a_WoW_AddOn_in_15_Minutes)). Beef plan extends this into layered folders:

```
ChurchOfBeef/
  ChurchOfBeef.toc
  ChurchOfBeef.lua     # bootstrap LAST
  Data/Ranks.lua
  Core/*.lua
  Net/*.lua
  UI/*.lua
```

## TOC order = runtime dependency order

Within one addon ([AddOn loading process](https://wowpedia.fandom.com/wiki/AddOn_loading_process)):

1. Files execute **sequentially** as listed in the `.toc` (and via XML `<Script>` / `<Include>`).
2. **SavedVariables load after the last file**, overwriting earlier defaults.
3. **`ADDON_LOADED`** fires — earliest safe SV read for that addon name.

Implications for layout:

| Place early in TOC | Place late in TOC |
|--------------------|-------------------|
| Canon / constants (`Data/`) | Bootstrap that calls `Init` |
| Pure Core tables that only define methods | UI that assumes Core methods exist |
| Net validate helpers used by Sync | Sync that registers chat handlers |
| Locale tables (AceLocale or plain `L`) | Anything that indexes `L["…"]` at file scope |

Plan TOC order (Data → Core → Net → UI → `ChurchOfBeef.lua`) is the correct dependency direction for a plain-namespace addon.

## Naming conventions that age well

| Convention | Why |
|------------|-----|
| Folder = layer (`Core/`, `UI/`, `Net/`, `Data/`) | Matches mental model in design spec §6 |
| One primary table per file (`COB.Ladder` in `Ladder.lua`) | Easy `dofile` tests; grep-friendly |
| Bootstrap named like the addon (`ChurchOfBeef.lua`) | Ace Getting Started notes this as a common alternative to `Core.lua` |
| Consistent casing (`ChurchOfBeef*.lua`) | Case-sensitive packaging (spec §5) |
| No top-level `canon/` inside the installable addon | TOC can only load inside the addon folder; machine canon is `Data/Ranks.lua` |

## What not to copy from Ace layouts into Beef V1

- **`embeds.xml` + full Ace3 tree** — not required; if a single lib is added later (e.g. ChatThrottleLib, LibDBIcon), prefer a minimal `Libs/` include without adopting AceAddon as root (see track 03 for embed policy).
- **`Modules/` with enable toggles for scoring** — scoring/ladder are product-critical, not user-optional display modes.
- **Options as the second file with no layering** — fine for HelloWorld; Beef already outgrew that (UI tabs + Net + Core).

## Cross-addon load order (only as layout context)

Custom addons load after Blizzard UI, roughly alphabetical, unless `LoadWith` / `LoadOnDemand` / dependencies intervene ([loading process](https://wowpedia.fandom.com/wiki/AddOn_loading_process)). Beef should not rely on another addon’s load order. Soft-detect optional companions; never require ElvUI/Skada load sequence for Core correctness. (Hard `## Dependencies` / Interface details → track 04.)
