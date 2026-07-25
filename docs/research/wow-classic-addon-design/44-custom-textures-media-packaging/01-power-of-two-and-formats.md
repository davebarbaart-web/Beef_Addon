# Power-of-two dimensions & BLP vs TGA

**Last updated:** 2026-07-25  
**Track:** [44-custom-textures-media-packaging](README.md)

---

## 1. Hard rule: power-of-two

Custom images passed to `SetTexture` must have **power-of-two width and height** — axes independent, so rectangles are fine if both sides are PoT ([TextureBase:SetTexture — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture)):

| Valid | Invalid |
|-------|---------|
| 16×16, 32×32, 64×64, 128×128 | 48×48, 100×100 |
| 256×64, 512×256, 8×32 | 512×200, 300×128 |

Wowpedia’s BLP notes restate the same constraint for native BLP2 assets: 512×256 is valid; 512×200 is not ([BLP files](https://wowpedia.fandom.com/wiki/BLP_files)). Empirical BLP dumps from TBC-era archives are **100% power-of-2** ([warcraft-rs BLP analysis](https://warcraft-rs.readthedocs.io/en/latest/formats/graphics/blp.html)).

**Practical Beef sizes**

| Use | Author size | Notes |
|-----|-------------|-------|
| Minimap / LDB icon | 64×64 (or 128×128) | Drawn small (~17px hole in LibDBIcon) |
| Rank badge / toast glyph | 64×64 | Keep silhouette readable at 24–32 UI px |
| Panel backdrop tile | 256×256 or 128×128 | Tileable parchment / iron |
| Wide banner / header | 512×128 or 256×64 | Use `SetTexCoord` if art is letterboxed |

Community folklore: avoid **8×8** as a working size (historical client glitches reported on WoWInterface); prefer **≥16×16** ([BLP/TGA thread](https://www.wowinterface.com/forums/showthread.php?t=42139)).

---

## 2. TGA — authoring default

**TGA** is the long-standing “edit in a paint program, drop in AddOns” format.

Documented client acceptance for TGA ([SetTexture](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture)):

- 8 bpp grayscale, 24 bpp RGB, or **32 bpp RGBA**
- **RLE compression supported** (authors disagree on Photoshop’s TGA writer; GIMP export is a common fix)

Authoring tips from addon authors ([same WoWInterface thread](https://www.wowinterface.com/forums/showthread.php?t=42139)):

- Prefer **32-bit with a single alpha channel**. Extra Photoshop alpha layers confuse the client.
- If Photoshop TGA alpha fails: PNG → open in **GIMP** → export TGA.
- Paint.NET is a lighter Windows option mentioned on Blizzard UI forums for custom addon images.

**Pros:** Direct edit/reload loop; no converter in the pipeline.  
**Cons:** Large on disk uncompressed; zip shrinks a lot, but unpacked addon folders bloat.

---

## 3. BLP — ship / native format

**BLP2** is Blizzard’s texture container for WoW ([BLP files — Wowpedia](https://wowpedia.fandom.com/wiki/BLP_files)):

- Header + up to 16 mip levels; mip0 = full size; each level halves dimensions toward 1×1
- Compression modes include palette RAW and **DXT1 / DXT3 / DXT5**
- Alpha bit depths 0 / 1 / 4 / 8 depending on encoding
- WoW UI icons commonly use DXT with alpha (examples in Wowpedia table)

**Why authors convert TGA → BLP**

- Smaller on-disk footprint (Masque plugin author reported **>50% size cut** switching to BLP) ([WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=42139))
- Native format; required for some engine paths historically associated with **Interface folder overrides** (addon `SetTexture` can use TGA; replacing stock UI files often expects BLP)

**Cons:** Conversion step; DXT can introduce color bleed on sharp UI edges — author at higher resolution or use less lossy BLP modes for crisp glyphs; validate on client.

Tooling pointers (community, verify before trusting): [BLP2PNG on WoWInterface](https://www.wowinterface.com/downloads/info6127-BLP2PNG.html), [blpconvert](https://github.com/mitjafelicijan/blpconvert), format notes at [wowdev.wiki/BLP](https://wowdev.wiki/BLP) / [warcraft-rs](https://warcraft-rs.readthedocs.io/en/latest/formats/graphics/blp.html).

---

## 4. PNG / JPEG — do not plan Beef V2 around them on Classic

Retail `SetTexture` docs list **BLP, JPEG, PNG, or TGA**, and note:

- PNG support added **Patch 10.0.7**
- Unlike other formats, **PNG paths must include the `.png` extension** ([SetTexture](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture))

Church of Beef V1/V2 targets **TBC Classic Anniversary**, not Retail 10.x. Treat PNG/JPEG as **unsupported or unverified** for Anniversary packaging unless re-tested on the live Anniversary client. Safe default: **TGA + BLP only**.

---

## 5. Alpha & mipmaps (packaging checklist)

| Concern | Guidance |
|---------|----------|
| Transparency | Author with real alpha; test against dark and parchment UI fills |
| Soft edges | Prefer hard 1-px gold/scarlet rings for brand marks (matches visual-language “halo” idea); soft glow dies at minimap size |
| Mipmaps | BLP can embed mips; UI icons that stay sharp at one size often ship with mips enabled in Blizzard assets — for custom UI glyphs, test both; muddy mips hurt small icons |
| Compression artifacts | High-contrast scarlet/gold logos: inspect DXT edges; fall back to TGA or less aggressive BLP if halo fringes |

---

## 6. Beef packaging recommendation

```
ChurchOfBeef/
  Media/
    Icons/          # 64×64 PoT — minimap, rank chips
      cob_minimap.tga   # or .blp for release zip
      cob_rank_*.tga
    Textures/       # panels / tiles — V2 chrome only
      cob_parchment.tga
      cob_border.tga
```

- **Dev:** keep TGA for fast edit → `/reload`.
- **Release zip:** convert hot-path icons to BLP if size matters; keep source TGA/PSD outside the shipped addon or in a `Media/src` not loaded by the client.
- **Never** require SharedMedia for these paths (track 10 territory).
