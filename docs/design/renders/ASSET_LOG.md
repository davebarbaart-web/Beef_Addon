# Church of Beef — custom asset import log

Written by `scripts/import-assets.py`. **Do not hand-edit the table** — each
import run regenerates this file from a fixed header plus the current import
record (the `Media/<Category>/*.tga` tree after prune). Re-importing the same
master updates its row rather than duplicating it. Deleting a master PNG and
re-running removes its TGA(s) and its row.

Masters land in `assets/incoming/` as `COB_<category>_<name>[_<variant>][_<part>].png`.
Optional prompt sidecar: `assets/incoming/<stem>.prompt.txt` or `<semantic>.prompt.txt`.

## Manifest key / size-suffix scheme

Theme (and Lua) look up `ChurchOfBeefMediaManifest[key]`.

| Piece | Rule | Example |
|-------|------|---------|
| Semantic | `<category>_<name>[_<variant>][_<part>]` (lowercase) | `seal_papal`, `seal_papal_gold`, `roundel_bull_pushed` |
| Canonical size | no suffix = first / largest inventory size | `seal_papal` → `Media/Seal/seal_papal.tga` (256²) |
| Second size | `_small` | `seal_papal_small` → 128²; `sigil_gora_small` → 64² |
| Third size | `_tiny` | unused in the Part 4 table today |
| Fourth+ | `_tiny2`, `_tiny3`, … | unused today |
| Unlisted name | one size: next power-of-two, max 1024 (warning) | `seal_fixture` from a 2048² master → 1024² |

Inventory is keyed by `<category>_<name>` with longest prefix match at `_` or `-`
(so `bar_stainedglass_fill` inherits `bar_stainedglass` = 256×32). Variants must
not be named `small` or `tiny`. Hyphens normalize to underscores
(`corner-TL` → `corner_tl`).

Theme keys whose first token is not a category come from canonical incoming
names (KEY_ALIASES): `COB_frame_banner_knighting.png` → `banner_knighting`,
`COB_ornament_rays_sunburst.png` → `rays_sunburst`,
`COB_parchment_tome_records.png` → `tome_records`,
`COB_ornament_ribbon_bookmark.png` → `ribbon_bookmark`,
`COB_ornament_plate_verb[_hover|_pressed].png` → `plate_verb*`.

Category folders: Seal, Sigil, Glyph, Rank, Frame, Parchment, Bar, Roundel, Ornament.

## Current inventory (this run)

<!-- ASSET_LOG_TABLE -->
_No assets imported this run._
