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
| Date | Source PNG | Prompt | Output TGA(s) | Sizes |
|------|------------|--------|---------------|-------|
| 2026-08-20 | assets/incoming/COB_frame_banner_knighting.png | _(none)_ | addon/ChurchOfBeef/Media/Frame/banner_knighting.tga | 512×128 |
| 2026-08-20 | assets/incoming/COB_frame_fightercard.png | _(none)_ | addon/ChurchOfBeef/Media/Frame/frame_fightercard.tga | 512×128 |
| 2026-08-20 | assets/incoming/COB_frame_proclamation.png | _(none)_ | addon/ChurchOfBeef/Media/Frame/frame_proclamation.tga | 256×256 |
| 2026-08-20 | assets/incoming/COB_frame_proclamation_center.png | _(none)_ | addon/ChurchOfBeef/Media/Frame/frame_proclamation_center.tga | 256×256 |
| 2026-08-20 | assets/incoming/COB_frame_proclamation_pin_bl.png | _(none)_ | addon/ChurchOfBeef/Media/Frame/frame_proclamation_pin_bl.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_frame_proclamation_pin_br.png | _(none)_ | addon/ChurchOfBeef/Media/Frame/frame_proclamation_pin_br.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_frame_proclamation_pin_tl.png | _(none)_ | addon/ChurchOfBeef/Media/Frame/frame_proclamation_pin_tl.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_frame_proclamation_pin_tr.png | _(none)_ | addon/ChurchOfBeef/Media/Frame/frame_proclamation_pin_tr.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_glyph_defenses.png | _(none)_ | addon/ChurchOfBeef/Media/Glyph/glyph_defenses.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_glyph_headtohead.png | _(none)_ | addon/ChurchOfBeef/Media/Glyph/glyph_headtohead.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_glyph_record.png | _(none)_ | addon/ChurchOfBeef/Media/Glyph/glyph_record.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_glyph_stipulation.png | _(none)_ | addon/ChurchOfBeef/Media/Glyph/glyph_stipulation.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_ornament_bullhorn.png | _(none)_ | addon/ChurchOfBeef/Media/Ornament/ornament_bullhorn.tga | 512×128 |
| 2026-08-20 | assets/incoming/COB_ornament_nail.png | _(none)_ | addon/ChurchOfBeef/Media/Ornament/ornament_nail.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_parchment_decree.png | _(none)_ | addon/ChurchOfBeef/Media/Parchment/parchment_decree.tga | 512×256 |
| 2026-08-20 | assets/incoming/COB_ornament_plate_verb.png | _(none)_ | addon/ChurchOfBeef/Media/Ornament/plate_verb.tga | 256×64 |
| 2026-08-20 | assets/incoming/COB_ornament_plate_verb_hover.png | _(none)_ | addon/ChurchOfBeef/Media/Ornament/plate_verb_hover.tga | 256×64 |
| 2026-08-20 | assets/incoming/COB_ornament_plate_verb_pressed.png | _(none)_ | addon/ChurchOfBeef/Media/Ornament/plate_verb_pressed.tga | 256×64 |
| 2026-08-20 | assets/incoming/COB_ornament_rays_sunburst.png | _(none)_ | addon/ChurchOfBeef/Media/Ornament/rays_sunburst.tga | 512×512 |
| 2026-08-20 | assets/incoming/COB_ornament_ribbon_bookmark.png | _(none)_ | addon/ChurchOfBeef/Media/Ornament/ribbon_bookmark.tga | 64×256 |
| 2026-08-20 | assets/incoming/COB_roundel_minimap.png | Built-in ImageGen, 2026-08-20. Tiny-readable minimap roundel: a compact charcoal medallion dominated by one simplified antique-gold bull head, with a bold silhouette and minimal detail that remains legible at 20 px; orthographic, no text or faction marks, genuine transparent alpha. A background-extraction-only pass removed the generator's baked checkerboard without redesigning the emblem. | addon/ChurchOfBeef/Media/Roundel/roundel_minimap.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_seal_cowardice.png | _(none)_ | addon/ChurchOfBeef/Media/Seal/seal_cowardice.tga | 256×256 |
| 2026-08-20 | assets/incoming/COB_seal_papal.png | Built-in ImageGen, 2026-08-20. Canonical papal bull wax seal: forward-facing bull head embossed in oxblood wax with a restrained antique-gold rim; Warcraft-compatible ecclesiastical game UI style; orthographic, no text or faction marks, transparent alpha. Background extraction pass preserved the seal and produced true transparency. | addon/ChurchOfBeef/Media/Seal/seal_papal.tga; addon/ChurchOfBeef/Media/Seal/seal_papal_small.tga | 256×256; 128×128 |
| 2026-08-20 | assets/incoming/COB_seal_victor.png | Built-in ImageGen, 2026-08-20. Victor's bull seal derived from the canonical papal seal: antique-gold bull relief with deeper charcoal shadows, same round silhouette and heraldic rim; orthographic, no text or faction marks, transparent alpha. Background extraction pass produced true transparency. | addon/ChurchOfBeef/Media/Seal/seal_victor.tga | 256×256 |
| 2026-08-20 | assets/incoming/COB_sigil_favor.png | _(none)_ | addon/ChurchOfBeef/Media/Sigil/sigil_favor.tga | 64×64 |
| 2026-08-20 | assets/incoming/COB_sigil_gora.png | Built-in ImageGen, 2026-08-20. Canonical Beef Gora sigil: forward-facing bull above crossed axes inside a dark-iron heater shield with antique-gold engraved edging; compact Warcraft-compatible game UI icon; orthographic, no text or faction marks, transparent alpha. Background extraction pass preserved the sigil and produced true transparency. | addon/ChurchOfBeef/Media/Sigil/sigil_gora.tga; addon/ChurchOfBeef/Media/Sigil/sigil_gora_small.tga | 256×256; 64×64 |
| 2026-08-20 | assets/incoming/COB_parchment_tome_records.png | _(none)_ | addon/ChurchOfBeef/Media/Parchment/tome_records.tga | 1024×512 |
