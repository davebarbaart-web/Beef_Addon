# Church of Beef — Custom Asset Production Spec & Inventory
**Date:** 2026-08-18
**Purpose:** (1) the delivery rules ChatGPT must follow so generated assets can be imported into the game by an agent pipeline with zero manual cleanup (no background erasing, no recropping); (2) the running inventory of every custom asset the product needs, by priority.
**Consumers:** David (prompting ChatGPT), the import agent (conversion + placement), the Vestments lanes (consuming `Media/` paths).
**Companion:** `UI_Render_Critique_Batch4_2026-08-18.md`.

---

## Part 1 — Why mockups and assets are different requests

Everything generated so far is a **mockup**: a full scene proving art direction. An **asset** is one extractable object on a transparent background that ships inside the addon. Mockups tolerate garbled text and baked-in lighting; assets tolerate neither. From now on, every ChatGPT request must declare which mode it is, and asset-mode requests must carry the delivery block below verbatim.

## Part 2 — The target format (what the game actually loads)

The Anniversary client (`## Interface: 20506`) loads addon textures as **BLP** or **32-bit uncompressed TGA with alpha channel**. It does not reliably load PNG. So the pipeline is:

**ChatGPT delivers master PNG (RGBA, true transparency) → import agent converts → TGA/BLP → `addon/ChurchOfBeef/Media/` → referenced by file path in Lua.**

Hard rules the conversion step imposes back on generation:

1. **True alpha transparency.** The PNG must carry a real transparent background — not white, not checkerboard-drawn, not a scene. ChatGPT's image tool supports transparent-background output; every asset prompt must explicitly request it. Fallback if a given generation can't do transparency: solid **magenta #FF00FF** background (the agent chroma-keys it), but transparency is the standard.
2. **Power-of-two final dimensions.** Every in-game texture ends up at 64, 128, 256, 512, or 1024 px per side (not necessarily square: 512×128 is a valid bar). ChatGPT delivers big masters (≥1024, ideally 2048 square); the agent downscales and pads to the target. Composition must survive centered padding — so: **asset centered, ~8–10% empty margin on all sides, nothing touching the canvas edge.**
3. **Tintable assets ship neutral.** Health-bar and favor-bar fills get their color from code (`SetVertexColor` with class colors). Deliver those as **grayscale-to-white** texture strips, not pre-colored. Anything pre-colored can never be class-tinted.
4. **Frames ship as parts, not pictures.** A border the UI can stretch needs corner and edge pieces (9-slice): 4 corners, 4 edges (edges must tile seamlessly along their axis), optional center fill. One labeled file per piece, consistent thickness. A single flattened frame picture is a mockup, not an asset.
5. **No baked environment.** No drop shadows against imaginary backgrounds, no candle-glow spill, no vignette, no perspective — straight-on orthographic, even matte lighting (soft top-left at most). Glow effects are separate additive layers if we want them.
6. **No text inside assets** unless the text *is* the asset (e.g., the motto ring on the papal seal, which must then be re-specified with exact spelling and treated as decorative). Names, numbers, and labels are always rendered live by the game in fonts.
7. **One asset per image. No watermarks, no signatures, no version tags.**
8. **Consistency across a family beats beauty of any single piece** (R10's own rule). Same palette, same engraving depth, same metal finishes: muted gold, aged silver, dark iron, oxblood wax. When requesting a family, request it in one session with the style anchor image attached.

### Paste-ready ASSET MODE block for ChatGPT

> ASSET MODE — delivery requirements, non-negotiable: Output a single game-ready UI asset as a PNG with a genuinely TRANSPARENT background (alpha channel; no white, no checkerboard, no scene). One asset only, centered, orthographic straight-on view, even matte lighting, no drop shadow, no glow spill, no vignette, no perspective, nothing touching the canvas edge (keep ~10% margin). No text anywhere in the image [unless this request states otherwise]. No watermark or signature. Canvas 2048×2048 [or 2048×512 for bars/edges]. Style anchor: match the attached Church of Beef seal-sheet render — engraved metal and wax, muted antique gold / aged silver / dark iron / oxblood, worn but dignified. If transparency is impossible for this generation, use a solid #FF00FF background instead and say so.

### File naming (ChatGPT should title them; the agent enforces)

`COB_<category>_<name>[_<variant>][_<part>].png` — e.g. `COB_seal_papal_gold.png`, `COB_frame_proclamation_corner-TL.png`, `COB_bar_stainedglass_fill.png`. Categories: `seal`, `sigil`, `glyph`, `rank`, `frame`, `parchment`, `bar`, `roundel`, `ornament`.

### Import agent pipeline (for the Cursor/automation side)

1. Validate: RGBA, transparency present (or keyable magenta), single connected asset, margin respected.
2. Downscale to target size(s) from the inventory table; pad to power-of-two.
3. Convert PNG → 32-bit TGA (and/or BLP2 via BLPConverter); verify in-client render at 100% and 50% scale.
4. Place under `addon/ChurchOfBeef/Media/<Category>/`; append to a generated `Media/manifest.lua` (name → path, size) so Lua never hardcodes stray paths.
5. Record provenance (prompt + date) in `docs/design/renders/ASSET_LOG.md`.

## Part 3 — Assets that do NOT come from ChatGPT

- **Fonts (2):** one blackletter display face, one book serif — these are licensed font files, not generated images. Candidates under the SIL Open Font License, TTF, shippable inside an addon: blackletter — *Grenze Gotisch* or *UnifrakturMaguntia* (pick after an in-client legibility test at 14–30px); serif — *EB Garamond* or *Alegreya*. The typography rule they serve: blackletter for proclamation headlines and fighter names; serif small caps for labels; serif for body.
- **Sound cues (6):** Sanction bell, Verdict, Elevation, Knighting, Cowardice, (later) Canonization — §19.4. OGG files via PlaySoundFile. MVP path: audition Blizzard's own built-in sound kit IDs (costs nothing, always fits the client); custom OGG (CC0 bell/choir sources, lightly edited) is the upgrade. Never from an image model.
- **The six-rank icon set** *can* come from ChatGPT (see inventory) but should wait for the R10b sheet so it inherits the family style.

## Part 4 — The custom asset inventory

Priority 1 = needed by the Vestments lanes now; 2 = needed before the first streamed Gathering; 3 = polish after.

| # | Asset | Pri | Source render | Files / parts | Final size(s) | Notes |
|---|-------|-----|---------------|---------------|---------------|-------|
| 1 | Minimap roundel (bull) | 1 | R10 sheet | 3: normal, pushed, highlight ring | 64² | The addon's one permanent pixel; do first |
| 2 | Papal bull wax seal | 1 | R10 sheet | 2: large, small | 256², 128² | Decree, proclamations, console title chip |
| 3 | Gora sigil (bull + crossed axes shield) | 1 | R10 sheet | 2 sizes | 256², 64² | HUD centerpiece, Gora desk |
| 4 | Cowardice sigil + oxblood verdict seal | 1 | R10 + Batch 2 stamp | 2 | 256² | Cowardice beat |
| 5 | Victor gold bull seal | 1 | NEW (R10b) | 1 | 256² | Kills the lion on Victor Declared |
| 6 | Proclamation parchment frame | 1 | Victor Declared | 9-slice (4 corners, 4 edges) + parchment center fill + 4 iron corner-pin ornaments | edges 256×64 etc. | Reused by verdict, sanction, knighting surfaces |
| 7 | HUD kit | 1 | HUD-B reference | fighter plate frame L/R, portrait ring, crest mount, favor frame | mixed, ≤512×128 | Iron + thin parchment text field per Batch 3 |
| 8 | Stained-glass bar fill | 1 | HUD-B | 1 grayscale tileable strip (+1 spark cap) | 256×32 | WHITE/gray only — code tints per class |
| 9 | Favor bar fill + FAVOR label sigil | 1 | HUD-B + R10b palm | 2 | 256×32, 64² | Fill grayscale (tinted per fighter) |
| 10 | Engraved stat glyphs (record, defenses, head-to-head, stipulation) | 2 | R10 glyph grid | 4 | 64² | Fighter Card ledger rows |
| 11 | Kneeling-knight sigil | 2 | NEW (R10b) | 2 sizes | 256², 64² | Knighting banner medallion |
| 12 | Sanction bell sigil | 2 | NEW (R10b) | 1 | 64² | Sound-moment iconography, console |
| 13 | Rank icons — the six canon ranks | 2 | NEW rank sheet | 6 | 64² | Console Present list, Records Book medallion chips |
| 14 | Cleaver (Butcher) + council-ring sigils | 3 | NEW (R10b) | 2 | 64² | Rank set adjuncts |
| 15 | Knighting banner strip + sunburst rays | 2 | R7 v2 | banner 9-slice + rays overlay | rays ≤512² | Rays as separate additive layer |
| 16 | Decree parchment (nailed, curled) + iron nail | 2 | Batch 2 Decree | parchment + nail overlay | 512×256 | Quiet Mode's one object |
| 17 | Records Book tome spread | 3 | Batch 2 tome | 2-page background, ribbon bookmarks ×4, illuminated capitals A–Z subset | 1024×512 | Big; slice carefully; capitals can be one strip |
| 18 | Chronicle mark (book + bull) | 3 | R10 | 2 sizes | 128², 64² | MARK THIS MOMENT affordance |
| 19 | Fighter Card frame | 2 | Fighter Card v2 | 9-slice + bull-horn header ornament | header ≤512×128 | Parchment interior reuses #6 fill |
| 20 | Sacred-verb iron plate (SANCTION / KNIGHT THIS BEEF button) | 2 | Console v3 | 3 states: normal, hover, pressed | 256×64 | The one ornament the plain console is allowed |
| 21 | Fonts: blackletter + serif | 1 | — | 2 TTF (OFL) | — | Part 3; not generated |
| 22 | Sound cues ×6 | 2 | — | OGG | — | Part 3; not generated |

**Suggested first asset session with ChatGPT:** anchor with the R10 sheet image, then request #1–#5 one at a time in ASSET MODE (they're small, style-defining, and reused everywhere). If those five convert and render clean in-client, the pipeline is proven and the frames (#6, #7) — the hardest deliveries because of 9-slice discipline — go next.

## Part 5 — Definition of done, per asset

An asset is DONE when: the master PNG passes validation; the converted TGA/BLP renders in the Anniversary client at intended size without halo, fringe, or blur; it's placed under `Media/` with a manifest entry; and the source prompt is logged in `ASSET_LOG.md`. Anything short of in-client verification is a candidate, not an asset — same honesty rule as the rest of the project.
