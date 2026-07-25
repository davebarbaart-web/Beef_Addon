# LibSharedMedia-3.0

**Last updated:** 2026-07-25  
**Sources:** [LibSharedMedia project](https://www.wowace.com/projects/libsharedmedia-3-0), [API documentation](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation), [AceGUI-3.0-SharedMediaWidgets](https://www.wowace.com/projects/ace-gui-3-0-shared-media-widgets), scrapes in [`.firecrawl/`](.firecrawl/).

---

## 1. Role in the Classic UI ecosystem

LibSharedMedia (LSM) is the shared registry for **named media handles** so ElvUI, WeakAuras, Details!, Plater, and countless small addons can pick the same fonts, statusbar textures, borders, backgrounds, and sounds by string key.

Church of Beef V1 design (§10) already requires: missing fonts/textures fall back to default UI fonts; the addon must still load. That is exactly the LSM-friendly posture — **consume optionally, never hard-require**.

---

## 2. Media types

From the official API constants:

| MediaType | Purpose |
|-----------|---------|
| `background` | Background textures |
| `border` | Border textures |
| `font` | Fonts (optional locale bitmask on Register) |
| `statusbar` | Statusbar textures |
| `sound` | Sound files |

Blizzard ships a baseline set of handles (dialog backgrounds, tooltip background, default fonts, etc.) so Fetch can succeed even with no third-party SharedMedia pack.

---

## 3. Core API surface

| Method | Purpose |
|--------|---------|
| `Register(mediatype, key, data[, langmask])` | Publish a handle; returns false if key already taken |
| `Fetch(mediatype, key[, noDefault])` | Canonical read path; honors global override + defaults |
| `IsValid` / `HashTable` / `List` | Enumeration for options UIs |
| `GetGlobal` / `SetGlobal` | Override Fetch results globally for a type |
| `GetDefault` / `SetDefault` | Default handle management |

**Callbacks** (CallbackHandler-style):

- `LibSharedMedia_Registered` — new handle appeared (other addons / SharedMedia packs loaded later)
- `LibSharedMedia_SetGlobal` — global override changed

UI that caches a font path must re-Fetch (or re-apply) on these callbacks during a theatrical / theme pass.

---

## 4. AceConfig integration

[AceGUI-3.0-SharedMediaWidgets](https://www.wowace.com/projects/ace-gui-3-0-shared-media-widgets) provides AceConfig `select`-style widgets that list LSM hashes (fonts, statusbars, etc.). Contemporary options panels that expose “Font” / “Texture” dropdowns almost always use this stack:

`AceConfig table` → SharedMedia widget → `LSM:Fetch` in the setter → apply to frames.

Without Ace, authors still call `LibStub("LibSharedMedia-3.0")` the same way; only the picker UI differs.

---

## 5. Soft-dependency norms

| Pattern | Meaning for CoB |
|---------|-----------------|
| Embed LSM | Guarantees Register/Fetch exist |
| OptionalDeps SharedMedia / LSM | Plays nice with community media packs |
| Register Church media only if files present | Matches §10 fallback doctrine |
| Hard-require a custom font | Violates V1 “always load” success criteria |

V1 recommendation: **do not depend on LSM**. Use default fonts/textures.  
Later visual pass: optionally `Register` Church fonts/statusbars **and** always Fetch with fallback; treat SharedMedia packs as player-side enhancement, not a install requirement.

---

## 6. Relevance to Church of Beef brand

Brand direction (gothic / Scarlet / absurd religious pageantry) will eventually want custom fonts and bar textures. LSM is how that media becomes selectable alongside ElvUI users’ existing libraries — useful for streamers who already theme their UI.

Until that art pass exists, LSM is documentation-only for CoB.
