# Icon authoring for Beef brand V2

**Last updated:** 2026-07-25  
**Track:** [44-custom-textures-media-packaging](README.md)  
**Color tokens:** [23-color-brand-tokens](../23-color-brand-tokens/) — this note covers **raster craft**, not hex tables.  
**Visual pole:** [03-visual-language-reference.md](../03-visual-language-reference.md) — theatrical Classic-native, not ElvUI flat.

---

## 1. When icons ship

| Phase | Icons |
|-------|-------|
| **V1** | Stock Blizzard path for LibDBIcon (meat / holy / tabard-adjacent `Interface\Icons\...`). No custom files. Plain frames. |
| **V2** | Branded minimap mark; optional rank chips; optional toast glyph; optional panel chrome textures. Still no SharedMedia dependency. |

Spec already locks missing-media fallback and defers dark-iron theatrical chrome ([design §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 2. Brand signals the pixels must carry

From product + brand tracks (not SharedMedia):

- Absurd holy institution: **Scarlet / cathedral / steak** pageantry
- Comedy + rivalry — icons can be slightly ridiculous, never “generic Discord bot”
- Hard edges, **1-px gold/candle ring** (“halo”), bone/parchment fields — not soft neon glow, not rounded-full app-icon gradients ([visual language](../03-visual-language-reference.md); track 02 raw notes on cursors/icons)
- Scarlet ≠ hostile red ≠ DK red — keep brand crimson warmer/deeper so combat semantics don’t collide ([track 23](../23-color-brand-tokens/))

**Silhouette test:** at 17×17 (minimap hole) and at 32×32 (toast), the mark should still read as “Church,” not a brown smudge.

---

## 3. Minimap / LDB icon (highest priority V2 art)

LibDBIcon builds a ~31×31 button with ~**17×17 artwork** under Blizzard’s `MiniMap-TrackingBorder` ([LibDBIcon source patterns](https://github.com/Jimmerz28/WoW-Addons/blob/master/Interface/AddOns/Skada/lib/LibDBIcon-1.0/LibDBIcon-1.0.lua); [WowAce overview](https://www.wowace.com/projects/libdbicon-1-0)).

**Author checklist**

1. Canvas **64×64** (or 128×128), PoT, 32-bit TGA with alpha.
2. Keep meaningful ink inside ~70% center — corners get eaten by the circular tracking border.
3. High local contrast: scarlet/gold on dark iron or parchment, not mid-gray on mid-gray.
4. No tiny text in the icon (unreadable at 17px).
5. Export TGA for dev; optional BLP for release zip ([formats note](01-power-of-two-and-formats.md)).
6. Path: `Interface\AddOns\ChurchOfBeef\Media\Icons\cob_minimap` ([paths note](02-interface-path-rules.md)).

**V1 placeholder (no art):** pick a stock icon that already signals food/holy/tabard, e.g. meat or blessing-style `Interface\Icons\...`, and swap the LDB `icon` string in V2.

Do **not** invent a custom circular crop pipeline; design for the stock border. `SetPortraitToTexture` is a BLP-oriented footgun for TGA authors ([archive note](https://www.wowinterface.com/forums/archive/index.php/t-51853.html)).

---

## 4. Rank chips & toast glyphs

Seven ranks need **distinct silhouettes**, not seven scarlet blobs.

| Approach | Guidance |
|----------|----------|
| Shared crest + rank accent | One Church mark + different gold bar count / bone notch / steak tally |
| Per-rank icons | Only if silhouettes stay unique at 24px; else merge to crest + text |
| Color alone | Forbidden as sole encoding ([track 23](../23-color-brand-tokens/)) — pair with shape or label |

Toast glyphs: single 64×64 “approved / pending / excommunicated” marks with word labels in UI — icon reinforces, does not replace copy.

---

## 5. Panel chrome (V2 theatrical pass)

Deferred textures (not V1 blockers):

| Asset | Size | Role |
|-------|------|------|
| Parchment fill | 128² or 256² tile | Ladder / My Standing backdrop |
| Edge / border strip | 64×256 or atlas in one 256² | Scarlet/iron bevel — or reuse Blizzard `edgeFile` with `SetBackdropBorderColor` until art exists |
| Header banner | 512×128 | Ceremony frame only |

Prefer **tiling** quiet noise (~low contrast) over busy stained-glass that fights text. Stream readability track still owns contrast budgets; textures must not drop body text below targets.

Backdrop without custom art (V1 and early V2): white swatch + vertex color ([Blizzard UI forum pattern](https://us.forums.blizzard.com/en/wow/t/drawing-rectangles-for-borders/1189042)) — zero packaging cost.

---

## 6. Authoring pipeline (recommended)

```text
Source (PSD/Krita) 64–128 PoT
    → flatten single alpha
    → export TGA via GIMP if PS alpha misbehaves
    → drop into Media/Icons/
    → /reload in Anniversary client
    → screenshot minimap + toast at native UI scale
    → optional: convert to BLP for release zip
```

Tools called out by authors: **GIMP**, **Paint.NET**, BLP converters ([WoWInterface thread](https://www.wowinterface.com/forums/showthread.php?t=42139)).

---

## 7. Explicit non-goals (avoid duplicating track 10)

- Registering Beef parchment as LSM `background` / `statusbar` for ElvUI users
- Masque skin packs framed as Church of Beef
- Shipping a general SharedMedia_* addon

If the guild later wants optional LSM registration, that is an **optional satellite** designed under track 10 — not core ChurchOfBeef V2.

---

## 8. Acceptance criteria for V2 art drop

- [ ] All files PoT; 32-bit TGA (and/or BLP) under `Media/`
- [ ] Minimap icon legible at default UI scale under tracking border
- [ ] Rank/toast marks dual-encoded with text/shape
- [ ] Missing file → color/Blizzard fallback; `/beef` still opens
- [ ] No PNG reliance; no SharedMedia hard dependency
- [ ] Brand reads Scarlet-holy-absurd, not generic red app icon
