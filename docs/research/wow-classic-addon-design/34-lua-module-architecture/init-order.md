# Init order — file scope, ADDON_LOADED, PLAYER_LOGIN

**Track:** [34-lua-module-architecture](README.md)  
**Does not cover:** SavedVariables schema/migration → [21](../21-savedvariables-migration/); BeefNet login sync budgets → [14](../14-addon-messaging-beefnet/); TOC Interface → [04](../04-toc-api-performance/).

## Canonical client sequence (per-addon)

From [AddOn loading process](https://wowpedia.fandom.com/wiki/AddOn_loading_process) (Wowpedia; warcraft.wiki.gg mirror preferred when available):

| Step | What happens | Safe to do |
|------|--------------|------------|
| TOC file list runs | Each Lua/XML chunk executes in order | Define tables, functions, slash stubs, create frames (empty) |
| SavedVariables applied | Declared SV globals populated / overwrite defaults | — |
| `ADDON_LOADED` (arg = addon name) | Addon finished loading files + SV | **First reliable SV read**; filter by addon name; DB migrate/init |
| `PLAYER_LOGIN` | Login/reload loading screen; most character/world UI data present | Register gameplay events; show frames; one-time enable |
| `PLAYER_ENTERING_WORLD` | Every load screen (login, reload, instance) | Zone/instance-dependent init; **not** a second DB init |
| `PLAYER_LOGOUT` / unload | Last chance to mutate SV before serialize | Rarely needed if you mutate live |

Ace maps this to lifecycle methods ([AceAddon-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0)):

| Ace callback | Rough client moment | Ace docs say |
|--------------|---------------------|--------------|
| `OnInitialize` | After addon fully loaded | SavedVariables, slash setup |
| `OnEnable` | During `PLAYER_LOGIN` | Register events, hooks, frames, game queries unavailable earlier |
| `OnDisable` | Manual disable / standby | Unhook, unregister, hide |

AceDB must be created in **`OnInitialize` or later**, never in the main chunk ([Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)) — same rule for plain addons: do not assume SV shape until `ADDON_LOADED` for your name ([wiki HelloWorld](https://warcraft.wiki.gg/wiki/Create_a_WoW_AddOn_in_15_Minutes)).

> Note: Some community notes claim SVs are available at the top of the first Lua file. Prefer the wiki/Ace rule: treat **`ADDON_LOADED` + name filter** as the authoritative first SV read. File-scope `MyDB = MyDB or {}` is a common shorthand but is not a substitute for understanding overwrite timing.

## What belongs at file scope (no event)

Safe and idiomatic:

- `ChurchOfBeef = ChurchOfBeef or {}`
- Attach empty subtables / function definitions (`function COB.Ladder:Commit(...)`)
- Local constants and pure helpers with no WoW API
- `SLASH_*` registration (plan does this in bootstrap)
- `CreateFrame("Frame")` + `RegisterEvent` **wiring** (handlers that no-op until flags set)

Unsafe at file scope:

- Reading `ChurchOfBeefDB` fields as authoritative
- Guild roster / unit APIs for officer gates
- `SendAddonMessage` / sync fan-out
- Creating full UI assuming fonts/positions from SV

## Beef plan bootstrap (locked shape)

Plan `ChurchOfBeef.lua` already encodes the Ace-equivalent split:

| Event | Plan calls | Role |
|-------|------------|------|
| `ADDON_LOADED` + `"ChurchOfBeef"` | `COB.DB:Init()` | SV merge, schema, `COB.loaded = true` |
| `PLAYER_LOGIN` | `COB.UI:Init()`, `COB.Net:Init()`, `COB.Sync:OnLogin()` | Frames, message prefix, delayed sync |

Recommended refinements (architecture, not re-spec):

1. **Unregister `ADDON_LOADED` after self-hit** — avoids noise from other addons’ loads ([loading process](https://wowpedia.fandom.com/wiki/AddOn_loading_process)).
2. **Defer `Sync:OnLogin` past bare `PLAYER_LOGIN`** if roster/throttle hostility bites — track 14 documents cold-login and CTL post-login clamp; architecturally keep Sync behind a “world settled” gate (`PLAYER_ENTERING_WORLD` once, or a short timer), not inside Core file load.
3. **Core methods may exist before Init** — `dofile` tests call them with fake DB; runtime Init only attaches the live SV table.

## Module init inside AceAddon (contrast)

Ace modules created with `NewModule` get the same initialize/enable schedule relative to their parent. Optional modules can start disabled (`SetDefaultModuleState(false)`) and enable later ([API](https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0)). Beef has no disabled Core modules — every Core file should be safe to define at TOC load and idle until something calls it.

## Init order checklist for new Beef files

When adding a file under `Core/`, `Net/`, or `UI/`:

1. List it in the TOC **before** `ChurchOfBeef.lua`, after its dependencies.
2. At file scope: only attach the table + methods.
3. If it needs SV: run from `DB:Init` or a method called by bootstrap after `ADDON_LOADED`.
4. If it needs events/frames: register from `PLAYER_LOGIN` Init (or PEW for instance-scoped).
5. Never call Net send paths from Core constructors.
