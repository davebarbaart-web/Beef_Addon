# Annotated URLs — custom textures / BLP–TGA packaging

**Last updated:** 2026-07-25  
**Track:** [44-custom-textures-media-packaging](README.md)

Primary sources for Track 44. Prefer these over “best UI texture packs” listicles.  
**Not listed here on purpose:** LibSharedMedia API / SharedMedia pack pages — those belong to [track 10](../10-skinning-masque-sharedmedia/).

---

## SetTexture, formats, dimensions

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture | Canonical: PoT custom images; BLP/JPEG/PNG/TGA; TGA bit depths + RLE; PNG needs `.png`; async load; `/reload` for new AddOns files (9.0.1+); PNG support patch **10.0.7** (Retail — verify before Classic use). |
| https://wowpedia.fandom.com/wiki/BLP_files | BLP2 header, mip chain, DXT/RAW, PoT rule, note that engine also accepts TGA for addon work. |
| https://wowdev.wiki/BLP | Low-level BLP format reference for converter/debug work. |
| https://warcraft-rs.readthedocs.io/en/latest/formats/graphics/blp.html | Empirical BLP stats by expansion (TBC-era 100% PoT); compression/alpha patterns. |
| https://warcraft-rs.readthedocs.io/en/latest/guides/texture-loading.html | BLP versions, compression types, PoT/max size notes for tooling. |

---

## Author practice (TGA vs BLP, alpha)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowinterface.com/forums/showthread.php?t=42139 | Living author thread: TGA works via SetTexture; BLP for size; Photoshop alpha pain → GIMP; RLE debate; ≥16×16 folklore. |
| https://www.wowinterface.com/forums/archive/index.php/t-42139.html | Archive mirror of the same thread. |
| https://www.wowinterface.com/downloads/info6127-BLP2PNG.html | Community BLP↔PNG utility commonly linked by authors. |
| https://github.com/mitjafelicijan/blpconvert | Modern open-source BLP→PNG/TGA helper (verify outputs in client). |

---

## Paths, inline textures, minimap icons

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/UI_escape_sequences | `|Tpath:height|t` markup for optional V2 text flair; cropping params. |
| https://www.wowace.com/projects/libdbicon-1-0 | Official LibDBIcon usage; LDB `icon` path string (stock or custom). |
| https://www.wowinterface.com/forums/showthread.php?t=54315 | Phanx: prefer LDB + LibDBIcon; how to point `icon` at a custom path. |
| https://www.wowinterface.com/forums/archive/index.php/t-51853.html | `SetPortraitToTexture` ≈ BLP; TGA custom icons may not circularize — design for stock border. |
| https://www.reddit.com/r/wowaddondev/comments/1esk1p2/creating_a_wow_addon_part_12_creating_a_minimap/ | Dev tutorial reminder: minimap image PoT, typically TGA. |

---

## Chrome without custom files (V1 bridge)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/drawing-rectangles-for-borders/1189042 | Backdrop / white swatch + border color — ship V1 with zero Media/. |
| https://warcraft.wiki.gg/wiki/TOC_format | Addon packaging context; media files need not be TOC-listed. |

---

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10–§11, §14 | Plain frames V1; missing-media fallback; V2 ceremony spectacle. |
| [`docs/research/wow-classic-addon-design/03-visual-language-reference.md`](../03-visual-language-reference.md) | Classic-native vs modern; Beef theatrical chrome direction. |
| [`docs/research/wow-classic-addon-design/23-color-brand-tokens/`](../23-color-brand-tokens/) | Scarlet/gold/parchment tokens — color layer under these textures. |
| [`docs/research/wow-classic-addon-design/10-skinning-masque-sharedmedia/`](../10-skinning-masque-sharedmedia/) | Explicit non-overlap: LSM/Masque only. |
| [`docs/research/wow-classic-addon-design/20-sound-sfx-feedback/`](../20-sound-sfx-feedback/) | Parallel packaging story for `.ogg`, not textures. |

---

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-blp-tga-packaging.json`](.raw/search-blp-tga-packaging.json) | Parallel search: BLP/TGA/SetTexture/PoT |
| [`.raw/search-icons-paths.json`](.raw/search-icons-paths.json) | Parallel search: LibDBIcon, minimap paths |
| [`.raw/search-blp-tools-alpha.json`](.raw/search-blp-tools-alpha.json) | Parallel search: alpha, converters |
| [`.raw/search-classic-png-portrait.json`](.raw/search-classic-png-portrait.json) | Parallel search: Classic PNG / BLP docs |
| [`.raw/extract-settexture-blp.json`](.raw/extract-settexture-blp.json) | Extract: SetTexture + WoWInterface BLP/TGA thread |
| [`.raw/extract-portrait-paths.json`](.raw/extract-portrait-paths.json) | Extract: escape sequences + LibDBIcon |
