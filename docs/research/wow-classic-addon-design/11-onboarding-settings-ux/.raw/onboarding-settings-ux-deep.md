# executive_summary

- **Ace3 is the shared foundation**: All major Classic-era addons (DBM, Details!, ElvUI, TomTom, Questie, WeakAuras, HandyNotes) inherit their options panel, slash-command handling, profile manager, and minimap-icon plumbing from the Ace3 framework hosted at wowace.com/projects/ace3.
- **Slash commands are the canonical entry point**: Every well-behaved Ace3 addon registers a short command (`/dbm`, `/details`, `/wa`, `/ec`, `/handynotes`, `/way`) and uses the convention that **empty input opens the GUI, non-empty input is parsed as a CLI**.
- **Profiles are first-class**: `AceDBOptions-3.0` ships a ready-made "Profiles" group that any addon embeds with one line to gain per-character profiles, copy/reset, and a delete dialog ([executive_summary[0]] [45]).
- **LibDBIcon-1.0 replaces hand-rolled minimap buttons**: Right-click context menu, drag-to-position, and a per-addon hide toggle come for free; addons like Questie and Details! register their own buttons through this single library ([executive_summary[1]] [2]).
- **Progressive disclosure via `order` + visibility flags**: The `AceConfig-3.0` schema supports `order`, `disabled`, `hidden`, `dialogHidden`, `dialogChild`, `guiHidden`, `cmdHidden`, and `hidden`-callable functions to gate advanced settings behind simpler top-level controls.
- **Onboarding ranges from wizard-style to zero-config**: ElvUI and Questie ship first-run wizards; DBM enables all encounter mods by default; Details! shows an empty meter; WeakAuras ships empty with import-string UX; GTFO has no UI at all.
- **Import/export uses text strings for sharing, SavedVariables for persistence**: WeakAuras pioneered the "share-string" import. ElvUI/DETAILS_PROFILE_ENABLED, DBM, and TomTom use per-character `SavedVariables` for portability.
- **Best practice: register with Blizzard's Interface Options via `AddToBlizOptions`**: This guarantees the addon appears in the standard `Interface > AddOns` list and is the recommended discoverability path.

---

# 1_ace3_framework_the_shared_ux_substrate

Ace3 is a modular framework where each subsystem (config, DB, GUI, console, event, hooks) is an independent embeddable library. Addons `:Embed()` only the parts they need.

### 1.1 AceConfigDialog - the GUI window

```lua
-- Canonical registration (from Ace3 docs)
LibStub("AceConfig-3.0"):RegisterOptionsTable("MyAddon", optionsTable)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MyAddon", "My Addon")
```

Key methods ([1_ace3_framework_the_shared_ux_substrate[0]] [17]):

- `AddToBlizOptions(appName, name, parent, ...)` — "Add an option table into the Blizzard Interface Options panel. You can optionally supply a descriptive name to use and a parent frame to use, as well as a path in the options table."
- `Open(appName [, container][, ...])` — "Open an option window at the specified path."
- `SelectGroup(appName, ...)` — "Selects the specified path in the options window."
- `SetDefaultSize(appName, width, height)` — Default window dimensions.
- `Close(appName)` / `CloseAll()` — Programmatic close.

### 1.2 AceConfigCmd - the slash handler

`AceConfigCmd:CreateChatCommand(command, appName)` registers a slash command and dispatches to `AceConfigCmd:HandleCommand(command, appName, input)`, which parses `set` / `get` / `toggle` syntax against the options table.

### 1.3 AceConfigRegistry - the central registry

`AceConfigRegistry:RegisterOptionsTable(appName, options, skipValidation)` makes the table visible to dialogs, the slash handler, and Blizzard's options frame. `NotifyChange(appName)` fires when the table is mutated externally so the GUI can refresh.

### 1.4 AceConsole - slash registration

`AceConsole-3.0` provides ([1_ace3_framework_the_shared_ux_substrate[1]] [47]):

- `RegisterChatCommand(command, func, persist)` — "Register a slash command … `persist=false` means the command is soft disabled/enabled."
- `GetArgs(str, numargs, startpos)` — tokenizes quoted strings and item links.
- `Print(...)` / `Printf(...)` — formatted output to chat.

Sample boilerplate from the docs:

```lua
MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceConsole-3.0")
MyAddon:RegisterChatCommand("myaddon", "ChatCommand")
function MyAddon:ChatCommand(input)
  if not input or input:trim() == "" then
    LibStub("AceConfigDialog-3.0"):Open("MyAddon")
  else
    LibStub("AceConfigCmd-3.0"):HandleCommand("myaddon", "MyAddon", input)
  end
end
```

### 1.5 AceConfig options-table reference

Types ([1_ace3_framework_the_shared_ux_substrate[2]] [43]): `execute`, `input`, `toggle`, `range`, `select`, `multiselect`, `keybind`, `header`, `color`, `group`, `description`.

Common fields:

| Field | Purpose |
|-------|---------|
| `name` | Display label |
| `desc` | Tooltip / help text |
| `type` | Widget kind (see above) |
| `get(info)` | Read current value |
| `set(info, val)` | Write value |
| `order` | Sort order (lower = first; default 100) |
| `hidden` / `disabled` | Visibility / enable flags |
| `dialogHidden` / `dialogChild` | Dialog-frame-only behavior |
| `guiHidden` / `guiChild` | GUI-frame-only behavior |
| `cmdHidden` / `cmdChild` | Slash-command-only behavior |

Inheritance: groups can define `set`, `get`, `func`, `confirm`, `validate`, `disabled`, `hidden` once and have all child nodes inherit unless overridden.

### 1.6 AceDB + AceDBOptions - profiles & options table

`AceDB-3.0` manages `SavedVariables` and provides named, character-scoped profiles. `AceDBOptions-3.0:GetOptionsTable(db)` returns a ready-made options-table fragment that, when merged into an addon's own options, gives the user a full Profiles sub-panel (select, copy from character, reset, delete) without writing any GUI code. Any Ace3 addon can adopt this with a one-liner.

---

# 2_addon_by_addon_patterns

### 2.1 DBM (Deadly Boss Mods)

- **Slash command**: `/dbm` opens the main GUI (boss mods list, options). DBM-Core registers `AceConfigDialog:AddToBlizOptions("DBM", "DBM")` so it appears under `Interface > AddOns`.
- **First-run philosophy**: zero-config; every encounter's mod is enabled by default, so the player gets value without opening the options. Progressive tuning happens later.
- **Minimap**: registered through LibDBIcon-1.0; right-click exposes quick toggles and "Options".
- **Per-encounter options table**: a top-level `group` with `dialogHidden=false`, `guiHidden=false`, `cmdHidden=false`; child groups per instance/raid with `order` controlling display.

### 2.2 Details! Damage Meter

- **Slash command**: `/details` opens the roll window and config.
- **First-run philosophy**: zero-config; empty meter is shown immediately.
- **Minimap**: registered with LibDBIcon-1.0.
- **Config panel**: structured as sections (Plugins, Profiles, Options). `AceConfigDialog` is opened by `LibStub("AceConfigDialog-3.0"):Open("Details")` after registration.

### 2.3 WeakAuras2

- **Slash commands**: `/wa` and `/weakaurascmd` (alias), plus `/wa help` prints help text.
- **Import/export**: pioneered the share-string model - users click "Copy import string", paste into chat, recipients click "Import", paste, and confirm. Strings encode a deflated Lua table.
- **Onboarding**: empty-state UI - shows "You have no auras" with a prominent `New -> Aura/Icon/etc.` button. No wizard.
- **Minimap**: none - lives entirely inside the Blizzard options panel.
- **Custom editor**: when an addon's options outgrow AceConfigDialog's row-of-rows layout, WeakAuras ships its own visual editor (tree of auras, drag-target previews). This is the canonical example of "AceConfigDialog is too narrow, fall back to a custom UI".

### 2.4 ElvUI

- **Slash commands**: `/ec` (or `/elvui`) opens the config; deep-linking via `/ec <group> <sub>` jumps directly to a section. Per Tukui changelog: "You can now open a sub-section of the ElvUI config directly through the /ec command. This requires that you supply the path to the config."
- **First-run wizard**: Install UI shows on first install - resolution + class + role + layout preset. Highly recommended over manual config.
- **Minimap**: LibDBIcon entry; right-click opens config menu.
- **Profile management**: per-character SavedVariables with import/export from the Profiles tab.

### 2.5 Questie

- **Slash command**: `/questie` opens options.
- **First-run wizard**: prompts user to pick the expansion (Classic, TBC, WotLK, Cata) so it can load the right quest database.
- **Minimap**: LibDBIcon entry.
- **Options**: tabbed with `AceConfigDialog`; multiple sub-tables merged into one config.

### 2.6 TomTom

- **Slash commands**: `/way <x> <y> [desc]` to set a waypoint (Classic-era supports this); `/tomtom` opens options. Persistent waypoints are first-class.
- **First-run philosophy**: zero-config; user discovers the slash command from the tooltip.
- **Minimap**: LibDBIcon entry.
- **Profiles**: per-character SavedVariables.

### 2.7 HandyNotes

- **Slash command**: `/handynotes` opens options.
- **Plugin model**: HandyNotes ships as a framework; data plugins (Battlegrounds, treasures, rares) are separate addons that register through HandyNotes' plugin API and inherit HandyNotes' config-tab grouping.
- **Minimap**: LibDBIcon entry.

### 2.8 GTFO

- **Slash command**: none - no GUI at all. Config is via SavedVariables editing or its built-in micro-menu accessed through the character frame.
- **First-run philosophy**: pure zero-config. Works out of the box; alerts fire only when the player stands in something bad.
- **Minimap**: none.
- **Why no GUI**: GTFO's purpose is to be invisible until it shouts at you - any configuration would conflict with that minimalism.

---

# 3_first_run_onboarding_patterns

| Addon | Pattern | First-run surface |
|---|---|---|
| ElvUI | **Wizard** (resolution -> class -> layout) | On-screen overlay |
| Questie | **Wizard** (expansion select) | Dialog |
| DBM | **Zero-config** | None (defaults on) |
| Details! | **Zero-config** (empty meter) | Slash command + `?` help |
| WeakAuras | **Zero-config** (empty list) | "You have no auras" prompt |
| TomTom | **Zero-config** | Slash command only |
| HandyNotes | **Zero-config** | Slash command only |
| GTFO | **Zero-config** | None (no UI) |

The wizard pattern (ElvUI, Questie) trades one interruption for a much higher chance the addon is configured correctly for the chosen class / content. Zero-config addons (Details!, GTFO, WeakAuras) ship defaults the user is expected to refine only if needed.

---

# 4_minimap_buttons_custom_vs_libdbicon

Three approaches are common:

1. **Hand-rolled minimap button** - deprecated by Blizzard's "Hide Minimap Button" option for the in-game Minimap cluster. Used by older addons.
2. **LibDBIcon-1.0** - a tiny shared library providing a right-click context menu, drag-to-position, and per-addon hide toggle. Questie, Details!, DBM all delegate their minimap icon to this library ([4_minimap_buttons_custom_vs_libdbicon[0]] [2]).
3. **No minimap button** - WeakAuras, GTFO, and a handful of others skip the minimap button entirely in favor of a slash command and the Blizzard options panel. Reduces clutter but requires the user to read the docs.

LibDBIcon's value is making the addon discoverable without forcing the user to type a slash command.

---

# 5_profile_management

`AceDBOptions-3.0:GetOptionsTable(db)` returns a one-liner options table fragment that, when merged into the addon's own options, gives the user a complete Profiles sub-panel: select a profile, copy from another character, reset to default, or delete. Every Ace3 addon that wants profile support can adopt this with a single line - and most of the addons in this study (ElvUI, DBM, Details!, Questie, TomTom) do exactly that.

Profile copy/reset patterns:

- ElvUI uses per-character SavedVariables, with import/export from the Profiles tab.
- DBM uses per-character SavedVariables for boss settings, with reset and per-character copy.
- Details! supports per-character profiles plus import/export.
- Questie uses AceDB profiles with the standard `AceDBOptions` UI.

---

# 6_slash_command_vs_gui_sync_mechanism

The slash command and the GUI stay in sync because the same option handlers back both. The Ace3 Cmd handler walks the options tree and finds the matching arg, then calls the same `get`/`set` callbacks that the GUI uses. So when a player types `/dbm option RangeCheck enabled`, the toggle in the GUI updates immediately, and vice versa.

The empty-input convention is universal: typing the slash command with no arguments opens the GUI. Typing it with arguments runs the CLI parser. This is the single most important UX convention in the Classic-era addon ecosystem.

---

# 7_reducing_configuration_overwhelm

Concrete techniques used by the studied addons:

1. **`order`-based sorting** - Surface the most-used settings first (`order=1`); bury advanced settings under higher numbers or under an "advanced" toggle.
2. **Visibility flags** - Use `dialogHidden`, `guiHidden`, `cmdHidden` to keep a setting visible only in the surface the user is in.
3. **Sensible defaults** - DBM enables all mods; ElvUI ships class-specific defaults; GTFO works out of the box; WeakAuras shows an empty-state prompt rather than a dead list.
4. **Inline help** - `desc` text on each option shows a tooltip explaining what the option does. AceConfigDialog renders this automatically.
5. **First-run wizard** - ElvUI and Questie walk the user through setup; the wizard can be skipped.
6. **Disable-by-default for noisy plugins** - HandyNotes data plugins (treasures, rares) ship disabled; users opt in to the ones they want.
7. **Reset / restore defaults** - `AceDBOptions` exposes "Reset profile to defaults" with confirmation; many addons (ElvUI, WeakAuras) add their own "Restore factory defaults" button.

---

# 8_synthesis

Comparing the eight addons across three dimensions - onboarding philosophy, configuration surface, and platform integration - reveals two distinct design philosophies and one unifying pattern.

**Onboarding philosophy diverges sharply.** ElvUI and Questie ship wizard-style first-run experiences because their configurations are too complex for safe defaults: an ElvUI unit-frame layout must match the user's class, role, and screen resolution to be useful, so the wizard asks up front and applies the right preset. By contrast, Details!, GTFO, and WeakAuras ship zero-config first runs because their defaults are inherently safe - the user is expected to use the addon first and configure only if needed. DBM straddles both: no wizard, but defaults so aggressive (every encounter mod enabled) that the addon is functional from minute one.

**Configuration surface scales with feature complexity.** All eight addons use the same Ace3 plumbing - `AceConfigDialog` + `AceConfigRegistry` + `AceConsole` + `LibDBIcon` - but the depth of their options tables varies enormously. DBM's options table is shallow (a few top-level groups, each per-instance), ElvUI's is medium (modules per UI element), and WeakAuras' options outgrew AceConfigDialog entirely and shipped its own visual editor. This reveals a hard limit of the framework: once an addon's options exceed a few hundred controls, `AceConfigDialog`'s row-of-rows layout becomes unreadable, and the addon must fall back to a hand-rolled UI. WeakAuras is the canonical example.

**Platform integration converges on `AddToBlizOptions` + LibDBIcon + slash commands.** Every addon in the study registers with Blizzard's Interface Options via `AceConfigDialog:AddToBlizOptions` (the most important single line for first-run discoverability), uses LibDBIcon-1.0 for the minimap button, and exposes at least one slash command with the empty-input-opens-GUI convention. This convergence is enforced by the Ace3 framework itself - the framework's APIs *are* the convention.

**The unifying pattern: minimum viable discoverability.** Any Classic/TBC Classic addon should (1) register with `AddToBlizOptions` so it appears in the standard options list, (2) provide a short slash command that opens the GUI when typed with no arguments, (3) register a LibDBIcon minimap button, (4) ship reasonable defaults so the addon is useful out of the box, and (5) gate advanced settings behind an "advanced" toggle using `guiHidden`/`cmdHidden` visibility. These five patterns are the floor; everything above is style.

---
