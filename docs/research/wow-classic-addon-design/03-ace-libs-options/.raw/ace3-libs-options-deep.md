# Parallel deep research — Ace3 / LibStub / LSM / options

Run: trun_91f36069f0964480b242772dcf1e9943

## Executive Insights

- **Adopt the addon-table shape from v1**: Ace3's lifecycle anchors every addon in a single `:NewAddon()` table; Church of Beef should follow the same shape from v1 so v2 can swap to AceDB without a rewrite.
- **Per-character storage aligns with AceDB's `char` scope**: a v1 file-load model already maps to AceDB's per-character namespace, so adopting AceDB later requires only declaring the scope, not migrating data.
- **Route slash commands through `AceConsole:RegisterChatCommand`**: persistence is the only knob that matters; one boolean decides whether the command survives `/reload`.
- **Officer gating belongs at the data layer, not the command layer**: AceDB child namespaces inherit the parent's profile, so splitting `guildData` (account-wide) from `ladderEntries` (char-specific) at registration makes officer gating a property of the table, not a guard at each command.
- **Settings panel = `AceConfig` table + `AceConfigDialog:AddToBlizOptions`**: this is the only Blizzard-options integration Classic addons need; `AceDBOptions` then auto-renders the profile manager (per-character / per-realm / per-account).
- **LibSharedMedia registration is a one-liner**: `LSM:Register("font"|"statusbar"|"border"|"background"|"sound", key, data)` plus a `:RegisterCallback` for `LibSharedMedia_MediaType` to re-render.
- **LibDBIcon follows the data-object pattern**: an object implementing `OnClick`/`OnTooltipShow` plus an LDB `type` field is enough to get a minimap button via `LibDBIcon:Register(name, dataobj, db)`.
- **Enforce officer gating with Blizzard's permission APIs**: `CanEditOfficerNote()`, `CanGuildPromote()`, `CanRemoveFromGuild()`, plus `IsInGuild()`, `IsGuildLeader()` are the canonical gates that already back the guild UI.
- **Inversion-of-control via mixins pays in officer UIs**: Ace3 dependency-injects libraries into the addon object; Church of Beef should adopt the same pattern so officer-only features plug into the addon object instead of branching inside commands.
- **Embed LibStub once via `.pkgmeta`**: every Ace3 module is a LibStub library; v1 should ship its own LibStub and reference it from the `.toc` so future modules can register without an external dependency.
- **The `.pkgmeta` `externals:` block is the canonical embed pattern**: WeakAuras2 demonstrates the production-grade model (`https://repos.curseforge.com/...`) and is the template to copy.
- **Standard widget vocabulary for settings UIs**: `toggle`, `range`, `select`, `multiselect`, `input`, `execute`, `color`, `keybinding`, `description`, `header`, `group` -- everything else is composition.
- **AceDB profile copy/reset UX is built-in**: `db:ResetProfile()` wipes to defaults; `db:CopyProfile(name)` and `db:SetProfile(name)` are the supported APIs to switch/copy.
- **Officer gating should use Blizzard's permission APIs**, not guild rank string checks -- they are the canonical, localized, and resilient gates.

## Why Ace3 In One Paragraph

Ace3 is a modular, embed-by-LibStub Lua framework whose libraries are versioned independently yet load as ordinary WoW libraries. Each library uses `LibStub:NewLibrary("Name", ver)` so an embedded copy registers once and any later load is ignored. Addons consume Ace via `LibStub("AceAddon-3.0"):NewAddon("Name")`, which returns a mixin-aware object whose `OnInitialize` / `OnEnable` / `OnDisable` lifecycle is the only contract every addon module honors. For Church of Beef this means a v1 split into data, UI, and slash regions can move to Ace without code change beyond replacing init with `:NewAddon()` and registering libraries.

## Aceaddon 3 0 The Addon Lifecycle

AceAddon is the only library an addon MUST instantiate; all others are optional and injected by name. The signature is `LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceEvent-3.0", "AceComm-3.0", ...)`. Each library name becomes a mixin applied to the addon table. Three hooks fire in order:

- `OnInitialize()` runs once on `ADDON_LOADED`; load SavedVariables, wire defaults.
- `OnEnable()` runs on login or `/reload`; register events, slash commands, frames, AceDB options.
- `OnDisable()` runs on user disable; here all listeners must be unregistered to avoid leaks.

Modules are declared with `addon:NewModule("Name", "AceEvent-3.0")`; they receive the parent addon's events via `self.module:SetEnabledState(true|false)` driven by `db.profile.modules.<name>.enabled`. This is the foundation Church of Beef should plan around: a single add-on with N modules, each module optionally hooked into events, each module automatically participating in enable/disable and profile switching.

## Aceconsole 3 0 Slash Command Registration

AceConsole registers slash commands and parses the argument tail. The signature is `RegisterChatCommand(command, func, persist)`. Persistence defaults to `true`, so the command survives `OnDisable`; setting `persist=false` is the right choice when a moderator wants the command to vanish when the addon is disabled. The companion `GetArgs(input, numargs, startpos)` returns `arg1, arg2, ..., nextposition` so callers can iterate.

For Church of Beef, the canonical pattern is one handler per command that captures `arg1, arg2, ... = self:GetArgs(input, 3)`; group commands like `/guif ladder` route by `arg1`. Persistence matters when an officer disables the addon mid-event: a `persist=false` chat command goes dark and prevents ghost handlers.

## Acedb 3 0 Saved Variables Done Right

AceDB is the single most important library for Church of Beef because it transforms SavedVariables from a flat file into a typed, multi-scope database. The call is `local db = LibStub("AceDB-3.0"):New("CoBVars", defaults, true)`. The third argument forces a character-specific SavedVariables table (saved per character), which is the closest analog to "per-character SavedVariables" and the right default for Church of Beef's per-character ladder entries.

Nine scopes are available; their sharing boundaries are summarized below.

| Scope | Sharing boundary |
|-------|------------------|
| `char` | one character, one DB |
| `realm` | one realm, shared across characters on it |
| `class` | shared across same-class characters |
| `race` | shared across same-race characters |
| `faction` | shared across same-faction characters |
| `factionrealm` | shared across same-faction-and-realm characters |
| `locale` | shared across client locales |
| `global` | shared across the whole account |
| `profile` | user-managed, switchable per character |

The default table structure mirrors the scope names: `{ char = {...}, realm = {...}, ..., profile = {...} }`. Anything outside these keys lives under a wildcard `["*"]` block. Defaults are a regular Lua table mirroring that shape; AceDB only fills in keys missing from the saved file.

Child namespaces are a separate feature: `db:RegisterNamespace("guild", defaults)` creates a child DB. Child DBs share the parent's profile and so cannot change profile independently. The profile-related APIs are: `ResetProfile([name])`, `CopyProfile(target)`, `SetProfile(name)`, `GetProfile([name])`, `DeleteProfile(name)`, `ListProfiles()`, `IterateProfiles()`, `GetCurrentProfile()`. For Church of Beef three scopes suffice: `char` for ladder entries and scores, `realm` for the shared guild ladder and officer-only data, and `profile` for UI preferences.

## Aceconfig 3 0 Aceconfigdialog 3 0 Settings Panels

AceConfig is a data-driven spec format; AceConfigDialog renders it. The flow is: build an options table (a Lua dict of widget specs), register it via `LibStub("AceConfig-3.0"):RegisterOptionsTable("MyAddon", options, slash)`, then call `LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MyAddon", "Display Name", parent)`. A registered slash in the third argument of `RegisterOptionsTable` auto-routes `/cob` to `AceConfigDialog:Open("MyAddon")`.

The widget vocabulary is fixed:

- `toggle` -- `name`, `desc`, `get`, `set`, optional `width`
- `range` -- adds `min`, `max`, `step`, optional `softMin`/`softMax`
- `select` -- adds `values = { [key] = label, ... }`, optional `style` (dropdown vs radio)
- `multiselect` -- multi-pick variant of select
- `input` -- single-line text, optional `multiline`, optional `width`
- `execute` -- `func(info)` runs on click
- `color` / `multicolor` -- color picker (gradient for multicolor)
- `keybinding` -- bound to a WoW keybinding via `SetBinding`
- `description` -- static text, no `get`/`set`
- `header` -- section title
- `group` -- nesting container; supports `inline = true` or `childGroups = "tab"` (or `"tree"`) for tabbed layout

Two patterns matter most for a social addon:

1. **Args-as-functions for live reads.** Each `get`/`set` callback receives an `info` table with `.type`, `.arg` (key path), and `.options` (full table); live binding lets officers see updated values after changes propagate from another character.
2. **`childGroups = "tab"` for tabbed layout.** Switching between Normal/TBC/Profile views becomes a single option without stacking groups.

AceDBOptions auto-adds a profile selector with copy/reset/delete controls whenever an AceDB database is registered, satisfying the "per-character / per-realm / per-account" UX requirement.

## Aceevent 3 0 And Acecomm 3 0 Events And Channels

AceEvent wraps Blizzard's event dispatcher. API: `RegisterEvent(event[, callback[, arg]])`, `UnregisterEvent(event)`, `RegisterMessage(msg[, callback[, arg]])`, `UnregisterMessage(msg)`, `SendMessage(msg, ...)`, `UnregisterAllEvents/Messages()`. Dispatch is via `CallbackHandler-1.0`, so callbacks run sequentially and may pass `arg` to inject per-listener state.

AceComm adds addon-channel messaging on top of `C_ChatInfo.SendAddonMessage` / `RegisterAddonMessagePrefix`. API: `RegisterComm(prefix[, method])`, `SendCommMessage(prefix, text, distribution, target?, prio?, callbackFn?, callbackArg?)`. `prio` accepts ChatThrottleLib priorities: `"BULK"`, `"NORMAL"`, `"ALERT"`. The "infinite-length" guarantee is the reason to use AceComm over raw addon messages -- it auto-splits and reassembles with no extra work.

## Libstub The Embedding Layer

LibStub is the universal loader: it accepts one table per `(name, version)` pair. The canonical pattern:

```lua
local LibStub = LibStub
local MAJOR, MINOR = "CoB", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end
```

The lifecycle is "first writer wins": `:NewLibrary` returns `nil` for subsequent loads with the same name+version, letting addons skip redundant work. `:GetLibrary(name)` returns the current table; `:GetLibraryIterators()` walks all registered libs.

For Church of Beef, ship LibStub as `Libs/LibStub` and reference it from the addon's `.toc` before any other LibStub-aware library.

## Pkgmeta And The Curseforge Packager Workflow

`.pkgmeta` is a YAML file at the addon root. Production addons like WeakAuras2 use it to declare an `externals:` block that pulls libraries from remote repositories at packaging time:

```
externals:
  WeakAuras/Libs/LibStub: https://repos.curseforge.com/wow/libstub/trunk
  WeakAuras/Libs/AceComm-3.0: https://repos.curseforge.com/wow/ace3/trunk/AceComm-3.0
  WeakAuras/Libs/LibSharedMedia-3.0: https://repos.curseforge.com/wow/libsharedmedia-3-0/trunk/LibSharedMedia-3.0
  WeakAuras/Libs/LibDataBroker-1.1: https://github.com/tekkub/libdatabroker-1-1
  WeakAuras/Libs/LibDBIcon-1.0: https://repos.curseforge.com/wow/libdbicon-1-0/trunk
```

Church of Beef should ship with a `.pkgmeta` like the above and ship the addon's `.toc` with `## OptionalDeps: Ace3` so users with an Ace3 provider get the embedded copy if no Ace is present.

## Libsharedmedia 3 0 Shared Media Registries

LibSharedMedia registers media under five built-in types: `background`, `border`, `font`, `statusbar`, `sound`. API:

- `LSM:Register(mediatype, key, data[, langmask])` -- add a media entry
- `LSM:Fetch(mediatype, key[, noDefaultFallback])` -- look up by key (the canonical accessor)
- `LSM:HashTable(mediatype)` and `LSM:GetHash(mediatype, key)` -- enumeration helpers
- `LSM.RegisterCallback(LSM, "LibSharedMedia_MediaType", callback)` -- refresh hook

`data` for textures is a file path; for sounds it is the sound file name. Add-ons should never read `data` directly -- always use `Fetch` to honor the user's selection. Re-rendering on user pick is done by listening to `LibSharedMedia_<MediaType>` callbacks.

## Libdbicon 1 0 Minimap Buttons

LibDBIcon integrates with `LibDataBroker-1.1` to attach minimap buttons to data objects. The integration pattern:

```lua
local LDB = LibStub("LibDataBroker-1.1")
local LDBI = LibStub("LibDBIcon-1.0")
local dataobj = LDB:NewDataObject("MyAddonName", {
  type = "data source",
  text = "My Addon",
  icon = "Interface\\Icons\\INV_Misc_QuestionMark",
  OnClick = function(self, button) ... end,
  OnTooltipShow = function(tooltip) ... end,
})
LDBI:Register("MyAddonName", dataobj, db)
```

`Register` accepts an AceDB-style db and reads `db.profile.hide` (and similar) to remember visibility. `Lock`/`Unlock`/`Hide`/`Show`/`Toggle` are the standard controls; `Lock` makes the button fixed, `Unlock` makes it draggable. This is the canonical minimap pattern used by Details!, DBM, WeakAuras and most popular addons.

## Slash Command Architecture A Reference Pattern

AceConsole treats a slash command as a registered handler; the handler receives the raw chat text and uses `GetArgs` to split. A canonical moderator-friendly pattern:

```lua
function MyAddon:HandleSlash(input)
  if not input or input == "" then return self:PrintUsage() end
  local cmd, rest = self:GetArgs(input, 2)
  if cmd == "ladder" then self:Ladder(rest)
  elseif cmd == "promote" then self:Promote(rest)
  elseif cmd == "reset" then self:Reset(rest)
  elseif cmd == "config" then
    LibStub("AceConfigDialog-3.0"):Open("MyAddon")
  end
end
```

Each subcommand is a method that owns its own argument parsing and permission check. Permission checks live in dedicated functions so they can be reused by slash, GUI, and addon-channel callbacks:

```lua
function MyAddon:RequireOfficer(action, fn, ...)
  if not IsInGuild() or not (CanEditOfficerNote() or CanGuildPromote() or IsGuildLeader()) then
    return self:Print("officer-only: ", action)
  end
  return fn(...)
end
```

Wrap the call site, not the function body, so the function stays callable from non-slash entry points that have already verified authority.

## Officer Gated Settings Permission Apis

Blizzard exposes a small, stable set of APIs that gate guild moderation actions. The canonical gates are:

- `IsInGuild()` / `IsInGuild("player")` -- guild membership check.
- `CanEditOfficerNote()` -- permission to edit the officer note (rank 1 and 2 in most guilds).
- `CanEditPublicNote()` -- permission to edit the public note (all members).
- `CanGuildPromote()` -- permission to promote/demote.
- `CanRemoveFromGuild()` -- permission to kick.
- `CanGuildDemote()` -- permission to demote.
- `IsGuildLeader()` -- character is the guild master.
- `GuildRoster()` -- request roster updates; await `GUILD_ROSTER_UPDATE` before reading.

Officer-only settings in Church of Beef should gate actions at the action site using these APIs rather than parsing rank strings, which are localized and may not match UI conventions.

## Acedb Profile Copy Reset Ux Practical Patterns

The copy/reset UX in AceDB has three patterns:

1. **Profile drop-down** (default): AceDBOptions auto-adds a select widget with "Existing Profiles", "New", and "Copy From" choices.
2. **Char profile copy**: `db:CopyProfile("alt")` clones the current profile under the name "alt"; `db:SetProfile("alt")` switches.
3. **Reset**: `db:ResetProfile()` wipes the current profile back to defaults; preferred over `delete db.profile` because it preserves keys that are *not* in defaults.

For Church of Beef, three scopes suffice:

| Scope | Data | Reason |
|-------|------|--------|
| `char` | Ladder entries, personal scores | Per-character is the natural identity |
| `realm` | Guild ladder, officer-only settings | Shared across the player's characters on one realm |
| `profile` | UI preferences (sort order, time frame) | Each character wants its own UI |

Namespaces (`char` -> `realm` -> `profile`) compose naturally and keep officer-moderated ladder data shared while leaving personal UI per-character.

## Real World Reference Addons

WeakAuras2 is the canonical reference. Its `.pkgmeta` shows the production-grade `externals:` pattern, listing LibStub, AceComm, AceEvent, AceSerializer, AceTimer, LibSharedMedia, LibDataBroker, LibDBIcon, CallbackHandler, Chomp, LibCompress, LibDeflate, LibGetFrame, LibCustomGlow, LibRangeCheck, LibSpellRange, plus the right to disable library creation. It also embeds LibStub and a wide set of Ace3 libraries.

Details! embeds AceComm and LibDataBroker. It uses AceComm for cross-character data sync (the master/instance pattern) and LibDataBroker so its minimap button integrates with other broker displays (TitanPanel, ChocolateBar, Bazooka).

Deadly Boss Mods embeds LibDataBroker and LibDBIcon for its minimap button and uses AceComm sparingly. The minimap button pattern is the canonical example of how popular addons wire minimap UI.

Bagnon, Pawn, and WeakAuras all demonstrate the per-character SavedVariables split that the addon's `.toc` enforces with `## SavedVariablesPerCharacter: <name>` (or the equivalent).

## Synthesis Recommendations For Church Of Beef

The matrix below maps the v1 design questions to the Ace3 mechanism that resolves them, so the team knows exactly what changes when adopting Ace later.

| Question | v1 (Pre-Ace) | v2 (Adopt Ace) | Mechanism |
|----------|--------------|----------------|-----------|
| Where does data live? | `SavedVariables/ChurchOfBeef.lua` | `self.db.char.*`, `self.db.realm.*`, `self.db.profile.*` | AceDB scopes |
| How is the SV file structured? | Flat table | Nested `{ char = {...}, realm = {...}, profile = {...} }` | AceDB schema |
| How are options exposed? | Nothing | `/cob config` opens Blizzard panel | AceConfig + AceConfigDialog |
| How are slash commands registered? | Raw `SLASH_*` | `addon:RegisterChatCommand("/cob", handler, persist)` | AceConsole |
| How are events handled? | `CreateFrame` + `SetScript` | `addon:RegisterEvent("GUILD_ROSTER_UPDATE")` | AceEvent |
| How is the minimap button created? | Hand-rolled | `LibDBIcon:Register("CoB", dataobj, db)` | LibDBIcon + LibDataBroker |
| How is officer gating enforced? | None | `if not CanEditOfficerNote() then return end` | Blizzard APIs |
| How are media assets sourced? | Hardcoded | `LSM:Fetch("font", "Friz Quadrata")` | LibSharedMedia |
| How are modules loaded? | `if Mod.enabled then ...` | `addon:NewModule("Ladder", "AceEvent")` | AceAddon modules |
| How is SV reset? | Manual file edit | `/cob reset` or via Options panel | AceDB `ResetProfile` |

### Architecture Decision: Use AceDB's char/realm/profile scopes from v1

Adopting Ace3 wholesale from v1 is unnecessary; the team can introduce one Ace3 component at a time without rewriting existing code. The two high-value adoptions to do early are:

1. **AceDB** -- replace the v1 SavedVariables file with AceDB. This automatically yields per-character tables, profile selection UI, defaults merging, and child-namespace support. Migration is a single-file change.
2. **AceEvent + AceComm** -- replace raw `CreateFrame` event handlers with `RegisterEvent` / `RegisterComm`. Both run through CallbackHandler-1.0's well-tested dispatcher.

### Architecture Decision: Keep officer gating out of the addon object

Officer checks belong in the action layer, not in the data layer. A request from a non-officer should never even reach the `AceComm` listener; have the `RegisterComm` callback check `CanEditOfficerNote()` or the equivalent role gate and silently `return` if false. The chat response (silent vs. chat-frame output) can then be controlled per-command.

### Architecture Decision: Mirror AceDB's profile model in v1's SavedVariables

The cleanest path forward is to wrap the v1 SavedVariables table in the same shape AceDB would produce:

```lua
ChurchOfBeefDB = {
    char = {
        ladderEntries = { ... },
        lastSeen = 12345,
    },
    realm = {
        ladder = { ... },
    },
    profile = {
        ui = { sortBy = "score", timeFrame = "week" },
        notifications = { enabled = true, sound = "GlueScreenEnter" },
    },
    profileKeys = { "Default" },
    profiles = { Default = { ... } },
}
```

When the team adopts AceDB, the file format stays identical; the addon code only needs to change from `ChurchOfBeefDB.char.ladderEntries` to `self.db.char.ladderEntries`.

## Basis / Citations

### executive_insights (confidence: medium)

Assessment reasoning:
- The user asked for executive insights on architecture decisions for a WoW Classic addon (Church of Beef) using Ace3, LibStub/LibSharedMedia, LibDBIcon, etc., with per-character SavedVariables, slash commands, officer-gated settings, potential later adoption of Ace3 patterns. The provided field_answer contains a broad set of architecture recommendations covering addon-table shape, per-character storage, CLI command routing, officer gating, config panels, LibSharedMedia/LibDBIcon integration, Blizzard permission APIs, IoC via mixins, embedding via LibStub, external pkgmeta pattern, widget vocabulary, and AceDB profile UX.
- The completeness check should decide whether these insights address the expected field description. The answer appears to touch on most major arch


### why_ace3_in_one_paragraph (confidence: low)

Reasoning: The field_answer gives a brief description of Ace3 usage, LibStub versioning, and the basic AceAddon lifecycle, tailored to a hypothetical Church of Beef scenario. However, the user query requests a broad synthesis of Ace3 conventions (AceAddon, AceDB, AceConfig, AceConfigDialog, AceDBOptions, AceConsole, AceEvent, AceComm), LibStub/LibSharedMedia patterns, UI norms for options tables, profile scopes in AceDB, minimap integration with LibDBIcon, and architecture decisions for a social guild addon with per-character SavedVariables, officer gating, and potential later adoption of Ace. The field_answer omits almost all of these topics beyond a minimal lifecycle and generic embedding approach. Therefore, it does not comprehensively address the described field requirements. Without e


### aceaddon_3_0_the_addon_lifecycle (confidence: low)

Assessment reasoning:
- The field_description appears to cover Ace3 lifecycle, module system, and several other architecture aspects (AceDB, LibStub, LibSharedMedia, minimap integration, per-character SavedVariables, etc.).
- The provided field_answer focuses on AceAddon lifecycle (OnInitialize, OnEnable, OnDisable) and module instantiation/enablement, but it omits many other required aspects (LibStub usage nuances, other libraries, LibSharedMedia, AceConfig options patterns, SavedVariables scope details, profile handling, minimap icon integration, etc.).
- Because the answer does not comprehensively address all aspects implied by the field description/query, the completeness should be false.
- Regarding excerpts: there are no excerpts provided in this evaluation input to verify support. T


### aceconsole_3_0_slash_command_registration (confidence: medium)

Assessment reasoning:
- The field answer discusses AceConsole 3.0 slash command registration, including the RegisterChatCommand signature, default persistence behavior, and the GetArgs usage. It also provides a concrete pattern for Church of Beef (per-command handlers, arg extraction), and notes about persistence affecting command visibility when officer disables the addon mid-event. 
- The field description appears to expect guidance on AceConsole 3.0 slash command registration and related architectural patterns (per-command handlers, arg routing, persistence semantics). The answer directly addresses these aspects and includes practical implications for addon behavior in an officer-gated setting.
- However, there are no explicit citations or excerpts provided to verify these claims agains


### acedb_3_0_saved_variables_done_right (confidence: low)

Assessment reasoning:
- The field_description asks for a broad survey of Ace3 conventions, LibStub ecosystem, LibSharedMedia, AceConfig UI norms, AceDB profile patterns, UI panels, minimap integration, and architecture decisions for a Church of Beef-like addon. It also asks to favor primary docs from specific sources.
- The provided field_answer focuses almost entirely on AceDB 3.0 usage, scopes, a per-character SavedVariables approach, and profile APIs, with concrete examples for Church of Beef. It does not address: Ace3 addon framework conventions (AceAddon, AceConsole, AceEvent, etc.), AceConfig/UI norms in detail, LibStub/versioning semantics, LibSharedMedia registration, minimap/LibDBIcon integration, how AceConfig options tables render in UI, slash command architecture, officer-gated


### aceconfig_3_0_aceconfigdialog_3_0_settings_panels (confidence: high)

Evaluation notes:
- The field answer provides a comprehensive overview of AceConfig/ACEConfigDialog usage in 3.0, including how to register options, how AddToBlizOptions works, and how slash commands route to the dialog. It also enumerates widget types and typical live-read patterns (Args-as-functions) and tabbed layout via childGroups. It mentions per-character/per-realm/per-account UX considerations via AceDBOptions profile handling, which aligns with the field focus on settings panels for a social guild addon.
- The answer appears to cover the expected aspects of settings panels (data-driven options, registration, dialog opening, widget vocabulary, patterns for live reads, tabbed layout, and per-profile UX). It does not discuss LibStub versioning, LibSharedMedia, or deep integration spe


### aceevent_3_0_and_acecomm_3_0_events_and_channels (confidence: high)

Assessed field for completeness: The answer provides core API surfaces for AceEvent (RegisterEvent/UnregisterEvent, RegisterMessage/UnregisterMessage, SendMessage, UnregisterAllEvents/Messages) and notes on dispatch via CallbackHandler-1.0, which aligns with AceEvent 3.0 usage. For AceComm, it covers addon-channel messaging on top of C_ChatInfo.SendAddonMessage and RegisterAddonMessagePrefix, and API surface (RegisterComm, SendCommMessage) including distribution, target, prio, and callback args. It mentions ChatThrottleLib priorities and the implication of infinite-length messages via AceComm. This aligns with expectation to describe events, channels, and messaging behavior relevant to addon-to-addon communication and per-character SavedVariables/Ace-like patterns in Classic-era addons. Po


### libstub_the_embedding_layer (confidence: high)

Assessment:
- Field content: The answer describes LibStub as the universal loader, shows the canonical LibStub:NewLibrary pattern with MAJOR/MINOR, explains the 'first writer wins' lifecycle, and mentions usage guidance (ship LibStub in Libs/LibStub and reference from toc before other LibStub-aware libraries).
- Completeness check: The field seems to address embedding LibStub, the typical lifecycle, and a practical usage note for a Church of Beef addon. It covers core concepts (versioned majors, NewLibrary returning nil on subsequent loads, GetLibrary and iterators) and a recommended embedding location. For a field about the embedding layer and pattern usage in Classic era addon architecture, this appears to reasonably satisfy the expected content: how LibStub is loaded/initialized, how ve


### pkgmeta_and_the_curseforge_packager_workflow (confidence: medium)

Reasoning: The field answer provides a concrete .pkgmeta example with externals mapping and recommends shipping a .toc with OptionalDeps: Ace3. This aligns with common CurseForge packaging workflows and the idea of embedding libraries when Ace3 is available via provider. The field description appears to focus on packaging workflow for Wow addons and Ace3 ecosystem, and the answer covers externals usage and a UX pattern (OptionalDeps) that matches the described workflow. However, there are no excerpts provided to verify against; thus, we cannot confirm excerpt-supported evidence. Based on this, completeness is true (the answer directly answers the packaging workflow aspect) but supported is false (no excerpts to corroborate).



### libsharedmedia_3_0_shared_media_registries (confidence: medium)

Assessment notes:
- Field description likely asks for an overview of LibSharedMedia registries, typical media types, core API, data expectations, and refresh callbacks; it may also touch on usage patterns (e.g., fetching rather than direct data access).
- The provided field_answer enumerates the five built-in types, lists key API calls (Register, Fetch, HashTable, GetHash, RegisterCallback), describes the data format for textures and sounds, and emphasizes using Fetch for user selections and listening to LibSharedMedia_<MediaType> for re-rendering on changes. 
- This content aligns with typical LibSharedMedia usage and covers the essential aspects (types, API surface, data semantics, and callback mechanism). It does not heavily discuss embedding/versioning details, integration with Ace/Lol


### libdbicon_1_0_minimap_buttons (confidence: medium)

Assessment reasoning:
- Field name: libdbicon_1_0_minimap_buttons
- Field answer provided: describes LibDBIcon integration with LibDataBroker, including a code example for creating a data object and registering with LibDBIcon, notes that Register uses an AceDB-style db and respects db.profile.hide, and mentions standard control methods (Lock/Unlock/Hide/Show/Toggle). Claims canonical pattern used by popular addons.
- Completeness check:
  - The answer covers the core integration pattern (data object creation via LibDataBroker-1.1, registration with LibDBIcon-1.0), expected interactions (db.profile.hide for visibility), and common controls (Lock/Unlock/Hide/Show/Toggle). It aligns with typical LibDBIcon usage and mentions cross-addon prevalence.
  - Potential gaps (not fatal to completeness


### slash_command_architecture_a_reference_pattern (confidence: medium)

Evaluation reasoning:
- The field_description pertains to slash command architecture patterns for Ace3-based addons, including command parsing, permissions, and modular subcommand handling. 
- The provided field_answer shows a canonical pattern for handling slash commands with GetArgs, a dispatcher for subcommands, separate permission checks, and a wrapper (RequireOfficer) to centralize authority checks for multiple entry points. 
- This content directly addresses typical slash-command architecture decisions, subcommand ownership, and permission wrapping, aligned to AceConsole usage, modular design, and reuse across slash/GUI/channel callbacks. 
- On completeness: the answer covers command dispatch, per-subcommand handlers, argument parsing, and centralized permission checks, which matches


### officer_gated_settings_permission_apis (confidence: medium)

Assessment notes: The field answer provides a list of Blizzard guild-related APIs that gate guild moderation actions and advises gating at the action site rather than parsing ranks. It covers typical officer-gated settings patterns (IsInGuild, IsInGuild("player"), CanEditOfficerNote, CanEditPublicNote, CanGuildPromote, CanRemoveFromGuild, CanGuildDemote, IsGuildLeader, GuildRoster) and gives a practical integration hint (gate at action site). It aligns with the field goal of describing permission APIs for officer-gated settings. Potential gaps to verify with sources: exact API availability/behavior across WoW Classic / TBC Classic versions, any changes to Lib/ACE patterns, and whether additional API shims or guard conditions are needed for per-character SavedVariables and officer-only acti


### acedb_profile_copy_reset_ux_practical_patterns (confidence: medium)

Assessment reasoning:
- The field_answer presents three concrete UX patterns for AceDB profile management (Profile drop-down with Existing/New/Copy From, Char profile copy via db:CopyProfile, and Reset via db:ResetProfile) and aligns them with a three-scope model (char, realm, profile) suitable for a social guild ladder addon like Church of Beef. It discusses data locality and governance (per-character vs realm vs profile) and ties into officer-m gated settings. The answer appears to satisfy the likely field description of practical patterns for copied/reset UX and per-scope data organization.
- Completeness judgment: The answer directly enumerates practical patterns and maps data scopes with rationale. It does not miss evident UX patterns for AceDB copy/reset (these three) and provides ra


### real_world_reference_addons (confidence: low)

Reasoning: The field_answer provides a few concrete examples (WeakAuras2, LibStub, AceComm, LibDataBroker, LibDBIcon) and mentions per-character SavedVariables, but the user query asks for a broad, architecture-focused synthesis of Ace3 conventions, LibStub ecosystem, LibSharedMedia, AceConfig/UI norms, profile patterns, minimap integration patterns, and how these apply to a social guild addon (Church of Beef) with per-character SavedVariables, officer-gated settings, etc. The field answer does not comprehensively cover Ace3 addon lifecycle, configuration patterns (AceConfig, AceConfigDialog, AceDBOptions), profiles (char/realm/account scopes, copy/reset UX), or the broader ecosystem guidance across wowace.com / warcraft.wiki.gg / curseforge. It also asserts canonical references without pr


### synthesis_recommendations_for_church_of_beef (confidence: high)

Assessment notes:
- The field_description asks for synthesis/recommendations for Church of Beef in the context of Ace3 adoption and architecture decisions.
- The field_answer provides a concrete synthesis mapping pre-Ace to Ace-based mechanisms and several architecture decisions, including AceDB scope adoption, officer gating, profile mirroring, and recommended incremental integration steps. It also includes code examples showing expected data structure under AceDB.
- The content covers data lifecycle (where data lives), UI exposure, command handling, events, minimap integration, gating, media sourcing, module loading, and SavedVariables structure, plus explicit architecture decisions about incremental adoption and migration strategy. This aligns with the requested synthesis focusing on ar


