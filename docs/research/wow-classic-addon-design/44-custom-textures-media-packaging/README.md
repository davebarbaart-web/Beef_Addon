# Track 44 — Custom textures, icons, BLP/TGA packaging

**Lane:** Focused research (file formats + paths + Beef brand icon authoring)  
**Last updated:** 2026-07-25  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 (plain frames + missing-media fallback), §14 (V2 ceremonial theater)  
**Does not cover:** LibSharedMedia / SharedMedia packs / Masque button skins (see [10-skinning-masque-sharedmedia](../10-skinning-masque-sharedmedia/)); brand hex tokens ([23-color-brand-tokens](../23-color-brand-tokens/)); sound file packaging ([20-sound-sfx-feedback](../20-sound-sfx-feedback/)). No addon code or commits in this folder.

## Purpose

How Church of Beef should author, size, format, and path custom raster art for the Anniversary (TBC Classic) client — especially for a **V2 brand icon / chrome** pass — without depending on SharedMedia.

## Docs in this track

| File | Contents |
|------|----------|
| [01-power-of-two-and-formats.md](01-power-of-two-and-formats.md) | Power-of-two rule; BLP vs TGA; PNG/JPEG caveats on Classic |
| [02-interface-path-rules.md](02-interface-path-rules.md) | `Interface/AddOns/...` paths, extensions, reload, inline `|T` markup |
| [03-icon-authoring-beef-v2.md](03-icon-authoring-beef-v2.md) | Minimap / rank / toast icon authoring for Beef brand V2 |
| [annotated-urls.md](annotated-urls.md) | Annotated primary URLs |

## Top takeaways (one screen)

1. **V1 ships zero custom textures.** Spec §10: plain Classic frames; missing media must fall back and still load. Custom art is a V2 theatrical pass.
2. **Every custom bitmap must be power-of-two on each axis** (e.g. 16×16, 64×64, 256×128). Non-PoT dimensions fail or mis-render ([SetTexture — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture); [BLP files — Wowpedia](https://wowpedia.fandom.com/wiki/BLP_files)).
3. **Anniversary-safe formats: TGA and BLP.** Prefer **TGA for authoring** (edit in GIMP/Paint.NET), convert to **BLP for ship size / native format** when the zip matters ([WoWInterface BLP/TGA thread](https://www.wowinterface.com/forums/showthread.php?t=42139)). Do not assume retail PNG texture support (added Retail **10.0.7**).
4. **Path = `Interface\AddOns\<AddonFolder>\Media\...` with backslashes in Lua strings.** Omit extension for BLP/TGA in many call sites; **PNG (when supported) requires `.png`** ([SetTexture details](https://warcraft.wiki.gg/wiki/API_TextureBase_SetTexture)).
5. **Beef brand icons: hard-edged Scarlet/gothic mark, not soft neon.** Design for LibDBIcon’s ~17×17 artwork hole + tracking border; author at 64×64 (or 128×128) with alpha, then rely on downscale ([LibDBIcon](https://www.wowace.com/projects/libdbicon-1-0)).
6. **Do not register Beef art into LibSharedMedia in V1/V2 core.** Ship private paths under ChurchOfBeef; leave SharedMedia to track 10 if guild members want optional packs later.

## Boundary vs track 10

| Track 10 owns | Track 44 owns |
|---------------|---------------|
| LSM `:Register` / `:Fetch` for fonts, statusbars, borders, sounds | File formats, PoT sizes, path strings |
| Masque skinning / button framing culture | Authoring Beef’s own icons & panel textures |
| SharedMedia community packs | What to put in `ChurchOfBeef/Media/` |

## Provenance

Search/extract JSON under [`.raw/`](.raw/). Prefer warcraft.wiki.gg / Wowpedia / WoWInterface author threads over listicles.
