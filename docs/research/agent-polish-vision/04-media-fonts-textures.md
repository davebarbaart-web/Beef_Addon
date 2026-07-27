# 04 — Media, fonts, textures & atlas usage (Anniversary `20506`)

**Lane:** Agent polish vision (visual polish without Retail-only APIs)  
**Last updated:** 2026-07-26  
**Host:** TBC Classic Anniversary — `## Interface: 20506`  
**Product law:** design spec §10 / §11 (plain frames, missing-media fallback); UI brief `docs/superpowers/ui-polished-direction-for-agents.md`  
**Repo rules:** `.cursor/rules/packaging-assets.mdc`, `.cursor/rules/build-packaging.mdc`  
**Depth tracks (do not fork product policy here):**  
[10-skinning-masque-sharedmedia](../wow-classic-addon-design/10-skinning-masque-sharedmedia/) · [44-custom-textures-media-packaging](../wow-classic-addon-design/44-custom-textures-media-packaging/) · [18-localization-i18n/03-fonts-non-latin.md](../wow-classic-addon-design/18-localization-i18n/03-fonts-non-latin.md) · [42-soft-deps-embeds](../wow-classic-addon-design/42-soft-deps-embeds/)

---

## 1. One-screen verdict

| Layer | Anniversary-safe polish | Avoid |
|-------|-------------------------|--------|
| **Typography** | `GameFont*` / inherited Blizzard faces (locale-correct) | Latin-only gothic TTF as sole body face; Retail Expressway assumptions |
| **Panel chrome** | Classic FrameXML templates + opaque fills; stock dialog/tooltip art | Glass / low-alpha Retail skins; ElvUI-as-brand |
| **Custom bitmaps** | TGA (dev) / BLP (ship), **power-of-two**, under `ChurchOfBeef/Media/` | Retail PNG texture paths; non-PoT sizes |
| **Atlas API** | Optional: `SetAtlas` / `CreateAtlasMarkup` **only** after live Anniversary proof of that name | Hard-coding Retail atlas catalogs; assuming `C_Texture` feature parity |
| **SharedMedia** | Soft / feature-detect only; never required for `/beef` | Hard `## Dependencies` on LSM or SharedMedia packs |
| **Vendored media** | Ship small brand files inside the addon zip | Asking guildies to install SharedMedia Extended for readability |

**Doctrine:** V1 polish = hierarchy, contrast, spacing, template discipline, and copy — not a media megapack. Custom fonts/textures are a later theatrical pass that must still fall back to default UI.

---

## 2. Packaging rules that bind media work

From `packaging-assets.mdc` + `build-packaging.mdc`:

1. **TOC only loads files under `ChurchOfBeef/`** — keep fonts/textures/sounds next to code; zip root is `ChurchOfBeef/`, not the monorepo.
2. **Missing custom media must not fail load** — `/beef` frame still exists; fall back to default UI fonts/textures.
3. **Case-sensitive paths** — match on-disk casing in TOC, Lua, and packager zips (Linux CI / some extractors break on `Media` vs `media`).
4. **Prefer backslashes in TOC paths** (`Data\Ranks.lua`); Lua texture paths commonly use escaped backslashes (`Interface\\AddOns\\ChurchOfBeef\\Media\\...`).
5. **V1 Interface stays `20506`** unless intentionally bumped; no Retail / Era multi-TOC for V1.
6. **Do not bundle ripped Blizzard soundtrack**; quiet by default (no ambient `/g` spam from media).
7. Media files **need not appear in the `.toc`** to be usable via `SetTexture` — they must exist on disk under the addon tree before reference.

Install shape (from build-packaging):

```bash
# From addon checkout (often .worktrees/feat-church-of-beef-v1/)
cp -R addon/ChurchOfBeef "$WOW_ADDONS_DIR/ChurchOfBeef"
```

---

## 3. Fonts (Classic / Anniversary)

### 3.1 Default UI fonts = polish baseline

Blizzard font objects (`GameFontNormal`, `GameFontHighlight`, `GameFontNormalLarge`, `GameFontDisable`, etc.) already pick the **locale-correct** face. That is the V1 and stream-safe path:

- High contrast on opaque panels beats a fancy display face on parchment.
- Titles: larger GameFont / highlight; body: normal; disabled: `GameFontDisable`.
- Player names on the ladder: keep default faces so Cyrillic/CJK/mixed names do not tofu.

Stock faces players recognize (also LSM built-ins):

| Face | Typical path | Role |
|------|--------------|------|
| Friz Quadrata TT | `Fonts\FRIZQT__.TTF` | Classic body / UI default |
| Arial Narrow | `Fonts\ARIALN.TTF` | Compact labels |
| Morpheus | `Fonts\MORPHEUS.TTF` | Fantasy title flavor |
| Skurri | `Fonts\SKURRI.TTF` | Condensed display |

Non-Latin clients use counterpart files (e.g. `FRIZQT___CYR.TTF`) — another reason **not** to hard-code English TTF paths for body text ([18/03-fonts-non-latin](../wow-classic-addon-design/18-localization-i18n/03-fonts-non-latin.md)).

### 3.2 Custom / SharedMedia fonts (post-V1 only)

| Pattern | When | Rule |
|---------|------|------|
| Embedded Church display `.ttf` | Art / theatrical pass | One face for titles/wordmark; always fall back to GameFont |
| Optional LSM `Register` / `Fetch` | If LibStub finds LSM | Soft only; never block load |
| SharedMedia ClassicalFonts / Extended packs | Player taste | Never a install requirement |

Community “clean Classic” stacks (ElvUI Expressway-class faces) are **references**, not dependencies. Guildies on default UI must see a finished ladder without those packs.

### 3.3 Typography polish without new files

- Size hierarchy: title > rank title > row body > helper.
- Prefer Blizzard highlight colors over custom hex until Anniversary screenshot lock (glossary row 78 / UI brief).
- Avoid pixel/condensed meme fonts for roster density — they read as WeakAuras HUD, not guild institution.

---

## 4. Textures — formats, sizes, paths

### 4.1 Formats for `20506`

| Format | Anniversary stance |
|--------|-------------------|
| **TGA** | Authoring default (32-bit RGBA); edit → `/reload` |
| **BLP** | Ship/native; smaller zip; good for release icons |
| **PNG / JPEG** | Treat as **unsupported / unverified** on Anniversary — Retail PNG landed **10.0.7**; do not plan V1/V2 around it |

### 4.2 Power-of-two (hard)

Both axes must be PoT (independent): `64×64`, `256×128` OK; `48×48`, `512×200` not. Prefer ≥16×16 for UI glyphs.

Practical Beef sizes (when Media/ lands):

| Use | Size |
|-----|------|
| Minimap / LDB | 64×64 (or 128×128) |
| Rank / toast seal | 64×64 |
| Panel tile | 128×128 or 256×256 |
| Wide header | 512×128 or 256×64 + `SetTexCoord` |

### 4.3 Path conventions

```lua
-- Preferred: addon-relative, escaped backslashes, no extension for TGA/BLP
tex:SetTexture("Interface\\AddOns\\ChurchOfBeef\\Media\\Icons\\cob_minimap")

-- Fallback solid (no custom file)
tex:SetTexture("Interface\\Buttons\\WHITE8X8")
-- or SetColorTexture(...)
```

Suggested tree (theatrical pass — **not** V1 Task 7–10):

```text
ChurchOfBeef/
  Media/
    Icons/       # cob_minimap.tga, cob_rank_*.tga
    Textures/    # parchment / border tiles
    Fonts/       # optional display face only
```

Casing must match exactly on disk, in Lua, and in any future packager include list.

### 4.4 Stock Blizzard art for polish without shipping files

Use template inheritance and known Interface paths (dialog borders, `UI-StatusBar`, `WHITE8X8`, faction/class icons when appropriate) before inventing chrome. Class color on **names only** (UI brief); ranks stay heraldic text, not item-quality rainbow.

### 4.5 Inline markup

`|Tpath:height[:width]|t` embeds textures in FontStrings. Keep V1 guild announce **plain text** (spec) so recipients without the addon never see broken `|T` icons.

---

## 5. Atlas usage on Classic / Anniversary

**Clarify terms:** the third-party **Atlas** dungeon-map addon is unrelated. Here **atlas** means Blizzard’s named sub-rects (`SetAtlas`, `CreateAtlasMarkup`, `C_Texture.GetAtlasInfo`).

### 5.1 What is safe to assume

- `TextureBase:SetAtlas` is a long-standing API (wiki: since 6.0.2). Modern Classic clients expose atlas helpers in SharedXML.
- **Atlas name catalogs differ by client.** Retail / DF names often **missing** on Classic Era / Anniversary → “Unable to load atlas entry …” errors (community reports for templates like DiamondMetal on Era).
- Some addon authors treat “full atlas workflow” as Retail-primary and ship **extracted BLP + `SetTexture`/`SetTexCoord`** on Classic builds for parity.

### 5.2 Polish recommendations (Beef)

| Approach | Use when | Notes |
|----------|----------|-------|
| **A. No atlas** | V1 default | Templates + `SetTexture` paths; most reliable |
| **B. Verified atlas** | Specific Anniversary-proven name | Guard: `C_Texture.GetAtlasInfo(name)` (or pcall) → else texture fallback |
| **C. DIY atlas sheet** | Brand chrome | One PoT TGA/BLP + `SetTexCoord` regions — Classic-safe, no Retail catalog |

```lua
-- Pattern: never hard-fail on missing atlas
local function COB_SetAtlasOrTexture(tex, atlasName, filePath, useAtlasSize)
    if atlasName and C_Texture and C_Texture.GetAtlasInfo then
        local info = C_Texture.GetAtlasInfo(atlasName)
        if info then
            tex:SetAtlas(atlasName, useAtlasSize)
            return
        end
    end
    if filePath then
        tex:SetTexture(filePath)
    else
        tex:SetTexture("Interface\\Buttons\\WHITE8X8")
    end
end
```

**Do not** copy Retail-only NineSlice / calendar / Edit Mode atlas stacks into V1. Prefer Anniversary-shipped FrameXML templates that already resolve their own art.

---

## 6. LibSharedMedia — optional vs vendored

### 6.1 Roles

| Piece | Role |
|-------|------|
| **LibSharedMedia-3.0** | Registry: `Register` / `Fetch` for FONT, STATUSBAR, BORDER, BACKGROUND, SOUND |
| **SharedMedia packs** | Player-installed dumps that fill the registry |
| **AceGUI-SharedMediaWidgets** | Options dropdowns (Ace stack; not V1) |

LSM already predefines Blizzard fonts/borders/backgrounds — enough for a Classic look with zero files.

### 6.2 Optional (correct for Beef)

```toc
## OptionalDeps: LibSharedMedia-3.0
```

Runtime:

```lua
local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
local font = (LSM and LSM:Fetch("font", "Friz Quadrata TT")) or "Fonts\\FRIZQT__.TTF"
-- Still prefer GameFont* objects for locale safety on body text
```

- Feature-detect; ignore if absent.
- If registering Church media later: embed files under `Media/`, Register when LSM present (ElvUI hybrid pattern).
- Never require SharedMedia Extended / ClassicalFonts for ladder readability.

### 6.3 Vendored (when art exists)

| Strategy | Pros | Cons |
|----------|------|------|
| **Vendored in `ChurchOfBeef/Media/`** | Solo load; consistent brand; zip is source of truth | Zip size; you maintain license/assets |
| **Optional `ChurchOfBeef_Media` addon** | Keeps core small | Extra install; must not break core if missing |
| **Hard-dep SharedMedia pack** | Tiny core | Fragile installs; **deny** for Beef |

**V1 policy (aligned with track 42 / UI brief):** no LSM/Masque hard deps; no custom Media required. Soft LSM only after a theatrical pass needs picker interoperability.

---

## 7. Visual polish without Retail APIs (checklist)

Polish levers that **do not** need DF/Retail-only APIs or fat media:

1. **Templates** — `BasicFrameTemplate`, `UIPanelButtonTemplate`, `BackdropTemplate` (verify on Anniversary).
2. **Opacity & corners** — opaque panels, hard corners; no glass.
3. **Type scale & weight** — GameFont ladder; stream-readable sizes.
4. **Spacing & density** — short roster, not Details!-dense meters.
5. **State encoding** — dual-encode pending/approve/reject (color + text/icon), not neon pulses.
6. **Stock icons** — e.g. food/meat Interface icons for minimap until brand TGA exists.
7. **Motion budget** — one private toast; no center-screen WA-style atlas fireworks.
8. **Fallback contract** — every `SetTexture` / font path has a Blizzard default.

Retail APIs / assumptions to refuse for media polish:

- PNG-as-default texture pipeline  
- Unverified Retail atlas names / NineSlice layouts  
- Edit Mode chrome dependencies  
- Hard SharedMedia / Masque / ElvUI  
- Standing-as-StatusBar “HP” metaphor  

---

## 8. Phased recommendation for Church of Beef

| Phase | Media / fonts / textures |
|-------|--------------------------|
| **V1 (now)** | GameFont* + Classic templates; stock paths only; zero custom Media; no LSM code required |
| **V1.1** | Same; optional streamer quieter SV — still no media megapack |
| **Art / spectacle pass** | Small PoT TGA→BLP set under `Media/`; hard-edged seals; fallbacks mandatory; optional LSM Register |
| **Optional later** | Soft Masque only if icon grids appear; optional `ChurchOfBeef_Media` if zip bloats |

---

## 9. Agent do / don’t

**Do**

- Match casing on every media path; keep assets inside `addon/ChurchOfBeef/`.
- Prefer GameFont* and template chrome for Anniversary polish.
- Size custom bitmaps PoT; TGA author → BLP ship when size matters.
- Treat atlas names as **per-client** — verify on `20506` or use `SetTexCoord` sheets.
- Soft-detect LSM; vendor brand art in-tree when you need guarantees.

**Don’t**

- List missing files in the TOC; gate `/beef` on media load.
- Hard-depend SharedMedia packs or assume Expressway is installed.
- Ship Latin-only fonts as the only face for body/ladder text.
- Copy Retail atlas strings or PNG texture habits into Anniversary packaging.
- Put `docs/canon/` or research dumps in the release zip.

---

## 10. Sources & related docs

| Topic | Where |
|-------|--------|
| Missing-media / quiet packaging | `.cursor/rules/packaging-assets.mdc` |
| TOC / zip / `20506` | `.cursor/rules/build-packaging.mdc` |
| LSM API & built-ins | [10/02-libsharedmedia.md](../wow-classic-addon-design/10-skinning-masque-sharedmedia/02-libsharedmedia.md) |
| Fonts / statusbars culture | [10/03-skins-fonts-statusbars.md](../wow-classic-addon-design/10-skinning-masque-sharedmedia/03-skins-fonts-statusbars.md) |
| Hybrid embed strategy | [10/05-brandable-visual-systems.md](../wow-classic-addon-design/10-skinning-masque-sharedmedia/05-brandable-visual-systems.md) |
| TGA/BLP / PoT / paths | [44/01](../wow-classic-addon-design/44-custom-textures-media-packaging/01-power-of-two-and-formats.md), [44/02](../wow-classic-addon-design/44-custom-textures-media-packaging/02-interface-path-rules.md) |
| Locale fonts | [18/03-fonts-non-latin.md](../wow-classic-addon-design/18-localization-i18n/03-fonts-non-latin.md) |
| Soft-dep matrix | [42/beef-v1-dependency-policy.md](../wow-classic-addon-design/42-soft-deps-embeds/beef-v1-dependency-policy.md) |
| SetAtlas API | [warcraft.wiki.gg — TextureBase:SetAtlas](https://warcraft.wiki.gg/wiki/API_TextureBase_SetAtlas) |
| SetTexture formats | [warcraft.wiki.gg — TextureBase:SetTexture](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture) |
| LSM | [WowAce LibSharedMedia-3.0](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation) |

---

## 11. Recommendations (actionable)

1. **Ship V1 with zero custom fonts/textures** — polish via GameFont hierarchy, opaque Classic templates, and stock Interface paths.
2. **Never hard-depend LibSharedMedia or SharedMedia packs**; OptionalDeps + LibStub detect only if a later options panel needs Fetch/Register.
3. **When Media/ lands, vendor a tiny in-tree set** (minimap + seals); keep core readable if the folder is deleted; consider split `ChurchOfBeef_Media` only if size hurts.
4. **Author TGA PoT → convert hot icons to BLP for release**; omit PNG pipelines for Anniversary.
5. **Treat `SetAtlas` as optional sugar** — verify each atlas name on Anniversary, or draw from custom sheets with `SetTexCoord`.
6. **Enforce case-identical paths** across disk, Lua, TOC, and zip; prefer `Interface\\AddOns\\ChurchOfBeef\\...` strings.
7. **Keep guild spectacle in text + private toast** — do not spend polish budget on Retail atlas fireworks or center-screen pulses.

---

## 12. Deepen pass — primary-sourced media packaging (2026-07-26)

> **CoB constraints preserved:** Anniversary `20506`; missing media must not fail load; no Retail/DF-only API assumptions; TOC truth; no ripped Blizzard soundtrack in the zip; UI never awards points; Media work stays in `UI/` + packaged files under `ChurchOfBeef/Media/` — never Core/Net.

### SetTexture formats (what the wiki actually says)

[`TextureBase:SetTexture`](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture) documents accepted image families (BLP / JPEG / PNG / TGA), async load behavior, and that **new AddOns files generally need `/reload`** after drop-in (9.0.1+ notes). Critically, **PNG support for addon textures is a Retail 10.0.7-era addition** on that page — do **not** plan Anniversary V1/V2 around PNG-as-default. Prefer TGA for authoring and BLP for ship size.

Power-of-two remains the hard custom-image rule on both axes ([same SetTexture page](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture); [BLP files — Wowpedia](https://wowpedia.fandom.com/wiki/BLP_files); low-level [wowdev BLP](https://wowdev.wiki/BLP); empirical expansion notes [warcraft-rs BLP](https://warcraft-rs.readthedocs.io/en/latest/formats/graphics/blp.html)).

Author practice thread (living): TGA works via SetTexture; BLP for zip size; Photoshop alpha pain → GIMP; ≥16×16 folklore ([WoWInterface — BLP/TGA thread](https://www.wowinterface.com/forums/showthread.php?t=42139); [archive mirror](https://www.wowinterface.com/forums/archive/index.php/t-42139.html)). Community converters: [BLP2PNG](https://www.wowinterface.com/downloads/info6127-BLP2PNG.html), [blpconvert](https://github.com/mitjafelicijan/blpconvert) — always verify outputs in the Anniversary client.

### Atlas vs texture sheets

| API | Primary | CoB stance |
|-----|---------|------------|
| `SetAtlas` | [TextureBase:SetAtlas — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_TextureBase_SetAtlas) · [Wowpedia](https://wowpedia.fandom.com/wiki/API_TextureBase_SetAtlas) | Optional; **name catalogs differ by client** |
| `C_Texture.GetAtlasInfo` | [API_C_Texture.GetAtlasInfo](https://warcraft.wiki.gg/wiki/API_C_Texture.GetAtlasInfo) | Guard before SetAtlas; fallback to file path |
| DIY sheet + `SetTexCoord` | Classic-safe pattern | Prefer for brand seals when Media/ lands |
| Stock templates | FrameXML resolves own art | V1 default — zero custom files |

Do not confuse Blizzard atlases with the third-party **Atlas** dungeon-map addon. Do not copy Retail NineSlice / Edit Mode atlas stacks into `20506`.

### Fonts & SharedMedia (optional only)

LibSharedMedia-3.0 is a **registry** (`Register` / `Fetch` for FONT, STATUSBAR, BORDER, BACKGROUND, SOUND) — not a font pack ([WowAce project](https://www.wowace.com/projects/libsharedmedia-3-0); [API docs](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation); [CurseForge](https://www.curseforge.com/wow/addons/libsharedmedia-3-0)). Player packs (ClassicalFonts, AdditionalFonts, SharedMedia dumps) are taste, never install requirements ([ClassicalFonts](https://www.curseforge.com/wow/addons/sharedmedia-classicalfonts); [AdditionalFonts](https://www.curseforge.com/wow/addons/shared-media-additional-fonts); example dump [bkader/SharedMedia](https://github.com/bkader/SharedMedia)).

**Body text:** keep `GameFont*` so locale-correct faces (incl. non-Latin counterparts) win. Latin-only gothic TTF as sole ladder face is a tofu risk.

### Paths, TOC, inline markup

- Media files **need not** appear in the `.toc` to be usable ([TOC format — wiki.gg](https://warcraft.wiki.gg/wiki/TOC_format)) — they must exist on disk under the addon tree.  
- Path casing is case-sensitive on some extractors/CI — match disk, Lua, and zip.  
- Inline `|Tpath:height|t` markup: [UI escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences). V1 guild announce stays **plain text** so peers without the addon never see broken icons.  
- Minimap icons: PoT TGA/BLP; LibDBIcon expects an `icon` path string ([LibDBIcon — WowAce](https://www.wowace.com/projects/libdbicon-1-0); [Phanx LDB icon thread](https://www.wowinterface.com/forums/showthread.php?t=54315); [Reddit minimap tutorial](https://www.reddit.com/r/wowaddondev/comments/1esk1p2/creating_a_wow_addon_part_12_creating_a_minimap/)).  
- `SetPortraitToTexture` ≈ BLP circularize; TGA customs may not round cleanly ([WoWInterface archive](https://www.wowinterface.com/forums/archive/index.php/t-51853.html)).

### V1 polish without shipping Media/

Opaque panels + Backdrop / white swatch borders are enough for Anniversary chrome without custom bitmaps ([Drawing rectangles for borders — US forums](https://us.forums.blizzard.com/en/wow/t/drawing-rectangles-for-borders/1189042)). Stock Interface paths (`WHITE8X8`, dialog borders, food/meat icons) beat a half-finished brand pack.

### Agent packaging checklist (cite-backed)

- [ ] No PNG-as-default pipeline assumed for `20506` ([SetTexture](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture))  
- [ ] Custom bitmaps PoT both axes ([BLP files](https://wowpedia.fandom.com/wiki/BLP_files))  
- [ ] Missing file → GameFont / WHITE8X8 fallback; `/beef` still opens  
- [ ] Atlas names guarded via `GetAtlasInfo` or skipped  
- [ ] No hard `## Dependencies` on LSM / SharedMedia packs  
- [ ] Guild `/g` spectacle remains plain text (no `|T` dependency)  
- [ ] Case-identical `Interface\\AddOns\\ChurchOfBeef\\Media\\...` paths  

---

## External sources

Annotated primaries for this deepen pass (≥8). Prefer wiki + author forums over “best UI texture pack” listicles.

1. [TextureBase:SetTexture — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture) — formats, PoT, PNG 10.0.7 note, reload behavior.  
2. [TextureBase:SetAtlas — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_TextureBase_SetAtlas) — atlas API.  
3. [TextureBase:SetAtlas — Wowpedia](https://wowpedia.fandom.com/wiki/API_TextureBase_SetAtlas) — mirror.  
4. [C_Texture.GetAtlasInfo — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_C_Texture.GetAtlasInfo) — atlas existence guard.  
5. [BLP files — Wowpedia](https://wowpedia.fandom.com/wiki/BLP_files) — BLP2, mip, PoT.  
6. [BLP — wowdev.wiki](https://wowdev.wiki/BLP) — low-level format reference.  
7. [warcraft-rs — BLP format notes](https://warcraft-rs.readthedocs.io/en/latest/formats/graphics/blp.html) — empirical PoT / compression by expansion.  
8. [WoWInterface — BLP/TGA author thread](https://www.wowinterface.com/forums/showthread.php?t=42139) — living author practice.  
9. [BLP2PNG — WoWInterface](https://www.wowinterface.com/downloads/info6127-BLP2PNG.html) — community converter.  
10. [LibSharedMedia-3.0 — WowAce](https://www.wowace.com/projects/libsharedmedia-3-0) — registry project.  
11. [LibSharedMedia-3.0 API documentation — WowAce](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation) — Register/Fetch types.  
12. [LibSharedMedia-3.0 — CurseForge](https://www.curseforge.com/wow/addons/libsharedmedia-3-0) — distribution.  
13. [TOC format — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/TOC_format) — media need not be TOC-listed.  
14. [UI escape sequences — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/UI_escape_sequences) — `|T|t` markup.  
15. [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0) — minimap icon path contract.  
16. [Drawing rectangles for borders — Blizzard US forums](https://us.forums.blizzard.com/en/wow/t/drawing-rectangles-for-borders/1189042) — zero-Media chrome.  
17. [Reddit r/wowaddondev — minimap icon PoT/TGA](https://www.reddit.com/r/wowaddondev/comments/1esk1p2/creating_a_wow_addon_part_12_creating_a_minimap/) — author tutorial.  
18. [SharedMedia ClassicalFonts — CurseForge](https://www.curseforge.com/wow/addons/sharedmedia-classicalfonts) — optional pack (never required).  
19. [Gethe/wow-ui-textures README](https://github.com/Gethe/wow-ui-textures/blob/live/README.md) — upstream UI texture dump context.  
20. [TextureBase widget — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) — texture object overview.  

**Sister depth (repo):** [44 annotated-urls](../wow-classic-addon-design/44-custom-textures-media-packaging/annotated-urls.md) · [10 LSM track](../wow-classic-addon-design/10-skinning-masque-sharedmedia/) · packaging rules `.cursor/rules/packaging-assets.mdc`.
