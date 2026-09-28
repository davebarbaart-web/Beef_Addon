#!/usr/bin/env python3
"""Church of Beef — master PNG → 32-bit TGA import pipeline.

Sole writer of addon/ChurchOfBeef/Media/manifest.lua and of imported
TGA files under Media/{Seal,Sigil,Glyph,Rank,Frame,Parchment,Bar,Roundel,Ornament}/.
Do not hand-edit the manifest.

Usage:
  python3 scripts/import-assets.py              # process assets/incoming/
  python3 scripts/import-assets.py --selftest   # fixture pipeline in a temp dir

Dependency: Pillow. If missing, this script prints `pip3 install Pillow` and exits 2.

Filename convention (Asset Production Spec Part 2):
  COB_<category>_<name>[_<variant>][_<part>].png
  categories: seal, sigil, glyph, rank, frame, parchment, bar, roundel, ornament

Manifest key / size-suffix scheme (Theme:Texture looks these up):
  semantic = "<category>_<name>[_<variant>][_<part>]"  (lowercased)
  sizes come from INVENTORY keyed by <category>_<name> (longest prefix at
  '_' or '-' boundary). Unlisted names: pad to next power-of-two, max 1024
  (one size), logged as a warning.

  Size suffixes (largest / first inventory entry is canonical):
    <semantic>         → first (largest) size     e.g. seal_papal        256²
    <semantic>_small   → second size              e.g. seal_papal_small  128²
    <semantic>_tiny    → third size
    <semantic>_tinyN   → fourth+ (N=2,3,…)

  Variants must not be named "small" or "tiny" (would collide with suffixes).
  Hyphens normalize to underscores (corner-TL → corner_tl). Theme keys whose
  first token is not a category are produced via KEY_ALIASES canonical names
  (e.g. COB_parchment_tome_records.png → manifest key tome_records).

Validation (fail that file, continue others; exit 1 if any failed):
  - RGBA (RGB/P/LA accepted only when convertible; RGB needs #FF00FF key)
  - real transparency (alpha min < 255) OR solid #FF00FF background (chroma-keyed)
  - content bbox does not touch the canvas edge
  - every side has ≥ 8% empty margin (the spec's ~8–10%)

Idempotent ASSET_LOG: the table section is rewritten each run from this run's
successful imports (which match the Media tree after prune). Re-importing the
same master updates its row; deleting a PNG and re-running removes its TGA(s)
and its log row. Stale TGAs in the category dirs are pruned. Media/Fonts/ is
never touched.

BLP conversion is out of scope (TGA only).
"""

from __future__ import annotations

import argparse
import datetime
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable, List, Optional, Sequence, Tuple

try:
    from PIL import Image, ImageDraw

    try:
        LANCZOS = Image.Resampling.LANCZOS
    except AttributeError:  # Pillow < 9
        LANCZOS = Image.LANCZOS  # type: ignore[attr-defined]
    HAVE_PIL = True
except ImportError:
    Image = None  # type: ignore[assignment]
    ImageDraw = None  # type: ignore[assignment]
    LANCZOS = None
    HAVE_PIL = False


SCRIPT_PATH = Path(__file__).resolve()
REPO_ROOT = SCRIPT_PATH.parent.parent
DEFAULT_INCOMING = REPO_ROOT / "assets" / "incoming"
DEFAULT_MEDIA = REPO_ROOT / "addon" / "ChurchOfBeef" / "Media"
DEFAULT_LOG = REPO_ROOT / "docs" / "design" / "renders" / "ASSET_LOG.md"

CATEGORIES = (
    "seal",
    "sigil",
    "glyph",
    "rank",
    "frame",
    "parchment",
    "bar",
    "roundel",
    "ornament",
)
CATEGORY_DIR = {c: c.capitalize() for c in CATEGORIES}

# Reserved size-suffix tokens — incoming variants must not use these names.
SIZE_SUFFIXES = ("small", "tiny")

MAGENTA = (255, 0, 255)
MARGIN_MIN = 0.08
UNLISTED_MAX = 1024
# Image generators sometimes leave mathematically non-zero, visually empty
# alpha (1/255) on an otherwise transparent canvas edge.  Treat only that
# single quantization step as transparent before margin validation; real edge
# content (alpha >= 2) still fails closed.
ALPHA_NOISE_MAX = 1

# Part 4 inventory: semantic <category>_<name> → [(w, h), ...] largest first.
# Prefix match at '_' / '-' lets variants/parts inherit (seal_papal_gold,
# frame_proclamation_corner-TL, bar_stainedglass_fill, roundel_bull_pushed).
INVENTORY = {
    # #1 Minimap roundel (bull) — 3 states via variant: (none)/pushed/highlight
    "roundel_bull": [(64, 64)],
    "roundel_minimap": [(64, 64)],
    "roundel_portrait": [(128, 128)],
    # #2 Papal bull wax seal
    "seal_papal": [(256, 256), (128, 128)],
    # #3 Gora sigil
    "sigil_gora": [(256, 256), (64, 64)],
    # #4 Cowardice sigil + oxblood verdict seal
    "sigil_cowardice": [(256, 256)],
    "seal_cowardice": [(256, 256)],
    "seal_verdict": [(256, 256)],
    # #5 Victor gold bull seal
    "seal_victor": [(256, 256)],
    # #6 Proclamation parchment frame (9-slice + fill + pins)
    "frame_proclamation": [(256, 256)],
    "frame_proclamation_corner": [(64, 64)],
    "frame_proclamation_edge": [(256, 64)],
    "frame_proclamation_fill": [(256, 256)],
    "frame_proclamation_center": [(256, 256)],
    "frame_proclamation_pin": [(64, 64)],
    "parchment_proclamation": [(256, 256)],
    "parchment_fill": [(256, 256)],
    "ornament_pin": [(64, 64)],
    # #7 HUD kit — mixed, ≤512×128
    "frame_hud": [(512, 128)],
    "frame_fighter": [(512, 128)],
    "frame_favor": [(256, 64)],
    "ornament_crest": [(128, 128)],
    # #8 Stained-glass bar fill (+ spark cap via variant)
    "bar_stainedglass": [(256, 32)],
    # #9 Favor bar fill + FAVOR label sigil
    "bar_favor": [(256, 32)],
    "sigil_favor": [(64, 64)],
    # #10 Engraved stat glyphs
    "glyph_record": [(64, 64)],
    "glyph_defenses": [(64, 64)],
    "glyph_head-to-head": [(64, 64)],
    "glyph_headtohead": [(64, 64)],
    "glyph_stipulation": [(64, 64)],
    # #11 Kneeling-knight sigil
    "sigil_knight": [(256, 256), (64, 64)],
    "sigil_kneeling": [(256, 256), (64, 64)],
    # #12 Sanction bell sigil
    "sigil_bell": [(64, 64)],
    "sigil_sanction": [(64, 64)],
    # #13 Rank icons — six canon ranks
    "rank_fresh": [(64, 64)],
    "rank_cooked": [(64, 64)],
    "rank_knight": [(64, 64)],
    "rank_lord": [(64, 64)],
    "rank_butcher": [(64, 64)],
    "rank_council": [(64, 64)],
    # #14 Cleaver + council-ring
    "sigil_cleaver": [(64, 64)],
    "sigil_council": [(64, 64)],
    # #15 Knighting banner + sunburst rays
    "frame_banner": [(512, 128)],
    "ornament_rays": [(512, 512)],
    "ornament_sunburst": [(512, 512)],
    # #16 Decree parchment + iron nail
    "parchment_decree": [(512, 256)],
    "ornament_nail": [(64, 64)],
    # #17 Records Book tome
    "parchment_tome": [(1024, 512)],
    "ornament_ribbon": [(64, 256)],
    "glyph_capital": [(256, 64)],
    # #18 Chronicle mark
    "sigil_chronicle": [(128, 128), (64, 64)],
    "ornament_chronicle": [(128, 128), (64, 64)],
    # #19 Fighter Card frame + bull-horn header
    "frame_card": [(512, 128)],
    "frame_fightercard": [(512, 128)],
    "ornament_horns": [(512, 128)],
    "ornament_bullhorn": [(512, 128)],
    # #20 Sacred-verb iron plate (normal/hover/pressed via variant)
    "ornament_verb": [(256, 64)],
    "ornament_plate": [(256, 64)],
    "frame_verb": [(256, 64)],
}

SEMANTIC_RE = re.compile(r"^[a-z][a-z0-9_-]*$")

# Theme:Texture keys whose first token is not one of the nine categories are
# produced through these canonical incoming names. Sizes still come from
# INVENTORY by longest-prefix on the incoming semantic.
KEY_ALIASES = {
    "frame_banner_knighting": "banner_knighting",
    "ornament_rays_sunburst": "rays_sunburst",
    "parchment_tome_records": "tome_records",
    "ornament_ribbon_bookmark": "ribbon_bookmark",
    "ornament_plate_verb": "plate_verb",
    "ornament_plate_verb_hover": "plate_verb_hover",
    "ornament_plate_verb_pressed": "plate_verb_pressed",
}


@dataclass
class ParsedName:
    category: str
    semantic: str
    filename: str


@dataclass
class OutputAsset:
    key: str
    rel_tga: str  # e.g. Seal/seal_papal.tga (under Media/)
    width: int
    height: int


@dataclass
class ImportRecord:
    source_name: str
    source_rel: str
    prompt: str
    date: str
    outputs: List[OutputAsset] = field(default_factory=list)
    inventory_key: str = ""
    unlisted: bool = False


def ensure_pillow() -> None:
    if HAVE_PIL:
        return
    print("Pillow is required for scripts/import-assets.py.", file=sys.stderr)
    print("Install: pip3 install Pillow", file=sys.stderr)
    sys.exit(2)


def next_power_of_two(n: int) -> int:
    if n < 1:
        return 1
    p = 1
    while p < n:
        p *= 2
        if p >= UNLISTED_MAX:
            return UNLISTED_MAX
    return p


def default_target(width: int, height: int) -> Tuple[int, int]:
    """Pad to next power-of-two per side, after downscale so max side ≤ 1024."""
    w, h = width, height
    longest = max(w, h)
    if longest > UNLISTED_MAX:
        scale = UNLISTED_MAX / float(longest)
        w = max(1, int(round(w * scale)))
        h = max(1, int(round(h * scale)))
    return next_power_of_two(w), next_power_of_two(h)


def _token_boundary_prefix(semantic: str, key: str) -> bool:
    if semantic == key:
        return True
    if not semantic.startswith(key):
        return False
    nxt = semantic[len(key) : len(key) + 1]
    return nxt in ("_", "-")


def lookup_sizes(semantic: str) -> Tuple[List[Tuple[int, int]], str, bool]:
    """Return (sizes, matched_inventory_key, unlisted)."""
    if semantic in INVENTORY:
        return list(INVENTORY[semantic]), semantic, False
    matches: List[Tuple[int, str]] = []
    for key in INVENTORY:
        if _token_boundary_prefix(semantic, key):
            matches.append((len(key), key))
    if matches:
        matches.sort(reverse=True)
        key = matches[0][1]
        return list(INVENTORY[key]), key, False
    w_h = (1, 1)  # replaced by caller using the actual image size
    return [w_h], "", True


def size_suffix(index: int) -> str:
    if index == 0:
        return ""
    if index == 1:
        return "_small"
    if index == 2:
        return "_tiny"
    return "_tiny%d" % (index - 1)


def parse_incoming_name(filename: str) -> Tuple[Optional[ParsedName], str]:
    stem = Path(filename).stem
    if not stem.upper().startswith("COB_"):
        return None, "filename must start with COB_"
    rest = stem[4:]
    if "_" not in rest:
        return None, "expected COB_<category>_<name>[_<variant>][_<part>]"
    category_raw, remainder = rest.split("_", 1)
    category = category_raw.lower()
    if category not in CATEGORIES:
        return None, "unknown category %r (want %s)" % (category, ", ".join(CATEGORIES))
    if not remainder:
        return None, "missing <name> after category"
    # Hyphens normalize to underscores so COB_frame_proclamation_corner-TL.png
    # keys as frame_proclamation_corner_tl, matching Theme's lookup names.
    semantic = (category + "_" + remainder).lower().replace("-", "_")
    if not SEMANTIC_RE.match(semantic):
        return None, "semantic %r has characters outside [a-z0-9_-]" % semantic
    return ParsedName(category=category, semantic=semantic, filename=filename), ""


def read_prompt_sidecar(incoming: Path, png_path: Path, semantic: str) -> str:
    candidates = [
        incoming / (png_path.stem + ".prompt.txt"),
        incoming / (semantic + ".prompt.txt"),
    ]
    for path in candidates:
        if path.is_file():
            text = path.read_text(encoding="utf-8", errors="replace").strip()
            return " ".join(text.split())
    return ""


def chroma_key_magenta(im: Image.Image) -> Image.Image:
    keyed = [
        (p[0], p[1], p[2], 0) if p[0] == 255 and p[1] == 0 and p[2] == 255 else p
        for p in im.getdata()
    ]
    out = Image.new("RGBA", im.size)
    out.putdata(keyed)
    return out


def border_has_magenta(im: Image.Image) -> bool:
    px = im.load()
    w, h = im.size
    for x in range(w):
        if px[x, 0][:3] == MAGENTA or px[x, h - 1][:3] == MAGENTA:
            return True
    for y in range(h):
        if px[0, y][:3] == MAGENTA or px[w - 1, y][:3] == MAGENTA:
            return True
    return False


def load_rgba(path: Path) -> Tuple[Optional[Image.Image], str]:
    im = Image.open(path)
    im.load()
    original = im.mode
    if original == "RGBA":
        return im, ""
    if original in ("RGB", "P", "PA", "LA", "RGBa"):
        converted = im.convert("RGBA")
        im.close()
        return converted, original
    im.close()
    return None, "not RGBA (mode %s)" % original


def clear_alpha_quantization_noise(im: Image.Image) -> bool:
    """Zero invisible 1/255 alpha specks without relaxing edge validation."""
    alpha = im.split()[3]
    extrema = alpha.getextrema()
    if not extrema or extrema[0] > ALPHA_NOISE_MAX:
        alpha.close()
        return False
    cleaned = alpha.point(lambda value: 0 if value <= ALPHA_NOISE_MAX else value)
    changed = cleaned.tobytes() != alpha.tobytes()
    if changed:
        im.putalpha(cleaned)
    cleaned.close()
    alpha.close()
    return changed


def validate_and_prepare(path: Path) -> Tuple[Optional[Image.Image], List[str], str]:
    """Return (image, warnings, error). Image is RGBA with transparency applied."""
    warnings: List[str] = []
    im, mode_note = load_rgba(path)
    if im is None:
        return None, warnings, mode_note

    extrema = im.split()[3].getextrema()
    min_a = extrema[0] if extrema else 255
    if min_a < 255:
        if clear_alpha_quantization_noise(im):
            warnings.append("cleared invisible alpha=1 quantization noise")
        if mode_note and mode_note != "RGBA":
            warnings.append("converted mode %s → RGBA (alpha present)" % mode_note)
        return im, warnings, ""

    if not border_has_magenta(im):
        extra = " (source mode %s)" % mode_note if mode_note else ""
        im.close()
        return None, warnings, "no transparency (alpha min=255) and no #FF00FF background%s" % extra

    keyed = chroma_key_magenta(im)
    im.close()
    if keyed.split()[3].getextrema()[0] >= 255:
        keyed.close()
        return None, warnings, "chroma-key #FF00FF left no transparent pixels"
    warnings.append("chroma-keyed solid #FF00FF background to transparency")
    return keyed, warnings, ""


def content_bbox(im: Image.Image) -> Optional[Tuple[int, int, int, int]]:
    return im.split()[3].getbbox()


def check_margin(im: Image.Image) -> str:
    bbox = content_bbox(im)
    w, h = im.size
    if bbox is None:
        return "no opaque content (fully transparent after prepare)"
    x0, y0, x1, y1 = bbox
    if x0 <= 0 or y0 <= 0 or x1 >= w or y1 >= h:
        return "content touches canvas edge; bbox=%s on %d×%d" % (bbox, w, h)
    left = x0 / float(w)
    top = y0 / float(h)
    right = (w - x1) / float(w)
    bottom = (h - y1) / float(h)
    sides = (("left", left), ("top", top), ("right", right), ("bottom", bottom))
    worst_name, worst = min(sides, key=lambda s: s[1])
    if worst < MARGIN_MIN:
        return "margin %.1f%% on %s < 8%% (need ~8–10%%); bbox=%s on %d×%d" % (
            worst * 100.0,
            worst_name,
            bbox,
            w,
            h,
        )
    return ""


def fit_and_pad(im: Image.Image, tw: int, th: int) -> Image.Image:
    sw, sh = im.size
    scale = min(tw / float(sw), th / float(sh))
    nw = max(1, int(round(sw * scale)))
    nh = max(1, int(round(sh * scale)))
    if nw > tw:
        nw = tw
    if nh > th:
        nh = th
    resized = im.resize((nw, nh), LANCZOS)
    canvas = Image.new("RGBA", (tw, th), (0, 0, 0, 0))
    canvas.paste(resized, ((tw - nw) // 2, (th - nh) // 2), resized)
    resized.close()
    return canvas


def write_tga(im: Image.Image, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    # Pillow TGA is uncompressed unless rle=True or compression="tga_rle".
    im.save(str(dest), format="TGA", rle=False)


def wow_interface_path(category_dir: str, tga_name: str) -> str:
    return "Interface\\AddOns\\ChurchOfBeef\\Media\\%s\\%s" % (category_dir, tga_name)


def write_manifest(media: Path, outputs: Sequence[OutputAsset]) -> Path:
    dest = media / "manifest.lua"
    media.mkdir(parents=True, exist_ok=True)
    lines = [
        "-- GENERATED by scripts/import-assets.py — do not hand-edit\n",
        "ChurchOfBeefMediaManifest = {\n",
    ]
    for item in sorted(outputs, key=lambda o: o.key):
        category_dir, tga_name = item.rel_tga.split("/", 1)
        path = wow_interface_path(category_dir, tga_name)
        lua_path = path.replace("\\", "\\\\")
        lines.append('  ["%s"] = "%s",\n' % (item.key, lua_path))
    lines.append("}\n")
    dest.write_text("".join(lines), encoding="utf-8")
    return dest


ASSET_LOG_HEADER = """# Church of Beef — custom asset import log

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
"""


def md_cell(text: str) -> str:
    flat = " ".join((text or "").split())
    return flat.replace("|", "/") or "—"


def write_asset_log(log_path: Path, records: Sequence[ImportRecord], _media: Path) -> None:
    log_path.parent.mkdir(parents=True, exist_ok=True)
    body = [ASSET_LOG_HEADER]
    if not records:
        body.append("_No assets imported this run._\n")
    else:
        body.append("| Date | Source PNG | Prompt | Output TGA(s) | Sizes |\n")
        body.append("|------|------------|--------|---------------|-------|\n")
        for rec in sorted(records, key=lambda r: (r.outputs[0].key if r.outputs else r.source_name)):
            tgas = "; ".join(
                "addon/ChurchOfBeef/Media/%s" % o.rel_tga for o in rec.outputs
            )
            sizes = "; ".join("%d×%d" % (o.width, o.height) for o in rec.outputs)
            prompt = rec.prompt if rec.prompt else "_(none)_"
            body.append(
                "| %s | %s | %s | %s | %s |\n"
                % (
                    rec.date,
                    md_cell(rec.source_rel),
                    md_cell(prompt),
                    md_cell(tgas),
                    md_cell(sizes),
                )
            )
    log_path.write_text("".join(body), encoding="utf-8")


def prune_stale_tgas(media: Path, keep: Iterable[Path]) -> List[Path]:
    kept = {p.resolve() for p in keep}
    pruned: List[Path] = []
    for category in CATEGORY_DIR.values():
        folder = media / category
        if not folder.is_dir():
            continue
        for tga in folder.glob("*.tga"):
            if tga.resolve() not in kept:
                tga.unlink()
                pruned.append(tga)
        try:
            next(folder.iterdir())
        except StopIteration:
            folder.rmdir()
    return pruned


def list_incoming_pngs(incoming: Path) -> List[Path]:
    if not incoming.is_dir():
        return []
    found = []
    for path in sorted(incoming.iterdir()):
        if path.name.startswith("."):
            continue
        if path.suffix.lower() != ".png":
            continue
        found.append(path)
    return found


def process_one(
    png_path: Path,
    incoming: Path,
    media: Path,
    today: str,
    incoming_label: str,
) -> Tuple[Optional[ImportRecord], List[str], str]:
    parsed, err = parse_incoming_name(png_path.name)
    if parsed is None:
        return None, [], err

    tokens = parsed.semantic.split("_")
    if len(tokens) >= 3 and tokens[-1] in SIZE_SUFFIXES:
        return (
            None,
            [],
            "variant/part %r collides with the size-suffix scheme (_small/_tiny)"
            % tokens[-1],
        )

    im, warnings, verr = validate_and_prepare(png_path)
    if im is None:
        return None, warnings, verr

    merr = check_margin(im)
    if merr:
        im.close()
        return None, warnings, merr

    sizes, inv_key, unlisted = lookup_sizes(parsed.semantic)
    if unlisted:
        sizes = [default_target(*im.size)]
        warnings.append(
            "unlisted semantic %r: default pad-to-PoT max %d → %d×%d"
            % (parsed.semantic, UNLISTED_MAX, sizes[0][0], sizes[0][1])
        )

    cat_dir = CATEGORY_DIR[parsed.category]
    key_base = KEY_ALIASES.get(parsed.semantic, parsed.semantic)
    record = ImportRecord(
        source_name=png_path.name,
        source_rel="%s/%s" % (incoming_label, png_path.name),
        prompt=read_prompt_sidecar(incoming, png_path, parsed.semantic),
        date=today,
        inventory_key=inv_key,
        unlisted=unlisted,
    )
    for i, (tw, th) in enumerate(sizes):
        canvas = fit_and_pad(im, tw, th)
        suffix = size_suffix(i)
        key = key_base + suffix
        tga_name = key + ".tga"
        rel = "%s/%s" % (cat_dir, tga_name)
        dest = media / cat_dir / tga_name
        write_tga(canvas, dest)
        canvas.close()
        record.outputs.append(OutputAsset(key=key, rel_tga=rel, width=tw, height=th))

    im.close()
    return record, warnings, ""


def run_import(
    incoming: Path,
    media: Path,
    log_path: Optional[Path],
    incoming_label: str = "assets/incoming",
) -> int:
    ensure_pillow()
    incoming.mkdir(parents=True, exist_ok=True)
    media.mkdir(parents=True, exist_ok=True)

    today = datetime.date.today().isoformat()
    pngs = list_incoming_pngs(incoming)
    records: List[ImportRecord] = []
    failed = 0

    if not pngs:
        print("import-assets: no PNGs in %s" % incoming)

    for png in pngs:
        try:
            rec, warnings, err = process_one(png, incoming, media, today, incoming_label)
        except Exception as exc:
            # A corrupt or unreadable master fails this file only; the rest of
            # the batch, the prune, and the manifest still run.
            print("FAIL %s: unreadable master (%s)" % (png.name, exc), file=sys.stderr)
            failed += 1
            continue
        for w in warnings:
            print("WARN %s: %s" % (png.name, w))
        if err:
            print("FAIL %s: %s" % (png.name, err), file=sys.stderr)
            failed += 1
            continue
        assert rec is not None
        records.append(rec)
        bits = ", ".join(
            "%s %d×%d" % (o.rel_tga, o.width, o.height) for o in rec.outputs
        )
        print("OK %s → %s" % (png.name, bits))

    all_outputs = [o for rec in records for o in rec.outputs]
    written = [media / o.rel_tga for o in all_outputs]
    pruned = prune_stale_tgas(media, written)
    for path in pruned:
        try:
            rel = path.relative_to(media)
        except ValueError:
            rel = path
        print("PRUNE stale %s" % rel)

    dest = write_manifest(media, all_outputs)
    print("import-assets: wrote %s (%d entries)" % (dest, len(all_outputs)))

    if log_path is not None:
        write_asset_log(log_path, records, media)
        print("import-assets: wrote %s" % log_path)

    return 1 if failed else 0


# ---------------------------------------------------------------------------
# Self-test (temp dirs only)
# ---------------------------------------------------------------------------

def write_fixture_png(path: Path, size: int = 2048, margin_frac: float = 0.10) -> Path:
    ensure_pillow()
    im = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(im)
    m = int(size * margin_frac)
    draw.ellipse([m, m, size - m - 1, size - m - 1], fill=(201, 165, 74, 255))
    path.parent.mkdir(parents=True, exist_ok=True)
    im.save(str(path), format="PNG")
    im.close()
    return path


def read_tga_header(path: Path) -> Tuple[int, int, int, int]:
    """Return (image_type, width, height, depth) from the TGA header."""
    data = path.read_bytes()
    if len(data) < 18:
        raise ValueError("TGA too short")
    image_type = data[2]
    width = data[12] | (data[13] << 8)
    height = data[14] | (data[15] << 8)
    depth = data[16]
    return image_type, width, height, depth


def lua_manifest_ok(manifest: Path) -> Tuple[bool, str]:
    expr = (
        "dofile([====[%s]====]); assert(type(ChurchOfBeefMediaManifest)=='table')"
        % str(manifest)
    )
    try:
        proc = subprocess.run(
            ["lua", "-e", expr],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    except OSError as exc:
        return False, "lua not available: %s" % exc
    if proc.returncode != 0:
        err = (proc.stderr or proc.stdout).decode("utf-8", "replace").strip()
        return False, err or "lua exit %d" % proc.returncode
    return True, ""


def manifest_has_key(manifest: Path, key: str) -> bool:
    text = manifest.read_text(encoding="utf-8")
    return '["%s"]' % key in text


def _selftest_check(failures: List[str], name: str, cond: bool, detail: str = "") -> None:
    if cond:
        print("PASS: %s" % name)
        return
    msg = "FAIL: %s" % name
    if detail:
        msg += " — %s" % detail
    print(msg)
    failures.append(name)


def run_selftest() -> int:
    ensure_pillow()
    failures: List[str] = []
    tmp = Path(tempfile.mkdtemp(prefix="cob-import-selftest-"))
    incoming = tmp / "incoming"
    media = tmp / "Media"
    log_path = tmp / "ASSET_LOG.md"
    incoming.mkdir()

    repo_manifest = DEFAULT_MEDIA / "manifest.lua"
    repo_log = DEFAULT_LOG
    before_manifest = repo_manifest.exists()
    before_manifest_mtime = repo_manifest.stat().st_mtime if before_manifest else None
    before_log = repo_log.exists()
    before_log_mtime = repo_log.stat().st_mtime if before_log else None

    try:
        fixture = incoming / "COB_seal_fixture.png"
        write_fixture_png(fixture)
        _selftest_check(failures, "fixture PNG written", fixture.is_file())

        code = run_import(incoming, media, log_path, incoming_label="incoming")
        _selftest_check(failures, "import exit 0", code == 0, "exit %s" % code)

        tga = media / "Seal" / "seal_fixture.tga"
        _selftest_check(failures, "TGA exists", tga.is_file(), str(tga))

        if tga.is_file():
            image_type, width, height, depth = read_tga_header(tga)
            _selftest_check(
                failures,
                "TGA uncompressed truecolor (type 2)",
                image_type == 2,
                "image_type=%s" % image_type,
            )
            _selftest_check(
                failures,
                "TGA is 32-bit",
                depth == 32,
                "depth=%s" % depth,
            )
            _selftest_check(
                failures,
                "dimensions 1024×1024 (unlisted default PoT)",
                width == 1024 and height == 1024,
                "%d×%d" % (width, height),
            )
            opened = Image.open(tga)
            opened.load()
            _selftest_check(
                failures,
                "TGA is 32-bit RGBA",
                opened.mode == "RGBA",
                "mode=%s" % opened.mode,
            )
            amin, amax = opened.split()[3].getextrema()
            _selftest_check(
                failures,
                "alpha survived (transparent + opaque)",
                amin < 255 and amax == 255,
                "alpha extrema=%s,%s" % (amin, amax),
            )
            opened.close()

        manifest = media / "manifest.lua"
        ok, lua_err = lua_manifest_ok(manifest)
        _selftest_check(failures, "manifest.lua parses as Lua", ok, lua_err)
        _selftest_check(
            failures,
            "manifest contains seal_fixture",
            manifest.is_file() and manifest_has_key(manifest, "seal_fixture"),
        )

        # Magenta fallback (function-level, still inside temp).
        mag = tmp / "magenta" / "COB_roundel_bull.png"
        mag.parent.mkdir()
        mag_im = Image.new("RGB", (2048, 2048), MAGENTA)
        draw = ImageDraw.Draw(mag_im)
        m = int(2048 * 0.10)
        draw.ellipse([m, m, 2048 - m - 1, 2048 - m - 1], fill=(80, 80, 80))
        mag_im.save(str(mag), format="PNG")
        mag_im.close()
        rec, warns, err = process_one(
            mag, mag.parent, tmp / "magenta-media", "1970-01-01", "incoming"
        )
        mag_ok = rec is not None and not err and rec.outputs[0].width == 64
        _selftest_check(
            failures,
            "magenta #FF00FF chroma-key + listed 64²",
            mag_ok,
            err or "no record",
        )
        if rec:
            for w in warns:
                print("  (magenta) %s" % w)

        # Edge-touch must fail that file.
        bad = tmp / "bad" / "COB_seal_papal.png"
        bad.parent.mkdir()
        bad_im = Image.new("RGBA", (2048, 2048), (0, 0, 0, 0))
        draw = ImageDraw.Draw(bad_im)
        draw.ellipse([0, 200, 1800, 1800], fill=(200, 160, 80, 255))
        bad_im.save(str(bad), format="PNG")
        bad_im.close()
        rec_bad, _, err_bad = process_one(
            bad, bad.parent, tmp / "bad-media", "1970-01-01", "incoming"
        )
        _selftest_check(
            failures,
            "edge-touch file fails validation",
            rec_bad is None and "touches canvas edge" in (err_bad or ""),
            err_bad or "unexpected success",
        )

        # A corrupt master fails its file only; the rest of the batch,
        # the prune, and the manifest still run.
        mixed = tmp / "mixed" / "incoming"
        mixed.mkdir(parents=True)
        (mixed / "COB_seal_aaa.png").write_bytes(b"")
        write_fixture_png(mixed / "COB_seal_papal.png")
        mixed_media = tmp / "mixed-media"
        mixed_code = run_import(mixed, mixed_media, None, incoming_label="incoming")
        _selftest_check(
            failures,
            "corrupt master fails the file, batch continues (exit 1)",
            mixed_code == 1,
            "exit %s" % mixed_code,
        )
        mixed_manifest = mixed_media / "manifest.lua"
        _selftest_check(
            failures,
            "batch after corrupt file wrote the good key only",
            mixed_manifest.is_file()
            and manifest_has_key(mixed_manifest, "seal_papal")
            and not manifest_has_key(mixed_manifest, "seal_aaa"),
        )

        # Theme-key alias + hyphen normalization (function-level, temp only).
        alias_png = tmp / "alias" / "COB_parchment_tome_records.png"
        alias_png.parent.mkdir()
        write_fixture_png(alias_png)
        rec_alias, _, err_alias = process_one(
            alias_png, alias_png.parent, tmp / "alias-media", "1970-01-01", "incoming"
        )
        alias_ok = (
            rec_alias is not None
            and not err_alias
            and rec_alias.outputs[0].key == "tome_records"
            and (rec_alias.outputs[0].width, rec_alias.outputs[0].height) == (1024, 512)
        )
        _selftest_check(
            failures,
            "alias COB_parchment_tome_records → tome_records at 1024×512",
            alias_ok,
            err_alias or "no record",
        )

        hyphen_png = tmp / "hyphen" / "COB_frame_proclamation_corner-TL.png"
        hyphen_png.parent.mkdir()
        write_fixture_png(hyphen_png)
        rec_hyphen, _, err_hyphen = process_one(
            hyphen_png, hyphen_png.parent, tmp / "hyphen-media", "1970-01-01", "incoming"
        )
        hyphen_ok = (
            rec_hyphen is not None
            and not err_hyphen
            and rec_hyphen.outputs[0].key == "frame_proclamation_corner_tl"
            and (rec_hyphen.outputs[0].width, rec_hyphen.outputs[0].height) == (64, 64)
        )
        _selftest_check(
            failures,
            "hyphen part normalizes: corner-TL → frame_proclamation_corner_tl at 64²",
            hyphen_ok,
            err_hyphen or "no record",
        )

        if before_manifest:
            after_mtime = repo_manifest.stat().st_mtime if repo_manifest.exists() else None
            repo_untouched = after_mtime == before_manifest_mtime
        else:
            repo_untouched = not repo_manifest.exists()
        if before_log:
            after_log = repo_log.stat().st_mtime if repo_log.exists() else None
            log_untouched = after_log == before_log_mtime
        else:
            log_untouched = not repo_log.exists()
        _selftest_check(
            failures,
            "selftest did not touch repo Media/manifest.lua",
            repo_untouched,
        )
        _selftest_check(
            failures,
            "selftest did not touch repo ASSET_LOG.md",
            log_untouched,
        )
    finally:
        shutil.rmtree(tmp, ignore_errors=True)

    if failures:
        print("SELFTEST FAIL (%d)" % len(failures))
        return 1
    print("SELFTEST PASS")
    return 0


def parse_args(argv: Optional[Sequence[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Import Church of Beef master PNGs to 32-bit TGA + manifest.lua"
    )
    parser.add_argument(
        "--selftest",
        action="store_true",
        help="run the fixture pipeline in a temp dir (no writes to Media/ or ASSET_LOG.md)",
    )
    parser.add_argument(
        "--incoming",
        type=Path,
        default=None,
        help="override incoming PNG directory (default: assets/incoming/)",
    )
    parser.add_argument(
        "--media",
        type=Path,
        default=None,
        help="override Media root (default: addon/ChurchOfBeef/Media/)",
    )
    parser.add_argument(
        "--log",
        type=Path,
        default=None,
        help="override ASSET_LOG.md path",
    )
    return parser.parse_args(argv)


def main(argv: Optional[Sequence[str]] = None) -> int:
    args = parse_args(argv)
    if args.selftest:
        return run_selftest()
    incoming = (args.incoming or DEFAULT_INCOMING).resolve()
    media = (args.media or DEFAULT_MEDIA).resolve()
    log_path = (args.log or DEFAULT_LOG).resolve()
    return run_import(incoming, media, log_path)


if __name__ == "__main__":
    sys.exit(main())
