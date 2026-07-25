# AceAddon modules vs plain namespaces

**Track:** [34-lua-module-architecture](README.md)  
**Does not cover:** AceDB/AceConfig/AceComm feature catalogs → [03](../03-ace-libs-options/).

## Two dominant organization styles

| Style | Root object | Sub-units | Lifecycle | Classic examples |
|-------|-------------|-----------|-----------|------------------|
| **AceAddon modules** | `LibStub("AceAddon-3.0"):NewAddon("Name", …)` | `:NewModule("Foo", "AceEvent-3.0", …)` | `OnInitialize` / `OnEnable` / `OnDisable` per addon **and** per module | Skada (`modules/`), Chatter modules, many WowAce utilities |
| **Plain namespace** | `MyAddon = MyAddon or {}` or private `local _, ns = ...` | Tables hung on root (`MyAddon.Core`, `ns.DB`) | Author-owned `CreateFrame` + events | Wiki HelloWorld tutorials; Beef plan; many single-purpose Classic tools |

## What AceAddon modules actually buy

From the [AceAddon-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0):

- **`NewAddon`** — creates the root object, embeds listed libs, schedules `OnInitialize` (after addon fully loaded) and `OnEnable` (during `PLAYER_LOGIN`).
- **`NewModule`** — child objects with the **same API as an addon** (nested modules allowed). Can embed their own libs or inherit defaults via `SetDefaultModuleLibraries` / `SetDefaultModulePrototype`.
- **Enable/disable** — `:EnableModule` / `:DisableModule` / `SetDefaultModuleState(false)` for optional features that tear down events/hooks in `OnDisable`.
- **Iteration** — `:IterateModules()` for “enable all display modes” style loops (damage-meter pattern).

Skada’s public face is “modular damage meter with viewing modes” ([Skada Classic listing](https://legacy-wow.com/classic-addons/skada-classic/)); error stacks show real `NewModule` / `OnEnable` module tables under an AceAddon root — the textbook use of optional feature packs.

## What plain namespaces buy

From [Create a WoW AddOn in 15 Minutes](https://warcraft.wiki.gg/wiki/Create_a_WoW_AddOn_in_15_Minutes) and Ace Getting Started (which still describes a main `Core.lua` / `MyAddon.lua` even for Ace projects):

- **Zero LibStub requirement** for Core logic — files are plain Lua tables.
- **Private addon namespace** via `local addonName, ns = ...` shared across TOC files without polluting `_G` (wiki “AddOn namespace” section).
- **Explicit globals when needed** — `ChurchOfBeef = ChurchOfBeef or {}` is the plan’s public root; other addons can detect `ChurchOfBeef` without Ace.
- **Desktop test harness** — `dofile("Core/Ladder.lua")` works if the file only assumes a table exists; AceAddon’s LibStub schedule does not.

Plain does **not** mean “one giant file.” Quality plain addons still split Options / Events / Core across TOC-listed files that mutate the same `ns` or global.

## Decision matrix (architecture, not library shopping)

| Need | Prefer AceAddon modules | Prefer plain namespace |
|------|-------------------------|------------------------|
| Many optional features users toggle independently | Yes (`SetDefaultModuleState`, per-module `OnDisable`) | Painful DIY |
| Heavy AceEvent / AceHook / AceTimer mixins per feature | Yes (embed on `NewModule`) | Manual embed or skip |
| Offline unit tests of scoring / ladder pure logic | Awkward (LibStub, frame lifecycle) | **Yes** |
| Fixed always-on Core + thin UI/Net adapters | Overkill | **Yes** (Beef V1) |
| Future AceConfig options UI only | Can adopt Ace later for options only | Keep Core plain; options can be a later adapter |

## Mapping Ace concepts → Beef plain equivalents

| AceAddon concept | Beef V1 plain shape |
|------------------|---------------------|
| `NewAddon("ChurchOfBeef")` | `ChurchOfBeef = ChurchOfBeef or {}` / `local COB = ChurchOfBeef` |
| `NewModule("Ladder")` | `COB.Ladder = COB.Ladder or {}` in `Core/Ladder.lua` |
| `OnInitialize` | `ADDON_LOADED` branch → `COB.DB:Init()` |
| `OnEnable` | `PLAYER_LOGIN` branch → `COB.UI:Init()`, `COB.Net:Init()`, `COB.Sync:OnLogin()` |
| `OnDisable` / module standby | Not needed V1 (no hot-toggle Core); unregister events only if adding a “pause” mode later |
| `SetDefaultModuleLibraries("AceEvent-3.0")` | One bootstrap frame owns Blizzard events; modules expose methods |

## Anti-patterns

- **AceAddon root wrapping already-pure Core “for consistency.”** Adds load path and test friction; gains nothing Beef will use in V1 (no optional Core modules).
- **Plain global soup** — every file defining top-level functions without a `COB.*` table. Collides with other addons; harder to stub.
- **Half-Ace** — root is AceAddon but Core bypasses modules with ad-hoc globals. Pick one story per layer.

## Steal / adapt

- **Steal from Ace:** the *semantic* split of initialize (SV/slash) vs enable (events/frames/world).  
- **Steal from Skada-style modules:** folder-per-feature only if a feature is truly optional (not V1).  
- **Adapt for Beef:** always-on `COB.Core*` tables + bootstrap orchestration; defer AceAddon until a V2 feature pack genuinely needs per-module standby.
