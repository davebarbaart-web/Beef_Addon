# Incoming master PNGs

Drop ChatGPT ASSET MODE masters here, then run:

```bash
python3 scripts/import-assets.py
```

Requires Pillow (`pip3 install Pillow`). `python3 scripts/import-assets.py --selftest`
validates the pipeline in a temp dir without touching `Media/` or the log.

## Filename convention

`COB_<category>_<name>[_<variant>][_<part>].png`

Categories: `seal`, `sigil`, `glyph`, `rank`, `frame`, `parchment`, `bar`, `roundel`, `ornament`.

Examples: `COB_seal_papal.png`, `COB_seal_papal_gold.png`, `COB_frame_proclamation_corner_TL.png`.

Rules:

- Hyphens and underscores both work; hyphens normalize to underscores (`corner-TL` → `corner_tl`).
- Never name a variant/part `small` or `tiny` — those are reserved size suffixes.
- The manifest key is what `Theme:Texture("...")` looks up. Use the Theme semantic names:
  `COB_roundel_minimap.png` (not `roundel_bull`), `COB_ornament_bullhorn.png` (not `horns`).

## Theme keys with non-category first tokens

These come from canonical incoming names (aliases):

| Theme key | Drop this file |
|-----------|----------------|
| `banner_knighting` | `COB_frame_banner_knighting.png` |
| `rays_sunburst` | `COB_ornament_rays_sunburst.png` |
| `tome_records` | `COB_parchment_tome_records.png` |
| `ribbon_bookmark` | `COB_ornament_ribbon_bookmark.png` |
| `plate_verb` / `plate_verb_hover` / `plate_verb_pressed` | `COB_ornament_plate_verb[_hover|_pressed].png` |

Optional sidecar prompt (logged in `docs/design/renders/ASSET_LOG.md`):

- `COB_seal_papal.prompt.txt` (same stem as the PNG), or
- `seal_papal.prompt.txt` (semantic name)

The importer is the sole writer of `addon/ChurchOfBeef/Media/<Category>/*.tga` and `Media/manifest.lua`. Do not hand-edit the manifest. A failed master (corrupt, opaque, edge-touching, bad name) fails that file only; the rest of the batch still imports, and the run exits non-zero.
