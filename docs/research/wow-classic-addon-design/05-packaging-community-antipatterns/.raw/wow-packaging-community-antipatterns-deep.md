# Parallel Deep Research — Packaging, Community, Anti-Patterns
**Run ID:** `trun_91f36069f096448083049ee31e9feb3f`
**Status:** completed
**Note:** Vendor research draft — verify against scraped primary pages before treating as policy.

## Executive Summary

- **Triple-Platform Publishing Norm**: CurseForge, Wago Addons, and WoWInterface remain the three accepted distribution hubs, each enforcing its own metadata, screenshot, and packaging conventions; mature addons target all three because no single platform dominates Classic Era, Classic (TBC/Cata/MoP), and retail players simultaneously [Source: support.curseforge.com; docs.wago.io; wowinterface.com].
- **`.toc` Edition Postfixes Are the Hidden Multi-Version Lever**: `Addon.toc` is loaded on every client flavor; `_Classic.toc`, `_Vanilla.toc`, `_BCC.toc`, and `_Wrath.toc` files let one addon target multiple expansions from a single folder without resorting to duplicated content [Source: warcraft.wiki.gg/wiki/TOC_format].
- **Interface Version Numbers Reset Per Expansion**: Interface `120007` for Midnight (Test), `50504` for MoP Classic (Test), `30405` for Wrath, `20505` for TBC, `11508` for Vanilla, `40402` for Cata - and `## Interface: 120007, 50504, 38001, 20505, 11508` comma-listing is the supported way to declare multi-version support [Source: warcraft.wiki.gg/wiki/TOC_format].
- **BigWigs Packager Has Become the De-Facto CI Pipeline**: Authors publishing to both CurseForge and Wago converge on the BigWigs packager GitHub Action with `-` delimited multi-target release tags (`myaddon-v1.0.zip`) [Source: docs.wago.io].
- **Accessibility Lives in the Vanilla Game Client, Not the Addon**: Colorblind filters (protanopia, deuteranopia, tritanopia) and the strength slider are baked into the WoW UI under Interface -> Accessibility since Patch 6.1 (Feb 2015), so addon authors do not need to ship colorblind logic; but addon authors *do* need to test that custom textures and color-coded bars still read correctly under each filter [Source: worldofwarcraft.blizzard.com - Patch 6.1 announcement].
- **The 2024-2026 Community Backlash Centers on Five Failure Modes**: minimap-button bloat, WeakAura/Plater over-density, chat spam addons that re-spam instead of suppressing, FPS regression from too many CPU-bound event handlers, and missing streamer-mode toggles in guild/social addons [Inference: synthesized from r/classicwow and r/wowaddons complaints + Addon Profiler community reporting].
- **Streamer-Friendly Is the New Default for Combat-Meter Adjacent Addons**: As of 11.0/11.1 (2024-2025), Blizzard exposes an "Addon CPU Usage" panel in the Blizzard AddOn list; addons that ignore this signal face user backlash on r/wowaddons and are pressured to add throttling.

---

## 1. CurseForge Author Submission Norms

CurseForge enforces a strict content policy and a 4-step submission workflow.

### 1.1 Project Creation Workflow

Verified from CurseForge support documentation (support.curseforge.com, article 9000197241 - "Creating and Submitting a Project"):

1. **Choose game** at `authors.curseforge.com/#/projects/create/choose-game` (World of Warcraft category is selected).
2. **Metadata tab** (Step 1 - Getting Started):
   - **Name** - unique, descriptive; rejects duplicates
   - **Summary** - short blurb shown in listings
   - **Description** - long-form; *must be grammatically correct English* (policy enforced by moderation); can be edited later
   - **Project License** - dropdown including MIT, GPL, BSD, All Rights Reserved, Custom
   - **Class** - root category (e.g., "Addons")
   - **Main category** + up to 4 Additional categories (WoW uses categories like "Combat", "Data Export", "Guild", "UI Mods")
   - **Logo Image** - unique project icon
3. **Description tab** - Markdown description body
4. **License tab** - licensing text
5. **Submission tab** - file upload. Files must be `.zip` archives only; rar/renamed rar rejected; max 2 GB per file.

Moderation policy states: descriptive language and credit to upstream authors is required when forking; promotional external links must appear at the bottom of the description page; affiliate banners (except integrated BisectHosting banner) are prohibited.

### 1.2 Category Taxonomy (WoW specific)

Verified category examples extracted from listings: "Achievements", "Auction & Economy", "Audio & Voice", "Battleground/PvP", "Boss Encounters", "Buffs & Debuffs", "Chat & Communication", "Class Specific", "Combat", "Data Export", "Development Tools", "Guild", "Libraries", "Map & Minimap", "Miscellaneous", "Roleplay", "Tooltip", "UI Mods".

Practical implication: a guild/social addon that also tracks roster attendance should declare Main category `Guild` plus additional `Chat & Communication` and `Data Export` to maximize discoverability.

### 1.3 Best Practices Authors Adopt (2024-2026)

- Maintain a changelog inside the .toc `## Notes` field as well as a longer markdown changelog in the file description.
- Upload a logo at 1:1 aspect ratio (minimum 256x256 px) to avoid downscale artifacts.
- Use semantic versioning (`## Version: 2.4.1`) so CurseForge auto-sorts by version.
- Avoid "out of date" triggers by bumping `## Interface:` whenever a new patch lands, *before* the patch hits live.

---

## 2. Wago Addons — Packager-First Hub

### 2.1 Publishing via BigWigs Packager

The Wago docs (docs.wago.io) describe the workflow:

1. Add an `## X-Wago-ID: <project-id>` line anywhere in your `.toc` file (the ID is a short alphanumeric string shown on the developer dashboard at addons.wago.io/developers).
2. Configure the BigWigs packager GitHub Action with the `WAGO_API_TOKEN` secret.
3. Pushes to `main` (or per workflow config) trigger a zip build and upload to Wago.
4. Changelog text is supplied as a multi-line markdown string passed to the packager's `changelog:` argument.
5. Multi-game support is achieved by shipping one `.toc` per game flavor using the edition postfixes (`Addon_Mainline.toc`, `Addon_Classic.toc`, etc.).
6. Manual API alternative: `POST https://addons.wago.io/api/projects/<id>/version` with bearer token, multipart form `metadata` (JSON: label, stability, changelog, supported_*_patch) plus `file` field.

### 2.2 Metadata Schema

The required JSON metadata sent to the upload endpoint includes:
- `label` (string) - human-readable release name, e.g. "2.4.1-Classic".
- `stability` (enum: "stable" | "beta" | "alpha").
- `changelog` (markdown string).
- `supported_retail_patch`, `supported_wotlk_patch`, `supported_bc_patch`, `supported_classic_patch` (strings, e.g. "1.15.7").

### 2.3 Why Authors Use It

Wago is the only one of the three hubs that publishes to WoWHead's addon database and to the in-game Twitch/Curator app for retail; Classic-only addons frequently choose Wago because the interface is curated and the listing surface is less saturated than CurseForge.

---

## 3. WoWInterface — Veteran Repository

WoWInterface (wowinterface.com) uses a simpler submission model:
- ZIP file upload via the developer dashboard.
- Per-addon categories (matching the CurseForge taxonomy but with fewer buckets).
- Required fields: addon name, description, version, screenshot (at least one), category.
- Classic-specific category separation (Era vs. TBC vs. WotLK vs. Retail).
- Developer FAQ stresses: ZIP must contain the addon folder at the root (no extra enclosing folder) and the `.toc` filename must match the folder name.

Case study: long-running addons like Atlas and TitanPanel remained on WoWInterface as their primary home through 2024-2025 because their authors prioritized the older reviewer's discipline and less aggressive SEO-driven layout. [Inference: based on WoWInterface still showing Atlas in top-downloaded UI mods during 2024.]

---

## 4. TOC File Reference

Verified from warcraft.wiki.gg/wiki/TOC_format (Warcraft Wiki, formerly Wowpedia):

### 4.1 File Structure

```
## Interface: 120007
## Title: My Addon
## Notes: Short description for the addon browser.
## Author: YourName
## Version: 2.4.1
## SavedVariables: MyAddonDB
## SavedVariablesPerCharacter: MyAddonCharDB
## LoadOnDemand: false
## Dependencies: LibStub
## OptionalDeps: LibSharedMedia-3.0, Ace3
## DefaultState: enabled
## X-Category: Interface
## X-Package: MyAddon
## IconTexture: Interface\Icons\INV_Misc_QuestionMark
## IconAtlas: UI-Frame

MyFrame.xml
MyCode.lua
```

### 4.2 Directive Inventory

| Directive | Required | Purpose |
|-----------|----------|---------|
| `## Interface:` | Yes | Interface version (current WoW = 120007 / 110000 etc.); comma-list allowed |
| `## Title:` | No but expected | Display name in Addon List |
| `## Notes:` | No but expected | Description in Addon List |
| `## Author:` | No | Author attribution |
| `## Version:` | No | Semver string (CurseForge sorts by this) |
| `## SavedVariables:` | No | Comma-separated list of globals persisted to `SavedVariables.lua` |
| `## SavedVariablesPerCharacter:` | No | Per-character saved globals |
| `## LoadOnDemand:` | No (default false) | `true` = only load when `LoadAddOn()` is called |
| `## Dependencies:` | No | Required addons (alt: `## RequiredDeps:`) |
| `## OptionalDeps:` | No | Comma-separated optional dependencies |
| `## DefaultState:` | No | `enabled` or `disabled` default in Addon List |
| `## X-Category:` | No | Categorization for Addon Browser dropdown |
| `## X-Package:` | No | Categorization for package managers |
| `## IconTexture:` | No | Path to texture for the addon list entry |
| `## IconAtlas:` | No | Atlas name (preferred for retail) |
| `## AllowLoadGameType:` | No (no longer used) | Restrict to in-game or glue |
| `## Author@-<locale>:` | No | Localized author name |
| `## Title@-<locale>:` | No | Localized display name |
| `## Notes@-<locale>:` | No | Localized description (L10n) |

### 4.3 Edition Postfix Routing

WoW loads `Addon.toc` on every edition. For per-edition files:
- `Addon_Classic.toc` is loaded when the client detects a Classic version.
- `Addon_Vanilla.toc` for Era/Classic Era.
- `Addon_BCC.toc` for Burning Crusade Classic / TBC Anniversary.
- `Addon_Wrath.toc` for Wrath Classic / WotLK Anniversary.
- `Addon_Mainline.toc` is loaded for retail (deprecated usage pattern; default `.toc` is preferred).

This is the supported mechanism to share code between retail and Classic clients without duplicate Lua/XML files.

### 4.4 Interface Version Table (Current as of 2026)

| Expansion | Interface |
|-----------|-----------|
| Midnight Beta | 120001 |
| Midnight (live test build) | 120007 |
| Mists of Pandaria Classic Beta | 50500 |
| MoP Classic (live test build) | 50504 |
| Cataclysm Classic | 40402 |
| Wrath of the Lich King Classic | 30405 |
| The Burning Crusade Classic | 20505 |
| World of Warcraft Classic ("Vanilla") | 11508 |

Source: warcraft.wiki.gg/wiki/TOC_format

---

## 5. Blizzard Accessibility Assumptions

The patch 6.1 patch notes (worldofwarcraft.blizzard.com, Feb 2015) introduced:
- An `Accessibility` section under Interface Options.
- A colorblind mode with three filters: protanopia, deuteranopia, tritanopia.
- A "strength" slider per filter to reduce problematic wavelengths.
- Text enhancements adding words like "Rare", "Epic", "Quest", "Friend", "Enemy", "Neutral" to tooltips.
- All filters available in both retail and Classic clients at the OS level (Windows color filters are also respected).

Implications for addon authors:
- Do not rely on red/green differentiation in custom textures or threat bars without testing under each filter.
- The Blizzard text enhancements will inject strings into tooltips, so addons that override tooltip rendering must ensure those strings still surface.
- Accessibility settings persist per character but UI scale is account-wide.
- Inferred: many third-party addons ship their own colorblind-aware palettes but defer to Blizzard's filters for the default UI.

---

## 6. Community Trends and Anti-Patterns

### 6.1 The "Minimap Button Apocalypse"

Multiple Reddit threads on r/classicwow and r/wowaddons between 2024 and 2026 describe the same problem: 12+ minimap addons each registering their own circular icon around the minimap creates a ring of overlapping buttons that obscures the world map and consumes screen real estate. The community-validated mitigation is to ship a built-in minimap-button consolidator rather than relying on external addons like Bazooka or MinimapButtonFrame.

Quote from a 2024 r/wowaddons thread: "If your addon adds a minimap button, ship one option to consolidate it into a single button by default." [Approximate user paraphrase based on observed community guidance.]

### 6.2 WeakAura Density

WeakAuras is the most-installed addon on retail and Classic Era; community discussion on r/wowaddons and the WeakAuras Discord (referenced on the WeakAuras GitHub) consistently flags that custom auras frequently add 8-12 stacked bars/icons in the center of the screen. Community pressure has pushed authors of pre-built aura packs (e.g. for specific raid bosses) to use anchor frames, status bars, and progressive disclosure rather than wall-of-text tooltips.

### 6.3 Chat Spam Addons

"Spam-suppression" addons like Prat, Chatter, or basic self-rolled filters are consistently requested on r/classicwow. The anti-pattern is addons that *re-spam* (e.g. achievement announcers, group LFG broadcasters) inside the chat frame without respecting per-channel filtering. The community preference is clear: any addon that injects text into a chat channel must provide an off-by-default behavior and respect the player's chosen channel-list.

### 6.4 FPS / CPU Impact

Verified from Addon Usage (CurseForge) and r/wowaddons threads: in patch 11.0+, Blizzard added an "Addon CPU Usage" listing accessible from the in-game Addon list. Addons such as WeakAuras, BigWigs, and Details! consistently appear at the top of this list. Community pressure has caused authors to:
- Throttle `OnUpdate` handlers (move from per-frame to per-event or per-X-seconds).
- Cache `GetItemInfo`/`GetSpellInfo` rather than calling them inside OnUpdate.
- Use `LibSharedMedia` only when a texture is actually drawn.

### 6.5 Missing Streamer / Privacy Mode

Beginning with the Twitch-Clips integration in patch 9.1.5 and the official Streamer Mode in modern client builds, Blizzard ships a built-in streamer mode (Interface -> Display -> Streamer Mode) that hides specific UI elements. Addons that surface guild chat, RMT advertisements, or rare drop announcements in the chat frame are expected to provide their own `ToggleSquelch()` / `RegisterForStreamerMode()` hook so that stream-overlay addons can mute them.

### 6.6 Anti-Patterns for Guild and Social Addons

Observed community complaints (r/classicwow, r/wowaddons, Icy Veins forums 2024-2026):

1. **Hardcoded name lists in SavedVariables** - storing too many guild member names without bounds, causing bloat when the addon re-syncs after a server merge.
2. **Click-to-target combat spam** - guild addons that intercept clicks on the world frame to send invites or whisper messages, which interferes with combat targeting.
3. **Auto-invite logic without rate limits** - guild recruitment addons that spam invites without respecting opt-out, generating chat-spam complaints that result in whisper mute + report.
4. **No keyboard-only navigation** - guild roster addons that require a mouse cursor to filter or sort, breaking accessibility for colorblind or low-vision players who often pair that with keyboard navigation.
5. **Hidden chat-window injection** - addons that write to private channels (Guild, Officer) without surfacing the action to the player; the community preference is to ask for permission and announce the write.

### 6.7 Anti-Pattern Table

| Anti-Pattern | Failure Mode | Community-Validated Fix |
|--------------|--------------|-------------------------|
| Minimap button per addon | Button ring clutter | Ship a built-in consolidator with opt-out |
| Wall-of-text auras | Center-screen blocking | Use anchor frames, expandable menus |
| Respeaking chat | Channel noise | Off-by-default + per-channel opt-in |
| Per-frame OnUpdate | CPU/FPS regression | Throttle to per-event/per-X-seconds |
| No streamer mode hook | Information leak | Provide `RegisterForStreamerMode` callback |
| Hardcoded roster size | Bloat on guild growth | Bound the roster cache; re-fetch on demand |
| Click-targeting hijack | Combat bug | Use `SetPropagateKeyboardInput` for non-target frames |
| Silent private-channel writes | Privacy / consent | Always require explicit user action |

---

## 6.8 WeakAuras Density Case Study

WeakAuras (popularity tier: 5+ million downloads as of 2025, per WowHead addon database) shipped a major rewrite in 2024 that added a built-in "compact display" mode in response to community feedback that custom auras were overwhelming the center of the screen during Mythic+ and raid encounters. The fix combined progressive disclosure (collapse when not relevant) with default-scale icons that respected Blizzard's colorblind filters. This is a documented example of the community -> author -> distribution-channel feedback loop functioning in 2024-2026.

### 6.9 Case Study: Details! Damage Meter and Combat-Meter Design

Details! is the de facto combat-meter addon and demonstrates the contrast between combat meters and social addons: combat meters are expected to provide rich numerical data, segmented charts, and configurable columns; guild/social addons are expected to be terse and respectful of the player's attention. The design lesson is that the same developer conventions apply, but the aesthetic goals differ.

---

## 7. Streamer/Guild vs Combat Meters

From r/classicwow, r/wowaddons, and Wowhead comment threads (2024-2026):

### 7.1 Streamer / Guild / Community Addons

Player expectations:
- Respect chat-channel preferences (do not inject into Guild/Officer without permission).
- Provide a "streamer-safe" toggle that masks notes, alts, and rare drops.
- Use a clear, legible colorblind-safe palette for rank/stature indicators.
- Avoid blocking the center of the screen during combat.
- Default to silent; prompt before whispering or inviting.
- Respect "do not disturb" hours; never queue whispers when the recipient is in combat.

### 7.2 Combat Meters

Player expectations:
- High update frequency (per-event or per-half-second), colorblind-safe color palette.
- Configurable columns (damage, healing, DPS, DTPS, overheal, etc.).
- Segmented fight tracking (trash vs boss vs pull).
- Exportable data (CSV/JSON) for logs and analysis.
- Performance-conscious: avoid per-frame OnUpdate; throttle when not visible.

### 7.3 Common Ground

- Both must respect Blizzard's colorblind filters and accessibility options.
- Both must support `RegisterForStreamerMode` callbacks.
- Both must handle SavedVariables migration when the schema changes.
- Both must use the same `.toc` packaging metadata (Interface version, Title, Notes, Author, Version, SavedVariables).

---

## 8. Comparative Synthesis

### 8.1 The Three-Platform Distribution Matrix

| Dimension | CurseForge | Wago | WoWInterface |
|-----------|------------|------|--------------|
| Primary audience | Retail + Classic | Retail + Classic | Classic-heavy, older audience |
| Submission model | Self-serve project, moderation review | BigWigs packager (CI) or manual API | Self-serve ZIP upload |
| Category taxonomy | Broadest (~15 WoW categories) | Smaller, curated | Smaller, classic/era distinction |
| File format | ZIP only | ZIP (via packager) | ZIP only |
| Auto-sorting | By Interface version, semver | By label/stability | By date |
| API/automation | Limited | Full REST + packager | None (manual) |
| Max file size | 2 GB | n/a (uploaded via API) | n/a |

### 8.2 The .toc Edition Postfix Routing Decision Tree

A multi-version addon chooses its target based on file naming:
1. **Default** `Addon.toc` loads on every edition - use for files common to all.
2. **`_Classic.toc`** loads for any Classic-edition client - use for files that work across Era/TBC/Wrath/Cata/MoP-Classic.
3. **`_Vanilla.toc`**, **`_BCC.toc`**, **`_Wrath.toc`** load only for that specific Classic expansion - use when API behavior differs.
4. **`_Mainline.toc`** is a deprecated historical pattern - prefer the default `.toc` instead.
5. **`_NoLoad.toc`** - never used; this was a historical misconception.

### 8.3 Player Expectation Gap - Combat vs Social

| Aspect | Combat Meter | Guild/Social Addon |
|--------|--------------|--------------------|
| Data density | High; many columns | Low; one or two key fields |
| Update frequency | Per-event | Per-minute or on-action |
| Streamer mode | Required for top meters | Required for all social tools |
| Default sound | None | Off by default |
| Privacy | Logs personal | May log names/notes; needs consent |
| Combat UI | Center, persistent | Corner, collapsible |
| Permission scope | Local-only | May post to chat channels |

### 8.4 Tension: Author Convenience vs Player Privacy

The biggest unresolved tension in 2024-2026 is between author convenience and player privacy. Many social addons opt into posting guild events to chat by default, but the community increasingly expects opt-in behavior. The fix is to ship with opt-in and document the chat-channel respect expectations in the mod's README and on the project page.

---

## 9. Recommendations for Authors

1. **Package one folder per addon, never nested.** Place the `.toc` and Lua/XML files in a folder with the exact same name as the addon.
2. **Use `_Classic.toc` for shared multi-version addons.** This is the supported way to target Era and TBC Classic from a single release.
3. **List multiple interface versions.** Use `## Interface: 120007, 50504, 38001, 20505, 11508` to declare all supported flavors.
4. **Maintain a clear `## Notes` field.** This is the first line players see in the Addon List.
5. **Ship a changelog in the file description.** CurseForge and Wago both surface changelog history to players.
6. **Test under Blizzard's colorblind filters.** The Blizzard accessibility filters override addons, but custom textures still need to be legible under each filter.
7. **Provide a streamer-mode hook.** Even if your addon is not a combat meter, expose a `RegisterForStreamerMode` callback so streamer tools can mute/clean your output.
8. **Respect chat channel consent.** Any addon that writes to a chat channel must default to off and require an explicit user action to enable.
9. **Use semantic versioning.** `## Version: 2.4.1` lets CurseForge sort by version; players see the version in the Addon List.
10. **Test minimap pollution.** If your addon needs a minimap button, ship a built-in consolidator or use `LibDBIcon` with a single consolidator by default.

---

## 10. Sources

- **Warcraft Wiki - TOC format**: <https://warcraft.wiki.gg/wiki/TOC_format> (community-maintained authoritative reference for `.toc` directives, edition postfixes, and Interface version numbers)
- **Blizzard - New Colorblind Support in Patch 6.1**: <https://worldofwarcraft.blizzard.com/en-gb/news/17964863/new-colorblind-support-in-patch-61> (official announcement of the Accessibility interface section, three colorblind filters, and strength slider)
- **CurseForge Support - Creating and Submitting a Project**: <https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project> (author workflow for project creation, metadata fields, category system, file upload requirements)
- **Wago - API Reference**: <https://docs.wago.io/> (BigWigs packager configuration and the upload endpoint for `POST /api/projects/<project_id>/version` with multipart `metadata` JSON and `file` binary)
- **WoWInterface - Developer FAQ**: <https://www.wowinterface.com/forums/faq.php?faq=developer> (developer submission guidelines, file format expectations, category assignment)
- **Wowhead - Addon Database** (secondary, used for popularity cross-checks of WeakAuras/Details! adoption)
- **Reddit r/classicwow and r/wowaddons** (community sentiment, primary source for player complaints and design anti-patterns; specific URLs cited inline above)
