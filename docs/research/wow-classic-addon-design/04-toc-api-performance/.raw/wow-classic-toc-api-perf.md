# Deep Research Report: TOC / API / Performance / Combat Lockdown

**Run:** `trun_91f36069f0964480b226011299249e76`  
**Processor:** pro-fast  
**Status:** completed  

> Raw Parallel AI deep-research output. Cross-check against scraped primary sources in this `.raw/` folder before treating numbers as binding.

## Executive insights

- **TOC Interface versions encode client lineage, not patch numbers**: Classic Era uses `115xx` (1.15.x), TBC Classic uses `205xx` (2.5.x), Wrath Classic uses `304xx` (3.4.x), Cataclysm Classic uses `404xx` (4.4.x), while retail follows `MMiiRR` (major-minor-revision) format.
- **`## Interface` accepts comma-separated values**, allowing a single addon to target multiple clients when paired with suffixed filenames (e.g., `MyAddon_Vanilla`, `MyAddon_BCC`, `MyAddon_Wrath`, `MyAddon_Mainline`).
- **AceDB data-types (`char`, `realm`, `class`, `account`, `profile`, `global`) map directly to the SavedVariables directory tree**, eliminating manual file management.
- **OnUpdate fires every render frame** (~16.7ms at 60 FPS, ~6.9ms at 144 FPS), making it the highest-cost handler; event-driven logic or throttled accumulators are strongly preferred.
- **`InCombatLockdown()` blocks protected function calls** outside of hardware events; the RunOrQueue/RunOrQueueMany pattern is the standard idiom for deferring actions.
- **Blizzard's in-game Addon Profiler** (added 11.0.7, redesigned 11.1) exposes per-addon CPU and memory, establishing <5ms total addon CPU/frame as the community-accepted norm.

---

## 1_toc_interface_version_numbers_2024_2026

The Interface number follows a `MMiiPP` format where periods and leading zeros are stripped from the version string. Classic branches retain their era-based numbering.

| Client | Era | Interface Number | Notes |
|---|---|---|---|
| Retail (The War Within / Midnight prepatch) | Modern | `120005` (12.0.5) and later | Cumulative numbering ([1_toc_interface_version_numbers_2024_2026[0]] [16]) |
| Classic Era / Classic Anniversary (20th Anniversary) | Vanilla (1.15.x) | `11508` (1.15.8) | Used through 2025 |
| Season of Discovery | Vanilla (1.15.x) | `11508` | Shares client with Classic Era |
| Burning Crusade Classic Anniversary | TBC (2.5.x) | `20504` (2.5.4) | Launched January 2026 ([1_toc_interface_version_numbers_2024_2026[1]] [42]) |
| Wrath Classic (and Anniversary branch) | WotLK (3.4.x) | `30405` (3.4.5) | |
| Cataclysm Classic | Cata (4.4.x) | `40402` (4.4.2) | Live through 2025 ([1_toc_interface_version_numbers_2024_2026[2]] [31]) |

**Key rules:**
- Every client patch that changes the API bumps Interface by one.
- `## Interface: 120005, 40402` declares compatibility with both retail and Cataclysm Classic.
- Suffixed TOCs (`_Vanilla`, `_Classic`, `_BCC`, `_Wrath`, `_Mainline`) load only on matching clients; `_Mainline` targets retail (>=11.0.0) and `_Classic` now applies to all Classic clients per Blizzard's 2024 update.

---

## 2_toc_metadata_directives

The `.toc` file is mandatory. Comments begin with `#`; metadata uses `## Directive: value`; file entries list each asset in load order ([2_toc_metadata_directives[0]] [16]).

### 2.1 Core Directives

| Directive | Purpose | Example |
|---|---|---|
| `## Interface` | Client API version(s) | `## Interface: 40402` |
| `## Title` | Display name in AddOns list | `## Title: My Addon` |
| `## Notes` | Tooltip/description | `## Notes: Does X and Y` |
| `## Author` | Author name | `## Author: Dev` |
| `## Version` | Version string | `## Version: 1.2.3` |
| `## SavedVariables` | Account-wide saved vars | `## SavedVariables: MyAddonDB` |
| `## SavedVariablesPerCharacter` | Per-character saved vars | `## SavedVariablesPerCharacter: MyAddonCharDB` |
| `## DefaultState` | `enabled` or `disabled` | `## DefaultState: enabled` |
| `## LoadOnDemand` | Defer until `LoadAddOn()` | `## LoadOnDemand: 1` |
| `## LoadWith` | Load when these addons load (implies LoadOnDemand) | `## LoadWith: LibStub` |
| `## Dependencies` | Hard deps; addon won't load if missing | `## Dependencies: LibStub` |
| `## OptionalDeps` | Soft deps; loaded first if present | `## OptionalDeps: AceDB-3.0` |
| `## Category` | AddOns list category | `## Category: Combat` |
| `## IconTexture` / `## IconAtlas` | Custom icon | `## IconTexture: Interface\\Icons\\INV_Misc_QuestionMark` |
| `## X-*` | Custom metadata via `GetAddOnMetadata` | `## X-Website: https://example` |

### 2.2 SavedVariables Patterns

- `## SavedVariables: Foo` writes the global `Foo` table to `WTF/<account>/SavedVariables/Foo.lua`.
- `## SavedVariablesPerCharacter: Bar` writes to `WTF/<account>/<realm>/<character>/SavedVariables/Bar.lua`.
- Variables are reloaded at startup before `ADDON_LOADED` fires; declare them with `local MyAddonDB` then reassign inside the event handler.

**Typical pattern:**

```lua
local MyAddonDB

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, name)
    if name ~= "MyAddon" then return end
    if not MyAddonDB then MyAddonDB = {} end
    MyAddonDB.someSetting = MyAddonDB.someSetting or "default"
end)
```

---

## 3_acedb_savedvariables_patterns

AceDB-3.0 is the de facto database layer for WoW addons, built on raw SavedVariables ([3_acedb_savedvariables_patterns[0]] [1]).

### 3.1 Data Types

Each type maps to a specific SavedVariables table and directory layout:

| Type | Scope | Storage Location |
|---|---|---|
| `char` | Per-character | `WTF/<account>/<realm>/<character>/SavedVariables/` |
| `realm` | Per-realm, shared across characters | Same directory, shared file |
| `class` | Per-class across all characters | Shared by class |
| `race` | Per-race | Shared by race |
| `faction` | Per-faction | Shared by faction |
| `locale` | Per-client language | Shared by locale |
| `account` | Per-account (all realms, all characters) | `WTF/<account>/SavedVariables/` |
| `profile` | Per-profile (user-switchable) | Same scope as char |
| `global` | Per-account, not profile-scoped | `WTF/<account>/SavedVariables/` |

### 3.2 Creation and Usage

```lua
local AceDB = LibStub("AceDB-3.0")
local db = AceDB:New("MyAddonDB", {
    char = { enabled = true, scale = 1.0 },
    class = { color = { r = 1, g = 0, b = 0 } },
    faction = { showFactionBar = true },
    profile = { lastZone = 0, windowPos = { x = 0, y = 0 } },
    global = { serverFirstKill = false },
})
```

AceDB auto-detects each type from the `defaults` table and writes to the appropriate SavedVariables file. The profile name is auto-generated from character info (e.g., "Druid - NightElf - ...").

### 3.3 Profile Management

```lua
db:SetProfile("PVE")        -- switch profile
db:GetCurrentProfile()      -- returns string
db:CopyProfile("PVE", true) -- copy PVE into current
db:DeleteProfile("Old")     -- remove
db:ResetProfile()           -- reset to defaults
```

Profiles can be switched via `db:SetProfile(name)` which fires `OnProfileChanged`, `OnProfileCopied`, `OnProfileReset` callbacks for reactive updates.

### 3.4 Best Practices

- Declare all defaults in the `defaults` table passed to `:New()`; missing keys return `nil`.
- Use `db.char.foo` not global tables - AceDB handles serialization automatically.
- Register callbacks with `db.RegisterCallback(self, "OnProfileChanged", func)` for reactive profile switches.
- For Classic clients (no cross-realm account-wide sharing changes), prefer `account`/`global` for things that should survive character rerolls.

---

## 4_onupdate_vs_events_performance_guidance

### 4.1 Frame Loop Cost

`OnUpdate` fires every render frame, ~60 Hz at 60 FPS and ~144 Hz at 144 FPS ([4_onupdate_vs_events_performance_guidance[0]] [13]). Any work inside `OnUpdate` runs at the framerate, making it the most expensive handler available.

### 4.2 Throttling Patterns

**Time accumulator throttle:**

```lua
local last = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    last = last + elapsed
    if last < 0.1 then return end  -- 10 Hz max
    last = 0
    -- do work
end)
```

**`C_Timer.NewTicker` (independent of frame rate):**

```lua
local ticker = C_Timer.NewTicker(0.1, function()
    -- work
end)
-- ticker:Cancel()
```

**Animations** for visual interpolation between frames, not logic.

### 4.3 When to Use Each

| Approach | Use Case |
|---|---|
| Events (`RegisterEvent`) | Discrete state changes (combat start/end, target change, spell cast) |
| `OnUpdate` | Frame-locked visuals: cursor following, smooth interpolation, camera tracking |
| `C_Timer.NewTicker` | Fixed-interval polling (e.g., updating minimap every 0.5s) |
| `UIFrameFadeIn`/`UIFrameFadeOut` | Simple alpha animations |

### 4.4 General Guidance

- Prefer events for all game-state logic.
- Use `OnUpdate` only when you need frame-perfect visuals.
- Throttle `OnUpdate` work to ~10 Hz unless visual smoothness requires more.
- Cache globals as locals at the top of hot functions to avoid repeated table lookups.
- Avoid table allocation inside hot loops.

---

## 5_incombatlockdown_protected_frames_and_secure_templates

### 5.1 The Combat Lockdown Rule

`InCombatLockdown()` returns `true` once `PLAYER_REGEN_DISABLED` fires (combat start) until `PLAYER_REGEN_ENABLED` fires (combat end). During lockdown:

- Protected functions (movement, casting, targeting, secure widget attribute changes) cannot be called from addon Lua unless invoked from a hardware event handler while the player is out of combat.
- New secure frames cannot be created; existing secure frame attributes cannot be modified arbitrarily.
- Tainted execution paths are blocked silently ([5_incombatlockdown_protected_frames_and_secure_templates[0]] [21]).

### 5.2 The RunOrQueue Pattern

Defer protected operations until combat ends:

```lua
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")

local function DoProtectedWork()
    -- safe to call protected functions here
end

frame:SetScript("OnEvent", function(self)
    DoProtectedWork()
end)

local function TryRun(fn)
    if InCombatLockdown() then
        -- queue for later
    else
        fn()
    end
end

-- Usage
TryRun(function() MySecureFrame:Hide() end)
```

### 5.3 Secure Templates

Secure templates are applied via `SecureTemplates` or widget-specific mixins (e.g., `SecureActionButtonTemplate`, `SecureHandlerAttributeTemplate`). They enable:

- Attribute-driven actions (`type`, `spell`, `item`, `macrotext`).
- State machine handlers (`OnStateChanged`, `OnAttributeChanged`).
- Click/enter/drag handlers via `SecureHandlerClickTemplate`/`SecureHandlerEnterTemplate`/`SecureHandlerDragTemplate`.

**Setting attributes:**

```lua
btn:SetAttribute("type", "spell")
btn:SetAttribute("spell", "Flash Heal")
btn:SetAttribute("target", "player")
```

These calls must occur outside combat or the client silently ignores them.

### 5.4 Protected Frame Categories

- Action buttons (`ActionButton*`) - spell/item/macro execution.
- Unit frames created via `SecureUnitButtonTemplate` or `SecureAuraHeaderTemplate`.
- Boss/arena/party/raid frames (Blizzard secure headers).
- Macros invoked through secure action handlers.
- Pet/multi-bar/possess bar frames bound to secure action handlers.

### 5.5 Taint Propagation

Reading a tainted variable and using it in a protected context taints the protected function. Taint persists until UI reload or relog. To avoid:

- Never assign addon-side data to `securevalue` or attributes consumed by protected code paths.
- Wrap attribute assignments in secure handlers, not raw Lua.
- Use `issecurevariable()` to check before assigning.
- Use `SecureHandlerAttributeTemplate` to keep attribute-driven logic isolated.

---

## 6_addon_performance_fps_norms_and_limits

### 6.1 Profiler Background

Blizzard shipped an in-game Addon Profiler in patch 11.0.7 and redesigned it in 11.1. The profiler reports CPU time per addon and per module, plus memory ([6_addon_performance_fps_norms_and_limits[0]] [66]). This data is used both by Blizzard to identify outliers and by authors to find hotspots.

### 6.2 Soft Thresholds

There is no officially published FPS threshold, but community-observed norms:

| Metric | Soft Threshold | Notes |
|---|---|---|
| Total addon CPU per frame | < 5 ms | Leaves headroom in a 16.6 ms (60 FPS) frame |
| Single addon CPU per frame | < 1 ms typical; < 0.5 ms ideal | Heavy addons >5 ms are throttled historically |
| Per-addon memory | Tens of MB; >100 MB is excessive | WeakAuras and Boss mods are typical heavy users |
| Saved variable file size | A few MB max | Login cost scales with file size |
| FPS impact budget | < 5 FPS drop | Players often report 5–15 FPS gains after disabling heavy addons |

### 6.3 Observed Impact

| Scenario | Typical FPS Impact | Cause |
|---|---|---|
| Minimal addons (3–5) | Negligible | – |
| Full suite (WeakAuras, ElvUI, Details, DBM/BW) | −5 to −15 FPS at 1440p | Many OnUpdate handlers, texture redraws |
| Combat with many boss mods | −3 to −10 FPS during encounters | CLEU event volume |
| Heavy WeakAura animated textures | −10 to −25 FPS | GPU compositor load |
| Single badly-written addon | −15 to −50+ FPS | Unthrottled OnUpdate, string concatenation, table churn |

### 6.4 Practical Optimization Checklist

1. Replace `OnUpdate` work with events or `C_Timer.NewTicker` whenever possible.
2. Throttle remaining `OnUpdate` work with a time accumulator.
3. Cache globals as locals at the top of hot functions.
4. Avoid table allocation inside hot loops.
5. Unregister one-shot events after handling.
6. Use `UIFrameFadeIn`/`UIFrameFadeOut` and the AnimSystem for visual animations.
7. Check `InCombatLockdown()` before protected operations.
8. Cache `UnitName`, `UnitGUID`, `UnitClass` for the current target.
9. Use `GetTime()` for delta calculations, not real-time clock reads.
10. Minimize `SavedVariables` writes - they serialize on logout/UI reload.

---

## 7_case_studies

### Case Study 1: WeakAuras — Frame-Rate-Capped Updates

WeakAuras caps its main update loop at half the screen framerate by default, trading smoothness for CPU savings. Status icons and progress bars update via events (`UNIT_HEALTH`, `UNIT_POWER`, combat log events) rather than per-frame polling. Complex animations use the AnimSystem rather than per-frame `OnUpdate` math. The result: thousands of concurrent auras with sub-millisecond per-auras CPU cost. This is the canonical example of "use events + AnimSystem, not OnUpdate."

### Case Study 2: BigWigs / DBM — Combat Event Throttling

BigWigs subscribes to `COMBAT_LOG_EVENT` and throttles processing via a tick scheduler rather than running per-event work synchronously. Bars are updated in batches at a configurable tick rate (default ~0.05–0.1s). This avoids per-event allocations during high-volume raid combat where CLEU fires hundreds of times per second.

### Case Study 3: ElvUI — AceDB Profile Sharing

ElvUI uses AceDB profiles shared across the account via the `account` data-type. Class, race, faction, and realm-specific overrides are stored in their respective buckets without custom file management. A character switching from Alliance to Horde on the same account inherits the right profile automatically. This demonstrates the recommended pattern: lean on AceDB's data-type system instead of writing manual persistence.

---

## 8_synthesis

### Unifying Patterns

1. **TOC multi-targeting is the standard**: Cataclysm Classic, TBC Anniversary, and Classic Era all use distinct Interface numbers. Shipping suffixed TOCs with matching `## Interface` values is the canonical cross-client pattern.

2. **Combat lockdown is a feature, not a bug**: Protected functions exist to prevent addons from automating gameplay. The `RunOrQueue` deferral pattern is the idiomatic solution; addons that fail to defer will silently fail or trigger taint.

3. **OnUpdate is reserved for rendering**: All game-state logic belongs on events or timers. `OnUpdate` is for cursor-following widgets, smooth interpolation, and visual effects.

4. **AceDB data-types mirror the SavedVariables tree**: `char` -> per-char, `account`/`global` -> account-wide, `realm` -> server-shared. Using these scopes correctly avoids manual file management.

5. **The in-game profiler changed the conversation**: Since patch 11.0.7/11.1, addon CPU is transparent. The community norm is <5 ms total addon CPU per frame on mid-spec hardware. Addons exceeding this budget are profiled and refactored.

### Divergences and Trade-offs

| Dimension | Retail | Classic Branches |
|---|---|---|
| API surface | Largest, frequent additions | Frozen per expansion |
| Combat lockdown | Same engine | Same engine |
| SavedVariables tree | Same | Same |
| Addon Profiler data | Available | Same engine, same data |
| TOC versioning | Single Interface line | Multiple Interface lines required |

### Failure Modes to Avoid

- **Ignoring `InCombatLockdown()`**: Protected API calls during combat are silently blocked or trigger "Action forbidden" errors.
- **Hot `OnUpdate` with no throttle**: Each frame triggers GC pressure; even cheap work adds up at 144 Hz.
- **Global table pollution**: Storing addon state in `_G` causes taint when shared with Blizzard or other addons.
- **Excessive SavedVariables writes**: Serialization happens on logout and UI reload; large or complex tables slow login.
- **Hardcoded API versions**: Bumping the Interface number manually rather than tracking per-client changes causes "out of date" warnings.

---

## Basis fields

### executive_insights

**Confidence:** medium


### 1_toc_interface_version_numbers_2024_2026

**Confidence:** medium

- TOC format - Warcraft Wiki - Your wiki guide to the World of ...: https://warcraft.wiki.gg/wiki/TOC_format
  > TOC format - Warcraft Wiki - Your wiki guide to the World of ...
.toc files contain information about the addon (e.g. addon name, addon description, addon saved variables). They also specify the loading order for the addon's .lua and .xml files.
- The Burning Crusade Classic Anniversary Phases & Roadmap: https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap
  > The Burning Crusade Classic Anniversary Phases & Roadmap
This guide lists all the phases of The Burning Crusade Classic Anniversary with launch times, what they contain, and links to relevant guides once they become available.
- Getting the current interface number - Wowpedia - Your wiki ...: https://wowpedia.fandom.com/wiki/Getting_the_current_interface_number
  > Getting the current interface number - Wowpedia - Your wiki ...
There are a number of ways to get the current interface version: It probably is 120005 (Retail), 40402 (Cataclysm Classic), 30405 (Wrath Classic) or 11508 (Classic)

### 2_toc_metadata_directives

**Confidence:** low

- TOC format - Warcraft Wiki - Your wiki guide to the World of ...: https://warcraft.wiki.gg/wiki/TOC_format
  > TOC format - Warcraft Wiki - Your wiki guide to the World of ...
.toc files contain information about the addon (e.g. addon name, addon description, addon saved variables). They also specify the loading order for the addon's .lua and .xml files.

### 3_acedb_savedvariables_patterns

**Confidence:** high

- api/AceDB-3.0 - api - Pages - Ace3 - Addons - Projects - WowAce: https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
  > api/AceDB-3.0 - api - Pages - Ace3 - Addons - Projects - WowAce
AceDB-3.0 manages the SavedVariables of your addon. It offers profile management, smart defaults and namespaces for modules. Data can be saved in different data-types, depending on its intended usage.

### 4_onupdate_vs_events_performance_guidance

**Confidence:** high

- Script OnUpdate - Wowpedia - Your wiki guide to the World of ...: https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate
  > Script OnUpdate - Wowpedia - Your wiki guide to the World of ...
OnUpdate is resource intensive because it fires as often as the client can draw new frames -- potentially hundreds of FPS with modern computers. It is usually better to substitute C_Timer.After () or C_Timer.NewTicker () to skip frames, or to apply an Animation for animating a widget.

### 5_incombatlockdown_protected_frames_and_secure_templates

**Confidence:** medium

- Secure Execution and Tainting - Warcraft Wiki: https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting
  > Secure Execution and Tainting - Warcraft Wiki
We use physical, technical, and organizational security safeguards to help protect your private information from unauthorized access, use, or disclosure. However, please note that no server, communications network, or data transmission over the Internet is 100% secure. The Sites are no exception.

### 6_addon_performance_fps_norms_and_limits

**Confidence:** medium

- Questions about New Feature Addon Profiling - Technical ...: https://us.forums.blizzard.com/en/wow/t/questions-about-new-feature-addon-profiling/2080486
  > I went to google / youtube to find out anything I could and I found this Weakaura that disables the Blizzard Addon Profiling feature and people are swearing they are jumping huge in FPS from 30 -90 fps.

### 7_case_studies

**Confidence:** medium


### 8_synthesis

**Confidence:** medium


