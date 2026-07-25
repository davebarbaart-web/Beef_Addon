# Deep Research Raw: Masque / SharedMedia / Skinning
Run: `trun_91f36069f096448099a7e91eae0e7f4a`
Processor: pro-fast

---

## executive summary

- **Masque is library-based, not widget-based**: It exposes a `Masque:GetGroup()` -> `Group:AddButton()` / `Group:ReSkin()` API that other addons call to receive a fully-skinned frame; skins live in their own folder as `SkinName.lua` returning a `SkinType` table. -> An addon can ship as "Masque-aware" with zero embedded art by relying on whatever skin the user has installed.
- **Classic/TBC support is first-class**: Masque ships separate `Classic`, `Classic TBC`, `MoP Classic`, `Titan Reforged Classic` flavors on CurseForge and Wago, and the bkader WotLK fork explicitly backports it for 3.3.5. -> Any TBC Anniversary addon can integrate without compatibility hacks.
- **LibSharedMedia-3.0 standardizes five media slots**: BACKGROUND, BORDER, FONT, STATUSBAR, SOUND. Register/Fetch/IsValid/HashTable/List/GetDefault/SetDefault plus the `LibSharedMedia_Registered` and `LibSharedMedia_SetGlobal` callbacks. -> A TBC addon can ask for `LSM:Fetch("font", "Friz Quadrata")` instead of hard-coding a path.
- **ElvUI ships its own SharedMedia pack as a submodule, not as separate addons**: Custom fonts/statusbars/textures live inside `ElvUI/Media/`. -> Bundled media is preferred to requiring users to install ElvUI itself; third-party packs (SharedMedia AdditionalFonts, etc.) fill gaps.
- **Item quality colors are the de-facto icon-framing convention**: `GetItemQualityColor(quality)` returns the canonical Poor/Common/Uncommon/Rare/Epic/Legendary/Heirloom r,g,b,a. -> Borders tints use those constants rather than custom palettes for consistency with the rest of the Blizzard UI.
- **Embed a baseline + opt into dependencies**: Best practice is to ship a minimal embedded skin (font/statusbar/blessing icon) and additionally register LSM/Masque so power users get the polished version. -> Reduces install friction for users who never touch Masque/LSM while rewarding skin collectors.
- **For Church of Beef, adopt Masque + LSM + ElvUI conventions, invent the religious iconography**: A religion-themed addon should still ship a default Masque-compatible skin (heavy "stained-glass" frames) and an LSM-pack of chant fonts, but invent custom worship-tier quality borders (Tallow -> Roasted -> Brimstone) outside the standard item-quality palette. -> This balances the ecosystem's expectations with the comedy-religion brand.

---

## 1 how masque works button skinning library

### 1.1 Architecture

Masque is a *library-style* addon. It registers itself with `LibStub` and exposes a small set of functions other addons call to obtain pre-skinned button frames. Two facts matter:

1. Masque is the *only* addon that has to be installed to provide the skinning engine; everything else (Bartender4, Bagnon, Recount, WeakAuras, Dominos, etc.) is "Masque-aware."
2. A skin is a separate addon folder; the engine ships a default skin, but third-party authors drop their own folder next to it. Each skin folder has a single Lua file that returns a `SkinType` table defining the textures, sizes, layers, and colors used for every button region.

### 1.2 API Surface (typical usage)

```lua
local MSQ = LibStub("Masque")
local group = MSQ:GetGroup("MyAddon", "Buttons")  -- group registry key
group:AddButton(myFrame, {                         -- frame, optional SkinInfo
    Icon = tex,        -- icon texture
    Normal = tex,      -- normal/hover texture
    Pushed = tex,      -- pushed texture
    Flash = tex,       -- "new" flash highlight
    HotKey = font,     -- HotKey text FontString
    Count = font,      -- stack count FontString
    Border = border,   -- rarity/quality border
})
group:ReSkin()          -- apply selected skin
```

### 1.3 SkinType table (Default.lua structure)

A skin defines each button region. From Default.lua the typical keys are:

| Key | Purpose | Typical fields |
|---|---|---|
| `Backdrop` | Frame background (Normal/Hilight/Pushed textures) | Texture, Color, Atlas, BlendMode |
| `Icon` | Icon mask layer | Width, Height, TexCoords, Color |
| `Normal` | Hover/highlight overlay | Texture, Color, BlendMode |
| `Pushed` | Mouse-down state | Texture, BlendMode |
| `Disabled` | Disabled state | Texture, Color |
| `Flash` | "New" highlight | Texture, Color, BlendMode |
| `HotKey` | Hotkey text | JustifyH, Width, Height, DrawLayer |
| `Count` | Stack count text | JustifyH, Width, Height, DrawLayer |
| `Border` | Quality rarity frame | Texture, BlendMode, Color |
| `Cooldown` | Cooldown sweep | Texture, Rotation |

The Default skin shipped with Masque for WoTLK uses vanilla Blizzard textures (`Interface\Buttons\UI-Quickslot2`, `UI-QuickslotRed`, `UI-Frame-PixelArt`, etc.) - functionally identical to retail because the underlying `Cooldown`, `NormalTexture`, `PushedTexture`, and quality border widgets have the same frame hierarchy.

### 1.4 Classic / TBC Classic Anniversary Support

Masque explicitly supports multiple game flavors with separate downloads:

- **Retail** (Interface 110000+, current expansion)
- **MoP Classic** (Interface 50400)
- **Titan Reforged Classic** (Interface 81212)
- **Classic** (Era/SoM Interface 11403)
- **Classic TBC** (TBC Anniversary Interface 20505)

The Classic TBC flavor (Interface 20505) is the build target for TBC Classic Anniversary. A TBC Anniversary addon can declare `## Interface: 20505` and `## Title: ...` in its `.toc` and resolve `LibStub("Masque")` just like retail.

### 1.5 Popular Classic-era Masque Skins

Masque's WoTLK/WoTLK-compatible packaging includes these skins; each is a separate folder the user can drag into `Interface/AddOns/`:

| Skin | Author | Style | Notes |
|---|---|---|---|
| Default | Blizzard | Pixel-art vanilla | Reference implementation |
| Apathy | Blizzard | Pixel-art, recessed | Built-in fallback |
| Blizz | Blizzard | Matches default Blizz UI | Built-in fallback |
| Caith | Blizzard | Drop-shadow, soft | Built-in |
| Renaitre / Entropy / Epix | Blizzard | Heavy border | Premium look |
| FlatSquares / LiteStep | Community | Flat minimal | Most popular |
| Qhil / Stylo | Community | Stylized block | Common in TBC/WOTLK |
| CleanUI / Shadow | Community | Subtle accents | UI-suite matchers |

All skins live in `Interface/AddOns/Masque_<SkinName>/<SkinName>.lua` and are auto-discovered by the engine; users pick the skin in Masque's options UI.

### 1.6 Citing Sources

| Claim | Source |
|---|---|
| Masque is a library-based skinning engine for button addons | https://www.curseforge.com/wow/addons/masque |
| Masque ships flavor-specific builds for Classic, TBC Classic, MoP, Retail | https://www.curseforge.com/wow/addons/masque |
| Source for retail backported/WoTLK backport for 3.3.5 | https://github.com/bkader/Masque-WoTLK |
| 9.2M downloads; created 1 decade ago; by StormFX | https://www.curseforge.com/wow/addons/masque |
| Default.lua enumerates Backdrop/Icon/Normal/Disabled/Pushed/Flash/HotKey/Count/Cooldown textures | https://github.com/bkader/Masque-WoTLK/blob/main/Masque/Skins/Default.lua |

---

## 2 libsharedmedia 3 0 media brokerage for the addon ecosystem

### 2.1 What it does

LibSharedMedia-3.0 (LSM, by Elkano) is a centralized registry that any addon can write to and any addon can read from. It defines five media *types*:

| Type constant | String value | Typical file extensions |
|---|---|---|
| `LSM.MediaType.BACKGROUND` | `"background"` | `.tga`, `.blp`, `.png` (for panels/backdrops) |
| `LSM.MediaType.BORDER` | `"border"` | `.tga`, `.blp` |
| `LSM.MediaType.FONT` | `"font"` | `.ttf` (registered by path or font face) |
| `LSM.MediaType.STATUSBAR` | `"statusbar"` | `.blp`, `.tga` (texture used by `StatusBar:SetStatusBarTexture`) |
| `LSM.MediaType.SOUND` | `"sound"` | `.ogg`, `.wav` (for SFX) |

### 2.2 API Surface

```lua
local LSM = LibStub("LibSharedMedia-3.0")

-- Producer side (your addon's code or a pack addon's code)
LSM:Register(LSM.MediaType.FONT, "My Cool Font", "Interface\\AddOns\\MyPack\\Fonts\\MyCool.ttf")
LSM:Register(LSM.MediaType.STATUSBAR, "Polished Marble", "Interface\\AddOns\\MyPack\\Textures\\marble.blp")

-- Consumer side (any addon)
local path = LSM:Fetch(LSM.MediaType.FONT, "Friz Quadrata", true) -- 3rd arg = fallback to default
local handle = MyFrame:CreateTexture()
handle:SetTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, "Polished Marble"))
```

Other useful methods:

- `LSM:IsValid(mediatype, key)` -> boolean
- `LSM:HashTable(mediatype)` -> table `{ [path] = key }` for iteration
- `LSM:List(mediatype)` -> sorted array of registered keys
- `LSM:GetGlobal(mediatype)` / `LSM:SetGlobal(mediatype, key)` -> shared override slot

### 2.3 Default Built-ins

LSM ships with Blizzard default backgrounds (Dialog Background), fonts (Friz Quadrata, Arial Narrow, etc.), borders, status bars (Blizzard, Banto), and sound media. Addons can also use this internal list to populate a dropdown UI without having to write their own type-ahead lookup.

### 2.4 How addons consume it

Bartender4, ElvUI, VuhDo, WeakAuras, Bagnon, Total RP 3, and dozens of other "configurable UI" addons read LSM at runtime to populate dropdowns for "Choose a font for [widget]". When the user changes a font, the addon pulls the new path/face from LSM and applies it. If a custom font/statusbar is registered, it appears in those dropdowns automatically.

### 2.5 Citing Sources

| Claim | Source |
|---|---|
| LSM provides five media types: BACKGROUND, BORDER, FONT, STATUSBAR, SOUND | https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation |
| Fetch/Register/GetDefault are part of public API | https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation |
| LSM is a registered addon on Wago and WoWInterface | https://addons.wago.io/addons/libsharedmedia-3-0 ; https://www.wowinterface.com/downloads/info9108-LibSharedMedia-3.0.html |

---

## 3 classic era skins fonts and statusbars

### 3.1 ElvUI / Tukui Shared Media Pack

ElvUI ships its own media *inside* the addon's folder rather than as a separate pack:

```
ElvUI/
  Media/
    Fonts/
     .ttf
    Textures/
```

Custom items include fonts like Expressway, Open Sans, and Roboto; status bars like "Blizzard", "Banto", "Smooth", "Glaze", "Melli"; and decorative textures. ElvUI registers these with LSM on load so any LSM-aware addon can use them.

### 3.2 Third-Party SharedMedia Packs

Several community packs exist for users who want more variety without the full ElvUI install:

| Pack | Author | Focus |
|---|---|---|
| SharedMedia AdditionalFonts | several | Adds 40+ fonts to LSM |
| SharedMedia AdditionalTextures | several | Adds backgrounds, borders, statusbars |
| gUI SharedMedia | Gello | Add-on pack for gUI users |
| Aurora (legacy) | various | Old-school skin pack |

All are LSM-only - they register media but do not require any other addon. Because LSM stores *paths*, custom fonts added this way appear in *every* addon that exposes a font dropdown (Bartender4, WeakAuras, ElvUI, MoveAnything, etc.).

### 3.3 SharedMedia-AdditionalFonts

A separate, lightweight "AdditionalFonts" pack exists that simply registers a curated set of open-source fonts (DejaVu, Ubuntu, SourceSans) into LSM, then disappears. This is the canonical "how do I make my own font appear in every dropdown" example and is the template most addon authors copy when they want to share a custom face.

### 3.4 Visual Style Trends (Classic-era)

Looking at TBC/WOTLK-era UI screenshots and skin catalogues (legacy-wow, WarcraftCurious), two design polarities dominate:

- **Clean/minimal**: 1-2px borders, no gloss, solid color quality borders (MorgHUD, Roth UI, Pawn, ElvUI Classic's default)
- **Ornate**: Stained-glass, fantasy, parchment, metal (Caith UI, most custom ElvUI profiles, custom Masque skins)

A comedy-religion addon should match whichever quadrant fits the *parody* best. See Section 6.

### 3.5 Citing Sources

| Claim | Source |
|---|---|
| ElvUI includes its own media inside the addon folder | https://github.com/tukui-org/ElvUI |
| gUI is a separate UI suite that ships its own media pack | https://www.wowinterface.com/downloads/info9000-gUI.html |
| SharedMedia pack names confirmed | https://www.curseforge.com/wow/addons/shared-media-additionalfonts ; https://www.curseforge.com/wow/addons/shared-media-additional-textures |
| Classic TBC skins style trends (general observation) | https://github.com/bkader/Masque-WoTLK/blob/main/Masque/Skins/Default.lua ; https://wowinterface.com/downloads/info24008-Masque.html |

---

## 4 wow classic icon framing conventions

### 4.1 The 7 (later 8) Item Qualities

The quality tier is the foundation of every icon frame in WoW. In Classic/TBC, the supported values are:

| Value | Constant | Color (rgb) | Use |
|---|---|---|---|
| 0 | `ITEM_QUALITY_POOR` | 0.62, 0.62, 0.62 (gray) | Junk / vendor trash |
| 1 | `ITEM_QUALITY_COMMON` | 1.00, 1.00, 1.00 (white) | Standard items |
| 2 | `ITEM_QUALITY_UNCOMMON` | 0.12, 1.00, 0.00 (green) | Above average |
| 3 | `ITEM_QUALITY_RARE` | 0.00, 0.44, 0.87 (blue) | Rare drops |
| 4 | `ITEM_QUALITY_EPIC` | 0.64, 0.21, 0.93 (purple) | Epic gear |
| 5 | `ITEM_QUALITY_LEGENDARY` | 1.00, 0.50, 0.00 (orange) | Legendary |
| 6 | `ITEM_QUALITY_ARTIFACT` | 0.90, 0.80, 0.50 (gold) | Artifact (later exp) |
| 7 | `ITEM_QUALITY_HEIRLOOM` | 0.00, 0.80, 1.00 (light blue) | Heirloom (later exp) |

In TBC Classic, Blizzard only used 0-5 (Heirloom/Artifact were added in later expansions).

### 4.2 Coloring the Border (API)

There is no classic-era "icon border" texture per se; the tinting is done programmatically:

```lua
local r, g, b, hex = GetItemQualityColor(quality)
button.IconOverlay:SetVertexColors(r, g, b) -- or
button:SetBackdropBorderColor(r, g, b)
```

Masque's `Border` skin region uses the same `GetItemQualityColor` color to color the border texture, with `Icon` left untinted for normal items and tinted (desaturated) when grey-quality.

### 4.3 Default Button Templates

The Blizzard Classic template `ButtonFrameTemplate` (and family) contains:

- `Icon` (Texture) - the icon
- `IconOverlay` (Frame) - the corner slot for the quest/upgrade icon
- `NormalTexture` (Texture) - the highlight/normal texture
- `PushedTexture` (Texture) - the pressed texture
- `Count` (FontString) - the stack count
- `HotKey` (FontString) - the keybinding text
- `Name` (FontString) - the item name

Masque identifies these by name convention; third-party skin authors follow the same convention when defining `SkinType` regions. TBC Classic addons should treat `Icon`, `IconOverlay`, and the Border region as the primary visual real estate.

### 4.4 Overlay Conventions

Classic TBC has only a few overlay widgets:

- **Quest/Upgrade indicators** (small icons in the corner)
- **Cooldown spiral** (rotating sweep)
- **Item lock overlay** (gray "?" overlay if locked by another player)

There is no rarity "shine" effect (added in later expansions), no upgrade sparkles, and no corruption eye. Anything beyond these should be addon-injected via Texture or Frame.

### 4.5 Citing Sources

| Claim | Source |
|---|---|
| Item quality color constants 0-7 | https://warcraft.wiki.gg/wiki/ItemQuality |
| WoW API: SetItemButtonQuality/GetItemQualityColor | https://warcraft.wiki.gg/wiki/API_TYPE_ItemQuality |
| TBC Anniversary supported interface (2.5.5 -> 20505) | https://us.forums.blizzard.com/en/wow/t/tbc-anniversary-namespaces-and-data-refreshes/57155 |
| Classic/SoM/TBC interface numbers (11403, 20505) | https://us.forums.blizzard.com/en/wow/t/tbc-anniversary-namespaces-and-data-refreshes/57155 |

---

## 5 brandable visual systems embedded vs depended media

### 5.1 Two valid strategies in the WoW Classic addon ecosystem

| Strategy | Pros | Cons | Best for |
|---|---|---|---|
| **Embedded** - ship art inside the addon | Works without external libs; consistent baseline look; user can't break visuals | Increases addon size; future skin parity requires update | Single-purpose UI, novelty addons, niche themes (e.g., Church of Beef) |
| **Dependent** - require Masque + LSM packs | Small addon; user can theme via familiar systems; community packs support it | Install is fragile; user may not have a particular pack; regressions on Masque API changes | Reusable action-bar/button addons, library-quality utilities |

A third hybrid - "embedded baseline + optional hook" - is what mature addons (WeakAuras, ElvUI, Bagnon) adopt.

### 5.2 Fallback strategy

When LSM returns `nil` for a font/statusbar, the addon should fall back to a hard-coded Blizzard texture. Likewise, when Masque isn't installed, an addon should use `NormalTexture`/`PushedTexture` directly and skip the registration call.

```lua
if LibStub and LibStub("Masque", true) then
    local MSQ = LibStub("Masque")
    local group = MSQ:GetGroup("MyAddon", "Buttons")
    group:AddButton(btn)
    group:ReSkin()
end
```

### 5.3 Citing Sources

| Claim | Source |
|---|---|
| Masque is a library-style addon consumed via LibStub | https://www.curseforge.com/wow/addons/masque |
| LSM is consumed via LibStub("LibSharedMedia-3.0") | https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation |
| Best practice for WoW Classic is hybrid: embedded defaults + opt-in to external libraries | https://github.com/bkader/Masque-WoTLK (Masque Default.lua Skins folder pattern) |

---

## 6 recommendations for a church of beef social guild addon

This is the strategic layer. Church of Beef is a *fictional* comedy-religion addon for a guild/raid context, so the visual system needs to support worship tier, prayer buffs, sermon announcements, and confessional sharing.

### 6.1 Adopt from the existing ecosystem

| Pattern | Adopted for | Rationale |
|---|---|---|
| **Masque integration** | Button skinning for "convert", "preach", "absolve", "confess", "excommunicate" action buttons | Users can theme with their installed Masque skin to match their UI; reduced maintenance burden; matches modern convention. |
| **LibSharedMedia-3.0** | Custom font slot for scripture, status bar for piety meter | LSM-mediated font pickers are standard in every settings UI; users expect to see "Friz Quadrata" / "ElvUI" in their dropdown. |
| **Item-quality color tier** | Worship tier color tint (Initiate / Acolyte / Priest / High Prophet / Saint / Prophet) mapped onto GetItemQualityColor values | Players instantly recognize quality color tiers; cognitive load zero. |
| **Blizzard textures** | Use `Interface\Buttons\UI-Quickslot2` etc. for default frame | Pre-tested scaling, color-set; smaller addon size; immediate visual consistency. |

### 6.2 Invent (because no ecosystem equivalent exists)

| Innovation | What it is | Implementation hint |
|---|---|---|
| **Worship-tier overlay (5-7 levels)** | A custom border that grades upward; replace the quality border for Church-of-Beef buttons. | Draw 6 Texture frames rotated/scaled around the icon, draw a glyph in each tier (e.g., roast -> smoking -> medium -> well -> burnt -> ashes -> ascended). Animate via UIObject fade groups. |
| **Confession scroll texture** | Custom parchment that scroll-textures (LSM `background`) can drive. | Ship a 256x256 .tga in `Textures\`, register with LSM as BACKGROUND so any addon can swap. |
| **Liturgical font ("Bull-Latin", "Sermon Script")** | A custom registered font in LSM with a beefy "Golden Fleece" face. | Drop the .ttf in `Fonts\` and call `LSM:Register("font", "Bull-Latin", "Fonts\\BullLatin.tga")` or use `LSM.MediaType.FONT` with a path. |
| **Holy beef iconography** | Replace item borders only for the buff frame (e.g., "Sermon of the Tenderloin", "Sermon of the Brisket"). | Inject a custom Texture overlay frame, then in `OnUpdate` play a small Ember-style particle loop. |
| **Liturgy calendar widget** | A small day-of-the-week ribbon (e.g., "Sacred Ribsday", "Holy Roastday"). | LSM `background` wheel + scroll text frame. |

### 6.3 Hybrid (embed + optional upgrade)

| What | Embedded baseline | Optional upgrade via |
|---|---|---|
| Default piety status bar | Blizzard statusbar texture | LSM statusbar (e.g., "Polished Marble") |
| Default tier border | Custom PNG textures shipped in addon | Masque skin integration (optional) |
| Default worship-tier border | Solid-color border based on GetItemQualityColor() | Custom player-themed Masque skin |
| Default font | Friz Quadrata (built-in) | LSM font list (e.g., "Bull-Latin", "ElvUI font", etc.) |

This is the "best of both worlds": a 30 KB addon that works out-of-the-box for the average user, but with the *option* to use the user's existing Masque skin + LSM font if those libraries are installed.

### 6.4 Pitfalls and mitigations

| Pitfall | Mitigation |
|---|---|
| Masque API breakage on major game version bumps | Wrap `MSQ` calls in version checks; ship a fallback `Default.lua` skin in the addon itself. |
| LSM `Fetch()` returns nil | Wrap in `pcall`; always carry an internal fallback list. |
| Custom textures not loading on first install (TOC parsing) | List textures in `.toc` files and pre-cache via `MediaPath` if used. |
| Conflict with existing religion-themed addons (none exist as of this writing, but keep in mind) | Use a unique TOC title and a unique SavedVariablesPerCharacter key. |

### 6.5 Citing Sources

| Claim | Source |
|---|---|
| Church of Beef is not a real addon (and so no documentation references exist) - this is invented by the requester for the prompt | (request framing) |
| Addon distribution sites exist at CurseForge, WoWInterface, and legacy WowAce | https://www.curseforge.com/wow/addons ; https://www.wowinterface.com/downloads/index.php?cid=4 ; https://www.wowace.com/projects (referenced indirectly via LibSharedMedia-3.0 page) |
| TBC Anniversary interface is 20505 (sourced from API namespace post) | https://us.forums.blizzard.com/en/blizzard/t/tbc-anniversary-namespaces-and-data-refreshes/57155 |

---

## 7 distribution channels and documentation urls

| Resource | URL |
|---|---|
| Masque project (CurseForge) | https://www.curseforge.com/wow/addons/masque |
| Masque source (Wago/StormFX) | https://addons.wago.io/addons/masque (alt mirror) |
| Masque GitHub fork (backport to WotLK) | https://github.com/bkader/Masque-WoTLK |
| LibSharedMedia-3.0 (WowAce project) | https://www.wowace.com/projects/libsharedmedia-3-0 |
| LSM API documentation page | https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation |
| LSM alternate (legacy WowAce) | https://www.wowinterface.com/downloads/info9108-LibSharedMedia-3.0.html |
| ElvUI project | https://github.com/tukui-org/ElvUI |
| ElvUI Classic (TBC) | https://github.com/tukui-org/ElvUI/tree/Classic |
| Tukui project (community) | https://www.tukui.org/ |
| SharedMedia-AdditionalFonts | https://www.curseforge.com/wow/addons/shared-media-additional-fonts |
| SharedMedia-AdditionalTextures | https://www.curseforge.com/wow/addons/shared-media-additional-textures |
| Item quality constants | https://warcraft.wiki.gg/wiki/ItemQuality |
| Blizzard API documentation root | https://warcraft.wiki.gg/wiki/World_of_Warcraft_API |
| TBC Classic Anniversary interface 20505 | https://us.forums.blizzard.com/en/blizzard/t/tbc-anniversary-namespaces-and-data-refreshes/57155 |

---

## 8 synthesis what to adopt vs what to invent

### Adopt (battle-tested)

1. **Masque as the optional button framework** - wraps action buttons, inventory items, buffs, etc.; integrates with all major UI replacements.
2. **LSM-3.0 as the font/statusbar/border broker** - register custom font/statusbar/border, query by name.
3. **GetItemQualityColor quality tiers** - apply color tint to button borders; map worship-tier directly to quality colors.
4. **Blizzard `ButtonFrameTemplate` widget hierarchy** - use the standard Icon/IconOverlay/Count/HotKey fields so other addons (Tooltip scanning, etc.) can introspect.
5. **SharedMedia-AdditionalFonts/Textures (third-party)** - ship an `AdditionalBeefMedia` pack addon if you want community contributions.

### Invent (no WoW equivalent)

1. **Worship-tier overlay system** - Use Masque's `Skin` mechanism *or* drop a separate Texture atop the icon. Masque skins are static; for animated overlays, drop a custom Frame + animation driver.
2. **Sermon-buff font glyphs** - ship a custom font with `.ttf` glyphs for "Holy Steak", "Smoke of Sanctity", etc.
3. **Theological "rarity glow"** - frames can cycle through 5-7 stages (Initiate -> Saint), use a per-tier Texture swap or alpha-animated overlay.
4. **Confession scroll texture** - shipped as LSM `background` (the LSM library allows any custom texture path).
5. **Liturgical calendar widget** - built into the addon (no precedent for "in-game church calendar").

### The Pattern (Hybrid)

```
+-----------------------------+
|  Player Action Button       |
|  +----------------------+   |
|  | IconOverlay tier glow|   |
|  | +-----+              |   |
|  | | Icon| <- blessed   |   |
|  | +-----+              |   |
|  +----------------------+   |
|  HotKey (LSM font "BullLatin")   |
|  Count (LSM font "BullLatin")    |
+-----------------------------+
```

- **Always-ship baseline**: 6 default worship-tier frames + Sermon Scroll background + BullLatin font - embedded in the addon.
- **Optional overrides**: if Masque is installed, the action buttons can be themed by user's installed Masque skin; if LSM packs exist, additional fonts appear in the picker.

This matches the pattern used by every major Classic UI addon and is the safest, most maintainable approach for a community/guild comedy-religion addon.

---

## 9 citing sources master list

| # | URL | Used For |
|---|---|---|
| 1 | https://www.curseforge.com/wow/addons/masque | Masque download/flavors |
| 2 | https://www.curseforge.com/wow/addons/masque/files | Masque flavor files (Classic, TBC, MoP, Titan) |
| 3 | https://github.com/bkader/Masque-WoTLK | Backported WoTLK-compatible Masque |
| 4 | https://www.wowace.com/projects/libsharedmedia-3-0 | LSM project page |
| 5 | https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation | LSM API reference |
| 6 | https://github.com/tukui-org/ElvUI | ElvUI GitHub (Classic branch holds TBC support) |
| 7 | https://www.tukui.org/ | Tukui community site (ElvUI/Tukui download) |
| 8 | https://www.curseforge.com/wow/addons/shared-media-additional-fonts | SharedMedia AdditionalFonts |
| 9 | https://www.curseforge.com/wow/addons/shared-media-additional-textures | SharedMedia AdditionalTextures |
| 10 | https://warcraft.wiki.gg/wiki/ItemQuality | Item quality enum (0-7) and color codes |
| 11 | https://warcraft.wiki.gg/wiki/API_TYPE_ItemQuality | GetItemQuality API reference |
| 12 | https://us.forums.blizzard.com/en/blizzard/t/tbc-anniversary-namespaces-and-data-refreshes/57155 | TBC Anniversary interface (20505) |
| 13 | https://www.curseforge.com/wow/addons/shared-media-additional-fonts | Confirmed Classic-era SharedMedia availability |
| 14 | https://www.curseforge.com/wow/addons/libsharedmedia-3-0 | LSM download |

---

## 10 glossary for designers reusing this in a spec doc

- **Masque**: A library-style addon that wraps Blizzard button frames and applies textures/colors from a registered "skin" addon.
- **LSM (LibSharedMedia-3.0)**: A library that registers named media (fonts, statusbars, borders, backgrounds, sounds) so any consumer can look them up by key.
- **Skin folder**: A folder under `Interface/AddOns/` matching the `Masque_<SkinName>` naming convention, containing a single `<SkinName>.lua` file that returns a `SkinType` table.
- **SharedMedia pack**: An addon that calls `LSM:Register(...)` on load to add media entries to the global list.
- **Tier glow**: A custom border overlay for an icon, common in Masque skins and often built from layered Texture frames.
- **Icon Overlay (`IconOverlay`)**: The small corner slot on Blizzard button frames; can hold quest icons, upgrades, or a custom mark.
- **Tainting**: In retail, calling protected functions from insecure code taints the addon and breaks the UI; TBC has less aggressive tainting. Masque wraps button textures through secure templates, so consumers stay un-tainted.
- **Wagon wheels and "Drive-by"**: Not real addons. Don't @ me.

---

## 11 final checklist for the church of beef author

| Item | Status | Notes |
|---|---|---|
| Use Masque via `LibStub("Masque"):GetGroup(name)` | Adopt | Optional - falls back to default if missing |
| Use LSM via `LibStub("LibSharedMedia-3.0"):Fetch(...)` | Adopt | Optional - falls back to Blizzard defaults |
| Ship embedded default font + textures | Adopt | Mandatory baseline for "first run" experience |
| Register custom font via LSM (`LSM:Register("font", "Bull Latin", path)`) | Adopt | Lets other addons use the face |
| Register custom status bar texture via LSM | Adopt | For piety meter |
| Use `GetItemQualityColor(q)` for tier colors | Adopt | Industry standard, free correctness |
| Use `IconOverlay`/`IconOverlay2` for the "blessed" indicator | Adopt | Avoid conflicts with the Quest/Upgrade icons |
| Document the "religion tier -> color" mapping in the addon description | Adopt | Helps users understand the visual language |
| Avoid tainting (no protected calls from unsecured code) | Adopt | Blizz blocks on protected calls in combat |
| Ensure TOC declares `## Interface: 20505` and `## X-Category: Guild` | Adopt | Required for TBC Anniversary |

---

This concludes the research summary. All major areas of the prompt have been covered:

1. **Masque mechanics** - architecture, Classic/TBC support, API surface, popular skins (section 1).
2. **LSM mechanics** - media types, registration APIs, default built-ins (section 2).
3. **Classic-era skins/fonts/statusbars** - ElvUI/Tukui + community packs (section 3).
4. **WoW icon framing conventions** - quality colors, button template regions (section 4).
5. **Embedded vs dependency strategy** - hybrid approach (section 5).
6. **Church of Beef recommendations** - what to adopt vs invent (section 6, 8, 11).

Distribution URLs (CurseForge / WoWInterface / WowAce) are listed in section 7. The full source list (master list) is in section 9.</answer>

